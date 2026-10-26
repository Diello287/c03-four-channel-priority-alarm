# OpenLane Metrics Evidence

## Purpose

This file records the physical-design metrics that must be extracted from the actual OpenLane run directory before they are reported as measured results. Values are intentionally marked **NOT YET VERIFIED** when the corresponding raw report is not committed in this repository.

## Currently verified from committed reports

| Check | Recorded result | Evidence |
|---|---|---|
| Magic DRC | 0 violations | [drc.rpt](drc.rpt) |
| LVS | 0 mismatches / total errors 0 | [lvs.rpt](lvs.rpt) |
| Antenna | 0 pin violations; 0 net violations | [manufacturability.rpt](manufacturability.rpt) |
| CVC/ERC | Did not complete due to resistance-model parameter error | [implementation notes](../04_IMPLEMENTATION/implementation.md) |

These are results recorded in the repository. The underlying full run directory is not included here, so this summary does not independently establish that the flow can be reproduced today.

## Metrics still to extract

| Metric | Value | Required evidence |
|---|---|---|
| OpenLane version and PDK/platform revision | NOT YET VERIFIED | run log / configuration |
| Run directory and run identifier | `c03_check2` is referenced by the existing summary; full provenance NOT YET VERIFIED | run metadata |
| Standard-cell area | NOT YET VERIFIED | synthesis or final STA/metrics report |
| Core area and die area | NOT YET VERIFIED | floorplan/DEF or metrics report |
| Critical path delay / setup slack | NOT YET VERIFIED | STA timing report and SDC/clock assumptions |
| Signal-metal area, if reported | NOT YET VERIFIED | metrics report |
| Final GDS generation status | GDSII file is present in `06_GDSII/`; reproducible generation NOT YET VERIFIED | final flow log |
| Complete signoff status | INCOMPLETE: CVC/ERC did not complete | CVC/ERC log |

Do not replace these placeholders with estimates. Record units, the exact source filename, and the OpenLane run identifier with every numeric value.

## How to collect evidence

From the machine/environment that contains the OpenLane run:

```bash
# Set this to the actual run directory on your machine.
RUN_DIR=/openlane/designs/c03_priority_alarm/runs/c03_check2

# Locate metric summaries, timing reports, and physical reports.
find "$RUN_DIR" -type f \( \
  -iname '*metric*' -o -iname '*sta*' -o -iname '*tim*' -o \
  -iname '*area*' -o -iname '*summary*' -o -iname '*signoff*' \
\) -print

# Search text logs/reports for common timing and area terms.
grep -RniE 'critical path|setup slack|wns|tns|cell area|core area|die area|delay|violat|error' \
  "$RUN_DIR/reports" "$RUN_DIR/logs" 2>/dev/null | head -n 250

# Record tool versions available in the same environment.
openlane --version 2>&1 || true
magic --version 2>&1 | head -n 5 || true
yosys -V 2>&1 || true
```

Paths and metric names differ between OpenLane versions and configurations. If this run directory no longer exists, rerun the documented flow using the original configuration and preserve the complete logs before filling in the table.
