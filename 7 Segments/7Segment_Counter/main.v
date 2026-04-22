// ==========================================================
// Project: UART Controlled Auto Counter 0-9 for iCEstick
// Controls (Laptop Keyboard): 
// 'u' = Up, 'd' = Down, 'p' = Pause/Play, 'r' = Reset
// ==========================================================

module main (
    input  clk,      // Internal clock 12MHz (Pin 21)
    input  rx,       // UART RX (Pin 9)
    output [6:0] seg // Output ke 7-segment (a-g)
);

    // --- 1. UART Receiver Logic ---
    parameter CLKS_PER_BIT = 1250; // 12MHz / 9600 baud
    
    reg [2:0]  r_state = 0;
    reg [15:0] r_clk_count = 0;
    reg [2:0]  r_bit_index = 0;
    reg [7:0]  r_uart_data = 0;
    reg        r_uart_ready = 0;

    always @(posedge clk) begin
        case (r_state)
            0: begin // IDLE
                r_uart_ready <= 0;
                r_clk_count <= 0;
                r_bit_index <= 0;
                if (rx == 0) r_state <= 1; 
            end
            1: begin // Start Bit
                if (r_clk_count == (CLKS_PER_BIT-1)/2) r_state <= 2;
                else r_clk_count <= r_clk_count + 1;
            end
            2: begin // Data Bits
                if (r_clk_count < CLKS_PER_BIT-1) r_clk_count <= r_clk_count + 1;
                else begin
                    r_clk_count <= 0;
                    r_uart_data[r_bit_index] <= rx;
                    if (r_bit_index < 7) r_bit_index <= r_bit_index + 1;
                    else r_state <= 3;
                end
            end
            3: begin // Stop Bit
                if (r_clk_count < CLKS_PER_BIT-1) r_clk_count <= r_clk_count + 1;
                else begin
                    r_uart_ready <= 1;
                    r_state <= 0;
                end
            end
            default: r_state <= 0;
        endcase
    end

    // --- 2. Control Registers (Berdasarkan Input Keyboard) ---
    reg sw_dir = 1;    // 1=Up, 0=Down
    reg pause  = 0;    // 1=Berhenti
    reg rst_fsm = 0;

    always @(posedge clk) begin
        if (r_uart_ready) begin
            case (r_uart_data)
                8'h75, 8'h55: sw_dir  <= 1;    // 'u' atau 'U'
                8'h64, 8'h44: sw_dir  <= 0;    // 'd' atau 'D'
                8'h70, 8'h50: pause   <= ~pause; // 'p' atau 'P'
                8'h72, 8'h52: rst_fsm <= 1;    // 'r' atau 'R'
            endcase
        end else begin
            rst_fsm <= 0;
        end
    end

    // --- 3. Clock Divider (1Hz) ---
    reg [23:0] sec_count;
    reg clk_1hz;
    always @(posedge clk) begin
        if (sec_count == 5999999) begin
            sec_count <= 0;
            clk_1hz <= ~clk_1hz;
        end else begin
            sec_count <= sec_count + 1;
        end
    end

    // --- 4. FSM Counter Logic ---
    reg [3:0] count_state = 0;
    always @(posedge clk_1hz or posedge rst_fsm) begin
        if (rst_fsm) begin
            count_state <= 0;
        end else if (!pause) begin
            if (sw_dir) 
                count_state <= (count_state == 9) ? 0 : count_state + 1;
            else 
                count_state <= (count_state == 0) ? 9 : count_state - 1;
        end
    end

    // --- 5. Seven Segment Decoder (Common Cathode) ---
    reg [6:0] r_seg;
    always @(*) begin
        case (count_state)
            0: r_seg = 7'b0111111; // abcdef
            1: r_seg = 7'b0000110; // bc
            2: r_seg = 7'b1011011; // abdeg
            3: r_seg = 7'b1001111; // abcdg
            4: r_seg = 7'b1100110; // bcfg
            5: r_seg = 7'b1101101; // acdfg
            6: r_seg = 7'b1111101; // acdefg
            7: r_seg = 7'b0000111; // abc
            8: r_seg = 7'b1111111; // abcdefg
            9: r_seg = 7'b1101111; // abcdfg
            default: r_seg = 7'b0000000;
        endcase
    end
    
    // Inversi jika menggunakan Common Anode: assign seg = ~r_seg;
    assign seg = r_seg;

endmodule