module AXIS_DataMover_IF # (
  parameter integer DATA_WIDTH = 64,
  parameter integer MAX_BURST_LEN = 256,
  parameter integer BASE_ADDRESS = 0
)(
  input wire CLK,
  input wire RESETN,
  
  // S_AXIS bus signals
  input wire [DATA_WIDTH-1:0] S_AXIS_TDATA,
  input wire S_AXIS_TVALID,
  input wire S_AXIS_TLAST,
  output wire S_AXIS_TREADY,

  // M_AXIS bus signals
  output wire [DATA_WIDTH-1:0] M_AXIS_TDATA,
  output wire M_AXIS_TVALID,
  output wire M_AXIS_TLAST,
  input wire M_AXIS_TREADY,

  // M_AXIS bus signals
  output wire [DATA_WIDTH+39:0] M_AXIS_CMD_TDATA,
  output wire M_AXIS_CMD_TVALID,
  output wire M_AXIS_CMD_TLAST,
  input wire M_AXIS_CMD_TREADY
);

  localparam integer BTT_FIELD_LEN = MAX_BURST_LEN*DATA_WIDTH/8;
  localparam integer HEADER_FOOTER_ID_WIDTH = 16;

  wire [15:0] HEADER_ID = 16'hAAAA;
  wire [15:0] FOOTER_ID = 16'h5555;
  wire [15:0] ERROR_HEADER_ID = 16'hAAEE;
  wire [15:0] ERROR_FOOTER_ID = 16'h55EE;

  wire s_axis_tdata_header_foundD = (S_AXIS_TDATA[HEADER_FOOTER_ID_WIDTH-1:0]==HEADER_ID)|(S_AXIS_TDATA[HEADER_FOOTER_ID_WIDTH-1:0]==ERROR_HEADER_ID);
  wire s_axis_tdata_footer_foundD = (S_AXIS_TDATA[HEADER_FOOTER_ID_WIDTH-1:0]==FOOTER_ID)|(S_AXIS_TDATA[HEADER_FOOTER_ID_WIDTH-1:0]==ERROR_FOOTER_ID);
  wire [11:0] frame_byte_size = S_AXIS_TDATA[11:0]*64/8;

  reg m_axis_cmd_tvalid;

  wire [3:0] reserved = 4'h0;
  reg [3:0] command_tag;
  reg [DATA_WIDTH-1:0] start_address;
  wire [7:0] basic_mode_ignored_2 = 8'h0;
  wire type = 1'b1;
  wire [21-BTT_FIELD_LEN:0] basic_mode_ignored_1 = 22'h0;
  reg [BTT_FIELD_LEN:0] byte_to_transfer;

  always @(posedge CLK ) begin
    if (RESETN) begin
      m_axis_cmd_tvalid <= #400 1'b0;
    end else begin
      if (&{s_axis_tdata_header_foundD, S_AXIS_TVALID, M_AXIS_CMD_TREADY}) begin
        m_axis_cmd_tvalid <= #400 1'b1;
      end else begin
        
      end
    end
  end

  assign M_AXIS_CMD_TDATA = {reserved, command_tag, start_address, basic_mode_ignored_2, type, basic_mode_ignored_1, byte_to_transfer};

endmodule