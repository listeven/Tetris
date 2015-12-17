`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:41:17 10/29/2015 
// Design Name: 
// Module Name:    ToFourBit 
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
module ToFourBit(
input [3:0] q,
input carry,
output [3:0] v
    );
assign v[0] = q[1];
assign v[1] = q[2];
assign v[2] = q[3];
assign v[3] = carry;	




endmodule
