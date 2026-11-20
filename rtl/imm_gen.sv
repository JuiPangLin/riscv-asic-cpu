module imm_gen (
    input  logic [31:0]          instr,
    input  cpu_pkg::imm_type_t   imm_type,
    output logic [31:0]          imm
);
    always_comb begin
        case (imm_type)

            // I-type: imm[11:0] = instr[31:20], sign-extended
            cpu_pkg::IMM_I: begin
                imm = {{20{instr[31]}}, instr[31:20]};
            end

            // S-type: imm[11:5] = instr[31:25], imm[4:0] = instr[11:7]
            cpu_pkg::IMM_S: begin
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            end

            // B-type: imm[12|10:5] = instr[31:25], imm[4:1|11] = instr[11:7]
            cpu_pkg::IMM_B: begin
                imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            end

            // U-type: imm[31:12] = instr[31:12], low 12 bits are zero.
            // No sign extension needed: the field already fills bit 31.
            cpu_pkg::IMM_U: begin
                imm = {instr[31:12], 12'b0};
            end

            // J-type: imm[20|10:1|11|19:12] = instr[31:12]
            //   instr[31]    -> imm[20]   (sign bit)
            //   instr[30:21] -> imm[10:1]
            //   instr[20]    -> imm[11]
            //   instr[19:12] -> imm[19:12]  (same position, not moved)
            // 11 sign bits + 1 + 8 + 1 + 10 + 1 zero = 32 bits
            cpu_pkg::IMM_J: begin
                imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
            end

            default: begin
                imm = 32'd0;
            end
        endcase
    end
endmodule
