// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 

// Implements a down counter 9 to 0 with enable and loadN data
// and count and tc outputs

module down_counter
	(
	input logic clk, resetN, ena, loadN, 
	input logic [3:0] datain,
	output logic [3:0] count,
	output logic tc
   );

// Down counter
always_ff @(posedge clk or negedge resetN)
   begin
	      
      if ( !resetN )	begin // Asynchronic reset
			
			count <= 9;
			
			end
				
      else 	begin		// Synchronic logic		
			
			if (!loadN) begin //load data
				count <= datain;
			end
			else if (!ena) begin
				count <= count;
			end
			else if (count == 0) begin //count finish
				count <= 9;
			end
			else begin
				count <= count - 1;
			end
			
			
		end //Synch
	end //always
	
assign tc = (count == 0) ? 1 : 0;

	
endmodule
