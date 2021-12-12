module mux2 #(parameter N) (
    input	logic			sel,
    input	logic[N-1:0]	src0, src1,
    output	logic[N-1:0]	out
);
    assign out = sel ? src1 : src0;
endmodule