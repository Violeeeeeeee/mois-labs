set terminal pngcairo size 800,600 enhanced font 'Verdana,10'
set output 'matrix_timing.png'

set title "Zależność czasu obliczeń od rozmiaru układu równań (GSL LU)"
set xlabel "Rozmiar macierzy (N)"
set ylabel "Czas procesora [s]"
set grid
set key left top

# Ustawienie stylów linii
set style line 1 lc rgb 'red' lw 2 pt 7
set style line 2 lc rgb 'blue' lw 2 pt 5

plot "results.txt" using 1:2 title "Dekompozycja LU (O(N^3))" w lp ls 1, \
     "results.txt" using 1:3 title "Rozwiązywanie (O(N^2))" w lp ls 2
