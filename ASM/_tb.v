`timescale 1ns / 1ps

module _tb;

    // 1. Deklarasi Sinyal
    reg clk;
    reg r_input;      // Menggunakan nama r_input untuk menghindari konflik keyword
    wire w_output;    // Menggunakan nama w_output

    // 2. Instansiasi Unit Under Test (UUT)
    main uut (
        .clk(clk),
        .\input (r_input),  // Koneksi ke port dengan escape character
        .\output (w_output)
    );

    // 3. Generasi Clock (12 MHz ~ 83.33ns per periode)
    // Kita gunakan periode 20ns (50 MHz) agar lebih mudah dibaca di simulasi
    always #10 clk = ~clk;

    // 4. Prosedur Stimulus
    initial begin
        // Inisialisasi
        clk = 0;
        r_input = 0;

        // Tunggu beberapa saat setelah reset/initial state
        #25;

        // --- Skenario 1: Memberikan input 1 ---
        $display("Waktu: %0t | Input: %b | Output: %b", $time, r_input, w_output);
        r_input = 1;
        #20; // Tunggu satu siklus clock
        
        // --- Skenario 2: Memberikan input 0 ---
        r_input = 0;
        #20;
        
        // --- Skenario 3: Input 1 berulang untuk melihat perubahan state ---
        r_input = 1;
        #40;
        
        r_input = 0;
        #20;

        // Selesai simulasi
        $display("Simulasi Selesai.");
        $finish;
    end

    // 5. Monitoring (Opsional: untuk melihat perubahan di terminal)
    initial begin
        $monitor("Time: %0t | In: %b | Out: %b | S1(Q0): %b | S3(Q1): %b", 
                 $time, r_input, w_output, uut.s1, uut.s3);
    end

    // 6. Dump file untuk melihat Waveform (GTKWave)
    initial begin
       
        $dumpvars(0, _tb);
    end

endmodule