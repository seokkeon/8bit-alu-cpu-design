// alu.v - 8-bit Arithmetic Logic Unit
// Performs ADD, SUB, AND, OR operations

`timescale 1ns/1ps

module alu (
    input  [7:0] a,        // Operand A
    input  [7:0] b,        // Operand B
    input  [1:0] alu_op,   // Operation select
    output reg [7:0] result // ALU result
);

    // ALU operation codes
    localparam ADD = 2'b00;
    localparam SUB = 2'b01;
    localparam AND = 2'b10;
    localparam OR  = 2'b11;

    // Combinational logic for ALU operations
    always @(*) begin
        case (alu_op)
            ADD: result = a + b;
            SUB: result = a - b;
            AND: result = a & b;
            OR:  result = a | b;
            default: result = 8'h00;
        endcase
    end

endmodule
