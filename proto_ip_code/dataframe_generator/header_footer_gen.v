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
    output wire S_AXIS_TREADY,

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
    wire tready = 1'b1;
    assign S_AXIS_TREADY = tready;

    reg [`FRAME_LENGTH_WIDTH-2:0] frame_len;
    wire [`FRAME_LENGTH_WIDTH-1:0] dataframe_len = (frame_len+1)*2;
    reg [15:0] max_trigger_len;
    wire split_frame = (frame_len+1 == max_trigger_len)|gain_change;

    reg gain_type_reg;
    wire gain_type_wire = S_AXIS_TDATA[`TRIGGER_TYPE_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH];
    wire gain_change = (gain_type_reg!=gain_type_wire)&(!s_axis_tvalid_posedge);
    reg [`TRIGGER_TYPE_WIDTH-1:0] trigger_type;
    reg [`FOOTER_TIMESTAMP_WIDTH-1:0] footer_timestamp;
    reg [`HEADER_TIMESTAMP_WIDTH-1:0] header_timestamp;
    reg [`TRIGGER_CONFIG_WIDTH-1:0] trigger_config;

    wire [`HEADER_ID_WIDTH-1:0] HEADER_ID = `HEADER_ID;
    wire [`FOOTER_ID_WIDTH-1:0] FOOTER_ID = `FOOTER_ID;
    wire [`CH_ID_WIDTH-1:0] CH_ID = CHANNEL_ID;

    reg [1:0] trigger_run_state;
    wire [1:0] trigger_state = (adc_fifo_gets_full|hf_fifo_gets_full) ? 2'b10 : trigger_run_state;
    wire frame_continue = &{split_frame, S_AXIS_TVALID, !adc_fifo_gets_full, !hf_fifo_gets_full};
    wire [`FRAME_INFO_WIDTH-1:0] frame_info = {trigger_state, frame_continue, gain_type_reg};

    reg [`OBJECT_ID_WIDTH-1:0] object_id;
    // wire [`FOOTER_OBJECT_ID_WIDTH_1-1:0] footer_object_id_1 = object_id[`OBJECT_ID_WIDTH-1 -:`FOOTER_OBJECT_ID_WIDTH_1];
    wire [`FOOTER_OBJECT_ID_WIDTH_2-1:0] footer_object_id_2 = object_id[`FOOTER_OBJECT_ID_WIDTH_2-1 :0];

    reg [`CHARGE_SUM-2-1:0] partial_charge_sum[`SAMPLE_NUM_PER_CLK-1:0];
    wire [`CHARGE_SUM-1:0] charge_sum;
    wire [`CHARGE_SUM-1:0] charge_sum_step_holder [`SAMPLE_NUM_PER_CLK-2:0];
    genvar i;
    generate
        assign charge_sum_step_holder[0] = partial_charge_sum[0][`CHARGE_SUM-3-1:0] + partial_charge_sum[1][`CHARGE_SUM-3-1:0];//for less cost starts witch first sum (not array[0])
        for(i=0; i<`SAMPLE_NUM_PER_CLK-2; i=i+1) begin
            assign charge_sum_step_holder[i+1] = charge_sum_step_holder[i] + partial_charge_sum[i+2][`CHARGE_SUM-3-1:0];
        end
    endgenerate
    assign charge_sum = charge_sum_step_holder[`SAMPLE_NUM_PER_CLK-2];  


    wire [`HEADER_LINE*`DATAFRAME_WIDTH-1:0] header = {HEADER_ID, CH_ID, dataframe_len, frame_info, trigger_type, header_timestamp, {`HEADER_ID_WIDTH{1'b0}}, charge_sum, trigger_config};
    // wire [`DATAFRAME_WIDTH-1:0] footer = {footer_timestamp, footer_object_id_1, footer_object_id_2, FOOTER_ID};
    wire [`DATAFRAME_WIDTH-1:0] footer = {{`HEADER_ID_WIDTH{1'b0}}, footer_timestamp, footer_object_id_2, FOOTER_ID};
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
            gain_type_reg <= #100 1'b1;
            trigger_type <= #100 {`TRIGGER_TYPE_WIDTH{1'b1}};
            header_timestamp <= #100 {`HEADER_TIMESTAMP_WIDTH{1'b1}};
            footer_timestamp <= #100 {`FOOTER_TIMESTAMP_WIDTH{1'b1}};
            trigger_config <= #100 {`TRIGGER_CONFIG_WIDTH{1'b1}};
        end else begin
            if (s_axis_tvalid_posedge|split_frame) begin
                gain_type_reg <= #100 gain_type_wire;
                trigger_type <= #100 S_AXIS_TDATA[`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH +:`TRIGGER_TYPE_WIDTH];
                footer_timestamp <= #100 S_AXIS_TDATA[`TRIGGER_CONFIG_WIDTH+`HEADER_TIMESTAMP_WIDTH +:`FOOTER_TIMESTAMP_WIDTH];
                header_timestamp <= #100 S_AXIS_TDATA[`TRIGGER_CONFIG_WIDTH +:`HEADER_TIMESTAMP_WIDTH];
                trigger_config <= #100 S_AXIS_TDATA[`TRIGGER_CONFIG_WIDTH-1:0];
            end else begin
                gain_type_reg <= #100 gain_type_reg;
                trigger_type <= #100 trigger_type;
                header_timestamp <= #100 header_timestamp;
                footer_timestamp <= #100 footer_timestamp;
                trigger_config <= #100 trigger_config;
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            object_id <= #100 0;
        end else begin
            if (s_axis_tvalid_negedge) begin
                object_id <= #100 object_id + 1;
            end else begin
                object_id <= #100 object_id;
            end
        end
    end

    // There is no safety for charge_sum overflow
    // safety should be like below...
    // change partial_charge_sum bit width to 21bitg->22bit
    // if partial_charge_sum>=2**21, partial_charge_sum should be clipped to 2**21-1
    integer j;
    always @(posedge ACLK ) begin
        if (trigger_halt|(!S_AXIS_TVALID)) begin
            frame_len <= #100 {`FRAME_LENGTH_WIDTH{1'b1}};
            for ( j=0 ; j<`SAMPLE_NUM_PER_CLK ; j=j+1) begin
                partial_charge_sum[j] <= #100 {`CHARGE_SUM-3{1'b1}};
            end
        end else begin
            if (s_axis_tvalid_posedge|split_frame) begin
                frame_len <= #100 0;
                for ( j=0 ; j<`SAMPLE_NUM_PER_CLK ; j=j+1) begin
                    partial_charge_sum[j] <= #100 S_AXIS_TDATA[`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH+`SAMPLE_WIDTH*j +:`SAMPLE_WIDTH];
                end
            end else begin
                if (trigger_run_state!=2'b00) begin
                    frame_len <= #100 frame_len + 1;
                    for ( j=0 ; j<`SAMPLE_NUM_PER_CLK ; j=j+1) begin
                        if (partial_charge_sum[j] + S_AXIS_TDATA[`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH+`SAMPLE_WIDTH*j +:`SAMPLE_WIDTH]>{`CHARGE_SUM-3{1'b1}}) begin
                            partial_charge_sum[j] <= #100 {`CHARGE_SUM-3{1'b1}};
                        end else begin
                            partial_charge_sum[j] <= #100 partial_charge_sum[j] + S_AXIS_TDATA[`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH+`SAMPLE_WIDTH*j +:`SAMPLE_WIDTH];
                        end
                    end          
                end else begin
                    frame_len <= #100 {`FRAME_LENGTH_WIDTH{1'b1}};
                    for ( j=0 ; j<`SAMPLE_NUM_PER_CLK ; j=j+1) begin
                        partial_charge_sum[j] <= #100 {`CHARGE_SUM-3{1'b1}};
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