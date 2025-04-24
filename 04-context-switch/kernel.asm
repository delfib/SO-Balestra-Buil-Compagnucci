
kernel:     file format elf32-littleriscv


Disassembly of section .text:

80000000 <boot>:
80000000:	f1402273          	csrr	tp,mhartid
80000004:	00003117          	auipc	sp,0x3
80000008:	ad010113          	addi	sp,sp,-1328 # 80002ad4 <__bss_end>
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
80000040:	7ffe0e13          	addi	t3,t3,2047 # ffffe7ff <__kernel_end+0x7ffdbd2b>
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
80000070:	25c000ef          	jal	800002cc <kernel_main>

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

80000108 <init_task_context>:
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

800001d0 <task_a>:
800001d0:	ff010113          	addi	sp,sp,-16
800001d4:	00112623          	sw	ra,12(sp)
800001d8:	00812423          	sw	s0,8(sp)
800001dc:	01010413          	addi	s0,sp,16
800001e0:	e95ff0ef          	jal	80000074 <cpuid>
800001e4:	00050593          	mv	a1,a0
800001e8:	00000517          	auipc	a0,0x0
800001ec:	50c50513          	addi	a0,a0,1292 # 800006f4 <release+0x30>
800001f0:	28c000ef          	jal	8000047c <printf>
800001f4:	00003597          	auipc	a1,0x3
800001f8:	8d858593          	addi	a1,a1,-1832 # 80002acc <task_b_sp>
800001fc:	00003517          	auipc	a0,0x3
80000200:	8d450513          	addi	a0,a0,-1836 # 80002ad0 <task_a_sp>
80000204:	e89ff0ef          	jal	8000008c <context_switch>
80000208:	e6dff0ef          	jal	80000074 <cpuid>
8000020c:	00050593          	mv	a1,a0
80000210:	00000517          	auipc	a0,0x0
80000214:	4f850513          	addi	a0,a0,1272 # 80000708 <release+0x44>
80000218:	264000ef          	jal	8000047c <printf>
8000021c:	00003597          	auipc	a1,0x3
80000220:	8ac58593          	addi	a1,a1,-1876 # 80002ac8 <main_thread_sp>
80000224:	00003517          	auipc	a0,0x3
80000228:	8ac50513          	addi	a0,a0,-1876 # 80002ad0 <task_a_sp>
8000022c:	e61ff0ef          	jal	8000008c <context_switch>
80000230:	00c12083          	lw	ra,12(sp)
80000234:	00812403          	lw	s0,8(sp)
80000238:	01010113          	addi	sp,sp,16
8000023c:	00008067          	ret

80000240 <task_b>:
80000240:	ff010113          	addi	sp,sp,-16
80000244:	00112623          	sw	ra,12(sp)
80000248:	00812423          	sw	s0,8(sp)
8000024c:	01010413          	addi	s0,sp,16
80000250:	e25ff0ef          	jal	80000074 <cpuid>
80000254:	00050593          	mv	a1,a0
80000258:	00000517          	auipc	a0,0x0
8000025c:	4cc50513          	addi	a0,a0,1228 # 80000724 <release+0x60>
80000260:	21c000ef          	jal	8000047c <printf>
80000264:	00003597          	auipc	a1,0x3
80000268:	86c58593          	addi	a1,a1,-1940 # 80002ad0 <task_a_sp>
8000026c:	00003517          	auipc	a0,0x3
80000270:	86050513          	addi	a0,a0,-1952 # 80002acc <task_b_sp>
80000274:	e19ff0ef          	jal	8000008c <context_switch>
80000278:	dfdff0ef          	jal	80000074 <cpuid>
8000027c:	00050593          	mv	a1,a0
80000280:	00000517          	auipc	a0,0x0
80000284:	4b850513          	addi	a0,a0,1208 # 80000738 <release+0x74>
80000288:	1f4000ef          	jal	8000047c <printf>
8000028c:	02f00613          	li	a2,47
80000290:	00000597          	auipc	a1,0x0
80000294:	4c458593          	addi	a1,a1,1220 # 80000754 <release+0x90>
80000298:	00000517          	auipc	a0,0x0
8000029c:	4c850513          	addi	a0,a0,1224 # 80000760 <release+0x9c>
800002a0:	1dc000ef          	jal	8000047c <printf>
800002a4:	0000006f          	j	800002a4 <task_b+0x64>

800002a8 <create_task>:
800002a8:	ff010113          	addi	sp,sp,-16
800002ac:	00112623          	sw	ra,12(sp)
800002b0:	00812423          	sw	s0,8(sp)
800002b4:	01010413          	addi	s0,sp,16
800002b8:	e51ff0ef          	jal	80000108 <init_task_context>
800002bc:	00c12083          	lw	ra,12(sp)
800002c0:	00812403          	lw	s0,8(sp)
800002c4:	01010113          	addi	sp,sp,16
800002c8:	00008067          	ret

800002cc <kernel_main>:
800002cc:	ff010113          	addi	sp,sp,-16
800002d0:	00112623          	sw	ra,12(sp)
800002d4:	00812423          	sw	s0,8(sp)
800002d8:	01010413          	addi	s0,sp,16
800002dc:	d99ff0ef          	jal	80000074 <cpuid>
800002e0:	02050063          	beqz	a0,80000300 <kernel_main+0x34>
800002e4:	04400613          	li	a2,68
800002e8:	00000597          	auipc	a1,0x0
800002ec:	46c58593          	addi	a1,a1,1132 # 80000754 <release+0x90>
800002f0:	00000517          	auipc	a0,0x0
800002f4:	47050513          	addi	a0,a0,1136 # 80000760 <release+0x9c>
800002f8:	184000ef          	jal	8000047c <printf>
800002fc:	0000006f          	j	800002fc <kernel_main+0x30>
80000300:	00912223          	sw	s1,4(sp)
80000304:	01212023          	sw	s2,0(sp)
80000308:	00002597          	auipc	a1,0x2
8000030c:	7c058593          	addi	a1,a1,1984 # 80002ac8 <main_thread_sp>
80000310:	00000517          	auipc	a0,0x0
80000314:	ec050513          	addi	a0,a0,-320 # 800001d0 <task_a>
80000318:	df1ff0ef          	jal	80000108 <init_task_context>
8000031c:	00002917          	auipc	s2,0x2
80000320:	7b490913          	addi	s2,s2,1972 # 80002ad0 <task_a_sp>
80000324:	00a92023          	sw	a0,0(s2)
80000328:	00001597          	auipc	a1,0x1
8000032c:	7a058593          	addi	a1,a1,1952 # 80001ac8 <stack_task_a>
80000330:	00000517          	auipc	a0,0x0
80000334:	f1050513          	addi	a0,a0,-240 # 80000240 <task_b>
80000338:	dd1ff0ef          	jal	80000108 <init_task_context>
8000033c:	00002497          	auipc	s1,0x2
80000340:	79048493          	addi	s1,s1,1936 # 80002acc <task_b_sp>
80000344:	00a4a023          	sw	a0,0(s1)
80000348:	00000517          	auipc	a0,0x0
8000034c:	43450513          	addi	a0,a0,1076 # 8000077c <release+0xb8>
80000350:	12c000ef          	jal	8000047c <printf>
80000354:	00090593          	mv	a1,s2
80000358:	00002517          	auipc	a0,0x2
8000035c:	77050513          	addi	a0,a0,1904 # 80002ac8 <main_thread_sp>
80000360:	d2dff0ef          	jal	8000008c <context_switch>
80000364:	00000517          	auipc	a0,0x0
80000368:	43450513          	addi	a0,a0,1076 # 80000798 <release+0xd4>
8000036c:	110000ef          	jal	8000047c <printf>
80000370:	00048593          	mv	a1,s1
80000374:	00002517          	auipc	a0,0x2
80000378:	75450513          	addi	a0,a0,1876 # 80002ac8 <main_thread_sp>
8000037c:	d11ff0ef          	jal	8000008c <context_switch>
80000380:	00412483          	lw	s1,4(sp)
80000384:	00012903          	lw	s2,0(sp)
80000388:	f5dff06f          	j	800002e4 <kernel_main+0x18>

8000038c <memset>:
8000038c:	ff010113          	addi	sp,sp,-16
80000390:	00812623          	sw	s0,12(sp)
80000394:	01010413          	addi	s0,sp,16
80000398:	00060c63          	beqz	a2,800003b0 <memset+0x24>
8000039c:	00c50633          	add	a2,a0,a2
800003a0:	00050793          	mv	a5,a0
800003a4:	00178793          	addi	a5,a5,1
800003a8:	feb78fa3          	sb	a1,-1(a5)
800003ac:	fef61ce3          	bne	a2,a5,800003a4 <memset+0x18>
800003b0:	00c12403          	lw	s0,12(sp)
800003b4:	01010113          	addi	sp,sp,16
800003b8:	00008067          	ret

800003bc <memcpy>:
800003bc:	ff010113          	addi	sp,sp,-16
800003c0:	00812623          	sw	s0,12(sp)
800003c4:	01010413          	addi	s0,sp,16
800003c8:	02060063          	beqz	a2,800003e8 <memcpy+0x2c>
800003cc:	00c50633          	add	a2,a0,a2
800003d0:	00050793          	mv	a5,a0
800003d4:	00158593          	addi	a1,a1,1
800003d8:	00178793          	addi	a5,a5,1
800003dc:	fff5c703          	lbu	a4,-1(a1)
800003e0:	fee78fa3          	sb	a4,-1(a5)
800003e4:	fef618e3          	bne	a2,a5,800003d4 <memcpy+0x18>
800003e8:	00c12403          	lw	s0,12(sp)
800003ec:	01010113          	addi	sp,sp,16
800003f0:	00008067          	ret

800003f4 <strcpy>:
800003f4:	ff010113          	addi	sp,sp,-16
800003f8:	00812623          	sw	s0,12(sp)
800003fc:	01010413          	addi	s0,sp,16
80000400:	0005c783          	lbu	a5,0(a1)
80000404:	02078663          	beqz	a5,80000430 <strcpy+0x3c>
80000408:	00050713          	mv	a4,a0
8000040c:	00158593          	addi	a1,a1,1
80000410:	00170713          	addi	a4,a4,1
80000414:	fef70fa3          	sb	a5,-1(a4)
80000418:	0005c783          	lbu	a5,0(a1)
8000041c:	fe0798e3          	bnez	a5,8000040c <strcpy+0x18>
80000420:	00070023          	sb	zero,0(a4)
80000424:	00c12403          	lw	s0,12(sp)
80000428:	01010113          	addi	sp,sp,16
8000042c:	00008067          	ret
80000430:	00050713          	mv	a4,a0
80000434:	fedff06f          	j	80000420 <strcpy+0x2c>

80000438 <strcmp>:
80000438:	ff010113          	addi	sp,sp,-16
8000043c:	00812623          	sw	s0,12(sp)
80000440:	01010413          	addi	s0,sp,16
80000444:	00054783          	lbu	a5,0(a0)
80000448:	02078063          	beqz	a5,80000468 <strcmp+0x30>
8000044c:	0005c703          	lbu	a4,0(a1)
80000450:	00070c63          	beqz	a4,80000468 <strcmp+0x30>
80000454:	00f71a63          	bne	a4,a5,80000468 <strcmp+0x30>
80000458:	00150513          	addi	a0,a0,1
8000045c:	00158593          	addi	a1,a1,1
80000460:	00054783          	lbu	a5,0(a0)
80000464:	fe0794e3          	bnez	a5,8000044c <strcmp+0x14>
80000468:	0005c503          	lbu	a0,0(a1)
8000046c:	40a78533          	sub	a0,a5,a0
80000470:	00c12403          	lw	s0,12(sp)
80000474:	01010113          	addi	sp,sp,16
80000478:	00008067          	ret

8000047c <printf>:
8000047c:	fa010113          	addi	sp,sp,-96
80000480:	02112e23          	sw	ra,60(sp)
80000484:	02812c23          	sw	s0,56(sp)
80000488:	02912a23          	sw	s1,52(sp)
8000048c:	04010413          	addi	s0,sp,64
80000490:	00050493          	mv	s1,a0
80000494:	00b42223          	sw	a1,4(s0)
80000498:	00c42423          	sw	a2,8(s0)
8000049c:	00d42623          	sw	a3,12(s0)
800004a0:	00e42823          	sw	a4,16(s0)
800004a4:	00f42a23          	sw	a5,20(s0)
800004a8:	01042c23          	sw	a6,24(s0)
800004ac:	01142e23          	sw	a7,28(s0)
800004b0:	00440793          	addi	a5,s0,4
800004b4:	fcf42623          	sw	a5,-52(s0)
800004b8:	00054503          	lbu	a0,0(a0)
800004bc:	06050663          	beqz	a0,80000528 <printf+0xac>
800004c0:	03212823          	sw	s2,48(sp)
800004c4:	03312623          	sw	s3,44(sp)
800004c8:	03412423          	sw	s4,40(sp)
800004cc:	03512223          	sw	s5,36(sp)
800004d0:	03612023          	sw	s6,32(sp)
800004d4:	01712e23          	sw	s7,28(sp)
800004d8:	01812c23          	sw	s8,24(sp)
800004dc:	02500993          	li	s3,37
800004e0:	06400a13          	li	s4,100
800004e4:	07300a93          	li	s5,115
800004e8:	1180006f          	j	80000600 <printf+0x184>
800004ec:	00078c63          	beqz	a5,80000504 <printf+0x88>
800004f0:	02500713          	li	a4,37
800004f4:	10e79063          	bne	a5,a4,800005f4 <printf+0x178>
800004f8:	02500513          	li	a0,37
800004fc:	c5dff0ef          	jal	80000158 <console_putc>
80000500:	0f40006f          	j	800005f4 <printf+0x178>
80000504:	02500513          	li	a0,37
80000508:	c51ff0ef          	jal	80000158 <console_putc>
8000050c:	03012903          	lw	s2,48(sp)
80000510:	02c12983          	lw	s3,44(sp)
80000514:	02812a03          	lw	s4,40(sp)
80000518:	02412a83          	lw	s5,36(sp)
8000051c:	02012b03          	lw	s6,32(sp)
80000520:	01c12b83          	lw	s7,28(sp)
80000524:	01812c03          	lw	s8,24(sp)
80000528:	03c12083          	lw	ra,60(sp)
8000052c:	03812403          	lw	s0,56(sp)
80000530:	03412483          	lw	s1,52(sp)
80000534:	06010113          	addi	sp,sp,96
80000538:	00008067          	ret
8000053c:	fcc42783          	lw	a5,-52(s0)
80000540:	00478713          	addi	a4,a5,4
80000544:	fce42623          	sw	a4,-52(s0)
80000548:	0007a483          	lw	s1,0(a5)
8000054c:	0004c503          	lbu	a0,0(s1)
80000550:	0a050263          	beqz	a0,800005f4 <printf+0x178>
80000554:	c05ff0ef          	jal	80000158 <console_putc>
80000558:	00148493          	addi	s1,s1,1
8000055c:	0004c503          	lbu	a0,0(s1)
80000560:	fe051ae3          	bnez	a0,80000554 <printf+0xd8>
80000564:	0900006f          	j	800005f4 <printf+0x178>
80000568:	fcc42783          	lw	a5,-52(s0)
8000056c:	00478713          	addi	a4,a5,4
80000570:	fce42623          	sw	a4,-52(s0)
80000574:	0007ab03          	lw	s6,0(a5)
80000578:	040b4e63          	bltz	s6,800005d4 <printf+0x158>
8000057c:	00900793          	li	a5,9
80000580:	0767d263          	bge	a5,s6,800005e4 <printf+0x168>
80000584:	00100493          	li	s1,1
80000588:	00900713          	li	a4,9
8000058c:	00249793          	slli	a5,s1,0x2
80000590:	009787b3          	add	a5,a5,s1
80000594:	00179793          	slli	a5,a5,0x1
80000598:	00078493          	mv	s1,a5
8000059c:	02fb47b3          	div	a5,s6,a5
800005a0:	fef746e3          	blt	a4,a5,8000058c <printf+0x110>
800005a4:	04905863          	blez	s1,800005f4 <printf+0x178>
800005a8:	00a00c13          	li	s8,10
800005ac:	00900b93          	li	s7,9
800005b0:	029b4533          	div	a0,s6,s1
800005b4:	03050513          	addi	a0,a0,48
800005b8:	0ff57513          	zext.b	a0,a0
800005bc:	b9dff0ef          	jal	80000158 <console_putc>
800005c0:	029b6b33          	rem	s6,s6,s1
800005c4:	00048793          	mv	a5,s1
800005c8:	0384c4b3          	div	s1,s1,s8
800005cc:	fefbc2e3          	blt	s7,a5,800005b0 <printf+0x134>
800005d0:	0240006f          	j	800005f4 <printf+0x178>
800005d4:	02d00513          	li	a0,45
800005d8:	b81ff0ef          	jal	80000158 <console_putc>
800005dc:	41600b33          	neg	s6,s6
800005e0:	f9dff06f          	j	8000057c <printf+0x100>
800005e4:	00100493          	li	s1,1
800005e8:	fc1ff06f          	j	800005a8 <printf+0x12c>
800005ec:	b6dff0ef          	jal	80000158 <console_putc>
800005f0:	00048913          	mv	s2,s1
800005f4:	00190493          	addi	s1,s2,1
800005f8:	00194503          	lbu	a0,1(s2)
800005fc:	06050263          	beqz	a0,80000660 <printf+0x1e4>
80000600:	ff3516e3          	bne	a0,s3,800005ec <printf+0x170>
80000604:	00148913          	addi	s2,s1,1
80000608:	0014c783          	lbu	a5,1(s1)
8000060c:	f5478ee3          	beq	a5,s4,80000568 <printf+0xec>
80000610:	ecfa7ee3          	bgeu	s4,a5,800004ec <printf+0x70>
80000614:	f35784e3          	beq	a5,s5,8000053c <printf+0xc0>
80000618:	07800713          	li	a4,120
8000061c:	fce79ce3          	bne	a5,a4,800005f4 <printf+0x178>
80000620:	fcc42783          	lw	a5,-52(s0)
80000624:	00478713          	addi	a4,a5,4
80000628:	fce42623          	sw	a4,-52(s0)
8000062c:	0007ac03          	lw	s8,0(a5)
80000630:	01c00493          	li	s1,28
80000634:	00000b97          	auipc	s7,0x0
80000638:	188b8b93          	addi	s7,s7,392 # 800007bc <release+0xf8>
8000063c:	ffc00b13          	li	s6,-4
80000640:	409c57b3          	sra	a5,s8,s1
80000644:	00f7f793          	andi	a5,a5,15
80000648:	00fb87b3          	add	a5,s7,a5
8000064c:	0007c503          	lbu	a0,0(a5)
80000650:	b09ff0ef          	jal	80000158 <console_putc>
80000654:	ffc48493          	addi	s1,s1,-4
80000658:	ff6494e3          	bne	s1,s6,80000640 <printf+0x1c4>
8000065c:	f99ff06f          	j	800005f4 <printf+0x178>
80000660:	03012903          	lw	s2,48(sp)
80000664:	02c12983          	lw	s3,44(sp)
80000668:	02812a03          	lw	s4,40(sp)
8000066c:	02412a83          	lw	s5,36(sp)
80000670:	02012b03          	lw	s6,32(sp)
80000674:	01c12b83          	lw	s7,28(sp)
80000678:	01812c03          	lw	s8,24(sp)
8000067c:	eadff06f          	j	80000528 <printf+0xac>

80000680 <acquire>:
80000680:	ff010113          	addi	sp,sp,-16
80000684:	00112623          	sw	ra,12(sp)
80000688:	00812423          	sw	s0,8(sp)
8000068c:	00912223          	sw	s1,4(sp)
80000690:	01010413          	addi	s0,sp,16
80000694:	00050493          	mv	s1,a0
80000698:	9e5ff0ef          	jal	8000007c <disable_interrupts>
8000069c:	00100713          	li	a4,1
800006a0:	00070793          	mv	a5,a4
800006a4:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
800006a8:	fe079ce3          	bnez	a5,800006a0 <acquire+0x20>
800006ac:	0330000f          	fence	rw,rw
800006b0:	00c12083          	lw	ra,12(sp)
800006b4:	00812403          	lw	s0,8(sp)
800006b8:	00412483          	lw	s1,4(sp)
800006bc:	01010113          	addi	sp,sp,16
800006c0:	00008067          	ret

800006c4 <release>:
800006c4:	ff010113          	addi	sp,sp,-16
800006c8:	00112623          	sw	ra,12(sp)
800006cc:	00812423          	sw	s0,8(sp)
800006d0:	01010413          	addi	s0,sp,16
800006d4:	0330000f          	fence	rw,rw
800006d8:	0310000f          	fence	rw,w
800006dc:	00052023          	sw	zero,0(a0)
800006e0:	9a5ff0ef          	jal	80000084 <enable_interrupts>
800006e4:	00c12083          	lw	ra,12(sp)
800006e8:	00812403          	lw	s0,8(sp)
800006ec:	01010113          	addi	sp,sp,16
800006f0:	00008067          	ret
