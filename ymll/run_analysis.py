#!/usr/bin/env python3
"""run_analysis.py

Automatycznie wczytuje ``manifest.yaml`` i uruchamia wszystkie narzędzia
zdefiniowane w sekcji ``analysis_tools``. Wyniki (stdout+stderr oraz kod
zwrócenia) są zapisywane w pliku ``prompt_for_chatai.txt`` razem z
informacjami o projekcie i iteracji.

Skrypt jest prosty, nie wymaga dodatkowych zależności poza standardową
biblioteką Pythona.
"""

import yaml
import subprocess
import shlex
from pathlib import Path
import json

MANIFEST_FILE = Path(__file__).resolve().parents[1] / "manifest.yaml"
PROMPT_FILE = Path(__file__).resolve().parents[1] / "prompt_for_chatai.txt"

def load_manifest() -> dict:
    with MANIFEST_FILE.open("r", encoding="utf-8") as f:
        return yaml.safe_load(f)

def run_tool(name: str, path: str, timeout: int) -> dict:
    cmd = f"{name} {path}"
    try:
        completed = subprocess.run(
            shlex.split(cmd),
            capture_output=True,
            text=True,
            timeout=timeout,
        )
        return {
            "tool": name,
            "returncode": completed.returncode,
            "output": completed.stdout + "\n" + completed.stderr,
        }
    except subprocess.TimeoutExpired:
        return {
            "tool": name,
            "returncode": -1,
            "output": "TIMEOUT",
        }
    except FileNotFoundError:
        return {
            "tool": name,
            "returncode": -1,
            "output": f"Tool '{name}' not found on PATH",
        }

def generate_prompt(manifest: dict, results: list[dict]) -> str:
    lines = []
    pm = manifest["project_manifest"]
    it = manifest["iteration_template"]["manifest_template"]
    lines.append(f"Analizuj projekt {pm.get('project_name', '')}")
    lines.append(f"Vector of expectations: {pm.get('vector_of_expectations', '')}")
    lines.append(f"Iteracja: {it.get('iteration_number', '')}")
    lines.append(f"Feature: {it.get('feature_name', '')}\n")
    lines.append("Analiza wyników narzędzi:")
    for r in results:
        lines.append(f"\nTool: {r['tool']}")
        lines.append(f"Return code: {r['returncode']}")
        lines.append("Output:\n" + r["output"])
    lines.append("\nNa podstawie powyższych informacji wygeneruj plan kolejnej iteracji oraz sugestie napraw.")
    return "\n".join(lines)

def main():
    manifest = load_manifest()
    tools = manifest.get("analysis_tools", [])
    results = []
    for tool in tools:
        name = tool.get("name")
        path = tool.get("path", "")
        timeout = tool.get("timeout", 30)
        results.append(run_tool(name, path, timeout))
    prompt = generate_prompt(manifest, results)
    PROMPT_FILE.write_text(prompt, encoding="utf-8")
    print(f"Prompt zapisany w {PROMPT_FILE}")

if __name__ == "__main__":
    main()
