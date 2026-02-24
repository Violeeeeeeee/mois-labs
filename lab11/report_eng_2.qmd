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

\title{Lab 11: Ordinary Differential Equations}
\titlerunning{Lab 11: ODEs}

\author{Vladyslav Humeniuk}
\authorrunning{Vladyslav Humeniuk}
\institute{}
\maketitle

## Introduction {#sec-intro}

The objective of this laboratory was to solve Ordinary Differential Equations (ODEs) using numerical methods provided by the GNU Scientific Library (GSL) [@gsl_ode_doc]. Numerical solutions are essential when analytical solutions are difficult or impossible to obtain, replacing the differential equations with algebraic approximations evaluated over finite steps [@heath_ode].

This report is divided into two main parts. Part A explores the van der Pol oscillator, a second-order non-linear ODE, focusing on the differences between fixed-step and adaptive-step solvers. Part B involves solving a first-order initial value problem to compare the accuracy and efficiency of the Runge-Kutta 4th-order method against the standard Euler method.

## Methodology

### Part A: The van der Pol Oscillator
The van der Pol equation is given by:
$$u''(t) + \mu u'(t)(u(t)^2 - 1) + u(t) = 0$$
To solve this using GSL, it must be reduced to a system of first-order equations by introducing a new variable $v = u'(t)$ [@heath_ode]:
$$u' = v$$
$$v' = -u + \mu v(1 - u^2)$$

Three different GSL implementations were analyzed:

1. **`ode-ex1.c`**: Uses a high-level driver with the adaptive Runge-Kutta Prince-Dormand (8,9) method (`rk8pd`). It evaluates the solution dynamically but forces the output at exactly 100 evenly spaced intervals.
2. **`ode-ex2.c`**: Employs a low-level stepper (`gsl_odeiv2_evolve`) with the `rk8pd` method. It outputs the solution at every single internal adaptive step taken by the algorithm.
3. **`ode-ex3.c`**: Utilizes a high-level driver with a strict fixed-step 4th-order Runge-Kutta method (`rk4`), taking 1000 internal steps per interval to output 100 evenly spaced points.

### Part B: First-Order ODE Comparison
The target initial value problem ($y(0) = 0$) is:
$$y' + y \cos(x) = \sin(x) \cos(x)$$
Rewritten in the standard form $y' = f(x,y)$:
$$y' = \sin(x)\cos(x) - y\cos(x)$$
The equation was solved over the interval $[0, 15]$ using two numerical methods:

1. The Runge-Kutta 4th-order method (via GSL `gsl_odeiv2_step_rk4`).
2. The Euler method (custom implementation).

The numerical results were compared against the exact analytical solution:
$$y(x) = e^{-\sin(x)} + \sin(x) - 1$$

## Results

### Part A: Solver Strategies for the van der Pol Equation
Figure \ref{fig-vanderpol-all} illustrates the step distribution for the three solver configurations.

![Comparison of step distributions for the van der Pol oscillator using different GSL ODE solvers.](part_a_vanderpol_comparison.pdf){#fig-vanderpol-all width=100% fig-pos='h'}

As seen in the overlay plots (Figures \ref{fig-ex1ex2}, \ref{fig-ex2ex3} and \ref{fig-ex1ex3}), all three methods successfully trace the same oscillatory curve. However, the internal mechanics differ drastically:

* **Example 1 and 3** yield perfectly spaced outputs. Example 1 achieves this by masking the complex adaptive micro-steps, while Example 3 achieves this through brute-force fixed micro-steps.
* **Example 2** exposes the behavior of the adaptive `rk8pd` solver. The density of points increases significantly in regions where the function undergoes rapid changes (sharp turns). In smoother regions, the algorithm takes much larger steps, saving computational resources while maintaining precision [@heath_ode].

::: {layout-nw="[1,1]"}
![Overlay of Ex 1 (Fixed Output) and Ex 2 (Adaptive Steps).](ex1vsex2.pdf){#fig-ex1ex2 fig-pos='t'}

![Overlay of Ex 2 (Adaptive Steps) and Ex 3 (Fixed Internal Steps).](ex2vsex3.pdf){#fig-ex2ex3 fig-pos='t'}

![Overlay of Ex 1 (Fixed Output) and Ex 3 (Fixed Internal Steps).](ex1vsex3.pdf){#fig-ex1ex3 fig-pos='t'}
:::

### Part B: Runge-Kutta vs. Euler Method
Figure \ref{fig-partb} presents the numerical solutions of the first-order ODE compared to the exact analytical curve.

![Numerical solutions vs. Exact solution for $y' = \sin(x)\cos(x) - y\cos(x)$.](part_b_comparison.pdf){#fig-partb width=100% fig-pos='t'}

The graphical comparison clearly demonstrates the superior accuracy of the Runge-Kutta 4th-order method (RK4). The RK4 data points fall perfectly along the exact solution line. Conversely, the Euler method visibly drifts from the true curve, overshooting the peaks and valleys of the oscillation.

**Efficiency Comparison:**
The Euler method is a 1st-order approach with a global truncation error proportional to the step size ($O(h)$). To achieve the same level of accuracy as the RK4 method ($O(h^4)$), the Euler method would require exponentially more steps, making it highly inefficient for complex scientific computing [@heath_ode]. RK4 requires four function evaluations per step but allows for vastly larger step sizes, making it far more efficient overall.

## Conclusion

The laboratory tasks highlighted the importance of choosing the correct numerical method and stepping strategy for solving ODEs. For stiff equations or those with rapid fluctuations like the van der Pol oscillator, adaptive step-size solvers (e.g., `rk8pd`) provide the best balance of precision and performance by automatically adjusting the resolution where needed [@gsl_ode_doc]. Furthermore, the comparison in Part B empirically confirmed that higher-order methods like RK4 are vastly more accurate and efficient than the basic Euler method for the same number of integration steps.
