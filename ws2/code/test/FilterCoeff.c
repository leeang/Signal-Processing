#define SAMPLE_RATE 24000.0
#define PI 3.14159265359

static float BW = 0.1 * PI;     // Bandwidth
static float F = 550;           // Central frequency

static double alpha, beta;      // filter coefficients
static double a1, a2;
static double b0, b1, b2;

void FilterCoeff(void) {
    beta = cos(F * 2 * PI / SAMPLE_RATE);

    double cosine = cos(BW);
    alpha = 1/cosine - sqrt(1/(cosine*cosine) - 1);

    printf("alpha=%f\nbeta=%f\n", alpha, beta);

    double coefficient = (1 + alpha) / 2;
    a1 = -beta * (1 + alpha);
    a2 = alpha;
    b0 = coefficient;
    b1 = -2 * beta * coefficient;
    b2 = coefficient;
}
