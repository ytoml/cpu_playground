module imem (
    mem_bus_if.central imem_bus
);
    logic[31:0] IMEM[64];

    initial $readmemh("memfile.data", IMEM);
    // inst <- ROM[pc]
    assign imem_bus.data = IMEM[imem_bus.addr];
    
endmodule