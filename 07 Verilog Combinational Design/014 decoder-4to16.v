
module decoder_3to8 
    (input [2:0] a,
     input enable,
     output reg [7:0] y
    );
 
    //Whenever there is a change in the bus 'a' or 'enable' -> execute the always block.
    always @(a or enable) begin  // wildcard '*' could also be used
        if (enable == 0)
           y = 8'b0;
        else begin
            case (a)   //case statement. Check all the 8 combinations.
                3'b000 : y = 8'b00000001;
                3'b001 : y = 8'b00000010;
                3'b010 : y = 8'b00000100;
                3'b011 : y = 8'b00001000;
                3'b100 : y = 8'b00010000;
                3'b101 : y = 8'b00100000;
                3'b110 : y = 8'b01000000;
                3'b111 : y = 8'b10000000;
                //PRO Tip: create a default value for output to prevent latch creation
                //You should always use a default even if all the combinations are covered (full case)
                default : y = 8'b00000000;
            endcase
        end
    end
  
endmodule


module decoder_4to16 
  (input [3:0] a,
   output[15:0] d
  );
 
    decoder_3to8 DEC1 (
        .a(a[2:0]),
        .enable(~a[3]),
        .y(d[7:0])
    );
  
    decoder_3to8 DEC2 (
        .a(a[2:0]),
        .enable(a[3]),
        .y(d[15:8])
    );
  
endmodule


`timescale 1us/1ns
module tb_decoder_4to16();
	
   reg [3:0] a;
   wire  [15:0] d;
   integer i;
   
    // Instantiate the DUT
    decoder_4to16 DEC4_16 (
      .a(a),
      .d(d)
    );
  
    // Create stimulus
    initial begin
        $monitor($time, " a = %d, d = %b", a, d);
        #1; a = 0;
        for (i = 0; i<16; i=i+1) begin
            #1; a = i;
        end
    end
  
endmodule
