`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:54:45 12/14/2015 
// Design Name: 
// Module Name:    SevSegDriver 
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
module SevSegDriver(input [15:0] big_bin, output [6:0] seven, output [3:0] AN, input clk);
		
	wire [3:0] steven;
	
	binary_to_segment (.bin(steven),.seven(seven));	
	seven_alternate (.big_bin(big_bin), .small_bin(steven), .AN(AN), .clk(clk));

		//	4 5 8 1
			
/*			big_bin[15:12] = 4;
			big_bin[11:8] = 5;
			big_bin[7:4] = 8;
			big_bin[3:0] = 1;
*/
endmodule
