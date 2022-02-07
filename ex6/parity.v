module parity(clk, in, reset, out);

   input clk, in, reset;
   output out;

   reg 	  out;
   reg 	  state; // counts the number of ones - 0 if it's even

   localparam zero=0, one=1;

   always @(posedge clk)
     begin
	if (reset)
	  state <= zero;
	else
	  case (state)
		zero:		if(in == 1)
						state <= one;
					else
						state <= zero;
		one:		if(in == 1)
						state <= zero;
					else
						state <= one;
		default:	state <= zero;
	  endcase
     end

   always @(state) 
     begin
	case (state)
	    zero:		assign out = 1; // is even
		one:		assign out = 0;
		default:	assign out = 1;
	endcase
     end

endmodule