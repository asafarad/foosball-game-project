



module gate_object (
	   input   logic   CLK,
		input   logic   RESETn,
		input   logic [10:0] oCoord_X,
		input   logic [10:0] oCoord_Y,
		output  logic   drawing_request,
		output  logic [7:0] mVGA_RGB 
);

localparam int object_X_size = 15;
localparam int object_Y_size = 140;

// 8 bit - color definition : "RRRGGGBB"  
bit [0:object_Y_size-1] [0:object_X_size-1] [7:0] object_colors = { 
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hB6, 8'hDB, 8'hDB, 8'hFF},
{8'hFF, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h92, 8'h6D, 8'h92, 8'hB6, 8'hDB},
{8'hDB, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h92, 8'h24, 8'h6D, 8'hB6, 8'hDB},
{8'hDB, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hBB, 8'h6D, 8'h24, 8'h6D, 8'hB6, 8'hDB},
{8'hDB, 8'hB6, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hB6, 8'hFF, 8'hB6, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hDF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hDF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hDF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDF, 8'hDF, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDF, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hDB, 8'hFF, 8'hBA, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB},
{8'hDF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDF, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDF, 8'hFF},
{8'hDF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB},
{8'hDF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hBA, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hDF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDF, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hFF, 8'hDF, 8'hDF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hBB, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDF, 8'hDF, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hB6, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hFF, 8'hDB, 8'hDB, 8'hDF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hDB, 8'hFF, 8'hBB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDF, 8'hFF, 8'hDF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB},
{8'hFF, 8'hDB, 8'hDF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDF, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hDF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hBA, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDF, 8'hDB, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hDF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB},
{8'hDF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hDB, 8'hFF, 8'hBA, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hDF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDF, 8'hDB, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hDF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hDF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDF, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hB6, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hDF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDF, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hDF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF},
{8'hDB, 8'hB6, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF},
{8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB},
{8'hDB, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hB6, 8'hFF, 8'hDB, 8'hFF, 8'hDF, 8'hDB, 8'hDF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hB6, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF},
{8'hDB, 8'hBB, 8'hFF, 8'hDF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF},
{8'hDB, 8'hB7, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB},
{8'hDB, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF},
{8'hDB, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h92, 8'h92, 8'h92, 8'hB6, 8'hDB},
{8'hDB, 8'h92, 8'h92, 8'hB6, 8'h92, 8'hB6, 8'h92, 8'hB6, 8'hB6, 8'hB6, 8'h92, 8'h6D, 8'h6D, 8'h92, 8'hDB},
{8'hFF, 8'hB6, 8'h92, 8'h92, 8'h92, 8'h92, 8'hB6, 8'h92, 8'h92, 8'hB6, 8'h6D, 8'h24, 8'h49, 8'hB6, 8'hDB},
{8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hB6, 8'h6D, 8'hB6, 8'hDB, 8'hFF},
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF}
};

// one bit mask  0 - off 1 dispaly 
bit [0:object_Y_size-1] [0:object_X_size-1] object_mask = {
{15'b000000000000000},
{15'b000000000000000},
{15'b011111111111111},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b000011100011111},
{15'b011100011100011},
{15'b011111111111111},
{15'b000000000000000},
{15'b000000000000000}
};

int bCoord_X;// offset from start position 
int bCoord_Y;

logic drawing_X;
logic drawing_Y; // synthesis keep
logic mask_bit;

int objectEndX;
int objectEndY;
localparam int ObjectStartX = 0;
localparam int ObjectStartY = 169;
int gate_offset = 624;
localparam int middleOfPlayground = 320;
parameter num_gate = 0;


// Calculate object end boundaries
assign objectEndX    = (object_X_size + ObjectStartX);
assign objectEndY    = (object_Y_size + ObjectStartY);


always_comb begin

	bCoord_Y = 0 ; //default values
   bCoord_X = 0 ; 
	drawing_X	=  0;
 	drawing_Y	=  0;
	if ((oCoord_X  >= ObjectStartX) &&  (oCoord_X < objectEndX) && (oCoord_Y  >= ObjectStartY) &&  (oCoord_Y < objectEndY) && num_gate == 0) begin //left gate
		drawing_X = 1;
		drawing_Y = 1;
		bCoord_X = oCoord_X - ObjectStartX;
		bCoord_Y = oCoord_Y - ObjectStartY;
	end
	if ((oCoord_X  >= ObjectStartX + gate_offset) &&  (oCoord_X < objectEndX + gate_offset) && (oCoord_Y  >= ObjectStartY) &&  (oCoord_Y < objectEndY) && num_gate	== 1) begin //right gate
		drawing_X = 1;
		drawing_Y = 1;
		bCoord_X = oCoord_X - ObjectStartX + gate_offset;
		bCoord_Y = oCoord_Y - ObjectStartY;
	end
end

always_ff@ (posedge CLK, negedge RESETn)
begin
    if(!RESETn) begin
         mVGA_RGB	<= 8'b0;
         drawing_request <= 1'b0;
         mask_bit	<=  1'b0;
    end
    else begin
			if (num_gate == 0) begin //left gate
				mVGA_RGB	<=  object_colors[bCoord_Y][bCoord_X];	//get from colors table 
				drawing_request	<= object_mask[bCoord_Y][bCoord_X] && drawing_X && drawing_Y ; // get from mask table if inside rectangle 
				mask_bit	<= object_mask[bCoord_Y][bCoord_X]; 
			end
			else begin //right gate
				mVGA_RGB	<=  object_colors[bCoord_Y][object_X_size - 1 - bCoord_X];	//get from colors table 
				drawing_request	<= object_mask[bCoord_Y][object_X_size - 1 - bCoord_X] && drawing_X && drawing_Y ; // get from mask table if inside rectangle 
				mask_bit	<= object_mask[bCoord_Y][object_X_size - 1 - bCoord_X]; 
			end
	end
end

endmodule		

//generated with PNGtoSV tool by Ben Wellingstein
