# 🎓 CPU 프로젝트 완료 가이드

## ✅ 프로젝트 체크리스트

### Week 1: 기초 구축
- [x] 프로젝트 구조 생성
- [x] ISA 설계 (8비트, 4개 명령어)
- [x] ALU 모듈 구현
- [x] Register File 구현
- [x] 테스트벤치 작성
- [ ] 모든 시뮬레이션 실행 및 통과

### Week 2: CPU 통합
- [x] 단일 사이클 CPU 구현
- [x] CPU 테스트벤치 작성
- [ ] 프로그램 실행 검증
- [ ] 디버깅 및 최적화

### Week 3: 합성 및 분석
- [ ] Yosys 합성 실행
- [ ] 타이밍 분석
- [ ] 리소스 사용량 측정
- [ ] 결과 문서화

### Week 4: 확장 및 개선
- [ ] 새 명령어 추가 (XOR, SHL, SHR)
- [ ] 성능 최적화
- [ ] 고급 기능 구현 (선택)

---

## 📊 학습 목표 달성도

### 필수 목표
1. **RTL 설계 이해**
   - ✅ Verilog 문법 숙지
   - ✅ 조합 논리 vs 순차 논리
   - ✅ 모듈화 설계

2. **CPU 마이크로아키텍처**
   - ✅ Fetch-Decode-Execute 사이클
   - ✅ Datapath 구조
   - ✅ Control signals

3. **시뮬레이션 기법**
   - ✅ Testbench 작성
   - ✅ Waveform 분석
   - ✅ Verification 전략

4. **합성 프로세스**
   - ✅ RTL to Gates 변환
   - ✅ 타이밍 제약
   - ✅ 리소스 최적화

### 선택 목표 (고급)
- [ ] 파이프라인 구현
- [ ] Hazard 처리
- [ ] 캐시 메모리
- [ ] FPGA 구현

---

## 🚀 다음 명령어 한눈에 보기

### 시뮬레이션
```bash
# ALU 테스트
make sim-alu

# Register File 테스트
make sim-regfile

# 전체 CPU 테스트
make sim-cpu

# Waveform 보기
make view-cpu
```

### 합성
```bash
# Yosys 합성
make synth

# 다이어그램 생성
dot -Tpng synth/cpu_diagram.dot -o synth/cpu_diagram.png
```

### 정리
```bash
# 생성된 파일 삭제
make clean
```

---

## 📚 주요 파일 설명

### RTL 소스코드
- `rtl/alu.v` - 8비트 ALU (ADD, SUB, AND, OR)
- `rtl/regfile.v` - 4x8비트 레지스터 파일
- `rtl/cpu.v` - 단일 사이클 CPU 코어

### 테스트벤치
- `tb/alu_tb.v` - ALU 검증
- `tb/regfile_tb.v` - 레지스터 파일 검증
- `tb/cpu_tb.v` - CPU 통합 검증

### 문서
- `README.md` - 프로젝트 개요
- `GETTING_STARTED.md` - 빠른 시작 가이드
- `docs/ISA_spec.md` - 명령어 세트 사양
- `docs/architecture.md` - 아키텍처 다이어그램
- `docs/timing_analysis.md` - 타이밍 및 성능 분석
- `docs/tutorial_add_instruction.md` - 명령어 추가 튜토리얼
- `docs/advanced_pipeline.md` - 파이프라인 참고 자료

### 빌드 스크립트
- `Makefile` - 자동화된 빌드 시스템
- `simulate.sh` - 시뮬레이션 스크립트
- `synthesize.sh` - 합성 스크립트

---

## 🎯 예상 학습 시간

### 초보자 (Verilog 처음)
- Week 1-2: 기초 학습 및 개별 모듈 이해
- Week 3: CPU 통합 및 디버깅
- Week 4: 합성 및 확장
- **총 4주**

### 중급자 (Verilog 경험 있음)
- Week 1: 전체 구현
- Week 2: 합성 및 최적화
- Week 3: 고급 기능 추가
- **총 2-3주**

### 고급자 (CPU 설계 경험)
- 1-2일: 기본 구현
- 3-4일: 파이프라인 변환
- 5-7일: 성능 최적화
- **총 1주**

---

## 💡 자주 묻는 질문 (FAQ)

### Q1: 시뮬레이션이 동작하지 않아요
**A:** 다음을 확인하세요:
```bash
# 툴 설치 확인
iverilog --version
vvp --version

# 파일 경로 확인
ls rtl/
ls tb/

# 문법 오류 확인
iverilog -t null rtl/alu.v
```

### Q2: Waveform을 어떻게 해석하나요?
**A:** GTKWave에서:
1. 신호 선택 (왼쪽 패널)
2. 시간 축 확대/축소 (Zoom In/Out)
3. 커서로 값 확인
4. 중요 신호: clk, pc, instruction, alu_result

### Q3: 합성 결과를 어떻게 평가하나요?
**A:** 주요 지표:
- **게이트 수**: 적을수록 효율적
- **플립플롭 수**: 상태 저장 요소
- **Critical Path**: 최대 클럭 주파수 결정
- **리소스 사용률**: FPGA 타겟의 경우

### Q4: 새 명령어를 추가하려면?
**A:** 4단계 프로세스:
1. ALU에 연산 추가
2. Opcode 할당
3. CPU 디코더 수정
4. 테스트 추가

자세한 내용: `docs/tutorial_add_instruction.md`

### Q5: FPGA에 어떻게 올리나요?
**A:** 기본 CPU 완성 후:
1. FPGA 보드 선택 (예: Basys3, DE0-Nano)
2. 벤더 툴 설치 (Vivado, Quartus)
3. 제약 파일 작성 (.xdc, .sdc)
4. 합성 → 구현 → 비트스트림 생성
5. 보드 프로그래밍

---

## 📈 성능 벤치마크

### 기본 구현 (예상)
```
클럭 주파수:     ~150 MHz (ASIC)
               ~100 MHz (FPGA)
CPI:            1.0 (단일 사이클)
게이트 수:       ~180
플립플롭:        ~40
전력 소비:       ~5-10 mW
```

### 최적화 후 (파이프라인)
```
클럭 주파수:     ~400 MHz (ASIC)
               ~200 MHz (FPGA)
CPI:            ~1.2 (hazard 포함)
처리량:         3-4배 향상
면적:           1.5-2배 증가
```

---

## 🎓 추천 학습 경로

### 이 프로젝트 후 다음 단계

1. **RISC-V 구현**
   - 표준 ISA 학습
   - 더 복잡한 명령어 세트
   - 생태계 활용

2. **파이프라인 CPU**
   - 5단 파이프라인
   - Hazard detection
   - Branch prediction

3. **메모리 계층**
   - L1 캐시 구현
   - Cache coherency
   - 가상 메모리

4. **슈퍼스칼라**
   - 다중 발행
   - Out-of-order execution
   - Register renaming

5. **FPGA 프로젝트**
   - 실제 하드웨어 구현
   - 주변장치 연결
   - SoC 설계

---

## 🏆 프로젝트 완성 기준

다음을 모두 완료하면 프로젝트 성공!

### 필수 (기본)
- [ ] 모든 시뮬레이션 통과 (ALU, RegFile, CPU)
- [ ] CPU가 최소 5개 명령어 실행
- [ ] Waveform으로 동작 확인
- [ ] 합성 성공 (경고 무시 가능)
- [ ] README 문서화

### 권장 (추가)
- [ ] 1개 이상 명령어 추가
- [ ] 타이밍 분석 문서 작성
- [ ] 복잡한 테스트 프로그램 작성
- [ ] 성능 최적화 시도

### 도전 (고급)
- [ ] 파이프라인 구현
- [ ] FPGA 보드에 구현
- [ ] 인터럽트 처리
- [ ] OS 부트 가능

---

## 🌟 마무리

축하합니다! 🎉

이 프로젝트를 통해:
- **RTL 설계 능력** 획득
- **CPU 동작 원리** 깊은 이해
- **디지털 회로 검증** 경험
- **합성 프로세스** 학습

### 다음은?

1. GitHub에 업로드
2. 포트폴리오에 추가
3. 더 복잡한 프로젝트 도전
4. 커뮤니티 공유

### 유용한 리소스

- **온라인 시뮬레이터**: EDA Playground
- **FPGA 보드**: Basys3, DE0-Nano
- **강의**: Nand2Tetris, MIT 6.004
- **책**: "Computer Organization and Design"

### 피드백 & 개선

프로젝트를 개선하고 싶다면:
- 코드 리뷰 요청
- 성능 프로파일링
- 다른 ISA 시도
- 오픈소스 기여

---

**Happy Hacking! 🚀**

Remember: "The best way to learn is by building."
