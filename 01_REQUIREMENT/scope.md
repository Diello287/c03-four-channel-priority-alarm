# Project Scope

## In Scope
- Four alarm channels, each represented by 2 bits.
- Selection of the highest alarm level.
- Tie-breaking by the lowest channel index.
- Combinational Verilog RTL implementation.
- Exhaustive functional simulation of all 256 input combinations.
- RTL structural checks and documented physical-design results.

## Out of Scope
- More than four alarm channels.
- Clocked or sequential alarm processing.
- Alarm storage, history, or logging.
- A user interface, display, or communication protocol.
- Certification for safety-critical applications.

## Physical Verification Limitation
The recorded DRC and LVS checks passed. CVC/ERC did not complete successfully, so full physical signoff is not claimed.
