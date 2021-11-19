module regfile( 
    ctrl_bus_if.central ctrl_bus,
    input   logic       reg_write,
    input   logic[5:0]  rs, rt, rd, // rs, rt はソース、rd はディスティネーション
    output  logic[31:0] rs_data, rt_data
);
    
endmodule