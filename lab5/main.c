#include <stdio.h>
#include <math.h>
#include <gsl/gsl_integration.h>
#include <gsl/gsl_errno.h>

/*******************/
/* f1: x^2 + x + 1 */
/*******************/
double f1(double x, void * params)
{
    return x*x + x + 1;
}

/*********************/
/* f2: sqrt(1 - x^2) */
/*********************/
double f2(double x, void * params)
{
    return sqrt(1 - x*x);
}

/*****************/
/* f3: 1/sqrt(x) */
/*****************/
double f3(double x, void * params)
{
    if (x == 0) return 0; /* Safeguard, although midpoint method won't hit 0 */
    return 1.0 / sqrt(x);
}

/*****************/
/* f_sin: sin(x) */
/*****************/
double f_sin(double x, void * params)
{
    return sin(x);
}

/*****************/
/* f_tan: tan(x) */
/*****************/
/*  */
double f_tan(double x, void * params)
{
    return tan(x);
}

/**************************************/
/* f_log: log(x + x^2) -> ln(x + x^2) */
/**************************************/
double f_log(double x, void * params)
{
    return log(x + x*x);
}

/************************************/
/* Rectangle Method (Midpoint Rule) */
/************************************/
double rectangle_integration(double (*f)(double, void*), double a, double b, int n)
{
    double h = (b - a) / n;
    double sum = 0.0;

    for (int i = 0; i < n; i++)
    {
        /* Midpoint of the interval */
        double x = a + (i + 0.5) * h;
        sum += f(x, NULL);
    }

    return sum * h;
}

/****************************/
/* --- Function for cw1 --- */
/****************************/
void analyze_function(const char* name, double (*f)(double, void*), double exact_val, double a, double b)
{
    printf("\n=== Function Analysis: %s on [%.2f, %.2f] ===\n", name, a, b);
    printf("Exact value: %.10f\n", exact_val);
    printf("%-10s | %-15s | %-15s | %-15s\n", "Tolerance", "N (Rect)", "N (GSL)", "GSL Result");
    printf("---------------------------------------------------------------\n");

    double tolerances[] = {1e-3, 1e-4, 1e-5, 1e-6};

    /* GSL workspace allocation */
    gsl_integration_workspace * w = gsl_integration_workspace_alloc (10000);
    gsl_function F;
    F.function = f;
    F.params = NULL;

    for (int i = 0; i < 4; i++)
    {
        double tol = tolerances[i];

        /* 1. Rectangle method - finding N */
        /* Double N in the loop until the error drops below tolerance */
        int n_rect = 10;
        double rect_res = 0;
        double rect_err = 1.0;

        /* Limit iterations to avoid infinite loop */
        while (n_rect < 100000000)
        {
            rect_res = rectangle_integration(f, a, b, n_rect);
            rect_err = fabs(rect_res - exact_val);
            if (rect_err < tol) break;
            n_rect *= 2;
        }

        /* 2. GSL Method (QAGS - adaptive with singularities) */
        double gsl_result, gsl_error;
        /* neval: Number of evaluations / subintervals */

        /* Use tol as epsabs (absolute error), set epsrel to 0 (or very small) */
        /* int gsl_integration_qags (const gsl_function * f, double a, double b, double epsabs, double epsrel, size_t limit, gsl_integration_workspace * workspace, double * result, double * abserr) */
        gsl_integration_qags (&F, a, b, tol, 1e-7, 10000, w, &gsl_result, &gsl_error);

        /* GSL returns the number of intervals in w->size */
        size_t gsl_intervals = w->size;

        printf("%-10.0e | %-15d | %-15zu | %.10f\n", tol, n_rect, gsl_intervals, gsl_result);
    }

    gsl_integration_workspace_free (w);
}

/****************************/
/* --- Function for cw2 --- */
/****************************/
void analyze_extra(const char* name, double (*f)(double, void*), double a, double b)
{
    printf("\n=== cw2 analysis: %s on [%.2f, %.2f] ===\n", name, a, b);
    printf("%-10s | %-15s | %-15s | %-15s\n", "Tolerance", "GSL Result", "GSL Error", "Intervals");

    double tolerances[] = {1e-3, 1e-4, 1e-5, 1e-6};
    gsl_integration_workspace * w = gsl_integration_workspace_alloc (10000);
    gsl_function F;
    F.function = f;
    F.params = NULL;

    for (int i=0; i<4; i++)
    {
        double result, error;
        /* Turn off error handler so tan(x) doesn't crash the program immediately */
        gsl_set_error_handler_off();

        int status = gsl_integration_qags (&F, a, b, tolerances[i], 0, 10000, w, &result, &error);

        if (status)
        {
            printf("%-10.0e | Error: %s\n", tolerances[i], gsl_strerror(status));
        } else {
            printf("%-10.0e | %-15.8f | %-15.8e | %zu\n", tolerances[i], result, error, w->size);
        }
    }
    gsl_integration_workspace_free (w);
}

int main()
{
    /* cw1 */
    analyze_function("x^2 + x + 1", f1, 11.0/6.0, 0, 1);
    analyze_function("sqrt(1 - x^2)", f2, M_PI/4.0, 0, 1);
    analyze_function("1/sqrt(x)", f3, 2.0, 0, 1);

    /* cw2 */
    analyze_extra("sin(x)", f_sin, 0, M_PI);
    analyze_extra("tan(x)", f_tan, 0, M_PI/2.0);
    analyze_extra("log(x + x^2)", f_log, 1, 4);

    return 0;
}
