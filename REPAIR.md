# REPAIR_GUIDELINES.md


Naprawa kodu z pomocą LLM jest skuteczna, jeśli przebiega według powtarzalnego procesu:
**MRE → test → patch → walidacja → integracja**. 
Model kosztu i prawdopodobieństwa sukcesu pozwala decydować, 
kiedy naprawiać, a kiedy przebudować system od zera.

## Manifest: Efektywne podejście do naprawiania kodu z użyciem LLM

Ten dokument zawiera reguły, modele matematyczne oraz checklistę operacyjną, które 
pomagają zdecydować czy naprawiać istniejący kod, czy odbudować go od zera, oraz 
jak prowadzić proces „repair” w repozytorium.

---

## 1. Zmienne i modele

### Kluczowe zmienne:

* **D** – dług techniczny / złożoność problemu (0..∞).
* **T** – pokrycie testami (0..1).
* **K** – dostępny kontekst (0..1 względem potrzebnego).
* **S** – zdolności modelu LLM (0..1).
* **C_new** – koszt stworzenia nowego projektu od zera.
* **C_fix** – koszt naprawy istniejącego systemu.

### Model kosztu naprawy:

$C_{fix} = \gamma D \cdot \frac{1}{S} \cdot \frac{1}{k} \cdot (1 + \lambda (1-T))$

Decyzja:

* Jeśli $C_{fix} > C_{new}$ → **rebuild**.
* W przeciwnym razie → **repair**.

### Prawdopodobieństwo sukcesu naprawy:

$P_{fix} = \sigma(\alpha k + \beta T + \gamma' S - \delta D_{norm})$

$\sigma(x) = \frac{1}{1+e^{-x}}$.

---

## 2. Workflow naprawy

1. **Triage**

   * Zidentyfikuj symptom (bug/test/stacktrace).
   * Zmierz $D, T, K$.
   * Oblicz $C_{fix}$ i porównaj z $C_{new}$.

2. **Minimal Reproducible Example (MRE)**

   * Wydziel minimalny fragment do osobnego folderu.
   * Przygotuj `Dockerfile`/`requirements.txt`.

3. **Testy**

   * Napisz test reprodukujący błąd, jeśli nie istnieje.

4. **Iteracje z LLM**

   * Używaj prompt-template’ów (patrz sekcja 4).
   * Pracuj na wydzielonym MRE.

5. **Weryfikacja**

   * Uruchom testy CI.
   * Sprawdź regresje.

6. **Integracja**

   * Jeśli poprawka jest poprawna → merge.
   * Jeśli wymaga architektonicznej zmiany → rozważ rebuild.

---

## 3. Struktura folderów naprawy

```
/repair-{ticket-id}/
  /mre/
    src/
    tests/
    Dockerfile
    README.md
  /proposals/
    fix-1/
      patch.diff
      explanation.md
    fix-2/
  /validation/
  decision.md
```

---

## 4. Prompt-templates

### Template A — MRE + test + stacktrace

```
Masz za zadanie naprawić błąd.
Oto MRE (folder /mre). Uruchomienie: `docker build . && pytest`.
Failing test: tests/test_bug.py::test_case
Stacktrace:
<wklej stacktrace>
Środowisko: Python 3.11, dependencies: <requirements>

Zadanie:
1) Zlokalizuj przyczynę.
2) Zaproponuj patch (diff).
3) Uaktualnij testy jeśli potrzebne.
4) Wyjaśnij ryzyko regresji.
```

### Template B — brak testów, duży repo

```
Dostarczam mini-MRE: [opis] + stacktrace + lista plików.
Zadanie:
1) Zaproponuj minimalny test.
2) Utwórz plan MRE.
3) Dodaj patch i test.
```

---

## 5. Checklist (przy każdym zadaniu naprawy)

* [ ] Czy istnieje MRE?
* [ ] Czy istnieje test reprodukujący błąd?
* [ ] Obliczono $C_{fix}$ vs $C_{new}$?
* [ ] Przygotowano folder `repair-*`?
* [ ] LLM dostał MRE + testy?
* [ ] Testy przeszły w CI?
* [ ] Zrobiono code review?

---

## 6. Kryteria akceptacji

* 100% nowych testów przechodzi.
* Brak regresji w istniejących testach.
* LOC zmienione <20% pliku, jeśli brak zmian architektonicznych.
* Jeśli dotknięto >30% modułów → wymagana dodatkowa weryfikacja.

---

## 7. Antywzorce

* Zmiana bez testów.
* Wklejanie całego repo do promptu.
* Naprawa bez kontenera.
* Brak kalkulacji opłacalności.

---

## 8. Kalibracja

* Zbieraj dane historyczne z napraw.
* Dopasuj $\gamma, \lambda$ do realnych kosztów.
* Ustal próg rebuild (np. $C_{fix} > 1.5 C_{new}$).

---

## 9. Automatyzacja

* Każde `/repair-*` uruchamiaj w kontenerze.
* Pipeline: `build -> run failing test -> run smoke tests -> full suite -> static analysis`.


