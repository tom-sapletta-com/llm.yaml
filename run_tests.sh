#!/bin/bash
set -e

# Kolorowe komunikaty
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW} Uruchamianie testów...${NC}"
if [ -d "tests" ] && [ "$(ls -A tests)" ]; then
    python -m pytest tests/ -v --color=yes
else
    echo -e "${YELLOW} Brak testów do uruchomienia.${NC}
   Aby dodać testy, utwórz pliki w katalogu tests/ z prefixem test_"
fi

echo -e "\n${YELLOW} Sprawdzanie jakości kodu...${NC}"
if [ -d "src" ] && [ "$(ls -A src)" ]; then
    echo -e "${GREEN} Uruchamiam flake8...${NC}"
    flake8 src/ --show-source --statistics || true
    
    echo -e "\n${GREEN} Sprawdzanie typów mypy...${NC}"
    mypy src/ --pretty || true
else
    echo -e "${YELLOW} Brak kodu źródłowego do analizy.${NC}\n   Dodaj kod do katalogu src/ aby przeprowadzić analizę."
fi

echo -e "\n Analiza zakończona. Sprawdź powyższe wyniki.${NC}"