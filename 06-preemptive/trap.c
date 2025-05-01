#include "klib.h"
#include "arch.h"
#include "task.h"
#include "spinlock.h"

spinlock timer_lock = 0;

// kernel ticks (incremented in each timer interrupt)
volatile unsigned int ticks = 0;

volatile size_t mstatus = 0;
volatile size_t mie = 0;
volatile size_t mip = 0;

spinlock console_lock = 0;

void evaluate_sleeping_tasks()
{
    struct task *tasks = get_all_tasks();

    for (int i = 0; i < TASK_MAX; i++)
    {
        struct task *current_task = &(tasks[i]);

        acquire(&console_lock);
        printf("Task %s is in state %d\n", current_task->name, current_task->state);
        release(&console_lock);
        
        if (current_task->state == TASK_SLEEPING && current_task->wake_up_time <= ticks)
        {
            acquire(&console_lock);
            printf("Task %s is waking up at this moment %d!\n", current_task->name, ticks);
            release(&console_lock);
            current_task->state = TASK_RUNNABLE;
        }
    }
}

// high level trap handler. It will be the kernel entry point after boot.
void trap(struct trap_frame *tf)
{
    int cpu_id = cpuid();
    size_t cause = trap_cause();
    size_t pc = trap_pc();
    struct task *task = current_task(cpu_id);

    /* for debugging
    size_t sstatus = cpu_status();
    size_t sie     = r_sie();
    size_t sip     = r_sip();
    */

    acquire(&console_lock);
    printf("trap: ticks=%d, cpu=%d, cause=%x, sepc=%x\n",
           ticks, cpu_id, cause, pc);
    release(&console_lock);

    /*
    (for debugging)
    printf("sstatus=%x, sie=%x, sip=%x\n", sstatus, sie, sip);
    printf("mstatus=%x, mie=%x, mip=%x\n", mstatus, mie, mip);
    */

    switch (cause)
    {
    case TIMER_INTERRUPT:
        if (cpu_id == 0)
        {
            ticks++;
            evaluate_sleeping_tasks();
            acquire(&console_lock);
            printf("\nticks=%d\n", ticks);
            release(&console_lock);
        }
        clear_timer_interrupt_pending();
        if (task)
        {
            yield();
        }
        break;

    case ILLEGAL_INSTRUCTION:
        if (task)
        {
            kill_task(task);
        }
        break;

    default:
        panic("Unsupported trap\n");
    }
}