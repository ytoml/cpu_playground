`include "lib_cpu.svh"
module cpu (
    ctrl_bus_if.central ctrl_bus,
    mem_bus_if.central  mem_bus,
    output  logic       mem_write_enab,
    output  logic[31:0] write_data
);
    import lib_cpu::*;

    OPECODE     op;
    FUNCT       funct;
    logic       zero, mem_to_reg, pc_src, alu_src, reg_dst, reg_write, jmp;
	logic		ireg_write_enab, i_or_d;
    logic[2:0]  alu_ctrl_sig;

    controller  controller(.*);
    datapath    datapath(.*);
    
endmodule