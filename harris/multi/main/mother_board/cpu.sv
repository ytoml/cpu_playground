`include "lib_cpu.svh"
module cpu (
    ctrl_bus_if.central ctrl_bus,
    mem_bus_if.central  mem_bus,
    output  logic       mem_enab,
    output  logic[31:0] write_data
);
    import lib_cpu::*;

    OPECODE     op;
    FUNCT       funct;
    logic       zero, mem_to_reg, pc_src, alu_srcA, reg_dst, reg_write, jmp;
	logic		pc_enab, ireg_enab, i_or_d;
	logic[1:0]	alu_srcB;
    logic[2:0]  alu_ctrl_sig;
	logic[31:0]	inst;

    datapath    datapath(.*);
	decoder		decoder(
        .prefix(inst[31:26]),
        .suffix(inst[5:0]),
        .op, .funct
    );
    controller  controller(.*);
    
endmodule