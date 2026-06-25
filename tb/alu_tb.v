// alu_tb.v - Testbench for ALU module

`timescale 1ns/1ps

module alu_tb;

    // Testbench signals
    reg  [7:0] a;
    reg  [7:0] b;
    reg  [1:0] alu_op;
    wire [7:0] result;

    // Instantiate ALU
    alu uut (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result)
    );

    // Test procedure
    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        $display("Starting ALU testbench...");
        $display("Time\tOP\tA\tB\tResult\tExpected");
        $display("----\t--\t--\t--\t------\t--------");

        // Test ADD
        alu_op = 2'b00; a = 8'd15; b = 8'd10; #10;
        $display("%0t\tADD\t%d\t%d\t%d\t%d %s", $time, a, b, result, 8'd25, 
                 (result == 8'd25) ? "PASS" : "FAIL");

        alu_op = 2'b00; a = 8'd255; b = 8'd1; #10;
        $display("%0t\tADD\t%d\t%d\t%d\t%d %s", $time, a, b, result, 8'd0, 
                 (result == 8'd0) ? "PASS (overflow)" : "FAIL");

        // Test SUB
        alu_op = 2'b01; a = 8'd20; b = 8'd5; #10;
        $display("%0t\tSUB\t%d\t%d\t%d\t%d %s", $time, a, b, result, 8'd15, 
                 (result == 8'd15) ? "PASS" : "FAIL");

        alu_op = 2'b01; a = 8'd5; b = 8'd10; #10;
        $display("%0t\tSUB\t%d\t%d\t%d\t%d %s", $time, a, b, result, 8'd251, 
                 (result == 8'd251) ? "PASS (underflow)" : "FAIL");

        // Test AND
        alu_op = 2'b10; a = 8'hF0; b = 8'h0F; #10;
        $display("%0t\tAND\t%h\t%h\t%h\t%h %s", $time, a, b, result, 8'h00, 
                 (result == 8'h00) ? "PASS" : "FAIL");

        alu_op = 2'b10; a = 8'hFF; b = 8'hAA; #10;
        $display("%0t\tAND\t%h\t%h\t%h\t%h %s", $time, a, b, result, 8'hAA, 
                 (result == 8'hAA) ? "PASS" : "FAIL");

        // Test OR
        alu_op = 2'b11; a = 8'hF0; b = 8'h0F; #10;
        $display("%0t\tOR\t%h\t%h\t%h\t%h %s", $time, a, b, result, 8'hFF, 
                 (result == 8'hFF) ? "PASS" : "FAIL");

        alu_op = 2'b11; a = 8'h00; b = 8'h00; #10;
        $display("%0t\tOR\t%h\t%h\t%h\t%h %s", $time, a, b, result, 8'h00, 
                 (result == 8'h00) ? "PASS" : "FAIL");

        $display("\nALU testbench complete!");
        $finish;
    end

endmodule
