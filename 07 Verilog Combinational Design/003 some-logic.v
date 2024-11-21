
module some_logic (
   input a,
   input b,
   output c
   );
  
   // Declare internal nets
   wire a_not;
   wire a_or_b;
  
   // The order of the assignments in NOT important
   assign c = a_or_b | (a_or_b & a_not);
   assign a_not = ~a;
   assign a_or_b = a | b;
  
endmodule


`timescale 1us/1ns
module tb_logic(
    // no inputs here ;)
    );
	
    reg a;
    reg b;
    wire c;
	
    // Instantiate the DUT
    some_logic LOGIC(
       .a(a),
       .b(b),
       .c(c)
    );

    // Toggle a and b
    initial begin
        $monitor(" a = %b, b = %b, c = %b",a ,b ,c);
        #1; a = 0; b = 0;
        #1; a = 1; b = 0;
        #1; a = 0; b = 1;
        #1; a = 1; b = 1;
        #1;
    end
  
endmodule