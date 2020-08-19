

module goals_counter 
	(
   // Input, Output Ports
   input logic clk, resetN,
	input logic timer_done,
	input logic goal,
	input logic idle,
	output logic Max_goal,
   output logic [Nbits-1:0] count = 0
   );
	
	// Internal or local parameters declarations
	localparam logic [Nbits-1:0] MaxCount = 9; // Maximum counter value
	
	parameter num_player = 0;
	parameter Nbits = 4;
	int left_flag = 0; //goal in left gate
	int right_flag = 0; //goal in right gate
	
	localparam int middleOfPlayground = 320;
	
   always_ff @( posedge clk or negedge resetN )
   begin
      
      if ( !resetN ) begin// Asynchronic reset
			
			count <= 0;
			Max_goal <= 0;
		end
		
      else 				// Synchronic logic			
			if (num_player == 0) begin //player1 goals counter
				if (count >= MaxCount) begin
					count <= 0;
					Max_goal <= 1;
				end
				else if (goal && !right_flag) begin
					count <= count + 1;
					right_flag <= 1;
				end
				else if (timer_done && right_flag)
					right_flag <= 0;
				else if (idle) //initial the counter in game over state
					count <= 0;
				else
					Max_goal <= 0;
			end
			
			else begin //player2 goals counter
				if (count >= MaxCount) begin
					count <= 0;
					Max_goal <= 1;
				end
				else if (goal && !left_flag) begin
					count <= count + 1;
					left_flag <= 1;
				end
				else if (timer_done && left_flag)
					left_flag <= 0;
				else if (idle) //initial the counter in game over state
					count <= 0;
				else
					Max_goal <= 0;
			end
			
			
    end // always
endmodule
