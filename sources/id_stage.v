`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 02:55:08 PM
// Design Name: 
// Module Name: id_stage
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

module id_stage(
    input clk,
    input rst_n,
    
    //if_id_reg
    input [31:0] if_id_reg_pc,
    input [31:0] if_id_reg_inst,
    
    //id_ex_reg
//    output reg [31:0] id_ex_reg_pc,
    output reg [31:0] id_ex_reg_rs1_data,
    output reg [31:0] id_ex_reg_rs2_data,
    output reg [31:0] id_ex_reg_imm_out,
    output reg [31:0] id_ex_reg_pc,
//    output reg [31:0] id_ex_reg_pc_sum,
    output reg [4:0]  id_ex_reg_rs1_adr,
    output reg [4:0]  id_ex_reg_rs2_adr,
    output reg [4:0]  id_ex_reg_rd_adr,
    output reg [6:0]  id_ex_reg_funct7,
    output reg [2:0]  id_ex_reg_funct3,
    output reg        id_ex_reg_wb_ctrl_RegWrite,
    output reg        id_ex_reg_wb_ctrl_MemtoReg,
    output reg        id_ex_reg_wb_ctrl_MemSign,
    output reg [1:0]  id_ex_reg_wb_ctrl_MemTrim,
//    output reg [5:0]  id_ex_reg_mem_ctrl_Branch,
    output reg        id_ex_reg_mem_ctrl_MemRead,    
    output reg [3:0]  id_ex_reg_mem_ctrl_MemWrite,
    output reg [1:0]  id_ex_reg_ex_ctrl_ALU_A_Src,
    output reg [1:0]  id_ex_reg_ex_ctrl_ALU_B_Src,
    output reg [1:0]  id_ex_reg_ex_ctrl_ALUOp,
    output reg        id_ex_reg_ex_ctrl_uncBranch,
    output reg        id_ex_reg_ex_ctrl_PCAdderSrc,
    
    output            id_stage_stall,
//    output            id_stage_flush,
    input             ex_stage_flush,
    
    //inputs

        
    input             wb_stage_wb_ctrl_RegWrite,
    input      [4:0]  wb_stage_rd_adr,
    input      [31:0] wb_stage_reg_file_wr_data
    
    );

wire [31:0] inst = ex_stage_flush ? `NOP : if_id_reg_inst;

wire [6:0] OPCODE   = inst[6:0];
wire [6:0] FUNCT7   = inst[31:25];
wire [2:0] FUNCT3   = inst[14:12];
wire [4:0] RS1_ADR   = inst[19:15];
wire [4:0] RS2_ADR   = inst[24:20];
wire [4:0] RD_ADR   = inst[11:7];

wire [4:0]  reg_file_rs1_addr_in = RS1_ADR; 
wire [4:0]  reg_file_rs2_addr_in = RS2_ADR;
wire [4:0]  reg_file_rd_addr_in  = wb_stage_rd_adr;
wire [31:0] reg_file_rd_in = wb_stage_reg_file_wr_data;
wire        reg_file_rd_wr_en_in = wb_stage_wb_ctrl_RegWrite;

wire [31:0] reg_file_rs1_out;
wire [31:0] reg_file_rs2_out;

wire [31:0] imm_gen_inst_in = inst;
wire [4:0]  imm_gen_type; 
wire [31:0] imm_out;

//WB Stage Controls
wire        main_ctrl_RegWrite;
wire        main_ctrl_MemtoReg;
wire        main_ctrl_MemSign;
wire [1:0]  main_ctrl_MemTrim;

//MEM Stage Controls
wire        main_ctrl_MemRead;
wire [3:0]  main_ctrl_MemWrite;

//EX Stage Controls
wire [1:0]  main_ctrl_ALU_A_Src;
wire [1:0]  main_ctrl_ALU_B_Src;
wire [1:0]  main_ctrl_ALUOp;

//IF Stage Controls
wire        main_ctrl_uncBranch; 

wire        main_ctrl_PCAdderSrc; 

wire        hazard_stall_out;

//wire [31:0] mux2_level_1_adder_pc_sum_in_a_a = if_id_reg_pc;
//wire [31:0] mux2_level_1_adder_pc_sum_in_a_b = reg_file_rs1_out;
//wire [31:0] mux2_level_1_adder_pc_sum_in_a_out;
//wire        mux2_level_1_adder_pc_sum_in_a_sel = main_ctrl_PCAdderSrc;

//wire [31:0] adder_pc_sum_in_a = mux2_level_1_adder_pc_sum_in_a_out;
//wire [31:0] adder_pc_sum_in_b = imm_out;
//wire [31:0] adder_pc_sum_out;


assign id_stage_stall = hazard_stall_out;
//assign id_stage_flush = main_ctrl_PCSrc; 

//assign id_stage_pc_sum = adder_pc_sum_out;
       
always @(posedge clk, negedge rst_n)
begin
    if (~rst_n) begin
//        id_ex_reg_pc <= 32'b0;
        id_ex_reg_rs1_data <= 32'b0;
        id_ex_reg_rs2_data <= 32'b0;
        id_ex_reg_imm_out <= 32'b0;
//        id_ex_reg_pc_sum <= 32'b0;
        id_ex_reg_pc <= 32'b0;
        id_ex_reg_rs1_adr <= 5'b0;
        id_ex_reg_rs2_adr <= 5'b0;
        id_ex_reg_rd_adr <= 5'b0;
        id_ex_reg_funct7 <= 7'b0;
        id_ex_reg_funct3 <= 3'b0;
        id_ex_reg_wb_ctrl_RegWrite <= 1'b0;
        id_ex_reg_wb_ctrl_MemtoReg <= 1'b0;
        id_ex_reg_wb_ctrl_MemSign <= 1'b0;
        id_ex_reg_wb_ctrl_MemTrim <= 2'b00;
//        id_ex_reg_mem_ctrl_Branch <= 6'b0;
        id_ex_reg_mem_ctrl_MemRead <= 1'b0;    
        id_ex_reg_mem_ctrl_MemWrite <= 4'b0;
        id_ex_reg_ex_ctrl_ALU_A_Src <= 2'b0;
        id_ex_reg_ex_ctrl_ALU_B_Src <= 2'b0;
        id_ex_reg_ex_ctrl_ALUOp <= 2'b0;    
        id_ex_reg_ex_ctrl_uncBranch <= 1'b0;
        id_ex_reg_ex_ctrl_PCAdderSrc <= 1'b0;
    end else begin
//        id_ex_reg_pc <= if_id_reg_pc;
        id_ex_reg_rs1_data <= reg_file_rs1_out;
        id_ex_reg_rs2_data <= reg_file_rs2_out;
        id_ex_reg_imm_out <= imm_out;
//        id_ex_reg_pc_sum <= adder_pc_sum_out;
        id_ex_reg_pc <= if_id_reg_pc;
        id_ex_reg_rs1_adr <= RS1_ADR;
        id_ex_reg_rs2_adr <= RS2_ADR;
        id_ex_reg_rd_adr <= RD_ADR;
        id_ex_reg_funct7 <= FUNCT7;
        id_ex_reg_funct3 <= FUNCT3;
        id_ex_reg_wb_ctrl_RegWrite <= main_ctrl_RegWrite;
        id_ex_reg_wb_ctrl_MemtoReg <= main_ctrl_MemtoReg;
        id_ex_reg_wb_ctrl_MemSign <= main_ctrl_MemSign;
        id_ex_reg_wb_ctrl_MemTrim <= main_ctrl_MemTrim;
//        id_ex_reg_mem_ctrl_Branch <= main_ctrl_Branch;
        id_ex_reg_mem_ctrl_MemRead <= main_ctrl_MemRead;    
        id_ex_reg_mem_ctrl_MemWrite <= main_ctrl_MemWrite;
        id_ex_reg_ex_ctrl_ALU_A_Src <= main_ctrl_ALU_A_Src;
        id_ex_reg_ex_ctrl_ALU_B_Src <= main_ctrl_ALU_B_Src;
        id_ex_reg_ex_ctrl_ALUOp <= main_ctrl_ALUOp;
        id_ex_reg_ex_ctrl_uncBranch <= main_ctrl_uncBranch;
        id_ex_reg_ex_ctrl_PCAdderSrc <= main_ctrl_PCAdderSrc;
    end
end

reg_file reg_file_ins(
    .clk(clk),
    .rst_n(rst_n),
    
    .rs1_addr_i(reg_file_rs1_addr_in),
    .rs2_addr_i(reg_file_rs2_addr_in),
    .rd_addr_i(reg_file_rd_addr_in),
    .rd_data_i(reg_file_rd_in),
    .rd_wr_en_i(reg_file_rd_wr_en_in),
   
    .r1_data_o(reg_file_rs1_out),
    .r2_data_o(reg_file_rs2_out)
    );
    
imm_gen imm_gen_ins
(
	.inst_i(imm_gen_inst_in),
	.type_i(imm_gen_type),
	.imm_val_o(imm_out)
);

main_ctrl main_ctrl_ins(
    .opcode_i(OPCODE),
    .funct3_i(FUNCT3),
    .funct7_i(FUNCT7),
    .stall_i(hazard_stall_out),
    .mem_read_o(main_ctrl_MemRead),
    .mem_to_reg_o(main_ctrl_MemtoReg),
    .mem_sign_extend_o(main_ctrl_MemSign),
    .mem_trim_o(main_ctrl_MemTrim),
    .alu_op_o(main_ctrl_ALUOp),
    .imm_gen_type_o(imm_gen_type),
    .mem_write_o(main_ctrl_MemWrite),
    .alu_a_src_o(main_ctrl_ALU_A_Src),
    .alu_b_src_o(main_ctrl_ALU_B_Src),
    .unc_branch_o(main_ctrl_uncBranch),
    .pc_adder_src_o(main_ctrl_PCAdderSrc),
    .reg_write_o(main_ctrl_RegWrite)
    );   

hazard_detection_unit hazard_i(
    .ID_EX_REG_MEM_CTRL_MemRead(id_ex_reg_mem_ctrl_MemRead),
    .ID_EX_REG_RD_ADD(id_ex_reg_rd_adr),
    .IF_ID_REG_RS1_ADD(RS1_ADR),
    .IF_ID_REG_RS2_ADD(RS2_ADR),
    .stall(hazard_stall_out)
    );
    
//adder adder_pc(
//    .data_a_i(mux2_level_1_adder_pc_sum_in_a_out),
//    .data_b_i(adder_pc_sum_in_b),
//    .data_o(adder_pc_sum_out)
//    );

//mux2 mux_adder_pc_a_level_1(
//   .data_a_i(mux2_level_1_adder_pc_sum_in_a_a),
//   .data_b_i(mux2_level_1_adder_pc_sum_in_a_b),
//   .data_o(mux2_level_1_adder_pc_sum_in_a_out),
//   .sel_i(mux2_level_1_adder_pc_sum_in_a_sel)
//); 
       
endmodule
