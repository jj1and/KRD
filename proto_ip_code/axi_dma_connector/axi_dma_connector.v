`timescale 1 ps / 1 ps
module axi_dma_connector # (
    parameter integer TDATA_WIDTH = 128
)(
    input wire ACLK,
    input wire ARESET,

    input wire [TDATA_WIDTH-1:0] S_AXIS_TDATA,
    input wire S_AXIS_TVALID,
    input wire S_AXIS_TLAST,
    input wire [TDATA_WIDTH/8-1:0] S_AXIS_TKEEP,
    output wire S_AXIS_TREADY,

    output wire [TDATA_WIDTH-1:0] M_AXIS_TDATA,
    output wire M_AXIS_TVALID,
    output wire M_AXIS_TLAST,
    output wire [TDATA_WIDTH/8-1:0] M_AXIS_TKEEP,
    input wire M_AXIS_TREADY,

    input wire AXIDMA_S2MM_INTR_IN
);
    
    reg s_axis_suppress;
    reg m_axis_suppress;
    reg s2mm_intr_in_delay;
    wire s2mm_intr_negedge = (AXIDMA_S2MM_INTR_IN==1'b0)&(s2mm_intr_in_delay==1'b1);
    always @(posedge ACLK ) begin
        s2mm_intr_in_delay <= #100 AXIDMA_S2MM_INTR_IN;
    end

    always @(posedge ACLK ) begin
        if (ARESET) begin
            s_axis_suppress <= #100 1'b0;
        end else begin
            if (&{S_AXIS_TLAST, S_AXIS_TVALID, M_AXIS_TREADY}) begin
                s_axis_suppress <= #100 1'b1;
            end else begin
                if (s2mm_intr_negedge) begin
                    s_axis_suppress <= #100 1'b0;
                end else begin
                    s_axis_suppress <= #100 s_axis_suppress;
                end
            end
        end
    end

    always @(posedge ACLK ) begin
        if (ARESET) begin
            m_axis_suppress <= #100 1'b0;
        end else begin
            if (&{M_AXIS_TLAST, M_AXIS_TVALID, M_AXIS_TREADY}) begin
                m_axis_suppress <= #100 1'b1;
            end else begin
                if (s2mm_intr_negedge) begin
                    m_axis_suppress <= #100 1'b0;
                end else begin
                    m_axis_suppress <= #100 m_axis_suppress;
                end
            end
        end
    end    

    assign S_AXIS_TREADY = |{M_AXIS_TREADY&(!s_axis_suppress), s2mm_intr_negedge};


    reg m_axis_tvalid;
    reg m_axis_tlast;
    reg [TDATA_WIDTH-1:0] m_axis_tdata;
    reg [TDATA_WIDTH/8-1:0] m_axis_tkeep;

    always @(posedge ACLK ) begin
        if (ARESET) begin
            m_axis_tvalid <= #100 1'b0;
            m_axis_tlast <= #100 1'b0;
            m_axis_tdata <= #100 {TDATA_WIDTH{1'b1}};
            m_axis_tkeep <= #100 {TDATA_WIDTH/8{1'b0}};
        end else begin
            if (&{m_axis_tvalid, !M_AXIS_TREADY}) begin
                m_axis_tvalid <= #100 m_axis_tvalid;
                m_axis_tlast <= #100 m_axis_tlast;
                m_axis_tdata <= #100 m_axis_tdata;
                m_axis_tkeep <= #100 m_axis_tkeep;
            end else begin
                m_axis_tvalid <= #100 S_AXIS_TVALID;
                m_axis_tlast <= #100 S_AXIS_TLAST;
                m_axis_tdata <= #100 S_AXIS_TDATA;
                m_axis_tkeep <= #100 S_AXIS_TKEEP;
            end
        end
    end

    assign M_AXIS_TVALID = &{m_axis_tvalid, !m_axis_suppress};
    assign M_AXIS_TLAST = &{m_axis_tlast, !m_axis_suppress};
    assign M_AXIS_TDATA = m_axis_tdata;
    assign M_AXIS_TKEEP = m_axis_tkeep;
    

endmodule
