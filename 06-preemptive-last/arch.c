#include "arch.h"

void next_timer_interrupt(int cpu_id)
{
    // mtimecmp = mtime + interval
    *(uint64*)CLINT_MTIMECMP(cpu_id) = *(uint64*)CLINT_MTIME + T_INTERVAL;
    enable_timer_interrupts();
    
    /* for debugging
    extern size_t mstatus, mie, mip;
    mstatus = r_mstatus();
    mie = r_mie();
    mip = r_mip();
    */
}
