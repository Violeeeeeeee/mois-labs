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

\title{Lab 10: One-Dimensional Minimization}
\titlerunning{Lab 10: 1D Optimization}

\author{Vladyslav Humeniuk}
\authorrunning{Vladyslav Humeniuk}
\institute{}
\maketitle

## Introduction {#sec-intro}

The objective of this laboratory was to explore one-dimensional minimization algorithms provided by the GNU Scientific Library (GSL) [@gsl_min]. Optimization problems involve finding a minimizer $x^*$ such that $f(x^*) \le f(x)$ for all $x$ in a given set [@heath_optim]. The GSL minimization algorithms begin with a bounded region known to contain a minimum, described by a lower bound $a$ and an upper bound $b$, along with an initial estimate $m$ of the minimum's location [@gsl_min]. This report investigates the computational complexity and bracketing requirements of three different iterative minimizers: Brent's method, the modified Brent method (`quad_golden`), and the Golden Section search.

## Methodology

The computational tasks were divided into the following stages:

1. **Analysis of `brent_minim.c`**: Examining a base program that uses Brent's algorithm to find the minimum of $f(x) = \cos(x) + 1$ on the interval $[0, 6]$ with an initial guess of $2.0$ [@gsl_min].
2. **Algorithm Comparison**: Modifying the base program to include `gsl_min_fminimizer_goldensection` and `gsl_min_fminimizer_quad_golden`, and comparing their convergence rates (number of iterations).
3. **Problematic Bracketing**: Applying the algorithms to a new function, $f(x) = e^{-x} - \sin(x) + \sqrt{x}$, on the interval $[\pi/2, 4\pi]$, to analyze failure modes and implement a corrected bracketing strategy.

## Results

### Task 1 & 2: Optimization of $f(x) = \cos(x) + 1$

The initial program uses the Brent algorithm to find the minimum of the function $f(x) = \cos(x) + 1$, which theoretically occurs at $x = \pi$ [@gsl_min]. The starting interval is $(0,6)$, with an initial guess for the minimum of $2$ [@gsl_min]. A plot of this function is shown in Figure \ref{fig-f1}.

![Plot of $f(x) = \cos(x) + 1$. The global minimum is visibly located at $x \approx 3.14$.](f1_plot.pdf){#fig-f1 width=85% fig-pos='h'}

The convergence results for the three tested methods are presented in Table \ref{tbl-f1-results}.

::: {#tbl-f1-results tbl-pos='h'}
\begin{table}
\centering
\begin{tabular}{|l|c|c|c|}
\hline
Method & Iterations & Found Minimum ($x$) & $f(x)$ \\
\hline
Brent & 6 & 3.14159 & 0.00000 \\
Quad-Golden & 19 & 3.14165 & 0.00000 \\
Golden Section & 24 & 3.14157 & 0.00000 \\
\hline
\end{tabular}
\end{table}
Performance comparison of 1D minimization algorithms for $f(x) = \cos(x) + 1$.
:::

**Computational Complexity Comparison:** Brent's method is highly efficient, requiring only 6 iterations to converge. It achieves this speed by approximating the function using an interpolating parabola through three existing points to jump directly toward the minimum [@gsl_min]. The Golden Section search is the slowest (24 iterations) because it relies on a strict geometric reduction of the interval without assuming any shape of the function. The `quad_golden` variant, which uses the safeguarded step-length algorithm of Gill and Murray, required 19 iterations [@gsl_min].

### Task 3: Optimization of $f(x) = e^{-x} - \sin(x) + \sqrt{x}$

The second function, $f(x) = e^{-x} - \sin(x) + \sqrt{x}$, was analyzed on the requested interval $[\pi/2, 4\pi]$. Its behavior is visualized in Figure \ref{fig-f2}.

![Plot of $f(x) = e^{-x} - \sin(x) + \sqrt{x}$. A local minimum is visible near $x = 7.67$, but the absolute lowest value on the interval $[\pi/2, 4\pi]$ is at the left boundary.](f2_plot.pdf){#fig-f2 width=85% fig-pos='h'}

**Analysis of the Bracketing Problem:**
When attempting to initialize the GSL minimizers on the interval $[\pi/2, 4\pi]$ with a guess of $x=4.0$, the program throws a fatal error: `invalid argument supplied by user`.

This occurs because GSL requires a strictly valid bracketing interval. The mathematical condition is that the function value at the internal guess $m$ must be lower than the values at both boundaries: $f(m) < f(a)$ and $f(m) < f(b)$. However, on the interval $[\pi/2, 4\pi]$, the absolute lowest value occurs at the left boundary $a = \pi/2$ (where $f(a) \approx 0.461194$). Because the boundary is lower than any internal local minimum, it is impossible to supply a valid guess $m$ that satisfies the strict bracketing conditions.

**Solution and Corrected Results:**
To successfully find the local minimum, the starting bracket must be narrowed to exclusively enclose the "dip" in the curve, avoiding the lower left boundary. The interval was corrected to $[6.0, 9.0]$ with an initial guess of $7.0$.

The performance of the algorithms on this corrected interval is presented in Table \ref{tbl-f2-results}.

::: {#tbl-f2-results tbl-pos='h'}
\begin{table}
\centering
\begin{tabular}{|l|c|c|c|}
\hline
Method & Iterations & Found Minimum ($x$) & $f(x)$ \\
\hline
Brent & 6 & 7.67295 & 1.78682 \\
Quad-Golden & 17 & 7.67292 & 1.78682 \\
Golden Section & 21 & 7.67296 & 1.78682 \\
\hline
\end{tabular}
\end{table}
Performance comparison of 1D minimization algorithms for $f(x) = e^{-x} - \sin(x) + \sqrt{x}$ on the corrected interval $[6.0, 9.0]$.
:::

Once a valid bracket was established, the hierarchy of algorithmic efficiency remained identical to the first task. Brent's method converged exceptionally fast (6 iterations), while the Golden Section method required over three times as many steps (21 iterations).

## Conclusion

The laboratory tasks successfully demonstrated the use of one-dimensional optimization algorithms. Brent's method proved to be the most computationally efficient approach, leveraging parabolic interpolation for rapid convergence. The experiments also highlighted a critical limitation of bracket-based minimizers: they cannot find global minima that lie directly on the boundaries of an interval if a lower internal point does not exist. Proper visualization and manual bounding are essential prerequisites for automated optimization routines.
