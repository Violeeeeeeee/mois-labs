// Vladyslav Humeniuk
#include <stdio.h>
#include <float.h>

void calc_eps() {
    float f = 1.0f;
    while ((1.0f + f/2.0f) > 1.0f) {
        f /= 2.0f;
    }

    double d = 1.0;
    while ((1.0 + d/2.0) > 1.0) {
        d /= 2.0;
    }

    long double ld = 1.0L;
    while ((1.0L + ld/2.0L) > 1.0L) {
        ld /= 2.0L;
    }

    printf("float eps = %.10e (FLT_EPSILON=%.10e)\n", f, FLT_EPSILON);
    printf("double eps = %.20e (DBL_EPSILON=%.20e)\n", d, DBL_EPSILON);
    printf("long double eps = %.30Le (LDBL_EPSILON=%.30Le)\n", ld, LDBL_EPSILON);
}

int main() {
    calc_eps();
    return 0;
}
