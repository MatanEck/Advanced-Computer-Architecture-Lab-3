module main;
   reg clk, reset, taken, branch;
   wire prediction;

   sat_count sat_count(clk, reset, branch, taken, prediction);
   
   integer test;
   
   always #5 clk = ~clk;

	initial
    begin
	$monitor("time=%d: reset=%b, branch=%b, taken=%b -> prediction is: %b\n", $time, reset, branch, taken, prediction);
	$dumpfile("waves.vcd");
	$dumpvars;
		clk = 0;
        reset = 1; branch = 0; taken = 1;
		#10
				branch = 1; taken = 1;
		#10
				branch = 1; taken = 1;
		#10
				branch = 1; taken = 1;
				
		if (prediction == 0) // reset = 1 - ZERO state - should be prediction == 0
			test = 1; // test passed
		else
			test = 0;
		#10
		
		reset = 0; branch = 1; taken = 1;
		#10
				branch = 1; taken = 1;
		#10
				branch = 1; taken = 1;
		#10
				
		if (prediction == 1) // taken=1 for 3 cycles - should be in SAT state and prediction=1
			test = test + 1; // test passed
		else
			test = 0;
		#10
		
		branch = 0; taken = 0;
		#10
				taken = 0;
		#10
				taken = 0;
		if (prediction == 1) // branch = 0 - should stay in SAT state and prediction=1
			test = test + 1; // test passed
		else
			test = 0;
			
	if (test == 3) // sat_count is correct if all the prediction were as expected
		$display("PASSED ALL TESTS");
	$finish;
	end
endmodule