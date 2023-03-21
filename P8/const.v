//  OPCODE
`define OP_rtype   6'b000000
//  load
`define OP_lb      6'b100000
`define OP_lbu     6'b100100
`define OP_lh      6'b100001
`define OP_lhu     6'b100101
`define OP_lw      6'b100011
//  store
`define OP_sb      6'b101000
`define OP_sh      6'b101001
`define OP_sw      6'b101011
//  i-cal
`define OP_addi    6'b001000
`define OP_addiu   6'b001001
`define OP_andi    6'b001100
`define OP_lui     6'b001111
`define OP_ori     6'b001101
`define OP_slti    6'b001010
`define OP_sltiu   6'b001011
`define OP_xori    6'b001110
// branch
`define OP_beq     6'b000100
`define OP_bgez    6'b000001
`define OP_bgtz    6'b000111
`define OP_blez    6'b000110
`define OP_bltz    6'b000001
`define OP_bne     6'b000101

`define OP_bgezal  6'b000001 //new
// jump
`define OP_j       6'b000010
`define OP_jal     6'b000011


// FUNCTION
`define FUNC_add   6'b100000
`define FUNC_addu  6'b100001
`define FUNC_and   6'b100100
`define FUNC_div   6'b011010
`define FUNC_divu  6'b011011
`define FUNC_jalr  6'b001001
`define FUNC_jr    6'b001000
`define FUNC_nor   6'b100111
`define FUNC_or    6'b100101
`define FUNC_sll   6'b000000
`define FUNC_sllv  6'b000100
`define FUNC_slt   6'b101010
`define FUNC_sltu  6'b101011
`define FUNC_sra   6'b000011
`define FUNC_srav  6'b000111
`define FUNC_srl   6'b000010
`define FUNC_srlv  6'b000110
`define FUNC_sub   6'b100010
`define FUNC_subu  6'b100011
`define FUNC_xor   6'b100110


`define FUNC_mfhi  6'b010000
`define FUNC_mflo  6'b010010
`define FUNC_mthi  6'b010001
`define FUNC_mtlo  6'b010011
`define FUNC_mult  6'b011000
`define FUNC_multu 6'b011001


`define RT_bltz    5'b00000
`define RT_bgez    5'b00001
`define RT_bgezal  5'b10001

// ALU
`define ALU_add     4'd0
`define ALU_sub     4'd1
`define ALU_and     4'd2
`define ALU_or      4'd3
`define ALU_xor     4'd4
`define ALU_nor     4'd5
`define ALU_sll     4'd6
`define ALU_srl     4'd7
`define ALU_sra     4'd8
`define ALU_slt     4'd9
`define ALU_sltu    4'd10
`define ALU_lui     4'd11

// RF_data_sel
`define RFWD_ALU    3'd0
`define RFWD_MEM    3'd1
`define RFWD_PC8    3'd2
`define RFWD_CP0    3'd3


// ALUSrc
`define ALUSrc_rs     3'd0
`define ALUSrc_rt     3'd1
`define ALUSrc_imm    3'd2
`define ALUSrc_shamt  3'd3
`define ALUSrc_rs_4_0 3'd4


// MDU
`define MDU_mult    4'd1
`define MDU_multu   4'd2
`define MDU_div     4'd3
`define MDU_divu    4'd4
`define MDU_mfhi    4'd5
`define MDU_mflo    4'd6
`define MDU_mthi    4'd7
`define MDU_mtlo    4'd8

// ALMD
`define ALMD_ALU    1'd0
`define ALMD_MDU    1'd1

// Exceptions
`define EXC_Int     5'd0
`define EXC_AdEL    5'd4
`define EXC_AdES    5'd5
`define EXC_Sysc    5'd8
`define EXC_RI      5'd10
`define EXC_Ov      5'd12
`define DEX_None    5'b11111



`define OP_eret     32'h4200_0018
`define OP_mfc0     11'b010000_00000
`define OP_mtc0     11'b010000_00100