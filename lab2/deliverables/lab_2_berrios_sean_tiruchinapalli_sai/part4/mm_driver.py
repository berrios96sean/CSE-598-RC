from pynq import Overlay 
from pynq import MMIO

overlay = Overlay('/home/xilinx/jupyter_notebooks/lab2/lab2_p4.bit')

matrix_mult = overlay.matrix_mult_0
base_address = 0x40000000
size = 0x40000
matrix_size = 16

offset_a = 0x0
offset_b = 0x2000
offset_prod = 0x4000

mmio = MMIO(base_address,size)

def write_matrix_a(matrix):
    rows, cols = matrix.shape

    for row in range(rows):
        for col in range(cols):
            # offset for input a
            offset = offset_a + (row * cols + col) * 4
            
            # Get the value from the matrix
            value = matrix[row, col]
            
            # Write the value to the calculated offset
            mmio.write(offset, value)
            
def write_matrix_b(matrix):
    rows, cols = matrix.shape

    for row in range(rows):
        for col in range(cols):
            # offset for input b
            offset = offset_b + (row * cols + col) * 4
            
            # Get the value from the matrix
            value = matrix[row, col]
            
            # Write the value to the calculated offset
            mmio.write(offset, value)
            
def start_calculation():
    matrix_mult.register_map.CTRL.AP_START = 1
    
    # Wait for calculation to finish
    while matrix_mult.register_map.CTRL.AP_IDLE == 0: 
        pass
    
'''
Returns a Matrix 
'''
def read_offset_a_matrix():
    output_matrix = [[0 for _ in range(matrix_size)] for _ in range(matrix_size)]
    for row in range(matrix_size):
        for col in range(matrix_size):
            # offset for input a
            offset = offset_a + (row * matrix_size + col) * 4
            
            # Get the value from the offset 
            value = mmio.read(offset)
            
            # Write the value to the calculated offset
            mmio.write(offset, value)
            
            # store value
            output_matrix[row][col] = value
    
    return output_matrix

'''
Returns a Matrix 
'''
def read_offset_b_matrix():
    output_matrix = [[0 for _ in range(matrix_size)] for _ in range(matrix_size)]
    for row in range(matrix_size):
        for col in range(matrix_size):
            # offset for input a
            offset = offset_b + (row * matrix_size + col) * 4
            
            # Get the value from the offset 
            value = mmio.read(offset)
            
            # Write the value to the calculated offset
            mmio.write(offset, value)
            
            # store value
            output_matrix[row][col] = value
    
    return output_matrix

'''
Returns a Matrix 
'''
def read_offset_prod_matrix():
    output_matrix = [[0 for _ in range(matrix_size)] for _ in range(matrix_size)]
    for row in range(matrix_size):
        for col in range(matrix_size):
            # offset for input a
            offset = offset_prod + (row * matrix_size + col) * 4
            
            # Get the value from the offset 
            value = mmio.read(offset)
            
            # Write the value to the calculated offset
            mmio.write(offset, value)
            
            # store value
            output_matrix[row][col] = value
    
    return output_matrix
