//////////////////////////////////
//  RISC-V ISA OPCODE DEFINES  //      
///////////////////////////////// 

`define OPCODE_R_TYPE           7'b0110011 //ADD,SUB,SLL,SLT,SLTU,XOR,SRL,SRA,OR,AND (OK)
`define OPCODE_I_TYPE_LOAD      7'b0000011 //LB,LH,LW,LBU,LHU (OK)
`define OPCODE_I_TYPE_ARITH     7'b0010011 //ADDI,SLTI,SLTIU,XORI,ORI,ANDI,SLLI,SRLI,SRAI (OK)
`define OPCODE_I_TYPE_JUMP      7'b1100111 //JALR (OK)
`define OPCODE_I_TYPE_CSR       7'b1110011 //CSRRW,CSRRS,CSRRC,CSRRWI,CSRRSI,CSRRCI
`define OPCODE_S_TYPE           7'b0100011 //SB,SH,SW (OK)
`define OPCODE_B_TYPE           7'b1100011 //BEQ,BNE,BLT,BGE,BLTU,BGEU (OK)
`define OPCODE_J_TYPE           7'b1101111 //JAL (OK)
`define OPCODE_U_TYPE_LOAD      7'b0110111 //LUI (OK)
`define OPCODE_U_TYPE_AUIPC     7'b0010111 //AUIPC (OK)


///////////////////////////////////
//  ALU CONTROL OPCODE DEFINES  //      
//////////////////////////////////

`define ALU_AND                 4'b0000 //AND
`define ALU_OR                  4'b0001 //OR
`define ALU_ADD                 4'b0010 //ADD
`define ALU_XOR                 4'b0011 //XOR
`define ALU_SLL                 4'b0100 //SLL
`define ALU_SRL                 4'b0101 //SRL
`define ALU_SUB                 4'b0110 //SUB
`define ALU_SRA                 4'b0111 //SRA
`define ALU_SLT                 4'b1000 //SLT
`define ALU_SLTU                4'b1001 //SLTU

`define ALU_BEQ                 4'b1010 //BEQ
`define ALU_BNQ                 4'b1011 //BNQ
`define ALU_BLT                 4'b1100 //BLT
`define ALU_BGE                 4'b1101 //BGE
`define ALU_BLTU                4'b1110 //BLTU
`define ALU_BGEU                4'b1111 //BGEU

`define ALU_DEFAULT             `ALU_AND //DEFAULT OP

//NOP
`define NOP                     32'h00000013 //add x0, x0, x0