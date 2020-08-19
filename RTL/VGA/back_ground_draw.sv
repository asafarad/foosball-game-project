//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018

module	back_ground_draw	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input 	logic	[10:0]	oCoord_X,
					input 	logic	[10:0]	oCoord_Y,

					output	logic	[7:0]	mVGA_RGB
					
);
//frame and border constants
const int	x_frame	=	639;
const int	y_frame	=	479;
const int	int_frame =	10;
const int	top_border = 5;
const int	left_border = 4;
const int	bottom_border = y_frame - 4;
const int	right_border = x_frame - 5;

//rods constants
const int	rod_offset = 7;
const int	p1_goalkeeper = 43; //player1
const int	p1_defense = 143;
const int	p1_attack = 363;

const int	p2_goalkeeper = x_frame - 50; //player2
const int	p2_defense = x_frame - 150;
const int	p2_attack = x_frame - 370;

//playground lines constants
const int	middle_line = 318;
const int	middle_offset = 4;
const int	middle_Xcoord = 320;
const int	middle_Ycoord = 239;
const int	radius_in = 25;
const int	radius_out = 27;


logic [2:0] mVGA_R;
logic [2:0] mVGA_G;
logic [1:0] mVGA_B;


assign mVGA_RGB =  {mVGA_R , mVGA_G , mVGA_B} ;

always_comb
begin
				//black borders
				if ( (oCoord_X > 0 && oCoord_X <= x_frame 						&&  oCoord_Y >= 0 &&  oCoord_Y < top_border) ||						 // top border
					  (oCoord_X > 0 && oCoord_X <= left_border 					&&  oCoord_Y >= 0 &&  oCoord_Y < y_frame) ||	  				// left border
					  (oCoord_X > 0 && oCoord_X <= x_frame - 1 					&&  oCoord_Y >= bottom_border &&  oCoord_Y < y_frame) ||  // bottom border
					  (oCoord_X > right_border && oCoord_X <= x_frame - 1 	&&  oCoord_Y >= 0 &&  oCoord_Y < y_frame) )  // right border
						begin 
					mVGA_R <= 3'b000 ;	
					mVGA_G <= 3'b000  ;	
					mVGA_B <= 2'b00 ;	
				end
				//players rods and gates
				else if ( (oCoord_X > p1_goalkeeper && oCoord_X <= p1_goalkeeper + rod_offset					 && oCoord_Y >= 0 &&  oCoord_Y < y_frame) ||  // player1 goalkeeper
							 (oCoord_X > p1_defense && oCoord_X <= p1_defense + rod_offset 						 && oCoord_Y >= 0 &&  oCoord_Y < y_frame) || //player1 defense rod
							 (oCoord_X > p1_attack && oCoord_X <= p1_attack + rod_offset 							 && oCoord_Y >= 0 &&  oCoord_Y < y_frame) || //player1 attack rod 
							 
							 
							 (oCoord_X > p2_goalkeeper && oCoord_X <= p2_goalkeeper + rod_offset 				&& oCoord_Y >= 0 &&  oCoord_Y < y_frame) || // player2 goalkeeper
							 (oCoord_X > p2_defense && oCoord_X <= p2_defense + rod_offset						   && oCoord_Y >= 0 &&  oCoord_Y < y_frame) || //player2 defense rod
							 (oCoord_X > p2_attack && oCoord_X <= p2_attack + rod_offset 							&& oCoord_Y >= 0 &&  oCoord_Y < y_frame)) //player2 attack rod
							begin
						mVGA_R <= 3'b110 ;	
						mVGA_G <= 3'b111  ;	
						mVGA_B <= 2'b11 ;	 
				end
				
				else if ( (oCoord_X > middle_line && oCoord_X <= middle_line + middle_offset &&  oCoord_Y >= 0 &&  oCoord_Y < y_frame) ||	//middle line of the playground
								//circle eqaution to draw circle in the middle:
							 ((((oCoord_X - middle_Xcoord)*(oCoord_X - middle_Xcoord) 	+ 	(oCoord_Y - middle_Ycoord)*(oCoord_Y - middle_Ycoord)) >= radius_in*radius_in) && 
							 ((oCoord_X - middle_Xcoord)*(oCoord_X - middle_Xcoord) 		+ 	(oCoord_Y - middle_Ycoord)*(oCoord_Y - middle_Ycoord)) <= radius_out*radius_out)) begin 
						mVGA_R <= 3'b111 ;	
						mVGA_G <= 3'b111  ;	
						mVGA_B <= 2'b11 ;	 
				end
				else begin // green background
					mVGA_R <= 3'b000 ;	
					mVGA_G <= 3'b011  ;	
					mVGA_B <= 2'b01 ;	
				end	  
		
end 


endmodule

