#!/bin/bash
# simulate.sh - Compile and run Verilog simulations

set -e

echo "=== CPU Project Simulation Script ==="

# Check if iverilog is installed
if ! command -v iverilog &> /dev/null; then
    echo "ERROR: iverilog not found!"
    echo "Please install: sudo apt install iverilog gtkwave"
    exit 1
fi

# Simulation target
TARGET=${1:-alu}

case $TARGET in
    alu)
        echo "Simulating ALU..."
        iverilog -o alu_sim tb/alu_tb.v rtl/alu.v
        vvp alu_sim
        echo "✓ ALU simulation complete! View waveform: gtkwave alu_tb.vcd"
        ;;
    regfile)
        echo "Simulating Register File..."
        iverilog -o regfile_sim tb/regfile_tb.v rtl/regfile.v
        vvp regfile_sim
        echo "✓ Register File simulation complete! View: gtkwave regfile_tb.vcd"
        ;;
    cpu)
        echo "Simulating full CPU..."
        iverilog -o cpu_sim tb/cpu_tb.v rtl/cpu.v rtl/alu.v rtl/regfile.v
        vvp cpu_sim
        echo "✓ CPU simulation complete! View: gtkwave cpu_tb.vcd"
        ;;
    *)
        echo "Usage: ./simulate.sh [alu|regfile|cpu]"
        exit 1
        ;;
esac
