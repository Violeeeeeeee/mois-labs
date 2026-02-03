#include <stdio.h>
#include <math.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_roots.h>

double my_f (double x, void *params) { return exp(-x) - sin(x); }
double my_df (double x, void *params) { return -exp(-x) - cos(x); }
void my_fdf (double x, void *params, double *y, double *dy) {
    *y = exp(-x) - sin(x);
    *dy = -exp(-x) - cos(x);
}

int main (void) {
    const gsl_root_fsolver_type *T_bisect = gsl_root_fsolver_bisection;
    gsl_root_fsolver *s_bisect = gsl_root_fsolver_alloc (T_bisect);
    gsl_function F;
    F.function = &my_f; F.params = NULL;

    // interval [0, 1], because f(0)=1, f(1)≈-0.47
    gsl_root_fsolver_set (s_bisect, &F, 0.0, 1.0);

    printf("# Bisection Method\n");
    int iter = 0, status;
    double r;
    double expected = 0.5885327;

    FILE *fp_bisect = fopen("error_bisection.txt", "w");

    do {
        iter++;
        gsl_root_fsolver_iterate (s_bisect);
        r = gsl_root_fsolver_root (s_bisect);
        double x_lo = gsl_root_fsolver_x_lower (s_bisect);
        double x_hi = gsl_root_fsolver_x_upper (s_bisect);
        status = gsl_root_test_interval (x_lo, x_hi, 0, 1e-7);

        fprintf(fp_bisect, "%d %.10f\n", iter, fabs(r - expected));
    } while (status == GSL_CONTINUE && iter < 100);
    fclose(fp_bisect);
    gsl_root_fsolver_free(s_bisect);

    const gsl_root_fdfsolver_type *T_newton = gsl_root_fdfsolver_newton;
    gsl_root_fdfsolver *s_newton = gsl_root_fdfsolver_alloc (T_newton);
    gsl_function_fdf FDF;
    FDF.f = &my_f; FDF.df = &my_df; FDF.fdf = &my_fdf; FDF.params = NULL;

    gsl_root_fdfsolver_set (s_newton, &FDF, 0.0);

    printf("# Newton Method\n");
    iter = 0;
    FILE *fp_newton = fopen("error_newton.txt", "w");
    double x = 0.0;

    do {
        iter++;
        gsl_root_fdfsolver_iterate (s_newton);
        double x0 = x;
        x = gsl_root_fdfsolver_root (s_newton);
        status = gsl_root_test_delta (x, x0, 0, 1e-7);

        fprintf(fp_newton, "%d %.10f\n", iter, fabs(x - expected));
    } while (status == GSL_CONTINUE && iter < 100);
    fclose(fp_newton);
    gsl_root_fdfsolver_free(s_newton);

    return 0;
}
