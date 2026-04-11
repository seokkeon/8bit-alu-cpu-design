# 타이밍 분석 및 성능 평가

## 1. 단일 사이클 CPU 타이밍 분석

### 클럭 주기 계산

단일 사이클 CPU의 최소 클럭 주기는 가장 긴 경로(Critical Path)에 의해 결정됩니다.

```
T_clk >= T_pc + T_imem + T_decode + T_regread + T_alu + T_regsetup

여기서:
- T_pc       : Program Counter 출력 지연 (~0.5ns)
- T_imem     : Instruction Memory 접근 시간 (~2ns)
- T_decode   : 명령어 디코딩 (조합 논리) (~0.5ns)
- T_regread  : Register File 읽기 (~1ns)
- T_alu      : ALU 연산 (~2ns)
- T_regsetup : Register File 셋업 시간 (~0.5ns)

총 Critical Path: ~6.5ns
최대 클럭 주파수: ~154 MHz
```

### 실제 합성 후 예상 결과

```
Technology: Generic ASIC (typical)
----------------------------------
Critical Path Delay: 6-8 ns
Maximum Frequency:   125-166 MHz
Power Consumption:   ~5-10 mW @ 100MHz

FPGA (Xilinx Artix-7):
----------------------------------
Critical Path Delay: 8-12 ns
Maximum Frequency:   83-125 MHz
LUTs used:          ~150
Flip-Flops:         ~24
Block RAM:          0
```

## 2. 경로별 지연 분석

### Critical Path 상세 분석

```
Stage 1: Instruction Fetch
  PC → Instruction Memory
  Delay: 2.5ns
  
Stage 2: Decode
  Instruction → opcode, rd, ra, rb
  Delay: 0.5ns (조합 논리)
  
Stage 3: Register Read
  ra, rb → Register File → ra_data, rb_data
  Delay: 1.0ns
  
Stage 4: Execute (ALU)
  ra_data, rb_data → ALU → result
  Delay: 2.0ns
  - ADD/SUB: 2.0ns (Ripple-carry adder)
  - AND/OR:  0.5ns (단순 게이트)
  
Stage 5: Write Back
  result → Register File setup
  Delay: 0.5ns
  
Total: 6.5ns
```

## 3. 리소스 사용량 추정

### 게이트 레벨 분석

```
모듈              플립플롭    조합 논리 게이트
---------------------------------------------------
Program Counter      8           10 (incrementer)
Register File       32           50 (4x8 mux)
ALU                  0          100 (adder, logic)
Control Logic        0           20
---------------------------------------------------
Total               40          180
```

### FPGA 리소스 추정 (Xilinx)

```
리소스 타입         사용량    비율 (Artix-7 35T 기준)
--------------------------------------------------------
Slice LUTs          ~150      0.29%
Slice Registers      ~40      0.08%
Block RAM             0       0%
DSP48 Slices          0       0%
```

## 4. 성능 최적화 방안

### 현재 설계의 병목 구간

1. **ALU 지연** (2ns) - Critical Path의 31%
   - Ripple-carry adder 사용
   - 개선: Carry-lookahead adder로 변경

2. **Instruction Memory** (2ns) - 31%
   - 현재: 조합 논리 ROM
   - 개선: Block RAM 사용 (FPGA)

3. **단일 사이클 제약**
   - 모든 명령어가 동일한 시간 소요
   - 개선: 멀티사이클 또는 파이프라인

### 최적화 전략

#### Strategy 1: 멀티사이클 CPU
```
장점:
- 평균 CPI 감소 가능
- 하드웨어 재사용 → 면적 감소
- 복잡한 명령어 추가 용이

단점:
- 제어 로직 복잡도 증가
- 평균 실행 시간은 비슷할 수 있음
```

#### Strategy 2: 파이프라인 (5단)
```
IF → ID → EX → MEM → WB

장점:
- 처리량 5배 증가 (이상적)
- 높은 클럭 주파수

단점:
- Data hazard 처리 필요
- Branch penalty
- 면적 증가 (파이프라인 레지스터)

예상 성능:
- 클럭 주파수: 400-500 MHz
- CPI: 1.0-1.5 (hazard 포함)
- 처리량: 3-4배 향상
```

## 5. 벤치마크 프로그램

### Test Program 1: 산술 연산
```verilog
// R3 = (R1 + R2) - R0
ADD R3, R1, R2    // 1 cycle
SUB R3, R3, R0    // 1 cycle
Total: 2 cycles @ 154MHz = 13ns
```

### Test Program 2: 논리 연산 체인
```verilog
// R0 = (R1 AND R2) OR R3
AND R0, R1, R2    // 1 cycle
OR  R0, R0, R3    // 1 cycle
Total: 2 cycles = 13ns
```

## 6. 전력 소비 분석

### 동적 전력 (Dynamic Power)
```
P_dynamic = α × C × V² × f

여기서:
- α = 전환 활동도 (switching activity) ~0.1
- C = 총 커패시턴스 ~50pF
- V = 전압 1.0V (FPGA) or 0.9V (ASIC)
- f = 클럭 주파수 100MHz

예상 동적 전력: ~5mW
```

### 정적 전력 (Leakage)
```
현대 공정 (28nm, 7nm):
- FPGA: ~10-20mW (전체 칩)
- ASIC: ~1-2mW (이 CPU만)
```

## 7. 개선 로드맵

### Phase 1: 기본 최적화 (Week 2-3)
- [ ] Carry-lookahead adder 구현
- [ ] 명령어 메모리 Block RAM으로 변경
- [ ] 타이밍 제약 추가 (SDC 파일)

### Phase 2: 아키텍처 개선 (Week 4-6)
- [ ] 5단 파이프라인 구현
- [ ] Hazard detection unit
- [ ] Forwarding unit
- [ ] Branch prediction (간단한 정적 예측)

### Phase 3: 고급 기능 (Week 7-10)
- [ ] L1 캐시 추가
- [ ] 부동소수점 연산
- [ ] 인터럽트 처리
- [ ] DMA 컨트롤러

## 8. 측정 방법

### 시뮬레이션에서 성능 측정
```verilog
// testbench에 추가
initial begin
    integer cycle_count = 0;
    integer start_time, end_time;
    
    start_time = $time;
    
    @(posedge program_complete);
    
    end_time = $time;
    cycle_count = (end_time - start_time) / CLOCK_PERIOD;
    
    $display("Execution time: %0d ns", end_time - start_time);
    $display("Cycles: %0d", cycle_count);
    $display("IPC: %f", num_instructions / cycle_count);
end
```

### 합성 후 타이밍 리포트 확인
```bash
# Yosys에서 타이밍 정보 추출
yosys -p "read_verilog cpu.v; synth; stat -top cpu"

# 또는 상용 툴 사용
# Vivado: Report Timing Summary
# Quartus: TimeQuest Timing Analyzer
```

## 9. 결론

현재 설계:
- ✅ 단순하고 이해하기 쉬움
- ✅ 교육용으로 적합
- ⚠️  성능은 제한적 (~150MHz)
- ⚠️  확장성 고려 필요

다음 단계:
1. 타이밍 제약 추가
2. 합성 후 실제 측정
3. 성능 병목 구간 최적화
4. 파이프라인으로 진화
