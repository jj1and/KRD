`timescale 1ps / 1ps

module variable_shiftreg_delay_tb;

    parameter integer CLK_PERIOD = 8000; // 125MHz
    parameter integer DATA_WIDTH = 16;
    parameter integer MAX_DELAY_LENGTH = 16;

    reg CLK = 0;
    reg  [DATA_WIDTH-1:0] DIN;
    reg [$clog2(MAX_DELAY_LENGTH)-1:0] DELAY;
    wire [DATA_WIDTH-1:0] DOUT;

    variable_shiftreg_delay # (
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_DELAY_LENGTH(MAX_DELAY_LENGTH)
    ) DUT ( 
        .*
    );

    task output_monitor(input logic [DATA_WIDTH-1:0] DIN, input logic [DATA_WIDTH-1:0] DOUT, input [$clog2(MAX_DELAY_LENGTH)-1:0] DELAY);
        bit [DATA_WIDTH-1:0] dynamic_mem[$];
        bit [DATA_WIDTH-1:0] valid_dout;
        while (DELAY<=MAX_DELAY_LENGTH) begin
           @(posedge CLK);
           dynamic_mem.push_back(DIN);
           if (dynamic_mem.size()>DELAY) begin
               valid_dout = dynamic_mem.pop_front();
               if (valid_dout!=DOUT) begin
                   $display("TEST ERROR: Output data is invalid INPUT:%d OUTPUT:%d", valid_dout, DOUT);
               end
           end 
        end
    endtask 


    initial begin
        $dumpfile("variable_shiftreg_delay_tb.vcd");
        $dumpvars(0, variable_shiftreg_delay_tb);
        $display("TEST INFO: beggin test.");
        fork
            begin
                for (int i=1; i<=MAX_DELAY_LENGTH; i++) begin
                    for (int j=0; j<i*2; j++ ) begin
                        @(posedge CLK);
                        DIN <= #100 j;
                        DELAY <= #100 i;
                    end
                end
            end
            begin
                output_monitor(DIN, DOUT, DELAY);
            end
        join
        $display("TEST INFO: TEST PASSED!");
        $finish;
    end

    initial begin
        CLK = 0;
        forever #(CLK_PERIOD/2)  CLK = ~CLK;       
    end

endmodule