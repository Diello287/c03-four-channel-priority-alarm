# Functional Specification

## 1. Overview
The Four-Channel Priority Alarm Selector is a combinational digital circuit that monitors four alarm channels and reports the highest active alarm level.

## 2. Input Channels
The 8-bit input bus `ui_in[7:0]` contains four 2-bit alarm values:
- Channel 0: `ui_in[1:0]`
- Channel 1: `ui_in[3:2]`
- Channel 2: `ui_in[5:4]`
- Channel 3: `ui_in[7:6]`

## 3. Alarm Encoding
| Value | Meaning |
|---|---|
| `00` | No alarm |
| `01` | Low |
| `10` | Medium |
| `11` | High |

## 4. Priority Rules
1. The highest alarm level takes priority.
2. If multiple channels have the same highest level, the channel with the smallest index is selected.
3. If all channels contain `00`, no alarm is valid.

## 5. Output Behavior
- `uo_out[1:0]`: Selected channel index.
- `uo_out[3:2]`: Selected alarm level.
- `uo_out[4]`: Valid alarm indicator.
- `uo_out[7:5]`: Always driven low.

## 6. Circuit Behavior
The circuit operates combinationally and does not require a clock, reset, or sequential storage.
