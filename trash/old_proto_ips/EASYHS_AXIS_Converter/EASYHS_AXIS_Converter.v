module EASYHS_AXIS_converter # (
  parameter integer DATA_WIDTH =64
)(
  input wire CLK,
  input wire RESET,

  // EASYHS bus signals
  input wire [DATA_WIDTH-1:0] DIN,
  input wire iVALID,
  output wire oREADY,

  // AXIS bus signals
  output wire [DATA_WIDTH-1:0] TDATA,
  output wire TVALID,
  output wire TLAST,
  input wire TREADY
);

  localparam integer HEADER_FOOTER_ID_WIDTH = 16;

  reg [15:0] HEADER_ID = 16'hAAAA;
  reg [15:0] FOOTER_ID = 16'h5555;
  reg [15:0] ERROR_HEADER_ID = 16'hAAEE;
  reg [15:0] ERROR_FOOTER_ID = 16'h55EE;

  wire BufferFifo_prog_full;
  wire BufferFifo_full;
  wire BufferFifo_empty;
  wire BufferFifo_wr_rst_busy;
  wire BufferFifo_rd_rst_busy;

  wire BufferFifo_rd_en = &{!BufferFifo_empty, TREADY};
  wire [DATA_WIDTH-1:0] BufferFifo_dout;

  wire BufferFifo_dout_footer_foundD = (BufferFifo_dout[HEADER_FOOTER_ID_WIDTH-1:0]==FOOTER_ID)|(BufferFifo_dout[HEADER_FOOTER_ID_WIDTH-1:0]==ERROR_FOOTER_ID);

  // Common Clock Built-in Fifo FWFT mode
  buffer_fifo BufferFifo (
    .srst(RESET),                  // input wire srst
    // .wr_clk(WR_CLK),            // input wire wr_clk
    .clk(CLK),            // input wire rd_clk
    .din(DIN),                  // input wire [63 : 0] din
    .wr_en(iVALID),              // input wire wr_en
    .rd_en(BufferFifo_rd_en),              // input wire rd_en
    .dout(BufferFifo_dout),                // output wire [63 : 0] dout
    .prog_full(BufferFifo_prog_full),      // output wire prog_full  
    .full(BufferFifo_full),                // output wire full
    .empty(BufferFifo_empty),              // output wire empty
    .wr_rst_busy(BufferFifo_wr_rst_busy),  // output wire wr_rst_busy
    .rd_rst_busy(BufferFifo_rd_rst_busy)  // output wire rd_rst_busy
  );

  assign oREADY = ~|{BufferFifo_prog_full, BufferFifo_full, BufferFifo_wr_rst_busy};
  assign TVALID = ~|{BufferFifo_empty, BufferFifo_rd_rst_busy};
  assign TDATA = BufferFifo_dout;
  assign TLAST = BufferFifo_dout_footer_foundD;

endmodule // 