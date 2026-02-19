CC=gcc
CFLAGS=-Wall -O2
LIBS=-lgsl -lgslcblas -lm

all: ftt_lab9

ftt_lab9: ftt_lab9.c
	$(CC) $(CFLAGS) -o ftt_lab9 ftt_lab9.c $(LIBS)

clean:
	rm -f ftt_lab9.o
