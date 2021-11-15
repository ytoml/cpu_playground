module imem (
    input   logic[5:0]  pc,
    output  logic[31:0] inst
);
    logic[31:0] IMEM[63:0];

    initial $readmemh("memfile.data", IMEM);
    assign inst = IMEM[pc];
    
endmodule