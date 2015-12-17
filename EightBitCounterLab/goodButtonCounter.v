`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:14:55 11/12/2015 
// Design Name: 
// Module Name:    goodButtonCounter 
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
module goodButtonCounter(
input trigger,
input clk_in,
output [7:0] Y,
wire state, down, up
    );
	
	
	
PushButton_Debouncer soCool(clk_in, trigger, state, down, up);
EightCounter(state, Y);


endmodule
