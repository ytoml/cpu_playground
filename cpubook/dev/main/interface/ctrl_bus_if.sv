// クロック等の制御バスとの接続
interface ctrl_bus_if();
	logic clk, n_reset;
	modport master(input clk, input n_reset);
endinterface