# ⚡ 빠른 참조 카드 (Quick Reference)

## 🎯 한눈에 보는 명령어

### 시뮬레이션
```bash
make sim-alu        # ALU 테스트
make sim-regfile    # 레지스터 파일 테스트
make sim-cpu        # CPU 전체 테스트
make view-cpu       # 파형 보기
```

### 합성
```bash
make synth          # Yosys 합성 실행
make clean          # 생성 파일 삭제
```

### 수동 실행
```bash
# 컴파일
iverilog -o cpu_sim tb/cpu_tb.v rtl/*.v

# 실행
vvp cpu_sim

# 파형 보기
gtkwave cpu_tb.vcd
```

---

## 📋 ISA 요약

### 명령어 형식 (8비트)
```
[7:6] Opcode | [5:4] Rd | [3:2] Ra | [1:0] Rb
```

### 명령어 세트
| Op | Inst | 설명 | 예시 |
|----|------|------|------|
| 00 | ADD  | Rd = Ra + Rb | ADD R0,R1,R2 |
| 01 | SUB  | Rd = Ra - Rb | SUB R0,R1,R2 |
| 10 | AND  | Rd = Ra & Rb | AND R0,R1,R2 |
| 11 | OR   | Rd = Ra \| Rb | OR R0,R1,R2 |

---

## 🔧 모듈 개요

### ALU (alu.v)
- **입력**: a[7:0], b[7:0], alu_op[1:0]
- **출력**: result[7:0]
- **동작**: 조합 논리

### Register File (regfile.v)
- **레지스터**: 4개 (R0-R3), 각 8비트
- **포트**: 2 read, 1 write
- **읽기**: 비동기
- **쓰기**: 동기 (clk 상승 엣지)

### CPU (cpu.v)
- **구조**: 단일 사이클
- **메모리**: 16 × 8비트 명령어
- **CPI**: 1.0

---

## 🐛 디버깅 팁

### 시뮬레이션 오류
```bash
# 문법 체크
iverilog -t null rtl/alu.v

# 상세 로그
vvp -v cpu_sim
```

### 파형 분석 순서
1. **clk** - 클럭 확인
2. **pc** - 프로그램 카운터 진행
3. **instruction** - 명령어 변화
4. **alu_result** - 연산 결과
5. **registers** - 레지스터 값 변화

### 흔한 문제
- **X (unknown)**: 초기화 안됨
- **Z (high-Z)**: 연결 끊김
- **빨간선**: 다중 드라이버

---

## 📁 파일 위치

```
cpu_project/
├── rtl/              ← Verilog 소스
├── tb/               ← 테스트벤치
├── docs/             ← 문서
├── synth/            ← 합성 결과
├── Makefile          ← 빌드 자동화
└── README.md         ← 프로젝트 개요
```

---

## 🎓 학습 순서

1. **Day 1**: ALU 이해 및 시뮬레이션
2. **Day 2**: Register File 이해
3. **Day 3**: CPU 통합 및 실행
4. **Day 4**: 합성 및 분석
5. **Day 5+**: 확장 및 최적화

---

## 💾 예제 프로그램

### 프로그램 1: 덧셈
```assembly
# R0 = R1 + R2
# R1=5, R2=3이라 가정
ADD R0, R1, R2    # 0x06
→ R0 = 8
```

### 프로그램 2: 복합 연산
```assembly
# R3 = (R1 + R2) AND R0
ADD R3, R1, R2    # 0x36
AND R3, R3, R0    # 0xBC
```

### CPU에서 실행
```verilog
// rtl/cpu.v에서 수정
imem[0] = 8'b00_00_01_10;  // ADD R0, R1, R2
imem[1] = 8'b01_11_00_10;  // SUB R3, R0, R2
```

---

## ⚙️ 설정

### Verilog 문법 기본
```verilog
// 조합 논리
always @(*) begin
    result = a + b;
end

// 순차 논리 (플립플롭)
always @(posedge clk) begin
    register <= value;
end

// 리셋 포함
always @(posedge clk or posedge rst) begin
    if (rst)
        register <= 0;
    else
        register <= value;
end
```

---

## 📊 성능 지표

### 예상 결과
- **게이트**: ~180
- **FF**: ~40
- **주파수**: ~150MHz
- **면적**: 작음
- **전력**: ~5mW

---

## 🔗 유용한 링크

- **Verilog**: hdlbits.01xz.net
- **시뮬레이터**: edaplayground.com
- **문서**: 프로젝트 내 docs/ 폴더
- **튜토리얼**: GETTING_STARTED.md

---

## ✅ 체크리스트

시작하기 전:
- [ ] iverilog 설치
- [ ] gtkwave 설치
- [ ] yosys 설치 (선택)

완료 기준:
- [ ] ALU 시뮬레이션 통과
- [ ] RegFile 시뮬레이션 통과
- [ ] CPU 시뮬레이션 통과
- [ ] 파형으로 동작 확인
- [ ] 합성 성공

---

**이 카드를 인쇄하거나 저장해두고 참고하세요!** 📌
