module full_adder_dataflow(
    input a,     // always wire
    input b,
	input carry_in,
    output sum,  // default wire but can be changed to reg
    output carry_out
    );
  
    // Declare nets to connect the half adders
    wire sum1;
    wire and1;
    wire and2;	
	
	// Implement the circuit using Dataflow style
    assign sum1 = a ^ b;
    assign and1 = sum1 & carry_in;
    assign and2 = a & b;
    
    assign sum  = sum1 ^ carry_in;
    assign carry_out  = and1 | and2;
  
endmodule


module testbench();
  
    // Declare variables and nets for module ports
    reg a;
    reg b;
    reg cin;
    wire sum;
    wire cout;  
  
    // Instantiate the module
    full_adder_dataflow FULL_ADD(
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
  
    initial begin
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