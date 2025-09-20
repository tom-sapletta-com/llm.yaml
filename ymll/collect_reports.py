#!/usr/bin/env python3
"""collect_reports.py

Collects the outputs of the analysis tools (pytest, flake8, mypy) and
writes a combined JSON report ``combined_report.json``. The script expects
that the tools have been run previously and their raw outputs are stored
in ``reports/`` as ``pytest.txt``, ``flake8.txt`` and ``mypy.txt``.
If a file is missing it is ignored.
"""

import json
from pathlib import Path

REPORTS_DIR = Path("reports")
OUTPUT_FILE = Path("reports/combined_report.json")

TOOLS = ["pytest", "flake8", "mypy"]

def read_tool_output(name: str) -> str:
    file_path = REPORTS_DIR / f"{name}.txt"
    if file_path.exists():
        return file_path.read_text(encoding="utf-8")
    return ""

def main():
    combined = {}
    for tool in TOOLS:
        output = read_tool_output(tool)
        combined[tool] = output
    REPORTS_DIR.mkdir(exist_ok=True)
    OUTPUT_FILE.write_text(json.dumps(combined, indent=2), encoding="utf-8")
    print(f"Combined report written to {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
