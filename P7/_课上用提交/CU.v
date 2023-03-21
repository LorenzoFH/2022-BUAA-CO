`timescale 1ns / 1ps

`include "const.v"
module CU(
    input [31:0] instr,
    input [31:0] a,
    input [31:0] b, //for D stage : jump & branch
    input [31:0] DM_write_addr,

    output branch,
    output jump,
    output [31:0] jump_addr,
    output j_r,
    output clear_delay, //for D stage : jump & branch

    // New instrctions
    output bgezal,
    input bgezal_en_in,
    output bgezal_en_out,

    //
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [15:0] imm,
    output [25:0] addr,

    output load,
    output store,
    output r_cal,
    output i_cal,
    output shift_s,
    output shift_v,
    output branch_ins,

    output lw,
    output lh,
    output lb,
    output sw,
    output sh,
    output sb,
    
    
    output md,
    output mt,
    output mf,
    
    output IMM_EXT_TYPE,
    output MemtoReg,
    output MemWrite,
    output [31:0] ALUControl,
    output [2:0] ALUSrcA,
    output [2:0] ALUSrcB,
    output [2:0] RF_data_sel,
    output [4:0] RF_write_addr,
    output RegWrite,
    output [3:0] MDU_type,
    output reg [3:0] DM_data_byteen,
    output reg [3:0] DM_rdata_byteen,

    // Exception
    output EXCRI,
    output ALUOv_Dectect,
    output ALUDMOv_Dectect,
    output mfc0,
    output mtc0,
    output eret,
    output syscall,
    output CP0WE,
    output [4:0] CP0WA
	);
    wire [5:0] opcode = instr[31:26],
               func = instr[5:0];
    assign rs = instr[25:21],
           rt = instr[20:16],
           rd = instr[15:11],
           imm = instr[15:0],
           addr = instr[25:0];
    
    // Load
    assign lb    = (opcode == `OP_lb   );
    assign lh    = (opcode == `OP_lh   );
    assign lw    = (opcode == `OP_lw   );
    // Store
    assign sb    = (opcode == `OP_sb   );
    assign sh    = (opcode == `OP_sh   );
    assign sw    = (opcode == `OP_sw   );
    // R-R-cal
    wire add   = (opcode == `OP_rtype && func == `FUNC_add  );
    wire addu  = (opcode == `OP_rtype && func == `FUNC_addu );
    wire sub   = (opcode == `OP_rtype && func == `FUNC_sub  );
    wire subu  = (opcode == `OP_rtype && func == `FUNC_subu );
    wire slt   = (opcode == `OP_rtype && func == `FUNC_slt  );
    wire sltu  = (opcode == `OP_rtype && func == `FUNC_sltu );
    wire sll   = (opcode == `OP_rtype && func == `FUNC_sll  );
    wire srl   = (opcode == `OP_rtype && func == `FUNC_srl  );
    wire sra   = (opcode == `OP_rtype && func == `FUNC_sra  );
    wire sllv  = (opcode == `OP_rtype && func == `FUNC_sllv );
    wire srlv  = (opcode == `OP_rtype && func == `FUNC_srlv );
    wire srav  = (opcode == `OP_rtype && func == `FUNC_srav );
    wire And   = (opcode == `OP_rtype && func == `FUNC_and  );
    wire Or    = (opcode == `OP_rtype && func == `FUNC_or   );
    wire Xor   = (opcode == `OP_rtype && func == `FUNC_xor  );
    wire Nor   = (opcode == `OP_rtype && func == `FUNC_nor  );


assign r_cal  = add | addu | sub  | subu | slt  | sltu |
                sll | srl  | sra  | sllv | srlv | srav | 
                And | Or   | Xor  | Nor; //  ~(jr jalr mt mf md)

    // R-I-cal
    wire addi  = (opcode == `OP_addi );
    wire addiu = (opcode == `OP_addiu);
    wire andi  = (opcode == `OP_andi );
    wire ori   = (opcode == `OP_ori  );
    wire xori  = (opcode == `OP_xori );
    wire lui   = (opcode == `OP_lui  );
    wire slti  = (opcode == `OP_slti );
    wire sltiu = (opcode == `OP_sltiu);
    // Branch
    wire beq   = (opcode == `OP_beq  );
    wire bne   = (opcode == `OP_bne  );
    wire blez  = (opcode == `OP_blez );
    wire bgtz  = (opcode == `OP_bgtz );
    wire bltz  = (opcode == `OP_bltz && rt == `RT_bltz);
    wire bgez  = (opcode == `OP_bgez && rt == `RT_bgez);

    assign bgezal = (opcode == `OP_bgezal && rt == `RT_bgezal);
    // Jump
    wire j     = (opcode == `OP_j    );
    wire jal   = (opcode == `OP_jal  );
    wire jalr  = (opcode == `OP_rtype && func == `FUNC_jalr );
    wire jr    = (opcode == `OP_rtype && func == `FUNC_jr   );
    // Tranfer
    wire mult  = (opcode == `OP_rtype && func == `FUNC_mult );
    wire multu = (opcode == `OP_rtype && func == `FUNC_multu);
    wire div   = (opcode == `OP_rtype && func == `FUNC_div  );
    wire divu  = (opcode == `OP_rtype && func == `FUNC_divu );

    wire mfhi  = (opcode == `OP_rtype && func == `FUNC_mfhi );
    wire mflo  = (opcode == `OP_rtype && func == `FUNC_mflo );
    wire mthi  = (opcode == `OP_rtype && func == `FUNC_mthi );
    wire mtlo  = (opcode == `OP_rtype && func == `FUNC_mtlo );
    // Privilege
    assign mfc0 = instr[31:21] == `OP_mfc0;
    assign mtc0 = instr[31:21] == `OP_mtc0;
    assign eret  = instr == `OP_eret;
    
    assign syscall = ((opcode == 6'b000000) && (func==6'b001100));

    assign load   = lw | lh | lb;
    assign store  = sw | sh | sb;


    assign r_cal  = add | addu | sub | subu | slt | sltu |
                    sll | sllv | srl | srlv | sra | srav |
                    And | Or | Xor | Nor; //  ~(jr jalr mt mf md)

    assign i_cal = addi | addiu | andi | ori| xori | slti | sltiu | lui ;

    assign shift_s = sll | srl | sra;
    assign shift_v = sllv | srlv | srav;
    
    assign md = mult | multu | div | divu;
    assign mt = mtlo | mthi;
    assign mf = mflo | mfhi;

    assign branch_ins = beq | bne | blez | bgtz | bgez | bltz;
    assign jump = j | jal | jalr | jr;
    assign j_r = jalr | jr;

    // Exception

    assign EXCRI = !(load | store | r_cal | i_cal | branch_ins |
                     jump | md | mt | mf | mfc0 | mtc0 | eret | syscall);

    assign CP0WE = mtc0 | syscall;
    assign CP0WA =  (syscall) ? 14 : rd;

    assign ALUOv_Dectect = add | addi | sub;
    assign ALUDMOv_Dectect = load | store;
    
     //D stage
    assign branch = beq  ? a==b :
                    bne  ? a!=b :
                    blez ? $signed(a)<=0 :
                    bgtz ? $signed(a)>0 :
                    bltz ? $signed(a)<0 :
                    bgez ? $signed(a)>=0 :
                    bgezal ? $signed(a)>=0 :
                    0;

    assign bgezal_en_out = bgezal && $signed(a)>=0; //this signal should be piped

    assign jump = j | jal | jalr | jr;

    assign jump_addr = (j) ?    {4'b0,instr[25:0],2'b0} :
                       (jal) ?  {4'b0,instr[25:0],2'b0} :
                       (jr) ? a :
                       (jalr) ? a :
                       0;

    wire link = (jal | jalr | bgezal_en_in);

    wire [31:0] link_addr = (jal|bgezal_en_in)  ? 31 :
                            (jalr) ? rd :
                             0;

    assign clear_delay = eret;



    // E stage

    assign ALUSrcA = (shift_s | shift_v) ? `ALUSrc_rt : `ALUSrc_rs; 

    assign ALUSrcB = shift_s ? `ALUSrc_shamt  :
                     shift_v ? `ALUSrc_rs_4_0 :
                    (r_cal && !shift_s && !shift_v) ? `ALUSrc_rt  : 
                    (i_cal | load | store)          ? `ALUSrc_imm :
                                                      `ALUSrc_rt  ;

    assign ALUControl = (sub | subu)   ? `ALU_sub  :
                        (And | andi)   ? `ALU_and  :
                        (Or | ori)     ? `ALU_or   :
                        (Xor | xori)   ? `ALU_xor  :
                        (Nor)          ? `ALU_nor  :
                        (sll | sllv)   ? `ALU_sll  :
                        (srl | srlv)   ? `ALU_srl  :
                        (sra | srav)   ? `ALU_sra  :
                        (slt | slti)   ? `ALU_slt  :
                        (sltu | sltiu) ? `ALU_sltu :
                        (lui)          ? `ALU_lui  :
                                         `ALU_add;

    assign MDU_type  =  (mult)  ? `MDU_mult     :
                        (multu) ? `MDU_multu    :
                        (div)   ? `MDU_div      :
                        (divu)  ? `MDU_divu     :
                        (mfhi)  ? `MDU_mfhi     :
                        (mflo)  ? `MDU_mflo     :
                        (mthi)  ? `MDU_mthi     :
                        (mtlo)  ? `MDU_mtlo     :
                         0;

    // M stage
    assign MemtoReg = load;
    assign MemWrite = store;

    // W stage
    assign RegWrite = load | r_cal | i_cal | mf
                      | jal | jalr | mfc0; //rtype  mult  div



    assign RF_write_addr = (r_cal|jalr|mf) ? rd : 
                           (jal) ? 31 :
                           (i_cal|load|mfc0) ? rt :
                           0;

    assign RF_data_sel = (jal|jalr|bgezal_en_in) ?  `RFWD_PC8 :
                         load  ?                    `RFWD_MEM : 
                         mfc0  ?                    `RFWD_CP0 :
                                                    `RFWD_ALU ;

                                         
    assign IMM_EXT_TYPE = (lui|ori|andi) ? 0 : 1;

    // DM signals
    always @(*) begin
    	if(sw)begin
        	DM_data_byteen <= 4'b1111;
   	 	end
    	else if(sh)begin
        	case(DM_write_addr[1:0])
				0 : DM_data_byteen <= 4'b0011;
				2 : DM_data_byteen <= 4'b1100;
        	endcase
    	end
    	else if(sb)begin
			case(DM_write_addr[1:0])
				0 : DM_data_byteen <= 4'b0001;
				1 : DM_data_byteen <= 4'b0010;
				2 : DM_data_byteen <= 4'b0100;
				3 : DM_data_byteen <= 4'b1000;
        	endcase
    	end
        else DM_data_byteen <= 4'b0000;
    end

    always @(*) begin
    	if(lw)begin
        	DM_rdata_byteen <= 4'b1111;
   	 	end
    	else if(lh)begin
        	case(DM_write_addr[1:0])
				0 : DM_rdata_byteen <= 4'b0011;
				2 : DM_rdata_byteen <= 4'b1100;
        	endcase
    	end
    	else if(lb)begin
			case(DM_write_addr[1:0])
				0 : DM_rdata_byteen <= 4'b0001;
				1 : DM_rdata_byteen <= 4'b0010;
				2 : DM_rdata_byteen <= 4'b0100;
				3 : DM_rdata_byteen <= 4'b1000;
        	endcase
    	end
        else DM_rdata_byteen <= 4'b0000;
    end

endmodule
