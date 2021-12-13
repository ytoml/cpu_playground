`include "lib_cpu.svh"
module cpu (
    ctrl_bus_if.central ctrl_bus,
    mem_bus_if.central  imem_bus,
    mem_bus_if.central  dmem_bus,
    output  logic[31:0] write_data
);
    import lib_cpu::*;

    OPECODE     op;
    FUNCT       funct;
    logic       zero, mem_to_reg, mem_enab, pc_src, alu_src, reg_dst, reg_write, jmp;
    logic[2:0]  alu_ctrl_sig;
	logic[31:0]	inst;
    
    decoder decoder(
        .prefix(inst[31:26]),
        .suffix(inst[5:0]),
        .op, .funct
    );
    controller  controller(.*);
    datapath    datapath(.*);
endmodule