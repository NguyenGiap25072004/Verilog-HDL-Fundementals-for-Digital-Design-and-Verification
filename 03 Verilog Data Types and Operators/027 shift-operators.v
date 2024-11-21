
module shift_operators();
  
  reg [11:0] a = 12'b0101_1010_1101; // 12bit value (unsigned)
  reg [11:0] b ;
    
    // Procedure used to continuously monitor 'a', and 'b'
	initial begin
      $monitor("MON a = %12b, b = %12b, a = %0d, b = %0d", a, b, a, b);
	end
  
	// Procedure used to generate stimulus
	initial begin
        b = a << 1;  // b = a*2
        #1; // wait some time between examples
        b = 0;  
        
        #1; b = a * 2; // Write on 1 line to save space
        
        #1; b = a << 5;      
        #1; b = b >> 2;        
        #1; b = b >> 7;
        #1; b = b << 1;
        #1; b = (a << 1) >> 6; // always use paranthesys

        // Change the values of a and b and perform different logical shifts between them
        // Ex: a = a << 12
	end
  
endmodule

