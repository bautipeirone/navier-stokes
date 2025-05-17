#include <immintrin.h>

typedef boundary;

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
