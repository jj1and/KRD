`timescale 1 ps / 1 ps

`include "trigger_config.vh"
module dummy_signal_generator # (
    // l-gain/h-gain = $clog2(LGAIN_CORRECTION)
    parameter integer LGAIN_CORRECTION = 8
)(
    input wire ACLK,
    input wire ARESET,
    input wire SET_CONFIG,

    input wire signed [`ADC_RESOLUTION_WIDTH:0] H_GAIN_BASELINE,
    input wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE,

    // S_AXIS interface from AXI DMA IP
    input wire [`RFDC_TDATA_WIDTH-1:0] S_AXIS_TDATA,
    input wire S_AXIS_TVALID,
    output wire S_AXIS_TREADY,

    // M_AXIS interface of dummy RF Data Converter logic IP
    output wire [`RFDC_TDATA_WIDTH-1:0] H_M_AXIS_TDATA,
    output wire H_M_AXIS_TVALID,

    // M_AXIS interfrace of dummy L-gain ADC
    output wire [`LGAIN_TDATA_WIDTH-1:0] L_M_AXIS_TDATA,
    output wire L_M_AXIS_TVALID,

    // M_AXIS interface of dummy DSP module
    output wire [`RFDC_TDATA_WIDTH-1:0] DSP_M_AXIS_TDATA,
    output wire DSP_M_AXIS_TVALID      
);


    reg signed [`ADC_RESOLUTION_WIDTH:0] h_gain_baseline;
    reg signed [`SAMPLE_WIDTH-1:0] l_gain_baseline;

    always @(posedge ACLK ) begin
        if (ARESET) begin
            h_gain_baseline <= #100 -1024;
            l_gain_baseline <= #100 128;
        end else begin
            if (SET_CONFIG) begin
                h_gain_baseline <= #100 H_GAIN_BASELINE;
                l_gain_baseline <= #100 L_GAIN_BASELINE;
            end else begin
                h_gain_baseline <= #100 h_gain_baseline;
                l_gain_baseline <= #100 l_gain_baseline;
            end
        end
    end

    reg tready;
    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            tready <= #100 1'b0;
        end else begin
            tready <= #100 1'b1;
        end
    end

    wire signed [`ADC_RESOLUTION_WIDTH-1:0] s_axis_sample[`SAMPLE_NUM_PER_CLK-1:0];

    reg [`RFDC_TDATA_WIDTH-1:0] h_gain_tdata;
    wire signed [`ADC_RESOLUTION_WIDTH:0] s_axis_sample_bl_subtracted[`SAMPLE_NUM_PER_CLK-1:0];

    reg [`RFDC_TDATA_WIDTH-1:0] dsp_tdata;
    wire signed [`SAMPLE_WIDTH-1:0] dsp_sample[`SAMPLE_NUM_PER_CLK-1:0];

    reg [`LGAIN_TDATA_WIDTH-1:0] l_gain_tdata;
    wire signed [`SAMPLE_WIDTH-1:0] l_gain_sample[`LGAIN_SAMPLE_NUM_PER_CLK-1:0];

    genvar i;
    generate
        for (i=0; i<`SAMPLE_NUM_PER_CLK; i=i+1) begin
            assign s_axis_sample[i] = S_AXIS_TDATA[i*`SAMPLE_WIDTH+(`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH) +:`ADC_RESOLUTION_WIDTH];
            assign s_axis_sample_bl_subtracted[i] = { s_axis_sample[i][`ADC_RESOLUTION_WIDTH-1], s_axis_sample[i] } - h_gain_baseline;
            assign dsp_sample[i] = { {`SAMPLE_WIDTH-(`ADC_RESOLUTION_WIDTH+1){s_axis_sample_bl_subtracted[i][`ADC_RESOLUTION_WIDTH]}}, s_axis_sample_bl_subtracted[i] };
        end

        for (i=0; i<`LGAIN_SAMPLE_NUM_PER_CLK; i=i+1) begin
            assign l_gain_sample[i] = { {(`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH)+$clog2(LGAIN_CORRECTION){s_axis_sample[i*4][`ADC_RESOLUTION_WIDTH-1]}},  s_axis_sample[i*4][`ADC_RESOLUTION_WIDTH-1:$clog2(LGAIN_CORRECTION)]};
        end
    endgenerate


    integer j;
    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            h_gain_tdata <= #100 {`SAMPLE_NUM_PER_CLK{h_gain_baseline[`ADC_RESOLUTION_WIDTH], h_gain_baseline[`ADC_RESOLUTION_WIDTH-2:0], 4'h0}};
            dsp_tdata <= #100 {`SAMPLE_NUM_PER_CLK{16'd0}};
            l_gain_tdata <= #100 {`LGAIN_SAMPLE_NUM_PER_CLK{l_gain_baseline}};            
        end else begin
            h_gain_tdata <= #100 S_AXIS_TDATA;
            for (j=0; j<`SAMPLE_NUM_PER_CLK; j=j+1) begin
                dsp_tdata[j*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] <= #100 dsp_sample[j];
            end
            for (j=0; j<`LGAIN_SAMPLE_NUM_PER_CLK; j=j+1) begin
                l_gain_tdata[j*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] <= #100 l_gain_sample[j];
            end                     
        end
    end

    reg tvalid;
    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            tvalid <= #100 1'b0;
        end else begin
            tvalid <= #100 S_AXIS_TVALID;
        end
    end
    
    assign S_AXIS_TREADY = tready;

    assign H_M_AXIS_TVALID = tvalid;
    assign L_M_AXIS_TVALID = tvalid;
    assign DSP_M_AXIS_TVALID = tvalid;

    assign H_M_AXIS_TDATA = h_gain_tdata;
    assign L_M_AXIS_TDATA = l_gain_tdata;
    assign DSP_M_AXIS_TDATA = dsp_tdata;
    
    
endmodule