set terminal pdfcairo enhanced color font 'Verdana,12' size 5.0,3.0
set output "fig3.pdf"
set border 3 lw 1
set tics nomirror out scale 1
set key right top nobox
set xlabel "Iteration Number"
set ylabel "Absolute Error"
set logscale y
set grid
plot "error_bisection.txt" using 1:2 with lines lw 2 lc rgb "blue" title "Bisection Method", \
     "error_newton.txt" using 1:2 with lines lw 2 lc rgb "red" title "Newton Method"
