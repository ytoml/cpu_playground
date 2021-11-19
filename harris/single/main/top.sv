module top(
    input   logic       clk, reset,
    output  logic[31:0] write_data, data_addr,
    output  logic       write_enab
);
    mem_bus_if #(.ADDR_WIDTH(6), .DATA_WIDTH(32)) imem_bus();

    mem_bus_if #(.ADDR_WIDTH(32), .DATA_WIDTH(32)) dmem_bus();
    assign data_addr        = dmem_bus.addr;

    ctrl_bus_if ctrl_bus();
    assign ctrl_bus.clk     = clk;
    assign ctrl_bus.reset   = reset;

    mother_board    mother_board(.ctrl_bus, .imem_bus, .dmem_bus, .write_enab, .write_data);
    
endmodule