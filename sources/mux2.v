`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2023 03:11:46 PM
// Design Name: 
// Module Name: mux
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


module mux2(
    input [31:0] data_a_i,
    input [31:0] data_b_i,
    output [31:0] data_o,
    input sel_i
    );
    
assign data_o = (~sel_i) ? data_a_i : data_b_i;

endmodule
