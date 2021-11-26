`include "lib_cpu.svh"
module cpu (
    ctrl_bus_if.central ctrl_bus,
    mem_bus_if.central  imem_bus,
    mem_bus_if.central  dmem_bus,
    output  logic       write_enab,
    output  logic[31:0] write_data
);
    import lib_cpu::*;

    OPECODE op, funct;
    logic       zero, mem_to_reg, pc_src, alu_src, reg_dst, reg_write, jmp;
    logic[2:0]  alu_ctrl_sig;
    
    decoder decoder(
        .prefix(imem_bus.data[31:26]),
        .suffix(imem_bus.data[5:0]),
        .op, .funct
    );

    controller  controller(
        .op, .funct,
        .zero, .mem_to_reg, .write_enab,
        .pc_src, .alu_src, .reg_dst, .reg_write,
        .jmp, .alu_ctrl_sig
    );

    datapath    datapath(
        .ctrl_bus, .imem_bus, .dmem_bus,
        .zero, .mem_to_reg,
        .pc_src, .alu_src, .reg_dst, .reg_write,
        .jmp, .alu_ctrl_sig,
        .write_data
    );
    
endmodule