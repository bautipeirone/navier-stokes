#include <stddef.h>

#include "solver.h"
#include "indices.h"
#include <immintrin.h>
#include <omp.h>
#include <stdio.h>

#define IX(x,y) (rb_idx((x),(y),(n+2)))
#define SWAP(x0,x) {float * tmp=x0;x0=x;x=tmp;}


#define PRINT_THREAD printf("threadId: %d\n", omp_get_thread_num())
#define OMP_PARALLEL_RANGE(start, end, total)                  \
{                                                              \
  _Pragma("omp parallel")                                      \
  {                                                            \
    unsigned start, end;                                       \
    int _tid = omp_get_thread_num();                           \
    int _nthr = omp_get_num_threads();                         \
    int _chunk = ((total) + _nthr - 1) / _nthr;                \
    start = _tid * _chunk;                                     \
    end = start + _chunk;                                      \
    if (end > (total)) end = (total);                          \
    
#define OMP_PARALLEL_RANGE_END }}

#ifndef NUM_BLOCKS
  #define NUM_BLOCKS 12
#endif

#ifdef OMP
  #define PARALLEL_FOR _Pragma("omp parallel for simd")
#else
#define PARALLEL_FOR
#endif
#ifdef AUTOVEC
#if defined(__INTEL_LLVM_COMPILER) // Compilando con icx
#define VECTORIZE_LOOP \
  _Pragma("ivdep") \
  _Pragma("vector always")
#elif defined(__clang__) // Compilando con clang
  #define VECTORIZE_LOOP _Pragma("clang loop vectorize(assume_safety)")
#elif defined(__GNUC__) // Compilando con gcc
// Code for GCC (and sometimes icx if it pretends to be GCC)
  #define VECTORIZE_LOOP _Pragma("GCC ivdep")
#endif
#else
  #define VECTORIZE_LOOP
#endif

#define __CUDACC__
#ifdef __CUDACC__
int threadsPerBlock = 1024;
__constant__ float ro_mem[threadsPerBlock];
#endif

typedef enum { NONE = 0, VERTICAL = 1, HORIZONTAL = 2 } boundary;
typedef enum { RED, BLACK } grid_color;

#ifdef __CUDACC__
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

#else
static void add_source(unsigned int n, float * restrict x, const float * restrict s, float dt)
{
  unsigned int size = (n + 2) * (n + 2);
  for (unsigned i = 0; i < size; i++) {
    x[i] += dt * s[i];
  }
}
#endif

#ifdef __CUDACC__

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
#else
static void set_bnd(unsigned int n, boundary b, float* x)
{
  for (unsigned int i = 0+1; i < n+1; i++) {
      x[IX(0, i)]     = (b == VERTICAL)   ? -x[IX(1, i)] : x[IX(1, i)];
      x[IX(n + 1, i)] = (b == VERTICAL)   ? -x[IX(n, i)] : x[IX(n, i)];
      x[IX(i, 0)]     = (b == HORIZONTAL) ? -x[IX(i, 1)] : x[IX(i, 1)];
      x[IX(i, n + 1)] = (b == HORIZONTAL) ? -x[IX(i, n)] : x[IX(i, n)];
  }
  // OMP_PARALLEL_RANGE_END
    x[IX(0, 0)] = 0.5f * (x[IX(1, 0)] + x[IX(0, 1)]);
    x[IX(n + 1, 0)] = 0.5f * (x[IX(n, 0)] + x[IX(n + 1, 1)]);
    x[IX(0, n + 1)] = 0.5f * (x[IX(1, n + 1)] + x[IX(0, n)]);
    x[IX(n + 1, n + 1)] = 0.5f * (x[IX(n, n + 1)] + x[IX(n + 1, n)]);
}
#endif

static void lin_solve_rb_step(grid_color color,
  unsigned int n,
  float a,
  float c,
  const float * restrict same0,
  const float * restrict neigh,
  float * restrict same)
  {
#ifndef INTRINISCS
    unsigned int width = (n + 2) / 2;
    unsigned int block_size = 1024 / n;

    unsigned y = blockIdx.y;
    unsigned x = blockIdx.x * blockDim.x + threadIdx.x;
    
    int shift = color == RED ? 1 : -1;
    unsigned int start = color == RED ? 0 : 1;
    
    // for (unsigned int i = 0; i < ((n+2) / NUM_BLOCKS) ; i++) {
    // const float* restrict same0_i = same0 + (i * block_size);
    // const float* restrict neigh_i = neigh + (i * block_size);
    // float* restrict same_i = same + (i * block_size);             

    int index = idx(x+start,y+1,width);
    same[index] = (same0[index] + a * (neigh[index - width] +
    neigh[index] +
    neigh[index + (y % 2 == 0 ? shift : -shift)] +
    neigh[index + width])) / c;
    // }
#else
    int shift = color == RED ? 1 : -1;
    unsigned int start = color == RED ? 0 : 1;
    unsigned int width = (n + 2) / 2;

    float neigh_res[8] = {};
    for (unsigned int y = 1; y <= n; ++y) {
      unsigned int limit = width - (1 -start);  
      start = 1 - start;
      shift = -shift;
      unsigned int x = start;
      for (; x + 8 < limit; x += 8) {
          for (; x < width - (1 - start); ++x) {
            int index = idx(x, y, width);
            same[index] = (same0[index] + a * (neigh[index - width] +
              neigh[index] +
                                neigh[index + shift] +
                                neigh[index + width])) / c;
          }
          int index = idx(x, y, width); 
          for (unsigned int i = 0; i < 8; i++ ) 
          {   
              __m128i idx_vec = _mm_set_epi32(index+i, index+i+width, index+i-width, index+i+shift);
              __m128 values = _mm_i32gather_ps(neigh, idx_vec, 4);
              values = _mm_hadd_ps(values, values);
              values = _mm_hadd_ps(values, values);
              neigh_res[i] = _mm_cvtss_f32(values);
          }
          int indices_N[8], indices_E[8], indices_W[8], indices_S[8];
          for (int i = 0; i < 8; ++i) {
            int idx_i = index + i;
            indices_N[i] = idx_i - width;
            indices_E[i] = idx_i + shift;
            indices_W[i] = idx_i;
            indices_S[i] = idx_i + width;
          }

          __m256 neigh_N = _mm256_i32gather_ps(neigh, _mm256_loadu_si256((__m256i*)indices_N), 4);
          __m256 neigh_E = _mm256_i32gather_ps(neigh, _mm256_loadu_si256((__m256i*)indices_E), 4);
          __m256 neigh_W = _mm256_i32gather_ps(neigh, _mm256_loadu_si256((__m256i*)indices_W), 4);
          __m256 neigh_S = _mm256_i32gather_ps(neigh, _mm256_loadu_si256((__m256i*)indices_S), 4);

          __m256 neigh_res = _mm256_add_ps(_mm256_add_ps(neigh_N, neigh_E),_mm256_add_ps(neigh_W, neigh_S));
          __m256 same0s = _mm256_loadu_ps(same0 + index);
          __m256 as = _mm256_set1_ps(a);
          __m256 partial_res = _mm256_fmadd_ps(as, neigh_res, same0s);

          __m256 cs = _mm256_set1_ps(1.0f / c);
          __m256 final_res = _mm256_mul_ps(partial_res, cs);
          _mm256_storeu_ps(same+index, final_res);
        }
    }
#endif
}

#ifdef __CUDACC__
__global__ void lin_solve(unsigned int n, boundary b,
                      float * restrict x,
                      const float * restrict x0,
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
    unsigned y = blockIdx.y;
    unsigned x = blockIdx.x * blockDim.x + threadIdx.x;
    for (unsigned int k = 0; k < 20; ++k) {
        // cudaMemcpyToSymbol(ro_mem, red0, threadsPerBlock * sizeof(float));
        lin_solve_rb_step<<<grid, block>>>(RED, n, a, c, red0, blk, red);
        // cudaMemcpyToSymbol(ro_mem, blk0, threadsPerBlock * sizeof(float));
        lin_solve_rb_step<<<grid, block>>>(BLACK, n, a, c, blk0, red, blk);
        set_bnd(n, b, x);
    }
  }
#else
static void lin_solve(unsigned int n, boundary b,
                      float * restrict x,
                      const float * restrict x0,
                      float a, float c)
{
    unsigned int color_size = (n + 2) * ((n + 2) / 2);
    const float * red0 = x0;
    const float * blk0 = x0 + color_size;
    float * red = x;
    float * blk = x + color_size;

    for (unsigned int k = 0; k < 20; ++k) {
        lin_solve_rb_step(RED,   n, a, c, red0, blk, red);
        lin_solve_rb_step(BLACK, n, a, c, blk0, red, blk);
        set_bnd(n, b, x);
    }
}
#endif

static void diffuse(unsigned int n, boundary b, float * x, const float * x0, float diff, float dt)
{
    float a = dt * diff * n * n;
    lin_solve(n, b, x, x0, a, 1 + 4 * a);
}


static inline float max(float x, float y) {
  return x < y ? y : x;
}

static inline float min(float x, float y) {
  return x < y ? x : y;
}

static void advect(unsigned int n, boundary b, float* restrict d, float* d0, const float* u, const float* v, float dt)
{
    float dt0 = dt * n;
    // PARALLEL_FOR
    OMP_PARALLEL_RANGE(start, end, n)
        for (unsigned int j = start+1; j < end+1; j++) {
            // PARALLEL_FOR
            int i0, i1, j0, j1;
            float x, y, s0, t0, s1, t1;
            VECTORIZE_LOOP
            for (unsigned int i = 1; i <= n; i++) {
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
    OMP_PARALLEL_RANGE_END
    set_bnd(n, b, d);
}

static void project(unsigned int n, float * restrict u, float * restrict v, float * restrict p, float * restrict div)
{
    OMP_PARALLEL_RANGE(start1, end1, n)
        // printf("Thread %d in range [%d,%d), total: %d\n", omp_get_thread_num(), start+1, end+1, n);
        for (unsigned i = start1+1; i < end1+1; i++) {
            // printf("Thread %d, i: %d\n", omp_get_thread_num(), i);
            // fflush(stdout);
            VECTORIZE_LOOP
            for (unsigned int j = 1; j < n+1; j++) {
                div[IX(i, j)] = -0.5f * (u[IX(i + 1, j)] - u[IX(i - 1, j)] +
                                        v[IX(i, j + 1)] - v[IX(i, j - 1)]) / n;
                p[IX(i, j)] = 0;
            }
        }
    OMP_PARALLEL_RANGE_END
    set_bnd(n, NONE, div);
    set_bnd(n, NONE, p);

    lin_solve(n, NONE, p, div, 1, 4);

    // PARALLEL_FOR
    OMP_PARALLEL_RANGE(start, end, n)
        for (unsigned int i = start+1; i < end+1; i++) {
            VECTORIZE_LOOP
            for (unsigned int j = 1; j <= n; j++) {
                u[IX(i, j)] -= 0.5f * n * (p[IX(i + 1, j)] - p[IX(i - 1, j)]);
                v[IX(i, j)] -= 0.5f * n * (p[IX(i, j + 1)] - p[IX(i, j - 1)]);
            }
        }
    OMP_PARALLEL_RANGE_END
    set_bnd(n, VERTICAL, u);
    set_bnd(n, HORIZONTAL, v);
}

void dens_step(unsigned int n, float *x, float *x0, float *u, float *v, float diff, float dt)
{
    add_source(n, x, x0, dt);
    SWAP(x0, x);
    diffuse(n, NONE, x, x0, diff, dt);
    SWAP(x0, x);
    advect(n, NONE, x, x0, u, v, dt);
}

void vel_step(unsigned int n, float *u, float *v, float *u0, float *v0, float visc, float dt)
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
