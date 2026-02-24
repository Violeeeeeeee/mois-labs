set terminal pdfcairo enhanced color font "Verdana,10" size 6,4
set output "part_b_comparison.pdf"
set grid
set key top left opaque

set title "Numerical Solutions vs Exact Solution"
set xlabel "x"
set ylabel "y(x)"

plot "task_b_exact.txt" using 1:2 with lines lw 3 lc rgb "black" title "Exact Solution", \
     "task_b_rk4.txt" using 1:2 with points pt 7 ps 0.6 lc rgb "blue" title "Runge-Kutta 4", \
     "task_b_euler.txt" using 1:2 with linespoints pt 6 ps 0.6 lc rgb "red" title "Euler Method"
