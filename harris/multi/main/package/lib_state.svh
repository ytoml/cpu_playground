`ifndef LIB_STATE_SVH
`define LIB_STATE_SVH
package lib_state;
    typedef enum logic[3:0] {
        FETCH, DECODE, 
        MEM_ADDR, MEM_READ, MEM_TO_REG, MEM_WRITE,
        EXECUTE, ALU_TO_REG,
        BRANCH,
        /* ADDI_EXEC, */ ADDI_TO_REG,
        JUMP,
        INVALID_ST
    } STATE;
endpackage
`endif /* LIB_STATE_SVH */