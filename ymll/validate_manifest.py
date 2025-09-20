#!/usr/bin/env python3
"""validate_manifest.py

Validates ``manifest.yaml`` against ``manifest_schema.json`` using ``jsonschema``.
If validation fails, prints errors and exits with non‑zero status.
"""

import json
import sys
from pathlib import Path
import yaml
import jsonschema

MANIFEST_PATH = Path("manifest.yaml")
SCHEMA_PATH = Path("manifest_schema.json")

def load_yaml(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as f:
        return yaml.safe_load(f)

def load_json(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)

def main():
    try:
        manifest = load_yaml(MANIFEST_PATH)
        schema = load_json(SCHEMA_PATH)
        jsonschema.validate(instance=manifest, schema=schema)
        print("Manifest is valid.")
    except jsonschema.exceptions.ValidationError as e:
        print("Manifest validation error:")
        print(e)
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
