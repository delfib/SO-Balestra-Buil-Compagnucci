#include "arch.h"

// Initialize stack context for new task.
// Setup an initial context (callee saved register values) on stack.
// Push a saved ra register with pc value (task entry function address).
address init_context(address pc, address* sp)
{
    // Stack callee-saved registers. These register values will be restored in
    // the first context switch in switch_context.
    *--sp = 0;  // s11
    *--sp = 0;  // s10
    *--sp = 0;  // s9
    *--sp = 0;  // s8
    *--sp = 0;  // s7
    *--sp = 0;  // s6
    *--sp = 0;  // s5
    *--sp = 0;  // s4
    *--sp = 0;  // s3
    *--sp = 0;  // s2
    *--sp = 0;  // s1
    *--sp = 0;  // s0
    *--sp = pc; // ra
    return (address)sp;
}

void next_timer_interrupt(int cpu_id)
{
    // mtimecmp = mtime + interval
    *(uint64*)CLINT_MTIMECMP(cpu_id) = *(uint64*)CLINT_MTIME + T_INTERVAL;
    enable_timer_interrupts();
    // for debugging
    extern size_t mstatus, mie, mip;
    mstatus = r_mstatus();
    mie = r_mie();
    mip = r_mip();
}
