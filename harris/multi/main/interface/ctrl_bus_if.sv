// クロック等の制御バスとの接続
interface ctrl_bus_if();
	logic clk, reset;
	modport central(input clk, input reset);
endinterface