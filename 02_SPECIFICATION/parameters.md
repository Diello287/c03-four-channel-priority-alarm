# Design Parameters

## 1. Channel Configuration
- Number of alarm channels: 4
- Width of each channel: 2 bits
- Total alarm input width: 8 bits

## 2. Alarm Encoding
| Encoding | Meaning | Priority |
|---|---|---:|
| `00` | No alarm | 0 |
| `01` | Low | 1 |
| `10` | Medium | 2 |
| `11` | High | 3 |

## 3. Channel Index
| Channel | Index Encoding |
|---|---|
| Channel 0 | `00` |
| Channel 1 | `01` |
| Channel 2 | `10` |
| Channel 3 | `11` |

## 4. Output Configuration
- `uo_out[1:0]`: 2-bit selected channel index
- `uo_out[3:2]`: 2-bit selected alarm level
- `uo_out[4]`: 1-bit valid indicator
- `uo_out[7:5]`: 3 reserved bits, driven low

## 5. Implementation Constraints
- The alarm-selection function is combinational.
- No clocked state or memory is required by the selection algorithm.
- The design supports all 256 possible values of the 8-bit input bus.
