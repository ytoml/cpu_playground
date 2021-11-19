`include "lib_cpu.svh"
module path_ctrl import lib_cpu::*; (
    input   OPECODE     op,
    output  logic       mem_to_reg, write_enab,
    output  logic       alu_src, branch,
    output  logic       reg_dst, reg_write,
    output  logic       jmp,
    output  logic[1:0]  alu_op
);
    logic[8:0]  ctrl_sigs;
    assign {
        mem_to_reg, write_enab, alu_src, branch,
        reg_dst, reg_write, jmp, alu_op
    } = ctrl_sigs;

    always_comb begin
        unique case (op)
            RTYPE:      ctrl_sigs <= 9'b000011010;
            LW:         ctrl_sigs <= 9'b101001000;
            SW:         ctrl_sigs <= 9'b011000000;
            BEQ:        ctrl_sigs <= 9'b000100001;
            ADDI:       ctrl_sigs <= 9'b001001000;
            J:          ctrl_sigs <= 9'b000000100;
            default:    ctrl_sigs <= 9'bxxxxxxxxx;
        endcase
    end
    
endmodule