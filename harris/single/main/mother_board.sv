module motherboard (
    ctrl_bus_if.central ctrl_bus,
    mem_bus_if.central  imem_bus,
    mem_bus_if.central  dmem_bus,
    output  logic       write_enab,
    output  logic[31:0] write_data,
);
    logic[5:0]  pc;
    logic[31:0] inst, 

    assign inst             = imem_bus.data;
    assign imem_bus.addr    = pc;

    cpu     cpu(.ctrl_bus, .imem_bus, .write_enab, .write_data);
    memory  memory(.imem_bus, .dmem_bus, .ctrl_bus, .write_enab, .write_data);
    
endmodule