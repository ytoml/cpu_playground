module dmem (
    mem_bus_if.peripheral   dmem_bus,
    ctrl_bus_if.central  ctrl_bus,
    input   logic           write_enab,
    input   logic[31:0]     write_data,
);
    logic[31:0] DMEM[0:2**32-1];
    assign dmem_bus.data = DMEM[dmem_bus.addr];

    always_ff @(posedge ctrl_bus.clk) begin
        if (write_enab) DMEM[dmem_bus.addr] <= write_data;
    end
    
endmodule