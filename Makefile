# Makefile dla projektu YMLL

# ----------------------------------------------------------------------
# Zmienne
# ----------------------------------------------------------------------
PYTHON ?= python3
PIP    ?= pip
REQ_FILE = requirements.txt

# ----------------------------------------------------------------------
# Pomoc
# ----------------------------------------------------------------------
.PHONY: help
help:
	@echo "Dostępne polecenia:"
	@echo "  install   - instaluje zależności Pythona"
	@echo "  test      - uruchamia testy i analizę kodu"
	@echo "  run       - wykonuje pełny workflow (analiza → zbiorczy raport → plan → nowa iteracja)"
	@echo "  lint      - sprawdza jakość kodu (flake8 + mypy)"
	@echo "  clean     - usuwa wygenerowane pliki"
	@echo "  publish   - tworzy archiwum projektu z datą"

# ----------------------------------------------------------------------
# Instalacja zależności
# ----------------------------------------------------------------------
.PHONY: install
install:
	@echo " Instalowanie zależności..."
	@$(PIP) install -r $(REQ_FILE)

# ----------------------------------------------------------------------
# Uruchomienie testów
# ----------------------------------------------------------------------
.PHONY: test
test:
	@chmod +x run_tests.sh
	@./run_tests.sh

# ----------------------------------------------------------------------
# Sprawdzenie jakości kodu
# ----------------------------------------------------------------------
.PHONY: lint
lint:
	@echo " Sprawdzanie jakości kodu..."
	@if [ -d "src" ]; then \
		flake8 src/ --show-source --statistics || true; \
		echo -e "\n Sprawdzanie typów mypy..."; \
		mypy src/ --pretty || true; \
	else \
		echo " Brak katalogu src/. Pomijam sprawdzanie jakości kodu."; \
	fi

# ----------------------------------------------------------------------
# Pełny workflow
# ----------------------------------------------------------------------
.PHONY: run
run:
	@echo " Uruchamianie pełnego workflow..."
	@$(PYTHON) ymll/run_analysis.py
	@$(PYTHON) ymll/collect_reports.py
	@$(PYTHON) ymll/generate_plan.py
	@$(PYTHON) ymll/update_iterations.py
	@echo -e "\n Workflow zakończony. Sprawdź nową iterację w katalogu iteration_*"

# ----------------------------------------------------------------------
# Czyszczenie
# ----------------------------------------------------------------------
.PHONY: clean
clean:
	@echo " Czyszczenie..."
	@rm -f prompt_for_chatai.txt plan.yaml
	@rm -rf reports
	@rm -f iterations_map.yaml
	@echo " Wygenerowane pliki zostały usunięte"

# ----------------------------------------------------------------------
# Publikacja (tworzy archiwum .tar.gz)
# ----------------------------------------------------------------------
.PHONY: publish
publish:
	@echo " Przygotowywanie archiwum..."
	@TIMESTAMP=$$(date +%Y%m%d%H%M%S) && \
	ARCHIVE="ymll-$${TIMESTAMP}.tar.gz" && \
	tar --exclude='./.git' --exclude='./.venv' -czf $$ARCHIVE . && \
	echo -e "\n Utworzono archiwum: $$ARCHIVE"

# ----------------------------------------------------------------------
# Domyślne polecenie (wyświetla pomoc)
# ----------------------------------------------------------------------
.DEFAULT_GOAL := help