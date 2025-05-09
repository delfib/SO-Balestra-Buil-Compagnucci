#pragma once
#include "arch.h"
#include "spinlock.h"

#define TASK_NAME_LEN 81

#define TASK_MAX  16    // Maximum number of tasks

// task state
#define UNUSED     0    // Unused task/process control structure
#define RUNNABLE   1    // Runnable task
#define RUNNING    2    // CPU is running it
#define WAITING    3    // task is in some waiting queue
#define TERMINATED 4    // finished task (but yet exist in tasks table)

// task/process control block
struct task {
    int          tid;                 // Process ID
    char         name[TASK_NAME_LEN]; // task name
    int          state;               // Task state
    int          exit_code;           // exit_cod for terminated tasks
    address      sp;                  // Saved stack pointer
    uint8        kstack[PAGE_SIZE];   // Kernel-mode stack
    uint64       sleep_ticks;         // Waiting for ticks
    struct task* next;                // waiting queue
    int          cpu_id;              // CPU in which this task is running
    spinlock     lock;                // lock for task
    uint ticks;                        // ticks the task will be asleep for
};

// CPU state
struct cpu_state {
    int    noff;        // disable_interrupts() nested calls
    bool   enabled;     // interrupts enabled/disabled
    struct task* task;  // current task
};
extern struct cpu_state cpus_state[NCPU];

// task wait queues
struct wait_queue {
    struct task* first;
    struct task* last;
    spinlock     lock;
};

// initialize tasks descriptors table
void init_tasks(void);

// init task. Must be called at task start.
void init_task(void);

// type task_function
typedef void (*task_function)(void);

// create a RUNNABLE task
struct task* create_task(char* name, task_function pc);

// get current task. If kernel is in scheduler context, it return NULL.
struct task* current_task(void);

// current task yield CPU by doing a contexto switch to scheduler.
void         yield(void);

// select next task to run and do context switch.
void         scheduler(void);

// sleep for a number of ticks
void         sleep(uint ticks);

// wakeup tasks waiting for ticks
void         wake_up_for_timer(void);

// Suspend current task and put in queue q.
void         suspend(struct wait_queue* q);

// Make RUNNABLE first task waiting in q.
void         wakeup(struct wait_queue* q);

// Terminate current task.
void         terminate(int exit_code);
