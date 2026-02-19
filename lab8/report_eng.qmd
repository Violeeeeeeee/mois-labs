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

\title{Lab 8: Monte Carlo Integration}
\titlerunning{Lab 8: Monte Carlo}

\author{Vladyslav Humeniuk}
\authorrunning{Vladyslav Humeniuk}
\institute{}
\maketitle

## Introduction {#sec-intro}

The objective of this laboratory was the empirical verification of Monte Carlo methods for numerical integration. The exercise focuses on evaluating the definite integral of three specific functions on the interval $(0, 1)$: $f_1(x) = x^2 + x + 1$, $f_2(x) = \sqrt{1 - x^2}$, and $f_3(x) = \frac{1}{\sqrt{x}}$.

The study compares a custom implementation of the basic Hit-and-Miss algorithm against advanced multidimensional integration routines: PLAIN, MISER, and VEGAS [@gsl_monte]. Standard Monte Carlo methods rely on random sampling to approximate integrals [@mathworld_mc], with the theoretical error estimate decreasing proportionally to $1/\sqrt{N}$, where $N$ is the total number of sample points.

## Methodology

The computational procedure was divided into two main approaches. The first approach involved the Hit-and-Miss method, which requires defining a finite rectangular bounding box that fully encloses the function. While this geometric approach works correctly for bounded functions such as $f_1(x)$ and $f_2(x)$, it inherently fails for $f_3(x) = 1/\sqrt{x}$. Because the function approaches infinity as $x \to 0$, it is impossible to establish the maximum boundary $y_{max}$ required for generating uniform random coordinates.

To evaluate $f_3(x)$, the second approach utilized advanced numerical integration routines. These algorithms are designed such that random sample points are strictly chosen within the integration region, automatically avoiding endpoint singularities [@gsl_monte]. The PLAIN method performs a standard uniform sampling over the region. To significantly improve convergence, variance reduction techniques are applied: the MISER algorithm utilizes recursive stratified sampling to concentrate points in regions of highest variance, whereas the VEGAS algorithm employs importance sampling, adapting its probability distribution to match the integrand's behavior [@gsl_monte]. The accuracy of all these numerical methods is fundamentally dependent on the quality of the underlying pseudorandom number generators [@taygeta_rng].

## Results

### Hit-and-Miss Convergence

The absolute errors for the Hit-and-Miss algorithm applied to $f_1$ and $f_2$ are presented in Table \ref{tbl-hit-miss}.

::: {#tbl-hit-miss tbl-pos='h'}
\begin{table}
\centering
\begin{tabular}{|r|r|r|}
\hline
N & Error $f_1(x)$ & Error $f_2(x)$ \\
\hline
100 & 0.213333 & 0.0546018 \\
500 & 0.0926667 & 0.00860184 \\
1000 & 0.0603333 & 0.00160184 \\
5000 & 0.00986667 & 0.00100184 \\
10000 & 0.0174333 & 0.000101837 \\
50000 & 0.00729333 & 0.00402184 \\
100000 & 0.00236667 & 0.00213184 \\
500000 & 0.00165333 & 0.000432163 \\
\hline
\end{tabular}
\end{table}
Absolute integration errors for the Hit-and-Miss method for $f_1(x)$ and $f_2(x)$.
:::

Figure \ref{fig-hitmiss} illustrates this convergence on a logarithmic scale. The data demonstrates a steady downward trend for both functions, which is highly consistent with the theoretical $O(1/\sqrt{N})$ Monte Carlo error scaling.

![Hit-and-Miss Integration Error vs. Number of Trials. The downward trend reflects standard Monte Carlo error scaling.](hit_and_miss_error.pdf){#fig-hitmiss width=100% fig-pos='h'}

### GSL Methods Comparison

Table \ref{tbl-gsl} and Figure \ref{fig-gsl} present the integration errors for $f_3(x)$ utilizing the PLAIN, MISER, and VEGAS strategies.

::: {#tbl-gsl tbl-pos='h'}
\begin{table}
\centering
\begin{tabular}{|r|r|r|r|}
\hline
N & Error PLAIN & Error MISER & Error VEGAS \\
\hline
100 & 0.1281730 & 0.5453990 & 0.00140105 \\
500 & 0.0395817 & 0.0152057 & 0.00323800 \\
1000 & 0.3370740 & 0.0488994 & 0.00170075 \\
5000 & 0.0011285 & 0.0135611 & 0.00006517 \\
10000 & 0.0166513 & 0.0300152 & 0.00003832 \\
50000 & 0.0121750 & 0.0016634 & 0.00002639 \\
100000 & 0.0131327 & 0.0098215 & 0.00001162 \\
500000 & 0.0005657 & 0.0001767 & 0.00000216 \\
\hline
\end{tabular}
\end{table}
Integration errors for $f_3(x) = 1/\sqrt{x}$ using PLAIN, MISER, and VEGAS algorithms.
:::

![Error vs. Number of Function Calls for different Monte Carlo methods. The VEGAS algorithm demonstrates a significant accuracy advantage.](gsl_methods_error.pdf){#fig-gsl width=100% fig-pos='h'}

The results highlight the significant impact of variance reduction techniques. The PLAIN method, relying on pure uniform sampling, yields the highest error at $N=500000$ ($5.65 \times 10^{-4}$). The MISER method improves upon this baseline by using stratified sampling, reducing the final error to $1.76 \times 10^{-4}$. However, the VEGAS algorithm heavily outperforms both alternatives, achieving an error of $2.15 \times 10^{-6}$ for the same number of function calls due to its ability to adapt its sampling grid to the integrand's sharp peak near zero.

## Conclusion

The conducted experiments confirm the theoretical principles and limitations of Monte Carlo integration. The rudimentary Hit-and-Miss method provides intuitive and correct results but is strictly limited to bounded functions. Advanced integration routines effectively handle endpoint singularities by constraining the sample space safely. Furthermore, variance reduction techniques are critical for computational efficiency. The VEGAS algorithm, utilizing importance sampling, proved to be highly superior for an integrand with a sharp localized peak, requiring significantly fewer iterations to reach a high degree of precision compared to uniform random sampling or basic stratification.
