`timescale 1 ps / 1 ps

module pl_ddr_mmu # (
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
    input wire ARESET,
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

    // write transaction done signal from AXI Data Mover IP
    input wire S2MM_WR_XFER_CMPLT,

    // M_AXIS inferface for MM2S CMD port of AXI Data Mover IP
    output wire [ADDRESS_WIDTH+40-1:0] MM2S_CMD_M_AXIS_TDATA,
    output wire MM2S_CMD_M_AXIS_TVALID,
    input wire MM2S_CMD_M_AXIS_TREADY,

    // read transaction done signal frmo AXI Data Mover IP
    input wire MM2S_RD_XFER_CMPLT,

    // S_AXIS interface for MM2S DATA port of AXI Data Mover IP
    input wire [TDATA_WIDTH-1:0] MM2S_S_AXIS_TDATA,
    input wire MM2S_S_AXIS_TVALID,
    output wire MM2S_S_AXIS_TREADY,

    // M_AXIS interface for AXIS Interconnect
    output wire [TDATA_WIDTH-1:0] M_AXIS_TDATA,
    output wire M_AXIS_TVALID,
    output wire M_AXIS_TLAST,
    output wire [TDATA_WIDTH/8-1:0] M_AXIS_TKEEP,
    input wire M_AXIS_TREADY,

    input wire S2MM_ERR,
    input wire MM2S_ERR,
    output wire DATAMOVER_ERROR
);

    localparam integer DATAFRAME_WIDTH = TDATA_WIDTH/2;
    wire [7:0] HEADER_ID = 8'hAA;
    wire [7:0] FOOTER_ID = 8'h55;

    assign DATAMOVER_ERROR = S2MM_ERR|MM2S_ERR;

    // ------------------------------- mmu configration -------------------------------
    localparam integer BTT_WIDTH = $clog2((2**15-1)*16+3*8)+1;
    reg [3:0] rsvd;
    reg drr;
    reg eof;
    // dsa is effective when drr = 1'b1
    reg [5:0] dsa;
    reg burst_type;
    reg [BTT_WIDTH-1:0] max_btt;
    always @(posedge ACLK ) begin
        if (|{ARESET, DATAMOVER_ERROR}) begin
            rsvd <= #100 0;
            drr <= #100 0;
            eof <= #100 1'b1;
            dsa <= #100 0;
            burst_type <= #100 1'b1;
            max_btt <= #100 16*16+32;
        end else begin
            if (SET_CONFIG) begin
                rsvd <= #100 0;
                drr <= #100 0;
                eof <= #100 1'b1;
                dsa <= #100 0;      
                burst_type <= #100 1'b1;
                max_btt <= #100 (MAX_TRIGGER_LENGTH*16+32);                  
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

    // ------------------------------- write/read address control -------------------------------
    reg [LOCAL_ADDRESS_WIDTH:0] src_addr;
    reg [LOCAL_ADDRESS_WIDTH:0] dest_addr;
    reg [LOCAL_ADDRESS_WIDTH:0] next_src_addr;
    reg [LOCAL_ADDRESS_WIDTH:0] next_dest_addr;
    wire [LOCAL_ADDRESS_WIDTH-1:0] ACTUAL_HIGH_ADDRESS = {LOCAL_ADDRESS_WIDTH{1'b1}} - max_btt; 
    wire empty = (src_addr == dest_addr);
    wire full = (src_addr[LOCAL_ADDRESS_WIDTH-1:0] == dest_addr[LOCAL_ADDRESS_WIDTH-1:0])&(src_addr[LOCAL_ADDRESS_WIDTH] != dest_addr[LOCAL_ADDRESS_WIDTH]);
    wire almost_empty = (next_src_addr[LOCAL_ADDRESS_WIDTH-1:0] == dest_addr[LOCAL_ADDRESS_WIDTH-1:0])&(next_src_addr[LOCAL_ADDRESS_WIDTH] == dest_addr[LOCAL_ADDRESS_WIDTH]);
    wire almost_full = (next_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] == src_addr[LOCAL_ADDRESS_WIDTH-1:0])&(next_dest_addr[LOCAL_ADDRESS_WIDTH] != src_addr[LOCAL_ADDRESS_WIDTH]);    

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG, DATAMOVER_ERROR}) begin
            dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 0;
            dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 1'b0;
        end else begin
            if (S2MM_WR_XFER_CMPLT) begin
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
        if (|{ARESET, SET_CONFIG, DATAMOVER_ERROR}) begin
            next_dest_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 max_btt;
            next_dest_addr[LOCAL_ADDRESS_WIDTH] <= #100 1'b0;
        end else begin
            if (S2MM_WR_XFER_CMPLT) begin
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
        if (|{ARESET, SET_CONFIG, DATAMOVER_ERROR}) begin
            src_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 0;
            src_addr[LOCAL_ADDRESS_WIDTH] <= #100 1'b0;
        end else begin
            if (MM2S_RD_XFER_CMPLT) begin
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
        if (|{ARESET, SET_CONFIG, DATAMOVER_ERROR}) begin
            next_src_addr[LOCAL_ADDRESS_WIDTH-1:0] <= #100 max_btt;
            next_src_addr[LOCAL_ADDRESS_WIDTH] <= #100 1'b0;
        end else begin
            if (MM2S_RD_XFER_CMPLT) begin
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
        if (|{ARESET, SET_CONFIG}) begin
            write_ready <= #100 1'b1;
        end else begin
            if (|{S2MM_M_AXIS_TLAST&S2MM_M_AXIS_TREADY, DATAMOVER_ERROR}) begin
                write_ready <= #100 1'b0;
            end else begin
                if (S2MM_WR_XFER_CMPLT) begin
                    write_ready <= #100 1'b1;
                end else begin
                    write_ready <= #100 write_ready;
                end
            end
        end
    end
    
    assign S2MM_M_AXIS_TDATA = S_AXIS_TDATA;
    assign S2MM_M_AXIS_TVALID = &{S_AXIS_TVALID, write_ready, !almost_full, !full};
    assign S2MM_M_AXIS_TLAST = S_AXIS_TLAST;
    assign S_AXIS_TREADY = &{S2MM_M_AXIS_TREADY, write_ready, !almost_full, !full};

    // ------------------------------- S2MM Command assigment -------------------------------
    reg s2mm_cmd_tvaild;
    reg [3:0] s2mm_tag;

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG, DATAMOVER_ERROR}) begin
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
        if (|{ARESET, SET_CONFIG, DATAMOVER_ERROR}) begin
            s2mm_tag <= #100 0;
        end else begin
            if (S2MM_WR_XFER_CMPLT) begin
                s2mm_tag <= #100 s2mm_tag+1;
            end else begin
                s2mm_tag <= #100 s2mm_tag;
            end
        end
    end

    // For Non-IBTT Mode
    // reg [BTT_WIDTH-1:0] s2mm_btt;
    // always @(posedge ACLK ) begin
    //     if (|{ARESET, SET_CONFIG}) begin
    //         s2mm_btt <= #100 max_btt;
    //     end else begin
    //         if (&{S_AXIS_TDATA[DATAFRAME_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==HEADER_ID, S2MM_M_AXIS_TVALID, S2MM_M_AXIS_TREADY}) begin
    //             s2mm_btt <= #100 S_AXIS_TDATA[DATAFRAME_WIDTH-HEADER_FOOTER_ID_WIDTH-CHANNEL_ID_WIDTH-1 -:FRAME_LENGTH_WIDTH]*8+32;
    //         end else begin
    //             s2mm_btt <= #100 s2mm_btt;
    //         end
    //     end
    // end
    // assign S2MM_CMD_M_AXIS_TDATA = {rsvd, s2mm_tag, src_addr+BASE_ADDRESS, drr, eof, dsa, burst_type, {23-BTT_WIDTH{1'b0}}, s2mm_btt};

    assign S2MM_CMD_M_AXIS_TDATA = {rsvd, s2mm_tag, dest_addr[LOCAL_ADDRESS_WIDTH-1:0]+BASE_ADDRESS, drr, eof, dsa, burst_type, {23-BTT_WIDTH{1'b0}}, max_btt};
    assign S2MM_CMD_M_AXIS_TVALID = s2mm_cmd_tvaild;

    // ------------------------------- MM2S Command assigment -------------------------------
    reg mm2s_cmd_tvalid;
    reg [3:0] mm2s_tag;
    reg read_ready;

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            read_ready <= #100 1'b1;
        end else begin
            if (|{MM2S_CMD_M_AXIS_TVALID&MM2S_CMD_M_AXIS_TREADY, DATAMOVER_ERROR}) begin
                read_ready <= #100 1'b0;
            end else begin
                if (MM2S_RD_XFER_CMPLT) begin
                    read_ready <= #100 1'b1;
                end else begin
                    read_ready <= #100 read_ready;
                end
            end
        end
    end    

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG, DATAMOVER_ERROR}) begin
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
        if (|{ARESET, SET_CONFIG, DATAMOVER_ERROR}) begin
            mm2s_tag <= #100 0;
        end else begin
            if (MM2S_CMD_M_AXIS_TVALID&MM2S_CMD_M_AXIS_TREADY) begin
                mm2s_tag <= #100 mm2s_tag+1;
            end else begin
                mm2s_tag <= #100 mm2s_tag;
            end
        end
    end    

    assign MM2S_CMD_M_AXIS_TDATA = {rsvd, mm2s_tag, src_addr[LOCAL_ADDRESS_WIDTH-1:0]+BASE_ADDRESS, drr, eof, dsa, burst_type, {23-BTT_WIDTH{1'b0}}, max_btt};
    assign MM2S_CMD_M_AXIS_TVALID = mm2s_cmd_tvalid;

    // ------------------------------- M_AXIS/MM2S DATA assigment -------------------------------
    reg m_axis_tvalid;
    reg mm2s_tvalid_delay;
    reg mm2s_tdata_valid;
    wire mm2s_tvalid_posedge = (MM2S_S_AXIS_TVALID==1'b1)&(mm2s_tvalid_delay==1'b0);
    wire mm2s_tdata_is_header =  (MM2S_S_AXIS_TDATA[DATAFRAME_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==HEADER_ID);
    wire mm2s_tdata_is_footer = (MM2S_S_AXIS_TDATA[DATAFRAME_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==FOOTER_ID);
    wire m_axis_tdata_is_footer = (m_axis_tdata[DATAFRAME_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==FOOTER_ID);

    reg [TDATA_WIDTH/8-1:0] m_axis_tkeep;
    reg [TDATA_WIDTH-1:0] m_axis_tdata;

    always @(posedge ACLK ) begin
        mm2s_tvalid_delay <= #100 MM2S_S_AXIS_TVALID;
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG, DATAMOVER_ERROR}) begin
            m_axis_tvalid <= #100 1'b0;
        end else begin
            if (&{mm2s_tdata_is_header, mm2s_tvalid_posedge}) begin
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
    //     if (|{ARESET, SET_CONFIG}) begin
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
    //     if (|{ARESET, SET_CONFIG}) begin
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
        if (|{ARESET, SET_CONFIG, DATAMOVER_ERROR}) begin
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

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG, DATAMOVER_ERROR}) begin
            m_axis_tkeep <= #100 {TDATA_WIDTH/8{1'b0}};
        end else begin
            if (&{m_axis_tvalid, !M_AXIS_TREADY}) begin
                m_axis_tkeep <= #100 m_axis_tkeep;
            end else begin
                if (!MM2S_S_AXIS_TVALID) begin
                    m_axis_tkeep <= #100 {TDATA_WIDTH/8{1'b0}};
                end else begin
                    if (mm2s_tdata_is_footer) begin
                        m_axis_tkeep <= #100 {{TDATA_WIDTH/16{1'b0}}, {TDATA_WIDTH/16{1'b1}}};
                    end else begin
                        m_axis_tkeep <= #100  {TDATA_WIDTH/8{1'b1}};
                    end                    
                end
            end
        end
    end

    assign MM2S_S_AXIS_TREADY = |{M_AXIS_TREADY, !m_axis_tvalid};
    assign M_AXIS_TDATA = m_axis_tdata;
    assign M_AXIS_TVALID = &{m_axis_tvalid, mm2s_tdata_valid};
    assign M_AXIS_TKEEP = m_axis_tkeep;
    assign M_AXIS_TLAST = &{m_axis_tdata_is_footer, m_axis_tvalid, mm2s_tdata_valid};

endmodule