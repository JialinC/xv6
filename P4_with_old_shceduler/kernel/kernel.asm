
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	80010113          	addi	sp,sp,-2048 # 80009800 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <junk>:
    8000001a:	a001                	j	8000001a <junk>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00009617          	auipc	a2,0x9
    8000004e:	fb660613          	addi	a2,a2,-74 # 80009000 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	d6478793          	addi	a5,a5,-668 # 80005dc0 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000074:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87e3>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	c7a78793          	addi	a5,a5,-902 # 80000d20 <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c0:	30379073          	csrw	mideleg,a5
  timerinit();
    800000c4:	00000097          	auipc	ra,0x0
    800000c8:	f58080e7          	jalr	-168(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000cc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000d0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000d2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000d4:	30200073          	mret
}
    800000d8:	60a2                	ld	ra,8(sp)
    800000da:	6402                	ld	s0,0(sp)
    800000dc:	0141                	addi	sp,sp,16
    800000de:	8082                	ret

00000000800000e0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800000e0:	7119                	addi	sp,sp,-128
    800000e2:	fc86                	sd	ra,120(sp)
    800000e4:	f8a2                	sd	s0,112(sp)
    800000e6:	f4a6                	sd	s1,104(sp)
    800000e8:	f0ca                	sd	s2,96(sp)
    800000ea:	ecce                	sd	s3,88(sp)
    800000ec:	e8d2                	sd	s4,80(sp)
    800000ee:	e4d6                	sd	s5,72(sp)
    800000f0:	e0da                	sd	s6,64(sp)
    800000f2:	fc5e                	sd	s7,56(sp)
    800000f4:	f862                	sd	s8,48(sp)
    800000f6:	f466                	sd	s9,40(sp)
    800000f8:	f06a                	sd	s10,32(sp)
    800000fa:	ec6e                	sd	s11,24(sp)
    800000fc:	0100                	addi	s0,sp,128
    800000fe:	8b2a                	mv	s6,a0
    80000100:	8aae                	mv	s5,a1
    80000102:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000104:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80000108:	00011517          	auipc	a0,0x11
    8000010c:	6f850513          	addi	a0,a0,1784 # 80011800 <cons>
    80000110:	00001097          	auipc	ra,0x1
    80000114:	9c2080e7          	jalr	-1598(ra) # 80000ad2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000118:	00011497          	auipc	s1,0x11
    8000011c:	6e848493          	addi	s1,s1,1768 # 80011800 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000120:	89a6                	mv	s3,s1
    80000122:	00011917          	auipc	s2,0x11
    80000126:	77690913          	addi	s2,s2,1910 # 80011898 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    8000012a:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000012c:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000012e:	4da9                	li	s11,10
  while(n > 0){
    80000130:	07405863          	blez	s4,800001a0 <consoleread+0xc0>
    while(cons.r == cons.w){
    80000134:	0984a783          	lw	a5,152(s1)
    80000138:	09c4a703          	lw	a4,156(s1)
    8000013c:	02f71463          	bne	a4,a5,80000164 <consoleread+0x84>
      if(myproc()->killed){
    80000140:	00001097          	auipc	ra,0x1
    80000144:	704080e7          	jalr	1796(ra) # 80001844 <myproc>
    80000148:	591c                	lw	a5,48(a0)
    8000014a:	e7b5                	bnez	a5,800001b6 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000014c:	85ce                	mv	a1,s3
    8000014e:	854a                	mv	a0,s2
    80000150:	00002097          	auipc	ra,0x2
    80000154:	172080e7          	jalr	370(ra) # 800022c2 <sleep>
    while(cons.r == cons.w){
    80000158:	0984a783          	lw	a5,152(s1)
    8000015c:	09c4a703          	lw	a4,156(s1)
    80000160:	fef700e3          	beq	a4,a5,80000140 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80000164:	0017871b          	addiw	a4,a5,1
    80000168:	08e4ac23          	sw	a4,152(s1)
    8000016c:	07f7f713          	andi	a4,a5,127
    80000170:	9726                	add	a4,a4,s1
    80000172:	01874703          	lbu	a4,24(a4)
    80000176:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    8000017a:	079c0663          	beq	s8,s9,800001e6 <consoleread+0x106>
    cbuf = c;
    8000017e:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000182:	4685                	li	a3,1
    80000184:	f8f40613          	addi	a2,s0,-113
    80000188:	85d6                	mv	a1,s5
    8000018a:	855a                	mv	a0,s6
    8000018c:	00002097          	auipc	ra,0x2
    80000190:	4da080e7          	jalr	1242(ra) # 80002666 <either_copyout>
    80000194:	01a50663          	beq	a0,s10,800001a0 <consoleread+0xc0>
    dst++;
    80000198:	0a85                	addi	s5,s5,1
    --n;
    8000019a:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000019c:	f9bc1ae3          	bne	s8,s11,80000130 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800001a0:	00011517          	auipc	a0,0x11
    800001a4:	66050513          	addi	a0,a0,1632 # 80011800 <cons>
    800001a8:	00001097          	auipc	ra,0x1
    800001ac:	97e080e7          	jalr	-1666(ra) # 80000b26 <release>

  return target - n;
    800001b0:	414b853b          	subw	a0,s7,s4
    800001b4:	a811                	j	800001c8 <consoleread+0xe8>
        release(&cons.lock);
    800001b6:	00011517          	auipc	a0,0x11
    800001ba:	64a50513          	addi	a0,a0,1610 # 80011800 <cons>
    800001be:	00001097          	auipc	ra,0x1
    800001c2:	968080e7          	jalr	-1688(ra) # 80000b26 <release>
        return -1;
    800001c6:	557d                	li	a0,-1
}
    800001c8:	70e6                	ld	ra,120(sp)
    800001ca:	7446                	ld	s0,112(sp)
    800001cc:	74a6                	ld	s1,104(sp)
    800001ce:	7906                	ld	s2,96(sp)
    800001d0:	69e6                	ld	s3,88(sp)
    800001d2:	6a46                	ld	s4,80(sp)
    800001d4:	6aa6                	ld	s5,72(sp)
    800001d6:	6b06                	ld	s6,64(sp)
    800001d8:	7be2                	ld	s7,56(sp)
    800001da:	7c42                	ld	s8,48(sp)
    800001dc:	7ca2                	ld	s9,40(sp)
    800001de:	7d02                	ld	s10,32(sp)
    800001e0:	6de2                	ld	s11,24(sp)
    800001e2:	6109                	addi	sp,sp,128
    800001e4:	8082                	ret
      if(n < target){
    800001e6:	000a071b          	sext.w	a4,s4
    800001ea:	fb777be3          	bgeu	a4,s7,800001a0 <consoleread+0xc0>
        cons.r--;
    800001ee:	00011717          	auipc	a4,0x11
    800001f2:	6af72523          	sw	a5,1706(a4) # 80011898 <cons+0x98>
    800001f6:	b76d                	j	800001a0 <consoleread+0xc0>

00000000800001f8 <consputc>:
  if(panicked){
    800001f8:	00026797          	auipc	a5,0x26
    800001fc:	e087a783          	lw	a5,-504(a5) # 80026000 <panicked>
    80000200:	c391                	beqz	a5,80000204 <consputc+0xc>
    for(;;)
    80000202:	a001                	j	80000202 <consputc+0xa>
{
    80000204:	1141                	addi	sp,sp,-16
    80000206:	e406                	sd	ra,8(sp)
    80000208:	e022                	sd	s0,0(sp)
    8000020a:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000020c:	10000793          	li	a5,256
    80000210:	00f50a63          	beq	a0,a5,80000224 <consputc+0x2c>
    uartputc(c);
    80000214:	00000097          	auipc	ra,0x0
    80000218:	5d2080e7          	jalr	1490(ra) # 800007e6 <uartputc>
}
    8000021c:	60a2                	ld	ra,8(sp)
    8000021e:	6402                	ld	s0,0(sp)
    80000220:	0141                	addi	sp,sp,16
    80000222:	8082                	ret
    uartputc('\b'); uartputc(' '); uartputc('\b');
    80000224:	4521                	li	a0,8
    80000226:	00000097          	auipc	ra,0x0
    8000022a:	5c0080e7          	jalr	1472(ra) # 800007e6 <uartputc>
    8000022e:	02000513          	li	a0,32
    80000232:	00000097          	auipc	ra,0x0
    80000236:	5b4080e7          	jalr	1460(ra) # 800007e6 <uartputc>
    8000023a:	4521                	li	a0,8
    8000023c:	00000097          	auipc	ra,0x0
    80000240:	5aa080e7          	jalr	1450(ra) # 800007e6 <uartputc>
    80000244:	bfe1                	j	8000021c <consputc+0x24>

0000000080000246 <consolewrite>:
{
    80000246:	715d                	addi	sp,sp,-80
    80000248:	e486                	sd	ra,72(sp)
    8000024a:	e0a2                	sd	s0,64(sp)
    8000024c:	fc26                	sd	s1,56(sp)
    8000024e:	f84a                	sd	s2,48(sp)
    80000250:	f44e                	sd	s3,40(sp)
    80000252:	f052                	sd	s4,32(sp)
    80000254:	ec56                	sd	s5,24(sp)
    80000256:	0880                	addi	s0,sp,80
    80000258:	89aa                	mv	s3,a0
    8000025a:	84ae                	mv	s1,a1
    8000025c:	8ab2                	mv	s5,a2
  acquire(&cons.lock);
    8000025e:	00011517          	auipc	a0,0x11
    80000262:	5a250513          	addi	a0,a0,1442 # 80011800 <cons>
    80000266:	00001097          	auipc	ra,0x1
    8000026a:	86c080e7          	jalr	-1940(ra) # 80000ad2 <acquire>
  for(i = 0; i < n; i++){
    8000026e:	03505e63          	blez	s5,800002aa <consolewrite+0x64>
    80000272:	00148913          	addi	s2,s1,1
    80000276:	fffa879b          	addiw	a5,s5,-1
    8000027a:	1782                	slli	a5,a5,0x20
    8000027c:	9381                	srli	a5,a5,0x20
    8000027e:	993e                	add	s2,s2,a5
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000280:	5a7d                	li	s4,-1
    80000282:	4685                	li	a3,1
    80000284:	8626                	mv	a2,s1
    80000286:	85ce                	mv	a1,s3
    80000288:	fbf40513          	addi	a0,s0,-65
    8000028c:	00002097          	auipc	ra,0x2
    80000290:	430080e7          	jalr	1072(ra) # 800026bc <either_copyin>
    80000294:	01450b63          	beq	a0,s4,800002aa <consolewrite+0x64>
    consputc(c);
    80000298:	fbf44503          	lbu	a0,-65(s0)
    8000029c:	00000097          	auipc	ra,0x0
    800002a0:	f5c080e7          	jalr	-164(ra) # 800001f8 <consputc>
  for(i = 0; i < n; i++){
    800002a4:	0485                	addi	s1,s1,1
    800002a6:	fd249ee3          	bne	s1,s2,80000282 <consolewrite+0x3c>
  release(&cons.lock);
    800002aa:	00011517          	auipc	a0,0x11
    800002ae:	55650513          	addi	a0,a0,1366 # 80011800 <cons>
    800002b2:	00001097          	auipc	ra,0x1
    800002b6:	874080e7          	jalr	-1932(ra) # 80000b26 <release>
}
    800002ba:	8556                	mv	a0,s5
    800002bc:	60a6                	ld	ra,72(sp)
    800002be:	6406                	ld	s0,64(sp)
    800002c0:	74e2                	ld	s1,56(sp)
    800002c2:	7942                	ld	s2,48(sp)
    800002c4:	79a2                	ld	s3,40(sp)
    800002c6:	7a02                	ld	s4,32(sp)
    800002c8:	6ae2                	ld	s5,24(sp)
    800002ca:	6161                	addi	sp,sp,80
    800002cc:	8082                	ret

00000000800002ce <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ce:	1101                	addi	sp,sp,-32
    800002d0:	ec06                	sd	ra,24(sp)
    800002d2:	e822                	sd	s0,16(sp)
    800002d4:	e426                	sd	s1,8(sp)
    800002d6:	e04a                	sd	s2,0(sp)
    800002d8:	1000                	addi	s0,sp,32
    800002da:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002dc:	00011517          	auipc	a0,0x11
    800002e0:	52450513          	addi	a0,a0,1316 # 80011800 <cons>
    800002e4:	00000097          	auipc	ra,0x0
    800002e8:	7ee080e7          	jalr	2030(ra) # 80000ad2 <acquire>

  switch(c){
    800002ec:	47d5                	li	a5,21
    800002ee:	0af48663          	beq	s1,a5,8000039a <consoleintr+0xcc>
    800002f2:	0297ca63          	blt	a5,s1,80000326 <consoleintr+0x58>
    800002f6:	47a1                	li	a5,8
    800002f8:	0ef48763          	beq	s1,a5,800003e6 <consoleintr+0x118>
    800002fc:	47c1                	li	a5,16
    800002fe:	10f49a63          	bne	s1,a5,80000412 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80000302:	00002097          	auipc	ra,0x2
    80000306:	410080e7          	jalr	1040(ra) # 80002712 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000030a:	00011517          	auipc	a0,0x11
    8000030e:	4f650513          	addi	a0,a0,1270 # 80011800 <cons>
    80000312:	00001097          	auipc	ra,0x1
    80000316:	814080e7          	jalr	-2028(ra) # 80000b26 <release>
}
    8000031a:	60e2                	ld	ra,24(sp)
    8000031c:	6442                	ld	s0,16(sp)
    8000031e:	64a2                	ld	s1,8(sp)
    80000320:	6902                	ld	s2,0(sp)
    80000322:	6105                	addi	sp,sp,32
    80000324:	8082                	ret
  switch(c){
    80000326:	07f00793          	li	a5,127
    8000032a:	0af48e63          	beq	s1,a5,800003e6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000032e:	00011717          	auipc	a4,0x11
    80000332:	4d270713          	addi	a4,a4,1234 # 80011800 <cons>
    80000336:	0a072783          	lw	a5,160(a4)
    8000033a:	09872703          	lw	a4,152(a4)
    8000033e:	9f99                	subw	a5,a5,a4
    80000340:	07f00713          	li	a4,127
    80000344:	fcf763e3          	bltu	a4,a5,8000030a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000348:	47b5                	li	a5,13
    8000034a:	0cf48763          	beq	s1,a5,80000418 <consoleintr+0x14a>
      consputc(c);
    8000034e:	8526                	mv	a0,s1
    80000350:	00000097          	auipc	ra,0x0
    80000354:	ea8080e7          	jalr	-344(ra) # 800001f8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000358:	00011797          	auipc	a5,0x11
    8000035c:	4a878793          	addi	a5,a5,1192 # 80011800 <cons>
    80000360:	0a07a703          	lw	a4,160(a5)
    80000364:	0017069b          	addiw	a3,a4,1
    80000368:	0006861b          	sext.w	a2,a3
    8000036c:	0ad7a023          	sw	a3,160(a5)
    80000370:	07f77713          	andi	a4,a4,127
    80000374:	97ba                	add	a5,a5,a4
    80000376:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    8000037a:	47a9                	li	a5,10
    8000037c:	0cf48563          	beq	s1,a5,80000446 <consoleintr+0x178>
    80000380:	4791                	li	a5,4
    80000382:	0cf48263          	beq	s1,a5,80000446 <consoleintr+0x178>
    80000386:	00011797          	auipc	a5,0x11
    8000038a:	5127a783          	lw	a5,1298(a5) # 80011898 <cons+0x98>
    8000038e:	0807879b          	addiw	a5,a5,128
    80000392:	f6f61ce3          	bne	a2,a5,8000030a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000396:	863e                	mv	a2,a5
    80000398:	a07d                	j	80000446 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000039a:	00011717          	auipc	a4,0x11
    8000039e:	46670713          	addi	a4,a4,1126 # 80011800 <cons>
    800003a2:	0a072783          	lw	a5,160(a4)
    800003a6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003aa:	00011497          	auipc	s1,0x11
    800003ae:	45648493          	addi	s1,s1,1110 # 80011800 <cons>
    while(cons.e != cons.w &&
    800003b2:	4929                	li	s2,10
    800003b4:	f4f70be3          	beq	a4,a5,8000030a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b8:	37fd                	addiw	a5,a5,-1
    800003ba:	07f7f713          	andi	a4,a5,127
    800003be:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003c0:	01874703          	lbu	a4,24(a4)
    800003c4:	f52703e3          	beq	a4,s2,8000030a <consoleintr+0x3c>
      cons.e--;
    800003c8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003cc:	10000513          	li	a0,256
    800003d0:	00000097          	auipc	ra,0x0
    800003d4:	e28080e7          	jalr	-472(ra) # 800001f8 <consputc>
    while(cons.e != cons.w &&
    800003d8:	0a04a783          	lw	a5,160(s1)
    800003dc:	09c4a703          	lw	a4,156(s1)
    800003e0:	fcf71ce3          	bne	a4,a5,800003b8 <consoleintr+0xea>
    800003e4:	b71d                	j	8000030a <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003e6:	00011717          	auipc	a4,0x11
    800003ea:	41a70713          	addi	a4,a4,1050 # 80011800 <cons>
    800003ee:	0a072783          	lw	a5,160(a4)
    800003f2:	09c72703          	lw	a4,156(a4)
    800003f6:	f0f70ae3          	beq	a4,a5,8000030a <consoleintr+0x3c>
      cons.e--;
    800003fa:	37fd                	addiw	a5,a5,-1
    800003fc:	00011717          	auipc	a4,0x11
    80000400:	4af72223          	sw	a5,1188(a4) # 800118a0 <cons+0xa0>
      consputc(BACKSPACE);
    80000404:	10000513          	li	a0,256
    80000408:	00000097          	auipc	ra,0x0
    8000040c:	df0080e7          	jalr	-528(ra) # 800001f8 <consputc>
    80000410:	bded                	j	8000030a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000412:	ee048ce3          	beqz	s1,8000030a <consoleintr+0x3c>
    80000416:	bf21                	j	8000032e <consoleintr+0x60>
      consputc(c);
    80000418:	4529                	li	a0,10
    8000041a:	00000097          	auipc	ra,0x0
    8000041e:	dde080e7          	jalr	-546(ra) # 800001f8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000422:	00011797          	auipc	a5,0x11
    80000426:	3de78793          	addi	a5,a5,990 # 80011800 <cons>
    8000042a:	0a07a703          	lw	a4,160(a5)
    8000042e:	0017069b          	addiw	a3,a4,1
    80000432:	0006861b          	sext.w	a2,a3
    80000436:	0ad7a023          	sw	a3,160(a5)
    8000043a:	07f77713          	andi	a4,a4,127
    8000043e:	97ba                	add	a5,a5,a4
    80000440:	4729                	li	a4,10
    80000442:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000446:	00011797          	auipc	a5,0x11
    8000044a:	44c7ab23          	sw	a2,1110(a5) # 8001189c <cons+0x9c>
        wakeup(&cons.r);
    8000044e:	00011517          	auipc	a0,0x11
    80000452:	44a50513          	addi	a0,a0,1098 # 80011898 <cons+0x98>
    80000456:	00002097          	auipc	ra,0x2
    8000045a:	136080e7          	jalr	310(ra) # 8000258c <wakeup>
    8000045e:	b575                	j	8000030a <consoleintr+0x3c>

0000000080000460 <consoleinit>:

void
consoleinit(void)
{
    80000460:	1141                	addi	sp,sp,-16
    80000462:	e406                	sd	ra,8(sp)
    80000464:	e022                	sd	s0,0(sp)
    80000466:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000468:	00007597          	auipc	a1,0x7
    8000046c:	cb058593          	addi	a1,a1,-848 # 80007118 <userret+0x88>
    80000470:	00011517          	auipc	a0,0x11
    80000474:	39050513          	addi	a0,a0,912 # 80011800 <cons>
    80000478:	00000097          	auipc	ra,0x0
    8000047c:	548080e7          	jalr	1352(ra) # 800009c0 <initlock>
  uartinit();
    80000480:	00000097          	auipc	ra,0x0
    80000484:	330080e7          	jalr	816(ra) # 800007b0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000488:	00021797          	auipc	a5,0x21
    8000048c:	7b878793          	addi	a5,a5,1976 # 80021c40 <devsw>
    80000490:	00000717          	auipc	a4,0x0
    80000494:	c5070713          	addi	a4,a4,-944 # 800000e0 <consoleread>
    80000498:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000049a:	00000717          	auipc	a4,0x0
    8000049e:	dac70713          	addi	a4,a4,-596 # 80000246 <consolewrite>
    800004a2:	ef98                	sd	a4,24(a5)
}
    800004a4:	60a2                	ld	ra,8(sp)
    800004a6:	6402                	ld	s0,0(sp)
    800004a8:	0141                	addi	sp,sp,16
    800004aa:	8082                	ret

00000000800004ac <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004ac:	7179                	addi	sp,sp,-48
    800004ae:	f406                	sd	ra,40(sp)
    800004b0:	f022                	sd	s0,32(sp)
    800004b2:	ec26                	sd	s1,24(sp)
    800004b4:	e84a                	sd	s2,16(sp)
    800004b6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004b8:	c219                	beqz	a2,800004be <printint+0x12>
    800004ba:	08054663          	bltz	a0,80000546 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004be:	2501                	sext.w	a0,a0
    800004c0:	4881                	li	a7,0
    800004c2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004c6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004c8:	2581                	sext.w	a1,a1
    800004ca:	00007617          	auipc	a2,0x7
    800004ce:	39e60613          	addi	a2,a2,926 # 80007868 <digits>
    800004d2:	883a                	mv	a6,a4
    800004d4:	2705                	addiw	a4,a4,1
    800004d6:	02b577bb          	remuw	a5,a0,a1
    800004da:	1782                	slli	a5,a5,0x20
    800004dc:	9381                	srli	a5,a5,0x20
    800004de:	97b2                	add	a5,a5,a2
    800004e0:	0007c783          	lbu	a5,0(a5)
    800004e4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004e8:	0005079b          	sext.w	a5,a0
    800004ec:	02b5553b          	divuw	a0,a0,a1
    800004f0:	0685                	addi	a3,a3,1
    800004f2:	feb7f0e3          	bgeu	a5,a1,800004d2 <printint+0x26>

  if(sign)
    800004f6:	00088b63          	beqz	a7,8000050c <printint+0x60>
    buf[i++] = '-';
    800004fa:	fe040793          	addi	a5,s0,-32
    800004fe:	973e                	add	a4,a4,a5
    80000500:	02d00793          	li	a5,45
    80000504:	fef70823          	sb	a5,-16(a4)
    80000508:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000050c:	02e05763          	blez	a4,8000053a <printint+0x8e>
    80000510:	fd040793          	addi	a5,s0,-48
    80000514:	00e784b3          	add	s1,a5,a4
    80000518:	fff78913          	addi	s2,a5,-1
    8000051c:	993a                	add	s2,s2,a4
    8000051e:	377d                	addiw	a4,a4,-1
    80000520:	1702                	slli	a4,a4,0x20
    80000522:	9301                	srli	a4,a4,0x20
    80000524:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000528:	fff4c503          	lbu	a0,-1(s1)
    8000052c:	00000097          	auipc	ra,0x0
    80000530:	ccc080e7          	jalr	-820(ra) # 800001f8 <consputc>
  while(--i >= 0)
    80000534:	14fd                	addi	s1,s1,-1
    80000536:	ff2499e3          	bne	s1,s2,80000528 <printint+0x7c>
}
    8000053a:	70a2                	ld	ra,40(sp)
    8000053c:	7402                	ld	s0,32(sp)
    8000053e:	64e2                	ld	s1,24(sp)
    80000540:	6942                	ld	s2,16(sp)
    80000542:	6145                	addi	sp,sp,48
    80000544:	8082                	ret
    x = -xx;
    80000546:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000054a:	4885                	li	a7,1
    x = -xx;
    8000054c:	bf9d                	j	800004c2 <printint+0x16>

000000008000054e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000054e:	1101                	addi	sp,sp,-32
    80000550:	ec06                	sd	ra,24(sp)
    80000552:	e822                	sd	s0,16(sp)
    80000554:	e426                	sd	s1,8(sp)
    80000556:	1000                	addi	s0,sp,32
    80000558:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000055a:	00011797          	auipc	a5,0x11
    8000055e:	3607a323          	sw	zero,870(a5) # 800118c0 <pr+0x18>
  printf("panic: ");
    80000562:	00007517          	auipc	a0,0x7
    80000566:	bbe50513          	addi	a0,a0,-1090 # 80007120 <userret+0x90>
    8000056a:	00000097          	auipc	ra,0x0
    8000056e:	02e080e7          	jalr	46(ra) # 80000598 <printf>
  printf(s);
    80000572:	8526                	mv	a0,s1
    80000574:	00000097          	auipc	ra,0x0
    80000578:	024080e7          	jalr	36(ra) # 80000598 <printf>
  printf("\n");
    8000057c:	00007517          	auipc	a0,0x7
    80000580:	e6c50513          	addi	a0,a0,-404 # 800073e8 <userret+0x358>
    80000584:	00000097          	auipc	ra,0x0
    80000588:	014080e7          	jalr	20(ra) # 80000598 <printf>
  panicked = 1; // freeze other CPUs
    8000058c:	4785                	li	a5,1
    8000058e:	00026717          	auipc	a4,0x26
    80000592:	a6f72923          	sw	a5,-1422(a4) # 80026000 <panicked>
  for(;;)
    80000596:	a001                	j	80000596 <panic+0x48>

0000000080000598 <printf>:
{
    80000598:	7131                	addi	sp,sp,-192
    8000059a:	fc86                	sd	ra,120(sp)
    8000059c:	f8a2                	sd	s0,112(sp)
    8000059e:	f4a6                	sd	s1,104(sp)
    800005a0:	f0ca                	sd	s2,96(sp)
    800005a2:	ecce                	sd	s3,88(sp)
    800005a4:	e8d2                	sd	s4,80(sp)
    800005a6:	e4d6                	sd	s5,72(sp)
    800005a8:	e0da                	sd	s6,64(sp)
    800005aa:	fc5e                	sd	s7,56(sp)
    800005ac:	f862                	sd	s8,48(sp)
    800005ae:	f466                	sd	s9,40(sp)
    800005b0:	f06a                	sd	s10,32(sp)
    800005b2:	ec6e                	sd	s11,24(sp)
    800005b4:	0100                	addi	s0,sp,128
    800005b6:	8a2a                	mv	s4,a0
    800005b8:	e40c                	sd	a1,8(s0)
    800005ba:	e810                	sd	a2,16(s0)
    800005bc:	ec14                	sd	a3,24(s0)
    800005be:	f018                	sd	a4,32(s0)
    800005c0:	f41c                	sd	a5,40(s0)
    800005c2:	03043823          	sd	a6,48(s0)
    800005c6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ca:	00011d97          	auipc	s11,0x11
    800005ce:	2f6dad83          	lw	s11,758(s11) # 800118c0 <pr+0x18>
  if(locking)
    800005d2:	020d9b63          	bnez	s11,80000608 <printf+0x70>
  if (fmt == 0)
    800005d6:	040a0263          	beqz	s4,8000061a <printf+0x82>
  va_start(ap, fmt);
    800005da:	00840793          	addi	a5,s0,8
    800005de:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e2:	000a4503          	lbu	a0,0(s4)
    800005e6:	16050263          	beqz	a0,8000074a <printf+0x1b2>
    800005ea:	4481                	li	s1,0
    if(c != '%'){
    800005ec:	02500a93          	li	s5,37
    switch(c){
    800005f0:	07000b13          	li	s6,112
  consputc('x');
    800005f4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005f6:	00007b97          	auipc	s7,0x7
    800005fa:	272b8b93          	addi	s7,s7,626 # 80007868 <digits>
    switch(c){
    800005fe:	07300c93          	li	s9,115
    80000602:	06400c13          	li	s8,100
    80000606:	a82d                	j	80000640 <printf+0xa8>
    acquire(&pr.lock);
    80000608:	00011517          	auipc	a0,0x11
    8000060c:	2a050513          	addi	a0,a0,672 # 800118a8 <pr>
    80000610:	00000097          	auipc	ra,0x0
    80000614:	4c2080e7          	jalr	1218(ra) # 80000ad2 <acquire>
    80000618:	bf7d                	j	800005d6 <printf+0x3e>
    panic("null fmt");
    8000061a:	00007517          	auipc	a0,0x7
    8000061e:	b1650513          	addi	a0,a0,-1258 # 80007130 <userret+0xa0>
    80000622:	00000097          	auipc	ra,0x0
    80000626:	f2c080e7          	jalr	-212(ra) # 8000054e <panic>
      consputc(c);
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	bce080e7          	jalr	-1074(ra) # 800001f8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000632:	2485                	addiw	s1,s1,1
    80000634:	009a07b3          	add	a5,s4,s1
    80000638:	0007c503          	lbu	a0,0(a5)
    8000063c:	10050763          	beqz	a0,8000074a <printf+0x1b2>
    if(c != '%'){
    80000640:	ff5515e3          	bne	a0,s5,8000062a <printf+0x92>
    c = fmt[++i] & 0xff;
    80000644:	2485                	addiw	s1,s1,1
    80000646:	009a07b3          	add	a5,s4,s1
    8000064a:	0007c783          	lbu	a5,0(a5)
    8000064e:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80000652:	cfe5                	beqz	a5,8000074a <printf+0x1b2>
    switch(c){
    80000654:	05678a63          	beq	a5,s6,800006a8 <printf+0x110>
    80000658:	02fb7663          	bgeu	s6,a5,80000684 <printf+0xec>
    8000065c:	09978963          	beq	a5,s9,800006ee <printf+0x156>
    80000660:	07800713          	li	a4,120
    80000664:	0ce79863          	bne	a5,a4,80000734 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80000668:	f8843783          	ld	a5,-120(s0)
    8000066c:	00878713          	addi	a4,a5,8
    80000670:	f8e43423          	sd	a4,-120(s0)
    80000674:	4605                	li	a2,1
    80000676:	85ea                	mv	a1,s10
    80000678:	4388                	lw	a0,0(a5)
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	e32080e7          	jalr	-462(ra) # 800004ac <printint>
      break;
    80000682:	bf45                	j	80000632 <printf+0x9a>
    switch(c){
    80000684:	0b578263          	beq	a5,s5,80000728 <printf+0x190>
    80000688:	0b879663          	bne	a5,s8,80000734 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    8000068c:	f8843783          	ld	a5,-120(s0)
    80000690:	00878713          	addi	a4,a5,8
    80000694:	f8e43423          	sd	a4,-120(s0)
    80000698:	4605                	li	a2,1
    8000069a:	45a9                	li	a1,10
    8000069c:	4388                	lw	a0,0(a5)
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	e0e080e7          	jalr	-498(ra) # 800004ac <printint>
      break;
    800006a6:	b771                	j	80000632 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006a8:	f8843783          	ld	a5,-120(s0)
    800006ac:	00878713          	addi	a4,a5,8
    800006b0:	f8e43423          	sd	a4,-120(s0)
    800006b4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006b8:	03000513          	li	a0,48
    800006bc:	00000097          	auipc	ra,0x0
    800006c0:	b3c080e7          	jalr	-1220(ra) # 800001f8 <consputc>
  consputc('x');
    800006c4:	07800513          	li	a0,120
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	b30080e7          	jalr	-1232(ra) # 800001f8 <consputc>
    800006d0:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006d2:	03c9d793          	srli	a5,s3,0x3c
    800006d6:	97de                	add	a5,a5,s7
    800006d8:	0007c503          	lbu	a0,0(a5)
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	b1c080e7          	jalr	-1252(ra) # 800001f8 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006e4:	0992                	slli	s3,s3,0x4
    800006e6:	397d                	addiw	s2,s2,-1
    800006e8:	fe0915e3          	bnez	s2,800006d2 <printf+0x13a>
    800006ec:	b799                	j	80000632 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006ee:	f8843783          	ld	a5,-120(s0)
    800006f2:	00878713          	addi	a4,a5,8
    800006f6:	f8e43423          	sd	a4,-120(s0)
    800006fa:	0007b903          	ld	s2,0(a5)
    800006fe:	00090e63          	beqz	s2,8000071a <printf+0x182>
      for(; *s; s++)
    80000702:	00094503          	lbu	a0,0(s2)
    80000706:	d515                	beqz	a0,80000632 <printf+0x9a>
        consputc(*s);
    80000708:	00000097          	auipc	ra,0x0
    8000070c:	af0080e7          	jalr	-1296(ra) # 800001f8 <consputc>
      for(; *s; s++)
    80000710:	0905                	addi	s2,s2,1
    80000712:	00094503          	lbu	a0,0(s2)
    80000716:	f96d                	bnez	a0,80000708 <printf+0x170>
    80000718:	bf29                	j	80000632 <printf+0x9a>
        s = "(null)";
    8000071a:	00007917          	auipc	s2,0x7
    8000071e:	a0e90913          	addi	s2,s2,-1522 # 80007128 <userret+0x98>
      for(; *s; s++)
    80000722:	02800513          	li	a0,40
    80000726:	b7cd                	j	80000708 <printf+0x170>
      consputc('%');
    80000728:	8556                	mv	a0,s5
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	ace080e7          	jalr	-1330(ra) # 800001f8 <consputc>
      break;
    80000732:	b701                	j	80000632 <printf+0x9a>
      consputc('%');
    80000734:	8556                	mv	a0,s5
    80000736:	00000097          	auipc	ra,0x0
    8000073a:	ac2080e7          	jalr	-1342(ra) # 800001f8 <consputc>
      consputc(c);
    8000073e:	854a                	mv	a0,s2
    80000740:	00000097          	auipc	ra,0x0
    80000744:	ab8080e7          	jalr	-1352(ra) # 800001f8 <consputc>
      break;
    80000748:	b5ed                	j	80000632 <printf+0x9a>
  if(locking)
    8000074a:	020d9163          	bnez	s11,8000076c <printf+0x1d4>
}
    8000074e:	70e6                	ld	ra,120(sp)
    80000750:	7446                	ld	s0,112(sp)
    80000752:	74a6                	ld	s1,104(sp)
    80000754:	7906                	ld	s2,96(sp)
    80000756:	69e6                	ld	s3,88(sp)
    80000758:	6a46                	ld	s4,80(sp)
    8000075a:	6aa6                	ld	s5,72(sp)
    8000075c:	6b06                	ld	s6,64(sp)
    8000075e:	7be2                	ld	s7,56(sp)
    80000760:	7c42                	ld	s8,48(sp)
    80000762:	7ca2                	ld	s9,40(sp)
    80000764:	7d02                	ld	s10,32(sp)
    80000766:	6de2                	ld	s11,24(sp)
    80000768:	6129                	addi	sp,sp,192
    8000076a:	8082                	ret
    release(&pr.lock);
    8000076c:	00011517          	auipc	a0,0x11
    80000770:	13c50513          	addi	a0,a0,316 # 800118a8 <pr>
    80000774:	00000097          	auipc	ra,0x0
    80000778:	3b2080e7          	jalr	946(ra) # 80000b26 <release>
}
    8000077c:	bfc9                	j	8000074e <printf+0x1b6>

000000008000077e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000077e:	1101                	addi	sp,sp,-32
    80000780:	ec06                	sd	ra,24(sp)
    80000782:	e822                	sd	s0,16(sp)
    80000784:	e426                	sd	s1,8(sp)
    80000786:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000788:	00011497          	auipc	s1,0x11
    8000078c:	12048493          	addi	s1,s1,288 # 800118a8 <pr>
    80000790:	00007597          	auipc	a1,0x7
    80000794:	9b058593          	addi	a1,a1,-1616 # 80007140 <userret+0xb0>
    80000798:	8526                	mv	a0,s1
    8000079a:	00000097          	auipc	ra,0x0
    8000079e:	226080e7          	jalr	550(ra) # 800009c0 <initlock>
  pr.locking = 1;
    800007a2:	4785                	li	a5,1
    800007a4:	cc9c                	sw	a5,24(s1)
}
    800007a6:	60e2                	ld	ra,24(sp)
    800007a8:	6442                	ld	s0,16(sp)
    800007aa:	64a2                	ld	s1,8(sp)
    800007ac:	6105                	addi	sp,sp,32
    800007ae:	8082                	ret

00000000800007b0 <uartinit>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

void
uartinit(void)
{
    800007b0:	1141                	addi	sp,sp,-16
    800007b2:	e422                	sd	s0,8(sp)
    800007b4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007b6:	100007b7          	lui	a5,0x10000
    800007ba:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, 0x80);
    800007be:	f8000713          	li	a4,-128
    800007c2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007c6:	470d                	li	a4,3
    800007c8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007cc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, 0x03);
    800007d0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, 0x07);
    800007d4:	471d                	li	a4,7
    800007d6:	00e78123          	sb	a4,2(a5)

  // enable receive interrupts.
  WriteReg(IER, 0x01);
    800007da:	4705                	li	a4,1
    800007dc:	00e780a3          	sb	a4,1(a5)
}
    800007e0:	6422                	ld	s0,8(sp)
    800007e2:	0141                	addi	sp,sp,16
    800007e4:	8082                	ret

00000000800007e6 <uartputc>:

// write one output character to the UART.
void
uartputc(int c)
{
    800007e6:	1141                	addi	sp,sp,-16
    800007e8:	e422                	sd	s0,8(sp)
    800007ea:	0800                	addi	s0,sp,16
  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & (1 << 5)) == 0)
    800007ec:	10000737          	lui	a4,0x10000
    800007f0:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800007f4:	0ff7f793          	andi	a5,a5,255
    800007f8:	0207f793          	andi	a5,a5,32
    800007fc:	dbf5                	beqz	a5,800007f0 <uartputc+0xa>
    ;
  WriteReg(THR, c);
    800007fe:	0ff57513          	andi	a0,a0,255
    80000802:	100007b7          	lui	a5,0x10000
    80000806:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    8000080a:	6422                	ld	s0,8(sp)
    8000080c:	0141                	addi	sp,sp,16
    8000080e:	8082                	ret

0000000080000810 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000810:	1141                	addi	sp,sp,-16
    80000812:	e422                	sd	s0,8(sp)
    80000814:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000816:	100007b7          	lui	a5,0x10000
    8000081a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000081e:	8b85                	andi	a5,a5,1
    80000820:	cb91                	beqz	a5,80000834 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000822:	100007b7          	lui	a5,0x10000
    80000826:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000082a:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000082e:	6422                	ld	s0,8(sp)
    80000830:	0141                	addi	sp,sp,16
    80000832:	8082                	ret
    return -1;
    80000834:	557d                	li	a0,-1
    80000836:	bfe5                	j	8000082e <uartgetc+0x1e>

0000000080000838 <uartintr>:

// trap.c calls here when the uart interrupts.
void
uartintr(void)
{
    80000838:	1101                	addi	sp,sp,-32
    8000083a:	ec06                	sd	ra,24(sp)
    8000083c:	e822                	sd	s0,16(sp)
    8000083e:	e426                	sd	s1,8(sp)
    80000840:	1000                	addi	s0,sp,32
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000842:	54fd                	li	s1,-1
    int c = uartgetc();
    80000844:	00000097          	auipc	ra,0x0
    80000848:	fcc080e7          	jalr	-52(ra) # 80000810 <uartgetc>
    if(c == -1)
    8000084c:	00950763          	beq	a0,s1,8000085a <uartintr+0x22>
      break;
    consoleintr(c);
    80000850:	00000097          	auipc	ra,0x0
    80000854:	a7e080e7          	jalr	-1410(ra) # 800002ce <consoleintr>
  while(1){
    80000858:	b7f5                	j	80000844 <uartintr+0xc>
  }
}
    8000085a:	60e2                	ld	ra,24(sp)
    8000085c:	6442                	ld	s0,16(sp)
    8000085e:	64a2                	ld	s1,8(sp)
    80000860:	6105                	addi	sp,sp,32
    80000862:	8082                	ret

0000000080000864 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000864:	1101                	addi	sp,sp,-32
    80000866:	ec06                	sd	ra,24(sp)
    80000868:	e822                	sd	s0,16(sp)
    8000086a:	e426                	sd	s1,8(sp)
    8000086c:	e04a                	sd	s2,0(sp)
    8000086e:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000870:	03451793          	slli	a5,a0,0x34
    80000874:	ebb9                	bnez	a5,800008ca <kfree+0x66>
    80000876:	84aa                	mv	s1,a0
    80000878:	00025797          	auipc	a5,0x25
    8000087c:	7a478793          	addi	a5,a5,1956 # 8002601c <end>
    80000880:	04f56563          	bltu	a0,a5,800008ca <kfree+0x66>
    80000884:	47c5                	li	a5,17
    80000886:	07ee                	slli	a5,a5,0x1b
    80000888:	04f57163          	bgeu	a0,a5,800008ca <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000088c:	6605                	lui	a2,0x1
    8000088e:	4585                	li	a1,1
    80000890:	00000097          	auipc	ra,0x0
    80000894:	2de080e7          	jalr	734(ra) # 80000b6e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000898:	00011917          	auipc	s2,0x11
    8000089c:	03090913          	addi	s2,s2,48 # 800118c8 <kmem>
    800008a0:	854a                	mv	a0,s2
    800008a2:	00000097          	auipc	ra,0x0
    800008a6:	230080e7          	jalr	560(ra) # 80000ad2 <acquire>
  r->next = kmem.freelist;
    800008aa:	01893783          	ld	a5,24(s2)
    800008ae:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800008b0:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800008b4:	854a                	mv	a0,s2
    800008b6:	00000097          	auipc	ra,0x0
    800008ba:	270080e7          	jalr	624(ra) # 80000b26 <release>
}
    800008be:	60e2                	ld	ra,24(sp)
    800008c0:	6442                	ld	s0,16(sp)
    800008c2:	64a2                	ld	s1,8(sp)
    800008c4:	6902                	ld	s2,0(sp)
    800008c6:	6105                	addi	sp,sp,32
    800008c8:	8082                	ret
    panic("kfree");
    800008ca:	00007517          	auipc	a0,0x7
    800008ce:	87e50513          	addi	a0,a0,-1922 # 80007148 <userret+0xb8>
    800008d2:	00000097          	auipc	ra,0x0
    800008d6:	c7c080e7          	jalr	-900(ra) # 8000054e <panic>

00000000800008da <freerange>:
{
    800008da:	7179                	addi	sp,sp,-48
    800008dc:	f406                	sd	ra,40(sp)
    800008de:	f022                	sd	s0,32(sp)
    800008e0:	ec26                	sd	s1,24(sp)
    800008e2:	e84a                	sd	s2,16(sp)
    800008e4:	e44e                	sd	s3,8(sp)
    800008e6:	e052                	sd	s4,0(sp)
    800008e8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800008ea:	6785                	lui	a5,0x1
    800008ec:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800008f0:	94aa                	add	s1,s1,a0
    800008f2:	757d                	lui	a0,0xfffff
    800008f4:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800008f6:	94be                	add	s1,s1,a5
    800008f8:	0095ee63          	bltu	a1,s1,80000914 <freerange+0x3a>
    800008fc:	892e                	mv	s2,a1
    kfree(p);
    800008fe:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000900:	6985                	lui	s3,0x1
    kfree(p);
    80000902:	01448533          	add	a0,s1,s4
    80000906:	00000097          	auipc	ra,0x0
    8000090a:	f5e080e7          	jalr	-162(ra) # 80000864 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000090e:	94ce                	add	s1,s1,s3
    80000910:	fe9979e3          	bgeu	s2,s1,80000902 <freerange+0x28>
}
    80000914:	70a2                	ld	ra,40(sp)
    80000916:	7402                	ld	s0,32(sp)
    80000918:	64e2                	ld	s1,24(sp)
    8000091a:	6942                	ld	s2,16(sp)
    8000091c:	69a2                	ld	s3,8(sp)
    8000091e:	6a02                	ld	s4,0(sp)
    80000920:	6145                	addi	sp,sp,48
    80000922:	8082                	ret

0000000080000924 <kinit>:
{
    80000924:	1141                	addi	sp,sp,-16
    80000926:	e406                	sd	ra,8(sp)
    80000928:	e022                	sd	s0,0(sp)
    8000092a:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000092c:	00007597          	auipc	a1,0x7
    80000930:	82458593          	addi	a1,a1,-2012 # 80007150 <userret+0xc0>
    80000934:	00011517          	auipc	a0,0x11
    80000938:	f9450513          	addi	a0,a0,-108 # 800118c8 <kmem>
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	084080e7          	jalr	132(ra) # 800009c0 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000944:	45c5                	li	a1,17
    80000946:	05ee                	slli	a1,a1,0x1b
    80000948:	00025517          	auipc	a0,0x25
    8000094c:	6d450513          	addi	a0,a0,1748 # 8002601c <end>
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f8a080e7          	jalr	-118(ra) # 800008da <freerange>
}
    80000958:	60a2                	ld	ra,8(sp)
    8000095a:	6402                	ld	s0,0(sp)
    8000095c:	0141                	addi	sp,sp,16
    8000095e:	8082                	ret

0000000080000960 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000960:	1101                	addi	sp,sp,-32
    80000962:	ec06                	sd	ra,24(sp)
    80000964:	e822                	sd	s0,16(sp)
    80000966:	e426                	sd	s1,8(sp)
    80000968:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000096a:	00011497          	auipc	s1,0x11
    8000096e:	f5e48493          	addi	s1,s1,-162 # 800118c8 <kmem>
    80000972:	8526                	mv	a0,s1
    80000974:	00000097          	auipc	ra,0x0
    80000978:	15e080e7          	jalr	350(ra) # 80000ad2 <acquire>
  r = kmem.freelist;
    8000097c:	6c84                	ld	s1,24(s1)
  if(r)
    8000097e:	c885                	beqz	s1,800009ae <kalloc+0x4e>
    kmem.freelist = r->next;
    80000980:	609c                	ld	a5,0(s1)
    80000982:	00011517          	auipc	a0,0x11
    80000986:	f4650513          	addi	a0,a0,-186 # 800118c8 <kmem>
    8000098a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	19a080e7          	jalr	410(ra) # 80000b26 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000994:	6605                	lui	a2,0x1
    80000996:	4595                	li	a1,5
    80000998:	8526                	mv	a0,s1
    8000099a:	00000097          	auipc	ra,0x0
    8000099e:	1d4080e7          	jalr	468(ra) # 80000b6e <memset>
  return (void*)r;
}
    800009a2:	8526                	mv	a0,s1
    800009a4:	60e2                	ld	ra,24(sp)
    800009a6:	6442                	ld	s0,16(sp)
    800009a8:	64a2                	ld	s1,8(sp)
    800009aa:	6105                	addi	sp,sp,32
    800009ac:	8082                	ret
  release(&kmem.lock);
    800009ae:	00011517          	auipc	a0,0x11
    800009b2:	f1a50513          	addi	a0,a0,-230 # 800118c8 <kmem>
    800009b6:	00000097          	auipc	ra,0x0
    800009ba:	170080e7          	jalr	368(ra) # 80000b26 <release>
  if(r)
    800009be:	b7d5                	j	800009a2 <kalloc+0x42>

00000000800009c0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800009c0:	1141                	addi	sp,sp,-16
    800009c2:	e422                	sd	s0,8(sp)
    800009c4:	0800                	addi	s0,sp,16
  lk->name = name;
    800009c6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800009c8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800009cc:	00053823          	sd	zero,16(a0)
}
    800009d0:	6422                	ld	s0,8(sp)
    800009d2:	0141                	addi	sp,sp,16
    800009d4:	8082                	ret

00000000800009d6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800009e0:	100024f3          	csrr	s1,sstatus
    800009e4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800009e8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800009ea:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800009ee:	00001097          	auipc	ra,0x1
    800009f2:	e3a080e7          	jalr	-454(ra) # 80001828 <mycpu>
    800009f6:	5d3c                	lw	a5,120(a0)
    800009f8:	cf89                	beqz	a5,80000a12 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800009fa:	00001097          	auipc	ra,0x1
    800009fe:	e2e080e7          	jalr	-466(ra) # 80001828 <mycpu>
    80000a02:	5d3c                	lw	a5,120(a0)
    80000a04:	2785                	addiw	a5,a5,1
    80000a06:	dd3c                	sw	a5,120(a0)
}
    80000a08:	60e2                	ld	ra,24(sp)
    80000a0a:	6442                	ld	s0,16(sp)
    80000a0c:	64a2                	ld	s1,8(sp)
    80000a0e:	6105                	addi	sp,sp,32
    80000a10:	8082                	ret
    mycpu()->intena = old;
    80000a12:	00001097          	auipc	ra,0x1
    80000a16:	e16080e7          	jalr	-490(ra) # 80001828 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000a1a:	8085                	srli	s1,s1,0x1
    80000a1c:	8885                	andi	s1,s1,1
    80000a1e:	dd64                	sw	s1,124(a0)
    80000a20:	bfe9                	j	800009fa <push_off+0x24>

0000000080000a22 <pop_off>:

void
pop_off(void)
{
    80000a22:	1141                	addi	sp,sp,-16
    80000a24:	e406                	sd	ra,8(sp)
    80000a26:	e022                	sd	s0,0(sp)
    80000a28:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000a2a:	00001097          	auipc	ra,0x1
    80000a2e:	dfe080e7          	jalr	-514(ra) # 80001828 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a32:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000a36:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000a38:	ef8d                	bnez	a5,80000a72 <pop_off+0x50>
    panic("pop_off - interruptible");
  c->noff -= 1;
    80000a3a:	5d3c                	lw	a5,120(a0)
    80000a3c:	37fd                	addiw	a5,a5,-1
    80000a3e:	0007871b          	sext.w	a4,a5
    80000a42:	dd3c                	sw	a5,120(a0)
  if(c->noff < 0)
    80000a44:	02079693          	slli	a3,a5,0x20
    80000a48:	0206cd63          	bltz	a3,80000a82 <pop_off+0x60>
    panic("pop_off");
  if(c->noff == 0 && c->intena)
    80000a4c:	ef19                	bnez	a4,80000a6a <pop_off+0x48>
    80000a4e:	5d7c                	lw	a5,124(a0)
    80000a50:	cf89                	beqz	a5,80000a6a <pop_off+0x48>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80000a52:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000a56:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80000a5a:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a5e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000a62:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000a66:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000a6a:	60a2                	ld	ra,8(sp)
    80000a6c:	6402                	ld	s0,0(sp)
    80000a6e:	0141                	addi	sp,sp,16
    80000a70:	8082                	ret
    panic("pop_off - interruptible");
    80000a72:	00006517          	auipc	a0,0x6
    80000a76:	6e650513          	addi	a0,a0,1766 # 80007158 <userret+0xc8>
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	ad4080e7          	jalr	-1324(ra) # 8000054e <panic>
    panic("pop_off");
    80000a82:	00006517          	auipc	a0,0x6
    80000a86:	6ee50513          	addi	a0,a0,1774 # 80007170 <userret+0xe0>
    80000a8a:	00000097          	auipc	ra,0x0
    80000a8e:	ac4080e7          	jalr	-1340(ra) # 8000054e <panic>

0000000080000a92 <holding>:
{
    80000a92:	1101                	addi	sp,sp,-32
    80000a94:	ec06                	sd	ra,24(sp)
    80000a96:	e822                	sd	s0,16(sp)
    80000a98:	e426                	sd	s1,8(sp)
    80000a9a:	1000                	addi	s0,sp,32
    80000a9c:	84aa                	mv	s1,a0
  push_off();
    80000a9e:	00000097          	auipc	ra,0x0
    80000aa2:	f38080e7          	jalr	-200(ra) # 800009d6 <push_off>
  r = (lk->locked && lk->cpu == mycpu());
    80000aa6:	409c                	lw	a5,0(s1)
    80000aa8:	ef81                	bnez	a5,80000ac0 <holding+0x2e>
    80000aaa:	4481                	li	s1,0
  pop_off();
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	f76080e7          	jalr	-138(ra) # 80000a22 <pop_off>
}
    80000ab4:	8526                	mv	a0,s1
    80000ab6:	60e2                	ld	ra,24(sp)
    80000ab8:	6442                	ld	s0,16(sp)
    80000aba:	64a2                	ld	s1,8(sp)
    80000abc:	6105                	addi	sp,sp,32
    80000abe:	8082                	ret
  r = (lk->locked && lk->cpu == mycpu());
    80000ac0:	6884                	ld	s1,16(s1)
    80000ac2:	00001097          	auipc	ra,0x1
    80000ac6:	d66080e7          	jalr	-666(ra) # 80001828 <mycpu>
    80000aca:	8c89                	sub	s1,s1,a0
    80000acc:	0014b493          	seqz	s1,s1
    80000ad0:	bff1                	j	80000aac <holding+0x1a>

0000000080000ad2 <acquire>:
{
    80000ad2:	1101                	addi	sp,sp,-32
    80000ad4:	ec06                	sd	ra,24(sp)
    80000ad6:	e822                	sd	s0,16(sp)
    80000ad8:	e426                	sd	s1,8(sp)
    80000ada:	1000                	addi	s0,sp,32
    80000adc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000ade:	00000097          	auipc	ra,0x0
    80000ae2:	ef8080e7          	jalr	-264(ra) # 800009d6 <push_off>
  if(holding(lk))
    80000ae6:	8526                	mv	a0,s1
    80000ae8:	00000097          	auipc	ra,0x0
    80000aec:	faa080e7          	jalr	-86(ra) # 80000a92 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000af0:	4705                	li	a4,1
  if(holding(lk))
    80000af2:	e115                	bnez	a0,80000b16 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000af4:	87ba                	mv	a5,a4
    80000af6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000afa:	2781                	sext.w	a5,a5
    80000afc:	ffe5                	bnez	a5,80000af4 <acquire+0x22>
  __sync_synchronize();
    80000afe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000b02:	00001097          	auipc	ra,0x1
    80000b06:	d26080e7          	jalr	-730(ra) # 80001828 <mycpu>
    80000b0a:	e888                	sd	a0,16(s1)
}
    80000b0c:	60e2                	ld	ra,24(sp)
    80000b0e:	6442                	ld	s0,16(sp)
    80000b10:	64a2                	ld	s1,8(sp)
    80000b12:	6105                	addi	sp,sp,32
    80000b14:	8082                	ret
    panic("acquire");
    80000b16:	00006517          	auipc	a0,0x6
    80000b1a:	66250513          	addi	a0,a0,1634 # 80007178 <userret+0xe8>
    80000b1e:	00000097          	auipc	ra,0x0
    80000b22:	a30080e7          	jalr	-1488(ra) # 8000054e <panic>

0000000080000b26 <release>:
{
    80000b26:	1101                	addi	sp,sp,-32
    80000b28:	ec06                	sd	ra,24(sp)
    80000b2a:	e822                	sd	s0,16(sp)
    80000b2c:	e426                	sd	s1,8(sp)
    80000b2e:	1000                	addi	s0,sp,32
    80000b30:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000b32:	00000097          	auipc	ra,0x0
    80000b36:	f60080e7          	jalr	-160(ra) # 80000a92 <holding>
    80000b3a:	c115                	beqz	a0,80000b5e <release+0x38>
  lk->cpu = 0;
    80000b3c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000b40:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000b44:	0f50000f          	fence	iorw,ow
    80000b48:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	ed6080e7          	jalr	-298(ra) # 80000a22 <pop_off>
}
    80000b54:	60e2                	ld	ra,24(sp)
    80000b56:	6442                	ld	s0,16(sp)
    80000b58:	64a2                	ld	s1,8(sp)
    80000b5a:	6105                	addi	sp,sp,32
    80000b5c:	8082                	ret
    panic("release");
    80000b5e:	00006517          	auipc	a0,0x6
    80000b62:	62250513          	addi	a0,a0,1570 # 80007180 <userret+0xf0>
    80000b66:	00000097          	auipc	ra,0x0
    80000b6a:	9e8080e7          	jalr	-1560(ra) # 8000054e <panic>

0000000080000b6e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000b6e:	1141                	addi	sp,sp,-16
    80000b70:	e422                	sd	s0,8(sp)
    80000b72:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000b74:	ce09                	beqz	a2,80000b8e <memset+0x20>
    80000b76:	87aa                	mv	a5,a0
    80000b78:	fff6071b          	addiw	a4,a2,-1
    80000b7c:	1702                	slli	a4,a4,0x20
    80000b7e:	9301                	srli	a4,a4,0x20
    80000b80:	0705                	addi	a4,a4,1
    80000b82:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000b84:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000b88:	0785                	addi	a5,a5,1
    80000b8a:	fee79de3          	bne	a5,a4,80000b84 <memset+0x16>
  }
  return dst;
}
    80000b8e:	6422                	ld	s0,8(sp)
    80000b90:	0141                	addi	sp,sp,16
    80000b92:	8082                	ret

0000000080000b94 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000b94:	1141                	addi	sp,sp,-16
    80000b96:	e422                	sd	s0,8(sp)
    80000b98:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000b9a:	ca05                	beqz	a2,80000bca <memcmp+0x36>
    80000b9c:	fff6069b          	addiw	a3,a2,-1
    80000ba0:	1682                	slli	a3,a3,0x20
    80000ba2:	9281                	srli	a3,a3,0x20
    80000ba4:	0685                	addi	a3,a3,1
    80000ba6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000ba8:	00054783          	lbu	a5,0(a0)
    80000bac:	0005c703          	lbu	a4,0(a1)
    80000bb0:	00e79863          	bne	a5,a4,80000bc0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000bb4:	0505                	addi	a0,a0,1
    80000bb6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000bb8:	fed518e3          	bne	a0,a3,80000ba8 <memcmp+0x14>
  }

  return 0;
    80000bbc:	4501                	li	a0,0
    80000bbe:	a019                	j	80000bc4 <memcmp+0x30>
      return *s1 - *s2;
    80000bc0:	40e7853b          	subw	a0,a5,a4
}
    80000bc4:	6422                	ld	s0,8(sp)
    80000bc6:	0141                	addi	sp,sp,16
    80000bc8:	8082                	ret
  return 0;
    80000bca:	4501                	li	a0,0
    80000bcc:	bfe5                	j	80000bc4 <memcmp+0x30>

0000000080000bce <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000bce:	1141                	addi	sp,sp,-16
    80000bd0:	e422                	sd	s0,8(sp)
    80000bd2:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000bd4:	02a5e563          	bltu	a1,a0,80000bfe <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000bd8:	fff6069b          	addiw	a3,a2,-1
    80000bdc:	ce11                	beqz	a2,80000bf8 <memmove+0x2a>
    80000bde:	1682                	slli	a3,a3,0x20
    80000be0:	9281                	srli	a3,a3,0x20
    80000be2:	0685                	addi	a3,a3,1
    80000be4:	96ae                	add	a3,a3,a1
    80000be6:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000be8:	0585                	addi	a1,a1,1
    80000bea:	0785                	addi	a5,a5,1
    80000bec:	fff5c703          	lbu	a4,-1(a1)
    80000bf0:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000bf4:	fed59ae3          	bne	a1,a3,80000be8 <memmove+0x1a>

  return dst;
}
    80000bf8:	6422                	ld	s0,8(sp)
    80000bfa:	0141                	addi	sp,sp,16
    80000bfc:	8082                	ret
  if(s < d && s + n > d){
    80000bfe:	02061713          	slli	a4,a2,0x20
    80000c02:	9301                	srli	a4,a4,0x20
    80000c04:	00e587b3          	add	a5,a1,a4
    80000c08:	fcf578e3          	bgeu	a0,a5,80000bd8 <memmove+0xa>
    d += n;
    80000c0c:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000c0e:	fff6069b          	addiw	a3,a2,-1
    80000c12:	d27d                	beqz	a2,80000bf8 <memmove+0x2a>
    80000c14:	02069613          	slli	a2,a3,0x20
    80000c18:	9201                	srli	a2,a2,0x20
    80000c1a:	fff64613          	not	a2,a2
    80000c1e:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000c20:	17fd                	addi	a5,a5,-1
    80000c22:	177d                	addi	a4,a4,-1
    80000c24:	0007c683          	lbu	a3,0(a5)
    80000c28:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000c2c:	fec79ae3          	bne	a5,a2,80000c20 <memmove+0x52>
    80000c30:	b7e1                	j	80000bf8 <memmove+0x2a>

0000000080000c32 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000c32:	1141                	addi	sp,sp,-16
    80000c34:	e406                	sd	ra,8(sp)
    80000c36:	e022                	sd	s0,0(sp)
    80000c38:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000c3a:	00000097          	auipc	ra,0x0
    80000c3e:	f94080e7          	jalr	-108(ra) # 80000bce <memmove>
}
    80000c42:	60a2                	ld	ra,8(sp)
    80000c44:	6402                	ld	s0,0(sp)
    80000c46:	0141                	addi	sp,sp,16
    80000c48:	8082                	ret

0000000080000c4a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000c4a:	1141                	addi	sp,sp,-16
    80000c4c:	e422                	sd	s0,8(sp)
    80000c4e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000c50:	ce11                	beqz	a2,80000c6c <strncmp+0x22>
    80000c52:	00054783          	lbu	a5,0(a0)
    80000c56:	cf89                	beqz	a5,80000c70 <strncmp+0x26>
    80000c58:	0005c703          	lbu	a4,0(a1)
    80000c5c:	00f71a63          	bne	a4,a5,80000c70 <strncmp+0x26>
    n--, p++, q++;
    80000c60:	367d                	addiw	a2,a2,-1
    80000c62:	0505                	addi	a0,a0,1
    80000c64:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000c66:	f675                	bnez	a2,80000c52 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000c68:	4501                	li	a0,0
    80000c6a:	a809                	j	80000c7c <strncmp+0x32>
    80000c6c:	4501                	li	a0,0
    80000c6e:	a039                	j	80000c7c <strncmp+0x32>
  if(n == 0)
    80000c70:	ca09                	beqz	a2,80000c82 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000c72:	00054503          	lbu	a0,0(a0)
    80000c76:	0005c783          	lbu	a5,0(a1)
    80000c7a:	9d1d                	subw	a0,a0,a5
}
    80000c7c:	6422                	ld	s0,8(sp)
    80000c7e:	0141                	addi	sp,sp,16
    80000c80:	8082                	ret
    return 0;
    80000c82:	4501                	li	a0,0
    80000c84:	bfe5                	j	80000c7c <strncmp+0x32>

0000000080000c86 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000c86:	1141                	addi	sp,sp,-16
    80000c88:	e422                	sd	s0,8(sp)
    80000c8a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000c8c:	872a                	mv	a4,a0
    80000c8e:	8832                	mv	a6,a2
    80000c90:	367d                	addiw	a2,a2,-1
    80000c92:	01005963          	blez	a6,80000ca4 <strncpy+0x1e>
    80000c96:	0705                	addi	a4,a4,1
    80000c98:	0005c783          	lbu	a5,0(a1)
    80000c9c:	fef70fa3          	sb	a5,-1(a4)
    80000ca0:	0585                	addi	a1,a1,1
    80000ca2:	f7f5                	bnez	a5,80000c8e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000ca4:	86ba                	mv	a3,a4
    80000ca6:	00c05c63          	blez	a2,80000cbe <strncpy+0x38>
    *s++ = 0;
    80000caa:	0685                	addi	a3,a3,1
    80000cac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000cb0:	fff6c793          	not	a5,a3
    80000cb4:	9fb9                	addw	a5,a5,a4
    80000cb6:	010787bb          	addw	a5,a5,a6
    80000cba:	fef048e3          	bgtz	a5,80000caa <strncpy+0x24>
  return os;
}
    80000cbe:	6422                	ld	s0,8(sp)
    80000cc0:	0141                	addi	sp,sp,16
    80000cc2:	8082                	ret

0000000080000cc4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000cc4:	1141                	addi	sp,sp,-16
    80000cc6:	e422                	sd	s0,8(sp)
    80000cc8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000cca:	02c05363          	blez	a2,80000cf0 <safestrcpy+0x2c>
    80000cce:	fff6069b          	addiw	a3,a2,-1
    80000cd2:	1682                	slli	a3,a3,0x20
    80000cd4:	9281                	srli	a3,a3,0x20
    80000cd6:	96ae                	add	a3,a3,a1
    80000cd8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000cda:	00d58963          	beq	a1,a3,80000cec <safestrcpy+0x28>
    80000cde:	0585                	addi	a1,a1,1
    80000ce0:	0785                	addi	a5,a5,1
    80000ce2:	fff5c703          	lbu	a4,-1(a1)
    80000ce6:	fee78fa3          	sb	a4,-1(a5)
    80000cea:	fb65                	bnez	a4,80000cda <safestrcpy+0x16>
    ;
  *s = 0;
    80000cec:	00078023          	sb	zero,0(a5)
  return os;
}
    80000cf0:	6422                	ld	s0,8(sp)
    80000cf2:	0141                	addi	sp,sp,16
    80000cf4:	8082                	ret

0000000080000cf6 <strlen>:

int
strlen(const char *s)
{
    80000cf6:	1141                	addi	sp,sp,-16
    80000cf8:	e422                	sd	s0,8(sp)
    80000cfa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000cfc:	00054783          	lbu	a5,0(a0)
    80000d00:	cf91                	beqz	a5,80000d1c <strlen+0x26>
    80000d02:	0505                	addi	a0,a0,1
    80000d04:	87aa                	mv	a5,a0
    80000d06:	4685                	li	a3,1
    80000d08:	9e89                	subw	a3,a3,a0
    80000d0a:	00f6853b          	addw	a0,a3,a5
    80000d0e:	0785                	addi	a5,a5,1
    80000d10:	fff7c703          	lbu	a4,-1(a5)
    80000d14:	fb7d                	bnez	a4,80000d0a <strlen+0x14>
    ;
  return n;
}
    80000d16:	6422                	ld	s0,8(sp)
    80000d18:	0141                	addi	sp,sp,16
    80000d1a:	8082                	ret
  for(n = 0; s[n]; n++)
    80000d1c:	4501                	li	a0,0
    80000d1e:	bfe5                	j	80000d16 <strlen+0x20>

0000000080000d20 <main>:

volatile static int started = 0;
// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000d20:	1141                	addi	sp,sp,-16
    80000d22:	e406                	sd	ra,8(sp)
    80000d24:	e022                	sd	s0,0(sp)
    80000d26:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000d28:	00001097          	auipc	ra,0x1
    80000d2c:	af0080e7          	jalr	-1296(ra) # 80001818 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000d30:	00025717          	auipc	a4,0x25
    80000d34:	2d470713          	addi	a4,a4,724 # 80026004 <started>
  if(cpuid() == 0){
    80000d38:	c139                	beqz	a0,80000d7e <main+0x5e>
    while(started == 0)
    80000d3a:	431c                	lw	a5,0(a4)
    80000d3c:	2781                	sext.w	a5,a5
    80000d3e:	dff5                	beqz	a5,80000d3a <main+0x1a>
      ;
    __sync_synchronize();
    80000d40:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000d44:	00001097          	auipc	ra,0x1
    80000d48:	ad4080e7          	jalr	-1324(ra) # 80001818 <cpuid>
    80000d4c:	85aa                	mv	a1,a0
    80000d4e:	00006517          	auipc	a0,0x6
    80000d52:	45250513          	addi	a0,a0,1106 # 800071a0 <userret+0x110>
    80000d56:	00000097          	auipc	ra,0x0
    80000d5a:	842080e7          	jalr	-1982(ra) # 80000598 <printf>
    kvminithart();    // turn on paging
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	156080e7          	jalr	342(ra) # 80000eb4 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000d66:	00002097          	auipc	ra,0x2
    80000d6a:	aec080e7          	jalr	-1300(ra) # 80002852 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000d6e:	00005097          	auipc	ra,0x5
    80000d72:	092080e7          	jalr	146(ra) # 80005e00 <plicinithart>
  }
   scheduler();        
    80000d76:	00001097          	auipc	ra,0x1
    80000d7a:	284080e7          	jalr	644(ra) # 80001ffa <scheduler>
    consoleinit();
    80000d7e:	fffff097          	auipc	ra,0xfffff
    80000d82:	6e2080e7          	jalr	1762(ra) # 80000460 <consoleinit>
    printfinit();
    80000d86:	00000097          	auipc	ra,0x0
    80000d8a:	9f8080e7          	jalr	-1544(ra) # 8000077e <printfinit>
    printf("\n");
    80000d8e:	00006517          	auipc	a0,0x6
    80000d92:	65a50513          	addi	a0,a0,1626 # 800073e8 <userret+0x358>
    80000d96:	00000097          	auipc	ra,0x0
    80000d9a:	802080e7          	jalr	-2046(ra) # 80000598 <printf>
    printf("xv6 kernel is booting\n");
    80000d9e:	00006517          	auipc	a0,0x6
    80000da2:	3ea50513          	addi	a0,a0,1002 # 80007188 <userret+0xf8>
    80000da6:	fffff097          	auipc	ra,0xfffff
    80000daa:	7f2080e7          	jalr	2034(ra) # 80000598 <printf>
    printf("\n");
    80000dae:	00006517          	auipc	a0,0x6
    80000db2:	63a50513          	addi	a0,a0,1594 # 800073e8 <userret+0x358>
    80000db6:	fffff097          	auipc	ra,0xfffff
    80000dba:	7e2080e7          	jalr	2018(ra) # 80000598 <printf>
    kinit();         // physical page allocator
    80000dbe:	00000097          	auipc	ra,0x0
    80000dc2:	b66080e7          	jalr	-1178(ra) # 80000924 <kinit>
    kvminit();       // create kernel page table
    80000dc6:	00000097          	auipc	ra,0x0
    80000dca:	31e080e7          	jalr	798(ra) # 800010e4 <kvminit>
    kvminithart();   // turn on paging
    80000dce:	00000097          	auipc	ra,0x0
    80000dd2:	0e6080e7          	jalr	230(ra) # 80000eb4 <kvminithart>
    procinit();      // process table
    80000dd6:	00001097          	auipc	ra,0x1
    80000dda:	972080e7          	jalr	-1678(ra) # 80001748 <procinit>
    trapinit();      // trap vectors
    80000dde:	00002097          	auipc	ra,0x2
    80000de2:	a4c080e7          	jalr	-1460(ra) # 8000282a <trapinit>
    trapinithart();  // install kernel trap vector
    80000de6:	00002097          	auipc	ra,0x2
    80000dea:	a6c080e7          	jalr	-1428(ra) # 80002852 <trapinithart>
    plicinit();      // set up interrupt controller
    80000dee:	00005097          	auipc	ra,0x5
    80000df2:	ffc080e7          	jalr	-4(ra) # 80005dea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000df6:	00005097          	auipc	ra,0x5
    80000dfa:	00a080e7          	jalr	10(ra) # 80005e00 <plicinithart>
    binit();         // buffer cache
    80000dfe:	00002097          	auipc	ra,0x2
    80000e02:	1fc080e7          	jalr	508(ra) # 80002ffa <binit>
    iinit();         // inode cache
    80000e06:	00003097          	auipc	ra,0x3
    80000e0a:	88c080e7          	jalr	-1908(ra) # 80003692 <iinit>
    fileinit();      // file table
    80000e0e:	00004097          	auipc	ra,0x4
    80000e12:	800080e7          	jalr	-2048(ra) # 8000460e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	104080e7          	jalr	260(ra) # 80005f1a <virtio_disk_init>
    userinit();      // first user process
    80000e1e:	00001097          	auipc	ra,0x1
    80000e22:	d3e080e7          	jalr	-706(ra) # 80001b5c <userinit>
    __sync_synchronize();
    80000e26:	0ff0000f          	fence
    started = 1;
    80000e2a:	4785                	li	a5,1
    80000e2c:	00025717          	auipc	a4,0x25
    80000e30:	1cf72c23          	sw	a5,472(a4) # 80026004 <started>
    80000e34:	b789                	j	80000d76 <main+0x56>

0000000080000e36 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void
freewalk(pagetable_t pagetable)
{
    80000e36:	7179                	addi	sp,sp,-48
    80000e38:	f406                	sd	ra,40(sp)
    80000e3a:	f022                	sd	s0,32(sp)
    80000e3c:	ec26                	sd	s1,24(sp)
    80000e3e:	e84a                	sd	s2,16(sp)
    80000e40:	e44e                	sd	s3,8(sp)
    80000e42:	e052                	sd	s4,0(sp)
    80000e44:	1800                	addi	s0,sp,48
    80000e46:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000e48:	84aa                	mv	s1,a0
    80000e4a:	6905                	lui	s2,0x1
    80000e4c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000e4e:	4985                	li	s3,1
    80000e50:	a821                	j	80000e68 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000e52:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000e54:	0532                	slli	a0,a0,0xc
    80000e56:	00000097          	auipc	ra,0x0
    80000e5a:	fe0080e7          	jalr	-32(ra) # 80000e36 <freewalk>
      pagetable[i] = 0;
    80000e5e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000e62:	04a1                	addi	s1,s1,8
    80000e64:	03248b63          	beq	s1,s2,80000e9a <freewalk+0x64>
    pte_t pte = pagetable[i];
    80000e68:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000e6a:	00f57793          	andi	a5,a0,15
    80000e6e:	ff3782e3          	beq	a5,s3,80000e52 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000e72:	00157793          	andi	a5,a0,1
    80000e76:	d7f5                	beqz	a5,80000e62 <freewalk+0x2c>
      printf("pte:%p",pte);
    80000e78:	85aa                	mv	a1,a0
    80000e7a:	00006517          	auipc	a0,0x6
    80000e7e:	33e50513          	addi	a0,a0,830 # 800071b8 <userret+0x128>
    80000e82:	fffff097          	auipc	ra,0xfffff
    80000e86:	716080e7          	jalr	1814(ra) # 80000598 <printf>
      panic("freewalk: leaf");
    80000e8a:	00006517          	auipc	a0,0x6
    80000e8e:	33650513          	addi	a0,a0,822 # 800071c0 <userret+0x130>
    80000e92:	fffff097          	auipc	ra,0xfffff
    80000e96:	6bc080e7          	jalr	1724(ra) # 8000054e <panic>
    }
  }
  kfree((void*)pagetable);
    80000e9a:	8552                	mv	a0,s4
    80000e9c:	00000097          	auipc	ra,0x0
    80000ea0:	9c8080e7          	jalr	-1592(ra) # 80000864 <kfree>
}
    80000ea4:	70a2                	ld	ra,40(sp)
    80000ea6:	7402                	ld	s0,32(sp)
    80000ea8:	64e2                	ld	s1,24(sp)
    80000eaa:	6942                	ld	s2,16(sp)
    80000eac:	69a2                	ld	s3,8(sp)
    80000eae:	6a02                	ld	s4,0(sp)
    80000eb0:	6145                	addi	sp,sp,48
    80000eb2:	8082                	ret

0000000080000eb4 <kvminithart>:
{
    80000eb4:	1141                	addi	sp,sp,-16
    80000eb6:	e422                	sd	s0,8(sp)
    80000eb8:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000eba:	00025797          	auipc	a5,0x25
    80000ebe:	14e7b783          	ld	a5,334(a5) # 80026008 <kernel_pagetable>
    80000ec2:	83b1                	srli	a5,a5,0xc
    80000ec4:	577d                	li	a4,-1
    80000ec6:	177e                	slli	a4,a4,0x3f
    80000ec8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000eca:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000ece:	12000073          	sfence.vma
}
    80000ed2:	6422                	ld	s0,8(sp)
    80000ed4:	0141                	addi	sp,sp,16
    80000ed6:	8082                	ret

0000000080000ed8 <walk>:
{
    80000ed8:	7139                	addi	sp,sp,-64
    80000eda:	fc06                	sd	ra,56(sp)
    80000edc:	f822                	sd	s0,48(sp)
    80000ede:	f426                	sd	s1,40(sp)
    80000ee0:	f04a                	sd	s2,32(sp)
    80000ee2:	ec4e                	sd	s3,24(sp)
    80000ee4:	e852                	sd	s4,16(sp)
    80000ee6:	e456                	sd	s5,8(sp)
    80000ee8:	e05a                	sd	s6,0(sp)
    80000eea:	0080                	addi	s0,sp,64
    80000eec:	84aa                	mv	s1,a0
    80000eee:	89ae                	mv	s3,a1
    80000ef0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000ef2:	57fd                	li	a5,-1
    80000ef4:	83e9                	srli	a5,a5,0x1a
    80000ef6:	4a79                	li	s4,30
  for(int level = 2; level > 0; level--) {
    80000ef8:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000efa:	04b7f263          	bgeu	a5,a1,80000f3e <walk+0x66>
    panic("walk");
    80000efe:	00006517          	auipc	a0,0x6
    80000f02:	2d250513          	addi	a0,a0,722 # 800071d0 <userret+0x140>
    80000f06:	fffff097          	auipc	ra,0xfffff
    80000f0a:	648080e7          	jalr	1608(ra) # 8000054e <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f0e:	060a8663          	beqz	s5,80000f7a <walk+0xa2>
    80000f12:	00000097          	auipc	ra,0x0
    80000f16:	a4e080e7          	jalr	-1458(ra) # 80000960 <kalloc>
    80000f1a:	84aa                	mv	s1,a0
    80000f1c:	c529                	beqz	a0,80000f66 <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    80000f1e:	6605                	lui	a2,0x1
    80000f20:	4581                	li	a1,0
    80000f22:	00000097          	auipc	ra,0x0
    80000f26:	c4c080e7          	jalr	-948(ra) # 80000b6e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f2a:	00c4d793          	srli	a5,s1,0xc
    80000f2e:	07aa                	slli	a5,a5,0xa
    80000f30:	0017e793          	ori	a5,a5,1
    80000f34:	00f93023          	sd	a5,0(s2) # 1000 <_entry-0x7ffff000>
  for(int level = 2; level > 0; level--) {
    80000f38:	3a5d                	addiw	s4,s4,-9
    80000f3a:	036a0063          	beq	s4,s6,80000f5a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f3e:	0149d933          	srl	s2,s3,s4
    80000f42:	1ff97913          	andi	s2,s2,511
    80000f46:	090e                	slli	s2,s2,0x3
    80000f48:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f4a:	00093483          	ld	s1,0(s2)
    80000f4e:	0014f793          	andi	a5,s1,1
    80000f52:	dfd5                	beqz	a5,80000f0e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f54:	80a9                	srli	s1,s1,0xa
    80000f56:	04b2                	slli	s1,s1,0xc
    80000f58:	b7c5                	j	80000f38 <walk+0x60>
  return &pagetable[PX(0, va)];
    80000f5a:	00c9d513          	srli	a0,s3,0xc
    80000f5e:	1ff57513          	andi	a0,a0,511
    80000f62:	050e                	slli	a0,a0,0x3
    80000f64:	9526                	add	a0,a0,s1
}
    80000f66:	70e2                	ld	ra,56(sp)
    80000f68:	7442                	ld	s0,48(sp)
    80000f6a:	74a2                	ld	s1,40(sp)
    80000f6c:	7902                	ld	s2,32(sp)
    80000f6e:	69e2                	ld	s3,24(sp)
    80000f70:	6a42                	ld	s4,16(sp)
    80000f72:	6aa2                	ld	s5,8(sp)
    80000f74:	6b02                	ld	s6,0(sp)
    80000f76:	6121                	addi	sp,sp,64
    80000f78:	8082                	ret
        return 0;
    80000f7a:	4501                	li	a0,0
    80000f7c:	b7ed                	j	80000f66 <walk+0x8e>

0000000080000f7e <walkaddr>:
  if(va >= MAXVA)
    80000f7e:	57fd                	li	a5,-1
    80000f80:	83e9                	srli	a5,a5,0x1a
    80000f82:	00b7f463          	bgeu	a5,a1,80000f8a <walkaddr+0xc>
    return 0;
    80000f86:	4501                	li	a0,0
}
    80000f88:	8082                	ret
{
    80000f8a:	1141                	addi	sp,sp,-16
    80000f8c:	e406                	sd	ra,8(sp)
    80000f8e:	e022                	sd	s0,0(sp)
    80000f90:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000f92:	4601                	li	a2,0
    80000f94:	00000097          	auipc	ra,0x0
    80000f98:	f44080e7          	jalr	-188(ra) # 80000ed8 <walk>
  if(pte == 0)
    80000f9c:	c105                	beqz	a0,80000fbc <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000f9e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000fa0:	0117f693          	andi	a3,a5,17
    80000fa4:	4745                	li	a4,17
    return 0;
    80000fa6:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000fa8:	00e68663          	beq	a3,a4,80000fb4 <walkaddr+0x36>
}
    80000fac:	60a2                	ld	ra,8(sp)
    80000fae:	6402                	ld	s0,0(sp)
    80000fb0:	0141                	addi	sp,sp,16
    80000fb2:	8082                	ret
  pa = PTE2PA(*pte);
    80000fb4:	00a7d513          	srli	a0,a5,0xa
    80000fb8:	0532                	slli	a0,a0,0xc
  return pa;
    80000fba:	bfcd                	j	80000fac <walkaddr+0x2e>
    return 0;
    80000fbc:	4501                	li	a0,0
    80000fbe:	b7fd                	j	80000fac <walkaddr+0x2e>

0000000080000fc0 <kvmpa>:
{
    80000fc0:	1101                	addi	sp,sp,-32
    80000fc2:	ec06                	sd	ra,24(sp)
    80000fc4:	e822                	sd	s0,16(sp)
    80000fc6:	e426                	sd	s1,8(sp)
    80000fc8:	1000                	addi	s0,sp,32
    80000fca:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    80000fcc:	1552                	slli	a0,a0,0x34
    80000fce:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    80000fd2:	4601                	li	a2,0
    80000fd4:	00025517          	auipc	a0,0x25
    80000fd8:	03453503          	ld	a0,52(a0) # 80026008 <kernel_pagetable>
    80000fdc:	00000097          	auipc	ra,0x0
    80000fe0:	efc080e7          	jalr	-260(ra) # 80000ed8 <walk>
  if(pte == 0)
    80000fe4:	cd09                	beqz	a0,80000ffe <kvmpa+0x3e>
  if((*pte & PTE_V) == 0)
    80000fe6:	6108                	ld	a0,0(a0)
    80000fe8:	00157793          	andi	a5,a0,1
    80000fec:	c38d                	beqz	a5,8000100e <kvmpa+0x4e>
  pa = PTE2PA(*pte);
    80000fee:	8129                	srli	a0,a0,0xa
    80000ff0:	0532                	slli	a0,a0,0xc
}
    80000ff2:	9526                	add	a0,a0,s1
    80000ff4:	60e2                	ld	ra,24(sp)
    80000ff6:	6442                	ld	s0,16(sp)
    80000ff8:	64a2                	ld	s1,8(sp)
    80000ffa:	6105                	addi	sp,sp,32
    80000ffc:	8082                	ret
    panic("kvmpa");
    80000ffe:	00006517          	auipc	a0,0x6
    80001002:	1da50513          	addi	a0,a0,474 # 800071d8 <userret+0x148>
    80001006:	fffff097          	auipc	ra,0xfffff
    8000100a:	548080e7          	jalr	1352(ra) # 8000054e <panic>
    panic("kvmpa");
    8000100e:	00006517          	auipc	a0,0x6
    80001012:	1ca50513          	addi	a0,a0,458 # 800071d8 <userret+0x148>
    80001016:	fffff097          	auipc	ra,0xfffff
    8000101a:	538080e7          	jalr	1336(ra) # 8000054e <panic>

000000008000101e <mappages>:
{
    8000101e:	715d                	addi	sp,sp,-80
    80001020:	e486                	sd	ra,72(sp)
    80001022:	e0a2                	sd	s0,64(sp)
    80001024:	fc26                	sd	s1,56(sp)
    80001026:	f84a                	sd	s2,48(sp)
    80001028:	f44e                	sd	s3,40(sp)
    8000102a:	f052                	sd	s4,32(sp)
    8000102c:	ec56                	sd	s5,24(sp)
    8000102e:	e85a                	sd	s6,16(sp)
    80001030:	e45e                	sd	s7,8(sp)
    80001032:	0880                	addi	s0,sp,80
    80001034:	8aaa                	mv	s5,a0
    80001036:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    80001038:	777d                	lui	a4,0xfffff
    8000103a:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000103e:	167d                	addi	a2,a2,-1
    80001040:	00b609b3          	add	s3,a2,a1
    80001044:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001048:	893e                	mv	s2,a5
    8000104a:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    8000104e:	6b85                	lui	s7,0x1
    80001050:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001054:	4605                	li	a2,1
    80001056:	85ca                	mv	a1,s2
    80001058:	8556                	mv	a0,s5
    8000105a:	00000097          	auipc	ra,0x0
    8000105e:	e7e080e7          	jalr	-386(ra) # 80000ed8 <walk>
    80001062:	c51d                	beqz	a0,80001090 <mappages+0x72>
    if(*pte & PTE_V)
    80001064:	611c                	ld	a5,0(a0)
    80001066:	8b85                	andi	a5,a5,1
    80001068:	ef81                	bnez	a5,80001080 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000106a:	80b1                	srli	s1,s1,0xc
    8000106c:	04aa                	slli	s1,s1,0xa
    8000106e:	0164e4b3          	or	s1,s1,s6
    80001072:	0014e493          	ori	s1,s1,1
    80001076:	e104                	sd	s1,0(a0)
    if(a == last)
    80001078:	03390863          	beq	s2,s3,800010a8 <mappages+0x8a>
    a += PGSIZE;
    8000107c:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000107e:	bfc9                	j	80001050 <mappages+0x32>
      panic("remap");
    80001080:	00006517          	auipc	a0,0x6
    80001084:	16050513          	addi	a0,a0,352 # 800071e0 <userret+0x150>
    80001088:	fffff097          	auipc	ra,0xfffff
    8000108c:	4c6080e7          	jalr	1222(ra) # 8000054e <panic>
      return -1;
    80001090:	557d                	li	a0,-1
}
    80001092:	60a6                	ld	ra,72(sp)
    80001094:	6406                	ld	s0,64(sp)
    80001096:	74e2                	ld	s1,56(sp)
    80001098:	7942                	ld	s2,48(sp)
    8000109a:	79a2                	ld	s3,40(sp)
    8000109c:	7a02                	ld	s4,32(sp)
    8000109e:	6ae2                	ld	s5,24(sp)
    800010a0:	6b42                	ld	s6,16(sp)
    800010a2:	6ba2                	ld	s7,8(sp)
    800010a4:	6161                	addi	sp,sp,80
    800010a6:	8082                	ret
  return 0;
    800010a8:	4501                	li	a0,0
    800010aa:	b7e5                	j	80001092 <mappages+0x74>

00000000800010ac <kvmmap>:
{
    800010ac:	1141                	addi	sp,sp,-16
    800010ae:	e406                	sd	ra,8(sp)
    800010b0:	e022                	sd	s0,0(sp)
    800010b2:	0800                	addi	s0,sp,16
    800010b4:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800010b6:	86ae                	mv	a3,a1
    800010b8:	85aa                	mv	a1,a0
    800010ba:	00025517          	auipc	a0,0x25
    800010be:	f4e53503          	ld	a0,-178(a0) # 80026008 <kernel_pagetable>
    800010c2:	00000097          	auipc	ra,0x0
    800010c6:	f5c080e7          	jalr	-164(ra) # 8000101e <mappages>
    800010ca:	e509                	bnez	a0,800010d4 <kvmmap+0x28>
}
    800010cc:	60a2                	ld	ra,8(sp)
    800010ce:	6402                	ld	s0,0(sp)
    800010d0:	0141                	addi	sp,sp,16
    800010d2:	8082                	ret
    panic("kvmmap");
    800010d4:	00006517          	auipc	a0,0x6
    800010d8:	11450513          	addi	a0,a0,276 # 800071e8 <userret+0x158>
    800010dc:	fffff097          	auipc	ra,0xfffff
    800010e0:	472080e7          	jalr	1138(ra) # 8000054e <panic>

00000000800010e4 <kvminit>:
{
    800010e4:	1101                	addi	sp,sp,-32
    800010e6:	ec06                	sd	ra,24(sp)
    800010e8:	e822                	sd	s0,16(sp)
    800010ea:	e426                	sd	s1,8(sp)
    800010ec:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	872080e7          	jalr	-1934(ra) # 80000960 <kalloc>
    800010f6:	00025797          	auipc	a5,0x25
    800010fa:	f0a7b923          	sd	a0,-238(a5) # 80026008 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    800010fe:	6605                	lui	a2,0x1
    80001100:	4581                	li	a1,0
    80001102:	00000097          	auipc	ra,0x0
    80001106:	a6c080e7          	jalr	-1428(ra) # 80000b6e <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000110a:	4699                	li	a3,6
    8000110c:	6605                	lui	a2,0x1
    8000110e:	100005b7          	lui	a1,0x10000
    80001112:	10000537          	lui	a0,0x10000
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	f96080e7          	jalr	-106(ra) # 800010ac <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000111e:	4699                	li	a3,6
    80001120:	6605                	lui	a2,0x1
    80001122:	100015b7          	lui	a1,0x10001
    80001126:	10001537          	lui	a0,0x10001
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f82080e7          	jalr	-126(ra) # 800010ac <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001132:	4699                	li	a3,6
    80001134:	6641                	lui	a2,0x10
    80001136:	020005b7          	lui	a1,0x2000
    8000113a:	02000537          	lui	a0,0x2000
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	f6e080e7          	jalr	-146(ra) # 800010ac <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001146:	4699                	li	a3,6
    80001148:	00400637          	lui	a2,0x400
    8000114c:	0c0005b7          	lui	a1,0xc000
    80001150:	0c000537          	lui	a0,0xc000
    80001154:	00000097          	auipc	ra,0x0
    80001158:	f58080e7          	jalr	-168(ra) # 800010ac <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000115c:	00007497          	auipc	s1,0x7
    80001160:	ea448493          	addi	s1,s1,-348 # 80008000 <initcode>
    80001164:	46a9                	li	a3,10
    80001166:	80007617          	auipc	a2,0x80007
    8000116a:	e9a60613          	addi	a2,a2,-358 # 8000 <_entry-0x7fff8000>
    8000116e:	4585                	li	a1,1
    80001170:	05fe                	slli	a1,a1,0x1f
    80001172:	852e                	mv	a0,a1
    80001174:	00000097          	auipc	ra,0x0
    80001178:	f38080e7          	jalr	-200(ra) # 800010ac <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000117c:	4699                	li	a3,6
    8000117e:	4645                	li	a2,17
    80001180:	066e                	slli	a2,a2,0x1b
    80001182:	8e05                	sub	a2,a2,s1
    80001184:	85a6                	mv	a1,s1
    80001186:	8526                	mv	a0,s1
    80001188:	00000097          	auipc	ra,0x0
    8000118c:	f24080e7          	jalr	-220(ra) # 800010ac <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001190:	46a9                	li	a3,10
    80001192:	6605                	lui	a2,0x1
    80001194:	00006597          	auipc	a1,0x6
    80001198:	e6c58593          	addi	a1,a1,-404 # 80007000 <trampoline>
    8000119c:	04000537          	lui	a0,0x4000
    800011a0:	157d                	addi	a0,a0,-1
    800011a2:	0532                	slli	a0,a0,0xc
    800011a4:	00000097          	auipc	ra,0x0
    800011a8:	f08080e7          	jalr	-248(ra) # 800010ac <kvmmap>
}
    800011ac:	60e2                	ld	ra,24(sp)
    800011ae:	6442                	ld	s0,16(sp)
    800011b0:	64a2                	ld	s1,8(sp)
    800011b2:	6105                	addi	sp,sp,32
    800011b4:	8082                	ret

00000000800011b6 <uvmunmap>:
{
    800011b6:	715d                	addi	sp,sp,-80
    800011b8:	e486                	sd	ra,72(sp)
    800011ba:	e0a2                	sd	s0,64(sp)
    800011bc:	fc26                	sd	s1,56(sp)
    800011be:	f84a                	sd	s2,48(sp)
    800011c0:	f44e                	sd	s3,40(sp)
    800011c2:	f052                	sd	s4,32(sp)
    800011c4:	ec56                	sd	s5,24(sp)
    800011c6:	e85a                	sd	s6,16(sp)
    800011c8:	e45e                	sd	s7,8(sp)
    800011ca:	0880                	addi	s0,sp,80
    800011cc:	8a2a                	mv	s4,a0
    800011ce:	8ab6                	mv	s5,a3
  a = PGROUNDDOWN(va);
    800011d0:	77fd                	lui	a5,0xfffff
    800011d2:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800011d6:	167d                	addi	a2,a2,-1
    800011d8:	00b609b3          	add	s3,a2,a1
    800011dc:	00f9f9b3          	and	s3,s3,a5
    if(PTE_FLAGS(*pte) == PTE_V)
    800011e0:	4b05                	li	s6,1
    a += PGSIZE;
    800011e2:	6b85                	lui	s7,0x1
    800011e4:	a0a1                	j	8000122c <uvmunmap+0x76>
      panic("uvmunmap: walk");
    800011e6:	00006517          	auipc	a0,0x6
    800011ea:	00a50513          	addi	a0,a0,10 # 800071f0 <userret+0x160>
    800011ee:	fffff097          	auipc	ra,0xfffff
    800011f2:	360080e7          	jalr	864(ra) # 8000054e <panic>
      panic("uvmunmap: not mapped");
    800011f6:	00006517          	auipc	a0,0x6
    800011fa:	00a50513          	addi	a0,a0,10 # 80007200 <userret+0x170>
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	350080e7          	jalr	848(ra) # 8000054e <panic>
      panic("uvmunmap: not a leaf");
    80001206:	00006517          	auipc	a0,0x6
    8000120a:	01250513          	addi	a0,a0,18 # 80007218 <userret+0x188>
    8000120e:	fffff097          	auipc	ra,0xfffff
    80001212:	340080e7          	jalr	832(ra) # 8000054e <panic>
      pa = PTE2PA(*pte);
    80001216:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001218:	0532                	slli	a0,a0,0xc
    8000121a:	fffff097          	auipc	ra,0xfffff
    8000121e:	64a080e7          	jalr	1610(ra) # 80000864 <kfree>
    *pte = 0;
    80001222:	0004b023          	sd	zero,0(s1)
    if(a == last)
    80001226:	03390763          	beq	s2,s3,80001254 <uvmunmap+0x9e>
    a += PGSIZE;
    8000122a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 0)) == 0)
    8000122c:	4601                	li	a2,0
    8000122e:	85ca                	mv	a1,s2
    80001230:	8552                	mv	a0,s4
    80001232:	00000097          	auipc	ra,0x0
    80001236:	ca6080e7          	jalr	-858(ra) # 80000ed8 <walk>
    8000123a:	84aa                	mv	s1,a0
    8000123c:	d54d                	beqz	a0,800011e6 <uvmunmap+0x30>
    if((*pte & PTE_V) == 0){
    8000123e:	6108                	ld	a0,0(a0)
    80001240:	00157793          	andi	a5,a0,1
    80001244:	dbcd                	beqz	a5,800011f6 <uvmunmap+0x40>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001246:	3ff57793          	andi	a5,a0,1023
    8000124a:	fb678ee3          	beq	a5,s6,80001206 <uvmunmap+0x50>
    if(do_free){
    8000124e:	fc0a8ae3          	beqz	s5,80001222 <uvmunmap+0x6c>
    80001252:	b7d1                	j	80001216 <uvmunmap+0x60>
}
    80001254:	60a6                	ld	ra,72(sp)
    80001256:	6406                	ld	s0,64(sp)
    80001258:	74e2                	ld	s1,56(sp)
    8000125a:	7942                	ld	s2,48(sp)
    8000125c:	79a2                	ld	s3,40(sp)
    8000125e:	7a02                	ld	s4,32(sp)
    80001260:	6ae2                	ld	s5,24(sp)
    80001262:	6b42                	ld	s6,16(sp)
    80001264:	6ba2                	ld	s7,8(sp)
    80001266:	6161                	addi	sp,sp,80
    80001268:	8082                	ret

000000008000126a <uvmcreate>:
{
    8000126a:	1101                	addi	sp,sp,-32
    8000126c:	ec06                	sd	ra,24(sp)
    8000126e:	e822                	sd	s0,16(sp)
    80001270:	e426                	sd	s1,8(sp)
    80001272:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    80001274:	fffff097          	auipc	ra,0xfffff
    80001278:	6ec080e7          	jalr	1772(ra) # 80000960 <kalloc>
  if(pagetable == 0)
    8000127c:	cd11                	beqz	a0,80001298 <uvmcreate+0x2e>
    8000127e:	84aa                	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
    80001280:	6605                	lui	a2,0x1
    80001282:	4581                	li	a1,0
    80001284:	00000097          	auipc	ra,0x0
    80001288:	8ea080e7          	jalr	-1814(ra) # 80000b6e <memset>
}
    8000128c:	8526                	mv	a0,s1
    8000128e:	60e2                	ld	ra,24(sp)
    80001290:	6442                	ld	s0,16(sp)
    80001292:	64a2                	ld	s1,8(sp)
    80001294:	6105                	addi	sp,sp,32
    80001296:	8082                	ret
    panic("uvmcreate: out of memory");
    80001298:	00006517          	auipc	a0,0x6
    8000129c:	f9850513          	addi	a0,a0,-104 # 80007230 <userret+0x1a0>
    800012a0:	fffff097          	auipc	ra,0xfffff
    800012a4:	2ae080e7          	jalr	686(ra) # 8000054e <panic>

00000000800012a8 <uvminit>:
{
    800012a8:	7179                	addi	sp,sp,-48
    800012aa:	f406                	sd	ra,40(sp)
    800012ac:	f022                	sd	s0,32(sp)
    800012ae:	ec26                	sd	s1,24(sp)
    800012b0:	e84a                	sd	s2,16(sp)
    800012b2:	e44e                	sd	s3,8(sp)
    800012b4:	e052                	sd	s4,0(sp)
    800012b6:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    800012b8:	6785                	lui	a5,0x1
    800012ba:	04f67863          	bgeu	a2,a5,8000130a <uvminit+0x62>
    800012be:	8a2a                	mv	s4,a0
    800012c0:	89ae                	mv	s3,a1
    800012c2:	84b2                	mv	s1,a2
  mem = kalloc();
    800012c4:	fffff097          	auipc	ra,0xfffff
    800012c8:	69c080e7          	jalr	1692(ra) # 80000960 <kalloc>
    800012cc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012ce:	6605                	lui	a2,0x1
    800012d0:	4581                	li	a1,0
    800012d2:	00000097          	auipc	ra,0x0
    800012d6:	89c080e7          	jalr	-1892(ra) # 80000b6e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012da:	4779                	li	a4,30
    800012dc:	86ca                	mv	a3,s2
    800012de:	6605                	lui	a2,0x1
    800012e0:	4581                	li	a1,0
    800012e2:	8552                	mv	a0,s4
    800012e4:	00000097          	auipc	ra,0x0
    800012e8:	d3a080e7          	jalr	-710(ra) # 8000101e <mappages>
  memmove(mem, src, sz);
    800012ec:	8626                	mv	a2,s1
    800012ee:	85ce                	mv	a1,s3
    800012f0:	854a                	mv	a0,s2
    800012f2:	00000097          	auipc	ra,0x0
    800012f6:	8dc080e7          	jalr	-1828(ra) # 80000bce <memmove>
}
    800012fa:	70a2                	ld	ra,40(sp)
    800012fc:	7402                	ld	s0,32(sp)
    800012fe:	64e2                	ld	s1,24(sp)
    80001300:	6942                	ld	s2,16(sp)
    80001302:	69a2                	ld	s3,8(sp)
    80001304:	6a02                	ld	s4,0(sp)
    80001306:	6145                	addi	sp,sp,48
    80001308:	8082                	ret
    panic("inituvm: more than a page");
    8000130a:	00006517          	auipc	a0,0x6
    8000130e:	f4650513          	addi	a0,a0,-186 # 80007250 <userret+0x1c0>
    80001312:	fffff097          	auipc	ra,0xfffff
    80001316:	23c080e7          	jalr	572(ra) # 8000054e <panic>

000000008000131a <uvmdealloc>:
{
    8000131a:	1101                	addi	sp,sp,-32
    8000131c:	ec06                	sd	ra,24(sp)
    8000131e:	e822                	sd	s0,16(sp)
    80001320:	e426                	sd	s1,8(sp)
    80001322:	1000                	addi	s0,sp,32
    return oldsz;
    80001324:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001326:	00b67d63          	bgeu	a2,a1,80001340 <uvmdealloc+0x26>
    8000132a:	84b2                	mv	s1,a2
  uint64 newup = PGROUNDUP(newsz);
    8000132c:	6785                	lui	a5,0x1
    8000132e:	17fd                	addi	a5,a5,-1
    80001330:	00f60733          	add	a4,a2,a5
    80001334:	76fd                	lui	a3,0xfffff
    80001336:	8f75                	and	a4,a4,a3
  if(newup < PGROUNDUP(oldsz)){
    80001338:	97ae                	add	a5,a5,a1
    8000133a:	8ff5                	and	a5,a5,a3
    8000133c:	00f76863          	bltu	a4,a5,8000134c <uvmdealloc+0x32>
}
    80001340:	8526                	mv	a0,s1
    80001342:	60e2                	ld	ra,24(sp)
    80001344:	6442                	ld	s0,16(sp)
    80001346:	64a2                	ld	s1,8(sp)
    80001348:	6105                	addi	sp,sp,32
    8000134a:	8082                	ret
    uvmunmap(pagetable, newup, oldsz - newup, 1);
    8000134c:	4685                	li	a3,1
    8000134e:	40e58633          	sub	a2,a1,a4
    80001352:	85ba                	mv	a1,a4
    80001354:	00000097          	auipc	ra,0x0
    80001358:	e62080e7          	jalr	-414(ra) # 800011b6 <uvmunmap>
    8000135c:	b7d5                	j	80001340 <uvmdealloc+0x26>

000000008000135e <uvmalloc>:
  if(newsz < oldsz)
    8000135e:	0ab66163          	bltu	a2,a1,80001400 <uvmalloc+0xa2>
{
    80001362:	7139                	addi	sp,sp,-64
    80001364:	fc06                	sd	ra,56(sp)
    80001366:	f822                	sd	s0,48(sp)
    80001368:	f426                	sd	s1,40(sp)
    8000136a:	f04a                	sd	s2,32(sp)
    8000136c:	ec4e                	sd	s3,24(sp)
    8000136e:	e852                	sd	s4,16(sp)
    80001370:	e456                	sd	s5,8(sp)
    80001372:	0080                	addi	s0,sp,64
    80001374:	8aaa                	mv	s5,a0
    80001376:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);  //PGROUNDUP(sz)  (((sz)+PGSIZE-1) & ~(PGSIZE-1))
    80001378:	6985                	lui	s3,0x1
    8000137a:	19fd                	addi	s3,s3,-1
    8000137c:	95ce                	add	a1,a1,s3
    8000137e:	79fd                	lui	s3,0xfffff
    80001380:	0135f9b3          	and	s3,a1,s3
  for(; a < newsz; a += PGSIZE){
    80001384:	08c9f063          	bgeu	s3,a2,80001404 <uvmalloc+0xa6>
  a = oldsz;
    80001388:	894e                	mv	s2,s3
    mem = kalloc();
    8000138a:	fffff097          	auipc	ra,0xfffff
    8000138e:	5d6080e7          	jalr	1494(ra) # 80000960 <kalloc>
    80001392:	84aa                	mv	s1,a0
    if(mem == 0){
    80001394:	c51d                	beqz	a0,800013c2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001396:	6605                	lui	a2,0x1
    80001398:	4581                	li	a1,0
    8000139a:	fffff097          	auipc	ra,0xfffff
    8000139e:	7d4080e7          	jalr	2004(ra) # 80000b6e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){  //mappages(pagetable, va, sz, pa, perm)
    800013a2:	4779                	li	a4,30
    800013a4:	86a6                	mv	a3,s1
    800013a6:	6605                	lui	a2,0x1
    800013a8:	85ca                	mv	a1,s2
    800013aa:	8556                	mv	a0,s5
    800013ac:	00000097          	auipc	ra,0x0
    800013b0:	c72080e7          	jalr	-910(ra) # 8000101e <mappages>
    800013b4:	e905                	bnez	a0,800013e4 <uvmalloc+0x86>
  for(; a < newsz; a += PGSIZE){
    800013b6:	6785                	lui	a5,0x1
    800013b8:	993e                	add	s2,s2,a5
    800013ba:	fd4968e3          	bltu	s2,s4,8000138a <uvmalloc+0x2c>
  return newsz;
    800013be:	8552                	mv	a0,s4
    800013c0:	a809                	j	800013d2 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800013c2:	864e                	mv	a2,s3
    800013c4:	85ca                	mv	a1,s2
    800013c6:	8556                	mv	a0,s5
    800013c8:	00000097          	auipc	ra,0x0
    800013cc:	f52080e7          	jalr	-174(ra) # 8000131a <uvmdealloc>
      return 0;
    800013d0:	4501                	li	a0,0
}
    800013d2:	70e2                	ld	ra,56(sp)
    800013d4:	7442                	ld	s0,48(sp)
    800013d6:	74a2                	ld	s1,40(sp)
    800013d8:	7902                	ld	s2,32(sp)
    800013da:	69e2                	ld	s3,24(sp)
    800013dc:	6a42                	ld	s4,16(sp)
    800013de:	6aa2                	ld	s5,8(sp)
    800013e0:	6121                	addi	sp,sp,64
    800013e2:	8082                	ret
      kfree(mem);
    800013e4:	8526                	mv	a0,s1
    800013e6:	fffff097          	auipc	ra,0xfffff
    800013ea:	47e080e7          	jalr	1150(ra) # 80000864 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013ee:	864e                	mv	a2,s3
    800013f0:	85ca                	mv	a1,s2
    800013f2:	8556                	mv	a0,s5
    800013f4:	00000097          	auipc	ra,0x0
    800013f8:	f26080e7          	jalr	-218(ra) # 8000131a <uvmdealloc>
      return 0;
    800013fc:	4501                	li	a0,0
    800013fe:	bfd1                	j	800013d2 <uvmalloc+0x74>
    return oldsz;
    80001400:	852e                	mv	a0,a1
}
    80001402:	8082                	ret
  return newsz;
    80001404:	8532                	mv	a0,a2
    80001406:	b7f1                	j	800013d2 <uvmalloc+0x74>

0000000080001408 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001408:	1101                	addi	sp,sp,-32
    8000140a:	ec06                	sd	ra,24(sp)
    8000140c:	e822                	sd	s0,16(sp)
    8000140e:	e426                	sd	s1,8(sp)
    80001410:	1000                	addi	s0,sp,32
    80001412:	84aa                	mv	s1,a0
    80001414:	862e                	mv	a2,a1
  uvmunmap(pagetable, 0, sz, 1);
    80001416:	4685                	li	a3,1
    80001418:	4581                	li	a1,0
    8000141a:	00000097          	auipc	ra,0x0
    8000141e:	d9c080e7          	jalr	-612(ra) # 800011b6 <uvmunmap>
  freewalk(pagetable);
    80001422:	8526                	mv	a0,s1
    80001424:	00000097          	auipc	ra,0x0
    80001428:	a12080e7          	jalr	-1518(ra) # 80000e36 <freewalk>
}
    8000142c:	60e2                	ld	ra,24(sp)
    8000142e:	6442                	ld	s0,16(sp)
    80001430:	64a2                	ld	s1,8(sp)
    80001432:	6105                	addi	sp,sp,32
    80001434:	8082                	ret

0000000080001436 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001436:	c671                	beqz	a2,80001502 <uvmcopy+0xcc>
{
    80001438:	715d                	addi	sp,sp,-80
    8000143a:	e486                	sd	ra,72(sp)
    8000143c:	e0a2                	sd	s0,64(sp)
    8000143e:	fc26                	sd	s1,56(sp)
    80001440:	f84a                	sd	s2,48(sp)
    80001442:	f44e                	sd	s3,40(sp)
    80001444:	f052                	sd	s4,32(sp)
    80001446:	ec56                	sd	s5,24(sp)
    80001448:	e85a                	sd	s6,16(sp)
    8000144a:	e45e                	sd	s7,8(sp)
    8000144c:	0880                	addi	s0,sp,80
    8000144e:	8b2a                	mv	s6,a0
    80001450:	8aae                	mv	s5,a1
    80001452:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001454:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001456:	4601                	li	a2,0
    80001458:	85ce                	mv	a1,s3
    8000145a:	855a                	mv	a0,s6
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	a7c080e7          	jalr	-1412(ra) # 80000ed8 <walk>
    80001464:	c531                	beqz	a0,800014b0 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0){
    80001466:	6118                	ld	a4,0(a0)
    80001468:	00177793          	andi	a5,a4,1
    8000146c:	cbb1                	beqz	a5,800014c0 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    }
    pa = PTE2PA(*pte);
    8000146e:	00a75593          	srli	a1,a4,0xa
    80001472:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001476:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000147a:	fffff097          	auipc	ra,0xfffff
    8000147e:	4e6080e7          	jalr	1254(ra) # 80000960 <kalloc>
    80001482:	892a                	mv	s2,a0
    80001484:	c939                	beqz	a0,800014da <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001486:	6605                	lui	a2,0x1
    80001488:	85de                	mv	a1,s7
    8000148a:	fffff097          	auipc	ra,0xfffff
    8000148e:	744080e7          	jalr	1860(ra) # 80000bce <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001492:	8726                	mv	a4,s1
    80001494:	86ca                	mv	a3,s2
    80001496:	6605                	lui	a2,0x1
    80001498:	85ce                	mv	a1,s3
    8000149a:	8556                	mv	a0,s5
    8000149c:	00000097          	auipc	ra,0x0
    800014a0:	b82080e7          	jalr	-1150(ra) # 8000101e <mappages>
    800014a4:	e515                	bnez	a0,800014d0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800014a6:	6785                	lui	a5,0x1
    800014a8:	99be                	add	s3,s3,a5
    800014aa:	fb49e6e3          	bltu	s3,s4,80001456 <uvmcopy+0x20>
    800014ae:	a83d                	j	800014ec <uvmcopy+0xb6>
      panic("uvmcopy: pte should exist");
    800014b0:	00006517          	auipc	a0,0x6
    800014b4:	dc050513          	addi	a0,a0,-576 # 80007270 <userret+0x1e0>
    800014b8:	fffff097          	auipc	ra,0xfffff
    800014bc:	096080e7          	jalr	150(ra) # 8000054e <panic>
      panic("uvmcopy: page not present");
    800014c0:	00006517          	auipc	a0,0x6
    800014c4:	dd050513          	addi	a0,a0,-560 # 80007290 <userret+0x200>
    800014c8:	fffff097          	auipc	ra,0xfffff
    800014cc:	086080e7          	jalr	134(ra) # 8000054e <panic>
      kfree(mem);
    800014d0:	854a                	mv	a0,s2
    800014d2:	fffff097          	auipc	ra,0xfffff
    800014d6:	392080e7          	jalr	914(ra) # 80000864 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
    800014da:	4685                	li	a3,1
    800014dc:	864e                	mv	a2,s3
    800014de:	4581                	li	a1,0
    800014e0:	8556                	mv	a0,s5
    800014e2:	00000097          	auipc	ra,0x0
    800014e6:	cd4080e7          	jalr	-812(ra) # 800011b6 <uvmunmap>
  return -1;
    800014ea:	557d                	li	a0,-1
}
    800014ec:	60a6                	ld	ra,72(sp)
    800014ee:	6406                	ld	s0,64(sp)
    800014f0:	74e2                	ld	s1,56(sp)
    800014f2:	7942                	ld	s2,48(sp)
    800014f4:	79a2                	ld	s3,40(sp)
    800014f6:	7a02                	ld	s4,32(sp)
    800014f8:	6ae2                	ld	s5,24(sp)
    800014fa:	6b42                	ld	s6,16(sp)
    800014fc:	6ba2                	ld	s7,8(sp)
    800014fe:	6161                	addi	sp,sp,80
    80001500:	8082                	ret
  return 0;
    80001502:	4501                	li	a0,0
}
    80001504:	8082                	ret

0000000080001506 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001506:	1141                	addi	sp,sp,-16
    80001508:	e406                	sd	ra,8(sp)
    8000150a:	e022                	sd	s0,0(sp)
    8000150c:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000150e:	4601                	li	a2,0
    80001510:	00000097          	auipc	ra,0x0
    80001514:	9c8080e7          	jalr	-1592(ra) # 80000ed8 <walk>
  if(pte == 0)
    80001518:	c901                	beqz	a0,80001528 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000151a:	611c                	ld	a5,0(a0)
    8000151c:	9bbd                	andi	a5,a5,-17
    8000151e:	e11c                	sd	a5,0(a0)
}
    80001520:	60a2                	ld	ra,8(sp)
    80001522:	6402                	ld	s0,0(sp)
    80001524:	0141                	addi	sp,sp,16
    80001526:	8082                	ret
    panic("uvmclear");
    80001528:	00006517          	auipc	a0,0x6
    8000152c:	d8850513          	addi	a0,a0,-632 # 800072b0 <userret+0x220>
    80001530:	fffff097          	auipc	ra,0xfffff
    80001534:	01e080e7          	jalr	30(ra) # 8000054e <panic>

0000000080001538 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001538:	c6bd                	beqz	a3,800015a6 <copyout+0x6e>
{
    8000153a:	715d                	addi	sp,sp,-80
    8000153c:	e486                	sd	ra,72(sp)
    8000153e:	e0a2                	sd	s0,64(sp)
    80001540:	fc26                	sd	s1,56(sp)
    80001542:	f84a                	sd	s2,48(sp)
    80001544:	f44e                	sd	s3,40(sp)
    80001546:	f052                	sd	s4,32(sp)
    80001548:	ec56                	sd	s5,24(sp)
    8000154a:	e85a                	sd	s6,16(sp)
    8000154c:	e45e                	sd	s7,8(sp)
    8000154e:	e062                	sd	s8,0(sp)
    80001550:	0880                	addi	s0,sp,80
    80001552:	8b2a                	mv	s6,a0
    80001554:	8c2e                	mv	s8,a1
    80001556:	8a32                	mv	s4,a2
    80001558:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000155a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000155c:	6a85                	lui	s5,0x1
    8000155e:	a015                	j	80001582 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001560:	9562                	add	a0,a0,s8
    80001562:	0004861b          	sext.w	a2,s1
    80001566:	85d2                	mv	a1,s4
    80001568:	41250533          	sub	a0,a0,s2
    8000156c:	fffff097          	auipc	ra,0xfffff
    80001570:	662080e7          	jalr	1634(ra) # 80000bce <memmove>

    len -= n;
    80001574:	409989b3          	sub	s3,s3,s1
    src += n;
    80001578:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000157a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000157e:	02098263          	beqz	s3,800015a2 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001582:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001586:	85ca                	mv	a1,s2
    80001588:	855a                	mv	a0,s6
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	9f4080e7          	jalr	-1548(ra) # 80000f7e <walkaddr>
    if(pa0 == 0)
    80001592:	cd01                	beqz	a0,800015aa <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001594:	418904b3          	sub	s1,s2,s8
    80001598:	94d6                	add	s1,s1,s5
    if(n > len)
    8000159a:	fc99f3e3          	bgeu	s3,s1,80001560 <copyout+0x28>
    8000159e:	84ce                	mv	s1,s3
    800015a0:	b7c1                	j	80001560 <copyout+0x28>
  }
  return 0;
    800015a2:	4501                	li	a0,0
    800015a4:	a021                	j	800015ac <copyout+0x74>
    800015a6:	4501                	li	a0,0
}
    800015a8:	8082                	ret
      return -1;
    800015aa:	557d                	li	a0,-1
}
    800015ac:	60a6                	ld	ra,72(sp)
    800015ae:	6406                	ld	s0,64(sp)
    800015b0:	74e2                	ld	s1,56(sp)
    800015b2:	7942                	ld	s2,48(sp)
    800015b4:	79a2                	ld	s3,40(sp)
    800015b6:	7a02                	ld	s4,32(sp)
    800015b8:	6ae2                	ld	s5,24(sp)
    800015ba:	6b42                	ld	s6,16(sp)
    800015bc:	6ba2                	ld	s7,8(sp)
    800015be:	6c02                	ld	s8,0(sp)
    800015c0:	6161                	addi	sp,sp,80
    800015c2:	8082                	ret

00000000800015c4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800015c4:	c6bd                	beqz	a3,80001632 <copyin+0x6e>
{
    800015c6:	715d                	addi	sp,sp,-80
    800015c8:	e486                	sd	ra,72(sp)
    800015ca:	e0a2                	sd	s0,64(sp)
    800015cc:	fc26                	sd	s1,56(sp)
    800015ce:	f84a                	sd	s2,48(sp)
    800015d0:	f44e                	sd	s3,40(sp)
    800015d2:	f052                	sd	s4,32(sp)
    800015d4:	ec56                	sd	s5,24(sp)
    800015d6:	e85a                	sd	s6,16(sp)
    800015d8:	e45e                	sd	s7,8(sp)
    800015da:	e062                	sd	s8,0(sp)
    800015dc:	0880                	addi	s0,sp,80
    800015de:	8b2a                	mv	s6,a0
    800015e0:	8a2e                	mv	s4,a1
    800015e2:	8c32                	mv	s8,a2
    800015e4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800015e6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800015e8:	6a85                	lui	s5,0x1
    800015ea:	a015                	j	8000160e <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800015ec:	9562                	add	a0,a0,s8
    800015ee:	0004861b          	sext.w	a2,s1
    800015f2:	412505b3          	sub	a1,a0,s2
    800015f6:	8552                	mv	a0,s4
    800015f8:	fffff097          	auipc	ra,0xfffff
    800015fc:	5d6080e7          	jalr	1494(ra) # 80000bce <memmove>

    len -= n;
    80001600:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001604:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001606:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000160a:	02098263          	beqz	s3,8000162e <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    8000160e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001612:	85ca                	mv	a1,s2
    80001614:	855a                	mv	a0,s6
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	968080e7          	jalr	-1688(ra) # 80000f7e <walkaddr>
    if(pa0 == 0)
    8000161e:	cd01                	beqz	a0,80001636 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80001620:	418904b3          	sub	s1,s2,s8
    80001624:	94d6                	add	s1,s1,s5
    if(n > len)
    80001626:	fc99f3e3          	bgeu	s3,s1,800015ec <copyin+0x28>
    8000162a:	84ce                	mv	s1,s3
    8000162c:	b7c1                	j	800015ec <copyin+0x28>
  }
  return 0;
    8000162e:	4501                	li	a0,0
    80001630:	a021                	j	80001638 <copyin+0x74>
    80001632:	4501                	li	a0,0
}
    80001634:	8082                	ret
      return -1;
    80001636:	557d                	li	a0,-1
}
    80001638:	60a6                	ld	ra,72(sp)
    8000163a:	6406                	ld	s0,64(sp)
    8000163c:	74e2                	ld	s1,56(sp)
    8000163e:	7942                	ld	s2,48(sp)
    80001640:	79a2                	ld	s3,40(sp)
    80001642:	7a02                	ld	s4,32(sp)
    80001644:	6ae2                	ld	s5,24(sp)
    80001646:	6b42                	ld	s6,16(sp)
    80001648:	6ba2                	ld	s7,8(sp)
    8000164a:	6c02                	ld	s8,0(sp)
    8000164c:	6161                	addi	sp,sp,80
    8000164e:	8082                	ret

0000000080001650 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001650:	c6c5                	beqz	a3,800016f8 <copyinstr+0xa8>
{
    80001652:	715d                	addi	sp,sp,-80
    80001654:	e486                	sd	ra,72(sp)
    80001656:	e0a2                	sd	s0,64(sp)
    80001658:	fc26                	sd	s1,56(sp)
    8000165a:	f84a                	sd	s2,48(sp)
    8000165c:	f44e                	sd	s3,40(sp)
    8000165e:	f052                	sd	s4,32(sp)
    80001660:	ec56                	sd	s5,24(sp)
    80001662:	e85a                	sd	s6,16(sp)
    80001664:	e45e                	sd	s7,8(sp)
    80001666:	0880                	addi	s0,sp,80
    80001668:	8a2a                	mv	s4,a0
    8000166a:	8b2e                	mv	s6,a1
    8000166c:	8bb2                	mv	s7,a2
    8000166e:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001670:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001672:	6985                	lui	s3,0x1
    80001674:	a035                	j	800016a0 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001676:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000167a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000167c:	0017b793          	seqz	a5,a5
    80001680:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
    80001684:	60a6                	ld	ra,72(sp)
    80001686:	6406                	ld	s0,64(sp)
    80001688:	74e2                	ld	s1,56(sp)
    8000168a:	7942                	ld	s2,48(sp)
    8000168c:	79a2                	ld	s3,40(sp)
    8000168e:	7a02                	ld	s4,32(sp)
    80001690:	6ae2                	ld	s5,24(sp)
    80001692:	6b42                	ld	s6,16(sp)
    80001694:	6ba2                	ld	s7,8(sp)
    80001696:	6161                	addi	sp,sp,80
    80001698:	8082                	ret
    srcva = va0 + PGSIZE;
    8000169a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    8000169e:	c8a9                	beqz	s1,800016f0 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800016a0:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800016a4:	85ca                	mv	a1,s2
    800016a6:	8552                	mv	a0,s4
    800016a8:	00000097          	auipc	ra,0x0
    800016ac:	8d6080e7          	jalr	-1834(ra) # 80000f7e <walkaddr>
    if(pa0 == 0)
    800016b0:	c131                	beqz	a0,800016f4 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800016b2:	41790833          	sub	a6,s2,s7
    800016b6:	984e                	add	a6,a6,s3
    if(n > max)
    800016b8:	0104f363          	bgeu	s1,a6,800016be <copyinstr+0x6e>
    800016bc:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800016be:	955e                	add	a0,a0,s7
    800016c0:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800016c4:	fc080be3          	beqz	a6,8000169a <copyinstr+0x4a>
    800016c8:	985a                	add	a6,a6,s6
    800016ca:	87da                	mv	a5,s6
      if(*p == '\0'){
    800016cc:	41650633          	sub	a2,a0,s6
    800016d0:	14fd                	addi	s1,s1,-1
    800016d2:	9b26                	add	s6,s6,s1
    800016d4:	00f60733          	add	a4,a2,a5
    800016d8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8fe4>
    800016dc:	df49                	beqz	a4,80001676 <copyinstr+0x26>
        *dst = *p;
    800016de:	00e78023          	sb	a4,0(a5)
      --max;
    800016e2:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800016e6:	0785                	addi	a5,a5,1
    while(n > 0){
    800016e8:	ff0796e3          	bne	a5,a6,800016d4 <copyinstr+0x84>
      dst++;
    800016ec:	8b42                	mv	s6,a6
    800016ee:	b775                	j	8000169a <copyinstr+0x4a>
    800016f0:	4781                	li	a5,0
    800016f2:	b769                	j	8000167c <copyinstr+0x2c>
      return -1;
    800016f4:	557d                	li	a0,-1
    800016f6:	b779                	j	80001684 <copyinstr+0x34>
  int got_null = 0;
    800016f8:	4781                	li	a5,0
  if(got_null){
    800016fa:	0017b793          	seqz	a5,a5
    800016fe:	40f00533          	neg	a0,a5
    80001702:	8082                	ret

0000000080001704 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    80001704:	1101                	addi	sp,sp,-32
    80001706:	ec06                	sd	ra,24(sp)
    80001708:	e822                	sd	s0,16(sp)
    8000170a:	e426                	sd	s1,8(sp)
    8000170c:	1000                	addi	s0,sp,32
    8000170e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001710:	fffff097          	auipc	ra,0xfffff
    80001714:	382080e7          	jalr	898(ra) # 80000a92 <holding>
    80001718:	c909                	beqz	a0,8000172a <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    8000171a:	749c                	ld	a5,40(s1)
    8000171c:	00978f63          	beq	a5,s1,8000173a <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001720:	60e2                	ld	ra,24(sp)
    80001722:	6442                	ld	s0,16(sp)
    80001724:	64a2                	ld	s1,8(sp)
    80001726:	6105                	addi	sp,sp,32
    80001728:	8082                	ret
    panic("wakeup1");
    8000172a:	00006517          	auipc	a0,0x6
    8000172e:	b9650513          	addi	a0,a0,-1130 # 800072c0 <userret+0x230>
    80001732:	fffff097          	auipc	ra,0xfffff
    80001736:	e1c080e7          	jalr	-484(ra) # 8000054e <panic>
  if(p->chan == p && p->state == SLEEPING) {
    8000173a:	4c98                	lw	a4,24(s1)
    8000173c:	4785                	li	a5,1
    8000173e:	fef711e3          	bne	a4,a5,80001720 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001742:	4789                	li	a5,2
    80001744:	cc9c                	sw	a5,24(s1)
}
    80001746:	bfe9                	j	80001720 <wakeup1+0x1c>

0000000080001748 <procinit>:
{
    80001748:	715d                	addi	sp,sp,-80
    8000174a:	e486                	sd	ra,72(sp)
    8000174c:	e0a2                	sd	s0,64(sp)
    8000174e:	fc26                	sd	s1,56(sp)
    80001750:	f84a                	sd	s2,48(sp)
    80001752:	f44e                	sd	s3,40(sp)
    80001754:	f052                	sd	s4,32(sp)
    80001756:	ec56                	sd	s5,24(sp)
    80001758:	e85a                	sd	s6,16(sp)
    8000175a:	e45e                	sd	s7,8(sp)
    8000175c:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    8000175e:	00006597          	auipc	a1,0x6
    80001762:	b6a58593          	addi	a1,a1,-1174 # 800072c8 <userret+0x238>
    80001766:	00010517          	auipc	a0,0x10
    8000176a:	18250513          	addi	a0,a0,386 # 800118e8 <pid_lock>
    8000176e:	fffff097          	auipc	ra,0xfffff
    80001772:	252080e7          	jalr	594(ra) # 800009c0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001776:	00010917          	auipc	s2,0x10
    8000177a:	58a90913          	addi	s2,s2,1418 # 80011d00 <proc>
      initlock(&p->lock, "proc");
    8000177e:	00006b97          	auipc	s7,0x6
    80001782:	b52b8b93          	addi	s7,s7,-1198 # 800072d0 <userret+0x240>
      uint64 va = KSTACK((int) (p - proc)); //every process has a kernel stack with a protection page below it
    80001786:	8b4a                	mv	s6,s2
    80001788:	00006a97          	auipc	s5,0x6
    8000178c:	1f8a8a93          	addi	s5,s5,504 # 80007980 <syscalls+0xc0>
    80001790:	040009b7          	lui	s3,0x4000
    80001794:	19fd                	addi	s3,s3,-1
    80001796:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001798:	00016a17          	auipc	s4,0x16
    8000179c:	168a0a13          	addi	s4,s4,360 # 80017900 <tickslock>
      initlock(&p->lock, "proc");
    800017a0:	85de                	mv	a1,s7
    800017a2:	854a                	mv	a0,s2
    800017a4:	fffff097          	auipc	ra,0xfffff
    800017a8:	21c080e7          	jalr	540(ra) # 800009c0 <initlock>
      char *pa = kalloc();
    800017ac:	fffff097          	auipc	ra,0xfffff
    800017b0:	1b4080e7          	jalr	436(ra) # 80000960 <kalloc>
    800017b4:	85aa                	mv	a1,a0
      if(pa == 0)
    800017b6:	c929                	beqz	a0,80001808 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc)); //every process has a kernel stack with a protection page below it
    800017b8:	416904b3          	sub	s1,s2,s6
    800017bc:	8491                	srai	s1,s1,0x4
    800017be:	000ab783          	ld	a5,0(s5)
    800017c2:	02f484b3          	mul	s1,s1,a5
    800017c6:	2485                	addiw	s1,s1,1
    800017c8:	00d4949b          	slliw	s1,s1,0xd
    800017cc:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017d0:	4699                	li	a3,6
    800017d2:	6605                	lui	a2,0x1
    800017d4:	8526                	mv	a0,s1
    800017d6:	00000097          	auipc	ra,0x0
    800017da:	8d6080e7          	jalr	-1834(ra) # 800010ac <kvmmap>
      p->kstack = va;
    800017de:	04993423          	sd	s1,72(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e2:	17090913          	addi	s2,s2,368
    800017e6:	fb491de3          	bne	s2,s4,800017a0 <procinit+0x58>
  kvminithart();
    800017ea:	fffff097          	auipc	ra,0xfffff
    800017ee:	6ca080e7          	jalr	1738(ra) # 80000eb4 <kvminithart>
}
    800017f2:	60a6                	ld	ra,72(sp)
    800017f4:	6406                	ld	s0,64(sp)
    800017f6:	74e2                	ld	s1,56(sp)
    800017f8:	7942                	ld	s2,48(sp)
    800017fa:	79a2                	ld	s3,40(sp)
    800017fc:	7a02                	ld	s4,32(sp)
    800017fe:	6ae2                	ld	s5,24(sp)
    80001800:	6b42                	ld	s6,16(sp)
    80001802:	6ba2                	ld	s7,8(sp)
    80001804:	6161                	addi	sp,sp,80
    80001806:	8082                	ret
        panic("kalloc");
    80001808:	00006517          	auipc	a0,0x6
    8000180c:	ad050513          	addi	a0,a0,-1328 # 800072d8 <userret+0x248>
    80001810:	fffff097          	auipc	ra,0xfffff
    80001814:	d3e080e7          	jalr	-706(ra) # 8000054e <panic>

0000000080001818 <cpuid>:
{
    80001818:	1141                	addi	sp,sp,-16
    8000181a:	e422                	sd	s0,8(sp)
    8000181c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000181e:	8512                	mv	a0,tp
}
    80001820:	2501                	sext.w	a0,a0
    80001822:	6422                	ld	s0,8(sp)
    80001824:	0141                	addi	sp,sp,16
    80001826:	8082                	ret

0000000080001828 <mycpu>:
mycpu(void) {
    80001828:	1141                	addi	sp,sp,-16
    8000182a:	e422                	sd	s0,8(sp)
    8000182c:	0800                	addi	s0,sp,16
    8000182e:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001830:	2781                	sext.w	a5,a5
    80001832:	079e                	slli	a5,a5,0x7
}
    80001834:	00010517          	auipc	a0,0x10
    80001838:	0cc50513          	addi	a0,a0,204 # 80011900 <cpus>
    8000183c:	953e                	add	a0,a0,a5
    8000183e:	6422                	ld	s0,8(sp)
    80001840:	0141                	addi	sp,sp,16
    80001842:	8082                	ret

0000000080001844 <myproc>:
myproc(void) {
    80001844:	1101                	addi	sp,sp,-32
    80001846:	ec06                	sd	ra,24(sp)
    80001848:	e822                	sd	s0,16(sp)
    8000184a:	e426                	sd	s1,8(sp)
    8000184c:	1000                	addi	s0,sp,32
  push_off();
    8000184e:	fffff097          	auipc	ra,0xfffff
    80001852:	188080e7          	jalr	392(ra) # 800009d6 <push_off>
    80001856:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001858:	2781                	sext.w	a5,a5
    8000185a:	079e                	slli	a5,a5,0x7
    8000185c:	00010717          	auipc	a4,0x10
    80001860:	08c70713          	addi	a4,a4,140 # 800118e8 <pid_lock>
    80001864:	97ba                	add	a5,a5,a4
    80001866:	6f84                	ld	s1,24(a5)
  pop_off();
    80001868:	fffff097          	auipc	ra,0xfffff
    8000186c:	1ba080e7          	jalr	442(ra) # 80000a22 <pop_off>
}
    80001870:	8526                	mv	a0,s1
    80001872:	60e2                	ld	ra,24(sp)
    80001874:	6442                	ld	s0,16(sp)
    80001876:	64a2                	ld	s1,8(sp)
    80001878:	6105                	addi	sp,sp,32
    8000187a:	8082                	ret

000000008000187c <forkret>:
{
    8000187c:	1141                	addi	sp,sp,-16
    8000187e:	e406                	sd	ra,8(sp)
    80001880:	e022                	sd	s0,0(sp)
    80001882:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001884:	00000097          	auipc	ra,0x0
    80001888:	fc0080e7          	jalr	-64(ra) # 80001844 <myproc>
    8000188c:	fffff097          	auipc	ra,0xfffff
    80001890:	29a080e7          	jalr	666(ra) # 80000b26 <release>
  if (first) {
    80001894:	00006797          	auipc	a5,0x6
    80001898:	7a07a783          	lw	a5,1952(a5) # 80008034 <first.1714>
    8000189c:	eb89                	bnez	a5,800018ae <forkret+0x32>
  usertrapret();
    8000189e:	00001097          	auipc	ra,0x1
    800018a2:	fcc080e7          	jalr	-52(ra) # 8000286a <usertrapret>
}
    800018a6:	60a2                	ld	ra,8(sp)
    800018a8:	6402                	ld	s0,0(sp)
    800018aa:	0141                	addi	sp,sp,16
    800018ac:	8082                	ret
    first = 0;
    800018ae:	00006797          	auipc	a5,0x6
    800018b2:	7807a323          	sw	zero,1926(a5) # 80008034 <first.1714>
    fsinit(ROOTDEV);
    800018b6:	4505                	li	a0,1
    800018b8:	00002097          	auipc	ra,0x2
    800018bc:	d5a080e7          	jalr	-678(ra) # 80003612 <fsinit>
    800018c0:	bff9                	j	8000189e <forkret+0x22>

00000000800018c2 <allocpid>:
allocpid() {
    800018c2:	1101                	addi	sp,sp,-32
    800018c4:	ec06                	sd	ra,24(sp)
    800018c6:	e822                	sd	s0,16(sp)
    800018c8:	e426                	sd	s1,8(sp)
    800018ca:	e04a                	sd	s2,0(sp)
    800018cc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800018ce:	00010917          	auipc	s2,0x10
    800018d2:	01a90913          	addi	s2,s2,26 # 800118e8 <pid_lock>
    800018d6:	854a                	mv	a0,s2
    800018d8:	fffff097          	auipc	ra,0xfffff
    800018dc:	1fa080e7          	jalr	506(ra) # 80000ad2 <acquire>
  pid = nextpid;
    800018e0:	00006797          	auipc	a5,0x6
    800018e4:	75878793          	addi	a5,a5,1880 # 80008038 <nextpid>
    800018e8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018ea:	0014871b          	addiw	a4,s1,1
    800018ee:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018f0:	854a                	mv	a0,s2
    800018f2:	fffff097          	auipc	ra,0xfffff
    800018f6:	234080e7          	jalr	564(ra) # 80000b26 <release>
}
    800018fa:	8526                	mv	a0,s1
    800018fc:	60e2                	ld	ra,24(sp)
    800018fe:	6442                	ld	s0,16(sp)
    80001900:	64a2                	ld	s1,8(sp)
    80001902:	6902                	ld	s2,0(sp)
    80001904:	6105                	addi	sp,sp,32
    80001906:	8082                	ret

0000000080001908 <proc_pagetable>:
{
    80001908:	7179                	addi	sp,sp,-48
    8000190a:	f406                	sd	ra,40(sp)
    8000190c:	f022                	sd	s0,32(sp)
    8000190e:	ec26                	sd	s1,24(sp)
    80001910:	e84a                	sd	s2,16(sp)
    80001912:	e44e                	sd	s3,8(sp)
    80001914:	1800                	addi	s0,sp,48
    80001916:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001918:	00000097          	auipc	ra,0x0
    8000191c:	952080e7          	jalr	-1710(ra) # 8000126a <uvmcreate>
    80001920:	84aa                	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001922:	4729                	li	a4,10
    80001924:	00005697          	auipc	a3,0x5
    80001928:	6dc68693          	addi	a3,a3,1756 # 80007000 <trampoline>
    8000192c:	6605                	lui	a2,0x1
    8000192e:	040009b7          	lui	s3,0x4000
    80001932:	fff98593          	addi	a1,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001936:	05b2                	slli	a1,a1,0xc
    80001938:	fffff097          	auipc	ra,0xfffff
    8000193c:	6e6080e7          	jalr	1766(ra) # 8000101e <mappages>
  mappages(pagetable, TRAPFRAME-2*(p - proc)*PGSIZE, PGSIZE,(uint64)(p->tf), PTE_R | PTE_W); //p4 modified
    80001940:	00010597          	auipc	a1,0x10
    80001944:	3c058593          	addi	a1,a1,960 # 80011d00 <proc>
    80001948:	40b905b3          	sub	a1,s2,a1
    8000194c:	858d                	srai	a1,a1,0x3
    8000194e:	00006797          	auipc	a5,0x6
    80001952:	03a7b783          	ld	a5,58(a5) # 80007988 <syscalls+0xc8>
    80001956:	02f585b3          	mul	a1,a1,a5
    8000195a:	19f9                	addi	s3,s3,-2
    8000195c:	95ce                	add	a1,a1,s3
    8000195e:	4719                	li	a4,6
    80001960:	06093683          	ld	a3,96(s2)
    80001964:	6605                	lui	a2,0x1
    80001966:	05b2                	slli	a1,a1,0xc
    80001968:	8526                	mv	a0,s1
    8000196a:	fffff097          	auipc	ra,0xfffff
    8000196e:	6b4080e7          	jalr	1716(ra) # 8000101e <mappages>
}
    80001972:	8526                	mv	a0,s1
    80001974:	70a2                	ld	ra,40(sp)
    80001976:	7402                	ld	s0,32(sp)
    80001978:	64e2                	ld	s1,24(sp)
    8000197a:	6942                	ld	s2,16(sp)
    8000197c:	69a2                	ld	s3,8(sp)
    8000197e:	6145                	addi	sp,sp,48
    80001980:	8082                	ret

0000000080001982 <allocproc>:
{
    80001982:	1101                	addi	sp,sp,-32
    80001984:	ec06                	sd	ra,24(sp)
    80001986:	e822                	sd	s0,16(sp)
    80001988:	e426                	sd	s1,8(sp)
    8000198a:	e04a                	sd	s2,0(sp)
    8000198c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000198e:	00010497          	auipc	s1,0x10
    80001992:	37248493          	addi	s1,s1,882 # 80011d00 <proc>
    80001996:	00016917          	auipc	s2,0x16
    8000199a:	f6a90913          	addi	s2,s2,-150 # 80017900 <tickslock>
    acquire(&p->lock);
    8000199e:	8526                	mv	a0,s1
    800019a0:	fffff097          	auipc	ra,0xfffff
    800019a4:	132080e7          	jalr	306(ra) # 80000ad2 <acquire>
    if(p->state == UNUSED) {
    800019a8:	4c9c                	lw	a5,24(s1)
    800019aa:	cf81                	beqz	a5,800019c2 <allocproc+0x40>
      release(&p->lock);
    800019ac:	8526                	mv	a0,s1
    800019ae:	fffff097          	auipc	ra,0xfffff
    800019b2:	178080e7          	jalr	376(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019b6:	17048493          	addi	s1,s1,368
    800019ba:	ff2492e3          	bne	s1,s2,8000199e <allocproc+0x1c>
  return 0;
    800019be:	4481                	li	s1,0
    800019c0:	a0a9                	j	80001a0a <allocproc+0x88>
  p->pid = allocpid();
    800019c2:	00000097          	auipc	ra,0x0
    800019c6:	f00080e7          	jalr	-256(ra) # 800018c2 <allocpid>
    800019ca:	dc88                	sw	a0,56(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    800019cc:	fffff097          	auipc	ra,0xfffff
    800019d0:	f94080e7          	jalr	-108(ra) # 80000960 <kalloc>
    800019d4:	892a                	mv	s2,a0
    800019d6:	f0a8                	sd	a0,96(s1)
    800019d8:	c121                	beqz	a0,80001a18 <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    800019da:	8526                	mv	a0,s1
    800019dc:	00000097          	auipc	ra,0x0
    800019e0:	f2c080e7          	jalr	-212(ra) # 80001908 <proc_pagetable>
    800019e4:	eca8                	sd	a0,88(s1)
  memset(&p->context, 0, sizeof p->context); //write all zeros
    800019e6:	07000613          	li	a2,112
    800019ea:	4581                	li	a1,0
    800019ec:	06848513          	addi	a0,s1,104
    800019f0:	fffff097          	auipc	ra,0xfffff
    800019f4:	17e080e7          	jalr	382(ra) # 80000b6e <memset>
  p->context.ra = (uint64)forkret; //return address
    800019f8:	00000797          	auipc	a5,0x0
    800019fc:	e8478793          	addi	a5,a5,-380 # 8000187c <forkret>
    80001a00:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001a02:	64bc                	ld	a5,72(s1)
    80001a04:	6705                	lui	a4,0x1
    80001a06:	97ba                	add	a5,a5,a4
    80001a08:	f8bc                	sd	a5,112(s1)
}
    80001a0a:	8526                	mv	a0,s1
    80001a0c:	60e2                	ld	ra,24(sp)
    80001a0e:	6442                	ld	s0,16(sp)
    80001a10:	64a2                	ld	s1,8(sp)
    80001a12:	6902                	ld	s2,0(sp)
    80001a14:	6105                	addi	sp,sp,32
    80001a16:	8082                	ret
    release(&p->lock);
    80001a18:	8526                	mv	a0,s1
    80001a1a:	fffff097          	auipc	ra,0xfffff
    80001a1e:	10c080e7          	jalr	268(ra) # 80000b26 <release>
    return 0;
    80001a22:	84ca                	mv	s1,s2
    80001a24:	b7dd                	j	80001a0a <allocproc+0x88>

0000000080001a26 <proc_freepagetable>:
{
    80001a26:	7179                	addi	sp,sp,-48
    80001a28:	f406                	sd	ra,40(sp)
    80001a2a:	f022                	sd	s0,32(sp)
    80001a2c:	ec26                	sd	s1,24(sp)
    80001a2e:	e84a                	sd	s2,16(sp)
    80001a30:	e44e                	sd	s3,8(sp)
    80001a32:	e052                	sd	s4,0(sp)
    80001a34:	1800                	addi	s0,sp,48
    80001a36:	89aa                	mv	s3,a0
    80001a38:	8a2e                	mv	s4,a1
    80001a3a:	84b2                	mv	s1,a2
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    80001a3c:	4681                	li	a3,0
    80001a3e:	6605                	lui	a2,0x1
    80001a40:	04000937          	lui	s2,0x4000
    80001a44:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001a48:	05b2                	slli	a1,a1,0xc
    80001a4a:	fffff097          	auipc	ra,0xfffff
    80001a4e:	76c080e7          	jalr	1900(ra) # 800011b6 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME-2*(p - proc)*PGSIZE, PGSIZE, 0); //p4 modified
    80001a52:	00010617          	auipc	a2,0x10
    80001a56:	2ae60613          	addi	a2,a2,686 # 80011d00 <proc>
    80001a5a:	8c91                	sub	s1,s1,a2
    80001a5c:	848d                	srai	s1,s1,0x3
    80001a5e:	00006597          	auipc	a1,0x6
    80001a62:	f2a5b583          	ld	a1,-214(a1) # 80007988 <syscalls+0xc8>
    80001a66:	02b484b3          	mul	s1,s1,a1
    80001a6a:	1979                	addi	s2,s2,-2
    80001a6c:	94ca                	add	s1,s1,s2
    80001a6e:	4681                	li	a3,0
    80001a70:	6605                	lui	a2,0x1
    80001a72:	00c49593          	slli	a1,s1,0xc
    80001a76:	854e                	mv	a0,s3
    80001a78:	fffff097          	auipc	ra,0xfffff
    80001a7c:	73e080e7          	jalr	1854(ra) # 800011b6 <uvmunmap>
  if(sz > 0){
    80001a80:	000a1a63          	bnez	s4,80001a94 <proc_freepagetable+0x6e>
}
    80001a84:	70a2                	ld	ra,40(sp)
    80001a86:	7402                	ld	s0,32(sp)
    80001a88:	64e2                	ld	s1,24(sp)
    80001a8a:	6942                	ld	s2,16(sp)
    80001a8c:	69a2                	ld	s3,8(sp)
    80001a8e:	6a02                	ld	s4,0(sp)
    80001a90:	6145                	addi	sp,sp,48
    80001a92:	8082                	ret
    uvmfree(pagetable, sz);
    80001a94:	85d2                	mv	a1,s4
    80001a96:	854e                	mv	a0,s3
    80001a98:	00000097          	auipc	ra,0x0
    80001a9c:	970080e7          	jalr	-1680(ra) # 80001408 <uvmfree>
}
    80001aa0:	b7d5                	j	80001a84 <proc_freepagetable+0x5e>

0000000080001aa2 <freeproc>:
{
    80001aa2:	1101                	addi	sp,sp,-32
    80001aa4:	ec06                	sd	ra,24(sp)
    80001aa6:	e822                	sd	s0,16(sp)
    80001aa8:	e426                	sd	s1,8(sp)
    80001aaa:	1000                	addi	s0,sp,32
    80001aac:	84aa                	mv	s1,a0
  if(p->tf)
    80001aae:	7128                	ld	a0,96(a0)
    80001ab0:	c509                	beqz	a0,80001aba <freeproc+0x18>
    kfree((void*)p->tf);
    80001ab2:	fffff097          	auipc	ra,0xfffff
    80001ab6:	db2080e7          	jalr	-590(ra) # 80000864 <kfree>
  p->tf = 0;
    80001aba:	0604b023          	sd	zero,96(s1)
    if(pfree->pagetable == p->pagetable && pfree != p){
    80001abe:	6ca8                	ld	a0,88(s1)
  for(pfree = proc; pfree < &proc[NPROC]; pfree++) { //check if this is the last process/thread reference this pagetable
    80001ac0:	00010797          	auipc	a5,0x10
    80001ac4:	24078793          	addi	a5,a5,576 # 80011d00 <proc>
  int islast = 1; //p4 added
    80001ac8:	4605                	li	a2,1
      islast = 0;
    80001aca:	4581                	li	a1,0
  for(pfree = proc; pfree < &proc[NPROC]; pfree++) { //check if this is the last process/thread reference this pagetable
    80001acc:	00016697          	auipc	a3,0x16
    80001ad0:	e3468693          	addi	a3,a3,-460 # 80017900 <tickslock>
    80001ad4:	a029                	j	80001ade <freeproc+0x3c>
    80001ad6:	17078793          	addi	a5,a5,368
    80001ada:	00d78963          	beq	a5,a3,80001aec <freeproc+0x4a>
    if(pfree->pagetable == p->pagetable && pfree != p){
    80001ade:	6fb8                	ld	a4,88(a5)
    80001ae0:	fea71be3          	bne	a4,a0,80001ad6 <freeproc+0x34>
    80001ae4:	fef489e3          	beq	s1,a5,80001ad6 <freeproc+0x34>
      islast = 0;
    80001ae8:	862e                	mv	a2,a1
    80001aea:	b7f5                	j	80001ad6 <freeproc+0x34>
  if(p->pagetable && islast){ //free the pgtb only when this is the last reference
    80001aec:	c111                	beqz	a0,80001af0 <freeproc+0x4e>
    80001aee:	e225                	bnez	a2,80001b4e <freeproc+0xac>
    uvmunmap(p->pagetable, TRAPFRAME-2*(p - proc)*PGSIZE, PGSIZE, 0);
    80001af0:	00010597          	auipc	a1,0x10
    80001af4:	21058593          	addi	a1,a1,528 # 80011d00 <proc>
    80001af8:	40b485b3          	sub	a1,s1,a1
    80001afc:	858d                	srai	a1,a1,0x3
    80001afe:	00006797          	auipc	a5,0x6
    80001b02:	e8a7b783          	ld	a5,-374(a5) # 80007988 <syscalls+0xc8>
    80001b06:	02f585b3          	mul	a1,a1,a5
    80001b0a:	040007b7          	lui	a5,0x4000
    80001b0e:	17f9                	addi	a5,a5,-2
    80001b10:	95be                	add	a1,a1,a5
    80001b12:	4681                	li	a3,0
    80001b14:	6605                	lui	a2,0x1
    80001b16:	05b2                	slli	a1,a1,0xc
    80001b18:	fffff097          	auipc	ra,0xfffff
    80001b1c:	69e080e7          	jalr	1694(ra) # 800011b6 <uvmunmap>
  p->pagetable = 0;
    80001b20:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001b24:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001b28:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001b2c:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001b30:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001b34:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001b38:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001b3c:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001b40:	0004ac23          	sw	zero,24(s1)
}
    80001b44:	60e2                	ld	ra,24(sp)
    80001b46:	6442                	ld	s0,16(sp)
    80001b48:	64a2                	ld	s1,8(sp)
    80001b4a:	6105                	addi	sp,sp,32
    80001b4c:	8082                	ret
    proc_freepagetable(p->pagetable, p->sz, p); //p4 add the p
    80001b4e:	8626                	mv	a2,s1
    80001b50:	68ac                	ld	a1,80(s1)
    80001b52:	00000097          	auipc	ra,0x0
    80001b56:	ed4080e7          	jalr	-300(ra) # 80001a26 <proc_freepagetable>
    80001b5a:	b7d9                	j	80001b20 <freeproc+0x7e>

0000000080001b5c <userinit>:
{
    80001b5c:	1101                	addi	sp,sp,-32
    80001b5e:	ec06                	sd	ra,24(sp)
    80001b60:	e822                	sd	s0,16(sp)
    80001b62:	e426                	sd	s1,8(sp)
    80001b64:	1000                	addi	s0,sp,32
  p = allocproc(); //get the return address
    80001b66:	00000097          	auipc	ra,0x0
    80001b6a:	e1c080e7          	jalr	-484(ra) # 80001982 <allocproc>
    80001b6e:	84aa                	mv	s1,a0
  initproc = p;
    80001b70:	00024797          	auipc	a5,0x24
    80001b74:	4aa7b023          	sd	a0,1184(a5) # 80026010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001b78:	03300613          	li	a2,51
    80001b7c:	00006597          	auipc	a1,0x6
    80001b80:	48458593          	addi	a1,a1,1156 # 80008000 <initcode>
    80001b84:	6d28                	ld	a0,88(a0)
    80001b86:	fffff097          	auipc	ra,0xfffff
    80001b8a:	722080e7          	jalr	1826(ra) # 800012a8 <uvminit>
  p->sz = PGSIZE;
    80001b8e:	6785                	lui	a5,0x1
    80001b90:	e8bc                	sd	a5,80(s1)
  p->tf->epc = 0;      // user program counter
    80001b92:	70b8                	ld	a4,96(s1)
    80001b94:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->tf->sp = PGSIZE;  // user stack pointer
    80001b98:	70b8                	ld	a4,96(s1)
    80001b9a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001b9c:	4641                	li	a2,16
    80001b9e:	00005597          	auipc	a1,0x5
    80001ba2:	74258593          	addi	a1,a1,1858 # 800072e0 <userret+0x250>
    80001ba6:	16048513          	addi	a0,s1,352
    80001baa:	fffff097          	auipc	ra,0xfffff
    80001bae:	11a080e7          	jalr	282(ra) # 80000cc4 <safestrcpy>
  p->cwd = namei("/");
    80001bb2:	00005517          	auipc	a0,0x5
    80001bb6:	73e50513          	addi	a0,a0,1854 # 800072f0 <userret+0x260>
    80001bba:	00002097          	auipc	ra,0x2
    80001bbe:	45a080e7          	jalr	1114(ra) # 80004014 <namei>
    80001bc2:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001bc6:	4789                	li	a5,2
    80001bc8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001bca:	8526                	mv	a0,s1
    80001bcc:	fffff097          	auipc	ra,0xfffff
    80001bd0:	f5a080e7          	jalr	-166(ra) # 80000b26 <release>
}
    80001bd4:	60e2                	ld	ra,24(sp)
    80001bd6:	6442                	ld	s0,16(sp)
    80001bd8:	64a2                	ld	s1,8(sp)
    80001bda:	6105                	addi	sp,sp,32
    80001bdc:	8082                	ret

0000000080001bde <growproc>:
{
    80001bde:	1101                	addi	sp,sp,-32
    80001be0:	ec06                	sd	ra,24(sp)
    80001be2:	e822                	sd	s0,16(sp)
    80001be4:	e426                	sd	s1,8(sp)
    80001be6:	e04a                	sd	s2,0(sp)
    80001be8:	1000                	addi	s0,sp,32
    80001bea:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bec:	00000097          	auipc	ra,0x0
    80001bf0:	c58080e7          	jalr	-936(ra) # 80001844 <myproc>
    80001bf4:	892a                	mv	s2,a0
  sz = p->sz;
    80001bf6:	692c                	ld	a1,80(a0)
    80001bf8:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001bfc:	00904f63          	bgtz	s1,80001c1a <growproc+0x3c>
  } else if(n < 0){
    80001c00:	0204cc63          	bltz	s1,80001c38 <growproc+0x5a>
  p->sz = sz;
    80001c04:	1602                	slli	a2,a2,0x20
    80001c06:	9201                	srli	a2,a2,0x20
    80001c08:	04c93823          	sd	a2,80(s2)
  return 0;
    80001c0c:	4501                	li	a0,0
}
    80001c0e:	60e2                	ld	ra,24(sp)
    80001c10:	6442                	ld	s0,16(sp)
    80001c12:	64a2                	ld	s1,8(sp)
    80001c14:	6902                	ld	s2,0(sp)
    80001c16:	6105                	addi	sp,sp,32
    80001c18:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001c1a:	9e25                	addw	a2,a2,s1
    80001c1c:	1602                	slli	a2,a2,0x20
    80001c1e:	9201                	srli	a2,a2,0x20
    80001c20:	1582                	slli	a1,a1,0x20
    80001c22:	9181                	srli	a1,a1,0x20
    80001c24:	6d28                	ld	a0,88(a0)
    80001c26:	fffff097          	auipc	ra,0xfffff
    80001c2a:	738080e7          	jalr	1848(ra) # 8000135e <uvmalloc>
    80001c2e:	0005061b          	sext.w	a2,a0
    80001c32:	fa69                	bnez	a2,80001c04 <growproc+0x26>
      return -1;
    80001c34:	557d                	li	a0,-1
    80001c36:	bfe1                	j	80001c0e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c38:	9e25                	addw	a2,a2,s1
    80001c3a:	1602                	slli	a2,a2,0x20
    80001c3c:	9201                	srli	a2,a2,0x20
    80001c3e:	1582                	slli	a1,a1,0x20
    80001c40:	9181                	srli	a1,a1,0x20
    80001c42:	6d28                	ld	a0,88(a0)
    80001c44:	fffff097          	auipc	ra,0xfffff
    80001c48:	6d6080e7          	jalr	1750(ra) # 8000131a <uvmdealloc>
    80001c4c:	0005061b          	sext.w	a2,a0
    80001c50:	bf55                	j	80001c04 <growproc+0x26>

0000000080001c52 <fork>:
{
    80001c52:	7179                	addi	sp,sp,-48
    80001c54:	f406                	sd	ra,40(sp)
    80001c56:	f022                	sd	s0,32(sp)
    80001c58:	ec26                	sd	s1,24(sp)
    80001c5a:	e84a                	sd	s2,16(sp)
    80001c5c:	e44e                	sd	s3,8(sp)
    80001c5e:	e052                	sd	s4,0(sp)
    80001c60:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001c62:	00000097          	auipc	ra,0x0
    80001c66:	be2080e7          	jalr	-1054(ra) # 80001844 <myproc>
    80001c6a:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001c6c:	00000097          	auipc	ra,0x0
    80001c70:	d16080e7          	jalr	-746(ra) # 80001982 <allocproc>
    80001c74:	c175                	beqz	a0,80001d58 <fork+0x106>
    80001c76:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001c78:	05093603          	ld	a2,80(s2)
    80001c7c:	6d2c                	ld	a1,88(a0)
    80001c7e:	05893503          	ld	a0,88(s2)
    80001c82:	fffff097          	auipc	ra,0xfffff
    80001c86:	7b4080e7          	jalr	1972(ra) # 80001436 <uvmcopy>
    80001c8a:	04054863          	bltz	a0,80001cda <fork+0x88>
  np->sz = p->sz;
    80001c8e:	05093783          	ld	a5,80(s2)
    80001c92:	04f9b823          	sd	a5,80(s3)
  np->parent = p;
    80001c96:	0329b023          	sd	s2,32(s3)
  *(np->tf) = *(p->tf);
    80001c9a:	06093683          	ld	a3,96(s2)
    80001c9e:	87b6                	mv	a5,a3
    80001ca0:	0609b703          	ld	a4,96(s3)
    80001ca4:	12068693          	addi	a3,a3,288
    80001ca8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001cac:	6788                	ld	a0,8(a5)
    80001cae:	6b8c                	ld	a1,16(a5)
    80001cb0:	6f90                	ld	a2,24(a5)
    80001cb2:	01073023          	sd	a6,0(a4)
    80001cb6:	e708                	sd	a0,8(a4)
    80001cb8:	eb0c                	sd	a1,16(a4)
    80001cba:	ef10                	sd	a2,24(a4)
    80001cbc:	02078793          	addi	a5,a5,32
    80001cc0:	02070713          	addi	a4,a4,32
    80001cc4:	fed792e3          	bne	a5,a3,80001ca8 <fork+0x56>
  np->tf->a0 = 0;
    80001cc8:	0609b783          	ld	a5,96(s3)
    80001ccc:	0607b823          	sd	zero,112(a5)
    80001cd0:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80001cd4:	15800a13          	li	s4,344
    80001cd8:	a03d                	j	80001d06 <fork+0xb4>
    freeproc(np);
    80001cda:	854e                	mv	a0,s3
    80001cdc:	00000097          	auipc	ra,0x0
    80001ce0:	dc6080e7          	jalr	-570(ra) # 80001aa2 <freeproc>
    release(&np->lock);
    80001ce4:	854e                	mv	a0,s3
    80001ce6:	fffff097          	auipc	ra,0xfffff
    80001cea:	e40080e7          	jalr	-448(ra) # 80000b26 <release>
    return -1;
    80001cee:	54fd                	li	s1,-1
    80001cf0:	a899                	j	80001d46 <fork+0xf4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001cf2:	00003097          	auipc	ra,0x3
    80001cf6:	9ae080e7          	jalr	-1618(ra) # 800046a0 <filedup>
    80001cfa:	009987b3          	add	a5,s3,s1
    80001cfe:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001d00:	04a1                	addi	s1,s1,8
    80001d02:	01448763          	beq	s1,s4,80001d10 <fork+0xbe>
    if(p->ofile[i])
    80001d06:	009907b3          	add	a5,s2,s1
    80001d0a:	6388                	ld	a0,0(a5)
    80001d0c:	f17d                	bnez	a0,80001cf2 <fork+0xa0>
    80001d0e:	bfcd                	j	80001d00 <fork+0xae>
  np->cwd = idup(p->cwd);
    80001d10:	15893503          	ld	a0,344(s2)
    80001d14:	00002097          	auipc	ra,0x2
    80001d18:	b38080e7          	jalr	-1224(ra) # 8000384c <idup>
    80001d1c:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d20:	4641                	li	a2,16
    80001d22:	16090593          	addi	a1,s2,352
    80001d26:	16098513          	addi	a0,s3,352
    80001d2a:	fffff097          	auipc	ra,0xfffff
    80001d2e:	f9a080e7          	jalr	-102(ra) # 80000cc4 <safestrcpy>
  pid = np->pid;
    80001d32:	0389a483          	lw	s1,56(s3)
  np->state = RUNNABLE;
    80001d36:	4789                	li	a5,2
    80001d38:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001d3c:	854e                	mv	a0,s3
    80001d3e:	fffff097          	auipc	ra,0xfffff
    80001d42:	de8080e7          	jalr	-536(ra) # 80000b26 <release>
}
    80001d46:	8526                	mv	a0,s1
    80001d48:	70a2                	ld	ra,40(sp)
    80001d4a:	7402                	ld	s0,32(sp)
    80001d4c:	64e2                	ld	s1,24(sp)
    80001d4e:	6942                	ld	s2,16(sp)
    80001d50:	69a2                	ld	s3,8(sp)
    80001d52:	6a02                	ld	s4,0(sp)
    80001d54:	6145                	addi	sp,sp,48
    80001d56:	8082                	ret
    return -1;
    80001d58:	54fd                	li	s1,-1
    80001d5a:	b7f5                	j	80001d46 <fork+0xf4>

0000000080001d5c <clone>:
{
    80001d5c:	715d                	addi	sp,sp,-80
    80001d5e:	e486                	sd	ra,72(sp)
    80001d60:	e0a2                	sd	s0,64(sp)
    80001d62:	fc26                	sd	s1,56(sp)
    80001d64:	f84a                	sd	s2,48(sp)
    80001d66:	f44e                	sd	s3,40(sp)
    80001d68:	f052                	sd	s4,32(sp)
    80001d6a:	ec56                	sd	s5,24(sp)
    80001d6c:	e85a                	sd	s6,16(sp)
    80001d6e:	e45e                	sd	s7,8(sp)
    80001d70:	0880                	addi	s0,sp,80
    80001d72:	8aaa                	mv	s5,a0
    80001d74:	8bae                	mv	s7,a1
    80001d76:	8b32                	mv	s6,a2
    80001d78:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001d7a:	00000097          	auipc	ra,0x0
    80001d7e:	aca080e7          	jalr	-1334(ra) # 80001844 <myproc>
  if(((uint64)stack % PGSIZE) != 0) { //check the stack address is page aligned
    80001d82:	034a1793          	slli	a5,s4,0x34
    80001d86:	18079563          	bnez	a5,80001f10 <clone+0x1b4>
    80001d8a:	89aa                	mv	s3,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d8c:	00010497          	auipc	s1,0x10
    80001d90:	f7448493          	addi	s1,s1,-140 # 80011d00 <proc>
    80001d94:	00016917          	auipc	s2,0x16
    80001d98:	b6c90913          	addi	s2,s2,-1172 # 80017900 <tickslock>
    acquire(&p->lock);
    80001d9c:	8526                	mv	a0,s1
    80001d9e:	fffff097          	auipc	ra,0xfffff
    80001da2:	d34080e7          	jalr	-716(ra) # 80000ad2 <acquire>
    if(p->state == UNUSED) {
    80001da6:	4c9c                	lw	a5,24(s1)
    80001da8:	cf81                	beqz	a5,80001dc0 <clone+0x64>
      release(&p->lock);
    80001daa:	8526                	mv	a0,s1
    80001dac:	fffff097          	auipc	ra,0xfffff
    80001db0:	d7a080e7          	jalr	-646(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001db4:	17048493          	addi	s1,s1,368
    80001db8:	ff2492e3          	bne	s1,s2,80001d9c <clone+0x40>
  return 0;
    80001dbc:	4481                	li	s1,0
    80001dbe:	a895                	j	80001e32 <clone+0xd6>
  p->pid = allocpid();
    80001dc0:	00000097          	auipc	ra,0x0
    80001dc4:	b02080e7          	jalr	-1278(ra) # 800018c2 <allocpid>
    80001dc8:	dc88                	sw	a0,56(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    80001dca:	fffff097          	auipc	ra,0xfffff
    80001dce:	b96080e7          	jalr	-1130(ra) # 80000960 <kalloc>
    80001dd2:	892a                	mv	s2,a0
    80001dd4:	f0a8                	sd	a0,96(s1)
    80001dd6:	c169                	beqz	a0,80001e98 <clone+0x13c>
  mappages(parent->pagetable, TRAPFRAME-2*(p - proc)*PGSIZE, PGSIZE,(uint64)(p->tf), PTE_R | PTE_W);
    80001dd8:	00010797          	auipc	a5,0x10
    80001ddc:	f2878793          	addi	a5,a5,-216 # 80011d00 <proc>
    80001de0:	40f487b3          	sub	a5,s1,a5
    80001de4:	878d                	srai	a5,a5,0x3
    80001de6:	00006597          	auipc	a1,0x6
    80001dea:	ba25b583          	ld	a1,-1118(a1) # 80007988 <syscalls+0xc8>
    80001dee:	02b787b3          	mul	a5,a5,a1
    80001df2:	040005b7          	lui	a1,0x4000
    80001df6:	15f9                	addi	a1,a1,-2
    80001df8:	95be                	add	a1,a1,a5
    80001dfa:	4719                	li	a4,6
    80001dfc:	86aa                	mv	a3,a0
    80001dfe:	6605                	lui	a2,0x1
    80001e00:	05b2                	slli	a1,a1,0xc
    80001e02:	0589b503          	ld	a0,88(s3)
    80001e06:	fffff097          	auipc	ra,0xfffff
    80001e0a:	218080e7          	jalr	536(ra) # 8000101e <mappages>
  memset(&p->context, 0, sizeof p->context); //write all zeros
    80001e0e:	07000613          	li	a2,112
    80001e12:	4581                	li	a1,0
    80001e14:	06848513          	addi	a0,s1,104
    80001e18:	fffff097          	auipc	ra,0xfffff
    80001e1c:	d56080e7          	jalr	-682(ra) # 80000b6e <memset>
  p->context.ra = (uint64)forkret; //return address
    80001e20:	00000797          	auipc	a5,0x0
    80001e24:	a5c78793          	addi	a5,a5,-1444 # 8000187c <forkret>
    80001e28:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001e2a:	64bc                	ld	a5,72(s1)
    80001e2c:	6705                	lui	a4,0x1
    80001e2e:	97ba                	add	a5,a5,a4
    80001e30:	f8bc                	sd	a5,112(s1)
  np->stack = (uint64)stack; //self added PCB field
    80001e32:	0544b023          	sd	s4,64(s1)
  np->pagetable = p->pagetable; //use the same pagetable
    80001e36:	0589b783          	ld	a5,88(s3)
    80001e3a:	ecbc                	sd	a5,88(s1)
  np->sz = p->sz;
    80001e3c:	0509b783          	ld	a5,80(s3)
    80001e40:	e8bc                	sd	a5,80(s1)
  np->parent = p;
    80001e42:	0334b023          	sd	s3,32(s1)
  *(np->tf) = *(p->tf);
    80001e46:	0609b683          	ld	a3,96(s3)
    80001e4a:	87b6                	mv	a5,a3
    80001e4c:	70b8                	ld	a4,96(s1)
    80001e4e:	12068693          	addi	a3,a3,288
    80001e52:	0007b803          	ld	a6,0(a5)
    80001e56:	6788                	ld	a0,8(a5)
    80001e58:	6b8c                	ld	a1,16(a5)
    80001e5a:	6f90                	ld	a2,24(a5)
    80001e5c:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001e60:	e708                	sd	a0,8(a4)
    80001e62:	eb0c                	sd	a1,16(a4)
    80001e64:	ef10                	sd	a2,24(a4)
    80001e66:	02078793          	addi	a5,a5,32
    80001e6a:	02070713          	addi	a4,a4,32
    80001e6e:	fed792e3          	bne	a5,a3,80001e52 <clone+0xf6>
  np->tf->a0 = (uint64)arg1;
    80001e72:	70bc                	ld	a5,96(s1)
    80001e74:	0777b823          	sd	s7,112(a5)
  np->tf->a1 = (uint64)arg2;
    80001e78:	70bc                	ld	a5,96(s1)
    80001e7a:	0767bc23          	sd	s6,120(a5)
  np->tf->sp = sp;
    80001e7e:	70bc                	ld	a5,96(s1)
  sp = (uint64)stack + PGSIZE; //stack top
    80001e80:	6705                	lui	a4,0x1
    80001e82:	9a3a                	add	s4,s4,a4
  np->tf->sp = sp;
    80001e84:	0347b823          	sd	s4,48(a5)
  np->tf->epc = (uint64)fcn;
    80001e88:	70bc                	ld	a5,96(s1)
    80001e8a:	0157bc23          	sd	s5,24(a5)
    80001e8e:	0d800913          	li	s2,216
  for(i = 0; i < NOFILE; i++)
    80001e92:	15800a13          	li	s4,344
    80001e96:	a015                	j	80001eba <clone+0x15e>
    release(&p->lock);
    80001e98:	8526                	mv	a0,s1
    80001e9a:	fffff097          	auipc	ra,0xfffff
    80001e9e:	c8c080e7          	jalr	-884(ra) # 80000b26 <release>
    return 0;
    80001ea2:	84ca                	mv	s1,s2
    80001ea4:	b779                	j	80001e32 <clone+0xd6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001ea6:	00002097          	auipc	ra,0x2
    80001eaa:	7fa080e7          	jalr	2042(ra) # 800046a0 <filedup>
    80001eae:	012487b3          	add	a5,s1,s2
    80001eb2:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001eb4:	0921                	addi	s2,s2,8
    80001eb6:	01490763          	beq	s2,s4,80001ec4 <clone+0x168>
    if(p->ofile[i])
    80001eba:	012987b3          	add	a5,s3,s2
    80001ebe:	6388                	ld	a0,0(a5)
    80001ec0:	f17d                	bnez	a0,80001ea6 <clone+0x14a>
    80001ec2:	bfcd                	j	80001eb4 <clone+0x158>
  np->cwd = idup(p->cwd);
    80001ec4:	1589b503          	ld	a0,344(s3)
    80001ec8:	00002097          	auipc	ra,0x2
    80001ecc:	984080e7          	jalr	-1660(ra) # 8000384c <idup>
    80001ed0:	14a4bc23          	sd	a0,344(s1)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ed4:	4641                	li	a2,16
    80001ed6:	16098593          	addi	a1,s3,352
    80001eda:	16048513          	addi	a0,s1,352
    80001ede:	fffff097          	auipc	ra,0xfffff
    80001ee2:	de6080e7          	jalr	-538(ra) # 80000cc4 <safestrcpy>
  pid = np->pid;
    80001ee6:	0384a903          	lw	s2,56(s1)
  np->state = RUNNABLE;
    80001eea:	4789                	li	a5,2
    80001eec:	cc9c                	sw	a5,24(s1)
  release(&np->lock);
    80001eee:	8526                	mv	a0,s1
    80001ef0:	fffff097          	auipc	ra,0xfffff
    80001ef4:	c36080e7          	jalr	-970(ra) # 80000b26 <release>
}
    80001ef8:	854a                	mv	a0,s2
    80001efa:	60a6                	ld	ra,72(sp)
    80001efc:	6406                	ld	s0,64(sp)
    80001efe:	74e2                	ld	s1,56(sp)
    80001f00:	7942                	ld	s2,48(sp)
    80001f02:	79a2                	ld	s3,40(sp)
    80001f04:	7a02                	ld	s4,32(sp)
    80001f06:	6ae2                	ld	s5,24(sp)
    80001f08:	6b42                	ld	s6,16(sp)
    80001f0a:	6ba2                	ld	s7,8(sp)
    80001f0c:	6161                	addi	sp,sp,80
    80001f0e:	8082                	ret
    return -1;
    80001f10:	597d                	li	s2,-1
    80001f12:	b7dd                	j	80001ef8 <clone+0x19c>

0000000080001f14 <sys_clone>:
{
    80001f14:	7179                	addi	sp,sp,-48
    80001f16:	f406                	sd	ra,40(sp)
    80001f18:	f022                	sd	s0,32(sp)
    80001f1a:	1800                	addi	s0,sp,48
  if(argaddr(0, &fcn) < 0)
    80001f1c:	fe840593          	addi	a1,s0,-24
    80001f20:	4501                	li	a0,0
    80001f22:	00001097          	auipc	ra,0x1
    80001f26:	e0a080e7          	jalr	-502(ra) # 80002d2c <argaddr>
    80001f2a:	04054d63          	bltz	a0,80001f84 <sys_clone+0x70>
  if(argaddr(1, &arg1) < 0)
    80001f2e:	fe040593          	addi	a1,s0,-32
    80001f32:	4505                	li	a0,1
    80001f34:	00001097          	auipc	ra,0x1
    80001f38:	df8080e7          	jalr	-520(ra) # 80002d2c <argaddr>
    80001f3c:	04054663          	bltz	a0,80001f88 <sys_clone+0x74>
  if(argaddr(2, &arg2) < 0)
    80001f40:	fd840593          	addi	a1,s0,-40
    80001f44:	4509                	li	a0,2
    80001f46:	00001097          	auipc	ra,0x1
    80001f4a:	de6080e7          	jalr	-538(ra) # 80002d2c <argaddr>
    80001f4e:	02054f63          	bltz	a0,80001f8c <sys_clone+0x78>
  if(argaddr(3, &stack) < 0)
    80001f52:	fd040593          	addi	a1,s0,-48
    80001f56:	450d                	li	a0,3
    80001f58:	00001097          	auipc	ra,0x1
    80001f5c:	dd4080e7          	jalr	-556(ra) # 80002d2c <argaddr>
    80001f60:	02054863          	bltz	a0,80001f90 <sys_clone+0x7c>
  return clone((void(*)(void*,void*))fcn, (void*)arg1, (void*)arg2, (void*)stack);
    80001f64:	fd043683          	ld	a3,-48(s0)
    80001f68:	fd843603          	ld	a2,-40(s0)
    80001f6c:	fe043583          	ld	a1,-32(s0)
    80001f70:	fe843503          	ld	a0,-24(s0)
    80001f74:	00000097          	auipc	ra,0x0
    80001f78:	de8080e7          	jalr	-536(ra) # 80001d5c <clone>
}
    80001f7c:	70a2                	ld	ra,40(sp)
    80001f7e:	7402                	ld	s0,32(sp)
    80001f80:	6145                	addi	sp,sp,48
    80001f82:	8082                	ret
    return -1;
    80001f84:	557d                	li	a0,-1
    80001f86:	bfdd                	j	80001f7c <sys_clone+0x68>
    return -1;
    80001f88:	557d                	li	a0,-1
    80001f8a:	bfcd                	j	80001f7c <sys_clone+0x68>
    return -1;
    80001f8c:	557d                	li	a0,-1
    80001f8e:	b7fd                	j	80001f7c <sys_clone+0x68>
    return -1;
    80001f90:	557d                	li	a0,-1
    80001f92:	b7ed                	j	80001f7c <sys_clone+0x68>

0000000080001f94 <reparent>:
{
    80001f94:	7179                	addi	sp,sp,-48
    80001f96:	f406                	sd	ra,40(sp)
    80001f98:	f022                	sd	s0,32(sp)
    80001f9a:	ec26                	sd	s1,24(sp)
    80001f9c:	e84a                	sd	s2,16(sp)
    80001f9e:	e44e                	sd	s3,8(sp)
    80001fa0:	e052                	sd	s4,0(sp)
    80001fa2:	1800                	addi	s0,sp,48
    80001fa4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fa6:	00010497          	auipc	s1,0x10
    80001faa:	d5a48493          	addi	s1,s1,-678 # 80011d00 <proc>
      pp->parent = initproc;
    80001fae:	00024a17          	auipc	s4,0x24
    80001fb2:	062a0a13          	addi	s4,s4,98 # 80026010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fb6:	00016997          	auipc	s3,0x16
    80001fba:	94a98993          	addi	s3,s3,-1718 # 80017900 <tickslock>
    80001fbe:	a029                	j	80001fc8 <reparent+0x34>
    80001fc0:	17048493          	addi	s1,s1,368
    80001fc4:	03348363          	beq	s1,s3,80001fea <reparent+0x56>
    if(pp->parent == p){
    80001fc8:	709c                	ld	a5,32(s1)
    80001fca:	ff279be3          	bne	a5,s2,80001fc0 <reparent+0x2c>
      acquire(&pp->lock);
    80001fce:	8526                	mv	a0,s1
    80001fd0:	fffff097          	auipc	ra,0xfffff
    80001fd4:	b02080e7          	jalr	-1278(ra) # 80000ad2 <acquire>
      pp->parent = initproc;
    80001fd8:	000a3783          	ld	a5,0(s4)
    80001fdc:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001fde:	8526                	mv	a0,s1
    80001fe0:	fffff097          	auipc	ra,0xfffff
    80001fe4:	b46080e7          	jalr	-1210(ra) # 80000b26 <release>
    80001fe8:	bfe1                	j	80001fc0 <reparent+0x2c>
}
    80001fea:	70a2                	ld	ra,40(sp)
    80001fec:	7402                	ld	s0,32(sp)
    80001fee:	64e2                	ld	s1,24(sp)
    80001ff0:	6942                	ld	s2,16(sp)
    80001ff2:	69a2                	ld	s3,8(sp)
    80001ff4:	6a02                	ld	s4,0(sp)
    80001ff6:	6145                	addi	sp,sp,48
    80001ff8:	8082                	ret

0000000080001ffa <scheduler>:
{
    80001ffa:	7139                	addi	sp,sp,-64
    80001ffc:	fc06                	sd	ra,56(sp)
    80001ffe:	f822                	sd	s0,48(sp)
    80002000:	f426                	sd	s1,40(sp)
    80002002:	f04a                	sd	s2,32(sp)
    80002004:	ec4e                	sd	s3,24(sp)
    80002006:	e852                	sd	s4,16(sp)
    80002008:	e456                	sd	s5,8(sp)
    8000200a:	e05a                	sd	s6,0(sp)
    8000200c:	0080                	addi	s0,sp,64
    8000200e:	8792                	mv	a5,tp
  int id = r_tp();
    80002010:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002012:	00779a93          	slli	s5,a5,0x7
    80002016:	00010717          	auipc	a4,0x10
    8000201a:	8d270713          	addi	a4,a4,-1838 # 800118e8 <pid_lock>
    8000201e:	9756                	add	a4,a4,s5
    80002020:	00073c23          	sd	zero,24(a4)
        swtch(&c->scheduler, &p->context);
    80002024:	00010717          	auipc	a4,0x10
    80002028:	8e470713          	addi	a4,a4,-1820 # 80011908 <cpus+0x8>
    8000202c:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE){
    8000202e:	4989                	li	s3,2
        p->state = RUNNING;
    80002030:	4b0d                	li	s6,3
        c->proc = p;
    80002032:	079e                	slli	a5,a5,0x7
    80002034:	00010a17          	auipc	s4,0x10
    80002038:	8b4a0a13          	addi	s4,s4,-1868 # 800118e8 <pid_lock>
    8000203c:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++){
    8000203e:	00016917          	auipc	s2,0x16
    80002042:	8c290913          	addi	s2,s2,-1854 # 80017900 <tickslock>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80002046:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000204a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000204e:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002052:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002056:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000205a:	10079073          	csrw	sstatus,a5
    8000205e:	00010497          	auipc	s1,0x10
    80002062:	ca248493          	addi	s1,s1,-862 # 80011d00 <proc>
    80002066:	a03d                	j	80002094 <scheduler+0x9a>
        p->state = RUNNING;
    80002068:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000206c:	009a3c23          	sd	s1,24(s4)
        swtch(&c->scheduler, &p->context);
    80002070:	06848593          	addi	a1,s1,104
    80002074:	8556                	mv	a0,s5
    80002076:	00000097          	auipc	ra,0x0
    8000207a:	74a080e7          	jalr	1866(ra) # 800027c0 <swtch>
        c->proc = 0;
    8000207e:	000a3c23          	sd	zero,24(s4)
      release(&p->lock);
    80002082:	8526                	mv	a0,s1
    80002084:	fffff097          	auipc	ra,0xfffff
    80002088:	aa2080e7          	jalr	-1374(ra) # 80000b26 <release>
    for(p = proc; p < &proc[NPROC]; p++){
    8000208c:	17048493          	addi	s1,s1,368
    80002090:	fb248be3          	beq	s1,s2,80002046 <scheduler+0x4c>
      acquire(&p->lock);
    80002094:	8526                	mv	a0,s1
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	a3c080e7          	jalr	-1476(ra) # 80000ad2 <acquire>
      if(p->state == RUNNABLE){
    8000209e:	4c9c                	lw	a5,24(s1)
    800020a0:	ff3791e3          	bne	a5,s3,80002082 <scheduler+0x88>
    800020a4:	b7d1                	j	80002068 <scheduler+0x6e>

00000000800020a6 <sched>:
{
    800020a6:	7179                	addi	sp,sp,-48
    800020a8:	f406                	sd	ra,40(sp)
    800020aa:	f022                	sd	s0,32(sp)
    800020ac:	ec26                	sd	s1,24(sp)
    800020ae:	e84a                	sd	s2,16(sp)
    800020b0:	e44e                	sd	s3,8(sp)
    800020b2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800020b4:	fffff097          	auipc	ra,0xfffff
    800020b8:	790080e7          	jalr	1936(ra) # 80001844 <myproc>
    800020bc:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800020be:	fffff097          	auipc	ra,0xfffff
    800020c2:	9d4080e7          	jalr	-1580(ra) # 80000a92 <holding>
    800020c6:	c93d                	beqz	a0,8000213c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020c8:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800020ca:	2781                	sext.w	a5,a5
    800020cc:	079e                	slli	a5,a5,0x7
    800020ce:	00010717          	auipc	a4,0x10
    800020d2:	81a70713          	addi	a4,a4,-2022 # 800118e8 <pid_lock>
    800020d6:	97ba                	add	a5,a5,a4
    800020d8:	0907a703          	lw	a4,144(a5)
    800020dc:	4785                	li	a5,1
    800020de:	06f71763          	bne	a4,a5,8000214c <sched+0xa6>
  if(p->state == RUNNING)
    800020e2:	4c98                	lw	a4,24(s1)
    800020e4:	478d                	li	a5,3
    800020e6:	06f70b63          	beq	a4,a5,8000215c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020ea:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800020ee:	8b89                	andi	a5,a5,2
  if(intr_get())
    800020f0:	efb5                	bnez	a5,8000216c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020f2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800020f4:	0000f917          	auipc	s2,0xf
    800020f8:	7f490913          	addi	s2,s2,2036 # 800118e8 <pid_lock>
    800020fc:	2781                	sext.w	a5,a5
    800020fe:	079e                	slli	a5,a5,0x7
    80002100:	97ca                	add	a5,a5,s2
    80002102:	0947a983          	lw	s3,148(a5)
    80002106:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->scheduler);
    80002108:	2781                	sext.w	a5,a5
    8000210a:	079e                	slli	a5,a5,0x7
    8000210c:	0000f597          	auipc	a1,0xf
    80002110:	7fc58593          	addi	a1,a1,2044 # 80011908 <cpus+0x8>
    80002114:	95be                	add	a1,a1,a5
    80002116:	06848513          	addi	a0,s1,104
    8000211a:	00000097          	auipc	ra,0x0
    8000211e:	6a6080e7          	jalr	1702(ra) # 800027c0 <swtch>
    80002122:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002124:	2781                	sext.w	a5,a5
    80002126:	079e                	slli	a5,a5,0x7
    80002128:	97ca                	add	a5,a5,s2
    8000212a:	0937aa23          	sw	s3,148(a5)
}
    8000212e:	70a2                	ld	ra,40(sp)
    80002130:	7402                	ld	s0,32(sp)
    80002132:	64e2                	ld	s1,24(sp)
    80002134:	6942                	ld	s2,16(sp)
    80002136:	69a2                	ld	s3,8(sp)
    80002138:	6145                	addi	sp,sp,48
    8000213a:	8082                	ret
    panic("sched p->lock");
    8000213c:	00005517          	auipc	a0,0x5
    80002140:	1bc50513          	addi	a0,a0,444 # 800072f8 <userret+0x268>
    80002144:	ffffe097          	auipc	ra,0xffffe
    80002148:	40a080e7          	jalr	1034(ra) # 8000054e <panic>
    panic("sched locks");
    8000214c:	00005517          	auipc	a0,0x5
    80002150:	1bc50513          	addi	a0,a0,444 # 80007308 <userret+0x278>
    80002154:	ffffe097          	auipc	ra,0xffffe
    80002158:	3fa080e7          	jalr	1018(ra) # 8000054e <panic>
    panic("sched running");
    8000215c:	00005517          	auipc	a0,0x5
    80002160:	1bc50513          	addi	a0,a0,444 # 80007318 <userret+0x288>
    80002164:	ffffe097          	auipc	ra,0xffffe
    80002168:	3ea080e7          	jalr	1002(ra) # 8000054e <panic>
    panic("sched interruptible");
    8000216c:	00005517          	auipc	a0,0x5
    80002170:	1bc50513          	addi	a0,a0,444 # 80007328 <userret+0x298>
    80002174:	ffffe097          	auipc	ra,0xffffe
    80002178:	3da080e7          	jalr	986(ra) # 8000054e <panic>

000000008000217c <exit>:
{
    8000217c:	7179                	addi	sp,sp,-48
    8000217e:	f406                	sd	ra,40(sp)
    80002180:	f022                	sd	s0,32(sp)
    80002182:	ec26                	sd	s1,24(sp)
    80002184:	e84a                	sd	s2,16(sp)
    80002186:	e44e                	sd	s3,8(sp)
    80002188:	e052                	sd	s4,0(sp)
    8000218a:	1800                	addi	s0,sp,48
    8000218c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	6b6080e7          	jalr	1718(ra) # 80001844 <myproc>
    80002196:	89aa                	mv	s3,a0
  if(p == initproc)
    80002198:	00024797          	auipc	a5,0x24
    8000219c:	e787b783          	ld	a5,-392(a5) # 80026010 <initproc>
    800021a0:	0d850493          	addi	s1,a0,216
    800021a4:	15850913          	addi	s2,a0,344
    800021a8:	02a79363          	bne	a5,a0,800021ce <exit+0x52>
    panic("init exiting");
    800021ac:	00005517          	auipc	a0,0x5
    800021b0:	19450513          	addi	a0,a0,404 # 80007340 <userret+0x2b0>
    800021b4:	ffffe097          	auipc	ra,0xffffe
    800021b8:	39a080e7          	jalr	922(ra) # 8000054e <panic>
      fileclose(f);
    800021bc:	00002097          	auipc	ra,0x2
    800021c0:	536080e7          	jalr	1334(ra) # 800046f2 <fileclose>
      p->ofile[fd] = 0;
    800021c4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800021c8:	04a1                	addi	s1,s1,8
    800021ca:	01248563          	beq	s1,s2,800021d4 <exit+0x58>
    if(p->ofile[fd]){
    800021ce:	6088                	ld	a0,0(s1)
    800021d0:	f575                	bnez	a0,800021bc <exit+0x40>
    800021d2:	bfdd                	j	800021c8 <exit+0x4c>
  begin_op();
    800021d4:	00002097          	auipc	ra,0x2
    800021d8:	04c080e7          	jalr	76(ra) # 80004220 <begin_op>
  iput(p->cwd);
    800021dc:	1589b503          	ld	a0,344(s3)
    800021e0:	00001097          	auipc	ra,0x1
    800021e4:	7b8080e7          	jalr	1976(ra) # 80003998 <iput>
  end_op();
    800021e8:	00002097          	auipc	ra,0x2
    800021ec:	0b8080e7          	jalr	184(ra) # 800042a0 <end_op>
  p->cwd = 0;
    800021f0:	1409bc23          	sd	zero,344(s3)
  acquire(&initproc->lock);
    800021f4:	00024497          	auipc	s1,0x24
    800021f8:	e1c48493          	addi	s1,s1,-484 # 80026010 <initproc>
    800021fc:	6088                	ld	a0,0(s1)
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	8d4080e7          	jalr	-1836(ra) # 80000ad2 <acquire>
  wakeup1(initproc);
    80002206:	6088                	ld	a0,0(s1)
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	4fc080e7          	jalr	1276(ra) # 80001704 <wakeup1>
  release(&initproc->lock);
    80002210:	6088                	ld	a0,0(s1)
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	914080e7          	jalr	-1772(ra) # 80000b26 <release>
  acquire(&p->lock);
    8000221a:	854e                	mv	a0,s3
    8000221c:	fffff097          	auipc	ra,0xfffff
    80002220:	8b6080e7          	jalr	-1866(ra) # 80000ad2 <acquire>
  struct proc *original_parent = p->parent;
    80002224:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002228:	854e                	mv	a0,s3
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	8fc080e7          	jalr	-1796(ra) # 80000b26 <release>
  acquire(&original_parent->lock);
    80002232:	8526                	mv	a0,s1
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	89e080e7          	jalr	-1890(ra) # 80000ad2 <acquire>
  acquire(&p->lock);
    8000223c:	854e                	mv	a0,s3
    8000223e:	fffff097          	auipc	ra,0xfffff
    80002242:	894080e7          	jalr	-1900(ra) # 80000ad2 <acquire>
  reparent(p);
    80002246:	854e                	mv	a0,s3
    80002248:	00000097          	auipc	ra,0x0
    8000224c:	d4c080e7          	jalr	-692(ra) # 80001f94 <reparent>
  wakeup1(original_parent);
    80002250:	8526                	mv	a0,s1
    80002252:	fffff097          	auipc	ra,0xfffff
    80002256:	4b2080e7          	jalr	1202(ra) # 80001704 <wakeup1>
  p->xstate = status;
    8000225a:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000225e:	4791                	li	a5,4
    80002260:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80002264:	8526                	mv	a0,s1
    80002266:	fffff097          	auipc	ra,0xfffff
    8000226a:	8c0080e7          	jalr	-1856(ra) # 80000b26 <release>
  sched();
    8000226e:	00000097          	auipc	ra,0x0
    80002272:	e38080e7          	jalr	-456(ra) # 800020a6 <sched>
  panic("zombie exit");
    80002276:	00005517          	auipc	a0,0x5
    8000227a:	0da50513          	addi	a0,a0,218 # 80007350 <userret+0x2c0>
    8000227e:	ffffe097          	auipc	ra,0xffffe
    80002282:	2d0080e7          	jalr	720(ra) # 8000054e <panic>

0000000080002286 <yield>:
{
    80002286:	1101                	addi	sp,sp,-32
    80002288:	ec06                	sd	ra,24(sp)
    8000228a:	e822                	sd	s0,16(sp)
    8000228c:	e426                	sd	s1,8(sp)
    8000228e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002290:	fffff097          	auipc	ra,0xfffff
    80002294:	5b4080e7          	jalr	1460(ra) # 80001844 <myproc>
    80002298:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000229a:	fffff097          	auipc	ra,0xfffff
    8000229e:	838080e7          	jalr	-1992(ra) # 80000ad2 <acquire>
  p->state = RUNNABLE;
    800022a2:	4789                	li	a5,2
    800022a4:	cc9c                	sw	a5,24(s1)
  sched();
    800022a6:	00000097          	auipc	ra,0x0
    800022aa:	e00080e7          	jalr	-512(ra) # 800020a6 <sched>
  release(&p->lock);
    800022ae:	8526                	mv	a0,s1
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	876080e7          	jalr	-1930(ra) # 80000b26 <release>
}
    800022b8:	60e2                	ld	ra,24(sp)
    800022ba:	6442                	ld	s0,16(sp)
    800022bc:	64a2                	ld	s1,8(sp)
    800022be:	6105                	addi	sp,sp,32
    800022c0:	8082                	ret

00000000800022c2 <sleep>:
{
    800022c2:	7179                	addi	sp,sp,-48
    800022c4:	f406                	sd	ra,40(sp)
    800022c6:	f022                	sd	s0,32(sp)
    800022c8:	ec26                	sd	s1,24(sp)
    800022ca:	e84a                	sd	s2,16(sp)
    800022cc:	e44e                	sd	s3,8(sp)
    800022ce:	1800                	addi	s0,sp,48
    800022d0:	89aa                	mv	s3,a0
    800022d2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	570080e7          	jalr	1392(ra) # 80001844 <myproc>
    800022dc:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800022de:	05250663          	beq	a0,s2,8000232a <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    800022e2:	ffffe097          	auipc	ra,0xffffe
    800022e6:	7f0080e7          	jalr	2032(ra) # 80000ad2 <acquire>
    release(lk);
    800022ea:	854a                	mv	a0,s2
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	83a080e7          	jalr	-1990(ra) # 80000b26 <release>
  p->chan = chan;
    800022f4:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800022f8:	4785                	li	a5,1
    800022fa:	cc9c                	sw	a5,24(s1)
  sched();
    800022fc:	00000097          	auipc	ra,0x0
    80002300:	daa080e7          	jalr	-598(ra) # 800020a6 <sched>
  p->chan = 0;
    80002304:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002308:	8526                	mv	a0,s1
    8000230a:	fffff097          	auipc	ra,0xfffff
    8000230e:	81c080e7          	jalr	-2020(ra) # 80000b26 <release>
    acquire(lk);
    80002312:	854a                	mv	a0,s2
    80002314:	ffffe097          	auipc	ra,0xffffe
    80002318:	7be080e7          	jalr	1982(ra) # 80000ad2 <acquire>
}
    8000231c:	70a2                	ld	ra,40(sp)
    8000231e:	7402                	ld	s0,32(sp)
    80002320:	64e2                	ld	s1,24(sp)
    80002322:	6942                	ld	s2,16(sp)
    80002324:	69a2                	ld	s3,8(sp)
    80002326:	6145                	addi	sp,sp,48
    80002328:	8082                	ret
  p->chan = chan;
    8000232a:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    8000232e:	4785                	li	a5,1
    80002330:	cd1c                	sw	a5,24(a0)
  sched();
    80002332:	00000097          	auipc	ra,0x0
    80002336:	d74080e7          	jalr	-652(ra) # 800020a6 <sched>
  p->chan = 0;
    8000233a:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    8000233e:	bff9                	j	8000231c <sleep+0x5a>

0000000080002340 <join>:
{
    80002340:	711d                	addi	sp,sp,-96
    80002342:	ec86                	sd	ra,88(sp)
    80002344:	e8a2                	sd	s0,80(sp)
    80002346:	e4a6                	sd	s1,72(sp)
    80002348:	e0ca                	sd	s2,64(sp)
    8000234a:	fc4e                	sd	s3,56(sp)
    8000234c:	f852                	sd	s4,48(sp)
    8000234e:	f456                	sd	s5,40(sp)
    80002350:	f05a                	sd	s6,32(sp)
    80002352:	ec5e                	sd	s7,24(sp)
    80002354:	e862                	sd	s8,16(sp)
    80002356:	1080                	addi	s0,sp,96
    80002358:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000235a:	fffff097          	auipc	ra,0xfffff
    8000235e:	4ea080e7          	jalr	1258(ra) # 80001844 <myproc>
    80002362:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002364:	8c2a                	mv	s8,a0
    80002366:	ffffe097          	auipc	ra,0xffffe
    8000236a:	76c080e7          	jalr	1900(ra) # 80000ad2 <acquire>
    havekids = 0;
    8000236e:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002370:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    80002372:	00015997          	auipc	s3,0x15
    80002376:	58e98993          	addi	s3,s3,1422 # 80017900 <tickslock>
        havekids = 1;
    8000237a:	4a85                	li	s5,1
    havekids = 0;
    8000237c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000237e:	00010497          	auipc	s1,0x10
    80002382:	98248493          	addi	s1,s1,-1662 # 80011d00 <proc>
    80002386:	a08d                	j	800023e8 <join+0xa8>
          pid = np->pid;
    80002388:	0384a983          	lw	s3,56(s1)
          ustack = np->stack;
    8000238c:	60bc                	ld	a5,64(s1)
    8000238e:	faf43423          	sd	a5,-88(s0)
          if(copyout(np->pagetable, stack, (char *)&ustack, sizeof(ustack)) < 0){
    80002392:	46a1                	li	a3,8
    80002394:	fa840613          	addi	a2,s0,-88
    80002398:	85da                	mv	a1,s6
    8000239a:	6ca8                	ld	a0,88(s1)
    8000239c:	fffff097          	auipc	ra,0xfffff
    800023a0:	19c080e7          	jalr	412(ra) # 80001538 <copyout>
    800023a4:	02054263          	bltz	a0,800023c8 <join+0x88>
          freeproc(np); 
    800023a8:	8526                	mv	a0,s1
    800023aa:	fffff097          	auipc	ra,0xfffff
    800023ae:	6f8080e7          	jalr	1784(ra) # 80001aa2 <freeproc>
          release(&np->lock);
    800023b2:	8526                	mv	a0,s1
    800023b4:	ffffe097          	auipc	ra,0xffffe
    800023b8:	772080e7          	jalr	1906(ra) # 80000b26 <release>
          release(&p->lock);
    800023bc:	854a                	mv	a0,s2
    800023be:	ffffe097          	auipc	ra,0xffffe
    800023c2:	768080e7          	jalr	1896(ra) # 80000b26 <release>
          return pid;
    800023c6:	a8a9                	j	80002420 <join+0xe0>
            release(&np->lock);
    800023c8:	8526                	mv	a0,s1
    800023ca:	ffffe097          	auipc	ra,0xffffe
    800023ce:	75c080e7          	jalr	1884(ra) # 80000b26 <release>
            release(&p->lock);
    800023d2:	854a                	mv	a0,s2
    800023d4:	ffffe097          	auipc	ra,0xffffe
    800023d8:	752080e7          	jalr	1874(ra) # 80000b26 <release>
            return -1;
    800023dc:	59fd                	li	s3,-1
    800023de:	a089                	j	80002420 <join+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    800023e0:	17048493          	addi	s1,s1,368
    800023e4:	03348463          	beq	s1,s3,8000240c <join+0xcc>
      if(np->parent == p ){
    800023e8:	709c                	ld	a5,32(s1)
    800023ea:	ff279be3          	bne	a5,s2,800023e0 <join+0xa0>
        acquire(&np->lock);
    800023ee:	8526                	mv	a0,s1
    800023f0:	ffffe097          	auipc	ra,0xffffe
    800023f4:	6e2080e7          	jalr	1762(ra) # 80000ad2 <acquire>
        if(np->state == ZOMBIE){
    800023f8:	4c9c                	lw	a5,24(s1)
    800023fa:	f94787e3          	beq	a5,s4,80002388 <join+0x48>
        release(&np->lock);
    800023fe:	8526                	mv	a0,s1
    80002400:	ffffe097          	auipc	ra,0xffffe
    80002404:	726080e7          	jalr	1830(ra) # 80000b26 <release>
        havekids = 1;
    80002408:	8756                	mv	a4,s5
    8000240a:	bfd9                	j	800023e0 <join+0xa0>
    if(!havekids || p->killed){
    8000240c:	c701                	beqz	a4,80002414 <join+0xd4>
    8000240e:	03092783          	lw	a5,48(s2)
    80002412:	c785                	beqz	a5,8000243a <join+0xfa>
      release(&p->lock);
    80002414:	854a                	mv	a0,s2
    80002416:	ffffe097          	auipc	ra,0xffffe
    8000241a:	710080e7          	jalr	1808(ra) # 80000b26 <release>
      return -1;
    8000241e:	59fd                	li	s3,-1
}
    80002420:	854e                	mv	a0,s3
    80002422:	60e6                	ld	ra,88(sp)
    80002424:	6446                	ld	s0,80(sp)
    80002426:	64a6                	ld	s1,72(sp)
    80002428:	6906                	ld	s2,64(sp)
    8000242a:	79e2                	ld	s3,56(sp)
    8000242c:	7a42                	ld	s4,48(sp)
    8000242e:	7aa2                	ld	s5,40(sp)
    80002430:	7b02                	ld	s6,32(sp)
    80002432:	6be2                	ld	s7,24(sp)
    80002434:	6c42                	ld	s8,16(sp)
    80002436:	6125                	addi	sp,sp,96
    80002438:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    8000243a:	85e2                	mv	a1,s8
    8000243c:	854a                	mv	a0,s2
    8000243e:	00000097          	auipc	ra,0x0
    80002442:	e84080e7          	jalr	-380(ra) # 800022c2 <sleep>
    havekids = 0;
    80002446:	bf1d                	j	8000237c <join+0x3c>

0000000080002448 <sys_join>:
{
    80002448:	1101                	addi	sp,sp,-32
    8000244a:	ec06                	sd	ra,24(sp)
    8000244c:	e822                	sd	s0,16(sp)
    8000244e:	1000                	addi	s0,sp,32
  if(argaddr(0, &stack) < 0)  {
    80002450:	fe840593          	addi	a1,s0,-24
    80002454:	4501                	li	a0,0
    80002456:	00001097          	auipc	ra,0x1
    8000245a:	8d6080e7          	jalr	-1834(ra) # 80002d2c <argaddr>
    8000245e:	00054c63          	bltz	a0,80002476 <sys_join+0x2e>
    return join(stack);
    80002462:	fe843503          	ld	a0,-24(s0)
    80002466:	00000097          	auipc	ra,0x0
    8000246a:	eda080e7          	jalr	-294(ra) # 80002340 <join>
}
    8000246e:	60e2                	ld	ra,24(sp)
    80002470:	6442                	ld	s0,16(sp)
    80002472:	6105                	addi	sp,sp,32
    80002474:	8082                	ret
    return -1;
    80002476:	557d                	li	a0,-1
    80002478:	bfdd                	j	8000246e <sys_join+0x26>

000000008000247a <wait>:
{
    8000247a:	715d                	addi	sp,sp,-80
    8000247c:	e486                	sd	ra,72(sp)
    8000247e:	e0a2                	sd	s0,64(sp)
    80002480:	fc26                	sd	s1,56(sp)
    80002482:	f84a                	sd	s2,48(sp)
    80002484:	f44e                	sd	s3,40(sp)
    80002486:	f052                	sd	s4,32(sp)
    80002488:	ec56                	sd	s5,24(sp)
    8000248a:	e85a                	sd	s6,16(sp)
    8000248c:	e45e                	sd	s7,8(sp)
    8000248e:	e062                	sd	s8,0(sp)
    80002490:	0880                	addi	s0,sp,80
    80002492:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002494:	fffff097          	auipc	ra,0xfffff
    80002498:	3b0080e7          	jalr	944(ra) # 80001844 <myproc>
    8000249c:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000249e:	8c2a                	mv	s8,a0
    800024a0:	ffffe097          	auipc	ra,0xffffe
    800024a4:	632080e7          	jalr	1586(ra) # 80000ad2 <acquire>
    havekids = 0;
    800024a8:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800024aa:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    800024ac:	00015997          	auipc	s3,0x15
    800024b0:	45498993          	addi	s3,s3,1108 # 80017900 <tickslock>
        havekids = 1;
    800024b4:	4a85                	li	s5,1
    havekids = 0;
    800024b6:	86de                	mv	a3,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800024b8:	00010497          	auipc	s1,0x10
    800024bc:	84848493          	addi	s1,s1,-1976 # 80011d00 <proc>
    800024c0:	a08d                	j	80002522 <wait+0xa8>
          pid = np->pid;
    800024c2:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800024c6:	000b0e63          	beqz	s6,800024e2 <wait+0x68>
    800024ca:	4691                	li	a3,4
    800024cc:	03448613          	addi	a2,s1,52
    800024d0:	85da                	mv	a1,s6
    800024d2:	05893503          	ld	a0,88(s2)
    800024d6:	fffff097          	auipc	ra,0xfffff
    800024da:	062080e7          	jalr	98(ra) # 80001538 <copyout>
    800024de:	02054263          	bltz	a0,80002502 <wait+0x88>
          freeproc(np); 
    800024e2:	8526                	mv	a0,s1
    800024e4:	fffff097          	auipc	ra,0xfffff
    800024e8:	5be080e7          	jalr	1470(ra) # 80001aa2 <freeproc>
          release(&np->lock);
    800024ec:	8526                	mv	a0,s1
    800024ee:	ffffe097          	auipc	ra,0xffffe
    800024f2:	638080e7          	jalr	1592(ra) # 80000b26 <release>
          release(&p->lock);
    800024f6:	854a                	mv	a0,s2
    800024f8:	ffffe097          	auipc	ra,0xffffe
    800024fc:	62e080e7          	jalr	1582(ra) # 80000b26 <release>
          return pid;
    80002500:	a095                	j	80002564 <wait+0xea>
            release(&np->lock);
    80002502:	8526                	mv	a0,s1
    80002504:	ffffe097          	auipc	ra,0xffffe
    80002508:	622080e7          	jalr	1570(ra) # 80000b26 <release>
            release(&p->lock);
    8000250c:	854a                	mv	a0,s2
    8000250e:	ffffe097          	auipc	ra,0xffffe
    80002512:	618080e7          	jalr	1560(ra) # 80000b26 <release>
            return -1;
    80002516:	59fd                	li	s3,-1
    80002518:	a0b1                	j	80002564 <wait+0xea>
    for(np = proc; np < &proc[NPROC]; np++){
    8000251a:	17048493          	addi	s1,s1,368
    8000251e:	03348963          	beq	s1,s3,80002550 <wait+0xd6>
      if(np->parent == p && np->pagetable != p->pagetable ){ //p4 thread modified condition, only wait for forked process not thread
    80002522:	709c                	ld	a5,32(s1)
    80002524:	ff279be3          	bne	a5,s2,8000251a <wait+0xa0>
    80002528:	6cb8                	ld	a4,88(s1)
    8000252a:	05893783          	ld	a5,88(s2)
    8000252e:	fef706e3          	beq	a4,a5,8000251a <wait+0xa0>
        acquire(&np->lock);
    80002532:	8526                	mv	a0,s1
    80002534:	ffffe097          	auipc	ra,0xffffe
    80002538:	59e080e7          	jalr	1438(ra) # 80000ad2 <acquire>
        if(np->state == ZOMBIE){
    8000253c:	4c9c                	lw	a5,24(s1)
    8000253e:	f94782e3          	beq	a5,s4,800024c2 <wait+0x48>
        release(&np->lock);
    80002542:	8526                	mv	a0,s1
    80002544:	ffffe097          	auipc	ra,0xffffe
    80002548:	5e2080e7          	jalr	1506(ra) # 80000b26 <release>
        havekids = 1;
    8000254c:	86d6                	mv	a3,s5
    8000254e:	b7f1                	j	8000251a <wait+0xa0>
    if(!havekids || p->killed){
    80002550:	c681                	beqz	a3,80002558 <wait+0xde>
    80002552:	03092783          	lw	a5,48(s2)
    80002556:	c785                	beqz	a5,8000257e <wait+0x104>
      release(&p->lock);
    80002558:	854a                	mv	a0,s2
    8000255a:	ffffe097          	auipc	ra,0xffffe
    8000255e:	5cc080e7          	jalr	1484(ra) # 80000b26 <release>
      return -1;
    80002562:	59fd                	li	s3,-1
}
    80002564:	854e                	mv	a0,s3
    80002566:	60a6                	ld	ra,72(sp)
    80002568:	6406                	ld	s0,64(sp)
    8000256a:	74e2                	ld	s1,56(sp)
    8000256c:	7942                	ld	s2,48(sp)
    8000256e:	79a2                	ld	s3,40(sp)
    80002570:	7a02                	ld	s4,32(sp)
    80002572:	6ae2                	ld	s5,24(sp)
    80002574:	6b42                	ld	s6,16(sp)
    80002576:	6ba2                	ld	s7,8(sp)
    80002578:	6c02                	ld	s8,0(sp)
    8000257a:	6161                	addi	sp,sp,80
    8000257c:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    8000257e:	85e2                	mv	a1,s8
    80002580:	854a                	mv	a0,s2
    80002582:	00000097          	auipc	ra,0x0
    80002586:	d40080e7          	jalr	-704(ra) # 800022c2 <sleep>
    havekids = 0;
    8000258a:	b735                	j	800024b6 <wait+0x3c>

000000008000258c <wakeup>:
{
    8000258c:	7139                	addi	sp,sp,-64
    8000258e:	fc06                	sd	ra,56(sp)
    80002590:	f822                	sd	s0,48(sp)
    80002592:	f426                	sd	s1,40(sp)
    80002594:	f04a                	sd	s2,32(sp)
    80002596:	ec4e                	sd	s3,24(sp)
    80002598:	e852                	sd	s4,16(sp)
    8000259a:	e456                	sd	s5,8(sp)
    8000259c:	0080                	addi	s0,sp,64
    8000259e:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800025a0:	0000f497          	auipc	s1,0xf
    800025a4:	76048493          	addi	s1,s1,1888 # 80011d00 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    800025a8:	4985                	li	s3,1
      p->state = RUNNABLE;
    800025aa:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    800025ac:	00015917          	auipc	s2,0x15
    800025b0:	35490913          	addi	s2,s2,852 # 80017900 <tickslock>
    800025b4:	a821                	j	800025cc <wakeup+0x40>
      p->state = RUNNABLE;
    800025b6:	0154ac23          	sw	s5,24(s1)
    release(&p->lock);
    800025ba:	8526                	mv	a0,s1
    800025bc:	ffffe097          	auipc	ra,0xffffe
    800025c0:	56a080e7          	jalr	1386(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800025c4:	17048493          	addi	s1,s1,368
    800025c8:	01248e63          	beq	s1,s2,800025e4 <wakeup+0x58>
    acquire(&p->lock);
    800025cc:	8526                	mv	a0,s1
    800025ce:	ffffe097          	auipc	ra,0xffffe
    800025d2:	504080e7          	jalr	1284(ra) # 80000ad2 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800025d6:	4c9c                	lw	a5,24(s1)
    800025d8:	ff3791e3          	bne	a5,s3,800025ba <wakeup+0x2e>
    800025dc:	749c                	ld	a5,40(s1)
    800025de:	fd479ee3          	bne	a5,s4,800025ba <wakeup+0x2e>
    800025e2:	bfd1                	j	800025b6 <wakeup+0x2a>
}
    800025e4:	70e2                	ld	ra,56(sp)
    800025e6:	7442                	ld	s0,48(sp)
    800025e8:	74a2                	ld	s1,40(sp)
    800025ea:	7902                	ld	s2,32(sp)
    800025ec:	69e2                	ld	s3,24(sp)
    800025ee:	6a42                	ld	s4,16(sp)
    800025f0:	6aa2                	ld	s5,8(sp)
    800025f2:	6121                	addi	sp,sp,64
    800025f4:	8082                	ret

00000000800025f6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800025f6:	7179                	addi	sp,sp,-48
    800025f8:	f406                	sd	ra,40(sp)
    800025fa:	f022                	sd	s0,32(sp)
    800025fc:	ec26                	sd	s1,24(sp)
    800025fe:	e84a                	sd	s2,16(sp)
    80002600:	e44e                	sd	s3,8(sp)
    80002602:	1800                	addi	s0,sp,48
    80002604:	892a                	mv	s2,a0
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++){
    80002606:	0000f497          	auipc	s1,0xf
    8000260a:	6fa48493          	addi	s1,s1,1786 # 80011d00 <proc>
    8000260e:	00015997          	auipc	s3,0x15
    80002612:	2f298993          	addi	s3,s3,754 # 80017900 <tickslock>
    acquire(&p->lock);
    80002616:	8526                	mv	a0,s1
    80002618:	ffffe097          	auipc	ra,0xffffe
    8000261c:	4ba080e7          	jalr	1210(ra) # 80000ad2 <acquire>
    if(p->pid == pid){
    80002620:	5c9c                	lw	a5,56(s1)
    80002622:	01278d63          	beq	a5,s2,8000263c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002626:	8526                	mv	a0,s1
    80002628:	ffffe097          	auipc	ra,0xffffe
    8000262c:	4fe080e7          	jalr	1278(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002630:	17048493          	addi	s1,s1,368
    80002634:	ff3491e3          	bne	s1,s3,80002616 <kill+0x20>
  }
  return -1;
    80002638:	557d                	li	a0,-1
    8000263a:	a821                	j	80002652 <kill+0x5c>
      p->killed = 1;
    8000263c:	4785                	li	a5,1
    8000263e:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002640:	4c98                	lw	a4,24(s1)
    80002642:	00f70f63          	beq	a4,a5,80002660 <kill+0x6a>
      release(&p->lock);
    80002646:	8526                	mv	a0,s1
    80002648:	ffffe097          	auipc	ra,0xffffe
    8000264c:	4de080e7          	jalr	1246(ra) # 80000b26 <release>
      return 0;
    80002650:	4501                	li	a0,0
}
    80002652:	70a2                	ld	ra,40(sp)
    80002654:	7402                	ld	s0,32(sp)
    80002656:	64e2                	ld	s1,24(sp)
    80002658:	6942                	ld	s2,16(sp)
    8000265a:	69a2                	ld	s3,8(sp)
    8000265c:	6145                	addi	sp,sp,48
    8000265e:	8082                	ret
        p->state = RUNNABLE;
    80002660:	4789                	li	a5,2
    80002662:	cc9c                	sw	a5,24(s1)
    80002664:	b7cd                	j	80002646 <kill+0x50>

0000000080002666 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002666:	7179                	addi	sp,sp,-48
    80002668:	f406                	sd	ra,40(sp)
    8000266a:	f022                	sd	s0,32(sp)
    8000266c:	ec26                	sd	s1,24(sp)
    8000266e:	e84a                	sd	s2,16(sp)
    80002670:	e44e                	sd	s3,8(sp)
    80002672:	e052                	sd	s4,0(sp)
    80002674:	1800                	addi	s0,sp,48
    80002676:	84aa                	mv	s1,a0
    80002678:	892e                	mv	s2,a1
    8000267a:	89b2                	mv	s3,a2
    8000267c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000267e:	fffff097          	auipc	ra,0xfffff
    80002682:	1c6080e7          	jalr	454(ra) # 80001844 <myproc>
  if(user_dst){
    80002686:	c08d                	beqz	s1,800026a8 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002688:	86d2                	mv	a3,s4
    8000268a:	864e                	mv	a2,s3
    8000268c:	85ca                	mv	a1,s2
    8000268e:	6d28                	ld	a0,88(a0)
    80002690:	fffff097          	auipc	ra,0xfffff
    80002694:	ea8080e7          	jalr	-344(ra) # 80001538 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002698:	70a2                	ld	ra,40(sp)
    8000269a:	7402                	ld	s0,32(sp)
    8000269c:	64e2                	ld	s1,24(sp)
    8000269e:	6942                	ld	s2,16(sp)
    800026a0:	69a2                	ld	s3,8(sp)
    800026a2:	6a02                	ld	s4,0(sp)
    800026a4:	6145                	addi	sp,sp,48
    800026a6:	8082                	ret
    memmove((char *)dst, src, len);
    800026a8:	000a061b          	sext.w	a2,s4
    800026ac:	85ce                	mv	a1,s3
    800026ae:	854a                	mv	a0,s2
    800026b0:	ffffe097          	auipc	ra,0xffffe
    800026b4:	51e080e7          	jalr	1310(ra) # 80000bce <memmove>
    return 0;
    800026b8:	8526                	mv	a0,s1
    800026ba:	bff9                	j	80002698 <either_copyout+0x32>

00000000800026bc <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800026bc:	7179                	addi	sp,sp,-48
    800026be:	f406                	sd	ra,40(sp)
    800026c0:	f022                	sd	s0,32(sp)
    800026c2:	ec26                	sd	s1,24(sp)
    800026c4:	e84a                	sd	s2,16(sp)
    800026c6:	e44e                	sd	s3,8(sp)
    800026c8:	e052                	sd	s4,0(sp)
    800026ca:	1800                	addi	s0,sp,48
    800026cc:	892a                	mv	s2,a0
    800026ce:	84ae                	mv	s1,a1
    800026d0:	89b2                	mv	s3,a2
    800026d2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800026d4:	fffff097          	auipc	ra,0xfffff
    800026d8:	170080e7          	jalr	368(ra) # 80001844 <myproc>
  if(user_src){
    800026dc:	c08d                	beqz	s1,800026fe <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800026de:	86d2                	mv	a3,s4
    800026e0:	864e                	mv	a2,s3
    800026e2:	85ca                	mv	a1,s2
    800026e4:	6d28                	ld	a0,88(a0)
    800026e6:	fffff097          	auipc	ra,0xfffff
    800026ea:	ede080e7          	jalr	-290(ra) # 800015c4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800026ee:	70a2                	ld	ra,40(sp)
    800026f0:	7402                	ld	s0,32(sp)
    800026f2:	64e2                	ld	s1,24(sp)
    800026f4:	6942                	ld	s2,16(sp)
    800026f6:	69a2                	ld	s3,8(sp)
    800026f8:	6a02                	ld	s4,0(sp)
    800026fa:	6145                	addi	sp,sp,48
    800026fc:	8082                	ret
    memmove(dst, (char*)src, len);
    800026fe:	000a061b          	sext.w	a2,s4
    80002702:	85ce                	mv	a1,s3
    80002704:	854a                	mv	a0,s2
    80002706:	ffffe097          	auipc	ra,0xffffe
    8000270a:	4c8080e7          	jalr	1224(ra) # 80000bce <memmove>
    return 0;
    8000270e:	8526                	mv	a0,s1
    80002710:	bff9                	j	800026ee <either_copyin+0x32>

0000000080002712 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002712:	715d                	addi	sp,sp,-80
    80002714:	e486                	sd	ra,72(sp)
    80002716:	e0a2                	sd	s0,64(sp)
    80002718:	fc26                	sd	s1,56(sp)
    8000271a:	f84a                	sd	s2,48(sp)
    8000271c:	f44e                	sd	s3,40(sp)
    8000271e:	f052                	sd	s4,32(sp)
    80002720:	ec56                	sd	s5,24(sp)
    80002722:	e85a                	sd	s6,16(sp)
    80002724:	e45e                	sd	s7,8(sp)
    80002726:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002728:	00005517          	auipc	a0,0x5
    8000272c:	cc050513          	addi	a0,a0,-832 # 800073e8 <userret+0x358>
    80002730:	ffffe097          	auipc	ra,0xffffe
    80002734:	e68080e7          	jalr	-408(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002738:	0000f497          	auipc	s1,0xf
    8000273c:	72848493          	addi	s1,s1,1832 # 80011e60 <proc+0x160>
    80002740:	00015917          	auipc	s2,0x15
    80002744:	32090913          	addi	s2,s2,800 # 80017a60 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002748:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    8000274a:	00005997          	auipc	s3,0x5
    8000274e:	c1698993          	addi	s3,s3,-1002 # 80007360 <userret+0x2d0>
    printf("%d %s %s", p->pid, state, p->name);
    80002752:	00005a97          	auipc	s5,0x5
    80002756:	c16a8a93          	addi	s5,s5,-1002 # 80007368 <userret+0x2d8>
    printf("\n");
    8000275a:	00005a17          	auipc	s4,0x5
    8000275e:	c8ea0a13          	addi	s4,s4,-882 # 800073e8 <userret+0x358>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002762:	00005b97          	auipc	s7,0x5
    80002766:	11eb8b93          	addi	s7,s7,286 # 80007880 <states.1754>
    8000276a:	a00d                	j	8000278c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000276c:	ed86a583          	lw	a1,-296(a3)
    80002770:	8556                	mv	a0,s5
    80002772:	ffffe097          	auipc	ra,0xffffe
    80002776:	e26080e7          	jalr	-474(ra) # 80000598 <printf>
    printf("\n");
    8000277a:	8552                	mv	a0,s4
    8000277c:	ffffe097          	auipc	ra,0xffffe
    80002780:	e1c080e7          	jalr	-484(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002784:	17048493          	addi	s1,s1,368
    80002788:	03248163          	beq	s1,s2,800027aa <procdump+0x98>
    if(p->state == UNUSED)
    8000278c:	86a6                	mv	a3,s1
    8000278e:	eb84a783          	lw	a5,-328(s1)
    80002792:	dbed                	beqz	a5,80002784 <procdump+0x72>
      state = "???";
    80002794:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002796:	fcfb6be3          	bltu	s6,a5,8000276c <procdump+0x5a>
    8000279a:	1782                	slli	a5,a5,0x20
    8000279c:	9381                	srli	a5,a5,0x20
    8000279e:	078e                	slli	a5,a5,0x3
    800027a0:	97de                	add	a5,a5,s7
    800027a2:	6390                	ld	a2,0(a5)
    800027a4:	f661                	bnez	a2,8000276c <procdump+0x5a>
      state = "???";
    800027a6:	864e                	mv	a2,s3
    800027a8:	b7d1                	j	8000276c <procdump+0x5a>
  }
}
    800027aa:	60a6                	ld	ra,72(sp)
    800027ac:	6406                	ld	s0,64(sp)
    800027ae:	74e2                	ld	s1,56(sp)
    800027b0:	7942                	ld	s2,48(sp)
    800027b2:	79a2                	ld	s3,40(sp)
    800027b4:	7a02                	ld	s4,32(sp)
    800027b6:	6ae2                	ld	s5,24(sp)
    800027b8:	6b42                	ld	s6,16(sp)
    800027ba:	6ba2                	ld	s7,8(sp)
    800027bc:	6161                	addi	sp,sp,80
    800027be:	8082                	ret

00000000800027c0 <swtch>:
    800027c0:	00153023          	sd	ra,0(a0)
    800027c4:	00253423          	sd	sp,8(a0)
    800027c8:	e900                	sd	s0,16(a0)
    800027ca:	ed04                	sd	s1,24(a0)
    800027cc:	03253023          	sd	s2,32(a0)
    800027d0:	03353423          	sd	s3,40(a0)
    800027d4:	03453823          	sd	s4,48(a0)
    800027d8:	03553c23          	sd	s5,56(a0)
    800027dc:	05653023          	sd	s6,64(a0)
    800027e0:	05753423          	sd	s7,72(a0)
    800027e4:	05853823          	sd	s8,80(a0)
    800027e8:	05953c23          	sd	s9,88(a0)
    800027ec:	07a53023          	sd	s10,96(a0)
    800027f0:	07b53423          	sd	s11,104(a0)
    800027f4:	0005b083          	ld	ra,0(a1)
    800027f8:	0085b103          	ld	sp,8(a1)
    800027fc:	6980                	ld	s0,16(a1)
    800027fe:	6d84                	ld	s1,24(a1)
    80002800:	0205b903          	ld	s2,32(a1)
    80002804:	0285b983          	ld	s3,40(a1)
    80002808:	0305ba03          	ld	s4,48(a1)
    8000280c:	0385ba83          	ld	s5,56(a1)
    80002810:	0405bb03          	ld	s6,64(a1)
    80002814:	0485bb83          	ld	s7,72(a1)
    80002818:	0505bc03          	ld	s8,80(a1)
    8000281c:	0585bc83          	ld	s9,88(a1)
    80002820:	0605bd03          	ld	s10,96(a1)
    80002824:	0685bd83          	ld	s11,104(a1)
    80002828:	8082                	ret

000000008000282a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000282a:	1141                	addi	sp,sp,-16
    8000282c:	e406                	sd	ra,8(sp)
    8000282e:	e022                	sd	s0,0(sp)
    80002830:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002832:	00005597          	auipc	a1,0x5
    80002836:	b6e58593          	addi	a1,a1,-1170 # 800073a0 <userret+0x310>
    8000283a:	00015517          	auipc	a0,0x15
    8000283e:	0c650513          	addi	a0,a0,198 # 80017900 <tickslock>
    80002842:	ffffe097          	auipc	ra,0xffffe
    80002846:	17e080e7          	jalr	382(ra) # 800009c0 <initlock>
}
    8000284a:	60a2                	ld	ra,8(sp)
    8000284c:	6402                	ld	s0,0(sp)
    8000284e:	0141                	addi	sp,sp,16
    80002850:	8082                	ret

0000000080002852 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002852:	1141                	addi	sp,sp,-16
    80002854:	e422                	sd	s0,8(sp)
    80002856:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002858:	00003797          	auipc	a5,0x3
    8000285c:	4d878793          	addi	a5,a5,1240 # 80005d30 <kernelvec>
    80002860:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002864:	6422                	ld	s0,8(sp)
    80002866:	0141                	addi	sp,sp,16
    80002868:	8082                	ret

000000008000286a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000286a:	1141                	addi	sp,sp,-16
    8000286c:	e406                	sd	ra,8(sp)
    8000286e:	e022                	sd	s0,0(sp)
    80002870:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002872:	fffff097          	auipc	ra,0xfffff
    80002876:	fd2080e7          	jalr	-46(ra) # 80001844 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000287a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000287e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002880:	10079073          	csrw	sstatus,a5
  // turn off interrupts, since we're switching
  // now from kerneltrap() to usertrap().
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002884:	00004817          	auipc	a6,0x4
    80002888:	77c80813          	addi	a6,a6,1916 # 80007000 <trampoline>
    8000288c:	00004717          	auipc	a4,0x4
    80002890:	77470713          	addi	a4,a4,1908 # 80007000 <trampoline>
    80002894:	41070733          	sub	a4,a4,a6
    80002898:	04000637          	lui	a2,0x4000
    8000289c:	fff60793          	addi	a5,a2,-1 # 3ffffff <_entry-0x7c000001>
    800028a0:	00c79693          	slli	a3,a5,0xc
    800028a4:	9736                	add	a4,a4,a3
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028a6:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->tf->kernel_satp = r_satp();         // kernel page table
    800028aa:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800028ac:	18002773          	csrr	a4,satp
    800028b0:	e398                	sd	a4,0(a5)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800028b2:	713c                	ld	a5,96(a0)
    800028b4:	6538                	ld	a4,72(a0)
    800028b6:	6585                	lui	a1,0x1
    800028b8:	972e                	add	a4,a4,a1
    800028ba:	e798                	sd	a4,8(a5)
  p->tf->kernel_trap = (uint64)usertrap;
    800028bc:	713c                	ld	a5,96(a0)
    800028be:	00000717          	auipc	a4,0x0
    800028c2:	13a70713          	addi	a4,a4,314 # 800029f8 <usertrap>
    800028c6:	eb98                	sd	a4,16(a5)
  p->tf->kernel_hartid = r_tp();         // hartid for cpuid()
    800028c8:	713c                	ld	a5,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800028ca:	8712                	mv	a4,tp
    800028cc:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028ce:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800028d2:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800028d6:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028da:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->tf->epc);
    800028de:	713c                	ld	a5,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028e0:	6f9c                	ld	a5,24(a5)
    800028e2:	14179073          	csrw	sepc,a5

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800028e6:	6d2c                	ld	a1,88(a0)
    800028e8:	81b1                	srli	a1,a1,0xc
  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
  //((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
  ((void (*)(uint64,uint64))fn)(TRAPFRAME-2*(p - proc)*PGSIZE, satp);
    800028ea:	0000f797          	auipc	a5,0xf
    800028ee:	41678793          	addi	a5,a5,1046 # 80011d00 <proc>
    800028f2:	8d1d                	sub	a0,a0,a5
    800028f4:	850d                	srai	a0,a0,0x3
    800028f6:	00005797          	auipc	a5,0x5
    800028fa:	0927b783          	ld	a5,146(a5) # 80007988 <syscalls+0xc8>
    800028fe:	02f50533          	mul	a0,a0,a5
    80002902:	1679                	addi	a2,a2,-2
    80002904:	9532                	add	a0,a0,a2
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002906:	00004797          	auipc	a5,0x4
    8000290a:	78a78793          	addi	a5,a5,1930 # 80007090 <userret>
    8000290e:	410787b3          	sub	a5,a5,a6
    80002912:	97b6                	add	a5,a5,a3
  ((void (*)(uint64,uint64))fn)(TRAPFRAME-2*(p - proc)*PGSIZE, satp);
    80002914:	577d                	li	a4,-1
    80002916:	177e                	slli	a4,a4,0x3f
    80002918:	8dd9                	or	a1,a1,a4
    8000291a:	0532                	slli	a0,a0,0xc
    8000291c:	9782                	jalr	a5
}
    8000291e:	60a2                	ld	ra,8(sp)
    80002920:	6402                	ld	s0,0(sp)
    80002922:	0141                	addi	sp,sp,16
    80002924:	8082                	ret

0000000080002926 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002926:	1101                	addi	sp,sp,-32
    80002928:	ec06                	sd	ra,24(sp)
    8000292a:	e822                	sd	s0,16(sp)
    8000292c:	e426                	sd	s1,8(sp)
    8000292e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002930:	00015497          	auipc	s1,0x15
    80002934:	fd048493          	addi	s1,s1,-48 # 80017900 <tickslock>
    80002938:	8526                	mv	a0,s1
    8000293a:	ffffe097          	auipc	ra,0xffffe
    8000293e:	198080e7          	jalr	408(ra) # 80000ad2 <acquire>
  ticks++;
    80002942:	00023517          	auipc	a0,0x23
    80002946:	6d650513          	addi	a0,a0,1750 # 80026018 <ticks>
    8000294a:	411c                	lw	a5,0(a0)
    8000294c:	2785                	addiw	a5,a5,1
    8000294e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002950:	00000097          	auipc	ra,0x0
    80002954:	c3c080e7          	jalr	-964(ra) # 8000258c <wakeup>
  release(&tickslock);
    80002958:	8526                	mv	a0,s1
    8000295a:	ffffe097          	auipc	ra,0xffffe
    8000295e:	1cc080e7          	jalr	460(ra) # 80000b26 <release>
}
    80002962:	60e2                	ld	ra,24(sp)
    80002964:	6442                	ld	s0,16(sp)
    80002966:	64a2                	ld	s1,8(sp)
    80002968:	6105                	addi	sp,sp,32
    8000296a:	8082                	ret

000000008000296c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000296c:	1101                	addi	sp,sp,-32
    8000296e:	ec06                	sd	ra,24(sp)
    80002970:	e822                	sd	s0,16(sp)
    80002972:	e426                	sd	s1,8(sp)
    80002974:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002976:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000297a:	00074d63          	bltz	a4,80002994 <devintr+0x28>
      virtio_disk_intr();
    }

    plic_complete(irq);
    return 1;
  } else if(scause == 0x8000000000000001L){
    8000297e:	57fd                	li	a5,-1
    80002980:	17fe                	slli	a5,a5,0x3f
    80002982:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002984:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002986:	04f70863          	beq	a4,a5,800029d6 <devintr+0x6a>
  }
}
    8000298a:	60e2                	ld	ra,24(sp)
    8000298c:	6442                	ld	s0,16(sp)
    8000298e:	64a2                	ld	s1,8(sp)
    80002990:	6105                	addi	sp,sp,32
    80002992:	8082                	ret
     (scause & 0xff) == 9){
    80002994:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002998:	46a5                	li	a3,9
    8000299a:	fed792e3          	bne	a5,a3,8000297e <devintr+0x12>
    int irq = plic_claim();
    8000299e:	00003097          	auipc	ra,0x3
    800029a2:	4ac080e7          	jalr	1196(ra) # 80005e4a <plic_claim>
    800029a6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800029a8:	47a9                	li	a5,10
    800029aa:	00f50c63          	beq	a0,a5,800029c2 <devintr+0x56>
    } else if(irq == VIRTIO0_IRQ){
    800029ae:	4785                	li	a5,1
    800029b0:	00f50e63          	beq	a0,a5,800029cc <devintr+0x60>
    plic_complete(irq);
    800029b4:	8526                	mv	a0,s1
    800029b6:	00003097          	auipc	ra,0x3
    800029ba:	4b8080e7          	jalr	1208(ra) # 80005e6e <plic_complete>
    return 1;
    800029be:	4505                	li	a0,1
    800029c0:	b7e9                	j	8000298a <devintr+0x1e>
      uartintr();
    800029c2:	ffffe097          	auipc	ra,0xffffe
    800029c6:	e76080e7          	jalr	-394(ra) # 80000838 <uartintr>
    800029ca:	b7ed                	j	800029b4 <devintr+0x48>
      virtio_disk_intr();
    800029cc:	00004097          	auipc	ra,0x4
    800029d0:	932080e7          	jalr	-1742(ra) # 800062fe <virtio_disk_intr>
    800029d4:	b7c5                	j	800029b4 <devintr+0x48>
    if(cpuid() == 0){
    800029d6:	fffff097          	auipc	ra,0xfffff
    800029da:	e42080e7          	jalr	-446(ra) # 80001818 <cpuid>
    800029de:	c901                	beqz	a0,800029ee <devintr+0x82>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800029e0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800029e4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800029e6:	14479073          	csrw	sip,a5
    return 2;
    800029ea:	4509                	li	a0,2
    800029ec:	bf79                	j	8000298a <devintr+0x1e>
      clockintr();
    800029ee:	00000097          	auipc	ra,0x0
    800029f2:	f38080e7          	jalr	-200(ra) # 80002926 <clockintr>
    800029f6:	b7ed                	j	800029e0 <devintr+0x74>

00000000800029f8 <usertrap>:
{
    800029f8:	1101                	addi	sp,sp,-32
    800029fa:	ec06                	sd	ra,24(sp)
    800029fc:	e822                	sd	s0,16(sp)
    800029fe:	e426                	sd	s1,8(sp)
    80002a00:	e04a                	sd	s2,0(sp)
    80002a02:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a04:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002a08:	1007f793          	andi	a5,a5,256
    80002a0c:	e7bd                	bnez	a5,80002a7a <usertrap+0x82>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a0e:	00003797          	auipc	a5,0x3
    80002a12:	32278793          	addi	a5,a5,802 # 80005d30 <kernelvec>
    80002a16:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002a1a:	fffff097          	auipc	ra,0xfffff
    80002a1e:	e2a080e7          	jalr	-470(ra) # 80001844 <myproc>
    80002a22:	84aa                	mv	s1,a0
  p->tf->epc = r_sepc();
    80002a24:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a26:	14102773          	csrr	a4,sepc
    80002a2a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a2c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002a30:	47a1                	li	a5,8
    80002a32:	06f71263          	bne	a4,a5,80002a96 <usertrap+0x9e>
    if(p->killed)
    80002a36:	591c                	lw	a5,48(a0)
    80002a38:	eba9                	bnez	a5,80002a8a <usertrap+0x92>
    p->tf->epc += 4;
    80002a3a:	70b8                	ld	a4,96(s1)
    80002a3c:	6f1c                	ld	a5,24(a4)
    80002a3e:	0791                	addi	a5,a5,4
    80002a40:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sie" : "=r" (x) );
    80002a42:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80002a46:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80002a4a:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a4e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002a52:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a56:	10079073          	csrw	sstatus,a5
    syscall();  //handle the syscall
    80002a5a:	00000097          	auipc	ra,0x0
    80002a5e:	324080e7          	jalr	804(ra) # 80002d7e <syscall>
  if(p->killed)
    80002a62:	589c                	lw	a5,48(s1)
    80002a64:	ebf1                	bnez	a5,80002b38 <usertrap+0x140>
  usertrapret();
    80002a66:	00000097          	auipc	ra,0x0
    80002a6a:	e04080e7          	jalr	-508(ra) # 8000286a <usertrapret>
}
    80002a6e:	60e2                	ld	ra,24(sp)
    80002a70:	6442                	ld	s0,16(sp)
    80002a72:	64a2                	ld	s1,8(sp)
    80002a74:	6902                	ld	s2,0(sp)
    80002a76:	6105                	addi	sp,sp,32
    80002a78:	8082                	ret
    panic("usertrap: not from user mode");
    80002a7a:	00005517          	auipc	a0,0x5
    80002a7e:	92e50513          	addi	a0,a0,-1746 # 800073a8 <userret+0x318>
    80002a82:	ffffe097          	auipc	ra,0xffffe
    80002a86:	acc080e7          	jalr	-1332(ra) # 8000054e <panic>
      exit(-1);
    80002a8a:	557d                	li	a0,-1
    80002a8c:	fffff097          	auipc	ra,0xfffff
    80002a90:	6f0080e7          	jalr	1776(ra) # 8000217c <exit>
    80002a94:	b75d                	j	80002a3a <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002a96:	00000097          	auipc	ra,0x0
    80002a9a:	ed6080e7          	jalr	-298(ra) # 8000296c <devintr>
    80002a9e:	892a                	mv	s2,a0
    80002aa0:	e949                	bnez	a0,80002b32 <usertrap+0x13a>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002aa2:	14202773          	csrr	a4,scause
  } else if(0xd ==r_scause()){ //p3 this is null pointer deference
    80002aa6:	47b5                	li	a5,13
    80002aa8:	04f70d63          	beq	a4,a5,80002b02 <usertrap+0x10a>
    80002aac:	14202773          	csrr	a4,scause
  } else if(0xf ==r_scause()){ //p3 this is write to read only memory
    80002ab0:	47bd                	li	a5,15
    80002ab2:	06f70463          	beq	a4,a5,80002b1a <usertrap+0x122>
    80002ab6:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002aba:	5c90                	lw	a2,56(s1)
    80002abc:	00005517          	auipc	a0,0x5
    80002ac0:	96c50513          	addi	a0,a0,-1684 # 80007428 <userret+0x398>
    80002ac4:	ffffe097          	auipc	ra,0xffffe
    80002ac8:	ad4080e7          	jalr	-1324(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002acc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ad0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002ad4:	00005517          	auipc	a0,0x5
    80002ad8:	98450513          	addi	a0,a0,-1660 # 80007458 <userret+0x3c8>
    80002adc:	ffffe097          	auipc	ra,0xffffe
    80002ae0:	abc080e7          	jalr	-1348(ra) # 80000598 <printf>
    p->killed = 1;
    80002ae4:	4785                	li	a5,1
    80002ae6:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002ae8:	557d                	li	a0,-1
    80002aea:	fffff097          	auipc	ra,0xfffff
    80002aee:	692080e7          	jalr	1682(ra) # 8000217c <exit>
  if(which_dev == 2)
    80002af2:	4789                	li	a5,2
    80002af4:	f6f919e3          	bne	s2,a5,80002a66 <usertrap+0x6e>
    yield();
    80002af8:	fffff097          	auipc	ra,0xfffff
    80002afc:	78e080e7          	jalr	1934(ra) # 80002286 <yield>
    80002b00:	b79d                	j	80002a66 <usertrap+0x6e>
    printf("Illegal Address Accesses, pid=%d\n",p->pid);
    80002b02:	5c8c                	lw	a1,56(s1)
    80002b04:	00005517          	auipc	a0,0x5
    80002b08:	8c450513          	addi	a0,a0,-1852 # 800073c8 <userret+0x338>
    80002b0c:	ffffe097          	auipc	ra,0xffffe
    80002b10:	a8c080e7          	jalr	-1396(ra) # 80000598 <printf>
    p->killed = 1;
    80002b14:	4785                	li	a5,1
    80002b16:	d89c                	sw	a5,48(s1)
    80002b18:	bfc1                	j	80002ae8 <usertrap+0xf0>
    printf("Do not have write permission to this address , pid=%d\n",p->pid);
    80002b1a:	5c8c                	lw	a1,56(s1)
    80002b1c:	00005517          	auipc	a0,0x5
    80002b20:	8d450513          	addi	a0,a0,-1836 # 800073f0 <userret+0x360>
    80002b24:	ffffe097          	auipc	ra,0xffffe
    80002b28:	a74080e7          	jalr	-1420(ra) # 80000598 <printf>
    p->killed = 1;
    80002b2c:	4785                	li	a5,1
    80002b2e:	d89c                	sw	a5,48(s1)
    80002b30:	bf65                	j	80002ae8 <usertrap+0xf0>
  if(p->killed)
    80002b32:	589c                	lw	a5,48(s1)
    80002b34:	dfdd                	beqz	a5,80002af2 <usertrap+0xfa>
    80002b36:	bf4d                	j	80002ae8 <usertrap+0xf0>
  int which_dev = 0;
    80002b38:	4901                	li	s2,0
    80002b3a:	b77d                	j	80002ae8 <usertrap+0xf0>

0000000080002b3c <kerneltrap>:
{
    80002b3c:	7179                	addi	sp,sp,-48
    80002b3e:	f406                	sd	ra,40(sp)
    80002b40:	f022                	sd	s0,32(sp)
    80002b42:	ec26                	sd	s1,24(sp)
    80002b44:	e84a                	sd	s2,16(sp)
    80002b46:	e44e                	sd	s3,8(sp)
    80002b48:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b4a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b4e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b52:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002b56:	1004f793          	andi	a5,s1,256
    80002b5a:	cb85                	beqz	a5,80002b8a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b5c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002b60:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002b62:	ef85                	bnez	a5,80002b9a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002b64:	00000097          	auipc	ra,0x0
    80002b68:	e08080e7          	jalr	-504(ra) # 8000296c <devintr>
    80002b6c:	cd1d                	beqz	a0,80002baa <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002b6e:	4789                	li	a5,2
    80002b70:	06f50a63          	beq	a0,a5,80002be4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002b74:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b78:	10049073          	csrw	sstatus,s1
}
    80002b7c:	70a2                	ld	ra,40(sp)
    80002b7e:	7402                	ld	s0,32(sp)
    80002b80:	64e2                	ld	s1,24(sp)
    80002b82:	6942                	ld	s2,16(sp)
    80002b84:	69a2                	ld	s3,8(sp)
    80002b86:	6145                	addi	sp,sp,48
    80002b88:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002b8a:	00005517          	auipc	a0,0x5
    80002b8e:	8ee50513          	addi	a0,a0,-1810 # 80007478 <userret+0x3e8>
    80002b92:	ffffe097          	auipc	ra,0xffffe
    80002b96:	9bc080e7          	jalr	-1604(ra) # 8000054e <panic>
    panic("kerneltrap: interrupts enabled");
    80002b9a:	00005517          	auipc	a0,0x5
    80002b9e:	90650513          	addi	a0,a0,-1786 # 800074a0 <userret+0x410>
    80002ba2:	ffffe097          	auipc	ra,0xffffe
    80002ba6:	9ac080e7          	jalr	-1620(ra) # 8000054e <panic>
    printf("scause %p\n", scause);
    80002baa:	85ce                	mv	a1,s3
    80002bac:	00005517          	auipc	a0,0x5
    80002bb0:	91450513          	addi	a0,a0,-1772 # 800074c0 <userret+0x430>
    80002bb4:	ffffe097          	auipc	ra,0xffffe
    80002bb8:	9e4080e7          	jalr	-1564(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002bbc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002bc0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002bc4:	00005517          	auipc	a0,0x5
    80002bc8:	90c50513          	addi	a0,a0,-1780 # 800074d0 <userret+0x440>
    80002bcc:	ffffe097          	auipc	ra,0xffffe
    80002bd0:	9cc080e7          	jalr	-1588(ra) # 80000598 <printf>
    panic("kerneltrap");
    80002bd4:	00005517          	auipc	a0,0x5
    80002bd8:	91450513          	addi	a0,a0,-1772 # 800074e8 <userret+0x458>
    80002bdc:	ffffe097          	auipc	ra,0xffffe
    80002be0:	972080e7          	jalr	-1678(ra) # 8000054e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002be4:	fffff097          	auipc	ra,0xfffff
    80002be8:	c60080e7          	jalr	-928(ra) # 80001844 <myproc>
    80002bec:	d541                	beqz	a0,80002b74 <kerneltrap+0x38>
    80002bee:	fffff097          	auipc	ra,0xfffff
    80002bf2:	c56080e7          	jalr	-938(ra) # 80001844 <myproc>
    80002bf6:	4d18                	lw	a4,24(a0)
    80002bf8:	478d                	li	a5,3
    80002bfa:	f6f71de3          	bne	a4,a5,80002b74 <kerneltrap+0x38>
    yield();
    80002bfe:	fffff097          	auipc	ra,0xfffff
    80002c02:	688080e7          	jalr	1672(ra) # 80002286 <yield>
    80002c06:	b7bd                	j	80002b74 <kerneltrap+0x38>

0000000080002c08 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002c08:	1101                	addi	sp,sp,-32
    80002c0a:	ec06                	sd	ra,24(sp)
    80002c0c:	e822                	sd	s0,16(sp)
    80002c0e:	e426                	sd	s1,8(sp)
    80002c10:	1000                	addi	s0,sp,32
    80002c12:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002c14:	fffff097          	auipc	ra,0xfffff
    80002c18:	c30080e7          	jalr	-976(ra) # 80001844 <myproc>
  switch (n) {
    80002c1c:	4795                	li	a5,5
    80002c1e:	0497e163          	bltu	a5,s1,80002c60 <argraw+0x58>
    80002c22:	048a                	slli	s1,s1,0x2
    80002c24:	00005717          	auipc	a4,0x5
    80002c28:	c8470713          	addi	a4,a4,-892 # 800078a8 <states.1754+0x28>
    80002c2c:	94ba                	add	s1,s1,a4
    80002c2e:	409c                	lw	a5,0(s1)
    80002c30:	97ba                	add	a5,a5,a4
    80002c32:	8782                	jr	a5
  case 0:
    return p->tf->a0;
    80002c34:	713c                	ld	a5,96(a0)
    80002c36:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
    80002c38:	60e2                	ld	ra,24(sp)
    80002c3a:	6442                	ld	s0,16(sp)
    80002c3c:	64a2                	ld	s1,8(sp)
    80002c3e:	6105                	addi	sp,sp,32
    80002c40:	8082                	ret
    return p->tf->a1;
    80002c42:	713c                	ld	a5,96(a0)
    80002c44:	7fa8                	ld	a0,120(a5)
    80002c46:	bfcd                	j	80002c38 <argraw+0x30>
    return p->tf->a2;
    80002c48:	713c                	ld	a5,96(a0)
    80002c4a:	63c8                	ld	a0,128(a5)
    80002c4c:	b7f5                	j	80002c38 <argraw+0x30>
    return p->tf->a3;
    80002c4e:	713c                	ld	a5,96(a0)
    80002c50:	67c8                	ld	a0,136(a5)
    80002c52:	b7dd                	j	80002c38 <argraw+0x30>
    return p->tf->a4;
    80002c54:	713c                	ld	a5,96(a0)
    80002c56:	6bc8                	ld	a0,144(a5)
    80002c58:	b7c5                	j	80002c38 <argraw+0x30>
    return p->tf->a5;
    80002c5a:	713c                	ld	a5,96(a0)
    80002c5c:	6fc8                	ld	a0,152(a5)
    80002c5e:	bfe9                	j	80002c38 <argraw+0x30>
  panic("argraw");
    80002c60:	00005517          	auipc	a0,0x5
    80002c64:	89850513          	addi	a0,a0,-1896 # 800074f8 <userret+0x468>
    80002c68:	ffffe097          	auipc	ra,0xffffe
    80002c6c:	8e6080e7          	jalr	-1818(ra) # 8000054e <panic>

0000000080002c70 <fetchaddr>:
{
    80002c70:	1101                	addi	sp,sp,-32
    80002c72:	ec06                	sd	ra,24(sp)
    80002c74:	e822                	sd	s0,16(sp)
    80002c76:	e426                	sd	s1,8(sp)
    80002c78:	e04a                	sd	s2,0(sp)
    80002c7a:	1000                	addi	s0,sp,32
    80002c7c:	84aa                	mv	s1,a0
    80002c7e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002c80:	fffff097          	auipc	ra,0xfffff
    80002c84:	bc4080e7          	jalr	-1084(ra) # 80001844 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002c88:	693c                	ld	a5,80(a0)
    80002c8a:	02f4f863          	bgeu	s1,a5,80002cba <fetchaddr+0x4a>
    80002c8e:	00848713          	addi	a4,s1,8
    80002c92:	02e7e663          	bltu	a5,a4,80002cbe <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002c96:	46a1                	li	a3,8
    80002c98:	8626                	mv	a2,s1
    80002c9a:	85ca                	mv	a1,s2
    80002c9c:	6d28                	ld	a0,88(a0)
    80002c9e:	fffff097          	auipc	ra,0xfffff
    80002ca2:	926080e7          	jalr	-1754(ra) # 800015c4 <copyin>
    80002ca6:	00a03533          	snez	a0,a0
    80002caa:	40a00533          	neg	a0,a0
}
    80002cae:	60e2                	ld	ra,24(sp)
    80002cb0:	6442                	ld	s0,16(sp)
    80002cb2:	64a2                	ld	s1,8(sp)
    80002cb4:	6902                	ld	s2,0(sp)
    80002cb6:	6105                	addi	sp,sp,32
    80002cb8:	8082                	ret
    return -1;
    80002cba:	557d                	li	a0,-1
    80002cbc:	bfcd                	j	80002cae <fetchaddr+0x3e>
    80002cbe:	557d                	li	a0,-1
    80002cc0:	b7fd                	j	80002cae <fetchaddr+0x3e>

0000000080002cc2 <fetchstr>:
{
    80002cc2:	7179                	addi	sp,sp,-48
    80002cc4:	f406                	sd	ra,40(sp)
    80002cc6:	f022                	sd	s0,32(sp)
    80002cc8:	ec26                	sd	s1,24(sp)
    80002cca:	e84a                	sd	s2,16(sp)
    80002ccc:	e44e                	sd	s3,8(sp)
    80002cce:	1800                	addi	s0,sp,48
    80002cd0:	892a                	mv	s2,a0
    80002cd2:	84ae                	mv	s1,a1
    80002cd4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002cd6:	fffff097          	auipc	ra,0xfffff
    80002cda:	b6e080e7          	jalr	-1170(ra) # 80001844 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002cde:	86ce                	mv	a3,s3
    80002ce0:	864a                	mv	a2,s2
    80002ce2:	85a6                	mv	a1,s1
    80002ce4:	6d28                	ld	a0,88(a0)
    80002ce6:	fffff097          	auipc	ra,0xfffff
    80002cea:	96a080e7          	jalr	-1686(ra) # 80001650 <copyinstr>
  if(err < 0)
    80002cee:	00054763          	bltz	a0,80002cfc <fetchstr+0x3a>
  return strlen(buf);
    80002cf2:	8526                	mv	a0,s1
    80002cf4:	ffffe097          	auipc	ra,0xffffe
    80002cf8:	002080e7          	jalr	2(ra) # 80000cf6 <strlen>
}
    80002cfc:	70a2                	ld	ra,40(sp)
    80002cfe:	7402                	ld	s0,32(sp)
    80002d00:	64e2                	ld	s1,24(sp)
    80002d02:	6942                	ld	s2,16(sp)
    80002d04:	69a2                	ld	s3,8(sp)
    80002d06:	6145                	addi	sp,sp,48
    80002d08:	8082                	ret

0000000080002d0a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002d0a:	1101                	addi	sp,sp,-32
    80002d0c:	ec06                	sd	ra,24(sp)
    80002d0e:	e822                	sd	s0,16(sp)
    80002d10:	e426                	sd	s1,8(sp)
    80002d12:	1000                	addi	s0,sp,32
    80002d14:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002d16:	00000097          	auipc	ra,0x0
    80002d1a:	ef2080e7          	jalr	-270(ra) # 80002c08 <argraw>
    80002d1e:	c088                	sw	a0,0(s1)
  return 0;
}
    80002d20:	4501                	li	a0,0
    80002d22:	60e2                	ld	ra,24(sp)
    80002d24:	6442                	ld	s0,16(sp)
    80002d26:	64a2                	ld	s1,8(sp)
    80002d28:	6105                	addi	sp,sp,32
    80002d2a:	8082                	ret

0000000080002d2c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002d2c:	1101                	addi	sp,sp,-32
    80002d2e:	ec06                	sd	ra,24(sp)
    80002d30:	e822                	sd	s0,16(sp)
    80002d32:	e426                	sd	s1,8(sp)
    80002d34:	1000                	addi	s0,sp,32
    80002d36:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002d38:	00000097          	auipc	ra,0x0
    80002d3c:	ed0080e7          	jalr	-304(ra) # 80002c08 <argraw>
    80002d40:	e088                	sd	a0,0(s1)
  //if(*ip < PGSIZE)
    //return -1;
  return 0;
}
    80002d42:	4501                	li	a0,0
    80002d44:	60e2                	ld	ra,24(sp)
    80002d46:	6442                	ld	s0,16(sp)
    80002d48:	64a2                	ld	s1,8(sp)
    80002d4a:	6105                	addi	sp,sp,32
    80002d4c:	8082                	ret

0000000080002d4e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002d4e:	1101                	addi	sp,sp,-32
    80002d50:	ec06                	sd	ra,24(sp)
    80002d52:	e822                	sd	s0,16(sp)
    80002d54:	e426                	sd	s1,8(sp)
    80002d56:	e04a                	sd	s2,0(sp)
    80002d58:	1000                	addi	s0,sp,32
    80002d5a:	84ae                	mv	s1,a1
    80002d5c:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002d5e:	00000097          	auipc	ra,0x0
    80002d62:	eaa080e7          	jalr	-342(ra) # 80002c08 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002d66:	864a                	mv	a2,s2
    80002d68:	85a6                	mv	a1,s1
    80002d6a:	00000097          	auipc	ra,0x0
    80002d6e:	f58080e7          	jalr	-168(ra) # 80002cc2 <fetchstr>
}
    80002d72:	60e2                	ld	ra,24(sp)
    80002d74:	6442                	ld	s0,16(sp)
    80002d76:	64a2                	ld	s1,8(sp)
    80002d78:	6902                	ld	s2,0(sp)
    80002d7a:	6105                	addi	sp,sp,32
    80002d7c:	8082                	ret

0000000080002d7e <syscall>:
[SYS_join]    sys_join, //p4
};

void
syscall(void)
{
    80002d7e:	1101                	addi	sp,sp,-32
    80002d80:	ec06                	sd	ra,24(sp)
    80002d82:	e822                	sd	s0,16(sp)
    80002d84:	e426                	sd	s1,8(sp)
    80002d86:	e04a                	sd	s2,0(sp)
    80002d88:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002d8a:	fffff097          	auipc	ra,0xfffff
    80002d8e:	aba080e7          	jalr	-1350(ra) # 80001844 <myproc>
    80002d92:	84aa                	mv	s1,a0

  num = p->tf->a7;
    80002d94:	06053903          	ld	s2,96(a0)
    80002d98:	0a893783          	ld	a5,168(s2)
    80002d9c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002da0:	37fd                	addiw	a5,a5,-1
    80002da2:	4759                	li	a4,22
    80002da4:	00f76f63          	bltu	a4,a5,80002dc2 <syscall+0x44>
    80002da8:	00369713          	slli	a4,a3,0x3
    80002dac:	00005797          	auipc	a5,0x5
    80002db0:	b1478793          	addi	a5,a5,-1260 # 800078c0 <syscalls>
    80002db4:	97ba                	add	a5,a5,a4
    80002db6:	639c                	ld	a5,0(a5)
    80002db8:	c789                	beqz	a5,80002dc2 <syscall+0x44>
    p->tf->a0 = syscalls[num]();
    80002dba:	9782                	jalr	a5
    80002dbc:	06a93823          	sd	a0,112(s2)
    80002dc0:	a839                	j	80002dde <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002dc2:	16048613          	addi	a2,s1,352
    80002dc6:	5c8c                	lw	a1,56(s1)
    80002dc8:	00004517          	auipc	a0,0x4
    80002dcc:	73850513          	addi	a0,a0,1848 # 80007500 <userret+0x470>
    80002dd0:	ffffd097          	auipc	ra,0xffffd
    80002dd4:	7c8080e7          	jalr	1992(ra) # 80000598 <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
    80002dd8:	70bc                	ld	a5,96(s1)
    80002dda:	577d                	li	a4,-1
    80002ddc:	fbb8                	sd	a4,112(a5)
  }
}
    80002dde:	60e2                	ld	ra,24(sp)
    80002de0:	6442                	ld	s0,16(sp)
    80002de2:	64a2                	ld	s1,8(sp)
    80002de4:	6902                	ld	s2,0(sp)
    80002de6:	6105                	addi	sp,sp,32
    80002de8:	8082                	ret

0000000080002dea <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002dea:	1101                	addi	sp,sp,-32
    80002dec:	ec06                	sd	ra,24(sp)
    80002dee:	e822                	sd	s0,16(sp)
    80002df0:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002df2:	fec40593          	addi	a1,s0,-20
    80002df6:	4501                	li	a0,0
    80002df8:	00000097          	auipc	ra,0x0
    80002dfc:	f12080e7          	jalr	-238(ra) # 80002d0a <argint>
    return -1;
    80002e00:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002e02:	00054963          	bltz	a0,80002e14 <sys_exit+0x2a>
  exit(n);
    80002e06:	fec42503          	lw	a0,-20(s0)
    80002e0a:	fffff097          	auipc	ra,0xfffff
    80002e0e:	372080e7          	jalr	882(ra) # 8000217c <exit>
  return 0;  // not reached
    80002e12:	4781                	li	a5,0
}
    80002e14:	853e                	mv	a0,a5
    80002e16:	60e2                	ld	ra,24(sp)
    80002e18:	6442                	ld	s0,16(sp)
    80002e1a:	6105                	addi	sp,sp,32
    80002e1c:	8082                	ret

0000000080002e1e <sys_getpid>:

uint64
sys_getpid(void)
{
    80002e1e:	1141                	addi	sp,sp,-16
    80002e20:	e406                	sd	ra,8(sp)
    80002e22:	e022                	sd	s0,0(sp)
    80002e24:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002e26:	fffff097          	auipc	ra,0xfffff
    80002e2a:	a1e080e7          	jalr	-1506(ra) # 80001844 <myproc>
}
    80002e2e:	5d08                	lw	a0,56(a0)
    80002e30:	60a2                	ld	ra,8(sp)
    80002e32:	6402                	ld	s0,0(sp)
    80002e34:	0141                	addi	sp,sp,16
    80002e36:	8082                	ret

0000000080002e38 <sys_fork>:


uint64
sys_fork(void)
{
    80002e38:	1141                	addi	sp,sp,-16
    80002e3a:	e406                	sd	ra,8(sp)
    80002e3c:	e022                	sd	s0,0(sp)
    80002e3e:	0800                	addi	s0,sp,16
  return fork();
    80002e40:	fffff097          	auipc	ra,0xfffff
    80002e44:	e12080e7          	jalr	-494(ra) # 80001c52 <fork>
}
    80002e48:	60a2                	ld	ra,8(sp)
    80002e4a:	6402                	ld	s0,0(sp)
    80002e4c:	0141                	addi	sp,sp,16
    80002e4e:	8082                	ret

0000000080002e50 <sys_wait>:

uint64
sys_wait(void)
{
    80002e50:	1101                	addi	sp,sp,-32
    80002e52:	ec06                	sd	ra,24(sp)
    80002e54:	e822                	sd	s0,16(sp)
    80002e56:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002e58:	fe840593          	addi	a1,s0,-24
    80002e5c:	4501                	li	a0,0
    80002e5e:	00000097          	auipc	ra,0x0
    80002e62:	ece080e7          	jalr	-306(ra) # 80002d2c <argaddr>
    80002e66:	87aa                	mv	a5,a0
    return -1;
    80002e68:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002e6a:	0007c863          	bltz	a5,80002e7a <sys_wait+0x2a>
  return wait(p);
    80002e6e:	fe843503          	ld	a0,-24(s0)
    80002e72:	fffff097          	auipc	ra,0xfffff
    80002e76:	608080e7          	jalr	1544(ra) # 8000247a <wait>
}
    80002e7a:	60e2                	ld	ra,24(sp)
    80002e7c:	6442                	ld	s0,16(sp)
    80002e7e:	6105                	addi	sp,sp,32
    80002e80:	8082                	ret

0000000080002e82 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002e82:	7179                	addi	sp,sp,-48
    80002e84:	f406                	sd	ra,40(sp)
    80002e86:	f022                	sd	s0,32(sp)
    80002e88:	ec26                	sd	s1,24(sp)
    80002e8a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002e8c:	fdc40593          	addi	a1,s0,-36
    80002e90:	4501                	li	a0,0
    80002e92:	00000097          	auipc	ra,0x0
    80002e96:	e78080e7          	jalr	-392(ra) # 80002d0a <argint>
    80002e9a:	87aa                	mv	a5,a0
    return -1;
    80002e9c:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002e9e:	0207c063          	bltz	a5,80002ebe <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002ea2:	fffff097          	auipc	ra,0xfffff
    80002ea6:	9a2080e7          	jalr	-1630(ra) # 80001844 <myproc>
    80002eaa:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    80002eac:	fdc42503          	lw	a0,-36(s0)
    80002eb0:	fffff097          	auipc	ra,0xfffff
    80002eb4:	d2e080e7          	jalr	-722(ra) # 80001bde <growproc>
    80002eb8:	00054863          	bltz	a0,80002ec8 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002ebc:	8526                	mv	a0,s1
}
    80002ebe:	70a2                	ld	ra,40(sp)
    80002ec0:	7402                	ld	s0,32(sp)
    80002ec2:	64e2                	ld	s1,24(sp)
    80002ec4:	6145                	addi	sp,sp,48
    80002ec6:	8082                	ret
    return -1;
    80002ec8:	557d                	li	a0,-1
    80002eca:	bfd5                	j	80002ebe <sys_sbrk+0x3c>

0000000080002ecc <sys_sleep>:

uint64
sys_sleep(void)
{
    80002ecc:	7139                	addi	sp,sp,-64
    80002ece:	fc06                	sd	ra,56(sp)
    80002ed0:	f822                	sd	s0,48(sp)
    80002ed2:	f426                	sd	s1,40(sp)
    80002ed4:	f04a                	sd	s2,32(sp)
    80002ed6:	ec4e                	sd	s3,24(sp)
    80002ed8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002eda:	fcc40593          	addi	a1,s0,-52
    80002ede:	4501                	li	a0,0
    80002ee0:	00000097          	auipc	ra,0x0
    80002ee4:	e2a080e7          	jalr	-470(ra) # 80002d0a <argint>
    return -1;
    80002ee8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002eea:	06054563          	bltz	a0,80002f54 <sys_sleep+0x88>
  acquire(&tickslock);
    80002eee:	00015517          	auipc	a0,0x15
    80002ef2:	a1250513          	addi	a0,a0,-1518 # 80017900 <tickslock>
    80002ef6:	ffffe097          	auipc	ra,0xffffe
    80002efa:	bdc080e7          	jalr	-1060(ra) # 80000ad2 <acquire>
  ticks0 = ticks;
    80002efe:	00023917          	auipc	s2,0x23
    80002f02:	11a92903          	lw	s2,282(s2) # 80026018 <ticks>
  while(ticks - ticks0 < n){
    80002f06:	fcc42783          	lw	a5,-52(s0)
    80002f0a:	cf85                	beqz	a5,80002f42 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002f0c:	00015997          	auipc	s3,0x15
    80002f10:	9f498993          	addi	s3,s3,-1548 # 80017900 <tickslock>
    80002f14:	00023497          	auipc	s1,0x23
    80002f18:	10448493          	addi	s1,s1,260 # 80026018 <ticks>
    if(myproc()->killed){
    80002f1c:	fffff097          	auipc	ra,0xfffff
    80002f20:	928080e7          	jalr	-1752(ra) # 80001844 <myproc>
    80002f24:	591c                	lw	a5,48(a0)
    80002f26:	ef9d                	bnez	a5,80002f64 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002f28:	85ce                	mv	a1,s3
    80002f2a:	8526                	mv	a0,s1
    80002f2c:	fffff097          	auipc	ra,0xfffff
    80002f30:	396080e7          	jalr	918(ra) # 800022c2 <sleep>
  while(ticks - ticks0 < n){
    80002f34:	409c                	lw	a5,0(s1)
    80002f36:	412787bb          	subw	a5,a5,s2
    80002f3a:	fcc42703          	lw	a4,-52(s0)
    80002f3e:	fce7efe3          	bltu	a5,a4,80002f1c <sys_sleep+0x50>
  }
  release(&tickslock);
    80002f42:	00015517          	auipc	a0,0x15
    80002f46:	9be50513          	addi	a0,a0,-1602 # 80017900 <tickslock>
    80002f4a:	ffffe097          	auipc	ra,0xffffe
    80002f4e:	bdc080e7          	jalr	-1060(ra) # 80000b26 <release>
  return 0;
    80002f52:	4781                	li	a5,0
}
    80002f54:	853e                	mv	a0,a5
    80002f56:	70e2                	ld	ra,56(sp)
    80002f58:	7442                	ld	s0,48(sp)
    80002f5a:	74a2                	ld	s1,40(sp)
    80002f5c:	7902                	ld	s2,32(sp)
    80002f5e:	69e2                	ld	s3,24(sp)
    80002f60:	6121                	addi	sp,sp,64
    80002f62:	8082                	ret
      release(&tickslock);
    80002f64:	00015517          	auipc	a0,0x15
    80002f68:	99c50513          	addi	a0,a0,-1636 # 80017900 <tickslock>
    80002f6c:	ffffe097          	auipc	ra,0xffffe
    80002f70:	bba080e7          	jalr	-1094(ra) # 80000b26 <release>
      return -1;
    80002f74:	57fd                	li	a5,-1
    80002f76:	bff9                	j	80002f54 <sys_sleep+0x88>

0000000080002f78 <sys_kill>:

uint64
sys_kill(void)
{
    80002f78:	1101                	addi	sp,sp,-32
    80002f7a:	ec06                	sd	ra,24(sp)
    80002f7c:	e822                	sd	s0,16(sp)
    80002f7e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002f80:	fec40593          	addi	a1,s0,-20
    80002f84:	4501                	li	a0,0
    80002f86:	00000097          	auipc	ra,0x0
    80002f8a:	d84080e7          	jalr	-636(ra) # 80002d0a <argint>
    80002f8e:	87aa                	mv	a5,a0
    return -1;
    80002f90:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002f92:	0007c863          	bltz	a5,80002fa2 <sys_kill+0x2a>
  return kill(pid);
    80002f96:	fec42503          	lw	a0,-20(s0)
    80002f9a:	fffff097          	auipc	ra,0xfffff
    80002f9e:	65c080e7          	jalr	1628(ra) # 800025f6 <kill>
}
    80002fa2:	60e2                	ld	ra,24(sp)
    80002fa4:	6442                	ld	s0,16(sp)
    80002fa6:	6105                	addi	sp,sp,32
    80002fa8:	8082                	ret

0000000080002faa <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002faa:	1101                	addi	sp,sp,-32
    80002fac:	ec06                	sd	ra,24(sp)
    80002fae:	e822                	sd	s0,16(sp)
    80002fb0:	e426                	sd	s1,8(sp)
    80002fb2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002fb4:	00015517          	auipc	a0,0x15
    80002fb8:	94c50513          	addi	a0,a0,-1716 # 80017900 <tickslock>
    80002fbc:	ffffe097          	auipc	ra,0xffffe
    80002fc0:	b16080e7          	jalr	-1258(ra) # 80000ad2 <acquire>
  xticks = ticks;
    80002fc4:	00023497          	auipc	s1,0x23
    80002fc8:	0544a483          	lw	s1,84(s1) # 80026018 <ticks>
  release(&tickslock);
    80002fcc:	00015517          	auipc	a0,0x15
    80002fd0:	93450513          	addi	a0,a0,-1740 # 80017900 <tickslock>
    80002fd4:	ffffe097          	auipc	ra,0xffffe
    80002fd8:	b52080e7          	jalr	-1198(ra) # 80000b26 <release>
  return xticks;
}
    80002fdc:	02049513          	slli	a0,s1,0x20
    80002fe0:	9101                	srli	a0,a0,0x20
    80002fe2:	60e2                	ld	ra,24(sp)
    80002fe4:	6442                	ld	s0,16(sp)
    80002fe6:	64a2                	ld	s1,8(sp)
    80002fe8:	6105                	addi	sp,sp,32
    80002fea:	8082                	ret

0000000080002fec <sys_tester>:

//self defined sys teseter
uint64
sys_tester(void)
{
    80002fec:	1141                	addi	sp,sp,-16
    80002fee:	e422                	sd	s0,8(sp)
    80002ff0:	0800                	addi	s0,sp,16
  return 0;
}
    80002ff2:	4501                	li	a0,0
    80002ff4:	6422                	ld	s0,8(sp)
    80002ff6:	0141                	addi	sp,sp,16
    80002ff8:	8082                	ret

0000000080002ffa <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002ffa:	7179                	addi	sp,sp,-48
    80002ffc:	f406                	sd	ra,40(sp)
    80002ffe:	f022                	sd	s0,32(sp)
    80003000:	ec26                	sd	s1,24(sp)
    80003002:	e84a                	sd	s2,16(sp)
    80003004:	e44e                	sd	s3,8(sp)
    80003006:	e052                	sd	s4,0(sp)
    80003008:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000300a:	00004597          	auipc	a1,0x4
    8000300e:	51658593          	addi	a1,a1,1302 # 80007520 <userret+0x490>
    80003012:	00015517          	auipc	a0,0x15
    80003016:	90650513          	addi	a0,a0,-1786 # 80017918 <bcache>
    8000301a:	ffffe097          	auipc	ra,0xffffe
    8000301e:	9a6080e7          	jalr	-1626(ra) # 800009c0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003022:	0001d797          	auipc	a5,0x1d
    80003026:	8f678793          	addi	a5,a5,-1802 # 8001f918 <bcache+0x8000>
    8000302a:	0001d717          	auipc	a4,0x1d
    8000302e:	c4670713          	addi	a4,a4,-954 # 8001fc70 <bcache+0x8358>
    80003032:	3ae7b023          	sd	a4,928(a5)
  bcache.head.next = &bcache.head;
    80003036:	3ae7b423          	sd	a4,936(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000303a:	00015497          	auipc	s1,0x15
    8000303e:	8f648493          	addi	s1,s1,-1802 # 80017930 <bcache+0x18>
    b->next = bcache.head.next;
    80003042:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003044:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003046:	00004a17          	auipc	s4,0x4
    8000304a:	4e2a0a13          	addi	s4,s4,1250 # 80007528 <userret+0x498>
    b->next = bcache.head.next;
    8000304e:	3a893783          	ld	a5,936(s2)
    80003052:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003054:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003058:	85d2                	mv	a1,s4
    8000305a:	01048513          	addi	a0,s1,16
    8000305e:	00001097          	auipc	ra,0x1
    80003062:	486080e7          	jalr	1158(ra) # 800044e4 <initsleeplock>
    bcache.head.next->prev = b;
    80003066:	3a893783          	ld	a5,936(s2)
    8000306a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000306c:	3a993423          	sd	s1,936(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003070:	46048493          	addi	s1,s1,1120
    80003074:	fd349de3          	bne	s1,s3,8000304e <binit+0x54>
  }
}
    80003078:	70a2                	ld	ra,40(sp)
    8000307a:	7402                	ld	s0,32(sp)
    8000307c:	64e2                	ld	s1,24(sp)
    8000307e:	6942                	ld	s2,16(sp)
    80003080:	69a2                	ld	s3,8(sp)
    80003082:	6a02                	ld	s4,0(sp)
    80003084:	6145                	addi	sp,sp,48
    80003086:	8082                	ret

0000000080003088 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003088:	7179                	addi	sp,sp,-48
    8000308a:	f406                	sd	ra,40(sp)
    8000308c:	f022                	sd	s0,32(sp)
    8000308e:	ec26                	sd	s1,24(sp)
    80003090:	e84a                	sd	s2,16(sp)
    80003092:	e44e                	sd	s3,8(sp)
    80003094:	1800                	addi	s0,sp,48
    80003096:	89aa                	mv	s3,a0
    80003098:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000309a:	00015517          	auipc	a0,0x15
    8000309e:	87e50513          	addi	a0,a0,-1922 # 80017918 <bcache>
    800030a2:	ffffe097          	auipc	ra,0xffffe
    800030a6:	a30080e7          	jalr	-1488(ra) # 80000ad2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800030aa:	0001d497          	auipc	s1,0x1d
    800030ae:	c164b483          	ld	s1,-1002(s1) # 8001fcc0 <bcache+0x83a8>
    800030b2:	0001d797          	auipc	a5,0x1d
    800030b6:	bbe78793          	addi	a5,a5,-1090 # 8001fc70 <bcache+0x8358>
    800030ba:	02f48f63          	beq	s1,a5,800030f8 <bread+0x70>
    800030be:	873e                	mv	a4,a5
    800030c0:	a021                	j	800030c8 <bread+0x40>
    800030c2:	68a4                	ld	s1,80(s1)
    800030c4:	02e48a63          	beq	s1,a4,800030f8 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800030c8:	449c                	lw	a5,8(s1)
    800030ca:	ff379ce3          	bne	a5,s3,800030c2 <bread+0x3a>
    800030ce:	44dc                	lw	a5,12(s1)
    800030d0:	ff2799e3          	bne	a5,s2,800030c2 <bread+0x3a>
      b->refcnt++;
    800030d4:	40bc                	lw	a5,64(s1)
    800030d6:	2785                	addiw	a5,a5,1
    800030d8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800030da:	00015517          	auipc	a0,0x15
    800030de:	83e50513          	addi	a0,a0,-1986 # 80017918 <bcache>
    800030e2:	ffffe097          	auipc	ra,0xffffe
    800030e6:	a44080e7          	jalr	-1468(ra) # 80000b26 <release>
      acquiresleep(&b->lock);
    800030ea:	01048513          	addi	a0,s1,16
    800030ee:	00001097          	auipc	ra,0x1
    800030f2:	430080e7          	jalr	1072(ra) # 8000451e <acquiresleep>
      return b;
    800030f6:	a8b9                	j	80003154 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800030f8:	0001d497          	auipc	s1,0x1d
    800030fc:	bc04b483          	ld	s1,-1088(s1) # 8001fcb8 <bcache+0x83a0>
    80003100:	0001d797          	auipc	a5,0x1d
    80003104:	b7078793          	addi	a5,a5,-1168 # 8001fc70 <bcache+0x8358>
    80003108:	00f48863          	beq	s1,a5,80003118 <bread+0x90>
    8000310c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000310e:	40bc                	lw	a5,64(s1)
    80003110:	cf81                	beqz	a5,80003128 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003112:	64a4                	ld	s1,72(s1)
    80003114:	fee49de3          	bne	s1,a4,8000310e <bread+0x86>
  panic("bget: no buffers");
    80003118:	00004517          	auipc	a0,0x4
    8000311c:	41850513          	addi	a0,a0,1048 # 80007530 <userret+0x4a0>
    80003120:	ffffd097          	auipc	ra,0xffffd
    80003124:	42e080e7          	jalr	1070(ra) # 8000054e <panic>
      b->dev = dev;
    80003128:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000312c:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80003130:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003134:	4785                	li	a5,1
    80003136:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003138:	00014517          	auipc	a0,0x14
    8000313c:	7e050513          	addi	a0,a0,2016 # 80017918 <bcache>
    80003140:	ffffe097          	auipc	ra,0xffffe
    80003144:	9e6080e7          	jalr	-1562(ra) # 80000b26 <release>
      acquiresleep(&b->lock);
    80003148:	01048513          	addi	a0,s1,16
    8000314c:	00001097          	auipc	ra,0x1
    80003150:	3d2080e7          	jalr	978(ra) # 8000451e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003154:	409c                	lw	a5,0(s1)
    80003156:	cb89                	beqz	a5,80003168 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003158:	8526                	mv	a0,s1
    8000315a:	70a2                	ld	ra,40(sp)
    8000315c:	7402                	ld	s0,32(sp)
    8000315e:	64e2                	ld	s1,24(sp)
    80003160:	6942                	ld	s2,16(sp)
    80003162:	69a2                	ld	s3,8(sp)
    80003164:	6145                	addi	sp,sp,48
    80003166:	8082                	ret
    virtio_disk_rw(b, 0);
    80003168:	4581                	li	a1,0
    8000316a:	8526                	mv	a0,s1
    8000316c:	00003097          	auipc	ra,0x3
    80003170:	ef2080e7          	jalr	-270(ra) # 8000605e <virtio_disk_rw>
    b->valid = 1;
    80003174:	4785                	li	a5,1
    80003176:	c09c                	sw	a5,0(s1)
  return b;
    80003178:	b7c5                	j	80003158 <bread+0xd0>

000000008000317a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000317a:	1101                	addi	sp,sp,-32
    8000317c:	ec06                	sd	ra,24(sp)
    8000317e:	e822                	sd	s0,16(sp)
    80003180:	e426                	sd	s1,8(sp)
    80003182:	1000                	addi	s0,sp,32
    80003184:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003186:	0541                	addi	a0,a0,16
    80003188:	00001097          	auipc	ra,0x1
    8000318c:	430080e7          	jalr	1072(ra) # 800045b8 <holdingsleep>
    80003190:	cd01                	beqz	a0,800031a8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003192:	4585                	li	a1,1
    80003194:	8526                	mv	a0,s1
    80003196:	00003097          	auipc	ra,0x3
    8000319a:	ec8080e7          	jalr	-312(ra) # 8000605e <virtio_disk_rw>
}
    8000319e:	60e2                	ld	ra,24(sp)
    800031a0:	6442                	ld	s0,16(sp)
    800031a2:	64a2                	ld	s1,8(sp)
    800031a4:	6105                	addi	sp,sp,32
    800031a6:	8082                	ret
    panic("bwrite");
    800031a8:	00004517          	auipc	a0,0x4
    800031ac:	3a050513          	addi	a0,a0,928 # 80007548 <userret+0x4b8>
    800031b0:	ffffd097          	auipc	ra,0xffffd
    800031b4:	39e080e7          	jalr	926(ra) # 8000054e <panic>

00000000800031b8 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
    800031b8:	1101                	addi	sp,sp,-32
    800031ba:	ec06                	sd	ra,24(sp)
    800031bc:	e822                	sd	s0,16(sp)
    800031be:	e426                	sd	s1,8(sp)
    800031c0:	e04a                	sd	s2,0(sp)
    800031c2:	1000                	addi	s0,sp,32
    800031c4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800031c6:	01050913          	addi	s2,a0,16
    800031ca:	854a                	mv	a0,s2
    800031cc:	00001097          	auipc	ra,0x1
    800031d0:	3ec080e7          	jalr	1004(ra) # 800045b8 <holdingsleep>
    800031d4:	c92d                	beqz	a0,80003246 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800031d6:	854a                	mv	a0,s2
    800031d8:	00001097          	auipc	ra,0x1
    800031dc:	39c080e7          	jalr	924(ra) # 80004574 <releasesleep>

  acquire(&bcache.lock);
    800031e0:	00014517          	auipc	a0,0x14
    800031e4:	73850513          	addi	a0,a0,1848 # 80017918 <bcache>
    800031e8:	ffffe097          	auipc	ra,0xffffe
    800031ec:	8ea080e7          	jalr	-1814(ra) # 80000ad2 <acquire>
  b->refcnt--;
    800031f0:	40bc                	lw	a5,64(s1)
    800031f2:	37fd                	addiw	a5,a5,-1
    800031f4:	0007871b          	sext.w	a4,a5
    800031f8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800031fa:	eb05                	bnez	a4,8000322a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800031fc:	68bc                	ld	a5,80(s1)
    800031fe:	64b8                	ld	a4,72(s1)
    80003200:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003202:	64bc                	ld	a5,72(s1)
    80003204:	68b8                	ld	a4,80(s1)
    80003206:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003208:	0001c797          	auipc	a5,0x1c
    8000320c:	71078793          	addi	a5,a5,1808 # 8001f918 <bcache+0x8000>
    80003210:	3a87b703          	ld	a4,936(a5)
    80003214:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003216:	0001d717          	auipc	a4,0x1d
    8000321a:	a5a70713          	addi	a4,a4,-1446 # 8001fc70 <bcache+0x8358>
    8000321e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003220:	3a87b703          	ld	a4,936(a5)
    80003224:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003226:	3a97b423          	sd	s1,936(a5)
  }
  
  release(&bcache.lock);
    8000322a:	00014517          	auipc	a0,0x14
    8000322e:	6ee50513          	addi	a0,a0,1774 # 80017918 <bcache>
    80003232:	ffffe097          	auipc	ra,0xffffe
    80003236:	8f4080e7          	jalr	-1804(ra) # 80000b26 <release>
}
    8000323a:	60e2                	ld	ra,24(sp)
    8000323c:	6442                	ld	s0,16(sp)
    8000323e:	64a2                	ld	s1,8(sp)
    80003240:	6902                	ld	s2,0(sp)
    80003242:	6105                	addi	sp,sp,32
    80003244:	8082                	ret
    panic("brelse");
    80003246:	00004517          	auipc	a0,0x4
    8000324a:	30a50513          	addi	a0,a0,778 # 80007550 <userret+0x4c0>
    8000324e:	ffffd097          	auipc	ra,0xffffd
    80003252:	300080e7          	jalr	768(ra) # 8000054e <panic>

0000000080003256 <bpin>:

void
bpin(struct buf *b) {
    80003256:	1101                	addi	sp,sp,-32
    80003258:	ec06                	sd	ra,24(sp)
    8000325a:	e822                	sd	s0,16(sp)
    8000325c:	e426                	sd	s1,8(sp)
    8000325e:	1000                	addi	s0,sp,32
    80003260:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003262:	00014517          	auipc	a0,0x14
    80003266:	6b650513          	addi	a0,a0,1718 # 80017918 <bcache>
    8000326a:	ffffe097          	auipc	ra,0xffffe
    8000326e:	868080e7          	jalr	-1944(ra) # 80000ad2 <acquire>
  b->refcnt++;
    80003272:	40bc                	lw	a5,64(s1)
    80003274:	2785                	addiw	a5,a5,1
    80003276:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003278:	00014517          	auipc	a0,0x14
    8000327c:	6a050513          	addi	a0,a0,1696 # 80017918 <bcache>
    80003280:	ffffe097          	auipc	ra,0xffffe
    80003284:	8a6080e7          	jalr	-1882(ra) # 80000b26 <release>
}
    80003288:	60e2                	ld	ra,24(sp)
    8000328a:	6442                	ld	s0,16(sp)
    8000328c:	64a2                	ld	s1,8(sp)
    8000328e:	6105                	addi	sp,sp,32
    80003290:	8082                	ret

0000000080003292 <bunpin>:

void
bunpin(struct buf *b) {
    80003292:	1101                	addi	sp,sp,-32
    80003294:	ec06                	sd	ra,24(sp)
    80003296:	e822                	sd	s0,16(sp)
    80003298:	e426                	sd	s1,8(sp)
    8000329a:	1000                	addi	s0,sp,32
    8000329c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000329e:	00014517          	auipc	a0,0x14
    800032a2:	67a50513          	addi	a0,a0,1658 # 80017918 <bcache>
    800032a6:	ffffe097          	auipc	ra,0xffffe
    800032aa:	82c080e7          	jalr	-2004(ra) # 80000ad2 <acquire>
  b->refcnt--;
    800032ae:	40bc                	lw	a5,64(s1)
    800032b0:	37fd                	addiw	a5,a5,-1
    800032b2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800032b4:	00014517          	auipc	a0,0x14
    800032b8:	66450513          	addi	a0,a0,1636 # 80017918 <bcache>
    800032bc:	ffffe097          	auipc	ra,0xffffe
    800032c0:	86a080e7          	jalr	-1942(ra) # 80000b26 <release>
}
    800032c4:	60e2                	ld	ra,24(sp)
    800032c6:	6442                	ld	s0,16(sp)
    800032c8:	64a2                	ld	s1,8(sp)
    800032ca:	6105                	addi	sp,sp,32
    800032cc:	8082                	ret

00000000800032ce <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800032ce:	1101                	addi	sp,sp,-32
    800032d0:	ec06                	sd	ra,24(sp)
    800032d2:	e822                	sd	s0,16(sp)
    800032d4:	e426                	sd	s1,8(sp)
    800032d6:	e04a                	sd	s2,0(sp)
    800032d8:	1000                	addi	s0,sp,32
    800032da:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800032dc:	00d5d59b          	srliw	a1,a1,0xd
    800032e0:	0001d797          	auipc	a5,0x1d
    800032e4:	e0c7a783          	lw	a5,-500(a5) # 800200ec <sb+0x1c>
    800032e8:	9dbd                	addw	a1,a1,a5
    800032ea:	00000097          	auipc	ra,0x0
    800032ee:	d9e080e7          	jalr	-610(ra) # 80003088 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800032f2:	0074f713          	andi	a4,s1,7
    800032f6:	4785                	li	a5,1
    800032f8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800032fc:	14ce                	slli	s1,s1,0x33
    800032fe:	90d9                	srli	s1,s1,0x36
    80003300:	00950733          	add	a4,a0,s1
    80003304:	06074703          	lbu	a4,96(a4)
    80003308:	00e7f6b3          	and	a3,a5,a4
    8000330c:	c69d                	beqz	a3,8000333a <bfree+0x6c>
    8000330e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003310:	94aa                	add	s1,s1,a0
    80003312:	fff7c793          	not	a5,a5
    80003316:	8ff9                	and	a5,a5,a4
    80003318:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    8000331c:	00001097          	auipc	ra,0x1
    80003320:	0da080e7          	jalr	218(ra) # 800043f6 <log_write>
  brelse(bp);
    80003324:	854a                	mv	a0,s2
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	e92080e7          	jalr	-366(ra) # 800031b8 <brelse>
}
    8000332e:	60e2                	ld	ra,24(sp)
    80003330:	6442                	ld	s0,16(sp)
    80003332:	64a2                	ld	s1,8(sp)
    80003334:	6902                	ld	s2,0(sp)
    80003336:	6105                	addi	sp,sp,32
    80003338:	8082                	ret
    panic("freeing free block");
    8000333a:	00004517          	auipc	a0,0x4
    8000333e:	21e50513          	addi	a0,a0,542 # 80007558 <userret+0x4c8>
    80003342:	ffffd097          	auipc	ra,0xffffd
    80003346:	20c080e7          	jalr	524(ra) # 8000054e <panic>

000000008000334a <balloc>:
{
    8000334a:	711d                	addi	sp,sp,-96
    8000334c:	ec86                	sd	ra,88(sp)
    8000334e:	e8a2                	sd	s0,80(sp)
    80003350:	e4a6                	sd	s1,72(sp)
    80003352:	e0ca                	sd	s2,64(sp)
    80003354:	fc4e                	sd	s3,56(sp)
    80003356:	f852                	sd	s4,48(sp)
    80003358:	f456                	sd	s5,40(sp)
    8000335a:	f05a                	sd	s6,32(sp)
    8000335c:	ec5e                	sd	s7,24(sp)
    8000335e:	e862                	sd	s8,16(sp)
    80003360:	e466                	sd	s9,8(sp)
    80003362:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003364:	0001d797          	auipc	a5,0x1d
    80003368:	d707a783          	lw	a5,-656(a5) # 800200d4 <sb+0x4>
    8000336c:	cbd1                	beqz	a5,80003400 <balloc+0xb6>
    8000336e:	8baa                	mv	s7,a0
    80003370:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003372:	0001db17          	auipc	s6,0x1d
    80003376:	d5eb0b13          	addi	s6,s6,-674 # 800200d0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000337a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000337c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000337e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003380:	6c89                	lui	s9,0x2
    80003382:	a831                	j	8000339e <balloc+0x54>
    brelse(bp);
    80003384:	854a                	mv	a0,s2
    80003386:	00000097          	auipc	ra,0x0
    8000338a:	e32080e7          	jalr	-462(ra) # 800031b8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000338e:	015c87bb          	addw	a5,s9,s5
    80003392:	00078a9b          	sext.w	s5,a5
    80003396:	004b2703          	lw	a4,4(s6)
    8000339a:	06eaf363          	bgeu	s5,a4,80003400 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000339e:	41fad79b          	sraiw	a5,s5,0x1f
    800033a2:	0137d79b          	srliw	a5,a5,0x13
    800033a6:	015787bb          	addw	a5,a5,s5
    800033aa:	40d7d79b          	sraiw	a5,a5,0xd
    800033ae:	01cb2583          	lw	a1,28(s6)
    800033b2:	9dbd                	addw	a1,a1,a5
    800033b4:	855e                	mv	a0,s7
    800033b6:	00000097          	auipc	ra,0x0
    800033ba:	cd2080e7          	jalr	-814(ra) # 80003088 <bread>
    800033be:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033c0:	004b2503          	lw	a0,4(s6)
    800033c4:	000a849b          	sext.w	s1,s5
    800033c8:	8662                	mv	a2,s8
    800033ca:	faa4fde3          	bgeu	s1,a0,80003384 <balloc+0x3a>
      m = 1 << (bi % 8);
    800033ce:	41f6579b          	sraiw	a5,a2,0x1f
    800033d2:	01d7d69b          	srliw	a3,a5,0x1d
    800033d6:	00c6873b          	addw	a4,a3,a2
    800033da:	00777793          	andi	a5,a4,7
    800033de:	9f95                	subw	a5,a5,a3
    800033e0:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800033e4:	4037571b          	sraiw	a4,a4,0x3
    800033e8:	00e906b3          	add	a3,s2,a4
    800033ec:	0606c683          	lbu	a3,96(a3)
    800033f0:	00d7f5b3          	and	a1,a5,a3
    800033f4:	cd91                	beqz	a1,80003410 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033f6:	2605                	addiw	a2,a2,1
    800033f8:	2485                	addiw	s1,s1,1
    800033fa:	fd4618e3          	bne	a2,s4,800033ca <balloc+0x80>
    800033fe:	b759                	j	80003384 <balloc+0x3a>
  panic("balloc: out of blocks");
    80003400:	00004517          	auipc	a0,0x4
    80003404:	17050513          	addi	a0,a0,368 # 80007570 <userret+0x4e0>
    80003408:	ffffd097          	auipc	ra,0xffffd
    8000340c:	146080e7          	jalr	326(ra) # 8000054e <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003410:	974a                	add	a4,a4,s2
    80003412:	8fd5                	or	a5,a5,a3
    80003414:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    80003418:	854a                	mv	a0,s2
    8000341a:	00001097          	auipc	ra,0x1
    8000341e:	fdc080e7          	jalr	-36(ra) # 800043f6 <log_write>
        brelse(bp);
    80003422:	854a                	mv	a0,s2
    80003424:	00000097          	auipc	ra,0x0
    80003428:	d94080e7          	jalr	-620(ra) # 800031b8 <brelse>
  bp = bread(dev, bno);
    8000342c:	85a6                	mv	a1,s1
    8000342e:	855e                	mv	a0,s7
    80003430:	00000097          	auipc	ra,0x0
    80003434:	c58080e7          	jalr	-936(ra) # 80003088 <bread>
    80003438:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000343a:	40000613          	li	a2,1024
    8000343e:	4581                	li	a1,0
    80003440:	06050513          	addi	a0,a0,96
    80003444:	ffffd097          	auipc	ra,0xffffd
    80003448:	72a080e7          	jalr	1834(ra) # 80000b6e <memset>
  log_write(bp);
    8000344c:	854a                	mv	a0,s2
    8000344e:	00001097          	auipc	ra,0x1
    80003452:	fa8080e7          	jalr	-88(ra) # 800043f6 <log_write>
  brelse(bp);
    80003456:	854a                	mv	a0,s2
    80003458:	00000097          	auipc	ra,0x0
    8000345c:	d60080e7          	jalr	-672(ra) # 800031b8 <brelse>
}
    80003460:	8526                	mv	a0,s1
    80003462:	60e6                	ld	ra,88(sp)
    80003464:	6446                	ld	s0,80(sp)
    80003466:	64a6                	ld	s1,72(sp)
    80003468:	6906                	ld	s2,64(sp)
    8000346a:	79e2                	ld	s3,56(sp)
    8000346c:	7a42                	ld	s4,48(sp)
    8000346e:	7aa2                	ld	s5,40(sp)
    80003470:	7b02                	ld	s6,32(sp)
    80003472:	6be2                	ld	s7,24(sp)
    80003474:	6c42                	ld	s8,16(sp)
    80003476:	6ca2                	ld	s9,8(sp)
    80003478:	6125                	addi	sp,sp,96
    8000347a:	8082                	ret

000000008000347c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000347c:	7179                	addi	sp,sp,-48
    8000347e:	f406                	sd	ra,40(sp)
    80003480:	f022                	sd	s0,32(sp)
    80003482:	ec26                	sd	s1,24(sp)
    80003484:	e84a                	sd	s2,16(sp)
    80003486:	e44e                	sd	s3,8(sp)
    80003488:	e052                	sd	s4,0(sp)
    8000348a:	1800                	addi	s0,sp,48
    8000348c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000348e:	47ad                	li	a5,11
    80003490:	04b7fe63          	bgeu	a5,a1,800034ec <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003494:	ff45849b          	addiw	s1,a1,-12
    80003498:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000349c:	0ff00793          	li	a5,255
    800034a0:	0ae7e363          	bltu	a5,a4,80003546 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800034a4:	08052583          	lw	a1,128(a0)
    800034a8:	c5ad                	beqz	a1,80003512 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800034aa:	00092503          	lw	a0,0(s2)
    800034ae:	00000097          	auipc	ra,0x0
    800034b2:	bda080e7          	jalr	-1062(ra) # 80003088 <bread>
    800034b6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800034b8:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    800034bc:	02049593          	slli	a1,s1,0x20
    800034c0:	9181                	srli	a1,a1,0x20
    800034c2:	058a                	slli	a1,a1,0x2
    800034c4:	00b784b3          	add	s1,a5,a1
    800034c8:	0004a983          	lw	s3,0(s1)
    800034cc:	04098d63          	beqz	s3,80003526 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800034d0:	8552                	mv	a0,s4
    800034d2:	00000097          	auipc	ra,0x0
    800034d6:	ce6080e7          	jalr	-794(ra) # 800031b8 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800034da:	854e                	mv	a0,s3
    800034dc:	70a2                	ld	ra,40(sp)
    800034de:	7402                	ld	s0,32(sp)
    800034e0:	64e2                	ld	s1,24(sp)
    800034e2:	6942                	ld	s2,16(sp)
    800034e4:	69a2                	ld	s3,8(sp)
    800034e6:	6a02                	ld	s4,0(sp)
    800034e8:	6145                	addi	sp,sp,48
    800034ea:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800034ec:	02059493          	slli	s1,a1,0x20
    800034f0:	9081                	srli	s1,s1,0x20
    800034f2:	048a                	slli	s1,s1,0x2
    800034f4:	94aa                	add	s1,s1,a0
    800034f6:	0504a983          	lw	s3,80(s1)
    800034fa:	fe0990e3          	bnez	s3,800034da <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800034fe:	4108                	lw	a0,0(a0)
    80003500:	00000097          	auipc	ra,0x0
    80003504:	e4a080e7          	jalr	-438(ra) # 8000334a <balloc>
    80003508:	0005099b          	sext.w	s3,a0
    8000350c:	0534a823          	sw	s3,80(s1)
    80003510:	b7e9                	j	800034da <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003512:	4108                	lw	a0,0(a0)
    80003514:	00000097          	auipc	ra,0x0
    80003518:	e36080e7          	jalr	-458(ra) # 8000334a <balloc>
    8000351c:	0005059b          	sext.w	a1,a0
    80003520:	08b92023          	sw	a1,128(s2)
    80003524:	b759                	j	800034aa <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003526:	00092503          	lw	a0,0(s2)
    8000352a:	00000097          	auipc	ra,0x0
    8000352e:	e20080e7          	jalr	-480(ra) # 8000334a <balloc>
    80003532:	0005099b          	sext.w	s3,a0
    80003536:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000353a:	8552                	mv	a0,s4
    8000353c:	00001097          	auipc	ra,0x1
    80003540:	eba080e7          	jalr	-326(ra) # 800043f6 <log_write>
    80003544:	b771                	j	800034d0 <bmap+0x54>
  panic("bmap: out of range");
    80003546:	00004517          	auipc	a0,0x4
    8000354a:	04250513          	addi	a0,a0,66 # 80007588 <userret+0x4f8>
    8000354e:	ffffd097          	auipc	ra,0xffffd
    80003552:	000080e7          	jalr	ra # 8000054e <panic>

0000000080003556 <iget>:
{
    80003556:	7179                	addi	sp,sp,-48
    80003558:	f406                	sd	ra,40(sp)
    8000355a:	f022                	sd	s0,32(sp)
    8000355c:	ec26                	sd	s1,24(sp)
    8000355e:	e84a                	sd	s2,16(sp)
    80003560:	e44e                	sd	s3,8(sp)
    80003562:	e052                	sd	s4,0(sp)
    80003564:	1800                	addi	s0,sp,48
    80003566:	89aa                	mv	s3,a0
    80003568:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    8000356a:	0001d517          	auipc	a0,0x1d
    8000356e:	b8650513          	addi	a0,a0,-1146 # 800200f0 <icache>
    80003572:	ffffd097          	auipc	ra,0xffffd
    80003576:	560080e7          	jalr	1376(ra) # 80000ad2 <acquire>
  empty = 0;
    8000357a:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000357c:	0001d497          	auipc	s1,0x1d
    80003580:	b8c48493          	addi	s1,s1,-1140 # 80020108 <icache+0x18>
    80003584:	0001e697          	auipc	a3,0x1e
    80003588:	61468693          	addi	a3,a3,1556 # 80021b98 <log>
    8000358c:	a039                	j	8000359a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000358e:	02090b63          	beqz	s2,800035c4 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003592:	08848493          	addi	s1,s1,136
    80003596:	02d48a63          	beq	s1,a3,800035ca <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000359a:	449c                	lw	a5,8(s1)
    8000359c:	fef059e3          	blez	a5,8000358e <iget+0x38>
    800035a0:	4098                	lw	a4,0(s1)
    800035a2:	ff3716e3          	bne	a4,s3,8000358e <iget+0x38>
    800035a6:	40d8                	lw	a4,4(s1)
    800035a8:	ff4713e3          	bne	a4,s4,8000358e <iget+0x38>
      ip->ref++;
    800035ac:	2785                	addiw	a5,a5,1
    800035ae:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    800035b0:	0001d517          	auipc	a0,0x1d
    800035b4:	b4050513          	addi	a0,a0,-1216 # 800200f0 <icache>
    800035b8:	ffffd097          	auipc	ra,0xffffd
    800035bc:	56e080e7          	jalr	1390(ra) # 80000b26 <release>
      return ip;
    800035c0:	8926                	mv	s2,s1
    800035c2:	a03d                	j	800035f0 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800035c4:	f7f9                	bnez	a5,80003592 <iget+0x3c>
    800035c6:	8926                	mv	s2,s1
    800035c8:	b7e9                	j	80003592 <iget+0x3c>
  if(empty == 0)
    800035ca:	02090c63          	beqz	s2,80003602 <iget+0xac>
  ip->dev = dev;
    800035ce:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800035d2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800035d6:	4785                	li	a5,1
    800035d8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800035dc:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    800035e0:	0001d517          	auipc	a0,0x1d
    800035e4:	b1050513          	addi	a0,a0,-1264 # 800200f0 <icache>
    800035e8:	ffffd097          	auipc	ra,0xffffd
    800035ec:	53e080e7          	jalr	1342(ra) # 80000b26 <release>
}
    800035f0:	854a                	mv	a0,s2
    800035f2:	70a2                	ld	ra,40(sp)
    800035f4:	7402                	ld	s0,32(sp)
    800035f6:	64e2                	ld	s1,24(sp)
    800035f8:	6942                	ld	s2,16(sp)
    800035fa:	69a2                	ld	s3,8(sp)
    800035fc:	6a02                	ld	s4,0(sp)
    800035fe:	6145                	addi	sp,sp,48
    80003600:	8082                	ret
    panic("iget: no inodes");
    80003602:	00004517          	auipc	a0,0x4
    80003606:	f9e50513          	addi	a0,a0,-98 # 800075a0 <userret+0x510>
    8000360a:	ffffd097          	auipc	ra,0xffffd
    8000360e:	f44080e7          	jalr	-188(ra) # 8000054e <panic>

0000000080003612 <fsinit>:
fsinit(int dev) {
    80003612:	7179                	addi	sp,sp,-48
    80003614:	f406                	sd	ra,40(sp)
    80003616:	f022                	sd	s0,32(sp)
    80003618:	ec26                	sd	s1,24(sp)
    8000361a:	e84a                	sd	s2,16(sp)
    8000361c:	e44e                	sd	s3,8(sp)
    8000361e:	1800                	addi	s0,sp,48
    80003620:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003622:	4585                	li	a1,1
    80003624:	00000097          	auipc	ra,0x0
    80003628:	a64080e7          	jalr	-1436(ra) # 80003088 <bread>
    8000362c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000362e:	0001d997          	auipc	s3,0x1d
    80003632:	aa298993          	addi	s3,s3,-1374 # 800200d0 <sb>
    80003636:	02000613          	li	a2,32
    8000363a:	06050593          	addi	a1,a0,96
    8000363e:	854e                	mv	a0,s3
    80003640:	ffffd097          	auipc	ra,0xffffd
    80003644:	58e080e7          	jalr	1422(ra) # 80000bce <memmove>
  brelse(bp);
    80003648:	8526                	mv	a0,s1
    8000364a:	00000097          	auipc	ra,0x0
    8000364e:	b6e080e7          	jalr	-1170(ra) # 800031b8 <brelse>
  if(sb.magic != FSMAGIC)
    80003652:	0009a703          	lw	a4,0(s3)
    80003656:	102037b7          	lui	a5,0x10203
    8000365a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000365e:	02f71263          	bne	a4,a5,80003682 <fsinit+0x70>
  initlog(dev, &sb);
    80003662:	0001d597          	auipc	a1,0x1d
    80003666:	a6e58593          	addi	a1,a1,-1426 # 800200d0 <sb>
    8000366a:	854a                	mv	a0,s2
    8000366c:	00001097          	auipc	ra,0x1
    80003670:	b12080e7          	jalr	-1262(ra) # 8000417e <initlog>
}
    80003674:	70a2                	ld	ra,40(sp)
    80003676:	7402                	ld	s0,32(sp)
    80003678:	64e2                	ld	s1,24(sp)
    8000367a:	6942                	ld	s2,16(sp)
    8000367c:	69a2                	ld	s3,8(sp)
    8000367e:	6145                	addi	sp,sp,48
    80003680:	8082                	ret
    panic("invalid file system");
    80003682:	00004517          	auipc	a0,0x4
    80003686:	f2e50513          	addi	a0,a0,-210 # 800075b0 <userret+0x520>
    8000368a:	ffffd097          	auipc	ra,0xffffd
    8000368e:	ec4080e7          	jalr	-316(ra) # 8000054e <panic>

0000000080003692 <iinit>:
{
    80003692:	7179                	addi	sp,sp,-48
    80003694:	f406                	sd	ra,40(sp)
    80003696:	f022                	sd	s0,32(sp)
    80003698:	ec26                	sd	s1,24(sp)
    8000369a:	e84a                	sd	s2,16(sp)
    8000369c:	e44e                	sd	s3,8(sp)
    8000369e:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    800036a0:	00004597          	auipc	a1,0x4
    800036a4:	f2858593          	addi	a1,a1,-216 # 800075c8 <userret+0x538>
    800036a8:	0001d517          	auipc	a0,0x1d
    800036ac:	a4850513          	addi	a0,a0,-1464 # 800200f0 <icache>
    800036b0:	ffffd097          	auipc	ra,0xffffd
    800036b4:	310080e7          	jalr	784(ra) # 800009c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    800036b8:	0001d497          	auipc	s1,0x1d
    800036bc:	a6048493          	addi	s1,s1,-1440 # 80020118 <icache+0x28>
    800036c0:	0001e997          	auipc	s3,0x1e
    800036c4:	4e898993          	addi	s3,s3,1256 # 80021ba8 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    800036c8:	00004917          	auipc	s2,0x4
    800036cc:	f0890913          	addi	s2,s2,-248 # 800075d0 <userret+0x540>
    800036d0:	85ca                	mv	a1,s2
    800036d2:	8526                	mv	a0,s1
    800036d4:	00001097          	auipc	ra,0x1
    800036d8:	e10080e7          	jalr	-496(ra) # 800044e4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800036dc:	08848493          	addi	s1,s1,136
    800036e0:	ff3498e3          	bne	s1,s3,800036d0 <iinit+0x3e>
}
    800036e4:	70a2                	ld	ra,40(sp)
    800036e6:	7402                	ld	s0,32(sp)
    800036e8:	64e2                	ld	s1,24(sp)
    800036ea:	6942                	ld	s2,16(sp)
    800036ec:	69a2                	ld	s3,8(sp)
    800036ee:	6145                	addi	sp,sp,48
    800036f0:	8082                	ret

00000000800036f2 <ialloc>:
{
    800036f2:	715d                	addi	sp,sp,-80
    800036f4:	e486                	sd	ra,72(sp)
    800036f6:	e0a2                	sd	s0,64(sp)
    800036f8:	fc26                	sd	s1,56(sp)
    800036fa:	f84a                	sd	s2,48(sp)
    800036fc:	f44e                	sd	s3,40(sp)
    800036fe:	f052                	sd	s4,32(sp)
    80003700:	ec56                	sd	s5,24(sp)
    80003702:	e85a                	sd	s6,16(sp)
    80003704:	e45e                	sd	s7,8(sp)
    80003706:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003708:	0001d717          	auipc	a4,0x1d
    8000370c:	9d472703          	lw	a4,-1580(a4) # 800200dc <sb+0xc>
    80003710:	4785                	li	a5,1
    80003712:	04e7fa63          	bgeu	a5,a4,80003766 <ialloc+0x74>
    80003716:	8aaa                	mv	s5,a0
    80003718:	8bae                	mv	s7,a1
    8000371a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000371c:	0001da17          	auipc	s4,0x1d
    80003720:	9b4a0a13          	addi	s4,s4,-1612 # 800200d0 <sb>
    80003724:	00048b1b          	sext.w	s6,s1
    80003728:	0044d593          	srli	a1,s1,0x4
    8000372c:	018a2783          	lw	a5,24(s4)
    80003730:	9dbd                	addw	a1,a1,a5
    80003732:	8556                	mv	a0,s5
    80003734:	00000097          	auipc	ra,0x0
    80003738:	954080e7          	jalr	-1708(ra) # 80003088 <bread>
    8000373c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000373e:	06050993          	addi	s3,a0,96
    80003742:	00f4f793          	andi	a5,s1,15
    80003746:	079a                	slli	a5,a5,0x6
    80003748:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000374a:	00099783          	lh	a5,0(s3)
    8000374e:	c785                	beqz	a5,80003776 <ialloc+0x84>
    brelse(bp);
    80003750:	00000097          	auipc	ra,0x0
    80003754:	a68080e7          	jalr	-1432(ra) # 800031b8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003758:	0485                	addi	s1,s1,1
    8000375a:	00ca2703          	lw	a4,12(s4)
    8000375e:	0004879b          	sext.w	a5,s1
    80003762:	fce7e1e3          	bltu	a5,a4,80003724 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003766:	00004517          	auipc	a0,0x4
    8000376a:	e7250513          	addi	a0,a0,-398 # 800075d8 <userret+0x548>
    8000376e:	ffffd097          	auipc	ra,0xffffd
    80003772:	de0080e7          	jalr	-544(ra) # 8000054e <panic>
      memset(dip, 0, sizeof(*dip));
    80003776:	04000613          	li	a2,64
    8000377a:	4581                	li	a1,0
    8000377c:	854e                	mv	a0,s3
    8000377e:	ffffd097          	auipc	ra,0xffffd
    80003782:	3f0080e7          	jalr	1008(ra) # 80000b6e <memset>
      dip->type = type;
    80003786:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000378a:	854a                	mv	a0,s2
    8000378c:	00001097          	auipc	ra,0x1
    80003790:	c6a080e7          	jalr	-918(ra) # 800043f6 <log_write>
      brelse(bp);
    80003794:	854a                	mv	a0,s2
    80003796:	00000097          	auipc	ra,0x0
    8000379a:	a22080e7          	jalr	-1502(ra) # 800031b8 <brelse>
      return iget(dev, inum);
    8000379e:	85da                	mv	a1,s6
    800037a0:	8556                	mv	a0,s5
    800037a2:	00000097          	auipc	ra,0x0
    800037a6:	db4080e7          	jalr	-588(ra) # 80003556 <iget>
}
    800037aa:	60a6                	ld	ra,72(sp)
    800037ac:	6406                	ld	s0,64(sp)
    800037ae:	74e2                	ld	s1,56(sp)
    800037b0:	7942                	ld	s2,48(sp)
    800037b2:	79a2                	ld	s3,40(sp)
    800037b4:	7a02                	ld	s4,32(sp)
    800037b6:	6ae2                	ld	s5,24(sp)
    800037b8:	6b42                	ld	s6,16(sp)
    800037ba:	6ba2                	ld	s7,8(sp)
    800037bc:	6161                	addi	sp,sp,80
    800037be:	8082                	ret

00000000800037c0 <iupdate>:
{
    800037c0:	1101                	addi	sp,sp,-32
    800037c2:	ec06                	sd	ra,24(sp)
    800037c4:	e822                	sd	s0,16(sp)
    800037c6:	e426                	sd	s1,8(sp)
    800037c8:	e04a                	sd	s2,0(sp)
    800037ca:	1000                	addi	s0,sp,32
    800037cc:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037ce:	415c                	lw	a5,4(a0)
    800037d0:	0047d79b          	srliw	a5,a5,0x4
    800037d4:	0001d597          	auipc	a1,0x1d
    800037d8:	9145a583          	lw	a1,-1772(a1) # 800200e8 <sb+0x18>
    800037dc:	9dbd                	addw	a1,a1,a5
    800037de:	4108                	lw	a0,0(a0)
    800037e0:	00000097          	auipc	ra,0x0
    800037e4:	8a8080e7          	jalr	-1880(ra) # 80003088 <bread>
    800037e8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800037ea:	06050793          	addi	a5,a0,96
    800037ee:	40c8                	lw	a0,4(s1)
    800037f0:	893d                	andi	a0,a0,15
    800037f2:	051a                	slli	a0,a0,0x6
    800037f4:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800037f6:	04449703          	lh	a4,68(s1)
    800037fa:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800037fe:	04649703          	lh	a4,70(s1)
    80003802:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003806:	04849703          	lh	a4,72(s1)
    8000380a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    8000380e:	04a49703          	lh	a4,74(s1)
    80003812:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003816:	44f8                	lw	a4,76(s1)
    80003818:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000381a:	03400613          	li	a2,52
    8000381e:	05048593          	addi	a1,s1,80
    80003822:	0531                	addi	a0,a0,12
    80003824:	ffffd097          	auipc	ra,0xffffd
    80003828:	3aa080e7          	jalr	938(ra) # 80000bce <memmove>
  log_write(bp);
    8000382c:	854a                	mv	a0,s2
    8000382e:	00001097          	auipc	ra,0x1
    80003832:	bc8080e7          	jalr	-1080(ra) # 800043f6 <log_write>
  brelse(bp);
    80003836:	854a                	mv	a0,s2
    80003838:	00000097          	auipc	ra,0x0
    8000383c:	980080e7          	jalr	-1664(ra) # 800031b8 <brelse>
}
    80003840:	60e2                	ld	ra,24(sp)
    80003842:	6442                	ld	s0,16(sp)
    80003844:	64a2                	ld	s1,8(sp)
    80003846:	6902                	ld	s2,0(sp)
    80003848:	6105                	addi	sp,sp,32
    8000384a:	8082                	ret

000000008000384c <idup>:
{
    8000384c:	1101                	addi	sp,sp,-32
    8000384e:	ec06                	sd	ra,24(sp)
    80003850:	e822                	sd	s0,16(sp)
    80003852:	e426                	sd	s1,8(sp)
    80003854:	1000                	addi	s0,sp,32
    80003856:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003858:	0001d517          	auipc	a0,0x1d
    8000385c:	89850513          	addi	a0,a0,-1896 # 800200f0 <icache>
    80003860:	ffffd097          	auipc	ra,0xffffd
    80003864:	272080e7          	jalr	626(ra) # 80000ad2 <acquire>
  ip->ref++;
    80003868:	449c                	lw	a5,8(s1)
    8000386a:	2785                	addiw	a5,a5,1
    8000386c:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    8000386e:	0001d517          	auipc	a0,0x1d
    80003872:	88250513          	addi	a0,a0,-1918 # 800200f0 <icache>
    80003876:	ffffd097          	auipc	ra,0xffffd
    8000387a:	2b0080e7          	jalr	688(ra) # 80000b26 <release>
}
    8000387e:	8526                	mv	a0,s1
    80003880:	60e2                	ld	ra,24(sp)
    80003882:	6442                	ld	s0,16(sp)
    80003884:	64a2                	ld	s1,8(sp)
    80003886:	6105                	addi	sp,sp,32
    80003888:	8082                	ret

000000008000388a <ilock>:
{
    8000388a:	1101                	addi	sp,sp,-32
    8000388c:	ec06                	sd	ra,24(sp)
    8000388e:	e822                	sd	s0,16(sp)
    80003890:	e426                	sd	s1,8(sp)
    80003892:	e04a                	sd	s2,0(sp)
    80003894:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003896:	c115                	beqz	a0,800038ba <ilock+0x30>
    80003898:	84aa                	mv	s1,a0
    8000389a:	451c                	lw	a5,8(a0)
    8000389c:	00f05f63          	blez	a5,800038ba <ilock+0x30>
  acquiresleep(&ip->lock);
    800038a0:	0541                	addi	a0,a0,16
    800038a2:	00001097          	auipc	ra,0x1
    800038a6:	c7c080e7          	jalr	-900(ra) # 8000451e <acquiresleep>
  if(ip->valid == 0){
    800038aa:	40bc                	lw	a5,64(s1)
    800038ac:	cf99                	beqz	a5,800038ca <ilock+0x40>
}
    800038ae:	60e2                	ld	ra,24(sp)
    800038b0:	6442                	ld	s0,16(sp)
    800038b2:	64a2                	ld	s1,8(sp)
    800038b4:	6902                	ld	s2,0(sp)
    800038b6:	6105                	addi	sp,sp,32
    800038b8:	8082                	ret
    panic("ilock");
    800038ba:	00004517          	auipc	a0,0x4
    800038be:	d3650513          	addi	a0,a0,-714 # 800075f0 <userret+0x560>
    800038c2:	ffffd097          	auipc	ra,0xffffd
    800038c6:	c8c080e7          	jalr	-884(ra) # 8000054e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800038ca:	40dc                	lw	a5,4(s1)
    800038cc:	0047d79b          	srliw	a5,a5,0x4
    800038d0:	0001d597          	auipc	a1,0x1d
    800038d4:	8185a583          	lw	a1,-2024(a1) # 800200e8 <sb+0x18>
    800038d8:	9dbd                	addw	a1,a1,a5
    800038da:	4088                	lw	a0,0(s1)
    800038dc:	fffff097          	auipc	ra,0xfffff
    800038e0:	7ac080e7          	jalr	1964(ra) # 80003088 <bread>
    800038e4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800038e6:	06050593          	addi	a1,a0,96
    800038ea:	40dc                	lw	a5,4(s1)
    800038ec:	8bbd                	andi	a5,a5,15
    800038ee:	079a                	slli	a5,a5,0x6
    800038f0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800038f2:	00059783          	lh	a5,0(a1)
    800038f6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800038fa:	00259783          	lh	a5,2(a1)
    800038fe:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003902:	00459783          	lh	a5,4(a1)
    80003906:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000390a:	00659783          	lh	a5,6(a1)
    8000390e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003912:	459c                	lw	a5,8(a1)
    80003914:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003916:	03400613          	li	a2,52
    8000391a:	05b1                	addi	a1,a1,12
    8000391c:	05048513          	addi	a0,s1,80
    80003920:	ffffd097          	auipc	ra,0xffffd
    80003924:	2ae080e7          	jalr	686(ra) # 80000bce <memmove>
    brelse(bp);
    80003928:	854a                	mv	a0,s2
    8000392a:	00000097          	auipc	ra,0x0
    8000392e:	88e080e7          	jalr	-1906(ra) # 800031b8 <brelse>
    ip->valid = 1;
    80003932:	4785                	li	a5,1
    80003934:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003936:	04449783          	lh	a5,68(s1)
    8000393a:	fbb5                	bnez	a5,800038ae <ilock+0x24>
      panic("ilock: no type");
    8000393c:	00004517          	auipc	a0,0x4
    80003940:	cbc50513          	addi	a0,a0,-836 # 800075f8 <userret+0x568>
    80003944:	ffffd097          	auipc	ra,0xffffd
    80003948:	c0a080e7          	jalr	-1014(ra) # 8000054e <panic>

000000008000394c <iunlock>:
{
    8000394c:	1101                	addi	sp,sp,-32
    8000394e:	ec06                	sd	ra,24(sp)
    80003950:	e822                	sd	s0,16(sp)
    80003952:	e426                	sd	s1,8(sp)
    80003954:	e04a                	sd	s2,0(sp)
    80003956:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003958:	c905                	beqz	a0,80003988 <iunlock+0x3c>
    8000395a:	84aa                	mv	s1,a0
    8000395c:	01050913          	addi	s2,a0,16
    80003960:	854a                	mv	a0,s2
    80003962:	00001097          	auipc	ra,0x1
    80003966:	c56080e7          	jalr	-938(ra) # 800045b8 <holdingsleep>
    8000396a:	cd19                	beqz	a0,80003988 <iunlock+0x3c>
    8000396c:	449c                	lw	a5,8(s1)
    8000396e:	00f05d63          	blez	a5,80003988 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003972:	854a                	mv	a0,s2
    80003974:	00001097          	auipc	ra,0x1
    80003978:	c00080e7          	jalr	-1024(ra) # 80004574 <releasesleep>
}
    8000397c:	60e2                	ld	ra,24(sp)
    8000397e:	6442                	ld	s0,16(sp)
    80003980:	64a2                	ld	s1,8(sp)
    80003982:	6902                	ld	s2,0(sp)
    80003984:	6105                	addi	sp,sp,32
    80003986:	8082                	ret
    panic("iunlock");
    80003988:	00004517          	auipc	a0,0x4
    8000398c:	c8050513          	addi	a0,a0,-896 # 80007608 <userret+0x578>
    80003990:	ffffd097          	auipc	ra,0xffffd
    80003994:	bbe080e7          	jalr	-1090(ra) # 8000054e <panic>

0000000080003998 <iput>:
{
    80003998:	7139                	addi	sp,sp,-64
    8000399a:	fc06                	sd	ra,56(sp)
    8000399c:	f822                	sd	s0,48(sp)
    8000399e:	f426                	sd	s1,40(sp)
    800039a0:	f04a                	sd	s2,32(sp)
    800039a2:	ec4e                	sd	s3,24(sp)
    800039a4:	e852                	sd	s4,16(sp)
    800039a6:	e456                	sd	s5,8(sp)
    800039a8:	0080                	addi	s0,sp,64
    800039aa:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800039ac:	0001c517          	auipc	a0,0x1c
    800039b0:	74450513          	addi	a0,a0,1860 # 800200f0 <icache>
    800039b4:	ffffd097          	auipc	ra,0xffffd
    800039b8:	11e080e7          	jalr	286(ra) # 80000ad2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039bc:	4498                	lw	a4,8(s1)
    800039be:	4785                	li	a5,1
    800039c0:	02f70663          	beq	a4,a5,800039ec <iput+0x54>
  ip->ref--;
    800039c4:	449c                	lw	a5,8(s1)
    800039c6:	37fd                	addiw	a5,a5,-1
    800039c8:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800039ca:	0001c517          	auipc	a0,0x1c
    800039ce:	72650513          	addi	a0,a0,1830 # 800200f0 <icache>
    800039d2:	ffffd097          	auipc	ra,0xffffd
    800039d6:	154080e7          	jalr	340(ra) # 80000b26 <release>
}
    800039da:	70e2                	ld	ra,56(sp)
    800039dc:	7442                	ld	s0,48(sp)
    800039de:	74a2                	ld	s1,40(sp)
    800039e0:	7902                	ld	s2,32(sp)
    800039e2:	69e2                	ld	s3,24(sp)
    800039e4:	6a42                	ld	s4,16(sp)
    800039e6:	6aa2                	ld	s5,8(sp)
    800039e8:	6121                	addi	sp,sp,64
    800039ea:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039ec:	40bc                	lw	a5,64(s1)
    800039ee:	dbf9                	beqz	a5,800039c4 <iput+0x2c>
    800039f0:	04a49783          	lh	a5,74(s1)
    800039f4:	fbe1                	bnez	a5,800039c4 <iput+0x2c>
    acquiresleep(&ip->lock);
    800039f6:	01048a13          	addi	s4,s1,16
    800039fa:	8552                	mv	a0,s4
    800039fc:	00001097          	auipc	ra,0x1
    80003a00:	b22080e7          	jalr	-1246(ra) # 8000451e <acquiresleep>
    release(&icache.lock);
    80003a04:	0001c517          	auipc	a0,0x1c
    80003a08:	6ec50513          	addi	a0,a0,1772 # 800200f0 <icache>
    80003a0c:	ffffd097          	auipc	ra,0xffffd
    80003a10:	11a080e7          	jalr	282(ra) # 80000b26 <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003a14:	05048913          	addi	s2,s1,80
    80003a18:	08048993          	addi	s3,s1,128
    80003a1c:	a819                	j	80003a32 <iput+0x9a>
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
    80003a1e:	4088                	lw	a0,0(s1)
    80003a20:	00000097          	auipc	ra,0x0
    80003a24:	8ae080e7          	jalr	-1874(ra) # 800032ce <bfree>
      ip->addrs[i] = 0;
    80003a28:	00092023          	sw	zero,0(s2)
  for(i = 0; i < NDIRECT; i++){
    80003a2c:	0911                	addi	s2,s2,4
    80003a2e:	01390663          	beq	s2,s3,80003a3a <iput+0xa2>
    if(ip->addrs[i]){
    80003a32:	00092583          	lw	a1,0(s2)
    80003a36:	d9fd                	beqz	a1,80003a2c <iput+0x94>
    80003a38:	b7dd                	j	80003a1e <iput+0x86>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003a3a:	0804a583          	lw	a1,128(s1)
    80003a3e:	ed9d                	bnez	a1,80003a7c <iput+0xe4>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003a40:	0404a623          	sw	zero,76(s1)
  iupdate(ip);
    80003a44:	8526                	mv	a0,s1
    80003a46:	00000097          	auipc	ra,0x0
    80003a4a:	d7a080e7          	jalr	-646(ra) # 800037c0 <iupdate>
    ip->type = 0;
    80003a4e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003a52:	8526                	mv	a0,s1
    80003a54:	00000097          	auipc	ra,0x0
    80003a58:	d6c080e7          	jalr	-660(ra) # 800037c0 <iupdate>
    ip->valid = 0;
    80003a5c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003a60:	8552                	mv	a0,s4
    80003a62:	00001097          	auipc	ra,0x1
    80003a66:	b12080e7          	jalr	-1262(ra) # 80004574 <releasesleep>
    acquire(&icache.lock);
    80003a6a:	0001c517          	auipc	a0,0x1c
    80003a6e:	68650513          	addi	a0,a0,1670 # 800200f0 <icache>
    80003a72:	ffffd097          	auipc	ra,0xffffd
    80003a76:	060080e7          	jalr	96(ra) # 80000ad2 <acquire>
    80003a7a:	b7a9                	j	800039c4 <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003a7c:	4088                	lw	a0,0(s1)
    80003a7e:	fffff097          	auipc	ra,0xfffff
    80003a82:	60a080e7          	jalr	1546(ra) # 80003088 <bread>
    80003a86:	8aaa                	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
    80003a88:	06050913          	addi	s2,a0,96
    80003a8c:	46050993          	addi	s3,a0,1120
    80003a90:	a809                	j	80003aa2 <iput+0x10a>
        bfree(ip->dev, a[j]);
    80003a92:	4088                	lw	a0,0(s1)
    80003a94:	00000097          	auipc	ra,0x0
    80003a98:	83a080e7          	jalr	-1990(ra) # 800032ce <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80003a9c:	0911                	addi	s2,s2,4
    80003a9e:	01390663          	beq	s2,s3,80003aaa <iput+0x112>
      if(a[j])
    80003aa2:	00092583          	lw	a1,0(s2)
    80003aa6:	d9fd                	beqz	a1,80003a9c <iput+0x104>
    80003aa8:	b7ed                	j	80003a92 <iput+0xfa>
    brelse(bp);
    80003aaa:	8556                	mv	a0,s5
    80003aac:	fffff097          	auipc	ra,0xfffff
    80003ab0:	70c080e7          	jalr	1804(ra) # 800031b8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003ab4:	0804a583          	lw	a1,128(s1)
    80003ab8:	4088                	lw	a0,0(s1)
    80003aba:	00000097          	auipc	ra,0x0
    80003abe:	814080e7          	jalr	-2028(ra) # 800032ce <bfree>
    ip->addrs[NDIRECT] = 0;
    80003ac2:	0804a023          	sw	zero,128(s1)
    80003ac6:	bfad                	j	80003a40 <iput+0xa8>

0000000080003ac8 <iunlockput>:
{
    80003ac8:	1101                	addi	sp,sp,-32
    80003aca:	ec06                	sd	ra,24(sp)
    80003acc:	e822                	sd	s0,16(sp)
    80003ace:	e426                	sd	s1,8(sp)
    80003ad0:	1000                	addi	s0,sp,32
    80003ad2:	84aa                	mv	s1,a0
  iunlock(ip);
    80003ad4:	00000097          	auipc	ra,0x0
    80003ad8:	e78080e7          	jalr	-392(ra) # 8000394c <iunlock>
  iput(ip);
    80003adc:	8526                	mv	a0,s1
    80003ade:	00000097          	auipc	ra,0x0
    80003ae2:	eba080e7          	jalr	-326(ra) # 80003998 <iput>
}
    80003ae6:	60e2                	ld	ra,24(sp)
    80003ae8:	6442                	ld	s0,16(sp)
    80003aea:	64a2                	ld	s1,8(sp)
    80003aec:	6105                	addi	sp,sp,32
    80003aee:	8082                	ret

0000000080003af0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003af0:	1141                	addi	sp,sp,-16
    80003af2:	e422                	sd	s0,8(sp)
    80003af4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003af6:	411c                	lw	a5,0(a0)
    80003af8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003afa:	415c                	lw	a5,4(a0)
    80003afc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003afe:	04451783          	lh	a5,68(a0)
    80003b02:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003b06:	04a51783          	lh	a5,74(a0)
    80003b0a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003b0e:	04c56783          	lwu	a5,76(a0)
    80003b12:	e99c                	sd	a5,16(a1)
}
    80003b14:	6422                	ld	s0,8(sp)
    80003b16:	0141                	addi	sp,sp,16
    80003b18:	8082                	ret

0000000080003b1a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b1a:	457c                	lw	a5,76(a0)
    80003b1c:	0ed7e563          	bltu	a5,a3,80003c06 <readi+0xec>
{
    80003b20:	7159                	addi	sp,sp,-112
    80003b22:	f486                	sd	ra,104(sp)
    80003b24:	f0a2                	sd	s0,96(sp)
    80003b26:	eca6                	sd	s1,88(sp)
    80003b28:	e8ca                	sd	s2,80(sp)
    80003b2a:	e4ce                	sd	s3,72(sp)
    80003b2c:	e0d2                	sd	s4,64(sp)
    80003b2e:	fc56                	sd	s5,56(sp)
    80003b30:	f85a                	sd	s6,48(sp)
    80003b32:	f45e                	sd	s7,40(sp)
    80003b34:	f062                	sd	s8,32(sp)
    80003b36:	ec66                	sd	s9,24(sp)
    80003b38:	e86a                	sd	s10,16(sp)
    80003b3a:	e46e                	sd	s11,8(sp)
    80003b3c:	1880                	addi	s0,sp,112
    80003b3e:	8baa                	mv	s7,a0
    80003b40:	8c2e                	mv	s8,a1
    80003b42:	8ab2                	mv	s5,a2
    80003b44:	8936                	mv	s2,a3
    80003b46:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b48:	9f35                	addw	a4,a4,a3
    80003b4a:	0cd76063          	bltu	a4,a3,80003c0a <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    80003b4e:	00e7f463          	bgeu	a5,a4,80003b56 <readi+0x3c>
    n = ip->size - off; //only can read till the end of the file
    80003b52:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b56:	080b0763          	beqz	s6,80003be4 <readi+0xca>
    80003b5a:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b5c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003b60:	5cfd                	li	s9,-1
    80003b62:	a82d                	j	80003b9c <readi+0x82>
    80003b64:	02099d93          	slli	s11,s3,0x20
    80003b68:	020ddd93          	srli	s11,s11,0x20
    80003b6c:	06048613          	addi	a2,s1,96
    80003b70:	86ee                	mv	a3,s11
    80003b72:	963a                	add	a2,a2,a4
    80003b74:	85d6                	mv	a1,s5
    80003b76:	8562                	mv	a0,s8
    80003b78:	fffff097          	auipc	ra,0xfffff
    80003b7c:	aee080e7          	jalr	-1298(ra) # 80002666 <either_copyout>
    80003b80:	05950d63          	beq	a0,s9,80003bda <readi+0xc0>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003b84:	8526                	mv	a0,s1
    80003b86:	fffff097          	auipc	ra,0xfffff
    80003b8a:	632080e7          	jalr	1586(ra) # 800031b8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b8e:	01498a3b          	addw	s4,s3,s4
    80003b92:	0129893b          	addw	s2,s3,s2
    80003b96:	9aee                	add	s5,s5,s11
    80003b98:	056a7663          	bgeu	s4,s6,80003be4 <readi+0xca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003b9c:	000ba483          	lw	s1,0(s7)
    80003ba0:	00a9559b          	srliw	a1,s2,0xa
    80003ba4:	855e                	mv	a0,s7
    80003ba6:	00000097          	auipc	ra,0x0
    80003baa:	8d6080e7          	jalr	-1834(ra) # 8000347c <bmap>
    80003bae:	0005059b          	sext.w	a1,a0
    80003bb2:	8526                	mv	a0,s1
    80003bb4:	fffff097          	auipc	ra,0xfffff
    80003bb8:	4d4080e7          	jalr	1236(ra) # 80003088 <bread>
    80003bbc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bbe:	3ff97713          	andi	a4,s2,1023
    80003bc2:	40ed07bb          	subw	a5,s10,a4
    80003bc6:	414b06bb          	subw	a3,s6,s4
    80003bca:	89be                	mv	s3,a5
    80003bcc:	2781                	sext.w	a5,a5
    80003bce:	0006861b          	sext.w	a2,a3
    80003bd2:	f8f679e3          	bgeu	a2,a5,80003b64 <readi+0x4a>
    80003bd6:	89b6                	mv	s3,a3
    80003bd8:	b771                	j	80003b64 <readi+0x4a>
      brelse(bp);
    80003bda:	8526                	mv	a0,s1
    80003bdc:	fffff097          	auipc	ra,0xfffff
    80003be0:	5dc080e7          	jalr	1500(ra) # 800031b8 <brelse>
  }
  return n;
    80003be4:	000b051b          	sext.w	a0,s6
}
    80003be8:	70a6                	ld	ra,104(sp)
    80003bea:	7406                	ld	s0,96(sp)
    80003bec:	64e6                	ld	s1,88(sp)
    80003bee:	6946                	ld	s2,80(sp)
    80003bf0:	69a6                	ld	s3,72(sp)
    80003bf2:	6a06                	ld	s4,64(sp)
    80003bf4:	7ae2                	ld	s5,56(sp)
    80003bf6:	7b42                	ld	s6,48(sp)
    80003bf8:	7ba2                	ld	s7,40(sp)
    80003bfa:	7c02                	ld	s8,32(sp)
    80003bfc:	6ce2                	ld	s9,24(sp)
    80003bfe:	6d42                	ld	s10,16(sp)
    80003c00:	6da2                	ld	s11,8(sp)
    80003c02:	6165                	addi	sp,sp,112
    80003c04:	8082                	ret
    return -1;
    80003c06:	557d                	li	a0,-1
}
    80003c08:	8082                	ret
    return -1;
    80003c0a:	557d                	li	a0,-1
    80003c0c:	bff1                	j	80003be8 <readi+0xce>

0000000080003c0e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003c0e:	457c                	lw	a5,76(a0)
    80003c10:	10d7e663          	bltu	a5,a3,80003d1c <writei+0x10e>
{
    80003c14:	7159                	addi	sp,sp,-112
    80003c16:	f486                	sd	ra,104(sp)
    80003c18:	f0a2                	sd	s0,96(sp)
    80003c1a:	eca6                	sd	s1,88(sp)
    80003c1c:	e8ca                	sd	s2,80(sp)
    80003c1e:	e4ce                	sd	s3,72(sp)
    80003c20:	e0d2                	sd	s4,64(sp)
    80003c22:	fc56                	sd	s5,56(sp)
    80003c24:	f85a                	sd	s6,48(sp)
    80003c26:	f45e                	sd	s7,40(sp)
    80003c28:	f062                	sd	s8,32(sp)
    80003c2a:	ec66                	sd	s9,24(sp)
    80003c2c:	e86a                	sd	s10,16(sp)
    80003c2e:	e46e                	sd	s11,8(sp)
    80003c30:	1880                	addi	s0,sp,112
    80003c32:	8baa                	mv	s7,a0
    80003c34:	8c2e                	mv	s8,a1
    80003c36:	8ab2                	mv	s5,a2
    80003c38:	8936                	mv	s2,a3
    80003c3a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003c3c:	00e687bb          	addw	a5,a3,a4
    80003c40:	0ed7e063          	bltu	a5,a3,80003d20 <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003c44:	00043737          	lui	a4,0x43
    80003c48:	0cf76e63          	bltu	a4,a5,80003d24 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c4c:	0a0b0763          	beqz	s6,80003cfa <writei+0xec>
    80003c50:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c52:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003c56:	5cfd                	li	s9,-1
    80003c58:	a091                	j	80003c9c <writei+0x8e>
    80003c5a:	02099d93          	slli	s11,s3,0x20
    80003c5e:	020ddd93          	srli	s11,s11,0x20
    80003c62:	06048513          	addi	a0,s1,96
    80003c66:	86ee                	mv	a3,s11
    80003c68:	8656                	mv	a2,s5
    80003c6a:	85e2                	mv	a1,s8
    80003c6c:	953a                	add	a0,a0,a4
    80003c6e:	fffff097          	auipc	ra,0xfffff
    80003c72:	a4e080e7          	jalr	-1458(ra) # 800026bc <either_copyin>
    80003c76:	07950263          	beq	a0,s9,80003cda <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003c7a:	8526                	mv	a0,s1
    80003c7c:	00000097          	auipc	ra,0x0
    80003c80:	77a080e7          	jalr	1914(ra) # 800043f6 <log_write>
    brelse(bp);
    80003c84:	8526                	mv	a0,s1
    80003c86:	fffff097          	auipc	ra,0xfffff
    80003c8a:	532080e7          	jalr	1330(ra) # 800031b8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c8e:	01498a3b          	addw	s4,s3,s4
    80003c92:	0129893b          	addw	s2,s3,s2
    80003c96:	9aee                	add	s5,s5,s11
    80003c98:	056a7663          	bgeu	s4,s6,80003ce4 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003c9c:	000ba483          	lw	s1,0(s7)
    80003ca0:	00a9559b          	srliw	a1,s2,0xa
    80003ca4:	855e                	mv	a0,s7
    80003ca6:	fffff097          	auipc	ra,0xfffff
    80003caa:	7d6080e7          	jalr	2006(ra) # 8000347c <bmap>
    80003cae:	0005059b          	sext.w	a1,a0
    80003cb2:	8526                	mv	a0,s1
    80003cb4:	fffff097          	auipc	ra,0xfffff
    80003cb8:	3d4080e7          	jalr	980(ra) # 80003088 <bread>
    80003cbc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003cbe:	3ff97713          	andi	a4,s2,1023
    80003cc2:	40ed07bb          	subw	a5,s10,a4
    80003cc6:	414b06bb          	subw	a3,s6,s4
    80003cca:	89be                	mv	s3,a5
    80003ccc:	2781                	sext.w	a5,a5
    80003cce:	0006861b          	sext.w	a2,a3
    80003cd2:	f8f674e3          	bgeu	a2,a5,80003c5a <writei+0x4c>
    80003cd6:	89b6                	mv	s3,a3
    80003cd8:	b749                	j	80003c5a <writei+0x4c>
      brelse(bp);
    80003cda:	8526                	mv	a0,s1
    80003cdc:	fffff097          	auipc	ra,0xfffff
    80003ce0:	4dc080e7          	jalr	1244(ra) # 800031b8 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003ce4:	04cba783          	lw	a5,76(s7)
    80003ce8:	0127f463          	bgeu	a5,s2,80003cf0 <writei+0xe2>
      ip->size = off;
    80003cec:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003cf0:	855e                	mv	a0,s7
    80003cf2:	00000097          	auipc	ra,0x0
    80003cf6:	ace080e7          	jalr	-1330(ra) # 800037c0 <iupdate>
  }

  return n;
    80003cfa:	000b051b          	sext.w	a0,s6
}
    80003cfe:	70a6                	ld	ra,104(sp)
    80003d00:	7406                	ld	s0,96(sp)
    80003d02:	64e6                	ld	s1,88(sp)
    80003d04:	6946                	ld	s2,80(sp)
    80003d06:	69a6                	ld	s3,72(sp)
    80003d08:	6a06                	ld	s4,64(sp)
    80003d0a:	7ae2                	ld	s5,56(sp)
    80003d0c:	7b42                	ld	s6,48(sp)
    80003d0e:	7ba2                	ld	s7,40(sp)
    80003d10:	7c02                	ld	s8,32(sp)
    80003d12:	6ce2                	ld	s9,24(sp)
    80003d14:	6d42                	ld	s10,16(sp)
    80003d16:	6da2                	ld	s11,8(sp)
    80003d18:	6165                	addi	sp,sp,112
    80003d1a:	8082                	ret
    return -1;
    80003d1c:	557d                	li	a0,-1
}
    80003d1e:	8082                	ret
    return -1;
    80003d20:	557d                	li	a0,-1
    80003d22:	bff1                	j	80003cfe <writei+0xf0>
    return -1;
    80003d24:	557d                	li	a0,-1
    80003d26:	bfe1                	j	80003cfe <writei+0xf0>

0000000080003d28 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003d28:	1141                	addi	sp,sp,-16
    80003d2a:	e406                	sd	ra,8(sp)
    80003d2c:	e022                	sd	s0,0(sp)
    80003d2e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003d30:	4639                	li	a2,14
    80003d32:	ffffd097          	auipc	ra,0xffffd
    80003d36:	f18080e7          	jalr	-232(ra) # 80000c4a <strncmp>
}
    80003d3a:	60a2                	ld	ra,8(sp)
    80003d3c:	6402                	ld	s0,0(sp)
    80003d3e:	0141                	addi	sp,sp,16
    80003d40:	8082                	ret

0000000080003d42 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003d42:	7139                	addi	sp,sp,-64
    80003d44:	fc06                	sd	ra,56(sp)
    80003d46:	f822                	sd	s0,48(sp)
    80003d48:	f426                	sd	s1,40(sp)
    80003d4a:	f04a                	sd	s2,32(sp)
    80003d4c:	ec4e                	sd	s3,24(sp)
    80003d4e:	e852                	sd	s4,16(sp)
    80003d50:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003d52:	04451703          	lh	a4,68(a0)
    80003d56:	4785                	li	a5,1
    80003d58:	00f71a63          	bne	a4,a5,80003d6c <dirlookup+0x2a>
    80003d5c:	892a                	mv	s2,a0
    80003d5e:	89ae                	mv	s3,a1
    80003d60:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d62:	457c                	lw	a5,76(a0)
    80003d64:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003d66:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d68:	e79d                	bnez	a5,80003d96 <dirlookup+0x54>
    80003d6a:	a8a5                	j	80003de2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003d6c:	00004517          	auipc	a0,0x4
    80003d70:	8a450513          	addi	a0,a0,-1884 # 80007610 <userret+0x580>
    80003d74:	ffffc097          	auipc	ra,0xffffc
    80003d78:	7da080e7          	jalr	2010(ra) # 8000054e <panic>
      panic("dirlookup read");
    80003d7c:	00004517          	auipc	a0,0x4
    80003d80:	8ac50513          	addi	a0,a0,-1876 # 80007628 <userret+0x598>
    80003d84:	ffffc097          	auipc	ra,0xffffc
    80003d88:	7ca080e7          	jalr	1994(ra) # 8000054e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d8c:	24c1                	addiw	s1,s1,16
    80003d8e:	04c92783          	lw	a5,76(s2)
    80003d92:	04f4f763          	bgeu	s1,a5,80003de0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d96:	4741                	li	a4,16
    80003d98:	86a6                	mv	a3,s1
    80003d9a:	fc040613          	addi	a2,s0,-64
    80003d9e:	4581                	li	a1,0
    80003da0:	854a                	mv	a0,s2
    80003da2:	00000097          	auipc	ra,0x0
    80003da6:	d78080e7          	jalr	-648(ra) # 80003b1a <readi>
    80003daa:	47c1                	li	a5,16
    80003dac:	fcf518e3          	bne	a0,a5,80003d7c <dirlookup+0x3a>
    if(de.inum == 0)
    80003db0:	fc045783          	lhu	a5,-64(s0)
    80003db4:	dfe1                	beqz	a5,80003d8c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003db6:	fc240593          	addi	a1,s0,-62
    80003dba:	854e                	mv	a0,s3
    80003dbc:	00000097          	auipc	ra,0x0
    80003dc0:	f6c080e7          	jalr	-148(ra) # 80003d28 <namecmp>
    80003dc4:	f561                	bnez	a0,80003d8c <dirlookup+0x4a>
      if(poff)
    80003dc6:	000a0463          	beqz	s4,80003dce <dirlookup+0x8c>
        *poff = off;
    80003dca:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003dce:	fc045583          	lhu	a1,-64(s0)
    80003dd2:	00092503          	lw	a0,0(s2)
    80003dd6:	fffff097          	auipc	ra,0xfffff
    80003dda:	780080e7          	jalr	1920(ra) # 80003556 <iget>
    80003dde:	a011                	j	80003de2 <dirlookup+0xa0>
  return 0;
    80003de0:	4501                	li	a0,0
}
    80003de2:	70e2                	ld	ra,56(sp)
    80003de4:	7442                	ld	s0,48(sp)
    80003de6:	74a2                	ld	s1,40(sp)
    80003de8:	7902                	ld	s2,32(sp)
    80003dea:	69e2                	ld	s3,24(sp)
    80003dec:	6a42                	ld	s4,16(sp)
    80003dee:	6121                	addi	sp,sp,64
    80003df0:	8082                	ret

0000000080003df2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003df2:	711d                	addi	sp,sp,-96
    80003df4:	ec86                	sd	ra,88(sp)
    80003df6:	e8a2                	sd	s0,80(sp)
    80003df8:	e4a6                	sd	s1,72(sp)
    80003dfa:	e0ca                	sd	s2,64(sp)
    80003dfc:	fc4e                	sd	s3,56(sp)
    80003dfe:	f852                	sd	s4,48(sp)
    80003e00:	f456                	sd	s5,40(sp)
    80003e02:	f05a                	sd	s6,32(sp)
    80003e04:	ec5e                	sd	s7,24(sp)
    80003e06:	e862                	sd	s8,16(sp)
    80003e08:	e466                	sd	s9,8(sp)
    80003e0a:	1080                	addi	s0,sp,96
    80003e0c:	84aa                	mv	s1,a0
    80003e0e:	8b2e                	mv	s6,a1
    80003e10:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003e12:	00054703          	lbu	a4,0(a0)
    80003e16:	02f00793          	li	a5,47
    80003e1a:	02f70363          	beq	a4,a5,80003e40 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003e1e:	ffffe097          	auipc	ra,0xffffe
    80003e22:	a26080e7          	jalr	-1498(ra) # 80001844 <myproc>
    80003e26:	15853503          	ld	a0,344(a0)
    80003e2a:	00000097          	auipc	ra,0x0
    80003e2e:	a22080e7          	jalr	-1502(ra) # 8000384c <idup>
    80003e32:	89aa                	mv	s3,a0
  while(*path == '/')
    80003e34:	02f00913          	li	s2,47
  len = path - s;
    80003e38:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003e3a:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003e3c:	4c05                	li	s8,1
    80003e3e:	a865                	j	80003ef6 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003e40:	4585                	li	a1,1
    80003e42:	4505                	li	a0,1
    80003e44:	fffff097          	auipc	ra,0xfffff
    80003e48:	712080e7          	jalr	1810(ra) # 80003556 <iget>
    80003e4c:	89aa                	mv	s3,a0
    80003e4e:	b7dd                	j	80003e34 <namex+0x42>
      iunlockput(ip);
    80003e50:	854e                	mv	a0,s3
    80003e52:	00000097          	auipc	ra,0x0
    80003e56:	c76080e7          	jalr	-906(ra) # 80003ac8 <iunlockput>
      return 0;
    80003e5a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003e5c:	854e                	mv	a0,s3
    80003e5e:	60e6                	ld	ra,88(sp)
    80003e60:	6446                	ld	s0,80(sp)
    80003e62:	64a6                	ld	s1,72(sp)
    80003e64:	6906                	ld	s2,64(sp)
    80003e66:	79e2                	ld	s3,56(sp)
    80003e68:	7a42                	ld	s4,48(sp)
    80003e6a:	7aa2                	ld	s5,40(sp)
    80003e6c:	7b02                	ld	s6,32(sp)
    80003e6e:	6be2                	ld	s7,24(sp)
    80003e70:	6c42                	ld	s8,16(sp)
    80003e72:	6ca2                	ld	s9,8(sp)
    80003e74:	6125                	addi	sp,sp,96
    80003e76:	8082                	ret
      iunlock(ip);
    80003e78:	854e                	mv	a0,s3
    80003e7a:	00000097          	auipc	ra,0x0
    80003e7e:	ad2080e7          	jalr	-1326(ra) # 8000394c <iunlock>
      return ip;
    80003e82:	bfe9                	j	80003e5c <namex+0x6a>
      iunlockput(ip);
    80003e84:	854e                	mv	a0,s3
    80003e86:	00000097          	auipc	ra,0x0
    80003e8a:	c42080e7          	jalr	-958(ra) # 80003ac8 <iunlockput>
      return 0;
    80003e8e:	89d2                	mv	s3,s4
    80003e90:	b7f1                	j	80003e5c <namex+0x6a>
  len = path - s;
    80003e92:	40b48633          	sub	a2,s1,a1
    80003e96:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003e9a:	094cd463          	bge	s9,s4,80003f22 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003e9e:	4639                	li	a2,14
    80003ea0:	8556                	mv	a0,s5
    80003ea2:	ffffd097          	auipc	ra,0xffffd
    80003ea6:	d2c080e7          	jalr	-724(ra) # 80000bce <memmove>
  while(*path == '/')
    80003eaa:	0004c783          	lbu	a5,0(s1)
    80003eae:	01279763          	bne	a5,s2,80003ebc <namex+0xca>
    path++;
    80003eb2:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003eb4:	0004c783          	lbu	a5,0(s1)
    80003eb8:	ff278de3          	beq	a5,s2,80003eb2 <namex+0xc0>
    ilock(ip);
    80003ebc:	854e                	mv	a0,s3
    80003ebe:	00000097          	auipc	ra,0x0
    80003ec2:	9cc080e7          	jalr	-1588(ra) # 8000388a <ilock>
    if(ip->type != T_DIR){
    80003ec6:	04499783          	lh	a5,68(s3)
    80003eca:	f98793e3          	bne	a5,s8,80003e50 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003ece:	000b0563          	beqz	s6,80003ed8 <namex+0xe6>
    80003ed2:	0004c783          	lbu	a5,0(s1)
    80003ed6:	d3cd                	beqz	a5,80003e78 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003ed8:	865e                	mv	a2,s7
    80003eda:	85d6                	mv	a1,s5
    80003edc:	854e                	mv	a0,s3
    80003ede:	00000097          	auipc	ra,0x0
    80003ee2:	e64080e7          	jalr	-412(ra) # 80003d42 <dirlookup>
    80003ee6:	8a2a                	mv	s4,a0
    80003ee8:	dd51                	beqz	a0,80003e84 <namex+0x92>
    iunlockput(ip);
    80003eea:	854e                	mv	a0,s3
    80003eec:	00000097          	auipc	ra,0x0
    80003ef0:	bdc080e7          	jalr	-1060(ra) # 80003ac8 <iunlockput>
    ip = next;
    80003ef4:	89d2                	mv	s3,s4
  while(*path == '/')
    80003ef6:	0004c783          	lbu	a5,0(s1)
    80003efa:	05279763          	bne	a5,s2,80003f48 <namex+0x156>
    path++;
    80003efe:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003f00:	0004c783          	lbu	a5,0(s1)
    80003f04:	ff278de3          	beq	a5,s2,80003efe <namex+0x10c>
  if(*path == 0)
    80003f08:	c79d                	beqz	a5,80003f36 <namex+0x144>
    path++;
    80003f0a:	85a6                	mv	a1,s1
  len = path - s;
    80003f0c:	8a5e                	mv	s4,s7
    80003f0e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003f10:	01278963          	beq	a5,s2,80003f22 <namex+0x130>
    80003f14:	dfbd                	beqz	a5,80003e92 <namex+0xa0>
    path++;
    80003f16:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003f18:	0004c783          	lbu	a5,0(s1)
    80003f1c:	ff279ce3          	bne	a5,s2,80003f14 <namex+0x122>
    80003f20:	bf8d                	j	80003e92 <namex+0xa0>
    memmove(name, s, len);
    80003f22:	2601                	sext.w	a2,a2
    80003f24:	8556                	mv	a0,s5
    80003f26:	ffffd097          	auipc	ra,0xffffd
    80003f2a:	ca8080e7          	jalr	-856(ra) # 80000bce <memmove>
    name[len] = 0;
    80003f2e:	9a56                	add	s4,s4,s5
    80003f30:	000a0023          	sb	zero,0(s4)
    80003f34:	bf9d                	j	80003eaa <namex+0xb8>
  if(nameiparent){
    80003f36:	f20b03e3          	beqz	s6,80003e5c <namex+0x6a>
    iput(ip);
    80003f3a:	854e                	mv	a0,s3
    80003f3c:	00000097          	auipc	ra,0x0
    80003f40:	a5c080e7          	jalr	-1444(ra) # 80003998 <iput>
    return 0;
    80003f44:	4981                	li	s3,0
    80003f46:	bf19                	j	80003e5c <namex+0x6a>
  if(*path == 0)
    80003f48:	d7fd                	beqz	a5,80003f36 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003f4a:	0004c783          	lbu	a5,0(s1)
    80003f4e:	85a6                	mv	a1,s1
    80003f50:	b7d1                	j	80003f14 <namex+0x122>

0000000080003f52 <dirlink>:
{
    80003f52:	7139                	addi	sp,sp,-64
    80003f54:	fc06                	sd	ra,56(sp)
    80003f56:	f822                	sd	s0,48(sp)
    80003f58:	f426                	sd	s1,40(sp)
    80003f5a:	f04a                	sd	s2,32(sp)
    80003f5c:	ec4e                	sd	s3,24(sp)
    80003f5e:	e852                	sd	s4,16(sp)
    80003f60:	0080                	addi	s0,sp,64
    80003f62:	892a                	mv	s2,a0
    80003f64:	8a2e                	mv	s4,a1
    80003f66:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003f68:	4601                	li	a2,0
    80003f6a:	00000097          	auipc	ra,0x0
    80003f6e:	dd8080e7          	jalr	-552(ra) # 80003d42 <dirlookup>
    80003f72:	e93d                	bnez	a0,80003fe8 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f74:	04c92483          	lw	s1,76(s2)
    80003f78:	c49d                	beqz	s1,80003fa6 <dirlink+0x54>
    80003f7a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f7c:	4741                	li	a4,16
    80003f7e:	86a6                	mv	a3,s1
    80003f80:	fc040613          	addi	a2,s0,-64
    80003f84:	4581                	li	a1,0
    80003f86:	854a                	mv	a0,s2
    80003f88:	00000097          	auipc	ra,0x0
    80003f8c:	b92080e7          	jalr	-1134(ra) # 80003b1a <readi>
    80003f90:	47c1                	li	a5,16
    80003f92:	06f51163          	bne	a0,a5,80003ff4 <dirlink+0xa2>
    if(de.inum == 0)
    80003f96:	fc045783          	lhu	a5,-64(s0)
    80003f9a:	c791                	beqz	a5,80003fa6 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f9c:	24c1                	addiw	s1,s1,16
    80003f9e:	04c92783          	lw	a5,76(s2)
    80003fa2:	fcf4ede3          	bltu	s1,a5,80003f7c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003fa6:	4639                	li	a2,14
    80003fa8:	85d2                	mv	a1,s4
    80003faa:	fc240513          	addi	a0,s0,-62
    80003fae:	ffffd097          	auipc	ra,0xffffd
    80003fb2:	cd8080e7          	jalr	-808(ra) # 80000c86 <strncpy>
  de.inum = inum;
    80003fb6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003fba:	4741                	li	a4,16
    80003fbc:	86a6                	mv	a3,s1
    80003fbe:	fc040613          	addi	a2,s0,-64
    80003fc2:	4581                	li	a1,0
    80003fc4:	854a                	mv	a0,s2
    80003fc6:	00000097          	auipc	ra,0x0
    80003fca:	c48080e7          	jalr	-952(ra) # 80003c0e <writei>
    80003fce:	872a                	mv	a4,a0
    80003fd0:	47c1                	li	a5,16
  return 0;
    80003fd2:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003fd4:	02f71863          	bne	a4,a5,80004004 <dirlink+0xb2>
}
    80003fd8:	70e2                	ld	ra,56(sp)
    80003fda:	7442                	ld	s0,48(sp)
    80003fdc:	74a2                	ld	s1,40(sp)
    80003fde:	7902                	ld	s2,32(sp)
    80003fe0:	69e2                	ld	s3,24(sp)
    80003fe2:	6a42                	ld	s4,16(sp)
    80003fe4:	6121                	addi	sp,sp,64
    80003fe6:	8082                	ret
    iput(ip);
    80003fe8:	00000097          	auipc	ra,0x0
    80003fec:	9b0080e7          	jalr	-1616(ra) # 80003998 <iput>
    return -1;
    80003ff0:	557d                	li	a0,-1
    80003ff2:	b7dd                	j	80003fd8 <dirlink+0x86>
      panic("dirlink read");
    80003ff4:	00003517          	auipc	a0,0x3
    80003ff8:	64450513          	addi	a0,a0,1604 # 80007638 <userret+0x5a8>
    80003ffc:	ffffc097          	auipc	ra,0xffffc
    80004000:	552080e7          	jalr	1362(ra) # 8000054e <panic>
    panic("dirlink");
    80004004:	00003517          	auipc	a0,0x3
    80004008:	75450513          	addi	a0,a0,1876 # 80007758 <userret+0x6c8>
    8000400c:	ffffc097          	auipc	ra,0xffffc
    80004010:	542080e7          	jalr	1346(ra) # 8000054e <panic>

0000000080004014 <namei>:

struct inode*
namei(char *path)
{
    80004014:	1101                	addi	sp,sp,-32
    80004016:	ec06                	sd	ra,24(sp)
    80004018:	e822                	sd	s0,16(sp)
    8000401a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000401c:	fe040613          	addi	a2,s0,-32
    80004020:	4581                	li	a1,0
    80004022:	00000097          	auipc	ra,0x0
    80004026:	dd0080e7          	jalr	-560(ra) # 80003df2 <namex>
}
    8000402a:	60e2                	ld	ra,24(sp)
    8000402c:	6442                	ld	s0,16(sp)
    8000402e:	6105                	addi	sp,sp,32
    80004030:	8082                	ret

0000000080004032 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004032:	1141                	addi	sp,sp,-16
    80004034:	e406                	sd	ra,8(sp)
    80004036:	e022                	sd	s0,0(sp)
    80004038:	0800                	addi	s0,sp,16
    8000403a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000403c:	4585                	li	a1,1
    8000403e:	00000097          	auipc	ra,0x0
    80004042:	db4080e7          	jalr	-588(ra) # 80003df2 <namex>
}
    80004046:	60a2                	ld	ra,8(sp)
    80004048:	6402                	ld	s0,0(sp)
    8000404a:	0141                	addi	sp,sp,16
    8000404c:	8082                	ret

000000008000404e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000404e:	1101                	addi	sp,sp,-32
    80004050:	ec06                	sd	ra,24(sp)
    80004052:	e822                	sd	s0,16(sp)
    80004054:	e426                	sd	s1,8(sp)
    80004056:	e04a                	sd	s2,0(sp)
    80004058:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000405a:	0001e917          	auipc	s2,0x1e
    8000405e:	b3e90913          	addi	s2,s2,-1218 # 80021b98 <log>
    80004062:	01892583          	lw	a1,24(s2)
    80004066:	02892503          	lw	a0,40(s2)
    8000406a:	fffff097          	auipc	ra,0xfffff
    8000406e:	01e080e7          	jalr	30(ra) # 80003088 <bread>
    80004072:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004074:	02c92683          	lw	a3,44(s2)
    80004078:	d134                	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000407a:	02d05763          	blez	a3,800040a8 <write_head+0x5a>
    8000407e:	0001e797          	auipc	a5,0x1e
    80004082:	b4a78793          	addi	a5,a5,-1206 # 80021bc8 <log+0x30>
    80004086:	06450713          	addi	a4,a0,100
    8000408a:	36fd                	addiw	a3,a3,-1
    8000408c:	1682                	slli	a3,a3,0x20
    8000408e:	9281                	srli	a3,a3,0x20
    80004090:	068a                	slli	a3,a3,0x2
    80004092:	0001e617          	auipc	a2,0x1e
    80004096:	b3a60613          	addi	a2,a2,-1222 # 80021bcc <log+0x34>
    8000409a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000409c:	4390                	lw	a2,0(a5)
    8000409e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800040a0:	0791                	addi	a5,a5,4
    800040a2:	0711                	addi	a4,a4,4
    800040a4:	fed79ce3          	bne	a5,a3,8000409c <write_head+0x4e>
  }
  bwrite(buf);
    800040a8:	8526                	mv	a0,s1
    800040aa:	fffff097          	auipc	ra,0xfffff
    800040ae:	0d0080e7          	jalr	208(ra) # 8000317a <bwrite>
  brelse(buf);
    800040b2:	8526                	mv	a0,s1
    800040b4:	fffff097          	auipc	ra,0xfffff
    800040b8:	104080e7          	jalr	260(ra) # 800031b8 <brelse>
}
    800040bc:	60e2                	ld	ra,24(sp)
    800040be:	6442                	ld	s0,16(sp)
    800040c0:	64a2                	ld	s1,8(sp)
    800040c2:	6902                	ld	s2,0(sp)
    800040c4:	6105                	addi	sp,sp,32
    800040c6:	8082                	ret

00000000800040c8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800040c8:	0001e797          	auipc	a5,0x1e
    800040cc:	afc7a783          	lw	a5,-1284(a5) # 80021bc4 <log+0x2c>
    800040d0:	0af05663          	blez	a5,8000417c <install_trans+0xb4>
{
    800040d4:	7139                	addi	sp,sp,-64
    800040d6:	fc06                	sd	ra,56(sp)
    800040d8:	f822                	sd	s0,48(sp)
    800040da:	f426                	sd	s1,40(sp)
    800040dc:	f04a                	sd	s2,32(sp)
    800040de:	ec4e                	sd	s3,24(sp)
    800040e0:	e852                	sd	s4,16(sp)
    800040e2:	e456                	sd	s5,8(sp)
    800040e4:	0080                	addi	s0,sp,64
    800040e6:	0001ea97          	auipc	s5,0x1e
    800040ea:	ae2a8a93          	addi	s5,s5,-1310 # 80021bc8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800040ee:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800040f0:	0001e997          	auipc	s3,0x1e
    800040f4:	aa898993          	addi	s3,s3,-1368 # 80021b98 <log>
    800040f8:	0189a583          	lw	a1,24(s3)
    800040fc:	014585bb          	addw	a1,a1,s4
    80004100:	2585                	addiw	a1,a1,1
    80004102:	0289a503          	lw	a0,40(s3)
    80004106:	fffff097          	auipc	ra,0xfffff
    8000410a:	f82080e7          	jalr	-126(ra) # 80003088 <bread>
    8000410e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004110:	000aa583          	lw	a1,0(s5)
    80004114:	0289a503          	lw	a0,40(s3)
    80004118:	fffff097          	auipc	ra,0xfffff
    8000411c:	f70080e7          	jalr	-144(ra) # 80003088 <bread>
    80004120:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004122:	40000613          	li	a2,1024
    80004126:	06090593          	addi	a1,s2,96
    8000412a:	06050513          	addi	a0,a0,96
    8000412e:	ffffd097          	auipc	ra,0xffffd
    80004132:	aa0080e7          	jalr	-1376(ra) # 80000bce <memmove>
    bwrite(dbuf);  // write dst to disk
    80004136:	8526                	mv	a0,s1
    80004138:	fffff097          	auipc	ra,0xfffff
    8000413c:	042080e7          	jalr	66(ra) # 8000317a <bwrite>
    bunpin(dbuf);
    80004140:	8526                	mv	a0,s1
    80004142:	fffff097          	auipc	ra,0xfffff
    80004146:	150080e7          	jalr	336(ra) # 80003292 <bunpin>
    brelse(lbuf);
    8000414a:	854a                	mv	a0,s2
    8000414c:	fffff097          	auipc	ra,0xfffff
    80004150:	06c080e7          	jalr	108(ra) # 800031b8 <brelse>
    brelse(dbuf);
    80004154:	8526                	mv	a0,s1
    80004156:	fffff097          	auipc	ra,0xfffff
    8000415a:	062080e7          	jalr	98(ra) # 800031b8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000415e:	2a05                	addiw	s4,s4,1
    80004160:	0a91                	addi	s5,s5,4
    80004162:	02c9a783          	lw	a5,44(s3)
    80004166:	f8fa49e3          	blt	s4,a5,800040f8 <install_trans+0x30>
}
    8000416a:	70e2                	ld	ra,56(sp)
    8000416c:	7442                	ld	s0,48(sp)
    8000416e:	74a2                	ld	s1,40(sp)
    80004170:	7902                	ld	s2,32(sp)
    80004172:	69e2                	ld	s3,24(sp)
    80004174:	6a42                	ld	s4,16(sp)
    80004176:	6aa2                	ld	s5,8(sp)
    80004178:	6121                	addi	sp,sp,64
    8000417a:	8082                	ret
    8000417c:	8082                	ret

000000008000417e <initlog>:
{
    8000417e:	7179                	addi	sp,sp,-48
    80004180:	f406                	sd	ra,40(sp)
    80004182:	f022                	sd	s0,32(sp)
    80004184:	ec26                	sd	s1,24(sp)
    80004186:	e84a                	sd	s2,16(sp)
    80004188:	e44e                	sd	s3,8(sp)
    8000418a:	1800                	addi	s0,sp,48
    8000418c:	892a                	mv	s2,a0
    8000418e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004190:	0001e497          	auipc	s1,0x1e
    80004194:	a0848493          	addi	s1,s1,-1528 # 80021b98 <log>
    80004198:	00003597          	auipc	a1,0x3
    8000419c:	4b058593          	addi	a1,a1,1200 # 80007648 <userret+0x5b8>
    800041a0:	8526                	mv	a0,s1
    800041a2:	ffffd097          	auipc	ra,0xffffd
    800041a6:	81e080e7          	jalr	-2018(ra) # 800009c0 <initlock>
  log.start = sb->logstart;
    800041aa:	0149a583          	lw	a1,20(s3)
    800041ae:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800041b0:	0109a783          	lw	a5,16(s3)
    800041b4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800041b6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800041ba:	854a                	mv	a0,s2
    800041bc:	fffff097          	auipc	ra,0xfffff
    800041c0:	ecc080e7          	jalr	-308(ra) # 80003088 <bread>
  log.lh.n = lh->n;
    800041c4:	513c                	lw	a5,96(a0)
    800041c6:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800041c8:	02f05563          	blez	a5,800041f2 <initlog+0x74>
    800041cc:	06450713          	addi	a4,a0,100
    800041d0:	0001e697          	auipc	a3,0x1e
    800041d4:	9f868693          	addi	a3,a3,-1544 # 80021bc8 <log+0x30>
    800041d8:	37fd                	addiw	a5,a5,-1
    800041da:	1782                	slli	a5,a5,0x20
    800041dc:	9381                	srli	a5,a5,0x20
    800041de:	078a                	slli	a5,a5,0x2
    800041e0:	06850613          	addi	a2,a0,104
    800041e4:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800041e6:	4310                	lw	a2,0(a4)
    800041e8:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800041ea:	0711                	addi	a4,a4,4
    800041ec:	0691                	addi	a3,a3,4
    800041ee:	fef71ce3          	bne	a4,a5,800041e6 <initlog+0x68>
  brelse(buf);
    800041f2:	fffff097          	auipc	ra,0xfffff
    800041f6:	fc6080e7          	jalr	-58(ra) # 800031b8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    800041fa:	00000097          	auipc	ra,0x0
    800041fe:	ece080e7          	jalr	-306(ra) # 800040c8 <install_trans>
  log.lh.n = 0;
    80004202:	0001e797          	auipc	a5,0x1e
    80004206:	9c07a123          	sw	zero,-1598(a5) # 80021bc4 <log+0x2c>
  write_head(); // clear the log
    8000420a:	00000097          	auipc	ra,0x0
    8000420e:	e44080e7          	jalr	-444(ra) # 8000404e <write_head>
}
    80004212:	70a2                	ld	ra,40(sp)
    80004214:	7402                	ld	s0,32(sp)
    80004216:	64e2                	ld	s1,24(sp)
    80004218:	6942                	ld	s2,16(sp)
    8000421a:	69a2                	ld	s3,8(sp)
    8000421c:	6145                	addi	sp,sp,48
    8000421e:	8082                	ret

0000000080004220 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004220:	1101                	addi	sp,sp,-32
    80004222:	ec06                	sd	ra,24(sp)
    80004224:	e822                	sd	s0,16(sp)
    80004226:	e426                	sd	s1,8(sp)
    80004228:	e04a                	sd	s2,0(sp)
    8000422a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000422c:	0001e517          	auipc	a0,0x1e
    80004230:	96c50513          	addi	a0,a0,-1684 # 80021b98 <log>
    80004234:	ffffd097          	auipc	ra,0xffffd
    80004238:	89e080e7          	jalr	-1890(ra) # 80000ad2 <acquire>
  while(1){
    if(log.committing){
    8000423c:	0001e497          	auipc	s1,0x1e
    80004240:	95c48493          	addi	s1,s1,-1700 # 80021b98 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004244:	4979                	li	s2,30
    80004246:	a039                	j	80004254 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004248:	85a6                	mv	a1,s1
    8000424a:	8526                	mv	a0,s1
    8000424c:	ffffe097          	auipc	ra,0xffffe
    80004250:	076080e7          	jalr	118(ra) # 800022c2 <sleep>
    if(log.committing){
    80004254:	50dc                	lw	a5,36(s1)
    80004256:	fbed                	bnez	a5,80004248 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004258:	509c                	lw	a5,32(s1)
    8000425a:	0017871b          	addiw	a4,a5,1
    8000425e:	0007069b          	sext.w	a3,a4
    80004262:	0027179b          	slliw	a5,a4,0x2
    80004266:	9fb9                	addw	a5,a5,a4
    80004268:	0017979b          	slliw	a5,a5,0x1
    8000426c:	54d8                	lw	a4,44(s1)
    8000426e:	9fb9                	addw	a5,a5,a4
    80004270:	00f95963          	bge	s2,a5,80004282 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004274:	85a6                	mv	a1,s1
    80004276:	8526                	mv	a0,s1
    80004278:	ffffe097          	auipc	ra,0xffffe
    8000427c:	04a080e7          	jalr	74(ra) # 800022c2 <sleep>
    80004280:	bfd1                	j	80004254 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004282:	0001e517          	auipc	a0,0x1e
    80004286:	91650513          	addi	a0,a0,-1770 # 80021b98 <log>
    8000428a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000428c:	ffffd097          	auipc	ra,0xffffd
    80004290:	89a080e7          	jalr	-1894(ra) # 80000b26 <release>
      break;
    }
  }
}
    80004294:	60e2                	ld	ra,24(sp)
    80004296:	6442                	ld	s0,16(sp)
    80004298:	64a2                	ld	s1,8(sp)
    8000429a:	6902                	ld	s2,0(sp)
    8000429c:	6105                	addi	sp,sp,32
    8000429e:	8082                	ret

00000000800042a0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800042a0:	7139                	addi	sp,sp,-64
    800042a2:	fc06                	sd	ra,56(sp)
    800042a4:	f822                	sd	s0,48(sp)
    800042a6:	f426                	sd	s1,40(sp)
    800042a8:	f04a                	sd	s2,32(sp)
    800042aa:	ec4e                	sd	s3,24(sp)
    800042ac:	e852                	sd	s4,16(sp)
    800042ae:	e456                	sd	s5,8(sp)
    800042b0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800042b2:	0001e497          	auipc	s1,0x1e
    800042b6:	8e648493          	addi	s1,s1,-1818 # 80021b98 <log>
    800042ba:	8526                	mv	a0,s1
    800042bc:	ffffd097          	auipc	ra,0xffffd
    800042c0:	816080e7          	jalr	-2026(ra) # 80000ad2 <acquire>
  log.outstanding -= 1;
    800042c4:	509c                	lw	a5,32(s1)
    800042c6:	37fd                	addiw	a5,a5,-1
    800042c8:	0007891b          	sext.w	s2,a5
    800042cc:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800042ce:	50dc                	lw	a5,36(s1)
    800042d0:	efb9                	bnez	a5,8000432e <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800042d2:	06091663          	bnez	s2,8000433e <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800042d6:	0001e497          	auipc	s1,0x1e
    800042da:	8c248493          	addi	s1,s1,-1854 # 80021b98 <log>
    800042de:	4785                	li	a5,1
    800042e0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800042e2:	8526                	mv	a0,s1
    800042e4:	ffffd097          	auipc	ra,0xffffd
    800042e8:	842080e7          	jalr	-1982(ra) # 80000b26 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800042ec:	54dc                	lw	a5,44(s1)
    800042ee:	06f04763          	bgtz	a5,8000435c <end_op+0xbc>
    acquire(&log.lock);
    800042f2:	0001e497          	auipc	s1,0x1e
    800042f6:	8a648493          	addi	s1,s1,-1882 # 80021b98 <log>
    800042fa:	8526                	mv	a0,s1
    800042fc:	ffffc097          	auipc	ra,0xffffc
    80004300:	7d6080e7          	jalr	2006(ra) # 80000ad2 <acquire>
    log.committing = 0;
    80004304:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004308:	8526                	mv	a0,s1
    8000430a:	ffffe097          	auipc	ra,0xffffe
    8000430e:	282080e7          	jalr	642(ra) # 8000258c <wakeup>
    release(&log.lock);
    80004312:	8526                	mv	a0,s1
    80004314:	ffffd097          	auipc	ra,0xffffd
    80004318:	812080e7          	jalr	-2030(ra) # 80000b26 <release>
}
    8000431c:	70e2                	ld	ra,56(sp)
    8000431e:	7442                	ld	s0,48(sp)
    80004320:	74a2                	ld	s1,40(sp)
    80004322:	7902                	ld	s2,32(sp)
    80004324:	69e2                	ld	s3,24(sp)
    80004326:	6a42                	ld	s4,16(sp)
    80004328:	6aa2                	ld	s5,8(sp)
    8000432a:	6121                	addi	sp,sp,64
    8000432c:	8082                	ret
    panic("log.committing");
    8000432e:	00003517          	auipc	a0,0x3
    80004332:	32250513          	addi	a0,a0,802 # 80007650 <userret+0x5c0>
    80004336:	ffffc097          	auipc	ra,0xffffc
    8000433a:	218080e7          	jalr	536(ra) # 8000054e <panic>
    wakeup(&log);
    8000433e:	0001e497          	auipc	s1,0x1e
    80004342:	85a48493          	addi	s1,s1,-1958 # 80021b98 <log>
    80004346:	8526                	mv	a0,s1
    80004348:	ffffe097          	auipc	ra,0xffffe
    8000434c:	244080e7          	jalr	580(ra) # 8000258c <wakeup>
  release(&log.lock);
    80004350:	8526                	mv	a0,s1
    80004352:	ffffc097          	auipc	ra,0xffffc
    80004356:	7d4080e7          	jalr	2004(ra) # 80000b26 <release>
  if(do_commit){
    8000435a:	b7c9                	j	8000431c <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000435c:	0001ea97          	auipc	s5,0x1e
    80004360:	86ca8a93          	addi	s5,s5,-1940 # 80021bc8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004364:	0001ea17          	auipc	s4,0x1e
    80004368:	834a0a13          	addi	s4,s4,-1996 # 80021b98 <log>
    8000436c:	018a2583          	lw	a1,24(s4)
    80004370:	012585bb          	addw	a1,a1,s2
    80004374:	2585                	addiw	a1,a1,1
    80004376:	028a2503          	lw	a0,40(s4)
    8000437a:	fffff097          	auipc	ra,0xfffff
    8000437e:	d0e080e7          	jalr	-754(ra) # 80003088 <bread>
    80004382:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004384:	000aa583          	lw	a1,0(s5)
    80004388:	028a2503          	lw	a0,40(s4)
    8000438c:	fffff097          	auipc	ra,0xfffff
    80004390:	cfc080e7          	jalr	-772(ra) # 80003088 <bread>
    80004394:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004396:	40000613          	li	a2,1024
    8000439a:	06050593          	addi	a1,a0,96
    8000439e:	06048513          	addi	a0,s1,96
    800043a2:	ffffd097          	auipc	ra,0xffffd
    800043a6:	82c080e7          	jalr	-2004(ra) # 80000bce <memmove>
    bwrite(to);  // write the log
    800043aa:	8526                	mv	a0,s1
    800043ac:	fffff097          	auipc	ra,0xfffff
    800043b0:	dce080e7          	jalr	-562(ra) # 8000317a <bwrite>
    brelse(from);
    800043b4:	854e                	mv	a0,s3
    800043b6:	fffff097          	auipc	ra,0xfffff
    800043ba:	e02080e7          	jalr	-510(ra) # 800031b8 <brelse>
    brelse(to);
    800043be:	8526                	mv	a0,s1
    800043c0:	fffff097          	auipc	ra,0xfffff
    800043c4:	df8080e7          	jalr	-520(ra) # 800031b8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800043c8:	2905                	addiw	s2,s2,1
    800043ca:	0a91                	addi	s5,s5,4
    800043cc:	02ca2783          	lw	a5,44(s4)
    800043d0:	f8f94ee3          	blt	s2,a5,8000436c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800043d4:	00000097          	auipc	ra,0x0
    800043d8:	c7a080e7          	jalr	-902(ra) # 8000404e <write_head>
    install_trans(); // Now install writes to home locations
    800043dc:	00000097          	auipc	ra,0x0
    800043e0:	cec080e7          	jalr	-788(ra) # 800040c8 <install_trans>
    log.lh.n = 0;
    800043e4:	0001d797          	auipc	a5,0x1d
    800043e8:	7e07a023          	sw	zero,2016(a5) # 80021bc4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800043ec:	00000097          	auipc	ra,0x0
    800043f0:	c62080e7          	jalr	-926(ra) # 8000404e <write_head>
    800043f4:	bdfd                	j	800042f2 <end_op+0x52>

00000000800043f6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800043f6:	1101                	addi	sp,sp,-32
    800043f8:	ec06                	sd	ra,24(sp)
    800043fa:	e822                	sd	s0,16(sp)
    800043fc:	e426                	sd	s1,8(sp)
    800043fe:	e04a                	sd	s2,0(sp)
    80004400:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004402:	0001d717          	auipc	a4,0x1d
    80004406:	7c272703          	lw	a4,1986(a4) # 80021bc4 <log+0x2c>
    8000440a:	47f5                	li	a5,29
    8000440c:	08e7c063          	blt	a5,a4,8000448c <log_write+0x96>
    80004410:	84aa                	mv	s1,a0
    80004412:	0001d797          	auipc	a5,0x1d
    80004416:	7a27a783          	lw	a5,1954(a5) # 80021bb4 <log+0x1c>
    8000441a:	37fd                	addiw	a5,a5,-1
    8000441c:	06f75863          	bge	a4,a5,8000448c <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004420:	0001d797          	auipc	a5,0x1d
    80004424:	7987a783          	lw	a5,1944(a5) # 80021bb8 <log+0x20>
    80004428:	06f05a63          	blez	a5,8000449c <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    8000442c:	0001d917          	auipc	s2,0x1d
    80004430:	76c90913          	addi	s2,s2,1900 # 80021b98 <log>
    80004434:	854a                	mv	a0,s2
    80004436:	ffffc097          	auipc	ra,0xffffc
    8000443a:	69c080e7          	jalr	1692(ra) # 80000ad2 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    8000443e:	02c92603          	lw	a2,44(s2)
    80004442:	06c05563          	blez	a2,800044ac <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004446:	44cc                	lw	a1,12(s1)
    80004448:	0001d717          	auipc	a4,0x1d
    8000444c:	78070713          	addi	a4,a4,1920 # 80021bc8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004450:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004452:	4314                	lw	a3,0(a4)
    80004454:	04b68d63          	beq	a3,a1,800044ae <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    80004458:	2785                	addiw	a5,a5,1
    8000445a:	0711                	addi	a4,a4,4
    8000445c:	fec79be3          	bne	a5,a2,80004452 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004460:	0621                	addi	a2,a2,8
    80004462:	060a                	slli	a2,a2,0x2
    80004464:	0001d797          	auipc	a5,0x1d
    80004468:	73478793          	addi	a5,a5,1844 # 80021b98 <log>
    8000446c:	963e                	add	a2,a2,a5
    8000446e:	44dc                	lw	a5,12(s1)
    80004470:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004472:	8526                	mv	a0,s1
    80004474:	fffff097          	auipc	ra,0xfffff
    80004478:	de2080e7          	jalr	-542(ra) # 80003256 <bpin>
    log.lh.n++;
    8000447c:	0001d717          	auipc	a4,0x1d
    80004480:	71c70713          	addi	a4,a4,1820 # 80021b98 <log>
    80004484:	575c                	lw	a5,44(a4)
    80004486:	2785                	addiw	a5,a5,1
    80004488:	d75c                	sw	a5,44(a4)
    8000448a:	a83d                	j	800044c8 <log_write+0xd2>
    panic("too big a transaction");
    8000448c:	00003517          	auipc	a0,0x3
    80004490:	1d450513          	addi	a0,a0,468 # 80007660 <userret+0x5d0>
    80004494:	ffffc097          	auipc	ra,0xffffc
    80004498:	0ba080e7          	jalr	186(ra) # 8000054e <panic>
    panic("log_write outside of trans");
    8000449c:	00003517          	auipc	a0,0x3
    800044a0:	1dc50513          	addi	a0,a0,476 # 80007678 <userret+0x5e8>
    800044a4:	ffffc097          	auipc	ra,0xffffc
    800044a8:	0aa080e7          	jalr	170(ra) # 8000054e <panic>
  for (i = 0; i < log.lh.n; i++) {
    800044ac:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    800044ae:	00878713          	addi	a4,a5,8
    800044b2:	00271693          	slli	a3,a4,0x2
    800044b6:	0001d717          	auipc	a4,0x1d
    800044ba:	6e270713          	addi	a4,a4,1762 # 80021b98 <log>
    800044be:	9736                	add	a4,a4,a3
    800044c0:	44d4                	lw	a3,12(s1)
    800044c2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800044c4:	faf607e3          	beq	a2,a5,80004472 <log_write+0x7c>
  }
  release(&log.lock);
    800044c8:	0001d517          	auipc	a0,0x1d
    800044cc:	6d050513          	addi	a0,a0,1744 # 80021b98 <log>
    800044d0:	ffffc097          	auipc	ra,0xffffc
    800044d4:	656080e7          	jalr	1622(ra) # 80000b26 <release>
}
    800044d8:	60e2                	ld	ra,24(sp)
    800044da:	6442                	ld	s0,16(sp)
    800044dc:	64a2                	ld	s1,8(sp)
    800044de:	6902                	ld	s2,0(sp)
    800044e0:	6105                	addi	sp,sp,32
    800044e2:	8082                	ret

00000000800044e4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800044e4:	1101                	addi	sp,sp,-32
    800044e6:	ec06                	sd	ra,24(sp)
    800044e8:	e822                	sd	s0,16(sp)
    800044ea:	e426                	sd	s1,8(sp)
    800044ec:	e04a                	sd	s2,0(sp)
    800044ee:	1000                	addi	s0,sp,32
    800044f0:	84aa                	mv	s1,a0
    800044f2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800044f4:	00003597          	auipc	a1,0x3
    800044f8:	1a458593          	addi	a1,a1,420 # 80007698 <userret+0x608>
    800044fc:	0521                	addi	a0,a0,8
    800044fe:	ffffc097          	auipc	ra,0xffffc
    80004502:	4c2080e7          	jalr	1218(ra) # 800009c0 <initlock>
  lk->name = name;
    80004506:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000450a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000450e:	0204a423          	sw	zero,40(s1)
}
    80004512:	60e2                	ld	ra,24(sp)
    80004514:	6442                	ld	s0,16(sp)
    80004516:	64a2                	ld	s1,8(sp)
    80004518:	6902                	ld	s2,0(sp)
    8000451a:	6105                	addi	sp,sp,32
    8000451c:	8082                	ret

000000008000451e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000451e:	1101                	addi	sp,sp,-32
    80004520:	ec06                	sd	ra,24(sp)
    80004522:	e822                	sd	s0,16(sp)
    80004524:	e426                	sd	s1,8(sp)
    80004526:	e04a                	sd	s2,0(sp)
    80004528:	1000                	addi	s0,sp,32
    8000452a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000452c:	00850913          	addi	s2,a0,8
    80004530:	854a                	mv	a0,s2
    80004532:	ffffc097          	auipc	ra,0xffffc
    80004536:	5a0080e7          	jalr	1440(ra) # 80000ad2 <acquire>
  while (lk->locked) {
    8000453a:	409c                	lw	a5,0(s1)
    8000453c:	cb89                	beqz	a5,8000454e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000453e:	85ca                	mv	a1,s2
    80004540:	8526                	mv	a0,s1
    80004542:	ffffe097          	auipc	ra,0xffffe
    80004546:	d80080e7          	jalr	-640(ra) # 800022c2 <sleep>
  while (lk->locked) {
    8000454a:	409c                	lw	a5,0(s1)
    8000454c:	fbed                	bnez	a5,8000453e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000454e:	4785                	li	a5,1
    80004550:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004552:	ffffd097          	auipc	ra,0xffffd
    80004556:	2f2080e7          	jalr	754(ra) # 80001844 <myproc>
    8000455a:	5d1c                	lw	a5,56(a0)
    8000455c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000455e:	854a                	mv	a0,s2
    80004560:	ffffc097          	auipc	ra,0xffffc
    80004564:	5c6080e7          	jalr	1478(ra) # 80000b26 <release>
}
    80004568:	60e2                	ld	ra,24(sp)
    8000456a:	6442                	ld	s0,16(sp)
    8000456c:	64a2                	ld	s1,8(sp)
    8000456e:	6902                	ld	s2,0(sp)
    80004570:	6105                	addi	sp,sp,32
    80004572:	8082                	ret

0000000080004574 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004574:	1101                	addi	sp,sp,-32
    80004576:	ec06                	sd	ra,24(sp)
    80004578:	e822                	sd	s0,16(sp)
    8000457a:	e426                	sd	s1,8(sp)
    8000457c:	e04a                	sd	s2,0(sp)
    8000457e:	1000                	addi	s0,sp,32
    80004580:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004582:	00850913          	addi	s2,a0,8
    80004586:	854a                	mv	a0,s2
    80004588:	ffffc097          	auipc	ra,0xffffc
    8000458c:	54a080e7          	jalr	1354(ra) # 80000ad2 <acquire>
  lk->locked = 0;
    80004590:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004594:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004598:	8526                	mv	a0,s1
    8000459a:	ffffe097          	auipc	ra,0xffffe
    8000459e:	ff2080e7          	jalr	-14(ra) # 8000258c <wakeup>
  release(&lk->lk);
    800045a2:	854a                	mv	a0,s2
    800045a4:	ffffc097          	auipc	ra,0xffffc
    800045a8:	582080e7          	jalr	1410(ra) # 80000b26 <release>
}
    800045ac:	60e2                	ld	ra,24(sp)
    800045ae:	6442                	ld	s0,16(sp)
    800045b0:	64a2                	ld	s1,8(sp)
    800045b2:	6902                	ld	s2,0(sp)
    800045b4:	6105                	addi	sp,sp,32
    800045b6:	8082                	ret

00000000800045b8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800045b8:	7179                	addi	sp,sp,-48
    800045ba:	f406                	sd	ra,40(sp)
    800045bc:	f022                	sd	s0,32(sp)
    800045be:	ec26                	sd	s1,24(sp)
    800045c0:	e84a                	sd	s2,16(sp)
    800045c2:	e44e                	sd	s3,8(sp)
    800045c4:	1800                	addi	s0,sp,48
    800045c6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800045c8:	00850913          	addi	s2,a0,8
    800045cc:	854a                	mv	a0,s2
    800045ce:	ffffc097          	auipc	ra,0xffffc
    800045d2:	504080e7          	jalr	1284(ra) # 80000ad2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800045d6:	409c                	lw	a5,0(s1)
    800045d8:	ef99                	bnez	a5,800045f6 <holdingsleep+0x3e>
    800045da:	4481                	li	s1,0
  release(&lk->lk);
    800045dc:	854a                	mv	a0,s2
    800045de:	ffffc097          	auipc	ra,0xffffc
    800045e2:	548080e7          	jalr	1352(ra) # 80000b26 <release>
  return r;
}
    800045e6:	8526                	mv	a0,s1
    800045e8:	70a2                	ld	ra,40(sp)
    800045ea:	7402                	ld	s0,32(sp)
    800045ec:	64e2                	ld	s1,24(sp)
    800045ee:	6942                	ld	s2,16(sp)
    800045f0:	69a2                	ld	s3,8(sp)
    800045f2:	6145                	addi	sp,sp,48
    800045f4:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800045f6:	0284a983          	lw	s3,40(s1)
    800045fa:	ffffd097          	auipc	ra,0xffffd
    800045fe:	24a080e7          	jalr	586(ra) # 80001844 <myproc>
    80004602:	5d04                	lw	s1,56(a0)
    80004604:	413484b3          	sub	s1,s1,s3
    80004608:	0014b493          	seqz	s1,s1
    8000460c:	bfc1                	j	800045dc <holdingsleep+0x24>

000000008000460e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000460e:	1141                	addi	sp,sp,-16
    80004610:	e406                	sd	ra,8(sp)
    80004612:	e022                	sd	s0,0(sp)
    80004614:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004616:	00003597          	auipc	a1,0x3
    8000461a:	09258593          	addi	a1,a1,146 # 800076a8 <userret+0x618>
    8000461e:	0001d517          	auipc	a0,0x1d
    80004622:	6c250513          	addi	a0,a0,1730 # 80021ce0 <ftable>
    80004626:	ffffc097          	auipc	ra,0xffffc
    8000462a:	39a080e7          	jalr	922(ra) # 800009c0 <initlock>
}
    8000462e:	60a2                	ld	ra,8(sp)
    80004630:	6402                	ld	s0,0(sp)
    80004632:	0141                	addi	sp,sp,16
    80004634:	8082                	ret

0000000080004636 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004636:	1101                	addi	sp,sp,-32
    80004638:	ec06                	sd	ra,24(sp)
    8000463a:	e822                	sd	s0,16(sp)
    8000463c:	e426                	sd	s1,8(sp)
    8000463e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004640:	0001d517          	auipc	a0,0x1d
    80004644:	6a050513          	addi	a0,a0,1696 # 80021ce0 <ftable>
    80004648:	ffffc097          	auipc	ra,0xffffc
    8000464c:	48a080e7          	jalr	1162(ra) # 80000ad2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004650:	0001d497          	auipc	s1,0x1d
    80004654:	6a848493          	addi	s1,s1,1704 # 80021cf8 <ftable+0x18>
    80004658:	0001e717          	auipc	a4,0x1e
    8000465c:	64070713          	addi	a4,a4,1600 # 80022c98 <ftable+0xfb8>
    if(f->ref == 0){
    80004660:	40dc                	lw	a5,4(s1)
    80004662:	cf99                	beqz	a5,80004680 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004664:	02848493          	addi	s1,s1,40
    80004668:	fee49ce3          	bne	s1,a4,80004660 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000466c:	0001d517          	auipc	a0,0x1d
    80004670:	67450513          	addi	a0,a0,1652 # 80021ce0 <ftable>
    80004674:	ffffc097          	auipc	ra,0xffffc
    80004678:	4b2080e7          	jalr	1202(ra) # 80000b26 <release>
  return 0;
    8000467c:	4481                	li	s1,0
    8000467e:	a819                	j	80004694 <filealloc+0x5e>
      f->ref = 1;
    80004680:	4785                	li	a5,1
    80004682:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004684:	0001d517          	auipc	a0,0x1d
    80004688:	65c50513          	addi	a0,a0,1628 # 80021ce0 <ftable>
    8000468c:	ffffc097          	auipc	ra,0xffffc
    80004690:	49a080e7          	jalr	1178(ra) # 80000b26 <release>
}
    80004694:	8526                	mv	a0,s1
    80004696:	60e2                	ld	ra,24(sp)
    80004698:	6442                	ld	s0,16(sp)
    8000469a:	64a2                	ld	s1,8(sp)
    8000469c:	6105                	addi	sp,sp,32
    8000469e:	8082                	ret

00000000800046a0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800046a0:	1101                	addi	sp,sp,-32
    800046a2:	ec06                	sd	ra,24(sp)
    800046a4:	e822                	sd	s0,16(sp)
    800046a6:	e426                	sd	s1,8(sp)
    800046a8:	1000                	addi	s0,sp,32
    800046aa:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800046ac:	0001d517          	auipc	a0,0x1d
    800046b0:	63450513          	addi	a0,a0,1588 # 80021ce0 <ftable>
    800046b4:	ffffc097          	auipc	ra,0xffffc
    800046b8:	41e080e7          	jalr	1054(ra) # 80000ad2 <acquire>
  if(f->ref < 1)
    800046bc:	40dc                	lw	a5,4(s1)
    800046be:	02f05263          	blez	a5,800046e2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800046c2:	2785                	addiw	a5,a5,1
    800046c4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800046c6:	0001d517          	auipc	a0,0x1d
    800046ca:	61a50513          	addi	a0,a0,1562 # 80021ce0 <ftable>
    800046ce:	ffffc097          	auipc	ra,0xffffc
    800046d2:	458080e7          	jalr	1112(ra) # 80000b26 <release>
  return f;
}
    800046d6:	8526                	mv	a0,s1
    800046d8:	60e2                	ld	ra,24(sp)
    800046da:	6442                	ld	s0,16(sp)
    800046dc:	64a2                	ld	s1,8(sp)
    800046de:	6105                	addi	sp,sp,32
    800046e0:	8082                	ret
    panic("filedup");
    800046e2:	00003517          	auipc	a0,0x3
    800046e6:	fce50513          	addi	a0,a0,-50 # 800076b0 <userret+0x620>
    800046ea:	ffffc097          	auipc	ra,0xffffc
    800046ee:	e64080e7          	jalr	-412(ra) # 8000054e <panic>

00000000800046f2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800046f2:	7139                	addi	sp,sp,-64
    800046f4:	fc06                	sd	ra,56(sp)
    800046f6:	f822                	sd	s0,48(sp)
    800046f8:	f426                	sd	s1,40(sp)
    800046fa:	f04a                	sd	s2,32(sp)
    800046fc:	ec4e                	sd	s3,24(sp)
    800046fe:	e852                	sd	s4,16(sp)
    80004700:	e456                	sd	s5,8(sp)
    80004702:	0080                	addi	s0,sp,64
    80004704:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004706:	0001d517          	auipc	a0,0x1d
    8000470a:	5da50513          	addi	a0,a0,1498 # 80021ce0 <ftable>
    8000470e:	ffffc097          	auipc	ra,0xffffc
    80004712:	3c4080e7          	jalr	964(ra) # 80000ad2 <acquire>
  if(f->ref < 1)
    80004716:	40dc                	lw	a5,4(s1)
    80004718:	06f05163          	blez	a5,8000477a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000471c:	37fd                	addiw	a5,a5,-1
    8000471e:	0007871b          	sext.w	a4,a5
    80004722:	c0dc                	sw	a5,4(s1)
    80004724:	06e04363          	bgtz	a4,8000478a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004728:	0004a903          	lw	s2,0(s1)
    8000472c:	0094ca83          	lbu	s5,9(s1)
    80004730:	0104ba03          	ld	s4,16(s1)
    80004734:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004738:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000473c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004740:	0001d517          	auipc	a0,0x1d
    80004744:	5a050513          	addi	a0,a0,1440 # 80021ce0 <ftable>
    80004748:	ffffc097          	auipc	ra,0xffffc
    8000474c:	3de080e7          	jalr	990(ra) # 80000b26 <release>

  if(ff.type == FD_PIPE){
    80004750:	4785                	li	a5,1
    80004752:	04f90d63          	beq	s2,a5,800047ac <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004756:	3979                	addiw	s2,s2,-2
    80004758:	4785                	li	a5,1
    8000475a:	0527e063          	bltu	a5,s2,8000479a <fileclose+0xa8>
    begin_op();
    8000475e:	00000097          	auipc	ra,0x0
    80004762:	ac2080e7          	jalr	-1342(ra) # 80004220 <begin_op>
    iput(ff.ip);
    80004766:	854e                	mv	a0,s3
    80004768:	fffff097          	auipc	ra,0xfffff
    8000476c:	230080e7          	jalr	560(ra) # 80003998 <iput>
    end_op();
    80004770:	00000097          	auipc	ra,0x0
    80004774:	b30080e7          	jalr	-1232(ra) # 800042a0 <end_op>
    80004778:	a00d                	j	8000479a <fileclose+0xa8>
    panic("fileclose");
    8000477a:	00003517          	auipc	a0,0x3
    8000477e:	f3e50513          	addi	a0,a0,-194 # 800076b8 <userret+0x628>
    80004782:	ffffc097          	auipc	ra,0xffffc
    80004786:	dcc080e7          	jalr	-564(ra) # 8000054e <panic>
    release(&ftable.lock);
    8000478a:	0001d517          	auipc	a0,0x1d
    8000478e:	55650513          	addi	a0,a0,1366 # 80021ce0 <ftable>
    80004792:	ffffc097          	auipc	ra,0xffffc
    80004796:	394080e7          	jalr	916(ra) # 80000b26 <release>
  }
}
    8000479a:	70e2                	ld	ra,56(sp)
    8000479c:	7442                	ld	s0,48(sp)
    8000479e:	74a2                	ld	s1,40(sp)
    800047a0:	7902                	ld	s2,32(sp)
    800047a2:	69e2                	ld	s3,24(sp)
    800047a4:	6a42                	ld	s4,16(sp)
    800047a6:	6aa2                	ld	s5,8(sp)
    800047a8:	6121                	addi	sp,sp,64
    800047aa:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800047ac:	85d6                	mv	a1,s5
    800047ae:	8552                	mv	a0,s4
    800047b0:	00000097          	auipc	ra,0x0
    800047b4:	372080e7          	jalr	882(ra) # 80004b22 <pipeclose>
    800047b8:	b7cd                	j	8000479a <fileclose+0xa8>

00000000800047ba <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800047ba:	715d                	addi	sp,sp,-80
    800047bc:	e486                	sd	ra,72(sp)
    800047be:	e0a2                	sd	s0,64(sp)
    800047c0:	fc26                	sd	s1,56(sp)
    800047c2:	f84a                	sd	s2,48(sp)
    800047c4:	f44e                	sd	s3,40(sp)
    800047c6:	0880                	addi	s0,sp,80
    800047c8:	84aa                	mv	s1,a0
    800047ca:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800047cc:	ffffd097          	auipc	ra,0xffffd
    800047d0:	078080e7          	jalr	120(ra) # 80001844 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800047d4:	409c                	lw	a5,0(s1)
    800047d6:	37f9                	addiw	a5,a5,-2
    800047d8:	4705                	li	a4,1
    800047da:	04f76763          	bltu	a4,a5,80004828 <filestat+0x6e>
    800047de:	892a                	mv	s2,a0
    ilock(f->ip);
    800047e0:	6c88                	ld	a0,24(s1)
    800047e2:	fffff097          	auipc	ra,0xfffff
    800047e6:	0a8080e7          	jalr	168(ra) # 8000388a <ilock>
    stati(f->ip, &st);
    800047ea:	fb840593          	addi	a1,s0,-72
    800047ee:	6c88                	ld	a0,24(s1)
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	300080e7          	jalr	768(ra) # 80003af0 <stati>
    iunlock(f->ip);
    800047f8:	6c88                	ld	a0,24(s1)
    800047fa:	fffff097          	auipc	ra,0xfffff
    800047fe:	152080e7          	jalr	338(ra) # 8000394c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004802:	46e1                	li	a3,24
    80004804:	fb840613          	addi	a2,s0,-72
    80004808:	85ce                	mv	a1,s3
    8000480a:	05893503          	ld	a0,88(s2)
    8000480e:	ffffd097          	auipc	ra,0xffffd
    80004812:	d2a080e7          	jalr	-726(ra) # 80001538 <copyout>
    80004816:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000481a:	60a6                	ld	ra,72(sp)
    8000481c:	6406                	ld	s0,64(sp)
    8000481e:	74e2                	ld	s1,56(sp)
    80004820:	7942                	ld	s2,48(sp)
    80004822:	79a2                	ld	s3,40(sp)
    80004824:	6161                	addi	sp,sp,80
    80004826:	8082                	ret
  return -1;
    80004828:	557d                	li	a0,-1
    8000482a:	bfc5                	j	8000481a <filestat+0x60>

000000008000482c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000482c:	7179                	addi	sp,sp,-48
    8000482e:	f406                	sd	ra,40(sp)
    80004830:	f022                	sd	s0,32(sp)
    80004832:	ec26                	sd	s1,24(sp)
    80004834:	e84a                	sd	s2,16(sp)
    80004836:	e44e                	sd	s3,8(sp)
    80004838:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000483a:	00854783          	lbu	a5,8(a0)
    8000483e:	c3d5                	beqz	a5,800048e2 <fileread+0xb6>
    80004840:	84aa                	mv	s1,a0
    80004842:	89ae                	mv	s3,a1
    80004844:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004846:	411c                	lw	a5,0(a0)
    80004848:	4705                	li	a4,1
    8000484a:	04e78963          	beq	a5,a4,8000489c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000484e:	470d                	li	a4,3
    80004850:	04e78d63          	beq	a5,a4,800048aa <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004854:	4709                	li	a4,2
    80004856:	06e79e63          	bne	a5,a4,800048d2 <fileread+0xa6>
    ilock(f->ip);
    8000485a:	6d08                	ld	a0,24(a0)
    8000485c:	fffff097          	auipc	ra,0xfffff
    80004860:	02e080e7          	jalr	46(ra) # 8000388a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004864:	874a                	mv	a4,s2
    80004866:	5094                	lw	a3,32(s1)
    80004868:	864e                	mv	a2,s3
    8000486a:	4585                	li	a1,1
    8000486c:	6c88                	ld	a0,24(s1)
    8000486e:	fffff097          	auipc	ra,0xfffff
    80004872:	2ac080e7          	jalr	684(ra) # 80003b1a <readi>
    80004876:	892a                	mv	s2,a0
    80004878:	00a05563          	blez	a0,80004882 <fileread+0x56>
      f->off += r;
    8000487c:	509c                	lw	a5,32(s1)
    8000487e:	9fa9                	addw	a5,a5,a0
    80004880:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004882:	6c88                	ld	a0,24(s1)
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	0c8080e7          	jalr	200(ra) # 8000394c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000488c:	854a                	mv	a0,s2
    8000488e:	70a2                	ld	ra,40(sp)
    80004890:	7402                	ld	s0,32(sp)
    80004892:	64e2                	ld	s1,24(sp)
    80004894:	6942                	ld	s2,16(sp)
    80004896:	69a2                	ld	s3,8(sp)
    80004898:	6145                	addi	sp,sp,48
    8000489a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000489c:	6908                	ld	a0,16(a0)
    8000489e:	00000097          	auipc	ra,0x0
    800048a2:	408080e7          	jalr	1032(ra) # 80004ca6 <piperead>
    800048a6:	892a                	mv	s2,a0
    800048a8:	b7d5                	j	8000488c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800048aa:	02451783          	lh	a5,36(a0)
    800048ae:	03079693          	slli	a3,a5,0x30
    800048b2:	92c1                	srli	a3,a3,0x30
    800048b4:	4725                	li	a4,9
    800048b6:	02d76863          	bltu	a4,a3,800048e6 <fileread+0xba>
    800048ba:	0792                	slli	a5,a5,0x4
    800048bc:	0001d717          	auipc	a4,0x1d
    800048c0:	38470713          	addi	a4,a4,900 # 80021c40 <devsw>
    800048c4:	97ba                	add	a5,a5,a4
    800048c6:	639c                	ld	a5,0(a5)
    800048c8:	c38d                	beqz	a5,800048ea <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800048ca:	4505                	li	a0,1
    800048cc:	9782                	jalr	a5
    800048ce:	892a                	mv	s2,a0
    800048d0:	bf75                	j	8000488c <fileread+0x60>
    panic("fileread");
    800048d2:	00003517          	auipc	a0,0x3
    800048d6:	df650513          	addi	a0,a0,-522 # 800076c8 <userret+0x638>
    800048da:	ffffc097          	auipc	ra,0xffffc
    800048de:	c74080e7          	jalr	-908(ra) # 8000054e <panic>
    return -1;
    800048e2:	597d                	li	s2,-1
    800048e4:	b765                	j	8000488c <fileread+0x60>
      return -1;
    800048e6:	597d                	li	s2,-1
    800048e8:	b755                	j	8000488c <fileread+0x60>
    800048ea:	597d                	li	s2,-1
    800048ec:	b745                	j	8000488c <fileread+0x60>

00000000800048ee <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800048ee:	00954783          	lbu	a5,9(a0)
    800048f2:	14078563          	beqz	a5,80004a3c <filewrite+0x14e>
{
    800048f6:	715d                	addi	sp,sp,-80
    800048f8:	e486                	sd	ra,72(sp)
    800048fa:	e0a2                	sd	s0,64(sp)
    800048fc:	fc26                	sd	s1,56(sp)
    800048fe:	f84a                	sd	s2,48(sp)
    80004900:	f44e                	sd	s3,40(sp)
    80004902:	f052                	sd	s4,32(sp)
    80004904:	ec56                	sd	s5,24(sp)
    80004906:	e85a                	sd	s6,16(sp)
    80004908:	e45e                	sd	s7,8(sp)
    8000490a:	e062                	sd	s8,0(sp)
    8000490c:	0880                	addi	s0,sp,80
    8000490e:	892a                	mv	s2,a0
    80004910:	8aae                	mv	s5,a1
    80004912:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004914:	411c                	lw	a5,0(a0)
    80004916:	4705                	li	a4,1
    80004918:	02e78263          	beq	a5,a4,8000493c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000491c:	470d                	li	a4,3
    8000491e:	02e78563          	beq	a5,a4,80004948 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004922:	4709                	li	a4,2
    80004924:	10e79463          	bne	a5,a4,80004a2c <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004928:	0ec05e63          	blez	a2,80004a24 <filewrite+0x136>
    int i = 0;
    8000492c:	4981                	li	s3,0
    8000492e:	6b05                	lui	s6,0x1
    80004930:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004934:	6b85                	lui	s7,0x1
    80004936:	c00b8b9b          	addiw	s7,s7,-1024
    8000493a:	a851                	j	800049ce <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    8000493c:	6908                	ld	a0,16(a0)
    8000493e:	00000097          	auipc	ra,0x0
    80004942:	254080e7          	jalr	596(ra) # 80004b92 <pipewrite>
    80004946:	a85d                	j	800049fc <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004948:	02451783          	lh	a5,36(a0)
    8000494c:	03079693          	slli	a3,a5,0x30
    80004950:	92c1                	srli	a3,a3,0x30
    80004952:	4725                	li	a4,9
    80004954:	0ed76663          	bltu	a4,a3,80004a40 <filewrite+0x152>
    80004958:	0792                	slli	a5,a5,0x4
    8000495a:	0001d717          	auipc	a4,0x1d
    8000495e:	2e670713          	addi	a4,a4,742 # 80021c40 <devsw>
    80004962:	97ba                	add	a5,a5,a4
    80004964:	679c                	ld	a5,8(a5)
    80004966:	cff9                	beqz	a5,80004a44 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004968:	4505                	li	a0,1
    8000496a:	9782                	jalr	a5
    8000496c:	a841                	j	800049fc <filewrite+0x10e>
    8000496e:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004972:	00000097          	auipc	ra,0x0
    80004976:	8ae080e7          	jalr	-1874(ra) # 80004220 <begin_op>
      ilock(f->ip);
    8000497a:	01893503          	ld	a0,24(s2)
    8000497e:	fffff097          	auipc	ra,0xfffff
    80004982:	f0c080e7          	jalr	-244(ra) # 8000388a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004986:	8762                	mv	a4,s8
    80004988:	02092683          	lw	a3,32(s2)
    8000498c:	01598633          	add	a2,s3,s5
    80004990:	4585                	li	a1,1
    80004992:	01893503          	ld	a0,24(s2)
    80004996:	fffff097          	auipc	ra,0xfffff
    8000499a:	278080e7          	jalr	632(ra) # 80003c0e <writei>
    8000499e:	84aa                	mv	s1,a0
    800049a0:	02a05f63          	blez	a0,800049de <filewrite+0xf0>
        f->off += r;
    800049a4:	02092783          	lw	a5,32(s2)
    800049a8:	9fa9                	addw	a5,a5,a0
    800049aa:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800049ae:	01893503          	ld	a0,24(s2)
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	f9a080e7          	jalr	-102(ra) # 8000394c <iunlock>
      end_op();
    800049ba:	00000097          	auipc	ra,0x0
    800049be:	8e6080e7          	jalr	-1818(ra) # 800042a0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    800049c2:	049c1963          	bne	s8,s1,80004a14 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    800049c6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800049ca:	0349d663          	bge	s3,s4,800049f6 <filewrite+0x108>
      int n1 = n - i;
    800049ce:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800049d2:	84be                	mv	s1,a5
    800049d4:	2781                	sext.w	a5,a5
    800049d6:	f8fb5ce3          	bge	s6,a5,8000496e <filewrite+0x80>
    800049da:	84de                	mv	s1,s7
    800049dc:	bf49                	j	8000496e <filewrite+0x80>
      iunlock(f->ip);
    800049de:	01893503          	ld	a0,24(s2)
    800049e2:	fffff097          	auipc	ra,0xfffff
    800049e6:	f6a080e7          	jalr	-150(ra) # 8000394c <iunlock>
      end_op();
    800049ea:	00000097          	auipc	ra,0x0
    800049ee:	8b6080e7          	jalr	-1866(ra) # 800042a0 <end_op>
      if(r < 0)
    800049f2:	fc04d8e3          	bgez	s1,800049c2 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    800049f6:	8552                	mv	a0,s4
    800049f8:	033a1863          	bne	s4,s3,80004a28 <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800049fc:	60a6                	ld	ra,72(sp)
    800049fe:	6406                	ld	s0,64(sp)
    80004a00:	74e2                	ld	s1,56(sp)
    80004a02:	7942                	ld	s2,48(sp)
    80004a04:	79a2                	ld	s3,40(sp)
    80004a06:	7a02                	ld	s4,32(sp)
    80004a08:	6ae2                	ld	s5,24(sp)
    80004a0a:	6b42                	ld	s6,16(sp)
    80004a0c:	6ba2                	ld	s7,8(sp)
    80004a0e:	6c02                	ld	s8,0(sp)
    80004a10:	6161                	addi	sp,sp,80
    80004a12:	8082                	ret
        panic("short filewrite");
    80004a14:	00003517          	auipc	a0,0x3
    80004a18:	cc450513          	addi	a0,a0,-828 # 800076d8 <userret+0x648>
    80004a1c:	ffffc097          	auipc	ra,0xffffc
    80004a20:	b32080e7          	jalr	-1230(ra) # 8000054e <panic>
    int i = 0;
    80004a24:	4981                	li	s3,0
    80004a26:	bfc1                	j	800049f6 <filewrite+0x108>
    ret = (i == n ? n : -1);
    80004a28:	557d                	li	a0,-1
    80004a2a:	bfc9                	j	800049fc <filewrite+0x10e>
    panic("filewrite");
    80004a2c:	00003517          	auipc	a0,0x3
    80004a30:	cbc50513          	addi	a0,a0,-836 # 800076e8 <userret+0x658>
    80004a34:	ffffc097          	auipc	ra,0xffffc
    80004a38:	b1a080e7          	jalr	-1254(ra) # 8000054e <panic>
    return -1;
    80004a3c:	557d                	li	a0,-1
}
    80004a3e:	8082                	ret
      return -1;
    80004a40:	557d                	li	a0,-1
    80004a42:	bf6d                	j	800049fc <filewrite+0x10e>
    80004a44:	557d                	li	a0,-1
    80004a46:	bf5d                	j	800049fc <filewrite+0x10e>

0000000080004a48 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004a48:	7179                	addi	sp,sp,-48
    80004a4a:	f406                	sd	ra,40(sp)
    80004a4c:	f022                	sd	s0,32(sp)
    80004a4e:	ec26                	sd	s1,24(sp)
    80004a50:	e84a                	sd	s2,16(sp)
    80004a52:	e44e                	sd	s3,8(sp)
    80004a54:	e052                	sd	s4,0(sp)
    80004a56:	1800                	addi	s0,sp,48
    80004a58:	84aa                	mv	s1,a0
    80004a5a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004a5c:	0005b023          	sd	zero,0(a1)
    80004a60:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004a64:	00000097          	auipc	ra,0x0
    80004a68:	bd2080e7          	jalr	-1070(ra) # 80004636 <filealloc>
    80004a6c:	e088                	sd	a0,0(s1)
    80004a6e:	c551                	beqz	a0,80004afa <pipealloc+0xb2>
    80004a70:	00000097          	auipc	ra,0x0
    80004a74:	bc6080e7          	jalr	-1082(ra) # 80004636 <filealloc>
    80004a78:	00aa3023          	sd	a0,0(s4)
    80004a7c:	c92d                	beqz	a0,80004aee <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004a7e:	ffffc097          	auipc	ra,0xffffc
    80004a82:	ee2080e7          	jalr	-286(ra) # 80000960 <kalloc>
    80004a86:	892a                	mv	s2,a0
    80004a88:	c125                	beqz	a0,80004ae8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004a8a:	4985                	li	s3,1
    80004a8c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004a90:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004a94:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004a98:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004a9c:	00003597          	auipc	a1,0x3
    80004aa0:	c5c58593          	addi	a1,a1,-932 # 800076f8 <userret+0x668>
    80004aa4:	ffffc097          	auipc	ra,0xffffc
    80004aa8:	f1c080e7          	jalr	-228(ra) # 800009c0 <initlock>
  (*f0)->type = FD_PIPE;
    80004aac:	609c                	ld	a5,0(s1)
    80004aae:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004ab2:	609c                	ld	a5,0(s1)
    80004ab4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004ab8:	609c                	ld	a5,0(s1)
    80004aba:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004abe:	609c                	ld	a5,0(s1)
    80004ac0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004ac4:	000a3783          	ld	a5,0(s4)
    80004ac8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004acc:	000a3783          	ld	a5,0(s4)
    80004ad0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004ad4:	000a3783          	ld	a5,0(s4)
    80004ad8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004adc:	000a3783          	ld	a5,0(s4)
    80004ae0:	0127b823          	sd	s2,16(a5)
  return 0;
    80004ae4:	4501                	li	a0,0
    80004ae6:	a025                	j	80004b0e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004ae8:	6088                	ld	a0,0(s1)
    80004aea:	e501                	bnez	a0,80004af2 <pipealloc+0xaa>
    80004aec:	a039                	j	80004afa <pipealloc+0xb2>
    80004aee:	6088                	ld	a0,0(s1)
    80004af0:	c51d                	beqz	a0,80004b1e <pipealloc+0xd6>
    fileclose(*f0);
    80004af2:	00000097          	auipc	ra,0x0
    80004af6:	c00080e7          	jalr	-1024(ra) # 800046f2 <fileclose>
  if(*f1)
    80004afa:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004afe:	557d                	li	a0,-1
  if(*f1)
    80004b00:	c799                	beqz	a5,80004b0e <pipealloc+0xc6>
    fileclose(*f1);
    80004b02:	853e                	mv	a0,a5
    80004b04:	00000097          	auipc	ra,0x0
    80004b08:	bee080e7          	jalr	-1042(ra) # 800046f2 <fileclose>
  return -1;
    80004b0c:	557d                	li	a0,-1
}
    80004b0e:	70a2                	ld	ra,40(sp)
    80004b10:	7402                	ld	s0,32(sp)
    80004b12:	64e2                	ld	s1,24(sp)
    80004b14:	6942                	ld	s2,16(sp)
    80004b16:	69a2                	ld	s3,8(sp)
    80004b18:	6a02                	ld	s4,0(sp)
    80004b1a:	6145                	addi	sp,sp,48
    80004b1c:	8082                	ret
  return -1;
    80004b1e:	557d                	li	a0,-1
    80004b20:	b7fd                	j	80004b0e <pipealloc+0xc6>

0000000080004b22 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004b22:	1101                	addi	sp,sp,-32
    80004b24:	ec06                	sd	ra,24(sp)
    80004b26:	e822                	sd	s0,16(sp)
    80004b28:	e426                	sd	s1,8(sp)
    80004b2a:	e04a                	sd	s2,0(sp)
    80004b2c:	1000                	addi	s0,sp,32
    80004b2e:	84aa                	mv	s1,a0
    80004b30:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004b32:	ffffc097          	auipc	ra,0xffffc
    80004b36:	fa0080e7          	jalr	-96(ra) # 80000ad2 <acquire>
  if(writable){
    80004b3a:	02090d63          	beqz	s2,80004b74 <pipeclose+0x52>
    pi->writeopen = 0;
    80004b3e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004b42:	21848513          	addi	a0,s1,536
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	a46080e7          	jalr	-1466(ra) # 8000258c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004b4e:	2204b783          	ld	a5,544(s1)
    80004b52:	eb95                	bnez	a5,80004b86 <pipeclose+0x64>
    release(&pi->lock);
    80004b54:	8526                	mv	a0,s1
    80004b56:	ffffc097          	auipc	ra,0xffffc
    80004b5a:	fd0080e7          	jalr	-48(ra) # 80000b26 <release>
    kfree((char*)pi);
    80004b5e:	8526                	mv	a0,s1
    80004b60:	ffffc097          	auipc	ra,0xffffc
    80004b64:	d04080e7          	jalr	-764(ra) # 80000864 <kfree>
  } else
    release(&pi->lock);
}
    80004b68:	60e2                	ld	ra,24(sp)
    80004b6a:	6442                	ld	s0,16(sp)
    80004b6c:	64a2                	ld	s1,8(sp)
    80004b6e:	6902                	ld	s2,0(sp)
    80004b70:	6105                	addi	sp,sp,32
    80004b72:	8082                	ret
    pi->readopen = 0;
    80004b74:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004b78:	21c48513          	addi	a0,s1,540
    80004b7c:	ffffe097          	auipc	ra,0xffffe
    80004b80:	a10080e7          	jalr	-1520(ra) # 8000258c <wakeup>
    80004b84:	b7e9                	j	80004b4e <pipeclose+0x2c>
    release(&pi->lock);
    80004b86:	8526                	mv	a0,s1
    80004b88:	ffffc097          	auipc	ra,0xffffc
    80004b8c:	f9e080e7          	jalr	-98(ra) # 80000b26 <release>
}
    80004b90:	bfe1                	j	80004b68 <pipeclose+0x46>

0000000080004b92 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004b92:	7159                	addi	sp,sp,-112
    80004b94:	f486                	sd	ra,104(sp)
    80004b96:	f0a2                	sd	s0,96(sp)
    80004b98:	eca6                	sd	s1,88(sp)
    80004b9a:	e8ca                	sd	s2,80(sp)
    80004b9c:	e4ce                	sd	s3,72(sp)
    80004b9e:	e0d2                	sd	s4,64(sp)
    80004ba0:	fc56                	sd	s5,56(sp)
    80004ba2:	f85a                	sd	s6,48(sp)
    80004ba4:	f45e                	sd	s7,40(sp)
    80004ba6:	f062                	sd	s8,32(sp)
    80004ba8:	ec66                	sd	s9,24(sp)
    80004baa:	1880                	addi	s0,sp,112
    80004bac:	84aa                	mv	s1,a0
    80004bae:	8b2e                	mv	s6,a1
    80004bb0:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004bb2:	ffffd097          	auipc	ra,0xffffd
    80004bb6:	c92080e7          	jalr	-878(ra) # 80001844 <myproc>
    80004bba:	8c2a                	mv	s8,a0

  acquire(&pi->lock);
    80004bbc:	8526                	mv	a0,s1
    80004bbe:	ffffc097          	auipc	ra,0xffffc
    80004bc2:	f14080e7          	jalr	-236(ra) # 80000ad2 <acquire>
  for(i = 0; i < n; i++){
    80004bc6:	0b505063          	blez	s5,80004c66 <pipewrite+0xd4>
    80004bca:	8926                	mv	s2,s1
    80004bcc:	fffa8b9b          	addiw	s7,s5,-1
    80004bd0:	1b82                	slli	s7,s7,0x20
    80004bd2:	020bdb93          	srli	s7,s7,0x20
    80004bd6:	001b0793          	addi	a5,s6,1
    80004bda:	9bbe                	add	s7,s7,a5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004bdc:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004be0:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004be4:	5cfd                	li	s9,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004be6:	2184a783          	lw	a5,536(s1)
    80004bea:	21c4a703          	lw	a4,540(s1)
    80004bee:	2007879b          	addiw	a5,a5,512
    80004bf2:	02f71e63          	bne	a4,a5,80004c2e <pipewrite+0x9c>
      if(pi->readopen == 0 || myproc()->killed){
    80004bf6:	2204a783          	lw	a5,544(s1)
    80004bfa:	c3d9                	beqz	a5,80004c80 <pipewrite+0xee>
    80004bfc:	ffffd097          	auipc	ra,0xffffd
    80004c00:	c48080e7          	jalr	-952(ra) # 80001844 <myproc>
    80004c04:	591c                	lw	a5,48(a0)
    80004c06:	efad                	bnez	a5,80004c80 <pipewrite+0xee>
      wakeup(&pi->nread);
    80004c08:	8552                	mv	a0,s4
    80004c0a:	ffffe097          	auipc	ra,0xffffe
    80004c0e:	982080e7          	jalr	-1662(ra) # 8000258c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004c12:	85ca                	mv	a1,s2
    80004c14:	854e                	mv	a0,s3
    80004c16:	ffffd097          	auipc	ra,0xffffd
    80004c1a:	6ac080e7          	jalr	1708(ra) # 800022c2 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004c1e:	2184a783          	lw	a5,536(s1)
    80004c22:	21c4a703          	lw	a4,540(s1)
    80004c26:	2007879b          	addiw	a5,a5,512
    80004c2a:	fcf706e3          	beq	a4,a5,80004bf6 <pipewrite+0x64>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004c2e:	4685                	li	a3,1
    80004c30:	865a                	mv	a2,s6
    80004c32:	f9f40593          	addi	a1,s0,-97
    80004c36:	058c3503          	ld	a0,88(s8)
    80004c3a:	ffffd097          	auipc	ra,0xffffd
    80004c3e:	98a080e7          	jalr	-1654(ra) # 800015c4 <copyin>
    80004c42:	03950263          	beq	a0,s9,80004c66 <pipewrite+0xd4>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004c46:	21c4a783          	lw	a5,540(s1)
    80004c4a:	0017871b          	addiw	a4,a5,1
    80004c4e:	20e4ae23          	sw	a4,540(s1)
    80004c52:	1ff7f793          	andi	a5,a5,511
    80004c56:	97a6                	add	a5,a5,s1
    80004c58:	f9f44703          	lbu	a4,-97(s0)
    80004c5c:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004c60:	0b05                	addi	s6,s6,1
    80004c62:	f97b12e3          	bne	s6,s7,80004be6 <pipewrite+0x54>
  }
  wakeup(&pi->nread);
    80004c66:	21848513          	addi	a0,s1,536
    80004c6a:	ffffe097          	auipc	ra,0xffffe
    80004c6e:	922080e7          	jalr	-1758(ra) # 8000258c <wakeup>
  release(&pi->lock);
    80004c72:	8526                	mv	a0,s1
    80004c74:	ffffc097          	auipc	ra,0xffffc
    80004c78:	eb2080e7          	jalr	-334(ra) # 80000b26 <release>
  return n;
    80004c7c:	8556                	mv	a0,s5
    80004c7e:	a039                	j	80004c8c <pipewrite+0xfa>
        release(&pi->lock);
    80004c80:	8526                	mv	a0,s1
    80004c82:	ffffc097          	auipc	ra,0xffffc
    80004c86:	ea4080e7          	jalr	-348(ra) # 80000b26 <release>
        return -1;
    80004c8a:	557d                	li	a0,-1
}
    80004c8c:	70a6                	ld	ra,104(sp)
    80004c8e:	7406                	ld	s0,96(sp)
    80004c90:	64e6                	ld	s1,88(sp)
    80004c92:	6946                	ld	s2,80(sp)
    80004c94:	69a6                	ld	s3,72(sp)
    80004c96:	6a06                	ld	s4,64(sp)
    80004c98:	7ae2                	ld	s5,56(sp)
    80004c9a:	7b42                	ld	s6,48(sp)
    80004c9c:	7ba2                	ld	s7,40(sp)
    80004c9e:	7c02                	ld	s8,32(sp)
    80004ca0:	6ce2                	ld	s9,24(sp)
    80004ca2:	6165                	addi	sp,sp,112
    80004ca4:	8082                	ret

0000000080004ca6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004ca6:	715d                	addi	sp,sp,-80
    80004ca8:	e486                	sd	ra,72(sp)
    80004caa:	e0a2                	sd	s0,64(sp)
    80004cac:	fc26                	sd	s1,56(sp)
    80004cae:	f84a                	sd	s2,48(sp)
    80004cb0:	f44e                	sd	s3,40(sp)
    80004cb2:	f052                	sd	s4,32(sp)
    80004cb4:	ec56                	sd	s5,24(sp)
    80004cb6:	e85a                	sd	s6,16(sp)
    80004cb8:	0880                	addi	s0,sp,80
    80004cba:	84aa                	mv	s1,a0
    80004cbc:	892e                	mv	s2,a1
    80004cbe:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80004cc0:	ffffd097          	auipc	ra,0xffffd
    80004cc4:	b84080e7          	jalr	-1148(ra) # 80001844 <myproc>
    80004cc8:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80004cca:	8b26                	mv	s6,s1
    80004ccc:	8526                	mv	a0,s1
    80004cce:	ffffc097          	auipc	ra,0xffffc
    80004cd2:	e04080e7          	jalr	-508(ra) # 80000ad2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004cd6:	2184a703          	lw	a4,536(s1)
    80004cda:	21c4a783          	lw	a5,540(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004cde:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ce2:	02f71763          	bne	a4,a5,80004d10 <piperead+0x6a>
    80004ce6:	2244a783          	lw	a5,548(s1)
    80004cea:	c39d                	beqz	a5,80004d10 <piperead+0x6a>
    if(myproc()->killed){
    80004cec:	ffffd097          	auipc	ra,0xffffd
    80004cf0:	b58080e7          	jalr	-1192(ra) # 80001844 <myproc>
    80004cf4:	591c                	lw	a5,48(a0)
    80004cf6:	ebc1                	bnez	a5,80004d86 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004cf8:	85da                	mv	a1,s6
    80004cfa:	854e                	mv	a0,s3
    80004cfc:	ffffd097          	auipc	ra,0xffffd
    80004d00:	5c6080e7          	jalr	1478(ra) # 800022c2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d04:	2184a703          	lw	a4,536(s1)
    80004d08:	21c4a783          	lw	a5,540(s1)
    80004d0c:	fcf70de3          	beq	a4,a5,80004ce6 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d10:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004d12:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d14:	05405363          	blez	s4,80004d5a <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004d18:	2184a783          	lw	a5,536(s1)
    80004d1c:	21c4a703          	lw	a4,540(s1)
    80004d20:	02f70d63          	beq	a4,a5,80004d5a <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004d24:	0017871b          	addiw	a4,a5,1
    80004d28:	20e4ac23          	sw	a4,536(s1)
    80004d2c:	1ff7f793          	andi	a5,a5,511
    80004d30:	97a6                	add	a5,a5,s1
    80004d32:	0187c783          	lbu	a5,24(a5)
    80004d36:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004d3a:	4685                	li	a3,1
    80004d3c:	fbf40613          	addi	a2,s0,-65
    80004d40:	85ca                	mv	a1,s2
    80004d42:	058ab503          	ld	a0,88(s5)
    80004d46:	ffffc097          	auipc	ra,0xffffc
    80004d4a:	7f2080e7          	jalr	2034(ra) # 80001538 <copyout>
    80004d4e:	01650663          	beq	a0,s6,80004d5a <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d52:	2985                	addiw	s3,s3,1
    80004d54:	0905                	addi	s2,s2,1
    80004d56:	fd3a11e3          	bne	s4,s3,80004d18 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004d5a:	21c48513          	addi	a0,s1,540
    80004d5e:	ffffe097          	auipc	ra,0xffffe
    80004d62:	82e080e7          	jalr	-2002(ra) # 8000258c <wakeup>
  release(&pi->lock);
    80004d66:	8526                	mv	a0,s1
    80004d68:	ffffc097          	auipc	ra,0xffffc
    80004d6c:	dbe080e7          	jalr	-578(ra) # 80000b26 <release>
  return i;
}
    80004d70:	854e                	mv	a0,s3
    80004d72:	60a6                	ld	ra,72(sp)
    80004d74:	6406                	ld	s0,64(sp)
    80004d76:	74e2                	ld	s1,56(sp)
    80004d78:	7942                	ld	s2,48(sp)
    80004d7a:	79a2                	ld	s3,40(sp)
    80004d7c:	7a02                	ld	s4,32(sp)
    80004d7e:	6ae2                	ld	s5,24(sp)
    80004d80:	6b42                	ld	s6,16(sp)
    80004d82:	6161                	addi	sp,sp,80
    80004d84:	8082                	ret
      release(&pi->lock);
    80004d86:	8526                	mv	a0,s1
    80004d88:	ffffc097          	auipc	ra,0xffffc
    80004d8c:	d9e080e7          	jalr	-610(ra) # 80000b26 <release>
      return -1;
    80004d90:	59fd                	li	s3,-1
    80004d92:	bff9                	j	80004d70 <piperead+0xca>

0000000080004d94 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004d94:	de010113          	addi	sp,sp,-544
    80004d98:	20113c23          	sd	ra,536(sp)
    80004d9c:	20813823          	sd	s0,528(sp)
    80004da0:	20913423          	sd	s1,520(sp)
    80004da4:	21213023          	sd	s2,512(sp)
    80004da8:	ffce                	sd	s3,504(sp)
    80004daa:	fbd2                	sd	s4,496(sp)
    80004dac:	f7d6                	sd	s5,488(sp)
    80004dae:	f3da                	sd	s6,480(sp)
    80004db0:	efde                	sd	s7,472(sp)
    80004db2:	ebe2                	sd	s8,464(sp)
    80004db4:	e7e6                	sd	s9,456(sp)
    80004db6:	e3ea                	sd	s10,448(sp)
    80004db8:	ff6e                	sd	s11,440(sp)
    80004dba:	1400                	addi	s0,sp,544
    80004dbc:	84aa                	mv	s1,a0
    80004dbe:	dea43823          	sd	a0,-528(s0)
    80004dc2:	deb43c23          	sd	a1,-520(s0)
  uint64 argc, sz, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004dc6:	ffffd097          	auipc	ra,0xffffd
    80004dca:	a7e080e7          	jalr	-1410(ra) # 80001844 <myproc>
    80004dce:	e0a43023          	sd	a0,-512(s0)

  begin_op();
    80004dd2:	fffff097          	auipc	ra,0xfffff
    80004dd6:	44e080e7          	jalr	1102(ra) # 80004220 <begin_op>

  if((ip = namei(path)) == 0){
    80004dda:	8526                	mv	a0,s1
    80004ddc:	fffff097          	auipc	ra,0xfffff
    80004de0:	238080e7          	jalr	568(ra) # 80004014 <namei>
    80004de4:	c93d                	beqz	a0,80004e5a <exec+0xc6>
    80004de6:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004de8:	fffff097          	auipc	ra,0xfffff
    80004dec:	aa2080e7          	jalr	-1374(ra) # 8000388a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004df0:	04000713          	li	a4,64
    80004df4:	4681                	li	a3,0
    80004df6:	e4840613          	addi	a2,s0,-440
    80004dfa:	4581                	li	a1,0
    80004dfc:	8526                	mv	a0,s1
    80004dfe:	fffff097          	auipc	ra,0xfffff
    80004e02:	d1c080e7          	jalr	-740(ra) # 80003b1a <readi>
    80004e06:	04000793          	li	a5,64
    80004e0a:	00f51a63          	bne	a0,a5,80004e1e <exec+0x8a>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004e0e:	e4842703          	lw	a4,-440(s0)
    80004e12:	464c47b7          	lui	a5,0x464c4
    80004e16:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004e1a:	04f70663          	beq	a4,a5,80004e66 <exec+0xd2>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz, p);
  if(ip){
    iunlockput(ip);
    80004e1e:	8526                	mv	a0,s1
    80004e20:	fffff097          	auipc	ra,0xfffff
    80004e24:	ca8080e7          	jalr	-856(ra) # 80003ac8 <iunlockput>
    end_op();
    80004e28:	fffff097          	auipc	ra,0xfffff
    80004e2c:	478080e7          	jalr	1144(ra) # 800042a0 <end_op>
  }
  return -1;
    80004e30:	557d                	li	a0,-1
}
    80004e32:	21813083          	ld	ra,536(sp)
    80004e36:	21013403          	ld	s0,528(sp)
    80004e3a:	20813483          	ld	s1,520(sp)
    80004e3e:	20013903          	ld	s2,512(sp)
    80004e42:	79fe                	ld	s3,504(sp)
    80004e44:	7a5e                	ld	s4,496(sp)
    80004e46:	7abe                	ld	s5,488(sp)
    80004e48:	7b1e                	ld	s6,480(sp)
    80004e4a:	6bfe                	ld	s7,472(sp)
    80004e4c:	6c5e                	ld	s8,464(sp)
    80004e4e:	6cbe                	ld	s9,456(sp)
    80004e50:	6d1e                	ld	s10,448(sp)
    80004e52:	7dfa                	ld	s11,440(sp)
    80004e54:	22010113          	addi	sp,sp,544
    80004e58:	8082                	ret
    end_op();
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	446080e7          	jalr	1094(ra) # 800042a0 <end_op>
    return -1;
    80004e62:	557d                	li	a0,-1
    80004e64:	b7f9                	j	80004e32 <exec+0x9e>
  if((pagetable = proc_pagetable(p)) == 0)
    80004e66:	e0043503          	ld	a0,-512(s0)
    80004e6a:	ffffd097          	auipc	ra,0xffffd
    80004e6e:	a9e080e7          	jalr	-1378(ra) # 80001908 <proc_pagetable>
    80004e72:	8c2a                	mv	s8,a0
    80004e74:	d54d                	beqz	a0,80004e1e <exec+0x8a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e76:	e6842983          	lw	s3,-408(s0)
    80004e7a:	e8045783          	lhu	a5,-384(s0)
    80004e7e:	c7fd                	beqz	a5,80004f6c <exec+0x1d8>
  sz = 0;
    80004e80:	e0043423          	sd	zero,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e84:	4b81                	li	s7,0
    if(ph.vaddr % PGSIZE != 0)
    80004e86:	6b05                	lui	s6,0x1
    80004e88:	fffb0793          	addi	a5,s6,-1 # fff <_entry-0x7ffff001>
    80004e8c:	def43423          	sd	a5,-536(s0)
    80004e90:	a0a5                	j	80004ef8 <exec+0x164>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004e92:	00003517          	auipc	a0,0x3
    80004e96:	86e50513          	addi	a0,a0,-1938 # 80007700 <userret+0x670>
    80004e9a:	ffffb097          	auipc	ra,0xffffb
    80004e9e:	6b4080e7          	jalr	1716(ra) # 8000054e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004ea2:	8756                	mv	a4,s5
    80004ea4:	012d86bb          	addw	a3,s11,s2
    80004ea8:	4581                	li	a1,0
    80004eaa:	8526                	mv	a0,s1
    80004eac:	fffff097          	auipc	ra,0xfffff
    80004eb0:	c6e080e7          	jalr	-914(ra) # 80003b1a <readi>
    80004eb4:	2501                	sext.w	a0,a0
    80004eb6:	10aa9263          	bne	s5,a0,80004fba <exec+0x226>
  for(i = 0; i < sz; i += PGSIZE){
    80004eba:	6785                	lui	a5,0x1
    80004ebc:	0127893b          	addw	s2,a5,s2
    80004ec0:	77fd                	lui	a5,0xfffff
    80004ec2:	01478a3b          	addw	s4,a5,s4
    80004ec6:	03997263          	bgeu	s2,s9,80004eea <exec+0x156>
    pa = walkaddr(pagetable, va + i);
    80004eca:	02091593          	slli	a1,s2,0x20
    80004ece:	9181                	srli	a1,a1,0x20
    80004ed0:	95ea                	add	a1,a1,s10
    80004ed2:	8562                	mv	a0,s8
    80004ed4:	ffffc097          	auipc	ra,0xffffc
    80004ed8:	0aa080e7          	jalr	170(ra) # 80000f7e <walkaddr>
    80004edc:	862a                	mv	a2,a0
    if(pa == 0)
    80004ede:	d955                	beqz	a0,80004e92 <exec+0xfe>
      n = PGSIZE;
    80004ee0:	8ada                	mv	s5,s6
    if(sz - i < PGSIZE)
    80004ee2:	fd6a70e3          	bgeu	s4,s6,80004ea2 <exec+0x10e>
      n = sz - i;
    80004ee6:	8ad2                	mv	s5,s4
    80004ee8:	bf6d                	j	80004ea2 <exec+0x10e>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004eea:	2b85                	addiw	s7,s7,1
    80004eec:	0389899b          	addiw	s3,s3,56
    80004ef0:	e8045783          	lhu	a5,-384(s0)
    80004ef4:	06fbde63          	bge	s7,a5,80004f70 <exec+0x1dc>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004ef8:	2981                	sext.w	s3,s3
    80004efa:	03800713          	li	a4,56
    80004efe:	86ce                	mv	a3,s3
    80004f00:	e1040613          	addi	a2,s0,-496
    80004f04:	4581                	li	a1,0
    80004f06:	8526                	mv	a0,s1
    80004f08:	fffff097          	auipc	ra,0xfffff
    80004f0c:	c12080e7          	jalr	-1006(ra) # 80003b1a <readi>
    80004f10:	03800793          	li	a5,56
    80004f14:	0af51363          	bne	a0,a5,80004fba <exec+0x226>
    if(ph.type != ELF_PROG_LOAD)
    80004f18:	e1042783          	lw	a5,-496(s0)
    80004f1c:	4705                	li	a4,1
    80004f1e:	fce796e3          	bne	a5,a4,80004eea <exec+0x156>
    if(ph.memsz < ph.filesz)
    80004f22:	e3843603          	ld	a2,-456(s0)
    80004f26:	e3043783          	ld	a5,-464(s0)
    80004f2a:	08f66863          	bltu	a2,a5,80004fba <exec+0x226>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004f2e:	e2043783          	ld	a5,-480(s0)
    80004f32:	963e                	add	a2,a2,a5
    80004f34:	08f66363          	bltu	a2,a5,80004fba <exec+0x226>
    if((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004f38:	e0843583          	ld	a1,-504(s0)
    80004f3c:	8562                	mv	a0,s8
    80004f3e:	ffffc097          	auipc	ra,0xffffc
    80004f42:	420080e7          	jalr	1056(ra) # 8000135e <uvmalloc>
    80004f46:	e0a43423          	sd	a0,-504(s0)
    80004f4a:	c925                	beqz	a0,80004fba <exec+0x226>
    if(ph.vaddr % PGSIZE != 0)
    80004f4c:	e2043d03          	ld	s10,-480(s0)
    80004f50:	de843783          	ld	a5,-536(s0)
    80004f54:	00fd77b3          	and	a5,s10,a5
    80004f58:	e3ad                	bnez	a5,80004fba <exec+0x226>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004f5a:	e1842d83          	lw	s11,-488(s0)
    80004f5e:	e3042c83          	lw	s9,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004f62:	f80c84e3          	beqz	s9,80004eea <exec+0x156>
    80004f66:	8a66                	mv	s4,s9
    80004f68:	4901                	li	s2,0
    80004f6a:	b785                	j	80004eca <exec+0x136>
  sz = 0;
    80004f6c:	e0043423          	sd	zero,-504(s0)
  iunlockput(ip);
    80004f70:	8526                	mv	a0,s1
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	b56080e7          	jalr	-1194(ra) # 80003ac8 <iunlockput>
  end_op();
    80004f7a:	fffff097          	auipc	ra,0xfffff
    80004f7e:	326080e7          	jalr	806(ra) # 800042a0 <end_op>
  p = myproc();
    80004f82:	ffffd097          	auipc	ra,0xffffd
    80004f86:	8c2080e7          	jalr	-1854(ra) # 80001844 <myproc>
    80004f8a:	e0a43023          	sd	a0,-512(s0)
  uint64 oldsz = p->sz;
    80004f8e:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    80004f92:	6585                	lui	a1,0x1
    80004f94:	15fd                	addi	a1,a1,-1
    80004f96:	e0843783          	ld	a5,-504(s0)
    80004f9a:	00b78b33          	add	s6,a5,a1
    80004f9e:	75fd                	lui	a1,0xfffff
    80004fa0:	00bb75b3          	and	a1,s6,a1
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004fa4:	6609                	lui	a2,0x2
    80004fa6:	962e                	add	a2,a2,a1
    80004fa8:	8562                	mv	a0,s8
    80004faa:	ffffc097          	auipc	ra,0xffffc
    80004fae:	3b4080e7          	jalr	948(ra) # 8000135e <uvmalloc>
    80004fb2:	e0a43423          	sd	a0,-504(s0)
  ip = 0;
    80004fb6:	4481                	li	s1,0
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004fb8:	ed11                	bnez	a0,80004fd4 <exec+0x240>
    proc_freepagetable(pagetable, sz, p);
    80004fba:	e0043603          	ld	a2,-512(s0)
    80004fbe:	e0843583          	ld	a1,-504(s0)
    80004fc2:	8562                	mv	a0,s8
    80004fc4:	ffffd097          	auipc	ra,0xffffd
    80004fc8:	a62080e7          	jalr	-1438(ra) # 80001a26 <proc_freepagetable>
  if(ip){
    80004fcc:	e40499e3          	bnez	s1,80004e1e <exec+0x8a>
  return -1;
    80004fd0:	557d                	li	a0,-1
    80004fd2:	b585                	j	80004e32 <exec+0x9e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004fd4:	75f9                	lui	a1,0xffffe
    80004fd6:	84aa                	mv	s1,a0
    80004fd8:	95aa                	add	a1,a1,a0
    80004fda:	8562                	mv	a0,s8
    80004fdc:	ffffc097          	auipc	ra,0xffffc
    80004fe0:	52a080e7          	jalr	1322(ra) # 80001506 <uvmclear>
  stackbase = sp - PGSIZE;
    80004fe4:	7afd                	lui	s5,0xfffff
    80004fe6:	9aa6                	add	s5,s5,s1
  for(argc = 0; argv[argc]; argc++) {
    80004fe8:	df843783          	ld	a5,-520(s0)
    80004fec:	6388                	ld	a0,0(a5)
    80004fee:	c135                	beqz	a0,80005052 <exec+0x2be>
    80004ff0:	e8840993          	addi	s3,s0,-376
    80004ff4:	f8840b93          	addi	s7,s0,-120
    80004ff8:	4901                	li	s2,0
    sp -= strlen(argv[argc]) + 1;
    80004ffa:	ffffc097          	auipc	ra,0xffffc
    80004ffe:	cfc080e7          	jalr	-772(ra) # 80000cf6 <strlen>
    80005002:	2505                	addiw	a0,a0,1
    80005004:	8c89                	sub	s1,s1,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005006:	98c1                	andi	s1,s1,-16
    if(sp < stackbase)
    80005008:	0f54ea63          	bltu	s1,s5,800050fc <exec+0x368>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000500c:	df843b03          	ld	s6,-520(s0)
    80005010:	000b3a03          	ld	s4,0(s6)
    80005014:	8552                	mv	a0,s4
    80005016:	ffffc097          	auipc	ra,0xffffc
    8000501a:	ce0080e7          	jalr	-800(ra) # 80000cf6 <strlen>
    8000501e:	0015069b          	addiw	a3,a0,1
    80005022:	8652                	mv	a2,s4
    80005024:	85a6                	mv	a1,s1
    80005026:	8562                	mv	a0,s8
    80005028:	ffffc097          	auipc	ra,0xffffc
    8000502c:	510080e7          	jalr	1296(ra) # 80001538 <copyout>
    80005030:	0c054863          	bltz	a0,80005100 <exec+0x36c>
    ustack[argc] = sp;
    80005034:	0099b023          	sd	s1,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005038:	0905                	addi	s2,s2,1
    8000503a:	008b0793          	addi	a5,s6,8
    8000503e:	def43c23          	sd	a5,-520(s0)
    80005042:	008b3503          	ld	a0,8(s6)
    80005046:	c909                	beqz	a0,80005058 <exec+0x2c4>
    if(argc >= MAXARG)
    80005048:	09a1                	addi	s3,s3,8
    8000504a:	fb3b98e3          	bne	s7,s3,80004ffa <exec+0x266>
  ip = 0;
    8000504e:	4481                	li	s1,0
    80005050:	b7ad                	j	80004fba <exec+0x226>
  sp = sz;
    80005052:	e0843483          	ld	s1,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005056:	4901                	li	s2,0
  ustack[argc] = 0;
    80005058:	00391793          	slli	a5,s2,0x3
    8000505c:	f9040713          	addi	a4,s0,-112
    80005060:	97ba                	add	a5,a5,a4
    80005062:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd8edc>
  sp -= (argc+1) * sizeof(uint64);
    80005066:	00190693          	addi	a3,s2,1
    8000506a:	068e                	slli	a3,a3,0x3
    8000506c:	8c95                	sub	s1,s1,a3
  sp -= sp % 16;
    8000506e:	ff04f993          	andi	s3,s1,-16
  ip = 0;
    80005072:	4481                	li	s1,0
  if(sp < stackbase)
    80005074:	f559e3e3          	bltu	s3,s5,80004fba <exec+0x226>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005078:	e8840613          	addi	a2,s0,-376
    8000507c:	85ce                	mv	a1,s3
    8000507e:	8562                	mv	a0,s8
    80005080:	ffffc097          	auipc	ra,0xffffc
    80005084:	4b8080e7          	jalr	1208(ra) # 80001538 <copyout>
    80005088:	06054e63          	bltz	a0,80005104 <exec+0x370>
  p->tf->a1 = sp;
    8000508c:	e0043783          	ld	a5,-512(s0)
    80005090:	73bc                	ld	a5,96(a5)
    80005092:	0737bc23          	sd	s3,120(a5)
  for(last=s=path; *s; s++)
    80005096:	df043783          	ld	a5,-528(s0)
    8000509a:	0007c703          	lbu	a4,0(a5)
    8000509e:	cf11                	beqz	a4,800050ba <exec+0x326>
    800050a0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800050a2:	02f00693          	li	a3,47
    800050a6:	a029                	j	800050b0 <exec+0x31c>
  for(last=s=path; *s; s++)
    800050a8:	0785                	addi	a5,a5,1
    800050aa:	fff7c703          	lbu	a4,-1(a5)
    800050ae:	c711                	beqz	a4,800050ba <exec+0x326>
    if(*s == '/')
    800050b0:	fed71ce3          	bne	a4,a3,800050a8 <exec+0x314>
      last = s+1;
    800050b4:	def43823          	sd	a5,-528(s0)
    800050b8:	bfc5                	j	800050a8 <exec+0x314>
  safestrcpy(p->name, last, sizeof(p->name));
    800050ba:	4641                	li	a2,16
    800050bc:	df043583          	ld	a1,-528(s0)
    800050c0:	e0043483          	ld	s1,-512(s0)
    800050c4:	16048513          	addi	a0,s1,352
    800050c8:	ffffc097          	auipc	ra,0xffffc
    800050cc:	bfc080e7          	jalr	-1028(ra) # 80000cc4 <safestrcpy>
  oldpagetable = p->pagetable;
    800050d0:	8626                	mv	a2,s1
    800050d2:	6ca8                	ld	a0,88(s1)
  p->pagetable = pagetable;
    800050d4:	0584bc23          	sd	s8,88(s1)
  p->sz = sz;
    800050d8:	e0843703          	ld	a4,-504(s0)
    800050dc:	e8b8                	sd	a4,80(s1)
  p->tf->epc = elf.entry;  // initial program counter = main
    800050de:	70bc                	ld	a5,96(s1)
    800050e0:	e6043703          	ld	a4,-416(s0)
    800050e4:	ef98                	sd	a4,24(a5)
  p->tf->sp = sp; // initial stack pointer
    800050e6:	70bc                	ld	a5,96(s1)
    800050e8:	0337b823          	sd	s3,48(a5)
  proc_freepagetable(oldpagetable, oldsz, p);
    800050ec:	85e6                	mv	a1,s9
    800050ee:	ffffd097          	auipc	ra,0xffffd
    800050f2:	938080e7          	jalr	-1736(ra) # 80001a26 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800050f6:	0009051b          	sext.w	a0,s2
    800050fa:	bb25                	j	80004e32 <exec+0x9e>
  ip = 0;
    800050fc:	4481                	li	s1,0
    800050fe:	bd75                	j	80004fba <exec+0x226>
    80005100:	4481                	li	s1,0
    80005102:	bd65                	j	80004fba <exec+0x226>
    80005104:	4481                	li	s1,0
    80005106:	bd55                	j	80004fba <exec+0x226>

0000000080005108 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005108:	7179                	addi	sp,sp,-48
    8000510a:	f406                	sd	ra,40(sp)
    8000510c:	f022                	sd	s0,32(sp)
    8000510e:	ec26                	sd	s1,24(sp)
    80005110:	e84a                	sd	s2,16(sp)
    80005112:	1800                	addi	s0,sp,48
    80005114:	892e                	mv	s2,a1
    80005116:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005118:	fdc40593          	addi	a1,s0,-36
    8000511c:	ffffe097          	auipc	ra,0xffffe
    80005120:	bee080e7          	jalr	-1042(ra) # 80002d0a <argint>
    80005124:	04054063          	bltz	a0,80005164 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005128:	fdc42703          	lw	a4,-36(s0)
    8000512c:	47bd                	li	a5,15
    8000512e:	02e7ed63          	bltu	a5,a4,80005168 <argfd+0x60>
    80005132:	ffffc097          	auipc	ra,0xffffc
    80005136:	712080e7          	jalr	1810(ra) # 80001844 <myproc>
    8000513a:	fdc42703          	lw	a4,-36(s0)
    8000513e:	01a70793          	addi	a5,a4,26
    80005142:	078e                	slli	a5,a5,0x3
    80005144:	953e                	add	a0,a0,a5
    80005146:	651c                	ld	a5,8(a0)
    80005148:	c395                	beqz	a5,8000516c <argfd+0x64>
    return -1;
  if(pfd)
    8000514a:	00090463          	beqz	s2,80005152 <argfd+0x4a>
    *pfd = fd;
    8000514e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005152:	4501                	li	a0,0
  if(pf)
    80005154:	c091                	beqz	s1,80005158 <argfd+0x50>
    *pf = f;
    80005156:	e09c                	sd	a5,0(s1)
}
    80005158:	70a2                	ld	ra,40(sp)
    8000515a:	7402                	ld	s0,32(sp)
    8000515c:	64e2                	ld	s1,24(sp)
    8000515e:	6942                	ld	s2,16(sp)
    80005160:	6145                	addi	sp,sp,48
    80005162:	8082                	ret
    return -1;
    80005164:	557d                	li	a0,-1
    80005166:	bfcd                	j	80005158 <argfd+0x50>
    return -1;
    80005168:	557d                	li	a0,-1
    8000516a:	b7fd                	j	80005158 <argfd+0x50>
    8000516c:	557d                	li	a0,-1
    8000516e:	b7ed                	j	80005158 <argfd+0x50>

0000000080005170 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005170:	1101                	addi	sp,sp,-32
    80005172:	ec06                	sd	ra,24(sp)
    80005174:	e822                	sd	s0,16(sp)
    80005176:	e426                	sd	s1,8(sp)
    80005178:	1000                	addi	s0,sp,32
    8000517a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000517c:	ffffc097          	auipc	ra,0xffffc
    80005180:	6c8080e7          	jalr	1736(ra) # 80001844 <myproc>
    80005184:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005186:	0d850793          	addi	a5,a0,216
    8000518a:	4501                	li	a0,0
    8000518c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000518e:	6398                	ld	a4,0(a5)
    80005190:	cb19                	beqz	a4,800051a6 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005192:	2505                	addiw	a0,a0,1
    80005194:	07a1                	addi	a5,a5,8
    80005196:	fed51ce3          	bne	a0,a3,8000518e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000519a:	557d                	li	a0,-1
}
    8000519c:	60e2                	ld	ra,24(sp)
    8000519e:	6442                	ld	s0,16(sp)
    800051a0:	64a2                	ld	s1,8(sp)
    800051a2:	6105                	addi	sp,sp,32
    800051a4:	8082                	ret
      p->ofile[fd] = f;
    800051a6:	01a50793          	addi	a5,a0,26
    800051aa:	078e                	slli	a5,a5,0x3
    800051ac:	963e                	add	a2,a2,a5
    800051ae:	e604                	sd	s1,8(a2)
      return fd;
    800051b0:	b7f5                	j	8000519c <fdalloc+0x2c>

00000000800051b2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800051b2:	715d                	addi	sp,sp,-80
    800051b4:	e486                	sd	ra,72(sp)
    800051b6:	e0a2                	sd	s0,64(sp)
    800051b8:	fc26                	sd	s1,56(sp)
    800051ba:	f84a                	sd	s2,48(sp)
    800051bc:	f44e                	sd	s3,40(sp)
    800051be:	f052                	sd	s4,32(sp)
    800051c0:	ec56                	sd	s5,24(sp)
    800051c2:	0880                	addi	s0,sp,80
    800051c4:	89ae                	mv	s3,a1
    800051c6:	8ab2                	mv	s5,a2
    800051c8:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800051ca:	fb040593          	addi	a1,s0,-80
    800051ce:	fffff097          	auipc	ra,0xfffff
    800051d2:	e64080e7          	jalr	-412(ra) # 80004032 <nameiparent>
    800051d6:	892a                	mv	s2,a0
    800051d8:	12050e63          	beqz	a0,80005314 <create+0x162>
    return 0;

  ilock(dp);
    800051dc:	ffffe097          	auipc	ra,0xffffe
    800051e0:	6ae080e7          	jalr	1710(ra) # 8000388a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800051e4:	4601                	li	a2,0
    800051e6:	fb040593          	addi	a1,s0,-80
    800051ea:	854a                	mv	a0,s2
    800051ec:	fffff097          	auipc	ra,0xfffff
    800051f0:	b56080e7          	jalr	-1194(ra) # 80003d42 <dirlookup>
    800051f4:	84aa                	mv	s1,a0
    800051f6:	c921                	beqz	a0,80005246 <create+0x94>
    iunlockput(dp);
    800051f8:	854a                	mv	a0,s2
    800051fa:	fffff097          	auipc	ra,0xfffff
    800051fe:	8ce080e7          	jalr	-1842(ra) # 80003ac8 <iunlockput>
    ilock(ip);
    80005202:	8526                	mv	a0,s1
    80005204:	ffffe097          	auipc	ra,0xffffe
    80005208:	686080e7          	jalr	1670(ra) # 8000388a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000520c:	2981                	sext.w	s3,s3
    8000520e:	4789                	li	a5,2
    80005210:	02f99463          	bne	s3,a5,80005238 <create+0x86>
    80005214:	0444d783          	lhu	a5,68(s1)
    80005218:	37f9                	addiw	a5,a5,-2
    8000521a:	17c2                	slli	a5,a5,0x30
    8000521c:	93c1                	srli	a5,a5,0x30
    8000521e:	4705                	li	a4,1
    80005220:	00f76c63          	bltu	a4,a5,80005238 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005224:	8526                	mv	a0,s1
    80005226:	60a6                	ld	ra,72(sp)
    80005228:	6406                	ld	s0,64(sp)
    8000522a:	74e2                	ld	s1,56(sp)
    8000522c:	7942                	ld	s2,48(sp)
    8000522e:	79a2                	ld	s3,40(sp)
    80005230:	7a02                	ld	s4,32(sp)
    80005232:	6ae2                	ld	s5,24(sp)
    80005234:	6161                	addi	sp,sp,80
    80005236:	8082                	ret
    iunlockput(ip);
    80005238:	8526                	mv	a0,s1
    8000523a:	fffff097          	auipc	ra,0xfffff
    8000523e:	88e080e7          	jalr	-1906(ra) # 80003ac8 <iunlockput>
    return 0;
    80005242:	4481                	li	s1,0
    80005244:	b7c5                	j	80005224 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005246:	85ce                	mv	a1,s3
    80005248:	00092503          	lw	a0,0(s2)
    8000524c:	ffffe097          	auipc	ra,0xffffe
    80005250:	4a6080e7          	jalr	1190(ra) # 800036f2 <ialloc>
    80005254:	84aa                	mv	s1,a0
    80005256:	c521                	beqz	a0,8000529e <create+0xec>
  ilock(ip);
    80005258:	ffffe097          	auipc	ra,0xffffe
    8000525c:	632080e7          	jalr	1586(ra) # 8000388a <ilock>
  ip->major = major;
    80005260:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005264:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005268:	4a05                	li	s4,1
    8000526a:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000526e:	8526                	mv	a0,s1
    80005270:	ffffe097          	auipc	ra,0xffffe
    80005274:	550080e7          	jalr	1360(ra) # 800037c0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005278:	2981                	sext.w	s3,s3
    8000527a:	03498a63          	beq	s3,s4,800052ae <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000527e:	40d0                	lw	a2,4(s1)
    80005280:	fb040593          	addi	a1,s0,-80
    80005284:	854a                	mv	a0,s2
    80005286:	fffff097          	auipc	ra,0xfffff
    8000528a:	ccc080e7          	jalr	-820(ra) # 80003f52 <dirlink>
    8000528e:	06054b63          	bltz	a0,80005304 <create+0x152>
  iunlockput(dp);
    80005292:	854a                	mv	a0,s2
    80005294:	fffff097          	auipc	ra,0xfffff
    80005298:	834080e7          	jalr	-1996(ra) # 80003ac8 <iunlockput>
  return ip;
    8000529c:	b761                	j	80005224 <create+0x72>
    panic("create: ialloc");
    8000529e:	00002517          	auipc	a0,0x2
    800052a2:	48250513          	addi	a0,a0,1154 # 80007720 <userret+0x690>
    800052a6:	ffffb097          	auipc	ra,0xffffb
    800052aa:	2a8080e7          	jalr	680(ra) # 8000054e <panic>
    dp->nlink++;  // for ".."
    800052ae:	04a95783          	lhu	a5,74(s2)
    800052b2:	2785                	addiw	a5,a5,1
    800052b4:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800052b8:	854a                	mv	a0,s2
    800052ba:	ffffe097          	auipc	ra,0xffffe
    800052be:	506080e7          	jalr	1286(ra) # 800037c0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800052c2:	40d0                	lw	a2,4(s1)
    800052c4:	00002597          	auipc	a1,0x2
    800052c8:	46c58593          	addi	a1,a1,1132 # 80007730 <userret+0x6a0>
    800052cc:	8526                	mv	a0,s1
    800052ce:	fffff097          	auipc	ra,0xfffff
    800052d2:	c84080e7          	jalr	-892(ra) # 80003f52 <dirlink>
    800052d6:	00054f63          	bltz	a0,800052f4 <create+0x142>
    800052da:	00492603          	lw	a2,4(s2)
    800052de:	00002597          	auipc	a1,0x2
    800052e2:	45a58593          	addi	a1,a1,1114 # 80007738 <userret+0x6a8>
    800052e6:	8526                	mv	a0,s1
    800052e8:	fffff097          	auipc	ra,0xfffff
    800052ec:	c6a080e7          	jalr	-918(ra) # 80003f52 <dirlink>
    800052f0:	f80557e3          	bgez	a0,8000527e <create+0xcc>
      panic("create dots");
    800052f4:	00002517          	auipc	a0,0x2
    800052f8:	44c50513          	addi	a0,a0,1100 # 80007740 <userret+0x6b0>
    800052fc:	ffffb097          	auipc	ra,0xffffb
    80005300:	252080e7          	jalr	594(ra) # 8000054e <panic>
    panic("create: dirlink");
    80005304:	00002517          	auipc	a0,0x2
    80005308:	44c50513          	addi	a0,a0,1100 # 80007750 <userret+0x6c0>
    8000530c:	ffffb097          	auipc	ra,0xffffb
    80005310:	242080e7          	jalr	578(ra) # 8000054e <panic>
    return 0;
    80005314:	84aa                	mv	s1,a0
    80005316:	b739                	j	80005224 <create+0x72>

0000000080005318 <sys_dup>:
{
    80005318:	7179                	addi	sp,sp,-48
    8000531a:	f406                	sd	ra,40(sp)
    8000531c:	f022                	sd	s0,32(sp)
    8000531e:	ec26                	sd	s1,24(sp)
    80005320:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005322:	fd840613          	addi	a2,s0,-40
    80005326:	4581                	li	a1,0
    80005328:	4501                	li	a0,0
    8000532a:	00000097          	auipc	ra,0x0
    8000532e:	dde080e7          	jalr	-546(ra) # 80005108 <argfd>
    return -1;
    80005332:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005334:	02054363          	bltz	a0,8000535a <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005338:	fd843503          	ld	a0,-40(s0)
    8000533c:	00000097          	auipc	ra,0x0
    80005340:	e34080e7          	jalr	-460(ra) # 80005170 <fdalloc>
    80005344:	84aa                	mv	s1,a0
    return -1;
    80005346:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005348:	00054963          	bltz	a0,8000535a <sys_dup+0x42>
  filedup(f);
    8000534c:	fd843503          	ld	a0,-40(s0)
    80005350:	fffff097          	auipc	ra,0xfffff
    80005354:	350080e7          	jalr	848(ra) # 800046a0 <filedup>
  return fd;
    80005358:	87a6                	mv	a5,s1
}
    8000535a:	853e                	mv	a0,a5
    8000535c:	70a2                	ld	ra,40(sp)
    8000535e:	7402                	ld	s0,32(sp)
    80005360:	64e2                	ld	s1,24(sp)
    80005362:	6145                	addi	sp,sp,48
    80005364:	8082                	ret

0000000080005366 <sys_read>:
{
    80005366:	7179                	addi	sp,sp,-48
    80005368:	f406                	sd	ra,40(sp)
    8000536a:	f022                	sd	s0,32(sp)
    8000536c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000536e:	fe840613          	addi	a2,s0,-24
    80005372:	4581                	li	a1,0
    80005374:	4501                	li	a0,0
    80005376:	00000097          	auipc	ra,0x0
    8000537a:	d92080e7          	jalr	-622(ra) # 80005108 <argfd>
    return -1;
    8000537e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005380:	04054163          	bltz	a0,800053c2 <sys_read+0x5c>
    80005384:	fe440593          	addi	a1,s0,-28
    80005388:	4509                	li	a0,2
    8000538a:	ffffe097          	auipc	ra,0xffffe
    8000538e:	980080e7          	jalr	-1664(ra) # 80002d0a <argint>
    return -1;
    80005392:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005394:	02054763          	bltz	a0,800053c2 <sys_read+0x5c>
    80005398:	fd840593          	addi	a1,s0,-40
    8000539c:	4505                	li	a0,1
    8000539e:	ffffe097          	auipc	ra,0xffffe
    800053a2:	98e080e7          	jalr	-1650(ra) # 80002d2c <argaddr>
    return -1;
    800053a6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800053a8:	00054d63          	bltz	a0,800053c2 <sys_read+0x5c>
  return fileread(f, p, n);
    800053ac:	fe442603          	lw	a2,-28(s0)
    800053b0:	fd843583          	ld	a1,-40(s0)
    800053b4:	fe843503          	ld	a0,-24(s0)
    800053b8:	fffff097          	auipc	ra,0xfffff
    800053bc:	474080e7          	jalr	1140(ra) # 8000482c <fileread>
    800053c0:	87aa                	mv	a5,a0
}
    800053c2:	853e                	mv	a0,a5
    800053c4:	70a2                	ld	ra,40(sp)
    800053c6:	7402                	ld	s0,32(sp)
    800053c8:	6145                	addi	sp,sp,48
    800053ca:	8082                	ret

00000000800053cc <sys_write>:
{
    800053cc:	7179                	addi	sp,sp,-48
    800053ce:	f406                	sd	ra,40(sp)
    800053d0:	f022                	sd	s0,32(sp)
    800053d2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800053d4:	fe840613          	addi	a2,s0,-24
    800053d8:	4581                	li	a1,0
    800053da:	4501                	li	a0,0
    800053dc:	00000097          	auipc	ra,0x0
    800053e0:	d2c080e7          	jalr	-724(ra) # 80005108 <argfd>
    return -1;
    800053e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800053e6:	04054163          	bltz	a0,80005428 <sys_write+0x5c>
    800053ea:	fe440593          	addi	a1,s0,-28
    800053ee:	4509                	li	a0,2
    800053f0:	ffffe097          	auipc	ra,0xffffe
    800053f4:	91a080e7          	jalr	-1766(ra) # 80002d0a <argint>
    return -1;
    800053f8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800053fa:	02054763          	bltz	a0,80005428 <sys_write+0x5c>
    800053fe:	fd840593          	addi	a1,s0,-40
    80005402:	4505                	li	a0,1
    80005404:	ffffe097          	auipc	ra,0xffffe
    80005408:	928080e7          	jalr	-1752(ra) # 80002d2c <argaddr>
    return -1;
    8000540c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000540e:	00054d63          	bltz	a0,80005428 <sys_write+0x5c>
  return filewrite(f, p, n);
    80005412:	fe442603          	lw	a2,-28(s0)
    80005416:	fd843583          	ld	a1,-40(s0)
    8000541a:	fe843503          	ld	a0,-24(s0)
    8000541e:	fffff097          	auipc	ra,0xfffff
    80005422:	4d0080e7          	jalr	1232(ra) # 800048ee <filewrite>
    80005426:	87aa                	mv	a5,a0
}
    80005428:	853e                	mv	a0,a5
    8000542a:	70a2                	ld	ra,40(sp)
    8000542c:	7402                	ld	s0,32(sp)
    8000542e:	6145                	addi	sp,sp,48
    80005430:	8082                	ret

0000000080005432 <sys_close>:
{
    80005432:	1101                	addi	sp,sp,-32
    80005434:	ec06                	sd	ra,24(sp)
    80005436:	e822                	sd	s0,16(sp)
    80005438:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000543a:	fe040613          	addi	a2,s0,-32
    8000543e:	fec40593          	addi	a1,s0,-20
    80005442:	4501                	li	a0,0
    80005444:	00000097          	auipc	ra,0x0
    80005448:	cc4080e7          	jalr	-828(ra) # 80005108 <argfd>
    return -1;
    8000544c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000544e:	02054463          	bltz	a0,80005476 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005452:	ffffc097          	auipc	ra,0xffffc
    80005456:	3f2080e7          	jalr	1010(ra) # 80001844 <myproc>
    8000545a:	fec42783          	lw	a5,-20(s0)
    8000545e:	07e9                	addi	a5,a5,26
    80005460:	078e                	slli	a5,a5,0x3
    80005462:	97aa                	add	a5,a5,a0
    80005464:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    80005468:	fe043503          	ld	a0,-32(s0)
    8000546c:	fffff097          	auipc	ra,0xfffff
    80005470:	286080e7          	jalr	646(ra) # 800046f2 <fileclose>
  return 0;
    80005474:	4781                	li	a5,0
}
    80005476:	853e                	mv	a0,a5
    80005478:	60e2                	ld	ra,24(sp)
    8000547a:	6442                	ld	s0,16(sp)
    8000547c:	6105                	addi	sp,sp,32
    8000547e:	8082                	ret

0000000080005480 <sys_fstat>:
{
    80005480:	1101                	addi	sp,sp,-32
    80005482:	ec06                	sd	ra,24(sp)
    80005484:	e822                	sd	s0,16(sp)
    80005486:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005488:	fe840613          	addi	a2,s0,-24
    8000548c:	4581                	li	a1,0
    8000548e:	4501                	li	a0,0
    80005490:	00000097          	auipc	ra,0x0
    80005494:	c78080e7          	jalr	-904(ra) # 80005108 <argfd>
    return -1;
    80005498:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000549a:	02054563          	bltz	a0,800054c4 <sys_fstat+0x44>
    8000549e:	fe040593          	addi	a1,s0,-32
    800054a2:	4505                	li	a0,1
    800054a4:	ffffe097          	auipc	ra,0xffffe
    800054a8:	888080e7          	jalr	-1912(ra) # 80002d2c <argaddr>
    return -1;
    800054ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800054ae:	00054b63          	bltz	a0,800054c4 <sys_fstat+0x44>
  return filestat(f, st);
    800054b2:	fe043583          	ld	a1,-32(s0)
    800054b6:	fe843503          	ld	a0,-24(s0)
    800054ba:	fffff097          	auipc	ra,0xfffff
    800054be:	300080e7          	jalr	768(ra) # 800047ba <filestat>
    800054c2:	87aa                	mv	a5,a0
}
    800054c4:	853e                	mv	a0,a5
    800054c6:	60e2                	ld	ra,24(sp)
    800054c8:	6442                	ld	s0,16(sp)
    800054ca:	6105                	addi	sp,sp,32
    800054cc:	8082                	ret

00000000800054ce <sys_link>:
{
    800054ce:	7169                	addi	sp,sp,-304
    800054d0:	f606                	sd	ra,296(sp)
    800054d2:	f222                	sd	s0,288(sp)
    800054d4:	ee26                	sd	s1,280(sp)
    800054d6:	ea4a                	sd	s2,272(sp)
    800054d8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800054da:	08000613          	li	a2,128
    800054de:	ed040593          	addi	a1,s0,-304
    800054e2:	4501                	li	a0,0
    800054e4:	ffffe097          	auipc	ra,0xffffe
    800054e8:	86a080e7          	jalr	-1942(ra) # 80002d4e <argstr>
    return -1;
    800054ec:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800054ee:	10054e63          	bltz	a0,8000560a <sys_link+0x13c>
    800054f2:	08000613          	li	a2,128
    800054f6:	f5040593          	addi	a1,s0,-176
    800054fa:	4505                	li	a0,1
    800054fc:	ffffe097          	auipc	ra,0xffffe
    80005500:	852080e7          	jalr	-1966(ra) # 80002d4e <argstr>
    return -1;
    80005504:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005506:	10054263          	bltz	a0,8000560a <sys_link+0x13c>
  begin_op();
    8000550a:	fffff097          	auipc	ra,0xfffff
    8000550e:	d16080e7          	jalr	-746(ra) # 80004220 <begin_op>
  if((ip = namei(old)) == 0){
    80005512:	ed040513          	addi	a0,s0,-304
    80005516:	fffff097          	auipc	ra,0xfffff
    8000551a:	afe080e7          	jalr	-1282(ra) # 80004014 <namei>
    8000551e:	84aa                	mv	s1,a0
    80005520:	c551                	beqz	a0,800055ac <sys_link+0xde>
  ilock(ip);
    80005522:	ffffe097          	auipc	ra,0xffffe
    80005526:	368080e7          	jalr	872(ra) # 8000388a <ilock>
  if(ip->type == T_DIR){
    8000552a:	04449703          	lh	a4,68(s1)
    8000552e:	4785                	li	a5,1
    80005530:	08f70463          	beq	a4,a5,800055b8 <sys_link+0xea>
  ip->nlink++;
    80005534:	04a4d783          	lhu	a5,74(s1)
    80005538:	2785                	addiw	a5,a5,1
    8000553a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000553e:	8526                	mv	a0,s1
    80005540:	ffffe097          	auipc	ra,0xffffe
    80005544:	280080e7          	jalr	640(ra) # 800037c0 <iupdate>
  iunlock(ip);
    80005548:	8526                	mv	a0,s1
    8000554a:	ffffe097          	auipc	ra,0xffffe
    8000554e:	402080e7          	jalr	1026(ra) # 8000394c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005552:	fd040593          	addi	a1,s0,-48
    80005556:	f5040513          	addi	a0,s0,-176
    8000555a:	fffff097          	auipc	ra,0xfffff
    8000555e:	ad8080e7          	jalr	-1320(ra) # 80004032 <nameiparent>
    80005562:	892a                	mv	s2,a0
    80005564:	c935                	beqz	a0,800055d8 <sys_link+0x10a>
  ilock(dp);
    80005566:	ffffe097          	auipc	ra,0xffffe
    8000556a:	324080e7          	jalr	804(ra) # 8000388a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000556e:	00092703          	lw	a4,0(s2)
    80005572:	409c                	lw	a5,0(s1)
    80005574:	04f71d63          	bne	a4,a5,800055ce <sys_link+0x100>
    80005578:	40d0                	lw	a2,4(s1)
    8000557a:	fd040593          	addi	a1,s0,-48
    8000557e:	854a                	mv	a0,s2
    80005580:	fffff097          	auipc	ra,0xfffff
    80005584:	9d2080e7          	jalr	-1582(ra) # 80003f52 <dirlink>
    80005588:	04054363          	bltz	a0,800055ce <sys_link+0x100>
  iunlockput(dp);
    8000558c:	854a                	mv	a0,s2
    8000558e:	ffffe097          	auipc	ra,0xffffe
    80005592:	53a080e7          	jalr	1338(ra) # 80003ac8 <iunlockput>
  iput(ip);
    80005596:	8526                	mv	a0,s1
    80005598:	ffffe097          	auipc	ra,0xffffe
    8000559c:	400080e7          	jalr	1024(ra) # 80003998 <iput>
  end_op();
    800055a0:	fffff097          	auipc	ra,0xfffff
    800055a4:	d00080e7          	jalr	-768(ra) # 800042a0 <end_op>
  return 0;
    800055a8:	4781                	li	a5,0
    800055aa:	a085                	j	8000560a <sys_link+0x13c>
    end_op();
    800055ac:	fffff097          	auipc	ra,0xfffff
    800055b0:	cf4080e7          	jalr	-780(ra) # 800042a0 <end_op>
    return -1;
    800055b4:	57fd                	li	a5,-1
    800055b6:	a891                	j	8000560a <sys_link+0x13c>
    iunlockput(ip);
    800055b8:	8526                	mv	a0,s1
    800055ba:	ffffe097          	auipc	ra,0xffffe
    800055be:	50e080e7          	jalr	1294(ra) # 80003ac8 <iunlockput>
    end_op();
    800055c2:	fffff097          	auipc	ra,0xfffff
    800055c6:	cde080e7          	jalr	-802(ra) # 800042a0 <end_op>
    return -1;
    800055ca:	57fd                	li	a5,-1
    800055cc:	a83d                	j	8000560a <sys_link+0x13c>
    iunlockput(dp);
    800055ce:	854a                	mv	a0,s2
    800055d0:	ffffe097          	auipc	ra,0xffffe
    800055d4:	4f8080e7          	jalr	1272(ra) # 80003ac8 <iunlockput>
  ilock(ip);
    800055d8:	8526                	mv	a0,s1
    800055da:	ffffe097          	auipc	ra,0xffffe
    800055de:	2b0080e7          	jalr	688(ra) # 8000388a <ilock>
  ip->nlink--;
    800055e2:	04a4d783          	lhu	a5,74(s1)
    800055e6:	37fd                	addiw	a5,a5,-1
    800055e8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800055ec:	8526                	mv	a0,s1
    800055ee:	ffffe097          	auipc	ra,0xffffe
    800055f2:	1d2080e7          	jalr	466(ra) # 800037c0 <iupdate>
  iunlockput(ip);
    800055f6:	8526                	mv	a0,s1
    800055f8:	ffffe097          	auipc	ra,0xffffe
    800055fc:	4d0080e7          	jalr	1232(ra) # 80003ac8 <iunlockput>
  end_op();
    80005600:	fffff097          	auipc	ra,0xfffff
    80005604:	ca0080e7          	jalr	-864(ra) # 800042a0 <end_op>
  return -1;
    80005608:	57fd                	li	a5,-1
}
    8000560a:	853e                	mv	a0,a5
    8000560c:	70b2                	ld	ra,296(sp)
    8000560e:	7412                	ld	s0,288(sp)
    80005610:	64f2                	ld	s1,280(sp)
    80005612:	6952                	ld	s2,272(sp)
    80005614:	6155                	addi	sp,sp,304
    80005616:	8082                	ret

0000000080005618 <sys_unlink>:
{
    80005618:	7151                	addi	sp,sp,-240
    8000561a:	f586                	sd	ra,232(sp)
    8000561c:	f1a2                	sd	s0,224(sp)
    8000561e:	eda6                	sd	s1,216(sp)
    80005620:	e9ca                	sd	s2,208(sp)
    80005622:	e5ce                	sd	s3,200(sp)
    80005624:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005626:	08000613          	li	a2,128
    8000562a:	f3040593          	addi	a1,s0,-208
    8000562e:	4501                	li	a0,0
    80005630:	ffffd097          	auipc	ra,0xffffd
    80005634:	71e080e7          	jalr	1822(ra) # 80002d4e <argstr>
    80005638:	18054163          	bltz	a0,800057ba <sys_unlink+0x1a2>
  begin_op();
    8000563c:	fffff097          	auipc	ra,0xfffff
    80005640:	be4080e7          	jalr	-1052(ra) # 80004220 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005644:	fb040593          	addi	a1,s0,-80
    80005648:	f3040513          	addi	a0,s0,-208
    8000564c:	fffff097          	auipc	ra,0xfffff
    80005650:	9e6080e7          	jalr	-1562(ra) # 80004032 <nameiparent>
    80005654:	84aa                	mv	s1,a0
    80005656:	c979                	beqz	a0,8000572c <sys_unlink+0x114>
  ilock(dp);
    80005658:	ffffe097          	auipc	ra,0xffffe
    8000565c:	232080e7          	jalr	562(ra) # 8000388a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005660:	00002597          	auipc	a1,0x2
    80005664:	0d058593          	addi	a1,a1,208 # 80007730 <userret+0x6a0>
    80005668:	fb040513          	addi	a0,s0,-80
    8000566c:	ffffe097          	auipc	ra,0xffffe
    80005670:	6bc080e7          	jalr	1724(ra) # 80003d28 <namecmp>
    80005674:	14050a63          	beqz	a0,800057c8 <sys_unlink+0x1b0>
    80005678:	00002597          	auipc	a1,0x2
    8000567c:	0c058593          	addi	a1,a1,192 # 80007738 <userret+0x6a8>
    80005680:	fb040513          	addi	a0,s0,-80
    80005684:	ffffe097          	auipc	ra,0xffffe
    80005688:	6a4080e7          	jalr	1700(ra) # 80003d28 <namecmp>
    8000568c:	12050e63          	beqz	a0,800057c8 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005690:	f2c40613          	addi	a2,s0,-212
    80005694:	fb040593          	addi	a1,s0,-80
    80005698:	8526                	mv	a0,s1
    8000569a:	ffffe097          	auipc	ra,0xffffe
    8000569e:	6a8080e7          	jalr	1704(ra) # 80003d42 <dirlookup>
    800056a2:	892a                	mv	s2,a0
    800056a4:	12050263          	beqz	a0,800057c8 <sys_unlink+0x1b0>
  ilock(ip);
    800056a8:	ffffe097          	auipc	ra,0xffffe
    800056ac:	1e2080e7          	jalr	482(ra) # 8000388a <ilock>
  if(ip->nlink < 1)
    800056b0:	04a91783          	lh	a5,74(s2)
    800056b4:	08f05263          	blez	a5,80005738 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800056b8:	04491703          	lh	a4,68(s2)
    800056bc:	4785                	li	a5,1
    800056be:	08f70563          	beq	a4,a5,80005748 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800056c2:	4641                	li	a2,16
    800056c4:	4581                	li	a1,0
    800056c6:	fc040513          	addi	a0,s0,-64
    800056ca:	ffffb097          	auipc	ra,0xffffb
    800056ce:	4a4080e7          	jalr	1188(ra) # 80000b6e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800056d2:	4741                	li	a4,16
    800056d4:	f2c42683          	lw	a3,-212(s0)
    800056d8:	fc040613          	addi	a2,s0,-64
    800056dc:	4581                	li	a1,0
    800056de:	8526                	mv	a0,s1
    800056e0:	ffffe097          	auipc	ra,0xffffe
    800056e4:	52e080e7          	jalr	1326(ra) # 80003c0e <writei>
    800056e8:	47c1                	li	a5,16
    800056ea:	0af51563          	bne	a0,a5,80005794 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800056ee:	04491703          	lh	a4,68(s2)
    800056f2:	4785                	li	a5,1
    800056f4:	0af70863          	beq	a4,a5,800057a4 <sys_unlink+0x18c>
  iunlockput(dp);
    800056f8:	8526                	mv	a0,s1
    800056fa:	ffffe097          	auipc	ra,0xffffe
    800056fe:	3ce080e7          	jalr	974(ra) # 80003ac8 <iunlockput>
  ip->nlink--;
    80005702:	04a95783          	lhu	a5,74(s2)
    80005706:	37fd                	addiw	a5,a5,-1
    80005708:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000570c:	854a                	mv	a0,s2
    8000570e:	ffffe097          	auipc	ra,0xffffe
    80005712:	0b2080e7          	jalr	178(ra) # 800037c0 <iupdate>
  iunlockput(ip);
    80005716:	854a                	mv	a0,s2
    80005718:	ffffe097          	auipc	ra,0xffffe
    8000571c:	3b0080e7          	jalr	944(ra) # 80003ac8 <iunlockput>
  end_op();
    80005720:	fffff097          	auipc	ra,0xfffff
    80005724:	b80080e7          	jalr	-1152(ra) # 800042a0 <end_op>
  return 0;
    80005728:	4501                	li	a0,0
    8000572a:	a84d                	j	800057dc <sys_unlink+0x1c4>
    end_op();
    8000572c:	fffff097          	auipc	ra,0xfffff
    80005730:	b74080e7          	jalr	-1164(ra) # 800042a0 <end_op>
    return -1;
    80005734:	557d                	li	a0,-1
    80005736:	a05d                	j	800057dc <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005738:	00002517          	auipc	a0,0x2
    8000573c:	02850513          	addi	a0,a0,40 # 80007760 <userret+0x6d0>
    80005740:	ffffb097          	auipc	ra,0xffffb
    80005744:	e0e080e7          	jalr	-498(ra) # 8000054e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005748:	04c92703          	lw	a4,76(s2)
    8000574c:	02000793          	li	a5,32
    80005750:	f6e7f9e3          	bgeu	a5,a4,800056c2 <sys_unlink+0xaa>
    80005754:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005758:	4741                	li	a4,16
    8000575a:	86ce                	mv	a3,s3
    8000575c:	f1840613          	addi	a2,s0,-232
    80005760:	4581                	li	a1,0
    80005762:	854a                	mv	a0,s2
    80005764:	ffffe097          	auipc	ra,0xffffe
    80005768:	3b6080e7          	jalr	950(ra) # 80003b1a <readi>
    8000576c:	47c1                	li	a5,16
    8000576e:	00f51b63          	bne	a0,a5,80005784 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005772:	f1845783          	lhu	a5,-232(s0)
    80005776:	e7a1                	bnez	a5,800057be <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005778:	29c1                	addiw	s3,s3,16
    8000577a:	04c92783          	lw	a5,76(s2)
    8000577e:	fcf9ede3          	bltu	s3,a5,80005758 <sys_unlink+0x140>
    80005782:	b781                	j	800056c2 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005784:	00002517          	auipc	a0,0x2
    80005788:	ff450513          	addi	a0,a0,-12 # 80007778 <userret+0x6e8>
    8000578c:	ffffb097          	auipc	ra,0xffffb
    80005790:	dc2080e7          	jalr	-574(ra) # 8000054e <panic>
    panic("unlink: writei");
    80005794:	00002517          	auipc	a0,0x2
    80005798:	ffc50513          	addi	a0,a0,-4 # 80007790 <userret+0x700>
    8000579c:	ffffb097          	auipc	ra,0xffffb
    800057a0:	db2080e7          	jalr	-590(ra) # 8000054e <panic>
    dp->nlink--;
    800057a4:	04a4d783          	lhu	a5,74(s1)
    800057a8:	37fd                	addiw	a5,a5,-1
    800057aa:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800057ae:	8526                	mv	a0,s1
    800057b0:	ffffe097          	auipc	ra,0xffffe
    800057b4:	010080e7          	jalr	16(ra) # 800037c0 <iupdate>
    800057b8:	b781                	j	800056f8 <sys_unlink+0xe0>
    return -1;
    800057ba:	557d                	li	a0,-1
    800057bc:	a005                	j	800057dc <sys_unlink+0x1c4>
    iunlockput(ip);
    800057be:	854a                	mv	a0,s2
    800057c0:	ffffe097          	auipc	ra,0xffffe
    800057c4:	308080e7          	jalr	776(ra) # 80003ac8 <iunlockput>
  iunlockput(dp);
    800057c8:	8526                	mv	a0,s1
    800057ca:	ffffe097          	auipc	ra,0xffffe
    800057ce:	2fe080e7          	jalr	766(ra) # 80003ac8 <iunlockput>
  end_op();
    800057d2:	fffff097          	auipc	ra,0xfffff
    800057d6:	ace080e7          	jalr	-1330(ra) # 800042a0 <end_op>
  return -1;
    800057da:	557d                	li	a0,-1
}
    800057dc:	70ae                	ld	ra,232(sp)
    800057de:	740e                	ld	s0,224(sp)
    800057e0:	64ee                	ld	s1,216(sp)
    800057e2:	694e                	ld	s2,208(sp)
    800057e4:	69ae                	ld	s3,200(sp)
    800057e6:	616d                	addi	sp,sp,240
    800057e8:	8082                	ret

00000000800057ea <sys_open>:

uint64
sys_open(void)
{
    800057ea:	7131                	addi	sp,sp,-192
    800057ec:	fd06                	sd	ra,184(sp)
    800057ee:	f922                	sd	s0,176(sp)
    800057f0:	f526                	sd	s1,168(sp)
    800057f2:	f14a                	sd	s2,160(sp)
    800057f4:	ed4e                	sd	s3,152(sp)
    800057f6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800057f8:	08000613          	li	a2,128
    800057fc:	f5040593          	addi	a1,s0,-176
    80005800:	4501                	li	a0,0
    80005802:	ffffd097          	auipc	ra,0xffffd
    80005806:	54c080e7          	jalr	1356(ra) # 80002d4e <argstr>
    return -1;
    8000580a:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000580c:	0a054763          	bltz	a0,800058ba <sys_open+0xd0>
    80005810:	f4c40593          	addi	a1,s0,-180
    80005814:	4505                	li	a0,1
    80005816:	ffffd097          	auipc	ra,0xffffd
    8000581a:	4f4080e7          	jalr	1268(ra) # 80002d0a <argint>
    8000581e:	08054e63          	bltz	a0,800058ba <sys_open+0xd0>

  begin_op();
    80005822:	fffff097          	auipc	ra,0xfffff
    80005826:	9fe080e7          	jalr	-1538(ra) # 80004220 <begin_op>

  if(omode & O_CREATE){
    8000582a:	f4c42783          	lw	a5,-180(s0)
    8000582e:	2007f793          	andi	a5,a5,512
    80005832:	c3cd                	beqz	a5,800058d4 <sys_open+0xea>
    ip = create(path, T_FILE, 0, 0);
    80005834:	4681                	li	a3,0
    80005836:	4601                	li	a2,0
    80005838:	4589                	li	a1,2
    8000583a:	f5040513          	addi	a0,s0,-176
    8000583e:	00000097          	auipc	ra,0x0
    80005842:	974080e7          	jalr	-1676(ra) # 800051b2 <create>
    80005846:	892a                	mv	s2,a0
    if(ip == 0){
    80005848:	c149                	beqz	a0,800058ca <sys_open+0xe0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000584a:	04491703          	lh	a4,68(s2)
    8000584e:	478d                	li	a5,3
    80005850:	00f71763          	bne	a4,a5,8000585e <sys_open+0x74>
    80005854:	04695703          	lhu	a4,70(s2)
    80005858:	47a5                	li	a5,9
    8000585a:	0ce7e263          	bltu	a5,a4,8000591e <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000585e:	fffff097          	auipc	ra,0xfffff
    80005862:	dd8080e7          	jalr	-552(ra) # 80004636 <filealloc>
    80005866:	89aa                	mv	s3,a0
    80005868:	c175                	beqz	a0,8000594c <sys_open+0x162>
    8000586a:	00000097          	auipc	ra,0x0
    8000586e:	906080e7          	jalr	-1786(ra) # 80005170 <fdalloc>
    80005872:	84aa                	mv	s1,a0
    80005874:	0c054763          	bltz	a0,80005942 <sys_open+0x158>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005878:	04491703          	lh	a4,68(s2)
    8000587c:	478d                	li	a5,3
    8000587e:	0af70b63          	beq	a4,a5,80005934 <sys_open+0x14a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005882:	4789                	li	a5,2
    80005884:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005888:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    8000588c:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005890:	f4c42783          	lw	a5,-180(s0)
    80005894:	0017c713          	xori	a4,a5,1
    80005898:	8b05                	andi	a4,a4,1
    8000589a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000589e:	8b8d                	andi	a5,a5,3
    800058a0:	00f037b3          	snez	a5,a5
    800058a4:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
    800058a8:	854a                	mv	a0,s2
    800058aa:	ffffe097          	auipc	ra,0xffffe
    800058ae:	0a2080e7          	jalr	162(ra) # 8000394c <iunlock>
  end_op();
    800058b2:	fffff097          	auipc	ra,0xfffff
    800058b6:	9ee080e7          	jalr	-1554(ra) # 800042a0 <end_op>

  return fd;
}
    800058ba:	8526                	mv	a0,s1
    800058bc:	70ea                	ld	ra,184(sp)
    800058be:	744a                	ld	s0,176(sp)
    800058c0:	74aa                	ld	s1,168(sp)
    800058c2:	790a                	ld	s2,160(sp)
    800058c4:	69ea                	ld	s3,152(sp)
    800058c6:	6129                	addi	sp,sp,192
    800058c8:	8082                	ret
      end_op();
    800058ca:	fffff097          	auipc	ra,0xfffff
    800058ce:	9d6080e7          	jalr	-1578(ra) # 800042a0 <end_op>
      return -1;
    800058d2:	b7e5                	j	800058ba <sys_open+0xd0>
    if((ip = namei(path)) == 0){
    800058d4:	f5040513          	addi	a0,s0,-176
    800058d8:	ffffe097          	auipc	ra,0xffffe
    800058dc:	73c080e7          	jalr	1852(ra) # 80004014 <namei>
    800058e0:	892a                	mv	s2,a0
    800058e2:	c905                	beqz	a0,80005912 <sys_open+0x128>
    ilock(ip);
    800058e4:	ffffe097          	auipc	ra,0xffffe
    800058e8:	fa6080e7          	jalr	-90(ra) # 8000388a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800058ec:	04491703          	lh	a4,68(s2)
    800058f0:	4785                	li	a5,1
    800058f2:	f4f71ce3          	bne	a4,a5,8000584a <sys_open+0x60>
    800058f6:	f4c42783          	lw	a5,-180(s0)
    800058fa:	d3b5                	beqz	a5,8000585e <sys_open+0x74>
      iunlockput(ip);
    800058fc:	854a                	mv	a0,s2
    800058fe:	ffffe097          	auipc	ra,0xffffe
    80005902:	1ca080e7          	jalr	458(ra) # 80003ac8 <iunlockput>
      end_op();
    80005906:	fffff097          	auipc	ra,0xfffff
    8000590a:	99a080e7          	jalr	-1638(ra) # 800042a0 <end_op>
      return -1;
    8000590e:	54fd                	li	s1,-1
    80005910:	b76d                	j	800058ba <sys_open+0xd0>
      end_op();
    80005912:	fffff097          	auipc	ra,0xfffff
    80005916:	98e080e7          	jalr	-1650(ra) # 800042a0 <end_op>
      return -1;
    8000591a:	54fd                	li	s1,-1
    8000591c:	bf79                	j	800058ba <sys_open+0xd0>
    iunlockput(ip);
    8000591e:	854a                	mv	a0,s2
    80005920:	ffffe097          	auipc	ra,0xffffe
    80005924:	1a8080e7          	jalr	424(ra) # 80003ac8 <iunlockput>
    end_op();
    80005928:	fffff097          	auipc	ra,0xfffff
    8000592c:	978080e7          	jalr	-1672(ra) # 800042a0 <end_op>
    return -1;
    80005930:	54fd                	li	s1,-1
    80005932:	b761                	j	800058ba <sys_open+0xd0>
    f->type = FD_DEVICE;
    80005934:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005938:	04691783          	lh	a5,70(s2)
    8000593c:	02f99223          	sh	a5,36(s3)
    80005940:	b7b1                	j	8000588c <sys_open+0xa2>
      fileclose(f);
    80005942:	854e                	mv	a0,s3
    80005944:	fffff097          	auipc	ra,0xfffff
    80005948:	dae080e7          	jalr	-594(ra) # 800046f2 <fileclose>
    iunlockput(ip);
    8000594c:	854a                	mv	a0,s2
    8000594e:	ffffe097          	auipc	ra,0xffffe
    80005952:	17a080e7          	jalr	378(ra) # 80003ac8 <iunlockput>
    end_op();
    80005956:	fffff097          	auipc	ra,0xfffff
    8000595a:	94a080e7          	jalr	-1718(ra) # 800042a0 <end_op>
    return -1;
    8000595e:	54fd                	li	s1,-1
    80005960:	bfa9                	j	800058ba <sys_open+0xd0>

0000000080005962 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005962:	7175                	addi	sp,sp,-144
    80005964:	e506                	sd	ra,136(sp)
    80005966:	e122                	sd	s0,128(sp)
    80005968:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000596a:	fffff097          	auipc	ra,0xfffff
    8000596e:	8b6080e7          	jalr	-1866(ra) # 80004220 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005972:	08000613          	li	a2,128
    80005976:	f7040593          	addi	a1,s0,-144
    8000597a:	4501                	li	a0,0
    8000597c:	ffffd097          	auipc	ra,0xffffd
    80005980:	3d2080e7          	jalr	978(ra) # 80002d4e <argstr>
    80005984:	02054963          	bltz	a0,800059b6 <sys_mkdir+0x54>
    80005988:	4681                	li	a3,0
    8000598a:	4601                	li	a2,0
    8000598c:	4585                	li	a1,1
    8000598e:	f7040513          	addi	a0,s0,-144
    80005992:	00000097          	auipc	ra,0x0
    80005996:	820080e7          	jalr	-2016(ra) # 800051b2 <create>
    8000599a:	cd11                	beqz	a0,800059b6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000599c:	ffffe097          	auipc	ra,0xffffe
    800059a0:	12c080e7          	jalr	300(ra) # 80003ac8 <iunlockput>
  end_op();
    800059a4:	fffff097          	auipc	ra,0xfffff
    800059a8:	8fc080e7          	jalr	-1796(ra) # 800042a0 <end_op>
  return 0;
    800059ac:	4501                	li	a0,0
}
    800059ae:	60aa                	ld	ra,136(sp)
    800059b0:	640a                	ld	s0,128(sp)
    800059b2:	6149                	addi	sp,sp,144
    800059b4:	8082                	ret
    end_op();
    800059b6:	fffff097          	auipc	ra,0xfffff
    800059ba:	8ea080e7          	jalr	-1814(ra) # 800042a0 <end_op>
    return -1;
    800059be:	557d                	li	a0,-1
    800059c0:	b7fd                	j	800059ae <sys_mkdir+0x4c>

00000000800059c2 <sys_mknod>:

uint64
sys_mknod(void)
{
    800059c2:	7135                	addi	sp,sp,-160
    800059c4:	ed06                	sd	ra,152(sp)
    800059c6:	e922                	sd	s0,144(sp)
    800059c8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800059ca:	fffff097          	auipc	ra,0xfffff
    800059ce:	856080e7          	jalr	-1962(ra) # 80004220 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800059d2:	08000613          	li	a2,128
    800059d6:	f7040593          	addi	a1,s0,-144
    800059da:	4501                	li	a0,0
    800059dc:	ffffd097          	auipc	ra,0xffffd
    800059e0:	372080e7          	jalr	882(ra) # 80002d4e <argstr>
    800059e4:	04054a63          	bltz	a0,80005a38 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    800059e8:	f6c40593          	addi	a1,s0,-148
    800059ec:	4505                	li	a0,1
    800059ee:	ffffd097          	auipc	ra,0xffffd
    800059f2:	31c080e7          	jalr	796(ra) # 80002d0a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800059f6:	04054163          	bltz	a0,80005a38 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    800059fa:	f6840593          	addi	a1,s0,-152
    800059fe:	4509                	li	a0,2
    80005a00:	ffffd097          	auipc	ra,0xffffd
    80005a04:	30a080e7          	jalr	778(ra) # 80002d0a <argint>
     argint(1, &major) < 0 ||
    80005a08:	02054863          	bltz	a0,80005a38 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005a0c:	f6841683          	lh	a3,-152(s0)
    80005a10:	f6c41603          	lh	a2,-148(s0)
    80005a14:	458d                	li	a1,3
    80005a16:	f7040513          	addi	a0,s0,-144
    80005a1a:	fffff097          	auipc	ra,0xfffff
    80005a1e:	798080e7          	jalr	1944(ra) # 800051b2 <create>
     argint(2, &minor) < 0 ||
    80005a22:	c919                	beqz	a0,80005a38 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005a24:	ffffe097          	auipc	ra,0xffffe
    80005a28:	0a4080e7          	jalr	164(ra) # 80003ac8 <iunlockput>
  end_op();
    80005a2c:	fffff097          	auipc	ra,0xfffff
    80005a30:	874080e7          	jalr	-1932(ra) # 800042a0 <end_op>
  return 0;
    80005a34:	4501                	li	a0,0
    80005a36:	a031                	j	80005a42 <sys_mknod+0x80>
    end_op();
    80005a38:	fffff097          	auipc	ra,0xfffff
    80005a3c:	868080e7          	jalr	-1944(ra) # 800042a0 <end_op>
    return -1;
    80005a40:	557d                	li	a0,-1
}
    80005a42:	60ea                	ld	ra,152(sp)
    80005a44:	644a                	ld	s0,144(sp)
    80005a46:	610d                	addi	sp,sp,160
    80005a48:	8082                	ret

0000000080005a4a <sys_chdir>:

uint64
sys_chdir(void)
{
    80005a4a:	7135                	addi	sp,sp,-160
    80005a4c:	ed06                	sd	ra,152(sp)
    80005a4e:	e922                	sd	s0,144(sp)
    80005a50:	e526                	sd	s1,136(sp)
    80005a52:	e14a                	sd	s2,128(sp)
    80005a54:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005a56:	ffffc097          	auipc	ra,0xffffc
    80005a5a:	dee080e7          	jalr	-530(ra) # 80001844 <myproc>
    80005a5e:	892a                	mv	s2,a0
  
  begin_op();
    80005a60:	ffffe097          	auipc	ra,0xffffe
    80005a64:	7c0080e7          	jalr	1984(ra) # 80004220 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005a68:	08000613          	li	a2,128
    80005a6c:	f6040593          	addi	a1,s0,-160
    80005a70:	4501                	li	a0,0
    80005a72:	ffffd097          	auipc	ra,0xffffd
    80005a76:	2dc080e7          	jalr	732(ra) # 80002d4e <argstr>
    80005a7a:	04054b63          	bltz	a0,80005ad0 <sys_chdir+0x86>
    80005a7e:	f6040513          	addi	a0,s0,-160
    80005a82:	ffffe097          	auipc	ra,0xffffe
    80005a86:	592080e7          	jalr	1426(ra) # 80004014 <namei>
    80005a8a:	84aa                	mv	s1,a0
    80005a8c:	c131                	beqz	a0,80005ad0 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005a8e:	ffffe097          	auipc	ra,0xffffe
    80005a92:	dfc080e7          	jalr	-516(ra) # 8000388a <ilock>
  if(ip->type != T_DIR){
    80005a96:	04449703          	lh	a4,68(s1)
    80005a9a:	4785                	li	a5,1
    80005a9c:	04f71063          	bne	a4,a5,80005adc <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005aa0:	8526                	mv	a0,s1
    80005aa2:	ffffe097          	auipc	ra,0xffffe
    80005aa6:	eaa080e7          	jalr	-342(ra) # 8000394c <iunlock>
  iput(p->cwd);
    80005aaa:	15893503          	ld	a0,344(s2)
    80005aae:	ffffe097          	auipc	ra,0xffffe
    80005ab2:	eea080e7          	jalr	-278(ra) # 80003998 <iput>
  end_op();
    80005ab6:	ffffe097          	auipc	ra,0xffffe
    80005aba:	7ea080e7          	jalr	2026(ra) # 800042a0 <end_op>
  p->cwd = ip;
    80005abe:	14993c23          	sd	s1,344(s2)
  return 0;
    80005ac2:	4501                	li	a0,0
}
    80005ac4:	60ea                	ld	ra,152(sp)
    80005ac6:	644a                	ld	s0,144(sp)
    80005ac8:	64aa                	ld	s1,136(sp)
    80005aca:	690a                	ld	s2,128(sp)
    80005acc:	610d                	addi	sp,sp,160
    80005ace:	8082                	ret
    end_op();
    80005ad0:	ffffe097          	auipc	ra,0xffffe
    80005ad4:	7d0080e7          	jalr	2000(ra) # 800042a0 <end_op>
    return -1;
    80005ad8:	557d                	li	a0,-1
    80005ada:	b7ed                	j	80005ac4 <sys_chdir+0x7a>
    iunlockput(ip);
    80005adc:	8526                	mv	a0,s1
    80005ade:	ffffe097          	auipc	ra,0xffffe
    80005ae2:	fea080e7          	jalr	-22(ra) # 80003ac8 <iunlockput>
    end_op();
    80005ae6:	ffffe097          	auipc	ra,0xffffe
    80005aea:	7ba080e7          	jalr	1978(ra) # 800042a0 <end_op>
    return -1;
    80005aee:	557d                	li	a0,-1
    80005af0:	bfd1                	j	80005ac4 <sys_chdir+0x7a>

0000000080005af2 <sys_exec>:

uint64
sys_exec(void)
{
    80005af2:	7145                	addi	sp,sp,-464
    80005af4:	e786                	sd	ra,456(sp)
    80005af6:	e3a2                	sd	s0,448(sp)
    80005af8:	ff26                	sd	s1,440(sp)
    80005afa:	fb4a                	sd	s2,432(sp)
    80005afc:	f74e                	sd	s3,424(sp)
    80005afe:	f352                	sd	s4,416(sp)
    80005b00:	ef56                	sd	s5,408(sp)
    80005b02:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005b04:	08000613          	li	a2,128
    80005b08:	f4040593          	addi	a1,s0,-192
    80005b0c:	4501                	li	a0,0
    80005b0e:	ffffd097          	auipc	ra,0xffffd
    80005b12:	240080e7          	jalr	576(ra) # 80002d4e <argstr>
    80005b16:	0e054663          	bltz	a0,80005c02 <sys_exec+0x110>
    80005b1a:	e3840593          	addi	a1,s0,-456
    80005b1e:	4505                	li	a0,1
    80005b20:	ffffd097          	auipc	ra,0xffffd
    80005b24:	20c080e7          	jalr	524(ra) # 80002d2c <argaddr>
    80005b28:	0e054763          	bltz	a0,80005c16 <sys_exec+0x124>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    80005b2c:	10000613          	li	a2,256
    80005b30:	4581                	li	a1,0
    80005b32:	e4040513          	addi	a0,s0,-448
    80005b36:	ffffb097          	auipc	ra,0xffffb
    80005b3a:	038080e7          	jalr	56(ra) # 80000b6e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005b3e:	e4040913          	addi	s2,s0,-448
  memset(argv, 0, sizeof(argv));
    80005b42:	89ca                	mv	s3,s2
    80005b44:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    80005b46:	02000a13          	li	s4,32
    80005b4a:	00048a9b          	sext.w	s5,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005b4e:	00349513          	slli	a0,s1,0x3
    80005b52:	e3040593          	addi	a1,s0,-464
    80005b56:	e3843783          	ld	a5,-456(s0)
    80005b5a:	953e                	add	a0,a0,a5
    80005b5c:	ffffd097          	auipc	ra,0xffffd
    80005b60:	114080e7          	jalr	276(ra) # 80002c70 <fetchaddr>
    80005b64:	02054a63          	bltz	a0,80005b98 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005b68:	e3043783          	ld	a5,-464(s0)
    80005b6c:	c7a1                	beqz	a5,80005bb4 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005b6e:	ffffb097          	auipc	ra,0xffffb
    80005b72:	df2080e7          	jalr	-526(ra) # 80000960 <kalloc>
    80005b76:	85aa                	mv	a1,a0
    80005b78:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005b7c:	c92d                	beqz	a0,80005bee <sys_exec+0xfc>
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
    80005b7e:	6605                	lui	a2,0x1
    80005b80:	e3043503          	ld	a0,-464(s0)
    80005b84:	ffffd097          	auipc	ra,0xffffd
    80005b88:	13e080e7          	jalr	318(ra) # 80002cc2 <fetchstr>
    80005b8c:	00054663          	bltz	a0,80005b98 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005b90:	0485                	addi	s1,s1,1
    80005b92:	09a1                	addi	s3,s3,8
    80005b94:	fb449be3          	bne	s1,s4,80005b4a <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b98:	10090493          	addi	s1,s2,256
    80005b9c:	00093503          	ld	a0,0(s2)
    80005ba0:	cd39                	beqz	a0,80005bfe <sys_exec+0x10c>
    kfree(argv[i]);
    80005ba2:	ffffb097          	auipc	ra,0xffffb
    80005ba6:	cc2080e7          	jalr	-830(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005baa:	0921                	addi	s2,s2,8
    80005bac:	fe9918e3          	bne	s2,s1,80005b9c <sys_exec+0xaa>
  return -1;
    80005bb0:	557d                	li	a0,-1
    80005bb2:	a889                	j	80005c04 <sys_exec+0x112>
      argv[i] = 0;
    80005bb4:	0a8e                	slli	s5,s5,0x3
    80005bb6:	fc040793          	addi	a5,s0,-64
    80005bba:	9abe                	add	s5,s5,a5
    80005bbc:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8e64>
  int ret = exec(path, argv);
    80005bc0:	e4040593          	addi	a1,s0,-448
    80005bc4:	f4040513          	addi	a0,s0,-192
    80005bc8:	fffff097          	auipc	ra,0xfffff
    80005bcc:	1cc080e7          	jalr	460(ra) # 80004d94 <exec>
    80005bd0:	84aa                	mv	s1,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bd2:	10090993          	addi	s3,s2,256
    80005bd6:	00093503          	ld	a0,0(s2)
    80005bda:	c901                	beqz	a0,80005bea <sys_exec+0xf8>
    kfree(argv[i]);
    80005bdc:	ffffb097          	auipc	ra,0xffffb
    80005be0:	c88080e7          	jalr	-888(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005be4:	0921                	addi	s2,s2,8
    80005be6:	ff3918e3          	bne	s2,s3,80005bd6 <sys_exec+0xe4>
  return ret;
    80005bea:	8526                	mv	a0,s1
    80005bec:	a821                	j	80005c04 <sys_exec+0x112>
      panic("sys_exec kalloc");
    80005bee:	00002517          	auipc	a0,0x2
    80005bf2:	bb250513          	addi	a0,a0,-1102 # 800077a0 <userret+0x710>
    80005bf6:	ffffb097          	auipc	ra,0xffffb
    80005bfa:	958080e7          	jalr	-1704(ra) # 8000054e <panic>
  return -1;
    80005bfe:	557d                	li	a0,-1
    80005c00:	a011                	j	80005c04 <sys_exec+0x112>
    return -1;
    80005c02:	557d                	li	a0,-1
}
    80005c04:	60be                	ld	ra,456(sp)
    80005c06:	641e                	ld	s0,448(sp)
    80005c08:	74fa                	ld	s1,440(sp)
    80005c0a:	795a                	ld	s2,432(sp)
    80005c0c:	79ba                	ld	s3,424(sp)
    80005c0e:	7a1a                	ld	s4,416(sp)
    80005c10:	6afa                	ld	s5,408(sp)
    80005c12:	6179                	addi	sp,sp,464
    80005c14:	8082                	ret
    return -1;
    80005c16:	557d                	li	a0,-1
    80005c18:	b7f5                	j	80005c04 <sys_exec+0x112>

0000000080005c1a <sys_pipe>:

uint64
sys_pipe(void)
{
    80005c1a:	7139                	addi	sp,sp,-64
    80005c1c:	fc06                	sd	ra,56(sp)
    80005c1e:	f822                	sd	s0,48(sp)
    80005c20:	f426                	sd	s1,40(sp)
    80005c22:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005c24:	ffffc097          	auipc	ra,0xffffc
    80005c28:	c20080e7          	jalr	-992(ra) # 80001844 <myproc>
    80005c2c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005c2e:	fd840593          	addi	a1,s0,-40
    80005c32:	4501                	li	a0,0
    80005c34:	ffffd097          	auipc	ra,0xffffd
    80005c38:	0f8080e7          	jalr	248(ra) # 80002d2c <argaddr>
    return -1;
    80005c3c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005c3e:	0e054063          	bltz	a0,80005d1e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005c42:	fc840593          	addi	a1,s0,-56
    80005c46:	fd040513          	addi	a0,s0,-48
    80005c4a:	fffff097          	auipc	ra,0xfffff
    80005c4e:	dfe080e7          	jalr	-514(ra) # 80004a48 <pipealloc>
    return -1;
    80005c52:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005c54:	0c054563          	bltz	a0,80005d1e <sys_pipe+0x104>
  fd0 = -1;
    80005c58:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005c5c:	fd043503          	ld	a0,-48(s0)
    80005c60:	fffff097          	auipc	ra,0xfffff
    80005c64:	510080e7          	jalr	1296(ra) # 80005170 <fdalloc>
    80005c68:	fca42223          	sw	a0,-60(s0)
    80005c6c:	08054c63          	bltz	a0,80005d04 <sys_pipe+0xea>
    80005c70:	fc843503          	ld	a0,-56(s0)
    80005c74:	fffff097          	auipc	ra,0xfffff
    80005c78:	4fc080e7          	jalr	1276(ra) # 80005170 <fdalloc>
    80005c7c:	fca42023          	sw	a0,-64(s0)
    80005c80:	06054863          	bltz	a0,80005cf0 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c84:	4691                	li	a3,4
    80005c86:	fc440613          	addi	a2,s0,-60
    80005c8a:	fd843583          	ld	a1,-40(s0)
    80005c8e:	6ca8                	ld	a0,88(s1)
    80005c90:	ffffc097          	auipc	ra,0xffffc
    80005c94:	8a8080e7          	jalr	-1880(ra) # 80001538 <copyout>
    80005c98:	02054063          	bltz	a0,80005cb8 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005c9c:	4691                	li	a3,4
    80005c9e:	fc040613          	addi	a2,s0,-64
    80005ca2:	fd843583          	ld	a1,-40(s0)
    80005ca6:	0591                	addi	a1,a1,4
    80005ca8:	6ca8                	ld	a0,88(s1)
    80005caa:	ffffc097          	auipc	ra,0xffffc
    80005cae:	88e080e7          	jalr	-1906(ra) # 80001538 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005cb2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005cb4:	06055563          	bgez	a0,80005d1e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005cb8:	fc442783          	lw	a5,-60(s0)
    80005cbc:	07e9                	addi	a5,a5,26
    80005cbe:	078e                	slli	a5,a5,0x3
    80005cc0:	97a6                	add	a5,a5,s1
    80005cc2:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005cc6:	fc042503          	lw	a0,-64(s0)
    80005cca:	0569                	addi	a0,a0,26
    80005ccc:	050e                	slli	a0,a0,0x3
    80005cce:	9526                	add	a0,a0,s1
    80005cd0:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005cd4:	fd043503          	ld	a0,-48(s0)
    80005cd8:	fffff097          	auipc	ra,0xfffff
    80005cdc:	a1a080e7          	jalr	-1510(ra) # 800046f2 <fileclose>
    fileclose(wf);
    80005ce0:	fc843503          	ld	a0,-56(s0)
    80005ce4:	fffff097          	auipc	ra,0xfffff
    80005ce8:	a0e080e7          	jalr	-1522(ra) # 800046f2 <fileclose>
    return -1;
    80005cec:	57fd                	li	a5,-1
    80005cee:	a805                	j	80005d1e <sys_pipe+0x104>
    if(fd0 >= 0)
    80005cf0:	fc442783          	lw	a5,-60(s0)
    80005cf4:	0007c863          	bltz	a5,80005d04 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005cf8:	01a78513          	addi	a0,a5,26
    80005cfc:	050e                	slli	a0,a0,0x3
    80005cfe:	9526                	add	a0,a0,s1
    80005d00:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005d04:	fd043503          	ld	a0,-48(s0)
    80005d08:	fffff097          	auipc	ra,0xfffff
    80005d0c:	9ea080e7          	jalr	-1558(ra) # 800046f2 <fileclose>
    fileclose(wf);
    80005d10:	fc843503          	ld	a0,-56(s0)
    80005d14:	fffff097          	auipc	ra,0xfffff
    80005d18:	9de080e7          	jalr	-1570(ra) # 800046f2 <fileclose>
    return -1;
    80005d1c:	57fd                	li	a5,-1
}
    80005d1e:	853e                	mv	a0,a5
    80005d20:	70e2                	ld	ra,56(sp)
    80005d22:	7442                	ld	s0,48(sp)
    80005d24:	74a2                	ld	s1,40(sp)
    80005d26:	6121                	addi	sp,sp,64
    80005d28:	8082                	ret
    80005d2a:	0000                	unimp
    80005d2c:	0000                	unimp
	...

0000000080005d30 <kernelvec>:
    80005d30:	7111                	addi	sp,sp,-256
    80005d32:	e006                	sd	ra,0(sp)
    80005d34:	e40a                	sd	sp,8(sp)
    80005d36:	e80e                	sd	gp,16(sp)
    80005d38:	ec12                	sd	tp,24(sp)
    80005d3a:	f016                	sd	t0,32(sp)
    80005d3c:	f41a                	sd	t1,40(sp)
    80005d3e:	f81e                	sd	t2,48(sp)
    80005d40:	fc22                	sd	s0,56(sp)
    80005d42:	e0a6                	sd	s1,64(sp)
    80005d44:	e4aa                	sd	a0,72(sp)
    80005d46:	e8ae                	sd	a1,80(sp)
    80005d48:	ecb2                	sd	a2,88(sp)
    80005d4a:	f0b6                	sd	a3,96(sp)
    80005d4c:	f4ba                	sd	a4,104(sp)
    80005d4e:	f8be                	sd	a5,112(sp)
    80005d50:	fcc2                	sd	a6,120(sp)
    80005d52:	e146                	sd	a7,128(sp)
    80005d54:	e54a                	sd	s2,136(sp)
    80005d56:	e94e                	sd	s3,144(sp)
    80005d58:	ed52                	sd	s4,152(sp)
    80005d5a:	f156                	sd	s5,160(sp)
    80005d5c:	f55a                	sd	s6,168(sp)
    80005d5e:	f95e                	sd	s7,176(sp)
    80005d60:	fd62                	sd	s8,184(sp)
    80005d62:	e1e6                	sd	s9,192(sp)
    80005d64:	e5ea                	sd	s10,200(sp)
    80005d66:	e9ee                	sd	s11,208(sp)
    80005d68:	edf2                	sd	t3,216(sp)
    80005d6a:	f1f6                	sd	t4,224(sp)
    80005d6c:	f5fa                	sd	t5,232(sp)
    80005d6e:	f9fe                	sd	t6,240(sp)
    80005d70:	dcdfc0ef          	jal	ra,80002b3c <kerneltrap>
    80005d74:	6082                	ld	ra,0(sp)
    80005d76:	6122                	ld	sp,8(sp)
    80005d78:	61c2                	ld	gp,16(sp)
    80005d7a:	7282                	ld	t0,32(sp)
    80005d7c:	7322                	ld	t1,40(sp)
    80005d7e:	73c2                	ld	t2,48(sp)
    80005d80:	7462                	ld	s0,56(sp)
    80005d82:	6486                	ld	s1,64(sp)
    80005d84:	6526                	ld	a0,72(sp)
    80005d86:	65c6                	ld	a1,80(sp)
    80005d88:	6666                	ld	a2,88(sp)
    80005d8a:	7686                	ld	a3,96(sp)
    80005d8c:	7726                	ld	a4,104(sp)
    80005d8e:	77c6                	ld	a5,112(sp)
    80005d90:	7866                	ld	a6,120(sp)
    80005d92:	688a                	ld	a7,128(sp)
    80005d94:	692a                	ld	s2,136(sp)
    80005d96:	69ca                	ld	s3,144(sp)
    80005d98:	6a6a                	ld	s4,152(sp)
    80005d9a:	7a8a                	ld	s5,160(sp)
    80005d9c:	7b2a                	ld	s6,168(sp)
    80005d9e:	7bca                	ld	s7,176(sp)
    80005da0:	7c6a                	ld	s8,184(sp)
    80005da2:	6c8e                	ld	s9,192(sp)
    80005da4:	6d2e                	ld	s10,200(sp)
    80005da6:	6dce                	ld	s11,208(sp)
    80005da8:	6e6e                	ld	t3,216(sp)
    80005daa:	7e8e                	ld	t4,224(sp)
    80005dac:	7f2e                	ld	t5,232(sp)
    80005dae:	7fce                	ld	t6,240(sp)
    80005db0:	6111                	addi	sp,sp,256
    80005db2:	10200073          	sret
    80005db6:	00000013          	nop
    80005dba:	00000013          	nop
    80005dbe:	0001                	nop

0000000080005dc0 <timervec>:
    80005dc0:	34051573          	csrrw	a0,mscratch,a0
    80005dc4:	e10c                	sd	a1,0(a0)
    80005dc6:	e510                	sd	a2,8(a0)
    80005dc8:	e914                	sd	a3,16(a0)
    80005dca:	710c                	ld	a1,32(a0)
    80005dcc:	7510                	ld	a2,40(a0)
    80005dce:	6194                	ld	a3,0(a1)
    80005dd0:	96b2                	add	a3,a3,a2
    80005dd2:	e194                	sd	a3,0(a1)
    80005dd4:	4589                	li	a1,2
    80005dd6:	14459073          	csrw	sip,a1
    80005dda:	6914                	ld	a3,16(a0)
    80005ddc:	6510                	ld	a2,8(a0)
    80005dde:	610c                	ld	a1,0(a0)
    80005de0:	34051573          	csrrw	a0,mscratch,a0
    80005de4:	30200073          	mret
	...

0000000080005dea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005dea:	1141                	addi	sp,sp,-16
    80005dec:	e422                	sd	s0,8(sp)
    80005dee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005df0:	0c0007b7          	lui	a5,0xc000
    80005df4:	4705                	li	a4,1
    80005df6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005df8:	c3d8                	sw	a4,4(a5)
}
    80005dfa:	6422                	ld	s0,8(sp)
    80005dfc:	0141                	addi	sp,sp,16
    80005dfe:	8082                	ret

0000000080005e00 <plicinithart>:

void
plicinithart(void)
{
    80005e00:	1141                	addi	sp,sp,-16
    80005e02:	e406                	sd	ra,8(sp)
    80005e04:	e022                	sd	s0,0(sp)
    80005e06:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005e08:	ffffc097          	auipc	ra,0xffffc
    80005e0c:	a10080e7          	jalr	-1520(ra) # 80001818 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005e10:	0085171b          	slliw	a4,a0,0x8
    80005e14:	0c0027b7          	lui	a5,0xc002
    80005e18:	97ba                	add	a5,a5,a4
    80005e1a:	40200713          	li	a4,1026
    80005e1e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005e22:	00d5151b          	slliw	a0,a0,0xd
    80005e26:	0c2017b7          	lui	a5,0xc201
    80005e2a:	953e                	add	a0,a0,a5
    80005e2c:	00052023          	sw	zero,0(a0)
}
    80005e30:	60a2                	ld	ra,8(sp)
    80005e32:	6402                	ld	s0,0(sp)
    80005e34:	0141                	addi	sp,sp,16
    80005e36:	8082                	ret

0000000080005e38 <plic_pending>:

// return a bitmap of which IRQs are waiting
// to be served.
uint64
plic_pending(void)
{
    80005e38:	1141                	addi	sp,sp,-16
    80005e3a:	e422                	sd	s0,8(sp)
    80005e3c:	0800                	addi	s0,sp,16
  //mask = *(uint32*)(PLIC + 0x1000);
  //mask |= (uint64)*(uint32*)(PLIC + 0x1004) << 32;
  mask = *(uint64*)PLIC_PENDING;

  return mask;
}
    80005e3e:	0c0017b7          	lui	a5,0xc001
    80005e42:	6388                	ld	a0,0(a5)
    80005e44:	6422                	ld	s0,8(sp)
    80005e46:	0141                	addi	sp,sp,16
    80005e48:	8082                	ret

0000000080005e4a <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005e4a:	1141                	addi	sp,sp,-16
    80005e4c:	e406                	sd	ra,8(sp)
    80005e4e:	e022                	sd	s0,0(sp)
    80005e50:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005e52:	ffffc097          	auipc	ra,0xffffc
    80005e56:	9c6080e7          	jalr	-1594(ra) # 80001818 <cpuid>
  //int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005e5a:	00d5179b          	slliw	a5,a0,0xd
    80005e5e:	0c201537          	lui	a0,0xc201
    80005e62:	953e                	add	a0,a0,a5
  return irq;
}
    80005e64:	4148                	lw	a0,4(a0)
    80005e66:	60a2                	ld	ra,8(sp)
    80005e68:	6402                	ld	s0,0(sp)
    80005e6a:	0141                	addi	sp,sp,16
    80005e6c:	8082                	ret

0000000080005e6e <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005e6e:	1101                	addi	sp,sp,-32
    80005e70:	ec06                	sd	ra,24(sp)
    80005e72:	e822                	sd	s0,16(sp)
    80005e74:	e426                	sd	s1,8(sp)
    80005e76:	1000                	addi	s0,sp,32
    80005e78:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005e7a:	ffffc097          	auipc	ra,0xffffc
    80005e7e:	99e080e7          	jalr	-1634(ra) # 80001818 <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005e82:	00d5151b          	slliw	a0,a0,0xd
    80005e86:	0c2017b7          	lui	a5,0xc201
    80005e8a:	97aa                	add	a5,a5,a0
    80005e8c:	c3c4                	sw	s1,4(a5)
}
    80005e8e:	60e2                	ld	ra,24(sp)
    80005e90:	6442                	ld	s0,16(sp)
    80005e92:	64a2                	ld	s1,8(sp)
    80005e94:	6105                	addi	sp,sp,32
    80005e96:	8082                	ret

0000000080005e98 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005e98:	1141                	addi	sp,sp,-16
    80005e9a:	e406                	sd	ra,8(sp)
    80005e9c:	e022                	sd	s0,0(sp)
    80005e9e:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005ea0:	479d                	li	a5,7
    80005ea2:	04a7cc63          	blt	a5,a0,80005efa <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005ea6:	0001d797          	auipc	a5,0x1d
    80005eaa:	15a78793          	addi	a5,a5,346 # 80023000 <disk>
    80005eae:	00a78733          	add	a4,a5,a0
    80005eb2:	6789                	lui	a5,0x2
    80005eb4:	97ba                	add	a5,a5,a4
    80005eb6:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005eba:	eba1                	bnez	a5,80005f0a <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005ebc:	00451713          	slli	a4,a0,0x4
    80005ec0:	0001f797          	auipc	a5,0x1f
    80005ec4:	1407b783          	ld	a5,320(a5) # 80025000 <disk+0x2000>
    80005ec8:	97ba                	add	a5,a5,a4
    80005eca:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005ece:	0001d797          	auipc	a5,0x1d
    80005ed2:	13278793          	addi	a5,a5,306 # 80023000 <disk>
    80005ed6:	97aa                	add	a5,a5,a0
    80005ed8:	6509                	lui	a0,0x2
    80005eda:	953e                	add	a0,a0,a5
    80005edc:	4785                	li	a5,1
    80005ede:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005ee2:	0001f517          	auipc	a0,0x1f
    80005ee6:	13650513          	addi	a0,a0,310 # 80025018 <disk+0x2018>
    80005eea:	ffffc097          	auipc	ra,0xffffc
    80005eee:	6a2080e7          	jalr	1698(ra) # 8000258c <wakeup>
}
    80005ef2:	60a2                	ld	ra,8(sp)
    80005ef4:	6402                	ld	s0,0(sp)
    80005ef6:	0141                	addi	sp,sp,16
    80005ef8:	8082                	ret
    panic("virtio_disk_intr 1");
    80005efa:	00002517          	auipc	a0,0x2
    80005efe:	8b650513          	addi	a0,a0,-1866 # 800077b0 <userret+0x720>
    80005f02:	ffffa097          	auipc	ra,0xffffa
    80005f06:	64c080e7          	jalr	1612(ra) # 8000054e <panic>
    panic("virtio_disk_intr 2");
    80005f0a:	00002517          	auipc	a0,0x2
    80005f0e:	8be50513          	addi	a0,a0,-1858 # 800077c8 <userret+0x738>
    80005f12:	ffffa097          	auipc	ra,0xffffa
    80005f16:	63c080e7          	jalr	1596(ra) # 8000054e <panic>

0000000080005f1a <virtio_disk_init>:
{
    80005f1a:	1101                	addi	sp,sp,-32
    80005f1c:	ec06                	sd	ra,24(sp)
    80005f1e:	e822                	sd	s0,16(sp)
    80005f20:	e426                	sd	s1,8(sp)
    80005f22:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005f24:	00002597          	auipc	a1,0x2
    80005f28:	8bc58593          	addi	a1,a1,-1860 # 800077e0 <userret+0x750>
    80005f2c:	0001f517          	auipc	a0,0x1f
    80005f30:	17c50513          	addi	a0,a0,380 # 800250a8 <disk+0x20a8>
    80005f34:	ffffb097          	auipc	ra,0xffffb
    80005f38:	a8c080e7          	jalr	-1396(ra) # 800009c0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f3c:	100017b7          	lui	a5,0x10001
    80005f40:	4398                	lw	a4,0(a5)
    80005f42:	2701                	sext.w	a4,a4
    80005f44:	747277b7          	lui	a5,0x74727
    80005f48:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005f4c:	0ef71163          	bne	a4,a5,8000602e <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005f50:	100017b7          	lui	a5,0x10001
    80005f54:	43dc                	lw	a5,4(a5)
    80005f56:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f58:	4705                	li	a4,1
    80005f5a:	0ce79a63          	bne	a5,a4,8000602e <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f5e:	100017b7          	lui	a5,0x10001
    80005f62:	479c                	lw	a5,8(a5)
    80005f64:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005f66:	4709                	li	a4,2
    80005f68:	0ce79363          	bne	a5,a4,8000602e <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005f6c:	100017b7          	lui	a5,0x10001
    80005f70:	47d8                	lw	a4,12(a5)
    80005f72:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f74:	554d47b7          	lui	a5,0x554d4
    80005f78:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005f7c:	0af71963          	bne	a4,a5,8000602e <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f80:	100017b7          	lui	a5,0x10001
    80005f84:	4705                	li	a4,1
    80005f86:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f88:	470d                	li	a4,3
    80005f8a:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005f8c:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005f8e:	c7ffe737          	lui	a4,0xc7ffe
    80005f92:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd8743>
    80005f96:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005f98:	2701                	sext.w	a4,a4
    80005f9a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f9c:	472d                	li	a4,11
    80005f9e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005fa0:	473d                	li	a4,15
    80005fa2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005fa4:	6705                	lui	a4,0x1
    80005fa6:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005fa8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005fac:	5bdc                	lw	a5,52(a5)
    80005fae:	2781                	sext.w	a5,a5
  if(max == 0)
    80005fb0:	c7d9                	beqz	a5,8000603e <virtio_disk_init+0x124>
  if(max < NUM)
    80005fb2:	471d                	li	a4,7
    80005fb4:	08f77d63          	bgeu	a4,a5,8000604e <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005fb8:	100014b7          	lui	s1,0x10001
    80005fbc:	47a1                	li	a5,8
    80005fbe:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005fc0:	6609                	lui	a2,0x2
    80005fc2:	4581                	li	a1,0
    80005fc4:	0001d517          	auipc	a0,0x1d
    80005fc8:	03c50513          	addi	a0,a0,60 # 80023000 <disk>
    80005fcc:	ffffb097          	auipc	ra,0xffffb
    80005fd0:	ba2080e7          	jalr	-1118(ra) # 80000b6e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005fd4:	0001d717          	auipc	a4,0x1d
    80005fd8:	02c70713          	addi	a4,a4,44 # 80023000 <disk>
    80005fdc:	00c75793          	srli	a5,a4,0xc
    80005fe0:	2781                	sext.w	a5,a5
    80005fe2:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80005fe4:	0001f797          	auipc	a5,0x1f
    80005fe8:	01c78793          	addi	a5,a5,28 # 80025000 <disk+0x2000>
    80005fec:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80005fee:	0001d717          	auipc	a4,0x1d
    80005ff2:	09270713          	addi	a4,a4,146 # 80023080 <disk+0x80>
    80005ff6:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80005ff8:	0001e717          	auipc	a4,0x1e
    80005ffc:	00870713          	addi	a4,a4,8 # 80024000 <disk+0x1000>
    80006000:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006002:	4705                	li	a4,1
    80006004:	00e78c23          	sb	a4,24(a5)
    80006008:	00e78ca3          	sb	a4,25(a5)
    8000600c:	00e78d23          	sb	a4,26(a5)
    80006010:	00e78da3          	sb	a4,27(a5)
    80006014:	00e78e23          	sb	a4,28(a5)
    80006018:	00e78ea3          	sb	a4,29(a5)
    8000601c:	00e78f23          	sb	a4,30(a5)
    80006020:	00e78fa3          	sb	a4,31(a5)
}
    80006024:	60e2                	ld	ra,24(sp)
    80006026:	6442                	ld	s0,16(sp)
    80006028:	64a2                	ld	s1,8(sp)
    8000602a:	6105                	addi	sp,sp,32
    8000602c:	8082                	ret
    panic("could not find virtio disk");
    8000602e:	00001517          	auipc	a0,0x1
    80006032:	7c250513          	addi	a0,a0,1986 # 800077f0 <userret+0x760>
    80006036:	ffffa097          	auipc	ra,0xffffa
    8000603a:	518080e7          	jalr	1304(ra) # 8000054e <panic>
    panic("virtio disk has no queue 0");
    8000603e:	00001517          	auipc	a0,0x1
    80006042:	7d250513          	addi	a0,a0,2002 # 80007810 <userret+0x780>
    80006046:	ffffa097          	auipc	ra,0xffffa
    8000604a:	508080e7          	jalr	1288(ra) # 8000054e <panic>
    panic("virtio disk max queue too short");
    8000604e:	00001517          	auipc	a0,0x1
    80006052:	7e250513          	addi	a0,a0,2018 # 80007830 <userret+0x7a0>
    80006056:	ffffa097          	auipc	ra,0xffffa
    8000605a:	4f8080e7          	jalr	1272(ra) # 8000054e <panic>

000000008000605e <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000605e:	7119                	addi	sp,sp,-128
    80006060:	fc86                	sd	ra,120(sp)
    80006062:	f8a2                	sd	s0,112(sp)
    80006064:	f4a6                	sd	s1,104(sp)
    80006066:	f0ca                	sd	s2,96(sp)
    80006068:	ecce                	sd	s3,88(sp)
    8000606a:	e8d2                	sd	s4,80(sp)
    8000606c:	e4d6                	sd	s5,72(sp)
    8000606e:	e0da                	sd	s6,64(sp)
    80006070:	fc5e                	sd	s7,56(sp)
    80006072:	f862                	sd	s8,48(sp)
    80006074:	f466                	sd	s9,40(sp)
    80006076:	f06a                	sd	s10,32(sp)
    80006078:	0100                	addi	s0,sp,128
    8000607a:	892a                	mv	s2,a0
    8000607c:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000607e:	00c52c83          	lw	s9,12(a0)
    80006082:	001c9c9b          	slliw	s9,s9,0x1
    80006086:	1c82                	slli	s9,s9,0x20
    80006088:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000608c:	0001f517          	auipc	a0,0x1f
    80006090:	01c50513          	addi	a0,a0,28 # 800250a8 <disk+0x20a8>
    80006094:	ffffb097          	auipc	ra,0xffffb
    80006098:	a3e080e7          	jalr	-1474(ra) # 80000ad2 <acquire>
  for(int i = 0; i < 3; i++){
    8000609c:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000609e:	4c21                	li	s8,8
      disk.free[i] = 0;
    800060a0:	0001db97          	auipc	s7,0x1d
    800060a4:	f60b8b93          	addi	s7,s7,-160 # 80023000 <disk>
    800060a8:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800060aa:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800060ac:	8a4e                	mv	s4,s3
    800060ae:	a051                	j	80006132 <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800060b0:	00fb86b3          	add	a3,s7,a5
    800060b4:	96da                	add	a3,a3,s6
    800060b6:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800060ba:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800060bc:	0207c563          	bltz	a5,800060e6 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800060c0:	2485                	addiw	s1,s1,1
    800060c2:	0711                	addi	a4,a4,4
    800060c4:	1b548863          	beq	s1,s5,80006274 <virtio_disk_rw+0x216>
    idx[i] = alloc_desc();
    800060c8:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800060ca:	0001f697          	auipc	a3,0x1f
    800060ce:	f4e68693          	addi	a3,a3,-178 # 80025018 <disk+0x2018>
    800060d2:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800060d4:	0006c583          	lbu	a1,0(a3)
    800060d8:	fde1                	bnez	a1,800060b0 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800060da:	2785                	addiw	a5,a5,1
    800060dc:	0685                	addi	a3,a3,1
    800060de:	ff879be3          	bne	a5,s8,800060d4 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800060e2:	57fd                	li	a5,-1
    800060e4:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800060e6:	02905a63          	blez	s1,8000611a <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800060ea:	f9042503          	lw	a0,-112(s0)
    800060ee:	00000097          	auipc	ra,0x0
    800060f2:	daa080e7          	jalr	-598(ra) # 80005e98 <free_desc>
      for(int j = 0; j < i; j++)
    800060f6:	4785                	li	a5,1
    800060f8:	0297d163          	bge	a5,s1,8000611a <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800060fc:	f9442503          	lw	a0,-108(s0)
    80006100:	00000097          	auipc	ra,0x0
    80006104:	d98080e7          	jalr	-616(ra) # 80005e98 <free_desc>
      for(int j = 0; j < i; j++)
    80006108:	4789                	li	a5,2
    8000610a:	0097d863          	bge	a5,s1,8000611a <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    8000610e:	f9842503          	lw	a0,-104(s0)
    80006112:	00000097          	auipc	ra,0x0
    80006116:	d86080e7          	jalr	-634(ra) # 80005e98 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000611a:	0001f597          	auipc	a1,0x1f
    8000611e:	f8e58593          	addi	a1,a1,-114 # 800250a8 <disk+0x20a8>
    80006122:	0001f517          	auipc	a0,0x1f
    80006126:	ef650513          	addi	a0,a0,-266 # 80025018 <disk+0x2018>
    8000612a:	ffffc097          	auipc	ra,0xffffc
    8000612e:	198080e7          	jalr	408(ra) # 800022c2 <sleep>
  for(int i = 0; i < 3; i++){
    80006132:	f9040713          	addi	a4,s0,-112
    80006136:	84ce                	mv	s1,s3
    80006138:	bf41                	j	800060c8 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000613a:	0001f717          	auipc	a4,0x1f
    8000613e:	ec673703          	ld	a4,-314(a4) # 80025000 <disk+0x2000>
    80006142:	973e                	add	a4,a4,a5
    80006144:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006148:	0001d517          	auipc	a0,0x1d
    8000614c:	eb850513          	addi	a0,a0,-328 # 80023000 <disk>
    80006150:	0001f717          	auipc	a4,0x1f
    80006154:	eb070713          	addi	a4,a4,-336 # 80025000 <disk+0x2000>
    80006158:	6310                	ld	a2,0(a4)
    8000615a:	963e                	add	a2,a2,a5
    8000615c:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006160:	0015e593          	ori	a1,a1,1
    80006164:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80006168:	f9842683          	lw	a3,-104(s0)
    8000616c:	6310                	ld	a2,0(a4)
    8000616e:	97b2                	add	a5,a5,a2
    80006170:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    80006174:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    80006178:	0612                	slli	a2,a2,0x4
    8000617a:	962a                	add	a2,a2,a0
    8000617c:	02060823          	sb	zero,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006180:	00469793          	slli	a5,a3,0x4
    80006184:	630c                	ld	a1,0(a4)
    80006186:	95be                	add	a1,a1,a5
    80006188:	6689                	lui	a3,0x2
    8000618a:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    8000618e:	96ce                	add	a3,a3,s3
    80006190:	96aa                	add	a3,a3,a0
    80006192:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    80006194:	6314                	ld	a3,0(a4)
    80006196:	96be                	add	a3,a3,a5
    80006198:	4585                	li	a1,1
    8000619a:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000619c:	6314                	ld	a3,0(a4)
    8000619e:	96be                	add	a3,a3,a5
    800061a0:	4509                	li	a0,2
    800061a2:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    800061a6:	6314                	ld	a3,0(a4)
    800061a8:	97b6                	add	a5,a5,a3
    800061aa:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800061ae:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800061b2:	03263423          	sd	s2,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    800061b6:	6714                	ld	a3,8(a4)
    800061b8:	0026d783          	lhu	a5,2(a3)
    800061bc:	8b9d                	andi	a5,a5,7
    800061be:	2789                	addiw	a5,a5,2
    800061c0:	0786                	slli	a5,a5,0x1
    800061c2:	97b6                	add	a5,a5,a3
    800061c4:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    800061c8:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    800061cc:	6718                	ld	a4,8(a4)
    800061ce:	00275783          	lhu	a5,2(a4)
    800061d2:	2785                	addiw	a5,a5,1
    800061d4:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800061d8:	100017b7          	lui	a5,0x10001
    800061dc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800061e0:	00492783          	lw	a5,4(s2)
    800061e4:	02b79163          	bne	a5,a1,80006206 <virtio_disk_rw+0x1a8>
    sleep(b, &disk.vdisk_lock);
    800061e8:	0001f997          	auipc	s3,0x1f
    800061ec:	ec098993          	addi	s3,s3,-320 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    800061f0:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800061f2:	85ce                	mv	a1,s3
    800061f4:	854a                	mv	a0,s2
    800061f6:	ffffc097          	auipc	ra,0xffffc
    800061fa:	0cc080e7          	jalr	204(ra) # 800022c2 <sleep>
  while(b->disk == 1) {
    800061fe:	00492783          	lw	a5,4(s2)
    80006202:	fe9788e3          	beq	a5,s1,800061f2 <virtio_disk_rw+0x194>
  }

  disk.info[idx[0]].b = 0;
    80006206:	f9042483          	lw	s1,-112(s0)
    8000620a:	20048793          	addi	a5,s1,512
    8000620e:	00479713          	slli	a4,a5,0x4
    80006212:	0001d797          	auipc	a5,0x1d
    80006216:	dee78793          	addi	a5,a5,-530 # 80023000 <disk>
    8000621a:	97ba                	add	a5,a5,a4
    8000621c:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80006220:	0001f917          	auipc	s2,0x1f
    80006224:	de090913          	addi	s2,s2,-544 # 80025000 <disk+0x2000>
    free_desc(i);
    80006228:	8526                	mv	a0,s1
    8000622a:	00000097          	auipc	ra,0x0
    8000622e:	c6e080e7          	jalr	-914(ra) # 80005e98 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80006232:	0492                	slli	s1,s1,0x4
    80006234:	00093783          	ld	a5,0(s2)
    80006238:	94be                	add	s1,s1,a5
    8000623a:	00c4d783          	lhu	a5,12(s1)
    8000623e:	8b85                	andi	a5,a5,1
    80006240:	c781                	beqz	a5,80006248 <virtio_disk_rw+0x1ea>
      i = disk.desc[i].next;
    80006242:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    80006246:	b7cd                	j	80006228 <virtio_disk_rw+0x1ca>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006248:	0001f517          	auipc	a0,0x1f
    8000624c:	e6050513          	addi	a0,a0,-416 # 800250a8 <disk+0x20a8>
    80006250:	ffffb097          	auipc	ra,0xffffb
    80006254:	8d6080e7          	jalr	-1834(ra) # 80000b26 <release>
}
    80006258:	70e6                	ld	ra,120(sp)
    8000625a:	7446                	ld	s0,112(sp)
    8000625c:	74a6                	ld	s1,104(sp)
    8000625e:	7906                	ld	s2,96(sp)
    80006260:	69e6                	ld	s3,88(sp)
    80006262:	6a46                	ld	s4,80(sp)
    80006264:	6aa6                	ld	s5,72(sp)
    80006266:	6b06                	ld	s6,64(sp)
    80006268:	7be2                	ld	s7,56(sp)
    8000626a:	7c42                	ld	s8,48(sp)
    8000626c:	7ca2                	ld	s9,40(sp)
    8000626e:	7d02                	ld	s10,32(sp)
    80006270:	6109                	addi	sp,sp,128
    80006272:	8082                	ret
  if(write)
    80006274:	01a037b3          	snez	a5,s10
    80006278:	f8f42023          	sw	a5,-128(s0)
  buf0.reserved = 0;
    8000627c:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    80006280:	f9943423          	sd	s9,-120(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80006284:	f9042483          	lw	s1,-112(s0)
    80006288:	00449993          	slli	s3,s1,0x4
    8000628c:	0001fa17          	auipc	s4,0x1f
    80006290:	d74a0a13          	addi	s4,s4,-652 # 80025000 <disk+0x2000>
    80006294:	000a3a83          	ld	s5,0(s4)
    80006298:	9ace                	add	s5,s5,s3
    8000629a:	f8040513          	addi	a0,s0,-128
    8000629e:	ffffb097          	auipc	ra,0xffffb
    800062a2:	d22080e7          	jalr	-734(ra) # 80000fc0 <kvmpa>
    800062a6:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    800062aa:	000a3783          	ld	a5,0(s4)
    800062ae:	97ce                	add	a5,a5,s3
    800062b0:	4741                	li	a4,16
    800062b2:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800062b4:	000a3783          	ld	a5,0(s4)
    800062b8:	97ce                	add	a5,a5,s3
    800062ba:	4705                	li	a4,1
    800062bc:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800062c0:	f9442783          	lw	a5,-108(s0)
    800062c4:	000a3703          	ld	a4,0(s4)
    800062c8:	974e                	add	a4,a4,s3
    800062ca:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800062ce:	0792                	slli	a5,a5,0x4
    800062d0:	000a3703          	ld	a4,0(s4)
    800062d4:	973e                	add	a4,a4,a5
    800062d6:	06090693          	addi	a3,s2,96
    800062da:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    800062dc:	000a3703          	ld	a4,0(s4)
    800062e0:	973e                	add	a4,a4,a5
    800062e2:	40000693          	li	a3,1024
    800062e6:	c714                	sw	a3,8(a4)
  if(write)
    800062e8:	e40d19e3          	bnez	s10,8000613a <virtio_disk_rw+0xdc>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800062ec:	0001f717          	auipc	a4,0x1f
    800062f0:	d1473703          	ld	a4,-748(a4) # 80025000 <disk+0x2000>
    800062f4:	973e                	add	a4,a4,a5
    800062f6:	4689                	li	a3,2
    800062f8:	00d71623          	sh	a3,12(a4)
    800062fc:	b5b1                	j	80006148 <virtio_disk_rw+0xea>

00000000800062fe <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800062fe:	1101                	addi	sp,sp,-32
    80006300:	ec06                	sd	ra,24(sp)
    80006302:	e822                	sd	s0,16(sp)
    80006304:	e426                	sd	s1,8(sp)
    80006306:	e04a                	sd	s2,0(sp)
    80006308:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000630a:	0001f517          	auipc	a0,0x1f
    8000630e:	d9e50513          	addi	a0,a0,-610 # 800250a8 <disk+0x20a8>
    80006312:	ffffa097          	auipc	ra,0xffffa
    80006316:	7c0080e7          	jalr	1984(ra) # 80000ad2 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    8000631a:	0001f717          	auipc	a4,0x1f
    8000631e:	ce670713          	addi	a4,a4,-794 # 80025000 <disk+0x2000>
    80006322:	02075783          	lhu	a5,32(a4)
    80006326:	6b18                	ld	a4,16(a4)
    80006328:	00275683          	lhu	a3,2(a4)
    8000632c:	8ebd                	xor	a3,a3,a5
    8000632e:	8a9d                	andi	a3,a3,7
    80006330:	cab9                	beqz	a3,80006386 <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    80006332:	0001d917          	auipc	s2,0x1d
    80006336:	cce90913          	addi	s2,s2,-818 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    8000633a:	0001f497          	auipc	s1,0x1f
    8000633e:	cc648493          	addi	s1,s1,-826 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    80006342:	078e                	slli	a5,a5,0x3
    80006344:	97ba                	add	a5,a5,a4
    80006346:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    80006348:	20078713          	addi	a4,a5,512
    8000634c:	0712                	slli	a4,a4,0x4
    8000634e:	974a                	add	a4,a4,s2
    80006350:	03074703          	lbu	a4,48(a4)
    80006354:	e739                	bnez	a4,800063a2 <virtio_disk_intr+0xa4>
    disk.info[id].b->disk = 0;   // disk is done with buf
    80006356:	20078793          	addi	a5,a5,512
    8000635a:	0792                	slli	a5,a5,0x4
    8000635c:	97ca                	add	a5,a5,s2
    8000635e:	7798                	ld	a4,40(a5)
    80006360:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    80006364:	7788                	ld	a0,40(a5)
    80006366:	ffffc097          	auipc	ra,0xffffc
    8000636a:	226080e7          	jalr	550(ra) # 8000258c <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    8000636e:	0204d783          	lhu	a5,32(s1)
    80006372:	2785                	addiw	a5,a5,1
    80006374:	8b9d                	andi	a5,a5,7
    80006376:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    8000637a:	6898                	ld	a4,16(s1)
    8000637c:	00275683          	lhu	a3,2(a4)
    80006380:	8a9d                	andi	a3,a3,7
    80006382:	fcf690e3          	bne	a3,a5,80006342 <virtio_disk_intr+0x44>
  }

  release(&disk.vdisk_lock);
    80006386:	0001f517          	auipc	a0,0x1f
    8000638a:	d2250513          	addi	a0,a0,-734 # 800250a8 <disk+0x20a8>
    8000638e:	ffffa097          	auipc	ra,0xffffa
    80006392:	798080e7          	jalr	1944(ra) # 80000b26 <release>
}
    80006396:	60e2                	ld	ra,24(sp)
    80006398:	6442                	ld	s0,16(sp)
    8000639a:	64a2                	ld	s1,8(sp)
    8000639c:	6902                	ld	s2,0(sp)
    8000639e:	6105                	addi	sp,sp,32
    800063a0:	8082                	ret
      panic("virtio_disk_intr status");
    800063a2:	00001517          	auipc	a0,0x1
    800063a6:	4ae50513          	addi	a0,a0,1198 # 80007850 <userret+0x7c0>
    800063aa:	ffffa097          	auipc	ra,0xffffa
    800063ae:	1a4080e7          	jalr	420(ra) # 8000054e <panic>
	...

0000000080007000 <trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
