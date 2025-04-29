
arch.o:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <init_context>:
   0:	fca5a623          	sw	a0,-52(a1)
   4:	fe05ae23          	sw	zero,-4(a1)

00000008 <.LVL1>:
   8:	fe05ac23          	sw	zero,-8(a1)

0000000c <.LVL2>:
   c:	fe05aa23          	sw	zero,-12(a1)

00000010 <.LVL3>:
  10:	fe05a823          	sw	zero,-16(a1)

00000014 <.LVL4>:
  14:	fe05a623          	sw	zero,-20(a1)

00000018 <.LVL5>:
  18:	fe05a423          	sw	zero,-24(a1)

0000001c <.LVL6>:
  1c:	fe05a223          	sw	zero,-28(a1)

00000020 <.LVL7>:
  20:	fe05a023          	sw	zero,-32(a1)

00000024 <.LVL8>:
  24:	fc05ae23          	sw	zero,-36(a1)

00000028 <.LVL9>:
  28:	fc05ac23          	sw	zero,-40(a1)

0000002c <.LVL10>:
  2c:	fc05aa23          	sw	zero,-44(a1)

00000030 <.LVL11>:
  30:	fc05a823          	sw	zero,-48(a1)

00000034 <.LVL12>:
  34:	fcc58513          	addi	a0,a1,-52

00000038 <.LVL13>:
  38:	00008067          	ret

0000003c <next_timer_interrupt>:
  3c:	0200c737          	lui	a4,0x200c
  40:	ff872783          	lw	a5,-8(a4) # 200bff8 <.LASF217+0x2009943>
  44:	ffc72603          	lw	a2,-4(a4)
  48:	004c5737          	lui	a4,0x4c5
  4c:	b4070713          	addi	a4,a4,-1216 # 4c4b40 <.LASF217+0x4c248b>
  50:	004016b7          	lui	a3,0x401
  54:	00e78733          	add	a4,a5,a4
  58:	80068693          	addi	a3,a3,-2048 # 400800 <.LASF217+0x3fe14b>
  5c:	00d50533          	add	a0,a0,a3

00000060 <.LVL15>:
  60:	00f737b3          	sltu	a5,a4,a5
  64:	00351513          	slli	a0,a0,0x3

00000068 <.LVL16>:
  68:	00c787b3          	add	a5,a5,a2
  6c:	00e52023          	sw	a4,0(a0)
  70:	00f52223          	sw	a5,4(a0)

00000074 <.LBB6>:
  74:	300027f3          	csrr	a5,mstatus

00000078 <.LBE6>:
  78:	00000717          	auipc	a4,0x0
  7c:	00f72023          	sw	a5,0(a4) # 78 <.LBE6>

00000080 <.LBB8>:
  80:	08000793          	li	a5,128
  84:	3007a073          	csrs	mstatus,a5

00000088 <.LBE8>:
  88:	00008067          	ret
