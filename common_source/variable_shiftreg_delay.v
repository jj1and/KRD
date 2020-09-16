`timescale 1ps / 1ps
module variable_shiftreg_delay # (
    parameter DATA_WIDTH = 128,
    parameter MAX_DELAY_LENGTH = 8
)(
    input wire CLK,
    input wire [DATA_WIDTH-1:0] DIN,
    input wire [$clog2(MAX_DELAY_LENGTH):0] DELAY,
    output wire [DATA_WIDTH-1:0] DOUT
);

    localparam integer SHIFT_REG_WIDTH = MAX_DELAY_LENGTH*DATA_WIDTH;
    reg [SHIFT_REG_WIDTH-1:0] shift_reg;

    always @(posedge CLK ) begin
        shift_reg <= #100 {shift_reg[SHIFT_REG_WIDTH-DATA_WIDTH-1:0], DIN};
    end

    assign DOUT = shift_reg[DATA_WIDTH*(DELAY-1) +:DATA_WIDTH];


endmodule // 