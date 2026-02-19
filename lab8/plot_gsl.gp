set terminal pdfcairo enhanced color font "Verdana,10" size 5,4

set grid
set logscale x
set logscale y
set xlabel "Number of Calls"
set ylabel "Estimated Error"

# Plot for f1
set output "gsl_methods_error_f1.pdf"
set title "GSL Methods Error: f_1(x) = x^2 + x + 1"
plot "gsl_data_f1.txt" using 1:2 with linespoints title "PLAIN", \
     "gsl_data_f1.txt" using 1:3 with linespoints title "MISER", \
     "gsl_data_f1.txt" using 1:4 with linespoints title "VEGAS"

# Plot for f2
set output "gsl_methods_error_f2.pdf"
set title "GSL Methods Error: f_2(x) = sqrt(1-x^2)"
plot "gsl_data_f2.txt" using 1:2 with linespoints title "PLAIN", \
     "gsl_data_f2.txt" using 1:3 with linespoints title "MISER", \
     "gsl_data_f2.txt" using 1:4 with linespoints title "VEGAS"

# Plot for f3
set output "gsl_methods_error_f3.pdf"
set title "GSL Methods Error: f_3(x) = 1/sqrt(x)"
plot "gsl_data_f3.txt" using 1:2 with linespoints title "PLAIN", \
     "gsl_data_f3.txt" using 1:3 with linespoints title "MISER", \
     "gsl_data_f3.txt" using 1:4 with linespoints title "VEGAS"
