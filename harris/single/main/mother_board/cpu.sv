`include "lib_cpu.svh"
module cpu import lib_cpu::*; (
    mem_bus_if.central  imem_bus
);
    OPECODE  op, funct;
    decoder decoder(.imem_mus);

    controller  controller(.op, .funct);
    regfile     regfile();
    
endmodule