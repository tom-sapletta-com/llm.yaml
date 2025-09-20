#!/bin/bash
set -e

echo "Running pytest..."
if [ -d "tests" ]; then
    python -m pytest tests/ -v
else
    echo "No tests/ directory found. Skipping pytest."
fi

echo -e "\nRunning flake8..."
if [ -d "src" ]; then
    flake8 src/ || true
else
    echo "No src/ directory found. Skipping flake8."
fi

echo -e "\nRunning mypy..."
if [ -d "src" ]; then
    mypy src/ || true
else
    echo "No src/ directory found. Skipping mypy."
fi