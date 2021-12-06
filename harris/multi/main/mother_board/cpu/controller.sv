`include "lib_cpu.svh"
module controller import lib_cpu::*; (
	ctrl_bus_if.central ctrl_bus,
	mem_bus_if.central	mem_bus,
	input   OPECODE		op,
	input   FUNCT		funct,
	input   logic		zero,
	output	logic		i_or_d, ireg_enab,
	output  logic[1:0]	pc_src,
	output	logic		pc_enab,
	output  logic		mem_to_reg,
	output  logic		reg_dst, reg_write,
	output	logic		alu_srcA,
	output	logic[1:0]	alu_srcB,
	output  logic[2:0]  alu_ctrl_sig
);
	logic[1:0]  alu_op;
	logic	   beq_enab, branch;

	alu_ctrl	alu_ctrl(.*);
	path_ctrl   path_ctrl(.*);

	assign beq_eneb = zero & branch;
	assign pc_enab = beq_enab | pc_write;
	
endmodule