module imm_gen (
    input logic [31:0] instr,
    input cpu_pkg::imm_type_t imm_type,
    output logic [31:0] imm
);
    always_comb begin
        case(imm_type)

            cpu_pkg::IMM_I: begin
                imm = {{20{instr[31]}}, instr[31:20]};
            end
            cpu_pkg::IMM_S: begin
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            end
            cpu_pkg::IMM_B: begin
                imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            end
            default: begin
                imm = 32'd0;
            end
        endcase
    end
endmodule