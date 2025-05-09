# Preemptive tasks

In this project we handle clock interrupts to implement preemtive multitasking.

## The Core local interrupt controller (CLINT)

There is a CLINT device per core. It provide timer functionalities.
In our platform the CLINT controller is memory mapped starting at address
0x2000000.

It contains a *shared* 64 bits timer counter register (MTIME) witch is updated
by the internal clock and counts cycles from boot.

For each hart there is a 64 bits comparator register (MTIME_CMP). See `arch.h`
to see memory mapped addresses. This registes only can be accesed in *machine
mode*.

When MTIME reaches the MTIME_CMP register, it throws an interrupt and jumps to a
*machine mode trap handler*.

In `arch.c` we added the `next_timer_interrupt(int cpu_id)` function to schedule
the next timer interrupt.

This function simply put in the MTIME_CMP register the value of MTIME plus an
constant interval.

This RISC-V board CLINT 

## Trap handling

In this step we have included low and high level trap handling.

In `arch.s` we add two low level trap handling routines:

On boot, the `mtvec` CSR was set to point to `m_trap`, so the `m_trap` routine
handle traps in *machine mode*. Timer interrupts are handled here.
It just call to `next_timer_interrupt(int cpu_id)` function.

Also, on boot each hart was set to delegate other interrupts to *supervisor mode*
and set `stvec` pointing to `s_trap`.

With this configuration, each hart will deliver timer interrupts to `m_trap` and
other interrupts and exceptions to `s_trap`.

The `m_trap` routine (running in machine mode) *delegate* trap handling to
*supervisor mode*. It is done by setting the *supervisor interrupt pending* CSR
(`sip`) bit 2 (timer interrupts). The `mret` instruction will jump to `s_trap`
routine.

The `s_trap` handler save all CPU registers in current stack and the it calls
the `trap(sp)` high level trap handling function (defined in `trap.c`).

The `trapframe` structure represents the interrupted task state saved on its
kernel mode stack.

The function `trap(struct trapframe* tf)` get the trap cause *interrupt,
exception or software interrupt number)* and handle the corresponding case.

For now, we are interested only in timer interrupts. In such a case, it
increments a global `ticks` variable and makes current task leaves the CPU by
calling `yield()`.

## Exercises

1. Suppose a 32 bits timer running at 1Mhz (1000000 cycles per second). How long
   it takes to overflow?

2. Suppose an OS con a 32 bits internal clock counter incremented each second.
   In how many days it will overflow? And for a 64 bits counter?

3. 

3. Define a function `sleep(ticks)` which *sleep* the calling task for the
   `ticks` given. Modifies the `trap()` handling function to *wake up* a
   sleeping task when the time elapsed expired.

4. Define a contant `QUANTUM` which represents the maximum number of ticks used
   by a `RUNNING` task. A task should yield the CPU when it has consumed its
   quantum. Note: When a task is scheduled, it starts a new quantum.
