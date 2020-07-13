`timescale 1 ps / 1 ps
`include "trigger_config.vh"

module data_trigger # (
    // these parameter must be configured before logic synthesis
    parameter integer MAX_PRE_ACQUISITION_LENGTH = 2,
    parameter integer MAX_POST_ACQUISITION_LENGTH = 2,
    parameter integer MAX_ADC_SELECTION_PERIOD_LENGTH = 4
)(
    input wire ACLK,
    input wire ARESET,
    input wire SET_CONFIG,
    input wire STOP,

    // S_AXIS interface from RF Data Converter logic IP
    input wire [`RFDC_TDATA_WIDTH-1:0] H_S_AXIS_TDATA,
    input wire H_S_AXIS_TVALID,

    // S_AXIS interfrace from L-gain ADC
    input wire [`LGAIN_TDATA_WIDTH-1:0] L_S_AXIS_TDATA,
    input wire L_S_AXIS_TVALID,

    // Timestamp
    input wire [`TIMESTAMP_WIDTH-1:0] TIMESTAMP,    

    // trigger settings
    input wire signed [`ADC_RESOLUTION_WIDTH:0] RISING_EDGE_THRSHOLD,
    input wire signed [`ADC_RESOLUTION_WIDTH:0] FALLING_EDGE_THRESHOLD,
    input wire signed [`ADC_RESOLUTION_WIDTH:0] DIGITAL_BASELINE,
    input wire [$clog2(MAX_PRE_ACQUISITION_LENGTH)-1:0] PRE_ACQUISITION_LENGTH,
    input wire [$clog2(MAX_POST_ACQUISITION_LENGTH)-1:0] POST_ACQUISITION_LENGTH,
    input wire [$clog2(MAX_ADC_SELECTION_PERIOD_LENGTH)-1:0] ADC_SELECTION_PERIOD_LENGTH,

    output wire [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] M_AXIS_TDATA,
    output wire M_AXIS_TVALID,

    // h-gain data for charge_sum. timing is syncronized width M_AXIS_TDATA
    output wire [`RFDC_TDATA_WIDTH-1:0] H_GAIN_BASELINE_SUBTRACTED_TDATA
);

    // ------------------------------- trigger configration -------------------------------
    localparam integer BASELINE_EFFECTIVE_WIDTH = `TRIGGER_CONFIG_WIDTH-(`ADC_RESOLUTION_WIDTH+1)*2;

    reg [$clog2(MAX_PRE_ACQUISITION_LENGTH)-1:0] pre_acquisition_length;
    reg [$clog2(MAX_POST_ACQUISITION_LENGTH)-1:0] post_acquisition_length;
    reg [$clog2(MAX_ADC_SELECTION_PERIOD_LENGTH)-1:0] adc_selection_period_length;
    reg signed [`ADC_RESOLUTION_WIDTH:0] rising_edge_threshold;
    reg signed [`ADC_RESOLUTION_WIDTH:0] falling_edge_threshold;
    reg signed [`ADC_RESOLUTION_WIDTH:0] digital_baseline;        
    wire trigger_config = {digital_baseline[`ADC_RESOLUTION_WIDTH -:BASELINE_EFFECTIVE_WIDTH], rising_edge_threshold, falling_edge_threshold};

    always @(posedge ACLK ) begin
        if (ARESET) begin
            pre_acquisition_length <= #100 1;
            post_acquisition_length <= #100 1;
            adc_selection_period_length <= #100 2;
            rising_edge_threshold <= #100 1024;
            falling_edge_threshold <= #100 1024;
            digital_baseline <= #100 0;                               
        end else begin
            if (SET_CONFIG) begin
                pre_acquisition_length <= #100 PRE_ACQUISITION_LENGTH;
                post_acquisition_length <= #100 POST_ACQUISITION_LENGTH;
                adc_selection_period_length <= #100 ADC_SELECTION_PERIOD_LENGTH;
                rising_edge_threshold <= #100 RISING_EDGE_THRSHOLD;
                falling_edge_threshold <= #100 FALLING_EDGE_THRESHOLD;
                digital_baseline <= #100 { DIGITAL_BASELINE[`ADC_RESOLUTION_WIDTH -:BASELINE_EFFECTIVE_WIDTH], {`ADC_RESOLUTION_WIDTH+1-BASELINE_EFFECTIVE_WIDTH{1'b0}} };                                      
            end else begin
                pre_acquisition_length <= #100 pre_acquisition_length;
                post_acquisition_length <= #100 post_acquisition_length;
                adc_selection_period_length <= #100 adc_selection_period_length;
                rising_edge_threshold <= #100 rising_edge_threshold;
                falling_edge_threshold <= #100 falling_edge_threshold;
                digital_baseline <= #100 digital_baseline;                
            end
        end
    end


    // ------------------------------- data stream for dataformat generation -------------------------------
    wire signed [`SAMPLE_WIDTH-1:0] rfdc_sample[`SAMPLE_NUM_PER_CLK-1:0];
    wire signed [`SAMPLE_WIDTH-1:0] normal_tdata_sample[`SAMPLE_NUM_PER_CLK-1:0];
    wire [`RFDC_TDATA_WIDTH-1:0] normal_tdata; 
    wire [`RFDC_TDATA_WIDTH-1:0] combined_tdata;
    wire [`SAMPLE_WIDTH:0] sum_of_2samples[3:0];
    wire [`SAMPLE_WIDTH-1:0] average_of_2samples[3:0];

    genvar i;
    generate
            for (i=0; i<`SAMPLE_NUM_PER_CLK; i=i+1) begin
                assign rfdc_sample[i] =  { {`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH{H_S_AXIS_TDATA[`SAMPLE_WIDTH*(i+1)-1]}}, H_S_AXIS_TDATA[i*`SAMPLE_WIDTH +:`ADC_RESOLUTION_WIDTH] };
                assign normal_tdata_sample[i] = rfdc_sample[i] - digital_baseline;
                assign normal_tdata[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] = normal_tdata_sample[i];
            end
            for (i=0; i<4; i=i+1) begin
                assign sum_of_2samples[i] = normal_tdata_sample[i*2] + normal_tdata_sample[i*2+1];
                assign average_of_2samples[i] = sum_of_2samples[i][`SAMPLE_WIDTH:1]; // divided by 2nsec
            end
            for (i=0; i<2; i=i+1) begin
                assign combined_tdata[i*(`RFDC_TDATA_WIDTH/2) +:(`RFDC_TDATA_WIDTH/2)] = {16'hCC00, average_of_2samples[i*2+1], average_of_2samples[i*2], L_S_AXIS_TDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] };
            end
    endgenerate


    // ------------------------------- Trigger & ADC data, timstamp delay ------------------------------- 
    wire [$clog2(MAX_ADC_SELECTION_PERIOD_LENGTH+MAX_PRE_ACQUISITION_LENGTH+3)-1:0] TRIGGER_CORE_DELAY_FOR_DATA = 3;

    wire EXTEND_TRIGGER;
    wire delayed_extend_trigger;
    wire [`RFDC_TDATA_WIDTH-1:0] delayed_normal_tdata;
    wire [`RFDC_TDATA_WIDTH-1:0] delayed_combined_tdata;
    wire [`TIMESTAMP_WIDTH-1:0] delayed_timestamp;

    variable_shiftreg_delay # (
        .DATA_WIDTH(1),
        .MAX_DELAY_LENGTH(MAX_ADC_SELECTION_PERIOD_LENGTH)
    ) extend_trigger_delay_inst (
        .CLK(ACLK),
        .DIN(EXTEND_TRIGGER),
        .DELAY(adc_selection_period_length),
        .DOUT(delayed_extend_trigger)
    );

    variable_shiftreg_delay # (
        .DATA_WIDTH(`RFDC_TDATA_WIDTH),
        .MAX_DELAY_LENGTH(MAX_ADC_SELECTION_PERIOD_LENGTH+MAX_PRE_ACQUISITION_LENGTH+3)
    ) h_gain_data_delay_inst (
        .CLK(ACLK),
        .DIN(normal_tdata),
        .DELAY(adc_selection_period_length+pre_acquisition_length+TRIGGER_CORE_DELAY_FOR_DATA),
        .DOUT(delayed_normal_tdata)
    );

    variable_shiftreg_delay # (
        .DATA_WIDTH(`RFDC_TDATA_WIDTH),
        .MAX_DELAY_LENGTH(MAX_ADC_SELECTION_PERIOD_LENGTH+MAX_PRE_ACQUISITION_LENGTH+3)
    ) l_gain_data_delay_inst (
        .CLK(ACLK),
        .DIN(combined_tdata),
        .DELAY(adc_selection_period_length+pre_acquisition_length+TRIGGER_CORE_DELAY_FOR_DATA),
        .DOUT(delayed_combined_tdata)
    );

    variable_shiftreg_delay # (
        .DATA_WIDTH(`TIMESTAMP_WIDTH),
        .MAX_DELAY_LENGTH(MAX_ADC_SELECTION_PERIOD_LENGTH+MAX_PRE_ACQUISITION_LENGTH+3)
    ) timestamp_delay_inst (
        .CLK(ACLK),
        .DIN(TIMESTAMP),
        .DELAY(adc_selection_period_length+pre_acquisition_length+TRIGGER_CORE_DELAY_FOR_DATA),
        .DOUT(delayed_timestamp)
    );


    // ------------------------------- ADC selector -------------------------------
    wire SATURATED_FLAG;
    reg [`RFDC_TDATA_WIDTH-1:0] h_gain_baseline_subtracted_tdata;
    reg [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] m_axis_tdata;
    reg m_axis_tvalid;

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            m_axis_tdata <= #100 {`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH{1'b1}};    
        end else begin
            if (SATURATED_FLAG) begin
                m_axis_tdata <= #100 {delayed_combined_tdata, {3'b0, ~SATURATED_FLAG, 4'b0}, delayed_timestamp, trigger_config};
            end else begin
                m_axis_tdata <= #100 {delayed_normal_tdata, {3'b0, ~SATURATED_FLAG, 4'b0}, delayed_timestamp, trigger_config};
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            m_axis_tvalid <= #100 1'b0;
        end else begin
            m_axis_tvalid <= #100 delayed_extend_trigger;
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            h_gain_baseline_subtracted_tdata <= #100 {`RFDC_TDATA_WIDTH{1'b1}};
        end else begin
            h_gain_baseline_subtracted_tdata <= #100 delayed_normal_tdata;
        end
    end

    assign M_AXIS_TDATA = m_axis_tdata;
    assign M_AXIS_TVALID = m_axis_tvalid;
    assign H_GAIN_BASELINE_SUBTRACTED_TDATA = h_gain_baseline_subtracted_tdata;

    // trigger_core TRIGGER & GAIN_TYPE is syncronized to 3CLK delayed H_S_AXIS_TDATA
    // trigger is already extended in trigger_core, for pre & post acquisition
    // TRIGGER_CONFIG is only changed at run-change
    trigger_core # (
        .MAX_PRE_ACQUISITION_LENGTH(MAX_PRE_ACQUISITION_LENGTH),
        .MAX_POST_ACQUISITION_LENGTH(MAX_POST_ACQUISITION_LENGTH),
        .MAX_ADC_SELECTION_PERIOD_LENGTH(MAX_ADC_SELECTION_PERIOD_LENGTH)
    ) trigger_core_inst (
        .ACLK(ACLK),
        .ARESET(ARESET),
        .SET_CONFIG(SET_CONFIG),
        .STOP(STOP),

        // S_AXIS interface from RF Data Converter logic IP
        .S_AXIS_TDATA(H_S_AXIS_TDATA),
        .S_AXIS_TVALID(H_S_AXIS_TVALID),

        // trigger settings
        .RISING_EDGE_THRSHOLD(rising_edge_threshold),
        .FALLING_EDGE_THRESHOLD(falling_edge_threshold),
        .DIGITAL_BASELINE(digital_baseline),
        .PRE_ACQUISITION_LENGTH(pre_acquisition_length),
        .POST_ACQUISITION_LENGTH(post_acquisition_length),
        .ADC_SELECTION_PERIOD_LENGTH(adc_selection_period_length),

        // trigger and gain-mode for ADC selector
        .TRIGGER(EXTEND_TRIGGER),
        .SATURATION_FLAG(SATURATED_FLAG)
    );

endmodule