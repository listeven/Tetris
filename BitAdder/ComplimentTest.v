`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:52:32 10/15/2015
// Design Name:   Compliment
// Module Name:   X:/311Lab/BitAdder/ComplimentTest.v
// Project Name:  BitAdder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Compliment
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ComplimentTest;

	// Inputs
	wire [3:0] Bcom;
	reg m;
	reg [3:0] b;

	// Instantiate the Unit Under Test (UUT)
	Compliment uut (
		.Bcom(Bcom), 
		.m(m), 
		.b(b)
	);

	initial begin
		// Initialize Inputs
		
		m = 1;
		b[0:0] = 1;
		b[1:0] = 0;
		b[2:0] = 1;
		b[3:0] = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

