// Vladyslav Humeniuk
#include <stdio.h>

void seq() {
    float xf1 = 0.01f;
    float xf2 = 0.01f;
    double xd2 = 0.01;
    double xd1 = 0.01;
    for (int i = 0; i <= 20; i++) {
        xf1 = xf1 + 3.0f * xf1 * (1.0f -  xf1);
        xf2 = xf2 + 3.0f * xf2 * (1.0f -  xf2);
        xd2 = xd2 + 3.0 * xd2 * (1.0 - xd2);
        xd1 = xd1 + 3.0 * xd1 * (1.0 - xd1);
        printf("|%2d|%1.8f|%1.15fl|%1.8f|%1.15fl|\n", i, xf1, xd1, xf2, xd2);
    }
}



int main() {
    printf("zadanie 1 i 2\n\n");
    printf("|n |float xf1 |double xd1        |float xf2 |double xd2        |\n");
    seq();
    return 0;
}
