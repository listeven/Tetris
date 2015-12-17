`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:39:58 10/23/2015
// Design Name:   BCD
// Module Name:   X:/311Lab/BitAdder/BCDsimulate.v
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

module BCDsimulate;

	// Inputs
	reg [3:0] x;
	reg [3:0] y;

	// Outputs
	wire [3:0] Q;
	wire CarryOut;

	// Instantiate the Unit Under Test (UUT)
	BCD uut (
		.x(x), 
		.y(y), 
		.Q(Q), 
		.CarryOut(CarryOut)
	);

	initial begin
		// Initialize Inputs
		x = 0;
		y = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	always begin
	{x,y} = {x,y} + 1;
	#1;
	end
      
endmodule

