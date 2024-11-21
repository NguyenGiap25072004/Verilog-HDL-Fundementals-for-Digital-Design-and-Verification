
module ALU
    // Parameters section
    #( parameter BUS_WIDTH = 8)
    // Ports section
    (input [BUS_WIDTH-1:0] a,
     input [BUS_WIDTH-1:0] b,
     input carry_in,
     input [3:0] opcode,
     output reg [BUS_WIDTH-1:0] y,
     output reg carry_out,
     output reg borrow,
     output zero,
     output parity,
     output reg invalid_op
    );
  
    // Define a list of opcodes
    localparam OP_ADD       = 1; // A + B
    localparam OP_ADD_CARRY = 2; // A + B + Carry
    localparam OP_SUB = 3;       // Subtract B from A
    localparam OP_INC = 4;       // Increment A
    localparam OP_DEC = 5;       // Decrement A
    localparam OP_AND = 6;       // Bitwise AND
    localparam OP_NOT = 7;       // Bitwise NOT
    localparam OP_ROL = 8;       // Rotate Left
    localparam OP_ROR = 9;       // Rotate Right  
  
    always @(*) begin
        y = 0; carry_out = 0; borrow = 0; invalid_op = 0;
        case (opcode)
            OP_ADD        :  begin y = a + b; end
            OP_ADD_CARRY  :  begin {carry_out, y} = a + b + carry_in; end
            OP_SUB        :  begin {borrow, y} = a - b; end
            OP_INC        :  begin {carry_out, y} = a + 1'b1; end
            OP_DEC        :  begin {borrow, y} = a - 1'b1; end
            OP_AND        :  begin y = a & b; end
            OP_NOT        :  begin y = ~a; end
            OP_ROL        :  begin y = {a[BUS_WIDTH-2:0], a[BUS_WIDTH-1]}; end
            OP_ROR        :  begin y = {a[0], a[BUS_WIDTH-1:1]}; end
            default: begin invalid_op = 1; y = 0; carry_out = 0; borrow = 0;  end
        endcase
    end
  
    assign parity = ^y;
    assign zero = (y == 0);
endmodule




`timescale 1us/1ns

module tb_ALU();
	
	// Testbench variables
    parameter BUS_WIDTH = 8;
    reg  [3:0] opcode;
    reg [BUS_WIDTH-1:0] a, b;
    reg carry_in;
    wire [BUS_WIDTH-1:0] y;
    wire carry_out;
    wire borrow;
    wire zero;
    wire parity;
    wire invalid_op;

    // Instantiate the DUT 
    ALU
    // Parameters section
    #(.BUS_WIDTH(BUS_WIDTH))
    ALU0
   (.a(a),
   .b(b),
   .carry_in(carry_in),
   .opcode(opcode),
   .y(y),
   .carry_out(carry_out),
   .borrow(borrow),
   .zero(zero),
   .parity,
   .invalid_op(invalid_op)
    );
  
    // Create stimulus
    initial begin
        $monitor($time, " opcode = %d, a = %d, b = %d, y = %d, carry_out=%b, borrow=%b, zero=%b, parity=%b, invalid_op=%b", 
	                  opcode, a, b, y, carry_out, borrow, zero, parity, invalid_op);
        #1; opcode = 0; // 
        // Test OP_ADD
        #1 opcode = 1; a = 9; b = 33; carry_in = 0; 
        // Test OP_ADD_CARRY
        #1 opcode = 2; a = 9; b = 33; carry_in = 1; 
        // Test OP_SUB
        #1 opcode = 3; a = 65; b = 64; carry_in = 0; 
        #1 opcode = 3; a = 65; b = 66; carry_in = 0; 
        // Test OP_INC
        #1 opcode = 4; a = 233; b = 69; carry_in = 1; 
        // Test OP_DEC
        #1 opcode = 5; a = 0; b = 3; carry_in = 0; 
        // Test OP_AND
        #1 opcode = 6; a = 8'b0000_0010; b = 8'b0000_0011; 
        // Test OP_NOT
        #1 opcode = 7; a = 8'b1111_1111;  
        // Test OP_ROL
        #1 opcode = 8; a = 8'b0000_0001; 
        // Test OP_ROR
        #1 opcode = 9; a = 8'b1000_0000;
        #1 $stop;
    end
  
endmodule 
