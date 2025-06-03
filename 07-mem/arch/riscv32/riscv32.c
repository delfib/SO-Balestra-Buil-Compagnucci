#include "arch.h"
#include "kalloc.h"
#include "klib.h"

//=============================================================================
// Interrupts.
//=============================================================================

void next_timer_interrupt(int cpu_id)
{
    // mtimecmp = mtime + interval
    *(uint64*)CLINT_MTIMECMP(cpu_id) = *(uint64*)CLINT_MTIME + T_INTERVAL;
    enable_timer_interrupts();
    
    /* for debugging
    extern size_t mstatus, mie, mip;
    mstatus = r_mstatus();
    mie = r_mie();
    mip = r_mip();
    */
}

//=============================================================================
// Paging
//=============================================================================

// kernel page table initialized by init_vm() in vm.c
pte* kernel_pgtbl;

// set satp register pointing to the kernel page table.
void enable_paging(void)
{
    __asm__ __volatile__("sfence.vma");
    w_satp(0x80000000 | (((paddr)kernel_pgtbl) >> 12));
    __asm__ __volatile__("sfence.vma");
}

// get the page table entry (pte) from a virtual address
static pte* get_pte(pte* pgtbl, vaddr va, bool create_leaf)
{
    uint i = va_index1(va);
    if ((pgtbl[i] & PAGE_V) == 0) {
        if (create_leaf) {
            // Create the non-existent 2nd level page table node
            paddr pa = (paddr) alloc_page();
            if (!pa)
                panic("alloc_page() failed!");
            // set the pte pointing to leaf node
            pgtbl[i] = pa2ppn(pa) | PAGE_V;
        } else
            return 0;
    }
    // get 2nd level node physical address
    pte* pg0 = (pte*) pte_pa(pgtbl[i]);
    // return pte address
    return &pg0[va_index0(va)];
}

// map the virtual address va to physical address in a page table
void map_page(pte* pgtbl, vaddr va, paddr pa, uint flags)
{
    pte* entry = get_pte(pgtbl, va, true);
    *entry = pa2ppn(pa) | flags | PAGE_V;
}

// unmap a page in a page table. If free == true, it should free the
// corresponding physical page 
void unmap_page(pte* pt, vaddr va, bool free)
{
    // to do
}

// map kernel memory layout. 1:1 mappings
void map_kernel_memory(pte* pgtbl)
{
    extern void map_region(pte*, vaddr, paddr, uint, uint);
    address ktext_start = (address) __kernel_start;
    uint    ktext_size  = (uint)(__text_end - __kernel_start);
    address kdata_start = (address) (__text_end);
    uint    kdata_size  = (uint) (__mem_end - __text_end);

    printf("ktext_start: %x\n", ktext_start);
    printf("kdata_start: %x\n", kdata_start);

    //                va           pa           size        flags
    map_region(pgtbl, UART,        UART,        PAGE_SIZE,  PAGE_R | PAGE_W);
    map_region(pgtbl, VIRTIO0,     VIRTIO0,     PAGE_SIZE,  PAGE_R | PAGE_W);
    map_region(pgtbl, PLIC,        PLIC,        PLIC_SIZE,  PAGE_R | PAGE_W);
    map_region(pgtbl, ktext_start, ktext_start, ktext_size, PAGE_R | PAGE_X);
    map_region(pgtbl, kdata_start, kdata_start, kdata_size, PAGE_R | PAGE_W);
}
