module memory(
    ctrl_bus_if.central     ctrl_bus,
    mem_bus_if.peripheral   imem_bus,
    mem_bus_if.peripheral   dmem_bus,
    input   logic[31:0]     write_data
);
    imem    imem(.*);
    dmem    dmem(.*);
endmodule