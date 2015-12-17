`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:37:13 10/29/2015
// Design Name:   FourToOneMultiplexer
// Module Name:   X:/311Lab/BitAdder/testMux.v
// Project Name:  BitAdder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FourToOneMultiplexer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testMux;

	// Inputs
	reg [7:0] A0;
	reg [7:0] A1;
	reg [7:0] A2;
	reg [7:0] A3;
	reg S0;
	reg S1;

	// Outputs
	wire [7:0] Y;

	// Instantiate the Unit Under Test (UUT)
	FourToOneMultiplexer uut (
		.A0(A0), 
		.A1(A1), 
		.A2(A2), 
		.A3(A3), 
		.S0(S0), 
		.S1(S1), 
		.Y(Y)
	);

	initial begin
		// Initialize Inputs
		A0 = 'd14;
		A1 = 'd8;
		A2 = 'd4;
		A3 = 'd9;
		S0 = 0;
		S1 = 0;

		// Wait 100 ns for global reset to finish
		#100;
		end
		
		always begin
		{S0,S1} = {S0,S1} + 1;
	#1;
        
		// Add stimulus here

	end
      
endmodule

