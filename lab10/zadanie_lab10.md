Minimalizacja funkcji 1-D
Materiały

1. [Poszukiwanie minimum 1-D w gsl](https://www.gnu.org/software/gsl/doc/html/min.html)
2. [Metody obliczeniowe optymalizacji](http://optymalizacja.w8.pl/)
3. [Metody optymalizacji - slajdy](http://artemis.wszib.edu.pl/~funika/mois/lab10/heath_optim.pdf)

Zadania

1. Uruchomić program brent_minim.c
    * Krótko opisać, co on robi.
    * Narysować (np. za pomocą gnuplota ) wykres funkcji, której minimum szukamy.
2. Zmienić program tak, aby znajdował minimum metodą „złotego podziału” oraz zmodyfikowaną metodą Brenta „quad_golden”.
    * Porównać metody (złożoność obliczeniowa).
    * Zamienić program tak, aby spróbował znaleźć minimum funkcji e^(-x) – sin(x) + sqrt(x) na przedziale od pi/2 do 4*pi
    * Narysować wykres tej funkcji za pomocą np. gnuplota.
    * Wyjaśnić działanie programu – czy są problemy ze znalezieniem minimum? Jeśli są, co należy zrobić, żeby znaleźć minimum.
    * Porównać metodę Brenta, zmodyfikowaną metoda Brenta i metodę „złotego podziału”.
