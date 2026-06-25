#!/bin/bash
# synthesize.sh - Run synthesis with Yosys

set -e

echo "=== CPU Synthesis Script ==="

if ! command -v yosys > /dev/null 2>&1; then
    echo "ERROR: yosys not found!"
    echo "Please install: sudo apt install yosys"
    exit 1
fi

cd "$(dirname "$0")"

echo "Running synthesis..."
yosys -s synth/synth.ys

echo ""
echo "Synthesis complete!"
echo "  - Netlist: synth/cpu_synth.v"
echo "  - Diagram: synth/cpu_diagram.dot"
echo ""
echo "To view diagram: dot -Tpng synth/cpu_diagram.dot -o synth/cpu_diagram.png"
