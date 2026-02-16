CC=gcc
CFLAGS=-Wall -O2
LIBS=-lgsl -lgslcblas -lm

all: lab7

lab7: lab7.c
	$(CC) $(CFLAGS) -o lab7 lab7.c $(LIBS)

clean:
	rm -f lab7 data.txt plot.pdf
