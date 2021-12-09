module ram (
    ctrl_bus_if.central  ctrl_bus,
    mem_bus_if.peripheral   mem_bus,
    input   logic[31:0]     write_data
);
    // ひとまず小さめに RAM を取ることにして、大きいアドレスにアクセスしないようにしておく
    logic[31:0] RAM[63:0]; // logic[31:0] DMEM[0:2**30-1]; 
	logic[29:0] word_index;
	// logic[1:0] word_offset;

	// DMEM は 4 byte 値の配列であることに注意(addr >> 2 が必要)
	assign word_index = mem_bus.addr[31:2];
    assign mem_bus.data = RAM[word_index];

    initial $readmemh("rom_data.mem", RAM);

    always_ff @(posedge ctrl_bus.clk) begin
        if (mem_bus.enab) RAM[word_index] <= write_data;
    end
    
endmodule