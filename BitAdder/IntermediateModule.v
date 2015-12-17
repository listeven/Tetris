`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:58:30 10/29/2015 
// Design Name: 
// Module Name:    IntermediateModule 
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
module IntermediateModule(
input [3:0] a,b,
input m,
output [7:0] A0, A1, A2, A3,
wire [3:0] FirstSums, temp, V, BCDSums
    );

//multiplier	          A3  
Multiplier multiply(a,b,A3);

//BCD Adder              A2
BCD bcdAdder(a,b,BCDSums, temp[1]);
assign A2[7] = 0;
assign A2[6] = 0;
assign A2[5] = temp[1];

assign A2[4] = 0;
assign A2[3] = BCDSums[3];
assign A2[2] = BCDSums[2];
assign A2[1] = BCDSums[1];
assign A2[0] = BCDSums[0];

//4Bit AdderSubtractor   A1
Verilog FourAddSubtract(a,b,m,FirstSums, temp[0], V[0]);
assign A1[7] = V[0];
assign A1[6] = 0;
assign A1[5] = temp[0];
assign A1[4] = 0;

assign A1[3] = FirstSums[3];
assign A1[2] = FirstSums[2];
assign A1[1] = FirstSums[1];
assign A1[0] = FirstSums[0];

//Buffer                 A0
assign A0[4] = a[0];
assign A0[5] = a[1];
assign A0[6] = a[2];
assign A0[7] = a[3];
assign A0[0] = b[0];
assign A0[1] = b[1];
assign A0[2] = b[2];
assign A0[3] = b[3];


endmodule
