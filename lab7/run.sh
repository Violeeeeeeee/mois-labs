#!/bin/bash

make

OUTPUT="data.txt"
echo "N DecompTime SolveTime Error" > $OUTPUT

echo "Starting measurements..."

# for N in 10 100 200 300 400 500 600 700 800 900 1000
# do
#    ./lab7 $N $N >> $OUTPUT
# done

for N in 10 100 200 300 400 500 600 700 800 900 1000
do
    echo "Processing N = $N..."
    ./lab7 $N >> $OUTPUT
done

echo "Done. Results saved to $OUTPUT"
