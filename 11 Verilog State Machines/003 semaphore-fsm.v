
module semaphore_fsm(
        input clk,
		input rst_n,
		input enable,
		output reg red,
		output reg yellow,
		output reg green,
		output [3:0] state_out // used for debug
        );
    
	// Declare the state values as parameters using ONE-HOT encoding
	parameter [3:0] OFF    = 4'b0001,
	                RED    = 4'b0010,
					YELLOW = 4'b0100,
					GREEN  = 4'b1000;
					
	// Declare the logic for the state machine
	reg [3:0] state;      // the sequential part
	reg [3:0] next_state; // the combinational part
	
	reg [5:0] timer;       // the counter that keeps the gate open
    reg       timer_clear; // when set is resets the timer value
	
	// Next state logic
	always @(*) begin
	    next_state  = OFF;     // default values
		red         = 0;
		yellow      = 0;
		green       = 0;
		timer_clear = 0;
	    case (state)
		    OFF           : begin
			                    if (enable) next_state = RED;
							end
		    RED           : begin
								red = 1;
								if (timer == 6'd50) begin
									next_state  = YELLOW;
									timer_clear = 1;
								end else begin
									next_state = RED;
								end
							end
		    YELLOW         : begin
								yellow = 1;
								if (timer == 6'd10) begin
									next_state = GREEN;
									timer_clear = 1;
								end else begin
									next_state = YELLOW;
								end
							end
		    GREEN         : begin
								green = 1;
								if (timer == 6'd30) begin
									next_state = RED;
									timer_clear = 1;
								end else begin
									next_state = GREEN;
								end 
							end 							
		    default: next_state = OFF; // best practice
		endcase
		
		// Return from any state to OFF if enable == 0
		if (!enable) begin
		    next_state = OFF;
		end
	end
	
	// State sequencer logic
	always @(posedge clk or negedge rst_n) begin
	    if(!rst_n)
		    state <= OFF;
	    else
		    state <= next_state;
	end
	
	assign state_out = state; // connect with output port
	
	// Timer logic
	always @(posedge clk or negedge rst_n) begin
	    if(!rst_n)
		    timer <= 6'd0;
	    else if ((timer_clear == 1) || (!enable))
		    timer <= 6'd0;
	    else if (state != OFF)  // increment timer if state != OFF
		    timer <= timer + 1'b1; 
	end
	
endmodule


`timescale 1us/1ns
module tb_semaphore_fsm();

    reg clk = 0;
	reg rst_n;
	reg enable;
	wire red    ;
	wire yellow ;
	wire green  ;
	wire [3:0] state_out;

    // Parameters used for testbench flow
	parameter [3:0] OFF    = 4'b0001,
	                RED    = 4'b0010,
					YELLOW = 4'b0100,
					GREEN  = 4'b1000;

    // Instantiate the module
    semaphore_fsm SEM0(
        .clk      (clk      ),
		.rst_n    (rst_n    ),
		.enable   (enable   ),
		.red      (red      ),
		.yellow   (yellow   ),
		.green    (green    ),
		.state_out(state_out) // used for debug
        );
	
    initial begin // Create the clock signal
        forever begin 
		    #1 clk = ~clk;
	    end
    end

    initial begin
	    $monitor($time, " enable = %b, red = %b, yellow = %b, green = %b", 
		                enable, red, yellow, green);
		
	    rst_n = 0; #2.5; rst_n = 1;   // reset sequence
		enable = 0;
	    repeat(10) @(posedge clk);  // wait some time
		enable = 1;
         
		// Let the semaphore cycle 2 times
	    repeat(2) begin 
		    wait (state_out === GREEN);
			@(state_out); // wait for GREEN to be over
	    end
		
	    // Disable the semaphore during Yellow state
	    wait (state_out === YELLOW);
        @(posedge clk); enable = 0;
		
		// Enable the semaphore again
	    repeat(10) @(posedge clk); 
        @(posedge clk); enable = 1; 

	    #40 $stop;
	end   
    
endmodule
