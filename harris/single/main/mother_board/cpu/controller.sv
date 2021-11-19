module controller(
    input   OPECODE op,
    input   FUNCT   funct,
    output  logic   mem_to_reg, write_enab,

);
    alu_ctrl    alu_ctrl();
    path_ctrl   path_ctrl();
    
endmodule