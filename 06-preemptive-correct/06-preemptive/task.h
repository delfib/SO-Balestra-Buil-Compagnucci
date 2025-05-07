#pragma once
#include "arch.h"
#include "spinlock.h"

#define TASK_NAME_LEN 81

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
};

// task wait queues
struct wait_queue {
    struct task* first;
    struct task* last;
    spinlock     lock;
};

// initialize tasks descriptors table
void init_tasks(void);

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
