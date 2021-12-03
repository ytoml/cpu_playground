module memory(
    ctrl_bus_if.central     ctrl_bus,
    mem_bus_if.peripheral   mem_bus,
    input   logic           mem_enab,
    input   logic[31:0]     write_data,

);
    ram		ram(.*);
endmodule