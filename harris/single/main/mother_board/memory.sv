module memory(
    mem_bus_if.peripheral   imem_bus,
    mem_bus_if.peripheral   dmem_bus,
    ctrl_bus_if.central     ctrl_bus,
    input   logic           write_enab,
    input   logic[31:0]     write_data
);
    imem    imem(.imem_bus);
    dmem    dmem(.dmem_bus, .ctrl_bus, .write_enab, .write_data);
endmodule