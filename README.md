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
      actions:
        - "Określ kierunek rozwoju projektu."
        - "Zidentyfikuj funkcje i moduły kluczowe dla obecnej iteracji."

    - id: 2
      title: "Refaktoryzacja generuje górkę zadań"
      description: "Refaktoryzacja często ujawnia dodatkowe wymagania i testy."
      priority: medium
      actions:
        - "Zidentyfikuj nowe testy potrzebne do poprawnej refaktoryzacji."
        - "Oceń, czy warto kontynuować stary projekt, czy zacząć nowy."

    - id: 3
      title: "Nowy projekt vs kontynuacja"
      description: "Rozpoczęcie nowego projektu może być bardziej efektywne niż poprawa starego."
      priority: high
      actions:
        - "Utwórz nową strukturę projektu, jeśli obecna jest zbyt złożona."
        - "Zachowaj doświadczenia z poprzednich iteracji w dokumentacji."

    - id: 4
      title: "Iteracje jako nowe foldery/projekty"
      description: "Każda iteracja powinna być osobnym projektem, unikając zmiany starych plików."
      priority: high
      actions:
        - "Twórz nowy folder dla każdej iteracji."
        - "Podziel problem na mniejsze zadania realizowane w nowych strukturach."

    - id: 5
      title: "Niepowodzenia kształtują kierunek rozwoju"
      description: "Błędy i nieudane iteracje są źródłem informacji o kierunku prac."
      priority: medium
      actions:
        - "Dokumentuj niepowodzenia i wyciągaj z nich wnioski."
        - "Uaktualniaj wektor oczekiwań na podstawie doświadczeń."

    - id: 6
      title: "Manifest jako przewodnik LLM"
      description: "Zasady manifestu pomagają LLM w efektywnej realizacji zadań."
      priority: high
      actions:
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

