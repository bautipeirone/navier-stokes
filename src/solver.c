#include <stddef.h>

#include "solver.h"
#include "indices.h"
#include <immintrin.h>
#include <stdio.h>

#define IX(x,y) (rb_idx((x),(y),(n+2)))
#define SWAP(x0,x) {float * tmp=x0;x0=x;x=tmp;}

typedef enum { NONE = 0, VERTICAL = 1, HORIZONTAL = 2 } boundary;
typedef enum { RED, BLACK } grid_color;

static void add_source(unsigned int n, float * restrict x, const float * restrict s, float dt)
{
    unsigned int size = (n + 2) * (n + 2);
    for (unsigned int i = 0; i < size; i++) {
        x[i] += dt * s[i];
    }
}

static void set_top_bnd(unsigned int n, boundary b, float * restrict p1) {
  const float coef = b == HORIZONTAL ? -1.0f : 1.0f;

  __m256 coef_v = _mm256_set1_ps(coef);

  // TOP BLK BOUND
  for (unsigned int i = 1; i <= n/2; i += 8) {
    int ridx = rb_idx(0, i, n+2);
    int bidx = rb_idx(1, i, n+2);
    printf("i: %d, ridx: %d, bidx: %d\n", i, ridx, bidx);
    if (1)
      continue;

    __m256i ridx_v = _mm256_set_epi32(ridx + 7, ridx + 6, ridx + 5, ridx + 4, ridx + 3, ridx + 2, ridx + 1, ridx);
    __m256i bidx_v = _mm256_set_epi32(bidx + 7, bidx + 6, bidx + 5, bidx + 4, bidx + 3, bidx + 2, bidx + 1, bidx);
    
    // Gather 8 float values from ap1 using those indices
    __m256 src = _mm256_i32gather_ps(p1, bidx_v, sizeof(float));
    
    // Multiply by coef
    __m256 result = _mm256_mul_ps(coef_v, src);
    // float tmp[4];
    _mm256_storeu_ps(p1 + ridx, result);

    // for (int j = 0; j < 4; ++j)
    //   // p1[((int*)((void*)lidx_v))[j]] = tmp[j];
    //   p1[ridx_v[j]] = tmp[j];
    // Store result to ap2[lidx[i..i+7]] manually (scatter)
    // _mm256_i32scatter_ps(p1, ridx_v, result, sizeof(float));
  }

  // TOP RED BOUND
  for (unsigned int i = 1; i <= n/2; i += 8) {
    int bidx = rb_idx(0, i, n+2);
    int ridx = rb_idx(1, i, n+2);
    
    __m256i ridx_v = _mm256_set_epi32(ridx + 7, ridx + 6, ridx + 5, ridx + 4, ridx + 3, ridx + 2, ridx + 1, ridx);
    __m256i bidx_v = _mm256_set_epi32(bidx + 7, bidx + 6, bidx + 5, bidx + 4, bidx + 3, bidx + 2, bidx + 1, bidx);
    
    // Gather 8 float values from ap1 using those indices
    __m256 src = _mm256_i32gather_ps(p1, ridx_v, sizeof(float));
    
    // Multiply by coef
    __m256 result = _mm256_mul_ps(coef_v, src);
    _mm256_storeu_ps(p1 + bidx, result);

    // for (int j = 0; j < 8; ++j)
    //   p1[((int*)((void*)lidx_v))[j]] = tmp[j];
    // Store result to ap2[lidx[i..i+7]] manually (scatter)
    // _mm256_i32scatter_ps(p1, bidx_v, result, sizeof(float));
  }
}

static void set_bot_bnd(unsigned int n, boundary b, float * restrict p1) {
  const float coef = b == HORIZONTAL ? -1.0f : 1.0f;

  __m256 coef_v = _mm256_set1_ps(coef);

  // TOP RED BOUND
  for (unsigned int i = 1; i <= n/2; i += 8) {
    int ridx = rb_idx(n+1, i, n+2);
    int bidx = rb_idx(n,  i,  n+2);
    
    __m256i ridx_v = _mm256_set_epi32(ridx + 7, ridx + 6, ridx + 5, ridx + 4, ridx + 3, ridx + 2, ridx + 1, ridx);
    __m256i bidx_v = _mm256_set_epi32(bidx + 7, bidx + 6, bidx + 5, bidx + 4, bidx + 3, bidx + 2, bidx + 1, bidx);
    
    // Gather 8 float values from ap1 using those indices
    __m256 src = _mm256_i32gather_ps(p1, bidx_v, sizeof(float));
    
    // Multiply by coef
    __m256 result = _mm256_mul_ps(coef_v, src);
    // float tmp[4];
    _mm256_store_ps(p1 + ridx, result);

    // for (int j = 0; j < 4; ++j)
    //   // p1[((int*)((void*)lidx_v))[j]] = tmp[j];
    //   p1[ridx_v[j]] = tmp[j];
    // Store result to ap2[lidx[i..i+7]] manually (scatter)
    // _mm256_i32scatter_ps(p1, ridx_v, result, sizeof(float));
  }

  // TOP BLK BOUND
  for (unsigned int i = 1; i <= n/2; i += 8) {
    int bidx = rb_idx(n+1, i, n+2);
    int ridx = rb_idx(n,  i,  n+2);
    
    __m256i ridx_v = _mm256_set_epi32(ridx + 7, ridx + 6, ridx + 5, ridx + 4, ridx + 3, ridx + 2, ridx + 1, ridx);
    __m256i bidx_v = _mm256_set_epi32(bidx + 7, bidx + 6, bidx + 5, bidx + 4, bidx + 3, bidx + 2, bidx + 1, bidx);
    
    // Gather 8 float values from ap1 using those indices
    __m256 src = _mm256_i32gather_ps(p1, ridx_v, sizeof(float));
    
    // Multiply by coef
    __m256 result = _mm256_mul_ps(coef_v, src);
    _mm256_store_ps(p1 + bidx, result);

    // for (int j = 0; j < 8; ++j)
    //   p1[((int*)((void*)lidx_v))[j]] = tmp[j];
    // Store result to ap2[lidx[i..i+7]] manually (scatter)
    // _mm256_i32scatter_ps(p1, bidx_v, result, sizeof(float));
  }
}

static void set_v_bnd(unsigned int n, boundary b, float * x) {
  const float coef = b == VERTICAL ? -1.0f : 1.0f;
  for (unsigned int i = 1; i <= n; i++) {
    x[IX(0, i)]     = coef * x[IX(1, i)];
    x[IX(n + 1, i)] = coef * x[IX(n, i)];
  }
}

// static void set_bnd(unsigned int n, boundary b, float * x)
// {
//     // set_top_bnd(n, b, x);
//     // set_bot_bnd(n, b, x);
//     // set_v_bnd(n, b, x);
    
//     x[IX(0, 0)]         = 0.5f * (x[IX(1, 0)]     + x[IX(0, 1)]);
//     x[IX(0, n + 1)]     = 0.5f * (x[IX(1, n + 1)] + x[IX(0, n)]);
//     x[IX(n + 1, 0)]     = 0.5f * (x[IX(n, 0)]     + x[IX(n + 1, 1)]);
//     x[IX(n + 1, n + 1)] = 0.5f * (x[IX(n, n + 1)] + x[IX(n + 1, n)]);
// }

static void set_bnd(unsigned int n, boundary b, float* x)
{
    float vcoef = -1 * (((b == VERTICAL) * 2) - 1);
    float hcoef = -1 * (((b == HORIZONTAL) * 2) - 1);
    for (unsigned int i = 1; i <= n; i++) {
        x[IX(0, i)] = vcoef * x[IX(1, i)];
        x[IX(n + 1, i)] = vcoef * x[IX(n, i)];
        x[IX(i, 0)] = hcoef * x[IX(i, 1)];
        x[IX(i, n + 1)] = hcoef * x[IX(i, n)];
    }
    x[IX(0, 0)] = 0.5f * (x[IX(1, 0)] + x[IX(0, 1)]);
    x[IX(n + 1, 0)] = 0.5f * (x[IX(n, 0)] + x[IX(n + 1, 1)]);
    x[IX(0, n + 1)] = 0.5f * (x[IX(1, n + 1)] + x[IX(0, n)]);
    x[IX(n + 1, n + 1)] = 0.5f * (x[IX(n, n + 1)] + x[IX(n + 1, n)]);
}


static void lin_solve_rb_step(grid_color color,
                              unsigned int n,
                              float a,
                              float c,
                              const float * restrict same0,
                              const float * restrict neigh,
                              float * restrict same)
{
    // color = RED
    // same0 = red0, same = red, neigh = blk
    int shift = color == RED ? 1 : -1;
    unsigned int start = color == RED ? 0 : 1;

    unsigned int width = (n + 2) / 2;

    for (unsigned int y = 1; y <= n; ++y, shift = -shift, start = 1 - start) {
        for (unsigned int x = start; x < width - (1 - start); ++x) {
            int index = idx(x, y, width);
            same[index] = (same0[index] + a * (neigh[index - width] +
                                               neigh[index] +
                                               neigh[index + shift] +
                                               neigh[index + width])) / c;
        }
    }
}

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

static void diffuse(unsigned int n, boundary b, float * x, const float * x0, float diff, float dt)
{
    float a = dt * diff * n * n;
    lin_solve(n, b, x, x0, a, 1 + 4 * a);
}

// static void advect(unsigned int n, boundary b, float * d, const float * d0, const float * u, const float * v, float dt)
// {
//     int i0, i1, j0, j1;
//     float x, y, s0, t0, s1, t1;

//     float dt0 = dt * n;
//     for (unsigned int i = 1; i <= n; i++) {
//         for (unsigned int j = 1; j <= n; j++) {
//             x = i - dt0 * u[IX(i, j)];
//             y = j - dt0 * v[IX(i, j)];
//             if (x < 0.5f) {
//                 x = 0.5f;
//             } else if (x > n + 0.5f) {
//                 x = n + 0.5f;
//             }
//             i0 = (int) x;
//             i1 = i0 + 1;
//             if (y < 0.5f) {
//                 y = 0.5f;
//             } else if (y > n + 0.5f) {
//                 y = n + 0.5f;
//             }
//             j0 = (int) y;
//             j1 = j0 + 1;
//             s1 = x - i0;
//             s0 = 1 - s1;
//             t1 = y - j0;
//             t0 = 1 - t1;
//             d[IX(i, j)] = s0 * (t0 * d0[IX(i0, j0)] + t1 * d0[IX(i0, j1)]) +
//                           s1 * (t0 * d0[IX(i1, j0)] + t1 * d0[IX(i1, j1)]);
//         }
//     }
//     set_bnd(n, b, d);
// }

static inline max(float x, float y) {
  return x < y ? y : x;
}

static inline min(float x, float y) {
  return x < y ? x : y;
}

static void advect(unsigned int n, boundary b, float* restrict d, float* d0, const float* u, const float* v, float dt)
{
    int i0, i1, j0, j1;
    float x, y, s0, t0, s1, t1;

    float dt0 = dt * n;
    for (unsigned int j = 1; j <= n; j++) {
          for (unsigned int i = 1; i <= n; i++) {
            x = i - dt0 * u[IX(i, j)];
            y = j - dt0 * v[IX(i, j)];
            x = max(x, 0.5f);
            x = min(x, n + 0.5f);
            // if (x < 0.5f) {
            //     x = 0.5f;
            // } else if (x > n + 0.5f) {
            //     x = n + 0.5f;
            // }
            i0 = (int)x;
            i1 = i0 + 1;
            // if (y < 0.5f) {
            //     y = 0.5f;
            // } else if (y > n + 0.5f) {
            //     y = n + 0.5f;
            // }
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
    set_bnd(n, b, d);
}

static void project(unsigned int n, float *u, float *v, float *p, float *div)
{
    for (unsigned int i = 1; i <= n; i++) {
        for (unsigned int j = 1; j <= n; j++) {
            div[IX(i, j)] = -0.5f * (u[IX(i + 1, j)] - u[IX(i - 1, j)] +
                                     v[IX(i, j + 1)] - v[IX(i, j - 1)]) / n;
            p[IX(i, j)] = 0;
        }
    }
    set_bnd(n, NONE, div);
    set_bnd(n, NONE, p);

    lin_solve(n, NONE, p, div, 1, 4);

    for (unsigned int i = 1; i <= n; i++) {
        for (unsigned int j = 1; j <= n; j++) {
            u[IX(i, j)] -= 0.5f * n * (p[IX(i + 1, j)] - p[IX(i - 1, j)]);
            v[IX(i, j)] -= 0.5f * n * (p[IX(i, j + 1)] - p[IX(i, j - 1)]);
        }
    }
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
