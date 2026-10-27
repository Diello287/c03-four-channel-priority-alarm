#!/usr/bin/env python3
"""Lightweight structural netlist checks; not a replacement for CVC ERC."""

import re
import sys
from pathlib import Path
from datetime import datetime

TOP = "tt_um_c03_priority_alarm"

if len(sys.argv) != 2:
    print("Usage: python3 ERC/erc_check.py PATH_TO_NETLIST")
    sys.exit(2)

netlist = Path(sys.argv[1]).expanduser()

report_dir = Path("ERC/reports")
report_dir.mkdir(parents=True, exist_ok=True)
report = report_dir / (
    "custom_erc_" + datetime.now().strftime("%Y%m%d_%H%M%S") + ".txt"
)

lines = [
    "CUSTOM ERC — STRUCTURAL NETLIST CHECK",
    f"Date: {datetime.now().astimezone().isoformat(timespec='seconds')}",
    f"Top module expected: {TOP}",
    f"Input netlist: {netlist}",
    "",
]

checks = []
if not netlist.is_file():
    lines += ["RESULT: BLOCKED", "Reason: input netlist does not exist."]
    report.write_text("\n".join(lines) + "\n")
    print("\n".join(lines))
    print(f"\nReport saved: {report}")
    sys.exit(2)

text = netlist.read_text(errors="replace")
# Remove comments before simple structural checks.
clean = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
clean = re.sub(r"//.*", "", clean)

module_names = re.findall(
    r"\bmodule\s+(?:automatic\s+|static\s+)?([A-Za-z_$][\w$]*)",
    clean,
)
endmodule_count = len(re.findall(r"\bendmodule\b", clean))

checks.append((
    "Expected top module exists",
    TOP in module_names,
))
checks.append((
    "Module/endmodule counts match",
    len(module_names) == endmodule_count,
))
checks.append((
    "Netlist is non-empty",
    bool(clean.strip()),
))

# These are warnings only: empty named ports may be intentional.
empty_ports = re.findall(r"\.\s*[A-Za-z_$][\w$]*\s*\(\s*\)", clean)

for name, passed in checks:
    lines.append(f"[{'PASS' if passed else 'FAIL'}] {name}")

lines += [
    "",
    f"Modules found: {len(module_names)}",
    f"endmodule statements: {endmodule_count}",
    f"Empty named-port connections (review manually): {len(empty_ports)}",
    "",
]

if empty_ports:
    lines.append("WARNING: empty named-port connections need manual review.")
    for item in empty_ports[:20]:
        lines.append(f"  {item}")

passed_all = all(ok for _, ok in checks)
lines += [
    "",
    f"STRUCTURAL CHECK RESULT: {'PASS' if passed_all else 'FAIL'}",
    "",
    "Scope limitation:",
    "- This is a lightweight structural sanity check only.",
    "- It does not verify electrical connectivity, power integrity,",
    "  device models, or all ERC rules.",
    "- It does not replace OpenLane/CVC ERC.",
]

report.write_text("\n".join(lines) + "\n")
print("\n".join(lines))
print(f"\nReport saved: {report}")
sys.exit(0 if passed_all else 1)
