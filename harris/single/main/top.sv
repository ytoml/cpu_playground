module top(
    input   logic   clk, reset,
    output  logic[31:0] write_data, addr,
    output  logic       write_enab
);
    logic[31:0] pc, inst, read_data;
    logic[31:0] alu_res;

    mem_bus_if #(.ADDR_WIDTH(6), .DATA_WIDTH(32)) imem_bus();
    assign imem_bus.addr = pc[7:2];
    assign imem_bus.data = inst;

    // TODO: データアドレスをどこから持ってくるか怪しいので確認
    mem_bus_if #(.ADDR_WIDTH(6), .DATA_WIDTH(32)) dmem_bus();
    assign dmem_bus.addr = alu_res[5:0];
    assign dmem_bus.data = read_data;

    ctrl_bus_if ctrl_bus();
    assign ctrl_bus.clk     = clk;
    assign ctrl_bus.reset   = clk;

    mother_board    mother_board(.ctrl_bus);
    memory          memory(.imem_bus, .dmem_bus, .ctrl_bus);
    
endmodule