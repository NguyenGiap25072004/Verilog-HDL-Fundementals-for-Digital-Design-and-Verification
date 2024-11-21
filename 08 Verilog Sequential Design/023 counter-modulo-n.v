
module counter_modulo_n
    // Parameters section
    #( parameter N = 10, 
	   parameter CNT_WIDTH = 4)
    // Ports section
    (input clk,
    input reset_n,
	input enable,
    output reg [CNT_WIDTH-1:0] counter_out);
  
    // Use non-blocking assignment for sequential logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
		    counter_out <= 0;
	    else if (enable) begin
		    if (counter_out == (N-1)) begin
				counter_out <= 0;
            end else begin
				counter_out <= counter_out + 1'b1;
		    end
		end
    end  
  
endmodule


`timescale 1us/1ns
module tb_counter_modulo_n();
	// Testbench variables
	parameter CNT_WIDTH = 4;
    parameter N = 10;

    reg clk = 0;
    reg reset_n;
	reg enable;
    wire [CNT_WIDTH-1:0] counter_out;
	
	// Instantiate the DUT
    counter_modulo_n 
        // Parameters section
        #(.N(N), .CNT_WIDTH(CNT_WIDTH))
		    CNT_MODN0
        // Ports section
        (.clk        (clk        ),
         .reset_n    (reset_n    ),
		 .enable     (enable     ),
         .counter_out(counter_out));
	
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
    // Create stimulus	  
    initial begin	 
	    $monitor ($time, " enable = %b, counter_out = %d",
		               enable, counter_out);
	    #1  ; reset_n = 0; enable = 0; 	
		#1.2; reset_n = 1;  // release reset
		repeat(3) @(posedge clk); enable = 1;     
		repeat(14) @(posedge clk); $stop;
	end
	
endmodule
