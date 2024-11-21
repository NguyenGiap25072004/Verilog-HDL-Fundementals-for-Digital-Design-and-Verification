
module seq_det_non_overlap(
        input clk,
		input rst_n,
		input seq_in,
		output reg detected,
		output [1:0] state_out // used for debug
        );
    
	// Declare the state values as parameters using binary values
	parameter [1:0] S1   = 2'd0,
	                S10  = 2'd1,
					S101 = 2'd2;
					
	// Declare the logic for the state machine
	reg [3:0] state;      // the sequential part
	reg [3:0] next_state; // the combinational part
		
	// Next state logic
	always @(*) begin
		detected = 1'b0;
	    case (state)
		    S1  : begin  // wait the first 1
			        if (seq_in == 1) next_state = S10;
					else             next_state = S1;
				end
		    S10 : begin  // wait next for a 0
                    if (seq_in == 0) next_state = S101;
			        else             next_state = S10;				
				end
		    S101: begin  // wait next for a 1
                    if (seq_in == 1) begin 
					    detected = 1'b1;
			        end
					next_state = S1;			
				end
		    default: next_state = S1; // best practice
		endcase
	end
	
	// State sequencer logic
	always @(posedge clk or negedge rst_n) begin
	    if(!rst_n)
		    state <= S1;
	    else
		    state <= next_state;
	end
	
	assign state_out = state; // connect with output port
	
endmodule



`timescale 1us/1ns
module tb_seq_det_non_overlap();

    reg clk = 0;
	reg rst_n;
	reg seq_in;
	wire detected;
	wire [1:0] state_out;
   
    reg [0:13] test_vect = 14'b00_1100_0101_0101;
	integer i;
	
    // Instantiate the module
    seq_det_non_overlap SEQ_DET0(
        .clk      (clk      ),
		.rst_n    (rst_n    ),
		.seq_in   (seq_in   ),
		.detected (detected ),
		.state_out(state_out)
        );
	
    initial begin // Create the clock signal
        forever begin 
		    #1 clk = ~clk;
	    end
    end

    initial begin
	    $monitor($time, " seq_in = %b, detected = %b", seq_in, detected);
		
	    rst_n = 0; #2.5; rst_n = 1; // reset sequence
	    repeat(2) @(posedge clk);   // wait some time
		
		for(i=0; i<14; i=i+1) begin
		    seq_in = test_vect[i];
			@(posedge clk);
		end
		
		for(i=0; i<15; i=i+1) begin
		    seq_in = $random;
			@(posedge clk);
		end
		
		// Enable the semaphore again
	    repeat(10) @(posedge clk); 
        @(posedge clk);

	    #40 $stop;
	end   
    
endmodule
