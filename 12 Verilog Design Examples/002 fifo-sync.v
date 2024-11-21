
module fifo_sync
    // Parameters section
    #( parameter FIFO_DEPTH = 8,
	   parameter DATA_WIDTH = 32)
    // Ports section   
	(input clk, 
     input rst_n,
     input cs,     // chip select	 
     input wr_en, 
     input rd_en, 
     input [DATA_WIDTH-1:0] data_in, 
     output reg [DATA_WIDTH-1:0] data_out, 
	 output empty,
	 output full); 

    localparam FIFO_DEPTH_LOG = $clog2(FIFO_DEPTH);
	
    // Declare a by-dimensional array to store the data
	reg [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];
	
	// Wr/Rd pointer have 1 extra bits at MSB
	reg [FIFO_DEPTH_LOG:0] write_pointer;
	reg [FIFO_DEPTH_LOG:0] read_pointer;

    always @(posedge clk or negedge rst_n) begin
	    if(!rst_n)
		    write_pointer <= 0;
		else if (cs && wr_en && !full)
	        write_pointer <= write_pointer + 1'b1;
	end
	
	always @(posedge clk or negedge rst_n) begin
	    if(!rst_n)
		    read_pointer <= 0;
		else if (cs && rd_en && !empty)
	        read_pointer <= read_pointer + 1'b1;
	end
	
	// Declare the empty/full logic
    assign empty = (read_pointer == write_pointer);
	assign full  = (read_pointer == {~write_pointer[FIFO_DEPTH_LOG], write_pointer[FIFO_DEPTH_LOG-1:0]});

    always @(posedge clk) begin
	    if (cs && wr_en && !full)
	        fifo[write_pointer[FIFO_DEPTH_LOG-1:0]] <= data_in;
	end
	
	always @(posedge clk or negedge rst_n) begin
	    if (!rst_n)
		    data_out <= 0;
		else if (cs && rd_en && !empty)
	        data_out <= fifo[read_pointer[FIFO_DEPTH_LOG-1:0]];
	end

endmodule



`timescale 1us/1ns
module tb_fifo_sync();
	
	// Testbench variables
	parameter FIFO_DEPTH = 8;
	parameter DATA_WIDTH = 32;
    reg clk = 0; 
    reg rst_n;
    reg cs;	 
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
	wire empty;
	wire full;
	
    integer i;
	
	// Instantiate the DUT
	fifo_sync 
	    #(.FIFO_DEPTH(FIFO_DEPTH),
	     .DATA_WIDTH(DATA_WIDTH))
        FIFO0
  	    (.clk     (clk     ), 
         .rst_n   (rst_n   ),
         .cs      (cs      ),	 
         .wr_en   (wr_en   ), 
         .rd_en   (rd_en   ), 
         .data_in (data_in ), 
         .data_out(data_out), 
	     .empty   (empty   ),
	     .full    (full    ));

    task write_data(input [DATA_WIDTH-1:0] d_in);
	    begin
		    @(posedge clk); // sync to positive edge of clock
			cs = 1; wr_en = 1;
			data_in = d_in;
			$display($time, " write_data data_in = %0d", data_in);
			@(posedge clk);
		    cs = 1; wr_en = 0;
		end
	endtask
	
	task read_data();
	    begin
		    @(posedge clk);  // sync to positive edge of clock
			cs = 1; rd_en = 1;
			@(posedge clk);
			#0.1;
		    $display($time, " read_data data_out = %0d", data_out);
		    cs = 1; rd_en = 0;
		end
	endtask
	
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
    // Create stimulus	  
    initial begin
	    #1; 
		rst_n = 0; rd_en = 0; wr_en = 0;
		
		#1.3; 
		rst_n = 1;
		$display($time, "\n SCENARIO 1");
		write_data(1);
		write_data(10);
		write_data(100);
		read_data();
		read_data();
		read_data();
		read_data();
		
        $display($time, "\n SCENARIO 2");
		for (i=0; i<FIFO_DEPTH; i=i+1) begin
		    write_data(2**i);
			read_data();        
		end

        $display($time, "\n SCENARIO 3");		
		for (i=0; i<=FIFO_DEPTH; i=i+1) begin
		    write_data(2**i);
		end
		
		for (i=0; i<FIFO_DEPTH; i=i+1) begin
			read_data();
		end
		
	    #40 $stop;
	end
endmodule

























