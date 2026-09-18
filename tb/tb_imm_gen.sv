module tb_imm_gen;
    timeunit 1ns;
    timeprecision 1ps;
    import cpu_pkg::*;
    logic [31:0] instr, imm;
    imm_type_t imm_type;

    imm_gen dut (
        .instr(instr),
        .imm(imm),
        .imm_type(imm_type)
    );

    initial begin
        instr = 32'd0;
        imm_type = IMM_I;

        instr[31:20] = 12'h00C;
        #1
        if (imm === 32'd12) begin
            $display("PASS: I 12");
        end else begin
            $fatal(1, "FAIL: IMM 12");
        end

        instr[31:20] = 12'hFFF;
        #1
        if (imm === 32'hFFFF_FFFF) begin
            $display("PASS: I -1");
        end else begin
            $fatal(1, "FAIL: I -1");
        end

        instr = 32'd0;
        imm_type = IMM_S;
        instr[31:25] = 7'd1;
        instr[11:7] = 5'd12;
        #1
        if (imm === 32'd44) begin
            $display("PASS: S 44");
        end else begin
            $fatal(1, "FAIL: S 44");
        end
        
        instr[31:25] = 7'b1111111;
        instr[11:7] = 5'b11111;
        #1
        if (imm === 32'hFFFF_FFFF) begin
            $display("PASS: S -1");
        end else begin
            $fatal(1, "FAIL: S -1");
        end

        instr = 32'd0;
        imm_type = IMM_B;
        instr[31] = 1'b0;
        instr[7] = 1'b0;
        instr[30:25] = 6'b000000;
        instr[11:8] = 4'b0100;
        
        #1
        if (imm === 32'd8) begin
            $display("PASS: B 8");
        end else begin
            $fatal(1, "FAIL: B 8");
        end
        
        instr[31] = 1'b1;
        instr[7] = 1'b1;
        instr[30:25] = 6'b111111;
        instr[11:8] = 4'b1110;
        
        #1
        if (imm === 32'hFFFF_FFFC) begin
            $display("PASS: B -4");
        end else begin
            $fatal(1, "FAIL: B -4");
        end

        instr[31] = 1'b0;
        instr[7] = 1'b1;
        instr[30:25] = 6'b000000;
        instr[11:8] = 4'b0000;
        
        #1
        if (imm === 32'd2048) begin
            $display("PASS: B 2048");
        end else begin
            $fatal(1, "FAIL: B 2048");
        end
        $finish;
    end
endmodule