fun1(x) = 2*cos(x*sin(x))
fun2(x) = sin(x**5)
fun3(x) = 3*sin(x)
label0 = "Dane z pliku fun1.txt"
label1 = "funkcja1: 2*cos(x*sin(x))"
label2 = "funkcja2: sinus(x^5)"
label3 = "funkcja3: 3*sin(x)"
set output "zad1.jpeg"
set terminal jpeg
set grid
set title "Wykres Testowy"
set ylabel "Amplituda"
set label
set key box left width -1
set xrange [-3:3]
set yrange [-4:5]
plot "fun1.txt" using 1:($2+$3)/2:2:3 lw 1.5 lc rgb "red" w yerrorbars title label0, \
     fun2(x) lw 2 lc rgb "green" title label2, \
     fun1(x) lw 1 lc rgb "blue" with boxes title label1, \
     fun3(x) lw 2 lc rgb "red" title label3

