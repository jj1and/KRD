`timescale 1 ps / 1 ps
`include "trigger_config.vh"

module data_trigger # (
    // these parameter must be configured before logic synthesis
    parameter integer MAX_PRE_ACQUISITION_LENGTH = 2,
    parameter integer MAX_POST_ACQUISITION_LENGTH = 2
)(
    input wire ACLK,
    input wire ARESET,
    input wire SET_CONFIG,
    input wire STOP,

    input wire [1:0] ACQUIRE_MODE,

    // S_AXIS interface from RF Data Converter logic IP
    input wire [`RFDC_TDATA_WIDTH-1:0] H_S_AXIS_TDATA,
    input wire H_S_AXIS_TVALID,

    // S_AXIS interfrace from L-gain ADC
    input wire [`LGAIN_TDATA_WIDTH-1:0] L_S_AXIS_TDATA,
    input wire L_S_AXIS_TVALID,

    // S_AXIS interface from DSP module
    input wire [`RFDC_TDATA_WIDTH-1:0] DSP_S_AXIS_TDATA,
    input wire DSP_S_AXIS_TVALID,    

    // Timestamp
    input wire [`TIMESTAMP_WIDTH-1:0] TIMESTAMP,    

    // trigger settings
    input wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRSHOLD,
    input wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD,
    input wire signed [`ADC_RESOLUTION_WIDTH:0] H_GAIN_BASELINE,
    input wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE,
    input wire [$clog2(MAX_PRE_ACQUISITION_LENGTH):0] PRE_ACQUISITION_LENGTH,
    input wire [$clog2(MAX_POST_ACQUISITION_LENGTH):0] POST_ACQUISITION_LENGTH,

    input wire signed [`SAMPLE_WIDTH-1:0] MODE_SWITCH_UPPER_THRESOLD,
    input wire signed [`SAMPLE_WIDTH-1:0] MODE_SWITCH_LOWER_THRESOLD,

    output wire [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] M_AXIS_TDATA,
    output wire M_AXIS_TVALID,

    // h-gain data for charge_sum. timing is syncronized width M_AXIS_TDATA
    output wire [`RFDC_TDATA_WIDTH-1:0] H_GAIN_TDATA,
    output wire H_GAIN_SATURATED_FLAG
);

    // ------------------------------- trigger configration -------------------------------
    reg [1:0] acquire_mode; //  2'b01 => combined mode (always send combined data, dsp is disabled), 2'b01 => normal mode (combined mode is only when saturated, dsp is disabled)
                            //  2'b11 => combined mode (always send combined data, dsp is enabled), 2'b10 => normal mode (combined mode is only when saturated, dsp is enabled)
    reg [$clog2(MAX_PRE_ACQUISITION_LENGTH):0] pre_acquisition_length;
    reg [$clog2(MAX_POST_ACQUISITION_LENGTH):0] post_acquisition_length;
    reg signed [`SAMPLE_WIDTH-1:0] rising_edge_threshold;
    reg signed [`SAMPLE_WIDTH-1:0] falling_edge_threshold;
    reg signed [`ADC_RESOLUTION_WIDTH:0] h_gain_baseline;
    reg signed [`SAMPLE_WIDTH-1:0] l_gain_baseline;   
    wire [`TRIGGER_CONFIG_WIDTH-1:0] trigger_config = { rising_edge_threshold, falling_edge_threshold };

    reg signed [`ADC_RESOLUTION_WIDTH-1:0] mode_switch_upper_ther;
    reg signed [`ADC_RESOLUTION_WIDTH-1:0] mode_switch_lower_ther;

    always @(posedge ACLK ) begin
        if (ARESET) begin
            acquire_mode <= #100 2'b00;
            pre_acquisition_length <= #100 1;
            post_acquisition_length <= #100 1;
            rising_edge_threshold <= #100 1024;
            falling_edge_threshold <= #100 1024;
            h_gain_baseline <= #100 -1024;
            l_gain_baseline <= #100 128;
            mode_switch_upper_ther <= #100 2047; 
            mode_switch_lower_ther <= #100 -2048;                                       
        end else begin
            if (SET_CONFIG) begin
                acquire_mode <= #100 ACQUIRE_MODE;
                pre_acquisition_length <= #100 PRE_ACQUISITION_LENGTH;
                post_acquisition_length <= #100 POST_ACQUISITION_LENGTH;
                rising_edge_threshold <= #100 RISING_EDGE_THRSHOLD;
                falling_edge_threshold <= #100 FALLING_EDGE_THRESHOLD;
                h_gain_baseline <= #100 H_GAIN_BASELINE;
                l_gain_baseline <= #100 L_GAIN_BASELINE;
                mode_switch_upper_ther <= #100 MODE_SWITCH_UPPER_THRESOLD[0 +:`ADC_RESOLUTION_WIDTH]; 
                mode_switch_lower_ther <= #100 MODE_SWITCH_LOWER_THRESOLD[0 +:`ADC_RESOLUTION_WIDTH];                                                        
            end else begin
                acquire_mode <= #100 acquire_mode;
                pre_acquisition_length <= #100 pre_acquisition_length;
                post_acquisition_length <= #100 post_acquisition_length;
                rising_edge_threshold <= #100 rising_edge_threshold;
                falling_edge_threshold <= #100 falling_edge_threshold;
                h_gain_baseline <= #100 h_gain_baseline;
                l_gain_baseline <= #100 l_gain_baseline;
                mode_switch_upper_ther <= #100 mode_switch_upper_ther; 
                mode_switch_lower_ther <= #100 mode_switch_lower_ther;                                           
            end
        end
    end


    // ------------------------------- data stream for dataformat generation -------------------------------
    wire signed [`ADC_RESOLUTION_WIDTH:0] rfdc_sample[`SAMPLE_NUM_PER_CLK-1:0];
    wire signed [`ADC_RESOLUTION_WIDTH:0] h_gain_bl_subtracted[`SAMPLE_NUM_PER_CLK-1:0];
    wire signed [`SAMPLE_WIDTH-1:0] dsp_sample[`SAMPLE_NUM_PER_CLK-1:0];
    wire signed [`SAMPLE_WIDTH-1:0] l_gain_sample[`LGAIN_SAMPLE_NUM_PER_CLK-1:0];
    wire signed [`SAMPLE_WIDTH-1:0] l_gain_bl_subtracted[`LGAIN_SAMPLE_NUM_PER_CLK-1:0];
    wire [`RFDC_TDATA_WIDTH-1:0] normal_tdata; 
    wire [`RFDC_TDATA_WIDTH-1:0] combined_tdata;
    wire signed [`SAMPLE_WIDTH:0] sum_of_2samples[3:0];
    wire signed [`SAMPLE_WIDTH:0] sum_of_2dsp_samples[3:0];
    wire signed [`SAMPLE_WIDTH-1:0] average_of_2samples[3:0];
    wire signed [`SAMPLE_WIDTH-1:0] average_of_2dsp_samples[3:0];
    wire dsp_mode_enable = acquire_mode[1];

    genvar i;
    generate
            for (i=0; i<`SAMPLE_NUM_PER_CLK; i=i+1) begin
                assign rfdc_sample[i] =  {H_S_AXIS_TDATA[(i+1)*`SAMPLE_WIDTH-1], H_S_AXIS_TDATA[i*`SAMPLE_WIDTH+`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH +:`ADC_RESOLUTION_WIDTH]};
                assign h_gain_bl_subtracted[i] = rfdc_sample[i] - h_gain_baseline;
                assign dsp_sample[i] = DSP_S_AXIS_TDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
                // assign normal_tdata[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] = { {`SAMPLE_WIDTH-(`ADC_RESOLUTION_WIDTH+1){h_gain_bl_subtracted[i][`ADC_RESOLUTION_WIDTH]}}, h_gain_bl_subtracted[i][`ADC_RESOLUTION_WIDTH:0] };                
                assign normal_tdata[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] = dsp_mode_enable ? 
                                                                                    DSP_S_AXIS_TDATA : 
                                                                                    { {`SAMPLE_WIDTH-(`ADC_RESOLUTION_WIDTH+1){h_gain_bl_subtracted[i][`ADC_RESOLUTION_WIDTH]}}, h_gain_bl_subtracted[i][`ADC_RESOLUTION_WIDTH:0] };
            end
            for (i=0; i<4; i=i+1) begin
                assign sum_of_2samples[i] = h_gain_bl_subtracted[i*2] + h_gain_bl_subtracted[i*2+1];
                assign average_of_2samples[i] = sum_of_2samples[i][`SAMPLE_WIDTH:1]; // divided by 2nsec
                assign sum_of_2dsp_samples[i] = dsp_sample[i*2] + dsp_sample[i*2+1];
                assign average_of_2dsp_samples[i] = sum_of_2dsp_samples[i][`SAMPLE_WIDTH:1]; // divided by 2nsec                
            end
            for (i=0; i<2; i=i+1) begin
                assign l_gain_sample[i] = L_S_AXIS_TDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
                assign l_gain_bl_subtracted[i] = l_gain_sample[i] - l_gain_baseline;
                // assign combined_tdata[i*(`RFDC_TDATA_WIDTH/2) +:(`RFDC_TDATA_WIDTH/2)] = {16'hCC00, average_of_2samples[i*2+1], average_of_2samples[i*2],  l_gain_bl_subtracted[i]};                
                assign combined_tdata[i*(`RFDC_TDATA_WIDTH/2) +:(`RFDC_TDATA_WIDTH/2)] = dsp_mode_enable ? 
                                                                                                    {16'hCC00, average_of_2dsp_samples[i*2+1], average_of_2dsp_samples[i*2],  l_gain_bl_subtracted[i]} :
                                                                                                    {16'hCC00, average_of_2samples[i*2+1], average_of_2samples[i*2],  l_gain_bl_subtracted[i]};
            end
    endgenerate


    // ------------------------------- Trigger & ADC data, timstamp delay ------------------------------- 
    wire [$clog2(MAX_PRE_ACQUISITION_LENGTH+3):0] TRIGGER_CORE_DELAY_FOR_DATA = 3;
    wire [$clog2(MAX_PRE_ACQUISITION_LENGTH+3):0] TRIGGER_CORE_DELAY_FOR_RST_CONFIG = 2;

    wire EXTEND_TRIGGER;
    wire delayed_saturated_flag;

    // trigger_core must supress trigger until data in shift register gets valid data
    wire extend_areset;
    wire extend_set_config;
    wire [`RFDC_TDATA_WIDTH-1:0] delayed_normal_tdata;
    wire [`RFDC_TDATA_WIDTH-1:0] delayed_combined_tdata;
    wire [`TIMESTAMP_WIDTH-1:0] delayed_timestamp;

    variable_shiftreg_delay # (
        .DATA_WIDTH(1),
        .MAX_DELAY_LENGTH(MAX_PRE_ACQUISITION_LENGTH)
    ) saturated_flag_delay_inst (
        .CLK(ACLK),
        .DIN(SATURATED_FLAG),
        .DELAY(pre_acquisition_length),
        .DOUT(delayed_saturated_flag)
    );

    variable_shiftreg_delay # (
        .DATA_WIDTH(2),
        .MAX_DELAY_LENGTH(MAX_PRE_ACQUISITION_LENGTH+3)
    ) extend_areset_set_config_inst (
        .CLK(ACLK),
        .DIN({ARESET, SET_CONFIG}),
        .DELAY(pre_acquisition_length+TRIGGER_CORE_DELAY_FOR_RST_CONFIG),
        .DOUT({extend_areset, extend_set_config})
    );         

    variable_shiftreg_delay # (
        .DATA_WIDTH(`RFDC_TDATA_WIDTH),
        .MAX_DELAY_LENGTH(MAX_PRE_ACQUISITION_LENGTH+3)
    ) h_gain_data_delay_inst (
        .CLK(ACLK),
        .DIN(normal_tdata),
        .DELAY(pre_acquisition_length+TRIGGER_CORE_DELAY_FOR_DATA),
        .DOUT(delayed_normal_tdata)
    );

    variable_shiftreg_delay # (
        .DATA_WIDTH(`RFDC_TDATA_WIDTH),
        .MAX_DELAY_LENGTH(MAX_PRE_ACQUISITION_LENGTH+3)
    ) l_gain_data_delay_inst (
        .CLK(ACLK),
        .DIN(combined_tdata),
        .DELAY(pre_acquisition_length+TRIGGER_CORE_DELAY_FOR_DATA),
        .DOUT(delayed_combined_tdata)
    );

    variable_shiftreg_delay # (
        .DATA_WIDTH(`TIMESTAMP_WIDTH),
        .MAX_DELAY_LENGTH(MAX_PRE_ACQUISITION_LENGTH+3)
    ) timestamp_delay_inst (
        .CLK(ACLK),
        .DIN(TIMESTAMP),
        .DELAY(pre_acquisition_length+TRIGGER_CORE_DELAY_FOR_DATA),
        .DOUT(delayed_timestamp)
    );


    // ------------------------------- ADC selector -------------------------------
    wire combined_mode_enable = acquire_mode[0];

    wire SATURATED_FLAG;
    reg [`RFDC_TDATA_WIDTH-1:0] h_gain_tdata;
    reg [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] m_axis_tdata;
    reg m_axis_tvalid;

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            m_axis_tdata <= #100 {`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH{1'b1}};    
        end else begin
            if (delayed_saturated_flag|combined_mode_enable) begin
                m_axis_tdata <= #100 {delayed_combined_tdata, {3'b0, ~(delayed_saturated_flag|combined_mode_enable), 4'b0}, delayed_timestamp, trigger_config};
            end else begin
                m_axis_tdata <= #100 {delayed_normal_tdata, {3'b0, ~(delayed_saturated_flag|combined_mode_enable), 4'b0}, delayed_timestamp, trigger_config};
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            m_axis_tvalid <= #100 1'b0;
        end else begin
            m_axis_tvalid <= #100 EXTEND_TRIGGER;
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            h_gain_tdata <= #100 {`RFDC_TDATA_WIDTH{1'b1}};
        end else begin
            h_gain_tdata <= #100 delayed_normal_tdata;
        end
    end

    reg  h_gain_saturated_flag;
    always @(posedge ACLK ) begin
        h_gain_saturated_flag <= #100 delayed_saturated_flag;
    end

    assign M_AXIS_TDATA = m_axis_tdata;
    assign M_AXIS_TVALID = m_axis_tvalid;
    assign H_GAIN_TDATA = h_gain_tdata;
    assign H_GAIN_SATURATED_FLAG = h_gain_saturated_flag;

    // trigger_core TRIGGER & GAIN_TYPE is syncronized to 3CLK delayed H_S_AXIS_TDATA
    // trigger is already extended in trigger_core, for pre & post acquisition
    // TRIGGER_CONFIG is only changed at run-change
    trigger_core # (
        .MAX_PRE_ACQUISITION_LENGTH(MAX_PRE_ACQUISITION_LENGTH),
        .MAX_POST_ACQUISITION_LENGTH(MAX_POST_ACQUISITION_LENGTH)
    ) trigger_core_inst (
        .ACLK(ACLK),
        .ARESET(ARESET|extend_areset),
        .SET_CONFIG(SET_CONFIG|extend_set_config),
        .STOP(STOP),

        .S_AXIS_TDATA(normal_tdata),
        .S_AXIS_TVALID(&{H_S_AXIS_TVALID, L_S_AXIS_TVALID, DSP_S_AXIS_TVALID}),
        // S_AXIS interface from RF Data Converter logic IP
        .H_S_AXIS_TDATA(H_S_AXIS_TDATA),

        // trigger settings
        .RISING_EDGE_THRSHOLD(rising_edge_threshold),
        .FALLING_EDGE_THRESHOLD(falling_edge_threshold),
        .PRE_ACQUISITION_LENGTH(pre_acquisition_length),
        .POST_ACQUISITION_LENGTH(post_acquisition_length),
        .MODE_SWITCH_UPPER_THRESOLD(mode_switch_upper_ther),
        .MODE_SWITCH_LOWER_THRESOLD(mode_switch_lower_ther),

        // trigger and gain-mode for ADC selector
        .TRIGGER(EXTEND_TRIGGER),
        .SATURATION_FLAG(SATURATED_FLAG)
    );

endmodule