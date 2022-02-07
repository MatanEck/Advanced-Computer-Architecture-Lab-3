module sat_count(clk, reset, branch, taken, prediction);
   parameter N=2;
   input clk, reset, branch, taken;
   output prediction;

   reg 	  prediction;
   reg 	  [1:0] state; 

   localparam ZERO=2'b00, ONE=2'b01, TWO=2'b10, SAT=2'b11;

   always @(posedge clk)
   begin
		if (reset)
			state <= ZERO;
		else if (branch == 0)
			state <= state;
		else // if reset == 0 and branch == 1
			case (state)
			ZERO:		if(taken ==1)
							state <= ONE;
						else 
							state <= ZERO;
			ONE:		if(taken ==1)
							state <= TWO;
						else
							state <= ZERO;
			TWO:		if(taken ==1)
							state <= SAT;
						else
							state <= ONE;
			SAT:		if(taken ==1)
							state <= SAT;
						else
							state <= TWO;				
			default:	state <= ZERO;
	  endcase
    end

   always @(state) 
   begin
		if (state >= TWO)
			prediction = 1;
		else
			prediction = 0;
	end
 
endmodule
