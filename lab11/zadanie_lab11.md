Równania różniczkowe zwyczajne
Materiały

1. [Równania różniczkowe w GSL](https://www.gnu.org/software/gsl/doc/html/ode-initval.html)
2. [Metody rozwiązywania równań różniczkowych - slajdy](http://artemis.wszib.edu.pl/~funika/mois/lab11/heath_ODE.pdf)

Zadania
A.
1.  Szukamy przybliżonego rozwiązania równania van der Pol’a:
    $$
    u''(t)+\mu u'(t)(u(t)^{2}-1) +u(t) = 0
    $$
    poprzez sprowadzenie równania do układu równań 1-ego stopnia z wprowadzeniem nowej zmiennej $v=u'(t)$:
    $$
    u'=v
    v'=-u+\mu v(1-u^{2})
    $$

2.  Uruchomić programy rozwiązujące w/w równanie różniczkowe: ode-ex1.c, ode-ex2.c, ode-ex3.c.
    Umieć odpowiedzieć na szczegółowe pytania, co one robią.
    Narysować (np. za pomocą gnuplota ) wykresy na podstawie danych wynikowych.

B.
1. Dane jest równanie różniczkowe (zagadnienie początkowe):
$$
y’ + y cosx = sinx cosx
y(0) = 0
$$
2. Znaleźć rozwiązanie metodą Rungego-Kutty i metodą Eulera.
3. Porównać otrzymane rozwiązanie z rozwiązaniem dokładnym $y(x) = e^{-sinx} + sin x – 1$
4. Porównać efektywność rozwiązania uzyskanego metodą Rungego-Kutty i metodą Eulera.
