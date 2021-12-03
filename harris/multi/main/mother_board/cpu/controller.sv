`include "lib_cpu.svh"
module controller import lib_cpu::*; (
    ctrl_bus_if.central ctrl_bus,
    input   OPECODE     op,
    input   FUNCT       funct,
    input   logic       zero,
    output  logic       mem_to_reg, mem_enab,
    output  logic       pc_src, alu_src,
	output	logic		pc_enab,
    output  logic       reg_dst, reg_write,
    output  logic       jmp,
    output  logic[2:0]  alu_ctrl_sig
);
    logic[1:0]  alu_op;
    logic       beq_enab, branch;

    alu_ctrl    alu_ctrl(.funct, .alu_op, .alu_ctrl_sig);
    path_ctrl   path_ctrl(
        .op, .mem_to_reg, .mem_enab,
		.pc_write, .alu_src, .branch, .reg_dst, .reg_write,
        .jmp, .alu_op
    );

	assign beq_eneb = zero & branch;
	assign pc_enab = beq_enab | pc_write;
    
endmodule