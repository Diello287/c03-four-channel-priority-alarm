# C03 - Datapath

## 1. Purpose

The datapath extracts and compares four 2-bit alarm levels and produces the winning channel index, alarm level, and valid flag.

## 2. Input Organization

The input bus `alert_level[7:0]` contains four 2-bit fields:

| Channel | Signal slice | Index |
|---|---|---:|
| CH0 | `alert_level[1:0]` | 0 |
| CH1 | `alert_level[3:2]` | 1 |
| CH2 | `alert_level[5:4]` | 2 |
| CH3 | `alert_level[7:6]` | 3 |

At the top level, `alert_level` is connected directly to `ui_in`.

## 3. Selection Algorithm

At the start of each combinational evaluation:

- `winner_valid` is initialized to zero.
- `winner_ch` is initialized to `00`.
- `winner_level` is initialized to `00`.

The core then examines channels in ascending index order from 0 to 3.

For each channel, its 2-bit value is compared with `winner_level`. If the current value is strictly greater, the core updates the winner flag, channel index, and winning level.

Equal values do not replace the current winner.

## 4. Output Encoding

The wrapper assembles the result as:

`uo_out = {3'b000, winner_valid, winner_level, winner_ch}`

This creates an 8-bit output bus with the reserved upper bits set to zero.

## 5. No Sequential Datapath

The RTL uses combinational logic. It does not intentionally store alarm history in registers or memory.
