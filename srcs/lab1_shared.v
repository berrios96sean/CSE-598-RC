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
reg valid_Q3, valid_Q4, valid_Q5, valid_Q6, valid_Q7 ;
reg valid_Q8, valid_Q9, valid_Q10, valid_Q11, valid_Q12 ;

reg [31:0] t_output; 

// Input to mult
reg [WIDTHOUT-1:0] P1;
reg [31:0] temp_p1; 

// Register array to hold Input
reg [15:0] in_array [0:100];
reg [31:0] out_array [0:100];
integer out_index; 
integer index; 

// testpoints 
reg [31:0] t0; 
reg [31:0] t1; 
reg [31:0] t2; 
reg [31:0] t3; 
reg [31:0] t4; 
reg [31:0] t5; 
reg [31:0] t6; 
reg [31:0] t7; 
reg [31:0] t8; 
reg [31:0] t9; 
reg [31:0] t10; 
reg [31:0] t11; 
reg [31:0] t12; 
reg [31:0] t13; 
reg [31:0] t14; 
reg [31:0] t15; 
reg [31:0] t16; 
reg [31:0] t17; 
reg [31:0] t18; 
reg [31:0] t19; 
reg [31:0] t20; 
reg [31:0] t21; 
reg [31:0] t22; 
reg [31:0] t23; 
reg [31:0] t24; 
reg [31:0] t25; 
reg [31:0] t26; 
reg [31:0] t27; 
reg [31:0] t28; 
reg [31:0] t29; 
reg [31:0] t30; 
reg [31:0] t31; 
reg [31:0] t32; 
reg [31:0] t33; 
reg [31:0] t34; 
reg [31:0] t35; 
reg [31:0] t36; 
reg [31:0] t37; 
reg [31:0] t38; 
reg [31:0] t39; 
reg [31:0] t40;
reg [31:0] t41; 
reg [31:0] t42; 
reg [31:0] t43; 
reg [31:0] t44; 
reg [31:0] t45; 
reg [31:0] t46; 
reg [31:0] t47; 
reg [31:0] t48; 
reg [31:0] t49; 
reg [31:0] t50;  



integer counter; 
integer t_counter;

// Mux registers 
reg [2:0] mux_sel; 
reg mux_sel2; 

// Mux Wires
wire [15:0] mux_out; 
wire [31:0] mux_out2; 
// signal for enabling sequential circuit elements
reg enable;

reg [15:0] temp;

wire [WIDTHOUT-1:0] m_out; // P1 * x
wire [WIDTHOUT-1:0] a_out; //P1*x + MUX_out

reg out_sel; // input to select Mult calculation 

reg [31:0] a_out_r1; 

reg [15:0] mult0_inb;

integer index2;

reg [31:0] mult0_ina;
reg [31:0] add_ina;
reg [15:0] add_inb;

reg t_valid; 

// -----------------------------------------------------------------------------------------
// FSM to control first calculation
// -----------------------------------------------------------------------------------------

reg [2:0] current_state, next_state; 

// FSM transition control
always @(posedge clk or posedge reset) begin
	if (reset) begin 
        next_state <= IDLE; 
	end else begin
		current_state <= next_state; 
	end
end

localparam IDLE   = 2'b00,
           ADD    = 2'b01,
           MULT1  = 2'b10,
           MULT2  = 2'b11;

always @ (current_state, counter)
begin 
    if (reset) begin 
        t_valid <= 0;
        out_index <= 0; 
    end else begin
        case(current_state)

        IDLE: 
        if (counter % 10 == 4) begin 
            next_state <= MULT1;
            mult0_ina   <= A5;
            out_sel    <= 0;
        end else begin 
            next_state <= IDLE;
        end
        MULT1: 
        if (counter % 10 == 5) begin 
            next_state <= ADD;
            add_ina <= m_out; 
            mux_sel <= 3'b100; // A4
            out_sel <= 1;
        end
        ADD:
        begin
            next_state <= MULT2;
            mult0_ina <= a_out; 
        end
        MULT2:
        if (counter % 10 == 7) begin
            next_state <= ADD;
            add_ina <= m_out;
            mux_sel <= 3'b011; // A3
        end else if (counter % 10 == 9) begin 
            next_state <= ADD;
            add_ina <= m_out;
            mux_sel <= 3'b010; // A2
        end else if (counter % 10 == 1 && counter > 1) begin 
            next_state <= ADD;
            add_ina <= m_out;
            mux_sel <= 3'b001; // A1
        end else if (counter % 10 == 3 && counter > 3) begin 
            next_state <= IDLE; // Send Back with Next X input
            add_ina <= m_out;
            mux_sel <= 3'b000; // A0
            
        end 
        endcase
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset logic here
        index2 <= 0; 
    end else begin
        // Check if counter is within the valid range to update index2 and possibly out_array
        if (counter > 0 && counter < 513) begin // Adjust the range as necessary
            
            if (counter > 3 && counter % 10 == 3) begin 
                index2 <= index2 + 1;
            end
            
            // Check if counter is at the start of a new range for updating out_array
            if (counter > 4 && counter % 10 == 4) begin
                out_index <= out_index + 1;
                out_array[out_index] <= a_out;
            end
        end
    end
end

always @ (posedge clk or posedge reset) begin
    if (reset) begin 
        t_counter <= 0; 
    end else begin 

        if (counter > 495 && counter < 503) begin // finished transfer data from clock cycle 86 +  
            t_valid <= 1; 
            t_output <= out_array[t_counter];
            t_counter <= t_counter + 1; 
        end else if (counter > 508 && counter < 552) begin 
            t_output <= out_array[t_counter]; // 130
            t_counter <= t_counter + 1; 
        end

    end
end


// -----------------------------------------------------------------------------------------
// Module Instantiations 
// -----------------------------------------------------------------------------------------
mux mux0 (
    .a(A0), 
    .b(A1), 
    .c(A2), 
    .d(A3), 
    .e(A4), 
    .f(A5), 
    .sel(mux_sel), 
    .out(mux_out)
    );

mux2 mux1 (
    .a({16'b0,A5}), 
    .b(a_out_r1), 
    .sel(mux_sel2), 
    .out(mux_out2)
    );


// -----------------------------------------------------------------------------------------
// Mult/Addr
// -----------------------------------------------------------------------------------------
mult32x16 Mult0 (
    .i_dataa(mult0_ina), 		
    .i_datab(in_array[index2]), // not sure this is setting correctly may need to delay by one clock cylce
    .out_sel(out_sel),	
    .o_res(m_out)
    );

addr32p16 Addr0 (
    .i_dataa(add_ina), 	
    .i_datab(mux_out), 	
    .o_res(a_out)
    );



// -----------------------------------------------------------------------------------------
// Counter to continuosly increment
// -----------------------------------------------------------------------------------------
always @ (posedge clk or posedge reset)
begin 
    if (reset) begin 
        counter <= 0; 
    end else begin 
        counter <= counter + 1;
    end
end

// -----------------------------------------------------------------------------------------
// Select next input b for adder 
// -----------------------------------------------------------------------------------------


// -----------------------------------------------------------------------------------------
// Control Multiplier Inputs 
// -----------------------------------------------------------------------------------------
// always @(posedge clk or posedge reset) 
// begin
// 	if(reset) begin
// 		P1 <= 0;
//         temp_p1 <= 0;
//         mux_sel2 <= 0; // selects which input to sent to multiplier
//         index2 <= 0;
//     end else begin
//         if (counter > 2 && counter < 4) begin
//             P1 <= A5[15:0];
//             out_sel <= 0;
//             temp_p1 <= a_out; 
//             mux_sel2 <= 0;
//         end else if (counter > 3)begin 
//             P1 <= a_out;
//             out_sel <= 1;
//             mux_sel2 <= 1;
//         end

//         if (counter < 7) begin 
//             mult0_inb <= in_array[0];
//         end
//     end
// end 

// -----------------------------------------------------------------------------------------
// Hold input inside register array 
// -----------------------------------------------------------------------------------------
always @ (posedge clk or posedge reset)
begin
    if (reset) begin 
        in_array[0] <= 0;
        in_array[1] <= 0;
        in_array[2] <= 0;
        in_array[3] <= 0;
        in_array[4] <= 0;
        in_array[5] <= 0;
        in_array[6] <= 0;
        in_array[7] <= 0; 
        index       <= 0;
    end else begin 
        temp <= in_array[25]; // test register array input
        if ((counter > 1) && (counter < 27)) begin 
            in_array[index] <= x[15:0];
            index <= index + 1; 
        end

        if ((counter > 29) && (counter < 55)) begin 
            in_array[index] <= x[15:0];
            index <= index + 1; 
        end
    end 
end

// -----------------------------------------------------------------------------------------
// Control Mux selections for input b of adder 
// -----------------------------------------------------------------------------------------
// always @ (posedge clk or posedge reset) 
// begin 
//     if (reset) begin 

//     end else begin 
//         if (counter < 2) begin 
//             mux_sel <= 3'b100;
//         end else if (counter < 3) begin
//             mux_sel <= 3'b011; 
//         end
//     end
// end



// Combinational logic
always @* begin
	// signal for enable
	enable = i_ready;
end

// -----------------------------------------------------------------------------------------
// Pipeline stage 
// -----------------------------------------------------------------------------------------
always @ (posedge clk or posedge reset) begin
	if (reset) begin
		valid_Q1 <= 1'b0;
		valid_Q2 <= 1'b0;
		
		x <= 0;
		y_Q <= 0;
	end else if (enable) begin
		// propagate the valid value
		valid_Q1 <= i_valid;
		valid_Q2 <= valid_Q1;
        valid_Q3 <= valid_Q2;
        valid_Q4 <= valid_Q3;
        valid_Q5 <= valid_Q4;
        valid_Q6 <= valid_Q5;
        valid_Q7 <= valid_Q6;


        a_out_r1 <= a_out; 

        // test values 
        t0   <= out_array[0];
        t1   <= out_array[1];
        t2   <= out_array[2];
        t3   <= out_array[3];
        t4   <= out_array[4];
        t5   <= out_array[5];
        t6   <= out_array[6];
        t7   <= out_array[7];
        t8   <= out_array[8];
        t9   <= out_array[9];
        t10  <= out_array[10];
        t11  <= out_array[11];
        t12  <= out_array[12];
        t13  <= out_array[13];
        t14  <= out_array[14];
        t15  <= out_array[15];
        t16  <= out_array[16];
        t17  <= out_array[17];
        t18  <= out_array[18];
        t19  <= out_array[19];
        t20  <= out_array[20];
        t21  <= out_array[21];
        t22  <= out_array[22];
        t23  <= out_array[23];
        t24  <= out_array[24];
        t25  <= out_array[25];
        t26  <= out_array[26];
        t27  <= out_array[27];
        t28  <= out_array[28];
        t29  <= out_array[29];
        t30  <= out_array[30];
        t31  <= out_array[31];
        t32  <= out_array[32];
        t33  <= out_array[33];
        t34  <= out_array[34];
        t35  <= out_array[35];
        t36  <= out_array[36];
        t37  <= out_array[37];
        t38  <= out_array[38];
        t39  <= out_array[39];
        t40  <= out_array[40];
        t41  <= out_array[41];
        t42  <= out_array[42];
        t43  <= out_array[43];
        t44  <= out_array[44];
        t45  <= out_array[45];
        t46  <= out_array[46];
        t47  <= out_array[47];
        t48  <= out_array[48];
        t49  <= out_array[49];
        t50  <= out_array[50];

		// read in new x value
		x <= i_x;
		
		// output computed y value
		// y_Q <= y_D;
	end
end


// assign y_D = t_output; 
// -----------------------------------------------------------------------------------------
// Concurrent Assignments
// -----------------------------------------------------------------------------------------
// assign outputs
assign o_y = t_output;
// ready for inputs as long as receiver is ready for outputs */
assign o_ready = i_ready;   		
// the output is valid as long as the corresponding input was valid and 
//	the receiver is ready. If the receiver isn't ready, the computed output
//	will still remain on the register outputs and the circuit will resume
//  normal operation with the receiver is ready again (i_ready is high)*/
assign o_valid = t_valid ;	

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
    input  out_sel, 
	output [31:0] o_res
);

reg [47:0] result;

always @ (*) begin
	result = i_dataa * i_datab;
end

// The result of Q7.25 x Q2.14 is in the Q9.39 format. Therefore we need to change it
// to the Q7.25 format specified in the assignment by selecting the appropriate bits
// (i.e. dropping the most-significant 2 bits and least-significant 14 bits).
assign o_res = out_sel ? result[45:14] : {3'b000, result[31:3]};

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

// -----------------------------------------------------------------------------------------
// Mux Component 
// -----------------------------------------------------------------------------------------
module mux (
    input  [15:0] a, // a0 
    input  [15:0] b, // a1 
    input  [15:0] c, // a2 
    input  [15:0] d, // a3 
    input  [15:0] e, // a4 
    input  [15:0] f, // a5
    input  [2:0]  sel,
    output reg [15:0] out
);

always @ (a or b or c or d or e or f or sel) begin 
    case (sel) 
        3'b000: out <= a; 
        3'b001: out <= b; 
        3'b010: out <= c; 
        3'b011: out <= d; 
        3'b100: out <= e; 
        3'b101: out <= f; 
    endcase
end
endmodule

module mux2 (
    input [31:0] a, // P1
    input [31:0] b, // P2
    input sel, 
    output reg [31:0] out
);

always @ (a or b or sel) begin 
    case (sel) 
        1'b0: out <= a; 
        1'b1: out <= b; 
    endcase
end


endmodule

// module input_mux (
//     input  [15:0] a, // a0 
//     input  [15:0] b, // a1 
//     input  [15:0] c, // a2 
//     input  [15:0] d, // a3 
//     input  [15:0] e, // a4 
//     input  [15:0] f, // a5
//     input  [2:0]  sel,
//     output reg [15:0] out
// );

// always @ (a or b or c or d or e or f or sel) begin 
//     case (sel) 
//         3'b000: out <= a; 
//         3'b001: out <= b; 
//         3'b010: out <= c; 
//         3'b011: out <= d; 
//         3'b100: out <= e; 
//         3'b101: out <= f; 
//         3'b110: out <= g;
//         3'b111: out <= h;
//     endcase
// end

// endmodule