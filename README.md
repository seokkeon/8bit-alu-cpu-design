# Simple 8-bit CPU Design Project
## RTL to Synthesis Implementation

A complete educational CPU design project implementing an 8-bit processor from RTL to synthesis.

---

## 🎯 Project Overview

This project implements a simple 8-bit single-cycle CPU with:
- **4 general-purpose registers** (R0-R3)
- **4 ALU operations** (ADD, SUB, AND, OR)
- **8-bit instruction word**
- **Single-cycle execution** (1 instruction per clock)

### Learning Objectives
- Understand CPU microarchitecture
- Practice Verilog RTL design
- Learn simulation and testbench methodology
- Perform logic synthesis
- Analyze timing and resource usage

---

## 📁 Project Structure

```
cpu_project/
├── rtl/                  # RTL source files
│   ├── alu.v            # Arithmetic Logic Unit
│   ├── regfile.v        # Register File (4x8-bit)
│   └── cpu.v            # Top-level CPU module
├── tb/                   # Testbenches
│   ├── alu_tb.v
│   ├── regfile_tb.v
│   └── cpu_tb.v
├── synth/                # Synthesis outputs
├── docs/                 # Documentation
│   ├── ISA_spec.md      # Instruction Set Architecture
│   └── INSTALL.md       # Tool installation guide
├── Makefile             # Build automation
├── simulate.sh          # Simulation script
└── synthesize.sh        # Synthesis script
```

---

## 🚀 Quick Start

### 1. Install Tools (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install -y iverilog gtkwave yosys graphviz
```

### 2. Simulate ALU
```bash
make sim-alu
make view-alu    # View waveforms
```

### 3. Simulate Complete CPU
```bash
make sim-cpu
make view-cpu
```

### 4. Synthesize
```bash
make synth
```

---

## 📚 Step-by-Step Workflow

### Phase 1: Component Testing (Week 1-2)

#### Test ALU
```bash
cd cpu_project
make sim-alu
```

**What to observe:**
- All 4 operations (ADD, SUB, AND, OR) work correctly
- Overflow/underflow behavior
- Combinational logic timing

#### Test Register File
```bash
make sim-regfile
```

**What to observe:**
- Write operations update registers
- Read operations retrieve correct data
- Synchronous write, asynchronous read

### Phase 2: CPU Integration (Week 3)

#### Test Complete CPU
```bash
make sim-cpu
```

**What to observe:**
- Program counter incrementing
- Instructions being fetched and decoded
- ALU operations executing
- Results writing back to registers

### Phase 3: Synthesis (Week 4)

#### Run Synthesis
```bash
make synth
```

**Analyze results:**
1. Check `synth/cpu_synth.v` for gate-level netlist
2. View statistics in terminal output
3. Examine resource usage (flip-flops, LUTs, etc.)

#### Generate Diagram
```bash
dot -Tpng synth/cpu_diagram.dot -o synth/cpu_diagram.png
```

---

## 🔬 Understanding the Architecture

### Instruction Format (8 bits)
```
[7:6] - Opcode (2 bits)
[5:4] - Destination Register
[3:2] - Source Register A  
[1:0] - Source Register B
```

### Instruction Set
| Opcode | Operation | Example |
|--------|-----------|---------|
| 00 | ADD | `R0 = R1 + R2` |
| 01 | SUB | `R0 = R1 - R2` |
| 10 | AND | `R0 = R1 & R2` |
| 11 | OR  | `R0 = R1 \| R2` |

### Example Program
```verilog
// R1 = 5, R2 = 3
// R0 = R1 + R2 = 8
Instruction: 00_00_01_10 = 0x06
```

---

## 🎓 Learning Path

### Beginner Tasks
1. ✅ Simulate ALU and understand operations
2. ✅ Simulate register file and verify reads/writes
3. ✅ Run CPU simulation and trace execution
4. ✅ Modify test program in `cpu.v`

### Intermediate Tasks
5. Add a fifth ALU operation (XOR, SHL, SHR)
6. Implement a status register (zero flag, carry flag)
7. Add immediate addressing mode
8. Implement conditional branching (BEQ, BNE)

### Advanced Tasks
9. Convert to multi-cycle CPU (reduce hardware)
10. Add pipeline stages (IF, ID, EX, MEM, WB)
11. Implement hazard detection and forwarding
12. Add instruction and data memory

---

## 📊 Expected Results

### Simulation
- ALU: ~8 test cases, all passing
- Register File: Read/write verification
- CPU: 10+ cycle execution trace

### Synthesis (Yosys)
Typical results for this simple CPU:
```
Number of wires:        ~50
Number of cells:        ~150
  Flip-flops:          ~20 (for registers + PC)
  Logic gates:         ~130
```

---

## 🐛 Troubleshooting

### Simulation fails
- Check that Icarus Verilog is installed: `iverilog --version`
- Verify file paths in Makefile
- Look for syntax errors in .v files

### Waveform viewer doesn't open
- Install GTKWave: `sudo apt install gtkwave`
- Check that .vcd file was generated

### Synthesis errors
- Ensure all modules are read before `hierarchy` command
- Check for undefined signals or modules

---

## 📖 Additional Resources

### Documentation
- ISA Specification: `docs/ISA_spec.md`
- Tool Installation: `docs/INSTALL.md`

### Online Resources
- Verilog tutorial: https://hdlbits.01xz.net/
- Yosys manual: http://www.clifford.at/yosys/
- Computer Architecture course (Nand2Tetris)

---

## 🎯 Next Steps

After completing this project:
1. Study pipelined CPUs (5-stage pipeline)
2. Implement cache memory
3. Add interrupts and exception handling
4. Design a custom ISA for specific applications
5. Target an FPGA (Xilinx or Altera)

---

## 📝 License

Educational use only. Feel free to modify and extend!

---

## ✨ Acknowledgments

Based on classic RISC architecture principles and educational CPU design patterns.
