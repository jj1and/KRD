`timescale 1 ps / 1 ps

module pl_ddr_mmu # (
    parameter integer TDATA_WIDTH = 128,
    // global address size of PL DDR e.g. 4GiB -> 32bit
    parameter integer ADDRESS_WIDTH = 32,
    // local address size which pl_ddr_mmu manages. e.g. 256MiB -> 28bit 
    parameter integer LOCAL_ADDRESS_WIDTH = 28,
    parameter integer PTR_FIFO_DEPTH = 16,
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

    // S_AXIS interface for MM2S DATA port of AXI Data Mover IP
    input wire [TDATA_WIDTH-1:0] MM2S_S_AXIS_TDATA,
    input wire MM2S_S_AXIS_TVALID,
    output wire MM2S_S_AXIS_TREADY,

    // M_AXIS interface for AXIS Interconnect
    output wire [TDATA_WIDTH-1:0] M_AXIS_TDATA,
    output wire M_AXIS_TVALID,
    output wire M_AXIS_TLAST,
    input wire M_AXIS_TREADY
);

    wire [7:0] HEADER_ID = 8'hAA;
    wire [7:0] FOOTER_ID = 8'h55;


    // ------------------------------- mmu configration -------------------------------
    localparam integer BTT_WIDTH = $clog2((2**15-1)*16+3*8)+1;
    reg [3:0] rsvd;
    reg [3:0] tag;
    reg drr;
    reg eof;
    // dsa is effective when drr = 1'b1
    reg [5:0] dsa;
    reg burst_type;
    reg [BTT_WIDTH-1:0] btt;
    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            rsvd <= #100 0;
            drr <= #100 0;
            eof <= #100 1'b1;
            dsa <= #100 0;
            burst_type <= #100 1'b1;
            btt <= #100 152;
        end else begin
            if (SET_CONFIG) begin
                rsvd <= #100 0;
                drr <= #100 0;
                eof <= #100 1'b1;
                dsa <= #100 0;      
                burst_type <= #100 1'b1;
                btt <= #100 (MAX_TRIGGER_LENGTH*16+3*8);                  
            end else begin
                rsvd <= #100 rsvd;
                drr <= #100 drr;
                eof <= #100 eof;
                dsa <= #100 dsa;      
                burst_type <= #100 burst_type;
                btt <= #100 btt;                
            end
        end
    end

    always @(posedge ACLK ) begin
        if (!{ARESET, SET_CONFIG}) begin
            tag <= #100 15;
        end else begin
            if (wr_en) begin
                tag <= #100 tag+1;
            end else begin
                tag <= #100 tag;
            end
        end
    end    

    // ------------------------------- write/read address control -------------------------------
    reg [LOCAL_ADDRESS_WIDTH:0] wp;
    reg [(LOCAL_ADDRESS_WIDTH+1)*PTR_FIFO_DEPTH-1:0] wp_shiftreg;
    reg [$clog2(PTR_FIFO_DEPTH)-1:0] wp_selector;
    reg wp_fifo_empty;
    wire wp_fifo_full = (wp_selector[$clog2(PTR_FIFO_DEPTH)-1:0]==PTR_FIFO_DEPTH-1);
    wire [LOCAL_ADDRESS_WIDTH:0] current_wp = wp_fifo_empty ? wp : wp_shiftreg[LOCAL_ADDRESS_WIDTH*wp_selector[$clog2(PTR_FIFO_DEPTH)-1:0] +:LOCAL_ADDRESS_WIDTH];
    wire [LOCAL_ADDRESS_WIDTH:0] next_current_wp = current_wp+1;

    reg [LOCAL_ADDRESS_WIDTH:0] rp;
    wire [LOCAL_ADDRESS_WIDTH:0] next_rp = rp+1;

    assign EMPTY = (rp == current_wp);
    assign FULL = (current_wp[LOCAL_ADDRESS_WIDTH-1:0] == rp[LOCAL_ADDRESS_WIDTH-1:0])&(current_wp[LOCAL_ADDRESS_WIDTH] != rp[LOCAL_ADDRESS_WIDTH]);
    wire wr_en = &{S2MM_CMD_M_AXIS_TVALID, S2MM_CMD_M_AXIS_TREADY};
    wire rd_en = &{MM2S_CMD_M_AXIS_TVALID, MM2S_CMD_M_AXIS_TREADY};

    always @(posedge ACLK ) begin
        if (wr_en) begin
            wp_shiftreg <= #100 {wp_shiftreg[(LOCAL_ADDRESS_WIDTH+1)*(PTR_FIFO_DEPTH-1)-1:0], wp};
        end else begin
            wp_shiftreg <= #100 wp_shiftreg;
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            wp_fifo_empty <= #100 1'b1;
        end else begin
            if (&{S2MM_WR_XFER_CMPLT, wp_selector==0}) begin
                wp_fifo_empty <= #100 1'b1;
            end else begin
                if (wr_en) begin
                    wp_fifo_empty <= #100 1'b0;
                end else begin
                    wp_fifo_empty <= #100 1'b1;
                end
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            wp_selector <= #100 0;
        end else begin
            if (&{wr_en, S2MM_WR_XFER_CMPLT}) begin
                wp_selector <= #100 wp_selector;
            end else begin
                if (&{wr_en, !wp_fifo_full}) begin
                    wp_selector <= #100 wp_selector + 1;
                end else begin
                    if (&{S2MM_WR_XFER_CMPLT, !wp_fifo_empty}) begin
                        wp_selector <= wp_selector - 1;
                    end else begin
                        wp_selector <= #100 wp_selector;
                    end
                end
            end
        end
    end

    // always @(posedge ACLK ) begin
    //     if (|{ARESET, SET_CONFIG}) begin
    //         current_wp <= #100 wp;
    //     end else begin
    //         if (wp_fifo_empty) begin
    //             current_wp <= #100 wp;
    //         end else begin
    //             current_wp <= #100 wp_shiftreg[LOCAL_ADDRESS_WIDTH*wp_selector[$clog2(PTR_FIFO_DEPTH)-1:0] +:LOCAL_ADDRESS_WIDTH];
    //         end
    //     end
    // end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            wp <= #100 0;
        end else begin
            if (wr_en&(!FULL)) begin
                wp <= #100 wp + btt;
            end else begin
                wp <= #100 wp;
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            rp <= #100 0;
        end else begin
            if (rd_en&(!EMPTY)) begin
                rp <= #100 rp + btt;
            end else begin
                rp <= #100 rp;
            end
        end
    end


    // ------------------------------- S2MM/MM2S Command assigment -------------------------------
    assign S2MM_CMD_M_AXIS_TDATA = {rsvd, tag, wp, drr, eof, dsa, burst_type, {23-BTT_WIDTH{1'b0}}, btt};
    assign S2MM_CMD_M_AXIS_TVALID = &{S_AXIS_TDATA[TDATA_WIDTH -:8]==HEADER_ID, S_AXIS_TVALID};
    assign MM2S_CMD_M_AXIS_TDATA = {rsvd, tag, rp, drr, eof, dsa, burst_type, {23-BTT_WIDTH{1'b0}}, btt};
    assign MM2S_CMD_M_AXIS_TVALID = !EMPTY;

    // ------------------------------- S_AXIS/S2MM DATA assigment -------------------------------
    assign S2MM_M_AXIS_TDATA = S_AXIS_TDATA;
    assign S2MM_M_AXIS_TVALID = S_AXIS_TVALID;
    assign S2MM_M_AXIS_TLAST = S_AXIS_TLAST;
    assign S_AXIS_TREADY = &{S2MM_M_AXIS_TREADY, S2MM_CMD_M_AXIS_TREADY, !wp_fifo_full};

    // ------------------------------- M_AXIS/MM2S DATA assigment -------------------------------
    reg m_axis_tvalid;
    reg [TDATA_WIDTH-1:0] m_axis_tdata;

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            m_axis_tvalid <= #100 1'b0;
        end else begin
            if (&{MM2S_S_AXIS_TDATA[TDATA_WIDTH -:8]==HEADER_ID, MM2S_S_AXIS_TVALID}) begin
                m_axis_tvalid <= #100 1'b1;
            end else begin
                if (&{m_axis_tdata[TDATA_WIDTH -:8]==FOOTER_ID, MM2S_S_AXIS_TVALID, M_AXIS_TREADY}) begin
                    m_axis_tvalid <= #100 1'b0;
                end else begin
                    m_axis_tvalid <= #100 m_axis_tvalid;
                end
            end
        end
    end

    always @(posedge ACLK ) begin
        m_axis_tdata <= #100 MM2S_S_AXIS_TDATA;
    end

    assign MM2S_S_AXIS_TREADY = |{M_AXIS_TREADY, !m_axis_tvalid};
    assign M_AXIS_TDATA = m_axis_tdata;
    assign M_AXIS_TVALID = m_axis_tvalid;
    assign M_AXIS_TLAST = &{m_axis_tdata[TDATA_WIDTH -:8]==FOOTER_ID, m_axis_tvalid};

endmodule