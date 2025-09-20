# Makefile for ymll project

# ----------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------
PYTHON ?= python3
PIP    ?= pip
REQ_FILE = requirements.txt

# ----------------------------------------------------------------------
# Help
# ----------------------------------------------------------------------
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  install   - install Python dependencies"
	@echo "  test      - run test suite (pytest, flake8, mypy)"
	@echo "  run       - execute full workflow (analysis, collect, plan, update)"
	@echo "  lint      - run flake8 and mypy"
	@echo "  clean     - remove generated files"
	@echo "  publish   - create a timestamped archive of the project"

# ----------------------------------------------------------------------
# Install dependencies
# ----------------------------------------------------------------------
.PHONY: install
install:
	@$(PIP) install -r $(REQ_FILE)

# ----------------------------------------------------------------------
# Run tests (wrapper script)
# ----------------------------------------------------------------------
.PHONY: test
test:
	@./run_tests.sh

# ----------------------------------------------------------------------
# Lint (flake8 + mypy)
# ----------------------------------------------------------------------
.PHONY: lint
lint:
	@flake8 src/ || true
	@mypy src/ || true

# ----------------------------------------------------------------------
# Full workflow: analysis -> collect -> generate plan -> update iterations
# ----------------------------------------------------------------------
.PHONY: run
run:
	@$(PYTHON) ymll/run_analysis.py
	@$(PYTHON) ymll/collect_reports.py
	@$(PYTHON) ymll/generate_plan.py
	@$(PYTHON) ymll/update_iterations.py

# ----------------------------------------------------------------------
# Clean generated artifacts
# ----------------------------------------------------------------------
.PHONY: clean
clean:
	@rm -f prompt_for_chatai.txt plan.yaml
	@rm -rf reports
	@rm -f iterations_map.yaml

# ----------------------------------------------------------------------
# Publish placeholder – creates a tar.gz archive with a timestamp
# ----------------------------------------------------------------------
.PHONY: publish
publish:
	@TIMESTAMP=$$(date +%Y%m%d%H%M%S) && \
	ARCHIVE="ymll-$${TIMESTAMP}.tar.gz" && \
	echo "Creating archive $$ARCHIVE ..." && \
	tar --exclude='./.git' --exclude='./.venv' -czf $$ARCHIVE . && \
	echo "Archive created: $$ARCHIVE"