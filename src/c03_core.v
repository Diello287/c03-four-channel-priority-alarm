
module c03_core (
    input  wire [7:0] alert_level,
    output reg        winner_valid,
    output reg  [1:0] winner_ch,
    output reg  [1:0] winner_level
);

    integer i;
    reg [1:0] current_level;

    always @(*) begin
        winner_valid = 1'b0;
        winner_ch    = 2'b00;
        winner_level = 2'b00;
        current_level = 2'b00;

        for (i = 0; i < 4; i = i + 1) begin
            current_level = alert_level[2*i +: 2];

            if (current_level > winner_level) begin
                winner_valid = 1'b1;
                winner_ch    = i[1:0];
                winner_level = current_level;
            end
        end
    end

endmodule
