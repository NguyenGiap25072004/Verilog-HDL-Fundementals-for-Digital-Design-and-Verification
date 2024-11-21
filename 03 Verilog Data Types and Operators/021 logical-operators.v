
module logical_operators();
  
    reg [2:0] my_val1 = 3'b111;   // 3bit variable
    reg [3:0] my_val2 = 4'b0000;  // 4bit variable
    reg result;                   // 1bit variable
  
    // Procedure used to continuously monitor 'my_val1', 'my_val2', and 'result'
	initial begin
      $monitor("MON my_val1=%b, my_val2=%b, result=%b", my_val1, my_val2, result);
	end
  		
	// Procedure used to generate stimulus
	initial begin
        result = !my_val1;   // Logical NOT
        #1;                  // wait some time between examples
        result = !my_val2;   // Logical NOT
        
        #1;
        result = my_val1 && my_val2; // Logical AND
        
        #1;
        result = my_val1 || my_val2;
      
        #1;
        my_val1 = 3'bz0X; // Add some unknown bits
        result  = !my_val1;
      
        #1;
        result = my_val1 || my_val2;
      
        #1;
        result = my_val1 && my_val2;
      
        // Change the values of my_val1/2 and perform some logical operations
        // Ex: my_val2 = 4'b0101
        //     result = my_val1 && my_val2
        //     $display("MON my_val1=%b, my_val2=%b, result=%b", my_val1, my_val2, result);
	end
  
endmodule

