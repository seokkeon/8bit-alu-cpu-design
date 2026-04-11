// regfile.v - 4x8-bit Register File
// 2 read ports, 1 write port

module regfile (
    input clk,
    input rst,
    input we,              // Write enable
    input  [1:0] rd_addr,  // Write address
    input  [1:0] ra_addr,  // Read address A
    input  [1:0] rb_addr,  // Read address B
    input  [7:0] wr_data,  // Write data
    output [7:0] ra_data,  // Read data A
    output [7:0] rb_data   // Read data B
);

    // 4 registers, 8-bits each
    reg [7:0] registers [0:3];

    // Asynchronous read
    assign ra_data = registers[ra_addr];
    assign rb_data = registers[rb_addr];

    // Synchronous write
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            registers[0] <= 8'h00;
            registers[1] <= 8'h00;
            registers[2] <= 8'h00;
            registers[3] <= 8'h00;
        end else if (we) begin
            registers[rd_addr] <= wr_data;
        end
    end

endmodule
