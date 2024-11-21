
module operators_precedence();
  
  reg [3:0] a;
  integer b;
  
  initial begin
    #1; a = ~4'b1110 & |4'b1000; // unary executed before bit-wise
    // ~4'b1110 = 4'b0001, |4'b1000 = 1'b1, 4'b0001 & 1'b1 = 4'b0001
    $display("a = %b", a);
    
    #1; a = ~4'b1100 & |4'b1000; // unary executed before bit-wise
    // ~4'b1100 = 4'b0011, |4'b1000 = 1'b1, 4'b0011 & 1'b1 = 4'b0001
    $display("a = %b", a);
    
    #1; a = |4'b0100 & ~&4'b1011; // unary executed before bit-wise
    // |4'b0100 = 1'b1, ~&4'b1011 = 1'b1, 1'b1 & 1'b1 = 4'b0001
    $display("a = %b", a);
    // Best practice: (|4'b0100) & (~&4'b1011)
    
    #1; b = 2 * 5 << 2; // multiplication execute before shift
    // b = 10 << 2 = 40; * executes before <<
    $display("b = %0d", b);
    // Always use parenthesis b = (2 * 5) << 2 to make clear you intent
    // for you and for others
    
    #1; b = 2 < 4 && -33 > -34; // relational executed before logical
    // b = (2 < 4) && (-33 > -34) = 1 && 1 = 1
    $display("b = %0d", b);
    
    #1; b = 2 << 3 - 3; // arithmetic before shift
    // b = 2 << (3 - 3) = 2 << 0 = 2;
    $display("b = %0d", b);

    // Do some other examples to play with operators precedence
    
  end
  
endmodule