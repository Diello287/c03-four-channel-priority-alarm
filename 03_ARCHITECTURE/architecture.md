# C03 - System Architecture

## 1. Overview

The Four-Channel Priority Alarm Selector is a combinational digital circuit. It receives four 2-bit alarm levels and produces the highest alarm level, the selected channel index, and a valid alarm indicator.

## 2. Architecture

The design consists of two main RTL modules:

- `c03_core`: implements the alarm selection logic.
- `tt_um_c03_priority_alarm`: provides the top-level Tiny Tapeout interface and connects the core logic to the input and output buses.

## 3. Data Flow

1. The 8-bit `ui_in` bus is divided into four 2-bit alarm values.
2. The core logic evaluates the alarm levels.
3. The highest non-zero alarm level is selected.
4. If multiple channels have the same highest level, the channel with the smallest index is selected.
5. The selected channel index, alarm level, and valid indicator are encoded into `uo_out`.
6. Reserved output bits are driven to zero. Bidirectional GPIO outputs and output-enable signals are also tied to zero.

## 4. Priority Behavior

The alarm levels are ordered numerically:

`00 < 01 < 10 < 11`

Channel 0 has the highest tie-breaking priority, followed by Channel 1, Channel 2, and Channel 3.

For example, if Channel 1 and Channel 3 both report `2'b11`, Channel 1 is selected because it has the smaller index.

If all four channels report `2'b00`, the valid indicator is zero and both the selected channel index and selected alarm level are zero.

## 5. Clocking

The alarm selection path is purely combinational. It does not require a clock, reset, registers, or memory to perform the selection.

## 6. Architecture Verification

The core and top-level wrapper testbenches exercise all 256 possible combinations of the four 2-bit alarm inputs.
