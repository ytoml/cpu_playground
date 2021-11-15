module dmem (
    input   logic       clk,　write_enab,
    input   logic[31:0] alu_res, write_data,
    output  logic[31:0] read_data
);
    logic[31:0] DMEM[63:0];
    logic[29:0] word_addr;
    assign word_addr = alu_res[31:2];
    assign read_data = DMEM[word_addr];

    always_ff @(posedge clk) begin
        if (write_enab) DMEM[word_addr] <= write_data;
    end
    
endmodule