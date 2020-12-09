module iic_cdci6214_customif #(
	parameter integer NUMBER_OF_STAGES = 200,
	parameter integer BIT_WIDTHS = 1
)(
    input wire CLK,
    input wire IIC_CDCI6214_0_scl_t,
    output wire IIC_CDCI6214_0_scl_i,
    input wire IIC_CDCI6214_0_scl_o,

    input wire IIC_CDCI6214_0_sda_t,
    output wire IIC_CDCI6214_0_sda_i,
    input wire IIC_CDCI6214_0_sda_o,

    inout wire IIC_CDCI6214_0_scl_io,
    inout wire IIC_CDCI6214_0_sda_io
);

    integer i;

    reg [BIT_WIDTHS-1:0] f[NUMBER_OF_STAGES-1:0];

    always @(posedge CLK) begin : proc_gen_f
        for (i=0; i<=NUMBER_OF_STAGES-1; i=i+1) begin
            if (i==0) begin
                f[i] <= IIC_CDCI6214_0_sda_t;
            end else begin
                f[i] <= f[i-1];
            end
        end
    end

    wire sync_sda_t = f[NUMBER_OF_STAGES-1];

    IOBUF IIC_CDCI6214_0_scl_iobuf
        (.I(IIC_CDCI6214_0_scl_o),
            .IO(IIC_CDCI6214_0_scl_io),
            .O(IIC_CDCI6214_0_scl_i),
            .T(IIC_CDCI6214_0_scl_t));

    IOBUF IIC_CDCI6214_0_sda_iobuf
        (.I(IIC_CDCI6214_0_sda_o),
        .IO(IIC_CDCI6214_0_sda_io),
        .O(IIC_CDCI6214_0_sda_i),
        .T(sync_sda_t));
    
endmodule