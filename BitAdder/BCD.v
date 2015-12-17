`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:46:25 10/22/2015 
// Design Name: 
// Module Name:    BCD 
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
module BCD(
//a became x     b became y S became Q  Cout became CarryOut
input [3:0] x,y,
    output [3:0] Q,
	 output CarryOut,
	  wire /*m,*/FirstCarry, V2, V, CarryOutFake,   //V and CarryoutFake not used
	 wire [3:0] FirstSums,EitherZeroOrSix
    );
/*assign m = 0;*/
Verilog addFirst(x,y,0,FirstSums, FirstCarry, V);
assign CarryOut = (FirstSums[3]*FirstSums[2]) | (FirstSums[3]*FirstSums[1]) | (FirstCarry);

assign EitherZeroOrSix[0] = 0;
assign EitherZeroOrSix[3] = 0;
assign EitherZeroOrSix[1] = CarryOut;
assign EitherZeroOrSix[2] = CarryOut;

Verilog addSecong(EitherZeroOrSix,FirstSums,0/*m*/,Q, CarryOutFake, V2);


endmodule
