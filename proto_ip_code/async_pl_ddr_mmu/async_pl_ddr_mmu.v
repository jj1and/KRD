`timescale 1 ps / 1 ps

module async_pl_ddr_mmu # (
    parameter integer TDATA_WIDTH = 128,
    parameter integer HEADER_FOOTER_ID_WIDTH = 8,
    parameter integer CHANNEL_ID_WIDTH = 12,
    parameter integer FRAME_LENGTH_WIDTH = 12,
    // global address size of PL DDR e.g. 4GiB -> 32bit
    parameter integer ADDRESS_WIDTH = 32,
    // local address size which pl_ddr_mmu manages. e.g. 256MiB -> 28bit 
    parameter integer LOCAL_ADDRESS_WIDTH = 28,
    parameter integer BASE_ADDRESS = 32'h0000_0000
)(
    input wire ACLK,
    input wire ARESETN,

    input wire CLK,
    input wire RESET,
    input wire SET_CONFIG,

    // Maximum trigger length from dataframe_generator (packet size <= MAX_TRIGGER_LENGTH*16+3*8 Bytes)
    input wire [15:0] MAX_TRIGGER_LENGTH,

    // S_AXIS interface from dataframe_generator
    input wire [TDATA_WIDTH-1:0] S_AXIS_TDATA,
    input wire S_AXIS_TVALID,
    input wire S_AXIS_TLAST,
    output wire S_AXIS_TREADY,

    // M_AXIS inferface for S2MM CMD port of AXI Data Mover IP
    output wire [ADDRESS_WIDTH+40-1:0] S2MM_CMD_M_AXIS_TDATA,
    output wire S2MM_CMD_M_AXIS_TVALID,
    input wire S2MM_CMD_M_AXIS_TREADY,

    // M_AXIS interface for S2MM DATA port of AXI Data Mover IP
    output wire [TDATA_WIDTH-1:0] S2MM_M_AXIS_TDATA,
    output wire S2MM_M_AXIS_TVALID,
    output wire S2MM_M_AXIS_TLAST,
    input wire S2MM_M_AXIS_TREADY,

    // S_AXIS inferface for S2MM STS port of AXI Data Mover IP
    //input wire [31:0] S2MM_STS_S_AXIS_TDATA, // For IBTT mode
    input wire [7:0] S2MM_STS_S_AXIS_TDATA, // For Non-IBTT mode
    input wire S2MM_STS_S_AXIS_TVALID,
    output wire S2MM_STS_S_AXIS_TREADY,

    // write transaction done signal from AXI Data Mover IP
    // input wire S2MM_WR_XFER_CMPLT,

    // M_AXIS inferface for MM2S CMD port of AXI Data Mover IP
    output wire [ADDRESS_WIDTH+40-1:0] MM2S_CMD_M_AXIS_TDATA,
    output wire MM2S_CMD_M_AXIS_TVALID,
    input wire MM2S_CMD_M_AXIS_TREADY,

    // S_AXIS inferface for MM2S STS port of AXI Data Mover IP
    input wire [7:0] MM2S_STS_S_AXIS_TDATA,
    input wire MM2S_STS_S_AXIS_TVALID,
    output wire MM2S_STS_S_AXIS_TREADY,

    // read transaction done signal frmo AXI Data Mover IP
    // input wire MM2S_RD_XFER_CMPLT,

    // S_AXIS interface for MM2S DATA port of AXI Data Mover IP
    input wire [TDATA_WIDTH-1:0] MM2S_S_AXIS_TDATA,
    input wire MM2S_S_AXIS_TVALID,
    input wire MM2S_S_AXIS_TLAST,
    output wire MM2S_S_AXIS_TREADY,

    // M_AXIS interface for AXIS Interconnect
    output wire [TDATA_WIDTH-1:0] M_AXIS_TDATA,
    output wire M_AXIS_TVALID,
    output wire M_AXIS_TLAST,
    output wire [TDATA_WIDTH/8-1:0] M_AXIS_TKEEP,
    input wire M_AXIS_TREADY,

    // input wire S2MM_ERR,
    // input wire MM2S_ERR,
    output wire DATAMOVER_ERROR
);

    reg src_send;
    wire src_rcv;
    wire dest_req;
    wire [15:0] dest_max_trigger_lengthD;
    reg [15:0] dest_max_trigger_length;
	// xpm_cdc_handshake: Bus Synchronizer with Full Handshake
	// Xilinx Parameterized Macro, version 2019.1
	xpm_cdc_handshake #(
        .DEST_EXT_HSK(0), // DECIMAL; 0=internal handshake, 1=external handshake
        .DEST_SYNC_FF(2), // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0), // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_SYNC_FF(2), // DECIMAL; range: 2-10
        .WIDTH(16) // DECIMAL; range: 1-1024
	)
	xpm_cdc_handshake_inst (
        .dest_out(dest_max_trigger_lengthD), // WIDTH-bit output: Input bus (src_in) synchronized to destination clock domain.
        // This output is registered.
        .dest_req(dest_req), // 1-bit output: Assertion of this signal indicates that new dest_out data has been
        // received and is ready to be used or captured by the destination logic. When
        // DEST_EXT_HSK = 1, this signal will deassert once the source handshake
        // acknowledges that the destination clock domain has received the transferred data.
        // When DEST_EXT_HSK = 0, this signal asserts for one clock period when dest_out bus
        // is valid. This output is registered.
        .src_rcv(src_rcv), // 1-bit output: Acknowledgement from destination logic that src_in has been
        // received. This signal will be deasserted once destination handshake has fully
        // completed, thus completing a full data transfer. This output is registered.
        .dest_ack(), // 1-bit input: optional; required when DEST_EXT_HSK = 1
        .dest_clk(ACLK), // 1-bit input: Destination clock.
        .src_clk(CLK), // 1-bit input: Source clock.
        .src_in(MAX_TRIGGER_LENGTH), // WIDTH-bit input: Input bus that will be synchronized to the destination clock
        // domain.
        .src_send(src_send) // 1-bit input: Assertion of this signal allows the src_in bus to be synchronized to
        // the destination clock domain. This signal should only be asserted when src_rcv is
        // deasserted, indicating that the previous data transfer is complete. This signal
        // should only be deasserted once src_rcv is asserted, acknowledging that the src_in
        // has been received by the destination logic.
	);
	// End of xpm_cdc_handshake_inst instantiation

    always @(posedge CLK ) begin
        if (RESET) begin
            src_send <= #100 1'b0;
        end else begin
            if (src_rcv) begin
                src_send <= #100 1'b0;
            end else begin
                if (SET_CONFIG) begin
                    src_send <= #100 1'b1;
                end else begin
                    src_send <= src_send;
                end
            end
        end
    end

    always @(posedge ACLK ) begin
        if (dest_req) begin
            dest_max_trigger_length <= #100 dest_max_trigger_lengthD;
        end else begin
            dest_max_trigger_length <= #100 dest_max_trigger_length;
        end
    end

    reg dest_req_delay;
    always @(posedge ACLK ) begin
        dest_req_delay <= #100 dest_req;
    end

    localparam integer RFADC_TDATA_WIDTH = 128;
    localparam integer DATAFRAME_WIDTH = 64;
    localparam integer RFADC_W = $clog2(RFADC_TDATA_WIDTH);
    localparam integer W = $clog2(TDATA_WIDTH);
    localparam integer BYTE_W = $clog2(TDATA_WIDTH/8);
    localparam integer RFADC_TDATA_NUM_PER_CLK = TDATA_WIDTH/RFADC_TDATA_WIDTH;
    wire [7:0] HEADER_ID = 8'hAA;
    wire [7:0] FOOTER_ID = 8'h55;

    // ------------------------------- mmu configration -------------------------------
    localparam integer BTT_WIDTH = 23;
    reg [3:0] rsvd;
    reg drr;
    reg eof;
    // dsa is effective when drr = 1'b1
    reg [5:0] dsa;
    reg burst_type;
    reg [BTT_WIDTH-1:0] max_btt;

    wire [16:0] max_tdata_len = dest_max_trigger_length + 2;
    wire [16:0] max_send_len;
    generate
        if (W>7) begin
            assign max_send_len = {{W-RFADC_W-1{1'b0}}, max_tdata_len[FRAME_LENGTH_WIDTH:W-RFADC_W]} + |max_tdata_len[W-RFADC_W-1:0];
        end else begin
            assign max_send_len = max_tdata_len;
        end
    endgenerate
    wire [BTT_WIDTH-1:0] max_bttD = {{BTT_WIDTH-17-BYTE_W{1'b0}}, max_send_len, {BYTE_W{1'b0}}};

    always @(posedge ACLK ) begin
        if (|{~ARESETN, DATAMOVER_ERROR}) begin
            rsvd <= #100 0;
            drr <= #100 0;
            eof <= #100 1'b1;
            dsa <= #100 0;
            burst_type <= #100 1'b1;
            max_btt <= #100 16*16+32;
        end else begin
            if (dest_req_delay) begin
                rsvd <= #100 0;
                drr <= #100 0;
                eof <= #100 1'b1;
                dsa <= #100 0;      
                burst_type <= #100 1'b1;
                max_btt <= #100 max_bttD;                  
            end else begin
                rsvd <= #100 rsvd;
                drr <= #100 drr;
                eof <= #100 eof;
                dsa <= #100 dsa;      
                burst_type <= #100 burst_type;
                max_btt <= #100 max_btt;                
            end
        end
    end

    // ------------------------------- S2MM STS assigment ------------------------------
    // wire s2mm_sts_eop = S2MM_STS_S_AXIS_TDATA[31]; // IBTT-mode only
    // wire [22:0] s2mm_sts_brcvd = S2MM_STS_S_AXIS_TDATA[30:8]; // IBTT-mode only
    wire s2mm_sts_okay = S2MM_STS_S_AXIS_TDATA[7];
    wire s2mm_sts_slverr = S2MM_STS_S_AXIS_TDATA[6];
    wire s2mm_sts_decerr = S2MM_STS_S_AXIS_TDATA[5];
    wire s2mm_sts_interr = S2MM_STS_S_AXIS_TDATA[4];
    wire [3:0] s2mm_sts_tag = S2MM_STS_S_AXIS_TDATA[3:0];
    wire s2mm_transfer_cmpltD = &{s2mm_sts_okay, S2MM_STS_S_AXIS_TVALID};
    reg s2mm_transfer_cmplt;
    assign S2MM_STS_S_AXIS_TREADY = 1'b1;

    reg s2mm_mover_error;
    always @(posedge ACLK ) begin
        if (~ARESETN) begin
            s2mm_mover_error <= #100 1'b0;
        end else begin
            if (|{s2mm_sts_slverr, s2mm_sts_decerr, s2mm_sts_interr}) begin
                s2mm_mover_error <= #100 1'b1;
            end else begin
                s2mm_mover_error <= #100 s2mm_mover_error;
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay}) begin
            s2mm_transfer_cmplt <= #100 1'b1;
        end else begin
            if (s2mm_transfer_cmpltD) begin
                s2mm_transfer_cmplt <= #100 1'b1;
            end else begin
                if (S2MM_CMD_M_AXIS_TVALID&S2MM_CMD_M_AXIS_TREADY) begin
                    s2mm_transfer_cmplt <= #100 1'b0;
                end else begin
                    s2mm_transfer_cmplt <= #100 s2mm_transfer_cmplt;
                end
            end
        end
    end

    // ------------------------------- MM2S STS assigment ------------------------------
    wire mm2s_sts_okay = MM2S_STS_S_AXIS_TDATA[7];
    wire mm2s_sts_slverr = MM2S_STS_S_AXIS_TDATA[6];
    wire mm2s_sts_decerr = MM2S_STS_S_AXIS_TDATA[5];
    wire mm2s_sts_interr = MM2S_STS_S_AXIS_TDATA[4];
    wire [3:0] mm2s_sts_tag = MM2S_STS_S_AXIS_TDATA[3:0];
    wire mm2s_transfer_cmpltD = &{mm2s_sts_okay, mm2s_sts_tag==mm2s_tag, MM2S_STS_S_AXIS_TVALID};
    assign MM2S_STS_S_AXIS_TREADY = 1'b1;

    reg mm2s_mover_error;
    always @(posedge ACLK ) begin
        if (~ARESETN) begin
            mm2s_mover_error <= #100 1'b0;
        end else begin
            if (|{mm2s_sts_slverr, mm2s_sts_decerr, mm2s_sts_interr}) begin
                mm2s_mover_error <= #100 1'b1;
            end else begin
                mm2s_mover_error <= #100 mm2s_mover_error;
            end
        end
    end

    assign DATAMOVER_ERROR = s2mm_mover_error|mm2s_mover_error;

    // ------------------------------- write/read address control -------------------------------
    reg [LOCAL_ADDRESS_WIDTH:0] src_addr;
    reg [LOCAL_ADDRESS_WIDTH:0] dest_addr;
    reg [LOCAL_ADDRESS_WIDTH:0] cmd_dest_addr;
    reg [LOCAL_ADDRESS_WIDTH:0] next_src_addr;
    reg [LOCAL_ADDRESS_WIDTH:0] next_dest_addr;
    reg [LOCAL_ADDRESS_WIDTH:0] next_cmd_dest_addr;
    wire [LOCAL_ADDRESS_WIDTH-1:0] HIGH_ADDRESS = {LOCAL_ADDRESS_WIDTH{1'b1}};
    wire [LOCAL_ADDRESS_WIDTH-1:0] ACTUAL_HIGH_ADDRESS = HIGH_ADDRESS - max_btt; 
    wire empty = (src_addr == dest_addr);
    wire full = (src_addr[LOCAL_ADDRESS_WIDTH-1:0] == cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:0])&(src_addr[LOCAL_ADDRESS_WIDTH] != cmd_dest_addr[LOCAL_ADDRESS_WIDTH]);
    wire almost_empty = (next_src_addr[LOCAL_ADDRESS_WIDTH-1:0] == dest_addr[LOCAL_ADDRESS_WIDTH-1:0])&(next_src_addr[LOCAL_ADDRESS_WIDTH] == dest_addr[LOCAL_ADDRESS_WIDTH]);
    wire almost_full = (next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] == src_addr[LOCAL_ADDRESS_WIDTH-1:0])&(next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH] != src_addr[LOCAL_ADDRESS_WIDTH]);    

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay, DATAMOVER_ERROR}) begin
            cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 0;
            cmd_dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 1'b0;
        end else begin
            if (s2mm_cmd_tvaild&S2MM_CMD_M_AXIS_TREADY) begin
                if (cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:0]+max_btt>ACTUAL_HIGH_ADDRESS) begin
                    cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 0;
                    cmd_dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 ~cmd_dest_addr[LOCAL_ADDRESS_WIDTH];
                end else begin
                    if ({1'b0, cmd_dest_addr[11:0]}+max_btt*2>4095) begin
                        // 4k byte alignment
                        cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 {cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:12], 12'b0} + 4096;
                        cmd_dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 cmd_dest_addr[LOCAL_ADDRESS_WIDTH];                           
                    end else begin
                        cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] + max_btt;
                        cmd_dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 cmd_dest_addr[LOCAL_ADDRESS_WIDTH];                        
                    end
                end
            end else begin
                cmd_dest_addr <= #100 cmd_dest_addr;
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay, DATAMOVER_ERROR}) begin
            next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 max_btt;
            next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 1'b0;
        end else begin
            if (s2mm_cmd_tvaild&S2MM_CMD_M_AXIS_TREADY) begin
                if (next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:0]+max_btt>ACTUAL_HIGH_ADDRESS) begin
                    next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 0;
                    next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 ~next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH];
                end else begin
                    if ({1'b0, next_cmd_dest_addr[11:0]}+max_btt*2>4095) begin
                        // 4k byte alignment
                        next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 {next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:12], 12'b0} + 4096;
                        next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH];                           
                    end else begin
                        next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] + max_btt;
                        next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 next_cmd_dest_addr[LOCAL_ADDRESS_WIDTH];                        
                    end
                end
            end else begin
                next_cmd_dest_addr <= #100 next_cmd_dest_addr;
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay, DATAMOVER_ERROR}) begin
            dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 0;
            dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 1'b0;
        end else begin
            if (s2mm_transfer_cmpltD) begin
                if (dest_addr[LOCAL_ADDRESS_WIDTH-1:0]+max_btt>ACTUAL_HIGH_ADDRESS) begin
                    dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 0;
                    dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 ~dest_addr[LOCAL_ADDRESS_WIDTH];
                end else begin
                    if ({1'b0, dest_addr[11:0]}+max_btt*2>4095) begin
                        // 4k byte alignment
                        dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 {dest_addr[LOCAL_ADDRESS_WIDTH-1:12], 12'b0} + 4096;
                        dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 dest_addr[LOCAL_ADDRESS_WIDTH];                           
                    end else begin
                        dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 dest_addr[LOCAL_ADDRESS_WIDTH-1:0] + max_btt;
                        dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 dest_addr[LOCAL_ADDRESS_WIDTH];                        
                    end
                end
            end else begin
                dest_addr <= #100 dest_addr;
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay, DATAMOVER_ERROR}) begin
            next_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 max_btt;
            next_dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 1'b0;
        end else begin
            if (s2mm_transfer_cmpltD) begin
                if (next_dest_addr[LOCAL_ADDRESS_WIDTH-1:0]+max_btt>ACTUAL_HIGH_ADDRESS) begin
                    next_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 0;
                    next_dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 ~next_dest_addr[LOCAL_ADDRESS_WIDTH];
                end else begin
                    if ({1'b0, next_dest_addr[11:0]}+max_btt*2>4095) begin
                        // 4k byte alignment
                        next_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 {next_dest_addr[LOCAL_ADDRESS_WIDTH-1:12], 12'b0} + 4096;
                        next_dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 next_dest_addr[LOCAL_ADDRESS_WIDTH];                           
                    end else begin
                        next_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 next_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] + max_btt;
                        next_dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 next_dest_addr[LOCAL_ADDRESS_WIDTH];                        
                    end
                end
            end else begin
                next_dest_addr <= #100 next_dest_addr;
            end
        end
    end    

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay, DATAMOVER_ERROR}) begin
            src_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 0;
            src_addr[LOCAL_ADDRESS_WIDTH] <= #100 1'b0;
        end else begin
            if (mm2s_transfer_cmpltD) begin
                if (src_addr[LOCAL_ADDRESS_WIDTH-1:0]+max_btt>ACTUAL_HIGH_ADDRESS) begin
                    src_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 0;
                    src_addr[LOCAL_ADDRESS_WIDTH] <= #100 ~src_addr[LOCAL_ADDRESS_WIDTH];
                end else begin
                    if ({1'b0, src_addr[11:0]}+max_btt*2>4095) begin
                        // 4k byte alignment
                        src_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 {src_addr[LOCAL_ADDRESS_WIDTH-1:12], 12'b0} + 4096;
                        src_addr[LOCAL_ADDRESS_WIDTH] <= #100 src_addr[LOCAL_ADDRESS_WIDTH];                           
                    end else begin
                        src_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 src_addr[LOCAL_ADDRESS_WIDTH-1:0] + max_btt;
                        src_addr[LOCAL_ADDRESS_WIDTH] <= #100 src_addr[LOCAL_ADDRESS_WIDTH];                        
                    end
                end
            end else begin
                src_addr <= #100 src_addr;
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay, DATAMOVER_ERROR}) begin
            next_src_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 max_btt;
            next_src_addr[LOCAL_ADDRESS_WIDTH] <= #100 1'b0;
        end else begin
            if (mm2s_transfer_cmpltD) begin
                if (next_src_addr[LOCAL_ADDRESS_WIDTH-1:0]+max_btt>ACTUAL_HIGH_ADDRESS) begin
                    next_src_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 0;
                    next_src_addr[LOCAL_ADDRESS_WIDTH] <= #100 ~next_src_addr[LOCAL_ADDRESS_WIDTH];
                end else begin
                    if ({1'b0, next_src_addr[11:0]}+max_btt*2>4095) begin
                        // 4k byte alignment
                        next_src_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 {next_src_addr[LOCAL_ADDRESS_WIDTH-1:12], 12'b0} + 4096;
                        next_src_addr[LOCAL_ADDRESS_WIDTH] <= #100 next_src_addr[LOCAL_ADDRESS_WIDTH];                           
                    end else begin
                        next_src_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 next_src_addr[LOCAL_ADDRESS_WIDTH-1:0] + max_btt;
                        next_src_addr[LOCAL_ADDRESS_WIDTH] <= #100 next_src_addr[LOCAL_ADDRESS_WIDTH];                        
                    end
                end
            end else begin
                next_src_addr <= #100 next_src_addr;
            end
        end
    end    

    // ------------------------------- S_AXIS/S2MM DATA assigment -------------------------------
    reg write_ready;

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay}) begin
            write_ready <= #100 1'b1;
        end else begin
            if (&{S_AXIS_TVALID, S_AXIS_TLAST, write_ready, S2MM_M_AXIS_TREADY}|DATAMOVER_ERROR) begin
                write_ready <= #100 1'b0;
            end else begin
                if (&{!almost_full, !full}) begin
                    write_ready <= #100 1'b1;
                end else begin
                    write_ready <= #100 write_ready;
                end
            end
        end
    end
    
    assign S2MM_M_AXIS_TDATA = S_AXIS_TDATA;
    assign S2MM_M_AXIS_TVALID = &{S_AXIS_TVALID, write_ready};
    assign S2MM_M_AXIS_TLAST = &{S_AXIS_TVALID, S_AXIS_TLAST, write_ready};
    assign S_AXIS_TREADY = &{S2MM_M_AXIS_TREADY, write_ready};

    // ------------------------------- S2MM Command assigment -------------------------------
    reg s2mm_cmd_tvaild;
    reg [3:0] cmd_s2mm_tag;

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay, DATAMOVER_ERROR}) begin
            s2mm_cmd_tvaild <= #100 1'b0;
        end else begin
            if (&{S_AXIS_TDATA[DATAFRAME_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==HEADER_ID, S2MM_M_AXIS_TVALID, S2MM_M_AXIS_TREADY}) begin
                s2mm_cmd_tvaild <= #100 1'b1;
            end else begin
                if (s2mm_cmd_tvaild&S2MM_CMD_M_AXIS_TREADY) begin
                    s2mm_cmd_tvaild <= #100 1'b0;
                end else begin
                    s2mm_cmd_tvaild <= #100 s2mm_cmd_tvaild;
                end
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay, DATAMOVER_ERROR}) begin
            cmd_s2mm_tag <= #100 0;
        end else begin
            if (s2mm_cmd_tvaild&S2MM_CMD_M_AXIS_TREADY) begin
                cmd_s2mm_tag <= #100 cmd_s2mm_tag+1;
            end else begin
                cmd_s2mm_tag <= #100 cmd_s2mm_tag;
            end
        end
    end

    wire [ADDRESS_WIDTH-1:0] cmd_s2mm_addr = cmd_dest_addr[LOCAL_ADDRESS_WIDTH-1:0]+BASE_ADDRESS;
    wire [FRAME_LENGTH_WIDTH:0] send_len;
    // For Non-IBTT Mode
    reg [BTT_WIDTH-1:0] s2mm_btt;
    wire [FRAME_LENGTH_WIDTH:0] tdata_len = {2'b0, S_AXIS_TDATA[DATAFRAME_WIDTH-HEADER_FOOTER_ID_WIDTH-CHANNEL_ID_WIDTH-1 -:FRAME_LENGTH_WIDTH-1]} + 2;
    generate
        if (W>7) begin
            assign send_len = {{W-RFADC_W-1{1'b0}}, tdata_len[FRAME_LENGTH_WIDTH:W-RFADC_W]} + |tdata_len[W-RFADC_W-1:0];
        end else begin
            assign send_len = tdata_len;
        end
    endgenerate
    wire [BTT_WIDTH-1:0] s2mm_bttD = {{BTT_WIDTH-FRAME_LENGTH_WIDTH-1-BYTE_W{1'b0}}, send_len, {BYTE_W{1'b0}}};

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay}) begin
            s2mm_btt <= #100 max_btt;
        end else begin
            if (&{S_AXIS_TDATA[DATAFRAME_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==HEADER_ID, S2MM_M_AXIS_TVALID, S2MM_M_AXIS_TREADY}) begin
                // s2mm_btt <= #100 S_AXIS_TDATA[DATAFRAME_WIDTH-HEADER_FOOTER_ID_WIDTH-CHANNEL_ID_WIDTH-1 -:FRAME_LENGTH_WIDTH]*8+32;
                s2mm_btt <= #100 s2mm_bttD;
            end else begin
                s2mm_btt <= #100 s2mm_btt;
            end
        end
    end
    assign S2MM_CMD_M_AXIS_TDATA = {rsvd, cmd_s2mm_tag, cmd_s2mm_addr, drr, eof, dsa, burst_type, s2mm_btt};

    // For IBTT mode
    // assign S2MM_CMD_M_AXIS_TDATA = {rsvd, cmd_s2mm_tag, cmd_s2mm_addr, drr, eof, dsa, burst_type, max_btt};
    assign S2MM_CMD_M_AXIS_TVALID = s2mm_cmd_tvaild;

    // ------------------------------- MM2S Command assigment -------------------------------
    reg mm2s_cmd_tvalid;
    reg [3:0] mm2s_tag;
    reg read_ready;

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay}) begin
            read_ready <= #100 1'b1;
        end else begin
            if (|{MM2S_CMD_M_AXIS_TVALID&MM2S_CMD_M_AXIS_TREADY, DATAMOVER_ERROR}) begin
                read_ready <= #100 1'b0;
            end else begin
                if (mm2s_transfer_cmpltD) begin
                    read_ready <= #100 1'b1;
                end else begin
                    read_ready <= #100 read_ready;
                end
            end
        end
    end    

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay, DATAMOVER_ERROR}) begin
            mm2s_cmd_tvalid <= #100 1'b0;
        end else begin
            if (&{read_ready, !empty, !mm2s_cmd_tvalid}) begin
                mm2s_cmd_tvalid <= #100 1'b1;
            end else begin
                if (mm2s_cmd_tvalid&MM2S_CMD_M_AXIS_TREADY) begin
                    mm2s_cmd_tvalid <= #100 1'b0;
                end else begin
                    mm2s_cmd_tvalid <= #100 mm2s_cmd_tvalid;
                end
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay, DATAMOVER_ERROR}) begin
            mm2s_tag <= #100 0;
        end else begin
            if (mm2s_transfer_cmpltD) begin
                mm2s_tag <= #100 mm2s_tag+1;
            end else begin
                mm2s_tag <= #100 mm2s_tag;
            end
        end
    end    

    wire [ADDRESS_WIDTH-1:0] cmd_mm2s_addr = src_addr[LOCAL_ADDRESS_WIDTH-1:0]+BASE_ADDRESS;
    assign MM2S_CMD_M_AXIS_TDATA = {rsvd, mm2s_tag, cmd_mm2s_addr, drr, eof, dsa, burst_type, max_btt};
    assign MM2S_CMD_M_AXIS_TVALID = mm2s_cmd_tvalid;

    // ------------------------------- M_AXIS/MM2S DATA assigment -------------------------------
    reg m_axis_tvalid;
    reg mm2s_tvalid_delay;
    reg mm2s_tdata_valid;
    reg new_data;
    wire mm2s_tvalid_posedge = (mm2s_tvalid_delay==1'b0)&(MM2S_S_AXIS_TVALID==1'b1);
    wire mm2s_tdata_is_header =  (MM2S_S_AXIS_TDATA[DATAFRAME_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==HEADER_ID);
    wire mm2s_tdata_is_footer;
    wire m_axis_tdata_is_footer;

    reg [TDATA_WIDTH-1:0] m_axis_tdata;
    reg [TDATA_WIDTH/8-1:0] m_axis_tkeep;

    genvar i;
    integer j;
    generate
        if (W>7) begin
            wire [RFADC_TDATA_NUM_PER_CLK-1:0] mm2s_rfdc_tdata_has_footer;
            wire [RFADC_TDATA_NUM_PER_CLK-1:0] m_axis_rfdc_tdata_has_footer;  
            wire [RFADC_TDATA_NUM_PER_CLK-2:0] these_rfdc_tdata_has_no_footer;
            wire [RFADC_TDATA_NUM_PER_CLK-1:0] mm2s_valid_rfdc_tdata;   
            for (i=0; i<RFADC_TDATA_NUM_PER_CLK; i=i+1) begin
                assign mm2s_rfdc_tdata_has_footer[i] = (MM2S_S_AXIS_TDATA[RFADC_TDATA_WIDTH*i+DATAFRAME_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==FOOTER_ID);
                assign m_axis_rfdc_tdata_has_footer[i] = (m_axis_tdata[RFADC_TDATA_WIDTH*i+DATAFRAME_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==FOOTER_ID);
            end
            for (i=0; i<RFADC_TDATA_NUM_PER_CLK-1; i=i+1 ) begin
                assign these_rfdc_tdata_has_no_footer[i] = ~|mm2s_rfdc_tdata_has_footer[i:0];
            end
            assign mm2s_tdata_is_footer = |mm2s_rfdc_tdata_has_footer;
            assign mm2s_valid_rfdc_tdata = {these_rfdc_tdata_has_no_footer, 1'b1};
            assign m_axis_tdata_is_footer = |m_axis_rfdc_tdata_has_footer;
            always @(posedge ACLK ) begin
                if (|{~ARESETN, dest_req_delay, DATAMOVER_ERROR}) begin
                    m_axis_tkeep <= #100 {TDATA_WIDTH/8{1'b0}};
                end else begin
                    if (&{m_axis_tvalid, !M_AXIS_TREADY}) begin
                        m_axis_tkeep <= #100 m_axis_tkeep;
                    end else begin
                        if (mm2s_tdata_is_footer&MM2S_S_AXIS_TVALID) begin
                            for (j=0; j<RFADC_TDATA_NUM_PER_CLK; j=j+1) begin
                                m_axis_tkeep[RFADC_TDATA_WIDTH/8*j +:RFADC_TDATA_WIDTH/8] <= #100 {RFADC_TDATA_WIDTH/8{mm2s_valid_rfdc_tdata[j]}};
                            end
                        end else begin
                            m_axis_tkeep <= #100  {TDATA_WIDTH/8{1'b1}};
                        end                        
                    end
                end
            end
        end else begin
            assign mm2s_tdata_is_footer = (MM2S_S_AXIS_TDATA[DATAFRAME_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==FOOTER_ID);
            assign m_axis_tdata_is_footer = (m_axis_tdata[DATAFRAME_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==FOOTER_ID);
            always @(posedge ACLK ) begin
                if (|{~ARESETN, dest_req_delay, DATAMOVER_ERROR}) begin
                    m_axis_tkeep <= #100 {TDATA_WIDTH/8{1'b0}};
                end else begin
                    if (&{m_axis_tvalid, !M_AXIS_TREADY}) begin
                        m_axis_tkeep <= #100 m_axis_tkeep;
                    end else begin
                        if (MM2S_S_AXIS_TVALID) begin
                            m_axis_tkeep <= #100 {{TDATA_WIDTH/16{1'b0}}, {TDATA_WIDTH/16{1'b1}}};
                        end else begin
                            m_axis_tkeep <= #100  {TDATA_WIDTH/8{1'b1}};
                        end                        
                    end
                end
            end
        end
    endgenerate

    always @(posedge ACLK ) begin
        mm2s_tvalid_delay <= #100 MM2S_S_AXIS_TVALID;
    end

    always @(posedge ACLK) begin
        if (|{~ARESETN, dest_req_delay, DATAMOVER_ERROR}) begin
            new_data <= #100 1'b1;
        end else begin
            if (&{MM2S_S_AXIS_TLAST, MM2S_S_AXIS_TVALID, MM2S_S_AXIS_TREADY}) begin
                new_data <= #100 1'b1;
            end else begin
                if (&{mm2s_tdata_is_footer, MM2S_S_AXIS_TVALID, MM2S_S_AXIS_TREADY}) begin
                    new_data <= #100 1'b0;
                end else begin
                    new_data <= #100 new_data;
                end
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay, DATAMOVER_ERROR}) begin
            m_axis_tvalid <= #100 1'b0;
        end else begin
            if (&{mm2s_tdata_is_header, MM2S_S_AXIS_TVALID, new_data}) begin
                m_axis_tvalid <= #100 1'b1;
            end else begin
                if (&{m_axis_tdata_is_footer, mm2s_tdata_valid, M_AXIS_TREADY}) begin
                    m_axis_tvalid <= #100 1'b0;
                end else begin
                    m_axis_tvalid <= #100 m_axis_tvalid;
                end
            end
        end
    end

    // (* MARK_DEBUG = "TRUE" *) reg [FRAME_LENGTH_WIDTH-1:0] rcvd_frame_len;
    // (* MARK_DEBUG = "TRUE" *) reg [FRAME_LENGTH_WIDTH:0] frame_len_count;
    // (* MARK_DEBUG = "TRUE" *) wire frame_acquired = (rcvd_frame_len==frame_len_count);
    // (* MARK_DEBUG = "TRUE" *) wire frame_len_mismatch = frame_acquired^mm2s_tdata_is_footer;

    // always @(posedge ACLK ) begin
    //     if (|{~ARESETN, dest_req_delay}) begin
    //         rcvd_frame_len <= #100 max_btt;
    //     end else begin
    //         if (&{mm2s_tdata_is_header, mm2s_tvalid_posedge}) begin
    //             rcvd_frame_len <= #100 MM2S_S_AXIS_TDATA[DATAFRAME_WIDTH-HEADER_FOOTER_ID_WIDTH-CHANNEL_ID_WIDTH-1 -:FRAME_LENGTH_WIDTH-1]+2;
    //         end else begin
    //             rcvd_frame_len <= #100 rcvd_frame_len;
    //         end
    //     end
    // end

    // always @(posedge ACLK ) begin
    //     if (|{~ARESETN, dest_req_delay}) begin
    //         frame_len_count <= #100 0;
    //     end else begin
    //         if (&{mm2s_tdata_is_header, mm2s_tvalid_posedge}) begin
    //             frame_len_count <= #100 1;
    //         end else begin
    //             if (frame_acquired) begin
    //                 frame_len_count <= #100 0;
    //             end else begin
    //                 if (MM2S_S_AXIS_TVALID&MM2S_S_AXIS_TREADY) begin
    //                     frame_len_count <= #100 frame_len_count + 1;
    //                 end else begin
    //                     frame_len_count <= #100 frame_len_count;
    //                 end                    
    //             end
    //         end
    //     end
    // end

    always @(posedge ACLK ) begin
        if (|{~ARESETN, dest_req_delay, DATAMOVER_ERROR}) begin
            m_axis_tdata <= #100 {TDATA_WIDTH{1'b1}};
            mm2s_tdata_valid <= #100 1'b0;
        end else begin
           if (&{m_axis_tvalid, !M_AXIS_TREADY}) begin
               m_axis_tdata <= #100 m_axis_tdata;
               mm2s_tdata_valid <= #100 mm2s_tdata_valid;
           end else begin
               m_axis_tdata <= #100 MM2S_S_AXIS_TDATA;
               mm2s_tdata_valid <= #100 MM2S_S_AXIS_TVALID;
           end 
        end
    end

    assign MM2S_S_AXIS_TREADY = |{M_AXIS_TREADY, !m_axis_tvalid};
    assign M_AXIS_TDATA = m_axis_tdata;
    assign M_AXIS_TVALID = &{m_axis_tvalid, mm2s_tdata_valid};
    assign M_AXIS_TKEEP = m_axis_tkeep;
    assign M_AXIS_TLAST = &{m_axis_tdata_is_footer, m_axis_tvalid, mm2s_tdata_valid};

endmodule