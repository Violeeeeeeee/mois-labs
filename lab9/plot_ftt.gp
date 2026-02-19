set terminal pdfcairo enhanced color font "Verdana,10" size 4,3
set grid
set key right top opaque

set xrange [0:256]

# Task 1
set output "1_signal.pdf"
set title "Generated Signal"
plot "signal.txt" using 1:2 with linespoints pt 1 ps 0.5 lc rgb "purple" title "Signal"

# Task 2
set output "2_spectrum.pdf"
set title "Frequency Spectrum"
set yrange [-20:140]
plot "spectrum.txt" using 1:2 with linespoints pt 1 ps 0.5 lc rgb "blue" title "Spectrum"

# Task 3
set output "3_noisy_signal.pdf"
set title "Noisy Signal"
set yrange [-1.5:1.5]
plot "noisy_signal.txt" using 1:2 with linespoints pt 1 ps 0.5 lc rgb "purple" title "Noise"

# Task 4
set output "4_noisy_spectrum.pdf"
set title "Spectrum of Noisy Signal"
set yrange [-20:140]
plot "noisy_spectrum.txt" using 1:2 with linespoints pt 1 ps 0.5 lc rgb "blue" title "Noise Spectrum"

# Task 5
set output "5_filtered_spectrum.pdf"
set title "Spectrum after Zeroing Noise (< 50)"
set yrange [-20:140]
plot "filtered_spectrum.txt" using 1:2 with linespoints pt 1 ps 0.5 lc rgb "blue" title "Filtered"

# Task 6
set output "6_inverse_signal.pdf"
set title "Signal after Inverse Transform (Inversion)"
set yrange [-1:1]
plot "inverse_signal.txt" using 1:2 with linespoints pt 1 ps 0.5 lc rgb "purple" title "Inversion"
