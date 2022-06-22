module sign_ext(
    input   logic[15:0] half,
    output  logic[31:0] full
);
    // 入力 bit の MSB を見て符号拡張
    assign full = {{16{half[15]}}, half};
endmodule 