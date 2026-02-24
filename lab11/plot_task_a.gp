set terminal pdfcairo enhanced color font "Verdana,10" size 7,9
set output "part_a_vanderpol_comparison.pdf"

# Define margins for the 3x1 layout
set multiplot layout 3,1 title "{/:Bold=14 van der Pol Oscillator: Step Distribution Comparison}" \
              margins 0.12, 0.95, 0.08, 0.92 spacing 0.0, 0.08

set grid
set ylabel "u(t)"
set xrange [0:100]
set yrange [-3:3]

set title "Ex 1: Adaptive Solver (Forced 100 Evenly Spaced Outputs)"
unset xlabel
set format x ""  # Hide x-axis labels for the top plot
plot "ex1.txt" using 1:2 with linespoints pt 7 ps 0.5 lc rgb "blue" title ""

set title "Ex 2: Low-Level Stepper (Outputs EVERY Adaptive Internal Step)"
unset xlabel
set format x ""  # Hide x-axis labels for the middle plot
plot "ex2.txt" using 1:2 with linespoints pt 7 ps 0.2 lc rgb "red" title ""

set title "Ex 3: Fixed-Step Solver (Forced 100 Evenly Spaced Outputs)"
set xlabel "t"
set format x "%g" # Restore x-axis labels for the bottom plot
plot "ex3.txt" using 1:2 with linespoints pt 7 ps 0.5 lc rgb "forest-green" title ""

unset multiplot

set terminal pdfcairo enhanced color font "Verdana,10" size 4,3
set output "part_a_vanderpol.pdf"
set grid
set title "van der Pol Oscillator: u(t) vs t"
set xlabel "t"
set ylabel "u(t)"

# Using points instead of lines to clearly see the step distributions
plot "ex1.txt" using 1:2 with points pt 7 ps 0.3 title "Ex 1 (Fixed Output)", \
     "ex2.txt" using 1:2 with points pt 6 ps 0.3 title "Ex 2 (Adaptive Steps)",

set terminal pdfcairo enhanced color font "Verdana,10" size 4,3
set output "part_a_vanderpol.pdf"
set grid
set title "van der Pol Oscillator: u(t) vs t"
set xlabel "t"
set ylabel "u(t)"

plot "ex1.txt" using 1:2 with points pt 7 ps 0.3 title "Ex 1 (Fixed Output)", \
     "ex3.txt" using 1:2 with points pt 5 ps 0.3 title "Ex 3 (Fixed Internal)"

set terminal pdfcairo enhanced color font "Verdana,10" size 4,3
set output "part_a_vanderpol.pdf"
set grid
set title "van der Pol Oscillator: u(t) vs t"
set xlabel "t"
set ylabel "u(t)"

plot "ex2.txt" using 1:2 with points pt 6 ps 0.3 title "Ex 2 (Adaptive Steps)", \
     "ex3.txt" using 1:2 with points pt 5 ps 0.3 title "Ex 3 (Fixed Internal)"
