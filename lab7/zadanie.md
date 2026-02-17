Układy równań
Materiały
1. [Wektory i macierze w gsl](https://www.gnu.org/software/gsl/doc/html/vectors.html)
2. [Algebra liniowa](https://www.gnu.org/software/gsl/doc/html/linalg.html)
3. [Biblioteka GSL CBLAS](https://www.gnu.org/software/gsl/doc/html/blas.html)
4. [Dekompozycja LU](http://csep10.phys.utk.edu/guidry/phys594/lectures/linear_algebra/lanotes/node3.html)
5. [Operacje na wektorach i macierzach - BLAS](http://csep10.phys.utk.edu/guidry/phys594/lectures/linear_algebra/blas.html)

Zadanie
   Korzystając z [przykładu](https://www.gnu.org/software/gsl/doc/html/linalg.html#examples) napisz program, który:
1. Jako parametr pobiera rozmiar układu równań n
2. Generuje macierz układu A(nxn) i wektor wyrazów wolnych b(n)
3. Rozwiązuje układ równań
4. Sprawdza poprawność rozwiązania (tj., czy Ax=b)
5. Mierzy czas dekompozycji macierzy - do mierzenia czasu można skorzystać z przykładowego programu dokonującego pomiaru czasu procesora spędzonego w danym fragmencie programu.
6. Mierzy czas rozwiązywania układu równań

Zadanie domowe: Narysuj wykres zależności czasu dekompozycji i czasu rozwiązywania układu od rozmiaru układu równań. Wykonaj pomiary dla 10 wartości z przedziału od 10 do 1000.


przyklad do zadania 5:
```{c}
#include <stdio.h>
#include <sys/resource.h>
#include <string.h>
int czas(struct rusage *ru0, struct rusage *ru1){

	double utime = 0, stime = 0, ttime = 0;

  	/* Obliczenie czasow. Aby mikrosekundy traktowac jako czesci sekund musimy je wymnozyc przez 10^-6*/
	utime = (double) ru1->ru_utime.tv_sec
		+ 1.e-6 * (double) ru1->ru_utime.tv_usec
		- ru0->ru_utime.tv_sec
		- 1.e-6 * (double) ru0->ru_utime.tv_usec;
  	stime = (double) ru1->ru_stime.tv_sec
    		+ 1.e-6 * (double) ru1->ru_stime.tv_usec
		- ru0->ru_stime.tv_sec
    		- 1.e-6 * (double) ru0->ru_stime.tv_usec;
	ttime = stime + utime;

	/*printf("user time: %3f\n", utime);
	printf("system time: %3f\n", stime);*/
	printf("total time: %3f\n", ttime);

}

int
main (int argc, char **argv)
{
  struct rusage t0, t1, t2;
  int i;

  getrusage(RUSAGE_SELF, &t0);
  for(i=0;i<1000000000;i++);
  getrusage(RUSAGE_SELF, &t1);
  for(i=0;i<500000000;i++);
  getrusage(RUSAGE_SELF, &t2);


  /* tylko wypisanie zmierzonych wczesniej czasów */
  printf("%s \n","W petli 1");
  czas(&t0, &t1);
  printf("%s \n","W petli 2");
  czas(&t1, &t2);
  printf("%s \n","Razem:");
  czas(&t0, &t2);
  return 0;
}
```


moje rozwianzanie:
```{c}
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/resource.h>
#include <gsl/gsl_linalg.h>
#include <gsl/gsl_blas.h>
#include <gsl/gsl_rng.h>

double calculate_time(struct rusage *ru0, struct rusage *ru1) {
    double utime = 0, stime = 0, ttime = 0;
    utime = (double) ru1->ru_utime.tv_sec + 1.e-6 * (double) ru1->ru_utime.tv_usec - ru0->ru_utime.tv_sec - 1.e-6 * (double) ru0->ru_utime.tv_usec;
    stime = (double) ru1->ru_stime.tv_sec + 1.e-6 * (double) ru1->ru_stime.tv_usec - ru0->ru_stime.tv_sec - 1.e-6 * (double) ru0->ru_stime.tv_usec;
    ttime = stime + utime;
    return ttime;
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Used: %s <matrix_size_n>\n", argv[0]);
        return 1;
    }

    int n = atoi(argv[1]);
    struct rusage t0, t1, t2;

    gsl_rng_env_setup();
    const gsl_rng_type *T = gsl_rng_default;
    gsl_rng *r = gsl_rng_alloc(T);
    gsl_rng_set(r, time(NULL));

    gsl_matrix *A = gsl_matrix_alloc(n, n);
    gsl_matrix *A_copy = gsl_matrix_alloc(n, n);
    gsl_vector *b = gsl_vector_alloc(n);
    gsl_vector *x = gsl_vector_alloc(n);
    gsl_permutation *p = gsl_permutation_alloc(n);

    for (int i = 0; i < n; i++) {
        gsl_vector_set(b, i, gsl_rng_uniform(r) * 100.0);
        for (int j = 0; j < n; j++) {
            double val = gsl_rng_uniform(r) * 100.0;
            gsl_matrix_set(A, i, j, val);
            gsl_matrix_set(A_copy, i, j, val);
        }
    }

    int signum;

    getrusage(RUSAGE_SELF, &t0);
    gsl_linalg_LU_decomp(A, p, &signum);
    getrusage(RUSAGE_SELF, &t1);

    double time_decomp = calculate_time(&t0, &t1);

    getrusage(RUSAGE_SELF, &t1);
    gsl_linalg_LU_solve(A, p, b, x);
    getrusage(RUSAGE_SELF, &t2);

    double time_solve = calculate_time(&t1, &t2);

    gsl_vector *verification = gsl_vector_alloc(n);
    gsl_blas_dgemv(CblasNoTrans, 1.0, A_copy, x, 0.0, verification);
    gsl_vector_sub(verification, b);
    double error = gsl_blas_dnrm2(verification);

    printf("%d %.6f %.6f %.6e\n", n, time_decomp, time_solve, error);

    gsl_matrix_free(A);
    gsl_matrix_free(A_copy);
    gsl_vector_free(b);
    gsl_vector_free(x);
    gsl_vector_free(verification);
    gsl_permutation_free(p);
    gsl_rng_free(r);

    return 0;
}
```
