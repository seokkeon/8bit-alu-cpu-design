# 🔧 Windows 문제 해결 가이드

## ❌ 오류: `iverilog.exe: unknown option -- -`

이 오류는 Windows 명령행 인자 파싱 문제입니다.

### 해결 방법

#### 방법 1: 배치 스크립트 사용 (가장 간단!)

```cmd
REM Makefile 대신 배치 스크립트 사용
simulate.bat alu
simulate.bat regfile
simulate.bat cpu
```

#### 방법 2: 직접 명령어 실행

```cmd
REM ALU 시뮬레이션
iverilog -o alu_sim tb\alu_tb.v rtl\alu.v
vvp alu_sim

REM Register File 시뮬레이션
iverilog -o regfile_sim tb\regfile_tb.v rtl\regfile.v
vvp regfile_sim

REM CPU 시뮬레이션
iverilog -o cpu_sim tb\cpu_tb.v rtl\cpu.v rtl\alu.v rtl\regfile.v
vvp cpu_sim
```

#### 방법 3: PowerShell 스크립트

```powershell
# PowerShell에서 실행
.\simulate.ps1 cpu
```

#### 방법 4: WSL2 사용 (강력 추천!)

```bash
# WSL2 Ubuntu 터미널에서
make sim-cpu
```

WSL2가 없다면:
```powershell
# PowerShell 관리자 권한
wsl --install
# 재부팅 후 Ubuntu 실행
```

---

## ❌ 오류: `make: command not found`

Windows에 Make가 설치되지 않았습니다.

### 해결 방법

#### 옵션 A: 배치 스크립트 사용
```cmd
simulate.bat cpu
```

#### 옵션 B: Chocolatey로 Make 설치
```powershell
# PowerShell 관리자 권한
choco install make
```

#### 옵션 C: WSL2 사용
```bash
# WSL2에서는 make가 기본 포함
make sim-cpu
```

---

## ❌ 오류: 경로를 찾을 수 없습니다

Windows는 `/` 대신 `\`를 사용합니다.

### 해결 방법

#### 배치 스크립트 사용
`simulate.bat`는 자동으로 Windows 경로를 사용합니다.

#### 또는 PowerShell에서:
```powershell
iverilog -o cpu_sim tb\cpu_tb.v rtl\cpu.v rtl\alu.v rtl\regfile.v
```

---

## ❌ VS Code Task가 작동하지 않음

### 해결 방법

#### 1. 터미널 유형 변경

`.vscode/settings.json` 수정:

```json
{
    "terminal.integrated.defaultProfile.windows": "Command Prompt"
}
```

또는

```json
{
    "terminal.integrated.defaultProfile.windows": "PowerShell"
}
```

#### 2. Task 수동 수정

`.vscode/tasks.json`에서:

```json
{
    "label": "Simulate CPU",
    "type": "shell",
    "command": "simulate.bat cpu",  // ← 배치 스크립트 사용
    "windows": {
        "command": "simulate.bat cpu"
    }
}
```

---

## ❌ GTKWave가 실행되지 않음

### 해결 방법

#### 1. GTKWave 설치 확인
다운로드: http://gtkwave.sourceforge.net/

#### 2. 수동 실행
```cmd
gtkwave cpu_tb.vcd
```

#### 3. 전체 경로 사용
```cmd
"C:\Program Files\gtkwave\bin\gtkwave.exe" cpu_tb.vcd
```

#### 4. WSL2 + X Server
```bash
# WSL2에서 GTKWave 사용
# 먼저 Windows에 VcXsrv 설치
# WSL에서:
export DISPLAY=:0
gtkwave cpu_tb.vcd
```

---

## 🎯 권장 설정 (Windows 네이티브)

### 프로젝트 루트에 `run.bat` 생성:

```batch
@echo off
echo ================================
echo   CPU Project - Quick Run
echo ================================
echo.
echo 1. Simulate ALU
echo 2. Simulate Register File
echo 3. Simulate CPU
echo 4. View ALU waveform
echo 5. View CPU waveform
echo 6. Clean
echo.
set /p choice="Enter choice (1-6): "

if "%choice%"=="1" goto alu
if "%choice%"=="2" goto regfile
if "%choice%"=="3" goto cpu
if "%choice%"=="4" goto view_alu
if "%choice%"=="5" goto view_cpu
if "%choice%"=="6" goto clean

:alu
echo.
echo Running ALU simulation...
iverilog -o alu_sim tb\alu_tb.v rtl\alu.v
vvp alu_sim
pause
goto end

:regfile
echo.
echo Running Register File simulation...
iverilog -o regfile_sim tb\regfile_tb.v rtl\regfile.v
vvp regfile_sim
pause
goto end

:cpu
echo.
echo Running CPU simulation...
iverilog -o cpu_sim tb\cpu_tb.v rtl\cpu.v rtl\alu.v rtl\regfile.v
vvp cpu_sim
pause
goto end

:view_alu
echo.
gtkwave alu_tb.vcd
goto end

:view_cpu
echo.
gtkwave cpu_tb.vcd
goto end

:clean
echo.
echo Cleaning...
del /Q *.vcd *.vvp *_sim 2>nul
echo Done!
pause
goto end

:end
```

실행: 탐색기에서 `run.bat` 더블클릭!

---

## 🚀 최고의 Windows 설정

### WSL2 + VS Code Remote

1. **WSL2 설치**
   ```powershell
   wsl --install
   ```

2. **VS Code에서 WSL 확장 설치**
   - Extensions → "WSL" 검색 → 설치

3. **WSL에서 프로젝트 열기**
   ```bash
   # WSL Ubuntu 터미널
   cd ~
   unzip /mnt/c/Users/YOUR_NAME/Downloads/cpu_project.zip
   cd cpu_project
   code .
   ```

4. **모든 것이 완벽하게 작동!**
   ```bash
   make sim-cpu
   gtkwave cpu_tb.vcd
   ```

### 장점
- ✅ Linux 툴 네이티브 실행
- ✅ 모든 스크립트 그대로 작동
- ✅ 성능 우수
- ✅ VS Code 완벽 통합
- ✅ 문제 없음!

---

## 📋 빠른 참조 - Windows 명령어

### 시뮬레이션
```cmd
REM 방법 1: 배치 스크립트
simulate.bat cpu

REM 방법 2: 직접 실행
iverilog -o cpu_sim tb\cpu_tb.v rtl\cpu.v rtl\alu.v rtl\regfile.v
vvp cpu_sim

REM 방법 3: WSL2
wsl make sim-cpu
```

### 파형 보기
```cmd
gtkwave cpu_tb.vcd
```

### 정리
```cmd
del /Q *.vcd *.vvp *_sim
```

---

## 💡 프로 팁

### 1. PATH 환경 변수 확인
```cmd
echo %PATH%
```
`C:\iverilog\bin`이 포함되어야 합니다.

### 2. 탐색기 통합
`cpu_project` 폴더 우클릭 → "Open with Code"

### 3. Git Bash 사용
Git for Windows 설치 후:
```bash
# Git Bash에서 Linux 명령어 사용 가능
make sim-cpu
```

### 4. PowerShell 프로필 설정
```powershell
# 별칭 추가
notepad $PROFILE

# 추가:
function sim-cpu { .\simulate.bat cpu }
function sim-alu { .\simulate.bat alu }
```

---

## ❓ 여전히 문제가 있나요?

### 가장 확실한 해결책: WSL2

```powershell
# 1. PowerShell 관리자 권한
wsl --install

# 2. 재부팅

# 3. Ubuntu 실행
# 사용자명/비밀번호 설정

# 4. 툴 설치
sudo apt update
sudo apt install iverilog gtkwave yosys make

# 5. 프로젝트 복사
cp /mnt/c/Users/YOUR_NAME/Downloads/cpu_project.zip ~/
unzip cpu_project.zip
cd cpu_project

# 6. 실행!
make sim-cpu
```

**더 이상 Windows 문제 없음!** ✅

---

## 📞 추가 도움

- **WSL2 공식 가이드**: https://learn.microsoft.com/en-us/windows/wsl/
- **Icarus Verilog Windows**: http://bleyer.org/icarus/
- **프로젝트 README**: `README.md`
- **일반 가이드**: `GETTING_STARTED.md`

**Windows에서도 성공할 수 있습니다!** 🚀
