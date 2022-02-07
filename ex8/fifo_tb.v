module main;
   reg clk, reset, push, pop;
   reg [1:0] in;
   wire [1:0] out;
   wire full;

   // Correct the parameter assignment
   fifo #(4,2) fifo (clk, reset, in, push, pop, out, full);
   
   integer test;

   always #5 clk = ~clk;

   initial
   begin
   $monitor("time=%d: reset %b, in %b, out %b, push %b, pop %b, full %b\n", $time, reset, in, out, push, pop, full);
   $dumpfile("waves.vcd");
   $dumpvars;
	clk=0;
	reset = 1; in = 0; push = 0; pop = 0;
	#10
	reset = 0; in = 2'b11; push = 1; pop = 0;
	#10
				in = 2'b01; push = 1; pop = 0;
	#10
				in = 2'b10; push = 1; pop = 0;
	#10
	if (out == 2'b11 && full == 0) // queue is not full and out is 11.(11,01,10,empty)
		test = 1;
	else
		test = 0;
				in = 2'b01; push = 1; pop = 1;
	#10// queue is not full and out is 01.(01,10,01,empty)

				in = 2'b11; push = 1; pop = 0;
	#10// queue is full and out is 01.(01,10,01,11)
	if (out == 2'b01 && full == 1) 
		test = test + 1;
				in = 2'b01; push = 0; pop = 1;
	#10// queue is not full and out is 10.(10,01,11,empty)
				in = 2'b10; push = 1; pop = 0;
	#10// queue is full and out is 10.(10,01,11,10)
				in = 2'b01; push = 1; pop = 0;
	#10//should not change.
	if (out == 2'b10 && full == 1 ) 
		test = test + 1;
				in = 2'b01; push = 1; pop = 1;
	#10//// queue is full and out is 01.(01,11,10,01)
				in = 2'b01; push = 0; pop = 0;
	#10//should not change
	if  (out == 2'b01 && full == 1) 
		test = test + 1;
				in = 2'b01; push = 0; pop = 0;
	#10
	

				in = 2'b01; push = 0; pop = 0;
	#10	
	if (test == 4)
	$display("PASSED ALL TESTS");
	$finish;
   end
endmodule
