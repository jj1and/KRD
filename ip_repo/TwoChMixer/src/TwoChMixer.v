`timescale 1 ps / 1 ps

module TwoChMixer # (
  parameter integer DATA_WIDTH = 64

)(
  input wire CLK,
  input wire RESET,
  
  // handshake signals
  input wire [DATA_WIDTH-1:0] CH0_DIN,
  input wire CH0_iVALID,
  output wire CH0_oREADY,

  input wire [DATA_WIDTH-1:0] CH1_DIN,
  input wire CH1_iVALID, 
  output wire CH1_oREADY,

  (* mark_debug = "true" *) output wire [DATA_WIDTH-1:0] DOUT,
  (* mark_debug = "true" *) output wire oVALID,
  input wire iREADY
  
);

  localparam integer DATA_WIDTH_HEX = DATA_WIDTH/4;

  wire DualChMixer_CH0_RE;
  
  reg [DATA_WIDTH-1:0] fast_ch0fifo_dout;
  wire [DATA_WIDTH-1:0] Ch0Fifo_dout;
  wire Ch0Fifo_full;
  wire Ch0Fifo_empty;
  wire Ch0Fifo_prog_full;
  wire Ch0Fifo_prog_empty;
  wire Ch0Fifo_wr_rst_busy;
  wire Ch0Fifo_rd_rst_busy;

  always @(posedge CLK ) begin
    if (RESET) begin
      fast_ch0fifo_dout <= #400 {DATA_WIDTH_HEX{4'hE}};
    end else begin
      if (DualChMixer_CH0_RE) begin
        fast_ch0fifo_dout <= #400 Ch0Fifo_dout;
      end else begin
        fast_ch0fifo_dout <= #400 fast_ch0fifo_dout;
      end
    end
  end  

  wire DualChMixer_CH1_RE;

  reg [DATA_WIDTH-1:0] fast_ch1fifo_dout;
  wire [DATA_WIDTH-1:0] Ch1Fifo_dout;
  wire Ch1Fifo_full;
  wire Ch1Fifo_empty;
  wire Ch1Fifo_prog_full;
  wire Ch1Fifo_prog_empty;
  wire Ch1Fifo_wr_rst_busy;
  wire Ch1Fifo_rd_rst_busy;

  always @(posedge CLK ) begin
    if (RESET) begin
      fast_ch1fifo_dout <= #400 {DATA_WIDTH_HEX{4'hE}};
    end else begin
      if (DualChMixer_CH1_RE) begin
        fast_ch1fifo_dout <= #400 Ch1Fifo_dout;
      end else begin
        fast_ch1fifo_dout <= #400 fast_ch1fifo_dout;
      end
    end
  end

  ch0_fifo Ch0Fifo (
    .clk(CLK),                  // input wire clk
    .srst(RESET),                // input wire srst
    .din(CH0_DIN),                  // input wire [63 : 0] din
    .wr_en(CH0_iVALID),              // input wire wr_en
    .rd_en(DualChMixer_CH0_RE),              // input wire rd_en
    .dout(Ch0Fifo_dout),                // output wire [63 : 0] dout
    .full(Ch0Fifo_full),                // output wire full
    .empty(Ch0Fifo_empty),              // output wire empty
    .prog_full(Ch0Fifo_prog_full),      // output wire prog_full
    .prog_empty(Ch0Fifo_prog_empty),    // output wire prog_empty
    .wr_rst_busy(Ch0Fifo_wr_rst_busy),  // output wire wr_rst_busy
    .rd_rst_busy(Ch0Fifo_rd_rst_busy)  // output wire rd_rst_busy
  );

  ch1_fifo Ch1Fifo (
    .clk(CLK),                  // input wire clk
    .srst(RESET),                // input wire srst
    .din(CH1_DIN),                  // input wire [63 : 0] din
    .wr_en(CH1_iVALID),              // input wire wr_en
    .rd_en(DualChMixer_CH1_RE),              // input wire rd_en
    .dout(Ch1Fifo_dout),                // output wire [63 : 0] dout
    .full(Ch1Fifo_full),                // output wire full
    .empty(Ch1Fifo_empty),              // output wire empty
    .prog_full(Ch1Fifo_prog_full),      // output wire prog_full
    .prog_empty(Ch1Fifo_prog_empty),    // output wire prog_empty
    .wr_rst_busy(Ch1Fifo_wr_rst_busy),  // output wire wr_rst_busy
    .rd_rst_busy(Ch1Fifo_rd_rst_busy)  // output wire rd_rst_busy
  );

  assign CH0_oREADY = ~|{Ch0Fifo_prog_full, Ch0Fifo_full};
  assign CH1_oREADY = ~|{Ch1Fifo_prog_full, Ch1Fifo_full};

  wire Ch0ReadRequester_READ_REQUEST;
  wire Ch1ReadRequester_READ_REQUEST;

  ReadRequester Ch0ReadRequester (
    .CLK(CLK),
    .RESET(RESET),
    .PROGRAMMABLE_FULL(Ch0Fifo_prog_full),
    .PROGRAMMABLE_EMPTY(Ch0Fifo_prog_empty|Ch0Fifo_empty),
    .READ_REQUEST(Ch0ReadRequester_READ_REQUEST)
  );

  ReadRequester Ch1ReadRequester (
    .CLK(CLK),
    .RESET(RESET),
    .PROGRAMMABLE_FULL(Ch1Fifo_prog_full),
    .PROGRAMMABLE_EMPTY(Ch1Fifo_prog_empty|Ch1Fifo_empty),
    .READ_REQUEST(Ch1ReadRequester_READ_REQUEST)
  );

  wire [DATA_WIDTH-1:0] DualChMixer_DOUT;
  wire DualChMixer_oVALID;

  TwoChMixer_mod # (
    .DATA_WIDTH(DATA_WIDTH)
  ) DualChMixer (
    .CLK(CLK),
    .RESET(RESET),

    // channel 0 interface
    .CH0_DIN(fast_ch0fifo_dout),
    .CH0_READ_REQUEST(Ch0ReadRequester_READ_REQUEST),
    .CH0_RE(DualChMixer_CH0_RE),

    // channel 1 interface
    .CH1_DIN(fast_ch1fifo_dout),
    .CH1_READ_REQUEST(Ch1ReadRequester_READ_REQUEST),
    .CH1_RE(DualChMixer_CH1_RE),
    
    // handshake signals
    .iREADY(iREADY),
    .DOUT(DualChMixer_DOUT),
    .oVALID(DualChMixer_oVALID)
  );

  assign DOUT = DualChMixer_DOUT;
  assign oVALID = DualChMixer_oVALID;

endmodule