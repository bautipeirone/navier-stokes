#include <stddef.h>
#include <cuda_runtime.h>

#include "solver.h"
#include "indices.h"
#include <stdio.h>

#define IX(x,y) (rb_idx((x),(y),(n+2)))
#define SWAP(x0,x) {float * tmp=x0;x0=x;x=tmp;}

int threadsPerBlock = 1024;


typedef enum { NONE = 0, VERTICAL = 1, HORIZONTAL = 2 } boundary;
typedef enum { RED, BLACK } grid_color;

__global__ void add_source_kernel(unsigned int n, float *x, const float *s, float dt)
{
  unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
  unsigned int size = (n + 2) * (n + 2);
  if (i < size) {
    x[i] += dt * s[i];
  }
}

static void add_source(unsigned int n, float *x, const float *s, float dt)
{
  unsigned int size = (n + 2) * (n + 2);
  int numBlocks = (size + threadsPerBlock - 1) / threadsPerBlock;
  
  // Check if the number of blocks exceeds the maximum allowed
  int maxBlocks = 65535; // Maximum number of blocks (adjust if needed)
  while (numBlocks > maxBlocks) {
    add_source_kernel<<<maxBlocks, threadsPerBlock>>>(n, x, s, dt);
    x += maxBlocks * threadsPerBlock;
    s += maxBlocks * threadsPerBlock;
    numBlocks -= maxBlocks;
  }
  add_source_kernel<<<numBlocks, threadsPerBlock>>>(n, x, s, dt);
}

__global__ void set_bnd_kernel(unsigned int n, boundary b, float* x)
{
  unsigned int i = blockIdx.x * blockDim.x + threadIdx.x + 1;
  // int 
  if (i < n + 1) {
    x[IX(0, i)]     = (b == VERTICAL)   ? -x[IX(1, i)] : x[IX(1, i)];
    x[IX(n + 1, i)] = (b == VERTICAL)   ? -x[IX(n, i)] : x[IX(n, i)];
    x[IX(i, 0)]     = (b == HORIZONTAL) ? -x[IX(i, 1)] : x[IX(i, 1)];
    x[IX(i, n + 1)] = (b == HORIZONTAL) ? -x[IX(i, n)] : x[IX(i, n)];
  }
}

static void set_bnd(unsigned int n, boundary b, float* x)
{
    int numBlocks = (n + threadsPerBlock - 1) / threadsPerBlock;
    set_bnd_kernel<<<numBlocks, threadsPerBlock>>>(n, b, x);
    x[IX(0, 0)] = 0.5f * (x[IX(1, 0)] + x[IX(0, 1)]);
    x[IX(n + 1, 0)] = 0.5f * (x[IX(n, 0)] + x[IX(n + 1, 1)]);
    x[IX(0, n + 1)] = 0.5f * (x[IX(1, n + 1)] + x[IX(0, n)]);
    x[IX(n + 1, n + 1)] = 0.5f * (x[IX(n, n + 1)] + x[IX(n + 1, n)]);
}

__global__ void lin_solve_rb_step(grid_color color,
  unsigned int n,
  float a,
  float c,
  const float * same0,
  const float * neigh,
  float * same)
  {
    unsigned int width = (n + 2) / 2;
    unsigned int block_size = 1024 / n;

    unsigned y = blockIdx.y;
    unsigned x = blockIdx.x * blockDim.x + threadIdx.x;
    
    int shift = color == RED ? 1 : -1;
    unsigned int start = color == RED ? 0 : 1;
    
    // for (unsigned int i = 0; i < ((n+2) / NUM_BLOCKS) ; i++) {
    // const float*  same0_i = same0 + (i * block_size);
    // const float*  neigh_i = neigh + (i * block_size);
    // float*  same_i = same + (i * block_size);             

    int index = idx(x+start,y+1,width);
    same[index] = (same0[index] + a * (neigh[index - width] +
    neigh[index] +
    neigh[index + (y % 2 == 0 ? shift : -shift)] +
    neigh[index + width])) / c;
    // }
}

void lin_solve(unsigned int n, boundary b,
                      float * x,
                      const float * x0,
                      float a, float c)
{
    unsigned int color_size = (n + 2) * ((n + 2) / 2);
    const float * red0 = x0;
    const float * blk0 = x0 + color_size;
    float * red = x;
    float * blk = x + color_size;

    unsigned int blocksPerRow = (((n / 2) + 1023) / 1024);
    dim3 grid(blocksPerRow, n);
    dim3 block(1024, 1);
    for (unsigned int k = 0; k < 20; ++k) {
        // cudaMemcpyToSymbol(ro_mem, red0, threadsPerBlock * sizeof(float));
        lin_solve_rb_step<<<grid, block>>>(RED, n, a, c, red0, blk, red);
        // cudaMemcpyToSymbol(ro_mem, blk0, threadsPerBlock * sizeof(float));
        lin_solve_rb_step<<<grid, block>>>(BLACK, n, a, c, blk0, red, blk);
        set_bnd(n, b, x);
    }
  }

void diffuse(unsigned int n, boundary b, float * x, const float * x0, float diff, float dt)
{
    float a = dt * diff * n * n;
    lin_solve(n, b, x, x0, a, 1 + 4 * a);
}

//float max(float x, float y) {
// return x < y ? y : x;
//}

//float min(float x, float y) {
//  return x < y ? x : y;
//}


__global__ void advect_kernel(unsigned int n, boundary b, float*  d, float* d0, const float* u, const float* v, float dt) {
  float dt0 = dt * n;
  unsigned int i = blockDim.y * blockIdx.y + threadIdx.y + 1;
  unsigned int j = blockDim.x * blockIdx.x + threadIdx.x + 1;
  if (i < n+1 && j < n+1) {
    int i0, i1, j0, j1;
    float x, y, s0, t0, s1, t1;
    x = i - dt0 * u[IX(i, j)];
    y = j - dt0 * v[IX(i, j)];
    x = max(x, 0.5f);
    x = min(x, n + 0.5f);
    i0 = (int)x;
    i1 = i0 + 1;
    y = max(y, 0.5f);
    y = min(y, n + 0.5f);
    j0 = (int)y;
    j1 = j0 + 1;
    s1 = x - i0;
    s0 = 1 - s1;
    t1 = y - j0;
    t0 = 1 - t1;
    d[IX(i, j)] = s0 * (t0 * d0[IX(i0, j0)] + t1 * d0[IX(i0, j1)]) + s1 * (t0 * d0[IX(i1, j0)] + t1 * d0[IX(i1, j1)]);
  }
}

void advect(unsigned int n, boundary b, float*  d, float* d0, const float* u, const float* v, float dt)
{
  unsigned int numBlocks = (n + 31) / 32;
  dim3 block(32, 32);
  dim3 grid(numBlocks,numBlocks);
  advect_kernel<<<grid, block>>>(n, b, d, d0, u, v, dt);
  set_bnd(n, b, d);
}

__global__ void project_density_kernel(unsigned int n, float *u, float *v, float *p, float *div) {
  unsigned int i = blockDim.y * blockIdx.y + threadIdx.y + 1;
  unsigned int j = blockDim.x * blockIdx.x + threadIdx.x + 1;
  if (i < n+1 && j < n+1) {
    div[IX(i, j)] = -0.5f * (u[IX(i + 1, j)] - u[IX(i - 1, j)] +
                            v[IX(i, j + 1)] - v[IX(i, j - 1)]) / n;
    p[IX(i, j)] = 0;
  }
}

__global__ void project_vel_kernel(unsigned int n, float *u, float *v, float *p) {
  unsigned int i = blockDim.y * blockIdx.y + threadIdx.y + 1;
  unsigned int j = blockDim.x * blockIdx.x + threadIdx.x + 1;
  if (i < n+1 && j < n+1) {
    u[IX(i, j)] -= 0.5f * n * (p[IX(i + 1, j)] - p[IX(i - 1, j)]);
    v[IX(i, j)] -= 0.5f * n * (p[IX(i, j + 1)] - p[IX(i, j - 1)]);
  }
}

static void project(unsigned int n, float * u, float *  v, float * p, float * div)
{
        // printf("Thread %d in range [%d,%d), total: %d\n", omp_get_thread_num(), start+1, end+1, n);
    unsigned int numBlocks = (n + 31) / 32;
    dim3 block(32, 32);
    dim3 grid(numBlocks,numBlocks);
    project_density_kernel<<<grid,block>>>(n, u, v, p, div);

    set_bnd(n, NONE, div);
    set_bnd(n, NONE, p);

    lin_solve(n, NONE, p, div, 1, 4);

    project_vel_kernel<<<grid, block>>>(n, u, v, p);
    set_bnd(n, VERTICAL, u);
    set_bnd(n, HORIZONTAL, v);
}

__host__ void dens_step(unsigned int n, float *x, float *x0, float *u, float *v, float diff, float dt)
{
    add_source(n, x, x0, dt);
    SWAP(x0, x);
    diffuse(n, NONE, x, x0, diff, dt);
    SWAP(x0, x);
    advect(n, NONE, x, x0, u, v, dt);
}

__host__ void vel_step(unsigned int n, float *u, float *v, float *u0, float *v0, float visc, float dt)
{
    add_source(n, u, u0, dt);
    add_source(n, v, v0, dt);
    SWAP(u0, u);
    diffuse(n, VERTICAL, u, u0, visc, dt);
    SWAP(v0, v);
    diffuse(n, HORIZONTAL, v, v0, visc, dt);
    project(n, u, v, u0, v0);
    SWAP(u0, u);
    SWAP(v0, v);
    advect(n, VERTICAL, u, u0, u0, v0, dt);
    advect(n, HORIZONTAL, v, v0, u0, v0, dt);
    project(n, u, v, u0, v0);
}
