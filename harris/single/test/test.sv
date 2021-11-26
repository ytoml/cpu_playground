module test();
	logic	clk, reset, write_enab;
	logic[31:0]	write_data, data_addr, 
	top	top(.clk, .reset, .write_data, .data_addr, .write_enab);
	
	initial begin
		clk <= 0; reset <= 1;
		#10 reset <= 0;
		#1000
	end

	always @(negedge clk) begin
		if (write_enab) begin
			if (data_addr === 84 && write_data === 7) begin 
				$display("Simulation Succeeded.");
				$stop;
			end else if (data_addr !== 80) begin 
				$display("Simulation Failed.");
				$stop;
			end
		end
	end

	always #5 clk <= ~clk;
endmodule