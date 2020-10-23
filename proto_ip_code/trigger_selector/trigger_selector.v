`timescale 1 ps / 1 ps
`include "selector_config.vh" 

module trigger_selector (
    input wire ACLK,
    input wire ARESET,
    input wire SET_CONFIG,
    input wire STOP,
    
    input wire [`TRIGGER_TYPE_WIDTH-1:0] TRIGGER_TYPE,
    input wire EXTERNAL_TRIGGER,

    input wire S_AXIS_TVALID,
    input wire [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] S_AXIS_TDATA,

    input wire [`RFDC_TDATA_WIDTH-1:0] H_GAIN_TDATA_IN,

    output wire M_AXIS_TVALID,
    output wire [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] M_AXIS_TDATA,
    output wire [`RFDC_TDATA_WIDTH-1:0] H_GAIN_TDATA

);

    reg [`TRIGGER_TYPE_WIDTH-1:0] trigger_type;

    always @(posedge ACLK ) begin
        if (ARESET) begin
            trigger_type <= #100 `HARDWARE_TRG;
        end else begin
           if (SET_CONFIG) begin
               trigger_type <= #100 TRIGGER_TYPE;
           end else begin
               trigger_type <= #100 trigger_type;
           end 
        end
    end

    reg ext_trgD;
    reg ext_trg;
    always @(posedge ACLK ) begin
        ext_trgD <= #100 EXTERNAL_TRIGGER;
        ext_trg <= #100 ext_trgD;
    end

    reg tvalidD;
    reg tvalid;
    reg [`RFDC_TDATA_WIDTH-1:0] h_gain_tdataD;
    reg [`RFDC_TDATA_WIDTH-1:0] h_gain_tdata;
    reg [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] tdataD;
    reg [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] tdata;

    always @(posedge ACLK) begin
        tdataD <= #100 {S_AXIS_TDATA[`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1 -:`RFDC_TDATA_WIDTH+(`TRIGGER_INFO_WIDTH-`TRIGGER_TYPE_WIDTH)], trigger_type, S_AXIS_TDATA[`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0]};     
        tdata <= #100 tdataD;
    end

    always @(posedge ACLK ) begin
        h_gain_tdataD <= #100 H_GAIN_TDATA_IN;
        h_gain_tdata <= #100 h_gain_tdataD;
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG, STOP}) begin
            tvalidD <= #100 1'b0;
        end else begin
            case (trigger_type)
                `HARDWARE_TRG:
                    begin
                        tvalidD <= #100 S_AXIS_TVALID;
                    end
                `EXTERNAL_TRG:
                    begin
                        tvalidD <= #100 ext_trg;                 
                    end
                default: 
                    begin
                        tvalidD <= #100 S_AXIS_TVALID;
                    end
            endcase            
        end  
    end

    always @(posedge ACLK ) begin
        if (ARESET|SET_CONFIG) begin
            tvalid <= #100 1'b0;
        end else begin
            tvalid <= #100 tvalidD;
        end        
    end


    assign M_AXIS_TVALID = tvalid;
    assign M_AXIS_TDATA = tdata;
    assign H_GAIN_TDATA = h_gain_tdata;

endmodule