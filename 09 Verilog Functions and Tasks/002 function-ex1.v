
`timescale 1us/1ns
module func_ex1 ();

    // This function returns the sum of 2 x 8bit numbers
	// An internal variable with the same name as the function is
	// created inside it and is used for returning the value
	function [8:0] sum (input [7:0] a, input [7:0] b);
	    begin
		    sum = a + b;
		end	
	endfunction
	
	// Variables used for stimulus
    reg [7:0] a, b;
	
	initial begin
	    $monitor ($time, " a = %d, b = %d, sum = %d", a, b, sum(a,b));
		#1 a = 1  ; b = 9;
		#1 a = 13 ; b = 66;
		#1 a = 255; b = 1;
		#1 a = 255; b = 255;
	end
  
endmodule