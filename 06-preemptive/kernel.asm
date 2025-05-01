
kernel:     file format elf32-littleriscv


Disassembly of section .text:

80000000 <boot>:
80000000:	f1402273          	csrr	tp,mhartid
80000004:	0000a117          	auipc	sp,0xa
80000008:	ffc10113          	addi	sp,sp,-4 # 8000a000 <__stack0>
8000000c:	000012b7          	lui	t0,0x1
80000010:	00120313          	addi	t1,tp,1 # 1 <boot-0x7fffffff>
80000014:	026282b3          	mul	t0,t0,t1
80000018:	00510133          	add	sp,sp,t0
8000001c:	00000297          	auipc	t0,0x0
80000020:	07828293          	addi	t0,t0,120 # 80000094 <supervisor>
80000024:	34129073          	csrw	mepc,t0
80000028:	00000317          	auipc	t1,0x0
8000002c:	20430313          	addi	t1,t1,516 # 8000022c <m_trap>
80000030:	30531073          	csrw	mtvec,t1
80000034:	01f00f13          	li	t5,31
80000038:	3a0f1073          	csrw	pmpcfg0,t5
8000003c:	fff00f93          	li	t6,-1
80000040:	3b0f9073          	csrw	pmpaddr0,t6
80000044:	300023f3          	csrr	t2,mstatus
80000048:	ffffee37          	lui	t3,0xffffe
8000004c:	7ffe0e13          	addi	t3,t3,2047 # ffffe7ff <__kernel_end+0x7fff37ff>
80000050:	01c3f3b3          	and	t2,t2,t3
80000054:	00001eb7          	lui	t4,0x1
80000058:	800e8e93          	addi	t4,t4,-2048 # 800 <boot-0x7ffff800>
8000005c:	01d3e3b3          	or	t2,t2,t4
80000060:	30039073          	csrw	mstatus,t2
80000064:	00010f37          	lui	t5,0x10
80000068:	ffff0f13          	addi	t5,t5,-1 # ffff <boot-0x7fff0001>
8000006c:	302f2073          	csrs	medeleg,t5
80000070:	303f2073          	csrs	mideleg,t5
80000074:	10016073          	csrsi	sstatus,2
80000078:	22200f13          	li	t5,546
8000007c:	104f2073          	csrs	sie,t5
80000080:	00020513          	mv	a0,tp
80000084:	328000ef          	jal	800003ac <next_timer_interrupt>
80000088:	08c00f13          	li	t5,140
8000008c:	304f2073          	csrs	mie,t5
80000090:	30200073          	mret

80000094 <supervisor>:
80000094:	18001073          	csrw	satp,zero
80000098:	00000317          	auipc	t1,0x0
8000009c:	08c30313          	addi	t1,t1,140 # 80000124 <s_trap>
800000a0:	10531073          	csrw	stvec,t1
800000a4:	4a0000ef          	jal	80000544 <kernel_main>

800000a8 <context_switch>:
800000a8:	fcc10113          	addi	sp,sp,-52
800000ac:	00112023          	sw	ra,0(sp)
800000b0:	00812223          	sw	s0,4(sp)
800000b4:	00912423          	sw	s1,8(sp)
800000b8:	01212623          	sw	s2,12(sp)
800000bc:	01312823          	sw	s3,16(sp)
800000c0:	01412a23          	sw	s4,20(sp)
800000c4:	01512c23          	sw	s5,24(sp)
800000c8:	01612e23          	sw	s6,28(sp)
800000cc:	03712023          	sw	s7,32(sp)
800000d0:	03812223          	sw	s8,36(sp)
800000d4:	03912423          	sw	s9,40(sp)
800000d8:	03a12623          	sw	s10,44(sp)
800000dc:	03b12823          	sw	s11,48(sp)
800000e0:	00252023          	sw	sp,0(a0)
800000e4:	0005a103          	lw	sp,0(a1)
800000e8:	00012083          	lw	ra,0(sp)
800000ec:	00412403          	lw	s0,4(sp)
800000f0:	00812483          	lw	s1,8(sp)
800000f4:	00c12903          	lw	s2,12(sp)
800000f8:	01012983          	lw	s3,16(sp)
800000fc:	01412a03          	lw	s4,20(sp)
80000100:	01812a83          	lw	s5,24(sp)
80000104:	01c12b03          	lw	s6,28(sp)
80000108:	02012b83          	lw	s7,32(sp)
8000010c:	02412c03          	lw	s8,36(sp)
80000110:	02812c83          	lw	s9,40(sp)
80000114:	02c12d03          	lw	s10,44(sp)
80000118:	03012d83          	lw	s11,48(sp)
8000011c:	03410113          	addi	sp,sp,52
80000120:	00008067          	ret

80000124 <s_trap>:
80000124:	f8810113          	addi	sp,sp,-120
80000128:	00112023          	sw	ra,0(sp)
8000012c:	00312223          	sw	gp,4(sp)
80000130:	00512423          	sw	t0,8(sp)
80000134:	00612623          	sw	t1,12(sp)
80000138:	00712823          	sw	t2,16(sp)
8000013c:	01c12a23          	sw	t3,20(sp)
80000140:	01d12c23          	sw	t4,24(sp)
80000144:	01e12e23          	sw	t5,28(sp)
80000148:	03f12023          	sw	t6,32(sp)
8000014c:	02a12223          	sw	a0,36(sp)
80000150:	02b12423          	sw	a1,40(sp)
80000154:	02c12623          	sw	a2,44(sp)
80000158:	02d12823          	sw	a3,48(sp)
8000015c:	02e12a23          	sw	a4,52(sp)
80000160:	02f12c23          	sw	a5,56(sp)
80000164:	03012e23          	sw	a6,60(sp)
80000168:	05112023          	sw	a7,64(sp)
8000016c:	04812223          	sw	s0,68(sp)
80000170:	04912423          	sw	s1,72(sp)
80000174:	05212623          	sw	s2,76(sp)
80000178:	05312823          	sw	s3,80(sp)
8000017c:	05412a23          	sw	s4,84(sp)
80000180:	05512c23          	sw	s5,88(sp)
80000184:	05612e23          	sw	s6,92(sp)
80000188:	07712023          	sw	s7,96(sp)
8000018c:	07812223          	sw	s8,100(sp)
80000190:	07912423          	sw	s9,104(sp)
80000194:	07a12623          	sw	s10,108(sp)
80000198:	07b12823          	sw	s11,112(sp)
8000019c:	06212a23          	sw	sp,116(sp)
800001a0:	00010513          	mv	a0,sp
800001a4:	409000ef          	jal	80000dac <trap>
800001a8:	00012083          	lw	ra,0(sp)
800001ac:	00412183          	lw	gp,4(sp)
800001b0:	00812283          	lw	t0,8(sp)
800001b4:	00c12303          	lw	t1,12(sp)
800001b8:	01012383          	lw	t2,16(sp)
800001bc:	01412e03          	lw	t3,20(sp)
800001c0:	01812e83          	lw	t4,24(sp)
800001c4:	01c12f03          	lw	t5,28(sp)
800001c8:	02012f83          	lw	t6,32(sp)
800001cc:	02412503          	lw	a0,36(sp)
800001d0:	02812583          	lw	a1,40(sp)
800001d4:	02c12603          	lw	a2,44(sp)
800001d8:	03012683          	lw	a3,48(sp)
800001dc:	03412703          	lw	a4,52(sp)
800001e0:	03812783          	lw	a5,56(sp)
800001e4:	03c12803          	lw	a6,60(sp)
800001e8:	04012883          	lw	a7,64(sp)
800001ec:	04412403          	lw	s0,68(sp)
800001f0:	04812483          	lw	s1,72(sp)
800001f4:	04c12903          	lw	s2,76(sp)
800001f8:	05012983          	lw	s3,80(sp)
800001fc:	05412a03          	lw	s4,84(sp)
80000200:	05812a83          	lw	s5,88(sp)
80000204:	05c12b03          	lw	s6,92(sp)
80000208:	06012b83          	lw	s7,96(sp)
8000020c:	06412c03          	lw	s8,100(sp)
80000210:	06812c83          	lw	s9,104(sp)
80000214:	06c12d03          	lw	s10,108(sp)
80000218:	07012d83          	lw	s11,112(sp)
8000021c:	07412103          	lw	sp,116(sp)
80000220:	07810113          	addi	sp,sp,120
80000224:	10016073          	csrsi	sstatus,2
80000228:	10200073          	sret

8000022c <m_trap>:
8000022c:	fe010113          	addi	sp,sp,-32
80000230:	00a12023          	sw	a0,0(sp)
80000234:	00b12223          	sw	a1,4(sp)
80000238:	00c12423          	sw	a2,8(sp)
8000023c:	00d12623          	sw	a3,12(sp)
80000240:	00e12823          	sw	a4,16(sp)
80000244:	00f12a23          	sw	a5,20(sp)
80000248:	01012c23          	sw	a6,24(sp)
8000024c:	01112e23          	sw	a7,28(sp)
80000250:	00020513          	mv	a0,tp
80000254:	158000ef          	jal	800003ac <next_timer_interrupt>
80000258:	00012503          	lw	a0,0(sp)
8000025c:	00012023          	sw	zero,0(sp)
80000260:	00412583          	lw	a1,4(sp)
80000264:	00012223          	sw	zero,4(sp)
80000268:	00812603          	lw	a2,8(sp)
8000026c:	00012423          	sw	zero,8(sp)
80000270:	00c12683          	lw	a3,12(sp)
80000274:	00012623          	sw	zero,12(sp)
80000278:	01012703          	lw	a4,16(sp)
8000027c:	00012823          	sw	zero,16(sp)
80000280:	01412783          	lw	a5,20(sp)
80000284:	00012a23          	sw	zero,20(sp)
80000288:	01812803          	lw	a6,24(sp)
8000028c:	00012c23          	sw	zero,24(sp)
80000290:	01c12883          	lw	a7,28(sp)
80000294:	00012e23          	sw	zero,28(sp)
80000298:	02010113          	addi	sp,sp,32
8000029c:	00200593          	li	a1,2
800002a0:	14459073          	csrw	sip,a1
800002a4:	30200073          	mret

800002a8 <push_irq_off>:
800002a8:	ff010113          	addi	sp,sp,-16
800002ac:	00812623          	sw	s0,12(sp)
800002b0:	01010413          	addi	s0,sp,16
800002b4:	100026f3          	csrr	a3,sstatus
800002b8:	00020793          	mv	a5,tp
800002bc:	10017073          	csrci	sstatus,2
800002c0:	00379613          	slli	a2,a5,0x3
800002c4:	00001717          	auipc	a4,0x1
800002c8:	2e870713          	addi	a4,a4,744 # 800015ac <cpu_irq_status>
800002cc:	00c70733          	add	a4,a4,a2
800002d0:	00072703          	lw	a4,0(a4)
800002d4:	00071e63          	bnez	a4,800002f0 <push_irq_off+0x48>
800002d8:	00060593          	mv	a1,a2
800002dc:	00001617          	auipc	a2,0x1
800002e0:	2d060613          	addi	a2,a2,720 # 800015ac <cpu_irq_status>
800002e4:	00b60633          	add	a2,a2,a1
800002e8:	0026f693          	andi	a3,a3,2
800002ec:	00d62223          	sw	a3,4(a2)
800002f0:	00379793          	slli	a5,a5,0x3
800002f4:	00001697          	auipc	a3,0x1
800002f8:	2b868693          	addi	a3,a3,696 # 800015ac <cpu_irq_status>
800002fc:	00f687b3          	add	a5,a3,a5
80000300:	00170713          	addi	a4,a4,1
80000304:	00e7a023          	sw	a4,0(a5)
80000308:	00c12403          	lw	s0,12(sp)
8000030c:	01010113          	addi	sp,sp,16
80000310:	00008067          	ret

80000314 <pop_irq_off>:
80000314:	ff010113          	addi	sp,sp,-16
80000318:	00812623          	sw	s0,12(sp)
8000031c:	01010413          	addi	s0,sp,16
80000320:	00020693          	mv	a3,tp
80000324:	00369793          	slli	a5,a3,0x3
80000328:	00001717          	auipc	a4,0x1
8000032c:	28470713          	addi	a4,a4,644 # 800015ac <cpu_irq_status>
80000330:	00f70733          	add	a4,a4,a5
80000334:	00072783          	lw	a5,0(a4)
80000338:	fff78793          	addi	a5,a5,-1
8000033c:	00f72023          	sw	a5,0(a4)
80000340:	00079863          	bnez	a5,80000350 <pop_irq_off+0x3c>
80000344:	00472783          	lw	a5,4(a4)
80000348:	00078463          	beqz	a5,80000350 <pop_irq_off+0x3c>
8000034c:	10016073          	csrsi	sstatus,2
80000350:	00c12403          	lw	s0,12(sp)
80000354:	01010113          	addi	sp,sp,16
80000358:	00008067          	ret

8000035c <init_context>:
8000035c:	ff010113          	addi	sp,sp,-16
80000360:	00812623          	sw	s0,12(sp)
80000364:	01010413          	addi	s0,sp,16
80000368:	fe05ae23          	sw	zero,-4(a1)
8000036c:	fe05ac23          	sw	zero,-8(a1)
80000370:	fe05aa23          	sw	zero,-12(a1)
80000374:	fe05a823          	sw	zero,-16(a1)
80000378:	fe05a623          	sw	zero,-20(a1)
8000037c:	fe05a423          	sw	zero,-24(a1)
80000380:	fe05a223          	sw	zero,-28(a1)
80000384:	fe05a023          	sw	zero,-32(a1)
80000388:	fc05ae23          	sw	zero,-36(a1)
8000038c:	fc05ac23          	sw	zero,-40(a1)
80000390:	fc05aa23          	sw	zero,-44(a1)
80000394:	fc05a823          	sw	zero,-48(a1)
80000398:	fca5a623          	sw	a0,-52(a1)
8000039c:	fcc58513          	addi	a0,a1,-52
800003a0:	00c12403          	lw	s0,12(sp)
800003a4:	01010113          	addi	sp,sp,16
800003a8:	00008067          	ret

800003ac <next_timer_interrupt>:
800003ac:	ff010113          	addi	sp,sp,-16
800003b0:	00812623          	sw	s0,12(sp)
800003b4:	01010413          	addi	s0,sp,16
800003b8:	004017b7          	lui	a5,0x401
800003bc:	80078793          	addi	a5,a5,-2048 # 400800 <boot-0x7fbff800>
800003c0:	00f50533          	add	a0,a0,a5
800003c4:	00351513          	slli	a0,a0,0x3
800003c8:	0200c737          	lui	a4,0x200c
800003cc:	ff872783          	lw	a5,-8(a4) # 200bff8 <boot-0x7dff4008>
800003d0:	ffc72683          	lw	a3,-4(a4)
800003d4:	004c5737          	lui	a4,0x4c5
800003d8:	b4070713          	addi	a4,a4,-1216 # 4c4b40 <boot-0x7fb3b4c0>
800003dc:	00e78733          	add	a4,a5,a4
800003e0:	00f737b3          	sltu	a5,a4,a5
800003e4:	00d787b3          	add	a5,a5,a3
800003e8:	00e52023          	sw	a4,0(a0)
800003ec:	00f52223          	sw	a5,4(a0)
800003f0:	08000793          	li	a5,128
800003f4:	3007a073          	csrs	mstatus,a5
800003f8:	300027f3          	csrr	a5,mstatus
800003fc:	00009717          	auipc	a4,0x9
80000400:	30f72423          	sw	a5,776(a4) # 80009704 <mstatus>
80000404:	304027f3          	csrr	a5,mie
80000408:	00009717          	auipc	a4,0x9
8000040c:	2ef72c23          	sw	a5,760(a4) # 80009700 <mie>
80000410:	344027f3          	csrr	a5,mip
80000414:	00009717          	auipc	a4,0x9
80000418:	2ef72423          	sw	a5,744(a4) # 800096fc <mip>
8000041c:	00c12403          	lw	s0,12(sp)
80000420:	01010113          	addi	sp,sp,16
80000424:	00008067          	ret

80000428 <console_putc>:
80000428:	ff010113          	addi	sp,sp,-16
8000042c:	00812623          	sw	s0,12(sp)
80000430:	01010413          	addi	s0,sp,16
80000434:	100007b7          	lui	a5,0x10000
80000438:	00578793          	addi	a5,a5,5 # 10000005 <boot-0x6ffffffb>
8000043c:	0007c783          	lbu	a5,0(a5)
80000440:	0407f793          	andi	a5,a5,64
80000444:	00078063          	beqz	a5,80000444 <console_putc+0x1c>
80000448:	100007b7          	lui	a5,0x10000
8000044c:	00a78023          	sb	a0,0(a5) # 10000000 <boot-0x70000000>
80000450:	00c12403          	lw	s0,12(sp)
80000454:	01010113          	addi	sp,sp,16
80000458:	00008067          	ret

8000045c <console_puts>:
8000045c:	ff010113          	addi	sp,sp,-16
80000460:	00112623          	sw	ra,12(sp)
80000464:	00812423          	sw	s0,8(sp)
80000468:	00912223          	sw	s1,4(sp)
8000046c:	01010413          	addi	s0,sp,16
80000470:	00050493          	mv	s1,a0
80000474:	00001517          	auipc	a0,0x1
80000478:	15850513          	addi	a0,a0,344 # 800015cc <console_lock>
8000047c:	464000ef          	jal	800008e0 <acquire>
80000480:	0004c503          	lbu	a0,0(s1)
80000484:	00050a63          	beqz	a0,80000498 <console_puts+0x3c>
80000488:	00148493          	addi	s1,s1,1
8000048c:	f9dff0ef          	jal	80000428 <console_putc>
80000490:	0004c503          	lbu	a0,0(s1)
80000494:	fe051ae3          	bnez	a0,80000488 <console_puts+0x2c>
80000498:	00001517          	auipc	a0,0x1
8000049c:	13450513          	addi	a0,a0,308 # 800015cc <console_lock>
800004a0:	484000ef          	jal	80000924 <release>
800004a4:	00c12083          	lw	ra,12(sp)
800004a8:	00812403          	lw	s0,8(sp)
800004ac:	00412483          	lw	s1,4(sp)
800004b0:	01010113          	addi	sp,sp,16
800004b4:	00008067          	ret

800004b8 <task_b>:
800004b8:	ff010113          	addi	sp,sp,-16
800004bc:	00112623          	sw	ra,12(sp)
800004c0:	00812423          	sw	s0,8(sp)
800004c4:	00912223          	sw	s1,4(sp)
800004c8:	01010413          	addi	s0,sp,16
800004cc:	00001497          	auipc	s1,0x1
800004d0:	9ec48493          	addi	s1,s1,-1556 # 80000eb8 <trap+0x10c>
800004d4:	00020593          	mv	a1,tp
800004d8:	00048513          	mv	a0,s1
800004dc:	200000ef          	jal	800006dc <printf>
800004e0:	11e1a7b7          	lui	a5,0x11e1a
800004e4:	30078793          	addi	a5,a5,768 # 11e1a300 <boot-0x6e1e5d00>
800004e8:	00000013          	nop
800004ec:	fff78793          	addi	a5,a5,-1
800004f0:	fe079ce3          	bnez	a5,800004e8 <task_b+0x30>
800004f4:	fe1ff06f          	j	800004d4 <task_b+0x1c>

800004f8 <task_a>:
800004f8:	ff010113          	addi	sp,sp,-16
800004fc:	00112623          	sw	ra,12(sp)
80000500:	00812423          	sw	s0,8(sp)
80000504:	00912223          	sw	s1,4(sp)
80000508:	01010413          	addi	s0,sp,16
8000050c:	00001497          	auipc	s1,0x1
80000510:	9c048493          	addi	s1,s1,-1600 # 80000ecc <trap+0x120>
80000514:	00c0006f          	j	80000520 <task_a+0x28>
80000518:	00500513          	li	a0,5
8000051c:	738000ef          	jal	80000c54 <sleep>
80000520:	00020593          	mv	a1,tp
80000524:	00048513          	mv	a0,s1
80000528:	1b4000ef          	jal	800006dc <printf>
8000052c:	1dcd67b7          	lui	a5,0x1dcd6
80000530:	50078793          	addi	a5,a5,1280 # 1dcd6500 <boot-0x62329b00>
80000534:	00000013          	nop
80000538:	fff78793          	addi	a5,a5,-1
8000053c:	fe079ce3          	bnez	a5,80000534 <task_a+0x3c>
80000540:	fd9ff06f          	j	80000518 <task_a+0x20>

80000544 <kernel_main>:
80000544:	ff010113          	addi	sp,sp,-16
80000548:	00112623          	sw	ra,12(sp)
8000054c:	00812423          	sw	s0,8(sp)
80000550:	01010413          	addi	s0,sp,16
80000554:	10016073          	csrsi	sstatus,2
80000558:	00020793          	mv	a5,tp
8000055c:	02078263          	beqz	a5,80000580 <kernel_main+0x3c>
80000560:	584000ef          	jal	80000ae4 <scheduler>
80000564:	02800613          	li	a2,40
80000568:	00001597          	auipc	a1,0x1
8000056c:	98058593          	addi	a1,a1,-1664 # 80000ee8 <trap+0x13c>
80000570:	00001517          	auipc	a0,0x1
80000574:	98450513          	addi	a0,a0,-1660 # 80000ef4 <trap+0x148>
80000578:	164000ef          	jal	800006dc <printf>
8000057c:	0000006f          	j	8000057c <kernel_main+0x38>
80000580:	00000597          	auipc	a1,0x0
80000584:	f7858593          	addi	a1,a1,-136 # 800004f8 <task_a>
80000588:	00001517          	auipc	a0,0x1
8000058c:	95850513          	addi	a0,a0,-1704 # 80000ee0 <trap+0x134>
80000590:	410000ef          	jal	800009a0 <create_task>
80000594:	00000597          	auipc	a1,0x0
80000598:	f2458593          	addi	a1,a1,-220 # 800004b8 <task_b>
8000059c:	00001517          	auipc	a0,0x1
800005a0:	94850513          	addi	a0,a0,-1720 # 80000ee4 <trap+0x138>
800005a4:	3fc000ef          	jal	800009a0 <create_task>
800005a8:	fb9ff06f          	j	80000560 <kernel_main+0x1c>

800005ac <memset>:
800005ac:	ff010113          	addi	sp,sp,-16
800005b0:	00812623          	sw	s0,12(sp)
800005b4:	01010413          	addi	s0,sp,16
800005b8:	00060c63          	beqz	a2,800005d0 <memset+0x24>
800005bc:	00c50633          	add	a2,a0,a2
800005c0:	00050793          	mv	a5,a0
800005c4:	00178793          	addi	a5,a5,1
800005c8:	feb78fa3          	sb	a1,-1(a5)
800005cc:	fef61ce3          	bne	a2,a5,800005c4 <memset+0x18>
800005d0:	00c12403          	lw	s0,12(sp)
800005d4:	01010113          	addi	sp,sp,16
800005d8:	00008067          	ret

800005dc <memcpy>:
800005dc:	ff010113          	addi	sp,sp,-16
800005e0:	00812623          	sw	s0,12(sp)
800005e4:	01010413          	addi	s0,sp,16
800005e8:	02060063          	beqz	a2,80000608 <memcpy+0x2c>
800005ec:	00c50633          	add	a2,a0,a2
800005f0:	00050793          	mv	a5,a0
800005f4:	00158593          	addi	a1,a1,1
800005f8:	00178793          	addi	a5,a5,1
800005fc:	fff5c703          	lbu	a4,-1(a1)
80000600:	fee78fa3          	sb	a4,-1(a5)
80000604:	fef618e3          	bne	a2,a5,800005f4 <memcpy+0x18>
80000608:	00c12403          	lw	s0,12(sp)
8000060c:	01010113          	addi	sp,sp,16
80000610:	00008067          	ret

80000614 <strlen>:
80000614:	ff010113          	addi	sp,sp,-16
80000618:	00812623          	sw	s0,12(sp)
8000061c:	01010413          	addi	s0,sp,16
80000620:	00054783          	lbu	a5,0(a0)
80000624:	02078463          	beqz	a5,8000064c <strlen+0x38>
80000628:	00050713          	mv	a4,a0
8000062c:	00000513          	li	a0,0
80000630:	00150513          	addi	a0,a0,1
80000634:	00a707b3          	add	a5,a4,a0
80000638:	0007c783          	lbu	a5,0(a5)
8000063c:	fe079ae3          	bnez	a5,80000630 <strlen+0x1c>
80000640:	00c12403          	lw	s0,12(sp)
80000644:	01010113          	addi	sp,sp,16
80000648:	00008067          	ret
8000064c:	00000513          	li	a0,0
80000650:	ff1ff06f          	j	80000640 <strlen+0x2c>

80000654 <strcpy>:
80000654:	ff010113          	addi	sp,sp,-16
80000658:	00812623          	sw	s0,12(sp)
8000065c:	01010413          	addi	s0,sp,16
80000660:	0005c783          	lbu	a5,0(a1)
80000664:	02078663          	beqz	a5,80000690 <strcpy+0x3c>
80000668:	00050713          	mv	a4,a0
8000066c:	00158593          	addi	a1,a1,1
80000670:	00170713          	addi	a4,a4,1
80000674:	fef70fa3          	sb	a5,-1(a4)
80000678:	0005c783          	lbu	a5,0(a1)
8000067c:	fe0798e3          	bnez	a5,8000066c <strcpy+0x18>
80000680:	00070023          	sb	zero,0(a4)
80000684:	00c12403          	lw	s0,12(sp)
80000688:	01010113          	addi	sp,sp,16
8000068c:	00008067          	ret
80000690:	00050713          	mv	a4,a0
80000694:	fedff06f          	j	80000680 <strcpy+0x2c>

80000698 <strcmp>:
80000698:	ff010113          	addi	sp,sp,-16
8000069c:	00812623          	sw	s0,12(sp)
800006a0:	01010413          	addi	s0,sp,16
800006a4:	00054783          	lbu	a5,0(a0)
800006a8:	02078063          	beqz	a5,800006c8 <strcmp+0x30>
800006ac:	0005c703          	lbu	a4,0(a1)
800006b0:	00070c63          	beqz	a4,800006c8 <strcmp+0x30>
800006b4:	00f71a63          	bne	a4,a5,800006c8 <strcmp+0x30>
800006b8:	00150513          	addi	a0,a0,1
800006bc:	00158593          	addi	a1,a1,1
800006c0:	00054783          	lbu	a5,0(a0)
800006c4:	fe0794e3          	bnez	a5,800006ac <strcmp+0x14>
800006c8:	0005c503          	lbu	a0,0(a1)
800006cc:	40a78533          	sub	a0,a5,a0
800006d0:	00c12403          	lw	s0,12(sp)
800006d4:	01010113          	addi	sp,sp,16
800006d8:	00008067          	ret

800006dc <printf>:
800006dc:	fa010113          	addi	sp,sp,-96
800006e0:	02112e23          	sw	ra,60(sp)
800006e4:	02812c23          	sw	s0,56(sp)
800006e8:	02912a23          	sw	s1,52(sp)
800006ec:	04010413          	addi	s0,sp,64
800006f0:	00050493          	mv	s1,a0
800006f4:	00b42223          	sw	a1,4(s0)
800006f8:	00c42423          	sw	a2,8(s0)
800006fc:	00d42623          	sw	a3,12(s0)
80000700:	00e42823          	sw	a4,16(s0)
80000704:	00f42a23          	sw	a5,20(s0)
80000708:	01042c23          	sw	a6,24(s0)
8000070c:	01142e23          	sw	a7,28(s0)
80000710:	00440793          	addi	a5,s0,4
80000714:	fcf42623          	sw	a5,-52(s0)
80000718:	00054503          	lbu	a0,0(a0)
8000071c:	06050663          	beqz	a0,80000788 <printf+0xac>
80000720:	03212823          	sw	s2,48(sp)
80000724:	03312623          	sw	s3,44(sp)
80000728:	03412423          	sw	s4,40(sp)
8000072c:	03512223          	sw	s5,36(sp)
80000730:	03612023          	sw	s6,32(sp)
80000734:	01712e23          	sw	s7,28(sp)
80000738:	01812c23          	sw	s8,24(sp)
8000073c:	02500993          	li	s3,37
80000740:	06400a13          	li	s4,100
80000744:	07300a93          	li	s5,115
80000748:	1180006f          	j	80000860 <printf+0x184>
8000074c:	00078c63          	beqz	a5,80000764 <printf+0x88>
80000750:	02500713          	li	a4,37
80000754:	10e79063          	bne	a5,a4,80000854 <printf+0x178>
80000758:	02500513          	li	a0,37
8000075c:	ccdff0ef          	jal	80000428 <console_putc>
80000760:	0f40006f          	j	80000854 <printf+0x178>
80000764:	02500513          	li	a0,37
80000768:	cc1ff0ef          	jal	80000428 <console_putc>
8000076c:	03012903          	lw	s2,48(sp)
80000770:	02c12983          	lw	s3,44(sp)
80000774:	02812a03          	lw	s4,40(sp)
80000778:	02412a83          	lw	s5,36(sp)
8000077c:	02012b03          	lw	s6,32(sp)
80000780:	01c12b83          	lw	s7,28(sp)
80000784:	01812c03          	lw	s8,24(sp)
80000788:	03c12083          	lw	ra,60(sp)
8000078c:	03812403          	lw	s0,56(sp)
80000790:	03412483          	lw	s1,52(sp)
80000794:	06010113          	addi	sp,sp,96
80000798:	00008067          	ret
8000079c:	fcc42783          	lw	a5,-52(s0)
800007a0:	00478713          	addi	a4,a5,4
800007a4:	fce42623          	sw	a4,-52(s0)
800007a8:	0007a483          	lw	s1,0(a5)
800007ac:	0004c503          	lbu	a0,0(s1)
800007b0:	0a050263          	beqz	a0,80000854 <printf+0x178>
800007b4:	c75ff0ef          	jal	80000428 <console_putc>
800007b8:	00148493          	addi	s1,s1,1
800007bc:	0004c503          	lbu	a0,0(s1)
800007c0:	fe051ae3          	bnez	a0,800007b4 <printf+0xd8>
800007c4:	0900006f          	j	80000854 <printf+0x178>
800007c8:	fcc42783          	lw	a5,-52(s0)
800007cc:	00478713          	addi	a4,a5,4
800007d0:	fce42623          	sw	a4,-52(s0)
800007d4:	0007ab03          	lw	s6,0(a5)
800007d8:	040b4e63          	bltz	s6,80000834 <printf+0x158>
800007dc:	00900793          	li	a5,9
800007e0:	0767d263          	bge	a5,s6,80000844 <printf+0x168>
800007e4:	00100493          	li	s1,1
800007e8:	00900713          	li	a4,9
800007ec:	00249793          	slli	a5,s1,0x2
800007f0:	009787b3          	add	a5,a5,s1
800007f4:	00179793          	slli	a5,a5,0x1
800007f8:	00078493          	mv	s1,a5
800007fc:	02fb47b3          	div	a5,s6,a5
80000800:	fef746e3          	blt	a4,a5,800007ec <printf+0x110>
80000804:	04905863          	blez	s1,80000854 <printf+0x178>
80000808:	00a00c13          	li	s8,10
8000080c:	00900b93          	li	s7,9
80000810:	029b4533          	div	a0,s6,s1
80000814:	03050513          	addi	a0,a0,48
80000818:	0ff57513          	zext.b	a0,a0
8000081c:	c0dff0ef          	jal	80000428 <console_putc>
80000820:	029b6b33          	rem	s6,s6,s1
80000824:	00048793          	mv	a5,s1
80000828:	0384c4b3          	div	s1,s1,s8
8000082c:	fefbc2e3          	blt	s7,a5,80000810 <printf+0x134>
80000830:	0240006f          	j	80000854 <printf+0x178>
80000834:	02d00513          	li	a0,45
80000838:	bf1ff0ef          	jal	80000428 <console_putc>
8000083c:	41600b33          	neg	s6,s6
80000840:	f9dff06f          	j	800007dc <printf+0x100>
80000844:	00100493          	li	s1,1
80000848:	fc1ff06f          	j	80000808 <printf+0x12c>
8000084c:	bddff0ef          	jal	80000428 <console_putc>
80000850:	00048913          	mv	s2,s1
80000854:	00190493          	addi	s1,s2,1
80000858:	00194503          	lbu	a0,1(s2)
8000085c:	06050263          	beqz	a0,800008c0 <printf+0x1e4>
80000860:	ff3516e3          	bne	a0,s3,8000084c <printf+0x170>
80000864:	00148913          	addi	s2,s1,1
80000868:	0014c783          	lbu	a5,1(s1)
8000086c:	f5478ee3          	beq	a5,s4,800007c8 <printf+0xec>
80000870:	ecfa7ee3          	bgeu	s4,a5,8000074c <printf+0x70>
80000874:	f35784e3          	beq	a5,s5,8000079c <printf+0xc0>
80000878:	07800713          	li	a4,120
8000087c:	fce79ce3          	bne	a5,a4,80000854 <printf+0x178>
80000880:	fcc42783          	lw	a5,-52(s0)
80000884:	00478713          	addi	a4,a5,4
80000888:	fce42623          	sw	a4,-52(s0)
8000088c:	0007ac03          	lw	s8,0(a5)
80000890:	01c00493          	li	s1,28
80000894:	00000b97          	auipc	s7,0x0
80000898:	684b8b93          	addi	s7,s7,1668 # 80000f18 <trap+0x16c>
8000089c:	ffc00b13          	li	s6,-4
800008a0:	409c57b3          	sra	a5,s8,s1
800008a4:	00f7f793          	andi	a5,a5,15
800008a8:	00fb87b3          	add	a5,s7,a5
800008ac:	0007c503          	lbu	a0,0(a5)
800008b0:	b79ff0ef          	jal	80000428 <console_putc>
800008b4:	ffc48493          	addi	s1,s1,-4
800008b8:	ff6494e3          	bne	s1,s6,800008a0 <printf+0x1c4>
800008bc:	f99ff06f          	j	80000854 <printf+0x178>
800008c0:	03012903          	lw	s2,48(sp)
800008c4:	02c12983          	lw	s3,44(sp)
800008c8:	02812a03          	lw	s4,40(sp)
800008cc:	02412a83          	lw	s5,36(sp)
800008d0:	02012b03          	lw	s6,32(sp)
800008d4:	01c12b83          	lw	s7,28(sp)
800008d8:	01812c03          	lw	s8,24(sp)
800008dc:	eadff06f          	j	80000788 <printf+0xac>

800008e0 <acquire>:
800008e0:	ff010113          	addi	sp,sp,-16
800008e4:	00112623          	sw	ra,12(sp)
800008e8:	00812423          	sw	s0,8(sp)
800008ec:	00912223          	sw	s1,4(sp)
800008f0:	01010413          	addi	s0,sp,16
800008f4:	00050493          	mv	s1,a0
800008f8:	9b1ff0ef          	jal	800002a8 <push_irq_off>
800008fc:	00100713          	li	a4,1
80000900:	00070793          	mv	a5,a4
80000904:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
80000908:	fe079ce3          	bnez	a5,80000900 <acquire+0x20>
8000090c:	0330000f          	fence	rw,rw
80000910:	00c12083          	lw	ra,12(sp)
80000914:	00812403          	lw	s0,8(sp)
80000918:	00412483          	lw	s1,4(sp)
8000091c:	01010113          	addi	sp,sp,16
80000920:	00008067          	ret

80000924 <release>:
80000924:	ff010113          	addi	sp,sp,-16
80000928:	00112623          	sw	ra,12(sp)
8000092c:	00812423          	sw	s0,8(sp)
80000930:	01010413          	addi	s0,sp,16
80000934:	0330000f          	fence	rw,rw
80000938:	0310000f          	fence	rw,w
8000093c:	00052023          	sw	zero,0(a0)
80000940:	9d5ff0ef          	jal	80000314 <pop_irq_off>
80000944:	00c12083          	lw	ra,12(sp)
80000948:	00812403          	lw	s0,8(sp)
8000094c:	01010113          	addi	sp,sp,16
80000950:	00008067          	ret

80000954 <current_task>:
80000954:	ff010113          	addi	sp,sp,-16
80000958:	00812623          	sw	s0,12(sp)
8000095c:	01010413          	addi	s0,sp,16
80000960:	00251513          	slli	a0,a0,0x2
80000964:	00001797          	auipc	a5,0x1
80000968:	c6c78793          	addi	a5,a5,-916 # 800015d0 <current_tasks>
8000096c:	00a787b3          	add	a5,a5,a0
80000970:	0007a503          	lw	a0,0(a5)
80000974:	00c12403          	lw	s0,12(sp)
80000978:	01010113          	addi	sp,sp,16
8000097c:	00008067          	ret

80000980 <get_all_tasks>:
80000980:	ff010113          	addi	sp,sp,-16
80000984:	00812623          	sw	s0,12(sp)
80000988:	01010413          	addi	s0,sp,16
8000098c:	00001517          	auipc	a0,0x1
80000990:	c6450513          	addi	a0,a0,-924 # 800015f0 <tasks>
80000994:	00c12403          	lw	s0,12(sp)
80000998:	01010113          	addi	sp,sp,16
8000099c:	00008067          	ret

800009a0 <create_task>:
800009a0:	fe010113          	addi	sp,sp,-32
800009a4:	00112e23          	sw	ra,28(sp)
800009a8:	00812c23          	sw	s0,24(sp)
800009ac:	00912a23          	sw	s1,20(sp)
800009b0:	01212823          	sw	s2,16(sp)
800009b4:	01312623          	sw	s3,12(sp)
800009b8:	01412423          	sw	s4,8(sp)
800009bc:	01512223          	sw	s5,4(sp)
800009c0:	02010413          	addi	s0,sp,32
800009c4:	00050a13          	mv	s4,a0
800009c8:	00058993          	mv	s3,a1
800009cc:	00009517          	auipc	a0,0x9
800009d0:	d2850513          	addi	a0,a0,-728 # 800096f4 <tasks_lock>
800009d4:	f0dff0ef          	jal	800008e0 <acquire>
800009d8:	00001797          	auipc	a5,0x1
800009dc:	c1878793          	addi	a5,a5,-1000 # 800015f0 <tasks>
800009e0:	00000493          	li	s1,0
800009e4:	000016b7          	lui	a3,0x1
800009e8:	02068693          	addi	a3,a3,32 # 1020 <boot-0x7fffefe0>
800009ec:	00800613          	li	a2,8
800009f0:	0147a703          	lw	a4,20(a5)
800009f4:	02070663          	beqz	a4,80000a20 <create_task+0x80>
800009f8:	00148493          	addi	s1,s1,1
800009fc:	00d787b3          	add	a5,a5,a3
80000a00:	fec498e3          	bne	s1,a2,800009f0 <create_task+0x50>
80000a04:	03200613          	li	a2,50
80000a08:	00000597          	auipc	a1,0x0
80000a0c:	52458593          	addi	a1,a1,1316 # 80000f2c <trap+0x180>
80000a10:	00000517          	auipc	a0,0x0
80000a14:	52450513          	addi	a0,a0,1316 # 80000f34 <trap+0x188>
80000a18:	cc5ff0ef          	jal	800006dc <printf>
80000a1c:	0000006f          	j	80000a1c <create_task+0x7c>
80000a20:	00749913          	slli	s2,s1,0x7
80000a24:	00990933          	add	s2,s2,s1
80000a28:	00591913          	slli	s2,s2,0x5
80000a2c:	00001a97          	auipc	s5,0x1
80000a30:	bc4a8a93          	addi	s5,s5,-1084 # 800015f0 <tasks>
80000a34:	012a8ab3          	add	s5,s5,s2
80000a38:	000015b7          	lui	a1,0x1
80000a3c:	01c58593          	addi	a1,a1,28 # 101c <boot-0x7fffefe4>
80000a40:	00ba85b3          	add	a1,s5,a1
80000a44:	00098513          	mv	a0,s3
80000a48:	915ff0ef          	jal	8000035c <init_context>
80000a4c:	00aaac23          	sw	a0,24(s5)
80000a50:	00009717          	auipc	a4,0x9
80000a54:	ca070713          	addi	a4,a4,-864 # 800096f0 <last_pid>
80000a58:	00072783          	lw	a5,0(a4)
80000a5c:	00178793          	addi	a5,a5,1
80000a60:	00f72023          	sw	a5,0(a4)
80000a64:	00faa023          	sw	a5,0(s5)
80000a68:	000a0513          	mv	a0,s4
80000a6c:	ba9ff0ef          	jal	80000614 <strlen>
80000a70:	00f00793          	li	a5,15
80000a74:	06a7c463          	blt	a5,a0,80000adc <create_task+0x13c>
80000a78:	00490513          	addi	a0,s2,4
80000a7c:	00001997          	auipc	s3,0x1
80000a80:	b7498993          	addi	s3,s3,-1164 # 800015f0 <tasks>
80000a84:	000a0593          	mv	a1,s4
80000a88:	00a98533          	add	a0,s3,a0
80000a8c:	bc9ff0ef          	jal	80000654 <strcpy>
80000a90:	00749793          	slli	a5,s1,0x7
80000a94:	009787b3          	add	a5,a5,s1
80000a98:	00579793          	slli	a5,a5,0x5
80000a9c:	00f989b3          	add	s3,s3,a5
80000aa0:	00100793          	li	a5,1
80000aa4:	00f9aa23          	sw	a5,20(s3)
80000aa8:	00009517          	auipc	a0,0x9
80000aac:	c4c50513          	addi	a0,a0,-948 # 800096f4 <tasks_lock>
80000ab0:	e75ff0ef          	jal	80000924 <release>
80000ab4:	000a8513          	mv	a0,s5
80000ab8:	01c12083          	lw	ra,28(sp)
80000abc:	01812403          	lw	s0,24(sp)
80000ac0:	01412483          	lw	s1,20(sp)
80000ac4:	01012903          	lw	s2,16(sp)
80000ac8:	00c12983          	lw	s3,12(sp)
80000acc:	00812a03          	lw	s4,8(sp)
80000ad0:	00412a83          	lw	s5,4(sp)
80000ad4:	02010113          	addi	sp,sp,32
80000ad8:	00008067          	ret
80000adc:	000a07a3          	sb	zero,15(s4)
80000ae0:	f99ff06f          	j	80000a78 <create_task+0xd8>

80000ae4 <scheduler>:
80000ae4:	fd010113          	addi	sp,sp,-48
80000ae8:	02112623          	sw	ra,44(sp)
80000aec:	02812423          	sw	s0,40(sp)
80000af0:	02912223          	sw	s1,36(sp)
80000af4:	03212023          	sw	s2,32(sp)
80000af8:	01312e23          	sw	s3,28(sp)
80000afc:	01412c23          	sw	s4,24(sp)
80000b00:	01512a23          	sw	s5,20(sp)
80000b04:	01612823          	sw	s6,16(sp)
80000b08:	01712623          	sw	s7,12(sp)
80000b0c:	01812423          	sw	s8,8(sp)
80000b10:	01912223          	sw	s9,4(sp)
80000b14:	01a12023          	sw	s10,0(sp)
80000b18:	03010413          	addi	s0,sp,48
80000b1c:	00020793          	mv	a5,tp
80000b20:	00279713          	slli	a4,a5,0x2
80000b24:	00001c97          	auipc	s9,0x1
80000b28:	abcc8c93          	addi	s9,s9,-1348 # 800015e0 <scheduler_sp>
80000b2c:	00ec8cb3          	add	s9,s9,a4
80000b30:	00001b97          	auipc	s7,0x1
80000b34:	aa0b8b93          	addi	s7,s7,-1376 # 800015d0 <current_tasks>
80000b38:	00eb8bb3          	add	s7,s7,a4
80000b3c:	00009b17          	auipc	s6,0x9
80000b40:	bb4b0b13          	addi	s6,s6,-1100 # 800096f0 <last_pid>
80000b44:	00009917          	auipc	s2,0x9
80000b48:	bb090913          	addi	s2,s2,-1104 # 800096f4 <tasks_lock>
80000b4c:	00200d13          	li	s10,2
80000b50:	00001ab7          	lui	s5,0x1
80000b54:	020a8a93          	addi	s5,s5,32 # 1020 <boot-0x7fffefe0>
80000b58:	000ba023          	sw	zero,0(s7)
80000b5c:	00001497          	auipc	s1,0x1
80000b60:	a9448493          	addi	s1,s1,-1388 # 800015f0 <tasks>
80000b64:	00100993          	li	s3,1
80000b68:	00300c13          	li	s8,3
80000b6c:	0340006f          	j	80000ba0 <scheduler+0xbc>
80000b70:	01a4aa23          	sw	s10,20(s1)
80000b74:	009ba023          	sw	s1,0(s7)
80000b78:	00090513          	mv	a0,s2
80000b7c:	da9ff0ef          	jal	80000924 <release>
80000b80:	10016073          	csrsi	sstatus,2
80000b84:	01848593          	addi	a1,s1,24
80000b88:	000c8513          	mv	a0,s9
80000b8c:	d1cff0ef          	jal	800000a8 <context_switch>
80000b90:	0144a783          	lw	a5,20(s1)
80000b94:	03878463          	beq	a5,s8,80000bbc <scheduler+0xd8>
80000b98:	015484b3          	add	s1,s1,s5
80000b9c:	fb648ee3          	beq	s1,s6,80000b58 <scheduler+0x74>
80000ba0:	00090513          	mv	a0,s2
80000ba4:	d3dff0ef          	jal	800008e0 <acquire>
80000ba8:	0144a783          	lw	a5,20(s1)
80000bac:	fd3782e3          	beq	a5,s3,80000b70 <scheduler+0x8c>
80000bb0:	00090513          	mv	a0,s2
80000bb4:	d71ff0ef          	jal	80000924 <release>
80000bb8:	fe1ff06f          	j	80000b98 <scheduler+0xb4>
80000bbc:	0004aa23          	sw	zero,20(s1)
80000bc0:	fd9ff06f          	j	80000b98 <scheduler+0xb4>

80000bc4 <yield>:
80000bc4:	ff010113          	addi	sp,sp,-16
80000bc8:	00112623          	sw	ra,12(sp)
80000bcc:	00812423          	sw	s0,8(sp)
80000bd0:	01010413          	addi	s0,sp,16
80000bd4:	00020593          	mv	a1,tp
80000bd8:	00259713          	slli	a4,a1,0x2
80000bdc:	00001797          	auipc	a5,0x1
80000be0:	9f478793          	addi	a5,a5,-1548 # 800015d0 <current_tasks>
80000be4:	00e787b3          	add	a5,a5,a4
80000be8:	0007a503          	lw	a0,0(a5)
80000bec:	01452703          	lw	a4,20(a0)
80000bf0:	00300793          	li	a5,3
80000bf4:	00f70663          	beq	a4,a5,80000c00 <yield+0x3c>
80000bf8:	00100793          	li	a5,1
80000bfc:	00f52a23          	sw	a5,20(a0)
80000c00:	00259593          	slli	a1,a1,0x2
80000c04:	00001797          	auipc	a5,0x1
80000c08:	9dc78793          	addi	a5,a5,-1572 # 800015e0 <scheduler_sp>
80000c0c:	00b785b3          	add	a1,a5,a1
80000c10:	01850513          	addi	a0,a0,24
80000c14:	c94ff0ef          	jal	800000a8 <context_switch>
80000c18:	00c12083          	lw	ra,12(sp)
80000c1c:	00812403          	lw	s0,8(sp)
80000c20:	01010113          	addi	sp,sp,16
80000c24:	00008067          	ret

80000c28 <kill_task>:
80000c28:	ff010113          	addi	sp,sp,-16
80000c2c:	00112623          	sw	ra,12(sp)
80000c30:	00812423          	sw	s0,8(sp)
80000c34:	01010413          	addi	s0,sp,16
80000c38:	00300793          	li	a5,3
80000c3c:	00f52a23          	sw	a5,20(a0)
80000c40:	f85ff0ef          	jal	80000bc4 <yield>
80000c44:	00c12083          	lw	ra,12(sp)
80000c48:	00812403          	lw	s0,8(sp)
80000c4c:	01010113          	addi	sp,sp,16
80000c50:	00008067          	ret

80000c54 <sleep>:
80000c54:	ff010113          	addi	sp,sp,-16
80000c58:	00112623          	sw	ra,12(sp)
80000c5c:	00812423          	sw	s0,8(sp)
80000c60:	01010413          	addi	s0,sp,16
80000c64:	00050693          	mv	a3,a0
80000c68:	00020713          	mv	a4,tp
80000c6c:	00271713          	slli	a4,a4,0x2
80000c70:	00001797          	auipc	a5,0x1
80000c74:	96078793          	addi	a5,a5,-1696 # 800015d0 <current_tasks>
80000c78:	00e787b3          	add	a5,a5,a4
80000c7c:	0007a783          	lw	a5,0(a5)
80000c80:	00009617          	auipc	a2,0x9
80000c84:	a8862603          	lw	a2,-1400(a2) # 80009708 <ticks>
80000c88:	00001737          	lui	a4,0x1
80000c8c:	00e78733          	add	a4,a5,a4
80000c90:	00c505b3          	add	a1,a0,a2
80000c94:	00b72e23          	sw	a1,28(a4) # 101c <boot-0x7fffefe4>
80000c98:	00400713          	li	a4,4
80000c9c:	00e7aa23          	sw	a4,20(a5)
80000ca0:	0007a583          	lw	a1,0(a5)
80000ca4:	00000517          	auipc	a0,0x0
80000ca8:	2b450513          	addi	a0,a0,692 # 80000f58 <trap+0x1ac>
80000cac:	a31ff0ef          	jal	800006dc <printf>
80000cb0:	f15ff0ef          	jal	80000bc4 <yield>
80000cb4:	00c12083          	lw	ra,12(sp)
80000cb8:	00812403          	lw	s0,8(sp)
80000cbc:	01010113          	addi	sp,sp,16
80000cc0:	00008067          	ret

80000cc4 <evaluate_sleeping_tasks>:
80000cc4:	fd010113          	addi	sp,sp,-48
80000cc8:	02112623          	sw	ra,44(sp)
80000ccc:	02812423          	sw	s0,40(sp)
80000cd0:	02912223          	sw	s1,36(sp)
80000cd4:	03212023          	sw	s2,32(sp)
80000cd8:	01312e23          	sw	s3,28(sp)
80000cdc:	01412c23          	sw	s4,24(sp)
80000ce0:	01512a23          	sw	s5,20(sp)
80000ce4:	01612823          	sw	s6,16(sp)
80000ce8:	01712623          	sw	s7,12(sp)
80000cec:	03010413          	addi	s0,sp,48
80000cf0:	00009517          	auipc	a0,0x9
80000cf4:	a1c50513          	addi	a0,a0,-1508 # 8000970c <timer_lock>
80000cf8:	be9ff0ef          	jal	800008e0 <acquire>
80000cfc:	c85ff0ef          	jal	80000980 <get_all_tasks>
80000d00:	00050493          	mv	s1,a0
80000d04:	00008937          	lui	s2,0x8
80000d08:	10090913          	addi	s2,s2,256 # 8100 <boot-0x7fff7f00>
80000d0c:	01250933          	add	s2,a0,s2
80000d10:	00400a13          	li	s4,4
80000d14:	00009b97          	auipc	s7,0x9
80000d18:	9f4b8b93          	addi	s7,s7,-1548 # 80009708 <ticks>
80000d1c:	00001ab7          	lui	s5,0x1
80000d20:	01ca8a93          	addi	s5,s5,28 # 101c <boot-0x7fffefe4>
80000d24:	000019b7          	lui	s3,0x1
80000d28:	02098993          	addi	s3,s3,32 # 1020 <boot-0x7fffefe0>
80000d2c:	00c0006f          	j	80000d38 <evaluate_sleeping_tasks+0x74>
80000d30:	013484b3          	add	s1,s1,s3
80000d34:	05248063          	beq	s1,s2,80000d74 <evaluate_sleeping_tasks+0xb0>
80000d38:	0144a783          	lw	a5,20(s1)
80000d3c:	ff479ae3          	bne	a5,s4,80000d30 <evaluate_sleeping_tasks+0x6c>
80000d40:	000ba783          	lw	a5,0(s7)
80000d44:	01548733          	add	a4,s1,s5
80000d48:	00072703          	lw	a4,0(a4)
80000d4c:	fee7e2e3          	bltu	a5,a4,80000d30 <evaluate_sleeping_tasks+0x6c>
80000d50:	00009617          	auipc	a2,0x9
80000d54:	9b862603          	lw	a2,-1608(a2) # 80009708 <ticks>
80000d58:	0004a583          	lw	a1,0(s1)
80000d5c:	00000517          	auipc	a0,0x0
80000d60:	24850513          	addi	a0,a0,584 # 80000fa4 <trap+0x1f8>
80000d64:	979ff0ef          	jal	800006dc <printf>
80000d68:	00100793          	li	a5,1
80000d6c:	00f4aa23          	sw	a5,20(s1)
80000d70:	fc1ff06f          	j	80000d30 <evaluate_sleeping_tasks+0x6c>
80000d74:	00009517          	auipc	a0,0x9
80000d78:	99850513          	addi	a0,a0,-1640 # 8000970c <timer_lock>
80000d7c:	ba9ff0ef          	jal	80000924 <release>
80000d80:	02c12083          	lw	ra,44(sp)
80000d84:	02812403          	lw	s0,40(sp)
80000d88:	02412483          	lw	s1,36(sp)
80000d8c:	02012903          	lw	s2,32(sp)
80000d90:	01c12983          	lw	s3,28(sp)
80000d94:	01812a03          	lw	s4,24(sp)
80000d98:	01412a83          	lw	s5,20(sp)
80000d9c:	01012b03          	lw	s6,16(sp)
80000da0:	00c12b83          	lw	s7,12(sp)
80000da4:	03010113          	addi	sp,sp,48
80000da8:	00008067          	ret

80000dac <trap>:
80000dac:	fe010113          	addi	sp,sp,-32
80000db0:	00112e23          	sw	ra,28(sp)
80000db4:	00812c23          	sw	s0,24(sp)
80000db8:	00912a23          	sw	s1,20(sp)
80000dbc:	01212823          	sw	s2,16(sp)
80000dc0:	01312623          	sw	s3,12(sp)
80000dc4:	01412423          	sw	s4,8(sp)
80000dc8:	02010413          	addi	s0,sp,32
80000dcc:	00020493          	mv	s1,tp
80000dd0:	142029f3          	csrr	s3,scause
80000dd4:	14102a73          	csrr	s4,sepc
80000dd8:	00048513          	mv	a0,s1
80000ddc:	b79ff0ef          	jal	80000954 <current_task>
80000de0:	00050913          	mv	s2,a0
80000de4:	00009517          	auipc	a0,0x9
80000de8:	91450513          	addi	a0,a0,-1772 # 800096f8 <console_lock>
80000dec:	af5ff0ef          	jal	800008e0 <acquire>
80000df0:	000a0713          	mv	a4,s4
80000df4:	00098693          	mv	a3,s3
80000df8:	00048613          	mv	a2,s1
80000dfc:	00009597          	auipc	a1,0x9
80000e00:	90c5a583          	lw	a1,-1780(a1) # 80009708 <ticks>
80000e04:	00000517          	auipc	a0,0x0
80000e08:	1cc50513          	addi	a0,a0,460 # 80000fd0 <trap+0x224>
80000e0c:	8d1ff0ef          	jal	800006dc <printf>
80000e10:	00009517          	auipc	a0,0x9
80000e14:	8e850513          	addi	a0,a0,-1816 # 800096f8 <console_lock>
80000e18:	b0dff0ef          	jal	80000924 <release>
80000e1c:	00200793          	li	a5,2
80000e20:	06f98263          	beq	s3,a5,80000e84 <trap+0xd8>
80000e24:	01512223          	sw	s5,4(sp)
80000e28:	800007b7          	lui	a5,0x80000
80000e2c:	00178793          	addi	a5,a5,1 # 80000001 <boot+0x1>
80000e30:	06f99263          	bne	s3,a5,80000e94 <trap+0xe8>
80000e34:	02048a63          	beqz	s1,80000e68 <trap+0xbc>
80000e38:	14417073          	csrci	sip,2
80000e3c:	06090a63          	beqz	s2,80000eb0 <trap+0x104>
80000e40:	d85ff0ef          	jal	80000bc4 <yield>
80000e44:	00412a83          	lw	s5,4(sp)
80000e48:	01c12083          	lw	ra,28(sp)
80000e4c:	01812403          	lw	s0,24(sp)
80000e50:	01412483          	lw	s1,20(sp)
80000e54:	01012903          	lw	s2,16(sp)
80000e58:	00c12983          	lw	s3,12(sp)
80000e5c:	00812a03          	lw	s4,8(sp)
80000e60:	02010113          	addi	sp,sp,32
80000e64:	00008067          	ret
80000e68:	00009717          	auipc	a4,0x9
80000e6c:	8a070713          	addi	a4,a4,-1888 # 80009708 <ticks>
80000e70:	00072783          	lw	a5,0(a4)
80000e74:	00178793          	addi	a5,a5,1
80000e78:	00f72023          	sw	a5,0(a4)
80000e7c:	e49ff0ef          	jal	80000cc4 <evaluate_sleeping_tasks>
80000e80:	fb9ff06f          	j	80000e38 <trap+0x8c>
80000e84:	fc0902e3          	beqz	s2,80000e48 <trap+0x9c>
80000e88:	00090513          	mv	a0,s2
80000e8c:	d9dff0ef          	jal	80000c28 <kill_task>
80000e90:	fb9ff06f          	j	80000e48 <trap+0x9c>
80000e94:	05400613          	li	a2,84
80000e98:	00000597          	auipc	a1,0x0
80000e9c:	16458593          	addi	a1,a1,356 # 80000ffc <trap+0x250>
80000ea0:	00000517          	auipc	a0,0x0
80000ea4:	16450513          	addi	a0,a0,356 # 80001004 <trap+0x258>
80000ea8:	835ff0ef          	jal	800006dc <printf>
80000eac:	0000006f          	j	80000eac <trap+0x100>
80000eb0:	00412a83          	lw	s5,4(sp)
80000eb4:	f95ff06f          	j	80000e48 <trap+0x9c>
