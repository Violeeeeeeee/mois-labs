set output "zad3.jpeg"
set terminal jpeg

set grid

# searching for max value and for index
stats 'dane2.dat' using 3 name "VAL"
# VAL_max       -> value (1.0)
# VAL_index_max -> index (396)

# X for this row
# "every ::Start::End" - taking only one row
stats 'dane2.dat' using 1 every ::VAL_index_max::VAL_index_max name "POS_X"
target_x = POS_X_min

# Y for this row
stats 'dane2.dat' using 2 every ::VAL_index_max::VAL_index_max name "POS_Y"
target_y = POS_Y_min

# output
print sprintf("Max Value: %f found at Index: %d", VAL_max, VAL_index_max)
print sprintf("Coordinates are X: %f, Y: %f", target_x, target_y)


stats 'dane2.dat' using 1 name "X_AXIS"
set xrange [X_AXIS_min:X_AXIS_max]
set yrange [0:7]

set style line 1 pointtype 7 linecolor rgb '#22aa22' pointsize 2

# labels
label1 = "data from dane2.dat"
label2 = "max value"
set label
set key box left

# https://stackoverflow.com/a/19457387
plot 'dane2.dat' using 1:2 axes x1y1 w lines lt 1 lw 1 lc rgb "blue" title label1, \
     '+' using ($0 == 0 ? target_x : NaN):(target_y):(sprintf('Max: %.2f', VAL_max)) \
     with labels offset char 1,-0.5 left textcolor rgb 'red' \
     point linestyle 1 title label2
