
`timescale 1ns/1ps

module tb_c03_core;

    reg  [7:0] alert_level;
    wire       winner_valid;
    wire [1:0] winner_ch;
    wire [1:0] winner_level;

    reg        expected_valid;
    reg  [1:0] expected_ch;
    reg  [1:0] expected_level;
    reg  [1:0] current_level;

    integer i;
    integer errors;

    c03_core dut (
        .alert_level(alert_level),
        .winner_valid(winner_valid),
        .winner_ch(winner_ch),
        .winner_level(winner_level)
    );

    task check_result;
        input [7:0] test_input;
        integer k;
        begin
            alert_level = test_input;

            expected_valid = 1'b0;
            expected_ch = 2'b00;
            expected_level = 2'b00;

            for (k = 0; k < 4; k = k + 1) begin
                current_level = (test_input >> (2*k)) & 2'b11;

                if (current_level > expected_level) begin
                    expected_valid = 1'b1;
                    expected_ch = k;
                    expected_level = current_level;
                end
            end

            #1;

            if ({winner_valid, winner_ch, winner_level} !==
                {expected_valid, expected_ch, expected_level}) begin
                $display(
                    "FAIL input=%b expected valid=%b ch=%d level=%d got valid=%b ch=%d level=%d",
                    test_input,
                    expected_valid, expected_ch, expected_level,
                    winner_valid, winner_ch, winner_level
                );
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        alert_level = 8'b0;

        for (i = 0; i < 256; i = i + 1)
            check_result(i);

        if (errors == 0)
            $display("PASS: all 256 input combinations checked.");
        else
            $display("FAIL: %0d mismatches found.", errors);

        $finish;
    end

endmodule
