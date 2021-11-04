`include "main/package/lib_cpu.svh"
`include "main/package/lib_stage.svh"
module cpu (
	ctrl_bus_if.master	ctrl_bus,
	io_bus_if.master	io_bus,
	mem_bus_if.master	mem_bus,
);
	import lib_cpu::*; 
	import lib_stage::*; 

	STAGE stage;
	OPECODE opecode;
	
	always_ff @(posedge ctrl_bus.clk) begin
		if (~ctrl_bus.n_reset) stage = FETCH;
		else stage = next_stage(stage);
	end

	logic[3:0]	imm;
	decoder		decoder(.stage, .data, .opecode, .imm);

	REGS cur, next;
	assign mem_bus.addr	= cur.ip;
	assign io_bus.led	= cur.out;

	alu			alu(.stage, .opecode, .imm, .switch(io_bus.switch), .cur, .next);
	write_reg	write_reg(.ctrl_bus, .stage, .cur, .next);
endmodule
