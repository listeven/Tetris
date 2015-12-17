`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:27:03 10/29/2015 
// Design Name: 
// Module Name:    And 
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
module And(
input [3:0] a,
input b,
    output [3:0] c
    );

assign c[0] = a[0]*b;
assign c[1] = a[1]*b;
assign c[2] = a[2]*b;
assign c[3] = a[3]*b;


endmodule
