#include "SPWS3.h"
#include "sysreg.h"
#include "ccblkfn.h"
#include <stdio.h>

// array for registers to configure the ad1836
// names are defined in "Talkthrough.h"
volatile short sCodec1836TxRegs[CODEC_1836_REGS_LENGTH] =
{									
    DAC_CONTROL_1	| 0x000,
    DAC_CONTROL_2	| 0x000,
    DAC_VOLUME_0	| 0x3ff,
    DAC_VOLUME_1	| 0x3ff,
    DAC_VOLUME_2	| 0x3ff,
    DAC_VOLUME_3	| 0x3ff,
    DAC_VOLUME_4	| 0x3ff,
    DAC_VOLUME_5	| 0x3ff,
    ADC_CONTROL_1	| 0x000,
    ADC_CONTROL_2	| 0x180,
    ADC_CONTROL_3	| 0x000
};

// SPORT0 DMA transmit buffer
volatile int iTxBuffer1[8];

// SPORT0 DMA receive buffer
volatile int iRxBuffer1[8];

int iChannel0LeftIn;
int iChannel0RightIn;
int iChannel0LeftOut;
int iChannel0RightOut;
int iChannel1LeftIn;
int iChannel1RightIn;
int iChannel1LeftOut;
int iChannel1RightOut;

int require_processing = 0;

void main(void)
{
    sysreg_write(reg_SYSCFG, 0x32);		// Initialize System Configuration Register
	
	init_process();

    Init_EBIU();
	Init_Flash();
	Init1836();
	Init_Sport0();
	Init_DMA();
	Init_Sport_Interrupts();
	Enable_DMA_Sport0();
	
    // run forever
	printf("Starting.\n");
	while (1)
	{
	    // check if we need to process a block
	    if (require_processing)
	    {
	        require_processing = 0;
	        process_block(output_current);
	    }
	}
}
