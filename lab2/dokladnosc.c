#include <stdio.h>
#include <gsl/gsl_ieee_utils.h>

int
main (void)
{
  /* default was 1.0/3.0 for float and double */
  for (int i = 1; i <= 20; i++)
  {
    printf("i: %d", i);
    printf("\n");
    float x = 1.0;
    double xd = 1.0;
    float y = i;
    double yd = i;
    float f = 1.0/y;
    double d = 1.0/yd;
    double fd = f; /* promote from float to double */
    printf(" f="); gsl_ieee_printf_float(&f);
    printf("\n");
    printf("fd="); gsl_ieee_printf_double(&fd);
    printf("\n");
    printf(" d="); gsl_ieee_printf_double(&d);
    printf("\n");
  }



  return 0;
}
