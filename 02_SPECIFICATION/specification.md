# C03 - Technical Specification

## 1. Input Interface

The circuit uses the 8-bit input bus `ui_in` to represent four alarm channels.

| Channel | Input Bits | Width |
|---|---|---|
| Channel 0 | `ui_in[1:0]` | 2 bits |
| Channel 1 | `ui_in[3:2]` | 2 bits |
| Channel 2 | `ui_in[5:4]` | 2 bits |
| Channel 3 | `ui_in[7:6]` | 2 bits |

## 2. Alarm Encoding

| Binary Code | Alarm Level |
|---|---|
| `2'b00` | No alarm |
| `2'b01` | Low |
| `2'b10` | Medium |
| `2'b11` | High |

The numerical value of each 2-bit code represents its alarm priority.

## 3. Output Interface

The 8-bit output bus `uo_out` is defined as follows.

| Output Bits | Width | Description |
|---|---|---|
| `uo_out[1:0]` | 2 bits | Selected channel index |
| `uo_out[3:2]` | 2 bits | Highest alarm level |
| `uo_out[4]` | 1 bit | Valid alarm indicator |
| `uo_out[7:5]` | 3 bits | Reserved; always zero |

The selected channel index is encoded as follows:

| Channel | Index |
|---|---|
| Channel 0 | `2'b00` |
| Channel 1 | `2'b01` |
| Channel 2 | `2'b10` |
| Channel 3 | `2'b11` |

## 4. Selection Rules

1. Select the channel with the highest alarm level.
2. If multiple channels share the highest non-zero level, select the channel with the smallest index.
3. If all channels are `2'b00`, set the valid indicator to zero, the selected channel index to `2'b00`, and the selected alarm level to `2'b00`.
4. Set `uo_out[7:5]` to zero for every input combination.

## 5. Other Interface Signals

- The design is combinational and does not require a clock or reset for alarm selection.
- The top-level wrapper's bidirectional GPIO output and output-enable signals are tied to zero.

## 6. Exhaustive Verification

There are four channels, each with four possible alarm codes. Therefore, the total number of input combinations is:

`4^4 = 256`

The core and top-level wrapper testbenches are expected to check all 256 input combinations.
