# Tool Installation Guide

## Installing Open-Source Digital Design Tools

### For Ubuntu/Debian:
```bash
sudo apt update
sudo apt install -y iverilog gtkwave yosys
```

### For macOS:
```bash
brew install icarus-verilog gtkwave yosys
```

### For Windows:
1. Download Icarus Verilog from: http://bleyer.org/icarus/
2. Download GTKWave from: http://gtkwave.sourceforge.net/
3. For Yosys, use WSL2 or Docker

## Verify Installation
```bash
iverilog --version
gtkwave --version
yosys --version
```

## Alternative: Online Simulators
If you can't install locally, try:
- EDA Playground: https://www.edaplayground.com/
- HDLBits: https://hdlbits.01xz.net/

