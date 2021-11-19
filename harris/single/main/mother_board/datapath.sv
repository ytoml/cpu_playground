module datapath(
    ctrl_bus_if.central ctrl_bus,
    mem_bus_if.central  imem_bus,
    mem_bus_if.central  dmem_bus,
    output  logic       zero,
    input   logic       mem_to_reg,
    input   logic       pc_src, alu_src,
    input   logic       reg_dst, reg_write,
    input   logic       jmp,
    input   logic[2:0]  alu_ctrl_sig,
    output  logic[31:0] write_data
);
    logic[31:0] alu_out, inst, imm, reg_in, read_data, reg_in;
    logic[5:0]  pc, rd;

    assign imem_bus.addr = pc;
    assign inst = imem_bus.data;
    assign dmem_bus.addr = alu_out;
    assign read_data = dmem_bus.data;

    // lw 命令では inst[20:16], R 形式では inst[15:11] をディスティネーションに設定
    mux2 #(.N(32))  sel_dst(.sel(reg_dst), .src1(inst[15:11]), .src2(inst[20:16]), .out(rd));
    alu #(.N(32))   alu(.src1(), .src2(), .alu_ctrl_sig, .alu_out, .zero);
    regfile         regfile(
        .ctrl_bus, .reg_write,
        .rs(inst[25:21]), .rt(inst[20:16], .rd,
        .rs_data(), .rt_data()
    );
    sign_ext        sign_ext(.half(inst[15:0]), .full(imm));
    mux2 #(.N(32))  res_to_reg(.sel(mem_to_reg), .src1(read_data), .src2(alu_out), .out(reg_in));
    
endmodule