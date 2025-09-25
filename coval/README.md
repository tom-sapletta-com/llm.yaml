# COVAL

![coval-logo.svg](coval-logo.svg) 

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

### 5. **Użycie CLI**

```bash
# Podstawowa naprawa
python repair.py --error error.log --source ./src

# Z testem
python repair.py --error stacktrace.txt --source ./project --test tests/test_bug.py

# Tylko analiza (bez naprawy)
python repair.py --analyze --source ./src --error error.txt

# Z wyborem modelu
python repair.py --error err.log --source ./app --model deepseek

# Z ID ticketu
python repair.py --error bug.txt --source ./code --ticket BUG-1234
```

### 6. **Inteligentne Funkcje**

- **Automatyczne wykrywanie języka/frameworka** - dostosowuje Dockerfile i proces walidacji
- **Iteracyjne poprawki** - do 5 prób z różnymi podejściami
- **Parsowanie błędów** - wyciąga pliki wymienione w stacktrace
- **Generowanie promptów** - różne szablony dla pierwszej i kolejnych prób
- **Walidacja w kontenerach** - izolowane środowisko testowe

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

