# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the 8-bit CPU project.

## Project Overview

An educational 8-bit single-cycle CPU implemented in Verilog. Demonstrates RTL design, simulation, and digital logic concepts.

**Specifications:**
- 8-bit data path
- 4 general-purpose registers (R0-R3)
- 4 ALU operations: ADD, SUB, AND, OR
- Single-cycle execution (1 clock per instruction)
- 8-bit instruction encoding

## Quick Start

### Requirements
- [Icarus Verilog](https://steveicarus.github.io/iverilog/) (`iverilog` + `vvp`)
- [GTKWave](https://gtkwave.sourceforge.net/) (optional, for waveform viewing)
- GNU Make (Windows users: install via [chocolatey](https://chocolatey.org/) or Git Bash)

### Run Simulations

```bash
# Test individual modules
make sim-alu        # Test ALU operations
make sim-regfile    # Test register file read/write
make sim-cpu        # Test complete CPU execution

# View waveforms (requires GTKWave)
make view-alu       # View ALU waveforms
make view-cpu       # View CPU execution trace

# Clean generated files
make clean
```

**Windows users:** The Makefile auto-detects Windows vs Unix and adjusts paths/commands accordingly.

### Manual Commands (without Make)

```bash
# Compile and run ALU test
iverilog -o alu_sim tb/alu_tb.v rtl/alu.v
vvp alu_sim

# Compile and run CPU test
iverilog -o cpu_sim tb/cpu_tb.v rtl/cpu.v rtl/alu.v rtl/regfile.v
vvp cpu_sim

# View waveforms
gtkwave cpu_tb.vcd
```

## Architecture

### Block Diagram

```
                    ┌─────────────────┐
                    │      CPU        │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Program     │     │   Register   │     │     ALU      │
│  Counter     │     │    File      │     │   (8-bit)    │
│   (8-bit)    │     │  (4 × 8-bit) │     │              │
└──────┬───────┘     └──────┬───────┘     └──────┬───────┘
       │                    │                    │
       ▼                    ▼                    ▼
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Instruction │     │  Read data   │     │   Result     │
│   Memory     │     │    (2 ports) │     │              │
│  (16 × 8)    │     └──────────────┘     └──────────────┘
└──────────────┘
```

### Module Hierarchy

```
cpu (top)
├── pc - Program counter (8-bit, increments each cycle)
├── imem - Instruction memory (16 words, hardcoded in initial block)
├── decoder - Combinational instruction decoder
├── regfile (module)
│   ├── 4 registers × 8-bits
│   ├── 2 asynchronous read ports
│   └── 1 synchronous write port (clocked, with reset)
└── alu (module)
    └── 4 operations: ADD(00), SUB(01), AND(10), OR(11)
```

### Execution Flow (Single-Cycle)

```
1. FETCH:    PC → Instruction Memory → Instruction
2. DECODE:   Instruction → {opcode, Rd, Ra, Rb}
3. READ:     Ra, Rb → Register File → Data A, Data B
4. EXECUTE:  Data A, Data B → ALU → Result
5. WRITEBACK: Result → Register File[Rd] (on clock edge)
6. UPDATE:   PC increments for next instruction
```

All stages complete in one clock cycle. Critical path: Register read → ALU → Register setup time.

## Instruction Set

### Instruction Format (8-bit)

```
Bit:    [7] [6] | [5] [4] | [3] [2] | [1] [0]
        ─────────────────────────────────────
Field:  Opcode   |   Rd    |   Ra    |   Rb
        (2-bit)  | (2-bit) | (2-bit) | (2-bit)
```

### Operations

| Opcode | Mnemonic | Operation | Example |
|--------|----------|-----------|---------|
| 00 | ADD | Rd = Ra + Rb | `ADD R0, R1, R2` |
| 01 | SUB | Rd = Ra - Rb | `SUB R0, R1, R2` |
| 10 | AND | Rd = Ra & Rb | `AND R0, R1, R2` |
| 11 | OR  | Rd = Ra \| Rb | `OR  R0, R1, R2` |

### Encoding Examples

```verilog
// ADD R0, R1, R2  →  opcode=00, Rd=00, Ra=01, Rb=10  →  8'b00_00_01_10 = 0x06
// SUB R3, R0, R2  →  opcode=01, Rd=11, Ra=00, Rb=10  →  8'b01_11_00_10 = 0x72
// AND R1, R1, R2  →  opcode=10, Rd=01, Ra=01, Rb=10  →  8'b10_01_01_10 = 0x96
// OR  R2, R1, R0  →  opcode=11, Rd=10, Ra=01, Rb=00  →  8'b11_10_01_00 = 0xE4
```

## File Structure

```
cpu_project/
├── rtl/
│   ├── alu.v          # Combinational ALU (ADD, SUB, AND, OR)
│   ├── regfile.v      # 4×8-bit register file with reset
│   └── cpu.v          # Top-level CPU module
├── tb/
│   ├── alu_tb.v       # ALU testbench (tests all 4 operations)
│   ├── regfile_tb.v   # Register file testbench
│   └── cpu_tb.v       # CPU integration testbench
├── Makefile           # Cross-platform build automation
└── CLAUDE.md          # This file
```

## Source Code Details

### rtl/alu.v

Combinational ALU with 4 operations selected by 2-bit `alu_op`:

```verilog
always @(*) begin
    case (alu_op)
        2'b00: result = a + b;    // ADD
        2'b01: result = a - b;    // SUB
        2'b10: result = a & b;    // AND
        2'b11: result = a | b;    // OR
    endcase
end
```

### rtl/regfile.v

- **Read**: Asynchronous (combinational `assign` statements)
- **Write**: Synchronous on clock rising edge
- **Reset**: Synchronous, clears all registers to 0

```verilog
// Asynchronous read
assign ra_data = registers[ra_addr];
assign rb_data = registers[rb_addr];

// Synchronous write
always @(posedge clk or posedge rst) begin
    if (rst)
        registers[0] <= 8'h00;  // Clear all
    else if (we)
        registers[rd_addr] <= wr_data;
end
```

### rtl/cpu.v

Top-level module integrating all components:

```verilog
// Instruction decode
assign opcode = instruction[7:6];
assign rd     = instruction[5:4];
assign ra     = instruction[3:2];
assign rb     = instruction[1:0];

// Module instantiations
regfile rf (.clk(clk), .rst(rst), ...);
alu     alu_unit (.a(ra_data), .b(rb_data), ...);

// PC logic: increments each clock cycle
always @(posedge clk or posedge rst)
    if (rst) pc <= 8'h00;
    else     pc <= pc + 1;
```

## Testbenches

### tb/alu_tb.v

Tests all 4 ALU operations with known inputs:
- ADD: 15 + 10 = 25, 255 + 1 = 0 (overflow)
- SUB: 20 - 5 = 15, 5 - 10 = 251 (underflow/wrap)
- AND: 0xF0 & 0x0F = 0x00, 0xFF & 0xAA = 0xAA
- OR:  0xF0 | 0x0F = 0xFF, 0x00 | 0x00 = 0x00

### tb/regfile_tb.v

Tests write then read for all 4 registers, verifies reset functionality.

### tb/cpu_tb.v

Runs the test program loaded in instruction memory. Monitors PC, instruction, and ALU result over 10 cycles.

**Access internal signals for debugging:**
```verilog
uut.pc                  // Program counter
uut.rf.registers[0]     // R0 value
uut.rf.registers[1]     // R1 value
uut.alu_result          // ALU output
uut.opcode              // Current opcode
```

## Test Program

The test program is hardcoded in `rtl/cpu.v` initial block:

```verilog
initial begin
    imem[0] = 8'b00_01_01_00;  // ADD R1, R1, R0
    imem[1] = 8'b00_00_01_10;  // ADD R0, R1, R2
    imem[2] = 8'b01_11_00_10;  // SUB R3, R0, R2
    imem[3] = 8'b10_01_01_10;  // AND R1, R1, R2
    imem[4] = 8'b11_10_01_00;  // OR  R2, R1, R0
    // Remaining locations = NOP (0x00)
end
```

**Note:** All registers start at 0 after reset. Without immediate load instructions, operations on zero produce zero. To test with actual values, modify the instruction memory or add immediate addressing to the ISA.

## Common Tasks

### Run a Single Test

```bash
iverilog -o alu_sim tb/alu_tb.v rtl/alu.v && vvp alu_sim
```

### Check Verilog Syntax

```bash
iverilog -t null rtl/alu.v      # Syntax check only
iverilog -Wall rtl/cpu.v        # Show all warnings
```

### Debug with Waveforms

1. Run simulation to generate VCD: `make sim-cpu`
2. Open in GTKWave: `gtkwave cpu_tb.vcd`
3. Add signals: `clk`, `pc`, `instruction`, `opcode`, `alu_result`, `rf.registers[0]`

### Add a New ALU Operation

1. Edit `rtl/alu.v`: Add case for new operation
2. Update this documentation with new opcode encoding
3. Add test cases to `tb/alu_tb.v`
4. Run `make sim-alu` to verify

Example adding XOR:
```verilog
// In alu.v case statement:
2'b11: result = a ^ b;  // Change OR to XOR, or extend to 3 bits
```

## Limitations

- **No immediate values**: All operations are register-to-register
- **No branching**: PC only increments linearly
- **No data memory**: Only register file storage
- **Hardcoded program**: Instruction memory initialized in `initial` block
- **Single-cycle**: Simple but limits clock frequency

## Tool Installation

### Windows

**Option 1: Chocolatey (recommended)**
```powershell
choco install iverilog gtkwave make
```

**Option 2: Manual**
- Icarus Verilog: https://bleyer.org/icarus/
- GTKWave: https://sourceforge.net/projects/gtkwave/
- Make: Included with Git Bash

### macOS

```bash
brew install icarus-verilog gtkwave
```

### Ubuntu/Debian

```bash
sudo apt install iverilog gtkwave make
```

## Resources

- Icarus Verilog docs: https://steveicarus.github.io/iverilog/
- Verilog tutorials: https://hdlbits.01xz.net/
- GTKWave manual: https://gtkwave.sourceforge.net/gtkwave.pdf
