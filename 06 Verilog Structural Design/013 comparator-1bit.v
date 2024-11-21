
module comparator_1bit(
    input a,
    input b,
    output smaller,
    output equal,
    output greater
    );
  
  wire not_a;
  wire not_b;
  
  not NOT1 (not_a, a);
  not NOT2 (not_b, b);
  
  and  AND1  (smaller, b, not_a);
  xnor NXOR1 (equal, a, b);
  and  AND2  (greater, a, not_b);

endmodule


`timescale 1us/1ns
module tb_comp(
    // no inputs here ;)
    );
	
    reg a, b;
    wire smaller, greater, equal;
	
    // Instantiate the DUT
    comparator_1bit CMP1(
      .a(a),
      .b(b),
      .smaller(smaller),
      .equal(equal),
      .greater(greater)
    );
   
    initial begin
       $monitor(" a = %b, b = %b, smaller = %b, equal = %b, greater = %b",
				  a, b, smaller, equal, greater);
       #1; a = 0; b = 0;
       #1; a = 1; b = 0;
       #1; a = 1; b = 0;
       #1; a = 0; b = 1;
       #1; a = 1; b = 1;      
       #1; $stop;
    end
  
endmodule