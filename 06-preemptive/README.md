# Preemptive tasks

In this project we handle clock interrupts to implement preemtive multitasking.

## The Core local interrupt controller (CLINT)

There is a CLINT device per core. It provide timer functionalities.
In our platform the CLINT controller is memory mapped starting at address
0x2000000.

It contains a _shared_ 64 bits timer counter register (MTIME) witch is updated
by the internal clock and counts cycles from boot.

For each hart there is a 64 bits comparator register (MTIME*CMP). See `arch.h`
to see memory mapped addresses. This registes only can be accesed in \_machine
mode*.

When MTIME reaches the MTIME*CMP register, it throws an interrupt and jumps to a
\_machine mode trap handler*.

In `arch.c` we added the `next_timer_interrupt(int cpu_id)` function to schedule
the next timer interrupt.

This function simply put in the MTIME_CMP register the value of MTIME plus an
constant interval.

This RISC-V board CLINT

## Trap handling

In this step we have included low and high level trap handling.

In `arch.s` we add two low level trap handling routines:

On boot, the `mtvec` CSR was set to point to `m_trap`, so the `m_trap` routine
handle traps in _machine mode_. Timer interrupts are handled here.
It just call to `next_timer_interrupt(int cpu_id)` function.

Also, on boot each hart was set to handle other interrupts in _supervisor mode_
by setting `stvec` to `s_trap`.

A trap handler running in machine mode can _delegate_ trap handling to
_supervisor mode_. It is done in `m_trap` routine by setting the _supervisor
interrupt pending_ CSR (`sip`) bit 2 (timer interrupts). So, the `mret`
instruction will jump to `s_trap` routine.

The `s_trap` handler save all CPU registers in current stack, calls the
`trap(sp)` high level trap handling function (in `trap.c`).

The `trapframe` structure represents the interrupted task state saved on its
stack.

Function `trap(struct trapframe* tf)` get the trap cause
_interrupt, exception or software interrupt number)_ and handle the
corresponding case.

For now, we are interested only in timer interrupts.

In such a case, it increments a global `ticks` variable and makes current task
leaves the CPU by calling `yield()`.

## Exercises

1. Suppose a 32 bits timer running at 1Mhz (1000000 cycles per second). How long
   it takes to overflow?

__Respuesta__

Para calcular cuanto tarda un temporizador de 32 bits a 1 MHz en desbordarse, necesitamos determinar el valor maximo que puede almacenar y dividirlo entre la frecuencia.

Un temporizador de 32 bits puede contar de 0 a 2^32, lo que equivale a 4.294.967.296 valores.

Dado que el temporizador funciona a 1000000 de ciclos por segundo (1 MHz), el tiempo de desbordamiento es:

Tiempo de desbordamiento = Valor maximo / Frecuencia
Tiempo de desbordamiento = (2^32 - 1) / 1.000.000
Tiempo de desbordamiento = 4.294.967.296 / 1.000.000
Tiempo de desbordamiento = 4294,97 segundos

```bash
Por lo tanto un temporizador de 32 bits que funciona a 1 MHz se desbordara despues de aproximadamente 4295 segundos, lo que equivale a aproximadamente 1,20 horas, o lo que es lo mismo 71,58 minutos.
```

2. Suppose an OS con a 32 bits internal clock counter incremented each second.
   In how many days it will overflow? And for a 64 bits counter?  

__Respuesta__

Si contamos con contador de reloj interno de 32 bits el cual es incrementado cada segundo, este puede contar desde el número 0 hasta 2^32, siendo el valor máximo 4.294.967.296. Como este contador se incrementa por segundo, va a tardar 4.294.967.296 segundos hasta llegar a su valor máximo en donde ocurrirá un overflow.

tiempo de desbordamiento / segundos por dia  
4.294.967.296 / 24 * 60 * 60  = 49.710,27 dias

```bash
Lo cual equivale a 136 años.
```

Si ahora tenemos el contador de 64 bits, haciendo el mismo cálculo:

tiempo de desbordamiento / segundos por dia  
18.446.744.073.709.551.616 / 24 * 60 * 60 = 213.503.982.334.601,28 dias

```bash
Lo cual equivale a 584.942.417.355 de años.
```

3. Define a function `sleep(ticks)` which _sleep_ the calling task for the
   `ticks` given. Modifies the `trap()` handling function to _wake up_ a sleeping
   task when the time elapsed expired.