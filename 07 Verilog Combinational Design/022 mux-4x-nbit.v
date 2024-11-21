module mux_4x_nbit
    // Parameters section
  #( parameter BUS_WIDTH = 8)
    // Ports section
  (input [BUS_WIDTH-1:0] a,
   input [BUS_WIDTH-1:0] b,
   input [BUS_WIDTH-1:0] c,
   input [BUS_WIDTH-1:0] d,
   input [1:0] sel,
   output reg [BUS_WIDTH-1:0] y
  );
  
  always @(*) begin
    case (sel)
        2'd0 :  begin y = a; end
        2'd1 :  begin y = b; end
        2'd2 :  begin y = c; end
        2'd3 :  begin y = d; end
        default: begin y = a; end
    endcase
  end
  
endmodule


`timescale 1us/1ns
module tb_mux_4x_nbit(
    // no inputs here ;)
    );
	
   parameter BUS_WIDTH = 8;
   reg [BUS_WIDTH-1:0] a;
   reg [BUS_WIDTH-1:0] b;
   reg [BUS_WIDTH-1:0] c;
   reg [BUS_WIDTH-1:0] d;
   reg [1:0] sel;
   wire [BUS_WIDTH-1:0] y;
   integer i;


    // Instantiate the DUT 
    mux_4x_nbit
        #(.BUS_WIDTH(BUS_WIDTH))
        MUX0 (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .y(y)
    );
  
    // Create stimulus
    initial begin
        $monitor($time, " a = %d, b = %d, c = %d, d = %d, sel = %d, y = %d", 
                 a, b, c, d, sel, y);
        #1; sel = 0; a = 0; b = 0; c = 0; d = 0;
        for (i = 0; i<8; i=i+1) begin
            #1; sel = $urandom%4; a = $urandom; b = $urandom; c = $urandom; d = $urandom;
        end
    end
  
endmodule