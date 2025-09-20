Wygeneruj ponzisze pliki i przetestuj

dodaj plik Makefile z funkcjami jak install, publish, test, run, itd
wygeneruj testy, prztetsuj i opublikuj,
zaktualizuj dokumentacje

**developer wskazuje tylko manifest**, a cały workflow – analiza błędów, generowanie promptu, wywołanie `chatai`, tworzenie nowej iteracji, aktualizacja mapy i archiwizacja – odbywa się automatycznie.

## Zalety tego rozwiązania

* Developer **wskazuje tylko manifest** – resztę wykonuje automatycznie skrypt `ymll`.
* **Automatyczne generowanie promptu dla `chatai`** uwzględnia manifest i wyniki narzędzi testowych.
* **Tworzenie nowej iteracji i manifestu** w pełni automatyczne.
* **Archiwizacja starych iteracji** utrzymuje porządek w projekcie.
* **Aktualizacja mapy iteracji** pozwala śledzić historię i zależności między iteracjami.


## Struktura projektu

Kompletny workflow: manifest → analiza → prompt → chatai → nowa iteracja → aktualizacja mapy → archiwizacja

```
ymll/
├── src/
├── tests/
├── common/
├── manifest.yaml           # wskazany przez developera
├── iterations_map.yaml     # aktualna mapa iteracji
├── archive/                # stare iteracje
├── ymll/                   # skrypty automatyzujące
│   ├── run_analysis.py
│   ├── update_iterations.py
│   └── validate_manifest.py
└── prompt_for_chatai.txt    # wygenerowany automatycznie
```


## Workflow: manifest → analiza → prompt → chatai → nowa iteracja → mapa → archiwizacja

```
+----------------------+
|  Developer wskazuje  |
|   manifest.yaml      |
+---------+------------+
          |
          v
+---------------------------+
|  Skrypt ymll/run_analysis |
|  - Wczytuje manifest      |
|  - Uruchamia testy i lint |
|    (pytest, flake8, mypy) |
|  - Timeout dla narzędzi   |
|  - Zbiera wyniki analizy  |
+------------+--------------+
             |
             v
+-----------------------------+
|  Generowanie promptu dla    |
|  chatai                     |
|  - Uwzględnia manifest      |
|  - Uwzględnia wyniki testów |
|  - Tworzy kompletny kontekst|
+------------+----------------+
             |
             v
+-----------------------------+
|  Wywołanie chatai           |
|  - chatai run --prompt-file |
|    prompt_for_chatai.txt    |
|  - LLM generuje plan        |
|    kolejnej iteracji,       |
|    sugestie napraw          |
+------------+----------------+
             |
             v
+-----------------------------+
|  Tworzenie nowej iteracji   |
|  - Folder zgodny z wzorcem  |
|  - Kopiowanie common/       |
|  - Tworzenie manifestu      |
|    nowej iteracji           |
+------------+----------------+
             |
             v
+-----------------------------------+
|  Aktualizacja iterations_map.yaml |
|  - Dodanie nowej iteracji         |
|  - Archiwizacja starych iteracji  |
+------------+----------------------+
             |
             v
+---------------------------+
|  Gotowe do uruchomienia   |
|  kolejnej iteracji        |
+---------------------------+
```


## Kluczowe punkty diagramu

1. **Minimalna praca developera** – wskazanie jedynie `manifest.yaml`.
2. **Automatyczna analiza błędów** – `ymll/run_analysis.py` uruchamia narzędzia, zbiera wyniki, generuje prompt.
3. **Generowanie promptu dla `chatai`** – pełen kontekst: manifest + raporty testów.
4. **Tworzenie nowej iteracji** – nowy folder, manifest, kopiowanie wspólnych funkcji.
5. **Aktualizacja mapy iteracji i archiwizacja** – porządek w projekcie, zachowanie historii.

## Pliki

### Manifest YAML (`manifest.yaml`)

```yaml
project_manifest:
  project_name: "ExampleProject"
  description: "Projekt rozwijany iteracyjnie z LLM i automatyzacją"
  vector_of_expectations: "Uproszczenie kodu, automatyzacja testów, izolacja funkcjonalności"

iteration_template:
  folder_pattern: "iteration_{number}_{feature}_{version}"
  manifest_template:
    iteration_number: 3
    feature_name: "FeatureX"
    version: 1
    stable: false
    parent_iteration: "iteration_2_FeatureX_v1"
    notes: "Poprawa błędów i refaktoryzacja funkcji"
  next_iteration_rules:
    increment_version: true
    new_feature: false
    fork_sub_iteration_if_experimental: true

structure_guidelines:
  common_libraries:
    folder: "common"
    description: "Funkcje współdzielone"
  tests:
    folder: "tests"
    description: "Testy wspólne i specyficzne dla iteracji"
  rules:
    avoid_duplicate_code: true
    archive_old_iterations: true
    version_files_instead_of_folders: true
    lmm_generate_next_iteration: true

analysis_tools:
  - name: "pytest"
    path: "tests/"
    timeout: 30
  - name: "flake8"
    path: "src/"
    timeout: 10
  - name: "mypy"
    path: "src/"
    timeout: 10
```


Dodajemy pola do **automatycznej analizy błędów i narzędzi**, które mają być użyte:


W `analysis_tools` deklarujemy:

* Narzędzia do analizy (testy, lint, typy),
* Ścieżki, które mają sprawdzać,
* Timeout dla każdej analizy (chroni przed zawieszeniem skryptu).



## JSON Schema do walidacji manifestu

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Project Manifest Schema",
  "type": "object",
  "required": ["project_manifest", "iteration_template", "structure_guidelines"],
  "properties": {
    "project_manifest": {
      "type": "object",
      "required": ["project_name", "description", "vector_of_expectations"],
      "properties": {
        "project_name": {"type": "string"},
        "description": {"type": "string"},
        "vector_of_expectations": {"type": "string"}
      }
    },
    "iteration_template": {
      "type": "object",
      "required": ["folder_pattern", "manifest_template", "next_iteration_rules"],
      "properties": {
        "folder_pattern": {"type": "string"},
        "manifest_template": {
          "type": "object",
          "required": ["iteration_number", "feature_name", "version", "stable", "parent_iteration", "notes"],
          "properties": {
            "iteration_number": {"type": "string"},
            "feature_name": {"type": "string"},
            "version": {"type": "string"},
            "stable": {"type": "boolean"},
            "parent_iteration": {"type": "string"},
            "notes": {"type": "string"}
          }
        },
        "next_iteration_rules": {
          "type": "object",
          "properties": {
            "increment_version": {"type": "boolean"},
            "new_feature": {"type": "boolean"},
            "fork_sub_iteration_if_experimental": {"type": "boolean"}
          },
          "additionalProperties": false
        }
      }
    },
    "structure_guidelines": {
      "type": "object",
      "required": ["common_libraries", "tests", "rules"],
      "properties": {
        "common_libraries": {
          "type": "object",
          "required": ["folder", "description"],
          "properties": {
            "folder": {"type": "string"},
            "description": {"type": "string"}
          }
        },
        "tests": {
          "type": "object",
          "required": ["folder", "description"],
          "properties": {
            "folder": {"type": "string"},
            "description": {"type": "string"}
          }
        },
        "rules": {
          "type": "object",
          "required": ["avoid_duplicate_code", "archive_old_iterations", "version_files_instead_of_folders", "lmm_generate_next_iteration"],
          "properties": {
            "avoid_duplicate_code": {"type": "boolean"},
            "archive_old_iterations": {"type": "boolean"},
            "version_files_instead_of_folders": {"type": "boolean"},
            "lmm_generate_next_iteration": {"type": "boolean"}
          },
          "additionalProperties": false
        }
      },
      "additionalProperties": false
    }
  },
  "additionalProperties": false
}
```




## Jak użyć schematu do walidacji

### Python (przykład):

```python
import yaml
import jsonschema

# Wczytaj manifest YAML
with open("manifest.yaml", "r") as f:
    manifest = yaml.safe_load(f)

# Wczytaj schemat JSON
with open("manifest_schema.json", "r") as f:
    schema = json.load(f)

# Walidacja
try:
    jsonschema.validate(instance=manifest, schema=schema)
    print("Manifest jest poprawny!")
except jsonschema.exceptions.ValidationError as e:
    print("Błąd w manifeście:", e)
```



### Skrypt `ymll/run_analysis.py`

```python
import yaml
import subprocess
import shlex
from pathlib import Path
import os
import datetime

# 1. Wczytanie manifestu
manifest_file = "manifest.yaml"
with open(manifest_file, "r") as f:
    manifest = yaml.safe_load(f)

tools = manifest.get("analysis_tools", [])
results = []

# 2. Uruchomienie narzędzi z timeout i zebranie wyników
for tool in tools:
    cmd = f"{tool['name']} {tool['path']}"
    try:
        completed = subprocess.run(shlex.split(cmd), capture_output=True, text=True, timeout=tool.get("timeout", 30))
        results.append({
            "tool": tool['name'],
            "returncode": completed.returncode,
            "output": completed.stdout + "\n" + completed.stderr
        })
    except subprocess.TimeoutExpired:
        results.append({
            "tool": tool['name'],
            "returncode": -1,
            "output": "TIMEOUT"
        })

# 3. Generowanie promptu dla chatai
prompt_lines = [
    f"Analizuj projekt {manifest['project_manifest']['project_name']}",
    f"Vector of expectations: {manifest['project_manifest']['vector_of_expectations']}",
    f"Iteracja: {manifest['iteration_template']['manifest_template']['iteration_number']}",
    f"Feature: {manifest['iteration_template']['manifest_template']['feature_name']}",
    f"Folder: {manifest['iteration_template']['folder_pattern']}",
    "\nAnaliza wyników narzędzi:"
]

for r in results:
    prompt_lines.append(f"\nTool: {r['tool']}\nReturn code: {r['returncode']}\nOutput:\n{r['output']}")

prompt_lines.append("\nNa podstawie powyższych informacji wygeneruj plan kolejnej iteracji oraz sugestie napraw.")

prompt_text = "\n".join(prompt_lines)
Path("prompt_for_chatai.txt").write_text(prompt_text)
print("Prompt dla chatai został wygenerowany w pliku prompt_for_chatai.txt")

# 4. Tworzenie nowej iteracji
new_iter_number = manifest['iteration_template']['manifest_template']['iteration_number'] + 1
feature = manifest['iteration_template']['manifest_template']['feature_name']
folder_name = f"iteration_{new_iter_number}_{feature}_v1"
Path(folder_name).mkdir(exist_ok=True)

# Kopiowanie wspólnych funkcji
os.system(f"cp -r common {folder_name}/")

# Tworzenie manifestu nowej iteracji
new_manifest = dict(manifest)
new_manifest['iteration_template']['manifest_template']['iteration_number'] = new_iter_number
new_manifest['iteration_template']['manifest_template']['parent_iteration'] = manifest['iteration_template']['folder_pattern']
Path(folder_name + "/manifest.yaml").write_text(yaml.dump(new_manifest))
print(f"Nowa iteracja utworzona w folderze {folder_name}")
```


### Skrypt `ymll/update_iterations.py`

```python
import yaml
from pathlib import Path
import shutil
import datetime

# Wczytanie mapy iteracji
map_file = "iterations_map.yaml"
if Path(map_file).exists():
    with open(map_file) as f:
        iterations_map = yaml.safe_load(f)
else:
    iterations_map = []

# Dane nowej iteracji
new_folder = "iteration_4_FeatureX_v1"
new_iteration = {
    "iteration": 4,
    "folder": new_folder,
    "stable": False,
    "parent_iteration": "iteration_3_FeatureX_v1",
    "notes": "Automatycznie wygenerowana iteracja po analizie testów"
}

# Dodanie nowej iteracji
iterations_map.append(new_iteration)

# Archiwizacja starych iteracji
archive_dir = Path("archive")
archive_dir.mkdir(exist_ok=True)
for old_iter in iterations_map[:-1]:
    old_folder = Path(old_iter['folder'])
    if old_folder.exists():
        timestamp = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
        shutil.move(str(old_folder), str(archive_dir / f"{old_folder.name}_{timestamp}"))

# Zapis zaktualizowanej mapy iteracji
with open(map_file, "w") as f:
    yaml.dump(iterations_map, f)

print("Mapa iteracji została zaktualizowana i stare iteracje zostały zarchiwizowane.")
```

## Shell workflow (end-to-end)

1. **Uruchomienie analizy i wygenerowanie promptu dla `chatai`:**

```bash
python ymll/run_analysis.py
```

* Skrypt uruchamia testy (`pytest`), linty (`flake8`), typy (`mypy`) z timeoutami.
* Zbiera wyniki i generuje prompt dla `chatai` w pliku `prompt_for_chatai.txt`.


2. **Uruchomienie `chatai` z wygenerowanym promptem:**

```bash
chatai run --prompt-file prompt_for_chatai.txt
```

* `chatai` generuje plan kolejnej iteracji i rekomendacje napraw.
* LLM nie musi znać struktury projektu ani narzędzi – wszystko jest w prompt.


3. **Aktualizacja mapy iteracji i archiwizacja starych iteracji:**

```bash
python ymll/update_iterations.py
```

* Folder według schematu: `iteration_{number}_{feature}_v{version}`.
* Kopiowanie wspólnych funkcji z `common/`.
* Tworzenie nowego manifestu iteracji na podstawie szablonu w `manifest.yaml`.
* `iterations_map.yaml` zostaje zaktualizowane o nową iterację.
* Stare iteracje przenoszone są do `archive/` z timestampem.
* Zachowujemy pełną historię projektu bez zaśmiecania głównej struktury.



## LLM

katalog projektu z gotowymi skryptami instalacyjnymi i uruchomieniowymi dla wszystkich narzędzi CLI, tak aby działały niezależnie od dystrybucji Linuxa. Zrobimy to z użyciem **uniwersalnych poleceń** (`curl`, `pip`, `npm`, `xdg-open`) i sprawdzaniem systemu, aby `xdg-open` działało też na macOS (`open`).

Oto projektowa struktura katalogu:

```
llm/
├─ aichat/
│  ├─ setup.sh
│  └─ run.sh
├─ gemini/
│  ├─ setup.sh
│  └─ run.sh
├─ ollama/
│  ├─ setup.sh
│  └─ run.sh
├─ aider/
│  ├─ setup.sh
│  └─ run.sh
├─ lms/
│  ├─ setup.sh
│  └─ run.sh
└─ README.md
```

---

## 1️⃣ aichat/setup.sh

```bash
#!/bin/bash
# Instalacja AIChat w systemach Linux/macOS

echo "Instalacja AIChat..."

# Instalacja pip, jeśli nie istnieje
if ! command -v pip &> /dev/null; then
    echo "pip nie znaleziony, instalacja..."
    if [ -f /etc/debian_version ]; then
        sudo apt update && sudo apt install -y python3-pip
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y python3-pip
    else
        echo "Nieznana dystrybucja, zainstaluj pip ręcznie."
        exit 1
    fi
fi

pip install --user aichat

echo "AIChat zainstalowany."
```

## aichat/run.sh

```bash
#!/bin/bash
# Uruchomienie AIChat w katalogu projektu i otwarcie pliku w przeglądarce

if [ "$(uname)" == "Darwin" ]; then
    BROWSER_CMD="open"
else
    BROWSER_CMD="xdg-open"
fi

echo "Uruchamianie AIChat..."
aichat

# Przykład otwarcia pliku HTML
$aichat -e "$BROWSER_CMD index.html"
```

---

## 2️⃣ gemini/setup.sh

```bash
#!/bin/bash
echo "Instalacja Gemini CLI..."

if ! command -v brew &> /dev/null; then
    echo "Homebrew nie zainstalowany. Instalacja..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install gemini

echo "Gemini CLI zainstalowany."
```

## gemini/run.sh

```bash
#!/bin/bash
if [ "$(uname)" == "Darwin" ]; then
    BROWSER_CMD="open"
else
    BROWSER_CMD="xdg-open"
fi

gemini
gemini "!$BROWSER_CMD docs/index.html"
```

---

## 3️⃣ ollama/setup.sh

```bash
#!/bin/bash
echo "Instalacja Ollama..."

curl https://ollama.com/install.sh | bash
ollama --version
echo "Ollama zainstalowana."
```

## ollama/run.sh

```bash
#!/bin/bash
if [ "$(uname)" == "Darwin" ]; then
    BROWSER_CMD="open"
else
    BROWSER_CMD="xdg-open"
fi

ollama run llama3:8b
ollama run llama3:8b "!$BROWSER_CMD build/index.html"
```

---

## 4️⃣ aider/setup.sh

```bash
#!/bin/bash
echo "Instalacja aider..."

if ! command -v npm &> /dev/null; then
    echo "npm nie znaleziony, instalacja Node.js..."
    if [ -f /etc/debian_version ]; then
        sudo apt update && sudo apt install -y nodejs npm
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y nodejs npm
    else
        echo "Nieznana dystrybucja, zainstaluj Node.js ręcznie."
        exit 1
    fi
fi

npm install -g aider
echo "aider zainstalowany."
```

## aider/run.sh

```bash
#!/bin/bash
if [ "$(uname)" == "Darwin" ]; then
    BROWSER_CMD="open"
else
    BROWSER_CMD="xdg-open"
fi

aider review
aider shell "!$BROWSER_CMD index.html"
```

---

## 5️⃣ lms/setup.sh

```bash
#!/bin/bash
echo "Instalacja LM Studio CLI..."
curl -fsSL https://lmstudio.ai/install.sh | bash
lms --version
echo "LM Studio CLI zainstalowany."
```

## lms/run.sh

```bash
#!/bin/bash
if [ "$(uname)" == "Darwin" ]; then
    BROWSER_CMD="open"
else
    BROWSER_CMD="xdg-open"
fi

lms exec "$BROWSER_CMD report.html"
```

---

### 🔹 Uwagi końcowe

* Wszystkie skrypty są **wielodystrosystemowe Linux/macOS** dzięki sprawdzeniu `uname` i `xdg-open`/`open`.
* Po sklonowaniu projektu nadaj uprawnienia wykonywalne:

```bash
chmod +x */setup.sh */run.sh
```

* Instalacja i uruchomienie każdego narzędzia:

```bash
./aichat/setup.sh
./aichat/run.sh
```




## Użycie z LLM w shell

przykład, ale nie dosłowny, w praktyce może wygladać inaczej, zależnie od narzędiza, implementacji yaml i lms: Po wygenerowaniu promptu przez `ymll`, LLM wykonuje prompt:

```bash
ymll run --manifest manifest.yaml -o prompt_from_ymll.txt
lms run --manifest-file prompt_from_ymll.txt
```

* **Developer nie uruchamia testów ręcznie**, nie analizuje błędów – wszystko robi `ymll`.
* `chatai` tylko otrzymuje gotowy, kompletny prompt i generuje rekomendacje lub kod dla kolejnej iteracji.

---

## Zalety tego podejścia

1. **Pełna automatyzacja** – developer wskazuje tylko plik manifestu.
2. **Bezpieczne uruchamianie narzędzi** – timeout w manifestach chroni przed zawieszeniem.
3. **Łatwe rozszerzanie** – dodajesz nowe narzędzie do manifestu, `ymll` obsłuży je automatycznie.
4. **Standaryzacja promptów** – LLM zawsze otrzymuje spójny, kompletny kontekst.
5. **Integracja z iteracyjnym workflow** – manifest, mapa iteracji i raporty testów są podstawą dla kolejnych iteracji.


