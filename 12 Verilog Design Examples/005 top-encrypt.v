
module top_encrypt(input rst_n,
            input clk,
            input load_seed,
            input [7:0] seed_in,
            input encrypt_en,
            input [7:0] data_in,
		    output reg [7:0] data_out);
            
	reg encrypt_en_dly;
	reg [7:0] data_in_dly;
	wire [7:0] prng;

	prng   PRNG(.rst_n     (rst_n     ),
				.clk       (clk       ),
				.load_seed (load_seed ),
				.seed_in   (seed_in   ),
				.encrypt_en(encrypt_en),
				.prng      (prng      )
				);

	// Buffer encrypt_en
	always @(posedge clk or negedge rst_n)
	begin
	   if(!rst_n) begin
		  encrypt_en_dly <=0;
		  data_in_dly    <=0;
	   end else begin
		  encrypt_en_dly   <= encrypt_en;
		  data_in_dly[7:0] <= data_in[7:0];
	   end
	end

	// Encrypt or decrypt the data
	always @(posedge clk or negedge rst_n)
	begin
	    if(!rst_n)
		    data_out <=0;
	    else if (encrypt_en_dly)
		    data_out[7:0] <= prng[7:0] ^ data_in_dly[7:0];
	end

endmodule



