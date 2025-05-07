#include "klib.h"
#include "arch.h"
#include "task.h"

static volatile int ready = 0;

void task_a(void) {
    while (true) {
        int cpu = cpuid();
        printf("Task A in cpu %d \n", cpu);
        // invalid_instruction();

        // a short delay
        for (int i = 0; i < 500000000; i++)
            __asm__ __volatile__("nop");
    }
}

void task_b(void) {
    int cpu = cpuid();
    printf("Task B in cpu %d, going to sleep...\n", cpu);
    sleep(5);
    printf("Task B in cpu %d, awake... finishing now.\n", cpu);
    terminate(0);
}

void kernel_main(void) {
    enable_interrupts();
    if (cpuid() == 0) {
        create_task("A", task_a);
        create_task("B", task_b);
        __sync_synchronize();
        ready = 1;
    }
    while (!ready)
        ;
    __sync_synchronize();
    scheduler();
}
