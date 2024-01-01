`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2023 04:15:53 PM
// Design Name: 
// Module Name: main_ctrl
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

module main_ctrl(
    input [6:0] opcode_i,
    input [2:0] funct3_i,
    input [6:0] funct7_i,
    input stall_i,
    output reg mem_read_o,
    output reg mem_to_reg_o,
    output reg mem_sign_extend_o,
    output reg [1:0] mem_trim_o,
    output [1:0] alu_op_o,
    output [4:0] imm_gen_type_o,
    output reg [3:0] mem_write_o,
    output reg [1:0] alu_a_src_o,
    output reg [1:0] alu_b_src_o,
    output reg unc_branch_o,
    output reg pc_adder_src_o,
    output reg reg_write_o
    );

wire R_TYPE        = ( opcode_i == `OPCODE_R_TYPE      );     
wire I_TYPE_LOAD   = ( opcode_i == `OPCODE_I_TYPE_LOAD );
wire I_TYPE_ARITH  = ( opcode_i == `OPCODE_I_TYPE_ARITH);
wire I_TYPE_JUMP   = ( opcode_i == `OPCODE_I_TYPE_JUMP );
wire I_TYPE_CSR    = ( opcode_i == `OPCODE_I_TYPE_CSR  );
wire S_TYPE        = ( opcode_i == `OPCODE_S_TYPE      );
wire B_TYPE        = ( opcode_i == `OPCODE_B_TYPE      );
wire J_TYPE        = ( opcode_i == `OPCODE_J_TYPE      );
wire U_TYPE_LOAD   = ( opcode_i == `OPCODE_U_TYPE_LOAD );
wire U_TYPE_AUIPC  = ( opcode_i == `OPCODE_U_TYPE_AUIPC);

wire I_TYPE = I_TYPE_LOAD || I_TYPE_ARITH || I_TYPE_JUMP || I_TYPE_CSR;
wire U_TYPE = U_TYPE_LOAD || U_TYPE_AUIPC;

wire B_TYPE_BEQ = ( funct3_i == 'b000);
wire B_TYPE_BNQ = ( funct3_i == 'b001);
wire B_TYPE_BLT = ( funct3_i == 'b100);
wire B_TYPE_BGE = ( funct3_i == 'b101);
wire B_TYPE_BLTU = ( funct3_i == 'b110);
wire B_TYPE_BGEU = ( funct3_i == 'b111);

reg alu_op1;
reg alu_op0;

assign imm_gen_type_o = {I_TYPE,S_TYPE,B_TYPE,J_TYPE,U_TYPE};

assign alu_op_o = {alu_op1,alu_op0};

always @*
begin
    if (stall_i) begin
        mem_read_o     = 1'b0;
        mem_to_reg_o   = 1'b0;
        alu_op1        = 1'b0;
        alu_op0        = 1'b0;
        mem_write_o    = 4'b0;
        alu_a_src_o    = 2'b00;
        alu_b_src_o    = 2'b00;
        unc_branch_o   = 1'b0;
        pc_adder_src_o = 1'b0;
        reg_write_o    = 1'b0;    
        mem_sign_extend_o = 1'b0; 
        mem_trim_o     = 2'b00;  
    end else begin
        case (opcode_i)
            `OPCODE_R_TYPE : //ADD,SUB,SLL,SLT,SLTU,XOR,SRL,SRA,OR,AND
            begin
                mem_read_o     = 1'b0;
                mem_to_reg_o   = 1'b0;
                alu_op1        = 1'b1;
                alu_op0        = 1'b0;
                mem_write_o    = 4'b0;
                alu_a_src_o    = 2'b00; //ALU OP A: RS1 Data
                alu_b_src_o    = 2'b00; //ALU OP B: RS2 Data
                unc_branch_o   = 1'b0;
                pc_adder_src_o = 1'b0;
                reg_write_o    = 1'b1;    
                mem_sign_extend_o = 1'b0;
                mem_trim_o     = 2'b00;        
            end
            `OPCODE_I_TYPE_LOAD : //LB,LH,LW,LBU,LHU
            begin
                mem_read_o     = 1'b1;
                mem_to_reg_o   = 1'b1;
                alu_op1        = 1'b0;
                alu_op0        = 1'b0;
                mem_write_o    = 4'b0;
                alu_a_src_o    = 2'b00; //ALU OP A: RS1 Data
                alu_b_src_o    = 2'b01; //ALU OP B: Immediate
                unc_branch_o   = 1'b0;
                pc_adder_src_o = 1'b0;
                reg_write_o    = 1'b1; 
                if (funct3_i[1]) begin //LW
                    mem_sign_extend_o = 1'b1; 
                    mem_trim_o        = 2'b00;                     
                end else begin
                    if (funct3_i[2]) begin //zero extend
                        mem_sign_extend_o = 1'b0; 
                    end else begin //sign extend
                        mem_sign_extend_o = 1'b1; 
                    end                
                
                    if (funct3_i[0]) begin //LH,LHU
                        mem_trim_o  = 2'b01; 
                    end else begin //LB, LBU
                        mem_trim_o  = 2'b10;                       
                    end
                end                          
            end
            `OPCODE_I_TYPE_ARITH : //ADDI,SLTI,SLTIU,XORI,ORI,ANDI,SLLI,SRLI,SRAI
            begin
                mem_read_o     = 1'b0;
                mem_to_reg_o   = 1'b0;
                alu_op1        = 1'b1;
                alu_op0        = 1'b1;
                mem_write_o    = 4'b0;
                alu_a_src_o    = 2'b00; //ALU OP A: RS1 Data
                alu_b_src_o    = 2'b01; //ALU OP A: Immediate
                unc_branch_o   = 1'b0;
                pc_adder_src_o = 1'b0;
                reg_write_o    = 1'b1;  
                mem_sign_extend_o = 1'b0; 
                mem_trim_o     = 2'b00;         
            end        
            `OPCODE_S_TYPE : //SB,SH,SW
            begin
                mem_read_o     = 1'b0;
                mem_to_reg_o   = 1'b0;
                alu_op1        = 1'b0;
                alu_op0        = 1'b0;
                if (funct3_i[1] == 1'b1) begin //SW
                    mem_write_o = 4'b1111; 
                end else if (funct3_i[0] == 1'b1) begin  //SH
                    mem_write_o = 4'b0011; 
                end else begin 
                    mem_write_o = 4'b0001; //SB
                end                
                alu_a_src_o    = 2'b00; //ALU OP A: RS1 Data
                alu_b_src_o    = 2'b01; //ALU OP B: Immediate
                unc_branch_o   = 1'b0;
                pc_adder_src_o = 1'b0;
                reg_write_o    = 1'b0;
                mem_sign_extend_o = 1'b0; 
                mem_trim_o     = 2'b00; 
            end
            `OPCODE_B_TYPE : //BEQ,BNE,BLT,BGE,BLTU,BGEU
            begin
                mem_read_o     = 1'b0;
                mem_to_reg_o   = 1'b0;
                alu_op1        = 1'b0;
                alu_op0        = 1'b1;
                mem_write_o    = 4'b0;
                alu_a_src_o    = 2'b00; //ALU OP A: RS1 Data
                alu_b_src_o    = 2'b00; //ALU OP B: RS2 Data
                unc_branch_o   = 1'b0;
                pc_adder_src_o = 1'b0;
                reg_write_o    = 1'b0;
                mem_sign_extend_o = 1'b0;
                mem_trim_o     = 2'b00; 
            end
            `OPCODE_J_TYPE : //JAL
            begin
                mem_read_o     = 1'b0;
                mem_to_reg_o   = 1'b0;
                alu_op1        = 1'b0;
                alu_op0        = 1'b0;
                mem_write_o    = 4'b0;
                alu_a_src_o    = 2'b01; //ALU OP A: PC
                alu_b_src_o    = 2'b10; //ALU OP B: 32'd4  
                unc_branch_o   = 1'b1;
                pc_adder_src_o = 1'b0;
                reg_write_o    = 1'b1;  
                mem_sign_extend_o = 1'b0;
                mem_trim_o     = 2'b00;                        
            end 
            `OPCODE_I_TYPE_JUMP : //JALR
            begin
                mem_read_o     = 1'b0;
                mem_to_reg_o   = 1'b0;
                alu_op1        = 1'b0;
                alu_op0        = 1'b0;
                mem_write_o    = 4'b0;
                alu_a_src_o    = 2'b01; //ALU OP A: PC
                alu_b_src_o    = 2'b10; //ALU OP B: 32'd4     
                unc_branch_o   = 1'b1;
                pc_adder_src_o = 1'b1;
                reg_write_o    = 1'b1;
                mem_sign_extend_o = 1'b0; 
                mem_trim_o     = 2'b0;                               
            end 
            `OPCODE_U_TYPE_LOAD : //LUI
            begin
                mem_read_o     = 1'b0;
                mem_to_reg_o   = 1'b0;
                alu_op1        = 1'b0;
                alu_op0        = 1'b0;
                mem_write_o    = 4'b0;
                alu_a_src_o    = 2'b10; //ALU OP A: 32'b0
                alu_b_src_o    = 2'b01; //ALU OP B: Immediate  
                unc_branch_o   = 1'b0;
                pc_adder_src_o = 1'b0;
                reg_write_o    = 1'b1;
                mem_sign_extend_o = 1'b0; 
                mem_trim_o     = 2'b00;                               
            end  
            `OPCODE_U_TYPE_AUIPC : //AUIPC
            begin
                mem_read_o     = 1'b0;
                mem_to_reg_o   = 1'b0;
                alu_op1        = 1'b0;
                alu_op0        = 1'b0;
                mem_write_o    = 4'b0;
                alu_a_src_o    = 2'b01; //ALU OP A: PC 
                alu_b_src_o    = 2'b01; //ALU OP B: Immediate    
                unc_branch_o   = 1'b0;
                pc_adder_src_o = 1'b0;
                reg_write_o    = 1'b1;  
                mem_sign_extend_o = 1'b0;      
                mem_trim_o     = 2'b00;                        
            end                                                       
            default:
            begin
                mem_read_o     = 1'b0;
                mem_to_reg_o   = 1'b0;
                alu_op1        = 1'b0;
                alu_op0        = 1'b0;
                mem_write_o    = 4'b0;
                alu_a_src_o    = 2'b00;
                alu_b_src_o    = 2'b00;
                unc_branch_o   = 1'b0;
                pc_adder_src_o = 1'b0;
                reg_write_o    = 1'b0;  
                mem_sign_extend_o = 1'b0; 
                mem_trim_o     = 2'b00; 
            end
        endcase
    end
end
endmodule
