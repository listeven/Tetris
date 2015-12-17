`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:26:46 11/12/2015 
// Design Name: 
// Module Name:    EightCounter 
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
/*
//code a modified Version of the one from the PDF for the lab, below
Lab 3 - Sequential
Design
Counters and Debouncers
Boston University*/

module EightCounter(
input trigger,
output reg [7:0] Y 
    );
	 
//initial // Initial block, used for correct simulations
initial begin Y = 0;
end


always @ (posedge trigger)
Y = Y + 1/*'b1*/;



endmodule
