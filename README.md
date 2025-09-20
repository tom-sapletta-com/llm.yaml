# llm.yaml
manifest realizacji projektów przy użyciu LLM

## Szkic
podczas wieloletniej pracy rozwijania oprogramowania z LLM-ami doszedłem do kilku wniosków, które optymalizują czas dostarczenia oczekiwanych rezultatów:
- specyfikacja nie jest wystarczająca do tworzenia
- konieczne jest określenie wektora rozwoju, często przy refaktoryzacji dochodzi do koneicznosci określenia większej ilości tetsów i twoprzy się gó©ka zadań
- Gdy dochodzimy do tej górki zadań potrzebujemy zadecydować czy stworzyćnowy projekt od nowa z aktualna specyfikacja i okresleniem punktu wektoru oczekiwań
- każda iteracja wymaga kolejnego folderu, dlatego ż łatwiej jest coś stworzyć od nowa mając w głowie aktualne doświadczenia i niepowodzenia
- to niepowodzenia kształtują wektor określający zakres prac i kierunek rozwoju
- kolejne iteracje nie powoinny polegać na zmianie aktualnych plików, ale całej struktury, co jest nieintuicyjne dla człowieka, który z zasady chce naprawić to co nie działa, gdyż okontekśt jest ściśle określony, jednak dla LLM to zbyt duży wydatek energetyczny i muszą skupiać się na protszzych modelach, dlatego konieczny jest manifest ułatwiający radzenie sobie z konkretnymi problemami poporzez ich dzielnie na mniejsze i realziacje ich w nowych folderach



## Podsumowanie

Wnioski z pracy z LLM w projektach programistycznych

1. **Specyfikacja to dopiero początek**

   * Sama specyfikacja nie wystarczy, aby LLM generowały w pełni funkcjonalny kod.
   * Trzeba również określić **kierunek rozwoju projektu** („wektor oczekiwań”), który pozwala decydować, co jest priorytetem w kolejnych iteracjach.

2. **Refaktoryzacja generuje górkę zadań**

   * Podczas refaktoryzacji często okazuje się, że potrzeba więcej testów i dodatkowych funkcji.
   * To tworzy „górkę zadań”, którą trzeba ocenić: czy lepiej kontynuować obecny projekt, czy zacząć od nowa.

3. **Decyzja: nowy projekt vs kontynuacja**

   * Często bardziej efektywne jest rozpoczęcie nowego projektu z aktualną specyfikacją i nowym punktem startowym, niż próba naprawy istniejącego kodu.
   * Dzięki temu unikamy nagromadzenia „historycznych” błędów i nieoptymalnych struktur.

4. **Iteracje jako nowe foldery / struktury**

   * Każda iteracja powinna być traktowana jako osobny projekt, a nie poprawka w istniejących plikach.
   * Ludzki instynkt: „naprawić to, co nie działa” jest nieoptymalny dla LLM, ponieważ kontekst staje się zbyt rozbudowany.
   * Lepsze: dzielić problemy na mniejsze części i realizować je w **nowych strukturach**, minimalizując zależności od wcześniejszych iteracji.

5. **Niepowodzenia kształtują kierunek rozwoju**

   * Błędy i nieudane iteracje nie są stratą czasu – to kluczowy element wyznaczania kolejnych kroków i punktów w wektorze rozwoju.
   * Pozwalają LLM skupić się na prostszych, bardziej precyzyjnych modelach problemu.

6. **Manifest dla pracy z LLM**

   * Stworzenie dokumentu / zasad, które pomagają radzić sobie z problemami poprzez:

     * dzielenie ich na mniejsze, łatwiejsze zadania,
     * realizację ich w nowych folderach/projektach,
     * zachowanie jasnego punktu startowego i minimalizacji kontekstu z poprzednich iteracji.


## Przykłady


- manifest w formacie YAML, który LLM ma czytać i interpretować
- Każdy punkt ma **opis**, **priorytet** oraz **zalecane działania**, żeby model wiedział, co jest istotne w danej iteracji. 


### Manifest pracy z LLM – YAML

```yaml
project_manifest:
  metadata:
    project_name: "ExampleProject"
    current_iteration: 3
    vector_of_expectations: "Refaktoryzacja modułów API i uproszczenie testów"
  
  principles:
    - id: 1
      title: "Specyfikacja to dopiero początek"
      description: "Sama specyfikacja nie wystarcza. Należy wskazać wektor rozwoju i priorytety."
      priority: high
      LLM_hint: "Skup się na określeniu kierunku rozwoju projektu."
      example_use: |
        - "Określ kierunek rozwoju projektu."
        - "Zidentyfikuj funkcje i moduły kluczowe dla obecnej iteracji."

    - id: 2
      title: "Refaktoryzacja generuje górkę zadań"
      description: "Refaktoryzacja często ujawnia dodatkowe wymagania i testy."
      priority: medium
      LLM_hint: "Zidentyfikuj nowe testy potrzebne do poprawnej refaktoryzacji."
      example_use: |
        - "Zidentyfikuj nowe testy potrzebne do poprawnej refaktoryzacji."
        - "Oceń, czy warto kontynuować stary projekt, czy zacząć nowy."

    - id: 3
      title: "Nowy projekt vs kontynuacja"
      description: "Rozpoczęcie nowego projektu może być bardziej efektywne niż poprawa starego."
      priority: high
      LLM_hint: "Oceń, czy lepiej rozpocząć nowy projekt, czy kontynuować obecny."
      example_use: |
        - "Utwórz nową strukturę projektu, jeśli obecna jest zbyt złożona."
        - "Zachowaj doświadczenia z poprzednich iteracji w dokumentacji."

    - id: 4
      title: "Iteracje jako nowe foldery/projekty"
      description: "Każda iteracja powinna być osobnym projektem, unikając zmiany starych plików."
      priority: high
      LLM_hint: "Twórz nowy folder dla każdej iteracji."
      example_use: |
        - "Twórz nowy folder dla każdej iteracji."
        - "Podziel problem na mniejsze zadania realizowane w nowych strukturach."

    - id: 5
      title: "Niepowodzenia kształtują kierunek rozwoju"
      description: "Błędy i nieudane iteracje są źródłem informacji o kierunku prac."
      priority: medium
      LLM_hint: "Dokumentuj niepowodzenia i wyciągaj z nich wnioski."
      example_use: |
        - "Dokumentuj niepowodzenia i wyciągaj z nich wnioski."
        - "Uaktualniaj wektor oczekiwań na podstawie doświadczeń."

    - id: 6
      title: "Manifest jako przewodnik LLM"
      description: "Zasady manifestu pomagają LLM w efektywnej realizacji zadań."
      priority: high
      LLM_hint: "Dziel problemy na mniejsze, łatwiejsze do wykonania zadania."
      example_use: |
        - "Dziel problemy na mniejsze, łatwiejsze do wykonania zadania."
        - "Realizuj zadania w nowych folderach, aby minimalizować kontekst z poprzednich iteracji."

```



### Przykład użycia YAML przez LLM

Załóżmy, że LLM dostaje zadanie: **Refaktoryzacja modułu API w iteracji 3**.

1. Model odczytuje manifest i widzi:

   * `current_iteration: 3`
   * `vector_of_expectations: Refaktoryzacja modułów API i uproszczenie testów`
   * Priorytetowe zasady: `Specyfikacja to dopiero początek`, `Iteracje jako nowe foldery`, `Nowy projekt vs kontynuacja`.

2. Model może zaplanować działania:

```yaml
iteration_plan:
  iteration: 3
  actions:
    - "Utwórz nowy folder dla iteracji 3."
    - "Zidentyfikuj kluczowe moduły API wymagające refaktoryzacji."
    - "Dodaj brakujące testy dla modułów API."
    - "Dokumentuj wszelkie problemy i niepowodzenia."
    - "Na podstawie doświadczeń z poprzednich iteracji zaktualizuj wektor oczekiwań."
```

3. Efekt: LLM działa zgodnie z manifestem, unika nadmiernego kontekstu z poprzednich iteracji i skupia się na priorytetach.



## Ollama + manifest llm yaml

jak rozpocząć pracę z Ollama i manifestami YAML, aby efektywnie zarządzać iteracjami w projektach programistycznych?

---

## 🧰 Krok 1: Instalacja Ollama

### Na systemie Linux:

1. **Pobierz i zainstaluj Ollama:**

   ```bash
   curl -fsSL https://ollama.com/install.sh | sh
   ```

2. **Sprawdź, czy instalacja się powiodła:**

   ```bash
   ollama --version
   ```

   Jeśli zobaczysz wersję Ollama, oznacza to, że instalacja przebiegła pomyślnie.


3. **Zainicjuj serwer Ollama:**

   ```bash
   ollama serve
   ```

4. **Przekaż manifest jako prompt do Ollama:**

   ```bash
   ollama chat --prompt "$(cat manifest.yaml)"
   ```

   Ollama odczyta manifest i na jego podstawie wygeneruje plan iteracji lub działania w oparciu o zawarte zasady.






Rozumiem, chcesz w pełni **zautomatyzować przepływ informacji**: LLM dostaje wyniki testów, lintów i innych narzędzi, łączy je z manifestem YAML i generuje plan działań w jednej, spójnej iteracji. Mogę to rozbić na kroki i pokazać sposób, jak to zrobić praktycznie – np. w shellu lub Pythonie.

---

## 🔹 Koncepcja automatyzacji

1. **Zbierz wszystkie wyniki narzędzi** w formacie tekstowym lub JSON:

   * `pytest --json-report` → raport JSON z testów
   * `eslint -f json` → raport JSON dla JS/TS
   * `flake8 --format=json` → raport JSON dla Pythona
2. **Połącz te raporty** w jedną strukturę, np. JSON z błędami i metadanymi.
3. **Przekaż ten JSON + manifest YAML** do LLM jako prompt.
4. LLM analizuje:

   * błędy / niepowodzenia
   * priorytety z manifestu (`LLM_hint`, `priority`)
   * wektor rozwoju i aktualną iterację
5. LLM generuje **plan naprawy**, np. w YAML lub JSON gotowy do automatycznej realizacji.

---

## 🔹 Przykład w jednej linii (bash + Ollama)

Zakładając, że masz:

* `manifest.yaml`
* `test_report.json` (wyniki testów, lintów itd.)

```bash
ollama chat --prompt "$(echo "Manifest YAML:"; cat manifest.yaml; echo; echo "Błędy i raporty:"; cat test_report.json; echo; echo "Na podstawie manifestu i raportów, wygeneruj plan naprawy w YAML.")"
```

* `$(echo ...)` – scala manifest i raport w jedną wiadomość.
* LLM otrzymuje kontekst manifestu i konkretnych błędów, więc może wygenerować **plan iteracji i naprawy**.

---

## 🔹 Przykład w Pythonie 

```python
import json
from pathlib import Path
from ollama import Chat

# Wczytaj manifest i raport
manifest = Path("manifest.yaml").read_text()
report = Path("test_report.json").read_text()

prompt = f"""
Manifest YAML:
{manifest}

Błędy i raporty:
{report}

Na podstawie manifestu i raportów, wygeneruj plan naprawy w YAML.
"""

# Wywołanie Ollama
response = Chat("your_model_name").send(prompt)
print(response.text)
```

Efekt: LLM wygeneruje **iteracyjny plan działań**, uwzględniający priorytety i zalecenia z manifestu oraz konkretne problemy wykryte przez narzędzia.


[![Terminal GPT: Użyj ChatGPT w terminalu Linux bez kluczy API](https://tse2.mm.bing.net/th/id/OIP.a-367W9ib2ZqDIpy5cRxQAHaEK?pid=Api)](https://pl.ubunlog.com/terminal-gpt-tgpt/?utm_source=chatgpt.com)



## Projekt

1. Zbiera raporty z testów i lintów.
2. Scala je z manifestem YAML.
3. Wysyła do Ollama jako prompt.
4. Zapisuje wynikowy plan naprawy w YAML.

---

### 🔹 Struktura projektu

```
project/
├── manifest.yaml
├── run_tests.sh
├── collect_reports.py
├── generate_plan.py
└── reports/
    ├── test_report.json
    └── lint_report.json
```

---

### 🔹 1️⃣ Skrypt do uruchamiania testów i lintów (`run_tests.sh`)

```bash
#!/bin/bash
mkdir -p reports

# Uruchom testy Pythona i zapisz JSON
pytest --json-report --json-report-file=reports/test_report.json

# Uruchom linter Pythona i zapisz JSON
flake8 --format=json > reports/lint_report.json || true

echo "Raporty zapisane w folderze reports/"
```

> `|| true` zabezpiecza przed przerwaniem skryptu przy błędach lint.

---

### 🔹 2️⃣ Skrypt do łączenia raportów (`collect_reports.py`)

```python
import json
from pathlib import Path

# Wczytaj raporty
test_report = json.loads(Path("reports/test_report.json").read_text())
lint_report = json.loads(Path("reports/lint_report.json").read_text())

# Połącz w jeden obiekt
combined_report = {
    "test_report": test_report,
    "lint_report": lint_report
}

# Zapisz do pliku JSON
Path("reports/combined_report.json").write_text(json.dumps(combined_report, indent=2))
print("Połączony raport zapisany jako reports/combined_report.json")
```

---

### 🔹 3️⃣ Skrypt do generowania planu naprawy (`generate_plan.py`)

```python
from pathlib import Path
from ollama import Chat

# Wczytaj manifest i raport
manifest = Path("manifest.yaml").read_text()
combined_report = Path("reports/combined_report.json").read_text()

prompt = f"""
Manifest YAML:
{manifest}

Błędy i raporty:
{combined_report}

Na podstawie manifestu i raportów, wygeneruj plan naprawy w YAML.
"""

# Wywołanie Ollama
response = Chat("your_model_name").send(prompt)

# Zapisz wynikowy plan
Path("reports/repair_plan.yaml").write_text(response.text)
print("Plan naprawy zapisany jako reports/repair_plan.yaml")
```

---

### 🔹 4️⃣ Wersja “w jednej linii” (bash)

Po zainstalowaniu Ollama i Pythonowego klienta:

```bash
bash run_tests.sh && python collect_reports.py && python generate_plan.py
```

* Uruchamia testy i linty.
* Łączy raporty.
* Wysyła wszystko do Ollama.
* Zapisuje wynikowy plan naprawy w `reports/repair_plan.yaml`.

---

### 🔹 🔹 Dodatkowe usprawnienia

1. Filtracja tylko krytycznych błędów do promptu, aby nie przeciążać LLM.
2. Automatyczne generowanie nazwy folderu nowej iteracji w planie.
3. Możliwość integracji w CI/CD: GitHub Actions, GitLab CI, Jenkins.









## 🧰 Najlepsze narzędzia AI do pracy w terminalu

### 1. **AIChat**

* **Opis**: Wszechstronne narzędzie CLI integrujące różne modele LLM, takie jak OpenAI, Claude, Gemini, Ollama i inne. Umożliwia interakcję z systemem plików, generowanie poleceń shellowych oraz korzystanie z agentów AI.

* **Instalacja**:

  ```bash
  cargo install aichat
  ```

* **Użycie**:

  ```bash
  aichat -e "Na podstawie wyników testów i manifestu YAML, wygeneruj plan iteracji w YAML."
  ```

* **Zalety**: Obsługuje wiele modeli LLM, oferuje integrację z systemem plików i umożliwia tworzenie agentów AI.

### 2. **ShellGPT**

* **Opis**: Narzędzie CLI umożliwiające zadawanie pytań i generowanie poleceń shellowych za pomocą LLM. Obsługuje Linux, macOS i Windows z Bash, Zsh, PowerShell itp.

* **Instalacja**:

  ```bash
  npm install -g @thekitze/shellgpt
  ```

* **Użycie**:

  ```bash
  sgpt "Na podstawie wyników testów i manifestu YAML, wygeneruj plan iteracji w YAML."
  ```

* **Zalety**: Prosta integracja z terminalem, wsparcie dla wielu systemów operacyjnych.

### 3. **Lazyshell**

* **Opis**: Narzędzie CLI generujące polecenia shellowe z naturalnego języka za pomocą AI.

* **Instalacja**:

  ```bash
  cargo install lazyshell
  ```

* **Użycie**:

  ```bash
  lazyshell "Na podstawie wyników testów i manifestu YAML, wygeneruj plan iteracji w YAML."
  ```

* **Zalety**: Umożliwia generowanie poleceń shellowych z naturalnego języka, co ułatwia automatyzację zadań.

### 4. **Butterfish**

* **Opis**: Narzędzie CLI umożliwiające zadawanie pytań dotyczących historii poleceń shellowych, generowanie i autouzupełnianie poleceń shellowych oraz interakcję z GPT.

* **Instalacja**:

  ```bash
  cargo install butterfish
  ```

* **Użycie**:

  ```bash
  butterfish "Na podstawie wyników testów i manifestu YAML, wygeneruj plan iteracji w YAML."
  ```

* **Zalety**: Integracja z historią poleceń shellowych, wsparcie dla autouzupełniania poleceń.

### 5. **Warp**

* **Opis**: Nowoczesny emulator terminala z wbudowaną sztuczną inteligencją, oferujący sugestie poleceń i generowanie kodu.

* **Instalacja**:

  ```bash
  curl -fsSL https://warp.dev/install.sh | sh
  ```

* **Użycie**:

  ```bash
  warp "Na podstawie wyników testów i manifestu YAML, wygeneruj plan iteracji w YAML."
  ```

* **Zalety**: Zaawansowane funkcje AI, integracja z terminalem, wsparcie dla współpracy zespołowej.

---

## 🔧 Przykłady zastosowania z manifestem YAML

Załóżmy, że masz manifest YAML o następującej treści:

```yaml
project_manifest:
  metadata:
    project_name: "ExampleProject"
    current_iteration: 3
    vector_of_expectations: "Refaktoryzacja modułów API i uproszczenie testów"
  
  principles:
    - id: 1
      title: "Specyfikacja to dopiero początek"
      description: "Sama specyfikacja nie wystarcza. Należy wskazać wektor rozwoju i priorytety."
      priority: high
      LLM_hint: "Skup się na określeniu kierunku rozwoju projektu."
      example_use: |
        - "Określ kierunek rozwoju projektu."
        - "Zidentyfikuj funkcje i moduły kluczowe dla obecnej iteracji."
```

### 🛠️ Integracja z wynikami testów

Po uruchomieniu testów i zapisaniu wyników w pliku `test_report.json`, możesz połączyć je z manifestem YAML i przekazać do narzędzia AI:

```bash
cat manifest.yaml test_report.json | aichat -e "Na podstawie manifestu i wyników testów, wygeneruj plan iteracji w YAML."
```

### 📂 Automatyczne tworzenie struktury folderów

Na podstawie wygenerowanego planu iteracji, możesz automatycznie tworzyć odpowiednią strukturę folderów:

```bash
mkdir -p $(cat plan.yaml | grep 'folder_name' | awk '{print $2}')
```

---

## 📚 Inne przydatne narzędzia AI CLI

* **ShellGPT**: Narzędzie CLI umożliwiające zadawanie pytań i generowanie poleceń shellowych za pomocą LLM.

* **Lazyshell**: Narzędzie CLI generujące polecenia shellowe z naturalnego języka za pomocą AI.

* **Butterfish**: Narzędzie CLI umożliwiające zadawanie pytań dotyczących historii poleceń shellowych, generowanie i autouzupełnianie poleceń shellowych oraz interakcję z GPT.

* **Warp**: Nowoczesny emulator terminala z wbudowaną sztuczną inteligencją, oferujący sugestie poleceń i generowanie kodu.

* **AI Shell Agent**: Asystent AI działający w terminalu, umożliwiający interakcję z systemem plików i wykonywanie poleceń shellowych.

* **Raconteur**: Narzędzie LLM do wyjaśniania poleceń shellowych, oferujące zrozumiałe wyjaśnienia i kontekstowe informacje.

* **JELAI**: Platforma integrująca AI i analizę uczenia w notatnikach Jupyter, wspierająca interakcję z kodem i analizę danych.

* **ChatCoT**: Framework do rozumowania z wykorzystaniem narzędzi w modelach opartych na czacie, wspierający rozwiązywanie złożonych zadań.

## 📚 Dodatkowe zasoby

* [Ollama Tutorial: Running LLMs Locally Made Super Simple](https://www.kdnuggets.com/ollama-tutorial-running-llms-locally-made-super-simple)
* [Getting started with Ollama for Python](https://github.com/RamiKrispin/ollama-poc)
* [Step-by-Step Guide: Running LLM Models with Ollama](https://dev.to/snehalkadwe/how-to-setup-ollma-and-llm-4601)

