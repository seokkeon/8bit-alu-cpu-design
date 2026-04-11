# Getting Started Checklist

## ✅ Pre-Flight Checklist

### 1. Install Required Tools
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y iverilog gtkwave yosys graphviz

# macOS
brew install icarus-verilog gtkwave yosys graphviz

# Verify installation
iverilog --version
gtkwave --version
yosys --version
```

### 2. Navigate to Project
```bash
cd cpu_project
ls -la
```

You should see:
- `rtl/` - Verilog source files
- `tb/` - Testbenches
- `docs/` - Documentation
- `Makefile` - Build system

---

## 🎯 Your First Simulation (5 minutes)

### Step 1: Test the ALU
```bash
make sim-alu
```

**Expected output:**
```
Starting ALU testbench...
Time    OP      A       B       Result  Expected
----    --      --      --      ------  --------
10      ADD     15      10      25      25 PASS
20      ADD     255     1       0       0 PASS (overflow)
...
ALU testbench complete!
```

### Step 2: View Waveforms
```bash
make view-alu
```

This opens GTKWave. Look for:
- `a` and `b` inputs changing
- `alu_op` selecting different operations
- `result` showing correct outputs

### Step 3: Test Register File
```bash
make sim-regfile
```

### Step 4: Test Complete CPU
```bash
make sim-cpu
```

**What to look for:**
- Program Counter incrementing each cycle
- Instructions being fetched
- Register values updating

---

## 📚 Day 1 Learning Goals

By the end of today, you should understand:

1. **ALU Design**
   - How operations are selected with `alu_op`
   - Combinational logic (no clock needed)
   - Testing methodology with testbenches

2. **Register File**
   - Synchronous write (on clock edge)
   - Asynchronous read (immediate)
   - Multi-port architecture (2 read, 1 write)

3. **CPU Integration**
   - Instruction fetch → decode → execute → writeback
   - Single-cycle execution model
   - Data path connections

---

## 📖 Study Materials

### Read These First (30 minutes)
1. `docs/ISA_spec.md` - Understand the instruction format
2. `docs/architecture.md` - See how modules connect
3. `rtl/alu.v` - Study the ALU implementation

### Try These Exercises

#### Exercise 1: Modify ALU
Add an XOR operation:
1. Edit `rtl/alu.v`
2. Add a new case for XOR
3. Update the testbench
4. Simulate: `make sim-alu`

#### Exercise 2: Change Test Program
Edit the program in `rtl/cpu.v`:
1. Find the `initial begin` block in `cpu.v`
2. Modify instructions in `imem[]`
3. Simulate: `make sim-cpu`
4. Verify register values

#### Exercise 3: Add Debug Prints
In `tb/cpu_tb.v`, add:
```verilog
$monitor("R0=%d R1=%d R2=%d R3=%d", 
         uut.rf.registers[0],
         uut.rf.registers[1],
         uut.rf.registers[2],
         uut.rf.registers[3]);
```

---

## 🔧 Common Issues & Solutions

### Issue: "iverilog: command not found"
**Solution:** Install Icarus Verilog
```bash
sudo apt install iverilog
```

### Issue: Simulation produces no output
**Solution:** Check that you're in the project directory
```bash
pwd  # Should show .../cpu_project
```

### Issue: Can't open waveform viewer
**Solution:** Install GTKWave
```bash
sudo apt install gtkwave
```

### Issue: Make command fails
**Solution:** Ensure files exist
```bash
ls rtl/     # Should show alu.v, regfile.v, cpu.v
ls tb/      # Should show testbenches
```

---

## 🎓 Week 1 Roadmap

### Day 1-2: Component Understanding
- [x] Install tools
- [x] Run ALU simulation
- [x] Run register file simulation
- [ ] Understand how each module works
- [ ] Read all source code

### Day 3-4: CPU Integration
- [ ] Run full CPU simulation
- [ ] Trace instruction execution
- [ ] Modify test program
- [ ] Add new instructions

### Day 5-7: Experimentation
- [ ] Add XOR operation
- [ ] Implement shift operations
- [ ] Add status flags (zero, carry)
- [ ] Design your own test programs

---

## 📊 Success Criteria

You've successfully completed Week 1 if you can:
- ✅ Run all simulations without errors
- ✅ Explain what each module does
- ✅ Write a simple assembly program
- ✅ Add a new ALU operation
- ✅ Read and understand waveforms

---

## 🚀 Next Steps (Week 2+)

1. **Synthesis**
   - Run `make synth`
   - Analyze resource usage
   - Understand gate-level netlist

2. **Advanced Features**
   - Immediate addressing
   - Branch instructions
   - Memory interface
   - Multi-cycle execution

3. **FPGA Implementation**
   - Target specific FPGA board
   - Add I/O peripherals
   - Real-world testing

---

## 💡 Pro Tips

1. **Always simulate before synthesizing**
   - Catch bugs early in simulation
   - Synthesis is much harder to debug

2. **Use version control**
   ```bash
   git init
   git add .
   git commit -m "Initial CPU design"
   ```

3. **Keep a lab notebook**
   - Document changes you make
   - Record synthesis results
   - Track bugs and solutions

4. **Read the waveforms**
   - Don't just trust print statements
   - Visual debugging is powerful
   - Look for signal transitions

---

## 📞 Getting Help

If stuck:
1. Check `README.md` for overview
2. Read module comments in `.v` files
3. Search for Verilog syntax online
4. Review testbench outputs carefully

**Remember:** CPU design is complex! Take it step by step. 🎯
