# 8-bit CPU Instruction Set Architecture (ISA)

## Overview
- 8-bit data path
- 4 general-purpose registers (R0-R3)
- 8-bit instruction word
- 256 bytes of memory

## Instruction Format

```
[7:6] - Opcode (2 bits)
[5:4] - Destination Register (2 bits)
[3:2] - Source Register A (2 bits)
[1:0] - Source Register B (2 bits) OR Immediate value
```

## Instruction Set (8 instructions)

| Opcode | Mnemonic | Format | Description |
|--------|----------|--------|-------------|
| 00 | ADD | ADD Rd, Ra, Rb | Rd = Ra + Rb |
| 01 | SUB | SUB Rd, Ra, Rb | Rd = Ra - Rb |
| 10 | AND | AND Rd, Ra, Rb | Rd = Ra & Rb |
| 11 | OR  | OR Rd, Ra, Rb  | Rd = Ra \| Rb |

## Register Map
- R0: General purpose (can be hardwired to 0 optionally)
- R1: General purpose
- R2: General purpose
- R3: General purpose

## Example Programs

### Addition: R0 = R1 + R2
```
ADD R0, R1, R2  -> 00_00_01_10 -> 0x06
```

### Compute: R3 = (R1 + R2) AND R0
```
ADD R3, R1, R2  -> 00_11_01_10 -> 0x36
AND R3, R3, R0  -> 10_11_11_00 -> 0xBC
```
