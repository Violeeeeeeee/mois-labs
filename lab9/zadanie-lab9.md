Szybka transformata Fouriera
Materiały

1. [Szybka transformata Fouriera w gsl](https://www.gnu.org/software/gsl/doc/html/fft.html)
2. [FFT a obróbka sygnałów](http://artemis.wszib.edu.pl/~funika/mois/lab9/FFT2.htm)
3. [Szybka transformata Fouriera](http://wazniak.mimuw.edu.pl/index.php?title=MN10)

Zadania

1. Proszę wygenerować 256-elementową tablicę wartości funkcji będącej sumą czterech cosinusów o różnych okresach i amplitudach, korzystając np. z wzoru: data[i]=cos(4*Pi*i/N)+cos(16*Pi*i/N)/5+cos(32*Pi*i/N)/8+cos(128*Pi*i/N)/16 gdzie N = 256. Narysować wykres tej funkcji korzystając z Gnuplota. Tę funkcję nazywamy sygnałem.
2. Proszę użyć funkcji gsl_fft_real_radix2_transform do otrzymania transformaty Fouriera sygnału. Narysować wykres słupkowy tej transformaty. Czy na tym wykresie widać związek z częstotliwościami i amplitudami cosinusów wchodzących w skład funkcji? Ten wykres nazywamy widmem częstotliwości. (przykładowy kod) fft_example.c
3. Teraz wypełniamy tablicę wartościami funkcji cosinus zaburzonej niewielkim "szumem", np. korzystając z wzoru: data[i]=cos(4*Pi*i/N)+((float)rand())/RAND_MAX/8.0 Proszę narysować wykres tej funkcji.
4. Narysować wykres transformaty Fouriera tego sygnału (jak w punkcie 2).
5. Po transformacie wyzerować w widmie wszystkie elementy, których wartość bezwzględna jest mniejsza niż 50. W ten sposób usuwamy "szumy" z sygnału.
6. Użyć funkcji gsl_fft_halfcomplex_radix2_inverse do przeprowadzenia odwrotnej transformaty. Narysować wykres otrzymanej funkcji. Czym różni się ona od wyjściowego sygnału?

Przykładowe wykresy fft-plot.pdf
