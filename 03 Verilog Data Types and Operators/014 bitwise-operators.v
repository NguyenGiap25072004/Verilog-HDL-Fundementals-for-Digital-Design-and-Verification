
module bitwise_operators(
    // no inputs here 
    );
	
  	reg [5:0] x = 0;        // 6bit variable
 	reg [5:0] y = 0;        // 6bit variable
    reg [5:0] result = 0;   // 6bit variable
	
	// Procedure used to continuously monitor 'x', 'y', and 'result'
	initial begin
      $monitor("MON x=%b, y=%b, result=%b", x, y, result);
	end
	
	// Procedure used to generate stimulus
	initial begin
        #1;  // wait some time between examples
        x = 6'b00_0101;
	    y = 6'b11_0001;
        result = x & y; // AND
       
        #1;  // Use the same values for x and y from above (reg stores the value)
        result = ~(x & y); // NAND Try: x ~& y to see what happens
	    
        #1;
        x = 6'b10_0101;
	    y = 6'b01_1011;
        result = x | y; // OR
	    
        #1; 
        result = ~(x | y); // NOR Try: x ~| y to see what happens
	    
        #1;
        x = 6'b01_0110;
	    y = 6'b01_1011;
        result = x ^ y; // XOR
	    
        #1; // NXOR is used to check if x = y
        result = x ~^ y; // NXOR
	    
        #1
        x = y; // This should make all bits 1
        result = ~(x ^ y); // NXOR
	end

endmodule

