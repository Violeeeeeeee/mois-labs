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

\title{Sprawozdanie z Laboratorium 7: Rozwiązywanie układów równań liniowych metodą dekompozycji LU}
\titlerunning{Lab 7: Linear Equations LU}

\author{Vladyslav Humeniuk}
\authorrunning{Vladyslav Humeniuk}
\institute{}
\maketitle

## Wstęp {#sec-intro}

Celem laboratorium było zbadanie numerycznej efektywności rozwiązywania układów równań liniowych postaci $Ax = b$ przy użyciu biblioteki *GNU Scientific Library* (GSL). Kluczowym aspektem ćwiczenia była analiza złożoności obliczeniowej dwóch etapów procesu:
1.  Dekompozycji macierzy $A$ na iloczyn macierzy dolno- i górnotrójkątnej ($LU$).
2.  Rozwiązania układu równań przy użyciu wyznaczonych macierzy (podstawienie w przód i wstecz).

Zgodnie z teorią, dekompozycja LU powinna charakteryzować się złożonością $O(N^3)$, natomiast samo rozwiązywanie układu po dekompozycji – złożonością $O(N^2)$.

## Metodyka

Do realizacji zadania napisano program w języku C wykorzystujący funkcje `gsl_linalg_LU_decomp` oraz `gsl_linalg_LU_solve`. Pomiary czasu wykonano dla rozmiarów macierzy $N$ z przedziału $[10, 1000]$. Czas mierzono przy użyciu funkcji systemowych `getrusage` (czas użytkownika + czas systemowy). Poprawność rozwiązania weryfikowano poprzez obliczenie normy residuum $||Ax - b||$.

## Wyniki

Otrzymane wyniki pomiarów czasu oraz błędów przedstawiono w Tabeli \ref{tbl-results}.

::: {#tbl-results tbl-pos='h'}
{latex}
\begin{table}
\centering
\begin{tabular}{|r|r|r|r|}
\hline
N & Czas Dekompozycji [s] & Czas Rozwiązywania [s] & Błąd $||Ax-b||$ \\
\hline
10 & 0.000206 & 0.000026 & $5.68 \times 10^{-13}$ \\
100 & 0.001146 & 0.000061 & $3.93 \times 10^{-12}$ \\
200 & 0.007188 & 0.000191 & $1.34 \times 10^{-10}$ \\
300 & 0.016513 & 0.000289 & $5.55 \times 10^{-11}$ \\
400 & 0.026210 & 0.000263 & $1.42 \times 10^{-10}$ \\
500 & 0.030898 & 0.000285 & $1.83 \times 10^{-10}$ \\
600 & 0.045422 & 0.000410 & $2.04 \times 10^{-09}$ \\
700 & 0.071670 & 0.000560 & $3.23 \times 10^{-10}$ \\
800 & 0.104717 & 0.000754 & $2.00 \times 10^{-10}$ \\
900 & 0.146367 & 0.000982 & $5.49 \times 10^{-10}$ \\
1000 & 0.201480 & 0.001222 & $1.20 \times 10^{-09}$ \\
\hline
\end{tabular}
\end{table}
Zestawienie czasów wykonania i błędów dla różnych rozmiarów układu $N$.
:::

### Analiza złożoności obliczeniowej

Na Rysunku \ref{fig-decomp} przedstawiono zależność czasu dekompozycji od rozmiaru macierzy, a na Rysunku \ref{fig-solve} – czasu rozwiązywania.

![Zależność czasu dekompozycji LU od rozmiaru macierzy $N$. Widoczny charakter sześcienny krzywej.](decomp_plot.pdf){#fig-decomp width=100% fig-pos='h'}

![Zależność czasu rozwiązywania układu (podstawienie) od rozmiaru macierzy $N$. Widoczny charakter kwadratowy.](solve_plot.pdf){#fig-solve width=100% fig-pos='h'}

Analizując przyrost czasu dla podwojenia rozmiaru problemu (np. z $N=500$ do $N=1000$):
1.  **Dekompozycja:** Czas wzrósł z $0.0309$ s do $0.2015$ s, co stanowi krotność ok. $6.5$. Teoretyczny wzrost dla $O(N^3)$ wynosi $2^3=8$. Wynik eksperymentalny jest zbliżony do teoretycznego, różnice mogą wynikać z optymalizacji pamięci podręcznej (cache) procesora dla mniejszych macierzy.
2.  **Rozwiązywanie:** Czas wzrósł z $0.000285$ s do $0.001222$ s, co stanowi krotność ok. $4.3$. Jest to wynik bardzo zbliżony do teoretycznego $2^2=4$ dla złożoności $O(N^2)$.

## Wnioski

Przeprowadzone eksperymenty potwierdzają teoretyczne założenia dotyczące złożoności obliczeniowej algorytmów algebry liniowej:
1.  Koszt dekompozycji macierzy ($O(N^3)$) dominuje nad kosztem rozwiązania układu ($O(N^2)$), szczególnie dla dużych wartości $N$.
2.  Dla $N=1000$ czas dekompozycji jest około 165 razy dłuższy niż czas rozwiązania układu. Oznacza to, że w przypadku konieczności rozwiązania wielu układów z tą samą macierzą główną $A$, ale różnymi wektorami $b$, wykonanie dekompozycji raz i wielokrotne podstawianie jest strategią wysoce efektywną.
3.  Biblioteka GSL zapewnia wysoką precyzję obliczeń – błędy rozwiązania rzędu $10^{-10}$ są pomijalne w zastosowaniach inżynierskich.
