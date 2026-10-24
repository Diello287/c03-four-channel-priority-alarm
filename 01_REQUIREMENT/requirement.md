# C03 - Four-Channel Priority Alarm Selector

## 1. Objective

Design a combinational circuit that monitors four alarm channels and selects the channel with the highest alarm level.

## 2. Functional Requirements

- The circuit shall accept four alarm channels.
- Each channel shall use 2 bits to represent its alarm level.
- The circuit shall select the highest alarm level among the four channels.
- If multiple channels have the same highest alarm level, the channel with the smallest index shall be selected.
- If all channels have no alarm, the valid alarm indicator shall be zero.
- The circuit shall provide the selected channel index, selected alarm level, and valid alarm indicator.

## 3. Alarm Level Encoding

| Alarm Level | Encoding |
|---|---|
| No alarm | `00` |
| Low | `01` |
| Medium | `10` |
| High | `11` |

## 4. Design Constraints

- The alarm selection logic shall be combinational.
- No clocked registers or memory shall be required for alarm selection.
- Unused output bits shall be driven to zero.
- Bidirectional GPIO outputs and output-enable signals shall be tied to zero.

## 5. Verification Requirements

- Verify the core logic against all 256 possible 8-bit input combinations.
- Verify the top-level wrapper against all 256 input combinations.
- Check the selected channel, alarm level, valid indicator, and GPIO-related outputs.
