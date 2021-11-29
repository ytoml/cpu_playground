`include "lib_cpu.svh"
module decoder import lib_cpu::*; (
    input   logic[5:0]  prefix, suffix,
    output  OPECODE     op,
    output  FUNCT       funct
);
    always_comb begin
        unique case (prefix)
            6'b000000:  op <= RTYPE;
            6'b100011:  op <= LW;
            6'b101011:  op <= SW;
            6'b000100:  op <= BEQ;
            6'b001000:  op <= ADDI;
            6'b000010:  op <= J;
            default:    op <= INVALID_OP;
        endcase
    end

    always_comb begin
        unique case (suffix)
            6'b100000:  funct <= ADD;
            6'b100010:  funct <= SUB;
            6'b100100:  funct <= AND;
            6'b100101:  funct <= OR;
            6'b101010:  funct <= SLT;
            default:    funct <= INVALID_FU;
        endcase
    end
endmodule