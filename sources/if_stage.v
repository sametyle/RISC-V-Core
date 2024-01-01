`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 02:32:23 PM
// Design Name: 
// Module Name: if_stage
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


module if_stage(
    input clk,
    input rst_n,
    
    input id_stage_stall,
    input ex_stage_flush,
    
    input ex_stage_branch,
    input [31:0] ex_stage_branch_address,
    
    //instruction memory interface
    input [31:0] inst_mem_data_i,
    output [31:0] inst_mem_addr_o,
    
    //if_id_reg
    output reg [31:0] if_id_reg_pc,
    output reg [31:0] if_id_reg_inst
    );
    
    
wire        mux_pc_in_sel = ex_stage_branch;
wire [31:0] mux_pc_in_a;  //pc + 4
wire [31:0] mux_pc_in_b = ex_stage_branch_address; //
//wire [31:0] mux_pc_in_c = ex_stage_branch_address; //beq,bnq,bge,blt,bgeu,bltu
//wire [31:0] mux_pc_in_d = 32'b0;

wire [31:0] pc_in;
wire [31:0] pc_out;
wire        pc_wr = ~id_stage_stall;

assign inst_mem_addr_o = pc_out;

always @(posedge clk, negedge rst_n)
begin
    if (~rst_n) begin
        if_id_reg_pc <= 32'b0;
        if_id_reg_inst <= 32'b0;        
    end else begin
        if (id_stage_stall) begin
            if_id_reg_pc <= if_id_reg_pc;
            if_id_reg_inst <= if_id_reg_inst;
        end else if (ex_stage_flush) begin
            if_id_reg_pc <= pc_out;
            if_id_reg_inst <= 32'h00000013;         
        end else begin
            if_id_reg_pc <= pc_out;
            if_id_reg_inst <= inst_mem_data_i;        
        end
    end
end

//Program counter
register #(.WIDTH(32)) pc_ins
(
	.clk(clk),
	.rst_n(rst_n),
	.data_i(pc_in),
	.data_o(pc_out),
	.wr(pc_wr)
);
   
mux2 mux2_pc_in(
   .data_a_i(mux_pc_in_a),
   .data_b_i(mux_pc_in_b),
   .data_o(pc_in),
   .sel_i(mux_pc_in_sel)
); 

adder adder_mux_pc_in_a(
    .data_a_i(pc_out),
    .data_b_i(32'd4),
    .data_o(mux_pc_in_a)
    );  

endmodule
