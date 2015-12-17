`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Zafar M. Takhirov
// 
// Create Date:    12:59:40 04/12/2011 
// Design Name: EC311 Support Files
// Module Name:    vga_display 
// Project Name: Lab5 / Lab6 / Project
// Target Devices: xc6slx16-3csg324
// Tool versions: XILINX ISE 13.3
// Description: 
//
// Dependencies: vga_controller_640_60
//
// Revision: 
// Revision 0.01 - File Created 
// Additional Comments:  
// 
//////////////////////////////////////////////////////////////////////////////////
module vga_display(workingTetris,singleBlock, resetAll, rstR,up,down,left,right, clk, R, G, B, HS, VS, seven, AN);
	input workingTetris;
	input singleBlock;
	
	input resetAll;
	input rstR,up,down,left,right;	// global reset
	input clk;	// 100MHz clk
		
		
		
	// color outputs to show on display (current pixel)
	output reg [2:0] R, G;
	output reg [1:0] B;
	
	// Synchronization signals
	output HS;
	output VS; 
	
	
	wire [2:0] R1, G1;
	wire [1:0] B1; 
	
	output [6:0] seven;
	output [3:0] AN;
	// controls:
	wire [10:0] hcount, vcount;	// coordinates for the current pixel
	wire blank;	// signal to indicate the current coordinate is blank
	wire figure;	// the figure you want to display
	
	reg switch;
	initial switch = 0;
	
	reg rst;
	initial rst = 0;
	
	// memory interface: 
	wire [14:0] addra;
	wire [7:0] douta;
	
//	reg upBounce, downBounce, leftBounce, rightBounce;
	
	wire yAdd, xAdd,change;
	
	reg [10:0] xMemory, yMemory;
	reg [2:0] changeOld;
	
	reg resetFig;
	
	reg slow_clk;	
		reg [25:0] slow_count;	
	always @ (posedge clk)begin
		slow_count = slow_count + 1'b1;	
		slow_clk = slow_count[23];
	end	
	reg slow_clk2;	
		reg [24:0] slow_count2;	
	always @ (posedge clk)begin
		slow_count2 = slow_count2 + 1'b1;	
		slow_clk2 = slow_count2[22];
	end
	
	/*
	reg slow_clk3;	
		reg [22:0] slow_count3;	
	always @ (posedge clk)begin
		slow_count3 = slow_count3 + 1'b1;	
		slow_clk3 = slow_count3[20];
	end	
*/
	
	
	//reg upBounce, downBounce, leftBounce, rightBounce;
	
	initial big_bin = 0;
	
	reg [15:0] big_bin;  //(input)
	
	always @(posedge slow_clk2)begin
	//big_bin = big_bin + 10;
	end
	
	SevSegDriver sevenDisplay(.big_bin(big_bin), .seven(seven), .AN(AN), .clk(clk));
		
	
	//reg changeCLK;
	/////////////////////////////////////////////////////
	// Begin clock division
	parameter N = 2;	// parameter for clock division
	reg clk_25Mhz;
	reg [N-1:0] count;
	/*initial xAdd = 0;
	initial yAdd = 0;*/
	initial count = 0;
	initial R = 0; 
	initial G = 0;
	initial B = 0;
	
	
	initial xMemory = 0;
	initial yMemory = 0;
	
	 
	
	reg [5:0] row1,coL1;
	always @ (posedge clk)begin
	if(yMemory<500) 	 begin row1 = 19; end
	if(yMemory<440) 	 begin row1 = 18; end
	if(yMemory<420) 	 begin row1 = 17; end
	if(yMemory<400) 	 begin row1 = 16; end
	if(yMemory<380) 	 begin row1 = 15; end
	if(yMemory<360) 	 begin row1 = 14; end
	if(yMemory<340) 	 begin row1 = 13; end
	if(yMemory<320) 	 begin row1 = 12; end
	if(yMemory<300) 	 begin row1 = 11; end
	if(yMemory<280) 	 begin row1 = 10; end
	if(yMemory<260) 	 begin row1 = 9; end
	if(yMemory<240) 	 begin row1 = 8; end
	if(yMemory<220) 	 begin row1 = 7; end
	if(yMemory<200) 	 begin row1 = 6; end
	if(yMemory<180) 	 begin row1 = 5; end
	if(yMemory<160) 	 begin row1 = 4; end
	if(yMemory<140) 	 begin row1 = 3; end
	if(yMemory<120) 	 begin row1 = 2; end
	if(yMemory<100) 	 begin row1 = 1; end
	if(yMemory<80) 	 begin row1 = 0; end
	//if(yMemory<70) 	 begin row1 = 20; end
	//if(yMemory<60) 	 begin row1 = 0; end
	//if(yMemory<40) 	 begin row1 = 1; end
	//if(yMemory<20) 	 begin row1 = 0; end 
	end
	
	always @ (posedge clk)begin
	if(xMemory<220) 	 begin coL1 = 9; end
	if(xMemory<200) 	 begin coL1 = 8; end
	if(xMemory<180) 	 begin coL1 = 7; end
	if(xMemory<160) 	 begin coL1 = 6; end
	if(xMemory<140) 	 begin coL1 = 5; end
	if(xMemory<120) 	 begin coL1 = 4; end
	if(xMemory<100) 	 begin coL1 = 3; end
	if(xMemory<80) 	 begin coL1 = 2; end
	if(xMemory<60) 	 begin coL1 = 1; end
	if(xMemory<40) 	 begin coL1 = 0; end
	//if(xMemory<200) 	 begin coL1 = 9; end
	//if(xMemory<200) 	 begin coL1 = 9; end
	
	end
	
	
	
	always @ (posedge clk) begin
		count <= count + 1'b1;
		clk_25Mhz <= count[N-1];
	end
	// End clock division
	/////////////////////////////////////////////////////
	
	// Call driver
	vga_controller_640_60 vc(
		.rst(rst), 
		/*
		.up(up),
		.down(down),
		.left(left),
		.right(right),
		*/
		.pixel_clk(clk_25Mhz), 
		.HS(HS), 
		.VS(VS), 
		.hcounter(hcount), 
		.vcounter(vcount), 
		.blank(blank)
	);
	
	//reg switch;
	//initial switch = 0;
	
	vga_bsprite sprites_mem(
		.x0(0+100), 
		.y0(0+100),
		.x1(343+100),
		.y1(47+100), 
		.hc(hcount), 
		.vc(vcount), 
		.mem_value(douta), 
		.rom_addr(addra), 
		.R(R1), 
		.G(G1), 
		.B(B1), 
		.blank(blank),
		.switch(switch)
	);
	
	
	game_over_mem memory_1 (
		.clka(clk_25Mhz), // input clka
		.addra(addra), // input [14 : 0] addra
		.douta(douta) // output [7 : 0] douta
	);
	
	
	
	
	
	
	reg increaseScore;
	initial increaseScore = 0;
	always @(posedge slow_clk2)begin
	if(resetAll) begin
	big_bin = 0;
	end
	else if (increaseScore & (yMemory == 0))begin
	
	big_bin = big_bin + 10;
	end
	end
	
		
	reg clearLineHappened;
	initial clearLineHappened = 0;
	/////module aBlock(clearLineHappened,hcount, vcount, clk,blank,xMemory,yMemory,placed,border,slow_clk2,placeBlockNotOk,row1,coL1, r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,     noR, noL, noD,resetFig);
	
	wire figure1,figure2,figure3,figure4,figure5,figure6,figure7,figure8,figure9,figure10,figure11,testerR1,testerR2,testerR3,testerR4,testerR5,testerR6,testerR7,testerR8,testerR9,testerR10,testerR11,testerL1,testerL2,testerL3,testerL4,testerL5,testerL6,testerL7,testerL8,testerL9,testerL10,testerL11;
	wire testerD1,testerD2,testerD3,testerD4,testerD5,testerD6,testerD7,testerD8,testerD9,testerD10,testerD11, tester1,tester2,tester3,tester4,tester5,tester6,tester7,tester8,tester9,tester10,tester11;
	wire noR1,noR2,noR3,noR4,noR5,noR6,noR7,noR8,noR9,noR10,noR11,noL1,noL2,noL3,noL4,noL5,noL6,noL7,noL8,noL9,noL10,noL11,noD1,noD2,noD3,noD4,noD5,noD6,noD7,noD8,noD9,noD10,noD11;
	wire figure1f,figure2f,figure3f,figure4f,figure5f,figure6f,figure7f,figure8f,figure9f,figure10f,figure11f;
	
	
	
	aBlock firstBlock(clearLineHappened, hcount, vcount, clk,blank,xMemory,yMemory,placed,border,slow_clk2,  	    placeBlockNotOk1,row1,coL1, noR1, noL1, noD1,resetFig1,figure1,testerR1,testerL1,testerD1,tester1,figure1f);
	aBlock secondBlock(clearLineHappened, hcount, vcount, clk,blank,(xMemory-20),yMemory,placed,border,slow_clk2,   placeBlockNotOk1,(row1-1),coL1, noR2, noL2, noD2,resetFig2,figure2,testerR2,testerL2,testerD2,tester2,figure2f);
	aBlock thirdBlock(clearLineHappened, hcount, vcount, clk,blank,xMemory,(yMemory-20),placed,border,slow_clk2,   placeBlockNotOk1,row1,(coL1-1),  noR3, noL3, noD3,resetFig3,figure3,testerR3,testerL3,testerD3,tester3,figure3f);
	aBlock fourthBlock(clearLineHappened, hcount, vcount, clk,blank,(xMemory+20),yMemory,placed,border,slow_clk2,   placeBlockNotOk1,(row1+1),coL1, noR4, noL4, noD4,resetFig4,figure4,testerR4,testerL4,testerD4,tester4,figure4f);
	aBlock fifthBlock(clearLineHappened, hcount, vcount, clk,blank,(xMemory-20),(yMemory-20),placed,border,slow_clk2,   placeBlockNotOk1,(row1-1),(coL1-1), noR5, noL5, noD5,resetFig5,figure5,testerR5,testerL5,testerD5,tester5,figure5f);
	aBlock sixthBlock(clearLineHappened, hcount, vcount, clk,blank,(xMemory+20),(yMemory-20),placed,border,slow_clk2,   placeBlockNotOk1,(row1+1),(coL1-1), noR6, noL6, noD6,resetFig6,figure6,testerR6,testerL6,testerD6,tester6,figure6f);
	aBlock seventh(clearLineHappened, hcount, vcount, clk,blank,(xMemory-40),yMemory,placed,border,slow_clk2,     placeBlockNotOk1,(row1-2),coL1, noR7, noL7, noD7,resetFig7,figure7,testerR7,testerL7,testerD7,tester7,figure7f);
	
	aBlock eighth(clearLineHappened, hcount, vcount, clk,blank,(xMemory-20),(yMemory+20),placed,border,slow_clk2,     placeBlockNotOk1,(row1-1),(coL1+1), noR8, noL8, noD8,resetFig8,figure8,testerR8,testerL8,testerD8,tester8,figure8f);
	aBlock ninth(clearLineHappened, hcount, vcount, clk,blank,xMemory,(yMemory+20),placed,border,slow_clk2,     placeBlockNotOk1,row1,(coL1+1), noR9, noL9, noD9,resetFig9,figure9,testerR9,testerL9,testerD9,tester9,figure9f);
	aBlock tenth(clearLineHappened, hcount, vcount, clk,blank,xMemory,(yMemory-40),placed,border,slow_clk2,     placeBlockNotOk1,row1,(coL1-2), noR10, noL10, noD10,resetFig10,figure10,testerR10,testerL10,testerD10,tester10,figure10f);
	aBlock eleventh(clearLineHappened, hcount, vcount, clk,blank,(xMemory+20),(yMemory+20),placed,border,slow_clk2,     placeBlockNotOk1,(row1+1),(coL1+1), noR11, noL11, noD11,resetFig11,figure11,testerR11,testerL11,testerD11,tester11,figure11f);
	
	reg[11:0] on;
	initial on = 0;
	
	assign figure = (!singleBlock & (figure1||figure2&on[2]||figure3&on[3]||figure4&on[4]||figure5&on[5]||figure6&on[6]||figure7&on[7]|| figure8&on[8]||figure9&on[9]||figure10&on[10]||figure11&on[11] ))  ||(singleBlock & ~blank & (hcount >= xMemory & hcount <= 20+xMemory & vcount >= -20+yMemory & vcount <= 0+yMemory)); 
	assign figuref = (!singleBlock & (figure1f||figure2f&on[2]||figure3f&on[3]||figure4f&on[4]||figure5f&on[5]||figure6f&on[6]||figure7f&on[7]|| figure8f&on[8]||figure9f&on[9]||figure10f&on[10]||figure11f&on[11]));
	
	
	assign testerR = (!singleBlock & ((testerR1||testerR2&on[2]||testerR3&on[3]||testerR4&on[4]||testerR5&on[5]||testerR6&on[6]||testerR7&on[7]||testerR8&on[8]||testerR9&on[9]||testerR10&on[10]||testerR11&on[11])&(!figure)) ) ||(singleBlock & ~blank & (hcount > 20+xMemory & hcount < 40+xMemory & vcount >= -20+yMemory & vcount <= 0+yMemory));
	assign testerL = (!singleBlock & ((testerL1||testerL2&on[2]||testerL3&on[3]||testerL4&on[4]||testerL5&on[5]||testerL6&on[6]||testerL7&on[7]||testerL8&on[8]||testerL9&on[9]||testerL10&on[10]||testerL11&on[11])&(!figure)) ) ||(singleBlock & ~blank & (hcount > xMemory -20 & hcount < xMemory & vcount >= -20+yMemory & vcount <= 0+yMemory));
	assign testerD = (!singleBlock & ((testerD1||testerD2&on[2]||testerD3&on[3]||testerD4&on[4]||testerD5&on[5]||testerD6&on[6]||testerD7&on[7]||testerD8&on[8]||testerD9&on[9]||testerD10&on[10]||testerD11&on[11])&(!figure)))  ||(singleBlock & ~blank & (hcount > xMemory & hcount < 20+xMemory & vcount > yMemory & vcount < 44+yMemory));
	assign tester = (!singleBlock & ((tester1||tester2&on[2]||tester3&on[3]||tester4&on[4]||tester5&on[5]||tester6&on[6]||tester7&on[7]||tester8&on[8]||tester9&on[9]||tester10&on[10]||tester11&on[11])&(!figure)))  ||(singleBlock & ~blank & (hcount > xMemory+5 & hcount < 15+xMemory  & vcount > yMemory & vcount < 10+yMemory));   
	
	
/*
	 assign testerR = ~blank & (hcount > 20+xMemory & hcount < 40+xMemory & vcount >= -20+yMemory & vcount <= 0+yMemory);
	 assign testerL = ~blank & (hcount > xMemory -20 & hcount < xMemory & vcount >= -20+yMemory & vcount <= 0+yMemory);
	 assign testerD = ~blank & (hcount > xMemory & hcount < 20+xMemory & vcount > yMemory & vcount < 24+yMemory);
	 
	 assign tester = ~blank & (hcount > xMemory+5 & hcount < 15+xMemory  & vcount > yMemory & vcount < 10+yMemory);   

	
	
	 assign figure = singleBlock & ~blank & (hcount >= xMemory & hcount <= 20+xMemory & vcount >= -20+yMemory & vcount <= 0+yMemory);

	 assign testerR = singleBlock & ~blank & (hcount > 20+xMemory & hcount < 40+xMemory & vcount >= -20+yMemory & vcount <= 0+yMemory);
	 assign testerL = singleBlock & ~blank & (hcount > xMemory -20 & hcount < xMemory & vcount >= -20+yMemory & vcount <= 0+yMemory);
	 assign testerD = singleBlock & ~blank & (hcount > xMemory & hcount < 20+xMemory & vcount > yMemory & vcount < 24+yMemory);
	 
	 assign tester = singleBlock & ~blank & (hcount > xMemory+5 & hcount < 15+xMemory  & vcount > yMemory & vcount < 10+yMemory);   
	*/
	
	
//	initial assign on[2]=1;assign  on[3]=1;assign  on[4]=1;

reg [2:0] pieceChosen;
initial pieceChosen = 0;
always @(posedge slow_clk2) begin
pieceChosen =pieceChosen +1; 
if(left)begin
pieceChosen =pieceChosen +2;
end

if(right)begin
pieceChosen =pieceChosen +3;
end


if(down)begin
pieceChosen =pieceChosen -1;
end

end

reg [7:0] pieceNumber;
initial pieceNumber=1;

always @(posedge clk) begin
if(pieceNumber == 1) begin on[2]=1; on[3]=1; on[4]=0; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 1; on[7] = 0; on[8] = 0;on[9] = 0;on[10] = 0;on[11] = 0; end
if(pieceNumber == 2) begin on[2]=0; on[3]=1; on[4]=1; on[0]=0; on[1] = 0; on[5] = 1; on[6] = 0; on[7] = 0; on[8] = 0;on[9] = 0;on[10] = 0;on[11] = 0;  end
if(pieceNumber == 3) begin  on[2]=1; on[3]=0; on[4]=1; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 0; on[7] = 1; on[8] = 0;on[9] = 0;on[10] = 0;on[11] = 0; end
if(pieceNumber == 4) begin  on[2]=1; on[3]=1; on[4]=0; on[0]=0; on[1] = 0; on[5] = 1; on[6] = 0; on[7] = 0; on[8] = 0;on[9] = 0;on[10] = 0;on[11] = 0; end

if(pieceNumber == 5) begin  on[2]=1; on[3]=0; on[4]=1; on[0]=0; on[1] = 0; on[5] = 1; on[6] = 0; on[7] = 0; on[8] = 0;on[9] = 0;on[10] = 0;on[11] = 0; end
if(pieceNumber == 6) begin on[2]=1; on[3]=0; on[4]=1; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 1; on[7] = 0; on[8] = 0;on[9] = 0;on[10] = 0;on[11] = 0;  end
if(pieceNumber == 7) begin on[2]=1; on[3]=1; on[4]=1; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 0; on[7] = 0; on[8] = 0;on[9] = 0;on[10] = 0;on[11] = 0;  end

if(pieceNumber == 9) begin on[2]=1; on[3]=0; on[4]=0; on[0]=0; on[1] = 0; on[5] = 1; on[6] = 0; on[7] = 0; on[8] = 0;on[9] = 1;on[10] = 0;on[11] = 0; end  //1rotate once
if(pieceNumber == 10) begin on[2]=1; on[3]=1; on[4]=0; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 0; on[7] = 0; on[8] = 1;on[9] = 0;on[10] = 0;on[11] = 0;  end  //2rotate once
if(pieceNumber == 11) begin on[2]=0; on[3]=1; on[4]=0; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 0; on[7] = 0; on[8] = 0;on[9] = 1;on[10] = 1;on[11] = 0;  end  //3rotate once

if(pieceNumber == 12) begin on[2]=0; on[3]=1; on[4]=0; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 0; on[7] = 0; on[8] = 1;on[9] = 1;on[10] = 0;on[11] = 0;  end  //5rotate once
if(pieceNumber == 13) begin on[2]=1; on[3]=0; on[4]=1; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 0; on[7] = 0; on[8] = 0;on[9] = 0;on[10] = 0;on[11] = 1;  end //5rotate 2
if(pieceNumber == 14) begin on[2]=0; on[3]=1; on[4]=0; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 1; on[7] = 0; on[8] = 0;on[9] = 1;on[10] = 0;on[11] = 0;  end //5rotate 3

if(pieceNumber == 15) begin on[2]=0; on[3]=1; on[4]=0; on[0]=0; on[1] = 0; on[5] = 1; on[6] = 0; on[7] = 0; on[8] = 0;on[9] = 1;on[10] = 0;on[11] = 0;  end //6rotate once
if(pieceNumber == 16) begin on[2]=1; on[3]=0; on[4]=1; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 0; on[7] = 0; on[8] = 1;on[9] = 0;on[10] = 0;on[11] = 0;  end //6rotate 2
if(pieceNumber == 17) begin on[2]=0; on[3]=1; on[4]=0; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 0; on[7] = 0; on[8] = 0;on[9] = 1;on[10] = 0;on[11] = 1;  end //6rotate 3

if(pieceNumber == 18) begin on[2]=1; on[3]=1; on[4]=0; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 0; on[7] = 0; on[8] = 0;on[9] = 1;on[10] = 0;on[11] = 0;  end //7rotate once
if(pieceNumber == 19) begin on[2]=1; on[3]=0; on[4]=1; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 0; on[7] = 0; on[8] = 0;on[9] = 1;on[10] = 0;on[11] = 0;  end //7rotate 2
if(pieceNumber == 20) begin on[2]=0; on[3]=1; on[4]=1; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 0; on[7] = 0; on[8] = 0;on[9] = 1;on[10] = 0;on[11] = 0;  end //7rotate 3

end



	 
	always @(posedge slow_clk2) begin
	 //on[2]=1; on[3]=1; on[4]=1; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 0; on[7] = 0;     //T shaped block
	 if(yMemory==0) begin
if(!singleBlock) begin	
if(pieceChosen==1) begin	 pieceNumber=1;   end  //..^^
	if(pieceChosen==2) begin	pieceNumber=2; end//^^..
	if(pieceChosen==3) begin	 pieceNumber=3; end//  ....
	if(pieceChosen==4) begin	pieceNumber=4; end//big square
	
	if(pieceChosen==5) begin	  pieceNumber=5; end//  ^...
	if(pieceChosen==6) begin	 pieceNumber=6; end// ...^
	if(pieceChosen==7) begin	  pieceNumber=7; end //T shaped block
	end	
	
	
/*if(singleBlock) begin		
	on[2]=0; on[3]=0; on[4]=0; on[0]=0; on[1] = 0; on[5] = 0; on[6] = 0; on[7] = 0;     //single block
end*/
end


	if(rstR&(pieceNumber==1)) begin
	pieceNumber = 9;
	end
	else if(rstR&(pieceNumber==9)) begin
	pieceNumber = 1;
	end
	
	else if(rstR&(pieceNumber==2)) begin
	pieceNumber = 10;
	end
	else if(rstR&(pieceNumber==10)) begin
	pieceNumber = 2;
	end
	
	else if(rstR&(pieceNumber==3)) begin
	pieceNumber = 11;
	end
	else if(rstR&(pieceNumber==11)) begin
	pieceNumber = 3;
	end
	
else if(rstR&(pieceNumber==5)) begin
	pieceNumber = 12;
	end
	else if(rstR&(pieceNumber==12)) begin
	pieceNumber = 13;
	end
	else if(rstR&(pieceNumber==13)) begin
	pieceNumber = 14;
	end
	else if(rstR&(pieceNumber==14)) begin
	pieceNumber = 5;
	end

else if(rstR&(pieceNumber==6)) begin
	pieceNumber = 15;
	end
	else if(rstR&(pieceNumber==15)) begin
	pieceNumber = 16;
	end
	else if(rstR&(pieceNumber==16)) begin
	pieceNumber = 17;
	end
	else if(rstR&(pieceNumber==17)) begin
	pieceNumber = 6;
	end
	
else if(rstR&(pieceNumber==7)) begin
	pieceNumber = 18;
	end
	else if(rstR&(pieceNumber==18)) begin
	pieceNumber = 19;
	end
	else if(rstR&(pieceNumber==19)) begin
	pieceNumber = 20;
	end
	else if(rstR&(pieceNumber==20)) begin
	pieceNumber = 7;
	end
	
	//noR = (!singleBlock & (noR1||noR2&on[2]||noR3&on[3]||noR4&on[4]||noR5&on[5]||noR6&on[6]||noR7&on[7]))    ||  (singleBlock & noRsingle );
	//noL = (!singleBlock & (noL1||noL2&on[2]||noL3&on[3]||noL4&on[4]||noL5&on[5]||noL6&on[6]||noL7&on[7]))    ||  (singleBlock & noLsingle ); 
	//noD = (!singleBlock & (noD1||noD2&on[2]||noD3&on[3]||noD4&on[4]||noD5&on[5]||noD6&on[6]||noD7&on[7]))    ||  (singleBlock & noDsingle );
	
	noR = noRsingle;
	noL = noLsingle;
	noD = noDsingle;
	
	//resetFig = resetFig1||resetFig2||resetFig3||resetFig4;
	
	
	
	
	
	
	if(yMemory==0)begin
//placeBlockNotOk = 0;
//resetFig = 0;
//clearLineHappened = 0;
//noR = 0;
//noL = 0;

//countResets = 0;
//r19[4] = 1;
end	 
	
	
	end
	
	reg noD, noR, noL;


//if left&~noR

initial noR =0; initial noL =0;
	
	
	
/*	
	Movement move1(up, down, left, right,clk,xAdd,yAdd,change);
	
	always @ (posedge clk) begin
	if (change!=changeOld)begin
	xMemory = xMemory + xAdd;
	yMemory = yMemory + yAdd;
	changeOld = change;end
	end
*/
/* 
wire upBounce, downBounce, leftBounce, rightBounce;


PushButton_Debouncer upMaybe(clk,up,PB_state,PB_down,upBounce);
PushButton_Debouncer downMaybe(clk,down,PB_state1,PB_down1,downBounce);
PushButton_Debouncer rightMaybe(clk,right,PB_state2,PB_down2,rightBounce);
PushButton_Debouncer leftMaybe(clk,left,PB_state3,PB_down3,leftBounce);
*/

/*

always @(posedge slow_clk2) begin
if (up) begin
yMemory = yMemory -10; end
if (down) begin
yMemory = yMemory +10; end
if (right) begin 
xMemory = xMemory +10; end
if (left) begin
xMemory = xMemory -10; end

//moves block down
if(yMemory < 100)begin
yMemory = yMemory + 10;
end



end */
/*
always @(posedge upBounce , posedge downBounce) begin
if (downBounce)
yMemory = yMemory +1;
else 
yMemory = yMemory -1;
 end

 always @(posedge rightBounce , posedge leftBounce) begin 
if (rightBounce)
xMemory = xMemory -1;
else 
xMemory = xMemory +1;
 end
 
 */
	//TF's code for box below
//	assign figure = ~blank & (hcount >= 300 & hcount <= 500 & vcount >= 167 & vcount <= 367);



	                                                                                                                                                             
	/* assign figure2 = ~blank & (hcount >= 50+xMemory & hcount <= 55+xMemory & vcount >= 10+yMemory & vcount <= 20+yMemory);
	 assign figure3 = ~blank & (hcount >= 56+xMemory & hcount <= 66+xMemory & vcount >= 10+yMemory & vcount <= 20+yMemory);
	 assign figure4 = ~blank & (hcount >= 100+xMemory & hcount <= 140+xMemory & vcount >= 10+yMemory & vcount <= 20+yMemory);
	 assign figure5 = ~blank & (hcount >= 30+xMemory & hcount <= 40+xMemory & vcount >= 110+yMemory & vcount <= 210+yMemory);
	 assign figure6 = ~blank & (hcount >= 30+xMemory & hcount <= 40+xMemory & vcount >= 211+yMemory & vcount <= 220+yMemory);
	 assign figure7 = ~blank & (hcount >= 30+xMemory & hcount <= 40+xMemory & vcount >= 40+yMemory & vcount <= 50+yMemory);
    // send colors:
	 */
//	reg [20:10] RC;
	reg [10:0] r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19;
	//wire w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26, w27, w28, w29, w30, w31, w32, w33, w34, w35, w36, w37, w38, w39, w40, w41, w42, w43, w44, w45, w46, w47, w48, w49, w50;
	wire w51, w52, w53, w54, w55, w56, w57, w58, w59, w60, w61, w62, w63, w64, w65, w66, w67, w68, w69, w70, w71, w72, w73, w74, w75, w76, w77, w78, w79, w80, w81, w82, w83, w84, w85, w86, w87, w88, w89, w90, w91, w92, w93, w94, w95, w96, w97, w98, w99;
	wire w100, w101, w102, w103, w104, w105, w106, w107, w108, w109, w110, w111, w112, w113, w114, w115, w116, w117, w118, w119, w120, w121, w122, w123, w124, w125, w126, w127, w128, w129, w130, w131, w132, w133, w134, w135, w136, w137, w138, w139, w140, w141;
	wire w142, w143, w144, w145, w146, w147, w148, w149, w150, w151, w152, w153, w154, w155, w156, w157, w158, w159, w160, w161, w162, w163, w164, w165, w166, w167, w168, w169, w170, w171, w172, w173, w174, w175, w176, w177, w178, w179, w180, w181, w182; 
	wire w183, w184, w185, w186, w187, w188, w189, w190, w191, w192, w193, w194, w195, w196, w197, w198, w199;
	wire wcountTest;
	
	//RC[3:4]
	
assign w0= r0[0]; assign w10= r1[0]; assign w20= r2[0]; assign w30= r3[0]; assign w40= r4[0]; assign w50= r5[0]; assign w60= r6[0]; assign w70= r7[0]; assign w80= r8[0]; assign w90= r9[0]; assign w100= r10[0]; assign w110= r11[0]; assign w120= r12[0]; assign w130= r13[0]; assign w140= r14[0]; assign w150= r15[0]; assign w160= r16[0]; assign w170= r17[0]; assign w180= r18[0]; assign w190= r19[0];                                                                                                  
assign w1= r0[1]; assign w11= r1[1]; assign w21= r2[1]; assign w31= r3[1]; assign w41= r4[1]; assign w51= r5[1]; assign w61= r6[1]; assign w71= r7[1]; assign w81= r8[1]; assign w91= r9[1]; assign w101= r10[1]; assign w111= r11[1]; assign w121= r12[1]; assign w131= r13[1]; assign w141= r14[1]; assign w151= r15[1]; assign w161= r16[1]; assign w171= r17[1]; assign w181= r18[1]; assign w191= r19[1];                                                                                                  
assign w2= r0[2]; assign w12= r1[2]; assign w22= r2[2]; assign w32= r3[2]; assign w42= r4[2]; assign w52= r5[2]; assign w62= r6[2]; assign w72= r7[2]; assign w82= r8[2]; assign w92= r9[2]; assign w102= r10[2]; assign w112= r11[2]; assign w122= r12[2]; assign w132= r13[2]; assign w142= r14[2]; assign w152= r15[2]; assign w162= r16[2]; assign w172= r17[2]; assign w182= r18[2]; assign w192= r19[2];                                                                                                  
assign w3= r0[3]; assign w13= r1[3]; assign w23= r2[3]; assign w33= r3[3]; assign w43= r4[3]; assign w53= r5[3]; assign w63= r6[3]; assign w73= r7[3]; assign w83= r8[3]; assign w93= r9[3]; assign w103= r10[3]; assign w113= r11[3]; assign w123= r12[3]; assign w133= r13[3]; assign w143= r14[3]; assign w153= r15[3]; assign w163= r16[3]; assign w173= r17[3]; assign w183= r18[3]; assign w193= r19[3];                                                                                                  
assign w4= r0[4]; assign w14= r1[4]; assign w24= r2[4]; assign w34= r3[4]; assign w44= r4[4]; assign w54= r5[4]; assign w64= r6[4]; assign w74= r7[4]; assign w84= r8[4]; assign w94= r9[4]; assign w104= r10[4]; assign w114= r11[4]; assign w124= r12[4]; assign w134= r13[4]; assign w144= r14[4]; assign w154= r15[4]; assign w164= r16[4]; assign w174= r17[4]; assign w184= r18[4]; assign w194= r19[4];                                                                                                  
assign w5= r0[5]; assign w15= r1[5]; assign w25= r2[5]; assign w35= r3[5]; assign w45= r4[5]; assign w55= r5[5]; assign w65= r6[5]; assign w75= r7[5]; assign w85= r8[5]; assign w95= r9[5]; assign w105= r10[5]; assign w115= r11[5]; assign w125= r12[5]; assign w135= r13[5]; assign w145= r14[5]; assign w155= r15[5]; assign w165= r16[5]; assign w175= r17[5]; assign w185= r18[5]; assign w195= r19[5];                                                                                                  
assign w6= r0[6]; assign w16= r1[6]; assign w26= r2[6]; assign w36= r3[6]; assign w46= r4[6]; assign w56= r5[6]; assign w66= r6[6]; assign w76= r7[6]; assign w86= r8[6]; assign w96= r9[6]; assign w106= r10[6]; assign w116= r11[6]; assign w126= r12[6]; assign w136= r13[6]; assign w146= r14[6]; assign w156= r15[6]; assign w166= r16[6]; assign w176= r17[6]; assign w186= r18[6]; assign w196= r19[6];                                                                                                  
assign w7= r0[7]; assign w17= r1[7]; assign w27= r2[7]; assign w37= r3[7]; assign w47= r4[7]; assign w57= r5[7]; assign w67= r6[7]; assign w77= r7[7]; assign w87= r8[7]; assign w97= r9[7]; assign w107= r10[7]; assign w117= r11[7]; assign w127= r12[7]; assign w137= r13[7]; assign w147= r14[7]; assign w157= r15[7]; assign w167= r16[7]; assign w177= r17[7]; assign w187= r18[7]; assign w197= r19[7];                                                                                                  
assign w8= r0[8]; assign w18= r1[8]; assign w28= r2[8]; assign w38= r3[8]; assign w48= r4[8]; assign w58= r5[8]; assign w68= r6[8]; assign w78= r7[8]; assign w88= r8[8]; assign w98= r9[8]; assign w108= r10[8]; assign w118= r11[8]; assign w128= r12[8]; assign w138= r13[8]; assign w148= r14[8]; assign w158= r15[8]; assign w168= r16[8]; assign w178= r17[8]; assign w188= r18[8]; assign w198= r19[8];                                                                                                  
assign w9= r0[9]; assign w19= r1[9]; assign w29= r2[9]; assign w39= r3[9]; assign w49= r4[9]; assign w59= r5[9]; assign w69= r6[9]; assign w79= r7[9]; assign w89= r8[9]; assign w99= r9[9]; assign w109= r10[9]; assign w119= r11[9]; assign w129= r12[9]; assign w139= r13[9]; assign w149= r14[9]; assign w159= r15[9]; assign w169= r16[9]; assign w179= r17[9]; assign w189= r18[9]; assign w199= r19[9];            
	
/*
assign w0 = RC[0:0];                                                                                                                                                                                                                                     
assign w1 = RC[0:1];assign w2 = RC[0:2];assign w3 = RC[0:3];assign w4 = RC[0:4];assign w5 = RC[0:5];                                                                                                                                                    
assign w6 = RC[0:6];assign w7 = RC[0:7];assign w8 = RC[0:8];assign w9 = RC[0:9];assign w10 = RC[1:0];                                                                                                                                                   
assign w11 = RC[1:1];assign w12 = RC[1:2];assign w13 = RC[1:3];assign w14 = RC[1:4];assign w15 = RC[1:5];                                                                                                                                               
assign w16 = RC[1:6];assign w17 = RC[1:7];assign w18 = RC[1:8];assign w19 = RC[1:9];assign w20 = RC[2:0];                                                                                                                                               
assign w21 = RC[2:1];assign w22 = RC[2:2];assign w23 = RC[2:3];assign w24 = RC[2:4];assign w25 = RC[2:5];                                                                                                                                               
assign w26 = RC[2:6];assign w27 = RC[2:7];assign w28 = RC[2:8];assign w29 = RC[2:9];assign w30 = RC[3:0];                                                                                                                                               
assign w31 = RC[3:1];assign w32 = RC[3:2];assign w33 = RC[3:3];assign w34 = RC[3:4];assign w35 = RC[3:5];                                                                                                                                               
assign w36 = RC[3:6];assign w37 = RC[3:7];assign w38 = RC[3:8];assign w39 = RC[3:9];assign w40 = RC[4:0];                                                                                                                                               
assign w41 = RC[4:1];assign w42 = RC[4:2];assign w43 = RC[4:3];assign w44 = RC[4:4];assign w45 = RC[4:5];                                                                                                                                               
assign w46 = RC[4:6];assign w47 = RC[4:7];assign w48 = RC[4:8];assign w49 = RC[4:9];assign w50 = RC[5:0];                                                                                                                                               
assign w51 = RC[5:1];assign w52 = RC[5:2];assign w53 = RC[5:3];assign w54 = RC[5:4];assign w55 = RC[5:5];                                                                                                                                               
assign w56 = RC[5:6];assign w57 = RC[5:7];assign w58 = RC[5:8];assign w59 = RC[5:9];assign w60 = RC[6:0];                                                                                                                                               
assign w61 = RC[6:1];assign w62 = RC[6:2];assign w63 = RC[6:3];assign w64 = RC[6:4];assign w65 = RC[6:5];                                                                                                                                               
assign w66 = RC[6:6];assign w67 = RC[6:7];assign w68 = RC[6:8];assign w69 = RC[6:9];assign w70 = RC[7:0];                                                                                                                                               
assign w71 = RC[7:1];assign w72 = RC[7:2];assign w73 = RC[7:3];assign w74 = RC[7:4];assign w75 = RC[7:5];                                                                                                                                               
assign w76 = RC[7:6];assign w77 = RC[7:7];assign w78 = RC[7:8];assign w79 = RC[7:9];assign w80 = RC[8:0];                                                                                                                                               
assign w81 = RC[8:1];assign w82 = RC[8:2];assign w83 = RC[8:3];assign w84 = RC[8:4];assign w85 = RC[8:5];                                                                                                                                               
assign w86 = RC[8:6];assign w87 = RC[8:7];assign w88 = RC[8:8];assign w89 = RC[8:9];assign w90 = RC[9:0];                                                                                                                                               
assign w91 = RC[9:1];assign w92 = RC[9:2];assign w93 = RC[9:3];assign w94 = RC[9:4];assign w95 = RC[9:5];                                                                                                                                               
assign w96 = RC[9:6];assign w97 = RC[9:7];assign w98 = RC[9:8];assign w99 = RC[9:9];assign w100 = RC[10:0];                                                                                                                                             
assign w101 = RC[10:1];assign w102 = RC[10:2];assign w103 = RC[10:3];assign w104 = RC[10:4];assign w105 = RC[10:5];                                                                                                                                     
assign w106 = RC[10:6];assign w107 = RC[10:7];assign w108 = RC[10:8];assign w109 = RC[10:9];assign w110 = RC[11:0];                                                                                                                                     
assign w111 = RC[11:1];assign w112 = RC[11:2];assign w113 = RC[11:3];assign w114 = RC[11:4];assign w115 = RC[11:5];                                                                                                                                     
assign w116 = RC[11:6];assign w117 = RC[11:7];assign w118 = RC[11:8];assign w119 = RC[11:9];assign w120 = RC[12:0];                                                                                                                                     
assign w121 = RC[12:1];assign w122 = RC[12:2];assign w123 = RC[12:3];assign w124 = RC[12:4];assign w125 = RC[12:5];                                                                                                                                     
assign w126 = RC[12:6];assign w127 = RC[12:7];assign w128 = RC[12:8];assign w129 = RC[12:9];assign w130 = RC[13:0];                                                                                                                                     
assign w131 = RC[13:1];assign w132 = RC[13:2];assign w133 = RC[13:3];assign w134 = RC[13:4];assign w135 = RC[13:5];                                                                                                                                     
assign w136 = RC[13:6];assign w137 = RC[13:7];assign w138 = RC[13:8];assign w139 = RC[13:9];assign w140 = RC[14:0];                                                                                                                                     
assign w141 = RC[14:1];assign w142 = RC[14:2];assign w143 = RC[14:3];assign w144 = RC[14:4];assign w145 = RC[14:5];                                                                                                                                     
assign w146 = RC[14:6];assign w147 = RC[14:7];assign w148 = RC[14:8];assign w149 = RC[14:9];assign w150 = RC[15:0];                                                                                                                                     
assign w151 = RC[15:1];assign w152 = RC[15:2];assign w153 = RC[15:3];assign w154 = RC[15:4];assign w155 = RC[15:5];                                                                                                                                     
assign w156 = RC[15:6];assign w157 = RC[15:7];assign w158 = RC[15:8];assign w159 = RC[15:9];assign w160 = RC[16:0];                                                                                                                                     
assign w161 = RC[16:1];assign w162 = RC[16:2];assign w163 = RC[16:3];assign w164 = RC[16:4];assign w165 = RC[16:5];                                                                                                                                     
assign w166 = RC[16:6];assign w167 = RC[16:7];assign w168 = RC[16:8];assign w169 = RC[16:9];assign w170 = RC[17:0];                                                                                                                                     
assign w171 = RC[17:1];assign w172 = RC[17:2];assign w173 = RC[17:3];assign w174 = RC[17:4];assign w175 = RC[17:5];                                                                                                                                     
assign w176 = RC[17:6];assign w177 = RC[17:7];assign w178 = RC[17:8];assign w179 = RC[17:9];assign w180 = RC[18:0];                                                                                                                                     
assign w181 = RC[18:1];assign w182 = RC[18:2];assign w183 = RC[18:3];assign w184 = RC[18:4];assign w185 = RC[18:5];                                                                                                                                     
assign w186 = RC[18:6];assign w187 = RC[18:7];assign w188 = RC[18:8];assign w189 = RC[18:9];assign w190 = RC[19:0];                                                                                                                                     
assign w191 = RC[19:1];assign w192 = RC[19:2];assign w193 = RC[19:3];assign w194 = RC[19:4];assign w195 = RC[19:5];                                                                                                                                     
assign w196 = RC[19:6];assign w197 = RC[19:7];assign w198 = RC[19:8];assign w199 = RC[19:9];
*/




	 assign border = ~blank & (hcount < 20 || hcount > 220 || vcount < 40 || vcount > 440);

	 
assign placed0 = w0 & ~blank & (hcount > 20 & hcount < 40  & vcount > 40 & vcount < 60);                                                                                                                                                                
assign placed1 = w1 & ~blank & (hcount > 40 & hcount < 60  & vcount > 40 & vcount < 60);                                                                                                                                                                
assign placed2 = w2 & ~blank & (hcount > 60 & hcount < 80  & vcount > 40 & vcount < 60);                                                                                                                                                                
assign placed3 = w3 & ~blank & (hcount > 80 & hcount < 100  & vcount > 40 & vcount < 60);                                                                                                                                                               
assign placed4 = w4 & ~blank & (hcount > 100 & hcount < 120  & vcount > 40 & vcount < 60);                                                                                                                                                              
assign placed5 = w5 & ~blank & (hcount > 120 & hcount < 140  & vcount > 40 & vcount < 60);                                                                                                                                                              
assign placed6 = w6 & ~blank & (hcount > 140 & hcount < 160  & vcount > 40 & vcount < 60);                                                                                                                                                              
assign placed7 = w7 & ~blank & (hcount > 160 & hcount < 180  & vcount > 40 & vcount < 60);                                                                                                                                                              
assign placed8 = w8 & ~blank & (hcount > 180 & hcount < 200  & vcount > 40 & vcount < 60);                                                                                                                                                              
assign placed9 = w9 & ~blank & (hcount > 200 & hcount < 220  & vcount > 40 & vcount < 60);                                                                                                                                                              
assign placed10 = w10 & ~blank & (hcount > 20 & hcount < 40  & vcount > 60 & vcount < 80);                                                                                                                                                              
assign placed11 = w11 & ~blank & (hcount > 40 & hcount < 60  & vcount > 60 & vcount < 80);                                                                                                                                                              
assign placed12 = w12 & ~blank & (hcount > 60 & hcount < 80  & vcount > 60 & vcount < 80);                                                                                                                                                              
assign placed13 = w13 & ~blank & (hcount > 80 & hcount < 100  & vcount > 60 & vcount < 80);                                                                                                                                                             
assign placed14 = w14 & ~blank & (hcount > 100 & hcount < 120  & vcount > 60 & vcount < 80);                                                                                                                                                            
assign placed15 = w15 & ~blank & (hcount > 120 & hcount < 140  & vcount > 60 & vcount < 80);                                                                                                                                                            
assign placed16 = w16 & ~blank & (hcount > 140 & hcount < 160  & vcount > 60 & vcount < 80);                                                                                                                                                            
assign placed17 = w17 & ~blank & (hcount > 160 & hcount < 180  & vcount > 60 & vcount < 80);                                                                                                                                                            
assign placed18 = w18 & ~blank & (hcount > 180 & hcount < 200  & vcount > 60 & vcount < 80);                                                                                                                                                            
assign placed19 = w19 & ~blank & (hcount > 200 & hcount < 220  & vcount > 60 & vcount < 80);                                                                                                                                                            
assign placed20 = w20 & ~blank & (hcount > 20 & hcount < 40  & vcount > 80 & vcount < 100);                                                                                                                                                             
assign placed21 = w21 & ~blank & (hcount > 40 & hcount < 60  & vcount > 80 & vcount < 100);                                                                                                                                                             
assign placed22 = w22 & ~blank & (hcount > 60 & hcount < 80  & vcount > 80 & vcount < 100);                                                                                                                                                             
assign placed23 = w23 & ~blank & (hcount > 80 & hcount < 100  & vcount > 80 & vcount < 100);                                                                                                                                                            
assign placed24 = w24 & ~blank & (hcount > 100 & hcount < 120  & vcount > 80 & vcount < 100);                                                                                                                                                           
assign placed25 = w25 & ~blank & (hcount > 120 & hcount < 140  & vcount > 80 & vcount < 100);                                                                                                                                                           
assign placed26 = w26 & ~blank & (hcount > 140 & hcount < 160  & vcount > 80 & vcount < 100);                                                                                                                                                           
assign placed27 = w27 & ~blank & (hcount > 160 & hcount < 180  & vcount > 80 & vcount < 100);                                                                                                                                                           
assign placed28 = w28 & ~blank & (hcount > 180 & hcount < 200  & vcount > 80 & vcount < 100);                                                                                                                                                           
assign placed29 = w29 & ~blank & (hcount > 200 & hcount < 220  & vcount > 80 & vcount < 100);                                                                                                                                                           
assign placed30 = w30 & ~blank & (hcount > 20 & hcount < 40  & vcount > 100 & vcount < 120);                                                                                                                                                            
assign placed31 = w31 & ~blank & (hcount > 40 & hcount < 60  & vcount > 100 & vcount < 120);                                                                                                                                                            
assign placed32 = w32 & ~blank & (hcount > 60 & hcount < 80  & vcount > 100 & vcount < 120);                                                                                                                                                            
assign placed33 = w33 & ~blank & (hcount > 80 & hcount < 100  & vcount > 100 & vcount < 120);                                                                                                                                                           
assign placed34 = w34 & ~blank & (hcount > 100 & hcount < 120  & vcount > 100 & vcount < 120);                                                                                                                                                          
assign placed35 = w35 & ~blank & (hcount > 120 & hcount < 140  & vcount > 100 & vcount < 120);                                                                                                                                                          
assign placed36 = w36 & ~blank & (hcount > 140 & hcount < 160  & vcount > 100 & vcount < 120);                                                                                                                                                          
assign placed37 = w37 & ~blank & (hcount > 160 & hcount < 180  & vcount > 100 & vcount < 120);                                                                                                                                                          
assign placed38 = w38 & ~blank & (hcount > 180 & hcount < 200  & vcount > 100 & vcount < 120);                                                                                                                                                          
assign placed39 = w39 & ~blank & (hcount > 200 & hcount < 220  & vcount > 100 & vcount < 120);                                                                                                                                                          
assign placed40 = w40 & ~blank & (hcount > 20 & hcount < 40  & vcount > 120 & vcount < 140);                                                                                                                                                            
assign placed41 = w41 & ~blank & (hcount > 40 & hcount < 60  & vcount > 120 & vcount < 140);                                                                                                                                                            
assign placed42 = w42 & ~blank & (hcount > 60 & hcount < 80  & vcount > 120 & vcount < 140);                                                                                                                                                            
assign placed43 = w43 & ~blank & (hcount > 80 & hcount < 100  & vcount > 120 & vcount < 140);                                                                                                                                                           
assign placed44 = w44 & ~blank & (hcount > 100 & hcount < 120  & vcount > 120 & vcount < 140);                                                                                                                                                          
assign placed45 = w45 & ~blank & (hcount > 120 & hcount < 140  & vcount > 120 & vcount < 140);
assign placed46 = w46 & ~blank & (hcount > 140 & hcount < 160  & vcount > 120 & vcount < 140);                                                                                                                                                          
assign placed47 = w47 & ~blank & (hcount > 160 & hcount < 180  & vcount > 120 & vcount < 140);                                                                                                                                                          
assign placed48 = w48 & ~blank & (hcount > 180 & hcount < 200  & vcount > 120 & vcount < 140);                                                                                                                                                          
assign placed49 = w49 & ~blank & (hcount > 200 & hcount < 220  & vcount > 120 & vcount < 140);                                                                                                                                                          
assign placed50 = w50 & ~blank & (hcount > 20 & hcount < 40  & vcount > 140 & vcount < 160);                                                                                                                                                            
assign placed51 = w51 & ~blank & (hcount > 40 & hcount < 60  & vcount > 140 & vcount < 160);                                                                                                                                                            
assign placed52 = w52 & ~blank & (hcount > 60 & hcount < 80  & vcount > 140 & vcount < 160);                                                                                                                                                            
assign placed53 = w53 & ~blank & (hcount > 80 & hcount < 100  & vcount > 140 & vcount < 160);                                                                                                                                                           
assign placed54 = w54 & ~blank & (hcount > 100 & hcount < 120  & vcount > 140 & vcount < 160);                                                                                                                                                          
assign placed55 = w55 & ~blank & (hcount > 120 & hcount < 140  & vcount > 140 & vcount < 160);                                                                                                                                                          
assign placed56 = w56 & ~blank & (hcount > 140 & hcount < 160  & vcount > 140 & vcount < 160);                                                                                                                                                          
assign placed57 = w57 & ~blank & (hcount > 160 & hcount < 180  & vcount > 140 & vcount < 160);                                                                                                                                                          
assign placed58 = w58 & ~blank & (hcount > 180 & hcount < 200  & vcount > 140 & vcount < 160);                                                                                                                                                          
assign placed59 = w59 & ~blank & (hcount > 200 & hcount < 220  & vcount > 140 & vcount < 160);                                                                                                                                                          
assign placed60 = w60 & ~blank & (hcount > 20 & hcount < 40  & vcount > 160 & vcount < 180);                                                                                                                                                            
assign placed61 = w61 & ~blank & (hcount > 40 & hcount < 60  & vcount > 160 & vcount < 180);                                                                                                                                                            
assign placed62 = w62 & ~blank & (hcount > 60 & hcount < 80  & vcount > 160 & vcount < 180);                                                                                                                                                            
assign placed63 = w63 & ~blank & (hcount > 80 & hcount < 100  & vcount > 160 & vcount < 180);                                                                                                                                                           
assign placed64 = w64 & ~blank & (hcount > 100 & hcount < 120  & vcount > 160 & vcount < 180);                                                                                                                                                          
assign placed65 = w65 & ~blank & (hcount > 120 & hcount < 140  & vcount > 160 & vcount < 180);                                                                                                                                                          
assign placed66 = w66 & ~blank & (hcount > 140 & hcount < 160  & vcount > 160 & vcount < 180);                                                                                                                                                          
assign placed67 = w67 & ~blank & (hcount > 160 & hcount < 180  & vcount > 160 & vcount < 180);                                                                                                                                                          
assign placed68 = w68 & ~blank & (hcount > 180 & hcount < 200  & vcount > 160 & vcount < 180);                                                                                                                                                          
assign placed69 = w69 & ~blank & (hcount > 200 & hcount < 220  & vcount > 160 & vcount < 180);                                                                                                                                                          
assign placed70 = w70 & ~blank & (hcount > 20 & hcount < 40  & vcount > 180 & vcount < 200);                                                                                                                                                            
assign placed71 = w71 & ~blank & (hcount > 40 & hcount < 60  & vcount > 180 & vcount < 200);                                                                                                                                                             
assign placed72 = w72 & ~blank & (hcount > 60 & hcount < 80  & vcount > 180 & vcount < 200);                                                                                                                                                            
assign placed73 = w73 & ~blank & (hcount > 80 & hcount < 100  & vcount > 180 & vcount < 200);                                                                                                                                                           
assign placed74 = w74 & ~blank & (hcount > 100 & hcount < 120  & vcount > 180 & vcount < 200);                                                                                                                                                          
assign placed75 = w75 & ~blank & (hcount > 120 & hcount < 140  & vcount > 180 & vcount < 200);                                                                                                                                                          
assign placed76 = w76 & ~blank & (hcount > 140 & hcount < 160  & vcount > 180 & vcount < 200);                                                                                                                                                          
assign placed77 = w77 & ~blank & (hcount > 160 & hcount < 180  & vcount > 180 & vcount < 200);                                                                                                                                                          
assign placed78 = w78 & ~blank & (hcount > 180 & hcount < 200  & vcount > 180 & vcount < 200);                                                                                                                                                          
assign placed79 = w79 & ~blank & (hcount > 200 & hcount < 220  & vcount > 180 & vcount < 200);                                                                                                                                                          
assign placed80 = w80 & ~blank & (hcount > 20 & hcount < 40  & vcount > 200 & vcount < 220); 
assign placed81 = w81 & ~blank & (hcount > 40 & hcount < 60  & vcount > 200 & vcount < 220);                                                                                                                                                            
assign placed82 = w82 & ~blank & (hcount > 60 & hcount < 80  & vcount > 200 & vcount < 220);                                                                                                                                                            
assign placed83 = w83 & ~blank & (hcount > 80 & hcount < 100  & vcount > 200 & vcount < 220);                                                                                                                                                           
assign placed84 = w84 & ~blank & (hcount > 100 & hcount < 120  & vcount > 200 & vcount < 220);                                                                                                                                                          
assign placed85 = w85 & ~blank & (hcount > 120 & hcount < 140  & vcount > 200 & vcount < 220);                                                                                                                                                          
assign placed86 = w86 & ~blank & (hcount > 140 & hcount < 160  & vcount > 200 & vcount < 220);                                                                                                                                                          
assign placed87 = w87 & ~blank & (hcount > 160 & hcount < 180  & vcount > 200 & vcount < 220);                                                                                                                                                          
assign placed88 = w88 & ~blank & (hcount > 180 & hcount < 200  & vcount > 200 & vcount < 220);                                                                                                                                                          
assign placed89 = w89 & ~blank & (hcount > 200 & hcount < 220  & vcount > 200 & vcount < 220);                                                                                                                                                          
assign placed90 = w90 & ~blank & (hcount > 20 & hcount < 40  & vcount > 220 & vcount < 240);                                                                                                                                                            
assign placed91 = w91 & ~blank & (hcount > 40 & hcount < 60  & vcount > 220 & vcount < 240);                                                                                                                                                            
assign placed92 = w92 & ~blank & (hcount > 60 & hcount < 80  & vcount > 220 & vcount < 240);                                                                                                                                                            
assign placed93 = w93 & ~blank & (hcount > 80 & hcount < 100  & vcount > 220 & vcount < 240);                                                                                                                                                           
assign placed94 = w94 & ~blank & (hcount > 100 & hcount < 120  & vcount > 220 & vcount < 240);                                                                                                                                                          
assign placed95 = w95 & ~blank & (hcount > 120 & hcount < 140  & vcount > 220 & vcount < 240);                                                                                                                                                          
assign placed96 = w96 & ~blank & (hcount > 140 & hcount < 160  & vcount > 220 & vcount < 240);                                                                                                                                                          
assign placed97 = w97 & ~blank & (hcount > 160 & hcount < 180  & vcount > 220 & vcount < 240);                                                                                                                                                          
assign placed98 = w98 & ~blank & (hcount > 180 & hcount < 200  & vcount > 220 & vcount < 240);                                                                                                                                                          
assign placed99 = w99 & ~blank & (hcount > 200 & hcount < 220  & vcount > 220 & vcount < 240);                                                                                                                                                          
assign placed100 = w100 & ~blank & (hcount > 20 & hcount < 40  & vcount > 240 & vcount < 260);                                                                                                                                                          
assign placed101 = w101 & ~blank & (hcount > 40 & hcount < 60  & vcount > 240 & vcount < 260);                                                                                                                                                          
assign placed102 = w102 & ~blank & (hcount > 60 & hcount < 80  & vcount > 240 & vcount < 260);                                                                                                                                                          
assign placed103 = w103 & ~blank & (hcount > 80 & hcount < 100  & vcount > 240 & vcount < 260);                                                                                                                                                         
assign placed104 = w104 & ~blank & (hcount > 100 & hcount < 120  & vcount > 240 & vcount < 260);                                                                                                                                                        
assign placed105 = w105 & ~blank & (hcount > 120 & hcount < 140  & vcount > 240 & vcount < 260);                                                                                                                                                        
assign placed106 = w106 & ~blank & (hcount > 140 & hcount < 160  & vcount > 240 & vcount < 260);                                                                                                                                                        
assign placed107 = w107 & ~blank & (hcount > 160 & hcount < 180  & vcount > 240 & vcount < 260);                                                                                                                                                        
assign placed108 = w108 & ~blank & (hcount > 180 & hcount < 200  & vcount > 240 & vcount < 260);                                                                                                                                                        
assign placed109 = w109 & ~blank & (hcount > 200 & hcount < 220  & vcount > 240 & vcount < 260);                                                                                                                                                        
assign placed110 = w110 & ~blank & (hcount > 20 & hcount < 40  & vcount > 260 & vcount < 280);                                                                                                                                                          
assign placed111 = w111 & ~blank & (hcount > 40 & hcount < 60  & vcount > 260 & vcount < 280);                                                                                                                                                          
assign placed112 = w112 & ~blank & (hcount > 60 & hcount < 80  & vcount > 260 & vcount < 280);                                                                                                                                                          
assign placed113 = w113 & ~blank & (hcount > 80 & hcount < 100  & vcount > 260 & vcount < 280);                                                                                                                                                         
assign placed114 = w114 & ~blank & (hcount > 100 & hcount < 120  & vcount > 260 & vcount < 280);                                                                                                                                                        
assign placed115 = w115 & ~blank & (hcount > 120 & hcount < 140  & vcount > 260 & vcount < 280);                                                                                                                                                        
assign placed116 = w116 & ~blank & (hcount > 140 & hcount < 160  & vcount > 260 & vcount < 280);                                                                                                                                                        
assign placed117 = w117 & ~blank & (hcount > 160 & hcount < 180  & vcount > 260 & vcount < 280);                                                                                                                                                        
assign placed118 = w118 & ~blank & (hcount > 180 & hcount < 200  & vcount > 260 & vcount < 280);                                                                                                                                                        
assign placed119 = w119 & ~blank & (hcount > 200 & hcount < 220  & vcount > 260 & vcount < 280);                                                                                                                                                        
assign placed120 = w120 & ~blank & (hcount > 20 & hcount < 40  & vcount > 280 & vcount < 300);                                                                                                                                                          
assign placed121 = w121 & ~blank & (hcount > 40 & hcount < 60  & vcount > 280 & vcount < 300);                                                                                                                                                          
assign placed122 = w122 & ~blank & (hcount > 60 & hcount < 80  & vcount > 280 & vcount < 300);                                                                                                                                                          
assign placed123 = w123 & ~blank & (hcount > 80 & hcount < 100  & vcount > 280 & vcount < 300);                                                                                                                                                         
assign placed124 = w124 & ~blank & (hcount > 100 & hcount < 120  & vcount > 280 & vcount < 300);                                                                                                                                                        
assign placed125 = w125 & ~blank & (hcount > 120 & hcount < 140  & vcount > 280 & vcount < 300);                                                                                                                                                        
assign placed126 = w126 & ~blank & (hcount > 140 & hcount < 160  & vcount > 280 & vcount < 300);                                                                                                                                                        
assign placed127 = w127 & ~blank & (hcount > 160 & hcount < 180  & vcount > 280 & vcount < 300);                                                                                                                                                        
assign placed128 = w128 & ~blank & (hcount > 180 & hcount < 200  & vcount > 280 & vcount < 300);                                                                                                                                                        
assign placed129 = w129 & ~blank & (hcount > 200 & hcount < 220  & vcount > 280 & vcount < 300);                                                                                                                                                        
assign placed130 = w130 & ~blank & (hcount > 20 & hcount < 40  & vcount > 300 & vcount < 320);                                                                                                                                                          
assign placed131 = w131 & ~blank & (hcount > 40 & hcount < 60  & vcount > 300 & vcount < 320);                                                                                                                                                          
assign placed132 = w132 & ~blank & (hcount > 60 & hcount < 80  & vcount > 300 & vcount < 320);                                                                                                                                                          
assign placed133 = w133 & ~blank & (hcount > 80 & hcount < 100  & vcount > 300 & vcount < 320);                                                                                                                                                         
assign placed134 = w134 & ~blank & (hcount > 100 & hcount < 120  & vcount > 300 & vcount < 320);                                                                                                                                                        
assign placed135 = w135 & ~blank & (hcount > 120 & hcount < 140  & vcount > 300 & vcount < 320);       
assign placed136 = w136 & ~blank & (hcount > 140 & hcount < 160  & vcount > 300 & vcount < 320);                                                                                                                                                        
assign placed137 = w137 & ~blank & (hcount > 160 & hcount < 180  & vcount > 300 & vcount < 320);                                                                                                                                                        
assign placed138 = w138 & ~blank & (hcount > 180 & hcount < 200  & vcount > 300 & vcount < 320);                                                                                                                                                        
assign placed139 = w139 & ~blank & (hcount > 200 & hcount < 220  & vcount > 300 & vcount < 320);                                                                                                                                                        
assign placed140 = w140 & ~blank & (hcount > 20 & hcount < 40  & vcount > 320 & vcount < 340);                                                                                                                                                          
assign placed141 = w141 & ~blank & (hcount > 40 & hcount < 60  & vcount > 320 & vcount < 340);                                                                                                                                                          
assign placed142 = w142 & ~blank & (hcount > 60 & hcount < 80  & vcount > 320 & vcount < 340);                                                                                                                                                          
assign placed143 = w143 & ~blank & (hcount > 80 & hcount < 100  & vcount > 320 & vcount < 340);                                                                                                                                                         
assign placed144 = w144 & ~blank & (hcount > 100 & hcount < 120  & vcount > 320 & vcount < 340);                                                                                                                                                        
assign placed145 = w145 & ~blank & (hcount > 120 & hcount < 140  & vcount > 320 & vcount < 340);                                                                                                                                                        
assign placed146 = w146 & ~blank & (hcount > 140 & hcount < 160  & vcount > 320 & vcount < 340);                                                                                                                                                        
assign placed147 = w147 & ~blank & (hcount > 160 & hcount < 180  & vcount > 320 & vcount < 340);                                                                                                                                                        
assign placed148 = w148 & ~blank & (hcount > 180 & hcount < 200  & vcount > 320 & vcount < 340);                                                                                                                                                        
assign placed149 = w149 & ~blank & (hcount > 200 & hcount < 220  & vcount > 320 & vcount < 340);                                                                                                                                                        
assign placed150 = w150 & ~blank & (hcount > 20 & hcount < 40  & vcount > 340 & vcount < 360);                                                                                                                                                          
assign placed151 = w151 & ~blank & (hcount > 40 & hcount < 60  & vcount > 340 & vcount < 360);                                                                                                                                                          
assign placed152 = w152 & ~blank & (hcount > 60 & hcount < 80  & vcount > 340 & vcount < 360);                                                                                                                                                          
assign placed153 = w153 & ~blank & (hcount > 80 & hcount < 100  & vcount > 340 & vcount < 360);                                                                                                                                                         
assign placed154 = w154 & ~blank & (hcount > 100 & hcount < 120  & vcount > 340 & vcount < 360);                                                                                                                                                        
assign placed155 = w155 & ~blank & (hcount > 120 & hcount < 140  & vcount > 340 & vcount < 360);                                                                                                                                                        
assign placed156 = w156 & ~blank & (hcount > 140 & hcount < 160  & vcount > 340 & vcount < 360);                                                                                                                                                        
assign placed157 = w157 & ~blank & (hcount > 160 & hcount < 180  & vcount > 340 & vcount < 360);                                                                                                                                                        
assign placed158 = w158 & ~blank & (hcount > 180 & hcount < 200  & vcount > 340 & vcount < 360);                                                                                                                                                        
assign placed159 = w159 & ~blank & (hcount > 200 & hcount < 220  & vcount > 340 & vcount < 360);                                                                                                                                                        
assign placed160 = w160 & ~blank & (hcount > 20 & hcount < 40  & vcount > 360 & vcount < 380);                                                                                                                                                          
assign placed161 = w161 & ~blank & (hcount > 40 & hcount < 60  & vcount > 360 & vcount < 380);                                                                                                                                                          
assign placed162 = w162 & ~blank & (hcount > 60 & hcount < 80  & vcount > 360 & vcount < 380);                                                                                                                                                          
assign placed163 = w163 & ~blank & (hcount > 80 & hcount < 100  & vcount > 360 & vcount < 380);                                                                                                                                                         
assign placed164 = w164 & ~blank & (hcount > 100 & hcount < 120  & vcount > 360 & vcount < 380);                                                                                                                                                        
assign placed165 = w165 & ~blank & (hcount > 120 & hcount < 140  & vcount > 360 & vcount < 380);                                                                                                                                                        
assign placed166 = w166 & ~blank & (hcount > 140 & hcount < 160  & vcount > 360 & vcount < 380);                                                                                                                                                        
assign placed167 = w167 & ~blank & (hcount > 160 & hcount < 180  & vcount > 360 & vcount < 380);                                                                                                                                                        
assign placed168 = w168 & ~blank & (hcount > 180 & hcount < 200  & vcount > 360 & vcount < 380);                                                                                                                                                        
assign placed169 = w169 & ~blank & (hcount > 200 & hcount < 220  & vcount > 360 & vcount < 380);                                                                                                                                                        
assign placed170 = w170 & ~blank & (hcount > 20 & hcount < 40  & vcount > 380 & vcount < 400);                                                                                                                                                          
assign placed171 = w171 & ~blank & (hcount > 40 & hcount < 60  & vcount > 380 & vcount < 400);                                                                                                                                                          
assign placed172 = w172 & ~blank & (hcount > 60 & hcount < 80  & vcount > 380 & vcount < 400);                                                                                                                                                          
assign placed173 = w173 & ~blank & (hcount > 80 & hcount < 100  & vcount > 380 & vcount < 400);                                                                                                                                                         
assign placed174 = w174 & ~blank & (hcount > 100 & hcount < 120  & vcount > 380 & vcount < 400);                                                                                                                                                        
assign placed175 = w175 & ~blank & (hcount > 120 & hcount < 140  & vcount > 380 & vcount < 400);                                                                                                                                                        
assign placed176 = w176 & ~blank & (hcount > 140 & hcount < 160  & vcount > 380 & vcount < 400);                                                                                                                                                        
assign placed177 = w177 & ~blank & (hcount > 160 & hcount < 180  & vcount > 380 & vcount < 400);                                                                                                                                                        
assign placed178 = w178 & ~blank & (hcount > 180 & hcount < 200  & vcount > 380 & vcount < 400);                                                                                                                                                        
assign placed179 = w179 & ~blank & (hcount > 200 & hcount < 220  & vcount > 380 & vcount < 400);                                                                                                                                                        
assign placed180 = w180 & ~blank & (hcount > 20 & hcount < 40  & vcount > 400 & vcount < 420);                                                                                                                                                          
assign placed181 = w181 & ~blank & (hcount > 40 & hcount < 60  & vcount > 400 & vcount < 420);                                                                                                                                                          
assign placed182 = w182 & ~blank & (hcount > 60 & hcount < 80  & vcount > 400 & vcount < 420);                                                                                                                                                          
assign placed183 = w183 & ~blank & (hcount > 80 & hcount < 100  & vcount > 400 & vcount < 420);                                                                                                                                                         
assign placed184 = w184 & ~blank & (hcount > 100 & hcount < 120  & vcount > 400 & vcount < 420);                                                                                                                                                        
assign placed185 = w185 & ~blank & (hcount > 120 & hcount < 140  & vcount > 400 & vcount < 420);                                                                                                                                                        
assign placed186 = w186 & ~blank & (hcount > 140 & hcount < 160  & vcount > 400 & vcount < 420); 
assign placed187 = w187 & ~blank & (hcount > 160 & hcount < 180  & vcount > 400 & vcount < 420);                                                                                                                                                        
assign placed188 = w188 & ~blank & (hcount > 180 & hcount < 200  & vcount > 400 & vcount < 420);                                                                                                                                                        
assign placed189 = w189 & ~blank & (hcount > 200 & hcount < 220  & vcount > 400 & vcount < 420);                                                                                                                                                        
assign placed190 = w190 & ~blank & (hcount > 20 & hcount < 40  & vcount > 420 & vcount < 440);                                                                                                                                                          
assign placed191 = w191 & ~blank & (hcount > 40 & hcount < 60  & vcount > 420 & vcount < 440);                                                                                                                                                          
assign placed192 = w192 & ~blank & (hcount > 60 & hcount < 80  & vcount > 420 & vcount < 440);                                                                                                                                                          
assign placed193 = w193 & ~blank & (hcount > 80 & hcount < 100  & vcount > 420 & vcount < 440);                                                                                                                                                         
assign placed194 = w194 & ~blank & (hcount > 100 & hcount < 120  & vcount > 420 & vcount < 440);                                                                                                                                                        
assign placed195 = w195 & ~blank & (hcount > 120 & hcount < 140  & vcount > 420 & vcount < 440);                                                                                                                                                        
assign placed196 = w196 & ~blank & (hcount > 140 & hcount < 160  & vcount > 420 & vcount < 440);                                                                                                                                                        
assign placed197 = w197 & ~blank & (hcount > 160 & hcount < 180  & vcount > 420 & vcount < 440);                                                                                                                                                        
assign placed198 = w198 & ~blank & (hcount > 180 & hcount < 200  & vcount > 420 & vcount < 440);                                                                                                                                                        
assign placed199 = w199 & ~blank & (hcount > 200 & hcount < 220  & vcount > 420 & vcount < 440);              





//wire left2, right2, down2;
//reg reset2;

	 
assign placed0f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 40 & vcount < 60);                                                                                                                                                                
assign placed1f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 40 & vcount < 60);                                                                                                                                                                
assign placed2f = ~blank & (hcount > 60 & hcount < 80  & vcount > 40 & vcount < 60);                                                                                                                                                                
assign placed3f = ~blank & (hcount > 80 & hcount < 100  & vcount > 40 & vcount < 60);                                                                                                                                                               
assign placed4f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 40 & vcount < 60);                                                                                                                                                              
assign placed5f = ~blank & (hcount > 120 & hcount < 140  & vcount > 40 & vcount < 60);                                                                                                                                                              
assign placed6f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 40 & vcount < 60);                                                                                                                                                              
assign placed7f = ~blank & (hcount > 160 & hcount < 180  & vcount > 40 & vcount < 60);                                                                                                                                                              
assign placed8f =  ~blank & (hcount > 180 & hcount < 200  & vcount > 40 & vcount < 60);                                                                                                                                                              
assign placed9f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 40 & vcount < 60);                                                                                                                                                              
assign placed10f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 60 & vcount < 80);                                                                                                                                                              
assign placed11f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 60 & vcount < 80);                                                                                                                                                              
assign placed12f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 60 & vcount < 80);                                                                                                                                                              
assign placed13f =  ~blank & (hcount > 80 & hcount < 100  & vcount > 60 & vcount < 80);                                                                                                                                                             
assign placed14f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 60 & vcount < 80);                                                                                                                                                            
assign placed15f =  ~blank & (hcount > 120 & hcount < 140  & vcount > 60 & vcount < 80);                                                                                                                                                            
assign placed16f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 60 & vcount < 80);                                                                                                                                                            
assign placed17f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 60 & vcount < 80);                                                                                                                                                            
assign placed18f =  ~blank & (hcount > 180 & hcount < 200  & vcount > 60 & vcount < 80);                                                                                                                                                            
assign placed19f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 60 & vcount < 80);                                                                                                                                                            
assign placed20f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 80 & vcount < 100);                                                                                                                                                             
assign placed21f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 80 & vcount < 100);                                                                                                                                                             
assign placed22f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 80 & vcount < 100);                                                                                                                                                             
assign placed23f =  ~blank & (hcount > 80 & hcount < 100  & vcount > 80 & vcount < 100);                                                                                                                                                            
assign placed24f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 80 & vcount < 100);                                                                                                                                                           
assign placed25f =  ~blank & (hcount > 120 & hcount < 140  & vcount > 80 & vcount < 100);                                                                                                                                                           
assign placed26f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 80 & vcount < 100);                                                                                                                                                           
assign placed27f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 80 & vcount < 100);                                                                                                                                                           
assign placed28f =  ~blank & (hcount > 180 & hcount < 200  & vcount > 80 & vcount < 100);                                                                                                                                                           
assign placed29f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 80 & vcount < 100);                                                                                                                                                           
assign placed30f = ~blank & (hcount > 20 & hcount < 40  & vcount > 100 & vcount < 120);                                                                                                                                                            
assign placed31f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 100 & vcount < 120);                                                                                                                                                            
assign placed32f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 100 & vcount < 120);                                                                                                                                                            
assign placed33f =  ~blank & (hcount > 80 & hcount < 100  & vcount > 100 & vcount < 120);                                                                                                                                                           
assign placed34f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 100 & vcount < 120);                                                                                                                                                          
assign placed35f = ~blank & (hcount > 120 & hcount < 140  & vcount > 100 & vcount < 120);                                                                                                                                                          
assign placed36f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 100 & vcount < 120);                                                                                                                                                          
assign placed37f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 100 & vcount < 120);                                                                                                                                                          
assign placed38f =  ~blank & (hcount > 180 & hcount < 200  & vcount > 100 & vcount < 120);                                                                                                                                                          
assign placed39f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 100 & vcount < 120);                                                                                                                                                          
assign placed40f = ~blank & (hcount > 20 & hcount < 40  & vcount > 120 & vcount < 140);                                                                                                                                                            
assign placed41f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 120 & vcount < 140);                                                                                                                                                            
assign placed42f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 120 & vcount < 140);                                                                                                                                                            
assign placed43f = ~blank & (hcount > 80 & hcount < 100  & vcount > 120 & vcount < 140);                                                                                                                                                           
assign placed44f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 120 & vcount < 140);                                                                                                                                                          
assign placed45f =  ~blank & (hcount > 120 & hcount < 140  & vcount > 120 & vcount < 140);
assign placed46f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 120 & vcount < 140);                                                                                                                                                          
assign placed47f = ~blank & (hcount > 160 & hcount < 180  & vcount > 120 & vcount < 140);                                                                                                                                                          
assign placed48f =  ~blank & (hcount > 180 & hcount < 200  & vcount > 120 & vcount < 140);                                                                                                                                                          
assign placed49f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 120 & vcount < 140);                                                                                                                                                          
assign placed50f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 140 & vcount < 160);                                                                                                                                                            
assign placed51f = ~blank & (hcount > 40 & hcount < 60  & vcount > 140 & vcount < 160);                                                                                                                                                            
assign placed52f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 140 & vcount < 160);                                                                                                                                                            
assign placed53f = ~blank & (hcount > 80 & hcount < 100  & vcount > 140 & vcount < 160);                                                                                                                                                           
assign placed54f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 140 & vcount < 160);                                                                                                                                                          
assign placed55f =  ~blank & (hcount > 120 & hcount < 140  & vcount > 140 & vcount < 160);                                                                                                                                                          
assign placed56f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 140 & vcount < 160);                                                                                                                                                          
assign placed57f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 140 & vcount < 160);                                                                                                                                                          
assign placed58f=  ~blank & (hcount > 180 & hcount < 200  & vcount > 140 & vcount < 160);                                                                                                                                                          
assign placed59f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 140 & vcount < 160);                                                                                                                                                          
assign placed60f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 160 & vcount < 180);                                                                                                                                                            
assign placed61f = ~blank & (hcount > 40 & hcount < 60  & vcount > 160 & vcount < 180);                                                                                                                                                            
assign placed62f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 160 & vcount < 180);                                                                                                                                                            
assign placed63f =  ~blank & (hcount > 80 & hcount < 100  & vcount > 160 & vcount < 180);                                                                                                                                                           
assign placed64f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 160 & vcount < 180);                                                                                                                                                          
assign placed65f =  ~blank & (hcount > 120 & hcount < 140  & vcount > 160 & vcount < 180);                                                                                                                                                          
assign placed66f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 160 & vcount < 180);                                                                                                                                                          
assign placed67f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 160 & vcount < 180);                                                                                                                                                          
assign placed68f =  ~blank & (hcount > 180 & hcount < 200  & vcount > 160 & vcount < 180);                                                                                                                                                          
assign placed69f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 160 & vcount < 180);                                                                                                                                                          
assign placed70f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 180 & vcount < 200);                                                                                                                                                            
assign placed71f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 180 & vcount < 200);                                                                                                                                                             
assign placed72f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 180 & vcount < 200);                                                                                                                                                            
assign placed73f =  ~blank & (hcount > 80 & hcount < 100  & vcount > 180 & vcount < 200);                                                                                                                                                           
assign placed74f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 180 & vcount < 200);                                                                                                                                                          
assign placed75f =  ~blank & (hcount > 120 & hcount < 140  & vcount > 180 & vcount < 200);                                                                                                                                                          
assign placed76f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 180 & vcount < 200);                                                                                                                                                          
assign placed77f = ~blank & (hcount > 160 & hcount < 180  & vcount > 180 & vcount < 200);                                                                                                                                                          
assign placed78f =  ~blank & (hcount > 180 & hcount < 200  & vcount > 180 & vcount < 200);                                                                                                                                                          
assign placed79f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 180 & vcount < 200);                                                                                                                                                          
assign placed80f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 200 & vcount < 220); 
assign placed81f=  ~blank & (hcount > 40 & hcount < 60  & vcount > 200 & vcount < 220);                                                                                                                                                            
assign placed82f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 200 & vcount < 220);                                                                                                                                                            
assign placed83f =  ~blank & (hcount > 80 & hcount < 100  & vcount > 200 & vcount < 220);                                                                                                                                                           
assign placed84f = ~blank & (hcount > 100 & hcount < 120  & vcount > 200 & vcount < 220);                                                                                                                                                          
assign placed85f =  ~blank & (hcount > 120 & hcount < 140  & vcount > 200 & vcount < 220);                                                                                                                                                          
assign placed86f = ~blank & (hcount > 140 & hcount < 160  & vcount > 200 & vcount < 220);                                                                                                                                                          
assign placed87f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 200 & vcount < 220);                                                                                                                                                          
assign placed88f =  ~blank & (hcount > 180 & hcount < 200  & vcount > 200 & vcount < 220);                                                                                                                                                          
assign placed89f = ~blank & (hcount > 200 & hcount < 220  & vcount > 200 & vcount < 220);                                                                                                                                                          
assign placed90f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 220 & vcount < 240);                                                                                                                                                            
assign placed91f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 220 & vcount < 240);                                                                                                                                                            
assign placed92f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 220 & vcount < 240);                                                                                                                                                            
assign placed93f =  ~blank & (hcount > 80 & hcount < 100  & vcount > 220 & vcount < 240);                                                                                                                                                           
assign placed94f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 220 & vcount < 240);                                                                                                                                                          
assign placed95f = ~blank & (hcount > 120 & hcount < 140  & vcount > 220 & vcount < 240);                                                                                                                                                          
assign placed96f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 220 & vcount < 240);                                                                                                                                                          
assign placed97f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 220 & vcount < 240);                                                                                                                                                          
assign placed98f= ~blank & (hcount > 180 & hcount < 200  & vcount > 220 & vcount < 240);                                                                                                                                                          
assign placed99f=  ~blank & (hcount > 200 & hcount < 220  & vcount > 220 & vcount < 240);                                                                                                                                                          
assign placed100f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 240 & vcount < 260);                                                                                                                                                          
assign placed101f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 240 & vcount < 260);                                                                                                                                                          
assign placed102f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 240 & vcount < 260);                                                                                                                                                          
assign placed103f =  ~blank & (hcount > 80 & hcount < 100  & vcount > 240 & vcount < 260);                                                                                                                                                         
assign placed104f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 240 & vcount < 260);                                                                                                                                                        
assign placed105f =  ~blank & (hcount > 120 & hcount < 140  & vcount > 240 & vcount < 260);                                                                                                                                                        
assign placed106f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 240 & vcount < 260);                                                                                                                                                        
assign placed107f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 240 & vcount < 260);                                                                                                                                                        
assign placed108f =  ~blank & (hcount > 180 & hcount < 200  & vcount > 240 & vcount < 260);                                                                                                                                                        
assign placed109f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 240 & vcount < 260);                                                                                                                                                        
assign placed110f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 260 & vcount < 280);                                                                                                                                                          
assign placed111f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 260 & vcount < 280);                                                                                                                                                          
assign placed112f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 260 & vcount < 280);                                                                                                                                                          
assign placed113f = ~blank & (hcount > 80 & hcount < 100  & vcount > 260 & vcount < 280);                                                                                                                                                         
assign placed114f = ~blank & (hcount > 100 & hcount < 120  & vcount > 260 & vcount < 280);                                                                                                                                                        
assign placed115f =  ~blank & (hcount > 120 & hcount < 140  & vcount > 260 & vcount < 280);                                                                                                                                                        
assign placed116f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 260 & vcount < 280);                                                                                                                                                        
assign placed117f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 260 & vcount < 280);                                                                                                                                                        
assign placed118f = ~blank & (hcount > 180 & hcount < 200  & vcount > 260 & vcount < 280);                                                                                                                                                        
assign placed119f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 260 & vcount < 280);                                                                                                                                                        
assign placed120f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 280 & vcount < 300);                                                                                                                                                          
assign placed121f = ~blank & (hcount > 40 & hcount < 60  & vcount > 280 & vcount < 300);                                                                                                                                                          
assign placed122f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 280 & vcount < 300);                                                                                                                                                          
assign placed123f =  ~blank & (hcount > 80 & hcount < 100  & vcount > 280 & vcount < 300);                                                                                                                                                         
assign placed124f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 280 & vcount < 300);                                                                                                                                                        
assign placed125f = ~blank & (hcount > 120 & hcount < 140  & vcount > 280 & vcount < 300);                                                                                                                                                        
assign placed126f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 280 & vcount < 300);                                                                                                                                                        
assign placed127f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 280 & vcount < 300);                                                                                                                                                        
assign placed128f =  ~blank & (hcount > 180 & hcount < 200  & vcount > 280 & vcount < 300);                                                                                                                                                        
assign placed129f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 280 & vcount < 300);                                                                                                                                                        
assign placed130f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 300 & vcount < 320);                                                                                                                                                          
assign placed131f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 300 & vcount < 320);                                                                                                                                                          
assign placed132f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 300 & vcount < 320);                                                                                                                                                          
assign placed133f = ~blank & (hcount > 80 & hcount < 100  & vcount > 300 & vcount < 320);                                                                                                                                                         
assign placed134f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 300 & vcount < 320);                                                                                                                                                        
assign placed135f = ~blank & (hcount > 120 & hcount < 140  & vcount > 300 & vcount < 320);       
assign placed136f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 300 & vcount < 320);                                                                                                                                                        
assign placed137f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 300 & vcount < 320);                                                                                                                                                        
assign placed138f =  ~blank & (hcount > 180 & hcount < 200  & vcount > 300 & vcount < 320);                                                                                                                                                        
assign placed139f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 300 & vcount < 320);                                                                                                                                                        
assign placed140f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 320 & vcount < 340);                                                                                                                                                          
assign placed141f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 320 & vcount < 340);                                                                                                                                                          
assign placed142f = ~blank & (hcount > 60 & hcount < 80  & vcount > 320 & vcount < 340);                                                                                                                                                          
assign placed143f =  ~blank & (hcount > 80 & hcount < 100  & vcount > 320 & vcount < 340);                                                                                                                                                         
assign placed144f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 320 & vcount < 340);                                                                                                                                                        
assign placed145f =  ~blank & (hcount > 120 & hcount < 140  & vcount > 320 & vcount < 340);                                                                                                                                                        
assign placed146f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 320 & vcount < 340);                                                                                                                                                        
assign placed147f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 320 & vcount < 340);                                                                                                                                                        
assign placed148f =  ~blank & (hcount > 180 & hcount < 200  & vcount > 320 & vcount < 340);                                                                                                                                                        
assign placed149f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 320 & vcount < 340);                                                                                                                                                        
assign placed150f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 340 & vcount < 360);                                                                                                                                                          
assign placed151f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 340 & vcount < 360);                                                                                                                                                          
assign placed152f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 340 & vcount < 360);                                                                                                                                                          
assign placed153f =  ~blank & (hcount > 80 & hcount < 100  & vcount > 340 & vcount < 360);                                                                                                                                                         
assign placed154f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 340 & vcount < 360);                                                                                                                                                        
assign placed155f = ~blank & (hcount > 120 & hcount < 140  & vcount > 340 & vcount < 360);                                                                                                                                                        
assign placed156f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 340 & vcount < 360);                                                                                                                                                        
assign placed157f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 340 & vcount < 360);                                                                                                                                                        
assign placed158f = ~blank & (hcount > 180 & hcount < 200  & vcount > 340 & vcount < 360);                                                                                                                                                        
assign placed159f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 340 & vcount < 360);                                                                                                                                                        
assign placed160f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 360 & vcount < 380);                                                                                                                                                          
assign placed161f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 360 & vcount < 380);                                                                                                                                                          
assign placed162f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 360 & vcount < 380);                                                                                                                                                          
assign placed163f =  ~blank & (hcount > 80 & hcount < 100  & vcount > 360 & vcount < 380);                                                                                                                                                         
assign placed164f = ~blank & (hcount > 100 & hcount < 120  & vcount > 360 & vcount < 380);                                                                                                                                                        
assign placed165f = ~blank & (hcount > 120 & hcount < 140  & vcount > 360 & vcount < 380);                                                                                                                                                        
assign placed166f = ~blank & (hcount > 140 & hcount < 160  & vcount > 360 & vcount < 380);                                                                                                                                                        
assign placed167f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 360 & vcount < 380);                                                                                                                                                        
assign placed168f = ~blank & (hcount > 180 & hcount < 200  & vcount > 360 & vcount < 380);                                                                                                                                                        
assign placed169f = ~blank & (hcount > 200 & hcount < 220  & vcount > 360 & vcount < 380);                                                                                                                                                        
assign placed170f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 380 & vcount < 400);                                                                                                                                                          
assign placed171f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 380 & vcount < 400);                                                                                                                                                          
assign placed172f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 380 & vcount < 400);                                                                                                                                                          
assign placed173f =  ~blank & (hcount > 80 & hcount < 100  & vcount > 380 & vcount < 400);                                                                                                                                                         
assign placed174f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 380 & vcount < 400);                                                                                                                                                        
assign placed175f =  ~blank & (hcount > 120 & hcount < 140  & vcount > 380 & vcount < 400);                                                                                                                                                        
assign placed176f = ~blank & (hcount > 140 & hcount < 160  & vcount > 380 & vcount < 400);                                                                                                                                                        
assign placed177f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 380 & vcount < 400);                                                                                                                                                        
assign placed178f = ~blank & (hcount > 180 & hcount < 200  & vcount > 380 & vcount < 400);                                                                                                                                                        
assign placed179f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 380 & vcount < 400);                                                                                                                                                        
assign placed180f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 400 & vcount < 420);                                                                                                                                                          
assign placed181f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 400 & vcount < 420);                                                                                                                                                          
assign placed182f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 400 & vcount < 420);                                                                                                                                                          
assign placed183f =  ~blank & (hcount > 80 & hcount < 100  & vcount > 400 & vcount < 420);                                                                                                                                                         
assign placed184f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 400 & vcount < 420);                                                                                                                                                        
assign placed185f = ~blank & (hcount > 120 & hcount < 140  & vcount > 400 & vcount < 420);                                                                                                                                                        
assign placed186f = ~blank & (hcount > 140 & hcount < 160  & vcount > 400 & vcount < 420); 
assign placed187f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 400 & vcount < 420);                                                                                                                                                        
assign placed188f =  ~blank & (hcount > 180 & hcount < 200  & vcount > 400 & vcount < 420);                                                                                                                                                        
assign placed189f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 400 & vcount < 420);                                                                                                                                                        
assign placed190f =  ~blank & (hcount > 20 & hcount < 40  & vcount > 420 & vcount < 440);                                                                                                                                                          
assign placed191f =  ~blank & (hcount > 40 & hcount < 60  & vcount > 420 & vcount < 440);                                                                                                                                                          
assign placed192f =  ~blank & (hcount > 60 & hcount < 80  & vcount > 420 & vcount < 440);                                                                                                                                                          
assign placed193f =  ~blank & (hcount > 80 & hcount < 100  & vcount > 420 & vcount < 440);                                                                                                                                                         
assign placed194f =  ~blank & (hcount > 100 & hcount < 120  & vcount > 420 & vcount < 440);                                                                                                                                                        
assign placed195f =  ~blank & (hcount > 120 & hcount < 140  & vcount > 420 & vcount < 440);                                                                                                                                                        
assign placed196f =  ~blank & (hcount > 140 & hcount < 160  & vcount > 420 & vcount < 440);                                                                                                                                                        
assign placed197f =  ~blank & (hcount > 160 & hcount < 180  & vcount > 420 & vcount < 440);                                                                                                                                                        
assign placed198f =  ~blank & (hcount > 180 & hcount < 200  & vcount > 420 & vcount < 440);                                                                                                                                                        
assign placed199f =  ~blank & (hcount > 200 & hcount < 220  & vcount > 420 & vcount < 440);    




reg downOK1;

//reg resetAll;
/*
always @(posedge clk)begin 
//if (resetAll != 0) begin
if (row1 == 0)begin                                                                                                                                                                                                                                     
 if (coL1 == 0)begin if(r0[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                             
 if (coL1 == 1)begin if(r0[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r0[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r0[3] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 4)begin if(r0[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r0[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                     
 if (coL1 == 6)begin if(r0[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r0[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r0[8] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 9)begin if(r0[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                             
else if (row1 == 1)begin                                                                                                                                                                                                                                     
 if (coL1 == 0)begin if(r1[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                             
 if (coL1 == 1)begin if(r1[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r1[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r1[3] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 4)begin if(r1[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r1[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                     
 if (coL1 == 6)begin if(r1[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r1[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r1[8] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 9)begin if(r1[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                             
else if (row1 == 2)begin                                                                                                                                                                                                                                     
 if (coL1 == 0)begin if(r2[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                             
 if (coL1 == 1)begin if(r2[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r2[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r2[3] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 4)begin if(r2[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r2[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                     
 if (coL1 == 6)begin if(r2[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r2[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r2[8] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 9)begin if(r2[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                             
else if (row1 == 3)begin                                                                                                                                                                                                                                     
 if (coL1 == 0)begin if(r3[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                             
 if (coL1 == 1)begin if(r3[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r3[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r3[3] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 4)begin if(r3[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r3[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                     
 if (coL1 == 6)begin if(r3[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r3[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r3[8] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 9)begin if(r3[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                             
else if (row1 == 4)begin                                                                                                                                                                                                                                     
 if (coL1 == 0)begin if(r4[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                             
 if (coL1 == 1)begin if(r4[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r4[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r4[3] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 4)begin if(r4[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r4[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                     
 if (coL1 == 6)begin if(r4[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r4[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r4[8] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 9)begin if(r4[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                             
else if (row1 == 5)begin                                                                                                                                                                                                                                     
 if (coL1 == 0)begin if(r5[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                             
 if (coL1 == 1)begin if(r5[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r5[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r5[3] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 4)begin if(r5[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r5[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                     
 if (coL1 == 6)begin if(r5[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r5[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r5[8] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 9)begin if(r5[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                             
else if (row1 == 6)begin                                                                                                                                                                                                                                     
 if (coL1 == 0)begin if(r6[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                             
 if (coL1 == 1)begin if(r6[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r6[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r6[3] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 4)begin if(r6[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r6[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                     
 if (coL1 == 6)begin if(r6[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r6[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r6[8] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 9)begin if(r6[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                             
else if (row1 == 7)begin                                                                                                                                                                                                                                     
 if (coL1 == 0)begin if(r7[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                             
 if (coL1 == 1)begin if(r7[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r7[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r7[3] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 4)begin if(r7[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r7[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                     
 if (coL1 == 6)begin if(r7[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r7[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r7[8] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 9)begin if(r7[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end 

else if (row1 == 8)begin                                                                                                                                                                                                                                     
 if (coL1 == 0)begin if(r8[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                             
 if (coL1 == 1)begin if(r8[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r8[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r8[3] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 4)begin if(r8[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r8[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                     
 if (coL1 == 6)begin if(r8[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r8[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r8[8] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 9)begin if(r8[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end 


else if (row1 == 9)begin                                                                                                                                                                                                                                     
 if (coL1 == 0)begin if(r9[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                             
 if (coL1 == 1)begin if(r9[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r9[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r9[3] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 4)begin if(r9[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r9[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                     
 if (coL1 == 6)begin if(r9[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r9[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r9[8] == 0)begin downOK1 = 0; end else
 begin downOK1 = 1; end end  if (coL1 == 9)begin if(r9[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                             
else if (row1 == 10)begin                                                                                                                                                                                                                                    
 if (coL1 == 0)begin if(r10[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                            
 if (coL1 == 1)begin if(r10[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r10[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r10[3] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 4)begin if(r10[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r10[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                
 if (coL1 == 6)begin if(r10[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r10[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r10[8] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 9)begin if(r10[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                         
else if (row1 == 11)begin                                                                                                                                                                                                                                    
 if (coL1 == 0)begin if(r11[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                            
 if (coL1 == 1)begin if(r11[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r11[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r11[3] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 4)begin if(r11[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r11[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                
 if (coL1 == 6)begin if(r11[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r11[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r11[8] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 9)begin if(r11[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                         
else if (row1 == 12)begin                                                                                                                                                                                                                                    
 if (coL1 == 0)begin if(r12[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                            
 if (coL1 == 1)begin if(r12[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r12[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r12[3] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 4)begin if(r12[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r12[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                
 if (coL1 == 6)begin if(r12[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r12[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r12[8] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 9)begin if(r12[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                         
else if (row1 == 13)begin                                                                                                                                                                                                                                    
 if (coL1 == 0)begin if(r13[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                            
 if (coL1 == 1)begin if(r13[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r13[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r13[3] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 4)begin if(r13[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r13[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                
 if (coL1 == 6)begin if(r13[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r13[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r13[8] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 9)begin if(r13[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                         
else if (row1 == 14)begin                                                                                                                                                                                                                                    
 if (coL1 == 0)begin if(r14[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                            
 if (coL1 == 1)begin if(r14[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r14[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r14[3] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 4)begin if(r14[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r14[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                
 if (coL1 == 6)begin if(r14[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r14[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r14[8] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 9)begin if(r14[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                         
else if (row1 == 15)begin                                                                                                                                                                                                                                    
 if (coL1 == 0)begin if(r15[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                            
 if (coL1 == 1)begin if(r15[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r15[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r15[3] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 4)begin if(r15[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r15[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                
 if (coL1 == 6)begin if(r15[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r15[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r15[8] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 9)begin if(r15[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end     

else if (row1 == 16)begin                                                                                                                                                                                                                                    
 if (coL1 == 0)begin if(r16[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                            
 if (coL1 == 1)begin if(r16[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r16[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r16[3] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 4)begin if(r16[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r16[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                
 if (coL1 == 6)begin if(r16[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r16[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r16[8] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 9)begin if(r16[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                         
else if (row1 == 17)begin                                                                                                                                                                                                                                    
 if (coL1 == 0)begin if(r17[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                            
 if (coL1 == 1)begin if(r17[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r17[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r17[3] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 4)begin if(r17[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r17[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                
 if (coL1 == 6)begin if(r17[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r17[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r17[8] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 9)begin if(r17[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                         
else if (row1 == 18)begin                                                                                                                                                                                                                                    
 if (coL1 == 0)begin if(r18[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                            
 if (coL1 == 1)begin if(r18[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r18[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r18[3] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 4)begin if(r18[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r18[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                
 if (coL1 == 6)begin if(r18[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r18[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r18[8] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 9)begin if(r18[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end                                                                                                                         
else if (row1 == 19)begin                                                                                                                                                                                                                                    
 if (coL1 == 0)begin if(r19[0] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                                                                                                                                            
 if (coL1 == 1)begin if(r19[1] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 2)begin if(r19[2] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 3)begin if(r19[3] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 4)begin if(r19[4] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 5)begin if(r19[5] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end                                
 if (coL1 == 6)begin if(r19[6] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 7)begin if(r19[7] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 8)begin if(r19[8] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end  if (coL1 == 9)begin if(r19[9] == 0)begin downOK1 = 0; end else begin downOK1 = 1; end end end     

//if(downOK1!=0)begin resetAll=0; end  //should be 1...
//downOK1 = r0[coL1];
//end
end

 
*/



//end

//checkDirection checkBlock1(clk, xMemory+20,yMemory,r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,  reset2, left2, right2, down2);

assign overlap = ~blank & tester & placed;

//wire down3;
//reg reset3;
//checkDirection2 checkBlock1simple(clk,yMemory,reset3,down3);

assign placed =  (placed0 || placed1 || placed2 || placed3 || placed4 || placed5 || placed6 || placed7 || placed8 || placed9 || placed10 || placed11 || placed12 || placed13 || placed14 || placed15 || placed16 || placed17 || placed18 || placed19 || placed20 || placed21 || placed22 || placed23 || placed24 || placed25 || placed26 || placed27 || placed28 || placed29 || placed30 || placed31 || placed32 || placed33 || placed34 || placed35 || placed36 || placed37 || placed38 || placed39 || placed40 || placed41 || placed42 || placed43 || placed44 || placed45 || placed46 || placed47 || placed48 || placed49 || placed50 || placed51 || placed52 || placed53 || placed54 || placed55 || placed56 || placed57 || placed58 || placed59 || placed60 || placed61 || placed62 || placed63 || placed64 || placed65 || placed66 || placed67 || placed68 || placed69 || placed70 || placed71 || placed72 || placed73 || placed74 || placed75 || placed76 || placed77 || placed78 || placed79 || placed80 || placed81 || placed82 || placed83 || placed84 || placed85 || placed86 || placed87 || placed88 || placed89 || placed90 || placed91 || placed92 || placed93 || placed94 || placed95 || placed96 || placed97 || placed98 || placed99 || placed100 || placed101 || placed102 || placed103 || placed104 || placed105 || placed106 || placed107 || placed108 || placed109 || placed110 || placed111 || placed112 || placed113 || placed114 || placed115 || placed116 || placed117 || placed118 || placed119 || placed120 || placed121 || placed122 || placed123 || placed124 || placed125 || placed126 || placed127 || placed128 || placed129 || placed130 || placed131 || placed132 || placed133 || placed134 || placed135 || placed136 || placed137 || placed138 || placed139 || placed140 || placed141 || placed142 || placed143 || placed144 || placed145 || placed146 || placed147 || placed148 || placed149 || placed150 || placed151 || placed152 || placed153 || placed154 || placed155 || placed156 || placed157 || placed158 || placed159 || placed160 || placed161 || placed162 || placed163 || placed164 || placed165 || placed166 || placed167 || placed168 || placed169 || placed170 || placed171 || placed172 || placed173 || placed174 || placed175 || placed176 || placed177 || placed178 || placed179 || placed180 || placed181 || placed182 || placed183 || placed184 || placed185 || placed186 || placed187 || placed188 || placed189 || placed190 || placed191 || placed192 || placed193 || placed194 || placed195 || placed196 || placed197 || placed198 || placed199);	 
	 
	 reg firstTime;
	

initial begin resetFig=0; end

reg [4:0] counter222;

reg [5:0] countSmallSteps;
initial countSmallSteps = 0;


always @(posedge slow_clk2) begin
/*
if(resetAll) begin
countSmallSteps = 0;
firstTime = 0;
yMemory = 0; 
xMemory = 0;
end
*/


if(countSmallSteps>5) begin
countSmallSteps = 0;
firstTime = 0;
yMemory = 0; 
xMemory = 0;
end

/*
if(resetAll==1) begin

firstTime = 0;
yMemory = 0; 
xMemory = 0;

end
*/

counter222 = counter222+1;
/*
if(counter222>7) begin
//r19[8] = 1; r19[5] = 1; r19[6] = 1; r19[7] = 1; r19[4] = 1; r19[3] = 1; r19[2] = 1; r19[1] = 1; r19[0] = 1; 
end


if(counter222<=7) begin
//r19[8] = 0; r19[5] = 0; r19[6] = 0; r19[7] = 0; r19[4] = 0; r19[3] = 0; r19[2] = 0; r19[1] = 0; r19[0] = 0; 

end
*/

if (resetFig/*&!left*/) begin 

//r0[0] = 1;
countSmallSteps = 0;
firstTime = 0;
yMemory = 0; 
xMemory = 0;
//resetFig = 0;

end


else begin

//always @(posedge clk)begin
/*
if(downOK1 == 1&resetAll == 0)begin
//resetAll = 1;
firstTime = 0;
yMemory = 0; 
xMemory = 0;

end

 */
if(!firstTime)begin
xMemory = xMemory +120;
//yMemory = yMemory;
firstTime = 1;
end

if (up) begin
yMemory = yMemory -10; end
if (!noD&down) begin
yMemory = yMemory +20; end
if (!noR&right&xMemory<200) begin 
xMemory = xMemory +20; end 
if (!noL&left&xMemory>20) begin
xMemory = xMemory -20; end


if(yMemory < 450)begin


//else begin
//if(yMemory>20&(~blank &(hcount >= xMemory& hcount <= xMemory+1 & yMemory+33 < vcount&yMemory+53 > vcount)))begin 
//if (yMemory>20&(placed || (hcount == xMemory+4 & yMemory <= vcount+33)))begin 
//always @ (!(RC[row1:coL1])) begin

if (!yMemStick) begin
yMemory = yMemory + 10; 

end

else if(yMemStick) begin
if (slow_clk == 1) begin
yMemory = yMemory + 1; 
countSmallSteps = countSmallSteps+1;
end
end
//recountLeftRightAllowances = 1;


//reset3=0;
//reset3 = 1;
/*
if(down3>0) begin
firstTime = 0;
yMemory = 0; 
xMemory = 0;
reset3 = 1;
end*/
//end
/*
always @ ((yMemory>100)&(RC[row1:coL1])) begin 

firstTime = 0;
yMemory = 0; 
xMemory = 0;

end*/

//end
end

if(yMemory >= 450)begin
firstTime = 0;
//wcountTest = wcountTest+1;
yMemory = 0;
xMemory = 0;
//figure = ~blank & (hcount >= 30+xMemory & hcount <= 40+xMemory & vcount >= 0+yMemory & vcount <= 10+yMemory);
end

end 
end

//always @(posedge clk) begin


/* 
wcountTest = wcountTest+1; 



	 if (wcountTest >21) begin w0 = 1; end
	 else if (wcountTest>19) begin w1 = 1; end
	 else if (wcountTest >15) begin w2 = 1; end
	 else if (wcountTest >14) begin w3 = 1; end
	 else if (wcountTest >13) begin w4 = 1; end
	 else if (wcountTest >12) begin w5 = 1; end
	 else if (wcountTest >11) begin w6 = 1; end
	 else if (wcountTest >9) begin w7 = 1; end
	 else if (wcountTest >8) begin w8 = 1; end
	 else if (wcountTest >6) begin w9 = 1; end
	 else if (wcountTest >5) begin w10 = 1; end
	 else if (wcountTest >3) begin w11 = 1; end
	*/
//w1=1;w88=1;w187=1;w198=1;

//r1[9] = 1;r10[0] = 1; r15[4] = 1; r4[7] = 1; r4[1] = 1;
//end

/*
reg countResets;
initial countResets = 0;

reg countResets2;

always @(posedge slow_clk2) begin
if(countResets == 1) begin
countResets2 = countResets2+1;
end
end

always @(posedge clk) begin
if (countResets2 == 0 ) begin r2[9] = 1;r11[0] = 1; end 
if (countResets2 > 4 ) begin r15[3] = 1; r4[4] = 1; r4[2] = 1; end
end

*/

initial r0[0] = 0; initial r0[1] = 0; initial r0[2] = 0; initial r0[3] = 0; initial r0[4] = 0; initial r0[5] = 0; initial r0[6] = 0; initial r0[7] = 0; initial r0[8] = 0; initial r0[9] = 0; initial r1[0] = 0; initial r1[1] = 0; initial r1[2] = 0; initial r1[3] = 0; initial r1[4] = 0; initial r1[5] = 0; initial r1[6] = 0; initial r1[7] = 0; initial r1[8] = 0; initial r1[9] = 0; initial r2[0] = 0; initial r2[1] = 0; initial r2[2] = 0; initial r2[3] = 0; initial r2[4] = 0; initial r2[5] = 0; initial r2[6] = 0; initial r2[7] = 0; initial r2[8] = 0; initial r2[9] = 0; initial r3[0] = 0; initial r3[1] = 0; initial r3[2] = 0; initial r3[3] = 0; initial r3[4] = 0; initial r3[5] = 0; initial r3[6] = 0; initial r3[7] = 0; initial r3[8] = 0; initial r3[9] = 0; initial r4[0] = 0; initial r4[1] = 0; initial r4[2] = 0; initial r4[3] = 0; initial r4[4] = 0; initial r4[5] = 0; initial r4[6] = 0; initial r4[7] = 0; initial r4[8] = 0; initial r4[9] = 0; initial r5[0] = 0; initial r5[1] = 0; initial r5[2] = 0; initial r5[3] = 0; initial r5[4] = 0; initial r5[5] = 0; initial r5[6] = 0; initial r5[7] = 0; initial r5[8] = 0; initial r5[9] = 0; initial r6[0] = 0; initial r6[1] = 0; initial r6[2] = 0; initial r6[3] = 0; initial r6[4] = 0; initial r6[5] = 0; initial r6[6] = 0; initial r6[7] = 0; initial r6[8] = 0; initial r6[9] = 0; initial r7[0] = 0; initial r7[1] = 0; initial r7[2] = 0; initial r7[3] = 0; initial r7[4] = 0; initial r7[5] = 0; initial r7[6] = 0; initial r7[7] = 0; initial r7[8] = 0; initial r7[9] = 0; initial r8[0] = 0; initial r8[1] = 0; initial r8[2] = 0; initial r8[3] = 0; initial r8[4] = 0; initial r8[5] = 0; initial r8[6] = 0; initial r8[7] = 0; initial r8[8] = 0; initial r8[9] = 0; initial r9[0] = 0; initial r9[1] = 0; initial r9[2] = 0; initial r9[3] = 0; initial r9[4] = 0; initial r9[5] = 0; initial r9[6] = 0; initial r9[7] = 0; initial r9[8] = 0; initial r9[9] = 0; initial r10[0] = 0; initial r10[1] = 0; initial r10[2] = 0; initial r10[3] = 0; initial r10[4] = 0; initial r10[5] = 0; initial r10[6] = 0; initial r10[7] = 0; initial r10[8] = 0; initial r10[9] = 0; initial r11[0] = 0; initial r11[1] = 0; initial r11[2] = 0; initial r11[3] = 0; initial r11[4] = 0; initial r11[5] = 0; initial r11[6] = 0; initial r11[7] = 0; initial r11[8] = 0; initial r11[9] = 0; initial r12[0] = 0; initial r12[1] = 0; initial r12[2] = 0; initial r12[3] = 0; initial r12[4] = 0; initial r12[5] = 0; initial r12[6] = 0; initial r12[7] = 0; initial r12[8] = 0; initial r12[9] = 0; initial r13[0] = 0; initial r13[1] = 0; initial r13[2] = 0; initial r13[3] = 0; initial r13[4] = 0; initial r13[5] = 0; initial r13[6] = 0; initial r13[7] = 0; initial r13[8] = 0; initial r13[9] = 0; initial r14[0] = 0; initial r14[1] = 0; initial r14[2] = 0; initial r14[3] = 0; initial r14[4] = 0; initial r14[5] = 0; initial r14[6] = 0; initial r14[7] = 0; initial r14[8] = 0; initial r14[9] = 0; initial r15[0] = 0; initial r15[1] = 0; initial r15[2] = 0; initial r15[3] = 0; initial r15[4] = 0; initial r15[5] = 0; initial r15[6] = 0; initial r15[7] = 0; initial r15[8] = 0; initial r15[9] = 0; initial r16[0] = 0; initial r16[1] = 0; initial r16[2] = 0; initial r16[3] = 0; initial r16[4] = 0; initial r16[5] = 0; initial r16[6] = 0; initial r16[7] = 0; initial r16[8] = 0; initial r16[9] = 0; initial r17[0] = 0; initial r17[1] = 0; initial r17[2] = 0; initial r17[3] = 0; initial r17[4] = 0; initial r17[5] = 0; initial r17[6] = 0; initial r17[7] = 0; initial r17[8] = 0; initial r17[9] = 0; initial r18[0] = 0; initial r18[1] = 0; initial r18[2] = 0; initial r18[3] = 0; initial r18[4] = 0; initial r18[5] = 0; initial r18[6] = 0; initial r18[7] = 0; initial r18[8] = 0; initial r18[9] = 0; initial r19[0] = 0; initial r19[1] = 0; initial r19[2] = 0; initial r19[3] = 0; initial r19[4] = 0; initial r19[5] = 0; initial r19[6] = 0; initial r19[7] = 0; initial r19[8] = 0; initial r19[9] = 0; 






reg placeBlockNotOk;
reg blocksNeedPlacement;
reg [7:0] blocksPlaced;
reg yMemStick;

reg [9:0] blocksFilledIn;
reg [9:0] blocksFilledInCurrent;
initial blocksFilledIn = 0;
initial blocksFilledInCurrent = 0;




//reg recountLeftRightAllowances;

//initial r19[9] = 0;
/*
always @(posedge clk) begin
if(yMemory==0)begin
noR = 0;
end

if (!(testerR && placed)) begin
noR = 0;
end

else if (testerR && placed) begin
noR = 1;
end

end
*/
reg noLsingle, noRsingle, noDsingle;
initial noLsingle=0;initial noRsingle=0;initial noDsingle=0;


always @(posedge clk) begin

//noL = noL || testerL && placed

if(yMemory==0)begin
noRsingle = 0;
end
/*if (testerL && placed) begin
noL = 1;
end*/

noRsingle = (noRsingle || (testerR && placed))&!slow_clk2;


end




always @(posedge clk) begin


//noL = noL || testerL && placed

if(yMemory==0)begin
noLsingle = 0;
end
/*if (testerL && placed) begin
noL = 1;
end*/

noLsingle = (noLsingle || (testerL && placed))&!slow_clk2;


end



always @(posedge clk) begin

//noL = noL || testerL && placed

if(yMemory==0)begin
noDsingle = 0;
end
/*if (testerL && placed) begin
noL = 1;
end*/

noDsingle = (noDsingle || ((testerD && placed )|| (testerD && border)))&!slow_clk2;


end






//reg placeBlockNotOk;





always @ (posedge clk) begin


if (resetAll) begin
placeBlockNotOk = 0;
resetFig = 1;
r0 =0;r1 =0;r2 =0;r3 =0;r4 =0;r5 =0;r6 =0;r7 =0;r8 =0;r9 =0;r10 =0;r11 =0;r12 =0;r13 =0;r14 =0;r15 =0;r16 =0;r17 =0;r18 =0;r19 =0;
switch = 0;
//big_bin = 0;

end


//r1[9] = 1;r10[0] = 1; r15[4] = 1; r4[7] = 1; r4[1] = 1;
//r19[4] = 1; r18[6] = 1;r17[7] = 1; r16[5] = 1;


if(r19[0]*r19[1]*r19[2]*r19[3]*r19[4]*r19[5]*r19[6]*r19[7]*r19[8]*r19[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r19 = r18; r18 = r17; r17 = r16; r16 = r15; r15 = r14; r14 = r13; r13 = r12; r12 = r11; r11 = r10; r10 = r9; r9 = r8; r8 = r7; r7 = r6; r6 = r5; r5 = r4; r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end

if(r18[0]*r18[1]*r18[2]*r18[3]*r18[4]*r18[5]*r18[6]*r18[7]*r18[8]*r18[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r18 = r17; r17 = r16; r16 = r15; r15 = r14; r14 = r13; r13 = r12; r12 = r11; r11 = r10; r10 = r9; r9 = r8; r8 = r7; r7 = r6; r6 = r5; r5 = r4; r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end
if(r17[0]*r17[1]*r17[2]*r17[3]*r17[4]*r17[5]*r17[6]*r17[7]*r17[8]*r17[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r17 = r16; r16 = r15; r15 = r14; r14 = r13; r13 = r12; r12 = r11; r11 = r10; r10 = r9; r9 = r8; r8 = r7; r7 = r6; r6 = r5; r5 = r4; r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end

if(r16[0]*r16[1]*r16[2]*r16[3]*r16[4]*r16[5]*r16[6]*r16[7]*r16[8]*r16[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r16 = r15; r15 = r14; r14 = r13; r13 = r12; r12 = r11; r11 = r10; r10 = r9; r9 = r8; r8 = r7; r7 = r6; r6 = r5; r5 = r4; r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end

if(r15[0]*r15[1]*r15[2]*r15[3]*r15[4]*r15[5]*r15[6]*r15[7]*r15[8]*r15[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r15 = r14; r14 = r13; r13 = r12; r12 = r11; r11 = r10; r10 = r9; r9 = r8; r8 = r7; r7 = r6; r6 = r5; r5 = r4; r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end

if(r14[0]*r14[1]*r14[2]*r14[3]*r14[4]*r14[5]*r14[6]*r14[7]*r14[8]*r14[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r14 = r13; r13 = r12; r12 = r11; r11 = r10; r10 = r9; r9 = r8; r8 = r7; r7 = r6; r6 = r5; r5 = r4; r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end
if(r13[0]*r13[1]*r13[2]*r13[3]*r13[4]*r13[5]*r13[6]*r13[7]*r13[8]*r13[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r13 = r12; r12 = r11; r11 = r10; r10 = r9; r9 = r8; r8 = r7; r7 = r6; r6 = r5; r5 = r4; r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end

if(r12[0]*r12[1]*r12[2]*r12[3]*r12[4]*r12[5]*r12[6]*r12[7]*r12[8]*r12[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r12 = r11; r11 = r10; r10 = r9; r9 = r8; r8 = r7; r7 = r6; r6 = r5; r5 = r4; r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end

if(r11[0]*r11[1]*r11[2]*r11[3]*r11[4]*r11[5]*r11[6]*r11[7]*r11[8]*r11[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r11 = r10; r10 = r9; r9 = r8; r8 = r7; r7 = r6; r6 = r5; r5 = r4; r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end


if(r10[0]*r10[1]*r10[2]*r10[3]*r10[4]*r10[5]*r10[6]*r10[7]*r10[8]*r10[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r10 = r9; r9 = r8; r8 = r7; r7 = r6; r6 = r5; r5 = r4; r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end

if(r9[0]*r9[1]*r9[2]*r9[3]*r9[4]*r9[5]*r9[6]*r9[7]*r9[8]*r9[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r9 = r8; r8 = r7; r7 = r6; r6 = r5; r5 = r4; r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end

if(r8[0]*r8[1]*r8[2]*r8[3]*r8[4]*r8[5]*r8[6]*r8[7]*r8[8]*r8[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r8 = r7; r7 = r6; r6 = r5; r5 = r4; r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end

if(r7[0]*r7[1]*r7[2]*r7[3]*r7[4]*r7[5]*r7[6]*r7[7]*r7[8]*r7[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r7 = r6; r6 = r5; r5 = r4; r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end

if(r6[0]*r6[1]*r6[2]*r6[3]*r6[4]*r6[5]*r6[6]*r6[7]*r6[8]*r6[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r6 = r5; r5 = r4; r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end


if(r5[0]*r5[1]*r5[2]*r5[3]*r5[4]*r5[5]*r5[6]*r5[7]*r5[8]*r5[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r5 = r4; r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end
if(r4[0]*r4[1]*r4[2]*r4[3]*r4[4]*r4[5]*r4[6]*r4[7]*r4[8]*r4[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r4 = r3; r3 = r2; r2 = r1; r1 = r0; r0 = 0;end
if(r3[0]*r3[1]*r3[2]*r3[3]*r3[4]*r3[5]*r3[6]*r3[7]*r3[8]*r3[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r3 = r2; r2 = r1; r1 = r0; r0 = 0;end
if(r2[0]*r2[1]*r2[2]*r2[3]*r2[4]*r2[5]*r2[6]*r2[7]*r2[8]*r2[9] == 1) begin
placeBlockNotOk = 1;increaseScore = 1;
r2 = r1; r1 = r0; r0 = 0;end

if(r1[0]*r1[1]*r1[2]*r1[3]*r1[4]*r1[5]*r1[6]*r1[7]*r1[8]*r1[9] == 1) begin
placeBlockNotOk = 1;
increaseScore = 1;
r1 = r0; r0 = 0;end

if(yMemory==0)begin
placeBlockNotOk = 0;
resetFig = 0;
//noR = 0;
//noL = 0;

//countResets = 0;
//r19[4] = 1;
end	 

if(yMemory >0 & yMemory <=60)begin
increaseScore = 0;
if (tester && placed) begin
switch = 1;
end
end


else if (singleBlock||workingTetris) begin 
if(row1>=19&!placeBlockNotOk) begin
if(coL1==0)begin r19[0] = 1; end if(coL1==1)begin r19[1] = 1; end if(coL1==2)begin r19[2] = 1; end if(coL1==3)begin r19[3] = 1; end if(coL1==4)begin r19[4] = 1; end if(coL1==5)begin r19[5] = 1; end if(coL1==6)begin r19[6] = 1; end if(coL1==7)begin r19[7] = 1; end if(coL1==8)begin r19[8] = 1; end if(coL1==9)begin r19[9] = 1; end 
end

else if ((tester && placed)&!placeBlockNotOk) begin

//countResets = 1;
resetFig = 1;


if(row1==18) begin
if(coL1==0)begin r18[0] = 1; end if(coL1==1)begin r18[1] = 1; end if(coL1==2)begin r18[2] = 1; end if(coL1==3)begin r18[3] = 1; end if(coL1==4)begin r18[4] = 1; end if(coL1==5)begin r18[5] = 1; end if(coL1==6)begin r18[6] = 1; end if(coL1==7)begin r18[7] = 1; end if(coL1==8)begin r18[8] = 1; end if(coL1==9)begin r18[9] = 1; end 
end


if(row1==17) begin
if(coL1==0)begin r17[0] = 1; end if(coL1==1)begin r17[1] = 1; end if(coL1==2)begin r17[2] = 1; end if(coL1==3)begin r17[3] = 1; end if(coL1==4)begin r17[4] = 1; end if(coL1==5)begin r17[5] = 1; end if(coL1==6)begin r17[6] = 1; end if(coL1==7)begin r17[7] = 1; end if(coL1==8)begin r17[8] = 1; end if(coL1==9)begin r17[9] = 1; end 
end

if(row1==16) begin
if(coL1==0)begin r16[0] = 1; end if(coL1==1)begin r16[1] = 1; end if(coL1==2)begin r16[2] = 1; end if(coL1==3)begin r16[3] = 1; end if(coL1==4)begin r16[4] = 1; end if(coL1==5)begin r16[5] = 1; end if(coL1==6)begin r16[6] = 1; end if(coL1==7)begin r16[7] = 1; end if(coL1==8)begin r16[8] = 1; end if(coL1==9)begin r16[9] = 1; end 
end

if(row1==15) begin
if(coL1==0)begin r15[0] = 1; end if(coL1==1)begin r15[1] = 1; end if(coL1==2)begin r15[2] = 1; end if(coL1==3)begin r15[3] = 1; end if(coL1==4)begin r15[4] = 1; end if(coL1==5)begin r15[5] = 1; end if(coL1==6)begin r15[6] = 1; end if(coL1==7)begin r15[7] = 1; end if(coL1==8)begin r15[8] = 1; end if(coL1==9)begin r15[9] = 1; end 
end

if(row1==14) begin
if(coL1==0)begin r14[0] = 1; end if(coL1==1)begin r14[1] = 1; end if(coL1==2)begin r14[2] = 1; end if(coL1==3)begin r14[3] = 1; end if(coL1==4)begin r14[4] = 1; end if(coL1==5)begin r14[5] = 1; end if(coL1==6)begin r14[6] = 1; end if(coL1==7)begin r14[7] = 1; end if(coL1==8)begin r14[8] = 1; end if(coL1==9)begin r14[9] = 1; end 
end

if(row1==13) begin  if(coL1==0)begin r13[0] = 1; end  if(coL1==1)begin r13[1] = 1; end  if(coL1==2)begin r13[2] = 1; end  if(coL1==3)begin r13[3] = 1; end  if(coL1==4)begin r13[4] = 1; end  if(coL1==5)begin r13[5] = 1; end  if(coL1==6)begin r13[6] = 1; end  if(coL1==7)begin r13[7] = 1; end  if(coL1==8)begin r13[8] = 1; end  if(coL1==9)begin r13[9] = 1; end  end 
if(row1==12) begin  if(coL1==0)begin r12[0] = 1; end  if(coL1==1)begin r12[1] = 1; end  if(coL1==2)begin r12[2] = 1; end  if(coL1==3)begin r12[3] = 1; end  if(coL1==4)begin r12[4] = 1; end  if(coL1==5)begin r12[5] = 1; end  if(coL1==6)begin r12[6] = 1; end  if(coL1==7)begin r12[7] = 1; end  if(coL1==8)begin r12[8] = 1; end  if(coL1==9)begin r12[9] = 1; end  end 
if(row1==11) begin  if(coL1==0)begin r11[0] = 1; end  if(coL1==1)begin r11[1] = 1; end  if(coL1==2)begin r11[2] = 1; end  if(coL1==3)begin r11[3] = 1; end  if(coL1==4)begin r11[4] = 1; end  if(coL1==5)begin r11[5] = 1; end  if(coL1==6)begin r11[6] = 1; end  if(coL1==7)begin r11[7] = 1; end  if(coL1==8)begin r11[8] = 1; end  if(coL1==9)begin r11[9] = 1; end  end 
if(row1==10) begin  if(coL1==0)begin r10[0] = 1; end  if(coL1==1)begin r10[1] = 1; end  if(coL1==2)begin r10[2] = 1; end  if(coL1==3)begin r10[3] = 1; end  if(coL1==4)begin r10[4] = 1; end  if(coL1==5)begin r10[5] = 1; end  if(coL1==6)begin r10[6] = 1; end  if(coL1==7)begin r10[7] = 1; end  if(coL1==8)begin r10[8] = 1; end  if(coL1==9)begin r10[9] = 1; end  end 
if(row1==9) begin  if(coL1==0)begin r9[0] = 1; end  if(coL1==1)begin r9[1] = 1; end  if(coL1==2)begin r9[2] = 1; end  if(coL1==3)begin r9[3] = 1; end  if(coL1==4)begin r9[4] = 1; end  if(coL1==5)begin r9[5] = 1; end  if(coL1==6)begin r9[6] = 1; end  if(coL1==7)begin r9[7] = 1; end  if(coL1==8)begin r9[8] = 1; end  if(coL1==9)begin r9[9] = 1; end  end 
if(row1==8) begin  if(coL1==0)begin r8[0] = 1; end  if(coL1==1)begin r8[1] = 1; end  if(coL1==2)begin r8[2] = 1; end  if(coL1==3)begin r8[3] = 1; end  if(coL1==4)begin r8[4] = 1; end  if(coL1==5)begin r8[5] = 1; end  if(coL1==6)begin r8[6] = 1; end  if(coL1==7)begin r8[7] = 1; end  if(coL1==8)begin r8[8] = 1; end  if(coL1==9)begin r8[9] = 1; end  end 
if(row1==7) begin  if(coL1==0)begin r7[0] = 1; end  if(coL1==1)begin r7[1] = 1; end  if(coL1==2)begin r7[2] = 1; end  if(coL1==3)begin r7[3] = 1; end  if(coL1==4)begin r7[4] = 1; end  if(coL1==5)begin r7[5] = 1; end  if(coL1==6)begin r7[6] = 1; end  if(coL1==7)begin r7[7] = 1; end  if(coL1==8)begin r7[8] = 1; end  if(coL1==9)begin r7[9] = 1; end  end 
if(row1==6) begin  if(coL1==0)begin r6[0] = 1; end  if(coL1==1)begin r6[1] = 1; end  if(coL1==2)begin r6[2] = 1; end  if(coL1==3)begin r6[3] = 1; end  if(coL1==4)begin r6[4] = 1; end  if(coL1==5)begin r6[5] = 1; end  if(coL1==6)begin r6[6] = 1; end  if(coL1==7)begin r6[7] = 1; end  if(coL1==8)begin r6[8] = 1; end  if(coL1==9)begin r6[9] = 1; end  end 
if(row1==5) begin  if(coL1==0)begin r5[0] = 1; end  if(coL1==1)begin r5[1] = 1; end  if(coL1==2)begin r5[2] = 1; end  if(coL1==3)begin r5[3] = 1; end  if(coL1==4)begin r5[4] = 1; end  if(coL1==5)begin r5[5] = 1; end  if(coL1==6)begin r5[6] = 1; end  if(coL1==7)begin r5[7] = 1; end  if(coL1==8)begin r5[8] = 1; end  if(coL1==9)begin r5[9] = 1; end  end 
if(row1==4) begin  if(coL1==0)begin r4[0] = 1; end  if(coL1==1)begin r4[1] = 1; end  if(coL1==2)begin r4[2] = 1; end  if(coL1==3)begin r4[3] = 1; end  if(coL1==4)begin r4[4] = 1; end  if(coL1==5)begin r4[5] = 1; end  if(coL1==6)begin r4[6] = 1; end  if(coL1==7)begin r4[7] = 1; end  if(coL1==8)begin r4[8] = 1; end  if(coL1==9)begin r4[9] = 1; end  end 
if(row1==3) begin  if(coL1==0)begin r3[0] = 1; end  if(coL1==1)begin r3[1] = 1; end  if(coL1==2)begin r3[2] = 1; end  if(coL1==3)begin r3[3] = 1; end  if(coL1==4)begin r3[4] = 1; end  if(coL1==5)begin r3[5] = 1; end  if(coL1==6)begin r3[6] = 1; end  if(coL1==7)begin r3[7] = 1; end  if(coL1==8)begin r3[8] = 1; end  if(coL1==9)begin r3[9] = 1; end  end 
if(row1==2) begin  if(coL1==0)begin r2[0] = 1; end  if(coL1==1)begin r2[1] = 1; end  if(coL1==2)begin r2[2] = 1; end  if(coL1==3)begin r2[3] = 1; end  if(coL1==4)begin r2[4] = 1; end  if(coL1==5)begin r2[5] = 1; end  if(coL1==6)begin r2[6] = 1; end  if(coL1==7)begin r2[7] = 1; end  if(coL1==8)begin r2[8] = 1; end  if(coL1==9)begin r2[9] = 1; end  end 
if(row1==1) begin  if(coL1==0)begin r1[0] = 1; end  if(coL1==1)begin r1[1] = 1; end  if(coL1==2)begin r1[2] = 1; end  if(coL1==3)begin r1[3] = 1; end  if(coL1==4)begin r1[4] = 1; end  if(coL1==5)begin r1[5] = 1; end  if(coL1==6)begin r1[6] = 1; end  if(coL1==7)begin r1[7] = 1; end  if(coL1==8)begin r1[8] = 1; end  if(coL1==9)begin r1[9] = 1; end  end 
if(row1==0) begin  if(coL1==0)begin r0[0] = 1; end  if(coL1==1)begin r0[1] = 1; end  if(coL1==2)begin r0[2] = 1; end  if(coL1==3)begin r0[3] = 1; end  if(coL1==4)begin r0[4] = 1; end  if(coL1==5)begin r0[5] = 1; end  if(coL1==6)begin r0[6] = 1; end  if(coL1==7)begin r0[7] = 1; end  if(coL1==8)begin r0[8] = 1; end  if(coL1==9)begin r0[9] = 1; end  end 
if(row1==20) begin /*switch = 1; */end
end
///HEREREERE LOTS OF IFS
end

if(!singleBlock&!workingTetris) begin


if(blocksFilledInCurrent >= (blocksFilledIn+4)) begin
//resetFig = 1;
blocksFilledIn = r19[9]+r19[8]+r19[7]+r19[6]+r19[5]+r19[4]+r19[3]+r19[2]+r19[1]+r19[0]+r18[9]+r18[8]+r18[7]+r18[6]+r18[5]+r18[4]+r18[3]+r18[2]+r18[1]+r18[0]+r17[9]+r17[8]+r17[7]+r17[6]+r17[5]+r17[4]+r17[3]+r17[2]+r17[1]+r17[0]+r16[9]+r16[8]+r16[7]+r16[6]+r16[5]+r16[4]+r16[3]+r16[2]+r16[1]+r16[0]+r15[9]+r15[8]+r15[7]+r15[6]+r15[5]+r15[4]+r15[3]+r15[2]+r15[1]+r15[0]+r14[9]+r14[8]+r14[7]+r14[6]+r14[5]+r14[4]+r14[3]+r14[2]+r14[1]+r14[0]+r13[9]+r13[8]+r13[7]+r13[6]+r13[5]+r13[4]+r13[3]+r13[2]+r13[1]+r13[0]+r12[9]+r12[8]+r12[7]+r12[6]+r12[5]+r12[4]+r12[3]+r12[2]+r12[1]+r12[0]+r11[9]+r11[8]+r11[7]+r11[6]+r11[5]+r11[4]+r11[3]+r11[2]+r11[1]+r11[0]+r10[9]+r10[8]+r10[7]+r10[6]+r10[5]+r10[4]+r10[3]+r10[2]+r10[1]+r10[0]+r9[9]+r9[8]+r9[7]+r9[6]+r9[5]+r9[4]+r9[3]+r9[2]+r9[1]+r9[0]+r8[9]+r8[8]+r8[7]+r8[6]+r8[5]+r8[4]+r8[3]+r8[2]+r8[1]+r8[0]+r7[9]+r7[8]+r7[7]+r7[6]+r7[5]+r7[4]+r7[3]+r7[2]+r7[1]+r7[0]+r6[9]+r6[8]+r6[7]+r6[6]+r6[5]+r6[4]+r6[3]+r6[2]+r6[1]+r6[0]+r5[9]+r5[8]+r5[7]+r5[6]+r5[5]+r5[4]+r5[3]+r5[2]+r5[1]+r5[0]+r4[9]+r4[8]+r4[7]+r4[6]+r4[5]+r4[4]+r4[3]+r4[2]+r4[1]+r4[0]+r3[9]+r3[8]+r3[7]+r3[6]+r3[5]+r3[4]+r3[3]+r3[2]+r3[1]+r3[0]+r2[9]+r2[8]+r2[7]+r2[6]+r2[5]+r2[4]+r2[3]+r2[2]+r2[1]+r2[0]+r1[9]+r1[8]+r1[7]+r1[6]+r1[5]+r1[4]+r1[3]+r1[2]+r1[1]+r1[0]+r0[9]+r0[8]+r0[7]+r0[6]+r0[5]+r0[4]+r0[3]+r0[2]+r0[1]+r0[0];
blocksFilledInCurrent = r19[9]+r19[8]+r19[7]+r19[6]+r19[5]+r19[4]+r19[3]+r19[2]+r19[1]+r19[0]+r18[9]+r18[8]+r18[7]+r18[6]+r18[5]+r18[4]+r18[3]+r18[2]+r18[1]+r18[0]+r17[9]+r17[8]+r17[7]+r17[6]+r17[5]+r17[4]+r17[3]+r17[2]+r17[1]+r17[0]+r16[9]+r16[8]+r16[7]+r16[6]+r16[5]+r16[4]+r16[3]+r16[2]+r16[1]+r16[0]+r15[9]+r15[8]+r15[7]+r15[6]+r15[5]+r15[4]+r15[3]+r15[2]+r15[1]+r15[0]+r14[9]+r14[8]+r14[7]+r14[6]+r14[5]+r14[4]+r14[3]+r14[2]+r14[1]+r14[0]+r13[9]+r13[8]+r13[7]+r13[6]+r13[5]+r13[4]+r13[3]+r13[2]+r13[1]+r13[0]+r12[9]+r12[8]+r12[7]+r12[6]+r12[5]+r12[4]+r12[3]+r12[2]+r12[1]+r12[0]+r11[9]+r11[8]+r11[7]+r11[6]+r11[5]+r11[4]+r11[3]+r11[2]+r11[1]+r11[0]+r10[9]+r10[8]+r10[7]+r10[6]+r10[5]+r10[4]+r10[3]+r10[2]+r10[1]+r10[0]+r9[9]+r9[8]+r9[7]+r9[6]+r9[5]+r9[4]+r9[3]+r9[2]+r9[1]+r9[0]+r8[9]+r8[8]+r8[7]+r8[6]+r8[5]+r8[4]+r8[3]+r8[2]+r8[1]+r8[0]+r7[9]+r7[8]+r7[7]+r7[6]+r7[5]+r7[4]+r7[3]+r7[2]+r7[1]+r7[0]+r6[9]+r6[8]+r6[7]+r6[6]+r6[5]+r6[4]+r6[3]+r6[2]+r6[1]+r6[0]+r5[9]+r5[8]+r5[7]+r5[6]+r5[5]+r5[4]+r5[3]+r5[2]+r5[1]+r5[0]+r4[9]+r4[8]+r4[7]+r4[6]+r4[5]+r4[4]+r4[3]+r4[2]+r4[1]+r4[0]+r3[9]+r3[8]+r3[7]+r3[6]+r3[5]+r3[4]+r3[3]+r3[2]+r3[1]+r3[0]+r2[9]+r2[8]+r2[7]+r2[6]+r2[5]+r2[4]+r2[3]+r2[2]+r2[1]+r2[0]+r1[9]+r1[8]+r1[7]+r1[6]+r1[5]+r1[4]+r1[3]+r1[2]+r1[1]+r1[0]+r0[9]+r0[8]+r0[7]+r0[6]+r0[5]+r0[4]+r0[3]+r0[2]+r0[1]+r0[0];
end

blocksFilledIn = r19[9]+r19[8]+r19[7]+r19[6]+r19[5]+r19[4]+r19[3]+r19[2]+r19[1]+r19[0]+r18[9]+r18[8]+r18[7]+r18[6]+r18[5]+r18[4]+r18[3]+r18[2]+r18[1]+r18[0]+r17[9]+r17[8]+r17[7]+r17[6]+r17[5]+r17[4]+r17[3]+r17[2]+r17[1]+r17[0]+r16[9]+r16[8]+r16[7]+r16[6]+r16[5]+r16[4]+r16[3]+r16[2]+r16[1]+r16[0]+r15[9]+r15[8]+r15[7]+r15[6]+r15[5]+r15[4]+r15[3]+r15[2]+r15[1]+r15[0]+r14[9]+r14[8]+r14[7]+r14[6]+r14[5]+r14[4]+r14[3]+r14[2]+r14[1]+r14[0]+r13[9]+r13[8]+r13[7]+r13[6]+r13[5]+r13[4]+r13[3]+r13[2]+r13[1]+r13[0]+r12[9]+r12[8]+r12[7]+r12[6]+r12[5]+r12[4]+r12[3]+r12[2]+r12[1]+r12[0]+r11[9]+r11[8]+r11[7]+r11[6]+r11[5]+r11[4]+r11[3]+r11[2]+r11[1]+r11[0]+r10[9]+r10[8]+r10[7]+r10[6]+r10[5]+r10[4]+r10[3]+r10[2]+r10[1]+r10[0]+r9[9]+r9[8]+r9[7]+r9[6]+r9[5]+r9[4]+r9[3]+r9[2]+r9[1]+r9[0]+r8[9]+r8[8]+r8[7]+r8[6]+r8[5]+r8[4]+r8[3]+r8[2]+r8[1]+r8[0]+r7[9]+r7[8]+r7[7]+r7[6]+r7[5]+r7[4]+r7[3]+r7[2]+r7[1]+r7[0]+r6[9]+r6[8]+r6[7]+r6[6]+r6[5]+r6[4]+r6[3]+r6[2]+r6[1]+r6[0]+r5[9]+r5[8]+r5[7]+r5[6]+r5[5]+r5[4]+r5[3]+r5[2]+r5[1]+r5[0]+r4[9]+r4[8]+r4[7]+r4[6]+r4[5]+r4[4]+r4[3]+r4[2]+r4[1]+r4[0]+r3[9]+r3[8]+r3[7]+r3[6]+r3[5]+r3[4]+r3[3]+r3[2]+r3[1]+r3[0]+r2[9]+r2[8]+r2[7]+r2[6]+r2[5]+r2[4]+r2[3]+r2[2]+r2[1]+r2[0]+r1[9]+r1[8]+r1[7]+r1[6]+r1[5]+r1[4]+r1[3]+r1[2]+r1[1]+r1[0]+r0[9]+r0[8]+r0[7]+r0[6]+r0[5]+r0[4]+r0[3]+r0[2]+r0[1]+r0[0];

if(yMemory <20)begin
clearLineHappened = 0;
yMemStick = 0;
placeBlockNotOk = 0;
blocksPlaced = 0;
blocksNeedPlacement = 0;
resetFig = 0;


end 

 if (blocksPlaced >=(4)) begin
//resetFig = 1;  
end

else if(blocksNeedPlacement & ((blocksPlaced<4) & /*(!slow_clk2) &*/ (!resetFig))) begin


if(row1<=2) begin

if((figuref&&placed39f)&!r3[9]) begin r3[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed38f)&!r3[8]) begin r3[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed37f)&!r3[7]) begin r3[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed36f)&!r3[6]) begin r3[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed35f)&!r3[5]) begin r3[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed34f)&!r3[4]) begin r3[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed33f)&!r3[3]) begin r3[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed32f)&!r3[2]) begin r3[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed31f)&!r3[1]) begin r3[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed30f)&!r3[0]) begin r3[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed29f)&!r2[9]) begin r2[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed28f)&!r2[8]) begin r2[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed27f)&!r2[7]) begin r2[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed26f)&!r2[6]) begin r2[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed25f)&!r2[5]) begin r2[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed24f)&!r2[4]) begin r2[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed23f)&!r2[3]) begin r2[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed22f)&!r2[2]) begin r2[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed21f)&!r2[1]) begin r2[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed20f)&!r2[0]) begin r2[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed19f)&!r1[9]) begin r1[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed18f)&!r1[8]) begin r1[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed17f)&!r1[7]) begin r1[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed16f)&!r1[6]) begin r1[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed15f)&!r1[5]) begin r1[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed14f)&!r1[4]) begin r1[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed13f)&!r1[3]) begin r1[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed12f)&!r1[2]) begin r1[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed11f)&!r1[1]) begin r1[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed10f)&!r1[0]) begin r1[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed9f)&!r0[9]) begin r0[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed8f)&!r0[8]) begin r0[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed7f)&!r0[7]) begin r0[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed6f)&!r0[6]) begin r0[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed5f)&!r0[5]) begin r0[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed4f)&!r0[4]) begin r0[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed3f)&!r0[3]) begin r0[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed2f)&!r0[2]) begin r0[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed1f)&!r0[1]) begin r0[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed0f)&!r0[0]) begin r0[0] = 1;blocksPlaced = blocksPlaced+1; end  
//else if((figuref&&placed49f)&!r4[9]) begin r4[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed48f)&!r4[8]) begin r4[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed47f)&!r4[7]) begin r4[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed46f)&!r4[6]) begin r4[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed45f)&!r4[5]) begin r4[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed44f)&!r4[4]) begin r4[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed43f)&!r4[3]) begin r4[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed42f)&!r4[2]) begin r4[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed41f)&!r4[1]) begin r4[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed40f)&!r4[0]) begin r4[0] = 1;blocksPlaced = blocksPlaced+1; end  
end 

else if(row1>2 & row1<=5) begin

//  if((figuref&&placed79f)&!r7[9]) begin r7[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed78f)&!r7[8]) begin r7[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed77f)&!r7[7]) begin r7[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed76f)&!r7[6]) begin r7[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed75f)&!r7[5]) begin r7[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed74f)&!r7[4]) begin r7[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed73f)&!r7[3]) begin r7[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed72f)&!r7[2]) begin r7[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed71f)&!r7[1]) begin r7[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed70f)&!r7[0]) begin r7[0] = 1;blocksPlaced = blocksPlaced+1; end  
 /*else */ if((figuref&&placed69f)&!r6[9]) begin r6[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed68f)&!r6[8]) begin r6[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed67f)&!r6[7]) begin r6[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed66f)&!r6[6]) begin r6[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed65f)&!r6[5]) begin r6[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed64f)&!r6[4]) begin r6[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed63f)&!r6[3]) begin r6[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed62f)&!r6[2]) begin r6[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed61f)&!r6[1]) begin r6[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed60f)&!r6[0]) begin r6[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed59f)&!r5[9]) begin r5[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed58f)&!r5[8]) begin r5[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed57f)&!r5[7]) begin r5[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed56f)&!r5[6]) begin r5[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed55f)&!r5[5]) begin r5[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed54f)&!r5[4]) begin r5[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed53f)&!r5[3]) begin r5[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed52f)&!r5[2]) begin r5[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed51f)&!r5[1]) begin r5[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed50f)&!r5[0]) begin r5[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed49f)&!r4[9]) begin r4[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed48f)&!r4[8]) begin r4[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed47f)&!r4[7]) begin r4[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed46f)&!r4[6]) begin r4[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed45f)&!r4[5]) begin r4[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed44f)&!r4[4]) begin r4[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed43f)&!r4[3]) begin r4[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed42f)&!r4[2]) begin r4[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed41f)&!r4[1]) begin r4[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed40f)&!r4[0]) begin r4[0] = 1;blocksPlaced = blocksPlaced+1; end  

else if((figuref&&placed39f)&!r3[9]) begin r3[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed38f)&!r3[8]) begin r3[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed37f)&!r3[7]) begin r3[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed36f)&!r3[6]) begin r3[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed35f)&!r3[5]) begin r3[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed34f)&!r3[4]) begin r3[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed33f)&!r3[3]) begin r3[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed32f)&!r3[2]) begin r3[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed31f)&!r3[1]) begin r3[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed30f)&!r3[0]) begin r3[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed29f)&!r2[9]) begin r2[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed28f)&!r2[8]) begin r2[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed27f)&!r2[7]) begin r2[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed26f)&!r2[6]) begin r2[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed25f)&!r2[5]) begin r2[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed24f)&!r2[4]) begin r2[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed23f)&!r2[3]) begin r2[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed22f)&!r2[2]) begin r2[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed21f)&!r2[1]) begin r2[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed20f)&!r2[0]) begin r2[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed19f)&!r1[9]) begin r1[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed18f)&!r1[8]) begin r1[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed17f)&!r1[7]) begin r1[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed16f)&!r1[6]) begin r1[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed15f)&!r1[5]) begin r1[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed14f)&!r1[4]) begin r1[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed13f)&!r1[3]) begin r1[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed12f)&!r1[2]) begin r1[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed11f)&!r1[1]) begin r1[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed10f)&!r1[0]) begin r1[0] = 1;blocksPlaced = blocksPlaced+1; end  

end

else if(row1>5 & row1<=9) begin 
 //if((figuref&&placed119f)&!r11[9]) begin r11[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed118f)&!r11[8]) begin r11[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed117f)&!r11[7]) begin r11[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed116f)&!r11[6]) begin r11[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed115f)&!r11[5]) begin r11[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed114f)&!r11[4]) begin r11[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed113f)&!r11[3]) begin r11[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed112f)&!r11[2]) begin r11[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed111f)&!r11[1]) begin r11[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed110f)&!r11[0]) begin r11[0] = 1;blocksPlaced = blocksPlaced+1; end  
 //else 
 if((figuref&&placed109f)&!r10[9]) begin r10[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed108f)&!r10[8]) begin r10[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed107f)&!r10[7]) begin r10[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed106f)&!r10[6]) begin r10[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed105f)&!r10[5]) begin r10[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed104f)&!r10[4]) begin r10[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed103f)&!r10[3]) begin r10[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed102f)&!r10[2]) begin r10[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed101f)&!r10[1]) begin r10[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed100f)&!r10[0]) begin r10[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed99f)&!r9[9]) begin r9[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed98f)&!r9[8]) begin r9[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed97f)&!r9[7]) begin r9[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed96f)&!r9[6]) begin r9[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed95f)&!r9[5]) begin r9[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed94f)&!r9[4]) begin r9[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed93f)&!r9[3]) begin r9[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed92f)&!r9[2]) begin r9[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed91f)&!r9[1]) begin r9[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed90f)&!r9[0]) begin r9[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed89f)&!r8[9]) begin r8[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed88f)&!r8[8]) begin r8[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed87f)&!r8[7]) begin r8[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed86f)&!r8[6]) begin r8[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed85f)&!r8[5]) begin r8[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed84f)&!r8[4]) begin r8[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed83f)&!r8[3]) begin r8[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed82f)&!r8[2]) begin r8[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed81f)&!r8[1]) begin r8[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed80f)&!r8[0]) begin r8[0] = 1;blocksPlaced = blocksPlaced+1; end  
else if((figuref&&placed79f)&!r7[9]) begin r7[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed78f)&!r7[8]) begin r7[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed77f)&!r7[7]) begin r7[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed76f)&!r7[6]) begin r7[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed75f)&!r7[5]) begin r7[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed74f)&!r7[4]) begin r7[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed73f)&!r7[3]) begin r7[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed72f)&!r7[2]) begin r7[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed71f)&!r7[1]) begin r7[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed70f)&!r7[0]) begin r7[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed69f)&!r6[9]) begin r6[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed68f)&!r6[8]) begin r6[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed67f)&!r6[7]) begin r6[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed66f)&!r6[6]) begin r6[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed65f)&!r6[5]) begin r6[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed64f)&!r6[4]) begin r6[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed63f)&!r6[3]) begin r6[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed62f)&!r6[2]) begin r6[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed61f)&!r6[1]) begin r6[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed60f)&!r6[0]) begin r6[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed59f)&!r5[9]) begin r5[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed58f)&!r5[8]) begin r5[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed57f)&!r5[7]) begin r5[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed56f)&!r5[6]) begin r5[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed55f)&!r5[5]) begin r5[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed54f)&!r5[4]) begin r5[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed53f)&!r5[3]) begin r5[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed52f)&!r5[2]) begin r5[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed51f)&!r5[1]) begin r5[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed50f)&!r5[0]) begin r5[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed49f)&!r4[9]) begin r4[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed48f)&!r4[8]) begin r4[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed47f)&!r4[7]) begin r4[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed46f)&!r4[6]) begin r4[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed45f)&!r4[5]) begin r4[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed44f)&!r4[4]) begin r4[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed43f)&!r4[3]) begin r4[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed42f)&!r4[2]) begin r4[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed41f)&!r4[1]) begin r4[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed40f)&!r4[0]) begin r4[0] = 1;blocksPlaced = blocksPlaced+1; end  

//else if((figuref&&placed39f)&!r3[9]) begin r3[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed38f)&!r3[8]) begin r3[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed37f)&!r3[7]) begin r3[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed36f)&!r3[6]) begin r3[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed35f)&!r3[5]) begin r3[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed34f)&!r3[4]) begin r3[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed33f)&!r3[3]) begin r3[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed32f)&!r3[2]) begin r3[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed31f)&!r3[1]) begin r3[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed30f)&!r3[0]) begin r3[0] = 1;blocksPlaced = blocksPlaced+1; end  

end

else if(row1>9 & row1<=12) begin 
//if((figuref&&placed169f)&!r16[9]) begin r16[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed168f)&!r16[8]) begin r16[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed167f)&!r16[7]) begin r16[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed166f)&!r16[6]) begin r16[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed165f)&!r16[5]) begin r16[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed164f)&!r16[4]) begin r16[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed163f)&!r16[3]) begin r16[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed162f)&!r16[2]) begin r16[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed161f)&!r16[1]) begin r16[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed160f)&!r16[0]) begin r16[0] = 1;blocksPlaced = blocksPlaced+1; end  
 //else if((figuref&&placed159f)&!r15[9]) begin r15[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed158f)&!r15[8]) begin r15[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed157f)&!r15[7]) begin r15[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed156f)&!r15[6]) begin r15[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed155f)&!r15[5]) begin r15[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed154f)&!r15[4]) begin r15[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed153f)&!r15[3]) begin r15[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed152f)&!r15[2]) begin r15[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed151f)&!r15[1]) begin r15[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed150f)&!r15[0]) begin r15[0] = 1;blocksPlaced = blocksPlaced+1; end  
 //else if((figuref&&placed149f)&!r14[9]) begin r14[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed148f)&!r14[8]) begin r14[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed147f)&!r14[7]) begin r14[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed146f)&!r14[6]) begin r14[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed145f)&!r14[5]) begin r14[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed144f)&!r14[4]) begin r14[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed143f)&!r14[3]) begin r14[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed142f)&!r14[2]) begin r14[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed141f)&!r14[1]) begin r14[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed140f)&!r14[0]) begin r14[0] = 1;blocksPlaced = blocksPlaced+1; end  
// else
 if((figuref&&placed139f)&!r13[9]) begin r13[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed138f)&!r13[8]) begin r13[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed137f)&!r13[7]) begin r13[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed136f)&!r13[6]) begin r13[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed135f)&!r13[5]) begin r13[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed134f)&!r13[4]) begin r13[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed133f)&!r13[3]) begin r13[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed132f)&!r13[2]) begin r13[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed131f)&!r13[1]) begin r13[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed130f)&!r13[0]) begin r13[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed129f)&!r12[9]) begin r12[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed128f)&!r12[8]) begin r12[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed127f)&!r12[7]) begin r12[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed126f)&!r12[6]) begin r12[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed125f)&!r12[5]) begin r12[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed124f)&!r12[4]) begin r12[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed123f)&!r12[3]) begin r12[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed122f)&!r12[2]) begin r12[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed121f)&!r12[1]) begin r12[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed120f)&!r12[0]) begin r12[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed119f)&!r11[9]) begin r11[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed118f)&!r11[8]) begin r11[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed117f)&!r11[7]) begin r11[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed116f)&!r11[6]) begin r11[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed115f)&!r11[5]) begin r11[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed114f)&!r11[4]) begin r11[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed113f)&!r11[3]) begin r11[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed112f)&!r11[2]) begin r11[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed111f)&!r11[1]) begin r11[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed110f)&!r11[0]) begin r11[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed109f)&!r10[9]) begin r10[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed108f)&!r10[8]) begin r10[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed107f)&!r10[7]) begin r10[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed106f)&!r10[6]) begin r10[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed105f)&!r10[5]) begin r10[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed104f)&!r10[4]) begin r10[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed103f)&!r10[3]) begin r10[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed102f)&!r10[2]) begin r10[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed101f)&!r10[1]) begin r10[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed100f)&!r10[0]) begin r10[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed99f)&!r9[9]) begin r9[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed98f)&!r9[8]) begin r9[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed97f)&!r9[7]) begin r9[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed96f)&!r9[6]) begin r9[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed95f)&!r9[5]) begin r9[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed94f)&!r9[4]) begin r9[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed93f)&!r9[3]) begin r9[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed92f)&!r9[2]) begin r9[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed91f)&!r9[1]) begin r9[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed90f)&!r9[0]) begin r9[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed89f)&!r8[9]) begin r8[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed88f)&!r8[8]) begin r8[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed87f)&!r8[7]) begin r8[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed86f)&!r8[6]) begin r8[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed85f)&!r8[5]) begin r8[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed84f)&!r8[4]) begin r8[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed83f)&!r8[3]) begin r8[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed82f)&!r8[2]) begin r8[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed81f)&!r8[1]) begin r8[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed80f)&!r8[0]) begin r8[0] = 1;blocksPlaced = blocksPlaced+1; end  
 //else if((figuref&&placed79f)&!r7[9]) begin r7[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed78f)&!r7[8]) begin r7[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed77f)&!r7[7]) begin r7[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed76f)&!r7[6]) begin r7[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed75f)&!r7[5]) begin r7[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed74f)&!r7[4]) begin r7[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed73f)&!r7[3]) begin r7[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed72f)&!r7[2]) begin r7[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed71f)&!r7[1]) begin r7[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed70f)&!r7[0]) begin r7[0] = 1;blocksPlaced = blocksPlaced+1; end  

end

else if(row1>12 & row1<=16) begin 
//if((figuref&&placed189f)&!r18[9]) begin r18[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed188f)&!r18[8]) begin r18[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed187f)&!r18[7]) begin r18[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed186f)&!r18[6]) begin r18[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed185f)&!r18[5]) begin r18[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed184f)&!r18[4]) begin r18[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed183f)&!r18[3]) begin r18[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed182f)&!r18[2]) begin r18[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed181f)&!r18[1]) begin r18[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed180f)&!r18[0]) begin r18[0] = 1;blocksPlaced = blocksPlaced+1; end  
 //else 
 if((figuref&&placed179f)&!r17[9]) begin r17[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed178f)&!r17[8]) begin r17[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed177f)&!r17[7]) begin r17[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed176f)&!r17[6]) begin r17[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed175f)&!r17[5]) begin r17[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed174f)&!r17[4]) begin r17[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed173f)&!r17[3]) begin r17[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed172f)&!r17[2]) begin r17[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed171f)&!r17[1]) begin r17[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed170f)&!r17[0]) begin r17[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed169f)&!r16[9]) begin r16[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed168f)&!r16[8]) begin r16[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed167f)&!r16[7]) begin r16[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed166f)&!r16[6]) begin r16[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed165f)&!r16[5]) begin r16[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed164f)&!r16[4]) begin r16[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed163f)&!r16[3]) begin r16[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed162f)&!r16[2]) begin r16[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed161f)&!r16[1]) begin r16[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed160f)&!r16[0]) begin r16[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed159f)&!r15[9]) begin r15[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed158f)&!r15[8]) begin r15[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed157f)&!r15[7]) begin r15[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed156f)&!r15[6]) begin r15[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed155f)&!r15[5]) begin r15[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed154f)&!r15[4]) begin r15[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed153f)&!r15[3]) begin r15[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed152f)&!r15[2]) begin r15[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed151f)&!r15[1]) begin r15[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed150f)&!r15[0]) begin r15[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed149f)&!r14[9]) begin r14[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed148f)&!r14[8]) begin r14[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed147f)&!r14[7]) begin r14[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed146f)&!r14[6]) begin r14[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed145f)&!r14[5]) begin r14[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed144f)&!r14[4]) begin r14[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed143f)&!r14[3]) begin r14[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed142f)&!r14[2]) begin r14[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed141f)&!r14[1]) begin r14[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed140f)&!r14[0]) begin r14[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed139f)&!r13[9]) begin r13[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed138f)&!r13[8]) begin r13[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed137f)&!r13[7]) begin r13[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed136f)&!r13[6]) begin r13[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed135f)&!r13[5]) begin r13[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed134f)&!r13[4]) begin r13[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed133f)&!r13[3]) begin r13[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed132f)&!r13[2]) begin r13[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed131f)&!r13[1]) begin r13[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed130f)&!r13[0]) begin r13[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed129f)&!r12[9]) begin r12[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed128f)&!r12[8]) begin r12[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed127f)&!r12[7]) begin r12[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed126f)&!r12[6]) begin r12[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed125f)&!r12[5]) begin r12[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed124f)&!r12[4]) begin r12[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed123f)&!r12[3]) begin r12[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed122f)&!r12[2]) begin r12[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed121f)&!r12[1]) begin r12[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed120f)&!r12[0]) begin r12[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed119f)&!r11[9]) begin r11[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed118f)&!r11[8]) begin r11[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed117f)&!r11[7]) begin r11[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed116f)&!r11[6]) begin r11[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed115f)&!r11[5]) begin r11[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed114f)&!r11[4]) begin r11[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed113f)&!r11[3]) begin r11[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed112f)&!r11[2]) begin r11[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed111f)&!r11[1]) begin r11[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed110f)&!r11[0]) begin r11[0] = 1;blocksPlaced = blocksPlaced+1; end  
 //else if((figuref&&placed109f)&!r10[9]) begin r10[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed108f)&!r10[8]) begin r10[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed107f)&!r10[7]) begin r10[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed106f)&!r10[6]) begin r10[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed105f)&!r10[5]) begin r10[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed104f)&!r10[4]) begin r10[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed103f)&!r10[3]) begin r10[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed102f)&!r10[2]) begin r10[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed101f)&!r10[1]) begin r10[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed100f)&!r10[0]) begin r10[0] = 1;blocksPlaced = blocksPlaced+1; end  

end

else if(row1>16 & row1<=18) begin 
if((figuref&&placed199f)&!r19[9]) begin r19[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed198f)&!r19[8]) begin r19[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed197f)&!r19[7]) begin r19[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed196f)&!r19[6]) begin r19[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed195f)&!r19[5]) begin r19[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed194f)&!r19[4]) begin r19[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed193f)&!r19[3]) begin r19[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed192f)&!r19[2]) begin r19[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed191f)&!r19[1]) begin r19[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed190f)&!r19[0]) begin r19[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed189f)&!r18[9]) begin r18[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed188f)&!r18[8]) begin r18[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed187f)&!r18[7]) begin r18[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed186f)&!r18[6]) begin r18[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed185f)&!r18[5]) begin r18[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed184f)&!r18[4]) begin r18[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed183f)&!r18[3]) begin r18[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed182f)&!r18[2]) begin r18[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed181f)&!r18[1]) begin r18[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed180f)&!r18[0]) begin r18[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed179f)&!r17[9]) begin r17[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed178f)&!r17[8]) begin r17[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed177f)&!r17[7]) begin r17[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed176f)&!r17[6]) begin r17[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed175f)&!r17[5]) begin r17[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed174f)&!r17[4]) begin r17[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed173f)&!r17[3]) begin r17[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed172f)&!r17[2]) begin r17[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed171f)&!r17[1]) begin r17[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed170f)&!r17[0]) begin r17[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed169f)&!r16[9]) begin r16[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed168f)&!r16[8]) begin r16[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed167f)&!r16[7]) begin r16[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed166f)&!r16[6]) begin r16[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed165f)&!r16[5]) begin r16[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed164f)&!r16[4]) begin r16[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed163f)&!r16[3]) begin r16[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed162f)&!r16[2]) begin r16[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed161f)&!r16[1]) begin r16[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed160f)&!r16[0]) begin r16[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed159f)&!r15[9]) begin r15[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed158f)&!r15[8]) begin r15[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed157f)&!r15[7]) begin r15[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed156f)&!r15[6]) begin r15[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed155f)&!r15[5]) begin r15[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed154f)&!r15[4]) begin r15[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed153f)&!r15[3]) begin r15[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed152f)&!r15[2]) begin r15[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed151f)&!r15[1]) begin r15[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed150f)&!r15[0]) begin r15[0] = 1;blocksPlaced = blocksPlaced+1; end  
 //else if((figuref&&placed149f)&!r14[9]) begin r14[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed148f)&!r14[8]) begin r14[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed147f)&!r14[7]) begin r14[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed146f)&!r14[6]) begin r14[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed145f)&!r14[5]) begin r14[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed144f)&!r14[4]) begin r14[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed143f)&!r14[3]) begin r14[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed142f)&!r14[2]) begin r14[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed141f)&!r14[1]) begin r14[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed140f)&!r14[0]) begin r14[0] = 1;blocksPlaced = blocksPlaced+1; end  
end

else if(row1>18) begin 
if((figuref&&placed199f)&!r19[9]) begin r19[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed198f)&!r19[8]) begin r19[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed197f)&!r19[7]) begin r19[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed196f)&!r19[6]) begin r19[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed195f)&!r19[5]) begin r19[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed194f)&!r19[4]) begin r19[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed193f)&!r19[3]) begin r19[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed192f)&!r19[2]) begin r19[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed191f)&!r19[1]) begin r19[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed190f)&!r19[0]) begin r19[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed189f)&!r18[9]) begin r18[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed188f)&!r18[8]) begin r18[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed187f)&!r18[7]) begin r18[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed186f)&!r18[6]) begin r18[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed185f)&!r18[5]) begin r18[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed184f)&!r18[4]) begin r18[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed183f)&!r18[3]) begin r18[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed182f)&!r18[2]) begin r18[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed181f)&!r18[1]) begin r18[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed180f)&!r18[0]) begin r18[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed179f)&!r17[9]) begin r17[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed178f)&!r17[8]) begin r17[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed177f)&!r17[7]) begin r17[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed176f)&!r17[6]) begin r17[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed175f)&!r17[5]) begin r17[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed174f)&!r17[4]) begin r17[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed173f)&!r17[3]) begin r17[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed172f)&!r17[2]) begin r17[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed171f)&!r17[1]) begin r17[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed170f)&!r17[0]) begin r17[0] = 1;blocksPlaced = blocksPlaced+1; end  
 //else if((figuref&&placed169f)&!r16[9]) begin r16[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed168f)&!r16[8]) begin r16[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed167f)&!r16[7]) begin r16[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed166f)&!r16[6]) begin r16[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed165f)&!r16[5]) begin r16[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed164f)&!r16[4]) begin r16[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed163f)&!r16[3]) begin r16[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed162f)&!r16[2]) begin r16[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed161f)&!r16[1]) begin r16[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed160f)&!r16[0]) begin r16[0] = 1;blocksPlaced = blocksPlaced+1; end  


end
/*
if((figuref&&placed199f)&!r19[9]) begin r19[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed198f)&!r19[8]) begin r19[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed197f)&!r19[7]) begin r19[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed196f)&!r19[6]) begin r19[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed195f)&!r19[5]) begin r19[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed194f)&!r19[4]) begin r19[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed193f)&!r19[3]) begin r19[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed192f)&!r19[2]) begin r19[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed191f)&!r19[1]) begin r19[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed190f)&!r19[0]) begin r19[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed189f)&!r18[9]) begin r18[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed188f)&!r18[8]) begin r18[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed187f)&!r18[7]) begin r18[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed186f)&!r18[6]) begin r18[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed185f)&!r18[5]) begin r18[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed184f)&!r18[4]) begin r18[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed183f)&!r18[3]) begin r18[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed182f)&!r18[2]) begin r18[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed181f)&!r18[1]) begin r18[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed180f)&!r18[0]) begin r18[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed179f)&!r17[9]) begin r17[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed178f)&!r17[8]) begin r17[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed177f)&!r17[7]) begin r17[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed176f)&!r17[6]) begin r17[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed175f)&!r17[5]) begin r17[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed174f)&!r17[4]) begin r17[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed173f)&!r17[3]) begin r17[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed172f)&!r17[2]) begin r17[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed171f)&!r17[1]) begin r17[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed170f)&!r17[0]) begin r17[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed169f)&!r16[9]) begin r16[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed168f)&!r16[8]) begin r16[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed167f)&!r16[7]) begin r16[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed166f)&!r16[6]) begin r16[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed165f)&!r16[5]) begin r16[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed164f)&!r16[4]) begin r16[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed163f)&!r16[3]) begin r16[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed162f)&!r16[2]) begin r16[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed161f)&!r16[1]) begin r16[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed160f)&!r16[0]) begin r16[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed159f)&!r15[9]) begin r15[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed158f)&!r15[8]) begin r15[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed157f)&!r15[7]) begin r15[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed156f)&!r15[6]) begin r15[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed155f)&!r15[5]) begin r15[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed154f)&!r15[4]) begin r15[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed153f)&!r15[3]) begin r15[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed152f)&!r15[2]) begin r15[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed151f)&!r15[1]) begin r15[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed150f)&!r15[0]) begin r15[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed149f)&!r14[9]) begin r14[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed148f)&!r14[8]) begin r14[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed147f)&!r14[7]) begin r14[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed146f)&!r14[6]) begin r14[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed145f)&!r14[5]) begin r14[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed144f)&!r14[4]) begin r14[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed143f)&!r14[3]) begin r14[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed142f)&!r14[2]) begin r14[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed141f)&!r14[1]) begin r14[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed140f)&!r14[0]) begin r14[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed139f)&!r13[9]) begin r13[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed138f)&!r13[8]) begin r13[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed137f)&!r13[7]) begin r13[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed136f)&!r13[6]) begin r13[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed135f)&!r13[5]) begin r13[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed134f)&!r13[4]) begin r13[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed133f)&!r13[3]) begin r13[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed132f)&!r13[2]) begin r13[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed131f)&!r13[1]) begin r13[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed130f)&!r13[0]) begin r13[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed129f)&!r12[9]) begin r12[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed128f)&!r12[8]) begin r12[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed127f)&!r12[7]) begin r12[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed126f)&!r12[6]) begin r12[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed125f)&!r12[5]) begin r12[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed124f)&!r12[4]) begin r12[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed123f)&!r12[3]) begin r12[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed122f)&!r12[2]) begin r12[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed121f)&!r12[1]) begin r12[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed120f)&!r12[0]) begin r12[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed119f)&!r11[9]) begin r11[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed118f)&!r11[8]) begin r11[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed117f)&!r11[7]) begin r11[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed116f)&!r11[6]) begin r11[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed115f)&!r11[5]) begin r11[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed114f)&!r11[4]) begin r11[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed113f)&!r11[3]) begin r11[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed112f)&!r11[2]) begin r11[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed111f)&!r11[1]) begin r11[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed110f)&!r11[0]) begin r11[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed109f)&!r10[9]) begin r10[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed108f)&!r10[8]) begin r10[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed107f)&!r10[7]) begin r10[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed106f)&!r10[6]) begin r10[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed105f)&!r10[5]) begin r10[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed104f)&!r10[4]) begin r10[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed103f)&!r10[3]) begin r10[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed102f)&!r10[2]) begin r10[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed101f)&!r10[1]) begin r10[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed100f)&!r10[0]) begin r10[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed99f)&!r9[9]) begin r9[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed98f)&!r9[8]) begin r9[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed97f)&!r9[7]) begin r9[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed96f)&!r9[6]) begin r9[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed95f)&!r9[5]) begin r9[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed94f)&!r9[4]) begin r9[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed93f)&!r9[3]) begin r9[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed92f)&!r9[2]) begin r9[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed91f)&!r9[1]) begin r9[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed90f)&!r9[0]) begin r9[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed89f)&!r8[9]) begin r8[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed88f)&!r8[8]) begin r8[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed87f)&!r8[7]) begin r8[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed86f)&!r8[6]) begin r8[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed85f)&!r8[5]) begin r8[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed84f)&!r8[4]) begin r8[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed83f)&!r8[3]) begin r8[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed82f)&!r8[2]) begin r8[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed81f)&!r8[1]) begin r8[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed80f)&!r8[0]) begin r8[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed79f)&!r7[9]) begin r7[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed78f)&!r7[8]) begin r7[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed77f)&!r7[7]) begin r7[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed76f)&!r7[6]) begin r7[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed75f)&!r7[5]) begin r7[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed74f)&!r7[4]) begin r7[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed73f)&!r7[3]) begin r7[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed72f)&!r7[2]) begin r7[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed71f)&!r7[1]) begin r7[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed70f)&!r7[0]) begin r7[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed69f)&!r6[9]) begin r6[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed68f)&!r6[8]) begin r6[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed67f)&!r6[7]) begin r6[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed66f)&!r6[6]) begin r6[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed65f)&!r6[5]) begin r6[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed64f)&!r6[4]) begin r6[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed63f)&!r6[3]) begin r6[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed62f)&!r6[2]) begin r6[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed61f)&!r6[1]) begin r6[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed60f)&!r6[0]) begin r6[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed59f)&!r5[9]) begin r5[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed58f)&!r5[8]) begin r5[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed57f)&!r5[7]) begin r5[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed56f)&!r5[6]) begin r5[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed55f)&!r5[5]) begin r5[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed54f)&!r5[4]) begin r5[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed53f)&!r5[3]) begin r5[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed52f)&!r5[2]) begin r5[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed51f)&!r5[1]) begin r5[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed50f)&!r5[0]) begin r5[0] = 1;blocksPlaced = blocksPlaced+1; end  
 else if((figuref&&placed49f)&!r4[9]) begin r4[9] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed48f)&!r4[8]) begin r4[8] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed47f)&!r4[7]) begin r4[7] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed46f)&!r4[6]) begin r4[6] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed45f)&!r4[5]) begin r4[5] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed44f)&!r4[4]) begin r4[4] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed43f)&!r4[3]) begin r4[3] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed42f)&!r4[2]) begin r4[2] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed41f)&!r4[1]) begin r4[1] = 1;blocksPlaced = blocksPlaced+1; end  else if((figuref&&placed40f)&!r4[0]) begin r4[0] = 1;blocksPlaced = blocksPlaced+1; end  
  

*/




else begin /*resetFig = 1;*/ /* blocksNeedPlacement = 0;*//* blocksPlaced = blocksPlaced+1;*/ end

blocksFilledInCurrent = r19[9]+r19[8]+r19[7]+r19[6]+r19[5]+r19[4]+r19[3]+r19[2]+r19[1]+r19[0]+r18[9]+r18[8]+r18[7]+r18[6]+r18[5]+r18[4]+r18[3]+r18[2]+r18[1]+r18[0]+r17[9]+r17[8]+r17[7]+r17[6]+r17[5]+r17[4]+r17[3]+r17[2]+r17[1]+r17[0]+r16[9]+r16[8]+r16[7]+r16[6]+r16[5]+r16[4]+r16[3]+r16[2]+r16[1]+r16[0]+r15[9]+r15[8]+r15[7]+r15[6]+r15[5]+r15[4]+r15[3]+r15[2]+r15[1]+r15[0]+r14[9]+r14[8]+r14[7]+r14[6]+r14[5]+r14[4]+r14[3]+r14[2]+r14[1]+r14[0]+r13[9]+r13[8]+r13[7]+r13[6]+r13[5]+r13[4]+r13[3]+r13[2]+r13[1]+r13[0]+r12[9]+r12[8]+r12[7]+r12[6]+r12[5]+r12[4]+r12[3]+r12[2]+r12[1]+r12[0]+r11[9]+r11[8]+r11[7]+r11[6]+r11[5]+r11[4]+r11[3]+r11[2]+r11[1]+r11[0]+r10[9]+r10[8]+r10[7]+r10[6]+r10[5]+r10[4]+r10[3]+r10[2]+r10[1]+r10[0]+r9[9]+r9[8]+r9[7]+r9[6]+r9[5]+r9[4]+r9[3]+r9[2]+r9[1]+r9[0]+r8[9]+r8[8]+r8[7]+r8[6]+r8[5]+r8[4]+r8[3]+r8[2]+r8[1]+r8[0]+r7[9]+r7[8]+r7[7]+r7[6]+r7[5]+r7[4]+r7[3]+r7[2]+r7[1]+r7[0]+r6[9]+r6[8]+r6[7]+r6[6]+r6[5]+r6[4]+r6[3]+r6[2]+r6[1]+r6[0]+r5[9]+r5[8]+r5[7]+r5[6]+r5[5]+r5[4]+r5[3]+r5[2]+r5[1]+r5[0]+r4[9]+r4[8]+r4[7]+r4[6]+r4[5]+r4[4]+r4[3]+r4[2]+r4[1]+r4[0]+r3[9]+r3[8]+r3[7]+r3[6]+r3[5]+r3[4]+r3[3]+r3[2]+r3[1]+r3[0]+r2[9]+r2[8]+r2[7]+r2[6]+r2[5]+r2[4]+r2[3]+r2[2]+r2[1]+r2[0]+r1[9]+r1[8]+r1[7]+r1[6]+r1[5]+r1[4]+r1[3]+r1[2]+r1[1]+r1[0]+r0[9]+r0[8]+r0[7]+r0[6]+r0[5]+r0[4]+r0[3]+r0[2]+r0[1]+r0[0];
end

else if(row1>=19&(!placeBlockNotOk)& (blocksPlaced < 4)) begin

//r0 = 1; r1=1;r2=1;r3=1;r4=1;r5=1;r6=1;r7=1;r8=1;r9=1;r10=1;r11=1;r12=1;r13=1;r14=1;r15=1;r16=1;r17=1;r18=1;r19=1;
blocksNeedPlacement = 1;
yMemStick = 1;
//if((figure&&placed0f)&!r0[0]) begin r0[0] = 0; end
  
//if(coL1==0)begin r19[0] = 1; end if(coL1==1)begin r19[1] = 1; end if(coL1==2)begin r19[2] = 1; end if(coL1==3)begin r19[3] = 1; end if(coL1==4)begin r19[4] = 1; end if(coL1==5)begin r19[5] = 1; end if(coL1==6)begin r19[6] = 1; end if(coL1==7)begin r19[7] = 1; end if(coL1==8)begin r19[8] = 1; end if(coL1==9)begin r19[9] = 1; end 
end 
 
else if ((tester && placed)&(!placeBlockNotOk) & (blocksPlaced < 4)) begin
 
yMemStick = 1;
blocksNeedPlacement = 1;
//countResets = 1;
 
end









end
	// Movement move1(up, down, left, right,clk,xAdd,yAdd);
	//||figure2||figure3||figure4||figure5||figure6||figure7 
		/*   if (overlap) begin   // if you are within the valid region
            R = 10;
            G = 100; 
            B = 100;*/
				/*	firstTime = 0;
					yMemory = 0; 
					xMemory = 0;*/
      /*  end
		  
		 else */ 
		 if(!switch) begin
		 if (placed) begin   // if you are within the valid region
            R = 50;
            G = 70; 
            B = 200;
        end
		  
		  
		 else  if (figure) begin   // if you are within the valid region
            R = 100;
            G = 20; 
            B = 200;
        end
		  /*
		  if() begin
		  figure = ~blank & (hcount >= 10+xMemory & hcount <= 20+xMemory & vcount >= 0+yMemory & vcount <= 10+yMemory);
		  end
		  */
		  else if (border) begin   // if you are within the valid region
            R = 100;
            G = 20; 
            B = 200;
        end 
        else begin  // if you are outside the valid region
            R = 0; 
            G = 0;
            B = 0;
        end
		  end
		  if(switch) begin
		  R = R1;
		  G=G1;
		  B=B1;
		  end
    end




endmodule

/*
module checkDirection(clk, xpos,ypos,r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,  reset, left, right, down);
input clk, xpos,ypos;
input [10:0] r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19;
input reset;
output reg left,right,down;
//(hcount > 100 & hcount < 120  & vcount > 340 & vcount < 360); 


always @(negedge reset) begin
//if(reset>0)begin 
 left=0;  right=0; down=0;
end

always @(posedge clk) begin

//if(reset ==0 &(ypos>340) & r15[4]) begin 
if((ypos>340)) begin 

 down = 1; 

end 
 end

endmodule

module checkDirection2(clk,yMemory,reset,down3);
input clk;
input yMemory;
input reset;
output reg down3;

always @(negedge reset) begin
  down3=0;
end

always @(posedge clk) begin 
//if(reset ==0 &(ypos>340) & r15[4]) begin 
//if((ypos>340)) begin 
//down3=0;
if (yMemory>100) begin down3=1; end
else begin down3=0; end
end 
//end
endmodule*/

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




//////////////////////////////////////////////////////////////////////////////////
// Company: 		Boston University
// Engineer:		Zafar Takhirov
// 
// Create Date:		11/18/2015
// Design Name: 	EC311 Support Files
// Module Name:    	binary_to_segment
// Project Name: 	Lab4 / Project
// Description:
//					This module receives a 4-bit input and converts it to 7-segment
//					LED (HEX)
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: INCOMPLETE CODE
//
//////////////////////////////////////////////////////////////////////////////////

module binary_to_segment(bin,seven);	
input [3:0] bin;
output reg [6:0] seven; //Assume MSB is A, and LSB is G	

initial	//Initial block, used for correct simulations	
	seven=0;

always @ (*)
	case(bin)	
		0:	seven = 7'b0000001;
		1:	seven = 7'b1001111;
		2: seven = 7'b0010010;
		3: seven = 7'b0000110;
		4: seven = 7'b1001100;
		5: seven = 7'b0100100;
		6: seven = 7'b0100000;
		7: seven = 7'b0001111;
		8: seven = 7'b0000000;
		9: seven = 7'b0000100;
			//	.........
		15: seven = 7'b0111000; // This will show F	
		//remember 0 means ‘‘light-up’’
		default: seven = 7'b1111110;	
	endcase
endmodule	



//////////////////////////////////////////////////////////////////////////////////
// Company: 		Boston University
// Engineer:		Zafar Takhirov
// 
// Create Date:		11/18/2015
// Design Name: 	EC311 Support Files
// Module Name:    	seven_alternate
// Project Name: 	Lab4 / Project
// Description: 	This module takes a 16-bit binary and releases it in chunks of
//					4-bits (nibbles) while synchronizing them with the AN signal.
//					This file is to be used with 7-segment LED 4-displays
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module seven_alternate (big_bin, small_bin, AN, clk);	
	input[15:0] big_bin;		// This receives a huge 16 bit number
	output reg [3:0] small_bin;	// And returns one 4-bit number at a time (this goes into bin2bcd7)
	output reg [3:0] AN;		// While synchronizing it with the Anode signal
	input clk;  				

	reg [1:0] count;  			// we need to iterate through the displays	

	initial begin // Initial block, used for correct simulations	
		AN = 0;
		small_bin = 0;	
		count= 0;
	end	
	
	reg [30:0] cnt;
	reg slowclk;
	
	always @ (posedge clk) begin	
		if (cnt > 50000)
		begin
			slowclk = ~slowclk;
			cnt = 0;
		end
		else 
		begin
			cnt = cnt + 1'b1;
		end
		end
		
	wire [15:0] new_bin;
	bintobcd dog(.binary(big_bin), .tot(new_bin));
	
	always @ (posedge slowclk) begin	
		count = count + 1'b1;
		case (count)	
			0: begin
				AN = 4'b1110;	
				small_bin = new_bin[3:0];
			end	
			1: begin
				AN = 4'b1101;	
				small_bin = new_bin[7:4];
			end	
			2: begin
				AN = 4'b1011;
				small_bin = new_bin[11:8];
			end
			3: begin
				AN = 4'b0111;
				small_bin = new_bin[15:12];
				end
		endcase	
	end
endmodule	


module bintobcd(
    input [15:0] binary,
	 output [15:0] tot
    );
integer i;
reg [3:0] ones;
reg [3:0] tens; 
reg [3:0] hundreds;
reg [3:0] thousands;

always @(binary) begin
    // set 100's, 10's, and 1's to zero
	 thousands = 4'd0;
    hundreds = 4'd0;
    tens = 4'd0;
    ones = 4'd0;

    for (i=15; i>=0; i=i-1) begin
        // add 3 to columns >= 5
		  if (thousands >= 5)
				thousands = thousands +3;
        if (hundreds >= 5)
            hundreds = hundreds + 3;
        if (tens >= 5)
            tens = tens + 3;
        if (ones >= 5)
            ones = ones + 3;

        // shift left one
		  thousands = thousands << 1;
		  thousands[0] = hundreds[3];
        hundreds = hundreds << 1;
        hundreds[0] = tens[3];
        tens = tens << 1;
        tens[0] = ones[3];
        ones = ones << 1;
        ones[0] = binary[i];
    end
end
assign tot = {thousands, hundreds, tens, ones};

endmodule







module aBlock(clearLineHappened,hcount, vcount, clk,blank,xMemory,yMemory,placed,border,slow_clk2,placeBlockNotOk,row1,coL1, noR, noL, noD,resetFig, figure,testerR,testerL,testerD,tester,figuref);
input clearLineHappened;
input [10:0] hcount, vcount;
input clk,blank;
input [10:0] xMemory, yMemory;
input placed,border;
input slow_clk2;
input placeBlockNotOk;
input row1,coL1;
//input reset;

//output  reg [10:0] r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19;
output reg noR, noL, noD;
output reg resetFig;
output figure,testerR,testerL,testerD,tester,figuref;


assign figure = ~blank & (hcount >= xMemory & hcount <= 20+xMemory & vcount >= -20+yMemory & vcount <= 0+yMemory);
assign figuref = ~blank & (hcount > xMemory+5 & hcount < 15+xMemory & vcount > -15+yMemory & vcount < yMemory-5);

	 assign testerR = ~blank & (hcount > 20+xMemory & hcount < 40+xMemory & vcount >= -20+yMemory & vcount <= 0+yMemory);
	 assign testerL = ~blank & (hcount > xMemory -20 & hcount < xMemory & vcount >= -20+yMemory & vcount <= 0+yMemory);
	 assign testerD = ~blank & (hcount > xMemory & hcount < 20+xMemory & vcount > yMemory & vcount < 44+yMemory);
	 
	 assign tester = ~blank & (hcount > xMemory+5 & hcount < 15+xMemory  & vcount > yMemory & vcount < 10+yMemory);   


	// reg noR, noL, noD;
	 initial noR =0; initial noL =0;initial noD =0;
	 
	 

always @(posedge clk) begin

//noL = noL || testerL && placed

if(yMemory==0)begin
noL = 0;
end


noL = (noL || (testerL && placed) || (testerL && border))&!slow_clk2;


end

//row1    coL1

always @(posedge clk) begin

//noL = noL || testerL && placed

if(yMemory==0)begin
noD = 0;
end


noD = (noD || ((testerD && placed )|| (testerD && border)))&!slow_clk2;


end



always @(posedge clk) begin

//noL = noL || testerL && placed

if(yMemory==0)begin
noR = 0;
end
/*if (testerL && placed) begin
noL = 1;
end*/

noR = (noR || (testerR && placed) || (testerR && border))&!slow_clk2;


end
/*
initial begin r0 = 0; r1 = 0; r2=0; r3=0;r4=0;r5=0;r6=0;r7=0;r8=0;r9=0;r10=0;r11=0;r12=0;r13=0;r14=0;r15=0;r16=0;r17=0;r18=0;r19=0; end
*/


always @(posedge clk) begin
/*
if(clearLineHappened) begin 
r0 = 0; r1 = 0; r2=0; r3=0;r4=0;r5=0;r6=0;r7=0;r8=0;r9=0;r10=0;r11=0;r12=0;r13=0;r14=0;r15=0;r16=0;r17=0;r18=0;r19=0;

end
*/


if(yMemory==0)begin
//placeBlockNotOk = 0;
resetFig = 0;
//noR = 0;
//noL = 0;

//countResets = 0;
//r19[4] = 1;
end	
/*
if(row1>=19) begin
if(coL1==0)begin r19[0] = 1; end if(coL1==1)begin r19[1] = 1; end if(coL1==2)begin r19[2] = 1; end if(coL1==3)begin r19[3] = 1; end if(coL1==4)begin r19[4] = 1; end if(coL1==5)begin r19[5] = 1; end if(coL1==6)begin r19[6] = 1; end if(coL1==7)begin r19[7] = 1; end if(coL1==8)begin r19[8] = 1; end if(coL1==9)begin r19[9] = 1; end 
end

else if ((tester && placed)) begin

//countResets = 1;
resetFig = 1;


if(row1==18) begin
if(coL1==0)begin r18[0] = 1; end if(coL1==1)begin r18[1] = 1; end if(coL1==2)begin r18[2] = 1; end if(coL1==3)begin r18[3] = 1; end if(coL1==4)begin r18[4] = 1; end if(coL1==5)begin r18[5] = 1; end if(coL1==6)begin r18[6] = 1; end if(coL1==7)begin r18[7] = 1; end if(coL1==8)begin r18[8] = 1; end if(coL1==9)begin r18[9] = 1; end 
end


if(row1==17) begin
if(coL1==0)begin r17[0] = 1; end if(coL1==1)begin r17[1] = 1; end if(coL1==2)begin r17[2] = 1; end if(coL1==3)begin r17[3] = 1; end if(coL1==4)begin r17[4] = 1; end if(coL1==5)begin r17[5] = 1; end if(coL1==6)begin r17[6] = 1; end if(coL1==7)begin r17[7] = 1; end if(coL1==8)begin r17[8] = 1; end if(coL1==9)begin r17[9] = 1; end 
end

if(row1==16) begin
if(coL1==0)begin r16[0] = 1; end if(coL1==1)begin r16[1] = 1; end if(coL1==2)begin r16[2] = 1; end if(coL1==3)begin r16[3] = 1; end if(coL1==4)begin r16[4] = 1; end if(coL1==5)begin r16[5] = 1; end if(coL1==6)begin r16[6] = 1; end if(coL1==7)begin r16[7] = 1; end if(coL1==8)begin r16[8] = 1; end if(coL1==9)begin r16[9] = 1; end 
end

if(row1==15) begin
if(coL1==0)begin r15[0] = 1; end if(coL1==1)begin r15[1] = 1; end if(coL1==2)begin r15[2] = 1; end if(coL1==3)begin r15[3] = 1; end if(coL1==4)begin r15[4] = 1; end if(coL1==5)begin r15[5] = 1; end if(coL1==6)begin r15[6] = 1; end if(coL1==7)begin r15[7] = 1; end if(coL1==8)begin r15[8] = 1; end if(coL1==9)begin r15[9] = 1; end 
end

if(row1==14) begin
if(coL1==0)begin r14[0] = 1; end if(coL1==1)begin r14[1] = 1; end if(coL1==2)begin r14[2] = 1; end if(coL1==3)begin r14[3] = 1; end if(coL1==4)begin r14[4] = 1; end if(coL1==5)begin r14[5] = 1; end if(coL1==6)begin r14[6] = 1; end if(coL1==7)begin r14[7] = 1; end if(coL1==8)begin r14[8] = 1; end if(coL1==9)begin r14[9] = 1; end 
end
// if (clear) begin
// r13 = 0; 
// r.. = 0;
// end else begin
if(row1==13) begin  if(coL1==0)begin r13[0] = 1; end  if(coL1==1)begin r13[1] = 1; end  if(coL1==2)begin r13[2] = 1; end  if(coL1==3)begin r13[3] = 1; end  if(coL1==4)begin r13[4] = 1; end  if(coL1==5)begin r13[5] = 1; end  if(coL1==6)begin r13[6] = 1; end  if(coL1==7)begin r13[7] = 1; end  if(coL1==8)begin r13[8] = 1; end  if(coL1==9)begin r13[9] = 1; end  end 
if(row1==12) begin  if(coL1==0)begin r12[0] = 1; end  if(coL1==1)begin r12[1] = 1; end  if(coL1==2)begin r12[2] = 1; end  if(coL1==3)begin r12[3] = 1; end  if(coL1==4)begin r12[4] = 1; end  if(coL1==5)begin r12[5] = 1; end  if(coL1==6)begin r12[6] = 1; end  if(coL1==7)begin r12[7] = 1; end  if(coL1==8)begin r12[8] = 1; end  if(coL1==9)begin r12[9] = 1; end  end 
if(row1==11) begin  if(coL1==0)begin r11[0] = 1; end  if(coL1==1)begin r11[1] = 1; end  if(coL1==2)begin r11[2] = 1; end  if(coL1==3)begin r11[3] = 1; end  if(coL1==4)begin r11[4] = 1; end  if(coL1==5)begin r11[5] = 1; end  if(coL1==6)begin r11[6] = 1; end  if(coL1==7)begin r11[7] = 1; end  if(coL1==8)begin r11[8] = 1; end  if(coL1==9)begin r11[9] = 1; end  end 
if(row1==10) begin  if(coL1==0)begin r10[0] = 1; end  if(coL1==1)begin r10[1] = 1; end  if(coL1==2)begin r10[2] = 1; end  if(coL1==3)begin r10[3] = 1; end  if(coL1==4)begin r10[4] = 1; end  if(coL1==5)begin r10[5] = 1; end  if(coL1==6)begin r10[6] = 1; end  if(coL1==7)begin r10[7] = 1; end  if(coL1==8)begin r10[8] = 1; end  if(coL1==9)begin r10[9] = 1; end  end 
if(row1==9) begin  if(coL1==0)begin r9[0] = 1; end  if(coL1==1)begin r9[1] = 1; end  if(coL1==2)begin r9[2] = 1; end  if(coL1==3)begin r9[3] = 1; end  if(coL1==4)begin r9[4] = 1; end  if(coL1==5)begin r9[5] = 1; end  if(coL1==6)begin r9[6] = 1; end  if(coL1==7)begin r9[7] = 1; end  if(coL1==8)begin r9[8] = 1; end  if(coL1==9)begin r9[9] = 1; end  end 
if(row1==8) begin  if(coL1==0)begin r8[0] = 1; end  if(coL1==1)begin r8[1] = 1; end  if(coL1==2)begin r8[2] = 1; end  if(coL1==3)begin r8[3] = 1; end  if(coL1==4)begin r8[4] = 1; end  if(coL1==5)begin r8[5] = 1; end  if(coL1==6)begin r8[6] = 1; end  if(coL1==7)begin r8[7] = 1; end  if(coL1==8)begin r8[8] = 1; end  if(coL1==9)begin r8[9] = 1; end  end 
if(row1==7) begin  if(coL1==0)begin r7[0] = 1; end  if(coL1==1)begin r7[1] = 1; end  if(coL1==2)begin r7[2] = 1; end  if(coL1==3)begin r7[3] = 1; end  if(coL1==4)begin r7[4] = 1; end  if(coL1==5)begin r7[5] = 1; end  if(coL1==6)begin r7[6] = 1; end  if(coL1==7)begin r7[7] = 1; end  if(coL1==8)begin r7[8] = 1; end  if(coL1==9)begin r7[9] = 1; end  end 
if(row1==6) begin  if(coL1==0)begin r6[0] = 1; end  if(coL1==1)begin r6[1] = 1; end  if(coL1==2)begin r6[2] = 1; end  if(coL1==3)begin r6[3] = 1; end  if(coL1==4)begin r6[4] = 1; end  if(coL1==5)begin r6[5] = 1; end  if(coL1==6)begin r6[6] = 1; end  if(coL1==7)begin r6[7] = 1; end  if(coL1==8)begin r6[8] = 1; end  if(coL1==9)begin r6[9] = 1; end  end 
if(row1==5) begin  if(coL1==0)begin r5[0] = 1; end  if(coL1==1)begin r5[1] = 1; end  if(coL1==2)begin r5[2] = 1; end  if(coL1==3)begin r5[3] = 1; end  if(coL1==4)begin r5[4] = 1; end  if(coL1==5)begin r5[5] = 1; end  if(coL1==6)begin r5[6] = 1; end  if(coL1==7)begin r5[7] = 1; end  if(coL1==8)begin r5[8] = 1; end  if(coL1==9)begin r5[9] = 1; end  end 
if(row1==4) begin  if(coL1==0)begin r4[0] = 1; end  if(coL1==1)begin r4[1] = 1; end  if(coL1==2)begin r4[2] = 1; end  if(coL1==3)begin r4[3] = 1; end  if(coL1==4)begin r4[4] = 1; end  if(coL1==5)begin r4[5] = 1; end  if(coL1==6)begin r4[6] = 1; end  if(coL1==7)begin r4[7] = 1; end  if(coL1==8)begin r4[8] = 1; end  if(coL1==9)begin r4[9] = 1; end  end 
if(row1==3) begin  if(coL1==0)begin r3[0] = 1; end  if(coL1==1)begin r3[1] = 1; end  if(coL1==2)begin r3[2] = 1; end  if(coL1==3)begin r3[3] = 1; end  if(coL1==4)begin r3[4] = 1; end  if(coL1==5)begin r3[5] = 1; end  if(coL1==6)begin r3[6] = 1; end  if(coL1==7)begin r3[7] = 1; end  if(coL1==8)begin r3[8] = 1; end  if(coL1==9)begin r3[9] = 1; end  end 
if(row1==2) begin  if(coL1==0)begin r2[0] = 1; end  if(coL1==1)begin r2[1] = 1; end  if(coL1==2)begin r2[2] = 1; end  if(coL1==3)begin r2[3] = 1; end  if(coL1==4)begin r2[4] = 1; end  if(coL1==5)begin r2[5] = 1; end  if(coL1==6)begin r2[6] = 1; end  if(coL1==7)begin r2[7] = 1; end  if(coL1==8)begin r2[8] = 1; end  if(coL1==9)begin r2[9] = 1; end  end 
if(row1==1) begin  if(coL1==0)begin r1[0] = 1; end  if(coL1==1)begin r1[1] = 1; end  if(coL1==2)begin r1[2] = 1; end  if(coL1==3)begin r1[3] = 1; end  if(coL1==4)begin r1[4] = 1; end  if(coL1==5)begin r1[5] = 1; end  if(coL1==6)begin r1[6] = 1; end  if(coL1==7)begin r1[7] = 1; end  if(coL1==8)begin r1[8] = 1; end  if(coL1==9)begin r1[9] = 1; end  end 
if(row1==0) begin  if(coL1==0)begin r0[0] = 1; end  if(coL1==1)begin r0[1] = 1; end  if(coL1==2)begin r0[2] = 1; end  if(coL1==3)begin r0[3] = 1; end  if(coL1==4)begin r0[4] = 1; end  if(coL1==5)begin r0[5] = 1; end  if(coL1==6)begin r0[6] = 1; end  if(coL1==7)begin r0[7] = 1; end  if(coL1==8)begin r0[8] = 1; end  if(coL1==9)begin r0[9] = 1; end  end 
// end
	 
end  */
	 end

// if (&r..) begin
// 	clear = 1
// ...
// end else begin
// clear = 0;
// ..
// end
/*
always @(posedge clk) begin
if (figure) begin   // if you are within the valid region
            R = 100;
            G = 20; 
            B = 200; 
        end*/
		  //end

	 
endmodule





