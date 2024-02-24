import numpy as np # using np for int32 data types

def matrix_mult(a, b):
    
    a = np.array(a, dtype=np.int32)
    b = np.array(b, dtype=np.int32)
    prod = np.zeros((len(a), len(a[0])),dtype=np.int32)
    
    IN_A_ROWS = len(a)
    IN_A_COLS = len(a[0])
    IN_B_ROWS = len(b)
    IN_B_COLS = len(b[0])
    
    
    for i in range(IN_A_ROWS):
        for j in range(IN_B_COLS):
            for k in range(IN_B_ROWS):
                prod[i][j] += a[i][k] * b[k][j]
    return prod

def generate_random_matrices(rows, cols):
    a = np.random.randint(low=0, high=10, size=(rows, cols), dtype=np.int32)
    b = np.random.randint(low=0, high=10, size=(rows, cols), dtype=np.int32)
    return a, b

def generate_basic_matrices(rows, cols):
    a = np.ones((rows, cols), dtype=np.int32)
    b = np.ones((rows, cols), dtype=np.int32)
    return a, b 

def generate_basic_matrices_value(rows, cols, value):
    a = np.full((rows, cols), value, dtype=np.int32)
    b = np.full((rows, cols), value, dtype=np.int32)
    return a, b 

def print_matrix(matrix):
    for row in matrix:
        print(" ".join(map(str, row)))
