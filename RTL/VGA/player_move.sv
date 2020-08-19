//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018


module	player_move	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input		logic	timer_done,
					input		logic	up_direction,
					input		logic	down_direction,
					output	logic	[10:0]	ObjectStartX,
					output	logic	[10:0]	ObjectStartY
					
);

//
parameter logic [10:0] StartX = 11'd20;
parameter logic [10:0] StartY = 11'd220;
int directionX;
int directionY;
int t;

//restriction constants on player movements
const int	top_border = 130;
const int	bottom_border = 329;




always_ff@(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		ObjectStartX	<= StartX;
		ObjectStartY	<= StartY;
		t = StartY;
	end
	else 
	begin
			
			if (timer_done == 1'b1) begin
							if (up_direction && ObjectStartY > top_border) //if pressing up key
								ObjectStartY <= ObjectStartY - 2;
							else if (down_direction && ObjectStartY <= bottom_border) //if pressing down key
								ObjectStartY <= ObjectStartY + 2;
			end
			
	end
end


endmodule

