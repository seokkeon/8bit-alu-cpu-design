// cpu.v - Simple 8-bit Single-Cycle CPU
// Executes one instruction per clock cycle

module cpu (
    input clk,
    input rst
);

    // Program Counter
    reg [7:0] pc;

    // Instruction Memory (16 instructions for demo)
    reg [7:0] imem [0:15];
    wire [7:0] instruction;
    
    // Instruction fields
    wire [1:0] opcode;
    wire [1:0] rd;
    wire [1:0] ra;
    wire [1:0] rb;

    // Register file signals
    wire [7:0] ra_data, rb_data;
    wire [7:0] alu_result;
    reg  reg_we;

    // Decode instruction
    assign instruction = imem[pc];
    assign opcode = instruction[7:6];
    assign rd     = instruction[5:4];
    assign ra     = instruction[3:2];
    assign rb     = instruction[1:0];

    // Instantiate Register File
    regfile rf (
        .clk(clk),
        .rst(rst),
        .we(reg_we),
        .rd_addr(rd),
        .ra_addr(ra),
        .rb_addr(rb),
        .wr_data(alu_result),
        .ra_data(ra_data),
        .rb_data(rb_data)
    );

    // Instantiate ALU
    alu alu_unit (
        .a(ra_data),
        .b(rb_data),
        .alu_op(opcode),
        .result(alu_result)
    );

    // Control logic
    always @(*) begin
        // Always write result back to register
        reg_we = 1'b1;
    end

    // Program Counter logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 8'h00;
        end else begin
            pc <= pc + 1;
        end
    end

    // Initialize instruction memory with test program
    initial begin
        // Simple test program:
        // R1 = 5, R2 = 3
        // R0 = R1 + R2  (expect 8)
        // R3 = R0 - R2  (expect 5)
        // R1 = R1 AND R2 (expect 1)
        // R2 = R1 OR R0  (expect 9)
        
        imem[0]  = 8'b00_01_00_01; // ADD R1, R0, R1 (init R1=0)
        imem[1]  = 8'b00_01_01_01; // ADD R1, R1, R1 (R1=0)
        imem[2]  = 8'b00_01_00_01; // We'll manually set these in testbench
        imem[3]  = 8'b00_10_00_10; // ADD R2, R0, R2 (init R2=0)
        imem[4]  = 8'b00_00_01_10; // ADD R0, R1, R2 (R0 = R1+R2)
        imem[5]  = 8'b01_11_00_10; // SUB R3, R0, R2 (R3 = R0-R2)
        imem[6]  = 8'b10_01_01_10; // AND R1, R1, R2 (R1 = R1&R2)
        imem[7]  = 8'b11_10_01_00; // OR  R2, R1, R0 (R2 = R1|R0)
        imem[8]  = 8'b00_00_00_00; // NOP (ADD R0, R0, R0)
        imem[9]  = 8'b00_00_00_00; // NOP
        imem[10] = 8'b00_00_00_00; // NOP
        imem[11] = 8'b00_00_00_00; // NOP
        imem[12] = 8'b00_00_00_00; // NOP
        imem[13] = 8'b00_00_00_00; // NOP
        imem[14] = 8'b00_00_00_00; // NOP
        imem[15] = 8'b00_00_00_00; // NOP
    end

endmodule
