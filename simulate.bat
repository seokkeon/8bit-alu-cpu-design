@echo off
REM simulate.bat - Windows batch script for simulations

if "%1"=="" goto help
if "%1"=="alu" goto sim_alu
if "%1"=="regfile" goto sim_regfile
if "%1"=="cpu" goto sim_cpu
goto help

:sim_alu
echo === Simulating ALU ===
iverilog -Wall -o alu_sim tb\alu_tb.v rtl\alu.v
if errorlevel 1 goto error
vvp alu_sim
echo.
echo Success! Run: gtkwave alu_tb.vcd
goto end

:sim_regfile
echo === Simulating Register File ===
iverilog -Wall -o regfile_sim tb\regfile_tb.v rtl\regfile.v
if errorlevel 1 goto error
vvp regfile_sim
echo.
echo Success! Run: gtkwave regfile_tb.vcd
goto end

:sim_cpu
echo === Simulating CPU ===
iverilog -Wall -o cpu_sim tb\cpu_tb.v rtl\cpu.v rtl\alu.v rtl\regfile.v
if errorlevel 1 goto error
vvp cpu_sim
echo.
echo Success! Run: gtkwave cpu_tb.vcd
goto end

:help
echo Usage: simulate.bat [alu^|regfile^|cpu]
echo.
echo Examples:
echo   simulate.bat alu      - Simulate ALU
echo   simulate.bat regfile  - Simulate Register File
echo   simulate.bat cpu      - Simulate CPU
echo.
goto end

:error
echo.
echo === ERROR ===
echo Compilation failed! Check the error messages above.
echo.
goto end

:end
