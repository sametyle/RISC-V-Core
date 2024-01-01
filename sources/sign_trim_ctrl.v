`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2023 04:33:56 PM
// Design Name: 
// Module Name: sign_trim_ctrl
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


module sign_trim_ctrl(
    input sign_extend_i,
    input [1:0] trim_i,
    input [31:0] data_i,
    output [31:0] data_o
    );

wire [31:0] data_byte = {{24{data_i[7] && sign_extend_i}}, (data_i[7:0])};
wire [31:0] data_half = {{16{data_i[15] && sign_extend_i}}, (data_i[15:0])};
wire [31:0] data_word = data_i;

assign data_o = (trim_i == 2'b00) ? data_word : ((trim_i == 2'b01) ? data_half : ((trim_i == 2'b10) ? data_byte : data_word));

endmodule
