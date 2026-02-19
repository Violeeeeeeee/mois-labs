CC=gcc
CFLAGS=-Wall -O2
LIBS=-lgsl -lgslcblas -lm

all: montecarlo

montecarlo: montecarlo.c
	$(CC) $(CFLAGS) -o montecarlo montecarlo.c $(LIBS)

clean:
	rm -f montecarlo.o
