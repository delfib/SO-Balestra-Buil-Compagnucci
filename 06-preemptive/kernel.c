#include "klib.h"
#include "arch.h"
#include "task.h"

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
    while (true) {
        int cpu = cpuid();
        printf("Task B in cpu %d \n", cpu);

        // a shot delay
        for (int i = 0; i < 300000000; i++)
            __asm__ __volatile__("nop");
    }
}

void kernel_main(void) {
    enable_interrupts();
    if (cpuid() == 0) {
        create_task("A", (uint32) task_a);
        create_task("B", (uint32) task_b);
    }

    // all cpus running in scheduler()
    scheduler();

    panic("unreachable here!");
}
