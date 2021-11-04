`include "main/package/lib_cpu.svh"
`include "main/package/lib_operation.svh"
`include "main/package/lib_stage.svh"
module alu import lib_cpu::*, lib_operation::*, lib_stage::*; (
	input	STAGE		stage,
	input	OPECODE		opecode,
	input	logic[3:0]	imm,
	input	logic[3:0]	switch,
	input	REGS		cur,
	output	REGS		next,
);
	always_comb begin
		if (stage == EXECUTE) begin
			unique case (opecode)
				ADD_A_IMM:	next = add_a_imm(cur, imm);
				ADD_B_IMM:	next = add_b_imm(cur, imm);
				MOV_A_IMM:	next = mov_a_imm(cur, imm);
				MOV_B_IMM:	next = mov_b_imm(cur, imm);
				MOV_A_B:	next = mov_a_b(cur);
				MOV_B_A:	next = mov_b_a(cur);
				JMP_IMM:	next = jmp_imm(cur, imm);
				JNC_IMM:	next = jnc_imm(cur, imm);
				IN_A:		next = in_a(cur, switch);
				IN_B:		next = in_b(cur, switch);
				OUT_B:		next = out_b(cur);
				OUT_IMM:	next = out_imm(cur, imm);
				default:	next = nop(cur);
			endcase
		end 
	end
endmodule