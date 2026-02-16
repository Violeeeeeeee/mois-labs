set terminal pdfcairo enhanced color font 'Verdana,10' size 5,3
set grid
set xlabel "Matrix size (N)"
set ylabel "Time [s]"

set output 'decomp_plot.pdf'
set title "Złożoność czasowa dekompozycji LU (O(N^3))"
plot "data.txt" skip 1 using 1:2 with linespoints lw 2 pt 7 lc rgb "red" title "Czas Dekompozycji"

set output 'solve_plot.pdf'
set title "Złożoność czasowa rozwiązywania układu (O(N^2))"
plot "data.txt" skip 1 using 1:3 with linespoints lw 2 pt 7 lc rgb "blue" title "Czas Rozwiązywania"

set output 'combined_log_plot.pdf'
set title "Porównanie czasów (Skala Logarytmiczna)"
set logscale y
plot "data.txt" skip 1 using 1:2 with linespoints lw 2 lc rgb "red" title "Dekompozycja", \
     "data.txt" skip 1 using 1:3 with linespoints lw 2 lc rgb "blue" title "Rozwiązywanie"
