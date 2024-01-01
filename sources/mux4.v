`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2023 10:43:26 PM
// Design Name: 
// Module Name: mux4
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


module mux4(
    input [31:0] data_a_i,
    input [31:0] data_b_i,
    input [31:0] data_c_i,
    input [31:0] data_d_i,
    output [31:0] data_o,
    input [1:0] sel_i
    );
    
assign data_o = (sel_i == 2'b00) ? data_a_i : ((sel_i == 2'b01) ? data_b_i : ((sel_i == 2'b10) ? data_c_i : data_d_i));

endmodule

