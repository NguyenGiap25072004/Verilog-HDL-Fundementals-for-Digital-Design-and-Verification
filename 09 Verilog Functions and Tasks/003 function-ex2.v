
`timescale 1us/1ns
module func_ex2 ();

    // This function compares two integer numbers and outputs if they are equal
	// The result is either 0 (False) or 1 (True)
	function compare (input integer a, input integer b);
	    begin
		    compare = (a == b);
		end	
	endfunction
	
	// Variables used for stimulus
    integer a, b;
	
	initial begin
	    $monitor ($time, " a = %d, b = %d, compare = %d", a, b, compare(a,b));
		#1 a = 1  ; b = 9;
		#1 a = 99 ; b = 99;
		#1 a = 400; b = 101;
		#1 a = -134; b = -134;		
	end
  
endmodule