`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:21:48 10/29/2015
// Design Name:   MuxAdderMultiplierBCDBuffer
// Module Name:   X:/311Lab/BitAdder/testMuxAddSubMulBuff.v
// Project Name:  BitAdder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MuxAdderMultiplierBCDBuffer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testMuxAddSubMulBuff;

	// Inputs
	reg [3:0] a;
	reg [3:0] b;
	reg m;
	reg S0;
	reg S1;

	// Outputs
	wire [7:0] Y;

	// Instantiate the Unit Under Test (UUT)
	MuxAdderMultiplierBCDBuffer uut (
		.a(a), 
		.b(b), 
		.m(m), 
		.S0(S0), 
		.S1(S1), 
		.Y(Y)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		m = 0;
		S0 = 0;
		S1 = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
		always begin
	{S1,S0,b,a} = {S1,S0,b,a} + 1;
	#0.2;
	end
		
		
		
endmodule

