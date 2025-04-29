#include "arch.h"
#include "klib.h"
#include "task.h"
#include "spinlock.h"

// ticks (number of clock interrupts), defined in trap.c
extern unsigned int ticks;

// tasks/processes table
static struct task tasks[TASK_MAX];
static spinlock tasks_lock = 0;

// Current task pointers (per cpu)
static struct task* current_tasks[NCPU];

// scheduler stack pointer
static uint32 scheduler_sp[NCPU];

// for task/process id assignment
static uint32 last_pid = 0;

// return current_task in give cpu
struct task * current_task(int cpu)
{
    return current_tasks[cpu];
}

// create task with 'pc' as initial program counter
struct task* create_task(char *name, uint32 pc) {
    // Find an unused process control structure.
    struct task *task = NULL;
    int i;
    acquire(&tasks_lock);
    for (i = 0; i < TASK_MAX; i++) {
        if (tasks[i].state == TASK_UNUSED) {
            task = &(tasks[i]);
            break;
        }
    }

    if (!task)
        panic("no free tasks slots\n");

    uint32* stack_bottom = (uint32 *)(task->kstack + TASK_KSTACKSIZE);

    // Initialize fields on task structure.
    task->sp = (vaddr) init_context(pc, stack_bottom);
    task->pid = ++last_pid;
    if (strlen(name) > TASK_NAME_LEN)
        name[TASK_NAME_LEN] = '\0';
    strcpy(task->name, name);
    task->state = TASK_RUNNABLE;
    release(&tasks_lock);
    return task;
}

static void destroy_task(struct task * task)
{
    // free slot
    task->state = TASK_UNUSED;
}

// select a new task to give the CPU
void scheduler(void)
{
    int cpu_id = cpuid();

    while (1) {
        current_tasks[cpu_id] = NULL;
        for (int i=0; i<TASK_MAX; i++) {
            acquire(&tasks_lock);
            if (tasks[i].state == TASK_RUNNABLE) {        
                struct task *next_task = &(tasks[i]);

                // task runnable found: context switch
                next_task->state = TASK_RUNNING;
                current_tasks[cpu_id] = next_task;
                release(&tasks_lock);
                // resume next task
                enable_interrupts();  // needed only for kernel tasks
                context_switch(&(scheduler_sp[cpu_id]), &(next_task->sp));
                if (next_task->state == TASK_TERMINATED) {
                    destroy_task(next_task);
                }
            } else {
                release(&tasks_lock);
            }
        }
    }
}

// current task leaves CPU
void yield(void)
{
    int cpu_id = cpuid();
    struct task *task = current_tasks[cpu_id];
    if (task->state != TASK_TERMINATED) {
        task->state = TASK_RUNNABLE;
    }
    // CPU leaves current task, resume scheduler
    context_switch(&(task->sp), &(scheduler_sp[cpu_id]));
}

void  kill_task(struct task *task)
{
    task->state = TASK_TERMINATED;
    yield();
}