module mother_board (
    ctrl_bus_if.central ctrl_bus,
    output  logic       write_enab,
    output  logic[31:0] write_data, data_addr
);
    mem_bus_if #(.ADDR_WIDTH(32), .DATA_WIDTH(32)) imem_bus();

    mem_bus_if #(.ADDR_WIDTH(32), .DATA_WIDTH(32)) dmem_bus();
    assign data_addr = dmem_bus.addr;

    cpu     cpu(.*);
    memory  memory(.*);
endmodule