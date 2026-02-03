set terminal pngcairo size 800,600 enhanced font 'Verdana,10'
set output "fig2.png"
set title "Function f(x) = (x-1)^2"
set xlabel "x"
set ylabel "f(x)"
set xrange [-1:3]
set yrange [-0.5:4]
set grid
set xzeroaxis lw 2
f2(x) = (x-1)**2
plot f2(x) lw 2 lc rgb "dark-green" title "f(x) = (x-1)^2"
