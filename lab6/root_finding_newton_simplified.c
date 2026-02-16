#include <stdio.h>
#include <math.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_roots.h>

#include "demo_fn.h"

/*
 * Uproszczona Metoda Newtona (Simplified Newton / Chord Method)
 * Wzór: x_{i+1} = x_i - f(x_i) / f'(x_0)
 * Pochodna jest liczona tylko raz na początku!
 */

int main (void)
{
  int iter = 0, max_iter = 100;
  int status;

  struct quadratic_params params = { 1.0, -2.0, 1.0 };

  double x = 0.0;
  double x0 = x;
  double const_deriv;
  double y;

  const_deriv = quadratic_deriv(x, &params);

  printf("Uproszczona Metoda Newtona (Simplified Newton)\n");
  printf("Start: x0 = %.5f, f'(x0) = %.5f\n", x, const_deriv);
  printf("%-5s %10s %10s\n", "Iter", "Root", "Error");

  if (fabs(const_deriv) < 1e-7) {
      fprintf(stderr, "Błąd: Pochodna w punkcie startowym jest bliska zeru!\n");
      return GSL_FAILURE;
  }

  do {
      iter++;
      y = quadratic(x, &params);
      double x_next = x - (y / const_deriv);
      status = gsl_root_test_delta(x_next, x, 0, 1e-3);
      double x_prev = x;
      x = x_next;
      printf ("%5d %10.7f %10.7f\n", iter, x, fabs(x - 1.0));
  } while (status == GSL_CONTINUE && iter < max_iter);

  return status;
}
