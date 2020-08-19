// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By David Bar-On  June 2018 


module kbd_cmd_decoder 	
 ( 
   input	   logic  clk,
	input	   logic  resetN, 
   input  logic [8:0]	key_Pressed,	
   input  logic 	make,	
   input  logic 	brakee,  // warning break is a reserved word 
	
   output  logic 	space,	 // presing space valid while key is presed (from make to brake)  
	output  logic  up_direction,     //player 1 keys
	output  logic  down_direction,
	output  logic  right_direction,     
	output  logic  up2_direction,    //player 2 keys
	output  logic  down2_direction,
	output  logic  right2_direction     
  	 
  ) ;


   localparam KEY_SPACE = 9'h029 ; 
   localparam KEY_UP1 = 9'he175 ; 
   localparam KEY_DOWN1 = 9'he172 ; 
   localparam KEY_RIGHT1 = 9'h174 ; 
   localparam KEY_UP2 = 9'h01d ; 
   localparam KEY_DOWN2 = 9'h01b ; 
   localparam KEY_RIGHT2 = 9'h01c ; 
 
  
	always_ff @(posedge clk or negedge resetN)
	begin: fsm_sync_proc
		if (resetN == 1'b0) begin 
			space	 <= 0 ; 
			up_direction <= 0 ;
			down_direction <= 0 ;
			right_direction <= 0 ;
			up2_direction <= 0 ;
			down2_direction <= 0 ;
			right2_direction <= 0 ;
 
		end 
		else begin 
		

// keys logic 

		 if (key_Pressed  == KEY_SPACE ) begin  if (make == 1'b1) space <= 1'b1 ; if (brakee == 1'b1) space <= 1'b0 ; end ; 
		 
		 if (key_Pressed  == KEY_UP1 ) begin  if (make == 1'b1) up_direction <= 1'b1 ; if (brakee == 1'b1) up_direction <= 1'b0 ; end ; 
		 if (key_Pressed  == KEY_DOWN1 ) begin  if (make == 1'b1) down_direction <= 1'b1 ; if (brakee == 1'b1) down_direction <= 1'b0 ; end ; 
		 if (key_Pressed  == KEY_RIGHT1 ) begin  if (make == 1'b1) right_direction <= 1'b1 ; if (brakee == 1'b1) right_direction <= 1'b0 ; end ; 
		 
		 if (key_Pressed  == KEY_UP2 ) begin  if (make == 1'b1) up2_direction <= 1'b1 ; if (brakee == 1'b1) up2_direction <= 1'b0 ; end ; 
		 if (key_Pressed  == KEY_DOWN2 ) begin  if (make == 1'b1) down2_direction <= 1'b1 ; if (brakee == 1'b1) down2_direction <= 1'b0 ; end ;
		 if (key_Pressed  == KEY_RIGHT2 ) begin  if (make == 1'b1) right2_direction <= 1'b1 ; if (brakee == 1'b1) right2_direction <= 1'b0 ; end ; 
		 

		end // if 
	end // always_ff 
	

endmodule


