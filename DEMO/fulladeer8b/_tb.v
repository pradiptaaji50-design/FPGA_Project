`timescale 1ns/1ps

module _tb;
    reg A, B, Cin, A1, B1, A2, B2, A3, B3, A4, B4, A5, B5, A6, B6, A7, B7;
    wire S, S1, S2, S3, S4, S5, S6, S7, CoutFinal;

    // Instansiasi modul
    main uut (
        .A(A), .B(B), .Cin(Cin),
        .A1(A1), .B1(B1), .A2(A2), .B2(B2), .A3(A3), .B3(B3), .A4(A4), .B4(B4),
        .A5(A5), .B5(B5), .A6(A6), .B6(B6), .A7(A7), .B7(B7),
        .S(S), .S1(S1), .S2(S2), .S3(S3), .S4(S4), .S5(S5), .S6(S6), .S7(S7),
        .CoutFinal(CoutFinal)
    );

    initial begin
        $dumpvars(0, _tb);

        // Kasus 1: 0 + 0
        {A7,A6,A5,A4,A3,A2,A1,A} = 8'd0;
        {B7,B6,B5,B4,B3,B2,B1,B} = 8'd0;
        Cin = 0; #10;

        // Kasus 2: 10 + 5 = 15
        {A7,A6,A5,A4,A3,A2,A1,A} = 8'd10;
        {B7,B6,B5,B4,B3,B2,B1,B} = 8'd5;
        Cin = 0; #10;

        // Kasus 3: 255 + 1 = 256 (Overflow, S7..S0 jadi 0, Cout=1)
        {A7,A6,A5,A4,A3,A2,A1,A} = 8'd255;
        {B7,B6,B5,B4,B3,B2,B1,B} = 8'd1;
        Cin = 0; #10;

        // Kasus 4: 127 + 127 + Cin(1) = 255
        {A7,A6,A5,A4,A3,A2,A1,A} = 8'd127;
        {B7,B6,B5,B4,B3,B2,B1,B} = 8'd127;
        Cin = 1; #10;

        $finish;
    end
endmodule