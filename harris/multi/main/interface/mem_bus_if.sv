// メモリモジュール(rom)との接続
interface mem_bus_if #(parameter ADDR_WIDTH, DATA_WIDTH) ();
	logic					enab;
	logic[ADDR_WIDTH-1:0]	addr;
	logic[DATA_WIDTH-1:0]	data;
	modport	central(output enab, output addr, input data);
	modport	peripheral(input enab, input addr, output data);
endinterface