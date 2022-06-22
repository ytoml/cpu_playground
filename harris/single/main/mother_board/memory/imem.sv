module imem (
    mem_bus_if.peripheral imem_bus
);
    logic[31:0] IMEM[63:0];

    initial $readmemh("rom_data.mem", IMEM);
    // inst <- ROM[pc]
    // pc は 各 byte に対するアドレスを表すのに対しこの IMEM は命令(4byte)ごとの値を示しているため、配列インデックスに直すには pc >> 2 とする
    assign imem_bus.data = IMEM[imem_bus.addr[7:2]]; 
endmodule