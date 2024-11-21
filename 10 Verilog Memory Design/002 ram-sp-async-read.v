
// Single port RAM with asynchronous read
// The size of the RAM is 16 x 8bit words
module ram_sp_async_read(
    input clk,
	input [7:0] data_in,  // 8bit intput word
	input [3:0] address,  // for 16 locations
	input write_en,       // active high
	output [7:0] data_out // 8bit output word
    );
	
	// Declare a bidimentional array for the RAM
	reg [7:0] ram [0:15];
	
	// RAMs don't have reset. 
	// The default value from each location is X.
	// The write is synchronous
	always @(posedge clk) begin
	    if (write_en) begin
		    ram[address] <= data_in;
	    end
	end

    // The read is asynchronous
	assign data_out = ram[address];

endmodule


`timescale 1us/1ns
module tb_ram_sp_async_read();
	
	// Testbench variables
    reg clk = 0;
	reg [7:0] data_in;  // 8bit intput word
	reg [3:0] address;  // for 16 locations
	reg write_en;       // active high
	wire [7:0] data_out;// 8bit output word
	reg [1:0] delay;
	reg [7:0] wr_data;
	integer success_count, error_count, test_count;
    integer i;
	
	// Instantiate the DUT
	ram_sp_async_read RAM0(
        .clk     (clk     ),
	    .data_in (data_in ),  // 8bit intput word
	    .address (address ),  // for 32 locations
	    .write_en(write_en),  // active high
	    .data_out(data_out)   // 8bit output word
    );
	
	// We will use no outputs as we will use the global variables
	// connected to the module's ports
    task write_data(input [3:0] address_in, input [7:0] d_in);
	    begin
		    @(posedge clk); // sync to positive edge of clock
			write_en = 1;
		    address  = address_in;
			data_in  = d_in;
		end
	endtask
	
	task read_data(input [3:0] address_in);
	    begin
		    @(posedge clk); // sync to positive edge of clock
			write_en = 0;
		    address  = address_in;
		end
	endtask
	
	// Compare write data with read data
	task compare_data(input [3:0] address, input [7:0] expected_data, input [7:0] observed_data); 
	    begin
		    if (expected_data === observed_data) begin // use case equality opearator
				$display($time, " SUCCESS address = %0d, expected_data = %2x, observed_data = %2x", 
				                  address, expected_data, observed_data);
                success_count = success_count + 1;				
            end else begin
				$display($time, " ERROR address = %0d, expected_data = %2x, observed_data = %2x", 
				                  address, expected_data, observed_data);	
				error_count = error_count + 1;
            end
            test_count = test_count + 1;			
		end
	endtask
	
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
    // Create stimulus	  
    initial begin
	    #1; 
		// Clear the statistics counters
		success_count = 0; error_count = 0; test_count = 0;
		
		#1.3; 
		for (i=0; i<17; i=i+1) begin
		    wr_data = $random;
		    write_data(i, wr_data); // write random data at an address
			read_data(i);           // read that address back
			#0.1;                   // wait for output to stabilize 
			compare_data(i, wr_data, data_out);
			delay = $random;
		    #(delay); // wait between tests
		end
		
	    read_data(7);  // Show the read behavior         
	    read_data(8);          
		
		// Print statistics 
	    $display($time, " TEST RESULTS success_count = %0d, error_count = %0d, test_count = %0d", 
		                success_count, error_count, test_count);
	    #40 $stop;
	end
endmodule

