`timescale 1ps/1ps
`include "async_dataframe_config.vh"


module async_dataframe_generator # (
    parameter integer CHANNEL_ID = 0,
    parameter integer ADC_FIFO_DEPTH = 2048,
    parameter integer HF_FIFO_DEPTH = 256
)(
    input wire S_AXIS_ACLK,
    input wire S_AXIS_RESETN,

    input wire M_AXIS_ACLK,
    input wire M_AXIS_RESETN,

    // Data frame length configuration
    input wire SET_CONFIG,
    input wire [15:0] MAX_TRIGGER_LENGTH, // maximum value should be 512 (charge_sum will be over-flow with larger value)

    // Input signals from trigger
    input wire [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] S_AXIS_TDATA, // TDATA from RF Data Converter logic IP
    input wire S_AXIS_TVALID,

    // h-gain data for charge_sum
    input wire [`RFDC_TDATA_WIDTH-1:0] H_GAIN_TDATA,

    input wire M_AXIS_TREADY,
    output wire M_AXIS_TVALID,
    output wire [`RFDC_TDATA_WIDTH-1:0] M_AXIS_TDATA,
    output wire [`RFDC_TDATA_WIDTH/8-1:0] M_AXIS_TKEEP,    
    output wire M_AXIS_TLAST,

    output wire DATAFRAME_GEN_ERROR
);

    wire WR_ARESET = ~S_AXIS_RESETN;
    wire RD_ARESET = ~M_AXIS_RESETN;

    wire [(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-1:0] HEADER_FOOTER_DATA;
    wire HEADER_FOOTER_VALID;
    wire [(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-1:0] HF_FIFO_DOUT;
    wire HF_FIFO_RD_EN;
    wire HF_FIFO_FULL;
    wire HF_FIFO_EMPTY;
    wire HF_FIFO_ALMOST_FULL;
    wire HF_FIFO_WR_RST_BUSY;
    wire HF_FIFO_RD_RST_BUSY;
    wire HF_FIFO_RD_RST_BUSY_wr_domain;


    wire [`RFDC_TDATA_WIDTH-1:0] ADC_DATA;
    wire ADC_VALID;
    wire [`RFDC_TDATA_WIDTH-1:0] ADC_FIFO_DOUT;
    wire ADC_FIFO_RD_EN;
    wire ADC_FIFO_ALMOST_FULL;
    wire ADC_FIFO_FULL;
    wire ADC_FIFO_EMPTY;
    wire ADC_FIFO_WR_RST_BUSY;
    wire ADC_FIFO_RD_RST_BUSY;
    wire ADC_FIFO_RD_RST_BUSY_wr_domain;   

    async_header_footer_gen # (
        .CHANNEL_ID(CHANNEL_ID)
    ) header_footer_gen_inst (
        .ACLK(S_AXIS_ACLK),
        .ARESET(WR_ARESET),

        // Data frame length configuration
        .SET_CONFIG(SET_CONFIG),
        .MAX_TRIGGER_LENGTH(MAX_TRIGGER_LENGTH),

        // Input signals from trigger
        .S_AXIS_TDATA(S_AXIS_TDATA), // TDATA from data trigger
        .S_AXIS_TVALID(S_AXIS_TVALID),

        .H_GAIN_TDATA(H_GAIN_TDATA),
        
        .HEADER_FOOTER_DATA(HEADER_FOOTER_DATA),
        .HEADER_FOOTER_VALID(HEADER_FOOTER_VALID),
        .HF_FIFO_ALMOST_FULL(HF_FIFO_ALMOST_FULL),
        .HF_FIFO_FULL(HF_FIFO_FULL),
        .HF_FIFO_RST_BUSY(HF_FIFO_WR_RST_BUSY|HF_FIFO_RD_RST_BUSY_wr_domain),

        .ADC_DATA(ADC_DATA),
        .ADC_VALID(ADC_VALID),
        .ADC_FIFO_ALMOST_FULL(ADC_FIFO_ALMOST_FULL),
        .ADC_FIFO_FULL(ADC_FIFO_FULL),
        .ADC_FIFO_RST_BUSY(ADC_FIFO_WR_RST_BUSY|ADC_FIFO_RD_RST_BUSY_wr_domain)
    );

    // xpm_cdc_array_single: Single-bit Array Synchronizer
    // Xilinx Parameterized Macro, version 2019.1

    xpm_cdc_array_single #(
    .DEST_SYNC_FF(4),   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(1),  // DECIMAL; 0=do not register input, 1=register input
        .WIDTH(2)           // DECIMAL; range: 1-1024
    )
    xpm_cdc_array_single_inst (
        .dest_out({HF_FIFO_RD_RST_BUSY_wr_domain, ADC_FIFO_RD_RST_BUSY_wr_domain}), // WIDTH-bit output: src_in synchronized to the destination clock domain. This
                                // output is registered.

        .dest_clk(S_AXIS_ACLK), // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(M_AXIS_ACLK),   // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in({HF_FIFO_RD_RST_BUSY, ADC_FIFO_RD_RST_BUSY})      // WIDTH-bit input: Input single-bit array to be synchronized to destination clock
                                // domain. It is assumed that each bit of the array is unrelated to the others. This
                                // is reflected in the constraints applied to this macro. To transfer a binary value
                                // losslessly across the two clock domains, use the XPM_CDC_GRAY macro instead.

    );

// End of xpm_cdc_array_single_inst instantiation


    // xpm_fifo_async: Asynchronous FIFO
    // Xilinx Parameterized Macro, version 2019.1

    xpm_fifo_async #(
        .CDC_SYNC_STAGES(2),       // DECIMAL
        .DOUT_RESET_VALUE("0"),    // String
        .ECC_MODE("no_ecc"),       // String
        .FIFO_MEMORY_TYPE("auto"), // String
        .FIFO_READ_LATENCY(1),     // DECIMAL
        .FIFO_WRITE_DEPTH(2**$clog2(ADC_FIFO_DEPTH)),   // DECIMAL
        .FULL_RESET_VALUE(0),      // DECIMAL
        .PROG_EMPTY_THRESH(10),    // DECIMAL
        .PROG_FULL_THRESH(10),     // DECIMAL
        .RD_DATA_COUNT_WIDTH(1),   // DECIMAL
        .READ_DATA_WIDTH(`RFDC_TDATA_WIDTH),      // DECIMAL
        .READ_MODE("std"),         // String
        .RELATED_CLOCKS(0),        // DECIMAL
        .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .USE_ADV_FEATURES("0008"), // String
        .WAKEUP_TIME(0),           // DECIMAL
        .WRITE_DATA_WIDTH(`RFDC_TDATA_WIDTH),     // DECIMAL
        .WR_DATA_COUNT_WIDTH(1)    // DECIMAL
    ) xpm_adc_fifo_async_inst (
        .almost_empty(),   // 1-bit output: Almost Empty : When asserted, this signal indicates that
                                        // only one more read can be performed before the FIFO goes to empty.

        .almost_full(ADC_FIFO_ALMOST_FULL),     // 1-bit output: Almost Full: When asserted, this signal indicates that
                                        // only one more write can be performed before the FIFO is full.

        .data_valid(),       // 1-bit output: Read Data Valid: When asserted, this signal indicates
                                        // that valid data is available on the output bus (dout).

        .dbiterr(),             // 1-bit output: Double Bit Error: Indicates that the ECC decoder detected
                                        // a double-bit error and data in the FIFO core is corrupted.

        .dout(ADC_FIFO_DOUT),                   // READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven
                                        // when reading the FIFO.

        .empty(ADC_FIFO_EMPTY),                 // 1-bit output: Empty Flag: When asserted, this signal indicates that the
                                        // FIFO is empty. Read requests are ignored when the FIFO is empty,
                                        // initiating a read while empty is not destructive to the FIFO.

        .full(ADC_FIFO_FULL),                   // 1-bit output: Full Flag: When asserted, this signal indicates that the
                                        // FIFO is full. Write requests are ignored when the FIFO is full,
                                        // initiating a write when the FIFO is full is not destructive to the
                                        // contents of the FIFO.

        .overflow(),           // 1-bit output: Overflow: This signal indicates that a write request
                                        // (wren) during the prior clock cycle was rejected, because the FIFO is
                                        // full. Overflowing the FIFO is not destructive to the contents of the
                                        // FIFO.

        .prog_empty(),       // 1-bit output: Programmable Empty: This signal is asserted when the
                                        // number of words in the FIFO is less than or equal to the programmable
                                        // empty threshold value. It is de-asserted when the number of words in
                                        // the FIFO exceeds the programmable empty threshold value.

        .prog_full(),         // 1-bit output: Programmable Full: This signal is asserted when the
                                        // number of words in the FIFO is greater than or equal to the
                                        // programmable full threshold value. It is de-asserted when the number of
                                        // words in the FIFO is less than the programmable full threshold value.

        .rd_data_count(), // RD_DATA_COUNT_WIDTH-bit output: Read Data Count: This bus indicates the
                                        // number of words read from the FIFO.

        .rd_rst_busy(ADC_FIFO_RD_RST_BUSY),     // 1-bit output: Read Reset Busy: Active-High indicator that the FIFO read
                                        // domain is currently in a reset state.

        .sbiterr(),             // 1-bit output: Single Bit Error: Indicates that the ECC decoder detected
                                        // and fixed a single-bit error.

        .underflow(),         // 1-bit output: Underflow: Indicates that the read request (rd_en) during
                                        // the previous clock cycle was rejected because the FIFO is empty. Under
                                        // flowing the FIFO is not destructive to the FIFO.

        .wr_ack(),               // 1-bit output: Write Acknowledge: This signal indicates that a write
                                        // request (wr_en) during the prior clock cycle is succeeded.

        .wr_data_count(), // WR_DATA_COUNT_WIDTH-bit output: Write Data Count: This bus indicates
                                        // the number of words written into the FIFO.

        .wr_rst_busy(ADC_FIFO_WR_RST_BUSY),     // 1-bit output: Write Reset Busy: Active-High indicator that the FIFO
                                        // write domain is currently in a reset state.

        .din(ADC_DATA),                     // WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when
                                        // writing the FIFO.

        .injectdbiterr(), // 1-bit input: Double Bit Error Injection: Injects a double bit error if
                                        // the ECC feature is used on block RAMs or UltraRAM macros.

        .injectsbiterr(), // 1-bit input: Single Bit Error Injection: Injects a single bit error if
                                        // the ECC feature is used on block RAMs or UltraRAM macros.

        .rd_clk(M_AXIS_ACLK),               // 1-bit input: Read clock: Used for read operation. rd_clk must be a free
                                        // running clock.

        .rd_en(ADC_FIFO_RD_EN),                 // 1-bit input: Read Enable: If the FIFO is not empty, asserting this
                                        // signal causes data (on dout) to be read from the FIFO. Must be held
                                        // active-low when rd_rst_busy is active high.

        .rst(WR_ARESET),                     // 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be
                                        // unstable at the time of applying reset, but reset must be released only
                                        // after the clock(s) is/are stable.

        .sleep(),                 // 1-bit input: Dynamic power saving: If sleep is High, the memory/fifo
                                        // block is in power saving mode.

        .wr_clk(S_AXIS_ACLK),               // 1-bit input: Write clock: Used for write operation. wr_clk must be a
                                        // free running clock.

        .wr_en(ADC_VALID)                  // 1-bit input: Write Enable: If the FIFO is not full, asserting this
                                        // signal causes data (on din) to be written to the FIFO. Must be held
                                        // active-low when rst or wr_rst_busy is active high.

    );
    // End of xpm_fifo_async_inst instantiation


    // xpm_fifo_async: Asynchronous FIFO
    // Xilinx Parameterized Macro, version 2019.1

    xpm_fifo_async #(
        .CDC_SYNC_STAGES(2),       // DECIMAL
        .DOUT_RESET_VALUE("0"),    // String
        .ECC_MODE("no_ecc"),       // String
        .FIFO_MEMORY_TYPE("auto"), // String
        .FIFO_READ_LATENCY(1),     // DECIMAL
        .FIFO_WRITE_DEPTH(2**$clog2(HF_FIFO_DEPTH)),   // DECIMAL
        .FULL_RESET_VALUE(0),      // DECIMAL
        .PROG_EMPTY_THRESH(10),    // DECIMAL
        .PROG_FULL_THRESH(10),     // DECIMAL
        .RD_DATA_COUNT_WIDTH(1),   // DECIMAL
        .READ_DATA_WIDTH((`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH),      // DECIMAL
        .READ_MODE("std"),         // String
        .RELATED_CLOCKS(0),        // DECIMAL
        .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .USE_ADV_FEATURES("0008"), // String
        .WAKEUP_TIME(0),           // DECIMAL
        .WRITE_DATA_WIDTH((`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH),     // DECIMAL
        .WR_DATA_COUNT_WIDTH(1)    // DECIMAL
    ) xpm_hf_fifo_async_inst (
        .almost_empty(),   // 1-bit output: Almost Empty : When asserted, this signal indicates that
                                        // only one more read can be performed before the FIFO goes to empty.

        .almost_full(HF_FIFO_ALMOST_FULL),     // 1-bit output: Almost Full: When asserted, this signal indicates that
                                        // only one more write can be performed before the FIFO is full.

        .data_valid(),       // 1-bit output: Read Data Valid: When asserted, this signal indicates
                                        // that valid data is available on the output bus (dout).

        .dbiterr(),             // 1-bit output: Double Bit Error: Indicates that the ECC decoder detected
                                        // a double-bit error and data in the FIFO core is corrupted.

        .dout(HF_FIFO_DOUT),                   // READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven
                                        // when reading the FIFO.

        .empty(HF_FIFO_EMPTY),                 // 1-bit output: Empty Flag: When asserted, this signal indicates that the
                                        // FIFO is empty. Read requests are ignored when the FIFO is empty,
                                        // initiating a read while empty is not destructive to the FIFO.

        .full(HF_FIFO_FULL),                   // 1-bit output: Full Flag: When asserted, this signal indicates that the
                                        // FIFO is full. Write requests are ignored when the FIFO is full,
                                        // initiating a write when the FIFO is full is not destructive to the
                                        // contents of the FIFO.

        .overflow(),           // 1-bit output: Overflow: This signal indicates that a write request
                                        // (wren) during the prior clock cycle was rejected, because the FIFO is
                                        // full. Overflowing the FIFO is not destructive to the contents of the
                                        // FIFO.

        .prog_empty(),       // 1-bit output: Programmable Empty: This signal is asserted when the
                                        // number of words in the FIFO is less than or equal to the programmable
                                        // empty threshold value. It is de-asserted when the number of words in
                                        // the FIFO exceeds the programmable empty threshold value.

        .prog_full(),         // 1-bit output: Programmable Full: This signal is asserted when the
                                        // number of words in the FIFO is greater than or equal to the
                                        // programmable full threshold value. It is de-asserted when the number of
                                        // words in the FIFO is less than the programmable full threshold value.

        .rd_data_count(), // RD_DATA_COUNT_WIDTH-bit output: Read Data Count: This bus indicates the
                                        // number of words read from the FIFO.

        .rd_rst_busy(HF_FIFO_RD_RST_BUSY),     // 1-bit output: Read Reset Busy: Active-High indicator that the FIFO read
                                        // domain is currently in a reset state.

        .sbiterr(),             // 1-bit output: Single Bit Error: Indicates that the ECC decoder detected
                                        // and fixed a single-bit error.

        .underflow(),         // 1-bit output: Underflow: Indicates that the read request (rd_en) during
                                        // the previous clock cycle was rejected because the FIFO is empty. Under
                                        // flowing the FIFO is not destructive to the FIFO.

        .wr_ack(),               // 1-bit output: Write Acknowledge: This signal indicates that a write
                                        // request (wr_en) during the prior clock cycle is succeeded.

        .wr_data_count(), // WR_DATA_COUNT_WIDTH-bit output: Write Data Count: This bus indicates
                                        // the number of words written into the FIFO.

        .wr_rst_busy(HF_FIFO_WR_RST_BUSY),     // 1-bit output: Write Reset Busy: Active-High indicator that the FIFO
                                        // write domain is currently in a reset state.

        .din(HEADER_FOOTER_DATA),                     // WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when
                                        // writing the FIFO.

        .injectdbiterr(), // 1-bit input: Double Bit Error Injection: Injects a double bit error if
                                        // the ECC feature is used on block RAMs or UltraRAM macros.

        .injectsbiterr(), // 1-bit input: Single Bit Error Injection: Injects a single bit error if
                                        // the ECC feature is used on block RAMs or UltraRAM macros.

        .rd_clk(M_AXIS_ACLK),               // 1-bit input: Read clock: Used for read operation. rd_clk must be a free
                                        // running clock.

        .rd_en(HF_FIFO_RD_EN),                 // 1-bit input: Read Enable: If the FIFO is not empty, asserting this
                                        // signal causes data (on dout) to be read from the FIFO. Must be held
                                        // active-low when rd_rst_busy is active high.

        .rst(WR_ARESET),                     // 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be
                                        // unstable at the time of applying reset, but reset must be released only
                                        // after the clock(s) is/are stable.

        .sleep(),                 // 1-bit input: Dynamic power saving: If sleep is High, the memory/fifo
                                        // block is in power saving mode.

        .wr_clk(S_AXIS_ACLK),               // 1-bit input: Write clock: Used for write operation. wr_clk must be a
                                        // free running clock.

        .wr_en(HEADER_FOOTER_VALID)                  // 1-bit input: Write Enable: If the FIFO is not full, asserting this
                                        // signal causes data (on din) to be written to the FIFO. Must be held
                                        // active-low when rst or wr_rst_busy is active high.

    );
    // End of xpm_fifo_async_inst instantiation


    async_dataframe_gen dataframe_gen_inst (
        .ACLK(M_AXIS_ACLK),
        .ARESET(RD_ARESET),

        .HF_FIFO_RD_RST_BUSY(HF_FIFO_RD_RST_BUSY),
        .HF_FIFO_EMPTY(HF_FIFO_EMPTY),
        .HF_FIFO_DOUT(HF_FIFO_DOUT),
        .HF_FIFO_RD_EN(HF_FIFO_RD_EN),

        .ADC_FIFO_RD_RST_BUSY(ADC_FIFO_RD_RST_BUSY),
        .ADC_FIFO_EMPTY(ADC_FIFO_EMPTY),
        .ADC_FIFO_DOUT(ADC_FIFO_DOUT),
        .ADC_FIFO_RD_EN(ADC_FIFO_RD_EN),

        .M_AXIS_TREADY(M_AXIS_TREADY),
        .M_AXIS_TVALID(M_AXIS_TVALID),
        .M_AXIS_TDATA(M_AXIS_TDATA),
        .M_AXIS_TKEEP(M_AXIS_TKEEP),
        .M_AXIS_TLAST(M_AXIS_TLAST),

        .DATAFRAME_GEN_ERROR(DATAFRAME_GEN_ERROR)
    );



endmodule // 