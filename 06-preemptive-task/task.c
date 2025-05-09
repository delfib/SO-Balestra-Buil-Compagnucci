#include "arch.h"
#include "klib.h"
#include "task.h"
#include "spinlock.h"

struct cpu_state cpus_state[NCPU];

// tasks/processes table
static struct task tasks[TASK_MAX];

// scheduler (kernel main) thread stack pointer (per cpu)
static address scheduler_sp[NCPU];

// for task/process id assignment
static uint last_tid = 0;

void init_tasks(void)
{
    for (int i=0; i < NCPU; i++) {
        cpus_state[i].task = NULL;
    }
    for (int i=0; i < TASK_MAX; i++) {
        tasks[i].state = UNUSED;
        tasks[i].next = NULL;
        tasks[i].lock = 0;
    }
}

// Kernel tasks must call at start
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
            task->sp = (address)(task->kstack + PAGE_SIZE);
            task->sp = init_context((address) f, (address*)task->sp);
            task->tid = ++last_tid;
            task->cpu_id = -1;
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
            // pick a new task or one that was running in this CPU
            if (tasks[i].state == RUNNABLE &&            
                (tasks[i].cpu_id == -1 || tasks[i].cpu_id == cpu_id)) {
                struct task* next_task = &tasks[i];
                next_task->state = RUNNING;
                next_task->cpu_id = cpu_id;
                cpus_state[cpu_id].task = next_task;

                printf("scheduler: Task %s in CPU %d\n", next_task->name, cpu_id);
    
                context_switch(&scheduler_sp[cpu_id], &next_task->sp);
                cpus_state[cpu_id].task = NULL;
            }
            release(&tasks[i].lock);
        }
    }
}

// current task leaves CPU
void yield(void)
{
    int cpu_id = cpuid();
    struct task *current = cpus_state[cpu_id].task;
    if (!current)
        panic("yield");
    
    printf("yield task %s in CPU %d\n", current->name, cpu_id);
    acquire(&current->lock);
    int irq = cpus_state[cpu_id].enabled;
    if (current->state == RUNNING)
        current->state = RUNNABLE;
    context_switch(&current->sp, &scheduler_sp[cpu_id]);

    // scheduler jumps here
    cpus_state[cpu_id].enabled = irq;
    release(&current->lock);

    // printf("CPU %d noff: %d\n", cpu_id, cpus_state[cpu_id].noff);
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
    // sleep current task for n ticks
    struct task *task = current_task();
    
    acquire(&task->lock);

    task->ticks = n;
    task->state = WAITING;

    release(&task->lock);
    yield();
}


// wakeup sleeping (for timer) tasks 
void wake_up_for_timer(void)
{
    // awake waiting tasks for time
    for (int i = 0; i < TASK_MAX; i++)
    {
        struct task *current_task = &(tasks[i]);
        acquire(&current_task->lock);
        
        if (current_task->state == WAITING)
        {
            current_task->ticks--;
            if (current_task->ticks <= 0)
            {
                current_task->ticks = 0;
                current_task->state = RUNNABLE;
            }
        }
        release(&current_task->lock);
    }
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
