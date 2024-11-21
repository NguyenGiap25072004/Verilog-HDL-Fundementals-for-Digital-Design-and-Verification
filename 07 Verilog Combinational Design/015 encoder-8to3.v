
module encoder_8to3(
    input [7:0] d,
    input enable,
    output reg [2:0] y
    );
 
    always @(*) begin
        if (enable == 0)
           y = 8'b0;
        else begin
            case (d)   //case statement. Check all the 8 valid combinations
                8'b00000001 : y = 3'd0; // 8 out of 256 combinations used
                8'b00000010 : y = 3'd1;
                8'b00000100 : y = 3'd2;
                8'b00001000 : y = 3'd3;
                8'b00010000 : y = 3'd4;
                8'b00100000 : y = 3'd5;
                8'b01000000 : y = 3'd6;
                8'b10000000 : y = 3'd7;
                //PRO Tip: create a default value for output to prevent latch creation
                //You should always use a default even if all the combinations are covered (full case)
                default : y = 3'd0; 
            endcase
        end
    end
  
endmodule



`timescale 1us/1ns
module tb_encoder_8to3();
	
    reg [7:0] d;
    reg enable;
    wire  [2:0] y;
	
	integer i;

    // Instantiate the DUT
    encoder_8to3 ENC3_8 (
        .d     (d     ),
        .enable(enable),
        .y     (y     )
    );
  
    // Create stimulus
    initial begin
        $monitor($time, " d = %b, y = %d", d, y);
        #1; d = 0; enable = 0;
        for (i = 0; i<8; i=i+1) begin
            #1; d = (1 << i); enable = 1;
        end
        #1; d = 8'b1111_1111;
    end
  
endmodule