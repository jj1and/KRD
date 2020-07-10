`timescale 1 ps/1 ps
module data_trigger # (
    // these parameter setting will be merged with "dataframe_config.v"
    parameter integer SAMPLE_WIDTH = 16,
    parameter integer SAMPLE_NUM_PER_CLK = 8,
    parameter integer ADC_RESOLUTION_WIDTH = 12,
    parameter integer TRIGGER_CONFIG_WIDTH = 32,
    parameter integer TRIGGER_INFO_WIDTH = 8,
    parameter integer TIMESTAMP_WIDTH = 48,

    // these parameter must be configured before logic synthesis
    parameter integer MAX_PRE_ACQUISITION_LENGTH = 2,
    parameter integer MAX_POST_ACQUISITION_LENGTH = 2,
    parameter integer MAX_ADC_SELECTION_PERIOD_LENGTH = 4,
    parameter integer ADC_SELECTION_PERIOD = 2
)(
    input wire ACLK,
    input wire ARESET,
    input wire SET_CONFIG,
    input wire STOP,

    // S_AXIS interface from RF Data Converter logic IP
    input wire [SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK-1:0] H_S_AXIS_TDATA,
    input wire H_S_AXIS_TVALID,
    output wire H_S_AXIS_TREADY,

    // S_AXIS interfrace from L-gain ADC
    input wire [SAMPLE_WIDTH*2-1:0] L_S_AXIS_TDATA,
    input wire L_S_AXIS_TVALID,
    output wire L_S_AXIS_TREADY,

    // Timestamp
    input wire [TIMESTAMP_WIDTH-1:0] TIMESTAMP,    

    // trigger settings
    input wire signed [ADC_RESOLUTION_WIDTH:0] RISING_EDGE_THRSHOLD,
    input wire signed [ADC_RESOLUTION_WIDTH:0] FALLING_EDGE_THRESHOLD,
    input wire signed [ADC_RESOLUTION_WIDTH:0] DIGITAL_BASELINE,
    input wire [$clog2(MAX_PRE_ACQUISITION_LENGTH)-1:0] PRE_ACQUISITION_LENGTH,
    input wire [$clog2(MAX_POST_ACQUISITION_LENGTH)-1:0] POST_ACQUISITION_LENGTH,
    input wire [$clog2(MAX_ADC_SELECTION_PERIOD_LENGTH)-1:0] ADC_SELECTION_PERIOD_LENGTH,

    output wire [SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK+TRIGGER_INFO_WIDTH+TIMESTAMP_WIDTH+TRIGGER_CONFIG_WIDTH-1:0] M_AXIS_TDATA,
    output wire M_AXIS_TVALID
);

    assign H_S_AXIS_TREADY = 1'b1;
    assign L_S_AXIS_TREADY = 1'b1;

    // ------------------------------- trigger configration -------------------------------
    localparam integer BASELINE_EFFECTIVE_WIDTH = TRIGGER_CONFIG_WIDTH-(ADC_RESOLUTION_WIDTH+1)*2;

    reg [$clog2(MAX_PRE_ACQUISITION_LENGTH)-1:0] pre_acquisition_length;
    reg [$clog2(MAX_POST_ACQUISITION_LENGTH)-1:0] post_acquisition_length;
    reg [$clog2(MAX_ADC_SELECTION_PERIOD_LENGTH)-1:0] adc_selection_period_length;
    reg signed [ADC_RESOLUTION_WIDTH:0] rising_edge_threshold;
    reg signed [ADC_RESOLUTION_WIDTH:0] falling_edge_threshold;
    reg signed [ADC_RESOLUTION_WIDTH:0] digital_baseline;        
    wire trigger_config = {digital_baseline[ADC_RESOLUTION_WIDTH -:BASELINE_EFFECTIVE_WIDTH], rising_edge_threshold, falling_edge_threshold};

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
                digital_baseline <= #100 { DIGITAL_BASELINE[ADC_RESOLUTION_WIDTH -:BASELINE_EFFECTIVE_WIDTH], {ADC_RESOLUTION_WIDTH+1-BASELINE_EFFECTIVE_WIDTH{1'b0}} };                                      
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
    wire signed [SAMPLE_WIDTH-1:0] rfdc_sample[SAMPLE_NUM_PER_CLK];
    wire signed [SAMPLE_WIDTH-1:0] h_sample_baseline_subtracted[SAMPLE_NUM_PER_CLK];
    wire [SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK-1:0] h_data_baseline_subtracted; 
    wire [SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK-1:0] adc_data_at_saturation;
    wire [SAMPLE_WIDTH:0] sum_h_tdata[4];
    wire [SAMPLE_WIDTH-1:0] averaged_h_tdata[4];

    genvar i;
    generate
            for (i=0; i<SAMPLE_NUM_PER_CLK; i++) begin
                assign rfdc_sample[i] =  { {SAMPLE_WIDTH-ADC_RESOLUTION_WIDTH{H_S_AXIS_TDATA[SAMPLE_WIDTH*(i+1)-1]}}, H_S_AXIS_TDATA[i*SAMPLE_WIDTH +:ADC_RESOLUTION_WIDTH] };
                assign h_sample_baseline_subtracted[i] = rfdc_sample[i] - digital_baseline;
                assign h_data_baseline_subtracted[i*SAMPLE_WIDTH +:SAMPLE_WIDTH] = h_sample_baseline_subtracted[i];
            end
            for (i=0; i<4; i++) begin
                assign sum_h_tdata[i] = h_sample_baseline_subtracted[i*2] + h_sample_baseline_subtracted[i*2+1];
                assign averaged_h_tdata[i] = sum_h_tdata[i][SAMPLE_WIDTH:1]; // divided by 2nsec
            end
            for (i=0; i<2; i++) begin
                assign adc_data_at_saturation[i*(SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK/2) +:(SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK/2)] = {16'hCC00, averaged_h_tdata[i*2+1], averaged_h_tdata[i*2], L_S_AXIS_TDATA[i*SAMPLE_WIDTH +:SAMPLE_WIDTH] };
            end
    endgenerate


    // ------------------------------- Trigger & ADC data, timstamp delay ------------------------------- 
    wire [$clog2(MAX_ADC_SELECTION_PERIOD_LENGTH+3)-1:0] TRIGGER_CORE_DELAY_FOR_TRIGGER = 3;
    wire [$clog2(MAX_ADC_SELECTION_PERIOD_LENGTH+MAX_PRE_ACQUISITION_LENGTH+3)-1:0] TRIGGER_CORE_DELAY_FOR_DATA = 3;

    wire EXTEND_TRIGGER;
    wire delayed_extend_trigger;
    wire [SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK-1:0] delayed_h_data_baseline_subtracted;
    wire [SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK-1:0] delayed_adc_data_at_saturation;
    wire [TIMESTAMP_WIDTH-1:0] delayed_timestamp;

    variable_shiftreg_delay # (
        .DATA_WIDTH(1),
        .MAX_DELAY_LENGTH(MAX_ADC_SELECTION_PERIOD_LENGTH+3)
    ) extend_trigger_delay_inst (
        .CLK(ACLK),
        .DIN(EXTEND_TRIGGER),
        .DELAY(adc_selection_period_length+TRIGGER_CORE_DELAY_FOR_TRIGGER),
        .DOUT(delayed_extend_trigger)
    );

    variable_shiftreg_delay # (
        .DATA_WIDTH(SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK),
        .MAX_DELAY_LENGTH(MAX_ADC_SELECTION_PERIOD_LENGTH+MAX_PRE_ACQUISITION_LENGTH+3)
    ) h_gain_data_delay_inst (
        .CLK(ACLK),
        .DIN(h_data_baseline_subtracted),
        .DELAY(adc_selection_period_length+pre_acquisition_length+TRIGGER_CORE_DELAY_FOR_DATA),
        .DOUT(delayed_h_data_baseline_subtracted)
    );

    variable_shiftreg_delay # (
        .DATA_WIDTH(SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK),
        .MAX_DELAY_LENGTH(MAX_ADC_SELECTION_PERIOD_LENGTH+MAX_PRE_ACQUISITION_LENGTH+3)
    ) l_gain_data_delay_inst (
        .CLK(ACLK),
        .DIN(adc_data_at_saturation),
        .DELAY(adc_selection_period_length+pre_acquisition_length+TRIGGER_CORE_DELAY_FOR_DATA),
        .DOUT(delayed_adc_data_at_saturation)
    );

    variable_shiftreg_delay # (
        .DATA_WIDTH(TIMESTAMP_WIDTH),
        .MAX_DELAY_LENGTH(MAX_ADC_SELECTION_PERIOD_LENGTH+MAX_PRE_ACQUISITION_LENGTH+3)
    ) timestamp_delay_inst (
        .CLK(ACLK),
        .DIN(TIMESTAMP),
        .DELAY(adc_selection_period_length+pre_acquisition_length+TRIGGER_CORE_DELAY_FOR_DATA),
        .DOUT(delayed_timestamp)
    );


    // ------------------------------- ADC selector -------------------------------
    wire SATURATED_FLAG; 
    reg [SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK+TRIGGER_INFO_WIDTH+TIMESTAMP_WIDTH+TRIGGER_CONFIG_WIDTH-1:0] m_axis_tdata;
    reg m_axis_tvalid;

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            m_axis_tdata <= #100 {SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK+TRIGGER_INFO_WIDTH+TIMESTAMP_WIDTH+TRIGGER_CONFIG_WIDTH{1'b1}};    
        end else begin
            if (SATURATED_FLAG) begin
                m_axis_tdata <= #100 {delayed_adc_data_at_saturation, {3'b0, ~SATURATED_FLAG, 4'b0}, delayed_timestamp, trigger_config};
            end else begin
                m_axis_tdata <= #100 {delayed_h_data_baseline_subtracted, {3'b0, ~SATURATED_FLAG, 4'b0}, delayed_timestamp, trigger_config};
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

    assign M_AXIS_TDATA = m_axis_tdata;
    assign M_AXIS_TVALID = m_axis_tvalid;

    // trigger_core TRIGGER & GAIN_TYPE is syncronized to 3CLK delayed H_S_AXIS_TDATA
    // trigger is already extended in trigger_core, for pre & post acquisition
    // TRIGGER_CONFIG is only changed at run-change
    trigger_core # (
        .SAMPLE_WIDTH(SAMPLE_WIDTH),
        .SAMPLE_NUM_PER_CLK(SAMPLE_NUM_PER_CLK),
        .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH),
        .MAX_PRE_ACQUISITION_LENGTH(MAX_PRE_ACQUISITION_LENGTH),
        .MAX_POST_ACQUISITION_LENGTH(MAX_POST_ACQUISITION_LENGTH),
        .MAX_ADC_SELECTION_PERIOD_LENGTH(MAX_ADC_SELECTION_PERIOD_LENGTH),
        .ADC_SELECTION_PERIOD(ADC_SELECTION_PERIOD)
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