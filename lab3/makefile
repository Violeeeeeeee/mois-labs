CC=gcc
GSL_HOME=/usr

CFLAGS=-I$(GSL_HOME)/include
#LDFLAGS=-L$(GSL_HOME)/lib -lgsl -lgslcblas -lm
LDFLAGS=-lgsl -lgslcblas -lm

all: interpolacja_m

dokladnosc: interpolacja_m.o
	$(CC) $(LDFLAGS) -o $@ $^

clean:
	rm -f *.o

