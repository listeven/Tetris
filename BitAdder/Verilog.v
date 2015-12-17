`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:39:07 10/15/2015 
// Design Name: 
// Module Name:    Verilog 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////



module Verilog(
    
	 input [3:0] a,b,
	 input m,
    output [3:0] S,
	 output Cout, V,
	 wire [3:0] Bcom, C
	 //wire [0,3] C
	 /*
		for (i=0; i<4; i=i+1) begin
		toByTwoAdder whichBit[i](a=a[i], b=b[i], c=c[i])
		
		end
	  */
    );
	 Compliment comB(Bcom, b, m);
	 WholeAdder bit1(/*S,C,a,b,Cin*/S[0], C[0], a[0], Bcom[0], m);
	 WholeAdder bit2(/*S,C,a,b,Cin*/S[1], C[1], a[1], Bcom[1], C[0]);
	 WholeAdder bit3(/*S,C,a,b,Cin*/S[2], C[2], a[2], Bcom[2], C[1]);
	 WholeAdder bit4(/*S,C,a,b,Cin*/S[3], Cout, a[3], Bcom[3], C[2]);
	 assign V = C[2]^Cout;
	 
	 
	 
	 

endmodule
