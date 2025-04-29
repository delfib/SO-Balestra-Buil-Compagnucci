#include "arch.h"

// number of disable_interrupts on cpu
struct cpu_irq {
    int  noff;
    bool enabled;
};
static struct cpu_irq cpu_irq_status[NCPU];

void push_irq_off(void)
{
    bool old = irq_enabled();
    int cpu_id = cpuid();

    disable_interrupts();
    if (cpu_irq_status[cpu_id].noff == 0) {
        cpu_irq_status[cpu_id].enabled = old;
    }
    cpu_irq_status[cpu_id].noff++;
}

void pop_irq_off(void)
{
    int cpu_id = cpuid();
    cpu_irq_status[cpu_id].noff--;
    if (cpu_irq_status[cpu_id].noff == 0 && cpu_irq_status[cpu_id].enabled) {
        enable_interrupts();
    }
}

// Initialize stack context for new task.
// Setup an initial context (callee saved register values) on stack.
// Push a saved ra register with pc value (task entry function address).
// Return the updated stack pointer value.
uint32* init_context(uint32 pc, uint32* sp)
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
    return sp;
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