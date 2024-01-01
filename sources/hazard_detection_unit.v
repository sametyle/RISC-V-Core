`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2023 10:10:27 PM
// Design Name: 
// Module Name: hazard_detection_unit
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


module hazard_detection_unit(
    input ID_EX_REG_MEM_CTRL_MemRead,
    input [4:0] ID_EX_REG_RD_ADD,
    input [4:0] IF_ID_REG_RS1_ADD,
    input [4:0] IF_ID_REG_RS2_ADD,
    output stall
    );

assign stall = (ID_EX_REG_MEM_CTRL_MemRead && (ID_EX_REG_RD_ADD == IF_ID_REG_RS1_ADD || ID_EX_REG_RD_ADD == IF_ID_REG_RS2_ADD)) ? 1'b1 : 1'b0;

endmodule
