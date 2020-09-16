`timescale 1 ps / 1 ps
`include "../dsp_config.vh"

module passthrough_dsp (
    input wire ACLK,
    input wire ARESET,
    input wire SET_CONFIG,

    input wire signed [`ADC_RESOLUTION_WIDTH:0] H_GAIN_BASELINE,

    // M_AXIS interface of dummy RF Data Converter logic IP
    input wire [`RFDC_TDATA_WIDTH-1:0] H_S_AXIS_TDATA,
    input wire H_S_AXIS_TVALID,

    // M_AXIS interfrace of dummy L-gain ADC
    input wire [`LGAIN_TDATA_WIDTH-1:0] L_S_AXIS_TDATA,
    input wire L_S_AXIS_TVALID,

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

    always @(posedge ACLK ) begin
        if (ARESET) begin
            h_gain_baseline <= #100 -1024;
        end else begin
            if (SET_CONFIG) begin
                h_gain_baseline <= #100 H_GAIN_BASELINE;
            end else begin
                h_gain_baseline <= #100 h_gain_baseline;
            end
        end
    end

    wire signed [`ADC_RESOLUTION_WIDTH-1:0] h_gain_sample[`SAMPLE_NUM_PER_CLK-1:0];
    wire signed [`ADC_RESOLUTION_WIDTH:0]  sign_extend_h_gain_sample[`SAMPLE_NUM_PER_CLK-1:0];
    reg [`RFDC_TDATA_WIDTH-1:0] h_gain_tdata;
    wire signed [`ADC_RESOLUTION_WIDTH:0] h_gain_sample_bl_subtracted[`SAMPLE_NUM_PER_CLK-1:0];

    reg [`RFDC_TDATA_WIDTH-1:0] dsp_tdata;
    wire signed [`SAMPLE_WIDTH-1:0] dsp_sample[`SAMPLE_NUM_PER_CLK-1:0];

    reg [`LGAIN_TDATA_WIDTH-1:0] l_gain_tdata;

    genvar i;
    generate
        for (i=0; i<`SAMPLE_NUM_PER_CLK; i=i+1) begin
            assign h_gain_sample[i] = H_S_AXIS_TDATA[i*`SAMPLE_WIDTH+(`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH) +:`ADC_RESOLUTION_WIDTH];
            assign sign_extend_h_gain_sample[i] = { h_gain_sample[i][`ADC_RESOLUTION_WIDTH-1], h_gain_sample[i] };
            assign h_gain_sample_bl_subtracted[i] = sign_extend_h_gain_sample[i] - h_gain_baseline;
            assign dsp_sample[i] = { {`SAMPLE_WIDTH-(`ADC_RESOLUTION_WIDTH+1){h_gain_sample_bl_subtracted[i][`ADC_RESOLUTION_WIDTH]}}, h_gain_sample_bl_subtracted[i] };
        end

    endgenerate


    integer j;
    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            dsp_tdata <= #100 {`SAMPLE_NUM_PER_CLK{16'd0}};         
        end else begin
            for (j=0; j<`SAMPLE_NUM_PER_CLK; j=j+1) begin
                dsp_tdata[j*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] <= #100 dsp_sample[j];
            end                  
        end
    end

    always @(posedge ACLK ) begin
        h_gain_tdata <= #100 H_S_AXIS_TDATA;
        l_gain_tdata <= #100 L_S_AXIS_TDATA;
    end

    reg h_gain_tvalid;
    reg l_gain_tvalid;
    reg dsp_tvalid;

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            dsp_tvalid <= #100 1'b0;
        end else begin
            dsp_tvalid <= #100 H_S_AXIS_TVALID;
        end
    end
    
    always @(posedge ACLK ) begin
        h_gain_tvalid <= #100 H_S_AXIS_TVALID;
        l_gain_tvalid <= #100 L_S_AXIS_TVALID;
    end

    assign H_M_AXIS_TVALID = h_gain_tvalid;
    assign L_M_AXIS_TVALID = l_gain_tvalid;
    assign DSP_M_AXIS_TVALID = dsp_tvalid;

    assign H_M_AXIS_TDATA = h_gain_tdata;
    assign L_M_AXIS_TDATA = l_gain_tdata;
    assign DSP_M_AXIS_TDATA = dsp_tdata;
    
endmodule 
