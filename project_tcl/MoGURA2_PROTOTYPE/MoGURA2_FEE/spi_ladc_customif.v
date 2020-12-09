module spi_ladc_customif (
    input wire [7:0] LADC_SEN,
    input wire [6:0] LDAC_SDATA,
    output wire [6:0] LDAC_SEN,

    input wire SPI_LADC_0_io0_t,
    output wire SPI_LADC_0_io0_i,
    input wire SPI_LADC_0_io0_o,

    input wire SPI_LADC_0_io1_t,
    output wire SPI_LADC_0_io1_i,
    input wire SPI_LADC_0_io1_o,

    input wire SPI_LADC_0_ss_t,
    output wire SPI_LADC_0_ss_i,    
    input wire SPI_LADC_0_ss_o,

    input wire SPI_LADC_0_sck_t,
    output wire SPI_LADC_0_sck_i,    
    input wire SPI_LADC_0_sck_o,

    inout wire SPI_LADC_0_io0_io,
    inout wire SPI_LADC_0_io1_io,
    inout wire SPI_LADC_0_sck_io,
    inout wire SPI_LADC_0_ss_io

);


    wire SPI_LADC_0_ss_o_tmp;
    wire SPI_LADC_0_io1_i_tmp;  

    IOBUF SPI_LADC_0_io0_iobuf
        (.I(SPI_LADC_0_io0_o),
        .IO(SPI_LADC_0_io0_io),
        .O(SPI_LADC_0_io0_i),
        .T(SPI_LADC_0_io0_t));

    IOBUF SPI_LADC_0_io1_iobuf
        (.I(SPI_LADC_0_io1_o),
        .IO(SPI_LADC_0_io1_io),
        .O(SPI_LADC_0_io1_i_tmp),
        .T(SPI_LADC_0_io1_t));

    IOBUF SPI_LADC_0_sck_iobuf
        (.I(SPI_LADC_0_sck_o),
        .IO(SPI_LADC_0_sck_io),
        .O(SPI_LADC_0_sck_i),
        .T(SPI_LADC_0_sck_t));

    IOBUF SPI_LADC_0_ss_iobuf_0
        (.I(SPI_LADC_0_ss_o_tmp),
        .IO(SPI_LADC_0_ss_io),
        .O(SPI_LADC_0_ss_i),
        .T(SPI_LADC_0_ss_t));

    assign SPI_LADC_0_io1_i = (LADC_SEN==8'b00000001) ?  SPI_LADC_0_io1_i_tmp : 
                                (LADC_SEN==8'b00000010) ?  LDAC_SDATA[0] : 
                                (LADC_SEN==8'b00000100) ?  LDAC_SDATA[1] :
                                (LADC_SEN==8'b00001000) ?  LDAC_SDATA[2] :
                                (LADC_SEN==8'b00010000) ?  LDAC_SDATA[3] :
                                (LADC_SEN==8'b00100000) ?  LDAC_SDATA[4] :
                                (LADC_SEN==8'b01000000) ?  LDAC_SDATA[5] :
                                LDAC_SDATA[6] ;

    assign SPI_LADC_0_ss_o_tmp = (LADC_SEN==8'b00000001) ?  SPI_LADC_0_ss_o : 1'b1;
    assign ldac_sen1 = (LADC_SEN==8'b00000010) ?  SPI_LADC_0_ss_o : 1'b1;
    assign ldac_sen2 = (LADC_SEN==8'b00000100) ?  SPI_LADC_0_ss_o : 1'b1;
    assign ldac_sen3 = (LADC_SEN==8'b00001000) ?  SPI_LADC_0_ss_o : 1'b1;
    assign ldac_sen4 = (LADC_SEN==8'b00010000) ?  SPI_LADC_0_ss_o : 1'b1;
    assign ldac_sen5 = (LADC_SEN==8'b00100000) ?  SPI_LADC_0_ss_o : 1'b1;
    assign ldac_sen6 = (LADC_SEN==8'b01000000) ?  SPI_LADC_0_ss_o : 1'b1;
    assign ldac_sen7 = (LADC_SEN==8'b10000000) ?  SPI_LADC_0_ss_o : 1'b1;
    
endmodule