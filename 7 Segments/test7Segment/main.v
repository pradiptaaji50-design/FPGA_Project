module main (
    input  clk,       // Pin 21 (12MHz)
    input  rx,        // Pin 9 (UART RX)
    output [7:0] seg  // Output ke 7-segment
);

    // --- 1. UART RECEIVER (9600 BAUD) ---
    parameter CLKS_PER_BIT = 104;
    reg [2:0]  u_state = 0;
    reg [15:0] u_clk_count = 0;
    reg [2:0]  u_bit_index = 0;
    reg [7:0]  u_data = 0;
    reg        u_ready = 0;

    always @(posedge clk) begin
        case (u_state)
            0: begin u_ready <= 0; u_clk_count <= 0; u_bit_index <= 0; if (rx == 0) u_state <= 1; end
            1: begin if (u_clk_count == (CLKS_PER_BIT-1)/2) u_state <= 2; else u_clk_count <= u_clk_count + 1; end
            2: begin 
                if (u_clk_count < CLKS_PER_BIT-1) u_clk_count <= u_clk_count + 1;
                else begin u_clk_count <= 0; u_data[u_bit_index] <= rx; 
                    if (u_bit_index < 7) u_bit_index <= u_bit_index + 1; else u_state <= 3; 
                end
            end
            3: begin if (u_clk_count < CLKS_PER_BIT-1) u_clk_count <= u_clk_count + 1; else begin u_ready <= 1; u_state <= 0; end end
        endcase
    end

    // --- 2. MANUAL TESTER LOGIC ---
    reg [7:0] r_seg = 8'b00000000;

    always @(posedge clk) begin
        if (u_ready) begin
            case (u_data)
                8'h31: r_seg <= 8'b00000001; // Tekan '1' -> segmen a nyala
                8'h32: r_seg <= 8'b00000010; // Tekan '2' -> segmen b nyala
                8'h33: r_seg <= 8'b00000100; // Tekan '3' -> segmen c nyala
                8'h34: r_seg <= 8'b00001000; // Tekan '4' -> segmen d nyala
                8'h35: r_seg <= 8'b00010000; // Tekan '5' -> segmen e nyala
                8'h36: r_seg <= 8'b00100000; // Tekan '6' -> segmen f nyala
                8'h37: r_seg <= 8'b01000000; // Tekan '7' -> segmen g nyala
                8'h38: r_seg <= 8'b10000000; // Tekan '8' -> segmen DP nyala
                8'h30: r_seg <= 8'b00000000; // Tekan '0' -> Matikan semua
                8'h61: r_seg <= 8'b11111111; // Tekan 'a' -> Nyalakan semua (angka 8.)
                default: r_seg <= r_seg;     // Tetap di kondisi terakhir
            endcase
        end
    end

    // GANTI KE assign seg = ~r_seg; JIKA MENGGUNAKAN COMMON ANODE
    assign seg = r_seg; 

endmodule