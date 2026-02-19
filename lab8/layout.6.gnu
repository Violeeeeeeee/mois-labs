# set terminal pngcairo  transparent enhanced font "arial,10" fontscale 1.0 size 600, 400 
# set output 'layout.6.png'
set format y "%.1f" 
set key fixed right top vertical Right noreverse enhanced autotitle box lt black linewidth 1.000 dashtype solid
set key opaque
unset ytics
set trange [ * : * ] noreverse nowriteback
set urange [ * : * ] noreverse nowriteback
set vrange [ * : * ] noreverse nowriteback
set xlabel "xlabel" 
set xrange [ -6.28319 : 6.28319 ] noreverse nowriteback
set x2range [ * : * ] noreverse writeback
set yrange [ * : * ] noreverse writeback
set y2range [ * : * ] noreverse writeback
set zrange [ * : * ] noreverse writeback
set cbrange [ * : * ] noreverse writeback
set rrange [ * : * ] noreverse writeback
set colorbox vertical origin screen 0.9, 0.2 size screen 0.05, 0.6 front  noinvert bdefault
VERSION = "gnuplot version 6.0.3"
NO_ANIMATION = 1
MP_LEFT = 0.1
MP_RIGHT = 0.95
MP_BOTTOM = 0.14
MP_TOP = 0.9
MP_xGAP = 0.05
MP_yGAP = 0.02
## Last datafile plotted: "immigration.dat"
## Last plot was a multiplot
# saved multiplot
set multiplot layout 2,2 columnsfirst title "{/:Bold=15 Multiplot with explicit page margins}"               margins screen MP_LEFT, MP_RIGHT, MP_BOTTOM, MP_TOP spacing screen MP_xGAP, MP_yGAP
set format y "%.1f"
set key box opaque
set ylabel 'ylabel'
set xrange [-2*pi:2*pi]
plot sin(x) lt 1
set xlabel 'xlabel'
plot cos(x) lt 2
unset ylabel
unset ytics
unset xlabel
plot sin(2*x) lt 3
set xlabel 'xlabel'
plot cos(2*x) lt 4
unset multiplot
