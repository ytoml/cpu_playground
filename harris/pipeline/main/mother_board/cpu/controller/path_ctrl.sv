`include "lib_cpu.svh"
module path_ctrl import lib_cpu::*; (
    input   OPECODE     op,
    output  logic       mem_to_reg, mem_enab,
    output  logic       alu_srcB, branch,
    output  logic       reg_dst, reg_write,
    output  logic       jmp,
    output  logic[1:0]  alu_op
);
    logic[8:0]  ctrl_sigs;
    assign {
        mem_to_reg, mem_enab, alu_srcB, branch,
        reg_dst, reg_write, jmp, alu_op
    } = ctrl_sigs;

	// reg_write が 立つ命令では mem_to_reg, reg_dst を気にする必要がある
	// write_enab は常に気にする必要がある
	// branch は j 形式のみ上書きされるのでドントケアとして良い
	// alu_src は j 形式のみ ALU を使わないためドントケアとして良い 
    always_comb begin
        unique case (op)
            RTYPE:      ctrl_sigs <= 9'b000011010;
            LW:         ctrl_sigs <= 9'b101001000;
            SW:         ctrl_sigs <= 9'bx110x0000;
            BEQ:        ctrl_sigs <= 9'bx001x0001;
            ADDI:       ctrl_sigs <= 9'b001001000;
            J:          ctrl_sigs <= 9'bx0xxx01xx;
            default:    ctrl_sigs <= 9'bxxxxxxxxx;
        endcase
    end
    
endmodule