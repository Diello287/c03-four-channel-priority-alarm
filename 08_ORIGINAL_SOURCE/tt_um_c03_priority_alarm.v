
module tt_um_c03_priority_alarm (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       ena,
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe
);

    wire       winner_valid;
    wire [1:0] winner_ch;
    wire [1:0] winner_level;

    c03_core core_inst (
        .alert_level(ui_in),
        .winner_valid(winner_valid),
        .winner_ch(winner_ch),
        .winner_level(winner_level)
    );

    assign uo_out = {
        3'b000,
        winner_valid,
        winner_level,
        winner_ch
    };

    // No bidirectional GPIO pins are used.
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

endmodule
