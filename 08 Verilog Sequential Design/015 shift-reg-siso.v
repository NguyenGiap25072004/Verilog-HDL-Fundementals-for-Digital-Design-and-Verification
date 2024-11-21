
module shift_reg_siso(
	input reset_n,
	input clk,
    input sdi, // serial data in
	output sdo // serial data out
    );
	
	// Internal 4 bits wide register
	reg [3:0] siso;
	
	// Async negative reset is used
	// The input data is the same as the output data
	always @(posedge clk or negedge reset_n) begin
	    if (!reset_n)
		    siso <= 4'b0;
	    else
		    siso[3:0] <= {siso[2:0], sdi};
	end

    // Connect the sdo net to the register MSB
    assign sdo = siso[3];

endmodule


`timescale 1us/1ns
module tb_shift_reg_siso();
	
	// Testbench variables
    reg sdi;
	reg clk = 0;
	reg reset_n;
	wire sdo;
	
	// Instantiate the DUT
    shift_reg_siso SISO0(
		.reset_n(reset_n),
	    .clk    (clk    ),
        .sdi    (sdi    ),
	    .sdo    (sdo    )
    );
	
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
    // Create stimulus	  
    initial begin
	    #1; // apply reset to the circuit
        reset_n = 0; sdi = 0;
		
		#1.3; // release the reset
		reset_n = 1;
		
		// Set sdi for 1 clock
		@(posedge clk); sdi = 1'b1; @(posedge clk); sdi = 1'b0;
        
		// Wait for the bit to shift
        repeat (5) @(posedge clk); 
		@(posedge clk); sdi = 1'b1; 
		@(posedge clk);
		@(posedge clk); sdi = 1'b0;
	end
	
    // This will stop the simulator when the time expires
    initial begin
        #40 $finish;
    end  
endmodule
