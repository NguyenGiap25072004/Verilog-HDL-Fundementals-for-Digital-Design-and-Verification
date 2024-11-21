module fsm_template(
        // add I/O ports here
        );
    
	// Declare the state values as parameters
	parameter [WIDTH-1:0] STATE1 = value_1,
	                      STATE2 = value_2,
						  ....
					      STATEn = valuen;					
					
	// Declare the logic for the state machine
	reg [WIDTH-1:0] state, next_state;	
	    
	// Next state logic
	always @(*) begin
	    next_state  = STATE1;     // default values
		out_signal1 = 0;    // default values for outputs
	    case (state)
		    STATE1         : begin
			                    ...
							end
		    STATE2         : begin
			                    ...
							end 
		    ...
		    default: next_state = STATE1; // best practice
		endcase
	end
	
	// State sequencer logic
	always @(posedge clk or negedge rst_n) begin
	    if(!rst_n)
		    state <= STATE1;
	    else
		    state <= next_state;
	end
	
	
endmodule
