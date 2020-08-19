//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018


module	smileyface_move	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input		logic	timer_done,
					input		logic	X_direction,
					input		logic	y_direction,
					output	logic	[10:0]	ObjectStartX,
					output	logic	[10:0]	ObjectStartY
					
);

//
const int StartX = 580;
const int StartY = 385;
int directionX;
int directionY;
int t;

//

//
//
assign directionX = (X_direction ) ? -1 : 1;
assign directionY = (y_direction ) ? -1 : 1;

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
							
							if (ObjectStartX <= 100 || ObjectStartX >= 600 || ObjectStartY <= 0 || ObjectStartY >= 600)  begin
								ObjectStartX <= StartX;
								ObjectStartY <= StartY;
								t	<= StartY;
								end
							else begin
									ObjectStartX  <= t*t /256; // Dudy Bar-On
									//ObjectStartX  <= ObjectStartY*ObjectStartY /256;
							  // Parabola 
									ObjectStartY	<= ObjectStartY - directionY; // move to the left 
									t					<= t - directionX; // Dudy Bar-On
								end
			end
			
	end
end

//
endmodule
//
