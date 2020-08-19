
module goal_object (
	   input   logic   CLK,
		input   logic   RESETn,
		input   logic [10:0] oCoord_X,
		input   logic [10:0] oCoord_Y,
		input   logic goal_ena,
		output  logic   drawing_request,
		output  logic [7:0] mVGA_RGB 
);

localparam int object_X_size = 100;
localparam int object_Y_size = 100;


// one bit mask  0 - off 1 dispaly 
bit [0:object_Y_size-1] [0:object_X_size-1] object_mask = {
{100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000000000000000000000000011110000000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000000000000000000000001100011000000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000000111100000000000011011110100000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000001000110000000000110111111010000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000010111101100000001011111111101000000000000100000000000000000},
{100'b0000000000000000000000000000000000000000101111110011000010111111111110100000000111011000000000000000},
{100'b0000000000000000000000000000000000000001011111111101110101111110111111010000111000111100000000000000},
{100'b0000000000000000000000000000000000000001011111111111011011111101011111111111000111111010000000000000},
{100'b0000000000000000000000000000000000000010111111111111110111111010101111101100111111111101000000000000},
{100'b0000000000000000000000000010000000000101111101011111111111110100010111110111111111111101000000000000},
{100'b0000000000000000000000000101111100000101111101110111111111101000001011111111111111111101000000000000},
{100'b0000000000000000000000001011000011111011111010011101111111010000000101111111111110111101000000000000},
{100'b0000000000000000000000001111111100001011110100000110011110100000000110111111110010111110100000000000},
{100'b0000000000000000000000101111111111110111110100000001100011000000000011111110011111011110100000000000},
{100'b0000000000000000000000101111111111111111101000000000011110000000000001100011100001011110100000000000},
{100'b0000000000000000000001011111111111111111101000000000000000000000000000011100000001011110100000000000},
{100'b0000000000000000000001011110100111111111010000000000000000000000000000000000000001011111010000000000},
{100'b0000000000000000000001011110111000011110100000000000000000000000000000000011100000101111011100000000},
{100'b0000000000000000000000011110100111100011000000000000000000000000000000000110110000101111111011110000},
{100'b0000000000000000000010111110100000011110000000000000000000000000000000001011101000101111111100011100},
{100'b0000000000000000000010111101000000000000000000000000000000000000000000010111110100000111111111110010},
{100'b0000000000000000111110111101000000000000000000000000000000000000000000010111110100010111111111111101},
{100'b0000000000111111000101111101000000000000000000000000000000000000000000001011110100001100111111111110},
{100'b0000000001100000111111111101000000000000000000000000000000000111100000001011111010000111010111111111},
{100'b0000000010111111111111111010000000000000000000000000000000000000100000000101111010000000111001011111},
{100'b0000000101111111111111111010000000000000000000000000000000010111101000000101111101000000000111011110},
{100'b0000000101111111111111110100000000000000000000000000000000101111101000000010111101000000000010111110},
{100'b0000000101111111111000011000000000000000000000000001100000010111101000000010111101000000000000111101},
{100'b0000000101111010000111110000000000000000000000000110010000010111110100000010111110100000000101111101},
{100'b0000000101111011111000000000000000000000000000000011111000010111110100000001011110100000000101111010},
{100'b0000000101111010000000000000000000000000000000010111110100001011111010000001011111010000001011111010},
{100'b0000000101111010000000000000000000000000000000010111111010001011111010000000101111010000000011110100},
{100'b0000000101111010000000000000000000000000000000010111111101000101111101000000101111010000010111110100},
{100'b0000000101111101000000000000000000000000000000010111111110100101111101000000010111101000010111101000},
{100'b0000000101111101000000000000000000011101110000010111111111010010111101000000010111101000010111101000},
{100'b0000000101111101000000000000000001100000011000010111111111111010111110100000000011011000010111110100},
{100'b0000000010111101000000000000000011011111110100010111111111101010111110100000000110110000001011110100},
{100'b0000000011111101000000000000000101111111111010000011110111110101011111010000111101111010001011101000},
{100'b0001001011111101000000000000001011111111111101001011110011111011011111010011100101111010000110111110},
{100'b0110111011111010000000000000010111111111111110101011110011111101101111101100111101111010000011100011},
{100'b1001101011110100000001111100010111110000111110101011110001111110101111101011111110111000000000101110},
{100'b0111100100011000000110000110010111100000011110101011110000111111010111101111111111101000000001011111},
{100'b1111110111110000011001111101101111100000011111011011110001111111010111111111111101110000000001011111},
{100'b1111101000000000110111111110110111100000011111011011110111111111101111111111100100000000000011101111},
{100'b1111010000000001011111111111010111100000001111101011111111111111110011111110111100000000001110111111},
{100'b1111101000000010111111111111100111110000001111101011111111110111111011111001100000000000111011111111},
{100'b1111101000000010111111111111100011110000000111110011111111001011111010001110000000000001101111111110},
{100'b0111110100000101111100111111100011111000000111110101111011000101111011111000000000000010111111111011},
{100'b1011111100000101111100001111110011111000000011110101111011000010110000000000000000000101111111100110},
{100'b1011111010000101111100000111100001111100000011111001111010000001011000000000000000001011111111011000},
{100'b0101111101000101111100000000000001111100000011111001111010000000110000000000000000001011111101100000},
{100'b0010111101000000111100000111111010111100000001111001111101000000000000000000000000001011110110000000},
{100'b0010111110100010111110001111111100111110000001111001111010000000000000000000000000001011111010000000},
{100'b0001011110100010111110001111111101011111000011111010110000000000000000000000000000001011111010000000},
{100'b0001011110100001011111001111111110011111111111110101101000000000000000000000000000001011111010000000},
{100'b0010111110100001011111001110111110101111111111110100110000000000000000000000000000000101111010000000},
{100'b0010111100000000101111001111011110101111111111101000000000000000000000000000000000000101111010000000},
{100'b0101111101000000101111101111011111010111111110110000000000000000000000000000000000000101111010000000},
{100'b0101111010000000101111100000011111011101111001100000000000000000000000000000000001111101111010000000},
{100'b1011111010000000010111110000011111010111001110000000000000000000000000000000111110000101111010000000},
{100'b1011110000000000010111110000111110100001110000000000000000000000000000000001100001111111111010000000},
{100'b0111110100000000001011111111111110100000000000000000000000000000000000000010111111111111111010000000},
{100'b0111101110000000001011111111111101000000000000000000000000000000000000000101111111111111111010000000},
{100'b1111101001110000000101111111111010000000000000000000000000000000000000000101111111111111110100000000},
{100'b1111111110101110000010111111101100000000000000000000000000000000000000001011111111110000011000000000},
{100'b0111111111110011000001000000011000000000000000000000000000000000000000001011111010001111110000000000},
{100'b1011111111111110100000011111100000000000000000000000000000000000000000001011110111110000000000000000},
{100'b0100111111111110000000000000000000000000000000000000000000000000000000001011110100000000000000000000},
{100'b0011100011111111010000000000000000000000000000000000000000000111100000010111110100000000000000000000},
{100'b0000111101111111010000000000000000000000000000000000000000001100011110010111100000000000000000000000},
{100'b0000000011101111010000000000000000000000000000000000000000010111100001110111101000000000000000000000},
{100'b0000000000101111101000000000000000000000000000000000000000101111111110010111101000000000000000000000},
{100'b0000000000010111101000000011100000000000000000000000000001011111111111111111101000000000000000000000},
{100'b0000000000010111101000011100011000000000000111100000000001011111111111111111010000000000000000000000},
{100'b0000000000010111101111100111111100000000001100011000000010111110111111111111010000000000000000000000},
{100'b0000000000010111110100111111110110000000010111100110000010111101000011111111000000000000000000000000},
{100'b0000000000001011110111111111111010000000101111111011100101111101111100001101000000000000000000000000},
{100'b0000000000001011111111111111111101000001011111111110111011111010000011111010000000000000000000000000},
{100'b0000000000001011111111111110111110100010111111111111101011111010000000000100000000000000000000000000},
{100'b0000000000001011111111110011011111010101111110111111111111110100000000000000000000000000000000000000},
{100'b0000000000000101111110001111111111101011111101101111111111101000000000000000000000000000000000000000},
{100'b0000000000000011110001110000101111110111111010111011111111101000000000000000000000000000000000000000},
{100'b0000000000000001101110000000010111111111110100001100111111010000000000000000000000000000000000000000},
{100'b0000000000000000010000000000001011111111101000000011011110100000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000101111110110000000000110001000000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000010111101100000000000011110000000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000001100011000000000000000000000000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000000111100000000000000000000000000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000},
{100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000}
};

int bCoord_X;// offset from start position 
int bCoord_Y;

logic drawing_X;
logic drawing_Y; // synthesis keep
logic mask_bit;
localparam int ObjectStartX = 270;
localparam int ObjectStartY = 190;
int objectEndX;
int objectEndY;



// Calculate object end boundaries
assign objectEndX    = (object_X_size + ObjectStartX);
assign objectEndY    = (object_Y_size + ObjectStartY);

// Signals drawing_X[Y] are active when obects coordinates are being crossed

// test if oCoord is in the rectangle defined by Start and End 
assign drawing_X  = ((oCoord_X  >= ObjectStartX) &&  (oCoord_X < objectEndX)) ? 1 : 0;
assign drawing_Y = ((oCoord_Y  >= ObjectStartY) &&  (oCoord_Y < objectEndY)) ? 1 : 0;

// calculate offset from start corner 
assign bCoord_X	= (drawing_X == 1 &&  drawing_Y == 1)  ? (oCoord_X - ObjectStartX): 0;
assign bCoord_Y	= (drawing_X == 1 &&  drawing_Y == 1  )  ? (oCoord_Y - ObjectStartY): 0; 


always_ff@ (posedge CLK, negedge RESETn)
begin
    if(!RESETn)
   begin
         mVGA_RGB	<= 8'b0;
         drawing_request     <= 1'b0;
         mask_bit	<=  1'b0;
    end
   else
  begin
			drawing_request	<= object_mask[bCoord_Y][bCoord_X] && drawing_X && drawing_Y && goal_ena; // get from mask table if inside rectangle and enable
			mask_bit	<= object_mask[bCoord_Y][bCoord_X]; 
			if (object_mask[bCoord_Y][bCoord_X])
				mVGA_RGB	<= 8'b11111001; //uniform color
	end
end

endmodule		

//generated with PNGtoSV tool by Ben Wellingstein