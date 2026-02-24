#include <stdio.h>
#include <math.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_odeiv2.h>

// Define the ODE function for GSL (Runge-Kutta)
int func_B (double x, const double y[], double f[], void *params) {
    (void)(params);
    f[0] = sin(x)*cos(x) - y[0]*cos(x);
    return GSL_SUCCESS;
}

// Exact analytical solution for error comparison
double exact_sol(double x) {
    return sin(x) - 1.0 + exp(-sin(x));
}

int main() {
    double x_start = 0.0, x_end = 15.0;
    int steps = 100;

    /********************************************
    * METHOD 1: Runge-Kutta 4th Order (via GSL) *
    ********************************************/
    gsl_odeiv2_system sys = {func_B, NULL, 1, NULL}; // No Jacobian needed for explicit RK
    gsl_odeiv2_driver * d = gsl_odeiv2_driver_alloc_y_new (&sys, gsl_odeiv2_step_rk4, 1e-6, 1e-6, 0.0);

    double x_rk = x_start;
    double y_rk[1] = { 0.0 }; // Initial condition y(0) = 0

    FILE *f_rk4 = fopen("task_b_rk4.txt", "w");
    FILE *f_exact = fopen("task_b_exact.txt", "w");

    fprintf(f_rk4, "%f %f\n", x_rk, y_rk[0]);
    fprintf(f_exact, "%f %f\n", x_rk, exact_sol(x_rk));

    for (int i = 1; i <= steps; i++) {
        double xi = i * x_end / steps;
        gsl_odeiv2_driver_apply (d, &x_rk, xi, y_rk);

        fprintf(f_rk4, "%f %f\n", x_rk, y_rk[0]);
        fprintf(f_exact, "%f %f\n", x_rk, exact_sol(x_rk));
    }
    gsl_odeiv2_driver_free (d);
    fclose(f_rk4);
    fclose(f_exact);

    /********************************************
    * METHOD 2: Standard Euler Method (Manual) *
    ********************************************/
    FILE *f_euler = fopen("task_b_euler.txt", "w");
    double h = (x_end - x_start) / steps;
    double x_e = x_start;
    double y_e = 0.0; // Initial condition

    fprintf(f_euler, "%f %f\n", x_e, y_e);

    for (int i = 1; i <= steps; i++) {
        // Euler formula: y_{n+1} = y_n + h * f(x_n, y_n)
        double f_val = sin(x_e)*cos(x_e) - y_e*cos(x_e);
        y_e = y_e + h * f_val;
        x_e = x_e + h;

        fprintf(f_euler, "%f %f\n", x_e, y_e);
    }
    fclose(f_euler);

    printf("Task B data successfully generated.\n");
    return 0;
}
