# Simple 8-bit ALU CPU Design

Educational Verilog project for a tiny single-cycle 8-bit CPU. The design is
small enough to trace by hand, but complete enough to demonstrate RTL modules,
testbenches, waveforms, and synthesis.

## Project Overview

- 4 general-purpose 8-bit registers: `R0` through `R3`
- 4 ALU operations: ADD, SUB, AND, OR
- 8-bit instruction word
- 16-entry instruction memory
- Single-cycle execution: one instruction retires per clock

## Project Structure

```text
8bit-alu-cpu-design/
  rtl/
    alu.v          # 8-bit arithmetic logic unit
    regfile.v      # 4x8-bit register file
    cpu.v          # Top-level CPU
  tb/
    alu_tb.v       # ALU testbench
    regfile_tb.v   # Register file testbench
    cpu_tb.v       # CPU integration testbench
  synth/
    synth.ys       # Yosys synthesis script
  docs/
    ISA_spec.md    # Instruction set notes
    INSTALL.md     # Tool installation notes
  Makefile
  simulate.sh
  simulate.ps1
  simulate.bat
  synthesize.sh
```

## Instruction Format

```text
[7:6] opcode
[5:4] destination register rd
[3:2] source register ra
[1:0] source register rb
```

| Opcode | Operation | Meaning |
| ------ | --------- | ------- |
| `00` | ADD | `rd = ra + rb` |
| `01` | SUB | `rd = ra - rb` |
| `10` | AND | `rd = ra & rb` |
| `11` | OR  | `rd = ra | rb` |

Arithmetic wraps modulo 256.

## Quick Start

Install Icarus Verilog, then run:

```bash
make sim-alu
make sim-regfile
make sim-cpu
```

On Windows without `make`, run:

```powershell
.\simulate.ps1 alu
.\simulate.ps1 regfile
.\simulate.ps1 cpu
```

Or:

```cmd
simulate.bat alu
simulate.bat regfile
simulate.bat cpu
```

## Expected CPU Program

The CPU testbench preloads:

```text
R1 = 5
R2 = 3
```

The instruction memory then executes:

```text
ADD R0, R1, R2  # R0 = 8
SUB R3, R0, R2  # R3 = 5
AND R1, R1, R2  # R1 = 1
OR  R2, R1, R0  # R2 = 9
```

Final expected register values:

```text
R0 = 8
R1 = 1
R2 = 9
R3 = 5
```

## Synthesis

Install Yosys, then run:

```bash
make synth
```

or:

```bash
./synthesize.sh
```

Generated synthesis files are written under `synth/`.

## Notes

This CPU intentionally has no immediate instructions, branches, data memory, or
halt instruction. The demo fills unused instruction memory with `OR R0, R0, R0`,
which acts as a pseudo-NOP because it preserves `R0`.
