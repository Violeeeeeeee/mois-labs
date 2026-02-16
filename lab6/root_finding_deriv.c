#include <stdio.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_roots.h>
#include "demo_fn.h"

int main (void)
{
  int status, iter = 0, max_iter = 100;
  const gsl_root_fdfsolver_type *T;
  gsl_root_fdfsolver *s;

  // parameters for x^2 - 2x + 1 = 0
  struct quadratic_params params = { 1.0, -2.0, 1.0 };

  gsl_function_fdf FDF;
  FDF.f = &quadratic;
  FDF.df = &quadratic_deriv;
  FDF.fdf = &quadratic_fdf;
  FDF.params = &params;

  // choose method: gsl_root_fdfsolver_newton, gsl_root_fdfsolver_steffenson
  T = gsl_root_fdfsolver_newton;
  // T = gsl_root_fdfsolver_steffenson;
  s = gsl_root_fdfsolver_alloc (T);

  double x = 0.0;
  gsl_root_fdfsolver_set (s, &FDF, x);

  printf ("Using %s method\n", gsl_root_fdfsolver_name (s));
  printf ("%-5s %10s %10s\n", "Iter", "Root", "Error");

  do {
      iter++;
      status = gsl_root_fdfsolver_iterate (s);
      double x0 = x;
      x = gsl_root_fdfsolver_root (s);
      status = gsl_root_test_delta (x, x0, 0, 1e-3);

      printf ("%5d %10.7f %10.7f\n", iter, x, x - x0);
  } while (status == GSL_CONTINUE && iter < max_iter);

  gsl_root_fdfsolver_free (s);
  return status;
}
