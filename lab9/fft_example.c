#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_fft_real.h>

#define Pi 3.1415926535
#define N 256

int
main (void)
{
  int i;
  double data[N];

  for (i = 0; i < N; i++)
    {
      data[i] = f(i); // funkcja nad ktora wykonujemy transformacje
      fprintf (output1, ? data[i]);
    }
   gsl_fft_real_radix2_transform (?);

for (i = 0; i < N; i++)
    {
      fprintf (output2, ? data[i]);
    }
  return 0;
}


