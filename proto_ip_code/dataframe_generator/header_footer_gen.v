`timescale 1ps / 1ps
`include "dataframe_config.vh"

module header_footer_gen # (
    parameter integer CHANNEL_ID = 0
) (
    input wire ACLK,
    input wire ARESET,

    // Data frame length configuration
    input wire SET_CONFIG,
    input wire [15:0] MAX_TRIGGER_LENGTH,

    // Input signals from trigger
    input wire [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] S_AXIS_TDATA, // TDATA from RF Data Converter logic IP
    input wire S_AXIS_TVALID,

    input wire [`RFDC_TDATA_WIDTH-1:0] H_GAIN_TDATA, 

    output wire [(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-1:0] HEADER_FOOTER_DATA,
    output wire HEADER_FOOTER_VALID,
    input wire HF_FIFO_RD_EN,
    input wire HF_FIFO_ALMOST_FULL,
    input wire HF_FIFO_FULL,

    output wire [`RFDC_TDATA_WIDTH-1:0] ADC_DATA,
    output wire ADC_VALID,
    input wire ADC_FIFO_RD_EN,
    input wire ADC_FIFO_ALMOST_FULL,
    input wire ADC_FIFO_FULL
);

    wire trigger_halt = |{ARESET, SET_CONFIG, ADC_FIFO_FULL, HF_FIFO_FULL};

    reg s_axis_tvalid_delay;
    wire s_axis_tvalid_posedge = (S_AXIS_TVALID==1'b1)&(s_axis_tvalid_delay==1'b0);
    wire s_axis_tvalid_negedge = (S_AXIS_TVALID==1'b0)&(s_axis_tvalid_delay==1'b1);

    reg [`FRAME_LENGTH_WIDTH-1:0] frame_len;
    wire [`FRAME_LENGTH_WIDTH-1:0] dataframe_len = (frame_len+1)*2;
    reg [15:0] max_trigger_len;
    wire split_frame = (frame_len+1 == max_trigger_len);

    wire gain_type_wire = S_AXIS_TDATA[`TRIGGER_TYPE_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH];
    reg [`TRIGGER_TYPE_WIDTH-1:0] trigger_type;
    reg [`FOOTER_TIMESTAMP_WIDTH-1:0] footer_timestamp;
    reg [`HEADER_TIMESTAMP_WIDTH-1:0] header_timestamp;
    reg [`TRIGGER_CONFIG_WIDTH-1:0] trigger_config;

    wire [`HEADER_ID_WIDTH-1:0] HEADER_ID = `HEADER_ID;
    wire [`FOOTER_ID_WIDTH-1:0] FOOTER_ID = `FOOTER_ID;
    wire [`CH_ID_WIDTH-1:0] CH_ID = CHANNEL_ID;

    reg [1:0] trigger_run_state;
    wire [1:0] trigger_state = (adc_fifo_gets_full|hf_fifo_gets_full) ? 2'b10 : trigger_run_state;
    reg frame_begin;
    wire frame_continue = (|{split_frame, adc_fifo_gets_full, hf_fifo_gets_full})&S_AXIS_TVALID;
    wire [`FRAME_INFO_WIDTH-1:0] frame_info = {trigger_state, frame_begin, frame_continue};

    reg [`OBJECT_ID_WIDTH-1:0] object_id;

    wire signed [`SAMPLE_WIDTH-1:0] h_gain_sample[`SAMPLE_NUM_PER_CLK-1:0];
    wire signed [`CHARGE_SUM-1:0] sign_extend_h_gain_sample[`SAMPLE_NUM_PER_CLK-1:0];
    reg signed [`CHARGE_SUM-1:0] h_partial_charge_sum[`SAMPLE_NUM_PER_CLK-1:0];
    wire signed [`CHARGE_SUM-1:0] charge_sum;
    wire signed [`CHARGE_SUM-1:0] h_charge_sum_step_holder [`SAMPLE_NUM_PER_CLK-2:0];
    genvar i;
    generate
        for (i=0; i<`SAMPLE_NUM_PER_CLK; i=i+1) begin
            assign h_gain_sample[i] = H_GAIN_TDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
            assign sign_extend_h_gain_sample[i] = {{`CHARGE_SUM-`SAMPLE_WIDTH{h_gain_sample[i][`SAMPLE_WIDTH-1]}}, h_gain_sample[i]};
        end

        assign h_charge_sum_step_holder[0] = h_partial_charge_sum[0] + h_partial_charge_sum[1];//for less cost starts witch first sum (not array[0])
        for(i=0; i<`SAMPLE_NUM_PER_CLK-2; i=i+1) begin
            assign h_charge_sum_step_holder[i+1] = h_charge_sum_step_holder[i] + h_partial_charge_sum[i+2];
        end
    endgenerate
    assign charge_sum = h_charge_sum_step_holder[`SAMPLE_NUM_PER_CLK-2];  


    wire [`HEADER_LINE*`DATAFRAME_WIDTH-1:0] header = {HEADER_ID, CH_ID, dataframe_len, frame_info, trigger_type, header_timestamp, {`HEADER_ID_WIDTH{1'b0}}, charge_sum, trigger_config};
    // wire [`DATAFRAME_WIDTH-1:0] footer = {footer_timestamp, footer_object_id_1, footer_object_id_2, FOOTER_ID};
    wire [`DATAFRAME_WIDTH-1:0] footer = {FOOTER_ID, footer_timestamp, object_id};
    wire [(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-1:0] header_footer = {header, footer};
    wire header_footer_valid =  |{trigger_halt, (trigger_run_state==2'b00)} ? 1'b0 :|{s_axis_tvalid_negedge, split_frame, adc_fifo_gets_full};
    wire hf_fifo_gets_full = &{HF_FIFO_ALMOST_FULL==1'b1, header_footer_valid==1'b1, HF_FIFO_RD_EN==1'b0};

    reg adc_fifo_wen;
    wire adc_fifo_gets_full = &{ADC_FIFO_ALMOST_FULL==1'b1, adc_fifo_wen==1'b1, ADC_FIFO_RD_EN==1'b0};
    // wire adc_fifo_full_posedge = (adc_fifo_full_delay==1'b0)&(ADC_FIFO_FULL==1'b1);
    reg [`RFDC_TDATA_WIDTH-1:0] adc_data;

    always @(posedge ACLK ) begin
        s_axis_tvalid_delay <= #100 S_AXIS_TVALID;
    end

    always @(posedge ACLK ) begin
        if (ARESET) begin
            max_trigger_len <= #100 100;
        end else begin
            if (SET_CONFIG) begin
                max_trigger_len <= #100 MAX_TRIGGER_LENGTH;
            end else begin
                max_trigger_len <= #100 max_trigger_len;
            end
        end
    end

    always @(posedge ACLK ) begin
        if (trigger_halt) begin
            trigger_run_state <= #100 00;
        end else begin
            if (s_axis_tvalid_posedge) begin
                if (trigger_run_state == 2'b00) begin
                    trigger_run_state <= #100 2'b01;
                end else begin
                    trigger_run_state <= #100 2'b11;
                end
            end else begin
                trigger_run_state <= #100 trigger_run_state;
            end
        end
    end

    always @(posedge ACLK ) begin
        if (trigger_halt) begin
            frame_begin <= #100 1'b0;
        end else begin
            if (s_axis_tvalid_posedge) begin
                frame_begin <= #100 1'b1;
            end else begin
                if (split_frame) begin
                    frame_begin <= #100 1'b0;
                end else begin
                    frame_begin <= #100 frame_begin; 
                end
            end
        end        
    end

    always @(posedge ACLK ) begin
        if (trigger_halt) begin
            trigger_type <= #100 {`TRIGGER_TYPE_WIDTH{1'b1}};
            header_timestamp <= #100 {`HEADER_TIMESTAMP_WIDTH{1'b1}};
            footer_timestamp <= #100 {`FOOTER_TIMESTAMP_WIDTH{1'b1}};
            trigger_config <= #100 {`TRIGGER_CONFIG_WIDTH{1'b1}};
        end else begin
            if (s_axis_tvalid_posedge|split_frame) begin
                trigger_type <= #100 S_AXIS_TDATA[`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH +:`TRIGGER_TYPE_WIDTH];
                footer_timestamp <= #100 S_AXIS_TDATA[`TRIGGER_CONFIG_WIDTH+`HEADER_TIMESTAMP_WIDTH +:`FOOTER_TIMESTAMP_WIDTH];
                header_timestamp <= #100 S_AXIS_TDATA[`TRIGGER_CONFIG_WIDTH +:`HEADER_TIMESTAMP_WIDTH];
                trigger_config <= #100 S_AXIS_TDATA[`TRIGGER_CONFIG_WIDTH-1:0];
            end else begin
                trigger_type <= #100 trigger_type;
                header_timestamp <= #100 header_timestamp;
                footer_timestamp <= #100 footer_timestamp;
                trigger_config <= #100 trigger_config;
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            object_id <= #100 {`OBJECT_ID_WIDTH{1'b1}};
        end else begin
            if (s_axis_tvalid_posedge) begin
                object_id <= #100 object_id + 1;
            end else begin
                object_id <= #100 object_id;
            end
        end
    end

    // There is no safety for charge_sum overflow
    // safety should be like below...
    // change h_partial_charge_sum bit width to 21bitg->22bit
    // if h_partial_charge_sum>=2**21, h_partial_charge_sum should be clipped to 2**21-1
    integer j;
    always @(posedge ACLK ) begin
        if (trigger_halt|(!S_AXIS_TVALID)) begin
            frame_len <= #100 {`FRAME_LENGTH_WIDTH{1'b1}};
            for ( j=0 ; j<`SAMPLE_NUM_PER_CLK ; j=j+1) begin
                h_partial_charge_sum[j] <= #100 {`CHARGE_SUM{1'b1}};
            end
        end else begin
            if (s_axis_tvalid_posedge|split_frame) begin
                frame_len <= #100 0;
                for ( j=0 ; j<`SAMPLE_NUM_PER_CLK ; j=j+1) begin
                    h_partial_charge_sum[j] <= #100 sign_extend_h_gain_sample[j];
                end
            end else begin
                if (trigger_run_state!=2'b00) begin
                    frame_len <= #100 frame_len + 1;
                    for ( j=0 ; j<`SAMPLE_NUM_PER_CLK ; j=j+1) begin
                        h_partial_charge_sum[j] <= #100 h_partial_charge_sum[j] + sign_extend_h_gain_sample[j];
                    end       
                end else begin
                    frame_len <= #100 {`FRAME_LENGTH_WIDTH{1'b1}};
                    for ( j=0 ; j<`SAMPLE_NUM_PER_CLK ; j=j+1) begin
                        h_partial_charge_sum[j] <= #100 {`CHARGE_SUM{1'b1}};
                    end  
                end
            end
        end
    end

    always @(posedge ACLK ) begin
        if (trigger_halt) begin
            adc_fifo_wen <= #100 1'b0;
        end else begin
            if (s_axis_tvalid_posedge) begin
                adc_fifo_wen <= #100 1'b1;
            end else begin
                if (|{hf_fifo_gets_full, adc_fifo_gets_full, s_axis_tvalid_negedge}) begin
                    adc_fifo_wen <= #100 1'b0;
                end else begin
                    adc_fifo_wen <= #100 adc_fifo_wen; 
                end
            end
        end
    end

    always @(posedge ACLK) begin
        if (trigger_halt) begin
            adc_data <= #100 {`RFDC_TDATA_WIDTH{1'b1}};
        end else begin
            adc_data <= S_AXIS_TDATA[`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1 -:`RFDC_TDATA_WIDTH];
        end
    end

    assign ADC_VALID = adc_fifo_wen;
    assign ADC_DATA = adc_data;

    assign HEADER_FOOTER_VALID = header_footer_valid;
    assign HEADER_FOOTER_DATA = header_footer;

endmodule // 