#!/bin/bash
# synthesize.sh - Run synthesis with Yosys

set -e

echo "=== CPU Synthesis Script ==="

# Check if yosys is installed
if ! command -v yosys &> /dev/null; then
    echo "ERROR: yosys not found!"
    echo "Please install: sudo apt install yosys"
    exit 1
fi

cd /home/claude/cpu_project

echo "Running synthesis..."

yosys -p "
    read_verilog rtl/alu.v;
    read_verilog rtl/regfile.v;
    read_verilog rtl/cpu.v;
    hierarchy -check -top cpu;
    proc; opt; fsm; opt; memory; opt;
    techmap; opt;
    stat;
    write_verilog synth/cpu_synth.v;
    show -prefix synth/cpu_diagram -format dot cpu
"

echo ""
echo "✓ Synthesis complete!"
echo "  - Netlist: synth/cpu_synth.v"
echo "  - Diagram: synth/cpu_diagram.dot"
echo ""
echo "To view diagram: dot -Tpng synth/cpu_diagram.dot -o synth/cpu_diagram.png"
