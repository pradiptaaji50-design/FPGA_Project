`timescale 1ns/1ps

module _tb;
    reg A, B, C, D;
    wire P;

    // Instansiasi modul OPG
    main uut (
        .A(A), .B(B), .C(C), .D(D),
        .P(P)
    );

    integer i;

    initial begin   
        $dumpvars(0, _tb);
    

        $display("A B C D | P | Total '1'");
        $display("--------|---|----------");

        for (i = 0; i < 16; i = i + 1) begin
            {A, B, C, D} = i;
            #10;
            $display("%b %b %b %b | %b | %0d", A, B, C, D, P, (A+B+C+D+P));
        end

        $finish;
    end
endmodule