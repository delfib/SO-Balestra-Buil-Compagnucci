#include "klib.h"
#include "arch.h"
#include "task.h"
#include "spinlock.h"

spinlock timer_lock = 0;

// kernel ticks (incremented in each timer interrupt)
volatile unsigned long ticks = 0;
static spinlock ticks_lock = 0;

volatile size_t mstatus = 0;
volatile size_t mie     = 0;
volatile size_t mip     = 0;

// high level trap handler. It will be the kernel entry point after boot.
void trap(struct trap_frame *tf)
{
    int    cpu_id     = cpuid();
    size_t cause      = trap_cause();
    size_t pc         = trap_pc();
    struct task* task = current_task();

    /* (for debugging)
    size_t sstatus = cpu_status();
    size_t sie     = r_sie();
    size_t sip     = r_sip();
    */


    /*
    (for debugging)
    printf("sstatus=%x, sie=%x, sip=%x\n", sstatus, sie, sip);
    printf("mstatus=%x, mie=%x, mip=%x\n", mstatus, mie, mip);
    */

    printf("trap: ticks=%d, cpu=%d, cause=%x, sepc=%x, tf->ra=%x task=%s\n",
            ticks, cpu_id, cause, pc, tf->ra, task ? task->name : "");
    switch (cause) {
        case TIMER_INTERRUPT:
            if (cpu_id == 0) {
                acquire(&ticks_lock);
                ticks++;
                release(&ticks_lock);
                wake_up_for_timer();
            }
            ack_timer_interrupt();
            
            // yield the CPU if current task is running in this cpu
            if (task && task == cpus_state[cpu_id].task && task->state == RUNNING) {
                yield();
            }
            break;

        case ILLEGAL_INSTRUCTION:
            if (task) {
                printf("Task %s in CPU %d illegal instruction at sepc=%x\n",
                       task->name, cpu_id, pc);
                terminate(-1);
            }
            break;

        default:
            panic("Unsupported trap\n");
    }
}
