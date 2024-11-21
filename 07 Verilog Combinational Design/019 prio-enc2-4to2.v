module prio_enc2_4to2
  (input [3:0] d,
   output reg [1:0] q,
   output reg v
  );
  
    always @(*) begin
        case (1) // checks if a signal is set
            d[3]:  begin q = 2'd3; v = 1; end
            d[2]:  begin q = 2'd2; v = 1; end
            d[1]:  begin q = 2'd1; v = 1; end
            d[0]:  begin q = 2'd0; v = 1; end
            default: begin q = 2'd0; v = 0; end
        endcase
    end
  
endmodule


`timescale 1us/1ns
module tb_prio_enc2_4to2();
	
    reg [3:0] d;   // DUT variables
    wire v;
    wire [1:0] q;
    integer i;     // testbench variable

    // Instantiate the DUT 
    prio_enc2_4to2 PRENC(
      .d(d),
      .q(q),
      .v(v)
    );
  
    // Create stimulus
    initial begin
        $monitor($time, " d = %b, q = %d, v = %d", d, q, v);
        #1; d = 0; 
        for (i = 0; i<4; i=i+1) begin
           #1; d = (1 << i);
        end
        #1; d = 4'b1111;
        #1; d = 4'b1001;
        #1; d = 4'b0101;
		#1; d = 4'b0000;
		#1; $stop;
    end
  
endmodule
