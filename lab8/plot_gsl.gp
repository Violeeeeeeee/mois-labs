# save as plot_gsl.gp
set terminal pngcairo size 800,600
set output 'gsl_methods_error.png'

set title 'Error vs. Number of Function Calls for GSL Methods'
set xlabel 'Number of Calls'
set ylabel 'Estimated Error'
set logscale x
set logscale y
set grid

plot 'gsl_data.txt' using 1:2 with linespoints title 'PLAIN', \
     'gsl_data.txt' using 1:3 with linespoints title 'MISER', \
     'gsl_data.txt' using 1:4 with linespoints title 'VEGAS'
