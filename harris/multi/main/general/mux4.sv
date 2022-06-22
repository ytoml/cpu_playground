module mux4 #(parameter N) (
    input   logic[1:0]      sel,
    input   logic[N-1:0]    src0, src1, src2, src3,
    output  logic[N-1:0]    out
);
    always_comb begin
        unique case(sel)
            2'b00:  out = src0;
            2'b01:  out = src1;
            2'b10:  out = src2;
            2'b11:  out = src3;
        endcase
    end
endmodule