
module ram_dp_async_read
        #(parameter WIDTH =8,
		  parameter DEPTH =16,
		  parameter DEPTH_LOG = $clog2(DEPTH))
        (input clk, 
		 input we_n, 
		 input [DEPTH_LOG-1:0] addr_wr, // The address bus has a log2(DEPTH)
		 input [DEPTH_LOG-1:0] addr_rd, 
		 input [WIDTH-1:0] data_wr, 
		 output [WIDTH-1:0]data_rd
		); 
	
    // Declare the RAM array
    reg [WIDTH-1:0] ram [0:DEPTH-1];
    
    // Write is synchronous
    always @(posedge clk) begin   
        if (we_n)   
            ram[addr_wr] <= data_wr;   
    end
    
    // Read is asynchronous  
    assign data_rd = ram[addr_rd];  
  
endmodule 


`timescale 1us/1ns
module tb_ram_dp_async_read();

    localparam WIDTH = 8;
	localparam DEPTH = 64;
    localparam DEPTH_LOG = $clog2(DEPTH);
    
    reg clk; 
    reg we_n; 
    reg [DEPTH_LOG-1:0] addr_wr;  
    reg [DEPTH_LOG-1:0] addr_rd; 
    reg [WIDTH-1:0] data_wr; 
    wire [WIDTH-1:0]data_rd;
    
    integer i;
	integer num_tests = 0;  // how many tests to perform     
    integer test_count = 0;
    integer success_count = 0;
    integer error_count = 0;
    reg [DEPTH_LOG-1:0] rand_addr_wr; 

    // Instantiate the module
    ram_dp_async_read 
        #(.WIDTH(WIDTH),
		  .DEPTH(DEPTH)
		) ram_dual_port0
        (.clk(clk), 
		 .we_n(we_n), 
		 .addr_wr(addr_wr), 
		 .addr_rd(addr_rd), 
		 .data_wr(data_wr), 
		 .data_rd(data_rd)
		); 
	
    initial begin // Create the clock signal
        clk=0;
        forever begin 
		    #1 clk = ~clk;
	    end
    end
	
	// Test scenario
    // Test1: write random data at a specific address, read it back and
    //        compare it with the written data.
    // Test2: write at a random address data with a known pattern, read it back
    //        and compare it with the written data.  	
    initial begin
	    #1; 
		// Clear the statistics counters
		success_count = 0; error_count = 0; test_count = 0;
		num_tests = DEPTH;
		#1.3;
		
        $display($time, " Test1 Start");
		for (i=0; i<num_tests; i=i+1) begin
		    data_wr = $random;
		    write_data(data_wr, i); // write random data at an address
			read_data(i);           // read that address back
			#0.1;                   // wait for output to stabilize 
			compare_data(i, data_wr, data_rd);
		end

        $display($time, " Test2 Start");
	    for (i=0; i<num_tests; i=i+1) begin
		    rand_addr_wr = $random % DEPTH;
		    data_wr = (rand_addr_wr << 4) | ((rand_addr_wr%2) ? 4'hA : 4'h5); // (even_position << 4) | 0x5
			                                                                  // (odd_position  << 4) | 0xA
		    write_data(data_wr, rand_addr_wr); // write random data at a random address
			read_data(rand_addr_wr);           // read that address back
			#0.1;                              // wait for output to stabilize 
			compare_data(rand_addr_wr, data_wr, data_rd);
		end
		
		// Print statistics 
	    $display($time, " TEST RESULTS success_count = %0d, error_count = %0d, test_count = %0d", 
		                success_count, error_count, test_count);
	    #40 $stop;
	end
	
   
    // All the tasks are below the test scenario location
    task write_data(input[WIDTH-1:0] data_in, input[DEPTH_LOG-1:0] address_in);
        begin
	        @(posedge clk);
	        we_n = 1; data_wr = data_in; addr_wr = address_in;
	        @(posedge clk);
	        we_n = 0;	  
        end
    endtask
   
    // Read the data asynchronously
    task read_data(input[DEPTH_LOG-1:0] address_in);
        begin
	        addr_rd = address_in;
	        //$display($time, " data_rd = %d", data_rd); // use for debug
        end
    endtask
	
	// Compare write data with read data
	task compare_data(input [DEPTH_LOG-1:0] address, 
	                  input [WIDTH-1:0] expected_data, 
					  input [WIDTH-1:0] observed_data); 
	    begin
		    if (expected_data === observed_data) begin // use case equality opearator
				$display($time, " SUCCESS address = %0d, expected_data = %0x, observed_data = %0x", 
				                  address, expected_data, observed_data);
                success_count = success_count + 1;				
            end else begin
				$display($time, " ERROR address = %0d, expected_data = %0x, observed_data = %0x", 
				                  address, expected_data, observed_data);	
				error_count = error_count + 1;
            end
            test_count = test_count + 1;			
		end
	endtask

endmodule
