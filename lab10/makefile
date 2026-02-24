CC=gcc
CFLAGS=-Wall -O2
LIBS=-lgsl -lgslcblas -lm

all: optimization_lab

optimization_lab: optimization_lab.c
	$(CC) $(CFLAGS) -o optimization_lab optimization_lab.c $(LIBS)

clean:
	rm -f optimization_lab.o
