module alu (
    input logic [31:0] a,
    input logic [31:0] b,
    input cpu_pkg::alu_op_t alu_op,

    output logic [31:0] result
);

    always_comb begin

        case(alu_op)

            cpu_pkg::ALU_ADD: begin
                result = a + b;
            end

            cpu_pkg::ALU_SUB: begin
                result = a - b;
            end

            cpu_pkg::ALU_AND: begin
                result = a & b;
            end

            cpu_pkg::ALU_OR: begin  
                result = a | b;
            end

            cpu_pkg::ALU_XOR: begin
                result = a ^ b;
            end

            cpu_pkg::ALU_SLL: begin
                result = a << b[4:0];
            end

            cpu_pkg::ALU_SRL: begin
                result = a >> b[4:0];
            end

            cpu_pkg::ALU_SRA: begin
                result = $signed(a) >>> b[4:0];
            end

            cpu_pkg::ALU_SLT: begin 
                result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            end

            cpu_pkg::ALU_SLTU: begin
                result = (a < b) ? 32'd1 : 32'd0;
            end

            default: begin
                result = 32'b0;
            end
        endcase
    end

endmodule