`include "lib_cpu.svh"
module datapath(
    ctrl_bus_if.central ctrl_bus,
    mem_bus_if.central  mem_bus,
	output	OPECODE		op,
	output	FUNCT		funct,
    output  logic       zero,
    input   logic       mem_to_reg,
    input   logic       pc_src, alu_src,
    input   logic       reg_dst, reg_write,
    input   logic       jmp,
	input	logic		ireg_write_enab,
	input	logic		i_or_d,
    input   logic[2:0]  alu_ctrl_sig,
    output  logic[31:0] write_data
);
    logic[31:0] alu_out, inst, imm, reg_in, read_data, load_data;
    logic[31:0] pc, pc_plus4, pc_next, pc_br, pc_br_next, br_offset, pc_jmp;
    logic[31:0] alu_in1, alu_in2;
    logic[4:0]  reg_id;

	mux2 #(.N(32))	sel_addr(.sel(i_or_d), .src1(pc), .src2(alu_out), .out(mem_bus.addr))

	// メモリから読んできたデータを命令/データレジスタに格納
	enab_ff #(.N(32))	ireg(.ctrl_bus, .enab(ireg_write_enab), .in(mem_bus.data), .out(inst))
	ff		#(.N(32))	dreg(.ctrl_bus, .in(mem_bus.data), .out(read_data));
    
    decoder decoder(
        .prefix(inst[31:26]),
        .suffix(inst[5:0]),
        .op, .funct
    );

	// PC 制御
	ff #(.N(32))	pcreg(.ctrl_bus, .in(pc_next), .out(pc));
	assign pc_plus4		= pc + 32'b100;
	assign br_offset	= { imm[29:0], 2'b00 };
	assign pc_br		= pc_plus4 + br_offset;
	assign pc_jmp		= { pc_plus4[31:28], inst[25:0], 2'b00 }; // word(4byte) alignment

	// beq は 次の命令(pc_plus4) からの相対でアドレシング、j は(擬似)直接アドレシング
    mux2 #(.N(32))  pc_br_select(.sel(pc_src), .src1(pc_plus4), .src2(pc_br), .out(pc_br_next));
	mux2 #(.N(32))	pc_select(.sel(jmp), .src1(pc_br_next), .src2(pc_jmp), .out(pc_next));

    // lw 命令では inst[20:16], R 形式では inst[15:11] をディスティネーションに設定
    mux2 #(.N(5))  sel_dst(.sel(reg_dst), .src1(inst[20:16]), .src2(inst[15:11]), .out(reg_id));
    regfile         regfile(
        .ctrl_bus, .reg_write,
        .rs(inst[25:21]), .rt(inst[20:16]), .rd(reg_id),
        .reg_in, .rs_data(alu_in1), .rt_data(write_data)
    );
    sign_ext        sign_ext(.half(inst[15:0]), .full(imm));
    mux2 #(.N(32))  res_to_reg(.sel(mem_to_reg), .src1(alu_out), .src2(read_data), .out(reg_in));
    
    mux2 #(.N(32))  alu_src_sel(.sel(alu_src), .src1(write_data), .src2(imm), .out(alu_in2));
    alu #(.N(32))   alu(.src1(alu_in1), .src2(alu_in2), .alu_ctrl_sig, .alu_out, .zero);
endmodule