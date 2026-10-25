# C03 - System Diagram

## 1. Top-Level Connectivity

The system consists of the Tiny Tapeout wrapper `tt_um_c03_priority_alarm` and the core instance `core_inst`.

```text
tt_um_c03_priority_alarm
|
|-- ui_in[7:0] --------------------+
|                                  |
|                                  v
|                         c03_core.alert_level
|                                  |
|                         c03_core selection logic
|                                  |
|             +--------------------+------------------+
|             |                    |                  |
|        winner_ch[1:0]     winner_level[1:0]   winner_valid
|             |                    |                  |
|             +--------------------+------------------+
|                                  |
|                                  v
|                         uo_out[7:0] encoding
|
|-- clk     : unused by current wrapper logic
|-- rst_n   : unused by current wrapper logic
|-- ena     : unused by current wrapper logic
|-- uio_in  : unused by current wrapper logic
|-- uio_out : constant 0
|-- uio_oe  : constant 0
```

## 2. Module Responsibilities

### `c03_core`

Evaluates the four alarm levels and generates the winning channel, winning level, and valid indicator.

### `tt_um_c03_priority_alarm`

Provides the top-level interface, instantiates the core, encodes the output bus, and disables bidirectional GPIO outputs.

## 3. Signal Ownership

The core drives the three winner signals. The wrapper uses those signals to construct `uo_out`.

The `clk`, `rst_n`, `ena`, and `uio_in` ports are present in the interface but are not used by the current RTL logic.
