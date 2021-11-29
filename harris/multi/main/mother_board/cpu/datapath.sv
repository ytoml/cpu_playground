`include "lib_cpu.svh"
module datapath(
    ctrl_bus_if.central ctrl_bus,
    mem_bus_if.central  mem_bus,
	output	OPECODE		op,
	output	FUNCT		funct,
    output  logic       zero,
    input   logic       mem_to_reg,
    input   logic       pc_src, alu_srcA,
    input   logic[1:0]	alu_srcB,
    input   logic       reg_dst, reg_write,
    input   logic       jmp,
	input	logic		ireg_write_enab,
	input	logic		pc_write_enab,
	input	logic		i_or_d,
    input   logic[2:0]  alu_ctrl_sig,
    output  logic[31:0] write_data
);
    logic[31:0] alu_out, inst, imm, reg_in, read_data;
    logic[31:0] pc, pc_plus4, pc_next, pc_br, pc_br_next, br_offset, pc_jmp;
    logic[31:0] rs_out, rs_to_A, rt_out, alu_inA, alu_inB, alu_res;
    logic[4:0]  reg_id;

	// メモリのアドレス選択
	mux2 #(.N(32))	sel_addr(.sel(i_or_d), .src0(pc), .src1(alu_out), .out(mem_bus.addr))

	// メモリから読んできたデータを命令/データレジスタに格納
	enab_ff #(.N(32))	ireg(.ctrl_bus, .enab(ireg_write_enab), .in(mem_bus.data), .out(inst))
	ff		#(.N(32))	dreg(.ctrl_bus, .in(mem_bus.data), .out(read_data));
    
    decoder decoder(
        .prefix(inst[31:26]),
        .suffix(inst[5:0]),
        .op, .funct
    );

	// PC 制御
	enab_ff #(.N(32))	pcreg(.ctrl_bus, .enab(pc_write_enab), .in(pc_next), .out(pc));
	assign br_offset	= { imm[29:0], 2'b00 };
	assign pc_br		= pc_plus4 + br_offset;
	assign pc_jmp		= { pc_plus4[31:28], inst[25:0], 2'b00 }; // word(4byte) alignment

	// beq は 次の命令(pc_plus4) からの相対でアドレシング、j は(擬似)直接アドレシング
    mux2 #(.N(32))  pc_br_select(.sel(pc_src), .src0(pc_plus4), .src1(pc_br), .out(pc_br_next));
	mux2 #(.N(32))	pc_select(.sel(jmp), .src0(pc_br_next), .src1(pc_jmp), .out(pc_next));

    // lw 命令では inst[20:16], R 形式では inst[15:11] をディスティネーションに設定
    mux2 #(.N(5))  sel_dst(.sel(reg_dst), .src0(inst[20:16]), .src1(inst[15:11]), .out(reg_id));
    regfile         regfile(
        .ctrl_bus, .reg_write,
        .rs(inst[25:21]), .rt(inst[20:16]), .rd(reg_id),
        .reg_in, .rs_data(rs_out), .rt_data(rt_out)
    );
	ff #(.N(32))	rs_buf(.ctrl_bus, .in(rs_out), .out(rs_to_A));
	ff #(.N(32))	rt_buf(.ctrl_bus, .in(rt_out), .out(write_data));

    sign_ext        sign_ext(.half(inst[15:0]), .full(imm));
    mux2 #(.N(32))  res_to_reg(.sel(mem_to_reg), .src0(alu_out), .src1(read_data), .out(reg_in));
    
    mux2 #(.N(32))  alu_srcA_sel(.sel(alu_srcA), .src0(pc), .src1(imm), .out(alu_inA));
	mux4 #(.N(32))	alu_srcB_sel(.sel(alu_srcB), .src1(32'b100), .src2(imm), .src3(br_offset), .out(alu_inB));
    alu #(.N(32))   alu(.src0(alu_inA), .src1(alu_inB), .alu_ctrl_sig, .alu_res, .zero);
    ff	#(.N(32))	alu_buf(.ctrl_bus, .in(alu_res), .out(alu_out));
endmodule