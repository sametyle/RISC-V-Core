`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2023 09:07:14 PM
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit(
    input [4:0] ID_EX_REG_RS1_ADD,
    input [4:0] ID_EX_REG_RS2_ADD,
    input [4:0] EX_MEM_REG_RD_ADD,
    input [4:0] MEM_WB_REG_RD_ADD,
    input EX_MEM_REG_WB_CTRL_RegWrite,
    input MEM_WB_REG_WB_CTRL_RegWrite,
    output [1:0] ForwardA,
    output [1:0] ForwardB
    );

assign ForwardA = (EX_MEM_REG_WB_CTRL_RegWrite && EX_MEM_REG_RD_ADD != 5'b0 && EX_MEM_REG_RD_ADD == ID_EX_REG_RS1_ADD) ? 2'b10 : 
                  ((MEM_WB_REG_WB_CTRL_RegWrite && MEM_WB_REG_RD_ADD != 5'b0 && MEM_WB_REG_RD_ADD == ID_EX_REG_RS1_ADD) ? 2'b01 : 2'b00);

assign ForwardB = (EX_MEM_REG_WB_CTRL_RegWrite && EX_MEM_REG_RD_ADD != 5'b0 && EX_MEM_REG_RD_ADD == ID_EX_REG_RS2_ADD) ? 2'b10 : 
                  ((MEM_WB_REG_WB_CTRL_RegWrite && MEM_WB_REG_RD_ADD != 5'b0 && MEM_WB_REG_RD_ADD == ID_EX_REG_RS2_ADD) ? 2'b01 : 2'b00);
endmodule
