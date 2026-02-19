set terminal pdfcairo enhanced color font "Verdana,10" size 10,8
set output "noise_filtering_2x2.pdf"

# Define explicit margins and spacing
MP_LEFT = 0.10
MP_RIGHT = 0.95
MP_BOTTOM = 0.10
MP_TOP = 0.92
MP_xGAP = 0.12
MP_yGAP = 0.15

set multiplot layout 2,2 columnsfirst \
    margins screen MP_LEFT, MP_RIGHT, MP_BOTTOM, MP_TOP \
    spacing screen MP_xGAP, MP_yGAP \
    title "{/:Bold=12 Noise Simulation and Signal Reconstruction}"

set grid
set key right top opaque
set xrange [0:300]

# --- Column 1: Time Domain ---

# Top-Left: Noisy Signal
set title "Noisy Signal"
set ylabel "Amplitude"
set yrange [-1.5:1.5]
unset xlabel
plot "noisy_signal.txt" using 1:2 with linespoints pt 1 ps 0.4 lc rgb "purple" title "Noise"

# Bottom-Left: Inverse Signal
set title "Signal after Inverse Transform (Inversion)"
set ylabel "Amplitude"
set yrange [-1:1]
set xlabel "Sample Index (n)"
plot "inverse_signal.txt" using 1:2 with linespoints pt 1 ps 0.4 lc rgb "purple" title "Inversion"

# --- Column 2: Frequency Domain ---

# Top-Right: Noisy Spectrum
set title "Spectrum of Noisy Signal"
set ylabel "Magnitude"
set yrange [-20:140]
unset xlabel
plot "noisy_spectrum.txt" using 1:2 with linespoints pt 1 ps 0.4 lc rgb "blue" title "Noise Spectrum"

# Bottom-Right: Filtered Spectrum
set title "Spectrum after Zeroing Noise (< 50)"
set ylabel "Magnitude"
set yrange [-20:140]
set xlabel "Frequency Index (k)"
plot "filtered_spectrum.txt" using 1:2 with linespoints pt 1 ps 0.4 lc rgb "blue" title "Filtered"

unset multiplot
