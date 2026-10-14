# C03 – Four-Channel Priority Alarm Selector

## 1. Project Information

- **Course:** EEE703128 – Introduction to Integrated Circuit Design
- **Project:** C03 – Four-Channel Priority Alarm Selector
- **Circuit Type:** Combinational Logic
- **Instructor:** Đinh Văn Nam
- **Group:** C – Threshold, Alarm, and Monitoring

## 2. Objective

The objective of this project is to design and verify a combinational logic circuit that monitors four alarm channels and selects the channel with the highest alarm level.

If multiple channels have the same highest alarm level, the channel with the smallest index must be selected.

The design will be implemented in Verilog RTL, verified using a testbench, and evaluated through an RTL-to-GDSII design flow.

## 3. Functional Description

The circuit receives four 2-bit alarm levels:

- Channel 0: `ui_in[1:0]`
- Channel 1: `ui_in[3:2]`
- Channel 2: `ui_in[5:4]`
- Channel 3: `ui_in[7:6]`

Each channel supports four alarm levels:

| Binary Value | Alarm Level |
|---|---|
| `2'b00` | No alarm |
| `2'b01` | Low |
| `2'b10` | Medium |
| `2'b11` | High |

The circuit compares the four channel levels and selects the channel with the highest level.

### Priority Rules

1. A higher alarm level has a higher priority.
2. If multiple channels share the highest alarm level, the channel with the smallest index wins.
3. If all channels have an alarm level of zero, the circuit indicates that no alarm is active.

## 4. Input and Output Interface

### Inputs

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `ui_in` | Input | 8 bits | Four 2-bit alarm levels |

`ui_in[7:0]` is the only functional input bus. The design does not require a clock or reset.

### Outputs

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `uo_out[1:0]` | Output | 2 bits | Index of the selected channel |
| `uo_out[3:2]` | Output | 2 bits | Highest alarm level |
| `uo_out[4]` | Output | 1 bit | Alarm-valid flag |
| `uo_out[7:5]` | Output | 3 bits | Unused outputs, driven to zero |

The output bus is 8 bits wide, consistent with the Tiny Tapeout interface.

### Output Encoding

| Condition | `uo_out[4]` | `uo_out[3:2]` | `uo_out[1:0]` |
|---|---:|---|---|
| All channels are zero | 0 | `00` | `00` |
| At least one channel is nonzero | 1 | Highest level | Selected channel index |

When no alarm is active, the selected channel index and alarm level are both set to zero.

## 5. Tie-Breaking Behavior

The channel with the smallest index must be selected when alarm levels are equal.

Example:

| Channel | Alarm Level |
|---|---:|
| Channel 0 | 1 |
| Channel 1 | 3 |
| Channel 2 | 3 |
| Channel 3 | 2 |

Expected output:

- Alarm valid: `1`
- Selected channel: `1`
- Highest alarm level: `3`

Channel 1 wins because it has the highest alarm level and a smaller index than Channel 2.

## 6. Design Constraints

- The circuit must be purely combinational.
- No clock, reset, register, or memory element is required.
- All outputs must be determined by the current input values.
- The implementation must follow the specified priority and tie-breaking rules.
- The RTL must be synthesizable.
- Unused output bits must be driven to zero.

## 7. Verification Plan

The testbench must cover at least the following cases:

1. All channels have alarm level zero.
2. Only one channel has a nonzero alarm level.
3. Two channels have the same highest alarm level.
4. All four channels have different alarm levels.
5. A tie occurs between non-adjacent channels.
6. The highest alarm level changes between input combinations.

Additional boundary and randomized tests may be used to improve coverage.

For each test case, the observed outputs must be compared against the expected outputs derived from the functional specification.

## 8. Implementation and Evaluation

The design will be implemented in Verilog RTL and verified using simulation.

The project will then be processed using the available RTL-to-GDSII flow, such as LibreLane and the configured process design kit (PDK).

The following results will be reviewed where available:

- RTL simulation and waveform
- Logic synthesis and cell statistics
- Static timing analysis (STA)
- Power estimation
- Design rule checking (DRC)
- Layout versus schematic (LVS)
- Physical layout and generated GDS data

A generated GDS file alone does not prove functional correctness, timing closure, DRC/LVS cleanliness, or manufacturing readiness.

## 9. Acceptance Criteria

The design is considered functionally verified when:

1. All mandatory test cases pass.
2. The highest alarm level is selected correctly.
3. The smallest channel index wins every tie.
4. The alarm-valid flag is correct.
5. Outputs follow the defined encoding when no alarm is active.
6. Unused output bits remain zero.
7. Simulation results and verification evidence are documented.

Physical implementation results and any flow failures must be reported accurately, with supporting logs and reports.

## 10. Project Limitations

This project does not include programmable priorities, alarm history, alarm latching, hysteresis, clocked logic, chip fabrication, or tape-out.

All conclusions must be limited to the behavior and implementation results demonstrated by the available verification and design-flow evidence.
