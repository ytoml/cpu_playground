`include "main/package/lib_cpu.svh"
`include "main/package/lib_stage.svh"
module write_reg import lib_cpu::*, lib_stage::*; (
	ctrl_bus_if.master	ctrl_bus,
	input 	STAGE		stage,
	output	REGS		cur,
	input	REGS		next
);
	// クロックごとに alu から受け取る next を次の cur にセットすることに注意(逆ではない)
	always_ff @(posedge ctrl_bus.clk) begin
		if (~ctrl_bus.n_reset)		cur <= '0;
		else if (stage == MEMSTORE)	cur <= next;
	end
endmodule