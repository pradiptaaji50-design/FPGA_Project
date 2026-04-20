module main (
    input clk,      // Pin 21
    input rx,       // Pin 9
    output reg tx,  // Pin 8
    output reg [4:0] led // Pin 95-99
);

    // Parameter Baud Rate (12MHz / 9600)
    parameter CLK_PER_BIT = 1250;

    // --- BAGIAN 1: UART TRANSMITTER (Kirim 'A' terus menerus) ---
    reg [10:0] tx_clk_count = 0;
    reg [3:0]  tx_bit_index = 0;
    reg [7:0]  tx_data = 8'h41; // Karakter 'A'
    reg [1:0]  tx_state = 0;

    always @(posedge clk) begin
        if (tx_clk_count < CLK_PER_BIT - 1) begin
            tx_clk_count <= tx_clk_count + 1;
        end else begin
            tx_clk_count <= 0;
            case (tx_state)
                0: begin tx <= 0; tx_state <= 1; end // Start Bit
                1: begin // Data Bits
                    tx <= tx_data[tx_bit_index];
                    if (tx_bit_index < 7) tx_bit_index <= tx_bit_index + 1;
                    else begin tx_bit_index <= 0; tx_state <= 2; end
                end
                2: begin tx <= 1; tx_state <= 0; end // Stop Bit & Loop
            endcase
        end
    end

    // --- BAGIAN 2: UART RECEIVER (Terima input Keyboard) ---
    reg [10:0] rx_clk_count = 0;
    reg [3:0]  rx_bit_index = 0;
    reg [7:0]  rx_data_out = 0;
    reg [1:0]  rx_state = 0;
    reg        rx_ready = 0;

    always @(posedge clk) begin
        case (rx_state)
            0: begin // IDLE: Cari Start Bit
                rx_ready <= 0;
                if (rx == 0) begin
                    if (rx_clk_count < (CLK_PER_BIT/2)) rx_clk_count <= rx_clk_count + 1;
                    else begin rx_clk_count <= 0; rx_state <= 1; end
                end
            end
            1: begin // Ambil Data
                if (rx_clk_count < CLK_PER_BIT - 1) rx_clk_count <= rx_clk_count + 1;
                else begin
                    rx_clk_count <= 0;
                    rx_data_out[rx_bit_index] <= rx;
                    if (rx_bit_index < 7) rx_bit_index <= rx_bit_index + 1;
                    else begin rx_bit_index <= 0; rx_state <= 2; end
                end
            end
            2: begin // Stop Bit
                if (rx_clk_count < CLK_PER_BIT - 1) rx_clk_count <= rx_clk_count + 1;
                else begin rx_clk_count <= 0; rx_ready <= 1; rx_state <= 0; end
            end
        endcase
    end

    // --- BAGIAN 3: KONTROL LED ---
    always @(posedge clk) begin
        if (rx_ready) begin
            case (rx_data_out)
                8'h31: led <= 5'b00001; // Tekan '1'
                8'h32: led <= 5'b00010; // Tekan '2'
                8'h33: led <= 5'b00100; // Tekan '3'
                8'h30: led <= 5'b00000; // Tekan '0' (Mati)
            endcase
        end
    end

endmodule