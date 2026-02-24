set terminal pdfcairo enhanced color font "Verdana,10" size 4,3
set output "ex2vsex3.pdf"
set grid
set title "van der Pol Oscillator: u(t) vs t"
set grid
set title "van der Pol Oscillator: u(t) vs t"
set xlabel "t"
set ylabel "u(t)"

plot "ex2.txt" using 1:2 with points pt 6 ps 0.3 title "Ex 2 (Adaptive Steps)", \
     "ex3.txt" using 1:2 with points pt 5 ps 0.5 title "Ex 3 (Fixed Internal)"
