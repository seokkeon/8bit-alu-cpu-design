// cpu_tb.v - Testbench for complete CPU

`timescale 1ns/1ps

module cpu_tb;

    reg clk;
    reg rst;
    integer errors;

    // Instantiate CPU
    cpu uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation (10ns period = 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task check_reg;
        input [1:0] reg_num;
        input [7:0] expected;
        begin
            if (uut.rf.registers[reg_num] !== expected) begin
                $display("FAIL: R%0d = %0d (0x%h), expected %0d (0x%h)",
                         reg_num, uut.rf.registers[reg_num],
                         uut.rf.registers[reg_num], expected, expected);
                errors = errors + 1;
            end else begin
                $display("PASS: R%0d = %0d (0x%h)",
                         reg_num, uut.rf.registers[reg_num],
                         uut.rf.registers[reg_num]);
            end
        end
    endtask

    // Test procedure
    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, cpu_tb);

        errors = 0;

        $display("");
        $display("=== Starting CPU Testbench ===");

        // Reset CPU, then preload source registers for the four-instruction
        // demo program stored in instruction memory.
        rst = 1;
        repeat (2) @(posedge clk);
        @(negedge clk);
        rst = 0;
        uut.rf.registers[1] = 8'd5;
        uut.rf.registers[2] = 8'd3;

        $display("Initial values: R1=5, R2=3");
        $display("");
        $display("Time\tExecPC\tInstr\tOpcode\tRd\tRa\tRb\tALU_Result");
        $display("----\t------\t-----\t------\t--\t--\t--\t----------");

        // Execute the four demo instructions. The trace is printed before the
        // active clock edge, so decoded fields and ALU result match ExecPC.
        repeat (4) begin
            #1; // Allow pre-edge combinational signals to settle.
            $display("%0t\t%0d\t%h\t%b\t%0d\t%0d\t%0d\t%0d",
                     $time, uut.pc, uut.instruction, uut.opcode,
                     uut.rd, uut.ra, uut.rb, uut.alu_result);
            @(posedge clk);
        end
        #1; // Allow the final write-back to settle before checking registers.

        $display("");
        $display("=== Final Register Values ===");
        $display("R0 = %0d (0x%h)", uut.rf.registers[0], uut.rf.registers[0]);
        $display("R1 = %0d (0x%h)", uut.rf.registers[1], uut.rf.registers[1]);
        $display("R2 = %0d (0x%h)", uut.rf.registers[2], uut.rf.registers[2]);
        $display("R3 = %0d (0x%h)", uut.rf.registers[3], uut.rf.registers[3]);

        $display("");
        $display("=== Verification ===");
        check_reg(2'd0, 8'd8); // R0 = 5 + 3
        check_reg(2'd1, 8'd1); // R1 = 5 & 3
        check_reg(2'd2, 8'd9); // R2 = 1 | 8
        check_reg(2'd3, 8'd5); // R3 = 8 - 3

        if (errors == 0) begin
            $display("");
            $display("CPU testbench complete: PASS");
        end else begin
            $display("");
            $display("CPU testbench complete: FAIL (%0d errors)", errors);
        end

        $finish;
    end

    // Timeout watchdog
    initial begin
        #1000;
        $display("ERROR: Testbench timeout!");
        $finish;
    end

endmodule
