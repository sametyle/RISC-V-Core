`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2023 02:42:08 PM
// Design Name: 
// Module Name: cpu_top
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

`include "cpu_defines.vh"
 
module cpu_top
    (
    input clk,
    input rst_n,
    
    input [31:0] inst_mem_data_i,
    output [31:0] inst_mem_addr_o,
    
    output [31:0] data_mem_data_o,
    input [31:0] data_mem_data_i,
    output [31:0] data_mem_addr_i,
    output data_mem_we_i,
    output [3:0] data_mem_wstrb_i,
    output data_mem_re_i
    );

wire [31:0] if_id_reg_pc;
wire [31:0] if_id_reg_inst;
wire [31:0] id_stage_pc_sum;
wire        id_stage_PCSrc;

wire [31:0] id_ex_reg_pc;
wire [31:0] id_ex_reg_rs1_data;
wire [31:0] id_ex_reg_rs2_data;
wire [31:0] id_ex_reg_imm_out;
wire [31:0] id_ex_reg_pc_sum;
wire [4:0]  id_ex_reg_rs1_adr;
wire [4:0]  id_ex_reg_rs2_adr;
wire [4:0]  id_ex_reg_rd_adr;
wire [6:0]  id_ex_reg_funct7;
wire [2:0]  id_ex_reg_funct3;
wire        id_ex_reg_wb_ctrl_RegWrite;
wire        id_ex_reg_wb_ctrl_MemtoReg;
wire        id_ex_reg_wb_ctrl_MemSign;
wire [1:0]  id_ex_reg_wb_ctrl_MemTrim;
wire [5:0]  id_ex_reg_mem_ctrl_Branch;
wire        id_ex_reg_mem_ctrl_MemRead;    
wire [3:0]  id_ex_reg_mem_ctrl_MemWrite;
wire [1:0]  id_ex_reg_ex_ctrl_ALU_A_Src;
wire [1:0]  id_ex_reg_ex_ctrl_ALU_B_Src;
wire        id_ex_reg_ex_ctrl_PCAdderSrc;
wire        id_ex_reg_ex_ctrl_uncBranch;
    
wire [1:0]  id_ex_reg_ex_ctrl_ALUOp;

wire        wb_stage_wb_ctrl_RegWrite;
wire [4:0]  wb_stage_rd_adr;
wire [31:0] wb_stage_reg_file_wr_data;

wire [31:0] ex_mem_reg_pc_imm_sum;
wire [31:0] ex_mem_reg_alu_result;
wire        ex_mem_reg_alu_equal;
wire        ex_mem_reg_alu_lessthan;
wire        ex_mem_reg_alu_lessthanu;

wire [31:0] ex_mem_reg_rs2_data;
wire [4:0]  ex_mem_reg_rd_adr;
wire        ex_mem_reg_wb_ctrl_RegWrite;
wire        ex_mem_reg_wb_ctrl_MemtoReg;
wire        ex_mem_reg_wb_ctrl_MemSign;
wire [1:0]  ex_mem_reg_wb_ctrl_MemTrim;
wire [5:0]  ex_mem_reg_mem_ctrl_Branch;
wire        ex_mem_reg_mem_ctrl_MemRead;    
wire [3:0]  ex_mem_reg_mem_ctrl_MemWrite;

wire        ex_stage_branch;
wire [31:0] ex_stage_branch_address;
wire        ex_stage_flush;

wire [31:0] mem_wb_reg_alu_result;
wire [31:0] mem_wb_reg_data_mem_out; 
wire [4:0]  mem_wb_reg_rd_adr;
wire        mem_wb_reg_wb_ctrl_RegWrite;
wire        mem_wb_reg_wb_ctrl_MemtoReg; 
wire        mem_wb_reg_wb_ctrl_MemSign; 
wire [1:0]  mem_wb_reg_wb_ctrl_MemTrim; 

wire [31:0] mem_stage_alu_result;

wire id_stage_stall;
wire id_stage_flush;
 
if_stage if_stage_i(
    .clk(clk),
    .rst_n(rst_n),
    
    .id_stage_stall(id_stage_stall),
    .ex_stage_flush(ex_stage_flush),
    
    .ex_stage_branch(ex_stage_branch),
    .ex_stage_branch_address(ex_stage_branch_address),
    
    //instruction memory interface
    .inst_mem_data_i(inst_mem_data_i),
    .inst_mem_addr_o(inst_mem_addr_o),
    
    //if_id_reg
    .if_id_reg_pc(if_id_reg_pc),
    .if_id_reg_inst(if_id_reg_inst)
    );

id_stage id_stage_i(
    .clk(clk),
    .rst_n(rst_n),
    
    //if_id_reg
    .if_id_reg_pc(if_id_reg_pc),
    .if_id_reg_inst(if_id_reg_inst),
    
    //id_ex_reg
//    .id_ex_reg_pc(id_ex_reg_pc),
    .id_ex_reg_rs1_data(id_ex_reg_rs1_data),
    .id_ex_reg_rs2_data(id_ex_reg_rs2_data),
    .id_ex_reg_imm_out(id_ex_reg_imm_out),
//    .id_ex_reg_pc_sum(id_ex_reg_pc_sum),
    .id_ex_reg_pc(id_ex_reg_pc),
    .id_ex_reg_rs1_adr(id_ex_reg_rs1_adr),
    .id_ex_reg_rs2_adr(id_ex_reg_rs2_adr),
    .id_ex_reg_rd_adr(id_ex_reg_rd_adr),
    .id_ex_reg_funct7(id_ex_reg_funct7),
    .id_ex_reg_funct3(id_ex_reg_funct3),
    .id_ex_reg_wb_ctrl_RegWrite(id_ex_reg_wb_ctrl_RegWrite),
    .id_ex_reg_wb_ctrl_MemtoReg(id_ex_reg_wb_ctrl_MemtoReg),
    .id_ex_reg_wb_ctrl_MemSign(id_ex_reg_wb_ctrl_MemSign),
    .id_ex_reg_wb_ctrl_MemTrim(id_ex_reg_wb_ctrl_MemTrim),
//    .id_ex_reg_mem_ctrl_Branch(id_ex_reg_mem_ctrl_Branch),
    .id_ex_reg_mem_ctrl_MemRead(id_ex_reg_mem_ctrl_MemRead),    
    .id_ex_reg_mem_ctrl_MemWrite(id_ex_reg_mem_ctrl_MemWrite),
    .id_ex_reg_ex_ctrl_ALU_A_Src(id_ex_reg_ex_ctrl_ALU_A_Src),
    .id_ex_reg_ex_ctrl_ALU_B_Src(id_ex_reg_ex_ctrl_ALU_B_Src),
    .id_ex_reg_ex_ctrl_ALUOp(id_ex_reg_ex_ctrl_ALUOp),
    .id_ex_reg_ex_ctrl_PCAdderSrc(id_ex_reg_ex_ctrl_PCAdderSrc),
    .id_ex_reg_ex_ctrl_uncBranch(id_ex_reg_ex_ctrl_uncBranch),
    
    .id_stage_stall(id_stage_stall),
    .ex_stage_flush(ex_stage_flush),
           
    .wb_stage_wb_ctrl_RegWrite(wb_stage_wb_ctrl_RegWrite),
    .wb_stage_rd_adr(wb_stage_rd_adr),
    .wb_stage_reg_file_wr_data(wb_stage_reg_file_wr_data)    
    );

ex_stage ex_stage_i(
    .clk(clk),
    .rst_n(rst_n),
    
    //id_ex_reg
//    .id_ex_reg_pc(id_ex_reg_pc),
    .id_ex_reg_rs1_data(id_ex_reg_rs1_data),
    .id_ex_reg_rs2_data(id_ex_reg_rs2_data),
    .id_ex_reg_imm_out(id_ex_reg_imm_out),
    .id_ex_reg_pc(id_ex_reg_pc),
//    .id_ex_reg_pc_sum(id_ex_reg_pc_sum),
    .id_ex_reg_rs1_adr(id_ex_reg_rs1_adr),
    .id_ex_reg_rs2_adr(id_ex_reg_rs2_adr),
    .id_ex_reg_rd_adr(id_ex_reg_rd_adr),
    .id_ex_reg_funct7(id_ex_reg_funct7),
    .id_ex_reg_funct3(id_ex_reg_funct3),
    .id_ex_reg_wb_ctrl_RegWrite(id_ex_reg_wb_ctrl_RegWrite),
    .id_ex_reg_wb_ctrl_MemtoReg(id_ex_reg_wb_ctrl_MemtoReg),
    .id_ex_reg_wb_ctrl_MemSign(id_ex_reg_wb_ctrl_MemSign),
    .id_ex_reg_wb_ctrl_MemTrim(id_ex_reg_wb_ctrl_MemTrim),
//    .id_ex_reg_mem_ctrl_Branch(id_ex_reg_mem_ctrl_Branch),
    .id_ex_reg_mem_ctrl_MemRead(id_ex_reg_mem_ctrl_MemRead),    
    .id_ex_reg_mem_ctrl_MemWrite(id_ex_reg_mem_ctrl_MemWrite),
    .id_ex_reg_ex_ctrl_ALU_A_Src(id_ex_reg_ex_ctrl_ALU_A_Src),
    .id_ex_reg_ex_ctrl_ALU_B_Src(id_ex_reg_ex_ctrl_ALU_B_Src),
    .id_ex_reg_ex_ctrl_ALUOp(id_ex_reg_ex_ctrl_ALUOp),
    .id_ex_reg_ex_ctrl_PCAdderSrc(id_ex_reg_ex_ctrl_PCAdderSrc),
    .id_ex_reg_ex_ctrl_uncBranch(id_ex_reg_ex_ctrl_uncBranch),
    
    //mem_wb_reg
    .mem_wb_reg_rd_adr(mem_wb_reg_rd_adr),
    .mem_wb_reg_wb_ctrl_RegWrite(mem_wb_reg_wb_ctrl_RegWrite),
    
    //ex_mem_reg
//    .ex_mem_reg_pc_imm_sum(ex_mem_reg_pc_imm_sum),
    .ex_mem_reg_alu_result(ex_mem_reg_alu_result),
//    .ex_mem_reg_alu_equal(ex_mem_reg_alu_equal),
//    .ex_mem_reg_alu_lessthan(ex_mem_reg_alu_lessthan),
//    .ex_mem_reg_alu_lessthanu(ex_mem_reg_alu_lessthanu),
    .ex_mem_reg_rs2_data(ex_mem_reg_rs2_data),
    .ex_mem_reg_rd_adr(ex_mem_reg_rd_adr),
    .ex_mem_reg_wb_ctrl_RegWrite(ex_mem_reg_wb_ctrl_RegWrite),
    .ex_mem_reg_wb_ctrl_MemtoReg(ex_mem_reg_wb_ctrl_MemtoReg),
    .ex_mem_reg_wb_ctrl_MemSign(ex_mem_reg_wb_ctrl_MemSign),
    .ex_mem_reg_wb_ctrl_MemTrim(ex_mem_reg_wb_ctrl_MemTrim),
//    .ex_mem_reg_mem_ctrl_Branch(ex_mem_reg_mem_ctrl_Branch),
    .ex_mem_reg_mem_ctrl_MemRead(ex_mem_reg_mem_ctrl_MemRead),    
    .ex_mem_reg_mem_ctrl_MemWrite(ex_mem_reg_mem_ctrl_MemWrite),
    
    .ex_stage_branch(ex_stage_branch),
    .ex_stage_branch_address(ex_stage_branch_address),
    .ex_stage_flush(ex_stage_flush),
    
    .wb_stage_reg_file_wr_data(wb_stage_reg_file_wr_data), 
    .mem_stage_alu_result(mem_stage_alu_result)
    );

mem_stage mem_stage_i(
    .clk(clk),
    .rst_n(rst_n),

    .data_mem_data_o(data_mem_data_o),
    .data_mem_data_i(data_mem_data_i),
    .data_mem_addr_i(data_mem_addr_i),
    .data_mem_we_i(data_mem_we_i),
    .data_mem_wstrb_i(data_mem_wstrb_i),
    .data_mem_re_i(data_mem_re_i),
        
    //ex_mem_reg
//    .ex_mem_reg_pc_imm_sum(ex_mem_reg_pc_imm_sum),
    .ex_mem_reg_alu_result(ex_mem_reg_alu_result),
//    .ex_mem_reg_alu_equal(ex_mem_reg_alu_equal),
//    .ex_mem_reg_alu_lessthan(ex_mem_reg_alu_lessthan),
//    .ex_mem_reg_alu_lessthanu(ex_mem_reg_alu_lessthanu),
    .ex_mem_reg_rs2_data(ex_mem_reg_rs2_data),
    .ex_mem_reg_rd_adr(ex_mem_reg_rd_adr),
    .ex_mem_reg_wb_ctrl_RegWrite(ex_mem_reg_wb_ctrl_RegWrite),
    .ex_mem_reg_wb_ctrl_MemtoReg(ex_mem_reg_wb_ctrl_MemtoReg),
    .ex_mem_reg_wb_ctrl_MemSign(ex_mem_reg_wb_ctrl_MemSign),
    .ex_mem_reg_wb_ctrl_MemTrim(ex_mem_reg_wb_ctrl_MemTrim),
//    .ex_mem_reg_mem_ctrl_Branch(ex_mem_reg_mem_ctrl_Branch),
    .ex_mem_reg_mem_ctrl_MemRead(ex_mem_reg_mem_ctrl_MemRead),    
    .ex_mem_reg_mem_ctrl_MemWrite(ex_mem_reg_mem_ctrl_MemWrite),

//    .mem_stage_pc_imm_sum(mem_stage_pc_imm_sum),
//    .mem_stage_PCSrc(mem_stage_PCSrc),
       
    //ex_mem_reg
    .mem_wb_reg_alu_result(mem_wb_reg_alu_result),
    .mem_wb_reg_data_mem_out(mem_wb_reg_data_mem_out), 
    .mem_wb_reg_rd_adr(mem_wb_reg_rd_adr),
    
    .mem_wb_reg_wb_ctrl_RegWrite(mem_wb_reg_wb_ctrl_RegWrite),
    .mem_wb_reg_wb_ctrl_MemtoReg(mem_wb_reg_wb_ctrl_MemtoReg),
    .mem_wb_reg_wb_ctrl_MemSign(mem_wb_reg_wb_ctrl_MemSign),
    .mem_wb_reg_wb_ctrl_MemTrim(mem_wb_reg_wb_ctrl_MemTrim),
    .mem_stage_alu_result(mem_stage_alu_result)
    );
 
wb_stage wb_stage_i(
    .clk(clk),
    .rst_n(rst_n),

    //ex_mem_reg
    .mem_wb_reg_alu_result(mem_wb_reg_alu_result),
    .mem_wb_reg_data_mem_out(mem_wb_reg_data_mem_out), 
    .mem_wb_reg_rd_adr(mem_wb_reg_rd_adr),
    
    .mem_wb_reg_wb_ctrl_RegWrite(mem_wb_reg_wb_ctrl_RegWrite),
    .mem_wb_reg_wb_ctrl_MemtoReg(mem_wb_reg_wb_ctrl_MemtoReg),  
    .mem_wb_reg_wb_ctrl_MemSign(mem_wb_reg_wb_ctrl_MemSign),
    .mem_wb_reg_wb_ctrl_MemTrim(mem_wb_reg_wb_ctrl_MemTrim),
            
    .wb_stage_wb_ctrl_RegWrite(wb_stage_wb_ctrl_RegWrite),
    .wb_stage_rd_adr(wb_stage_rd_adr),
    .wb_stage_reg_file_wr_data(wb_stage_reg_file_wr_data)
                          
    );
    
    
endmodule
