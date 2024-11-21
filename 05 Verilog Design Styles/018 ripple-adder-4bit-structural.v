module ripple_adder_4bit_structural(
    input [3:0]a,
    input [3:0]b,
	input carry_in,
    output [3:0] sum,  
    output carry_out
    );
    
    // Internal nets used to connect all 4 modules
    wire [2:0] c;
    
    // Instantiate 4 Structural adders
    full_adder_structural FA_STRUCT_0(
       .a(a[0]), 
       .b(b[0]),
       .carry_in(carry_in),
       .sum(sum[0]),  
       .carry_out(c[0])
    );
    
    full_adder_structural FA_STRUCT_1(
       .a(a[1]), 
       .b(b[1]),
       .carry_in(c[0]),
       .sum(sum[1]),  
       .carry_out(c[1])
    );
  
    full_adder_structural FA_STRUCT_2(
       .a(a[2]), 
       .b(b[2]),
       .carry_in(c[1]),
       .sum(sum[2]),  
       .carry_out(c[2])
    );
  
    full_adder_structural FA_STRUCT_3(
       .a(a[3]), 
       .b(b[3]),
       .carry_in(c[2]),
       .sum(sum[3]),  
       .carry_out(carry_out)
    );
  
endmodule



module full_adder_structural(
    input a, 
    input b,
	input carry_in,
    output sum, 
    output carry_out
    );
  
    // Declare nets to connect the half adders
    wire sum1;
    wire carry1;
    wire carry2;
	
    // Instantiate two half_adder_structural modules
    half_adder_structural HA1(
       .a(a),
       .b(b),
       .sum(sum1),
       .carry(carry1)
    ); 
	
	half_adder_structural HA2(
       .a(sum1),
       .b(carry_in),
       .sum(sum),
       .carry(carry2)
    );
	
	// Use Verilog primitive
	or (carry_out, carry1, carry2);
  
endmodule



module half_adder_structural(
    input a,
    input b,
    output sum,
    output carry
    );
  
    // Instantiate Verilog built-in primitives and connect them with nets
    xor XOR1 (sum,  a, b); // instantiate a XOR gate
    and AND1 (carry, a, b);  
  
endmodule



module testbench();
  
    // Declare variables and nets for module ports
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire [3:0]sum;
    wire cout; 
  
    integer i, j; // used for verification
    
    // Instantiate the module
    ripple_adder_4bit_structural RIPPLE_ADD_4BIT(
        .a(a),
        .b(b),
        .carry_in(cin),
        .sum(sum),
        .carry_out(cout)
        );
  
    // Generate stimulus and monitor module ports
    initial begin
      $monitor("a=%b, b=%b, carry_in=%0b, sum=%0d, carry_out=%b", a, b, cin, sum, cout);
    end  
  
    initial begin
        #1; a = 4'b0000; b = 4'b0000; cin = 0;
        #1; a = 4'b0000; b = 4'b0000; cin = 1;
        #1; a = 4'b0001; b = 4'b0001; cin = 0;
        #1; a = 4'b0001; b = 4'b0001; cin = 1;
        #1; a = 4'd3;    b = 4'd6;    cin = 0;
        // Change the values of a and b and observe the effects
      
        for (i=0; i<2; i=i+1) begin
            for (j=0; j<2; j=j+1) begin
                #1 a = i; b = j; cin = 0;
            end
        end
        // Change the loops limits observe the effects

    end
  
endmodule


