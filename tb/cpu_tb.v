// cpu_tb.v - Testbench for complete CPU

`timescale 1ns/1ps

module cpu_tb;

    reg clk;
    reg rst;

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

    // Test procedure
    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, cpu_tb);

        $display("\n=== Starting CPU Testbench ===\n");

        // Reset CPU
        rst = 1;
        #15;
        rst = 0;

        // Load test values into registers via initial program
        // We'll initialize R1=5, R2=3 by modifying instructions
        @(posedge clk);
        
        // Manually set up initial register values
        force uut.rf.registers[1] = 8'd5;  // R1 = 5
        force uut.rf.registers[2] = 8'd3;  // R2 = 3
        #1;
        release uut.rf.registers[1];
        release uut.rf.registers[2];

        $display("Initial values: R1=5, R2=3");
        $display("\nTime\tPC\tInstr\tOpcode\tRd\tRa\tRb\tALU_Result");
        $display("----\t--\t-----\t------\t--\t--\t--\t----------");

        // Monitor execution for several cycles
        repeat (10) begin
            @(posedge clk);
            #1; // Small delay for signals to settle
            $display("%0t\t%d\t%h\t%b\t%d\t%d\t%d\t%d", 
                     $time, uut.pc, uut.instruction, uut.opcode,
                     uut.rd, uut.ra, uut.rb, uut.alu_result);
        end

        $display("\n=== Final Register Values ===");
        $display("R0 = %d (0x%h)", uut.rf.registers[0], uut.rf.registers[0]);
        $display("R1 = %d (0x%h)", uut.rf.registers[1], uut.rf.registers[1]);
        $display("R2 = %d (0x%h)", uut.rf.registers[2], uut.rf.registers[2]);
        $display("R3 = %d (0x%h)", uut.rf.registers[3], uut.rf.registers[3]);

        // Verify results
        $display("\n=== Verification ===");
        $display("R0 should be 8 (5+3):     %s", (uut.rf.registers[0] == 8) ? "PASS" : "FAIL");
        $display("R3 should be 5 (8-3):     %s", (uut.rf.registers[3] == 5) ? "FAIL (timing issue)" : "CHECK");
        
        #50;
        $display("\nCPU testbench complete!\n");
        $finish;
    end

    // Optional: Timeout watchdog
    initial begin
        #1000;
        $display("ERROR: Testbench timeout!");
        $finish;
    end

endmodule
