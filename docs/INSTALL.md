# Install Tools

## Ubuntu, Debian, or WSL

```bash
sudo apt update
sudo apt install -y iverilog gtkwave yosys graphviz make
```

## Windows

Install Icarus Verilog for Windows and make sure `iverilog` and `vvp` are on
your PATH. Then run simulations with:

```powershell
.\simulate.ps1 cpu
```

GTKWave is optional and is only needed to inspect `.vcd` waveform files.

## macOS

With Homebrew:

```bash
brew install icarus-verilog gtkwave yosys graphviz make
```
