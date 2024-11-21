
`timescale 1us/1ns

module tb_mux(
    // no inputs here ;)
    );
	
   reg a;
   reg b;
   reg x;
   wire y;

	
    // Instantiate the DUT
    mux_1bit MUX1(
      .a(a),
      .b(b),
      .x(x),
      .y(y)
   );
  
	// Generate stimulus
	initial begin
	   #1; $display("Verilog is cool");
       #1; a = 1; b = 0; x = 1;
       #1; a = 0; b = 1; x = 0;
       #1; a = 0; b = 1; x = 1;
       #1; a = 0; b = 0; x = 1;
       #1; a = 1; b = 1; x = 1;
       #1; a = 0; b = 1; x = 0;
	   #5;
	end

endmodule


