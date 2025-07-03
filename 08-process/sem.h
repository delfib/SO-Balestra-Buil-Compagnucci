#pragma once
#include "types.h"
#include "spinlock.h"

#define NSEM        16    // Maximum number of semaphores in system
#define NSEM_PROC   8     // Maximum number of semaphores per process

// Forward declaration
struct task;

// Semaphore structure
struct semaphore {
    int             id;           // Semaphore ID
    int             value;        // Current semaphore value
    int             ref_count;    // Number of processes using this semaphore
    bool            used;         // Is this semaphore slot used?
    spinlock        lock;         // Lock for atomic operations
    void*           wait_queue;   // Wait queue for blocked processes
};

// Per-process semaphore table entry
struct proc_sem {
    int             sem_id;       // Semaphore ID
    bool            used;         // Is this slot used?
};

// Global semaphore table
extern struct semaphore semaphores[NSEM];
extern spinlock sem_table_lock;

// Initialize semaphore system
void init_semaphores(void);

// System calls
int sys_semcreate(struct task *task);
int sys_semget(struct task *task);
int sys_sem_wait(struct task *task);
int sys_sem_signal(struct task *task);
int sys_sem_close(struct task *task);

// Internal helper functions
struct semaphore* find_semaphore(int id);
int alloc_semaphore(int id, int init_value);
void free_semaphore(int id);
int add_proc_semaphore(struct task* task, int sem_id);
void remove_proc_semaphore(struct task* task, int sem_id);
bool proc_has_semaphore(struct task* task, int sem_id);
