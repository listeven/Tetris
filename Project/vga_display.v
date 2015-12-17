`timescale 1ns / 1ps

module vga_display(rst, clk, R, G, B, HS, VS, R_control, G_control, B_control);
	input rst;	// Global reset to reset display
	input clk;	// 100MHz clk
	
	// Color inputs for a given pixel
	input [2:0] R_control, G_control;
	input [1:0] B_control; 
//	input button;
	// Color outputs to show on display (current pixel)
	output reg [2:0] R, G;
	output reg [1:0] B;
	// Synchronization signals
	output HS;
	output VS;
	reg [1:0] n;
	// Controls:
	wire [10:0] hcount, vcount;	// coordinates for the current pixel
	wire blank;	// signal to indicate the current coordinate is blank
	reg [3:0] count1;
reg[27:0] timer;
reg one_Hz_clk;
	reg start;
	wire [15:0] value;
	assign value = 16'h0123;
//	input reset;
	//***********************************************************************************************
	// Begin clock division for generating 25 MHz clock signal since VGA operates at 25 MHz frequency
	// Don't modelse ify
	parameter N = 2;	// Parameter for clock division
	reg clk_25Mhz;
	reg [N-1:0] count;
	always @ (posedge clk) begin
		count <= count + 1'b1;
		clk_25Mhz <= count[N-1];
	end
	// End clock division
	//*************************************************************************************************
		// Begin clock division for generating 1 Hz clock signal since VGA operates at 25 MHz frequency
	// Don't modelse ify
	initial begin
	count1=0;
	timer=0;
	start=0;
	end
/*	always @ (posedge clk) begin
	if(button ==1)
	start=1;
	if(reset==1)
	start=0;
	end*/
always @ (posedge clk) begin

timer=timer+1;
if(timer==134217727)
begin
		one_Hz_clk=1;
		timer=0;
	end
	else
	one_Hz_clk=0;
end


	// End clock division
	
	//************************************************************
	// Call VGA controller - Don't modelse ify
	vga_controller_640_60 vc(
		.rst(rst), 
		.pixel_clk(clk_25Mhz), 
		.HS(HS), 
		.VS(VS), 
		.hcounter(hcount), 
		.vcounter(vcount), 
		.blank(blank));
	//*************************************************************

	
	// Insert your logic for displaying numbers in the following code section:
	
    // Following is an example for displaying a colored box. Note that you may have to completely modelse ify the following code to display the required output.
	// Create a box:
	assign a =~blank & (hcount >= 300+(n*55) & hcount <= 500+(n*55) & vcount >= 167 & vcount <= 192);
	assign b =~blank & (hcount >= 475+(n*55) & hcount <= 500+(n*55) & vcount >= 167 & vcount <= 267);
	assign c =~blank & (hcount >= 475+(n*55) & hcount <= 500+(n*55) & vcount >= 267 & vcount <= 367);
	assign d =~blank & (hcount >= 300 +(n*55)& hcount <= 500+(n*55) & vcount >= 342 & vcount <= 367);
	assign e =~blank & (hcount >= 300+(n*55) & hcount <= 325+(n*55) & vcount >= 267 & vcount <= 367);
	assign f =~blank & (hcount >= 300+(n*55) & hcount <= 325+(n*55) & vcount >= 167 & vcount <= 267);
	assign g =~blank &(hcount >= 300+(n*55) & hcount <= 500+(n*55) & vcount >= 255 & vcount <= 280);
	/*assign figure[6]=g;
	assign figure[5]=f;
	assign figure[4]=e;
	assign figure[3]=d;
	assign figure[2]=c;
	assign figure[1]=b;
	assign figure[0]=a;*/	
	always begin @(posedge one_Hz_clk)
	n=n+1;
	if(n==0)
	count1=value[3:0];
	if(n==1)
	count1=value[7:4];
	if(n==2)
	count1=value[11:8];
	if(n==3)
	count1=value[15:12];
	 if(count1==0)
	begin
		if (a) begin	// else if you are within the valid region
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (b) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (c) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (d) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (e) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (f) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else
			begin
			R=0;
			B=0;
			G=0;
			end
	end
	else if (count1==1)
		if (b) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (c) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end 
			else begin
			R=0;
			G=0;
			B=0;
		end
			else if(count1==2)
	begin
		if (a) begin	// else if you are within the valid region
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (b) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (d) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (e) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (g) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
			
		else
			begin
			R=0;
			B=0;
			G=0;
			end
	end
	else if(count1==3)
	begin
		if (a) begin	// else if you are within the valid region
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (b) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (c) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (d) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (g) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else
			begin
			R=0;
			B=0;
			G=0;
			end
	end
	else if(count1==4)
	begin
		if (b) begin	// else if you are within the valid region
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (c) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (f) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (g) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
			else
			begin
			R=0;
			B=0;
			G=0;
			end
	end
	else if(count1==5)
	begin
		if (a) begin	// else if you are within the valid region
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (c) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (d) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (f) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (g) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else
			begin
			R=0;
			B=0;
			G=0;
			end
	end
	else if(count1==6)
	begin
		if (a) begin	// else if you are within the valid region
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (c) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (d) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (e) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (f) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (g) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else
			begin
			R=0;
			B=0;
			G=0;
			end
	end
	else if(count1==7)
	begin
		if (a) begin	// else if you are within the valid region
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (b) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (c) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else
			begin
			R=0;
			B=0;
			G=0;
			end
	end
	else if(count1==8)
	begin
		if (a) begin	// else if you are within the valid region
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (b) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (c) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (d) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (e) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (f) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
			else if (g) begin
			R=R_control;
			G=G_control;
			B=B_control;
			end
		else
			begin
			R=0;
			B=0;
			G=0;
			end
	end
		else if(count1==9)
	begin
		if (a) begin	// else if you are within the valid region
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (b) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (c) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (d) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (f) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
			else if (g) begin
			R=R_control;
			G=G_control;
			B=B_control;
			end
		else
			begin
			R=0;
			B=0;
			G=0;
			end
	end
		else if(count1==10)
	begin
		if (a) begin	// else if you are within the valid region
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (b) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (c) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (e) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (f) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
			else if (g) begin
			R=R_control;
			G=G_control;
			B=B_control;
			end
		else
			begin
			R=0;
			B=0;
			G=0;
			end
	end
		else if(count1==11)
	begin
 if (c) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (d) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (e) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (f) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
			else if (g) begin
			R=R_control;
			G=G_control;
			B=B_control;
			end
		else
			begin
			R=0;
			B=0;
			G=0;
			end
	end
		else if(count1==12)
	begin
		if (a) begin	// else if you are within the valid region
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (d) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (e) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (f) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else
			begin
			R=0;
			B=0;
			G=0;
			end
			end
				else if(count1==13)
	begin
	if (b) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (c) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (d) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (e) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
			else if (g) begin
			R=R_control;
			G=G_control;
			B=B_control;
			end
		else
			begin
			R=0;
			B=0;
			G=0;
			end
	end
		else if(count1==14)
	begin
		if (a) begin	// else if you are within the valid region
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (d) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (e) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (f) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
			else if (g) begin
			R=R_control;
			G=G_control;
			B=B_control;
			end
		else
			begin
			R=0;
			B=0;
			G=0;
			end
	end
		else if(count1==15)
	begin
		if (a) begin	// else if you are within the valid region
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (e) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
		else if (f) begin
					R = R_control;
					G = G_control;
					B = B_control;
			end
			else if (g) begin
			R=R_control;
			G=G_control;
			B=B_control;
			end
		else
			begin
			R=0;
			B=0;
			G=0;
			end
	end
	else
	begin
	R=0;
	B=0;
	G=0;
	end
	end

endmodule 