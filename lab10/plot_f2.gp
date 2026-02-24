set terminal pdfcairo enhanced color font "Verdana,10" size 5,4
set output "f2_plot.pdf"
set grid
set title "Function 2: f(x) = e^{-x} - sin(x) + sqrt(x)"
set xlabel "x"
set ylabel "f(x)"
plot "f2_data.txt" using 1:2 with lines lw 2 lc rgb "red" title "f(x)"
