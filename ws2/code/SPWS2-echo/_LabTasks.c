#include "SPWS2-echo.h"

// Input samples
float LeftInput;
float RightInput;

// Output samples
float loa, lob, loc;

// Declare any global variables you need
#define N 1760

static float alpha13 = 0.75;
static float alpha2 = 0.6;

static float input[N] = {0.0};
static float outputB[N] = {0.0};
static float outputC[N] = {0.0};

static int current = 0;

void EchoFilter(void) {
    /* TODO: Implement echo filter (a) */
    loa = LeftInput + alpha13 * input[current];
    // input[current] is input[current] in last sampling period because it has not been updated.

    /* TODO: Implement echo filter (b) */
    outputB[current] = LeftInput - alpha2 * outputB[current];
    // the second outputB[current] is outputB[current] in last sampling period. outputB[current] is update by this line.
    lob = outputB[current];

    /* TODO: Implement echo filter (c) */
    outputC[current] = input[current] - alpha13 * LeftInput + alpha13 * outputC[current];
    // input[current] is input[current] in last sampling period because it has not been updated.
    // the second outputC[current] is outputC[current] in last sampling period. outputC[current] is update by this line.
    loc = outputC[current];

    /* update input[current] */
    input[current] = LeftInput;

    current++;
    current = current % N;
}
