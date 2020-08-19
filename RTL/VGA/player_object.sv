//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018



module	player_object	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input 	logic	[10:0]	oCoord_X,
					input 	logic	[10:0]	oCoord_Y,
					input 	logic	[10:0]	ObjectStartX,
					input 	logic	[10:0]	ObjectStartY,
					input		logic				right_direction,
					output	logic				drawing_request,
					output	logic	[7:0]		mVGA_RGB,
					output   logic [10:0] bCoord_X,
					output   logic [10:0] bCoord_Y
					
);

localparam  int object_X_size = 60;
localparam  int object_Y_size = 20;


bit [0:object_Y_size-1] [0:object_X_size-1] [7:0] player1_colors = { //left player color- blue
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24,8'h29,8'h29,8'h29,8'h29,8'h6d,8'h20,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h20,8'h49,8'h04,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24,8'h77,8'h57,8'h57,8'h57,8'h57,8'h77,8'h97,8'h92,8'h4d,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h49,8'h49,8'h49,8'h29,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24},
{8'h00,8'h00,8'h00,8'h00,8'h24,8'h48,8'h49,8'h69,8'h49,8'h8d,8'hf6,8'hfa,8'hd6,8'h00,8'h00,8'h00,8'h00,8'h00,8'h52,8'h53,8'h52,8'h52,8'h52,8'h52,8'h52,8'h53,8'h57,8'h77,8'h52,8'h52,8'h4e,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h6d,8'h6d,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h6d,8'h92,8'h49,8'h49,8'h49,8'h49,8'h49,8'h6d,8'h49,8'h25,8'h24,8'h00,8'h24},
{8'h00,8'h00,8'h00,8'h24,8'h8d,8'h69,8'hb1,8'hb1,8'hb1,8'hb1,8'hb1,8'hf5,8'hf6,8'hd1,8'hb1,8'h69,8'h00,8'h4d,8'h77,8'h52,8'h52,8'h52,8'h52,8'h52,8'h53,8'h52,8'h52,8'h52,8'h53,8'h53,8'h57,8'h96,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hfa,8'hfa,8'hd6,8'hb2,8'hb6,8'h92,8'h6d,8'h6d,8'hb6,8'hb6,8'h6d,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h6d,8'h00,8'h00},
{8'h00,8'h00,8'h00,8'h69,8'h48,8'h69,8'hf5,8'hf6,8'hf6,8'hf6,8'hf6,8'hf6,8'hf5,8'hf6,8'hfa,8'hfa,8'hb1,8'h92,8'h32,8'h53,8'h52,8'h52,8'h52,8'h52,8'h52,8'h52,8'h52,8'h52,8'h52,8'h52,8'h52,8'h92,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hf6,8'hf5,8'hf6,8'hf6,8'hfb,8'h97,8'hff,8'hff,8'hff,8'hdb,8'h6e,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h29,8'h49,8'h00,8'h24},
{8'h00,8'h00,8'h6d,8'h69,8'h68,8'h48,8'had,8'hf6,8'hf5,8'hf6,8'hf6,8'hf6,8'hf6,8'hf6,8'hf6,8'hf5,8'hf6,8'hf5,8'hb1,8'h52,8'h53,8'h52,8'h52,8'h52,8'h52,8'h52,8'h53,8'h53,8'h53,8'h53,8'h53,8'h96,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hdb,8'hf6,8'hf5,8'hf6,8'hf5,8'hda,8'h77,8'hdb,8'hdb,8'hdb,8'hdb,8'h6d,8'h29,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h25,8'h49,8'h24,8'h00},
{8'h00,8'h00,8'h48,8'h68,8'h68,8'h44,8'h8d,8'hfa,8'hf6,8'hf5,8'hf5,8'hf6,8'hf6,8'hf5,8'hf5,8'hd1,8'hd1,8'hd1,8'hd1,8'h4d,8'h52,8'h53,8'h52,8'h52,8'h52,8'h53,8'h52,8'h52,8'h52,8'h4e,8'h4e,8'h72,8'hb6,8'h96,8'h96,8'h96,8'h96,8'h96,8'hd1,8'hf1,8'hd1,8'hf1,8'hb6,8'h72,8'hb7,8'hbb,8'hbb,8'hb7,8'h6d,8'h25,8'h25,8'h25,8'h25,8'h25,8'h25,8'h25,8'h24,8'h49,8'h24,8'h00},
{8'h00,8'h00,8'h69,8'h44,8'h44,8'h44,8'had,8'hf6,8'hf5,8'hd1,8'hd1,8'hf6,8'hf5,8'hd1,8'hd1,8'hd1,8'hd1,8'had,8'h4d,8'h52,8'h53,8'h52,8'h52,8'h52,8'h53,8'h53,8'h4e,8'h4d,8'h4d,8'h4d,8'h4d,8'h72,8'h96,8'h96,8'h96,8'h96,8'h96,8'h96,8'hd1,8'hd1,8'hd1,8'hcd,8'hb6,8'h52,8'h96,8'h96,8'h96,8'h96,8'h6d,8'h24,8'h25,8'h25,8'h24,8'h24,8'h24,8'h25,8'h24,8'h49,8'h00,8'h00},
{8'h00,8'h00,8'h49,8'h8d,8'h20,8'h69,8'hd1,8'hd1,8'hcd,8'hcd,8'hcd,8'hd1,8'hd1,8'hd1,8'hd1,8'hd2,8'h49,8'h4d,8'h52,8'h53,8'h52,8'h53,8'h53,8'h53,8'h52,8'h4e,8'h4d,8'h4d,8'h4d,8'h4d,8'h2d,8'h4d,8'h96,8'h96,8'h96,8'h96,8'h96,8'h96,8'hd2,8'hf1,8'hd2,8'hf6,8'h92,8'h6e,8'h92,8'h96,8'h92,8'h72,8'h49,8'h24,8'h24,8'h24,8'h24,8'h24,8'h24,8'h24,8'h24,8'h49,8'h00,8'h00},
{8'h00,8'h00,8'h00,8'h49,8'h8d,8'h45,8'h65,8'h69,8'h69,8'h65,8'h89,8'hd1,8'hd1,8'h6d,8'h00,8'h00,8'h00,8'h00,8'h52,8'h53,8'h53,8'h52,8'h52,8'h4e,8'h4d,8'h4d,8'h4d,8'h2d,8'h4d,8'h4d,8'h4d,8'h72,8'h96,8'h96,8'h96,8'h96,8'h96,8'h96,8'hb6,8'h6d,8'h49,8'h24,8'h00,8'h00,8'h00,8'h00,8'h92,8'h6d,8'h49,8'h24,8'h24,8'h25,8'h25,8'h25,8'h49,8'h49,8'h49,8'h49,8'h00,8'h24},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h24,8'h20,8'h24,8'h24,8'hb2,8'had,8'h44,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h72,8'h57,8'h2e,8'h4d,8'h2d,8'h2d,8'h4d,8'h4d,8'h4d,8'h6d,8'h6d,8'h49,8'h24,8'h24,8'h24,8'h24,8'h24,8'h24,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h6d,8'h6d,8'h24,8'h49,8'h24,8'h49,8'h49,8'h24,8'h00,8'h00,8'h00,8'h00,8'h24},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24,8'h96,8'h72,8'h4d,8'h4e,8'h52,8'h49,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24,8'h24,8'h24,8'h24,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24}
};

bit [0:object_Y_size-1] [0:object_X_size-1] [7:0] player2_colors = { //right player color- red
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h69,8'h6d,8'h8d,8'h6d,8'h24,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h49,8'h49,8'h6d,8'h8e,8'h69,8'h69,8'h69,8'h89,8'h8d,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24,8'h00,8'h00,8'h24,8'h24,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24,8'h24,8'h04,8'h00,8'h00,8'h00,8'h24,8'h24,8'h6d,8'hb2,8'h8e,8'h69,8'h69,8'h69,8'h69,8'h69,8'ha9,8'hed,8'h69,8'h00,8'h00,8'h00,8'h00,8'h00,8'h6d,8'hb2,8'hd2,8'h92,8'h49,8'h49,8'h24,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
{8'h00,8'h00,8'h24,8'h49,8'h49,8'h49,8'h45,8'h25,8'h25,8'h25,8'h25,8'h49,8'h24,8'h24,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h6d,8'hb2,8'hb6,8'hd6,8'hb6,8'hb6,8'hb6,8'h92,8'h8d,8'h6d,8'h69,8'h69,8'h69,8'h69,8'h69,8'h69,8'h89,8'hcd,8'hed,8'hed,8'had,8'h00,8'h00,8'h00,8'h00,8'hb2,8'hd2,8'had,8'h64,8'h45,8'h49,8'h49,8'h45,8'h69,8'h24,8'h00,8'h00,8'h00,8'h00},
{8'h00,8'h24,8'h49,8'h24,8'h24,8'h24,8'h24,8'h24,8'h24,8'h24,8'h24,8'h69,8'h6d,8'h92,8'h6d,8'h20,8'h24,8'h24,8'h44,8'h69,8'h8d,8'hb2,8'hb2,8'hb2,8'hb2,8'hb2,8'hb2,8'hb2,8'h6d,8'h69,8'h69,8'h69,8'h69,8'h69,8'h89,8'hcd,8'hcd,8'hcd,8'hed,8'hcd,8'hcd,8'hed,8'h24,8'h00,8'h6d,8'hb1,8'hd2,8'had,8'had,8'h89,8'h89,8'h89,8'h89,8'h89,8'h44,8'h44,8'h00,8'h00,8'h00,8'h00},
{8'h00,8'h24,8'h49,8'h24,8'h24,8'h24,8'h24,8'h24,8'h24,8'h24,8'h24,8'h6d,8'hb2,8'hb2,8'hd6,8'hb2,8'h8e,8'hd2,8'had,8'had,8'had,8'had,8'hb2,8'hb2,8'hb2,8'hb2,8'hb2,8'hb2,8'h8d,8'h69,8'h69,8'h69,8'h69,8'h69,8'hcd,8'hed,8'hed,8'hed,8'hcd,8'hcd,8'hed,8'ha9,8'h92,8'hb2,8'hd1,8'had,8'had,8'hd1,8'hd1,8'had,8'had,8'had,8'hcd,8'had,8'h44,8'h44,8'h44,8'h00,8'h00,8'h00},
{8'h00,8'h24,8'h49,8'h24,8'h25,8'h24,8'h24,8'h24,8'h25,8'h24,8'h25,8'h6d,8'hd6,8'hb6,8'hb6,8'hb2,8'h8d,8'hb1,8'had,8'had,8'had,8'hb1,8'hb6,8'hb6,8'hb6,8'hb6,8'hb6,8'hb6,8'h8d,8'h69,8'h69,8'h69,8'h69,8'ha9,8'hed,8'hcd,8'hcd,8'hcd,8'hcd,8'hed,8'ha9,8'h8d,8'had,8'had,8'had,8'had,8'hcd,8'hf1,8'hd1,8'had,8'had,8'hd1,8'hf1,8'h68,8'h44,8'h44,8'h69,8'h44,8'h00,8'h00},
{8'h00,8'h24,8'h49,8'h24,8'h25,8'h25,8'h25,8'h25,8'h25,8'h25,8'h25,8'h6d,8'hd6,8'hd6,8'hd6,8'hd2,8'hae,8'hd2,8'had,8'had,8'hcd,8'hb1,8'hb6,8'hb2,8'hb2,8'hb2,8'hb2,8'hb2,8'h8d,8'h69,8'h89,8'h89,8'ha9,8'hcd,8'hed,8'hcd,8'hcd,8'hcd,8'hed,8'hcd,8'h89,8'had,8'had,8'had,8'had,8'hd1,8'hd1,8'hf1,8'hd1,8'hd1,8'hd1,8'hf1,8'hf1,8'h68,8'h44,8'h68,8'h68,8'h44,8'h00,8'h00},
{8'h00,8'h24,8'h49,8'h25,8'h49,8'h49,8'h29,8'h29,8'h29,8'h29,8'h29,8'h6d,8'hfb,8'hfb,8'hfb,8'hf6,8'hd2,8'hd6,8'hd0,8'hd1,8'hd1,8'hd1,8'hda,8'hd6,8'hd6,8'hd6,8'hfa,8'hd6,8'had,8'hc9,8'hcd,8'hcd,8'hed,8'hed,8'hcd,8'hcd,8'hcd,8'hcd,8'hed,8'ha9,8'h8d,8'hd1,8'hd1,8'hd1,8'hd1,8'hf1,8'hf1,8'hf1,8'hf1,8'hf1,8'hf1,8'hf1,8'hf1,8'h68,8'h68,8'h68,8'h69,8'h49,8'h00,8'h00},
{8'h00,8'h24,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h92,8'hfb,8'hfb,8'hfb,8'hf6,8'hf2,8'hf6,8'hf0,8'hf1,8'hf0,8'hf5,8'hfb,8'hfb,8'hfb,8'hfb,8'hfb,8'hfb,8'hd1,8'hed,8'hed,8'hed,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hed,8'ha9,8'had,8'hf1,8'hf1,8'hd1,8'hf1,8'hf1,8'hf1,8'hf1,8'hd1,8'hd1,8'hd1,8'hf1,8'h68,8'h48,8'h48,8'h8d,8'h24,8'h00,8'h00},
{8'h00,8'h24,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h92,8'hfb,8'hfb,8'hff,8'hfa,8'hf2,8'hf6,8'hf0,8'hd1,8'hd0,8'hf5,8'hfb,8'hfb,8'hfb,8'hfb,8'hfb,8'hfb,8'hd1,8'hed,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hed,8'hcd,8'ha9,8'had,8'hd1,8'hf1,8'hd0,8'hd1,8'hf1,8'hf1,8'hf1,8'hf1,8'hf1,8'hf1,8'hd1,8'h68,8'h69,8'h6d,8'h00,8'h00,8'h00},
{8'h00,8'h24,8'h49,8'h25,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h92,8'hd6,8'hdb,8'hb2,8'h8d,8'h8d,8'h8d,8'hd1,8'hf5,8'hf1,8'hf5,8'hfb,8'hfb,8'hfb,8'hfb,8'hfb,8'hda,8'had,8'hc9,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hed,8'h24,8'h00,8'hb1,8'hf5,8'hf1,8'hd1,8'hd1,8'hd1,8'hcd,8'hcd,8'hcd,8'had,8'h68,8'h6d,8'h00,8'h00,8'h00,8'h00},
{8'h00,8'h00,8'h6d,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h6e,8'h92,8'h49,8'h00,8'h00,8'h00,8'h00,8'h04,8'h6d,8'h8d,8'hd6,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hd6,8'hed,8'hed,8'hed,8'hc9,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hcd,8'hed,8'hd1,8'h00,8'h00,8'h00,8'h49,8'hb2,8'hf1,8'hcc,8'h88,8'h69,8'h69,8'h69,8'h69,8'h69,8'h20,8'h00,8'h00,8'h00,8'h00},
{8'h00,8'h00,8'h00,8'h24,8'h24,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h92,8'h6d,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h49,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h8d,8'hcd,8'hf1,8'hed,8'he9,8'hcd,8'hcd,8'hcd,8'hcd,8'hc9,8'hed,8'h6d,8'h00,8'h00,8'h00,8'h00,8'h00,8'hb1,8'hfa,8'hf5,8'hb2,8'h49,8'h49,8'h49,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24,8'h49,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24,8'h69,8'hd6,8'hed,8'hc9,8'hc9,8'hc9,8'hed,8'hd2,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h49,8'h49,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24,8'h8d,8'hf2,8'hf2,8'hd2,8'had,8'h24,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h24,8'h24,8'h04,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00}
};

//-- one bit mask  0 - off, 1 dispaly 

bit [0:object_Y_size-1] [0:object_X_size-1] player1_mask = { //left player mask
{60'b000000000000000000000000000000000000000000000000000000000000},
{60'b000000000000000000000000000000000000000000000000000000000000},
{60'b000000000000000000000000000000000000000000000000000000000000},
{60'b000000000000000000001111100000000000000000000000000000000000},
{60'b000000000000000000011111111100000000000000000000111110000000},
{60'b000011111111100000111111111111100000000000000001111111111100},
{60'b000111111111111111111111111111111111111111111111111111111100},
{60'b001111111111111111111111111111111111111111111111111111111100},
{60'b001111111111111111111111111111111111111111111111111111111100},
{60'b001111111111111111111111111111111111111111111111111111111100},
{60'b001111111111111111111111111111111111111111111111111111111100},
{60'b000111111111111111111111111111111111111111111111111111111100},
{60'b000111111111100000111111111111111111111100000011111111111100},
{60'b000000000000000000111111111111000000000000000001111111000000},
{60'b000000000000000000111111100000000000000000000000000000000000},
{60'b000000000000000000011110000000000000000000000000000000000000},
{60'b000000000000000000000000000000000000000000000000000000000000},
{60'b000000000000000000000000000000000000000000000000000000000000},
{60'b000000000000000000000000000000000000000000000000000000000000},
{60'b000000000000000000000000000000000000000000000000000000000000}
};            


bit [0:object_Y_size-1] [0:object_X_size-1] player2_mask = { //right player mask
{60'b000000000000000000000000000000000000000000000000000000000000},
{60'b000000000000000000000000000000000000000000000000000000000000},
{60'b000000000000000000000000000000000000000000000000000000000000},
{60'b000000000000000000000000000000011111111111000000000000000000},
{60'b000001111111000000000000000011111111111111000000000000000000},
{60'b001111111111100000000000011111111111111111000001111111110000},
{60'b001111111111111111111111111111111111111111111111111111111000},
{60'b001111111111111111111111111111111111111111111111111111111100},
{60'b001111111111111111111111111111111111111111111111111111111100},
{60'b001111111111111111111111111111111111111111111111111111111100},
{60'b001111111111111111111111111111111111111111111111111111111100},
{60'b001111111111111111111111111111111111111111111111111111111100},
{60'b001111111111111111111111111111111111111111000001111111111000},
{60'b000001111111100000000000001111111111111111000000000000000000},
{60'b000000000000000000000000000001111111111111000000000000000000},
{60'b000000000000000000000000000000001111111111000000000000000000},
{60'b000000000000000000000000000000000000000000000000000000000000},
{60'b000000000000000000000000000000000000000000000000000000000000},
{60'b000000000000000000000000000000000000000000000000000000000000},
{60'b000000000000000000000000000000000000000000000000000000000000}
};
  


logic drawing_X ;  /* synthesis keep */
logic drawing_Y ; /* synthesis keep */
logic mask_bit	; /* synthesis keep */


parameter num_player = 0;
int objectEndX ;
int objectEndY ;
int objectStartX_new ;
localparam  int StandOffset = 15;
localparam  int HalfSize = object_X_size / 2;

int rod_offset = 100; //offset between rods- goalkeeper and defense
int rod1_offset = 320; //offset between rods - goalkeeper and attack
int  ThreePlayers = 1 ;//signal checks if there are 3 or 2 players on the rod
int  TwoPlayers = 1 ;//signal checks if there are 2 or 1 players on the rod
int  offset = 130; //offset between players on one rod



// Calculate object end boundaries
assign objectStartX_new	= (right_direction) ? ObjectStartX : ObjectStartX + StandOffset ;
assign objectEndX	= (right_direction) ? (object_X_size + objectStartX_new) : (HalfSize + objectStartX_new) ;
assign objectEndY	= (object_Y_size + ObjectStartY);

assign rod_offset = (num_player) ? -100 : 100;
assign rod1_offset = (num_player) ? -320 : 320;



//
//-- Signals drawing_X[Y] are active when objects coordinates are being crossed
//
//-- test if ooCoord is in the rectangle defined by Start and End 



//asynchronized for duplicating players by offsets
always_comb begin 
      bCoord_Y = 0 ; //default values
      bCoord_X = 0 ; 
		drawing_X	=  0;
 		drawing_Y	=  0;
		ThreePlayers = 0;
		TwoPlayers = 0;		
		offset = 0;

		//---------X coordinations
		if  ((oCoord_X  >= objectStartX_new) &&  (oCoord_X < objectEndX)) begin // bCoordX when there are 1 players
			drawing_X	=  1;
			bCoord_X	=  oCoord_X - objectStartX_new ;
			ThreePlayers = 0 ;
			TwoPlayers = 0;
			offset = 0;
		end
		
		if  ((oCoord_X  >= objectStartX_new + rod_offset) &&  (oCoord_X < objectEndX + rod_offset)) begin // bCoordX when there are 2 players
			drawing_X	=  1;
			bCoord_X	=  oCoord_X - (objectStartX_new + rod_offset );
			ThreePlayers = 0 ;
			TwoPlayers = 1;
			offset = 100;

		 end
		
		if  ((oCoord_X  >= objectStartX_new + rod1_offset) &&  (oCoord_X < objectEndX + rod1_offset)) begin // bCoordX when there are 3 players
			drawing_X	=  1;
			bCoord_X	=  oCoord_X - (objectStartX_new + rod1_offset );
			ThreePlayers = 1 ;
			TwoPlayers = 0;
			offset = 130;

		 end 


		 //----------Y coordinations
		if  ((oCoord_Y  >= ObjectStartY) &&  (oCoord_Y < objectEndY) && ThreePlayers) begin //middle player
			drawing_Y = 1 ; 
			bCoord_Y = oCoord_Y - ObjectStartY;
		end
		
		if  ((oCoord_Y  >= ObjectStartY-offset) &&  (oCoord_Y < objectEndY-offset) ) begin // top player
			drawing_Y	= 1 ; 
			bCoord_Y = oCoord_Y - ( ObjectStartY-offset);
		end
		
		if  ((oCoord_Y  >= ObjectStartY+offset) &&  (oCoord_Y < objectEndY+offset)  ) begin //bottom player 
			drawing_Y	= 1 ; 
			bCoord_Y = oCoord_Y - (ObjectStartY+offset);
		end
end 

always_ff@(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		mVGA_RGB				<=	8'b0;
		drawing_request	<=	1'b0;
		mask_bit				<=	1'b0;
	end
	else
	begin
		if (num_player == 0) begin //player1
			if (right_direction) begin //lie position
				mVGA_RGB				<= player1_colors[bCoord_Y][bCoord_X];	//get from colors table 
				drawing_request	<= player1_mask[bCoord_Y][bCoord_X]&& drawing_X && drawing_Y ; // get from mask table if inside rectangle  
				mask_bit				<= player1_mask[bCoord_Y][bCoord_X];
			end
			else begin //stand position- smaller Y coordinations
				mVGA_RGB				<= player1_colors[bCoord_Y][bCoord_X*2];	//get from colors table 
				drawing_request	<= player1_mask[bCoord_Y][bCoord_X*2]&& drawing_X && drawing_Y ; // get from mask table if inside rectangle  
				mask_bit				<= player1_mask[bCoord_Y][bCoord_X*2];
			end
		end //end player1
		
		
		else begin //player2
			if (right_direction) begin //lie position
				mVGA_RGB				<= player2_colors[bCoord_Y][bCoord_X];	//get from colors table 
				drawing_request	<= player2_mask[bCoord_Y][bCoord_X]&& drawing_X && drawing_Y ; // get from mask table if inside rectangle  
				mask_bit				<= player2_mask[bCoord_Y][bCoord_X];
			end
			else begin //stand position- smaller Y coordinations
				mVGA_RGB				<= player2_colors[bCoord_Y][bCoord_X*2];	//get from colors table 
				drawing_request	<= player2_mask[bCoord_Y][bCoord_X*2]&& drawing_X && drawing_Y ; // get from mask table if inside rectangle  
				mask_bit				<= player2_mask[bCoord_Y][bCoord_X*2];
			end
		end //end player2
	end
end //always



endmodule 