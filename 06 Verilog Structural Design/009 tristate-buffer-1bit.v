module tristate_buffer_1bit(
    input din,
    input sel,
    output dout
    );
  
    bufif1 B1 (dout, din, sel);
  
endmodule