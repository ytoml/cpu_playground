// inst 専用の外部 reset 及び enable 付き ff
module inst_ff (
	ctrl_bus_if.central	ctrl_bus,
	input	logic		reset, enab,
	input	logic[31:0]	in,
	output	logic[31:0]	out
);
	always_ff @(posedge ctrl_bus.clk or posedge ctrl_bus.reset) begin
		if (ctrl_bus.reset || reset)	out <= 32'b100000; // nop (add $0, $0, $0)
		else if	(enab)					out <= in;
	end
endmodule