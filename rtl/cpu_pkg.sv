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

    typedef enum logic [2:0] {
        IMM_I,   // addi, lw, jalr       : instr[31:20]
        IMM_S,   // sw                   : instr[31:25], instr[11:7]
        IMM_B,   // beq, bne, ...        : scrambled, bit 0 always 0
        IMM_U,   // lui, auipc           : instr[31:12] in the upper 20 bits
        IMM_J    // jal                  : scrambled, bit 0 always 0    
    } imm_type_t;
    
endpackage