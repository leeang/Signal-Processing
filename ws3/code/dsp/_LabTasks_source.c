#include "SPWS3.h"
#include "Params.h"

complex_fract32 twiddle[N/2] = { 0 };
complex_fract32 filter_fft[N] = { 0 };

complex_fract32 input_freq[N] = { 0 };
complex_fract32 output_fft[N] = { 0 };
fract32 output_save[M-1] = { 0 };

float b[] = { 1 };

float process_time(float x0)
{
	// TODO: 1. Implement the filter using time domain methods

    float y;
    y = x0;
    
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

	int i;
	for (i = 0; i < N; i++)
	{
		// Note- the input is scaled by half here because the output will
		// be scaled to account for the filter coefficient scaling above.
		// In your filtering code you should NOT do this.
		output[i] = input_data[i] / 2;
	}
}
