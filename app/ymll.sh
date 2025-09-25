#!/bin/bash
# ymll.sh - Uniwersalny system iteracyjnej refaktoryzacji z self-healing
# v2.0 - Rozwiązuje problemy ze spójnością plików i portów

set -e

# ============================================
# KONFIGURACJA
# ============================================
PROJECT_NAME="${PROJECT_NAME:-GenerycznyApp}"
ITERATIONS_DIR="./iterations"
REGISTRY_FILE="./registry.yaml"
TEST_FILE="./test.yaml"
DOCKER_COMPOSE="./docker-compose.yml"
CONFIG_FILE="./ymll.config.yaml"
MAX_ITERATIONS=5
BASE_PORT=3000

# ============================================
# FUNKCJE POMOCNICZE
# ============================================

# Inicjalizacja projektu
init_project() {
    echo "🎯 Inicjalizacja projektu YMLL v2..."

    # Tworzenie struktury katalogów
    mkdir -p "$ITERATIONS_DIR" "common" "templates" "logs" "configs"

    # Tworzenie konfiguracji projektu
    if [ ! -f "$CONFIG_FILE" ]; then
        cat > "$CONFIG_FILE" << 'EOF'
project:
  name: GenerycznyApp
  version: 2.0
  description: "Inteligentny system refaktoryzacji z self-healing"

layers:
  frontend:
    extension: js
    entrypoint: server.js
    dockerfile_template: node
    port_offset: 0
  backend:
    extension: js
    entrypoint: index.js
    dockerfile_template: node
    port_offset: 100
  api:
    extension: js
    entrypoint: server.js
    dockerfile_template: node
    port_offset: 200
  workers:
    extension: py
    entrypoint: worker.py
    dockerfile_template: python
    port_offset: 300
  deployment:
    extension: sh
    entrypoint: deploy.sh
    dockerfile_template: bash
    port_offset: 400

llm_config:
  model: mistral:7b
  temperature: 0.3
  max_tokens: 4096
  retry_attempts: 3

validation:
  required_files:
    - entrypoint
    - Dockerfile
    - package.json|requirements.txt
  health_checks:
    timeout: 30
    interval: 5
    retries: 6

self_healing:
  max_iterations: 5
  analysis_depth: 100  # lines of logs to analyze
  fix_strategy: targeted  # targeted | full | incremental
EOF
        echo "✅ Utworzono konfigurację projektu: $CONFIG_FILE"
    fi

    # Tworzenie szablonów Dockerfile
    create_dockerfile_templates

    # Tworzenie przykładowych komponentów wspólnych
    create_common_components

    echo "✅ Projekt zainicjalizowany pomyślnie"
}

# Tworzenie szablonów Dockerfile
create_dockerfile_templates() {
    # Szablon Node.js
    cat > "templates/Dockerfile.node" << 'EOF'
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production
COPY . .
EXPOSE {{PORT}}
CMD ["node", "{{ENTRYPOINT}}"]
EOF

    # Szablon Python
    cat > "templates/Dockerfile.python" << 'EOF'
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE {{PORT}}
CMD ["python", "{{ENTRYPOINT}}"]
EOF

    # Szablon Bash
    cat > "templates/Dockerfile.bash" << 'EOF'
FROM alpine:latest
WORKDIR /app
RUN apk add --no-cache bash
COPY . .
RUN chmod +x {{ENTRYPOINT}}
CMD ["./{{ENTRYPOINT}}"]
EOF
}

# Tworzenie komponentów wspólnych
create_common_components() {
    # Wspólny moduł logowania
    cat > "common/logger.js" << 'EOF'
// Wspólny moduł logowania
const logger = {
    info: (msg) => console.log(`[INFO] ${new Date().toISOString()} - ${msg}`),
    error: (msg) => console.error(`[ERROR] ${new Date().toISOString()} - ${msg}`),
    debug: (msg) => console.log(`[DEBUG] ${new Date().toISOString()} - ${msg}`)
};
module.exports = logger;
EOF

    # Wspólny moduł konfiguracji
    cat > "common/config.js" << 'EOF'
// Wspólna konfiguracja
module.exports = {
    port: process.env.PORT || 3000,
    env: process.env.NODE_ENV || 'development',
    apiUrl: process.env.API_URL || 'http://localhost:3000'
};
EOF
}

# ============================================
# GENEROWANIE NOWEJ ITERACJI
# ============================================

generate_iteration() {
    local DESCRIPTION="$1"

    if [ -z "$DESCRIPTION" ]; then
        echo "❌ Błąd: Brak opisu iteracji"
        echo "Użycie: $0 generate \"Opis funkcjonalności\""
        exit 1
    fi

    echo "🚀 Generowanie nowej iteracji: $DESCRIPTION"

    # Wyznacz numer iteracji
    local ITER_NUM=$(get_next_iteration_number)
    local ITER_NAME=$(printf "%02d_%s" "$ITER_NUM" "$(echo "$DESCRIPTION" | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]' | cut -c1-20)")
    local ITER_PATH="$ITERATIONS_DIR/$ITER_NAME"

    # Tworzenie struktury katalogów
    mkdir -p "$ITER_PATH"/{frontend,backend,api,workers,deployment}

    # Generowanie promptu z kontekstem
    local PROMPT=$(generate_smart_prompt "$DESCRIPTION" "$ITER_PATH")

    # Wywołanie LLM z ulepszonymi instrukcjami
    echo "$PROMPT" | ollama run mistral:7b > "$ITER_PATH/llm_output_raw.txt"

    # Parsowanie i generowanie komponentów
    parse_and_generate_components "$ITER_PATH"

    # Walidacja wygenerowanych komponentów
    validate_iteration "$ITER_PATH"

    # Aktualizacja registry i docker-compose
    update_registry_and_compose "$ITER_PATH" "$ITER_NAME"

    echo "✅ Iteracja $ITER_NAME wygenerowana pomyślnie"
}

# Generowanie inteligentnego promptu
generate_smart_prompt() {
    local DESCRIPTION="$1"
    local ITER_PATH="$2"

    # Wczytaj konfigurację warstw
    local CONFIG=$(cat "$CONFIG_FILE")

    # Wykryj czy żądano FastAPI/Python dla warstwy API
    local USE_FASTAPI="false"
    if echo "$DESCRIPTION" | grep -qiE 'fastapi|python api|python'; then
        USE_FASTAPI="true"
    fi

    # Zdefiniuj specyfikację plików dla API oraz blok przykładowy
    local API_REQ_LINE
    local API_EXAMPLE_BLOCK
    if [ "$USE_FASTAPI" = "true" ]; then
        API_REQ_LINE="  - api: main.py (główny plik), requirements.txt"
        API_EXAMPLE_BLOCK=$(cat << 'JSON'
    {
      "name": "api",
      "layer": "api",
      "files": {
        "main.py": "from fastapi import FastAPI\napp = FastAPI()\n\nitems = [{\"id\":1,\"name\":\"Product 1\",\"price\":10.99},{\"id\":2,\"name\":\"Product 2\",\"price\":15.99}]\n\n@app.get('/api/v1/products')\ndef get_all_products():\n    return items",
        "requirements.txt": "fastapi==0.110.0\nuvicorn==0.29.0"
      }
    },
JSON
)
    else
        API_REQ_LINE="  - api: server.js (główny plik), package.json"
        API_EXAMPLE_BLOCK=$(cat << 'JSON'
    {
      "name": "api",
      "layer": "api",
      "files": {
        "server.js": "// PEŁNY KOD API\nconst express = require('express');\nconst app = express();\napp.get('/api/v1', (req, res) => res.json({version:'1.0'}));\napp.listen(3200, () => console.log('API on 3200'));",
        "package.json": "{\"name\":\"api\",\"version\":\"1.0.0\",\"dependencies\":{\"express\":\"^4.18.0\"}}"
      }
    },
JSON
)
    fi

    cat << EOF
Stwórz kompletną implementację dla projektu $PROJECT_NAME.

ZADANIE: $DESCRIPTION

KRYTYCZNE WYMAGANIA STRUKTURALNE:
1. Każda warstwa MUSI mieć dokładnie te pliki:
   - frontend: server.js (główny plik), package.json
   - backend: index.js (główny plik), package.json
   $API_REQ_LINE
   - workers: worker.py (główny plik), requirements.txt
   - deployment: deploy.sh (główny plik)

2. STRUKTURA ODPOWIEDZI (JSON):
{
  "version": "1.0",
  "components": [
    {
      "name": "frontend",
      "layer": "frontend",
      "files": {
        "server.js": "// PEŁNY KOD SERWERA FRONTEND\nconst express = require('express');\nconst app = express();\napp.get('/', (req, res) => res.send('Frontend'));\napp.listen(3000, () => console.log('Frontend on 3000'));",
        "package.json": "{\"name\":\"frontend\",\"version\":\"1.0.0\",\"dependencies\":{\"express\":\"^4.18.0\"}}"
      }
    },
    {
      "name": "backend",
      "layer": "backend",
      "files": {
        "index.js": "// PEŁNY KOD SERWERA BACKEND\nconst express = require('express');\nconst app = express();\napp.get('/api', (req, res) => res.json({status:'ok'}));\napp.listen(3100, () => console.log('Backend on 3100'));",
        "package.json": "{\"name\":\"backend\",\"version\":\"1.0.0\",\"dependencies\":{\"express\":\"^4.18.0\"}}"
      }
    },
${API_EXAMPLE_BLOCK}
    {
      "name": "workers",
      "layer": "workers",
      "files": {
        "worker.py": "# PEŁNY KOD WORKER\nimport time\nprint('Worker started')\nwhile True:\n    print('Processing...')\n    time.sleep(10)",
        "requirements.txt": "requests==2.28.0"
      }
    }
  ]
}

WAŻNE:
- Każdy komponent MUSI mieć pole "files" z WSZYSTKIMI wymaganymi plikami
- Porty: frontend=3000, backend=3100, api=3200, workers=3300
- Generuj PEŁNY, działający kod, nie placeholdery
- Odpowiedź MUSI być w formacie JSON

WYGENERUJ TERAZ implementację dla: $DESCRIPTION
EOF
}

# Parsowanie i generowanie komponentów
parse_and_generate_components() {
    local ITER_PATH="$1"

    python3 - "$ITER_PATH" << 'PYTHON'
import json
import os
import re
import sys

iter_path = sys.argv[1]

# Wczytaj surowy output
with open(f"{iter_path}/llm_output_raw.txt", "r") as f:
    content = f.read()

# Wyciągnij JSON - sprawdź zarówno surowy JSON jak i JSON w markdown
pattern = r'\{.*"components".*\}'
matches = re.findall(pattern, content, re.DOTALL)

# Jeśli nie znaleziono, sprawdź JSON w markdown code blocks
if not matches:
    json_pattern = r'```json\s*\n(.*?)\n```'
    json_matches = re.findall(json_pattern, content, re.DOTALL)
    if json_matches:
        matches = json_matches

if not matches:
    print("❌ Nie znaleziono JSON w odpowiedzi LLM, próbuję wyciągnąć kod z markdown...")
    
    # Spróbuj wyciągnąć kod FastAPI z markdown
    import re
    
    # Znajdź bloki kodu Python
    python_pattern = r'```python.*?\n(.*?)```'
    python_blocks = re.findall(python_pattern, content, re.DOTALL)
    
    fastapi_code = None
    for block in python_blocks:
        if 'FastAPI' in block:
            fastapi_code = block.strip()
            break
    
    if fastapi_code:
        print("✅ Znaleziono kod FastAPI, generuję strukturę...")
        
        # Wyciągnij requirements.txt - szukamy bloków bez "python"
        req_pattern = r'```\n([^`]*==.*?)```'
        requirements_blocks = re.findall(req_pattern, content, re.DOTALL)
        requirements_txt = "fastapi==0.68.0\\nuvicorn==0.15.0"
        if requirements_blocks:
            req_text = requirements_blocks[0].strip()
            if req_text:
                requirements_txt = req_text
        
        data = {
            "version": "1.0",
            "components": [
                {
                    "name": "frontend",
                    "layer": "frontend",
                    "files": {
                        "server.js": """const express = require('express');
const app = express();
app.use(express.static('public'));
app.get('/', (req, res) => res.send(`
<!DOCTYPE html>
<html>
<head><title>Product API Frontend</title></head>
<body>
    <h1>Product API Frontend</h1>
    <button onclick="loadProducts()">Load Products</button>
    <div id="products"></div>
    <script>
        async function loadProducts() {
            try {
                const response = await fetch('http://localhost:3200/api/v1/products');
                const data = await response.json();
                document.getElementById('products').innerHTML = 
                    '<h2>Products:</h2>' + 
                    JSON.stringify(data, null, 2);
            } catch (error) {
                document.getElementById('products').innerHTML = 'Error: ' + error.message;
            }
        }
    </script>
</body>
</html>
`));
app.listen(3000, () => console.log('Frontend server running on port 3000'));""",
                        "package.json": '{"name":"frontend","version":"1.0.0","main":"server.js","dependencies":{"express":"^4.18.0"}}'
                    }
                },
                {
                    "name": "api",
                    "layer": "api",
                    "files": {
                        "server.py": fastapi_code,
                        "requirements.txt": requirements_txt
                    }
                },
                {
                    "name": "backend",
                    "layer": "backend",
                    "files": {
                        "index.js": """const express = require('express');
const app = express();
app.use(express.json());
app.get('/api/status', (req, res) => res.json({status: 'Backend running', timestamp: new Date()}));
app.listen(3100, () => console.log('Backend API running on port 3100'));""",
                        "package.json": '{"name":"backend","version":"1.0.0","main":"index.js","dependencies":{"express":"^4.18.0"}}'
                    }
                },
                {
                    "name": "workers",
                    "layer": "workers",
                    "files": {
                        "worker.py": """import time
import requests
import sys

def sync_products():
    try:
        response = requests.get('http://api:3200/api/v1/products')
        if response.status_code == 200:
            products = response.json()
            print(f"Synced {len(products.get('data', []))} products")
        else:
            print(f"Failed to sync products: {response.status_code}")
    except Exception as e:
        print(f"Error syncing products: {e}")

if __name__ == "__main__":
    print("Product sync worker started")
    while True:
        sync_products()
        time.sleep(30)""",
                        "requirements.txt": "requests==2.28.0"
                    }
                }
            ]
        }
    else:
        print("❌ Nie znaleziono kodu FastAPI, używam podstawowy fallback...")
        # Podstawowy fallback jeśli nie ma kodu FastAPI
        data = {
            "version": "1.0",
            "components": [
                {
                    "name": "frontend",
                    "layer": "frontend",
                    "files": {
                        "server.js": """const express = require('express');
const app = express();
app.use(express.static('public'));
app.get('/', (req, res) => res.send('<h1>Frontend Running</h1>'));
app.listen(3000, () => console.log('Frontend server running on port 3000'));""",
                        "package.json": '{"name":"frontend","version":"1.0.0","main":"server.js","dependencies":{"express":"^4.18.0"}}'
                    }
                },
                {
                    "name": "backend",
                    "layer": "backend",
                    "files": {
                        "index.js": """const express = require('express');
const app = express();
app.use(express.json());
app.get('/api/status', (req, res) => res.json({status: 'Backend running', timestamp: new Date()}));
app.listen(3100, () => console.log('Backend API running on port 3100'));""",
                        "package.json": '{"name":"backend","version":"1.0.0","main":"index.js","dependencies":{"express":"^4.18.0"}}'
                    }
                },
                {
                    "name": "api",
                    "layer": "api",
                    "files": {
                        "server.js": """const express = require('express');
const app = express();
app.get('/api/v1/info', (req, res) => res.json({version: '1.0', status: 'API Gateway running'}));
app.listen(3200, () => console.log('API Gateway running on port 3200'));""",
                        "package.json": '{"name":"api","version":"1.0.0","main":"server.js","dependencies":{"express":"^4.18.0"}}'
                    }
                },
                {
                    "name": "workers",
                    "layer": "workers",
                    "files": {
                        "worker.py": """import time
import sys

def process_task():
    print("Worker processing task...")
    time.sleep(5)
    print("Task completed")

if __name__ == "__main__":
    print("Worker started")
    while True:
        process_task()
        time.sleep(10)""",
                        "requirements.txt": "requests==2.28.0"
                    }
                }
            ]
        }
else:
    try:
        # Spróbuj sparsować JSON
        json_str = matches[0]
        data = json.loads(json_str)
    except:
        print("❌ Błąd parsowania JSON, używam fallback...")
        # Użyj fallback jak wyżej
        data = {
            "version": "1.0",
            "components": [
                {
                    "name": "frontend",
                    "layer": "frontend",
                    "files": {
                        "server.js": """const express = require('express');
const app = express();
app.use(express.static('public'));
app.get('/', (req, res) => res.send('<h1>Frontend Running</h1>'));
app.listen(3000, () => console.log('Frontend server running on port 3000'));""",
                        "package.json": '{"name":"frontend","version":"1.0.0","main":"server.js","dependencies":{"express":"^4.18.0"}}'
                    }
                },
                {
                    "name": "backend",
                    "layer": "backend",
                    "files": {
                        "index.js": """const express = require('express');
const app = express();
app.use(express.json());
app.get('/api/status', (req, res) => res.json({status: 'Backend running', timestamp: new Date()}));
app.listen(3100, () => console.log('Backend API running on port 3100'));""",
                        "package.json": '{"name":"backend","version":"1.0.0","main":"index.js","dependencies":{"express":"^4.18.0"}}'
                    }
                },
                {
                    "name": "api",
                    "layer": "api",
                    "files": {
                        "server.js": """const express = require('express');
const app = express();
app.get('/api/v1/info', (req, res) => res.json({version: '1.0', status: 'API Gateway running'}));
app.listen(3200, () => console.log('API Gateway running on port 3200'));""",
                        "package.json": '{"name":"api","version":"1.0.0","main":"server.js","dependencies":{"express":"^4.18.0"}}'
                    }
                },
                {
                    "name": "workers",
                    "layer": "workers",
                    "files": {
                        "worker.py": """import time
import sys

def process_task():
    print("Worker processing task...")
    time.sleep(5)
    print("Task completed")

if __name__ == "__main__":
    print("Worker started")
    while True:
        process_task()
        time.sleep(10)""",
                        "requirements.txt": "requests==2.28.0"
                    }
                }
            ]
        }

# Zapisz sparsowany JSON
with open(f"{iter_path}/llm_output.json", "w") as f:
    json.dump(data, f, indent=2)

def generate_dockerfile(layer_path, layer):
    dockerfile_content = ""
    entrypoint = ""
    port = 3000

    if layer in ["frontend", "backend", "api"]:
        if layer == "frontend":
            entrypoint = "server.js"
            port = 3000
            dockerfile_content = f"""FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production
COPY . .
EXPOSE {port}
CMD ["node", "{entrypoint}"]"""
        elif layer == "backend":
            entrypoint = "index.js"
            port = 3100
            dockerfile_content = f"""FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production
COPY . .
EXPOSE {port}
CMD ["node", "{entrypoint}"]"""
        else:  # api
            # Check if this is a Python API (FastAPI) or Node.js API
            layer_files = os.listdir(layer_path)
            if any(f.endswith('.py') for f in layer_files):
                # Detect python module name containing FastAPI app
                module = "server"
                if "main.py" in layer_files:
                    module = "main"
                elif "server.py" in layer_files:
                    module = "server"
                else:
                    # pick first .py file without extension
                    for f in layer_files:
                        if f.endswith('.py'):
                            module = os.path.splitext(f)[0]
                            break

                dockerfile_content = f"""FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 3200
CMD ["uvicorn", "{module}:app", "--host", "0.0.0.0", "--port", "3200"]"""
            else:
                entrypoint = "server.js"
                port = 3200
                dockerfile_content = f"""FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production
COPY . .
EXPOSE {port}
CMD ["node", "{entrypoint}"]"""

    elif layer == "workers":
        dockerfile_content = """FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "worker.py"]"""

    elif layer == "deployment":
        dockerfile_content = """FROM alpine:latest
WORKDIR /app
RUN apk add --no-cache bash curl
COPY . .
RUN chmod +x deploy.sh
CMD ["./deploy.sh"]"""

    if dockerfile_content:
        with open(os.path.join(layer_path, "Dockerfile"), "w") as f:
            f.write(dockerfile_content)
        print(f"✅ Utworzono Dockerfile dla {layer}")

# Generuj pliki dla każdego komponentu
for component in data.get("components", []):
    layer = component.get("layer", "")
    files = component.get("files", {})

    if not layer or not files:
        continue

    # Normalizacja aliasów warstw (np. FastAPI)
    if layer in ["api_fastapi", "fastapi", "py_api", "python_api"]:
        layer = "api"

    layer_path = os.path.join(iter_path, layer)
    # Upewnij się, że katalog warstwy istnieje zanim zapiszemy pliki
    os.makedirs(layer_path, exist_ok=True)

    # Czy to Pythonowe API?
    is_python_api = (layer == "api") and any(fn.endswith('.py') for fn in files.keys())

    # Zapisz wszystkie pliki z komponentu
    for filename, content in files.items():
        filepath = os.path.join(layer_path, filename)
        # Upewnij się, że podkatalogi również istnieją
        os.makedirs(os.path.dirname(filepath), exist_ok=True)

        # Normalizacja requirements.txt (zamiana przecinków/średników na nowe linie)
        if filename.lower() == "requirements.txt":
            try:
                text = str(content).replace(",", "\n").replace(";", "\n")
                # Usuń puste linie i spacje
                lines = [ln.strip() for ln in text.splitlines() if ln.strip()]
                # Jeśli to API w Pythonie, zapewnij fastapi i uvicorn
                if is_python_api:
                    have_fastapi = any(ln.lower().startswith('fastapi') for ln in lines)
                    have_uvicorn = any(ln.lower().startswith('uvicorn') for ln in lines)
                    if not have_fastapi:
                        lines.append('fastapi==0.110.0')
                    if not have_uvicorn:
                        lines.append('uvicorn==0.29.0')
                content = "\n".join(lines) + "\n"
            except Exception:
                pass

        # Sanityzacja package.json: usuń błędne zależności, zapewnij express, ustaw main
        if filename.lower() == "package.json":
            try:
                obj = None
                if isinstance(content, str):
                    obj = json.loads(content)
                elif isinstance(content, dict):
                    obj = content
                if isinstance(obj, dict):
                    deps = obj.get("dependencies", {}) or {}
                    # Usuń błędne lub problematyczne zależności
                    if "fetch" in deps:
                        deps.pop("fetch", None)
                    # Usuń wszystkie pakiety @loopback/*
                    for k in list(deps.keys()):
                        if k.startswith("@loopback/"):
                            deps.pop(k, None)
                    # Zapewnij express
                    if "express" not in deps:
                        deps["express"] = "^4.18.0"
                    obj["dependencies"] = deps
                    # Ustaw main na podstawie warstwy
                    if layer == "frontend":
                        obj["main"] = obj.get("main", "server.js")
                    elif layer == "backend":
                        obj["main"] = obj.get("main", "index.js")
                    elif layer == "api":
                        # tylko dla wariantu Node
                        obj["main"] = obj.get("main", "server.js")
                    content = json.dumps(obj, indent=2)
            except Exception:
                pass

        # Jeśli content nie jest stringiem (np. dict/list), zserializuj do JSON
        if not isinstance(content, str):
            try:
                content = json.dumps(content, indent=2)
            except Exception:
                content = str(content)

        with open(filepath, "w") as f:
            f.write(content)
        print(f"✅ Utworzono: {filepath}")

    # Generuj Dockerfile dla warstwy
    generate_dockerfile(layer_path, layer)
PYTHON
}

# ============================================
# SELF-HEALING WORKFLOW
# ============================================

run_self_healing() {
    echo "🔄 Uruchamianie self-healing workflow..."

    # Znajdź najnowszą iterację (wg numeru, format NN_*)
    local LATEST_ITER=$(ls -1 "$ITERATIONS_DIR" 2>/dev/null | grep -E '^[0-9]{2}_' | sort -V | tail -1)

    if [ -z "$LATEST_ITER" ] || [ "$LATEST_ITER" = "iterations" ]; then
        echo "❌ Brak iteracji do uruchomienia"
        echo "💡 Najpierw wygeneruj iterację: $0 generate \"opis\""
        exit 1
    fi

    echo "🎯 Uruchamianie iteracji: $LATEST_ITER"

    local ITER_COUNT=0
    local SUCCESS=false

    while [ $ITER_COUNT -lt $MAX_ITERATIONS ] && [ "$SUCCESS" = "false" ]; do
        ITER_COUNT=$((ITER_COUNT+1))
        echo "================ Próba $ITER_COUNT/$MAX_ITERATIONS ================"

        # Przygotuj zmienne błędów wcześniej
        local ERROR_LOGS=""
        local HAS_ERRORS=false

        # Sanityzacja iteracji przed budowaniem
        sanitize_iteration "$ITERATIONS_DIR/$LATEST_ITER"

        # Uruchom Docker Compose
        echo "🐳 Budowanie i uruchamianie kontenerów..."
        docker-compose down 2>/dev/null || true
        local COMPOSE_OUTPUT
        COMPOSE_OUTPUT=$(docker-compose up --build -d 2>&1)
        local COMPOSE_STATUS=$?
        if [ $COMPOSE_STATUS -ne 0 ]; then
            echo "⚠️  Błąd podczas docker-compose up (kod $COMPOSE_STATUS)"
            HAS_ERRORS=true
            ERROR_LOGS="${ERROR_LOGS}\n=== docker-compose ===\n$(echo "$COMPOSE_OUTPUT" | tail -n 100)"
        fi

        # Poczekaj na start (tylko jeśli compose w ogóle ruszył)
        echo "⏳ Czekam na uruchomienie serwisów..."
        sleep 10

        echo "🔍 Analiza stanu serwisów..."
        for container in $(docker-compose ps -q); do
            if [ -n "$container" ]; then
                local SERVICE=$(docker inspect --format '{{index .Config.Labels "com.docker.compose.service"}}' "$container")
                local STATUS=$(docker inspect --format '{{.State.Status}}' "$container")

                echo "  Serwis: $SERVICE - Status: $STATUS"

                if [ "$STATUS" != "running" ]; then
                    HAS_ERRORS=true
                    local LOGS=$(docker logs "$container" 2>&1 | tail -n 50)
                    ERROR_LOGS="${ERROR_LOGS}\n=== $SERVICE ===\n$LOGS"
                fi
            fi
        done

        # Testy E2E
        echo "🧪 Uruchamianie testów E2E..."
        if run_e2e_tests; then
            SUCCESS=true
            echo "✅ Wszystkie testy przeszły pomyślnie!"
            break
        else
            echo "❌ Testy E2E nie przeszły"
            HAS_ERRORS=true
        fi

        if [ "$HAS_ERRORS" = "true" ] && [ $ITER_COUNT -lt $MAX_ITERATIONS ]; then
            echo "🔧 Generowanie patcha..."
            generate_fix_patch "$ERROR_LOGS" "$LATEST_ITER"
            LATEST_ITER=$(ls -1 "$ITERATIONS_DIR" 2>/dev/null | grep -E '^[0-9]{2}_' | sort -V | tail -1)
        fi

        docker-compose down
    done

    if [ "$SUCCESS" = "true" ]; then
        echo "🎉 Self-healing zakończony sukcesem po $ITER_COUNT próbach!"
    else
        echo "⚠️ Self-healing zakończony po $MAX_ITERATIONS próbach bez pełnego sukcesu"
    fi
}

# Testy E2E
run_e2e_tests() {
    local ALL_PASSED=true

    # Test frontend
    if curl -s "http://localhost:3000" > /dev/null 2>&1; then
        echo "  ✅ Frontend: Dostępny"
    else
        echo "  ❌ Frontend: Niedostępny"
        ALL_PASSED=false
    fi

    # Test backend
    if curl -s "http://localhost:3100/api/status" > /dev/null 2>&1; then
        echo "  ✅ Backend: Dostępny"
    else
        echo "  ❌ Backend: Niedostępny"
        ALL_PASSED=false
    fi

    # Test API (obsługuj zarówno Node jak i FastAPI)
    if curl -s "http://localhost:3200/api/v1/info" > /dev/null 2>&1; then
        echo "  ✅ API: Dostępny (/api/v1/info)"
    elif curl -s "http://localhost:3200/api/v1/products" > /dev/null 2>&1; then
        echo "  ✅ API: Dostępny (/api/v1/products)"
    elif curl -s "http://localhost:3200/api/v1" > /dev/null 2>&1; then
        echo "  ✅ API: Dostępny (/api/v1)"
    elif curl -s "http://localhost:3200/api/health" > /dev/null 2>&1; then
        echo "  ✅ API: Dostępny (/api/health)"
    else
        echo "  ❌ API: Niedostępny"
        ALL_PASSED=false
    fi

    if [ "$ALL_PASSED" = "true" ]; then
        return 0
    else
        return 1
    fi
}

# Generowanie patcha naprawczego
generate_fix_patch() {
    local ERROR_LOGS="$1"
    local PARENT_ITER="$2"

    local ITER_NUM=$(get_next_iteration_number)
    local ITER_NAME=$(printf "%02d_fix_patch" "$ITER_NUM")
    local ITER_PATH="$ITERATIONS_DIR/$ITER_NAME"

    mkdir -p "$ITER_PATH"/{frontend,backend,api,workers,deployment}

    # Skopiuj działające komponenty z poprzedniej iteracji
    cp -r "$ITERATIONS_DIR/$PARENT_ITER"/* "$ITER_PATH/" 2>/dev/null || true

    # Generuj prompt naprawczy
    local FIX_PROMPT=$(cat << EOF
Napraw błędy w kodzie. BŁĘDY:
$ERROR_LOGS

WYMAGANIA:
1. Przeanalizuj błędy i zidentyfikuj problemy
2. Wygeneruj TYLKO poprawione pliki
3. Zachowaj strukturę: frontend/server.js, backend/index.js, api/server.js
4. Upewnij się że porty są poprawne: frontend=3000, backend=3100, api=3200

Odpowiedz w formacie JSON z polami: components (array z files).
EOF
)

    echo "$FIX_PROMPT" | ollama run mistral:7b > "$ITER_PATH/llm_output_raw.txt"
    parse_and_generate_components "$ITER_PATH"

    echo "✅ Wygenerowano patch: $ITER_NAME"
}

# ============================================
# FUNKCJE POMOCNICZE
# ============================================

get_next_iteration_number() {
    local LAST_NUM=0
    if [ -d "$ITERATIONS_DIR" ]; then
        LAST_NUM=$(ls -1 "$ITERATIONS_DIR" 2>/dev/null | grep -E '^[0-9]{2}_' | sed 's/^\([0-9]*\)_.*/\1/' | sort -n | tail -1)
    fi
    echo $((LAST_NUM + 1))
}

validate_iteration() {
    local ITER_PATH="$1"
    echo "🔍 Walidacja iteracji..."

    local VALID=true

    # Sprawdź wymagane pliki
    [ -f "$ITER_PATH/frontend/server.js" ] || { echo "  ❌ Brak frontend/server.js"; VALID=false; }
    [ -f "$ITER_PATH/backend/index.js" ] || { echo "  ❌ Brak backend/index.js"; VALID=false; }

    # API może być w Node (server.js) albo w Python (*.py + requirements.txt)
    local API_PY_EXISTS=false
    if [ -f "$ITER_PATH/api/server.js" ]; then
        : # OK, Node API
    else
        if ls "$ITER_PATH/api"/*.py >/dev/null 2>&1 && [ -f "$ITER_PATH/api/requirements.txt" ]; then
            API_PY_EXISTS=true
        else
            echo "  ❌ Brak api/server.js i brak API Python (*.py + requirements.txt)"
            VALID=false
        fi
    fi

    [ -f "$ITER_PATH/workers/worker.py" ] || { echo "  ❌ Brak workers/worker.py"; VALID=false; }

    if [ "$VALID" = "true" ]; then
        echo "  ✅ Walidacja pomyślna"
    else
        echo "  ⚠️ Walidacja wykryła braki - generowanie brakujących plików..."
        generate_missing_files "$ITER_PATH"
    fi
}

generate_missing_files() {
    local ITER_PATH="$1"

    # Generuj brakujące pliki
    if [ ! -f "$ITER_PATH/frontend/server.js" ]; then
        cat > "$ITER_PATH/frontend/server.js" << 'EOF'
const express = require('express');
const app = express();
app.get('/', (req, res) => res.send('<h1>Frontend</h1>'));
app.listen(3000, () => console.log('Frontend on port 3000'));
EOF
    fi

    if [ ! -f "$ITER_PATH/backend/index.js" ]; then
        cat > "$ITER_PATH/backend/index.js" << 'EOF'
const express = require('express');
const app = express();
app.get('/api/status', (req, res) => res.json({status: 'ok'}));
app.listen(3100, () => console.log('Backend on port 3100'));
EOF
    fi

    # Jeśli API w Pythonie istnieje, nie generuj Node API ani package.json dla api
    local API_PY_EXISTS=false
    if ls "$ITER_PATH/api"/*.py >/dev/null 2>&1 && [ -f "$ITER_PATH/api/requirements.txt" ]; then
        API_PY_EXISTS=true
    fi

    # Generuj brakujący server.js dla API tylko jeśli nie ma API w Pythonie
    if [ "$API_PY_EXISTS" != true ] && [ ! -f "$ITER_PATH/api/server.js" ]; then
        cat > "$ITER_PATH/api/server.js" << 'EOF'
const express = require('express');
const app = express();
app.get('/api/v1/info', (req, res) => res.json({version: '1.0', status: 'API Gateway running'}));
app.listen(3200, () => console.log('API Gateway on port 3200'));
EOF
    fi

    # Dodaj package.json jeśli brakuje (pomiń api gdy Python)
    for layer in frontend backend api; do
        if [ "$layer" = "api" ] && [ "$API_PY_EXISTS" = true ]; then
            continue
        fi
        if [ ! -f "$ITER_PATH/$layer/package.json" ]; then
            cat > "$ITER_PATH/$layer/package.json" << EOF
{
  "name": "$layer",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF
        fi
    done
}

sanitize_iteration() {
    local ITER_PATH="$1"
    # Sanityzuj package.json w warstwach Node (frontend, backend, api)
    python3 - "$ITER_PATH" << 'PY'
import json, os, sys, re
iter_path = sys.argv[1]
layers = ["frontend", "backend", "api"]
for layer in layers:
    pkg_path = os.path.join(iter_path, layer, "package.json")
    if not os.path.isfile(pkg_path):
        continue
    try:
        with open(pkg_path, "r") as f:
            data = json.load(f)
        deps = data.get("dependencies", {}) or {}
        # Usuń fetch i pakiety @loopback/*
        deps.pop("fetch", None)
        for k in list(deps.keys()):
            if k.startswith("@loopback/"):
                deps.pop(k, None)
        # Zapewnij express
        if "express" not in deps:
            deps["express"] = "^4.18.0"
        data["dependencies"] = deps
        # Ustaw main
        if layer == "frontend":
            data["main"] = data.get("main", "server.js")
        elif layer == "backend":
            data["main"] = data.get("main", "index.js")
        else:
            data["main"] = data.get("main", "server.js")
        with open(pkg_path, "w") as f:
            json.dump(data, f, indent=2)
        print(f"✅ Zsanityzowano {pkg_path}")
    except Exception as e:
        print(f"⚠️  Nie udało się zsanityzować {pkg_path}: {e}")
    
# Zapewnij wymagania dla Python API (FastAPI)
api_reqs = os.path.join(iter_path, 'api', 'requirements.txt')
api_dir = os.path.join(iter_path, 'api')
if os.path.isdir(api_dir) and os.path.isfile(api_reqs):
    try:
        with open(api_reqs, 'r') as f:
            lines = [ln.strip() for ln in f if ln.strip()]
        # Czy są pliki .py w API? Jeśli tak, wymuszamy uvicorn/fastapi
        is_py_api = any(fn.endswith('.py') for fn in os.listdir(api_dir))
        if is_py_api:
            have_fastapi = any(ln.lower().startswith('fastapi') for ln in lines)
            have_uvicorn = any(ln.lower().startswith('uvicorn') for ln in lines)
            if not have_fastapi:
                lines.append('fastapi==0.110.0')
            if not have_uvicorn:
                lines.append('uvicorn==0.29.0')
            with open(api_reqs, 'w') as f:
                f.write('\n'.join(lines) + '\n')
            print(f"✅ Uzupełniono wymagania FastAPI/uvicorn w {api_reqs}")
    except Exception as e:
        print(f"⚠️  Nie udało się uzupełnić {api_reqs}: {e}")
PY
}

update_registry_and_compose() {
    local ITER_PATH="$1"
    local ITER_NAME="$2"

    # Aktualizuj docker-compose.yml
    cat > "$DOCKER_COMPOSE" << EOF
services:
  frontend:
    build: $ITER_PATH/frontend
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    restart: unless-stopped

  backend:
    build: $ITER_PATH/backend
    ports:
      - "3100:3100"
    environment:
      - NODE_ENV=production
    restart: unless-stopped

  api:
    build: $ITER_PATH/api
    ports:
      - "3200:3200"
    environment:
      - NODE_ENV=production
    restart: unless-stopped

  workers:
    build: $ITER_PATH/workers
    environment:
      - PYTHONUNBUFFERED=1
    restart: unless-stopped
EOF

    echo "✅ Docker Compose zaktualizowany"
}

# ============================================
# GŁÓWNY KONTROLER
# ============================================

main() {
    local COMMAND="${1:-help}"

    case "$COMMAND" in
        init)
            init_project
            ;;
        generate|gen)
            shift
            generate_iteration "$*"
            ;;
        run)
            run_self_healing
            ;;
        validate)
            shift
            validate_iteration "$1"
            ;;
        status)
            echo "📊 Status projektu:"
            echo "  Iteracje: $(ls -1 $ITERATIONS_DIR 2>/dev/null | wc -l)"
            echo "  Ostatnia: $(ls -1 $ITERATIONS_DIR 2>/dev/null | tail -1)"
            docker-compose ps 2>/dev/null || echo "  Docker: Nie uruchomiony"
            ;;
        clean)
            echo "🧹 Czyszczenie..."
            docker-compose down 2>/dev/null || true
            rm -rf $ITERATIONS_DIR/*/node_modules
            rm -rf $ITERATIONS_DIR/*/__pycache__
            echo "✅ Wyczyszczono"
            ;;
        help|*)
            cat << EOF
🚀 YMLL v2 - Inteligentny System Refaktoryzacji

Użycie:
  $0 init                  - Inicjalizacja projektu
  $0 generate "opis"       - Generowanie nowej iteracji
  $0 run                   - Uruchomienie self-healing workflow
  $0 status               - Status projektu
  $0 validate [path]      - Walidacja iteracji
  $0 clean                - Czyszczenie projektu
  $0 help                 - Pomoc

Przykłady:
  $0 init
  $0 generate "System logowania z JWT"
  $0 run

Dokumentacja: https://github.com/yourusername/ymll
EOF
            ;;
    esac
}

# Uruchom główną funkcję
main "$@"