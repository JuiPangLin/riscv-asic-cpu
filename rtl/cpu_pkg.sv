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

    typedef enum logic [1:0] {
        IMM_I,
        IMM_S,
        IMM_B
    } imm_type_t;
    
endpackage