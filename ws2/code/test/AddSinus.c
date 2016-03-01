#define SAMPLE_RATE 24000.0
#define PI 3.14159265359

static float A = 3E8;           // noise amplitude
static float F = 550;           // Central frequency

void AddSinus(void) {
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
