#include <stdio.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_chebyshev.h>

double
f (double x, void *p)
{
  if (x < 0.5)
      return 0.25;
   else
      return 0.75;
}

int
main (void)
{
	FILE *dane1 = fopen("dane1.dat", "w");
	FILE *dane2 = fopen("dane2.dat", "w");
	FILE *dane3 = fopen("dane3.dat", "w");
  int i, n = 10000; 

  gsl_cheb_series *cs = gsl_cheb_alloc (40);

  gsl_function F;

  F.function = f;
  F.params = 0;

  gsl_cheb_init (cs, &F, 0.0, 1.0);

  for (i = 0; i < n; i++)
  {
    double x = i / (double)n;
    double r10 = gsl_cheb_eval_n (cs, 10, x);
    double r40 = gsl_cheb_eval (cs, x);
    fprintf (dane1, "%g %g\n", x, GSL_FN_EVAL (&F, x));
    fprintf (dane2, "%g %g\n", x, r10);
    fprintf (dane3, "%g %g\n", x, r40);
  }

  gsl_cheb_free (cs);

  fclose(dane1);
  fclose(dane2);
  fclose(dane3);

 return 0;
}
