`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:52:24 10/29/2015
// Design Name:   Multiplier
// Module Name:   X:/311Lab/BitAdder/testMultiplier.v
// Project Name:  BitAdder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Multiplier
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testMultiplier;

	// Inputs
	reg [3:0] a;
	reg [3:0] b;

	// Outputs
	wire [7:0] S;
//wire [3:0] g;
//wire [3:0] i;
//wire [3:0] h;
	// Instantiate the Unit Under Test (UUT)
	Multiplier uut (
		.a(a), 
		.b(b), 
		.S(S)/*,
		.g(g),
		.h(h),
		.i(i)*/
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
		always begin
	{a,b} = {a,b} + 1;
	#0.2;
	end
      
		
		
endmodule

