#include "matrix_mult.h"
#include <iostream>
#include <iomanip>
// Matrix Mult Libraries for verification from boost
#include <boost/numeric/ublas/matrix.hpp>
#include <boost/numeric/ublas/io.hpp>

// function to use for testing the result of calculations
void print_matrix(mat_prod matrix[IN_A_ROWS][IN_B_COLS]) 
{
    for(int i = 0; i < IN_A_ROWS; ++i) {
        for(int j = 0; j < IN_B_COLS; ++j) {
            std::cout << std::setw(8) << matrix[i][j] << " ";
        }
        std::cout << "\n";
    }
}

int main()
{
    mat_a a[IN_A_ROWS][IN_A_COLS]; 
    mat_b b[IN_A_ROWS][IN_A_COLS]; 
    mat_prod prod[IN_A_ROWS][IN_A_COLS];
    mat_prod prod_expected[IN_A_ROWS][IN_A_COLS];

    // fill with all ones 
    for (int i = 0; i < IN_A_ROWS; ++i) {
        for (int j = 0; j < IN_A_COLS; ++j) {
            a[i][j] = 1; 
            b[i][j] = 1; 
            prod_expected[i][j] = IN_A_ROWS; // set to size of matrix for each index -- used for expected result
        }
    }

    matrix_mult(a,b,prod);

    // print_matrix(prod);
    // print_matrix(prod_expected);

    // need to compare result with expected -- from printing they look correct
    // not sure this will work for floating point random inputs 
    bool passed = true;  
    for (int i = 0; i < IN_A_ROWS; ++i) {
        for (int j = 0; j < IN_A_COLS; ++j) {
            if (prod[i][j] - prod_expected[i][j] != 0) // if outputs dont match
            {
                passed = false;
            }
        }
    }

    if (passed) {
        std::cout << "TEST PASSED\n";
    } else {
        std::cout << "TEST FAILED\n";
    }

    return 0;
}

