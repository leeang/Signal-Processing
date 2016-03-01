#include "SPWS2-notch.h"
#include <math.h>

#define SAMPLE_RATE	24000.0
#define PI 3.14159265359
#define N 24000
#define GAIN 40000000

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
float F = 550;

float alpha;
float beta;
float Bw;
double w0 = 550;
float B;
float p = 0;
float a1, a2, a3;
float b1, b2, b3;

static float xL[2] = {0.0};
static float xR[2] = {0.0};
static float yL[2] = {0.0};
static float yR[2] = {0.0};

void FilterCoeff(void)
{
	// TODO: 1. Initialise the filter coefficients
	//   You should write this function so the filter centre frequency and
	//   bandwidth can be easily changed.
	
	Bw = 0.1 * PI;
	F = 550.0;
	
	B = cos(Bw);
	alpha = (1 - sqrt(1-(B*B)))/B;
	beta = cos(w0*2*PI/SAMPLE_RATE);

	p = (1+alpha)/2;
	a1 = 1;
	a2 = -beta*(1+alpha);
	a3 = alpha;
	b1 = p;
	b2 = -2*beta*p;
	b3 = p;
	
}


void AddSinus(void)
{
	// TODO: 2. Add the sinusoidal disturbance to the input samples
	static int i=0;
	
	LeftInputCorrupted = LeftInput + (float)GAIN * sin(2 * PI * (550 / 24000.0) * (float)i);
    RightInputCorrupted = RightInput + (float)GAIN * sin(2 * PI * (550 / 24000.0) * (float)i);
	
	i = i + 1;
	i = i % N;
}

void NotchFilter(void)
{
	// TODO: 3. Filter the corrupted samples

	LeftOutputFiltered = b1*LeftInputCorrupted + b2*xL[0] + b3*xL[1]- a2*yL[0] - a3*yL[1];
	RightOutputFiltered = b1*RightInputCorrupted + b2*xR[0] + b3*xR[1]- a2*yR[0] - a3*yR[1];

	xL[1] = xL[0];
	xL[0] = LeftInputCorrupted;
	
	xR[1] = xR[0];
	xR[0] = RightInputCorrupted;

	yL[1] = yL[0];
	yL[0] = LeftOutputFiltered;
	
	yR[1] = yR[0];
	yR[0] = RightOutputFiltered;

}
