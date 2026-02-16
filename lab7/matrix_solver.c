#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <gsl/gsl_linalg.h>
#include <gsl/gsl_blas.h>
#include <gsl/gsl_rng.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Uzycie: %s <rozmiar_macierzy_n>\n", argv[0]);
        return 1;
    }

    int n = atoi(argv[1]);
    if (n <= 0) {
        fprintf(stderr, "Rozmiar musi byc liczba dodatnia.\n");
        return 1;
    }

    const gsl_rng_type *T_rng;
    gsl_rng *r;
    gsl_rng_env_setup();
    T_rng = gsl_rng_default;
    r = gsl_rng_alloc(T_rng);

    gsl_matrix *A = gsl_matrix_alloc(n, n);
    gsl_vector *b = gsl_vector_alloc(n);
    gsl_vector *x = gsl_vector_alloc(n);
    gsl_permutation *p = gsl_permutation_alloc(n);
    gsl_matrix *A_copy = gsl_matrix_alloc(n, n);
    gsl_vector *b_copy = gsl_vector_alloc(n);

    for (int i = 0; i < n; i++) {
        gsl_vector_set(b, i, gsl_rng_uniform(r) * 100.0);
        for (int j = 0; j < n; j++) {
            gsl_matrix_set(A, i, j, gsl_rng_uniform(r) * 100.0);
        }
    }

    gsl_matrix_memcpy(A_copy, A);
    gsl_vector_memcpy(b_copy, b);

    clock_t start, end;
    double time_decomp, time_solve;
    int signum;

    start = clock();
    gsl_linalg_LU_decomp(A, p, &signum);
    end = clock();
    time_decomp = ((double) (end - start)) / CLOCKS_PER_SEC;

    start = clock();
    gsl_linalg_LU_solve(A, p, b, x);
    end = clock();
    time_solve = ((double) (end - start)) / CLOCKS_PER_SEC;

    gsl_vector *check = gsl_vector_calloc(n);

    gsl_blas_dgemv(CblasNoTrans, 1.0, A_copy, x, 0.0, check);

    gsl_vector_sub(check, b_copy);

    double error = gsl_blas_dnrm2(check);

    printf("%d %.6f %.6f %.6e\n", n, time_decomp, time_solve, error);

    gsl_matrix_free(A);
    gsl_vector_free(b);
    gsl_vector_free(x);
    gsl_permutation_free(p);
    gsl_matrix_free(A_copy);
    gsl_vector_free(b_copy);
    gsl_vector_free(check);
    gsl_rng_free(r);

    return 0;
}
