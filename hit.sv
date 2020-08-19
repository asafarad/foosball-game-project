


module hit (
					input		logic	CLK,
					input		logic	RESETn,
					input		logic	b_drawing_request,    //ball req
					input		logic	p1_drawing_request,   //player 1 req
					input		logic	p2_drawing_request,   //player 2 req
					input		logic	db_drawing_request,   //double ball req
					input		logic	gate_drawing_request, //gate 1 req
					input		logic	gate2_drawing_request,//gate 2 req
					input    logic [10:0] bCoord_X,  //Position Ball No.1
					input    logic [10:0] bCoord_Y,
				   input    logic [10:0] bCoord2_X, //Position Ball No.2
					input    logic [10:0] bCoord2_Y,
					input    logic lie_pos,  //player1 in lying position
					input    logic lie2_pos, //player2 in lying position
					output   collision,  //A signal that warns of a collision of the ball with the player
					output   doubleball, //A signal that warns of a collision of the ball with the doubleball
					output 	goal_left,  //A signal that warns of a goal to player2 
					output 	goal_right, //A signal that warns of a goal to player1
					output	X_direction,//Parameter that define the position of the ball at each type of collision 
					output	Y_direction //Parameter that define the position of the ball at each type of collision
);

localparam  int player_X_size = 60;//The X_size of the player lying down 
localparam  int player_Y_size = 20;//The Y_size of the player lying down


//synch
always_ff@(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
			X_direction <= 0;
			Y_direction <= 0;
			collision <= 0;
			doubleball <= 0;
			goal_left <= 0;
			goal_right <= 0;
	end 
	else begin

			if ( b_drawing_request && p1_drawing_request && collision < 1 && !lie_pos) begin //collision with player1
				collision <= 1;
				if ( bCoord_Y <= ( player_Y_size / 3 )  ) begin //collision in the upper third of player1 
					Y_direction <= 1;//define first position of the ball
					X_direction <= 0;
				end
				else if (bCoord_Y >= ( player_Y_size * (2/3) ) ) begin //collision in the lower third of player1
					Y_direction <= 1;//define second position of the ball
					X_direction <= 1;
				end
				else begin //collision in the middle of player1
					Y_direction <= 0;//define third position of the ball
					X_direction <= 0;
				end
			end
			
			else if ( b_drawing_request && p2_drawing_request  && collision < 1 && !lie2_pos) begin //collision with player2
						collision <= 1;
				if ( bCoord2_Y <= ( player_Y_size / 3 )  ) begin //collision in the upper third of player2
					Y_direction <= 1;//define first position of the ball
					X_direction <= 0;
				end
				else if (bCoord2_Y >= ( player_Y_size * (2/3) ) ) begin //collision in the lower third of player2
					Y_direction <= 1;//define second position of the ball
					X_direction <= 1;
				end
				else begin //collision in the middle of player2
					Y_direction <= 0;//define third position of the ball
					X_direction <= 0;
				end
			end
			
			else if ( b_drawing_request && db_drawing_request) //Collision of the ball in doubleball's rectangle
					doubleball <= 1;
			else if ( b_drawing_request && gate_drawing_request) //Collision of the ball with player1 gate
					goal_left <= 1;
			else if ( b_drawing_request && gate2_drawing_request) //Collision of the ball with player2 gate
					goal_right <= 1;
			else begin
				collision <= 0;
				doubleball <= 0;
				goal_left <= 0;
				goal_right <= 0;
			end

	end
end

endmodule
	
		