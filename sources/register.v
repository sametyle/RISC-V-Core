`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2023 02:36:36 PM
// Design Name: 
// Module Name: register
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


module register #( parameter WIDTH = 32 )
    (
    input clk,
    input rst_n,
    input wr,
    input [WIDTH - 1:0] data_i,
    output reg [WIDTH - 1:0] data_o
    );

always @(posedge clk) begin
    if (~rst_n) begin
        data_o <= {WIDTH{1'b0}};
    end else begin
        if (wr) begin
            data_o <= data_i;
        end else begin
            data_o <= data_o;
        end
    end   
end
endmodule
