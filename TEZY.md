## 1. Tezy i konsekwencje

### Teza 1:

*„Modele LLM są lepsze w generowaniu od zera niż w naprawianiu istniejącego kodu.”*

* **Konsekwencja**: lepiej projektować workflow, w którym LLM tworzy nową strukturę zamiast ingerować w istniejącą.
* **Weryfikacja**:

  * Możemy to modelować jako **prawdopodobieństwo sukcesu**:

    * $P_{gen}$ – prawdopodobieństwo poprawnej generacji od zera
    * $P_{fix}$ – prawdopodobieństwo poprawnej naprawy istniejącego kodu
  * Hipoteza: $P_{gen} > P_{fix}$.
  * Badania benchmarkowe (np. HumanEval) faktycznie wskazują, że LLM radzi sobie lepiej w pełnym „solve” niż w lokalnej naprawie przy braku kontekstu.
* **Ocena prawdy**: ✅ zgodne z rzeczywistością.

---

### Teza 2:

*„Specyfikacja nie wystarcza do zbudowania działającej usługi – potrzeba kontekstu (środowisko, stack, testy).”*

* **Konsekwencja**: samo „napisz API do X” nie da działającego produktu – trzeba podać stack, wersje bibliotek, runtime.
* **Model matematyczny**:

  * Jakość outputu = $Q = f(S, C, T)$
  * gdzie $S$ = specyfikacja, $C$ = kontekst środowiskowy, $T$ = testy.
  * Jeśli $C = 0$ albo $T = 0$, to $Q \ll Q_{max}$.
* **Ocena prawdy**: ✅ potwierdzone praktyką inżynierską.

---

### Teza 3:

*„Refaktoryzacja prowadzi do narastania górki zadań (więcej testów, więcej zależności).”*

* **Konsekwencja**: iteracje wprowadzają koszt dodatkowy zamiast zmniejszać go liniowo.
* **Model matematyczny**:

  * Niech koszt pracy po $n$ iteracjach =

    $$
    C(n) = C_0 + \alpha n + \beta n^2
    $$
  * gdzie $\beta > 0$ reprezentuje kumulację długu technicznego.
* **Ocena prawdy**: ✅ zgodne z doświadczeniem – im więcej iteracji, tym większa złożoność, a nie liniowy wzrost.

---

### Teza 4:

*„Często taniej stworzyć nowy projekt od zera niż naprawiać istniejący.”*

* **Konsekwencja**: workflow z LLM powinien premiować *nowe foldery* i *czyste generacje*.
* **Model matematyczny**:

  * Porównujemy koszty:

    * Naprawa: $C_{fix} = \gamma \cdot D$ (gdzie $D$ = poziom długu technicznego).
    * Nowy projekt: $C_{new} = \delta$.
  * Teza zakłada: $C_{fix} > C_{new}$ gdy $D$ przekroczy pewien próg $D_{crit}$.
* **Ocena prawdy**: ✅ realistyczne – w wielu przypadkach refaktoryzacja starego monolitu kosztuje więcej niż greenfield.

---

### Teza 5:

*„LLM działa w ramach kontekstu, dlatego lepiej pracuje z frameworkami i DSL niż z gołym kodem.”*

* **Konsekwencja**: projektując prompt, lepiej użyć np. React niż czystego JS.
* **Model matematyczny**:

  * Rozmiar kontekstu $K$ jest ograniczony (np. 128k tokenów).
  * Frameworki i DSL kompresują semantykę:

    * Długość opisu w DSL = $L_{DSL}$
    * Długość opisu w low-level = $L_{LL}$
    * zwykle $L_{DSL} \ll L_{LL}$.
  * Wtedy stosunek efektywności:

    $$
    E = \frac{K}{L}
    $$

    → większe $E$ dla frameworków.
* **Ocena prawdy**: ✅ logiczne i potwierdzane praktyką.

---

## 2. Podsumowanie ogólne

* Wszystkie tezy są **spójne i zgodne z rzeczywistością**.
* Matematyczne modele (kosztów, prawdopodobieństwa sukcesu, efektywności ramki kontekstowej) **potwierdzają ich prawdziwość**.
* Główna myśl: **dla LLM lepiej jest budować nowe rzeczy w dobrze zdefiniowanym frameworku niż „chirurgicznie” naprawiać stare fragmenty kodu**.





# Teza dla naprawiania

Dla zadań naprawiania: **opłaca się podejść strukturalnie** 
— najpierw zmierzyć kontekst, dług i testy, potem zastosować regułę decyzyjną (naprawić / odbudować). 
Gdy decyzja to „naprawa”, stosujemy ścisły workflow: 
- izolacja, 
- testy (MRE),
- segmentacja do nowych komponentów/folderów,
- iteracyjne naprawy z automatyczną walidacją;

# 2. Zmienne i opis modeli

Oznaczenia (używamy ich dalej):

* $D$ — **dług techniczny / złożoność problemu** (skala 0..∞; większe = trudniej naprawić).
* $T$ — **pokrycie testami** części krytycznej (skala 0..1).
* $K$ — **dostępny kontekst** (liczba tokenów / linii kodu / plików które LLM może jednocześnie „widzieć”), normalizowany do skali 0..1 przy porównaniu z wymaganym kontekstem $K_{req}$: $k = K / K_{req}$, obcięte do [0,1].
* $S$ — **zdolności modelu** (miara jakości LLM na zadaniach dev; 0..1).
* $C_{new}$ — koszt stworzenia nowego projektu od zera (w osobogodzinach lub arbitralnych jednostkach).
* $C_{fix}$ — koszt naprawy istniejącego systemu.
* $P_{fix}$ — prawdopodobieństwo, że zaproponowana poprawka przejdzie wszystkie testy.
* $Q$ — jakość wyniku (0..1).

# 3. Model kosztu naprawy i reguła decyzji

Podstawowy model:

$$
C_{fix} = \gamma D \cdot \frac{1}{S} \cdot \frac{1}{k} \cdot (1 + \lambda (1-T))
$$

gdzie $\gamma,\lambda>0$ są skalującymi współczynnikami (kalibrowalnymi wg zespołu). Interpretacja:

* większy $D$ → większy koszt,
* większe $S$ i $k$ → zmniejszają koszt,
* małe $T$ (brak testów) → koszt rośnie.

Porównanie:

* jeśli $C_{fix} > C_{new}$ → **wybierz budowę od zera**,
* w przeciwnym razie → **naprawiaj**.

### Przykład numeryczny (ilustracja)

Załóżmy:

* $D = 120$ (jednostki długu),
* $S = 0{.}7$,
* $k = 0{.}5$,
* $T = 0{.}2$,
* $\gamma = 0{.}5$,
* $\lambda = 1$,
* $C_{new} = 50$.

Obliczamy $C_{fix}$:

1. Pomnóż $ \gamma \cdot D$: $0{.}5 \times 120$. Liczę cyfrowo:
   $120 \times 0{.}5 = 120 \div 2 = 60.$
2. Podziel przez $S$: $60 \div 0{.}7$. Obliczamy:
   $0{.}7$ w przybliżeniu odwrotność ≈ $1{.}428571$.
   $60 \times 1{.}428571 \approx 85{.}71426$. (zaokrąglijmy do 85.71)
3. Podziel przez $k=0{.}5$: $85{.}71426 \div 0{.}5 = 171{.}42852$.
4. Pomnóż przez $(1 + \lambda(1-T)) = 1 + 1(1-0{.}2) = 1 + 0{.}8 = 1{.}8$.
   $171{.}42852 \times 1{.}8 \approx 308{.}57134$.

Wynik: $C_{fix} \approx 308{.}57$ > $C_{new}=50$ → **rebuild opłacalny**.

(Uwaga: liczby i współczynniki dobieramy praktycznie — celem jest metoda, nie stałe wartości.)

# 4. Model prawdopodobieństwa sukcesu naprawy

Przydatny model logistyczny (sigmoid):

$$
P_{fix} = \sigma\big( \alpha k + \beta T + \gamma' S - \delta D_{norm} \big)
$$

gdzie $\sigma(x) = \frac{1}{1+e^{-x}}$, $D_{norm} = D / D_{max}$ (skalujemy do [0,1]) i $\alpha,\beta,\gamma',\delta$ są wagami. Interpretacja: więcej kontekstu, testów i silniejszy LLM podnosi P, dług zmniejsza.

# 5. Metody praktyczne — krok po kroku (algorytm)

1. **Zbierz dane / triage (10-30 min)**

   * Zidentyfikuj symptom (błąd, stacktrace, failing test).
   * Zmierz $T$ (czy istnieją testy dla tej ścieżki?), oszacuj $D$ (np. liczba zależnych modułów, złożoność cyclomatic) i $K$ (ile plików trzeba dostarczyć LLM).
2. **Oblicz heurystycznie $C_{fix}$ i $P_{fix}$** (użyj wzorów wyżej). Jeśli $C_{fix} > C_{new}$ → plan rebuild. Jeżeli niepewne, przejdź dalej.
3. **Stwórz minimalny reproducible example (MRE)**

   * Wydziel minimalny fragment kodu do osobnego folderu z własnym `package.json`/`requirements.txt`.
   * Jeżeli nie da się wydzielić — napisz wrapper, który odtwarza błąd.
4. **Napisz test (jeśli brak)**

   * Automatyczny test jednostkowy/integracyjny, który deterministycznie odtwarza błąd.
5. **Praca z LLM (iteracje)**

   * Dostarcz LLM: MRE, failing test, stacktrace, środowisko (runtime, wersje), oraz konkretną instrukcję „napraw, zapewnij test, wyjaśnij zmiany”.
   * Jeśli kontekst przekracza limit $K$, użyj: *a)* wyodrębnionego MRE, *b)* dodatkowego pliku podsumowującego punktacje i zależności (skrót).
6. **Weryfikacja automatyczna**

   * Uruchom testy CI lokalnie (container/dockera).
   * Mierz: testy przechodzą (tak/nie), zmiany regresyjne (inne testy).
7. **Kod review + integracja**

   * Jeśli poprawka przechodzi testy i review — cherry-pick/merge do feature-branch.
   * Jeśli naprawa wymaga dużej zmiany architektonicznej → rozważ rebuild/migrację modułową.
8. **Zamknięcie**

   * Dodaj testy regresyjne, dokumentację, ewentualny rollback plan.

# 6. Wzorzec pracy z folderami (proponowana struktura)

```
/repair-{ticket-id}/
  /mre/                 # minimal reproducible example
    src/
    tests/
    Dockerfile
    README.md
  /proposals/           # candidate fixes (patches)
    fix-1/
      patch.diff
      explanation.md
    fix-2/
  /validation/          # CI logs, test results
  decision.md           # kalkulacja C_fix vs C_new, wybór
```

Zaleta: wszystkie eksperymenty w oddzielnym folderze, zero bezpośredniej zmiany w repo głównym póki niezatwierdzone.

# 7. Prompt-templates (konkretne)

Uwaga: dopasuj długości i usuń nieistotne pliki, gdy limit kontekstu jest mały.

## Template A — gdy masz MRE + test + stacktrace

```
Jesteś asystentem programistycznym. Masz za zadanie naprawić błąd. 
Oto MRE (folder /mre). Uruchomienie: `docker build . && pytest`. 
Failing test: tests/test_bug.py::test_case
Stacktrace:
<wklej stacktrace>

Środowisko: Python 3.11, dependencies: <wklej requirements.txt>
Zadanie:
1) Zlokalizuj przyczynę błędu.
2) Zaproponuj poprawkę i podaj patch (diff).
3) Zaktualizuj testy jeśli potrzebne i wyjaśnij ryzyko regresji.
4) Jeżeli naprawa nie jest możliwa bez przebudowy, opisz minimalny plan migracji.

Ograniczenia: nie modyfikuj plików poza src/ i tests/ w /mre. Odpowiedz: (a) diagnoza (b) patch (c) testy (d) instrukcja uruchomienia.
```

## Template B — brak testów, duży repo

```
Dostarczam mini-MRE: [krótki opis] + stacktrace + listę plików, które wydają się powiązane: [lista]. 
Nie możesz otworzyć całego repo. Twoim zadaniem:
1) Ustal, jakie minimalne testy utworzyć by odtworzyć błąd.
2) Wygeneruj krok po kroku skrypt, który tworzy MRE (np. skopiuj X, Y; stwórz environment).
3) Zaproponuj poprawkę w formie funkcji/patcha + krótkie testy.
Odpowiedz w formacie: plan_MRE, patch.diff, test.py, uruchomienie.
```

# 8. Kryteria akceptacji (metryki)

* **Test pass rate**: 100% dla nowych testów; <=0% regresji w dotychczasowych testach.
* **Czas do naprawy** (TTR): ile iteracji LLM potrzebował; celem < 5 iteracji.
* **Złożoność zmiany**: LOC zmienione — preferuj <20% pliku jeśli nie arch changes.
* **Prawdopodobieństwo regresji**: estymowane przez liczbę dotkniętych modułów; jeśli >0.3 (30%) → wymaga dodatkowego code review i integracyjnego testu.
* **Koszt**: rzeczywisty czas (osobogodziny) porównany z szacunkiem $C_{fix}$.

# 9. Jak kalibrować parametry ($\gamma,\lambda,\alpha...$)

* Zbieraj historyczne dane: dla N prób napraw, zanotuj rzeczywisty czas i wynik. Użyj regresji liniowej aby dopasować $\gamma,\lambda$.
* Przykładowo: zbierz 50 ticketów, fituj $C_{fix}$ do rzeczywistych kosztów. To pozwoli ustalić próg $D_{crit}$ i lepsze wagi w $P_{fix}$.

# 10. Automatyzacja (CI / Docker)

* Każde „repair-*” uruchamiaj w kontenerze z predefiniowanym runtime.
* Pipeline: `build -> run failing test -> run full test suite (fast subset) -> static analysis -> performance smoke tests`.
* Jeśli full suite trwa długo, zdefiniuj *smoke subset* (najbardziej krytyczne testy) jako bramę przed merge.

# 11. Gotowy checklist (do użycia przy każdym zadaniu naprawy)

1. Czy istnieje MRE? (tak → idź do 3; nie → stwórz MRE)
2. Czy istnieje test reprodukujący błąd? (tak → idź do 4; nie → napisz test)
3. Kalkulacja $C_{fix}$ i porównanie do $C_{new}$ — decyzja fix/rebuild.
4. Przygotuj folder repair-*.
5. Uruchom LLM z Template A/B.
6. Weryfikacja automatyczna (CI).
7. Code review, merge/rollback.

# 12. Najczęstsze antywzorce (i jak ich unikać)

* „Zmiana bez testów” — zawsze wymagaj testów regresyjnych.
* „Wklej cały repo do promptu” — zamiast tego wydziel MRE.
* „Naprawa bez kontenera” — środowisko musi być odtwarzalne (Docker).
* „Bez decyzji opłacalności” — stosuj model kosztu.

# 13. Co dostosować do twojego zespołu (konkrety)

* Kalibruj $\gamma$ na podstawie średniej stawki godzinowej zespołu.
* Definiuj $K_{req}$ na podstawie typowej ilości plików potrzebnych do lokalizacji błędu (np. 5 plików = 1.0).
* Ustal progi decyzyjne (np. rebuild jeśli $C_{fix}>1{.}5 \times C_{new}$).

---

