set terminal pdfcairo enhanced color font "Verdana,10" size 10,4
set output "signal_analysis_1x2.pdf"

# Define explicit margins and spacing
MP_LEFT = 0.10
MP_RIGHT = 0.95
MP_BOTTOM = 0.15
MP_TOP = 0.85
MP_xGAP = 0.10
MP_yGAP = 0.05

set multiplot layout 1,2 \
    margins screen MP_LEFT, MP_RIGHT, MP_BOTTOM, MP_TOP \
    spacing screen MP_xGAP, MP_yGAP \
    title "{/:Bold=12 Signal and Frequency Spectrum Analysis}"

set grid
set key right top opaque
set xrange [0:300]
set xlabel "Sample Index (n)"

# Plot 1: Generated Signal
set title "Generated Signal"
set ylabel "Amplitude"
plot "signal.txt" using 1:2 with linespoints pt 1 ps 0.4 lc rgb "purple" title "Signal"

# Plot 2: Frequency Spectrum
set title "Frequency Spectrum"
set ylabel "Magnitude"
set yrange [-20:140]
plot "spectrum.txt" using 1:2 with linespoints pt 1 ps 0.4 lc rgb "blue" title "Spectrum"

unset multiplot
