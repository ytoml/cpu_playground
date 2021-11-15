module imem #( parameter WIDTH=32 ) (
    input   logic   addr,
    output  logic   inst
);
    logic [WITDH-1:0] IMEM;

    initial $readmemh("memfile.data", IMEM);
    assign inst = IMEM[addr];

    
endmodule