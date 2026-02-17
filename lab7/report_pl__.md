---
format:
  pdf:
    documentclass: llncs
    classoption: runningheads
    pdf-engine: pdflatex
    cite-method: natbib
    biblio-style: splncs04
    natbiboptions: "numbers,sort,compress,sectionbib"
    number-sections: true
    number-depth: 3
bibliography: bibliography.bib
---

\title{Sprawozdanie z laboratorium: Układy równań}
\titlerunning{Lab 7: Złożoność Dekompozycji LU}

\author{Vladyslav Humeniuk}
\authorrunning{Vladyslav Humeniuk}
\institute{}
\maketitle

## Wstęp

Celem niniejszego ćwiczenia była empiryczna weryfikacja teoretycznej złożoności obliczeniowej algorytmu rozwiązywania układów równań liniowych postaci $Ax = b$ z wykorzystaniem dekompozycji LU. Literatura przedmiotu wskazuje, że rozkład nieosobliwej macierzy $A$ na macierz dolnotrójkątną ($L$) i górnotrójkątną ($U$) wymaga wykonania około $\frac{2}{3}N^3$ operacji zmiennoprzecinkowych, co przekłada się na złożoność czasową rzędu $O(N^3)$[@lu_decomp]. Natomiast drugi etap procesu, czyli rozwiązanie układu metodą podstawiania (w przód i wstecz), charakteryzuje się znacznie niższą złożonością obliczeniową.

W sprawozdaniu przedstawiono analizę wydajności obu etapów algorytmu przy użyciu biblioteki *GNU Scientific Library* (GSL)[@gsl_linalg]. Pomiary czasu wykonano dla macierzy o wymiarach z przedziału od $N=10$ do $N=1000$.

## Metodyka

Program testowy zaimplementowano w języku C, wykorzystując funkcje biblioteczne GSL: `gsl_linalg_LU_decomp` oraz `gsl_linalg_LU_solve`, zgodnie z dokumentacją[@gsl_linalg]. Procedura badawcza obejmowała następujące kroki:

1.  **Generacja danych:** Dla każdego badanego wymiaru $N \in [10, 1000]$, macierz $A$ oraz wektor $b$ wypełniono losowymi wartościami z wykorzystaniem struktur wektorów i macierzy GSL[@gsl_vectors].
2.  **Dekompozycja:** Zmierzono czas operacji faktoryzacji LU macierzy $A$.
3.  **Rozwiązywanie:** Zmierzono czas wyznaczenia wektora wynikowego $x$ na podstawie wcześniejszego rozkładu.
4.  **Weryfikacja:** Poprawność wyniku sprawdzono poprzez obliczenie normy euklidesowej wektora residuum $r = ||Ax - b||$, wykorzystując operacje BLAS poziomu 2 dostępne w GSL[@gsl_blas].

Do pomiaru czasu wykorzystano funkcję systemową `getrusage()`, sumującą czas użytkownika i systemowy, co pozwoliło na uzyskanie precyzji mikrosekundowej.

## Wyniki

Zestawienie uzyskanych czasów wykonania oraz błędów numerycznych zaprezentowano w Tabeli \ref{tbl-results}. Wartości błędu residuum dla wszystkich prób oscylowały w granicach precyzji maszynowej ($10^{-10}$ do $10^{-13}$), co potwierdza poprawność i stabilność numeryczną zastosowanych metod[@gsl_linalg].

::: {#tbl-results tbl-pos='h'}
```{=latex}
\begin{table}
\centering
\begin{tabular}{|r|r|r|r|}
\hline
$N$ & Decomposition Time [s] & Solving Time [s] & Error $||Ax-b||$ \\
\hline
10 & 0.000206 & 0.000026 & $5.68 \times 10^{-13}$ \\
100 & 0.001146 & 0.000061 & $3.93 \times 10^{-12}$ \\
500 & 0.030898 & 0.000285 & $1.83 \times 10^{-10}$ \\
600 & 0.045422 & 0.000410 & $2.04 \times 10^{-09}$ \\
800 & 0.104717 & 0.000754 & $2.00 \times 10^{-10}$ \\
1000 & 0.201480 & 0.001222 & $1.20 \times 10^{-09}$ \\
\hline
\end{tabular}
\end{table}
```

Czasy wykonania i błędy rezydualne dla wybranych rozmiarów macierzy.
:::

### Analiza złożoności obliczeniowej

Otrzymane wyniki jednoznacznie ukazują dysproporcję w tempie wzrostu kosztu obliczeniowego obu operacji. Na Rysunku \ref{fig-decomp} przedstawiono czas dekompozycji, który wykazuje charakterystyczny dla złożoności $O(N^3)$ trend sześcienny, zgodny z teorią numeryczną[@lu_decomp].

![Zależność czasu dekompozycji LU od rozmiaru macierzy $N$. Widoczny trend wzrostu rzędu $O(N^3)$.](decomp_plot.pdf){#fig-decomp width=100% fig-pos='h'}

Z kolei czas rozwiązywania układu (Rysunek \ref{fig-solve}) rośnie w tempie kwadratowym. Nawet dla dużych wartości $N$, operacja ta pozostaje rzędy wielkości szybsza niż sama faktoryzacja.

![Zależność czasu rozwiązywania układu od rozmiaru macierzy $N$. Trend zgodny ze złożonością $O(N^2)$.](solve_plot.pdf){#fig-solve width=100% fig-pos='h'}

Aby precyzyjnie ocenić skalowalność algorytmu, porównano wzrost czasu wykonania przy dwukrotnym zwiększeniu rozmiaru problemu (z $N=500$ do $N=1000$):

\newpage

1.  **Etap dekompozycji:**
    $$\frac{T_{decomp}(1000)}{T_{decomp}(500)} = \frac{0.201480}{0.030898} \approx 6.52$$
    Teoretycznie, dla złożoności sześciennej oczekiwany współczynnik wzrostu wynosi $2^3 = 8$. Uzyskany wynik (ok. 6.5) jest niższy, co najprawdopodobniej wynika z mechanizmów optymalizacyjnych procesora (np. efektywniejsze wykorzystanie pamięci cache przy mniejszych macierzach). Mimo to, wzrost jest wyraźnie ponadkwadratowy.

2.  **Etap rozwiązywania:**
    $$\frac{T_{solve}(1000)}{T_{solve}(500)} = \frac{0.001222}{0.000285} \approx 4.29$$
    Wynik ten jest bardzo zbliżony do wartości teoretycznej dla złożoności kwadratowej ($2^2 = 4$).

Rysunek \ref{fig-log} w skali logarytmicznej obrazuje powiększającą się różnicę między nakładem obliczeniowym obu faz procesu.

![Porównanie czasów dekompozycji i rozwiązywania w skali logarytmicznej. Różne nachylenia krzywych odpowiadają różnym klasom złożoności.](combined_log_plot.pdf){#fig-log width=100% fig-pos='h'}

## Wnioski

Przeprowadzone eksperymenty w pełni potwierdzają teoretyczne założenia dotyczące złożoności algorytmów algebry liniowej omówione w materiałach dydaktycznych[@lu_decomp]. Koszt dekompozycji LU ($O(N^3)$) dominuje nad kosztem rozwiązania układu ($O(N^2)$), co staje się szczególnie widoczne wraz ze wzrostem wymiaru zadania.

Dla $N=1000$, proces dekompozycji trwał około 165 razy dłużej niż samo wyznaczenie wyniku. Uzasadnia to powszechnie stosowaną strategię numeryczną: w przypadku konieczności rozwiązania wielu układów z tą samą macierzą główną $A$, ale różnymi wektorami wyrazów wolnych $b$, najbardziej efektywnym podejściem jest jednokrotne wykonanie dekompozycji, a następnie wielokrotne wykorzystanie uzyskanej faktoryzacji do szybkiego ($O(N^2)$) wyznaczania rozwiązań.
