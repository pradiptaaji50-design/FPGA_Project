// Modul LED Bernafas untuk semua LED
module main (
    input wire clk,          // Clock input (12MHz untuk iCEStick)
    output wire [4:0] leds   // Output 5 bit untuk 5 LED
);

    reg [23:0] counter;      // Counter untuk timing (kecepatan nafas)
    reg [7:0] duty_cycle;    // Tingkat kecerahan (0-255)
    reg [7:0] pwm_cnt;       // Counter PWM cepat
    reg direction;           // 0 = bertambah terang, 1 = bertambah redup

    // Logika PWM
    // Semua LED akan menyala jika pwm_cnt lebih kecil dari nilai duty_cycle saat ini
    assign leds = (pwm_cnt < duty_cycle) ? 5'b11111 : 5'b00000;

    always @(posedge clk) begin
        // 1. PWM Counter (Berjalan sangat cepat agar tidak terlihat berkedip)
        pwm_cnt <= pwm_cnt + 1;

        // 2. Breathing Timing (Mengatur kecepatan transisi terang ke redup)
        counter <= counter + 1;
        
        // Menggunakan bit ke-15 dari counter sebagai pemicu (Tick)
        // Ubah angka 15 ke lebih tinggi (misal 17) jika ingin lebih lambat
        if (counter[17] == 1'b1) begin
            counter[17] <= 0; // Reset pemicu manual

            if (direction == 1'b0) begin
                if (duty_cycle < 8'hFF)
                    duty_cycle <= duty_cycle + 1;
                else
                    direction <= 1'b1; // Balik ke redup jika sudah maksimal
            end else begin
                if (duty_cycle > 8'h00)
                    duty_cycle <= duty_cycle - 1;
                else
                    direction <= 1'b0; // Balik ke terang jika sudah minimal
            end
        end
    end

endmodule