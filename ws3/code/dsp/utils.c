#include "SPWS3.h"

void transfer_data_in()
{
	// copy input data from dma input buffer into variables
	iChannel0LeftIn = iRxBuffer1[INTERNAL_ADC_L0];
	iChannel0RightIn = iRxBuffer1[INTERNAL_ADC_R0];
	iChannel1LeftIn = iRxBuffer1[INTERNAL_ADC_L1];
	iChannel1RightIn = iRxBuffer1[INTERNAL_ADC_R1];
}

void transfer_data_out()
{
	// copy processed data from variables into dma output buffer
	iTxBuffer1[INTERNAL_DAC_L0] = iChannel0LeftOut;
	iTxBuffer1[INTERNAL_DAC_R0] = iChannel0RightOut;
	iTxBuffer1[INTERNAL_DAC_L1] = iChannel1LeftOut;
	iTxBuffer1[INTERNAL_DAC_L2] = iChannel1LeftOut;
	iTxBuffer1[INTERNAL_DAC_R1] = iChannel1RightOut;
	iTxBuffer1[INTERNAL_DAC_R2] = iChannel1RightOut;
}

void led(int id, int onoff)
{
    if (onoff)
        *pFlashA_PortB_Data |= (1 << id);
    else
        *pFlashA_PortB_Data &= ~(1 << id);
}
