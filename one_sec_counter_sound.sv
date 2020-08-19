


module one_sec_counter_sound      	
	(
   // Input, Output Ports
   input  logic clk, resetN, sound,
   output logic one_sec, sound_flag,
	output logic [9:0]  sound_freq
   );
	
	parameter [25:0] oneSec = 26'd5000000; // For real 1/10 onesec or two seconds clock
	
	localparam logic [25:0] oneSecTurbo = oneSec/26'd10; 
	logic  [25:0] oneSecCount = 26'd0;
	
	parameter [9:0] freq = 0;
		
   always_ff @( posedge clk or negedge resetN )
   begin
	
      // Asynchronic reset
      if ( !resetN ) begin
			one_sec <= 1'b0;
			oneSecCount <= 26'd0;
			sound_flag <= 0;
			sound_freq <= 200;
		end //asynch
		
		// Synchronic logic	
      else begin
			oneSecCount <= oneSecCount + 26'd1;
				
				if (sound && !sound_flag) begin
					sound_flag <= 1;
					sound_freq <= freq;
				end
						
				else if (oneSecCount >= oneSec && sound_flag) begin
					one_sec <= 1'b1;
					oneSecCount <= 26'd0;
					sound_flag <= 0;
				end
				else 
					one_sec <= 1'b0;
		end //synch
	end // always
endmodule
