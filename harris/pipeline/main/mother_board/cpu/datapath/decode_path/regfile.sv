module regfile( 
    ctrl_bus_if.central ctrl_bus,
    input   logic       reg_write,
    input   logic[4:0]  rs, rt, rd, // rs, rt はソース、rd はディスティネーション
    input   logic[31:0] reg_in,        // rd に書き込むデータ
    output  logic[31:0] rs_data, rt_data
);
    logic [31:0] REGS[31:0];
    // サイクルの前半で writeback して後半で regfile から読むという流れに、negedge 更新にすることで対応
    always_ff @(negedge ctrl_bus.clk or posedge ctrl_bus.reset) begin
        if(ctrl_bus.reset) begin
            for(int i = 0; i < 32; i++) REGS[i] = 32'b0;
        end else if (reg_write) begin
            REGS[rd] <= reg_in;
        end
    end

    // ゼロレジスタは常に 0 であることに注意
    assign rs_data = (rs == 0) ? 0 : REGS[rs];
    assign rt_data = (rt == 0) ? 0 : REGS[rt];
endmodule