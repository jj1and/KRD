`timescale 1 ps / 1 ps
module DataParallelizer #(
  parameter integer DIN_WIDTH = 128
)(
  input wire CLK,
  input wire RESET,

  input wire iVALID,
  output wire oREADY,
  input wire [DIN_WIDTH-1:0] DIN,

  output wire oVALID,
  output wire [DIN_WIDTH*2-1:0] DOUT
);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth);
    begin
      for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
        bit_depth = bit_depth >> 1;
    end
  endfunction

    localparam integer DOUT_WIDTH = DIN_WIDTH*2;
    localparam integer CLK_DIFF = 2;

  reg [(DIN_WIDTH+1)*2-1:0] doutD;
  reg [DOUT_WIDTH-1:0] dout;

  reg ovalid;

  reg data_count;
  reg data_count_delay;

  wire data_en = (data_count_delay==1'b1);

  assign oREADY = !RESET;
  assign oVALID = ovalid;
  assign DOUT = dout;


  always @(posedge CLK ) begin
    if (~&{!RESET, iVALID}) begin
      data_count <= #400 1'b0;
    end else begin
      if (data_count==1'b1) begin
        data_count <= #400 1'b0;
      end else begin
        data_count <= #400 1'b1;
      end
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      data_count_delay <= #400 1'b0;
    end else begin
      data_count_delay <= #400 data_count;
    end
  end  

  always @(posedge CLK ) begin
    if (RESET) begin
      doutD <= #400 {DOUT_WIDTH{1'b1}};
    end else begin
      doutD[(DIN_WIDTH+1)*data_count +:DIN_WIDTH+1] <= #400 {iVALID, DIN};
    end
  end


   

  always @(posedge CLK ) begin
    if (RESET) begin
      ovalid <= #400 1'b0;
      dout <= #400 {DOUT_WIDTH{1'b1}};
    end else begin
      ovalid <= #400 (&{doutD[(DIN_WIDTH+1)*2-1 -:1], doutD[DIN_WIDTH +:1]})&(data_count_delay);
      dout <= #400 {doutD[DIN_WIDTH+1 +:DIN_WIDTH], doutD[0 +:DIN_WIDTH]};      
    end
  end

endmodule