`timescale 1 ps / 1 ps

module l_gain_decimator (
    input wire ACLK,
    input wire ARESET,
    input wire SET_CONFIG,

    // S_AXIS interface from RF Data Converter Logic IP (H-gain port)
    input wire [127:0] H_S_AXIS_TDATA,
    input wire H_S_AXIS_TVALID,
    output wire H_S_AXIS_TREADY,

    // S_AXIS interface from RF Data Converter Logic IP (L-gain port)
    input wire [127:0] L_S_AXIS_TDATA,
    input wire L_S_AXIS_TVALID,
    output wire L_S_AXIS_TREADY,

    // M_AXIS interface for H-gain ADC
    output wire [127:0] H_M_AXIS_TDATA,
    output wire H_M_AXIS_TVALID,

    // M_AXIS interfrace for L-gain ADC
    output wire [31:0] L_M_AXIS_TDATA,
    output wire L_M_AXIS_TVALID
  
);

    reg tready;
    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            tready <= #100 1'b0;
        end else begin
            tready <= #100 1'b1;
        end
    end

    wire signed [11:0] s_axis_sample[7:0];
    wire signed [13:0] h_gain_partial_sum[3:0];
    wire signed [13:0] h_gain_sum[1:0];
    wire signed [11:0] averaged_h_gain_sample[1:0];    

    reg [127:0] h_gain_tdata;

    reg [31:0] l_gain_tdata;
    wire signed [15:0] l_gain_sample[1:0];

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin
            assign s_axis_sample[i] = L_S_AXIS_TDATA[i*16+16-12 +:12];
        end
        for (i=0; i<4; i=i+1) begin
            assign h_gain_partial_sum[i] = s_axis_sample[2*i] + s_axis_sample[2*i+1];
        end
        for (i=0; i<2; i=i+1) begin
            assign h_gain_sum[i] = h_gain_partial_sum[2*i] + h_gain_partial_sum[2*i+1];
            assign averaged_h_gain_sample[i] = h_gain_sum[i][2 +:12];
        end

        for (i=0; i<2; i=i+1) begin
            assign l_gain_sample[i] = { {16-12{averaged_h_gain_sample[i][11]}},  averaged_h_gain_sample[i]};
        end
    endgenerate


    integer j;
    always @(posedge ACLK ) begin
        h_gain_tdata <= #100 H_S_AXIS_TDATA;
        for (j=0; j<2; j=j+1) begin
            l_gain_tdata[j*16 +:16] <= #100 l_gain_sample[j];
        end                     
    end

    reg h_tvalid;
    reg l_tvalid;
    always @(posedge ACLK ) begin
        if (|{ARESET, SET_CONFIG}) begin
            h_tvalid <= #100 1'b0;
            l_tvalid <= #100 1'b0;
        end else begin
            h_tvalid <= #100 H_S_AXIS_TVALID;
            l_tvalid <= #100 L_S_AXIS_TVALID;
        end
    end
    
    assign H_S_AXIS_TREADY = tready;
    assign L_S_AXIS_TREADY = tready;

    assign H_M_AXIS_TVALID = h_tvalid;
    assign L_M_AXIS_TVALID = l_tvalid;

    assign H_M_AXIS_TDATA = h_gain_tdata;
    assign L_M_AXIS_TDATA = l_gain_tdata;
    
    
endmodule