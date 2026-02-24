#include <stdio.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_min.h>

/********************************
* Function 1: f(x) = cos(x) + 1 *
********************************/
double fn1(double x, void * params) {
    return cos(x) + 1.0;
}

/***********************************************
* Function 2: f(x) = e^(-x) - sin(x) + sqrt(x) *
***********************************************/
double fn2(double x, void * params) {
    return exp(-x) - sin(x) + sqrt(x);
}

/************************************************
* Helper function to run and compare minimizers *
************************************************/
void run_minimizer(const gsl_min_fminimizer_type * T, gsl_function * F, double a, double b, double m) {
    int status;
    int iter = 0, max_iter = 100;
    gsl_min_fminimizer *s;

    s = gsl_min_fminimizer_alloc(T);

    gsl_set_error_handler_off();

    status = gsl_min_fminimizer_set(s, F, m, a, b);

    printf("--- Method: %-15s ---\n", gsl_min_fminimizer_name(s));

    if (status != GSL_SUCCESS) {
        printf("FAILED to initialize: %s\n", gsl_strerror(status));
        printf("Reason: f(a)=%g, f(m)=%g, f(b)=%g. GSL requires f(m) < f(a) AND f(m) < f(b).\n\n",
               GSL_FN_EVAL(F, a), GSL_FN_EVAL(F, m), GSL_FN_EVAL(F, b));
        gsl_min_fminimizer_free(s);
        return;
    }

    do {
        iter++;
        status = gsl_min_fminimizer_iterate(s);
        m = gsl_min_fminimizer_x_minimum(s);
        a = gsl_min_fminimizer_x_lower(s);
        b = gsl_min_fminimizer_x_upper(s);

        // Check for convergence: interval size < 0.001
        status = gsl_min_test_interval(a, b, 0.001, 0.0);
    } while (status == GSL_CONTINUE && iter < max_iter);

    printf("Converged in %d iterations. Minimum at x = %.5f, f(x) = %.5f\n\n",
            iter, m, GSL_FN_EVAL(F, m));

    gsl_min_fminimizer_free(s);
}

int main(void) {
    gsl_function F1;
    F1.function = &fn1;
    F1.params = 0;

    gsl_function F2;
    F2.function = &fn2;
    F2.params = 0;

    FILE *f1_out = fopen("f1_data.txt", "w");
    for (double x = 0; x <= 6.0; x += 0.05) {
        fprintf(f1_out, "%f %f\n", x, fn1(x, 0));
    }
    fclose(f1_out);

    FILE *f2_out = fopen("f2_data.txt", "w");
    for (double x = M_PI/2.0; x <= 4.0*M_PI; x += 0.05) {
        fprintf(f2_out, "%f %f\n", x, fn2(x, 0));
    }
    fclose(f2_out);

    /******************************************
    * TASK 1 & 2: First Function (cos(x) + 1) *
    ******************************************/
    printf("=== FUNCTION 1: f(x) = cos(x) + 1 ===\n");
    printf("Interval: [0, 6], Guess: 2.0\n\n");
    run_minimizer(gsl_min_fminimizer_brent, &F1, 0.0, 6.0, 2.0);
    run_minimizer(gsl_min_fminimizer_quad_golden, &F1, 0.0, 6.0, 2.0);
    run_minimizer(gsl_min_fminimizer_goldensection, &F1, 0.0, 6.0, 2.0);


    /******************************************************
    * TASK 2: Second Function (e^(-x) - sin(x) + sqrt(x)) *
    ******************************************************/
    printf("=== FUNCTION 2: f(x) = e^(-x) - sin(x) + sqrt(x) ===\n");

    // The problematic interval given in the assignment
    printf("Attempt 1: Problematic Interval: [pi/2, 4*pi], Guess: 4.0\n");
    run_minimizer(gsl_min_fminimizer_brent, &F2, M_PI/2.0, 4.0*M_PI, 4.0);

    // The fixed interval bracketing the true local minimum
    printf("Attempt 2: Corrected Bracketing Interval: [6.0, 9.0], Guess: 7.0\n\n");
    run_minimizer(gsl_min_fminimizer_brent, &F2, 6.0, 9.0, 7.0);
    run_minimizer(gsl_min_fminimizer_quad_golden, &F2, 6.0, 9.0, 7.0);
    run_minimizer(gsl_min_fminimizer_goldensection, &F2, 6.0, 9.0, 7.0);

    return 0;
}
