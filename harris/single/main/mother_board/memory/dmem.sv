module dmem (
    mem_bus_if.peripheral   dmem_bus,
    ctrl_bus_if.central  ctrl_bus,
    input   logic           write_enab,
    input   logic[31:0]     write_data,
);
    logic[31:0] DMEM[0:2**30-1];
	logic[29:0] word_index;
	// logic[1:0] word_offset;

	// DMEM は 4 byte 値の配列であることに注意(addr >> 2 が必要)
	assign word_index = dmem_bus.addr[31:2];
    assign dmem_bus.data = DMEM[word_index];

    always_ff @(posedge ctrl_bus.clk) begin
        if (write_enab) DMEM[word_index] <= write_data;
    end
    
endmodule