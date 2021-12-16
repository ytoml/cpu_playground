`ifndef LIB_CPU_SVH
`define LIB_CPU_SVH
package lib_cpu;
    typedef enum logic[5:0] {
        RTYPE,
        LW,
        SW,
        BEQ,
        ADDI,
        J,
        INVALID_OP
    } OPECODE;

    typedef enum logic[5:0] {
        ADD,
        SUB,
        AND,
        OR,
        SLT,
        INVALID_FU
    } FUNCT;
endpackage
`endif // LIB_CPU_SVH