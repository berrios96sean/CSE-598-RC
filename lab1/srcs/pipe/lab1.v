// TO-DO: need to clean up code and erase unused signals -- preliminary design for pipeline tests pass
module lab1 #
(
	parameter WIDTHIN = 16,		// Input format is Q2.14 (2 integer bits + 14 fractional bits = 16 bits)
	parameter WIDTHOUT = 32,	// Intermediate/Output format is Q7.25 (7 integer bits + 25 fractional bits = 32 bits)
	// Taylor coefficients for the first five terms in Q2.14 format
	parameter [WIDTHIN-1:0] A0 = 16'b01_00000000000000, // a0 = 1
	parameter [WIDTHIN-1:0] A1 = 16'b01_00000000000000, // a1 = 1
	parameter [WIDTHIN-1:0] A2 = 16'b00_10000000000000, // a2 = 1/2
	parameter [WIDTHIN-1:0] A3 = 16'b00_00101010101010, // a3 = 1/6
	parameter [WIDTHIN-1:0] A4 = 16'b00_00001010101010, // a4 = 1/24
	parameter [WIDTHIN-1:0] A5 = 16'b00_00000010001000  // a5 = 1/120
)
(
	input clk,
	input reset,	
	
	input i_valid,
	input i_ready,
	output o_valid,
	output o_ready,
	
	input [WIDTHIN-1:0] i_x,
	output [WIDTHOUT-1:0] o_y
);
//Output value could overflow (32-bit output, and 16-bit inputs multiplied
//together repeatedly).  Don't worry about that -- assume that only the bottom
//32 bits are of interest, and keep them.
reg [WIDTHIN-1:0] x;	// Register to hold input X
reg [WIDTHOUT-1:0] y_Q;	// Register to hold output Y
reg valid_Q1;		// Output of register x is valid
reg valid_Q2;		// Output of register y is valid

// Pipelined Registers 
reg [WIDTHIN-1:0] x_r1, x_r2, x_r3, x_r4, x_r5, x_r6, x_r7, x_r8, x_r9; 
reg [WIDTHIN-1:0] y_r1, y_r2, y_r3, y_r4, y_r5; 
reg valid_Q3, valid_Q4, valid_Q5, valid_Q6, valid_Q7;
reg valid_Q8, valid_Q9, valid_Q10, valid_Q11, valid_Q12, valid_Q13; 
reg ready_r1, ready_r2, ready_r3, ready_r4, ready_r5;

// signal for enabling sequential circuit elements
reg enable;

// Signals for computing the y output
wire [WIDTHOUT-1:0] m0_out; // A5 * x
wire [WIDTHOUT-1:0] a0_out; // A5 * x + A4
wire [WIDTHOUT-1:0] m1_out; // (A5 * x + A4) * x
wire [WIDTHOUT-1:0] a1_out; // (A5 * x + A4) * x + A3
wire [WIDTHOUT-1:0] m2_out; // ((A5 * x + A4) * x + A3) * x
wire [WIDTHOUT-1:0] a2_out; // ((A5 * x + A4) * x + A3) * x + A2
wire [WIDTHOUT-1:0] m3_out; // (((A5 * x + A4) * x + A3) * x + A2) * x
wire [WIDTHOUT-1:0] a3_out; // (((A5 * x + A4) * x + A3) * x + A2) * x + A1
wire [WIDTHOUT-1:0] m4_out; // ((((A5 * x + A4) * x + A3) * x + A2) * x + A1) * x
wire [WIDTHOUT-1:0] a4_out; // ((((A5 * x + A4) * x + A3) * x + A2) * x + A1) * x + A0
wire [WIDTHOUT-1:0] y_D;

// registers to hold wire outputs 
reg [WIDTHOUT-1:0] m0_out_r1;
reg [WIDTHOUT-1:0] a0_out_r1;
reg [WIDTHOUT-1:0] m1_out_r1;
reg [WIDTHOUT-1:0] a1_out_r1;
reg [WIDTHOUT-1:0] m2_out_r1;
reg [WIDTHOUT-1:0] a2_out_r1;
reg [WIDTHOUT-1:0] m3_out_r1;
reg [WIDTHOUT-1:0] a3_out_r1;
reg [WIDTHOUT-1:0] m4_out_r1;
reg [WIDTHOUT-1:0] a4_out_r1;
reg [WIDTHOUT-1:0] y_D_r1;

// compute y value
mult16x16 Mult0 (.i_dataa(A5), 		.i_datab(x_r1), 	.o_res(m0_out));
addr32p16 Addr0 (.i_dataa(m0_out_r1), 	.i_datab(A4), 	.o_res(a0_out));

mult32x16 Mult1 (.i_dataa(a0_out_r1), 	.i_datab(x_r3), .o_res(m1_out));
addr32p16 Addr1 (.i_dataa(m1_out_r1), 	.i_datab(A3), 	.o_res(a1_out));

mult32x16 Mult2 (.i_dataa(a1_out_r1), 	.i_datab(x_r5), 	.o_res(m2_out));
addr32p16 Addr2 (.i_dataa(m2_out_r1), 	.i_datab(A2), 	.o_res(a2_out));

mult32x16 Mult3 (.i_dataa(a2_out_r1), 	.i_datab(x_r7), 	.o_res(m3_out));
addr32p16 Addr3 (.i_dataa(m3_out_r1), 	.i_datab(A1), 	.o_res(a3_out));

mult32x16 Mult4 (.i_dataa(a3_out_r1), 	.i_datab(x_r9), 	.o_res(m4_out));
addr32p16 Addr4 (.i_dataa(m4_out_r1), 	.i_datab(A0), 	.o_res(a4_out));

assign y_D = a4_out_r1;

// Combinational logic
always @* begin
	// signal for enable
	enable = i_ready;
end

// Infer the registers
always @ (posedge clk or posedge reset) begin
	if (reset) begin
		valid_Q1  <= 1'b0;
		valid_Q2  <= 1'b0;
		valid_Q3  <= 1'b0;
		valid_Q4  <= 1'b0;
		valid_Q5  <= 1'b0;
		valid_Q6  <= 1'b0;
		valid_Q7  <= 1'b0;
		valid_Q8  <= 1'b0;
		valid_Q9  <= 1'b0;
		valid_Q10 <= 1'b0;
		valid_Q11 <= 1'b0;
		valid_Q12 <= 1'b0;
		valid_Q13 <= 1'b0;

		x <= 0;
		y_Q <= 0;
		{x_r1,x_r2,x_r3,x_r4,x_r5,x_r6,x_r7,x_r8,x_r9} <= 0;
		{y_r1,y_r2,y_r3,y_r4,y_r5} <= 0;

		m0_out_r1 <= 0;
		a0_out_r1 <= 0;
		m1_out_r1 <= 0;
		a1_out_r1 <= 0;
		m2_out_r1 <= 0;
		a2_out_r1 <= 0;
		m3_out_r1 <= 0;
		a3_out_r1 <= 0;
		m4_out_r1 <= 0;
		a4_out_r1 <= 0;
	end else if (enable) begin
		// propagate the valid value
		valid_Q1  <= i_valid;
		valid_Q2  <= valid_Q1;
		valid_Q3  <= valid_Q2; 
		valid_Q4  <= valid_Q3; 
		valid_Q5  <= valid_Q4; 
		valid_Q6  <= valid_Q5; 
		valid_Q7  <= valid_Q6; 
		valid_Q8  <= valid_Q7; 
		valid_Q9  <= valid_Q8; 
		valid_Q10 <= valid_Q9; 
		valid_Q11 <= valid_Q10; 
		valid_Q12 <= valid_Q11; 
		valid_Q13 <= valid_Q12; 

		// ready pipe
		ready_r1 <= i_ready;
		
		// read in new x value
		x <= i_x;
		x_r1 <= x;
		x_r2 <= x_r1; 
		x_r3 <= x_r2;
		x_r4 <= x_r3; 
		x_r5 <= x_r4; 
		x_r6 <= x_r5; 
		x_r7 <= x_r6; 
		x_r8 <= x_r7; 
		x_r9 <= x_r8; 
		
		// output computed y value
		y_Q <= y_D;
		y_r1 <= y_Q; 
		y_r2 <= y_r1; 
		y_r3 <= y_r2;
		y_r4 <= y_r3; 
		y_r5 <= y_r4;

		// registers holding wired outputs 
		m0_out_r1  <= m0_out;
		a0_out_r1  <= a0_out;
		m1_out_r1  <= m1_out;
		a1_out_r1  <= a1_out;
		m2_out_r1  <= m2_out;
		a2_out_r1  <= a2_out;
		m3_out_r1  <= m3_out;
		a3_out_r1  <= a3_out;
		m4_out_r1  <= m4_out;
		a4_out_r1  <= a4_out;
	end
end

// assign outputs
assign o_y = y_Q;
// ready for inputs as long as receiver is ready for outputs */
assign o_ready = i_ready;   		
// the output is valid as long as the corresponding input was valid and 
//	the receiver is ready. If the receiver isn't ready, the computed output
//	will still remain on the register outputs and the circuit will resume
//  normal operation with the receiver is ready again (i_ready is high)*/
assign o_valid = valid_Q13 & i_ready;	

endmodule

/*******************************************************************************************/

// Multiplier module for the first 16x16 multiplication
module mult16x16 (
	input  [15:0] i_dataa,
	input  [15:0] i_datab,
	output [31:0] o_res
);

reg [31:0] result;

always @ (*) begin
	result = i_dataa * i_datab;
end

// The result of Q2.14 x Q2.14 is in the Q4.28 format. Therefore we need to change it
// to the Q7.25 format specified in the assignment by shifting right and padding with zeros.
assign o_res = {3'b000, result[31:3]};

endmodule

/*******************************************************************************************/

// Multiplier module for all the remaining 32x16 multiplications
module mult32x16 (
	input  [31:0] i_dataa,
	input  [15:0] i_datab,
	output [31:0] o_res
);

reg [47:0] result;

always @ (*) begin
	result = i_dataa * i_datab;
end

// The result of Q7.25 x Q2.14 is in the Q9.39 format. Therefore we need to change it
// to the Q7.25 format specified in the assignment by selecting the appropriate bits
// (i.e. dropping the most-significant 2 bits and least-significant 14 bits).
assign o_res = result[45:14];

endmodule

/*******************************************************************************************/

// Adder module for all the 32b+16b addition operations 
module addr32p16 (
	input [31:0] i_dataa,
	input [15:0] i_datab,
	output [31:0] o_res
);

// The 16-bit Q2.14 input needs to be aligned with the 32-bit Q7.25 input by zero padding
assign o_res = i_dataa + {5'b00000, i_datab, 11'b00000000000};

endmodule

/*******************************************************************************************/