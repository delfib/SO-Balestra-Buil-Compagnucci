#include "arch.h"
#include "klib.h"
#include "task.h"
#include "spinlock.h"

// tasks/processes table
//- holding all the tasks
static struct task tasks[TASK_MAX];
static spinlock tasks_lock = 0;

// Current task pointers (per cpu)
static struct task* current_tasks[NCPU];

// scheduler stack pointers (per cpu)
static uint32 scheduler_sp[NCPU];

// for task/process id assignment
static uint32 last_pid = 0;

// return current_task in this cpu
struct task* current_task(void)
{
    return current_tasks[cpuid()];
}

// create task with 'pc' as initial program counter
struct task* create_task(uint32 pc, int priority) {
    // Find an unused tasks table slot
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

    // Initialize task structure
    task->sp = (vaddr) init_context(pc, stack_bottom);
    task->pid = ++last_pid;
    task->state = TASK_RUNNABLE;
    task->priority = priority;
    release(&tasks_lock);
    return task;
}

// select a new task to give the CPU
void scheduler(void)
{
    int cpu_id = cpuid();

    while (1) {
        current_tasks[cpu_id] = NULL;
        struct task* highest = NULL;

        for (int i=0; i<TASK_MAX; i++) {
            acquire(&tasks_lock);
            if (tasks[i].state == TASK_RUNNABLE) {    
                if (highest == NULL || tasks[i].priority > highest->priority) {
                    highest = &tasks[i];
                }
            } 
            release(&tasks_lock);
        }
        if (highest) {
            highest->state = TASK_RUNNING;
            current_tasks[cpu_id] = highest;
            release(&tasks_lock);
            context_switch(&(scheduler_sp[cpu_id]), &(highest->sp));
        }
    }
}

// current task leaves CPU
void yield(void)
{
    int cpu_id = cpuid();
    struct task *current = current_tasks[cpu_id];
    if (!current) {
        panic("yield(): No current task!");
    }
    current->state = TASK_RUNNABLE;
    context_switch(&(current->sp), &(scheduler_sp[cpu_id]));
}