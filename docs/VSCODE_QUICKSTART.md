# 🎨 VS Code 빠른 시작 - 비주얼 가이드

## 프로젝트를 VS Code로 열었을 때

### 첫 실행 시 나타나는 화면

```
┌─────────────────────────────────────────────────────────────┐
│ 📁 cpu_project - Visual Studio Code                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ⚠️  This workspace has extension recommendations          │
│                                                             │
│  Do you want to install recommended extensions?            │
│                                                             │
│  [Show Recommendations]  [Install All]  [Ignore]          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**→ "Install All" 클릭!**

---

## 설치 후 화면 구성

```
┌──────────────────────────────────────────────────────────────────┐
│ File  Edit  Selection  View  ...                        ⊡ ⊗ ✕  │
├────┬─────────────────────────────────────────────────────────────┤
│ 📁 │ EXPLORER                                    alu.v ×         │
│ 🔍 │                                                              │
│ ⎇  │ ▼ CPU_PROJECT                          1 // alu.v          │
│ ▶️ │   ▼ .vscode                            2                    │
│ ⚙️ │     ▸ rtl                              3 module alu (       │
│    │       ▸ alu.v                         4     input  [7:0] a,│
│    │       ▸ regfile.v  ← 여기 클릭!       5     input  [7:0] b,│
│    │       ▸ cpu.v                         6     input  [1:0]..│
│    │     ▸ tb                              7     output [7:0]..│
│    │     ▸ docs                            8 );                 │
│    │     ▸ Makefile                        9                    │
│    │     ▸ README.md                      10     localparam ... │
├────┴─────────────────────────────────────────────────────────────┤
│ TERMINAL                                    × bash           - ▼│
│                                                                  │
│ $ make sim-alu                                                   │
│ Simulating ALU...                                                │
│ ✓ ALU simulation complete!                                       │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 주요 영역 설명

### 1. 왼쪽 사이드바 (Activity Bar)

```
📁  Explorer        - 파일 탐색
🔍  Search          - 전체 검색
⎇   Source Control - Git 관리
▶️  Run and Debug   - 디버깅
⚙️  Extensions      - 확장 프로그램
```

### 2. Explorer (파일 트리)

```
cpu_project/
├── 📁 .vscode/          ← VS Code 설정 (자동 생성)
│   ├── settings.json
│   ├── tasks.json
│   └── ...
├── 📁 rtl/              ← RTL 소스 코드
│   ├── 📄 alu.v
│   ├── 📄 regfile.v
│   └── 📄 cpu.v
├── 📁 tb/               ← 테스트벤치
├── 📁 docs/             ← 문서
└── 📄 Makefile
```

**클릭하면 오른쪽에 파일 내용 표시**

### 3. 에디터 영역

코드 편집 + 문법 강조:

```verilog
module alu (
    input  [7:0] a,      ← 파란색
    input  [7:0] b,      ← 파란색
    input  [1:0] alu_op, ← 파란색
    output reg [7:0] result  ← 빨간색 (키워드)
);
    localparam ADD = 2'b00;  ← 초록색 (숫자)
    
    always @(*) begin        ← 보라색 (키워드)
        case (alu_op)        ← 오렌지색
            ADD: result = a + b;
            ...
        endcase
    end
endmodule
```

### 4. 하단 터미널

직접 명령어 실행:

```bash
$ make sim-alu       ← 입력
$ make sim-cpu       ← 입력
$ gtkwave cpu_tb.vcd ← 파형 보기
```

---

## 시뮬레이션 실행 방법

### 방법 1: 키보드 단축키 (가장 빠름!)

```
Ctrl + Shift + B
```

→ 기본 Task (CPU 시뮬레이션) 실행

### 방법 2: 명령 팔레트

```
Step 1: Ctrl + Shift + P

Step 2: 입력창에 "task" 입력

Step 3: "Tasks: Run Task" 선택

Step 4: 원하는 Task 선택
        - Simulate ALU
        - Simulate CPU
        - View CPU Waveform
        ...
```

### 방법 3: 터미널에서 직접

```
Step 1: Ctrl + `  (백틱, ESC 아래)

Step 2: 명령어 입력
        $ make sim-alu
```

---

## Task 실행 화면

### 시뮬레이션 실행 중:

```
┌──────────────────────────────────────────────────────────┐
│ TERMINAL                           × Task - Simulate CPU │
├──────────────────────────────────────────────────────────┤
│ > Executing task: make sim-cpu <                         │
│                                                           │
│ Compiling and simulating CPU...                          │
│ iverilog -o cpu_sim tb/cpu_tb.v rtl/cpu.v ...           │
│ vvp cpu_sim                                              │
│                                                           │
│ === Starting CPU Testbench ===                           │
│                                                           │
│ Initial values: R1=5, R2=3                               │
│                                                           │
│ Time  PC  Instr  Opcode  Rd  Ra  Rb  ALU_Result         │
│ ----  --  -----  ------  --  --  --  ----------         │
│ 25    0   06     00      0   1   2   8                  │
│ 35    1   2e     01      3   0   2   5                  │
│ ...                                                       │
│                                                           │
│ ✓ CPU simulation complete!                               │
│                                                           │
│ Terminal will be reused by tasks.                       │
└──────────────────────────────────────────────────────────┘
```

**성공!** ✓ 마크 확인

---

## 오류가 있을 때

### Problems 패널 (Ctrl+Shift+M)

```
┌──────────────────────────────────────────────────────────┐
│ 🔴 PROBLEMS                                        2     │
├──────────────────────────────────────────────────────────┤
│ ⚠️  alu.v [Line 15, Column 5]                            │
│     syntax error near text "endcase"                     │
│     Missing semicolon?                                   │
│                                                           │
│ ❌  cpu.v [Line 42, Column 12]                           │
│     Unknown module 'alu'                                 │
│     Check module name and file path                      │
└──────────────────────────────────────────────────────────┘
```

**오류 클릭** → 해당 파일, 라인으로 자동 이동!

---

## 코드 자동완성

### 타이핑 중:

```verilog
al ← 타이핑

┌─────────────────┐
│ ▼ always        │ ← 추천 목록
│   assign        │
│   and           │
└─────────────────┘

Enter 또는 Tab → 선택
```

### 스니펫 사용:

```verilog
always-comb ← 타이핑 + Tab

↓ 자동 확장

always @(*) begin
    |  ← 커서 위치
end
```

---

## 분할 화면

### 코드와 테스트벤치 동시 보기

```
┌────────────────────────┬────────────────────────┐
│ alu.v               ×  │ alu_tb.v            ×  │
├────────────────────────┼────────────────────────┤
│                        │                        │
│ module alu (           │ module alu_tb;         │
│     input [7:0] a,     │     reg [7:0] a;       │
│     input [7:0] b,     │     reg [7:0] b;       │
│     ...                │     ...                │
│ );                     │                        │
│                        │     alu uut (          │
│     always @(*) begin  │         .a(a),         │
│         case (alu_op)  │         .b(b),         │
│             ...        │         ...            │
│                        │                        │
└────────────────────────┴────────────────────────┘
```

**Ctrl+\** 로 화면 분할!

---

## 실전 예제: ALU에 XOR 추가

### Step-by-Step

```
1. Ctrl+P → "alu.v" 입력 → Enter
   (alu.v 파일 열림)

2. localparam 섹션에 추가:
   localparam XOR = 2'b?? ← ?는 뭘 쓸까? 🤔

3. Ctrl+Space (자동완성)
   → 기존 opcode 확인 → 적절한 값 선택

4. case 문에 추가:
   XOR: result = a ^ b;

5. Ctrl+S (저장)
   → 자동으로 문법 검사 실행
   → Problems 패널에 오류 표시 (있다면)

6. Ctrl+Shift+B (시뮬레이션)
   → 터미널에 결과 표시

7. 성공! ✓
```

---

## 파형 보기

### GTKWave 실행

```
방법 1: Task 사용
  Ctrl+Shift+P → "View CPU Waveform"

방법 2: 터미널
  $ gtkwave cpu_tb.vcd &

방법 3: (확장 프로그램 설치 시)
  .vcd 파일 우클릭 → "Open with Waveform Viewer"
  → VS Code 내부에서 파형 보기!
```

---

## 🎓 익숙해지는 팁

### Day 1: 기본 조작
- [ ] `Ctrl+P`로 파일 열기 연습
- [ ] `Ctrl+Shift+B`로 빌드 연습
- [ ] 터미널에서 명령어 실행

### Day 2: 코드 편집
- [ ] 스니펫 사용해보기
- [ ] 자동완성 활용
- [ ] Problems 패널 확인

### Day 3: 고급 기능
- [ ] 분할 화면 사용
- [ ] Multi-cursor 편집
- [ ] Git 통합

---

## 단축키 치트시트 (데스크탑에 붙여두기!)

```
┌─────────────────────────────────────────┐
│  VS Code Verilog 개발 핵심 단축키      │
├─────────────────────────────────────────┤
│  Ctrl+P         파일 빠른 열기          │
│  Ctrl+Shift+P   명령 팔레트             │
│  Ctrl+Shift+B   빌드/시뮬레이션        │
│  Ctrl+`         터미널 토글             │
│  Ctrl+Shift+M   Problems 패널           │
│  Ctrl+/         주석 토글               │
│  Ctrl+Space     자동완성                │
│  F12            정의로 이동             │
│  Ctrl+\         에디터 분할             │
│  Ctrl+S         저장                    │
└─────────────────────────────────────────┘
```

---

**이제 VS Code로 CPU를 만들어보세요!** 🚀

더 자세한 내용은 `docs/VSCODE_SETUP.md`를 참고하세요.
