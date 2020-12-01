`timescale 1 ps / 1 ps

module control_distributer # (
    parameter integer MAX_PRE_ACQUISITION_LENGTH = 2,
    parameter integer MAX_POST_ACQUISITION_LENGTH = 2
)(
    input wire STOP,
    input wire [2-1:0] ACQUIRE_MODE,
    input wire [4-1:0] TRIGGER_TYPE,
    input wire signed [16-1:0] RISING_EDGE_THRESHOLD,
    input wire signed [16-1:0] FALLING_EDGE_THRESHOLD,
    input wire signed [(12+1)-1:0] H_GAIN_BASELINE,
    input wire signed [16-1:0] L_GAIN_BASELINE,
    input wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH,
    input wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH,

    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD0 STOP" *)
    output wire STOP_MOD0,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD0 ACQUIRE_MODE" *)
    output wire [2-1:0] ACQUIRE_MODE_MOD0,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD0 TRIGGER_TYPE" *)
    output wire [4-1:0] TRIGGER_TYPE_MOD0,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD0 RISING_EDGE_THRESHOLD" *)
    output wire signed [16-1:0] RISING_EDGE_THRESHOLD_MOD0,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD0 FALLING_EDGE_THRESHOLD" *)
    output wire signed [16-1:0] FALLING_EDGE_THRESHOLD_MOD0,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD0 H_GAIN_BASELINE" *)
    output wire signed [(12+1)-1:0] H_GAIN_BASELINE_MOD0,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD0 L_GAIN_BASELINE" *)
    output wire signed [16-1:0] L_GAIN_BASELINE_MOD0,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD0 PRE_ACQUISITION_LENGTH" *)
    output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_MOD0,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD0 POST_ACQUISITION_LENGTH" *)
    output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_MOD0,

    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD1 STOP" *)
    output wire STOP_MOD1,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD1 ACQUIRE_MODE" *)
    output wire [2-1:0] ACQUIRE_MODE_MOD1,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD1 TRIGGER_TYPE" *)
    output wire [4-1:0] TRIGGER_TYPE_MOD1,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD1 RISING_EDGE_THRESHOLD" *)
    output wire signed [16-1:0] RISING_EDGE_THRESHOLD_MOD1,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD1 FALLING_EDGE_THRESHOLD" *)
    output wire signed [16-1:0] FALLING_EDGE_THRESHOLD_MOD1,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD1 H_GAIN_BASELINE" *)
    output wire signed [(12+1)-1:0] H_GAIN_BASELINE_MOD1,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD1 L_GAIN_BASELINE" *)
    output wire signed [16-1:0] L_GAIN_BASELINE_MOD1,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD1 PRE_ACQUISITION_LENGTH" *)
    output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_MOD1,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD1 POST_ACQUISITION_LENGTH" *)
    output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_MOD1,

    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD2 STOP" *)
    output wire STOP_MOD2,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD2 ACQUIRE_MODE" *)
    output wire [2-1:0] ACQUIRE_MODE_MOD2,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD2 TRIGGER_TYPE" *)
    output wire [4-1:0] TRIGGER_TYPE_MOD2,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD2 RISING_EDGE_THRESHOLD" *)
    output wire signed [16-1:0] RISING_EDGE_THRESHOLD_MOD2,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD2 FALLING_EDGE_THRESHOLD" *)
    output wire signed [16-1:0] FALLING_EDGE_THRESHOLD_MOD2,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD2 H_GAIN_BASELINE" *)
    output wire signed [(12+1)-1:0] H_GAIN_BASELINE_MOD2,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD2 L_GAIN_BASELINE" *)
    output wire signed [16-1:0] L_GAIN_BASELINE_MOD2,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD2 PRE_ACQUISITION_LENGTH" *)
    output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_MOD2,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD2 POST_ACQUISITION_LENGTH" *)
    output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_MOD2,

    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD3 STOP" *)
    output wire STOP_MOD3,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD3 ACQUIRE_MODE" *)
    output wire [2-1:0] ACQUIRE_MODE_MOD3,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD3 TRIGGER_TYPE" *)
    output wire [4-1:0] TRIGGER_TYPE_MOD3,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD3 RISING_EDGE_THRESHOLD" *)
    output wire signed [16-1:0] RISING_EDGE_THRESHOLD_MOD3,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD3 FALLING_EDGE_THRESHOLD" *)
    output wire signed [16-1:0] FALLING_EDGE_THRESHOLD_MOD3,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD3 H_GAIN_BASELINE" *)
    output wire signed [(12+1)-1:0] H_GAIN_BASELINE_MOD3,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD3 L_GAIN_BASELINE" *)
    output wire signed [16-1:0] L_GAIN_BASELINE_MOD3,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD3 PRE_ACQUISITION_LENGTH" *)
    output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_MOD3,
    (* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CONTROL_MOD3 POST_ACQUISITION_LENGTH" *)
    output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_MOD3
);
    

    assign STOP = STOP_MOD0;
    assign ACQUIRE_MODE = ACQUIRE_MODE_MOD0;
    assign TRIGGER_TYPE = TRIGGER_TYPE_MOD0;
    assign RISING_EDGE_THRESHOLD = RISING_EDGE_THRESHOLD_MOD0;
    assign FALLING_EDGE_THRESHOLD = FALLING_EDGE_THRESHOLD_MOD0;
    assign H_GAIN_BASELINE = H_GAIN_BASELINE_MOD0;
    assign L_GAIN_BASELINE = L_GAIN_BASELINE_MOD0;
    assign PRE_ACQUISITION_LENGTH = PRE_ACQUISITION_LENGTH_MOD0;
    assign POST_ACQUISITION_LENGTH = POST_ACQUISITION_LENGTH_MOD0;

    assign STOP = STOP_MOD1;
    assign ACQUIRE_MODE = ACQUIRE_MODE_MOD1;
    assign TRIGGER_TYPE = TRIGGER_TYPE_MOD1;
    assign RISING_EDGE_THRESHOLD = RISING_EDGE_THRESHOLD_MOD1;
    assign FALLING_EDGE_THRESHOLD = FALLING_EDGE_THRESHOLD_MOD1;
    assign H_GAIN_BASELINE = H_GAIN_BASELINE_MOD1;
    assign L_GAIN_BASELINE = L_GAIN_BASELINE_MOD1;
    assign PRE_ACQUISITION_LENGTH = PRE_ACQUISITION_LENGTH_MOD1;
    assign POST_ACQUISITION_LENGTH = POST_ACQUISITION_LENGTH_MOD1;

    assign STOP = STOP_MOD2;
    assign ACQUIRE_MODE = ACQUIRE_MODE_MOD2;
    assign TRIGGER_TYPE = TRIGGER_TYPE_MOD2;
    assign RISING_EDGE_THRESHOLD = RISING_EDGE_THRESHOLD_MOD2;
    assign FALLING_EDGE_THRESHOLD = FALLING_EDGE_THRESHOLD_MOD2;
    assign H_GAIN_BASELINE = H_GAIN_BASELINE_MOD2;
    assign L_GAIN_BASELINE = L_GAIN_BASELINE_MOD2;
    assign PRE_ACQUISITION_LENGTH = PRE_ACQUISITION_LENGTH_MOD2;
    assign POST_ACQUISITION_LENGTH = POST_ACQUISITION_LENGTH_MOD2;

    assign STOP = STOP_MOD3;
    assign ACQUIRE_MODE = ACQUIRE_MODE_MOD3;
    assign TRIGGER_TYPE = TRIGGER_TYPE_MOD3;
    assign RISING_EDGE_THRESHOLD = RISING_EDGE_THRESHOLD_MOD3;
    assign FALLING_EDGE_THRESHOLD = FALLING_EDGE_THRESHOLD_MOD3;
    assign H_GAIN_BASELINE = H_GAIN_BASELINE_MOD3;
    assign L_GAIN_BASELINE = L_GAIN_BASELINE_MOD3;
    assign PRE_ACQUISITION_LENGTH = PRE_ACQUISITION_LENGTH_MOD3;
    assign POST_ACQUISITION_LENGTH = POST_ACQUISITION_LENGTH_MOD3;

endmodule

