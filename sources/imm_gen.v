`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2023 03:06:04 PM
// Design Name: 
// Module Name: imm_gen
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


module imm_gen(
    input [31:0] inst_i,
    input [4:0] type_i,
    output reg signed [31:0] imm_val_o
    );

wire [31:0] I = inst_i;

always @*
begin
    casex (type_i) //Priority encoder
        5'b1xxxx: //I TYPE
            imm_val_o = {{21{I[31]}},I[30:20]};   
        5'b01xxx: //S TYPE
            imm_val_o = {{21{I[31]}},I[30:25],I[11:7]}; 
        5'b001xx: //B TYPE
            imm_val_o = {{20{I[31]}},I[7],I[30:25],I[11:8],1'b0}; 
        5'b0001x: //J TYPE
            imm_val_o = {{12{I[31]}},I[19:12],I[20],I[30:21],1'b0}; 
        5'b00001: //U TYPE
            imm_val_o = {I[31:12],12'b0}; 
        default:
            imm_val_o = 32'd0;
    endcase
end
    
endmodule
