module dmem (
    mem_bus_if.peripheral   dmem_bus,
    ctrl_bus_if.central  ctrl_bus,
    input   logic           write_enab,
    input   logic[31:0]     write_data,
);
    logic[31:0] DMEM[64];
    // logic[29:0] word_addr;
    // assign word_addr = alu_res[31:2];
    // assign read_data = DMEM[word_addr];
    assign dmem_bus.data = DMEM[dmem_bus.addr];

    always_ff @(posedge ctrl_bus.clk) begin
        if (write_enab) DMEM[dmem_bus.addr] <= write_data;
    end
    
endmodule