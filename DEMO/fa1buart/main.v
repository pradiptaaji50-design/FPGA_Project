module main (
    input clk,          // Pin 21
    input rx,           // Pin 9
    output [4:0] led    // Pin 95-99
);

    parameter CLK_PER_BIT = 1250;

    // Register untuk menyimpan status input Full Adder
    reg reg_a = 0;
    reg reg_b = 0;
    reg reg_cin = 0;

    // Sinyal Output Full Adder
    wire sum;
    wire cout;

    // --- BAGIAN 1: UART RECEIVER (Logika sama seperti sebelumnya) ---
    reg [10:0] rx_clk_count = 0;
    reg [3:0]  rx_bit_index = 0;
    reg [7:0]  rx_data_out = 0;
    reg [1:0]  rx_state = 0;
    reg        rx_ready = 0;

    always @(posedge clk) begin
        case (rx_state)
            0: begin 
                rx_ready <= 0;
                if (rx == 0) begin
                    if (rx_clk_count < (CLK_PER_BIT/2)) rx_clk_count <= rx_clk_count + 1;
                    else begin rx_clk_count <= 0; rx_state <= 1; end
                end
            end
            1: begin 
                if (rx_clk_count < CLK_PER_BIT - 1) rx_clk_count <= rx_clk_count + 1;
                else begin
                    rx_clk_count <= 0;
                    rx_data_out[rx_bit_index] <= rx;
                    if (rx_bit_index < 7) rx_bit_index <= rx_bit_index + 1;
                    else begin rx_bit_index <= 0; rx_state <= 2; end
                end
            end
            2: begin 
                if (rx_clk_count < CLK_PER_BIT - 1) rx_clk_count <= rx_clk_count + 1;
                else begin rx_clk_count <= 0; rx_ready <= 1; rx_state <= 0; end
            end
        endcase
    end

    // --- BAGIAN 2: LOGIKA MAPPING KEYBOARD KE INPUT ---
    always @(posedge clk) begin
        if (rx_ready) begin
            case (rx_data_out)
                8'h61: reg_a   <= ~reg_a;   // Tekan 'a' untuk toggle A
                8'h62: reg_b   <= ~reg_b;   // Tekan 'b' untuk toggle B
                8'h63: reg_cin <= ~reg_cin; // Tekan 'c' untuk toggle Cin
            endcase
        end
    end

    // --- BAGIAN 3: LOGIKA FULL ADDER ---
    assign sum  = reg_a ^ reg_b ^ reg_cin;
    assign cout = (reg_a & reg_b) | (reg_cin & (reg_a ^ reg_b));
    assign led[0] = sum;
    assign led[1] = cout;
    assign led[2] = reg_a;
    assign led[3] = reg_b;
    assign led[4] = reg_cin;

endmodule