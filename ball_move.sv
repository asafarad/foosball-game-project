//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018


module	ball_move	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input		logic	timer_done,
					input		logic	collision,
					input		logic	doubleball,
					input		logic	goal,
					input		logic move,
					input    logic X_direction,
					input    logic Y_direction,
					input		logic signed [2:0] Xspeed,
					input		logic signed [2:0] Yspeed,					
					output	logic	[10:0]	ObjectStartX,
					output	logic	[10:0]	ObjectStartY
					
);

//
const int StartX = 306; //middle of playground
const int StartY = 226;
const int	x_frame	=	639;
const int	y_frame	=	479;
int directionX ;
int directionY ;
int coll_flag = 0; //collision flag
int db_flag= 0; //double ball flag
int goal_flag = 0;

logic prev_move;


always_ff@(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		ObjectStartX	<= StartX;
		ObjectStartY	<= StartY;
	   directionX <= Xspeed;
      directionY <= Yspeed;
		prev_move = 1'b0 ; 
end
	else 
	begin
	
				prev_move <= move;  // rise detect of a new game 

			if (move && !prev_move)
				begin 
					ObjectStartX	<= StartX;
					ObjectStartY	<= StartY;
					directionX <= Xspeed;
					directionY <= Yspeed;
				end

			
			if (collision && !coll_flag) begin //collision with player
				directionX <= -directionX;
				coll_flag <= 1;				
				if ( Y_direction  && !X_direction) begin //collision with first 1/3 of player
					ObjectStartY <= ObjectStartY - 3;
					directionY <= -directionY;
				end
				if ( Y_direction  && X_direction) begin //collision with second 1/3 of player
					ObjectStartY <= ObjectStartY + 3;
					directionY <= -directionY;
				end
				if ( !Y_direction  && !X_direction) begin //collision with third 1/3 of player
					ObjectStartY <= ObjectStartY;
					directionY <= directionY;
				end
			end //end collision with player
			
			else if (doubleball && !db_flag) begin //double ball state
					db_flag <= 1;
					ObjectStartX	<= StartX;
					ObjectStartY	<= StartY;
			end //end double ball
			
			else if (goal && !goal_flag) begin //initial the ball back to middle after goal
					goal_flag <= 1;
					ObjectStartX	<= StartX;
					ObjectStartY	<= StartY;
					directionX <= 0;
					directionY <= 0;
			end
			
			else if (timer_done == 1'b1) begin
							
						if (!move) begin
							ObjectStartX	<= StartX;
							ObjectStartY	<= StartY;
						end
						else begin
							
							if (ObjectStartX <= 0 || ObjectStartX >= x_frame || ObjectStartY <= 0 || ObjectStartY >= y_frame)  begin //if ball out of the screen
								ObjectStartX <= StartX;
								ObjectStartY <= StartY;
							end
			

							else if (coll_flag)
								coll_flag <= 0;
							else if (db_flag)
								db_flag <= 0;
							else if (goal_flag)
								goal_flag <= 0;
							else if (ObjectStartY <= 5) begin  //collision with top border
								ObjectStartY <= ObjectStartY + 3;
								ObjectStartX <= ObjectStartX;
								directionY <= -directionY;
							end
							else if (ObjectStartY >= y_frame - 30) begin //collision with bottom border
								ObjectStartY <= ObjectStartY - 3;
								ObjectStartX <= ObjectStartX;
								directionY <= -directionY;
							end	
							else if (ObjectStartX <= 4) begin  //collision with left border
								ObjectStartX <= ObjectStartX + 3;
								ObjectStartY <= ObjectStartY;
								directionX <= -directionX;
							end
							else if (ObjectStartX >= x_frame - 31) begin //collisiton with right border
								ObjectStartX <= ObjectStartX - 3;
								ObjectStartY <= ObjectStartY;
								directionX <= -directionX;
							end
							else begin
								ObjectStartX  <= ObjectStartX + directionX; //default directions
								ObjectStartY	<= ObjectStartY + directionY; 
							end
						end
								
							
			end //end timer done
			
	end //end else of reset
end //end always

//
endmodule
//
