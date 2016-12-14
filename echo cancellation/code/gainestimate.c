#include "SP2WS1.h"
#include <time.h>


// input signal history
float insignal1[100], insignal2[100];


// function prototypes
void gainestimateLMS(float,float,float,float[2]);
void gainestimateRLS(float,float,float,float[2]);


void gainestimate(float in1, float in2, float out, float gain[2])
{
    // record input signal history for checking signal magnitude using plot facility
    for (int i = 99; i > 0; i--)
    {
        insignal1[i] = insignal1[i-1];
        insignal2[i] = insignal2[i-1];
    }
    insignal1[0] = in1;
    insignal2[0] = in2;


    // estimate gain
    // gain[0] = 0;
    // gain[1] = 1;
    gainestimateLMS(in1, in2, out, gain);
    //gainestimateRLS(in1, in2, out, gain);
}

void gainestimateLMS(float in1, float in2, float out, float gain[2])
{
    // TODO: Implement gain estimation using LMS algorithm
    float err = out - (in1 * gain[0] + in2 * gain[1]);
    float factor = 1e-18 * err;
    gain[0] += in1 * factor;
    gain[1] += in2 * factor;
}

void gainestimateRLS(float in1, float in2, float out, float gain[2])
{
    // TODO: Implement gain estimation using RLS algorithm
    static float P11 = 1e-19;
    static float P12 = 0.0;
    static float P21 = 0.0;
    static float P22 = 1e-19;

    float lambda = 0.98;
    float lambda_reciprocal = 1.020408163;

    static int index = 0;
    long clocks = clock();

    float v1 = P11*in1;
    float v2 = P12*in1;
    float v3 = P12*in2;
    float v4 = P21*in1;
    float v5 = P21*in2;
    float v6 = P22*in2;

    float den_reciprocal = 1 / ( lambda + in1*(v1 + v5) + in2*(v2 + v6) );

    P11 = (P11 - (v1*(v1 + v3) + v5*(v1 + v3)) * den_reciprocal) * lambda_reciprocal;
    P12 = (P12 - (v2*(v1 + v3) + v6*(v1 + v3)) * den_reciprocal) * lambda_reciprocal;
    P21 = (P21 - (v1*(v4 + v6) + v5*(v4 + v6)) * den_reciprocal) * lambda_reciprocal;
    P22 = (P22 - (v2*(v4 + v6) + v6*(v4 + v6)) * den_reciprocal) * lambda_reciprocal;

    float err = out - in1*gain[0] - in2*gain[1];
    gain[0] += err * (v1 + v3);
    gain[1] += err * (v4 + v6);

    clocks = clock() - clocks;

    if (!index) {
        printf("Clocks: %d\n", clocks);
        printf("CLOCKS_PER_SEC: %d\n", CLOCKS_PER_SEC);
    }

    index++;
    index %= 48000;
}
