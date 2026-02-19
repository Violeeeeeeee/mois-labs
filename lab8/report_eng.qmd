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

\title{Lab 8: Monte Carlo Integration Methods}
\titlerunning{Lab 8: Monte Carlo}

\author{Vladyslav Humeniuk}
\authorrunning{Vladyslav Humeniuk}
\institute{}
\maketitle

## Introduction {#sec-intro}

The objective of this laboratory was the empirical verification of Monte Carlo methods for numerical integration. The exercise focuses on evaluating the integral of three functions on the interval $(0, 1)$:

1. $f_1(x) = x^2 + x + 1$
2. $f_2(x) = \sqrt{1 - x^2}$
3. $f_3(x) = \frac{1}{\sqrt{x}}$

The study compares a custom implementation of the basic "Hit-and-Miss" algorithm against advanced routines provided by the GNU Scientific Library (GSL): PLAIN, MISER, and VEGAS [@gsl_monte]. Theory indicates that for standard Monte Carlo methods, the error estimate decreases proportionally to $1/\sqrt{N}$, where $N$ is the number of sample points.

## Methodology

To perform the measurements, a test program was implemented in C using GSL library functions: `gsl_monte_plain_integrate`, `gsl_monte_miser_integrate`, and `gsl_monte_vegas_integrate`.

The research procedure included the following considerations:

1. **Hit-and-Miss Method**: This basic approach requires defining a finite bounding box. It works correctly for bounded functions ($f_1$ and $f_2$) but fails for $f_3(x) = 1/\sqrt{x}$, because the function approaches infinity as $x \to 0$, making it impossible to establish a maximum boundary $y_{max}$.
2. **GSL Integration**: The GSL routines were used to integrate $f_3(x)$. These algorithms are designed such that random sample points are always chosen strictly within the integration region, automatically avoiding endpoint singularities like the one at $x=0$.

## Results

### Hit-and-Miss Convergence

The execution errors for the Hit-and-Miss algorithm applied to functions $f_1$ and $f_2$ are presented in Table \ref{tbl-hit-miss}.

::: {#tbl-hit-miss tbl-pos='h'}
\begin{table}
\centering
\begin{tabular}{|r|r|r|}
\hline
N & Error $f_1(x)$ & Error $f_2(x)$ \\
\hline
100     & 0.213333      & 0.0546018     \\
500     & 0.0926667     & 0.00860184    \\
1000    & 0.0603333     & 0.00160184    \\
5000    & 0.00986667    & 0.00100184    \\
10000   & 0.0174333     & 0.000101837   \\
50000   & 0.00729333    & 0.00402184    \\
100000  & 0.00236667    & 0.00213184    \\
500000  & 0.00165333    & 0.000432163   \\
\hline
\end{tabular}
\end{table}
Absolute integration errors for the Hit-and-Miss method for $f_1(x)$ and $f_2(x)$.
:::

Figure \ref{fig-hitmiss} illustrates the convergence in a logarithmic scale, showing the expected steady decrease in error as the number of trials increases.

![Hit-and-Miss Integration Error vs. Number of Trials. The downward trend is consistent with standard Monte Carlo error scaling.](hit_and_miss_error.pdf){#fig-hitmiss width=100% fig-pos='h'}

### GSL Methods Comparison

Table \ref{tbl-gsl} and Figure \ref{fig-gsl} present the error for the $f_3(x)$ integral using three distinct GSL strategies.

::: {#tbl-gsl tbl-pos='h'}
\begin{table}
\centering
\begin{tabular}{|r|r|r|r|}
\hline
N & Error PLAIN & Error MISER & Error VEGAS \\
\hline
100     & 0.1281730 & 0.5453990 & 0.00140105 \\
500     & 0.0395817 & 0.0152057 & 0.00323800 \\
1000    & 0.3370740 & 0.0488994 & 0.00170075 \\
5000    & 0.0011285 & 0.0135611 & 0.00006517 \\
10000   & 0.0166513 & 0.0300152 & 0.00003832 \\
50000   & 0.0121750 & 0.0016634 & 0.00002639 \\
100000  & 0.0131327 & 0.0098215 & 0.00001162 \\
500000  & 0.0005657 & 0.0001767 & 0.00000216 \\
\hline
\end{tabular}
\end{table}
Integration errors for $f_3(x) = 1/\sqrt{x}$ using GSL PLAIN, MISER, and VEGAS algorithms.
:::

![Error vs. Number of Function Calls for GSL Methods. Note the significant accuracy advantage of the VEGAS algorithm.](gsl_methods_error.pdf){#fig-gsl width=100% fig-pos='h'}

The results show clear disparities based on the variance reduction technique used:
* **PLAIN**: Relies on pure random sampling and yields the highest error at $N=500000$ ($5.65 \times 10^{-4}$).
* **MISER**: Uses recursive stratified sampling [@press1990] to concentrate points in regions of highest variance. It improves upon the PLAIN method, achieving an error of $1.76 \times 10^{-4}$.
* **VEGAS**: Based on importance sampling [@lepage1978], sampling from the probability distribution described by $|f|$. It heavily outperforms the others, achieving an error of $2.15 \times 10^{-6}$ for the same number of function calls.

## Conclusion

The conducted experiments confirm the theoretical principles of Monte Carlo integration:

1. The rudimentary Hit-and-Miss method is effective only for bounded functions.
2. The GSL routines handle endpoint singularities gracefully by sampling strictly within the bounds.
3. Variance reduction techniques are critical for efficiency. The VEGAS algorithm, utilizing importance sampling, proved to be highly superior for an integrand with a sharp localized peak ($1/\sqrt{x}$), requiring significantly fewer iterations to reach a high degree of precision compared to uniform random sampling.
