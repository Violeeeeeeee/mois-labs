set output "zad2.jpeg"
set terminal jpeg

set logscale x
set grid

set xlabel "logscale"
label1 = "data form dane1.dat"
set label
set key box right

plot 'dane1.dat' axes x1y1 w lines lt 1 lw 2 lc rgb "blue" title label1
