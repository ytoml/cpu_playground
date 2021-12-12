`include "lib_cpu.svh"
module controller import lib_cpu::*; (
    input   OPECODE     op,
    input   FUNCT       funct,
    input   logic       zero,
    output  logic       mem_to_reg, write_enab,
    output  logic       pc_src, alu_src,
    output  logic       reg_dst, reg_write,
    output  logic       jmp,
    output  logic[2:0]  alu_ctrl_sig
);
    logic[1:0]  alu_op;
    logic       branch;

    alu_ctrl    alu_ctrl(.funct, .alu_op, .alu_ctrl_sig);
    path_ctrl   path_ctrl(
        .op, .mem_to_reg, .write_enab,
        .alu_src, .branch, .reg_dst, .reg_write,
        .jmp, .alu_op
    );

    assign pc_src = branch & zero;
    
endmodule