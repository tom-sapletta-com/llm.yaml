"""Konfiguracja globalna dla testów."""

import pytest
import sys
from pathlib import Path

# Dodanie ścieżki do modułów projektu
sys.path.insert(0, str(Path(__file__).parent.parent / "ymll"))


@pytest.fixture(scope="session")
def sample_manifest():
    """Zwraca przykładowy poprawny manifest do testów."""
    return {
        "project_manifest": {
            "project_name": "TestProject",
            "description": "Test",
            "vector_of_expectations": "Test wektor"
        },
        "iteration_template": {
            "folder_pattern": "iteration_{number}_test_v{version}",
            "manifest_template": {
                "iteration_number": 1,
                "feature_name": "test",
                "version": 1,
                "stable": False,
                "parent_iteration": ""
            }
        },
        "analysis_tools": [
            {"name": "pytest", "path": "tests/", "timeout": 30},
            {"name": "flake8", "path": "src/", "timeout": 10},
            {"name": "mypy", "path": "src/", "timeout": 10}
        ]
    }
