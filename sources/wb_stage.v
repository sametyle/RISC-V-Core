`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 06:53:05 PM
// Design Name: 
// Module Name: wb_stage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module wb_stage(
    input clk,
    input rst_n,

    //ex_mem_reg
    input [31:0] mem_wb_reg_alu_result,
    input [31:0] mem_wb_reg_data_mem_out, 
    input [4:0]  mem_wb_reg_rd_adr,
    
    input        mem_wb_reg_wb_ctrl_RegWrite,
    input        mem_wb_reg_wb_ctrl_MemtoReg,  
    input        mem_wb_reg_wb_ctrl_MemSign,
    input [1:0]  mem_wb_reg_wb_ctrl_MemTrim,
        
    output             wb_stage_wb_ctrl_RegWrite,
    output      [4:0]  wb_stage_rd_adr,
    output      [31:0] wb_stage_reg_file_wr_data
    
    );

wire [31:0] sign_trim_data_mem_out; 

wire [31:0] mux_reg_file_wr_data_in_a = mem_wb_reg_alu_result;
wire [31:0] mux_reg_file_wr_data_in_b = sign_trim_data_mem_out;
wire [31:0] mux_reg_file_wr_data_out; 
wire mux_reg_file_wr_data_sel = mem_wb_reg_wb_ctrl_MemtoReg; 


assign wb_stage_wb_ctrl_RegWrite = mem_wb_reg_wb_ctrl_RegWrite;
assign wb_stage_rd_adr = mem_wb_reg_rd_adr;
assign wb_stage_reg_file_wr_data = mux_reg_file_wr_data_out;

mux2 mux_reg_file_wr_data(
   .data_a_i(mux_reg_file_wr_data_in_a),
   .data_b_i(mux_reg_file_wr_data_in_b),
   .data_o(mux_reg_file_wr_data_out),
   .sel_i(mux_reg_file_wr_data_sel)
);

sign_trim_ctrl sign_trim_ctrl_i(
    .sign_extend_i(mem_wb_reg_wb_ctrl_MemSign),
    .trim_i(mem_wb_reg_wb_ctrl_MemTrim),
    .data_i(mem_wb_reg_data_mem_out),
    .data_o(sign_trim_data_mem_out)
);

endmodule
