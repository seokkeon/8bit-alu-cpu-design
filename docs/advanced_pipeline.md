# 고급 예제: 5단 파이프라인 CPU

이 문서는 **참고용**입니다. 기본 CPU를 완성한 후 도전해보세요.

## 파이프라인 단계

```
1. IF  (Instruction Fetch)   - 명령어 가져오기
2. ID  (Instruction Decode)  - 명령어 해독 & 레지스터 읽기
3. EX  (Execute)             - ALU 실행
4. MEM (Memory Access)       - 메모리 접근 (미구현)
5. WB  (Write Back)          - 레지스터 쓰기
```

## 파이프라인 레지스터

각 단계 사이에 레지스터가 필요:

```verilog
// IF/ID Pipeline Register
reg [7:0] IF_ID_instruction;
reg [7:0] IF_ID_pc;

// ID/EX Pipeline Register
reg [7:0] ID_EX_pc;
reg [2:0] ID_EX_opcode;
reg [1:0] ID_EX_rd;
reg [7:0] ID_EX_ra_data;
reg [7:0] ID_EX_rb_data;

// EX/MEM Pipeline Register
reg [7:0] EX_MEM_alu_result;
reg [1:0] EX_MEM_rd;
reg       EX_MEM_reg_we;

// MEM/WB Pipeline Register
reg [7:0] MEM_WB_data;
reg [1:0] MEM_WB_rd;
reg       MEM_WB_reg_we;
```

## Hazard 처리

### 1. Data Hazard

**문제:**
```assembly
ADD R1, R2, R3   # Cycle 1: R1에 쓰기 (WB는 Cycle 5)
SUB R4, R1, R5   # Cycle 2: R1을 읽기 (ID는 Cycle 2)
                 # R1의 새 값이 아직 준비 안됨!
```

**해결책 1: Stall (지연)**
```verilog
// Hazard Detection Unit
assign data_hazard = (ID_EX_rd == rs1) || (ID_EX_rd == rs2) ||
                     (EX_MEM_rd == rs1) || (EX_MEM_rd == rs2);

assign stall = data_hazard;
```

**해결책 2: Forwarding (우회)**
```verilog
// Forwarding Unit
if (EX_MEM_reg_we && (EX_MEM_rd == rs1))
    forward_a = EX_MEM_alu_result;
else if (MEM_WB_reg_we && (MEM_WB_rd == rs1))
    forward_a = MEM_WB_data;
else
    forward_a = ra_data;
```

### 2. Control Hazard (분기)

**문제:**
```assembly
BEQ R1, R2, target   # 분기 결과는 EX 단계에서 알 수 있음
ADD R3, R4, R5       # 이미 IF 단계 진입
SUB R6, R7, R8       # 이미 ID 단계 진입
target: ...
```

**해결책: Branch Prediction + Flush**
```verilog
// Simple static prediction: always not taken
if (branch_taken && branch_predicted_not_taken) begin
    // Flush IF/ID and ID/EX stages
    IF_ID_instruction <= 8'h00;  // NOP
    ID_EX_opcode <= 3'b000;      // NOP
end
```

## 완전한 파이프라인 CPU 스켈레톤

```verilog
module pipelined_cpu (
    input clk,
    input rst
);

    //===========================================
    // IF Stage
    //===========================================
    reg [7:0] pc;
    reg [7:0] imem [0:255];
    wire [7:0] instruction;
    
    assign instruction = imem[pc];
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 8'h00;
        else if (!stall)
            pc <= pc_next;
    end
    
    //===========================================
    // IF/ID Pipeline Register
    //===========================================
    reg [7:0] IF_ID_instruction;
    reg [7:0] IF_ID_pc;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_ID_instruction <= 8'h00;
            IF_ID_pc <= 8'h00;
        end else if (!stall) begin
            IF_ID_instruction <= instruction;
            IF_ID_pc <= pc;
        end
    end
    
    //===========================================
    // ID Stage
    //===========================================
    wire [2:0] opcode;
    wire [1:0] rd, rs1, rs2;
    wire [7:0] rs1_data, rs2_data;
    
    assign opcode = IF_ID_instruction[7:5];
    assign rd     = IF_ID_instruction[4:3];
    assign rs1    = IF_ID_instruction[2:1];
    assign rs2    = {1'b0, IF_ID_instruction[0]};
    
    regfile rf (
        .clk(clk),
        .rst(rst),
        .we(MEM_WB_reg_we),
        .rd_addr(MEM_WB_rd),
        .ra_addr(rs1),
        .rb_addr(rs2),
        .wr_data(MEM_WB_data),
        .ra_data(rs1_data),
        .rb_data(rs2_data)
    );
    
    //===========================================
    // ID/EX Pipeline Register
    //===========================================
    reg [2:0] ID_EX_opcode;
    reg [1:0] ID_EX_rd;
    reg [7:0] ID_EX_rs1_data;
    reg [7:0] ID_EX_rs2_data;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ID_EX_opcode <= 3'b000;
            ID_EX_rd <= 2'b00;
            ID_EX_rs1_data <= 8'h00;
            ID_EX_rs2_data <= 8'h00;
        end else begin
            ID_EX_opcode <= opcode;
            ID_EX_rd <= rd;
            ID_EX_rs1_data <= rs1_data;
            ID_EX_rs2_data <= rs2_data;
        end
    end
    
    //===========================================
    // EX Stage
    //===========================================
    wire [7:0] alu_result;
    
    alu alu_unit (
        .a(ID_EX_rs1_data),
        .b(ID_EX_rs2_data),
        .alu_op(ID_EX_opcode),
        .result(alu_result)
    );
    
    //===========================================
    // EX/MEM Pipeline Register
    //===========================================
    reg [7:0] EX_MEM_alu_result;
    reg [1:0] EX_MEM_rd;
    reg       EX_MEM_reg_we;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            EX_MEM_alu_result <= 8'h00;
            EX_MEM_rd <= 2'b00;
            EX_MEM_reg_we <= 1'b0;
        end else begin
            EX_MEM_alu_result <= alu_result;
            EX_MEM_rd <= ID_EX_rd;
            EX_MEM_reg_we <= 1'b1;  // Always write
        end
    end
    
    //===========================================
    // MEM Stage (현재는 pass-through)
    //===========================================
    // 추후 Data Memory 추가 가능
    
    //===========================================
    // MEM/WB Pipeline Register
    //===========================================
    reg [7:0] MEM_WB_data;
    reg [1:0] MEM_WB_rd;
    reg       MEM_WB_reg_we;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            MEM_WB_data <= 8'h00;
            MEM_WB_rd <= 2'b00;
            MEM_WB_reg_we <= 1'b0;
        end else begin
            MEM_WB_data <= EX_MEM_alu_result;
            MEM_WB_rd <= EX_MEM_rd;
            MEM_WB_reg_we <= EX_MEM_reg_we;
        end
    end
    
    //===========================================
    // Hazard Detection (Simplified)
    //===========================================
    wire stall;
    assign stall = 1'b0;  // TODO: Implement
    
    wire [7:0] pc_next;
    assign pc_next = pc + 1;  // TODO: Handle branches

endmodule
```

## 성능 비교

### 단일 사이클 vs 파이프라인

**프로그램: 10개 독립 명령어**

```
단일 사이클:
- CPI = 1.0
- 클럭 주기 = 6.5ns
- 총 시간 = 10 × 6.5ns = 65ns

5단 파이프라인:
- CPI = 1.0 (hazard 없으면)
- 클럭 주기 = 1.5ns (가장 느린 단계)
- 총 시간 = (5 + 10) × 1.5ns = 22.5ns
- 속도 향상: 2.9배!
```

## 실습 과제

1. **파이프라인 레지스터 추가**
   - 위의 스켈레톤 코드 완성
   - 각 단계별 동작 확인

2. **Hazard Detection 구현**
   - Data hazard 감지
   - Stall 신호 생성

3. **Forwarding 구현**
   - EX/MEM → EX forwarding
   - MEM/WB → EX forwarding

4. **분기 처리**
   - BEQ 명령어 추가
   - Branch prediction
   - Pipeline flush

## 참고 자료

- "Computer Organization and Design" - Patterson & Hennessy
- RISC-V 파이프라인 구현 사례
- MIPS 파이프라인 아키텍처

---

**경고:** 파이프라인 CPU는 단일 사이클보다 훨씬 복잡합니다!
기본 CPU를 완전히 이해한 후 시도하세요.
