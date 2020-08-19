
module random (
					input		logic	CLK,
					input		logic	RESETn,
					input		logic rise,
					output	logic signed [2:0] Xspeed, //Random ball speed
					output	logic signed [2:0] Yspeed

);

logic [7:0] counter;
logic prev_rise;
logic [7:0] random;
parameter [7:0] seed = 0;

always_ff @(posedge CLK or negedge RESETn) begin

	  if(!RESETn) begin
	  
			random <= 8'd7;
			counter <= seed;
			prev_rise <= 1'b0;
		end

		else begin

			counter <= counter+1;
			prev_rise <= rise;

			if (rise && !prev_rise)
				 random <= counter;

		end
end


/*asynchronized logic for outputs:
	random[0:2] define the x_speed with random[7] positive bit
	random[3:5] define the y_speed with random[6] positive bit
*/
always_comb begin
	Xspeed = 1; //default values aren't 0 cause we want the ball to move
	Yspeed = 1;
	
		if (random[7] && random[2:0] != 3'b111) //check that x_speed isn't too low to the right direction
			Xspeed = 1 + random[2:0];

		else if (!random[7] && random[2:0] != 3'b111) //check that x_speed isn't too low to the left direction
			Xspeed = -(1 + random[2:0]);
			
		else if (random[2:0] == 3'b111) //Increases the x_speed of the ball
			Xspeed = 2 + random[2:0];
			
		else if (random[6] && random[5:3] != 3'b111) //check that y_speed isn't too low to the right direction
			Yspeed = 1 + random[5:3];

		else if (!random[6] && random[5:3] != 3'b111) //check that y_speed isn't too low to the left direction
			Yspeed = -(1 + random[5:3]);
			
		else if(random[2:0] == 3'b111) //Increases the y_speed of the ball
			Yspeed = 2 + random[5:3];
			
		else if ( random[2:0] == 3'b001 && random[5:3] == 3'b001 ) begin //if the speed is 1 = too slow 
			Yspeed = Yspeed + 1;
			Xspeed = Xspeed + 1;
		end
		else if (random[2:0] == 3'b100 || random[5:3] == 3'b100) begin //if the speed is too high, decrease it
			Yspeed = -2;
			Xspeed = -2;
		end
end



endmodule
