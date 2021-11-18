module memory(
    mem_bus_if.peripheral imem_bus,
    mem_bus_if.peripheral dmem_bus,
    ctrl_bus_if.central ctrl_bus,
);
    imem    imem(.imem_bus);
    dmem    dmem(.dmem_bus, .ctrl_bus);
    
endmodule