`timescale 1us/1ns
module clkgen();
	
	// Testbench variables
    parameter HALF_PERIOD_CLK1 = 0.5;
    parameter HALF_PERIOD_CLK2 = 0.25;

    reg clock1;      // 1 MHz clock, duty cycle = 50%
    reg clock2 = 0;  // 2 MHz clock, duty cycle = 50%
    reg clock3;      // 1 MHz clock, duty cycle = 30% 
    
    // Create stimulus
    initial begin
        clock1 = 0;
        forever begin
			#(HALF_PERIOD_CLK1); clock1 = ~clock1;
        end
    end
	
    always begin
        #(HALF_PERIOD_CLK2); clock2 = ~clock2;
	end
  
    initial begin
        clock3 = 1;
        forever begin
           clock3 = 1; #(0.3); 
           clock3 = 0; #(0.7); 
        end
	end
	
    // This will stop the simulator after 40us
    initial begin       
       #40 $stop;
       $display("End of CLKGEN");
    end
  
endmodule


