

module hex_7seg_decoder(
    input  [3:0]in,
    output reg a,
	output reg b,
    output reg c,
    output reg d,
    output reg e,
    output reg f,
    output reg g,
    output dot
    );
	
	// Use concatenation to pass values to all
	// outputs in the same time
	always @(*) begin
		case (in)
		4'd0 : {a,b,c,d,e,f,g} = 7'b1111110;
		4'd1 : {a,b,c,d,e,f,g} = 7'b0110000;
		4'd2 : {a,b,c,d,e,f,g} = 7'b1101101; 
		4'd3 : {a,b,c,d,e,f,g} = 7'b1111001;
		4'd4 : {a,b,c,d,e,f,g} = 7'b0110011;
		4'd5 : {a,b,c,d,e,f,g} = 7'b1011011;  
		4'd6 : {a,b,c,d,e,f,g} = 7'b1011111;
		4'd7 : {a,b,c,d,e,f,g} = 7'b1110000;
		4'd8 : {a,b,c,d,e,f,g} = 7'b1111111;
		4'd9 : {a,b,c,d,e,f,g} = 7'b1111011;
		4'd10: {a,b,c,d,e,f,g} = 7'b1110111; 
		4'd11: {a,b,c,d,e,f,g} = 7'b0011111;
		4'd12: {a,b,c,d,e,f,g} = 7'b1001110;
		4'd13: {a,b,c,d,e,f,g} = 7'b0111101;
		4'd14: {a,b,c,d,e,f,g} = 7'b1001111;
		4'd15: {a,b,c,d,e,f,g} = 7'b1000111;
	    endcase
    end
	
    // If you want the dot open assign 1 to it
	// ptherwise 0
    assign dot = 1'b1;

endmodule


`timescale 1us/1ns

module tb_hex_7seg_decoder();
	
	// Testbench variables
    reg  [3:0]in;
    wire a, b, c, d, e, f, g;
    wire dot;
    integer i; 
	
    // Instantiate the DUT 
	hex_7seg_decoder DEC_7SEG(
		.in(in),
		.a(a),
		.b(b),
		.c(c),
		.d(d),
		.e(e),
		.f(f),
		.g(g),
		.dot(dot)
		);
  
    // Create stimulus
    initial begin
        $monitor($time, " in = %d, seven_seg_code = %7b dot = %1b", 
                 in, {a, b, c, d, e, f, g}, dot);
        #1; in = 0;
        for (i = 0; i<16; i=i+1) begin
            #1; in = i;
        end
    end
  
endmodule