#!/usr/bin/env python3
"""update_iterations.py

Updates `iterations_map.yaml` with a new iteration entry based on the
current manifest and archives old iterations according to the rules in
`structure_guidelines.rules.archive_old_iterations`.
"""

import yaml
import shutil
from pathlib import Path
import datetime

MANIFEST_FILE = Path("manifest.yaml")
MAP_FILE = Path("iterations_map.yaml")
ARCHIVE_DIR = Path("archive")

def load_yaml(path: Path) -> dict:
    if not path.exists():
        return {}
    with path.open("r", encoding="utf-8") as f:
        return yaml.safe_load(f) or {}

def save_yaml(data, path: Path):
    with path.open("w", encoding="utf-8") as f:
        yaml.safe_dump(data, f, sort_keys=False)

def main():
    manifest = load_yaml(MANIFEST_FILE)
    it_template = manifest.get("iteration_template", {})
    tmpl = it_template.get("manifest_template", {})
    folder_pattern = it_template.get("folder_pattern", "iteration_{number}_{feature}_{version}")
    # Build folder name for the new iteration
    folder_name = folder_pattern.format(
        number=int(tmpl.get("iteration_number", 0)) + 1,
        feature=tmpl.get("feature_name", "feature"),
        version=tmpl.get("version", 1),
    )
    new_entry = {
        "iteration": int(tmpl.get("iteration_number", 0)) + 1,
        "folder": folder_name,
        "stable": tmpl.get("stable", False),
        "parent_iteration": tmpl.get("parent_iteration", ""),
        "notes": tmpl.get("notes", ""),
    }
    # Load or create map
    iterations = load_yaml(MAP_FILE)
    if not isinstance(iterations, list):
        iterations = []
    iterations.append(new_entry)
    # Archive old iterations if rule enabled
    rules = manifest.get("structure_guidelines", {}).get("rules", {})
    if rules.get("archive_old_iterations", False):
        ARCHIVE_DIR.mkdir(exist_ok=True)
        for entry in iterations[:-1]:
            old_folder = Path(entry["folder"]).resolve()
            if old_folder.exists():
                timestamp = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
                dest = ARCHIVE_DIR / f"{old_folder.name}_{timestamp}"
                shutil.move(str(old_folder), str(dest))
    # Save updated map
    save_yaml(iterations, MAP_FILE)
    print(f"Iterations map updated. New iteration folder: {folder_name}")

if __name__ == "__main__":
    main()
