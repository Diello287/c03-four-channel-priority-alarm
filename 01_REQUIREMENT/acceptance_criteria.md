# Acceptance Criteria

## Functional Acceptance
- The design accepts four 2-bit alarm inputs.
- The highest alarm level is selected.
- Ties are resolved by selecting the lowest channel index.
- When all channels are zero, the valid indicator is zero.

## Interface Acceptance
- `uo_out[4]`: valid alarm indicator.
- `uo_out[3:2]`: selected alarm level.
- `uo_out[1:0]`: selected channel index.
- `uo_out[7:5]`: driven low.

## Verification Acceptance
- Core and wrapper testbenches check all 256 input combinations.
- Recorded RTL tests passed.
- The recorded Yosys structural check reported zero problems.
- CVC/ERC did not complete successfully, so complete physical signoff is not claimed.
