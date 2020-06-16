
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
    80000060:	22478793          	addi	a5,a5,548 # 80006280 <timervec>
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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87db>
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
    80000140:	00002097          	auipc	ra,0x2
    80000144:	9c2080e7          	jalr	-1598(ra) # 80001b02 <myproc>
    80000148:	591c                	lw	a5,48(a0)
    8000014a:	e7b5                	bnez	a5,800001b6 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000014c:	85ce                	mv	a1,s3
    8000014e:	854a                	mv	a0,s2
    80000150:	00002097          	auipc	ra,0x2
    80000154:	61a080e7          	jalr	1562(ra) # 8000276a <sleep>
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
    8000018c:	00003097          	auipc	ra,0x3
    80000190:	982080e7          	jalr	-1662(ra) # 80002b0e <either_copyout>
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
    8000028c:	00003097          	auipc	ra,0x3
    80000290:	8d8080e7          	jalr	-1832(ra) # 80002b64 <either_copyin>
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
    80000302:	00003097          	auipc	ra,0x3
    80000306:	8b8080e7          	jalr	-1864(ra) # 80002bba <procdump>
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
    8000045a:	5de080e7          	jalr	1502(ra) # 80002a34 <wakeup>
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
  //initlock(&userw.lock,"userw");
  uartinit();
    80000480:	00000097          	auipc	ra,0x0
    80000484:	330080e7          	jalr	816(ra) # 800007b0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000488:	00022797          	auipc	a5,0x22
    8000048c:	9e878793          	addi	a5,a5,-1560 # 80021e70 <devsw>
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
    800004ce:	47e60613          	addi	a2,a2,1150 # 80007948 <digits>
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
    80000580:	e5450513          	addi	a0,a0,-428 # 800073d0 <userret+0x340>
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
    800005fa:	352b8b93          	addi	s7,s7,850 # 80007948 <digits>
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
    8000087c:	7ac78793          	addi	a5,a5,1964 # 80026024 <end>
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
    8000094c:	6dc50513          	addi	a0,a0,1756 # 80026024 <end>
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
    800009f2:	0f8080e7          	jalr	248(ra) # 80001ae6 <mycpu>
    800009f6:	5d3c                	lw	a5,120(a0)
    800009f8:	cf89                	beqz	a5,80000a12 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800009fa:	00001097          	auipc	ra,0x1
    800009fe:	0ec080e7          	jalr	236(ra) # 80001ae6 <mycpu>
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
    80000a16:	0d4080e7          	jalr	212(ra) # 80001ae6 <mycpu>
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
    80000a2e:	0bc080e7          	jalr	188(ra) # 80001ae6 <mycpu>
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
    80000ac6:	024080e7          	jalr	36(ra) # 80001ae6 <mycpu>
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
    80000b06:	fe4080e7          	jalr	-28(ra) # 80001ae6 <mycpu>
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
struct spinlock l_r_c; //J
struct spinlock sched_lock; //J
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
    80000d2c:	dae080e7          	jalr	-594(ra) # 80001ad6 <cpuid>
    __sync_synchronize();
    //printf("synchronize works\n");
    //printf("\n");
    started = 1;
  } else {
    while(started == 0)
    80000d30:	00025717          	auipc	a4,0x25
    80000d34:	2d870713          	addi	a4,a4,728 # 80026008 <started>
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
    80000d48:	d92080e7          	jalr	-622(ra) # 80001ad6 <cpuid>
    80000d4c:	85aa                	mv	a1,a0
    80000d4e:	00006517          	auipc	a0,0x6
    80000d52:	47250513          	addi	a0,a0,1138 # 800071c0 <userret+0x130>
    80000d56:	00000097          	auipc	ra,0x0
    80000d5a:	842080e7          	jalr	-1982(ra) # 80000598 <printf>
    kvminithart();    // turn on paging
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	186080e7          	jalr	390(ra) # 80000ee4 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000d66:	00002097          	auipc	ra,0x2
    80000d6a:	f94080e7          	jalr	-108(ra) # 80002cfa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000d6e:	00005097          	auipc	ra,0x5
    80000d72:	552080e7          	jalr	1362(ra) # 800062c0 <plicinithart>
    //noff= scheduler();
    //noff--;
    //printf("b, noff:%d\n", noff);
    //release(&sched_lock);
   //}
   scheduler();        
    80000d76:	00001097          	auipc	ra,0x1
    80000d7a:	71a080e7          	jalr	1818(ra) # 80002490 <scheduler>
    initlock(&l_r_c,"readcounter"); //J
    80000d7e:	00006597          	auipc	a1,0x6
    80000d82:	40a58593          	addi	a1,a1,1034 # 80007188 <userret+0xf8>
    80000d86:	00011517          	auipc	a0,0x11
    80000d8a:	b6250513          	addi	a0,a0,-1182 # 800118e8 <l_r_c>
    80000d8e:	00000097          	auipc	ra,0x0
    80000d92:	c32080e7          	jalr	-974(ra) # 800009c0 <initlock>
    initlock(&sched_lock,"scheduler"); //J
    80000d96:	00006597          	auipc	a1,0x6
    80000d9a:	40258593          	addi	a1,a1,1026 # 80007198 <userret+0x108>
    80000d9e:	00011517          	auipc	a0,0x11
    80000da2:	b6250513          	addi	a0,a0,-1182 # 80011900 <sched_lock>
    80000da6:	00000097          	auipc	ra,0x0
    80000daa:	c1a080e7          	jalr	-998(ra) # 800009c0 <initlock>
    consoleinit();
    80000dae:	fffff097          	auipc	ra,0xfffff
    80000db2:	6b2080e7          	jalr	1714(ra) # 80000460 <consoleinit>
    printfinit();
    80000db6:	00000097          	auipc	ra,0x0
    80000dba:	9c8080e7          	jalr	-1592(ra) # 8000077e <printfinit>
    printf("\n");
    80000dbe:	00006517          	auipc	a0,0x6
    80000dc2:	61250513          	addi	a0,a0,1554 # 800073d0 <userret+0x340>
    80000dc6:	fffff097          	auipc	ra,0xfffff
    80000dca:	7d2080e7          	jalr	2002(ra) # 80000598 <printf>
    printf("xv6 kernel is booting\n");
    80000dce:	00006517          	auipc	a0,0x6
    80000dd2:	3da50513          	addi	a0,a0,986 # 800071a8 <userret+0x118>
    80000dd6:	fffff097          	auipc	ra,0xfffff
    80000dda:	7c2080e7          	jalr	1986(ra) # 80000598 <printf>
    printf("\n");
    80000dde:	00006517          	auipc	a0,0x6
    80000de2:	5f250513          	addi	a0,a0,1522 # 800073d0 <userret+0x340>
    80000de6:	fffff097          	auipc	ra,0xfffff
    80000dea:	7b2080e7          	jalr	1970(ra) # 80000598 <printf>
    kinit();         // physical page allocator
    80000dee:	00000097          	auipc	ra,0x0
    80000df2:	b36080e7          	jalr	-1226(ra) # 80000924 <kinit>
    kvminit();       // create kernel page table
    80000df6:	00000097          	auipc	ra,0x0
    80000dfa:	31e080e7          	jalr	798(ra) # 80001114 <kvminit>
    kvminithart();   // turn on paging
    80000dfe:	00000097          	auipc	ra,0x0
    80000e02:	0e6080e7          	jalr	230(ra) # 80000ee4 <kvminithart>
    procinit();      // process table
    80000e06:	00001097          	auipc	ra,0x1
    80000e0a:	c00080e7          	jalr	-1024(ra) # 80001a06 <procinit>
    trapinit();      // trap vectors
    80000e0e:	00002097          	auipc	ra,0x2
    80000e12:	ec4080e7          	jalr	-316(ra) # 80002cd2 <trapinit>
    trapinithart();  // install kernel trap vector
    80000e16:	00002097          	auipc	ra,0x2
    80000e1a:	ee4080e7          	jalr	-284(ra) # 80002cfa <trapinithart>
    plicinit();      // set up interrupt controller
    80000e1e:	00005097          	auipc	ra,0x5
    80000e22:	48c080e7          	jalr	1164(ra) # 800062aa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000e26:	00005097          	auipc	ra,0x5
    80000e2a:	49a080e7          	jalr	1178(ra) # 800062c0 <plicinithart>
    binit();         // buffer cache
    80000e2e:	00002097          	auipc	ra,0x2
    80000e32:	688080e7          	jalr	1672(ra) # 800034b6 <binit>
    iinit();         // inode cache
    80000e36:	00003097          	auipc	ra,0x3
    80000e3a:	d18080e7          	jalr	-744(ra) # 80003b4e <iinit>
    fileinit();      // file table
    80000e3e:	00004097          	auipc	ra,0x4
    80000e42:	c8c080e7          	jalr	-884(ra) # 80004aca <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000e46:	00005097          	auipc	ra,0x5
    80000e4a:	594080e7          	jalr	1428(ra) # 800063da <virtio_disk_init>
    userinit();      // first user process
    80000e4e:	00001097          	auipc	ra,0x1
    80000e52:	fe8080e7          	jalr	-24(ra) # 80001e36 <userinit>
    __sync_synchronize();
    80000e56:	0ff0000f          	fence
    started = 1;
    80000e5a:	4785                	li	a5,1
    80000e5c:	00025717          	auipc	a4,0x25
    80000e60:	1af72623          	sw	a5,428(a4) # 80026008 <started>
    80000e64:	bf09                	j	80000d76 <main+0x56>

0000000080000e66 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void
freewalk(pagetable_t pagetable)
{
    80000e66:	7179                	addi	sp,sp,-48
    80000e68:	f406                	sd	ra,40(sp)
    80000e6a:	f022                	sd	s0,32(sp)
    80000e6c:	ec26                	sd	s1,24(sp)
    80000e6e:	e84a                	sd	s2,16(sp)
    80000e70:	e44e                	sd	s3,8(sp)
    80000e72:	e052                	sd	s4,0(sp)
    80000e74:	1800                	addi	s0,sp,48
    80000e76:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000e78:	84aa                	mv	s1,a0
    80000e7a:	6905                	lui	s2,0x1
    80000e7c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000e7e:	4985                	li	s3,1
    80000e80:	a821                	j	80000e98 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000e82:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000e84:	0532                	slli	a0,a0,0xc
    80000e86:	00000097          	auipc	ra,0x0
    80000e8a:	fe0080e7          	jalr	-32(ra) # 80000e66 <freewalk>
      pagetable[i] = 0;
    80000e8e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000e92:	04a1                	addi	s1,s1,8
    80000e94:	03248b63          	beq	s1,s2,80000eca <freewalk+0x64>
    pte_t pte = pagetable[i];
    80000e98:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000e9a:	00f57793          	andi	a5,a0,15
    80000e9e:	ff3782e3          	beq	a5,s3,80000e82 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000ea2:	00157793          	andi	a5,a0,1
    80000ea6:	d7f5                	beqz	a5,80000e92 <freewalk+0x2c>
      printf("pte:%p",pte);
    80000ea8:	85aa                	mv	a1,a0
    80000eaa:	00006517          	auipc	a0,0x6
    80000eae:	32e50513          	addi	a0,a0,814 # 800071d8 <userret+0x148>
    80000eb2:	fffff097          	auipc	ra,0xfffff
    80000eb6:	6e6080e7          	jalr	1766(ra) # 80000598 <printf>
      panic("freewalk: leaf");
    80000eba:	00006517          	auipc	a0,0x6
    80000ebe:	32650513          	addi	a0,a0,806 # 800071e0 <userret+0x150>
    80000ec2:	fffff097          	auipc	ra,0xfffff
    80000ec6:	68c080e7          	jalr	1676(ra) # 8000054e <panic>
    }
  }
  kfree((void*)pagetable);
    80000eca:	8552                	mv	a0,s4
    80000ecc:	00000097          	auipc	ra,0x0
    80000ed0:	998080e7          	jalr	-1640(ra) # 80000864 <kfree>
}
    80000ed4:	70a2                	ld	ra,40(sp)
    80000ed6:	7402                	ld	s0,32(sp)
    80000ed8:	64e2                	ld	s1,24(sp)
    80000eda:	6942                	ld	s2,16(sp)
    80000edc:	69a2                	ld	s3,8(sp)
    80000ede:	6a02                	ld	s4,0(sp)
    80000ee0:	6145                	addi	sp,sp,48
    80000ee2:	8082                	ret

0000000080000ee4 <kvminithart>:
{
    80000ee4:	1141                	addi	sp,sp,-16
    80000ee6:	e422                	sd	s0,8(sp)
    80000ee8:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000eea:	00025797          	auipc	a5,0x25
    80000eee:	1267b783          	ld	a5,294(a5) # 80026010 <kernel_pagetable>
    80000ef2:	83b1                	srli	a5,a5,0xc
    80000ef4:	577d                	li	a4,-1
    80000ef6:	177e                	slli	a4,a4,0x3f
    80000ef8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000efa:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000efe:	12000073          	sfence.vma
}
    80000f02:	6422                	ld	s0,8(sp)
    80000f04:	0141                	addi	sp,sp,16
    80000f06:	8082                	ret

0000000080000f08 <walk>:
{
    80000f08:	7139                	addi	sp,sp,-64
    80000f0a:	fc06                	sd	ra,56(sp)
    80000f0c:	f822                	sd	s0,48(sp)
    80000f0e:	f426                	sd	s1,40(sp)
    80000f10:	f04a                	sd	s2,32(sp)
    80000f12:	ec4e                	sd	s3,24(sp)
    80000f14:	e852                	sd	s4,16(sp)
    80000f16:	e456                	sd	s5,8(sp)
    80000f18:	e05a                	sd	s6,0(sp)
    80000f1a:	0080                	addi	s0,sp,64
    80000f1c:	84aa                	mv	s1,a0
    80000f1e:	89ae                	mv	s3,a1
    80000f20:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f22:	57fd                	li	a5,-1
    80000f24:	83e9                	srli	a5,a5,0x1a
    80000f26:	4a79                	li	s4,30
  for(int level = 2; level > 0; level--) {
    80000f28:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f2a:	04b7f263          	bgeu	a5,a1,80000f6e <walk+0x66>
    panic("walk");
    80000f2e:	00006517          	auipc	a0,0x6
    80000f32:	2c250513          	addi	a0,a0,706 # 800071f0 <userret+0x160>
    80000f36:	fffff097          	auipc	ra,0xfffff
    80000f3a:	618080e7          	jalr	1560(ra) # 8000054e <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f3e:	060a8663          	beqz	s5,80000faa <walk+0xa2>
    80000f42:	00000097          	auipc	ra,0x0
    80000f46:	a1e080e7          	jalr	-1506(ra) # 80000960 <kalloc>
    80000f4a:	84aa                	mv	s1,a0
    80000f4c:	c529                	beqz	a0,80000f96 <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    80000f4e:	6605                	lui	a2,0x1
    80000f50:	4581                	li	a1,0
    80000f52:	00000097          	auipc	ra,0x0
    80000f56:	c1c080e7          	jalr	-996(ra) # 80000b6e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f5a:	00c4d793          	srli	a5,s1,0xc
    80000f5e:	07aa                	slli	a5,a5,0xa
    80000f60:	0017e793          	ori	a5,a5,1
    80000f64:	00f93023          	sd	a5,0(s2) # 1000 <_entry-0x7ffff000>
  for(int level = 2; level > 0; level--) {
    80000f68:	3a5d                	addiw	s4,s4,-9
    80000f6a:	036a0063          	beq	s4,s6,80000f8a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f6e:	0149d933          	srl	s2,s3,s4
    80000f72:	1ff97913          	andi	s2,s2,511
    80000f76:	090e                	slli	s2,s2,0x3
    80000f78:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f7a:	00093483          	ld	s1,0(s2)
    80000f7e:	0014f793          	andi	a5,s1,1
    80000f82:	dfd5                	beqz	a5,80000f3e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f84:	80a9                	srli	s1,s1,0xa
    80000f86:	04b2                	slli	s1,s1,0xc
    80000f88:	b7c5                	j	80000f68 <walk+0x60>
  return &pagetable[PX(0, va)];
    80000f8a:	00c9d513          	srli	a0,s3,0xc
    80000f8e:	1ff57513          	andi	a0,a0,511
    80000f92:	050e                	slli	a0,a0,0x3
    80000f94:	9526                	add	a0,a0,s1
}
    80000f96:	70e2                	ld	ra,56(sp)
    80000f98:	7442                	ld	s0,48(sp)
    80000f9a:	74a2                	ld	s1,40(sp)
    80000f9c:	7902                	ld	s2,32(sp)
    80000f9e:	69e2                	ld	s3,24(sp)
    80000fa0:	6a42                	ld	s4,16(sp)
    80000fa2:	6aa2                	ld	s5,8(sp)
    80000fa4:	6b02                	ld	s6,0(sp)
    80000fa6:	6121                	addi	sp,sp,64
    80000fa8:	8082                	ret
        return 0;
    80000faa:	4501                	li	a0,0
    80000fac:	b7ed                	j	80000f96 <walk+0x8e>

0000000080000fae <walkaddr>:
  if(va >= MAXVA)
    80000fae:	57fd                	li	a5,-1
    80000fb0:	83e9                	srli	a5,a5,0x1a
    80000fb2:	00b7f463          	bgeu	a5,a1,80000fba <walkaddr+0xc>
    return 0;
    80000fb6:	4501                	li	a0,0
}
    80000fb8:	8082                	ret
{
    80000fba:	1141                	addi	sp,sp,-16
    80000fbc:	e406                	sd	ra,8(sp)
    80000fbe:	e022                	sd	s0,0(sp)
    80000fc0:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fc2:	4601                	li	a2,0
    80000fc4:	00000097          	auipc	ra,0x0
    80000fc8:	f44080e7          	jalr	-188(ra) # 80000f08 <walk>
  if(pte == 0)
    80000fcc:	c105                	beqz	a0,80000fec <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000fce:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000fd0:	0117f693          	andi	a3,a5,17
    80000fd4:	4745                	li	a4,17
    return 0;
    80000fd6:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000fd8:	00e68663          	beq	a3,a4,80000fe4 <walkaddr+0x36>
}
    80000fdc:	60a2                	ld	ra,8(sp)
    80000fde:	6402                	ld	s0,0(sp)
    80000fe0:	0141                	addi	sp,sp,16
    80000fe2:	8082                	ret
  pa = PTE2PA(*pte);
    80000fe4:	00a7d513          	srli	a0,a5,0xa
    80000fe8:	0532                	slli	a0,a0,0xc
  return pa;
    80000fea:	bfcd                	j	80000fdc <walkaddr+0x2e>
    return 0;
    80000fec:	4501                	li	a0,0
    80000fee:	b7fd                	j	80000fdc <walkaddr+0x2e>

0000000080000ff0 <kvmpa>:
{
    80000ff0:	1101                	addi	sp,sp,-32
    80000ff2:	ec06                	sd	ra,24(sp)
    80000ff4:	e822                	sd	s0,16(sp)
    80000ff6:	e426                	sd	s1,8(sp)
    80000ff8:	1000                	addi	s0,sp,32
    80000ffa:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    80000ffc:	1552                	slli	a0,a0,0x34
    80000ffe:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    80001002:	4601                	li	a2,0
    80001004:	00025517          	auipc	a0,0x25
    80001008:	00c53503          	ld	a0,12(a0) # 80026010 <kernel_pagetable>
    8000100c:	00000097          	auipc	ra,0x0
    80001010:	efc080e7          	jalr	-260(ra) # 80000f08 <walk>
  if(pte == 0)
    80001014:	cd09                	beqz	a0,8000102e <kvmpa+0x3e>
  if((*pte & PTE_V) == 0)
    80001016:	6108                	ld	a0,0(a0)
    80001018:	00157793          	andi	a5,a0,1
    8000101c:	c38d                	beqz	a5,8000103e <kvmpa+0x4e>
  pa = PTE2PA(*pte);
    8000101e:	8129                	srli	a0,a0,0xa
    80001020:	0532                	slli	a0,a0,0xc
}
    80001022:	9526                	add	a0,a0,s1
    80001024:	60e2                	ld	ra,24(sp)
    80001026:	6442                	ld	s0,16(sp)
    80001028:	64a2                	ld	s1,8(sp)
    8000102a:	6105                	addi	sp,sp,32
    8000102c:	8082                	ret
    panic("kvmpa");
    8000102e:	00006517          	auipc	a0,0x6
    80001032:	1ca50513          	addi	a0,a0,458 # 800071f8 <userret+0x168>
    80001036:	fffff097          	auipc	ra,0xfffff
    8000103a:	518080e7          	jalr	1304(ra) # 8000054e <panic>
    panic("kvmpa");
    8000103e:	00006517          	auipc	a0,0x6
    80001042:	1ba50513          	addi	a0,a0,442 # 800071f8 <userret+0x168>
    80001046:	fffff097          	auipc	ra,0xfffff
    8000104a:	508080e7          	jalr	1288(ra) # 8000054e <panic>

000000008000104e <mappages>:
{
    8000104e:	715d                	addi	sp,sp,-80
    80001050:	e486                	sd	ra,72(sp)
    80001052:	e0a2                	sd	s0,64(sp)
    80001054:	fc26                	sd	s1,56(sp)
    80001056:	f84a                	sd	s2,48(sp)
    80001058:	f44e                	sd	s3,40(sp)
    8000105a:	f052                	sd	s4,32(sp)
    8000105c:	ec56                	sd	s5,24(sp)
    8000105e:	e85a                	sd	s6,16(sp)
    80001060:	e45e                	sd	s7,8(sp)
    80001062:	0880                	addi	s0,sp,80
    80001064:	8aaa                	mv	s5,a0
    80001066:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    80001068:	777d                	lui	a4,0xfffff
    8000106a:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000106e:	167d                	addi	a2,a2,-1
    80001070:	00b609b3          	add	s3,a2,a1
    80001074:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001078:	893e                	mv	s2,a5
    8000107a:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    8000107e:	6b85                	lui	s7,0x1
    80001080:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001084:	4605                	li	a2,1
    80001086:	85ca                	mv	a1,s2
    80001088:	8556                	mv	a0,s5
    8000108a:	00000097          	auipc	ra,0x0
    8000108e:	e7e080e7          	jalr	-386(ra) # 80000f08 <walk>
    80001092:	c51d                	beqz	a0,800010c0 <mappages+0x72>
    if(*pte & PTE_V)
    80001094:	611c                	ld	a5,0(a0)
    80001096:	8b85                	andi	a5,a5,1
    80001098:	ef81                	bnez	a5,800010b0 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000109a:	80b1                	srli	s1,s1,0xc
    8000109c:	04aa                	slli	s1,s1,0xa
    8000109e:	0164e4b3          	or	s1,s1,s6
    800010a2:	0014e493          	ori	s1,s1,1
    800010a6:	e104                	sd	s1,0(a0)
    if(a == last)
    800010a8:	03390863          	beq	s2,s3,800010d8 <mappages+0x8a>
    a += PGSIZE;
    800010ac:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010ae:	bfc9                	j	80001080 <mappages+0x32>
      panic("remap");
    800010b0:	00006517          	auipc	a0,0x6
    800010b4:	15050513          	addi	a0,a0,336 # 80007200 <userret+0x170>
    800010b8:	fffff097          	auipc	ra,0xfffff
    800010bc:	496080e7          	jalr	1174(ra) # 8000054e <panic>
      return -1;
    800010c0:	557d                	li	a0,-1
}
    800010c2:	60a6                	ld	ra,72(sp)
    800010c4:	6406                	ld	s0,64(sp)
    800010c6:	74e2                	ld	s1,56(sp)
    800010c8:	7942                	ld	s2,48(sp)
    800010ca:	79a2                	ld	s3,40(sp)
    800010cc:	7a02                	ld	s4,32(sp)
    800010ce:	6ae2                	ld	s5,24(sp)
    800010d0:	6b42                	ld	s6,16(sp)
    800010d2:	6ba2                	ld	s7,8(sp)
    800010d4:	6161                	addi	sp,sp,80
    800010d6:	8082                	ret
  return 0;
    800010d8:	4501                	li	a0,0
    800010da:	b7e5                	j	800010c2 <mappages+0x74>

00000000800010dc <kvmmap>:
{
    800010dc:	1141                	addi	sp,sp,-16
    800010de:	e406                	sd	ra,8(sp)
    800010e0:	e022                	sd	s0,0(sp)
    800010e2:	0800                	addi	s0,sp,16
    800010e4:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800010e6:	86ae                	mv	a3,a1
    800010e8:	85aa                	mv	a1,a0
    800010ea:	00025517          	auipc	a0,0x25
    800010ee:	f2653503          	ld	a0,-218(a0) # 80026010 <kernel_pagetable>
    800010f2:	00000097          	auipc	ra,0x0
    800010f6:	f5c080e7          	jalr	-164(ra) # 8000104e <mappages>
    800010fa:	e509                	bnez	a0,80001104 <kvmmap+0x28>
}
    800010fc:	60a2                	ld	ra,8(sp)
    800010fe:	6402                	ld	s0,0(sp)
    80001100:	0141                	addi	sp,sp,16
    80001102:	8082                	ret
    panic("kvmmap");
    80001104:	00006517          	auipc	a0,0x6
    80001108:	10450513          	addi	a0,a0,260 # 80007208 <userret+0x178>
    8000110c:	fffff097          	auipc	ra,0xfffff
    80001110:	442080e7          	jalr	1090(ra) # 8000054e <panic>

0000000080001114 <kvminit>:
{
    80001114:	1101                	addi	sp,sp,-32
    80001116:	ec06                	sd	ra,24(sp)
    80001118:	e822                	sd	s0,16(sp)
    8000111a:	e426                	sd	s1,8(sp)
    8000111c:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    8000111e:	00000097          	auipc	ra,0x0
    80001122:	842080e7          	jalr	-1982(ra) # 80000960 <kalloc>
    80001126:	00025797          	auipc	a5,0x25
    8000112a:	eea7b523          	sd	a0,-278(a5) # 80026010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    8000112e:	6605                	lui	a2,0x1
    80001130:	4581                	li	a1,0
    80001132:	00000097          	auipc	ra,0x0
    80001136:	a3c080e7          	jalr	-1476(ra) # 80000b6e <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000113a:	4699                	li	a3,6
    8000113c:	6605                	lui	a2,0x1
    8000113e:	100005b7          	lui	a1,0x10000
    80001142:	10000537          	lui	a0,0x10000
    80001146:	00000097          	auipc	ra,0x0
    8000114a:	f96080e7          	jalr	-106(ra) # 800010dc <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000114e:	4699                	li	a3,6
    80001150:	6605                	lui	a2,0x1
    80001152:	100015b7          	lui	a1,0x10001
    80001156:	10001537          	lui	a0,0x10001
    8000115a:	00000097          	auipc	ra,0x0
    8000115e:	f82080e7          	jalr	-126(ra) # 800010dc <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001162:	4699                	li	a3,6
    80001164:	6641                	lui	a2,0x10
    80001166:	020005b7          	lui	a1,0x2000
    8000116a:	02000537          	lui	a0,0x2000
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	f6e080e7          	jalr	-146(ra) # 800010dc <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001176:	4699                	li	a3,6
    80001178:	00400637          	lui	a2,0x400
    8000117c:	0c0005b7          	lui	a1,0xc000
    80001180:	0c000537          	lui	a0,0xc000
    80001184:	00000097          	auipc	ra,0x0
    80001188:	f58080e7          	jalr	-168(ra) # 800010dc <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000118c:	00007497          	auipc	s1,0x7
    80001190:	e7448493          	addi	s1,s1,-396 # 80008000 <initcode>
    80001194:	46a9                	li	a3,10
    80001196:	80007617          	auipc	a2,0x80007
    8000119a:	e6a60613          	addi	a2,a2,-406 # 8000 <_entry-0x7fff8000>
    8000119e:	4585                	li	a1,1
    800011a0:	05fe                	slli	a1,a1,0x1f
    800011a2:	852e                	mv	a0,a1
    800011a4:	00000097          	auipc	ra,0x0
    800011a8:	f38080e7          	jalr	-200(ra) # 800010dc <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011ac:	4699                	li	a3,6
    800011ae:	4645                	li	a2,17
    800011b0:	066e                	slli	a2,a2,0x1b
    800011b2:	8e05                	sub	a2,a2,s1
    800011b4:	85a6                	mv	a1,s1
    800011b6:	8526                	mv	a0,s1
    800011b8:	00000097          	auipc	ra,0x0
    800011bc:	f24080e7          	jalr	-220(ra) # 800010dc <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011c0:	46a9                	li	a3,10
    800011c2:	6605                	lui	a2,0x1
    800011c4:	00006597          	auipc	a1,0x6
    800011c8:	e3c58593          	addi	a1,a1,-452 # 80007000 <trampoline>
    800011cc:	04000537          	lui	a0,0x4000
    800011d0:	157d                	addi	a0,a0,-1
    800011d2:	0532                	slli	a0,a0,0xc
    800011d4:	00000097          	auipc	ra,0x0
    800011d8:	f08080e7          	jalr	-248(ra) # 800010dc <kvmmap>
}
    800011dc:	60e2                	ld	ra,24(sp)
    800011de:	6442                	ld	s0,16(sp)
    800011e0:	64a2                	ld	s1,8(sp)
    800011e2:	6105                	addi	sp,sp,32
    800011e4:	8082                	ret

00000000800011e6 <uvmunmap>:
{
    800011e6:	715d                	addi	sp,sp,-80
    800011e8:	e486                	sd	ra,72(sp)
    800011ea:	e0a2                	sd	s0,64(sp)
    800011ec:	fc26                	sd	s1,56(sp)
    800011ee:	f84a                	sd	s2,48(sp)
    800011f0:	f44e                	sd	s3,40(sp)
    800011f2:	f052                	sd	s4,32(sp)
    800011f4:	ec56                	sd	s5,24(sp)
    800011f6:	e85a                	sd	s6,16(sp)
    800011f8:	e45e                	sd	s7,8(sp)
    800011fa:	0880                	addi	s0,sp,80
    800011fc:	8a2a                	mv	s4,a0
    800011fe:	8ab6                	mv	s5,a3
  a = PGROUNDDOWN(va);
    80001200:	77fd                	lui	a5,0xfffff
    80001202:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80001206:	167d                	addi	a2,a2,-1
    80001208:	00b609b3          	add	s3,a2,a1
    8000120c:	00f9f9b3          	and	s3,s3,a5
    if(PTE_FLAGS(*pte) == PTE_V)
    80001210:	4b05                	li	s6,1
    a += PGSIZE;
    80001212:	6b85                	lui	s7,0x1
    80001214:	a0a1                	j	8000125c <uvmunmap+0x76>
      panic("uvmunmap: walk");
    80001216:	00006517          	auipc	a0,0x6
    8000121a:	ffa50513          	addi	a0,a0,-6 # 80007210 <userret+0x180>
    8000121e:	fffff097          	auipc	ra,0xfffff
    80001222:	330080e7          	jalr	816(ra) # 8000054e <panic>
      panic("uvmunmap: not mapped");
    80001226:	00006517          	auipc	a0,0x6
    8000122a:	ffa50513          	addi	a0,a0,-6 # 80007220 <userret+0x190>
    8000122e:	fffff097          	auipc	ra,0xfffff
    80001232:	320080e7          	jalr	800(ra) # 8000054e <panic>
      panic("uvmunmap: not a leaf");
    80001236:	00006517          	auipc	a0,0x6
    8000123a:	00250513          	addi	a0,a0,2 # 80007238 <userret+0x1a8>
    8000123e:	fffff097          	auipc	ra,0xfffff
    80001242:	310080e7          	jalr	784(ra) # 8000054e <panic>
      pa = PTE2PA(*pte);
    80001246:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001248:	0532                	slli	a0,a0,0xc
    8000124a:	fffff097          	auipc	ra,0xfffff
    8000124e:	61a080e7          	jalr	1562(ra) # 80000864 <kfree>
    *pte = 0;
    80001252:	0004b023          	sd	zero,0(s1)
    if(a == last)
    80001256:	03390763          	beq	s2,s3,80001284 <uvmunmap+0x9e>
    a += PGSIZE;
    8000125a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 0)) == 0)
    8000125c:	4601                	li	a2,0
    8000125e:	85ca                	mv	a1,s2
    80001260:	8552                	mv	a0,s4
    80001262:	00000097          	auipc	ra,0x0
    80001266:	ca6080e7          	jalr	-858(ra) # 80000f08 <walk>
    8000126a:	84aa                	mv	s1,a0
    8000126c:	d54d                	beqz	a0,80001216 <uvmunmap+0x30>
    if((*pte & PTE_V) == 0){
    8000126e:	6108                	ld	a0,0(a0)
    80001270:	00157793          	andi	a5,a0,1
    80001274:	dbcd                	beqz	a5,80001226 <uvmunmap+0x40>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001276:	3ff57793          	andi	a5,a0,1023
    8000127a:	fb678ee3          	beq	a5,s6,80001236 <uvmunmap+0x50>
    if(do_free){
    8000127e:	fc0a8ae3          	beqz	s5,80001252 <uvmunmap+0x6c>
    80001282:	b7d1                	j	80001246 <uvmunmap+0x60>
}
    80001284:	60a6                	ld	ra,72(sp)
    80001286:	6406                	ld	s0,64(sp)
    80001288:	74e2                	ld	s1,56(sp)
    8000128a:	7942                	ld	s2,48(sp)
    8000128c:	79a2                	ld	s3,40(sp)
    8000128e:	7a02                	ld	s4,32(sp)
    80001290:	6ae2                	ld	s5,24(sp)
    80001292:	6b42                	ld	s6,16(sp)
    80001294:	6ba2                	ld	s7,8(sp)
    80001296:	6161                	addi	sp,sp,80
    80001298:	8082                	ret

000000008000129a <uvmcreate>:
{
    8000129a:	1101                	addi	sp,sp,-32
    8000129c:	ec06                	sd	ra,24(sp)
    8000129e:	e822                	sd	s0,16(sp)
    800012a0:	e426                	sd	s1,8(sp)
    800012a2:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    800012a4:	fffff097          	auipc	ra,0xfffff
    800012a8:	6bc080e7          	jalr	1724(ra) # 80000960 <kalloc>
  if(pagetable == 0)
    800012ac:	cd11                	beqz	a0,800012c8 <uvmcreate+0x2e>
    800012ae:	84aa                	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
    800012b0:	6605                	lui	a2,0x1
    800012b2:	4581                	li	a1,0
    800012b4:	00000097          	auipc	ra,0x0
    800012b8:	8ba080e7          	jalr	-1862(ra) # 80000b6e <memset>
}
    800012bc:	8526                	mv	a0,s1
    800012be:	60e2                	ld	ra,24(sp)
    800012c0:	6442                	ld	s0,16(sp)
    800012c2:	64a2                	ld	s1,8(sp)
    800012c4:	6105                	addi	sp,sp,32
    800012c6:	8082                	ret
    panic("uvmcreate: out of memory");
    800012c8:	00006517          	auipc	a0,0x6
    800012cc:	f8850513          	addi	a0,a0,-120 # 80007250 <userret+0x1c0>
    800012d0:	fffff097          	auipc	ra,0xfffff
    800012d4:	27e080e7          	jalr	638(ra) # 8000054e <panic>

00000000800012d8 <uvminit>:
{
    800012d8:	7179                	addi	sp,sp,-48
    800012da:	f406                	sd	ra,40(sp)
    800012dc:	f022                	sd	s0,32(sp)
    800012de:	ec26                	sd	s1,24(sp)
    800012e0:	e84a                	sd	s2,16(sp)
    800012e2:	e44e                	sd	s3,8(sp)
    800012e4:	e052                	sd	s4,0(sp)
    800012e6:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    800012e8:	6785                	lui	a5,0x1
    800012ea:	04f67863          	bgeu	a2,a5,8000133a <uvminit+0x62>
    800012ee:	8a2a                	mv	s4,a0
    800012f0:	89ae                	mv	s3,a1
    800012f2:	84b2                	mv	s1,a2
  mem = kalloc();
    800012f4:	fffff097          	auipc	ra,0xfffff
    800012f8:	66c080e7          	jalr	1644(ra) # 80000960 <kalloc>
    800012fc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012fe:	6605                	lui	a2,0x1
    80001300:	4581                	li	a1,0
    80001302:	00000097          	auipc	ra,0x0
    80001306:	86c080e7          	jalr	-1940(ra) # 80000b6e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000130a:	4779                	li	a4,30
    8000130c:	86ca                	mv	a3,s2
    8000130e:	6605                	lui	a2,0x1
    80001310:	4581                	li	a1,0
    80001312:	8552                	mv	a0,s4
    80001314:	00000097          	auipc	ra,0x0
    80001318:	d3a080e7          	jalr	-710(ra) # 8000104e <mappages>
  memmove(mem, src, sz);
    8000131c:	8626                	mv	a2,s1
    8000131e:	85ce                	mv	a1,s3
    80001320:	854a                	mv	a0,s2
    80001322:	00000097          	auipc	ra,0x0
    80001326:	8ac080e7          	jalr	-1876(ra) # 80000bce <memmove>
}
    8000132a:	70a2                	ld	ra,40(sp)
    8000132c:	7402                	ld	s0,32(sp)
    8000132e:	64e2                	ld	s1,24(sp)
    80001330:	6942                	ld	s2,16(sp)
    80001332:	69a2                	ld	s3,8(sp)
    80001334:	6a02                	ld	s4,0(sp)
    80001336:	6145                	addi	sp,sp,48
    80001338:	8082                	ret
    panic("inituvm: more than a page");
    8000133a:	00006517          	auipc	a0,0x6
    8000133e:	f3650513          	addi	a0,a0,-202 # 80007270 <userret+0x1e0>
    80001342:	fffff097          	auipc	ra,0xfffff
    80001346:	20c080e7          	jalr	524(ra) # 8000054e <panic>

000000008000134a <uvmdealloc>:
{
    8000134a:	1101                	addi	sp,sp,-32
    8000134c:	ec06                	sd	ra,24(sp)
    8000134e:	e822                	sd	s0,16(sp)
    80001350:	e426                	sd	s1,8(sp)
    80001352:	1000                	addi	s0,sp,32
    return oldsz;
    80001354:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001356:	00b67d63          	bgeu	a2,a1,80001370 <uvmdealloc+0x26>
    8000135a:	84b2                	mv	s1,a2
  uint64 newup = PGROUNDUP(newsz);
    8000135c:	6785                	lui	a5,0x1
    8000135e:	17fd                	addi	a5,a5,-1
    80001360:	00f60733          	add	a4,a2,a5
    80001364:	76fd                	lui	a3,0xfffff
    80001366:	8f75                	and	a4,a4,a3
  if(newup < PGROUNDUP(oldsz)){
    80001368:	97ae                	add	a5,a5,a1
    8000136a:	8ff5                	and	a5,a5,a3
    8000136c:	00f76863          	bltu	a4,a5,8000137c <uvmdealloc+0x32>
}
    80001370:	8526                	mv	a0,s1
    80001372:	60e2                	ld	ra,24(sp)
    80001374:	6442                	ld	s0,16(sp)
    80001376:	64a2                	ld	s1,8(sp)
    80001378:	6105                	addi	sp,sp,32
    8000137a:	8082                	ret
    uvmunmap(pagetable, newup, oldsz - newup, 1);
    8000137c:	4685                	li	a3,1
    8000137e:	40e58633          	sub	a2,a1,a4
    80001382:	85ba                	mv	a1,a4
    80001384:	00000097          	auipc	ra,0x0
    80001388:	e62080e7          	jalr	-414(ra) # 800011e6 <uvmunmap>
    8000138c:	b7d5                	j	80001370 <uvmdealloc+0x26>

000000008000138e <uvmalloc>:
  if(newsz < oldsz)
    8000138e:	0ab66163          	bltu	a2,a1,80001430 <uvmalloc+0xa2>
{
    80001392:	7139                	addi	sp,sp,-64
    80001394:	fc06                	sd	ra,56(sp)
    80001396:	f822                	sd	s0,48(sp)
    80001398:	f426                	sd	s1,40(sp)
    8000139a:	f04a                	sd	s2,32(sp)
    8000139c:	ec4e                	sd	s3,24(sp)
    8000139e:	e852                	sd	s4,16(sp)
    800013a0:	e456                	sd	s5,8(sp)
    800013a2:	0080                	addi	s0,sp,64
    800013a4:	8aaa                	mv	s5,a0
    800013a6:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);  //PGROUNDUP(sz)  (((sz)+PGSIZE-1) & ~(PGSIZE-1))
    800013a8:	6985                	lui	s3,0x1
    800013aa:	19fd                	addi	s3,s3,-1
    800013ac:	95ce                	add	a1,a1,s3
    800013ae:	79fd                	lui	s3,0xfffff
    800013b0:	0135f9b3          	and	s3,a1,s3
  for(; a < newsz; a += PGSIZE){
    800013b4:	08c9f063          	bgeu	s3,a2,80001434 <uvmalloc+0xa6>
  a = oldsz;
    800013b8:	894e                	mv	s2,s3
    mem = kalloc();
    800013ba:	fffff097          	auipc	ra,0xfffff
    800013be:	5a6080e7          	jalr	1446(ra) # 80000960 <kalloc>
    800013c2:	84aa                	mv	s1,a0
    if(mem == 0){
    800013c4:	c51d                	beqz	a0,800013f2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800013c6:	6605                	lui	a2,0x1
    800013c8:	4581                	li	a1,0
    800013ca:	fffff097          	auipc	ra,0xfffff
    800013ce:	7a4080e7          	jalr	1956(ra) # 80000b6e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){  //mappages(pagetable, va, sz, pa, perm)
    800013d2:	4779                	li	a4,30
    800013d4:	86a6                	mv	a3,s1
    800013d6:	6605                	lui	a2,0x1
    800013d8:	85ca                	mv	a1,s2
    800013da:	8556                	mv	a0,s5
    800013dc:	00000097          	auipc	ra,0x0
    800013e0:	c72080e7          	jalr	-910(ra) # 8000104e <mappages>
    800013e4:	e905                	bnez	a0,80001414 <uvmalloc+0x86>
  for(; a < newsz; a += PGSIZE){
    800013e6:	6785                	lui	a5,0x1
    800013e8:	993e                	add	s2,s2,a5
    800013ea:	fd4968e3          	bltu	s2,s4,800013ba <uvmalloc+0x2c>
  return newsz;
    800013ee:	8552                	mv	a0,s4
    800013f0:	a809                	j	80001402 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800013f2:	864e                	mv	a2,s3
    800013f4:	85ca                	mv	a1,s2
    800013f6:	8556                	mv	a0,s5
    800013f8:	00000097          	auipc	ra,0x0
    800013fc:	f52080e7          	jalr	-174(ra) # 8000134a <uvmdealloc>
      return 0;
    80001400:	4501                	li	a0,0
}
    80001402:	70e2                	ld	ra,56(sp)
    80001404:	7442                	ld	s0,48(sp)
    80001406:	74a2                	ld	s1,40(sp)
    80001408:	7902                	ld	s2,32(sp)
    8000140a:	69e2                	ld	s3,24(sp)
    8000140c:	6a42                	ld	s4,16(sp)
    8000140e:	6aa2                	ld	s5,8(sp)
    80001410:	6121                	addi	sp,sp,64
    80001412:	8082                	ret
      kfree(mem);
    80001414:	8526                	mv	a0,s1
    80001416:	fffff097          	auipc	ra,0xfffff
    8000141a:	44e080e7          	jalr	1102(ra) # 80000864 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000141e:	864e                	mv	a2,s3
    80001420:	85ca                	mv	a1,s2
    80001422:	8556                	mv	a0,s5
    80001424:	00000097          	auipc	ra,0x0
    80001428:	f26080e7          	jalr	-218(ra) # 8000134a <uvmdealloc>
      return 0;
    8000142c:	4501                	li	a0,0
    8000142e:	bfd1                	j	80001402 <uvmalloc+0x74>
    return oldsz;
    80001430:	852e                	mv	a0,a1
}
    80001432:	8082                	ret
  return newsz;
    80001434:	8532                	mv	a0,a2
    80001436:	b7f1                	j	80001402 <uvmalloc+0x74>

0000000080001438 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001438:	1101                	addi	sp,sp,-32
    8000143a:	ec06                	sd	ra,24(sp)
    8000143c:	e822                	sd	s0,16(sp)
    8000143e:	e426                	sd	s1,8(sp)
    80001440:	1000                	addi	s0,sp,32
    80001442:	84aa                	mv	s1,a0
    80001444:	862e                	mv	a2,a1
  //printf("uvmunmap wrong here b\n");
  uvmunmap(pagetable, PGSIZE, sz, 1);//uvmunmap(pagetable, 0, sz, 1);
    80001446:	4685                	li	a3,1
    80001448:	6585                	lui	a1,0x1
    8000144a:	00000097          	auipc	ra,0x0
    8000144e:	d9c080e7          	jalr	-612(ra) # 800011e6 <uvmunmap>
  freewalk(pagetable);
    80001452:	8526                	mv	a0,s1
    80001454:	00000097          	auipc	ra,0x0
    80001458:	a12080e7          	jalr	-1518(ra) # 80000e66 <freewalk>
}
    8000145c:	60e2                	ld	ra,24(sp)
    8000145e:	6442                	ld	s0,16(sp)
    80001460:	64a2                	ld	s1,8(sp)
    80001462:	6105                	addi	sp,sp,32
    80001464:	8082                	ret

0000000080001466 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = PGSIZE; i < sz; i += PGSIZE){//0 or PGSIZE; p3, start from PGSIZE since the 0-4095 not mapped
    80001466:	6785                	lui	a5,0x1
    80001468:	0cc7ff63          	bgeu	a5,a2,80001546 <uvmcopy+0xe0>
{
    8000146c:	715d                	addi	sp,sp,-80
    8000146e:	e486                	sd	ra,72(sp)
    80001470:	e0a2                	sd	s0,64(sp)
    80001472:	fc26                	sd	s1,56(sp)
    80001474:	f84a                	sd	s2,48(sp)
    80001476:	f44e                	sd	s3,40(sp)
    80001478:	f052                	sd	s4,32(sp)
    8000147a:	ec56                	sd	s5,24(sp)
    8000147c:	e85a                	sd	s6,16(sp)
    8000147e:	e45e                	sd	s7,8(sp)
    80001480:	0880                	addi	s0,sp,80
    80001482:	8b2a                	mv	s6,a0
    80001484:	8aae                	mv	s5,a1
    80001486:	8a32                	mv	s4,a2
  for(i = PGSIZE; i < sz; i += PGSIZE){//0 or PGSIZE; p3, start from PGSIZE since the 0-4095 not mapped
    80001488:	6985                	lui	s3,0x1
    if((pte = walk(old, i, 0)) == 0)
    8000148a:	4601                	li	a2,0
    8000148c:	85ce                	mv	a1,s3
    8000148e:	855a                	mv	a0,s6
    80001490:	00000097          	auipc	ra,0x0
    80001494:	a78080e7          	jalr	-1416(ra) # 80000f08 <walk>
    80001498:	c531                	beqz	a0,800014e4 <uvmcopy+0x7e>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0){
    8000149a:	6118                	ld	a4,0(a0)
    8000149c:	00177793          	andi	a5,a4,1
    800014a0:	cbb1                	beqz	a5,800014f4 <uvmcopy+0x8e>
      //printf("*pte:%p\n", *pte); //p3
      panic("uvmcopy: page not present");
    }
    pa = PTE2PA(*pte);
    800014a2:	00a75593          	srli	a1,a4,0xa
    800014a6:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014aa:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014ae:	fffff097          	auipc	ra,0xfffff
    800014b2:	4b2080e7          	jalr	1202(ra) # 80000960 <kalloc>
    800014b6:	892a                	mv	s2,a0
    800014b8:	c939                	beqz	a0,8000150e <uvmcopy+0xa8>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014ba:	6605                	lui	a2,0x1
    800014bc:	85de                	mv	a1,s7
    800014be:	fffff097          	auipc	ra,0xfffff
    800014c2:	710080e7          	jalr	1808(ra) # 80000bce <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014c6:	8726                	mv	a4,s1
    800014c8:	86ca                	mv	a3,s2
    800014ca:	6605                	lui	a2,0x1
    800014cc:	85ce                	mv	a1,s3
    800014ce:	8556                	mv	a0,s5
    800014d0:	00000097          	auipc	ra,0x0
    800014d4:	b7e080e7          	jalr	-1154(ra) # 8000104e <mappages>
    800014d8:	e515                	bnez	a0,80001504 <uvmcopy+0x9e>
  for(i = PGSIZE; i < sz; i += PGSIZE){//0 or PGSIZE; p3, start from PGSIZE since the 0-4095 not mapped
    800014da:	6785                	lui	a5,0x1
    800014dc:	99be                	add	s3,s3,a5
    800014de:	fb49e6e3          	bltu	s3,s4,8000148a <uvmcopy+0x24>
    800014e2:	a0b9                	j	80001530 <uvmcopy+0xca>
      panic("uvmcopy: pte should exist");
    800014e4:	00006517          	auipc	a0,0x6
    800014e8:	dac50513          	addi	a0,a0,-596 # 80007290 <userret+0x200>
    800014ec:	fffff097          	auipc	ra,0xfffff
    800014f0:	062080e7          	jalr	98(ra) # 8000054e <panic>
      panic("uvmcopy: page not present");
    800014f4:	00006517          	auipc	a0,0x6
    800014f8:	dbc50513          	addi	a0,a0,-580 # 800072b0 <userret+0x220>
    800014fc:	fffff097          	auipc	ra,0xfffff
    80001500:	052080e7          	jalr	82(ra) # 8000054e <panic>
      kfree(mem);
    80001504:	854a                	mv	a0,s2
    80001506:	fffff097          	auipc	ra,0xfffff
    8000150a:	35e080e7          	jalr	862(ra) # 80000864 <kfree>
    }
  }
  return 0;

 err:
  printf("uvmunmap wrong here c\n");
    8000150e:	00006517          	auipc	a0,0x6
    80001512:	dc250513          	addi	a0,a0,-574 # 800072d0 <userret+0x240>
    80001516:	fffff097          	auipc	ra,0xfffff
    8000151a:	082080e7          	jalr	130(ra) # 80000598 <printf>
  uvmunmap(new, 0, i, 1);
    8000151e:	4685                	li	a3,1
    80001520:	864e                	mv	a2,s3
    80001522:	4581                	li	a1,0
    80001524:	8556                	mv	a0,s5
    80001526:	00000097          	auipc	ra,0x0
    8000152a:	cc0080e7          	jalr	-832(ra) # 800011e6 <uvmunmap>
  return -1;
    8000152e:	557d                	li	a0,-1
}
    80001530:	60a6                	ld	ra,72(sp)
    80001532:	6406                	ld	s0,64(sp)
    80001534:	74e2                	ld	s1,56(sp)
    80001536:	7942                	ld	s2,48(sp)
    80001538:	79a2                	ld	s3,40(sp)
    8000153a:	7a02                	ld	s4,32(sp)
    8000153c:	6ae2                	ld	s5,24(sp)
    8000153e:	6b42                	ld	s6,16(sp)
    80001540:	6ba2                	ld	s7,8(sp)
    80001542:	6161                	addi	sp,sp,80
    80001544:	8082                	ret
  return 0;
    80001546:	4501                	li	a0,0
}
    80001548:	8082                	ret

000000008000154a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000154a:	1141                	addi	sp,sp,-16
    8000154c:	e406                	sd	ra,8(sp)
    8000154e:	e022                	sd	s0,0(sp)
    80001550:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001552:	4601                	li	a2,0
    80001554:	00000097          	auipc	ra,0x0
    80001558:	9b4080e7          	jalr	-1612(ra) # 80000f08 <walk>
  if(pte == 0)
    8000155c:	c901                	beqz	a0,8000156c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000155e:	611c                	ld	a5,0(a0)
    80001560:	9bbd                	andi	a5,a5,-17
    80001562:	e11c                	sd	a5,0(a0)
}
    80001564:	60a2                	ld	ra,8(sp)
    80001566:	6402                	ld	s0,0(sp)
    80001568:	0141                	addi	sp,sp,16
    8000156a:	8082                	ret
    panic("uvmclear");
    8000156c:	00006517          	auipc	a0,0x6
    80001570:	d7c50513          	addi	a0,a0,-644 # 800072e8 <userret+0x258>
    80001574:	fffff097          	auipc	ra,0xfffff
    80001578:	fda080e7          	jalr	-38(ra) # 8000054e <panic>

000000008000157c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000157c:	c6bd                	beqz	a3,800015ea <copyout+0x6e>
{
    8000157e:	715d                	addi	sp,sp,-80
    80001580:	e486                	sd	ra,72(sp)
    80001582:	e0a2                	sd	s0,64(sp)
    80001584:	fc26                	sd	s1,56(sp)
    80001586:	f84a                	sd	s2,48(sp)
    80001588:	f44e                	sd	s3,40(sp)
    8000158a:	f052                	sd	s4,32(sp)
    8000158c:	ec56                	sd	s5,24(sp)
    8000158e:	e85a                	sd	s6,16(sp)
    80001590:	e45e                	sd	s7,8(sp)
    80001592:	e062                	sd	s8,0(sp)
    80001594:	0880                	addi	s0,sp,80
    80001596:	8b2a                	mv	s6,a0
    80001598:	8c2e                	mv	s8,a1
    8000159a:	8a32                	mv	s4,a2
    8000159c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000159e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800015a0:	6a85                	lui	s5,0x1
    800015a2:	a015                	j	800015c6 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015a4:	9562                	add	a0,a0,s8
    800015a6:	0004861b          	sext.w	a2,s1
    800015aa:	85d2                	mv	a1,s4
    800015ac:	41250533          	sub	a0,a0,s2
    800015b0:	fffff097          	auipc	ra,0xfffff
    800015b4:	61e080e7          	jalr	1566(ra) # 80000bce <memmove>

    len -= n;
    800015b8:	409989b3          	sub	s3,s3,s1
    src += n;
    800015bc:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800015be:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800015c2:	02098263          	beqz	s3,800015e6 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800015c6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800015ca:	85ca                	mv	a1,s2
    800015cc:	855a                	mv	a0,s6
    800015ce:	00000097          	auipc	ra,0x0
    800015d2:	9e0080e7          	jalr	-1568(ra) # 80000fae <walkaddr>
    if(pa0 == 0)
    800015d6:	cd01                	beqz	a0,800015ee <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800015d8:	418904b3          	sub	s1,s2,s8
    800015dc:	94d6                	add	s1,s1,s5
    if(n > len)
    800015de:	fc99f3e3          	bgeu	s3,s1,800015a4 <copyout+0x28>
    800015e2:	84ce                	mv	s1,s3
    800015e4:	b7c1                	j	800015a4 <copyout+0x28>
  }
  return 0;
    800015e6:	4501                	li	a0,0
    800015e8:	a021                	j	800015f0 <copyout+0x74>
    800015ea:	4501                	li	a0,0
}
    800015ec:	8082                	ret
      return -1;
    800015ee:	557d                	li	a0,-1
}
    800015f0:	60a6                	ld	ra,72(sp)
    800015f2:	6406                	ld	s0,64(sp)
    800015f4:	74e2                	ld	s1,56(sp)
    800015f6:	7942                	ld	s2,48(sp)
    800015f8:	79a2                	ld	s3,40(sp)
    800015fa:	7a02                	ld	s4,32(sp)
    800015fc:	6ae2                	ld	s5,24(sp)
    800015fe:	6b42                	ld	s6,16(sp)
    80001600:	6ba2                	ld	s7,8(sp)
    80001602:	6c02                	ld	s8,0(sp)
    80001604:	6161                	addi	sp,sp,80
    80001606:	8082                	ret

0000000080001608 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001608:	c6bd                	beqz	a3,80001676 <copyin+0x6e>
{
    8000160a:	715d                	addi	sp,sp,-80
    8000160c:	e486                	sd	ra,72(sp)
    8000160e:	e0a2                	sd	s0,64(sp)
    80001610:	fc26                	sd	s1,56(sp)
    80001612:	f84a                	sd	s2,48(sp)
    80001614:	f44e                	sd	s3,40(sp)
    80001616:	f052                	sd	s4,32(sp)
    80001618:	ec56                	sd	s5,24(sp)
    8000161a:	e85a                	sd	s6,16(sp)
    8000161c:	e45e                	sd	s7,8(sp)
    8000161e:	e062                	sd	s8,0(sp)
    80001620:	0880                	addi	s0,sp,80
    80001622:	8b2a                	mv	s6,a0
    80001624:	8a2e                	mv	s4,a1
    80001626:	8c32                	mv	s8,a2
    80001628:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000162a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000162c:	6a85                	lui	s5,0x1
    8000162e:	a015                	j	80001652 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001630:	9562                	add	a0,a0,s8
    80001632:	0004861b          	sext.w	a2,s1
    80001636:	412505b3          	sub	a1,a0,s2
    8000163a:	8552                	mv	a0,s4
    8000163c:	fffff097          	auipc	ra,0xfffff
    80001640:	592080e7          	jalr	1426(ra) # 80000bce <memmove>

    len -= n;
    80001644:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001648:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000164a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000164e:	02098263          	beqz	s3,80001672 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80001652:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001656:	85ca                	mv	a1,s2
    80001658:	855a                	mv	a0,s6
    8000165a:	00000097          	auipc	ra,0x0
    8000165e:	954080e7          	jalr	-1708(ra) # 80000fae <walkaddr>
    if(pa0 == 0)
    80001662:	cd01                	beqz	a0,8000167a <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80001664:	418904b3          	sub	s1,s2,s8
    80001668:	94d6                	add	s1,s1,s5
    if(n > len)
    8000166a:	fc99f3e3          	bgeu	s3,s1,80001630 <copyin+0x28>
    8000166e:	84ce                	mv	s1,s3
    80001670:	b7c1                	j	80001630 <copyin+0x28>
  }
  return 0;
    80001672:	4501                	li	a0,0
    80001674:	a021                	j	8000167c <copyin+0x74>
    80001676:	4501                	li	a0,0
}
    80001678:	8082                	ret
      return -1;
    8000167a:	557d                	li	a0,-1
}
    8000167c:	60a6                	ld	ra,72(sp)
    8000167e:	6406                	ld	s0,64(sp)
    80001680:	74e2                	ld	s1,56(sp)
    80001682:	7942                	ld	s2,48(sp)
    80001684:	79a2                	ld	s3,40(sp)
    80001686:	7a02                	ld	s4,32(sp)
    80001688:	6ae2                	ld	s5,24(sp)
    8000168a:	6b42                	ld	s6,16(sp)
    8000168c:	6ba2                	ld	s7,8(sp)
    8000168e:	6c02                	ld	s8,0(sp)
    80001690:	6161                	addi	sp,sp,80
    80001692:	8082                	ret

0000000080001694 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001694:	c6c5                	beqz	a3,8000173c <copyinstr+0xa8>
{
    80001696:	715d                	addi	sp,sp,-80
    80001698:	e486                	sd	ra,72(sp)
    8000169a:	e0a2                	sd	s0,64(sp)
    8000169c:	fc26                	sd	s1,56(sp)
    8000169e:	f84a                	sd	s2,48(sp)
    800016a0:	f44e                	sd	s3,40(sp)
    800016a2:	f052                	sd	s4,32(sp)
    800016a4:	ec56                	sd	s5,24(sp)
    800016a6:	e85a                	sd	s6,16(sp)
    800016a8:	e45e                	sd	s7,8(sp)
    800016aa:	0880                	addi	s0,sp,80
    800016ac:	8a2a                	mv	s4,a0
    800016ae:	8b2e                	mv	s6,a1
    800016b0:	8bb2                	mv	s7,a2
    800016b2:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800016b4:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016b6:	6985                	lui	s3,0x1
    800016b8:	a035                	j	800016e4 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016ba:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016be:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016c0:	0017b793          	seqz	a5,a5
    800016c4:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016c8:	60a6                	ld	ra,72(sp)
    800016ca:	6406                	ld	s0,64(sp)
    800016cc:	74e2                	ld	s1,56(sp)
    800016ce:	7942                	ld	s2,48(sp)
    800016d0:	79a2                	ld	s3,40(sp)
    800016d2:	7a02                	ld	s4,32(sp)
    800016d4:	6ae2                	ld	s5,24(sp)
    800016d6:	6b42                	ld	s6,16(sp)
    800016d8:	6ba2                	ld	s7,8(sp)
    800016da:	6161                	addi	sp,sp,80
    800016dc:	8082                	ret
    srcva = va0 + PGSIZE;
    800016de:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800016e2:	c8a9                	beqz	s1,80001734 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800016e4:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800016e8:	85ca                	mv	a1,s2
    800016ea:	8552                	mv	a0,s4
    800016ec:	00000097          	auipc	ra,0x0
    800016f0:	8c2080e7          	jalr	-1854(ra) # 80000fae <walkaddr>
    if(pa0 == 0)
    800016f4:	c131                	beqz	a0,80001738 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800016f6:	41790833          	sub	a6,s2,s7
    800016fa:	984e                	add	a6,a6,s3
    if(n > max)
    800016fc:	0104f363          	bgeu	s1,a6,80001702 <copyinstr+0x6e>
    80001700:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001702:	955e                	add	a0,a0,s7
    80001704:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001708:	fc080be3          	beqz	a6,800016de <copyinstr+0x4a>
    8000170c:	985a                	add	a6,a6,s6
    8000170e:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001710:	41650633          	sub	a2,a0,s6
    80001714:	14fd                	addi	s1,s1,-1
    80001716:	9b26                	add	s6,s6,s1
    80001718:	00f60733          	add	a4,a2,a5
    8000171c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8fdc>
    80001720:	df49                	beqz	a4,800016ba <copyinstr+0x26>
        *dst = *p;
    80001722:	00e78023          	sb	a4,0(a5)
      --max;
    80001726:	40fb04b3          	sub	s1,s6,a5
      dst++;
    8000172a:	0785                	addi	a5,a5,1
    while(n > 0){
    8000172c:	ff0796e3          	bne	a5,a6,80001718 <copyinstr+0x84>
      dst++;
    80001730:	8b42                	mv	s6,a6
    80001732:	b775                	j	800016de <copyinstr+0x4a>
    80001734:	4781                	li	a5,0
    80001736:	b769                	j	800016c0 <copyinstr+0x2c>
      return -1;
    80001738:	557d                	li	a0,-1
    8000173a:	b779                	j	800016c8 <copyinstr+0x34>
  int got_null = 0;
    8000173c:	4781                	li	a5,0
  if(got_null){
    8000173e:	0017b793          	seqz	a5,a5
    80001742:	40f00533          	neg	a0,a5
}
    80001746:	8082                	ret

0000000080001748 <mprotect>:


int
mprotect(uint64 va, int len)
{
    80001748:	7139                	addi	sp,sp,-64
    8000174a:	fc06                	sd	ra,56(sp)
    8000174c:	f822                	sd	s0,48(sp)
    8000174e:	f426                	sd	s1,40(sp)
    80001750:	f04a                	sd	s2,32(sp)
    80001752:	ec4e                	sd	s3,24(sp)
    80001754:	e852                	sd	s4,16(sp)
    80001756:	e456                	sd	s5,8(sp)
    80001758:	e05a                	sd	s6,0(sp)
    8000175a:	0080                	addi	s0,sp,64
  if(len<=0){
    8000175c:	06b05d63          	blez	a1,800017d6 <mprotect+0x8e>
    80001760:	89aa                	mv	s3,a0
    80001762:	892e                	mv	s2,a1
    printf("len should not less than or equal to 0!\n");
    return -1;
  }

  if(POX(va)!=0){
    80001764:	03451793          	slli	a5,a0,0x34
    80001768:	e3c9                	bnez	a5,800017ea <mprotect+0xa2>
    printf("address is not page-aligned!\n");
    return -1;
  }

  if(va >= MAXVA){
    8000176a:	57fd                	li	a5,-1
    8000176c:	83e9                	srli	a5,a5,0x1a
    8000176e:	08a7e863          	bltu	a5,a0,800017fe <mprotect+0xb6>
  }
  
  pte_t *pte;
  pte_t old;
  pagetable_t pagetable = 0;
  struct proc *p = myproc();
    80001772:	00000097          	auipc	ra,0x0
    80001776:	390080e7          	jalr	912(ra) # 80001b02 <myproc>
  pagetable = p->pagetable;
    8000177a:	06053a03          	ld	s4,96(a0)
  for(int i =0; i<len; i++){
    8000177e:	397d                	addiw	s2,s2,-1
    80001780:	1902                	slli	s2,s2,0x20
    80001782:	02095913          	srli	s2,s2,0x20
    80001786:	0932                	slli	s2,s2,0xc
    80001788:	6785                	lui	a5,0x1
    8000178a:	97ce                	add	a5,a5,s3
    8000178c:	993e                	add	s2,s2,a5
  pagetable = p->pagetable;
    8000178e:	84ce                	mv	s1,s3
    pte = walk(pagetable, va+i*PGSIZE, 0);
    //printf("VA:%p\n",va+i*PGSIZE);
    //printf("PTE:%p\n",pte);
    //printf("PTE deference:%p\n",*pte);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0){ 
    80001790:	4ac5                	li	s5,17
    80001792:	6b05                	lui	s6,0x1
    pte = walk(pagetable, va+i*PGSIZE, 0);
    80001794:	4601                	li	a2,0
    80001796:	85a6                	mv	a1,s1
    80001798:	8552                	mv	a0,s4
    8000179a:	fffff097          	auipc	ra,0xfffff
    8000179e:	76e080e7          	jalr	1902(ra) # 80000f08 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0){ 
    800017a2:	c925                	beqz	a0,80001812 <mprotect+0xca>
    800017a4:	611c                	ld	a5,0(a0)
    800017a6:	8bc5                	andi	a5,a5,17
    800017a8:	07579563          	bne	a5,s5,80001812 <mprotect+0xca>
  for(int i =0; i<len; i++){
    800017ac:	94da                	add	s1,s1,s6
    800017ae:	ff2493e3          	bne	s1,s2,80001794 <mprotect+0x4c>
    800017b2:	6485                	lui	s1,0x1
      return -1;
    }
  }

  for(int i =0; i<len; i++){
    pte = walk(pagetable, va+i*PGSIZE, 0);
    800017b4:	4601                	li	a2,0
    800017b6:	85ce                	mv	a1,s3
    800017b8:	8552                	mv	a0,s4
    800017ba:	fffff097          	auipc	ra,0xfffff
    800017be:	74e080e7          	jalr	1870(ra) # 80000f08 <walk>
    old = *pte;
    *pte = old & (~PTE_W);
    800017c2:	611c                	ld	a5,0(a0)
    800017c4:	9bed                	andi	a5,a5,-5
    800017c6:	e11c                	sd	a5,0(a0)
  for(int i =0; i<len; i++){
    800017c8:	99a6                	add	s3,s3,s1
    800017ca:	ff2995e3          	bne	s3,s2,800017b4 <mprotect+0x6c>
    800017ce:	12000073          	sfence.vma
  //printf("PTE:%p\n",pte);
  //printf("PTE deference:%p\n",*pte);
  //if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
  //  panic("kvmmap");
  sfence_vma();
  return 0;
    800017d2:	4501                	li	a0,0
    800017d4:	a881                	j	80001824 <mprotect+0xdc>
    printf("len should not less than or equal to 0!\n");
    800017d6:	00006517          	auipc	a0,0x6
    800017da:	b2250513          	addi	a0,a0,-1246 # 800072f8 <userret+0x268>
    800017de:	fffff097          	auipc	ra,0xfffff
    800017e2:	dba080e7          	jalr	-582(ra) # 80000598 <printf>
    return -1;
    800017e6:	557d                	li	a0,-1
    800017e8:	a835                	j	80001824 <mprotect+0xdc>
    printf("address is not page-aligned!\n");
    800017ea:	00006517          	auipc	a0,0x6
    800017ee:	b3e50513          	addi	a0,a0,-1218 # 80007328 <userret+0x298>
    800017f2:	fffff097          	auipc	ra,0xfffff
    800017f6:	da6080e7          	jalr	-602(ra) # 80000598 <printf>
    return -1;
    800017fa:	557d                	li	a0,-1
    800017fc:	a025                	j	80001824 <mprotect+0xdc>
    printf("va >= MAXVA!\n");
    800017fe:	00006517          	auipc	a0,0x6
    80001802:	b4a50513          	addi	a0,a0,-1206 # 80007348 <userret+0x2b8>
    80001806:	fffff097          	auipc	ra,0xfffff
    8000180a:	d92080e7          	jalr	-622(ra) # 80000598 <printf>
    return -1;
    8000180e:	557d                	li	a0,-1
    80001810:	a811                	j	80001824 <mprotect+0xdc>
      printf("not currently a part of the address space!\n");
    80001812:	00006517          	auipc	a0,0x6
    80001816:	b4650513          	addi	a0,a0,-1210 # 80007358 <userret+0x2c8>
    8000181a:	fffff097          	auipc	ra,0xfffff
    8000181e:	d7e080e7          	jalr	-642(ra) # 80000598 <printf>
      return -1;
    80001822:	557d                	li	a0,-1
}
    80001824:	70e2                	ld	ra,56(sp)
    80001826:	7442                	ld	s0,48(sp)
    80001828:	74a2                	ld	s1,40(sp)
    8000182a:	7902                	ld	s2,32(sp)
    8000182c:	69e2                	ld	s3,24(sp)
    8000182e:	6a42                	ld	s4,16(sp)
    80001830:	6aa2                	ld	s5,8(sp)
    80001832:	6b02                	ld	s6,0(sp)
    80001834:	6121                	addi	sp,sp,64
    80001836:	8082                	ret

0000000080001838 <munprotect>:

int
munprotect(uint64 va, int len)
{
    80001838:	7139                	addi	sp,sp,-64
    8000183a:	fc06                	sd	ra,56(sp)
    8000183c:	f822                	sd	s0,48(sp)
    8000183e:	f426                	sd	s1,40(sp)
    80001840:	f04a                	sd	s2,32(sp)
    80001842:	ec4e                	sd	s3,24(sp)
    80001844:	e852                	sd	s4,16(sp)
    80001846:	e456                	sd	s5,8(sp)
    80001848:	e05a                	sd	s6,0(sp)
    8000184a:	0080                	addi	s0,sp,64
  if(len<=0){
    8000184c:	06b05e63          	blez	a1,800018c8 <munprotect+0x90>
    80001850:	89aa                	mv	s3,a0
    80001852:	892e                	mv	s2,a1
    printf("len should not less than or equal to 0!\n");
    return -1;
  }

  if(POX(va)!=0){
    80001854:	03451793          	slli	a5,a0,0x34
    80001858:	e3d1                	bnez	a5,800018dc <munprotect+0xa4>
    printf("address is not page-aligned!\n");
    return -1;
  }

  if(va >= MAXVA){
    8000185a:	57fd                	li	a5,-1
    8000185c:	83e9                	srli	a5,a5,0x1a
    8000185e:	08a7e963          	bltu	a5,a0,800018f0 <munprotect+0xb8>
  }
  
  pte_t *pte;
  pte_t old;
  pagetable_t pagetable = 0;
  struct proc *p = myproc();
    80001862:	00000097          	auipc	ra,0x0
    80001866:	2a0080e7          	jalr	672(ra) # 80001b02 <myproc>
  pagetable = p->pagetable;
    8000186a:	06053a03          	ld	s4,96(a0)
  for(int i =0; i<len; i++){
    8000186e:	397d                	addiw	s2,s2,-1
    80001870:	1902                	slli	s2,s2,0x20
    80001872:	02095913          	srli	s2,s2,0x20
    80001876:	0932                	slli	s2,s2,0xc
    80001878:	6785                	lui	a5,0x1
    8000187a:	97ce                	add	a5,a5,s3
    8000187c:	993e                	add	s2,s2,a5
  pagetable = p->pagetable;
    8000187e:	84ce                	mv	s1,s3
    pte = walk(pagetable, va+i*PGSIZE, 0);
    //printf("VA:%p\n",va+i*PGSIZE);
    //printf("PTE:%p\n",pte);
    //printf("PTE deference:%p\n",*pte);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0){ 
    80001880:	4ac5                	li	s5,17
    80001882:	6b05                	lui	s6,0x1
    pte = walk(pagetable, va+i*PGSIZE, 0);
    80001884:	4601                	li	a2,0
    80001886:	85a6                	mv	a1,s1
    80001888:	8552                	mv	a0,s4
    8000188a:	fffff097          	auipc	ra,0xfffff
    8000188e:	67e080e7          	jalr	1662(ra) # 80000f08 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0){ 
    80001892:	c92d                	beqz	a0,80001904 <munprotect+0xcc>
    80001894:	611c                	ld	a5,0(a0)
    80001896:	8bc5                	andi	a5,a5,17
    80001898:	07579663          	bne	a5,s5,80001904 <munprotect+0xcc>
  for(int i =0; i<len; i++){
    8000189c:	94da                	add	s1,s1,s6
    8000189e:	ff2493e3          	bne	s1,s2,80001884 <munprotect+0x4c>
    800018a2:	6485                	lui	s1,0x1
      return -1;
    }
  }

  for(int i =0; i<len; i++){
    pte = walk(pagetable, va+i*PGSIZE, 0);
    800018a4:	4601                	li	a2,0
    800018a6:	85ce                	mv	a1,s3
    800018a8:	8552                	mv	a0,s4
    800018aa:	fffff097          	auipc	ra,0xfffff
    800018ae:	65e080e7          	jalr	1630(ra) # 80000f08 <walk>
    old = *pte;
    *pte = old | PTE_W;
    800018b2:	611c                	ld	a5,0(a0)
    800018b4:	0047e793          	ori	a5,a5,4
    800018b8:	e11c                	sd	a5,0(a0)
  for(int i =0; i<len; i++){
    800018ba:	99a6                	add	s3,s3,s1
    800018bc:	ff2994e3          	bne	s3,s2,800018a4 <munprotect+0x6c>
    800018c0:	12000073          	sfence.vma
  }
  sfence_vma();
  return 0;
    800018c4:	4501                	li	a0,0
    800018c6:	a881                	j	80001916 <munprotect+0xde>
    printf("len should not less than or equal to 0!\n");
    800018c8:	00006517          	auipc	a0,0x6
    800018cc:	a3050513          	addi	a0,a0,-1488 # 800072f8 <userret+0x268>
    800018d0:	fffff097          	auipc	ra,0xfffff
    800018d4:	cc8080e7          	jalr	-824(ra) # 80000598 <printf>
    return -1;
    800018d8:	557d                	li	a0,-1
    800018da:	a835                	j	80001916 <munprotect+0xde>
    printf("address is not page-aligned!\n");
    800018dc:	00006517          	auipc	a0,0x6
    800018e0:	a4c50513          	addi	a0,a0,-1460 # 80007328 <userret+0x298>
    800018e4:	fffff097          	auipc	ra,0xfffff
    800018e8:	cb4080e7          	jalr	-844(ra) # 80000598 <printf>
    return -1;
    800018ec:	557d                	li	a0,-1
    800018ee:	a025                	j	80001916 <munprotect+0xde>
    printf("va >= MAXVA!\n");
    800018f0:	00006517          	auipc	a0,0x6
    800018f4:	a5850513          	addi	a0,a0,-1448 # 80007348 <userret+0x2b8>
    800018f8:	fffff097          	auipc	ra,0xfffff
    800018fc:	ca0080e7          	jalr	-864(ra) # 80000598 <printf>
    return -1;
    80001900:	557d                	li	a0,-1
    80001902:	a811                	j	80001916 <munprotect+0xde>
      printf("not currently a part of the address space!\n");
    80001904:	00006517          	auipc	a0,0x6
    80001908:	a5450513          	addi	a0,a0,-1452 # 80007358 <userret+0x2c8>
    8000190c:	fffff097          	auipc	ra,0xfffff
    80001910:	c8c080e7          	jalr	-884(ra) # 80000598 <printf>
      return -1;
    80001914:	557d                	li	a0,-1
}
    80001916:	70e2                	ld	ra,56(sp)
    80001918:	7442                	ld	s0,48(sp)
    8000191a:	74a2                	ld	s1,40(sp)
    8000191c:	7902                	ld	s2,32(sp)
    8000191e:	69e2                	ld	s3,24(sp)
    80001920:	6a42                	ld	s4,16(sp)
    80001922:	6aa2                	ld	s5,8(sp)
    80001924:	6b02                	ld	s6,0(sp)
    80001926:	6121                	addi	sp,sp,64
    80001928:	8082                	ret

000000008000192a <sys_mprotect>:



uint64
sys_mprotect(void) //p3
{ 
    8000192a:	1101                	addi	sp,sp,-32
    8000192c:	ec06                	sd	ra,24(sp)
    8000192e:	e822                	sd	s0,16(sp)
    80001930:	1000                	addi	s0,sp,32
   int n;
   uint64 p;
   if(argaddr(0, &p) < 0 || argint(1, &n) < 0)
    80001932:	fe040593          	addi	a1,s0,-32
    80001936:	4501                	li	a0,0
    80001938:	00002097          	auipc	ra,0x2
    8000193c:	89c080e7          	jalr	-1892(ra) # 800031d4 <argaddr>
    return -1;
    80001940:	57fd                	li	a5,-1
   if(argaddr(0, &p) < 0 || argint(1, &n) < 0)
    80001942:	02054563          	bltz	a0,8000196c <sys_mprotect+0x42>
    80001946:	fec40593          	addi	a1,s0,-20
    8000194a:	4505                	li	a0,1
    8000194c:	00002097          	auipc	ra,0x2
    80001950:	866080e7          	jalr	-1946(ra) # 800031b2 <argint>
    return -1;
    80001954:	57fd                	li	a5,-1
   if(argaddr(0, &p) < 0 || argint(1, &n) < 0)
    80001956:	00054b63          	bltz	a0,8000196c <sys_mprotect+0x42>
   return mprotect(p, n);
    8000195a:	fec42583          	lw	a1,-20(s0)
    8000195e:	fe043503          	ld	a0,-32(s0)
    80001962:	00000097          	auipc	ra,0x0
    80001966:	de6080e7          	jalr	-538(ra) # 80001748 <mprotect>
    8000196a:	87aa                	mv	a5,a0
}
    8000196c:	853e                	mv	a0,a5
    8000196e:	60e2                	ld	ra,24(sp)
    80001970:	6442                	ld	s0,16(sp)
    80001972:	6105                	addi	sp,sp,32
    80001974:	8082                	ret

0000000080001976 <sys_munprotect>:

uint64
sys_munprotect(void) //p3
{ 
    80001976:	1101                	addi	sp,sp,-32
    80001978:	ec06                	sd	ra,24(sp)
    8000197a:	e822                	sd	s0,16(sp)
    8000197c:	1000                	addi	s0,sp,32
   int n;
   uint64 p;
   if(argaddr(0, &p) < 0 || argint(1, &n) < 0)
    8000197e:	fe040593          	addi	a1,s0,-32
    80001982:	4501                	li	a0,0
    80001984:	00002097          	auipc	ra,0x2
    80001988:	850080e7          	jalr	-1968(ra) # 800031d4 <argaddr>
    return -1;
    8000198c:	57fd                	li	a5,-1
   if(argaddr(0, &p) < 0 || argint(1, &n) < 0)
    8000198e:	02054563          	bltz	a0,800019b8 <sys_munprotect+0x42>
    80001992:	fec40593          	addi	a1,s0,-20
    80001996:	4505                	li	a0,1
    80001998:	00002097          	auipc	ra,0x2
    8000199c:	81a080e7          	jalr	-2022(ra) # 800031b2 <argint>
    return -1;
    800019a0:	57fd                	li	a5,-1
   if(argaddr(0, &p) < 0 || argint(1, &n) < 0)
    800019a2:	00054b63          	bltz	a0,800019b8 <sys_munprotect+0x42>
   return munprotect(p, n);
    800019a6:	fec42583          	lw	a1,-20(s0)
    800019aa:	fe043503          	ld	a0,-32(s0)
    800019ae:	00000097          	auipc	ra,0x0
    800019b2:	e8a080e7          	jalr	-374(ra) # 80001838 <munprotect>
    800019b6:	87aa                	mv	a5,a0
}
    800019b8:	853e                	mv	a0,a5
    800019ba:	60e2                	ld	ra,24(sp)
    800019bc:	6442                	ld	s0,16(sp)
    800019be:	6105                	addi	sp,sp,32
    800019c0:	8082                	ret

00000000800019c2 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    800019c2:	1101                	addi	sp,sp,-32
    800019c4:	ec06                	sd	ra,24(sp)
    800019c6:	e822                	sd	s0,16(sp)
    800019c8:	e426                	sd	s1,8(sp)
    800019ca:	1000                	addi	s0,sp,32
    800019cc:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800019ce:	fffff097          	auipc	ra,0xfffff
    800019d2:	0c4080e7          	jalr	196(ra) # 80000a92 <holding>
    800019d6:	c909                	beqz	a0,800019e8 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    800019d8:	749c                	ld	a5,40(s1)
    800019da:	00978f63          	beq	a5,s1,800019f8 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    800019de:	60e2                	ld	ra,24(sp)
    800019e0:	6442                	ld	s0,16(sp)
    800019e2:	64a2                	ld	s1,8(sp)
    800019e4:	6105                	addi	sp,sp,32
    800019e6:	8082                	ret
    panic("wakeup1");
    800019e8:	00006517          	auipc	a0,0x6
    800019ec:	9a050513          	addi	a0,a0,-1632 # 80007388 <userret+0x2f8>
    800019f0:	fffff097          	auipc	ra,0xfffff
    800019f4:	b5e080e7          	jalr	-1186(ra) # 8000054e <panic>
  if(p->chan == p && p->state == SLEEPING) {
    800019f8:	4c98                	lw	a4,24(s1)
    800019fa:	4785                	li	a5,1
    800019fc:	fef711e3          	bne	a4,a5,800019de <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001a00:	4789                	li	a5,2
    80001a02:	cc9c                	sw	a5,24(s1)
}
    80001a04:	bfe9                	j	800019de <wakeup1+0x1c>

0000000080001a06 <procinit>:
{
    80001a06:	715d                	addi	sp,sp,-80
    80001a08:	e486                	sd	ra,72(sp)
    80001a0a:	e0a2                	sd	s0,64(sp)
    80001a0c:	fc26                	sd	s1,56(sp)
    80001a0e:	f84a                	sd	s2,48(sp)
    80001a10:	f44e                	sd	s3,40(sp)
    80001a12:	f052                	sd	s4,32(sp)
    80001a14:	ec56                	sd	s5,24(sp)
    80001a16:	e85a                	sd	s6,16(sp)
    80001a18:	e45e                	sd	s7,8(sp)
    80001a1a:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001a1c:	00006597          	auipc	a1,0x6
    80001a20:	97458593          	addi	a1,a1,-1676 # 80007390 <userret+0x300>
    80001a24:	00010517          	auipc	a0,0x10
    80001a28:	ef450513          	addi	a0,a0,-268 # 80011918 <pid_lock>
    80001a2c:	fffff097          	auipc	ra,0xfffff
    80001a30:	f94080e7          	jalr	-108(ra) # 800009c0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a34:	00010917          	auipc	s2,0x10
    80001a38:	2fc90913          	addi	s2,s2,764 # 80011d30 <proc>
      initlock(&p->lock, "proc");
    80001a3c:	00006b97          	auipc	s7,0x6
    80001a40:	95cb8b93          	addi	s7,s7,-1700 # 80007398 <userret+0x308>
      uint64 va = KSTACK((int) (p - proc)); //every process has a kernel stack with a protection page below it
    80001a44:	8b4a                	mv	s6,s2
    80001a46:	00006a97          	auipc	s5,0x6
    80001a4a:	042a8a93          	addi	s5,s5,66 # 80007a88 <syscalls+0xe8>
    80001a4e:	040009b7          	lui	s3,0x4000
    80001a52:	19fd                	addi	s3,s3,-1
    80001a54:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a56:	00016a17          	auipc	s4,0x16
    80001a5a:	0daa0a13          	addi	s4,s4,218 # 80017b30 <tickslock>
      initlock(&p->lock, "proc");
    80001a5e:	85de                	mv	a1,s7
    80001a60:	854a                	mv	a0,s2
    80001a62:	fffff097          	auipc	ra,0xfffff
    80001a66:	f5e080e7          	jalr	-162(ra) # 800009c0 <initlock>
      char *pa = kalloc();
    80001a6a:	fffff097          	auipc	ra,0xfffff
    80001a6e:	ef6080e7          	jalr	-266(ra) # 80000960 <kalloc>
    80001a72:	85aa                	mv	a1,a0
      if(pa == 0)
    80001a74:	c929                	beqz	a0,80001ac6 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc)); //every process has a kernel stack with a protection page below it
    80001a76:	416904b3          	sub	s1,s2,s6
    80001a7a:	848d                	srai	s1,s1,0x3
    80001a7c:	000ab783          	ld	a5,0(s5)
    80001a80:	02f484b3          	mul	s1,s1,a5
    80001a84:	2485                	addiw	s1,s1,1
    80001a86:	00d4949b          	slliw	s1,s1,0xd
    80001a8a:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001a8e:	4699                	li	a3,6
    80001a90:	6605                	lui	a2,0x1
    80001a92:	8526                	mv	a0,s1
    80001a94:	fffff097          	auipc	ra,0xfffff
    80001a98:	648080e7          	jalr	1608(ra) # 800010dc <kvmmap>
      p->kstack = va;
    80001a9c:	04993823          	sd	s1,80(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001aa0:	17890913          	addi	s2,s2,376
    80001aa4:	fb491de3          	bne	s2,s4,80001a5e <procinit+0x58>
  kvminithart();
    80001aa8:	fffff097          	auipc	ra,0xfffff
    80001aac:	43c080e7          	jalr	1084(ra) # 80000ee4 <kvminithart>
}
    80001ab0:	60a6                	ld	ra,72(sp)
    80001ab2:	6406                	ld	s0,64(sp)
    80001ab4:	74e2                	ld	s1,56(sp)
    80001ab6:	7942                	ld	s2,48(sp)
    80001ab8:	79a2                	ld	s3,40(sp)
    80001aba:	7a02                	ld	s4,32(sp)
    80001abc:	6ae2                	ld	s5,24(sp)
    80001abe:	6b42                	ld	s6,16(sp)
    80001ac0:	6ba2                	ld	s7,8(sp)
    80001ac2:	6161                	addi	sp,sp,80
    80001ac4:	8082                	ret
        panic("kalloc");
    80001ac6:	00006517          	auipc	a0,0x6
    80001aca:	8da50513          	addi	a0,a0,-1830 # 800073a0 <userret+0x310>
    80001ace:	fffff097          	auipc	ra,0xfffff
    80001ad2:	a80080e7          	jalr	-1408(ra) # 8000054e <panic>

0000000080001ad6 <cpuid>:
{
    80001ad6:	1141                	addi	sp,sp,-16
    80001ad8:	e422                	sd	s0,8(sp)
    80001ada:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001adc:	8512                	mv	a0,tp
}
    80001ade:	2501                	sext.w	a0,a0
    80001ae0:	6422                	ld	s0,8(sp)
    80001ae2:	0141                	addi	sp,sp,16
    80001ae4:	8082                	ret

0000000080001ae6 <mycpu>:
mycpu(void) {
    80001ae6:	1141                	addi	sp,sp,-16
    80001ae8:	e422                	sd	s0,8(sp)
    80001aea:	0800                	addi	s0,sp,16
    80001aec:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001aee:	2781                	sext.w	a5,a5
    80001af0:	079e                	slli	a5,a5,0x7
}
    80001af2:	00010517          	auipc	a0,0x10
    80001af6:	e3e50513          	addi	a0,a0,-450 # 80011930 <cpus>
    80001afa:	953e                	add	a0,a0,a5
    80001afc:	6422                	ld	s0,8(sp)
    80001afe:	0141                	addi	sp,sp,16
    80001b00:	8082                	ret

0000000080001b02 <myproc>:
myproc(void) {
    80001b02:	1101                	addi	sp,sp,-32
    80001b04:	ec06                	sd	ra,24(sp)
    80001b06:	e822                	sd	s0,16(sp)
    80001b08:	e426                	sd	s1,8(sp)
    80001b0a:	1000                	addi	s0,sp,32
  push_off();
    80001b0c:	fffff097          	auipc	ra,0xfffff
    80001b10:	eca080e7          	jalr	-310(ra) # 800009d6 <push_off>
    80001b14:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001b16:	2781                	sext.w	a5,a5
    80001b18:	079e                	slli	a5,a5,0x7
    80001b1a:	00010717          	auipc	a4,0x10
    80001b1e:	dfe70713          	addi	a4,a4,-514 # 80011918 <pid_lock>
    80001b22:	97ba                	add	a5,a5,a4
    80001b24:	6f84                	ld	s1,24(a5)
  pop_off();
    80001b26:	fffff097          	auipc	ra,0xfffff
    80001b2a:	efc080e7          	jalr	-260(ra) # 80000a22 <pop_off>
}
    80001b2e:	8526                	mv	a0,s1
    80001b30:	60e2                	ld	ra,24(sp)
    80001b32:	6442                	ld	s0,16(sp)
    80001b34:	64a2                	ld	s1,8(sp)
    80001b36:	6105                	addi	sp,sp,32
    80001b38:	8082                	ret

0000000080001b3a <forkret>:
{
    80001b3a:	1141                	addi	sp,sp,-16
    80001b3c:	e406                	sd	ra,8(sp)
    80001b3e:	e022                	sd	s0,0(sp)
    80001b40:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001b42:	00000097          	auipc	ra,0x0
    80001b46:	fc0080e7          	jalr	-64(ra) # 80001b02 <myproc>
    80001b4a:	fffff097          	auipc	ra,0xfffff
    80001b4e:	fdc080e7          	jalr	-36(ra) # 80000b26 <release>
  if (first) {
    80001b52:	00006797          	auipc	a5,0x6
    80001b56:	4e27a783          	lw	a5,1250(a5) # 80008034 <first.1770>
    80001b5a:	eb89                	bnez	a5,80001b6c <forkret+0x32>
  usertrapret();
    80001b5c:	00001097          	auipc	ra,0x1
    80001b60:	1b6080e7          	jalr	438(ra) # 80002d12 <usertrapret>
}
    80001b64:	60a2                	ld	ra,8(sp)
    80001b66:	6402                	ld	s0,0(sp)
    80001b68:	0141                	addi	sp,sp,16
    80001b6a:	8082                	ret
    first = 0;
    80001b6c:	00006797          	auipc	a5,0x6
    80001b70:	4c07a423          	sw	zero,1224(a5) # 80008034 <first.1770>
    fsinit(ROOTDEV);
    80001b74:	4505                	li	a0,1
    80001b76:	00002097          	auipc	ra,0x2
    80001b7a:	f58080e7          	jalr	-168(ra) # 80003ace <fsinit>
    80001b7e:	bff9                	j	80001b5c <forkret+0x22>

0000000080001b80 <allocpid>:
allocpid() {
    80001b80:	1101                	addi	sp,sp,-32
    80001b82:	ec06                	sd	ra,24(sp)
    80001b84:	e822                	sd	s0,16(sp)
    80001b86:	e426                	sd	s1,8(sp)
    80001b88:	e04a                	sd	s2,0(sp)
    80001b8a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001b8c:	00010917          	auipc	s2,0x10
    80001b90:	d8c90913          	addi	s2,s2,-628 # 80011918 <pid_lock>
    80001b94:	854a                	mv	a0,s2
    80001b96:	fffff097          	auipc	ra,0xfffff
    80001b9a:	f3c080e7          	jalr	-196(ra) # 80000ad2 <acquire>
  pid = nextpid;
    80001b9e:	00006797          	auipc	a5,0x6
    80001ba2:	49a78793          	addi	a5,a5,1178 # 80008038 <nextpid>
    80001ba6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001ba8:	0014871b          	addiw	a4,s1,1
    80001bac:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001bae:	854a                	mv	a0,s2
    80001bb0:	fffff097          	auipc	ra,0xfffff
    80001bb4:	f76080e7          	jalr	-138(ra) # 80000b26 <release>
}
    80001bb8:	8526                	mv	a0,s1
    80001bba:	60e2                	ld	ra,24(sp)
    80001bbc:	6442                	ld	s0,16(sp)
    80001bbe:	64a2                	ld	s1,8(sp)
    80001bc0:	6902                	ld	s2,0(sp)
    80001bc2:	6105                	addi	sp,sp,32
    80001bc4:	8082                	ret

0000000080001bc6 <proc_pagetable>:
{
    80001bc6:	7179                	addi	sp,sp,-48
    80001bc8:	f406                	sd	ra,40(sp)
    80001bca:	f022                	sd	s0,32(sp)
    80001bcc:	ec26                	sd	s1,24(sp)
    80001bce:	e84a                	sd	s2,16(sp)
    80001bd0:	e44e                	sd	s3,8(sp)
    80001bd2:	1800                	addi	s0,sp,48
    80001bd4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001bd6:	fffff097          	auipc	ra,0xfffff
    80001bda:	6c4080e7          	jalr	1732(ra) # 8000129a <uvmcreate>
    80001bde:	84aa                	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001be0:	4729                	li	a4,10
    80001be2:	00005697          	auipc	a3,0x5
    80001be6:	41e68693          	addi	a3,a3,1054 # 80007000 <trampoline>
    80001bea:	6605                	lui	a2,0x1
    80001bec:	040009b7          	lui	s3,0x4000
    80001bf0:	fff98593          	addi	a1,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001bf4:	05b2                	slli	a1,a1,0xc
    80001bf6:	fffff097          	auipc	ra,0xfffff
    80001bfa:	458080e7          	jalr	1112(ra) # 8000104e <mappages>
  mappages(pagetable, TRAPFRAME-2*(p - proc)*PGSIZE, PGSIZE,(uint64)(p->tf), PTE_R | PTE_W); //p4 modified
    80001bfe:	00010597          	auipc	a1,0x10
    80001c02:	13258593          	addi	a1,a1,306 # 80011d30 <proc>
    80001c06:	40b905b3          	sub	a1,s2,a1
    80001c0a:	8589                	srai	a1,a1,0x2
    80001c0c:	00006797          	auipc	a5,0x6
    80001c10:	e847b783          	ld	a5,-380(a5) # 80007a90 <syscalls+0xf0>
    80001c14:	02f585b3          	mul	a1,a1,a5
    80001c18:	19f9                	addi	s3,s3,-2
    80001c1a:	95ce                	add	a1,a1,s3
    80001c1c:	4719                	li	a4,6
    80001c1e:	06893683          	ld	a3,104(s2)
    80001c22:	6605                	lui	a2,0x1
    80001c24:	05b2                	slli	a1,a1,0xc
    80001c26:	8526                	mv	a0,s1
    80001c28:	fffff097          	auipc	ra,0xfffff
    80001c2c:	426080e7          	jalr	1062(ra) # 8000104e <mappages>
}
    80001c30:	8526                	mv	a0,s1
    80001c32:	70a2                	ld	ra,40(sp)
    80001c34:	7402                	ld	s0,32(sp)
    80001c36:	64e2                	ld	s1,24(sp)
    80001c38:	6942                	ld	s2,16(sp)
    80001c3a:	69a2                	ld	s3,8(sp)
    80001c3c:	6145                	addi	sp,sp,48
    80001c3e:	8082                	ret

0000000080001c40 <allocproc>:
{
    80001c40:	1101                	addi	sp,sp,-32
    80001c42:	ec06                	sd	ra,24(sp)
    80001c44:	e822                	sd	s0,16(sp)
    80001c46:	e426                	sd	s1,8(sp)
    80001c48:	e04a                	sd	s2,0(sp)
    80001c4a:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c4c:	00010497          	auipc	s1,0x10
    80001c50:	0e448493          	addi	s1,s1,228 # 80011d30 <proc>
    80001c54:	00016917          	auipc	s2,0x16
    80001c58:	edc90913          	addi	s2,s2,-292 # 80017b30 <tickslock>
    acquire(&p->lock);
    80001c5c:	8526                	mv	a0,s1
    80001c5e:	fffff097          	auipc	ra,0xfffff
    80001c62:	e74080e7          	jalr	-396(ra) # 80000ad2 <acquire>
    if(p->state == UNUSED) {
    80001c66:	4c9c                	lw	a5,24(s1)
    80001c68:	cf81                	beqz	a5,80001c80 <allocproc+0x40>
      release(&p->lock);
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	fffff097          	auipc	ra,0xfffff
    80001c70:	eba080e7          	jalr	-326(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c74:	17848493          	addi	s1,s1,376
    80001c78:	ff2492e3          	bne	s1,s2,80001c5c <allocproc+0x1c>
  return 0;
    80001c7c:	4481                	li	s1,0
    80001c7e:	a899                	j	80001cd4 <allocproc+0x94>
  p->pid = allocpid();
    80001c80:	00000097          	auipc	ra,0x0
    80001c84:	f00080e7          	jalr	-256(ra) # 80001b80 <allocpid>
    80001c88:	dc88                	sw	a0,56(s1)
  p->ticket = 1; //p2b
    80001c8a:	4785                	li	a5,1
    80001c8c:	dcdc                	sw	a5,60(s1)
  p->start_tick = 0; //p2b
    80001c8e:	0404a023          	sw	zero,64(s1)
  p->total_tick = 0; //p2b
    80001c92:	0404a223          	sw	zero,68(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    80001c96:	fffff097          	auipc	ra,0xfffff
    80001c9a:	cca080e7          	jalr	-822(ra) # 80000960 <kalloc>
    80001c9e:	892a                	mv	s2,a0
    80001ca0:	f4a8                	sd	a0,104(s1)
    80001ca2:	c121                	beqz	a0,80001ce2 <allocproc+0xa2>
  p->pagetable = proc_pagetable(p);
    80001ca4:	8526                	mv	a0,s1
    80001ca6:	00000097          	auipc	ra,0x0
    80001caa:	f20080e7          	jalr	-224(ra) # 80001bc6 <proc_pagetable>
    80001cae:	f0a8                	sd	a0,96(s1)
  memset(&p->context, 0, sizeof p->context); //write all zeros
    80001cb0:	07000613          	li	a2,112
    80001cb4:	4581                	li	a1,0
    80001cb6:	07048513          	addi	a0,s1,112
    80001cba:	fffff097          	auipc	ra,0xfffff
    80001cbe:	eb4080e7          	jalr	-332(ra) # 80000b6e <memset>
  p->context.ra = (uint64)forkret; //return address
    80001cc2:	00000797          	auipc	a5,0x0
    80001cc6:	e7878793          	addi	a5,a5,-392 # 80001b3a <forkret>
    80001cca:	f8bc                	sd	a5,112(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001ccc:	68bc                	ld	a5,80(s1)
    80001cce:	6705                	lui	a4,0x1
    80001cd0:	97ba                	add	a5,a5,a4
    80001cd2:	fcbc                	sd	a5,120(s1)
}
    80001cd4:	8526                	mv	a0,s1
    80001cd6:	60e2                	ld	ra,24(sp)
    80001cd8:	6442                	ld	s0,16(sp)
    80001cda:	64a2                	ld	s1,8(sp)
    80001cdc:	6902                	ld	s2,0(sp)
    80001cde:	6105                	addi	sp,sp,32
    80001ce0:	8082                	ret
    release(&p->lock);
    80001ce2:	8526                	mv	a0,s1
    80001ce4:	fffff097          	auipc	ra,0xfffff
    80001ce8:	e42080e7          	jalr	-446(ra) # 80000b26 <release>
    return 0;
    80001cec:	84ca                	mv	s1,s2
    80001cee:	b7dd                	j	80001cd4 <allocproc+0x94>

0000000080001cf0 <proc_freepagetable>:
{
    80001cf0:	7179                	addi	sp,sp,-48
    80001cf2:	f406                	sd	ra,40(sp)
    80001cf4:	f022                	sd	s0,32(sp)
    80001cf6:	ec26                	sd	s1,24(sp)
    80001cf8:	e84a                	sd	s2,16(sp)
    80001cfa:	e44e                	sd	s3,8(sp)
    80001cfc:	e052                	sd	s4,0(sp)
    80001cfe:	1800                	addi	s0,sp,48
    80001d00:	89aa                	mv	s3,a0
    80001d02:	8a2e                	mv	s4,a1
    80001d04:	84b2                	mv	s1,a2
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    80001d06:	4681                	li	a3,0
    80001d08:	6605                	lui	a2,0x1
    80001d0a:	04000937          	lui	s2,0x4000
    80001d0e:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001d12:	05b2                	slli	a1,a1,0xc
    80001d14:	fffff097          	auipc	ra,0xfffff
    80001d18:	4d2080e7          	jalr	1234(ra) # 800011e6 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME-2*(p - proc)*PGSIZE, PGSIZE, 0); //p4 modified
    80001d1c:	00010617          	auipc	a2,0x10
    80001d20:	01460613          	addi	a2,a2,20 # 80011d30 <proc>
    80001d24:	8c91                	sub	s1,s1,a2
    80001d26:	8489                	srai	s1,s1,0x2
    80001d28:	00006597          	auipc	a1,0x6
    80001d2c:	d685b583          	ld	a1,-664(a1) # 80007a90 <syscalls+0xf0>
    80001d30:	02b484b3          	mul	s1,s1,a1
    80001d34:	1979                	addi	s2,s2,-2
    80001d36:	94ca                	add	s1,s1,s2
    80001d38:	4681                	li	a3,0
    80001d3a:	6605                	lui	a2,0x1
    80001d3c:	00c49593          	slli	a1,s1,0xc
    80001d40:	854e                	mv	a0,s3
    80001d42:	fffff097          	auipc	ra,0xfffff
    80001d46:	4a4080e7          	jalr	1188(ra) # 800011e6 <uvmunmap>
  if(sz > 0){
    80001d4a:	000a1a63          	bnez	s4,80001d5e <proc_freepagetable+0x6e>
}
    80001d4e:	70a2                	ld	ra,40(sp)
    80001d50:	7402                	ld	s0,32(sp)
    80001d52:	64e2                	ld	s1,24(sp)
    80001d54:	6942                	ld	s2,16(sp)
    80001d56:	69a2                	ld	s3,8(sp)
    80001d58:	6a02                	ld	s4,0(sp)
    80001d5a:	6145                	addi	sp,sp,48
    80001d5c:	8082                	ret
    uvmfree(pagetable, sz);
    80001d5e:	85d2                	mv	a1,s4
    80001d60:	854e                	mv	a0,s3
    80001d62:	fffff097          	auipc	ra,0xfffff
    80001d66:	6d6080e7          	jalr	1750(ra) # 80001438 <uvmfree>
}
    80001d6a:	b7d5                	j	80001d4e <proc_freepagetable+0x5e>

0000000080001d6c <freeproc>:
{
    80001d6c:	1101                	addi	sp,sp,-32
    80001d6e:	ec06                	sd	ra,24(sp)
    80001d70:	e822                	sd	s0,16(sp)
    80001d72:	e426                	sd	s1,8(sp)
    80001d74:	1000                	addi	s0,sp,32
    80001d76:	84aa                	mv	s1,a0
  if(p->tf)
    80001d78:	7528                	ld	a0,104(a0)
    80001d7a:	c509                	beqz	a0,80001d84 <freeproc+0x18>
    kfree((void*)p->tf);
    80001d7c:	fffff097          	auipc	ra,0xfffff
    80001d80:	ae8080e7          	jalr	-1304(ra) # 80000864 <kfree>
  p->tf = 0;
    80001d84:	0604b423          	sd	zero,104(s1)
    if(pfree->pagetable == p->pagetable && pfree != p){
    80001d88:	70a8                	ld	a0,96(s1)
  for(pfree = proc; pfree < &proc[NPROC]; pfree++) { //check if this is the last process/thread reference this pagetable
    80001d8a:	00010797          	auipc	a5,0x10
    80001d8e:	fa678793          	addi	a5,a5,-90 # 80011d30 <proc>
  int islast = 1; //p4 added
    80001d92:	4605                	li	a2,1
      islast = 0;
    80001d94:	4581                	li	a1,0
  for(pfree = proc; pfree < &proc[NPROC]; pfree++) { //check if this is the last process/thread reference this pagetable
    80001d96:	00016697          	auipc	a3,0x16
    80001d9a:	d9a68693          	addi	a3,a3,-614 # 80017b30 <tickslock>
    80001d9e:	a029                	j	80001da8 <freeproc+0x3c>
    80001da0:	17878793          	addi	a5,a5,376
    80001da4:	00d78963          	beq	a5,a3,80001db6 <freeproc+0x4a>
    if(pfree->pagetable == p->pagetable && pfree != p){
    80001da8:	73b8                	ld	a4,96(a5)
    80001daa:	fea71be3          	bne	a4,a0,80001da0 <freeproc+0x34>
    80001dae:	fef489e3          	beq	s1,a5,80001da0 <freeproc+0x34>
      islast = 0;
    80001db2:	862e                	mv	a2,a1
    80001db4:	b7f5                	j	80001da0 <freeproc+0x34>
  if(p->pagetable && islast){ //free the pgtb only when this is the last reference
    80001db6:	c111                	beqz	a0,80001dba <freeproc+0x4e>
    80001db8:	e635                	bnez	a2,80001e24 <freeproc+0xb8>
    uvmunmap(p->pagetable, TRAPFRAME-2*(p - proc)*PGSIZE, PGSIZE, 0);
    80001dba:	00010597          	auipc	a1,0x10
    80001dbe:	f7658593          	addi	a1,a1,-138 # 80011d30 <proc>
    80001dc2:	40b485b3          	sub	a1,s1,a1
    80001dc6:	8589                	srai	a1,a1,0x2
    80001dc8:	00006797          	auipc	a5,0x6
    80001dcc:	cc87b783          	ld	a5,-824(a5) # 80007a90 <syscalls+0xf0>
    80001dd0:	02f585b3          	mul	a1,a1,a5
    80001dd4:	040007b7          	lui	a5,0x4000
    80001dd8:	17f9                	addi	a5,a5,-2
    80001dda:	95be                	add	a1,a1,a5
    80001ddc:	4681                	li	a3,0
    80001dde:	6605                	lui	a2,0x1
    80001de0:	05b2                	slli	a1,a1,0xc
    80001de2:	fffff097          	auipc	ra,0xfffff
    80001de6:	404080e7          	jalr	1028(ra) # 800011e6 <uvmunmap>
  p->pagetable = 0;
    80001dea:	0604b023          	sd	zero,96(s1)
  p->sz = 0;
    80001dee:	0404bc23          	sd	zero,88(s1)
  p->pid = 0;
    80001df2:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001df6:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001dfa:	16048423          	sb	zero,360(s1)
  p->chan = 0;
    80001dfe:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001e02:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001e06:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001e0a:	0004ac23          	sw	zero,24(s1)
  p->ticket = 0; //p2b
    80001e0e:	0204ae23          	sw	zero,60(s1)
  p->start_tick = 0; //p2b
    80001e12:	0404a023          	sw	zero,64(s1)
  p->total_tick = 0; //p2b
    80001e16:	0404a223          	sw	zero,68(s1)
}
    80001e1a:	60e2                	ld	ra,24(sp)
    80001e1c:	6442                	ld	s0,16(sp)
    80001e1e:	64a2                	ld	s1,8(sp)
    80001e20:	6105                	addi	sp,sp,32
    80001e22:	8082                	ret
    proc_freepagetable(p->pagetable, p->sz - PGSIZE, p); //p3 p4 add the p
    80001e24:	6cbc                	ld	a5,88(s1)
    80001e26:	8626                	mv	a2,s1
    80001e28:	75fd                	lui	a1,0xfffff
    80001e2a:	95be                	add	a1,a1,a5
    80001e2c:	00000097          	auipc	ra,0x0
    80001e30:	ec4080e7          	jalr	-316(ra) # 80001cf0 <proc_freepagetable>
    80001e34:	bf5d                	j	80001dea <freeproc+0x7e>

0000000080001e36 <userinit>:
{
    80001e36:	1101                	addi	sp,sp,-32
    80001e38:	ec06                	sd	ra,24(sp)
    80001e3a:	e822                	sd	s0,16(sp)
    80001e3c:	e426                	sd	s1,8(sp)
    80001e3e:	1000                	addi	s0,sp,32
  p = allocproc(); //get the return address
    80001e40:	00000097          	auipc	ra,0x0
    80001e44:	e00080e7          	jalr	-512(ra) # 80001c40 <allocproc>
    80001e48:	84aa                	mv	s1,a0
  initproc = p;
    80001e4a:	00024797          	auipc	a5,0x24
    80001e4e:	1ca7b723          	sd	a0,462(a5) # 80026018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001e52:	03300613          	li	a2,51
    80001e56:	00006597          	auipc	a1,0x6
    80001e5a:	1aa58593          	addi	a1,a1,426 # 80008000 <initcode>
    80001e5e:	7128                	ld	a0,96(a0)
    80001e60:	fffff097          	auipc	ra,0xfffff
    80001e64:	478080e7          	jalr	1144(ra) # 800012d8 <uvminit>
  p->sz = PGSIZE;
    80001e68:	6785                	lui	a5,0x1
    80001e6a:	ecbc                	sd	a5,88(s1)
  p->tf->epc = 0;      // user program counter
    80001e6c:	74b8                	ld	a4,104(s1)
    80001e6e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->tf->sp = PGSIZE;  // user stack pointer
    80001e72:	74b8                	ld	a4,104(s1)
    80001e74:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001e76:	4641                	li	a2,16
    80001e78:	00005597          	auipc	a1,0x5
    80001e7c:	53058593          	addi	a1,a1,1328 # 800073a8 <userret+0x318>
    80001e80:	16848513          	addi	a0,s1,360
    80001e84:	fffff097          	auipc	ra,0xfffff
    80001e88:	e40080e7          	jalr	-448(ra) # 80000cc4 <safestrcpy>
  p->cwd = namei("/");
    80001e8c:	00005517          	auipc	a0,0x5
    80001e90:	52c50513          	addi	a0,a0,1324 # 800073b8 <userret+0x328>
    80001e94:	00002097          	auipc	ra,0x2
    80001e98:	63c080e7          	jalr	1596(ra) # 800044d0 <namei>
    80001e9c:	16a4b023          	sd	a0,352(s1)
  p->state = RUNNABLE;
    80001ea0:	4789                	li	a5,2
    80001ea2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001ea4:	8526                	mv	a0,s1
    80001ea6:	fffff097          	auipc	ra,0xfffff
    80001eaa:	c80080e7          	jalr	-896(ra) # 80000b26 <release>
}
    80001eae:	60e2                	ld	ra,24(sp)
    80001eb0:	6442                	ld	s0,16(sp)
    80001eb2:	64a2                	ld	s1,8(sp)
    80001eb4:	6105                	addi	sp,sp,32
    80001eb6:	8082                	ret

0000000080001eb8 <growproc>:
{
    80001eb8:	1101                	addi	sp,sp,-32
    80001eba:	ec06                	sd	ra,24(sp)
    80001ebc:	e822                	sd	s0,16(sp)
    80001ebe:	e426                	sd	s1,8(sp)
    80001ec0:	e04a                	sd	s2,0(sp)
    80001ec2:	1000                	addi	s0,sp,32
    80001ec4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ec6:	00000097          	auipc	ra,0x0
    80001eca:	c3c080e7          	jalr	-964(ra) # 80001b02 <myproc>
    80001ece:	892a                	mv	s2,a0
  sz = p->sz;
    80001ed0:	6d2c                	ld	a1,88(a0)
    80001ed2:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001ed6:	00904f63          	bgtz	s1,80001ef4 <growproc+0x3c>
  } else if(n < 0){
    80001eda:	0204cc63          	bltz	s1,80001f12 <growproc+0x5a>
  p->sz = sz;
    80001ede:	1602                	slli	a2,a2,0x20
    80001ee0:	9201                	srli	a2,a2,0x20
    80001ee2:	04c93c23          	sd	a2,88(s2)
  return 0;
    80001ee6:	4501                	li	a0,0
}
    80001ee8:	60e2                	ld	ra,24(sp)
    80001eea:	6442                	ld	s0,16(sp)
    80001eec:	64a2                	ld	s1,8(sp)
    80001eee:	6902                	ld	s2,0(sp)
    80001ef0:	6105                	addi	sp,sp,32
    80001ef2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001ef4:	9e25                	addw	a2,a2,s1
    80001ef6:	1602                	slli	a2,a2,0x20
    80001ef8:	9201                	srli	a2,a2,0x20
    80001efa:	1582                	slli	a1,a1,0x20
    80001efc:	9181                	srli	a1,a1,0x20
    80001efe:	7128                	ld	a0,96(a0)
    80001f00:	fffff097          	auipc	ra,0xfffff
    80001f04:	48e080e7          	jalr	1166(ra) # 8000138e <uvmalloc>
    80001f08:	0005061b          	sext.w	a2,a0
    80001f0c:	fa69                	bnez	a2,80001ede <growproc+0x26>
      return -1;
    80001f0e:	557d                	li	a0,-1
    80001f10:	bfe1                	j	80001ee8 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001f12:	9e25                	addw	a2,a2,s1
    80001f14:	1602                	slli	a2,a2,0x20
    80001f16:	9201                	srli	a2,a2,0x20
    80001f18:	1582                	slli	a1,a1,0x20
    80001f1a:	9181                	srli	a1,a1,0x20
    80001f1c:	7128                	ld	a0,96(a0)
    80001f1e:	fffff097          	auipc	ra,0xfffff
    80001f22:	42c080e7          	jalr	1068(ra) # 8000134a <uvmdealloc>
    80001f26:	0005061b          	sext.w	a2,a0
    80001f2a:	bf55                	j	80001ede <growproc+0x26>

0000000080001f2c <fork>:
{
    80001f2c:	7179                	addi	sp,sp,-48
    80001f2e:	f406                	sd	ra,40(sp)
    80001f30:	f022                	sd	s0,32(sp)
    80001f32:	ec26                	sd	s1,24(sp)
    80001f34:	e84a                	sd	s2,16(sp)
    80001f36:	e44e                	sd	s3,8(sp)
    80001f38:	e052                	sd	s4,0(sp)
    80001f3a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f3c:	00000097          	auipc	ra,0x0
    80001f40:	bc6080e7          	jalr	-1082(ra) # 80001b02 <myproc>
    80001f44:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001f46:	00000097          	auipc	ra,0x0
    80001f4a:	cfa080e7          	jalr	-774(ra) # 80001c40 <allocproc>
    80001f4e:	c575                	beqz	a0,8000203a <fork+0x10e>
    80001f50:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001f52:	05893603          	ld	a2,88(s2)
    80001f56:	712c                	ld	a1,96(a0)
    80001f58:	06093503          	ld	a0,96(s2)
    80001f5c:	fffff097          	auipc	ra,0xfffff
    80001f60:	50a080e7          	jalr	1290(ra) # 80001466 <uvmcopy>
    80001f64:	04054c63          	bltz	a0,80001fbc <fork+0x90>
  np->sz = p->sz;
    80001f68:	05893783          	ld	a5,88(s2)
    80001f6c:	04f9bc23          	sd	a5,88(s3)
  np->ticket = p->ticket; //p2b added
    80001f70:	03c92783          	lw	a5,60(s2)
    80001f74:	02f9ae23          	sw	a5,60(s3)
  np->parent = p;
    80001f78:	0329b023          	sd	s2,32(s3)
  *(np->tf) = *(p->tf);
    80001f7c:	06893683          	ld	a3,104(s2)
    80001f80:	87b6                	mv	a5,a3
    80001f82:	0689b703          	ld	a4,104(s3)
    80001f86:	12068693          	addi	a3,a3,288
    80001f8a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001f8e:	6788                	ld	a0,8(a5)
    80001f90:	6b8c                	ld	a1,16(a5)
    80001f92:	6f90                	ld	a2,24(a5)
    80001f94:	01073023          	sd	a6,0(a4)
    80001f98:	e708                	sd	a0,8(a4)
    80001f9a:	eb0c                	sd	a1,16(a4)
    80001f9c:	ef10                	sd	a2,24(a4)
    80001f9e:	02078793          	addi	a5,a5,32
    80001fa2:	02070713          	addi	a4,a4,32
    80001fa6:	fed792e3          	bne	a5,a3,80001f8a <fork+0x5e>
  np->tf->a0 = 0;
    80001faa:	0689b783          	ld	a5,104(s3)
    80001fae:	0607b823          	sd	zero,112(a5)
    80001fb2:	0e000493          	li	s1,224
  for(i = 0; i < NOFILE; i++)
    80001fb6:	16000a13          	li	s4,352
    80001fba:	a03d                	j	80001fe8 <fork+0xbc>
    freeproc(np);
    80001fbc:	854e                	mv	a0,s3
    80001fbe:	00000097          	auipc	ra,0x0
    80001fc2:	dae080e7          	jalr	-594(ra) # 80001d6c <freeproc>
    release(&np->lock);
    80001fc6:	854e                	mv	a0,s3
    80001fc8:	fffff097          	auipc	ra,0xfffff
    80001fcc:	b5e080e7          	jalr	-1186(ra) # 80000b26 <release>
    return -1;
    80001fd0:	54fd                	li	s1,-1
    80001fd2:	a899                	j	80002028 <fork+0xfc>
      np->ofile[i] = filedup(p->ofile[i]);
    80001fd4:	00003097          	auipc	ra,0x3
    80001fd8:	b88080e7          	jalr	-1144(ra) # 80004b5c <filedup>
    80001fdc:	009987b3          	add	a5,s3,s1
    80001fe0:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001fe2:	04a1                	addi	s1,s1,8
    80001fe4:	01448763          	beq	s1,s4,80001ff2 <fork+0xc6>
    if(p->ofile[i])
    80001fe8:	009907b3          	add	a5,s2,s1
    80001fec:	6388                	ld	a0,0(a5)
    80001fee:	f17d                	bnez	a0,80001fd4 <fork+0xa8>
    80001ff0:	bfcd                	j	80001fe2 <fork+0xb6>
  np->cwd = idup(p->cwd);
    80001ff2:	16093503          	ld	a0,352(s2)
    80001ff6:	00002097          	auipc	ra,0x2
    80001ffa:	d12080e7          	jalr	-750(ra) # 80003d08 <idup>
    80001ffe:	16a9b023          	sd	a0,352(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002002:	4641                	li	a2,16
    80002004:	16890593          	addi	a1,s2,360
    80002008:	16898513          	addi	a0,s3,360
    8000200c:	fffff097          	auipc	ra,0xfffff
    80002010:	cb8080e7          	jalr	-840(ra) # 80000cc4 <safestrcpy>
  pid = np->pid;
    80002014:	0389a483          	lw	s1,56(s3)
  np->state = RUNNABLE;
    80002018:	4789                	li	a5,2
    8000201a:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000201e:	854e                	mv	a0,s3
    80002020:	fffff097          	auipc	ra,0xfffff
    80002024:	b06080e7          	jalr	-1274(ra) # 80000b26 <release>
}
    80002028:	8526                	mv	a0,s1
    8000202a:	70a2                	ld	ra,40(sp)
    8000202c:	7402                	ld	s0,32(sp)
    8000202e:	64e2                	ld	s1,24(sp)
    80002030:	6942                	ld	s2,16(sp)
    80002032:	69a2                	ld	s3,8(sp)
    80002034:	6a02                	ld	s4,0(sp)
    80002036:	6145                	addi	sp,sp,48
    80002038:	8082                	ret
    return -1;
    8000203a:	54fd                	li	s1,-1
    8000203c:	b7f5                	j	80002028 <fork+0xfc>

000000008000203e <clone>:
{
    8000203e:	715d                	addi	sp,sp,-80
    80002040:	e486                	sd	ra,72(sp)
    80002042:	e0a2                	sd	s0,64(sp)
    80002044:	fc26                	sd	s1,56(sp)
    80002046:	f84a                	sd	s2,48(sp)
    80002048:	f44e                	sd	s3,40(sp)
    8000204a:	f052                	sd	s4,32(sp)
    8000204c:	ec56                	sd	s5,24(sp)
    8000204e:	e85a                	sd	s6,16(sp)
    80002050:	e45e                	sd	s7,8(sp)
    80002052:	0880                	addi	s0,sp,80
    80002054:	8aaa                	mv	s5,a0
    80002056:	8bae                	mv	s7,a1
    80002058:	8b32                	mv	s6,a2
    8000205a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000205c:	00000097          	auipc	ra,0x0
    80002060:	aa6080e7          	jalr	-1370(ra) # 80001b02 <myproc>
  if(((uint64)stack % PGSIZE) != 0) { //check the stack address is page aligned
    80002064:	034a1793          	slli	a5,s4,0x34
    80002068:	18079e63          	bnez	a5,80002204 <clone+0x1c6>
    8000206c:	89aa                	mv	s3,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    8000206e:	00010497          	auipc	s1,0x10
    80002072:	cc248493          	addi	s1,s1,-830 # 80011d30 <proc>
    80002076:	00016917          	auipc	s2,0x16
    8000207a:	aba90913          	addi	s2,s2,-1350 # 80017b30 <tickslock>
    acquire(&p->lock);
    8000207e:	8526                	mv	a0,s1
    80002080:	fffff097          	auipc	ra,0xfffff
    80002084:	a52080e7          	jalr	-1454(ra) # 80000ad2 <acquire>
    if(p->state == UNUSED) {
    80002088:	4c9c                	lw	a5,24(s1)
    8000208a:	cf81                	beqz	a5,800020a2 <clone+0x64>
      release(&p->lock);
    8000208c:	8526                	mv	a0,s1
    8000208e:	fffff097          	auipc	ra,0xfffff
    80002092:	a98080e7          	jalr	-1384(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002096:	17848493          	addi	s1,s1,376
    8000209a:	ff2492e3          	bne	s1,s2,8000207e <clone+0x40>
  return 0;
    8000209e:	4481                	li	s1,0
    800020a0:	a041                	j	80002120 <clone+0xe2>
  p->pid = allocpid();
    800020a2:	00000097          	auipc	ra,0x0
    800020a6:	ade080e7          	jalr	-1314(ra) # 80001b80 <allocpid>
    800020aa:	dc88                	sw	a0,56(s1)
  p->ticket = 1; //p2b
    800020ac:	4785                	li	a5,1
    800020ae:	dcdc                	sw	a5,60(s1)
  p->start_tick = 0; //p2b
    800020b0:	0404a023          	sw	zero,64(s1)
  p->total_tick = 0; //p2b
    800020b4:	0404a223          	sw	zero,68(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    800020b8:	fffff097          	auipc	ra,0xfffff
    800020bc:	8a8080e7          	jalr	-1880(ra) # 80000960 <kalloc>
    800020c0:	892a                	mv	s2,a0
    800020c2:	f4a8                	sd	a0,104(s1)
    800020c4:	c561                	beqz	a0,8000218c <clone+0x14e>
  mappages(parent->pagetable, TRAPFRAME-2*(p - proc)*PGSIZE, PGSIZE,(uint64)(p->tf), PTE_R | PTE_W);
    800020c6:	00010797          	auipc	a5,0x10
    800020ca:	c6a78793          	addi	a5,a5,-918 # 80011d30 <proc>
    800020ce:	40f487b3          	sub	a5,s1,a5
    800020d2:	8789                	srai	a5,a5,0x2
    800020d4:	00006597          	auipc	a1,0x6
    800020d8:	9bc5b583          	ld	a1,-1604(a1) # 80007a90 <syscalls+0xf0>
    800020dc:	02b787b3          	mul	a5,a5,a1
    800020e0:	040005b7          	lui	a1,0x4000
    800020e4:	15f9                	addi	a1,a1,-2
    800020e6:	95be                	add	a1,a1,a5
    800020e8:	4719                	li	a4,6
    800020ea:	86aa                	mv	a3,a0
    800020ec:	6605                	lui	a2,0x1
    800020ee:	05b2                	slli	a1,a1,0xc
    800020f0:	0609b503          	ld	a0,96(s3)
    800020f4:	fffff097          	auipc	ra,0xfffff
    800020f8:	f5a080e7          	jalr	-166(ra) # 8000104e <mappages>
  memset(&p->context, 0, sizeof p->context); //write all zeros
    800020fc:	07000613          	li	a2,112
    80002100:	4581                	li	a1,0
    80002102:	07048513          	addi	a0,s1,112
    80002106:	fffff097          	auipc	ra,0xfffff
    8000210a:	a68080e7          	jalr	-1432(ra) # 80000b6e <memset>
  p->context.ra = (uint64)forkret; //return address
    8000210e:	00000797          	auipc	a5,0x0
    80002112:	a2c78793          	addi	a5,a5,-1492 # 80001b3a <forkret>
    80002116:	f8bc                	sd	a5,112(s1)
  p->context.sp = p->kstack + PGSIZE;
    80002118:	68bc                	ld	a5,80(s1)
    8000211a:	6705                	lui	a4,0x1
    8000211c:	97ba                	add	a5,a5,a4
    8000211e:	fcbc                	sd	a5,120(s1)
  np->stack = (uint64)stack; //self added PCB field
    80002120:	0544b423          	sd	s4,72(s1)
  np->pagetable = p->pagetable; //use the same pagetable
    80002124:	0609b783          	ld	a5,96(s3)
    80002128:	f0bc                	sd	a5,96(s1)
  np->sz = p->sz;
    8000212a:	0589b783          	ld	a5,88(s3)
    8000212e:	ecbc                	sd	a5,88(s1)
  np->ticket = p->ticket; //p2b added
    80002130:	03c9a783          	lw	a5,60(s3)
    80002134:	dcdc                	sw	a5,60(s1)
  np->parent = p;
    80002136:	0334b023          	sd	s3,32(s1)
  *(np->tf) = *(p->tf);
    8000213a:	0689b683          	ld	a3,104(s3)
    8000213e:	87b6                	mv	a5,a3
    80002140:	74b8                	ld	a4,104(s1)
    80002142:	12068693          	addi	a3,a3,288
    80002146:	0007b803          	ld	a6,0(a5)
    8000214a:	6788                	ld	a0,8(a5)
    8000214c:	6b8c                	ld	a1,16(a5)
    8000214e:	6f90                	ld	a2,24(a5)
    80002150:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80002154:	e708                	sd	a0,8(a4)
    80002156:	eb0c                	sd	a1,16(a4)
    80002158:	ef10                	sd	a2,24(a4)
    8000215a:	02078793          	addi	a5,a5,32
    8000215e:	02070713          	addi	a4,a4,32
    80002162:	fed792e3          	bne	a5,a3,80002146 <clone+0x108>
  np->tf->a0 = (uint64)arg1;
    80002166:	74bc                	ld	a5,104(s1)
    80002168:	0777b823          	sd	s7,112(a5)
  np->tf->a1 = (uint64)arg2;
    8000216c:	74bc                	ld	a5,104(s1)
    8000216e:	0767bc23          	sd	s6,120(a5)
  np->tf->sp = sp;
    80002172:	74bc                	ld	a5,104(s1)
  sp = (uint64)stack + PGSIZE; //stack top
    80002174:	6705                	lui	a4,0x1
    80002176:	9a3a                	add	s4,s4,a4
  np->tf->sp = sp;
    80002178:	0347b823          	sd	s4,48(a5)
  np->tf->epc = (uint64)fcn;
    8000217c:	74bc                	ld	a5,104(s1)
    8000217e:	0157bc23          	sd	s5,24(a5)
    80002182:	0e000913          	li	s2,224
  for(i = 0; i < NOFILE; i++)
    80002186:	16000a13          	li	s4,352
    8000218a:	a015                	j	800021ae <clone+0x170>
    release(&p->lock);
    8000218c:	8526                	mv	a0,s1
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	998080e7          	jalr	-1640(ra) # 80000b26 <release>
    return 0;
    80002196:	84ca                	mv	s1,s2
    80002198:	b761                	j	80002120 <clone+0xe2>
      np->ofile[i] = filedup(p->ofile[i]);
    8000219a:	00003097          	auipc	ra,0x3
    8000219e:	9c2080e7          	jalr	-1598(ra) # 80004b5c <filedup>
    800021a2:	012487b3          	add	a5,s1,s2
    800021a6:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800021a8:	0921                	addi	s2,s2,8
    800021aa:	01490763          	beq	s2,s4,800021b8 <clone+0x17a>
    if(p->ofile[i])
    800021ae:	012987b3          	add	a5,s3,s2
    800021b2:	6388                	ld	a0,0(a5)
    800021b4:	f17d                	bnez	a0,8000219a <clone+0x15c>
    800021b6:	bfcd                	j	800021a8 <clone+0x16a>
  np->cwd = idup(p->cwd);
    800021b8:	1609b503          	ld	a0,352(s3)
    800021bc:	00002097          	auipc	ra,0x2
    800021c0:	b4c080e7          	jalr	-1204(ra) # 80003d08 <idup>
    800021c4:	16a4b023          	sd	a0,352(s1)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800021c8:	4641                	li	a2,16
    800021ca:	16898593          	addi	a1,s3,360
    800021ce:	16848513          	addi	a0,s1,360
    800021d2:	fffff097          	auipc	ra,0xfffff
    800021d6:	af2080e7          	jalr	-1294(ra) # 80000cc4 <safestrcpy>
  pid = np->pid;
    800021da:	0384a903          	lw	s2,56(s1)
  np->state = RUNNABLE;
    800021de:	4789                	li	a5,2
    800021e0:	cc9c                	sw	a5,24(s1)
  release(&np->lock);
    800021e2:	8526                	mv	a0,s1
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	942080e7          	jalr	-1726(ra) # 80000b26 <release>
}
    800021ec:	854a                	mv	a0,s2
    800021ee:	60a6                	ld	ra,72(sp)
    800021f0:	6406                	ld	s0,64(sp)
    800021f2:	74e2                	ld	s1,56(sp)
    800021f4:	7942                	ld	s2,48(sp)
    800021f6:	79a2                	ld	s3,40(sp)
    800021f8:	7a02                	ld	s4,32(sp)
    800021fa:	6ae2                	ld	s5,24(sp)
    800021fc:	6b42                	ld	s6,16(sp)
    800021fe:	6ba2                	ld	s7,8(sp)
    80002200:	6161                	addi	sp,sp,80
    80002202:	8082                	ret
    return -1;
    80002204:	597d                	li	s2,-1
    80002206:	b7dd                	j	800021ec <clone+0x1ae>

0000000080002208 <sys_clone>:
{
    80002208:	7179                	addi	sp,sp,-48
    8000220a:	f406                	sd	ra,40(sp)
    8000220c:	f022                	sd	s0,32(sp)
    8000220e:	1800                	addi	s0,sp,48
  if(argaddr(0, &fcn) < 0)
    80002210:	fe840593          	addi	a1,s0,-24
    80002214:	4501                	li	a0,0
    80002216:	00001097          	auipc	ra,0x1
    8000221a:	fbe080e7          	jalr	-66(ra) # 800031d4 <argaddr>
    8000221e:	04054d63          	bltz	a0,80002278 <sys_clone+0x70>
  if(argaddr(1, &arg1) < 0)
    80002222:	fe040593          	addi	a1,s0,-32
    80002226:	4505                	li	a0,1
    80002228:	00001097          	auipc	ra,0x1
    8000222c:	fac080e7          	jalr	-84(ra) # 800031d4 <argaddr>
    80002230:	04054663          	bltz	a0,8000227c <sys_clone+0x74>
  if(argaddr(2, &arg2) < 0)
    80002234:	fd840593          	addi	a1,s0,-40
    80002238:	4509                	li	a0,2
    8000223a:	00001097          	auipc	ra,0x1
    8000223e:	f9a080e7          	jalr	-102(ra) # 800031d4 <argaddr>
    80002242:	02054f63          	bltz	a0,80002280 <sys_clone+0x78>
  if(argaddr(3, &stack) < 0)
    80002246:	fd040593          	addi	a1,s0,-48
    8000224a:	450d                	li	a0,3
    8000224c:	00001097          	auipc	ra,0x1
    80002250:	f88080e7          	jalr	-120(ra) # 800031d4 <argaddr>
    80002254:	02054863          	bltz	a0,80002284 <sys_clone+0x7c>
  return clone((void(*)(void*,void*))fcn, (void*)arg1, (void*)arg2, (void*)stack);
    80002258:	fd043683          	ld	a3,-48(s0)
    8000225c:	fd843603          	ld	a2,-40(s0)
    80002260:	fe043583          	ld	a1,-32(s0)
    80002264:	fe843503          	ld	a0,-24(s0)
    80002268:	00000097          	auipc	ra,0x0
    8000226c:	dd6080e7          	jalr	-554(ra) # 8000203e <clone>
}
    80002270:	70a2                	ld	ra,40(sp)
    80002272:	7402                	ld	s0,32(sp)
    80002274:	6145                	addi	sp,sp,48
    80002276:	8082                	ret
    return -1;
    80002278:	557d                	li	a0,-1
    8000227a:	bfdd                	j	80002270 <sys_clone+0x68>
    return -1;
    8000227c:	557d                	li	a0,-1
    8000227e:	bfcd                	j	80002270 <sys_clone+0x68>
    return -1;
    80002280:	557d                	li	a0,-1
    80002282:	b7fd                	j	80002270 <sys_clone+0x68>
    return -1;
    80002284:	557d                	li	a0,-1
    80002286:	b7ed                	j	80002270 <sys_clone+0x68>

0000000080002288 <reparent>:
{
    80002288:	7179                	addi	sp,sp,-48
    8000228a:	f406                	sd	ra,40(sp)
    8000228c:	f022                	sd	s0,32(sp)
    8000228e:	ec26                	sd	s1,24(sp)
    80002290:	e84a                	sd	s2,16(sp)
    80002292:	e44e                	sd	s3,8(sp)
    80002294:	e052                	sd	s4,0(sp)
    80002296:	1800                	addi	s0,sp,48
    80002298:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000229a:	00010497          	auipc	s1,0x10
    8000229e:	a9648493          	addi	s1,s1,-1386 # 80011d30 <proc>
      pp->parent = initproc;
    800022a2:	00024a17          	auipc	s4,0x24
    800022a6:	d76a0a13          	addi	s4,s4,-650 # 80026018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022aa:	00016997          	auipc	s3,0x16
    800022ae:	88698993          	addi	s3,s3,-1914 # 80017b30 <tickslock>
    800022b2:	a029                	j	800022bc <reparent+0x34>
    800022b4:	17848493          	addi	s1,s1,376
    800022b8:	03348363          	beq	s1,s3,800022de <reparent+0x56>
    if(pp->parent == p){
    800022bc:	709c                	ld	a5,32(s1)
    800022be:	ff279be3          	bne	a5,s2,800022b4 <reparent+0x2c>
      acquire(&pp->lock);
    800022c2:	8526                	mv	a0,s1
    800022c4:	fffff097          	auipc	ra,0xfffff
    800022c8:	80e080e7          	jalr	-2034(ra) # 80000ad2 <acquire>
      pp->parent = initproc;
    800022cc:	000a3783          	ld	a5,0(s4)
    800022d0:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    800022d2:	8526                	mv	a0,s1
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	852080e7          	jalr	-1966(ra) # 80000b26 <release>
    800022dc:	bfe1                	j	800022b4 <reparent+0x2c>
}
    800022de:	70a2                	ld	ra,40(sp)
    800022e0:	7402                	ld	s0,32(sp)
    800022e2:	64e2                	ld	s1,24(sp)
    800022e4:	6942                	ld	s2,16(sp)
    800022e6:	69a2                	ld	s3,8(sp)
    800022e8:	6a02                	ld	s4,0(sp)
    800022ea:	6145                	addi	sp,sp,48
    800022ec:	8082                	ret

00000000800022ee <settickets>:
    if(num<1) //check
    800022ee:	02a05d63          	blez	a0,80002328 <settickets+0x3a>
{
    800022f2:	1101                	addi	sp,sp,-32
    800022f4:	ec06                	sd	ra,24(sp)
    800022f6:	e822                	sd	s0,16(sp)
    800022f8:	e426                	sd	s1,8(sp)
    800022fa:	e04a                	sd	s2,0(sp)
    800022fc:	1000                	addi	s0,sp,32
    800022fe:	892a                	mv	s2,a0
    80002300:	84ae                	mv	s1,a1
    acquire(&p->lock);
    80002302:	852e                	mv	a0,a1
    80002304:	ffffe097          	auipc	ra,0xffffe
    80002308:	7ce080e7          	jalr	1998(ra) # 80000ad2 <acquire>
    p->ticket = num;
    8000230c:	0324ae23          	sw	s2,60(s1)
    release(&p->lock);
    80002310:	8526                	mv	a0,s1
    80002312:	fffff097          	auipc	ra,0xfffff
    80002316:	814080e7          	jalr	-2028(ra) # 80000b26 <release>
    return 0;	
    8000231a:	4501                	li	a0,0
}
    8000231c:	60e2                	ld	ra,24(sp)
    8000231e:	6442                	ld	s0,16(sp)
    80002320:	64a2                	ld	s1,8(sp)
    80002322:	6902                	ld	s2,0(sp)
    80002324:	6105                	addi	sp,sp,32
    80002326:	8082                	ret
	   return -1;
    80002328:	557d                	li	a0,-1
}
    8000232a:	8082                	ret

000000008000232c <sys_settickets>:
{ 
    8000232c:	7179                	addi	sp,sp,-48
    8000232e:	f406                	sd	ra,40(sp)
    80002330:	f022                	sd	s0,32(sp)
    80002332:	ec26                	sd	s1,24(sp)
    80002334:	1800                	addi	s0,sp,48
   struct proc *p = myproc(); 
    80002336:	fffff097          	auipc	ra,0xfffff
    8000233a:	7cc080e7          	jalr	1996(ra) # 80001b02 <myproc>
    8000233e:	84aa                	mv	s1,a0
   if(argint(0, &ticket) < 0)
    80002340:	fdc40593          	addi	a1,s0,-36
    80002344:	4501                	li	a0,0
    80002346:	00001097          	auipc	ra,0x1
    8000234a:	e6c080e7          	jalr	-404(ra) # 800031b2 <argint>
    8000234e:	87aa                	mv	a5,a0
     return -1;
    80002350:	557d                	li	a0,-1
   if(argint(0, &ticket) < 0)
    80002352:	0007c963          	bltz	a5,80002364 <sys_settickets+0x38>
   return settickets(ticket,p);
    80002356:	85a6                	mv	a1,s1
    80002358:	fdc42503          	lw	a0,-36(s0)
    8000235c:	00000097          	auipc	ra,0x0
    80002360:	f92080e7          	jalr	-110(ra) # 800022ee <settickets>
}
    80002364:	70a2                	ld	ra,40(sp)
    80002366:	7402                	ld	s0,32(sp)
    80002368:	64e2                	ld	s1,24(sp)
    8000236a:	6145                	addi	sp,sp,48
    8000236c:	8082                	ret

000000008000236e <getpinfo>:
{
    8000236e:	bc010113          	addi	sp,sp,-1088
    80002372:	42113c23          	sd	ra,1080(sp)
    80002376:	42813823          	sd	s0,1072(sp)
    8000237a:	42913423          	sd	s1,1064(sp)
    8000237e:	43213023          	sd	s2,1056(sp)
    80002382:	41313c23          	sd	s3,1048(sp)
    80002386:	41413823          	sd	s4,1040(sp)
    8000238a:	41513423          	sd	s5,1032(sp)
    8000238e:	41613023          	sd	s6,1024(sp)
    80002392:	44010413          	addi	s0,sp,1088
    80002396:	8b2a                	mv	s6,a0
    for(p = proc; p < &proc[NPROC]; p++) {
    80002398:	bc040913          	addi	s2,s0,-1088
    8000239c:	00010497          	auipc	s1,0x10
    800023a0:	99448493          	addi	s1,s1,-1644 # 80011d30 <proc>
	       info.inuse[i] = 1;
    800023a4:	4a85                	li	s5,1
	       info.tickets[i] = -1;
    800023a6:	59fd                	li	s3,-1
    for(p = proc; p < &proc[NPROC]; p++) {
    800023a8:	00015a17          	auipc	s4,0x15
    800023ac:	788a0a13          	addi	s4,s4,1928 # 80017b30 <tickslock>
    800023b0:	a01d                	j	800023d6 <getpinfo+0x68>
         info.inuse[i] = 0;
    800023b2:	00092023          	sw	zero,0(s2)
	       info.tickets[i] = -1;
    800023b6:	11392023          	sw	s3,256(s2)
	       info.pid[i] = -1;
    800023ba:	21392023          	sw	s3,512(s2)
	       info.ticks[i] = 0;
    800023be:	30092023          	sw	zero,768(s2)
       release(&p->lock);
    800023c2:	8526                	mv	a0,s1
    800023c4:	ffffe097          	auipc	ra,0xffffe
    800023c8:	762080e7          	jalr	1890(ra) # 80000b26 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800023cc:	17848493          	addi	s1,s1,376
    800023d0:	0911                	addi	s2,s2,4
    800023d2:	03448663          	beq	s1,s4,800023fe <getpinfo+0x90>
       acquire(&p->lock);
    800023d6:	8526                	mv	a0,s1
    800023d8:	ffffe097          	auipc	ra,0xffffe
    800023dc:	6fa080e7          	jalr	1786(ra) # 80000ad2 <acquire>
       if(p->state == UNUSED || p->state == ZOMBIE) {
    800023e0:	4c9c                	lw	a5,24(s1)
    800023e2:	9bed                	andi	a5,a5,-5
    800023e4:	d7f9                	beqz	a5,800023b2 <getpinfo+0x44>
	       info.inuse[i] = 1;
    800023e6:	01592023          	sw	s5,0(s2)
         info.tickets[i] = p->ticket;
    800023ea:	5cdc                	lw	a5,60(s1)
    800023ec:	10f92023          	sw	a5,256(s2)
         info.pid[i] = p->pid;
    800023f0:	5c9c                	lw	a5,56(s1)
    800023f2:	20f92023          	sw	a5,512(s2)
         info.ticks[i] = p->total_tick;
    800023f6:	40fc                	lw	a5,68(s1)
    800023f8:	30f92023          	sw	a5,768(s2)
    800023fc:	b7d9                	j	800023c2 <getpinfo+0x54>
    p = myproc();
    800023fe:	fffff097          	auipc	ra,0xfffff
    80002402:	704080e7          	jalr	1796(ra) # 80001b02 <myproc>
    if(copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0)
    80002406:	40000693          	li	a3,1024
    8000240a:	bc040613          	addi	a2,s0,-1088
    8000240e:	85da                	mv	a1,s6
    80002410:	7128                	ld	a0,96(a0)
    80002412:	fffff097          	auipc	ra,0xfffff
    80002416:	16a080e7          	jalr	362(ra) # 8000157c <copyout>
}
    8000241a:	41f5551b          	sraiw	a0,a0,0x1f
    8000241e:	43813083          	ld	ra,1080(sp)
    80002422:	43013403          	ld	s0,1072(sp)
    80002426:	42813483          	ld	s1,1064(sp)
    8000242a:	42013903          	ld	s2,1056(sp)
    8000242e:	41813983          	ld	s3,1048(sp)
    80002432:	41013a03          	ld	s4,1040(sp)
    80002436:	40813a83          	ld	s5,1032(sp)
    8000243a:	40013b03          	ld	s6,1024(sp)
    8000243e:	44010113          	addi	sp,sp,1088
    80002442:	8082                	ret

0000000080002444 <sys_getpinfo>:
{	
    80002444:	1101                	addi	sp,sp,-32
    80002446:	ec06                	sd	ra,24(sp)
    80002448:	e822                	sd	s0,16(sp)
    8000244a:	1000                	addi	s0,sp,32
    if(argaddr(0, &p) < 0)
    8000244c:	fe840593          	addi	a1,s0,-24
    80002450:	4501                	li	a0,0
    80002452:	00001097          	auipc	ra,0x1
    80002456:	d82080e7          	jalr	-638(ra) # 800031d4 <argaddr>
    8000245a:	02054963          	bltz	a0,8000248c <sys_getpinfo+0x48>
    if(p < PGSIZE){
    8000245e:	fe843503          	ld	a0,-24(s0)
    80002462:	6785                	lui	a5,0x1
    80002464:	00f56a63          	bltu	a0,a5,80002478 <sys_getpinfo+0x34>
    return getpinfo(p);
    80002468:	00000097          	auipc	ra,0x0
    8000246c:	f06080e7          	jalr	-250(ra) # 8000236e <getpinfo>
}
    80002470:	60e2                	ld	ra,24(sp)
    80002472:	6442                	ld	s0,16(sp)
    80002474:	6105                	addi	sp,sp,32
    80002476:	8082                	ret
      printf("Invalid address!\n");
    80002478:	00005517          	auipc	a0,0x5
    8000247c:	f4850513          	addi	a0,a0,-184 # 800073c0 <userret+0x330>
    80002480:	ffffe097          	auipc	ra,0xffffe
    80002484:	118080e7          	jalr	280(ra) # 80000598 <printf>
      return -1;
    80002488:	557d                	li	a0,-1
    8000248a:	b7dd                	j	80002470 <sys_getpinfo+0x2c>
	     return -1;
    8000248c:	557d                	li	a0,-1
    8000248e:	b7cd                	j	80002470 <sys_getpinfo+0x2c>

0000000080002490 <scheduler>:
{
    80002490:	7139                	addi	sp,sp,-64
    80002492:	fc06                	sd	ra,56(sp)
    80002494:	f822                	sd	s0,48(sp)
    80002496:	f426                	sd	s1,40(sp)
    80002498:	f04a                	sd	s2,32(sp)
    8000249a:	ec4e                	sd	s3,24(sp)
    8000249c:	e852                	sd	s4,16(sp)
    8000249e:	e456                	sd	s5,8(sp)
    800024a0:	e05a                	sd	s6,0(sp)
    800024a2:	0080                	addi	s0,sp,64
    800024a4:	8792                	mv	a5,tp
  int id = r_tp();
    800024a6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800024a8:	00779a93          	slli	s5,a5,0x7
    800024ac:	0000f717          	auipc	a4,0xf
    800024b0:	46c70713          	addi	a4,a4,1132 # 80011918 <pid_lock>
    800024b4:	9756                	add	a4,a4,s5
    800024b6:	00073c23          	sd	zero,24(a4)
        swtch(&c->scheduler, &p->context);
    800024ba:	0000f717          	auipc	a4,0xf
    800024be:	47e70713          	addi	a4,a4,1150 # 80011938 <cpus+0x8>
    800024c2:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE){
    800024c4:	4989                	li	s3,2
        p->state = RUNNING;
    800024c6:	4b0d                	li	s6,3
        c->proc = p;
    800024c8:	079e                	slli	a5,a5,0x7
    800024ca:	0000fa17          	auipc	s4,0xf
    800024ce:	44ea0a13          	addi	s4,s4,1102 # 80011918 <pid_lock>
    800024d2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++){
    800024d4:	00015917          	auipc	s2,0x15
    800024d8:	65c90913          	addi	s2,s2,1628 # 80017b30 <tickslock>
  asm volatile("csrr %0, sie" : "=r" (x) );
    800024dc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800024e0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800024e4:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024e8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800024ec:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024f0:	10079073          	csrw	sstatus,a5
    800024f4:	00010497          	auipc	s1,0x10
    800024f8:	83c48493          	addi	s1,s1,-1988 # 80011d30 <proc>
    800024fc:	a03d                	j	8000252a <scheduler+0x9a>
        p->state = RUNNING;
    800024fe:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80002502:	009a3c23          	sd	s1,24(s4)
        swtch(&c->scheduler, &p->context);
    80002506:	07048593          	addi	a1,s1,112
    8000250a:	8556                	mv	a0,s5
    8000250c:	00000097          	auipc	ra,0x0
    80002510:	75c080e7          	jalr	1884(ra) # 80002c68 <swtch>
        c->proc = 0;
    80002514:	000a3c23          	sd	zero,24(s4)
      release(&p->lock);
    80002518:	8526                	mv	a0,s1
    8000251a:	ffffe097          	auipc	ra,0xffffe
    8000251e:	60c080e7          	jalr	1548(ra) # 80000b26 <release>
    for(p = proc; p < &proc[NPROC]; p++){
    80002522:	17848493          	addi	s1,s1,376
    80002526:	fb248be3          	beq	s1,s2,800024dc <scheduler+0x4c>
      acquire(&p->lock);
    8000252a:	8526                	mv	a0,s1
    8000252c:	ffffe097          	auipc	ra,0xffffe
    80002530:	5a6080e7          	jalr	1446(ra) # 80000ad2 <acquire>
      if(p->state == RUNNABLE){
    80002534:	4c9c                	lw	a5,24(s1)
    80002536:	ff3791e3          	bne	a5,s3,80002518 <scheduler+0x88>
    8000253a:	b7d1                	j	800024fe <scheduler+0x6e>

000000008000253c <sched>:
{
    8000253c:	7179                	addi	sp,sp,-48
    8000253e:	f406                	sd	ra,40(sp)
    80002540:	f022                	sd	s0,32(sp)
    80002542:	ec26                	sd	s1,24(sp)
    80002544:	e84a                	sd	s2,16(sp)
    80002546:	e44e                	sd	s3,8(sp)
    80002548:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000254a:	fffff097          	auipc	ra,0xfffff
    8000254e:	5b8080e7          	jalr	1464(ra) # 80001b02 <myproc>
    80002552:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002554:	ffffe097          	auipc	ra,0xffffe
    80002558:	53e080e7          	jalr	1342(ra) # 80000a92 <holding>
    8000255c:	c93d                	beqz	a0,800025d2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000255e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1) //originally is 1
    80002560:	2781                	sext.w	a5,a5
    80002562:	079e                	slli	a5,a5,0x7
    80002564:	0000f717          	auipc	a4,0xf
    80002568:	3b470713          	addi	a4,a4,948 # 80011918 <pid_lock>
    8000256c:	97ba                	add	a5,a5,a4
    8000256e:	0907a703          	lw	a4,144(a5) # 1090 <_entry-0x7fffef70>
    80002572:	4785                	li	a5,1
    80002574:	06f71763          	bne	a4,a5,800025e2 <sched+0xa6>
  if(p->state == RUNNING)
    80002578:	4c98                	lw	a4,24(s1)
    8000257a:	478d                	li	a5,3
    8000257c:	06f70b63          	beq	a4,a5,800025f2 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002580:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002584:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002586:	efb5                	bnez	a5,80002602 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002588:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000258a:	0000f917          	auipc	s2,0xf
    8000258e:	38e90913          	addi	s2,s2,910 # 80011918 <pid_lock>
    80002592:	2781                	sext.w	a5,a5
    80002594:	079e                	slli	a5,a5,0x7
    80002596:	97ca                	add	a5,a5,s2
    80002598:	0947a983          	lw	s3,148(a5)
    8000259c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->scheduler);
    8000259e:	2781                	sext.w	a5,a5
    800025a0:	079e                	slli	a5,a5,0x7
    800025a2:	0000f597          	auipc	a1,0xf
    800025a6:	39658593          	addi	a1,a1,918 # 80011938 <cpus+0x8>
    800025aa:	95be                	add	a1,a1,a5
    800025ac:	07048513          	addi	a0,s1,112
    800025b0:	00000097          	auipc	ra,0x0
    800025b4:	6b8080e7          	jalr	1720(ra) # 80002c68 <swtch>
    800025b8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800025ba:	2781                	sext.w	a5,a5
    800025bc:	079e                	slli	a5,a5,0x7
    800025be:	97ca                	add	a5,a5,s2
    800025c0:	0937aa23          	sw	s3,148(a5)
}
    800025c4:	70a2                	ld	ra,40(sp)
    800025c6:	7402                	ld	s0,32(sp)
    800025c8:	64e2                	ld	s1,24(sp)
    800025ca:	6942                	ld	s2,16(sp)
    800025cc:	69a2                	ld	s3,8(sp)
    800025ce:	6145                	addi	sp,sp,48
    800025d0:	8082                	ret
    panic("sched p->lock");
    800025d2:	00005517          	auipc	a0,0x5
    800025d6:	e0650513          	addi	a0,a0,-506 # 800073d8 <userret+0x348>
    800025da:	ffffe097          	auipc	ra,0xffffe
    800025de:	f74080e7          	jalr	-140(ra) # 8000054e <panic>
    panic("sched locks");
    800025e2:	00005517          	auipc	a0,0x5
    800025e6:	e0650513          	addi	a0,a0,-506 # 800073e8 <userret+0x358>
    800025ea:	ffffe097          	auipc	ra,0xffffe
    800025ee:	f64080e7          	jalr	-156(ra) # 8000054e <panic>
    panic("sched running");
    800025f2:	00005517          	auipc	a0,0x5
    800025f6:	e0650513          	addi	a0,a0,-506 # 800073f8 <userret+0x368>
    800025fa:	ffffe097          	auipc	ra,0xffffe
    800025fe:	f54080e7          	jalr	-172(ra) # 8000054e <panic>
    panic("sched interruptible");
    80002602:	00005517          	auipc	a0,0x5
    80002606:	e0650513          	addi	a0,a0,-506 # 80007408 <userret+0x378>
    8000260a:	ffffe097          	auipc	ra,0xffffe
    8000260e:	f44080e7          	jalr	-188(ra) # 8000054e <panic>

0000000080002612 <exit>:
{
    80002612:	7179                	addi	sp,sp,-48
    80002614:	f406                	sd	ra,40(sp)
    80002616:	f022                	sd	s0,32(sp)
    80002618:	ec26                	sd	s1,24(sp)
    8000261a:	e84a                	sd	s2,16(sp)
    8000261c:	e44e                	sd	s3,8(sp)
    8000261e:	e052                	sd	s4,0(sp)
    80002620:	1800                	addi	s0,sp,48
    80002622:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002624:	fffff097          	auipc	ra,0xfffff
    80002628:	4de080e7          	jalr	1246(ra) # 80001b02 <myproc>
    8000262c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000262e:	00024797          	auipc	a5,0x24
    80002632:	9ea7b783          	ld	a5,-1558(a5) # 80026018 <initproc>
    80002636:	0e050493          	addi	s1,a0,224
    8000263a:	16050913          	addi	s2,a0,352
    8000263e:	02a79363          	bne	a5,a0,80002664 <exit+0x52>
    panic("init exiting");
    80002642:	00005517          	auipc	a0,0x5
    80002646:	dde50513          	addi	a0,a0,-546 # 80007420 <userret+0x390>
    8000264a:	ffffe097          	auipc	ra,0xffffe
    8000264e:	f04080e7          	jalr	-252(ra) # 8000054e <panic>
      fileclose(f);
    80002652:	00002097          	auipc	ra,0x2
    80002656:	55c080e7          	jalr	1372(ra) # 80004bae <fileclose>
      p->ofile[fd] = 0;
    8000265a:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000265e:	04a1                	addi	s1,s1,8
    80002660:	01248563          	beq	s1,s2,8000266a <exit+0x58>
    if(p->ofile[fd]){
    80002664:	6088                	ld	a0,0(s1)
    80002666:	f575                	bnez	a0,80002652 <exit+0x40>
    80002668:	bfdd                	j	8000265e <exit+0x4c>
  begin_op();
    8000266a:	00002097          	auipc	ra,0x2
    8000266e:	072080e7          	jalr	114(ra) # 800046dc <begin_op>
  iput(p->cwd);
    80002672:	1609b503          	ld	a0,352(s3)
    80002676:	00001097          	auipc	ra,0x1
    8000267a:	7de080e7          	jalr	2014(ra) # 80003e54 <iput>
  end_op();
    8000267e:	00002097          	auipc	ra,0x2
    80002682:	0de080e7          	jalr	222(ra) # 8000475c <end_op>
  p->cwd = 0;
    80002686:	1609b023          	sd	zero,352(s3)
  acquire(&initproc->lock);
    8000268a:	00024497          	auipc	s1,0x24
    8000268e:	98e48493          	addi	s1,s1,-1650 # 80026018 <initproc>
    80002692:	6088                	ld	a0,0(s1)
    80002694:	ffffe097          	auipc	ra,0xffffe
    80002698:	43e080e7          	jalr	1086(ra) # 80000ad2 <acquire>
  wakeup1(initproc);
    8000269c:	6088                	ld	a0,0(s1)
    8000269e:	fffff097          	auipc	ra,0xfffff
    800026a2:	324080e7          	jalr	804(ra) # 800019c2 <wakeup1>
  release(&initproc->lock);
    800026a6:	6088                	ld	a0,0(s1)
    800026a8:	ffffe097          	auipc	ra,0xffffe
    800026ac:	47e080e7          	jalr	1150(ra) # 80000b26 <release>
  acquire(&p->lock);
    800026b0:	854e                	mv	a0,s3
    800026b2:	ffffe097          	auipc	ra,0xffffe
    800026b6:	420080e7          	jalr	1056(ra) # 80000ad2 <acquire>
  struct proc *original_parent = p->parent;
    800026ba:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    800026be:	854e                	mv	a0,s3
    800026c0:	ffffe097          	auipc	ra,0xffffe
    800026c4:	466080e7          	jalr	1126(ra) # 80000b26 <release>
  acquire(&original_parent->lock);
    800026c8:	8526                	mv	a0,s1
    800026ca:	ffffe097          	auipc	ra,0xffffe
    800026ce:	408080e7          	jalr	1032(ra) # 80000ad2 <acquire>
  acquire(&p->lock);
    800026d2:	854e                	mv	a0,s3
    800026d4:	ffffe097          	auipc	ra,0xffffe
    800026d8:	3fe080e7          	jalr	1022(ra) # 80000ad2 <acquire>
  reparent(p);
    800026dc:	854e                	mv	a0,s3
    800026de:	00000097          	auipc	ra,0x0
    800026e2:	baa080e7          	jalr	-1110(ra) # 80002288 <reparent>
  wakeup1(original_parent);
    800026e6:	8526                	mv	a0,s1
    800026e8:	fffff097          	auipc	ra,0xfffff
    800026ec:	2da080e7          	jalr	730(ra) # 800019c2 <wakeup1>
  p->xstate = status;
    800026f0:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800026f4:	4791                	li	a5,4
    800026f6:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    800026fa:	8526                	mv	a0,s1
    800026fc:	ffffe097          	auipc	ra,0xffffe
    80002700:	42a080e7          	jalr	1066(ra) # 80000b26 <release>
  sched();
    80002704:	00000097          	auipc	ra,0x0
    80002708:	e38080e7          	jalr	-456(ra) # 8000253c <sched>
  panic("zombie exit");
    8000270c:	00005517          	auipc	a0,0x5
    80002710:	d2450513          	addi	a0,a0,-732 # 80007430 <userret+0x3a0>
    80002714:	ffffe097          	auipc	ra,0xffffe
    80002718:	e3a080e7          	jalr	-454(ra) # 8000054e <panic>

000000008000271c <yield>:
{
    8000271c:	1101                	addi	sp,sp,-32
    8000271e:	ec06                	sd	ra,24(sp)
    80002720:	e822                	sd	s0,16(sp)
    80002722:	e426                	sd	s1,8(sp)
    80002724:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002726:	fffff097          	auipc	ra,0xfffff
    8000272a:	3dc080e7          	jalr	988(ra) # 80001b02 <myproc>
    8000272e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002730:	ffffe097          	auipc	ra,0xffffe
    80002734:	3a2080e7          	jalr	930(ra) # 80000ad2 <acquire>
  p->state = RUNNABLE;
    80002738:	4789                	li	a5,2
    8000273a:	cc9c                	sw	a5,24(s1)
  p->total_tick+=(ticks - p->start_tick); //p2b, calculate the total tick passed since first start up
    8000273c:	40fc                	lw	a5,68(s1)
    8000273e:	00024717          	auipc	a4,0x24
    80002742:	8e272703          	lw	a4,-1822(a4) # 80026020 <ticks>
    80002746:	9fb9                	addw	a5,a5,a4
    80002748:	40b8                	lw	a4,64(s1)
    8000274a:	9f99                	subw	a5,a5,a4
    8000274c:	c0fc                	sw	a5,68(s1)
  sched();
    8000274e:	00000097          	auipc	ra,0x0
    80002752:	dee080e7          	jalr	-530(ra) # 8000253c <sched>
  release(&p->lock);
    80002756:	8526                	mv	a0,s1
    80002758:	ffffe097          	auipc	ra,0xffffe
    8000275c:	3ce080e7          	jalr	974(ra) # 80000b26 <release>
}
    80002760:	60e2                	ld	ra,24(sp)
    80002762:	6442                	ld	s0,16(sp)
    80002764:	64a2                	ld	s1,8(sp)
    80002766:	6105                	addi	sp,sp,32
    80002768:	8082                	ret

000000008000276a <sleep>:
{
    8000276a:	7179                	addi	sp,sp,-48
    8000276c:	f406                	sd	ra,40(sp)
    8000276e:	f022                	sd	s0,32(sp)
    80002770:	ec26                	sd	s1,24(sp)
    80002772:	e84a                	sd	s2,16(sp)
    80002774:	e44e                	sd	s3,8(sp)
    80002776:	1800                	addi	s0,sp,48
    80002778:	89aa                	mv	s3,a0
    8000277a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000277c:	fffff097          	auipc	ra,0xfffff
    80002780:	386080e7          	jalr	902(ra) # 80001b02 <myproc>
    80002784:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002786:	05250663          	beq	a0,s2,800027d2 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    8000278a:	ffffe097          	auipc	ra,0xffffe
    8000278e:	348080e7          	jalr	840(ra) # 80000ad2 <acquire>
    release(lk);
    80002792:	854a                	mv	a0,s2
    80002794:	ffffe097          	auipc	ra,0xffffe
    80002798:	392080e7          	jalr	914(ra) # 80000b26 <release>
  p->chan = chan;
    8000279c:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800027a0:	4785                	li	a5,1
    800027a2:	cc9c                	sw	a5,24(s1)
  sched();
    800027a4:	00000097          	auipc	ra,0x0
    800027a8:	d98080e7          	jalr	-616(ra) # 8000253c <sched>
  p->chan = 0;
    800027ac:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800027b0:	8526                	mv	a0,s1
    800027b2:	ffffe097          	auipc	ra,0xffffe
    800027b6:	374080e7          	jalr	884(ra) # 80000b26 <release>
    acquire(lk);
    800027ba:	854a                	mv	a0,s2
    800027bc:	ffffe097          	auipc	ra,0xffffe
    800027c0:	316080e7          	jalr	790(ra) # 80000ad2 <acquire>
}
    800027c4:	70a2                	ld	ra,40(sp)
    800027c6:	7402                	ld	s0,32(sp)
    800027c8:	64e2                	ld	s1,24(sp)
    800027ca:	6942                	ld	s2,16(sp)
    800027cc:	69a2                	ld	s3,8(sp)
    800027ce:	6145                	addi	sp,sp,48
    800027d0:	8082                	ret
  p->chan = chan;
    800027d2:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800027d6:	4785                	li	a5,1
    800027d8:	cd1c                	sw	a5,24(a0)
  sched();
    800027da:	00000097          	auipc	ra,0x0
    800027de:	d62080e7          	jalr	-670(ra) # 8000253c <sched>
  p->chan = 0;
    800027e2:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    800027e6:	bff9                	j	800027c4 <sleep+0x5a>

00000000800027e8 <join>:
{
    800027e8:	711d                	addi	sp,sp,-96
    800027ea:	ec86                	sd	ra,88(sp)
    800027ec:	e8a2                	sd	s0,80(sp)
    800027ee:	e4a6                	sd	s1,72(sp)
    800027f0:	e0ca                	sd	s2,64(sp)
    800027f2:	fc4e                	sd	s3,56(sp)
    800027f4:	f852                	sd	s4,48(sp)
    800027f6:	f456                	sd	s5,40(sp)
    800027f8:	f05a                	sd	s6,32(sp)
    800027fa:	ec5e                	sd	s7,24(sp)
    800027fc:	e862                	sd	s8,16(sp)
    800027fe:	1080                	addi	s0,sp,96
    80002800:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002802:	fffff097          	auipc	ra,0xfffff
    80002806:	300080e7          	jalr	768(ra) # 80001b02 <myproc>
    8000280a:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000280c:	8c2a                	mv	s8,a0
    8000280e:	ffffe097          	auipc	ra,0xffffe
    80002812:	2c4080e7          	jalr	708(ra) # 80000ad2 <acquire>
    havekids = 0;
    80002816:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002818:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    8000281a:	00015997          	auipc	s3,0x15
    8000281e:	31698993          	addi	s3,s3,790 # 80017b30 <tickslock>
        havekids = 1;
    80002822:	4a85                	li	s5,1
    havekids = 0;
    80002824:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002826:	0000f497          	auipc	s1,0xf
    8000282a:	50a48493          	addi	s1,s1,1290 # 80011d30 <proc>
    8000282e:	a08d                	j	80002890 <join+0xa8>
          pid = np->pid;
    80002830:	0384a983          	lw	s3,56(s1)
          ustack = np->stack;
    80002834:	64bc                	ld	a5,72(s1)
    80002836:	faf43423          	sd	a5,-88(s0)
          if(copyout(np->pagetable, stack, (char *)&ustack, sizeof(ustack)) < 0){
    8000283a:	46a1                	li	a3,8
    8000283c:	fa840613          	addi	a2,s0,-88
    80002840:	85da                	mv	a1,s6
    80002842:	70a8                	ld	a0,96(s1)
    80002844:	fffff097          	auipc	ra,0xfffff
    80002848:	d38080e7          	jalr	-712(ra) # 8000157c <copyout>
    8000284c:	02054263          	bltz	a0,80002870 <join+0x88>
          freeproc(np); 
    80002850:	8526                	mv	a0,s1
    80002852:	fffff097          	auipc	ra,0xfffff
    80002856:	51a080e7          	jalr	1306(ra) # 80001d6c <freeproc>
          release(&np->lock);
    8000285a:	8526                	mv	a0,s1
    8000285c:	ffffe097          	auipc	ra,0xffffe
    80002860:	2ca080e7          	jalr	714(ra) # 80000b26 <release>
          release(&p->lock);
    80002864:	854a                	mv	a0,s2
    80002866:	ffffe097          	auipc	ra,0xffffe
    8000286a:	2c0080e7          	jalr	704(ra) # 80000b26 <release>
          return pid;
    8000286e:	a8a9                	j	800028c8 <join+0xe0>
            release(&np->lock);
    80002870:	8526                	mv	a0,s1
    80002872:	ffffe097          	auipc	ra,0xffffe
    80002876:	2b4080e7          	jalr	692(ra) # 80000b26 <release>
            release(&p->lock);
    8000287a:	854a                	mv	a0,s2
    8000287c:	ffffe097          	auipc	ra,0xffffe
    80002880:	2aa080e7          	jalr	682(ra) # 80000b26 <release>
            return -1;
    80002884:	59fd                	li	s3,-1
    80002886:	a089                	j	800028c8 <join+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    80002888:	17848493          	addi	s1,s1,376
    8000288c:	03348463          	beq	s1,s3,800028b4 <join+0xcc>
      if(np->parent == p ){
    80002890:	709c                	ld	a5,32(s1)
    80002892:	ff279be3          	bne	a5,s2,80002888 <join+0xa0>
        acquire(&np->lock);
    80002896:	8526                	mv	a0,s1
    80002898:	ffffe097          	auipc	ra,0xffffe
    8000289c:	23a080e7          	jalr	570(ra) # 80000ad2 <acquire>
        if(np->state == ZOMBIE){
    800028a0:	4c9c                	lw	a5,24(s1)
    800028a2:	f94787e3          	beq	a5,s4,80002830 <join+0x48>
        release(&np->lock);
    800028a6:	8526                	mv	a0,s1
    800028a8:	ffffe097          	auipc	ra,0xffffe
    800028ac:	27e080e7          	jalr	638(ra) # 80000b26 <release>
        havekids = 1;
    800028b0:	8756                	mv	a4,s5
    800028b2:	bfd9                	j	80002888 <join+0xa0>
    if(!havekids || p->killed){
    800028b4:	c701                	beqz	a4,800028bc <join+0xd4>
    800028b6:	03092783          	lw	a5,48(s2)
    800028ba:	c785                	beqz	a5,800028e2 <join+0xfa>
      release(&p->lock);
    800028bc:	854a                	mv	a0,s2
    800028be:	ffffe097          	auipc	ra,0xffffe
    800028c2:	268080e7          	jalr	616(ra) # 80000b26 <release>
      return -1;
    800028c6:	59fd                	li	s3,-1
}
    800028c8:	854e                	mv	a0,s3
    800028ca:	60e6                	ld	ra,88(sp)
    800028cc:	6446                	ld	s0,80(sp)
    800028ce:	64a6                	ld	s1,72(sp)
    800028d0:	6906                	ld	s2,64(sp)
    800028d2:	79e2                	ld	s3,56(sp)
    800028d4:	7a42                	ld	s4,48(sp)
    800028d6:	7aa2                	ld	s5,40(sp)
    800028d8:	7b02                	ld	s6,32(sp)
    800028da:	6be2                	ld	s7,24(sp)
    800028dc:	6c42                	ld	s8,16(sp)
    800028de:	6125                	addi	sp,sp,96
    800028e0:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    800028e2:	85e2                	mv	a1,s8
    800028e4:	854a                	mv	a0,s2
    800028e6:	00000097          	auipc	ra,0x0
    800028ea:	e84080e7          	jalr	-380(ra) # 8000276a <sleep>
    havekids = 0;
    800028ee:	bf1d                	j	80002824 <join+0x3c>

00000000800028f0 <sys_join>:
{
    800028f0:	1101                	addi	sp,sp,-32
    800028f2:	ec06                	sd	ra,24(sp)
    800028f4:	e822                	sd	s0,16(sp)
    800028f6:	1000                	addi	s0,sp,32
  if(argaddr(0, &stack) < 0)  {
    800028f8:	fe840593          	addi	a1,s0,-24
    800028fc:	4501                	li	a0,0
    800028fe:	00001097          	auipc	ra,0x1
    80002902:	8d6080e7          	jalr	-1834(ra) # 800031d4 <argaddr>
    80002906:	00054c63          	bltz	a0,8000291e <sys_join+0x2e>
    return join(stack);
    8000290a:	fe843503          	ld	a0,-24(s0)
    8000290e:	00000097          	auipc	ra,0x0
    80002912:	eda080e7          	jalr	-294(ra) # 800027e8 <join>
}
    80002916:	60e2                	ld	ra,24(sp)
    80002918:	6442                	ld	s0,16(sp)
    8000291a:	6105                	addi	sp,sp,32
    8000291c:	8082                	ret
    return -1;
    8000291e:	557d                	li	a0,-1
    80002920:	bfdd                	j	80002916 <sys_join+0x26>

0000000080002922 <wait>:
{
    80002922:	715d                	addi	sp,sp,-80
    80002924:	e486                	sd	ra,72(sp)
    80002926:	e0a2                	sd	s0,64(sp)
    80002928:	fc26                	sd	s1,56(sp)
    8000292a:	f84a                	sd	s2,48(sp)
    8000292c:	f44e                	sd	s3,40(sp)
    8000292e:	f052                	sd	s4,32(sp)
    80002930:	ec56                	sd	s5,24(sp)
    80002932:	e85a                	sd	s6,16(sp)
    80002934:	e45e                	sd	s7,8(sp)
    80002936:	e062                	sd	s8,0(sp)
    80002938:	0880                	addi	s0,sp,80
    8000293a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000293c:	fffff097          	auipc	ra,0xfffff
    80002940:	1c6080e7          	jalr	454(ra) # 80001b02 <myproc>
    80002944:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002946:	8c2a                	mv	s8,a0
    80002948:	ffffe097          	auipc	ra,0xffffe
    8000294c:	18a080e7          	jalr	394(ra) # 80000ad2 <acquire>
    havekids = 0;
    80002950:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002952:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    80002954:	00015997          	auipc	s3,0x15
    80002958:	1dc98993          	addi	s3,s3,476 # 80017b30 <tickslock>
        havekids = 1;
    8000295c:	4a85                	li	s5,1
    havekids = 0;
    8000295e:	86de                	mv	a3,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002960:	0000f497          	auipc	s1,0xf
    80002964:	3d048493          	addi	s1,s1,976 # 80011d30 <proc>
    80002968:	a08d                	j	800029ca <wait+0xa8>
          pid = np->pid;
    8000296a:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000296e:	000b0e63          	beqz	s6,8000298a <wait+0x68>
    80002972:	4691                	li	a3,4
    80002974:	03448613          	addi	a2,s1,52
    80002978:	85da                	mv	a1,s6
    8000297a:	06093503          	ld	a0,96(s2)
    8000297e:	fffff097          	auipc	ra,0xfffff
    80002982:	bfe080e7          	jalr	-1026(ra) # 8000157c <copyout>
    80002986:	02054263          	bltz	a0,800029aa <wait+0x88>
          freeproc(np); 
    8000298a:	8526                	mv	a0,s1
    8000298c:	fffff097          	auipc	ra,0xfffff
    80002990:	3e0080e7          	jalr	992(ra) # 80001d6c <freeproc>
          release(&np->lock);
    80002994:	8526                	mv	a0,s1
    80002996:	ffffe097          	auipc	ra,0xffffe
    8000299a:	190080e7          	jalr	400(ra) # 80000b26 <release>
          release(&p->lock);
    8000299e:	854a                	mv	a0,s2
    800029a0:	ffffe097          	auipc	ra,0xffffe
    800029a4:	186080e7          	jalr	390(ra) # 80000b26 <release>
          return pid;
    800029a8:	a095                	j	80002a0c <wait+0xea>
            release(&np->lock);
    800029aa:	8526                	mv	a0,s1
    800029ac:	ffffe097          	auipc	ra,0xffffe
    800029b0:	17a080e7          	jalr	378(ra) # 80000b26 <release>
            release(&p->lock);
    800029b4:	854a                	mv	a0,s2
    800029b6:	ffffe097          	auipc	ra,0xffffe
    800029ba:	170080e7          	jalr	368(ra) # 80000b26 <release>
            return -1;
    800029be:	59fd                	li	s3,-1
    800029c0:	a0b1                	j	80002a0c <wait+0xea>
    for(np = proc; np < &proc[NPROC]; np++){
    800029c2:	17848493          	addi	s1,s1,376
    800029c6:	03348963          	beq	s1,s3,800029f8 <wait+0xd6>
      if(np->parent == p && np->pagetable != p->pagetable ){ //p4 thread modified condition, only wait for forked process not thread
    800029ca:	709c                	ld	a5,32(s1)
    800029cc:	ff279be3          	bne	a5,s2,800029c2 <wait+0xa0>
    800029d0:	70b8                	ld	a4,96(s1)
    800029d2:	06093783          	ld	a5,96(s2)
    800029d6:	fef706e3          	beq	a4,a5,800029c2 <wait+0xa0>
        acquire(&np->lock);
    800029da:	8526                	mv	a0,s1
    800029dc:	ffffe097          	auipc	ra,0xffffe
    800029e0:	0f6080e7          	jalr	246(ra) # 80000ad2 <acquire>
        if(np->state == ZOMBIE){
    800029e4:	4c9c                	lw	a5,24(s1)
    800029e6:	f94782e3          	beq	a5,s4,8000296a <wait+0x48>
        release(&np->lock);
    800029ea:	8526                	mv	a0,s1
    800029ec:	ffffe097          	auipc	ra,0xffffe
    800029f0:	13a080e7          	jalr	314(ra) # 80000b26 <release>
        havekids = 1;
    800029f4:	86d6                	mv	a3,s5
    800029f6:	b7f1                	j	800029c2 <wait+0xa0>
    if(!havekids || p->killed){
    800029f8:	c681                	beqz	a3,80002a00 <wait+0xde>
    800029fa:	03092783          	lw	a5,48(s2)
    800029fe:	c785                	beqz	a5,80002a26 <wait+0x104>
      release(&p->lock);
    80002a00:	854a                	mv	a0,s2
    80002a02:	ffffe097          	auipc	ra,0xffffe
    80002a06:	124080e7          	jalr	292(ra) # 80000b26 <release>
      return -1;
    80002a0a:	59fd                	li	s3,-1
}
    80002a0c:	854e                	mv	a0,s3
    80002a0e:	60a6                	ld	ra,72(sp)
    80002a10:	6406                	ld	s0,64(sp)
    80002a12:	74e2                	ld	s1,56(sp)
    80002a14:	7942                	ld	s2,48(sp)
    80002a16:	79a2                	ld	s3,40(sp)
    80002a18:	7a02                	ld	s4,32(sp)
    80002a1a:	6ae2                	ld	s5,24(sp)
    80002a1c:	6b42                	ld	s6,16(sp)
    80002a1e:	6ba2                	ld	s7,8(sp)
    80002a20:	6c02                	ld	s8,0(sp)
    80002a22:	6161                	addi	sp,sp,80
    80002a24:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    80002a26:	85e2                	mv	a1,s8
    80002a28:	854a                	mv	a0,s2
    80002a2a:	00000097          	auipc	ra,0x0
    80002a2e:	d40080e7          	jalr	-704(ra) # 8000276a <sleep>
    havekids = 0;
    80002a32:	b735                	j	8000295e <wait+0x3c>

0000000080002a34 <wakeup>:
{
    80002a34:	7139                	addi	sp,sp,-64
    80002a36:	fc06                	sd	ra,56(sp)
    80002a38:	f822                	sd	s0,48(sp)
    80002a3a:	f426                	sd	s1,40(sp)
    80002a3c:	f04a                	sd	s2,32(sp)
    80002a3e:	ec4e                	sd	s3,24(sp)
    80002a40:	e852                	sd	s4,16(sp)
    80002a42:	e456                	sd	s5,8(sp)
    80002a44:	0080                	addi	s0,sp,64
    80002a46:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002a48:	0000f497          	auipc	s1,0xf
    80002a4c:	2e848493          	addi	s1,s1,744 # 80011d30 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002a50:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002a52:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80002a54:	00015917          	auipc	s2,0x15
    80002a58:	0dc90913          	addi	s2,s2,220 # 80017b30 <tickslock>
    80002a5c:	a821                	j	80002a74 <wakeup+0x40>
      p->state = RUNNABLE;
    80002a5e:	0154ac23          	sw	s5,24(s1)
    release(&p->lock);
    80002a62:	8526                	mv	a0,s1
    80002a64:	ffffe097          	auipc	ra,0xffffe
    80002a68:	0c2080e7          	jalr	194(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002a6c:	17848493          	addi	s1,s1,376
    80002a70:	01248e63          	beq	s1,s2,80002a8c <wakeup+0x58>
    acquire(&p->lock);
    80002a74:	8526                	mv	a0,s1
    80002a76:	ffffe097          	auipc	ra,0xffffe
    80002a7a:	05c080e7          	jalr	92(ra) # 80000ad2 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002a7e:	4c9c                	lw	a5,24(s1)
    80002a80:	ff3791e3          	bne	a5,s3,80002a62 <wakeup+0x2e>
    80002a84:	749c                	ld	a5,40(s1)
    80002a86:	fd479ee3          	bne	a5,s4,80002a62 <wakeup+0x2e>
    80002a8a:	bfd1                	j	80002a5e <wakeup+0x2a>
}
    80002a8c:	70e2                	ld	ra,56(sp)
    80002a8e:	7442                	ld	s0,48(sp)
    80002a90:	74a2                	ld	s1,40(sp)
    80002a92:	7902                	ld	s2,32(sp)
    80002a94:	69e2                	ld	s3,24(sp)
    80002a96:	6a42                	ld	s4,16(sp)
    80002a98:	6aa2                	ld	s5,8(sp)
    80002a9a:	6121                	addi	sp,sp,64
    80002a9c:	8082                	ret

0000000080002a9e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002a9e:	7179                	addi	sp,sp,-48
    80002aa0:	f406                	sd	ra,40(sp)
    80002aa2:	f022                	sd	s0,32(sp)
    80002aa4:	ec26                	sd	s1,24(sp)
    80002aa6:	e84a                	sd	s2,16(sp)
    80002aa8:	e44e                	sd	s3,8(sp)
    80002aaa:	1800                	addi	s0,sp,48
    80002aac:	892a                	mv	s2,a0
  struct proc *p;
  //acquire(&sched_lock); //for access the process table
  for(p = proc; p < &proc[NPROC]; p++){
    80002aae:	0000f497          	auipc	s1,0xf
    80002ab2:	28248493          	addi	s1,s1,642 # 80011d30 <proc>
    80002ab6:	00015997          	auipc	s3,0x15
    80002aba:	07a98993          	addi	s3,s3,122 # 80017b30 <tickslock>
    acquire(&p->lock);
    80002abe:	8526                	mv	a0,s1
    80002ac0:	ffffe097          	auipc	ra,0xffffe
    80002ac4:	012080e7          	jalr	18(ra) # 80000ad2 <acquire>
    if(p->pid == pid){
    80002ac8:	5c9c                	lw	a5,56(s1)
    80002aca:	01278d63          	beq	a5,s2,80002ae4 <kill+0x46>
      }
      release(&p->lock);
      //acquire(&sched_lock); //for access the process table
      return 0;
    }
    release(&p->lock);
    80002ace:	8526                	mv	a0,s1
    80002ad0:	ffffe097          	auipc	ra,0xffffe
    80002ad4:	056080e7          	jalr	86(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002ad8:	17848493          	addi	s1,s1,376
    80002adc:	ff3491e3          	bne	s1,s3,80002abe <kill+0x20>
  }
  //release(&sched_lock); //for access the process table
  return -1;
    80002ae0:	557d                	li	a0,-1
    80002ae2:	a821                	j	80002afa <kill+0x5c>
      p->killed = 1;
    80002ae4:	4785                	li	a5,1
    80002ae6:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002ae8:	4c98                	lw	a4,24(s1)
    80002aea:	00f70f63          	beq	a4,a5,80002b08 <kill+0x6a>
      release(&p->lock);
    80002aee:	8526                	mv	a0,s1
    80002af0:	ffffe097          	auipc	ra,0xffffe
    80002af4:	036080e7          	jalr	54(ra) # 80000b26 <release>
      return 0;
    80002af8:	4501                	li	a0,0
}
    80002afa:	70a2                	ld	ra,40(sp)
    80002afc:	7402                	ld	s0,32(sp)
    80002afe:	64e2                	ld	s1,24(sp)
    80002b00:	6942                	ld	s2,16(sp)
    80002b02:	69a2                	ld	s3,8(sp)
    80002b04:	6145                	addi	sp,sp,48
    80002b06:	8082                	ret
        p->state = RUNNABLE;
    80002b08:	4789                	li	a5,2
    80002b0a:	cc9c                	sw	a5,24(s1)
    80002b0c:	b7cd                	j	80002aee <kill+0x50>

0000000080002b0e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002b0e:	7179                	addi	sp,sp,-48
    80002b10:	f406                	sd	ra,40(sp)
    80002b12:	f022                	sd	s0,32(sp)
    80002b14:	ec26                	sd	s1,24(sp)
    80002b16:	e84a                	sd	s2,16(sp)
    80002b18:	e44e                	sd	s3,8(sp)
    80002b1a:	e052                	sd	s4,0(sp)
    80002b1c:	1800                	addi	s0,sp,48
    80002b1e:	84aa                	mv	s1,a0
    80002b20:	892e                	mv	s2,a1
    80002b22:	89b2                	mv	s3,a2
    80002b24:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002b26:	fffff097          	auipc	ra,0xfffff
    80002b2a:	fdc080e7          	jalr	-36(ra) # 80001b02 <myproc>
  if(user_dst){
    80002b2e:	c08d                	beqz	s1,80002b50 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002b30:	86d2                	mv	a3,s4
    80002b32:	864e                	mv	a2,s3
    80002b34:	85ca                	mv	a1,s2
    80002b36:	7128                	ld	a0,96(a0)
    80002b38:	fffff097          	auipc	ra,0xfffff
    80002b3c:	a44080e7          	jalr	-1468(ra) # 8000157c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002b40:	70a2                	ld	ra,40(sp)
    80002b42:	7402                	ld	s0,32(sp)
    80002b44:	64e2                	ld	s1,24(sp)
    80002b46:	6942                	ld	s2,16(sp)
    80002b48:	69a2                	ld	s3,8(sp)
    80002b4a:	6a02                	ld	s4,0(sp)
    80002b4c:	6145                	addi	sp,sp,48
    80002b4e:	8082                	ret
    memmove((char *)dst, src, len);
    80002b50:	000a061b          	sext.w	a2,s4
    80002b54:	85ce                	mv	a1,s3
    80002b56:	854a                	mv	a0,s2
    80002b58:	ffffe097          	auipc	ra,0xffffe
    80002b5c:	076080e7          	jalr	118(ra) # 80000bce <memmove>
    return 0;
    80002b60:	8526                	mv	a0,s1
    80002b62:	bff9                	j	80002b40 <either_copyout+0x32>

0000000080002b64 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002b64:	7179                	addi	sp,sp,-48
    80002b66:	f406                	sd	ra,40(sp)
    80002b68:	f022                	sd	s0,32(sp)
    80002b6a:	ec26                	sd	s1,24(sp)
    80002b6c:	e84a                	sd	s2,16(sp)
    80002b6e:	e44e                	sd	s3,8(sp)
    80002b70:	e052                	sd	s4,0(sp)
    80002b72:	1800                	addi	s0,sp,48
    80002b74:	892a                	mv	s2,a0
    80002b76:	84ae                	mv	s1,a1
    80002b78:	89b2                	mv	s3,a2
    80002b7a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002b7c:	fffff097          	auipc	ra,0xfffff
    80002b80:	f86080e7          	jalr	-122(ra) # 80001b02 <myproc>
  if(user_src){
    80002b84:	c08d                	beqz	s1,80002ba6 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002b86:	86d2                	mv	a3,s4
    80002b88:	864e                	mv	a2,s3
    80002b8a:	85ca                	mv	a1,s2
    80002b8c:	7128                	ld	a0,96(a0)
    80002b8e:	fffff097          	auipc	ra,0xfffff
    80002b92:	a7a080e7          	jalr	-1414(ra) # 80001608 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002b96:	70a2                	ld	ra,40(sp)
    80002b98:	7402                	ld	s0,32(sp)
    80002b9a:	64e2                	ld	s1,24(sp)
    80002b9c:	6942                	ld	s2,16(sp)
    80002b9e:	69a2                	ld	s3,8(sp)
    80002ba0:	6a02                	ld	s4,0(sp)
    80002ba2:	6145                	addi	sp,sp,48
    80002ba4:	8082                	ret
    memmove(dst, (char*)src, len);
    80002ba6:	000a061b          	sext.w	a2,s4
    80002baa:	85ce                	mv	a1,s3
    80002bac:	854a                	mv	a0,s2
    80002bae:	ffffe097          	auipc	ra,0xffffe
    80002bb2:	020080e7          	jalr	32(ra) # 80000bce <memmove>
    return 0;
    80002bb6:	8526                	mv	a0,s1
    80002bb8:	bff9                	j	80002b96 <either_copyin+0x32>

0000000080002bba <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002bba:	715d                	addi	sp,sp,-80
    80002bbc:	e486                	sd	ra,72(sp)
    80002bbe:	e0a2                	sd	s0,64(sp)
    80002bc0:	fc26                	sd	s1,56(sp)
    80002bc2:	f84a                	sd	s2,48(sp)
    80002bc4:	f44e                	sd	s3,40(sp)
    80002bc6:	f052                	sd	s4,32(sp)
    80002bc8:	ec56                	sd	s5,24(sp)
    80002bca:	e85a                	sd	s6,16(sp)
    80002bcc:	e45e                	sd	s7,8(sp)
    80002bce:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002bd0:	00005517          	auipc	a0,0x5
    80002bd4:	80050513          	addi	a0,a0,-2048 # 800073d0 <userret+0x340>
    80002bd8:	ffffe097          	auipc	ra,0xffffe
    80002bdc:	9c0080e7          	jalr	-1600(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002be0:	0000f497          	auipc	s1,0xf
    80002be4:	2b848493          	addi	s1,s1,696 # 80011e98 <proc+0x168>
    80002be8:	00015917          	auipc	s2,0x15
    80002bec:	0b090913          	addi	s2,s2,176 # 80017c98 <bcache+0x150>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002bf0:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    80002bf2:	00005997          	auipc	s3,0x5
    80002bf6:	84e98993          	addi	s3,s3,-1970 # 80007440 <userret+0x3b0>
    printf("%d %s %s", p->pid, state, p->name);
    80002bfa:	00005a97          	auipc	s5,0x5
    80002bfe:	84ea8a93          	addi	s5,s5,-1970 # 80007448 <userret+0x3b8>
    printf("\n");
    80002c02:	00004a17          	auipc	s4,0x4
    80002c06:	7cea0a13          	addi	s4,s4,1998 # 800073d0 <userret+0x340>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002c0a:	00005b97          	auipc	s7,0x5
    80002c0e:	d56b8b93          	addi	s7,s7,-682 # 80007960 <states.1810>
    80002c12:	a00d                	j	80002c34 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002c14:	ed06a583          	lw	a1,-304(a3)
    80002c18:	8556                	mv	a0,s5
    80002c1a:	ffffe097          	auipc	ra,0xffffe
    80002c1e:	97e080e7          	jalr	-1666(ra) # 80000598 <printf>
    printf("\n");
    80002c22:	8552                	mv	a0,s4
    80002c24:	ffffe097          	auipc	ra,0xffffe
    80002c28:	974080e7          	jalr	-1676(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002c2c:	17848493          	addi	s1,s1,376
    80002c30:	03248163          	beq	s1,s2,80002c52 <procdump+0x98>
    if(p->state == UNUSED)
    80002c34:	86a6                	mv	a3,s1
    80002c36:	eb04a783          	lw	a5,-336(s1)
    80002c3a:	dbed                	beqz	a5,80002c2c <procdump+0x72>
      state = "???";
    80002c3c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002c3e:	fcfb6be3          	bltu	s6,a5,80002c14 <procdump+0x5a>
    80002c42:	1782                	slli	a5,a5,0x20
    80002c44:	9381                	srli	a5,a5,0x20
    80002c46:	078e                	slli	a5,a5,0x3
    80002c48:	97de                	add	a5,a5,s7
    80002c4a:	6390                	ld	a2,0(a5)
    80002c4c:	f661                	bnez	a2,80002c14 <procdump+0x5a>
      state = "???";
    80002c4e:	864e                	mv	a2,s3
    80002c50:	b7d1                	j	80002c14 <procdump+0x5a>
  }
}
    80002c52:	60a6                	ld	ra,72(sp)
    80002c54:	6406                	ld	s0,64(sp)
    80002c56:	74e2                	ld	s1,56(sp)
    80002c58:	7942                	ld	s2,48(sp)
    80002c5a:	79a2                	ld	s3,40(sp)
    80002c5c:	7a02                	ld	s4,32(sp)
    80002c5e:	6ae2                	ld	s5,24(sp)
    80002c60:	6b42                	ld	s6,16(sp)
    80002c62:	6ba2                	ld	s7,8(sp)
    80002c64:	6161                	addi	sp,sp,80
    80002c66:	8082                	ret

0000000080002c68 <swtch>:
    80002c68:	00153023          	sd	ra,0(a0)
    80002c6c:	00253423          	sd	sp,8(a0)
    80002c70:	e900                	sd	s0,16(a0)
    80002c72:	ed04                	sd	s1,24(a0)
    80002c74:	03253023          	sd	s2,32(a0)
    80002c78:	03353423          	sd	s3,40(a0)
    80002c7c:	03453823          	sd	s4,48(a0)
    80002c80:	03553c23          	sd	s5,56(a0)
    80002c84:	05653023          	sd	s6,64(a0)
    80002c88:	05753423          	sd	s7,72(a0)
    80002c8c:	05853823          	sd	s8,80(a0)
    80002c90:	05953c23          	sd	s9,88(a0)
    80002c94:	07a53023          	sd	s10,96(a0)
    80002c98:	07b53423          	sd	s11,104(a0)
    80002c9c:	0005b083          	ld	ra,0(a1)
    80002ca0:	0085b103          	ld	sp,8(a1)
    80002ca4:	6980                	ld	s0,16(a1)
    80002ca6:	6d84                	ld	s1,24(a1)
    80002ca8:	0205b903          	ld	s2,32(a1)
    80002cac:	0285b983          	ld	s3,40(a1)
    80002cb0:	0305ba03          	ld	s4,48(a1)
    80002cb4:	0385ba83          	ld	s5,56(a1)
    80002cb8:	0405bb03          	ld	s6,64(a1)
    80002cbc:	0485bb83          	ld	s7,72(a1)
    80002cc0:	0505bc03          	ld	s8,80(a1)
    80002cc4:	0585bc83          	ld	s9,88(a1)
    80002cc8:	0605bd03          	ld	s10,96(a1)
    80002ccc:	0685bd83          	ld	s11,104(a1)
    80002cd0:	8082                	ret

0000000080002cd2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002cd2:	1141                	addi	sp,sp,-16
    80002cd4:	e406                	sd	ra,8(sp)
    80002cd6:	e022                	sd	s0,0(sp)
    80002cd8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002cda:	00004597          	auipc	a1,0x4
    80002cde:	7a658593          	addi	a1,a1,1958 # 80007480 <userret+0x3f0>
    80002ce2:	00015517          	auipc	a0,0x15
    80002ce6:	e4e50513          	addi	a0,a0,-434 # 80017b30 <tickslock>
    80002cea:	ffffe097          	auipc	ra,0xffffe
    80002cee:	cd6080e7          	jalr	-810(ra) # 800009c0 <initlock>
}
    80002cf2:	60a2                	ld	ra,8(sp)
    80002cf4:	6402                	ld	s0,0(sp)
    80002cf6:	0141                	addi	sp,sp,16
    80002cf8:	8082                	ret

0000000080002cfa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002cfa:	1141                	addi	sp,sp,-16
    80002cfc:	e422                	sd	s0,8(sp)
    80002cfe:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002d00:	00003797          	auipc	a5,0x3
    80002d04:	4f078793          	addi	a5,a5,1264 # 800061f0 <kernelvec>
    80002d08:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002d0c:	6422                	ld	s0,8(sp)
    80002d0e:	0141                	addi	sp,sp,16
    80002d10:	8082                	ret

0000000080002d12 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002d12:	1141                	addi	sp,sp,-16
    80002d14:	e406                	sd	ra,8(sp)
    80002d16:	e022                	sd	s0,0(sp)
    80002d18:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002d1a:	fffff097          	auipc	ra,0xfffff
    80002d1e:	de8080e7          	jalr	-536(ra) # 80001b02 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d22:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002d26:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d28:	10079073          	csrw	sstatus,a5
  // turn off interrupts, since we're switching
  // now from kerneltrap() to usertrap().
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002d2c:	00004817          	auipc	a6,0x4
    80002d30:	2d480813          	addi	a6,a6,724 # 80007000 <trampoline>
    80002d34:	00004717          	auipc	a4,0x4
    80002d38:	2cc70713          	addi	a4,a4,716 # 80007000 <trampoline>
    80002d3c:	41070733          	sub	a4,a4,a6
    80002d40:	04000637          	lui	a2,0x4000
    80002d44:	fff60793          	addi	a5,a2,-1 # 3ffffff <_entry-0x7c000001>
    80002d48:	00c79693          	slli	a3,a5,0xc
    80002d4c:	9736                	add	a4,a4,a3
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002d4e:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->tf->kernel_satp = r_satp();         // kernel page table
    80002d52:	753c                	ld	a5,104(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002d54:	18002773          	csrr	a4,satp
    80002d58:	e398                	sd	a4,0(a5)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002d5a:	753c                	ld	a5,104(a0)
    80002d5c:	6938                	ld	a4,80(a0)
    80002d5e:	6585                	lui	a1,0x1
    80002d60:	972e                	add	a4,a4,a1
    80002d62:	e798                	sd	a4,8(a5)
  p->tf->kernel_trap = (uint64)usertrap;
    80002d64:	753c                	ld	a5,104(a0)
    80002d66:	00000717          	auipc	a4,0x0
    80002d6a:	13a70713          	addi	a4,a4,314 # 80002ea0 <usertrap>
    80002d6e:	eb98                	sd	a4,16(a5)
  p->tf->kernel_hartid = r_tp();         // hartid for cpuid()
    80002d70:	753c                	ld	a5,104(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002d72:	8712                	mv	a4,tp
    80002d74:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d76:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002d7a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002d7e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d82:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->tf->epc);
    80002d86:	753c                	ld	a5,104(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002d88:	6f9c                	ld	a5,24(a5)
    80002d8a:	14179073          	csrw	sepc,a5

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002d8e:	712c                	ld	a1,96(a0)
    80002d90:	81b1                	srli	a1,a1,0xc
  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
  //((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
  ((void (*)(uint64,uint64))fn)(TRAPFRAME-2*(p - proc)*PGSIZE, satp);
    80002d92:	0000f797          	auipc	a5,0xf
    80002d96:	f9e78793          	addi	a5,a5,-98 # 80011d30 <proc>
    80002d9a:	8d1d                	sub	a0,a0,a5
    80002d9c:	8509                	srai	a0,a0,0x2
    80002d9e:	00005797          	auipc	a5,0x5
    80002da2:	cf27b783          	ld	a5,-782(a5) # 80007a90 <syscalls+0xf0>
    80002da6:	02f50533          	mul	a0,a0,a5
    80002daa:	1679                	addi	a2,a2,-2
    80002dac:	9532                	add	a0,a0,a2
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002dae:	00004797          	auipc	a5,0x4
    80002db2:	2e278793          	addi	a5,a5,738 # 80007090 <userret>
    80002db6:	410787b3          	sub	a5,a5,a6
    80002dba:	97b6                	add	a5,a5,a3
  ((void (*)(uint64,uint64))fn)(TRAPFRAME-2*(p - proc)*PGSIZE, satp);
    80002dbc:	577d                	li	a4,-1
    80002dbe:	177e                	slli	a4,a4,0x3f
    80002dc0:	8dd9                	or	a1,a1,a4
    80002dc2:	0532                	slli	a0,a0,0xc
    80002dc4:	9782                	jalr	a5
}
    80002dc6:	60a2                	ld	ra,8(sp)
    80002dc8:	6402                	ld	s0,0(sp)
    80002dca:	0141                	addi	sp,sp,16
    80002dcc:	8082                	ret

0000000080002dce <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002dce:	1101                	addi	sp,sp,-32
    80002dd0:	ec06                	sd	ra,24(sp)
    80002dd2:	e822                	sd	s0,16(sp)
    80002dd4:	e426                	sd	s1,8(sp)
    80002dd6:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002dd8:	00015497          	auipc	s1,0x15
    80002ddc:	d5848493          	addi	s1,s1,-680 # 80017b30 <tickslock>
    80002de0:	8526                	mv	a0,s1
    80002de2:	ffffe097          	auipc	ra,0xffffe
    80002de6:	cf0080e7          	jalr	-784(ra) # 80000ad2 <acquire>
  ticks++;
    80002dea:	00023517          	auipc	a0,0x23
    80002dee:	23650513          	addi	a0,a0,566 # 80026020 <ticks>
    80002df2:	411c                	lw	a5,0(a0)
    80002df4:	2785                	addiw	a5,a5,1
    80002df6:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002df8:	00000097          	auipc	ra,0x0
    80002dfc:	c3c080e7          	jalr	-964(ra) # 80002a34 <wakeup>
  release(&tickslock);
    80002e00:	8526                	mv	a0,s1
    80002e02:	ffffe097          	auipc	ra,0xffffe
    80002e06:	d24080e7          	jalr	-732(ra) # 80000b26 <release>
}
    80002e0a:	60e2                	ld	ra,24(sp)
    80002e0c:	6442                	ld	s0,16(sp)
    80002e0e:	64a2                	ld	s1,8(sp)
    80002e10:	6105                	addi	sp,sp,32
    80002e12:	8082                	ret

0000000080002e14 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002e14:	1101                	addi	sp,sp,-32
    80002e16:	ec06                	sd	ra,24(sp)
    80002e18:	e822                	sd	s0,16(sp)
    80002e1a:	e426                	sd	s1,8(sp)
    80002e1c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e1e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002e22:	00074d63          	bltz	a4,80002e3c <devintr+0x28>
      virtio_disk_intr();
    }

    plic_complete(irq);
    return 1;
  } else if(scause == 0x8000000000000001L){
    80002e26:	57fd                	li	a5,-1
    80002e28:	17fe                	slli	a5,a5,0x3f
    80002e2a:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002e2c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002e2e:	04f70863          	beq	a4,a5,80002e7e <devintr+0x6a>
  }
}
    80002e32:	60e2                	ld	ra,24(sp)
    80002e34:	6442                	ld	s0,16(sp)
    80002e36:	64a2                	ld	s1,8(sp)
    80002e38:	6105                	addi	sp,sp,32
    80002e3a:	8082                	ret
     (scause & 0xff) == 9){
    80002e3c:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002e40:	46a5                	li	a3,9
    80002e42:	fed792e3          	bne	a5,a3,80002e26 <devintr+0x12>
    int irq = plic_claim();
    80002e46:	00003097          	auipc	ra,0x3
    80002e4a:	4c4080e7          	jalr	1220(ra) # 8000630a <plic_claim>
    80002e4e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002e50:	47a9                	li	a5,10
    80002e52:	00f50c63          	beq	a0,a5,80002e6a <devintr+0x56>
    } else if(irq == VIRTIO0_IRQ){
    80002e56:	4785                	li	a5,1
    80002e58:	00f50e63          	beq	a0,a5,80002e74 <devintr+0x60>
    plic_complete(irq);
    80002e5c:	8526                	mv	a0,s1
    80002e5e:	00003097          	auipc	ra,0x3
    80002e62:	4d0080e7          	jalr	1232(ra) # 8000632e <plic_complete>
    return 1;
    80002e66:	4505                	li	a0,1
    80002e68:	b7e9                	j	80002e32 <devintr+0x1e>
      uartintr();
    80002e6a:	ffffe097          	auipc	ra,0xffffe
    80002e6e:	9ce080e7          	jalr	-1586(ra) # 80000838 <uartintr>
    80002e72:	b7ed                	j	80002e5c <devintr+0x48>
      virtio_disk_intr();
    80002e74:	00004097          	auipc	ra,0x4
    80002e78:	94a080e7          	jalr	-1718(ra) # 800067be <virtio_disk_intr>
    80002e7c:	b7c5                	j	80002e5c <devintr+0x48>
    if(cpuid() == 0){
    80002e7e:	fffff097          	auipc	ra,0xfffff
    80002e82:	c58080e7          	jalr	-936(ra) # 80001ad6 <cpuid>
    80002e86:	c901                	beqz	a0,80002e96 <devintr+0x82>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002e88:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002e8c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002e8e:	14479073          	csrw	sip,a5
    return 2;
    80002e92:	4509                	li	a0,2
    80002e94:	bf79                	j	80002e32 <devintr+0x1e>
      clockintr();
    80002e96:	00000097          	auipc	ra,0x0
    80002e9a:	f38080e7          	jalr	-200(ra) # 80002dce <clockintr>
    80002e9e:	b7ed                	j	80002e88 <devintr+0x74>

0000000080002ea0 <usertrap>:
{
    80002ea0:	1101                	addi	sp,sp,-32
    80002ea2:	ec06                	sd	ra,24(sp)
    80002ea4:	e822                	sd	s0,16(sp)
    80002ea6:	e426                	sd	s1,8(sp)
    80002ea8:	e04a                	sd	s2,0(sp)
    80002eaa:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002eac:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002eb0:	1007f793          	andi	a5,a5,256
    80002eb4:	e7bd                	bnez	a5,80002f22 <usertrap+0x82>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002eb6:	00003797          	auipc	a5,0x3
    80002eba:	33a78793          	addi	a5,a5,826 # 800061f0 <kernelvec>
    80002ebe:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002ec2:	fffff097          	auipc	ra,0xfffff
    80002ec6:	c40080e7          	jalr	-960(ra) # 80001b02 <myproc>
    80002eca:	84aa                	mv	s1,a0
  p->tf->epc = r_sepc();
    80002ecc:	753c                	ld	a5,104(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ece:	14102773          	csrr	a4,sepc
    80002ed2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ed4:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002ed8:	47a1                	li	a5,8
    80002eda:	06f71263          	bne	a4,a5,80002f3e <usertrap+0x9e>
    if(p->killed)
    80002ede:	591c                	lw	a5,48(a0)
    80002ee0:	eba9                	bnez	a5,80002f32 <usertrap+0x92>
    p->tf->epc += 4;
    80002ee2:	74b8                	ld	a4,104(s1)
    80002ee4:	6f1c                	ld	a5,24(a4)
    80002ee6:	0791                	addi	a5,a5,4
    80002ee8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sie" : "=r" (x) );
    80002eea:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80002eee:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80002ef2:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ef6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002efa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002efe:	10079073          	csrw	sstatus,a5
    syscall();  //handle the syscall
    80002f02:	00000097          	auipc	ra,0x0
    80002f06:	324080e7          	jalr	804(ra) # 80003226 <syscall>
  if(p->killed)
    80002f0a:	589c                	lw	a5,48(s1)
    80002f0c:	ebf1                	bnez	a5,80002fe0 <usertrap+0x140>
  usertrapret();
    80002f0e:	00000097          	auipc	ra,0x0
    80002f12:	e04080e7          	jalr	-508(ra) # 80002d12 <usertrapret>
}
    80002f16:	60e2                	ld	ra,24(sp)
    80002f18:	6442                	ld	s0,16(sp)
    80002f1a:	64a2                	ld	s1,8(sp)
    80002f1c:	6902                	ld	s2,0(sp)
    80002f1e:	6105                	addi	sp,sp,32
    80002f20:	8082                	ret
    panic("usertrap: not from user mode");
    80002f22:	00004517          	auipc	a0,0x4
    80002f26:	56650513          	addi	a0,a0,1382 # 80007488 <userret+0x3f8>
    80002f2a:	ffffd097          	auipc	ra,0xffffd
    80002f2e:	624080e7          	jalr	1572(ra) # 8000054e <panic>
      exit(-1);
    80002f32:	557d                	li	a0,-1
    80002f34:	fffff097          	auipc	ra,0xfffff
    80002f38:	6de080e7          	jalr	1758(ra) # 80002612 <exit>
    80002f3c:	b75d                	j	80002ee2 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002f3e:	00000097          	auipc	ra,0x0
    80002f42:	ed6080e7          	jalr	-298(ra) # 80002e14 <devintr>
    80002f46:	892a                	mv	s2,a0
    80002f48:	e949                	bnez	a0,80002fda <usertrap+0x13a>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f4a:	14202773          	csrr	a4,scause
  } else if(0xd ==r_scause()){ //p3 this is null pointer deference
    80002f4e:	47b5                	li	a5,13
    80002f50:	04f70d63          	beq	a4,a5,80002faa <usertrap+0x10a>
    80002f54:	14202773          	csrr	a4,scause
  } else if(0xf ==r_scause()){ //p3 this is write to read only memory
    80002f58:	47bd                	li	a5,15
    80002f5a:	06f70463          	beq	a4,a5,80002fc2 <usertrap+0x122>
    80002f5e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002f62:	5c90                	lw	a2,56(s1)
    80002f64:	00004517          	auipc	a0,0x4
    80002f68:	5a450513          	addi	a0,a0,1444 # 80007508 <userret+0x478>
    80002f6c:	ffffd097          	auipc	ra,0xffffd
    80002f70:	62c080e7          	jalr	1580(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f74:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002f78:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002f7c:	00004517          	auipc	a0,0x4
    80002f80:	5bc50513          	addi	a0,a0,1468 # 80007538 <userret+0x4a8>
    80002f84:	ffffd097          	auipc	ra,0xffffd
    80002f88:	614080e7          	jalr	1556(ra) # 80000598 <printf>
    p->killed = 1;
    80002f8c:	4785                	li	a5,1
    80002f8e:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002f90:	557d                	li	a0,-1
    80002f92:	fffff097          	auipc	ra,0xfffff
    80002f96:	680080e7          	jalr	1664(ra) # 80002612 <exit>
  if(which_dev == 2)
    80002f9a:	4789                	li	a5,2
    80002f9c:	f6f919e3          	bne	s2,a5,80002f0e <usertrap+0x6e>
    yield();
    80002fa0:	fffff097          	auipc	ra,0xfffff
    80002fa4:	77c080e7          	jalr	1916(ra) # 8000271c <yield>
    80002fa8:	b79d                	j	80002f0e <usertrap+0x6e>
    printf("Illegal Address Accesses, pid=%d\n",p->pid);
    80002faa:	5c8c                	lw	a1,56(s1)
    80002fac:	00004517          	auipc	a0,0x4
    80002fb0:	4fc50513          	addi	a0,a0,1276 # 800074a8 <userret+0x418>
    80002fb4:	ffffd097          	auipc	ra,0xffffd
    80002fb8:	5e4080e7          	jalr	1508(ra) # 80000598 <printf>
    p->killed = 1;
    80002fbc:	4785                	li	a5,1
    80002fbe:	d89c                	sw	a5,48(s1)
    80002fc0:	bfc1                	j	80002f90 <usertrap+0xf0>
    printf("Do not have write permission to this address , pid=%d\n",p->pid);
    80002fc2:	5c8c                	lw	a1,56(s1)
    80002fc4:	00004517          	auipc	a0,0x4
    80002fc8:	50c50513          	addi	a0,a0,1292 # 800074d0 <userret+0x440>
    80002fcc:	ffffd097          	auipc	ra,0xffffd
    80002fd0:	5cc080e7          	jalr	1484(ra) # 80000598 <printf>
    p->killed = 1;
    80002fd4:	4785                	li	a5,1
    80002fd6:	d89c                	sw	a5,48(s1)
    80002fd8:	bf65                	j	80002f90 <usertrap+0xf0>
  if(p->killed)
    80002fda:	589c                	lw	a5,48(s1)
    80002fdc:	dfdd                	beqz	a5,80002f9a <usertrap+0xfa>
    80002fde:	bf4d                	j	80002f90 <usertrap+0xf0>
  int which_dev = 0;
    80002fe0:	4901                	li	s2,0
    80002fe2:	b77d                	j	80002f90 <usertrap+0xf0>

0000000080002fe4 <kerneltrap>:
{
    80002fe4:	7179                	addi	sp,sp,-48
    80002fe6:	f406                	sd	ra,40(sp)
    80002fe8:	f022                	sd	s0,32(sp)
    80002fea:	ec26                	sd	s1,24(sp)
    80002fec:	e84a                	sd	s2,16(sp)
    80002fee:	e44e                	sd	s3,8(sp)
    80002ff0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ff2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ff6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ffa:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002ffe:	1004f793          	andi	a5,s1,256
    80003002:	cb85                	beqz	a5,80003032 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003004:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80003008:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000300a:	ef85                	bnez	a5,80003042 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    8000300c:	00000097          	auipc	ra,0x0
    80003010:	e08080e7          	jalr	-504(ra) # 80002e14 <devintr>
    80003014:	cd1d                	beqz	a0,80003052 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003016:	4789                	li	a5,2
    80003018:	06f50a63          	beq	a0,a5,8000308c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000301c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003020:	10049073          	csrw	sstatus,s1
}
    80003024:	70a2                	ld	ra,40(sp)
    80003026:	7402                	ld	s0,32(sp)
    80003028:	64e2                	ld	s1,24(sp)
    8000302a:	6942                	ld	s2,16(sp)
    8000302c:	69a2                	ld	s3,8(sp)
    8000302e:	6145                	addi	sp,sp,48
    80003030:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80003032:	00004517          	auipc	a0,0x4
    80003036:	52650513          	addi	a0,a0,1318 # 80007558 <userret+0x4c8>
    8000303a:	ffffd097          	auipc	ra,0xffffd
    8000303e:	514080e7          	jalr	1300(ra) # 8000054e <panic>
    panic("kerneltrap: interrupts enabled");
    80003042:	00004517          	auipc	a0,0x4
    80003046:	53e50513          	addi	a0,a0,1342 # 80007580 <userret+0x4f0>
    8000304a:	ffffd097          	auipc	ra,0xffffd
    8000304e:	504080e7          	jalr	1284(ra) # 8000054e <panic>
    printf("scause %p\n", scause);
    80003052:	85ce                	mv	a1,s3
    80003054:	00004517          	auipc	a0,0x4
    80003058:	54c50513          	addi	a0,a0,1356 # 800075a0 <userret+0x510>
    8000305c:	ffffd097          	auipc	ra,0xffffd
    80003060:	53c080e7          	jalr	1340(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003064:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003068:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000306c:	00004517          	auipc	a0,0x4
    80003070:	54450513          	addi	a0,a0,1348 # 800075b0 <userret+0x520>
    80003074:	ffffd097          	auipc	ra,0xffffd
    80003078:	524080e7          	jalr	1316(ra) # 80000598 <printf>
    panic("kerneltrap");
    8000307c:	00004517          	auipc	a0,0x4
    80003080:	54c50513          	addi	a0,a0,1356 # 800075c8 <userret+0x538>
    80003084:	ffffd097          	auipc	ra,0xffffd
    80003088:	4ca080e7          	jalr	1226(ra) # 8000054e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000308c:	fffff097          	auipc	ra,0xfffff
    80003090:	a76080e7          	jalr	-1418(ra) # 80001b02 <myproc>
    80003094:	d541                	beqz	a0,8000301c <kerneltrap+0x38>
    80003096:	fffff097          	auipc	ra,0xfffff
    8000309a:	a6c080e7          	jalr	-1428(ra) # 80001b02 <myproc>
    8000309e:	4d18                	lw	a4,24(a0)
    800030a0:	478d                	li	a5,3
    800030a2:	f6f71de3          	bne	a4,a5,8000301c <kerneltrap+0x38>
    yield();
    800030a6:	fffff097          	auipc	ra,0xfffff
    800030aa:	676080e7          	jalr	1654(ra) # 8000271c <yield>
    800030ae:	b7bd                	j	8000301c <kerneltrap+0x38>

00000000800030b0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800030b0:	1101                	addi	sp,sp,-32
    800030b2:	ec06                	sd	ra,24(sp)
    800030b4:	e822                	sd	s0,16(sp)
    800030b6:	e426                	sd	s1,8(sp)
    800030b8:	1000                	addi	s0,sp,32
    800030ba:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800030bc:	fffff097          	auipc	ra,0xfffff
    800030c0:	a46080e7          	jalr	-1466(ra) # 80001b02 <myproc>
  switch (n) {
    800030c4:	4795                	li	a5,5
    800030c6:	0497e163          	bltu	a5,s1,80003108 <argraw+0x58>
    800030ca:	048a                	slli	s1,s1,0x2
    800030cc:	00005717          	auipc	a4,0x5
    800030d0:	8bc70713          	addi	a4,a4,-1860 # 80007988 <states.1810+0x28>
    800030d4:	94ba                	add	s1,s1,a4
    800030d6:	409c                	lw	a5,0(s1)
    800030d8:	97ba                	add	a5,a5,a4
    800030da:	8782                	jr	a5
  case 0:
    return p->tf->a0;
    800030dc:	753c                	ld	a5,104(a0)
    800030de:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
    800030e0:	60e2                	ld	ra,24(sp)
    800030e2:	6442                	ld	s0,16(sp)
    800030e4:	64a2                	ld	s1,8(sp)
    800030e6:	6105                	addi	sp,sp,32
    800030e8:	8082                	ret
    return p->tf->a1;
    800030ea:	753c                	ld	a5,104(a0)
    800030ec:	7fa8                	ld	a0,120(a5)
    800030ee:	bfcd                	j	800030e0 <argraw+0x30>
    return p->tf->a2;
    800030f0:	753c                	ld	a5,104(a0)
    800030f2:	63c8                	ld	a0,128(a5)
    800030f4:	b7f5                	j	800030e0 <argraw+0x30>
    return p->tf->a3;
    800030f6:	753c                	ld	a5,104(a0)
    800030f8:	67c8                	ld	a0,136(a5)
    800030fa:	b7dd                	j	800030e0 <argraw+0x30>
    return p->tf->a4;
    800030fc:	753c                	ld	a5,104(a0)
    800030fe:	6bc8                	ld	a0,144(a5)
    80003100:	b7c5                	j	800030e0 <argraw+0x30>
    return p->tf->a5;
    80003102:	753c                	ld	a5,104(a0)
    80003104:	6fc8                	ld	a0,152(a5)
    80003106:	bfe9                	j	800030e0 <argraw+0x30>
  panic("argraw");
    80003108:	00004517          	auipc	a0,0x4
    8000310c:	4d050513          	addi	a0,a0,1232 # 800075d8 <userret+0x548>
    80003110:	ffffd097          	auipc	ra,0xffffd
    80003114:	43e080e7          	jalr	1086(ra) # 8000054e <panic>

0000000080003118 <fetchaddr>:
{
    80003118:	1101                	addi	sp,sp,-32
    8000311a:	ec06                	sd	ra,24(sp)
    8000311c:	e822                	sd	s0,16(sp)
    8000311e:	e426                	sd	s1,8(sp)
    80003120:	e04a                	sd	s2,0(sp)
    80003122:	1000                	addi	s0,sp,32
    80003124:	84aa                	mv	s1,a0
    80003126:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003128:	fffff097          	auipc	ra,0xfffff
    8000312c:	9da080e7          	jalr	-1574(ra) # 80001b02 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80003130:	6d3c                	ld	a5,88(a0)
    80003132:	02f4f863          	bgeu	s1,a5,80003162 <fetchaddr+0x4a>
    80003136:	00848713          	addi	a4,s1,8
    8000313a:	02e7e663          	bltu	a5,a4,80003166 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000313e:	46a1                	li	a3,8
    80003140:	8626                	mv	a2,s1
    80003142:	85ca                	mv	a1,s2
    80003144:	7128                	ld	a0,96(a0)
    80003146:	ffffe097          	auipc	ra,0xffffe
    8000314a:	4c2080e7          	jalr	1218(ra) # 80001608 <copyin>
    8000314e:	00a03533          	snez	a0,a0
    80003152:	40a00533          	neg	a0,a0
}
    80003156:	60e2                	ld	ra,24(sp)
    80003158:	6442                	ld	s0,16(sp)
    8000315a:	64a2                	ld	s1,8(sp)
    8000315c:	6902                	ld	s2,0(sp)
    8000315e:	6105                	addi	sp,sp,32
    80003160:	8082                	ret
    return -1;
    80003162:	557d                	li	a0,-1
    80003164:	bfcd                	j	80003156 <fetchaddr+0x3e>
    80003166:	557d                	li	a0,-1
    80003168:	b7fd                	j	80003156 <fetchaddr+0x3e>

000000008000316a <fetchstr>:
{
    8000316a:	7179                	addi	sp,sp,-48
    8000316c:	f406                	sd	ra,40(sp)
    8000316e:	f022                	sd	s0,32(sp)
    80003170:	ec26                	sd	s1,24(sp)
    80003172:	e84a                	sd	s2,16(sp)
    80003174:	e44e                	sd	s3,8(sp)
    80003176:	1800                	addi	s0,sp,48
    80003178:	892a                	mv	s2,a0
    8000317a:	84ae                	mv	s1,a1
    8000317c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000317e:	fffff097          	auipc	ra,0xfffff
    80003182:	984080e7          	jalr	-1660(ra) # 80001b02 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80003186:	86ce                	mv	a3,s3
    80003188:	864a                	mv	a2,s2
    8000318a:	85a6                	mv	a1,s1
    8000318c:	7128                	ld	a0,96(a0)
    8000318e:	ffffe097          	auipc	ra,0xffffe
    80003192:	506080e7          	jalr	1286(ra) # 80001694 <copyinstr>
  if(err < 0)
    80003196:	00054763          	bltz	a0,800031a4 <fetchstr+0x3a>
  return strlen(buf);
    8000319a:	8526                	mv	a0,s1
    8000319c:	ffffe097          	auipc	ra,0xffffe
    800031a0:	b5a080e7          	jalr	-1190(ra) # 80000cf6 <strlen>
}
    800031a4:	70a2                	ld	ra,40(sp)
    800031a6:	7402                	ld	s0,32(sp)
    800031a8:	64e2                	ld	s1,24(sp)
    800031aa:	6942                	ld	s2,16(sp)
    800031ac:	69a2                	ld	s3,8(sp)
    800031ae:	6145                	addi	sp,sp,48
    800031b0:	8082                	ret

00000000800031b2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800031b2:	1101                	addi	sp,sp,-32
    800031b4:	ec06                	sd	ra,24(sp)
    800031b6:	e822                	sd	s0,16(sp)
    800031b8:	e426                	sd	s1,8(sp)
    800031ba:	1000                	addi	s0,sp,32
    800031bc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800031be:	00000097          	auipc	ra,0x0
    800031c2:	ef2080e7          	jalr	-270(ra) # 800030b0 <argraw>
    800031c6:	c088                	sw	a0,0(s1)
  return 0;
}
    800031c8:	4501                	li	a0,0
    800031ca:	60e2                	ld	ra,24(sp)
    800031cc:	6442                	ld	s0,16(sp)
    800031ce:	64a2                	ld	s1,8(sp)
    800031d0:	6105                	addi	sp,sp,32
    800031d2:	8082                	ret

00000000800031d4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800031d4:	1101                	addi	sp,sp,-32
    800031d6:	ec06                	sd	ra,24(sp)
    800031d8:	e822                	sd	s0,16(sp)
    800031da:	e426                	sd	s1,8(sp)
    800031dc:	1000                	addi	s0,sp,32
    800031de:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800031e0:	00000097          	auipc	ra,0x0
    800031e4:	ed0080e7          	jalr	-304(ra) # 800030b0 <argraw>
    800031e8:	e088                	sd	a0,0(s1)
  //if(*ip < PGSIZE)
    //return -1;
  return 0;
}
    800031ea:	4501                	li	a0,0
    800031ec:	60e2                	ld	ra,24(sp)
    800031ee:	6442                	ld	s0,16(sp)
    800031f0:	64a2                	ld	s1,8(sp)
    800031f2:	6105                	addi	sp,sp,32
    800031f4:	8082                	ret

00000000800031f6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800031f6:	1101                	addi	sp,sp,-32
    800031f8:	ec06                	sd	ra,24(sp)
    800031fa:	e822                	sd	s0,16(sp)
    800031fc:	e426                	sd	s1,8(sp)
    800031fe:	e04a                	sd	s2,0(sp)
    80003200:	1000                	addi	s0,sp,32
    80003202:	84ae                	mv	s1,a1
    80003204:	8932                	mv	s2,a2
  *ip = argraw(n);
    80003206:	00000097          	auipc	ra,0x0
    8000320a:	eaa080e7          	jalr	-342(ra) # 800030b0 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000320e:	864a                	mv	a2,s2
    80003210:	85a6                	mv	a1,s1
    80003212:	00000097          	auipc	ra,0x0
    80003216:	f58080e7          	jalr	-168(ra) # 8000316a <fetchstr>
}
    8000321a:	60e2                	ld	ra,24(sp)
    8000321c:	6442                	ld	s0,16(sp)
    8000321e:	64a2                	ld	s1,8(sp)
    80003220:	6902                	ld	s2,0(sp)
    80003222:	6105                	addi	sp,sp,32
    80003224:	8082                	ret

0000000080003226 <syscall>:
//[SYS_tester]	sys_tester, //general purpose tester
};

void
syscall(void)
{
    80003226:	1101                	addi	sp,sp,-32
    80003228:	ec06                	sd	ra,24(sp)
    8000322a:	e822                	sd	s0,16(sp)
    8000322c:	e426                	sd	s1,8(sp)
    8000322e:	e04a                	sd	s2,0(sp)
    80003230:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003232:	fffff097          	auipc	ra,0xfffff
    80003236:	8d0080e7          	jalr	-1840(ra) # 80001b02 <myproc>
    8000323a:	84aa                	mv	s1,a0

  num = p->tf->a7;
    8000323c:	06853903          	ld	s2,104(a0)
    80003240:	0a893783          	ld	a5,168(s2)
    80003244:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003248:	37fd                	addiw	a5,a5,-1
    8000324a:	476d                	li	a4,27
    8000324c:	00f76f63          	bltu	a4,a5,8000326a <syscall+0x44>
    80003250:	00369713          	slli	a4,a3,0x3
    80003254:	00004797          	auipc	a5,0x4
    80003258:	74c78793          	addi	a5,a5,1868 # 800079a0 <syscalls>
    8000325c:	97ba                	add	a5,a5,a4
    8000325e:	639c                	ld	a5,0(a5)
    80003260:	c789                	beqz	a5,8000326a <syscall+0x44>
    p->tf->a0 = syscalls[num]();
    80003262:	9782                	jalr	a5
    80003264:	06a93823          	sd	a0,112(s2)
    80003268:	a839                	j	80003286 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000326a:	16848613          	addi	a2,s1,360
    8000326e:	5c8c                	lw	a1,56(s1)
    80003270:	00004517          	auipc	a0,0x4
    80003274:	37050513          	addi	a0,a0,880 # 800075e0 <userret+0x550>
    80003278:	ffffd097          	auipc	ra,0xffffd
    8000327c:	320080e7          	jalr	800(ra) # 80000598 <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
    80003280:	74bc                	ld	a5,104(s1)
    80003282:	577d                	li	a4,-1
    80003284:	fbb8                	sd	a4,112(a5)
  }
}
    80003286:	60e2                	ld	ra,24(sp)
    80003288:	6442                	ld	s0,16(sp)
    8000328a:	64a2                	ld	s1,8(sp)
    8000328c:	6902                	ld	s2,0(sp)
    8000328e:	6105                	addi	sp,sp,32
    80003290:	8082                	ret

0000000080003292 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003292:	1101                	addi	sp,sp,-32
    80003294:	ec06                	sd	ra,24(sp)
    80003296:	e822                	sd	s0,16(sp)
    80003298:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000329a:	fec40593          	addi	a1,s0,-20
    8000329e:	4501                	li	a0,0
    800032a0:	00000097          	auipc	ra,0x0
    800032a4:	f12080e7          	jalr	-238(ra) # 800031b2 <argint>
    return -1;
    800032a8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800032aa:	00054963          	bltz	a0,800032bc <sys_exit+0x2a>
  exit(n);
    800032ae:	fec42503          	lw	a0,-20(s0)
    800032b2:	fffff097          	auipc	ra,0xfffff
    800032b6:	360080e7          	jalr	864(ra) # 80002612 <exit>
  return 0;  // not reached
    800032ba:	4781                	li	a5,0
}
    800032bc:	853e                	mv	a0,a5
    800032be:	60e2                	ld	ra,24(sp)
    800032c0:	6442                	ld	s0,16(sp)
    800032c2:	6105                	addi	sp,sp,32
    800032c4:	8082                	ret

00000000800032c6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800032c6:	1141                	addi	sp,sp,-16
    800032c8:	e406                	sd	ra,8(sp)
    800032ca:	e022                	sd	s0,0(sp)
    800032cc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800032ce:	fffff097          	auipc	ra,0xfffff
    800032d2:	834080e7          	jalr	-1996(ra) # 80001b02 <myproc>
}
    800032d6:	5d08                	lw	a0,56(a0)
    800032d8:	60a2                	ld	ra,8(sp)
    800032da:	6402                	ld	s0,0(sp)
    800032dc:	0141                	addi	sp,sp,16
    800032de:	8082                	ret

00000000800032e0 <sys_getreadcount>:

uint64
sys_getreadcount(void)
{
    800032e0:	1141                	addi	sp,sp,-16
    800032e2:	e422                	sd	s0,8(sp)
    800032e4:	0800                	addi	s0,sp,16
  return readcounter; //p1b edited
}
    800032e6:	00023517          	auipc	a0,0x23
    800032ea:	d1e52503          	lw	a0,-738(a0) # 80026004 <readcounter>
    800032ee:	6422                	ld	s0,8(sp)
    800032f0:	0141                	addi	sp,sp,16
    800032f2:	8082                	ret

00000000800032f4 <sys_fork>:

uint64
sys_fork(void)
{
    800032f4:	1141                	addi	sp,sp,-16
    800032f6:	e406                	sd	ra,8(sp)
    800032f8:	e022                	sd	s0,0(sp)
    800032fa:	0800                	addi	s0,sp,16
  return fork();
    800032fc:	fffff097          	auipc	ra,0xfffff
    80003300:	c30080e7          	jalr	-976(ra) # 80001f2c <fork>
}
    80003304:	60a2                	ld	ra,8(sp)
    80003306:	6402                	ld	s0,0(sp)
    80003308:	0141                	addi	sp,sp,16
    8000330a:	8082                	ret

000000008000330c <sys_wait>:

uint64
sys_wait(void)
{
    8000330c:	1101                	addi	sp,sp,-32
    8000330e:	ec06                	sd	ra,24(sp)
    80003310:	e822                	sd	s0,16(sp)
    80003312:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80003314:	fe840593          	addi	a1,s0,-24
    80003318:	4501                	li	a0,0
    8000331a:	00000097          	auipc	ra,0x0
    8000331e:	eba080e7          	jalr	-326(ra) # 800031d4 <argaddr>
    80003322:	87aa                	mv	a5,a0
    return -1;
    80003324:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80003326:	0007c863          	bltz	a5,80003336 <sys_wait+0x2a>
  return wait(p);
    8000332a:	fe843503          	ld	a0,-24(s0)
    8000332e:	fffff097          	auipc	ra,0xfffff
    80003332:	5f4080e7          	jalr	1524(ra) # 80002922 <wait>
}
    80003336:	60e2                	ld	ra,24(sp)
    80003338:	6442                	ld	s0,16(sp)
    8000333a:	6105                	addi	sp,sp,32
    8000333c:	8082                	ret

000000008000333e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000333e:	7179                	addi	sp,sp,-48
    80003340:	f406                	sd	ra,40(sp)
    80003342:	f022                	sd	s0,32(sp)
    80003344:	ec26                	sd	s1,24(sp)
    80003346:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80003348:	fdc40593          	addi	a1,s0,-36
    8000334c:	4501                	li	a0,0
    8000334e:	00000097          	auipc	ra,0x0
    80003352:	e64080e7          	jalr	-412(ra) # 800031b2 <argint>
    80003356:	87aa                	mv	a5,a0
    return -1;
    80003358:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000335a:	0207c063          	bltz	a5,8000337a <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000335e:	ffffe097          	auipc	ra,0xffffe
    80003362:	7a4080e7          	jalr	1956(ra) # 80001b02 <myproc>
    80003366:	4d24                	lw	s1,88(a0)
  if(growproc(n) < 0)
    80003368:	fdc42503          	lw	a0,-36(s0)
    8000336c:	fffff097          	auipc	ra,0xfffff
    80003370:	b4c080e7          	jalr	-1204(ra) # 80001eb8 <growproc>
    80003374:	00054863          	bltz	a0,80003384 <sys_sbrk+0x46>
    return -1;
  return addr;
    80003378:	8526                	mv	a0,s1
}
    8000337a:	70a2                	ld	ra,40(sp)
    8000337c:	7402                	ld	s0,32(sp)
    8000337e:	64e2                	ld	s1,24(sp)
    80003380:	6145                	addi	sp,sp,48
    80003382:	8082                	ret
    return -1;
    80003384:	557d                	li	a0,-1
    80003386:	bfd5                	j	8000337a <sys_sbrk+0x3c>

0000000080003388 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003388:	7139                	addi	sp,sp,-64
    8000338a:	fc06                	sd	ra,56(sp)
    8000338c:	f822                	sd	s0,48(sp)
    8000338e:	f426                	sd	s1,40(sp)
    80003390:	f04a                	sd	s2,32(sp)
    80003392:	ec4e                	sd	s3,24(sp)
    80003394:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80003396:	fcc40593          	addi	a1,s0,-52
    8000339a:	4501                	li	a0,0
    8000339c:	00000097          	auipc	ra,0x0
    800033a0:	e16080e7          	jalr	-490(ra) # 800031b2 <argint>
    return -1;
    800033a4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800033a6:	06054563          	bltz	a0,80003410 <sys_sleep+0x88>
  acquire(&tickslock);
    800033aa:	00014517          	auipc	a0,0x14
    800033ae:	78650513          	addi	a0,a0,1926 # 80017b30 <tickslock>
    800033b2:	ffffd097          	auipc	ra,0xffffd
    800033b6:	720080e7          	jalr	1824(ra) # 80000ad2 <acquire>
  ticks0 = ticks;
    800033ba:	00023917          	auipc	s2,0x23
    800033be:	c6692903          	lw	s2,-922(s2) # 80026020 <ticks>
  while(ticks - ticks0 < n){
    800033c2:	fcc42783          	lw	a5,-52(s0)
    800033c6:	cf85                	beqz	a5,800033fe <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800033c8:	00014997          	auipc	s3,0x14
    800033cc:	76898993          	addi	s3,s3,1896 # 80017b30 <tickslock>
    800033d0:	00023497          	auipc	s1,0x23
    800033d4:	c5048493          	addi	s1,s1,-944 # 80026020 <ticks>
    if(myproc()->killed){
    800033d8:	ffffe097          	auipc	ra,0xffffe
    800033dc:	72a080e7          	jalr	1834(ra) # 80001b02 <myproc>
    800033e0:	591c                	lw	a5,48(a0)
    800033e2:	ef9d                	bnez	a5,80003420 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800033e4:	85ce                	mv	a1,s3
    800033e6:	8526                	mv	a0,s1
    800033e8:	fffff097          	auipc	ra,0xfffff
    800033ec:	382080e7          	jalr	898(ra) # 8000276a <sleep>
  while(ticks - ticks0 < n){
    800033f0:	409c                	lw	a5,0(s1)
    800033f2:	412787bb          	subw	a5,a5,s2
    800033f6:	fcc42703          	lw	a4,-52(s0)
    800033fa:	fce7efe3          	bltu	a5,a4,800033d8 <sys_sleep+0x50>
  }
  release(&tickslock);
    800033fe:	00014517          	auipc	a0,0x14
    80003402:	73250513          	addi	a0,a0,1842 # 80017b30 <tickslock>
    80003406:	ffffd097          	auipc	ra,0xffffd
    8000340a:	720080e7          	jalr	1824(ra) # 80000b26 <release>
  return 0;
    8000340e:	4781                	li	a5,0
}
    80003410:	853e                	mv	a0,a5
    80003412:	70e2                	ld	ra,56(sp)
    80003414:	7442                	ld	s0,48(sp)
    80003416:	74a2                	ld	s1,40(sp)
    80003418:	7902                	ld	s2,32(sp)
    8000341a:	69e2                	ld	s3,24(sp)
    8000341c:	6121                	addi	sp,sp,64
    8000341e:	8082                	ret
      release(&tickslock);
    80003420:	00014517          	auipc	a0,0x14
    80003424:	71050513          	addi	a0,a0,1808 # 80017b30 <tickslock>
    80003428:	ffffd097          	auipc	ra,0xffffd
    8000342c:	6fe080e7          	jalr	1790(ra) # 80000b26 <release>
      return -1;
    80003430:	57fd                	li	a5,-1
    80003432:	bff9                	j	80003410 <sys_sleep+0x88>

0000000080003434 <sys_kill>:

uint64
sys_kill(void)
{
    80003434:	1101                	addi	sp,sp,-32
    80003436:	ec06                	sd	ra,24(sp)
    80003438:	e822                	sd	s0,16(sp)
    8000343a:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000343c:	fec40593          	addi	a1,s0,-20
    80003440:	4501                	li	a0,0
    80003442:	00000097          	auipc	ra,0x0
    80003446:	d70080e7          	jalr	-656(ra) # 800031b2 <argint>
    8000344a:	87aa                	mv	a5,a0
    return -1;
    8000344c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000344e:	0007c863          	bltz	a5,8000345e <sys_kill+0x2a>
  return kill(pid);
    80003452:	fec42503          	lw	a0,-20(s0)
    80003456:	fffff097          	auipc	ra,0xfffff
    8000345a:	648080e7          	jalr	1608(ra) # 80002a9e <kill>
}
    8000345e:	60e2                	ld	ra,24(sp)
    80003460:	6442                	ld	s0,16(sp)
    80003462:	6105                	addi	sp,sp,32
    80003464:	8082                	ret

0000000080003466 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003466:	1101                	addi	sp,sp,-32
    80003468:	ec06                	sd	ra,24(sp)
    8000346a:	e822                	sd	s0,16(sp)
    8000346c:	e426                	sd	s1,8(sp)
    8000346e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003470:	00014517          	auipc	a0,0x14
    80003474:	6c050513          	addi	a0,a0,1728 # 80017b30 <tickslock>
    80003478:	ffffd097          	auipc	ra,0xffffd
    8000347c:	65a080e7          	jalr	1626(ra) # 80000ad2 <acquire>
  xticks = ticks;
    80003480:	00023497          	auipc	s1,0x23
    80003484:	ba04a483          	lw	s1,-1120(s1) # 80026020 <ticks>
  release(&tickslock);
    80003488:	00014517          	auipc	a0,0x14
    8000348c:	6a850513          	addi	a0,a0,1704 # 80017b30 <tickslock>
    80003490:	ffffd097          	auipc	ra,0xffffd
    80003494:	696080e7          	jalr	1686(ra) # 80000b26 <release>
  return xticks;
}
    80003498:	02049513          	slli	a0,s1,0x20
    8000349c:	9101                	srli	a0,a0,0x20
    8000349e:	60e2                	ld	ra,24(sp)
    800034a0:	6442                	ld	s0,16(sp)
    800034a2:	64a2                	ld	s1,8(sp)
    800034a4:	6105                	addi	sp,sp,32
    800034a6:	8082                	ret

00000000800034a8 <sys_tester>:

//self defined sys teseter
uint64
sys_tester(void)
{
    800034a8:	1141                	addi	sp,sp,-16
    800034aa:	e422                	sd	s0,8(sp)
    800034ac:	0800                	addi	s0,sp,16
  return 0;
}
    800034ae:	4501                	li	a0,0
    800034b0:	6422                	ld	s0,8(sp)
    800034b2:	0141                	addi	sp,sp,16
    800034b4:	8082                	ret

00000000800034b6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800034b6:	7179                	addi	sp,sp,-48
    800034b8:	f406                	sd	ra,40(sp)
    800034ba:	f022                	sd	s0,32(sp)
    800034bc:	ec26                	sd	s1,24(sp)
    800034be:	e84a                	sd	s2,16(sp)
    800034c0:	e44e                	sd	s3,8(sp)
    800034c2:	e052                	sd	s4,0(sp)
    800034c4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800034c6:	00004597          	auipc	a1,0x4
    800034ca:	13a58593          	addi	a1,a1,314 # 80007600 <userret+0x570>
    800034ce:	00014517          	auipc	a0,0x14
    800034d2:	67a50513          	addi	a0,a0,1658 # 80017b48 <bcache>
    800034d6:	ffffd097          	auipc	ra,0xffffd
    800034da:	4ea080e7          	jalr	1258(ra) # 800009c0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800034de:	0001c797          	auipc	a5,0x1c
    800034e2:	66a78793          	addi	a5,a5,1642 # 8001fb48 <bcache+0x8000>
    800034e6:	0001d717          	auipc	a4,0x1d
    800034ea:	9ba70713          	addi	a4,a4,-1606 # 8001fea0 <bcache+0x8358>
    800034ee:	3ae7b023          	sd	a4,928(a5)
  bcache.head.next = &bcache.head;
    800034f2:	3ae7b423          	sd	a4,936(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800034f6:	00014497          	auipc	s1,0x14
    800034fa:	66a48493          	addi	s1,s1,1642 # 80017b60 <bcache+0x18>
    b->next = bcache.head.next;
    800034fe:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003500:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003502:	00004a17          	auipc	s4,0x4
    80003506:	106a0a13          	addi	s4,s4,262 # 80007608 <userret+0x578>
    b->next = bcache.head.next;
    8000350a:	3a893783          	ld	a5,936(s2)
    8000350e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003510:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003514:	85d2                	mv	a1,s4
    80003516:	01048513          	addi	a0,s1,16
    8000351a:	00001097          	auipc	ra,0x1
    8000351e:	486080e7          	jalr	1158(ra) # 800049a0 <initsleeplock>
    bcache.head.next->prev = b;
    80003522:	3a893783          	ld	a5,936(s2)
    80003526:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003528:	3a993423          	sd	s1,936(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000352c:	46048493          	addi	s1,s1,1120
    80003530:	fd349de3          	bne	s1,s3,8000350a <binit+0x54>
  }
}
    80003534:	70a2                	ld	ra,40(sp)
    80003536:	7402                	ld	s0,32(sp)
    80003538:	64e2                	ld	s1,24(sp)
    8000353a:	6942                	ld	s2,16(sp)
    8000353c:	69a2                	ld	s3,8(sp)
    8000353e:	6a02                	ld	s4,0(sp)
    80003540:	6145                	addi	sp,sp,48
    80003542:	8082                	ret

0000000080003544 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003544:	7179                	addi	sp,sp,-48
    80003546:	f406                	sd	ra,40(sp)
    80003548:	f022                	sd	s0,32(sp)
    8000354a:	ec26                	sd	s1,24(sp)
    8000354c:	e84a                	sd	s2,16(sp)
    8000354e:	e44e                	sd	s3,8(sp)
    80003550:	1800                	addi	s0,sp,48
    80003552:	89aa                	mv	s3,a0
    80003554:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80003556:	00014517          	auipc	a0,0x14
    8000355a:	5f250513          	addi	a0,a0,1522 # 80017b48 <bcache>
    8000355e:	ffffd097          	auipc	ra,0xffffd
    80003562:	574080e7          	jalr	1396(ra) # 80000ad2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003566:	0001d497          	auipc	s1,0x1d
    8000356a:	98a4b483          	ld	s1,-1654(s1) # 8001fef0 <bcache+0x83a8>
    8000356e:	0001d797          	auipc	a5,0x1d
    80003572:	93278793          	addi	a5,a5,-1742 # 8001fea0 <bcache+0x8358>
    80003576:	02f48f63          	beq	s1,a5,800035b4 <bread+0x70>
    8000357a:	873e                	mv	a4,a5
    8000357c:	a021                	j	80003584 <bread+0x40>
    8000357e:	68a4                	ld	s1,80(s1)
    80003580:	02e48a63          	beq	s1,a4,800035b4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003584:	449c                	lw	a5,8(s1)
    80003586:	ff379ce3          	bne	a5,s3,8000357e <bread+0x3a>
    8000358a:	44dc                	lw	a5,12(s1)
    8000358c:	ff2799e3          	bne	a5,s2,8000357e <bread+0x3a>
      b->refcnt++;
    80003590:	40bc                	lw	a5,64(s1)
    80003592:	2785                	addiw	a5,a5,1
    80003594:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003596:	00014517          	auipc	a0,0x14
    8000359a:	5b250513          	addi	a0,a0,1458 # 80017b48 <bcache>
    8000359e:	ffffd097          	auipc	ra,0xffffd
    800035a2:	588080e7          	jalr	1416(ra) # 80000b26 <release>
      acquiresleep(&b->lock);
    800035a6:	01048513          	addi	a0,s1,16
    800035aa:	00001097          	auipc	ra,0x1
    800035ae:	430080e7          	jalr	1072(ra) # 800049da <acquiresleep>
      return b;
    800035b2:	a8b9                	j	80003610 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800035b4:	0001d497          	auipc	s1,0x1d
    800035b8:	9344b483          	ld	s1,-1740(s1) # 8001fee8 <bcache+0x83a0>
    800035bc:	0001d797          	auipc	a5,0x1d
    800035c0:	8e478793          	addi	a5,a5,-1820 # 8001fea0 <bcache+0x8358>
    800035c4:	00f48863          	beq	s1,a5,800035d4 <bread+0x90>
    800035c8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800035ca:	40bc                	lw	a5,64(s1)
    800035cc:	cf81                	beqz	a5,800035e4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800035ce:	64a4                	ld	s1,72(s1)
    800035d0:	fee49de3          	bne	s1,a4,800035ca <bread+0x86>
  panic("bget: no buffers");
    800035d4:	00004517          	auipc	a0,0x4
    800035d8:	03c50513          	addi	a0,a0,60 # 80007610 <userret+0x580>
    800035dc:	ffffd097          	auipc	ra,0xffffd
    800035e0:	f72080e7          	jalr	-142(ra) # 8000054e <panic>
      b->dev = dev;
    800035e4:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800035e8:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800035ec:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800035f0:	4785                	li	a5,1
    800035f2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800035f4:	00014517          	auipc	a0,0x14
    800035f8:	55450513          	addi	a0,a0,1364 # 80017b48 <bcache>
    800035fc:	ffffd097          	auipc	ra,0xffffd
    80003600:	52a080e7          	jalr	1322(ra) # 80000b26 <release>
      acquiresleep(&b->lock);
    80003604:	01048513          	addi	a0,s1,16
    80003608:	00001097          	auipc	ra,0x1
    8000360c:	3d2080e7          	jalr	978(ra) # 800049da <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003610:	409c                	lw	a5,0(s1)
    80003612:	cb89                	beqz	a5,80003624 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003614:	8526                	mv	a0,s1
    80003616:	70a2                	ld	ra,40(sp)
    80003618:	7402                	ld	s0,32(sp)
    8000361a:	64e2                	ld	s1,24(sp)
    8000361c:	6942                	ld	s2,16(sp)
    8000361e:	69a2                	ld	s3,8(sp)
    80003620:	6145                	addi	sp,sp,48
    80003622:	8082                	ret
    virtio_disk_rw(b, 0);
    80003624:	4581                	li	a1,0
    80003626:	8526                	mv	a0,s1
    80003628:	00003097          	auipc	ra,0x3
    8000362c:	ef6080e7          	jalr	-266(ra) # 8000651e <virtio_disk_rw>
    b->valid = 1;
    80003630:	4785                	li	a5,1
    80003632:	c09c                	sw	a5,0(s1)
  return b;
    80003634:	b7c5                	j	80003614 <bread+0xd0>

0000000080003636 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003636:	1101                	addi	sp,sp,-32
    80003638:	ec06                	sd	ra,24(sp)
    8000363a:	e822                	sd	s0,16(sp)
    8000363c:	e426                	sd	s1,8(sp)
    8000363e:	1000                	addi	s0,sp,32
    80003640:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003642:	0541                	addi	a0,a0,16
    80003644:	00001097          	auipc	ra,0x1
    80003648:	430080e7          	jalr	1072(ra) # 80004a74 <holdingsleep>
    8000364c:	cd01                	beqz	a0,80003664 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000364e:	4585                	li	a1,1
    80003650:	8526                	mv	a0,s1
    80003652:	00003097          	auipc	ra,0x3
    80003656:	ecc080e7          	jalr	-308(ra) # 8000651e <virtio_disk_rw>
}
    8000365a:	60e2                	ld	ra,24(sp)
    8000365c:	6442                	ld	s0,16(sp)
    8000365e:	64a2                	ld	s1,8(sp)
    80003660:	6105                	addi	sp,sp,32
    80003662:	8082                	ret
    panic("bwrite");
    80003664:	00004517          	auipc	a0,0x4
    80003668:	fc450513          	addi	a0,a0,-60 # 80007628 <userret+0x598>
    8000366c:	ffffd097          	auipc	ra,0xffffd
    80003670:	ee2080e7          	jalr	-286(ra) # 8000054e <panic>

0000000080003674 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
    80003674:	1101                	addi	sp,sp,-32
    80003676:	ec06                	sd	ra,24(sp)
    80003678:	e822                	sd	s0,16(sp)
    8000367a:	e426                	sd	s1,8(sp)
    8000367c:	e04a                	sd	s2,0(sp)
    8000367e:	1000                	addi	s0,sp,32
    80003680:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003682:	01050913          	addi	s2,a0,16
    80003686:	854a                	mv	a0,s2
    80003688:	00001097          	auipc	ra,0x1
    8000368c:	3ec080e7          	jalr	1004(ra) # 80004a74 <holdingsleep>
    80003690:	c92d                	beqz	a0,80003702 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003692:	854a                	mv	a0,s2
    80003694:	00001097          	auipc	ra,0x1
    80003698:	39c080e7          	jalr	924(ra) # 80004a30 <releasesleep>

  acquire(&bcache.lock);
    8000369c:	00014517          	auipc	a0,0x14
    800036a0:	4ac50513          	addi	a0,a0,1196 # 80017b48 <bcache>
    800036a4:	ffffd097          	auipc	ra,0xffffd
    800036a8:	42e080e7          	jalr	1070(ra) # 80000ad2 <acquire>
  b->refcnt--;
    800036ac:	40bc                	lw	a5,64(s1)
    800036ae:	37fd                	addiw	a5,a5,-1
    800036b0:	0007871b          	sext.w	a4,a5
    800036b4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800036b6:	eb05                	bnez	a4,800036e6 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800036b8:	68bc                	ld	a5,80(s1)
    800036ba:	64b8                	ld	a4,72(s1)
    800036bc:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800036be:	64bc                	ld	a5,72(s1)
    800036c0:	68b8                	ld	a4,80(s1)
    800036c2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800036c4:	0001c797          	auipc	a5,0x1c
    800036c8:	48478793          	addi	a5,a5,1156 # 8001fb48 <bcache+0x8000>
    800036cc:	3a87b703          	ld	a4,936(a5)
    800036d0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800036d2:	0001c717          	auipc	a4,0x1c
    800036d6:	7ce70713          	addi	a4,a4,1998 # 8001fea0 <bcache+0x8358>
    800036da:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800036dc:	3a87b703          	ld	a4,936(a5)
    800036e0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800036e2:	3a97b423          	sd	s1,936(a5)
  }
  
  release(&bcache.lock);
    800036e6:	00014517          	auipc	a0,0x14
    800036ea:	46250513          	addi	a0,a0,1122 # 80017b48 <bcache>
    800036ee:	ffffd097          	auipc	ra,0xffffd
    800036f2:	438080e7          	jalr	1080(ra) # 80000b26 <release>
}
    800036f6:	60e2                	ld	ra,24(sp)
    800036f8:	6442                	ld	s0,16(sp)
    800036fa:	64a2                	ld	s1,8(sp)
    800036fc:	6902                	ld	s2,0(sp)
    800036fe:	6105                	addi	sp,sp,32
    80003700:	8082                	ret
    panic("brelse");
    80003702:	00004517          	auipc	a0,0x4
    80003706:	f2e50513          	addi	a0,a0,-210 # 80007630 <userret+0x5a0>
    8000370a:	ffffd097          	auipc	ra,0xffffd
    8000370e:	e44080e7          	jalr	-444(ra) # 8000054e <panic>

0000000080003712 <bpin>:

void
bpin(struct buf *b) {
    80003712:	1101                	addi	sp,sp,-32
    80003714:	ec06                	sd	ra,24(sp)
    80003716:	e822                	sd	s0,16(sp)
    80003718:	e426                	sd	s1,8(sp)
    8000371a:	1000                	addi	s0,sp,32
    8000371c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000371e:	00014517          	auipc	a0,0x14
    80003722:	42a50513          	addi	a0,a0,1066 # 80017b48 <bcache>
    80003726:	ffffd097          	auipc	ra,0xffffd
    8000372a:	3ac080e7          	jalr	940(ra) # 80000ad2 <acquire>
  b->refcnt++;
    8000372e:	40bc                	lw	a5,64(s1)
    80003730:	2785                	addiw	a5,a5,1
    80003732:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003734:	00014517          	auipc	a0,0x14
    80003738:	41450513          	addi	a0,a0,1044 # 80017b48 <bcache>
    8000373c:	ffffd097          	auipc	ra,0xffffd
    80003740:	3ea080e7          	jalr	1002(ra) # 80000b26 <release>
}
    80003744:	60e2                	ld	ra,24(sp)
    80003746:	6442                	ld	s0,16(sp)
    80003748:	64a2                	ld	s1,8(sp)
    8000374a:	6105                	addi	sp,sp,32
    8000374c:	8082                	ret

000000008000374e <bunpin>:

void
bunpin(struct buf *b) {
    8000374e:	1101                	addi	sp,sp,-32
    80003750:	ec06                	sd	ra,24(sp)
    80003752:	e822                	sd	s0,16(sp)
    80003754:	e426                	sd	s1,8(sp)
    80003756:	1000                	addi	s0,sp,32
    80003758:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000375a:	00014517          	auipc	a0,0x14
    8000375e:	3ee50513          	addi	a0,a0,1006 # 80017b48 <bcache>
    80003762:	ffffd097          	auipc	ra,0xffffd
    80003766:	370080e7          	jalr	880(ra) # 80000ad2 <acquire>
  b->refcnt--;
    8000376a:	40bc                	lw	a5,64(s1)
    8000376c:	37fd                	addiw	a5,a5,-1
    8000376e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003770:	00014517          	auipc	a0,0x14
    80003774:	3d850513          	addi	a0,a0,984 # 80017b48 <bcache>
    80003778:	ffffd097          	auipc	ra,0xffffd
    8000377c:	3ae080e7          	jalr	942(ra) # 80000b26 <release>
}
    80003780:	60e2                	ld	ra,24(sp)
    80003782:	6442                	ld	s0,16(sp)
    80003784:	64a2                	ld	s1,8(sp)
    80003786:	6105                	addi	sp,sp,32
    80003788:	8082                	ret

000000008000378a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000378a:	1101                	addi	sp,sp,-32
    8000378c:	ec06                	sd	ra,24(sp)
    8000378e:	e822                	sd	s0,16(sp)
    80003790:	e426                	sd	s1,8(sp)
    80003792:	e04a                	sd	s2,0(sp)
    80003794:	1000                	addi	s0,sp,32
    80003796:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003798:	00d5d59b          	srliw	a1,a1,0xd
    8000379c:	0001d797          	auipc	a5,0x1d
    800037a0:	b807a783          	lw	a5,-1152(a5) # 8002031c <sb+0x1c>
    800037a4:	9dbd                	addw	a1,a1,a5
    800037a6:	00000097          	auipc	ra,0x0
    800037aa:	d9e080e7          	jalr	-610(ra) # 80003544 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800037ae:	0074f713          	andi	a4,s1,7
    800037b2:	4785                	li	a5,1
    800037b4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800037b8:	14ce                	slli	s1,s1,0x33
    800037ba:	90d9                	srli	s1,s1,0x36
    800037bc:	00950733          	add	a4,a0,s1
    800037c0:	06074703          	lbu	a4,96(a4)
    800037c4:	00e7f6b3          	and	a3,a5,a4
    800037c8:	c69d                	beqz	a3,800037f6 <bfree+0x6c>
    800037ca:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800037cc:	94aa                	add	s1,s1,a0
    800037ce:	fff7c793          	not	a5,a5
    800037d2:	8ff9                	and	a5,a5,a4
    800037d4:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    800037d8:	00001097          	auipc	ra,0x1
    800037dc:	0da080e7          	jalr	218(ra) # 800048b2 <log_write>
  brelse(bp);
    800037e0:	854a                	mv	a0,s2
    800037e2:	00000097          	auipc	ra,0x0
    800037e6:	e92080e7          	jalr	-366(ra) # 80003674 <brelse>
}
    800037ea:	60e2                	ld	ra,24(sp)
    800037ec:	6442                	ld	s0,16(sp)
    800037ee:	64a2                	ld	s1,8(sp)
    800037f0:	6902                	ld	s2,0(sp)
    800037f2:	6105                	addi	sp,sp,32
    800037f4:	8082                	ret
    panic("freeing free block");
    800037f6:	00004517          	auipc	a0,0x4
    800037fa:	e4250513          	addi	a0,a0,-446 # 80007638 <userret+0x5a8>
    800037fe:	ffffd097          	auipc	ra,0xffffd
    80003802:	d50080e7          	jalr	-688(ra) # 8000054e <panic>

0000000080003806 <balloc>:
{
    80003806:	711d                	addi	sp,sp,-96
    80003808:	ec86                	sd	ra,88(sp)
    8000380a:	e8a2                	sd	s0,80(sp)
    8000380c:	e4a6                	sd	s1,72(sp)
    8000380e:	e0ca                	sd	s2,64(sp)
    80003810:	fc4e                	sd	s3,56(sp)
    80003812:	f852                	sd	s4,48(sp)
    80003814:	f456                	sd	s5,40(sp)
    80003816:	f05a                	sd	s6,32(sp)
    80003818:	ec5e                	sd	s7,24(sp)
    8000381a:	e862                	sd	s8,16(sp)
    8000381c:	e466                	sd	s9,8(sp)
    8000381e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003820:	0001d797          	auipc	a5,0x1d
    80003824:	ae47a783          	lw	a5,-1308(a5) # 80020304 <sb+0x4>
    80003828:	cbd1                	beqz	a5,800038bc <balloc+0xb6>
    8000382a:	8baa                	mv	s7,a0
    8000382c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000382e:	0001db17          	auipc	s6,0x1d
    80003832:	ad2b0b13          	addi	s6,s6,-1326 # 80020300 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003836:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003838:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000383a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000383c:	6c89                	lui	s9,0x2
    8000383e:	a831                	j	8000385a <balloc+0x54>
    brelse(bp);
    80003840:	854a                	mv	a0,s2
    80003842:	00000097          	auipc	ra,0x0
    80003846:	e32080e7          	jalr	-462(ra) # 80003674 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000384a:	015c87bb          	addw	a5,s9,s5
    8000384e:	00078a9b          	sext.w	s5,a5
    80003852:	004b2703          	lw	a4,4(s6)
    80003856:	06eaf363          	bgeu	s5,a4,800038bc <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000385a:	41fad79b          	sraiw	a5,s5,0x1f
    8000385e:	0137d79b          	srliw	a5,a5,0x13
    80003862:	015787bb          	addw	a5,a5,s5
    80003866:	40d7d79b          	sraiw	a5,a5,0xd
    8000386a:	01cb2583          	lw	a1,28(s6)
    8000386e:	9dbd                	addw	a1,a1,a5
    80003870:	855e                	mv	a0,s7
    80003872:	00000097          	auipc	ra,0x0
    80003876:	cd2080e7          	jalr	-814(ra) # 80003544 <bread>
    8000387a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000387c:	004b2503          	lw	a0,4(s6)
    80003880:	000a849b          	sext.w	s1,s5
    80003884:	8662                	mv	a2,s8
    80003886:	faa4fde3          	bgeu	s1,a0,80003840 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000388a:	41f6579b          	sraiw	a5,a2,0x1f
    8000388e:	01d7d69b          	srliw	a3,a5,0x1d
    80003892:	00c6873b          	addw	a4,a3,a2
    80003896:	00777793          	andi	a5,a4,7
    8000389a:	9f95                	subw	a5,a5,a3
    8000389c:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800038a0:	4037571b          	sraiw	a4,a4,0x3
    800038a4:	00e906b3          	add	a3,s2,a4
    800038a8:	0606c683          	lbu	a3,96(a3)
    800038ac:	00d7f5b3          	and	a1,a5,a3
    800038b0:	cd91                	beqz	a1,800038cc <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800038b2:	2605                	addiw	a2,a2,1
    800038b4:	2485                	addiw	s1,s1,1
    800038b6:	fd4618e3          	bne	a2,s4,80003886 <balloc+0x80>
    800038ba:	b759                	j	80003840 <balloc+0x3a>
  panic("balloc: out of blocks");
    800038bc:	00004517          	auipc	a0,0x4
    800038c0:	d9450513          	addi	a0,a0,-620 # 80007650 <userret+0x5c0>
    800038c4:	ffffd097          	auipc	ra,0xffffd
    800038c8:	c8a080e7          	jalr	-886(ra) # 8000054e <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800038cc:	974a                	add	a4,a4,s2
    800038ce:	8fd5                	or	a5,a5,a3
    800038d0:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    800038d4:	854a                	mv	a0,s2
    800038d6:	00001097          	auipc	ra,0x1
    800038da:	fdc080e7          	jalr	-36(ra) # 800048b2 <log_write>
        brelse(bp);
    800038de:	854a                	mv	a0,s2
    800038e0:	00000097          	auipc	ra,0x0
    800038e4:	d94080e7          	jalr	-620(ra) # 80003674 <brelse>
  bp = bread(dev, bno);
    800038e8:	85a6                	mv	a1,s1
    800038ea:	855e                	mv	a0,s7
    800038ec:	00000097          	auipc	ra,0x0
    800038f0:	c58080e7          	jalr	-936(ra) # 80003544 <bread>
    800038f4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800038f6:	40000613          	li	a2,1024
    800038fa:	4581                	li	a1,0
    800038fc:	06050513          	addi	a0,a0,96
    80003900:	ffffd097          	auipc	ra,0xffffd
    80003904:	26e080e7          	jalr	622(ra) # 80000b6e <memset>
  log_write(bp);
    80003908:	854a                	mv	a0,s2
    8000390a:	00001097          	auipc	ra,0x1
    8000390e:	fa8080e7          	jalr	-88(ra) # 800048b2 <log_write>
  brelse(bp);
    80003912:	854a                	mv	a0,s2
    80003914:	00000097          	auipc	ra,0x0
    80003918:	d60080e7          	jalr	-672(ra) # 80003674 <brelse>
}
    8000391c:	8526                	mv	a0,s1
    8000391e:	60e6                	ld	ra,88(sp)
    80003920:	6446                	ld	s0,80(sp)
    80003922:	64a6                	ld	s1,72(sp)
    80003924:	6906                	ld	s2,64(sp)
    80003926:	79e2                	ld	s3,56(sp)
    80003928:	7a42                	ld	s4,48(sp)
    8000392a:	7aa2                	ld	s5,40(sp)
    8000392c:	7b02                	ld	s6,32(sp)
    8000392e:	6be2                	ld	s7,24(sp)
    80003930:	6c42                	ld	s8,16(sp)
    80003932:	6ca2                	ld	s9,8(sp)
    80003934:	6125                	addi	sp,sp,96
    80003936:	8082                	ret

0000000080003938 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80003938:	7179                	addi	sp,sp,-48
    8000393a:	f406                	sd	ra,40(sp)
    8000393c:	f022                	sd	s0,32(sp)
    8000393e:	ec26                	sd	s1,24(sp)
    80003940:	e84a                	sd	s2,16(sp)
    80003942:	e44e                	sd	s3,8(sp)
    80003944:	e052                	sd	s4,0(sp)
    80003946:	1800                	addi	s0,sp,48
    80003948:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000394a:	47ad                	li	a5,11
    8000394c:	04b7fe63          	bgeu	a5,a1,800039a8 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003950:	ff45849b          	addiw	s1,a1,-12
    80003954:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003958:	0ff00793          	li	a5,255
    8000395c:	0ae7e363          	bltu	a5,a4,80003a02 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003960:	08052583          	lw	a1,128(a0)
    80003964:	c5ad                	beqz	a1,800039ce <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003966:	00092503          	lw	a0,0(s2)
    8000396a:	00000097          	auipc	ra,0x0
    8000396e:	bda080e7          	jalr	-1062(ra) # 80003544 <bread>
    80003972:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003974:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80003978:	02049593          	slli	a1,s1,0x20
    8000397c:	9181                	srli	a1,a1,0x20
    8000397e:	058a                	slli	a1,a1,0x2
    80003980:	00b784b3          	add	s1,a5,a1
    80003984:	0004a983          	lw	s3,0(s1)
    80003988:	04098d63          	beqz	s3,800039e2 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000398c:	8552                	mv	a0,s4
    8000398e:	00000097          	auipc	ra,0x0
    80003992:	ce6080e7          	jalr	-794(ra) # 80003674 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003996:	854e                	mv	a0,s3
    80003998:	70a2                	ld	ra,40(sp)
    8000399a:	7402                	ld	s0,32(sp)
    8000399c:	64e2                	ld	s1,24(sp)
    8000399e:	6942                	ld	s2,16(sp)
    800039a0:	69a2                	ld	s3,8(sp)
    800039a2:	6a02                	ld	s4,0(sp)
    800039a4:	6145                	addi	sp,sp,48
    800039a6:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800039a8:	02059493          	slli	s1,a1,0x20
    800039ac:	9081                	srli	s1,s1,0x20
    800039ae:	048a                	slli	s1,s1,0x2
    800039b0:	94aa                	add	s1,s1,a0
    800039b2:	0504a983          	lw	s3,80(s1)
    800039b6:	fe0990e3          	bnez	s3,80003996 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800039ba:	4108                	lw	a0,0(a0)
    800039bc:	00000097          	auipc	ra,0x0
    800039c0:	e4a080e7          	jalr	-438(ra) # 80003806 <balloc>
    800039c4:	0005099b          	sext.w	s3,a0
    800039c8:	0534a823          	sw	s3,80(s1)
    800039cc:	b7e9                	j	80003996 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800039ce:	4108                	lw	a0,0(a0)
    800039d0:	00000097          	auipc	ra,0x0
    800039d4:	e36080e7          	jalr	-458(ra) # 80003806 <balloc>
    800039d8:	0005059b          	sext.w	a1,a0
    800039dc:	08b92023          	sw	a1,128(s2)
    800039e0:	b759                	j	80003966 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800039e2:	00092503          	lw	a0,0(s2)
    800039e6:	00000097          	auipc	ra,0x0
    800039ea:	e20080e7          	jalr	-480(ra) # 80003806 <balloc>
    800039ee:	0005099b          	sext.w	s3,a0
    800039f2:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800039f6:	8552                	mv	a0,s4
    800039f8:	00001097          	auipc	ra,0x1
    800039fc:	eba080e7          	jalr	-326(ra) # 800048b2 <log_write>
    80003a00:	b771                	j	8000398c <bmap+0x54>
  panic("bmap: out of range");
    80003a02:	00004517          	auipc	a0,0x4
    80003a06:	c6650513          	addi	a0,a0,-922 # 80007668 <userret+0x5d8>
    80003a0a:	ffffd097          	auipc	ra,0xffffd
    80003a0e:	b44080e7          	jalr	-1212(ra) # 8000054e <panic>

0000000080003a12 <iget>:
{
    80003a12:	7179                	addi	sp,sp,-48
    80003a14:	f406                	sd	ra,40(sp)
    80003a16:	f022                	sd	s0,32(sp)
    80003a18:	ec26                	sd	s1,24(sp)
    80003a1a:	e84a                	sd	s2,16(sp)
    80003a1c:	e44e                	sd	s3,8(sp)
    80003a1e:	e052                	sd	s4,0(sp)
    80003a20:	1800                	addi	s0,sp,48
    80003a22:	89aa                	mv	s3,a0
    80003a24:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    80003a26:	0001d517          	auipc	a0,0x1d
    80003a2a:	8fa50513          	addi	a0,a0,-1798 # 80020320 <icache>
    80003a2e:	ffffd097          	auipc	ra,0xffffd
    80003a32:	0a4080e7          	jalr	164(ra) # 80000ad2 <acquire>
  empty = 0;
    80003a36:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003a38:	0001d497          	auipc	s1,0x1d
    80003a3c:	90048493          	addi	s1,s1,-1792 # 80020338 <icache+0x18>
    80003a40:	0001e697          	auipc	a3,0x1e
    80003a44:	38868693          	addi	a3,a3,904 # 80021dc8 <log>
    80003a48:	a039                	j	80003a56 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003a4a:	02090b63          	beqz	s2,80003a80 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003a4e:	08848493          	addi	s1,s1,136
    80003a52:	02d48a63          	beq	s1,a3,80003a86 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003a56:	449c                	lw	a5,8(s1)
    80003a58:	fef059e3          	blez	a5,80003a4a <iget+0x38>
    80003a5c:	4098                	lw	a4,0(s1)
    80003a5e:	ff3716e3          	bne	a4,s3,80003a4a <iget+0x38>
    80003a62:	40d8                	lw	a4,4(s1)
    80003a64:	ff4713e3          	bne	a4,s4,80003a4a <iget+0x38>
      ip->ref++;
    80003a68:	2785                	addiw	a5,a5,1
    80003a6a:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003a6c:	0001d517          	auipc	a0,0x1d
    80003a70:	8b450513          	addi	a0,a0,-1868 # 80020320 <icache>
    80003a74:	ffffd097          	auipc	ra,0xffffd
    80003a78:	0b2080e7          	jalr	178(ra) # 80000b26 <release>
      return ip;
    80003a7c:	8926                	mv	s2,s1
    80003a7e:	a03d                	j	80003aac <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003a80:	f7f9                	bnez	a5,80003a4e <iget+0x3c>
    80003a82:	8926                	mv	s2,s1
    80003a84:	b7e9                	j	80003a4e <iget+0x3c>
  if(empty == 0)
    80003a86:	02090c63          	beqz	s2,80003abe <iget+0xac>
  ip->dev = dev;
    80003a8a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003a8e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003a92:	4785                	li	a5,1
    80003a94:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003a98:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003a9c:	0001d517          	auipc	a0,0x1d
    80003aa0:	88450513          	addi	a0,a0,-1916 # 80020320 <icache>
    80003aa4:	ffffd097          	auipc	ra,0xffffd
    80003aa8:	082080e7          	jalr	130(ra) # 80000b26 <release>
}
    80003aac:	854a                	mv	a0,s2
    80003aae:	70a2                	ld	ra,40(sp)
    80003ab0:	7402                	ld	s0,32(sp)
    80003ab2:	64e2                	ld	s1,24(sp)
    80003ab4:	6942                	ld	s2,16(sp)
    80003ab6:	69a2                	ld	s3,8(sp)
    80003ab8:	6a02                	ld	s4,0(sp)
    80003aba:	6145                	addi	sp,sp,48
    80003abc:	8082                	ret
    panic("iget: no inodes");
    80003abe:	00004517          	auipc	a0,0x4
    80003ac2:	bc250513          	addi	a0,a0,-1086 # 80007680 <userret+0x5f0>
    80003ac6:	ffffd097          	auipc	ra,0xffffd
    80003aca:	a88080e7          	jalr	-1400(ra) # 8000054e <panic>

0000000080003ace <fsinit>:
fsinit(int dev) {
    80003ace:	7179                	addi	sp,sp,-48
    80003ad0:	f406                	sd	ra,40(sp)
    80003ad2:	f022                	sd	s0,32(sp)
    80003ad4:	ec26                	sd	s1,24(sp)
    80003ad6:	e84a                	sd	s2,16(sp)
    80003ad8:	e44e                	sd	s3,8(sp)
    80003ada:	1800                	addi	s0,sp,48
    80003adc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003ade:	4585                	li	a1,1
    80003ae0:	00000097          	auipc	ra,0x0
    80003ae4:	a64080e7          	jalr	-1436(ra) # 80003544 <bread>
    80003ae8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003aea:	0001d997          	auipc	s3,0x1d
    80003aee:	81698993          	addi	s3,s3,-2026 # 80020300 <sb>
    80003af2:	02000613          	li	a2,32
    80003af6:	06050593          	addi	a1,a0,96
    80003afa:	854e                	mv	a0,s3
    80003afc:	ffffd097          	auipc	ra,0xffffd
    80003b00:	0d2080e7          	jalr	210(ra) # 80000bce <memmove>
  brelse(bp);
    80003b04:	8526                	mv	a0,s1
    80003b06:	00000097          	auipc	ra,0x0
    80003b0a:	b6e080e7          	jalr	-1170(ra) # 80003674 <brelse>
  if(sb.magic != FSMAGIC)
    80003b0e:	0009a703          	lw	a4,0(s3)
    80003b12:	102037b7          	lui	a5,0x10203
    80003b16:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003b1a:	02f71263          	bne	a4,a5,80003b3e <fsinit+0x70>
  initlog(dev, &sb);
    80003b1e:	0001c597          	auipc	a1,0x1c
    80003b22:	7e258593          	addi	a1,a1,2018 # 80020300 <sb>
    80003b26:	854a                	mv	a0,s2
    80003b28:	00001097          	auipc	ra,0x1
    80003b2c:	b12080e7          	jalr	-1262(ra) # 8000463a <initlog>
}
    80003b30:	70a2                	ld	ra,40(sp)
    80003b32:	7402                	ld	s0,32(sp)
    80003b34:	64e2                	ld	s1,24(sp)
    80003b36:	6942                	ld	s2,16(sp)
    80003b38:	69a2                	ld	s3,8(sp)
    80003b3a:	6145                	addi	sp,sp,48
    80003b3c:	8082                	ret
    panic("invalid file system");
    80003b3e:	00004517          	auipc	a0,0x4
    80003b42:	b5250513          	addi	a0,a0,-1198 # 80007690 <userret+0x600>
    80003b46:	ffffd097          	auipc	ra,0xffffd
    80003b4a:	a08080e7          	jalr	-1528(ra) # 8000054e <panic>

0000000080003b4e <iinit>:
{
    80003b4e:	7179                	addi	sp,sp,-48
    80003b50:	f406                	sd	ra,40(sp)
    80003b52:	f022                	sd	s0,32(sp)
    80003b54:	ec26                	sd	s1,24(sp)
    80003b56:	e84a                	sd	s2,16(sp)
    80003b58:	e44e                	sd	s3,8(sp)
    80003b5a:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003b5c:	00004597          	auipc	a1,0x4
    80003b60:	b4c58593          	addi	a1,a1,-1204 # 800076a8 <userret+0x618>
    80003b64:	0001c517          	auipc	a0,0x1c
    80003b68:	7bc50513          	addi	a0,a0,1980 # 80020320 <icache>
    80003b6c:	ffffd097          	auipc	ra,0xffffd
    80003b70:	e54080e7          	jalr	-428(ra) # 800009c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003b74:	0001c497          	auipc	s1,0x1c
    80003b78:	7d448493          	addi	s1,s1,2004 # 80020348 <icache+0x28>
    80003b7c:	0001e997          	auipc	s3,0x1e
    80003b80:	25c98993          	addi	s3,s3,604 # 80021dd8 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003b84:	00004917          	auipc	s2,0x4
    80003b88:	b2c90913          	addi	s2,s2,-1236 # 800076b0 <userret+0x620>
    80003b8c:	85ca                	mv	a1,s2
    80003b8e:	8526                	mv	a0,s1
    80003b90:	00001097          	auipc	ra,0x1
    80003b94:	e10080e7          	jalr	-496(ra) # 800049a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003b98:	08848493          	addi	s1,s1,136
    80003b9c:	ff3498e3          	bne	s1,s3,80003b8c <iinit+0x3e>
}
    80003ba0:	70a2                	ld	ra,40(sp)
    80003ba2:	7402                	ld	s0,32(sp)
    80003ba4:	64e2                	ld	s1,24(sp)
    80003ba6:	6942                	ld	s2,16(sp)
    80003ba8:	69a2                	ld	s3,8(sp)
    80003baa:	6145                	addi	sp,sp,48
    80003bac:	8082                	ret

0000000080003bae <ialloc>:
{
    80003bae:	715d                	addi	sp,sp,-80
    80003bb0:	e486                	sd	ra,72(sp)
    80003bb2:	e0a2                	sd	s0,64(sp)
    80003bb4:	fc26                	sd	s1,56(sp)
    80003bb6:	f84a                	sd	s2,48(sp)
    80003bb8:	f44e                	sd	s3,40(sp)
    80003bba:	f052                	sd	s4,32(sp)
    80003bbc:	ec56                	sd	s5,24(sp)
    80003bbe:	e85a                	sd	s6,16(sp)
    80003bc0:	e45e                	sd	s7,8(sp)
    80003bc2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003bc4:	0001c717          	auipc	a4,0x1c
    80003bc8:	74872703          	lw	a4,1864(a4) # 8002030c <sb+0xc>
    80003bcc:	4785                	li	a5,1
    80003bce:	04e7fa63          	bgeu	a5,a4,80003c22 <ialloc+0x74>
    80003bd2:	8aaa                	mv	s5,a0
    80003bd4:	8bae                	mv	s7,a1
    80003bd6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003bd8:	0001ca17          	auipc	s4,0x1c
    80003bdc:	728a0a13          	addi	s4,s4,1832 # 80020300 <sb>
    80003be0:	00048b1b          	sext.w	s6,s1
    80003be4:	0044d593          	srli	a1,s1,0x4
    80003be8:	018a2783          	lw	a5,24(s4)
    80003bec:	9dbd                	addw	a1,a1,a5
    80003bee:	8556                	mv	a0,s5
    80003bf0:	00000097          	auipc	ra,0x0
    80003bf4:	954080e7          	jalr	-1708(ra) # 80003544 <bread>
    80003bf8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003bfa:	06050993          	addi	s3,a0,96
    80003bfe:	00f4f793          	andi	a5,s1,15
    80003c02:	079a                	slli	a5,a5,0x6
    80003c04:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003c06:	00099783          	lh	a5,0(s3)
    80003c0a:	c785                	beqz	a5,80003c32 <ialloc+0x84>
    brelse(bp);
    80003c0c:	00000097          	auipc	ra,0x0
    80003c10:	a68080e7          	jalr	-1432(ra) # 80003674 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003c14:	0485                	addi	s1,s1,1
    80003c16:	00ca2703          	lw	a4,12(s4)
    80003c1a:	0004879b          	sext.w	a5,s1
    80003c1e:	fce7e1e3          	bltu	a5,a4,80003be0 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003c22:	00004517          	auipc	a0,0x4
    80003c26:	a9650513          	addi	a0,a0,-1386 # 800076b8 <userret+0x628>
    80003c2a:	ffffd097          	auipc	ra,0xffffd
    80003c2e:	924080e7          	jalr	-1756(ra) # 8000054e <panic>
      memset(dip, 0, sizeof(*dip));
    80003c32:	04000613          	li	a2,64
    80003c36:	4581                	li	a1,0
    80003c38:	854e                	mv	a0,s3
    80003c3a:	ffffd097          	auipc	ra,0xffffd
    80003c3e:	f34080e7          	jalr	-204(ra) # 80000b6e <memset>
      dip->type = type;
    80003c42:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003c46:	854a                	mv	a0,s2
    80003c48:	00001097          	auipc	ra,0x1
    80003c4c:	c6a080e7          	jalr	-918(ra) # 800048b2 <log_write>
      brelse(bp);
    80003c50:	854a                	mv	a0,s2
    80003c52:	00000097          	auipc	ra,0x0
    80003c56:	a22080e7          	jalr	-1502(ra) # 80003674 <brelse>
      return iget(dev, inum);
    80003c5a:	85da                	mv	a1,s6
    80003c5c:	8556                	mv	a0,s5
    80003c5e:	00000097          	auipc	ra,0x0
    80003c62:	db4080e7          	jalr	-588(ra) # 80003a12 <iget>
}
    80003c66:	60a6                	ld	ra,72(sp)
    80003c68:	6406                	ld	s0,64(sp)
    80003c6a:	74e2                	ld	s1,56(sp)
    80003c6c:	7942                	ld	s2,48(sp)
    80003c6e:	79a2                	ld	s3,40(sp)
    80003c70:	7a02                	ld	s4,32(sp)
    80003c72:	6ae2                	ld	s5,24(sp)
    80003c74:	6b42                	ld	s6,16(sp)
    80003c76:	6ba2                	ld	s7,8(sp)
    80003c78:	6161                	addi	sp,sp,80
    80003c7a:	8082                	ret

0000000080003c7c <iupdate>:
{
    80003c7c:	1101                	addi	sp,sp,-32
    80003c7e:	ec06                	sd	ra,24(sp)
    80003c80:	e822                	sd	s0,16(sp)
    80003c82:	e426                	sd	s1,8(sp)
    80003c84:	e04a                	sd	s2,0(sp)
    80003c86:	1000                	addi	s0,sp,32
    80003c88:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c8a:	415c                	lw	a5,4(a0)
    80003c8c:	0047d79b          	srliw	a5,a5,0x4
    80003c90:	0001c597          	auipc	a1,0x1c
    80003c94:	6885a583          	lw	a1,1672(a1) # 80020318 <sb+0x18>
    80003c98:	9dbd                	addw	a1,a1,a5
    80003c9a:	4108                	lw	a0,0(a0)
    80003c9c:	00000097          	auipc	ra,0x0
    80003ca0:	8a8080e7          	jalr	-1880(ra) # 80003544 <bread>
    80003ca4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003ca6:	06050793          	addi	a5,a0,96
    80003caa:	40c8                	lw	a0,4(s1)
    80003cac:	893d                	andi	a0,a0,15
    80003cae:	051a                	slli	a0,a0,0x6
    80003cb0:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003cb2:	04449703          	lh	a4,68(s1)
    80003cb6:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003cba:	04649703          	lh	a4,70(s1)
    80003cbe:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003cc2:	04849703          	lh	a4,72(s1)
    80003cc6:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003cca:	04a49703          	lh	a4,74(s1)
    80003cce:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003cd2:	44f8                	lw	a4,76(s1)
    80003cd4:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003cd6:	03400613          	li	a2,52
    80003cda:	05048593          	addi	a1,s1,80
    80003cde:	0531                	addi	a0,a0,12
    80003ce0:	ffffd097          	auipc	ra,0xffffd
    80003ce4:	eee080e7          	jalr	-274(ra) # 80000bce <memmove>
  log_write(bp);
    80003ce8:	854a                	mv	a0,s2
    80003cea:	00001097          	auipc	ra,0x1
    80003cee:	bc8080e7          	jalr	-1080(ra) # 800048b2 <log_write>
  brelse(bp);
    80003cf2:	854a                	mv	a0,s2
    80003cf4:	00000097          	auipc	ra,0x0
    80003cf8:	980080e7          	jalr	-1664(ra) # 80003674 <brelse>
}
    80003cfc:	60e2                	ld	ra,24(sp)
    80003cfe:	6442                	ld	s0,16(sp)
    80003d00:	64a2                	ld	s1,8(sp)
    80003d02:	6902                	ld	s2,0(sp)
    80003d04:	6105                	addi	sp,sp,32
    80003d06:	8082                	ret

0000000080003d08 <idup>:
{
    80003d08:	1101                	addi	sp,sp,-32
    80003d0a:	ec06                	sd	ra,24(sp)
    80003d0c:	e822                	sd	s0,16(sp)
    80003d0e:	e426                	sd	s1,8(sp)
    80003d10:	1000                	addi	s0,sp,32
    80003d12:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003d14:	0001c517          	auipc	a0,0x1c
    80003d18:	60c50513          	addi	a0,a0,1548 # 80020320 <icache>
    80003d1c:	ffffd097          	auipc	ra,0xffffd
    80003d20:	db6080e7          	jalr	-586(ra) # 80000ad2 <acquire>
  ip->ref++;
    80003d24:	449c                	lw	a5,8(s1)
    80003d26:	2785                	addiw	a5,a5,1
    80003d28:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003d2a:	0001c517          	auipc	a0,0x1c
    80003d2e:	5f650513          	addi	a0,a0,1526 # 80020320 <icache>
    80003d32:	ffffd097          	auipc	ra,0xffffd
    80003d36:	df4080e7          	jalr	-524(ra) # 80000b26 <release>
}
    80003d3a:	8526                	mv	a0,s1
    80003d3c:	60e2                	ld	ra,24(sp)
    80003d3e:	6442                	ld	s0,16(sp)
    80003d40:	64a2                	ld	s1,8(sp)
    80003d42:	6105                	addi	sp,sp,32
    80003d44:	8082                	ret

0000000080003d46 <ilock>:
{
    80003d46:	1101                	addi	sp,sp,-32
    80003d48:	ec06                	sd	ra,24(sp)
    80003d4a:	e822                	sd	s0,16(sp)
    80003d4c:	e426                	sd	s1,8(sp)
    80003d4e:	e04a                	sd	s2,0(sp)
    80003d50:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003d52:	c115                	beqz	a0,80003d76 <ilock+0x30>
    80003d54:	84aa                	mv	s1,a0
    80003d56:	451c                	lw	a5,8(a0)
    80003d58:	00f05f63          	blez	a5,80003d76 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003d5c:	0541                	addi	a0,a0,16
    80003d5e:	00001097          	auipc	ra,0x1
    80003d62:	c7c080e7          	jalr	-900(ra) # 800049da <acquiresleep>
  if(ip->valid == 0){
    80003d66:	40bc                	lw	a5,64(s1)
    80003d68:	cf99                	beqz	a5,80003d86 <ilock+0x40>
}
    80003d6a:	60e2                	ld	ra,24(sp)
    80003d6c:	6442                	ld	s0,16(sp)
    80003d6e:	64a2                	ld	s1,8(sp)
    80003d70:	6902                	ld	s2,0(sp)
    80003d72:	6105                	addi	sp,sp,32
    80003d74:	8082                	ret
    panic("ilock");
    80003d76:	00004517          	auipc	a0,0x4
    80003d7a:	95a50513          	addi	a0,a0,-1702 # 800076d0 <userret+0x640>
    80003d7e:	ffffc097          	auipc	ra,0xffffc
    80003d82:	7d0080e7          	jalr	2000(ra) # 8000054e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003d86:	40dc                	lw	a5,4(s1)
    80003d88:	0047d79b          	srliw	a5,a5,0x4
    80003d8c:	0001c597          	auipc	a1,0x1c
    80003d90:	58c5a583          	lw	a1,1420(a1) # 80020318 <sb+0x18>
    80003d94:	9dbd                	addw	a1,a1,a5
    80003d96:	4088                	lw	a0,0(s1)
    80003d98:	fffff097          	auipc	ra,0xfffff
    80003d9c:	7ac080e7          	jalr	1964(ra) # 80003544 <bread>
    80003da0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003da2:	06050593          	addi	a1,a0,96
    80003da6:	40dc                	lw	a5,4(s1)
    80003da8:	8bbd                	andi	a5,a5,15
    80003daa:	079a                	slli	a5,a5,0x6
    80003dac:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003dae:	00059783          	lh	a5,0(a1)
    80003db2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003db6:	00259783          	lh	a5,2(a1)
    80003dba:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003dbe:	00459783          	lh	a5,4(a1)
    80003dc2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003dc6:	00659783          	lh	a5,6(a1)
    80003dca:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003dce:	459c                	lw	a5,8(a1)
    80003dd0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003dd2:	03400613          	li	a2,52
    80003dd6:	05b1                	addi	a1,a1,12
    80003dd8:	05048513          	addi	a0,s1,80
    80003ddc:	ffffd097          	auipc	ra,0xffffd
    80003de0:	df2080e7          	jalr	-526(ra) # 80000bce <memmove>
    brelse(bp);
    80003de4:	854a                	mv	a0,s2
    80003de6:	00000097          	auipc	ra,0x0
    80003dea:	88e080e7          	jalr	-1906(ra) # 80003674 <brelse>
    ip->valid = 1;
    80003dee:	4785                	li	a5,1
    80003df0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003df2:	04449783          	lh	a5,68(s1)
    80003df6:	fbb5                	bnez	a5,80003d6a <ilock+0x24>
      panic("ilock: no type");
    80003df8:	00004517          	auipc	a0,0x4
    80003dfc:	8e050513          	addi	a0,a0,-1824 # 800076d8 <userret+0x648>
    80003e00:	ffffc097          	auipc	ra,0xffffc
    80003e04:	74e080e7          	jalr	1870(ra) # 8000054e <panic>

0000000080003e08 <iunlock>:
{
    80003e08:	1101                	addi	sp,sp,-32
    80003e0a:	ec06                	sd	ra,24(sp)
    80003e0c:	e822                	sd	s0,16(sp)
    80003e0e:	e426                	sd	s1,8(sp)
    80003e10:	e04a                	sd	s2,0(sp)
    80003e12:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003e14:	c905                	beqz	a0,80003e44 <iunlock+0x3c>
    80003e16:	84aa                	mv	s1,a0
    80003e18:	01050913          	addi	s2,a0,16
    80003e1c:	854a                	mv	a0,s2
    80003e1e:	00001097          	auipc	ra,0x1
    80003e22:	c56080e7          	jalr	-938(ra) # 80004a74 <holdingsleep>
    80003e26:	cd19                	beqz	a0,80003e44 <iunlock+0x3c>
    80003e28:	449c                	lw	a5,8(s1)
    80003e2a:	00f05d63          	blez	a5,80003e44 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003e2e:	854a                	mv	a0,s2
    80003e30:	00001097          	auipc	ra,0x1
    80003e34:	c00080e7          	jalr	-1024(ra) # 80004a30 <releasesleep>
}
    80003e38:	60e2                	ld	ra,24(sp)
    80003e3a:	6442                	ld	s0,16(sp)
    80003e3c:	64a2                	ld	s1,8(sp)
    80003e3e:	6902                	ld	s2,0(sp)
    80003e40:	6105                	addi	sp,sp,32
    80003e42:	8082                	ret
    panic("iunlock");
    80003e44:	00004517          	auipc	a0,0x4
    80003e48:	8a450513          	addi	a0,a0,-1884 # 800076e8 <userret+0x658>
    80003e4c:	ffffc097          	auipc	ra,0xffffc
    80003e50:	702080e7          	jalr	1794(ra) # 8000054e <panic>

0000000080003e54 <iput>:
{
    80003e54:	7139                	addi	sp,sp,-64
    80003e56:	fc06                	sd	ra,56(sp)
    80003e58:	f822                	sd	s0,48(sp)
    80003e5a:	f426                	sd	s1,40(sp)
    80003e5c:	f04a                	sd	s2,32(sp)
    80003e5e:	ec4e                	sd	s3,24(sp)
    80003e60:	e852                	sd	s4,16(sp)
    80003e62:	e456                	sd	s5,8(sp)
    80003e64:	0080                	addi	s0,sp,64
    80003e66:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003e68:	0001c517          	auipc	a0,0x1c
    80003e6c:	4b850513          	addi	a0,a0,1208 # 80020320 <icache>
    80003e70:	ffffd097          	auipc	ra,0xffffd
    80003e74:	c62080e7          	jalr	-926(ra) # 80000ad2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e78:	4498                	lw	a4,8(s1)
    80003e7a:	4785                	li	a5,1
    80003e7c:	02f70663          	beq	a4,a5,80003ea8 <iput+0x54>
  ip->ref--;
    80003e80:	449c                	lw	a5,8(s1)
    80003e82:	37fd                	addiw	a5,a5,-1
    80003e84:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003e86:	0001c517          	auipc	a0,0x1c
    80003e8a:	49a50513          	addi	a0,a0,1178 # 80020320 <icache>
    80003e8e:	ffffd097          	auipc	ra,0xffffd
    80003e92:	c98080e7          	jalr	-872(ra) # 80000b26 <release>
}
    80003e96:	70e2                	ld	ra,56(sp)
    80003e98:	7442                	ld	s0,48(sp)
    80003e9a:	74a2                	ld	s1,40(sp)
    80003e9c:	7902                	ld	s2,32(sp)
    80003e9e:	69e2                	ld	s3,24(sp)
    80003ea0:	6a42                	ld	s4,16(sp)
    80003ea2:	6aa2                	ld	s5,8(sp)
    80003ea4:	6121                	addi	sp,sp,64
    80003ea6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ea8:	40bc                	lw	a5,64(s1)
    80003eaa:	dbf9                	beqz	a5,80003e80 <iput+0x2c>
    80003eac:	04a49783          	lh	a5,74(s1)
    80003eb0:	fbe1                	bnez	a5,80003e80 <iput+0x2c>
    acquiresleep(&ip->lock);
    80003eb2:	01048a13          	addi	s4,s1,16
    80003eb6:	8552                	mv	a0,s4
    80003eb8:	00001097          	auipc	ra,0x1
    80003ebc:	b22080e7          	jalr	-1246(ra) # 800049da <acquiresleep>
    release(&icache.lock);
    80003ec0:	0001c517          	auipc	a0,0x1c
    80003ec4:	46050513          	addi	a0,a0,1120 # 80020320 <icache>
    80003ec8:	ffffd097          	auipc	ra,0xffffd
    80003ecc:	c5e080e7          	jalr	-930(ra) # 80000b26 <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003ed0:	05048913          	addi	s2,s1,80
    80003ed4:	08048993          	addi	s3,s1,128
    80003ed8:	a819                	j	80003eee <iput+0x9a>
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
    80003eda:	4088                	lw	a0,0(s1)
    80003edc:	00000097          	auipc	ra,0x0
    80003ee0:	8ae080e7          	jalr	-1874(ra) # 8000378a <bfree>
      ip->addrs[i] = 0;
    80003ee4:	00092023          	sw	zero,0(s2)
  for(i = 0; i < NDIRECT; i++){
    80003ee8:	0911                	addi	s2,s2,4
    80003eea:	01390663          	beq	s2,s3,80003ef6 <iput+0xa2>
    if(ip->addrs[i]){
    80003eee:	00092583          	lw	a1,0(s2)
    80003ef2:	d9fd                	beqz	a1,80003ee8 <iput+0x94>
    80003ef4:	b7dd                	j	80003eda <iput+0x86>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003ef6:	0804a583          	lw	a1,128(s1)
    80003efa:	ed9d                	bnez	a1,80003f38 <iput+0xe4>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003efc:	0404a623          	sw	zero,76(s1)
  iupdate(ip);
    80003f00:	8526                	mv	a0,s1
    80003f02:	00000097          	auipc	ra,0x0
    80003f06:	d7a080e7          	jalr	-646(ra) # 80003c7c <iupdate>
    ip->type = 0;
    80003f0a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003f0e:	8526                	mv	a0,s1
    80003f10:	00000097          	auipc	ra,0x0
    80003f14:	d6c080e7          	jalr	-660(ra) # 80003c7c <iupdate>
    ip->valid = 0;
    80003f18:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003f1c:	8552                	mv	a0,s4
    80003f1e:	00001097          	auipc	ra,0x1
    80003f22:	b12080e7          	jalr	-1262(ra) # 80004a30 <releasesleep>
    acquire(&icache.lock);
    80003f26:	0001c517          	auipc	a0,0x1c
    80003f2a:	3fa50513          	addi	a0,a0,1018 # 80020320 <icache>
    80003f2e:	ffffd097          	auipc	ra,0xffffd
    80003f32:	ba4080e7          	jalr	-1116(ra) # 80000ad2 <acquire>
    80003f36:	b7a9                	j	80003e80 <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003f38:	4088                	lw	a0,0(s1)
    80003f3a:	fffff097          	auipc	ra,0xfffff
    80003f3e:	60a080e7          	jalr	1546(ra) # 80003544 <bread>
    80003f42:	8aaa                	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
    80003f44:	06050913          	addi	s2,a0,96
    80003f48:	46050993          	addi	s3,a0,1120
    80003f4c:	a809                	j	80003f5e <iput+0x10a>
        bfree(ip->dev, a[j]);
    80003f4e:	4088                	lw	a0,0(s1)
    80003f50:	00000097          	auipc	ra,0x0
    80003f54:	83a080e7          	jalr	-1990(ra) # 8000378a <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80003f58:	0911                	addi	s2,s2,4
    80003f5a:	01390663          	beq	s2,s3,80003f66 <iput+0x112>
      if(a[j])
    80003f5e:	00092583          	lw	a1,0(s2)
    80003f62:	d9fd                	beqz	a1,80003f58 <iput+0x104>
    80003f64:	b7ed                	j	80003f4e <iput+0xfa>
    brelse(bp);
    80003f66:	8556                	mv	a0,s5
    80003f68:	fffff097          	auipc	ra,0xfffff
    80003f6c:	70c080e7          	jalr	1804(ra) # 80003674 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003f70:	0804a583          	lw	a1,128(s1)
    80003f74:	4088                	lw	a0,0(s1)
    80003f76:	00000097          	auipc	ra,0x0
    80003f7a:	814080e7          	jalr	-2028(ra) # 8000378a <bfree>
    ip->addrs[NDIRECT] = 0;
    80003f7e:	0804a023          	sw	zero,128(s1)
    80003f82:	bfad                	j	80003efc <iput+0xa8>

0000000080003f84 <iunlockput>:
{
    80003f84:	1101                	addi	sp,sp,-32
    80003f86:	ec06                	sd	ra,24(sp)
    80003f88:	e822                	sd	s0,16(sp)
    80003f8a:	e426                	sd	s1,8(sp)
    80003f8c:	1000                	addi	s0,sp,32
    80003f8e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003f90:	00000097          	auipc	ra,0x0
    80003f94:	e78080e7          	jalr	-392(ra) # 80003e08 <iunlock>
  iput(ip);
    80003f98:	8526                	mv	a0,s1
    80003f9a:	00000097          	auipc	ra,0x0
    80003f9e:	eba080e7          	jalr	-326(ra) # 80003e54 <iput>
}
    80003fa2:	60e2                	ld	ra,24(sp)
    80003fa4:	6442                	ld	s0,16(sp)
    80003fa6:	64a2                	ld	s1,8(sp)
    80003fa8:	6105                	addi	sp,sp,32
    80003faa:	8082                	ret

0000000080003fac <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003fac:	1141                	addi	sp,sp,-16
    80003fae:	e422                	sd	s0,8(sp)
    80003fb0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003fb2:	411c                	lw	a5,0(a0)
    80003fb4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003fb6:	415c                	lw	a5,4(a0)
    80003fb8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003fba:	04451783          	lh	a5,68(a0)
    80003fbe:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003fc2:	04a51783          	lh	a5,74(a0)
    80003fc6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003fca:	04c56783          	lwu	a5,76(a0)
    80003fce:	e99c                	sd	a5,16(a1)
}
    80003fd0:	6422                	ld	s0,8(sp)
    80003fd2:	0141                	addi	sp,sp,16
    80003fd4:	8082                	ret

0000000080003fd6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003fd6:	457c                	lw	a5,76(a0)
    80003fd8:	0ed7e563          	bltu	a5,a3,800040c2 <readi+0xec>
{
    80003fdc:	7159                	addi	sp,sp,-112
    80003fde:	f486                	sd	ra,104(sp)
    80003fe0:	f0a2                	sd	s0,96(sp)
    80003fe2:	eca6                	sd	s1,88(sp)
    80003fe4:	e8ca                	sd	s2,80(sp)
    80003fe6:	e4ce                	sd	s3,72(sp)
    80003fe8:	e0d2                	sd	s4,64(sp)
    80003fea:	fc56                	sd	s5,56(sp)
    80003fec:	f85a                	sd	s6,48(sp)
    80003fee:	f45e                	sd	s7,40(sp)
    80003ff0:	f062                	sd	s8,32(sp)
    80003ff2:	ec66                	sd	s9,24(sp)
    80003ff4:	e86a                	sd	s10,16(sp)
    80003ff6:	e46e                	sd	s11,8(sp)
    80003ff8:	1880                	addi	s0,sp,112
    80003ffa:	8baa                	mv	s7,a0
    80003ffc:	8c2e                	mv	s8,a1
    80003ffe:	8ab2                	mv	s5,a2
    80004000:	8936                	mv	s2,a3
    80004002:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004004:	9f35                	addw	a4,a4,a3
    80004006:	0cd76063          	bltu	a4,a3,800040c6 <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    8000400a:	00e7f463          	bgeu	a5,a4,80004012 <readi+0x3c>
    n = ip->size - off; //only can read till the end of the file
    8000400e:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004012:	080b0763          	beqz	s6,800040a0 <readi+0xca>
    80004016:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80004018:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000401c:	5cfd                	li	s9,-1
    8000401e:	a82d                	j	80004058 <readi+0x82>
    80004020:	02099d93          	slli	s11,s3,0x20
    80004024:	020ddd93          	srli	s11,s11,0x20
    80004028:	06048613          	addi	a2,s1,96
    8000402c:	86ee                	mv	a3,s11
    8000402e:	963a                	add	a2,a2,a4
    80004030:	85d6                	mv	a1,s5
    80004032:	8562                	mv	a0,s8
    80004034:	fffff097          	auipc	ra,0xfffff
    80004038:	ada080e7          	jalr	-1318(ra) # 80002b0e <either_copyout>
    8000403c:	05950d63          	beq	a0,s9,80004096 <readi+0xc0>
      brelse(bp);
      break;
    }
    brelse(bp);
    80004040:	8526                	mv	a0,s1
    80004042:	fffff097          	auipc	ra,0xfffff
    80004046:	632080e7          	jalr	1586(ra) # 80003674 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000404a:	01498a3b          	addw	s4,s3,s4
    8000404e:	0129893b          	addw	s2,s3,s2
    80004052:	9aee                	add	s5,s5,s11
    80004054:	056a7663          	bgeu	s4,s6,800040a0 <readi+0xca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004058:	000ba483          	lw	s1,0(s7)
    8000405c:	00a9559b          	srliw	a1,s2,0xa
    80004060:	855e                	mv	a0,s7
    80004062:	00000097          	auipc	ra,0x0
    80004066:	8d6080e7          	jalr	-1834(ra) # 80003938 <bmap>
    8000406a:	0005059b          	sext.w	a1,a0
    8000406e:	8526                	mv	a0,s1
    80004070:	fffff097          	auipc	ra,0xfffff
    80004074:	4d4080e7          	jalr	1236(ra) # 80003544 <bread>
    80004078:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000407a:	3ff97713          	andi	a4,s2,1023
    8000407e:	40ed07bb          	subw	a5,s10,a4
    80004082:	414b06bb          	subw	a3,s6,s4
    80004086:	89be                	mv	s3,a5
    80004088:	2781                	sext.w	a5,a5
    8000408a:	0006861b          	sext.w	a2,a3
    8000408e:	f8f679e3          	bgeu	a2,a5,80004020 <readi+0x4a>
    80004092:	89b6                	mv	s3,a3
    80004094:	b771                	j	80004020 <readi+0x4a>
      brelse(bp);
    80004096:	8526                	mv	a0,s1
    80004098:	fffff097          	auipc	ra,0xfffff
    8000409c:	5dc080e7          	jalr	1500(ra) # 80003674 <brelse>
  }
  return n;
    800040a0:	000b051b          	sext.w	a0,s6
}
    800040a4:	70a6                	ld	ra,104(sp)
    800040a6:	7406                	ld	s0,96(sp)
    800040a8:	64e6                	ld	s1,88(sp)
    800040aa:	6946                	ld	s2,80(sp)
    800040ac:	69a6                	ld	s3,72(sp)
    800040ae:	6a06                	ld	s4,64(sp)
    800040b0:	7ae2                	ld	s5,56(sp)
    800040b2:	7b42                	ld	s6,48(sp)
    800040b4:	7ba2                	ld	s7,40(sp)
    800040b6:	7c02                	ld	s8,32(sp)
    800040b8:	6ce2                	ld	s9,24(sp)
    800040ba:	6d42                	ld	s10,16(sp)
    800040bc:	6da2                	ld	s11,8(sp)
    800040be:	6165                	addi	sp,sp,112
    800040c0:	8082                	ret
    return -1;
    800040c2:	557d                	li	a0,-1
}
    800040c4:	8082                	ret
    return -1;
    800040c6:	557d                	li	a0,-1
    800040c8:	bff1                	j	800040a4 <readi+0xce>

00000000800040ca <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800040ca:	457c                	lw	a5,76(a0)
    800040cc:	10d7e663          	bltu	a5,a3,800041d8 <writei+0x10e>
{
    800040d0:	7159                	addi	sp,sp,-112
    800040d2:	f486                	sd	ra,104(sp)
    800040d4:	f0a2                	sd	s0,96(sp)
    800040d6:	eca6                	sd	s1,88(sp)
    800040d8:	e8ca                	sd	s2,80(sp)
    800040da:	e4ce                	sd	s3,72(sp)
    800040dc:	e0d2                	sd	s4,64(sp)
    800040de:	fc56                	sd	s5,56(sp)
    800040e0:	f85a                	sd	s6,48(sp)
    800040e2:	f45e                	sd	s7,40(sp)
    800040e4:	f062                	sd	s8,32(sp)
    800040e6:	ec66                	sd	s9,24(sp)
    800040e8:	e86a                	sd	s10,16(sp)
    800040ea:	e46e                	sd	s11,8(sp)
    800040ec:	1880                	addi	s0,sp,112
    800040ee:	8baa                	mv	s7,a0
    800040f0:	8c2e                	mv	s8,a1
    800040f2:	8ab2                	mv	s5,a2
    800040f4:	8936                	mv	s2,a3
    800040f6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800040f8:	00e687bb          	addw	a5,a3,a4
    800040fc:	0ed7e063          	bltu	a5,a3,800041dc <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004100:	00043737          	lui	a4,0x43
    80004104:	0cf76e63          	bltu	a4,a5,800041e0 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004108:	0a0b0763          	beqz	s6,800041b6 <writei+0xec>
    8000410c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000410e:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004112:	5cfd                	li	s9,-1
    80004114:	a091                	j	80004158 <writei+0x8e>
    80004116:	02099d93          	slli	s11,s3,0x20
    8000411a:	020ddd93          	srli	s11,s11,0x20
    8000411e:	06048513          	addi	a0,s1,96
    80004122:	86ee                	mv	a3,s11
    80004124:	8656                	mv	a2,s5
    80004126:	85e2                	mv	a1,s8
    80004128:	953a                	add	a0,a0,a4
    8000412a:	fffff097          	auipc	ra,0xfffff
    8000412e:	a3a080e7          	jalr	-1478(ra) # 80002b64 <either_copyin>
    80004132:	07950263          	beq	a0,s9,80004196 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004136:	8526                	mv	a0,s1
    80004138:	00000097          	auipc	ra,0x0
    8000413c:	77a080e7          	jalr	1914(ra) # 800048b2 <log_write>
    brelse(bp);
    80004140:	8526                	mv	a0,s1
    80004142:	fffff097          	auipc	ra,0xfffff
    80004146:	532080e7          	jalr	1330(ra) # 80003674 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000414a:	01498a3b          	addw	s4,s3,s4
    8000414e:	0129893b          	addw	s2,s3,s2
    80004152:	9aee                	add	s5,s5,s11
    80004154:	056a7663          	bgeu	s4,s6,800041a0 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004158:	000ba483          	lw	s1,0(s7)
    8000415c:	00a9559b          	srliw	a1,s2,0xa
    80004160:	855e                	mv	a0,s7
    80004162:	fffff097          	auipc	ra,0xfffff
    80004166:	7d6080e7          	jalr	2006(ra) # 80003938 <bmap>
    8000416a:	0005059b          	sext.w	a1,a0
    8000416e:	8526                	mv	a0,s1
    80004170:	fffff097          	auipc	ra,0xfffff
    80004174:	3d4080e7          	jalr	980(ra) # 80003544 <bread>
    80004178:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000417a:	3ff97713          	andi	a4,s2,1023
    8000417e:	40ed07bb          	subw	a5,s10,a4
    80004182:	414b06bb          	subw	a3,s6,s4
    80004186:	89be                	mv	s3,a5
    80004188:	2781                	sext.w	a5,a5
    8000418a:	0006861b          	sext.w	a2,a3
    8000418e:	f8f674e3          	bgeu	a2,a5,80004116 <writei+0x4c>
    80004192:	89b6                	mv	s3,a3
    80004194:	b749                	j	80004116 <writei+0x4c>
      brelse(bp);
    80004196:	8526                	mv	a0,s1
    80004198:	fffff097          	auipc	ra,0xfffff
    8000419c:	4dc080e7          	jalr	1244(ra) # 80003674 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    800041a0:	04cba783          	lw	a5,76(s7)
    800041a4:	0127f463          	bgeu	a5,s2,800041ac <writei+0xe2>
      ip->size = off;
    800041a8:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    800041ac:	855e                	mv	a0,s7
    800041ae:	00000097          	auipc	ra,0x0
    800041b2:	ace080e7          	jalr	-1330(ra) # 80003c7c <iupdate>
  }

  return n;
    800041b6:	000b051b          	sext.w	a0,s6
}
    800041ba:	70a6                	ld	ra,104(sp)
    800041bc:	7406                	ld	s0,96(sp)
    800041be:	64e6                	ld	s1,88(sp)
    800041c0:	6946                	ld	s2,80(sp)
    800041c2:	69a6                	ld	s3,72(sp)
    800041c4:	6a06                	ld	s4,64(sp)
    800041c6:	7ae2                	ld	s5,56(sp)
    800041c8:	7b42                	ld	s6,48(sp)
    800041ca:	7ba2                	ld	s7,40(sp)
    800041cc:	7c02                	ld	s8,32(sp)
    800041ce:	6ce2                	ld	s9,24(sp)
    800041d0:	6d42                	ld	s10,16(sp)
    800041d2:	6da2                	ld	s11,8(sp)
    800041d4:	6165                	addi	sp,sp,112
    800041d6:	8082                	ret
    return -1;
    800041d8:	557d                	li	a0,-1
}
    800041da:	8082                	ret
    return -1;
    800041dc:	557d                	li	a0,-1
    800041de:	bff1                	j	800041ba <writei+0xf0>
    return -1;
    800041e0:	557d                	li	a0,-1
    800041e2:	bfe1                	j	800041ba <writei+0xf0>

00000000800041e4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800041e4:	1141                	addi	sp,sp,-16
    800041e6:	e406                	sd	ra,8(sp)
    800041e8:	e022                	sd	s0,0(sp)
    800041ea:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800041ec:	4639                	li	a2,14
    800041ee:	ffffd097          	auipc	ra,0xffffd
    800041f2:	a5c080e7          	jalr	-1444(ra) # 80000c4a <strncmp>
}
    800041f6:	60a2                	ld	ra,8(sp)
    800041f8:	6402                	ld	s0,0(sp)
    800041fa:	0141                	addi	sp,sp,16
    800041fc:	8082                	ret

00000000800041fe <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800041fe:	7139                	addi	sp,sp,-64
    80004200:	fc06                	sd	ra,56(sp)
    80004202:	f822                	sd	s0,48(sp)
    80004204:	f426                	sd	s1,40(sp)
    80004206:	f04a                	sd	s2,32(sp)
    80004208:	ec4e                	sd	s3,24(sp)
    8000420a:	e852                	sd	s4,16(sp)
    8000420c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000420e:	04451703          	lh	a4,68(a0)
    80004212:	4785                	li	a5,1
    80004214:	00f71a63          	bne	a4,a5,80004228 <dirlookup+0x2a>
    80004218:	892a                	mv	s2,a0
    8000421a:	89ae                	mv	s3,a1
    8000421c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000421e:	457c                	lw	a5,76(a0)
    80004220:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004222:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004224:	e79d                	bnez	a5,80004252 <dirlookup+0x54>
    80004226:	a8a5                	j	8000429e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004228:	00003517          	auipc	a0,0x3
    8000422c:	4c850513          	addi	a0,a0,1224 # 800076f0 <userret+0x660>
    80004230:	ffffc097          	auipc	ra,0xffffc
    80004234:	31e080e7          	jalr	798(ra) # 8000054e <panic>
      panic("dirlookup read");
    80004238:	00003517          	auipc	a0,0x3
    8000423c:	4d050513          	addi	a0,a0,1232 # 80007708 <userret+0x678>
    80004240:	ffffc097          	auipc	ra,0xffffc
    80004244:	30e080e7          	jalr	782(ra) # 8000054e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004248:	24c1                	addiw	s1,s1,16
    8000424a:	04c92783          	lw	a5,76(s2)
    8000424e:	04f4f763          	bgeu	s1,a5,8000429c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004252:	4741                	li	a4,16
    80004254:	86a6                	mv	a3,s1
    80004256:	fc040613          	addi	a2,s0,-64
    8000425a:	4581                	li	a1,0
    8000425c:	854a                	mv	a0,s2
    8000425e:	00000097          	auipc	ra,0x0
    80004262:	d78080e7          	jalr	-648(ra) # 80003fd6 <readi>
    80004266:	47c1                	li	a5,16
    80004268:	fcf518e3          	bne	a0,a5,80004238 <dirlookup+0x3a>
    if(de.inum == 0)
    8000426c:	fc045783          	lhu	a5,-64(s0)
    80004270:	dfe1                	beqz	a5,80004248 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004272:	fc240593          	addi	a1,s0,-62
    80004276:	854e                	mv	a0,s3
    80004278:	00000097          	auipc	ra,0x0
    8000427c:	f6c080e7          	jalr	-148(ra) # 800041e4 <namecmp>
    80004280:	f561                	bnez	a0,80004248 <dirlookup+0x4a>
      if(poff)
    80004282:	000a0463          	beqz	s4,8000428a <dirlookup+0x8c>
        *poff = off;
    80004286:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000428a:	fc045583          	lhu	a1,-64(s0)
    8000428e:	00092503          	lw	a0,0(s2)
    80004292:	fffff097          	auipc	ra,0xfffff
    80004296:	780080e7          	jalr	1920(ra) # 80003a12 <iget>
    8000429a:	a011                	j	8000429e <dirlookup+0xa0>
  return 0;
    8000429c:	4501                	li	a0,0
}
    8000429e:	70e2                	ld	ra,56(sp)
    800042a0:	7442                	ld	s0,48(sp)
    800042a2:	74a2                	ld	s1,40(sp)
    800042a4:	7902                	ld	s2,32(sp)
    800042a6:	69e2                	ld	s3,24(sp)
    800042a8:	6a42                	ld	s4,16(sp)
    800042aa:	6121                	addi	sp,sp,64
    800042ac:	8082                	ret

00000000800042ae <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800042ae:	711d                	addi	sp,sp,-96
    800042b0:	ec86                	sd	ra,88(sp)
    800042b2:	e8a2                	sd	s0,80(sp)
    800042b4:	e4a6                	sd	s1,72(sp)
    800042b6:	e0ca                	sd	s2,64(sp)
    800042b8:	fc4e                	sd	s3,56(sp)
    800042ba:	f852                	sd	s4,48(sp)
    800042bc:	f456                	sd	s5,40(sp)
    800042be:	f05a                	sd	s6,32(sp)
    800042c0:	ec5e                	sd	s7,24(sp)
    800042c2:	e862                	sd	s8,16(sp)
    800042c4:	e466                	sd	s9,8(sp)
    800042c6:	1080                	addi	s0,sp,96
    800042c8:	84aa                	mv	s1,a0
    800042ca:	8b2e                	mv	s6,a1
    800042cc:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800042ce:	00054703          	lbu	a4,0(a0)
    800042d2:	02f00793          	li	a5,47
    800042d6:	02f70363          	beq	a4,a5,800042fc <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800042da:	ffffe097          	auipc	ra,0xffffe
    800042de:	828080e7          	jalr	-2008(ra) # 80001b02 <myproc>
    800042e2:	16053503          	ld	a0,352(a0)
    800042e6:	00000097          	auipc	ra,0x0
    800042ea:	a22080e7          	jalr	-1502(ra) # 80003d08 <idup>
    800042ee:	89aa                	mv	s3,a0
  while(*path == '/')
    800042f0:	02f00913          	li	s2,47
  len = path - s;
    800042f4:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800042f6:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800042f8:	4c05                	li	s8,1
    800042fa:	a865                	j	800043b2 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800042fc:	4585                	li	a1,1
    800042fe:	4505                	li	a0,1
    80004300:	fffff097          	auipc	ra,0xfffff
    80004304:	712080e7          	jalr	1810(ra) # 80003a12 <iget>
    80004308:	89aa                	mv	s3,a0
    8000430a:	b7dd                	j	800042f0 <namex+0x42>
      iunlockput(ip);
    8000430c:	854e                	mv	a0,s3
    8000430e:	00000097          	auipc	ra,0x0
    80004312:	c76080e7          	jalr	-906(ra) # 80003f84 <iunlockput>
      return 0;
    80004316:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004318:	854e                	mv	a0,s3
    8000431a:	60e6                	ld	ra,88(sp)
    8000431c:	6446                	ld	s0,80(sp)
    8000431e:	64a6                	ld	s1,72(sp)
    80004320:	6906                	ld	s2,64(sp)
    80004322:	79e2                	ld	s3,56(sp)
    80004324:	7a42                	ld	s4,48(sp)
    80004326:	7aa2                	ld	s5,40(sp)
    80004328:	7b02                	ld	s6,32(sp)
    8000432a:	6be2                	ld	s7,24(sp)
    8000432c:	6c42                	ld	s8,16(sp)
    8000432e:	6ca2                	ld	s9,8(sp)
    80004330:	6125                	addi	sp,sp,96
    80004332:	8082                	ret
      iunlock(ip);
    80004334:	854e                	mv	a0,s3
    80004336:	00000097          	auipc	ra,0x0
    8000433a:	ad2080e7          	jalr	-1326(ra) # 80003e08 <iunlock>
      return ip;
    8000433e:	bfe9                	j	80004318 <namex+0x6a>
      iunlockput(ip);
    80004340:	854e                	mv	a0,s3
    80004342:	00000097          	auipc	ra,0x0
    80004346:	c42080e7          	jalr	-958(ra) # 80003f84 <iunlockput>
      return 0;
    8000434a:	89d2                	mv	s3,s4
    8000434c:	b7f1                	j	80004318 <namex+0x6a>
  len = path - s;
    8000434e:	40b48633          	sub	a2,s1,a1
    80004352:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80004356:	094cd463          	bge	s9,s4,800043de <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000435a:	4639                	li	a2,14
    8000435c:	8556                	mv	a0,s5
    8000435e:	ffffd097          	auipc	ra,0xffffd
    80004362:	870080e7          	jalr	-1936(ra) # 80000bce <memmove>
  while(*path == '/')
    80004366:	0004c783          	lbu	a5,0(s1)
    8000436a:	01279763          	bne	a5,s2,80004378 <namex+0xca>
    path++;
    8000436e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004370:	0004c783          	lbu	a5,0(s1)
    80004374:	ff278de3          	beq	a5,s2,8000436e <namex+0xc0>
    ilock(ip);
    80004378:	854e                	mv	a0,s3
    8000437a:	00000097          	auipc	ra,0x0
    8000437e:	9cc080e7          	jalr	-1588(ra) # 80003d46 <ilock>
    if(ip->type != T_DIR){
    80004382:	04499783          	lh	a5,68(s3)
    80004386:	f98793e3          	bne	a5,s8,8000430c <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000438a:	000b0563          	beqz	s6,80004394 <namex+0xe6>
    8000438e:	0004c783          	lbu	a5,0(s1)
    80004392:	d3cd                	beqz	a5,80004334 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004394:	865e                	mv	a2,s7
    80004396:	85d6                	mv	a1,s5
    80004398:	854e                	mv	a0,s3
    8000439a:	00000097          	auipc	ra,0x0
    8000439e:	e64080e7          	jalr	-412(ra) # 800041fe <dirlookup>
    800043a2:	8a2a                	mv	s4,a0
    800043a4:	dd51                	beqz	a0,80004340 <namex+0x92>
    iunlockput(ip);
    800043a6:	854e                	mv	a0,s3
    800043a8:	00000097          	auipc	ra,0x0
    800043ac:	bdc080e7          	jalr	-1060(ra) # 80003f84 <iunlockput>
    ip = next;
    800043b0:	89d2                	mv	s3,s4
  while(*path == '/')
    800043b2:	0004c783          	lbu	a5,0(s1)
    800043b6:	05279763          	bne	a5,s2,80004404 <namex+0x156>
    path++;
    800043ba:	0485                	addi	s1,s1,1
  while(*path == '/')
    800043bc:	0004c783          	lbu	a5,0(s1)
    800043c0:	ff278de3          	beq	a5,s2,800043ba <namex+0x10c>
  if(*path == 0)
    800043c4:	c79d                	beqz	a5,800043f2 <namex+0x144>
    path++;
    800043c6:	85a6                	mv	a1,s1
  len = path - s;
    800043c8:	8a5e                	mv	s4,s7
    800043ca:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800043cc:	01278963          	beq	a5,s2,800043de <namex+0x130>
    800043d0:	dfbd                	beqz	a5,8000434e <namex+0xa0>
    path++;
    800043d2:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800043d4:	0004c783          	lbu	a5,0(s1)
    800043d8:	ff279ce3          	bne	a5,s2,800043d0 <namex+0x122>
    800043dc:	bf8d                	j	8000434e <namex+0xa0>
    memmove(name, s, len);
    800043de:	2601                	sext.w	a2,a2
    800043e0:	8556                	mv	a0,s5
    800043e2:	ffffc097          	auipc	ra,0xffffc
    800043e6:	7ec080e7          	jalr	2028(ra) # 80000bce <memmove>
    name[len] = 0;
    800043ea:	9a56                	add	s4,s4,s5
    800043ec:	000a0023          	sb	zero,0(s4)
    800043f0:	bf9d                	j	80004366 <namex+0xb8>
  if(nameiparent){
    800043f2:	f20b03e3          	beqz	s6,80004318 <namex+0x6a>
    iput(ip);
    800043f6:	854e                	mv	a0,s3
    800043f8:	00000097          	auipc	ra,0x0
    800043fc:	a5c080e7          	jalr	-1444(ra) # 80003e54 <iput>
    return 0;
    80004400:	4981                	li	s3,0
    80004402:	bf19                	j	80004318 <namex+0x6a>
  if(*path == 0)
    80004404:	d7fd                	beqz	a5,800043f2 <namex+0x144>
  while(*path != '/' && *path != 0)
    80004406:	0004c783          	lbu	a5,0(s1)
    8000440a:	85a6                	mv	a1,s1
    8000440c:	b7d1                	j	800043d0 <namex+0x122>

000000008000440e <dirlink>:
{
    8000440e:	7139                	addi	sp,sp,-64
    80004410:	fc06                	sd	ra,56(sp)
    80004412:	f822                	sd	s0,48(sp)
    80004414:	f426                	sd	s1,40(sp)
    80004416:	f04a                	sd	s2,32(sp)
    80004418:	ec4e                	sd	s3,24(sp)
    8000441a:	e852                	sd	s4,16(sp)
    8000441c:	0080                	addi	s0,sp,64
    8000441e:	892a                	mv	s2,a0
    80004420:	8a2e                	mv	s4,a1
    80004422:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004424:	4601                	li	a2,0
    80004426:	00000097          	auipc	ra,0x0
    8000442a:	dd8080e7          	jalr	-552(ra) # 800041fe <dirlookup>
    8000442e:	e93d                	bnez	a0,800044a4 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004430:	04c92483          	lw	s1,76(s2)
    80004434:	c49d                	beqz	s1,80004462 <dirlink+0x54>
    80004436:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004438:	4741                	li	a4,16
    8000443a:	86a6                	mv	a3,s1
    8000443c:	fc040613          	addi	a2,s0,-64
    80004440:	4581                	li	a1,0
    80004442:	854a                	mv	a0,s2
    80004444:	00000097          	auipc	ra,0x0
    80004448:	b92080e7          	jalr	-1134(ra) # 80003fd6 <readi>
    8000444c:	47c1                	li	a5,16
    8000444e:	06f51163          	bne	a0,a5,800044b0 <dirlink+0xa2>
    if(de.inum == 0)
    80004452:	fc045783          	lhu	a5,-64(s0)
    80004456:	c791                	beqz	a5,80004462 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004458:	24c1                	addiw	s1,s1,16
    8000445a:	04c92783          	lw	a5,76(s2)
    8000445e:	fcf4ede3          	bltu	s1,a5,80004438 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004462:	4639                	li	a2,14
    80004464:	85d2                	mv	a1,s4
    80004466:	fc240513          	addi	a0,s0,-62
    8000446a:	ffffd097          	auipc	ra,0xffffd
    8000446e:	81c080e7          	jalr	-2020(ra) # 80000c86 <strncpy>
  de.inum = inum;
    80004472:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004476:	4741                	li	a4,16
    80004478:	86a6                	mv	a3,s1
    8000447a:	fc040613          	addi	a2,s0,-64
    8000447e:	4581                	li	a1,0
    80004480:	854a                	mv	a0,s2
    80004482:	00000097          	auipc	ra,0x0
    80004486:	c48080e7          	jalr	-952(ra) # 800040ca <writei>
    8000448a:	872a                	mv	a4,a0
    8000448c:	47c1                	li	a5,16
  return 0;
    8000448e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004490:	02f71863          	bne	a4,a5,800044c0 <dirlink+0xb2>
}
    80004494:	70e2                	ld	ra,56(sp)
    80004496:	7442                	ld	s0,48(sp)
    80004498:	74a2                	ld	s1,40(sp)
    8000449a:	7902                	ld	s2,32(sp)
    8000449c:	69e2                	ld	s3,24(sp)
    8000449e:	6a42                	ld	s4,16(sp)
    800044a0:	6121                	addi	sp,sp,64
    800044a2:	8082                	ret
    iput(ip);
    800044a4:	00000097          	auipc	ra,0x0
    800044a8:	9b0080e7          	jalr	-1616(ra) # 80003e54 <iput>
    return -1;
    800044ac:	557d                	li	a0,-1
    800044ae:	b7dd                	j	80004494 <dirlink+0x86>
      panic("dirlink read");
    800044b0:	00003517          	auipc	a0,0x3
    800044b4:	26850513          	addi	a0,a0,616 # 80007718 <userret+0x688>
    800044b8:	ffffc097          	auipc	ra,0xffffc
    800044bc:	096080e7          	jalr	150(ra) # 8000054e <panic>
    panic("dirlink");
    800044c0:	00003517          	auipc	a0,0x3
    800044c4:	37850513          	addi	a0,a0,888 # 80007838 <userret+0x7a8>
    800044c8:	ffffc097          	auipc	ra,0xffffc
    800044cc:	086080e7          	jalr	134(ra) # 8000054e <panic>

00000000800044d0 <namei>:

struct inode*
namei(char *path)
{
    800044d0:	1101                	addi	sp,sp,-32
    800044d2:	ec06                	sd	ra,24(sp)
    800044d4:	e822                	sd	s0,16(sp)
    800044d6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800044d8:	fe040613          	addi	a2,s0,-32
    800044dc:	4581                	li	a1,0
    800044de:	00000097          	auipc	ra,0x0
    800044e2:	dd0080e7          	jalr	-560(ra) # 800042ae <namex>
}
    800044e6:	60e2                	ld	ra,24(sp)
    800044e8:	6442                	ld	s0,16(sp)
    800044ea:	6105                	addi	sp,sp,32
    800044ec:	8082                	ret

00000000800044ee <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800044ee:	1141                	addi	sp,sp,-16
    800044f0:	e406                	sd	ra,8(sp)
    800044f2:	e022                	sd	s0,0(sp)
    800044f4:	0800                	addi	s0,sp,16
    800044f6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800044f8:	4585                	li	a1,1
    800044fa:	00000097          	auipc	ra,0x0
    800044fe:	db4080e7          	jalr	-588(ra) # 800042ae <namex>
}
    80004502:	60a2                	ld	ra,8(sp)
    80004504:	6402                	ld	s0,0(sp)
    80004506:	0141                	addi	sp,sp,16
    80004508:	8082                	ret

000000008000450a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000450a:	1101                	addi	sp,sp,-32
    8000450c:	ec06                	sd	ra,24(sp)
    8000450e:	e822                	sd	s0,16(sp)
    80004510:	e426                	sd	s1,8(sp)
    80004512:	e04a                	sd	s2,0(sp)
    80004514:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004516:	0001e917          	auipc	s2,0x1e
    8000451a:	8b290913          	addi	s2,s2,-1870 # 80021dc8 <log>
    8000451e:	01892583          	lw	a1,24(s2)
    80004522:	02892503          	lw	a0,40(s2)
    80004526:	fffff097          	auipc	ra,0xfffff
    8000452a:	01e080e7          	jalr	30(ra) # 80003544 <bread>
    8000452e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004530:	02c92683          	lw	a3,44(s2)
    80004534:	d134                	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004536:	02d05763          	blez	a3,80004564 <write_head+0x5a>
    8000453a:	0001e797          	auipc	a5,0x1e
    8000453e:	8be78793          	addi	a5,a5,-1858 # 80021df8 <log+0x30>
    80004542:	06450713          	addi	a4,a0,100
    80004546:	36fd                	addiw	a3,a3,-1
    80004548:	1682                	slli	a3,a3,0x20
    8000454a:	9281                	srli	a3,a3,0x20
    8000454c:	068a                	slli	a3,a3,0x2
    8000454e:	0001e617          	auipc	a2,0x1e
    80004552:	8ae60613          	addi	a2,a2,-1874 # 80021dfc <log+0x34>
    80004556:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004558:	4390                	lw	a2,0(a5)
    8000455a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000455c:	0791                	addi	a5,a5,4
    8000455e:	0711                	addi	a4,a4,4
    80004560:	fed79ce3          	bne	a5,a3,80004558 <write_head+0x4e>
  }
  bwrite(buf);
    80004564:	8526                	mv	a0,s1
    80004566:	fffff097          	auipc	ra,0xfffff
    8000456a:	0d0080e7          	jalr	208(ra) # 80003636 <bwrite>
  brelse(buf);
    8000456e:	8526                	mv	a0,s1
    80004570:	fffff097          	auipc	ra,0xfffff
    80004574:	104080e7          	jalr	260(ra) # 80003674 <brelse>
}
    80004578:	60e2                	ld	ra,24(sp)
    8000457a:	6442                	ld	s0,16(sp)
    8000457c:	64a2                	ld	s1,8(sp)
    8000457e:	6902                	ld	s2,0(sp)
    80004580:	6105                	addi	sp,sp,32
    80004582:	8082                	ret

0000000080004584 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004584:	0001e797          	auipc	a5,0x1e
    80004588:	8707a783          	lw	a5,-1936(a5) # 80021df4 <log+0x2c>
    8000458c:	0af05663          	blez	a5,80004638 <install_trans+0xb4>
{
    80004590:	7139                	addi	sp,sp,-64
    80004592:	fc06                	sd	ra,56(sp)
    80004594:	f822                	sd	s0,48(sp)
    80004596:	f426                	sd	s1,40(sp)
    80004598:	f04a                	sd	s2,32(sp)
    8000459a:	ec4e                	sd	s3,24(sp)
    8000459c:	e852                	sd	s4,16(sp)
    8000459e:	e456                	sd	s5,8(sp)
    800045a0:	0080                	addi	s0,sp,64
    800045a2:	0001ea97          	auipc	s5,0x1e
    800045a6:	856a8a93          	addi	s5,s5,-1962 # 80021df8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800045aa:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800045ac:	0001e997          	auipc	s3,0x1e
    800045b0:	81c98993          	addi	s3,s3,-2020 # 80021dc8 <log>
    800045b4:	0189a583          	lw	a1,24(s3)
    800045b8:	014585bb          	addw	a1,a1,s4
    800045bc:	2585                	addiw	a1,a1,1
    800045be:	0289a503          	lw	a0,40(s3)
    800045c2:	fffff097          	auipc	ra,0xfffff
    800045c6:	f82080e7          	jalr	-126(ra) # 80003544 <bread>
    800045ca:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800045cc:	000aa583          	lw	a1,0(s5)
    800045d0:	0289a503          	lw	a0,40(s3)
    800045d4:	fffff097          	auipc	ra,0xfffff
    800045d8:	f70080e7          	jalr	-144(ra) # 80003544 <bread>
    800045dc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800045de:	40000613          	li	a2,1024
    800045e2:	06090593          	addi	a1,s2,96
    800045e6:	06050513          	addi	a0,a0,96
    800045ea:	ffffc097          	auipc	ra,0xffffc
    800045ee:	5e4080e7          	jalr	1508(ra) # 80000bce <memmove>
    bwrite(dbuf);  // write dst to disk
    800045f2:	8526                	mv	a0,s1
    800045f4:	fffff097          	auipc	ra,0xfffff
    800045f8:	042080e7          	jalr	66(ra) # 80003636 <bwrite>
    bunpin(dbuf);
    800045fc:	8526                	mv	a0,s1
    800045fe:	fffff097          	auipc	ra,0xfffff
    80004602:	150080e7          	jalr	336(ra) # 8000374e <bunpin>
    brelse(lbuf);
    80004606:	854a                	mv	a0,s2
    80004608:	fffff097          	auipc	ra,0xfffff
    8000460c:	06c080e7          	jalr	108(ra) # 80003674 <brelse>
    brelse(dbuf);
    80004610:	8526                	mv	a0,s1
    80004612:	fffff097          	auipc	ra,0xfffff
    80004616:	062080e7          	jalr	98(ra) # 80003674 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000461a:	2a05                	addiw	s4,s4,1
    8000461c:	0a91                	addi	s5,s5,4
    8000461e:	02c9a783          	lw	a5,44(s3)
    80004622:	f8fa49e3          	blt	s4,a5,800045b4 <install_trans+0x30>
}
    80004626:	70e2                	ld	ra,56(sp)
    80004628:	7442                	ld	s0,48(sp)
    8000462a:	74a2                	ld	s1,40(sp)
    8000462c:	7902                	ld	s2,32(sp)
    8000462e:	69e2                	ld	s3,24(sp)
    80004630:	6a42                	ld	s4,16(sp)
    80004632:	6aa2                	ld	s5,8(sp)
    80004634:	6121                	addi	sp,sp,64
    80004636:	8082                	ret
    80004638:	8082                	ret

000000008000463a <initlog>:
{
    8000463a:	7179                	addi	sp,sp,-48
    8000463c:	f406                	sd	ra,40(sp)
    8000463e:	f022                	sd	s0,32(sp)
    80004640:	ec26                	sd	s1,24(sp)
    80004642:	e84a                	sd	s2,16(sp)
    80004644:	e44e                	sd	s3,8(sp)
    80004646:	1800                	addi	s0,sp,48
    80004648:	892a                	mv	s2,a0
    8000464a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000464c:	0001d497          	auipc	s1,0x1d
    80004650:	77c48493          	addi	s1,s1,1916 # 80021dc8 <log>
    80004654:	00003597          	auipc	a1,0x3
    80004658:	0d458593          	addi	a1,a1,212 # 80007728 <userret+0x698>
    8000465c:	8526                	mv	a0,s1
    8000465e:	ffffc097          	auipc	ra,0xffffc
    80004662:	362080e7          	jalr	866(ra) # 800009c0 <initlock>
  log.start = sb->logstart;
    80004666:	0149a583          	lw	a1,20(s3)
    8000466a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000466c:	0109a783          	lw	a5,16(s3)
    80004670:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004672:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004676:	854a                	mv	a0,s2
    80004678:	fffff097          	auipc	ra,0xfffff
    8000467c:	ecc080e7          	jalr	-308(ra) # 80003544 <bread>
  log.lh.n = lh->n;
    80004680:	513c                	lw	a5,96(a0)
    80004682:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004684:	02f05563          	blez	a5,800046ae <initlog+0x74>
    80004688:	06450713          	addi	a4,a0,100
    8000468c:	0001d697          	auipc	a3,0x1d
    80004690:	76c68693          	addi	a3,a3,1900 # 80021df8 <log+0x30>
    80004694:	37fd                	addiw	a5,a5,-1
    80004696:	1782                	slli	a5,a5,0x20
    80004698:	9381                	srli	a5,a5,0x20
    8000469a:	078a                	slli	a5,a5,0x2
    8000469c:	06850613          	addi	a2,a0,104
    800046a0:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800046a2:	4310                	lw	a2,0(a4)
    800046a4:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800046a6:	0711                	addi	a4,a4,4
    800046a8:	0691                	addi	a3,a3,4
    800046aa:	fef71ce3          	bne	a4,a5,800046a2 <initlog+0x68>
  brelse(buf);
    800046ae:	fffff097          	auipc	ra,0xfffff
    800046b2:	fc6080e7          	jalr	-58(ra) # 80003674 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    800046b6:	00000097          	auipc	ra,0x0
    800046ba:	ece080e7          	jalr	-306(ra) # 80004584 <install_trans>
  log.lh.n = 0;
    800046be:	0001d797          	auipc	a5,0x1d
    800046c2:	7207ab23          	sw	zero,1846(a5) # 80021df4 <log+0x2c>
  write_head(); // clear the log
    800046c6:	00000097          	auipc	ra,0x0
    800046ca:	e44080e7          	jalr	-444(ra) # 8000450a <write_head>
}
    800046ce:	70a2                	ld	ra,40(sp)
    800046d0:	7402                	ld	s0,32(sp)
    800046d2:	64e2                	ld	s1,24(sp)
    800046d4:	6942                	ld	s2,16(sp)
    800046d6:	69a2                	ld	s3,8(sp)
    800046d8:	6145                	addi	sp,sp,48
    800046da:	8082                	ret

00000000800046dc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800046dc:	1101                	addi	sp,sp,-32
    800046de:	ec06                	sd	ra,24(sp)
    800046e0:	e822                	sd	s0,16(sp)
    800046e2:	e426                	sd	s1,8(sp)
    800046e4:	e04a                	sd	s2,0(sp)
    800046e6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800046e8:	0001d517          	auipc	a0,0x1d
    800046ec:	6e050513          	addi	a0,a0,1760 # 80021dc8 <log>
    800046f0:	ffffc097          	auipc	ra,0xffffc
    800046f4:	3e2080e7          	jalr	994(ra) # 80000ad2 <acquire>
  while(1){
    if(log.committing){
    800046f8:	0001d497          	auipc	s1,0x1d
    800046fc:	6d048493          	addi	s1,s1,1744 # 80021dc8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004700:	4979                	li	s2,30
    80004702:	a039                	j	80004710 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004704:	85a6                	mv	a1,s1
    80004706:	8526                	mv	a0,s1
    80004708:	ffffe097          	auipc	ra,0xffffe
    8000470c:	062080e7          	jalr	98(ra) # 8000276a <sleep>
    if(log.committing){
    80004710:	50dc                	lw	a5,36(s1)
    80004712:	fbed                	bnez	a5,80004704 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004714:	509c                	lw	a5,32(s1)
    80004716:	0017871b          	addiw	a4,a5,1
    8000471a:	0007069b          	sext.w	a3,a4
    8000471e:	0027179b          	slliw	a5,a4,0x2
    80004722:	9fb9                	addw	a5,a5,a4
    80004724:	0017979b          	slliw	a5,a5,0x1
    80004728:	54d8                	lw	a4,44(s1)
    8000472a:	9fb9                	addw	a5,a5,a4
    8000472c:	00f95963          	bge	s2,a5,8000473e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004730:	85a6                	mv	a1,s1
    80004732:	8526                	mv	a0,s1
    80004734:	ffffe097          	auipc	ra,0xffffe
    80004738:	036080e7          	jalr	54(ra) # 8000276a <sleep>
    8000473c:	bfd1                	j	80004710 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000473e:	0001d517          	auipc	a0,0x1d
    80004742:	68a50513          	addi	a0,a0,1674 # 80021dc8 <log>
    80004746:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004748:	ffffc097          	auipc	ra,0xffffc
    8000474c:	3de080e7          	jalr	990(ra) # 80000b26 <release>
      break;
    }
  }
}
    80004750:	60e2                	ld	ra,24(sp)
    80004752:	6442                	ld	s0,16(sp)
    80004754:	64a2                	ld	s1,8(sp)
    80004756:	6902                	ld	s2,0(sp)
    80004758:	6105                	addi	sp,sp,32
    8000475a:	8082                	ret

000000008000475c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000475c:	7139                	addi	sp,sp,-64
    8000475e:	fc06                	sd	ra,56(sp)
    80004760:	f822                	sd	s0,48(sp)
    80004762:	f426                	sd	s1,40(sp)
    80004764:	f04a                	sd	s2,32(sp)
    80004766:	ec4e                	sd	s3,24(sp)
    80004768:	e852                	sd	s4,16(sp)
    8000476a:	e456                	sd	s5,8(sp)
    8000476c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000476e:	0001d497          	auipc	s1,0x1d
    80004772:	65a48493          	addi	s1,s1,1626 # 80021dc8 <log>
    80004776:	8526                	mv	a0,s1
    80004778:	ffffc097          	auipc	ra,0xffffc
    8000477c:	35a080e7          	jalr	858(ra) # 80000ad2 <acquire>
  log.outstanding -= 1;
    80004780:	509c                	lw	a5,32(s1)
    80004782:	37fd                	addiw	a5,a5,-1
    80004784:	0007891b          	sext.w	s2,a5
    80004788:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000478a:	50dc                	lw	a5,36(s1)
    8000478c:	efb9                	bnez	a5,800047ea <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000478e:	06091663          	bnez	s2,800047fa <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80004792:	0001d497          	auipc	s1,0x1d
    80004796:	63648493          	addi	s1,s1,1590 # 80021dc8 <log>
    8000479a:	4785                	li	a5,1
    8000479c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000479e:	8526                	mv	a0,s1
    800047a0:	ffffc097          	auipc	ra,0xffffc
    800047a4:	386080e7          	jalr	902(ra) # 80000b26 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800047a8:	54dc                	lw	a5,44(s1)
    800047aa:	06f04763          	bgtz	a5,80004818 <end_op+0xbc>
    acquire(&log.lock);
    800047ae:	0001d497          	auipc	s1,0x1d
    800047b2:	61a48493          	addi	s1,s1,1562 # 80021dc8 <log>
    800047b6:	8526                	mv	a0,s1
    800047b8:	ffffc097          	auipc	ra,0xffffc
    800047bc:	31a080e7          	jalr	794(ra) # 80000ad2 <acquire>
    log.committing = 0;
    800047c0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800047c4:	8526                	mv	a0,s1
    800047c6:	ffffe097          	auipc	ra,0xffffe
    800047ca:	26e080e7          	jalr	622(ra) # 80002a34 <wakeup>
    release(&log.lock);
    800047ce:	8526                	mv	a0,s1
    800047d0:	ffffc097          	auipc	ra,0xffffc
    800047d4:	356080e7          	jalr	854(ra) # 80000b26 <release>
}
    800047d8:	70e2                	ld	ra,56(sp)
    800047da:	7442                	ld	s0,48(sp)
    800047dc:	74a2                	ld	s1,40(sp)
    800047de:	7902                	ld	s2,32(sp)
    800047e0:	69e2                	ld	s3,24(sp)
    800047e2:	6a42                	ld	s4,16(sp)
    800047e4:	6aa2                	ld	s5,8(sp)
    800047e6:	6121                	addi	sp,sp,64
    800047e8:	8082                	ret
    panic("log.committing");
    800047ea:	00003517          	auipc	a0,0x3
    800047ee:	f4650513          	addi	a0,a0,-186 # 80007730 <userret+0x6a0>
    800047f2:	ffffc097          	auipc	ra,0xffffc
    800047f6:	d5c080e7          	jalr	-676(ra) # 8000054e <panic>
    wakeup(&log);
    800047fa:	0001d497          	auipc	s1,0x1d
    800047fe:	5ce48493          	addi	s1,s1,1486 # 80021dc8 <log>
    80004802:	8526                	mv	a0,s1
    80004804:	ffffe097          	auipc	ra,0xffffe
    80004808:	230080e7          	jalr	560(ra) # 80002a34 <wakeup>
  release(&log.lock);
    8000480c:	8526                	mv	a0,s1
    8000480e:	ffffc097          	auipc	ra,0xffffc
    80004812:	318080e7          	jalr	792(ra) # 80000b26 <release>
  if(do_commit){
    80004816:	b7c9                	j	800047d8 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004818:	0001da97          	auipc	s5,0x1d
    8000481c:	5e0a8a93          	addi	s5,s5,1504 # 80021df8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004820:	0001da17          	auipc	s4,0x1d
    80004824:	5a8a0a13          	addi	s4,s4,1448 # 80021dc8 <log>
    80004828:	018a2583          	lw	a1,24(s4)
    8000482c:	012585bb          	addw	a1,a1,s2
    80004830:	2585                	addiw	a1,a1,1
    80004832:	028a2503          	lw	a0,40(s4)
    80004836:	fffff097          	auipc	ra,0xfffff
    8000483a:	d0e080e7          	jalr	-754(ra) # 80003544 <bread>
    8000483e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004840:	000aa583          	lw	a1,0(s5)
    80004844:	028a2503          	lw	a0,40(s4)
    80004848:	fffff097          	auipc	ra,0xfffff
    8000484c:	cfc080e7          	jalr	-772(ra) # 80003544 <bread>
    80004850:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004852:	40000613          	li	a2,1024
    80004856:	06050593          	addi	a1,a0,96
    8000485a:	06048513          	addi	a0,s1,96
    8000485e:	ffffc097          	auipc	ra,0xffffc
    80004862:	370080e7          	jalr	880(ra) # 80000bce <memmove>
    bwrite(to);  // write the log
    80004866:	8526                	mv	a0,s1
    80004868:	fffff097          	auipc	ra,0xfffff
    8000486c:	dce080e7          	jalr	-562(ra) # 80003636 <bwrite>
    brelse(from);
    80004870:	854e                	mv	a0,s3
    80004872:	fffff097          	auipc	ra,0xfffff
    80004876:	e02080e7          	jalr	-510(ra) # 80003674 <brelse>
    brelse(to);
    8000487a:	8526                	mv	a0,s1
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	df8080e7          	jalr	-520(ra) # 80003674 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004884:	2905                	addiw	s2,s2,1
    80004886:	0a91                	addi	s5,s5,4
    80004888:	02ca2783          	lw	a5,44(s4)
    8000488c:	f8f94ee3          	blt	s2,a5,80004828 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004890:	00000097          	auipc	ra,0x0
    80004894:	c7a080e7          	jalr	-902(ra) # 8000450a <write_head>
    install_trans(); // Now install writes to home locations
    80004898:	00000097          	auipc	ra,0x0
    8000489c:	cec080e7          	jalr	-788(ra) # 80004584 <install_trans>
    log.lh.n = 0;
    800048a0:	0001d797          	auipc	a5,0x1d
    800048a4:	5407aa23          	sw	zero,1364(a5) # 80021df4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800048a8:	00000097          	auipc	ra,0x0
    800048ac:	c62080e7          	jalr	-926(ra) # 8000450a <write_head>
    800048b0:	bdfd                	j	800047ae <end_op+0x52>

00000000800048b2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800048b2:	1101                	addi	sp,sp,-32
    800048b4:	ec06                	sd	ra,24(sp)
    800048b6:	e822                	sd	s0,16(sp)
    800048b8:	e426                	sd	s1,8(sp)
    800048ba:	e04a                	sd	s2,0(sp)
    800048bc:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800048be:	0001d717          	auipc	a4,0x1d
    800048c2:	53672703          	lw	a4,1334(a4) # 80021df4 <log+0x2c>
    800048c6:	47f5                	li	a5,29
    800048c8:	08e7c063          	blt	a5,a4,80004948 <log_write+0x96>
    800048cc:	84aa                	mv	s1,a0
    800048ce:	0001d797          	auipc	a5,0x1d
    800048d2:	5167a783          	lw	a5,1302(a5) # 80021de4 <log+0x1c>
    800048d6:	37fd                	addiw	a5,a5,-1
    800048d8:	06f75863          	bge	a4,a5,80004948 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800048dc:	0001d797          	auipc	a5,0x1d
    800048e0:	50c7a783          	lw	a5,1292(a5) # 80021de8 <log+0x20>
    800048e4:	06f05a63          	blez	a5,80004958 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    800048e8:	0001d917          	auipc	s2,0x1d
    800048ec:	4e090913          	addi	s2,s2,1248 # 80021dc8 <log>
    800048f0:	854a                	mv	a0,s2
    800048f2:	ffffc097          	auipc	ra,0xffffc
    800048f6:	1e0080e7          	jalr	480(ra) # 80000ad2 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800048fa:	02c92603          	lw	a2,44(s2)
    800048fe:	06c05563          	blez	a2,80004968 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004902:	44cc                	lw	a1,12(s1)
    80004904:	0001d717          	auipc	a4,0x1d
    80004908:	4f470713          	addi	a4,a4,1268 # 80021df8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000490c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    8000490e:	4314                	lw	a3,0(a4)
    80004910:	04b68d63          	beq	a3,a1,8000496a <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    80004914:	2785                	addiw	a5,a5,1
    80004916:	0711                	addi	a4,a4,4
    80004918:	fec79be3          	bne	a5,a2,8000490e <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000491c:	0621                	addi	a2,a2,8
    8000491e:	060a                	slli	a2,a2,0x2
    80004920:	0001d797          	auipc	a5,0x1d
    80004924:	4a878793          	addi	a5,a5,1192 # 80021dc8 <log>
    80004928:	963e                	add	a2,a2,a5
    8000492a:	44dc                	lw	a5,12(s1)
    8000492c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000492e:	8526                	mv	a0,s1
    80004930:	fffff097          	auipc	ra,0xfffff
    80004934:	de2080e7          	jalr	-542(ra) # 80003712 <bpin>
    log.lh.n++;
    80004938:	0001d717          	auipc	a4,0x1d
    8000493c:	49070713          	addi	a4,a4,1168 # 80021dc8 <log>
    80004940:	575c                	lw	a5,44(a4)
    80004942:	2785                	addiw	a5,a5,1
    80004944:	d75c                	sw	a5,44(a4)
    80004946:	a83d                	j	80004984 <log_write+0xd2>
    panic("too big a transaction");
    80004948:	00003517          	auipc	a0,0x3
    8000494c:	df850513          	addi	a0,a0,-520 # 80007740 <userret+0x6b0>
    80004950:	ffffc097          	auipc	ra,0xffffc
    80004954:	bfe080e7          	jalr	-1026(ra) # 8000054e <panic>
    panic("log_write outside of trans");
    80004958:	00003517          	auipc	a0,0x3
    8000495c:	e0050513          	addi	a0,a0,-512 # 80007758 <userret+0x6c8>
    80004960:	ffffc097          	auipc	ra,0xffffc
    80004964:	bee080e7          	jalr	-1042(ra) # 8000054e <panic>
  for (i = 0; i < log.lh.n; i++) {
    80004968:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    8000496a:	00878713          	addi	a4,a5,8
    8000496e:	00271693          	slli	a3,a4,0x2
    80004972:	0001d717          	auipc	a4,0x1d
    80004976:	45670713          	addi	a4,a4,1110 # 80021dc8 <log>
    8000497a:	9736                	add	a4,a4,a3
    8000497c:	44d4                	lw	a3,12(s1)
    8000497e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004980:	faf607e3          	beq	a2,a5,8000492e <log_write+0x7c>
  }
  release(&log.lock);
    80004984:	0001d517          	auipc	a0,0x1d
    80004988:	44450513          	addi	a0,a0,1092 # 80021dc8 <log>
    8000498c:	ffffc097          	auipc	ra,0xffffc
    80004990:	19a080e7          	jalr	410(ra) # 80000b26 <release>
}
    80004994:	60e2                	ld	ra,24(sp)
    80004996:	6442                	ld	s0,16(sp)
    80004998:	64a2                	ld	s1,8(sp)
    8000499a:	6902                	ld	s2,0(sp)
    8000499c:	6105                	addi	sp,sp,32
    8000499e:	8082                	ret

00000000800049a0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800049a0:	1101                	addi	sp,sp,-32
    800049a2:	ec06                	sd	ra,24(sp)
    800049a4:	e822                	sd	s0,16(sp)
    800049a6:	e426                	sd	s1,8(sp)
    800049a8:	e04a                	sd	s2,0(sp)
    800049aa:	1000                	addi	s0,sp,32
    800049ac:	84aa                	mv	s1,a0
    800049ae:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800049b0:	00003597          	auipc	a1,0x3
    800049b4:	dc858593          	addi	a1,a1,-568 # 80007778 <userret+0x6e8>
    800049b8:	0521                	addi	a0,a0,8
    800049ba:	ffffc097          	auipc	ra,0xffffc
    800049be:	006080e7          	jalr	6(ra) # 800009c0 <initlock>
  lk->name = name;
    800049c2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800049c6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800049ca:	0204a423          	sw	zero,40(s1)
}
    800049ce:	60e2                	ld	ra,24(sp)
    800049d0:	6442                	ld	s0,16(sp)
    800049d2:	64a2                	ld	s1,8(sp)
    800049d4:	6902                	ld	s2,0(sp)
    800049d6:	6105                	addi	sp,sp,32
    800049d8:	8082                	ret

00000000800049da <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800049da:	1101                	addi	sp,sp,-32
    800049dc:	ec06                	sd	ra,24(sp)
    800049de:	e822                	sd	s0,16(sp)
    800049e0:	e426                	sd	s1,8(sp)
    800049e2:	e04a                	sd	s2,0(sp)
    800049e4:	1000                	addi	s0,sp,32
    800049e6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800049e8:	00850913          	addi	s2,a0,8
    800049ec:	854a                	mv	a0,s2
    800049ee:	ffffc097          	auipc	ra,0xffffc
    800049f2:	0e4080e7          	jalr	228(ra) # 80000ad2 <acquire>
  while (lk->locked) {
    800049f6:	409c                	lw	a5,0(s1)
    800049f8:	cb89                	beqz	a5,80004a0a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800049fa:	85ca                	mv	a1,s2
    800049fc:	8526                	mv	a0,s1
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	d6c080e7          	jalr	-660(ra) # 8000276a <sleep>
  while (lk->locked) {
    80004a06:	409c                	lw	a5,0(s1)
    80004a08:	fbed                	bnez	a5,800049fa <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004a0a:	4785                	li	a5,1
    80004a0c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004a0e:	ffffd097          	auipc	ra,0xffffd
    80004a12:	0f4080e7          	jalr	244(ra) # 80001b02 <myproc>
    80004a16:	5d1c                	lw	a5,56(a0)
    80004a18:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004a1a:	854a                	mv	a0,s2
    80004a1c:	ffffc097          	auipc	ra,0xffffc
    80004a20:	10a080e7          	jalr	266(ra) # 80000b26 <release>
}
    80004a24:	60e2                	ld	ra,24(sp)
    80004a26:	6442                	ld	s0,16(sp)
    80004a28:	64a2                	ld	s1,8(sp)
    80004a2a:	6902                	ld	s2,0(sp)
    80004a2c:	6105                	addi	sp,sp,32
    80004a2e:	8082                	ret

0000000080004a30 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004a30:	1101                	addi	sp,sp,-32
    80004a32:	ec06                	sd	ra,24(sp)
    80004a34:	e822                	sd	s0,16(sp)
    80004a36:	e426                	sd	s1,8(sp)
    80004a38:	e04a                	sd	s2,0(sp)
    80004a3a:	1000                	addi	s0,sp,32
    80004a3c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a3e:	00850913          	addi	s2,a0,8
    80004a42:	854a                	mv	a0,s2
    80004a44:	ffffc097          	auipc	ra,0xffffc
    80004a48:	08e080e7          	jalr	142(ra) # 80000ad2 <acquire>
  lk->locked = 0;
    80004a4c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004a50:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004a54:	8526                	mv	a0,s1
    80004a56:	ffffe097          	auipc	ra,0xffffe
    80004a5a:	fde080e7          	jalr	-34(ra) # 80002a34 <wakeup>
  release(&lk->lk);
    80004a5e:	854a                	mv	a0,s2
    80004a60:	ffffc097          	auipc	ra,0xffffc
    80004a64:	0c6080e7          	jalr	198(ra) # 80000b26 <release>
}
    80004a68:	60e2                	ld	ra,24(sp)
    80004a6a:	6442                	ld	s0,16(sp)
    80004a6c:	64a2                	ld	s1,8(sp)
    80004a6e:	6902                	ld	s2,0(sp)
    80004a70:	6105                	addi	sp,sp,32
    80004a72:	8082                	ret

0000000080004a74 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004a74:	7179                	addi	sp,sp,-48
    80004a76:	f406                	sd	ra,40(sp)
    80004a78:	f022                	sd	s0,32(sp)
    80004a7a:	ec26                	sd	s1,24(sp)
    80004a7c:	e84a                	sd	s2,16(sp)
    80004a7e:	e44e                	sd	s3,8(sp)
    80004a80:	1800                	addi	s0,sp,48
    80004a82:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004a84:	00850913          	addi	s2,a0,8
    80004a88:	854a                	mv	a0,s2
    80004a8a:	ffffc097          	auipc	ra,0xffffc
    80004a8e:	048080e7          	jalr	72(ra) # 80000ad2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a92:	409c                	lw	a5,0(s1)
    80004a94:	ef99                	bnez	a5,80004ab2 <holdingsleep+0x3e>
    80004a96:	4481                	li	s1,0
  release(&lk->lk);
    80004a98:	854a                	mv	a0,s2
    80004a9a:	ffffc097          	auipc	ra,0xffffc
    80004a9e:	08c080e7          	jalr	140(ra) # 80000b26 <release>
  return r;
}
    80004aa2:	8526                	mv	a0,s1
    80004aa4:	70a2                	ld	ra,40(sp)
    80004aa6:	7402                	ld	s0,32(sp)
    80004aa8:	64e2                	ld	s1,24(sp)
    80004aaa:	6942                	ld	s2,16(sp)
    80004aac:	69a2                	ld	s3,8(sp)
    80004aae:	6145                	addi	sp,sp,48
    80004ab0:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004ab2:	0284a983          	lw	s3,40(s1)
    80004ab6:	ffffd097          	auipc	ra,0xffffd
    80004aba:	04c080e7          	jalr	76(ra) # 80001b02 <myproc>
    80004abe:	5d04                	lw	s1,56(a0)
    80004ac0:	413484b3          	sub	s1,s1,s3
    80004ac4:	0014b493          	seqz	s1,s1
    80004ac8:	bfc1                	j	80004a98 <holdingsleep+0x24>

0000000080004aca <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004aca:	1141                	addi	sp,sp,-16
    80004acc:	e406                	sd	ra,8(sp)
    80004ace:	e022                	sd	s0,0(sp)
    80004ad0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004ad2:	00003597          	auipc	a1,0x3
    80004ad6:	cb658593          	addi	a1,a1,-842 # 80007788 <userret+0x6f8>
    80004ada:	0001d517          	auipc	a0,0x1d
    80004ade:	43650513          	addi	a0,a0,1078 # 80021f10 <ftable>
    80004ae2:	ffffc097          	auipc	ra,0xffffc
    80004ae6:	ede080e7          	jalr	-290(ra) # 800009c0 <initlock>
}
    80004aea:	60a2                	ld	ra,8(sp)
    80004aec:	6402                	ld	s0,0(sp)
    80004aee:	0141                	addi	sp,sp,16
    80004af0:	8082                	ret

0000000080004af2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004af2:	1101                	addi	sp,sp,-32
    80004af4:	ec06                	sd	ra,24(sp)
    80004af6:	e822                	sd	s0,16(sp)
    80004af8:	e426                	sd	s1,8(sp)
    80004afa:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004afc:	0001d517          	auipc	a0,0x1d
    80004b00:	41450513          	addi	a0,a0,1044 # 80021f10 <ftable>
    80004b04:	ffffc097          	auipc	ra,0xffffc
    80004b08:	fce080e7          	jalr	-50(ra) # 80000ad2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004b0c:	0001d497          	auipc	s1,0x1d
    80004b10:	41c48493          	addi	s1,s1,1052 # 80021f28 <ftable+0x18>
    80004b14:	0001e717          	auipc	a4,0x1e
    80004b18:	3b470713          	addi	a4,a4,948 # 80022ec8 <ftable+0xfb8>
    if(f->ref == 0){
    80004b1c:	40dc                	lw	a5,4(s1)
    80004b1e:	cf99                	beqz	a5,80004b3c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004b20:	02848493          	addi	s1,s1,40
    80004b24:	fee49ce3          	bne	s1,a4,80004b1c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004b28:	0001d517          	auipc	a0,0x1d
    80004b2c:	3e850513          	addi	a0,a0,1000 # 80021f10 <ftable>
    80004b30:	ffffc097          	auipc	ra,0xffffc
    80004b34:	ff6080e7          	jalr	-10(ra) # 80000b26 <release>
  return 0;
    80004b38:	4481                	li	s1,0
    80004b3a:	a819                	j	80004b50 <filealloc+0x5e>
      f->ref = 1;
    80004b3c:	4785                	li	a5,1
    80004b3e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004b40:	0001d517          	auipc	a0,0x1d
    80004b44:	3d050513          	addi	a0,a0,976 # 80021f10 <ftable>
    80004b48:	ffffc097          	auipc	ra,0xffffc
    80004b4c:	fde080e7          	jalr	-34(ra) # 80000b26 <release>
}
    80004b50:	8526                	mv	a0,s1
    80004b52:	60e2                	ld	ra,24(sp)
    80004b54:	6442                	ld	s0,16(sp)
    80004b56:	64a2                	ld	s1,8(sp)
    80004b58:	6105                	addi	sp,sp,32
    80004b5a:	8082                	ret

0000000080004b5c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004b5c:	1101                	addi	sp,sp,-32
    80004b5e:	ec06                	sd	ra,24(sp)
    80004b60:	e822                	sd	s0,16(sp)
    80004b62:	e426                	sd	s1,8(sp)
    80004b64:	1000                	addi	s0,sp,32
    80004b66:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004b68:	0001d517          	auipc	a0,0x1d
    80004b6c:	3a850513          	addi	a0,a0,936 # 80021f10 <ftable>
    80004b70:	ffffc097          	auipc	ra,0xffffc
    80004b74:	f62080e7          	jalr	-158(ra) # 80000ad2 <acquire>
  if(f->ref < 1)
    80004b78:	40dc                	lw	a5,4(s1)
    80004b7a:	02f05263          	blez	a5,80004b9e <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004b7e:	2785                	addiw	a5,a5,1
    80004b80:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004b82:	0001d517          	auipc	a0,0x1d
    80004b86:	38e50513          	addi	a0,a0,910 # 80021f10 <ftable>
    80004b8a:	ffffc097          	auipc	ra,0xffffc
    80004b8e:	f9c080e7          	jalr	-100(ra) # 80000b26 <release>
  return f;
}
    80004b92:	8526                	mv	a0,s1
    80004b94:	60e2                	ld	ra,24(sp)
    80004b96:	6442                	ld	s0,16(sp)
    80004b98:	64a2                	ld	s1,8(sp)
    80004b9a:	6105                	addi	sp,sp,32
    80004b9c:	8082                	ret
    panic("filedup");
    80004b9e:	00003517          	auipc	a0,0x3
    80004ba2:	bf250513          	addi	a0,a0,-1038 # 80007790 <userret+0x700>
    80004ba6:	ffffc097          	auipc	ra,0xffffc
    80004baa:	9a8080e7          	jalr	-1624(ra) # 8000054e <panic>

0000000080004bae <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004bae:	7139                	addi	sp,sp,-64
    80004bb0:	fc06                	sd	ra,56(sp)
    80004bb2:	f822                	sd	s0,48(sp)
    80004bb4:	f426                	sd	s1,40(sp)
    80004bb6:	f04a                	sd	s2,32(sp)
    80004bb8:	ec4e                	sd	s3,24(sp)
    80004bba:	e852                	sd	s4,16(sp)
    80004bbc:	e456                	sd	s5,8(sp)
    80004bbe:	0080                	addi	s0,sp,64
    80004bc0:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004bc2:	0001d517          	auipc	a0,0x1d
    80004bc6:	34e50513          	addi	a0,a0,846 # 80021f10 <ftable>
    80004bca:	ffffc097          	auipc	ra,0xffffc
    80004bce:	f08080e7          	jalr	-248(ra) # 80000ad2 <acquire>
  if(f->ref < 1)
    80004bd2:	40dc                	lw	a5,4(s1)
    80004bd4:	06f05163          	blez	a5,80004c36 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004bd8:	37fd                	addiw	a5,a5,-1
    80004bda:	0007871b          	sext.w	a4,a5
    80004bde:	c0dc                	sw	a5,4(s1)
    80004be0:	06e04363          	bgtz	a4,80004c46 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004be4:	0004a903          	lw	s2,0(s1)
    80004be8:	0094ca83          	lbu	s5,9(s1)
    80004bec:	0104ba03          	ld	s4,16(s1)
    80004bf0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004bf4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004bf8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004bfc:	0001d517          	auipc	a0,0x1d
    80004c00:	31450513          	addi	a0,a0,788 # 80021f10 <ftable>
    80004c04:	ffffc097          	auipc	ra,0xffffc
    80004c08:	f22080e7          	jalr	-222(ra) # 80000b26 <release>

  if(ff.type == FD_PIPE){
    80004c0c:	4785                	li	a5,1
    80004c0e:	04f90d63          	beq	s2,a5,80004c68 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004c12:	3979                	addiw	s2,s2,-2
    80004c14:	4785                	li	a5,1
    80004c16:	0527e063          	bltu	a5,s2,80004c56 <fileclose+0xa8>
    begin_op();
    80004c1a:	00000097          	auipc	ra,0x0
    80004c1e:	ac2080e7          	jalr	-1342(ra) # 800046dc <begin_op>
    iput(ff.ip);
    80004c22:	854e                	mv	a0,s3
    80004c24:	fffff097          	auipc	ra,0xfffff
    80004c28:	230080e7          	jalr	560(ra) # 80003e54 <iput>
    end_op();
    80004c2c:	00000097          	auipc	ra,0x0
    80004c30:	b30080e7          	jalr	-1232(ra) # 8000475c <end_op>
    80004c34:	a00d                	j	80004c56 <fileclose+0xa8>
    panic("fileclose");
    80004c36:	00003517          	auipc	a0,0x3
    80004c3a:	b6250513          	addi	a0,a0,-1182 # 80007798 <userret+0x708>
    80004c3e:	ffffc097          	auipc	ra,0xffffc
    80004c42:	910080e7          	jalr	-1776(ra) # 8000054e <panic>
    release(&ftable.lock);
    80004c46:	0001d517          	auipc	a0,0x1d
    80004c4a:	2ca50513          	addi	a0,a0,714 # 80021f10 <ftable>
    80004c4e:	ffffc097          	auipc	ra,0xffffc
    80004c52:	ed8080e7          	jalr	-296(ra) # 80000b26 <release>
  }
}
    80004c56:	70e2                	ld	ra,56(sp)
    80004c58:	7442                	ld	s0,48(sp)
    80004c5a:	74a2                	ld	s1,40(sp)
    80004c5c:	7902                	ld	s2,32(sp)
    80004c5e:	69e2                	ld	s3,24(sp)
    80004c60:	6a42                	ld	s4,16(sp)
    80004c62:	6aa2                	ld	s5,8(sp)
    80004c64:	6121                	addi	sp,sp,64
    80004c66:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004c68:	85d6                	mv	a1,s5
    80004c6a:	8552                	mv	a0,s4
    80004c6c:	00000097          	auipc	ra,0x0
    80004c70:	372080e7          	jalr	882(ra) # 80004fde <pipeclose>
    80004c74:	b7cd                	j	80004c56 <fileclose+0xa8>

0000000080004c76 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004c76:	715d                	addi	sp,sp,-80
    80004c78:	e486                	sd	ra,72(sp)
    80004c7a:	e0a2                	sd	s0,64(sp)
    80004c7c:	fc26                	sd	s1,56(sp)
    80004c7e:	f84a                	sd	s2,48(sp)
    80004c80:	f44e                	sd	s3,40(sp)
    80004c82:	0880                	addi	s0,sp,80
    80004c84:	84aa                	mv	s1,a0
    80004c86:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004c88:	ffffd097          	auipc	ra,0xffffd
    80004c8c:	e7a080e7          	jalr	-390(ra) # 80001b02 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004c90:	409c                	lw	a5,0(s1)
    80004c92:	37f9                	addiw	a5,a5,-2
    80004c94:	4705                	li	a4,1
    80004c96:	04f76763          	bltu	a4,a5,80004ce4 <filestat+0x6e>
    80004c9a:	892a                	mv	s2,a0
    ilock(f->ip);
    80004c9c:	6c88                	ld	a0,24(s1)
    80004c9e:	fffff097          	auipc	ra,0xfffff
    80004ca2:	0a8080e7          	jalr	168(ra) # 80003d46 <ilock>
    stati(f->ip, &st);
    80004ca6:	fb840593          	addi	a1,s0,-72
    80004caa:	6c88                	ld	a0,24(s1)
    80004cac:	fffff097          	auipc	ra,0xfffff
    80004cb0:	300080e7          	jalr	768(ra) # 80003fac <stati>
    iunlock(f->ip);
    80004cb4:	6c88                	ld	a0,24(s1)
    80004cb6:	fffff097          	auipc	ra,0xfffff
    80004cba:	152080e7          	jalr	338(ra) # 80003e08 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004cbe:	46e1                	li	a3,24
    80004cc0:	fb840613          	addi	a2,s0,-72
    80004cc4:	85ce                	mv	a1,s3
    80004cc6:	06093503          	ld	a0,96(s2)
    80004cca:	ffffd097          	auipc	ra,0xffffd
    80004cce:	8b2080e7          	jalr	-1870(ra) # 8000157c <copyout>
    80004cd2:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004cd6:	60a6                	ld	ra,72(sp)
    80004cd8:	6406                	ld	s0,64(sp)
    80004cda:	74e2                	ld	s1,56(sp)
    80004cdc:	7942                	ld	s2,48(sp)
    80004cde:	79a2                	ld	s3,40(sp)
    80004ce0:	6161                	addi	sp,sp,80
    80004ce2:	8082                	ret
  return -1;
    80004ce4:	557d                	li	a0,-1
    80004ce6:	bfc5                	j	80004cd6 <filestat+0x60>

0000000080004ce8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004ce8:	7179                	addi	sp,sp,-48
    80004cea:	f406                	sd	ra,40(sp)
    80004cec:	f022                	sd	s0,32(sp)
    80004cee:	ec26                	sd	s1,24(sp)
    80004cf0:	e84a                	sd	s2,16(sp)
    80004cf2:	e44e                	sd	s3,8(sp)
    80004cf4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004cf6:	00854783          	lbu	a5,8(a0)
    80004cfa:	c3d5                	beqz	a5,80004d9e <fileread+0xb6>
    80004cfc:	84aa                	mv	s1,a0
    80004cfe:	89ae                	mv	s3,a1
    80004d00:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d02:	411c                	lw	a5,0(a0)
    80004d04:	4705                	li	a4,1
    80004d06:	04e78963          	beq	a5,a4,80004d58 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d0a:	470d                	li	a4,3
    80004d0c:	04e78d63          	beq	a5,a4,80004d66 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d10:	4709                	li	a4,2
    80004d12:	06e79e63          	bne	a5,a4,80004d8e <fileread+0xa6>
    ilock(f->ip);
    80004d16:	6d08                	ld	a0,24(a0)
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	02e080e7          	jalr	46(ra) # 80003d46 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004d20:	874a                	mv	a4,s2
    80004d22:	5094                	lw	a3,32(s1)
    80004d24:	864e                	mv	a2,s3
    80004d26:	4585                	li	a1,1
    80004d28:	6c88                	ld	a0,24(s1)
    80004d2a:	fffff097          	auipc	ra,0xfffff
    80004d2e:	2ac080e7          	jalr	684(ra) # 80003fd6 <readi>
    80004d32:	892a                	mv	s2,a0
    80004d34:	00a05563          	blez	a0,80004d3e <fileread+0x56>
      f->off += r;
    80004d38:	509c                	lw	a5,32(s1)
    80004d3a:	9fa9                	addw	a5,a5,a0
    80004d3c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004d3e:	6c88                	ld	a0,24(s1)
    80004d40:	fffff097          	auipc	ra,0xfffff
    80004d44:	0c8080e7          	jalr	200(ra) # 80003e08 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004d48:	854a                	mv	a0,s2
    80004d4a:	70a2                	ld	ra,40(sp)
    80004d4c:	7402                	ld	s0,32(sp)
    80004d4e:	64e2                	ld	s1,24(sp)
    80004d50:	6942                	ld	s2,16(sp)
    80004d52:	69a2                	ld	s3,8(sp)
    80004d54:	6145                	addi	sp,sp,48
    80004d56:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004d58:	6908                	ld	a0,16(a0)
    80004d5a:	00000097          	auipc	ra,0x0
    80004d5e:	408080e7          	jalr	1032(ra) # 80005162 <piperead>
    80004d62:	892a                	mv	s2,a0
    80004d64:	b7d5                	j	80004d48 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004d66:	02451783          	lh	a5,36(a0)
    80004d6a:	03079693          	slli	a3,a5,0x30
    80004d6e:	92c1                	srli	a3,a3,0x30
    80004d70:	4725                	li	a4,9
    80004d72:	02d76863          	bltu	a4,a3,80004da2 <fileread+0xba>
    80004d76:	0792                	slli	a5,a5,0x4
    80004d78:	0001d717          	auipc	a4,0x1d
    80004d7c:	0f870713          	addi	a4,a4,248 # 80021e70 <devsw>
    80004d80:	97ba                	add	a5,a5,a4
    80004d82:	639c                	ld	a5,0(a5)
    80004d84:	c38d                	beqz	a5,80004da6 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004d86:	4505                	li	a0,1
    80004d88:	9782                	jalr	a5
    80004d8a:	892a                	mv	s2,a0
    80004d8c:	bf75                	j	80004d48 <fileread+0x60>
    panic("fileread");
    80004d8e:	00003517          	auipc	a0,0x3
    80004d92:	a1a50513          	addi	a0,a0,-1510 # 800077a8 <userret+0x718>
    80004d96:	ffffb097          	auipc	ra,0xffffb
    80004d9a:	7b8080e7          	jalr	1976(ra) # 8000054e <panic>
    return -1;
    80004d9e:	597d                	li	s2,-1
    80004da0:	b765                	j	80004d48 <fileread+0x60>
      return -1;
    80004da2:	597d                	li	s2,-1
    80004da4:	b755                	j	80004d48 <fileread+0x60>
    80004da6:	597d                	li	s2,-1
    80004da8:	b745                	j	80004d48 <fileread+0x60>

0000000080004daa <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004daa:	00954783          	lbu	a5,9(a0)
    80004dae:	14078563          	beqz	a5,80004ef8 <filewrite+0x14e>
{
    80004db2:	715d                	addi	sp,sp,-80
    80004db4:	e486                	sd	ra,72(sp)
    80004db6:	e0a2                	sd	s0,64(sp)
    80004db8:	fc26                	sd	s1,56(sp)
    80004dba:	f84a                	sd	s2,48(sp)
    80004dbc:	f44e                	sd	s3,40(sp)
    80004dbe:	f052                	sd	s4,32(sp)
    80004dc0:	ec56                	sd	s5,24(sp)
    80004dc2:	e85a                	sd	s6,16(sp)
    80004dc4:	e45e                	sd	s7,8(sp)
    80004dc6:	e062                	sd	s8,0(sp)
    80004dc8:	0880                	addi	s0,sp,80
    80004dca:	892a                	mv	s2,a0
    80004dcc:	8aae                	mv	s5,a1
    80004dce:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004dd0:	411c                	lw	a5,0(a0)
    80004dd2:	4705                	li	a4,1
    80004dd4:	02e78263          	beq	a5,a4,80004df8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004dd8:	470d                	li	a4,3
    80004dda:	02e78563          	beq	a5,a4,80004e04 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004dde:	4709                	li	a4,2
    80004de0:	10e79463          	bne	a5,a4,80004ee8 <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004de4:	0ec05e63          	blez	a2,80004ee0 <filewrite+0x136>
    int i = 0;
    80004de8:	4981                	li	s3,0
    80004dea:	6b05                	lui	s6,0x1
    80004dec:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004df0:	6b85                	lui	s7,0x1
    80004df2:	c00b8b9b          	addiw	s7,s7,-1024
    80004df6:	a851                	j	80004e8a <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004df8:	6908                	ld	a0,16(a0)
    80004dfa:	00000097          	auipc	ra,0x0
    80004dfe:	254080e7          	jalr	596(ra) # 8000504e <pipewrite>
    80004e02:	a85d                	j	80004eb8 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004e04:	02451783          	lh	a5,36(a0)
    80004e08:	03079693          	slli	a3,a5,0x30
    80004e0c:	92c1                	srli	a3,a3,0x30
    80004e0e:	4725                	li	a4,9
    80004e10:	0ed76663          	bltu	a4,a3,80004efc <filewrite+0x152>
    80004e14:	0792                	slli	a5,a5,0x4
    80004e16:	0001d717          	auipc	a4,0x1d
    80004e1a:	05a70713          	addi	a4,a4,90 # 80021e70 <devsw>
    80004e1e:	97ba                	add	a5,a5,a4
    80004e20:	679c                	ld	a5,8(a5)
    80004e22:	cff9                	beqz	a5,80004f00 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004e24:	4505                	li	a0,1
    80004e26:	9782                	jalr	a5
    80004e28:	a841                	j	80004eb8 <filewrite+0x10e>
    80004e2a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004e2e:	00000097          	auipc	ra,0x0
    80004e32:	8ae080e7          	jalr	-1874(ra) # 800046dc <begin_op>
      ilock(f->ip);
    80004e36:	01893503          	ld	a0,24(s2)
    80004e3a:	fffff097          	auipc	ra,0xfffff
    80004e3e:	f0c080e7          	jalr	-244(ra) # 80003d46 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004e42:	8762                	mv	a4,s8
    80004e44:	02092683          	lw	a3,32(s2)
    80004e48:	01598633          	add	a2,s3,s5
    80004e4c:	4585                	li	a1,1
    80004e4e:	01893503          	ld	a0,24(s2)
    80004e52:	fffff097          	auipc	ra,0xfffff
    80004e56:	278080e7          	jalr	632(ra) # 800040ca <writei>
    80004e5a:	84aa                	mv	s1,a0
    80004e5c:	02a05f63          	blez	a0,80004e9a <filewrite+0xf0>
        f->off += r;
    80004e60:	02092783          	lw	a5,32(s2)
    80004e64:	9fa9                	addw	a5,a5,a0
    80004e66:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004e6a:	01893503          	ld	a0,24(s2)
    80004e6e:	fffff097          	auipc	ra,0xfffff
    80004e72:	f9a080e7          	jalr	-102(ra) # 80003e08 <iunlock>
      end_op();
    80004e76:	00000097          	auipc	ra,0x0
    80004e7a:	8e6080e7          	jalr	-1818(ra) # 8000475c <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004e7e:	049c1963          	bne	s8,s1,80004ed0 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004e82:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004e86:	0349d663          	bge	s3,s4,80004eb2 <filewrite+0x108>
      int n1 = n - i;
    80004e8a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004e8e:	84be                	mv	s1,a5
    80004e90:	2781                	sext.w	a5,a5
    80004e92:	f8fb5ce3          	bge	s6,a5,80004e2a <filewrite+0x80>
    80004e96:	84de                	mv	s1,s7
    80004e98:	bf49                	j	80004e2a <filewrite+0x80>
      iunlock(f->ip);
    80004e9a:	01893503          	ld	a0,24(s2)
    80004e9e:	fffff097          	auipc	ra,0xfffff
    80004ea2:	f6a080e7          	jalr	-150(ra) # 80003e08 <iunlock>
      end_op();
    80004ea6:	00000097          	auipc	ra,0x0
    80004eaa:	8b6080e7          	jalr	-1866(ra) # 8000475c <end_op>
      if(r < 0)
    80004eae:	fc04d8e3          	bgez	s1,80004e7e <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004eb2:	8552                	mv	a0,s4
    80004eb4:	033a1863          	bne	s4,s3,80004ee4 <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004eb8:	60a6                	ld	ra,72(sp)
    80004eba:	6406                	ld	s0,64(sp)
    80004ebc:	74e2                	ld	s1,56(sp)
    80004ebe:	7942                	ld	s2,48(sp)
    80004ec0:	79a2                	ld	s3,40(sp)
    80004ec2:	7a02                	ld	s4,32(sp)
    80004ec4:	6ae2                	ld	s5,24(sp)
    80004ec6:	6b42                	ld	s6,16(sp)
    80004ec8:	6ba2                	ld	s7,8(sp)
    80004eca:	6c02                	ld	s8,0(sp)
    80004ecc:	6161                	addi	sp,sp,80
    80004ece:	8082                	ret
        panic("short filewrite");
    80004ed0:	00003517          	auipc	a0,0x3
    80004ed4:	8e850513          	addi	a0,a0,-1816 # 800077b8 <userret+0x728>
    80004ed8:	ffffb097          	auipc	ra,0xffffb
    80004edc:	676080e7          	jalr	1654(ra) # 8000054e <panic>
    int i = 0;
    80004ee0:	4981                	li	s3,0
    80004ee2:	bfc1                	j	80004eb2 <filewrite+0x108>
    ret = (i == n ? n : -1);
    80004ee4:	557d                	li	a0,-1
    80004ee6:	bfc9                	j	80004eb8 <filewrite+0x10e>
    panic("filewrite");
    80004ee8:	00003517          	auipc	a0,0x3
    80004eec:	8e050513          	addi	a0,a0,-1824 # 800077c8 <userret+0x738>
    80004ef0:	ffffb097          	auipc	ra,0xffffb
    80004ef4:	65e080e7          	jalr	1630(ra) # 8000054e <panic>
    return -1;
    80004ef8:	557d                	li	a0,-1
}
    80004efa:	8082                	ret
      return -1;
    80004efc:	557d                	li	a0,-1
    80004efe:	bf6d                	j	80004eb8 <filewrite+0x10e>
    80004f00:	557d                	li	a0,-1
    80004f02:	bf5d                	j	80004eb8 <filewrite+0x10e>

0000000080004f04 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004f04:	7179                	addi	sp,sp,-48
    80004f06:	f406                	sd	ra,40(sp)
    80004f08:	f022                	sd	s0,32(sp)
    80004f0a:	ec26                	sd	s1,24(sp)
    80004f0c:	e84a                	sd	s2,16(sp)
    80004f0e:	e44e                	sd	s3,8(sp)
    80004f10:	e052                	sd	s4,0(sp)
    80004f12:	1800                	addi	s0,sp,48
    80004f14:	84aa                	mv	s1,a0
    80004f16:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004f18:	0005b023          	sd	zero,0(a1)
    80004f1c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004f20:	00000097          	auipc	ra,0x0
    80004f24:	bd2080e7          	jalr	-1070(ra) # 80004af2 <filealloc>
    80004f28:	e088                	sd	a0,0(s1)
    80004f2a:	c551                	beqz	a0,80004fb6 <pipealloc+0xb2>
    80004f2c:	00000097          	auipc	ra,0x0
    80004f30:	bc6080e7          	jalr	-1082(ra) # 80004af2 <filealloc>
    80004f34:	00aa3023          	sd	a0,0(s4)
    80004f38:	c92d                	beqz	a0,80004faa <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004f3a:	ffffc097          	auipc	ra,0xffffc
    80004f3e:	a26080e7          	jalr	-1498(ra) # 80000960 <kalloc>
    80004f42:	892a                	mv	s2,a0
    80004f44:	c125                	beqz	a0,80004fa4 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004f46:	4985                	li	s3,1
    80004f48:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004f4c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004f50:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004f54:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004f58:	00003597          	auipc	a1,0x3
    80004f5c:	88058593          	addi	a1,a1,-1920 # 800077d8 <userret+0x748>
    80004f60:	ffffc097          	auipc	ra,0xffffc
    80004f64:	a60080e7          	jalr	-1440(ra) # 800009c0 <initlock>
  (*f0)->type = FD_PIPE;
    80004f68:	609c                	ld	a5,0(s1)
    80004f6a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004f6e:	609c                	ld	a5,0(s1)
    80004f70:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004f74:	609c                	ld	a5,0(s1)
    80004f76:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004f7a:	609c                	ld	a5,0(s1)
    80004f7c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004f80:	000a3783          	ld	a5,0(s4)
    80004f84:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004f88:	000a3783          	ld	a5,0(s4)
    80004f8c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004f90:	000a3783          	ld	a5,0(s4)
    80004f94:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004f98:	000a3783          	ld	a5,0(s4)
    80004f9c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004fa0:	4501                	li	a0,0
    80004fa2:	a025                	j	80004fca <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004fa4:	6088                	ld	a0,0(s1)
    80004fa6:	e501                	bnez	a0,80004fae <pipealloc+0xaa>
    80004fa8:	a039                	j	80004fb6 <pipealloc+0xb2>
    80004faa:	6088                	ld	a0,0(s1)
    80004fac:	c51d                	beqz	a0,80004fda <pipealloc+0xd6>
    fileclose(*f0);
    80004fae:	00000097          	auipc	ra,0x0
    80004fb2:	c00080e7          	jalr	-1024(ra) # 80004bae <fileclose>
  if(*f1)
    80004fb6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004fba:	557d                	li	a0,-1
  if(*f1)
    80004fbc:	c799                	beqz	a5,80004fca <pipealloc+0xc6>
    fileclose(*f1);
    80004fbe:	853e                	mv	a0,a5
    80004fc0:	00000097          	auipc	ra,0x0
    80004fc4:	bee080e7          	jalr	-1042(ra) # 80004bae <fileclose>
  return -1;
    80004fc8:	557d                	li	a0,-1
}
    80004fca:	70a2                	ld	ra,40(sp)
    80004fcc:	7402                	ld	s0,32(sp)
    80004fce:	64e2                	ld	s1,24(sp)
    80004fd0:	6942                	ld	s2,16(sp)
    80004fd2:	69a2                	ld	s3,8(sp)
    80004fd4:	6a02                	ld	s4,0(sp)
    80004fd6:	6145                	addi	sp,sp,48
    80004fd8:	8082                	ret
  return -1;
    80004fda:	557d                	li	a0,-1
    80004fdc:	b7fd                	j	80004fca <pipealloc+0xc6>

0000000080004fde <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004fde:	1101                	addi	sp,sp,-32
    80004fe0:	ec06                	sd	ra,24(sp)
    80004fe2:	e822                	sd	s0,16(sp)
    80004fe4:	e426                	sd	s1,8(sp)
    80004fe6:	e04a                	sd	s2,0(sp)
    80004fe8:	1000                	addi	s0,sp,32
    80004fea:	84aa                	mv	s1,a0
    80004fec:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004fee:	ffffc097          	auipc	ra,0xffffc
    80004ff2:	ae4080e7          	jalr	-1308(ra) # 80000ad2 <acquire>
  if(writable){
    80004ff6:	02090d63          	beqz	s2,80005030 <pipeclose+0x52>
    pi->writeopen = 0;
    80004ffa:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004ffe:	21848513          	addi	a0,s1,536
    80005002:	ffffe097          	auipc	ra,0xffffe
    80005006:	a32080e7          	jalr	-1486(ra) # 80002a34 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000500a:	2204b783          	ld	a5,544(s1)
    8000500e:	eb95                	bnez	a5,80005042 <pipeclose+0x64>
    release(&pi->lock);
    80005010:	8526                	mv	a0,s1
    80005012:	ffffc097          	auipc	ra,0xffffc
    80005016:	b14080e7          	jalr	-1260(ra) # 80000b26 <release>
    kfree((char*)pi);
    8000501a:	8526                	mv	a0,s1
    8000501c:	ffffc097          	auipc	ra,0xffffc
    80005020:	848080e7          	jalr	-1976(ra) # 80000864 <kfree>
  } else
    release(&pi->lock);
}
    80005024:	60e2                	ld	ra,24(sp)
    80005026:	6442                	ld	s0,16(sp)
    80005028:	64a2                	ld	s1,8(sp)
    8000502a:	6902                	ld	s2,0(sp)
    8000502c:	6105                	addi	sp,sp,32
    8000502e:	8082                	ret
    pi->readopen = 0;
    80005030:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005034:	21c48513          	addi	a0,s1,540
    80005038:	ffffe097          	auipc	ra,0xffffe
    8000503c:	9fc080e7          	jalr	-1540(ra) # 80002a34 <wakeup>
    80005040:	b7e9                	j	8000500a <pipeclose+0x2c>
    release(&pi->lock);
    80005042:	8526                	mv	a0,s1
    80005044:	ffffc097          	auipc	ra,0xffffc
    80005048:	ae2080e7          	jalr	-1310(ra) # 80000b26 <release>
}
    8000504c:	bfe1                	j	80005024 <pipeclose+0x46>

000000008000504e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000504e:	7159                	addi	sp,sp,-112
    80005050:	f486                	sd	ra,104(sp)
    80005052:	f0a2                	sd	s0,96(sp)
    80005054:	eca6                	sd	s1,88(sp)
    80005056:	e8ca                	sd	s2,80(sp)
    80005058:	e4ce                	sd	s3,72(sp)
    8000505a:	e0d2                	sd	s4,64(sp)
    8000505c:	fc56                	sd	s5,56(sp)
    8000505e:	f85a                	sd	s6,48(sp)
    80005060:	f45e                	sd	s7,40(sp)
    80005062:	f062                	sd	s8,32(sp)
    80005064:	ec66                	sd	s9,24(sp)
    80005066:	1880                	addi	s0,sp,112
    80005068:	84aa                	mv	s1,a0
    8000506a:	8b2e                	mv	s6,a1
    8000506c:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    8000506e:	ffffd097          	auipc	ra,0xffffd
    80005072:	a94080e7          	jalr	-1388(ra) # 80001b02 <myproc>
    80005076:	8c2a                	mv	s8,a0

  acquire(&pi->lock);
    80005078:	8526                	mv	a0,s1
    8000507a:	ffffc097          	auipc	ra,0xffffc
    8000507e:	a58080e7          	jalr	-1448(ra) # 80000ad2 <acquire>
  for(i = 0; i < n; i++){
    80005082:	0b505063          	blez	s5,80005122 <pipewrite+0xd4>
    80005086:	8926                	mv	s2,s1
    80005088:	fffa8b9b          	addiw	s7,s5,-1
    8000508c:	1b82                	slli	s7,s7,0x20
    8000508e:	020bdb93          	srli	s7,s7,0x20
    80005092:	001b0793          	addi	a5,s6,1
    80005096:	9bbe                	add	s7,s7,a5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80005098:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000509c:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800050a0:	5cfd                	li	s9,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    800050a2:	2184a783          	lw	a5,536(s1)
    800050a6:	21c4a703          	lw	a4,540(s1)
    800050aa:	2007879b          	addiw	a5,a5,512
    800050ae:	02f71e63          	bne	a4,a5,800050ea <pipewrite+0x9c>
      if(pi->readopen == 0 || myproc()->killed){
    800050b2:	2204a783          	lw	a5,544(s1)
    800050b6:	c3d9                	beqz	a5,8000513c <pipewrite+0xee>
    800050b8:	ffffd097          	auipc	ra,0xffffd
    800050bc:	a4a080e7          	jalr	-1462(ra) # 80001b02 <myproc>
    800050c0:	591c                	lw	a5,48(a0)
    800050c2:	efad                	bnez	a5,8000513c <pipewrite+0xee>
      wakeup(&pi->nread);
    800050c4:	8552                	mv	a0,s4
    800050c6:	ffffe097          	auipc	ra,0xffffe
    800050ca:	96e080e7          	jalr	-1682(ra) # 80002a34 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800050ce:	85ca                	mv	a1,s2
    800050d0:	854e                	mv	a0,s3
    800050d2:	ffffd097          	auipc	ra,0xffffd
    800050d6:	698080e7          	jalr	1688(ra) # 8000276a <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    800050da:	2184a783          	lw	a5,536(s1)
    800050de:	21c4a703          	lw	a4,540(s1)
    800050e2:	2007879b          	addiw	a5,a5,512
    800050e6:	fcf706e3          	beq	a4,a5,800050b2 <pipewrite+0x64>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800050ea:	4685                	li	a3,1
    800050ec:	865a                	mv	a2,s6
    800050ee:	f9f40593          	addi	a1,s0,-97
    800050f2:	060c3503          	ld	a0,96(s8)
    800050f6:	ffffc097          	auipc	ra,0xffffc
    800050fa:	512080e7          	jalr	1298(ra) # 80001608 <copyin>
    800050fe:	03950263          	beq	a0,s9,80005122 <pipewrite+0xd4>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005102:	21c4a783          	lw	a5,540(s1)
    80005106:	0017871b          	addiw	a4,a5,1
    8000510a:	20e4ae23          	sw	a4,540(s1)
    8000510e:	1ff7f793          	andi	a5,a5,511
    80005112:	97a6                	add	a5,a5,s1
    80005114:	f9f44703          	lbu	a4,-97(s0)
    80005118:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    8000511c:	0b05                	addi	s6,s6,1
    8000511e:	f97b12e3          	bne	s6,s7,800050a2 <pipewrite+0x54>
  }
  wakeup(&pi->nread);
    80005122:	21848513          	addi	a0,s1,536
    80005126:	ffffe097          	auipc	ra,0xffffe
    8000512a:	90e080e7          	jalr	-1778(ra) # 80002a34 <wakeup>
  release(&pi->lock);
    8000512e:	8526                	mv	a0,s1
    80005130:	ffffc097          	auipc	ra,0xffffc
    80005134:	9f6080e7          	jalr	-1546(ra) # 80000b26 <release>
  return n;
    80005138:	8556                	mv	a0,s5
    8000513a:	a039                	j	80005148 <pipewrite+0xfa>
        release(&pi->lock);
    8000513c:	8526                	mv	a0,s1
    8000513e:	ffffc097          	auipc	ra,0xffffc
    80005142:	9e8080e7          	jalr	-1560(ra) # 80000b26 <release>
        return -1;
    80005146:	557d                	li	a0,-1
}
    80005148:	70a6                	ld	ra,104(sp)
    8000514a:	7406                	ld	s0,96(sp)
    8000514c:	64e6                	ld	s1,88(sp)
    8000514e:	6946                	ld	s2,80(sp)
    80005150:	69a6                	ld	s3,72(sp)
    80005152:	6a06                	ld	s4,64(sp)
    80005154:	7ae2                	ld	s5,56(sp)
    80005156:	7b42                	ld	s6,48(sp)
    80005158:	7ba2                	ld	s7,40(sp)
    8000515a:	7c02                	ld	s8,32(sp)
    8000515c:	6ce2                	ld	s9,24(sp)
    8000515e:	6165                	addi	sp,sp,112
    80005160:	8082                	ret

0000000080005162 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005162:	715d                	addi	sp,sp,-80
    80005164:	e486                	sd	ra,72(sp)
    80005166:	e0a2                	sd	s0,64(sp)
    80005168:	fc26                	sd	s1,56(sp)
    8000516a:	f84a                	sd	s2,48(sp)
    8000516c:	f44e                	sd	s3,40(sp)
    8000516e:	f052                	sd	s4,32(sp)
    80005170:	ec56                	sd	s5,24(sp)
    80005172:	e85a                	sd	s6,16(sp)
    80005174:	0880                	addi	s0,sp,80
    80005176:	84aa                	mv	s1,a0
    80005178:	892e                	mv	s2,a1
    8000517a:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    8000517c:	ffffd097          	auipc	ra,0xffffd
    80005180:	986080e7          	jalr	-1658(ra) # 80001b02 <myproc>
    80005184:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80005186:	8b26                	mv	s6,s1
    80005188:	8526                	mv	a0,s1
    8000518a:	ffffc097          	auipc	ra,0xffffc
    8000518e:	948080e7          	jalr	-1720(ra) # 80000ad2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005192:	2184a703          	lw	a4,536(s1)
    80005196:	21c4a783          	lw	a5,540(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000519a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000519e:	02f71763          	bne	a4,a5,800051cc <piperead+0x6a>
    800051a2:	2244a783          	lw	a5,548(s1)
    800051a6:	c39d                	beqz	a5,800051cc <piperead+0x6a>
    if(myproc()->killed){
    800051a8:	ffffd097          	auipc	ra,0xffffd
    800051ac:	95a080e7          	jalr	-1702(ra) # 80001b02 <myproc>
    800051b0:	591c                	lw	a5,48(a0)
    800051b2:	ebc1                	bnez	a5,80005242 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800051b4:	85da                	mv	a1,s6
    800051b6:	854e                	mv	a0,s3
    800051b8:	ffffd097          	auipc	ra,0xffffd
    800051bc:	5b2080e7          	jalr	1458(ra) # 8000276a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051c0:	2184a703          	lw	a4,536(s1)
    800051c4:	21c4a783          	lw	a5,540(s1)
    800051c8:	fcf70de3          	beq	a4,a5,800051a2 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051cc:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051ce:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051d0:	05405363          	blez	s4,80005216 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800051d4:	2184a783          	lw	a5,536(s1)
    800051d8:	21c4a703          	lw	a4,540(s1)
    800051dc:	02f70d63          	beq	a4,a5,80005216 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800051e0:	0017871b          	addiw	a4,a5,1
    800051e4:	20e4ac23          	sw	a4,536(s1)
    800051e8:	1ff7f793          	andi	a5,a5,511
    800051ec:	97a6                	add	a5,a5,s1
    800051ee:	0187c783          	lbu	a5,24(a5)
    800051f2:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051f6:	4685                	li	a3,1
    800051f8:	fbf40613          	addi	a2,s0,-65
    800051fc:	85ca                	mv	a1,s2
    800051fe:	060ab503          	ld	a0,96(s5)
    80005202:	ffffc097          	auipc	ra,0xffffc
    80005206:	37a080e7          	jalr	890(ra) # 8000157c <copyout>
    8000520a:	01650663          	beq	a0,s6,80005216 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000520e:	2985                	addiw	s3,s3,1
    80005210:	0905                	addi	s2,s2,1
    80005212:	fd3a11e3          	bne	s4,s3,800051d4 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005216:	21c48513          	addi	a0,s1,540
    8000521a:	ffffe097          	auipc	ra,0xffffe
    8000521e:	81a080e7          	jalr	-2022(ra) # 80002a34 <wakeup>
  release(&pi->lock);
    80005222:	8526                	mv	a0,s1
    80005224:	ffffc097          	auipc	ra,0xffffc
    80005228:	902080e7          	jalr	-1790(ra) # 80000b26 <release>
  return i;
}
    8000522c:	854e                	mv	a0,s3
    8000522e:	60a6                	ld	ra,72(sp)
    80005230:	6406                	ld	s0,64(sp)
    80005232:	74e2                	ld	s1,56(sp)
    80005234:	7942                	ld	s2,48(sp)
    80005236:	79a2                	ld	s3,40(sp)
    80005238:	7a02                	ld	s4,32(sp)
    8000523a:	6ae2                	ld	s5,24(sp)
    8000523c:	6b42                	ld	s6,16(sp)
    8000523e:	6161                	addi	sp,sp,80
    80005240:	8082                	ret
      release(&pi->lock);
    80005242:	8526                	mv	a0,s1
    80005244:	ffffc097          	auipc	ra,0xffffc
    80005248:	8e2080e7          	jalr	-1822(ra) # 80000b26 <release>
      return -1;
    8000524c:	59fd                	li	s3,-1
    8000524e:	bff9                	j	8000522c <piperead+0xca>

0000000080005250 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80005250:	de010113          	addi	sp,sp,-544
    80005254:	20113c23          	sd	ra,536(sp)
    80005258:	20813823          	sd	s0,528(sp)
    8000525c:	20913423          	sd	s1,520(sp)
    80005260:	21213023          	sd	s2,512(sp)
    80005264:	ffce                	sd	s3,504(sp)
    80005266:	fbd2                	sd	s4,496(sp)
    80005268:	f7d6                	sd	s5,488(sp)
    8000526a:	f3da                	sd	s6,480(sp)
    8000526c:	efde                	sd	s7,472(sp)
    8000526e:	ebe2                	sd	s8,464(sp)
    80005270:	e7e6                	sd	s9,456(sp)
    80005272:	e3ea                	sd	s10,448(sp)
    80005274:	ff6e                	sd	s11,440(sp)
    80005276:	1400                	addi	s0,sp,544
    80005278:	84aa                	mv	s1,a0
    8000527a:	dea43823          	sd	a0,-528(s0)
    8000527e:	deb43c23          	sd	a1,-520(s0)
  uint64 argc, sz, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005282:	ffffd097          	auipc	ra,0xffffd
    80005286:	880080e7          	jalr	-1920(ra) # 80001b02 <myproc>
    8000528a:	e0a43023          	sd	a0,-512(s0)
  //printf("process name:%s\n", p->name); //p3
  begin_op();
    8000528e:	fffff097          	auipc	ra,0xfffff
    80005292:	44e080e7          	jalr	1102(ra) # 800046dc <begin_op>

  if((ip = namei(path)) == 0){
    80005296:	8526                	mv	a0,s1
    80005298:	fffff097          	auipc	ra,0xfffff
    8000529c:	238080e7          	jalr	568(ra) # 800044d0 <namei>
    800052a0:	c93d                	beqz	a0,80005316 <exec+0xc6>
    800052a2:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800052a4:	fffff097          	auipc	ra,0xfffff
    800052a8:	aa2080e7          	jalr	-1374(ra) # 80003d46 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf)) //readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
    800052ac:	04000713          	li	a4,64
    800052b0:	4681                	li	a3,0
    800052b2:	e4840613          	addi	a2,s0,-440
    800052b6:	4581                	li	a1,0
    800052b8:	8526                	mv	a0,s1
    800052ba:	fffff097          	auipc	ra,0xfffff
    800052be:	d1c080e7          	jalr	-740(ra) # 80003fd6 <readi>
    800052c2:	04000793          	li	a5,64
    800052c6:	00f51a63          	bne	a0,a5,800052da <exec+0x8a>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800052ca:	e4842703          	lw	a4,-440(s0)
    800052ce:	464c47b7          	lui	a5,0x464c4
    800052d2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800052d6:	04f70663          	beq	a4,a5,80005322 <exec+0xd2>
  if(pagetable){
    //printf("proc_freepagetable wrong here c\n");
    proc_freepagetable(pagetable, sz, p); //p4 add the p argument
  }
  if(ip){
    iunlockput(ip);
    800052da:	8526                	mv	a0,s1
    800052dc:	fffff097          	auipc	ra,0xfffff
    800052e0:	ca8080e7          	jalr	-856(ra) # 80003f84 <iunlockput>
    end_op();
    800052e4:	fffff097          	auipc	ra,0xfffff
    800052e8:	478080e7          	jalr	1144(ra) # 8000475c <end_op>
  }
  return -1;
    800052ec:	557d                	li	a0,-1
}
    800052ee:	21813083          	ld	ra,536(sp)
    800052f2:	21013403          	ld	s0,528(sp)
    800052f6:	20813483          	ld	s1,520(sp)
    800052fa:	20013903          	ld	s2,512(sp)
    800052fe:	79fe                	ld	s3,504(sp)
    80005300:	7a5e                	ld	s4,496(sp)
    80005302:	7abe                	ld	s5,488(sp)
    80005304:	7b1e                	ld	s6,480(sp)
    80005306:	6bfe                	ld	s7,472(sp)
    80005308:	6c5e                	ld	s8,464(sp)
    8000530a:	6cbe                	ld	s9,456(sp)
    8000530c:	6d1e                	ld	s10,448(sp)
    8000530e:	7dfa                	ld	s11,440(sp)
    80005310:	22010113          	addi	sp,sp,544
    80005314:	8082                	ret
    end_op();
    80005316:	fffff097          	auipc	ra,0xfffff
    8000531a:	446080e7          	jalr	1094(ra) # 8000475c <end_op>
    return -1;
    8000531e:	557d                	li	a0,-1
    80005320:	b7f9                	j	800052ee <exec+0x9e>
  if((pagetable = proc_pagetable(p)) == 0) //create a new empty pagetable only trapline and frame in it 
    80005322:	e0043503          	ld	a0,-512(s0)
    80005326:	ffffd097          	auipc	ra,0xffffd
    8000532a:	8a0080e7          	jalr	-1888(ra) # 80001bc6 <proc_pagetable>
    8000532e:	8c2a                	mv	s8,a0
    80005330:	d54d                	beqz	a0,800052da <exec+0x8a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005332:	e6842983          	lw	s3,-408(s0)
    80005336:	e8045783          	lhu	a5,-384(s0)
    8000533a:	cbe5                	beqz	a5,8000542a <exec+0x1da>
  sz = PGSIZE;//0; //PAGSIZE p3
    8000533c:	6785                	lui	a5,0x1
    8000533e:	e0f43423          	sd	a5,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005342:	4b81                	li	s7,0
    if(ph.vaddr % PGSIZE != 0)
    80005344:	6b05                	lui	s6,0x1
    80005346:	fffb0793          	addi	a5,s6,-1 # fff <_entry-0x7ffff001>
    8000534a:	def43423          	sd	a5,-536(s0)
    8000534e:	a0a5                	j	800053b6 <exec+0x166>
  for(i = 0; i < sz; i += PGSIZE){
    //printf("va: %p\n",va);
    pa = walkaddr(pagetable, va + i);
    //printf("pa: %p\n",pa);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005350:	00002517          	auipc	a0,0x2
    80005354:	49050513          	addi	a0,a0,1168 # 800077e0 <userret+0x750>
    80005358:	ffffb097          	auipc	ra,0xffffb
    8000535c:	1f6080e7          	jalr	502(ra) # 8000054e <panic>
    if(sz - i < PGSIZE) //last page, cannot fill a full page
      n = sz - i;
    else
      n = PGSIZE; //full page
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n) //readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
    80005360:	8756                	mv	a4,s5
    80005362:	012d86bb          	addw	a3,s11,s2
    80005366:	4581                	li	a1,0
    80005368:	8526                	mv	a0,s1
    8000536a:	fffff097          	auipc	ra,0xfffff
    8000536e:	c6c080e7          	jalr	-916(ra) # 80003fd6 <readi>
    80005372:	2501                	sext.w	a0,a0
    80005374:	10aa9363          	bne	s5,a0,8000547a <exec+0x22a>
  for(i = 0; i < sz; i += PGSIZE){
    80005378:	6785                	lui	a5,0x1
    8000537a:	0127893b          	addw	s2,a5,s2
    8000537e:	77fd                	lui	a5,0xfffff
    80005380:	01478a3b          	addw	s4,a5,s4
    80005384:	03997263          	bgeu	s2,s9,800053a8 <exec+0x158>
    pa = walkaddr(pagetable, va + i);
    80005388:	02091593          	slli	a1,s2,0x20
    8000538c:	9181                	srli	a1,a1,0x20
    8000538e:	95ea                	add	a1,a1,s10
    80005390:	8562                	mv	a0,s8
    80005392:	ffffc097          	auipc	ra,0xffffc
    80005396:	c1c080e7          	jalr	-996(ra) # 80000fae <walkaddr>
    8000539a:	862a                	mv	a2,a0
    if(pa == 0)
    8000539c:	d955                	beqz	a0,80005350 <exec+0x100>
      n = PGSIZE; //full page
    8000539e:	8ada                	mv	s5,s6
    if(sz - i < PGSIZE) //last page, cannot fill a full page
    800053a0:	fd6a70e3          	bgeu	s4,s6,80005360 <exec+0x110>
      n = sz - i;
    800053a4:	8ad2                	mv	s5,s4
    800053a6:	bf6d                	j	80005360 <exec+0x110>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800053a8:	2b85                	addiw	s7,s7,1
    800053aa:	0389899b          	addiw	s3,s3,56
    800053ae:	e8045783          	lhu	a5,-384(s0)
    800053b2:	06fbdf63          	bge	s7,a5,80005430 <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph)) //readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
    800053b6:	2981                	sext.w	s3,s3
    800053b8:	03800713          	li	a4,56
    800053bc:	86ce                	mv	a3,s3
    800053be:	e1040613          	addi	a2,s0,-496
    800053c2:	4581                	li	a1,0
    800053c4:	8526                	mv	a0,s1
    800053c6:	fffff097          	auipc	ra,0xfffff
    800053ca:	c10080e7          	jalr	-1008(ra) # 80003fd6 <readi>
    800053ce:	03800793          	li	a5,56
    800053d2:	0af51463          	bne	a0,a5,8000547a <exec+0x22a>
    if(ph.type != ELF_PROG_LOAD)
    800053d6:	e1042783          	lw	a5,-496(s0)
    800053da:	4705                	li	a4,1
    800053dc:	fce796e3          	bne	a5,a4,800053a8 <exec+0x158>
    if(ph.memsz < ph.filesz)
    800053e0:	e3843603          	ld	a2,-456(s0)
    800053e4:	e3043783          	ld	a5,-464(s0)
    800053e8:	08f66963          	bltu	a2,a5,8000547a <exec+0x22a>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800053ec:	e2043783          	ld	a5,-480(s0)
    800053f0:	963e                	add	a2,a2,a5
    800053f2:	08f66463          	bltu	a2,a5,8000547a <exec+0x22a>
    if((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0){// Allocate PTEs and physical memory to grow process from oldsz to newsz, which need not be page aligned.  Returns new size or 0 on error.
    800053f6:	e0843583          	ld	a1,-504(s0)
    800053fa:	8562                	mv	a0,s8
    800053fc:	ffffc097          	auipc	ra,0xffffc
    80005400:	f92080e7          	jalr	-110(ra) # 8000138e <uvmalloc>
    80005404:	e0a43423          	sd	a0,-504(s0)
    80005408:	c92d                	beqz	a0,8000547a <exec+0x22a>
    if(ph.vaddr % PGSIZE != 0)
    8000540a:	e2043d03          	ld	s10,-480(s0)
    8000540e:	de843783          	ld	a5,-536(s0)
    80005412:	00fd77b3          	and	a5,s10,a5
    80005416:	e3b5                	bnez	a5,8000547a <exec+0x22a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0){ //loadseg(pagetable, va, inode, offset, sz)
    80005418:	e1842d83          	lw	s11,-488(s0)
    8000541c:	e3042c83          	lw	s9,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005420:	f80c84e3          	beqz	s9,800053a8 <exec+0x158>
    80005424:	8a66                	mv	s4,s9
    80005426:	4901                	li	s2,0
    80005428:	b785                	j	80005388 <exec+0x138>
  sz = PGSIZE;//0; //PAGSIZE p3
    8000542a:	6785                	lui	a5,0x1
    8000542c:	e0f43423          	sd	a5,-504(s0)
  iunlockput(ip);
    80005430:	8526                	mv	a0,s1
    80005432:	fffff097          	auipc	ra,0xfffff
    80005436:	b52080e7          	jalr	-1198(ra) # 80003f84 <iunlockput>
  end_op();
    8000543a:	fffff097          	auipc	ra,0xfffff
    8000543e:	322080e7          	jalr	802(ra) # 8000475c <end_op>
  p = myproc();
    80005442:	ffffc097          	auipc	ra,0xffffc
    80005446:	6c0080e7          	jalr	1728(ra) # 80001b02 <myproc>
    8000544a:	e0a43023          	sd	a0,-512(s0)
  uint64 oldsz = p->sz;
    8000544e:	05853c83          	ld	s9,88(a0)
  sz = PGROUNDUP(sz);
    80005452:	6585                	lui	a1,0x1
    80005454:	15fd                	addi	a1,a1,-1
    80005456:	e0843783          	ld	a5,-504(s0)
    8000545a:	00b78b33          	add	s6,a5,a1
    8000545e:	75fd                	lui	a1,0xfffff
    80005460:	00bb75b3          	and	a1,s6,a1
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005464:	6609                	lui	a2,0x2
    80005466:	962e                	add	a2,a2,a1
    80005468:	8562                	mv	a0,s8
    8000546a:	ffffc097          	auipc	ra,0xffffc
    8000546e:	f24080e7          	jalr	-220(ra) # 8000138e <uvmalloc>
    80005472:	e0a43423          	sd	a0,-504(s0)
  ip = 0;
    80005476:	4481                	li	s1,0
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005478:	ed11                	bnez	a0,80005494 <exec+0x244>
    proc_freepagetable(pagetable, sz, p); //p4 add the p argument
    8000547a:	e0043603          	ld	a2,-512(s0)
    8000547e:	e0843583          	ld	a1,-504(s0)
    80005482:	8562                	mv	a0,s8
    80005484:	ffffd097          	auipc	ra,0xffffd
    80005488:	86c080e7          	jalr	-1940(ra) # 80001cf0 <proc_freepagetable>
  if(ip){
    8000548c:	e40497e3          	bnez	s1,800052da <exec+0x8a>
  return -1;
    80005490:	557d                	li	a0,-1
    80005492:	bdb1                	j	800052ee <exec+0x9e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005494:	75f9                	lui	a1,0xffffe
    80005496:	84aa                	mv	s1,a0
    80005498:	95aa                	add	a1,a1,a0
    8000549a:	8562                	mv	a0,s8
    8000549c:	ffffc097          	auipc	ra,0xffffc
    800054a0:	0ae080e7          	jalr	174(ra) # 8000154a <uvmclear>
  stackbase = sp - PGSIZE;
    800054a4:	7afd                	lui	s5,0xfffff
    800054a6:	9aa6                	add	s5,s5,s1
  for(argc = 0; argv[argc]; argc++) {
    800054a8:	df843783          	ld	a5,-520(s0)
    800054ac:	6388                	ld	a0,0(a5)
    800054ae:	c135                	beqz	a0,80005512 <exec+0x2c2>
    800054b0:	e8840993          	addi	s3,s0,-376
    800054b4:	f8840b93          	addi	s7,s0,-120
    800054b8:	4901                	li	s2,0
    sp -= strlen(argv[argc]) + 1;
    800054ba:	ffffc097          	auipc	ra,0xffffc
    800054be:	83c080e7          	jalr	-1988(ra) # 80000cf6 <strlen>
    800054c2:	2505                	addiw	a0,a0,1
    800054c4:	8c89                	sub	s1,s1,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800054c6:	98c1                	andi	s1,s1,-16
    if(sp < stackbase)
    800054c8:	0f54eb63          	bltu	s1,s5,800055be <exec+0x36e>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800054cc:	df843b03          	ld	s6,-520(s0)
    800054d0:	000b3a03          	ld	s4,0(s6)
    800054d4:	8552                	mv	a0,s4
    800054d6:	ffffc097          	auipc	ra,0xffffc
    800054da:	820080e7          	jalr	-2016(ra) # 80000cf6 <strlen>
    800054de:	0015069b          	addiw	a3,a0,1
    800054e2:	8652                	mv	a2,s4
    800054e4:	85a6                	mv	a1,s1
    800054e6:	8562                	mv	a0,s8
    800054e8:	ffffc097          	auipc	ra,0xffffc
    800054ec:	094080e7          	jalr	148(ra) # 8000157c <copyout>
    800054f0:	0c054963          	bltz	a0,800055c2 <exec+0x372>
    ustack[argc] = sp;
    800054f4:	0099b023          	sd	s1,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800054f8:	0905                	addi	s2,s2,1
    800054fa:	008b0793          	addi	a5,s6,8
    800054fe:	def43c23          	sd	a5,-520(s0)
    80005502:	008b3503          	ld	a0,8(s6)
    80005506:	c909                	beqz	a0,80005518 <exec+0x2c8>
    if(argc >= MAXARG)
    80005508:	09a1                	addi	s3,s3,8
    8000550a:	fb3b98e3          	bne	s7,s3,800054ba <exec+0x26a>
  ip = 0;
    8000550e:	4481                	li	s1,0
    80005510:	b7ad                	j	8000547a <exec+0x22a>
  sp = sz;
    80005512:	e0843483          	ld	s1,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005516:	4901                	li	s2,0
  ustack[argc] = 0;
    80005518:	00391793          	slli	a5,s2,0x3
    8000551c:	f9040713          	addi	a4,s0,-112
    80005520:	97ba                	add	a5,a5,a4
    80005522:	ee07bc23          	sd	zero,-264(a5) # ef8 <_entry-0x7ffff108>
  sp -= (argc+1) * sizeof(uint64);
    80005526:	00190693          	addi	a3,s2,1
    8000552a:	068e                	slli	a3,a3,0x3
    8000552c:	8c95                	sub	s1,s1,a3
  sp -= sp % 16;
    8000552e:	ff04f993          	andi	s3,s1,-16
  ip = 0;
    80005532:	4481                	li	s1,0
  if(sp < stackbase)
    80005534:	f559e3e3          	bltu	s3,s5,8000547a <exec+0x22a>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005538:	e8840613          	addi	a2,s0,-376
    8000553c:	85ce                	mv	a1,s3
    8000553e:	8562                	mv	a0,s8
    80005540:	ffffc097          	auipc	ra,0xffffc
    80005544:	03c080e7          	jalr	60(ra) # 8000157c <copyout>
    80005548:	06054f63          	bltz	a0,800055c6 <exec+0x376>
  p->tf->a1 = sp;
    8000554c:	e0043783          	ld	a5,-512(s0)
    80005550:	77bc                	ld	a5,104(a5)
    80005552:	0737bc23          	sd	s3,120(a5)
  for(last=s=path; *s; s++)
    80005556:	df043783          	ld	a5,-528(s0)
    8000555a:	0007c703          	lbu	a4,0(a5)
    8000555e:	cf11                	beqz	a4,8000557a <exec+0x32a>
    80005560:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005562:	02f00693          	li	a3,47
    80005566:	a029                	j	80005570 <exec+0x320>
  for(last=s=path; *s; s++)
    80005568:	0785                	addi	a5,a5,1
    8000556a:	fff7c703          	lbu	a4,-1(a5)
    8000556e:	c711                	beqz	a4,8000557a <exec+0x32a>
    if(*s == '/')
    80005570:	fed71ce3          	bne	a4,a3,80005568 <exec+0x318>
      last = s+1;
    80005574:	def43823          	sd	a5,-528(s0)
    80005578:	bfc5                	j	80005568 <exec+0x318>
  safestrcpy(p->name, last, sizeof(p->name));
    8000557a:	4641                	li	a2,16
    8000557c:	df043583          	ld	a1,-528(s0)
    80005580:	e0043483          	ld	s1,-512(s0)
    80005584:	16848513          	addi	a0,s1,360
    80005588:	ffffb097          	auipc	ra,0xffffb
    8000558c:	73c080e7          	jalr	1852(ra) # 80000cc4 <safestrcpy>
  oldpagetable = p->pagetable;
    80005590:	8626                	mv	a2,s1
    80005592:	70a8                	ld	a0,96(s1)
  p->pagetable = pagetable;
    80005594:	0784b023          	sd	s8,96(s1)
  p->sz = sz;
    80005598:	e0843703          	ld	a4,-504(s0)
    8000559c:	ecb8                	sd	a4,88(s1)
  p->tf->epc = elf.entry;  // initial program counter = main
    8000559e:	74bc                	ld	a5,104(s1)
    800055a0:	e6043703          	ld	a4,-416(s0)
    800055a4:	ef98                	sd	a4,24(a5)
  p->tf->sp = sp; // initial stack pointer
    800055a6:	74bc                	ld	a5,104(s1)
    800055a8:	0337b823          	sd	s3,48(a5)
  proc_freepagetable(oldpagetable, oldsz - PGSIZE,p); //p3 p4 add the p argument
    800055ac:	75fd                	lui	a1,0xfffff
    800055ae:	95e6                	add	a1,a1,s9
    800055b0:	ffffc097          	auipc	ra,0xffffc
    800055b4:	740080e7          	jalr	1856(ra) # 80001cf0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800055b8:	0009051b          	sext.w	a0,s2
    800055bc:	bb0d                	j	800052ee <exec+0x9e>
  ip = 0;
    800055be:	4481                	li	s1,0
    800055c0:	bd6d                	j	8000547a <exec+0x22a>
    800055c2:	4481                	li	s1,0
    800055c4:	bd5d                	j	8000547a <exec+0x22a>
    800055c6:	4481                	li	s1,0
    800055c8:	bd4d                	j	8000547a <exec+0x22a>

00000000800055ca <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800055ca:	7179                	addi	sp,sp,-48
    800055cc:	f406                	sd	ra,40(sp)
    800055ce:	f022                	sd	s0,32(sp)
    800055d0:	ec26                	sd	s1,24(sp)
    800055d2:	e84a                	sd	s2,16(sp)
    800055d4:	1800                	addi	s0,sp,48
    800055d6:	892e                	mv	s2,a1
    800055d8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800055da:	fdc40593          	addi	a1,s0,-36
    800055de:	ffffe097          	auipc	ra,0xffffe
    800055e2:	bd4080e7          	jalr	-1068(ra) # 800031b2 <argint>
    800055e6:	04054063          	bltz	a0,80005626 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800055ea:	fdc42703          	lw	a4,-36(s0)
    800055ee:	47bd                	li	a5,15
    800055f0:	02e7ed63          	bltu	a5,a4,8000562a <argfd+0x60>
    800055f4:	ffffc097          	auipc	ra,0xffffc
    800055f8:	50e080e7          	jalr	1294(ra) # 80001b02 <myproc>
    800055fc:	fdc42703          	lw	a4,-36(s0)
    80005600:	01c70793          	addi	a5,a4,28
    80005604:	078e                	slli	a5,a5,0x3
    80005606:	953e                	add	a0,a0,a5
    80005608:	611c                	ld	a5,0(a0)
    8000560a:	c395                	beqz	a5,8000562e <argfd+0x64>
    return -1;
  if(pfd)
    8000560c:	00090463          	beqz	s2,80005614 <argfd+0x4a>
    *pfd = fd;
    80005610:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005614:	4501                	li	a0,0
  if(pf)
    80005616:	c091                	beqz	s1,8000561a <argfd+0x50>
    *pf = f;
    80005618:	e09c                	sd	a5,0(s1)
}
    8000561a:	70a2                	ld	ra,40(sp)
    8000561c:	7402                	ld	s0,32(sp)
    8000561e:	64e2                	ld	s1,24(sp)
    80005620:	6942                	ld	s2,16(sp)
    80005622:	6145                	addi	sp,sp,48
    80005624:	8082                	ret
    return -1;
    80005626:	557d                	li	a0,-1
    80005628:	bfcd                	j	8000561a <argfd+0x50>
    return -1;
    8000562a:	557d                	li	a0,-1
    8000562c:	b7fd                	j	8000561a <argfd+0x50>
    8000562e:	557d                	li	a0,-1
    80005630:	b7ed                	j	8000561a <argfd+0x50>

0000000080005632 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005632:	1101                	addi	sp,sp,-32
    80005634:	ec06                	sd	ra,24(sp)
    80005636:	e822                	sd	s0,16(sp)
    80005638:	e426                	sd	s1,8(sp)
    8000563a:	1000                	addi	s0,sp,32
    8000563c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000563e:	ffffc097          	auipc	ra,0xffffc
    80005642:	4c4080e7          	jalr	1220(ra) # 80001b02 <myproc>
    80005646:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005648:	0e050793          	addi	a5,a0,224
    8000564c:	4501                	li	a0,0
    8000564e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005650:	6398                	ld	a4,0(a5)
    80005652:	cb19                	beqz	a4,80005668 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005654:	2505                	addiw	a0,a0,1
    80005656:	07a1                	addi	a5,a5,8
    80005658:	fed51ce3          	bne	a0,a3,80005650 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000565c:	557d                	li	a0,-1
}
    8000565e:	60e2                	ld	ra,24(sp)
    80005660:	6442                	ld	s0,16(sp)
    80005662:	64a2                	ld	s1,8(sp)
    80005664:	6105                	addi	sp,sp,32
    80005666:	8082                	ret
      p->ofile[fd] = f;
    80005668:	01c50793          	addi	a5,a0,28
    8000566c:	078e                	slli	a5,a5,0x3
    8000566e:	963e                	add	a2,a2,a5
    80005670:	e204                	sd	s1,0(a2)
      return fd;
    80005672:	b7f5                	j	8000565e <fdalloc+0x2c>

0000000080005674 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005674:	715d                	addi	sp,sp,-80
    80005676:	e486                	sd	ra,72(sp)
    80005678:	e0a2                	sd	s0,64(sp)
    8000567a:	fc26                	sd	s1,56(sp)
    8000567c:	f84a                	sd	s2,48(sp)
    8000567e:	f44e                	sd	s3,40(sp)
    80005680:	f052                	sd	s4,32(sp)
    80005682:	ec56                	sd	s5,24(sp)
    80005684:	0880                	addi	s0,sp,80
    80005686:	89ae                	mv	s3,a1
    80005688:	8ab2                	mv	s5,a2
    8000568a:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000568c:	fb040593          	addi	a1,s0,-80
    80005690:	fffff097          	auipc	ra,0xfffff
    80005694:	e5e080e7          	jalr	-418(ra) # 800044ee <nameiparent>
    80005698:	892a                	mv	s2,a0
    8000569a:	12050e63          	beqz	a0,800057d6 <create+0x162>
    return 0;

  ilock(dp);
    8000569e:	ffffe097          	auipc	ra,0xffffe
    800056a2:	6a8080e7          	jalr	1704(ra) # 80003d46 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800056a6:	4601                	li	a2,0
    800056a8:	fb040593          	addi	a1,s0,-80
    800056ac:	854a                	mv	a0,s2
    800056ae:	fffff097          	auipc	ra,0xfffff
    800056b2:	b50080e7          	jalr	-1200(ra) # 800041fe <dirlookup>
    800056b6:	84aa                	mv	s1,a0
    800056b8:	c921                	beqz	a0,80005708 <create+0x94>
    iunlockput(dp);
    800056ba:	854a                	mv	a0,s2
    800056bc:	fffff097          	auipc	ra,0xfffff
    800056c0:	8c8080e7          	jalr	-1848(ra) # 80003f84 <iunlockput>
    ilock(ip);
    800056c4:	8526                	mv	a0,s1
    800056c6:	ffffe097          	auipc	ra,0xffffe
    800056ca:	680080e7          	jalr	1664(ra) # 80003d46 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800056ce:	2981                	sext.w	s3,s3
    800056d0:	4789                	li	a5,2
    800056d2:	02f99463          	bne	s3,a5,800056fa <create+0x86>
    800056d6:	0444d783          	lhu	a5,68(s1)
    800056da:	37f9                	addiw	a5,a5,-2
    800056dc:	17c2                	slli	a5,a5,0x30
    800056de:	93c1                	srli	a5,a5,0x30
    800056e0:	4705                	li	a4,1
    800056e2:	00f76c63          	bltu	a4,a5,800056fa <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800056e6:	8526                	mv	a0,s1
    800056e8:	60a6                	ld	ra,72(sp)
    800056ea:	6406                	ld	s0,64(sp)
    800056ec:	74e2                	ld	s1,56(sp)
    800056ee:	7942                	ld	s2,48(sp)
    800056f0:	79a2                	ld	s3,40(sp)
    800056f2:	7a02                	ld	s4,32(sp)
    800056f4:	6ae2                	ld	s5,24(sp)
    800056f6:	6161                	addi	sp,sp,80
    800056f8:	8082                	ret
    iunlockput(ip);
    800056fa:	8526                	mv	a0,s1
    800056fc:	fffff097          	auipc	ra,0xfffff
    80005700:	888080e7          	jalr	-1912(ra) # 80003f84 <iunlockput>
    return 0;
    80005704:	4481                	li	s1,0
    80005706:	b7c5                	j	800056e6 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005708:	85ce                	mv	a1,s3
    8000570a:	00092503          	lw	a0,0(s2)
    8000570e:	ffffe097          	auipc	ra,0xffffe
    80005712:	4a0080e7          	jalr	1184(ra) # 80003bae <ialloc>
    80005716:	84aa                	mv	s1,a0
    80005718:	c521                	beqz	a0,80005760 <create+0xec>
  ilock(ip);
    8000571a:	ffffe097          	auipc	ra,0xffffe
    8000571e:	62c080e7          	jalr	1580(ra) # 80003d46 <ilock>
  ip->major = major;
    80005722:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005726:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000572a:	4a05                	li	s4,1
    8000572c:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005730:	8526                	mv	a0,s1
    80005732:	ffffe097          	auipc	ra,0xffffe
    80005736:	54a080e7          	jalr	1354(ra) # 80003c7c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000573a:	2981                	sext.w	s3,s3
    8000573c:	03498a63          	beq	s3,s4,80005770 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005740:	40d0                	lw	a2,4(s1)
    80005742:	fb040593          	addi	a1,s0,-80
    80005746:	854a                	mv	a0,s2
    80005748:	fffff097          	auipc	ra,0xfffff
    8000574c:	cc6080e7          	jalr	-826(ra) # 8000440e <dirlink>
    80005750:	06054b63          	bltz	a0,800057c6 <create+0x152>
  iunlockput(dp);
    80005754:	854a                	mv	a0,s2
    80005756:	fffff097          	auipc	ra,0xfffff
    8000575a:	82e080e7          	jalr	-2002(ra) # 80003f84 <iunlockput>
  return ip;
    8000575e:	b761                	j	800056e6 <create+0x72>
    panic("create: ialloc");
    80005760:	00002517          	auipc	a0,0x2
    80005764:	0a050513          	addi	a0,a0,160 # 80007800 <userret+0x770>
    80005768:	ffffb097          	auipc	ra,0xffffb
    8000576c:	de6080e7          	jalr	-538(ra) # 8000054e <panic>
    dp->nlink++;  // for ".."
    80005770:	04a95783          	lhu	a5,74(s2)
    80005774:	2785                	addiw	a5,a5,1
    80005776:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000577a:	854a                	mv	a0,s2
    8000577c:	ffffe097          	auipc	ra,0xffffe
    80005780:	500080e7          	jalr	1280(ra) # 80003c7c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005784:	40d0                	lw	a2,4(s1)
    80005786:	00002597          	auipc	a1,0x2
    8000578a:	08a58593          	addi	a1,a1,138 # 80007810 <userret+0x780>
    8000578e:	8526                	mv	a0,s1
    80005790:	fffff097          	auipc	ra,0xfffff
    80005794:	c7e080e7          	jalr	-898(ra) # 8000440e <dirlink>
    80005798:	00054f63          	bltz	a0,800057b6 <create+0x142>
    8000579c:	00492603          	lw	a2,4(s2)
    800057a0:	00002597          	auipc	a1,0x2
    800057a4:	07858593          	addi	a1,a1,120 # 80007818 <userret+0x788>
    800057a8:	8526                	mv	a0,s1
    800057aa:	fffff097          	auipc	ra,0xfffff
    800057ae:	c64080e7          	jalr	-924(ra) # 8000440e <dirlink>
    800057b2:	f80557e3          	bgez	a0,80005740 <create+0xcc>
      panic("create dots");
    800057b6:	00002517          	auipc	a0,0x2
    800057ba:	06a50513          	addi	a0,a0,106 # 80007820 <userret+0x790>
    800057be:	ffffb097          	auipc	ra,0xffffb
    800057c2:	d90080e7          	jalr	-624(ra) # 8000054e <panic>
    panic("create: dirlink");
    800057c6:	00002517          	auipc	a0,0x2
    800057ca:	06a50513          	addi	a0,a0,106 # 80007830 <userret+0x7a0>
    800057ce:	ffffb097          	auipc	ra,0xffffb
    800057d2:	d80080e7          	jalr	-640(ra) # 8000054e <panic>
    return 0;
    800057d6:	84aa                	mv	s1,a0
    800057d8:	b739                	j	800056e6 <create+0x72>

00000000800057da <sys_dup>:
{
    800057da:	7179                	addi	sp,sp,-48
    800057dc:	f406                	sd	ra,40(sp)
    800057de:	f022                	sd	s0,32(sp)
    800057e0:	ec26                	sd	s1,24(sp)
    800057e2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800057e4:	fd840613          	addi	a2,s0,-40
    800057e8:	4581                	li	a1,0
    800057ea:	4501                	li	a0,0
    800057ec:	00000097          	auipc	ra,0x0
    800057f0:	dde080e7          	jalr	-546(ra) # 800055ca <argfd>
    return -1;
    800057f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800057f6:	02054363          	bltz	a0,8000581c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800057fa:	fd843503          	ld	a0,-40(s0)
    800057fe:	00000097          	auipc	ra,0x0
    80005802:	e34080e7          	jalr	-460(ra) # 80005632 <fdalloc>
    80005806:	84aa                	mv	s1,a0
    return -1;
    80005808:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000580a:	00054963          	bltz	a0,8000581c <sys_dup+0x42>
  filedup(f);
    8000580e:	fd843503          	ld	a0,-40(s0)
    80005812:	fffff097          	auipc	ra,0xfffff
    80005816:	34a080e7          	jalr	842(ra) # 80004b5c <filedup>
  return fd;
    8000581a:	87a6                	mv	a5,s1
}
    8000581c:	853e                	mv	a0,a5
    8000581e:	70a2                	ld	ra,40(sp)
    80005820:	7402                	ld	s0,32(sp)
    80005822:	64e2                	ld	s1,24(sp)
    80005824:	6145                	addi	sp,sp,48
    80005826:	8082                	ret

0000000080005828 <sys_read>:
{
    80005828:	7179                	addi	sp,sp,-48
    8000582a:	f406                	sd	ra,40(sp)
    8000582c:	f022                	sd	s0,32(sp)
    8000582e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005830:	fe840613          	addi	a2,s0,-24
    80005834:	4581                	li	a1,0
    80005836:	4501                	li	a0,0
    80005838:	00000097          	auipc	ra,0x0
    8000583c:	d92080e7          	jalr	-622(ra) # 800055ca <argfd>
    return -1;
    80005840:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005842:	04054163          	bltz	a0,80005884 <sys_read+0x5c>
    80005846:	fe440593          	addi	a1,s0,-28
    8000584a:	4509                	li	a0,2
    8000584c:	ffffe097          	auipc	ra,0xffffe
    80005850:	966080e7          	jalr	-1690(ra) # 800031b2 <argint>
    return -1;
    80005854:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005856:	02054763          	bltz	a0,80005884 <sys_read+0x5c>
    8000585a:	fd840593          	addi	a1,s0,-40
    8000585e:	4505                	li	a0,1
    80005860:	ffffe097          	auipc	ra,0xffffe
    80005864:	974080e7          	jalr	-1676(ra) # 800031d4 <argaddr>
    return -1;
    80005868:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000586a:	00054d63          	bltz	a0,80005884 <sys_read+0x5c>
  return fileread(f, p, n);
    8000586e:	fe442603          	lw	a2,-28(s0)
    80005872:	fd843583          	ld	a1,-40(s0)
    80005876:	fe843503          	ld	a0,-24(s0)
    8000587a:	fffff097          	auipc	ra,0xfffff
    8000587e:	46e080e7          	jalr	1134(ra) # 80004ce8 <fileread>
    80005882:	87aa                	mv	a5,a0
}
    80005884:	853e                	mv	a0,a5
    80005886:	70a2                	ld	ra,40(sp)
    80005888:	7402                	ld	s0,32(sp)
    8000588a:	6145                	addi	sp,sp,48
    8000588c:	8082                	ret

000000008000588e <sys_write>:
{
    8000588e:	7179                	addi	sp,sp,-48
    80005890:	f406                	sd	ra,40(sp)
    80005892:	f022                	sd	s0,32(sp)
    80005894:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005896:	fe840613          	addi	a2,s0,-24
    8000589a:	4581                	li	a1,0
    8000589c:	4501                	li	a0,0
    8000589e:	00000097          	auipc	ra,0x0
    800058a2:	d2c080e7          	jalr	-724(ra) # 800055ca <argfd>
    return -1;
    800058a6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800058a8:	04054163          	bltz	a0,800058ea <sys_write+0x5c>
    800058ac:	fe440593          	addi	a1,s0,-28
    800058b0:	4509                	li	a0,2
    800058b2:	ffffe097          	auipc	ra,0xffffe
    800058b6:	900080e7          	jalr	-1792(ra) # 800031b2 <argint>
    return -1;
    800058ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800058bc:	02054763          	bltz	a0,800058ea <sys_write+0x5c>
    800058c0:	fd840593          	addi	a1,s0,-40
    800058c4:	4505                	li	a0,1
    800058c6:	ffffe097          	auipc	ra,0xffffe
    800058ca:	90e080e7          	jalr	-1778(ra) # 800031d4 <argaddr>
    return -1;
    800058ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800058d0:	00054d63          	bltz	a0,800058ea <sys_write+0x5c>
  return filewrite(f, p, n);
    800058d4:	fe442603          	lw	a2,-28(s0)
    800058d8:	fd843583          	ld	a1,-40(s0)
    800058dc:	fe843503          	ld	a0,-24(s0)
    800058e0:	fffff097          	auipc	ra,0xfffff
    800058e4:	4ca080e7          	jalr	1226(ra) # 80004daa <filewrite>
    800058e8:	87aa                	mv	a5,a0
}
    800058ea:	853e                	mv	a0,a5
    800058ec:	70a2                	ld	ra,40(sp)
    800058ee:	7402                	ld	s0,32(sp)
    800058f0:	6145                	addi	sp,sp,48
    800058f2:	8082                	ret

00000000800058f4 <sys_close>:
{
    800058f4:	1101                	addi	sp,sp,-32
    800058f6:	ec06                	sd	ra,24(sp)
    800058f8:	e822                	sd	s0,16(sp)
    800058fa:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800058fc:	fe040613          	addi	a2,s0,-32
    80005900:	fec40593          	addi	a1,s0,-20
    80005904:	4501                	li	a0,0
    80005906:	00000097          	auipc	ra,0x0
    8000590a:	cc4080e7          	jalr	-828(ra) # 800055ca <argfd>
    return -1;
    8000590e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005910:	02054463          	bltz	a0,80005938 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005914:	ffffc097          	auipc	ra,0xffffc
    80005918:	1ee080e7          	jalr	494(ra) # 80001b02 <myproc>
    8000591c:	fec42783          	lw	a5,-20(s0)
    80005920:	07f1                	addi	a5,a5,28
    80005922:	078e                	slli	a5,a5,0x3
    80005924:	97aa                	add	a5,a5,a0
    80005926:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000592a:	fe043503          	ld	a0,-32(s0)
    8000592e:	fffff097          	auipc	ra,0xfffff
    80005932:	280080e7          	jalr	640(ra) # 80004bae <fileclose>
  return 0;
    80005936:	4781                	li	a5,0
}
    80005938:	853e                	mv	a0,a5
    8000593a:	60e2                	ld	ra,24(sp)
    8000593c:	6442                	ld	s0,16(sp)
    8000593e:	6105                	addi	sp,sp,32
    80005940:	8082                	ret

0000000080005942 <sys_fstat>:
{
    80005942:	1101                	addi	sp,sp,-32
    80005944:	ec06                	sd	ra,24(sp)
    80005946:	e822                	sd	s0,16(sp)
    80005948:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000594a:	fe840613          	addi	a2,s0,-24
    8000594e:	4581                	li	a1,0
    80005950:	4501                	li	a0,0
    80005952:	00000097          	auipc	ra,0x0
    80005956:	c78080e7          	jalr	-904(ra) # 800055ca <argfd>
    return -1;
    8000595a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000595c:	02054563          	bltz	a0,80005986 <sys_fstat+0x44>
    80005960:	fe040593          	addi	a1,s0,-32
    80005964:	4505                	li	a0,1
    80005966:	ffffe097          	auipc	ra,0xffffe
    8000596a:	86e080e7          	jalr	-1938(ra) # 800031d4 <argaddr>
    return -1;
    8000596e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005970:	00054b63          	bltz	a0,80005986 <sys_fstat+0x44>
  return filestat(f, st);
    80005974:	fe043583          	ld	a1,-32(s0)
    80005978:	fe843503          	ld	a0,-24(s0)
    8000597c:	fffff097          	auipc	ra,0xfffff
    80005980:	2fa080e7          	jalr	762(ra) # 80004c76 <filestat>
    80005984:	87aa                	mv	a5,a0
}
    80005986:	853e                	mv	a0,a5
    80005988:	60e2                	ld	ra,24(sp)
    8000598a:	6442                	ld	s0,16(sp)
    8000598c:	6105                	addi	sp,sp,32
    8000598e:	8082                	ret

0000000080005990 <sys_link>:
{
    80005990:	7169                	addi	sp,sp,-304
    80005992:	f606                	sd	ra,296(sp)
    80005994:	f222                	sd	s0,288(sp)
    80005996:	ee26                	sd	s1,280(sp)
    80005998:	ea4a                	sd	s2,272(sp)
    8000599a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000599c:	08000613          	li	a2,128
    800059a0:	ed040593          	addi	a1,s0,-304
    800059a4:	4501                	li	a0,0
    800059a6:	ffffe097          	auipc	ra,0xffffe
    800059aa:	850080e7          	jalr	-1968(ra) # 800031f6 <argstr>
    return -1;
    800059ae:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800059b0:	10054e63          	bltz	a0,80005acc <sys_link+0x13c>
    800059b4:	08000613          	li	a2,128
    800059b8:	f5040593          	addi	a1,s0,-176
    800059bc:	4505                	li	a0,1
    800059be:	ffffe097          	auipc	ra,0xffffe
    800059c2:	838080e7          	jalr	-1992(ra) # 800031f6 <argstr>
    return -1;
    800059c6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800059c8:	10054263          	bltz	a0,80005acc <sys_link+0x13c>
  begin_op();
    800059cc:	fffff097          	auipc	ra,0xfffff
    800059d0:	d10080e7          	jalr	-752(ra) # 800046dc <begin_op>
  if((ip = namei(old)) == 0){
    800059d4:	ed040513          	addi	a0,s0,-304
    800059d8:	fffff097          	auipc	ra,0xfffff
    800059dc:	af8080e7          	jalr	-1288(ra) # 800044d0 <namei>
    800059e0:	84aa                	mv	s1,a0
    800059e2:	c551                	beqz	a0,80005a6e <sys_link+0xde>
  ilock(ip);
    800059e4:	ffffe097          	auipc	ra,0xffffe
    800059e8:	362080e7          	jalr	866(ra) # 80003d46 <ilock>
  if(ip->type == T_DIR){
    800059ec:	04449703          	lh	a4,68(s1)
    800059f0:	4785                	li	a5,1
    800059f2:	08f70463          	beq	a4,a5,80005a7a <sys_link+0xea>
  ip->nlink++;
    800059f6:	04a4d783          	lhu	a5,74(s1)
    800059fa:	2785                	addiw	a5,a5,1
    800059fc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a00:	8526                	mv	a0,s1
    80005a02:	ffffe097          	auipc	ra,0xffffe
    80005a06:	27a080e7          	jalr	634(ra) # 80003c7c <iupdate>
  iunlock(ip);
    80005a0a:	8526                	mv	a0,s1
    80005a0c:	ffffe097          	auipc	ra,0xffffe
    80005a10:	3fc080e7          	jalr	1020(ra) # 80003e08 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005a14:	fd040593          	addi	a1,s0,-48
    80005a18:	f5040513          	addi	a0,s0,-176
    80005a1c:	fffff097          	auipc	ra,0xfffff
    80005a20:	ad2080e7          	jalr	-1326(ra) # 800044ee <nameiparent>
    80005a24:	892a                	mv	s2,a0
    80005a26:	c935                	beqz	a0,80005a9a <sys_link+0x10a>
  ilock(dp);
    80005a28:	ffffe097          	auipc	ra,0xffffe
    80005a2c:	31e080e7          	jalr	798(ra) # 80003d46 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005a30:	00092703          	lw	a4,0(s2)
    80005a34:	409c                	lw	a5,0(s1)
    80005a36:	04f71d63          	bne	a4,a5,80005a90 <sys_link+0x100>
    80005a3a:	40d0                	lw	a2,4(s1)
    80005a3c:	fd040593          	addi	a1,s0,-48
    80005a40:	854a                	mv	a0,s2
    80005a42:	fffff097          	auipc	ra,0xfffff
    80005a46:	9cc080e7          	jalr	-1588(ra) # 8000440e <dirlink>
    80005a4a:	04054363          	bltz	a0,80005a90 <sys_link+0x100>
  iunlockput(dp);
    80005a4e:	854a                	mv	a0,s2
    80005a50:	ffffe097          	auipc	ra,0xffffe
    80005a54:	534080e7          	jalr	1332(ra) # 80003f84 <iunlockput>
  iput(ip);
    80005a58:	8526                	mv	a0,s1
    80005a5a:	ffffe097          	auipc	ra,0xffffe
    80005a5e:	3fa080e7          	jalr	1018(ra) # 80003e54 <iput>
  end_op();
    80005a62:	fffff097          	auipc	ra,0xfffff
    80005a66:	cfa080e7          	jalr	-774(ra) # 8000475c <end_op>
  return 0;
    80005a6a:	4781                	li	a5,0
    80005a6c:	a085                	j	80005acc <sys_link+0x13c>
    end_op();
    80005a6e:	fffff097          	auipc	ra,0xfffff
    80005a72:	cee080e7          	jalr	-786(ra) # 8000475c <end_op>
    return -1;
    80005a76:	57fd                	li	a5,-1
    80005a78:	a891                	j	80005acc <sys_link+0x13c>
    iunlockput(ip);
    80005a7a:	8526                	mv	a0,s1
    80005a7c:	ffffe097          	auipc	ra,0xffffe
    80005a80:	508080e7          	jalr	1288(ra) # 80003f84 <iunlockput>
    end_op();
    80005a84:	fffff097          	auipc	ra,0xfffff
    80005a88:	cd8080e7          	jalr	-808(ra) # 8000475c <end_op>
    return -1;
    80005a8c:	57fd                	li	a5,-1
    80005a8e:	a83d                	j	80005acc <sys_link+0x13c>
    iunlockput(dp);
    80005a90:	854a                	mv	a0,s2
    80005a92:	ffffe097          	auipc	ra,0xffffe
    80005a96:	4f2080e7          	jalr	1266(ra) # 80003f84 <iunlockput>
  ilock(ip);
    80005a9a:	8526                	mv	a0,s1
    80005a9c:	ffffe097          	auipc	ra,0xffffe
    80005aa0:	2aa080e7          	jalr	682(ra) # 80003d46 <ilock>
  ip->nlink--;
    80005aa4:	04a4d783          	lhu	a5,74(s1)
    80005aa8:	37fd                	addiw	a5,a5,-1
    80005aaa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005aae:	8526                	mv	a0,s1
    80005ab0:	ffffe097          	auipc	ra,0xffffe
    80005ab4:	1cc080e7          	jalr	460(ra) # 80003c7c <iupdate>
  iunlockput(ip);
    80005ab8:	8526                	mv	a0,s1
    80005aba:	ffffe097          	auipc	ra,0xffffe
    80005abe:	4ca080e7          	jalr	1226(ra) # 80003f84 <iunlockput>
  end_op();
    80005ac2:	fffff097          	auipc	ra,0xfffff
    80005ac6:	c9a080e7          	jalr	-870(ra) # 8000475c <end_op>
  return -1;
    80005aca:	57fd                	li	a5,-1
}
    80005acc:	853e                	mv	a0,a5
    80005ace:	70b2                	ld	ra,296(sp)
    80005ad0:	7412                	ld	s0,288(sp)
    80005ad2:	64f2                	ld	s1,280(sp)
    80005ad4:	6952                	ld	s2,272(sp)
    80005ad6:	6155                	addi	sp,sp,304
    80005ad8:	8082                	ret

0000000080005ada <sys_unlink>:
{
    80005ada:	7151                	addi	sp,sp,-240
    80005adc:	f586                	sd	ra,232(sp)
    80005ade:	f1a2                	sd	s0,224(sp)
    80005ae0:	eda6                	sd	s1,216(sp)
    80005ae2:	e9ca                	sd	s2,208(sp)
    80005ae4:	e5ce                	sd	s3,200(sp)
    80005ae6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005ae8:	08000613          	li	a2,128
    80005aec:	f3040593          	addi	a1,s0,-208
    80005af0:	4501                	li	a0,0
    80005af2:	ffffd097          	auipc	ra,0xffffd
    80005af6:	704080e7          	jalr	1796(ra) # 800031f6 <argstr>
    80005afa:	18054163          	bltz	a0,80005c7c <sys_unlink+0x1a2>
  begin_op();
    80005afe:	fffff097          	auipc	ra,0xfffff
    80005b02:	bde080e7          	jalr	-1058(ra) # 800046dc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005b06:	fb040593          	addi	a1,s0,-80
    80005b0a:	f3040513          	addi	a0,s0,-208
    80005b0e:	fffff097          	auipc	ra,0xfffff
    80005b12:	9e0080e7          	jalr	-1568(ra) # 800044ee <nameiparent>
    80005b16:	84aa                	mv	s1,a0
    80005b18:	c979                	beqz	a0,80005bee <sys_unlink+0x114>
  ilock(dp);
    80005b1a:	ffffe097          	auipc	ra,0xffffe
    80005b1e:	22c080e7          	jalr	556(ra) # 80003d46 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005b22:	00002597          	auipc	a1,0x2
    80005b26:	cee58593          	addi	a1,a1,-786 # 80007810 <userret+0x780>
    80005b2a:	fb040513          	addi	a0,s0,-80
    80005b2e:	ffffe097          	auipc	ra,0xffffe
    80005b32:	6b6080e7          	jalr	1718(ra) # 800041e4 <namecmp>
    80005b36:	14050a63          	beqz	a0,80005c8a <sys_unlink+0x1b0>
    80005b3a:	00002597          	auipc	a1,0x2
    80005b3e:	cde58593          	addi	a1,a1,-802 # 80007818 <userret+0x788>
    80005b42:	fb040513          	addi	a0,s0,-80
    80005b46:	ffffe097          	auipc	ra,0xffffe
    80005b4a:	69e080e7          	jalr	1694(ra) # 800041e4 <namecmp>
    80005b4e:	12050e63          	beqz	a0,80005c8a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005b52:	f2c40613          	addi	a2,s0,-212
    80005b56:	fb040593          	addi	a1,s0,-80
    80005b5a:	8526                	mv	a0,s1
    80005b5c:	ffffe097          	auipc	ra,0xffffe
    80005b60:	6a2080e7          	jalr	1698(ra) # 800041fe <dirlookup>
    80005b64:	892a                	mv	s2,a0
    80005b66:	12050263          	beqz	a0,80005c8a <sys_unlink+0x1b0>
  ilock(ip);
    80005b6a:	ffffe097          	auipc	ra,0xffffe
    80005b6e:	1dc080e7          	jalr	476(ra) # 80003d46 <ilock>
  if(ip->nlink < 1)
    80005b72:	04a91783          	lh	a5,74(s2)
    80005b76:	08f05263          	blez	a5,80005bfa <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005b7a:	04491703          	lh	a4,68(s2)
    80005b7e:	4785                	li	a5,1
    80005b80:	08f70563          	beq	a4,a5,80005c0a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005b84:	4641                	li	a2,16
    80005b86:	4581                	li	a1,0
    80005b88:	fc040513          	addi	a0,s0,-64
    80005b8c:	ffffb097          	auipc	ra,0xffffb
    80005b90:	fe2080e7          	jalr	-30(ra) # 80000b6e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b94:	4741                	li	a4,16
    80005b96:	f2c42683          	lw	a3,-212(s0)
    80005b9a:	fc040613          	addi	a2,s0,-64
    80005b9e:	4581                	li	a1,0
    80005ba0:	8526                	mv	a0,s1
    80005ba2:	ffffe097          	auipc	ra,0xffffe
    80005ba6:	528080e7          	jalr	1320(ra) # 800040ca <writei>
    80005baa:	47c1                	li	a5,16
    80005bac:	0af51563          	bne	a0,a5,80005c56 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005bb0:	04491703          	lh	a4,68(s2)
    80005bb4:	4785                	li	a5,1
    80005bb6:	0af70863          	beq	a4,a5,80005c66 <sys_unlink+0x18c>
  iunlockput(dp);
    80005bba:	8526                	mv	a0,s1
    80005bbc:	ffffe097          	auipc	ra,0xffffe
    80005bc0:	3c8080e7          	jalr	968(ra) # 80003f84 <iunlockput>
  ip->nlink--;
    80005bc4:	04a95783          	lhu	a5,74(s2)
    80005bc8:	37fd                	addiw	a5,a5,-1
    80005bca:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005bce:	854a                	mv	a0,s2
    80005bd0:	ffffe097          	auipc	ra,0xffffe
    80005bd4:	0ac080e7          	jalr	172(ra) # 80003c7c <iupdate>
  iunlockput(ip);
    80005bd8:	854a                	mv	a0,s2
    80005bda:	ffffe097          	auipc	ra,0xffffe
    80005bde:	3aa080e7          	jalr	938(ra) # 80003f84 <iunlockput>
  end_op();
    80005be2:	fffff097          	auipc	ra,0xfffff
    80005be6:	b7a080e7          	jalr	-1158(ra) # 8000475c <end_op>
  return 0;
    80005bea:	4501                	li	a0,0
    80005bec:	a84d                	j	80005c9e <sys_unlink+0x1c4>
    end_op();
    80005bee:	fffff097          	auipc	ra,0xfffff
    80005bf2:	b6e080e7          	jalr	-1170(ra) # 8000475c <end_op>
    return -1;
    80005bf6:	557d                	li	a0,-1
    80005bf8:	a05d                	j	80005c9e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005bfa:	00002517          	auipc	a0,0x2
    80005bfe:	c4650513          	addi	a0,a0,-954 # 80007840 <userret+0x7b0>
    80005c02:	ffffb097          	auipc	ra,0xffffb
    80005c06:	94c080e7          	jalr	-1716(ra) # 8000054e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005c0a:	04c92703          	lw	a4,76(s2)
    80005c0e:	02000793          	li	a5,32
    80005c12:	f6e7f9e3          	bgeu	a5,a4,80005b84 <sys_unlink+0xaa>
    80005c16:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005c1a:	4741                	li	a4,16
    80005c1c:	86ce                	mv	a3,s3
    80005c1e:	f1840613          	addi	a2,s0,-232
    80005c22:	4581                	li	a1,0
    80005c24:	854a                	mv	a0,s2
    80005c26:	ffffe097          	auipc	ra,0xffffe
    80005c2a:	3b0080e7          	jalr	944(ra) # 80003fd6 <readi>
    80005c2e:	47c1                	li	a5,16
    80005c30:	00f51b63          	bne	a0,a5,80005c46 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005c34:	f1845783          	lhu	a5,-232(s0)
    80005c38:	e7a1                	bnez	a5,80005c80 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005c3a:	29c1                	addiw	s3,s3,16
    80005c3c:	04c92783          	lw	a5,76(s2)
    80005c40:	fcf9ede3          	bltu	s3,a5,80005c1a <sys_unlink+0x140>
    80005c44:	b781                	j	80005b84 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005c46:	00002517          	auipc	a0,0x2
    80005c4a:	c1250513          	addi	a0,a0,-1006 # 80007858 <userret+0x7c8>
    80005c4e:	ffffb097          	auipc	ra,0xffffb
    80005c52:	900080e7          	jalr	-1792(ra) # 8000054e <panic>
    panic("unlink: writei");
    80005c56:	00002517          	auipc	a0,0x2
    80005c5a:	c1a50513          	addi	a0,a0,-998 # 80007870 <userret+0x7e0>
    80005c5e:	ffffb097          	auipc	ra,0xffffb
    80005c62:	8f0080e7          	jalr	-1808(ra) # 8000054e <panic>
    dp->nlink--;
    80005c66:	04a4d783          	lhu	a5,74(s1)
    80005c6a:	37fd                	addiw	a5,a5,-1
    80005c6c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005c70:	8526                	mv	a0,s1
    80005c72:	ffffe097          	auipc	ra,0xffffe
    80005c76:	00a080e7          	jalr	10(ra) # 80003c7c <iupdate>
    80005c7a:	b781                	j	80005bba <sys_unlink+0xe0>
    return -1;
    80005c7c:	557d                	li	a0,-1
    80005c7e:	a005                	j	80005c9e <sys_unlink+0x1c4>
    iunlockput(ip);
    80005c80:	854a                	mv	a0,s2
    80005c82:	ffffe097          	auipc	ra,0xffffe
    80005c86:	302080e7          	jalr	770(ra) # 80003f84 <iunlockput>
  iunlockput(dp);
    80005c8a:	8526                	mv	a0,s1
    80005c8c:	ffffe097          	auipc	ra,0xffffe
    80005c90:	2f8080e7          	jalr	760(ra) # 80003f84 <iunlockput>
  end_op();
    80005c94:	fffff097          	auipc	ra,0xfffff
    80005c98:	ac8080e7          	jalr	-1336(ra) # 8000475c <end_op>
  return -1;
    80005c9c:	557d                	li	a0,-1
}
    80005c9e:	70ae                	ld	ra,232(sp)
    80005ca0:	740e                	ld	s0,224(sp)
    80005ca2:	64ee                	ld	s1,216(sp)
    80005ca4:	694e                	ld	s2,208(sp)
    80005ca6:	69ae                	ld	s3,200(sp)
    80005ca8:	616d                	addi	sp,sp,240
    80005caa:	8082                	ret

0000000080005cac <sys_open>:

uint64
sys_open(void)
{
    80005cac:	7131                	addi	sp,sp,-192
    80005cae:	fd06                	sd	ra,184(sp)
    80005cb0:	f922                	sd	s0,176(sp)
    80005cb2:	f526                	sd	s1,168(sp)
    80005cb4:	f14a                	sd	s2,160(sp)
    80005cb6:	ed4e                	sd	s3,152(sp)
    80005cb8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005cba:	08000613          	li	a2,128
    80005cbe:	f5040593          	addi	a1,s0,-176
    80005cc2:	4501                	li	a0,0
    80005cc4:	ffffd097          	auipc	ra,0xffffd
    80005cc8:	532080e7          	jalr	1330(ra) # 800031f6 <argstr>
    return -1;
    80005ccc:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005cce:	0a054763          	bltz	a0,80005d7c <sys_open+0xd0>
    80005cd2:	f4c40593          	addi	a1,s0,-180
    80005cd6:	4505                	li	a0,1
    80005cd8:	ffffd097          	auipc	ra,0xffffd
    80005cdc:	4da080e7          	jalr	1242(ra) # 800031b2 <argint>
    80005ce0:	08054e63          	bltz	a0,80005d7c <sys_open+0xd0>

  begin_op();
    80005ce4:	fffff097          	auipc	ra,0xfffff
    80005ce8:	9f8080e7          	jalr	-1544(ra) # 800046dc <begin_op>

  if(omode & O_CREATE){
    80005cec:	f4c42783          	lw	a5,-180(s0)
    80005cf0:	2007f793          	andi	a5,a5,512
    80005cf4:	c3cd                	beqz	a5,80005d96 <sys_open+0xea>
    ip = create(path, T_FILE, 0, 0);
    80005cf6:	4681                	li	a3,0
    80005cf8:	4601                	li	a2,0
    80005cfa:	4589                	li	a1,2
    80005cfc:	f5040513          	addi	a0,s0,-176
    80005d00:	00000097          	auipc	ra,0x0
    80005d04:	974080e7          	jalr	-1676(ra) # 80005674 <create>
    80005d08:	892a                	mv	s2,a0
    if(ip == 0){
    80005d0a:	c149                	beqz	a0,80005d8c <sys_open+0xe0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005d0c:	04491703          	lh	a4,68(s2)
    80005d10:	478d                	li	a5,3
    80005d12:	00f71763          	bne	a4,a5,80005d20 <sys_open+0x74>
    80005d16:	04695703          	lhu	a4,70(s2)
    80005d1a:	47a5                	li	a5,9
    80005d1c:	0ce7e263          	bltu	a5,a4,80005de0 <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005d20:	fffff097          	auipc	ra,0xfffff
    80005d24:	dd2080e7          	jalr	-558(ra) # 80004af2 <filealloc>
    80005d28:	89aa                	mv	s3,a0
    80005d2a:	c175                	beqz	a0,80005e0e <sys_open+0x162>
    80005d2c:	00000097          	auipc	ra,0x0
    80005d30:	906080e7          	jalr	-1786(ra) # 80005632 <fdalloc>
    80005d34:	84aa                	mv	s1,a0
    80005d36:	0c054763          	bltz	a0,80005e04 <sys_open+0x158>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005d3a:	04491703          	lh	a4,68(s2)
    80005d3e:	478d                	li	a5,3
    80005d40:	0af70b63          	beq	a4,a5,80005df6 <sys_open+0x14a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005d44:	4789                	li	a5,2
    80005d46:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005d4a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005d4e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005d52:	f4c42783          	lw	a5,-180(s0)
    80005d56:	0017c713          	xori	a4,a5,1
    80005d5a:	8b05                	andi	a4,a4,1
    80005d5c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005d60:	8b8d                	andi	a5,a5,3
    80005d62:	00f037b3          	snez	a5,a5
    80005d66:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
    80005d6a:	854a                	mv	a0,s2
    80005d6c:	ffffe097          	auipc	ra,0xffffe
    80005d70:	09c080e7          	jalr	156(ra) # 80003e08 <iunlock>
  end_op();
    80005d74:	fffff097          	auipc	ra,0xfffff
    80005d78:	9e8080e7          	jalr	-1560(ra) # 8000475c <end_op>

  return fd;
}
    80005d7c:	8526                	mv	a0,s1
    80005d7e:	70ea                	ld	ra,184(sp)
    80005d80:	744a                	ld	s0,176(sp)
    80005d82:	74aa                	ld	s1,168(sp)
    80005d84:	790a                	ld	s2,160(sp)
    80005d86:	69ea                	ld	s3,152(sp)
    80005d88:	6129                	addi	sp,sp,192
    80005d8a:	8082                	ret
      end_op();
    80005d8c:	fffff097          	auipc	ra,0xfffff
    80005d90:	9d0080e7          	jalr	-1584(ra) # 8000475c <end_op>
      return -1;
    80005d94:	b7e5                	j	80005d7c <sys_open+0xd0>
    if((ip = namei(path)) == 0){
    80005d96:	f5040513          	addi	a0,s0,-176
    80005d9a:	ffffe097          	auipc	ra,0xffffe
    80005d9e:	736080e7          	jalr	1846(ra) # 800044d0 <namei>
    80005da2:	892a                	mv	s2,a0
    80005da4:	c905                	beqz	a0,80005dd4 <sys_open+0x128>
    ilock(ip);
    80005da6:	ffffe097          	auipc	ra,0xffffe
    80005daa:	fa0080e7          	jalr	-96(ra) # 80003d46 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005dae:	04491703          	lh	a4,68(s2)
    80005db2:	4785                	li	a5,1
    80005db4:	f4f71ce3          	bne	a4,a5,80005d0c <sys_open+0x60>
    80005db8:	f4c42783          	lw	a5,-180(s0)
    80005dbc:	d3b5                	beqz	a5,80005d20 <sys_open+0x74>
      iunlockput(ip);
    80005dbe:	854a                	mv	a0,s2
    80005dc0:	ffffe097          	auipc	ra,0xffffe
    80005dc4:	1c4080e7          	jalr	452(ra) # 80003f84 <iunlockput>
      end_op();
    80005dc8:	fffff097          	auipc	ra,0xfffff
    80005dcc:	994080e7          	jalr	-1644(ra) # 8000475c <end_op>
      return -1;
    80005dd0:	54fd                	li	s1,-1
    80005dd2:	b76d                	j	80005d7c <sys_open+0xd0>
      end_op();
    80005dd4:	fffff097          	auipc	ra,0xfffff
    80005dd8:	988080e7          	jalr	-1656(ra) # 8000475c <end_op>
      return -1;
    80005ddc:	54fd                	li	s1,-1
    80005dde:	bf79                	j	80005d7c <sys_open+0xd0>
    iunlockput(ip);
    80005de0:	854a                	mv	a0,s2
    80005de2:	ffffe097          	auipc	ra,0xffffe
    80005de6:	1a2080e7          	jalr	418(ra) # 80003f84 <iunlockput>
    end_op();
    80005dea:	fffff097          	auipc	ra,0xfffff
    80005dee:	972080e7          	jalr	-1678(ra) # 8000475c <end_op>
    return -1;
    80005df2:	54fd                	li	s1,-1
    80005df4:	b761                	j	80005d7c <sys_open+0xd0>
    f->type = FD_DEVICE;
    80005df6:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005dfa:	04691783          	lh	a5,70(s2)
    80005dfe:	02f99223          	sh	a5,36(s3)
    80005e02:	b7b1                	j	80005d4e <sys_open+0xa2>
      fileclose(f);
    80005e04:	854e                	mv	a0,s3
    80005e06:	fffff097          	auipc	ra,0xfffff
    80005e0a:	da8080e7          	jalr	-600(ra) # 80004bae <fileclose>
    iunlockput(ip);
    80005e0e:	854a                	mv	a0,s2
    80005e10:	ffffe097          	auipc	ra,0xffffe
    80005e14:	174080e7          	jalr	372(ra) # 80003f84 <iunlockput>
    end_op();
    80005e18:	fffff097          	auipc	ra,0xfffff
    80005e1c:	944080e7          	jalr	-1724(ra) # 8000475c <end_op>
    return -1;
    80005e20:	54fd                	li	s1,-1
    80005e22:	bfa9                	j	80005d7c <sys_open+0xd0>

0000000080005e24 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005e24:	7175                	addi	sp,sp,-144
    80005e26:	e506                	sd	ra,136(sp)
    80005e28:	e122                	sd	s0,128(sp)
    80005e2a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005e2c:	fffff097          	auipc	ra,0xfffff
    80005e30:	8b0080e7          	jalr	-1872(ra) # 800046dc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005e34:	08000613          	li	a2,128
    80005e38:	f7040593          	addi	a1,s0,-144
    80005e3c:	4501                	li	a0,0
    80005e3e:	ffffd097          	auipc	ra,0xffffd
    80005e42:	3b8080e7          	jalr	952(ra) # 800031f6 <argstr>
    80005e46:	02054963          	bltz	a0,80005e78 <sys_mkdir+0x54>
    80005e4a:	4681                	li	a3,0
    80005e4c:	4601                	li	a2,0
    80005e4e:	4585                	li	a1,1
    80005e50:	f7040513          	addi	a0,s0,-144
    80005e54:	00000097          	auipc	ra,0x0
    80005e58:	820080e7          	jalr	-2016(ra) # 80005674 <create>
    80005e5c:	cd11                	beqz	a0,80005e78 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005e5e:	ffffe097          	auipc	ra,0xffffe
    80005e62:	126080e7          	jalr	294(ra) # 80003f84 <iunlockput>
  end_op();
    80005e66:	fffff097          	auipc	ra,0xfffff
    80005e6a:	8f6080e7          	jalr	-1802(ra) # 8000475c <end_op>
  return 0;
    80005e6e:	4501                	li	a0,0
}
    80005e70:	60aa                	ld	ra,136(sp)
    80005e72:	640a                	ld	s0,128(sp)
    80005e74:	6149                	addi	sp,sp,144
    80005e76:	8082                	ret
    end_op();
    80005e78:	fffff097          	auipc	ra,0xfffff
    80005e7c:	8e4080e7          	jalr	-1820(ra) # 8000475c <end_op>
    return -1;
    80005e80:	557d                	li	a0,-1
    80005e82:	b7fd                	j	80005e70 <sys_mkdir+0x4c>

0000000080005e84 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005e84:	7135                	addi	sp,sp,-160
    80005e86:	ed06                	sd	ra,152(sp)
    80005e88:	e922                	sd	s0,144(sp)
    80005e8a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005e8c:	fffff097          	auipc	ra,0xfffff
    80005e90:	850080e7          	jalr	-1968(ra) # 800046dc <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005e94:	08000613          	li	a2,128
    80005e98:	f7040593          	addi	a1,s0,-144
    80005e9c:	4501                	li	a0,0
    80005e9e:	ffffd097          	auipc	ra,0xffffd
    80005ea2:	358080e7          	jalr	856(ra) # 800031f6 <argstr>
    80005ea6:	04054a63          	bltz	a0,80005efa <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005eaa:	f6c40593          	addi	a1,s0,-148
    80005eae:	4505                	li	a0,1
    80005eb0:	ffffd097          	auipc	ra,0xffffd
    80005eb4:	302080e7          	jalr	770(ra) # 800031b2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005eb8:	04054163          	bltz	a0,80005efa <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005ebc:	f6840593          	addi	a1,s0,-152
    80005ec0:	4509                	li	a0,2
    80005ec2:	ffffd097          	auipc	ra,0xffffd
    80005ec6:	2f0080e7          	jalr	752(ra) # 800031b2 <argint>
     argint(1, &major) < 0 ||
    80005eca:	02054863          	bltz	a0,80005efa <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005ece:	f6841683          	lh	a3,-152(s0)
    80005ed2:	f6c41603          	lh	a2,-148(s0)
    80005ed6:	458d                	li	a1,3
    80005ed8:	f7040513          	addi	a0,s0,-144
    80005edc:	fffff097          	auipc	ra,0xfffff
    80005ee0:	798080e7          	jalr	1944(ra) # 80005674 <create>
     argint(2, &minor) < 0 ||
    80005ee4:	c919                	beqz	a0,80005efa <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005ee6:	ffffe097          	auipc	ra,0xffffe
    80005eea:	09e080e7          	jalr	158(ra) # 80003f84 <iunlockput>
  end_op();
    80005eee:	fffff097          	auipc	ra,0xfffff
    80005ef2:	86e080e7          	jalr	-1938(ra) # 8000475c <end_op>
  return 0;
    80005ef6:	4501                	li	a0,0
    80005ef8:	a031                	j	80005f04 <sys_mknod+0x80>
    end_op();
    80005efa:	fffff097          	auipc	ra,0xfffff
    80005efe:	862080e7          	jalr	-1950(ra) # 8000475c <end_op>
    return -1;
    80005f02:	557d                	li	a0,-1
}
    80005f04:	60ea                	ld	ra,152(sp)
    80005f06:	644a                	ld	s0,144(sp)
    80005f08:	610d                	addi	sp,sp,160
    80005f0a:	8082                	ret

0000000080005f0c <sys_chdir>:

uint64
sys_chdir(void)
{
    80005f0c:	7135                	addi	sp,sp,-160
    80005f0e:	ed06                	sd	ra,152(sp)
    80005f10:	e922                	sd	s0,144(sp)
    80005f12:	e526                	sd	s1,136(sp)
    80005f14:	e14a                	sd	s2,128(sp)
    80005f16:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005f18:	ffffc097          	auipc	ra,0xffffc
    80005f1c:	bea080e7          	jalr	-1046(ra) # 80001b02 <myproc>
    80005f20:	892a                	mv	s2,a0
  
  begin_op();
    80005f22:	ffffe097          	auipc	ra,0xffffe
    80005f26:	7ba080e7          	jalr	1978(ra) # 800046dc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005f2a:	08000613          	li	a2,128
    80005f2e:	f6040593          	addi	a1,s0,-160
    80005f32:	4501                	li	a0,0
    80005f34:	ffffd097          	auipc	ra,0xffffd
    80005f38:	2c2080e7          	jalr	706(ra) # 800031f6 <argstr>
    80005f3c:	04054b63          	bltz	a0,80005f92 <sys_chdir+0x86>
    80005f40:	f6040513          	addi	a0,s0,-160
    80005f44:	ffffe097          	auipc	ra,0xffffe
    80005f48:	58c080e7          	jalr	1420(ra) # 800044d0 <namei>
    80005f4c:	84aa                	mv	s1,a0
    80005f4e:	c131                	beqz	a0,80005f92 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005f50:	ffffe097          	auipc	ra,0xffffe
    80005f54:	df6080e7          	jalr	-522(ra) # 80003d46 <ilock>
  if(ip->type != T_DIR){
    80005f58:	04449703          	lh	a4,68(s1)
    80005f5c:	4785                	li	a5,1
    80005f5e:	04f71063          	bne	a4,a5,80005f9e <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005f62:	8526                	mv	a0,s1
    80005f64:	ffffe097          	auipc	ra,0xffffe
    80005f68:	ea4080e7          	jalr	-348(ra) # 80003e08 <iunlock>
  iput(p->cwd);
    80005f6c:	16093503          	ld	a0,352(s2)
    80005f70:	ffffe097          	auipc	ra,0xffffe
    80005f74:	ee4080e7          	jalr	-284(ra) # 80003e54 <iput>
  end_op();
    80005f78:	ffffe097          	auipc	ra,0xffffe
    80005f7c:	7e4080e7          	jalr	2020(ra) # 8000475c <end_op>
  p->cwd = ip;
    80005f80:	16993023          	sd	s1,352(s2)
  return 0;
    80005f84:	4501                	li	a0,0
}
    80005f86:	60ea                	ld	ra,152(sp)
    80005f88:	644a                	ld	s0,144(sp)
    80005f8a:	64aa                	ld	s1,136(sp)
    80005f8c:	690a                	ld	s2,128(sp)
    80005f8e:	610d                	addi	sp,sp,160
    80005f90:	8082                	ret
    end_op();
    80005f92:	ffffe097          	auipc	ra,0xffffe
    80005f96:	7ca080e7          	jalr	1994(ra) # 8000475c <end_op>
    return -1;
    80005f9a:	557d                	li	a0,-1
    80005f9c:	b7ed                	j	80005f86 <sys_chdir+0x7a>
    iunlockput(ip);
    80005f9e:	8526                	mv	a0,s1
    80005fa0:	ffffe097          	auipc	ra,0xffffe
    80005fa4:	fe4080e7          	jalr	-28(ra) # 80003f84 <iunlockput>
    end_op();
    80005fa8:	ffffe097          	auipc	ra,0xffffe
    80005fac:	7b4080e7          	jalr	1972(ra) # 8000475c <end_op>
    return -1;
    80005fb0:	557d                	li	a0,-1
    80005fb2:	bfd1                	j	80005f86 <sys_chdir+0x7a>

0000000080005fb4 <sys_exec>:

uint64
sys_exec(void)
{
    80005fb4:	7145                	addi	sp,sp,-464
    80005fb6:	e786                	sd	ra,456(sp)
    80005fb8:	e3a2                	sd	s0,448(sp)
    80005fba:	ff26                	sd	s1,440(sp)
    80005fbc:	fb4a                	sd	s2,432(sp)
    80005fbe:	f74e                	sd	s3,424(sp)
    80005fc0:	f352                	sd	s4,416(sp)
    80005fc2:	ef56                	sd	s5,408(sp)
    80005fc4:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005fc6:	08000613          	li	a2,128
    80005fca:	f4040593          	addi	a1,s0,-192
    80005fce:	4501                	li	a0,0
    80005fd0:	ffffd097          	auipc	ra,0xffffd
    80005fd4:	226080e7          	jalr	550(ra) # 800031f6 <argstr>
    80005fd8:	0e054663          	bltz	a0,800060c4 <sys_exec+0x110>
    80005fdc:	e3840593          	addi	a1,s0,-456
    80005fe0:	4505                	li	a0,1
    80005fe2:	ffffd097          	auipc	ra,0xffffd
    80005fe6:	1f2080e7          	jalr	498(ra) # 800031d4 <argaddr>
    80005fea:	0e054763          	bltz	a0,800060d8 <sys_exec+0x124>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    80005fee:	10000613          	li	a2,256
    80005ff2:	4581                	li	a1,0
    80005ff4:	e4040513          	addi	a0,s0,-448
    80005ff8:	ffffb097          	auipc	ra,0xffffb
    80005ffc:	b76080e7          	jalr	-1162(ra) # 80000b6e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006000:	e4040913          	addi	s2,s0,-448
  memset(argv, 0, sizeof(argv));
    80006004:	89ca                	mv	s3,s2
    80006006:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    80006008:	02000a13          	li	s4,32
    8000600c:	00048a9b          	sext.w	s5,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006010:	00349513          	slli	a0,s1,0x3
    80006014:	e3040593          	addi	a1,s0,-464
    80006018:	e3843783          	ld	a5,-456(s0)
    8000601c:	953e                	add	a0,a0,a5
    8000601e:	ffffd097          	auipc	ra,0xffffd
    80006022:	0fa080e7          	jalr	250(ra) # 80003118 <fetchaddr>
    80006026:	02054a63          	bltz	a0,8000605a <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    8000602a:	e3043783          	ld	a5,-464(s0)
    8000602e:	c7a1                	beqz	a5,80006076 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80006030:	ffffb097          	auipc	ra,0xffffb
    80006034:	930080e7          	jalr	-1744(ra) # 80000960 <kalloc>
    80006038:	85aa                	mv	a1,a0
    8000603a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000603e:	c92d                	beqz	a0,800060b0 <sys_exec+0xfc>
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
    80006040:	6605                	lui	a2,0x1
    80006042:	e3043503          	ld	a0,-464(s0)
    80006046:	ffffd097          	auipc	ra,0xffffd
    8000604a:	124080e7          	jalr	292(ra) # 8000316a <fetchstr>
    8000604e:	00054663          	bltz	a0,8000605a <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80006052:	0485                	addi	s1,s1,1
    80006054:	09a1                	addi	s3,s3,8
    80006056:	fb449be3          	bne	s1,s4,8000600c <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000605a:	10090493          	addi	s1,s2,256
    8000605e:	00093503          	ld	a0,0(s2)
    80006062:	cd39                	beqz	a0,800060c0 <sys_exec+0x10c>
    kfree(argv[i]);
    80006064:	ffffb097          	auipc	ra,0xffffb
    80006068:	800080e7          	jalr	-2048(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000606c:	0921                	addi	s2,s2,8
    8000606e:	fe9918e3          	bne	s2,s1,8000605e <sys_exec+0xaa>
  return -1;
    80006072:	557d                	li	a0,-1
    80006074:	a889                	j	800060c6 <sys_exec+0x112>
      argv[i] = 0;
    80006076:	0a8e                	slli	s5,s5,0x3
    80006078:	fc040793          	addi	a5,s0,-64
    8000607c:	9abe                	add	s5,s5,a5
    8000607e:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8e5c>
  int ret = exec(path, argv);
    80006082:	e4040593          	addi	a1,s0,-448
    80006086:	f4040513          	addi	a0,s0,-192
    8000608a:	fffff097          	auipc	ra,0xfffff
    8000608e:	1c6080e7          	jalr	454(ra) # 80005250 <exec>
    80006092:	84aa                	mv	s1,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006094:	10090993          	addi	s3,s2,256
    80006098:	00093503          	ld	a0,0(s2)
    8000609c:	c901                	beqz	a0,800060ac <sys_exec+0xf8>
    kfree(argv[i]);
    8000609e:	ffffa097          	auipc	ra,0xffffa
    800060a2:	7c6080e7          	jalr	1990(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060a6:	0921                	addi	s2,s2,8
    800060a8:	ff3918e3          	bne	s2,s3,80006098 <sys_exec+0xe4>
  return ret;
    800060ac:	8526                	mv	a0,s1
    800060ae:	a821                	j	800060c6 <sys_exec+0x112>
      panic("sys_exec kalloc");
    800060b0:	00001517          	auipc	a0,0x1
    800060b4:	7d050513          	addi	a0,a0,2000 # 80007880 <userret+0x7f0>
    800060b8:	ffffa097          	auipc	ra,0xffffa
    800060bc:	496080e7          	jalr	1174(ra) # 8000054e <panic>
  return -1;
    800060c0:	557d                	li	a0,-1
    800060c2:	a011                	j	800060c6 <sys_exec+0x112>
    return -1;
    800060c4:	557d                	li	a0,-1
}
    800060c6:	60be                	ld	ra,456(sp)
    800060c8:	641e                	ld	s0,448(sp)
    800060ca:	74fa                	ld	s1,440(sp)
    800060cc:	795a                	ld	s2,432(sp)
    800060ce:	79ba                	ld	s3,424(sp)
    800060d0:	7a1a                	ld	s4,416(sp)
    800060d2:	6afa                	ld	s5,408(sp)
    800060d4:	6179                	addi	sp,sp,464
    800060d6:	8082                	ret
    return -1;
    800060d8:	557d                	li	a0,-1
    800060da:	b7f5                	j	800060c6 <sys_exec+0x112>

00000000800060dc <sys_pipe>:

uint64
sys_pipe(void)
{
    800060dc:	7139                	addi	sp,sp,-64
    800060de:	fc06                	sd	ra,56(sp)
    800060e0:	f822                	sd	s0,48(sp)
    800060e2:	f426                	sd	s1,40(sp)
    800060e4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800060e6:	ffffc097          	auipc	ra,0xffffc
    800060ea:	a1c080e7          	jalr	-1508(ra) # 80001b02 <myproc>
    800060ee:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800060f0:	fd840593          	addi	a1,s0,-40
    800060f4:	4501                	li	a0,0
    800060f6:	ffffd097          	auipc	ra,0xffffd
    800060fa:	0de080e7          	jalr	222(ra) # 800031d4 <argaddr>
    return -1;
    800060fe:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80006100:	0e054063          	bltz	a0,800061e0 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80006104:	fc840593          	addi	a1,s0,-56
    80006108:	fd040513          	addi	a0,s0,-48
    8000610c:	fffff097          	auipc	ra,0xfffff
    80006110:	df8080e7          	jalr	-520(ra) # 80004f04 <pipealloc>
    return -1;
    80006114:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006116:	0c054563          	bltz	a0,800061e0 <sys_pipe+0x104>
  fd0 = -1;
    8000611a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000611e:	fd043503          	ld	a0,-48(s0)
    80006122:	fffff097          	auipc	ra,0xfffff
    80006126:	510080e7          	jalr	1296(ra) # 80005632 <fdalloc>
    8000612a:	fca42223          	sw	a0,-60(s0)
    8000612e:	08054c63          	bltz	a0,800061c6 <sys_pipe+0xea>
    80006132:	fc843503          	ld	a0,-56(s0)
    80006136:	fffff097          	auipc	ra,0xfffff
    8000613a:	4fc080e7          	jalr	1276(ra) # 80005632 <fdalloc>
    8000613e:	fca42023          	sw	a0,-64(s0)
    80006142:	06054863          	bltz	a0,800061b2 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006146:	4691                	li	a3,4
    80006148:	fc440613          	addi	a2,s0,-60
    8000614c:	fd843583          	ld	a1,-40(s0)
    80006150:	70a8                	ld	a0,96(s1)
    80006152:	ffffb097          	auipc	ra,0xffffb
    80006156:	42a080e7          	jalr	1066(ra) # 8000157c <copyout>
    8000615a:	02054063          	bltz	a0,8000617a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000615e:	4691                	li	a3,4
    80006160:	fc040613          	addi	a2,s0,-64
    80006164:	fd843583          	ld	a1,-40(s0)
    80006168:	0591                	addi	a1,a1,4
    8000616a:	70a8                	ld	a0,96(s1)
    8000616c:	ffffb097          	auipc	ra,0xffffb
    80006170:	410080e7          	jalr	1040(ra) # 8000157c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006174:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006176:	06055563          	bgez	a0,800061e0 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000617a:	fc442783          	lw	a5,-60(s0)
    8000617e:	07f1                	addi	a5,a5,28
    80006180:	078e                	slli	a5,a5,0x3
    80006182:	97a6                	add	a5,a5,s1
    80006184:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006188:	fc042503          	lw	a0,-64(s0)
    8000618c:	0571                	addi	a0,a0,28
    8000618e:	050e                	slli	a0,a0,0x3
    80006190:	9526                	add	a0,a0,s1
    80006192:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006196:	fd043503          	ld	a0,-48(s0)
    8000619a:	fffff097          	auipc	ra,0xfffff
    8000619e:	a14080e7          	jalr	-1516(ra) # 80004bae <fileclose>
    fileclose(wf);
    800061a2:	fc843503          	ld	a0,-56(s0)
    800061a6:	fffff097          	auipc	ra,0xfffff
    800061aa:	a08080e7          	jalr	-1528(ra) # 80004bae <fileclose>
    return -1;
    800061ae:	57fd                	li	a5,-1
    800061b0:	a805                	j	800061e0 <sys_pipe+0x104>
    if(fd0 >= 0)
    800061b2:	fc442783          	lw	a5,-60(s0)
    800061b6:	0007c863          	bltz	a5,800061c6 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800061ba:	01c78513          	addi	a0,a5,28
    800061be:	050e                	slli	a0,a0,0x3
    800061c0:	9526                	add	a0,a0,s1
    800061c2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800061c6:	fd043503          	ld	a0,-48(s0)
    800061ca:	fffff097          	auipc	ra,0xfffff
    800061ce:	9e4080e7          	jalr	-1564(ra) # 80004bae <fileclose>
    fileclose(wf);
    800061d2:	fc843503          	ld	a0,-56(s0)
    800061d6:	fffff097          	auipc	ra,0xfffff
    800061da:	9d8080e7          	jalr	-1576(ra) # 80004bae <fileclose>
    return -1;
    800061de:	57fd                	li	a5,-1
}
    800061e0:	853e                	mv	a0,a5
    800061e2:	70e2                	ld	ra,56(sp)
    800061e4:	7442                	ld	s0,48(sp)
    800061e6:	74a2                	ld	s1,40(sp)
    800061e8:	6121                	addi	sp,sp,64
    800061ea:	8082                	ret
    800061ec:	0000                	unimp
	...

00000000800061f0 <kernelvec>:
    800061f0:	7111                	addi	sp,sp,-256
    800061f2:	e006                	sd	ra,0(sp)
    800061f4:	e40a                	sd	sp,8(sp)
    800061f6:	e80e                	sd	gp,16(sp)
    800061f8:	ec12                	sd	tp,24(sp)
    800061fa:	f016                	sd	t0,32(sp)
    800061fc:	f41a                	sd	t1,40(sp)
    800061fe:	f81e                	sd	t2,48(sp)
    80006200:	fc22                	sd	s0,56(sp)
    80006202:	e0a6                	sd	s1,64(sp)
    80006204:	e4aa                	sd	a0,72(sp)
    80006206:	e8ae                	sd	a1,80(sp)
    80006208:	ecb2                	sd	a2,88(sp)
    8000620a:	f0b6                	sd	a3,96(sp)
    8000620c:	f4ba                	sd	a4,104(sp)
    8000620e:	f8be                	sd	a5,112(sp)
    80006210:	fcc2                	sd	a6,120(sp)
    80006212:	e146                	sd	a7,128(sp)
    80006214:	e54a                	sd	s2,136(sp)
    80006216:	e94e                	sd	s3,144(sp)
    80006218:	ed52                	sd	s4,152(sp)
    8000621a:	f156                	sd	s5,160(sp)
    8000621c:	f55a                	sd	s6,168(sp)
    8000621e:	f95e                	sd	s7,176(sp)
    80006220:	fd62                	sd	s8,184(sp)
    80006222:	e1e6                	sd	s9,192(sp)
    80006224:	e5ea                	sd	s10,200(sp)
    80006226:	e9ee                	sd	s11,208(sp)
    80006228:	edf2                	sd	t3,216(sp)
    8000622a:	f1f6                	sd	t4,224(sp)
    8000622c:	f5fa                	sd	t5,232(sp)
    8000622e:	f9fe                	sd	t6,240(sp)
    80006230:	db5fc0ef          	jal	ra,80002fe4 <kerneltrap>
    80006234:	6082                	ld	ra,0(sp)
    80006236:	6122                	ld	sp,8(sp)
    80006238:	61c2                	ld	gp,16(sp)
    8000623a:	7282                	ld	t0,32(sp)
    8000623c:	7322                	ld	t1,40(sp)
    8000623e:	73c2                	ld	t2,48(sp)
    80006240:	7462                	ld	s0,56(sp)
    80006242:	6486                	ld	s1,64(sp)
    80006244:	6526                	ld	a0,72(sp)
    80006246:	65c6                	ld	a1,80(sp)
    80006248:	6666                	ld	a2,88(sp)
    8000624a:	7686                	ld	a3,96(sp)
    8000624c:	7726                	ld	a4,104(sp)
    8000624e:	77c6                	ld	a5,112(sp)
    80006250:	7866                	ld	a6,120(sp)
    80006252:	688a                	ld	a7,128(sp)
    80006254:	692a                	ld	s2,136(sp)
    80006256:	69ca                	ld	s3,144(sp)
    80006258:	6a6a                	ld	s4,152(sp)
    8000625a:	7a8a                	ld	s5,160(sp)
    8000625c:	7b2a                	ld	s6,168(sp)
    8000625e:	7bca                	ld	s7,176(sp)
    80006260:	7c6a                	ld	s8,184(sp)
    80006262:	6c8e                	ld	s9,192(sp)
    80006264:	6d2e                	ld	s10,200(sp)
    80006266:	6dce                	ld	s11,208(sp)
    80006268:	6e6e                	ld	t3,216(sp)
    8000626a:	7e8e                	ld	t4,224(sp)
    8000626c:	7f2e                	ld	t5,232(sp)
    8000626e:	7fce                	ld	t6,240(sp)
    80006270:	6111                	addi	sp,sp,256
    80006272:	10200073          	sret
    80006276:	00000013          	nop
    8000627a:	00000013          	nop
    8000627e:	0001                	nop

0000000080006280 <timervec>:
    80006280:	34051573          	csrrw	a0,mscratch,a0
    80006284:	e10c                	sd	a1,0(a0)
    80006286:	e510                	sd	a2,8(a0)
    80006288:	e914                	sd	a3,16(a0)
    8000628a:	710c                	ld	a1,32(a0)
    8000628c:	7510                	ld	a2,40(a0)
    8000628e:	6194                	ld	a3,0(a1)
    80006290:	96b2                	add	a3,a3,a2
    80006292:	e194                	sd	a3,0(a1)
    80006294:	4589                	li	a1,2
    80006296:	14459073          	csrw	sip,a1
    8000629a:	6914                	ld	a3,16(a0)
    8000629c:	6510                	ld	a2,8(a0)
    8000629e:	610c                	ld	a1,0(a0)
    800062a0:	34051573          	csrrw	a0,mscratch,a0
    800062a4:	30200073          	mret
	...

00000000800062aa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800062aa:	1141                	addi	sp,sp,-16
    800062ac:	e422                	sd	s0,8(sp)
    800062ae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800062b0:	0c0007b7          	lui	a5,0xc000
    800062b4:	4705                	li	a4,1
    800062b6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800062b8:	c3d8                	sw	a4,4(a5)
}
    800062ba:	6422                	ld	s0,8(sp)
    800062bc:	0141                	addi	sp,sp,16
    800062be:	8082                	ret

00000000800062c0 <plicinithart>:

void
plicinithart(void)
{
    800062c0:	1141                	addi	sp,sp,-16
    800062c2:	e406                	sd	ra,8(sp)
    800062c4:	e022                	sd	s0,0(sp)
    800062c6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800062c8:	ffffc097          	auipc	ra,0xffffc
    800062cc:	80e080e7          	jalr	-2034(ra) # 80001ad6 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800062d0:	0085171b          	slliw	a4,a0,0x8
    800062d4:	0c0027b7          	lui	a5,0xc002
    800062d8:	97ba                	add	a5,a5,a4
    800062da:	40200713          	li	a4,1026
    800062de:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800062e2:	00d5151b          	slliw	a0,a0,0xd
    800062e6:	0c2017b7          	lui	a5,0xc201
    800062ea:	953e                	add	a0,a0,a5
    800062ec:	00052023          	sw	zero,0(a0)
}
    800062f0:	60a2                	ld	ra,8(sp)
    800062f2:	6402                	ld	s0,0(sp)
    800062f4:	0141                	addi	sp,sp,16
    800062f6:	8082                	ret

00000000800062f8 <plic_pending>:

// return a bitmap of which IRQs are waiting
// to be served.
uint64
plic_pending(void)
{
    800062f8:	1141                	addi	sp,sp,-16
    800062fa:	e422                	sd	s0,8(sp)
    800062fc:	0800                	addi	s0,sp,16
  //mask = *(uint32*)(PLIC + 0x1000);
  //mask |= (uint64)*(uint32*)(PLIC + 0x1004) << 32;
  mask = *(uint64*)PLIC_PENDING;

  return mask;
}
    800062fe:	0c0017b7          	lui	a5,0xc001
    80006302:	6388                	ld	a0,0(a5)
    80006304:	6422                	ld	s0,8(sp)
    80006306:	0141                	addi	sp,sp,16
    80006308:	8082                	ret

000000008000630a <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000630a:	1141                	addi	sp,sp,-16
    8000630c:	e406                	sd	ra,8(sp)
    8000630e:	e022                	sd	s0,0(sp)
    80006310:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006312:	ffffb097          	auipc	ra,0xffffb
    80006316:	7c4080e7          	jalr	1988(ra) # 80001ad6 <cpuid>
  //int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000631a:	00d5179b          	slliw	a5,a0,0xd
    8000631e:	0c201537          	lui	a0,0xc201
    80006322:	953e                	add	a0,a0,a5
  return irq;
}
    80006324:	4148                	lw	a0,4(a0)
    80006326:	60a2                	ld	ra,8(sp)
    80006328:	6402                	ld	s0,0(sp)
    8000632a:	0141                	addi	sp,sp,16
    8000632c:	8082                	ret

000000008000632e <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000632e:	1101                	addi	sp,sp,-32
    80006330:	ec06                	sd	ra,24(sp)
    80006332:	e822                	sd	s0,16(sp)
    80006334:	e426                	sd	s1,8(sp)
    80006336:	1000                	addi	s0,sp,32
    80006338:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000633a:	ffffb097          	auipc	ra,0xffffb
    8000633e:	79c080e7          	jalr	1948(ra) # 80001ad6 <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006342:	00d5151b          	slliw	a0,a0,0xd
    80006346:	0c2017b7          	lui	a5,0xc201
    8000634a:	97aa                	add	a5,a5,a0
    8000634c:	c3c4                	sw	s1,4(a5)
}
    8000634e:	60e2                	ld	ra,24(sp)
    80006350:	6442                	ld	s0,16(sp)
    80006352:	64a2                	ld	s1,8(sp)
    80006354:	6105                	addi	sp,sp,32
    80006356:	8082                	ret

0000000080006358 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006358:	1141                	addi	sp,sp,-16
    8000635a:	e406                	sd	ra,8(sp)
    8000635c:	e022                	sd	s0,0(sp)
    8000635e:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006360:	479d                	li	a5,7
    80006362:	04a7cc63          	blt	a5,a0,800063ba <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80006366:	0001d797          	auipc	a5,0x1d
    8000636a:	c9a78793          	addi	a5,a5,-870 # 80023000 <disk>
    8000636e:	00a78733          	add	a4,a5,a0
    80006372:	6789                	lui	a5,0x2
    80006374:	97ba                	add	a5,a5,a4
    80006376:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000637a:	eba1                	bnez	a5,800063ca <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    8000637c:	00451713          	slli	a4,a0,0x4
    80006380:	0001f797          	auipc	a5,0x1f
    80006384:	c807b783          	ld	a5,-896(a5) # 80025000 <disk+0x2000>
    80006388:	97ba                	add	a5,a5,a4
    8000638a:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    8000638e:	0001d797          	auipc	a5,0x1d
    80006392:	c7278793          	addi	a5,a5,-910 # 80023000 <disk>
    80006396:	97aa                	add	a5,a5,a0
    80006398:	6509                	lui	a0,0x2
    8000639a:	953e                	add	a0,a0,a5
    8000639c:	4785                	li	a5,1
    8000639e:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800063a2:	0001f517          	auipc	a0,0x1f
    800063a6:	c7650513          	addi	a0,a0,-906 # 80025018 <disk+0x2018>
    800063aa:	ffffc097          	auipc	ra,0xffffc
    800063ae:	68a080e7          	jalr	1674(ra) # 80002a34 <wakeup>
}
    800063b2:	60a2                	ld	ra,8(sp)
    800063b4:	6402                	ld	s0,0(sp)
    800063b6:	0141                	addi	sp,sp,16
    800063b8:	8082                	ret
    panic("virtio_disk_intr 1");
    800063ba:	00001517          	auipc	a0,0x1
    800063be:	4d650513          	addi	a0,a0,1238 # 80007890 <userret+0x800>
    800063c2:	ffffa097          	auipc	ra,0xffffa
    800063c6:	18c080e7          	jalr	396(ra) # 8000054e <panic>
    panic("virtio_disk_intr 2");
    800063ca:	00001517          	auipc	a0,0x1
    800063ce:	4de50513          	addi	a0,a0,1246 # 800078a8 <userret+0x818>
    800063d2:	ffffa097          	auipc	ra,0xffffa
    800063d6:	17c080e7          	jalr	380(ra) # 8000054e <panic>

00000000800063da <virtio_disk_init>:
{
    800063da:	1101                	addi	sp,sp,-32
    800063dc:	ec06                	sd	ra,24(sp)
    800063de:	e822                	sd	s0,16(sp)
    800063e0:	e426                	sd	s1,8(sp)
    800063e2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800063e4:	00001597          	auipc	a1,0x1
    800063e8:	4dc58593          	addi	a1,a1,1244 # 800078c0 <userret+0x830>
    800063ec:	0001f517          	auipc	a0,0x1f
    800063f0:	cbc50513          	addi	a0,a0,-836 # 800250a8 <disk+0x20a8>
    800063f4:	ffffa097          	auipc	ra,0xffffa
    800063f8:	5cc080e7          	jalr	1484(ra) # 800009c0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800063fc:	100017b7          	lui	a5,0x10001
    80006400:	4398                	lw	a4,0(a5)
    80006402:	2701                	sext.w	a4,a4
    80006404:	747277b7          	lui	a5,0x74727
    80006408:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000640c:	0ef71163          	bne	a4,a5,800064ee <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006410:	100017b7          	lui	a5,0x10001
    80006414:	43dc                	lw	a5,4(a5)
    80006416:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006418:	4705                	li	a4,1
    8000641a:	0ce79a63          	bne	a5,a4,800064ee <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000641e:	100017b7          	lui	a5,0x10001
    80006422:	479c                	lw	a5,8(a5)
    80006424:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006426:	4709                	li	a4,2
    80006428:	0ce79363          	bne	a5,a4,800064ee <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000642c:	100017b7          	lui	a5,0x10001
    80006430:	47d8                	lw	a4,12(a5)
    80006432:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006434:	554d47b7          	lui	a5,0x554d4
    80006438:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000643c:	0af71963          	bne	a4,a5,800064ee <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006440:	100017b7          	lui	a5,0x10001
    80006444:	4705                	li	a4,1
    80006446:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006448:	470d                	li	a4,3
    8000644a:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000644c:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000644e:	c7ffe737          	lui	a4,0xc7ffe
    80006452:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd873b>
    80006456:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006458:	2701                	sext.w	a4,a4
    8000645a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000645c:	472d                	li	a4,11
    8000645e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006460:	473d                	li	a4,15
    80006462:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006464:	6705                	lui	a4,0x1
    80006466:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006468:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000646c:	5bdc                	lw	a5,52(a5)
    8000646e:	2781                	sext.w	a5,a5
  if(max == 0)
    80006470:	c7d9                	beqz	a5,800064fe <virtio_disk_init+0x124>
  if(max < NUM)
    80006472:	471d                	li	a4,7
    80006474:	08f77d63          	bgeu	a4,a5,8000650e <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006478:	100014b7          	lui	s1,0x10001
    8000647c:	47a1                	li	a5,8
    8000647e:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80006480:	6609                	lui	a2,0x2
    80006482:	4581                	li	a1,0
    80006484:	0001d517          	auipc	a0,0x1d
    80006488:	b7c50513          	addi	a0,a0,-1156 # 80023000 <disk>
    8000648c:	ffffa097          	auipc	ra,0xffffa
    80006490:	6e2080e7          	jalr	1762(ra) # 80000b6e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006494:	0001d717          	auipc	a4,0x1d
    80006498:	b6c70713          	addi	a4,a4,-1172 # 80023000 <disk>
    8000649c:	00c75793          	srli	a5,a4,0xc
    800064a0:	2781                	sext.w	a5,a5
    800064a2:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    800064a4:	0001f797          	auipc	a5,0x1f
    800064a8:	b5c78793          	addi	a5,a5,-1188 # 80025000 <disk+0x2000>
    800064ac:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    800064ae:	0001d717          	auipc	a4,0x1d
    800064b2:	bd270713          	addi	a4,a4,-1070 # 80023080 <disk+0x80>
    800064b6:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    800064b8:	0001e717          	auipc	a4,0x1e
    800064bc:	b4870713          	addi	a4,a4,-1208 # 80024000 <disk+0x1000>
    800064c0:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800064c2:	4705                	li	a4,1
    800064c4:	00e78c23          	sb	a4,24(a5)
    800064c8:	00e78ca3          	sb	a4,25(a5)
    800064cc:	00e78d23          	sb	a4,26(a5)
    800064d0:	00e78da3          	sb	a4,27(a5)
    800064d4:	00e78e23          	sb	a4,28(a5)
    800064d8:	00e78ea3          	sb	a4,29(a5)
    800064dc:	00e78f23          	sb	a4,30(a5)
    800064e0:	00e78fa3          	sb	a4,31(a5)
}
    800064e4:	60e2                	ld	ra,24(sp)
    800064e6:	6442                	ld	s0,16(sp)
    800064e8:	64a2                	ld	s1,8(sp)
    800064ea:	6105                	addi	sp,sp,32
    800064ec:	8082                	ret
    panic("could not find virtio disk");
    800064ee:	00001517          	auipc	a0,0x1
    800064f2:	3e250513          	addi	a0,a0,994 # 800078d0 <userret+0x840>
    800064f6:	ffffa097          	auipc	ra,0xffffa
    800064fa:	058080e7          	jalr	88(ra) # 8000054e <panic>
    panic("virtio disk has no queue 0");
    800064fe:	00001517          	auipc	a0,0x1
    80006502:	3f250513          	addi	a0,a0,1010 # 800078f0 <userret+0x860>
    80006506:	ffffa097          	auipc	ra,0xffffa
    8000650a:	048080e7          	jalr	72(ra) # 8000054e <panic>
    panic("virtio disk max queue too short");
    8000650e:	00001517          	auipc	a0,0x1
    80006512:	40250513          	addi	a0,a0,1026 # 80007910 <userret+0x880>
    80006516:	ffffa097          	auipc	ra,0xffffa
    8000651a:	038080e7          	jalr	56(ra) # 8000054e <panic>

000000008000651e <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000651e:	7119                	addi	sp,sp,-128
    80006520:	fc86                	sd	ra,120(sp)
    80006522:	f8a2                	sd	s0,112(sp)
    80006524:	f4a6                	sd	s1,104(sp)
    80006526:	f0ca                	sd	s2,96(sp)
    80006528:	ecce                	sd	s3,88(sp)
    8000652a:	e8d2                	sd	s4,80(sp)
    8000652c:	e4d6                	sd	s5,72(sp)
    8000652e:	e0da                	sd	s6,64(sp)
    80006530:	fc5e                	sd	s7,56(sp)
    80006532:	f862                	sd	s8,48(sp)
    80006534:	f466                	sd	s9,40(sp)
    80006536:	f06a                	sd	s10,32(sp)
    80006538:	0100                	addi	s0,sp,128
    8000653a:	892a                	mv	s2,a0
    8000653c:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000653e:	00c52c83          	lw	s9,12(a0)
    80006542:	001c9c9b          	slliw	s9,s9,0x1
    80006546:	1c82                	slli	s9,s9,0x20
    80006548:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000654c:	0001f517          	auipc	a0,0x1f
    80006550:	b5c50513          	addi	a0,a0,-1188 # 800250a8 <disk+0x20a8>
    80006554:	ffffa097          	auipc	ra,0xffffa
    80006558:	57e080e7          	jalr	1406(ra) # 80000ad2 <acquire>
  for(int i = 0; i < 3; i++){
    8000655c:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000655e:	4c21                	li	s8,8
      disk.free[i] = 0;
    80006560:	0001db97          	auipc	s7,0x1d
    80006564:	aa0b8b93          	addi	s7,s7,-1376 # 80023000 <disk>
    80006568:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000656a:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    8000656c:	8a4e                	mv	s4,s3
    8000656e:	a051                	j	800065f2 <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80006570:	00fb86b3          	add	a3,s7,a5
    80006574:	96da                	add	a3,a3,s6
    80006576:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    8000657a:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000657c:	0207c563          	bltz	a5,800065a6 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80006580:	2485                	addiw	s1,s1,1
    80006582:	0711                	addi	a4,a4,4
    80006584:	1b548863          	beq	s1,s5,80006734 <virtio_disk_rw+0x216>
    idx[i] = alloc_desc();
    80006588:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    8000658a:	0001f697          	auipc	a3,0x1f
    8000658e:	a8e68693          	addi	a3,a3,-1394 # 80025018 <disk+0x2018>
    80006592:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80006594:	0006c583          	lbu	a1,0(a3)
    80006598:	fde1                	bnez	a1,80006570 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000659a:	2785                	addiw	a5,a5,1
    8000659c:	0685                	addi	a3,a3,1
    8000659e:	ff879be3          	bne	a5,s8,80006594 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800065a2:	57fd                	li	a5,-1
    800065a4:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800065a6:	02905a63          	blez	s1,800065da <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800065aa:	f9042503          	lw	a0,-112(s0)
    800065ae:	00000097          	auipc	ra,0x0
    800065b2:	daa080e7          	jalr	-598(ra) # 80006358 <free_desc>
      for(int j = 0; j < i; j++)
    800065b6:	4785                	li	a5,1
    800065b8:	0297d163          	bge	a5,s1,800065da <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800065bc:	f9442503          	lw	a0,-108(s0)
    800065c0:	00000097          	auipc	ra,0x0
    800065c4:	d98080e7          	jalr	-616(ra) # 80006358 <free_desc>
      for(int j = 0; j < i; j++)
    800065c8:	4789                	li	a5,2
    800065ca:	0097d863          	bge	a5,s1,800065da <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800065ce:	f9842503          	lw	a0,-104(s0)
    800065d2:	00000097          	auipc	ra,0x0
    800065d6:	d86080e7          	jalr	-634(ra) # 80006358 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800065da:	0001f597          	auipc	a1,0x1f
    800065de:	ace58593          	addi	a1,a1,-1330 # 800250a8 <disk+0x20a8>
    800065e2:	0001f517          	auipc	a0,0x1f
    800065e6:	a3650513          	addi	a0,a0,-1482 # 80025018 <disk+0x2018>
    800065ea:	ffffc097          	auipc	ra,0xffffc
    800065ee:	180080e7          	jalr	384(ra) # 8000276a <sleep>
  for(int i = 0; i < 3; i++){
    800065f2:	f9040713          	addi	a4,s0,-112
    800065f6:	84ce                	mv	s1,s3
    800065f8:	bf41                	j	80006588 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800065fa:	0001f717          	auipc	a4,0x1f
    800065fe:	a0673703          	ld	a4,-1530(a4) # 80025000 <disk+0x2000>
    80006602:	973e                	add	a4,a4,a5
    80006604:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006608:	0001d517          	auipc	a0,0x1d
    8000660c:	9f850513          	addi	a0,a0,-1544 # 80023000 <disk>
    80006610:	0001f717          	auipc	a4,0x1f
    80006614:	9f070713          	addi	a4,a4,-1552 # 80025000 <disk+0x2000>
    80006618:	6310                	ld	a2,0(a4)
    8000661a:	963e                	add	a2,a2,a5
    8000661c:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006620:	0015e593          	ori	a1,a1,1
    80006624:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80006628:	f9842683          	lw	a3,-104(s0)
    8000662c:	6310                	ld	a2,0(a4)
    8000662e:	97b2                	add	a5,a5,a2
    80006630:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    80006634:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    80006638:	0612                	slli	a2,a2,0x4
    8000663a:	962a                	add	a2,a2,a0
    8000663c:	02060823          	sb	zero,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006640:	00469793          	slli	a5,a3,0x4
    80006644:	630c                	ld	a1,0(a4)
    80006646:	95be                	add	a1,a1,a5
    80006648:	6689                	lui	a3,0x2
    8000664a:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    8000664e:	96ce                	add	a3,a3,s3
    80006650:	96aa                	add	a3,a3,a0
    80006652:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    80006654:	6314                	ld	a3,0(a4)
    80006656:	96be                	add	a3,a3,a5
    80006658:	4585                	li	a1,1
    8000665a:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000665c:	6314                	ld	a3,0(a4)
    8000665e:	96be                	add	a3,a3,a5
    80006660:	4509                	li	a0,2
    80006662:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    80006666:	6314                	ld	a3,0(a4)
    80006668:	97b6                	add	a5,a5,a3
    8000666a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000666e:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80006672:	03263423          	sd	s2,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    80006676:	6714                	ld	a3,8(a4)
    80006678:	0026d783          	lhu	a5,2(a3)
    8000667c:	8b9d                	andi	a5,a5,7
    8000667e:	2789                	addiw	a5,a5,2
    80006680:	0786                	slli	a5,a5,0x1
    80006682:	97b6                	add	a5,a5,a3
    80006684:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    80006688:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    8000668c:	6718                	ld	a4,8(a4)
    8000668e:	00275783          	lhu	a5,2(a4)
    80006692:	2785                	addiw	a5,a5,1
    80006694:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006698:	100017b7          	lui	a5,0x10001
    8000669c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800066a0:	00492783          	lw	a5,4(s2)
    800066a4:	02b79163          	bne	a5,a1,800066c6 <virtio_disk_rw+0x1a8>
    sleep(b, &disk.vdisk_lock);
    800066a8:	0001f997          	auipc	s3,0x1f
    800066ac:	a0098993          	addi	s3,s3,-1536 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    800066b0:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800066b2:	85ce                	mv	a1,s3
    800066b4:	854a                	mv	a0,s2
    800066b6:	ffffc097          	auipc	ra,0xffffc
    800066ba:	0b4080e7          	jalr	180(ra) # 8000276a <sleep>
  while(b->disk == 1) {
    800066be:	00492783          	lw	a5,4(s2)
    800066c2:	fe9788e3          	beq	a5,s1,800066b2 <virtio_disk_rw+0x194>
  }

  disk.info[idx[0]].b = 0;
    800066c6:	f9042483          	lw	s1,-112(s0)
    800066ca:	20048793          	addi	a5,s1,512
    800066ce:	00479713          	slli	a4,a5,0x4
    800066d2:	0001d797          	auipc	a5,0x1d
    800066d6:	92e78793          	addi	a5,a5,-1746 # 80023000 <disk>
    800066da:	97ba                	add	a5,a5,a4
    800066dc:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800066e0:	0001f917          	auipc	s2,0x1f
    800066e4:	92090913          	addi	s2,s2,-1760 # 80025000 <disk+0x2000>
    free_desc(i);
    800066e8:	8526                	mv	a0,s1
    800066ea:	00000097          	auipc	ra,0x0
    800066ee:	c6e080e7          	jalr	-914(ra) # 80006358 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800066f2:	0492                	slli	s1,s1,0x4
    800066f4:	00093783          	ld	a5,0(s2)
    800066f8:	94be                	add	s1,s1,a5
    800066fa:	00c4d783          	lhu	a5,12(s1)
    800066fe:	8b85                	andi	a5,a5,1
    80006700:	c781                	beqz	a5,80006708 <virtio_disk_rw+0x1ea>
      i = disk.desc[i].next;
    80006702:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    80006706:	b7cd                	j	800066e8 <virtio_disk_rw+0x1ca>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006708:	0001f517          	auipc	a0,0x1f
    8000670c:	9a050513          	addi	a0,a0,-1632 # 800250a8 <disk+0x20a8>
    80006710:	ffffa097          	auipc	ra,0xffffa
    80006714:	416080e7          	jalr	1046(ra) # 80000b26 <release>
}
    80006718:	70e6                	ld	ra,120(sp)
    8000671a:	7446                	ld	s0,112(sp)
    8000671c:	74a6                	ld	s1,104(sp)
    8000671e:	7906                	ld	s2,96(sp)
    80006720:	69e6                	ld	s3,88(sp)
    80006722:	6a46                	ld	s4,80(sp)
    80006724:	6aa6                	ld	s5,72(sp)
    80006726:	6b06                	ld	s6,64(sp)
    80006728:	7be2                	ld	s7,56(sp)
    8000672a:	7c42                	ld	s8,48(sp)
    8000672c:	7ca2                	ld	s9,40(sp)
    8000672e:	7d02                	ld	s10,32(sp)
    80006730:	6109                	addi	sp,sp,128
    80006732:	8082                	ret
  if(write)
    80006734:	01a037b3          	snez	a5,s10
    80006738:	f8f42023          	sw	a5,-128(s0)
  buf0.reserved = 0;
    8000673c:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    80006740:	f9943423          	sd	s9,-120(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80006744:	f9042483          	lw	s1,-112(s0)
    80006748:	00449993          	slli	s3,s1,0x4
    8000674c:	0001fa17          	auipc	s4,0x1f
    80006750:	8b4a0a13          	addi	s4,s4,-1868 # 80025000 <disk+0x2000>
    80006754:	000a3a83          	ld	s5,0(s4)
    80006758:	9ace                	add	s5,s5,s3
    8000675a:	f8040513          	addi	a0,s0,-128
    8000675e:	ffffb097          	auipc	ra,0xffffb
    80006762:	892080e7          	jalr	-1902(ra) # 80000ff0 <kvmpa>
    80006766:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    8000676a:	000a3783          	ld	a5,0(s4)
    8000676e:	97ce                	add	a5,a5,s3
    80006770:	4741                	li	a4,16
    80006772:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006774:	000a3783          	ld	a5,0(s4)
    80006778:	97ce                	add	a5,a5,s3
    8000677a:	4705                	li	a4,1
    8000677c:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006780:	f9442783          	lw	a5,-108(s0)
    80006784:	000a3703          	ld	a4,0(s4)
    80006788:	974e                	add	a4,a4,s3
    8000678a:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000678e:	0792                	slli	a5,a5,0x4
    80006790:	000a3703          	ld	a4,0(s4)
    80006794:	973e                	add	a4,a4,a5
    80006796:	06090693          	addi	a3,s2,96
    8000679a:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    8000679c:	000a3703          	ld	a4,0(s4)
    800067a0:	973e                	add	a4,a4,a5
    800067a2:	40000693          	li	a3,1024
    800067a6:	c714                	sw	a3,8(a4)
  if(write)
    800067a8:	e40d19e3          	bnez	s10,800065fa <virtio_disk_rw+0xdc>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800067ac:	0001f717          	auipc	a4,0x1f
    800067b0:	85473703          	ld	a4,-1964(a4) # 80025000 <disk+0x2000>
    800067b4:	973e                	add	a4,a4,a5
    800067b6:	4689                	li	a3,2
    800067b8:	00d71623          	sh	a3,12(a4)
    800067bc:	b5b1                	j	80006608 <virtio_disk_rw+0xea>

00000000800067be <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800067be:	1101                	addi	sp,sp,-32
    800067c0:	ec06                	sd	ra,24(sp)
    800067c2:	e822                	sd	s0,16(sp)
    800067c4:	e426                	sd	s1,8(sp)
    800067c6:	e04a                	sd	s2,0(sp)
    800067c8:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800067ca:	0001f517          	auipc	a0,0x1f
    800067ce:	8de50513          	addi	a0,a0,-1826 # 800250a8 <disk+0x20a8>
    800067d2:	ffffa097          	auipc	ra,0xffffa
    800067d6:	300080e7          	jalr	768(ra) # 80000ad2 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800067da:	0001f717          	auipc	a4,0x1f
    800067de:	82670713          	addi	a4,a4,-2010 # 80025000 <disk+0x2000>
    800067e2:	02075783          	lhu	a5,32(a4)
    800067e6:	6b18                	ld	a4,16(a4)
    800067e8:	00275683          	lhu	a3,2(a4)
    800067ec:	8ebd                	xor	a3,a3,a5
    800067ee:	8a9d                	andi	a3,a3,7
    800067f0:	cab9                	beqz	a3,80006846 <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    800067f2:	0001d917          	auipc	s2,0x1d
    800067f6:	80e90913          	addi	s2,s2,-2034 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    800067fa:	0001f497          	auipc	s1,0x1f
    800067fe:	80648493          	addi	s1,s1,-2042 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    80006802:	078e                	slli	a5,a5,0x3
    80006804:	97ba                	add	a5,a5,a4
    80006806:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    80006808:	20078713          	addi	a4,a5,512
    8000680c:	0712                	slli	a4,a4,0x4
    8000680e:	974a                	add	a4,a4,s2
    80006810:	03074703          	lbu	a4,48(a4)
    80006814:	e739                	bnez	a4,80006862 <virtio_disk_intr+0xa4>
    disk.info[id].b->disk = 0;   // disk is done with buf
    80006816:	20078793          	addi	a5,a5,512
    8000681a:	0792                	slli	a5,a5,0x4
    8000681c:	97ca                	add	a5,a5,s2
    8000681e:	7798                	ld	a4,40(a5)
    80006820:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    80006824:	7788                	ld	a0,40(a5)
    80006826:	ffffc097          	auipc	ra,0xffffc
    8000682a:	20e080e7          	jalr	526(ra) # 80002a34 <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    8000682e:	0204d783          	lhu	a5,32(s1)
    80006832:	2785                	addiw	a5,a5,1
    80006834:	8b9d                	andi	a5,a5,7
    80006836:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    8000683a:	6898                	ld	a4,16(s1)
    8000683c:	00275683          	lhu	a3,2(a4)
    80006840:	8a9d                	andi	a3,a3,7
    80006842:	fcf690e3          	bne	a3,a5,80006802 <virtio_disk_intr+0x44>
  }

  release(&disk.vdisk_lock);
    80006846:	0001f517          	auipc	a0,0x1f
    8000684a:	86250513          	addi	a0,a0,-1950 # 800250a8 <disk+0x20a8>
    8000684e:	ffffa097          	auipc	ra,0xffffa
    80006852:	2d8080e7          	jalr	728(ra) # 80000b26 <release>
}
    80006856:	60e2                	ld	ra,24(sp)
    80006858:	6442                	ld	s0,16(sp)
    8000685a:	64a2                	ld	s1,8(sp)
    8000685c:	6902                	ld	s2,0(sp)
    8000685e:	6105                	addi	sp,sp,32
    80006860:	8082                	ret
      panic("virtio_disk_intr status");
    80006862:	00001517          	auipc	a0,0x1
    80006866:	0ce50513          	addi	a0,a0,206 # 80007930 <userret+0x8a0>
    8000686a:	ffffa097          	auipc	ra,0xffffa
    8000686e:	ce4080e7          	jalr	-796(ra) # 8000054e <panic>

0000000080006872 <set_rnd_seed>:
#include "defs.h"

uint32 rnd_seed = 10;

void set_rnd_seed(uint32 seed)
{
    80006872:	1141                	addi	sp,sp,-16
    80006874:	e422                	sd	s0,8(sp)
    80006876:	0800                	addi	s0,sp,16
	rnd_seed = seed;
    80006878:	00001797          	auipc	a5,0x1
    8000687c:	7ca7a223          	sw	a0,1988(a5) # 8000803c <rnd_seed>
    //printf("rnd_seed:%p\n",rnd_seed);
}
    80006880:	6422                	ld	s0,8(sp)
    80006882:	0141                	addi	sp,sp,16
    80006884:	8082                	ret

0000000080006886 <rand_int>:

uint32 rand_int(uint32 *state) //from wikipedia, lehmer random number generator
{
    80006886:	1141                	addi	sp,sp,-16
    80006888:	e422                	sd	s0,8(sp)
    8000688a:	0800                	addi	s0,sp,16
	const uint32 A = 48271;

	uint32 low  = (*state & 0x7fff) * A;			// max: 32,767 * 48,271 = 1,581,695,857 = 0x5e46c371
    8000688c:	4118                	lw	a4,0(a0)
	uint32 high = (*state >> 15)    * A;			// max: 65,535 * 48,271 = 3,163,439,985 = 0xbc8e4371
    8000688e:	00f7569b          	srliw	a3,a4,0xf
    80006892:	67b1                	lui	a5,0xc
    80006894:	c8f7861b          	addiw	a2,a5,-881
    80006898:	02c686bb          	mulw	a3,a3,a2
	uint32 low  = (*state & 0x7fff) * A;			// max: 32,767 * 48,271 = 1,581,695,857 = 0x5e46c371
    8000689c:	03171793          	slli	a5,a4,0x31
    800068a0:	93c5                	srli	a5,a5,0x31
    800068a2:	02c787bb          	mulw	a5,a5,a2
	uint32 x = low + ((high & 0xffff) << 15) + (high >> 16);	// max: 0x5e46c371 + 0x7fff8000 + 0xbc8e = 0xde46ffff
    800068a6:	0106d71b          	srliw	a4,a3,0x10
    800068aa:	9fb9                	addw	a5,a5,a4
    800068ac:	00f6969b          	slliw	a3,a3,0xf
    800068b0:	7fff8737          	lui	a4,0x7fff8
    800068b4:	8ef9                	and	a3,a3,a4
    800068b6:	9fb5                	addw	a5,a5,a3

	x = (x & 0x7fffffff) + (x >> 31);
    800068b8:	02179713          	slli	a4,a5,0x21
    800068bc:	9305                	srli	a4,a4,0x21
    800068be:	01f7d79b          	srliw	a5,a5,0x1f
    800068c2:	9fb9                	addw	a5,a5,a4
	return *state = x;
    800068c4:	c11c                	sw	a5,0(a0)
}
    800068c6:	0007851b          	sext.w	a0,a5
    800068ca:	6422                	ld	s0,8(sp)
    800068cc:	0141                	addi	sp,sp,16
    800068ce:	8082                	ret

00000000800068d0 <rand_interval>:

uint32
rand_interval(uint32 min, uint32 max)
{
    	if(max < min){
    800068d0:	04a5ec63          	bltu	a1,a0,80006928 <rand_interval+0x58>
{
    800068d4:	7179                	addi	sp,sp,-48
    800068d6:	f406                	sd	ra,40(sp)
    800068d8:	f022                	sd	s0,32(sp)
    800068da:	ec26                	sd	s1,24(sp)
    800068dc:	e84a                	sd	s2,16(sp)
    800068de:	e44e                	sd	s3,8(sp)
    800068e0:	e052                	sd	s4,0(sp)
    800068e2:	1800                	addi	s0,sp,48
    800068e4:	89aa                	mv	s3,a0
            return 0;
        }
        uint32 r;
    	const uint32 range = 1 + max - min;
    800068e6:	40a584bb          	subw	s1,a1,a0
    800068ea:	2485                	addiw	s1,s1,1
        //printf("range:%d\n",range);
     	const uint32 buckets = 0x80000000 / range;//(MAX_UINT32/2) / range;
    800068ec:	800007b7          	lui	a5,0x80000
    800068f0:	0297da3b          	divuw	s4,a5,s1
        //printf("bucket:%d\n",buckets);
     	const uint32 limit = buckets * range;
    800068f4:	034484bb          	mulw	s1,s1,s4
     	/* Create equal size buckets all in a row, then fire randomly towards
      	* the buckets until you land in one of them. All buckets are equally
      	* likely. If you land off the end of the line of buckets, try again. */
     	do
     	{   
        	 r = rand_int(&rnd_seed);
    800068f8:	00001917          	auipc	s2,0x1
    800068fc:	74490913          	addi	s2,s2,1860 # 8000803c <rnd_seed>
    80006900:	854a                	mv	a0,s2
    80006902:	00000097          	auipc	ra,0x0
    80006906:	f84080e7          	jalr	-124(ra) # 80006886 <rand_int>
    8000690a:	2501                	sext.w	a0,a0
             //printf("rnd_seed:%p\n",r);
    	 }while (r >= limit);
    8000690c:	fe957ae3          	bgeu	a0,s1,80006900 <rand_interval+0x30>
 
     	return min + (r / buckets);
    80006910:	034557bb          	divuw	a5,a0,s4
    80006914:	0137853b          	addw	a0,a5,s3
}
    80006918:	70a2                	ld	ra,40(sp)
    8000691a:	7402                	ld	s0,32(sp)
    8000691c:	64e2                	ld	s1,24(sp)
    8000691e:	6942                	ld	s2,16(sp)
    80006920:	69a2                	ld	s3,8(sp)
    80006922:	6a02                	ld	s4,0(sp)
    80006924:	6145                	addi	sp,sp,48
    80006926:	8082                	ret
            return 0;
    80006928:	4501                	li	a0,0
}
    8000692a:	8082                	ret
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
