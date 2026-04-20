`timescale 1ns/1ps

module _tb;
    reg OB, CLK, RST;
    wire RR, RL;

    // Instansiasi modul utama
    main uut (
        .OB(OB),
        .CLK(CLK),
        .RST(RST),
        .RR(RR),
        .RL(RL)
    );

    // Generator Clock (Periode 20ns = 50MHz)
    always #10 CLK = ~CLK;

    initial begin
        // Inisialisasi
        CLK = 0; OB = 0; RST = 1;
        #25 RST = 0; // Lepas Reset

        // Skenario 1: OB Dinyalakan
        #20 OB = 1;
        #100;

        // Skenario 2: OB Dimatikan
        #20 OB = 0;
        #100;

        // Skenario 3: Reset saat berjalan
        #20 OB = 1;
        #40 RST = 1;
        #20 RST = 0;

        #100 $finish;
    end

    initial begin
        $dumpvars(0, _tb);
    end
endmodule