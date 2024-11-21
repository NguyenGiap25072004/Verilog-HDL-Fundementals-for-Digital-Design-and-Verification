
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
    reg a;
    reg b;
    reg cin;
    wire sum;
    wire cout;  
  
    // Instantiate the module
    full_adder_structural FULL_ADD(
        .a(a),
        .b(b),
        .carry_in(cin),
        .sum(sum),
        .carry_out(cout)
        );
  
    // Generate stimulus and monitor module ports
    initial begin
      $monitor("a=%b, b=%b, carry_in=%0b, sum=%b, carry_out=%b", a, b, cin, sum, cout);
    end  
  
    initial begin // the same data as in the truth table
        #1; a = 0; b = 0; cin = 0;
        #1; a = 0; b = 0; cin = 1;
        #1; a = 0; b = 1; cin = 0;
        #1; a = 0; b = 1; cin = 1;
        #1; a = 1; b = 0; cin = 0;
        #1; a = 1; b = 0; cin = 1;
        #1; a = 1; b = 1; cin = 0;
        #1; a = 1; b = 1; cin = 1;
    end
  
endmodule