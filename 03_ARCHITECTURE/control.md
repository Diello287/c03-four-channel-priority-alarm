# C03 - Control Logic

## 1. Purpose

The control logic determines whether the current channel should replace the previously selected winner.

## 2. Comparison Rule

For each channel, the core evaluates:

`current_level > winner_level`

If true, the following signals are updated:

- `winner_valid = 1`
- `winner_ch = current channel index`
- `winner_level = current_level`

If false, the current winner is retained.

## 3. Priority and Tie-Breaking

The loop visits channels in this order:

`CH0 -> CH1 -> CH2 -> CH3`

Because the comparison is strictly greater-than rather than greater-than-or-equal, a later channel with an equal alarm level does not replace an earlier channel.

Therefore, the lowest-index channel among those with the highest non-zero level wins.

## 4. No Active Alarm

When every channel is `00`, no comparison succeeds. The initialized outputs remain:

- `winner_valid = 0`
- `winner_ch = 00`
- `winner_level = 00`

## 5. Control Implementation

The control behavior is implemented by the combinational `always @(*)` block in `src/c03_core.v`. There is no finite-state machine in this implementation.
