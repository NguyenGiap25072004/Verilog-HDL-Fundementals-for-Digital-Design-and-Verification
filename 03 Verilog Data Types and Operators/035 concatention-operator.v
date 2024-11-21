
module concatenation_operator();
  
    reg [7:0] a;
    reg [3:0] upper_nibble;
    reg [3:0] lower_nibble;

	// Procedure used to generate stimulus
	initial begin
      #1; a = {4'b1110, 4'b0001}; 
      $display("a = %b", a);

      #1; a = {3'b000, 2'b11, 3'b000}; 
      $display("a = %b", a);

      #1; a = {1'b1, 2'b00, 2'b01, 3'b010}; 
      $display("a = %b", a);
      
      // left shift 'a' and concatenate LSB with 1
      #1; a = {a << 1, 1'b1}; 
      $display("a = %b", a);
      
      #1; {upper_nibble, lower_nibble} = a;
      $display("upper_nibble = %b, lower_nibble = %b", upper_nibble, lower_nibble);
      
      // Change values between nibbles
      #1; {upper_nibble, lower_nibble} = {lower_nibble, upper_nibble};
      $display("upper_nibble = %b, lower_nibble = %b", upper_nibble, lower_nibble);
      
      #1; a ={upper_nibble, lower_nibble};
      $display("a = %b", a);
      
      // Concatenate some bit fields into a
	end
  
endmodule

