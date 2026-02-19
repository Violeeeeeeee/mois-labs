#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_monte.h>
#include <gsl/gsl_monte_plain.h>
#include <gsl/gsl_monte_miser.h>
#include <gsl/gsl_monte_vegas.h>
#include <gsl/gsl_rng.h>

#define EXACT_F1 (11.0 / 6.0) // approx 1.8333...
#define EXACT_F2 (M_PI / 4.0) // approx 0.7853...
#define EXACT_F3 2.0          // exact 2.0

// Standard C Functions for Hit-and-Miss
double f1(double x) { return x*x + x + 1.0; }
double f2(double x) { return sqrt(1.0 - x*x); }

// Hit-and-miss integration function
double hit_and_miss(double (*func)(double), double x_min, double x_max, double y_max, int N) {
    int hits = 0;
    for (int i = 0; i < N; i++) {
        double x = x_min + (x_max - x_min) * ((double)rand() / RAND_MAX);
        double y = y_max * ((double)rand() / RAND_MAX);
        if (y <= func(x)) {
            hits++;
        }
    }
    double box_area = (x_max - x_min) * y_max;
    return box_area * ((double)hits / N);
}

// GSL Compatible Function for f(x) = 1/sqrt(x)
double gsl_f3(double x[], size_t dim, void * p) {
    (void)(dim); // avoid unused parameter warning
    (void)(p);   // avoid unused parameter warning
    return 1.0 / sqrt(x[0]);
}

int main() {
    // Initialize standard RNG for Hit-and-Miss
    srand(time(NULL));

    size_t calls[] = {100, 500, 1000, 5000, 10000, 50000, 100000, 500000};
    int num_calls = sizeof(calls) / sizeof(calls[0]);

    // Hit-and-Miss Output
    FILE *f_hm = fopen("hit_miss_data.txt", "w");
    if (f_hm == NULL) {
        printf("Error opening hit_miss_data.txt\n");
        return 1;
    }

    fprintf(f_hm, "# N\tErr_f1\tErr_f2\n");

    for (int i = 0; i < num_calls; i++) {
        size_t N = calls[i];

        double res1 = hit_and_miss(f1, 0.0, 1.0, 3.0, N);
        double res2 = hit_and_miss(f2, 0.0, 1.0, 1.0, N);

        double err1 = fabs(res1 - EXACT_F1);
        double err2 = fabs(res2 - EXACT_F2);

        fprintf(f_hm, "%zu\t%g\t%g\n", N, err1, err2);
    }
    fclose(f_hm);
    printf("Successfully wrote hit-and-miss data to hit_miss_data.txt\n");

    // GSL Integration Methods Output
    FILE *f_gsl = fopen("gsl_data.txt", "w");
    if (f_gsl == NULL) {
        printf("Error opening gsl_data.txt\n");
        return 1;
    }

    fprintf(f_gsl, "# N\tErr_PLAIN\tErr_MISER\tErr_VEGAS\n");

    // Setup GSL Environment
    gsl_rng_env_setup();
    const gsl_rng_type *T = gsl_rng_default;
    gsl_rng *r = gsl_rng_alloc(T);

    gsl_monte_function F;
    F.f = &gsl_f3;
    F.dim = 1;
    F.params = 0; // No extra parameters needed

    double xl[1] = { 0.0 }; // Lower limit
    double xu[1] = { 1.0 }; // Upper limit
    double res, err;

    for (int i = 0; i < num_calls; i++) {
        size_t N = calls[i];

        // 1. PLAIN method
        gsl_monte_plain_state *s_plain = gsl_monte_plain_alloc(1);
        gsl_monte_plain_integrate(&F, xl, xu, 1, N, r, s_plain, &res, &err);
        double err_plain = fabs(res - EXACT_F3);
        gsl_monte_plain_free(s_plain);

        // 2. MISER method
        gsl_monte_miser_state *s_miser = gsl_monte_miser_alloc(1);
        gsl_monte_miser_integrate(&F, xl, xu, 1, N, r, s_miser, &res, &err);
        double err_miser = fabs(res - EXACT_F3);
        gsl_monte_miser_free(s_miser);

        // 3. VEGAS method
        gsl_monte_vegas_state *s_vegas = gsl_monte_vegas_alloc(1);
        gsl_monte_vegas_integrate(&F, xl, xu, 1, N, r, s_vegas, &res, &err);
        double err_vegas = fabs(res - EXACT_F3);
        gsl_monte_vegas_free(s_vegas);

        fprintf(f_gsl, "%zu\t%g\t%g\t%g\n", N, err_plain, err_miser, err_vegas);
    }

    fclose(f_gsl);
    gsl_rng_free(r);
    printf("Successfully wrote GSL data to gsl_data.txt\n");

    return 0;
}
