# Reproducibility Guide

This guide describes how to reproduce the repository's RTL checks and how to collect physical-design evidence. Run commands in a Linux environment with the required tools installed.

## 1. Obtain the source

```bash
git clone https://github.com/Diello287/c03-four-channel-priority-alarm.git
cd c03-four-channel-priority-alarm
```

To inspect the CI work in progress, use its branch:

```bash
git switch ci/rtl-regression
```

## 2. Run the exhaustive RTL simulations

Install Icarus Verilog using the package manager for your Linux distribution. On Ubuntu:

```bash
sudo apt-get update
sudo apt-get install --yes iverilog
```

Run the core testbench:

```bash
iverilog -g2012 -Wall -s tb_c03_core \
  -o /tmp/tb_c03_core.vvp \
  src/c03_core.v test/tb_c03_core.v
vvp /tmp/tb_c03_core.vvp
```

Run the top-level wrapper testbench:

```bash
iverilog -g2012 -Wall -s tb_tt_um_c03_priority_alarm \
  -o /tmp/tb_c03_wrapper.vvp \
  src/c03_core.v src/tt_um_c03_priority_alarm.v \
  test/tb_tt_um_c03_priority_alarm.v
vvp /tmp/tb_c03_wrapper.vvp
```

Each testbench enumerates all 256 values of the 8-bit input bus. The expected successful output includes a `PASS` line. The GitHub Actions workflow in `.github/workflows/rtl-regression.yml` runs these commands on pushes and pull requests.

## 3. Physical design and signoff evidence

The repository contains the final GDSII and summaries of Magic DRC, LVS, and antenna checks. It does **not** currently contain the complete OpenLane run directory or enough raw timing/area reports to establish exact timing and area metrics from the checked-in evidence alone.

Use the original OpenLane environment, PDK revision, and design configuration to reproduce physical design. Preserve the full run directory and record:
- OpenLane and PDK/platform versions;
- exact configuration and run identifier;
- synthesis/final standard-cell area;
- core and die dimensions/area;
- STA critical-path delay and setup slack, including clock/constraint assumptions where applicable;
- DRC, LVS, antenna and CVC/ERC completion status;
- final GDS generation result.

See [OPENLANE_METRICS.md](OPENLANE_METRICS.md) for a collection checklist and shell commands.

## 4. Limitations

The checked-in manufacturability summary reports zero Magic DRC violations, clean LVS, and zero antenna pin/net violations. The implementation notes also report that CVC/ERC did not complete because of a resistance-model parameter error. Therefore, do not describe the current evidence as complete physical signoff or manufacturing readiness.

## 5. Evidence discipline

For every reported number, retain the raw report filename, run directory, tool/PDK version, units, and relevant constraints. If a report is absent, mark the metric as unavailable rather than estimating it.
