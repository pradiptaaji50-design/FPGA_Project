`timescale 1ns/1ps

module _tb;

    reg clk;
    wire [2:0] lamp;

    // Instantiate DUT
    main uut (
        .clk(clk),
        .lamp(lamp)
    );

    // Clock generator (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

     // 6. Dump file untuk melihat Waveform (GTKWave)
    initial begin
       
        $dumpvars(0, _tb);
    end

    // Simulation duration
    initial begin
        #100;
        $finish;
    end

endmodule