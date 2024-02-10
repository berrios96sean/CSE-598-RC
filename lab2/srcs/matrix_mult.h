#ifndef __MATRIXMUL_H__
#define __MATRIXMUL_H__

#include <cmath>
using namespace std;

#define IN_A_ROWS 4
#define IN_A_COLS 4
#define IN_B_ROWS 4
#define IN_B_COLS 4

typedef float mat_a;
typedef float mat_b;
typedef float mat_prod;

// Prototype of top level function for C-synthesis
void matrix_mult(
      mat_a a[IN_A_ROWS][IN_A_COLS],
      mat_b b[IN_B_ROWS][IN_B_COLS],
      mat_prod prod[IN_A_ROWS][IN_B_COLS]);

#endif // __MATRIXMUL_H__ not defined

