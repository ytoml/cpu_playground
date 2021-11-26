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
    logic[31:0] pc, pc_plus4, pc_next, pc_br, pc_br_next, br_offset, pc_jmp;
    logic[31:0] alu_src1, alu_src2;
    logic[5:0]  rd;

    assign imem_bus.addr = pc[7:2];
    assign inst = imem_bus.data;
    assign dmem_bus.addr = alu_out;
    assign read_data = dmem_bus.data;

	// PC 制御
	ff #(.N(32))	pcreg(.ctrl_bus, pc_next, pc);
	assign pc_plus4		= pc + 32'b100;
	assign br_offset	= { imm[29:0], 2'b00 };
	assign pc_br		= pc_plus4 + br_offset;
	assign pc_jmp		= { pc_plus4[31:28], inst[25:0], 2'b00 }; // word(4byte) alignment
	// beq は 次の命令(pc_plus4) からの相対でアドレシング、j は(擬似)直接アドレシング
    mux2 #(.N(32))  pc_br_select(.sel(pc_src), .src1(pc_plus4), .src2(pc_br), .out(pc_br_next));
	mux2 #(.N(32))	pc_select(.sel(jmp), .src1(pc_br_next), .src2(pc_jmp), .out(pc_next));

    // lw 命令では inst[20:16], R 形式では inst[15:11] をディスティネーションに設定
    mux2 #(.N(32))  sel_dst(.sel(reg_dst), .src1(inst[20:16]), .src2(inst[15:11]), .out(rd));
    regfile         regfile(
        .ctrl_bus, .reg_write,
        .rs(inst[25:21]), .rt(inst[20:16]), .rd,
        .rs_data(), .rt_data()
    );
    sign_ext        sign_ext(.half(inst[15:0]), .full(imm));
    mux2 #(.N(32))  res_to_reg(.sel(mem_to_reg), .src1(alu_out), .src2(read_data), .out(reg_in));
    
    mux2 #(.N(32))  src_select(.sel(alu_src), .src1(write_data), .src2(imm), .out(alu_src2));
    alu #(.N(32))   alu(.src1(alu_src1), .src2(alu_src2), .alu_ctrl_sig, .alu_out, .zero);
endmodule