#include "klib.h"
#include "arch.h"

// task a stack and saved stack pointer
uint8   stack_task_a[PAGE_SIZE];
uint32* task_a_sp;

// task b's stack and saved stack pointer
uint8   stack_task_b[PAGE_SIZE];
uint32* task_b_sp;

// main thread (kernel_main() function) saved stack pointer on context switch
uint32* main_thread_sp;

// create a task with initial program counter and stack pointer.
// return top stack pointer
uint32* create_task(uint32 pc, uint32 *sp)
{
    return init_task_context(pc, sp);
}

// task entry function
void task_a(void)
{
    printf("Task A on cpu %d\n", cpuid());

    // resume task B
    context_switch((uint32*) &task_a_sp, (uint32*) &task_b_sp);

    printf("Task A on cpu %d again!\n", cpuid());

    // resume main thread
    context_switch((uint32*) &task_a_sp, (uint32*) &main_thread_sp);
}

void task_b(void)
{
    printf("Task B on cpu %d\n", cpuid());

    // resume task A
    context_switch((uint32*) &task_b_sp, (uint32*) &task_a_sp);

    printf("Task B on cpu %d again!\n", cpuid());

    // resume main thread
    //context_switch((uint32*) &task_b_sp, (uint32*) &main_thread_sp);
    stop();
}

// main kernel function. boot() in arch.c calls it
void kernel_main(void) {
    if (cpuid() == 0) {
        task_a_sp = create_task((uint32) task_a,
                                (uint32*) (stack_task_a + PAGE_SIZE));
        task_b_sp = create_task((uint32) task_b,
                                (uint32*) (stack_task_b + PAGE_SIZE));

        printf("In kernel_main() thread\n");
    
        // resume task_a
        context_switch((uint32*) &main_thread_sp, (uint32*) &task_a_sp);
    
        printf("In kernel initial thread again!\n");

        // resume task_b
        context_switch((uint32*) &main_thread_sp, (uint32*) &task_b_sp);
    }
    stop();
}

// `main_thread -> task_a -> task_b -> task_a -> main_thread -> task_b`.