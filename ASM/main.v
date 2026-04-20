module DIG_D_FF_1bit
#(
    parameter Default = 0
)
(
   input D,
   input C,
   output Q,
   output \~Q
);
    reg state;

    assign Q = state;
    assign \~Q = ~state;

    always @ (posedge C) begin
        state <= D;
    end

    initial begin
        state = Default;
    end
endmodule


module main (
  input clk,
  input \input ,
  output \output 
);
  wire s0;
  wire s1;
  wire s2;
  wire s3;
  assign s0 = ((s1 | s3) ^ \input );
  assign \output  = (\input  & s3);
  DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i0 (
    .D( s0 ),
    .C( clk ),
    .Q( s1 ),
    .\~Q ( s2 )
  );
  DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i1 (
    .D( s2 ),
    .C( clk ),
    .Q( s3 )
  );
endmodule
