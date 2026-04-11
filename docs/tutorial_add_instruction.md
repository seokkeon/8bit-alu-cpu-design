# Tutorial: 새로운 명령어 추가하기 (XOR)

이 튜토리얼에서는 CPU에 XOR 명령어를 추가하는 과정을 단계별로 설명합니다.

## 문제: 현재 ISA의 제약

현재 ISA는 2비트 opcode를 사용하여 4개의 명령어만 지원:
- 00: ADD
- 01: SUB
- 10: AND
- 11: OR

XOR을 추가하려면 **opcode를 3비트로 확장**해야 합니다.

---

## 해결방법: ISA 확장

### 새로운 명령어 형식
```
[7:5] - Opcode (3 bits) → 8개 명령어 지원 가능
[4:3] - Destination Register (2 bits)
[2:1] - Source Register A (2 bits)
[0]   - Source Register B (1 bit) + 추가 비트 활용
```

**문제점:** 레지스터 주소 공간 축소
- Rd: 2비트 → 4개 레지스터 ✓
- Ra: 2비트 → 4개 레지스터 ✓
- Rb: 1비트 → 2개 레지스터만! ✗

### 대안: 명령어 타입 분리

**Type-R (Register-Register):**
```
[7:5] - Opcode (3 bits)
[4:3] - Rd (2 bits)
[2:1] - Ra (2 bits)
[0]   - Rb (1 bit) - R0 또는 R1만 사용
```

**Type-I (Immediate):**
```
[7:5] - Opcode (3 bits)
[4:3] - Rd (2 bits)
[2:0] - Immediate value (3 bits)
```

---

## 단계별 구현

### Step 1: ALU 수정

```verilog
// rtl/alu.v
module alu (
    input  [7:0] a,
    input  [7:0] b,
    input  [2:0] alu_op,   // 2비트 → 3비트로 확장!
    output reg [7:0] result
);

    // ALU operation codes
    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;  // 새로운 명령어!
    
    always @(*) begin
        case (alu_op)
            ADD: result = a + b;
            SUB: result = a - b;
            AND: result = a & b;
            OR:  result = a | b;
            XOR: result = a ^ b;  // XOR 연산 추가
            default: result = 8'h00;
        endcase
    end

endmodule
```

### Step 2: CPU 수정

```verilog
// rtl/cpu.v 수정 부분

module cpu (
    input clk,
    input rst
);

    // ... (기존 코드)
    
    wire [2:0] opcode;  // 2비트 → 3비트로 변경
    
    // Decode instruction
    assign opcode = instruction[7:5];  // [7:6] → [7:5]로 변경
    assign rd     = instruction[4:3];  // [5:4] → [4:3]으로 변경
    assign ra     = instruction[2:1];  // [3:2] → [2:1]로 변경
    assign rb     = {1'b0, instruction[0]};  // [1:0] → [0]만 사용
    
    // ... (나머지 코드 동일)

endmodule
```

### Step 3: 테스트벤치 수정

```verilog
// tb/alu_tb.v에 추가

// Test XOR
alu_op = 3'b100; a = 8'hFF; b = 8'hAA; #10;
$display("%0t\tXOR\t%h\t%h\t%h\t%h %s", $time, a, b, result, 8'h55, 
         (result == 8'h55) ? "PASS" : "FAIL");

alu_op = 3'b100; a = 8'hF0; b = 8'hF0; #10;
$display("%0t\tXOR\t%h\t%h\t%h\t%h %s", $time, a, b, result, 8'h00, 
         (result == 8'h00) ? "PASS" : "FAIL");
```

### Step 4: ISA 문서 업데이트

```markdown
# docs/ISA_spec.md

## 확장된 명령어 세트 (8개)

| Opcode | Mnemonic | Description |
|--------|----------|-------------|
| 000 | ADD | Rd = Ra + Rb |
| 001 | SUB | Rd = Ra - Rb |
| 010 | AND | Rd = Ra & Rb |
| 011 | OR  | Rd = Ra | Rb |
| 100 | XOR | Rd = Ra ^ Rb |
| 101 | SHL | Rd = Ra << 1 |
| 110 | SHR | Rd = Ra >> 1 |
| 111 | NOT | Rd = ~Ra |
```

---

## 실습 과제

### 과제 1: XOR 구현 완성
1. 위의 변경사항을 적용
2. `make sim-alu` 실행
3. 테스트 통과 확인

### 과제 2: NOT 명령어 추가
```verilog
// Opcode 111: NOT
// NOT Rd, Ra  → Rd = ~Ra
// Rb는 사용하지 않음 (don't care)
```

힌트:
```verilog
localparam NOT = 3'b111;

case (alu_op)
    // ... 기존 코드
    NOT: result = ~a;  // b는 무시
    // ...
endcase
```

### 과제 3: 시프트 연산 추가
```verilog
// SHL (Shift Left): Rd = Ra << 1
// SHR (Shift Right): Rd = Ra >> 1
```

---

## 검증 프로그램

### XOR 테스트 프로그램
```assembly
# R1 = 0xFF, R2 = 0xAA
# R0 = R1 XOR R2 = 0x55

Instruction encoding:
100_00_01_0  (XOR R0, R1, R0)
→ 0x82

Binary: 10000010
```

### CPU 테스트벤치에 추가
```verilog
// tb/cpu_tb.v

// Initialize registers
force uut.rf.registers[1] = 8'hFF;
force uut.rf.registers[2] = 8'hAA;

// Test program
imem[0] = 8'b100_00_01_0;  // XOR R0, R1, R0
imem[1] = 8'b100_11_01_0;  // XOR R3, R1, R2

// Expected results:
// R0 = 0xFF XOR 0x00 = 0xFF (if R0 starts at 0)
// R3 = 0xFF XOR 0xAA = 0x55
```

---

## 흔한 실수들

### 실수 1: Opcode 비트 위치 혼동
```verilog
// ❌ 잘못됨
assign opcode = instruction[6:4];  // 중간 3비트

// ✅ 올바름
assign opcode = instruction[7:5];  // 상위 3비트
```

### 실수 2: 레지스터 주소 오버플로우
```verilog
// ❌ 문제: Rb가 1비트인데 2비트 주소 사용
assign rb = instruction[1:0];  // 1비트만 있는데 2비트 읽기

// ✅ 해결책
assign rb = {1'b0, instruction[0]};  // 0으로 패딩
```

### 실수 3: Testbench에서 opcode 크기 안맞춤
```verilog
// ❌ 잘못됨
reg [1:0] alu_op;  // 아직 2비트

// ✅ 올바름
reg [2:0] alu_op;  // 3비트로 확장
```

---

## 다음 단계 제안

1. **더 많은 명령어 추가**
   - SHL, SHR (Shift)
   - ROL, ROR (Rotate)
   - CMP (Compare, 플래그 설정)

2. **Immediate 모드 구현**
   - 상수 값을 직접 명령어에 포함
   - ADDI Rd, Ra, #imm

3. **조건부 분기**
   - BEQ (Branch if Equal)
   - BNE (Branch if Not Equal)
   - Program Counter 수정 필요

4. **메모리 접근**
   - LOAD Rd, [Ra]
   - STORE Rd, [Ra]
   - Data Memory 추가 필요

---

## 체크리스트

완료 후 확인사항:

- [ ] ALU에 XOR 케이스 추가
- [ ] ALU opcode 3비트로 확장
- [ ] CPU의 opcode 디코딩 수정
- [ ] 레지스터 주소 필드 조정
- [ ] 테스트벤치 업데이트
- [ ] ISA 문서 업데이트
- [ ] 모든 시뮬레이션 통과
- [ ] 합성 가능한지 확인

```bash
# 전체 테스트 실행
make sim-alu
make sim-cpu
make synth
```

축하합니다! CPU를 성공적으로 확장했습니다. 🎉
