#pragma once

#define TASK_MAX        8           // Maximum number of tasks
#define TASK_KSTACKSIZE PAGE_SIZE   // tasks kernel mode stack size

// task state
#define TASK_UNUSED     0           // Unused task/process control structure
#define TASK_RUNNABLE   1           // Runnable task
#define TASK_RUNNING    2           // CPU is running it
#define TASK_WAITING    3           // task is waiting for some event

// wait queue
struct task;                        // forward reference
struct wait_queue {
    struct task* next;
};

// task/process control block
struct task {
    int pid;                        // Process ID
    int state;                      // Process state
    int priority;                   // higher the number, higher the priority
    vaddr sp;                       // Saved stack pointer
    uint8 kstack[TASK_KSTACKSIZE];  // Kernel stack
    struct wait_queue* next;        // waiting queue
};

// create_task(pc, stack, priority)
struct task* create_task(uint32 pc, int priority);
struct task* current_task(void);
void         yield(void);
void         scheduler(void);