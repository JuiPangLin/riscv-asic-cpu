module decoder (
    input  logic [31:0]          instr,

    output logic [4:0]           rs1,
    output logic [4:0]           rs2,
    output logic [4:0]           rd,
    output logic [6:0]           opcode,

    output cpu_pkg::alu_op_t     alu_op,
    output cpu_pkg::imm_type_t   imm_type,
    output cpu_pkg::wb_sel_t     wb_sel,
    output logic                 reg_write,
    output logic                 illegal_instr,
    output logic                 alu_src,      // 0 = rs2, 1 = immediate
    output logic                 mem_read,
    output logic                 mem_write,
    output logic                 branch,
    output logic                 jump
);

    always_comb begin
        // Register fields are in the same place in every format
        rs1    = instr[19:15];
        rs2    = instr[24:20];
        rd     = instr[11:7];
        opcode = instr[6:0];

        // Defaults: a "do nothing" instruction.
        // Unsupported encodings must not write a register or touch memory.
        alu_op        = cpu_pkg::ALU_ADD;
        alu_src       = 1'b0;
        imm_type      = cpu_pkg::IMM_I;
        wb_sel        = cpu_pkg::WB_ALU;
        reg_write     = 1'b0;
        mem_read      = 1'b0;
        mem_write     = 1'b0;
        branch        = 1'b0;
        jump          = 1'b0;
        illegal_instr = 1'b1;

        case (opcode)

            // ---------------- R-type: rd = rs1 op rs2 ----------------
            7'b0110011: begin
                // {funct7, funct3} selects the operation
                case ({instr[31:25], instr[14:12]})
                    10'b0000000_000: begin alu_op = cpu_pkg::ALU_ADD;  reg_write = 1'b1; illegal_instr = 1'b0; end
                    10'b0100000_000: begin alu_op = cpu_pkg::ALU_SUB;  reg_write = 1'b1; illegal_instr = 1'b0; end
                    10'b0000000_111: begin alu_op = cpu_pkg::ALU_AND;  reg_write = 1'b1; illegal_instr = 1'b0; end
                    10'b0000000_110: begin alu_op = cpu_pkg::ALU_OR;   reg_write = 1'b1; illegal_instr = 1'b0; end
                    10'b0000000_100: begin alu_op = cpu_pkg::ALU_XOR;  reg_write = 1'b1; illegal_instr = 1'b0; end
                    10'b0000000_001: begin alu_op = cpu_pkg::ALU_SLL;  reg_write = 1'b1; illegal_instr = 1'b0; end
                    10'b0000000_101: begin alu_op = cpu_pkg::ALU_SRL;  reg_write = 1'b1; illegal_instr = 1'b0; end
                    10'b0100000_101: begin alu_op = cpu_pkg::ALU_SRA;  reg_write = 1'b1; illegal_instr = 1'b0; end
                    10'b0000000_010: begin alu_op = cpu_pkg::ALU_SLT;  reg_write = 1'b1; illegal_instr = 1'b0; end
                    10'b0000000_011: begin alu_op = cpu_pkg::ALU_SLTU; reg_write = 1'b1; illegal_instr = 1'b0; end
                    default: ;   // unsupported: keep safe defaults
                endcase
            end

            // ---------------- I-type ALU: rd = rs1 op imm ----------------
            7'b0010011: begin
                alu_src  = 1'b1;
                imm_type = cpu_pkg::IMM_I;

                case (instr[14:12])   // funct3 only; upper bits are part of the immediate
                    3'b000: begin alu_op = cpu_pkg::ALU_ADD;  reg_write = 1'b1; illegal_instr = 1'b0; end  // addi
                    3'b111: begin alu_op = cpu_pkg::ALU_AND;  reg_write = 1'b1; illegal_instr = 1'b0; end  // andi
                    3'b110: begin alu_op = cpu_pkg::ALU_OR;   reg_write = 1'b1; illegal_instr = 1'b0; end  // ori
                    3'b100: begin alu_op = cpu_pkg::ALU_XOR;  reg_write = 1'b1; illegal_instr = 1'b0; end  // xori
                    3'b010: begin alu_op = cpu_pkg::ALU_SLT;  reg_write = 1'b1; illegal_instr = 1'b0; end  // slti
                    3'b011: begin alu_op = cpu_pkg::ALU_SLTU; reg_write = 1'b1; illegal_instr = 1'b0; end  // sltiu

                    3'b001: begin   // slli: only funct7 = 0000000 is valid
                        if (instr[31:25] == 7'b0000000) begin
                            alu_op        = cpu_pkg::ALU_SLL;
                            reg_write     = 1'b1;
                            illegal_instr = 1'b0;
                        end
                    end

                    3'b101: begin   // srli / srai: funct7 decides
                        if (instr[31:25] == 7'b0000000) begin
                            alu_op        = cpu_pkg::ALU_SRL;
                            reg_write     = 1'b1;
                            illegal_instr = 1'b0;
                        end else if (instr[31:25] == 7'b0100000) begin
                            alu_op        = cpu_pkg::ALU_SRA;
                            reg_write     = 1'b1;
                            illegal_instr = 1'b0;
                        end
                    end

                    default: ;
                endcase
            end

            // ---------------- Loads: rd = mem[rs1 + imm] ----------------
            7'b0000011: begin
                alu_src  = 1'b1;              // address = rs1 + immediate
                imm_type = cpu_pkg::IMM_I;

                case (instr[14:12])
                    3'b010: begin             // lw
                        alu_op        = cpu_pkg::ALU_ADD;
                        mem_read      = 1'b1;
                        wb_sel        = cpu_pkg::WB_MEM;
                        reg_write     = 1'b1;
                        illegal_instr = 1'b0;
                    end
                    default: ;                // lb, lh, lbu, lhu: later
                endcase
            end

            default: ;   // other opcodes: keep safe defaults

        endcase
    end
endmodule
