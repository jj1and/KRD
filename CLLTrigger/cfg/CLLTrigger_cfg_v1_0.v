
`timescale 1 ns / 1 ps

	module CLLTrigger_cfg_v1_0 #
	(
		// Users to add parameters here
		
		// S_AXI_LITE_CFG threshold level data bus width (bit)
        parameter integer C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH = 16,
		// Width of S_AXI threshold level data bus
        parameter integer THRE_LEVEL_WIDTH = 8,
        // S_AXI_LITE_CFG acquisition length data bus width (bit)
        parameter integer C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH = 16,
//        // max proceeding_acquisition length (unit is clock) data bus width
//        parameter integer MAX_PRO_ACQUI_LENGTH_WIDTH = 5,
//        parameter integer MAX_TIMEOUT_LENGTH_WIDTH = 8,
        // BaseLine caluc length (clock) data bus (bit)
        parameter integer BL_CALC_LEN_WIDTH = 8,
        
        // data_width for time counter data bus width (bit)
        parameter integer TIME_COUNTER_WIDTH = 16,

		// User parameters ends
		
		// Do not modify the parameters beyond this line

		// Width of S_AXI trigger status data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 64,
		// Width of S_AXI address bus ( changing upper thre : 0, lower thre :1)
		parameter integer C_S_AXI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here
		
		//trigger state
		input wire [2:0] trg_state,
		// exception assert
		input wire [2:0] err_assert,
		// triggered time stanp
		input wire [TIME_COUNTER_WIDTH-1:0] time_stamp,
				// time counter input
		input wire [TIME_COUNTER_WIDTH-1:0] curr_time,
	   	
		// updated threshold =  { thre_1 (THRE_1_LEVEL_WIDTH bit), thre_2 (THRE_2_LEVEL_WIDTH bit) }
		output wire [C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH-1:0] cfg_new_thre,
		// updated pre/proceeding wait length =  { max_pre_cnt (MAX_PRE_ACQUI_LENGTH_WIDTH bit), max_pro_cnt (MAX_PRO_ACQUI_LENGTH_WIDTH bit), max_out_cnt (MAX_TIMEOUT_LENGTH_WIDTH bit) }
		output wire [C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH-1:0] cfg_new_len,
		// BaseLine calc length
		output wire [BL_CALC_LEN_WIDTH-1:0] bl_calc_len, 
	   	
	   	// inform cfg is updated
	   	output wire cfg_update_flag,
	   	
	   	// check cfg is updated or not
	   	input wire cfg_update_status,

		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH+C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH+C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY
	);

	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	// state of threshold registers [(upper threshold 8bit)+(lower threshold 8bit)+(default upper threshold 8bit)+(default lower threshold 8bit)]
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam integer OPT_MEM_ADDR_BITS = 1;
	// localparam integer ZERO_PAD_WIDTH = C_S_AXI_DATA_WIDTH-(C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH+C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH+TIME_COUNTER_WIDTH+BL_CALC_LEN_WIDTH+3);
	localparam integer ZERO_PAD_WIDTH = C_S_AXI_DATA_WIDTH-(C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH+C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH+TIME_COUNTER_WIDTH+3);
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 4
	reg [C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH-1:0]	new_thre;
	reg [C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH-1:0] new_len;
	reg [C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH-1:0]	def_new_thre;
	reg [C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH-1:0]	def_new_len;
	reg [TIME_COUNTER_WIDTH-1:0] i_curr_time = 0;
//	reg [BL_CALC_LEN_WIDTH-1:0] o_bl_calc_len = 0;
	reg [2:0] i_err_code = 3'b000;
	reg [ZERO_PAD_WIDTH-1:0] zero_pad = 0;
	reg o_cfg_update_flag;
	assign cfg_update_flag = o_cfg_update_flag;
	reg i_cfg_update_check;
	reg i_cfg_update_check_delay;
	
	wire	 slv_reg_rden;
	wire	 slv_reg_wren;
	integer	 byte_index;
	reg	 aw_en;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;
	// Implement axi_awready generation
	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	      aw_en <= 1'b1;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // slave is ready to accept write address when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_awready <= 1'b1;
	          aw_en <= 1'b0;
	        end
	        else if (S_AXI_BREADY && axi_bvalid)
	            begin
	              aw_en <= 1'b1;
	              axi_awready <= 1'b0;
	            end
	      else           
	        begin
	          axi_awready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_awaddr latching
	// This process is used to latch the address when both 
	// S_AXI_AWVALID and S_AXI_WVALID are valid. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // Write Address latching 
	          axi_awaddr <= S_AXI_AWADDR;
	        end
	    end 
	end       

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	// de-asserted when reset is low. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
	        begin
	          // slave is ready to accept write data when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_wready <= 1'b1;
	        end
	      else
	        begin
	          axi_wready <= 1'b0;
	        end
	    end 
	end       

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;
	
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      i_cfg_update_check_delay <= i_cfg_update_check;
          i_cfg_update_check <= cfg_update_status;    
	    end 
	  else 
	    begin
	      i_cfg_update_check_delay <= i_cfg_update_check;
          i_cfg_update_check <= cfg_update_status;
	    end
	end

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
          def_new_thre <= { 8'd5, 8'd100 };
          def_new_len <= { 3'd3, 5'd3, 8'd100 };
          // o_bl_calc_len <= 256;
          o_cfg_update_flag <= 1'b1;        
	    end 
	  else begin
	    if (slv_reg_wren)
	      begin
	        o_cfg_update_flag <= 1'b1;
	        case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	          2'h0:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 0
	                new_thre[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          2'h1:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 1
	                new_len[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end
//	          2'h3:
//	            for ( byte_index = 0; byte_index <= (BL_CALC_LEN_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 1
//	                o_bl_calc_len[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end	             
	          default : begin
	                      new_thre <= def_new_thre;
	                      new_len <= def_new_len;
	                      // o_bl_calc_len <= 256;
	                      def_new_thre <= def_new_thre;
	                      def_new_len <= def_new_len;
	                    end
	        endcase
	        if ( (i_cfg_update_check) & (!i_cfg_update_check_delay) )
	          begin
	            o_cfg_update_flag <= 1'b0;
	          end
	      end
	  end
	end    

	// Implement write response logic generation
	// The write response and response valid signals are asserted by the slave 
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	// This marks the acceptance of address and indicates the status of 
	// write transaction.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
	    end 
	  else
	    begin    
	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
	          // indicates a valid write response is available
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; // 'OKAY' response 
	        end                   // work error responses in future
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid) 
	            //check if bready is asserted while bvalid is high) 
	            //(there is a possibility that bready is always asserted high)   
	            begin
	              axi_bvalid <= 1'b0; 
	            end  
	        end
	    end
	end   

	// Implement axi_arready generation
	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is 
	// de-asserted when reset (active low) is asserted. 
	// The read address is also latched when S_AXI_ARVALID is 
	// asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= 32'b0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR;
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_arvalid generation
	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	// data are available on the axi_rdata bus at this instance. The 
	// assertion of axi_rvalid marks the validity of read data on the 
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	// is deasserted on reset (active low). axi_rresp and axi_rdata are 
	// cleared to zero on reset (active low).  
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end 
	  else
	    begin    
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
	        begin
	          // Valid read data is available at the read data bus
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; // 'OKAY' response
	        end   
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Read data is accepted by the master
	          axi_rvalid <= 1'b0;
	        end                
	    end
	end    

	// Implement memory mapped register select and read logic generation
	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.
	assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;

	// Output register or memory read data
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rdata  <= 0;
	    end 
	  else
	    begin    
	      // When there is a valid read address (S_AXI_ARVALID) with 
	      // acceptance of read address by the slave (axi_arready), 
	      // output the read dada 
	      if (slv_reg_rden)
	        begin
	          i_err_code <= err_assert;
	          i_curr_time <= curr_time;
	          axi_rdata <= {zero_pad, new_thre, new_len, i_curr_time, i_err_code}; // register read data
	          // axi_rdata <= {zero_pad, new_thre, new_len, i_curr_time, o_bl_calc_len, i_err_code};
	        end   
	    end
	end    

	// Add user logic here
	assign cfg_new_len = new_len;
	assign cfg_new_thre = new_thre;
	assign cfg_update_flag = o_cfg_update_flag;

	// User logic ends

	endmodule
