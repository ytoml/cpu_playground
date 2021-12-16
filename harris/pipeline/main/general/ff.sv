module ff #(parameter N) (
	ctrl_bus_if.central		ctrl_bus,
	input	logic[N-1:0]	in,
	output	logic[N-1:0]	out
);
	always_ff @(posedge ctrl_bus.clk or posedge ctrl_bus.reset) begin
		if (ctrl_bus.reset) out <= 0;
		else				out <= in;
	end
endmodule