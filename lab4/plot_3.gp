set terminal jpeg size 1200,800
set grid
set key outside top center horizontal

set output "plot1.jpg"
set title "Aproksymacja f(x) = exp(x)*cos(0.5*x^2)"
set xlabel "x"
set ylabel "y"
plot "data_f1.txt" using 1:2 w lines lw 3 lc rgb "black" t "Oryginał", \
     "" using 1:3 w lines lw 2 lc rgb "red" t "n=3", \
     "" using 1:4 w lines lw 2 lc rgb "blue" t "n=10", \
     "" using 1:5 w lines lw 2 lc rgb "green" t "n=40"

set output "plot2.jpg"
set title "Aproksymacja f(x) = 1/(12*x^2+1)"
plot "data_f2.txt" using 1:2 w lines lw 3 lc rgb "black" t "Oryginał", \
     "" using 1:3 w lines lw 2 lc rgb "red" t "n=3", \
     "" using 1:4 w lines lw 2 lc rgb "blue" t "n=10", \
     "" using 1:5 w lines lw 2 lc rgb "green" t "n=40"

set output "plot_extra.jpg"
set title "Zadanie dodatkowe: f(x) = cos(x) + 0.1*sin(50x)"
set xrange [0:10]
plot "data_extra.txt" using 1:2 w lines lw 1 lc rgb "#AAAAAA" t "Oryginał (szum)", \
     "" using 1:5 w lines lw 3 lc rgb "red" t "Aproksymacja n=40"
