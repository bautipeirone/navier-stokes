/*
  ======================================================================
   demo.c --- protoype to show off the simple solver
  ----------------------------------------------------------------------
   Author : Jos Stam (jstam@aw.sgi.com)
   Creation Date : Jan 9 2003

   Description:

    This code is a simple prototype that demonstrates how to use the
    code provided in  GDC2003 paper entitles "Real-Time Fluid Dynamics
    for Games". This code uses OpenGL and GLUT for graphics and interface

  =======================================================================
*/

#include <sys/time.h>
#include "wtime.h"
#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <cuda_runtime.h>
#include "indices.h"
#include "solver.h"
#include "wtime.h"
#include <GL/glut.h>

/* macros */

#define IX(x,y) (rb_idx((x),(y),(N+2)))

#ifndef TPB
#define TPB 1024
#endif

#ifndef SIDE
#define SIDE 32
#endif

#ifndef SIZE
#define SIZE 1024
#endif

/* global variables */

static int N;
static float dt, diff, visc;
static float* h_force, *h_source;
float* d_force, *d_source;

static float * h_u, * h_v, * h_u_prev, * h_v_prev;
static float * h_dens, * h_dens_prev;

float * d_u, * d_v, * d_u_prev, * d_v_prev;
float * d_dens, * d_dens_prev;
static int dvel;

static int h_win_id;
static int* h_win_x, *h_win_y;
static int* h_mouse_down;
static int* h_omx, *h_omy, *h_mx, *h_my;

int* d_win_x, *d_win_y;
int* d_mouse_down;
int* d_omx, *d_omy, *d_mx, *d_my;


/*
  ----------------------------------------------------------------------
   free/clear/allocate simulation data
  ----------------------------------------------------------------------
*/


static void free_data ( void )
{
        if ( h_u ) free ( h_u );
        if ( h_v ) free ( h_v );
        if ( h_u_prev ) free ( h_u_prev );
        if ( h_v_prev ) free ( h_v_prev );
        if ( h_dens ) free ( h_dens );
        if ( h_win_x ) free ( h_win_x );
        if ( h_win_y ) free ( h_win_y );
        if ( h_mouse_down ) free ( h_mouse_down );
        if ( h_omx ) free ( h_omx );
        if ( h_omy ) free ( h_omy );
        if ( h_mx ) free ( h_mx );
        if ( h_my ) free ( h_my );
        if ( h_force ) free ( h_force );
        if ( h_source ) free ( h_source );
  if ( d_u ) cudaFree ( d_u );
        if ( d_v ) cudaFree ( d_v );
        if ( d_u_prev ) cudaFree ( d_u_prev );
        if ( d_v_prev ) cudaFree ( d_v_prev );
        if ( d_dens ) cudaFree ( d_dens );
        if ( d_dens_prev ) cudaFree ( d_dens_prev );
        if ( d_win_x ) cudaFree ( d_win_x );
        if ( d_win_y ) cudaFree ( d_win_y );
        if ( d_mouse_down ) cudaFree ( d_mouse_down );
        if ( d_omx ) cudaFree ( d_omx );
        if ( d_omy ) cudaFree ( d_omy );
        if ( d_mx ) cudaFree ( d_mx );
        if ( d_my ) cudaFree ( d_my );
        if ( d_force ) cudaFree ( d_force );
        if ( d_source ) cudaFree ( d_source );
}

static void clear_data ( void )
{
        int i, size=(N+2)*(N+2);

        for ( i=0 ; i<size ; i++ ) {
                h_u[i] = h_v[i] = h_u_prev[i] = h_v_prev[i] = h_dens[i] = h_dens_prev[i] = 0.0f;
        }
}
static int allocate_data ( void )
{
        int size = (N+2)*(N+2);

        // h_u                  = (float *) malloc( size*sizeof(float) );
        // h_v                  = (float *) malloc( size*sizeof(float) );
        // h_u_prev             = (float *) malloc( size*sizeof(float) );
        // h_v_prev             = (float *) malloc( size*sizeof(float) );
        // h_dens               = (float *) malloc( size*sizeof(float) );
        // h_dens_prev  = (float *) malloc( size*sizeof(float) );

  h_u = (float*) malloc(size*sizeof(float));
  h_v = (float*) malloc(size*sizeof(float));
  h_u_prev = (float*) malloc(size*sizeof(float));
  h_v_prev = (float*) malloc(size*sizeof(float));
  h_dens = (float*) malloc(size*sizeof(float));
  h_dens_prev = (float*) malloc(size*sizeof(float));
  h_win_x = (int *) malloc(sizeof(int));
  h_win_y = (int *) malloc(sizeof(int));
  h_mouse_down = (int *) malloc(sizeof(int)*3);
  h_omx = (int *) malloc(sizeof(int));
  h_omy = (int *) malloc(sizeof(int));
  h_mx = (int *) malloc(sizeof(int));
  h_my = (int *) malloc(sizeof(int));
  h_force = (float *) malloc(sizeof(float));
  h_source = (float *) malloc(sizeof(float));

  cudaMalloc((void**) &d_u, size*sizeof(float));
  cudaMalloc((void**) &d_v, size*sizeof(float));
  cudaMalloc((void**) &d_u_prev, size*sizeof(float));
  cudaMalloc((void**) &d_v_prev, size*sizeof(float));
  cudaMalloc((void**) &d_dens, size*sizeof(float));
  cudaMalloc((void**) &d_dens_prev, size*sizeof(float));
  cudaMalloc((void**) &d_win_x ,sizeof(int));
  cudaMalloc((void**) &d_win_y ,sizeof(int));
  cudaMalloc((void**) &d_mouse_down, sizeof(int) * 3);
  cudaMalloc((void**) &d_omx,sizeof(int));
  cudaMalloc((void**) &d_omy,sizeof(int));
  cudaMalloc((void**) &d_mx,sizeof(int));
  cudaMalloc((void**) &d_my,sizeof(int));
  cudaMalloc((void**) &d_force,sizeof(float));
  cudaMalloc((void**) &d_source,sizeof(float));

        if ( !h_u || !h_v || !h_u_prev || !h_v_prev || !h_dens || !h_dens_prev ) {
                fprintf ( stderr, "cannot allocate data\n" );
                return ( 0 );
        }

        return ( 1 );
}

/*
  ----------------------------------------------------------------------
   OpenGL specific drawing routines
  ----------------------------------------------------------------------
*/

static void pre_display ( void )
{
        glViewport ( 0, 0, *h_win_x, *h_win_y );
        glMatrixMode ( GL_PROJECTION );
        glLoadIdentity ();
        gluOrtho2D ( 0.0, 1.0, 0.0, 1.0 );
        glClearColor ( 0.0f, 0.0f, 0.0f, 1.0f );
        glClear ( GL_COLOR_BUFFER_BIT );
}

static void post_display ( void )
{
        glutSwapBuffers ();
}

static void draw_velocity ( void )
{
        int i, j;
        float x, y, h;

        h = 1.0f/N;

        glColor3f ( 1.0f, 1.0f, 1.0f );
        glLineWidth ( 1.0f );

        glBegin ( GL_LINES );

                for ( i=1 ; i<=N ; i++ ) {
                        x = (i-0.5f)*h;
                        for ( j=1 ; j<=N ; j++ ) {
                                y = (j-0.5f)*h;

                                glVertex2f ( x, y );
                                glVertex2f ( x+h_u[IX(i,j)], y+h_v[IX(i,j)] );
                        }
                }

        glEnd ();
}

static void draw_density ( void )
{
        int i, j;
        float x, y, h, d00, d01, d10, d11;

        h = 1.0f/N;

        glBegin ( GL_QUADS );

                for ( i=0 ; i<=N ; i++ ) {
                        x = (i-0.5f)*h;
                        for ( j=0 ; j<=N ; j++ ) {
                                y = (j-0.5f)*h;

                                d00 = h_dens[IX(i,j)];
                                d01 = h_dens[IX(i,j+1)];
                                d10 = h_dens[IX(i+1,j)];
                                d11 = h_dens[IX(i+1,j+1)];

                                glColor3f ( d00, d00, d00 ); glVertex2f ( x, y );
                                glColor3f ( d10, d10, d10 ); glVertex2f ( x+h, y );
                                glColor3f ( d11, d11, d11 ); glVertex2f ( x+h, y+h );
                                glColor3f ( d01, d01, d01 ); glVertex2f ( x, y+h );
                        }
                }

        glEnd ();
}

/*
  ----------------------------------------------------------------------
   relates mouse movements to h_forces h_sources
  ----------------------------------------------------------------------
*/

__host__ void react(float * d, float * h_u, float * v, int n,
        float *d_force, float *d_source, int *d_mouse_down,
        int *d_mx, int *d_my, int *d_omx, int *d_omy, int *d_win_x, int *d_win_y);

/*
  ---------------------------------------------------------------------
   GLUT callback routines
  ----------------------------------------------------------------------
*/

static void key_func ( unsigned char key, int x, int y )
{
        switch ( key )
        {
                case 'c':
                case 'C':
                        clear_data ();
                        break;

                case 'q':
                case 'Q':
                        free_data ();
                        exit ( 0 );
                        break;

                case 'v':
                case 'V':
                        dvel = !dvel;
                        break;
        }
}

static void mouse_func ( int button, int state, int x, int y )
{
        *h_omx = *h_mx = x;
        *h_omy = *h_my = y;

        h_mouse_down[button] = state == GLUT_DOWN;
}

static void motion_func ( int x, int y )
{
        *h_mx = x;
        *h_my = y;
}

static void reshape_func ( int width, int height )
{
        glutSetWindow ( h_win_id );
        glutReshapeWindow ( width, height );

        *h_win_x = width;
        *h_win_y = height;
}

__host__ void idle_func ( void )
{
        static int times = 1;
        static double start_t = 0.0;
        static double one_second = 0.0;
        static double react_ns_p_cell = 0.0;
        static double vel_ns_p_cell = 0.0;
        static double dens_ns_p_cell = 0.0;
        unsigned int size = (N+2)*(N+2);

        start_t = wtime();
        react (d_dens_prev, d_u_prev, d_v_prev, N, d_force, d_source, d_mouse_down,
                d_mx, d_my, d_omx, d_omy, d_win_x, d_win_y);
        react_ns_p_cell += 1.0e9 * (wtime()-start_t)/(N*N);


        start_t = wtime();
        vel_step ( N, d_u, d_v, d_u_prev, d_v_prev, visc, dt );
        vel_ns_p_cell += 1.0e9 * (wtime()-start_t)/(N*N);

        start_t = wtime();
        dens_step ( N, d_dens, d_dens_prev, d_u, d_v, diff, dt );
        dens_ns_p_cell += 1.0e9 * (wtime()-start_t)/(N*N);

       cudaDeviceSynchronize();
       cudaMemcpy(h_dens,d_dens, size * sizeof(float), cudaMemcpyDeviceToHost);
       cudaMemcpy(h_dens_prev,d_dens_prev, size * sizeof(float), cudaMemcpyDeviceToHost);
       cudaMemcpy(h_u,d_u, size * sizeof(float), cudaMemcpyDeviceToHost);
  cudaMemcpy(h_u_prev,d_u_prev, size * sizeof(float), cudaMemcpyDeviceToHost);
  cudaMemcpy(h_v,d_v, size * sizeof(float), cudaMemcpyDeviceToHost);
  cudaMemcpy(h_v_prev,d_v_prev, size * sizeof(float), cudaMemcpyDeviceToHost);
  cudaMemcpy(h_win_x,d_win_x,sizeof(int), cudaMemcpyDeviceToHost);
  cudaMemcpy(h_win_y,d_win_y,sizeof(int), cudaMemcpyDeviceToHost);
  cudaMemcpy(h_mouse_down,d_mouse_down,sizeof(int)*3, cudaMemcpyDeviceToHost);
  cudaMemcpy(h_omx,d_omx,sizeof(int), cudaMemcpyDeviceToHost);
  cudaMemcpy(h_omy,d_omy,sizeof(int), cudaMemcpyDeviceToHost);
  cudaMemcpy(h_mx,d_mx,sizeof(int), cudaMemcpyDeviceToHost);
  cudaMemcpy(h_my,d_my,sizeof(int), cudaMemcpyDeviceToHost);
  cudaMemcpy(h_force,d_force,sizeof(float), cudaMemcpyDeviceToHost);
  cudaMemcpy(h_source,d_source,sizeof(float), cudaMemcpyDeviceToHost);

        if (1.0<wtime()-one_second) { /* at least 1s between stats */
                printf("%lf, %lf, %lf, %lf: ns per cell total, react, vel_step, dens_step\n",
                        (react_ns_p_cell+vel_ns_p_cell+dens_ns_p_cell)/times,
                        react_ns_p_cell/times, vel_ns_p_cell/times, dens_ns_p_cell/times);
                one_second = wtime();
                react_ns_p_cell = 0.0;
                vel_ns_p_cell = 0.0;
                dens_ns_p_cell = 0.0;
                times = 1;
        } else {
                times++;
        }
        glutSetWindow ( h_win_id );
        glutPostRedisplay ();
}

static void display_func ( void )
{
        pre_display ();

                if ( dvel ) draw_velocity ();
                else            draw_density ();

        post_display ();
}


/*
  ----------------------------------------------------------------------
   open_glut_window --- open a glut compatible window and set callbacks
  ----------------------------------------------------------------------
*/

static void open_glut_window ( void )
{
        glutInitDisplayMode ( GLUT_RGBA | GLUT_DOUBLE );

        glutInitWindowPosition ( 0, 0 );
        glutInitWindowSize ( *h_win_x, *h_win_y );
        h_win_id = glutCreateWindow ( "Alias | wavefront" );

        glClearColor ( 0.0f, 0.0f, 0.0f, 1.0f );
        glClear ( GL_COLOR_BUFFER_BIT );
        glutSwapBuffers ();
        glClear ( GL_COLOR_BUFFER_BIT );
        glutSwapBuffers ();

        pre_display ();

        glutKeyboardFunc ( key_func );
        glutMouseFunc ( mouse_func );
        glutMotionFunc ( motion_func );
        glutReshapeFunc ( reshape_func );

        int i  =0 ;
        unsigned int size = (N+2)*(N+2);


  glutIdleFunc( idle_func );
        glutDisplayFunc ( display_func );
}


/*
  ----------------------------------------------------------------------
   main --- main routine
  ----------------------------------------------------------------------
*/

int main ( int argc, char ** argv )
{
        glutInit ( &argc, argv );

        if ( argc != 1 && argc != 7 ) {
                fprintf ( stderr, "usage : %s N dt diff visc h_force *h_source\n", argv[0] );
                fprintf ( stderr, "where:\n" );\
                fprintf ( stderr, "\t N      : grid resolution\n" );
                fprintf ( stderr, "\t dt     : time step\n" );
                fprintf ( stderr, "\t diff   : diffusion rate of the density\n" );
                fprintf ( stderr, "\t visc   : viscosity of the fluid\n" );
                fprintf ( stderr, "\t h_force  : scales the mouse movement that generate a h_force\n" );
                fprintf ( stderr, "\t *h_source : amount of density that will be deposited\n" );
                exit ( 1 );
        }
  float aux_force;
  float aux_source;
        if ( argc == 1 ) {
                N = SIZE;
                dt = 0.1f;
                diff = 0.0f;
                visc = 0.0f;
                aux_force = 5.0f;
                aux_source = 100.0f;
                fprintf ( stderr, "Using defaults : N=%d dt=%g diff=%g visc=%g force = %g source=%g\n",
                        N, dt, diff, visc, aux_force, aux_source );
        } else {
                N = atoi(argv[1]);
                dt = atof(argv[2]);
                diff = atof(argv[3]);
                visc = atof(argv[4]);
                aux_force = atof(argv[5]);
                aux_source = atof(argv[6]);
        }

        printf ( "\n\nHow to use this demo:\n\n" );
        printf ( "\t Add densities with the right mouse button\n" );
        printf ( "\t Add velocities with the left mouse button and dragging the mouse\n" );
        printf ( "\t Toggle density/velocity display with the 'v' key\n" );
        printf ( "\t Clear the simulation by pressing the 'c' key\n" );
        printf ( "\t Quit by pressing the 'q' key\n" );

        dvel = 0;

        if ( !allocate_data () ) exit ( 1 );
        clear_data ();

  *h_force = aux_force;
  *h_source = aux_source;
        *h_win_x = 512;
        *h_win_y = 512;
        open_glut_window ();

        unsigned int size = (N+2)*(N+2);
  cudaMemcpy(d_dens,h_dens, size * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(d_dens_prev,h_dens_prev, size * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(d_u,h_u, size * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(d_u_prev,h_u_prev, size * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(d_v,h_v, size * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(d_v_prev,h_v_prev, size * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(d_win_x,h_win_x,sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_win_y,h_win_y,sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_mouse_down,h_mouse_down,sizeof(int)*3, cudaMemcpyHostToDevice);
  cudaMemcpy(d_omx,h_omx,sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_omy,h_omy,sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_mx,h_mx,sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_my,h_my,sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_force,h_force,sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(d_source,h_source,sizeof(float), cudaMemcpyHostToDevice);
        glutMainLoop ();

        exit ( 0 );
}

//
// timing.c
//
double wtime(void)
{
  struct timeval tv;
  gettimeofday(&tv, 0);

  return (double) tv.tv_sec + 1e-6 * tv.tv_usec;
}
#undef IX
#define IX(x,y) (rb_idx((x),(y),(n+2)))
#define SWAP(x0,x) {float * tmp=x0;x0=x;x=tmp;}

int threadsPerBlock = TPB;


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
  //while (numBlocks > maxBlocks) {
  dim3 block(threadsPerBlock,1);
  dim3 grid(numBlocks,1);
  add_source_kernel<<<grid, block>>>(n, x, s, dt);
  cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess) {
      printf("add_source_kernel 1 launch failed: %s\n", cudaGetErrorString(err));
  }

//     cudaDeviceSynchronize();
//    x += maxBlocks * threadsPerBlock;
//    s += maxBlocks * threadsPerBlock;
//    numBlocks -= maxBlocks;
//  }
//  add_source_kernel<<<numBlocks, threadsPerBlock>>>(n, x, s, dt);
//  cudaError_t err = cudaGetLastError();
//      if (err != cudaSuccess) {
//        printf("add_source_kernel 2 launch failed: %s\n", cudaGetErrorString(err));
//    }

//   cudaDeviceSynchronize();


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
  if(i == 0){
    x[IX(0, 0)] = 0.5f * (x[IX(1, 0)] + x[IX(0, 1)]);
    x[IX(n + 1, 0)] = 0.5f * (x[IX(n, 0)] + x[IX(n + 1, 1)]);
    x[IX(0, n + 1)] = 0.5f * (x[IX(1, n + 1)] + x[IX(0, n)]);
    x[IX(n + 1, n + 1)] = 0.5f * (x[IX(n, n + 1)] + x[IX(n + 1, n)]);
  }
}

static void set_bnd(unsigned int n, boundary b, float* x)
{
    int numBlocks = (n + threadsPerBlock - 1) / threadsPerBlock;
    set_bnd_kernel<<<numBlocks, threadsPerBlock>>>(n, b, x);
    cudaError_t err = cudaGetLastError();
      if (err != cudaSuccess) {
        printf("set_bnd_kernel launch failed: %s\n", cudaGetErrorString(err));
    }

//     cudaDeviceSynchronize();
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
    unsigned int block_size = TPB / n;

    unsigned y = blockIdx.y * blockDim.y + threadIdx.y;
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

    unsigned int threadsPerRow = n/2 < TPB ? n/2 : TPB;
    unsigned int blocksPerRow = (((n / 2) + (threadsPerRow-1)) / threadsPerRow);
    unsigned int height = 1024/threadsPerRow;
    int rows = (n/height);
    //dim3 grid(1, rows);
    dim3 block(threadsPerRow, height);
    dim3 grid(blocksPerRow, rows);
    for (unsigned int k = 0; k < 20; ++k) {
      // cudaMemcpyToSymbol(ro_mem, red0, threadsPerBlock * sizeof(float));
      lin_solve_rb_step<<<grid, block>>>(RED, n, a, c, red0, blk, red);
      cudaError_t err = cudaGetLastError();
      if (err != cudaSuccess) {
        printf("lin_solve_rb_step_kernel 1 launch failed: %s\n", cudaGetErrorString(err));
       }

      // cudaMemcpyToSymbol(ro_mem, blk0, threadsPerBlock * sizeof(float));
      lin_solve_rb_step<<<grid, block>>>(BLACK, n, a, c, blk0, red, blk);
      err = cudaGetLastError();
      if (err != cudaSuccess) {
        printf("lin_solve_rb_step_kernel 2 launch failed: %s\n", cudaGetErrorString(err));
       }

//       cudaDeviceSynchronize();
      set_bnd(n, b, x);
    }
  }

void diffuse(unsigned int n, boundary b, float * x, float * x0, float diff, float dt)
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
  unsigned int numBlocks = (n + (SIDE-1)) / SIDE;
  dim3 block(SIDE,SIDE);
  dim3 grid(numBlocks,numBlocks);
  advect_kernel<<<grid, block>>>(n, b, d, d0, u, v, dt);
  cudaError_t err = cudaGetLastError();
     if (err != cudaSuccess) {
     printf("react_kernel launch failed: %s\n", cudaGetErrorString(err));
  }
 // cudaDeviceSynchronize();
  set_bnd(n, b, d);
}

__global__ void project_density_kernel(
  unsigned int n,
  float *u,
  float *v,
  float *p,
  float *div) {
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
    unsigned int numBlocks = (n + (SIDE-1)) / SIDE;
    dim3 block(SIDE, SIDE);
    dim3 grid(numBlocks,numBlocks);
    project_density_kernel<<<grid,block>>>(n, u, v, p, div);
    cudaError_t err = cudaGetLastError();
      if (err != cudaSuccess) {
        printf("project_density_kernel launch failed: %s\n", cudaGetErrorString(err));
    }

    set_bnd(n, NONE, div);
    set_bnd(n, NONE, p);

    lin_solve(n, NONE, p, div, 1, 4);

    project_vel_kernel<<<grid, block>>>(n, u, v, p);
    err = cudaGetLastError();
      if (err != cudaSuccess) {
        printf("project_vel_kernel launch failed: %s\n", cudaGetErrorString(err));
    }

//     cudaDeviceSynchronize();
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

__global__ void react_kernel(float * d, float * h_u, float * v, int n,
    float *d_force, float *d_source, int *d_mouse_down,
    int *d_mx, int *d_my, int *d_omx, int *d_omy, int *d_win_x, int *d_win_y)
{


    if (threadIdx.x == 0 && threadIdx.y == 0 && blockIdx.x == 0 && blockIdx.y == 0) {
        float max_velocity2 = 0.0f;
        float max_density = 0.0f;
        int size = (n+2)*(n+2);

        // Busca máximos (puedes hacer esto en host si quieres)
        for (int idx = 0; idx < size; ++idx) {
            if (max_velocity2 < h_u[idx]*h_u[idx] + v[idx]*v[idx]) {
                max_velocity2 = h_u[idx]*h_u[idx] + v[idx]*v[idx];
            }
            if (max_density < d[idx]) {
                max_density = d[idx];
            }
        }

        if (max_velocity2<0.0000005f) {
            h_u[IX(n/2,n/2)] = *d_force * 10.0f;
            v[IX(n/2,n/2)] = *d_force * 10.0f;
        }
        if (max_density<1.0f) {
            d[IX(n/2,n/2)] = *d_source * 10.0f;
        }

        // if ( !d_mouse_down[0] && !d_mouse_down[2] ) return;

        // int i = (int)(( *d_mx /(float)*d_win_x)*n+1);
        // int j = (int)(((*d_win_y-*d_my)/(float)*d_win_y)*n+1);

        // if ( i<1 || i>n || j<1 || j>n ) return;

        // if ( d_mouse_down[0] ) {
        //     h_u[IX(i,j)] = *d_force * (*d_mx-*d_omx);
        //     v[IX(i,j)] = *d_force * (*d_omy-*d_my);
        // }

        // if ( d_mouse_down[2] ) {
        //     d[IX(i,j)] = *d_source;
        // }

        // *d_omx = *d_mx;
        // *d_omy = *d_my;
    }
}


void react(float * d, float * u, float * v, int n,
        float *d_force, float *d_source, int *d_mouse_down,
        int *d_mx, int *d_my, int *d_omx, int *d_omy, int *d_win_x, int *d_win_y){
        unsigned int numBlocks = (N + (SIDE-1)) / (SIDE);
        dim3 block(SIDE,SIDE);
        dim3 grid(numBlocks,numBlocks);
        react_kernel<<<grid, block>>>(d, u, v, n, d_force, d_source, d_mouse_down,
                d_mx, d_my, d_omx, d_omy, d_win_x, d_win_y);
        cudaError_t err = cudaGetLastError();
        if (err != cudaSuccess) {
         printf("react_kernel launch failed: %s\n", cudaGetErrorString(err));
        }
//      cudaDeviceSynchronize();

}
