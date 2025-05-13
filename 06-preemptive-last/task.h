#pragma once
#include "arch.h"
#include "spinlock.h"

#define TASK_NAME_LEN 81

#define TASK_MAX  16    // Maximum number of tasks

#define QUANTUM   4     // Number of ticks for each task quantum

// task state
#define UNUSED     0    // Unused task/process control structure
#define RUNNABLE   1    // Runnable task
#define RUNNING    2    // CPU is running it
#define WAITING    3    // task is in some waiting queue
#define TERMINATED 4    // finished task (but yet exist in tasks table)

// task/process control block
struct task {
    int            tid;                 // Process ID
    char           name[TASK_NAME_LEN]; // task name
    int            state;               // Task state
    int            exit_code;           // exit code for terminated tasks
    struct context ctx;                 // Saved context
    uint8          kstack[PAGE_SIZE];   // Kernel-mode stack
    uint64         sleep_ticks;         // Waiting for ticks
    int            cpu_id;              // CPU in which this task is running
    void*          wait_condition;      // Waiting condition
    spinlock       lock;                // lock for task
    int            quantum_ticks;               // ticks for this task
};

// CPU state
struct cpu_state {
    int    noff;        // disable_interrupts() nested calls
    bool   irq_enabled; // interrupts enabled/disabled
    struct task* task;  // current task
    struct context ctx; // saved main thread (scheduler) context
};

// export cpus_state (for spinlock.c and others)
extern struct cpu_state cpus_state[NCPU];

// get and increment ticks value
unsigned int get_ticks(void);
void         inc_ticks(void);

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

// Suspend current task for given condition
void         suspend(void* condition, spinlock* lk);

// Make RUNNABLE all tasks waiting for condition
void         wakeup(void* condition);

// Terminate current task.
void         terminate(int exit_code);
