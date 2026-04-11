# CPU Architecture Diagram

## High-Level Block Diagram

```
                    ┌─────────────────────────────────────┐
                    │         8-bit CPU Core              │
                    └─────────────────────────────────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
        ▼                           ▼                           ▼
┌───────────────┐          ┌────────────────┐         ┌────────────────┐
│   Program     │          │  Register File │         │      ALU       │
│   Counter     │          │   (4x8 bits)   │         │   (8-bit)      │
│   (8-bit)     │          └────────────────┘         └────────────────┘
└───────────────┘                   │                          │
        │                           │                          │
        │                    ┌──────┴──────┐                  │
        │                    │             │                  │
        ▼                    ▼             ▼                  ▼
┌───────────────┐    ┌─────────┐   ┌─────────┐      ┌────────────────┐
│  Instruction  │───>│ Decoder │   │  Data   │      │  Write-back    │
│    Memory     │    │         │   │  Path   │<─────│    Logic       │
│   (16x8)      │    └─────────┘   └─────────┘      └────────────────┘
└───────────────┘
```

## Datapath Flow

```
1. Fetch:     PC ──> Instruction Memory ──> Instruction Register
2. Decode:    Instruction ──> Opcode, Rd, Ra, Rb
3. Read:      Ra, Rb ──> Register File ──> ra_data, rb_data
4. Execute:   ra_data, rb_data ──> ALU ──> result
5. Write:     result ──> Register File[Rd]
```

## Signal Flow

```
Clock ────┬──> Program Counter
          ├──> Register File
          └──> (drives all sequential logic)

Reset ────┬──> Program Counter (clears to 0)
          └──> Register File (clears all registers)

Instruction[7:6] ──> ALU Operation Select
Instruction[5:4] ──> Write Register Address
Instruction[3:2] ──> Read Register A Address
Instruction[1:0] ──> Read Register B Address
```

## Module Hierarchy

```
cpu (top)
├── Program Counter (8-bit register)
├── Instruction Memory (16 x 8-bit ROM)
├── Instruction Decoder (combinational)
├── Register File Module
│   └── 4 x 8-bit registers
└── ALU Module
    ├── Adder
    ├── Subtractor
    ├── AND gate
    └── OR gate
```

## Timing Diagram

```
        ┌───┐   ┌───┐   ┌───┐   ┌───┐
CLK     ┘   └───┘   └───┘   └───┘   └───

PC      0       1       2       3       4

Instr   ════════[I0]═══[I1]═══[I2]═══[I3]

ALU     ════════[R0]═══[R1]═══[R2]═══[R3]

RegWr   ________╱═══╲___╱═══╲___╱═══╲___
```

## Critical Path

The critical path in this single-cycle design:

```
Clock Edge
    │
    ▼
Register File Read (async)
    │
    ▼
ALU Computation (combinational)
    │
    ▼
Register File Setup Time
    │
    ▼
Clock Edge (write)
```

**Maximum Frequency** depends on:
- Register file read delay
- ALU propagation delay
- Register file setup time
