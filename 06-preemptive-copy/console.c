#include "types.h"
#include "spinlock.h"

#define UART        0x10000000
#define UART_THR    (uint8*)(UART+0x00)
#define UART_LSR    (uint8*)(UART+0x05)
#define UART_STATUS_EMPTY 0x40

static spinlock console_lock = 0;

int console_putc(char ch) 
{
    // wait for UART transmitter register empty
	while ((*UART_LSR & UART_STATUS_EMPTY) == 0)
        ;
    // write character to UART THR to start transmission
	return *UART_THR = ch;
}

// write string to console
void console_puts(const char *s) 
{
    acquire(&console_lock);
	while (*s)
        console_putc(*s++);
    release(&console_lock);
}
