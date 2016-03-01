#include "SPWS2-notch.h"

int MusicSignal[100] = { 0 };

void Process_Data(void)
{
	static int i = 0;

    // store rolling buffer of 100 samples for plotting
	MusicSignal[i % 100] = iChannel0RightIn;
	
	RightInput = (float)iChannel0RightIn;
	LeftInput  = (float)iChannel0LeftIn;	
	
	// corrupt and filter the data
	AddSinus();
	NotchFilter();

	int time;
    time = (i / 24000) % 17;
	ledreset();
    
	// Play 5 seconds of the original music
	if (time <= 5) {
		iChannel0LeftOut = (int)LeftInput; 
		iChannel0RightOut = (int)RightInput; 
        led(0, 1);
	}
	// Play 5 seconds of corrupted music
	else if (time <= 10) {
		iChannel0LeftOut = (int)LeftInputCorrupted; 
		iChannel0RightOut = (int)RightInputCorrupted;
        led(1, 1);
	}
	// Play 5 seconds of filtered music
   else if (time <= 15) {
		iChannel0LeftOut = (int)LeftOutputFiltered;
		iChannel0RightOut = (int)RightOutputFiltered;
        led(2, 1);
	}
    // Play 1 second of silence
	else if (time <= 16) {
		iChannel0LeftOut = 0;
		iChannel0RightOut = 0;
	}
	// Reset counter
	else {
		i = 0;
	}

	i++;
}

