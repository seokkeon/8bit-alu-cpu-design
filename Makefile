# Makefile - Build automation for CPU project

.PHONY: all clean sim-alu sim-regfile sim-cpu synth help view-alu view-regfile view-cpu

# Default target
all: help

help:
	@echo "=== CPU Project Build System ==="
	@echo ""
	@echo "Simulation targets:"
	@echo "  make sim-alu      - Simulate ALU module"
	@echo "  make sim-regfile  - Simulate Register File"
	@echo "  make sim-cpu      - Simulate complete CPU"
	@echo ""
	@echo "Waveform viewing:"
	@echo "  make view-alu     - View ALU waveforms"
	@echo "  make view-regfile - View Register File waveforms"
	@echo "  make view-cpu     - View CPU waveforms"
	@echo ""
	@echo "Synthesis:"
	@echo "  make synth        - Synthesize CPU with Yosys"
	@echo ""
	@echo "Utility:"
	@echo "  make clean        - Remove generated files"
	@echo ""

# Simulation targets
sim-alu:
	@echo "Compiling and simulating ALU..."
	iverilog -o alu_sim tb/alu_tb.v rtl/alu.v
	vvp alu_sim
	@echo "✓ Done. Run 'make view-alu' to see waveforms"

sim-regfile:
	@echo "Compiling and simulating Register File..."
	iverilog -o regfile_sim tb/regfile_tb.v rtl/regfile.v
	vvp regfile_sim
	@echo "✓ Done. Run 'make view-regfile' to see waveforms"

sim-cpu:
	@echo "Compiling and simulating CPU..."
	iverilog -o cpu_sim tb/cpu_tb.v rtl/cpu.v rtl/alu.v rtl/regfile.v
	vvp cpu_sim
	@echo "✓ Done. Run 'make view-cpu' to see waveforms"

# Waveform viewing
view-alu: alu_tb.vcd
	gtkwave alu_tb.vcd &

view-regfile: regfile_tb.vcd
	gtkwave regfile_tb.vcd &

view-cpu: cpu_tb.vcd
	gtkwave cpu_tb.vcd &

# Synthesis
synth:
	@echo "Running synthesis..."
	./synthesize.sh

# Clean
clean:
	@echo "Cleaning generated files..."
	rm -f *.vcd *.vvp *_sim
	rm -f synth/*.v synth/*.dot synth/*.png
	@echo "✓ Clean complete"

# Check prerequisites
check:
	@echo "Checking required tools..."
	@command -v iverilog >/dev/null 2>&1 || { echo "iverilog not found!"; exit 1; }
	@command -v vvp >/dev/null 2>&1 || { echo "vvp not found!"; exit 1; }
	@command -v gtkwave >/dev/null 2>&1 || { echo "gtkwave not found (optional)"; }
	@command -v yosys >/dev/null 2>&1 || { echo "yosys not found (optional)"; }
	@echo "✓ All required tools found"
