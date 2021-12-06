`include "lib_cpu.svh"
`include "lib_state.svh"
module path_ctrl import lib_cpu::*, lib_state::*; (
	ctrl_bus_if.central ctrl_bus,
	input   OPECODE		op,
	output	logic		i_or_d, ireg_enab,
	output	logic[1:0]	pc_src,
	output	logic		pc_write, branch,
	output  logic		mem_to_reg, mem_enab,
	output  logic		reg_dst, reg_write,
	output	logic		alu_srcA,
	output  logic[1:0]  alu_srcB, alu_op 
);

	STATE		state;
	logic[14:0]  ctrl_sigs;
	// 配線の並びは、前半がマルチプレクサ or ALU のセレクタ、後半が各レジスタのイネーブル信号
	// 前半は、状態に関係がない場合ドントケアとして良く、後半は更新しない場合も常に0である必要がある
	assign {
		i_or_d, pc_src,
		reg_dst, mem_to_reg,
		alu_srcA, alu_srcB, alu_op,
		ireg_enab, pc_write, branch, reg_write, mem_enab
	} = ctrl_sigs;

	always_comb begin
		unique case (state)
			FETCH:			ctrl_sigs <= 15'b000_xx_00100_11000;	// フェッチ時に ALU が空いているため pc+4 を計算しておく(i_or_reg が 0 であるため、alu_srcA/B をうまく選べば可能)
			DECODE:			ctrl_sigs <= 15'bxxx_xx_01100_00000;	// デコード時は単に1サイクル待機するが、BRANCH 用に pc+4+(imm<<2) を計算しておく
			MEM_ADDR:		ctrl_sigs <= 15'bxxx_xx_11000_00000;	// 相対アドレスを計算
			MEM_READ:		ctrl_sigs <= 15'b1xx_xx_xxxxx_00000;	// アクセスしたデータを読むために i_or_reg=1
			MEM_TO_REG:		ctrl_sigs <= 15'bxxx_01_xxxxx_00010;
			MEM_WRITE:		ctrl_sigs <= 15'b1xx_xx_xxxxx_00001;
			EXECUTE:		ctrl_sigs <= 15'bxxx_xx_10010_00000; // 2つのソースレジスタを使った計算を ALU で行う
			ALU_TO_REG:		ctrl_sigs <= 15'bxxx_10_xxxxx_00010; // RTYPE ではディスティネーションレジスタが inst[16:11] で指定される
			BRANCH:			ctrl_sigs <= 15'bx01_10_10001_00100; // ALU で2つのソースレジスタの値を引いて、0ならば分岐
			// ADDI_EXEC:		ctrl_sigs <= 15'bxxx_xx_11000_00000; // MEM_ADDR と同一
			ADDI_TO_REG:	ctrl_sigs <= 15'bxxx_00_xxxxx_00010;	// RTYPE ではディスティネーションレジスタが inst[20:16] で指定される
			JUMP			ctrl_sigs <= 15'bx10_xx_xxxxx_01000;
			default:	ctrl_sigs <= 15'bx;
		endcase
	end

	always_ff @(posedge ctrl_bus.clk or posedge ctrl_bus.reset) begin
		if (ctrl_bus.reset) state <= FETCH;
		unique case (state)
			FETCH:	state <= DECODE;
			DECODE:	unique case (op)
				RTYPE:		state <= EXECUTE;
				LW, SW:		state <= MEM_ADDR;
				BEQ:		state <= BRANCH;
				ADDI:		state <= MEM_ADDR; // ADDI_EXEC;
				J:			state <= JUMP;
				default:	state <= INVALID_ST;
			endcase
			MEM_ADDR: unique case (op)
				LW:			state <= MEM_READ;
				SW:			state <= MEM_WRITE;
				ADDI:		state <= ADDI_TO_REG;
				default:	state <= INVALID_ST;
			endcase
			MEM_READ:		state <= MEM_TO_REG;
			EXECUTE:		state <= ALU_TO_REG;
			// ADDI_EXEC:		state <= ADDI_TO_REG;
			MEM_TO_REG, MEM_WRITE, BRANCH, ADDI_TO_REG, JUMP:
							state <= FETCH;
			default:		state <= INVALID_ST;
		endcase
	end


	
endmodule