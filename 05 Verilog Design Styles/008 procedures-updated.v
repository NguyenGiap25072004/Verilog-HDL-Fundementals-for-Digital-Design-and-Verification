
`timescale 1us/1ns

module procedures();
    
    reg [7:0] var1;
    reg [7:0] var2;
    wire [8:0] sum;
    reg [15:0] product;
    
    // All the procedures below are executed in parallel
  
    // Continuous assignment (Dataflow Style)
    assign sum = var1 + var2;
   
    // Behavioral Style - controlled by the change of var1 or var2
    always @(var1 or var2) begin
        product = var1 * var2;
    end

    // Behavioral Style - controlled by the change of var1 or var2
    always @(var1) begin
       $display($time, " MON_VAR1: var1 = %0d", var1); // var1 = 22
    end

    // Behavioral Style - controlled by the change of var1, var2, sum, product
  	always @(*) begin
        $display($time, " MON_ALL: var1 = %0d, var2 = %0d, sum = %0d, product = %0d", 
		         var1, var2, sum, product);
  	end
  
    // Behavioral Style - Generate stimulus 
    initial begin
        #1; var1 = 10; var2 = 99;
        #1; var2 = 33; 
        #1; var1 = var2 << 2;
        #1; var2 = var2 >> 3;
        #1; var2 = var2 + 1;
      
       // Change the value of var1/2 to see what happens
    end
  
endmodule