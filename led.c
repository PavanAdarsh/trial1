#include "led.h"
#include "msp430.h"

void led_init()
{
	P1DIR |= 0X01;
}

void led_blink()
{
	P1OUT ^= 0X01;
}
	
