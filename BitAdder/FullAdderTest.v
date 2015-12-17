`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:13:10 10/15/2015
// Design Name:   Verilog
// Module Name:   X:/311Lab/BitAdder/FullAdderTest.v
// Project Name:  BitAdder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Verilog
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FullAdderTest;

	// Inputs
	reg [3:0] a;
	reg [3:0] b;
	reg m;

	// Outputs
	wire [3:0] S;
	wire Cout;
		wire V;

	
	// Temp vars
	//wire [3:0] Sideal;
	//wire CoutIdeal;
//wire [4:0] answer;
	// Instantiate the Unit Under Test (UUT)
	Verilog uut (
		.a(a), 
		.b(b), 
		.m(m), 
		.S(S), 
		.Cout(Cout),
		.V(V)
	);  

	initial begin
		// Initialize Inputs
		
		a = 4'b0000;
		b = 4'b0000;
		/*a[0] = 1;
		a[1] = 0;
		a[2] = 1;
		a[3] = 0;
		
		b[0] = 1;
		b[1] = 0;
		b[2] = 1;
		b[3] = 0;
		*/
		m = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here 

	end
   always begin

		#1;
		
		//if(m==0)
		//{CoutIdeal, Sideal} = {CoutIdeal, Sideal}+1;		
		//else
      //{CoutIdeal, Sideal} = {CoutIdeal, Sideal}-1;		
		
	//	if(m==0)
	//	answer = answer+1;
	//	else
	//	answer = answer}-1;
	
		{m,a,b} = {m,a,b}+1;
	end   
endmodule

