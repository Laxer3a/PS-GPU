/* ----------------------------------------------------------------------------------------------------------------------

PS-FPGA Licenses (DUAL License GPLv2 and commercial license)

This PS-FPGA source code is copyright 2019 Romain PIQUOIS and licensed under the GNU General Public License v2.0, 
 and a commercial licensing option.
If you wish to use the source code from PS-FPGA, email laxer3a [at] hotmail [dot] com for commercial licensing.

See LICENSE file.
---------------------------------------------------------------------------------------------------------------------- */

module gpu_stencil_cache
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           stencil_rd_req_i
    ,input  [ 14:0]  stencil_rd_addr_i
    ,input           stencil_wr_req_i
    ,input  [ 14:0]  stencil_wr_addr_i
    ,input  [ 15:0]  stencil_wr_mask_i
    ,input  [ 15:0]  stencil_wr_value_i

    // Outputs
    ,output [ 15:0]  stencil_rd_value_o
	,output			 stencil_error_o
);

wire [7:0]  errU;

wire [2:0]	rID = { stencil_rd_addr_i[7:6]  ,stencil_rd_addr_i[0]   };
wire [11:0] rAdr= { stencil_rd_addr_i[14:8] ,stencil_rd_addr_i[5:1] };
wire [2:0]	wID = { stencil_wr_addr_i[7:6]  ,stencil_wr_addr_i[0]   };
wire [11:0] wAdr= { stencil_wr_addr_i[14:8] ,stencil_wr_addr_i[5:1] };

wire [7:0]  rdU = {	(rID == 3'd7) & stencil_rd_req_i,
					(rID == 3'd6) & stencil_rd_req_i,
					(rID == 3'd5) & stencil_rd_req_i,
					(rID == 3'd4) & stencil_rd_req_i,
					(rID == 3'd3) & stencil_rd_req_i,
					(rID == 3'd2) & stencil_rd_req_i,
					(rID == 3'd1) & stencil_rd_req_i,
					(rID == 3'd0) & stencil_rd_req_i };

wire [7:0]  wrU = {	(wID == 3'd7) & stencil_wr_req_i,
					(wID == 3'd6) & stencil_wr_req_i,
					(wID == 3'd5) & stencil_wr_req_i,
					(wID == 3'd4) & stencil_wr_req_i,
					(wID == 3'd3) & stencil_wr_req_i,
					(wID == 3'd2) & stencil_wr_req_i,
					(wID == 3'd1) & stencil_wr_req_i,
					(wID == 3'd0) & stencil_wr_req_i };

// Last Read ID ---------------
reg [2:0] prev_rd_ID;
always @(posedge clk_i)
	if (stencil_rd_req_i)
		prev_rd_ID <= rID;
// ----------------------------
// Last Write ID ---------------
reg [2:0] prev_wr_ID;
always @(posedge clk_i)
	if (stencil_wr_req_i)
		prev_wr_ID <= wID;
// ----------------------------

// Detect addr clash (well technically no issues :-)
// 
// Each unit send error pin :
// - ERROR Back to back Write operation.
assign stencil_error_o = (|errU);

wire [15:0] rd_data_r0,rd_data_r1,rd_data_r2,rd_data_r3,rd_data_r4,rd_data_r5,rd_data_r6,rd_data_r7;

stencil_cache_ram_8k u_ram0
(
     .clk_i		(clk_i)
    ,.rst_i		(rst_i)

    // Write port
    ,.addr0_i	(wAdr)
    ,.data0_i	(stencil_wr_value_i)
	,.mask0_i	(stencil_wr_mask_i)
    ,.wr0_i		(wrU[0])

    // Read port
	,.rd1_i		(rdU[0])
    ,.addr1_i	(rAdr)
    ,.data1_o	(rd_data_r0)
	,.error_o	(errU[0])
);

stencil_cache_ram_8k u_ram1
(
     .clk_i		(clk_i)
    ,.rst_i		(rst_i)

    // Write port
    ,.addr0_i	(wAdr)
    ,.data0_i	(stencil_wr_value_i)
	,.mask0_i	(stencil_wr_mask_i)
    ,.wr0_i		(wrU[1])

    // Read port
	,.rd1_i		(rdU[1])
    ,.addr1_i	(rAdr)
    ,.data1_o	(rd_data_r1)
	,.error_o	(errU[1])
);

stencil_cache_ram_8k u_ram2
(
     .clk_i		(clk_i)
    ,.rst_i		(rst_i)

    // Write port
    ,.addr0_i	(wAdr)
    ,.data0_i	(stencil_wr_value_i)
	,.mask0_i	(stencil_wr_mask_i)
    ,.wr0_i		(wrU[2])

    // Read port
	,.rd1_i		(rdU[2])
    ,.addr1_i	(rAdr)
    ,.data1_o	(rd_data_r2)
	,.error_o	(errU[2])
);

stencil_cache_ram_8k u_ram3
(
     .clk_i		(clk_i)
    ,.rst_i		(rst_i)

    // Write port
    ,.addr0_i	(wAdr)
    ,.data0_i	(stencil_wr_value_i)
	,.mask0_i	(stencil_wr_mask_i)
    ,.wr0_i		(wrU[3])

    // Read port
	,.rd1_i		(rdU[3])
    ,.addr1_i	(rAdr)
    ,.data1_o	(rd_data_r3)
	,.error_o	(errU[3])
);

stencil_cache_ram_8k u_ram4
(
     .clk_i		(clk_i)
    ,.rst_i		(rst_i)

    // Write port
    ,.addr0_i	(wAdr)
    ,.data0_i	(stencil_wr_value_i)
	,.mask0_i	(stencil_wr_mask_i)
    ,.wr0_i		(wrU[4])

    // Read port
	,.rd1_i		(rdU[4])
    ,.addr1_i	(rAdr)
    ,.data1_o	(rd_data_r4)
	,.error_o	(errU[4])
);

stencil_cache_ram_8k u_ram5
(
     .clk_i		(clk_i)
    ,.rst_i		(rst_i)

    // Write port
    ,.addr0_i	(wAdr)
    ,.data0_i	(stencil_wr_value_i)
	,.mask0_i	(stencil_wr_mask_i)
    ,.wr0_i		(wrU[5])

    // Read port
	,.rd1_i		(rdU[5])
    ,.addr1_i	(rAdr)
    ,.data1_o	(rd_data_r5)
	,.error_o	(errU[5])
);

stencil_cache_ram_8k u_ram6
(
     .clk_i		(clk_i)
    ,.rst_i		(rst_i)

    // Write port
    ,.addr0_i	(wAdr)
    ,.data0_i	(stencil_wr_value_i)
	,.mask0_i	(stencil_wr_mask_i)
    ,.wr0_i		(wrU[6])

    // Read port
	,.rd1_i		(rdU[6])
    ,.addr1_i	(rAdr)
    ,.data1_o	(rd_data_r6)
	,.error_o	(errU[6])
);

stencil_cache_ram_8k u_ram7
(
     .clk_i		(clk_i)
    ,.rst_i		(rst_i)

    // Write port
    ,.addr0_i	(wAdr)
    ,.data0_i	(stencil_wr_value_i)
	,.mask0_i	(stencil_wr_mask_i)
    ,.wr0_i		(wrU[7])

    // Read port
	,.rd1_i		(rdU[7])
    ,.addr1_i	(rAdr)
    ,.data1_o	(rd_data_r7)
	,.error_o	(errU[7])
);

reg [15:0] selOut;
always @(*) begin
	case (prev_rd_ID)
	3'd0 : selOut = rd_data_r0;
	3'd1 : selOut = rd_data_r1;
	3'd2 : selOut = rd_data_r2;
	3'd3 : selOut = rd_data_r3;
	3'd4 : selOut = rd_data_r4;
	3'd5 : selOut = rd_data_r5;
	3'd6 : selOut = rd_data_r6;
	default /*3'd7*/: selOut = rd_data_r7;
	endcase
end

assign stencil_rd_value_o = selOut;

`ifdef verilator
`ifndef LAXER
function write; /* verilator public */
input  [31:0]   addr;
input  [15:0]   data;
reg  [2:0] block;
reg [11:0] addrBlk;
begin
    block   = { addr[7:6]  , addr[0]   };
    addrBlk = { addr[14:8] , addr[5:1] };

    case (block)
    3'd0 : u_ram0.inst_dpRAM_8k.ram[addrBlk] = data;
    3'd1 : u_ram1.inst_dpRAM_8k.ram[addrBlk] = data;
    3'd2 : u_ram2.inst_dpRAM_8k.ram[addrBlk] = data;
    3'd3 : u_ram3.inst_dpRAM_8k.ram[addrBlk] = data;
    3'd4 : u_ram4.inst_dpRAM_8k.ram[addrBlk] = data;
    3'd5 : u_ram5.inst_dpRAM_8k.ram[addrBlk] = data;
    3'd6 : u_ram6.inst_dpRAM_8k.ram[addrBlk] = data;
    3'd7 : u_ram7.inst_dpRAM_8k.ram[addrBlk] = data;
    default : ;
    endcase
end
endfunction
`endif

`ifdef verilator
function [15:0] read; /* verilator public */
input  [14:0]   addr;
reg  [2:0] block;
reg [11:0] addrBlk;
begin
    block   = { addr[7:6]  , addr[0]   };
    addrBlk = { addr[14:8] , addr[5:1] };

    case (block)
    3'd0 : read = u_ram0.inst_dpRAM_8k.ram[addrBlk];
    3'd1 : read = u_ram1.inst_dpRAM_8k.ram[addrBlk];
    3'd2 : read = u_ram2.inst_dpRAM_8k.ram[addrBlk];
    3'd3 : read = u_ram3.inst_dpRAM_8k.ram[addrBlk];
    3'd4 : read = u_ram4.inst_dpRAM_8k.ram[addrBlk];
    3'd5 : read = u_ram5.inst_dpRAM_8k.ram[addrBlk];
    3'd6 : read = u_ram6.inst_dpRAM_8k.ram[addrBlk];
    3'd7 : read = u_ram7.inst_dpRAM_8k.ram[addrBlk];
    default : ;
    endcase
end
endfunction
`endif // [ifndef LAXER] Else fail my visual C++ setup, need to patch manually the C++ generated code each time.
`endif 


endmodule

//-----------------------------------------------------------------
// Dual Port RAM 8KB with write bypass masking features
// Does not support back to back writes (nor should support read while write)
//-----------------------------------------------------------------
module stencil_cache_ram_8k
(
     input           clk_i
    ,input           rst_i

    ,input  [ 11:0]  addr0_i
    ,input  [ 15:0]  data0_i
	,input	[ 15:0]  mask0_i
    ,input           wr0_i
//  ,output [ 15:0]  data0_o

	,input           rd1_i
    ,input  [ 11:0]  addr1_i
    ,output [ 15:0]  data1_o
	,output          error_o
);

// --- Write Signal ---
wire isStraight			= (mask0_i == 16'hFFFF);
wire straight_wr		= isStraight & wr0_i;
reg [11:0] delayedAdr;
reg [15:0] pipeMask,pipeData0;
reg  delayed_wr;
reg  pipeWr;
reg  pipeRd;
always @ (posedge clk_i)
	if (rst_i) begin
		delayed_wr <= 1'b0;
		delayedAdr <= 12'd0;
		pipeMask   <= 16'd0;
		pipeData0  <= 16'd0;
		pipeWr	   <= 0;
		pipeRd	   <= 0;
	end else begin
		pipeWr	   <= wr0_i;
		pipeRd	   <= rd1_i;
		delayed_wr <= (!isStraight & wr0_i);
		pipeMask   <= mask0_i;
		pipeData0  <= data0_i;
		delayedAdr <= addr0_i;
	end
// --------------------

wire [15:0] ram_read0_q;
wire [15:0] feedValue	= delayed_wr ? ((pipeData0 & pipeMask) | (ram_read0_q & ~pipeMask)) : data0_i;
wire [11:0] feedAdr     = delayed_wr ? delayedAdr : addr0_i;

// Synchronous write
wire writeSig = straight_wr | delayed_wr;

doubleport_ram_8k inst_dpRAM_8k
(
     .clk_i		(clk_i)
    ,.rst_i		(rst_i)

    ,.addr0_i	(feedAdr)
    ,.data0_i	(feedValue)
    ,.wr0_i		(writeSig)
    ,.data0_o	(ram_read0_q)

	,.rd1_i		(rd1_i)
    ,.addr1_i	(addr1_i)
    ,.data1_o	(data1_o)
);

// ERROR Back to back Write operation.
// DEPRECATED / COMMENTED OUT => ERROR Read while Write (Straight or Masked).
// TODO : Add rules about wrong usage of Double port memory.
// Proove we should be able to use SINGLE PORT MEMORY.
assign error_o = (pipeWr & wr0_i) /* | (rd1_i & (wr0_i | pipeWr))*/;


endmodule

module doubleport_ram_8k
(
     input           clk_i
    ,input           rst_i

    ,input  [ 11:0]  addr0_i
    ,input  [ 15:0]  data0_i
    ,input           wr0_i
    ,output [ 15:0]  data0_o

	,input           rd1_i
    ,input  [ 11:0]  addr1_i
    ,output [ 15:0]  data1_o
);

/* verilator lint_off MULTIDRIVEN */
reg [15:0]   ram [4095:0] /*verilator public*/;
/* verilator lint_on MULTIDRIVEN */

reg [15:0] ram_read0_q;
reg [15:0] ram_read1_q;

always @ (posedge clk_i)
begin
    if (wr0_i)
        ram[addr0_i] <= data0_i;

    ram_read0_q <= ram[addr0_i];
end

always @ (posedge clk_i)
begin
	ram_read1_q <= ram[addr1_i];
end

// --- Read/Write Bypass
reg data0_wr_q;
always @ (posedge clk_i )
if (rst_i)
    data0_wr_q <= 1'b0;
else
    data0_wr_q <= wr0_i;

reg wr_rd_byp_q;
always @ (posedge clk_i )
if (rst_i)
    wr_rd_byp_q <= 1'b0;
else
    wr_rd_byp_q <= wr0_i && (addr0_i == addr1_i);

reg [15:0] data0_bypass_q;

always @ (posedge clk_i)
    data0_bypass_q <= data0_i;

assign data0_o = data0_wr_q  ? data0_bypass_q : ram_read0_q;
assign data1_o = wr_rd_byp_q ? data0_bypass_q : ram_read1_q;

endmodule
