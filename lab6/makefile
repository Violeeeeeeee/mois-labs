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
# Шляхи з вашого оригінального makefile
INCLUDES = -I/afs/wszib.edu.pl/usr/k/z/kzajac/pub/gsl/include/
LIB_PATH = -L/afs/wszib.edu.pl/usr/k/z/kzajac/pub/gsl/lib

# Прапори компіляції та лінкування
CFLAGS = -Wall -Wextra $(INCLUDES)
LDFLAGS = $(LIB_PATH) -lgsl -lgslcblas -lm

# Об'єктні файли
OBJ_COMMON = demo_fn.o
OBJ_MAIN = root_finding.o
OBJ_DERIV = root_finding_deriv.o
OBJ_TRANS = transcendental.o

# Головна ціль - скомпілювати все
all: root_finding root_finding_deriv transcendental

# 1. Оригінальна програма (Бісекція, Хорд, Брент)
root_finding: $(OBJ_MAIN) $(OBJ_COMMON)
	$(CC) -o $@ $^ $(LDFLAGS)

# 2. Програма з похідними (Ньютон, Стеффенсон для квадратичної)
root_finding_deriv: $(OBJ_DERIV) $(OBJ_COMMON)
	$(CC) -o $@ $^ $(LDFLAGS)

# 3. Програма для e^-x - sin(x)
transcendental: $(OBJ_TRANS)
	$(CC) -o $@ $^ $(LDFLAGS)

# Правило для компіляції .c в .o
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Очищення
clean:
	rm -f *.o root_finding root_finding_deriv transcendental
