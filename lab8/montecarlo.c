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

#define EXACT_F1 (11.0 / 6.0)
#define EXACT_F2 (M_PI / 4.0)
#define EXACT_F3 2.0

double f1(double x) { return x*x + x + 1.0; }
double f2(double x) { return sqrt(1.0 - x*x); }
double f3(double x) { return 1.0 / sqrt(x); }

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

double gsl_f1(double x[], size_t dim, void * p) {
    (void)(dim); (void)(p);
    return x[0]*x[0] + x[0] + 1.0;
}
double gsl_f2(double x[], size_t dim, void * p) {
    (void)(dim); (void)(p);
    return sqrt(1.0 - x[0]*x[0]);
}
double gsl_f3(double x[], size_t dim, void * p) {
    (void)(dim); (void)(p);
    return 1.0 / sqrt(x[0]);
}

void run_gsl_methods(gsl_monte_function *F, double exact_val, const char* filename, size_t *calls, int num_calls, gsl_rng *r) {
    FILE *f_out = fopen(filename, "w");
    fprintf(f_out, "# N\tErr_PLAIN\tErr_MISER\tErr_VEGAS\n");

    double xl[1] = { 0.0 };
    double xu[1] = { 1.0 };
    double res, err;

    for (int i = 0; i < num_calls; i++) {
        size_t N = calls[i];

        gsl_monte_plain_state *s_plain = gsl_monte_plain_alloc(1);
        gsl_monte_plain_integrate(F, xl, xu, 1, N, r, s_plain, &res, &err);
        double err_plain = fabs(res - exact_val);
        gsl_monte_plain_free(s_plain);

        gsl_monte_miser_state *s_miser = gsl_monte_miser_alloc(1);
        gsl_monte_miser_integrate(F, xl, xu, 1, N, r, s_miser, &res, &err);
        double err_miser = fabs(res - exact_val);
        gsl_monte_miser_free(s_miser);

        gsl_monte_vegas_state *s_vegas = gsl_monte_vegas_alloc(1);
        gsl_monte_vegas_integrate(F, xl, xu, 1, N, r, s_vegas, &res, &err);
        double err_vegas = fabs(res - exact_val);
        gsl_monte_vegas_free(s_vegas);

        fprintf(f_out, "%zu\t%g\t%g\t%g\n", N, err_plain, err_miser, err_vegas);
    }
    fclose(f_out);
}

int main() {
    srand(time(NULL));

    size_t calls[] = {100, 500, 1000, 5000, 10000, 50000, 100000, 500000};
    int num_calls = sizeof(calls) / sizeof(calls[0]);

    // TASK 1 & 2: Hit-and-Miss for ALL 3 functions
    FILE *f_hm = fopen("hit_miss_data.txt", "w");
    fprintf(f_hm, "# N\tErr_f1\tErr_f2\tErr_f3\n");

    for (int i = 0; i < num_calls; i++) {
        size_t N = calls[i];

        // Bounding boxes: f1 max is 3, f2 max is 1.
        // For f3, it's unbounded. We use an arbitrary height of 1000.0 to show it fails.
        double res1 = hit_and_miss(f1, 0.0, 1.0, 3.0, N);
        double res2 = hit_and_miss(f2, 0.0, 1.0, 1.0, N);
        double res3 = hit_and_miss(f3, 0.0, 1.0, 1000.0, N);

        fprintf(f_hm, "%zu\t%g\t%g\t%g\n", N, fabs(res1 - EXACT_F1), fabs(res2 - EXACT_F2), fabs(res3 - EXACT_F3));
    }
    fclose(f_hm);

    // TASK 3: GSL Methods for ALL 3 functions
    gsl_rng_env_setup();
    const gsl_rng_type *T = gsl_rng_default;
    gsl_rng *r = gsl_rng_alloc(T);

    gsl_monte_function F1 = { &gsl_f1, 1, 0 };
    gsl_monte_function F2 = { &gsl_f2, 1, 0 };
    gsl_monte_function F3 = { &gsl_f3, 1, 0 };

    run_gsl_methods(&F1, EXACT_F1, "gsl_data_f1.txt", calls, num_calls, r);
    run_gsl_methods(&F2, EXACT_F2, "gsl_data_f2.txt", calls, num_calls, r);
    run_gsl_methods(&F3, EXACT_F3, "gsl_data_f3.txt", calls, num_calls, r);

    gsl_rng_free(r);
    printf("Data generation complete.\n");

    return 0;
}
