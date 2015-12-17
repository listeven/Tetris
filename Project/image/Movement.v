
module Movement(up, down, left, right,clk,x,y,change);
	//..................
	// Define your parameters, inputs, regs, etc
	//..................

	/////////////////////////////////////////
	// State machine parameters	
	parameter S_IDLE = 0;	// 0000 - no button pushed
	parameter S_UP = 1;		// 0001 - the first button pushed	
	parameter S_DOWN = 2;	// 0010 - the second button pushed
	parameter S_LEFT = 4; 	// 0100 - and so on	
	parameter S_RIGHT = 8;	// 1000 - and so on

	reg [3:0] state, next_state;
	////////////////////////////////////////	
	
	
	input up, down, left, right,clk; 	// 1 bit inputs	
	output reg [10:0] x, y;				//currentposition variables
	output reg [2:0] change;
	reg slow_clk;					// clock for position update,	
									// if it's too fast, every push
									// of a button willmake your object fly away.

	initial begin					// initial position of the box	
		x = 0; y=0;
	end	

	////////////////////////////////////////////	
	// slow clock for position update - optional
	reg [25:0] slow_count;	
	always @ (posedge clk)begin
		slow_count = slow_count + 1'b1;	
		slow_clk = slow_count[23];
	end	
	/////////////////////////////////////////

	///////////////////////////////////////////
	// State Machine	
	always @ (posedge slow_clk)begin
		state = next_state;	
	end

	always @ (posedge slow_clk) begin	
		case (state)
			S_IDLE: next_state = {right,left,down,up}; // if input is 0000
			S_UP: begin	// if input is 0001
				y = y - 5;	
				next_state = {right,left,down,up};
				change = 1;
			end	
			S_DOWN: begin // if input is 0010
				// .................	
				y = y + 5;
				next_state = {right,left,down,up};
				change = 0;
			end
			S_LEFT: begin //if input is 0100
				x = x - 5;
				next_state = {right,left,down,up};
				change = 2;
			end
			S_RIGHT: begin //if input is 1000
				x = x + 5;
				next_state = {right,left,down,up};
				change = 3;
			end
			//complete state machine
		endcase
	end
	// ..............................	
	//callthe VGA driver
	// .........................................	
	//Complete the figure description
endmodule

