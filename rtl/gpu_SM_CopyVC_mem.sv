/* ----------------------------------------------------------------------------------------------------------------------

PS-FPGA Licenses (DUAL License GPLv2 and commercial license)

This PS-FPGA source code is copyright 2019 and licensed under the GNU General Public License v2.0, 
 and a commercial licensing option.
If you wish to use the source code from PS-FPGA, email laxer3a [at] hotmail [dot] com for commercial licensing.

See LICENSE file.
---------------------------------------------------------------------------------------------------------------------- */

module gpu_SM_CopyVC_mem(
    input                    i_clk,
    input                    i_rst,
    
    input                    i_activate,
    output                   o_exitSig,    // End at next cycle
    output                   o_active,
    
    input    signed [11:0]   RegX0,
    input    signed [11:0]   RegY0,
    input            [10:0]  RegSizeW,
    input           [ 9:0]   RegSizeH,

    // FIFO
    input                    i_popPixelPair,
    output                   o_writeFIFOOut,
    output    [31:0]         o_pairPixelToCPU,
    
    // -----------------------------------
    // [DDR SIDE]
    // -----------------------------------

    output                   o_command,        
    input                    i_busy,           
    output   [1:0]           o_commandSize,    
    
    output                   o_write,           
    output [ 14:0]           o_adr,            
    output   [2:0]           o_subadr,         
    output  [15:0]           o_writeMask,

    input  [255:0]           i_dataIn,
    input                    i_dataInValid,
    output [255:0]           o_dataOut
);

// Delay acivate so that all signals are valid in the same cycle
reg  activate_q;
wire busy_w;

always @ (posedge i_clk)
if (i_rst)
    activate_q <= 1'b0;
else
    activate_q <= i_activate;

gpu_mem_vramcpu gpu_mem_vramcpu_inst
(
    // Inputs
    .clk_i					(i_clk),
    .rst_i                  (i_rst),
    .req_valid_i            (activate_q),
    .req_x_i                ({{4{RegX0[11]}}, RegX0}),
    .req_y_i                ({{4{RegY0[11]}}, RegY0}),
    .req_sizex_i            ({5'b0, RegSizeW}),
    .req_sizey_i            ({6'b0, RegSizeH}),

    .data_accept_i          (i_popPixelPair),
    
	.gpu_busy_i             (i_busy),
    .gpu_data_in_valid_i    (i_dataInValid),
    .gpu_data_in_i          (i_dataIn),

    // Outputs
    .req_accept_o			(),
    .data_valid_o           (o_writeFIFOOut),
    .data_pair_o            (o_pairPixelToCPU),
	
    .busy_o                 (busy_w),
    .done_o                 (o_exitSig),
    
	.gpu_command_o          (o_command),
    .gpu_size_o             (o_commandSize),
    .gpu_write_o            (o_write),
    .gpu_addr_o             (o_adr),
    .gpu_sub_addr_o         (o_subadr),
    .gpu_write_mask_o       (o_writeMask),
    .gpu_data_out_o         (o_dataOut)
	
);

assign o_active = busy_w | activate_q;

endmodule
