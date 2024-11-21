
module comparator_nbit 
    // Parameters section
   #( parameter N = 4)
    // Ports section
   (input [N-1:0] a,
    input [N-1:0] b,
    output reg smaller,
    output reg equal,
    output reg greater
   );
  
    // Wildcard operator is best for the procedure's
    // sensitivity list (control list)
    always @(*) begin
        smaller = (a < b);
        equal   = (a == b);
        greater = (a > b);
    end  
  
endmodule



`timescale 1us/1ns
module tb_comparator_nbit();
	
    parameter CMP_WIDTH = 12;
    reg  [CMP_WIDTH-1:0] a;
    reg  [CMP_WIDTH-1:0] b;
    wire smaller;
    wire equal;
    wire greater;
	
    // Instantiate the parameterized DUT
    comparator_nbit 
    #(.N(CMP_WIDTH))
    CMP1
    (
        .a      (a      ),
        .b      (b      ),
        .smaller(smaller),
        .equal  (equal  ),
        .greater(greater)
    );
  
    // Create stimulus
    initial begin
        $monitor($time, " a = %d, b = %d, smaller = %d, equal = %d, greater = %d",
                        a, b, smaller, equal, greater);
        #1; a = 0  ; b = 0  ;
        #2; a = 5  ; b = 99 ;
        #1; a = 66 ; b = 66 ;
        #1; a = 100; b = 47 ;
		#1; $stop;
    end
  
endmodule