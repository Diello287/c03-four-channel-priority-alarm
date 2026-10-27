# RTL Waveform — Priority Alarm

## Simulation result
- Simulator: Icarus Verilog
- Testbench: `test/tb_tt_um_c03_priority_alarm.v`
- Result: PASS
- Coverage: all 256 `ui_in` input combinations checked by the wrapper testbench.
- Waveform: `priority_alarm.vcd`

## Important limitation
The current testbench holds `clk` at logic 0. This waveform demonstrates
combinational input/output behavior; it is not evidence of clocked or
sequential timing verification.

## Signals to inspect
- `ui_in`: 8-bit input carrying four 2-bit channel levels.
- `uo_out`: encoded result, including valid, winning level, and channel.
- `clk`, `rst_n`, `ena`: wrapper control signals.
- `uio_in`, `uio_out`, `uio_oe`: GPIO-related signals.

The simulation checks all 256 possible `ui_in` values and verifies that
`uio_out` and `uio_oe` remain zero.
