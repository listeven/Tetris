`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:48:38 10/15/2015 
// Design Name: 
// Module Name:    Compliment 
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
module Compliment(
    output [3:0] Bcom
	 ,
	 input [3:0] b,
    input m
    
    );

	 
	 assign Bcom[0] = m^b[0];
	 assign Bcom[1] = m^b[1];
	 assign Bcom[2] = m^b[2];
	 assign Bcom[3] = m^b[3];

endmodule
