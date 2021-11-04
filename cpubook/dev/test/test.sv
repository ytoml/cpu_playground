module test();
	logic		pin_clock, pin_n_reset;
	logic[3:0]	pin_switch, pin_led;

	top top_(*.);
	defparam	top_.prescaler.RATIO = 2;

	initial pin_clock <= 1'b0;
	always #5 pin_clock <= ~pin_clock;

	initial begin
		pin_n_reset <= 1'b0;
		#10
		pin_n_reset <= 1'b1;
	end

	initial pin_switch <= 4'd6;

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(0, test);
		#2000
		$finish();
	end
	
endmodule