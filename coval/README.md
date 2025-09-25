# COVAL v2.0 - Intelligent Code Repair System

![coval-logo.svg](coval-logo.svg) 

![COVAL](https://img.shields.io/badge/COVAL-v2.0-blue.svg)
![Python](https://img.shields.io/badge/Python-3.11+-green.svg)
![Ollama](https://img.shields.io/badge/Ollama-Required-orange.svg)
![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen.svg)

## 🎉 **Nowe Funkcje v2.0**

### ✅ **6 Modeli LLM z Auto-pobieraniem**
- **qwen2.5-coder:7b** - Najlepszy do napraw JSON i debugowania (95% dynamicznej zdolności)
- **deepseek-r1:7b** - Nowy model z reasoning capabilities (88% zdolności) 
- **codellama:13b** - Duży kontekst 32k tokenów do złożonych napraw (75% zdolności)
- **deepseek-coder:6.7b** - Specjalizowany w analizie kodu (80% zdolności)
- **granite-code:8b** - Stabilny model enterprise (70% zdolności)
- **mistral:7b** - Uniwersalny fallback model (60% zdolności)

### 🧠 **Dynamiczne Obliczanie Zdolności Modelu**
System nie używa już statycznych wartości 85% - teraz kalkuluje zdolność modelu dynamicznie:
- **Token bonus**: +0.01% za każdy token ponad 8192 
- **Temperature penalty**: -20% * temperatura (optymalna 0.2)
- **Context bonus**: +0.01% za każdy token kontekstu ponad 8192
- **Historical bonus**: +10% * wskaźnik historycznego sukcesu
- **Rezultat**: Model qwen osiąga teraz 95% vs poprzednie 85%!

### 📊 **Adaptacyjna Ocena z Uczeniem Się**
- **8 kategorii problemów**: import_error, syntax_error, docker_error, type_error, runtime_error, dependency_error, config_error, other
- **Historyczne tracking**: `repairs/repair_history.json` śledzi sukces/porażkę per kategoria
- **Decay factor 0.9**: Nowsze naprawy mają większą wagę w ocenie zdolności
- **Intelligent triage**: Lepsza analiza decyzyjna repair vs rebuild

### ⚙️ **Konfiguracja YAML (`llm.config.yaml`)**
Każdy model ma optymalne predefiniowane ustawienia:
```yaml
models:
  qwen2.5-coder:
    max_tokens: 16384      # Zwiększone z 8192
    temperature: 0.2       # Optymalna dla napraw
    context_window: 32768  # Duży kontekst
    base_capability: 0.85  # Baza dla dynamicznej kalkulacji
```

### 🔄 **Automatyczne Pobieranie Modeli**
System automatycznie sprawdza dostępność modelu via `ollama list` i pobiera brakujące:
```bash
🔍 Sprawdzam dostępność modelu: deepseek-r1:7b
📥 Pobieram model: deepseek-r1:7b
✅ Pomyślnie pobrano model: deepseek-r1:7b
```

## Kluczowe funkcjonalności:

### 1. **Model Decyzyjny Repair vs Rebuild**
- Implementuje matematyczny model kosztu naprawy: `C_fix = γD * (1/S) * (1/K) * (1 + λ(1-T))`
- Oblicza prawdopodobieństwo sukcesu używając **funkcji logitowej**
- Automatycznie decyduje czy naprawiać czy przebudować

### 2. **Workflow Naprawy (MRE → Test → Patch → Walidacja)**
- **Triage**: Analiza problemu i zbieranie metryk
- **MRE**: Tworzenie Minimal Reproducible Example
- **Generowanie**: Używa LLM do tworzenia poprawek
- **Walidacja**: Automatyczne testy w Docker
- **Integracja**: Finalizacja i raportowanie

### 3. **Metryki i Analiza**
- Dług techniczny (złożoność, duplikacja, brak dokumentacji)
- Pokrycie testami
- Dostępny kontekst (stacktrace, testy, dokumentacja)
- Zdolności modelu LLM

### 4. **Struktura Folderów**
```
/repairs/
  /repair-{ticket-id}/
    /mre/           # Minimal Reproducible Example
    /proposals/     # Propozycje napraw
    /validation/    # Wyniki walidacji
    decision.md     # Decyzja repair vs rebuild
    repair_report.md # Raport końcowy
```

### 5. **Użycie CLI v2.0**

#### **Dostępne Modele:**
```bash
--model qwen         # qwen2.5-coder:7b (domyślny, 95% zdolności)
--model deepseek     # deepseek-coder:6.7b (80% zdolności)
--model codellama13b # codellama:13b (75% zdolności, duży kontekst)
--model deepseek-r1  # deepseek-r1:7b (88% zdolności, reasoning)
--model granite      # granite-code:8b (70% zdolności, enterprise)
--model mistral      # mistral:7b (60% zdolności, fallback)
```

#### **Przykłady Użycia:**

```bash
# Podstawowa naprawa z najlepszym modelem
python3 repair.py --error error.log --source ./src

# Analiza z pokazaniem dynamicznych zdolności modelu
python3 repair.py --analyze --source ./src --error error.txt --model qwen

# Użyj zaawansowanego modelu z reasoning do złożonych błędów
python3 repair.py --error complex_bug.log --source ./app --model deepseek-r1

# Duży kontekst dla złożonych projektów
python3 repair.py --error error.txt --source ./large_project --model codellama13b

# Z testem i verbose logging
python3 repair.py --error stacktrace.txt --source ./project \
  --test tests/test_bug.py --model qwen --verbose

# Enterprise-grade model dla produkcji
python3 repair.py --error prod_error.log --source ./enterprise_app \
  --model granite --ticket PROD-1234

# Tylko analiza z porównaniem modeli
python3 repair.py --analyze --source ./src --error bug.txt --model deepseek-r1
python3 repair.py --analyze --source ./src --error bug.txt --model codellama13b
```

#### **Przykład Wyjścia z v2.0:**
```bash
$ python3 repair.py --analyze --source ./app --error error.log --model qwen

🔍 Sprawdzam dostępność modelu: qwen2.5-coder:7b
✅ Model qwen2.5-coder:7b jest dostępny
🤖 Użyto modelu: qwen2.5-coder:7b
⚙️  Konfiguracja: 16384 tokenów, temp: 0.2
📊 Tryb analizy (bez naprawy)

============================================================
📊 ANALIZA DECYZYJNA v2.0
============================================================
Rekomendacja: REBUILD
Prawdopodobieństwo sukcesu: 65.63%
Koszt naprawy: 1052.63 ↓ (niższy dzięki lepszej zdolności!)
Koszt przebudowy: 10.18

Metryki:
  - Dług techniczny: 2.00
  - Pokrycie testami: 0.00%
  - Dostępny kontekst: 0.00%
  - Zdolności modelu: 95.00% ↑ (dynamiczne!)
  - Historyczna skuteczność: 0.00% (nowy system)
  - Kategoria problemu: import_error
  - Model użyty: qwen2.5-coder:7b
  - Parametry: 16384 tokenów, temp: 0.2
============================================================
```

### 6. **Inteligentne Funkcje v2.0**

- **Automatyczne pobieranie modeli** - System sprawdza `ollama list` i pobiera brakujące modele
- **Dynamiczne obliczanie zdolności** - Uwzględnia tokeny, temperaturę, kontekst i historię
- **Adaptacyjne uczenie się** - 8 kategorii problemów z historical tracking
- **Automatyczne wykrywanie języka/frameworka** - dostosowuje Dockerfile i proces walidacji
- **Iteracyjne poprawki** - do 5 prób z różnymi podejściami i konfiguracją z YAML
- **Parsowanie błędów** - wyciąga pliki wymienione w stacktrace
- **Generowanie promptów** - różne szablony dla pierwszej i kolejnych prób
- **Walidacja w kontenerach** - izolowane środowisko testowe
- **Konfigurowalne parametry** - Wszystkie ustawienia modeli w `llm.config.yaml`

## 📦 **Instalacja i Wymagania v2.0**

### **Wymagania Systemowe:**
```bash
# Podstawowe wymagania
Python 3.11+
Docker & Docker Compose
Ollama (automatyczne pobieranie modeli)

# Python dependencies
pip install pyyaml requests docker subprocess32
```

### **Instalacja Ollama:**
```bash
# Linux/macOS
curl -fsSL https://ollama.com/install.sh | sh

# Windows
# Pobierz z https://ollama.com/download

# Uruchom ollama
ollama serve
```

### **Konfiguracja COVAL:**
```bash
# Klonuj repozytorium
git clone https://github.com/twój-repo/ymll.git
cd ymll/coval

# System automatycznie pobierze modele przy pierwszym użyciu
python3 repair.py --analyze --source ./test --error ./test.log --model qwen

# Sprawdź dostępne modele
ollama list
```

## 🔧 **Troubleshooting**

### **Problemy z Ollama:**
```bash
# Ollama nie jest zainstalowane
❌ Ollama nie jest zainstalowane lub nie jest w PATH
✅ Rozwiązanie: curl -fsSL https://ollama.com/install.sh | sh

# Model nie może być pobrany
❌ Błąd pobierania modelu: connection refused
✅ Rozwiązanie: Uruchom ollama serve w osobnym terminalu

# Timeout pobierania
⏱️ Timeout przy pobieraniu modelu: deepseek-r1:7b
✅ Rozwiązanie: Zwiększ timeout lub pobierz ręcznie: ollama pull deepseek-r1:7b
```

### **Problemy z Konfiguracją:**
```bash
# Brak llm.config.yaml
❌ Nie można załadować konfiguracji
✅ Rozwiązanie: Skopiuj llm.config.yaml z repozytorium

# Nieprawidłowa konfiguracja YAML
❌ yaml.parser.ParserError
✅ Rozwiązanie: Sprawdź składnię YAML online (yamllint.com)

# Brak uprawnień do zapisu repair_history.json
❌ Permission denied: repairs/repair_history.json
✅ Rozwiązanie: mkdir -p repairs && chmod 755 repairs
```

### **Problemy z Modelami:**
```bash
# Model nie odpowiada
❌ Model timeout po 60s
✅ Rozwiązanie: Użyj mniejszego modelu (--model mistral) lub zwiększ timeout

# Niewystarczająca pamięć
❌ CUDA out of memory
✅ Rozwiązanie: Użyj CPU: CUDA_VISIBLE_DEVICES="" python3 repair.py

# Model daje złe wyniki
❌ Repair failed repeatedly
✅ Rozwiązanie: Spróbuj innego modelu z większymi zdolnościami (--model deepseek-r1)
```

## 📈 **Porównanie Wydajności v1.0 vs v2.0**

### **Analiza tego samego problemu (import_error):**

| Metryka | v1.0 (Static) | v2.0 (Dynamic) | Poprawa |
|---------|---------------|----------------|---------|
| **Zdolność modelu** | 85.00% (static) | 95.00% (dynamic) | **+10%** ↑ |
| **Prawdopodobieństwo sukcesu** | 64.04% | 65.63% | **+1.59%** ↑ |
| **Koszt naprawy** | 1176.47 | 1052.63 | **-123.84** ↓ |
| **Dostępne modele** | 1 (qwen) | 6 modeli | **+500%** ↑ |
| **Konfigurowalność** | Brak | YAML config | **Nowa funkcja** |
| **Uczenie się** | Brak | Historical tracking | **Nowa funkcja** |
| **Auto-pobieranie** | Ręczne | Automatyczne | **Nowa funkcja** |

### **Kluczowe Ulepszenia:**

#### 🎯 **Lepsza Analiza Decyzyjna**
- **Dynamiczne zdolności**: System uwzględnia rzeczywiste parametry modelu
- **Kategoryzacja problemów**: 8 typów błędów vs generyczne podejście  
- **Historyczne uczenie**: System poprawia się z każdą naprawą
- **Niższe koszty**: Lepsze zdolności = mniejszy koszt naprawy

#### 🤖 **Szerszy Wybór Modeli**
```
v1.0: Tylko qwen2.5-coder (85% static capability)
v2.0: 6 modeli z dynamicznymi zdolnościami:
├─ qwen2.5-coder:7b    → 95% (najlepszy do JSON/debugowania)
├─ deepseek-r1:7b      → 88% (reasoning capabilities)  
├─ deepseek-coder:6.7b → 80% (kod specjalizowany)
├─ codellama:13b       → 75% (duży kontekst 32k)
├─ granite-code:8b     → 70% (enterprise grade)
└─ mistral:7b          → 60% (fallback uniwersalny)
```

#### ⚙️ **Łatwiejsza Konfiguracja**
```
v1.0: Twarde kodowanie parametrów w kodzie
v2.0: Centralna konfiguracja YAML:
├─ Optymalne ustawienia per model
├─ Konfigurowalne timeouty  
├─ Adaptacyjne parametry uczenia
└─ Łatwa customizacja bez edycji kodu
```

## ⚙️ **Szczegółowa Konfiguracja `llm.config.yaml`**

### **Pełna Struktura Pliku:**
```yaml
# Globalne ustawienia systemu
global:
  timeout: 60
  max_iterations: 5
  adaptive_evaluation:
    enabled: true
    history_weight: 0.3
    decay_factor: 0.9
    min_samples: 5
  capability_calculation:
    token_bonus_multiplier: 0.0001    # +0.01% za token ponad 8192
    temperature_penalty: 0.2          # -20% * temperatura
    context_bonus_multiplier: 0.0001  # +0.01% za token kontekstu ponad 8192
    max_capability: 0.95              # Maksymalna zdolność (95%)

# Konfiguracje poszczególnych modeli
models:
  # Model domyślny - najlepszy do napraw JSON
  qwen2.5-coder:
    model_name: "qwen2.5-coder:7b"
    max_tokens: 16384           # 2x więcej niż standard
    temperature: 0.2            # Optymalna dla napraw
    retry_attempts: 3
    base_capability: 0.85       # Baza dla dynamicznej kalkulacji
    context_window: 32768       # Duży kontekst
    specialization: ["json", "debugging", "python", "javascript"]
    
  # Nowy model z reasoning - do złożonych problemów
  deepseek-r1:
    model_name: "deepseek-r1:7b"
    max_tokens: 12288
    temperature: 0.1            # Niska dla reasoning
    retry_attempts: 4
    base_capability: 0.80
    context_window: 16384
    specialization: ["reasoning", "complex_logic", "algorithms"]
    
  # Duży model - do większych projektów
  codellama:
    model_name: "codellama:13b"
    max_tokens: 8192
    temperature: 0.3
    retry_attempts: 2
    base_capability: 0.70
    context_window: 32768       # Największy kontekst
    specialization: ["large_codebases", "refactoring", "architecture"]
```

### **Customizacja dla Własnych Potrzeb:**

#### **Zwiększ Zdolności Modelu:**
```yaml
models:
  custom-qwen:
    base_capability: 0.90      # ↑ Wyższa baza
    max_tokens: 32768          # ↑ Więcej tokenów = bonus
    temperature: 0.1           # ↓ Niższa temperatura = mniej penalty
    context_window: 65536      # ↑ Większy kontekst = bonus
```

#### **Dostosuj dla Środowiska Produkcyjnego:**
```yaml
global:
  timeout: 120                 # ↑ Więcej czasu dla złożonych napraw
  max_iterations: 10           # ↑ Więcej prób
  adaptive_evaluation:
    history_weight: 0.5        # ↑ Większa waga dla historii
    min_samples: 10            # ↑ Więcej danych do oceny
```

#### **Optymalizacja dla Szybkości:**
```yaml
models:
  fast-mistral:
    max_tokens: 4096           # ↓ Mniej tokenów = szybciej
    temperature: 0.4           # ↑ Wyższa = mniej precyzyjne ale szybsze
    retry_attempts: 1          # ↓ Mniej prób
```

### 7. **Raporty i Decyzje**

System generuje szczegółowe raporty zawierające:
- Analizę kosztów (repair vs rebuild)
- Prawdopodobieństwo sukcesu
- Zastosowane poprawki
- Ocenę ryzyka regresji
- Rekomendacje dalszych kroków

### 8. **Wsparcie dla wielu języków**

Automatycznie rozpoznaje i obsługuje:
- Python (FastAPI, Django, Flask)
- JavaScript/Node.js (Express, Next.js)
- Go (Gin, Fiber)
- Rust, Java, Ruby, PHP

Skrypt jest w pełni zintegrowany z podejściem YMLL i implementuje wszystkie najlepsze praktyki z REPAIR_GUIDELINES, zapewniając efektywny i powtarzalny proces naprawiania kodu z pomocą LLM.

## Funkcja logitowa

Funkcja **logitowa** to po prostu funkcja matematyczna używana głównie w statystyce i uczeniu maszynowym do przekształcania prawdopodobieństw w tzw. log-odds. Jest odwrotnością funkcji sigmoidalnej (logistycznej).

Dokładniej:

### Definicja

Jeżeli $p$ to prawdopodobieństwo zdarzenia (0 < p < 1), funkcja logitowa jest zdefiniowana jako:

$$
\text{logit}(p) = \ln\left(\frac{p}{1-p}\right)
$$

* $p/(1-p)$ to **odds** (szansa, że zdarzenie nastąpi vs że nie nastąpi)
* $\ln$ to logarytm naturalny

### Przykład

* Jeśli $p = 0.8$ (80% prawdopodobieństwa),

$$
\text{logit}(0.8) = \ln\left(\frac{0.8}{0.2}\right) = \ln(4) \approx 1.386
$$

* Jeśli $p = 0.5$, $\text{logit}(0.5) = \ln(1) = 0$

### Zastosowanie

* W **regresji logistycznej** logit przekształca prawdopodobieństwa w wartość na osi liczbowej od $-\infty$ do $+\infty$, co pozwala modelowi liniowemu prognozować log-odds, a następnie łatwo przekształcać z powrotem w prawdopodobieństwo.
* W twoim kontekście (system naprawy kodu) funkcja logitowa może służyć do obliczenia **prawdopodobieństwa sukcesu naprawy** na podstawie różnych zmiennych (jak złożoność, dostępność testów itd.).

