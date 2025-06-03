#include "klib.h"
#include "arch.h"
#include "task.h"
#include "kalloc.h"
#include "vm.h"

static struct task* btask;

void task_a(void) {
    struct task* current = current_task();
    bool b_finished = false;
    init_task();
    while (true) {
        printf("Task %s in cpu %d \n", current->name, cpuid());
        // invalid_instruction();

        // a short delay
        for (uint i = 0; i < 50000000; i++)
            __asm__ __volatile__("nop");

        if (current->name[0] == 'A' && !b_finished) {
            printf("Task A: waiting for task B...\n");
            wait_for_task(btask);
            b_finished = true;
        }
    }
}

void task_b(void) {
    init_task();
    printf("Task B in cpu %d, going to sleep for 4 ticks...\n", cpuid());
    sleep(5);
    
    printf("Task B in cpu %d awaked.\n", cpuid());

    // to do: task want to use va pointer to virtual address 0x1000.
    // 1: verify the following code will throw a page fault at (*)
    // 2: explain why this happens
    char *va = (char*) 0x1000;
    paddr pa = alloc_page();
    
    // to do: map va to pa physical address here and test again
    
    va[0] = 'B'; // (*) page fault here

    printf("Task B contents at va 0x1000: %s\n", va);

    // unmap the page
    unmap_page(btask->pgtbl, va, true);

    printf("Task B in cpu %d... exiting.\n", cpuid());
    terminate(0);
    panic("task B after terminate()");
}

static volatile int ready = 0;

void kernel_main(void) {
    if (cpuid() == 0) {
        init_kalloc();          // pages allocator
        init_vm();              // set kernel page table
        init_tasks();           // tasks

        // create some tasks
        create_task("A", task_a);
        printf("task A created!\n");
        btask = create_task("B", task_b);
        printf("task B created!\n");
        create_task("C", task_a);
        printf("task C created!\n");

        __sync_synchronize();
        ready = 1;
    }
    while (!ready)
        ;
    __sync_synchronize();

    // in each CPU
    enable_paging();
    printf("Running scheduler on CPU %d\n", cpuid());
    scheduler();
}
