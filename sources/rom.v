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


module rom #(parameter DEPTH = 10)
    (
    output [31:0] data_o,
    input [31:0] addr_i
    );
    
reg [31:0] mem[2**DEPTH - 1:0];

wire [DEPTH - 1:0] efective_address = addr_i[DEPTH-1:0] >> 2;

assign data_o = mem[efective_address];

    initial begin
        $readmemh("output.vh", mem);

        // Example program:
               
//        // start:
//        mem[0] = 32'h0083_8133; // add x2 x7 x8

//        // finish:
//        mem[1] = 32'h0011_01b3; // nop (add x0 x0 0)
        
    end    
endmodule
