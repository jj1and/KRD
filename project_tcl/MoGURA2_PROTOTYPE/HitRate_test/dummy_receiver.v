module dummy_receiver # (
    parameter integer TDATA_WIDTH = 128,
    parameter integer HEADER_FOOTER_ID_WIDTH = 8,
    parameter integer CHANNEL_ID_WIDTH = 12,
    parameter integer FRAME_LENGTH_WIDTH = 12
)(
    input wire ACLK,
    input wire ARESETN,

    input wire [TDATA_WIDTH-1:0] S_AXIS_TDATA,
    input wire S_AXIS_TVALID,
    output wire S_AXIS_TREADY,

    output wire [31:0] RECEIVED_SIZE,
    output wire FULL_FLAG,
    output wire [30:0] HIT_COUNT
);

    localparam integer DATAFRAME_WIDTH = 64;
    localparam integer HEADER_ID = 8'hAA;

    wire tdata_is_header =  (S_AXIS_TDATA[DATAFRAME_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==HEADER_ID);
    wire [11:0] packet_size = S_AXIS_TDATA[DATAFRAME_WIDTH-HEADER_FOOTER_ID_WIDTH-CHANNEL_ID_WIDTH-1 -:FRAME_LENGTH_WIDTH]+4;
    wire [3:0] frame_info = S_AXIS_TDATA[DATAFRAME_WIDTH-HEADER_FOOTER_ID_WIDTH-CHANNEL_ID_WIDTH-FRAME_LENGTH_WIDTH-1 -:4];
    wire df_indicates_runEnd = (frame_info[3:2] == 2'b10);
    wire df_indicate_firstFrame = (frame_info[1] == 1'b1);
    wire df_indicates_notLastFrame = (frame_info[0] == 1'b1);
    wire df_full = (df_indicates_notLastFrame & df_indicates_runEnd);


    reg tready;
    reg full_flag;
    reg [31:0] total_rcvd_size;
    reg [19:0] counter;
    reg [30:0] hit_count;

    always @(posedge ACLK ) begin
        if (!ARESETN) begin
            total_rcvd_size <= #100 0;
        end else begin
            if (tdata_is_header&S_AXIS_TVALID) begin
                total_rcvd_size <= #100 total_rcvd_size + packet_size;
            end else begin
                total_rcvd_size <= #100 total_rcvd_size;
            end                
        end
    end

    always @(posedge ACLK ) begin
        if (!ARESETN) begin
            counter <= #100 0;
        end else begin
            counter <= #100 counter + 1;
        end
    end

    always @(posedge ACLK) begin
        if (|{!ARESETN, counter=={20{1'b1}}}) begin
            hit_count <= #100 0;
        end else begin
            if (&{tdata_is_header, df_indicate_firstFrame, S_AXIS_TVALID}) begin
                hit_count <= #100 hit_count + 1;
            end else begin
                hit_count <= #100 hit_count;
            end
        end
    end

    always @(posedge ACLK ) begin
        if (!ARESETN) begin
            full_flag <= #100 1'b0;
        end else begin
            if (&{tdata_is_header, df_full, S_AXIS_TVALID}) begin
                full_flag <= #100 1'b1;
            end else begin
                full_flag <= #100 full_flag;
            end
        end
    end

    always @(posedge ACLK) begin
        if (!ARESETN) begin
            tready <= #100 1'b0;
        end else begin
            tready <= 1'b1;
        end
    end

    assign S_AXIS_TREADY = tready;
    assign FULL_FLAG = full_flag;
    assign RECEIVED_SIZE = total_rcvd_size;
    assign HIT_COUNT = hit_count;
    
endmodule