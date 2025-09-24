Pliki, iteracje, registry, testy i Docker Compose współpracują w modelu iteracyjnym.

---

## 1. Struktura główna projektu

```
GenerycznyApp/
├── iterations/                  # Folder z iteracjami
│   ├── iter_001_login/
│   │   ├── frontend/
│   │   │   └── login.js
│   │   ├── backend/
│   │   │   └── login_api.js
│   │   ├── workers/
│   │   │   └── login_worker.py
│   │   ├── api/
│   │   │   └── login_endpoint.js
│   │   └── deployment/
│   │       └── deploy.sh
│   │   └── llm_output.json     # surowy wynik Ollama
│   ├── iter_002_patch/
│   │   └── ...
│   └── iter_003_patch/
│       └── ...
├── registry.yaml                # globalna baza komponentów i ścieżek
├── test.yaml                    # scenariusze testowe wszystkich iteracji
├── docker-compose.yml           # dynamicznie aktualizowany plik Compose
├── gen.sh
└── run.sh
```

---

## 2. Przepływ iteracji (workflow)

1. **Użytkownik podaje opis funkcjonalności**:

   ```
   ./gen.sh "Dodaj widok profilu użytkownika z walidacją API"
   ```

2. **Generacja pierwszej iteracji**

   * Skrypt `gen.sh` tworzy folder iteracji `iter_001_...`
   * Tworzy pliki komponentów w odpowiednich warstwach (`frontend`, `backend`, `workers`, `api`, `deployment`)
   * Tworzy/aktualizuje `registry.yaml` i `test.yaml`
   * Aktualizuje `docker-compose.yml` z serwisami dla nowych komponentów

3. **Uruchomienie projektu**
   
   * Skrypt `run.sh` uruchamia `docker-compose up --build -d`
   * Wszystkie warstwy są izolowane w odpowiednich kontenerach z volume mapping do iteracji

4. **Analiza logów i testów**

   * Skrypt pobiera ostatnie linie logów z kontenerów
   * Sprawdza testy w `test.yaml`
   * Błędy i wyjątki są wyciągane i przetwarzane

5. **Generowanie patcha przez LLM**

   * Prompt przekazuje: logi błędów, pliki wymagające poprawy, poprzednią iterację
   * LLM generuje tylko poprawione pliki i zapisuje w nowej iteracji (`iter_002_patch`)
   * `registry.yaml`, `test.yaml` i Docker Compose są aktualizowane

6. **Ponowne uruchomienie i walidacja**

   * Proces powtarza się, aż brak błędów w logach i testach lub osiągnięto limit iteracji

---

## 3. Zasady self-healing workflow

* **Każda iteracja jest nowym folderem** – zachowuje historię, umożliwia rollback.
* **Granularne poprawki** – tylko pliki wymagające poprawek są modyfikowane przez LLM.
* **Centralny registry.yaml** – śledzi wszystkie komponenty, warstwy i ścieżki do plików.
* **test.yaml** – minimalne scenariusze testowe dla wszystkich iteracji; LLM może aktualizować je przy patchach.
* **Docker Compose** – każda iteracja może dopisywać serwisy i volumes do kontenerów, łatwa izolacja.
* **Prompt LLM zawiera kontekst** – logi błędów, testy, poprzednia iteracja, struktura folderów.

---

## 4. Korzyści architektury

* **Izolacja iteracji** – łatwe debugowanie i analiza historyczna.
* **Automatyczna walidacja i naprawa** – self-healing workflow redukuje ręczne poprawki.
* **Granularność poprawek** – LLM modyfikuje tylko błędne pliki, reszta pozostaje nienaruszona.
* **Dynamiczna aktualizacja infrastruktury** – Docker Compose i registry są zawsze aktualne.
* **Łatwość integracji nowych warstw** – frontend/backend/workers/api/deployment w jednym spójnym modelu.


