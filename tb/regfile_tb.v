// regfile_tb.v - Testbench for Register File

`timescale 1ns/1ps

module regfile_tb;

    reg clk;
    reg rst;
    reg we;
    reg  [1:0] rd_addr;
    reg  [1:0] ra_addr;
    reg  [1:0] rb_addr;
    reg  [7:0] wr_data;
    wire [7:0] ra_data;
    wire [7:0] rb_data;

    // Instantiate register file
    regfile uut (
        .clk(clk),
        .rst(rst),
        .we(we),
        .rd_addr(rd_addr),
        .ra_addr(ra_addr),
        .rb_addr(rb_addr),
        .wr_data(wr_data),
        .ra_data(ra_data),
        .rb_data(rb_data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test procedure
    initial begin
        $dumpfile("regfile_tb.vcd");
        $dumpvars(0, regfile_tb);

        $display("Starting Register File testbench...");
        
        // Reset
        rst = 1; we = 0;
        #10 rst = 0;
        
        $display("\nWriting to registers...");
        // Write to R0
        @(posedge clk);
        we = 1; rd_addr = 2'd0; wr_data = 8'hAA;
        
        // Write to R1
        @(posedge clk);
        rd_addr = 2'd1; wr_data = 8'hBB;
        
        // Write to R2
        @(posedge clk);
        rd_addr = 2'd2; wr_data = 8'hCC;
        
        // Write to R3
        @(posedge clk);
        rd_addr = 2'd3; wr_data = 8'hDD;
        
        @(posedge clk);
        we = 0;
        
        $display("\nReading from registers...");
        // Read R0 and R1
        ra_addr = 2'd0; rb_addr = 2'd1;
        #1;
        $display("R0 = 0x%h (expect 0xAA) %s", ra_data, 
                 (ra_data == 8'hAA) ? "PASS" : "FAIL");
        $display("R1 = 0x%h (expect 0xBB) %s", rb_data, 
                 (rb_data == 8'hBB) ? "PASS" : "FAIL");
        
        // Read R2 and R3
        ra_addr = 2'd2; rb_addr = 2'd3;
        #1;
        $display("R2 = 0x%h (expect 0xCC) %s", ra_data, 
                 (ra_data == 8'hCC) ? "PASS" : "FAIL");
        $display("R3 = 0x%h (expect 0xDD) %s", rb_data, 
                 (rb_data == 8'hDD) ? "PASS" : "FAIL");
        
        #20;
        $display("\nRegister File testbench complete!");
        $finish;
    end

endmodule
