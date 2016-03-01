#include "SPWS3.h"
#include "Params.h"

complex_fract32 twiddle[N/2] = { 0 };
complex_fract32 filter_fft[N] = { 0 };

complex_fract32 input_fft[N] = { 0 };
complex_fract32 output_fft[N] = { 0 };
fract32 output_save[M-1] = { 0 };

// array b
float b[] = { -0.023442, 0.002569, 0.003110, 0.004042, 0.005350, 
        0.006991, 0.008953, 0.011183, 0.013656, 0.016321, 
        0.019156, 0.022085, 0.025091, 0.028018, 0.030937, 
        0.033753, 0.036369, 0.038771, 0.040886, 0.042684, 
        0.044126, 0.045181, 0.045806, 0.046024, 0.045806, 
        0.045181, 0.044126, 0.042684, 0.040886, 0.038771, 
        0.036369, 0.033753, 0.030937, 0.028018, 0.025091, 
        0.022085, 0.019156, 0.016321, 0.013656, 0.011183, 
        0.008953, 0.006991, 0.005350, 0.004042, 0.003110, 
        0.002569, -0.023442 };

float process_time(float x0)
{
    // TODO: 1. Implement the filter using time domain methods

    static float xBuffer[BUFFER_SIZE] = {0.0};          // BUFFER_SIZE = (M-1) is defined in 'Params.h'
    static int current = 0;

/*
    float y = b[0] * x0;
    for (int i = 1; i <= BUFFER_SIZE; i++) {
        y += b[i] * xBuffer[REM(current-i)];
    }
*/

    // M = 47 odd
    // y[n] = h[0]x[n] + h[1]x[n - 1] + ... + h[M - 1]x[n - M + 1]
    //      = (h[0]x[n] + h[M - 1]x[n - M + 1]) + (h[1]x[n-1] + h[M - 2]x[n - M + 2]) + ... + h[(M-1)/2]x[(M-1)/2]

    float y = b[0] * (x0 + xBuffer[REM(current)]);      // Macro 'REM(current)' is defined in 'Params.h'
    // h[0]x[n] + h[M - 1]x[n - M + 1]

    xBuffer[current] = x0;
    // save current x0 into xBuffer after 'y' is calculated, thus the size of 'xBuffer' can be reduced by 1 (from M to M-1).

    for (int i = 1; i <= BUFFER_SIZE/2-1; i++) {
        y += b[i] * (xBuffer[REM(current-i)] + xBuffer[REM(current+i)]);
    }
    // (h[1]x[n-1] + h[M - 2]x[n - M + 2]) + ... + (h[(M-1)/2-1]x[(M-1)/2+1] + h[(M-1)/2+1]x[(M-1)/2-1])

    y += b[BUFFER_SIZE/2] * xBuffer[REM(current-BUFFER_SIZE/2)];
    // h[(M-1)/2]x[(M-1)/2]

    current++;
    current %= BUFFER_SIZE;
    
    return y;
}

void init_process()
{
    int i;

    // calculate twiddle factors
    twidfftrad2_fr32(twiddle, N);
    
    // copy filter coefficients to input array to do fft
    for (i = 0; i < M; i++)
        input_data[i] = (1 << 30) * b[i];
        // [ note ]
        // Here we should scale by (1 << 31)-1 for full scale, however
        // doing so can cause overflows in fixed point, so we halve it
        // here and put back the factor 2 on output.
    
    // do fft
    int filter_blk_exp;
    rfft_fr32(input_data, filter_fft, twiddle, 1, N, &filter_blk_exp, 1);
    
    // rescale data points
    for (i = 0; i < N; i++)
    {
        filter_fft[i].re = filter_fft[i].re << (filter_blk_exp);
        filter_fft[i].im = filter_fft[i].im << (filter_blk_exp);
    }
    
    // clear input array
    for (i = 0; i < M; i++)
        input_data[i] = 0;
}

void process_block(fract32 output[])
{
    // TODO: 2. Implement the filter using the overlap-add method

    int index = 0;
    
    // do fft
    int block_exponent;
    rfft_fr32(input_data, input_fft, twiddle, 1, N, &block_exponent, 1);

    // Y[k] = H[k] X[k]
/*
    for (index = 0; index < N; index++) {
        output_fft[index] = cmlt_fr32(filter_fft[index], input_fft[index]);
    }
*/
    // use conjugate symmetry to reduce complex computations
    output_fft[0] = cmlt_fr32(filter_fft[0], input_fft[0]);
    for (index = 1; index < N/2; index++) {
        output_fft[index] = cmlt_fr32(filter_fft[index], input_fft[index]);
        output_fft[N-index] = conj_fr32(output_fft[index]);
    }
    output_fft[N/2] = cmlt_fr32(filter_fft[N/2], input_fft[N/2]);
    
    complex_fract32 output_complex[N]= { 0 };
    
    // do ifft
    ifft_fr32(output_fft, output_complex, twiddle, 1, N, &block_exponent, 1);
    
    for (index = 0; index < N; index++) {
        // output_complex[index].re = output_complex[index].re << (block_exponent);
        // output_complex[index].im = output_complex[index].im << (block_exponent);
        // rescale data points

        // output[index] = output_complex[index].re;
        // the output will be real so copy just the real part

        output[index] = output_complex[index].re << (block_exponent);
        // combine the previous lines of code into a single line
    }

    // overlap add
/*
    MATLAB style code
    index = 1:M-1;
    output[index] = output[index] + output_save[index];
    output_save[index] = output[L+index];
*/
    for (index = 0; index < M-1; index++) {
        output[index] += output_save[index];
        output_save[index] = output[L+index];
    }
}
