set terminal jpeg size 1200,800
set output "apr.jpg"
set grid
set key outside top center horizontal

set xlabel "x"
set ylabel "y"
set multiplot layout 1,3 columns

plot "dane1.dat" using 1:2 w lines lw 3 lc rgb "red" t "dane1.dat"
plot "dane2.dat" using 1:2 w lines lw 3 lc rgb "green" t "dane2.dat"
plot "dane3.dat" using 1:2 w lines lw 1 lc rgb "blue" t "dane3.dat"

unset multiplot
