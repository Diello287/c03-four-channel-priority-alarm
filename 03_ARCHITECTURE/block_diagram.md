# C03 - Block Diagram

## 1. Overview

The design contains a combinational alarm-selection core and a Tiny Tapeout top-level wrapper.

## 2. Block Diagram

```text
              ui_in[7:0]
                   |
                   v
       +------------------------+
       | Four 2-bit alarm       |
       | channels               |
       | CH0 CH1 CH2 CH3        |
       +------------------------+
                   |
                   v
       +------------------------+
       | c03_core               |
       | Highest-level selection|
       | Lowest-index tie-break |
       +------------------------+
                   |
          +--------+--------+
          |        |        |
          v        v        v
      winner_ch winner_level winner_valid
          |        |        |
          +--------+--------+
                   |
                   v
       +------------------------+
       | tt_um_c03_priority_alarm|
       | Output bus encoding    |
       +------------------------+
                   |
                   v
               uo_out[7:0]
```

## 3. Input Channel Mapping

- CH0: `ui_in[1:0]`
- CH1: `ui_in[3:2]`
- CH2: `ui_in[5:4]`
- CH3: `ui_in[7:6]`

## 4. Output Mapping

- `uo_out[1:0]`: selected channel index
- `uo_out[3:2]`: selected alarm level
- `uo_out[4]`: valid indicator
- `uo_out[7:5]`: constant zero

The bidirectional GPIO output bus and output-enable bus are both tied to zero.
