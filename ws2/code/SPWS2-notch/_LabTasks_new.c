#include "SPWS2-notch.h"

#define SAMPLE_RATE 24000.0
#define PI 3.14159265359

// Input samples
float LeftInput; 
float RightInput;

// Corrupted samples
float LeftInputCorrupted; 
float RightInputCorrupted;

// Filtered samples
float LeftOutputFiltered; 
float RightOutputFiltered;


// TODO: 0. Define your own global coefficients for filtering
#define BUFFER_SIZE     2
//define the buffer size

#define INDEX(CURRENT)  ((CURRENT) + BUFFER_SIZE) % BUFFER_SIZE
// if an index is negative, a specified position from the end of the array will be returned.
// e.g. given an array x[8], x[INDEX(-1)] and x[INDEX(7)] both refer to x[7].

static float A = 1E8;           // noise amplitude
static float BW = 0.1 * PI;     // Bandwidth
static float F = 550;           // Central frequency

static double alpha, beta;      // filter coefficients

static float a1, a2;
static float b0, b1, b2;

static float xBufferL[BUFFER_SIZE] = {0.0};
static float xBufferR[BUFFER_SIZE] = {0.0};
// input buffer (Left and Right)

static float yBufferL[BUFFER_SIZE] = {0.0};
static float yBufferR[BUFFER_SIZE] = {0.0};
// output buffer (Left and Right)


void FilterCoeff(void) {
    // TODO: 1. Initialise the filter coefficients
    //   You should write this function so the filter centre frequency and
    //   bandwidth can be easily changed.

    beta = cos(F * 2 * PI / SAMPLE_RATE);

    double cosine = cos(BW);
    alpha = 1/cosine - sqrt(1/(cosine*cosine) - 1);

    printf("alpha=%f\nbeta=%f\n", alpha, beta);

    float p = (1 + alpha) / 2;
    a1 = -beta * (1 + alpha);
    a2 = alpha;
    b0 = p;
    b1 = -2 * beta * p;
    b2 = p;
}


void AddSinus(void) {
    // TODO: 2. Add the sinusoidal disturbance to the input samples

    static int index = 0;
    // declaring as static keeps 'index' between invocations

    float disturbance = A * cos(F * 2 * PI * index / SAMPLE_RATE);
    // sinusoid wave

    index++;
    index = index % (int)SAMPLE_RATE;
    // 'index' counts from 0 up to SAMPLE_RATE and starts at 0 again.
    // in case of 'index' overflow

    LeftInputCorrupted = LeftInput + disturbance;
    RightInputCorrupted = RightInput + disturbance;
}

void NotchFilter(void) {
    // TODO: 3. Filter the corrupted samples

    LeftOutputFiltered = b0 * LeftInputCorrupted + b1 * xBufferL[0] + b2 * xBufferL[1] - a1 * yBufferL[0] - a2 * yBufferL[1];
    RightOutputFiltered = b0 * RightInputCorrupted + b1 * xBufferR[0] + b2 * xBufferR[1] - a1 * yBufferR[0] - a2 * yBufferR[1];

    xBufferL[1] = xBufferL[0];
    xBufferR[1] = xBufferR[0];

    yBufferL[1] = yBufferL[0];
    yBufferR[1] = yBufferR[0];

    xBufferL[0] = LeftInputCorrupted;
    xBufferR[0] = RightInputCorrupted;

    yBufferL[0] = LeftOutputFiltered;
    yBufferR[0] = RightOutputFiltered;
}
