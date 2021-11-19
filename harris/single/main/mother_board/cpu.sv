`include "lib_cpu.svh"
module cpu (
    mem_bus_if.central  imem_bus
);
    import lib_cpu::*;

    OPECODE  op, funct;
    decoder decoder(
        .prefix(imem_bus.data[31:26]),
        .suffix(imem_bus.data[5:0]),
        .op, .funct
    );

    controller  controller(.op, .funct);
    regfile     regfile();
    
endmodule