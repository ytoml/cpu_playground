`include "lib_cpu.svh"
module alu_ctrl(
    input   FUNCT       funct,
    input   logic[1:0]  alu_op,
    output  logic[2:0]  alu_ctrl_sig,
);
    always_comb begin
        unique case (alu_op)
            2'b00:      alu_ctrl_sig <= 3'b010; // add(lw/sw/addi に対応)
            2'b01:      alu_ctrl_sig <= 3'b110; // sub(beq に対応)
            default:    unique case (funct)
                ADD:        alu_ctrl_sig <= 3'b010;
                SUB:        alu_ctrl_sig <= 3'b110;
                AND:        alu_ctrl_sig <= 3'b000;
                OR:         alu_ctrl_sig <= 3'b001;
                SLT:        alu_ctrl_sig <= 3'b111;
                default:    alu_ctrl_sig <= 3'bxxx;
            endcase
        endcase
    end
endmodule