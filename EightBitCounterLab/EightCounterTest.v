`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:28:44 11/12/2015
// Design Name:   EightCounter
// Module Name:   X:/311Lab/EightBitCounterLab/EightCounterTest.v
// Project Name:  EightBitCounterLab
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: EightCounter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module EightCounterTest;

	// Outputs
	wire [7:0] Y;
	reg trigger;

	// Instantiate the Unit Under Test (UUT)
	EightCounter uut (
		.trigger(trigger),
		.Y(Y)
	); 

	initial begin
		// Initialize Inputs
	
	trigger = 0;
	//Y = 0'b;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	always begin
	if (trigger ==1) trigger = 0;
	else trigger = 1;
	#1;
	end
      
endmodule

