
module adders3_procedural(
   input [3:0] a,
   input [3:0] b,
   input [7:0] c,
   input [7:0] d,
   output reg [4:0] sum1,
   output reg [8:0] sum2,
   output reg [9:0] sum3
);
  
    // The order of the assignments in NOT important  
    always @(a or b) begin
        sum1 = a+b;
    end
    
    always @(c or d) begin
        sum2 = c + d;
    end
    
    // Best practice control list
    // Any change in RHS propagates to LHS
    always @(*) begin
        sum3 = sum1 + sum2;
    end 
    
    /*
    always @(*) begin
        sum3 = a + b + c + d;
    end  */
  
endmodule



`timescale 1us/1ns

module tb_adders3_proc(
    // no inputs here ;)
    );
	
   reg [3:0] a, b;
   reg [7:0] c, d;
   wire [4:0] sum1;
   wire [8:0] sum2;
   wire [9:0] sum3;

    // Instantiate the DUT
    adders3_procedural ADD3(
      .a(a),
      .b(b),
      .c(c),
      .d(d),
      .sum1(sum1),
      .sum2(sum2),
      .sum3(sum3)      
    );
   
    // Create stimulus
    initial begin
      $monitor(" a = %d, b = %d, c = %d, d = %d, sum1 = %d, sum2 = %d, sum3 = %d",
                 a ,b ,c, d, sum1, sum2, sum3);
       #1; a = 4'd0  ; b = 4'd3  ; c = 8'd1 ; d = 8'd255 ;
       #1; a = 4'd10 ; b = 4'd13 ; c = 8'd9 ; d = 8'd10 ;
       #1; a = 4'd15 ; b = 4'd15 ; c = 8'd109 ; d = 8'd37 ;
       #1; a = 4'd0  ; b = 4'd9  ; c = 8'd45 ; d = 8'd45 ;
       #1;
    end
  
endmodule