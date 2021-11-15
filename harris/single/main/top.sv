module top(
    input   logic   clk, reset,
    output  logic[31:0] write_data, addr,
    output  logic       write_enab
);
    logic[31:0] pc, inst, read_data;

    mother_board    mother_board();
    dmem            dmem(.clk, .alu_res, .write_data, .write_enab, .read_data);
    imem            imem(.pc, .inst);
    
endmodule