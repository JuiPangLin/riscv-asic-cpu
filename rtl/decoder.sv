module decoder (
    input  logic [31:0] instr,

    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd,
    output logic [6:0] opcode,

    output cpu_pkg::alu_op_t alu_op,
    output logic             reg_write,
    output logic             illegal_instr
);

    always_comb begin
        rs1    = instr[19:15];
        rs2    = instr[24:20];
        rd     = instr[11:7];
        opcode = instr[6:0];

        // Unsupported encodings must not write a register.
        alu_op        = cpu_pkg::ALU_ADD;
        reg_write     = 1'b0;
        illegal_instr = 1'b1;

        if (opcode == 7'b0110011) begin
            // {funct7, funct3} selects one of the supported R-type operations.
            case ({instr[31:25], instr[14:12]})
                10'b0000000_000: begin
                    alu_op = cpu_pkg::ALU_ADD;
                    reg_write = 1'b1;
                    illegal_instr = 1'b0;
                end
                10'b0100000_000: begin
                    alu_op = cpu_pkg::ALU_SUB;
                    reg_write = 1'b1;
                    illegal_instr = 1'b0;
                end
                10'b0000000_111: begin
                    alu_op = cpu_pkg::ALU_AND;
                    reg_write = 1'b1;
                    illegal_instr = 1'b0;
                end
                10'b0000000_110: begin
                    alu_op = cpu_pkg::ALU_OR;
                    reg_write = 1'b1;
                    illegal_instr = 1'b0;
                end
                10'b0000000_100: begin
                    alu_op = cpu_pkg::ALU_XOR;
                    reg_write = 1'b1;
                    illegal_instr = 1'b0;
                end
                10'b0000000_001: begin
                    alu_op = cpu_pkg::ALU_SLL;
                    reg_write = 1'b1;
                    illegal_instr = 1'b0;
                end
                10'b0000000_101: begin
                    alu_op = cpu_pkg::ALU_SRL;
                    reg_write = 1'b1;
                    illegal_instr = 1'b0;
                end
                10'b0100000_101: begin
                    alu_op = cpu_pkg::ALU_SRA;
                    reg_write = 1'b1;
                    illegal_instr = 1'b0;
                end
                10'b0000000_010: begin
                    alu_op = cpu_pkg::ALU_SLT;
                    reg_write = 1'b1;
                    illegal_instr = 1'b0;
                end
                10'b0000000_011: begin
                    alu_op = cpu_pkg::ALU_SLTU;
                    reg_write = 1'b1;
                    illegal_instr = 1'b0;
                end
                default: begin
                    // Keep the safe defaults for unsupported combinations.
                end
            endcase
        end
    end
endmodule
