`timescale 1ns / 1ps

module Multiplier(
	 input [3:0] a,b,
    output [7:0] S,
	 wire [3:0] S1, S2, q,v, w,carries, wsecond,vsecond, wthird, vthird, S3, doNotUse/*,
	 output [3:0] g,h, i*/
    );

And firstAnd(a, b[0], q);
assign S[0] = q[0];

ToFourBit one(q, 0, w);

//assign g = w;
//assign i = q;

And secondAnd(a, b[1], v);

Verilog addFirstq(w,v,0,S1, carries[0], doNotUse[0]);

assign S[1] = S1[0];

ToFourBit two(S1, carries[0], wsecond);

And thirdAnd(a, b[2], vsecond);

Verilog addFirstb(wsecond,vsecond,0,S2, carries[1], doNotUse[1]);

assign S[2] = S2[0];

ToFourBit three(S2, carries[1], wthird);

And fourthAnd(a, b[3], vthird);

//assign h = vthird;

Verilog addFirsta(wthird,vthird,0,S3, carries[2], doNotUse[2]);

assign S[3] = S3[0];

assign S[4] = S3[1];
assign S[5] = S3[2];
assign S[6] = S3[3];
assign S[7] = carries[2];

endmodule
