
module literal_values();
   
    reg [7:0] my_var;
    
    // All the assignments are grouped in an 'initial' procedure
    initial begin
        my_var = 8'd137;             // 137 in decimal
        $display("my_var = %d", my_var);
	   
        #2 my_var = 8'h89;              // 137 in hexadecimal
        $display("my_var = %x", my_var);
	   
        #2 my_var = 8'b1000_1001;       // 137 in binary
        $display("my_var = %b", my_var);
	   
        #2 my_var = 8'o211;             // 137 in octal
        $display("my_var = %o", my_var);
	   
        #2 my_var = 8'hZ1;              // zzzz_0001
        $display("my_var = %b", my_var);
	   
        #2 my_var = 1'b1;               // 8bit variable gets 1 bit value
        $display("my_var = %b", my_var);
	   
        #2 my_var = 12'b1111_1111_0000; // 8 bit variable gets 12bit value
        $display("my_var = %b", my_var);
    end

endmodule

