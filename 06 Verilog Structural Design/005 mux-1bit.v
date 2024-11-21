
module mux_1bit(
   input a,
   input b,
   input x,
   output y
   );
  
   wire not_x;
   wire bit1;
   wire bit2;
  
   not  not1  (not_x, x);
   and  and1  (bit1, a, not_x);
   and  and2  (bit2, b, x);
   or   or1   (y, bit1, bit2);
  
endmodule

