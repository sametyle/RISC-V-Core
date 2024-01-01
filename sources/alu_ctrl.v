`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2023 03:21:16 PM
// Design Name: 
// Module Name: alu_ctrl
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

module alu_ctrl(
    input [2:0] funct3_i,
    input [6:0] funct7_i,
    input [1:0] alu_op_i,
    output reg [3:0] alu_ctrl_o
    );

always @*
begin
    casex (alu_op_i)
        2'b00: alu_ctrl_o = `ALU_ADD; //S TYPE (SB,SH,SW) AND I TYPE LOAD (LB,LH,LW,LBU,LHU) AND I TYPE JUMP AND J TYPE
        2'b01: //B TYPE
            begin
                case(funct3_i)
                    3'b000: alu_ctrl_o = `ALU_BEQ; //BEQ
                    3'b001: alu_ctrl_o = `ALU_BNQ; //BNQ
                    3'b100: alu_ctrl_o = `ALU_BLT; //BLT
                    3'b101: alu_ctrl_o = `ALU_BGE; //BGE
                    3'b110: alu_ctrl_o = `ALU_BLTU; //BLTU
                    3'b111: alu_ctrl_o = `ALU_BGEU; //BGEU
                    default: alu_ctrl_o = `ALU_DEFAULT;
                endcase
            end
        2'b10: //R-TYPE 
            case(funct7_i[5])
                1'b0:
                    case(funct3_i)
                        3'b000: alu_ctrl_o =    `ALU_ADD; //ADD
                        3'b001: alu_ctrl_o =    `ALU_SLL; //SLL
                        3'b010: alu_ctrl_o =    `ALU_SLT; //SLT
                        3'b011: alu_ctrl_o =    `ALU_SLTU; //SLTU
                        3'b100: alu_ctrl_o =    `ALU_XOR; //XOR
                        3'b101: alu_ctrl_o =    `ALU_SRL; //SRL
                        3'b110: alu_ctrl_o =    `ALU_OR; //OR
                        3'b111: alu_ctrl_o =    `ALU_AND; //AND
                        default: alu_ctrl_o =   `ALU_DEFAULT; 
                    endcase
                7'b1:
                    case(funct3_i[2])
                        1'b0: alu_ctrl_o =    `ALU_SUB; //SUB
                        1'b1: alu_ctrl_o =    `ALU_SRA; //SRA
                        default: alu_ctrl_o =   `ALU_DEFAULT; 
                    endcase
                default: alu_ctrl_o =   `ALU_DEFAULT;                    
            endcase
        2'b11: //I-TYPE ARITH
                case(funct3_i)
                    3'b000: alu_ctrl_o =    `ALU_ADD; //ADDI
                    3'b001: alu_ctrl_o =    `ALU_SLL; //SLLI
                    3'b010: alu_ctrl_o =    `ALU_SLT; //SLTI
                    3'b011: alu_ctrl_o =    `ALU_SLTU; //SLTIU
                    3'b100: alu_ctrl_o =    `ALU_XOR; //XORI
                    3'b101: 
                    begin
                        case(funct7_i[5])
                            1'b0: alu_ctrl_o =    `ALU_SRL; //SRLI
                            1'b1: alu_ctrl_o =    `ALU_SRA; //SRAI
                            default: alu_ctrl_o =   `ALU_DEFAULT; 
                        endcase     
                    end
                    3'b110: alu_ctrl_o =    `ALU_OR; //ORI
                    3'b111: alu_ctrl_o =    `ALU_AND; //ANDI
                    default: alu_ctrl_o =   `ALU_DEFAULT; 
                endcase
        default: alu_ctrl_o =   `ALU_DEFAULT;
    endcase
end

endmodule
