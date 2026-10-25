# C03 - Design Trade-Offs

## 1. Combinational Selection

The design uses combinational logic instead of a clocked selection pipeline.

Advantages:
- No sequential state is needed.
- The output follows the current alarm inputs after propagation through the logic.
- The design is straightforward to simulate exhaustively.

Considerations:
- Physical propagation delay still exists.
- The output may transition while inputs change.
- No numerical maximum-delay claim is made without timing analysis.

## 2. Ascending Channel Scan

The core scans channels from index 0 through index 3 and replaces the winner only when a strictly higher level is found.

Advantages:
- The tie-breaking rule is simple and deterministic.
- The behavior is easy to inspect in RTL and verify with testbenches.

Considerations:
- The source code describes an ordered comparison loop; the final synthesized hardware structure depends on the synthesis tool.
- This implementation should not be assumed to have a particular gate count or delay without examining synthesis and timing reports.

## 3. Output Encoding

The output bus combines the valid flag, alarm level, and channel index into one byte.

Advantages:
- The result is compact.
- Reserved output bits have a defined zero value.
- The wrapper interface remains compatible with the expected Tiny Tapeout-style ports.

## 4. Scope and Safety

C03 is an educational priority-selector design. It is not claimed to be certified for safety-critical alarm applications.

Physical verification results must be reported according to the actual tool logs. In particular, incomplete CVC/ERC analysis must not be described as complete physical signoff.
