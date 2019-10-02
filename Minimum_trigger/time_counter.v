`timescale 1 ns / 1 ps

module time_counter # (

    // TIME STAMP DATA WIDTH
    parameter integer TIME_STAMP_WIDTH = 16,

    // AXIS_ACLK frequency (Hz)
    parameter integer AXIS_ACLK_FREQ = 500E6,

    // timer resolution freq (HZ )(must be < AXIS_ACLK_FREQ )
    parameter integer TIMER_RESO_FREQ = 100E6 
    
)
(   

    // exec statte
    input wire [1:0] EXEC_STATE,

    // Ports of Axi-stream Bus Interface
    input wire  AXIS_ACLK,
    input wire  AXIS_ARESETN,
    
    // current time
    input wire [TIME_STAMP_WIDTH-1:0] O_CURRENT_TIME
);

    localparam integer MAX_TIME_COUNT = 2^TIME_STAMP_WIDTH-1;
    localparam integer DIVIDE_NUM = AXIS_ACLK_FREQ/TIMER_RESO_FREQ;

    //  exec state
    localparam [1:0] INIT = 2'b00, // ADC < THRESHOLD_VAL
                    TRG = 2'b11; // ADC > THRESHOLD_VAL

    // enable counter
    reg [DIVIDE_NUM-1:0] en_cnt;

    // timer enable
    reg time_en;

    // current time
    reg [TIME_STAMP_WIDTH-1:0] current_time = 0;
    assign O_CURRENT_TIME = current_time;

    // time counter の動作
    always @(posedge AXIS_ACLK )
    begin
        if (!AXIS_ARESETN)
          begin
            current_time <= 1;
          end
        else
          begin
            if (time_en)
              begin
                if (current_time > MAX_TIME_COUNT-1)
                  begin
                    current_time <= 1;
                  end
                else
                  begin
                    if (en_cnt == 0)
                      begin
                        current_time <= current_time + 1;
                      end
                    else
                      begin
                        current_time <= current_time;
                      end
                  end
              end
            else
              begin
                current_time <= 1;
              end
          end
    end

    // en_cnt の動作(clockの分周のようなもの)
    always @(posedge AXIS_ACLK )
    begin
        if (!AXIS_ARESETN)
          begin
            en_cnt <= 0;
          end
        else
          begin
            if (time_en)
              begin
                if (en_cnt>DIVIDE_NUM-1)
                  begin
                    en_cnt <= 0; 
                  end
                else
                  begin
                    en_cnt <= en_cnt + 1;
                  end
              end
            else
              begin
                en_cnt <= en_cnt;
              end
          end
    end

    // time enable の動作
    always @(posedge AXIS_ACLK )
    begin
        if (!AXIS_ARESETN)
          begin
            time_en <= 1'b0;
          end
        else
          begin
            if (EXEC_STATE==INIT)
              begin
                time_en <= 1'b0;
              end
            else
              begin
                time_en <= 1'b1;
              end
          end
    end  





endmodule