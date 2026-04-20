// --- Modul Utama (Top Level) ---
module main (
    input clk,       // Pin 21 (12 MHz Crystal)
    input rx,        // Pin 9 (UART RX dari USB)
    output led1,     // Pin 99 (Lampu Berkedip Otomatis)
    output reg led2, // Pin 98 (Lampu via Keyboard 'a'/'s')
    output reg led3, // Pin 97 (Lampu Toggle via 'd')
    output led4,     // Pin 96
    output led5      // Pin 95
);

    // Default state untuk LED
    initial begin
        led2 = 0;
        led3 = 0;
    end

    // --- PARALEL 1: Blinking LED (Heartbeat) ---
    // Logika ini berjalan independen tanpa terpengaruh proses lain
    reg [23:0] blink_counter;
    assign led1 = blink_counter[23]; 

    always @(posedge clk) begin
        blink_counter <= blink_counter + 1;
    end

    // --- PARALEL 2: UART Receiver Control ---
    wire [7:0] rx_data;
    wire rx_done;

    // Instansiasi modul UART RX
    uart_rx #(.CLK_FREQ(12000000), .BAUD_RATE(9600)) receiver (
        .clk(clk),
        .rx(rx),
        .data(rx_data),
        .done(rx_done)
    );

    // Logika kontrol LED berdasarkan input keyboard
    always @(posedge clk) begin
        if (rx_done) begin
            case (rx_data)
                8'h61: led2 <= 1;    // Huruf 'a' -> ON
                8'h73: led2 <= 0;    // Huruf 's' -> OFF
                8'h64: led3 <= ~led3; // Huruf 'd' -> Toggle
            endcase
        end
    end

    // LED sisa dimatikan
    assign led4 = 0;
    assign led5 = 0;

endmodule

// --- Modul Pendukung (UART Receiver) ---
module uart_rx #(
    parameter CLK_FREQ = 12000000,
    parameter BAUD_RATE = 9600
)(
    input clk,
    input rx,
    output reg [7:0] data,
    output reg done
);
    localparam WAIT_TIME = CLK_FREQ / BAUD_RATE;

    reg [3:0] state = 0;
    reg [15:0] count = 0;
    reg [2:0] bit_idx = 0;

    always @(posedge clk) begin
        case (state)
            0: begin // Idle: Menunggu Start Bit (Low)
                done <= 0;
                if (rx == 0) begin
                    if (count == WAIT_TIME / 2) begin
                        count <= 0;
                        state <= 1;
                    end else count <= count + 1;
                end else count <= 0;
            end
            1: begin // Data: Mengambil 8 bit data
                if (count == WAIT_TIME - 1) begin
                    count <= 0;
                    data[bit_idx] <= rx;
                    if (bit_idx == 7) begin
                        bit_idx <= 0;
                        state <= 2;
                    end else bit_idx <= bit_idx + 1;
                end else count <= count + 1;
            end
            2: begin // Stop Bit: Menutup transmisi
                if (count == WAIT_TIME - 1) begin
                    count <= 0;
                    done <= 1;
                    state <= 0;
                end else count <= count + 1;
            end
        endcase
    end
endmodule