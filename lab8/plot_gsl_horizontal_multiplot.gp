set terminal pdfcairo enhanced color font "Verdana,10" size 10,3
set output "gsl_methods_error_multiplot.pdf"

# Global settings for all plots
set grid
set logscale x
set logscale y
set key box opaque top right
set format y "10^{%L}"  # Format y-axis nicely for log scale

# Define margins and spacing for the multiplot layout
MP_LEFT = 0.07
MP_RIGHT = 0.98
MP_BOTTOM = 0.15
MP_TOP = 0.88
MP_xGAP = 0.08
MP_yGAP = 0.0

# Start multiplot
set multiplot layout 1,3 rowsfirst title "{/:Bold=12 Error vs. Number of Function Calls for GSL Methods}" \
              margins screen MP_LEFT, MP_RIGHT, MP_BOTTOM, MP_TOP \
              spacing screen MP_xGAP, MP_yGAP

# --- Plot 1: f1 ---
set title "f_1(x) = x^2 + x + 1"
set xlabel "Number of Calls"
set ylabel "Estimated Error"
plot "gsl_data_f1.txt" using 1:2 with linespoints title "PLAIN", \
     "gsl_data_f1.txt" using 1:3 with linespoints title "MISER", \
     "gsl_data_f1.txt" using 1:4 with linespoints title "VEGAS"

# --- Plot 2: f2 ---
set title "f_2(x) = sqrt(1-x^2)"
set xlabel "Number of Calls"
set ylabel "" # Clear y-label to save space, but keep ytics because scales differ
plot "gsl_data_f2.txt" using 1:2 with linespoints title "PLAIN", \
     "gsl_data_f2.txt" using 1:3 with linespoints title "MISER", \
     "gsl_data_f2.txt" using 1:4 with linespoints title "VEGAS"

# --- Plot 3: f3 ---
set title "f_3(x) = 1/sqrt(x)"
set xlabel "Number of Calls"
set ylabel ""
plot "gsl_data_f3.txt" using 1:2 with linespoints title "PLAIN", \
     "gsl_data_f3.txt" using 1:3 with linespoints title "MISER", \
     "gsl_data_f3.txt" using 1:4 with linespoints title "VEGAS"

unset multiplot
