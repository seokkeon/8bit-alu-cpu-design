# ISA Specification

## Registers

The CPU has four 8-bit general-purpose registers:

```text
R0, R1, R2, R3
```

All registers are readable and writable.

## Instruction Word

Each instruction is 8 bits:

```text
[7:6] opcode
[5:4] rd
[3:2] ra
[1:0] rb
```

The CPU executes:

```text
rd = ra <operation> rb
```

## Opcodes

| Opcode | Mnemonic | Operation |
| ------ | -------- | --------- |
| `00` | ADD | `rd = ra + rb` |
| `01` | SUB | `rd = ra - rb` |
| `10` | AND | `rd = ra & rb` |
| `11` | OR  | `rd = ra | rb` |

ADD and SUB wrap modulo 256.

There is no dedicated NOP opcode. If a harmless filler instruction is needed,
`OR R0, R0, R0` preserves `R0` and is used as a pseudo-NOP in the demo program.

## Example

```text
00_00_01_10
```

decodes as:

```text
ADD R0, R1, R2
```

If `R1 = 5` and `R2 = 3`, the result is `R0 = 8`.
