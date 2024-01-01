`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2023 10:56:10 PM
// Design Name: 
// Module Name: imem
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


module ram #( parameter DEPTH = 10)
    (
    input clk,
    input rst_n,
    input [31:0] data_i,
    output [31:0] data_o,
    input [31:0] addr_i,
    input we_i,
    input [3:0] wstrb_i,
    input re_i
    );
    
reg [31:0] mem[2**DEPTH - 1:0];

wire [DEPTH - 1:0] efective_address = addr_i[DEPTH-1:0] >> 2;

assign data_o = mem[efective_address];

initial begin
    $readmemh("output.vh", mem);
end 

always @(posedge clk) begin
    if (we_i) begin
        if (wstrb_i[0])
            mem[efective_address][7:0] <= data_i[7:0];
        if (wstrb_i[1])
            mem[efective_address][15:8] <= data_i[15:8];
        if (wstrb_i[2])
            mem[efective_address][23:16] <= data_i[23:16];
        if (wstrb_i[3])
            mem[efective_address][31:24] <= data_i[31:24];                                    
    end
end
    
endmodule
