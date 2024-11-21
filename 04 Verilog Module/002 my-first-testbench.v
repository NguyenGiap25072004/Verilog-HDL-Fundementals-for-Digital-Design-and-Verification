
module my_first_testbench(
    // no inputs here ;)
    );
	
    reg [7:0] a = 0; // 1bit variable with the value 0
    reg [7:0] b = 0; // 1bit variable with the value 1
	
    wire [8:0] sum;

    // Instantiate the DUT
    // The syntax is <module_name> <instance_name>
    adder8bit ADDER1(  
      .a(a),
      .b(b),
      .sum(sum)
    );
  
    // Monitor the outputs and inputs
    initial begin
      $monitor("a=%d, b=%d, sum=%d", a,b,sum);
	end
	
	// Generate stimulus
	initial begin
       #1;    // wait 1 time unit
       a = 1;
       #1;
       b = 10;
       #1;
       a = 3;
       b = 99;
       #1;
       a = 101;
       b = 66;
       #1;
       a = 255;
       b = 255;
	end

endmodule



