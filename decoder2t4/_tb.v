`timescale 1ns/1ps

module _tb;
    reg I0, I1;
    wire O0, O1, O2, O3;

    // Instansiasi modul utama
    main uut (
        .I0(I0), .I1(I1),
        .O0(O0), .O1(O1), .O2(O2), .O3(O3)
    );

    initial begin
        $dumpvars(0, _tb);

        // Uji semua kombinasi input
        {I1, I0} = 2'b00; #10;
        {I1, I0} = 2'b01; #10;
        {I1, I0} = 2'b10; #10;
        {I1, I0} = 2'b11; #10;

        $finish;
    end
endmodule