#include "klib.h"
#include "arch.h"
#include "task.h"

void task_a(void) {
    while (1) {
        int cpu = cpuid();
        printf("Task A in cpu %d \n", cpu);
        yield();

        // a short delay
        for (int i = 0; i < 300000000; i++)
            __asm__ __volatile__("nop");
    }
}

void task_b(void) {
    while (1) {
        int cpu = cpuid();
        printf("Task B in cpu %d \n", cpu);
        yield();

        // a shot delay
        for (int i = 0; i < 300000000; i++)
            __asm__ __volatile__("nop");
    }
}

void task_c(void) {
    while (1) {
        int cpu = cpuid();
        printf("Task C in cpu %d \n", cpu);
        yield();

        // a shot delay
        for (int i = 0; i < 300000000; i++)
            __asm__ __volatile__("nop");
    }
}

void kernel_main(void) {
    if (cpuid() == 0) {
        create_task((address) task_a, 2);
        create_task((address) task_c, 4);
        create_task((address) task_b, 4);
    }

    // all cpus running in scheduler()
    scheduler();

    panic("unreachable here!");
}