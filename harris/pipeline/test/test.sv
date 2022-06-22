`timescale 1ns/1ps
module test();
    logic       pin_clock, pin_n_reset, write_enab;
    logic[31:0] write_data, data_addr; 
    top         top(.*, .clk(pin_clock), .reset(pin_n_reset));

    initial pin_clock <= 1'b0;
    always #5 pin_clock <= ~pin_clock;

    initial begin
        pin_n_reset <= 1'b1;
        #10
        pin_n_reset <= 1'b0;
    end
    
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
        #1000
        $finish;
    end

    always @(negedge pin_clock) begin
        if (write_enab) begin
            if (data_addr === 84 && write_data === 7) begin 
                $display("Simulation Succeeded.");
                $stop;
            end else if (data_addr !== 80) begin 
                $display("Simulation Failed.");
                $stop;
            end
        end
    end

endmodule