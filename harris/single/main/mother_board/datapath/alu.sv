module alu #(parameter N)(
    input   logic[N-1:0] src1, src2,
    input   logic[2:0]  alu_ctrl_sig,
    output  logic[N-1:0] alu_out,
    output  logic       zero
);

    // MIPS の ALU にはオーバーフローフラグがない
    always_comb begin
        unique case (alu_ctrl_sig)
            3'b000: alu_out = src1 & src2;
            3'b001: alu_out = src1 | src2;
            3'b010: alu_out = src1 + src2;
            3'b011: alu_out = 32'bx;                    // 使用しない
            3'b100: alu_out = src1 & ~src2;
            3'b101: alu_out = src1 | ~src2;
            3'b110: alu_out = src1 | ~src2;
            3'b111: alu_out = {0, (src1 - src2)[N-1]}   // set less than (この文法が正しいか怪しい)
        endcase
    end
    assign zero = alu_out == 0;
    
endmodule