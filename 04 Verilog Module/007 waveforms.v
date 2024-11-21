`timescale 1us/1ns

module waveforms(
    // no inputs here ;)
    );
	
    reg [1:0] sig1;
    reg       sig2;
		
	// Generate stimulus
	initial begin
	   sig1 = 0;
       #1;       // wait 1us    
       sig1[0] = 1'b1;
	   #2;
	   sig2 = 1'bz;
	   #3;
	   sig1[1] = 1'b1;
	   #2;
	   sig1 = 2'b10;
	   sig2 = 1'b1;
	   #7;
	   sig1[0] = 1'b1;
	   #6;
	   sig2 = ~sig2;
	   #4;
	end

endmodule
