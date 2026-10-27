# ERC Verification

## Custom Structural Netlist Check

A lightweight Python script checks basic structural properties of the
generated gate-level netlist.

### Checks performed
- Expected top module exists.
- Number of module declarations matches the number of `endmodule` statements.
- Netlist is non-empty.
- Empty named-port connections are reported for manual review.

### Latest result
- Status: PASS
- Report: `ERC/reports/custom_erc_20261027_225632.txt`
- Script: `erc_check.py`

### Scope and limitations
This custom check is a structural sanity check only. It does not verify
electrical connectivity, power integrity, device models, or all ERC rules.
It does not replace OpenLane/CVC ERC.

The OpenLane/CVC ERC result remains unresolved because the existing log
reports a resistor-model error: `missing parameter: l in l/w*48`.

### Run
From the project root:

```bash
python3 ERC/erc_check.py /path/to/tt_um_c03_priority_alarm.nl.v
>
```
