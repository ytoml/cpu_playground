module prescaler #(parameter RATIO = 2) (
	input logic quick_clock,
	output logic slow_clock
);
	logic [31:0] counter, next_counter;
	logic inv;

	initial begin
		counter <= 32'd0;
		slow_clock <= 1'b0;
	end

	// counter が RATIO/2 - 1 だけインクリメントされたら、次のクロックで slow_clock を動かす
	assign inv = (counter == (RATIO/2 - 1));

	assign next_counter = inv ? 32'd0 : counter + 32'd1;
	always_ff @(posedge quick_clock) counter <= next_counter;

	logic next_slow_clock;
	assign next_slow_clock = inv ? ~slow_clock : slow_clock;
	always_ff @(posedge quick_clock) slow_clock <= next_slow_clock;

endmodule