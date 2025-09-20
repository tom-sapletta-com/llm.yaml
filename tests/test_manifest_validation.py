"""Testy walidacji manifestu YAML."""

import pytest
import yaml
from pathlib import Path


def test_manifest_structure(tmp_path):
    """Sprawdza poprawność struktury pliku manifestu."""
    test_manifest = {
        "project_manifest": {
            "project_name": "TestProject",
            "description": "Testowy projekt",
            "vector_of_expectations": "Test wektor"
        },
        "iteration_template": {
            "folder_pattern": "iteration_{number}_{feature}_v{version}",
            "manifest_template": {
                "iteration_number": 1,
                "feature_name": "TestFeature",
                "version": 1,
                "stable": False,
                "parent_iteration": ""
            }
        },
        "analysis_tools": [
            {"name": "pytest", "path": "tests/", "timeout": 30}
        ]
    }
    
    manifest_path = tmp_path / "test_manifest.yaml"
    with open(manifest_path, 'w') as f:
        yaml.dump(test_manifest, f)
    
    assert manifest_path.exists()
    
    with open(manifest_path) as f:
        loaded = yaml.safe_load(f)
        assert loaded["project_manifest"]["project_name"] == "TestProject"
        assert loaded["iteration_template"]["manifest_template"]["iteration_number"] == 1


@pytest.mark.parametrize("tool", ["pytest", "flake8", "mypy"])
def test_analysis_tools_config(tool):
    """Sprawdza konfigurację narzędzi analitycznych."""
    from ymll.run_analysis import load_manifest
    
    manifest = load_manifest("manifest.yaml")
    tools = [t["name"] for t in manifest.get("analysis_tools", [])]
    
    assert tool in tools, f"{tool} nie jest skonfigurowany w manifeście"
