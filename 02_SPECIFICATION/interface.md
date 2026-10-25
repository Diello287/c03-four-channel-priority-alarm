# Interface Specification

## 1. Input Interface

| Signal | Width | Description |
|---|---:|---|
| `clk` | 1 bit | Clock input; unused by the combinational design |
| `rst_n` | 1 bit | Active-low reset input; unused because no sequential state is present |
| `ena` | 1 bit | Tiny Tapeout enable input; unused by the current wrapper logic |
| `ui_in` | 8 bits | Four 2-bit alarm channels |
| `uio_in` | 8 bits | Bidirectional GPIO input bus; unused by the design |

## 2. Alarm Channel Mapping

| Channel | Input Bits |
|---|---|
| Channel 0 | `ui_in[1:0]` |
| Channel 1 | `ui_in[3:2]` |
| Channel 2 | `ui_in[5:4]` |
| Channel 3 | `ui_in[7:6]` |

## 3. Output Interface

| Signal | Width | Description |
|---|---:|---|
| `uo_out[1:0]` | 2 bits | Selected channel index |
| `uo_out[3:2]` | 2 bits | Selected alarm level |
| `uo_out[4]` | 1 bit | Valid alarm indicator |
| `uo_out[7:5]` | 3 bits | Reserved outputs, always `000` |
| `uio_out` | 8 bits | Always driven to `00000000` |
| `uio_oe` | 8 bits | Always driven to `00000000`; bidirectional GPIO outputs are disabled |

## 4. Output Validity
When all four alarm channels are `00`, the valid indicator is `0`, and the selected channel and alarm level are both `00`.

## 5. Output Encoding
The top-level output bus is assembled as:

`uo_out = {3'b000, winner_valid, winner_level, winner_ch}`

This maps the valid flag to bit 4, the alarm level to bits 3:2, and the selected channel index to bits 1:0.
