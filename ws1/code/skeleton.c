#include <stdio.h>
#include <math.h>

// Globals
#define N	8
#define	PI	3.1415

float x[N];

int main(void) {
	int i;
	float omega1 = 0.25 * PI, omega2 = 1.0 * PI;
	float T = 1.0;

	for (i = 0; i < N; i++) {
		x[i] = 0.1 * (float)sin((float)omega1 * T * i);
	}

	for (i = 0; i < N; i++) {
		printf("x[%d] = %f\n", i, x[i]);
	}

	printf("Done.\n");

	return 0;
}
