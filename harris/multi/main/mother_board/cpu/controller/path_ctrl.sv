`include "lib_cpu.svh"
`include "lib_state.svh"
module path_ctrl import lib_cpu::*, lib_state::*; (
    ctrl_bus_if.central ctrl_bus,
    input   OPECODE     op,
	output	logic		i_or_d, ireg_enab,
	output	logic		pc_src, pc_write, branch,
    output  logic       mem_to_reg, mem_enab,
    output  logic       reg_dst, reg_write,
	output	logic		alu_srcA,
    output  logic[1:0]  alu_srcB, alu_op 
);

	STATE		state;
    logic[13:0]  ctrl_sigs;
    assign {
		i_or_d, ireg_enab,
		pc_src, pc_write, branch,
        mem_to_reg, mem_enab,
        reg_dst, reg_write,
		alu_srcA, alu_srcB, alu_op
    } = ctrl_sigs;

	// reg_write が 立つ命令では mem_to_reg, reg_dst を気にする必要がある
	// write_enab は常に気にする必要がある
	// branch は j 形式のみ上書きされるのでドントケアとして良い
	// alu_src は j 形式のみ ALU を使わないためドントケアとして良い 
	// FSM の状態に応じて決まる
    always_comb begin
        unique case (state)
            FETCH:      ctrl_sigs <= 14'b01_01x_xx_xx_00100;	// 
			// DECODE:		ctrl_sigs <= 14'b
           
            default:    ctrl_sigs <= 14'bx;
        endcase
    end

	always_ff @(posedge ctrl_bus.clk or posedge ctrl_bus.reset) begin
		if (ctrl_bus.reset) state <= FETCH;
		
	end
    
endmodule