###############################################################################
# risc-v architecture low level hardware abstraction layer (HAL)
###############################################################################

.section .text

# CPU boot firmware loads the kernel at address 0x80000000 and jump here
# (see kernel.ld). CPU starts running in M-mode

.global boot
boot:
    # save mhartid in tp register
    csrr tp, mhartid

    # set stack pointer for each cpu
    la sp, __stack0     # sp = __stack0
    li t0, 1024*4       # t0 = 4096
    addi t1, tp, 1      # t1 = mhartid + 1
    mul t0, t0, t1      # t0 = 4096 * (mhartid + 1)
    add sp, sp, t0      # sp = sp + (4096 * (mhartid + 1))

    # Load address of 'supervisor' into t0 and set mepc
    la      t0, supervisor
    csrw    mepc, t0

    # Set mtvec with m_trap address
    la      t1, m_trap
    csrw    mtvec, t1

    # Set up PMP to allow S-mode and U-mode full access to memory
    li      t5, 0x1F               # NAPOT + R/W/X permissions
    csrw    pmpcfg0, t5            # Write to pmpcfg0
    li      t6, -1                 # All ones to cover entire address space
    csrw    pmpaddr0, t6           # Write to pmpaddr0

    # Correctly set MPP to Supervisor Mode
    csrr    t2, mstatus            # Read mstatus into t2
    li      t3, ~(0x3 << 11)       # Mask to clear MPP bits
    and     t2, t2, t3             # Clear MPP bits
    li      t4, (0x1 << 11)        # MPP = 01 (Supervisor Mode)
    or      t2, t2, t4             # Set MPP bits to 01
    csrw    mstatus, t2            # Write back to mstatus

    # Delegate interrupts and exceptions to S-mode
    li      t5, 0xffff
    csrs    medeleg, t5
    csrs    mideleg, t5

    # enable S-mode interrupts: Set sstatus.SIE bit
    csrsi    sstatus, 0x2
    
    # enable S-mode external, timer and software interrupts
    # by setting sie.SEIE, sie.STIE and sie.SSIE bits
    li      t5, (1 << 9) | (1 << 5) | (1 << 1)
    csrs    sie, t5

    # setup next timer interrupt
    mv      a0, tp
    call    next_timer_interrupt

    # enable M-mode interrupts: set mstatus.SIE, mstatus.MIE and mie.MTIE bits
    li     t5, (1 << 2) | (1 << 3) | (1 << 7)
    csrs   mie, t5

    mret

# supervisor entry point (after mret)
supervisor:
    # Disable virtual memory by setting satp to zero
    csrw    satp, x0

    # set S-mode trap handler
    la      t1, s_trap
    csrw    stvec, t1

    # call kernel_main() in supervisor mode
    call kernel_main

#==============================================================================
# context_switch(uint32 *prev_sp, uint32 *next_sp)
#==============================================================================
# 1. save (push) cpu registers on current stack
# 2. update prev_sp: *prev_sp = sp; 
# 3. switch to next task stack: sp = *next_sp
# 4. restore (pop) cpu register saved values from next stack thread
.global context_switch
context_switch:
    # push callee saved registers and task pc (ra) 
    addi    sp, sp, -13 * 4
    sw      ra,  0  * 4(sp)
    sw      s0,  1  * 4(sp)
    sw      s1,  2  * 4(sp)
    sw      s2,  3  * 4(sp)
    sw      s3,  4  * 4(sp)
    sw      s4,  5  * 4(sp)
    sw      s5,  6  * 4(sp)
    sw      s6,  7  * 4(sp)
    sw      s7,  8  * 4(sp)
    sw      s8,  9  * 4(sp)
    sw      s9,  10 * 4(sp)
    sw      s10, 11 * 4(sp)
    sw      s11, 12 * 4(sp)

    # update prev_sp and change to next_sp
    sw      sp, (a0)         # *prev_sp = sp;
    lw      sp, (a1)         # sp = *next_sp

    # restore register values from next stack
    lw      ra,  0  * 4(sp)
    lw      s0,  1  * 4(sp)
    lw      s1,  2  * 4(sp)
    lw      s2,  3  * 4(sp)
    lw      s3,  4  * 4(sp)
    lw      s4,  5  * 4(sp)
    lw      s5,  6  * 4(sp)
    lw      s6,  7  * 4(sp)
    lw      s7,  8  * 4(sp)
    lw      s8,  9  * 4(sp)
    lw      s9,  10 * 4(sp)
    lw      s10, 11 * 4(sp)
    lw      s11, 12 * 4(sp)
    addi    sp, sp, 13 * 4
    ret

#==============================================================================
# Low-level trap handlers
#==============================================================================

# S-mode trap handler. It calls to trap(struct trap_frame *tf) in trap.c
s_trap:
    # save cpu registers in same order as defined in struct trap_handler
    addi    sp, sp, -30 * 4
    sw      ra, 0 * 4 (sp)
    sw      gp, 1 * 4 (sp)
    sw      t0, 2 * 4 (sp)
    sw      t1, 3 * 4 (sp)
    sw      t2, 4 * 4 (sp)
    sw      t3, 5 * 4 (sp)
    sw      t4, 6 * 4 (sp)
    sw      t5, 7 * 4 (sp)
    sw      t6, 8 * 4 (sp)
    sw      a0, 9 * 4 (sp)
    sw      a1, 10 * 4 (sp)
    sw      a2, 11 * 4 (sp)
    sw      a3, 12 * 4 (sp)
    sw      a4, 13 * 4 (sp)
    sw      a5, 14 * 4 (sp)
    sw      a6, 15 * 4 (sp)
    sw      a7, 16 * 4 (sp)
    sw      s0, 17 * 4 (sp)
    sw      s1, 18 * 4 (sp)
    sw      s2, 19 * 4 (sp)
    sw      s3, 20 * 4 (sp)
    sw      s4, 21 * 4 (sp)
    sw      s5, 22 * 4 (sp)
    sw      s6, 23 * 4 (sp)
    sw      s7, 24 * 4 (sp)
    sw      s8, 25 * 4 (sp)
    sw      s9, 26 * 4 (sp)
    sw      s10, 27 * 4 (sp)
    sw      s11, 28 * 4 (sp)
    sw      sp,  29 * 4 (sp)
    
    # call trap(struct trap_frame *tf)
    mv      a0, sp
    call    trap

    # we can return in a different stack here (by a context switch)
    # restore registers
    lw      ra, 0 * 4 (sp)
    lw      gp, 1 * 4 (sp)
    lw      t0, 2 * 4 (sp)
    lw      t1, 3 * 4 (sp)
    lw      t2, 4 * 4 (sp)
    lw      t3, 5 * 4 (sp)
    lw      t4, 6 * 4 (sp)
    lw      t5, 7 * 4 (sp)
    lw      t6, 8 * 4 (sp)
    lw      a0, 9 * 4 (sp)
    lw      a1, 10 * 4 (sp)
    lw      a2, 11 * 4 (sp)
    lw      a3, 12 * 4 (sp)
    lw      a4, 13 * 4 (sp)
    lw      a5, 14 * 4 (sp)
    lw      a6, 15 * 4 (sp)
    lw      a7, 16 * 4 (sp)
    lw      s0, 17 * 4 (sp)
    lw      s1, 18 * 4 (sp)
    lw      s2, 19 * 4 (sp)
    lw      s3, 20 * 4 (sp)
    lw      s4, 21 * 4 (sp)
    lw      s5, 22 * 4 (sp)
    lw      s6, 23 * 4 (sp)
    lw      s7, 24 * 4 (sp)
    lw      s8, 25 * 4 (sp)
    lw      s9, 26 * 4 (sp)
    lw      s10, 27 * 4 (sp)
    lw      s11, 28 * 4 (sp)
    lw      sp,  29 * 4 (sp)

    addi    sp, sp, 30 * 4

    # enable interrupts in S-mode
    csrsi   sstatus, 0x2

    # return from interrupt/exception in S-mode
    sret

# machine-mode (timer) interrupts handler
m_trap: 
    # save a0-a7 registers: some are used by next_timer_interrupt()
    addi    sp, sp, -8 * 4
    sw      a0, 0 * 4 (sp)
    sw      a1, 1 * 4 (sp)
    sw      a2, 2 * 4 (sp)
    sw      a3, 3 * 4 (sp)
    sw      a4, 4 * 4 (sp)
    sw      a5, 5 * 4 (sp)
    sw      a6, 6 * 4 (sp)
    sw      a7, 7 * 4 (sp)

    # schedule the next timer interrupt: timer_interrupt(cpu_id)
    mv      a0, tp
    call    next_timer_interrupt

    # restore saved registers and set stack values with zeroes
    lw      a0, 0 * 4 (sp)
    sw      x0, 0 * 4 (sp)
    lw      a1, 1 * 4 (sp)
    sw      x0, 1 * 4 (sp)
    lw      a2, 2 * 4 (sp)
    sw      x0, 2 * 4 (sp)
    lw      a3, 3 * 4 (sp)
    sw      x0, 3 * 4 (sp)
    lw      a4, 4 * 4 (sp)
    sw      x0, 4 * 4 (sp)
    lw      a5, 5 * 4 (sp)
    sw      x0, 5 * 4 (sp)
    lw      a6, 6 * 4 (sp)
    sw      x0, 6 * 4 (sp)
    lw      a7, 7 * 4 (sp)
    sw      x0, 7 * 4 (sp)
    addi    sp, sp, 8 * 4

    # set timer interrupt pending bit in sip.
    # This will delegate interrupt to S-mode trap handler
    li a1, 2
    csrw sip, a1

    # jump (delegate) to s-trap as a software interrupt (scause = 0x80000001)
    mret
