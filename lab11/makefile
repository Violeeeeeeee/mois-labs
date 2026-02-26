CC=gcc
CFLAGS=-Wall -O2
LIBS=-lgsl -lgslcblas -lm

all: task_b

task_b: task_b.c
	$(CC) $(CFLAGS) -o task_b task_b.c $(LIBS)

clean:
	rm -f task_b.o

