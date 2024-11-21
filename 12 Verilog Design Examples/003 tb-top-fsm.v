`timescale 1ns/1ps
module tb_top_fsm();

    localparam DEPTH = 4;
    localparam WIDTH_WR = 8;
    
    reg clk = 0; 
    reg rst_n;
    reg we; 
    reg [4:0] addr_wr;
    reg [3:0] addr_rd;     
    reg [WIDTH_WR-1:0] data_wr;     
    wire [2*WIDTH_WR-1:0]data_rd;
    reg  [2*WIDTH_WR-1:0]data_rd_buf;
    wire done;
    reg opmode;
    reg [2*WIDTH_WR-1:0] data_exp;
    
    integer i, loop_no;
    
    // Verification statistics
    integer test_count = 0, success_count = 0, error_count = 0;
       
    // Instantiate the module      
    top_fsm TOP(
        .clk            (clk    ),
        .rst_n          (rst_n  ),
	 	.ram_in_we      (we     ),
	 	.ram_in_addr_wr (addr_wr), 
	 	.ram_in_data_wr (data_wr),
	 	.ram_out_addr_rd(addr_rd), 
	 	.ram_out_data_rd(data_rd),       
        .opmode_in      (opmode ),
        .done_out       (done   )
    );
 
    // Create the clock signal	
    always begin #0.5 clk = ~clk; end
	
    // Begin test 		   
    initial begin
	    we = 0; 
	    addr_wr = 0;
        opmode = 0; // store data in RAM_IN
        rst_n = 0;
        #10;
        rst_n = 1;
      
	    for (loop_no=0;loop_no<2;loop_no=loop_no+1) begin
			// Fill RAM_IN with a data pattern
			for (i=0;i<32;i=i+1) begin
				write_data(i, ((i%2)<<7)+i+loop_no);
			end 
		
			// Trigger the data transfer procedure
			@(posedge clk); opmode = 1;     
			@(posedge clk); opmode = 0;
		    
			@(posedge clk); wait (done === 1);  // wait done is set 	  
			for (i=0;i<32;i=i+2) begin
				read_data(i>>1);
				data_exp =  ((((i%2)<<7)+i+loop_no)<<8) | ((((i+1)%2)<<7)+(i+loop_no+1));
				compare_data(data_exp, data_rd_buf);
			end     
        end
 

        #40;
	    $display($time, " test_count=%d success_count=%d error_count=%d", 
		                test_count, success_count, error_count);
	    $stop;
    end
   
    task write_data(input[4:0] address_in, input[WIDTH_WR-1:0]data_in);
    begin
	    @(posedge clk);
	    we = 1;
	    data_wr = data_in;
	    addr_wr = address_in;
        $display($time, " write_address=%d data_wr = 0x%h", addr_wr, data_wr);
	    @(posedge clk);
	    we = 0;
    end
    endtask
   
    task read_data(input[3:0]address_in);
    begin
	    @(posedge clk);
	    addr_rd = address_in;
	    @(negedge clk);
	    $display($time, " read_address=%d data_rd = 0x%h", addr_rd, data_rd);
        data_rd_buf = data_rd;  
    end
    endtask  

    task compare_data( input[2*WIDTH_WR-1:0] expected, input[2*WIDTH_WR-1:0] observed);
    begin
        test_count = test_count + 1;
	    if (observed != expected) begin
            //$display($time,(" test_count=%d  FAIL: expected data_out=%x, observed data_out=%x"), test_count, expected, observed);      
            error_count = error_count + 1;			
        end else begin
            //$display($time,(" test_count=%d  PASS: expected data_out=%x, observed data_out=%x"), test_count, expected, observed);
	 	    success_count = success_count + 1;
        end
    end
    endtask   
   
endmodule