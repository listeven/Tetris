`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:17:05 10/29/2015 
// Design Name: 
// Module Name:    MuxAdderMultiplierBCDBuffer 
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
module MuxAdderMultiplierBCDBuffer(
input [3:0] a,b,
input m, S0, S1,
output [7:0] Y,
wire [7:0] A0, A1, A2, A3
    );
IntermediateModule findAValues(a,b,m,A0, A1, A2, A3);

FourToOneMultiplexer selectOne(A0,A1,A2,A3,S0, S1, Y);

endmodule
