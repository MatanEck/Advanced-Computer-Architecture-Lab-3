module fifo(clk, reset, in, push, pop, out, full);
   parameter N=4; // determines the maximum number of words in queue.
   parameter M=2; // determines the bit-width of each word, stored in the queue.

   input clk, reset, push, pop;
   input [M-1:0] in;
   output [M-1:0] out;
   output full;
	
   reg [$clog2(N):0] write_ptr=0;
   reg [$clog2(N):0] read_ptr=0;
   reg [$clog2(N):0] count=0;
   reg [M-1:0] FIFO_ARRAY [0:N-1];
   reg [M-1:0] zero = {M{1'b0}}; // Array of 0^M
   output reg [M-1:0] out;
   integer i;
   
   assign full = (count == N)? 1'b1:1'b0;
   always @(posedge clk)
   begin
		if(reset) begin//reset=1
			write_ptr <= 0;
			read_ptr <= 0;
			count <= 0;
			for (i = 0; i < N; i = i + 1) // Empty queue (set every member to 0)
				FIFO_ARRAY[i] <= zero;
			out <= zero; /// ------------------- change1
		end
		else begin /// ------------------- added else - change2
		if(count == 0)begin //count=0
			out <= zero; /// ------------------- added - change3
			if (push) begin
				FIFO_ARRAY[0] <= in;
				write_ptr <= (write_ptr + 1);
				count <=(count + 1);
			end
		end
		else if(count>0 && count<N)begin//N>count>0
			out <= FIFO_ARRAY[read_ptr];
			
        	if ( pop == 1 && push==1 ) begin
				FIFO_ARRAY[read_ptr]=zero;
				read_ptr <= (read_ptr+1);
			
				FIFO_ARRAY[write_ptr] <= in;
				write_ptr <= (write_ptr + 1);
        	end
        	else if ( push == 1 && pop==0) begin
            		FIFO_ARRAY[write_ptr] <= in;
					write_ptr <= (write_ptr + 1);
					count<=(count+1);
			end
		else if ( push == 0 && pop == 1 ) begin
			FIFO_ARRAY[read_ptr]=zero;
			read_ptr <= (read_ptr+1);
			count<=count-1;
			end		
		else;
		end
		else if(count == N)begin //count=N
			out <= FIFO_ARRAY[read_ptr];
			
			if (pop == 1 && push==1 ) begin
				FIFO_ARRAY[read_ptr]=zero;
				read_ptr <= (read_ptr+1);
				FIFO_ARRAY[write_ptr] <= in;
				write_ptr <= (write_ptr + 1);
			end
			else if(push==0 && pop == 1)begin
				FIFO_ARRAY[read_ptr]=zero;
				read_ptr <= (read_ptr+1);
				count<=count-1;
			end
		else;
        end
		end

		if ( write_ptr == N) 
			write_ptr <= 0;
		else if (read_ptr == N) 
			read_ptr <= 0; 
		else; 
end
endmodule
