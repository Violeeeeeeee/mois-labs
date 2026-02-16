#!/bin/bash
make matrix_solver

OUTPUT="results.txt"
echo "N DecompTime SolveTime Error" > $OUTPUT

echo "Rozpoczynam pomiary..."

for n in $(seq 10 110 1000)
do
    echo "Przetwarzanie N = $n..."
    ./matrix_solver $n >> $OUTPUT
done

echo "Gotowe! Wyniki zapisano w $OUTPUT"
