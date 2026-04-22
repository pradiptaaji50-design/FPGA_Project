module top(
    input  [7:0] A,
    input  [7:0] B,
    input        CIN,
    output [7:0] SUM,
    output       COUT
);

assign {COUT, SUM} = A + B + CIN;

endmodule