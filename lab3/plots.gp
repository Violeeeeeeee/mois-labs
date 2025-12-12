set terminal jpeg size 1600,500
set output "out.jpg"

set grid

set xlabel "X"
set ylabel "Y"

set xrange [-1:1]
set yrange [-1:2]

# Funkcja analityczna (wzór)
f(x) = 1.0 / (1.0 + 25.0 * x * x)

# labels
l0 = "Analytical function 1/(1+25x^2)"
l1 = "Multivariable Interpolation"
l2 = "Nodes"
l3 = "CSpline"
l4 = "Linear"
set label
set key left

set multiplot layout 1,3 columns

plot f(x) with lines lw 2 lt rgb "black" t l0, \
    "inter_poly.txt" with lines lw 2 lt rgb "red" t l1, \
    "values.txt" with points pointtype 7 pointsize 1.5 lc rgb "black" t l2

plot f(x) with lines lw 2 lt rgb "black" t l0, \
    "inter_cspline.txt" with lines lw 2 lt rgb "blue" t l3, \
    "values.txt" with points pointtype 7 pointsize 1.5 lc rgb "black" t l2

plot f(x) with lines lw 2 lt rgb "black" t l0, \
    "inter_linear.txt" with lines lw 2 lt rgb "green" t l4, \
    "values.txt" with points pointtype 7 pointsize 1.5 lc rgb "black" t l2

unset multiplot
