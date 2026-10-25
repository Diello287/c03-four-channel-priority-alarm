# Timing Specification

## 1. Timing Model
The alarm selector is a combinational circuit. It does not use a clock to sample or store alarm inputs.

## 2. Input-to-Output Behavior
When an alarm input changes, the selection logic evaluates the four channel values and updates the output according to the priority rules.

## 3. Propagation Delay
The physical output does not change instantaneously. Its response time depends on the propagation delay of the implemented logic and the physical design.

## 4. Clock and Reset
- No clock edge is required for the alarm-selection function.
- No sequential reset behavior is required by the selection algorithm.
- The top-level interface may still include `clk` and `rst_n` to comply with the Tiny Tapeout wrapper interface.

## 5. Verification
Functional simulation checks the output behavior for all 256 possible input combinations. This verifies logical behavior, but does not by itself establish a physical maximum-delay guarantee.

## 6. Timing Signoff Limitation
No specific maximum propagation-delay value is claimed in this document. A verified timing report would be required to establish a numerical timing limit.
