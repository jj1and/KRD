`timescale 1ps / 1ps

module axi_dma_connector_tb;

    parameter integer ACLK_PERIOD = 8000; // 125MHz
    parameter integer RESET_ACLK_NUM = 10;
    
    
    parameter integer TDATA_WIDTH = 128;
    parameter integer HEADER_FOOTER_ID_WIDTH = 8;
    parameter integer CHANNEL_ID_WIDTH = 12;
    parameter integer FRAME_LENGTH_WIDTH = 12;

    parameter integer MAX_TRIGGER_LENGTH = 16;

    wire [7:0] HEADER_ID = 8'hAA;
    wire [7:0] FOOTER_ID = 8'h55;

    reg ACLK = 0;
    reg ARESET = 1'b0;
    
    reg  [TDATA_WIDTH-1:0] S_AXIS_TDATA;
    reg [TDATA_WIDTH/8-1:0] S_AXIS_TKEEP;
    reg S_AXIS_TVALID;
    reg S_AXIS_TLAST;
    wire S_AXIS_TREADY;

    wire [TDATA_WIDTH-1:0] M_AXIS_TDATA;
    wire [TDATA_WIDTH/8-1:0] M_AXIS_TKEEP;
    wire M_AXIS_TVALID;
    wire M_AXIS_TLAST;
    reg M_AXIS_TREADY;

    reg AXIDMA_S2MM_INTR_IN;

    axi_dma_connector # (
        .TDATA_WIDTH(TDATA_WIDTH)
    ) DUT ( 
        .*
    );

    typedef struct packed {
        reg [127:0] tdata;
        reg tvalid;
        reg [15:0] tkeep;
        reg tlast;
    } axis_data;
    typedef axis_data dataframe_line_t[];

    function dataframe_line_t generateFrame(input int frame_length);
        reg [15:0] tmp_sample[TDATA_WIDTH/16];
        reg [FRAME_LENGTH_WIDTH-1:0] frame_len;
        dataframe_line_t result;
        if (frame_length/2 > MAX_TRIGGER_LENGTH) begin
            $display("TEST ERROR: frame_length*2 must be smaller than max trigger length");
            $finish;
        end

        result = new[frame_length/2+2];
        frame_len = frame_length;
        
        result[0].tdata = {64'b0, HEADER_ID, 12'd0, frame_len, {64-HEADER_FOOTER_ID_WIDTH-CHANNEL_ID_WIDTH-FRAME_LENGTH_WIDTH{1'b0}}};
        result[0].tvalid = 1'b1;
        result[0].tkeep = 16'hFFFF;
        result[0].tlast = 1'b0;

        for (int i=1; i<frame_length/2+1; i++) begin
            for (int j=0; j<8; j++) begin
                tmp_sample[j] = i+j;
                result[i].tdata[j*16 +:16] = tmp_sample[j];
            end
            result[i].tvalid = 1'b1;
            result[i].tkeep = 16'hFFFF;
            result[i].tlast = 1'b0;
        end

        result[frame_length/2+1].tdata = {64'b0, FOOTER_ID, {64-8{1'b1}}};
        result[frame_length/2+1].tvalid = 1'b1;
        result[frame_length/2+1].tkeep = 16'h00FF;
        result[frame_length/2+1].tlast = 1'b1;        
        return result;
    endfunction


    task reset_all;   
        test_status = RESET_ALL;
        ARESET <= #100 1'b1;
        S_AXIS_TDATA <= #100 {TDATA_WIDTH{1'b1}};
        S_AXIS_TKEEP <= #100 {TDATA_WIDTH/8{1'b1}};
        S_AXIS_TVALID <= #100 1'b0;
        S_AXIS_TLAST <= #100 1'b0;
        M_AXIS_TREADY <= #100 1'b0;
        AXIDMA_S2MM_INTR_IN <= #100 1'b0;        
        repeat(RESET_ACLK_NUM) @(posedge ACLK);
        ARESET <= #100 1'b0;
    endtask


    task dut_output_monitor(input dataframe_line_t sample_frame[], input int sample_num);
        int test_failed;
        int sample_index;
        int line_index;
        
        sample_index = 0;
        line_index = 0;
        test_failed = 0;
        while (sample_index < sample_num) begin
            @(posedge ACLK);
            if (M_AXIS_TVALID&M_AXIS_TREADY) begin
                
                if (M_AXIS_TDATA[127 -:8]==FOOTER_ID) begin
                    if (sample_frame[sample_index][line_index].tdata[127:64] != M_AXIS_TDATA[127:64]) begin
                        $display("TEST FAILED: TDATA doesn't match Input:%0x  Output:%0x", sample_frame[sample_index][line_index].tdata, M_AXIS_TDATA);
                        test_failed = 1;
                    end                    
                end else if (sample_frame[sample_index][line_index].tdata != M_AXIS_TDATA) begin
                    $display("TEST FAILED: TDATA doesn't match Input:%0x  Output:%0x", sample_frame[sample_index][line_index].tdata, M_AXIS_TDATA);
                    test_failed = 1;
                end
                if (sample_frame[sample_index][line_index].tvalid != M_AXIS_TVALID) begin
                    $display("TEST FAILED: TVALID doesn't match Input:%0d  Output:%0d", sample_frame[sample_index][line_index].tvalid, M_AXIS_TVALID);
                    test_failed = 1;                    
                end
                if (sample_frame[sample_index][line_index].tlast != M_AXIS_TLAST) begin
                     $display("TEST FAILED: TLAST doesn't match Input:%0x  Output:%0x", sample_frame[sample_index][line_index].tlast, M_AXIS_TLAST);
                    test_failed = 1;                   
                end
                if (sample_frame[sample_index][line_index].tkeep != M_AXIS_TKEEP) begin
                    $display("TEST FAILED: TKEEP doesn't match Input:%0x  Output:%0x", sample_frame[sample_index][line_index].tkeep, M_AXIS_TKEEP);
                    test_failed = 1;                    
                end

                if (test_failed!=0) begin
                    $finish;
                end
                line_index++;
                if (M_AXIS_TDATA[63 -:8]==FOOTER_ID) begin
                    $display("TEST INFO: sample[%0d] is acquired", sample_index);
                    sample_index++;
                    line_index = 0;
                end
            end
        end
    endtask 

    task sample_send(input dataframe_line_t sample_frame[], input int sample_num, input int sample_frame_length[]);
        int line_index;
        int force_halt;
        @(posedge ACLK);
        S_AXIS_TVALID <= #100 1'b0;
        S_AXIS_TLAST <= #100 1'b0;
        S_AXIS_TDATA <= #100 {128{1'b1}};
        S_AXIS_TKEEP <= #100 {128/8{1'b1}};;
        
        fork
            begin
                for (int i=0; i<sample_num; i++) begin
                    line_index = -1;
                    force_halt = 0;

                                            
                    while (line_index< sample_frame_length[i]/2+2) begin 
                        @(posedge ACLK);
                        if (($urandom_range(1)==0)&S_AXIS_TREADY) begin
                            S_AXIS_TVALID <= #100 1'b0;
                            S_AXIS_TLAST <= #100 1'b0;
                            S_AXIS_TDATA <= #100 {128{1'b1}};
                            S_AXIS_TKEEP <= #100 {128/8{1'b1}};;                       
                        end else if ((force_halt==0 & line_index==0)&S_AXIS_TREADY) begin
                            S_AXIS_TVALID <= #100 1'b0;
                            S_AXIS_TLAST <= #100 1'b0;
                            S_AXIS_TDATA <= #100 {128{1'b1}};
                            S_AXIS_TKEEP <= #100 {128/8{1'b1}};
                            force_halt = 1;                    
                        end else begin
                            if (|{line_index<0, S_AXIS_TREADY, !S_AXIS_TVALID}) begin
                                line_index++;
                            end 
                            
                            S_AXIS_TDATA <= #100 sample_frame[i][line_index].tdata;
                            S_AXIS_TVALID <= #100 sample_frame[i][line_index].tvalid;
                            S_AXIS_TLAST <= #100 sample_frame[i][line_index].tlast;
                            S_AXIS_TKEEP <= #100 sample_frame[i][line_index].tkeep;                                                                             
                        end
                    end

                    S_AXIS_TVALID <= #100 1'b0;
                    S_AXIS_TLAST <= #100 1'b0;
                    S_AXIS_TDATA <= #100 {128{1'b1}};
                    S_AXIS_TKEEP <= #100 {128/8{1'b1}};
                end
            end
            begin
                dut_output_monitor(sample_frame, sample_num);
            end
        join
    endtask

    enum int {INITIALIZE, DMA_PROCESS, VALID_READY, INVALID_READY} state;
    reg axidma_s2mm_intr_delay;
    wire axidma_s2mm_intr_posedge = (!axidma_s2mm_intr_delay)&(AXIDMA_S2MM_INTR_IN);
    wire axidma_s2mm_intr_negedge = axidma_s2mm_intr_delay&(!AXIDMA_S2MM_INTR_IN);
    always @(posedge ACLK ) begin
        axidma_s2mm_intr_delay <= #100 AXIDMA_S2MM_INTR_IN;
    end

    task dummy_axi_dma(input int invalid_state_clk_num, input int latency);
        int dma_process_count;
        int invalid_process_count;
        state = INITIALIZE;
        invalid_process_count = 0;
        dma_process_count = 0;            
        fork
            begin
                while(1) begin
                    @(posedge ACLK);
                    if (&{M_AXIS_TVALID, M_AXIS_TLAST, M_AXIS_TREADY}) begin
                        #100
                        state = INVALID_READY;
                    end else begin
                       if (axidma_s2mm_intr_posedge) begin
                           #100
                           state = DMA_PROCESS;
                       end else begin
                           if (axidma_s2mm_intr_negedge) begin
                               #100
                               state = VALID_READY;
                           end else begin
                               if (ARESET) begin
                                   #100
                                   state = INITIALIZE;
                               end else begin
                                   if (state==INITIALIZE) begin
                                       #100
                                       state = VALID_READY;
                                   end else begin
                                       #100
                                       state = state;
                                   end                               
                               end
                           end
                       end 
                    end
                end
            end
            begin
                while (1) begin
                    @(posedge ACLK);
                    case (state)
                        INVALID_READY:
                            begin
                                if (invalid_process_count < invalid_state_clk_num) begin
                                    M_AXIS_TREADY <= #100 1'b1;
                                    AXIDMA_S2MM_INTR_IN <= #100 1'b0;
                                end else begin
                                    M_AXIS_TREADY <= #100 1'b0;
                                    AXIDMA_S2MM_INTR_IN <= #100 1'b1;   
                                end
                                invalid_process_count++;                            
                            end 
                        DMA_PROCESS:
                            begin
                                if (dma_process_count < latency) begin
                                    M_AXIS_TREADY <= #100 1'b0;
                                    AXIDMA_S2MM_INTR_IN <= #100 1'b1;
                                end else begin
                                    M_AXIS_TREADY <= #100 1'b1;
                                    AXIDMA_S2MM_INTR_IN <= #100 1'b0;   
                                end
                                dma_process_count++;               
                            end
                        VALID_READY:
                            begin
                                invalid_process_count = 0;
                                dma_process_count = 0;                                  
                                M_AXIS_TREADY <= #100 S_AXIS_TVALID;
                                AXIDMA_S2MM_INTR_IN <= #100 1'b0;                                   
                            end
                        default:
                            begin
                                invalid_process_count = 0;
                                dma_process_count = 0;                            
                                M_AXIS_TREADY <= #100 1'b0;
                                AXIDMA_S2MM_INTR_IN <= #100 1'b0;                                   
                            end                        
                    endcase
                end
            end
        join
    endtask


    parameter integer SAMPLE_NUM = 512;
    int sample_frame_length[SAMPLE_NUM];
    dataframe_line_t sample_frame[SAMPLE_NUM];

    enum integer {
        INTITIALIZE,
        RESET_ALL,
        SEQUENCIAL_SENDING_TEST,
        RANDOM_SENDING_TEST
    } test_status;
    
    initial begin
        int tmp_random_frame_len;
        $dumpfile("axi_dma_connector_tb.vcd");
        $dumpvars(0, axi_dma_connector_tb);
        test_status = INTITIALIZE;
        reset_all;

        fork
            begin
                $display("TEST START: sequencial sending test start");
                test_status = SEQUENCIAL_SENDING_TEST;
                for (int i=0; i<SAMPLE_NUM; i++) begin
                    sample_frame[i] = generateFrame((i%4+1)*2);
                    sample_frame_length[i] = (i%4+1)*2;
                end
                sample_send(sample_frame, SAMPLE_NUM, sample_frame_length);
                $display("TEST PASSED: sequencial sending test passed!");  
                $display("TEST START: random frame length sending test start");
                test_status = RANDOM_SENDING_TEST;
                for (int i=0; i<SAMPLE_NUM; i++) begin
                    tmp_random_frame_len = $urandom_range(1, 4)*2;
                    sample_frame[i] = generateFrame(tmp_random_frame_len);
                    sample_frame_length[i] = tmp_random_frame_len;
                end                
                sample_send(sample_frame, SAMPLE_NUM, sample_frame_length);
                $display("TEST PASSED: random frame length sending test passed!");
            end
            begin
                dummy_axi_dma(10, 20);
            end
        join_any
        
        for (int i=0; i<SAMPLE_NUM; i++) begin
            tmp_random_frame_len = $urandom_range(1, 4)*2;
            sample_frame[i] = generateFrame(tmp_random_frame_len);
            sample_frame_length[i] = tmp_random_frame_len;
        end
        $finish;
    end

    initial begin
        ACLK = 0;
        forever #(ACLK_PERIOD/2)  ACLK = ~ACLK;       
    end

endmodule