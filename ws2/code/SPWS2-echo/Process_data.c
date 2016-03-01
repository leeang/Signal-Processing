#include "SPWS2-echo.h"

void Process_Data(void)
{
	static int i = 0;

	LeftInput = (float)iChannel0LeftIn;
	RightInput = (float)iChannel0RightIn;

	// run echo filters
	EchoFilter();

	int time;
	time = (i / 4000) % 28;
	ledreset();

	// Play 3 seconds of the original signal
	if (time <= 5) {
		iChannel0LeftOut = iChannel0LeftIn;
		iChannel0RightOut = iChannel0RightIn;
		led(0, 1);
	}
	// Play half a second of silence
	else if (time <= 6) {
		iChannel0LeftOut = 0; 
		iChannel0RightOut = 0;
	}
	// Play 3 seconds of signal with echo a)
	else if (time <= 12) {
		iChannel0LeftOut = (int)loa;
		iChannel0RightOut = (int)loa;
		led(1, 1);
	}
	// Play half a second of silence
	else if (time <= 13) {
		iChannel0LeftOut = 0;
		iChannel0RightOut = 0;
	}
	// Play 3 seconds of signal with echo b)
	else if (time <= 19) {
		iChannel0LeftOut = (int)lob;
		iChannel0RightOut = (int)lob;
		led(2, 1);
	}
	// Play half a second of silence
	else if (time <= 20) {
		iChannel0LeftOut = 0;
		iChannel0RightOut = 0;
	}
	// Play 3 seconds of signal with echo c)
	else if (time <= 26) {
		iChannel0LeftOut = (int)loc;
		iChannel0RightOut = (int)loc;
		led(3, 1);
	}	// Play 1 seconds of silence
	else if (time <= 27) {
		iChannel0LeftOut = 0; 
		iChannel0RightOut = 0;
	}
	else {
		i = 0;
	}

	i++;
}

