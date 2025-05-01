#pragma once

#define TASK_MAX        8           // Maximum number of tasks
#define TASK_UNUSED     0           // Unused task/process control structure
#define TASK_RUNNABLE   1           // Runnable task
#define TASK_RUNNING    2           // CPU is running it
#define TASK_TERMINATED 3           // scheduler should free resources
#define TASK_SLEEPING   4           // task is sleeping for some amount of ticks
#define TASK_KSTACKSIZE PAGE_SIZE   // tasks kernel mode stack size
#define TASK_NAME_LEN   15          // task name max length

// task/process control block
struct task {
    int   pid;                      // Process ID
    char  name[TASK_NAME_LEN+1];    // Process name
    int   state;                    // Process state
    vaddr sp;                       // Saved stack pointer
    uint8 kstack[TASK_KSTACKSIZE];  // Kernel stack
    int wake_up_time;              // wake up time for sleeping task
};

void         init_tasks();
struct task* create_task(char *name, uint32 pc);
void         kill_task(struct task *task);
struct task* current_task(int cpu);
void         yield(void);
void         scheduler(void);
void         sleep(int sleepTicks);
struct task* get_all_tasks(void);