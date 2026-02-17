set terminal pdfcairo enhanced color font 'Verdana,10' size 5,3
set grid
set xlabel "Matrix size (N)"
set ylabel "Time [s]"

# Wykres 1: Dekompozycja
set output 'decomp_plot.pdf'
set title "LU Decomposition Time Complexity (O(N^3))"
plot "data.txt" skip 1 using 1:2 with linespoints lw 2 pt 7 lc rgb "red" title "Decomposition Time"

# Wykres 2: Rozwiązywanie
set output 'solve_plot.pdf'
set title "Solving Time Complexity (O(N^2))"
plot "data.txt" skip 1 using 1:3 with linespoints lw 2 pt 7 lc rgb "blue" title "Solving Time"

# Wykres 3: Porównanie (skala logarytmiczna)
set output 'combined_log_plot.pdf'
set title "Time Comparison (Logarithmic Scale)"
set logscale y
plot "data.txt" skip 1 using 1:2 with linespoints lw 2 lc rgb "red" title "Decomposition", \
     "data.txt" skip 1 using 1:3 with linespoints lw 2 lc rgb "blue" title "Solving"
