#include "stdio.h"
#include "math.h"
#include "input.c"

#define M 47
#define BUFFER_SIZE     (M-1)
#define REM(INDEX)      ((INDEX) + BUFFER_SIZE) % BUFFER_SIZE

float process_time(float x0)
{
    // TODO: 1. Implement the filter using time domain methods

    static float xBuffer[BUFFER_SIZE] = {0.0};          // BUFFER_SIZE = (M-1) is defined in 'Params.h'
    static int current = 0;

    // M = 47 odd
    // y[n] = h[0]x[n] + h[1]x[n − 1] + ... + h[M − 1]x[n − M + 1]
    //      = (h[0]x[n] + h[M − 1]x[n − M + 1]) + (h[1]x[n-1] + h[M − 2]x[n − M + 2]) + ... + h[(M-1)/2]x[(M-1)/2]

    float y = b[0] * (x0 + xBuffer[REM(current)]);      // Macro 'REM(current)' is defined in 'Params.h'
    // h[0]x[n] + h[M − 1]x[n − M + 1]

    xBuffer[current] = x0;
    // save current x0 into xBuffer after 'y' is calculated, thus the size of 'xBuffer' can be reduced by 1 (from M to M-1).

    for (int i = 1; i <= BUFFER_SIZE/2-1; i++) {
        y += b[i] * (xBuffer[REM(current-i)] + xBuffer[REM(current+i)]);
    }
    // (h[1]x[n-1] + h[M − 2]x[n − M + 2]) + ... + (h[(M-1)/2-1]x[(M-1)/2+1] + h[(M-1)/2+1]x[(M-1)/2-1])

    y += b[BUFFER_SIZE/2] * xBuffer[REM(current-BUFFER_SIZE/2)];
    // h[(M-1)/2]x[(M-1)/2]

    current++;
    current %= BUFFER_SIZE;
    
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
