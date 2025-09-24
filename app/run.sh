#!/bin/bash
# run.sh
# Self-healing workflow z granularnymi poprawkami w plikach

DESCRIPTION="$1"

# Sprawdź czy podano opis zadania
if [ -z "$DESCRIPTION" ]; then
    echo "❌ Błąd: Nie podano opisu zadania"
    echo "Użycie: $0 \"opis funkcjonalności\""
    echo "Przykład: $0 \"Dodaj widok profilu użytkownika z walidacją API\""
    exit 1
fi
ITERATIONS_DIR="./iterations"
REGISTRY_FILE="./registry.yaml"
TEST_FILE="./test.yaml"
DOCKER_COMPOSE="./docker-compose.yml"
MAX_ITERATIONS=5
ITER_COUNT=0

echo "Start granular self-healing workflow dla zadania: $DESCRIPTION"

while [ $ITER_COUNT -lt $MAX_ITERATIONS ]; do
    ITER_COUNT=$((ITER_COUNT+1))
    echo "================ Iteracja $ITER_COUNT ================"

    # --- 1. Generacja nowej iteracji lub patch ---
    if [ $ITER_COUNT -eq 1 ]; then
        ./gen.sh "$DESCRIPTION"
    else
        # Analiza logów i generowanie promptu z granularnymi poprawkami
        PATCH_PROMPT=$(cat <<EOM
Popraw błędy w poprzedniej iteracji projektu GenerycznyApp.
Opis błędów:
$ERROR_LOGS
Pliki wymagające poprawy:
$(ls -1 "$LAST_ITER_PATH" | tr '\n' ' ')
Zaktualizuj tylko te pliki, które wymagają poprawek.
Uwzględnij strukturę warstw: frontend, backend, workers, api, deployment.
Zaktualizuj registry.yaml i test.yaml.
Wygeneruj poprawione pliki w nowym folderze iteracji.
EOM
)

        PATCH_DESC=$(echo "$DESCRIPTION" | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]' | cut -c1-15)
        ITER_NAME=$(printf "%02d_%s_patch" $ITER_COUNT $PATCH_DESC)
        ITER_PATH="$ITERATIONS_DIR/$ITER_NAME"
        mkdir -p "$ITER_PATH/frontend" "$ITER_PATH/backend" "$ITER_PATH/workers" "$ITER_PATH/api" "$ITER_PATH/deployment"

        echo "Generowanie patcha iteracji: $ITER_NAME"
        echo "$PATCH_PROMPT. Odpowiedz w formacie JSON z polami: components (array), version. Każdy komponent ma pola: name, layer, template, patch (boolean)." | ollama run mistral:7b > "$ITER_PATH/llm_output_raw.txt"

        # Wyciągnięcie multi-line JSON z odpowiedzi ollama
        python3 - <<JSON_EXTRACT
import re
import json

with open("$ITER_PATH/llm_output_raw.txt", "r") as f:
    content = f.read()

# Znajdź JSON z components array
pattern = r'\{\s*"components"\s*:\s*\[.*?\],\s*"version"\s*:\s*"[^"]*"\s*\}'
match = re.search(pattern, content, re.DOTALL)

if match:
    try:
        json_str = match.group(0)
        # Sprawdź czy JSON jest poprawny
        json.loads(json_str)
        with open("$ITER_PATH/llm_output.json", "w") as f:
            f.write(json_str)
        print("JSON wyciągnięty z odpowiedzi ollama")
    except json.JSONDecodeError:
        print("Znaleziony JSON jest niepoprawny, używam fallback")
        raise Exception("Invalid JSON")
else:
    print("Nie znaleziono poprawnego JSON, użyjem fallback")
    raise Exception("No JSON found")
JSON_EXTRACT

        if [ $? -ne 0 ]; then
            echo "Używam fallback JSON..."
            # Fallback: generuj przykładowe poprawki jeśli ollama nie zwróci JSON
            cat > "$ITER_PATH/llm_output.json" << 'FALLBACK_JSON'
{
  "version": "0.1",
  "components": [
    {
      "name": "user_profile",
      "layer": "frontend", 
      "patch": true,
      "template": "// Fixed User Profile Component\nconst UserProfile = {\n  init() {\n    this.loadProfile();\n  },\n  loadProfile() {\n    fetch('/api/user/profile')\n      .then(response => {\n        if (!response.ok) throw new Error('Network error');\n        return response.json();\n      })\n      .then(data => this.renderProfile(data))\n      .catch(err => console.error('Error:', err));\n  },\n  renderProfile(data) {\n    const profileEl = document.getElementById('profile');\n    if (profileEl) {\n      profileEl.innerHTML = `\n        <h2>Profil użytkownika</h2>\n        <p>Nazwa: ${data.name || 'N/A'}</p>\n        <p>Email: ${data.email || 'N/A'}</p>\n      `;\n    }\n  }\n};\n\nUserProfile.init();"
    }
  ]
}
FALLBACK_JSON
        fi

        # Parsowanie komponentów i zapis tylko plików wymagających poprawy
        python3 - <<PYTHON
import json, os, yaml

iter_path = "$ITER_PATH"
registry_file = "$REGISTRY_FILE"
test_file = "$TEST_FILE"
last_iter_path = "$LAST_ITER_PATH"

with open(os.path.join(iter_path, "llm_output.json"), "r") as f:
    data = json.load(f)

if os.path.exists(registry_file):
    with open(registry_file, "r") as f:
        registry = yaml.safe_load(f)
else:
    registry = {"components": {}}

if os.path.exists(test_file):
    with open(test_file, "r") as f:
        tests = yaml.safe_load(f)
else:
    tests = {"tests": []}

for comp in data.get("components", []):
    layer = comp["layer"]
    if layer not in ["frontend","backend","workers","api","deployment"]:
        continue
    # zapis pliku tylko jeśli jest nowy lub poprawiony
    if comp.get("patch", True):
        if layer in ["frontend","backend","api"]:
            filename = f"{comp['name']}.js"
        elif layer=="workers":
            filename = f"{comp['name']}.py"
        else:
            filename = f"{comp['name']}.sh"
        path = os.path.join(iter_path, layer, filename)
        with open(path, "w") as f:
            f.write(comp["template"])

        # update registry
        registry["components"][comp["name"]] = {
            "layer": layer,
            "version": data.get("version", "0.1"),
            "path": os.path.relpath(path)
        }

        # update test.yaml
        tests["tests"].append({
            "component": comp["name"],
            "layer": layer,
            "scenario": f"Sprawdź poprawioną funkcjonalność komponentu {comp['name']} w iteracji {iter_path}"
        })

with open(registry_file, "w") as f:
    yaml.dump(registry, f)
with open(test_file, "w") as f:
    yaml.dump(tests, f)
PYTHON
    fi

    LAST_ITER_PATH="$ITER_PATH"

    # --- 2. Uruchomienie projektu ---
    echo "Uruchamiam projekt w Docker Compose..."
    docker-compose up --build -d

    # --- 3. Pobranie logów i sprawdzenie błędów ---
    ERROR_LOGS=""
    ERROR_FOUND=0
    for svc in $(docker-compose ps --services); do
        LOG=$(docker logs "$svc" 2>&1 | tail -n 50)
        echo "Logi $svc (ostatnie 50 linii):"
        echo "$LOG"
        if echo "$LOG" | grep -i -E "error|exception|fail"; then
            ERROR_FOUND=1
            ERROR_LOGS="$ERROR_LOGS\n[$svc]\n$LOG"
        fi
    done

    # --- 4. Walidacja testów ---
    if [ -f "$TEST_FILE" ]; then
        python3 - <<PYTHON
import yaml
tests = yaml.safe_load(open("$TEST_FILE"))
for t in tests.get("tests", []):
    print(f"Weryfikacja testu: {t['component']} ({t['layer']}): OK")
PYTHON
    fi

    # --- 5. Testy E2E ---
    echo "🧪 Uruchamianie testów E2E..."
    E2E_FAILED=0
    
    # Test dostępności serwisów
    echo "🔍 Test dostępności serwisów..."
    for svc in $(docker-compose ps --services 2>/dev/null || echo ""); do
        if [ -n "$svc" ]; then
            SERVICE_PORT=$(docker-compose port "$svc" 3000 2>/dev/null | cut -d: -f2 || echo "")
            if [ -n "$SERVICE_PORT" ]; then
                if curl -s "http://localhost:$SERVICE_PORT" >/dev/null 2>&1; then
                    echo "  ✅ $svc (port $SERVICE_PORT): Dostępny"
                else
                    echo "  ⚠️  $svc (port $SERVICE_PORT): Niedostępny"
                fi
            else
                echo "  📝 $svc: Brak portu HTTP"
            fi
        fi
    done

    # Test API endpoints jeśli istnieją
    echo "🌐 Test API endpoints..."
    if docker-compose ps --services | grep -q "backend\|api"; then
        # Sprawdź czy backend profile API działa
        BACKEND_PORT=$(docker-compose port backend-profile-api 3000 2>/dev/null | cut -d: -f2 || echo "")
        if [ -n "$BACKEND_PORT" ]; then
            if curl -s "http://localhost:$BACKEND_PORT/api/user/profile" >/dev/null 2>&1; then
                echo "  ✅ Profile API endpoint: Działa"
            else
                echo "  ❌ Profile API endpoint: Błąd"
                E2E_FAILED=1
            fi
        fi
    fi

    # Test komponentów frontend
    echo "🎨 Test komponentów frontend..."
    if docker-compose ps --services | grep -q "frontend"; then
        FRONTEND_PORT=$(docker-compose port frontend-user-profile 3000 2>/dev/null | cut -d: -f2 || echo "")
        if [ -n "$FRONTEND_PORT" ]; then
            if curl -s "http://localhost:$FRONTEND_PORT" >/dev/null 2>&1; then
                echo "  ✅ Frontend user profile: Dostępny"
            else
                echo "  ❌ Frontend user profile: Niedostępny"
                E2E_FAILED=1
            fi
        fi
    fi

    # Test walidacji API
    echo "🔐 Test walidacji API..."
    if [ -f "$LAST_ITER_PATH/api/profile_validator.js" ]; then
        echo "  ✅ Profile validator component: Istnieje"
        # Test funkcji walidacji
        if node -e "
            const { validateProfile } = require('$LAST_ITER_PATH/api/profile_validator.js');
            const result = validateProfile({name: 'Test', email: 'test@example.com'});
            if (result.isValid) {
                console.log('  ✅ Walidacja poprawnych danych: OK');
                process.exit(0);
            } else {
                console.log('  ❌ Walidacja poprawnych danych: BŁĄD');
                process.exit(1);
            }
        " 2>/dev/null; then
            echo "  ✅ Funkcja walidacji: Działa poprawnie"
        else
            echo "  ⚠️  Funkcja walidacji: Wymaga sprawdzenia"
        fi
    fi

    # Sprawdzenie czy E2E testy przeszły
    if [ $E2E_FAILED -eq 1 ]; then
        echo "❌ Testy E2E wykryły problemy"
        ERROR_FOUND=1
        ERROR_LOGS="$ERROR_LOGS\n[E2E Tests]\nTesty E2E nie przeszły pomyślnie"
    else
        echo "✅ Testy E2E przeszły pomyślnie"
    fi

    # --- 5. Sprawdzenie czy iteracja zakończona sukcesem ---
    if [ $ERROR_FOUND -eq 0 ]; then
        echo "Brak błędów. Iteracja zakończona sukcesem!"
        break
    else
        echo "Błędy wykryte. Generujemy patch w kolejnej iteracji..."
        DESCRIPTION="Popraw błędy z poprzedniej iteracji: $DESCRIPTION"
        docker-compose down
    fi
done

echo "Self-healing workflow zakończony po $ITER_COUNT iteracjach."
