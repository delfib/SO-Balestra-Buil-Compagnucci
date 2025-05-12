#include "arch.h"
#include "klib.h"
#include "task.h"
#include "spinlock.h"

// kernel ticks (incremented in each timer interrupt)
static volatile unsigned int ticks = 0;
static spinlock ticks_lock = 0;

// CPUs state
struct cpu_state cpus_state[NCPU];

// tasks/processes table
static struct task tasks[TASK_MAX];

// for task/process id assignment
static uint last_tid = 0;

void init_tasks(void)
{
    for (int i=0; i < NCPU; i++) {
        cpus_state[i].task = NULL;
    }
    for (int i=0; i < TASK_MAX; i++) {
        tasks[i].state = UNUSED;
        tasks[i].lock = 0;
    }
}

// Kernel tasks must call it at start
void init_task(void)
{
    release(&current_task()->lock);
    enable_interrupts();
}

// return current_task in this cpu
struct task* current_task(void)
{
    return cpus_state[cpuid()].task;
}

// create task with 'pc' as initial program counter
struct task* create_task(char* name, task_function f) {
    // Find an unused tasks table slot
    struct task *task = NULL;

    for (int i = 0; i < TASK_MAX && !task; i++) {
        acquire(&tasks[i].lock);
        if (tasks[i].state == UNUSED) {
            task = &(tasks[i]);
            memset(&task->ctx, 0, sizeof(struct context));
            task->ctx.ra = (address) f;
            task->ctx.sp = (address) (task->kstack + PAGE_SIZE);
            task->tid = ++last_tid;
            task->cpu_id = -1;
            task->wait_condition = 0;
            if (strlen(name) > TASK_NAME_LEN)
                name[TASK_NAME_LEN - 1] = '\0';
            strcpy(task->name, name);
            task->state = RUNNABLE;
        }
        release(&tasks[i].lock);
    }
    return task;
}

// select a new task to give the CPU
void scheduler(void)
{
    int cpu_id = cpuid();
    cpus_state[cpu_id].task = NULL;
    while (1) {
        enable_interrupts();
        for (int i=0; i<TASK_MAX; i++) {
            acquire(&tasks[i].lock);
            if (tasks[i].state == RUNNABLE) {
                struct task* next_task = &tasks[i];
                next_task->state = RUNNING;
                next_task->cpu_id = cpu_id;
                cpus_state[cpu_id].task = next_task;

                // switch to next_task (continue task execution)
                context_switch(&cpus_state[cpu_id].ctx, &next_task->ctx);

                // task give up this cpu
                next_task->cpu_id = -1;
                cpus_state[cpu_id].task = NULL;
            }
            release(&tasks[i].lock);
        }
    }
}

// Switch context to scheduler.
// Preconditions:
// 1. current->lock aquired.
// 2. cpus_state[cpu_id].noff == 1
// 3. interrupts enabled
// 4. current->state == RUNNING
static void sched(int cpu_id, struct task* current)
{
    int irq = cpus_state[cpu_id].irq_enabled;

    // switch to scheduler context
    context_switch(&current->ctx, &cpus_state[cpu_id].ctx);

    // later, scheduler will jump here. Set previous irq state.
    cpus_state[cpu_id].irq_enabled = irq;
}

// current task leaves CPU
void yield(void)
{
    int cpu_id = cpuid();
    struct task *current_task = cpus_state[cpu_id].task;

    if (!current_task)
        panic("yield");

    printf("yield task %s in CPU %d\n", current_task->name, cpu_id);

    acquire(&current_task->lock);

    if (current_task->state == RUNNING)
        current_task->state = RUNNABLE;
    sched(cpu_id, current_task);

    // we are comming from scheduler context switch with task locked
    release(&current_task->lock);
}

// Suspend (sleep) current task. Lock lk is related to waiting condition or
// resource.
// Invariant: cause != NULL && lk acquired
void suspend(void* condition, spinlock* lk)
{
    struct task* t = current_task();
    acquire(&t->lock);

    // release lk to avoid deadlock
    release(lk);
    t->wait_condition = condition;
    t->state = WAITING;

    sched(cpuid(), t);

    // task resume execution here
    t->wait_condition = 0;
    release(&t->lock);

    // acquire lock again
    acquire(lk);
}

// Make RUNNABLE tasks waiting for condition
void wakeup(void* condition)
{
    struct task* current = current_task();
    for (int i = 0; i < TASK_MAX; i++) {
        struct task* t = &tasks[i];
        if (t != current) {
            acquire(&t->lock);
            if (t->state == WAITING && t->wait_condition == condition) {
                t->state = RUNNABLE;
            }
            release(&t->lock);
        }
    }
}

// current task sleep for n ticks
void sleep(uint n)
{
    struct task *t = current_task();
    if (!t)
        panic("sleep: No current task!");
    acquire(&ticks_lock);
    t->sleep_ticks = n;
    suspend((void*) &ticks, &ticks_lock);
    release(&ticks_lock);
}

// get ticks value
unsigned int get_ticks(void)
{
    unsigned int result;
    acquire(&ticks_lock);
    result = ticks;
    release(&ticks_lock);
    return result;
}

// wakeup sleeping (for timer) tasks 
static void wake_up_for_timer(void)
{
    for (int i = 0; i < TASK_MAX; i++) {
        acquire(&tasks[i].lock);
        if (tasks[i].state == WAITING && tasks[i].sleep_ticks > 0) {
            if (--tasks[i].sleep_ticks == 0) {
                tasks[i].state = RUNNABLE;
            }
        }
        release(&tasks[i].lock);
    }
}

// increment ticks. Called from trap() in trap.c
void inc_ticks(void)
{
    acquire(&ticks_lock);
    ticks++;
    release(&ticks_lock);
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
