Całkowanie Monte Carlo
Materiały

* [Całkowanie Monte Carlo w gsl](https://www.gnu.org/software/gsl/doc/html/montecarlo.html)
* [Definicja metody Monte Carlo](http://mathworld.wolfram.com/MonteCarloMethod.html)
* [Liczby pseudolosowe vs. quasi-losowe](http://www.taygeta.com/rwalks/node3.html)

Zadania

Tematem zadania będzie obliczanie metodami Monte Carlo całki funkcji 1) x^2 + x + 1, 2) sqrt(1-x^2) oraz 3) 1/sqrt(x) w przedziale (0,1).
Proszę dla tych funkcji:

1. Napisać funkcję liczącą całkę metodą "hit-and-miss". Czy będzie ona dobrze działać dla funkcji 1/sqrt(x)?
2. Policzyć całkę przy użyciu napisanej funkcji. Jak zmienia się błąd wraz ze wzrostem liczby prób? Narysować wykres tej zależności przy pomocy Gnuplota. Przydatne będzie skala logarytmiczna.
3. Policzyć wartość całki korzystając z funkcji Monte Carlo z GSL. Narysować wykres zależności błędu od ilości wywołań funkcji dla różnych metod (PLAIN, MISER, VEGAS).
