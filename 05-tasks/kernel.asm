
kernel:     file format elf32-littleriscv


Disassembly of section .text:

80000000 <boot>:
80000000:	f1402273          	csrr	tp,mhartid
80000004:	00009117          	auipc	sp,0x9
80000008:	e6810113          	addi	sp,sp,-408 # 80008e6c <__bss_end>
8000000c:	000012b7          	lui	t0,0x1
80000010:	00120313          	addi	t1,tp,1 # 1 <boot-0x7fffffff>
80000014:	026282b3          	mul	t0,t0,t1
80000018:	00510133          	add	sp,sp,t0
8000001c:	00000297          	auipc	t0,0x0
80000020:	05028293          	addi	t0,t0,80 # 8000006c <supervisor>
80000024:	34129073          	csrw	mepc,t0
80000028:	01f00f13          	li	t5,31
8000002c:	3a0f1073          	csrw	pmpcfg0,t5
80000030:	fff00f93          	li	t6,-1
80000034:	3b0f9073          	csrw	pmpaddr0,t6
80000038:	300023f3          	csrr	t2,mstatus
8000003c:	ffffee37          	lui	t3,0xffffe
80000040:	7ffe0e13          	addi	t3,t3,2047 # ffffe7ff <__kernel_end+0x7ffd5993>
80000044:	01c3f3b3          	and	t2,t2,t3
80000048:	00001eb7          	lui	t4,0x1
8000004c:	800e8e93          	addi	t4,t4,-2048 # 800 <boot-0x7ffff800>
80000050:	01d3e3b3          	or	t2,t2,t4
80000054:	30039073          	csrw	mstatus,t2
80000058:	00010f37          	lui	t5,0x10
8000005c:	ffff0f13          	addi	t5,t5,-1 # ffff <boot-0x7fff0001>
80000060:	302f2073          	csrs	medeleg,t5
80000064:	303f2073          	csrs	mideleg,t5
80000068:	30200073          	mret

8000006c <supervisor>:
8000006c:	18001073          	csrw	satp,zero
80000070:	52c000ef          	jal	8000059c <kernel_main>

80000074 <cpuid>:
80000074:	00020513          	mv	a0,tp
80000078:	00008067          	ret

8000007c <disable_interrupts>:
8000007c:	10017073          	csrci	sstatus,2
80000080:	00008067          	ret

80000084 <enable_interrupts>:
80000084:	10016073          	csrsi	sstatus,2
80000088:	00008067          	ret

8000008c <context_switch>:
8000008c:	fcc10113          	addi	sp,sp,-52
80000090:	00112023          	sw	ra,0(sp)
80000094:	00812223          	sw	s0,4(sp)
80000098:	00912423          	sw	s1,8(sp)
8000009c:	01212623          	sw	s2,12(sp)
800000a0:	01312823          	sw	s3,16(sp)
800000a4:	01412a23          	sw	s4,20(sp)
800000a8:	01512c23          	sw	s5,24(sp)
800000ac:	01612e23          	sw	s6,28(sp)
800000b0:	03712023          	sw	s7,32(sp)
800000b4:	03812223          	sw	s8,36(sp)
800000b8:	03912423          	sw	s9,40(sp)
800000bc:	03a12623          	sw	s10,44(sp)
800000c0:	03b12823          	sw	s11,48(sp)
800000c4:	00252023          	sw	sp,0(a0)
800000c8:	0005a103          	lw	sp,0(a1)
800000cc:	00012083          	lw	ra,0(sp)
800000d0:	00412403          	lw	s0,4(sp)
800000d4:	00812483          	lw	s1,8(sp)
800000d8:	00c12903          	lw	s2,12(sp)
800000dc:	01012983          	lw	s3,16(sp)
800000e0:	01412a03          	lw	s4,20(sp)
800000e4:	01812a83          	lw	s5,24(sp)
800000e8:	01c12b03          	lw	s6,28(sp)
800000ec:	02012b83          	lw	s7,32(sp)
800000f0:	02412c03          	lw	s8,36(sp)
800000f4:	02812c83          	lw	s9,40(sp)
800000f8:	02c12d03          	lw	s10,44(sp)
800000fc:	03012d83          	lw	s11,48(sp)
80000100:	03410113          	addi	sp,sp,52
80000104:	00008067          	ret

80000108 <init_context>:
80000108:	ff010113          	addi	sp,sp,-16
8000010c:	00812623          	sw	s0,12(sp)
80000110:	01010413          	addi	s0,sp,16
80000114:	fe05ae23          	sw	zero,-4(a1)
80000118:	fe05ac23          	sw	zero,-8(a1)
8000011c:	fe05aa23          	sw	zero,-12(a1)
80000120:	fe05a823          	sw	zero,-16(a1)
80000124:	fe05a623          	sw	zero,-20(a1)
80000128:	fe05a423          	sw	zero,-24(a1)
8000012c:	fe05a223          	sw	zero,-28(a1)
80000130:	fe05a023          	sw	zero,-32(a1)
80000134:	fc05ae23          	sw	zero,-36(a1)
80000138:	fc05ac23          	sw	zero,-40(a1)
8000013c:	fc05aa23          	sw	zero,-44(a1)
80000140:	fc05a823          	sw	zero,-48(a1)
80000144:	fca5a623          	sw	a0,-52(a1)
80000148:	fcc58513          	addi	a0,a1,-52
8000014c:	00c12403          	lw	s0,12(sp)
80000150:	01010113          	addi	sp,sp,16
80000154:	00008067          	ret

80000158 <console_putc>:
80000158:	ff010113          	addi	sp,sp,-16
8000015c:	00812623          	sw	s0,12(sp)
80000160:	01010413          	addi	s0,sp,16
80000164:	100007b7          	lui	a5,0x10000
80000168:	00578793          	addi	a5,a5,5 # 10000005 <boot-0x6ffffffb>
8000016c:	0007c783          	lbu	a5,0(a5)
80000170:	0407f793          	andi	a5,a5,64
80000174:	00078063          	beqz	a5,80000174 <console_putc+0x1c>
80000178:	100007b7          	lui	a5,0x10000
8000017c:	00a78023          	sb	a0,0(a5) # 10000000 <boot-0x70000000>
80000180:	00c12403          	lw	s0,12(sp)
80000184:	01010113          	addi	sp,sp,16
80000188:	00008067          	ret

8000018c <console_puts>:
8000018c:	ff010113          	addi	sp,sp,-16
80000190:	00112623          	sw	ra,12(sp)
80000194:	00812423          	sw	s0,8(sp)
80000198:	00912223          	sw	s1,4(sp)
8000019c:	01010413          	addi	s0,sp,16
800001a0:	00050493          	mv	s1,a0
800001a4:	00054503          	lbu	a0,0(a0)
800001a8:	00050a63          	beqz	a0,800001bc <console_puts+0x30>
800001ac:	00148493          	addi	s1,s1,1
800001b0:	fa9ff0ef          	jal	80000158 <console_putc>
800001b4:	0004c503          	lbu	a0,0(s1)
800001b8:	fe051ae3          	bnez	a0,800001ac <console_puts+0x20>
800001bc:	00c12083          	lw	ra,12(sp)
800001c0:	00812403          	lw	s0,8(sp)
800001c4:	00412483          	lw	s1,4(sp)
800001c8:	01010113          	addi	sp,sp,16
800001cc:	00008067          	ret

800001d0 <memset>:
800001d0:	ff010113          	addi	sp,sp,-16
800001d4:	00812623          	sw	s0,12(sp)
800001d8:	01010413          	addi	s0,sp,16
800001dc:	00060c63          	beqz	a2,800001f4 <memset+0x24>
800001e0:	00c50633          	add	a2,a0,a2
800001e4:	00050793          	mv	a5,a0
800001e8:	00178793          	addi	a5,a5,1
800001ec:	feb78fa3          	sb	a1,-1(a5)
800001f0:	fef61ce3          	bne	a2,a5,800001e8 <memset+0x18>
800001f4:	00c12403          	lw	s0,12(sp)
800001f8:	01010113          	addi	sp,sp,16
800001fc:	00008067          	ret

80000200 <memcpy>:
80000200:	ff010113          	addi	sp,sp,-16
80000204:	00812623          	sw	s0,12(sp)
80000208:	01010413          	addi	s0,sp,16
8000020c:	02060063          	beqz	a2,8000022c <memcpy+0x2c>
80000210:	00c50633          	add	a2,a0,a2
80000214:	00050793          	mv	a5,a0
80000218:	00158593          	addi	a1,a1,1
8000021c:	00178793          	addi	a5,a5,1
80000220:	fff5c703          	lbu	a4,-1(a1)
80000224:	fee78fa3          	sb	a4,-1(a5)
80000228:	fef618e3          	bne	a2,a5,80000218 <memcpy+0x18>
8000022c:	00c12403          	lw	s0,12(sp)
80000230:	01010113          	addi	sp,sp,16
80000234:	00008067          	ret

80000238 <strcpy>:
80000238:	ff010113          	addi	sp,sp,-16
8000023c:	00812623          	sw	s0,12(sp)
80000240:	01010413          	addi	s0,sp,16
80000244:	0005c783          	lbu	a5,0(a1)
80000248:	02078663          	beqz	a5,80000274 <strcpy+0x3c>
8000024c:	00050713          	mv	a4,a0
80000250:	00158593          	addi	a1,a1,1
80000254:	00170713          	addi	a4,a4,1
80000258:	fef70fa3          	sb	a5,-1(a4)
8000025c:	0005c783          	lbu	a5,0(a1)
80000260:	fe0798e3          	bnez	a5,80000250 <strcpy+0x18>
80000264:	00070023          	sb	zero,0(a4)
80000268:	00c12403          	lw	s0,12(sp)
8000026c:	01010113          	addi	sp,sp,16
80000270:	00008067          	ret
80000274:	00050713          	mv	a4,a0
80000278:	fedff06f          	j	80000264 <strcpy+0x2c>

8000027c <strcmp>:
8000027c:	ff010113          	addi	sp,sp,-16
80000280:	00812623          	sw	s0,12(sp)
80000284:	01010413          	addi	s0,sp,16
80000288:	00054783          	lbu	a5,0(a0)
8000028c:	02078063          	beqz	a5,800002ac <strcmp+0x30>
80000290:	0005c703          	lbu	a4,0(a1)
80000294:	00070c63          	beqz	a4,800002ac <strcmp+0x30>
80000298:	00f71a63          	bne	a4,a5,800002ac <strcmp+0x30>
8000029c:	00150513          	addi	a0,a0,1
800002a0:	00158593          	addi	a1,a1,1
800002a4:	00054783          	lbu	a5,0(a0)
800002a8:	fe0794e3          	bnez	a5,80000290 <strcmp+0x14>
800002ac:	0005c503          	lbu	a0,0(a1)
800002b0:	40a78533          	sub	a0,a5,a0
800002b4:	00c12403          	lw	s0,12(sp)
800002b8:	01010113          	addi	sp,sp,16
800002bc:	00008067          	ret

800002c0 <printf>:
800002c0:	fa010113          	addi	sp,sp,-96
800002c4:	02112e23          	sw	ra,60(sp)
800002c8:	02812c23          	sw	s0,56(sp)
800002cc:	02912a23          	sw	s1,52(sp)
800002d0:	04010413          	addi	s0,sp,64
800002d4:	00050493          	mv	s1,a0
800002d8:	00b42223          	sw	a1,4(s0)
800002dc:	00c42423          	sw	a2,8(s0)
800002e0:	00d42623          	sw	a3,12(s0)
800002e4:	00e42823          	sw	a4,16(s0)
800002e8:	00f42a23          	sw	a5,20(s0)
800002ec:	01042c23          	sw	a6,24(s0)
800002f0:	01142e23          	sw	a7,28(s0)
800002f4:	00440793          	addi	a5,s0,4
800002f8:	fcf42623          	sw	a5,-52(s0)
800002fc:	00054503          	lbu	a0,0(a0)
80000300:	06050663          	beqz	a0,8000036c <printf+0xac>
80000304:	03212823          	sw	s2,48(sp)
80000308:	03312623          	sw	s3,44(sp)
8000030c:	03412423          	sw	s4,40(sp)
80000310:	03512223          	sw	s5,36(sp)
80000314:	03612023          	sw	s6,32(sp)
80000318:	01712e23          	sw	s7,28(sp)
8000031c:	01812c23          	sw	s8,24(sp)
80000320:	02500993          	li	s3,37
80000324:	06400a13          	li	s4,100
80000328:	07300a93          	li	s5,115
8000032c:	1180006f          	j	80000444 <printf+0x184>
80000330:	00078c63          	beqz	a5,80000348 <printf+0x88>
80000334:	02500713          	li	a4,37
80000338:	10e79063          	bne	a5,a4,80000438 <printf+0x178>
8000033c:	02500513          	li	a0,37
80000340:	e19ff0ef          	jal	80000158 <console_putc>
80000344:	0f40006f          	j	80000438 <printf+0x178>
80000348:	02500513          	li	a0,37
8000034c:	e0dff0ef          	jal	80000158 <console_putc>
80000350:	03012903          	lw	s2,48(sp)
80000354:	02c12983          	lw	s3,44(sp)
80000358:	02812a03          	lw	s4,40(sp)
8000035c:	02412a83          	lw	s5,36(sp)
80000360:	02012b03          	lw	s6,32(sp)
80000364:	01c12b83          	lw	s7,28(sp)
80000368:	01812c03          	lw	s8,24(sp)
8000036c:	03c12083          	lw	ra,60(sp)
80000370:	03812403          	lw	s0,56(sp)
80000374:	03412483          	lw	s1,52(sp)
80000378:	06010113          	addi	sp,sp,96
8000037c:	00008067          	ret
80000380:	fcc42783          	lw	a5,-52(s0)
80000384:	00478713          	addi	a4,a5,4
80000388:	fce42623          	sw	a4,-52(s0)
8000038c:	0007a483          	lw	s1,0(a5)
80000390:	0004c503          	lbu	a0,0(s1)
80000394:	0a050263          	beqz	a0,80000438 <printf+0x178>
80000398:	dc1ff0ef          	jal	80000158 <console_putc>
8000039c:	00148493          	addi	s1,s1,1
800003a0:	0004c503          	lbu	a0,0(s1)
800003a4:	fe051ae3          	bnez	a0,80000398 <printf+0xd8>
800003a8:	0900006f          	j	80000438 <printf+0x178>
800003ac:	fcc42783          	lw	a5,-52(s0)
800003b0:	00478713          	addi	a4,a5,4
800003b4:	fce42623          	sw	a4,-52(s0)
800003b8:	0007ab03          	lw	s6,0(a5)
800003bc:	040b4e63          	bltz	s6,80000418 <printf+0x158>
800003c0:	00900793          	li	a5,9
800003c4:	0767d263          	bge	a5,s6,80000428 <printf+0x168>
800003c8:	00100493          	li	s1,1
800003cc:	00900713          	li	a4,9
800003d0:	00249793          	slli	a5,s1,0x2
800003d4:	009787b3          	add	a5,a5,s1
800003d8:	00179793          	slli	a5,a5,0x1
800003dc:	00078493          	mv	s1,a5
800003e0:	02fb47b3          	div	a5,s6,a5
800003e4:	fef746e3          	blt	a4,a5,800003d0 <printf+0x110>
800003e8:	04905863          	blez	s1,80000438 <printf+0x178>
800003ec:	00a00c13          	li	s8,10
800003f0:	00900b93          	li	s7,9
800003f4:	029b4533          	div	a0,s6,s1
800003f8:	03050513          	addi	a0,a0,48
800003fc:	0ff57513          	zext.b	a0,a0
80000400:	d59ff0ef          	jal	80000158 <console_putc>
80000404:	029b6b33          	rem	s6,s6,s1
80000408:	00048793          	mv	a5,s1
8000040c:	0384c4b3          	div	s1,s1,s8
80000410:	fefbc2e3          	blt	s7,a5,800003f4 <printf+0x134>
80000414:	0240006f          	j	80000438 <printf+0x178>
80000418:	02d00513          	li	a0,45
8000041c:	d3dff0ef          	jal	80000158 <console_putc>
80000420:	41600b33          	neg	s6,s6
80000424:	f9dff06f          	j	800003c0 <printf+0x100>
80000428:	00100493          	li	s1,1
8000042c:	fc1ff06f          	j	800003ec <printf+0x12c>
80000430:	d29ff0ef          	jal	80000158 <console_putc>
80000434:	00048913          	mv	s2,s1
80000438:	00190493          	addi	s1,s2,1
8000043c:	00194503          	lbu	a0,1(s2)
80000440:	06050263          	beqz	a0,800004a4 <printf+0x1e4>
80000444:	ff3516e3          	bne	a0,s3,80000430 <printf+0x170>
80000448:	00148913          	addi	s2,s1,1
8000044c:	0014c783          	lbu	a5,1(s1)
80000450:	f5478ee3          	beq	a5,s4,800003ac <printf+0xec>
80000454:	ecfa7ee3          	bgeu	s4,a5,80000330 <printf+0x70>
80000458:	f35784e3          	beq	a5,s5,80000380 <printf+0xc0>
8000045c:	07800713          	li	a4,120
80000460:	fce79ce3          	bne	a5,a4,80000438 <printf+0x178>
80000464:	fcc42783          	lw	a5,-52(s0)
80000468:	00478713          	addi	a4,a5,4
8000046c:	fce42623          	sw	a4,-52(s0)
80000470:	0007ac03          	lw	s8,0(a5)
80000474:	01c00493          	li	s1,28
80000478:	00000b97          	auipc	s7,0x0
8000047c:	4a0b8b93          	addi	s7,s7,1184 # 80000918 <yield+0x78>
80000480:	ffc00b13          	li	s6,-4
80000484:	409c57b3          	sra	a5,s8,s1
80000488:	00f7f793          	andi	a5,a5,15
8000048c:	00fb87b3          	add	a5,s7,a5
80000490:	0007c503          	lbu	a0,0(a5)
80000494:	cc5ff0ef          	jal	80000158 <console_putc>
80000498:	ffc48493          	addi	s1,s1,-4
8000049c:	ff6494e3          	bne	s1,s6,80000484 <printf+0x1c4>
800004a0:	f99ff06f          	j	80000438 <printf+0x178>
800004a4:	03012903          	lw	s2,48(sp)
800004a8:	02c12983          	lw	s3,44(sp)
800004ac:	02812a03          	lw	s4,40(sp)
800004b0:	02412a83          	lw	s5,36(sp)
800004b4:	02012b03          	lw	s6,32(sp)
800004b8:	01c12b83          	lw	s7,28(sp)
800004bc:	01812c03          	lw	s8,24(sp)
800004c0:	eadff06f          	j	8000036c <printf+0xac>

800004c4 <task_a>:
800004c4:	ff010113          	addi	sp,sp,-16
800004c8:	00112623          	sw	ra,12(sp)
800004cc:	00812423          	sw	s0,8(sp)
800004d0:	00912223          	sw	s1,4(sp)
800004d4:	01010413          	addi	s0,sp,16
800004d8:	00000497          	auipc	s1,0x0
800004dc:	45448493          	addi	s1,s1,1108 # 8000092c <yield+0x8c>
800004e0:	b95ff0ef          	jal	80000074 <cpuid>
800004e4:	00050593          	mv	a1,a0
800004e8:	00048513          	mv	a0,s1
800004ec:	dd5ff0ef          	jal	800002c0 <printf>
800004f0:	3b0000ef          	jal	800008a0 <yield>
800004f4:	11e1a7b7          	lui	a5,0x11e1a
800004f8:	30078793          	addi	a5,a5,768 # 11e1a300 <boot-0x6e1e5d00>
800004fc:	00000013          	nop
80000500:	fff78793          	addi	a5,a5,-1
80000504:	fe079ce3          	bnez	a5,800004fc <task_a+0x38>
80000508:	fd9ff06f          	j	800004e0 <task_a+0x1c>

8000050c <task_b>:
8000050c:	ff010113          	addi	sp,sp,-16
80000510:	00112623          	sw	ra,12(sp)
80000514:	00812423          	sw	s0,8(sp)
80000518:	00912223          	sw	s1,4(sp)
8000051c:	01010413          	addi	s0,sp,16
80000520:	00000497          	auipc	s1,0x0
80000524:	42048493          	addi	s1,s1,1056 # 80000940 <yield+0xa0>
80000528:	b4dff0ef          	jal	80000074 <cpuid>
8000052c:	00050593          	mv	a1,a0
80000530:	00048513          	mv	a0,s1
80000534:	d8dff0ef          	jal	800002c0 <printf>
80000538:	368000ef          	jal	800008a0 <yield>
8000053c:	11e1a7b7          	lui	a5,0x11e1a
80000540:	30078793          	addi	a5,a5,768 # 11e1a300 <boot-0x6e1e5d00>
80000544:	00000013          	nop
80000548:	fff78793          	addi	a5,a5,-1
8000054c:	fe079ce3          	bnez	a5,80000544 <task_b+0x38>
80000550:	fd9ff06f          	j	80000528 <task_b+0x1c>

80000554 <task_c>:
80000554:	ff010113          	addi	sp,sp,-16
80000558:	00112623          	sw	ra,12(sp)
8000055c:	00812423          	sw	s0,8(sp)
80000560:	00912223          	sw	s1,4(sp)
80000564:	01010413          	addi	s0,sp,16
80000568:	00000497          	auipc	s1,0x0
8000056c:	3ec48493          	addi	s1,s1,1004 # 80000954 <yield+0xb4>
80000570:	b05ff0ef          	jal	80000074 <cpuid>
80000574:	00050593          	mv	a1,a0
80000578:	00048513          	mv	a0,s1
8000057c:	d45ff0ef          	jal	800002c0 <printf>
80000580:	320000ef          	jal	800008a0 <yield>
80000584:	11e1a7b7          	lui	a5,0x11e1a
80000588:	30078793          	addi	a5,a5,768 # 11e1a300 <boot-0x6e1e5d00>
8000058c:	00000013          	nop
80000590:	fff78793          	addi	a5,a5,-1
80000594:	fe079ce3          	bnez	a5,8000058c <task_c+0x38>
80000598:	fd9ff06f          	j	80000570 <task_c+0x1c>

8000059c <kernel_main>:
8000059c:	ff010113          	addi	sp,sp,-16
800005a0:	00112623          	sw	ra,12(sp)
800005a4:	00812423          	sw	s0,8(sp)
800005a8:	01010413          	addi	s0,sp,16
800005ac:	ac9ff0ef          	jal	80000074 <cpuid>
800005b0:	02050263          	beqz	a0,800005d4 <kernel_main+0x38>
800005b4:	1f8000ef          	jal	800007ac <scheduler>
800005b8:	03300613          	li	a2,51
800005bc:	00000597          	auipc	a1,0x0
800005c0:	3ac58593          	addi	a1,a1,940 # 80000968 <yield+0xc8>
800005c4:	00000517          	auipc	a0,0x0
800005c8:	3ac50513          	addi	a0,a0,940 # 80000970 <yield+0xd0>
800005cc:	cf5ff0ef          	jal	800002c0 <printf>
800005d0:	0000006f          	j	800005d0 <kernel_main+0x34>
800005d4:	00200593          	li	a1,2
800005d8:	00000517          	auipc	a0,0x0
800005dc:	eec50513          	addi	a0,a0,-276 # 800004c4 <task_a>
800005e0:	0d4000ef          	jal	800006b4 <create_task>
800005e4:	00400593          	li	a1,4
800005e8:	00000517          	auipc	a0,0x0
800005ec:	f6c50513          	addi	a0,a0,-148 # 80000554 <task_c>
800005f0:	0c4000ef          	jal	800006b4 <create_task>
800005f4:	00400593          	li	a1,4
800005f8:	00000517          	auipc	a0,0x0
800005fc:	f1450513          	addi	a0,a0,-236 # 8000050c <task_b>
80000600:	0b4000ef          	jal	800006b4 <create_task>
80000604:	fb1ff06f          	j	800005b4 <kernel_main+0x18>

80000608 <acquire>:
80000608:	ff010113          	addi	sp,sp,-16
8000060c:	00112623          	sw	ra,12(sp)
80000610:	00812423          	sw	s0,8(sp)
80000614:	00912223          	sw	s1,4(sp)
80000618:	01010413          	addi	s0,sp,16
8000061c:	00050493          	mv	s1,a0
80000620:	a5dff0ef          	jal	8000007c <disable_interrupts>
80000624:	00100713          	li	a4,1
80000628:	00070793          	mv	a5,a4
8000062c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
80000630:	fe079ce3          	bnez	a5,80000628 <acquire+0x20>
80000634:	0330000f          	fence	rw,rw
80000638:	00c12083          	lw	ra,12(sp)
8000063c:	00812403          	lw	s0,8(sp)
80000640:	00412483          	lw	s1,4(sp)
80000644:	01010113          	addi	sp,sp,16
80000648:	00008067          	ret

8000064c <release>:
8000064c:	ff010113          	addi	sp,sp,-16
80000650:	00112623          	sw	ra,12(sp)
80000654:	00812423          	sw	s0,8(sp)
80000658:	01010413          	addi	s0,sp,16
8000065c:	0330000f          	fence	rw,rw
80000660:	0310000f          	fence	rw,w
80000664:	00052023          	sw	zero,0(a0)
80000668:	a1dff0ef          	jal	80000084 <enable_interrupts>
8000066c:	00c12083          	lw	ra,12(sp)
80000670:	00812403          	lw	s0,8(sp)
80000674:	01010113          	addi	sp,sp,16
80000678:	00008067          	ret

8000067c <current_task>:
8000067c:	ff010113          	addi	sp,sp,-16
80000680:	00112623          	sw	ra,12(sp)
80000684:	00812423          	sw	s0,8(sp)
80000688:	01010413          	addi	s0,sp,16
8000068c:	9e9ff0ef          	jal	80000074 <cpuid>
80000690:	00251513          	slli	a0,a0,0x2
80000694:	00000797          	auipc	a5,0x0
80000698:	71078793          	addi	a5,a5,1808 # 80000da4 <current_tasks>
8000069c:	00a787b3          	add	a5,a5,a0
800006a0:	0007a503          	lw	a0,0(a5)
800006a4:	00c12083          	lw	ra,12(sp)
800006a8:	00812403          	lw	s0,8(sp)
800006ac:	01010113          	addi	sp,sp,16
800006b0:	00008067          	ret

800006b4 <create_task>:
800006b4:	fe010113          	addi	sp,sp,-32
800006b8:	00112e23          	sw	ra,28(sp)
800006bc:	00812c23          	sw	s0,24(sp)
800006c0:	00912a23          	sw	s1,20(sp)
800006c4:	01212823          	sw	s2,16(sp)
800006c8:	01312623          	sw	s3,12(sp)
800006cc:	02010413          	addi	s0,sp,32
800006d0:	00050993          	mv	s3,a0
800006d4:	00058913          	mv	s2,a1
800006d8:	00008517          	auipc	a0,0x8
800006dc:	79050513          	addi	a0,a0,1936 # 80008e68 <tasks_lock>
800006e0:	f29ff0ef          	jal	80000608 <acquire>
800006e4:	00000717          	auipc	a4,0x0
800006e8:	6e070713          	addi	a4,a4,1760 # 80000dc4 <tasks>
800006ec:	00000793          	li	a5,0
800006f0:	00001637          	lui	a2,0x1
800006f4:	01460613          	addi	a2,a2,20 # 1014 <boot-0x7fffefec>
800006f8:	00800813          	li	a6,8
800006fc:	00472683          	lw	a3,4(a4)
80000700:	02068663          	beqz	a3,8000072c <create_task+0x78>
80000704:	00178793          	addi	a5,a5,1
80000708:	00c70733          	add	a4,a4,a2
8000070c:	ff0798e3          	bne	a5,a6,800006fc <create_task+0x48>
80000710:	02800613          	li	a2,40
80000714:	00000597          	auipc	a1,0x0
80000718:	28058593          	addi	a1,a1,640 # 80000994 <yield+0xf4>
8000071c:	00000517          	auipc	a0,0x0
80000720:	28050513          	addi	a0,a0,640 # 8000099c <yield+0xfc>
80000724:	b9dff0ef          	jal	800002c0 <printf>
80000728:	0000006f          	j	80000728 <create_task+0x74>
8000072c:	00001737          	lui	a4,0x1
80000730:	01470713          	addi	a4,a4,20 # 1014 <boot-0x7fffefec>
80000734:	02e787b3          	mul	a5,a5,a4
80000738:	00000717          	auipc	a4,0x0
8000073c:	68c70713          	addi	a4,a4,1676 # 80000dc4 <tasks>
80000740:	00e784b3          	add	s1,a5,a4
80000744:	000015b7          	lui	a1,0x1
80000748:	01058593          	addi	a1,a1,16 # 1010 <boot-0x7fffeff0>
8000074c:	00b485b3          	add	a1,s1,a1
80000750:	00098513          	mv	a0,s3
80000754:	9b5ff0ef          	jal	80000108 <init_context>
80000758:	00a4a623          	sw	a0,12(s1)
8000075c:	00008717          	auipc	a4,0x8
80000760:	70870713          	addi	a4,a4,1800 # 80008e64 <last_pid>
80000764:	00072783          	lw	a5,0(a4)
80000768:	00178793          	addi	a5,a5,1
8000076c:	00f72023          	sw	a5,0(a4)
80000770:	00f4a023          	sw	a5,0(s1)
80000774:	00100793          	li	a5,1
80000778:	00f4a223          	sw	a5,4(s1)
8000077c:	0124a423          	sw	s2,8(s1)
80000780:	00008517          	auipc	a0,0x8
80000784:	6e850513          	addi	a0,a0,1768 # 80008e68 <tasks_lock>
80000788:	ec5ff0ef          	jal	8000064c <release>
8000078c:	00048513          	mv	a0,s1
80000790:	01c12083          	lw	ra,28(sp)
80000794:	01812403          	lw	s0,24(sp)
80000798:	01412483          	lw	s1,20(sp)
8000079c:	01012903          	lw	s2,16(sp)
800007a0:	00c12983          	lw	s3,12(sp)
800007a4:	02010113          	addi	sp,sp,32
800007a8:	00008067          	ret

800007ac <scheduler>:
800007ac:	fd010113          	addi	sp,sp,-48
800007b0:	02112623          	sw	ra,44(sp)
800007b4:	02812423          	sw	s0,40(sp)
800007b8:	02912223          	sw	s1,36(sp)
800007bc:	03212023          	sw	s2,32(sp)
800007c0:	01312e23          	sw	s3,28(sp)
800007c4:	01412c23          	sw	s4,24(sp)
800007c8:	01512a23          	sw	s5,20(sp)
800007cc:	01612823          	sw	s6,16(sp)
800007d0:	01712623          	sw	s7,12(sp)
800007d4:	01812423          	sw	s8,8(sp)
800007d8:	03010413          	addi	s0,sp,48
800007dc:	899ff0ef          	jal	80000074 <cpuid>
800007e0:	00251713          	slli	a4,a0,0x2
800007e4:	00000c17          	auipc	s8,0x0
800007e8:	5d0c0c13          	addi	s8,s8,1488 # 80000db4 <scheduler_sp>
800007ec:	00ec0c33          	add	s8,s8,a4
800007f0:	00000b97          	auipc	s7,0x0
800007f4:	5b4b8b93          	addi	s7,s7,1460 # 80000da4 <current_tasks>
800007f8:	00eb8bb3          	add	s7,s7,a4
800007fc:	00008b17          	auipc	s6,0x8
80000800:	668b0b13          	addi	s6,s6,1640 # 80008e64 <last_pid>
80000804:	00008917          	auipc	s2,0x8
80000808:	66490913          	addi	s2,s2,1636 # 80008e68 <tasks_lock>
8000080c:	00100a93          	li	s5,1
80000810:	00001a37          	lui	s4,0x1
80000814:	014a0a13          	addi	s4,s4,20 # 1014 <boot-0x7fffefec>
80000818:	06c0006f          	j	80000884 <scheduler+0xd8>
8000081c:	06098e63          	beqz	s3,80000898 <scheduler+0xec>
80000820:	0084a683          	lw	a3,8(s1)
80000824:	0089a783          	lw	a5,8(s3)
80000828:	00d7d463          	bge	a5,a3,80000830 <scheduler+0x84>
8000082c:	00048993          	mv	s3,s1
80000830:	00090513          	mv	a0,s2
80000834:	e19ff0ef          	jal	8000064c <release>
80000838:	014484b3          	add	s1,s1,s4
8000083c:	03648463          	beq	s1,s6,80000864 <scheduler+0xb8>
80000840:	00090513          	mv	a0,s2
80000844:	dc5ff0ef          	jal	80000608 <acquire>
80000848:	0044a783          	lw	a5,4(s1)
8000084c:	fd5788e3          	beq	a5,s5,8000081c <scheduler+0x70>
80000850:	00090513          	mv	a0,s2
80000854:	df9ff0ef          	jal	8000064c <release>
80000858:	014484b3          	add	s1,s1,s4
8000085c:	ff6492e3          	bne	s1,s6,80000840 <scheduler+0x94>
80000860:	02098263          	beqz	s3,80000884 <scheduler+0xd8>
80000864:	00200793          	li	a5,2
80000868:	00f9a223          	sw	a5,4(s3)
8000086c:	013ba023          	sw	s3,0(s7)
80000870:	00090513          	mv	a0,s2
80000874:	dd9ff0ef          	jal	8000064c <release>
80000878:	00c98593          	addi	a1,s3,12
8000087c:	000c0513          	mv	a0,s8
80000880:	80dff0ef          	jal	8000008c <context_switch>
80000884:	000ba023          	sw	zero,0(s7)
80000888:	00000497          	auipc	s1,0x0
8000088c:	53c48493          	addi	s1,s1,1340 # 80000dc4 <tasks>
80000890:	00000993          	li	s3,0
80000894:	fadff06f          	j	80000840 <scheduler+0x94>
80000898:	00048993          	mv	s3,s1
8000089c:	f95ff06f          	j	80000830 <scheduler+0x84>

800008a0 <yield>:
800008a0:	ff010113          	addi	sp,sp,-16
800008a4:	00112623          	sw	ra,12(sp)
800008a8:	00812423          	sw	s0,8(sp)
800008ac:	01010413          	addi	s0,sp,16
800008b0:	fc4ff0ef          	jal	80000074 <cpuid>
800008b4:	00251713          	slli	a4,a0,0x2
800008b8:	00000797          	auipc	a5,0x0
800008bc:	4ec78793          	addi	a5,a5,1260 # 80000da4 <current_tasks>
800008c0:	00e787b3          	add	a5,a5,a4
800008c4:	0007a783          	lw	a5,0(a5)
800008c8:	02078a63          	beqz	a5,800008fc <yield+0x5c>
800008cc:	00100713          	li	a4,1
800008d0:	00e7a223          	sw	a4,4(a5)
800008d4:	00251593          	slli	a1,a0,0x2
800008d8:	00000717          	auipc	a4,0x0
800008dc:	4dc70713          	addi	a4,a4,1244 # 80000db4 <scheduler_sp>
800008e0:	00b705b3          	add	a1,a4,a1
800008e4:	00c78513          	addi	a0,a5,12
800008e8:	fa4ff0ef          	jal	8000008c <context_switch>
800008ec:	00c12083          	lw	ra,12(sp)
800008f0:	00812403          	lw	s0,8(sp)
800008f4:	01010113          	addi	sp,sp,16
800008f8:	00008067          	ret
800008fc:	05600613          	li	a2,86
80000900:	00000597          	auipc	a1,0x0
80000904:	09458593          	addi	a1,a1,148 # 80000994 <yield+0xf4>
80000908:	00000517          	auipc	a0,0x0
8000090c:	0b850513          	addi	a0,a0,184 # 800009c0 <yield+0x120>
80000910:	9b1ff0ef          	jal	800002c0 <printf>
80000914:	0000006f          	j	80000914 <yield+0x74>
