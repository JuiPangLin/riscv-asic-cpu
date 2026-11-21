module tb_decoder;
    timeunit 1ns;
    timeprecision 1ps;

    import cpu_pkg::*;

    logic [31:0] instr;
    logic [4:0] rs1, rs2, rd;
    logic [6:0] opcode;
    alu_op_t alu_op;
    logic reg_write, illegal_instr;

    decoder dut (
        .instr(instr),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .alu_op(alu_op),
        .reg_write(reg_write),
        .illegal_instr(illegal_instr)
    );

    task automatic check_r(
        input string name,
        input logic [6:0] funct7,
        input logic [2:0] funct3,
        input alu_op_t expected_op
    );
        begin
            // Encode: operation x5, x1, x2.
            instr = {funct7, 5'd2, 5'd1, funct3, 5'd5, 7'b0110011};
            #1;
            if (rs1 !== 5'd1 || rs2 !== 5'd2 || rd !== 5'd5 ||
                opcode !== 7'b0110011 || alu_op !== expected_op ||
                reg_write !== 1'b1 || illegal_instr !== 1'b0)
                $fatal(1, "FAIL: %s decode", name);
            $display("PASS: %s decode", name);
        end
    endtask

    task automatic check_unsupported(input string name, input logic [31:0] word);
        begin
            instr = word;
            #1;
            if (reg_write !== 1'b0 || illegal_instr !== 1'b1)
                $fatal(1, "FAIL: %s accepted", name);
            $display("PASS: %s rejected", name);
        end
    endtask

    initial begin
        check_r("ADD",  7'b0000000, 3'b000, ALU_ADD);
        check_r("SUB",  7'b0100000, 3'b000, ALU_SUB);
        check_r("AND",  7'b0000000, 3'b111, ALU_AND);
        check_r("OR",   7'b0000000, 3'b110, ALU_OR);
        check_r("XOR",  7'b0000000, 3'b100, ALU_XOR);
        check_r("SLL",  7'b0000000, 3'b001, ALU_SLL);
        check_r("SRL",  7'b0000000, 3'b101, ALU_SRL);
        check_r("SRA",  7'b0100000, 3'b101, ALU_SRA);
        check_r("SLT",  7'b0000000, 3'b010, ALU_SLT);
        check_r("SLTU", 7'b0000000, 3'b011, ALU_SLTU);

        // MUL is outside our frozen RV32I subset.
        check_unsupported("MUL", {7'b0000001, 5'd2, 5'd1, 3'b000, 5'd5, 7'b0110011});
        check_unsupported("bad SLL funct7", {7'b0100000, 5'd2, 5'd1, 3'b001, 5'd5, 7'b0110011});
        check_unsupported("all-zero instr", 32'h0000_0000);
        check_unsupported("bad opcode",     {25'd0, 7'b1111111});
        check_unsupported("lb (not yet)",   {12'd8, 5'd1, 3'b000, 5'd5, 7'b0000011});
        $finish;
    end
endmodule
