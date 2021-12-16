`include "lib_cpu.svh"
module controller import lib_cpu::*; (
    input   OPECODE     op,
    input   FUNCT       funct,
    output  logic       mem_to_reg, mem_enab,
    output  logic       pc_src, alu_srcB,
    output  logic       reg_dst, reg_write,
    output  logic       branch, jmp,
    output  logic[2:0]  alu_ctrl_sig
);
    logic[1:0]  alu_op;

    alu_ctrl    alu_ctrl(.*);
    path_ctrl   path_ctrl(.*);
endmodule