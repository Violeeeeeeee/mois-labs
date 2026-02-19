# save as plot_hit_miss.gp
set terminal pngcairo size 800,600
set output 'hit_and_miss_error.png'

set title 'Hit-and-Miss Integration Error vs. Number of Trials'
set xlabel 'Number of Trials (N)'
set ylabel 'Absolute Error'

# Use logarithmic scale as requested
set logscale x
set logscale y
set grid

plot 'hit_miss_data.txt' using 1:2 with linespoints title 'f(x) = x^2 + x + 1', \
     'hit_miss_data.txt' using 1:3 with linespoints title 'f(x) = sqrt(1-x^2)'
