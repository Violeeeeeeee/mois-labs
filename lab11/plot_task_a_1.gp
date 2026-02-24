set terminal pdfcairo enhanced color font "Verdana,10" size 4,3
set output "ex1vsex2.pdf"
set grid
set title "van der Pol Oscillator: u(t) vs t"
set xlabel "t"
set ylabel "u(t)"

# Using points instead of lines to clearly see the step distributions
plot "ex1.txt" using 1:2 with points pt 7 ps 0.5 title "Ex 1 (Fixed Output)", \
     "ex2.txt" using 1:2 with points pt 6 ps 0.3 title "Ex 2 (Adaptive Steps)",
