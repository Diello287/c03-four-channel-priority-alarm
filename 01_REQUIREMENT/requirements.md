# Project Requirements

## Functional Requirements
1. The design shall accept four 2-bit alarm inputs.
2. Alarm encoding shall be `00` = none, `01` = low, `10` = medium, `11` = high.
3. The design shall select the highest alarm level.
4. If multiple channels share the highest level, the channel with the smallest index shall be selected.
5. If all channels are zero, the valid indicator shall be zero.
6. Reserved output bits `uo_out[7:5]` shall be driven low.

## Design Requirements
- Alarm selection shall be combinational.
- The selection function shall not require registers or memory.
- The top-level module shall follow the documented Tiny Tapeout interface.

## Verification Requirements
- Test all 256 combinations of the 8-bit input bus.
- Verify the core selection logic.
- Verify top-level output encoding and GPIO-related outputs.
