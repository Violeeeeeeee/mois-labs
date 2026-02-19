#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <time.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_fft_real.h>
#include <gsl/gsl_fft_halfcomplex.h>

#define N 256

int main(void) {
    int i;
    double data[N];
    double noisy_data[N];
    FILE *f_sig, *f_spec, *f_nsig, *f_nspec, *f_fspec, *f_inv;

    // Task 1: Generate the clean signal
    f_sig = fopen("signal.txt", "w");
    for (i = 0; i < N; i++) {
        data[i] = cos(4.0*M_PI*i/N) + cos(16.0*M_PI*i/N)/5.0 + cos(32.0*M_PI*i/N)/8.0 + cos(128.0*M_PI*i/N)/16.0;
        fprintf(f_sig, "%d %f\n", i, data[i]);
    }
    fclose(f_sig);

    // Task 2: FFT of the clean signal
    gsl_fft_real_radix2_transform(data, 1, N);

    f_spec = fopen("spectrum.txt", "w");
    for (i = 0; i < N; i++) {
        fprintf(f_spec, "%d %f\n", i, fabs(data[i]));
    }
    fclose(f_spec);

    // Task 3: Generate the noisy signal
    srand(time(NULL));
    f_nsig = fopen("noisy_signal.txt", "w");
    for (i = 0; i < N; i++) {
        noisy_data[i] = cos(4.0*M_PI*i/N) + ((float)rand()) / RAND_MAX / 8.0;
        fprintf(f_nsig, "%d %f\n", i, noisy_data[i]);
    }
    fclose(f_nsig);

    // Task 4: FFT of the noisy signal
    gsl_fft_real_radix2_transform(noisy_data, 1, N);

    f_nspec = fopen("noisy_spectrum.txt", "w");
    for (i = 0; i < N; i++) {
        fprintf(f_nspec, "%d %f\n", i, fabs(noisy_data[i]));
    }
    fclose(f_nspec);

    // Task 5: Zero out the noise (filter)
    f_fspec = fopen("filtered_spectrum.txt", "w");
    for (i = 0; i < N; i++) {
        if (fabs(noisy_data[i]) < 50.0) {
            noisy_data[i] = 0.0;
        }
        fprintf(f_fspec, "%d %f\n", i, fabs(noisy_data[i]));
    }
    fclose(f_fspec);

    // Task 6: Inverse FFT of the filtered spectrum
    gsl_fft_halfcomplex_radix2_inverse(noisy_data, 1, N);

    f_inv = fopen("inverse_signal.txt", "w");
    for (i = 0; i < N; i++) {
        fprintf(f_inv, "%d %f\n", i, noisy_data[i]);
    }
    fclose(f_inv);

    printf("Data generation complete.\n");
    return 0;
}
