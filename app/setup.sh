#!/bin/bash
# setup.sh - Automatyczna instalacja Ollama i modeli LLM

set -e

OLLAMA_MODEL="mistral:7b"
BACKUP_MODEL="qwen2.5:7b-instruct"

echo "🚀 YMLL Self-Healing Workflow - Setup Script"
echo "=============================================="

# Funkcja sprawdzania czy komenda istnieje
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Funkcja instalacji Ollama
install_ollama() {
    echo "📦 Instalacja Ollama..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -fsSL https://ollama.ai/install.sh | sh
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command_exists brew; then
            brew install ollama
        else
            curl -fsSL https://ollama.ai/install.sh | sh
        fi
    else
        echo "❌ Nieobsługiwany system operacyjny: $OSTYPE"
        echo "   Proszę zainstalować Ollama ręcznie: https://ollama.ai"
        exit 1
    fi
}

# Sprawdzenie i instalacja Ollama
if ! command_exists ollama; then
    echo "⚠️  Ollama nie jest zainstalowana"
    install_ollama
else
    echo "✅ Ollama jest już zainstalowana"
fi

# Uruchomienie serwisu Ollama w tle jeśli nie działa
echo "🔄 Sprawdzanie serwisu Ollama..."
if ! pgrep -f "ollama serve" > /dev/null; then
    echo "🚀 Uruchamianie serwisu Ollama..."
    ollama serve &
    OLLAMA_PID=$!
    echo "   Ollama PID: $OLLAMA_PID"
    
    # Czekamy na uruchomienie serwisu
    echo "⏳ Czekanie na uruchomienie serwisu..."
    sleep 5
    
    # Sprawdzenie czy serwis działa
    if ! pgrep -f "ollama serve" > /dev/null; then
        echo "❌ Nie udało się uruchomić serwisu Ollama"
        exit 1
    fi
else
    echo "✅ Serwis Ollama już działa"
fi

# Sprawdzenie dostępnych modeli
echo "📋 Sprawdzanie dostępnych modeli..."
AVAILABLE_MODELS=$(ollama list | tail -n +2 | awk '{print $1}' | tr '\n' ' ')
echo "   Dostępne modele: $AVAILABLE_MODELS"

# Funkcja pobierania modelu
pull_model() {
    local model="$1"
    echo "📥 Pobieranie modelu: $model"
    if ollama pull "$model"; then
        echo "✅ Model $model został pobrany pomyślnie"
        return 0
    else
        echo "❌ Nie udało się pobrać modelu $model"
        return 1
    fi
}

# Sprawdzenie i pobranie głównego modelu
if echo "$AVAILABLE_MODELS" | grep -q "$OLLAMA_MODEL"; then
    echo "✅ Model $OLLAMA_MODEL jest już dostępny"
else
    echo "⚠️  Model $OLLAMA_MODEL nie jest dostępny"
    if ! pull_model "$OLLAMA_MODEL"; then
        echo "🔄 Próba pobrania modelu zapasowego: $BACKUP_MODEL"
        if ! pull_model "$BACKUP_MODEL"; then
            echo "❌ Nie udało się pobrać żadnego z modeli"
            echo "   Dostępne modele w repozytorium ollama:"
            ollama list || echo "   Nie można pobrać listy modeli"
            exit 1
        else
            # Aktualizuj skrypty aby używały modelu zapasowego
            echo "🔧 Aktualizacja skryptów do używania modelu zapasowego..."
            sed -i "s/mistral:7b/$BACKUP_MODEL/g" gen.sh run.sh
        fi
    fi
fi

# Test działania modelu
echo "🧪 Test działania modelu..."
TEST_RESPONSE=$(echo "Test: odpowiedz 'OK'" | ollama run "$OLLAMA_MODEL" 2>/dev/null || echo "Test: odpowiedz 'OK'" | ollama run "$BACKUP_MODEL" 2>/dev/null)
if [[ "$TEST_RESPONSE" == *"OK"* ]] || [[ "$TEST_RESPONSE" == *"ok"* ]]; then
    echo "✅ Model działa poprawnie"
else
    echo "⚠️  Model odpowiedział: $TEST_RESPONSE"
    echo "   Model może działać, ale odpowiedź jest nieoczekiwana"
fi

# Sprawdzenie Docker
echo "🐳 Sprawdzanie Docker..."
if ! command_exists docker; then
    echo "❌ Docker nie jest zainstalowany"
    echo "   Proszę zainstalować Docker: https://docs.docker.com/get-docker/"
    exit 1
else
    echo "✅ Docker jest zainstalowany"
    
    # Sprawdzenie czy Docker daemon działa
    if ! docker info >/dev/null 2>&1; then
        echo "❌ Docker daemon nie działa"
        echo "   Proszę uruchomić Docker"
        exit 1
    else
        echo "✅ Docker daemon działa"
    fi
fi

# Sprawdzenie Docker Compose
if ! command_exists docker-compose && ! docker compose version >/dev/null 2>&1; then
    echo "❌ Docker Compose nie jest dostępny"
    echo "   Proszę zainstalować Docker Compose"
    exit 1
else
    echo "✅ Docker Compose jest dostępny"
fi

# Tworzenie struktury folderów jeśli nie istnieje
echo "📁 Sprawdzanie struktury folderów..."
mkdir -p iterations logs
echo "✅ Struktura folderów gotowa"

# Sprawdzenie uprawnień do plików wykonywalnych
echo "🔐 Sprawdzanie uprawnień..."
chmod +x gen.sh run.sh setup.sh 2>/dev/null || true
echo "✅ Uprawnienia ustawione"

echo ""
echo "🎉 Setup zakończony pomyślnie!"
echo "=============================================="
echo "📝 Dostępne komendy:"
echo "   ./gen.sh \"opis funkcjonalności\"  - Generuje nową iterację"
echo "   ./run.sh \"opis funkcjonalności\"  - Uruchamia self-healing workflow"
echo "   docker-compose up --build        - Uruchamia komponenty ręcznie"
echo ""
echo "🤖 Używany model LLM: $(ollama list | grep -E "(mistral|qwen)" | head -1 | awk '{print $1}' || echo 'nieznany')"
echo "📊 Status serwisu: $(pgrep -f "ollama serve" >/dev/null && echo "✅ Działa" || echo "❌ Nie działa")"
echo ""
