`timescale 1ns/1ps

module _tb;
    reg clk;
    reg S1;
    wire out;

    // Instansiasi modul utama
    main uut (
        .clk(clk),
        .S1(S1),
        .out(out)
    );

    // Generator Clock (periode 10ns)
    always #5 clk = ~clk;

    initial begin
        $dumpvars(0, _tb);

        // Inisialisasi
        clk = 0;
        S1 = 0;

        // Beri input pulsa S1
        #12 S1 = 1; // Set S1 jadi 1
        #10 S1 = 0; // Balikkan ke 0 setelah 1 siklus
        
        // Tunggu beberapa siklus untuk melihat pergeseran
        #100;

        $finish;
    end
endmodule