`timescale 1ns / 1ps

module testbench;
    reg a, b, sel;
    wire y;

    // Instantiate the design
    mux2to1 uut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    initial begin
        // Dump the waveform data
        $dumpfile("test.vcd");
        $dumpvars(0, testbench);

        // Test cases
        a = 0; b = 1; sel = 0; #10;
        a = 1; b = 0; sel = 1; #10;
        a = 0; b = 0; sel = 1; #10;
        a = 1; b = 1; sel = 0; #10;
        $finish;
    end
endmodule
