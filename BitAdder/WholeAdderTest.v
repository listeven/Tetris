`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:28:54 10/15/2015
// Design Name:   WholeAdder
// Module Name:   X:/311Lab/BitAdder/WholeAdderTest.v
// Project Name:  BitAdder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: WholeAdder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module WholeAdderTest;

	// Inputs
	reg a;
	reg b;
	reg Cin;
	
	wire S;
	wire C;
	

	// Instantiate the Unit Under Test (UUT)
	WholeAdder uut (
		.S(S),
		.C(C),
		.a(a), 
		.b(b), 
		.Cin(Cin)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 1;
		Cin = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

