module tb_imm_gen;
    timeunit 1ns;
    timeprecision 1ps;
    import cpu_pkg::*;

    logic [31:0] instr, imm;
    imm_type_t   imm_type;
    int          errors = 0;

    imm_gen dut (
        .instr(instr),
        .imm_type(imm_type),
        .imm(imm)
    );

    // Apply one instruction word and check the decoded immediate
    task automatic check(input logic [31:0] i, input imm_type_t t,
                         input logic [31:0] expected, input string name);
        instr    = i;
        imm_type = t;
        #1;
        if (imm === expected) begin
            $display("PASS: %-24s imm = 0x%08h", name, imm);
        end else begin
            $display("FAIL: %-24s imm = 0x%08h, expected 0x%08h", name, imm, expected);
            errors++;
        end
    endtask

    initial begin
        // Real instruction encodings (from the RISC-V assembler), so the
        // tests check the actual bit layout, not just hand-placed fields.

        // ---- I-type ----
        check(32'h00C00293, IMM_I, 32'd12,         "addi x5, x0, 12");
        check(32'hFFF00293, IMM_I, 32'hFFFF_FFFF,  "addi x5, x0, -1");

        // ---- S-type ----
        check(32'h0250A623, IMM_S, 32'd44,         "sw x5, 44(x1)");
        check(32'hFE50AFA3, IMM_S, 32'hFFFF_FFFF,  "sw x5, -1(x1)");

        // ---- B-type ----
        check(32'h00208463, IMM_B, 32'd8,          "beq x1, x2, 8");
        check(32'hFE208EE3, IMM_B, 32'hFFFF_FFFC,  "beq x1, x2, -4");
        check(32'h002080E3, IMM_B, 32'd2048,       "beq x1, x2, 2048");

        // ---- U-type ----
        check(32'h123452B7, IMM_U, 32'h1234_5000,  "lui x5, 0x12345");
        check(32'hFFFFF0B7, IMM_U, 32'hFFFF_F000,  "lui x1, 0xFFFFF");
        check(32'h00001517, IMM_U, 32'h0000_1000,  "auipc x10, 0x1");

        // ---- J-type ----  (one test per scrambled field)
        check(32'h008000EF, IMM_J, 32'd8,          "jal x1, 8");       // imm[10:1]
        check(32'h0010006F, IMM_J, 32'd2048,       "jal x0, 2048");    // imm[11]
        check(32'h0000106F, IMM_J, 32'd4096,       "jal x0, 4096");    // imm[19:12]
        check(32'hFFDFF06F, IMM_J, 32'hFFFF_FFFC,  "jal x0, -4");      // sign, all fields

        if (errors == 0) $display("ALL TESTS PASSED");
        else             $fatal(1, "%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule
