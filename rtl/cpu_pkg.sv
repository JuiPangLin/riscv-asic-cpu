package cpu_pkg;

    typedef enum logic [3:0] {
        ALU_ADD,
        ALU_SUB,
        ALU_AND,
        ALU_OR,
        ALU_XOR,
        ALU_SLL,
        ALU_SRL,
        ALU_SRA,
        ALU_SLT,
        ALU_SLTU
    } alu_op_t;

    // Widened from 2 to 3 bits: 5 immediate formats no longer fit in 2 bits
    typedef enum logic [2:0] {
        IMM_I,   // addi, lw, jalr       : instr[31:20]
        IMM_S,   // sw                   : instr[31:25], instr[11:7]
        IMM_B,   // beq, bne, ...        : scrambled, bit 0 always 0
        IMM_U,   // lui, auipc           : instr[31:12] in the upper 20 bits
        IMM_J    // jal                  : scrambled, bit 0 always 0
    } imm_type_t;

    // Which value is written back into rd
    typedef enum logic [1:0] {
        WB_ALU,   // R-type, I-type ALU: the ALU result
        WB_MEM,   // loads: data read from memory
        WB_PC4    // jal, jalr: return address PC+4
    } wb_sel_t;
    
endpackage
