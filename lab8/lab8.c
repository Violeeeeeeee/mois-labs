#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_monte.h>
#include <gsl/gsl_monte_plain.h>
#include <gsl/gsl_monte_miser.h>
#include <gsl/gsl_monte_vegas.h>

// Точні значення інтегралів для обчислення похибки
#define EXACT_F1 (11.0 / 6.0)     // x^2 + x + 1 -> 1/3 + 1/2 + 1 = 11/6
#define EXACT_F2 (M_PI / 4.0)     // sqrt(1 - x^2) -> чверть площі кола = pi/4
#define EXACT_F3 2.0              // 1/sqrt(x) -> 2*sqrt(x) від 0 до 1 = 2

// ------------------------------------------------------------------
// Функції для власного методу "Hit-and-Miss"
// ------------------------------------------------------------------
double f1(double x) { return x*x + x + 1.0; }
double f2(double x) { return sqrt(1.0 - x*x); }

double hit_and_miss(double (*f)(double), double a, double b, double y_max, size_t N, gsl_rng *r) {
    size_t hits = 0;
    for (size_t i = 0; i < N; i++) {
        double x = a + (b - a) * gsl_rng_uniform(r);
        double y = y_max * gsl_rng_uniform(r);
        if (y <= f(x)) hits++;
    }
    return (b - a) * y_max * ((double)hits / N);
}

// ------------------------------------------------------------------
// Обгортки функцій для GSL Monte Carlo
// ------------------------------------------------------------------
double f1_gsl(double *x, size_t dim, void *params) {
    (void)dim; (void)params;
    return x[0]*x[0] + x[0] + 1.0;
}

double f2_gsl(double *x, size_t dim, void *params) {
    (void)dim; (void)params;
    return sqrt(1.0 - x[0]*x[0]);
}

double f3_gsl(double *x, size_t dim, void *params) {
    (void)dim; (void)params;
    return 1.0 / sqrt(x[0]);
}

// Допоміжна функція для обчислення та виводу результатів GSL
void run_gsl_mc(gsl_monte_function *GSL_F, double xl[], double xu[], size_t dim, size_t calls, gsl_rng *r, double exact_val, double *err_plain, double *err_miser, double *err_vegas) {
    double res, err;

    // PLAIN Monte Carlo
    gsl_monte_plain_state *s_plain = gsl_monte_plain_alloc(dim);
    gsl_monte_plain_integrate(GSL_F, xl, xu, dim, calls, r, s_plain, &res, &err);
    *err_plain = fabs(res - exact_val);
    gsl_monte_plain_free(s_plain);

    // MISER Monte Carlo
    gsl_monte_miser_state *s_miser = gsl_monte_miser_alloc(dim);
    gsl_monte_miser_integrate(GSL_F, xl, xu, dim, calls, r, s_miser, &res, &err);
    *err_miser = fabs(res - exact_val);
    gsl_monte_miser_free(s_miser);

    // VEGAS Monte Carlo
    gsl_monte_vegas_state *s_vegas = gsl_monte_vegas_alloc(dim);
    gsl_monte_vegas_integrate(GSL_F, xl, xu, dim, calls, r, s_vegas, &res, &err);
    *err_vegas = fabs(res - exact_val);
    gsl_monte_vegas_free(s_vegas);
}

int main(void) {
    gsl_rng_env_setup();
    const gsl_rng_type *T = gsl_rng_default;
    gsl_rng *r = gsl_rng_alloc(T);

    // Налаштування для GSL
    double xl[1] = { 0.0 };
    double xu[1] = { 1.0 };
    size_t dim = 1;

    gsl_monte_function GSL_F1 = { &f1_gsl, dim, 0 };
    gsl_monte_function GSL_F2 = { &f2_gsl, dim, 0 };
    gsl_monte_function GSL_F3 = { &f3_gsl, dim, 0 };

    // Вивід заголовка для даних
    printf("# N\tHM_F1\tHM_F2\tPL_F1\tMS_F1\tVG_F1\tPL_F2\tMS_F2\tVG_F2\tPL_F3\tMS_F3\tVG_F3\n");

    // Максимальні значення y_max для hit-and-miss на [0, 1]
    double y_max_f1 = 3.0; // f(1) = 3
    double y_max_f2 = 1.0; // f(0) = 1

    size_t points[] = {100, 500, 1000, 5000, 10000, 50000, 100000, 500000, 1000000};
    int num_points = sizeof(points) / sizeof(points[0]);

    for (int i = 0; i < num_points; i++) {
        size_t N = points[i];

        // 1. Hit-and-Miss
        double hm_res_f1 = hit_and_miss(&f1, 0.0, 1.0, y_max_f1, N, r);
        double err_hm_f1 = fabs(hm_res_f1 - EXACT_F1);

        double hm_res_f2 = hit_and_miss(&f2, 0.0, 1.0, y_max_f2, N, r);
        double err_hm_f2 = fabs(hm_res_f2 - EXACT_F2);

        // 2. GSL Monte Carlo
        double err_pl_f1, err_ms_f1, err_vg_f1;
        run_gsl_mc(&GSL_F1, xl, xu, dim, N, r, EXACT_F1, &err_pl_f1, &err_ms_f1, &err_vg_f1);

        double err_pl_f2, err_ms_f2, err_vg_f2;
        run_gsl_mc(&GSL_F2, xl, xu, dim, N, r, EXACT_F2, &err_pl_f2, &err_ms_f2, &err_vg_f2);

        double err_pl_f3, err_ms_f3, err_vg_f3;
        run_gsl_mc(&GSL_F3, xl, xu, dim, N, r, EXACT_F3, &err_pl_f3, &err_ms_f3, &err_vg_f3);

        // Вивід рядка даних
        printf("%zu\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\n",
               N,
               err_hm_f1, err_hm_f2,
               err_pl_f1, err_ms_f1, err_vg_f1,
               err_pl_f2, err_ms_f2, err_vg_f2,
               err_pl_f3, err_ms_f3, err_vg_f3);
    }

    gsl_rng_free(r);
    return 0;
}
