module d_ff_async_rstn(
	input reset_n,
    input clk,
    input d,
	output reg q,
    output q_not
    );
	
	// The D-Flip Flop has a positive edge clock
	// reset_n is asynchronous with the clk signal
	// Use non-blocking operator for sequential logic
	always @(posedge clk or negedge reset_n) begin
	    if (!reset_n)
		    q <= 1'b0;
	    else
		    q <= d;  
	end
	
	assign q_not = ~q;
	
endmodule


`timescale 1us/1ns
module tb_d_dff_rstn();
	
	// Testbench variables
    reg d;
	reg clk = 0;
	reg reset_n;
	wire q;
    wire q_not;
	reg [1:0] delay;
    integer i;
	
	// Instantiate the DUT
	d_ff_async_rstn DFF0(
	    .reset_n(reset_n),
	    .clk    (clk    ),
        .d      (d      ),
	    .q      (q      ),
        .q_not  (q_not  )
	);
	
	// Create the clk signal
	always begin
	    #0.5 clk = ~clk;
	end
	
    // Create stimulus	  
    initial begin
        reset_n = 0; d = 0;
		for (i=0; i<5; i=i+1) begin
		   delay = $random+1;
		   #(delay) d = ~d;
		end
		
		reset_n = 1;
	    for (i=0; i<5; i=i+1) begin
		   delay = $random+1;
		   #(delay) d = ~d; // toggle the FF at random times
		end	
        #(0.2); reset_n = 0; // reset the FF again		
	end
	
    // This will stop the simulator when the time expires
    initial begin
        #40 $finish;
    end  
endmodule
