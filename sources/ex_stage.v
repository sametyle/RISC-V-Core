`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 05:58:18 PM
// Design Name: 
// Module Name: ex_stage
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


module ex_stage(
    input clk,
    input rst_n,
    
    //id_ex_reg
//    input [31:0] id_ex_reg_pc,
    input [31:0] id_ex_reg_rs1_data,
    input [31:0] id_ex_reg_rs2_data,
    input [31:0] id_ex_reg_imm_out,
    input [31:0] id_ex_reg_pc,
//    input [31:0] id_ex_reg_pc_sum,
    input [4:0]  id_ex_reg_rs1_adr,
    input [4:0]  id_ex_reg_rs2_adr,
    input [4:0]  id_ex_reg_rd_adr,
    input [6:0]  id_ex_reg_funct7,
    input [2:0]  id_ex_reg_funct3,
    input        id_ex_reg_wb_ctrl_RegWrite,
    input        id_ex_reg_wb_ctrl_MemtoReg,
    input        id_ex_reg_wb_ctrl_MemSign,
    input [1:0]  id_ex_reg_wb_ctrl_MemTrim,
//    input [5:0]  id_ex_reg_mem_ctrl_Branch,
    input        id_ex_reg_mem_ctrl_MemRead,    
    input [3:0]  id_ex_reg_mem_ctrl_MemWrite,
    input [1:0]  id_ex_reg_ex_ctrl_ALU_A_Src,
    input [1:0]  id_ex_reg_ex_ctrl_ALU_B_Src,
    input [1:0]  id_ex_reg_ex_ctrl_ALUOp,
    input        id_ex_reg_ex_ctrl_PCAdderSrc,
    input        id_ex_reg_ex_ctrl_uncBranch,
    
    //mem_wb_reg
    input [4:0]  mem_wb_reg_rd_adr,
    input        mem_wb_reg_wb_ctrl_RegWrite,
    
    //ex_mem_reg
//    output reg [31:0] ex_mem_reg_pc_imm_sum,
    output reg [31:0] ex_mem_reg_alu_result,
//    output reg        ex_mem_reg_alu_equal,
//    output reg        ex_mem_reg_alu_lessthan,
//    output reg        ex_mem_reg_alu_lessthanu,
    output reg [31:0] ex_mem_reg_rs2_data,
    output reg [4:0]  ex_mem_reg_rd_adr,
    output reg        ex_mem_reg_wb_ctrl_RegWrite,
    output reg        ex_mem_reg_wb_ctrl_MemtoReg,
    output reg        ex_mem_reg_wb_ctrl_MemSign,
    output reg [1:0]  ex_mem_reg_wb_ctrl_MemTrim,
//    output reg [5:0]  ex_mem_reg_mem_ctrl_Branch,
    output reg        ex_mem_reg_mem_ctrl_MemRead,    
    output reg [3:0]  ex_mem_reg_mem_ctrl_MemWrite,
    
    output            ex_stage_flush,
    output            ex_stage_branch,
    output     [31:0] ex_stage_branch_address,
       
    input      [31:0] wb_stage_reg_file_wr_data,
    input      [31:0] mem_stage_alu_result 

    );
    
wire [2:0] alu_ctrl_funct3 = id_ex_reg_funct3;
wire [6:0] alu_ctrl_funct7 = id_ex_reg_funct7;
wire [1:0] alu_ctrl_op = id_ex_reg_ex_ctrl_ALUOp;
wire [3:0] alu_ctrl_out; 


//Forwarding Unit Mux for Operand A
wire [31:0] mux4_level_2_alu_op_a_in_a = id_ex_reg_rs1_data;
wire [31:0] mux4_level_2_alu_op_a_in_b = wb_stage_reg_file_wr_data;
wire [31:0] mux4_level_2_alu_op_a_in_c = mem_stage_alu_result;
wire [31:0] mux4_level_2_alu_op_a_in_d = 32'b0;
wire [31:0] mux4_level_2_alu_op_a_out;
wire [1:0]  mux4_level_2_alu_op_a_sel;

//Forwarding Unit Mux for Operand B
wire [31:0] mux4_level_2_alu_op_b_in_a = id_ex_reg_rs2_data;
wire [31:0] mux4_level_2_alu_op_b_in_b = wb_stage_reg_file_wr_data;
wire [31:0] mux4_level_2_alu_op_b_in_c = mem_stage_alu_result;
wire [31:0] mux4_level_2_alu_op_b_in_d = 32'b0;
wire [31:0] mux4_level_2_alu_op_b_out;
wire [1:0]  mux4_level_2_alu_op_b_sel;

//Main Controller Mux for Operand A
wire [31:0] mux4_level_1_alu_op_a_in_a = mux4_level_2_alu_op_a_out;
wire [31:0] mux4_level_1_alu_op_a_in_b = id_ex_reg_pc;
wire [31:0] mux4_level_1_alu_op_a_in_c = 32'b0;
wire [31:0] mux4_level_1_alu_op_a_in_d = 32'b0; //Reserved

wire [1:0]  mux4_level_1_alu_op_a_sel = id_ex_reg_ex_ctrl_ALU_A_Src;
wire [31:0] mux4_level_1_alu_op_a_out;

//Main Controller Mux for Operand B
wire [31:0] mux4_level_1_alu_op_b_in_a = mux4_level_2_alu_op_b_out;
wire [31:0] mux4_level_1_alu_op_b_in_b = id_ex_reg_imm_out;
wire [31:0] mux4_level_1_alu_op_b_in_c = 32'd4;
wire [31:0] mux4_level_1_alu_op_b_in_d = 32'd0; //Reserved

wire [1:0]  mux4_level_1_alu_op_b_sel = id_ex_reg_ex_ctrl_ALU_B_Src;
wire [31:0] mux4_level_1_alu_op_b_out;

wire [31:0] alu_op_a_in = mux4_level_1_alu_op_a_out;
wire [31:0] alu_op_b_in = mux4_level_1_alu_op_b_out;


wire [31:0] alu_result;
wire con_branch;

wire [31:0] mux2_level_1_adder_pc_sum_in_a_a = id_ex_reg_pc;
wire [31:0] mux2_level_1_adder_pc_sum_in_a_b = id_ex_reg_rs1_data;
wire [31:0] mux2_level_1_adder_pc_sum_in_a_out;
wire        mux2_level_1_adder_pc_sum_in_a_sel = id_ex_reg_ex_ctrl_PCAdderSrc;

wire [31:0] adder_pc_sum_in_a = mux2_level_1_adder_pc_sum_in_a_out;
wire [31:0] adder_pc_sum_in_b = id_ex_reg_imm_out;
wire [31:0] adder_pc_sum_out;

//wire [31:0] adder_pc_imm_sum_in_a = id_ex_reg_pc;
//wire [31:0] adder_pc_imm_sum_in_b = id_ex_reg_imm_out;
//wire [31:0] adder_pc_imm_sum_out;

assign ex_stage_branch_address = adder_pc_sum_out;
assign ex_stage_branch = con_branch || id_ex_reg_ex_ctrl_uncBranch;
assign ex_stage_flush = ex_stage_branch;

always @(posedge clk, negedge rst_n)
begin
    if (~rst_n) begin
//        ex_mem_reg_pc_imm_sum <= 32'b0;
        ex_mem_reg_alu_result <= 32'b0;
//        ex_mem_reg_alu_equal <= 1'b0;
//        ex_mem_reg_alu_lessthan <= 1'b0;
//        ex_mem_reg_alu_lessthanu <= 1'b0;
        ex_mem_reg_rs2_data <= 32'b0;    
        ex_mem_reg_rd_adr <= 5'b0;
        ex_mem_reg_wb_ctrl_RegWrite <= 1'b0;
        ex_mem_reg_wb_ctrl_MemtoReg <= 1'b0;
        ex_mem_reg_wb_ctrl_MemSign <= 1'b0;
        ex_mem_reg_wb_ctrl_MemTrim <= 2'b00;
//        ex_mem_reg_mem_ctrl_Branch <= 6'b0;
        ex_mem_reg_mem_ctrl_MemRead <= 1'b0;    
        ex_mem_reg_mem_ctrl_MemWrite <= 1'b0;     
    end else begin
//        ex_mem_reg_pc_imm_sum <= adder_pc_imm_sum_out;
        ex_mem_reg_alu_result <= alu_result;
//        ex_mem_reg_alu_equal <= alu_equal;
//        ex_mem_reg_alu_lessthan <= alu_lessthan;
//        ex_mem_reg_alu_lessthanu <= alu_lessthanu;        
        ex_mem_reg_rs2_data <= id_ex_reg_rs2_data;    
        ex_mem_reg_rd_adr <= id_ex_reg_rd_adr;
        ex_mem_reg_wb_ctrl_RegWrite <= id_ex_reg_wb_ctrl_RegWrite;
        ex_mem_reg_wb_ctrl_MemtoReg <= id_ex_reg_wb_ctrl_MemtoReg;
        ex_mem_reg_wb_ctrl_MemSign <= id_ex_reg_wb_ctrl_MemSign;
        ex_mem_reg_wb_ctrl_MemTrim <= id_ex_reg_wb_ctrl_MemTrim;
//        ex_mem_reg_mem_ctrl_Branch <= id_ex_reg_mem_ctrl_Branch;
        ex_mem_reg_mem_ctrl_MemRead <= id_ex_reg_mem_ctrl_MemRead;    
        ex_mem_reg_mem_ctrl_MemWrite <= id_ex_reg_mem_ctrl_MemWrite; 
    end
end


alu_ctrl alu_ctrl_ins(
    .funct3_i(alu_ctrl_funct3),
    .funct7_i(alu_ctrl_funct7),
    .alu_op_i(alu_ctrl_op),
    .alu_ctrl_o(alu_ctrl_out)
    );
    
alu alu_ins(
    .op_a_i(alu_op_a_in),
    .op_b_i(alu_op_b_in),
    .op_code_i(alu_ctrl_out),    
    .result_o(alu_result),
    .branch_o(con_branch)
//    .lessthan_o(alu_lessthan),
//    .lessthanu_o(alu_lessthanu)
);

mux4 mux_alu_op_a_level_1(
   .data_a_i(mux4_level_1_alu_op_a_in_a),
   .data_b_i(mux4_level_1_alu_op_a_in_b),
   .data_c_i(mux4_level_1_alu_op_a_in_c),
   .data_d_i(mux4_level_1_alu_op_a_in_d),
   .data_o(mux4_level_1_alu_op_a_out),
   .sel_i(mux4_level_1_alu_op_a_sel)
); 

mux4 mux_alu_op_b_level_1(
   .data_a_i(mux4_level_1_alu_op_b_in_a),
   .data_b_i(mux4_level_1_alu_op_b_in_b),
   .data_c_i(mux4_level_1_alu_op_b_in_c),
   .data_d_i(mux4_level_1_alu_op_b_in_d),
   .data_o(mux4_level_1_alu_op_b_out),
   .sel_i(mux4_level_1_alu_op_b_sel)
); 

mux4 mux_alu_op_a_level_2(
   .data_a_i(mux4_level_2_alu_op_a_in_a),
   .data_b_i(mux4_level_2_alu_op_a_in_b),
   .data_c_i(mux4_level_2_alu_op_a_in_c),
   .data_d_i(mux4_level_2_alu_op_a_in_d),
   .data_o(mux4_level_2_alu_op_a_out),
   .sel_i(mux4_level_2_alu_op_a_sel)
); 

mux4 mux_alu_op_b_level_2(
   .data_a_i(mux4_level_2_alu_op_b_in_a),
   .data_b_i(mux4_level_2_alu_op_b_in_b),
   .data_c_i(mux4_level_2_alu_op_b_in_c),
   .data_d_i(mux4_level_2_alu_op_b_in_d),
   .data_o(mux4_level_2_alu_op_b_out),
   .sel_i(mux4_level_2_alu_op_b_sel)
); 

forwarding_unit forwarding_i(
    .ID_EX_REG_RS1_ADD(id_ex_reg_rs1_adr),
    .ID_EX_REG_RS2_ADD(id_ex_reg_rs2_adr),
    .EX_MEM_REG_RD_ADD(ex_mem_reg_rd_adr),
    .MEM_WB_REG_RD_ADD(mem_wb_reg_rd_adr),
    .EX_MEM_REG_WB_CTRL_RegWrite(ex_mem_reg_wb_ctrl_RegWrite),
    .MEM_WB_REG_WB_CTRL_RegWrite(mem_wb_reg_wb_ctrl_RegWrite),
    .ForwardA(mux4_level_2_alu_op_a_sel),
    .ForwardB(mux4_level_2_alu_op_b_sel)
    );

adder adder_pc(
    .data_a_i(mux2_level_1_adder_pc_sum_in_a_out),
    .data_b_i(adder_pc_sum_in_b),
    .data_o(adder_pc_sum_out)
    );

mux2 mux_adder_pc_a_level_1(
   .data_a_i(mux2_level_1_adder_pc_sum_in_a_a),
   .data_b_i(mux2_level_1_adder_pc_sum_in_a_b),
   .data_o(mux2_level_1_adder_pc_sum_in_a_out),
   .sel_i(mux2_level_1_adder_pc_sum_in_a_sel)
);
    
//adder adder_pc_imm_sum(
//    .data_a_i(adder_pc_imm_sum_in_a),
//    .data_b_i(adder_pc_imm_sum_in_b),
//    .data_o(adder_pc_imm_sum_out)
//    );
endmodule
