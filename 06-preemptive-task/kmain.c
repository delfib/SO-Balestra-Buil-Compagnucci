#include "klib.h"
#include "arch.h"
#include "task.h"

static volatile int ready = 0;

void task_a(void) {
    struct task* current = current_task();
    init_task();
    while (true) {
        int cpu = cpuid();
        printf("Task %s in cpu %d \n", current->name, cpu);
        // invalid_instruction();

        // a short delay
        for (uint i = 0; i < 50000000; i++)
            __asm__ __volatile__("nop");
    }
}

void task_b(void) {
    int cpu = cpuid();
    init_task();
    printf("Task B in cpu %d, going to sleep...\n", cpu);
    sleep(5);
    printf("Task B in cpu %d, awake... finishing now.\n", cpu);
    terminate(0);
}

void kernel_main(void) {
    if (cpuid() == 0) {
        init_tasks();
        create_task("A", task_a);
        printf("task A created!\n");
        create_task("B", task_b);
        printf("task B created!\n");
        create_task("C", task_a);
        printf("task C created!\n");
        __sync_synchronize();
        ready = 1;
    }
    while (!ready)
        ;
    __sync_synchronize();
    scheduler();
}
