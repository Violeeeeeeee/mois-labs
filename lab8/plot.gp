set terminal pdfcairo enhanced color font 'Verdana,10' size 5,3
set grid
set xlabel "Matrix size (N)"
set ylabel "Time [s]"
set key left top opaque

f(x) = a * x**3
g(x) = b * x**2

fit f(x) "data.txt" skip 1 using 1:2 via a
fit g(x) "data.txt" skip 1 using 1:3 via b

set output 'decomp_plot.pdf'
set title "LU Decomposition: Measurement vs Theory O(N^3)"
plot "data.txt" skip 1 using 1:2 with points lw 1 pt 7 lc rgb "red" title "Measured Time", \
     f(x) with lines lt 2 lc rgb "black" title sprintf("Theory O(N^3), a=%.1e", a)

set output 'solve_plot.pdf'
set title "Solving: Measurement vs Theory O(N^2)"
plot "data.txt" skip 1 using 1:3 with points lw 1 pt 7 lc rgb "blue" title "Measured Time", \
     g(x) with lines lt 2 lc rgb "black" title sprintf("Theory O(N^2), b=%.1e", b)

set output 'combined_log_plot.pdf'
set title "Time Comparison (Logarithmic Scale)"
set logscale y
plot "data.txt" skip 1 using 1:2 with linespoints lw 2 lc rgb "red" title "Decomposition", \
     "data.txt" skip 1 using 1:3 with linespoints lw 2 lc rgb "blue" title "Solving"
