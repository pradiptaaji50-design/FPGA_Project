module main (
    input clk,
    output reg [2:0] lamp
);

    // State encoding
    reg [1:0] state;

    // State definition
    localparam S0 = 2'b00;  // Merah
    localparam S1 = 2'b01;  // Kuning
    localparam S2 = 2'b10;  // Hijau

    // Initial state
    initial begin
        state = S0;
    end

    // State transition
    always @(posedge clk) begin
        case (state)
            S0: state <= S1;
            S1: state <= S2;
            S2: state <= S0;
            default: state <= S0;
        endcase
    end

    // Output logic (Moore Machine)
    always @(*) begin
        case (state)
            S0: lamp = 3'b100; // Merah
            S1: lamp = 3'b010; // Kuning
            S2: lamp = 3'b001; // Hijau
            default: lamp = 3'b000;
        endcase
    end

endmodule