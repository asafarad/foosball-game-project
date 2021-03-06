


module one_sec_counter      	
	(
   // Input, Output Ports
   input  logic clk, resetN,
   output logic one_sec
   );
	
	localparam logic [25:0] oneSec = 26'd50000000; // For real one sec clock
	localparam logic [25:0] oneSecTurbo = oneSec/26'd10; 
	logic  [25:0] oneSecCount = 26'd0;
		
   always_ff @( posedge clk or negedge resetN )
   begin
	
      // Asynchronic reset
      if ( !resetN ) begin
			one_sec <= 1'b0;
			oneSecCount <= 26'd0;
		end //asynch
		
		// Synchronic logic	
      else begin
			oneSecCount <= oneSecCount + 26'd1;
				
						
				if (oneSecCount >= oneSec) begin
					one_sec <= 1'b1;
					oneSecCount <= 26'd0;
				end
				else 
					one_sec <= 1'b0;

		end //synch
	end // always
endmodule
