# C03 - Implementation Notes

## 1. RTL Modules

The project contains two main Verilog modules:

- `src/c03_core.v`: implements the combinational four-channel alarm selection logic.
- `src/tt_um_c03_priority_alarm.v`: provides the top-level Tiny Tapeout interface.

## 2. Testbenches

The project includes two testbenches:

- `test/tb_c03_core.v`: verifies the core selection logic.
- `test/tb_tt_um_c03_priority_alarm.v`: verifies the top-level wrapper and GPIO-related outputs.

## 3. RTL Simulation

RTL simulation is performed with Icarus Verilog.

Both testbenches have passed exhaustive checks covering all 256 possible input combinations.

## 4. Structural Check

Yosys was used to check the RTL hierarchy and design structure. The recorded check reported zero problems.

## 5. Physical Design

The design was processed using OpenLane with the SkyWater SKY130A platform.

The generated GDSII file is stored in `06_GDSII/tt_um_c03_priority_alarm.gds`.

The `05_VERIFICATION/` directory contains the available DRC, LVS, and manufacturability reports and logs.

## 6. Recorded Physical Verification

- Magic DRC: zero reported violations.
- LVS: clean; the compared circuits matched.
- Antenna summary: zero pin violations and zero net violations.

CVC/ERC did not complete successfully because of a resistance-model parameter error in the verification flow. Therefore, this project does not claim complete physical signoff or manufacturing readiness.

## 7. Layout Screenshot

The KLayout screenshot is stored at `06_GDSII/c03_layout_klayout.png`.
