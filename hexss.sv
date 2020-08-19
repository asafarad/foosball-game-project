// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 


// Implements the hexadecimal to 7Segment conversion unit
// by using a two-dimensional array

module hexss 
	(
	input logic [3:0] hexin, 		// Data input: hex numbers 0 to f
	input logic darkN, LampTest, 	// Aditional inputs
	output logic [6:0] ss 	// Output for 7Seg display
	);

//Define the transformation table hex to 7Segment	
	logic [0:15] [6:0] SevenSeg =	
				'{	7'h40, //0
					7'h79, //1
					7'h24, //2
					7'h30, //3
					7'h19, //4
					7'h12, //5
					7'h02, //6
					7'h78, //7
					7'h00, //8
					7'h10, //9
					7'h08, //A
					7'h03, //B
					7'h46, //C
					7'h21, //D
					7'h06, //E
					7'h0e};//F
					
	always_comb
	begin
		if (LampTest == 1'b1)
			ss = SevenSeg[8];
		else if (!darkN)
			ss = 7'h7f;
		else
			ss = SevenSeg[hexin];
	end
	
endmodule
