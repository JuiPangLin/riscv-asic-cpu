module tb_test;

    logic a;
    logic b;
    logic c;

    test dut (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin

        a = 0;
        b = 0;
        #10;
        $display("a = %b b = %b y = %b", a, b, y);

        a = 0;
        b = 1;
        #10;
        $display("a = %b b = %b y = %b", a, b, y);

        a = 1;
        b = 0;
        #10;
        $display("a = %b b = %b y = %b", a, b, y);

        a = 1;
        b = 1;
        #10;
        $display("a = %b b = %b y = %b", a, b, y);

        $finish;

    end

endmodule