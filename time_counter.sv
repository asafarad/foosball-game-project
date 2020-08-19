 
 
 
 
 module time_counter
	(
	input  logic clk, resetN, ena, loadN, 
	input  logic [3:0] datainL, datainH,
	output logic [3:0] countL, countH,
	output logic tc
   );
	logic tclow, tchigh;
	
// Low counter instantiation
	down_counter lowc( clk, resetN, ena, loadN, datainL, countL, tclow );
	
// High counter instantiation
	down_counter highc( clk, resetN, tclow && ena, loadN, datainH, countH, tchigh);
 
	assign tc = (tclow && tchigh) ? 1 : 0; //count finish

				
endmodule