
`timescale 1ns/1ps

module tb_tt_um_c03_priority_alarm;

    reg        clk;
    reg        rst_n;
    reg        ena;
    reg  [7:0] ui_in;
    wire [7:0] uo_out;
    reg  [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    reg  [1:0] expected_ch;
    reg  [1:0] expected_level;
    reg        expected_valid;
    reg  [1:0] current_level;

    integer i;
    integer errors;

    tt_um_c03_priority_alarm dut (
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe)
    );

    task check_result;
        input [7:0] test_input;
        integer k;
        begin
            ui_in = test_input;
            expected_ch = 2'b00;
            expected_level = 2'b00;
            expected_valid = 1'b0;

            for (k = 0; k < 4; k = k + 1) begin
                current_level = (test_input >> (2*k)) & 2'b11;

                if (current_level > expected_level) begin
                    expected_ch = k;
                    expected_level = current_level;
                    expected_valid = 1'b1;
                end
            end

            #1;

            if (uo_out !== {
                3'b000, expected_valid,
                expected_level, expected_ch
            }) begin
                $display(
                    "FAIL ui_in=%b expected uo_out=%b got=%b",
                    test_input,
                    {3'b000, expected_valid,
                     expected_level, expected_ch},
                    uo_out
                );
                errors = errors + 1;
            end

            if (uio_out !== 8'b0 || uio_oe !== 8'b0) begin
                $display(
                    "FAIL GPIO uio_out=%b uio_oe=%b",
                    uio_out, uio_oe
                );
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b1;
        ena = 1'b1;
        uio_in = 8'b0;
        ui_in = 8'b0;
        errors = 0;

        for (i = 0; i < 256; i = i + 1)
            check_result(i);

        if (errors == 0)
            $display("PASS: wrapper checked for all 256 inputs and GPIO outputs.");
        else
            $fatal(1, "FAIL: %0d mismatches found.", errors);

        $finish;
    end

endmodule
