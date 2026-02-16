# CC=gcc
# CFLAGS = -I/afs/wszib.edu.pl/usr/k/z/kzajac/pub/gsl/include/
# LDFLAGS =  -L/afs/wszib.edu.pl/usr/k/z/kzajac/pub/gsl/lib -lgsl -lgslcblas -lm
# OBJ=  demo_fn.o root_finding.o
#
# all: root_finding
# root_finding:$(OBJ)
# 	$(CC) $(LDFLAGS) -o $@ $^
#

CC = gcc
INCLUDES = -I/afs/wszib.edu.pl/usr/k/z/kzajac/pub/gsl/include/
LIB_PATH = -L/afs/wszib.edu.pl/usr/k/z/kzajac/pub/gsl/lib

CFLAGS = -Wall -Wextra $(INCLUDES)
LDFLAGS = $(LIB_PATH) -lgsl -lgslcblas -lm

OBJ_COMMON = demo_fn.o
OBJ_MAIN = root_finding.o
OBJ_DERIV = root_finding_deriv.o
OBJ_TRANS = transcendental.o

all: root_finding root_finding_deriv transcendental

root_finding: $(OBJ_MAIN) $(OBJ_COMMON)
	$(CC) -o $@ $^ $(LDFLAGS)

root_finding_deriv: $(OBJ_DERIV) $(OBJ_COMMON)
	$(CC) -o $@ $^ $(LDFLAGS)

transcendental: $(OBJ_TRANS)
	$(CC) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o root_finding root_finding_deriv transcendental
