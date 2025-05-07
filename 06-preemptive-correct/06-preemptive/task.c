#include "arch.h"
#include "klib.h"
#include "task.h"
#include "spinlock.h"

#define TASK_MAX  16    // Maximum number of tasks

// task state
#define UNUSED     0    // Unused task/process control structure
#define RUNNABLE   1    // Runnable task
#define RUNNING    2    // CPU is running it
#define WAITING    3    // task is in some waiting queue
#define TERMINATED 4    // finished task (but yet exist in tasks table)

// tasks/processes table
static struct task tasks[TASK_MAX];
static spinlock tasks_lock = 0;

// Current task pointers (per cpu)
static struct task* current_tasks[NCPU];

// scheduler (kernel main) thread stack pointer (per cpu)
static address scheduler_sp[NCPU];

// for task/process id assignment
static uint last_tid = 0;

void init_tasks(void)
{
    for (int i=0; i < TASK_MAX; i++) {
        tasks[i].state = UNUSED;
        tasks[i].next = NULL;
    }
}

// return current_task in this cpu
struct task* current_task(void)
{
    return current_tasks[cpuid()];
}

// create task with 'pc' as initial program counter
struct task* create_task(char* name, task_function f) {
    // Find an unused tasks table slot
    struct task *task = NULL;
    int i;
    acquire(&tasks_lock);
    for (i = 0; i < TASK_MAX; i++) {
        if (tasks[i].state == UNUSED) {
            task = &(tasks[i]);
            task->sp = (address)(task->kstack + PAGE_SIZE);
            task->sp = init_context((address) f, (address*)task->sp);
            task->tid = ++last_tid;
            if (strlen(name) > TASK_NAME_LEN)
                name[TASK_NAME_LEN - 1] = '\0';
            strcpy(task->name, name);
            task->state = RUNNABLE;
            break;
        }
    }
    release(&tasks_lock);
    return task;
}

// select a new task to give the CPU
void scheduler(void)
{
    int cpu_id = cpuid();

    current_tasks[cpu_id] = NULL;
    while (1) {
        enable_interrupts();
        for (int i=0; i<TASK_MAX; i++) {
            acquire(&tasks_lock);
            if (tasks[i].state == RUNNABLE) {        
                struct task* next_task = tasks + i;

                next_task->state = RUNNING;
                current_tasks[cpu_id] = next_task;
                release(&tasks_lock);
                context_switch(&scheduler_sp[cpu_id], &next_task->sp);
                current_tasks[cpu_id] = NULL;
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
    struct task *current = current_tasks[cpu_id];
    if (current->state == RUNNING) {
        current->state = RUNNABLE;
    }
    context_switch(&current->sp, &scheduler_sp[cpu_id]);
}

// Suspend (sleep) current task and put in queue q.
void suspend(struct wait_queue* q)
{
    struct task* t = current_task();
    t->next = NULL;
    t->state = WAITING;
    acquire(&q->lock);
    if (!q->last) {
        q->first = q->last = t;
    } else {
        q->last->next = t;
        q->last = t;
    }
    release(&q->lock);
    yield();
}

// Make RUNNABLE first task waiting in q.
void wakeup(struct wait_queue* q)
{
    acquire(&q->lock);
    if (q->first) {
        struct task* t = q->first;
        q->first = t->next;
        if (!q->first)
            q->last = NULL;
        t->state = RUNNABLE;
    }
    release(&q->lock);
}

// sleep for n ticks
void sleep(uint n)
{
    struct task *t = current_task();
    if (!t)
        panic("sleep: No current task!");
    t->sleep_ticks = n;
    t->state = WAITING;
    yield();
}

// wakeup sleeping (for timer) tasks 
void wake_up_for_timer(void)
{
    acquire(&tasks_lock);
    for (int i = 0; i < TASK_MAX; i++) {
        if (tasks[i].state == WAITING && tasks[i].sleep_ticks > 0) {
            if (--tasks[i].sleep_ticks == 0) {
                tasks[i].state = RUNNABLE;
            }
        }
    }
    release(&tasks_lock);
}

// Terminate current task.
void terminate(int exit_code)
{
    struct task* t = current_task();
    t->state = TERMINATED;
    t->exit_code = exit_code;

    // to do: free resources (opened files, memory, ...)

    yield();
}
