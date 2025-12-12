#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_spline.h>
#include <gsl/gsl_interp.h>

static double fun(double x)
{
    return 1.0 / (1.0 + 25.0 * x * x);
}

void make_interpolation(const gsl_interp_type *T, const char *filename,
                        double *x, double *y, int steps, double a, double b)
{
    gsl_interp_accel *acc = gsl_interp_accel_alloc();
    gsl_spline *spline = gsl_spline_alloc(T, steps + 1);

    FILE *output = fopen(filename, "w");
    double xi, yi;

    gsl_spline_init(spline, x, y, steps + 1);

    for (xi = a; xi <= b; xi += 0.01)
    {
        yi = gsl_spline_eval(spline, xi, acc);
        fprintf(output, "%g %g\n", xi, yi);
    }

    fclose(output);
    gsl_spline_free(spline);
    gsl_interp_accel_free(acc);
}

int main (void)
{
    const double a = -1.0;
    const double b = 1.0;
    const int steps = 10;

    double x[100], y[100], dx;
    FILE *input;
    int i;

    input = fopen("values.txt", "w");
    dx = (b - a) / (double) steps;

    for (i = 0; i <= steps; ++i)
    {
        x[i] = a + (double)i * dx;
        y[i] = fun(x[i]);
        fprintf(input, "%g %g\n", x[i], y[i]);
    }
    fclose(input);

    /* 3 different interpolation */

    /* Polynomial */
    make_interpolation(gsl_interp_polynomial, "inter_poly.txt", x, y, steps, a, b);

    /* Cubic Spline */
    make_interpolation(gsl_interp_cspline, "inter_cspline.txt", x, y, steps, a, b);

    /* Linear */
    make_interpolation(gsl_interp_linear, "inter_linear.txt", x, y, steps, a, b);

    printf("values.txt, inter_poly.txt, inter_cspline.txt, inter_linear.txt\n");

    return 0;
}
