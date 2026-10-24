
# C03 - Four-Channel Priority Alarm Selector

## 1. Project Overview

This project implements a four-channel priority alarm selector for the Introduction to Integrated Circuit Design course.

The circuit is combinational and selects the highest alarm level among four input channels. If multiple channels have the same highest non-zero level, the channel with the smallest index is selected.

## 2. Alarm Encoding

| Alarm Level | Encoding |
|---|---|
| No alarm | `00` |
| Low | `01` |
| Medium | `10` |
| High | `11` |

## 3. Input and Output Interface

### Inputs

| Channel | Input Bits |
|---|---|
| Channel 0 | `ui_in[1:0]` |
| Channel 1 | `ui_in[3:2]` |
| Channel 2 | `ui_in[5:4]` |
| Channel 3 | `ui_in[7:6]` |

### Outputs

| Output Bits | Description |
|---|---|
| `uo_out[1:0]` | Selected channel index |
| `uo_out[3:2]` | Highest alarm level |
| `uo_out[4]` | Valid alarm indicator |
| `uo_out[7:5]` | Reserved; always zero |

When all channels report `00`, the valid indicator, selected channel, and selected level are zero. Bidirectional GPIO outputs and output-enable signals are tied to zero.

## 4. Priority Rules

1. Select the channel with the highest alarm level.
2. Resolve ties by selecting the channel with the smallest index.
3. If all channels report `00`, indicate that no alarm is active.

The selection logic does not require a clock, reset, registers, or memory.

## 5. Repository Structure

```text
.
├── 01_REQUIREMENT/
│   └── requirement.md
├── 02_SPECIFICATION/
│   └── specification.md
├── 03_ARCHITECTURE/
│   └── architecture.md
├── 04_IMPLEMENTATION/
│   └── implementation.md
├── 05_VERIFICATION/
│   ├── drc.log
│   ├── drc.rpt
│   ├── lvs.log
│   ├── lvs.rpt
│   └── manufacturability.rpt
├── 06_GDSII/
│   ├── c03_layout_klayout.png
│   └── tt_um_c03_priority_alarm.gds
├── 08_ORIGINAL_SOURCE/
│   ├── README.md
│   ├── SPEC.md
│   ├── c03_core.v
│   ├── tt_um_c03_priority_alarm.v
│   ├── tb_c03_core.v
│   └── tb_tt_um_c03_priority_alarm.v
├── src/
│   ├── c03_core.v
│   └── tt_um_c03_priority_alarm.v
├── test/
│   ├── tb_c03_core.v
│   └── tb_tt_um_c03_priority_alarm.v
├── README.md
└── SPEC.md
```

## 6. RTL Verification

RTL simulation uses Icarus Verilog.

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

### Recorded results

- Core testbench: PASS for all 256 input combinations.
- Top-level wrapper testbench: PASS for all 256 input combinations.
- GPIO output and output-enable checks: PASS.
- Yosys structural check: zero reported problems.

## 7. Physical Design and Verification

The design was implemented using OpenLane with the SkyWater SKY130A platform.

Recorded results:

- Magic DRC: zero reported violations.
- LVS: clean; the compared circuits matched.
- Antenna summary: zero pin violations and zero net violations.
- GDSII layout and KLayout screenshot are included in `06_GDSII/`.

**Limitation:** CVC/ERC did not complete successfully because of a resistance-model parameter error in the verification flow. Therefore, complete physical signoff and manufacturing readiness are not claimed.

## 8. Project Scope

The project focuses on combinational priority selection for four alarm channels. Programmable priorities, alarm history, latching, hysteresis, and clocked logic are outside the current scope.
