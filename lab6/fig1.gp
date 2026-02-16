set terminal pdfcairo enhanced color font 'Verdana,12' size 5.0,3.0
set output "fig1.pdf"
set border 3 lw 1
set tics nomirror out scale 1
set samples 50,50
set key right top nobox
set xlabel "x"
set ylabel "f(x)"
set xrange [0:5]
set yrange [-6:6]
set grid
set xzeroaxis lw 1
set yzeroaxis lw 1
f1(x) = x**2 - 5
plot f1(x) lw 2 lc rgb "blue" title "f(x) = x^2 - 5"
