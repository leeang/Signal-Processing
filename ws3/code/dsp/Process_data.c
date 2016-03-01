#include "SPWS3.h"
#include "Params.h"

// input data buffer
fract32 input_data[N] = { 0 };

// output data buffers
fract32 output_buffer0[N] = { 0 };
fract32 output_buffer1[N] = { 0 };
fract32* output_current  = output_buffer0;       // pointer to buffer for processing
fract32* output_playback = output_buffer1;       // pointer to buffer to be played out

void process_data()
{
    // set running indicator leds
    static int cycle_time = 0;
    static int toggle_time = 0;
    
    cycle_time = (cycle_time + 1) % Fs;
	if (cycle_time == 0)
	{
	    toggle_time = !toggle_time;
	}
    led(0, toggle_time == 0);
    led(1, toggle_time == 1);
    
    
    // --- main program ---
    static int cycle = 0;
    cycle = (cycle + 1) % L;
    
    // get input data
	transfer_data_in();
    input_data[cycle] = iChannel0LeftIn;

    // swap output source every 5 sec
    static int sample = 0;
    static int mode = 0;
    sample++;
    sample = sample % (Fs * 5);
	if (sample == 0)
    {
	    mode = (mode + 1) % 3;
    }
    led(2, mode == 0);  // unfiltered input
    led(3, mode == 1);  // filtered using time domain method
    led(4, mode == 2);  // filtered using FFT method
    
    // output data
    float output;
    switch (mode)
	{
	    case 0:
	        // pass input directly to output
            iChannel0LeftOut = input_data[cycle];
            break;
        case 1:
            // filter using time domain method
            output = process_time((float)iChannel0LeftIn);
            iChannel0LeftOut = (int)output;
            break;
        case 2:
            // play out the buffered output from the last processed block
            iChannel0LeftOut = (int)(2.0 * output_playback[cycle]);
            // Note- scaling to avoid overflows in fixed point.
            // See init_process() for more information.
            break;
	}
	// for simplicity, just do filter one channel
    iChannel0RightOut = iChannel0LeftOut;
	transfer_data_out();
	
	// reached end of a block
	if (cycle == (L-1))
    {
        // swap the processing and playback buffers
        fract32* temp;
        temp = output_playback;
        output_playback = output_current;
        output_current = temp;
        
	    // flag that we need processing, but don't wait for it to be done here
        require_processing = 1;
	}
}
