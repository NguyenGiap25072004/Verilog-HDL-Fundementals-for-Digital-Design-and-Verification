
module prng(input rst_n,
            input clk,
            input load_seed,
            input [7:0] seed_in,
            input encrypt_en,
			output reg [7:0] prng);
				
    localparam SEED = 8'hCD; // default value for the SEED
	
	wire feedback;	
	assign feedback = prng[7] ^ prng[5] ^ prng[4] ^ prng[3];
	
	always @(posedge clk or negedge rst_n)
	begin
	    if(!rst_n)
		    prng <= SEED;
        else if (load_seed == 1'b1)
            prng <= seed_in;
	    else if (encrypt_en)
            prng <= {prng[6:0],feedback};	
	end

endmodule

