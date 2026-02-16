set terminal pdfcairo enhanced color font 'Verdana,12' size 5.0,3.0
set output "fig2.pdf"
set border 3 lw 1
set tics nomirror out scale 1
set key right top nobox
set xlabel "x"
set ylabel "f(x)"
set xrange [-1:3]
set yrange [-0.5:4]
set grid
set xzeroaxis lw 1
set yzeroaxis lw 1
f2(x) = (x-1)**2
plot f2(x) lw 2 lc rgb "dark-green" title "f(x) = (x-1)^2"
