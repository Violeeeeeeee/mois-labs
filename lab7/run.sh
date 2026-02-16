#!/bin/bash

make

OUTPUT="data.txt"
echo "N DecompTime SolveTime Error" > $OUTPUT

echo "Rozpoczynam pomiary..."

for N in 10 100 200 300 400 500 600 700 800 900 1000
do
    echo "Przetwarzanie N = $N..."
    ./lab7 $N >> $OUTPUT
done

echo "Gotowe. Dane zapisano w $OUTPUT"
