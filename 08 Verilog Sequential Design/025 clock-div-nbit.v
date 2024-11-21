
module clock_div_nbit 
    // Parameters section
    #( parameter CNT_WIDTH = 4)
    // Ports section
    (input clk,
    input reset_n,
	output reg clk_div2,
    output [CNT_WIDTH-1:0] counter // only a net
	); 
  
    // Make a separate divider by two
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
		    clk_div2 <= 0;
		else
		    clk_div2 <= ~clk_div2; // feedback loop
    end 
	
	// Instantiate a parameterizable module 
	// with a new parameter value
    counter_nbit 
        #(.CNT_WIDTH(CNT_WIDTH))
		    CNT_NBIT0
        (.clk    (clk    ),
         .reset_n(reset_n),
         .counter(counter)
		);
  
endmodule


module counter_nbit 
    // Parameters section
    #( parameter CNT_WIDTH = 3)
    // Ports section
    (input clk,
    input reset_n,
    output reg [CNT_WIDTH-1:0] counter);
  
    // Use non-blocking assignment for sequential logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
		    counter <= 0;
		else
		    counter <= counter + 1'b1;
    end  
  
endmodule


`timescale 1us/1ns
module tb_clock_div_nbit();
	
	// Testbench variables
	parameter CNT_WIDTH = 4;
    reg clk = 0;
    reg reset_n;
	wire clk_div2;
    wire [CNT_WIDTH-1:0] counter;
	
	// Instantiate the DUT
    clock_div_nbit 
        // Parameters section
        #(.CNT_WIDTH(CNT_WIDTH))
		  CLK_DIV0
        // Ports section
        (.clk     (clk     ),
         .reset_n (reset_n ),
		 .clk_div2(clk_div2),
         .counter (counter ));
	
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
    // Create stimulus	  
    initial begin	 
	    #1  ; reset_n = 0; 	// apply reset
		#1.2; reset_n = 1;  // release reset
		repeat(20) @(posedge clk); $stop;
	end

endmodule
