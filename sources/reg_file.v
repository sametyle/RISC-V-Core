`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2023 09:22:50 PM
// Design Name: 
// Module Name: reg_file
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


module reg_file(
    input clk,
    input rst_n,
    
    input [4:0] rs1_addr_i,
    input [4:0] rs2_addr_i,
    input [4:0] rd_addr_i,
    input [31:0] rd_data_i,
    input rd_wr_en_i,
    
    output [31:0] r1_data_o,
    output [31:0] r2_data_o
    );

reg [31:0] regs[31:0]; // 32 Bit length, 32 Registers
integer i;

assign r1_data_o = regs[rs1_addr_i];
assign r2_data_o = regs[rs2_addr_i];
   
initial begin
    regs[0] <= 32'b0;
end
       
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < 32; i = i + 1) begin
            regs[i] <= 0;   
        end 
    end else begin
        if (rd_wr_en_i == 1 && rd_addr_i != 0) begin //r0 is non-writable
            regs[rd_addr_i] <= rd_data_i;
        end else begin
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= regs[i];   
            end 
        end
    end
end 
 
endmodule
