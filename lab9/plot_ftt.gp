set terminal pdfcairo enhanced color font "Verdana,10" size 6,4
set grid
set key right top opaque

# Task 1
set output "1_signal.pdf"
set title "Generated Signal"
plot "signal.txt" using 1:2 with linespoints pt 1 lc rgb "purple" title "Signal"

# Task 2
set output "2_spectrum.pdf"
set title "Frequency Spectrum"
plot "spectrum.txt" using 1:2 with impulses lw 2 lc rgb "blue" title "Spectrum", \
     "spectrum.txt" using 1:2 with points pt 2 lc rgb "blue" title ""

# Task 3
set output "3_noisy_signal.pdf"
set title "Noisy Signal"
plot "noisy_signal.txt" using 1:2 with linespoints pt 1 lc rgb "purple" title "Noise"

# Task 4
set output "4_noisy_spectrum.pdf"
set title "Spectrum of Noisy Signal"
plot "noisy_spectrum.txt" using 1:2 with impulses lw 2 lc rgb "blue" title "Noise Spectrum", \
     "noisy_spectrum.txt" using 1:2 with points pt 2 lc rgb "blue" title ""

# Task 5
set output "5_filtered_spectrum.pdf"
set title "Spectrum after Zeroing Noise (< 50)"
plot "filtered_spectrum.txt" using 1:2 with impulses lw 2 lc rgb "blue" title "Filtered", \
     "filtered_spectrum.txt" using 1:2 with points pt 2 lc rgb "blue" title ""

# Task 6
set output "6_inverse_signal.pdf"
set title "Signal after Inverse Transform (Inversion)"
plot "inverse_signal.txt" using 1:2 with linespoints pt 1 lc rgb "purple" title "Inversion"
