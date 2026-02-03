set terminal pngcairo size 800,600 enhanced font 'Verdana,10'
set output "fig1.png"
set title "Function f(x) = x^2 - 5"
set xlabel "x"
set ylabel "f(x)"
set xrange [0:5]
set yrange [-6:5]
set grid
set xzeroaxis lw 2
f1(x) = x**2 - 5
plot f1(x) lw 2 lc rgb "blue" title "f(x) = x^2 - 5"
