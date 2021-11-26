module test();
	logic	clk, reset, write_enab;
	logic[31:0]	write_data, data_addr, 
	top	top(.clk, .reset, .write_data, .data_addr, .write_enab);
	
	initial begin
		clk <= 0; reset <= 1;
		#10 reset <= 0;

	end

	always #5 clk <= ~clk;
endmodule