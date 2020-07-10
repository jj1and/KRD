`timescale 1 ps/1 ps
module trigger_core # (
    parameter integer SAMPLE_WIDTH = 16,
    parameter integer SAMPLE_NUM_PER_CLK = 8,
    parameter integer ADC_RESOLUTION_WIDTH = 12,
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
    input wire [SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK-1:0] S_AXIS_TDATA,
    input wire S_AXIS_TVALID,

    // trigger settings
    input wire signed [ADC_RESOLUTION_WIDTH:0] RISING_EDGE_THRSHOLD,
    input wire signed [ADC_RESOLUTION_WIDTH:0] FALLING_EDGE_THRESHOLD,
    input wire signed [ADC_RESOLUTION_WIDTH:0] DIGITAL_BASELINE,
    input wire [$clog2(MAX_PRE_ACQUISITION_LENGTH)-1:0] PRE_ACQUISITION_LENGTH,
    input wire [$clog2(MAX_POST_ACQUISITION_LENGTH)-1:0] POST_ACQUISITION_LENGTH,
    input wire [$clog2(MAX_ADC_SELECTION_PERIOD_LENGTH)-1:0] ADC_SELECTION_PERIOD_LENGTH,

    // trigger and gain-mode for ADC selector
    output wire TRIGGER,
    output wire SATURATION_FLAG
);

    // ------------------------------- hit detection -------------------------------
    wire signed [ADC_RESOLUTION_WIDTH:0] rfdc_sample[SAMPLE_NUM_PER_CLK];    
    wire [SAMPLE_NUM_PER_CLK-1:0] rise_edge_thre_over;
    reg [SAMPLE_NUM_PER_CLK-1:0] rise_edge_thre_over_delay;
    wire [SAMPLE_NUM_PER_CLK-1:0] hit_rising_edge;
    reg [SAMPLE_NUM_PER_CLK-1:0] hit_rising_edge_delay;        
    wire hit_start = |hit_rising_edge_delay;

    wire [SAMPLE_NUM_PER_CLK-1:0] fall_edge_thre_under;
    reg [SAMPLE_NUM_PER_CLK-1:0] fall_edge_thre_under_delay;
    wire hit_end = &fall_edge_thre_under_delay;

    genvar i;
    generate
        for (i=0; i<SAMPLE_NUM_PER_CLK; i++) begin
            assign rfdc_sample[i] = { {SAMPLE_WIDTH-ADC_RESOLUTION_WIDTH{S_AXIS_TDATA[16*(i+1)-1]}}, S_AXIS_TDATA[i*ADC_RESOLUTION_WIDTH +:ADC_RESOLUTION_WIDTH] };
            assign rise_edge_thre_over[i] = rfdc_sample[i]-DIGITAL_BASELINE > RISING_EDGE_THRSHOLD;
            assign fall_edge_thre_under[i] = rfdc_sample[i]-DIGITAL_BASELINE < FALLING_EDGE_THRESHOLD;
        end

        assign hit_rising_edge[SAMPLE_NUM_PER_CLK-1] = &hit_rising_edge;  
        for (i=1; i<SAMPLE_NUM_PER_CLK; i++) begin
            assign hit_rising_edge[i-1] = (&rise_edge_thre_over_delay[SAMPLE_NUM_PER_CLK-1:i])|(|rise_edge_thre_over[i-1:0]);
        end
    endgenerate    

    always @(posedge ACLK ) begin
        rise_edge_thre_over_delay <= #100 rise_edge_thre_over;
        fall_edge_thre_under_delay <= #100 fall_edge_thre_under;
        hit_rising_edge_delay <= #100 hit_rising_edge;
    end


    // ------------------------------- trigger generation -------------------------------
    reg [SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK*2-1:0] tdata_shiftreg;
    wire [SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK-1:0] tdata_delay = tdata_shiftreg[SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK-1 :0];
    wire [SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK-1:0] tdata_2delay = tdata_shiftreg[SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK*2-1 -:SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK];

    reg tvalid_delay;

    reg trigger;
    reg trigger_delay;
    wire trigger_posedge = (trigger == 1'b1)&(trigger_delay == 1'b0);
    wire trigger_negedge = (trigger == 1'b0)&(trigger_delay == 1'b1);
    reg [$clog2(MAX_POST_ACQUISITION_LENGTH+MAX_PRE_ACQUISITION_LENGTH)-1:0] extend_count;
    wire [$clog2(MAX_POST_ACQUISITION_LENGTH+MAX_PRE_ACQUISITION_LENGTH)-1:0] EXTEND_COUNT_INIT_VAL = {$clog2(MAX_POST_ACQUISITION_LENGTH+MAX_PRE_ACQUISITION_LENGTH){1'b1}};
    wire extend_trigger = (extend_count <= PRE_ACQUISITION_LENGTH+POST_ACQUISITION_LENGTH);

    always @(posedge ACLK ) begin
        tdata_shiftreg <= #100 {tdata_shiftreg[SAMPLE_WIDTH*SAMPLE_NUM_PER_CLK-1 :0], S_AXIS_TDATA};
    end

    always @(posedge ACLK ) begin
        trigger_delay <= #100 trigger;
        tvalid_delay <= #100 S_AXIS_TVALID;
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            trigger <= #100 1'b0;
        end else begin
            if (&{hit_start, !STOP, tvalid_delay}) begin
                trigger <= #100 1'b1;
            end else begin
                if (|{hit_end, !tvalid_delay}) begin
                    trigger <= #100 1'b0;
                end else begin
                    trigger <= #100 trigger;
                end
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            extend_count <= #100 EXTEND_COUNT_INIT_VAL;
        end else begin
            if (trigger) begin
                extend_count <= #100 0;
            end else begin
                if (extend_count < PRE_ACQUISITION_LENGTH+POST_ACQUISITION_LENGTH) begin
                    extend_count <= #100 extend_count + 1;
                end else begin
                    extend_count <= #100 EXTEND_COUNT_INIT_VAL;
                end
            end
        end
    end

    assign TRIGGER = extend_trigger;


    // ------------------------------- h-gain saturation detection -------------------------------
    reg [$clog2(MAX_ADC_SELECTION_PERIOD_LENGTH)-1:0] adc_select_count;
    wire [$clog2(MAX_ADC_SELECTION_PERIOD_LENGTH)-1:0] ADC_SELECT_COUNT_INIT_VAL = {$clog2(MAX_ADC_SELECTION_PERIOD_LENGTH){1'b1}};
    wire adc_select_enable = (adc_select_count < ADC_SELECTION_PERIOD_LENGTH);
    wire [SAMPLE_NUM_PER_CLK-1:0] saturation_detect;
    reg saturation_flag;

    generate
        for (i=0; i<SAMPLE_NUM_PER_CLK; i++) begin
            assign saturation_detect[i] = (tdata_2delay[i*SAMPLE_WIDTH +:ADC_RESOLUTION_WIDTH] == {ADC_RESOLUTION_WIDTH{1'b1}});
        end
    endgenerate

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            adc_select_count <= #100 ADC_SELECT_COUNT_INIT_VAL;
        end else begin
            if (trigger_posedge) begin
                adc_select_count <= #100 0;
            end else begin
                if (&{trigger, adc_select_enable}) begin
                    adc_select_count <= #100 adc_select_count + 1;
                end else begin
                    adc_select_count <= #100 ADC_SELECT_COUNT_INIT_VAL;
                end
            end
        end
    end    

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            saturation_flag <= #100 1'b0;
        end else begin
            if (&{adc_select_enable, |saturation_detect}) begin
                saturation_flag <= #100 1'b1;
            end else begin
                if (trigger_negedge) begin
                    saturation_flag <= #100 1'b0;
                end else begin
                    saturation_flag <= #100 saturation_flag;
                end
            end
        end
    end

    assign SATURATION_FLAG = saturation_flag;

endmodule 