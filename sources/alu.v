`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2023 11:25:17 PM
// Design Name: 
// Module Name: alu
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

module alu(
    input [31:0] op_a_i,
    input [31:0] op_b_i,
    input [3:0] op_code_i,
    
    output reg [31:0] result_o,
//    output lessthan_o,
//    output lessthanu_o,
    output reg branch_o
    );

wire signed [31:0] op_a_signed = op_a_i;
wire signed [31:0] op_b_signed = op_b_i;
 
//assign equal_o = (op_a_i == op_b_i) ? 1 : 0; 
//assign lessthan_o = (op_a_signed < op_b_signed ? 1'b1 : 1'b0);
//assign lessthanu_o = (op_a_i < op_b_i ? 1'b1 : 1'b0);
   
always @*
begin
    case (op_code_i)
        `ALU_SRL: begin
            result_o = op_a_i >> op_b_i; branch_o = 1'b0; end   
        `ALU_SLL: begin
            result_o = op_a_i << op_b_i; branch_o = 1'b0; end   
        `ALU_XOR: begin
            result_o = op_a_i ^ op_b_i; branch_o = 1'b0; end    
        `ALU_AND: begin
            result_o = op_a_i & op_b_i; branch_o = 1'b0; end           
        `ALU_OR: begin
            result_o = op_a_i | op_b_i; branch_o = 1'b0; end   
        `ALU_ADD: begin
            result_o = op_a_i + op_b_i; branch_o = 1'b0; end   
        `ALU_SUB: begin
            result_o = op_a_i - op_b_i; branch_o = 1'b0; end   
        `ALU_SRA: begin
            result_o = op_a_signed >>> op_b_i; branch_o = 1'b0; end   
        `ALU_SLT: begin
            result_o = (op_a_signed < op_b_signed ? 32'b1 : 32'b0); branch_o = 1'b0; end    
        `ALU_SLTU: begin
            result_o = (op_a_i < op_b_i ? 32'b1 : 32'b0); branch_o = 1'b0; end     
        `ALU_BEQ: begin
            result_o = 32'b0; branch_o = (op_a_i == op_b_i) ? 1 : 0; end   
        `ALU_BNQ: begin
            result_o = 32'b0; branch_o = (op_a_i != op_b_i) ? 1 : 0; end           
        `ALU_BLT: begin
            result_o = 32'b0; branch_o = (op_a_signed < op_b_signed) ? 1 : 0; end           
        `ALU_BGE: begin
            result_o = 32'b0; branch_o = (op_a_signed >= op_b_signed) ? 1 : 0; end           
        `ALU_BLTU: begin
            result_o = 32'b0; branch_o = (op_a_i < op_b_i) ? 1 : 0; end           
        `ALU_BGEU: begin 
            result_o = 32'b0; branch_o = (op_a_i >= op_b_i) ? 1 : 0; end                 
        default:
            result_o = 32'd0;
    endcase
end

endmodule
