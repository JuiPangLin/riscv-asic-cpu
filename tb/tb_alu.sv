module tb_alu;

    import cpu_pkg::*;  // import everything from cpu_pkg

    logic [31:0] a;
    logic [31:0] b;
    alu_op_t     alu_op;
    logic [31:0] result;

    alu dut (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result)
    );

        task check_alu(
        input alu_op_t op,
        input logic [31:0] test_a,
        input logic [31:0] test_b,
        input logic [31:0] expected,
        input string test_name
    );
        begin
            a      = test_a;
            b      = test_b;
            alu_op = op;

            #1;

            if (result === expected)
                $display("PASS: %s", test_name);
            else
                $display(
                    "FAIL: %s | a=%h b=%h expected=%h got=%h",
                    test_name, test_a, test_b, expected, result
                );
        end
    endtask

    initial begin

        check_alu(ALU_ADD,  32'd10, 32'd20, 32'd30, "ADD");
        check_alu(ALU_SUB,  32'd20, 32'd7,  32'd13, "SUB");

        check_alu(ALU_AND,  32'hF0F0, 32'h0FF0, 32'h00F0, "AND");
        check_alu(ALU_OR,   32'hF000, 32'h0F00, 32'hFF00, "OR");
        check_alu(ALU_XOR,  32'hAAAA, 32'h5555, 32'hFFFF, "XOR");

        check_alu(ALU_SLL,  32'd1,  32'd4,  32'd16, "SLL");
        check_alu(ALU_SRL,  32'd16, 32'd2,  32'd4,  "SRL");

        check_alu(
            ALU_SRA,
            32'h80000000,
            32'd1,
            32'hC0000000,
            "SRA"
        );

        check_alu(
            ALU_SLT,
            32'hFFFFFFFF,
            32'd1,
            32'd1,
            "SLT"
        );

        check_alu(
            ALU_SLTU,
            32'hFFFFFFFF,
            32'd1,
            32'd0,
            "SLTU"
        );

        $finish;

    end

endmodule