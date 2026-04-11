# 🪟 Windows에서 CPU 프로젝트 시작하기

이 가이드는 Windows 사용자를 위한 설정 방법입니다.

## 📦 Option 1: WSL2 사용 (추천!)

WSL2(Windows Subsystem for Linux)를 사용하면 Linux 툴을 그대로 사용할 수 있습니다.

### WSL2 설치

1. **PowerShell을 관리자 권한으로 실행**
```powershell
wsl --install
```

2. **재부팅**

3. **Ubuntu 실행**
   - 시작 메뉴에서 "Ubuntu" 검색 후 실행
   - 사용자 이름/비밀번호 설정

4. **툴 설치**
```bash
sudo apt update
sudo apt install -y iverilog gtkwave yosys make
```

5. **프로젝트 압축 해제**
```bash
# Windows 다운로드 폴더에서 복사
cp /mnt/c/Users/YOUR_USERNAME/Downloads/cpu_project.zip ~/
unzip cpu_project.zip
cd cpu_project
```

6. **VS Code에서 열기**
```bash
code .
```

VS Code가 자동으로 "WSL" 확장 프로그램 설치를 제안합니다 → 설치!

### WSL2의 장점
- ✅ Linux 툴 네이티브 실행
- ✅ 성능 우수
- ✅ VS Code 완벽 통합
- ✅ 모든 명령어 그대로 사용

---

## 📦 Option 2: 네이티브 Windows (GTKWave 제한적)

### 필수 프로그램 설치

#### 1. Icarus Verilog for Windows
다운로드: http://bleyer.org/icarus/

- `iverilog-v12-20220611-x64_setup.exe` 다운로드
- 설치 시 **"Add to PATH"** 체크!

#### 2. Make for Windows
두 가지 옵션:

**옵션 A: Chocolatey 사용**
```powershell
# PowerShell 관리자 권한
choco install make
```

**옵션 B: GnuWin32**
다운로드: http://gnuwin32.sourceforge.net/packages/make.htm

#### 3. GTKWave (선택)
다운로드: http://gtkwave.sourceforge.net/

- Windows 버전 설치
- PATH에 추가

### 프로젝트 사용

1. **압축 해제**
   - `cpu_project.zip` 우클릭 → "압축 풀기"

2. **VS Code로 열기**
   ```
   파일 → 폴더 열기 → cpu_project 선택
   ```

3. **PowerShell 터미널 사용**
   - VS Code에서 Ctrl+`
   - 터미널 유형을 PowerShell로 설정

4. **시뮬레이션 실행**
   ```powershell
   make sim-alu
   ```

### Windows 네이티브 제약사항
- ⚠️ 일부 bash 스크립트 동작 안 할 수 있음
- ⚠️ GTKWave 버전이 오래됨
- ⚠️ 경로 구분자 차이 (\ vs /)

---

## 📦 Option 3: Docker 사용

완전히 격리된 환경에서 실행:

### Docker Desktop 설치
다운로드: https://www.docker.com/products/docker-desktop

### Dockerfile 생성 (프로젝트 폴더 내)

```dockerfile
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    iverilog \
    gtkwave \
    yosys \
    make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
```

### 사용 방법

```powershell
# Docker 이미지 빌드
docker build -t verilog-dev .

# 컨테이너 실행
docker run -it -v ${PWD}:/workspace verilog-dev

# 컨테이너 내에서
make sim-cpu
```

---

## 🎯 추천 설정

### VS Code 설정 (Windows)

`.vscode/settings.json`에 추가:

```json
{
    // WSL2 사용 시
    "terminal.integrated.defaultProfile.windows": "Ubuntu (WSL)",
    
    // 또는 PowerShell 사용 시
    "terminal.integrated.defaultProfile.windows": "PowerShell",
    
    // 줄바꿈 문자 설정
    "files.eol": "\n"
}
```

### Git Bash 사용 (대안)

Git for Windows 설치 시 포함된 Git Bash 사용:

1. Git for Windows 설치
2. VS Code 터미널 설정:
   ```json
   {
       "terminal.integrated.defaultProfile.windows": "Git Bash"
   }
   ```

---

## 🐛 Windows 관련 문제 해결

### 문제 1: "make: command not found"

**해결:**
```powershell
# Chocolatey로 설치
choco install make

# 또는 수동으로 명령어 실행
iverilog -o cpu_sim tb/cpu_tb.v rtl/cpu.v rtl/alu.v rtl/regfile.v
vvp cpu_sim
```

### 문제 2: "iverilog: command not found"

**해결:**
- Icarus Verilog 재설치
- 환경 변수 PATH 확인
  - 시스템 속성 → 환경 변수
  - Path에 `C:\iverilog\bin` 추가

### 문제 3: 경로 오류 (\ vs /)

**해결:**
WSL2 사용 또는 PowerShell에서:
```powershell
$env:MSYS_NO_PATHCONV=1
```

### 문제 4: 줄바꿈 문자 오류

**해결:**
```bash
# Git Bash에서
dos2unix *.sh
```

또는 VS Code에서:
- 하단 상태바 "CRLF" 클릭 → "LF" 선택

---

## 💡 Windows 사용자를 위한 팁

### 1. WSL2가 최선
- 모든 Linux 툴 사용 가능
- 성능 우수
- VS Code 완벽 통합

### 2. 파일 경로 주의
```
❌ C:\Users\Name\cpu_project
✅ /mnt/c/Users/Name/cpu_project (WSL에서)
```

### 3. 권한 문제
```bash
# WSL에서 스크립트 실행 권한
chmod +x simulate.sh
chmod +x synthesize.sh
```

### 4. GTKWave 대안
- WSL2의 GTKWave 사용
- X Server (VcXsrv) 설치 후 GUI 실행

---

## 🚀 빠른 시작 (WSL2 기준)

```bash
# 1. WSL2 우분투 터미널 열기
# 2. 홈 디렉토리로 이동
cd ~

# 3. 압축 해제
unzip /mnt/c/Users/YOUR_USERNAME/Downloads/cpu_project.zip

# 4. 프로젝트 폴더로 이동
cd cpu_project

# 5. VS Code로 열기
code .

# 6. VS Code에서 터미널 열고 (Ctrl+`)
make sim-cpu

# 7. 성공!
```

---

## ✅ Windows 체크리스트

WSL2 사용자:
- [ ] WSL2 설치 완료
- [ ] Ubuntu 설치 완료
- [ ] iverilog, gtkwave 설치
- [ ] VS Code "WSL" 확장 설치
- [ ] 프로젝트 WSL 파일시스템에 복사

네이티브 Windows 사용자:
- [ ] Icarus Verilog 설치
- [ ] Make 설치
- [ ] PATH 환경 변수 설정
- [ ] VS Code 설치
- [ ] PowerShell 또는 Git Bash 설정

---

## 🔗 유용한 링크

- **WSL2 설치**: https://learn.microsoft.com/en-us/windows/wsl/install
- **Icarus Verilog**: http://bleyer.org/icarus/
- **GTKWave**: http://gtkwave.sourceforge.net/
- **Chocolatey**: https://chocolatey.org/
- **Git for Windows**: https://gitforwindows.org/

---

**Windows에서도 문제없이 CPU 개발할 수 있습니다!** 🚀

추천: WSL2 + VS Code 조합이 가장 편합니다.
