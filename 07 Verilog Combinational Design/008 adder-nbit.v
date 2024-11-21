
module adder_nbit 
    // Parameters section
    #( parameter N = 3)
    // Ports section
    (input [N-1:0] a,
     input [N-1:0] b,
     output reg [N:0] sum);
    
    // Wildcard operator is best for the procedure's
    // sensitivity list (control list)
    always @(*) begin
       sum[N:0] = a[N-1:0] + b[N-1:0];
       //sum = a + b;
    end  
  
endmodule


`timescale 1us/1ns
module tb_adder_nbit();
	
    parameter ADDER_WIDTH = 10;
    reg  [ADDER_WIDTH-1:0] a;
    reg  [ADDER_WIDTH-1:0] b;
    wire [ADDER_WIDTH:0] sum;
	
    // Instantiate the parameterized DUT
    adder_nbit 
    #(.N(ADDER_WIDTH))
    ADDER1
    (
        .a(a),
        .b(b),
        .sum(sum)      
    );
  
    // Create stimulus
    initial begin
        $monitor($time, " a = %d, b = %d, sum = %d", a, b, sum);
        #1; a = 0  ; b = 0  ;
        #2; a = 1  ; b = 99 ;
        #1; a = 33 ; b = 66 ;
        #1; a = 100; b = 47 ;
		#1; $stop;
    end
  
endmodule