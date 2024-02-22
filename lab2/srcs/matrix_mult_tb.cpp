#include "matrix_mult.h"
#include <iostream>
#include <iomanip>
#include <random>
// Matrix Mult Libraries for verification from boost
#include <boost/numeric/ublas/matrix.hpp>
#include <boost/numeric/ublas/io.hpp>

// function to use for testing the result of calculations
void print_matrix(mat_prod matrix[IN_A_ROWS][IN_B_COLS]) 
{
    for(int i = 0; i < IN_A_ROWS; ++i) {
        for(int j = 0; j < IN_B_COLS; ++j) {
            std::cout << std::fixed << std::setprecision(1) << std::setw(8) << matrix[i][j] << " ";
        }
        std::cout << "\n";
    }
}

void convert_matrix_in(const boost::numeric::ublas::matrix<double>& input_matrix, mat_a output_array[IN_A_ROWS][IN_A_COLS]) {
    for (int i = 0; i < std::min(IN_A_ROWS, (int)input_matrix.size1()); ++i) {
        for (int j = 0; j < std::min(IN_A_COLS, (int)input_matrix.size2()); ++j) {
            output_array[i][j] = static_cast<mat_a>(input_matrix(i, j));
        }
    }
}

void convert_matrix_out(const boost::numeric::ublas::matrix<double>& input_matrix, mat_prod output_array[IN_A_ROWS][IN_A_COLS]) {
    for (int i = 0; i < std::min(IN_A_ROWS, (int)input_matrix.size1()); ++i) {
        for (int j = 0; j < std::min(IN_A_COLS, (int)input_matrix.size2()); ++j) {
            output_array[i][j] = static_cast<mat_prod>(input_matrix(i, j));
        }
    }
}

int main()
{
    srand(static_cast<unsigned int>(time(0))); // random seed 

    // Random Matrix test 
    boost::numeric::ublas::matrix<int> rand_a(IN_A_ROWS,IN_A_COLS);
    boost::numeric::ublas::matrix<int> rand_b(IN_B_ROWS,IN_B_COLS);
    mat_a rand_a2[IN_A_ROWS][IN_A_COLS]; 
    mat_b rand_b2[IN_A_ROWS][IN_A_COLS]; 
    mat_prod rand_prod[IN_A_ROWS][IN_A_COLS];

    // Matrix filled with Ones
    mat_a a[IN_A_ROWS][IN_A_COLS]; 
    mat_b b[IN_A_ROWS][IN_A_COLS]; 
    mat_prod prod[IN_A_ROWS][IN_A_COLS];
    mat_prod rand_prod2[IN_A_ROWS][IN_A_COLS];
    mat_prod prod_expected[IN_A_ROWS][IN_A_COLS];

    // fill with all ones 
    for (int i = 0; i < IN_A_ROWS; ++i) {
        for (int j = 0; j < IN_A_COLS; ++j) {
            a[i][j] = 1; 
            b[i][j] = 1; 
            prod_expected[i][j] = IN_A_ROWS; // set to size of matrix for each index -- used for expected result
        }
    }

    // fill with random values 
    for (int i = 0; i < IN_A_ROWS; ++i) {
        for (int j = 0; j < IN_A_COLS; ++j) {
            rand_a(i, j) = static_cast<int>(rand()) / (RAND_MAX / 9.0); // fill with # 0-9
            rand_b(i, j) = static_cast<int>(rand()) / (RAND_MAX / 9.0); // fill with # 0-9
        }
    }

    convert_matrix_in(rand_a,rand_a2);
    convert_matrix_in(rand_b,rand_b2);
    // print_matrix(rand_a2);
    // print_matrix(rand_b2);

    matrix_mult(a,b,prod);
    matrix_mult(rand_a2,rand_b2,rand_prod);

    boost::numeric::ublas::matrix<double> rand_prod_expected = boost::numeric::ublas::prod(rand_a,rand_b);

    convert_matrix_out(rand_prod_expected,rand_prod2);

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

    bool rand_passed = true;  
    for (int i = 0; i < IN_A_ROWS; ++i) {
        for (int j = 0; j < IN_A_COLS; ++j) {
            if (rand_prod[i][j] - rand_prod2[i][j] != 0) // if outputs dont match
            {
                rand_passed = false;
            }
        }
    }

    if (passed) {
        std::cout << "BASIC TEST PASSED\n";
    } else {
        std::cout << "BASIC TEST FAILED\n";
    }

    if (rand_passed) {
        std::cout << "RANDOM TEST PASSED\n";
    } else {
        std::cout << "RANDOM TEST FAILED\n";
    }

    return 0;
}

