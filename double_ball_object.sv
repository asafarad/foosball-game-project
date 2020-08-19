

module double_ball_object (
	   input   logic   CLK,
		input   logic   RESETn,
		input   logic [10:0] oCoord_X,
		input   logic [10:0] oCoord_Y,
		input   logic db_enaN,
		output  logic   drawing_request,
		output  logic [7:0] mVGA_RGB 
);

localparam int object_X_size = 40;
localparam int object_Y_size = 7;

// 8 bit - color definition : "RRRGGGBB"  
bit [0:object_Y_size-1] [0:object_X_size-1] [7:0] object_colors = { 
{8'h93, 8'hAE, 8'hA5, 8'hC5, 8'hC5, 8'hAD, 8'hD6, 8'h96, 8'h92, 8'h6E, 8'h49, 8'h6D, 8'h6D, 8'hB2, 8'hAE, 8'h86, 8'hC9, 8'hC5, 8'hA9, 8'hD6, 8'h96, 8'h72, 8'h6A, 8'h69, 8'h8D, 8'h8D, 8'h72, 8'h92, 8'hA5, 8'hE5, 8'hC5, 8'hC9, 8'hD7, 8'hB6, 8'h92, 8'h6E, 8'h69, 8'h8D, 8'h6D, 8'h91},
{8'hB2, 8'h65, 8'hC5, 8'hC9, 8'hC9, 8'hD2, 8'h91, 8'h96, 8'h4D, 8'h69, 8'h8E, 8'h8E, 8'hD6, 8'h8D, 8'h89, 8'hA6, 8'hA5, 8'hC9, 8'hF2, 8'h8D, 8'h92, 8'h6E, 8'h69, 8'h8D, 8'h8D, 8'hB2, 8'h92, 8'h89, 8'hA5, 8'hC5, 8'hC9, 8'hD2, 8'h8E, 8'h72, 8'h6E, 8'h49, 8'h8D, 8'h8E, 8'hB2, 8'hB2},
{8'hA5, 8'hA9, 8'hC9, 8'hCD, 8'hD2, 8'h8D, 8'h91, 8'hB6, 8'h6D, 8'h8D, 8'h8D, 8'hD2, 8'hD2, 8'h85, 8'hC9, 8'hC5, 8'hCD, 8'hD2, 8'h6D, 8'h96, 8'hB6, 8'h8D, 8'h8D, 8'h8D, 8'hD6, 8'hB2, 8'h85, 8'hA9, 8'hA5, 8'hA9, 8'hD6, 8'h6D, 8'h91, 8'hB6, 8'h71, 8'h6D, 8'hAD, 8'hD2, 8'hD2, 8'h89},
{8'hC5, 8'hA5, 8'hCD, 8'hD1, 8'h8D, 8'hB2, 8'hDA, 8'h91, 8'hB1, 8'h8D, 8'hF6, 8'hCE, 8'hA5, 8'hC9, 8'hA5, 8'hCD, 8'hD2, 8'h8D, 8'h92, 8'hB6, 8'hB1, 8'hAD, 8'hAD, 8'hF2, 8'hAE, 8'h89, 8'hC9, 8'hA5, 8'hCD, 8'hD2, 8'h6D, 8'h96, 8'hB5, 8'h91, 8'h91, 8'h8D, 8'hF2, 8'hCE, 8'h85, 8'hAA},
{8'hA9, 8'hCD, 8'hB2, 8'h8D, 8'hB1, 8'hD6, 8'hAD, 8'hAD, 8'hB1, 8'hD6, 8'hAE, 8'hA5, 8'hC9, 8'hA9, 8'hCD, 8'hD2, 8'h8D, 8'h92, 8'hD2, 8'hB1, 8'hAD, 8'hAD, 8'hF2, 8'hAE, 8'hA5, 8'hCA, 8'hC9, 8'hCD, 8'hD2, 8'h8D, 8'h91, 8'hD6, 8'hB1, 8'hAD, 8'hB1, 8'hD6, 8'hCD, 8'hA5, 8'hCA, 8'hC9},
{8'hAD, 8'hD6, 8'h91, 8'h92, 8'hB2, 8'hAD, 8'hAD, 8'hD1, 8'hD1, 8'h8D, 8'h85, 8'hAA, 8'hA9, 8'hCD, 8'hD6, 8'h8D, 8'h92, 8'hB2, 8'hAD, 8'hAD, 8'hB1, 8'hF6, 8'hAE, 8'h85, 8'hCA, 8'hC9, 8'hCD, 8'hF2, 8'h8D, 8'h92, 8'hB1, 8'hAD, 8'hAD, 8'hD1, 8'hD2, 8'hAD, 8'hA5, 8'hC9, 8'hA5, 8'hC9},
{8'hFE, 8'hFA, 8'hD6, 8'hDB, 8'hF6, 8'hD6, 8'hF6, 8'hFA, 8'hD6, 8'hD2, 8'hD2, 8'hF6, 8'hF2, 8'hFB, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hDA, 8'hAE, 8'hF3, 8'hF2, 8'hCE, 8'hFA, 8'hFA, 8'hDA, 8'hDA, 8'hD6, 8'hD6, 8'hF6, 8'hF6, 8'hFB, 8'hD2, 8'hF3, 8'hF3, 8'hF2, 8'hFB}
};

// one bit mask  0 - off 1 dispaly 
bit [0:object_Y_size-1] [0:object_X_size-1] object_mask = {
{40'b1111111111111111111111111111111111111111},
{40'b1111111111111111111111111111111111111111},
{40'b1111111111111111111111111111111111111111},
{40'b1111111111111111111111111111111111111111},
{40'b1111111111111111111111111111111111111111},
{40'b1111111111111111111111111111111111111111},
{40'b1111111111111111111111111111111111111111}
};

int bCoord_X;// offset from start position 
int bCoord_Y;

logic drawing_X;
logic drawing_Y; // synthesis keep
logic mask_bit;

int objectEndX;
int objectEndY;
localparam int ObjectStartX = 279;
localparam int ObjectStartY = 472;



// Calculate object end boundaries
assign objectEndX    = (object_X_size + ObjectStartX);
assign objectEndY    = (object_Y_size + ObjectStartY);

// Signals drawing_X[Y] are active when obects coordinates are being crossed


always_comb begin

	bCoord_Y = 0 ; //default values
   bCoord_X = 0 ; 
	drawing_X	=  0;
 	drawing_Y	=  0;
	if ((oCoord_X  >= ObjectStartX) &&  (oCoord_X < objectEndX) && (oCoord_Y  >= ObjectStartY) &&  (oCoord_Y < objectEndY)) begin
		drawing_X = 1;
		drawing_Y = 1;
		bCoord_X = oCoord_X - ObjectStartX;
		bCoord_Y = oCoord_Y - ObjectStartY;
	end
	if ((oCoord_X  >= (ObjectStartX + object_X_size)) &&  (oCoord_X < (objectEndX + object_X_size)) && (oCoord_Y  >= ObjectStartY) &&  (oCoord_Y < objectEndY)) begin
		drawing_X = 1;
		drawing_Y = 1;
		bCoord_X = oCoord_X - (ObjectStartX + object_X_size);
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
			mVGA_RGB	<=  object_colors[bCoord_Y][bCoord_X];	//get from colors table 
			drawing_request	<= object_mask[bCoord_Y][bCoord_X] && drawing_X && drawing_Y && db_enaN; // get from mask table if inside rectangle 
			mask_bit	<= object_mask[bCoord_Y][bCoord_X];
	end
end

endmodule		

//generated with PNGtoSV tool by Ben Wellingstein
