# Four-Channel Priority Alarm Selector

## 1. Project Overview

This project implements a four-channel priority alarm selector for the Introduction to Integrated Circuit Design course.

The circuit is combinational and selects the highest alarm level among four input channels. If multiple channels have the same highest level, the channel with the smallest index is selected.

## 2. Alarm Encoding

Each channel uses two bits to represent its alarm level.

| Alarm Level | Encoding |
|---|---|
| No alarm | `00` |
| Low | `01` |
| Medium | `10` |
| High | `11` |

## 3. Input and Output Interface

### Inputs

The 8-bit input `ui_in` contains four 2-bit alarm channels:

| Channel | Input Bits |
|---|---|
| Channel 0 | `ui_in[1:0]` |
| Channel 1 | `ui_in[3:2]` |
| Channel 2 | `ui_in[5:4]` |
| Channel 3 | `ui_in[7:6]` |

### Outputs

The 8-bit output `uo_out` is encoded as follows:

| Output Bits | Description |
|---|---|
| `uo_out[1:0]` | Selected channel index |
| `uo_out[3:2]` | Highest alarm level |
| `uo_out[4]` | Valid alarm indicator |
| `uo_out[7:5]` | Reserved; always zero |

When all four channels have no alarm, the valid indicator, selected channel, and selected level are all zero.

The bidirectional GPIO output and output-enable signals are tied to zero.

## 4. Priority Rules

1. Select the channel with the highest alarm level.
2. If multiple channels share the highest level, select the channel with the smallest index.
3. If all channels have level `00`, indicate that no alarm is active.

The design does not use a clock, reset, registers, or memory for its selection logic.

## 5. Repository Structure

```text
.
├── SPEC.md
├── README.md
├── src/
│   ├── c03_core.v
│   └── tt_um_c03_priority_alarm.v
└── test/
    ├── tb_c03_core.v
    └── tb_tt_um_c03_priority_alarm.v
```

## 6. RTL Verification

The project uses Icarus Verilog for RTL simulation.

### Core testbench

```bash
iverilog -g2012 -Wall -s tb_c03_core \
  -o /tmp/tb_c03_core.vvp \
  src/c03_core.v test/tb_c03_core.v

vvp /tmp/tb_c03_core.vvp
```

### Top-level wrapper testbench

```bash
iverilog -g2012 -Wall -s tb_tt_um_c03_priority_alarm \
  -o /tmp/tb_c03_wrapper.vvp \
  src/c03_core.v src/tt_um_c03_priority_alarm.v \
  test/tb_tt_um_c03_priority_alarm.v

vvp /tmp/tb_c03_wrapper.vvp
```

### Current verification results

- Core testbench: PASS for all 256 input combinations.
- Top-level wrapper testbench: PASS for all 256 input combinations.
- GPIO output and output-enable checks: PASS.
- Yosys hierarchy and structural check: completed with zero reported problems.

These results describe RTL simulation and structural checks. They do not establish physical-design signoff or manufacturing readiness.

## 7. Physical Design Status

RTL-to-GDSII implementation and physical-design verification are separate stages of the project. Results such as synthesis, timing analysis, design-rule checking (DRC), and layout-versus-schematic (LVS) must be recorded after those stages have actually been run.

No claim of completed physical-design signoff or tape-out is made here.

## 8. Project Scope

The project focuses on combinational priority selection for four alarm channels. Programmable priorities, alarm history, latching, hysteresis, and clocked logic are outside the current scope.
