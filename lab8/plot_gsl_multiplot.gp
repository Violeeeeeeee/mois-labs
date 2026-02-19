set terminal pdfcairo enhanced color font "Verdana,10" size 5,9
set output "gsl_methods_error_combined.pdf"

# Define explicit margins and spacing for the multiplot
MP_LEFT = 0.15
MP_RIGHT = 0.95
MP_BOTTOM = 0.08
MP_TOP = 0.95
MP_xGAP = 0.05
MP_yGAP = 0.08

# Start multiplot (3 rows, 1 column)
set multiplot layout 3,1 \
    margins screen MP_LEFT, MP_RIGHT, MP_BOTTOM, MP_TOP \
    spacing screen MP_xGAP, MP_yGAP

set grid
set logscale x
set logscale y
set key right top opaque
set ylabel "Estimated Error"

# Plot 1: Top (f1)
set title "GSL Methods Error: f_1(x) = x^2 + x + 1"
unset xlabel
set format x "" # Hide X-axis numbers for cleaner stacking
plot "gsl_data_f1.txt" using 1:2 with linespoints title "PLAIN", \
     "gsl_data_f1.txt" using 1:3 with linespoints title "MISER", \
     "gsl_data_f1.txt" using 1:4 with linespoints title "VEGAS"

# Plot 2: Middle (f2)
set title "GSL Methods Error: f_2(x) = sqrt(1-x^2)"
plot "gsl_data_f2.txt" using 1:2 with linespoints title "PLAIN", \
     "gsl_data_f2.txt" using 1:3 with linespoints title "MISER", \
     "gsl_data_f2.txt" using 1:4 with linespoints title "VEGAS"

# Plot 3: Bottom (f3)
set title "GSL Methods Error: f_3(x) = 1/sqrt(x)"
set xlabel "Number of Calls"
set format x "%h" # Restore X-axis numbers for the bottom plot
plot "gsl_data_f3.txt" using 1:2 with linespoints title "PLAIN", \
     "gsl_data_f3.txt" using 1:3 with linespoints title "MISER", \
     "gsl_data_f3.txt" using 1:4 with linespoints title "VEGAS"

unset multiplot
