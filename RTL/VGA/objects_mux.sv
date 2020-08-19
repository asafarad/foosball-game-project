//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
module	objects_mux	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					
					//drawing requests
					input		logic	b_drawing_request, //ball
					input		logic	b2_drawing_request, //ball2
					input		logic	p1_drawing_request, // player1
					input		logic	p2_drawing_request, //player2
					input		logic	db_drawing_request, //doubleball
					input		logic	gate_drawing_request, //gate
					input		logic	gate2_drawing_request, //gate2
					input		logic	goal_drawing_request, //goal
					input		logic	game_over_drawing_request, //game over
					
					//VGA_RGB
					input		logic	[7:0] b_mVGA_RGB, //ball
					input		logic	[7:0] b2_mVGA_RGB, //ball2
					input		logic	[7:0] p1_mVGA_RGB, //player1
					input		logic	[7:0] p2_mVGA_RGB, //player2
					input		logic	[7:0] bckgrnd_mVGA_RGB, //background
					input		logic	[7:0] db_mVGA_RGB, //doubleball
					input		logic	[7:0] gate_mVGA_RGB, //gate1
					input		logic	[7:0] gate2_mVGA_RGB, //gate2
					input		logic	[7:0] goal_mVGA_RGB, //goal
					input		logic	[7:0] game_over_mVGA_RGB, //game over
					
					//outputs
					output	logic	[7:0] m_mVGA_R, 
					output	logic	[7:0] m_mVGA_G, 
					output	logic	[7:0] m_mVGA_B 
					
);

logic [7:0] m_mVGA_t;



assign m_mVGA_R	= {m_mVGA_t[7:5], 5'b0}; //-- expand to 10 bits 
assign m_mVGA_G	= {m_mVGA_t[4:2], 5'b0};
assign m_mVGA_B	= {m_mVGA_t[1:0], 6'b0};


always_ff@(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
			m_mVGA_t	<= 8'b0;
	end
	else
	begin
		if (goal_drawing_request == 1'b1 ) //goal icon
			m_mVGA_t <= goal_mVGA_RGB;
		else if (game_over_drawing_request == 1'b1 ) //gave over icon
			m_mVGA_t <= game_over_mVGA_RGB;
		else if (p1_drawing_request == 1'b1 )   
			m_mVGA_t <= p1_mVGA_RGB;  //first priority for player1
		else if (p2_drawing_request == 1'b1 )   
			m_mVGA_t <= p2_mVGA_RGB;  //first priority for player2
		else if (b_drawing_request == 1'b1 )   
			m_mVGA_t <= b_mVGA_RGB;  //second priority for ball
		else if (b2_drawing_request == 1'b1 )   
			m_mVGA_t <= b2_mVGA_RGB;  //third priority for ball2 in double ball	
		else if (db_drawing_request == 1'b1 )
			m_mVGA_t <= db_mVGA_RGB;
		else if (gate_drawing_request == 1'b1 ) //fourth priority for the gate
			m_mVGA_t <= gate_mVGA_RGB;	
		else if (gate2_drawing_request == 1'b1 ) //fourth priority for the gate
			m_mVGA_t <= gate2_mVGA_RGB;	
		else
			m_mVGA_t <= bckgrnd_mVGA_RGB ; // last priority from background
		end ; 
	end

endmodule


