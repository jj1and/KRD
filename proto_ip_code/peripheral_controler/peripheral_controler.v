	/* This module is based on Xilinx AXI peripheral IP preset */
	`timescale 1 ps / 1 ps

	module peripheral_controler # (
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of ID for for write address, write data, read address and read data
		parameter integer C_S_AXI_ID_WIDTH	= 1,
		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 32,
		// Width of optional user defined signal in write address channel
		parameter integer C_S_AXI_AWUSER_WIDTH	= 0,
		// Width of optional user defined signal in read address channel
		parameter integer C_S_AXI_ARUSER_WIDTH	= 0,
		// Width of optional user defined signal in write data channel
		parameter integer C_S_AXI_WUSER_WIDTH	= 0,
		// Width of optional user defined signal in read data channel
		parameter integer C_S_AXI_RUSER_WIDTH	= 0,
		// Width of optional user defined signal in write response channel
		parameter integer C_S_AXI_BUSER_WIDTH	= 0
	)(
		// Users to add ports here
        output wire CDCI6214_EEPROM_SEL,
        output wire CDCI6214_OE,
        output wire CDCI6214_REF_SEL,
        output wire CDCI6214_OPMODE,
        input wire CDCI6214_STATUS,
        
        input wire [3:0] GPI,
        output wire [3:0] GPO,
        
        output wire [7:0] LADC_CTRL1,
        output [7:0] LADC_CTRL2,
        output LADC_OPMODE,
        output [7:0] LADC_SEN,

        input wire SFP1_MOD_ABS,
        output wire SFP1_RS0,
        output wire SFP1_RS1,
        input wire SFP1_RX_LOS,
        output wire SFP1_TX_DISABLE,
        input wire SFP1_TX_FAULT,
        
        input wire SFP2_MOD_ABS,
        output wire SFP2_RS0,
        output wire SFP2_RS1,
        input wire SFP2_RX_LOS,
        output wire SFP2_TX_DISABLE,
        input wire SFP2_TX_FAULT,                     

		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write Address ID
		input wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_AWID,
		// Write address
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		input wire [7 : 0] S_AXI_AWLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		input wire [2 : 0] S_AXI_AWSIZE,
		// Burst type. The burst type and the size information, 
		// determine how the address for each transfer within the burst is calculated.
		input wire [1 : 0] S_AXI_AWBURST,
		// Lock type. Provides additional information about the
		// atomic characteristics of the transfer.
		input wire  S_AXI_AWLOCK,
		// Memory type. This signal indicates how transactions
		// are required to progress through a system.
		input wire [3 : 0] S_AXI_AWCACHE,
		// Protection type. This signal indicates the privilege
		// and security level of the transaction, and whether
		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Quality of Service, QoS identifier sent for each
		// write transaction.
		input wire [3 : 0] S_AXI_AWQOS,
		// Region identifier. Permits a single physical interface
		// on a slave to be used for multiple logical interfaces.
		input wire [3 : 0] S_AXI_AWREGION,
		// Optional User-defined signal in the write address channel.
		input wire [C_S_AXI_AWUSER_WIDTH-1 : 0] S_AXI_AWUSER,
		// Write address valid. This signal indicates that
		// the channel is signaling valid write address and
		// control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that
		// the slave is ready to accept an address and associated
		// control signals.
		output wire  S_AXI_AWREADY,
		// Write Data
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte
		// lanes hold valid data. There is one write strobe
		// bit for each eight bits of the write data bus.
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write last. This signal indicates the last transfer
		// in a write burst.
		input wire  S_AXI_WLAST,
		// Optional User-defined signal in the write data channel.
		input wire [C_S_AXI_WUSER_WIDTH-1 : 0] S_AXI_WUSER,
		// Write valid. This signal indicates that valid write
		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Response ID tag. This signal is the ID tag of the
		// write response.
		output wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_BID,
		// Write response. This signal indicates the status
		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Optional User-defined signal in the write response channel.
		output wire [C_S_AXI_BUSER_WIDTH-1 : 0] S_AXI_BUSER,
		// Write response valid. This signal indicates that the
		// channel is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address ID. This signal is the identification
		// tag for the read address group of signals.
		input wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_ARID,
		// Read address. This signal indicates the initial
		// address of a read burst transaction.
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		input wire [7 : 0] S_AXI_ARLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		input wire [2 : 0] S_AXI_ARSIZE,
		// Burst type. The burst type and the size information, 
		// determine how the address for each transfer within the burst is calculated.
		input wire [1 : 0] S_AXI_ARBURST,
		// Lock type. Provides additional information about the
		// atomic characteristics of the transfer.
		input wire  S_AXI_ARLOCK,
		// Memory type. This signal indicates how transactions
		// are required to progress through a system.
		input wire [3 : 0] S_AXI_ARCACHE,
		// Protection type. This signal indicates the privilege
		// and security level of the transaction, and whether
		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Quality of Service, QoS identifier sent for each
		// read transaction.
		input wire [3 : 0] S_AXI_ARQOS,
		// Region identifier. Permits a single physical interface
		// on a slave to be used for multiple logical interfaces.
		input wire [3 : 0] S_AXI_ARREGION,
		// Optional User-defined signal in the read address channel.
		input wire [C_S_AXI_ARUSER_WIDTH-1 : 0] S_AXI_ARUSER,
		// Write address valid. This signal indicates that
		// the channel is signaling valid read address and
		// control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that
		// the slave is ready to accept an address and associated
		// control signals.
		output wire  S_AXI_ARREADY,
		// Read ID tag. This signal is the identification tag
		// for the read data group of signals generated by the slave.
		output wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_RID,
		// Read Data
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of
		// the read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read last. This signal indicates the last transfer
		// in a read burst.
		output wire  S_AXI_RLAST,
		// Optional User-defined signal in the read address channel.
		output wire [C_S_AXI_RUSER_WIDTH-1 : 0] S_AXI_RUSER,
		// Read valid. This signal indicates that the channel
		// is signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
		// accept the read data and response information.
		input wire  S_AXI_RREADY
	);

	// AXI4FULL signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg [C_S_AXI_BUSER_WIDTH-1 : 0] 	axi_buser;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	wire [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rlast;
	reg [C_S_AXI_RUSER_WIDTH-1 : 0] 	axi_ruser;
	reg  	axi_rvalid;
	// aw_wrap_en determines wrap boundary and enables wrapping
	wire aw_wrap_en;
	// ar_wrap_en determines wrap boundary and enables wrapping
	wire ar_wrap_en;
	// aw_wrap_size is the size of the write transfer, the
	// write address wraps to a lower address if upper address
	// limit is reached
	wire [31:0]  aw_wrap_size ; 
	// ar_wrap_size is the size of the read transfer, the
	// read address wraps to a lower address if upper address
	// limit is reached
	wire [31:0]  ar_wrap_size ; 
	// The axi_awv_awr_flag flag marks the presence of write address valid
	reg axi_awv_awr_flag;
	//The axi_arv_arr_flag flag marks the presence of read address valid
	reg axi_arv_arr_flag; 
	// The axi_awlen_cntr internal write address counter to keep track of beats in a burst transaction
	reg [7:0] axi_awlen_cntr;
	//The axi_arlen_cntr internal read address counter to keep track of beats in a burst transaction
	reg [7:0] axi_arlen_cntr;
	reg [1:0] axi_arburst;
	reg [1:0] axi_awburst;
	reg [7:0] axi_arlen;
	reg [7:0] axi_awlen;
	//local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	//ADDR_LSB is used for addressing 32/64 bit registers/memories
	//ADDR_LSB = 2 for 32 bits (n downto 2) 
	//ADDR_LSB = 3 for 42 bits (n downto 3)

    localparam integer REGSTER_NUM = 8;
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32)+ 1;
	localparam integer OPT_MEM_ADDR_BITS = $clog2(REGSTER_NUM)-1;
	// localparam integer USER_NUM_MEM = 1;
	//----------------------------------------------
	//-- Signals for user logic memory space example
	//------------------------------------------------
	wire [OPT_MEM_ADDR_BITS:0] mem_address;
	// wire [USER_NUM_MEM-1:0] mem_select;
	// reg [C_S_AXI_DATA_WIDTH-1:0] mem_data_out[0 : USER_NUM_MEM-1];

	// genvar i;
	// genvar mem_byte_index;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BUSER	= axi_buser;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RLAST	= axi_rlast;
	assign S_AXI_RUSER	= axi_ruser;
	assign S_AXI_RVALID	= axi_rvalid;
	assign S_AXI_BID = S_AXI_AWID;
	assign S_AXI_RID = S_AXI_ARID;
	assign  aw_wrap_size = (C_S_AXI_DATA_WIDTH/8 * (axi_awlen)); 
	assign  ar_wrap_size = (C_S_AXI_DATA_WIDTH/8 * (axi_arlen)); 
	assign  aw_wrap_en = ((axi_awaddr & aw_wrap_size) == aw_wrap_size)? 1'b1: 1'b0;
	assign  ar_wrap_en = ((axi_araddr & ar_wrap_size) == ar_wrap_size)? 1'b1: 1'b0;

	// Implement axi_awready generation

	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_awready <= #100 1'b0;
		end else begin    
			if (~axi_awready && S_AXI_AWVALID && ~axi_awv_awr_flag && ~axi_arv_arr_flag) begin
				// slave is ready to accept an address and
				// associated control signals
				axi_awready <= #100 1'b1;
				// used for generation of bresp() and bvalid
			end else begin
				// preparing to accept next address after current write burst tx completion
				if (S_AXI_WLAST && axi_wready) begin
					axi_awready <= #100 axi_awready;
				end else begin
					axi_awready <= #100 1'b0;
				end
			end
		end 
	end

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_awv_awr_flag <= #100 1'b0;
		end else begin    
			if (~axi_awready && S_AXI_AWVALID && ~axi_awv_awr_flag && ~axi_arv_arr_flag) begin
				// slave is ready to accept an address and
				// associated control signals
				axi_awv_awr_flag  <= #100 1'b1; 
				// used for generation of bresp() and bvalid
			end else begin
				// preparing to accept next address after current write burst tx completion
				if (S_AXI_WLAST && axi_wready) begin
					axi_awv_awr_flag <= #100 1'b0;
				end else begin
					axi_awv_awr_flag <= #100 axi_awv_awr_flag;
				end
			end
		end 
	end 	      
	// Implement axi_awaddr latching

	// This process is used to latch the address when both 
	// S_AXI_AWVALID and S_AXI_WVALID are valid.

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_awburst <= #100 0;
			axi_awlen <= #100 0;
		end else begin    
			if (~axi_awready && S_AXI_AWVALID && ~axi_awv_awr_flag) begin
				// address latching 
				axi_awburst <= #100 S_AXI_AWBURST; 
				axi_awlen <= #100 S_AXI_AWLEN;     
				// start address of transfer
			end else begin
				axi_awburst <= #100 axi_awburst;
				axi_awlen <= #100 axi_awlen;					          
			end
		end 
	end  	

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_awlen_cntr <= #100 0;
		end else begin    
			if (~axi_awready && S_AXI_AWVALID && ~axi_awv_awr_flag) begin
				// address latching   
				// start address of transfer
				axi_awlen_cntr <= #100 0;
			end else begin
				if((axi_awlen_cntr <= axi_awlen) && axi_wready && S_AXI_WVALID) begin
					axi_awlen_cntr <= #100 axi_awlen_cntr + 1;
				end else begin
					axi_awlen_cntr <= #100 axi_awlen_cntr;			
				end              
			end
		end 
	end 

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_awaddr <= #100 0;
		end else begin    
			if (~axi_awready && S_AXI_AWVALID && ~axi_awv_awr_flag) begin
				// address latching 
				axi_awaddr <= #100 S_AXI_AWADDR[C_S_AXI_ADDR_WIDTH - 1:0];   
				// start address of transfer
			end else begin
				if((axi_awlen_cntr <= axi_awlen) && axi_wready && S_AXI_WVALID) begin
					case (axi_awburst)
						2'b00: // fixed burst
						// The write address for all the beats in the transaction are fixed
							begin
								axi_awaddr <= #100 axi_awaddr;          
								//for awsize = 4 bytes (010)
							end   
						2'b01: //incremental burst
						// The write address for all the beats in the transaction are increments by awsize
							begin
								axi_awaddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] <= #100 axi_awaddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
								//awaddr aligned to 4 byte boundary
								axi_awaddr[ADDR_LSB-1:0]  <= #100 {ADDR_LSB{1'b0}};   
								//for awsize = 4 bytes (010)
							end   
						2'b10: //Wrapping burst
						// The write address wraps when the address reaches wrap boundary 
							if (aw_wrap_en) begin
								axi_awaddr <= #100 (axi_awaddr - aw_wrap_size); 
							end else begin
								axi_awaddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] <= #100 axi_awaddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
								axi_awaddr[ADDR_LSB-1:0]  <= #100 {ADDR_LSB{1'b0}}; 
							end                      
						default: //reserved (incremental burst for example)
							begin
								axi_awaddr <= #100 axi_awaddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
								//for awsize = 4 bytes (010)
							end
					endcase
				end else begin
					axi_awaddr <= #100 axi_awaddr;				
				end              
			end
		end 
	end       
	// Implement axi_wready generation

	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	// de-asserted when reset is low. 

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_wready <= #100 1'b0;
		end else begin    
			if ( ~axi_wready && S_AXI_WVALID && axi_awv_awr_flag) begin
				// slave can accept the write data
				axi_wready <= #100 1'b1;
			end else begin
				//if (~axi_awv_awr_flag)
				if (S_AXI_WLAST && axi_wready) begin
					axi_wready <= #100 1'b0;
				end else begin
					axi_wready <= #100 axi_wready;
				end
			end
		end 
	end       
	// Implement write response logic generation

	// The write response and response valid signals are asserted by the slave 
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	// This marks the acceptance of address and indicates the status of 
	// write transaction.

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_bvalid <= #100 1'b0;
		end else begin    
			if (axi_awv_awr_flag && axi_wready && S_AXI_WVALID && ~axi_bvalid && S_AXI_WLAST ) begin
				axi_bvalid <= #100 1'b1;					 
				// 'OKAY' response 
			end else begin
				if (S_AXI_BREADY && axi_bvalid) begin
				//check if bready is asserted while bvalid is high) 
				//(there is a possibility that bready is always asserted high)   
					axi_bvalid <= #100 1'b0;					 
				end else begin
					axi_bvalid <= #100 axi_bvalid;				
				end  
			end
		end
	end

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_bresp <= #100 2'b0;
		end else begin    
			if (axi_awv_awr_flag && axi_wready && S_AXI_WVALID && ~axi_bvalid && S_AXI_WLAST ) begin
				axi_bresp  <= #100 2'b0;					 
				// 'OKAY' response 
			end else begin
				axi_bresp <= #100 axi_bresp;
			end
		end
	end

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_buser <= #100 0;
		end else begin    
			axi_buser <= #100 axi_buser;						 
		end
	end   		   	   
	// Implement axi_arready generation

	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is 
	// de-asserted when reset (active low) is asserted. 
	// The read address is also latched when S_AXI_ARVALID is 
	// asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_arready <= #100 1'b0;
		end else begin    
			if (~axi_arready && S_AXI_ARVALID && ~axi_awv_awr_flag && ~axi_arv_arr_flag) begin
				axi_arready <= #100 1'b1;
			end else begin 
				if (axi_rvalid && S_AXI_RREADY && axi_arlen_cntr == axi_arlen) begin
					// preparing to accept next address after current read completion
					axi_arready <= #100 axi_arready;
				end else begin
					axi_arready <= #100 1'b0;
				end
			end
		end 
	end

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_arv_arr_flag <= #100 1'b0;
		end else begin    
			if (~axi_arready && S_AXI_ARVALID && ~axi_awv_awr_flag && ~axi_arv_arr_flag) begin
				axi_arv_arr_flag <= #100 1'b1;
			end else begin 
				if (axi_rvalid && S_AXI_RREADY && axi_arlen_cntr == axi_arlen) begin
					// preparing to accept next address after current read completion
					axi_arv_arr_flag  <= #100 1'b0;
				end else begin
					axi_arv_arr_flag <= #100 axi_arv_arr_flag;
				end
			end
		end 
	end     	       
	// Implement axi_araddr latching

	//This process is used to latch the address when both 
	//S_AXI_ARVALID and S_AXI_RVALID are valid.
	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_ruser <= #100 0;
		end else begin
			axi_ruser <= #100 axi_ruser;
		end
	end

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_arburst <= #100 0;
			axi_arlen <= #100 0;
		end else begin    
			if (~axi_arready && S_AXI_ARVALID && ~axi_arv_arr_flag) begin
				// address latching  
				axi_arburst <= #100 S_AXI_ARBURST; 
				axi_arlen <= #100 S_AXI_ARLEN;     
				// start address of transfer
			end else begin
				axi_arburst <= #100 axi_arburst; 
				axi_arlen <= #100 axi_arlen;    				
			end
		end 
	end

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_arlen_cntr <= #100 0;
		end else begin    
			if (~axi_arready && S_AXI_ARVALID && ~axi_arv_arr_flag) begin
				// address latching  
				// start address of transfer
				axi_arlen_cntr <= #100 0;
			end else begin
				if((axi_arlen_cntr <= axi_arlen) && axi_rvalid && S_AXI_RREADY) begin					
					axi_arlen_cntr <= #100 axi_arlen_cntr + 1;
				end else begin 
					axi_arlen_cntr <= #100 axi_arlen_cntr;
				end
			end    
		end 
	end

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_araddr <= #100 0;
		end else begin    
			if (~axi_arready && S_AXI_ARVALID && ~axi_arv_arr_flag) begin
				// address latching 
				axi_araddr <= #100 S_AXI_ARADDR[C_S_AXI_ADDR_WIDTH - 1:0];  
				// start address of transfer
			end else begin
				if((axi_arlen_cntr <= axi_arlen) && axi_rvalid && S_AXI_RREADY) begin
					case (axi_arburst)
						2'b00: // fixed burst
							// The read address for all the beats in the transaction are fixed
							begin
								axi_araddr <= #100 axi_araddr;        
								//for arsize = 4 bytes (010)
							end   
						2'b01: //incremental burst
							// The read address for all the beats in the transaction are increments by awsize
							begin
								axi_araddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] <= #100 axi_araddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1; 
								//araddr aligned to 4 byte boundary
								axi_araddr[ADDR_LSB-1:0]  <= #100 {ADDR_LSB{1'b0}};   
								//for awsize = 4 bytes (010)
							end   
						2'b10: //Wrapping burst
							begin
								// The read address wraps when the address reaches wrap boundary 
								if (ar_wrap_en) begin
									axi_araddr <= #100 (axi_araddr - ar_wrap_size); 
								end	else begin
									axi_araddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] <= #100 axi_araddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1; 
									//araddr aligned to 4 byte boundary
									axi_araddr[ADDR_LSB-1:0]  <= #100 {ADDR_LSB{1'b0}};   
								end
							end                      
						default: //reserved (incremental burst for example)
							begin
								axi_araddr <= #100 axi_araddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB]+1;
								//for arsize = 4 bytes (010)
							end
					endcase              
				end else begin 
					axi_araddr <= #100 axi_araddr;
				end
			end    
		end 
	end

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_rlast <= #100 1'b0;
		end else begin    
			if (~axi_arready && S_AXI_ARVALID && ~axi_arv_arr_flag) begin
				// address latching 
				// start address of transfer
				axi_rlast <= #100 1'b0;
			end else begin
				if((axi_arlen_cntr <= axi_arlen) && axi_rvalid && S_AXI_RREADY) begin
					axi_rlast <= #100 1'b0;
				end else begin 
					if((axi_arlen_cntr == axi_arlen) && ~axi_rlast && axi_arv_arr_flag ) begin
						axi_rlast <= #100 1'b1;
					end else begin 
						if (S_AXI_RREADY) begin
							axi_rlast <= #100 1'b0;
						end else begin
							axi_rlast <= #100 axi_rlast;
						end
					end
				end
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

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_rvalid <= #100 0;
		end else begin    
			if (axi_arv_arr_flag && ~axi_rvalid) begin
				axi_rvalid <= #100 1'b1;
				// 'OKAY' response
			end else begin
				if (axi_rvalid && S_AXI_RREADY) begin
					axi_rvalid <= #100 1'b0;
				end
			end            
		end
	end

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_rresp  <= #100 0;
		end else begin    
			if (axi_arv_arr_flag && ~axi_rvalid) begin
				axi_rresp  <= #100 2'b0; 
				// 'OKAY' response
			end else begin
				axi_rresp <= #100 axi_rresp;
			end            
		end
	end

	assign mem_address = axi_arv_arr_flag ? 
							axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] : 
							(axi_awv_awr_flag ? axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS : ADDR_LSB] :	0 );   

	// Add user logic here

	reg [C_S_AXI_DATA_WIDTH-1:0] option_reg[REGSTER_NUM-1:0];
	/* register map
		option_reg[0] = {27'b0, EEPROM_SEL, RESETN, OE, STATUS, REF_SEL} // CDCI6214 reg
		option_reg[1] = {28'b0, GPO} // GPO reg, output only
		option_reg[2] = {28'b0, GPI} // GPI reg, input only
		option_reg[3] = {16'b0, CTRL2, CTRL1} // LADC control reg
		option_reg[4] = {31'b0, RESET} // LADC common reset reg
        option_reg[5] = {24'b0, SEN} // LADC send reg
        option_reg[6] = {26'b0, RS0, RS1, RX_LOS, MOD_ABS, TX_DISABLE, TX_FAULT} // SFP1 gpio reg
        option_reg[7] = {26'b0, RS0, RS1, RX_LOS, MOD_ABS, TX_DISABLE, TX_FAULT} // SFP2 gpio reg
	 */

	wire reg_wen = &{axi_wready, S_AXI_WVALID};

	reg [4:0] DEFAULT_CDCI6214_CONFIG = {1'b0, 1'b1, 1'b1, 1'b1, 1'b0};
    reg [3:0] DEFAULT_GPO = 4'b0000;
    reg [15:0] DEFAULT_LADC_CTRL = {8'b0, 8'b0};
    reg DEFAULT_LADC_OPMODE = 1'b0;
    reg [7:0] DEFAULT_LADC_SEN = 8'b00000001;
    reg [5:0] DEFAULT_SFP1_CONFIG = {1'b0, 1'b0, 2'b00, 1'b0, 1'b0};
    reg [5:0] DEFAULT_SFP2_CONFIG = {1'b0, 1'b0, 2'b00, 1'b0, 1'b0};

	always @(posedge S_AXI_ACLK ) begin
		if (!S_AXI_ARESETN) begin
			option_reg[0][C_S_AXI_DATA_WIDTH-1 -: 27] <= #100 27'b0;
            option_reg[1][C_S_AXI_DATA_WIDTH-1 -: 28] <= #100 28'b0;
            option_reg[2][C_S_AXI_DATA_WIDTH-1 -: 28] <= #100 28'b0;
            option_reg[3][C_S_AXI_DATA_WIDTH-1 -: 16] <= #100 16'b0;
            option_reg[4][C_S_AXI_DATA_WIDTH-1 -: 31] <= #100 31'b0;
            option_reg[5][C_S_AXI_DATA_WIDTH-1 -: 24] <= #100 24'b0;
            option_reg[6][C_S_AXI_DATA_WIDTH-1 -: 26] <= #100 26'b0;
            option_reg[7][C_S_AXI_DATA_WIDTH-1 -: 26] <= #100 26'b0;
		end else begin
			option_reg[0][C_S_AXI_DATA_WIDTH-1 -: 27] <= #100 option_reg[0][C_S_AXI_DATA_WIDTH-1 -: 27];
            option_reg[1][C_S_AXI_DATA_WIDTH-1 -: 28] <= #100 option_reg[1][C_S_AXI_DATA_WIDTH-1 -: 28];
            option_reg[2][C_S_AXI_DATA_WIDTH-1 -: 28] <= #100 option_reg[2][C_S_AXI_DATA_WIDTH-1 -: 28];
            option_reg[3][C_S_AXI_DATA_WIDTH-1 -: 16] <= #100 option_reg[3][C_S_AXI_DATA_WIDTH-1 -: 16];
            option_reg[4][C_S_AXI_DATA_WIDTH-1 -: 31] <= #100 option_reg[4][C_S_AXI_DATA_WIDTH-1 -: 31];
            option_reg[5][C_S_AXI_DATA_WIDTH-1 -: 24] <= #100 option_reg[5][C_S_AXI_DATA_WIDTH-1 -: 24];
            option_reg[6][C_S_AXI_DATA_WIDTH-1 -: 26] <= #100 option_reg[6][C_S_AXI_DATA_WIDTH-1 -: 26];
            option_reg[7][C_S_AXI_DATA_WIDTH-1 -: 26] <= #100 option_reg[7][C_S_AXI_DATA_WIDTH-1 -: 26];
		end
	end


    // CDCI6214 configration
	always @(posedge S_AXI_ACLK ) begin
		if (!S_AXI_ARESETN) begin
			option_reg[0][4] <= #100 DEFAULT_CDCI6214_CONFIG[4];
			option_reg[0][2:0] <= #100 {DEFAULT_CDCI6214_CONFIG[2], CDCI6214_STATUS, DEFAULT_CDCI6214_CONFIG[0]};
		end else begin
			if (&{reg_wen, S_AXI_WSTRB[0], mem_address==0}) begin
				option_reg[0][4] <= #100 S_AXI_WDATA[4];
				option_reg[0][2:0] <= #100 {S_AXI_WDATA[2], CDCI6214_STATUS, S_AXI_WDATA[0]};
			end else begin
				option_reg[0][4] <= #100 option_reg[0][4];
				option_reg[0][2:0] <= #100 {option_reg[0][2], CDCI6214_STATUS, option_reg[0][0]};
			end
		end
	end

	always @(posedge S_AXI_ACLK ) begin
		option_reg[0][3] <= #100 DEFAULT_CDCI6214_CONFIG[3];
	end


	assign CDCI6214_EEPROM_SEL = option_reg[0][4];
    // assign CDCI6214_OPMODE = option_reg[0][3];
    assign CDCI6214_OPMODE = 1'b1;
    assign CDCI6214_OE = option_reg[0][2];
    assign CDCI6214_REF_SEL = option_reg[0][0];


    // GPO configration
	always @(posedge S_AXI_ACLK ) begin
		if (!S_AXI_ARESETN) begin
			option_reg[1][0 +:4] <= #100 DEFAULT_GPO;
		end else begin
			if (&{reg_wen, S_AXI_WSTRB[0], mem_address==1}) begin
				option_reg[1][0 +:4] <= #100 S_AXI_WDATA[3:0];
			end else begin
				option_reg[1][0 +:4] <= #100 option_reg[1][0 +:4];
			end
		end
	end
	assign GPO = option_reg[1][3:0];

    // apply GPI input
    always @(posedge S_AXI_ACLK ) begin
        option_reg[2][3:0] <= #100 GPI;
    end

    // LADC CTRL configration
	always @(posedge S_AXI_ACLK ) begin
		if (!S_AXI_ARESETN) begin
			option_reg[3][0 +:16] <= #100 DEFAULT_LADC_CTRL;
		end else begin
			if (&{reg_wen, S_AXI_WSTRB[1:0], mem_address==3}) begin
				option_reg[3][0 +:16] <= #100 S_AXI_WDATA[15:0];
			end else begin
				option_reg[3][0 +:16] <= #100 option_reg[3][0 +:16];
			end
		end
	end
	assign LADC_CTRL1 = option_reg[3][7:0];
    assign LADC_CTRL2 = option_reg[3][15:8];

    // LADC RESET configration
    reg startup_init;
	always @(posedge S_AXI_ACLK ) begin
		if (!S_AXI_ARESETN) begin
			option_reg[4][0] <= #100 1'b1;
            startup_init <= #100 1'b1;
		end else begin
            if (startup_init) begin
                option_reg[4][0] <= #100 DEFAULT_LADC_OPMODE;
                startup_init <= #100 1'b0;
            end else begin
                if (&{reg_wen, S_AXI_WSTRB[0], mem_address==4}) begin
                    option_reg[4][0] <= #100 S_AXI_WDATA[0];
                    startup_init <= #100 1'b0;
                end else begin
                    option_reg[4][0] <= #100 option_reg[4][0];
                    startup_init <= #100 1'b0;
                end                
            end
		end
	end
	assign LADC_OPMODE = option_reg[4][0];

    // LADC SEN configration
	always @(posedge S_AXI_ACLK ) begin
		if (!S_AXI_ARESETN) begin
			option_reg[5][0 +:8] <= #100 DEFAULT_LADC_SEN;
		end else begin
			if (&{reg_wen, S_AXI_WSTRB[0], mem_address==5}) begin
				option_reg[5][0 +:8] <= #100 S_AXI_WDATA[7:0];
			end else begin
				option_reg[5][0 +:8] <= #100 option_reg[5][0 +:8];
			end
		end
	end
	assign LADC_SEN = option_reg[5][7:0];

    // SFP1 configration
	always @(posedge S_AXI_ACLK ) begin
		if (!S_AXI_ARESETN) begin
			option_reg[6][0 +:6] <= #100 {DEFAULT_SFP1_CONFIG[5:4], SFP1_RX_LOS, SFP1_MOD_ABS, DEFAULT_SFP1_CONFIG[1], SFP1_TX_FAULT};
		end else begin
			if (&{reg_wen, S_AXI_WSTRB[0], mem_address==6}) begin
				option_reg[6][0 +:6] <= #100 {S_AXI_WDATA[5:4], SFP1_RX_LOS, SFP1_MOD_ABS, S_AXI_WDATA[1], SFP1_TX_FAULT};
			end else begin
				option_reg[6][0 +:6] <= #100 {option_reg[6][5:4], SFP1_RX_LOS, SFP1_MOD_ABS, option_reg[6][1], SFP1_TX_FAULT};
			end
		end
	end
	assign SFP1_RS0 = option_reg[6][5];
    assign SFP1_RS1 = option_reg[6][4];
    assign SFP1_TX_DISABLE = option_reg[6][1];

    // SFP2 configration
	always @(posedge S_AXI_ACLK ) begin
		if (!S_AXI_ARESETN) begin
			option_reg[7][0 +:6] <= #100 {DEFAULT_SFP2_CONFIG[5:4], SFP2_RX_LOS, SFP2_MOD_ABS, DEFAULT_SFP2_CONFIG[1], SFP2_TX_FAULT};
		end else begin
			if (&{reg_wen, S_AXI_WSTRB[0], mem_address==7}) begin
				option_reg[7][0 +:6] <= #100 {S_AXI_WDATA[5:4], SFP2_RX_LOS, SFP2_MOD_ABS, S_AXI_WDATA[1], SFP2_TX_FAULT};
			end else begin
				option_reg[7][0 +:6] <= #100 {option_reg[7][5:4], SFP2_RX_LOS, SFP2_MOD_ABS, option_reg[7][1], SFP2_TX_FAULT};
			end
		end
	end
	assign SFP2_RS0 = option_reg[7][5];
    assign SFP2_RS1 = option_reg[7][4];
    assign SFP2_TX_DISABLE = option_reg[7][1];    

	assign axi_rdata = axi_rvalid ? option_reg[mem_address] : {C_S_AXI_DATA_WIDTH{1'b0}};
	// User logic ends

	endmodule
