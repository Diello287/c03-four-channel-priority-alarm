
# C03 - Timing Diagram

## 1. Timing Model

C03 is a combinational circuit. Its outputs depend on the current input values. The circuit does not use a clock edge to store or sample alarm inputs.

## 2. Functional Example

The input bus contains four 2-bit alarm levels:

- CH0 = `01`
- CH1 = `10`
- CH2 = `11`
- CH3 = `00`

CH2 has the highest alarm level, so CH2 is selected.

```text
Signal          Settled value
ui_in[7:0]      00_11_10_01
winner_valid    1
winner_level    11
winner_ch       10
```

The output bus is encoded as:

`uo_out = {3'b000, 1'b1, 2'b11, 2'b10}`

This corresponds to `8'b00011110`.

## 3. Timing Limitations

This example describes expected logical behavior after the combinational circuit settles. It is not a measured timing result.

No numerical propagation delay or maximum operating frequency is claimed without an appropriate timing analysis report.
