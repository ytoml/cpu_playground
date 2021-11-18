module motherboard (
    mem_bus_if.central  imem_bus,
    mem_bus_if.central  dmem_bus,
    ctrl_bus_if.central ctrl_bus,
    output  logic       write_enab,
    output  logic[31:0] write_data,
);
    logic[5:0]  pc;
    logic[31:0] inst, 

    assign inst             = imem_bus.data;
    assign imem_bus.addr    = pc;

    datapath    datapath(.ctrl_bus)
    
endmodule