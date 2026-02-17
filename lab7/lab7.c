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

    long seed = time(NULL);
    if (argc == 3) {
        seed = atol(argv[2]);
    }
    gsl_rng_set(r, seed);

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
