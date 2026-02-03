set terminal pngcairo size 800,600 enhanced font 'Verdana,10'
set output "fig3.png"
set terminal pngcairo size 1000,600 enhanced font 'Verdana,10'
set title "Convergence Speed Comparison: Newton vs Bisection"
set xlabel "Iteration Number"
set ylabel "Absolute Error |x - root| (log scale)"
set logscale y
set grid
set key right top

plot "error_bisection.txt" using 1:2 with linespoints lw 2 pt 7 lc rgb "blue" title "Bisection Method", \
     "error_newton.txt" using 1:2 with linespoints lw 2 pt 7 lc rgb "red" title "Newton Method"
