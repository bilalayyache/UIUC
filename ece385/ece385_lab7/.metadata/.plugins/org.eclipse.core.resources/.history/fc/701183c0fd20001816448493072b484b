// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x50; //make a pointer to access the PIO block
	volatile unsigned int *SW_PIO = (unsigned int*)0x20;
	volatile unsigned int *reset_PIO  = (unsigned int*)0x40;
	volatile unsigned int *accumulate_PIO  = (unsigned int*)0x30;


	*LED_PIO = 0; //clear all LEDs
//	while (1) //infinite loop
//	{
//		for (i = 0; i < 100000; i++); //software delay
//		*LED_PIO |= 0x1; //set LSB
//		for (i = 0; i < 100000; i++); //software delay
//		*LED_PIO &= ~0x1; //clear LSB
//		printf("*reset = %d\n", *reset_PIO);
//		if (*reset_PIO == 1)
//			break;
//	}
//	*LED_PIO &= 0x0; // reset all LED
	int flag = 0;
	while (1){
		if (*reset_PIO == 0)
				*LED_PIO = 0;
		if (*accumulate_PIO == 0 && flag == 0){
			*LED_PIO += *SW_PIO;
			if (*LED_PIO > 255)
				*LED_PIO -= 256;
			flag = 1;
		}
		else if (*accumulate_PIO == 1)
			flag = 0;
	}

	return 1; //never gets here
}
