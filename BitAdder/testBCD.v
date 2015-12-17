`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:12:08 10/22/2015
// Design Name:   BCD
// Module Name:   X:/311Lab/BitAdder/testBCD.v
// Project Name:  BitAdder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BCD
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testBCD;

	// Inputs
	reg [3:0] x;
	reg [3:0] y;
	wire [3:0] FirstSums;
	wire FirstCarry;

	// Instantiate the Unit Under Test (UUT)
	BCD uut (
		.x(x), 
		.y(y),
		.FirstSums(FirstSums),
		.FirstCarry(FirstCarry)
	);

	initial begin
		// Initialize Inputs 
		x = 4'd 5; 
		y = 4'd 6; 

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

