
#include "matrix_mult.h"

void matrix_mult(
      mat_a a[IN_A_ROWS][IN_A_COLS],
      mat_b b[IN_B_ROWS][IN_B_COLS],
      mat_prod prod[IN_A_ROWS][IN_B_COLS])
{
#pragma HLS INTERFACE s_axilite port=return bundle=control
#pragma HLS INTERFACE mode=bram port=a storage_type=ram_1p
#pragma HLS INTERFACE mode=bram port=b storage_type=ram_1p
#pragma HLS INTERFACE mode=bram port=prod storage_type=ram_1p
  // Iterate over the rows of the A matrix
   Row: for(int i = 0; i < IN_A_ROWS; i++) {
      // Iterate over the columns of the B matrix
      Col: for(int j = 0; j < IN_B_COLS; j++) {
         prod[i][j] = 0;
         // Do the inner product of a row of A and col of B
         Product: for(int k = 0; k < IN_B_ROWS; k++) {
            prod[i][j] += a[i][k] * b[k][j];
         }
      }
   }

}
