#!/bin/bash
# gen.sh
# Automatyczna generacja iteracji + registry/test + docker-compose.yml

DESCRIPTION="$1"
ITERATIONS_DIR="./iterations"
REGISTRY_FILE="./registry.yaml"
TEST_FILE="./test.yaml"
DOCKER_COMPOSE="./docker-compose.yml"

mkdir -p "$ITERATIONS_DIR"

# --- 1. Wyznacz nowy numer iteracji ---
LAST_ITER=$(ls -1 $ITERATIONS_DIR | grep iter_ | sort | tail -n1)
if [ -z "$LAST_ITER" ]; then
    NUM=1
else
    NUM=$(echo $LAST_ITER | sed -E 's/iter_0*([0-9]+)_.*/\1/' )
    NUM=$((NUM+1))
fi

# Tworzymy nazwę iteracji
SHORT_DESC=$(echo "$DESCRIPTION" | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]')
ITER_NAME=$(printf "iter_%03d_%s" $NUM $SHORT_DESC)
ITER_PATH="$ITERATIONS_DIR/$ITER_NAME"
mkdir -p "$ITER_PATH/frontend" "$ITER_PATH/backend" "$ITER_PATH/workers" "$ITER_PATH/api" "$ITER_PATH/deployment"

echo "Generowana nowa iteracja: $ITER_NAME"

# --- 2. Wczytaj ostatnie dwie iteracje do promptu ---
PREV_ITERS=$(ls -1 $ITERATIONS_DIR | grep iter_ | sort | tail -n2)
PREV_CONTENT=""
for it in $PREV_ITERS; do
    PREV_CONTENT="$PREV_CONTENT\n$(ls -1 $ITERATIONS_DIR/$it)"
done

# --- 3. Prompt dla LLM ---
read -r -d '' PROMPT <<EOM
Stwórz nową iterację projektu GenerycznyApp:
- Nowa iteracja: $ITER_NAME
- Funkcjonalność: $DESCRIPTION
- Uwzględnij wcześniejsze iteracje: $PREV_ITERS
- Komponenty ostatnich iteracji i pliki:
$PREV_CONTENT
- Generuj komponenty w folderach: frontend, backend, workers, api, deployment
- Dodaj Docker/SSH w deployment
- Uwzględnij llm.yaml i test.yaml
- Zaktualizuj registry.yaml
- Wygeneruj minimalne scenariusze testowe dla test.yaml
- Wygeneruj fragmenty do docker-compose.yml dla nowych komponentów
EOM

# --- 4. Wywołanie Ollama ---
ollama generate mistral-7b "$PROMPT" --json > "$ITER_PATH/llm_output.json"

# --- 5. Parsowanie i zapis komponentów, registry, test, docker-compose ---
python3 - <<PYTHON
import json, os, yaml

iter_path = "$ITER_PATH"
registry_file = "$REGISTRY_FILE"
test_file = "$TEST_FILE"
docker_compose_file = "$DOCKER_COMPOSE"

with open(os.path.join(iter_path, "llm_output.json"), "r") as f:
    data = json.load(f)

# --- Registry ---
if os.path.exists(registry_file):
    with open(registry_file, "r") as f:
        registry = yaml.safe_load(f)
else:
    registry = {"components": {}}

# --- Test ---
if os.path.exists(test_file):
    with open(test_file, "r") as f:
        tests = yaml.safe_load(f)
else:
    tests = {"tests": []}

# --- Docker Compose ---
if os.path.exists(docker_compose_file):
    with open(docker_compose_file, "r") as f:
        docker_compose = yaml.safe_load(f)
else:
    docker_compose = {"version": "3.9", "services": {}}

for comp in data.get("components", []):
    layer = comp["layer"]
    if layer not in ["frontend","backend","workers","api","deployment"]:
        continue
    # nazwa pliku
    if layer in ["frontend","backend","api"]:
        filename = f"{comp['name']}.js"
    elif layer=="workers":
        filename = f"{comp['name']}.py"
    else:
        filename = f"{comp['name']}.sh"
    path = os.path.join(iter_path, layer, filename)
    with open(path, "w") as f:
        f.write(comp["template"])

    # --- Registry ---
    registry["components"][comp["name"]] = {
        "layer": layer,
        "version": data.get("version", "0.1"),
        "path": os.path.relpath(path)
    }

    # --- Test ---
    tests["tests"].append({
        "component": comp["name"],
        "layer": layer,
        "scenario": f"Sprawdź podstawową funkcjonalność komponentu {comp['name']} w iteracji {iter_path}"
    })

    # --- Docker Compose ---
    service_name = f"{layer}_{comp['name']}"
    docker_compose["services"][service_name] = {
        "build": {"context": f"./{iter_path}/{layer}"},
        "volumes": [f"./{iter_path}/{layer}:/app/{layer}"],
        "ports": [f"{3000+len(docker_compose['services'])*100}:{3000+len(docker_compose['services'])*100}"]
    }

# --- Zapis plików ---
with open(registry_file, "w") as f:
    yaml.dump(registry, f)
with open(test_file, "w") as f:
    yaml.dump(tests, f)
with open(docker_compose_file, "w") as f:
    yaml.dump(docker_compose, f)

print(f"Iteracja {iter_path} wygenerowana. Registry, testy i docker-compose zaktualizowane.")
PYTHON

echo "Iteracja $ITER_NAME wygenerowana pomyślnie! Uruchom projekt: docker-compose up --build"
