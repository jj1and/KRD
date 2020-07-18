`timescale 1 ps/1 ps
`include "trigger_config.vh"
module trigger_core # (
    parameter integer MAX_PRE_ACQUISITION_LENGTH = 2,
    parameter integer MAX_POST_ACQUISITION_LENGTH = 2
)(
    input wire ACLK,
    input wire ARESET,
    input wire SET_CONFIG,
    input wire STOP,

    // S_AXIS interface from DBLR
    input wire [`RFDC_TDATA_WIDTH-1:0] S_AXIS_TDATA,
    input wire S_AXIS_TVALID,

    // S_AXIS interface from RF Data Converter logic IP
    input wire [`RFDC_TDATA_WIDTH-1:0] H_S_AXIS_TDATA,

    // trigger settings
    input wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRSHOLD,
    input wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD,
    input wire [$clog2(MAX_PRE_ACQUISITION_LENGTH):0] PRE_ACQUISITION_LENGTH,
    input wire [$clog2(MAX_POST_ACQUISITION_LENGTH):0] POST_ACQUISITION_LENGTH,

    // trigger and gain-mode for ADC selector
    output wire TRIGGER,
    output wire SATURATION_FLAG
);

    // ------------------------------- hit detection -------------------------------
    wire signed [`SAMPLE_WIDTH-1:0] dsp_sample[`SAMPLE_NUM_PER_CLK-1:0];    
    wire [`SAMPLE_NUM_PER_CLK-1:0] rise_edge_thre_over;
    reg [`SAMPLE_NUM_PER_CLK-1:0] rise_edge_thre_over_delay;
    wire [`SAMPLE_NUM_PER_CLK-1:0] hit_rising_edge;
    reg [`SAMPLE_NUM_PER_CLK-1:0] hit_rising_edge_delay;        
    wire hit_start = |{hit_rising_edge_delay, saturation_detect_delay};

    wire [`SAMPLE_NUM_PER_CLK-1:0] fall_edge_thre_under;
    reg [`SAMPLE_NUM_PER_CLK-1:0] fall_edge_thre_under_delay;
    wire hit_end = &fall_edge_thre_under_delay;

    genvar i;
    generate
        for (i=0; i<`SAMPLE_NUM_PER_CLK; i=i+1) begin
            assign dsp_sample[i] = S_AXIS_TDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
            assign rise_edge_thre_over[i] = dsp_sample[i] > RISING_EDGE_THRSHOLD;
            assign fall_edge_thre_under[i] = dsp_sample[i] < FALLING_EDGE_THRESHOLD;
        end

        assign hit_rising_edge[`SAMPLE_NUM_PER_CLK-1] = &rise_edge_thre_over;  
        for (i=1; i<`SAMPLE_NUM_PER_CLK; i=i+1) begin
            assign hit_rising_edge[i-1] = (&rise_edge_thre_over_delay[`SAMPLE_NUM_PER_CLK-1:i])&(|rise_edge_thre_over[i-1:0]);
        end
    endgenerate    

    always @(posedge ACLK ) begin
        rise_edge_thre_over_delay <= #100 rise_edge_thre_over;
        fall_edge_thre_under_delay <= #100 fall_edge_thre_under;
        hit_rising_edge_delay <= #100 hit_rising_edge;
    end


    // ------------------------------- trigger generation -------------------------------
    reg [`RFDC_TDATA_WIDTH*2-1:0] tdata_shiftreg;
    wire [`RFDC_TDATA_WIDTH-1:0] tdata_delay = tdata_shiftreg[`RFDC_TDATA_WIDTH-1 :0];

    reg tvalid_delay;
    reg tvalid_2delay;

    reg trigger;
    reg trigger_delay;
    wire trigger_posedge = (trigger == 1'b1)&(trigger_delay == 1'b0);
    wire trigger_negedge = (trigger == 1'b0)&(trigger_delay == 1'b1);
    reg [$clog2(MAX_POST_ACQUISITION_LENGTH+MAX_PRE_ACQUISITION_LENGTH)-1:0] extend_count;
    wire [$clog2(MAX_POST_ACQUISITION_LENGTH+MAX_PRE_ACQUISITION_LENGTH)-1:0] EXTEND_COUNT_INIT_VAL = {$clog2(MAX_POST_ACQUISITION_LENGTH+MAX_PRE_ACQUISITION_LENGTH){1'b1}};
    wire extend_trigger = (extend_count <= PRE_ACQUISITION_LENGTH+POST_ACQUISITION_LENGTH);

    always @(posedge ACLK ) begin
        tdata_shiftreg <= #100 {tdata_shiftreg[`RFDC_TDATA_WIDTH-1 :0], S_AXIS_TDATA};
    end

    always @(posedge ACLK ) begin
        trigger_delay <= #100 trigger;
        tvalid_delay <= #100 S_AXIS_TVALID;
        tvalid_2delay <= #100 tvalid_delay;
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            trigger <= #100 1'b0;
        end else begin
            if (&{hit_start, !STOP, tvalid_2delay}) begin
                trigger <= #100 1'b1;
            end else begin
                if (|{hit_end, !tvalid_2delay}) begin
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
    wire signed [`ADC_RESOLUTION_WIDTH-1:0] h_gain_sample[`SAMPLE_NUM_PER_CLK-1:0];
    wire [`SAMPLE_NUM_PER_CLK-1:0] saturation_detect;
    reg [`SAMPLE_NUM_PER_CLK-1:0] saturation_detect_delay;
    wire saturation_flag_delay = |saturation_detect_delay;
    reg saturation_flag_2delay;
    reg saturation_flag_3delay;

    generate
        for (i=0; i<`SAMPLE_NUM_PER_CLK; i=i+1) begin
            assign h_gain_sample[i] = H_S_AXIS_TDATA[i*`SAMPLE_WIDTH+`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH +:`ADC_RESOLUTION_WIDTH];
            assign saturation_detect[i] = (h_gain_sample[i] == 2047)|(h_gain_sample[i] == -2048);
        end
    endgenerate

    always @(posedge ACLK ) begin
        saturation_detect_delay <= #100 saturation_detect;
        saturation_flag_2delay <= #100 saturation_flag_delay;  
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            saturation_flag_3delay <= #100 1'b0;
        end else begin
            saturation_flag_3delay <= #100 saturation_flag_2delay;
        end
    end

    assign SATURATION_FLAG = saturation_flag_3delay;

endmodule 