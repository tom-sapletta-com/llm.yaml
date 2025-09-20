"""Testy przepływu iteracji projektu."""

import os
import shutil
from pathlib import Path
import pytest


def test_iteration_creation(tmp_path):
    """Testuje tworzenie nowej iteracji projektu."""
    # Przygotowanie środowiska testowego
    project_dir = tmp_path / "test_project"
    project_dir.mkdir()
    
    # Tworzenie katalogu common
    common_dir = project_dir / "common"
    common_dir.mkdir()
    (common_dir / "utils.py").write_text("def helper(): return 'test'")
    
    # Tworzenie manifestu
    manifest = {
        "project_manifest": {
            "project_name": "TestProject",
            "description": "Test",
            "vector_of_expectations": "Test"
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
        "analysis_tools": []
    }
    
    manifest_path = project_dir / "manifest.yaml"
    with open(manifest_path, 'w') as f:
        import yaml
        yaml.dump(manifest, f)
    
    # Uruchomienie skryptu (symulacja)
    os.chdir(project_dir)
    from ymll.update_iterations import create_new_iteration
    
    new_iter_dir = create_new_iteration(manifest_path)
    
    # Asercje
    assert new_iter_dir.exists()
    assert (new_iter_dir / "common" / "utils.py").exists()
    assert (new_iter_dir / "manifest.yaml").exists()
    
    # Sprawdzenie czy numer iteracji się zwiększył
    with open(new_iter_dir / "manifest.yaml") as f:
        new_manifest = yaml.safe_load(f)
        assert new_manifest["iteration_template"]["manifest_template"]["iteration_number"] == 2
