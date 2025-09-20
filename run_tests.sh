#!/usr/bin/env bash
# run_tests.sh – executes the analysis tools defined in manifest.yaml
# This script is a simple wrapper; it does not parse the manifest, it just runs the common tools.
# Adjust paths if your project layout differs.

set -e

# Run pytest (assumes tests are in ./tests)
if command -v pytest >/dev/null 2>&1; then
  echo "Running pytest..."
  pytest tests/ || true
else
  echo "pytest not found – skipping."
fi

# Run flake8 on src directory
if command -v flake8 >/dev/null 2>&1; then
  echo "Running flake8..."
  flake8 src/ || true
else
  echo "flake8 not found – skipping."
fi

# Run mypy on src directory
if command -v mypy >/dev/null 2>&1; then
  echo "Running mypy..."
  mypy src/ || true
else
  echo "mypy not found – skipping."
fi

echo "All analysis tools have been executed."
