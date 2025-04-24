# Context switch

Here we built a basic machinery to handle simple threads (or for now,
*coroutines*).

A task or coroutine transfers control to another by *resuming* execution of other
task. Each task has its own stack an its program counter. In the stack we have
control information about local variables and function arguments. Also, in
general we have to save function return addresses.

## Technique

Each thread uses its own stack. In the `boot()`function the main thread stack is
set. 

To create a new thread, we define its stack and initialize it with saved
register values. Also is saved the *return* or
*continuation addrress* with the thread entry (initial) function address. 

In RISC-V the routine return instruction `ret` copies to *program counter* `pc`
the value of *return address register* `ra`.

The function `init_task_context(pc, &sp)` set ups the initial stack content with
the saved return address with `pc` program counter value received on first argument.

A *context switch* is a control transfer from a running or current thread to a
new one.

The `switch_context(&current_sp, &next_sp)` function stops current thread and
jumps (*resume*) to next thread. Here threads are represented by its stack
pointers. Argument `current_sp` is an *out parameter*. It will take the new
stack pointer of current thread (pointed by `sp` register). The `next_sp`
argument is the address (reference) to next thread stack pointer. The new thread
state is *poped* from `next_sp` and it is updated.

This function does the following steps:

1. Save (push) CPU (*callee saved*) registers in `prev_sp` given and update it
   to stack top.
2. Switch CPU `sp` register to point to next stack top.
3. Restore (pop) CPU registers values from next stack.
   It restore the program return address register (`ra`). Then the `ret`
   instruction will jump to this address which is the thread point in the
   previous context switch in the past (when it left the cpu).

## Testing the context switch

In the `kernel_main()` function we create a thread (or *task*) to be started in
`task_a()` function. Then transfer control to `task_a` thread. The new thread
prints a message and returns control to main thread.

## Exercises

1. Why functions `init_task_context()` and `switch_context()` save and restore a
   partial set of CPU registers?

   Estas funciones únicamente guardan y restauran un subconjunto de los registros de la CPU, específicamente los registros s0-s11 (conocidos como saved registers) y la dirección de retorno. Esto se debe a la convención de llamadas a funciones de la arquitectura. Durante un cambio de contexto, no es necesario conservar todos los registros, ya que los registros restantes son responsabilidad de la función invocante o caller. El thread actual solo debe hacerse cargo de su saved context para luego de un context switch, poder seguir ejecutando su código desde el estado en el que había abandonado la CPU.

2. Create other task (`task_b`) and modify `kernel.c` to runing tasks in the
   following order: 
   `main_thread -> task_a -> task_b -> task_a -> main_thread -> task_b`.
   
   Resuelto en kernel.c