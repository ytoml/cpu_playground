module alu #(parameter N)(
    input   logic[N-1:0] src1, src2,
    input   logic[2:0]  alu_ctrl_sig,
    output  logic[N-1:0] alu_res,
    output  logic       zero
);

	logic[31:0]	sub;
	assign sub = src1 - src2;
    // MIPS の ALU にはオーバーフローフラグがない
    always_comb begin
        unique case (alu_ctrl_sig)
            3'b000: alu_res = src1 & src2;
            3'b001: alu_res = src1 | src2;
            3'b010: alu_res = src1 + src2;
            3'b011: alu_res = 32'bx;                    // 使用しない
            3'b100: alu_res = src1 & ~src2;
            3'b101: alu_res = src1 | ~src2;
            3'b110: alu_res = sub;
            3'b111: alu_res = {{N-1{1'b0}}, sub[N-1]};   // set less than
            default: alu_res = 32'bx;
        endcase
    end
    assign zero = alu_res == 0;
    
endmodule