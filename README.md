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
- przykładowo zamiast naprawiać to co nie działa w aktualnej wersji mamy do wyboru:
  - stworzenie od nowa tego co już jest z poszerzonym promptem lub
  - stworzenie kolejnego komponentu, który będzie korzystał z tego, tkóry aktualnie nie działa i LLM z kontekstu użycia będzie się starał dopasować stary kod peirwszego komponentu aby zaczął poorawnie funkcjonować lub napisze/nadpoisze nowy komponent




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







# v2 Iteracyjne tworzenie projektów z LLM i manifestem YAML



## Lista obaw programisty

1. **Zbyt wiele folderów iteracji**

   * Iteracje główne, sub-iteracje funkcjonalności, eksperymenty, poprawki.
   * Trudność w odnalezieniu właściwej wersji.

2. **Duplikacja kodu**

   * Każda iteracja tworzy nowe foldery i nowe pliki.
   * Powtarzanie funkcji, które działały wcześniej.

3. **Nieefektywna refaktoryzacja**

   * Kolejne iteracje wymagają zmian w wielu miejscach.
   * Trudność w ocenie, czy rozpocząć nowy folder czy kontynuować stary.

4. **Zarządzanie testami i wynikami**

   * Każda iteracja ma własne testy, raporty i linty.
   * Trudność w porównywaniu wyników między iteracjami.

5. **Historia zmian**

   * Trudno śledzić, które iteracje były stabilne, a które nie.
   * Łączenie wiedzy między wersjami funkcjonalności.

6. **Łączenie funkcjonalności**

   * Jedna funkcjonalność może mieć wiele sub-iteracji.
   * Trudność w integracji stabilnych fragmentów w kolejne wersje.

7. **Zarządzanie manifestem**

   * Utrzymanie aktualnego manifestu w wielu iteracjach.
   * Powiązanie z poprzednimi iteracjami (`parent_iteration`).

8. **Automatyzacja workflow**

   * Pobieranie wyników testów/lintów i generowanie planów działań przez LLM.
   * Minimalizacja błędów manualnych.

9. **Archiwizacja starych iteracji**

   * Jak zachować historię, a jednocześnie utrzymać porządek.
   * Kompresja i ewentualne usuwanie niepotrzebnych folderów.

10. **Kontekst LLM**

    * LLM ma ograniczoną pamięć kontekstu.
    * Jak uniknąć przeciążenia modelem przy wielu folderach i dużych projektach.







## Cel

Celem jest stworzenie **systemu iteracyjnego rozwoju oprogramowania**, który umożliwia:

* Tworzenie kolejnych wersji funkcjonalności w uporządkowany sposób.
* Automatyzację testów, lintów i planowania działań przez LLM.
* Minimalizację duplikacji kodu i chaosu w strukturze folderów.
* Utrzymanie historii i archiwizację starych iteracji.

---

## Kluczowe zasady

1. **Manifest YAML** jest centralnym punktem kontroli:

   * Opisuje każdą iterację lub funkcjonalność.
   * Zawiera informacje o `parent_iteration`, `version`, `vector_of_expectations` i notatki.
   * Może definiować **generyczny schemat tworzenia kolejnych iteracji**.

2. **Izolacja iteracji i funkcjonalności**:

   * Każda iteracja może być folderem, modułem lub artefaktem (mikro-usługa, kontener, FaaS).
   * Wspólne funkcje umieszczamy w `common/`.

3. **Automatyzacja**:

   * Skrypty zbierają raporty testów/lintów, integrują je z manifestem i przekazują do LLM.
   * LLM generuje plan kolejnej iteracji, strukturę folderów i manifest.

4. **Porządek i archiwizacja**:

   * Starsze iteracje kompresujemy lub przenosimy do `archive/`.
   * Można wersjonować pliki zamiast tworzyć nowe foldery dla drobnych zmian.

5. **Minimalizacja duplikacji**:

   * Dziedziczenie funkcji z `common/`.
   * Manifesty i LLM sugerują, które funkcje można odziedziczyć, zamiast kopiować.

---

## Obawy użytkownika i rozwiązania

| Obawa                         | Rozwiązanie praktyczne                                                                   |
| ----------------------------- | ---------------------------------------------------------------------------------------- |
| Zbyt wiele folderów           | Scal stabilne iteracje, wersjonowanie plików, archiwizacja eksperymentalnych iteracji.   |
| Duplikacja kodu               | `common/` dla funkcji współdzielonych, LLM sugeruje odziedziczenie.                      |
| Nieefektywna refaktoryzacja   | Automatyzacja z LLM, manifest pokazuje zależności między iteracjami.                     |
| Zarządzanie testami           | Wspólne testy w `tests/common`, specyficzne w iteracji. CI/CD automatyzuje uruchomienie. |
| Historia zmian                | Git + manifest + iterations\_map.yaml → łatwa kontrola kolejnych iteracji.               |
| Łączenie funkcjonalności      | Manifesty i sub-iteracje pokazują zależności i powiązania.                               |
| Zarządzanie manifestem        | Manifest centralizuje metadane iteracji i schemat generowania kolejnych.                 |
| Automatyzacja workflow        | Skrypty zbierają dane, LLM generuje plan, manifest i strukturę folderów.                 |
| Archiwizacja starych iteracji | Kompresja, `archive/`, Git, Git LFS dla dużych plików.                                   |
| Kontekst LLM                  | Manifest i podział na moduły/funkcje umożliwia analizę w ograniczonym kontekście.        |

---

## Struktura projektu (przykład)

```
ExampleProject/
├── featureX_stable/
│   ├── api_module_v3.py
│   └── tests/
├── featureY_stable/
│   ├── api_module_v2.py
│   └── tests/
├── common/
│   └── utils.py
├── iterations_map.yaml
├── manifest.yaml
└── archive/
    ├── featureX/
    │   ├── iteration_1_failed/
    │   └── iteration_2_partial/
    └── featureY/
        └── iteration_1/
```

## manifest YAML (generyczny schemat iteracji)

```yaml
project_manifest:
  project_name: "ExampleProject"
  description: "Generyczny schemat iteracyjnego rozwoju projektu z LLM"
  vector_of_expectations: "Uproszczenie kodu, automatyzacja testów, izolacja funkcjonalności"

iteration_template:
  folder_pattern: "iteration_{number}_{feature}_{version}"
  manifest_template:
    iteration_number: "{number}"
    feature_name: "{feature}"
    version: "{version}"
    stable: false
    parent_iteration: "{parent_iteration}"
    notes: "{notes}"
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
```

## 2️⃣ JSON Schema do walidacji manifestu

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

---

## Korzyści

* Automatyczna walidacja manifestu przed użyciem przez LLM lub skrypty.
* Zapobieganie błędom w polach manifestu i strukturze folderów.
* Łatwe rozszerzenie schematu o dodatkowe reguły lub typy iteracji.
* LLM może generować nową iterację i od razu sprawdzić poprawność YAML.



## Workflow przykładowej iteracji

1. Uruchomienie testów i lintów dla aktualnej iteracji:

```bash
bash run_tests.sh
```

2. Połączenie raportów z manifestem:

```bash
python collect_reports.py
```

3. LLM generuje plan kolejnej iteracji:

```bash
python generate_plan.py
```

4. Tworzenie nowego folderu/artefaktu zgodnie z manifestem szablonowym.
5. Dodanie nowej iteracji do `iterations_map.yaml`.
6. Archiwizacja starych eksperymentalnych iteracji.

---

## 7 Korzyści

* Porządek w wielu iteracjach i funkcjonalnościach.
* Automatyzacja planowania kolejnych iteracji z LLM.
* Minimalizacja duplikacji kodu.
* Historia i audyt iteracji.
* Łatwe testowanie i deployment dzięki modularnej strukturze i artefaktom.



# v3 Rozszerzony manifest YAML

Dodajemy pola do **automatycznej analizy błędów i narzędzi**, które mają być użyte:

```yaml
project_manifest:
  project_name: "ExampleProject"
  description: "Projekt rozwijany iteracyjnie z LLM i automatyzacją analizy błędów"
  vector_of_expectations: "Uproszczenie kodu, automatyzacja testów, izolacja funkcjonalności"

iteration_template:
  folder_pattern: "iteration_{number}_{feature}_{version}"
  manifest_template:
    iteration_number: "{number}"
    feature_name: "{feature}"
    version: "{version}"
    stable: false
    parent_iteration: "{parent_iteration}"
    notes: "{notes}"
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

W `analysis_tools` deklarujemy:

* Narzędzia do analizy (testy, lint, typy),
* Ścieżki, które mają sprawdzać,
* Timeout dla każdej analizy (chroni przed zawieszeniem skryptu).

---

## Przykładowy skrypt Python (`ymll`)

Skrypt automatycznie:

1. Wczytuje manifest YAML.
2. Uruchamia narzędzia wskazane w `analysis_tools`.
3. Zbiera wyniki (raporty błędów).
4. Generuje **prompt dla LLM (`chatai`)** bazując na manifestie i raportach.
5. Wywołuje LLM tylko z gotowym promptem.

```python
import yaml
import subprocess
import json
import shlex

# 1. Wczytanie manifestu
manifest_file = "manifest.yaml"  # developer wskazuje tylko ten plik
with open(manifest_file, "r") as f:
    manifest = yaml.safe_load(f)

tools = manifest.get("analysis_tools", [])

# 2. Uruchomienie narzędzi z timeout i zebranie wyników
results = []
for tool in tools:
    cmd = f"{tool['name']} {tool['path']}"
    try:
        completed = subprocess.run(shlex.split(cmd), capture_output=True, text=True, timeout=tool.get("timeout", 30))
        results.append({
            "tool": tool['name'],
            "output": completed.stdout + "\n" + completed.stderr,
            "returncode": completed.returncode
        })
    except subprocess.TimeoutExpired:
        results.append({
            "tool": tool['name'],
            "output": "TIMEOUT",
            "returncode": -1
        })

# 3. Generowanie promptu dla LLM na podstawie manifestu i raportów
prompt = f"""
Analizuj projekt {manifest['project_manifest']['project_name']}.

Vector of expectations: {manifest['project_manifest']['vector_of_expectations']}

Iteracja: {manifest['iteration_template']['manifest_template']['iteration_number']}
Feature: {manifest['iteration_template']['manifest_template']['feature_name']}
Folder: {manifest['iteration_template']['folder_pattern']}

Analiza wyników narzędzi:
"""

for r in results:
    prompt += f"\nTool: {r['tool']}\nReturn code: {r['returncode']}\nOutput:\n{r['output']}\n"

prompt += "\nNa podstawie powyższych informacji wygeneruj plan kolejnej iteracji oraz sugestie napraw."

# 4. Zapis promptu do pliku
with open("prompt_for_chatai.txt", "w") as f:
    f.write(prompt)

print("Prompt dla chatai został wygenerowany w pliku prompt_for_chatai.txt")
```

---

## Użycie z LLM w shell

Po wygenerowaniu promptu przez `ymll`, LLM wykonuje prompt:

```bash
chatai run --prompt-file prompt_from_ymll.txt
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




# v4 

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
ExampleProject/
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


