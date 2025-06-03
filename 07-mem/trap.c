#include "klib.h"
#include "arch.h"
#include "task.h"
#include "spinlock.h"

// high level trap handler. It will be the kernel entry point after boot.
void trap(struct trap_frame *tf)
{
    int     cpu_id     = cpuid();
    size_t  cause      = trap_cause();
    size_t  pc         = trap_pc();
    address fault_addr = fault_address();
    size_t  status     = cpu_status();
    struct  task* task = current_task();

    printf("trap: ticks=%d, cpu=%d, cause=%x, sepc=%x, tf->ra=%x task=%s\n",
           get_ticks(), cpu_id, cause, pc, tf->ra, task ? task->name : "");

    switch (cause) {
        case TIMER_INTERRUPT:
            if (cpu_id == 0) {
                inc_ticks();
            }
            ack_timer_interrupt();
            break;
        
        case LOAD_PAGE_FAULT:
        case LOAD_ACCESS_FAULT:
        case STORE_PAGE_FAULT:
        case STORE_ACCESS_FAULT:
            if (task) {
                printf("Task %s in CPU %d page fault sepc=%x, stval=%x\n",
                    task->name, cpu_id, pc, fault_addr);
                terminate(-1);
            } else
                panic("Kernel code page fault!\n");
        break;
        case ILLEGAL_INSTRUCTION:
            if (task) {
                printf("Task %s in CPU %d illegal instruction at sepc=%x\n",
                       task->name, cpu_id, pc);
                terminate(-1);
            } else
                panic("Kernel code page fault!\n");
            break;

        default:
            panic("Unsupported trap\n");
    }

    // yield the CPU if current task is running in this cpu
    if (running_in_cpu(cpu_id, task)) {
        if (cause == TIMER_INTERRUPT && --task->ticks == 0)
            yield();
    }

    // exit() or yield() may have caused some traps to occur,
    // so, restore trap address and cpu status.
    set_trap_pc(pc);
    set_cpu_status(status);
}
