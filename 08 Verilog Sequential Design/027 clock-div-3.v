/*
module clock_div3(input clock_in,
			       input reset_n,
			       output clock_out);
	
	// Internal variables for the FFs
	reg qa, qb, qc;

	// Flip-flop A - positive clock edge
	always @(posedge clock_in or negedge reset_n)
	begin
	    if(!reset_n)
		    qa <= 1'b0;
	    else
            qa <= (~qa) & (~qb);	
	end
	
	// Flip-flop B - positive clock edge
	always @(posedge clock_in or negedge reset_n)
	begin
	    if(!reset_n)
		    qb <= 1'b0;
	    else
            qb <= qa;	
	end
	
	// Flip-flop C - negative clock edge
	always @(negedge clock_in or negedge reset_n)
	begin
	    if(!reset_n)
		    qc <= 1'b0;
	    else
            qc <= qb;	
	end

    // Make the final OR gate (makes 50% duty cycle)
	assign clock_out = qb | qc;

endmodule
*/


module clock_div3(input clock_in,
			       input reset_n,
			       output clock_out);
	
	// Internal variables for the FFs
	reg qa, qb, qc;

	// Flip-flops A/B - positive clock edge
	always @(posedge clock_in or negedge reset_n)
	begin
	    if(!reset_n) begin
		    qa <= 1'b0;
			qb <= 1'b0;
	    end else begin
            qa <= (~qa) & (~qb);
            qb <= qa;
        end
	end
	
	// Flip-flop C - negative clock edge
	always @(negedge clock_in or negedge reset_n)
	begin
	    if(!reset_n)
		    qc <= 1'b0;
	    else
            qc <= qb;	
	end

    // Make the final OR gate (makes 50% duty cycle)
	assign clock_out = qb | qc;

endmodule



`timescale 1us/1ns
module tb_clock_div3();
	
	// Testbench variables
	reg clk = 0;
	reg reset_n;
	wire clock_out;
	
	// Instantiate the DUT
    clock_div3 CLK_DIV0
        (.clock_in(clk),
         .reset_n(reset_n),
		 .clock_out(clock_out)
        );
	
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
    // Create stimulus	  
    initial begin	 
	    #1  ;           reset_n = 0; 
		@(posedge clk); reset_n = 1; 
		repeat(20) @(posedge clk); $stop;		
	end
	
endmodule