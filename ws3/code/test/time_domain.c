#include "stdio.h"
#include "math.h"
#include "input.c"

#define M 47
#define REM(INDEX)      ((INDEX) + M) % M

float process_time(float x0)
{
    // TODO: 1. Implement the filter using time domain methods

    static float xBuffer[M] = {0.0};
    static int current = 0;

    xBuffer[current] = x0;

    float y = 0;
    for (int i = 0; i < M; i++) {
        y += b[i] * xBuffer[REM(current-i)];    // Macro 'REM(current)' is defined in 'Params.h'
    }

    current++;
    current %= M;
    
    return y;
}

int main(void) {

    for (int indexMain = 0; indexMain < 600; ++indexMain) {
        float x0 = input[indexMain];
        
        float y = process_time(x0);

        printf("%f\t", y);
    }
    printf("\n");

    return 0;
}
