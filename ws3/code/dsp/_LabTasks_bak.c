#include "SPWS3.h"
#include "Params.h"

complex_fract32 twiddle[N/2] = { 0 };
complex_fract32 filter_fft[N] = { 0 };

complex_fract32 input_freq[N] = { 0 };
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
    rfft_fr32(input_data, input_freq, twiddle, 1, N, &block_exponent, 1);

    // Y[k] = H[k] X[k]
    for (index = 0; index < N; index++) {
        output_fft[index] = cmlt_fr32(filter_fft[index], input_freq[index]);
    }
    
    complex_fract32 output_complex[N]= { 0 };
    
    // do ifft
    ifft_fr32(output_fft, output_complex, twiddle, 1, N, &block_exponent, 1);
    
    // rescale data points
    for (index = 0; index < N; index++) {
        output_complex[index].re = output_complex[index].re << (block_exponent);
        // output_complex[index].re <<= block_exponent;
        output[index] = output_complex[index].re;
        // the output will be real so copy just the real part
    }

    // overlap add
    for (index = 0; index < M-1; index++) {
        output[index] += output_save[index];
        output_save[index] = output[L+index];
    }
}
