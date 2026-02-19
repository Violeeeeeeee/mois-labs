# set terminal pngcairo  transparent enhanced font "arial,8" fontscale 1.0 size 610, 480 
# set output 'multiplt.1.png'
set dummy wnt, y
set grid nopolar
set grid xtics nomxtics ytics nomytics noztics nomztics nortics nomrtics \
 nox2tics nomx2tics noy2tics nomy2tics nocbtics nomcbtics
set grid layerdefault   lt 0 linecolor 0 linewidth 0.500,  lt 0 linecolor 0 linewidth 0.500
unset key
set label 1 "" at 0.140000, 17.0000, 0.00000 left norotate back nopoint
set samples 250, 250
set size ratio 0 0.5,0.5
set origin 0.5,0
set mxtics 10
set mytics 5
set xtics  norangelimit 0.00000,5 ,20.0000
set ytics  norangelimit -1.00000,0.5 ,1.00000
set title "Second Order System - Unit Impulse Response" 
set trange [ * : * ] noreverse nowriteback
set urange [ * : * ] noreverse nowriteback
set vrange [ * : * ] noreverse nowriteback
set xlabel "Normalized Time (wnt)" 
set xrange [ 0.00000 : 20.0000 ] noreverse nowriteback
set x2range [ * : * ] noreverse writeback
set ylabel "Amplitude y(wnt)" 
set ylabel  offset character 1, 0, 0 font "" textcolor lt -1 rotate
set yrange [ -1.00000 : 1.00000 ] noreverse nowriteback
set y2range [ * : * ] noreverse writeback
set zrange [ * : * ] noreverse writeback
set cbrange [ * : * ] noreverse writeback
set rrange [ * : * ] noreverse writeback
set colorbox vertical origin screen 0.9, 0.2 size screen 0.05, 0.6 front  noinvert bdefault
mag(w) = -10*log10( (1-w**2)**2 + 4*(zeta*w)**2)
tmp(w) = (-180/pi)*atan( 2*zeta*w/(1-w**2) )
tmp1(w)= w<1?tmp(w):(tmp(w)-180)
phi(w)=zeta==1?(-2*(180/pi)*atan(w)):tmp1(w)
wdwn(zeta)=sqrt(1-zeta**2)
shift(zeta) = atan(wdwn(zeta)/zeta)
alpha(zeta)=zeta>1?sqrt(zeta**2-1.0):0
tau1(zeta)=1/(zeta-alpha(zeta))
tau2(zeta)=1/(zeta+alpha(zeta))
c1(zeta)=(zeta + alpha(zeta))/(2*alpha(zeta))
c2(zeta)=c1(zeta)-1
y1(wnt)=zeta==1?1 - exp(-wnt)*(wnt + 1):0
y2(wnt)=zeta<1?(1 - (exp(-zeta*wnt)/wdwn(zeta))*sin(wdwn(zeta)*wnt + shift(zeta))):y1(wnt)
y(wnt)=exp(-zeta*wnt) * sin(wdwn(zeta)*wnt) / wdwn(zeta)
VERSION = "gnuplot version 6.0.3"
NO_ANIMATION = 1
zeta = 2
## Last plot was a multiplot
# saved multiplot
set multiplot
set size 0.5,0.5
set origin 0.0,0.5
set grid
unset key
set angles radians
set samples 250
set xtics auto
set mxtics default
set ytics auto
set mytics default
set title "Second Order System Transfer Function - Magnitude"
mag(w) = -10*log10( (1-w**2)**2 + 4*(zeta*w)**2)
set dummy w
set logscale x
set xlabel "Frequency (w/wn)"
set ylabel "Magnitude (dB)" offset 1,0
set label 1 "Damping =.1,.2,.3,.4,.5,.707,1.0,2.0" at .14,17
set xrange [.1:10]
set yrange [-40:20]
plot   zeta=.1,mag(w),   zeta=.2,mag(w),   zeta=.3,mag(w),   zeta=.4,mag(w),   zeta=.5,mag(w),   zeta=.707,mag(w),   zeta=1.0,mag(w),   zeta=2.0,mag(w),-6
set size 0.5,0.5
set origin 0.0,0.0
set title "Second Order System Transfer Function - Phase"
set label 1 ""
set ylabel "Phase (deg)" offset 1,0
set ytics -180, 30, 0 
set yrange [-180:0]
tmp(w) = (-180/pi)*atan( 2*zeta*w/(1-w**2) )
tmp1(w)= w<1?tmp(w):(tmp(w)-180)
phi(w)=zeta==1?(-2*(180/pi)*atan(w)):tmp1(w)
plot   zeta=.1,phi(w),   zeta=.2,phi(w),   zeta=.3,phi(w),   zeta=.4,phi(w),   zeta=.5,phi(w),   zeta=.707,phi(w),   zeta=1,phi(w),   zeta=2.0,phi(w),   -90
set size 0.5,0.5
set origin 0.5,0.5
set dummy wnt
unset logscale x
set title "Second Order System - Unit Step Response"
set ylabel "Amplitude y(wnt)" offset 1,0 
set xlabel "Normalized Time (wnt)"
set xrange [0:20]
set xtics 0,5,20
set yrange [0:2.0]
set ytics 0, .5, 2.0
set mytics 5
set mxtics 10
wdwn(zeta)=sqrt(1-zeta**2)
shift(zeta) = atan(wdwn(zeta)/zeta)
alpha(zeta)=zeta>1?sqrt(zeta**2-1.0):0
tau1(zeta)=1/(zeta-alpha(zeta))
tau2(zeta)=1/(zeta+alpha(zeta))
c1(zeta)=(zeta + alpha(zeta))/(2*alpha(zeta))
c2(zeta)=c1(zeta)-1
y1(wnt)=zeta==1?1 - exp(-wnt)*(wnt + 1):0
y2(wnt)=zeta<1?(1 - (exp(-zeta*wnt)/wdwn(zeta))*sin(wdwn(zeta)*wnt + shift(zeta))):y1(wnt)
y(wnt)=zeta>1?1-c1(zeta)*exp(-wnt/tau1(zeta))+c2(zeta)*exp(-wnt/tau2(zeta)):y2(wnt)
plot   zeta=.1,y(wnt),   zeta=.2,y(wnt),   zeta=.3,y(wnt),   zeta=.4,y(wnt),   zeta=.5,y(wnt),   zeta=.707,y(wnt),   zeta=1,y(wnt),   zeta=2,y(wnt)
set origin .5,0.
set title "Second Order System - Unit Impulse Response"
y(wnt)=exp(-zeta*wnt) * sin(wdwn(zeta)*wnt) / wdwn(zeta)
set yrange [-1. :1.]
set ytics -1,.5,1.
plot   zeta=.1,y(wnt),   zeta=.2,y(wnt),   zeta=.3,y(wnt),   zeta=.4,y(wnt),   zeta=.5,y(wnt),   zeta=.707,y(wnt),   zeta=1,y(wnt),   zeta=2,y(wnt)
unset multiplot
