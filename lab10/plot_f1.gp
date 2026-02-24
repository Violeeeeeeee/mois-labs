set terminal pdfcairo enhanced color font "Verdana,10" size 5,4
set output "f1_plot.pdf"
set grid
set title "Function 1: f(x) = cos(x) + 1"
set xlabel "x"
set ylabel "f(x)"
plot "f1_data.txt" using 1:2 with lines lw 2 lc rgb "blue" title "f(x)"
