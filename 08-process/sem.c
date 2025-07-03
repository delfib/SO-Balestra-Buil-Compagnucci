#include "sem.h"
#include "task.h"
#include "klib.h"
#include "spinlock.h"

// Global semaphore table
struct semaphore semaphores[NSEM];
spinlock sem_table_lock = {0};

// Initialize semaphore system
void init_semaphores(void)
{
    for (int i = 0; i < NSEM; i++) {
        semaphores[i].id = -1;
        semaphores[i].value = 0;
        semaphores[i].ref_count = 0;
        semaphores[i].used = false;
        semaphores[i].lock = (spinlock){0};
        semaphores[i].wait_queue = NULL;
    }
}

// Find semaphore by ID
struct semaphore* find_semaphore(int id)
{
    for (int i = 0; i < NSEM; i++) {
        if (semaphores[i].used && semaphores[i].id == id) {
            return &semaphores[i];
        }
    }
    return NULL;
}

// Allocate a new semaphore
int alloc_semaphore(int id, int init_value)
{
    acquire(&sem_table_lock);
    
    // Check if semaphore with this ID already exists
    if (find_semaphore(id) != NULL) {
        release(&sem_table_lock);
        return -1; // Semaphore already exists
    }
    
    // Find free slot
    for (int i = 0; i < NSEM; i++) {
        if (!semaphores[i].used) {
            semaphores[i].id = id;
            semaphores[i].value = init_value;
            semaphores[i].ref_count = 1;
            semaphores[i].used = true;
            semaphores[i].lock = (spinlock){0};
            semaphores[i].wait_queue = NULL;
            release(&sem_table_lock);
            return 0; // Success
        }
    }
    
    release(&sem_table_lock);
    return -1; // No free slots
}

// Free a semaphore
void free_semaphore(int id)
{
    acquire(&sem_table_lock);
    struct semaphore* sem = find_semaphore(id);
    if (sem && sem->ref_count > 0) {
        sem->ref_count--;
        if (sem->ref_count == 0) {
            sem->used = false;
            sem->id = -1;
            sem->value = 0;
            sem->wait_queue = NULL;
        }
    }
    release(&sem_table_lock);
}

// Add process semaphore reference
int add_proc_semaphore(struct task* task, int sem_id)
{
    // Find free slot in process semaphore table
    for (int i = 0; i < NSEM_PROC; i++) {
        if (!task->proc_sems[i].used) {
            task->proc_sems[i].sem_id = sem_id;
            task->proc_sems[i].used = true;
            return 0;
        }
    }
    return -1; // No free slots
}

// Remove process semaphore reference
void remove_proc_semaphore(struct task* task, int sem_id)
{
    for (int i = 0; i < NSEM_PROC; i++) {
        if (task->proc_sems[i].used && task->proc_sems[i].sem_id == sem_id) {
            task->proc_sems[i].used = false;
            task->proc_sems[i].sem_id = -1;
            return;
        }
    }
}

// Check if process has access to semaphore
bool proc_has_semaphore(struct task* task, int sem_id)
{
    for (int i = 0; i < NSEM_PROC; i++) {
        if (task->proc_sems[i].used && task->proc_sems[i].sem_id == sem_id) {
            return true;
        }
    }
    return false;
}

//=============================================================================
// System calls implementation
//=============================================================================

// semcreate(int id, int init_value)
int sys_semcreate(struct task *task)
{
    struct trap_frame *tf = task_trap_frame_address(task);
    int id = (int) syscall_arg(tf, 0);
    int init_value = (int) syscall_arg(tf, 1);
    
    if (init_value < 0) {
        return -1; // Invalid initial value
    }
    
    int result = alloc_semaphore(id, init_value);
    if (result == 0) {
        // Add to process semaphore table
        if (add_proc_semaphore(task, id) != 0) {
            free_semaphore(id);
            return -1;
        }
    }
    
    return result;
}

// semget(int id)
int sys_semget(struct task *task)
{
    struct trap_frame *tf = task_trap_frame_address(task);
    int id = (int) syscall_arg(tf, 0);
    
    acquire(&sem_table_lock);
    struct semaphore* sem = find_semaphore(id);
    if (sem) {
        // Check if process already has access
        if (proc_has_semaphore(task, id)) {
            release(&sem_table_lock);
            return 0; // Already have access
        }
        
        // Add reference
        if (add_proc_semaphore(task, id) == 0) {
            sem->ref_count++;
            release(&sem_table_lock);
            return 0; // Success
        }
    }
    release(&sem_table_lock);
    return -1; // Semaphore not found or no free slots
}

// sem_wait(int id)
int sys_sem_wait(struct task *task)
{
    struct trap_frame *tf = task_trap_frame_address(task);
    int id = (int) syscall_arg(tf, 0);
    
    // Check if process has access to this semaphore
    if (!proc_has_semaphore(task, id)) {
        return -1;
    }
    
    struct semaphore* sem = find_semaphore(id);
    if (!sem) {
        return -1;
    }
    
    acquire(&sem->lock);
    
    while (sem->value <= 0) {
        // Block the process
        suspend(&sem->wait_queue, &sem->lock);
        acquire(&sem->lock);
    }
    
    sem->value--;
    release(&sem->lock);
    
    return 0;
}

// sem_signal(int id)
int sys_sem_signal(struct task *task)
{
    struct trap_frame *tf = task_trap_frame_address(task);
    int id = (int) syscall_arg(tf, 0);
    
    // Check if process has access to this semaphore
    if (!proc_has_semaphore(task, id)) {
        return -1;
    }
    
    struct semaphore* sem = find_semaphore(id);
    if (!sem) {
        return -1;
    }
    
    acquire(&sem->lock);
    sem->value++;
    
    // Wake up waiting processes
    wakeup(&sem->wait_queue);
    
    release(&sem->lock);
    
    return 0;
}

// sem_close(int id)
int sys_sem_close(struct task *task)
{
    struct trap_frame *tf = task_trap_frame_address(task);
    int id = (int) syscall_arg(tf, 0);
    
    // Check if process has access to this semaphore
    if (!proc_has_semaphore(task, id)) {
        return -1;
    }
    
    // Remove from process table
    remove_proc_semaphore(task, id);
    
    // Decrease reference count
    free_semaphore(id);
    
    return 0;
}
