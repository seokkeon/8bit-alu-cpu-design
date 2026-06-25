# Getting Started

## 1. Install Tools

Ubuntu, Debian, or WSL:

```bash
sudo apt update
sudo apt install -y iverilog gtkwave yosys graphviz make
```

Windows:

Install Icarus Verilog and make sure `iverilog` and `vvp` are on your PATH.
GTKWave is optional for viewing waveform files.

## 2. Run Simulations

With `make`:

```bash
make sim-alu
make sim-regfile
make sim-cpu
```

On Windows without `make`:

```powershell
powershell -ExecutionPolicy Bypass -File .\simulate.ps1 alu
powershell -ExecutionPolicy Bypass -File .\simulate.ps1 regfile
powershell -ExecutionPolicy Bypass -File .\simulate.ps1 cpu
```

## 3. Expected CPU Result

The CPU testbench preloads:

```text
R1 = 5
R2 = 3
```

The demo program computes:

```text
R0 = R1 + R2 = 8
R3 = R0 - R2 = 5
R1 = R1 & R2 = 1
R2 = R1 | R0 = 9
```

The CPU simulation should end with all four register checks marked `PASS`.

## 4. View Waveforms

Each simulation writes a `.vcd` file:

```text
alu_tb.vcd
regfile_tb.vcd
cpu_tb.vcd
```

Open them with GTKWave:

```bash
gtkwave cpu_tb.vcd
```

## 5. Synthesize

If Yosys is installed:

```bash
make synth
```

The generated netlist and diagram files will be written under `synth/`.

## 6. Suggested Experiments

1. Add an XOR operation to `rtl/alu.v`.
2. Add a zero flag output to the ALU.
3. Add immediate instructions so the CPU can load constants without testbench preloads.
4. Replace the demo program in `rtl/cpu.v` and update `tb/cpu_tb.v` expected values.
