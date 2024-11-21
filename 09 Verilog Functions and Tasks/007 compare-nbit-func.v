
`timescale 1us/1ns

module compare_nbit_func
    // Parameters section
    #( parameter CMP_WIDTH = 4)
    // Ports section
    (input [CMP_WIDTH-1:0] a,
     input [CMP_WIDTH-1:0] b,
	 output reg greater,
	 output reg equal,
	 output reg smaller);
  
    // Synthesizable functions area (parameterized)
	// All 3 bits are combined into a single output
    function [2:0] compare (input [CMP_WIDTH-1:0] a, input [CMP_WIDTH-1:0] b);
	    // Local variables
	    reg greater_local;
		reg equal_local;
	    reg smaller_local;
		
	    begin // The actual computation from the function
		    greater_local = (a>b);
		    equal_local   = (a==b);
	        smaller_local = (a<b);
			compare = {greater_local, equal_local, smaller_local};
		end	
	endfunction

    // The RTL description of the combinational comp	
    always @(*) begin
	    {greater, equal, smaller} = compare(a,b);
	end
	
endmodule


`timescale 1us/1ns
module tb_compare_nbit_func();
   
    // Testbench variables
    parameter CMP_WIDTH = 5;
	reg [CMP_WIDTH-1:0] a, b;
	wire greater, equal, smaller;
	
    // Instantiate the DUT
    compare_nbit_func
      #(.CMP_WIDTH(CMP_WIDTH))
	  CMP0
      (.a      (a      ),
       .b      (b      ),
	   .greater(greater),
	   .equal  (equal  ),
	   .smaller(smaller));
	
	initial begin
	       $monitor ($time, " a = %d, b = %d, greater = %b, equal = %b, smaller = %b", 
		                    a, b, greater, equal, smaller);
	    #1 a = 3; b = 2;
		#1 b = 3;
		#1 a = 9; b = 11;
	end
  
endmodule
