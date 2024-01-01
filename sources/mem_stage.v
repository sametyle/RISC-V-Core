`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 06:52:50 PM
// Design Name: 
// Module Name: mem_stage
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


module mem_stage(
    input clk,
    input rst_n,

    output [31:0] data_mem_data_o,
    input  [31:0] data_mem_data_i,
    output [31:0] data_mem_addr_i,
    output data_mem_we_i,
    output [3:0] data_mem_wstrb_i,
    output data_mem_re_i,
        
    //ex_mem_reg
//    input [31:0] ex_mem_reg_pc_imm_sum,
    input [31:0] ex_mem_reg_alu_result,
//    input ex_mem_reg_alu_equal,
//    input ex_mem_reg_alu_lessthan,
//    input ex_mem_reg_alu_lessthanu,
    input [31:0] ex_mem_reg_rs2_data,
    input [4:0] ex_mem_reg_rd_adr,
    input ex_mem_reg_wb_ctrl_RegWrite,
    input ex_mem_reg_wb_ctrl_MemtoReg,
    input ex_mem_reg_wb_ctrl_MemSign,
    input [1:0] ex_mem_reg_wb_ctrl_MemTrim,
//    input [5:0] ex_mem_reg_mem_ctrl_Branch,
    input ex_mem_reg_mem_ctrl_MemRead,    
    input [3:0] ex_mem_reg_mem_ctrl_MemWrite,

//    output  [31:0] mem_stage_pc_imm_sum,
//    output  mem_stage_PCSrc,
       
    //ex_mem_reg
    output reg [31:0] mem_wb_reg_alu_result,
    output reg [31:0] mem_wb_reg_data_mem_out, 
    output reg [4:0]  mem_wb_reg_rd_adr,
   
    output reg        mem_wb_reg_wb_ctrl_RegWrite,
    output reg        mem_wb_reg_wb_ctrl_MemtoReg,
    output reg        mem_wb_reg_wb_ctrl_MemSign,
    output reg [1:0]  mem_wb_reg_wb_ctrl_MemTrim,
    output     [31:0] mem_stage_alu_result  
    );

assign mem_stage_alu_result = ex_mem_reg_alu_result;

//assign mem_stage_pc_imm_sum = ex_mem_reg_pc_imm_sum;
//assign mem_stage_PCSrc = (  (ex_mem_reg_alu_equal && ex_mem_reg_mem_ctrl_Branch[5])      || 
//                            (~ex_mem_reg_alu_equal && ex_mem_reg_mem_ctrl_Branch[4])      || 
//                            (ex_mem_reg_alu_lessthan && ex_mem_reg_mem_ctrl_Branch[3])    || 
//                            (~ex_mem_reg_alu_lessthan && ex_mem_reg_mem_ctrl_Branch[2])   || 
//                            (ex_mem_reg_alu_lessthanu && ex_mem_reg_mem_ctrl_Branch[1])  || 
//                            (~ex_mem_reg_alu_lessthanu && ex_mem_reg_mem_ctrl_Branch[0]));


assign data_mem_we_i = ex_mem_reg_mem_ctrl_MemWrite[3] || ex_mem_reg_mem_ctrl_MemWrite[2] || ex_mem_reg_mem_ctrl_MemWrite[1] || ex_mem_reg_mem_ctrl_MemWrite[0];
assign data_mem_wstrb_i = ex_mem_reg_mem_ctrl_MemWrite;
assign data_mem_re_i = ex_mem_reg_mem_ctrl_MemRead;
assign data_mem_addr_i = ex_mem_reg_alu_result;
assign data_mem_data_o = ex_mem_reg_rs2_data;

always @(posedge clk, negedge rst_n)
begin
    if (~rst_n) begin
        mem_wb_reg_rd_adr <= 5'b0;
        mem_wb_reg_data_mem_out <= 32'b0;
        mem_wb_reg_alu_result <= 32'b0;
        mem_wb_reg_wb_ctrl_RegWrite <= 1'b0;
        mem_wb_reg_wb_ctrl_MemtoReg <= 1'b0; 
        mem_wb_reg_wb_ctrl_MemSign <= 1'b0;  
        mem_wb_reg_wb_ctrl_MemTrim <= 2'b00;      
    end else begin
        mem_wb_reg_rd_adr <= ex_mem_reg_rd_adr;
        mem_wb_reg_data_mem_out <= data_mem_data_i;
        mem_wb_reg_alu_result <= ex_mem_reg_alu_result;
        mem_wb_reg_wb_ctrl_RegWrite <= ex_mem_reg_wb_ctrl_RegWrite;
        mem_wb_reg_wb_ctrl_MemtoReg <= ex_mem_reg_wb_ctrl_MemtoReg;  
        mem_wb_reg_wb_ctrl_MemSign <= ex_mem_reg_wb_ctrl_MemSign;
        mem_wb_reg_wb_ctrl_MemTrim <= ex_mem_reg_wb_ctrl_MemTrim;
    end
end
endmodule
