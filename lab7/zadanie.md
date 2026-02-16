Układy równań
Materiały
1. [Wektory i macierze w gsl](https://www.gnu.org/software/gsl/doc/html/vectors.html)
2. [Algebra liniowa](https://www.gnu.org/software/gsl/doc/html/linalg.html)
3. [Biblioteka GSL CBLAS](https://www.gnu.org/software/gsl/doc/html/blas.html)
4. [Dekompozycja LU](http://csep10.phys.utk.edu/guidry/phys594/lectures/linear_algebra/lanotes/node3.html)
5. [Operacje na wektorach i macierzach - BLAS](http://csep10.phys.utk.edu/guidry/phys594/lectures/linear_algebra/blas.html)

Zadanie
   Korzystając z [przykładu](https://www.gnu.org/software/gsl/doc/html/linalg.html#examples) napisz program, który:
1. Jako parametr pobiera rozmiar układu równań n
2. Generuje macierz układu A(nxn) i wektor wyrazów wolnych b(n)
3. Rozwiązuje układ równań
4. Sprawdza poprawność rozwiązania (tj., czy Ax=b)
5. Mierzy czas dekompozycji macierzy - do mierzenia czasu można skorzystać z przykładowego programu dokonującego pomiaru czasu procesora spędzonego w danym fragmencie programu.
6. Mierzy czas rozwiązywania układu równań

Zadanie domowe: Narysuj wykres zależności czasu dekompozycji i czasu rozwiązywania układu od rozmiaru układu równań. Wykonaj pomiary dla 10 wartości z przedziału od 10 do 1000.


przyklad do zadania 5:
```{c}
#include <stdio.h>
#include <sys/resource.h>
#include <string.h>
int czas(struct rusage *ru0, struct rusage *ru1){

	double utime = 0, stime = 0, ttime = 0;

  	/* Obliczenie czasow. Aby mikrosekundy traktowac jako czesci sekund musimy je wymnozyc przez 10^-6*/
	utime = (double) ru1->ru_utime.tv_sec
		+ 1.e-6 * (double) ru1->ru_utime.tv_usec
		- ru0->ru_utime.tv_sec
		- 1.e-6 * (double) ru0->ru_utime.tv_usec;
  	stime = (double) ru1->ru_stime.tv_sec
    		+ 1.e-6 * (double) ru1->ru_stime.tv_usec
		- ru0->ru_stime.tv_sec
    		- 1.e-6 * (double) ru0->ru_stime.tv_usec;
	ttime = stime + utime;

	/*printf("user time: %3f\n", utime);
	printf("system time: %3f\n", stime);*/
	printf("total time: %3f\n", ttime);

}

int
main (int argc, char **argv)
{
  struct rusage t0, t1, t2;
  int i;

  getrusage(RUSAGE_SELF, &t0);
  for(i=0;i<1000000000;i++);
  getrusage(RUSAGE_SELF, &t1);
  for(i=0;i<500000000;i++);
  getrusage(RUSAGE_SELF, &t2);


  /* tylko wypisanie zmierzonych wczesniej czasów */
  printf("%s \n","W petli 1");
  czas(&t0, &t1);
  printf("%s \n","W petli 2");
  czas(&t1, &t2);
  printf("%s \n","Razem:");
  czas(&t0, &t2);
  return 0;
}
```
