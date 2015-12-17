`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:33:07 10/29/2015 
// Design Name: 
// Module Name:    FourToOneMultiplexer 
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
module FourToOneMultiplexer(
input [7:0] A0,A1,A2,A3,
input S0, S1,
output reg [7:0] Y
    );
//reg Y;
//always
//begin
always @(S1,S0)
begin
if (S1 == 0)
if (S0 == 0)
/*assign*/ Y = A0;
else /*assign*/ Y = A1;
else 
if (S0 == 0)
/*assign*/Y = A2;
else /*assign*/Y = A3;
end

endmodule
