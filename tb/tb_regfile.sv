module tb_regfile;
    //time initial
    timeunit 1ns;
    timeprecision 1ps;

    //1 bit
    logic clk;
    logic we;

    //5 bit
    logic [4:0] waddr;
    logic [4:0] raddr1;
    logic [4:0] raddr2;

    //32 bit
    logic [31:0] wdata;
    logic [31:0] rdata1;
    logic [31:0] rdata2;

    regfile dut (
        .clk(clk),
        .we(we),
        .waddr(waddr),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .wdata(wdata),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    initial begin
        clk = 0;
    end
    always begin
            #5
            clk = ~clk;
    end

    initial begin
        we = 0;
        raddr1 = 5'd0;
        raddr2 = 5'd0;
        waddr = 5'd0;
        wdata = 32'd0;

        @(negedge clk);

        we = 1'b1;
        waddr = 5'd5;
        wdata = 32'd42;
        raddr1 = 5'd5;

        @(posedge clk);

        #1
        if (rdata1 === 32'd42) begin
            $display("PASS: write/read");
            
        end else begin
            $fatal(1, "Write/read test failed");
        end

        @(negedge clk);

        we = 1'b1;
        waddr = 5'd0;
        wdata = 32'd99;
        raddr1 = 5'd0;
        raddr2 = 5'd0;

        @(posedge clk);
        #1

        if (rdata1 === 32'd0 && rdata2 === 32'd0) begin
            $display("PASS: x0");
        end else begin
            $fatal(1, "FAIL: x0");
        end

        @(negedge clk);

        we = 1'b1;
        waddr = 5'd7;
        wdata = 32'd99;
        raddr1 = 5'd5;
        raddr2 = 5'd7;

        @(posedge clk);
        #1

        if (rdata1 === 32'd42 && rdata2 === 32'd99) begin
            $display("PASS: x5 & x7");
        end else begin
            $fatal(1, "FAIL:x5 & x7");
        end

        @(negedge clk);

        we = 1'b1;
        waddr = 5'd5;
        wdata = 32'd123;

        @(posedge clk);
        #1

        if (rdata1 === 32'd123 && rdata2 === 32'd99) begin
            $display("PASS: overwrite");
        end else begin
            $fatal(1, "FAIL: overwrite");
        end

        @(negedge clk);

        we = 1'b0;
        waddr = 5'd5;
        wdata = 32'd77;

        @(posedge clk);
        #1

        if (rdata1 === 32'd123 && rdata2 === 32'd99) begin
            $display("PASS: write disabled");
        end else begin
            $fatal(1, "FAIL: write disabled");
        end
        
        @(negedge clk);
        
        we = 1;
        waddr = 5'd7;
        wdata = 32'd200;
        raddr1 = 5'd7;
        raddr2 = 5'd5;

        #1

        if (rdata1 === 32'd99 && rdata2 === 32'd123) begin
            $display("PASS: read/write timing");
        end else begin
            $fatal(1, "FAIL: read/wrtie timing");
        end

        @(posedge clk);
        #1

        if (rdata1 === 32'd200 && rdata2 === 32'd123) begin
            $display("PASS: read/write timing");
        end else begin
            $fatal(1, "FAIL: read/wrtie timing");
        end

        $finish;
    end
endmodule