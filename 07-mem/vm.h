/*============================================================================*
 * Virtual memory                                                             *
 *============================================================================*/
#pragma once

// init create kernel page table
void init_vm(void);

// map an address (contiguous) space to a given starting physical address
void map_region(pte* pgtbl, vaddr va, paddr start, uint size, uint flags);

// unmap an address (contiguous) virtual space
void unmap_region(pte* pgtbl, vaddr va, uint size, bool free);