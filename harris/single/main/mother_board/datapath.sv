module datapath(
    ctrl_bus_if.central ctrl_bus,
    mem_bus_if.central  imem_bus,
    mem_bus_if.central  dmem_bus,
    output  logic       zero,
    input   logic       mem_to_reg, write_enab,
    input   logic       pc_src, alu_src,
    input   logic       reg_dst, reg_write,
    input   logic       jmp
    input   logic[2:0]  alu_ctrl_sig,
    output  logic[31:0] write_data
);
    logic[31:0] alu_out;

    //TODO: アドレス幅確認
    assign imem_bus.addr = alu_out;

    alu         alu();
    regfile     regfile();
    sign_ext    sign_ext();
    
endmodule