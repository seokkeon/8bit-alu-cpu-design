# VS Code 설정 가이드

이 문서는 VS Code에서 Verilog CPU 프로젝트를 개발하는 방법을 설명합니다.

## 🚀 빠른 시작

### 1. 프로젝트 열기

```bash
# 프로젝트 폴더로 이동
cd cpu_project

# VS Code로 열기
code .
```

### 2. 권장 확장 프로그램 설치

VS Code가 자동으로 권장 확장 프로그램을 설치할 것인지 물어봅니다. **"Install All"** 을 클릭하세요.

또는 수동으로 설치:

#### 필수 확장 프로그램
1. **Verilog-HDL/SystemVerilog** (mshr-h.veriloghdl)
   - Verilog 문법 강조
   - Linting (오류 검사)
   - 코드 자동완성

2. **Verilog** (leafvmaple.verilog)
   - 추가 Verilog 지원
   - 스니펫

#### 선택 확장 프로그램
3. **Waveform Viewer** (toteddy.waveform-viewer)
   - VCD 파일을 VS Code 내부에서 보기

4. **GitLens** (eamodio.gitlens)
   - Git 통합 (버전 관리)

5. **Markdown All in One** (yzhang.markdown-all-in-one)
   - 문서 편집

### 3. 도구 설치 확인

터미널에서 확인:
```bash
iverilog --version
gtkwave --version
yosys --version
```

설치 안되어 있다면:
```bash
sudo apt update
sudo apt install iverilog gtkwave yosys
```

---

## 🎯 VS Code 기능 활용

### Task 실행 (Ctrl+Shift+B)

프로젝트에는 미리 구성된 Task가 있습니다:

1. **Ctrl+Shift+P** → "Tasks: Run Task" 입력
2. 원하는 Task 선택:
   - `Simulate ALU` - ALU 시뮬레이션
   - `Simulate Register File` - RegFile 시뮬레이션
   - `Simulate CPU` - CPU 전체 시뮬레이션
   - `View CPU Waveform` - 파형 보기
   - `Synthesize CPU` - 합성 실행
   - `Clean Project` - 생성 파일 삭제

**또는** 키보드 단축키:
- **Ctrl+Shift+B** → 기본 빌드 Task (CPU 시뮬레이션)

### 통합 터미널

**Ctrl+`** (백틱)로 터미널 열기

```bash
# 수동 명령어 실행
make sim-alu
make sim-cpu
gtkwave cpu_tb.vcd
```

### 코드 스니펫 사용

Verilog 파일에서:

- `module` → Tab → 모듈 템플릿
- `always-comb` → Tab → 조합 논리 블록
- `always-seq` → Tab → 순차 논리 블록
- `always-reset` → Tab → 리셋 포함 블록
- `testbench` → Tab → 완전한 테스트벤치 템플릿
- `case` → Tab → Case 문

### 문법 검사 (Linting)

Verilog 파일을 열면 자동으로 문법 검사가 실행됩니다.

**수동 실행:**
1. Verilog 파일 열기
2. **Ctrl+Shift+P** → "Tasks: Run Task"
3. "Check Verilog Syntax (Current File)" 선택

오류가 있으면 **Problems 패널** (Ctrl+Shift+M)에 표시됩니다.

---

## 📁 프로젝트 구조 탐색

### Explorer (Ctrl+Shift+E)

```
cpu_project/
├── .vscode/              ← VS Code 설정 (자동 생성됨)
│   ├── settings.json     - 워크스페이스 설정
│   ├── tasks.json        - Task 정의
│   ├── extensions.json   - 권장 확장 프로그램
│   └── verilog.code-snippets - 코드 스니펫
├── rtl/                  ← RTL 소스코드
│   ├── alu.v            - ALU 모듈
│   ├── regfile.v        - Register File
│   └── cpu.v            - CPU 코어
├── tb/                   ← 테스트벤치
├── docs/                 ← 문서
├── Makefile
└── README.md
```

### 파일 빠른 열기 (Ctrl+P)

파일 이름 입력하여 빠르게 열기:
- `cpu.v` → rtl/cpu.v 열기
- `cpu_tb.v` → tb/cpu_tb.v 열기

---

## ⌨️ 유용한 단축키

### 일반
- `Ctrl+P` - 파일 빠른 열기
- `Ctrl+Shift+P` - 명령 팔레트
- `Ctrl+B` - 사이드바 토글
- `Ctrl+`` - 터미널 토글

### 편집
- `Ctrl+/` - 주석 토글
- `Ctrl+D` - 다음 같은 단어 선택
- `Alt+Up/Down` - 라인 이동
- `Shift+Alt+Up/Down` - 라인 복사
- `Ctrl+F` - 찾기
- `Ctrl+H` - 찾아 바꾸기

### Verilog 전용
- `Ctrl+Space` - 자동완성
- `F12` - 정의로 이동
- `Shift+F12` - 참조 찾기
- `Ctrl+Shift+O` - 심볼로 이동

---

## 🔧 개발 워크플로우

### 전형적인 개발 흐름

1. **파일 열기** (Ctrl+P)
   ```
   alu.v
   ```

2. **코드 수정**
   - 스니펫 사용 (예: `always-comb`)
   - 자동완성 활용 (Ctrl+Space)

3. **문법 검사**
   - 자동으로 실행됨
   - Problems 패널 확인 (Ctrl+Shift+M)

4. **시뮬레이션**
   - **Ctrl+Shift+B** 눌러 빌드
   - 또는 Task 선택

5. **결과 확인**
   - 터미널 출력 확인
   - 파형 열기 (gtkwave)

6. **반복**

### 예제: ALU에 XOR 추가

```verilog
// 1. rtl/alu.v 열기 (Ctrl+P → alu.v)

// 2. 코드 수정
localparam XOR = 3'b100;  // 추가

always @(*) begin
    case (alu_op)
        ADD: result = a + b;
        SUB: result = a - b;
        AND: result = a & b;
        OR:  result = a | b;
        XOR: result = a ^ b;  // 추가!
        default: result = 8'h00;
    endcase
end

// 3. 저장 (Ctrl+S)

// 4. 시뮬레이션 (Ctrl+Shift+B)

// 5. 결과 확인
```

---

## 🐛 디버깅

### 문법 오류 찾기

1. **Problems 패널** (Ctrl+Shift+M) 열기
2. 오류 클릭 → 해당 라인으로 이동
3. 오류 메시지 읽고 수정

### 시뮬레이션 오류

터미널 출력에서:
```
Error: Unknown module 'alu'
```

→ 모듈 이름 확인, 파일 경로 확인

### 논리 오류

1. **파형 분석**
   ```bash
   gtkwave cpu_tb.vcd
   ```

2. **Print 문 추가**
   ```verilog
   $display("Debug: alu_result=%d", alu_result);
   ```

3. **재시뮬레이션**

---

## 🎨 테마 및 설정 커스터마이징

### 권장 테마 (Verilog 코드에 좋음)

- **One Dark Pro**
- **Monokai Pro**
- **Dracula Official**

설치: Ctrl+Shift+X → "theme" 검색

### 폰트 설정

```json
// Settings (Ctrl+,) → settings.json 열기
{
    "editor.fontFamily": "Fira Code, Consolas, monospace",
    "editor.fontLigatures": true,
    "editor.fontSize": 14
}
```

---

## 📊 Waveform Viewer (선택)

VS Code 내장 VCD 뷰어 사용:

1. **Waveform Viewer** 확장 프로그램 설치
2. `.vcd` 파일 우클릭 → "Open with Waveform Viewer"
3. VS Code 내부에서 파형 보기

또는 외부 GTKWave:
```bash
gtkwave cpu_tb.vcd &
```

---

## 🔄 Git 통합 (선택)

### 초기화

```bash
git init
git add .
git commit -m "Initial CPU design"
```

### VS Code Git 기능

- **Source Control** 패널 (Ctrl+Shift+G)
- 변경사항 확인
- Commit, Push, Pull
- GitLens로 히스토리 보기

---

## 💡 프로 팁

### 1. Multi-Cursor 편집

여러 곳 동시 편집:
- `Alt+Click` - 커서 추가
- `Ctrl+Alt+Up/Down` - 위/아래에 커서 추가
- `Ctrl+D` - 같은 단어 선택

예시: 모든 `wire` → `reg` 변경
1. `wire` 선택
2. `Ctrl+D` 반복으로 모든 `wire` 선택
3. 타이핑: `reg`

### 2. 코드 폴딩

- `Ctrl+Shift+[` - 접기
- `Ctrl+Shift+]` - 펼치기

### 3. 분할 편집기

- `Ctrl+\` - 에디터 분할
- 좌측에 `.v` 파일, 우측에 `_tb.v` 파일 동시 편집

### 4. 빠른 문서 검색

- `Ctrl+Shift+F` - 전체 프로젝트 검색
- 정규식 지원

### 5. Task Output 고정

Task 실행 후 Output 패널이 자동으로 나타남
- 하단 고정하여 코드와 출력 동시 보기

---

## 📝 치트시트

| 작업 | 명령 |
|------|------|
| 파일 열기 | `Ctrl+P` |
| 명령 팔레트 | `Ctrl+Shift+P` |
| CPU 시뮬레이션 | `Ctrl+Shift+B` |
| 터미널 열기 | `Ctrl+`` |
| 문제 보기 | `Ctrl+Shift+M` |
| 찾기 | `Ctrl+F` |
| 바꾸기 | `Ctrl+H` |
| 저장 | `Ctrl+S` |
| 전체 저장 | `Ctrl+K S` |
| 닫기 | `Ctrl+W` |

---

## 🚀 고급 기능

### 1. Custom Task 추가

`.vscode/tasks.json`에 추가:

```json
{
    "label": "My Custom Simulation",
    "type": "shell",
    "command": "iverilog -o my_sim tb/my_tb.v rtl/my_module.v && vvp my_sim",
    "group": "test"
}
```

### 2. Workspace 저장

특정 파일 세트 자주 열기:
- 여러 파일 열기
- **File → Save Workspace As...**
- `.code-workspace` 파일로 저장

다음에는 해당 workspace 파일만 열면 됨

### 3. Settings Sync

여러 컴퓨터에서 동일한 설정 사용:
- GitHub 계정으로 로그인
- Settings Sync 활성화
- 모든 설정, 확장 프로그램 동기화

---

## ✅ VS Code 체크리스트

시작 전:
- [ ] VS Code 설치 (최신 버전)
- [ ] 권장 확장 프로그램 설치
- [ ] Iverilog, GTKWave 설치
- [ ] 프로젝트 폴더를 VS Code로 열기

개발 중:
- [ ] 문법 검사 활성화 확인
- [ ] Task로 시뮬레이션 실행
- [ ] Problems 패널로 오류 확인
- [ ] 터미널로 수동 명령 실행
- [ ] 파형으로 동작 검증

---

**VS Code로 즐거운 CPU 개발 되세요!** 🚀

문제가 있으면 `GETTING_STARTED.md` 또는 `README.md`를 참고하세요.
