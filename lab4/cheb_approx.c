#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_chebyshev.h>

/* func 1: y = exp(x)*cos(0.5*x^2) */
double func1(double x, void *p)
{
    return exp(x) * cos(0.5 * x * x);
}

/* func 2: y = 1/(12*x^2+1) */
double func2(double x, void *p)
{
    return 1.0 / (12.0 * x * x + 1.0);
}

/* Extra: y = cos(x) + A sin(Bx) */
/* input: A=0.1, B=50.0 */
double func_extra(double x, void *p)
{
    double A = 0.1;
    double B = 50.0;
    return cos(x) + A * sin(B * x);
}

void generate_data(double (*f)(double, void*), const char *filename, double a, double b)
{
    const int N_COEFFS = 100;
    const int STEPS = 500;

    gsl_cheb_series *cs = gsl_cheb_alloc(N_COEFFS);
    gsl_function F;
    F.function = f;
    F.params = 0;

    gsl_cheb_init(cs, &F, a, b);

    FILE *fp = fopen(filename, "w");
    if (!fp)
    {
        perror("Error opening file");
        exit(1);
    }

    double dx = (b - a) / (double)STEPS;
    double x;

    for (int i = 0; i <= STEPS; i++)
    {
        x = a + i * dx;

        double y_exact = GSL_FN_EVAL(&F, x);
        double y_n3 = gsl_cheb_eval_n(cs, 3, x);
        double y_n10 = gsl_cheb_eval_n(cs, 10, x);
        double y_n40 = gsl_cheb_eval_n(cs, 40, x);

        /* write: x, original, n=3, n=10, n=40 */
        fprintf(fp, "%g %g %g %g %g\n", x, y_exact, y_n3, y_n10, y_n40);
    }

    fclose(fp);
    gsl_cheb_free(cs);
}

int main(void)
{
    /* zad 1: func1 [0, 3] */
    generate_data(func1, "data_f1.txt", 0.0, 3.0);

    /* zad 2: func2 [-2, 2] */
    generate_data(func2, "data_f2.txt", -2.0, 2.0);

    /* extra: func_extra [0, 10] */
    generate_data(func_extra, "data_extra.txt", 0.0, 10.0);

    printf("data_f1.txt, data_f2.txt, data_extra.txt\n");
    return 0;
}
