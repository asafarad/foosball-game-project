

module game_controller (
					input		logic	CLK,
					input		logic	RESETn,
					input		logic space, //The key that makes the beginning of the states 
					input		logic goal,  //A signal that warns of a goal
					input		logic game_over,  //A signal on the end of the game
					input		logic double_ball,  //A signal on double ball state
					input		logic Max_goal, //define that after 9 goals the game is over
					//outputs for enable
					output			idle,
					output			goal_ena, 
					output			game_over_ena,
					output			double_ball_ena,
					output	logic [3:0] init_count, //counter initial
					output			move //enable ball movement

);

enum logic [2:0] {IDLE, GAME, GOAL, DOUBLE_BALL, GAME_OVER,DOUBLE_BALL_IDLE, DOUBLE_BALL_GAME} cur_state, nxt_state;
		
const int	x_frame	=	639;
const int	y_frame	=	479;
		
		
//fsm synchronized process
always_ff@(posedge CLK or negedge RESETn)
begin
		if(!RESETn) begin
			cur_state <= IDLE ;
		end
		
		else begin
			cur_state <= nxt_state;
		end
end

//fsm asynchronized logic
always_comb
begin
	//default values
	nxt_state = cur_state;
	goal_ena = 0;
	move = 0;
	game_over_ena = 0;
	double_ball_ena = 0;
	init_count = 0;
	idle = 0;
	
	case (cur_state)
	
		IDLE: begin //begin game with no move
			idle = 1; //signal to initial the goals counter
			if (space)
				nxt_state = GAME;
		end
		//-----------------------
		GAME: begin //start game with ball move
			move = 1;
			if (goal)
				nxt_state = GOAL;			
			else if (game_over)
				nxt_state = GAME_OVER;
			else if (double_ball)
				nxt_state = DOUBLE_BALL_IDLE;
		end
		//-----------------------
		GOAL: begin //goal state with no move
			goal_ena = 1;
			if (space)	
				nxt_state = GAME;
			else if (Max_goal) //if the goal counter is max=9
				nxt_state = GAME_OVER;
		end
		//-----------------------
		GAME_OVER: begin //finish game- initial the counters and back to idle
			game_over_ena = 1;
			init_count = 9;
			if (space)	
				nxt_state = IDLE;			
		end
		//-----------------------
		DOUBLE_BALL_IDLE: begin //special state for initial double ball with no move
			double_ball_ena = 1;	
			if (space)
				nxt_state = DOUBLE_BALL_GAME;
		end
		//-----------------------
		DOUBLE_BALL_GAME: begin //start game with double ball move
			move = 1;
			double_ball_ena = 1;
			if (goal)	
				nxt_state = GOAL; //exits the double ball state and back to the game
			else if (game_over)
				nxt_state = GAME_OVER;
		end
		
	endcase
end			
			

endmodule
	
					
					