# simulate.ps1 - PowerShell script for CPU simulations

param(
    [Parameter(Position=0)]
    [ValidateSet('alu', 'regfile', 'cpu', 'help')]
    [string]$Target = 'help'
)

function Show-Help {
    Write-Host "=== CPU Project Simulation Script ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage: .\simulate.ps1 [target]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Targets:" -ForegroundColor Green
    Write-Host "  alu      - Simulate ALU module"
    Write-Host "  regfile  - Simulate Register File"
    Write-Host "  cpu      - Simulate complete CPU"
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Green
    Write-Host "  .\simulate.ps1 alu"
    Write-Host "  .\simulate.ps1 cpu"
    Write-Host ""
}

function Simulate-ALU {
    Write-Host "=== Simulating ALU ===" -ForegroundColor Cyan
    & iverilog -Wall -o alu_sim tb\alu_tb.v rtl\alu.v
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Compilation failed!" -ForegroundColor Red
        return
    }
    & vvp alu_sim
    Write-Host ""
    Write-Host "Success! View waveform: gtkwave alu_tb.vcd" -ForegroundColor Green
}

function Simulate-RegFile {
    Write-Host "=== Simulating Register File ===" -ForegroundColor Cyan
    & iverilog -Wall -o regfile_sim tb\regfile_tb.v rtl\regfile.v
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Compilation failed!" -ForegroundColor Red
        return
    }
    & vvp regfile_sim
    Write-Host ""
    Write-Host "Success! View waveform: gtkwave regfile_tb.vcd" -ForegroundColor Green
}

function Simulate-CPU {
    Write-Host "=== Simulating CPU ===" -ForegroundColor Cyan
    & iverilog -Wall -o cpu_sim tb\cpu_tb.v rtl\cpu.v rtl\alu.v rtl\regfile.v
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Compilation failed!" -ForegroundColor Red
        return
    }
    & vvp cpu_sim
    Write-Host ""
    Write-Host "Success! View waveform: gtkwave cpu_tb.vcd" -ForegroundColor Green
}

# Main execution
switch ($Target) {
    'alu' { Simulate-ALU }
    'regfile' { Simulate-RegFile }
    'cpu' { Simulate-CPU }
    'help' { Show-Help }
    default { Show-Help }
}
