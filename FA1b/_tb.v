`timescale 1ns/1ps

module _tb;

    reg A;
    reg B;
    reg Cin;

    wire Cout;
    wire S;

    // Instantiate DUT
    main uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .S(S)
    );

    // 6. Dump file untuk melihat Waveform (GTKWave)
    initial begin
       
        $dumpvars(0, _tb);
    end

    initial begin
        $display("A B Cin | S Cout");
        $monitor("%b %b  %b  | %b   %b", A, B, Cin, S, Cout);

        // Semua kombinasi 000 → 111
        A=0; B=0; Cin=0; #10;
        A=0; B=0; Cin=1; #10;
        A=0; B=1; Cin=0; #10;
        A=0; B=1; Cin=1; #10;
        A=1; B=0; Cin=0; #10;
        A=1; B=0; Cin=1; #10;
        A=1; B=1; Cin=0; #10;
        A=1; B=1; Cin=1; #10;

        $finish;
    end

endmodule