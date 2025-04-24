# Tasks

In this step we create a *tasks module* (see `task.h` and `task.c`).

We are implementing *cooperative* threads (*coroutines*) because each thread
voluntarily leaves (*yield*) the cpu.

In next steps we'll develop *preemption*: A tasks can leave CPU on timer
interrupts.

## Tasks

A task is represented by `struct task` type. In `task.c` a *task/process control
block table* is defined.

Each task has a *process id*, its *state* (`TASK_RUNNABLE` or `TASK_RUNNING`),
its stack and the saved stack pointer (stack top).

Task creation (in `create_task(fn_address)`) is simple. An empty stack
descriptor slot in `tasks[]` table is found. Then it is initialized as en
previous *context-switch* step.

The *current task* (a pointer to task descriptor per CPU) is updated in each
context switch.

Function `yield()` changes current task to `TASK_RUNNABLE` and calls
`scheduler()`. The scheduler selects a next task using a *round/robin* strategy.
Then it makes the context switch to the selected task.

## Testing tasks

The main kernel function creates two tasks: `task_a` and `task_b` and calls
`scheduler()`.

Each task starts an infinite loop printing a message, does a small *busy wait
loop* and then calls `yield()`.

## Exercise

Do all necessary modifications to create tasks with *priorities*.

- Task creation: `create_task(pc, stack, priority)`
- Scheduling: The scheduler should select a `RUNNABLE` task with highest
  priority.

What problems can this scheduling algorithm have?

Este algoritmo presenta el problema de starvation. Si las tasks tienen prioridades y el scheduler siempre elige la task con mayor prioridad para ejecutar en una CPU, el resto de las tasks con menor prioridad no se van a ejecutar nunca, ya que siempre existirá una task con mayor prioridad que ocupará la CPU. Este problema se podría solucionar aplicando el concepto de envejecimiento, en el cual se incrementa la prioridad de las tasks que han esperado por mucho tiempo a ser elegidas por el scheduler, permitiendo que eventualmente puedan ser ejecutadas. Esto resultará en un algoritmo de planificación más justo.