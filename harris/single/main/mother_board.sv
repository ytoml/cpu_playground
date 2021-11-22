module mother_board (
    ctrl_bus_if.central ctrl_bus,
    mem_bus_if.central  imem_bus,
    mem_bus_if.central  dmem_bus,
    output  logic       write_enab,
    output  logic[31:0] write_data,
);

    cpu     cpu(.ctrl_bus, .imem_bus, .write_enab, .write_data);
    memory  memory(.imem_bus, .dmem_bus, .ctrl_bus, .write_enab, .write_data);
    
endmodule