`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:56:04 10/15/2015 
// Design Name: 
// Module Name:    WholeAdder 
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
module WholeAdder(S,C,a,b,Cin);
    output S, C;
	 input a, b, Cin;
    
	 //xor (S,a,b,Cin) ;
	 //or(C, and(a,Cin), and(b,Cin), and(a,b));
	 
	 
	 assign S =(a^b)^Cin;
	 assign C = Cin*a + Cin*b + a*b;
	 
	 
  //  );


endmodule
