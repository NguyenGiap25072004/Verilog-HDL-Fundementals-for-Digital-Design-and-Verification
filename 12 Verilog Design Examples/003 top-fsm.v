module top_fsm(
        input clk,
        input rst_n,
        // Signals for the input RAM
		input        ram_in_we,
		input [4 :0] ram_in_addr_wr, 
		input [7 :0] ram_in_data_wr,
        // Signals for the output RAM
		input [3 :0] ram_out_addr_rd, 
		output [15:0] ram_out_data_rd,     
        // FSM control signals
        input opmode_in,
        output reg done_out
);

    // instantiate the FSM
    parameter [3:0] //FSM One Hot coding
                   IDLE           = 4'b0001,
                   READ_BYTE0     = 4'b0010,
	  			   READ_BYTE1     = 4'b0100,
                   WRITE_BYTE12   = 4'b1000;
                   
    // Declare logic for the state machine
    reg [3:0] state, next_state;
	
	// Used to read from RAM_IN and write in RAM_OUT
    reg [4:0] ram_pointer;
    
    reg [4:0]   fsm_mem_in_addr_rd;
    wire [7:0] fsm_mem_in_data_rd;
    reg [7:0]  read_byte0_buffer, read_byte1_buffer;
    
    reg [3:0]  fsm_mem_out_addr_wr;
    reg ram_out_we;

    // Instantiate the RAM modules
    ram_dp_async_read 
        #(.WIDTH(8), .DEPTH(32))
        RAM_IN
        (.clk    (clk), 
		 .we     (ram_in_we), 
		 .addr_wr(ram_in_addr_wr), 
		 .data_wr(ram_in_data_wr),
         .addr_rd(fsm_mem_in_addr_rd),
		 .data_rd(fsm_mem_in_data_rd)
		);

    ram_dp_async_read 
        #(.WIDTH(16), .DEPTH(16))
        RAM_OUT
        (.clk    (clk), 
		 .we     (ram_out_we), 
		 .addr_wr(fsm_mem_out_addr_wr), 
		 .data_wr({read_byte1_buffer, read_byte0_buffer}),
         .addr_rd(ram_out_addr_rd),
		 .data_rd(ram_out_data_rd)
		);


    // Create the state machine  
    // Next state logic
    always @(*)
        begin
        next_state = IDLE;
        fsm_mem_in_addr_rd = 0;
        ram_out_we = 0;
        case(state) //
			IDLE        :begin
						    if (opmode_in == 1'b1)
						        next_state = READ_BYTE0;
						end
			READ_BYTE0  :begin
							fsm_mem_in_addr_rd = ram_pointer;
							next_state = READ_BYTE1;
						end   
			READ_BYTE1  :begin
							fsm_mem_in_addr_rd = ram_pointer;
							next_state = WRITE_BYTE12;
						end 			   
			WRITE_BYTE12: begin
							if (done_out == 1) begin
								next_state = IDLE;
							end else begin
								next_state = READ_BYTE0;                     
							end
							ram_out_we = 1;
						end     
			default: begin 
					   next_state = IDLE;
					end
        endcase
    end

    //State sequencer logic
	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
		    state <= IDLE;
		else
		    state <= next_state;
	end    
    
    //Declare internal counter logic 
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            ram_pointer <= 0;
        else if ((state == READ_BYTE0) || (state == READ_BYTE1))
            ram_pointer <= ram_pointer + 1'b1;
    end

   always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            fsm_mem_out_addr_wr <= 0;
        else if (state == READ_BYTE0)
		    fsm_mem_out_addr_wr <= (ram_pointer >> 1);
    end 

    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            done_out <= 0;
	    else if (opmode_in == 1)
		    done_out <= 0;
        else if (ram_pointer == 5'd31)
            done_out <= 1;
    end

    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) begin
            read_byte0_buffer <= 0;
	        read_byte1_buffer <= 0;
        end else begin
            read_byte0_buffer <= fsm_mem_in_data_rd;
	        read_byte1_buffer <= read_byte0_buffer;
	    end
    end 
 
endmodule