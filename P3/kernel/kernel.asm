
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
    80000060:	bb478793          	addi	a5,a5,-1100 # 80005c10 <timervec>
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
    80000140:	00002097          	auipc	ra,0x2
    80000144:	97e080e7          	jalr	-1666(ra) # 80001abe <myproc>
    80000148:	591c                	lw	a5,48(a0)
    8000014a:	e7b5                	bnez	a5,800001b6 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000014c:	85ce                	mv	a1,s3
    8000014e:	854a                	mv	a0,s2
    80000150:	00002097          	auipc	ra,0x2
    80000154:	114080e7          	jalr	276(ra) # 80002264 <sleep>
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
    80000190:	338080e7          	jalr	824(ra) # 800024c4 <either_copyout>
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
    80000290:	28e080e7          	jalr	654(ra) # 8000251a <either_copyin>
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
    80000306:	26e080e7          	jalr	622(ra) # 80002570 <procdump>
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
    8000045a:	f94080e7          	jalr	-108(ra) # 800023ea <wakeup>
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
    8000048c:	5b878793          	addi	a5,a5,1464 # 80021a40 <devsw>
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
    800004ce:	46e60613          	addi	a2,a2,1134 # 80007938 <digits>
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
    80000580:	f0c50513          	addi	a0,a0,-244 # 80007488 <userret+0x3f8>
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
    800005fa:	342b8b93          	addi	s7,s7,834 # 80007938 <digits>
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
    800009f2:	0b4080e7          	jalr	180(ra) # 80001aa2 <mycpu>
    800009f6:	5d3c                	lw	a5,120(a0)
    800009f8:	cf89                	beqz	a5,80000a12 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800009fa:	00001097          	auipc	ra,0x1
    800009fe:	0a8080e7          	jalr	168(ra) # 80001aa2 <mycpu>
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
    80000a16:	090080e7          	jalr	144(ra) # 80001aa2 <mycpu>
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
    80000a2e:	078080e7          	jalr	120(ra) # 80001aa2 <mycpu>
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
    80000ac6:	fe0080e7          	jalr	-32(ra) # 80001aa2 <mycpu>
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
    80000b06:	fa0080e7          	jalr	-96(ra) # 80001aa2 <mycpu>
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
    80000d2c:	d6a080e7          	jalr	-662(ra) # 80001a92 <cpuid>
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
    80000d48:	d4e080e7          	jalr	-690(ra) # 80001a92 <cpuid>
    80000d4c:	85aa                	mv	a1,a0
    80000d4e:	00006517          	auipc	a0,0x6
    80000d52:	45250513          	addi	a0,a0,1106 # 800071a0 <userret+0x110>
    80000d56:	00000097          	auipc	ra,0x0
    80000d5a:	842080e7          	jalr	-1982(ra) # 80000598 <printf>
    kvminithart();    // turn on paging
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	142080e7          	jalr	322(ra) # 80000ea0 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000d66:	00002097          	auipc	ra,0x2
    80000d6a:	94a080e7          	jalr	-1718(ra) # 800026b0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000d6e:	00005097          	auipc	ra,0x5
    80000d72:	ee2080e7          	jalr	-286(ra) # 80005c50 <plicinithart>
  }
   scheduler();        
    80000d76:	00001097          	auipc	ra,0x1
    80000d7a:	226080e7          	jalr	550(ra) # 80001f9c <scheduler>
    consoleinit();
    80000d7e:	fffff097          	auipc	ra,0xfffff
    80000d82:	6e2080e7          	jalr	1762(ra) # 80000460 <consoleinit>
    printfinit();
    80000d86:	00000097          	auipc	ra,0x0
    80000d8a:	9f8080e7          	jalr	-1544(ra) # 8000077e <printfinit>
    printf("\n");
    80000d8e:	00006517          	auipc	a0,0x6
    80000d92:	6fa50513          	addi	a0,a0,1786 # 80007488 <userret+0x3f8>
    80000d96:	00000097          	auipc	ra,0x0
    80000d9a:	802080e7          	jalr	-2046(ra) # 80000598 <printf>
    printf("xv6 kernel is booting\n");
    80000d9e:	00006517          	auipc	a0,0x6
    80000da2:	3ea50513          	addi	a0,a0,1002 # 80007188 <userret+0xf8>
    80000da6:	fffff097          	auipc	ra,0xfffff
    80000daa:	7f2080e7          	jalr	2034(ra) # 80000598 <printf>
    printf("\n");
    80000dae:	00006517          	auipc	a0,0x6
    80000db2:	6da50513          	addi	a0,a0,1754 # 80007488 <userret+0x3f8>
    80000db6:	fffff097          	auipc	ra,0xfffff
    80000dba:	7e2080e7          	jalr	2018(ra) # 80000598 <printf>
    kinit();         // physical page allocator
    80000dbe:	00000097          	auipc	ra,0x0
    80000dc2:	b66080e7          	jalr	-1178(ra) # 80000924 <kinit>
    kvminit();       // create kernel page table
    80000dc6:	00000097          	auipc	ra,0x0
    80000dca:	30a080e7          	jalr	778(ra) # 800010d0 <kvminit>
    kvminithart();   // turn on paging
    80000dce:	00000097          	auipc	ra,0x0
    80000dd2:	0d2080e7          	jalr	210(ra) # 80000ea0 <kvminithart>
    procinit();      // process table
    80000dd6:	00001097          	auipc	ra,0x1
    80000dda:	bec080e7          	jalr	-1044(ra) # 800019c2 <procinit>
    trapinit();      // trap vectors
    80000dde:	00002097          	auipc	ra,0x2
    80000de2:	8aa080e7          	jalr	-1878(ra) # 80002688 <trapinit>
    trapinithart();  // install kernel trap vector
    80000de6:	00002097          	auipc	ra,0x2
    80000dea:	8ca080e7          	jalr	-1846(ra) # 800026b0 <trapinithart>
    plicinit();      // set up interrupt controller
    80000dee:	00005097          	auipc	ra,0x5
    80000df2:	e4c080e7          	jalr	-436(ra) # 80005c3a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000df6:	00005097          	auipc	ra,0x5
    80000dfa:	e5a080e7          	jalr	-422(ra) # 80005c50 <plicinithart>
    binit();         // buffer cache
    80000dfe:	00002097          	auipc	ra,0x2
    80000e02:	02e080e7          	jalr	46(ra) # 80002e2c <binit>
    iinit();         // inode cache
    80000e06:	00002097          	auipc	ra,0x2
    80000e0a:	6be080e7          	jalr	1726(ra) # 800034c4 <iinit>
    fileinit();      // file table
    80000e0e:	00003097          	auipc	ra,0x3
    80000e12:	632080e7          	jalr	1586(ra) # 80004440 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	f54080e7          	jalr	-172(ra) # 80005d6a <virtio_disk_init>
    userinit();      // first user process
    80000e1e:	00001097          	auipc	ra,0x1
    80000e22:	f18080e7          	jalr	-232(ra) # 80001d36 <userinit>
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
    80000e64:	03248163          	beq	s1,s2,80000e86 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000e68:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000e6a:	00f57793          	andi	a5,a0,15
    80000e6e:	ff3782e3          	beq	a5,s3,80000e52 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000e72:	8905                	andi	a0,a0,1
    80000e74:	d57d                	beqz	a0,80000e62 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000e76:	00006517          	auipc	a0,0x6
    80000e7a:	34250513          	addi	a0,a0,834 # 800071b8 <userret+0x128>
    80000e7e:	fffff097          	auipc	ra,0xfffff
    80000e82:	6d0080e7          	jalr	1744(ra) # 8000054e <panic>
    }
  }
  kfree((void*)pagetable);
    80000e86:	8552                	mv	a0,s4
    80000e88:	00000097          	auipc	ra,0x0
    80000e8c:	9dc080e7          	jalr	-1572(ra) # 80000864 <kfree>
}
    80000e90:	70a2                	ld	ra,40(sp)
    80000e92:	7402                	ld	s0,32(sp)
    80000e94:	64e2                	ld	s1,24(sp)
    80000e96:	6942                	ld	s2,16(sp)
    80000e98:	69a2                	ld	s3,8(sp)
    80000e9a:	6a02                	ld	s4,0(sp)
    80000e9c:	6145                	addi	sp,sp,48
    80000e9e:	8082                	ret

0000000080000ea0 <kvminithart>:
{
    80000ea0:	1141                	addi	sp,sp,-16
    80000ea2:	e422                	sd	s0,8(sp)
    80000ea4:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000ea6:	00025797          	auipc	a5,0x25
    80000eaa:	1627b783          	ld	a5,354(a5) # 80026008 <kernel_pagetable>
    80000eae:	83b1                	srli	a5,a5,0xc
    80000eb0:	577d                	li	a4,-1
    80000eb2:	177e                	slli	a4,a4,0x3f
    80000eb4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000eb6:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000eba:	12000073          	sfence.vma
}
    80000ebe:	6422                	ld	s0,8(sp)
    80000ec0:	0141                	addi	sp,sp,16
    80000ec2:	8082                	ret

0000000080000ec4 <walk>:
{
    80000ec4:	7139                	addi	sp,sp,-64
    80000ec6:	fc06                	sd	ra,56(sp)
    80000ec8:	f822                	sd	s0,48(sp)
    80000eca:	f426                	sd	s1,40(sp)
    80000ecc:	f04a                	sd	s2,32(sp)
    80000ece:	ec4e                	sd	s3,24(sp)
    80000ed0:	e852                	sd	s4,16(sp)
    80000ed2:	e456                	sd	s5,8(sp)
    80000ed4:	e05a                	sd	s6,0(sp)
    80000ed6:	0080                	addi	s0,sp,64
    80000ed8:	84aa                	mv	s1,a0
    80000eda:	89ae                	mv	s3,a1
    80000edc:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000ede:	57fd                	li	a5,-1
    80000ee0:	83e9                	srli	a5,a5,0x1a
    80000ee2:	4a79                	li	s4,30
  for(int level = 2; level > 0; level--) {
    80000ee4:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000ee6:	04b7f263          	bgeu	a5,a1,80000f2a <walk+0x66>
    panic("walk");
    80000eea:	00006517          	auipc	a0,0x6
    80000eee:	2de50513          	addi	a0,a0,734 # 800071c8 <userret+0x138>
    80000ef2:	fffff097          	auipc	ra,0xfffff
    80000ef6:	65c080e7          	jalr	1628(ra) # 8000054e <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000efa:	060a8663          	beqz	s5,80000f66 <walk+0xa2>
    80000efe:	00000097          	auipc	ra,0x0
    80000f02:	a62080e7          	jalr	-1438(ra) # 80000960 <kalloc>
    80000f06:	84aa                	mv	s1,a0
    80000f08:	c529                	beqz	a0,80000f52 <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    80000f0a:	6605                	lui	a2,0x1
    80000f0c:	4581                	li	a1,0
    80000f0e:	00000097          	auipc	ra,0x0
    80000f12:	c60080e7          	jalr	-928(ra) # 80000b6e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f16:	00c4d793          	srli	a5,s1,0xc
    80000f1a:	07aa                	slli	a5,a5,0xa
    80000f1c:	0017e793          	ori	a5,a5,1
    80000f20:	00f93023          	sd	a5,0(s2) # 1000 <_entry-0x7ffff000>
  for(int level = 2; level > 0; level--) {
    80000f24:	3a5d                	addiw	s4,s4,-9
    80000f26:	036a0063          	beq	s4,s6,80000f46 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f2a:	0149d933          	srl	s2,s3,s4
    80000f2e:	1ff97913          	andi	s2,s2,511
    80000f32:	090e                	slli	s2,s2,0x3
    80000f34:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f36:	00093483          	ld	s1,0(s2)
    80000f3a:	0014f793          	andi	a5,s1,1
    80000f3e:	dfd5                	beqz	a5,80000efa <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f40:	80a9                	srli	s1,s1,0xa
    80000f42:	04b2                	slli	s1,s1,0xc
    80000f44:	b7c5                	j	80000f24 <walk+0x60>
  return &pagetable[PX(0, va)];
    80000f46:	00c9d513          	srli	a0,s3,0xc
    80000f4a:	1ff57513          	andi	a0,a0,511
    80000f4e:	050e                	slli	a0,a0,0x3
    80000f50:	9526                	add	a0,a0,s1
}
    80000f52:	70e2                	ld	ra,56(sp)
    80000f54:	7442                	ld	s0,48(sp)
    80000f56:	74a2                	ld	s1,40(sp)
    80000f58:	7902                	ld	s2,32(sp)
    80000f5a:	69e2                	ld	s3,24(sp)
    80000f5c:	6a42                	ld	s4,16(sp)
    80000f5e:	6aa2                	ld	s5,8(sp)
    80000f60:	6b02                	ld	s6,0(sp)
    80000f62:	6121                	addi	sp,sp,64
    80000f64:	8082                	ret
        return 0;
    80000f66:	4501                	li	a0,0
    80000f68:	b7ed                	j	80000f52 <walk+0x8e>

0000000080000f6a <walkaddr>:
  if(va >= MAXVA)
    80000f6a:	57fd                	li	a5,-1
    80000f6c:	83e9                	srli	a5,a5,0x1a
    80000f6e:	00b7f463          	bgeu	a5,a1,80000f76 <walkaddr+0xc>
    return 0;
    80000f72:	4501                	li	a0,0
}
    80000f74:	8082                	ret
{
    80000f76:	1141                	addi	sp,sp,-16
    80000f78:	e406                	sd	ra,8(sp)
    80000f7a:	e022                	sd	s0,0(sp)
    80000f7c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000f7e:	4601                	li	a2,0
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	f44080e7          	jalr	-188(ra) # 80000ec4 <walk>
  if(pte == 0)
    80000f88:	c105                	beqz	a0,80000fa8 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000f8a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000f8c:	0117f693          	andi	a3,a5,17
    80000f90:	4745                	li	a4,17
    return 0;
    80000f92:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000f94:	00e68663          	beq	a3,a4,80000fa0 <walkaddr+0x36>
}
    80000f98:	60a2                	ld	ra,8(sp)
    80000f9a:	6402                	ld	s0,0(sp)
    80000f9c:	0141                	addi	sp,sp,16
    80000f9e:	8082                	ret
  pa = PTE2PA(*pte);
    80000fa0:	00a7d513          	srli	a0,a5,0xa
    80000fa4:	0532                	slli	a0,a0,0xc
  return pa;
    80000fa6:	bfcd                	j	80000f98 <walkaddr+0x2e>
    return 0;
    80000fa8:	4501                	li	a0,0
    80000faa:	b7fd                	j	80000f98 <walkaddr+0x2e>

0000000080000fac <kvmpa>:
{
    80000fac:	1101                	addi	sp,sp,-32
    80000fae:	ec06                	sd	ra,24(sp)
    80000fb0:	e822                	sd	s0,16(sp)
    80000fb2:	e426                	sd	s1,8(sp)
    80000fb4:	1000                	addi	s0,sp,32
    80000fb6:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    80000fb8:	1552                	slli	a0,a0,0x34
    80000fba:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    80000fbe:	4601                	li	a2,0
    80000fc0:	00025517          	auipc	a0,0x25
    80000fc4:	04853503          	ld	a0,72(a0) # 80026008 <kernel_pagetable>
    80000fc8:	00000097          	auipc	ra,0x0
    80000fcc:	efc080e7          	jalr	-260(ra) # 80000ec4 <walk>
  if(pte == 0)
    80000fd0:	cd09                	beqz	a0,80000fea <kvmpa+0x3e>
  if((*pte & PTE_V) == 0)
    80000fd2:	6108                	ld	a0,0(a0)
    80000fd4:	00157793          	andi	a5,a0,1
    80000fd8:	c38d                	beqz	a5,80000ffa <kvmpa+0x4e>
  pa = PTE2PA(*pte);
    80000fda:	8129                	srli	a0,a0,0xa
    80000fdc:	0532                	slli	a0,a0,0xc
}
    80000fde:	9526                	add	a0,a0,s1
    80000fe0:	60e2                	ld	ra,24(sp)
    80000fe2:	6442                	ld	s0,16(sp)
    80000fe4:	64a2                	ld	s1,8(sp)
    80000fe6:	6105                	addi	sp,sp,32
    80000fe8:	8082                	ret
    panic("kvmpa");
    80000fea:	00006517          	auipc	a0,0x6
    80000fee:	1e650513          	addi	a0,a0,486 # 800071d0 <userret+0x140>
    80000ff2:	fffff097          	auipc	ra,0xfffff
    80000ff6:	55c080e7          	jalr	1372(ra) # 8000054e <panic>
    panic("kvmpa");
    80000ffa:	00006517          	auipc	a0,0x6
    80000ffe:	1d650513          	addi	a0,a0,470 # 800071d0 <userret+0x140>
    80001002:	fffff097          	auipc	ra,0xfffff
    80001006:	54c080e7          	jalr	1356(ra) # 8000054e <panic>

000000008000100a <mappages>:
{
    8000100a:	715d                	addi	sp,sp,-80
    8000100c:	e486                	sd	ra,72(sp)
    8000100e:	e0a2                	sd	s0,64(sp)
    80001010:	fc26                	sd	s1,56(sp)
    80001012:	f84a                	sd	s2,48(sp)
    80001014:	f44e                	sd	s3,40(sp)
    80001016:	f052                	sd	s4,32(sp)
    80001018:	ec56                	sd	s5,24(sp)
    8000101a:	e85a                	sd	s6,16(sp)
    8000101c:	e45e                	sd	s7,8(sp)
    8000101e:	0880                	addi	s0,sp,80
    80001020:	8aaa                	mv	s5,a0
    80001022:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    80001024:	777d                	lui	a4,0xfffff
    80001026:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000102a:	167d                	addi	a2,a2,-1
    8000102c:	00b609b3          	add	s3,a2,a1
    80001030:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001034:	893e                	mv	s2,a5
    80001036:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    8000103a:	6b85                	lui	s7,0x1
    8000103c:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001040:	4605                	li	a2,1
    80001042:	85ca                	mv	a1,s2
    80001044:	8556                	mv	a0,s5
    80001046:	00000097          	auipc	ra,0x0
    8000104a:	e7e080e7          	jalr	-386(ra) # 80000ec4 <walk>
    8000104e:	c51d                	beqz	a0,8000107c <mappages+0x72>
    if(*pte & PTE_V)
    80001050:	611c                	ld	a5,0(a0)
    80001052:	8b85                	andi	a5,a5,1
    80001054:	ef81                	bnez	a5,8000106c <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001056:	80b1                	srli	s1,s1,0xc
    80001058:	04aa                	slli	s1,s1,0xa
    8000105a:	0164e4b3          	or	s1,s1,s6
    8000105e:	0014e493          	ori	s1,s1,1
    80001062:	e104                	sd	s1,0(a0)
    if(a == last)
    80001064:	03390863          	beq	s2,s3,80001094 <mappages+0x8a>
    a += PGSIZE;
    80001068:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000106a:	bfc9                	j	8000103c <mappages+0x32>
      panic("remap");
    8000106c:	00006517          	auipc	a0,0x6
    80001070:	16c50513          	addi	a0,a0,364 # 800071d8 <userret+0x148>
    80001074:	fffff097          	auipc	ra,0xfffff
    80001078:	4da080e7          	jalr	1242(ra) # 8000054e <panic>
      return -1;
    8000107c:	557d                	li	a0,-1
}
    8000107e:	60a6                	ld	ra,72(sp)
    80001080:	6406                	ld	s0,64(sp)
    80001082:	74e2                	ld	s1,56(sp)
    80001084:	7942                	ld	s2,48(sp)
    80001086:	79a2                	ld	s3,40(sp)
    80001088:	7a02                	ld	s4,32(sp)
    8000108a:	6ae2                	ld	s5,24(sp)
    8000108c:	6b42                	ld	s6,16(sp)
    8000108e:	6ba2                	ld	s7,8(sp)
    80001090:	6161                	addi	sp,sp,80
    80001092:	8082                	ret
  return 0;
    80001094:	4501                	li	a0,0
    80001096:	b7e5                	j	8000107e <mappages+0x74>

0000000080001098 <kvmmap>:
{
    80001098:	1141                	addi	sp,sp,-16
    8000109a:	e406                	sd	ra,8(sp)
    8000109c:	e022                	sd	s0,0(sp)
    8000109e:	0800                	addi	s0,sp,16
    800010a0:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800010a2:	86ae                	mv	a3,a1
    800010a4:	85aa                	mv	a1,a0
    800010a6:	00025517          	auipc	a0,0x25
    800010aa:	f6253503          	ld	a0,-158(a0) # 80026008 <kernel_pagetable>
    800010ae:	00000097          	auipc	ra,0x0
    800010b2:	f5c080e7          	jalr	-164(ra) # 8000100a <mappages>
    800010b6:	e509                	bnez	a0,800010c0 <kvmmap+0x28>
}
    800010b8:	60a2                	ld	ra,8(sp)
    800010ba:	6402                	ld	s0,0(sp)
    800010bc:	0141                	addi	sp,sp,16
    800010be:	8082                	ret
    panic("kvmmap");
    800010c0:	00006517          	auipc	a0,0x6
    800010c4:	12050513          	addi	a0,a0,288 # 800071e0 <userret+0x150>
    800010c8:	fffff097          	auipc	ra,0xfffff
    800010cc:	486080e7          	jalr	1158(ra) # 8000054e <panic>

00000000800010d0 <kvminit>:
{
    800010d0:	1101                	addi	sp,sp,-32
    800010d2:	ec06                	sd	ra,24(sp)
    800010d4:	e822                	sd	s0,16(sp)
    800010d6:	e426                	sd	s1,8(sp)
    800010d8:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    800010da:	00000097          	auipc	ra,0x0
    800010de:	886080e7          	jalr	-1914(ra) # 80000960 <kalloc>
    800010e2:	00025797          	auipc	a5,0x25
    800010e6:	f2a7b323          	sd	a0,-218(a5) # 80026008 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    800010ea:	6605                	lui	a2,0x1
    800010ec:	4581                	li	a1,0
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	a80080e7          	jalr	-1408(ra) # 80000b6e <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800010f6:	4699                	li	a3,6
    800010f8:	6605                	lui	a2,0x1
    800010fa:	100005b7          	lui	a1,0x10000
    800010fe:	10000537          	lui	a0,0x10000
    80001102:	00000097          	auipc	ra,0x0
    80001106:	f96080e7          	jalr	-106(ra) # 80001098 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000110a:	4699                	li	a3,6
    8000110c:	6605                	lui	a2,0x1
    8000110e:	100015b7          	lui	a1,0x10001
    80001112:	10001537          	lui	a0,0x10001
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	f82080e7          	jalr	-126(ra) # 80001098 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    8000111e:	4699                	li	a3,6
    80001120:	6641                	lui	a2,0x10
    80001122:	020005b7          	lui	a1,0x2000
    80001126:	02000537          	lui	a0,0x2000
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f6e080e7          	jalr	-146(ra) # 80001098 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001132:	4699                	li	a3,6
    80001134:	00400637          	lui	a2,0x400
    80001138:	0c0005b7          	lui	a1,0xc000
    8000113c:	0c000537          	lui	a0,0xc000
    80001140:	00000097          	auipc	ra,0x0
    80001144:	f58080e7          	jalr	-168(ra) # 80001098 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001148:	00007497          	auipc	s1,0x7
    8000114c:	eb848493          	addi	s1,s1,-328 # 80008000 <initcode>
    80001150:	46a9                	li	a3,10
    80001152:	80007617          	auipc	a2,0x80007
    80001156:	eae60613          	addi	a2,a2,-338 # 8000 <_entry-0x7fff8000>
    8000115a:	4585                	li	a1,1
    8000115c:	05fe                	slli	a1,a1,0x1f
    8000115e:	852e                	mv	a0,a1
    80001160:	00000097          	auipc	ra,0x0
    80001164:	f38080e7          	jalr	-200(ra) # 80001098 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001168:	4699                	li	a3,6
    8000116a:	4645                	li	a2,17
    8000116c:	066e                	slli	a2,a2,0x1b
    8000116e:	8e05                	sub	a2,a2,s1
    80001170:	85a6                	mv	a1,s1
    80001172:	8526                	mv	a0,s1
    80001174:	00000097          	auipc	ra,0x0
    80001178:	f24080e7          	jalr	-220(ra) # 80001098 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000117c:	46a9                	li	a3,10
    8000117e:	6605                	lui	a2,0x1
    80001180:	00006597          	auipc	a1,0x6
    80001184:	e8058593          	addi	a1,a1,-384 # 80007000 <trampoline>
    80001188:	04000537          	lui	a0,0x4000
    8000118c:	157d                	addi	a0,a0,-1
    8000118e:	0532                	slli	a0,a0,0xc
    80001190:	00000097          	auipc	ra,0x0
    80001194:	f08080e7          	jalr	-248(ra) # 80001098 <kvmmap>
}
    80001198:	60e2                	ld	ra,24(sp)
    8000119a:	6442                	ld	s0,16(sp)
    8000119c:	64a2                	ld	s1,8(sp)
    8000119e:	6105                	addi	sp,sp,32
    800011a0:	8082                	ret

00000000800011a2 <uvmunmap>:
{
    800011a2:	715d                	addi	sp,sp,-80
    800011a4:	e486                	sd	ra,72(sp)
    800011a6:	e0a2                	sd	s0,64(sp)
    800011a8:	fc26                	sd	s1,56(sp)
    800011aa:	f84a                	sd	s2,48(sp)
    800011ac:	f44e                	sd	s3,40(sp)
    800011ae:	f052                	sd	s4,32(sp)
    800011b0:	ec56                	sd	s5,24(sp)
    800011b2:	e85a                	sd	s6,16(sp)
    800011b4:	e45e                	sd	s7,8(sp)
    800011b6:	0880                	addi	s0,sp,80
    800011b8:	8a2a                	mv	s4,a0
    800011ba:	8ab6                	mv	s5,a3
  a = PGROUNDDOWN(va);
    800011bc:	77fd                	lui	a5,0xfffff
    800011be:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800011c2:	167d                	addi	a2,a2,-1
    800011c4:	00b609b3          	add	s3,a2,a1
    800011c8:	00f9f9b3          	and	s3,s3,a5
    if(PTE_FLAGS(*pte) == PTE_V)
    800011cc:	4b05                	li	s6,1
    a += PGSIZE;
    800011ce:	6b85                	lui	s7,0x1
    800011d0:	a0a1                	j	80001218 <uvmunmap+0x76>
      panic("uvmunmap: walk");
    800011d2:	00006517          	auipc	a0,0x6
    800011d6:	01650513          	addi	a0,a0,22 # 800071e8 <userret+0x158>
    800011da:	fffff097          	auipc	ra,0xfffff
    800011de:	374080e7          	jalr	884(ra) # 8000054e <panic>
      panic("uvmunmap: not mapped");
    800011e2:	00006517          	auipc	a0,0x6
    800011e6:	01650513          	addi	a0,a0,22 # 800071f8 <userret+0x168>
    800011ea:	fffff097          	auipc	ra,0xfffff
    800011ee:	364080e7          	jalr	868(ra) # 8000054e <panic>
      panic("uvmunmap: not a leaf");
    800011f2:	00006517          	auipc	a0,0x6
    800011f6:	01e50513          	addi	a0,a0,30 # 80007210 <userret+0x180>
    800011fa:	fffff097          	auipc	ra,0xfffff
    800011fe:	354080e7          	jalr	852(ra) # 8000054e <panic>
      pa = PTE2PA(*pte);
    80001202:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001204:	0532                	slli	a0,a0,0xc
    80001206:	fffff097          	auipc	ra,0xfffff
    8000120a:	65e080e7          	jalr	1630(ra) # 80000864 <kfree>
    *pte = 0;
    8000120e:	0004b023          	sd	zero,0(s1)
    if(a == last)
    80001212:	03390763          	beq	s2,s3,80001240 <uvmunmap+0x9e>
    a += PGSIZE;
    80001216:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 0)) == 0)
    80001218:	4601                	li	a2,0
    8000121a:	85ca                	mv	a1,s2
    8000121c:	8552                	mv	a0,s4
    8000121e:	00000097          	auipc	ra,0x0
    80001222:	ca6080e7          	jalr	-858(ra) # 80000ec4 <walk>
    80001226:	84aa                	mv	s1,a0
    80001228:	d54d                	beqz	a0,800011d2 <uvmunmap+0x30>
    if((*pte & PTE_V) == 0){
    8000122a:	6108                	ld	a0,0(a0)
    8000122c:	00157793          	andi	a5,a0,1
    80001230:	dbcd                	beqz	a5,800011e2 <uvmunmap+0x40>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001232:	3ff57793          	andi	a5,a0,1023
    80001236:	fb678ee3          	beq	a5,s6,800011f2 <uvmunmap+0x50>
    if(do_free){
    8000123a:	fc0a8ae3          	beqz	s5,8000120e <uvmunmap+0x6c>
    8000123e:	b7d1                	j	80001202 <uvmunmap+0x60>
}
    80001240:	60a6                	ld	ra,72(sp)
    80001242:	6406                	ld	s0,64(sp)
    80001244:	74e2                	ld	s1,56(sp)
    80001246:	7942                	ld	s2,48(sp)
    80001248:	79a2                	ld	s3,40(sp)
    8000124a:	7a02                	ld	s4,32(sp)
    8000124c:	6ae2                	ld	s5,24(sp)
    8000124e:	6b42                	ld	s6,16(sp)
    80001250:	6ba2                	ld	s7,8(sp)
    80001252:	6161                	addi	sp,sp,80
    80001254:	8082                	ret

0000000080001256 <uvmcreate>:
{
    80001256:	1101                	addi	sp,sp,-32
    80001258:	ec06                	sd	ra,24(sp)
    8000125a:	e822                	sd	s0,16(sp)
    8000125c:	e426                	sd	s1,8(sp)
    8000125e:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    80001260:	fffff097          	auipc	ra,0xfffff
    80001264:	700080e7          	jalr	1792(ra) # 80000960 <kalloc>
  if(pagetable == 0)
    80001268:	cd11                	beqz	a0,80001284 <uvmcreate+0x2e>
    8000126a:	84aa                	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
    8000126c:	6605                	lui	a2,0x1
    8000126e:	4581                	li	a1,0
    80001270:	00000097          	auipc	ra,0x0
    80001274:	8fe080e7          	jalr	-1794(ra) # 80000b6e <memset>
}
    80001278:	8526                	mv	a0,s1
    8000127a:	60e2                	ld	ra,24(sp)
    8000127c:	6442                	ld	s0,16(sp)
    8000127e:	64a2                	ld	s1,8(sp)
    80001280:	6105                	addi	sp,sp,32
    80001282:	8082                	ret
    panic("uvmcreate: out of memory");
    80001284:	00006517          	auipc	a0,0x6
    80001288:	fa450513          	addi	a0,a0,-92 # 80007228 <userret+0x198>
    8000128c:	fffff097          	auipc	ra,0xfffff
    80001290:	2c2080e7          	jalr	706(ra) # 8000054e <panic>

0000000080001294 <uvminit>:
{
    80001294:	7179                	addi	sp,sp,-48
    80001296:	f406                	sd	ra,40(sp)
    80001298:	f022                	sd	s0,32(sp)
    8000129a:	ec26                	sd	s1,24(sp)
    8000129c:	e84a                	sd	s2,16(sp)
    8000129e:	e44e                	sd	s3,8(sp)
    800012a0:	e052                	sd	s4,0(sp)
    800012a2:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    800012a4:	6785                	lui	a5,0x1
    800012a6:	04f67863          	bgeu	a2,a5,800012f6 <uvminit+0x62>
    800012aa:	8a2a                	mv	s4,a0
    800012ac:	89ae                	mv	s3,a1
    800012ae:	84b2                	mv	s1,a2
  mem = kalloc();
    800012b0:	fffff097          	auipc	ra,0xfffff
    800012b4:	6b0080e7          	jalr	1712(ra) # 80000960 <kalloc>
    800012b8:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012ba:	6605                	lui	a2,0x1
    800012bc:	4581                	li	a1,0
    800012be:	00000097          	auipc	ra,0x0
    800012c2:	8b0080e7          	jalr	-1872(ra) # 80000b6e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012c6:	4779                	li	a4,30
    800012c8:	86ca                	mv	a3,s2
    800012ca:	6605                	lui	a2,0x1
    800012cc:	4581                	li	a1,0
    800012ce:	8552                	mv	a0,s4
    800012d0:	00000097          	auipc	ra,0x0
    800012d4:	d3a080e7          	jalr	-710(ra) # 8000100a <mappages>
  memmove(mem, src, sz);
    800012d8:	8626                	mv	a2,s1
    800012da:	85ce                	mv	a1,s3
    800012dc:	854a                	mv	a0,s2
    800012de:	00000097          	auipc	ra,0x0
    800012e2:	8f0080e7          	jalr	-1808(ra) # 80000bce <memmove>
}
    800012e6:	70a2                	ld	ra,40(sp)
    800012e8:	7402                	ld	s0,32(sp)
    800012ea:	64e2                	ld	s1,24(sp)
    800012ec:	6942                	ld	s2,16(sp)
    800012ee:	69a2                	ld	s3,8(sp)
    800012f0:	6a02                	ld	s4,0(sp)
    800012f2:	6145                	addi	sp,sp,48
    800012f4:	8082                	ret
    panic("inituvm: more than a page");
    800012f6:	00006517          	auipc	a0,0x6
    800012fa:	f5250513          	addi	a0,a0,-174 # 80007248 <userret+0x1b8>
    800012fe:	fffff097          	auipc	ra,0xfffff
    80001302:	250080e7          	jalr	592(ra) # 8000054e <panic>

0000000080001306 <uvmdealloc>:
{
    80001306:	1101                	addi	sp,sp,-32
    80001308:	ec06                	sd	ra,24(sp)
    8000130a:	e822                	sd	s0,16(sp)
    8000130c:	e426                	sd	s1,8(sp)
    8000130e:	1000                	addi	s0,sp,32
    return oldsz;
    80001310:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001312:	00b67d63          	bgeu	a2,a1,8000132c <uvmdealloc+0x26>
    80001316:	84b2                	mv	s1,a2
  uint64 newup = PGROUNDUP(newsz);
    80001318:	6785                	lui	a5,0x1
    8000131a:	17fd                	addi	a5,a5,-1
    8000131c:	00f60733          	add	a4,a2,a5
    80001320:	76fd                	lui	a3,0xfffff
    80001322:	8f75                	and	a4,a4,a3
  if(newup < PGROUNDUP(oldsz)){
    80001324:	97ae                	add	a5,a5,a1
    80001326:	8ff5                	and	a5,a5,a3
    80001328:	00f76863          	bltu	a4,a5,80001338 <uvmdealloc+0x32>
}
    8000132c:	8526                	mv	a0,s1
    8000132e:	60e2                	ld	ra,24(sp)
    80001330:	6442                	ld	s0,16(sp)
    80001332:	64a2                	ld	s1,8(sp)
    80001334:	6105                	addi	sp,sp,32
    80001336:	8082                	ret
    uvmunmap(pagetable, newup, oldsz - newup, 1);
    80001338:	4685                	li	a3,1
    8000133a:	40e58633          	sub	a2,a1,a4
    8000133e:	85ba                	mv	a1,a4
    80001340:	00000097          	auipc	ra,0x0
    80001344:	e62080e7          	jalr	-414(ra) # 800011a2 <uvmunmap>
    80001348:	b7d5                	j	8000132c <uvmdealloc+0x26>

000000008000134a <uvmalloc>:
  if(newsz < oldsz)
    8000134a:	0ab66163          	bltu	a2,a1,800013ec <uvmalloc+0xa2>
{
    8000134e:	7139                	addi	sp,sp,-64
    80001350:	fc06                	sd	ra,56(sp)
    80001352:	f822                	sd	s0,48(sp)
    80001354:	f426                	sd	s1,40(sp)
    80001356:	f04a                	sd	s2,32(sp)
    80001358:	ec4e                	sd	s3,24(sp)
    8000135a:	e852                	sd	s4,16(sp)
    8000135c:	e456                	sd	s5,8(sp)
    8000135e:	0080                	addi	s0,sp,64
    80001360:	8aaa                	mv	s5,a0
    80001362:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);  //PGROUNDUP(sz)  (((sz)+PGSIZE-1) & ~(PGSIZE-1))
    80001364:	6985                	lui	s3,0x1
    80001366:	19fd                	addi	s3,s3,-1
    80001368:	95ce                	add	a1,a1,s3
    8000136a:	79fd                	lui	s3,0xfffff
    8000136c:	0135f9b3          	and	s3,a1,s3
  for(; a < newsz; a += PGSIZE){
    80001370:	08c9f063          	bgeu	s3,a2,800013f0 <uvmalloc+0xa6>
  a = oldsz;
    80001374:	894e                	mv	s2,s3
    mem = kalloc();
    80001376:	fffff097          	auipc	ra,0xfffff
    8000137a:	5ea080e7          	jalr	1514(ra) # 80000960 <kalloc>
    8000137e:	84aa                	mv	s1,a0
    if(mem == 0){
    80001380:	c51d                	beqz	a0,800013ae <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001382:	6605                	lui	a2,0x1
    80001384:	4581                	li	a1,0
    80001386:	fffff097          	auipc	ra,0xfffff
    8000138a:	7e8080e7          	jalr	2024(ra) # 80000b6e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){  //mappages(pagetable, va, sz, pa, perm)
    8000138e:	4779                	li	a4,30
    80001390:	86a6                	mv	a3,s1
    80001392:	6605                	lui	a2,0x1
    80001394:	85ca                	mv	a1,s2
    80001396:	8556                	mv	a0,s5
    80001398:	00000097          	auipc	ra,0x0
    8000139c:	c72080e7          	jalr	-910(ra) # 8000100a <mappages>
    800013a0:	e905                	bnez	a0,800013d0 <uvmalloc+0x86>
  for(; a < newsz; a += PGSIZE){
    800013a2:	6785                	lui	a5,0x1
    800013a4:	993e                	add	s2,s2,a5
    800013a6:	fd4968e3          	bltu	s2,s4,80001376 <uvmalloc+0x2c>
  return newsz;
    800013aa:	8552                	mv	a0,s4
    800013ac:	a809                	j	800013be <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800013ae:	864e                	mv	a2,s3
    800013b0:	85ca                	mv	a1,s2
    800013b2:	8556                	mv	a0,s5
    800013b4:	00000097          	auipc	ra,0x0
    800013b8:	f52080e7          	jalr	-174(ra) # 80001306 <uvmdealloc>
      return 0;
    800013bc:	4501                	li	a0,0
}
    800013be:	70e2                	ld	ra,56(sp)
    800013c0:	7442                	ld	s0,48(sp)
    800013c2:	74a2                	ld	s1,40(sp)
    800013c4:	7902                	ld	s2,32(sp)
    800013c6:	69e2                	ld	s3,24(sp)
    800013c8:	6a42                	ld	s4,16(sp)
    800013ca:	6aa2                	ld	s5,8(sp)
    800013cc:	6121                	addi	sp,sp,64
    800013ce:	8082                	ret
      kfree(mem);
    800013d0:	8526                	mv	a0,s1
    800013d2:	fffff097          	auipc	ra,0xfffff
    800013d6:	492080e7          	jalr	1170(ra) # 80000864 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013da:	864e                	mv	a2,s3
    800013dc:	85ca                	mv	a1,s2
    800013de:	8556                	mv	a0,s5
    800013e0:	00000097          	auipc	ra,0x0
    800013e4:	f26080e7          	jalr	-218(ra) # 80001306 <uvmdealloc>
      return 0;
    800013e8:	4501                	li	a0,0
    800013ea:	bfd1                	j	800013be <uvmalloc+0x74>
    return oldsz;
    800013ec:	852e                	mv	a0,a1
}
    800013ee:	8082                	ret
  return newsz;
    800013f0:	8532                	mv	a0,a2
    800013f2:	b7f1                	j	800013be <uvmalloc+0x74>

00000000800013f4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013f4:	1101                	addi	sp,sp,-32
    800013f6:	ec06                	sd	ra,24(sp)
    800013f8:	e822                	sd	s0,16(sp)
    800013fa:	e426                	sd	s1,8(sp)
    800013fc:	1000                	addi	s0,sp,32
    800013fe:	84aa                	mv	s1,a0
    80001400:	862e                	mv	a2,a1
  uvmunmap(pagetable, PGSIZE, sz, 1);//uvmunmap(pagetable, 0, sz, 1);
    80001402:	4685                	li	a3,1
    80001404:	6585                	lui	a1,0x1
    80001406:	00000097          	auipc	ra,0x0
    8000140a:	d9c080e7          	jalr	-612(ra) # 800011a2 <uvmunmap>
  freewalk(pagetable);
    8000140e:	8526                	mv	a0,s1
    80001410:	00000097          	auipc	ra,0x0
    80001414:	a26080e7          	jalr	-1498(ra) # 80000e36 <freewalk>
}
    80001418:	60e2                	ld	ra,24(sp)
    8000141a:	6442                	ld	s0,16(sp)
    8000141c:	64a2                	ld	s1,8(sp)
    8000141e:	6105                	addi	sp,sp,32
    80001420:	8082                	ret

0000000080001422 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = PGSIZE; i < sz; i += PGSIZE){//p3, start from PGSIZE since the 0-4095 not mapped
    80001422:	6785                	lui	a5,0x1
    80001424:	0cc7ff63          	bgeu	a5,a2,80001502 <uvmcopy+0xe0>
{
    80001428:	715d                	addi	sp,sp,-80
    8000142a:	e486                	sd	ra,72(sp)
    8000142c:	e0a2                	sd	s0,64(sp)
    8000142e:	fc26                	sd	s1,56(sp)
    80001430:	f84a                	sd	s2,48(sp)
    80001432:	f44e                	sd	s3,40(sp)
    80001434:	f052                	sd	s4,32(sp)
    80001436:	ec56                	sd	s5,24(sp)
    80001438:	e85a                	sd	s6,16(sp)
    8000143a:	e45e                	sd	s7,8(sp)
    8000143c:	0880                	addi	s0,sp,80
    8000143e:	8b2a                	mv	s6,a0
    80001440:	8aae                	mv	s5,a1
    80001442:	8a32                	mv	s4,a2
  for(i = PGSIZE; i < sz; i += PGSIZE){//p3, start from PGSIZE since the 0-4095 not mapped
    80001444:	6985                	lui	s3,0x1
    if((pte = walk(old, i, 0)) == 0)
    80001446:	4601                	li	a2,0
    80001448:	85ce                	mv	a1,s3
    8000144a:	855a                	mv	a0,s6
    8000144c:	00000097          	auipc	ra,0x0
    80001450:	a78080e7          	jalr	-1416(ra) # 80000ec4 <walk>
    80001454:	c531                	beqz	a0,800014a0 <uvmcopy+0x7e>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0){
    80001456:	6118                	ld	a4,0(a0)
    80001458:	00177793          	andi	a5,a4,1
    8000145c:	cbb1                	beqz	a5,800014b0 <uvmcopy+0x8e>
      panic("uvmcopy: page not present");
    }
    pa = PTE2PA(*pte);
    8000145e:	00a75593          	srli	a1,a4,0xa
    80001462:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001466:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000146a:	fffff097          	auipc	ra,0xfffff
    8000146e:	4f6080e7          	jalr	1270(ra) # 80000960 <kalloc>
    80001472:	892a                	mv	s2,a0
    80001474:	c939                	beqz	a0,800014ca <uvmcopy+0xa8>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001476:	6605                	lui	a2,0x1
    80001478:	85de                	mv	a1,s7
    8000147a:	fffff097          	auipc	ra,0xfffff
    8000147e:	754080e7          	jalr	1876(ra) # 80000bce <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001482:	8726                	mv	a4,s1
    80001484:	86ca                	mv	a3,s2
    80001486:	6605                	lui	a2,0x1
    80001488:	85ce                	mv	a1,s3
    8000148a:	8556                	mv	a0,s5
    8000148c:	00000097          	auipc	ra,0x0
    80001490:	b7e080e7          	jalr	-1154(ra) # 8000100a <mappages>
    80001494:	e515                	bnez	a0,800014c0 <uvmcopy+0x9e>
  for(i = PGSIZE; i < sz; i += PGSIZE){//p3, start from PGSIZE since the 0-4095 not mapped
    80001496:	6785                	lui	a5,0x1
    80001498:	99be                	add	s3,s3,a5
    8000149a:	fb49e6e3          	bltu	s3,s4,80001446 <uvmcopy+0x24>
    8000149e:	a0b9                	j	800014ec <uvmcopy+0xca>
      panic("uvmcopy: pte should exist");
    800014a0:	00006517          	auipc	a0,0x6
    800014a4:	dc850513          	addi	a0,a0,-568 # 80007268 <userret+0x1d8>
    800014a8:	fffff097          	auipc	ra,0xfffff
    800014ac:	0a6080e7          	jalr	166(ra) # 8000054e <panic>
      panic("uvmcopy: page not present");
    800014b0:	00006517          	auipc	a0,0x6
    800014b4:	dd850513          	addi	a0,a0,-552 # 80007288 <userret+0x1f8>
    800014b8:	fffff097          	auipc	ra,0xfffff
    800014bc:	096080e7          	jalr	150(ra) # 8000054e <panic>
      kfree(mem);
    800014c0:	854a                	mv	a0,s2
    800014c2:	fffff097          	auipc	ra,0xfffff
    800014c6:	3a2080e7          	jalr	930(ra) # 80000864 <kfree>
    }
  }
  return 0;

 err:
  printf("uvmunmap wrong here c\n");
    800014ca:	00006517          	auipc	a0,0x6
    800014ce:	dde50513          	addi	a0,a0,-546 # 800072a8 <userret+0x218>
    800014d2:	fffff097          	auipc	ra,0xfffff
    800014d6:	0c6080e7          	jalr	198(ra) # 80000598 <printf>
  uvmunmap(new, 0, i, 1);
    800014da:	4685                	li	a3,1
    800014dc:	864e                	mv	a2,s3
    800014de:	4581                	li	a1,0
    800014e0:	8556                	mv	a0,s5
    800014e2:	00000097          	auipc	ra,0x0
    800014e6:	cc0080e7          	jalr	-832(ra) # 800011a2 <uvmunmap>
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
    80001514:	9b4080e7          	jalr	-1612(ra) # 80000ec4 <walk>
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
    8000152c:	d9850513          	addi	a0,a0,-616 # 800072c0 <userret+0x230>
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
    8000158e:	9e0080e7          	jalr	-1568(ra) # 80000f6a <walkaddr>
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
    8000161a:	954080e7          	jalr	-1708(ra) # 80000f6a <walkaddr>
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
    800016ac:	8c2080e7          	jalr	-1854(ra) # 80000f6a <walkaddr>
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
}
    80001702:	8082                	ret

0000000080001704 <mprotect>:


int
mprotect(uint64 va, int len)
{
    80001704:	7139                	addi	sp,sp,-64
    80001706:	fc06                	sd	ra,56(sp)
    80001708:	f822                	sd	s0,48(sp)
    8000170a:	f426                	sd	s1,40(sp)
    8000170c:	f04a                	sd	s2,32(sp)
    8000170e:	ec4e                	sd	s3,24(sp)
    80001710:	e852                	sd	s4,16(sp)
    80001712:	e456                	sd	s5,8(sp)
    80001714:	e05a                	sd	s6,0(sp)
    80001716:	0080                	addi	s0,sp,64
  if(len<=0){
    80001718:	06b05d63          	blez	a1,80001792 <mprotect+0x8e>
    8000171c:	89aa                	mv	s3,a0
    8000171e:	892e                	mv	s2,a1
    printf("len should not less than or equal to 0!\n");
    return -1;
  }

  if(POX(va)!=0){
    80001720:	03451793          	slli	a5,a0,0x34
    80001724:	e3c9                	bnez	a5,800017a6 <mprotect+0xa2>
    printf("address is not page-aligned!\n");
    return -1;
  }

  if(va >= MAXVA){
    80001726:	57fd                	li	a5,-1
    80001728:	83e9                	srli	a5,a5,0x1a
    8000172a:	08a7e863          	bltu	a5,a0,800017ba <mprotect+0xb6>
  }
  
  pte_t *pte;
  pte_t old;
  pagetable_t pagetable = 0;
  struct proc *p = myproc();
    8000172e:	00000097          	auipc	ra,0x0
    80001732:	390080e7          	jalr	912(ra) # 80001abe <myproc>
  pagetable = p->pagetable;
    80001736:	05053a03          	ld	s4,80(a0)
  for(int i =0; i<len; i++){
    8000173a:	397d                	addiw	s2,s2,-1
    8000173c:	1902                	slli	s2,s2,0x20
    8000173e:	02095913          	srli	s2,s2,0x20
    80001742:	0932                	slli	s2,s2,0xc
    80001744:	6785                	lui	a5,0x1
    80001746:	97ce                	add	a5,a5,s3
    80001748:	993e                	add	s2,s2,a5
  pagetable = p->pagetable;
    8000174a:	84ce                	mv	s1,s3
    pte = walk(pagetable, va+i*PGSIZE, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0){ 
    8000174c:	4ac5                	li	s5,17
    8000174e:	6b05                	lui	s6,0x1
    pte = walk(pagetable, va+i*PGSIZE, 0);
    80001750:	4601                	li	a2,0
    80001752:	85a6                	mv	a1,s1
    80001754:	8552                	mv	a0,s4
    80001756:	fffff097          	auipc	ra,0xfffff
    8000175a:	76e080e7          	jalr	1902(ra) # 80000ec4 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0){ 
    8000175e:	c925                	beqz	a0,800017ce <mprotect+0xca>
    80001760:	611c                	ld	a5,0(a0)
    80001762:	8bc5                	andi	a5,a5,17
    80001764:	07579563          	bne	a5,s5,800017ce <mprotect+0xca>
  for(int i =0; i<len; i++){
    80001768:	94da                	add	s1,s1,s6
    8000176a:	ff2493e3          	bne	s1,s2,80001750 <mprotect+0x4c>
    8000176e:	6485                	lui	s1,0x1
      return -1;
    }
  }

  for(int i =0; i<len; i++){
    pte = walk(pagetable, va+i*PGSIZE, 0);
    80001770:	4601                	li	a2,0
    80001772:	85ce                	mv	a1,s3
    80001774:	8552                	mv	a0,s4
    80001776:	fffff097          	auipc	ra,0xfffff
    8000177a:	74e080e7          	jalr	1870(ra) # 80000ec4 <walk>
    old = *pte;
    *pte = old & (~PTE_W);
    8000177e:	611c                	ld	a5,0(a0)
    80001780:	9bed                	andi	a5,a5,-5
    80001782:	e11c                	sd	a5,0(a0)
  for(int i =0; i<len; i++){
    80001784:	99a6                	add	s3,s3,s1
    80001786:	ff2995e3          	bne	s3,s2,80001770 <mprotect+0x6c>
    8000178a:	12000073          	sfence.vma
  }
  sfence_vma();
  return 0;
    8000178e:	4501                	li	a0,0
    80001790:	a881                	j	800017e0 <mprotect+0xdc>
    printf("len should not less than or equal to 0!\n");
    80001792:	00006517          	auipc	a0,0x6
    80001796:	b3e50513          	addi	a0,a0,-1218 # 800072d0 <userret+0x240>
    8000179a:	fffff097          	auipc	ra,0xfffff
    8000179e:	dfe080e7          	jalr	-514(ra) # 80000598 <printf>
    return -1;
    800017a2:	557d                	li	a0,-1
    800017a4:	a835                	j	800017e0 <mprotect+0xdc>
    printf("address is not page-aligned!\n");
    800017a6:	00006517          	auipc	a0,0x6
    800017aa:	b5a50513          	addi	a0,a0,-1190 # 80007300 <userret+0x270>
    800017ae:	fffff097          	auipc	ra,0xfffff
    800017b2:	dea080e7          	jalr	-534(ra) # 80000598 <printf>
    return -1;
    800017b6:	557d                	li	a0,-1
    800017b8:	a025                	j	800017e0 <mprotect+0xdc>
    printf("va >= MAXVA!\n");
    800017ba:	00006517          	auipc	a0,0x6
    800017be:	b6650513          	addi	a0,a0,-1178 # 80007320 <userret+0x290>
    800017c2:	fffff097          	auipc	ra,0xfffff
    800017c6:	dd6080e7          	jalr	-554(ra) # 80000598 <printf>
    return -1;
    800017ca:	557d                	li	a0,-1
    800017cc:	a811                	j	800017e0 <mprotect+0xdc>
      printf("not currently a part of the address space!\n");
    800017ce:	00006517          	auipc	a0,0x6
    800017d2:	b6250513          	addi	a0,a0,-1182 # 80007330 <userret+0x2a0>
    800017d6:	fffff097          	auipc	ra,0xfffff
    800017da:	dc2080e7          	jalr	-574(ra) # 80000598 <printf>
      return -1;
    800017de:	557d                	li	a0,-1
}
    800017e0:	70e2                	ld	ra,56(sp)
    800017e2:	7442                	ld	s0,48(sp)
    800017e4:	74a2                	ld	s1,40(sp)
    800017e6:	7902                	ld	s2,32(sp)
    800017e8:	69e2                	ld	s3,24(sp)
    800017ea:	6a42                	ld	s4,16(sp)
    800017ec:	6aa2                	ld	s5,8(sp)
    800017ee:	6b02                	ld	s6,0(sp)
    800017f0:	6121                	addi	sp,sp,64
    800017f2:	8082                	ret

00000000800017f4 <munprotect>:

int
munprotect(uint64 va, int len)
{
    800017f4:	7139                	addi	sp,sp,-64
    800017f6:	fc06                	sd	ra,56(sp)
    800017f8:	f822                	sd	s0,48(sp)
    800017fa:	f426                	sd	s1,40(sp)
    800017fc:	f04a                	sd	s2,32(sp)
    800017fe:	ec4e                	sd	s3,24(sp)
    80001800:	e852                	sd	s4,16(sp)
    80001802:	e456                	sd	s5,8(sp)
    80001804:	e05a                	sd	s6,0(sp)
    80001806:	0080                	addi	s0,sp,64
  if(len<=0){
    80001808:	06b05e63          	blez	a1,80001884 <munprotect+0x90>
    8000180c:	89aa                	mv	s3,a0
    8000180e:	892e                	mv	s2,a1
    printf("len should not less than or equal to 0!\n");
    return -1;
  }

  if(POX(va)!=0){
    80001810:	03451793          	slli	a5,a0,0x34
    80001814:	e3d1                	bnez	a5,80001898 <munprotect+0xa4>
    printf("address is not page-aligned!\n");
    return -1;
  }

  if(va >= MAXVA){
    80001816:	57fd                	li	a5,-1
    80001818:	83e9                	srli	a5,a5,0x1a
    8000181a:	08a7e963          	bltu	a5,a0,800018ac <munprotect+0xb8>
  }
  
  pte_t *pte;
  pte_t old;
  pagetable_t pagetable = 0;
  struct proc *p = myproc();
    8000181e:	00000097          	auipc	ra,0x0
    80001822:	2a0080e7          	jalr	672(ra) # 80001abe <myproc>
  pagetable = p->pagetable;
    80001826:	05053a03          	ld	s4,80(a0)
  for(int i =0; i<len; i++){
    8000182a:	397d                	addiw	s2,s2,-1
    8000182c:	1902                	slli	s2,s2,0x20
    8000182e:	02095913          	srli	s2,s2,0x20
    80001832:	0932                	slli	s2,s2,0xc
    80001834:	6785                	lui	a5,0x1
    80001836:	97ce                	add	a5,a5,s3
    80001838:	993e                	add	s2,s2,a5
  pagetable = p->pagetable;
    8000183a:	84ce                	mv	s1,s3
    pte = walk(pagetable, va+i*PGSIZE, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0){ 
    8000183c:	4ac5                	li	s5,17
    8000183e:	6b05                	lui	s6,0x1
    pte = walk(pagetable, va+i*PGSIZE, 0);
    80001840:	4601                	li	a2,0
    80001842:	85a6                	mv	a1,s1
    80001844:	8552                	mv	a0,s4
    80001846:	fffff097          	auipc	ra,0xfffff
    8000184a:	67e080e7          	jalr	1662(ra) # 80000ec4 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0){ 
    8000184e:	c92d                	beqz	a0,800018c0 <munprotect+0xcc>
    80001850:	611c                	ld	a5,0(a0)
    80001852:	8bc5                	andi	a5,a5,17
    80001854:	07579663          	bne	a5,s5,800018c0 <munprotect+0xcc>
  for(int i =0; i<len; i++){
    80001858:	94da                	add	s1,s1,s6
    8000185a:	ff2493e3          	bne	s1,s2,80001840 <munprotect+0x4c>
    8000185e:	6485                	lui	s1,0x1
      return -1;
    }
  }

  for(int i =0; i<len; i++){
    pte = walk(pagetable, va+i*PGSIZE, 0);
    80001860:	4601                	li	a2,0
    80001862:	85ce                	mv	a1,s3
    80001864:	8552                	mv	a0,s4
    80001866:	fffff097          	auipc	ra,0xfffff
    8000186a:	65e080e7          	jalr	1630(ra) # 80000ec4 <walk>
    old = *pte;
    *pte = old | PTE_W;
    8000186e:	611c                	ld	a5,0(a0)
    80001870:	0047e793          	ori	a5,a5,4
    80001874:	e11c                	sd	a5,0(a0)
  for(int i =0; i<len; i++){
    80001876:	99a6                	add	s3,s3,s1
    80001878:	ff2994e3          	bne	s3,s2,80001860 <munprotect+0x6c>
    8000187c:	12000073          	sfence.vma
  }
  sfence_vma();
  return 0;
    80001880:	4501                	li	a0,0
    80001882:	a881                	j	800018d2 <munprotect+0xde>
    printf("len should not less than or equal to 0!\n");
    80001884:	00006517          	auipc	a0,0x6
    80001888:	a4c50513          	addi	a0,a0,-1460 # 800072d0 <userret+0x240>
    8000188c:	fffff097          	auipc	ra,0xfffff
    80001890:	d0c080e7          	jalr	-756(ra) # 80000598 <printf>
    return -1;
    80001894:	557d                	li	a0,-1
    80001896:	a835                	j	800018d2 <munprotect+0xde>
    printf("address is not page-aligned!\n");
    80001898:	00006517          	auipc	a0,0x6
    8000189c:	a6850513          	addi	a0,a0,-1432 # 80007300 <userret+0x270>
    800018a0:	fffff097          	auipc	ra,0xfffff
    800018a4:	cf8080e7          	jalr	-776(ra) # 80000598 <printf>
    return -1;
    800018a8:	557d                	li	a0,-1
    800018aa:	a025                	j	800018d2 <munprotect+0xde>
    printf("va >= MAXVA!\n");
    800018ac:	00006517          	auipc	a0,0x6
    800018b0:	a7450513          	addi	a0,a0,-1420 # 80007320 <userret+0x290>
    800018b4:	fffff097          	auipc	ra,0xfffff
    800018b8:	ce4080e7          	jalr	-796(ra) # 80000598 <printf>
    return -1;
    800018bc:	557d                	li	a0,-1
    800018be:	a811                	j	800018d2 <munprotect+0xde>
      printf("not currently a part of the address space!\n");
    800018c0:	00006517          	auipc	a0,0x6
    800018c4:	a7050513          	addi	a0,a0,-1424 # 80007330 <userret+0x2a0>
    800018c8:	fffff097          	auipc	ra,0xfffff
    800018cc:	cd0080e7          	jalr	-816(ra) # 80000598 <printf>
      return -1;
    800018d0:	557d                	li	a0,-1
}
    800018d2:	70e2                	ld	ra,56(sp)
    800018d4:	7442                	ld	s0,48(sp)
    800018d6:	74a2                	ld	s1,40(sp)
    800018d8:	7902                	ld	s2,32(sp)
    800018da:	69e2                	ld	s3,24(sp)
    800018dc:	6a42                	ld	s4,16(sp)
    800018de:	6aa2                	ld	s5,8(sp)
    800018e0:	6b02                	ld	s6,0(sp)
    800018e2:	6121                	addi	sp,sp,64
    800018e4:	8082                	ret

00000000800018e6 <sys_mprotect>:


uint64
sys_mprotect(void) //p3
{ 
    800018e6:	1101                	addi	sp,sp,-32
    800018e8:	ec06                	sd	ra,24(sp)
    800018ea:	e822                	sd	s0,16(sp)
    800018ec:	1000                	addi	s0,sp,32
   int n;
   uint64 p;
   if(argaddr(0, &p) < 0 || argint(1, &n) < 0)
    800018ee:	fe040593          	addi	a1,s0,-32
    800018f2:	4501                	li	a0,0
    800018f4:	00001097          	auipc	ra,0x1
    800018f8:	278080e7          	jalr	632(ra) # 80002b6c <argaddr>
    return -1;
    800018fc:	57fd                	li	a5,-1
   if(argaddr(0, &p) < 0 || argint(1, &n) < 0)
    800018fe:	02054563          	bltz	a0,80001928 <sys_mprotect+0x42>
    80001902:	fec40593          	addi	a1,s0,-20
    80001906:	4505                	li	a0,1
    80001908:	00001097          	auipc	ra,0x1
    8000190c:	242080e7          	jalr	578(ra) # 80002b4a <argint>
    return -1;
    80001910:	57fd                	li	a5,-1
   if(argaddr(0, &p) < 0 || argint(1, &n) < 0)
    80001912:	00054b63          	bltz	a0,80001928 <sys_mprotect+0x42>
   return mprotect(p, n);
    80001916:	fec42583          	lw	a1,-20(s0)
    8000191a:	fe043503          	ld	a0,-32(s0)
    8000191e:	00000097          	auipc	ra,0x0
    80001922:	de6080e7          	jalr	-538(ra) # 80001704 <mprotect>
    80001926:	87aa                	mv	a5,a0
}
    80001928:	853e                	mv	a0,a5
    8000192a:	60e2                	ld	ra,24(sp)
    8000192c:	6442                	ld	s0,16(sp)
    8000192e:	6105                	addi	sp,sp,32
    80001930:	8082                	ret

0000000080001932 <sys_munprotect>:

uint64
sys_munprotect(void) //p3
{ 
    80001932:	1101                	addi	sp,sp,-32
    80001934:	ec06                	sd	ra,24(sp)
    80001936:	e822                	sd	s0,16(sp)
    80001938:	1000                	addi	s0,sp,32
   int n;
   uint64 p;
   if(argaddr(0, &p) < 0 || argint(1, &n) < 0)
    8000193a:	fe040593          	addi	a1,s0,-32
    8000193e:	4501                	li	a0,0
    80001940:	00001097          	auipc	ra,0x1
    80001944:	22c080e7          	jalr	556(ra) # 80002b6c <argaddr>
    return -1;
    80001948:	57fd                	li	a5,-1
   if(argaddr(0, &p) < 0 || argint(1, &n) < 0)
    8000194a:	02054563          	bltz	a0,80001974 <sys_munprotect+0x42>
    8000194e:	fec40593          	addi	a1,s0,-20
    80001952:	4505                	li	a0,1
    80001954:	00001097          	auipc	ra,0x1
    80001958:	1f6080e7          	jalr	502(ra) # 80002b4a <argint>
    return -1;
    8000195c:	57fd                	li	a5,-1
   if(argaddr(0, &p) < 0 || argint(1, &n) < 0)
    8000195e:	00054b63          	bltz	a0,80001974 <sys_munprotect+0x42>
   return munprotect(p, n);
    80001962:	fec42583          	lw	a1,-20(s0)
    80001966:	fe043503          	ld	a0,-32(s0)
    8000196a:	00000097          	auipc	ra,0x0
    8000196e:	e8a080e7          	jalr	-374(ra) # 800017f4 <munprotect>
    80001972:	87aa                	mv	a5,a0
}
    80001974:	853e                	mv	a0,a5
    80001976:	60e2                	ld	ra,24(sp)
    80001978:	6442                	ld	s0,16(sp)
    8000197a:	6105                	addi	sp,sp,32
    8000197c:	8082                	ret

000000008000197e <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    8000197e:	1101                	addi	sp,sp,-32
    80001980:	ec06                	sd	ra,24(sp)
    80001982:	e822                	sd	s0,16(sp)
    80001984:	e426                	sd	s1,8(sp)
    80001986:	1000                	addi	s0,sp,32
    80001988:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000198a:	fffff097          	auipc	ra,0xfffff
    8000198e:	108080e7          	jalr	264(ra) # 80000a92 <holding>
    80001992:	c909                	beqz	a0,800019a4 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001994:	749c                	ld	a5,40(s1)
    80001996:	00978f63          	beq	a5,s1,800019b4 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    8000199a:	60e2                	ld	ra,24(sp)
    8000199c:	6442                	ld	s0,16(sp)
    8000199e:	64a2                	ld	s1,8(sp)
    800019a0:	6105                	addi	sp,sp,32
    800019a2:	8082                	ret
    panic("wakeup1");
    800019a4:	00006517          	auipc	a0,0x6
    800019a8:	9bc50513          	addi	a0,a0,-1604 # 80007360 <userret+0x2d0>
    800019ac:	fffff097          	auipc	ra,0xfffff
    800019b0:	ba2080e7          	jalr	-1118(ra) # 8000054e <panic>
  if(p->chan == p && p->state == SLEEPING) {
    800019b4:	4c98                	lw	a4,24(s1)
    800019b6:	4785                	li	a5,1
    800019b8:	fef711e3          	bne	a4,a5,8000199a <wakeup1+0x1c>
    p->state = RUNNABLE;
    800019bc:	4789                	li	a5,2
    800019be:	cc9c                	sw	a5,24(s1)
}
    800019c0:	bfe9                	j	8000199a <wakeup1+0x1c>

00000000800019c2 <procinit>:
{
    800019c2:	715d                	addi	sp,sp,-80
    800019c4:	e486                	sd	ra,72(sp)
    800019c6:	e0a2                	sd	s0,64(sp)
    800019c8:	fc26                	sd	s1,56(sp)
    800019ca:	f84a                	sd	s2,48(sp)
    800019cc:	f44e                	sd	s3,40(sp)
    800019ce:	f052                	sd	s4,32(sp)
    800019d0:	ec56                	sd	s5,24(sp)
    800019d2:	e85a                	sd	s6,16(sp)
    800019d4:	e45e                	sd	s7,8(sp)
    800019d6:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    800019d8:	00006597          	auipc	a1,0x6
    800019dc:	99058593          	addi	a1,a1,-1648 # 80007368 <userret+0x2d8>
    800019e0:	00010517          	auipc	a0,0x10
    800019e4:	f0850513          	addi	a0,a0,-248 # 800118e8 <pid_lock>
    800019e8:	fffff097          	auipc	ra,0xfffff
    800019ec:	fd8080e7          	jalr	-40(ra) # 800009c0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019f0:	00010917          	auipc	s2,0x10
    800019f4:	31090913          	addi	s2,s2,784 # 80011d00 <proc>
      initlock(&p->lock, "proc");
    800019f8:	00006b97          	auipc	s7,0x6
    800019fc:	978b8b93          	addi	s7,s7,-1672 # 80007370 <userret+0x2e0>
      uint64 va = KSTACK((int) (p - proc)); //every process has a kernel stack with a protection page below it
    80001a00:	8b4a                	mv	s6,s2
    80001a02:	00006a97          	auipc	s5,0x6
    80001a06:	04ea8a93          	addi	s5,s5,78 # 80007a50 <syscalls+0xc0>
    80001a0a:	040009b7          	lui	s3,0x4000
    80001a0e:	19fd                	addi	s3,s3,-1
    80001a10:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a12:	00016a17          	auipc	s4,0x16
    80001a16:	ceea0a13          	addi	s4,s4,-786 # 80017700 <tickslock>
      initlock(&p->lock, "proc");
    80001a1a:	85de                	mv	a1,s7
    80001a1c:	854a                	mv	a0,s2
    80001a1e:	fffff097          	auipc	ra,0xfffff
    80001a22:	fa2080e7          	jalr	-94(ra) # 800009c0 <initlock>
      char *pa = kalloc();
    80001a26:	fffff097          	auipc	ra,0xfffff
    80001a2a:	f3a080e7          	jalr	-198(ra) # 80000960 <kalloc>
    80001a2e:	85aa                	mv	a1,a0
      if(pa == 0)
    80001a30:	c929                	beqz	a0,80001a82 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc)); //every process has a kernel stack with a protection page below it
    80001a32:	416904b3          	sub	s1,s2,s6
    80001a36:	848d                	srai	s1,s1,0x3
    80001a38:	000ab783          	ld	a5,0(s5)
    80001a3c:	02f484b3          	mul	s1,s1,a5
    80001a40:	2485                	addiw	s1,s1,1
    80001a42:	00d4949b          	slliw	s1,s1,0xd
    80001a46:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001a4a:	4699                	li	a3,6
    80001a4c:	6605                	lui	a2,0x1
    80001a4e:	8526                	mv	a0,s1
    80001a50:	fffff097          	auipc	ra,0xfffff
    80001a54:	648080e7          	jalr	1608(ra) # 80001098 <kvmmap>
      p->kstack = va;
    80001a58:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a5c:	16890913          	addi	s2,s2,360
    80001a60:	fb491de3          	bne	s2,s4,80001a1a <procinit+0x58>
  kvminithart();
    80001a64:	fffff097          	auipc	ra,0xfffff
    80001a68:	43c080e7          	jalr	1084(ra) # 80000ea0 <kvminithart>
}
    80001a6c:	60a6                	ld	ra,72(sp)
    80001a6e:	6406                	ld	s0,64(sp)
    80001a70:	74e2                	ld	s1,56(sp)
    80001a72:	7942                	ld	s2,48(sp)
    80001a74:	79a2                	ld	s3,40(sp)
    80001a76:	7a02                	ld	s4,32(sp)
    80001a78:	6ae2                	ld	s5,24(sp)
    80001a7a:	6b42                	ld	s6,16(sp)
    80001a7c:	6ba2                	ld	s7,8(sp)
    80001a7e:	6161                	addi	sp,sp,80
    80001a80:	8082                	ret
        panic("kalloc");
    80001a82:	00006517          	auipc	a0,0x6
    80001a86:	8f650513          	addi	a0,a0,-1802 # 80007378 <userret+0x2e8>
    80001a8a:	fffff097          	auipc	ra,0xfffff
    80001a8e:	ac4080e7          	jalr	-1340(ra) # 8000054e <panic>

0000000080001a92 <cpuid>:
{
    80001a92:	1141                	addi	sp,sp,-16
    80001a94:	e422                	sd	s0,8(sp)
    80001a96:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a98:	8512                	mv	a0,tp
}
    80001a9a:	2501                	sext.w	a0,a0
    80001a9c:	6422                	ld	s0,8(sp)
    80001a9e:	0141                	addi	sp,sp,16
    80001aa0:	8082                	ret

0000000080001aa2 <mycpu>:
mycpu(void) {
    80001aa2:	1141                	addi	sp,sp,-16
    80001aa4:	e422                	sd	s0,8(sp)
    80001aa6:	0800                	addi	s0,sp,16
    80001aa8:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001aaa:	2781                	sext.w	a5,a5
    80001aac:	079e                	slli	a5,a5,0x7
}
    80001aae:	00010517          	auipc	a0,0x10
    80001ab2:	e5250513          	addi	a0,a0,-430 # 80011900 <cpus>
    80001ab6:	953e                	add	a0,a0,a5
    80001ab8:	6422                	ld	s0,8(sp)
    80001aba:	0141                	addi	sp,sp,16
    80001abc:	8082                	ret

0000000080001abe <myproc>:
myproc(void) {
    80001abe:	1101                	addi	sp,sp,-32
    80001ac0:	ec06                	sd	ra,24(sp)
    80001ac2:	e822                	sd	s0,16(sp)
    80001ac4:	e426                	sd	s1,8(sp)
    80001ac6:	1000                	addi	s0,sp,32
  push_off();
    80001ac8:	fffff097          	auipc	ra,0xfffff
    80001acc:	f0e080e7          	jalr	-242(ra) # 800009d6 <push_off>
    80001ad0:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001ad2:	2781                	sext.w	a5,a5
    80001ad4:	079e                	slli	a5,a5,0x7
    80001ad6:	00010717          	auipc	a4,0x10
    80001ada:	e1270713          	addi	a4,a4,-494 # 800118e8 <pid_lock>
    80001ade:	97ba                	add	a5,a5,a4
    80001ae0:	6f84                	ld	s1,24(a5)
  pop_off();
    80001ae2:	fffff097          	auipc	ra,0xfffff
    80001ae6:	f40080e7          	jalr	-192(ra) # 80000a22 <pop_off>
}
    80001aea:	8526                	mv	a0,s1
    80001aec:	60e2                	ld	ra,24(sp)
    80001aee:	6442                	ld	s0,16(sp)
    80001af0:	64a2                	ld	s1,8(sp)
    80001af2:	6105                	addi	sp,sp,32
    80001af4:	8082                	ret

0000000080001af6 <forkret>:
{
    80001af6:	1141                	addi	sp,sp,-16
    80001af8:	e406                	sd	ra,8(sp)
    80001afa:	e022                	sd	s0,0(sp)
    80001afc:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001afe:	00000097          	auipc	ra,0x0
    80001b02:	fc0080e7          	jalr	-64(ra) # 80001abe <myproc>
    80001b06:	fffff097          	auipc	ra,0xfffff
    80001b0a:	020080e7          	jalr	32(ra) # 80000b26 <release>
  if (first) {
    80001b0e:	00006797          	auipc	a5,0x6
    80001b12:	5267a783          	lw	a5,1318(a5) # 80008034 <first.1659>
    80001b16:	eb89                	bnez	a5,80001b28 <forkret+0x32>
  usertrapret();
    80001b18:	00001097          	auipc	ra,0x1
    80001b1c:	bb0080e7          	jalr	-1104(ra) # 800026c8 <usertrapret>
}
    80001b20:	60a2                	ld	ra,8(sp)
    80001b22:	6402                	ld	s0,0(sp)
    80001b24:	0141                	addi	sp,sp,16
    80001b26:	8082                	ret
    first = 0;
    80001b28:	00006797          	auipc	a5,0x6
    80001b2c:	5007a623          	sw	zero,1292(a5) # 80008034 <first.1659>
    fsinit(ROOTDEV);
    80001b30:	4505                	li	a0,1
    80001b32:	00002097          	auipc	ra,0x2
    80001b36:	912080e7          	jalr	-1774(ra) # 80003444 <fsinit>
    80001b3a:	bff9                	j	80001b18 <forkret+0x22>

0000000080001b3c <allocpid>:
allocpid() {
    80001b3c:	1101                	addi	sp,sp,-32
    80001b3e:	ec06                	sd	ra,24(sp)
    80001b40:	e822                	sd	s0,16(sp)
    80001b42:	e426                	sd	s1,8(sp)
    80001b44:	e04a                	sd	s2,0(sp)
    80001b46:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001b48:	00010917          	auipc	s2,0x10
    80001b4c:	da090913          	addi	s2,s2,-608 # 800118e8 <pid_lock>
    80001b50:	854a                	mv	a0,s2
    80001b52:	fffff097          	auipc	ra,0xfffff
    80001b56:	f80080e7          	jalr	-128(ra) # 80000ad2 <acquire>
  pid = nextpid;
    80001b5a:	00006797          	auipc	a5,0x6
    80001b5e:	4de78793          	addi	a5,a5,1246 # 80008038 <nextpid>
    80001b62:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001b64:	0014871b          	addiw	a4,s1,1
    80001b68:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b6a:	854a                	mv	a0,s2
    80001b6c:	fffff097          	auipc	ra,0xfffff
    80001b70:	fba080e7          	jalr	-70(ra) # 80000b26 <release>
}
    80001b74:	8526                	mv	a0,s1
    80001b76:	60e2                	ld	ra,24(sp)
    80001b78:	6442                	ld	s0,16(sp)
    80001b7a:	64a2                	ld	s1,8(sp)
    80001b7c:	6902                	ld	s2,0(sp)
    80001b7e:	6105                	addi	sp,sp,32
    80001b80:	8082                	ret

0000000080001b82 <proc_pagetable>:
{
    80001b82:	1101                	addi	sp,sp,-32
    80001b84:	ec06                	sd	ra,24(sp)
    80001b86:	e822                	sd	s0,16(sp)
    80001b88:	e426                	sd	s1,8(sp)
    80001b8a:	e04a                	sd	s2,0(sp)
    80001b8c:	1000                	addi	s0,sp,32
    80001b8e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b90:	fffff097          	auipc	ra,0xfffff
    80001b94:	6c6080e7          	jalr	1734(ra) # 80001256 <uvmcreate>
    80001b98:	84aa                	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b9a:	4729                	li	a4,10
    80001b9c:	00005697          	auipc	a3,0x5
    80001ba0:	46468693          	addi	a3,a3,1124 # 80007000 <trampoline>
    80001ba4:	6605                	lui	a2,0x1
    80001ba6:	040005b7          	lui	a1,0x4000
    80001baa:	15fd                	addi	a1,a1,-1
    80001bac:	05b2                	slli	a1,a1,0xc
    80001bae:	fffff097          	auipc	ra,0xfffff
    80001bb2:	45c080e7          	jalr	1116(ra) # 8000100a <mappages>
  mappages(pagetable, TRAPFRAME, PGSIZE,
    80001bb6:	4719                	li	a4,6
    80001bb8:	05893683          	ld	a3,88(s2)
    80001bbc:	6605                	lui	a2,0x1
    80001bbe:	020005b7          	lui	a1,0x2000
    80001bc2:	15fd                	addi	a1,a1,-1
    80001bc4:	05b6                	slli	a1,a1,0xd
    80001bc6:	8526                	mv	a0,s1
    80001bc8:	fffff097          	auipc	ra,0xfffff
    80001bcc:	442080e7          	jalr	1090(ra) # 8000100a <mappages>
}
    80001bd0:	8526                	mv	a0,s1
    80001bd2:	60e2                	ld	ra,24(sp)
    80001bd4:	6442                	ld	s0,16(sp)
    80001bd6:	64a2                	ld	s1,8(sp)
    80001bd8:	6902                	ld	s2,0(sp)
    80001bda:	6105                	addi	sp,sp,32
    80001bdc:	8082                	ret

0000000080001bde <allocproc>:
{
    80001bde:	1101                	addi	sp,sp,-32
    80001be0:	ec06                	sd	ra,24(sp)
    80001be2:	e822                	sd	s0,16(sp)
    80001be4:	e426                	sd	s1,8(sp)
    80001be6:	e04a                	sd	s2,0(sp)
    80001be8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bea:	00010497          	auipc	s1,0x10
    80001bee:	11648493          	addi	s1,s1,278 # 80011d00 <proc>
    80001bf2:	00016917          	auipc	s2,0x16
    80001bf6:	b0e90913          	addi	s2,s2,-1266 # 80017700 <tickslock>
    acquire(&p->lock);
    80001bfa:	8526                	mv	a0,s1
    80001bfc:	fffff097          	auipc	ra,0xfffff
    80001c00:	ed6080e7          	jalr	-298(ra) # 80000ad2 <acquire>
    if(p->state == UNUSED) {
    80001c04:	4c9c                	lw	a5,24(s1)
    80001c06:	cf81                	beqz	a5,80001c1e <allocproc+0x40>
      release(&p->lock);
    80001c08:	8526                	mv	a0,s1
    80001c0a:	fffff097          	auipc	ra,0xfffff
    80001c0e:	f1c080e7          	jalr	-228(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c12:	16848493          	addi	s1,s1,360
    80001c16:	ff2492e3          	bne	s1,s2,80001bfa <allocproc+0x1c>
  return 0;
    80001c1a:	4481                	li	s1,0
    80001c1c:	a0a9                	j	80001c66 <allocproc+0x88>
  p->pid = allocpid();
    80001c1e:	00000097          	auipc	ra,0x0
    80001c22:	f1e080e7          	jalr	-226(ra) # 80001b3c <allocpid>
    80001c26:	dc88                	sw	a0,56(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    80001c28:	fffff097          	auipc	ra,0xfffff
    80001c2c:	d38080e7          	jalr	-712(ra) # 80000960 <kalloc>
    80001c30:	892a                	mv	s2,a0
    80001c32:	eca8                	sd	a0,88(s1)
    80001c34:	c121                	beqz	a0,80001c74 <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    80001c36:	8526                	mv	a0,s1
    80001c38:	00000097          	auipc	ra,0x0
    80001c3c:	f4a080e7          	jalr	-182(ra) # 80001b82 <proc_pagetable>
    80001c40:	e8a8                	sd	a0,80(s1)
  memset(&p->context, 0, sizeof p->context); //write all zeros
    80001c42:	07000613          	li	a2,112
    80001c46:	4581                	li	a1,0
    80001c48:	06048513          	addi	a0,s1,96
    80001c4c:	fffff097          	auipc	ra,0xfffff
    80001c50:	f22080e7          	jalr	-222(ra) # 80000b6e <memset>
  p->context.ra = (uint64)forkret; //return address
    80001c54:	00000797          	auipc	a5,0x0
    80001c58:	ea278793          	addi	a5,a5,-350 # 80001af6 <forkret>
    80001c5c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c5e:	60bc                	ld	a5,64(s1)
    80001c60:	6705                	lui	a4,0x1
    80001c62:	97ba                	add	a5,a5,a4
    80001c64:	f4bc                	sd	a5,104(s1)
}
    80001c66:	8526                	mv	a0,s1
    80001c68:	60e2                	ld	ra,24(sp)
    80001c6a:	6442                	ld	s0,16(sp)
    80001c6c:	64a2                	ld	s1,8(sp)
    80001c6e:	6902                	ld	s2,0(sp)
    80001c70:	6105                	addi	sp,sp,32
    80001c72:	8082                	ret
    release(&p->lock);
    80001c74:	8526                	mv	a0,s1
    80001c76:	fffff097          	auipc	ra,0xfffff
    80001c7a:	eb0080e7          	jalr	-336(ra) # 80000b26 <release>
    return 0;
    80001c7e:	84ca                	mv	s1,s2
    80001c80:	b7dd                	j	80001c66 <allocproc+0x88>

0000000080001c82 <proc_freepagetable>:
{
    80001c82:	1101                	addi	sp,sp,-32
    80001c84:	ec06                	sd	ra,24(sp)
    80001c86:	e822                	sd	s0,16(sp)
    80001c88:	e426                	sd	s1,8(sp)
    80001c8a:	e04a                	sd	s2,0(sp)
    80001c8c:	1000                	addi	s0,sp,32
    80001c8e:	84aa                	mv	s1,a0
    80001c90:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    80001c92:	4681                	li	a3,0
    80001c94:	6605                	lui	a2,0x1
    80001c96:	040005b7          	lui	a1,0x4000
    80001c9a:	15fd                	addi	a1,a1,-1
    80001c9c:	05b2                	slli	a1,a1,0xc
    80001c9e:	fffff097          	auipc	ra,0xfffff
    80001ca2:	504080e7          	jalr	1284(ra) # 800011a2 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, PGSIZE, 0);
    80001ca6:	4681                	li	a3,0
    80001ca8:	6605                	lui	a2,0x1
    80001caa:	020005b7          	lui	a1,0x2000
    80001cae:	15fd                	addi	a1,a1,-1
    80001cb0:	05b6                	slli	a1,a1,0xd
    80001cb2:	8526                	mv	a0,s1
    80001cb4:	fffff097          	auipc	ra,0xfffff
    80001cb8:	4ee080e7          	jalr	1262(ra) # 800011a2 <uvmunmap>
  if(sz > 0){
    80001cbc:	00091863          	bnez	s2,80001ccc <proc_freepagetable+0x4a>
}
    80001cc0:	60e2                	ld	ra,24(sp)
    80001cc2:	6442                	ld	s0,16(sp)
    80001cc4:	64a2                	ld	s1,8(sp)
    80001cc6:	6902                	ld	s2,0(sp)
    80001cc8:	6105                	addi	sp,sp,32
    80001cca:	8082                	ret
    uvmfree(pagetable, sz);
    80001ccc:	85ca                	mv	a1,s2
    80001cce:	8526                	mv	a0,s1
    80001cd0:	fffff097          	auipc	ra,0xfffff
    80001cd4:	724080e7          	jalr	1828(ra) # 800013f4 <uvmfree>
}
    80001cd8:	b7e5                	j	80001cc0 <proc_freepagetable+0x3e>

0000000080001cda <freeproc>:
{
    80001cda:	1101                	addi	sp,sp,-32
    80001cdc:	ec06                	sd	ra,24(sp)
    80001cde:	e822                	sd	s0,16(sp)
    80001ce0:	e426                	sd	s1,8(sp)
    80001ce2:	1000                	addi	s0,sp,32
    80001ce4:	84aa                	mv	s1,a0
  if(p->tf)
    80001ce6:	6d28                	ld	a0,88(a0)
    80001ce8:	c509                	beqz	a0,80001cf2 <freeproc+0x18>
    kfree((void*)p->tf);
    80001cea:	fffff097          	auipc	ra,0xfffff
    80001cee:	b7a080e7          	jalr	-1158(ra) # 80000864 <kfree>
  p->tf = 0;
    80001cf2:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable){
    80001cf6:	68a8                	ld	a0,80(s1)
    80001cf8:	c901                	beqz	a0,80001d08 <freeproc+0x2e>
    proc_freepagetable(p->pagetable, p->sz - PGSIZE);
    80001cfa:	64bc                	ld	a5,72(s1)
    80001cfc:	75fd                	lui	a1,0xfffff
    80001cfe:	95be                	add	a1,a1,a5
    80001d00:	00000097          	auipc	ra,0x0
    80001d04:	f82080e7          	jalr	-126(ra) # 80001c82 <proc_freepagetable>
  p->pagetable = 0;
    80001d08:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001d0c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001d10:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001d14:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001d18:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001d1c:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001d20:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001d24:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001d28:	0004ac23          	sw	zero,24(s1)
}
    80001d2c:	60e2                	ld	ra,24(sp)
    80001d2e:	6442                	ld	s0,16(sp)
    80001d30:	64a2                	ld	s1,8(sp)
    80001d32:	6105                	addi	sp,sp,32
    80001d34:	8082                	ret

0000000080001d36 <userinit>:
{
    80001d36:	1101                	addi	sp,sp,-32
    80001d38:	ec06                	sd	ra,24(sp)
    80001d3a:	e822                	sd	s0,16(sp)
    80001d3c:	e426                	sd	s1,8(sp)
    80001d3e:	1000                	addi	s0,sp,32
  p = allocproc(); //get the return address
    80001d40:	00000097          	auipc	ra,0x0
    80001d44:	e9e080e7          	jalr	-354(ra) # 80001bde <allocproc>
    80001d48:	84aa                	mv	s1,a0
  initproc = p;
    80001d4a:	00024797          	auipc	a5,0x24
    80001d4e:	2ca7b323          	sd	a0,710(a5) # 80026010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001d52:	03300613          	li	a2,51
    80001d56:	00006597          	auipc	a1,0x6
    80001d5a:	2aa58593          	addi	a1,a1,682 # 80008000 <initcode>
    80001d5e:	6928                	ld	a0,80(a0)
    80001d60:	fffff097          	auipc	ra,0xfffff
    80001d64:	534080e7          	jalr	1332(ra) # 80001294 <uvminit>
  p->sz = PGSIZE;
    80001d68:	6785                	lui	a5,0x1
    80001d6a:	e4bc                	sd	a5,72(s1)
  p->tf->epc = 0;      // user program counter
    80001d6c:	6cb8                	ld	a4,88(s1)
    80001d6e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->tf->sp = PGSIZE;  // user stack pointer
    80001d72:	6cb8                	ld	a4,88(s1)
    80001d74:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d76:	4641                	li	a2,16
    80001d78:	00005597          	auipc	a1,0x5
    80001d7c:	60858593          	addi	a1,a1,1544 # 80007380 <userret+0x2f0>
    80001d80:	15848513          	addi	a0,s1,344
    80001d84:	fffff097          	auipc	ra,0xfffff
    80001d88:	f40080e7          	jalr	-192(ra) # 80000cc4 <safestrcpy>
  p->cwd = namei("/");
    80001d8c:	00005517          	auipc	a0,0x5
    80001d90:	60450513          	addi	a0,a0,1540 # 80007390 <userret+0x300>
    80001d94:	00002097          	auipc	ra,0x2
    80001d98:	0b2080e7          	jalr	178(ra) # 80003e46 <namei>
    80001d9c:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001da0:	4789                	li	a5,2
    80001da2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001da4:	8526                	mv	a0,s1
    80001da6:	fffff097          	auipc	ra,0xfffff
    80001daa:	d80080e7          	jalr	-640(ra) # 80000b26 <release>
}
    80001dae:	60e2                	ld	ra,24(sp)
    80001db0:	6442                	ld	s0,16(sp)
    80001db2:	64a2                	ld	s1,8(sp)
    80001db4:	6105                	addi	sp,sp,32
    80001db6:	8082                	ret

0000000080001db8 <growproc>:
{
    80001db8:	1101                	addi	sp,sp,-32
    80001dba:	ec06                	sd	ra,24(sp)
    80001dbc:	e822                	sd	s0,16(sp)
    80001dbe:	e426                	sd	s1,8(sp)
    80001dc0:	e04a                	sd	s2,0(sp)
    80001dc2:	1000                	addi	s0,sp,32
    80001dc4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001dc6:	00000097          	auipc	ra,0x0
    80001dca:	cf8080e7          	jalr	-776(ra) # 80001abe <myproc>
    80001dce:	892a                	mv	s2,a0
  sz = p->sz;
    80001dd0:	652c                	ld	a1,72(a0)
    80001dd2:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001dd6:	00904f63          	bgtz	s1,80001df4 <growproc+0x3c>
  } else if(n < 0){
    80001dda:	0204cc63          	bltz	s1,80001e12 <growproc+0x5a>
  p->sz = sz;
    80001dde:	1602                	slli	a2,a2,0x20
    80001de0:	9201                	srli	a2,a2,0x20
    80001de2:	04c93423          	sd	a2,72(s2)
  return 0;
    80001de6:	4501                	li	a0,0
}
    80001de8:	60e2                	ld	ra,24(sp)
    80001dea:	6442                	ld	s0,16(sp)
    80001dec:	64a2                	ld	s1,8(sp)
    80001dee:	6902                	ld	s2,0(sp)
    80001df0:	6105                	addi	sp,sp,32
    80001df2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001df4:	9e25                	addw	a2,a2,s1
    80001df6:	1602                	slli	a2,a2,0x20
    80001df8:	9201                	srli	a2,a2,0x20
    80001dfa:	1582                	slli	a1,a1,0x20
    80001dfc:	9181                	srli	a1,a1,0x20
    80001dfe:	6928                	ld	a0,80(a0)
    80001e00:	fffff097          	auipc	ra,0xfffff
    80001e04:	54a080e7          	jalr	1354(ra) # 8000134a <uvmalloc>
    80001e08:	0005061b          	sext.w	a2,a0
    80001e0c:	fa69                	bnez	a2,80001dde <growproc+0x26>
      return -1;
    80001e0e:	557d                	li	a0,-1
    80001e10:	bfe1                	j	80001de8 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001e12:	9e25                	addw	a2,a2,s1
    80001e14:	1602                	slli	a2,a2,0x20
    80001e16:	9201                	srli	a2,a2,0x20
    80001e18:	1582                	slli	a1,a1,0x20
    80001e1a:	9181                	srli	a1,a1,0x20
    80001e1c:	6928                	ld	a0,80(a0)
    80001e1e:	fffff097          	auipc	ra,0xfffff
    80001e22:	4e8080e7          	jalr	1256(ra) # 80001306 <uvmdealloc>
    80001e26:	0005061b          	sext.w	a2,a0
    80001e2a:	bf55                	j	80001dde <growproc+0x26>

0000000080001e2c <fork>:
{
    80001e2c:	7179                	addi	sp,sp,-48
    80001e2e:	f406                	sd	ra,40(sp)
    80001e30:	f022                	sd	s0,32(sp)
    80001e32:	ec26                	sd	s1,24(sp)
    80001e34:	e84a                	sd	s2,16(sp)
    80001e36:	e44e                	sd	s3,8(sp)
    80001e38:	e052                	sd	s4,0(sp)
    80001e3a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e3c:	00000097          	auipc	ra,0x0
    80001e40:	c82080e7          	jalr	-894(ra) # 80001abe <myproc>
    80001e44:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001e46:	00000097          	auipc	ra,0x0
    80001e4a:	d98080e7          	jalr	-616(ra) # 80001bde <allocproc>
    80001e4e:	c175                	beqz	a0,80001f32 <fork+0x106>
    80001e50:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e52:	04893603          	ld	a2,72(s2)
    80001e56:	692c                	ld	a1,80(a0)
    80001e58:	05093503          	ld	a0,80(s2)
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	5c6080e7          	jalr	1478(ra) # 80001422 <uvmcopy>
    80001e64:	04054863          	bltz	a0,80001eb4 <fork+0x88>
  np->sz = p->sz;
    80001e68:	04893783          	ld	a5,72(s2)
    80001e6c:	04f9b423          	sd	a5,72(s3) # 4000048 <_entry-0x7bffffb8>
  np->parent = p;
    80001e70:	0329b023          	sd	s2,32(s3)
  *(np->tf) = *(p->tf);
    80001e74:	05893683          	ld	a3,88(s2)
    80001e78:	87b6                	mv	a5,a3
    80001e7a:	0589b703          	ld	a4,88(s3)
    80001e7e:	12068693          	addi	a3,a3,288
    80001e82:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e86:	6788                	ld	a0,8(a5)
    80001e88:	6b8c                	ld	a1,16(a5)
    80001e8a:	6f90                	ld	a2,24(a5)
    80001e8c:	01073023          	sd	a6,0(a4)
    80001e90:	e708                	sd	a0,8(a4)
    80001e92:	eb0c                	sd	a1,16(a4)
    80001e94:	ef10                	sd	a2,24(a4)
    80001e96:	02078793          	addi	a5,a5,32
    80001e9a:	02070713          	addi	a4,a4,32
    80001e9e:	fed792e3          	bne	a5,a3,80001e82 <fork+0x56>
  np->tf->a0 = 0;
    80001ea2:	0589b783          	ld	a5,88(s3)
    80001ea6:	0607b823          	sd	zero,112(a5)
    80001eaa:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001eae:	15000a13          	li	s4,336
    80001eb2:	a03d                	j	80001ee0 <fork+0xb4>
    freeproc(np);
    80001eb4:	854e                	mv	a0,s3
    80001eb6:	00000097          	auipc	ra,0x0
    80001eba:	e24080e7          	jalr	-476(ra) # 80001cda <freeproc>
    release(&np->lock);
    80001ebe:	854e                	mv	a0,s3
    80001ec0:	fffff097          	auipc	ra,0xfffff
    80001ec4:	c66080e7          	jalr	-922(ra) # 80000b26 <release>
    return -1;
    80001ec8:	54fd                	li	s1,-1
    80001eca:	a899                	j	80001f20 <fork+0xf4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001ecc:	00002097          	auipc	ra,0x2
    80001ed0:	606080e7          	jalr	1542(ra) # 800044d2 <filedup>
    80001ed4:	009987b3          	add	a5,s3,s1
    80001ed8:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001eda:	04a1                	addi	s1,s1,8
    80001edc:	01448763          	beq	s1,s4,80001eea <fork+0xbe>
    if(p->ofile[i])
    80001ee0:	009907b3          	add	a5,s2,s1
    80001ee4:	6388                	ld	a0,0(a5)
    80001ee6:	f17d                	bnez	a0,80001ecc <fork+0xa0>
    80001ee8:	bfcd                	j	80001eda <fork+0xae>
  np->cwd = idup(p->cwd);
    80001eea:	15093503          	ld	a0,336(s2)
    80001eee:	00001097          	auipc	ra,0x1
    80001ef2:	790080e7          	jalr	1936(ra) # 8000367e <idup>
    80001ef6:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001efa:	4641                	li	a2,16
    80001efc:	15890593          	addi	a1,s2,344
    80001f00:	15898513          	addi	a0,s3,344
    80001f04:	fffff097          	auipc	ra,0xfffff
    80001f08:	dc0080e7          	jalr	-576(ra) # 80000cc4 <safestrcpy>
  pid = np->pid;
    80001f0c:	0389a483          	lw	s1,56(s3)
  np->state = RUNNABLE;
    80001f10:	4789                	li	a5,2
    80001f12:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001f16:	854e                	mv	a0,s3
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	c0e080e7          	jalr	-1010(ra) # 80000b26 <release>
}
    80001f20:	8526                	mv	a0,s1
    80001f22:	70a2                	ld	ra,40(sp)
    80001f24:	7402                	ld	s0,32(sp)
    80001f26:	64e2                	ld	s1,24(sp)
    80001f28:	6942                	ld	s2,16(sp)
    80001f2a:	69a2                	ld	s3,8(sp)
    80001f2c:	6a02                	ld	s4,0(sp)
    80001f2e:	6145                	addi	sp,sp,48
    80001f30:	8082                	ret
    return -1;
    80001f32:	54fd                	li	s1,-1
    80001f34:	b7f5                	j	80001f20 <fork+0xf4>

0000000080001f36 <reparent>:
{
    80001f36:	7179                	addi	sp,sp,-48
    80001f38:	f406                	sd	ra,40(sp)
    80001f3a:	f022                	sd	s0,32(sp)
    80001f3c:	ec26                	sd	s1,24(sp)
    80001f3e:	e84a                	sd	s2,16(sp)
    80001f40:	e44e                	sd	s3,8(sp)
    80001f42:	e052                	sd	s4,0(sp)
    80001f44:	1800                	addi	s0,sp,48
    80001f46:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f48:	00010497          	auipc	s1,0x10
    80001f4c:	db848493          	addi	s1,s1,-584 # 80011d00 <proc>
      pp->parent = initproc;
    80001f50:	00024a17          	auipc	s4,0x24
    80001f54:	0c0a0a13          	addi	s4,s4,192 # 80026010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f58:	00015997          	auipc	s3,0x15
    80001f5c:	7a898993          	addi	s3,s3,1960 # 80017700 <tickslock>
    80001f60:	a029                	j	80001f6a <reparent+0x34>
    80001f62:	16848493          	addi	s1,s1,360
    80001f66:	03348363          	beq	s1,s3,80001f8c <reparent+0x56>
    if(pp->parent == p){
    80001f6a:	709c                	ld	a5,32(s1)
    80001f6c:	ff279be3          	bne	a5,s2,80001f62 <reparent+0x2c>
      acquire(&pp->lock);
    80001f70:	8526                	mv	a0,s1
    80001f72:	fffff097          	auipc	ra,0xfffff
    80001f76:	b60080e7          	jalr	-1184(ra) # 80000ad2 <acquire>
      pp->parent = initproc;
    80001f7a:	000a3783          	ld	a5,0(s4)
    80001f7e:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001f80:	8526                	mv	a0,s1
    80001f82:	fffff097          	auipc	ra,0xfffff
    80001f86:	ba4080e7          	jalr	-1116(ra) # 80000b26 <release>
    80001f8a:	bfe1                	j	80001f62 <reparent+0x2c>
}
    80001f8c:	70a2                	ld	ra,40(sp)
    80001f8e:	7402                	ld	s0,32(sp)
    80001f90:	64e2                	ld	s1,24(sp)
    80001f92:	6942                	ld	s2,16(sp)
    80001f94:	69a2                	ld	s3,8(sp)
    80001f96:	6a02                	ld	s4,0(sp)
    80001f98:	6145                	addi	sp,sp,48
    80001f9a:	8082                	ret

0000000080001f9c <scheduler>:
{
    80001f9c:	7139                	addi	sp,sp,-64
    80001f9e:	fc06                	sd	ra,56(sp)
    80001fa0:	f822                	sd	s0,48(sp)
    80001fa2:	f426                	sd	s1,40(sp)
    80001fa4:	f04a                	sd	s2,32(sp)
    80001fa6:	ec4e                	sd	s3,24(sp)
    80001fa8:	e852                	sd	s4,16(sp)
    80001faa:	e456                	sd	s5,8(sp)
    80001fac:	e05a                	sd	s6,0(sp)
    80001fae:	0080                	addi	s0,sp,64
    80001fb0:	8792                	mv	a5,tp
  int id = r_tp();
    80001fb2:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001fb4:	00779a93          	slli	s5,a5,0x7
    80001fb8:	00010717          	auipc	a4,0x10
    80001fbc:	93070713          	addi	a4,a4,-1744 # 800118e8 <pid_lock>
    80001fc0:	9756                	add	a4,a4,s5
    80001fc2:	00073c23          	sd	zero,24(a4)
        swtch(&c->scheduler, &p->context);
    80001fc6:	00010717          	auipc	a4,0x10
    80001fca:	94270713          	addi	a4,a4,-1726 # 80011908 <cpus+0x8>
    80001fce:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001fd0:	4989                	li	s3,2
        p->state = RUNNING;
    80001fd2:	4b0d                	li	s6,3
        c->proc = p;
    80001fd4:	079e                	slli	a5,a5,0x7
    80001fd6:	00010a17          	auipc	s4,0x10
    80001fda:	912a0a13          	addi	s4,s4,-1774 # 800118e8 <pid_lock>
    80001fde:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fe0:	00015917          	auipc	s2,0x15
    80001fe4:	72090913          	addi	s2,s2,1824 # 80017700 <tickslock>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80001fe8:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80001fec:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80001ff0:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ff4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ff8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ffc:	10079073          	csrw	sstatus,a5
    80002000:	00010497          	auipc	s1,0x10
    80002004:	d0048493          	addi	s1,s1,-768 # 80011d00 <proc>
    80002008:	a03d                	j	80002036 <scheduler+0x9a>
        p->state = RUNNING;
    8000200a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000200e:	009a3c23          	sd	s1,24(s4)
        swtch(&c->scheduler, &p->context);
    80002012:	06048593          	addi	a1,s1,96
    80002016:	8556                	mv	a0,s5
    80002018:	00000097          	auipc	ra,0x0
    8000201c:	606080e7          	jalr	1542(ra) # 8000261e <swtch>
        c->proc = 0;
    80002020:	000a3c23          	sd	zero,24(s4)
      release(&p->lock);
    80002024:	8526                	mv	a0,s1
    80002026:	fffff097          	auipc	ra,0xfffff
    8000202a:	b00080e7          	jalr	-1280(ra) # 80000b26 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000202e:	16848493          	addi	s1,s1,360
    80002032:	fb248be3          	beq	s1,s2,80001fe8 <scheduler+0x4c>
      acquire(&p->lock);
    80002036:	8526                	mv	a0,s1
    80002038:	fffff097          	auipc	ra,0xfffff
    8000203c:	a9a080e7          	jalr	-1382(ra) # 80000ad2 <acquire>
      if(p->state == RUNNABLE) {
    80002040:	4c9c                	lw	a5,24(s1)
    80002042:	ff3791e3          	bne	a5,s3,80002024 <scheduler+0x88>
    80002046:	b7d1                	j	8000200a <scheduler+0x6e>

0000000080002048 <sched>:
{
    80002048:	7179                	addi	sp,sp,-48
    8000204a:	f406                	sd	ra,40(sp)
    8000204c:	f022                	sd	s0,32(sp)
    8000204e:	ec26                	sd	s1,24(sp)
    80002050:	e84a                	sd	s2,16(sp)
    80002052:	e44e                	sd	s3,8(sp)
    80002054:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002056:	00000097          	auipc	ra,0x0
    8000205a:	a68080e7          	jalr	-1432(ra) # 80001abe <myproc>
    8000205e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002060:	fffff097          	auipc	ra,0xfffff
    80002064:	a32080e7          	jalr	-1486(ra) # 80000a92 <holding>
    80002068:	c93d                	beqz	a0,800020de <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000206a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000206c:	2781                	sext.w	a5,a5
    8000206e:	079e                	slli	a5,a5,0x7
    80002070:	00010717          	auipc	a4,0x10
    80002074:	87870713          	addi	a4,a4,-1928 # 800118e8 <pid_lock>
    80002078:	97ba                	add	a5,a5,a4
    8000207a:	0907a703          	lw	a4,144(a5)
    8000207e:	4785                	li	a5,1
    80002080:	06f71763          	bne	a4,a5,800020ee <sched+0xa6>
  if(p->state == RUNNING)
    80002084:	4c98                	lw	a4,24(s1)
    80002086:	478d                	li	a5,3
    80002088:	06f70b63          	beq	a4,a5,800020fe <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000208c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002090:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002092:	efb5                	bnez	a5,8000210e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002094:	8792                	mv	a5,tp
  intena = mycpu()->intena; 
    80002096:	00010917          	auipc	s2,0x10
    8000209a:	85290913          	addi	s2,s2,-1966 # 800118e8 <pid_lock>
    8000209e:	2781                	sext.w	a5,a5
    800020a0:	079e                	slli	a5,a5,0x7
    800020a2:	97ca                	add	a5,a5,s2
    800020a4:	0947a983          	lw	s3,148(a5)
    800020a8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->scheduler);
    800020aa:	2781                	sext.w	a5,a5
    800020ac:	079e                	slli	a5,a5,0x7
    800020ae:	00010597          	auipc	a1,0x10
    800020b2:	85a58593          	addi	a1,a1,-1958 # 80011908 <cpus+0x8>
    800020b6:	95be                	add	a1,a1,a5
    800020b8:	06048513          	addi	a0,s1,96
    800020bc:	00000097          	auipc	ra,0x0
    800020c0:	562080e7          	jalr	1378(ra) # 8000261e <swtch>
    800020c4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800020c6:	2781                	sext.w	a5,a5
    800020c8:	079e                	slli	a5,a5,0x7
    800020ca:	97ca                	add	a5,a5,s2
    800020cc:	0937aa23          	sw	s3,148(a5)
}
    800020d0:	70a2                	ld	ra,40(sp)
    800020d2:	7402                	ld	s0,32(sp)
    800020d4:	64e2                	ld	s1,24(sp)
    800020d6:	6942                	ld	s2,16(sp)
    800020d8:	69a2                	ld	s3,8(sp)
    800020da:	6145                	addi	sp,sp,48
    800020dc:	8082                	ret
    panic("sched p->lock");
    800020de:	00005517          	auipc	a0,0x5
    800020e2:	2ba50513          	addi	a0,a0,698 # 80007398 <userret+0x308>
    800020e6:	ffffe097          	auipc	ra,0xffffe
    800020ea:	468080e7          	jalr	1128(ra) # 8000054e <panic>
    panic("sched locks");
    800020ee:	00005517          	auipc	a0,0x5
    800020f2:	2ba50513          	addi	a0,a0,698 # 800073a8 <userret+0x318>
    800020f6:	ffffe097          	auipc	ra,0xffffe
    800020fa:	458080e7          	jalr	1112(ra) # 8000054e <panic>
    panic("sched running");
    800020fe:	00005517          	auipc	a0,0x5
    80002102:	2ba50513          	addi	a0,a0,698 # 800073b8 <userret+0x328>
    80002106:	ffffe097          	auipc	ra,0xffffe
    8000210a:	448080e7          	jalr	1096(ra) # 8000054e <panic>
    panic("sched interruptible");
    8000210e:	00005517          	auipc	a0,0x5
    80002112:	2ba50513          	addi	a0,a0,698 # 800073c8 <userret+0x338>
    80002116:	ffffe097          	auipc	ra,0xffffe
    8000211a:	438080e7          	jalr	1080(ra) # 8000054e <panic>

000000008000211e <exit>:
{
    8000211e:	7179                	addi	sp,sp,-48
    80002120:	f406                	sd	ra,40(sp)
    80002122:	f022                	sd	s0,32(sp)
    80002124:	ec26                	sd	s1,24(sp)
    80002126:	e84a                	sd	s2,16(sp)
    80002128:	e44e                	sd	s3,8(sp)
    8000212a:	e052                	sd	s4,0(sp)
    8000212c:	1800                	addi	s0,sp,48
    8000212e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002130:	00000097          	auipc	ra,0x0
    80002134:	98e080e7          	jalr	-1650(ra) # 80001abe <myproc>
    80002138:	89aa                	mv	s3,a0
  if(p == initproc)
    8000213a:	00024797          	auipc	a5,0x24
    8000213e:	ed67b783          	ld	a5,-298(a5) # 80026010 <initproc>
    80002142:	0d050493          	addi	s1,a0,208
    80002146:	15050913          	addi	s2,a0,336
    8000214a:	02a79363          	bne	a5,a0,80002170 <exit+0x52>
    panic("init exiting");
    8000214e:	00005517          	auipc	a0,0x5
    80002152:	29250513          	addi	a0,a0,658 # 800073e0 <userret+0x350>
    80002156:	ffffe097          	auipc	ra,0xffffe
    8000215a:	3f8080e7          	jalr	1016(ra) # 8000054e <panic>
      fileclose(f);
    8000215e:	00002097          	auipc	ra,0x2
    80002162:	3c6080e7          	jalr	966(ra) # 80004524 <fileclose>
      p->ofile[fd] = 0;
    80002166:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000216a:	04a1                	addi	s1,s1,8
    8000216c:	01248563          	beq	s1,s2,80002176 <exit+0x58>
    if(p->ofile[fd]){
    80002170:	6088                	ld	a0,0(s1)
    80002172:	f575                	bnez	a0,8000215e <exit+0x40>
    80002174:	bfdd                	j	8000216a <exit+0x4c>
  begin_op();
    80002176:	00002097          	auipc	ra,0x2
    8000217a:	edc080e7          	jalr	-292(ra) # 80004052 <begin_op>
  iput(p->cwd);
    8000217e:	1509b503          	ld	a0,336(s3)
    80002182:	00001097          	auipc	ra,0x1
    80002186:	648080e7          	jalr	1608(ra) # 800037ca <iput>
  end_op();
    8000218a:	00002097          	auipc	ra,0x2
    8000218e:	f48080e7          	jalr	-184(ra) # 800040d2 <end_op>
  p->cwd = 0;
    80002192:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    80002196:	00024497          	auipc	s1,0x24
    8000219a:	e7a48493          	addi	s1,s1,-390 # 80026010 <initproc>
    8000219e:	6088                	ld	a0,0(s1)
    800021a0:	fffff097          	auipc	ra,0xfffff
    800021a4:	932080e7          	jalr	-1742(ra) # 80000ad2 <acquire>
  wakeup1(initproc);
    800021a8:	6088                	ld	a0,0(s1)
    800021aa:	fffff097          	auipc	ra,0xfffff
    800021ae:	7d4080e7          	jalr	2004(ra) # 8000197e <wakeup1>
  release(&initproc->lock);
    800021b2:	6088                	ld	a0,0(s1)
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	972080e7          	jalr	-1678(ra) # 80000b26 <release>
  acquire(&p->lock);
    800021bc:	854e                	mv	a0,s3
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	914080e7          	jalr	-1772(ra) # 80000ad2 <acquire>
  struct proc *original_parent = p->parent;
    800021c6:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    800021ca:	854e                	mv	a0,s3
    800021cc:	fffff097          	auipc	ra,0xfffff
    800021d0:	95a080e7          	jalr	-1702(ra) # 80000b26 <release>
  acquire(&original_parent->lock);
    800021d4:	8526                	mv	a0,s1
    800021d6:	fffff097          	auipc	ra,0xfffff
    800021da:	8fc080e7          	jalr	-1796(ra) # 80000ad2 <acquire>
  acquire(&p->lock);
    800021de:	854e                	mv	a0,s3
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	8f2080e7          	jalr	-1806(ra) # 80000ad2 <acquire>
  reparent(p);
    800021e8:	854e                	mv	a0,s3
    800021ea:	00000097          	auipc	ra,0x0
    800021ee:	d4c080e7          	jalr	-692(ra) # 80001f36 <reparent>
  wakeup1(original_parent);
    800021f2:	8526                	mv	a0,s1
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	78a080e7          	jalr	1930(ra) # 8000197e <wakeup1>
  p->xstate = status;
    800021fc:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80002200:	4791                	li	a5,4
    80002202:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80002206:	8526                	mv	a0,s1
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	91e080e7          	jalr	-1762(ra) # 80000b26 <release>
  sched();
    80002210:	00000097          	auipc	ra,0x0
    80002214:	e38080e7          	jalr	-456(ra) # 80002048 <sched>
  panic("zombie exit");
    80002218:	00005517          	auipc	a0,0x5
    8000221c:	1d850513          	addi	a0,a0,472 # 800073f0 <userret+0x360>
    80002220:	ffffe097          	auipc	ra,0xffffe
    80002224:	32e080e7          	jalr	814(ra) # 8000054e <panic>

0000000080002228 <yield>:
{
    80002228:	1101                	addi	sp,sp,-32
    8000222a:	ec06                	sd	ra,24(sp)
    8000222c:	e822                	sd	s0,16(sp)
    8000222e:	e426                	sd	s1,8(sp)
    80002230:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002232:	00000097          	auipc	ra,0x0
    80002236:	88c080e7          	jalr	-1908(ra) # 80001abe <myproc>
    8000223a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	896080e7          	jalr	-1898(ra) # 80000ad2 <acquire>
  p->state = RUNNABLE;
    80002244:	4789                	li	a5,2
    80002246:	cc9c                	sw	a5,24(s1)
  sched();
    80002248:	00000097          	auipc	ra,0x0
    8000224c:	e00080e7          	jalr	-512(ra) # 80002048 <sched>
  release(&p->lock);
    80002250:	8526                	mv	a0,s1
    80002252:	fffff097          	auipc	ra,0xfffff
    80002256:	8d4080e7          	jalr	-1836(ra) # 80000b26 <release>
}
    8000225a:	60e2                	ld	ra,24(sp)
    8000225c:	6442                	ld	s0,16(sp)
    8000225e:	64a2                	ld	s1,8(sp)
    80002260:	6105                	addi	sp,sp,32
    80002262:	8082                	ret

0000000080002264 <sleep>:
{
    80002264:	7179                	addi	sp,sp,-48
    80002266:	f406                	sd	ra,40(sp)
    80002268:	f022                	sd	s0,32(sp)
    8000226a:	ec26                	sd	s1,24(sp)
    8000226c:	e84a                	sd	s2,16(sp)
    8000226e:	e44e                	sd	s3,8(sp)
    80002270:	1800                	addi	s0,sp,48
    80002272:	89aa                	mv	s3,a0
    80002274:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002276:	00000097          	auipc	ra,0x0
    8000227a:	848080e7          	jalr	-1976(ra) # 80001abe <myproc>
    8000227e:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002280:	05250663          	beq	a0,s2,800022cc <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    80002284:	fffff097          	auipc	ra,0xfffff
    80002288:	84e080e7          	jalr	-1970(ra) # 80000ad2 <acquire>
    release(lk);
    8000228c:	854a                	mv	a0,s2
    8000228e:	fffff097          	auipc	ra,0xfffff
    80002292:	898080e7          	jalr	-1896(ra) # 80000b26 <release>
  p->chan = chan;
    80002296:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000229a:	4785                	li	a5,1
    8000229c:	cc9c                	sw	a5,24(s1)
  sched();
    8000229e:	00000097          	auipc	ra,0x0
    800022a2:	daa080e7          	jalr	-598(ra) # 80002048 <sched>
  p->chan = 0;
    800022a6:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800022aa:	8526                	mv	a0,s1
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	87a080e7          	jalr	-1926(ra) # 80000b26 <release>
    acquire(lk);
    800022b4:	854a                	mv	a0,s2
    800022b6:	fffff097          	auipc	ra,0xfffff
    800022ba:	81c080e7          	jalr	-2020(ra) # 80000ad2 <acquire>
}
    800022be:	70a2                	ld	ra,40(sp)
    800022c0:	7402                	ld	s0,32(sp)
    800022c2:	64e2                	ld	s1,24(sp)
    800022c4:	6942                	ld	s2,16(sp)
    800022c6:	69a2                	ld	s3,8(sp)
    800022c8:	6145                	addi	sp,sp,48
    800022ca:	8082                	ret
  p->chan = chan;
    800022cc:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800022d0:	4785                	li	a5,1
    800022d2:	cd1c                	sw	a5,24(a0)
  sched();
    800022d4:	00000097          	auipc	ra,0x0
    800022d8:	d74080e7          	jalr	-652(ra) # 80002048 <sched>
  p->chan = 0;
    800022dc:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    800022e0:	bff9                	j	800022be <sleep+0x5a>

00000000800022e2 <wait>:
{
    800022e2:	715d                	addi	sp,sp,-80
    800022e4:	e486                	sd	ra,72(sp)
    800022e6:	e0a2                	sd	s0,64(sp)
    800022e8:	fc26                	sd	s1,56(sp)
    800022ea:	f84a                	sd	s2,48(sp)
    800022ec:	f44e                	sd	s3,40(sp)
    800022ee:	f052                	sd	s4,32(sp)
    800022f0:	ec56                	sd	s5,24(sp)
    800022f2:	e85a                	sd	s6,16(sp)
    800022f4:	e45e                	sd	s7,8(sp)
    800022f6:	e062                	sd	s8,0(sp)
    800022f8:	0880                	addi	s0,sp,80
    800022fa:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800022fc:	fffff097          	auipc	ra,0xfffff
    80002300:	7c2080e7          	jalr	1986(ra) # 80001abe <myproc>
    80002304:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002306:	8c2a                	mv	s8,a0
    80002308:	ffffe097          	auipc	ra,0xffffe
    8000230c:	7ca080e7          	jalr	1994(ra) # 80000ad2 <acquire>
    havekids = 0;
    80002310:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002312:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    80002314:	00015997          	auipc	s3,0x15
    80002318:	3ec98993          	addi	s3,s3,1004 # 80017700 <tickslock>
        havekids = 1;
    8000231c:	4a85                	li	s5,1
    havekids = 0;
    8000231e:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002320:	00010497          	auipc	s1,0x10
    80002324:	9e048493          	addi	s1,s1,-1568 # 80011d00 <proc>
    80002328:	a08d                	j	8000238a <wait+0xa8>
          pid = np->pid;
    8000232a:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000232e:	000b0e63          	beqz	s6,8000234a <wait+0x68>
    80002332:	4691                	li	a3,4
    80002334:	03448613          	addi	a2,s1,52
    80002338:	85da                	mv	a1,s6
    8000233a:	05093503          	ld	a0,80(s2)
    8000233e:	fffff097          	auipc	ra,0xfffff
    80002342:	1fa080e7          	jalr	506(ra) # 80001538 <copyout>
    80002346:	02054263          	bltz	a0,8000236a <wait+0x88>
          freeproc(np);
    8000234a:	8526                	mv	a0,s1
    8000234c:	00000097          	auipc	ra,0x0
    80002350:	98e080e7          	jalr	-1650(ra) # 80001cda <freeproc>
          release(&np->lock);
    80002354:	8526                	mv	a0,s1
    80002356:	ffffe097          	auipc	ra,0xffffe
    8000235a:	7d0080e7          	jalr	2000(ra) # 80000b26 <release>
          release(&p->lock);
    8000235e:	854a                	mv	a0,s2
    80002360:	ffffe097          	auipc	ra,0xffffe
    80002364:	7c6080e7          	jalr	1990(ra) # 80000b26 <release>
          return pid;
    80002368:	a8a9                	j	800023c2 <wait+0xe0>
            release(&np->lock);
    8000236a:	8526                	mv	a0,s1
    8000236c:	ffffe097          	auipc	ra,0xffffe
    80002370:	7ba080e7          	jalr	1978(ra) # 80000b26 <release>
            release(&p->lock);
    80002374:	854a                	mv	a0,s2
    80002376:	ffffe097          	auipc	ra,0xffffe
    8000237a:	7b0080e7          	jalr	1968(ra) # 80000b26 <release>
            return -1;
    8000237e:	59fd                	li	s3,-1
    80002380:	a089                	j	800023c2 <wait+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    80002382:	16848493          	addi	s1,s1,360
    80002386:	03348463          	beq	s1,s3,800023ae <wait+0xcc>
      if(np->parent == p){
    8000238a:	709c                	ld	a5,32(s1)
    8000238c:	ff279be3          	bne	a5,s2,80002382 <wait+0xa0>
        acquire(&np->lock);
    80002390:	8526                	mv	a0,s1
    80002392:	ffffe097          	auipc	ra,0xffffe
    80002396:	740080e7          	jalr	1856(ra) # 80000ad2 <acquire>
        if(np->state == ZOMBIE){
    8000239a:	4c9c                	lw	a5,24(s1)
    8000239c:	f94787e3          	beq	a5,s4,8000232a <wait+0x48>
        release(&np->lock);
    800023a0:	8526                	mv	a0,s1
    800023a2:	ffffe097          	auipc	ra,0xffffe
    800023a6:	784080e7          	jalr	1924(ra) # 80000b26 <release>
        havekids = 1;
    800023aa:	8756                	mv	a4,s5
    800023ac:	bfd9                	j	80002382 <wait+0xa0>
    if(!havekids || p->killed){
    800023ae:	c701                	beqz	a4,800023b6 <wait+0xd4>
    800023b0:	03092783          	lw	a5,48(s2)
    800023b4:	c785                	beqz	a5,800023dc <wait+0xfa>
      release(&p->lock);
    800023b6:	854a                	mv	a0,s2
    800023b8:	ffffe097          	auipc	ra,0xffffe
    800023bc:	76e080e7          	jalr	1902(ra) # 80000b26 <release>
      return -1;
    800023c0:	59fd                	li	s3,-1
}
    800023c2:	854e                	mv	a0,s3
    800023c4:	60a6                	ld	ra,72(sp)
    800023c6:	6406                	ld	s0,64(sp)
    800023c8:	74e2                	ld	s1,56(sp)
    800023ca:	7942                	ld	s2,48(sp)
    800023cc:	79a2                	ld	s3,40(sp)
    800023ce:	7a02                	ld	s4,32(sp)
    800023d0:	6ae2                	ld	s5,24(sp)
    800023d2:	6b42                	ld	s6,16(sp)
    800023d4:	6ba2                	ld	s7,8(sp)
    800023d6:	6c02                	ld	s8,0(sp)
    800023d8:	6161                	addi	sp,sp,80
    800023da:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    800023dc:	85e2                	mv	a1,s8
    800023de:	854a                	mv	a0,s2
    800023e0:	00000097          	auipc	ra,0x0
    800023e4:	e84080e7          	jalr	-380(ra) # 80002264 <sleep>
    havekids = 0;
    800023e8:	bf1d                	j	8000231e <wait+0x3c>

00000000800023ea <wakeup>:
{
    800023ea:	7139                	addi	sp,sp,-64
    800023ec:	fc06                	sd	ra,56(sp)
    800023ee:	f822                	sd	s0,48(sp)
    800023f0:	f426                	sd	s1,40(sp)
    800023f2:	f04a                	sd	s2,32(sp)
    800023f4:	ec4e                	sd	s3,24(sp)
    800023f6:	e852                	sd	s4,16(sp)
    800023f8:	e456                	sd	s5,8(sp)
    800023fa:	0080                	addi	s0,sp,64
    800023fc:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800023fe:	00010497          	auipc	s1,0x10
    80002402:	90248493          	addi	s1,s1,-1790 # 80011d00 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002406:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002408:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000240a:	00015917          	auipc	s2,0x15
    8000240e:	2f690913          	addi	s2,s2,758 # 80017700 <tickslock>
    80002412:	a821                	j	8000242a <wakeup+0x40>
      p->state = RUNNABLE;
    80002414:	0154ac23          	sw	s5,24(s1)
    release(&p->lock);
    80002418:	8526                	mv	a0,s1
    8000241a:	ffffe097          	auipc	ra,0xffffe
    8000241e:	70c080e7          	jalr	1804(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002422:	16848493          	addi	s1,s1,360
    80002426:	01248e63          	beq	s1,s2,80002442 <wakeup+0x58>
    acquire(&p->lock);
    8000242a:	8526                	mv	a0,s1
    8000242c:	ffffe097          	auipc	ra,0xffffe
    80002430:	6a6080e7          	jalr	1702(ra) # 80000ad2 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002434:	4c9c                	lw	a5,24(s1)
    80002436:	ff3791e3          	bne	a5,s3,80002418 <wakeup+0x2e>
    8000243a:	749c                	ld	a5,40(s1)
    8000243c:	fd479ee3          	bne	a5,s4,80002418 <wakeup+0x2e>
    80002440:	bfd1                	j	80002414 <wakeup+0x2a>
}
    80002442:	70e2                	ld	ra,56(sp)
    80002444:	7442                	ld	s0,48(sp)
    80002446:	74a2                	ld	s1,40(sp)
    80002448:	7902                	ld	s2,32(sp)
    8000244a:	69e2                	ld	s3,24(sp)
    8000244c:	6a42                	ld	s4,16(sp)
    8000244e:	6aa2                	ld	s5,8(sp)
    80002450:	6121                	addi	sp,sp,64
    80002452:	8082                	ret

0000000080002454 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002454:	7179                	addi	sp,sp,-48
    80002456:	f406                	sd	ra,40(sp)
    80002458:	f022                	sd	s0,32(sp)
    8000245a:	ec26                	sd	s1,24(sp)
    8000245c:	e84a                	sd	s2,16(sp)
    8000245e:	e44e                	sd	s3,8(sp)
    80002460:	1800                	addi	s0,sp,48
    80002462:	892a                	mv	s2,a0
  struct proc *p;
   //for access the process table
  for(p = proc; p < &proc[NPROC]; p++){
    80002464:	00010497          	auipc	s1,0x10
    80002468:	89c48493          	addi	s1,s1,-1892 # 80011d00 <proc>
    8000246c:	00015997          	auipc	s3,0x15
    80002470:	29498993          	addi	s3,s3,660 # 80017700 <tickslock>
    acquire(&p->lock);
    80002474:	8526                	mv	a0,s1
    80002476:	ffffe097          	auipc	ra,0xffffe
    8000247a:	65c080e7          	jalr	1628(ra) # 80000ad2 <acquire>
    if(p->pid == pid){
    8000247e:	5c9c                	lw	a5,56(s1)
    80002480:	01278d63          	beq	a5,s2,8000249a <kill+0x46>
      }
      release(&p->lock);
       //for access the process table
      return 0;
    }
    release(&p->lock);
    80002484:	8526                	mv	a0,s1
    80002486:	ffffe097          	auipc	ra,0xffffe
    8000248a:	6a0080e7          	jalr	1696(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000248e:	16848493          	addi	s1,s1,360
    80002492:	ff3491e3          	bne	s1,s3,80002474 <kill+0x20>
  }
   //for access the process table
  return -1;
    80002496:	557d                	li	a0,-1
    80002498:	a821                	j	800024b0 <kill+0x5c>
      p->killed = 1;
    8000249a:	4785                	li	a5,1
    8000249c:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    8000249e:	4c98                	lw	a4,24(s1)
    800024a0:	00f70f63          	beq	a4,a5,800024be <kill+0x6a>
      release(&p->lock);
    800024a4:	8526                	mv	a0,s1
    800024a6:	ffffe097          	auipc	ra,0xffffe
    800024aa:	680080e7          	jalr	1664(ra) # 80000b26 <release>
      return 0;
    800024ae:	4501                	li	a0,0
}
    800024b0:	70a2                	ld	ra,40(sp)
    800024b2:	7402                	ld	s0,32(sp)
    800024b4:	64e2                	ld	s1,24(sp)
    800024b6:	6942                	ld	s2,16(sp)
    800024b8:	69a2                	ld	s3,8(sp)
    800024ba:	6145                	addi	sp,sp,48
    800024bc:	8082                	ret
        p->state = RUNNABLE;
    800024be:	4789                	li	a5,2
    800024c0:	cc9c                	sw	a5,24(s1)
    800024c2:	b7cd                	j	800024a4 <kill+0x50>

00000000800024c4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024c4:	7179                	addi	sp,sp,-48
    800024c6:	f406                	sd	ra,40(sp)
    800024c8:	f022                	sd	s0,32(sp)
    800024ca:	ec26                	sd	s1,24(sp)
    800024cc:	e84a                	sd	s2,16(sp)
    800024ce:	e44e                	sd	s3,8(sp)
    800024d0:	e052                	sd	s4,0(sp)
    800024d2:	1800                	addi	s0,sp,48
    800024d4:	84aa                	mv	s1,a0
    800024d6:	892e                	mv	s2,a1
    800024d8:	89b2                	mv	s3,a2
    800024da:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024dc:	fffff097          	auipc	ra,0xfffff
    800024e0:	5e2080e7          	jalr	1506(ra) # 80001abe <myproc>
  if(user_dst){
    800024e4:	c08d                	beqz	s1,80002506 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024e6:	86d2                	mv	a3,s4
    800024e8:	864e                	mv	a2,s3
    800024ea:	85ca                	mv	a1,s2
    800024ec:	6928                	ld	a0,80(a0)
    800024ee:	fffff097          	auipc	ra,0xfffff
    800024f2:	04a080e7          	jalr	74(ra) # 80001538 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024f6:	70a2                	ld	ra,40(sp)
    800024f8:	7402                	ld	s0,32(sp)
    800024fa:	64e2                	ld	s1,24(sp)
    800024fc:	6942                	ld	s2,16(sp)
    800024fe:	69a2                	ld	s3,8(sp)
    80002500:	6a02                	ld	s4,0(sp)
    80002502:	6145                	addi	sp,sp,48
    80002504:	8082                	ret
    memmove((char *)dst, src, len);
    80002506:	000a061b          	sext.w	a2,s4
    8000250a:	85ce                	mv	a1,s3
    8000250c:	854a                	mv	a0,s2
    8000250e:	ffffe097          	auipc	ra,0xffffe
    80002512:	6c0080e7          	jalr	1728(ra) # 80000bce <memmove>
    return 0;
    80002516:	8526                	mv	a0,s1
    80002518:	bff9                	j	800024f6 <either_copyout+0x32>

000000008000251a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000251a:	7179                	addi	sp,sp,-48
    8000251c:	f406                	sd	ra,40(sp)
    8000251e:	f022                	sd	s0,32(sp)
    80002520:	ec26                	sd	s1,24(sp)
    80002522:	e84a                	sd	s2,16(sp)
    80002524:	e44e                	sd	s3,8(sp)
    80002526:	e052                	sd	s4,0(sp)
    80002528:	1800                	addi	s0,sp,48
    8000252a:	892a                	mv	s2,a0
    8000252c:	84ae                	mv	s1,a1
    8000252e:	89b2                	mv	s3,a2
    80002530:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002532:	fffff097          	auipc	ra,0xfffff
    80002536:	58c080e7          	jalr	1420(ra) # 80001abe <myproc>
  if(user_src){
    8000253a:	c08d                	beqz	s1,8000255c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000253c:	86d2                	mv	a3,s4
    8000253e:	864e                	mv	a2,s3
    80002540:	85ca                	mv	a1,s2
    80002542:	6928                	ld	a0,80(a0)
    80002544:	fffff097          	auipc	ra,0xfffff
    80002548:	080080e7          	jalr	128(ra) # 800015c4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000254c:	70a2                	ld	ra,40(sp)
    8000254e:	7402                	ld	s0,32(sp)
    80002550:	64e2                	ld	s1,24(sp)
    80002552:	6942                	ld	s2,16(sp)
    80002554:	69a2                	ld	s3,8(sp)
    80002556:	6a02                	ld	s4,0(sp)
    80002558:	6145                	addi	sp,sp,48
    8000255a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000255c:	000a061b          	sext.w	a2,s4
    80002560:	85ce                	mv	a1,s3
    80002562:	854a                	mv	a0,s2
    80002564:	ffffe097          	auipc	ra,0xffffe
    80002568:	66a080e7          	jalr	1642(ra) # 80000bce <memmove>
    return 0;
    8000256c:	8526                	mv	a0,s1
    8000256e:	bff9                	j	8000254c <either_copyin+0x32>

0000000080002570 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002570:	715d                	addi	sp,sp,-80
    80002572:	e486                	sd	ra,72(sp)
    80002574:	e0a2                	sd	s0,64(sp)
    80002576:	fc26                	sd	s1,56(sp)
    80002578:	f84a                	sd	s2,48(sp)
    8000257a:	f44e                	sd	s3,40(sp)
    8000257c:	f052                	sd	s4,32(sp)
    8000257e:	ec56                	sd	s5,24(sp)
    80002580:	e85a                	sd	s6,16(sp)
    80002582:	e45e                	sd	s7,8(sp)
    80002584:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002586:	00005517          	auipc	a0,0x5
    8000258a:	f0250513          	addi	a0,a0,-254 # 80007488 <userret+0x3f8>
    8000258e:	ffffe097          	auipc	ra,0xffffe
    80002592:	00a080e7          	jalr	10(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002596:	00010497          	auipc	s1,0x10
    8000259a:	8c248493          	addi	s1,s1,-1854 # 80011e58 <proc+0x158>
    8000259e:	00015917          	auipc	s2,0x15
    800025a2:	2ba90913          	addi	s2,s2,698 # 80017858 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025a6:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800025a8:	00005997          	auipc	s3,0x5
    800025ac:	e5898993          	addi	s3,s3,-424 # 80007400 <userret+0x370>
    printf("%d %s %s", p->pid, state, p->name);
    800025b0:	00005a97          	auipc	s5,0x5
    800025b4:	e58a8a93          	addi	s5,s5,-424 # 80007408 <userret+0x378>
    printf("\n");
    800025b8:	00005a17          	auipc	s4,0x5
    800025bc:	ed0a0a13          	addi	s4,s4,-304 # 80007488 <userret+0x3f8>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025c0:	00005b97          	auipc	s7,0x5
    800025c4:	390b8b93          	addi	s7,s7,912 # 80007950 <states.1699>
    800025c8:	a00d                	j	800025ea <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800025ca:	ee06a583          	lw	a1,-288(a3)
    800025ce:	8556                	mv	a0,s5
    800025d0:	ffffe097          	auipc	ra,0xffffe
    800025d4:	fc8080e7          	jalr	-56(ra) # 80000598 <printf>
    printf("\n");
    800025d8:	8552                	mv	a0,s4
    800025da:	ffffe097          	auipc	ra,0xffffe
    800025de:	fbe080e7          	jalr	-66(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025e2:	16848493          	addi	s1,s1,360
    800025e6:	03248163          	beq	s1,s2,80002608 <procdump+0x98>
    if(p->state == UNUSED)
    800025ea:	86a6                	mv	a3,s1
    800025ec:	ec04a783          	lw	a5,-320(s1)
    800025f0:	dbed                	beqz	a5,800025e2 <procdump+0x72>
      state = "???";
    800025f2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025f4:	fcfb6be3          	bltu	s6,a5,800025ca <procdump+0x5a>
    800025f8:	1782                	slli	a5,a5,0x20
    800025fa:	9381                	srli	a5,a5,0x20
    800025fc:	078e                	slli	a5,a5,0x3
    800025fe:	97de                	add	a5,a5,s7
    80002600:	6390                	ld	a2,0(a5)
    80002602:	f661                	bnez	a2,800025ca <procdump+0x5a>
      state = "???";
    80002604:	864e                	mv	a2,s3
    80002606:	b7d1                	j	800025ca <procdump+0x5a>
  }
}
    80002608:	60a6                	ld	ra,72(sp)
    8000260a:	6406                	ld	s0,64(sp)
    8000260c:	74e2                	ld	s1,56(sp)
    8000260e:	7942                	ld	s2,48(sp)
    80002610:	79a2                	ld	s3,40(sp)
    80002612:	7a02                	ld	s4,32(sp)
    80002614:	6ae2                	ld	s5,24(sp)
    80002616:	6b42                	ld	s6,16(sp)
    80002618:	6ba2                	ld	s7,8(sp)
    8000261a:	6161                	addi	sp,sp,80
    8000261c:	8082                	ret

000000008000261e <swtch>:
    8000261e:	00153023          	sd	ra,0(a0)
    80002622:	00253423          	sd	sp,8(a0)
    80002626:	e900                	sd	s0,16(a0)
    80002628:	ed04                	sd	s1,24(a0)
    8000262a:	03253023          	sd	s2,32(a0)
    8000262e:	03353423          	sd	s3,40(a0)
    80002632:	03453823          	sd	s4,48(a0)
    80002636:	03553c23          	sd	s5,56(a0)
    8000263a:	05653023          	sd	s6,64(a0)
    8000263e:	05753423          	sd	s7,72(a0)
    80002642:	05853823          	sd	s8,80(a0)
    80002646:	05953c23          	sd	s9,88(a0)
    8000264a:	07a53023          	sd	s10,96(a0)
    8000264e:	07b53423          	sd	s11,104(a0)
    80002652:	0005b083          	ld	ra,0(a1)
    80002656:	0085b103          	ld	sp,8(a1)
    8000265a:	6980                	ld	s0,16(a1)
    8000265c:	6d84                	ld	s1,24(a1)
    8000265e:	0205b903          	ld	s2,32(a1)
    80002662:	0285b983          	ld	s3,40(a1)
    80002666:	0305ba03          	ld	s4,48(a1)
    8000266a:	0385ba83          	ld	s5,56(a1)
    8000266e:	0405bb03          	ld	s6,64(a1)
    80002672:	0485bb83          	ld	s7,72(a1)
    80002676:	0505bc03          	ld	s8,80(a1)
    8000267a:	0585bc83          	ld	s9,88(a1)
    8000267e:	0605bd03          	ld	s10,96(a1)
    80002682:	0685bd83          	ld	s11,104(a1)
    80002686:	8082                	ret

0000000080002688 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002688:	1141                	addi	sp,sp,-16
    8000268a:	e406                	sd	ra,8(sp)
    8000268c:	e022                	sd	s0,0(sp)
    8000268e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002690:	00005597          	auipc	a1,0x5
    80002694:	db058593          	addi	a1,a1,-592 # 80007440 <userret+0x3b0>
    80002698:	00015517          	auipc	a0,0x15
    8000269c:	06850513          	addi	a0,a0,104 # 80017700 <tickslock>
    800026a0:	ffffe097          	auipc	ra,0xffffe
    800026a4:	320080e7          	jalr	800(ra) # 800009c0 <initlock>
}
    800026a8:	60a2                	ld	ra,8(sp)
    800026aa:	6402                	ld	s0,0(sp)
    800026ac:	0141                	addi	sp,sp,16
    800026ae:	8082                	ret

00000000800026b0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800026b0:	1141                	addi	sp,sp,-16
    800026b2:	e422                	sd	s0,8(sp)
    800026b4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026b6:	00003797          	auipc	a5,0x3
    800026ba:	4ca78793          	addi	a5,a5,1226 # 80005b80 <kernelvec>
    800026be:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800026c2:	6422                	ld	s0,8(sp)
    800026c4:	0141                	addi	sp,sp,16
    800026c6:	8082                	ret

00000000800026c8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800026c8:	1141                	addi	sp,sp,-16
    800026ca:	e406                	sd	ra,8(sp)
    800026cc:	e022                	sd	s0,0(sp)
    800026ce:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800026d0:	fffff097          	auipc	ra,0xfffff
    800026d4:	3ee080e7          	jalr	1006(ra) # 80001abe <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026d8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800026dc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026de:	10079073          	csrw	sstatus,a5
  // turn off interrupts, since we're switching
  // now from kerneltrap() to usertrap().
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    800026e2:	00005617          	auipc	a2,0x5
    800026e6:	91e60613          	addi	a2,a2,-1762 # 80007000 <trampoline>
    800026ea:	00005697          	auipc	a3,0x5
    800026ee:	91668693          	addi	a3,a3,-1770 # 80007000 <trampoline>
    800026f2:	8e91                	sub	a3,a3,a2
    800026f4:	040007b7          	lui	a5,0x4000
    800026f8:	17fd                	addi	a5,a5,-1
    800026fa:	07b2                	slli	a5,a5,0xc
    800026fc:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026fe:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->tf->kernel_satp = r_satp();         // kernel page table
    80002702:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002704:	180026f3          	csrr	a3,satp
    80002708:	e314                	sd	a3,0(a4)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000270a:	6d38                	ld	a4,88(a0)
    8000270c:	6134                	ld	a3,64(a0)
    8000270e:	6585                	lui	a1,0x1
    80002710:	96ae                	add	a3,a3,a1
    80002712:	e714                	sd	a3,8(a4)
  p->tf->kernel_trap = (uint64)usertrap;
    80002714:	6d38                	ld	a4,88(a0)
    80002716:	00000697          	auipc	a3,0x0
    8000271a:	12268693          	addi	a3,a3,290 # 80002838 <usertrap>
    8000271e:	eb14                	sd	a3,16(a4)
  p->tf->kernel_hartid = r_tp();         // hartid for cpuid()
    80002720:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002722:	8692                	mv	a3,tp
    80002724:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002726:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000272a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000272e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002732:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->tf->epc);
    80002736:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002738:	6f18                	ld	a4,24(a4)
    8000273a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000273e:	692c                	ld	a1,80(a0)
    80002740:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002742:	00005717          	auipc	a4,0x5
    80002746:	94e70713          	addi	a4,a4,-1714 # 80007090 <userret>
    8000274a:	8f11                	sub	a4,a4,a2
    8000274c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    8000274e:	577d                	li	a4,-1
    80002750:	177e                	slli	a4,a4,0x3f
    80002752:	8dd9                	or	a1,a1,a4
    80002754:	02000537          	lui	a0,0x2000
    80002758:	157d                	addi	a0,a0,-1
    8000275a:	0536                	slli	a0,a0,0xd
    8000275c:	9782                	jalr	a5
}
    8000275e:	60a2                	ld	ra,8(sp)
    80002760:	6402                	ld	s0,0(sp)
    80002762:	0141                	addi	sp,sp,16
    80002764:	8082                	ret

0000000080002766 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002766:	1101                	addi	sp,sp,-32
    80002768:	ec06                	sd	ra,24(sp)
    8000276a:	e822                	sd	s0,16(sp)
    8000276c:	e426                	sd	s1,8(sp)
    8000276e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002770:	00015497          	auipc	s1,0x15
    80002774:	f9048493          	addi	s1,s1,-112 # 80017700 <tickslock>
    80002778:	8526                	mv	a0,s1
    8000277a:	ffffe097          	auipc	ra,0xffffe
    8000277e:	358080e7          	jalr	856(ra) # 80000ad2 <acquire>
  ticks++;
    80002782:	00024517          	auipc	a0,0x24
    80002786:	89650513          	addi	a0,a0,-1898 # 80026018 <ticks>
    8000278a:	411c                	lw	a5,0(a0)
    8000278c:	2785                	addiw	a5,a5,1
    8000278e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002790:	00000097          	auipc	ra,0x0
    80002794:	c5a080e7          	jalr	-934(ra) # 800023ea <wakeup>
  release(&tickslock);
    80002798:	8526                	mv	a0,s1
    8000279a:	ffffe097          	auipc	ra,0xffffe
    8000279e:	38c080e7          	jalr	908(ra) # 80000b26 <release>
}
    800027a2:	60e2                	ld	ra,24(sp)
    800027a4:	6442                	ld	s0,16(sp)
    800027a6:	64a2                	ld	s1,8(sp)
    800027a8:	6105                	addi	sp,sp,32
    800027aa:	8082                	ret

00000000800027ac <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800027ac:	1101                	addi	sp,sp,-32
    800027ae:	ec06                	sd	ra,24(sp)
    800027b0:	e822                	sd	s0,16(sp)
    800027b2:	e426                	sd	s1,8(sp)
    800027b4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027b6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800027ba:	00074d63          	bltz	a4,800027d4 <devintr+0x28>
      virtio_disk_intr();
    }

    plic_complete(irq);
    return 1;
  } else if(scause == 0x8000000000000001L){
    800027be:	57fd                	li	a5,-1
    800027c0:	17fe                	slli	a5,a5,0x3f
    800027c2:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800027c4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800027c6:	04f70863          	beq	a4,a5,80002816 <devintr+0x6a>
  }
}
    800027ca:	60e2                	ld	ra,24(sp)
    800027cc:	6442                	ld	s0,16(sp)
    800027ce:	64a2                	ld	s1,8(sp)
    800027d0:	6105                	addi	sp,sp,32
    800027d2:	8082                	ret
     (scause & 0xff) == 9){
    800027d4:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    800027d8:	46a5                	li	a3,9
    800027da:	fed792e3          	bne	a5,a3,800027be <devintr+0x12>
    int irq = plic_claim();
    800027de:	00003097          	auipc	ra,0x3
    800027e2:	4bc080e7          	jalr	1212(ra) # 80005c9a <plic_claim>
    800027e6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800027e8:	47a9                	li	a5,10
    800027ea:	00f50c63          	beq	a0,a5,80002802 <devintr+0x56>
    } else if(irq == VIRTIO0_IRQ){
    800027ee:	4785                	li	a5,1
    800027f0:	00f50e63          	beq	a0,a5,8000280c <devintr+0x60>
    plic_complete(irq);
    800027f4:	8526                	mv	a0,s1
    800027f6:	00003097          	auipc	ra,0x3
    800027fa:	4c8080e7          	jalr	1224(ra) # 80005cbe <plic_complete>
    return 1;
    800027fe:	4505                	li	a0,1
    80002800:	b7e9                	j	800027ca <devintr+0x1e>
      uartintr();
    80002802:	ffffe097          	auipc	ra,0xffffe
    80002806:	036080e7          	jalr	54(ra) # 80000838 <uartintr>
    8000280a:	b7ed                	j	800027f4 <devintr+0x48>
      virtio_disk_intr();
    8000280c:	00004097          	auipc	ra,0x4
    80002810:	942080e7          	jalr	-1726(ra) # 8000614e <virtio_disk_intr>
    80002814:	b7c5                	j	800027f4 <devintr+0x48>
    if(cpuid() == 0){
    80002816:	fffff097          	auipc	ra,0xfffff
    8000281a:	27c080e7          	jalr	636(ra) # 80001a92 <cpuid>
    8000281e:	c901                	beqz	a0,8000282e <devintr+0x82>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002820:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002824:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002826:	14479073          	csrw	sip,a5
    return 2;
    8000282a:	4509                	li	a0,2
    8000282c:	bf79                	j	800027ca <devintr+0x1e>
      clockintr();
    8000282e:	00000097          	auipc	ra,0x0
    80002832:	f38080e7          	jalr	-200(ra) # 80002766 <clockintr>
    80002836:	b7ed                	j	80002820 <devintr+0x74>

0000000080002838 <usertrap>:
{
    80002838:	1101                	addi	sp,sp,-32
    8000283a:	ec06                	sd	ra,24(sp)
    8000283c:	e822                	sd	s0,16(sp)
    8000283e:	e426                	sd	s1,8(sp)
    80002840:	e04a                	sd	s2,0(sp)
    80002842:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002844:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002848:	1007f793          	andi	a5,a5,256
    8000284c:	e7bd                	bnez	a5,800028ba <usertrap+0x82>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000284e:	00003797          	auipc	a5,0x3
    80002852:	33278793          	addi	a5,a5,818 # 80005b80 <kernelvec>
    80002856:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000285a:	fffff097          	auipc	ra,0xfffff
    8000285e:	264080e7          	jalr	612(ra) # 80001abe <myproc>
    80002862:	84aa                	mv	s1,a0
  p->tf->epc = r_sepc();
    80002864:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002866:	14102773          	csrr	a4,sepc
    8000286a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000286c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002870:	47a1                	li	a5,8
    80002872:	06f71263          	bne	a4,a5,800028d6 <usertrap+0x9e>
    if(p->killed)
    80002876:	591c                	lw	a5,48(a0)
    80002878:	eba9                	bnez	a5,800028ca <usertrap+0x92>
    p->tf->epc += 4;
    8000287a:	6cb8                	ld	a4,88(s1)
    8000287c:	6f1c                	ld	a5,24(a4)
    8000287e:	0791                	addi	a5,a5,4
    80002880:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sie" : "=r" (x) );
    80002882:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80002886:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000288a:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000288e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002892:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002896:	10079073          	csrw	sstatus,a5
    syscall();  //handle the syscall
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	324080e7          	jalr	804(ra) # 80002bbe <syscall>
  if(p->killed)
    800028a2:	589c                	lw	a5,48(s1)
    800028a4:	ebf1                	bnez	a5,80002978 <usertrap+0x140>
  usertrapret();
    800028a6:	00000097          	auipc	ra,0x0
    800028aa:	e22080e7          	jalr	-478(ra) # 800026c8 <usertrapret>
}
    800028ae:	60e2                	ld	ra,24(sp)
    800028b0:	6442                	ld	s0,16(sp)
    800028b2:	64a2                	ld	s1,8(sp)
    800028b4:	6902                	ld	s2,0(sp)
    800028b6:	6105                	addi	sp,sp,32
    800028b8:	8082                	ret
    panic("usertrap: not from user mode");
    800028ba:	00005517          	auipc	a0,0x5
    800028be:	b8e50513          	addi	a0,a0,-1138 # 80007448 <userret+0x3b8>
    800028c2:	ffffe097          	auipc	ra,0xffffe
    800028c6:	c8c080e7          	jalr	-884(ra) # 8000054e <panic>
      exit(-1);
    800028ca:	557d                	li	a0,-1
    800028cc:	00000097          	auipc	ra,0x0
    800028d0:	852080e7          	jalr	-1966(ra) # 8000211e <exit>
    800028d4:	b75d                	j	8000287a <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	ed6080e7          	jalr	-298(ra) # 800027ac <devintr>
    800028de:	892a                	mv	s2,a0
    800028e0:	e949                	bnez	a0,80002972 <usertrap+0x13a>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028e2:	14202773          	csrr	a4,scause
  } else if(0xd ==r_scause()){ //p3 this is null pointer deference
    800028e6:	47b5                	li	a5,13
    800028e8:	04f70d63          	beq	a4,a5,80002942 <usertrap+0x10a>
    800028ec:	14202773          	csrr	a4,scause
  } else if(0xf ==r_scause()){ //p3 this is write to read only memory
    800028f0:	47bd                	li	a5,15
    800028f2:	06f70463          	beq	a4,a5,8000295a <usertrap+0x122>
    800028f6:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800028fa:	5c90                	lw	a2,56(s1)
    800028fc:	00005517          	auipc	a0,0x5
    80002900:	bcc50513          	addi	a0,a0,-1076 # 800074c8 <userret+0x438>
    80002904:	ffffe097          	auipc	ra,0xffffe
    80002908:	c94080e7          	jalr	-876(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000290c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002910:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002914:	00005517          	auipc	a0,0x5
    80002918:	be450513          	addi	a0,a0,-1052 # 800074f8 <userret+0x468>
    8000291c:	ffffe097          	auipc	ra,0xffffe
    80002920:	c7c080e7          	jalr	-900(ra) # 80000598 <printf>
    p->killed = 1;
    80002924:	4785                	li	a5,1
    80002926:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002928:	557d                	li	a0,-1
    8000292a:	fffff097          	auipc	ra,0xfffff
    8000292e:	7f4080e7          	jalr	2036(ra) # 8000211e <exit>
  if(which_dev == 2)
    80002932:	4789                	li	a5,2
    80002934:	f6f919e3          	bne	s2,a5,800028a6 <usertrap+0x6e>
    yield();
    80002938:	00000097          	auipc	ra,0x0
    8000293c:	8f0080e7          	jalr	-1808(ra) # 80002228 <yield>
    80002940:	b79d                	j	800028a6 <usertrap+0x6e>
    printf("Illegal Address Accesses, pid=%d\n",p->pid);
    80002942:	5c8c                	lw	a1,56(s1)
    80002944:	00005517          	auipc	a0,0x5
    80002948:	b2450513          	addi	a0,a0,-1244 # 80007468 <userret+0x3d8>
    8000294c:	ffffe097          	auipc	ra,0xffffe
    80002950:	c4c080e7          	jalr	-948(ra) # 80000598 <printf>
    p->killed = 1;
    80002954:	4785                	li	a5,1
    80002956:	d89c                	sw	a5,48(s1)
    80002958:	bfc1                	j	80002928 <usertrap+0xf0>
    printf("Do not have write permission to this address , pid=%d\n",p->pid);
    8000295a:	5c8c                	lw	a1,56(s1)
    8000295c:	00005517          	auipc	a0,0x5
    80002960:	b3450513          	addi	a0,a0,-1228 # 80007490 <userret+0x400>
    80002964:	ffffe097          	auipc	ra,0xffffe
    80002968:	c34080e7          	jalr	-972(ra) # 80000598 <printf>
    p->killed = 1;
    8000296c:	4785                	li	a5,1
    8000296e:	d89c                	sw	a5,48(s1)
    80002970:	bf65                	j	80002928 <usertrap+0xf0>
  if(p->killed)
    80002972:	589c                	lw	a5,48(s1)
    80002974:	dfdd                	beqz	a5,80002932 <usertrap+0xfa>
    80002976:	bf4d                	j	80002928 <usertrap+0xf0>
  int which_dev = 0;
    80002978:	4901                	li	s2,0
    8000297a:	b77d                	j	80002928 <usertrap+0xf0>

000000008000297c <kerneltrap>:
{
    8000297c:	7179                	addi	sp,sp,-48
    8000297e:	f406                	sd	ra,40(sp)
    80002980:	f022                	sd	s0,32(sp)
    80002982:	ec26                	sd	s1,24(sp)
    80002984:	e84a                	sd	s2,16(sp)
    80002986:	e44e                	sd	s3,8(sp)
    80002988:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000298a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000298e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002992:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002996:	1004f793          	andi	a5,s1,256
    8000299a:	cb85                	beqz	a5,800029ca <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000299c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800029a0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800029a2:	ef85                	bnez	a5,800029da <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800029a4:	00000097          	auipc	ra,0x0
    800029a8:	e08080e7          	jalr	-504(ra) # 800027ac <devintr>
    800029ac:	cd1d                	beqz	a0,800029ea <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800029ae:	4789                	li	a5,2
    800029b0:	06f50a63          	beq	a0,a5,80002a24 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800029b4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029b8:	10049073          	csrw	sstatus,s1
}
    800029bc:	70a2                	ld	ra,40(sp)
    800029be:	7402                	ld	s0,32(sp)
    800029c0:	64e2                	ld	s1,24(sp)
    800029c2:	6942                	ld	s2,16(sp)
    800029c4:	69a2                	ld	s3,8(sp)
    800029c6:	6145                	addi	sp,sp,48
    800029c8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800029ca:	00005517          	auipc	a0,0x5
    800029ce:	b4e50513          	addi	a0,a0,-1202 # 80007518 <userret+0x488>
    800029d2:	ffffe097          	auipc	ra,0xffffe
    800029d6:	b7c080e7          	jalr	-1156(ra) # 8000054e <panic>
    panic("kerneltrap: interrupts enabled");
    800029da:	00005517          	auipc	a0,0x5
    800029de:	b6650513          	addi	a0,a0,-1178 # 80007540 <userret+0x4b0>
    800029e2:	ffffe097          	auipc	ra,0xffffe
    800029e6:	b6c080e7          	jalr	-1172(ra) # 8000054e <panic>
    printf("scause %p\n", scause);
    800029ea:	85ce                	mv	a1,s3
    800029ec:	00005517          	auipc	a0,0x5
    800029f0:	b7450513          	addi	a0,a0,-1164 # 80007560 <userret+0x4d0>
    800029f4:	ffffe097          	auipc	ra,0xffffe
    800029f8:	ba4080e7          	jalr	-1116(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029fc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a00:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a04:	00005517          	auipc	a0,0x5
    80002a08:	b6c50513          	addi	a0,a0,-1172 # 80007570 <userret+0x4e0>
    80002a0c:	ffffe097          	auipc	ra,0xffffe
    80002a10:	b8c080e7          	jalr	-1140(ra) # 80000598 <printf>
    panic("kerneltrap");
    80002a14:	00005517          	auipc	a0,0x5
    80002a18:	b7450513          	addi	a0,a0,-1164 # 80007588 <userret+0x4f8>
    80002a1c:	ffffe097          	auipc	ra,0xffffe
    80002a20:	b32080e7          	jalr	-1230(ra) # 8000054e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a24:	fffff097          	auipc	ra,0xfffff
    80002a28:	09a080e7          	jalr	154(ra) # 80001abe <myproc>
    80002a2c:	d541                	beqz	a0,800029b4 <kerneltrap+0x38>
    80002a2e:	fffff097          	auipc	ra,0xfffff
    80002a32:	090080e7          	jalr	144(ra) # 80001abe <myproc>
    80002a36:	4d18                	lw	a4,24(a0)
    80002a38:	478d                	li	a5,3
    80002a3a:	f6f71de3          	bne	a4,a5,800029b4 <kerneltrap+0x38>
    yield();
    80002a3e:	fffff097          	auipc	ra,0xfffff
    80002a42:	7ea080e7          	jalr	2026(ra) # 80002228 <yield>
    80002a46:	b7bd                	j	800029b4 <kerneltrap+0x38>

0000000080002a48 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a48:	1101                	addi	sp,sp,-32
    80002a4a:	ec06                	sd	ra,24(sp)
    80002a4c:	e822                	sd	s0,16(sp)
    80002a4e:	e426                	sd	s1,8(sp)
    80002a50:	1000                	addi	s0,sp,32
    80002a52:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a54:	fffff097          	auipc	ra,0xfffff
    80002a58:	06a080e7          	jalr	106(ra) # 80001abe <myproc>
  switch (n) {
    80002a5c:	4795                	li	a5,5
    80002a5e:	0497e163          	bltu	a5,s1,80002aa0 <argraw+0x58>
    80002a62:	048a                	slli	s1,s1,0x2
    80002a64:	00005717          	auipc	a4,0x5
    80002a68:	f1470713          	addi	a4,a4,-236 # 80007978 <states.1699+0x28>
    80002a6c:	94ba                	add	s1,s1,a4
    80002a6e:	409c                	lw	a5,0(s1)
    80002a70:	97ba                	add	a5,a5,a4
    80002a72:	8782                	jr	a5
  case 0:
    return p->tf->a0;
    80002a74:	6d3c                	ld	a5,88(a0)
    80002a76:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
    80002a78:	60e2                	ld	ra,24(sp)
    80002a7a:	6442                	ld	s0,16(sp)
    80002a7c:	64a2                	ld	s1,8(sp)
    80002a7e:	6105                	addi	sp,sp,32
    80002a80:	8082                	ret
    return p->tf->a1;
    80002a82:	6d3c                	ld	a5,88(a0)
    80002a84:	7fa8                	ld	a0,120(a5)
    80002a86:	bfcd                	j	80002a78 <argraw+0x30>
    return p->tf->a2;
    80002a88:	6d3c                	ld	a5,88(a0)
    80002a8a:	63c8                	ld	a0,128(a5)
    80002a8c:	b7f5                	j	80002a78 <argraw+0x30>
    return p->tf->a3;
    80002a8e:	6d3c                	ld	a5,88(a0)
    80002a90:	67c8                	ld	a0,136(a5)
    80002a92:	b7dd                	j	80002a78 <argraw+0x30>
    return p->tf->a4;
    80002a94:	6d3c                	ld	a5,88(a0)
    80002a96:	6bc8                	ld	a0,144(a5)
    80002a98:	b7c5                	j	80002a78 <argraw+0x30>
    return p->tf->a5;
    80002a9a:	6d3c                	ld	a5,88(a0)
    80002a9c:	6fc8                	ld	a0,152(a5)
    80002a9e:	bfe9                	j	80002a78 <argraw+0x30>
  panic("argraw");
    80002aa0:	00005517          	auipc	a0,0x5
    80002aa4:	af850513          	addi	a0,a0,-1288 # 80007598 <userret+0x508>
    80002aa8:	ffffe097          	auipc	ra,0xffffe
    80002aac:	aa6080e7          	jalr	-1370(ra) # 8000054e <panic>

0000000080002ab0 <fetchaddr>:
{
    80002ab0:	1101                	addi	sp,sp,-32
    80002ab2:	ec06                	sd	ra,24(sp)
    80002ab4:	e822                	sd	s0,16(sp)
    80002ab6:	e426                	sd	s1,8(sp)
    80002ab8:	e04a                	sd	s2,0(sp)
    80002aba:	1000                	addi	s0,sp,32
    80002abc:	84aa                	mv	s1,a0
    80002abe:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002ac0:	fffff097          	auipc	ra,0xfffff
    80002ac4:	ffe080e7          	jalr	-2(ra) # 80001abe <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002ac8:	653c                	ld	a5,72(a0)
    80002aca:	02f4f863          	bgeu	s1,a5,80002afa <fetchaddr+0x4a>
    80002ace:	00848713          	addi	a4,s1,8
    80002ad2:	02e7e663          	bltu	a5,a4,80002afe <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002ad6:	46a1                	li	a3,8
    80002ad8:	8626                	mv	a2,s1
    80002ada:	85ca                	mv	a1,s2
    80002adc:	6928                	ld	a0,80(a0)
    80002ade:	fffff097          	auipc	ra,0xfffff
    80002ae2:	ae6080e7          	jalr	-1306(ra) # 800015c4 <copyin>
    80002ae6:	00a03533          	snez	a0,a0
    80002aea:	40a00533          	neg	a0,a0
}
    80002aee:	60e2                	ld	ra,24(sp)
    80002af0:	6442                	ld	s0,16(sp)
    80002af2:	64a2                	ld	s1,8(sp)
    80002af4:	6902                	ld	s2,0(sp)
    80002af6:	6105                	addi	sp,sp,32
    80002af8:	8082                	ret
    return -1;
    80002afa:	557d                	li	a0,-1
    80002afc:	bfcd                	j	80002aee <fetchaddr+0x3e>
    80002afe:	557d                	li	a0,-1
    80002b00:	b7fd                	j	80002aee <fetchaddr+0x3e>

0000000080002b02 <fetchstr>:
{
    80002b02:	7179                	addi	sp,sp,-48
    80002b04:	f406                	sd	ra,40(sp)
    80002b06:	f022                	sd	s0,32(sp)
    80002b08:	ec26                	sd	s1,24(sp)
    80002b0a:	e84a                	sd	s2,16(sp)
    80002b0c:	e44e                	sd	s3,8(sp)
    80002b0e:	1800                	addi	s0,sp,48
    80002b10:	892a                	mv	s2,a0
    80002b12:	84ae                	mv	s1,a1
    80002b14:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002b16:	fffff097          	auipc	ra,0xfffff
    80002b1a:	fa8080e7          	jalr	-88(ra) # 80001abe <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002b1e:	86ce                	mv	a3,s3
    80002b20:	864a                	mv	a2,s2
    80002b22:	85a6                	mv	a1,s1
    80002b24:	6928                	ld	a0,80(a0)
    80002b26:	fffff097          	auipc	ra,0xfffff
    80002b2a:	b2a080e7          	jalr	-1238(ra) # 80001650 <copyinstr>
  if(err < 0)
    80002b2e:	00054763          	bltz	a0,80002b3c <fetchstr+0x3a>
  return strlen(buf);
    80002b32:	8526                	mv	a0,s1
    80002b34:	ffffe097          	auipc	ra,0xffffe
    80002b38:	1c2080e7          	jalr	450(ra) # 80000cf6 <strlen>
}
    80002b3c:	70a2                	ld	ra,40(sp)
    80002b3e:	7402                	ld	s0,32(sp)
    80002b40:	64e2                	ld	s1,24(sp)
    80002b42:	6942                	ld	s2,16(sp)
    80002b44:	69a2                	ld	s3,8(sp)
    80002b46:	6145                	addi	sp,sp,48
    80002b48:	8082                	ret

0000000080002b4a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002b4a:	1101                	addi	sp,sp,-32
    80002b4c:	ec06                	sd	ra,24(sp)
    80002b4e:	e822                	sd	s0,16(sp)
    80002b50:	e426                	sd	s1,8(sp)
    80002b52:	1000                	addi	s0,sp,32
    80002b54:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b56:	00000097          	auipc	ra,0x0
    80002b5a:	ef2080e7          	jalr	-270(ra) # 80002a48 <argraw>
    80002b5e:	c088                	sw	a0,0(s1)
  return 0;
}
    80002b60:	4501                	li	a0,0
    80002b62:	60e2                	ld	ra,24(sp)
    80002b64:	6442                	ld	s0,16(sp)
    80002b66:	64a2                	ld	s1,8(sp)
    80002b68:	6105                	addi	sp,sp,32
    80002b6a:	8082                	ret

0000000080002b6c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002b6c:	1101                	addi	sp,sp,-32
    80002b6e:	ec06                	sd	ra,24(sp)
    80002b70:	e822                	sd	s0,16(sp)
    80002b72:	e426                	sd	s1,8(sp)
    80002b74:	1000                	addi	s0,sp,32
    80002b76:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b78:	00000097          	auipc	ra,0x0
    80002b7c:	ed0080e7          	jalr	-304(ra) # 80002a48 <argraw>
    80002b80:	e088                	sd	a0,0(s1)
  //if(*ip < PGSIZE)
    //return -1;
  return 0;
}
    80002b82:	4501                	li	a0,0
    80002b84:	60e2                	ld	ra,24(sp)
    80002b86:	6442                	ld	s0,16(sp)
    80002b88:	64a2                	ld	s1,8(sp)
    80002b8a:	6105                	addi	sp,sp,32
    80002b8c:	8082                	ret

0000000080002b8e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002b8e:	1101                	addi	sp,sp,-32
    80002b90:	ec06                	sd	ra,24(sp)
    80002b92:	e822                	sd	s0,16(sp)
    80002b94:	e426                	sd	s1,8(sp)
    80002b96:	e04a                	sd	s2,0(sp)
    80002b98:	1000                	addi	s0,sp,32
    80002b9a:	84ae                	mv	s1,a1
    80002b9c:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002b9e:	00000097          	auipc	ra,0x0
    80002ba2:	eaa080e7          	jalr	-342(ra) # 80002a48 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002ba6:	864a                	mv	a2,s2
    80002ba8:	85a6                	mv	a1,s1
    80002baa:	00000097          	auipc	ra,0x0
    80002bae:	f58080e7          	jalr	-168(ra) # 80002b02 <fetchstr>
}
    80002bb2:	60e2                	ld	ra,24(sp)
    80002bb4:	6442                	ld	s0,16(sp)
    80002bb6:	64a2                	ld	s1,8(sp)
    80002bb8:	6902                	ld	s2,0(sp)
    80002bba:	6105                	addi	sp,sp,32
    80002bbc:	8082                	ret

0000000080002bbe <syscall>:
[SYS_munprotect]   sys_munprotect, //p3 edited
};

void
syscall(void)
{
    80002bbe:	1101                	addi	sp,sp,-32
    80002bc0:	ec06                	sd	ra,24(sp)
    80002bc2:	e822                	sd	s0,16(sp)
    80002bc4:	e426                	sd	s1,8(sp)
    80002bc6:	e04a                	sd	s2,0(sp)
    80002bc8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002bca:	fffff097          	auipc	ra,0xfffff
    80002bce:	ef4080e7          	jalr	-268(ra) # 80001abe <myproc>
    80002bd2:	84aa                	mv	s1,a0

  num = p->tf->a7;
    80002bd4:	05853903          	ld	s2,88(a0)
    80002bd8:	0a893783          	ld	a5,168(s2)
    80002bdc:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002be0:	37fd                	addiw	a5,a5,-1
    80002be2:	4759                	li	a4,22
    80002be4:	00f76f63          	bltu	a4,a5,80002c02 <syscall+0x44>
    80002be8:	00369713          	slli	a4,a3,0x3
    80002bec:	00005797          	auipc	a5,0x5
    80002bf0:	da478793          	addi	a5,a5,-604 # 80007990 <syscalls>
    80002bf4:	97ba                	add	a5,a5,a4
    80002bf6:	639c                	ld	a5,0(a5)
    80002bf8:	c789                	beqz	a5,80002c02 <syscall+0x44>
    p->tf->a0 = syscalls[num]();
    80002bfa:	9782                	jalr	a5
    80002bfc:	06a93823          	sd	a0,112(s2)
    80002c00:	a839                	j	80002c1e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c02:	15848613          	addi	a2,s1,344
    80002c06:	5c8c                	lw	a1,56(s1)
    80002c08:	00005517          	auipc	a0,0x5
    80002c0c:	99850513          	addi	a0,a0,-1640 # 800075a0 <userret+0x510>
    80002c10:	ffffe097          	auipc	ra,0xffffe
    80002c14:	988080e7          	jalr	-1656(ra) # 80000598 <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
    80002c18:	6cbc                	ld	a5,88(s1)
    80002c1a:	577d                	li	a4,-1
    80002c1c:	fbb8                	sd	a4,112(a5)
  }
}
    80002c1e:	60e2                	ld	ra,24(sp)
    80002c20:	6442                	ld	s0,16(sp)
    80002c22:	64a2                	ld	s1,8(sp)
    80002c24:	6902                	ld	s2,0(sp)
    80002c26:	6105                	addi	sp,sp,32
    80002c28:	8082                	ret

0000000080002c2a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002c2a:	1101                	addi	sp,sp,-32
    80002c2c:	ec06                	sd	ra,24(sp)
    80002c2e:	e822                	sd	s0,16(sp)
    80002c30:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002c32:	fec40593          	addi	a1,s0,-20
    80002c36:	4501                	li	a0,0
    80002c38:	00000097          	auipc	ra,0x0
    80002c3c:	f12080e7          	jalr	-238(ra) # 80002b4a <argint>
    return -1;
    80002c40:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c42:	00054963          	bltz	a0,80002c54 <sys_exit+0x2a>
  exit(n);
    80002c46:	fec42503          	lw	a0,-20(s0)
    80002c4a:	fffff097          	auipc	ra,0xfffff
    80002c4e:	4d4080e7          	jalr	1236(ra) # 8000211e <exit>
  return 0;  // not reached
    80002c52:	4781                	li	a5,0
}
    80002c54:	853e                	mv	a0,a5
    80002c56:	60e2                	ld	ra,24(sp)
    80002c58:	6442                	ld	s0,16(sp)
    80002c5a:	6105                	addi	sp,sp,32
    80002c5c:	8082                	ret

0000000080002c5e <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c5e:	1141                	addi	sp,sp,-16
    80002c60:	e406                	sd	ra,8(sp)
    80002c62:	e022                	sd	s0,0(sp)
    80002c64:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c66:	fffff097          	auipc	ra,0xfffff
    80002c6a:	e58080e7          	jalr	-424(ra) # 80001abe <myproc>
}
    80002c6e:	5d08                	lw	a0,56(a0)
    80002c70:	60a2                	ld	ra,8(sp)
    80002c72:	6402                	ld	s0,0(sp)
    80002c74:	0141                	addi	sp,sp,16
    80002c76:	8082                	ret

0000000080002c78 <sys_fork>:

uint64
sys_fork(void)
{
    80002c78:	1141                	addi	sp,sp,-16
    80002c7a:	e406                	sd	ra,8(sp)
    80002c7c:	e022                	sd	s0,0(sp)
    80002c7e:	0800                	addi	s0,sp,16
  return fork();
    80002c80:	fffff097          	auipc	ra,0xfffff
    80002c84:	1ac080e7          	jalr	428(ra) # 80001e2c <fork>
}
    80002c88:	60a2                	ld	ra,8(sp)
    80002c8a:	6402                	ld	s0,0(sp)
    80002c8c:	0141                	addi	sp,sp,16
    80002c8e:	8082                	ret

0000000080002c90 <sys_wait>:

uint64
sys_wait(void)
{
    80002c90:	1101                	addi	sp,sp,-32
    80002c92:	ec06                	sd	ra,24(sp)
    80002c94:	e822                	sd	s0,16(sp)
    80002c96:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002c98:	fe840593          	addi	a1,s0,-24
    80002c9c:	4501                	li	a0,0
    80002c9e:	00000097          	auipc	ra,0x0
    80002ca2:	ece080e7          	jalr	-306(ra) # 80002b6c <argaddr>
    80002ca6:	87aa                	mv	a5,a0
    return -1;
    80002ca8:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002caa:	0007c863          	bltz	a5,80002cba <sys_wait+0x2a>
  return wait(p);
    80002cae:	fe843503          	ld	a0,-24(s0)
    80002cb2:	fffff097          	auipc	ra,0xfffff
    80002cb6:	630080e7          	jalr	1584(ra) # 800022e2 <wait>
}
    80002cba:	60e2                	ld	ra,24(sp)
    80002cbc:	6442                	ld	s0,16(sp)
    80002cbe:	6105                	addi	sp,sp,32
    80002cc0:	8082                	ret

0000000080002cc2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002cc2:	7179                	addi	sp,sp,-48
    80002cc4:	f406                	sd	ra,40(sp)
    80002cc6:	f022                	sd	s0,32(sp)
    80002cc8:	ec26                	sd	s1,24(sp)
    80002cca:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002ccc:	fdc40593          	addi	a1,s0,-36
    80002cd0:	4501                	li	a0,0
    80002cd2:	00000097          	auipc	ra,0x0
    80002cd6:	e78080e7          	jalr	-392(ra) # 80002b4a <argint>
    80002cda:	87aa                	mv	a5,a0
    return -1;
    80002cdc:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002cde:	0207c063          	bltz	a5,80002cfe <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002ce2:	fffff097          	auipc	ra,0xfffff
    80002ce6:	ddc080e7          	jalr	-548(ra) # 80001abe <myproc>
    80002cea:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002cec:	fdc42503          	lw	a0,-36(s0)
    80002cf0:	fffff097          	auipc	ra,0xfffff
    80002cf4:	0c8080e7          	jalr	200(ra) # 80001db8 <growproc>
    80002cf8:	00054863          	bltz	a0,80002d08 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002cfc:	8526                	mv	a0,s1
}
    80002cfe:	70a2                	ld	ra,40(sp)
    80002d00:	7402                	ld	s0,32(sp)
    80002d02:	64e2                	ld	s1,24(sp)
    80002d04:	6145                	addi	sp,sp,48
    80002d06:	8082                	ret
    return -1;
    80002d08:	557d                	li	a0,-1
    80002d0a:	bfd5                	j	80002cfe <sys_sbrk+0x3c>

0000000080002d0c <sys_sleep>:

uint64
sys_sleep(void)
{
    80002d0c:	7139                	addi	sp,sp,-64
    80002d0e:	fc06                	sd	ra,56(sp)
    80002d10:	f822                	sd	s0,48(sp)
    80002d12:	f426                	sd	s1,40(sp)
    80002d14:	f04a                	sd	s2,32(sp)
    80002d16:	ec4e                	sd	s3,24(sp)
    80002d18:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002d1a:	fcc40593          	addi	a1,s0,-52
    80002d1e:	4501                	li	a0,0
    80002d20:	00000097          	auipc	ra,0x0
    80002d24:	e2a080e7          	jalr	-470(ra) # 80002b4a <argint>
    return -1;
    80002d28:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002d2a:	06054563          	bltz	a0,80002d94 <sys_sleep+0x88>
  acquire(&tickslock);
    80002d2e:	00015517          	auipc	a0,0x15
    80002d32:	9d250513          	addi	a0,a0,-1582 # 80017700 <tickslock>
    80002d36:	ffffe097          	auipc	ra,0xffffe
    80002d3a:	d9c080e7          	jalr	-612(ra) # 80000ad2 <acquire>
  ticks0 = ticks;
    80002d3e:	00023917          	auipc	s2,0x23
    80002d42:	2da92903          	lw	s2,730(s2) # 80026018 <ticks>
  while(ticks - ticks0 < n){
    80002d46:	fcc42783          	lw	a5,-52(s0)
    80002d4a:	cf85                	beqz	a5,80002d82 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d4c:	00015997          	auipc	s3,0x15
    80002d50:	9b498993          	addi	s3,s3,-1612 # 80017700 <tickslock>
    80002d54:	00023497          	auipc	s1,0x23
    80002d58:	2c448493          	addi	s1,s1,708 # 80026018 <ticks>
    if(myproc()->killed){
    80002d5c:	fffff097          	auipc	ra,0xfffff
    80002d60:	d62080e7          	jalr	-670(ra) # 80001abe <myproc>
    80002d64:	591c                	lw	a5,48(a0)
    80002d66:	ef9d                	bnez	a5,80002da4 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002d68:	85ce                	mv	a1,s3
    80002d6a:	8526                	mv	a0,s1
    80002d6c:	fffff097          	auipc	ra,0xfffff
    80002d70:	4f8080e7          	jalr	1272(ra) # 80002264 <sleep>
  while(ticks - ticks0 < n){
    80002d74:	409c                	lw	a5,0(s1)
    80002d76:	412787bb          	subw	a5,a5,s2
    80002d7a:	fcc42703          	lw	a4,-52(s0)
    80002d7e:	fce7efe3          	bltu	a5,a4,80002d5c <sys_sleep+0x50>
  }
  release(&tickslock);
    80002d82:	00015517          	auipc	a0,0x15
    80002d86:	97e50513          	addi	a0,a0,-1666 # 80017700 <tickslock>
    80002d8a:	ffffe097          	auipc	ra,0xffffe
    80002d8e:	d9c080e7          	jalr	-612(ra) # 80000b26 <release>
  return 0;
    80002d92:	4781                	li	a5,0
}
    80002d94:	853e                	mv	a0,a5
    80002d96:	70e2                	ld	ra,56(sp)
    80002d98:	7442                	ld	s0,48(sp)
    80002d9a:	74a2                	ld	s1,40(sp)
    80002d9c:	7902                	ld	s2,32(sp)
    80002d9e:	69e2                	ld	s3,24(sp)
    80002da0:	6121                	addi	sp,sp,64
    80002da2:	8082                	ret
      release(&tickslock);
    80002da4:	00015517          	auipc	a0,0x15
    80002da8:	95c50513          	addi	a0,a0,-1700 # 80017700 <tickslock>
    80002dac:	ffffe097          	auipc	ra,0xffffe
    80002db0:	d7a080e7          	jalr	-646(ra) # 80000b26 <release>
      return -1;
    80002db4:	57fd                	li	a5,-1
    80002db6:	bff9                	j	80002d94 <sys_sleep+0x88>

0000000080002db8 <sys_kill>:

uint64
sys_kill(void)
{
    80002db8:	1101                	addi	sp,sp,-32
    80002dba:	ec06                	sd	ra,24(sp)
    80002dbc:	e822                	sd	s0,16(sp)
    80002dbe:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002dc0:	fec40593          	addi	a1,s0,-20
    80002dc4:	4501                	li	a0,0
    80002dc6:	00000097          	auipc	ra,0x0
    80002dca:	d84080e7          	jalr	-636(ra) # 80002b4a <argint>
    80002dce:	87aa                	mv	a5,a0
    return -1;
    80002dd0:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002dd2:	0007c863          	bltz	a5,80002de2 <sys_kill+0x2a>
  return kill(pid);
    80002dd6:	fec42503          	lw	a0,-20(s0)
    80002dda:	fffff097          	auipc	ra,0xfffff
    80002dde:	67a080e7          	jalr	1658(ra) # 80002454 <kill>
}
    80002de2:	60e2                	ld	ra,24(sp)
    80002de4:	6442                	ld	s0,16(sp)
    80002de6:	6105                	addi	sp,sp,32
    80002de8:	8082                	ret

0000000080002dea <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002dea:	1101                	addi	sp,sp,-32
    80002dec:	ec06                	sd	ra,24(sp)
    80002dee:	e822                	sd	s0,16(sp)
    80002df0:	e426                	sd	s1,8(sp)
    80002df2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002df4:	00015517          	auipc	a0,0x15
    80002df8:	90c50513          	addi	a0,a0,-1780 # 80017700 <tickslock>
    80002dfc:	ffffe097          	auipc	ra,0xffffe
    80002e00:	cd6080e7          	jalr	-810(ra) # 80000ad2 <acquire>
  xticks = ticks;
    80002e04:	00023497          	auipc	s1,0x23
    80002e08:	2144a483          	lw	s1,532(s1) # 80026018 <ticks>
  release(&tickslock);
    80002e0c:	00015517          	auipc	a0,0x15
    80002e10:	8f450513          	addi	a0,a0,-1804 # 80017700 <tickslock>
    80002e14:	ffffe097          	auipc	ra,0xffffe
    80002e18:	d12080e7          	jalr	-750(ra) # 80000b26 <release>
  return xticks;
}
    80002e1c:	02049513          	slli	a0,s1,0x20
    80002e20:	9101                	srli	a0,a0,0x20
    80002e22:	60e2                	ld	ra,24(sp)
    80002e24:	6442                	ld	s0,16(sp)
    80002e26:	64a2                	ld	s1,8(sp)
    80002e28:	6105                	addi	sp,sp,32
    80002e2a:	8082                	ret

0000000080002e2c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e2c:	7179                	addi	sp,sp,-48
    80002e2e:	f406                	sd	ra,40(sp)
    80002e30:	f022                	sd	s0,32(sp)
    80002e32:	ec26                	sd	s1,24(sp)
    80002e34:	e84a                	sd	s2,16(sp)
    80002e36:	e44e                	sd	s3,8(sp)
    80002e38:	e052                	sd	s4,0(sp)
    80002e3a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002e3c:	00004597          	auipc	a1,0x4
    80002e40:	78458593          	addi	a1,a1,1924 # 800075c0 <userret+0x530>
    80002e44:	00015517          	auipc	a0,0x15
    80002e48:	8d450513          	addi	a0,a0,-1836 # 80017718 <bcache>
    80002e4c:	ffffe097          	auipc	ra,0xffffe
    80002e50:	b74080e7          	jalr	-1164(ra) # 800009c0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002e54:	0001d797          	auipc	a5,0x1d
    80002e58:	8c478793          	addi	a5,a5,-1852 # 8001f718 <bcache+0x8000>
    80002e5c:	0001d717          	auipc	a4,0x1d
    80002e60:	c1470713          	addi	a4,a4,-1004 # 8001fa70 <bcache+0x8358>
    80002e64:	3ae7b023          	sd	a4,928(a5)
  bcache.head.next = &bcache.head;
    80002e68:	3ae7b423          	sd	a4,936(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e6c:	00015497          	auipc	s1,0x15
    80002e70:	8c448493          	addi	s1,s1,-1852 # 80017730 <bcache+0x18>
    b->next = bcache.head.next;
    80002e74:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002e76:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002e78:	00004a17          	auipc	s4,0x4
    80002e7c:	750a0a13          	addi	s4,s4,1872 # 800075c8 <userret+0x538>
    b->next = bcache.head.next;
    80002e80:	3a893783          	ld	a5,936(s2)
    80002e84:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002e86:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002e8a:	85d2                	mv	a1,s4
    80002e8c:	01048513          	addi	a0,s1,16
    80002e90:	00001097          	auipc	ra,0x1
    80002e94:	486080e7          	jalr	1158(ra) # 80004316 <initsleeplock>
    bcache.head.next->prev = b;
    80002e98:	3a893783          	ld	a5,936(s2)
    80002e9c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002e9e:	3a993423          	sd	s1,936(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ea2:	46048493          	addi	s1,s1,1120
    80002ea6:	fd349de3          	bne	s1,s3,80002e80 <binit+0x54>
  }
}
    80002eaa:	70a2                	ld	ra,40(sp)
    80002eac:	7402                	ld	s0,32(sp)
    80002eae:	64e2                	ld	s1,24(sp)
    80002eb0:	6942                	ld	s2,16(sp)
    80002eb2:	69a2                	ld	s3,8(sp)
    80002eb4:	6a02                	ld	s4,0(sp)
    80002eb6:	6145                	addi	sp,sp,48
    80002eb8:	8082                	ret

0000000080002eba <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002eba:	7179                	addi	sp,sp,-48
    80002ebc:	f406                	sd	ra,40(sp)
    80002ebe:	f022                	sd	s0,32(sp)
    80002ec0:	ec26                	sd	s1,24(sp)
    80002ec2:	e84a                	sd	s2,16(sp)
    80002ec4:	e44e                	sd	s3,8(sp)
    80002ec6:	1800                	addi	s0,sp,48
    80002ec8:	89aa                	mv	s3,a0
    80002eca:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002ecc:	00015517          	auipc	a0,0x15
    80002ed0:	84c50513          	addi	a0,a0,-1972 # 80017718 <bcache>
    80002ed4:	ffffe097          	auipc	ra,0xffffe
    80002ed8:	bfe080e7          	jalr	-1026(ra) # 80000ad2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002edc:	0001d497          	auipc	s1,0x1d
    80002ee0:	be44b483          	ld	s1,-1052(s1) # 8001fac0 <bcache+0x83a8>
    80002ee4:	0001d797          	auipc	a5,0x1d
    80002ee8:	b8c78793          	addi	a5,a5,-1140 # 8001fa70 <bcache+0x8358>
    80002eec:	02f48f63          	beq	s1,a5,80002f2a <bread+0x70>
    80002ef0:	873e                	mv	a4,a5
    80002ef2:	a021                	j	80002efa <bread+0x40>
    80002ef4:	68a4                	ld	s1,80(s1)
    80002ef6:	02e48a63          	beq	s1,a4,80002f2a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002efa:	449c                	lw	a5,8(s1)
    80002efc:	ff379ce3          	bne	a5,s3,80002ef4 <bread+0x3a>
    80002f00:	44dc                	lw	a5,12(s1)
    80002f02:	ff2799e3          	bne	a5,s2,80002ef4 <bread+0x3a>
      b->refcnt++;
    80002f06:	40bc                	lw	a5,64(s1)
    80002f08:	2785                	addiw	a5,a5,1
    80002f0a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f0c:	00015517          	auipc	a0,0x15
    80002f10:	80c50513          	addi	a0,a0,-2036 # 80017718 <bcache>
    80002f14:	ffffe097          	auipc	ra,0xffffe
    80002f18:	c12080e7          	jalr	-1006(ra) # 80000b26 <release>
      acquiresleep(&b->lock);
    80002f1c:	01048513          	addi	a0,s1,16
    80002f20:	00001097          	auipc	ra,0x1
    80002f24:	430080e7          	jalr	1072(ra) # 80004350 <acquiresleep>
      return b;
    80002f28:	a8b9                	j	80002f86 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f2a:	0001d497          	auipc	s1,0x1d
    80002f2e:	b8e4b483          	ld	s1,-1138(s1) # 8001fab8 <bcache+0x83a0>
    80002f32:	0001d797          	auipc	a5,0x1d
    80002f36:	b3e78793          	addi	a5,a5,-1218 # 8001fa70 <bcache+0x8358>
    80002f3a:	00f48863          	beq	s1,a5,80002f4a <bread+0x90>
    80002f3e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002f40:	40bc                	lw	a5,64(s1)
    80002f42:	cf81                	beqz	a5,80002f5a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f44:	64a4                	ld	s1,72(s1)
    80002f46:	fee49de3          	bne	s1,a4,80002f40 <bread+0x86>
  panic("bget: no buffers");
    80002f4a:	00004517          	auipc	a0,0x4
    80002f4e:	68650513          	addi	a0,a0,1670 # 800075d0 <userret+0x540>
    80002f52:	ffffd097          	auipc	ra,0xffffd
    80002f56:	5fc080e7          	jalr	1532(ra) # 8000054e <panic>
      b->dev = dev;
    80002f5a:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002f5e:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002f62:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002f66:	4785                	li	a5,1
    80002f68:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f6a:	00014517          	auipc	a0,0x14
    80002f6e:	7ae50513          	addi	a0,a0,1966 # 80017718 <bcache>
    80002f72:	ffffe097          	auipc	ra,0xffffe
    80002f76:	bb4080e7          	jalr	-1100(ra) # 80000b26 <release>
      acquiresleep(&b->lock);
    80002f7a:	01048513          	addi	a0,s1,16
    80002f7e:	00001097          	auipc	ra,0x1
    80002f82:	3d2080e7          	jalr	978(ra) # 80004350 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002f86:	409c                	lw	a5,0(s1)
    80002f88:	cb89                	beqz	a5,80002f9a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002f8a:	8526                	mv	a0,s1
    80002f8c:	70a2                	ld	ra,40(sp)
    80002f8e:	7402                	ld	s0,32(sp)
    80002f90:	64e2                	ld	s1,24(sp)
    80002f92:	6942                	ld	s2,16(sp)
    80002f94:	69a2                	ld	s3,8(sp)
    80002f96:	6145                	addi	sp,sp,48
    80002f98:	8082                	ret
    virtio_disk_rw(b, 0);
    80002f9a:	4581                	li	a1,0
    80002f9c:	8526                	mv	a0,s1
    80002f9e:	00003097          	auipc	ra,0x3
    80002fa2:	f10080e7          	jalr	-240(ra) # 80005eae <virtio_disk_rw>
    b->valid = 1;
    80002fa6:	4785                	li	a5,1
    80002fa8:	c09c                	sw	a5,0(s1)
  return b;
    80002faa:	b7c5                	j	80002f8a <bread+0xd0>

0000000080002fac <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002fac:	1101                	addi	sp,sp,-32
    80002fae:	ec06                	sd	ra,24(sp)
    80002fb0:	e822                	sd	s0,16(sp)
    80002fb2:	e426                	sd	s1,8(sp)
    80002fb4:	1000                	addi	s0,sp,32
    80002fb6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002fb8:	0541                	addi	a0,a0,16
    80002fba:	00001097          	auipc	ra,0x1
    80002fbe:	430080e7          	jalr	1072(ra) # 800043ea <holdingsleep>
    80002fc2:	cd01                	beqz	a0,80002fda <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002fc4:	4585                	li	a1,1
    80002fc6:	8526                	mv	a0,s1
    80002fc8:	00003097          	auipc	ra,0x3
    80002fcc:	ee6080e7          	jalr	-282(ra) # 80005eae <virtio_disk_rw>
}
    80002fd0:	60e2                	ld	ra,24(sp)
    80002fd2:	6442                	ld	s0,16(sp)
    80002fd4:	64a2                	ld	s1,8(sp)
    80002fd6:	6105                	addi	sp,sp,32
    80002fd8:	8082                	ret
    panic("bwrite");
    80002fda:	00004517          	auipc	a0,0x4
    80002fde:	60e50513          	addi	a0,a0,1550 # 800075e8 <userret+0x558>
    80002fe2:	ffffd097          	auipc	ra,0xffffd
    80002fe6:	56c080e7          	jalr	1388(ra) # 8000054e <panic>

0000000080002fea <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
    80002fea:	1101                	addi	sp,sp,-32
    80002fec:	ec06                	sd	ra,24(sp)
    80002fee:	e822                	sd	s0,16(sp)
    80002ff0:	e426                	sd	s1,8(sp)
    80002ff2:	e04a                	sd	s2,0(sp)
    80002ff4:	1000                	addi	s0,sp,32
    80002ff6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ff8:	01050913          	addi	s2,a0,16
    80002ffc:	854a                	mv	a0,s2
    80002ffe:	00001097          	auipc	ra,0x1
    80003002:	3ec080e7          	jalr	1004(ra) # 800043ea <holdingsleep>
    80003006:	c92d                	beqz	a0,80003078 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003008:	854a                	mv	a0,s2
    8000300a:	00001097          	auipc	ra,0x1
    8000300e:	39c080e7          	jalr	924(ra) # 800043a6 <releasesleep>

  acquire(&bcache.lock);
    80003012:	00014517          	auipc	a0,0x14
    80003016:	70650513          	addi	a0,a0,1798 # 80017718 <bcache>
    8000301a:	ffffe097          	auipc	ra,0xffffe
    8000301e:	ab8080e7          	jalr	-1352(ra) # 80000ad2 <acquire>
  b->refcnt--;
    80003022:	40bc                	lw	a5,64(s1)
    80003024:	37fd                	addiw	a5,a5,-1
    80003026:	0007871b          	sext.w	a4,a5
    8000302a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000302c:	eb05                	bnez	a4,8000305c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000302e:	68bc                	ld	a5,80(s1)
    80003030:	64b8                	ld	a4,72(s1)
    80003032:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003034:	64bc                	ld	a5,72(s1)
    80003036:	68b8                	ld	a4,80(s1)
    80003038:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000303a:	0001c797          	auipc	a5,0x1c
    8000303e:	6de78793          	addi	a5,a5,1758 # 8001f718 <bcache+0x8000>
    80003042:	3a87b703          	ld	a4,936(a5)
    80003046:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003048:	0001d717          	auipc	a4,0x1d
    8000304c:	a2870713          	addi	a4,a4,-1496 # 8001fa70 <bcache+0x8358>
    80003050:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003052:	3a87b703          	ld	a4,936(a5)
    80003056:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003058:	3a97b423          	sd	s1,936(a5)
  }
  
  release(&bcache.lock);
    8000305c:	00014517          	auipc	a0,0x14
    80003060:	6bc50513          	addi	a0,a0,1724 # 80017718 <bcache>
    80003064:	ffffe097          	auipc	ra,0xffffe
    80003068:	ac2080e7          	jalr	-1342(ra) # 80000b26 <release>
}
    8000306c:	60e2                	ld	ra,24(sp)
    8000306e:	6442                	ld	s0,16(sp)
    80003070:	64a2                	ld	s1,8(sp)
    80003072:	6902                	ld	s2,0(sp)
    80003074:	6105                	addi	sp,sp,32
    80003076:	8082                	ret
    panic("brelse");
    80003078:	00004517          	auipc	a0,0x4
    8000307c:	57850513          	addi	a0,a0,1400 # 800075f0 <userret+0x560>
    80003080:	ffffd097          	auipc	ra,0xffffd
    80003084:	4ce080e7          	jalr	1230(ra) # 8000054e <panic>

0000000080003088 <bpin>:

void
bpin(struct buf *b) {
    80003088:	1101                	addi	sp,sp,-32
    8000308a:	ec06                	sd	ra,24(sp)
    8000308c:	e822                	sd	s0,16(sp)
    8000308e:	e426                	sd	s1,8(sp)
    80003090:	1000                	addi	s0,sp,32
    80003092:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003094:	00014517          	auipc	a0,0x14
    80003098:	68450513          	addi	a0,a0,1668 # 80017718 <bcache>
    8000309c:	ffffe097          	auipc	ra,0xffffe
    800030a0:	a36080e7          	jalr	-1482(ra) # 80000ad2 <acquire>
  b->refcnt++;
    800030a4:	40bc                	lw	a5,64(s1)
    800030a6:	2785                	addiw	a5,a5,1
    800030a8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030aa:	00014517          	auipc	a0,0x14
    800030ae:	66e50513          	addi	a0,a0,1646 # 80017718 <bcache>
    800030b2:	ffffe097          	auipc	ra,0xffffe
    800030b6:	a74080e7          	jalr	-1420(ra) # 80000b26 <release>
}
    800030ba:	60e2                	ld	ra,24(sp)
    800030bc:	6442                	ld	s0,16(sp)
    800030be:	64a2                	ld	s1,8(sp)
    800030c0:	6105                	addi	sp,sp,32
    800030c2:	8082                	ret

00000000800030c4 <bunpin>:

void
bunpin(struct buf *b) {
    800030c4:	1101                	addi	sp,sp,-32
    800030c6:	ec06                	sd	ra,24(sp)
    800030c8:	e822                	sd	s0,16(sp)
    800030ca:	e426                	sd	s1,8(sp)
    800030cc:	1000                	addi	s0,sp,32
    800030ce:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030d0:	00014517          	auipc	a0,0x14
    800030d4:	64850513          	addi	a0,a0,1608 # 80017718 <bcache>
    800030d8:	ffffe097          	auipc	ra,0xffffe
    800030dc:	9fa080e7          	jalr	-1542(ra) # 80000ad2 <acquire>
  b->refcnt--;
    800030e0:	40bc                	lw	a5,64(s1)
    800030e2:	37fd                	addiw	a5,a5,-1
    800030e4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030e6:	00014517          	auipc	a0,0x14
    800030ea:	63250513          	addi	a0,a0,1586 # 80017718 <bcache>
    800030ee:	ffffe097          	auipc	ra,0xffffe
    800030f2:	a38080e7          	jalr	-1480(ra) # 80000b26 <release>
}
    800030f6:	60e2                	ld	ra,24(sp)
    800030f8:	6442                	ld	s0,16(sp)
    800030fa:	64a2                	ld	s1,8(sp)
    800030fc:	6105                	addi	sp,sp,32
    800030fe:	8082                	ret

0000000080003100 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003100:	1101                	addi	sp,sp,-32
    80003102:	ec06                	sd	ra,24(sp)
    80003104:	e822                	sd	s0,16(sp)
    80003106:	e426                	sd	s1,8(sp)
    80003108:	e04a                	sd	s2,0(sp)
    8000310a:	1000                	addi	s0,sp,32
    8000310c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000310e:	00d5d59b          	srliw	a1,a1,0xd
    80003112:	0001d797          	auipc	a5,0x1d
    80003116:	dda7a783          	lw	a5,-550(a5) # 8001feec <sb+0x1c>
    8000311a:	9dbd                	addw	a1,a1,a5
    8000311c:	00000097          	auipc	ra,0x0
    80003120:	d9e080e7          	jalr	-610(ra) # 80002eba <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003124:	0074f713          	andi	a4,s1,7
    80003128:	4785                	li	a5,1
    8000312a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000312e:	14ce                	slli	s1,s1,0x33
    80003130:	90d9                	srli	s1,s1,0x36
    80003132:	00950733          	add	a4,a0,s1
    80003136:	06074703          	lbu	a4,96(a4)
    8000313a:	00e7f6b3          	and	a3,a5,a4
    8000313e:	c69d                	beqz	a3,8000316c <bfree+0x6c>
    80003140:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003142:	94aa                	add	s1,s1,a0
    80003144:	fff7c793          	not	a5,a5
    80003148:	8ff9                	and	a5,a5,a4
    8000314a:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    8000314e:	00001097          	auipc	ra,0x1
    80003152:	0da080e7          	jalr	218(ra) # 80004228 <log_write>
  brelse(bp);
    80003156:	854a                	mv	a0,s2
    80003158:	00000097          	auipc	ra,0x0
    8000315c:	e92080e7          	jalr	-366(ra) # 80002fea <brelse>
}
    80003160:	60e2                	ld	ra,24(sp)
    80003162:	6442                	ld	s0,16(sp)
    80003164:	64a2                	ld	s1,8(sp)
    80003166:	6902                	ld	s2,0(sp)
    80003168:	6105                	addi	sp,sp,32
    8000316a:	8082                	ret
    panic("freeing free block");
    8000316c:	00004517          	auipc	a0,0x4
    80003170:	48c50513          	addi	a0,a0,1164 # 800075f8 <userret+0x568>
    80003174:	ffffd097          	auipc	ra,0xffffd
    80003178:	3da080e7          	jalr	986(ra) # 8000054e <panic>

000000008000317c <balloc>:
{
    8000317c:	711d                	addi	sp,sp,-96
    8000317e:	ec86                	sd	ra,88(sp)
    80003180:	e8a2                	sd	s0,80(sp)
    80003182:	e4a6                	sd	s1,72(sp)
    80003184:	e0ca                	sd	s2,64(sp)
    80003186:	fc4e                	sd	s3,56(sp)
    80003188:	f852                	sd	s4,48(sp)
    8000318a:	f456                	sd	s5,40(sp)
    8000318c:	f05a                	sd	s6,32(sp)
    8000318e:	ec5e                	sd	s7,24(sp)
    80003190:	e862                	sd	s8,16(sp)
    80003192:	e466                	sd	s9,8(sp)
    80003194:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003196:	0001d797          	auipc	a5,0x1d
    8000319a:	d3e7a783          	lw	a5,-706(a5) # 8001fed4 <sb+0x4>
    8000319e:	cbd1                	beqz	a5,80003232 <balloc+0xb6>
    800031a0:	8baa                	mv	s7,a0
    800031a2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800031a4:	0001db17          	auipc	s6,0x1d
    800031a8:	d2cb0b13          	addi	s6,s6,-724 # 8001fed0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031ac:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800031ae:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031b0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800031b2:	6c89                	lui	s9,0x2
    800031b4:	a831                	j	800031d0 <balloc+0x54>
    brelse(bp);
    800031b6:	854a                	mv	a0,s2
    800031b8:	00000097          	auipc	ra,0x0
    800031bc:	e32080e7          	jalr	-462(ra) # 80002fea <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800031c0:	015c87bb          	addw	a5,s9,s5
    800031c4:	00078a9b          	sext.w	s5,a5
    800031c8:	004b2703          	lw	a4,4(s6)
    800031cc:	06eaf363          	bgeu	s5,a4,80003232 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800031d0:	41fad79b          	sraiw	a5,s5,0x1f
    800031d4:	0137d79b          	srliw	a5,a5,0x13
    800031d8:	015787bb          	addw	a5,a5,s5
    800031dc:	40d7d79b          	sraiw	a5,a5,0xd
    800031e0:	01cb2583          	lw	a1,28(s6)
    800031e4:	9dbd                	addw	a1,a1,a5
    800031e6:	855e                	mv	a0,s7
    800031e8:	00000097          	auipc	ra,0x0
    800031ec:	cd2080e7          	jalr	-814(ra) # 80002eba <bread>
    800031f0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031f2:	004b2503          	lw	a0,4(s6)
    800031f6:	000a849b          	sext.w	s1,s5
    800031fa:	8662                	mv	a2,s8
    800031fc:	faa4fde3          	bgeu	s1,a0,800031b6 <balloc+0x3a>
      m = 1 << (bi % 8);
    80003200:	41f6579b          	sraiw	a5,a2,0x1f
    80003204:	01d7d69b          	srliw	a3,a5,0x1d
    80003208:	00c6873b          	addw	a4,a3,a2
    8000320c:	00777793          	andi	a5,a4,7
    80003210:	9f95                	subw	a5,a5,a3
    80003212:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003216:	4037571b          	sraiw	a4,a4,0x3
    8000321a:	00e906b3          	add	a3,s2,a4
    8000321e:	0606c683          	lbu	a3,96(a3)
    80003222:	00d7f5b3          	and	a1,a5,a3
    80003226:	cd91                	beqz	a1,80003242 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003228:	2605                	addiw	a2,a2,1
    8000322a:	2485                	addiw	s1,s1,1
    8000322c:	fd4618e3          	bne	a2,s4,800031fc <balloc+0x80>
    80003230:	b759                	j	800031b6 <balloc+0x3a>
  panic("balloc: out of blocks");
    80003232:	00004517          	auipc	a0,0x4
    80003236:	3de50513          	addi	a0,a0,990 # 80007610 <userret+0x580>
    8000323a:	ffffd097          	auipc	ra,0xffffd
    8000323e:	314080e7          	jalr	788(ra) # 8000054e <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003242:	974a                	add	a4,a4,s2
    80003244:	8fd5                	or	a5,a5,a3
    80003246:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    8000324a:	854a                	mv	a0,s2
    8000324c:	00001097          	auipc	ra,0x1
    80003250:	fdc080e7          	jalr	-36(ra) # 80004228 <log_write>
        brelse(bp);
    80003254:	854a                	mv	a0,s2
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	d94080e7          	jalr	-620(ra) # 80002fea <brelse>
  bp = bread(dev, bno);
    8000325e:	85a6                	mv	a1,s1
    80003260:	855e                	mv	a0,s7
    80003262:	00000097          	auipc	ra,0x0
    80003266:	c58080e7          	jalr	-936(ra) # 80002eba <bread>
    8000326a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000326c:	40000613          	li	a2,1024
    80003270:	4581                	li	a1,0
    80003272:	06050513          	addi	a0,a0,96
    80003276:	ffffe097          	auipc	ra,0xffffe
    8000327a:	8f8080e7          	jalr	-1800(ra) # 80000b6e <memset>
  log_write(bp);
    8000327e:	854a                	mv	a0,s2
    80003280:	00001097          	auipc	ra,0x1
    80003284:	fa8080e7          	jalr	-88(ra) # 80004228 <log_write>
  brelse(bp);
    80003288:	854a                	mv	a0,s2
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	d60080e7          	jalr	-672(ra) # 80002fea <brelse>
}
    80003292:	8526                	mv	a0,s1
    80003294:	60e6                	ld	ra,88(sp)
    80003296:	6446                	ld	s0,80(sp)
    80003298:	64a6                	ld	s1,72(sp)
    8000329a:	6906                	ld	s2,64(sp)
    8000329c:	79e2                	ld	s3,56(sp)
    8000329e:	7a42                	ld	s4,48(sp)
    800032a0:	7aa2                	ld	s5,40(sp)
    800032a2:	7b02                	ld	s6,32(sp)
    800032a4:	6be2                	ld	s7,24(sp)
    800032a6:	6c42                	ld	s8,16(sp)
    800032a8:	6ca2                	ld	s9,8(sp)
    800032aa:	6125                	addi	sp,sp,96
    800032ac:	8082                	ret

00000000800032ae <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800032ae:	7179                	addi	sp,sp,-48
    800032b0:	f406                	sd	ra,40(sp)
    800032b2:	f022                	sd	s0,32(sp)
    800032b4:	ec26                	sd	s1,24(sp)
    800032b6:	e84a                	sd	s2,16(sp)
    800032b8:	e44e                	sd	s3,8(sp)
    800032ba:	e052                	sd	s4,0(sp)
    800032bc:	1800                	addi	s0,sp,48
    800032be:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800032c0:	47ad                	li	a5,11
    800032c2:	04b7fe63          	bgeu	a5,a1,8000331e <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800032c6:	ff45849b          	addiw	s1,a1,-12
    800032ca:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800032ce:	0ff00793          	li	a5,255
    800032d2:	0ae7e363          	bltu	a5,a4,80003378 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800032d6:	08052583          	lw	a1,128(a0)
    800032da:	c5ad                	beqz	a1,80003344 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800032dc:	00092503          	lw	a0,0(s2)
    800032e0:	00000097          	auipc	ra,0x0
    800032e4:	bda080e7          	jalr	-1062(ra) # 80002eba <bread>
    800032e8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800032ea:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    800032ee:	02049593          	slli	a1,s1,0x20
    800032f2:	9181                	srli	a1,a1,0x20
    800032f4:	058a                	slli	a1,a1,0x2
    800032f6:	00b784b3          	add	s1,a5,a1
    800032fa:	0004a983          	lw	s3,0(s1)
    800032fe:	04098d63          	beqz	s3,80003358 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003302:	8552                	mv	a0,s4
    80003304:	00000097          	auipc	ra,0x0
    80003308:	ce6080e7          	jalr	-794(ra) # 80002fea <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000330c:	854e                	mv	a0,s3
    8000330e:	70a2                	ld	ra,40(sp)
    80003310:	7402                	ld	s0,32(sp)
    80003312:	64e2                	ld	s1,24(sp)
    80003314:	6942                	ld	s2,16(sp)
    80003316:	69a2                	ld	s3,8(sp)
    80003318:	6a02                	ld	s4,0(sp)
    8000331a:	6145                	addi	sp,sp,48
    8000331c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000331e:	02059493          	slli	s1,a1,0x20
    80003322:	9081                	srli	s1,s1,0x20
    80003324:	048a                	slli	s1,s1,0x2
    80003326:	94aa                	add	s1,s1,a0
    80003328:	0504a983          	lw	s3,80(s1)
    8000332c:	fe0990e3          	bnez	s3,8000330c <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003330:	4108                	lw	a0,0(a0)
    80003332:	00000097          	auipc	ra,0x0
    80003336:	e4a080e7          	jalr	-438(ra) # 8000317c <balloc>
    8000333a:	0005099b          	sext.w	s3,a0
    8000333e:	0534a823          	sw	s3,80(s1)
    80003342:	b7e9                	j	8000330c <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003344:	4108                	lw	a0,0(a0)
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	e36080e7          	jalr	-458(ra) # 8000317c <balloc>
    8000334e:	0005059b          	sext.w	a1,a0
    80003352:	08b92023          	sw	a1,128(s2)
    80003356:	b759                	j	800032dc <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003358:	00092503          	lw	a0,0(s2)
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	e20080e7          	jalr	-480(ra) # 8000317c <balloc>
    80003364:	0005099b          	sext.w	s3,a0
    80003368:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000336c:	8552                	mv	a0,s4
    8000336e:	00001097          	auipc	ra,0x1
    80003372:	eba080e7          	jalr	-326(ra) # 80004228 <log_write>
    80003376:	b771                	j	80003302 <bmap+0x54>
  panic("bmap: out of range");
    80003378:	00004517          	auipc	a0,0x4
    8000337c:	2b050513          	addi	a0,a0,688 # 80007628 <userret+0x598>
    80003380:	ffffd097          	auipc	ra,0xffffd
    80003384:	1ce080e7          	jalr	462(ra) # 8000054e <panic>

0000000080003388 <iget>:
{
    80003388:	7179                	addi	sp,sp,-48
    8000338a:	f406                	sd	ra,40(sp)
    8000338c:	f022                	sd	s0,32(sp)
    8000338e:	ec26                	sd	s1,24(sp)
    80003390:	e84a                	sd	s2,16(sp)
    80003392:	e44e                	sd	s3,8(sp)
    80003394:	e052                	sd	s4,0(sp)
    80003396:	1800                	addi	s0,sp,48
    80003398:	89aa                	mv	s3,a0
    8000339a:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    8000339c:	0001d517          	auipc	a0,0x1d
    800033a0:	b5450513          	addi	a0,a0,-1196 # 8001fef0 <icache>
    800033a4:	ffffd097          	auipc	ra,0xffffd
    800033a8:	72e080e7          	jalr	1838(ra) # 80000ad2 <acquire>
  empty = 0;
    800033ac:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800033ae:	0001d497          	auipc	s1,0x1d
    800033b2:	b5a48493          	addi	s1,s1,-1190 # 8001ff08 <icache+0x18>
    800033b6:	0001e697          	auipc	a3,0x1e
    800033ba:	5e268693          	addi	a3,a3,1506 # 80021998 <log>
    800033be:	a039                	j	800033cc <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800033c0:	02090b63          	beqz	s2,800033f6 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800033c4:	08848493          	addi	s1,s1,136
    800033c8:	02d48a63          	beq	s1,a3,800033fc <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800033cc:	449c                	lw	a5,8(s1)
    800033ce:	fef059e3          	blez	a5,800033c0 <iget+0x38>
    800033d2:	4098                	lw	a4,0(s1)
    800033d4:	ff3716e3          	bne	a4,s3,800033c0 <iget+0x38>
    800033d8:	40d8                	lw	a4,4(s1)
    800033da:	ff4713e3          	bne	a4,s4,800033c0 <iget+0x38>
      ip->ref++;
    800033de:	2785                	addiw	a5,a5,1
    800033e0:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    800033e2:	0001d517          	auipc	a0,0x1d
    800033e6:	b0e50513          	addi	a0,a0,-1266 # 8001fef0 <icache>
    800033ea:	ffffd097          	auipc	ra,0xffffd
    800033ee:	73c080e7          	jalr	1852(ra) # 80000b26 <release>
      return ip;
    800033f2:	8926                	mv	s2,s1
    800033f4:	a03d                	j	80003422 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800033f6:	f7f9                	bnez	a5,800033c4 <iget+0x3c>
    800033f8:	8926                	mv	s2,s1
    800033fa:	b7e9                	j	800033c4 <iget+0x3c>
  if(empty == 0)
    800033fc:	02090c63          	beqz	s2,80003434 <iget+0xac>
  ip->dev = dev;
    80003400:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003404:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003408:	4785                	li	a5,1
    8000340a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000340e:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003412:	0001d517          	auipc	a0,0x1d
    80003416:	ade50513          	addi	a0,a0,-1314 # 8001fef0 <icache>
    8000341a:	ffffd097          	auipc	ra,0xffffd
    8000341e:	70c080e7          	jalr	1804(ra) # 80000b26 <release>
}
    80003422:	854a                	mv	a0,s2
    80003424:	70a2                	ld	ra,40(sp)
    80003426:	7402                	ld	s0,32(sp)
    80003428:	64e2                	ld	s1,24(sp)
    8000342a:	6942                	ld	s2,16(sp)
    8000342c:	69a2                	ld	s3,8(sp)
    8000342e:	6a02                	ld	s4,0(sp)
    80003430:	6145                	addi	sp,sp,48
    80003432:	8082                	ret
    panic("iget: no inodes");
    80003434:	00004517          	auipc	a0,0x4
    80003438:	20c50513          	addi	a0,a0,524 # 80007640 <userret+0x5b0>
    8000343c:	ffffd097          	auipc	ra,0xffffd
    80003440:	112080e7          	jalr	274(ra) # 8000054e <panic>

0000000080003444 <fsinit>:
fsinit(int dev) {
    80003444:	7179                	addi	sp,sp,-48
    80003446:	f406                	sd	ra,40(sp)
    80003448:	f022                	sd	s0,32(sp)
    8000344a:	ec26                	sd	s1,24(sp)
    8000344c:	e84a                	sd	s2,16(sp)
    8000344e:	e44e                	sd	s3,8(sp)
    80003450:	1800                	addi	s0,sp,48
    80003452:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003454:	4585                	li	a1,1
    80003456:	00000097          	auipc	ra,0x0
    8000345a:	a64080e7          	jalr	-1436(ra) # 80002eba <bread>
    8000345e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003460:	0001d997          	auipc	s3,0x1d
    80003464:	a7098993          	addi	s3,s3,-1424 # 8001fed0 <sb>
    80003468:	02000613          	li	a2,32
    8000346c:	06050593          	addi	a1,a0,96
    80003470:	854e                	mv	a0,s3
    80003472:	ffffd097          	auipc	ra,0xffffd
    80003476:	75c080e7          	jalr	1884(ra) # 80000bce <memmove>
  brelse(bp);
    8000347a:	8526                	mv	a0,s1
    8000347c:	00000097          	auipc	ra,0x0
    80003480:	b6e080e7          	jalr	-1170(ra) # 80002fea <brelse>
  if(sb.magic != FSMAGIC)
    80003484:	0009a703          	lw	a4,0(s3)
    80003488:	102037b7          	lui	a5,0x10203
    8000348c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003490:	02f71263          	bne	a4,a5,800034b4 <fsinit+0x70>
  initlog(dev, &sb);
    80003494:	0001d597          	auipc	a1,0x1d
    80003498:	a3c58593          	addi	a1,a1,-1476 # 8001fed0 <sb>
    8000349c:	854a                	mv	a0,s2
    8000349e:	00001097          	auipc	ra,0x1
    800034a2:	b12080e7          	jalr	-1262(ra) # 80003fb0 <initlog>
}
    800034a6:	70a2                	ld	ra,40(sp)
    800034a8:	7402                	ld	s0,32(sp)
    800034aa:	64e2                	ld	s1,24(sp)
    800034ac:	6942                	ld	s2,16(sp)
    800034ae:	69a2                	ld	s3,8(sp)
    800034b0:	6145                	addi	sp,sp,48
    800034b2:	8082                	ret
    panic("invalid file system");
    800034b4:	00004517          	auipc	a0,0x4
    800034b8:	19c50513          	addi	a0,a0,412 # 80007650 <userret+0x5c0>
    800034bc:	ffffd097          	auipc	ra,0xffffd
    800034c0:	092080e7          	jalr	146(ra) # 8000054e <panic>

00000000800034c4 <iinit>:
{
    800034c4:	7179                	addi	sp,sp,-48
    800034c6:	f406                	sd	ra,40(sp)
    800034c8:	f022                	sd	s0,32(sp)
    800034ca:	ec26                	sd	s1,24(sp)
    800034cc:	e84a                	sd	s2,16(sp)
    800034ce:	e44e                	sd	s3,8(sp)
    800034d0:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    800034d2:	00004597          	auipc	a1,0x4
    800034d6:	19658593          	addi	a1,a1,406 # 80007668 <userret+0x5d8>
    800034da:	0001d517          	auipc	a0,0x1d
    800034de:	a1650513          	addi	a0,a0,-1514 # 8001fef0 <icache>
    800034e2:	ffffd097          	auipc	ra,0xffffd
    800034e6:	4de080e7          	jalr	1246(ra) # 800009c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    800034ea:	0001d497          	auipc	s1,0x1d
    800034ee:	a2e48493          	addi	s1,s1,-1490 # 8001ff18 <icache+0x28>
    800034f2:	0001e997          	auipc	s3,0x1e
    800034f6:	4b698993          	addi	s3,s3,1206 # 800219a8 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    800034fa:	00004917          	auipc	s2,0x4
    800034fe:	17690913          	addi	s2,s2,374 # 80007670 <userret+0x5e0>
    80003502:	85ca                	mv	a1,s2
    80003504:	8526                	mv	a0,s1
    80003506:	00001097          	auipc	ra,0x1
    8000350a:	e10080e7          	jalr	-496(ra) # 80004316 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000350e:	08848493          	addi	s1,s1,136
    80003512:	ff3498e3          	bne	s1,s3,80003502 <iinit+0x3e>
}
    80003516:	70a2                	ld	ra,40(sp)
    80003518:	7402                	ld	s0,32(sp)
    8000351a:	64e2                	ld	s1,24(sp)
    8000351c:	6942                	ld	s2,16(sp)
    8000351e:	69a2                	ld	s3,8(sp)
    80003520:	6145                	addi	sp,sp,48
    80003522:	8082                	ret

0000000080003524 <ialloc>:
{
    80003524:	715d                	addi	sp,sp,-80
    80003526:	e486                	sd	ra,72(sp)
    80003528:	e0a2                	sd	s0,64(sp)
    8000352a:	fc26                	sd	s1,56(sp)
    8000352c:	f84a                	sd	s2,48(sp)
    8000352e:	f44e                	sd	s3,40(sp)
    80003530:	f052                	sd	s4,32(sp)
    80003532:	ec56                	sd	s5,24(sp)
    80003534:	e85a                	sd	s6,16(sp)
    80003536:	e45e                	sd	s7,8(sp)
    80003538:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000353a:	0001d717          	auipc	a4,0x1d
    8000353e:	9a272703          	lw	a4,-1630(a4) # 8001fedc <sb+0xc>
    80003542:	4785                	li	a5,1
    80003544:	04e7fa63          	bgeu	a5,a4,80003598 <ialloc+0x74>
    80003548:	8aaa                	mv	s5,a0
    8000354a:	8bae                	mv	s7,a1
    8000354c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000354e:	0001da17          	auipc	s4,0x1d
    80003552:	982a0a13          	addi	s4,s4,-1662 # 8001fed0 <sb>
    80003556:	00048b1b          	sext.w	s6,s1
    8000355a:	0044d593          	srli	a1,s1,0x4
    8000355e:	018a2783          	lw	a5,24(s4)
    80003562:	9dbd                	addw	a1,a1,a5
    80003564:	8556                	mv	a0,s5
    80003566:	00000097          	auipc	ra,0x0
    8000356a:	954080e7          	jalr	-1708(ra) # 80002eba <bread>
    8000356e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003570:	06050993          	addi	s3,a0,96
    80003574:	00f4f793          	andi	a5,s1,15
    80003578:	079a                	slli	a5,a5,0x6
    8000357a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000357c:	00099783          	lh	a5,0(s3)
    80003580:	c785                	beqz	a5,800035a8 <ialloc+0x84>
    brelse(bp);
    80003582:	00000097          	auipc	ra,0x0
    80003586:	a68080e7          	jalr	-1432(ra) # 80002fea <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000358a:	0485                	addi	s1,s1,1
    8000358c:	00ca2703          	lw	a4,12(s4)
    80003590:	0004879b          	sext.w	a5,s1
    80003594:	fce7e1e3          	bltu	a5,a4,80003556 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003598:	00004517          	auipc	a0,0x4
    8000359c:	0e050513          	addi	a0,a0,224 # 80007678 <userret+0x5e8>
    800035a0:	ffffd097          	auipc	ra,0xffffd
    800035a4:	fae080e7          	jalr	-82(ra) # 8000054e <panic>
      memset(dip, 0, sizeof(*dip));
    800035a8:	04000613          	li	a2,64
    800035ac:	4581                	li	a1,0
    800035ae:	854e                	mv	a0,s3
    800035b0:	ffffd097          	auipc	ra,0xffffd
    800035b4:	5be080e7          	jalr	1470(ra) # 80000b6e <memset>
      dip->type = type;
    800035b8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800035bc:	854a                	mv	a0,s2
    800035be:	00001097          	auipc	ra,0x1
    800035c2:	c6a080e7          	jalr	-918(ra) # 80004228 <log_write>
      brelse(bp);
    800035c6:	854a                	mv	a0,s2
    800035c8:	00000097          	auipc	ra,0x0
    800035cc:	a22080e7          	jalr	-1502(ra) # 80002fea <brelse>
      return iget(dev, inum);
    800035d0:	85da                	mv	a1,s6
    800035d2:	8556                	mv	a0,s5
    800035d4:	00000097          	auipc	ra,0x0
    800035d8:	db4080e7          	jalr	-588(ra) # 80003388 <iget>
}
    800035dc:	60a6                	ld	ra,72(sp)
    800035de:	6406                	ld	s0,64(sp)
    800035e0:	74e2                	ld	s1,56(sp)
    800035e2:	7942                	ld	s2,48(sp)
    800035e4:	79a2                	ld	s3,40(sp)
    800035e6:	7a02                	ld	s4,32(sp)
    800035e8:	6ae2                	ld	s5,24(sp)
    800035ea:	6b42                	ld	s6,16(sp)
    800035ec:	6ba2                	ld	s7,8(sp)
    800035ee:	6161                	addi	sp,sp,80
    800035f0:	8082                	ret

00000000800035f2 <iupdate>:
{
    800035f2:	1101                	addi	sp,sp,-32
    800035f4:	ec06                	sd	ra,24(sp)
    800035f6:	e822                	sd	s0,16(sp)
    800035f8:	e426                	sd	s1,8(sp)
    800035fa:	e04a                	sd	s2,0(sp)
    800035fc:	1000                	addi	s0,sp,32
    800035fe:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003600:	415c                	lw	a5,4(a0)
    80003602:	0047d79b          	srliw	a5,a5,0x4
    80003606:	0001d597          	auipc	a1,0x1d
    8000360a:	8e25a583          	lw	a1,-1822(a1) # 8001fee8 <sb+0x18>
    8000360e:	9dbd                	addw	a1,a1,a5
    80003610:	4108                	lw	a0,0(a0)
    80003612:	00000097          	auipc	ra,0x0
    80003616:	8a8080e7          	jalr	-1880(ra) # 80002eba <bread>
    8000361a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000361c:	06050793          	addi	a5,a0,96
    80003620:	40c8                	lw	a0,4(s1)
    80003622:	893d                	andi	a0,a0,15
    80003624:	051a                	slli	a0,a0,0x6
    80003626:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003628:	04449703          	lh	a4,68(s1)
    8000362c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003630:	04649703          	lh	a4,70(s1)
    80003634:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003638:	04849703          	lh	a4,72(s1)
    8000363c:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003640:	04a49703          	lh	a4,74(s1)
    80003644:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003648:	44f8                	lw	a4,76(s1)
    8000364a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000364c:	03400613          	li	a2,52
    80003650:	05048593          	addi	a1,s1,80
    80003654:	0531                	addi	a0,a0,12
    80003656:	ffffd097          	auipc	ra,0xffffd
    8000365a:	578080e7          	jalr	1400(ra) # 80000bce <memmove>
  log_write(bp);
    8000365e:	854a                	mv	a0,s2
    80003660:	00001097          	auipc	ra,0x1
    80003664:	bc8080e7          	jalr	-1080(ra) # 80004228 <log_write>
  brelse(bp);
    80003668:	854a                	mv	a0,s2
    8000366a:	00000097          	auipc	ra,0x0
    8000366e:	980080e7          	jalr	-1664(ra) # 80002fea <brelse>
}
    80003672:	60e2                	ld	ra,24(sp)
    80003674:	6442                	ld	s0,16(sp)
    80003676:	64a2                	ld	s1,8(sp)
    80003678:	6902                	ld	s2,0(sp)
    8000367a:	6105                	addi	sp,sp,32
    8000367c:	8082                	ret

000000008000367e <idup>:
{
    8000367e:	1101                	addi	sp,sp,-32
    80003680:	ec06                	sd	ra,24(sp)
    80003682:	e822                	sd	s0,16(sp)
    80003684:	e426                	sd	s1,8(sp)
    80003686:	1000                	addi	s0,sp,32
    80003688:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000368a:	0001d517          	auipc	a0,0x1d
    8000368e:	86650513          	addi	a0,a0,-1946 # 8001fef0 <icache>
    80003692:	ffffd097          	auipc	ra,0xffffd
    80003696:	440080e7          	jalr	1088(ra) # 80000ad2 <acquire>
  ip->ref++;
    8000369a:	449c                	lw	a5,8(s1)
    8000369c:	2785                	addiw	a5,a5,1
    8000369e:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800036a0:	0001d517          	auipc	a0,0x1d
    800036a4:	85050513          	addi	a0,a0,-1968 # 8001fef0 <icache>
    800036a8:	ffffd097          	auipc	ra,0xffffd
    800036ac:	47e080e7          	jalr	1150(ra) # 80000b26 <release>
}
    800036b0:	8526                	mv	a0,s1
    800036b2:	60e2                	ld	ra,24(sp)
    800036b4:	6442                	ld	s0,16(sp)
    800036b6:	64a2                	ld	s1,8(sp)
    800036b8:	6105                	addi	sp,sp,32
    800036ba:	8082                	ret

00000000800036bc <ilock>:
{
    800036bc:	1101                	addi	sp,sp,-32
    800036be:	ec06                	sd	ra,24(sp)
    800036c0:	e822                	sd	s0,16(sp)
    800036c2:	e426                	sd	s1,8(sp)
    800036c4:	e04a                	sd	s2,0(sp)
    800036c6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800036c8:	c115                	beqz	a0,800036ec <ilock+0x30>
    800036ca:	84aa                	mv	s1,a0
    800036cc:	451c                	lw	a5,8(a0)
    800036ce:	00f05f63          	blez	a5,800036ec <ilock+0x30>
  acquiresleep(&ip->lock);
    800036d2:	0541                	addi	a0,a0,16
    800036d4:	00001097          	auipc	ra,0x1
    800036d8:	c7c080e7          	jalr	-900(ra) # 80004350 <acquiresleep>
  if(ip->valid == 0){
    800036dc:	40bc                	lw	a5,64(s1)
    800036de:	cf99                	beqz	a5,800036fc <ilock+0x40>
}
    800036e0:	60e2                	ld	ra,24(sp)
    800036e2:	6442                	ld	s0,16(sp)
    800036e4:	64a2                	ld	s1,8(sp)
    800036e6:	6902                	ld	s2,0(sp)
    800036e8:	6105                	addi	sp,sp,32
    800036ea:	8082                	ret
    panic("ilock");
    800036ec:	00004517          	auipc	a0,0x4
    800036f0:	fa450513          	addi	a0,a0,-92 # 80007690 <userret+0x600>
    800036f4:	ffffd097          	auipc	ra,0xffffd
    800036f8:	e5a080e7          	jalr	-422(ra) # 8000054e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800036fc:	40dc                	lw	a5,4(s1)
    800036fe:	0047d79b          	srliw	a5,a5,0x4
    80003702:	0001c597          	auipc	a1,0x1c
    80003706:	7e65a583          	lw	a1,2022(a1) # 8001fee8 <sb+0x18>
    8000370a:	9dbd                	addw	a1,a1,a5
    8000370c:	4088                	lw	a0,0(s1)
    8000370e:	fffff097          	auipc	ra,0xfffff
    80003712:	7ac080e7          	jalr	1964(ra) # 80002eba <bread>
    80003716:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003718:	06050593          	addi	a1,a0,96
    8000371c:	40dc                	lw	a5,4(s1)
    8000371e:	8bbd                	andi	a5,a5,15
    80003720:	079a                	slli	a5,a5,0x6
    80003722:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003724:	00059783          	lh	a5,0(a1)
    80003728:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000372c:	00259783          	lh	a5,2(a1)
    80003730:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003734:	00459783          	lh	a5,4(a1)
    80003738:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000373c:	00659783          	lh	a5,6(a1)
    80003740:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003744:	459c                	lw	a5,8(a1)
    80003746:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003748:	03400613          	li	a2,52
    8000374c:	05b1                	addi	a1,a1,12
    8000374e:	05048513          	addi	a0,s1,80
    80003752:	ffffd097          	auipc	ra,0xffffd
    80003756:	47c080e7          	jalr	1148(ra) # 80000bce <memmove>
    brelse(bp);
    8000375a:	854a                	mv	a0,s2
    8000375c:	00000097          	auipc	ra,0x0
    80003760:	88e080e7          	jalr	-1906(ra) # 80002fea <brelse>
    ip->valid = 1;
    80003764:	4785                	li	a5,1
    80003766:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003768:	04449783          	lh	a5,68(s1)
    8000376c:	fbb5                	bnez	a5,800036e0 <ilock+0x24>
      panic("ilock: no type");
    8000376e:	00004517          	auipc	a0,0x4
    80003772:	f2a50513          	addi	a0,a0,-214 # 80007698 <userret+0x608>
    80003776:	ffffd097          	auipc	ra,0xffffd
    8000377a:	dd8080e7          	jalr	-552(ra) # 8000054e <panic>

000000008000377e <iunlock>:
{
    8000377e:	1101                	addi	sp,sp,-32
    80003780:	ec06                	sd	ra,24(sp)
    80003782:	e822                	sd	s0,16(sp)
    80003784:	e426                	sd	s1,8(sp)
    80003786:	e04a                	sd	s2,0(sp)
    80003788:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000378a:	c905                	beqz	a0,800037ba <iunlock+0x3c>
    8000378c:	84aa                	mv	s1,a0
    8000378e:	01050913          	addi	s2,a0,16
    80003792:	854a                	mv	a0,s2
    80003794:	00001097          	auipc	ra,0x1
    80003798:	c56080e7          	jalr	-938(ra) # 800043ea <holdingsleep>
    8000379c:	cd19                	beqz	a0,800037ba <iunlock+0x3c>
    8000379e:	449c                	lw	a5,8(s1)
    800037a0:	00f05d63          	blez	a5,800037ba <iunlock+0x3c>
  releasesleep(&ip->lock);
    800037a4:	854a                	mv	a0,s2
    800037a6:	00001097          	auipc	ra,0x1
    800037aa:	c00080e7          	jalr	-1024(ra) # 800043a6 <releasesleep>
}
    800037ae:	60e2                	ld	ra,24(sp)
    800037b0:	6442                	ld	s0,16(sp)
    800037b2:	64a2                	ld	s1,8(sp)
    800037b4:	6902                	ld	s2,0(sp)
    800037b6:	6105                	addi	sp,sp,32
    800037b8:	8082                	ret
    panic("iunlock");
    800037ba:	00004517          	auipc	a0,0x4
    800037be:	eee50513          	addi	a0,a0,-274 # 800076a8 <userret+0x618>
    800037c2:	ffffd097          	auipc	ra,0xffffd
    800037c6:	d8c080e7          	jalr	-628(ra) # 8000054e <panic>

00000000800037ca <iput>:
{
    800037ca:	7139                	addi	sp,sp,-64
    800037cc:	fc06                	sd	ra,56(sp)
    800037ce:	f822                	sd	s0,48(sp)
    800037d0:	f426                	sd	s1,40(sp)
    800037d2:	f04a                	sd	s2,32(sp)
    800037d4:	ec4e                	sd	s3,24(sp)
    800037d6:	e852                	sd	s4,16(sp)
    800037d8:	e456                	sd	s5,8(sp)
    800037da:	0080                	addi	s0,sp,64
    800037dc:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800037de:	0001c517          	auipc	a0,0x1c
    800037e2:	71250513          	addi	a0,a0,1810 # 8001fef0 <icache>
    800037e6:	ffffd097          	auipc	ra,0xffffd
    800037ea:	2ec080e7          	jalr	748(ra) # 80000ad2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037ee:	4498                	lw	a4,8(s1)
    800037f0:	4785                	li	a5,1
    800037f2:	02f70663          	beq	a4,a5,8000381e <iput+0x54>
  ip->ref--;
    800037f6:	449c                	lw	a5,8(s1)
    800037f8:	37fd                	addiw	a5,a5,-1
    800037fa:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800037fc:	0001c517          	auipc	a0,0x1c
    80003800:	6f450513          	addi	a0,a0,1780 # 8001fef0 <icache>
    80003804:	ffffd097          	auipc	ra,0xffffd
    80003808:	322080e7          	jalr	802(ra) # 80000b26 <release>
}
    8000380c:	70e2                	ld	ra,56(sp)
    8000380e:	7442                	ld	s0,48(sp)
    80003810:	74a2                	ld	s1,40(sp)
    80003812:	7902                	ld	s2,32(sp)
    80003814:	69e2                	ld	s3,24(sp)
    80003816:	6a42                	ld	s4,16(sp)
    80003818:	6aa2                	ld	s5,8(sp)
    8000381a:	6121                	addi	sp,sp,64
    8000381c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000381e:	40bc                	lw	a5,64(s1)
    80003820:	dbf9                	beqz	a5,800037f6 <iput+0x2c>
    80003822:	04a49783          	lh	a5,74(s1)
    80003826:	fbe1                	bnez	a5,800037f6 <iput+0x2c>
    acquiresleep(&ip->lock);
    80003828:	01048a13          	addi	s4,s1,16
    8000382c:	8552                	mv	a0,s4
    8000382e:	00001097          	auipc	ra,0x1
    80003832:	b22080e7          	jalr	-1246(ra) # 80004350 <acquiresleep>
    release(&icache.lock);
    80003836:	0001c517          	auipc	a0,0x1c
    8000383a:	6ba50513          	addi	a0,a0,1722 # 8001fef0 <icache>
    8000383e:	ffffd097          	auipc	ra,0xffffd
    80003842:	2e8080e7          	jalr	744(ra) # 80000b26 <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003846:	05048913          	addi	s2,s1,80
    8000384a:	08048993          	addi	s3,s1,128
    8000384e:	a819                	j	80003864 <iput+0x9a>
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
    80003850:	4088                	lw	a0,0(s1)
    80003852:	00000097          	auipc	ra,0x0
    80003856:	8ae080e7          	jalr	-1874(ra) # 80003100 <bfree>
      ip->addrs[i] = 0;
    8000385a:	00092023          	sw	zero,0(s2)
  for(i = 0; i < NDIRECT; i++){
    8000385e:	0911                	addi	s2,s2,4
    80003860:	01390663          	beq	s2,s3,8000386c <iput+0xa2>
    if(ip->addrs[i]){
    80003864:	00092583          	lw	a1,0(s2)
    80003868:	d9fd                	beqz	a1,8000385e <iput+0x94>
    8000386a:	b7dd                	j	80003850 <iput+0x86>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000386c:	0804a583          	lw	a1,128(s1)
    80003870:	ed9d                	bnez	a1,800038ae <iput+0xe4>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003872:	0404a623          	sw	zero,76(s1)
  iupdate(ip);
    80003876:	8526                	mv	a0,s1
    80003878:	00000097          	auipc	ra,0x0
    8000387c:	d7a080e7          	jalr	-646(ra) # 800035f2 <iupdate>
    ip->type = 0;
    80003880:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003884:	8526                	mv	a0,s1
    80003886:	00000097          	auipc	ra,0x0
    8000388a:	d6c080e7          	jalr	-660(ra) # 800035f2 <iupdate>
    ip->valid = 0;
    8000388e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003892:	8552                	mv	a0,s4
    80003894:	00001097          	auipc	ra,0x1
    80003898:	b12080e7          	jalr	-1262(ra) # 800043a6 <releasesleep>
    acquire(&icache.lock);
    8000389c:	0001c517          	auipc	a0,0x1c
    800038a0:	65450513          	addi	a0,a0,1620 # 8001fef0 <icache>
    800038a4:	ffffd097          	auipc	ra,0xffffd
    800038a8:	22e080e7          	jalr	558(ra) # 80000ad2 <acquire>
    800038ac:	b7a9                	j	800037f6 <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800038ae:	4088                	lw	a0,0(s1)
    800038b0:	fffff097          	auipc	ra,0xfffff
    800038b4:	60a080e7          	jalr	1546(ra) # 80002eba <bread>
    800038b8:	8aaa                	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
    800038ba:	06050913          	addi	s2,a0,96
    800038be:	46050993          	addi	s3,a0,1120
    800038c2:	a809                	j	800038d4 <iput+0x10a>
        bfree(ip->dev, a[j]);
    800038c4:	4088                	lw	a0,0(s1)
    800038c6:	00000097          	auipc	ra,0x0
    800038ca:	83a080e7          	jalr	-1990(ra) # 80003100 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    800038ce:	0911                	addi	s2,s2,4
    800038d0:	01390663          	beq	s2,s3,800038dc <iput+0x112>
      if(a[j])
    800038d4:	00092583          	lw	a1,0(s2)
    800038d8:	d9fd                	beqz	a1,800038ce <iput+0x104>
    800038da:	b7ed                	j	800038c4 <iput+0xfa>
    brelse(bp);
    800038dc:	8556                	mv	a0,s5
    800038de:	fffff097          	auipc	ra,0xfffff
    800038e2:	70c080e7          	jalr	1804(ra) # 80002fea <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800038e6:	0804a583          	lw	a1,128(s1)
    800038ea:	4088                	lw	a0,0(s1)
    800038ec:	00000097          	auipc	ra,0x0
    800038f0:	814080e7          	jalr	-2028(ra) # 80003100 <bfree>
    ip->addrs[NDIRECT] = 0;
    800038f4:	0804a023          	sw	zero,128(s1)
    800038f8:	bfad                	j	80003872 <iput+0xa8>

00000000800038fa <iunlockput>:
{
    800038fa:	1101                	addi	sp,sp,-32
    800038fc:	ec06                	sd	ra,24(sp)
    800038fe:	e822                	sd	s0,16(sp)
    80003900:	e426                	sd	s1,8(sp)
    80003902:	1000                	addi	s0,sp,32
    80003904:	84aa                	mv	s1,a0
  iunlock(ip);
    80003906:	00000097          	auipc	ra,0x0
    8000390a:	e78080e7          	jalr	-392(ra) # 8000377e <iunlock>
  iput(ip);
    8000390e:	8526                	mv	a0,s1
    80003910:	00000097          	auipc	ra,0x0
    80003914:	eba080e7          	jalr	-326(ra) # 800037ca <iput>
}
    80003918:	60e2                	ld	ra,24(sp)
    8000391a:	6442                	ld	s0,16(sp)
    8000391c:	64a2                	ld	s1,8(sp)
    8000391e:	6105                	addi	sp,sp,32
    80003920:	8082                	ret

0000000080003922 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003922:	1141                	addi	sp,sp,-16
    80003924:	e422                	sd	s0,8(sp)
    80003926:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003928:	411c                	lw	a5,0(a0)
    8000392a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000392c:	415c                	lw	a5,4(a0)
    8000392e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003930:	04451783          	lh	a5,68(a0)
    80003934:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003938:	04a51783          	lh	a5,74(a0)
    8000393c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003940:	04c56783          	lwu	a5,76(a0)
    80003944:	e99c                	sd	a5,16(a1)
}
    80003946:	6422                	ld	s0,8(sp)
    80003948:	0141                	addi	sp,sp,16
    8000394a:	8082                	ret

000000008000394c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000394c:	457c                	lw	a5,76(a0)
    8000394e:	0ed7e563          	bltu	a5,a3,80003a38 <readi+0xec>
{
    80003952:	7159                	addi	sp,sp,-112
    80003954:	f486                	sd	ra,104(sp)
    80003956:	f0a2                	sd	s0,96(sp)
    80003958:	eca6                	sd	s1,88(sp)
    8000395a:	e8ca                	sd	s2,80(sp)
    8000395c:	e4ce                	sd	s3,72(sp)
    8000395e:	e0d2                	sd	s4,64(sp)
    80003960:	fc56                	sd	s5,56(sp)
    80003962:	f85a                	sd	s6,48(sp)
    80003964:	f45e                	sd	s7,40(sp)
    80003966:	f062                	sd	s8,32(sp)
    80003968:	ec66                	sd	s9,24(sp)
    8000396a:	e86a                	sd	s10,16(sp)
    8000396c:	e46e                	sd	s11,8(sp)
    8000396e:	1880                	addi	s0,sp,112
    80003970:	8baa                	mv	s7,a0
    80003972:	8c2e                	mv	s8,a1
    80003974:	8ab2                	mv	s5,a2
    80003976:	8936                	mv	s2,a3
    80003978:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000397a:	9f35                	addw	a4,a4,a3
    8000397c:	0cd76063          	bltu	a4,a3,80003a3c <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    80003980:	00e7f463          	bgeu	a5,a4,80003988 <readi+0x3c>
    n = ip->size - off; //only can read till the end of the file
    80003984:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003988:	080b0763          	beqz	s6,80003a16 <readi+0xca>
    8000398c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000398e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003992:	5cfd                	li	s9,-1
    80003994:	a82d                	j	800039ce <readi+0x82>
    80003996:	02099d93          	slli	s11,s3,0x20
    8000399a:	020ddd93          	srli	s11,s11,0x20
    8000399e:	06048613          	addi	a2,s1,96
    800039a2:	86ee                	mv	a3,s11
    800039a4:	963a                	add	a2,a2,a4
    800039a6:	85d6                	mv	a1,s5
    800039a8:	8562                	mv	a0,s8
    800039aa:	fffff097          	auipc	ra,0xfffff
    800039ae:	b1a080e7          	jalr	-1254(ra) # 800024c4 <either_copyout>
    800039b2:	05950d63          	beq	a0,s9,80003a0c <readi+0xc0>
      brelse(bp);
      break;
    }
    brelse(bp);
    800039b6:	8526                	mv	a0,s1
    800039b8:	fffff097          	auipc	ra,0xfffff
    800039bc:	632080e7          	jalr	1586(ra) # 80002fea <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800039c0:	01498a3b          	addw	s4,s3,s4
    800039c4:	0129893b          	addw	s2,s3,s2
    800039c8:	9aee                	add	s5,s5,s11
    800039ca:	056a7663          	bgeu	s4,s6,80003a16 <readi+0xca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800039ce:	000ba483          	lw	s1,0(s7)
    800039d2:	00a9559b          	srliw	a1,s2,0xa
    800039d6:	855e                	mv	a0,s7
    800039d8:	00000097          	auipc	ra,0x0
    800039dc:	8d6080e7          	jalr	-1834(ra) # 800032ae <bmap>
    800039e0:	0005059b          	sext.w	a1,a0
    800039e4:	8526                	mv	a0,s1
    800039e6:	fffff097          	auipc	ra,0xfffff
    800039ea:	4d4080e7          	jalr	1236(ra) # 80002eba <bread>
    800039ee:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800039f0:	3ff97713          	andi	a4,s2,1023
    800039f4:	40ed07bb          	subw	a5,s10,a4
    800039f8:	414b06bb          	subw	a3,s6,s4
    800039fc:	89be                	mv	s3,a5
    800039fe:	2781                	sext.w	a5,a5
    80003a00:	0006861b          	sext.w	a2,a3
    80003a04:	f8f679e3          	bgeu	a2,a5,80003996 <readi+0x4a>
    80003a08:	89b6                	mv	s3,a3
    80003a0a:	b771                	j	80003996 <readi+0x4a>
      brelse(bp);
    80003a0c:	8526                	mv	a0,s1
    80003a0e:	fffff097          	auipc	ra,0xfffff
    80003a12:	5dc080e7          	jalr	1500(ra) # 80002fea <brelse>
  }
  return n;
    80003a16:	000b051b          	sext.w	a0,s6
}
    80003a1a:	70a6                	ld	ra,104(sp)
    80003a1c:	7406                	ld	s0,96(sp)
    80003a1e:	64e6                	ld	s1,88(sp)
    80003a20:	6946                	ld	s2,80(sp)
    80003a22:	69a6                	ld	s3,72(sp)
    80003a24:	6a06                	ld	s4,64(sp)
    80003a26:	7ae2                	ld	s5,56(sp)
    80003a28:	7b42                	ld	s6,48(sp)
    80003a2a:	7ba2                	ld	s7,40(sp)
    80003a2c:	7c02                	ld	s8,32(sp)
    80003a2e:	6ce2                	ld	s9,24(sp)
    80003a30:	6d42                	ld	s10,16(sp)
    80003a32:	6da2                	ld	s11,8(sp)
    80003a34:	6165                	addi	sp,sp,112
    80003a36:	8082                	ret
    return -1;
    80003a38:	557d                	li	a0,-1
}
    80003a3a:	8082                	ret
    return -1;
    80003a3c:	557d                	li	a0,-1
    80003a3e:	bff1                	j	80003a1a <readi+0xce>

0000000080003a40 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a40:	457c                	lw	a5,76(a0)
    80003a42:	10d7e663          	bltu	a5,a3,80003b4e <writei+0x10e>
{
    80003a46:	7159                	addi	sp,sp,-112
    80003a48:	f486                	sd	ra,104(sp)
    80003a4a:	f0a2                	sd	s0,96(sp)
    80003a4c:	eca6                	sd	s1,88(sp)
    80003a4e:	e8ca                	sd	s2,80(sp)
    80003a50:	e4ce                	sd	s3,72(sp)
    80003a52:	e0d2                	sd	s4,64(sp)
    80003a54:	fc56                	sd	s5,56(sp)
    80003a56:	f85a                	sd	s6,48(sp)
    80003a58:	f45e                	sd	s7,40(sp)
    80003a5a:	f062                	sd	s8,32(sp)
    80003a5c:	ec66                	sd	s9,24(sp)
    80003a5e:	e86a                	sd	s10,16(sp)
    80003a60:	e46e                	sd	s11,8(sp)
    80003a62:	1880                	addi	s0,sp,112
    80003a64:	8baa                	mv	s7,a0
    80003a66:	8c2e                	mv	s8,a1
    80003a68:	8ab2                	mv	s5,a2
    80003a6a:	8936                	mv	s2,a3
    80003a6c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003a6e:	00e687bb          	addw	a5,a3,a4
    80003a72:	0ed7e063          	bltu	a5,a3,80003b52 <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003a76:	00043737          	lui	a4,0x43
    80003a7a:	0cf76e63          	bltu	a4,a5,80003b56 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a7e:	0a0b0763          	beqz	s6,80003b2c <writei+0xec>
    80003a82:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a84:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003a88:	5cfd                	li	s9,-1
    80003a8a:	a091                	j	80003ace <writei+0x8e>
    80003a8c:	02099d93          	slli	s11,s3,0x20
    80003a90:	020ddd93          	srli	s11,s11,0x20
    80003a94:	06048513          	addi	a0,s1,96
    80003a98:	86ee                	mv	a3,s11
    80003a9a:	8656                	mv	a2,s5
    80003a9c:	85e2                	mv	a1,s8
    80003a9e:	953a                	add	a0,a0,a4
    80003aa0:	fffff097          	auipc	ra,0xfffff
    80003aa4:	a7a080e7          	jalr	-1414(ra) # 8000251a <either_copyin>
    80003aa8:	07950263          	beq	a0,s9,80003b0c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003aac:	8526                	mv	a0,s1
    80003aae:	00000097          	auipc	ra,0x0
    80003ab2:	77a080e7          	jalr	1914(ra) # 80004228 <log_write>
    brelse(bp);
    80003ab6:	8526                	mv	a0,s1
    80003ab8:	fffff097          	auipc	ra,0xfffff
    80003abc:	532080e7          	jalr	1330(ra) # 80002fea <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ac0:	01498a3b          	addw	s4,s3,s4
    80003ac4:	0129893b          	addw	s2,s3,s2
    80003ac8:	9aee                	add	s5,s5,s11
    80003aca:	056a7663          	bgeu	s4,s6,80003b16 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003ace:	000ba483          	lw	s1,0(s7)
    80003ad2:	00a9559b          	srliw	a1,s2,0xa
    80003ad6:	855e                	mv	a0,s7
    80003ad8:	fffff097          	auipc	ra,0xfffff
    80003adc:	7d6080e7          	jalr	2006(ra) # 800032ae <bmap>
    80003ae0:	0005059b          	sext.w	a1,a0
    80003ae4:	8526                	mv	a0,s1
    80003ae6:	fffff097          	auipc	ra,0xfffff
    80003aea:	3d4080e7          	jalr	980(ra) # 80002eba <bread>
    80003aee:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003af0:	3ff97713          	andi	a4,s2,1023
    80003af4:	40ed07bb          	subw	a5,s10,a4
    80003af8:	414b06bb          	subw	a3,s6,s4
    80003afc:	89be                	mv	s3,a5
    80003afe:	2781                	sext.w	a5,a5
    80003b00:	0006861b          	sext.w	a2,a3
    80003b04:	f8f674e3          	bgeu	a2,a5,80003a8c <writei+0x4c>
    80003b08:	89b6                	mv	s3,a3
    80003b0a:	b749                	j	80003a8c <writei+0x4c>
      brelse(bp);
    80003b0c:	8526                	mv	a0,s1
    80003b0e:	fffff097          	auipc	ra,0xfffff
    80003b12:	4dc080e7          	jalr	1244(ra) # 80002fea <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003b16:	04cba783          	lw	a5,76(s7)
    80003b1a:	0127f463          	bgeu	a5,s2,80003b22 <writei+0xe2>
      ip->size = off;
    80003b1e:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003b22:	855e                	mv	a0,s7
    80003b24:	00000097          	auipc	ra,0x0
    80003b28:	ace080e7          	jalr	-1330(ra) # 800035f2 <iupdate>
  }

  return n;
    80003b2c:	000b051b          	sext.w	a0,s6
}
    80003b30:	70a6                	ld	ra,104(sp)
    80003b32:	7406                	ld	s0,96(sp)
    80003b34:	64e6                	ld	s1,88(sp)
    80003b36:	6946                	ld	s2,80(sp)
    80003b38:	69a6                	ld	s3,72(sp)
    80003b3a:	6a06                	ld	s4,64(sp)
    80003b3c:	7ae2                	ld	s5,56(sp)
    80003b3e:	7b42                	ld	s6,48(sp)
    80003b40:	7ba2                	ld	s7,40(sp)
    80003b42:	7c02                	ld	s8,32(sp)
    80003b44:	6ce2                	ld	s9,24(sp)
    80003b46:	6d42                	ld	s10,16(sp)
    80003b48:	6da2                	ld	s11,8(sp)
    80003b4a:	6165                	addi	sp,sp,112
    80003b4c:	8082                	ret
    return -1;
    80003b4e:	557d                	li	a0,-1
}
    80003b50:	8082                	ret
    return -1;
    80003b52:	557d                	li	a0,-1
    80003b54:	bff1                	j	80003b30 <writei+0xf0>
    return -1;
    80003b56:	557d                	li	a0,-1
    80003b58:	bfe1                	j	80003b30 <writei+0xf0>

0000000080003b5a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003b5a:	1141                	addi	sp,sp,-16
    80003b5c:	e406                	sd	ra,8(sp)
    80003b5e:	e022                	sd	s0,0(sp)
    80003b60:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003b62:	4639                	li	a2,14
    80003b64:	ffffd097          	auipc	ra,0xffffd
    80003b68:	0e6080e7          	jalr	230(ra) # 80000c4a <strncmp>
}
    80003b6c:	60a2                	ld	ra,8(sp)
    80003b6e:	6402                	ld	s0,0(sp)
    80003b70:	0141                	addi	sp,sp,16
    80003b72:	8082                	ret

0000000080003b74 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003b74:	7139                	addi	sp,sp,-64
    80003b76:	fc06                	sd	ra,56(sp)
    80003b78:	f822                	sd	s0,48(sp)
    80003b7a:	f426                	sd	s1,40(sp)
    80003b7c:	f04a                	sd	s2,32(sp)
    80003b7e:	ec4e                	sd	s3,24(sp)
    80003b80:	e852                	sd	s4,16(sp)
    80003b82:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003b84:	04451703          	lh	a4,68(a0)
    80003b88:	4785                	li	a5,1
    80003b8a:	00f71a63          	bne	a4,a5,80003b9e <dirlookup+0x2a>
    80003b8e:	892a                	mv	s2,a0
    80003b90:	89ae                	mv	s3,a1
    80003b92:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b94:	457c                	lw	a5,76(a0)
    80003b96:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003b98:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b9a:	e79d                	bnez	a5,80003bc8 <dirlookup+0x54>
    80003b9c:	a8a5                	j	80003c14 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003b9e:	00004517          	auipc	a0,0x4
    80003ba2:	b1250513          	addi	a0,a0,-1262 # 800076b0 <userret+0x620>
    80003ba6:	ffffd097          	auipc	ra,0xffffd
    80003baa:	9a8080e7          	jalr	-1624(ra) # 8000054e <panic>
      panic("dirlookup read");
    80003bae:	00004517          	auipc	a0,0x4
    80003bb2:	b1a50513          	addi	a0,a0,-1254 # 800076c8 <userret+0x638>
    80003bb6:	ffffd097          	auipc	ra,0xffffd
    80003bba:	998080e7          	jalr	-1640(ra) # 8000054e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bbe:	24c1                	addiw	s1,s1,16
    80003bc0:	04c92783          	lw	a5,76(s2)
    80003bc4:	04f4f763          	bgeu	s1,a5,80003c12 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003bc8:	4741                	li	a4,16
    80003bca:	86a6                	mv	a3,s1
    80003bcc:	fc040613          	addi	a2,s0,-64
    80003bd0:	4581                	li	a1,0
    80003bd2:	854a                	mv	a0,s2
    80003bd4:	00000097          	auipc	ra,0x0
    80003bd8:	d78080e7          	jalr	-648(ra) # 8000394c <readi>
    80003bdc:	47c1                	li	a5,16
    80003bde:	fcf518e3          	bne	a0,a5,80003bae <dirlookup+0x3a>
    if(de.inum == 0)
    80003be2:	fc045783          	lhu	a5,-64(s0)
    80003be6:	dfe1                	beqz	a5,80003bbe <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003be8:	fc240593          	addi	a1,s0,-62
    80003bec:	854e                	mv	a0,s3
    80003bee:	00000097          	auipc	ra,0x0
    80003bf2:	f6c080e7          	jalr	-148(ra) # 80003b5a <namecmp>
    80003bf6:	f561                	bnez	a0,80003bbe <dirlookup+0x4a>
      if(poff)
    80003bf8:	000a0463          	beqz	s4,80003c00 <dirlookup+0x8c>
        *poff = off;
    80003bfc:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003c00:	fc045583          	lhu	a1,-64(s0)
    80003c04:	00092503          	lw	a0,0(s2)
    80003c08:	fffff097          	auipc	ra,0xfffff
    80003c0c:	780080e7          	jalr	1920(ra) # 80003388 <iget>
    80003c10:	a011                	j	80003c14 <dirlookup+0xa0>
  return 0;
    80003c12:	4501                	li	a0,0
}
    80003c14:	70e2                	ld	ra,56(sp)
    80003c16:	7442                	ld	s0,48(sp)
    80003c18:	74a2                	ld	s1,40(sp)
    80003c1a:	7902                	ld	s2,32(sp)
    80003c1c:	69e2                	ld	s3,24(sp)
    80003c1e:	6a42                	ld	s4,16(sp)
    80003c20:	6121                	addi	sp,sp,64
    80003c22:	8082                	ret

0000000080003c24 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003c24:	711d                	addi	sp,sp,-96
    80003c26:	ec86                	sd	ra,88(sp)
    80003c28:	e8a2                	sd	s0,80(sp)
    80003c2a:	e4a6                	sd	s1,72(sp)
    80003c2c:	e0ca                	sd	s2,64(sp)
    80003c2e:	fc4e                	sd	s3,56(sp)
    80003c30:	f852                	sd	s4,48(sp)
    80003c32:	f456                	sd	s5,40(sp)
    80003c34:	f05a                	sd	s6,32(sp)
    80003c36:	ec5e                	sd	s7,24(sp)
    80003c38:	e862                	sd	s8,16(sp)
    80003c3a:	e466                	sd	s9,8(sp)
    80003c3c:	1080                	addi	s0,sp,96
    80003c3e:	84aa                	mv	s1,a0
    80003c40:	8b2e                	mv	s6,a1
    80003c42:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003c44:	00054703          	lbu	a4,0(a0)
    80003c48:	02f00793          	li	a5,47
    80003c4c:	02f70363          	beq	a4,a5,80003c72 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003c50:	ffffe097          	auipc	ra,0xffffe
    80003c54:	e6e080e7          	jalr	-402(ra) # 80001abe <myproc>
    80003c58:	15053503          	ld	a0,336(a0)
    80003c5c:	00000097          	auipc	ra,0x0
    80003c60:	a22080e7          	jalr	-1502(ra) # 8000367e <idup>
    80003c64:	89aa                	mv	s3,a0
  while(*path == '/')
    80003c66:	02f00913          	li	s2,47
  len = path - s;
    80003c6a:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003c6c:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003c6e:	4c05                	li	s8,1
    80003c70:	a865                	j	80003d28 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003c72:	4585                	li	a1,1
    80003c74:	4505                	li	a0,1
    80003c76:	fffff097          	auipc	ra,0xfffff
    80003c7a:	712080e7          	jalr	1810(ra) # 80003388 <iget>
    80003c7e:	89aa                	mv	s3,a0
    80003c80:	b7dd                	j	80003c66 <namex+0x42>
      iunlockput(ip);
    80003c82:	854e                	mv	a0,s3
    80003c84:	00000097          	auipc	ra,0x0
    80003c88:	c76080e7          	jalr	-906(ra) # 800038fa <iunlockput>
      return 0;
    80003c8c:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003c8e:	854e                	mv	a0,s3
    80003c90:	60e6                	ld	ra,88(sp)
    80003c92:	6446                	ld	s0,80(sp)
    80003c94:	64a6                	ld	s1,72(sp)
    80003c96:	6906                	ld	s2,64(sp)
    80003c98:	79e2                	ld	s3,56(sp)
    80003c9a:	7a42                	ld	s4,48(sp)
    80003c9c:	7aa2                	ld	s5,40(sp)
    80003c9e:	7b02                	ld	s6,32(sp)
    80003ca0:	6be2                	ld	s7,24(sp)
    80003ca2:	6c42                	ld	s8,16(sp)
    80003ca4:	6ca2                	ld	s9,8(sp)
    80003ca6:	6125                	addi	sp,sp,96
    80003ca8:	8082                	ret
      iunlock(ip);
    80003caa:	854e                	mv	a0,s3
    80003cac:	00000097          	auipc	ra,0x0
    80003cb0:	ad2080e7          	jalr	-1326(ra) # 8000377e <iunlock>
      return ip;
    80003cb4:	bfe9                	j	80003c8e <namex+0x6a>
      iunlockput(ip);
    80003cb6:	854e                	mv	a0,s3
    80003cb8:	00000097          	auipc	ra,0x0
    80003cbc:	c42080e7          	jalr	-958(ra) # 800038fa <iunlockput>
      return 0;
    80003cc0:	89d2                	mv	s3,s4
    80003cc2:	b7f1                	j	80003c8e <namex+0x6a>
  len = path - s;
    80003cc4:	40b48633          	sub	a2,s1,a1
    80003cc8:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003ccc:	094cd463          	bge	s9,s4,80003d54 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003cd0:	4639                	li	a2,14
    80003cd2:	8556                	mv	a0,s5
    80003cd4:	ffffd097          	auipc	ra,0xffffd
    80003cd8:	efa080e7          	jalr	-262(ra) # 80000bce <memmove>
  while(*path == '/')
    80003cdc:	0004c783          	lbu	a5,0(s1)
    80003ce0:	01279763          	bne	a5,s2,80003cee <namex+0xca>
    path++;
    80003ce4:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003ce6:	0004c783          	lbu	a5,0(s1)
    80003cea:	ff278de3          	beq	a5,s2,80003ce4 <namex+0xc0>
    ilock(ip);
    80003cee:	854e                	mv	a0,s3
    80003cf0:	00000097          	auipc	ra,0x0
    80003cf4:	9cc080e7          	jalr	-1588(ra) # 800036bc <ilock>
    if(ip->type != T_DIR){
    80003cf8:	04499783          	lh	a5,68(s3)
    80003cfc:	f98793e3          	bne	a5,s8,80003c82 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003d00:	000b0563          	beqz	s6,80003d0a <namex+0xe6>
    80003d04:	0004c783          	lbu	a5,0(s1)
    80003d08:	d3cd                	beqz	a5,80003caa <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003d0a:	865e                	mv	a2,s7
    80003d0c:	85d6                	mv	a1,s5
    80003d0e:	854e                	mv	a0,s3
    80003d10:	00000097          	auipc	ra,0x0
    80003d14:	e64080e7          	jalr	-412(ra) # 80003b74 <dirlookup>
    80003d18:	8a2a                	mv	s4,a0
    80003d1a:	dd51                	beqz	a0,80003cb6 <namex+0x92>
    iunlockput(ip);
    80003d1c:	854e                	mv	a0,s3
    80003d1e:	00000097          	auipc	ra,0x0
    80003d22:	bdc080e7          	jalr	-1060(ra) # 800038fa <iunlockput>
    ip = next;
    80003d26:	89d2                	mv	s3,s4
  while(*path == '/')
    80003d28:	0004c783          	lbu	a5,0(s1)
    80003d2c:	05279763          	bne	a5,s2,80003d7a <namex+0x156>
    path++;
    80003d30:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d32:	0004c783          	lbu	a5,0(s1)
    80003d36:	ff278de3          	beq	a5,s2,80003d30 <namex+0x10c>
  if(*path == 0)
    80003d3a:	c79d                	beqz	a5,80003d68 <namex+0x144>
    path++;
    80003d3c:	85a6                	mv	a1,s1
  len = path - s;
    80003d3e:	8a5e                	mv	s4,s7
    80003d40:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003d42:	01278963          	beq	a5,s2,80003d54 <namex+0x130>
    80003d46:	dfbd                	beqz	a5,80003cc4 <namex+0xa0>
    path++;
    80003d48:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003d4a:	0004c783          	lbu	a5,0(s1)
    80003d4e:	ff279ce3          	bne	a5,s2,80003d46 <namex+0x122>
    80003d52:	bf8d                	j	80003cc4 <namex+0xa0>
    memmove(name, s, len);
    80003d54:	2601                	sext.w	a2,a2
    80003d56:	8556                	mv	a0,s5
    80003d58:	ffffd097          	auipc	ra,0xffffd
    80003d5c:	e76080e7          	jalr	-394(ra) # 80000bce <memmove>
    name[len] = 0;
    80003d60:	9a56                	add	s4,s4,s5
    80003d62:	000a0023          	sb	zero,0(s4)
    80003d66:	bf9d                	j	80003cdc <namex+0xb8>
  if(nameiparent){
    80003d68:	f20b03e3          	beqz	s6,80003c8e <namex+0x6a>
    iput(ip);
    80003d6c:	854e                	mv	a0,s3
    80003d6e:	00000097          	auipc	ra,0x0
    80003d72:	a5c080e7          	jalr	-1444(ra) # 800037ca <iput>
    return 0;
    80003d76:	4981                	li	s3,0
    80003d78:	bf19                	j	80003c8e <namex+0x6a>
  if(*path == 0)
    80003d7a:	d7fd                	beqz	a5,80003d68 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003d7c:	0004c783          	lbu	a5,0(s1)
    80003d80:	85a6                	mv	a1,s1
    80003d82:	b7d1                	j	80003d46 <namex+0x122>

0000000080003d84 <dirlink>:
{
    80003d84:	7139                	addi	sp,sp,-64
    80003d86:	fc06                	sd	ra,56(sp)
    80003d88:	f822                	sd	s0,48(sp)
    80003d8a:	f426                	sd	s1,40(sp)
    80003d8c:	f04a                	sd	s2,32(sp)
    80003d8e:	ec4e                	sd	s3,24(sp)
    80003d90:	e852                	sd	s4,16(sp)
    80003d92:	0080                	addi	s0,sp,64
    80003d94:	892a                	mv	s2,a0
    80003d96:	8a2e                	mv	s4,a1
    80003d98:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003d9a:	4601                	li	a2,0
    80003d9c:	00000097          	auipc	ra,0x0
    80003da0:	dd8080e7          	jalr	-552(ra) # 80003b74 <dirlookup>
    80003da4:	e93d                	bnez	a0,80003e1a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003da6:	04c92483          	lw	s1,76(s2)
    80003daa:	c49d                	beqz	s1,80003dd8 <dirlink+0x54>
    80003dac:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003dae:	4741                	li	a4,16
    80003db0:	86a6                	mv	a3,s1
    80003db2:	fc040613          	addi	a2,s0,-64
    80003db6:	4581                	li	a1,0
    80003db8:	854a                	mv	a0,s2
    80003dba:	00000097          	auipc	ra,0x0
    80003dbe:	b92080e7          	jalr	-1134(ra) # 8000394c <readi>
    80003dc2:	47c1                	li	a5,16
    80003dc4:	06f51163          	bne	a0,a5,80003e26 <dirlink+0xa2>
    if(de.inum == 0)
    80003dc8:	fc045783          	lhu	a5,-64(s0)
    80003dcc:	c791                	beqz	a5,80003dd8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003dce:	24c1                	addiw	s1,s1,16
    80003dd0:	04c92783          	lw	a5,76(s2)
    80003dd4:	fcf4ede3          	bltu	s1,a5,80003dae <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003dd8:	4639                	li	a2,14
    80003dda:	85d2                	mv	a1,s4
    80003ddc:	fc240513          	addi	a0,s0,-62
    80003de0:	ffffd097          	auipc	ra,0xffffd
    80003de4:	ea6080e7          	jalr	-346(ra) # 80000c86 <strncpy>
  de.inum = inum;
    80003de8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003dec:	4741                	li	a4,16
    80003dee:	86a6                	mv	a3,s1
    80003df0:	fc040613          	addi	a2,s0,-64
    80003df4:	4581                	li	a1,0
    80003df6:	854a                	mv	a0,s2
    80003df8:	00000097          	auipc	ra,0x0
    80003dfc:	c48080e7          	jalr	-952(ra) # 80003a40 <writei>
    80003e00:	872a                	mv	a4,a0
    80003e02:	47c1                	li	a5,16
  return 0;
    80003e04:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e06:	02f71863          	bne	a4,a5,80003e36 <dirlink+0xb2>
}
    80003e0a:	70e2                	ld	ra,56(sp)
    80003e0c:	7442                	ld	s0,48(sp)
    80003e0e:	74a2                	ld	s1,40(sp)
    80003e10:	7902                	ld	s2,32(sp)
    80003e12:	69e2                	ld	s3,24(sp)
    80003e14:	6a42                	ld	s4,16(sp)
    80003e16:	6121                	addi	sp,sp,64
    80003e18:	8082                	ret
    iput(ip);
    80003e1a:	00000097          	auipc	ra,0x0
    80003e1e:	9b0080e7          	jalr	-1616(ra) # 800037ca <iput>
    return -1;
    80003e22:	557d                	li	a0,-1
    80003e24:	b7dd                	j	80003e0a <dirlink+0x86>
      panic("dirlink read");
    80003e26:	00004517          	auipc	a0,0x4
    80003e2a:	8b250513          	addi	a0,a0,-1870 # 800076d8 <userret+0x648>
    80003e2e:	ffffc097          	auipc	ra,0xffffc
    80003e32:	720080e7          	jalr	1824(ra) # 8000054e <panic>
    panic("dirlink");
    80003e36:	00004517          	auipc	a0,0x4
    80003e3a:	9f250513          	addi	a0,a0,-1550 # 80007828 <userret+0x798>
    80003e3e:	ffffc097          	auipc	ra,0xffffc
    80003e42:	710080e7          	jalr	1808(ra) # 8000054e <panic>

0000000080003e46 <namei>:

struct inode*
namei(char *path)
{
    80003e46:	1101                	addi	sp,sp,-32
    80003e48:	ec06                	sd	ra,24(sp)
    80003e4a:	e822                	sd	s0,16(sp)
    80003e4c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003e4e:	fe040613          	addi	a2,s0,-32
    80003e52:	4581                	li	a1,0
    80003e54:	00000097          	auipc	ra,0x0
    80003e58:	dd0080e7          	jalr	-560(ra) # 80003c24 <namex>
}
    80003e5c:	60e2                	ld	ra,24(sp)
    80003e5e:	6442                	ld	s0,16(sp)
    80003e60:	6105                	addi	sp,sp,32
    80003e62:	8082                	ret

0000000080003e64 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003e64:	1141                	addi	sp,sp,-16
    80003e66:	e406                	sd	ra,8(sp)
    80003e68:	e022                	sd	s0,0(sp)
    80003e6a:	0800                	addi	s0,sp,16
    80003e6c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003e6e:	4585                	li	a1,1
    80003e70:	00000097          	auipc	ra,0x0
    80003e74:	db4080e7          	jalr	-588(ra) # 80003c24 <namex>
}
    80003e78:	60a2                	ld	ra,8(sp)
    80003e7a:	6402                	ld	s0,0(sp)
    80003e7c:	0141                	addi	sp,sp,16
    80003e7e:	8082                	ret

0000000080003e80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003e80:	1101                	addi	sp,sp,-32
    80003e82:	ec06                	sd	ra,24(sp)
    80003e84:	e822                	sd	s0,16(sp)
    80003e86:	e426                	sd	s1,8(sp)
    80003e88:	e04a                	sd	s2,0(sp)
    80003e8a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003e8c:	0001e917          	auipc	s2,0x1e
    80003e90:	b0c90913          	addi	s2,s2,-1268 # 80021998 <log>
    80003e94:	01892583          	lw	a1,24(s2)
    80003e98:	02892503          	lw	a0,40(s2)
    80003e9c:	fffff097          	auipc	ra,0xfffff
    80003ea0:	01e080e7          	jalr	30(ra) # 80002eba <bread>
    80003ea4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003ea6:	02c92683          	lw	a3,44(s2)
    80003eaa:	d134                	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003eac:	02d05763          	blez	a3,80003eda <write_head+0x5a>
    80003eb0:	0001e797          	auipc	a5,0x1e
    80003eb4:	b1878793          	addi	a5,a5,-1256 # 800219c8 <log+0x30>
    80003eb8:	06450713          	addi	a4,a0,100
    80003ebc:	36fd                	addiw	a3,a3,-1
    80003ebe:	1682                	slli	a3,a3,0x20
    80003ec0:	9281                	srli	a3,a3,0x20
    80003ec2:	068a                	slli	a3,a3,0x2
    80003ec4:	0001e617          	auipc	a2,0x1e
    80003ec8:	b0860613          	addi	a2,a2,-1272 # 800219cc <log+0x34>
    80003ecc:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003ece:	4390                	lw	a2,0(a5)
    80003ed0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003ed2:	0791                	addi	a5,a5,4
    80003ed4:	0711                	addi	a4,a4,4
    80003ed6:	fed79ce3          	bne	a5,a3,80003ece <write_head+0x4e>
  }
  bwrite(buf);
    80003eda:	8526                	mv	a0,s1
    80003edc:	fffff097          	auipc	ra,0xfffff
    80003ee0:	0d0080e7          	jalr	208(ra) # 80002fac <bwrite>
  brelse(buf);
    80003ee4:	8526                	mv	a0,s1
    80003ee6:	fffff097          	auipc	ra,0xfffff
    80003eea:	104080e7          	jalr	260(ra) # 80002fea <brelse>
}
    80003eee:	60e2                	ld	ra,24(sp)
    80003ef0:	6442                	ld	s0,16(sp)
    80003ef2:	64a2                	ld	s1,8(sp)
    80003ef4:	6902                	ld	s2,0(sp)
    80003ef6:	6105                	addi	sp,sp,32
    80003ef8:	8082                	ret

0000000080003efa <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003efa:	0001e797          	auipc	a5,0x1e
    80003efe:	aca7a783          	lw	a5,-1334(a5) # 800219c4 <log+0x2c>
    80003f02:	0af05663          	blez	a5,80003fae <install_trans+0xb4>
{
    80003f06:	7139                	addi	sp,sp,-64
    80003f08:	fc06                	sd	ra,56(sp)
    80003f0a:	f822                	sd	s0,48(sp)
    80003f0c:	f426                	sd	s1,40(sp)
    80003f0e:	f04a                	sd	s2,32(sp)
    80003f10:	ec4e                	sd	s3,24(sp)
    80003f12:	e852                	sd	s4,16(sp)
    80003f14:	e456                	sd	s5,8(sp)
    80003f16:	0080                	addi	s0,sp,64
    80003f18:	0001ea97          	auipc	s5,0x1e
    80003f1c:	ab0a8a93          	addi	s5,s5,-1360 # 800219c8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f20:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003f22:	0001e997          	auipc	s3,0x1e
    80003f26:	a7698993          	addi	s3,s3,-1418 # 80021998 <log>
    80003f2a:	0189a583          	lw	a1,24(s3)
    80003f2e:	014585bb          	addw	a1,a1,s4
    80003f32:	2585                	addiw	a1,a1,1
    80003f34:	0289a503          	lw	a0,40(s3)
    80003f38:	fffff097          	auipc	ra,0xfffff
    80003f3c:	f82080e7          	jalr	-126(ra) # 80002eba <bread>
    80003f40:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003f42:	000aa583          	lw	a1,0(s5)
    80003f46:	0289a503          	lw	a0,40(s3)
    80003f4a:	fffff097          	auipc	ra,0xfffff
    80003f4e:	f70080e7          	jalr	-144(ra) # 80002eba <bread>
    80003f52:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003f54:	40000613          	li	a2,1024
    80003f58:	06090593          	addi	a1,s2,96
    80003f5c:	06050513          	addi	a0,a0,96
    80003f60:	ffffd097          	auipc	ra,0xffffd
    80003f64:	c6e080e7          	jalr	-914(ra) # 80000bce <memmove>
    bwrite(dbuf);  // write dst to disk
    80003f68:	8526                	mv	a0,s1
    80003f6a:	fffff097          	auipc	ra,0xfffff
    80003f6e:	042080e7          	jalr	66(ra) # 80002fac <bwrite>
    bunpin(dbuf);
    80003f72:	8526                	mv	a0,s1
    80003f74:	fffff097          	auipc	ra,0xfffff
    80003f78:	150080e7          	jalr	336(ra) # 800030c4 <bunpin>
    brelse(lbuf);
    80003f7c:	854a                	mv	a0,s2
    80003f7e:	fffff097          	auipc	ra,0xfffff
    80003f82:	06c080e7          	jalr	108(ra) # 80002fea <brelse>
    brelse(dbuf);
    80003f86:	8526                	mv	a0,s1
    80003f88:	fffff097          	auipc	ra,0xfffff
    80003f8c:	062080e7          	jalr	98(ra) # 80002fea <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f90:	2a05                	addiw	s4,s4,1
    80003f92:	0a91                	addi	s5,s5,4
    80003f94:	02c9a783          	lw	a5,44(s3)
    80003f98:	f8fa49e3          	blt	s4,a5,80003f2a <install_trans+0x30>
}
    80003f9c:	70e2                	ld	ra,56(sp)
    80003f9e:	7442                	ld	s0,48(sp)
    80003fa0:	74a2                	ld	s1,40(sp)
    80003fa2:	7902                	ld	s2,32(sp)
    80003fa4:	69e2                	ld	s3,24(sp)
    80003fa6:	6a42                	ld	s4,16(sp)
    80003fa8:	6aa2                	ld	s5,8(sp)
    80003faa:	6121                	addi	sp,sp,64
    80003fac:	8082                	ret
    80003fae:	8082                	ret

0000000080003fb0 <initlog>:
{
    80003fb0:	7179                	addi	sp,sp,-48
    80003fb2:	f406                	sd	ra,40(sp)
    80003fb4:	f022                	sd	s0,32(sp)
    80003fb6:	ec26                	sd	s1,24(sp)
    80003fb8:	e84a                	sd	s2,16(sp)
    80003fba:	e44e                	sd	s3,8(sp)
    80003fbc:	1800                	addi	s0,sp,48
    80003fbe:	892a                	mv	s2,a0
    80003fc0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003fc2:	0001e497          	auipc	s1,0x1e
    80003fc6:	9d648493          	addi	s1,s1,-1578 # 80021998 <log>
    80003fca:	00003597          	auipc	a1,0x3
    80003fce:	71e58593          	addi	a1,a1,1822 # 800076e8 <userret+0x658>
    80003fd2:	8526                	mv	a0,s1
    80003fd4:	ffffd097          	auipc	ra,0xffffd
    80003fd8:	9ec080e7          	jalr	-1556(ra) # 800009c0 <initlock>
  log.start = sb->logstart;
    80003fdc:	0149a583          	lw	a1,20(s3)
    80003fe0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003fe2:	0109a783          	lw	a5,16(s3)
    80003fe6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003fe8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003fec:	854a                	mv	a0,s2
    80003fee:	fffff097          	auipc	ra,0xfffff
    80003ff2:	ecc080e7          	jalr	-308(ra) # 80002eba <bread>
  log.lh.n = lh->n;
    80003ff6:	513c                	lw	a5,96(a0)
    80003ff8:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003ffa:	02f05563          	blez	a5,80004024 <initlog+0x74>
    80003ffe:	06450713          	addi	a4,a0,100
    80004002:	0001e697          	auipc	a3,0x1e
    80004006:	9c668693          	addi	a3,a3,-1594 # 800219c8 <log+0x30>
    8000400a:	37fd                	addiw	a5,a5,-1
    8000400c:	1782                	slli	a5,a5,0x20
    8000400e:	9381                	srli	a5,a5,0x20
    80004010:	078a                	slli	a5,a5,0x2
    80004012:	06850613          	addi	a2,a0,104
    80004016:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80004018:	4310                	lw	a2,0(a4)
    8000401a:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000401c:	0711                	addi	a4,a4,4
    8000401e:	0691                	addi	a3,a3,4
    80004020:	fef71ce3          	bne	a4,a5,80004018 <initlog+0x68>
  brelse(buf);
    80004024:	fffff097          	auipc	ra,0xfffff
    80004028:	fc6080e7          	jalr	-58(ra) # 80002fea <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    8000402c:	00000097          	auipc	ra,0x0
    80004030:	ece080e7          	jalr	-306(ra) # 80003efa <install_trans>
  log.lh.n = 0;
    80004034:	0001e797          	auipc	a5,0x1e
    80004038:	9807a823          	sw	zero,-1648(a5) # 800219c4 <log+0x2c>
  write_head(); // clear the log
    8000403c:	00000097          	auipc	ra,0x0
    80004040:	e44080e7          	jalr	-444(ra) # 80003e80 <write_head>
}
    80004044:	70a2                	ld	ra,40(sp)
    80004046:	7402                	ld	s0,32(sp)
    80004048:	64e2                	ld	s1,24(sp)
    8000404a:	6942                	ld	s2,16(sp)
    8000404c:	69a2                	ld	s3,8(sp)
    8000404e:	6145                	addi	sp,sp,48
    80004050:	8082                	ret

0000000080004052 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004052:	1101                	addi	sp,sp,-32
    80004054:	ec06                	sd	ra,24(sp)
    80004056:	e822                	sd	s0,16(sp)
    80004058:	e426                	sd	s1,8(sp)
    8000405a:	e04a                	sd	s2,0(sp)
    8000405c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000405e:	0001e517          	auipc	a0,0x1e
    80004062:	93a50513          	addi	a0,a0,-1734 # 80021998 <log>
    80004066:	ffffd097          	auipc	ra,0xffffd
    8000406a:	a6c080e7          	jalr	-1428(ra) # 80000ad2 <acquire>
  while(1){
    if(log.committing){
    8000406e:	0001e497          	auipc	s1,0x1e
    80004072:	92a48493          	addi	s1,s1,-1750 # 80021998 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004076:	4979                	li	s2,30
    80004078:	a039                	j	80004086 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000407a:	85a6                	mv	a1,s1
    8000407c:	8526                	mv	a0,s1
    8000407e:	ffffe097          	auipc	ra,0xffffe
    80004082:	1e6080e7          	jalr	486(ra) # 80002264 <sleep>
    if(log.committing){
    80004086:	50dc                	lw	a5,36(s1)
    80004088:	fbed                	bnez	a5,8000407a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000408a:	509c                	lw	a5,32(s1)
    8000408c:	0017871b          	addiw	a4,a5,1
    80004090:	0007069b          	sext.w	a3,a4
    80004094:	0027179b          	slliw	a5,a4,0x2
    80004098:	9fb9                	addw	a5,a5,a4
    8000409a:	0017979b          	slliw	a5,a5,0x1
    8000409e:	54d8                	lw	a4,44(s1)
    800040a0:	9fb9                	addw	a5,a5,a4
    800040a2:	00f95963          	bge	s2,a5,800040b4 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800040a6:	85a6                	mv	a1,s1
    800040a8:	8526                	mv	a0,s1
    800040aa:	ffffe097          	auipc	ra,0xffffe
    800040ae:	1ba080e7          	jalr	442(ra) # 80002264 <sleep>
    800040b2:	bfd1                	j	80004086 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800040b4:	0001e517          	auipc	a0,0x1e
    800040b8:	8e450513          	addi	a0,a0,-1820 # 80021998 <log>
    800040bc:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800040be:	ffffd097          	auipc	ra,0xffffd
    800040c2:	a68080e7          	jalr	-1432(ra) # 80000b26 <release>
      break;
    }
  }
}
    800040c6:	60e2                	ld	ra,24(sp)
    800040c8:	6442                	ld	s0,16(sp)
    800040ca:	64a2                	ld	s1,8(sp)
    800040cc:	6902                	ld	s2,0(sp)
    800040ce:	6105                	addi	sp,sp,32
    800040d0:	8082                	ret

00000000800040d2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800040d2:	7139                	addi	sp,sp,-64
    800040d4:	fc06                	sd	ra,56(sp)
    800040d6:	f822                	sd	s0,48(sp)
    800040d8:	f426                	sd	s1,40(sp)
    800040da:	f04a                	sd	s2,32(sp)
    800040dc:	ec4e                	sd	s3,24(sp)
    800040de:	e852                	sd	s4,16(sp)
    800040e0:	e456                	sd	s5,8(sp)
    800040e2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800040e4:	0001e497          	auipc	s1,0x1e
    800040e8:	8b448493          	addi	s1,s1,-1868 # 80021998 <log>
    800040ec:	8526                	mv	a0,s1
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	9e4080e7          	jalr	-1564(ra) # 80000ad2 <acquire>
  log.outstanding -= 1;
    800040f6:	509c                	lw	a5,32(s1)
    800040f8:	37fd                	addiw	a5,a5,-1
    800040fa:	0007891b          	sext.w	s2,a5
    800040fe:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004100:	50dc                	lw	a5,36(s1)
    80004102:	efb9                	bnez	a5,80004160 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004104:	06091663          	bnez	s2,80004170 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80004108:	0001e497          	auipc	s1,0x1e
    8000410c:	89048493          	addi	s1,s1,-1904 # 80021998 <log>
    80004110:	4785                	li	a5,1
    80004112:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004114:	8526                	mv	a0,s1
    80004116:	ffffd097          	auipc	ra,0xffffd
    8000411a:	a10080e7          	jalr	-1520(ra) # 80000b26 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000411e:	54dc                	lw	a5,44(s1)
    80004120:	06f04763          	bgtz	a5,8000418e <end_op+0xbc>
    acquire(&log.lock);
    80004124:	0001e497          	auipc	s1,0x1e
    80004128:	87448493          	addi	s1,s1,-1932 # 80021998 <log>
    8000412c:	8526                	mv	a0,s1
    8000412e:	ffffd097          	auipc	ra,0xffffd
    80004132:	9a4080e7          	jalr	-1628(ra) # 80000ad2 <acquire>
    log.committing = 0;
    80004136:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000413a:	8526                	mv	a0,s1
    8000413c:	ffffe097          	auipc	ra,0xffffe
    80004140:	2ae080e7          	jalr	686(ra) # 800023ea <wakeup>
    release(&log.lock);
    80004144:	8526                	mv	a0,s1
    80004146:	ffffd097          	auipc	ra,0xffffd
    8000414a:	9e0080e7          	jalr	-1568(ra) # 80000b26 <release>
}
    8000414e:	70e2                	ld	ra,56(sp)
    80004150:	7442                	ld	s0,48(sp)
    80004152:	74a2                	ld	s1,40(sp)
    80004154:	7902                	ld	s2,32(sp)
    80004156:	69e2                	ld	s3,24(sp)
    80004158:	6a42                	ld	s4,16(sp)
    8000415a:	6aa2                	ld	s5,8(sp)
    8000415c:	6121                	addi	sp,sp,64
    8000415e:	8082                	ret
    panic("log.committing");
    80004160:	00003517          	auipc	a0,0x3
    80004164:	59050513          	addi	a0,a0,1424 # 800076f0 <userret+0x660>
    80004168:	ffffc097          	auipc	ra,0xffffc
    8000416c:	3e6080e7          	jalr	998(ra) # 8000054e <panic>
    wakeup(&log);
    80004170:	0001e497          	auipc	s1,0x1e
    80004174:	82848493          	addi	s1,s1,-2008 # 80021998 <log>
    80004178:	8526                	mv	a0,s1
    8000417a:	ffffe097          	auipc	ra,0xffffe
    8000417e:	270080e7          	jalr	624(ra) # 800023ea <wakeup>
  release(&log.lock);
    80004182:	8526                	mv	a0,s1
    80004184:	ffffd097          	auipc	ra,0xffffd
    80004188:	9a2080e7          	jalr	-1630(ra) # 80000b26 <release>
  if(do_commit){
    8000418c:	b7c9                	j	8000414e <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000418e:	0001ea97          	auipc	s5,0x1e
    80004192:	83aa8a93          	addi	s5,s5,-1990 # 800219c8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004196:	0001ea17          	auipc	s4,0x1e
    8000419a:	802a0a13          	addi	s4,s4,-2046 # 80021998 <log>
    8000419e:	018a2583          	lw	a1,24(s4)
    800041a2:	012585bb          	addw	a1,a1,s2
    800041a6:	2585                	addiw	a1,a1,1
    800041a8:	028a2503          	lw	a0,40(s4)
    800041ac:	fffff097          	auipc	ra,0xfffff
    800041b0:	d0e080e7          	jalr	-754(ra) # 80002eba <bread>
    800041b4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800041b6:	000aa583          	lw	a1,0(s5)
    800041ba:	028a2503          	lw	a0,40(s4)
    800041be:	fffff097          	auipc	ra,0xfffff
    800041c2:	cfc080e7          	jalr	-772(ra) # 80002eba <bread>
    800041c6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800041c8:	40000613          	li	a2,1024
    800041cc:	06050593          	addi	a1,a0,96
    800041d0:	06048513          	addi	a0,s1,96
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	9fa080e7          	jalr	-1542(ra) # 80000bce <memmove>
    bwrite(to);  // write the log
    800041dc:	8526                	mv	a0,s1
    800041de:	fffff097          	auipc	ra,0xfffff
    800041e2:	dce080e7          	jalr	-562(ra) # 80002fac <bwrite>
    brelse(from);
    800041e6:	854e                	mv	a0,s3
    800041e8:	fffff097          	auipc	ra,0xfffff
    800041ec:	e02080e7          	jalr	-510(ra) # 80002fea <brelse>
    brelse(to);
    800041f0:	8526                	mv	a0,s1
    800041f2:	fffff097          	auipc	ra,0xfffff
    800041f6:	df8080e7          	jalr	-520(ra) # 80002fea <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800041fa:	2905                	addiw	s2,s2,1
    800041fc:	0a91                	addi	s5,s5,4
    800041fe:	02ca2783          	lw	a5,44(s4)
    80004202:	f8f94ee3          	blt	s2,a5,8000419e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004206:	00000097          	auipc	ra,0x0
    8000420a:	c7a080e7          	jalr	-902(ra) # 80003e80 <write_head>
    install_trans(); // Now install writes to home locations
    8000420e:	00000097          	auipc	ra,0x0
    80004212:	cec080e7          	jalr	-788(ra) # 80003efa <install_trans>
    log.lh.n = 0;
    80004216:	0001d797          	auipc	a5,0x1d
    8000421a:	7a07a723          	sw	zero,1966(a5) # 800219c4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000421e:	00000097          	auipc	ra,0x0
    80004222:	c62080e7          	jalr	-926(ra) # 80003e80 <write_head>
    80004226:	bdfd                	j	80004124 <end_op+0x52>

0000000080004228 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004228:	1101                	addi	sp,sp,-32
    8000422a:	ec06                	sd	ra,24(sp)
    8000422c:	e822                	sd	s0,16(sp)
    8000422e:	e426                	sd	s1,8(sp)
    80004230:	e04a                	sd	s2,0(sp)
    80004232:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004234:	0001d717          	auipc	a4,0x1d
    80004238:	79072703          	lw	a4,1936(a4) # 800219c4 <log+0x2c>
    8000423c:	47f5                	li	a5,29
    8000423e:	08e7c063          	blt	a5,a4,800042be <log_write+0x96>
    80004242:	84aa                	mv	s1,a0
    80004244:	0001d797          	auipc	a5,0x1d
    80004248:	7707a783          	lw	a5,1904(a5) # 800219b4 <log+0x1c>
    8000424c:	37fd                	addiw	a5,a5,-1
    8000424e:	06f75863          	bge	a4,a5,800042be <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004252:	0001d797          	auipc	a5,0x1d
    80004256:	7667a783          	lw	a5,1894(a5) # 800219b8 <log+0x20>
    8000425a:	06f05a63          	blez	a5,800042ce <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    8000425e:	0001d917          	auipc	s2,0x1d
    80004262:	73a90913          	addi	s2,s2,1850 # 80021998 <log>
    80004266:	854a                	mv	a0,s2
    80004268:	ffffd097          	auipc	ra,0xffffd
    8000426c:	86a080e7          	jalr	-1942(ra) # 80000ad2 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    80004270:	02c92603          	lw	a2,44(s2)
    80004274:	06c05563          	blez	a2,800042de <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004278:	44cc                	lw	a1,12(s1)
    8000427a:	0001d717          	auipc	a4,0x1d
    8000427e:	74e70713          	addi	a4,a4,1870 # 800219c8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004282:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004284:	4314                	lw	a3,0(a4)
    80004286:	04b68d63          	beq	a3,a1,800042e0 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    8000428a:	2785                	addiw	a5,a5,1
    8000428c:	0711                	addi	a4,a4,4
    8000428e:	fec79be3          	bne	a5,a2,80004284 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004292:	0621                	addi	a2,a2,8
    80004294:	060a                	slli	a2,a2,0x2
    80004296:	0001d797          	auipc	a5,0x1d
    8000429a:	70278793          	addi	a5,a5,1794 # 80021998 <log>
    8000429e:	963e                	add	a2,a2,a5
    800042a0:	44dc                	lw	a5,12(s1)
    800042a2:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800042a4:	8526                	mv	a0,s1
    800042a6:	fffff097          	auipc	ra,0xfffff
    800042aa:	de2080e7          	jalr	-542(ra) # 80003088 <bpin>
    log.lh.n++;
    800042ae:	0001d717          	auipc	a4,0x1d
    800042b2:	6ea70713          	addi	a4,a4,1770 # 80021998 <log>
    800042b6:	575c                	lw	a5,44(a4)
    800042b8:	2785                	addiw	a5,a5,1
    800042ba:	d75c                	sw	a5,44(a4)
    800042bc:	a83d                	j	800042fa <log_write+0xd2>
    panic("too big a transaction");
    800042be:	00003517          	auipc	a0,0x3
    800042c2:	44250513          	addi	a0,a0,1090 # 80007700 <userret+0x670>
    800042c6:	ffffc097          	auipc	ra,0xffffc
    800042ca:	288080e7          	jalr	648(ra) # 8000054e <panic>
    panic("log_write outside of trans");
    800042ce:	00003517          	auipc	a0,0x3
    800042d2:	44a50513          	addi	a0,a0,1098 # 80007718 <userret+0x688>
    800042d6:	ffffc097          	auipc	ra,0xffffc
    800042da:	278080e7          	jalr	632(ra) # 8000054e <panic>
  for (i = 0; i < log.lh.n; i++) {
    800042de:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    800042e0:	00878713          	addi	a4,a5,8
    800042e4:	00271693          	slli	a3,a4,0x2
    800042e8:	0001d717          	auipc	a4,0x1d
    800042ec:	6b070713          	addi	a4,a4,1712 # 80021998 <log>
    800042f0:	9736                	add	a4,a4,a3
    800042f2:	44d4                	lw	a3,12(s1)
    800042f4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800042f6:	faf607e3          	beq	a2,a5,800042a4 <log_write+0x7c>
  }
  release(&log.lock);
    800042fa:	0001d517          	auipc	a0,0x1d
    800042fe:	69e50513          	addi	a0,a0,1694 # 80021998 <log>
    80004302:	ffffd097          	auipc	ra,0xffffd
    80004306:	824080e7          	jalr	-2012(ra) # 80000b26 <release>
}
    8000430a:	60e2                	ld	ra,24(sp)
    8000430c:	6442                	ld	s0,16(sp)
    8000430e:	64a2                	ld	s1,8(sp)
    80004310:	6902                	ld	s2,0(sp)
    80004312:	6105                	addi	sp,sp,32
    80004314:	8082                	ret

0000000080004316 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004316:	1101                	addi	sp,sp,-32
    80004318:	ec06                	sd	ra,24(sp)
    8000431a:	e822                	sd	s0,16(sp)
    8000431c:	e426                	sd	s1,8(sp)
    8000431e:	e04a                	sd	s2,0(sp)
    80004320:	1000                	addi	s0,sp,32
    80004322:	84aa                	mv	s1,a0
    80004324:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004326:	00003597          	auipc	a1,0x3
    8000432a:	41258593          	addi	a1,a1,1042 # 80007738 <userret+0x6a8>
    8000432e:	0521                	addi	a0,a0,8
    80004330:	ffffc097          	auipc	ra,0xffffc
    80004334:	690080e7          	jalr	1680(ra) # 800009c0 <initlock>
  lk->name = name;
    80004338:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000433c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004340:	0204a423          	sw	zero,40(s1)
}
    80004344:	60e2                	ld	ra,24(sp)
    80004346:	6442                	ld	s0,16(sp)
    80004348:	64a2                	ld	s1,8(sp)
    8000434a:	6902                	ld	s2,0(sp)
    8000434c:	6105                	addi	sp,sp,32
    8000434e:	8082                	ret

0000000080004350 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004350:	1101                	addi	sp,sp,-32
    80004352:	ec06                	sd	ra,24(sp)
    80004354:	e822                	sd	s0,16(sp)
    80004356:	e426                	sd	s1,8(sp)
    80004358:	e04a                	sd	s2,0(sp)
    8000435a:	1000                	addi	s0,sp,32
    8000435c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000435e:	00850913          	addi	s2,a0,8
    80004362:	854a                	mv	a0,s2
    80004364:	ffffc097          	auipc	ra,0xffffc
    80004368:	76e080e7          	jalr	1902(ra) # 80000ad2 <acquire>
  while (lk->locked) {
    8000436c:	409c                	lw	a5,0(s1)
    8000436e:	cb89                	beqz	a5,80004380 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004370:	85ca                	mv	a1,s2
    80004372:	8526                	mv	a0,s1
    80004374:	ffffe097          	auipc	ra,0xffffe
    80004378:	ef0080e7          	jalr	-272(ra) # 80002264 <sleep>
  while (lk->locked) {
    8000437c:	409c                	lw	a5,0(s1)
    8000437e:	fbed                	bnez	a5,80004370 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004380:	4785                	li	a5,1
    80004382:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004384:	ffffd097          	auipc	ra,0xffffd
    80004388:	73a080e7          	jalr	1850(ra) # 80001abe <myproc>
    8000438c:	5d1c                	lw	a5,56(a0)
    8000438e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004390:	854a                	mv	a0,s2
    80004392:	ffffc097          	auipc	ra,0xffffc
    80004396:	794080e7          	jalr	1940(ra) # 80000b26 <release>
}
    8000439a:	60e2                	ld	ra,24(sp)
    8000439c:	6442                	ld	s0,16(sp)
    8000439e:	64a2                	ld	s1,8(sp)
    800043a0:	6902                	ld	s2,0(sp)
    800043a2:	6105                	addi	sp,sp,32
    800043a4:	8082                	ret

00000000800043a6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800043a6:	1101                	addi	sp,sp,-32
    800043a8:	ec06                	sd	ra,24(sp)
    800043aa:	e822                	sd	s0,16(sp)
    800043ac:	e426                	sd	s1,8(sp)
    800043ae:	e04a                	sd	s2,0(sp)
    800043b0:	1000                	addi	s0,sp,32
    800043b2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043b4:	00850913          	addi	s2,a0,8
    800043b8:	854a                	mv	a0,s2
    800043ba:	ffffc097          	auipc	ra,0xffffc
    800043be:	718080e7          	jalr	1816(ra) # 80000ad2 <acquire>
  lk->locked = 0;
    800043c2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043c6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800043ca:	8526                	mv	a0,s1
    800043cc:	ffffe097          	auipc	ra,0xffffe
    800043d0:	01e080e7          	jalr	30(ra) # 800023ea <wakeup>
  release(&lk->lk);
    800043d4:	854a                	mv	a0,s2
    800043d6:	ffffc097          	auipc	ra,0xffffc
    800043da:	750080e7          	jalr	1872(ra) # 80000b26 <release>
}
    800043de:	60e2                	ld	ra,24(sp)
    800043e0:	6442                	ld	s0,16(sp)
    800043e2:	64a2                	ld	s1,8(sp)
    800043e4:	6902                	ld	s2,0(sp)
    800043e6:	6105                	addi	sp,sp,32
    800043e8:	8082                	ret

00000000800043ea <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800043ea:	7179                	addi	sp,sp,-48
    800043ec:	f406                	sd	ra,40(sp)
    800043ee:	f022                	sd	s0,32(sp)
    800043f0:	ec26                	sd	s1,24(sp)
    800043f2:	e84a                	sd	s2,16(sp)
    800043f4:	e44e                	sd	s3,8(sp)
    800043f6:	1800                	addi	s0,sp,48
    800043f8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800043fa:	00850913          	addi	s2,a0,8
    800043fe:	854a                	mv	a0,s2
    80004400:	ffffc097          	auipc	ra,0xffffc
    80004404:	6d2080e7          	jalr	1746(ra) # 80000ad2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004408:	409c                	lw	a5,0(s1)
    8000440a:	ef99                	bnez	a5,80004428 <holdingsleep+0x3e>
    8000440c:	4481                	li	s1,0
  release(&lk->lk);
    8000440e:	854a                	mv	a0,s2
    80004410:	ffffc097          	auipc	ra,0xffffc
    80004414:	716080e7          	jalr	1814(ra) # 80000b26 <release>
  return r;
}
    80004418:	8526                	mv	a0,s1
    8000441a:	70a2                	ld	ra,40(sp)
    8000441c:	7402                	ld	s0,32(sp)
    8000441e:	64e2                	ld	s1,24(sp)
    80004420:	6942                	ld	s2,16(sp)
    80004422:	69a2                	ld	s3,8(sp)
    80004424:	6145                	addi	sp,sp,48
    80004426:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004428:	0284a983          	lw	s3,40(s1)
    8000442c:	ffffd097          	auipc	ra,0xffffd
    80004430:	692080e7          	jalr	1682(ra) # 80001abe <myproc>
    80004434:	5d04                	lw	s1,56(a0)
    80004436:	413484b3          	sub	s1,s1,s3
    8000443a:	0014b493          	seqz	s1,s1
    8000443e:	bfc1                	j	8000440e <holdingsleep+0x24>

0000000080004440 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004440:	1141                	addi	sp,sp,-16
    80004442:	e406                	sd	ra,8(sp)
    80004444:	e022                	sd	s0,0(sp)
    80004446:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004448:	00003597          	auipc	a1,0x3
    8000444c:	30058593          	addi	a1,a1,768 # 80007748 <userret+0x6b8>
    80004450:	0001d517          	auipc	a0,0x1d
    80004454:	69050513          	addi	a0,a0,1680 # 80021ae0 <ftable>
    80004458:	ffffc097          	auipc	ra,0xffffc
    8000445c:	568080e7          	jalr	1384(ra) # 800009c0 <initlock>
}
    80004460:	60a2                	ld	ra,8(sp)
    80004462:	6402                	ld	s0,0(sp)
    80004464:	0141                	addi	sp,sp,16
    80004466:	8082                	ret

0000000080004468 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004468:	1101                	addi	sp,sp,-32
    8000446a:	ec06                	sd	ra,24(sp)
    8000446c:	e822                	sd	s0,16(sp)
    8000446e:	e426                	sd	s1,8(sp)
    80004470:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004472:	0001d517          	auipc	a0,0x1d
    80004476:	66e50513          	addi	a0,a0,1646 # 80021ae0 <ftable>
    8000447a:	ffffc097          	auipc	ra,0xffffc
    8000447e:	658080e7          	jalr	1624(ra) # 80000ad2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004482:	0001d497          	auipc	s1,0x1d
    80004486:	67648493          	addi	s1,s1,1654 # 80021af8 <ftable+0x18>
    8000448a:	0001e717          	auipc	a4,0x1e
    8000448e:	60e70713          	addi	a4,a4,1550 # 80022a98 <ftable+0xfb8>
    if(f->ref == 0){
    80004492:	40dc                	lw	a5,4(s1)
    80004494:	cf99                	beqz	a5,800044b2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004496:	02848493          	addi	s1,s1,40
    8000449a:	fee49ce3          	bne	s1,a4,80004492 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000449e:	0001d517          	auipc	a0,0x1d
    800044a2:	64250513          	addi	a0,a0,1602 # 80021ae0 <ftable>
    800044a6:	ffffc097          	auipc	ra,0xffffc
    800044aa:	680080e7          	jalr	1664(ra) # 80000b26 <release>
  return 0;
    800044ae:	4481                	li	s1,0
    800044b0:	a819                	j	800044c6 <filealloc+0x5e>
      f->ref = 1;
    800044b2:	4785                	li	a5,1
    800044b4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800044b6:	0001d517          	auipc	a0,0x1d
    800044ba:	62a50513          	addi	a0,a0,1578 # 80021ae0 <ftable>
    800044be:	ffffc097          	auipc	ra,0xffffc
    800044c2:	668080e7          	jalr	1640(ra) # 80000b26 <release>
}
    800044c6:	8526                	mv	a0,s1
    800044c8:	60e2                	ld	ra,24(sp)
    800044ca:	6442                	ld	s0,16(sp)
    800044cc:	64a2                	ld	s1,8(sp)
    800044ce:	6105                	addi	sp,sp,32
    800044d0:	8082                	ret

00000000800044d2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800044d2:	1101                	addi	sp,sp,-32
    800044d4:	ec06                	sd	ra,24(sp)
    800044d6:	e822                	sd	s0,16(sp)
    800044d8:	e426                	sd	s1,8(sp)
    800044da:	1000                	addi	s0,sp,32
    800044dc:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800044de:	0001d517          	auipc	a0,0x1d
    800044e2:	60250513          	addi	a0,a0,1538 # 80021ae0 <ftable>
    800044e6:	ffffc097          	auipc	ra,0xffffc
    800044ea:	5ec080e7          	jalr	1516(ra) # 80000ad2 <acquire>
  if(f->ref < 1)
    800044ee:	40dc                	lw	a5,4(s1)
    800044f0:	02f05263          	blez	a5,80004514 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800044f4:	2785                	addiw	a5,a5,1
    800044f6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800044f8:	0001d517          	auipc	a0,0x1d
    800044fc:	5e850513          	addi	a0,a0,1512 # 80021ae0 <ftable>
    80004500:	ffffc097          	auipc	ra,0xffffc
    80004504:	626080e7          	jalr	1574(ra) # 80000b26 <release>
  return f;
}
    80004508:	8526                	mv	a0,s1
    8000450a:	60e2                	ld	ra,24(sp)
    8000450c:	6442                	ld	s0,16(sp)
    8000450e:	64a2                	ld	s1,8(sp)
    80004510:	6105                	addi	sp,sp,32
    80004512:	8082                	ret
    panic("filedup");
    80004514:	00003517          	auipc	a0,0x3
    80004518:	23c50513          	addi	a0,a0,572 # 80007750 <userret+0x6c0>
    8000451c:	ffffc097          	auipc	ra,0xffffc
    80004520:	032080e7          	jalr	50(ra) # 8000054e <panic>

0000000080004524 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004524:	7139                	addi	sp,sp,-64
    80004526:	fc06                	sd	ra,56(sp)
    80004528:	f822                	sd	s0,48(sp)
    8000452a:	f426                	sd	s1,40(sp)
    8000452c:	f04a                	sd	s2,32(sp)
    8000452e:	ec4e                	sd	s3,24(sp)
    80004530:	e852                	sd	s4,16(sp)
    80004532:	e456                	sd	s5,8(sp)
    80004534:	0080                	addi	s0,sp,64
    80004536:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004538:	0001d517          	auipc	a0,0x1d
    8000453c:	5a850513          	addi	a0,a0,1448 # 80021ae0 <ftable>
    80004540:	ffffc097          	auipc	ra,0xffffc
    80004544:	592080e7          	jalr	1426(ra) # 80000ad2 <acquire>
  if(f->ref < 1)
    80004548:	40dc                	lw	a5,4(s1)
    8000454a:	06f05163          	blez	a5,800045ac <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000454e:	37fd                	addiw	a5,a5,-1
    80004550:	0007871b          	sext.w	a4,a5
    80004554:	c0dc                	sw	a5,4(s1)
    80004556:	06e04363          	bgtz	a4,800045bc <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000455a:	0004a903          	lw	s2,0(s1)
    8000455e:	0094ca83          	lbu	s5,9(s1)
    80004562:	0104ba03          	ld	s4,16(s1)
    80004566:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000456a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000456e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004572:	0001d517          	auipc	a0,0x1d
    80004576:	56e50513          	addi	a0,a0,1390 # 80021ae0 <ftable>
    8000457a:	ffffc097          	auipc	ra,0xffffc
    8000457e:	5ac080e7          	jalr	1452(ra) # 80000b26 <release>

  if(ff.type == FD_PIPE){
    80004582:	4785                	li	a5,1
    80004584:	04f90d63          	beq	s2,a5,800045de <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004588:	3979                	addiw	s2,s2,-2
    8000458a:	4785                	li	a5,1
    8000458c:	0527e063          	bltu	a5,s2,800045cc <fileclose+0xa8>
    begin_op();
    80004590:	00000097          	auipc	ra,0x0
    80004594:	ac2080e7          	jalr	-1342(ra) # 80004052 <begin_op>
    iput(ff.ip);
    80004598:	854e                	mv	a0,s3
    8000459a:	fffff097          	auipc	ra,0xfffff
    8000459e:	230080e7          	jalr	560(ra) # 800037ca <iput>
    end_op();
    800045a2:	00000097          	auipc	ra,0x0
    800045a6:	b30080e7          	jalr	-1232(ra) # 800040d2 <end_op>
    800045aa:	a00d                	j	800045cc <fileclose+0xa8>
    panic("fileclose");
    800045ac:	00003517          	auipc	a0,0x3
    800045b0:	1ac50513          	addi	a0,a0,428 # 80007758 <userret+0x6c8>
    800045b4:	ffffc097          	auipc	ra,0xffffc
    800045b8:	f9a080e7          	jalr	-102(ra) # 8000054e <panic>
    release(&ftable.lock);
    800045bc:	0001d517          	auipc	a0,0x1d
    800045c0:	52450513          	addi	a0,a0,1316 # 80021ae0 <ftable>
    800045c4:	ffffc097          	auipc	ra,0xffffc
    800045c8:	562080e7          	jalr	1378(ra) # 80000b26 <release>
  }
}
    800045cc:	70e2                	ld	ra,56(sp)
    800045ce:	7442                	ld	s0,48(sp)
    800045d0:	74a2                	ld	s1,40(sp)
    800045d2:	7902                	ld	s2,32(sp)
    800045d4:	69e2                	ld	s3,24(sp)
    800045d6:	6a42                	ld	s4,16(sp)
    800045d8:	6aa2                	ld	s5,8(sp)
    800045da:	6121                	addi	sp,sp,64
    800045dc:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800045de:	85d6                	mv	a1,s5
    800045e0:	8552                	mv	a0,s4
    800045e2:	00000097          	auipc	ra,0x0
    800045e6:	372080e7          	jalr	882(ra) # 80004954 <pipeclose>
    800045ea:	b7cd                	j	800045cc <fileclose+0xa8>

00000000800045ec <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800045ec:	715d                	addi	sp,sp,-80
    800045ee:	e486                	sd	ra,72(sp)
    800045f0:	e0a2                	sd	s0,64(sp)
    800045f2:	fc26                	sd	s1,56(sp)
    800045f4:	f84a                	sd	s2,48(sp)
    800045f6:	f44e                	sd	s3,40(sp)
    800045f8:	0880                	addi	s0,sp,80
    800045fa:	84aa                	mv	s1,a0
    800045fc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800045fe:	ffffd097          	auipc	ra,0xffffd
    80004602:	4c0080e7          	jalr	1216(ra) # 80001abe <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004606:	409c                	lw	a5,0(s1)
    80004608:	37f9                	addiw	a5,a5,-2
    8000460a:	4705                	li	a4,1
    8000460c:	04f76763          	bltu	a4,a5,8000465a <filestat+0x6e>
    80004610:	892a                	mv	s2,a0
    ilock(f->ip);
    80004612:	6c88                	ld	a0,24(s1)
    80004614:	fffff097          	auipc	ra,0xfffff
    80004618:	0a8080e7          	jalr	168(ra) # 800036bc <ilock>
    stati(f->ip, &st);
    8000461c:	fb840593          	addi	a1,s0,-72
    80004620:	6c88                	ld	a0,24(s1)
    80004622:	fffff097          	auipc	ra,0xfffff
    80004626:	300080e7          	jalr	768(ra) # 80003922 <stati>
    iunlock(f->ip);
    8000462a:	6c88                	ld	a0,24(s1)
    8000462c:	fffff097          	auipc	ra,0xfffff
    80004630:	152080e7          	jalr	338(ra) # 8000377e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004634:	46e1                	li	a3,24
    80004636:	fb840613          	addi	a2,s0,-72
    8000463a:	85ce                	mv	a1,s3
    8000463c:	05093503          	ld	a0,80(s2)
    80004640:	ffffd097          	auipc	ra,0xffffd
    80004644:	ef8080e7          	jalr	-264(ra) # 80001538 <copyout>
    80004648:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000464c:	60a6                	ld	ra,72(sp)
    8000464e:	6406                	ld	s0,64(sp)
    80004650:	74e2                	ld	s1,56(sp)
    80004652:	7942                	ld	s2,48(sp)
    80004654:	79a2                	ld	s3,40(sp)
    80004656:	6161                	addi	sp,sp,80
    80004658:	8082                	ret
  return -1;
    8000465a:	557d                	li	a0,-1
    8000465c:	bfc5                	j	8000464c <filestat+0x60>

000000008000465e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000465e:	7179                	addi	sp,sp,-48
    80004660:	f406                	sd	ra,40(sp)
    80004662:	f022                	sd	s0,32(sp)
    80004664:	ec26                	sd	s1,24(sp)
    80004666:	e84a                	sd	s2,16(sp)
    80004668:	e44e                	sd	s3,8(sp)
    8000466a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000466c:	00854783          	lbu	a5,8(a0)
    80004670:	c3d5                	beqz	a5,80004714 <fileread+0xb6>
    80004672:	84aa                	mv	s1,a0
    80004674:	89ae                	mv	s3,a1
    80004676:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004678:	411c                	lw	a5,0(a0)
    8000467a:	4705                	li	a4,1
    8000467c:	04e78963          	beq	a5,a4,800046ce <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004680:	470d                	li	a4,3
    80004682:	04e78d63          	beq	a5,a4,800046dc <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004686:	4709                	li	a4,2
    80004688:	06e79e63          	bne	a5,a4,80004704 <fileread+0xa6>
    ilock(f->ip);
    8000468c:	6d08                	ld	a0,24(a0)
    8000468e:	fffff097          	auipc	ra,0xfffff
    80004692:	02e080e7          	jalr	46(ra) # 800036bc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004696:	874a                	mv	a4,s2
    80004698:	5094                	lw	a3,32(s1)
    8000469a:	864e                	mv	a2,s3
    8000469c:	4585                	li	a1,1
    8000469e:	6c88                	ld	a0,24(s1)
    800046a0:	fffff097          	auipc	ra,0xfffff
    800046a4:	2ac080e7          	jalr	684(ra) # 8000394c <readi>
    800046a8:	892a                	mv	s2,a0
    800046aa:	00a05563          	blez	a0,800046b4 <fileread+0x56>
      f->off += r;
    800046ae:	509c                	lw	a5,32(s1)
    800046b0:	9fa9                	addw	a5,a5,a0
    800046b2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800046b4:	6c88                	ld	a0,24(s1)
    800046b6:	fffff097          	auipc	ra,0xfffff
    800046ba:	0c8080e7          	jalr	200(ra) # 8000377e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800046be:	854a                	mv	a0,s2
    800046c0:	70a2                	ld	ra,40(sp)
    800046c2:	7402                	ld	s0,32(sp)
    800046c4:	64e2                	ld	s1,24(sp)
    800046c6:	6942                	ld	s2,16(sp)
    800046c8:	69a2                	ld	s3,8(sp)
    800046ca:	6145                	addi	sp,sp,48
    800046cc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800046ce:	6908                	ld	a0,16(a0)
    800046d0:	00000097          	auipc	ra,0x0
    800046d4:	408080e7          	jalr	1032(ra) # 80004ad8 <piperead>
    800046d8:	892a                	mv	s2,a0
    800046da:	b7d5                	j	800046be <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800046dc:	02451783          	lh	a5,36(a0)
    800046e0:	03079693          	slli	a3,a5,0x30
    800046e4:	92c1                	srli	a3,a3,0x30
    800046e6:	4725                	li	a4,9
    800046e8:	02d76863          	bltu	a4,a3,80004718 <fileread+0xba>
    800046ec:	0792                	slli	a5,a5,0x4
    800046ee:	0001d717          	auipc	a4,0x1d
    800046f2:	35270713          	addi	a4,a4,850 # 80021a40 <devsw>
    800046f6:	97ba                	add	a5,a5,a4
    800046f8:	639c                	ld	a5,0(a5)
    800046fa:	c38d                	beqz	a5,8000471c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800046fc:	4505                	li	a0,1
    800046fe:	9782                	jalr	a5
    80004700:	892a                	mv	s2,a0
    80004702:	bf75                	j	800046be <fileread+0x60>
    panic("fileread");
    80004704:	00003517          	auipc	a0,0x3
    80004708:	06450513          	addi	a0,a0,100 # 80007768 <userret+0x6d8>
    8000470c:	ffffc097          	auipc	ra,0xffffc
    80004710:	e42080e7          	jalr	-446(ra) # 8000054e <panic>
    return -1;
    80004714:	597d                	li	s2,-1
    80004716:	b765                	j	800046be <fileread+0x60>
      return -1;
    80004718:	597d                	li	s2,-1
    8000471a:	b755                	j	800046be <fileread+0x60>
    8000471c:	597d                	li	s2,-1
    8000471e:	b745                	j	800046be <fileread+0x60>

0000000080004720 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004720:	00954783          	lbu	a5,9(a0)
    80004724:	14078563          	beqz	a5,8000486e <filewrite+0x14e>
{
    80004728:	715d                	addi	sp,sp,-80
    8000472a:	e486                	sd	ra,72(sp)
    8000472c:	e0a2                	sd	s0,64(sp)
    8000472e:	fc26                	sd	s1,56(sp)
    80004730:	f84a                	sd	s2,48(sp)
    80004732:	f44e                	sd	s3,40(sp)
    80004734:	f052                	sd	s4,32(sp)
    80004736:	ec56                	sd	s5,24(sp)
    80004738:	e85a                	sd	s6,16(sp)
    8000473a:	e45e                	sd	s7,8(sp)
    8000473c:	e062                	sd	s8,0(sp)
    8000473e:	0880                	addi	s0,sp,80
    80004740:	892a                	mv	s2,a0
    80004742:	8aae                	mv	s5,a1
    80004744:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004746:	411c                	lw	a5,0(a0)
    80004748:	4705                	li	a4,1
    8000474a:	02e78263          	beq	a5,a4,8000476e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000474e:	470d                	li	a4,3
    80004750:	02e78563          	beq	a5,a4,8000477a <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004754:	4709                	li	a4,2
    80004756:	10e79463          	bne	a5,a4,8000485e <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000475a:	0ec05e63          	blez	a2,80004856 <filewrite+0x136>
    int i = 0;
    8000475e:	4981                	li	s3,0
    80004760:	6b05                	lui	s6,0x1
    80004762:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004766:	6b85                	lui	s7,0x1
    80004768:	c00b8b9b          	addiw	s7,s7,-1024
    8000476c:	a851                	j	80004800 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    8000476e:	6908                	ld	a0,16(a0)
    80004770:	00000097          	auipc	ra,0x0
    80004774:	254080e7          	jalr	596(ra) # 800049c4 <pipewrite>
    80004778:	a85d                	j	8000482e <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000477a:	02451783          	lh	a5,36(a0)
    8000477e:	03079693          	slli	a3,a5,0x30
    80004782:	92c1                	srli	a3,a3,0x30
    80004784:	4725                	li	a4,9
    80004786:	0ed76663          	bltu	a4,a3,80004872 <filewrite+0x152>
    8000478a:	0792                	slli	a5,a5,0x4
    8000478c:	0001d717          	auipc	a4,0x1d
    80004790:	2b470713          	addi	a4,a4,692 # 80021a40 <devsw>
    80004794:	97ba                	add	a5,a5,a4
    80004796:	679c                	ld	a5,8(a5)
    80004798:	cff9                	beqz	a5,80004876 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    8000479a:	4505                	li	a0,1
    8000479c:	9782                	jalr	a5
    8000479e:	a841                	j	8000482e <filewrite+0x10e>
    800047a0:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    800047a4:	00000097          	auipc	ra,0x0
    800047a8:	8ae080e7          	jalr	-1874(ra) # 80004052 <begin_op>
      ilock(f->ip);
    800047ac:	01893503          	ld	a0,24(s2)
    800047b0:	fffff097          	auipc	ra,0xfffff
    800047b4:	f0c080e7          	jalr	-244(ra) # 800036bc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800047b8:	8762                	mv	a4,s8
    800047ba:	02092683          	lw	a3,32(s2)
    800047be:	01598633          	add	a2,s3,s5
    800047c2:	4585                	li	a1,1
    800047c4:	01893503          	ld	a0,24(s2)
    800047c8:	fffff097          	auipc	ra,0xfffff
    800047cc:	278080e7          	jalr	632(ra) # 80003a40 <writei>
    800047d0:	84aa                	mv	s1,a0
    800047d2:	02a05f63          	blez	a0,80004810 <filewrite+0xf0>
        f->off += r;
    800047d6:	02092783          	lw	a5,32(s2)
    800047da:	9fa9                	addw	a5,a5,a0
    800047dc:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800047e0:	01893503          	ld	a0,24(s2)
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	f9a080e7          	jalr	-102(ra) # 8000377e <iunlock>
      end_op();
    800047ec:	00000097          	auipc	ra,0x0
    800047f0:	8e6080e7          	jalr	-1818(ra) # 800040d2 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    800047f4:	049c1963          	bne	s8,s1,80004846 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    800047f8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800047fc:	0349d663          	bge	s3,s4,80004828 <filewrite+0x108>
      int n1 = n - i;
    80004800:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004804:	84be                	mv	s1,a5
    80004806:	2781                	sext.w	a5,a5
    80004808:	f8fb5ce3          	bge	s6,a5,800047a0 <filewrite+0x80>
    8000480c:	84de                	mv	s1,s7
    8000480e:	bf49                	j	800047a0 <filewrite+0x80>
      iunlock(f->ip);
    80004810:	01893503          	ld	a0,24(s2)
    80004814:	fffff097          	auipc	ra,0xfffff
    80004818:	f6a080e7          	jalr	-150(ra) # 8000377e <iunlock>
      end_op();
    8000481c:	00000097          	auipc	ra,0x0
    80004820:	8b6080e7          	jalr	-1866(ra) # 800040d2 <end_op>
      if(r < 0)
    80004824:	fc04d8e3          	bgez	s1,800047f4 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004828:	8552                	mv	a0,s4
    8000482a:	033a1863          	bne	s4,s3,8000485a <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000482e:	60a6                	ld	ra,72(sp)
    80004830:	6406                	ld	s0,64(sp)
    80004832:	74e2                	ld	s1,56(sp)
    80004834:	7942                	ld	s2,48(sp)
    80004836:	79a2                	ld	s3,40(sp)
    80004838:	7a02                	ld	s4,32(sp)
    8000483a:	6ae2                	ld	s5,24(sp)
    8000483c:	6b42                	ld	s6,16(sp)
    8000483e:	6ba2                	ld	s7,8(sp)
    80004840:	6c02                	ld	s8,0(sp)
    80004842:	6161                	addi	sp,sp,80
    80004844:	8082                	ret
        panic("short filewrite");
    80004846:	00003517          	auipc	a0,0x3
    8000484a:	f3250513          	addi	a0,a0,-206 # 80007778 <userret+0x6e8>
    8000484e:	ffffc097          	auipc	ra,0xffffc
    80004852:	d00080e7          	jalr	-768(ra) # 8000054e <panic>
    int i = 0;
    80004856:	4981                	li	s3,0
    80004858:	bfc1                	j	80004828 <filewrite+0x108>
    ret = (i == n ? n : -1);
    8000485a:	557d                	li	a0,-1
    8000485c:	bfc9                	j	8000482e <filewrite+0x10e>
    panic("filewrite");
    8000485e:	00003517          	auipc	a0,0x3
    80004862:	f2a50513          	addi	a0,a0,-214 # 80007788 <userret+0x6f8>
    80004866:	ffffc097          	auipc	ra,0xffffc
    8000486a:	ce8080e7          	jalr	-792(ra) # 8000054e <panic>
    return -1;
    8000486e:	557d                	li	a0,-1
}
    80004870:	8082                	ret
      return -1;
    80004872:	557d                	li	a0,-1
    80004874:	bf6d                	j	8000482e <filewrite+0x10e>
    80004876:	557d                	li	a0,-1
    80004878:	bf5d                	j	8000482e <filewrite+0x10e>

000000008000487a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000487a:	7179                	addi	sp,sp,-48
    8000487c:	f406                	sd	ra,40(sp)
    8000487e:	f022                	sd	s0,32(sp)
    80004880:	ec26                	sd	s1,24(sp)
    80004882:	e84a                	sd	s2,16(sp)
    80004884:	e44e                	sd	s3,8(sp)
    80004886:	e052                	sd	s4,0(sp)
    80004888:	1800                	addi	s0,sp,48
    8000488a:	84aa                	mv	s1,a0
    8000488c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000488e:	0005b023          	sd	zero,0(a1)
    80004892:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004896:	00000097          	auipc	ra,0x0
    8000489a:	bd2080e7          	jalr	-1070(ra) # 80004468 <filealloc>
    8000489e:	e088                	sd	a0,0(s1)
    800048a0:	c551                	beqz	a0,8000492c <pipealloc+0xb2>
    800048a2:	00000097          	auipc	ra,0x0
    800048a6:	bc6080e7          	jalr	-1082(ra) # 80004468 <filealloc>
    800048aa:	00aa3023          	sd	a0,0(s4)
    800048ae:	c92d                	beqz	a0,80004920 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800048b0:	ffffc097          	auipc	ra,0xffffc
    800048b4:	0b0080e7          	jalr	176(ra) # 80000960 <kalloc>
    800048b8:	892a                	mv	s2,a0
    800048ba:	c125                	beqz	a0,8000491a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800048bc:	4985                	li	s3,1
    800048be:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800048c2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800048c6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800048ca:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800048ce:	00003597          	auipc	a1,0x3
    800048d2:	eca58593          	addi	a1,a1,-310 # 80007798 <userret+0x708>
    800048d6:	ffffc097          	auipc	ra,0xffffc
    800048da:	0ea080e7          	jalr	234(ra) # 800009c0 <initlock>
  (*f0)->type = FD_PIPE;
    800048de:	609c                	ld	a5,0(s1)
    800048e0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800048e4:	609c                	ld	a5,0(s1)
    800048e6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800048ea:	609c                	ld	a5,0(s1)
    800048ec:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800048f0:	609c                	ld	a5,0(s1)
    800048f2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800048f6:	000a3783          	ld	a5,0(s4)
    800048fa:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800048fe:	000a3783          	ld	a5,0(s4)
    80004902:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004906:	000a3783          	ld	a5,0(s4)
    8000490a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000490e:	000a3783          	ld	a5,0(s4)
    80004912:	0127b823          	sd	s2,16(a5)
  return 0;
    80004916:	4501                	li	a0,0
    80004918:	a025                	j	80004940 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000491a:	6088                	ld	a0,0(s1)
    8000491c:	e501                	bnez	a0,80004924 <pipealloc+0xaa>
    8000491e:	a039                	j	8000492c <pipealloc+0xb2>
    80004920:	6088                	ld	a0,0(s1)
    80004922:	c51d                	beqz	a0,80004950 <pipealloc+0xd6>
    fileclose(*f0);
    80004924:	00000097          	auipc	ra,0x0
    80004928:	c00080e7          	jalr	-1024(ra) # 80004524 <fileclose>
  if(*f1)
    8000492c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004930:	557d                	li	a0,-1
  if(*f1)
    80004932:	c799                	beqz	a5,80004940 <pipealloc+0xc6>
    fileclose(*f1);
    80004934:	853e                	mv	a0,a5
    80004936:	00000097          	auipc	ra,0x0
    8000493a:	bee080e7          	jalr	-1042(ra) # 80004524 <fileclose>
  return -1;
    8000493e:	557d                	li	a0,-1
}
    80004940:	70a2                	ld	ra,40(sp)
    80004942:	7402                	ld	s0,32(sp)
    80004944:	64e2                	ld	s1,24(sp)
    80004946:	6942                	ld	s2,16(sp)
    80004948:	69a2                	ld	s3,8(sp)
    8000494a:	6a02                	ld	s4,0(sp)
    8000494c:	6145                	addi	sp,sp,48
    8000494e:	8082                	ret
  return -1;
    80004950:	557d                	li	a0,-1
    80004952:	b7fd                	j	80004940 <pipealloc+0xc6>

0000000080004954 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004954:	1101                	addi	sp,sp,-32
    80004956:	ec06                	sd	ra,24(sp)
    80004958:	e822                	sd	s0,16(sp)
    8000495a:	e426                	sd	s1,8(sp)
    8000495c:	e04a                	sd	s2,0(sp)
    8000495e:	1000                	addi	s0,sp,32
    80004960:	84aa                	mv	s1,a0
    80004962:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004964:	ffffc097          	auipc	ra,0xffffc
    80004968:	16e080e7          	jalr	366(ra) # 80000ad2 <acquire>
  if(writable){
    8000496c:	02090d63          	beqz	s2,800049a6 <pipeclose+0x52>
    pi->writeopen = 0;
    80004970:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004974:	21848513          	addi	a0,s1,536
    80004978:	ffffe097          	auipc	ra,0xffffe
    8000497c:	a72080e7          	jalr	-1422(ra) # 800023ea <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004980:	2204b783          	ld	a5,544(s1)
    80004984:	eb95                	bnez	a5,800049b8 <pipeclose+0x64>
    release(&pi->lock);
    80004986:	8526                	mv	a0,s1
    80004988:	ffffc097          	auipc	ra,0xffffc
    8000498c:	19e080e7          	jalr	414(ra) # 80000b26 <release>
    kfree((char*)pi);
    80004990:	8526                	mv	a0,s1
    80004992:	ffffc097          	auipc	ra,0xffffc
    80004996:	ed2080e7          	jalr	-302(ra) # 80000864 <kfree>
  } else
    release(&pi->lock);
}
    8000499a:	60e2                	ld	ra,24(sp)
    8000499c:	6442                	ld	s0,16(sp)
    8000499e:	64a2                	ld	s1,8(sp)
    800049a0:	6902                	ld	s2,0(sp)
    800049a2:	6105                	addi	sp,sp,32
    800049a4:	8082                	ret
    pi->readopen = 0;
    800049a6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800049aa:	21c48513          	addi	a0,s1,540
    800049ae:	ffffe097          	auipc	ra,0xffffe
    800049b2:	a3c080e7          	jalr	-1476(ra) # 800023ea <wakeup>
    800049b6:	b7e9                	j	80004980 <pipeclose+0x2c>
    release(&pi->lock);
    800049b8:	8526                	mv	a0,s1
    800049ba:	ffffc097          	auipc	ra,0xffffc
    800049be:	16c080e7          	jalr	364(ra) # 80000b26 <release>
}
    800049c2:	bfe1                	j	8000499a <pipeclose+0x46>

00000000800049c4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800049c4:	7159                	addi	sp,sp,-112
    800049c6:	f486                	sd	ra,104(sp)
    800049c8:	f0a2                	sd	s0,96(sp)
    800049ca:	eca6                	sd	s1,88(sp)
    800049cc:	e8ca                	sd	s2,80(sp)
    800049ce:	e4ce                	sd	s3,72(sp)
    800049d0:	e0d2                	sd	s4,64(sp)
    800049d2:	fc56                	sd	s5,56(sp)
    800049d4:	f85a                	sd	s6,48(sp)
    800049d6:	f45e                	sd	s7,40(sp)
    800049d8:	f062                	sd	s8,32(sp)
    800049da:	ec66                	sd	s9,24(sp)
    800049dc:	1880                	addi	s0,sp,112
    800049de:	84aa                	mv	s1,a0
    800049e0:	8b2e                	mv	s6,a1
    800049e2:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    800049e4:	ffffd097          	auipc	ra,0xffffd
    800049e8:	0da080e7          	jalr	218(ra) # 80001abe <myproc>
    800049ec:	8c2a                	mv	s8,a0

  acquire(&pi->lock);
    800049ee:	8526                	mv	a0,s1
    800049f0:	ffffc097          	auipc	ra,0xffffc
    800049f4:	0e2080e7          	jalr	226(ra) # 80000ad2 <acquire>
  for(i = 0; i < n; i++){
    800049f8:	0b505063          	blez	s5,80004a98 <pipewrite+0xd4>
    800049fc:	8926                	mv	s2,s1
    800049fe:	fffa8b9b          	addiw	s7,s5,-1
    80004a02:	1b82                	slli	s7,s7,0x20
    80004a04:	020bdb93          	srli	s7,s7,0x20
    80004a08:	001b0793          	addi	a5,s6,1
    80004a0c:	9bbe                	add	s7,s7,a5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004a0e:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004a12:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a16:	5cfd                	li	s9,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004a18:	2184a783          	lw	a5,536(s1)
    80004a1c:	21c4a703          	lw	a4,540(s1)
    80004a20:	2007879b          	addiw	a5,a5,512
    80004a24:	02f71e63          	bne	a4,a5,80004a60 <pipewrite+0x9c>
      if(pi->readopen == 0 || myproc()->killed){
    80004a28:	2204a783          	lw	a5,544(s1)
    80004a2c:	c3d9                	beqz	a5,80004ab2 <pipewrite+0xee>
    80004a2e:	ffffd097          	auipc	ra,0xffffd
    80004a32:	090080e7          	jalr	144(ra) # 80001abe <myproc>
    80004a36:	591c                	lw	a5,48(a0)
    80004a38:	efad                	bnez	a5,80004ab2 <pipewrite+0xee>
      wakeup(&pi->nread);
    80004a3a:	8552                	mv	a0,s4
    80004a3c:	ffffe097          	auipc	ra,0xffffe
    80004a40:	9ae080e7          	jalr	-1618(ra) # 800023ea <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004a44:	85ca                	mv	a1,s2
    80004a46:	854e                	mv	a0,s3
    80004a48:	ffffe097          	auipc	ra,0xffffe
    80004a4c:	81c080e7          	jalr	-2020(ra) # 80002264 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004a50:	2184a783          	lw	a5,536(s1)
    80004a54:	21c4a703          	lw	a4,540(s1)
    80004a58:	2007879b          	addiw	a5,a5,512
    80004a5c:	fcf706e3          	beq	a4,a5,80004a28 <pipewrite+0x64>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a60:	4685                	li	a3,1
    80004a62:	865a                	mv	a2,s6
    80004a64:	f9f40593          	addi	a1,s0,-97
    80004a68:	050c3503          	ld	a0,80(s8)
    80004a6c:	ffffd097          	auipc	ra,0xffffd
    80004a70:	b58080e7          	jalr	-1192(ra) # 800015c4 <copyin>
    80004a74:	03950263          	beq	a0,s9,80004a98 <pipewrite+0xd4>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004a78:	21c4a783          	lw	a5,540(s1)
    80004a7c:	0017871b          	addiw	a4,a5,1
    80004a80:	20e4ae23          	sw	a4,540(s1)
    80004a84:	1ff7f793          	andi	a5,a5,511
    80004a88:	97a6                	add	a5,a5,s1
    80004a8a:	f9f44703          	lbu	a4,-97(s0)
    80004a8e:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004a92:	0b05                	addi	s6,s6,1
    80004a94:	f97b12e3          	bne	s6,s7,80004a18 <pipewrite+0x54>
  }
  wakeup(&pi->nread);
    80004a98:	21848513          	addi	a0,s1,536
    80004a9c:	ffffe097          	auipc	ra,0xffffe
    80004aa0:	94e080e7          	jalr	-1714(ra) # 800023ea <wakeup>
  release(&pi->lock);
    80004aa4:	8526                	mv	a0,s1
    80004aa6:	ffffc097          	auipc	ra,0xffffc
    80004aaa:	080080e7          	jalr	128(ra) # 80000b26 <release>
  return n;
    80004aae:	8556                	mv	a0,s5
    80004ab0:	a039                	j	80004abe <pipewrite+0xfa>
        release(&pi->lock);
    80004ab2:	8526                	mv	a0,s1
    80004ab4:	ffffc097          	auipc	ra,0xffffc
    80004ab8:	072080e7          	jalr	114(ra) # 80000b26 <release>
        return -1;
    80004abc:	557d                	li	a0,-1
}
    80004abe:	70a6                	ld	ra,104(sp)
    80004ac0:	7406                	ld	s0,96(sp)
    80004ac2:	64e6                	ld	s1,88(sp)
    80004ac4:	6946                	ld	s2,80(sp)
    80004ac6:	69a6                	ld	s3,72(sp)
    80004ac8:	6a06                	ld	s4,64(sp)
    80004aca:	7ae2                	ld	s5,56(sp)
    80004acc:	7b42                	ld	s6,48(sp)
    80004ace:	7ba2                	ld	s7,40(sp)
    80004ad0:	7c02                	ld	s8,32(sp)
    80004ad2:	6ce2                	ld	s9,24(sp)
    80004ad4:	6165                	addi	sp,sp,112
    80004ad6:	8082                	ret

0000000080004ad8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004ad8:	715d                	addi	sp,sp,-80
    80004ada:	e486                	sd	ra,72(sp)
    80004adc:	e0a2                	sd	s0,64(sp)
    80004ade:	fc26                	sd	s1,56(sp)
    80004ae0:	f84a                	sd	s2,48(sp)
    80004ae2:	f44e                	sd	s3,40(sp)
    80004ae4:	f052                	sd	s4,32(sp)
    80004ae6:	ec56                	sd	s5,24(sp)
    80004ae8:	e85a                	sd	s6,16(sp)
    80004aea:	0880                	addi	s0,sp,80
    80004aec:	84aa                	mv	s1,a0
    80004aee:	892e                	mv	s2,a1
    80004af0:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80004af2:	ffffd097          	auipc	ra,0xffffd
    80004af6:	fcc080e7          	jalr	-52(ra) # 80001abe <myproc>
    80004afa:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80004afc:	8b26                	mv	s6,s1
    80004afe:	8526                	mv	a0,s1
    80004b00:	ffffc097          	auipc	ra,0xffffc
    80004b04:	fd2080e7          	jalr	-46(ra) # 80000ad2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b08:	2184a703          	lw	a4,536(s1)
    80004b0c:	21c4a783          	lw	a5,540(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b10:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b14:	02f71763          	bne	a4,a5,80004b42 <piperead+0x6a>
    80004b18:	2244a783          	lw	a5,548(s1)
    80004b1c:	c39d                	beqz	a5,80004b42 <piperead+0x6a>
    if(myproc()->killed){
    80004b1e:	ffffd097          	auipc	ra,0xffffd
    80004b22:	fa0080e7          	jalr	-96(ra) # 80001abe <myproc>
    80004b26:	591c                	lw	a5,48(a0)
    80004b28:	ebc1                	bnez	a5,80004bb8 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b2a:	85da                	mv	a1,s6
    80004b2c:	854e                	mv	a0,s3
    80004b2e:	ffffd097          	auipc	ra,0xffffd
    80004b32:	736080e7          	jalr	1846(ra) # 80002264 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b36:	2184a703          	lw	a4,536(s1)
    80004b3a:	21c4a783          	lw	a5,540(s1)
    80004b3e:	fcf70de3          	beq	a4,a5,80004b18 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b42:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004b44:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b46:	05405363          	blez	s4,80004b8c <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004b4a:	2184a783          	lw	a5,536(s1)
    80004b4e:	21c4a703          	lw	a4,540(s1)
    80004b52:	02f70d63          	beq	a4,a5,80004b8c <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004b56:	0017871b          	addiw	a4,a5,1
    80004b5a:	20e4ac23          	sw	a4,536(s1)
    80004b5e:	1ff7f793          	andi	a5,a5,511
    80004b62:	97a6                	add	a5,a5,s1
    80004b64:	0187c783          	lbu	a5,24(a5)
    80004b68:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004b6c:	4685                	li	a3,1
    80004b6e:	fbf40613          	addi	a2,s0,-65
    80004b72:	85ca                	mv	a1,s2
    80004b74:	050ab503          	ld	a0,80(s5)
    80004b78:	ffffd097          	auipc	ra,0xffffd
    80004b7c:	9c0080e7          	jalr	-1600(ra) # 80001538 <copyout>
    80004b80:	01650663          	beq	a0,s6,80004b8c <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b84:	2985                	addiw	s3,s3,1
    80004b86:	0905                	addi	s2,s2,1
    80004b88:	fd3a11e3          	bne	s4,s3,80004b4a <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004b8c:	21c48513          	addi	a0,s1,540
    80004b90:	ffffe097          	auipc	ra,0xffffe
    80004b94:	85a080e7          	jalr	-1958(ra) # 800023ea <wakeup>
  release(&pi->lock);
    80004b98:	8526                	mv	a0,s1
    80004b9a:	ffffc097          	auipc	ra,0xffffc
    80004b9e:	f8c080e7          	jalr	-116(ra) # 80000b26 <release>
  return i;
}
    80004ba2:	854e                	mv	a0,s3
    80004ba4:	60a6                	ld	ra,72(sp)
    80004ba6:	6406                	ld	s0,64(sp)
    80004ba8:	74e2                	ld	s1,56(sp)
    80004baa:	7942                	ld	s2,48(sp)
    80004bac:	79a2                	ld	s3,40(sp)
    80004bae:	7a02                	ld	s4,32(sp)
    80004bb0:	6ae2                	ld	s5,24(sp)
    80004bb2:	6b42                	ld	s6,16(sp)
    80004bb4:	6161                	addi	sp,sp,80
    80004bb6:	8082                	ret
      release(&pi->lock);
    80004bb8:	8526                	mv	a0,s1
    80004bba:	ffffc097          	auipc	ra,0xffffc
    80004bbe:	f6c080e7          	jalr	-148(ra) # 80000b26 <release>
      return -1;
    80004bc2:	59fd                	li	s3,-1
    80004bc4:	bff9                	j	80004ba2 <piperead+0xca>

0000000080004bc6 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004bc6:	df010113          	addi	sp,sp,-528
    80004bca:	20113423          	sd	ra,520(sp)
    80004bce:	20813023          	sd	s0,512(sp)
    80004bd2:	ffa6                	sd	s1,504(sp)
    80004bd4:	fbca                	sd	s2,496(sp)
    80004bd6:	f7ce                	sd	s3,488(sp)
    80004bd8:	f3d2                	sd	s4,480(sp)
    80004bda:	efd6                	sd	s5,472(sp)
    80004bdc:	ebda                	sd	s6,464(sp)
    80004bde:	e7de                	sd	s7,456(sp)
    80004be0:	e3e2                	sd	s8,448(sp)
    80004be2:	ff66                	sd	s9,440(sp)
    80004be4:	fb6a                	sd	s10,432(sp)
    80004be6:	f76e                	sd	s11,424(sp)
    80004be8:	0c00                	addi	s0,sp,528
    80004bea:	84aa                	mv	s1,a0
    80004bec:	dea43c23          	sd	a0,-520(s0)
    80004bf0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004bf4:	ffffd097          	auipc	ra,0xffffd
    80004bf8:	eca080e7          	jalr	-310(ra) # 80001abe <myproc>
    80004bfc:	892a                	mv	s2,a0
  begin_op();
    80004bfe:	fffff097          	auipc	ra,0xfffff
    80004c02:	454080e7          	jalr	1108(ra) # 80004052 <begin_op>

  if((ip = namei(path)) == 0){
    80004c06:	8526                	mv	a0,s1
    80004c08:	fffff097          	auipc	ra,0xfffff
    80004c0c:	23e080e7          	jalr	574(ra) # 80003e46 <namei>
    80004c10:	c92d                	beqz	a0,80004c82 <exec+0xbc>
    80004c12:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004c14:	fffff097          	auipc	ra,0xfffff
    80004c18:	aa8080e7          	jalr	-1368(ra) # 800036bc <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf)) //readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
    80004c1c:	04000713          	li	a4,64
    80004c20:	4681                	li	a3,0
    80004c22:	e4840613          	addi	a2,s0,-440
    80004c26:	4581                	li	a1,0
    80004c28:	8526                	mv	a0,s1
    80004c2a:	fffff097          	auipc	ra,0xfffff
    80004c2e:	d22080e7          	jalr	-734(ra) # 8000394c <readi>
    80004c32:	04000793          	li	a5,64
    80004c36:	00f51a63          	bne	a0,a5,80004c4a <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004c3a:	e4842703          	lw	a4,-440(s0)
    80004c3e:	464c47b7          	lui	a5,0x464c4
    80004c42:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004c46:	04f70463          	beq	a4,a5,80004c8e <exec+0xc8>
 bad:
  if(pagetable){
    proc_freepagetable(pagetable, sz);
  }
  if(ip){
    iunlockput(ip);
    80004c4a:	8526                	mv	a0,s1
    80004c4c:	fffff097          	auipc	ra,0xfffff
    80004c50:	cae080e7          	jalr	-850(ra) # 800038fa <iunlockput>
    end_op();
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	47e080e7          	jalr	1150(ra) # 800040d2 <end_op>
  }
  return -1;
    80004c5c:	557d                	li	a0,-1
}
    80004c5e:	20813083          	ld	ra,520(sp)
    80004c62:	20013403          	ld	s0,512(sp)
    80004c66:	74fe                	ld	s1,504(sp)
    80004c68:	795e                	ld	s2,496(sp)
    80004c6a:	79be                	ld	s3,488(sp)
    80004c6c:	7a1e                	ld	s4,480(sp)
    80004c6e:	6afe                	ld	s5,472(sp)
    80004c70:	6b5e                	ld	s6,464(sp)
    80004c72:	6bbe                	ld	s7,456(sp)
    80004c74:	6c1e                	ld	s8,448(sp)
    80004c76:	7cfa                	ld	s9,440(sp)
    80004c78:	7d5a                	ld	s10,432(sp)
    80004c7a:	7dba                	ld	s11,424(sp)
    80004c7c:	21010113          	addi	sp,sp,528
    80004c80:	8082                	ret
    end_op();
    80004c82:	fffff097          	auipc	ra,0xfffff
    80004c86:	450080e7          	jalr	1104(ra) # 800040d2 <end_op>
    return -1;
    80004c8a:	557d                	li	a0,-1
    80004c8c:	bfc9                	j	80004c5e <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0) //create a new empty pagetable only trapline and frame in it 
    80004c8e:	854a                	mv	a0,s2
    80004c90:	ffffd097          	auipc	ra,0xffffd
    80004c94:	ef2080e7          	jalr	-270(ra) # 80001b82 <proc_pagetable>
    80004c98:	8c2a                	mv	s8,a0
    80004c9a:	d945                	beqz	a0,80004c4a <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c9c:	e6842983          	lw	s3,-408(s0)
    80004ca0:	e8045783          	lhu	a5,-384(s0)
    80004ca4:	10078363          	beqz	a5,80004daa <exec+0x1e4>
  sz = PGSIZE; //PAGSIZE p3
    80004ca8:	6785                	lui	a5,0x1
    80004caa:	e0f43423          	sd	a5,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004cae:	4b81                	li	s7,0
    if(ph.vaddr % PGSIZE != 0)
    80004cb0:	6b05                	lui	s6,0x1
    80004cb2:	fffb0793          	addi	a5,s6,-1 # fff <_entry-0x7ffff001>
    80004cb6:	def43823          	sd	a5,-528(s0)
    80004cba:	a8b5                	j	80004d36 <exec+0x170>
      printf("uvmalloc failed:%p\n", sz);
    80004cbc:	4581                	li	a1,0
    80004cbe:	00003517          	auipc	a0,0x3
    80004cc2:	ae250513          	addi	a0,a0,-1310 # 800077a0 <userret+0x710>
    80004cc6:	ffffc097          	auipc	ra,0xffffc
    80004cca:	8d2080e7          	jalr	-1838(ra) # 80000598 <printf>
      goto bad;
    80004cce:	a22d                	j	80004df8 <exec+0x232>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004cd0:	00003517          	auipc	a0,0x3
    80004cd4:	ae850513          	addi	a0,a0,-1304 # 800077b8 <userret+0x728>
    80004cd8:	ffffc097          	auipc	ra,0xffffc
    80004cdc:	876080e7          	jalr	-1930(ra) # 8000054e <panic>
    if(sz - i < PGSIZE) //last page, cannot fill a full page
      n = sz - i;
    else
      n = PGSIZE; //full page
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n) //readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
    80004ce0:	8756                	mv	a4,s5
    80004ce2:	012d86bb          	addw	a3,s11,s2
    80004ce6:	4581                	li	a1,0
    80004ce8:	8526                	mv	a0,s1
    80004cea:	fffff097          	auipc	ra,0xfffff
    80004cee:	c62080e7          	jalr	-926(ra) # 8000394c <readi>
    80004cf2:	2501                	sext.w	a0,a0
    80004cf4:	24aa9863          	bne	s5,a0,80004f44 <exec+0x37e>
  for(i = 0; i < sz; i += PGSIZE){
    80004cf8:	6785                	lui	a5,0x1
    80004cfa:	0127893b          	addw	s2,a5,s2
    80004cfe:	77fd                	lui	a5,0xfffff
    80004d00:	01478a3b          	addw	s4,a5,s4
    80004d04:	03997263          	bgeu	s2,s9,80004d28 <exec+0x162>
    pa = walkaddr(pagetable, va + i);
    80004d08:	02091593          	slli	a1,s2,0x20
    80004d0c:	9181                	srli	a1,a1,0x20
    80004d0e:	95ea                	add	a1,a1,s10
    80004d10:	8562                	mv	a0,s8
    80004d12:	ffffc097          	auipc	ra,0xffffc
    80004d16:	258080e7          	jalr	600(ra) # 80000f6a <walkaddr>
    80004d1a:	862a                	mv	a2,a0
    if(pa == 0)
    80004d1c:	d955                	beqz	a0,80004cd0 <exec+0x10a>
      n = PGSIZE; //full page
    80004d1e:	8ada                	mv	s5,s6
    if(sz - i < PGSIZE) //last page, cannot fill a full page
    80004d20:	fd6a70e3          	bgeu	s4,s6,80004ce0 <exec+0x11a>
      n = sz - i;
    80004d24:	8ad2                	mv	s5,s4
    80004d26:	bf6d                	j	80004ce0 <exec+0x11a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d28:	2b85                	addiw	s7,s7,1
    80004d2a:	0389899b          	addiw	s3,s3,56
    80004d2e:	e8045783          	lhu	a5,-384(s0)
    80004d32:	06fbdf63          	bge	s7,a5,80004db0 <exec+0x1ea>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph)) //readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
    80004d36:	2981                	sext.w	s3,s3
    80004d38:	03800713          	li	a4,56
    80004d3c:	86ce                	mv	a3,s3
    80004d3e:	e1040613          	addi	a2,s0,-496
    80004d42:	4581                	li	a1,0
    80004d44:	8526                	mv	a0,s1
    80004d46:	fffff097          	auipc	ra,0xfffff
    80004d4a:	c06080e7          	jalr	-1018(ra) # 8000394c <readi>
    80004d4e:	03800793          	li	a5,56
    80004d52:	0af51363          	bne	a0,a5,80004df8 <exec+0x232>
    if(ph.type != ELF_PROG_LOAD)
    80004d56:	e1042783          	lw	a5,-496(s0)
    80004d5a:	4705                	li	a4,1
    80004d5c:	fce796e3          	bne	a5,a4,80004d28 <exec+0x162>
    if(ph.memsz < ph.filesz)
    80004d60:	e3843603          	ld	a2,-456(s0)
    80004d64:	e3043783          	ld	a5,-464(s0)
    80004d68:	08f66863          	bltu	a2,a5,80004df8 <exec+0x232>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004d6c:	e2043783          	ld	a5,-480(s0)
    80004d70:	963e                	add	a2,a2,a5
    80004d72:	08f66363          	bltu	a2,a5,80004df8 <exec+0x232>
    if((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0){// Allocate PTEs and physical memory to grow process from oldsz to newsz, which need not be page aligned.  Returns new size or 0 on error.
    80004d76:	e0843583          	ld	a1,-504(s0)
    80004d7a:	8562                	mv	a0,s8
    80004d7c:	ffffc097          	auipc	ra,0xffffc
    80004d80:	5ce080e7          	jalr	1486(ra) # 8000134a <uvmalloc>
    80004d84:	e0a43423          	sd	a0,-504(s0)
    80004d88:	d915                	beqz	a0,80004cbc <exec+0xf6>
    if(ph.vaddr % PGSIZE != 0)
    80004d8a:	e2043d03          	ld	s10,-480(s0)
    80004d8e:	df043783          	ld	a5,-528(s0)
    80004d92:	00fd77b3          	and	a5,s10,a5
    80004d96:	e3ad                	bnez	a5,80004df8 <exec+0x232>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0){ //loadseg(pagetable, va, inode, offset, sz)
    80004d98:	e1842d83          	lw	s11,-488(s0)
    80004d9c:	e3042c83          	lw	s9,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004da0:	f80c84e3          	beqz	s9,80004d28 <exec+0x162>
    80004da4:	8a66                	mv	s4,s9
    80004da6:	4901                	li	s2,0
    80004da8:	b785                	j	80004d08 <exec+0x142>
  sz = PGSIZE; //PAGSIZE p3
    80004daa:	6785                	lui	a5,0x1
    80004dac:	e0f43423          	sd	a5,-504(s0)
  iunlockput(ip);
    80004db0:	8526                	mv	a0,s1
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	b48080e7          	jalr	-1208(ra) # 800038fa <iunlockput>
  end_op();
    80004dba:	fffff097          	auipc	ra,0xfffff
    80004dbe:	318080e7          	jalr	792(ra) # 800040d2 <end_op>
  p = myproc();
    80004dc2:	ffffd097          	auipc	ra,0xffffd
    80004dc6:	cfc080e7          	jalr	-772(ra) # 80001abe <myproc>
    80004dca:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004dcc:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004dd0:	6585                	lui	a1,0x1
    80004dd2:	15fd                	addi	a1,a1,-1
    80004dd4:	e0843783          	ld	a5,-504(s0)
    80004dd8:	00b78b33          	add	s6,a5,a1
    80004ddc:	75fd                	lui	a1,0xfffff
    80004dde:	00bb75b3          	and	a1,s6,a1
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004de2:	6609                	lui	a2,0x2
    80004de4:	962e                	add	a2,a2,a1
    80004de6:	8562                	mv	a0,s8
    80004de8:	ffffc097          	auipc	ra,0xffffc
    80004dec:	562080e7          	jalr	1378(ra) # 8000134a <uvmalloc>
    80004df0:	e0a43423          	sd	a0,-504(s0)
  ip = 0;
    80004df4:	4481                	li	s1,0
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004df6:	ed01                	bnez	a0,80004e0e <exec+0x248>
    proc_freepagetable(pagetable, sz);
    80004df8:	e0843583          	ld	a1,-504(s0)
    80004dfc:	8562                	mv	a0,s8
    80004dfe:	ffffd097          	auipc	ra,0xffffd
    80004e02:	e84080e7          	jalr	-380(ra) # 80001c82 <proc_freepagetable>
  if(ip){
    80004e06:	e40492e3          	bnez	s1,80004c4a <exec+0x84>
  return -1;
    80004e0a:	557d                	li	a0,-1
    80004e0c:	bd89                	j	80004c5e <exec+0x98>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004e0e:	75f9                	lui	a1,0xffffe
    80004e10:	84aa                	mv	s1,a0
    80004e12:	95aa                	add	a1,a1,a0
    80004e14:	8562                	mv	a0,s8
    80004e16:	ffffc097          	auipc	ra,0xffffc
    80004e1a:	6f0080e7          	jalr	1776(ra) # 80001506 <uvmclear>
  stackbase = sp - PGSIZE;
    80004e1e:	7afd                	lui	s5,0xfffff
    80004e20:	9aa6                	add	s5,s5,s1
  for(argc = 0; argv[argc]; argc++) {
    80004e22:	e0043783          	ld	a5,-512(s0)
    80004e26:	6388                	ld	a0,0(a5)
    80004e28:	c135                	beqz	a0,80004e8c <exec+0x2c6>
    80004e2a:	e8840993          	addi	s3,s0,-376
    80004e2e:	f8840c93          	addi	s9,s0,-120
    80004e32:	4901                	li	s2,0
    sp -= strlen(argv[argc]) + 1;
    80004e34:	ffffc097          	auipc	ra,0xffffc
    80004e38:	ec2080e7          	jalr	-318(ra) # 80000cf6 <strlen>
    80004e3c:	2505                	addiw	a0,a0,1
    80004e3e:	8c89                	sub	s1,s1,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004e40:	98c1                	andi	s1,s1,-16
    if(sp < stackbase)
    80004e42:	0f54eb63          	bltu	s1,s5,80004f38 <exec+0x372>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004e46:	e0043b03          	ld	s6,-512(s0)
    80004e4a:	000b3a03          	ld	s4,0(s6)
    80004e4e:	8552                	mv	a0,s4
    80004e50:	ffffc097          	auipc	ra,0xffffc
    80004e54:	ea6080e7          	jalr	-346(ra) # 80000cf6 <strlen>
    80004e58:	0015069b          	addiw	a3,a0,1
    80004e5c:	8652                	mv	a2,s4
    80004e5e:	85a6                	mv	a1,s1
    80004e60:	8562                	mv	a0,s8
    80004e62:	ffffc097          	auipc	ra,0xffffc
    80004e66:	6d6080e7          	jalr	1750(ra) # 80001538 <copyout>
    80004e6a:	0c054963          	bltz	a0,80004f3c <exec+0x376>
    ustack[argc] = sp;
    80004e6e:	0099b023          	sd	s1,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004e72:	0905                	addi	s2,s2,1
    80004e74:	008b0793          	addi	a5,s6,8
    80004e78:	e0f43023          	sd	a5,-512(s0)
    80004e7c:	008b3503          	ld	a0,8(s6)
    80004e80:	c909                	beqz	a0,80004e92 <exec+0x2cc>
    if(argc >= MAXARG)
    80004e82:	09a1                	addi	s3,s3,8
    80004e84:	fb3c98e3          	bne	s9,s3,80004e34 <exec+0x26e>
  ip = 0;
    80004e88:	4481                	li	s1,0
    80004e8a:	b7bd                	j	80004df8 <exec+0x232>
  sp = sz;
    80004e8c:	e0843483          	ld	s1,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004e90:	4901                	li	s2,0
  ustack[argc] = 0;
    80004e92:	00391793          	slli	a5,s2,0x3
    80004e96:	f9040713          	addi	a4,s0,-112
    80004e9a:	97ba                	add	a5,a5,a4
    80004e9c:	ee07bc23          	sd	zero,-264(a5) # ef8 <_entry-0x7ffff108>
  sp -= (argc+1) * sizeof(uint64);
    80004ea0:	00190693          	addi	a3,s2,1
    80004ea4:	068e                	slli	a3,a3,0x3
    80004ea6:	8c95                	sub	s1,s1,a3
  sp -= sp % 16;
    80004ea8:	ff04f993          	andi	s3,s1,-16
  ip = 0;
    80004eac:	4481                	li	s1,0
  if(sp < stackbase)
    80004eae:	f559e5e3          	bltu	s3,s5,80004df8 <exec+0x232>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004eb2:	e8840613          	addi	a2,s0,-376
    80004eb6:	85ce                	mv	a1,s3
    80004eb8:	8562                	mv	a0,s8
    80004eba:	ffffc097          	auipc	ra,0xffffc
    80004ebe:	67e080e7          	jalr	1662(ra) # 80001538 <copyout>
    80004ec2:	06054f63          	bltz	a0,80004f40 <exec+0x37a>
  p->tf->a1 = sp;
    80004ec6:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004eca:	0737bc23          	sd	s3,120(a5)
  for(last=s=path; *s; s++)
    80004ece:	df843783          	ld	a5,-520(s0)
    80004ed2:	0007c703          	lbu	a4,0(a5)
    80004ed6:	cf11                	beqz	a4,80004ef2 <exec+0x32c>
    80004ed8:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004eda:	02f00693          	li	a3,47
    80004ede:	a029                	j	80004ee8 <exec+0x322>
  for(last=s=path; *s; s++)
    80004ee0:	0785                	addi	a5,a5,1
    80004ee2:	fff7c703          	lbu	a4,-1(a5)
    80004ee6:	c711                	beqz	a4,80004ef2 <exec+0x32c>
    if(*s == '/')
    80004ee8:	fed71ce3          	bne	a4,a3,80004ee0 <exec+0x31a>
      last = s+1;
    80004eec:	def43c23          	sd	a5,-520(s0)
    80004ef0:	bfc5                	j	80004ee0 <exec+0x31a>
  safestrcpy(p->name, last, sizeof(p->name));
    80004ef2:	4641                	li	a2,16
    80004ef4:	df843583          	ld	a1,-520(s0)
    80004ef8:	158b8513          	addi	a0,s7,344
    80004efc:	ffffc097          	auipc	ra,0xffffc
    80004f00:	dc8080e7          	jalr	-568(ra) # 80000cc4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004f04:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004f08:	058bb823          	sd	s8,80(s7)
  p->sz = sz;
    80004f0c:	e0843783          	ld	a5,-504(s0)
    80004f10:	04fbb423          	sd	a5,72(s7)
  p->tf->epc = elf.entry;  // initial program counter = main
    80004f14:	058bb783          	ld	a5,88(s7)
    80004f18:	e6043703          	ld	a4,-416(s0)
    80004f1c:	ef98                	sd	a4,24(a5)
  p->tf->sp = sp; // initial stack pointer
    80004f1e:	058bb783          	ld	a5,88(s7)
    80004f22:	0337b823          	sd	s3,48(a5)
  proc_freepagetable(oldpagetable, oldsz - PGSIZE); //p3
    80004f26:	75fd                	lui	a1,0xfffff
    80004f28:	95ea                	add	a1,a1,s10
    80004f2a:	ffffd097          	auipc	ra,0xffffd
    80004f2e:	d58080e7          	jalr	-680(ra) # 80001c82 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004f32:	0009051b          	sext.w	a0,s2
    80004f36:	b325                	j	80004c5e <exec+0x98>
  ip = 0;
    80004f38:	4481                	li	s1,0
    80004f3a:	bd7d                	j	80004df8 <exec+0x232>
    80004f3c:	4481                	li	s1,0
    80004f3e:	bd6d                	j	80004df8 <exec+0x232>
    80004f40:	4481                	li	s1,0
    80004f42:	bd5d                	j	80004df8 <exec+0x232>
      printf("loadseg failed:%p\n", sz);
    80004f44:	e0843583          	ld	a1,-504(s0)
    80004f48:	00003517          	auipc	a0,0x3
    80004f4c:	89050513          	addi	a0,a0,-1904 # 800077d8 <userret+0x748>
    80004f50:	ffffb097          	auipc	ra,0xffffb
    80004f54:	648080e7          	jalr	1608(ra) # 80000598 <printf>
      goto bad;
    80004f58:	b545                	j	80004df8 <exec+0x232>

0000000080004f5a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004f5a:	7179                	addi	sp,sp,-48
    80004f5c:	f406                	sd	ra,40(sp)
    80004f5e:	f022                	sd	s0,32(sp)
    80004f60:	ec26                	sd	s1,24(sp)
    80004f62:	e84a                	sd	s2,16(sp)
    80004f64:	1800                	addi	s0,sp,48
    80004f66:	892e                	mv	s2,a1
    80004f68:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004f6a:	fdc40593          	addi	a1,s0,-36
    80004f6e:	ffffe097          	auipc	ra,0xffffe
    80004f72:	bdc080e7          	jalr	-1060(ra) # 80002b4a <argint>
    80004f76:	04054063          	bltz	a0,80004fb6 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004f7a:	fdc42703          	lw	a4,-36(s0)
    80004f7e:	47bd                	li	a5,15
    80004f80:	02e7ed63          	bltu	a5,a4,80004fba <argfd+0x60>
    80004f84:	ffffd097          	auipc	ra,0xffffd
    80004f88:	b3a080e7          	jalr	-1222(ra) # 80001abe <myproc>
    80004f8c:	fdc42703          	lw	a4,-36(s0)
    80004f90:	01a70793          	addi	a5,a4,26
    80004f94:	078e                	slli	a5,a5,0x3
    80004f96:	953e                	add	a0,a0,a5
    80004f98:	611c                	ld	a5,0(a0)
    80004f9a:	c395                	beqz	a5,80004fbe <argfd+0x64>
    return -1;
  if(pfd)
    80004f9c:	00090463          	beqz	s2,80004fa4 <argfd+0x4a>
    *pfd = fd;
    80004fa0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004fa4:	4501                	li	a0,0
  if(pf)
    80004fa6:	c091                	beqz	s1,80004faa <argfd+0x50>
    *pf = f;
    80004fa8:	e09c                	sd	a5,0(s1)
}
    80004faa:	70a2                	ld	ra,40(sp)
    80004fac:	7402                	ld	s0,32(sp)
    80004fae:	64e2                	ld	s1,24(sp)
    80004fb0:	6942                	ld	s2,16(sp)
    80004fb2:	6145                	addi	sp,sp,48
    80004fb4:	8082                	ret
    return -1;
    80004fb6:	557d                	li	a0,-1
    80004fb8:	bfcd                	j	80004faa <argfd+0x50>
    return -1;
    80004fba:	557d                	li	a0,-1
    80004fbc:	b7fd                	j	80004faa <argfd+0x50>
    80004fbe:	557d                	li	a0,-1
    80004fc0:	b7ed                	j	80004faa <argfd+0x50>

0000000080004fc2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004fc2:	1101                	addi	sp,sp,-32
    80004fc4:	ec06                	sd	ra,24(sp)
    80004fc6:	e822                	sd	s0,16(sp)
    80004fc8:	e426                	sd	s1,8(sp)
    80004fca:	1000                	addi	s0,sp,32
    80004fcc:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004fce:	ffffd097          	auipc	ra,0xffffd
    80004fd2:	af0080e7          	jalr	-1296(ra) # 80001abe <myproc>
    80004fd6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004fd8:	0d050793          	addi	a5,a0,208
    80004fdc:	4501                	li	a0,0
    80004fde:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004fe0:	6398                	ld	a4,0(a5)
    80004fe2:	cb19                	beqz	a4,80004ff8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004fe4:	2505                	addiw	a0,a0,1
    80004fe6:	07a1                	addi	a5,a5,8
    80004fe8:	fed51ce3          	bne	a0,a3,80004fe0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004fec:	557d                	li	a0,-1
}
    80004fee:	60e2                	ld	ra,24(sp)
    80004ff0:	6442                	ld	s0,16(sp)
    80004ff2:	64a2                	ld	s1,8(sp)
    80004ff4:	6105                	addi	sp,sp,32
    80004ff6:	8082                	ret
      p->ofile[fd] = f;
    80004ff8:	01a50793          	addi	a5,a0,26
    80004ffc:	078e                	slli	a5,a5,0x3
    80004ffe:	963e                	add	a2,a2,a5
    80005000:	e204                	sd	s1,0(a2)
      return fd;
    80005002:	b7f5                	j	80004fee <fdalloc+0x2c>

0000000080005004 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005004:	715d                	addi	sp,sp,-80
    80005006:	e486                	sd	ra,72(sp)
    80005008:	e0a2                	sd	s0,64(sp)
    8000500a:	fc26                	sd	s1,56(sp)
    8000500c:	f84a                	sd	s2,48(sp)
    8000500e:	f44e                	sd	s3,40(sp)
    80005010:	f052                	sd	s4,32(sp)
    80005012:	ec56                	sd	s5,24(sp)
    80005014:	0880                	addi	s0,sp,80
    80005016:	89ae                	mv	s3,a1
    80005018:	8ab2                	mv	s5,a2
    8000501a:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000501c:	fb040593          	addi	a1,s0,-80
    80005020:	fffff097          	auipc	ra,0xfffff
    80005024:	e44080e7          	jalr	-444(ra) # 80003e64 <nameiparent>
    80005028:	892a                	mv	s2,a0
    8000502a:	12050e63          	beqz	a0,80005166 <create+0x162>
    return 0;

  ilock(dp);
    8000502e:	ffffe097          	auipc	ra,0xffffe
    80005032:	68e080e7          	jalr	1678(ra) # 800036bc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005036:	4601                	li	a2,0
    80005038:	fb040593          	addi	a1,s0,-80
    8000503c:	854a                	mv	a0,s2
    8000503e:	fffff097          	auipc	ra,0xfffff
    80005042:	b36080e7          	jalr	-1226(ra) # 80003b74 <dirlookup>
    80005046:	84aa                	mv	s1,a0
    80005048:	c921                	beqz	a0,80005098 <create+0x94>
    iunlockput(dp);
    8000504a:	854a                	mv	a0,s2
    8000504c:	fffff097          	auipc	ra,0xfffff
    80005050:	8ae080e7          	jalr	-1874(ra) # 800038fa <iunlockput>
    ilock(ip);
    80005054:	8526                	mv	a0,s1
    80005056:	ffffe097          	auipc	ra,0xffffe
    8000505a:	666080e7          	jalr	1638(ra) # 800036bc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000505e:	2981                	sext.w	s3,s3
    80005060:	4789                	li	a5,2
    80005062:	02f99463          	bne	s3,a5,8000508a <create+0x86>
    80005066:	0444d783          	lhu	a5,68(s1)
    8000506a:	37f9                	addiw	a5,a5,-2
    8000506c:	17c2                	slli	a5,a5,0x30
    8000506e:	93c1                	srli	a5,a5,0x30
    80005070:	4705                	li	a4,1
    80005072:	00f76c63          	bltu	a4,a5,8000508a <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005076:	8526                	mv	a0,s1
    80005078:	60a6                	ld	ra,72(sp)
    8000507a:	6406                	ld	s0,64(sp)
    8000507c:	74e2                	ld	s1,56(sp)
    8000507e:	7942                	ld	s2,48(sp)
    80005080:	79a2                	ld	s3,40(sp)
    80005082:	7a02                	ld	s4,32(sp)
    80005084:	6ae2                	ld	s5,24(sp)
    80005086:	6161                	addi	sp,sp,80
    80005088:	8082                	ret
    iunlockput(ip);
    8000508a:	8526                	mv	a0,s1
    8000508c:	fffff097          	auipc	ra,0xfffff
    80005090:	86e080e7          	jalr	-1938(ra) # 800038fa <iunlockput>
    return 0;
    80005094:	4481                	li	s1,0
    80005096:	b7c5                	j	80005076 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005098:	85ce                	mv	a1,s3
    8000509a:	00092503          	lw	a0,0(s2)
    8000509e:	ffffe097          	auipc	ra,0xffffe
    800050a2:	486080e7          	jalr	1158(ra) # 80003524 <ialloc>
    800050a6:	84aa                	mv	s1,a0
    800050a8:	c521                	beqz	a0,800050f0 <create+0xec>
  ilock(ip);
    800050aa:	ffffe097          	auipc	ra,0xffffe
    800050ae:	612080e7          	jalr	1554(ra) # 800036bc <ilock>
  ip->major = major;
    800050b2:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800050b6:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800050ba:	4a05                	li	s4,1
    800050bc:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800050c0:	8526                	mv	a0,s1
    800050c2:	ffffe097          	auipc	ra,0xffffe
    800050c6:	530080e7          	jalr	1328(ra) # 800035f2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800050ca:	2981                	sext.w	s3,s3
    800050cc:	03498a63          	beq	s3,s4,80005100 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800050d0:	40d0                	lw	a2,4(s1)
    800050d2:	fb040593          	addi	a1,s0,-80
    800050d6:	854a                	mv	a0,s2
    800050d8:	fffff097          	auipc	ra,0xfffff
    800050dc:	cac080e7          	jalr	-852(ra) # 80003d84 <dirlink>
    800050e0:	06054b63          	bltz	a0,80005156 <create+0x152>
  iunlockput(dp);
    800050e4:	854a                	mv	a0,s2
    800050e6:	fffff097          	auipc	ra,0xfffff
    800050ea:	814080e7          	jalr	-2028(ra) # 800038fa <iunlockput>
  return ip;
    800050ee:	b761                	j	80005076 <create+0x72>
    panic("create: ialloc");
    800050f0:	00002517          	auipc	a0,0x2
    800050f4:	70050513          	addi	a0,a0,1792 # 800077f0 <userret+0x760>
    800050f8:	ffffb097          	auipc	ra,0xffffb
    800050fc:	456080e7          	jalr	1110(ra) # 8000054e <panic>
    dp->nlink++;  // for ".."
    80005100:	04a95783          	lhu	a5,74(s2)
    80005104:	2785                	addiw	a5,a5,1
    80005106:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000510a:	854a                	mv	a0,s2
    8000510c:	ffffe097          	auipc	ra,0xffffe
    80005110:	4e6080e7          	jalr	1254(ra) # 800035f2 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005114:	40d0                	lw	a2,4(s1)
    80005116:	00002597          	auipc	a1,0x2
    8000511a:	6ea58593          	addi	a1,a1,1770 # 80007800 <userret+0x770>
    8000511e:	8526                	mv	a0,s1
    80005120:	fffff097          	auipc	ra,0xfffff
    80005124:	c64080e7          	jalr	-924(ra) # 80003d84 <dirlink>
    80005128:	00054f63          	bltz	a0,80005146 <create+0x142>
    8000512c:	00492603          	lw	a2,4(s2)
    80005130:	00002597          	auipc	a1,0x2
    80005134:	6d858593          	addi	a1,a1,1752 # 80007808 <userret+0x778>
    80005138:	8526                	mv	a0,s1
    8000513a:	fffff097          	auipc	ra,0xfffff
    8000513e:	c4a080e7          	jalr	-950(ra) # 80003d84 <dirlink>
    80005142:	f80557e3          	bgez	a0,800050d0 <create+0xcc>
      panic("create dots");
    80005146:	00002517          	auipc	a0,0x2
    8000514a:	6ca50513          	addi	a0,a0,1738 # 80007810 <userret+0x780>
    8000514e:	ffffb097          	auipc	ra,0xffffb
    80005152:	400080e7          	jalr	1024(ra) # 8000054e <panic>
    panic("create: dirlink");
    80005156:	00002517          	auipc	a0,0x2
    8000515a:	6ca50513          	addi	a0,a0,1738 # 80007820 <userret+0x790>
    8000515e:	ffffb097          	auipc	ra,0xffffb
    80005162:	3f0080e7          	jalr	1008(ra) # 8000054e <panic>
    return 0;
    80005166:	84aa                	mv	s1,a0
    80005168:	b739                	j	80005076 <create+0x72>

000000008000516a <sys_dup>:
{
    8000516a:	7179                	addi	sp,sp,-48
    8000516c:	f406                	sd	ra,40(sp)
    8000516e:	f022                	sd	s0,32(sp)
    80005170:	ec26                	sd	s1,24(sp)
    80005172:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005174:	fd840613          	addi	a2,s0,-40
    80005178:	4581                	li	a1,0
    8000517a:	4501                	li	a0,0
    8000517c:	00000097          	auipc	ra,0x0
    80005180:	dde080e7          	jalr	-546(ra) # 80004f5a <argfd>
    return -1;
    80005184:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005186:	02054363          	bltz	a0,800051ac <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000518a:	fd843503          	ld	a0,-40(s0)
    8000518e:	00000097          	auipc	ra,0x0
    80005192:	e34080e7          	jalr	-460(ra) # 80004fc2 <fdalloc>
    80005196:	84aa                	mv	s1,a0
    return -1;
    80005198:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000519a:	00054963          	bltz	a0,800051ac <sys_dup+0x42>
  filedup(f);
    8000519e:	fd843503          	ld	a0,-40(s0)
    800051a2:	fffff097          	auipc	ra,0xfffff
    800051a6:	330080e7          	jalr	816(ra) # 800044d2 <filedup>
  return fd;
    800051aa:	87a6                	mv	a5,s1
}
    800051ac:	853e                	mv	a0,a5
    800051ae:	70a2                	ld	ra,40(sp)
    800051b0:	7402                	ld	s0,32(sp)
    800051b2:	64e2                	ld	s1,24(sp)
    800051b4:	6145                	addi	sp,sp,48
    800051b6:	8082                	ret

00000000800051b8 <sys_read>:
{
    800051b8:	7179                	addi	sp,sp,-48
    800051ba:	f406                	sd	ra,40(sp)
    800051bc:	f022                	sd	s0,32(sp)
    800051be:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051c0:	fe840613          	addi	a2,s0,-24
    800051c4:	4581                	li	a1,0
    800051c6:	4501                	li	a0,0
    800051c8:	00000097          	auipc	ra,0x0
    800051cc:	d92080e7          	jalr	-622(ra) # 80004f5a <argfd>
    return -1;
    800051d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051d2:	04054163          	bltz	a0,80005214 <sys_read+0x5c>
    800051d6:	fe440593          	addi	a1,s0,-28
    800051da:	4509                	li	a0,2
    800051dc:	ffffe097          	auipc	ra,0xffffe
    800051e0:	96e080e7          	jalr	-1682(ra) # 80002b4a <argint>
    return -1;
    800051e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051e6:	02054763          	bltz	a0,80005214 <sys_read+0x5c>
    800051ea:	fd840593          	addi	a1,s0,-40
    800051ee:	4505                	li	a0,1
    800051f0:	ffffe097          	auipc	ra,0xffffe
    800051f4:	97c080e7          	jalr	-1668(ra) # 80002b6c <argaddr>
    return -1;
    800051f8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051fa:	00054d63          	bltz	a0,80005214 <sys_read+0x5c>
  return fileread(f, p, n);
    800051fe:	fe442603          	lw	a2,-28(s0)
    80005202:	fd843583          	ld	a1,-40(s0)
    80005206:	fe843503          	ld	a0,-24(s0)
    8000520a:	fffff097          	auipc	ra,0xfffff
    8000520e:	454080e7          	jalr	1108(ra) # 8000465e <fileread>
    80005212:	87aa                	mv	a5,a0
}
    80005214:	853e                	mv	a0,a5
    80005216:	70a2                	ld	ra,40(sp)
    80005218:	7402                	ld	s0,32(sp)
    8000521a:	6145                	addi	sp,sp,48
    8000521c:	8082                	ret

000000008000521e <sys_write>:
{
    8000521e:	7179                	addi	sp,sp,-48
    80005220:	f406                	sd	ra,40(sp)
    80005222:	f022                	sd	s0,32(sp)
    80005224:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005226:	fe840613          	addi	a2,s0,-24
    8000522a:	4581                	li	a1,0
    8000522c:	4501                	li	a0,0
    8000522e:	00000097          	auipc	ra,0x0
    80005232:	d2c080e7          	jalr	-724(ra) # 80004f5a <argfd>
    return -1;
    80005236:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005238:	04054163          	bltz	a0,8000527a <sys_write+0x5c>
    8000523c:	fe440593          	addi	a1,s0,-28
    80005240:	4509                	li	a0,2
    80005242:	ffffe097          	auipc	ra,0xffffe
    80005246:	908080e7          	jalr	-1784(ra) # 80002b4a <argint>
    return -1;
    8000524a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000524c:	02054763          	bltz	a0,8000527a <sys_write+0x5c>
    80005250:	fd840593          	addi	a1,s0,-40
    80005254:	4505                	li	a0,1
    80005256:	ffffe097          	auipc	ra,0xffffe
    8000525a:	916080e7          	jalr	-1770(ra) # 80002b6c <argaddr>
    return -1;
    8000525e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005260:	00054d63          	bltz	a0,8000527a <sys_write+0x5c>
  return filewrite(f, p, n);
    80005264:	fe442603          	lw	a2,-28(s0)
    80005268:	fd843583          	ld	a1,-40(s0)
    8000526c:	fe843503          	ld	a0,-24(s0)
    80005270:	fffff097          	auipc	ra,0xfffff
    80005274:	4b0080e7          	jalr	1200(ra) # 80004720 <filewrite>
    80005278:	87aa                	mv	a5,a0
}
    8000527a:	853e                	mv	a0,a5
    8000527c:	70a2                	ld	ra,40(sp)
    8000527e:	7402                	ld	s0,32(sp)
    80005280:	6145                	addi	sp,sp,48
    80005282:	8082                	ret

0000000080005284 <sys_close>:
{
    80005284:	1101                	addi	sp,sp,-32
    80005286:	ec06                	sd	ra,24(sp)
    80005288:	e822                	sd	s0,16(sp)
    8000528a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000528c:	fe040613          	addi	a2,s0,-32
    80005290:	fec40593          	addi	a1,s0,-20
    80005294:	4501                	li	a0,0
    80005296:	00000097          	auipc	ra,0x0
    8000529a:	cc4080e7          	jalr	-828(ra) # 80004f5a <argfd>
    return -1;
    8000529e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800052a0:	02054463          	bltz	a0,800052c8 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800052a4:	ffffd097          	auipc	ra,0xffffd
    800052a8:	81a080e7          	jalr	-2022(ra) # 80001abe <myproc>
    800052ac:	fec42783          	lw	a5,-20(s0)
    800052b0:	07e9                	addi	a5,a5,26
    800052b2:	078e                	slli	a5,a5,0x3
    800052b4:	97aa                	add	a5,a5,a0
    800052b6:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800052ba:	fe043503          	ld	a0,-32(s0)
    800052be:	fffff097          	auipc	ra,0xfffff
    800052c2:	266080e7          	jalr	614(ra) # 80004524 <fileclose>
  return 0;
    800052c6:	4781                	li	a5,0
}
    800052c8:	853e                	mv	a0,a5
    800052ca:	60e2                	ld	ra,24(sp)
    800052cc:	6442                	ld	s0,16(sp)
    800052ce:	6105                	addi	sp,sp,32
    800052d0:	8082                	ret

00000000800052d2 <sys_fstat>:
{
    800052d2:	1101                	addi	sp,sp,-32
    800052d4:	ec06                	sd	ra,24(sp)
    800052d6:	e822                	sd	s0,16(sp)
    800052d8:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800052da:	fe840613          	addi	a2,s0,-24
    800052de:	4581                	li	a1,0
    800052e0:	4501                	li	a0,0
    800052e2:	00000097          	auipc	ra,0x0
    800052e6:	c78080e7          	jalr	-904(ra) # 80004f5a <argfd>
    return -1;
    800052ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800052ec:	02054563          	bltz	a0,80005316 <sys_fstat+0x44>
    800052f0:	fe040593          	addi	a1,s0,-32
    800052f4:	4505                	li	a0,1
    800052f6:	ffffe097          	auipc	ra,0xffffe
    800052fa:	876080e7          	jalr	-1930(ra) # 80002b6c <argaddr>
    return -1;
    800052fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005300:	00054b63          	bltz	a0,80005316 <sys_fstat+0x44>
  return filestat(f, st);
    80005304:	fe043583          	ld	a1,-32(s0)
    80005308:	fe843503          	ld	a0,-24(s0)
    8000530c:	fffff097          	auipc	ra,0xfffff
    80005310:	2e0080e7          	jalr	736(ra) # 800045ec <filestat>
    80005314:	87aa                	mv	a5,a0
}
    80005316:	853e                	mv	a0,a5
    80005318:	60e2                	ld	ra,24(sp)
    8000531a:	6442                	ld	s0,16(sp)
    8000531c:	6105                	addi	sp,sp,32
    8000531e:	8082                	ret

0000000080005320 <sys_link>:
{
    80005320:	7169                	addi	sp,sp,-304
    80005322:	f606                	sd	ra,296(sp)
    80005324:	f222                	sd	s0,288(sp)
    80005326:	ee26                	sd	s1,280(sp)
    80005328:	ea4a                	sd	s2,272(sp)
    8000532a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000532c:	08000613          	li	a2,128
    80005330:	ed040593          	addi	a1,s0,-304
    80005334:	4501                	li	a0,0
    80005336:	ffffe097          	auipc	ra,0xffffe
    8000533a:	858080e7          	jalr	-1960(ra) # 80002b8e <argstr>
    return -1;
    8000533e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005340:	10054e63          	bltz	a0,8000545c <sys_link+0x13c>
    80005344:	08000613          	li	a2,128
    80005348:	f5040593          	addi	a1,s0,-176
    8000534c:	4505                	li	a0,1
    8000534e:	ffffe097          	auipc	ra,0xffffe
    80005352:	840080e7          	jalr	-1984(ra) # 80002b8e <argstr>
    return -1;
    80005356:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005358:	10054263          	bltz	a0,8000545c <sys_link+0x13c>
  begin_op();
    8000535c:	fffff097          	auipc	ra,0xfffff
    80005360:	cf6080e7          	jalr	-778(ra) # 80004052 <begin_op>
  if((ip = namei(old)) == 0){
    80005364:	ed040513          	addi	a0,s0,-304
    80005368:	fffff097          	auipc	ra,0xfffff
    8000536c:	ade080e7          	jalr	-1314(ra) # 80003e46 <namei>
    80005370:	84aa                	mv	s1,a0
    80005372:	c551                	beqz	a0,800053fe <sys_link+0xde>
  ilock(ip);
    80005374:	ffffe097          	auipc	ra,0xffffe
    80005378:	348080e7          	jalr	840(ra) # 800036bc <ilock>
  if(ip->type == T_DIR){
    8000537c:	04449703          	lh	a4,68(s1)
    80005380:	4785                	li	a5,1
    80005382:	08f70463          	beq	a4,a5,8000540a <sys_link+0xea>
  ip->nlink++;
    80005386:	04a4d783          	lhu	a5,74(s1)
    8000538a:	2785                	addiw	a5,a5,1
    8000538c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005390:	8526                	mv	a0,s1
    80005392:	ffffe097          	auipc	ra,0xffffe
    80005396:	260080e7          	jalr	608(ra) # 800035f2 <iupdate>
  iunlock(ip);
    8000539a:	8526                	mv	a0,s1
    8000539c:	ffffe097          	auipc	ra,0xffffe
    800053a0:	3e2080e7          	jalr	994(ra) # 8000377e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800053a4:	fd040593          	addi	a1,s0,-48
    800053a8:	f5040513          	addi	a0,s0,-176
    800053ac:	fffff097          	auipc	ra,0xfffff
    800053b0:	ab8080e7          	jalr	-1352(ra) # 80003e64 <nameiparent>
    800053b4:	892a                	mv	s2,a0
    800053b6:	c935                	beqz	a0,8000542a <sys_link+0x10a>
  ilock(dp);
    800053b8:	ffffe097          	auipc	ra,0xffffe
    800053bc:	304080e7          	jalr	772(ra) # 800036bc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800053c0:	00092703          	lw	a4,0(s2)
    800053c4:	409c                	lw	a5,0(s1)
    800053c6:	04f71d63          	bne	a4,a5,80005420 <sys_link+0x100>
    800053ca:	40d0                	lw	a2,4(s1)
    800053cc:	fd040593          	addi	a1,s0,-48
    800053d0:	854a                	mv	a0,s2
    800053d2:	fffff097          	auipc	ra,0xfffff
    800053d6:	9b2080e7          	jalr	-1614(ra) # 80003d84 <dirlink>
    800053da:	04054363          	bltz	a0,80005420 <sys_link+0x100>
  iunlockput(dp);
    800053de:	854a                	mv	a0,s2
    800053e0:	ffffe097          	auipc	ra,0xffffe
    800053e4:	51a080e7          	jalr	1306(ra) # 800038fa <iunlockput>
  iput(ip);
    800053e8:	8526                	mv	a0,s1
    800053ea:	ffffe097          	auipc	ra,0xffffe
    800053ee:	3e0080e7          	jalr	992(ra) # 800037ca <iput>
  end_op();
    800053f2:	fffff097          	auipc	ra,0xfffff
    800053f6:	ce0080e7          	jalr	-800(ra) # 800040d2 <end_op>
  return 0;
    800053fa:	4781                	li	a5,0
    800053fc:	a085                	j	8000545c <sys_link+0x13c>
    end_op();
    800053fe:	fffff097          	auipc	ra,0xfffff
    80005402:	cd4080e7          	jalr	-812(ra) # 800040d2 <end_op>
    return -1;
    80005406:	57fd                	li	a5,-1
    80005408:	a891                	j	8000545c <sys_link+0x13c>
    iunlockput(ip);
    8000540a:	8526                	mv	a0,s1
    8000540c:	ffffe097          	auipc	ra,0xffffe
    80005410:	4ee080e7          	jalr	1262(ra) # 800038fa <iunlockput>
    end_op();
    80005414:	fffff097          	auipc	ra,0xfffff
    80005418:	cbe080e7          	jalr	-834(ra) # 800040d2 <end_op>
    return -1;
    8000541c:	57fd                	li	a5,-1
    8000541e:	a83d                	j	8000545c <sys_link+0x13c>
    iunlockput(dp);
    80005420:	854a                	mv	a0,s2
    80005422:	ffffe097          	auipc	ra,0xffffe
    80005426:	4d8080e7          	jalr	1240(ra) # 800038fa <iunlockput>
  ilock(ip);
    8000542a:	8526                	mv	a0,s1
    8000542c:	ffffe097          	auipc	ra,0xffffe
    80005430:	290080e7          	jalr	656(ra) # 800036bc <ilock>
  ip->nlink--;
    80005434:	04a4d783          	lhu	a5,74(s1)
    80005438:	37fd                	addiw	a5,a5,-1
    8000543a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000543e:	8526                	mv	a0,s1
    80005440:	ffffe097          	auipc	ra,0xffffe
    80005444:	1b2080e7          	jalr	434(ra) # 800035f2 <iupdate>
  iunlockput(ip);
    80005448:	8526                	mv	a0,s1
    8000544a:	ffffe097          	auipc	ra,0xffffe
    8000544e:	4b0080e7          	jalr	1200(ra) # 800038fa <iunlockput>
  end_op();
    80005452:	fffff097          	auipc	ra,0xfffff
    80005456:	c80080e7          	jalr	-896(ra) # 800040d2 <end_op>
  return -1;
    8000545a:	57fd                	li	a5,-1
}
    8000545c:	853e                	mv	a0,a5
    8000545e:	70b2                	ld	ra,296(sp)
    80005460:	7412                	ld	s0,288(sp)
    80005462:	64f2                	ld	s1,280(sp)
    80005464:	6952                	ld	s2,272(sp)
    80005466:	6155                	addi	sp,sp,304
    80005468:	8082                	ret

000000008000546a <sys_unlink>:
{
    8000546a:	7151                	addi	sp,sp,-240
    8000546c:	f586                	sd	ra,232(sp)
    8000546e:	f1a2                	sd	s0,224(sp)
    80005470:	eda6                	sd	s1,216(sp)
    80005472:	e9ca                	sd	s2,208(sp)
    80005474:	e5ce                	sd	s3,200(sp)
    80005476:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005478:	08000613          	li	a2,128
    8000547c:	f3040593          	addi	a1,s0,-208
    80005480:	4501                	li	a0,0
    80005482:	ffffd097          	auipc	ra,0xffffd
    80005486:	70c080e7          	jalr	1804(ra) # 80002b8e <argstr>
    8000548a:	18054163          	bltz	a0,8000560c <sys_unlink+0x1a2>
  begin_op();
    8000548e:	fffff097          	auipc	ra,0xfffff
    80005492:	bc4080e7          	jalr	-1084(ra) # 80004052 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005496:	fb040593          	addi	a1,s0,-80
    8000549a:	f3040513          	addi	a0,s0,-208
    8000549e:	fffff097          	auipc	ra,0xfffff
    800054a2:	9c6080e7          	jalr	-1594(ra) # 80003e64 <nameiparent>
    800054a6:	84aa                	mv	s1,a0
    800054a8:	c979                	beqz	a0,8000557e <sys_unlink+0x114>
  ilock(dp);
    800054aa:	ffffe097          	auipc	ra,0xffffe
    800054ae:	212080e7          	jalr	530(ra) # 800036bc <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800054b2:	00002597          	auipc	a1,0x2
    800054b6:	34e58593          	addi	a1,a1,846 # 80007800 <userret+0x770>
    800054ba:	fb040513          	addi	a0,s0,-80
    800054be:	ffffe097          	auipc	ra,0xffffe
    800054c2:	69c080e7          	jalr	1692(ra) # 80003b5a <namecmp>
    800054c6:	14050a63          	beqz	a0,8000561a <sys_unlink+0x1b0>
    800054ca:	00002597          	auipc	a1,0x2
    800054ce:	33e58593          	addi	a1,a1,830 # 80007808 <userret+0x778>
    800054d2:	fb040513          	addi	a0,s0,-80
    800054d6:	ffffe097          	auipc	ra,0xffffe
    800054da:	684080e7          	jalr	1668(ra) # 80003b5a <namecmp>
    800054de:	12050e63          	beqz	a0,8000561a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800054e2:	f2c40613          	addi	a2,s0,-212
    800054e6:	fb040593          	addi	a1,s0,-80
    800054ea:	8526                	mv	a0,s1
    800054ec:	ffffe097          	auipc	ra,0xffffe
    800054f0:	688080e7          	jalr	1672(ra) # 80003b74 <dirlookup>
    800054f4:	892a                	mv	s2,a0
    800054f6:	12050263          	beqz	a0,8000561a <sys_unlink+0x1b0>
  ilock(ip);
    800054fa:	ffffe097          	auipc	ra,0xffffe
    800054fe:	1c2080e7          	jalr	450(ra) # 800036bc <ilock>
  if(ip->nlink < 1)
    80005502:	04a91783          	lh	a5,74(s2)
    80005506:	08f05263          	blez	a5,8000558a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000550a:	04491703          	lh	a4,68(s2)
    8000550e:	4785                	li	a5,1
    80005510:	08f70563          	beq	a4,a5,8000559a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005514:	4641                	li	a2,16
    80005516:	4581                	li	a1,0
    80005518:	fc040513          	addi	a0,s0,-64
    8000551c:	ffffb097          	auipc	ra,0xffffb
    80005520:	652080e7          	jalr	1618(ra) # 80000b6e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005524:	4741                	li	a4,16
    80005526:	f2c42683          	lw	a3,-212(s0)
    8000552a:	fc040613          	addi	a2,s0,-64
    8000552e:	4581                	li	a1,0
    80005530:	8526                	mv	a0,s1
    80005532:	ffffe097          	auipc	ra,0xffffe
    80005536:	50e080e7          	jalr	1294(ra) # 80003a40 <writei>
    8000553a:	47c1                	li	a5,16
    8000553c:	0af51563          	bne	a0,a5,800055e6 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005540:	04491703          	lh	a4,68(s2)
    80005544:	4785                	li	a5,1
    80005546:	0af70863          	beq	a4,a5,800055f6 <sys_unlink+0x18c>
  iunlockput(dp);
    8000554a:	8526                	mv	a0,s1
    8000554c:	ffffe097          	auipc	ra,0xffffe
    80005550:	3ae080e7          	jalr	942(ra) # 800038fa <iunlockput>
  ip->nlink--;
    80005554:	04a95783          	lhu	a5,74(s2)
    80005558:	37fd                	addiw	a5,a5,-1
    8000555a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000555e:	854a                	mv	a0,s2
    80005560:	ffffe097          	auipc	ra,0xffffe
    80005564:	092080e7          	jalr	146(ra) # 800035f2 <iupdate>
  iunlockput(ip);
    80005568:	854a                	mv	a0,s2
    8000556a:	ffffe097          	auipc	ra,0xffffe
    8000556e:	390080e7          	jalr	912(ra) # 800038fa <iunlockput>
  end_op();
    80005572:	fffff097          	auipc	ra,0xfffff
    80005576:	b60080e7          	jalr	-1184(ra) # 800040d2 <end_op>
  return 0;
    8000557a:	4501                	li	a0,0
    8000557c:	a84d                	j	8000562e <sys_unlink+0x1c4>
    end_op();
    8000557e:	fffff097          	auipc	ra,0xfffff
    80005582:	b54080e7          	jalr	-1196(ra) # 800040d2 <end_op>
    return -1;
    80005586:	557d                	li	a0,-1
    80005588:	a05d                	j	8000562e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000558a:	00002517          	auipc	a0,0x2
    8000558e:	2a650513          	addi	a0,a0,678 # 80007830 <userret+0x7a0>
    80005592:	ffffb097          	auipc	ra,0xffffb
    80005596:	fbc080e7          	jalr	-68(ra) # 8000054e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000559a:	04c92703          	lw	a4,76(s2)
    8000559e:	02000793          	li	a5,32
    800055a2:	f6e7f9e3          	bgeu	a5,a4,80005514 <sys_unlink+0xaa>
    800055a6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055aa:	4741                	li	a4,16
    800055ac:	86ce                	mv	a3,s3
    800055ae:	f1840613          	addi	a2,s0,-232
    800055b2:	4581                	li	a1,0
    800055b4:	854a                	mv	a0,s2
    800055b6:	ffffe097          	auipc	ra,0xffffe
    800055ba:	396080e7          	jalr	918(ra) # 8000394c <readi>
    800055be:	47c1                	li	a5,16
    800055c0:	00f51b63          	bne	a0,a5,800055d6 <sys_unlink+0x16c>
    if(de.inum != 0)
    800055c4:	f1845783          	lhu	a5,-232(s0)
    800055c8:	e7a1                	bnez	a5,80005610 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800055ca:	29c1                	addiw	s3,s3,16
    800055cc:	04c92783          	lw	a5,76(s2)
    800055d0:	fcf9ede3          	bltu	s3,a5,800055aa <sys_unlink+0x140>
    800055d4:	b781                	j	80005514 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800055d6:	00002517          	auipc	a0,0x2
    800055da:	27250513          	addi	a0,a0,626 # 80007848 <userret+0x7b8>
    800055de:	ffffb097          	auipc	ra,0xffffb
    800055e2:	f70080e7          	jalr	-144(ra) # 8000054e <panic>
    panic("unlink: writei");
    800055e6:	00002517          	auipc	a0,0x2
    800055ea:	27a50513          	addi	a0,a0,634 # 80007860 <userret+0x7d0>
    800055ee:	ffffb097          	auipc	ra,0xffffb
    800055f2:	f60080e7          	jalr	-160(ra) # 8000054e <panic>
    dp->nlink--;
    800055f6:	04a4d783          	lhu	a5,74(s1)
    800055fa:	37fd                	addiw	a5,a5,-1
    800055fc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005600:	8526                	mv	a0,s1
    80005602:	ffffe097          	auipc	ra,0xffffe
    80005606:	ff0080e7          	jalr	-16(ra) # 800035f2 <iupdate>
    8000560a:	b781                	j	8000554a <sys_unlink+0xe0>
    return -1;
    8000560c:	557d                	li	a0,-1
    8000560e:	a005                	j	8000562e <sys_unlink+0x1c4>
    iunlockput(ip);
    80005610:	854a                	mv	a0,s2
    80005612:	ffffe097          	auipc	ra,0xffffe
    80005616:	2e8080e7          	jalr	744(ra) # 800038fa <iunlockput>
  iunlockput(dp);
    8000561a:	8526                	mv	a0,s1
    8000561c:	ffffe097          	auipc	ra,0xffffe
    80005620:	2de080e7          	jalr	734(ra) # 800038fa <iunlockput>
  end_op();
    80005624:	fffff097          	auipc	ra,0xfffff
    80005628:	aae080e7          	jalr	-1362(ra) # 800040d2 <end_op>
  return -1;
    8000562c:	557d                	li	a0,-1
}
    8000562e:	70ae                	ld	ra,232(sp)
    80005630:	740e                	ld	s0,224(sp)
    80005632:	64ee                	ld	s1,216(sp)
    80005634:	694e                	ld	s2,208(sp)
    80005636:	69ae                	ld	s3,200(sp)
    80005638:	616d                	addi	sp,sp,240
    8000563a:	8082                	ret

000000008000563c <sys_open>:

uint64
sys_open(void)
{
    8000563c:	7131                	addi	sp,sp,-192
    8000563e:	fd06                	sd	ra,184(sp)
    80005640:	f922                	sd	s0,176(sp)
    80005642:	f526                	sd	s1,168(sp)
    80005644:	f14a                	sd	s2,160(sp)
    80005646:	ed4e                	sd	s3,152(sp)
    80005648:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000564a:	08000613          	li	a2,128
    8000564e:	f5040593          	addi	a1,s0,-176
    80005652:	4501                	li	a0,0
    80005654:	ffffd097          	auipc	ra,0xffffd
    80005658:	53a080e7          	jalr	1338(ra) # 80002b8e <argstr>
    return -1;
    8000565c:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000565e:	0a054763          	bltz	a0,8000570c <sys_open+0xd0>
    80005662:	f4c40593          	addi	a1,s0,-180
    80005666:	4505                	li	a0,1
    80005668:	ffffd097          	auipc	ra,0xffffd
    8000566c:	4e2080e7          	jalr	1250(ra) # 80002b4a <argint>
    80005670:	08054e63          	bltz	a0,8000570c <sys_open+0xd0>

  begin_op();
    80005674:	fffff097          	auipc	ra,0xfffff
    80005678:	9de080e7          	jalr	-1570(ra) # 80004052 <begin_op>

  if(omode & O_CREATE){
    8000567c:	f4c42783          	lw	a5,-180(s0)
    80005680:	2007f793          	andi	a5,a5,512
    80005684:	c3cd                	beqz	a5,80005726 <sys_open+0xea>
    ip = create(path, T_FILE, 0, 0);
    80005686:	4681                	li	a3,0
    80005688:	4601                	li	a2,0
    8000568a:	4589                	li	a1,2
    8000568c:	f5040513          	addi	a0,s0,-176
    80005690:	00000097          	auipc	ra,0x0
    80005694:	974080e7          	jalr	-1676(ra) # 80005004 <create>
    80005698:	892a                	mv	s2,a0
    if(ip == 0){
    8000569a:	c149                	beqz	a0,8000571c <sys_open+0xe0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000569c:	04491703          	lh	a4,68(s2)
    800056a0:	478d                	li	a5,3
    800056a2:	00f71763          	bne	a4,a5,800056b0 <sys_open+0x74>
    800056a6:	04695703          	lhu	a4,70(s2)
    800056aa:	47a5                	li	a5,9
    800056ac:	0ce7e263          	bltu	a5,a4,80005770 <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800056b0:	fffff097          	auipc	ra,0xfffff
    800056b4:	db8080e7          	jalr	-584(ra) # 80004468 <filealloc>
    800056b8:	89aa                	mv	s3,a0
    800056ba:	c175                	beqz	a0,8000579e <sys_open+0x162>
    800056bc:	00000097          	auipc	ra,0x0
    800056c0:	906080e7          	jalr	-1786(ra) # 80004fc2 <fdalloc>
    800056c4:	84aa                	mv	s1,a0
    800056c6:	0c054763          	bltz	a0,80005794 <sys_open+0x158>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800056ca:	04491703          	lh	a4,68(s2)
    800056ce:	478d                	li	a5,3
    800056d0:	0af70b63          	beq	a4,a5,80005786 <sys_open+0x14a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800056d4:	4789                	li	a5,2
    800056d6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800056da:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800056de:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    800056e2:	f4c42783          	lw	a5,-180(s0)
    800056e6:	0017c713          	xori	a4,a5,1
    800056ea:	8b05                	andi	a4,a4,1
    800056ec:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800056f0:	8b8d                	andi	a5,a5,3
    800056f2:	00f037b3          	snez	a5,a5
    800056f6:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
    800056fa:	854a                	mv	a0,s2
    800056fc:	ffffe097          	auipc	ra,0xffffe
    80005700:	082080e7          	jalr	130(ra) # 8000377e <iunlock>
  end_op();
    80005704:	fffff097          	auipc	ra,0xfffff
    80005708:	9ce080e7          	jalr	-1586(ra) # 800040d2 <end_op>

  return fd;
}
    8000570c:	8526                	mv	a0,s1
    8000570e:	70ea                	ld	ra,184(sp)
    80005710:	744a                	ld	s0,176(sp)
    80005712:	74aa                	ld	s1,168(sp)
    80005714:	790a                	ld	s2,160(sp)
    80005716:	69ea                	ld	s3,152(sp)
    80005718:	6129                	addi	sp,sp,192
    8000571a:	8082                	ret
      end_op();
    8000571c:	fffff097          	auipc	ra,0xfffff
    80005720:	9b6080e7          	jalr	-1610(ra) # 800040d2 <end_op>
      return -1;
    80005724:	b7e5                	j	8000570c <sys_open+0xd0>
    if((ip = namei(path)) == 0){
    80005726:	f5040513          	addi	a0,s0,-176
    8000572a:	ffffe097          	auipc	ra,0xffffe
    8000572e:	71c080e7          	jalr	1820(ra) # 80003e46 <namei>
    80005732:	892a                	mv	s2,a0
    80005734:	c905                	beqz	a0,80005764 <sys_open+0x128>
    ilock(ip);
    80005736:	ffffe097          	auipc	ra,0xffffe
    8000573a:	f86080e7          	jalr	-122(ra) # 800036bc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000573e:	04491703          	lh	a4,68(s2)
    80005742:	4785                	li	a5,1
    80005744:	f4f71ce3          	bne	a4,a5,8000569c <sys_open+0x60>
    80005748:	f4c42783          	lw	a5,-180(s0)
    8000574c:	d3b5                	beqz	a5,800056b0 <sys_open+0x74>
      iunlockput(ip);
    8000574e:	854a                	mv	a0,s2
    80005750:	ffffe097          	auipc	ra,0xffffe
    80005754:	1aa080e7          	jalr	426(ra) # 800038fa <iunlockput>
      end_op();
    80005758:	fffff097          	auipc	ra,0xfffff
    8000575c:	97a080e7          	jalr	-1670(ra) # 800040d2 <end_op>
      return -1;
    80005760:	54fd                	li	s1,-1
    80005762:	b76d                	j	8000570c <sys_open+0xd0>
      end_op();
    80005764:	fffff097          	auipc	ra,0xfffff
    80005768:	96e080e7          	jalr	-1682(ra) # 800040d2 <end_op>
      return -1;
    8000576c:	54fd                	li	s1,-1
    8000576e:	bf79                	j	8000570c <sys_open+0xd0>
    iunlockput(ip);
    80005770:	854a                	mv	a0,s2
    80005772:	ffffe097          	auipc	ra,0xffffe
    80005776:	188080e7          	jalr	392(ra) # 800038fa <iunlockput>
    end_op();
    8000577a:	fffff097          	auipc	ra,0xfffff
    8000577e:	958080e7          	jalr	-1704(ra) # 800040d2 <end_op>
    return -1;
    80005782:	54fd                	li	s1,-1
    80005784:	b761                	j	8000570c <sys_open+0xd0>
    f->type = FD_DEVICE;
    80005786:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    8000578a:	04691783          	lh	a5,70(s2)
    8000578e:	02f99223          	sh	a5,36(s3)
    80005792:	b7b1                	j	800056de <sys_open+0xa2>
      fileclose(f);
    80005794:	854e                	mv	a0,s3
    80005796:	fffff097          	auipc	ra,0xfffff
    8000579a:	d8e080e7          	jalr	-626(ra) # 80004524 <fileclose>
    iunlockput(ip);
    8000579e:	854a                	mv	a0,s2
    800057a0:	ffffe097          	auipc	ra,0xffffe
    800057a4:	15a080e7          	jalr	346(ra) # 800038fa <iunlockput>
    end_op();
    800057a8:	fffff097          	auipc	ra,0xfffff
    800057ac:	92a080e7          	jalr	-1750(ra) # 800040d2 <end_op>
    return -1;
    800057b0:	54fd                	li	s1,-1
    800057b2:	bfa9                	j	8000570c <sys_open+0xd0>

00000000800057b4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800057b4:	7175                	addi	sp,sp,-144
    800057b6:	e506                	sd	ra,136(sp)
    800057b8:	e122                	sd	s0,128(sp)
    800057ba:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800057bc:	fffff097          	auipc	ra,0xfffff
    800057c0:	896080e7          	jalr	-1898(ra) # 80004052 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800057c4:	08000613          	li	a2,128
    800057c8:	f7040593          	addi	a1,s0,-144
    800057cc:	4501                	li	a0,0
    800057ce:	ffffd097          	auipc	ra,0xffffd
    800057d2:	3c0080e7          	jalr	960(ra) # 80002b8e <argstr>
    800057d6:	02054963          	bltz	a0,80005808 <sys_mkdir+0x54>
    800057da:	4681                	li	a3,0
    800057dc:	4601                	li	a2,0
    800057de:	4585                	li	a1,1
    800057e0:	f7040513          	addi	a0,s0,-144
    800057e4:	00000097          	auipc	ra,0x0
    800057e8:	820080e7          	jalr	-2016(ra) # 80005004 <create>
    800057ec:	cd11                	beqz	a0,80005808 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800057ee:	ffffe097          	auipc	ra,0xffffe
    800057f2:	10c080e7          	jalr	268(ra) # 800038fa <iunlockput>
  end_op();
    800057f6:	fffff097          	auipc	ra,0xfffff
    800057fa:	8dc080e7          	jalr	-1828(ra) # 800040d2 <end_op>
  return 0;
    800057fe:	4501                	li	a0,0
}
    80005800:	60aa                	ld	ra,136(sp)
    80005802:	640a                	ld	s0,128(sp)
    80005804:	6149                	addi	sp,sp,144
    80005806:	8082                	ret
    end_op();
    80005808:	fffff097          	auipc	ra,0xfffff
    8000580c:	8ca080e7          	jalr	-1846(ra) # 800040d2 <end_op>
    return -1;
    80005810:	557d                	li	a0,-1
    80005812:	b7fd                	j	80005800 <sys_mkdir+0x4c>

0000000080005814 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005814:	7135                	addi	sp,sp,-160
    80005816:	ed06                	sd	ra,152(sp)
    80005818:	e922                	sd	s0,144(sp)
    8000581a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000581c:	fffff097          	auipc	ra,0xfffff
    80005820:	836080e7          	jalr	-1994(ra) # 80004052 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005824:	08000613          	li	a2,128
    80005828:	f7040593          	addi	a1,s0,-144
    8000582c:	4501                	li	a0,0
    8000582e:	ffffd097          	auipc	ra,0xffffd
    80005832:	360080e7          	jalr	864(ra) # 80002b8e <argstr>
    80005836:	04054a63          	bltz	a0,8000588a <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    8000583a:	f6c40593          	addi	a1,s0,-148
    8000583e:	4505                	li	a0,1
    80005840:	ffffd097          	auipc	ra,0xffffd
    80005844:	30a080e7          	jalr	778(ra) # 80002b4a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005848:	04054163          	bltz	a0,8000588a <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    8000584c:	f6840593          	addi	a1,s0,-152
    80005850:	4509                	li	a0,2
    80005852:	ffffd097          	auipc	ra,0xffffd
    80005856:	2f8080e7          	jalr	760(ra) # 80002b4a <argint>
     argint(1, &major) < 0 ||
    8000585a:	02054863          	bltz	a0,8000588a <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000585e:	f6841683          	lh	a3,-152(s0)
    80005862:	f6c41603          	lh	a2,-148(s0)
    80005866:	458d                	li	a1,3
    80005868:	f7040513          	addi	a0,s0,-144
    8000586c:	fffff097          	auipc	ra,0xfffff
    80005870:	798080e7          	jalr	1944(ra) # 80005004 <create>
     argint(2, &minor) < 0 ||
    80005874:	c919                	beqz	a0,8000588a <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005876:	ffffe097          	auipc	ra,0xffffe
    8000587a:	084080e7          	jalr	132(ra) # 800038fa <iunlockput>
  end_op();
    8000587e:	fffff097          	auipc	ra,0xfffff
    80005882:	854080e7          	jalr	-1964(ra) # 800040d2 <end_op>
  return 0;
    80005886:	4501                	li	a0,0
    80005888:	a031                	j	80005894 <sys_mknod+0x80>
    end_op();
    8000588a:	fffff097          	auipc	ra,0xfffff
    8000588e:	848080e7          	jalr	-1976(ra) # 800040d2 <end_op>
    return -1;
    80005892:	557d                	li	a0,-1
}
    80005894:	60ea                	ld	ra,152(sp)
    80005896:	644a                	ld	s0,144(sp)
    80005898:	610d                	addi	sp,sp,160
    8000589a:	8082                	ret

000000008000589c <sys_chdir>:

uint64
sys_chdir(void)
{
    8000589c:	7135                	addi	sp,sp,-160
    8000589e:	ed06                	sd	ra,152(sp)
    800058a0:	e922                	sd	s0,144(sp)
    800058a2:	e526                	sd	s1,136(sp)
    800058a4:	e14a                	sd	s2,128(sp)
    800058a6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800058a8:	ffffc097          	auipc	ra,0xffffc
    800058ac:	216080e7          	jalr	534(ra) # 80001abe <myproc>
    800058b0:	892a                	mv	s2,a0
  
  begin_op();
    800058b2:	ffffe097          	auipc	ra,0xffffe
    800058b6:	7a0080e7          	jalr	1952(ra) # 80004052 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800058ba:	08000613          	li	a2,128
    800058be:	f6040593          	addi	a1,s0,-160
    800058c2:	4501                	li	a0,0
    800058c4:	ffffd097          	auipc	ra,0xffffd
    800058c8:	2ca080e7          	jalr	714(ra) # 80002b8e <argstr>
    800058cc:	04054b63          	bltz	a0,80005922 <sys_chdir+0x86>
    800058d0:	f6040513          	addi	a0,s0,-160
    800058d4:	ffffe097          	auipc	ra,0xffffe
    800058d8:	572080e7          	jalr	1394(ra) # 80003e46 <namei>
    800058dc:	84aa                	mv	s1,a0
    800058de:	c131                	beqz	a0,80005922 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800058e0:	ffffe097          	auipc	ra,0xffffe
    800058e4:	ddc080e7          	jalr	-548(ra) # 800036bc <ilock>
  if(ip->type != T_DIR){
    800058e8:	04449703          	lh	a4,68(s1)
    800058ec:	4785                	li	a5,1
    800058ee:	04f71063          	bne	a4,a5,8000592e <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800058f2:	8526                	mv	a0,s1
    800058f4:	ffffe097          	auipc	ra,0xffffe
    800058f8:	e8a080e7          	jalr	-374(ra) # 8000377e <iunlock>
  iput(p->cwd);
    800058fc:	15093503          	ld	a0,336(s2)
    80005900:	ffffe097          	auipc	ra,0xffffe
    80005904:	eca080e7          	jalr	-310(ra) # 800037ca <iput>
  end_op();
    80005908:	ffffe097          	auipc	ra,0xffffe
    8000590c:	7ca080e7          	jalr	1994(ra) # 800040d2 <end_op>
  p->cwd = ip;
    80005910:	14993823          	sd	s1,336(s2)
  return 0;
    80005914:	4501                	li	a0,0
}
    80005916:	60ea                	ld	ra,152(sp)
    80005918:	644a                	ld	s0,144(sp)
    8000591a:	64aa                	ld	s1,136(sp)
    8000591c:	690a                	ld	s2,128(sp)
    8000591e:	610d                	addi	sp,sp,160
    80005920:	8082                	ret
    end_op();
    80005922:	ffffe097          	auipc	ra,0xffffe
    80005926:	7b0080e7          	jalr	1968(ra) # 800040d2 <end_op>
    return -1;
    8000592a:	557d                	li	a0,-1
    8000592c:	b7ed                	j	80005916 <sys_chdir+0x7a>
    iunlockput(ip);
    8000592e:	8526                	mv	a0,s1
    80005930:	ffffe097          	auipc	ra,0xffffe
    80005934:	fca080e7          	jalr	-54(ra) # 800038fa <iunlockput>
    end_op();
    80005938:	ffffe097          	auipc	ra,0xffffe
    8000593c:	79a080e7          	jalr	1946(ra) # 800040d2 <end_op>
    return -1;
    80005940:	557d                	li	a0,-1
    80005942:	bfd1                	j	80005916 <sys_chdir+0x7a>

0000000080005944 <sys_exec>:

uint64
sys_exec(void)
{
    80005944:	7145                	addi	sp,sp,-464
    80005946:	e786                	sd	ra,456(sp)
    80005948:	e3a2                	sd	s0,448(sp)
    8000594a:	ff26                	sd	s1,440(sp)
    8000594c:	fb4a                	sd	s2,432(sp)
    8000594e:	f74e                	sd	s3,424(sp)
    80005950:	f352                	sd	s4,416(sp)
    80005952:	ef56                	sd	s5,408(sp)
    80005954:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005956:	08000613          	li	a2,128
    8000595a:	f4040593          	addi	a1,s0,-192
    8000595e:	4501                	li	a0,0
    80005960:	ffffd097          	auipc	ra,0xffffd
    80005964:	22e080e7          	jalr	558(ra) # 80002b8e <argstr>
    80005968:	0e054663          	bltz	a0,80005a54 <sys_exec+0x110>
    8000596c:	e3840593          	addi	a1,s0,-456
    80005970:	4505                	li	a0,1
    80005972:	ffffd097          	auipc	ra,0xffffd
    80005976:	1fa080e7          	jalr	506(ra) # 80002b6c <argaddr>
    8000597a:	0e054763          	bltz	a0,80005a68 <sys_exec+0x124>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    8000597e:	10000613          	li	a2,256
    80005982:	4581                	li	a1,0
    80005984:	e4040513          	addi	a0,s0,-448
    80005988:	ffffb097          	auipc	ra,0xffffb
    8000598c:	1e6080e7          	jalr	486(ra) # 80000b6e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005990:	e4040913          	addi	s2,s0,-448
  memset(argv, 0, sizeof(argv));
    80005994:	89ca                	mv	s3,s2
    80005996:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    80005998:	02000a13          	li	s4,32
    8000599c:	00048a9b          	sext.w	s5,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800059a0:	00349513          	slli	a0,s1,0x3
    800059a4:	e3040593          	addi	a1,s0,-464
    800059a8:	e3843783          	ld	a5,-456(s0)
    800059ac:	953e                	add	a0,a0,a5
    800059ae:	ffffd097          	auipc	ra,0xffffd
    800059b2:	102080e7          	jalr	258(ra) # 80002ab0 <fetchaddr>
    800059b6:	02054a63          	bltz	a0,800059ea <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    800059ba:	e3043783          	ld	a5,-464(s0)
    800059be:	c7a1                	beqz	a5,80005a06 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800059c0:	ffffb097          	auipc	ra,0xffffb
    800059c4:	fa0080e7          	jalr	-96(ra) # 80000960 <kalloc>
    800059c8:	85aa                	mv	a1,a0
    800059ca:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800059ce:	c92d                	beqz	a0,80005a40 <sys_exec+0xfc>
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
    800059d0:	6605                	lui	a2,0x1
    800059d2:	e3043503          	ld	a0,-464(s0)
    800059d6:	ffffd097          	auipc	ra,0xffffd
    800059da:	12c080e7          	jalr	300(ra) # 80002b02 <fetchstr>
    800059de:	00054663          	bltz	a0,800059ea <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    800059e2:	0485                	addi	s1,s1,1
    800059e4:	09a1                	addi	s3,s3,8
    800059e6:	fb449be3          	bne	s1,s4,8000599c <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800059ea:	10090493          	addi	s1,s2,256
    800059ee:	00093503          	ld	a0,0(s2)
    800059f2:	cd39                	beqz	a0,80005a50 <sys_exec+0x10c>
    kfree(argv[i]);
    800059f4:	ffffb097          	auipc	ra,0xffffb
    800059f8:	e70080e7          	jalr	-400(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800059fc:	0921                	addi	s2,s2,8
    800059fe:	fe9918e3          	bne	s2,s1,800059ee <sys_exec+0xaa>
  return -1;
    80005a02:	557d                	li	a0,-1
    80005a04:	a889                	j	80005a56 <sys_exec+0x112>
      argv[i] = 0;
    80005a06:	0a8e                	slli	s5,s5,0x3
    80005a08:	fc040793          	addi	a5,s0,-64
    80005a0c:	9abe                	add	s5,s5,a5
    80005a0e:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8e64>
  int ret = exec(path, argv);
    80005a12:	e4040593          	addi	a1,s0,-448
    80005a16:	f4040513          	addi	a0,s0,-192
    80005a1a:	fffff097          	auipc	ra,0xfffff
    80005a1e:	1ac080e7          	jalr	428(ra) # 80004bc6 <exec>
    80005a22:	84aa                	mv	s1,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a24:	10090993          	addi	s3,s2,256
    80005a28:	00093503          	ld	a0,0(s2)
    80005a2c:	c901                	beqz	a0,80005a3c <sys_exec+0xf8>
    kfree(argv[i]);
    80005a2e:	ffffb097          	auipc	ra,0xffffb
    80005a32:	e36080e7          	jalr	-458(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a36:	0921                	addi	s2,s2,8
    80005a38:	ff3918e3          	bne	s2,s3,80005a28 <sys_exec+0xe4>
  return ret;
    80005a3c:	8526                	mv	a0,s1
    80005a3e:	a821                	j	80005a56 <sys_exec+0x112>
      panic("sys_exec kalloc");
    80005a40:	00002517          	auipc	a0,0x2
    80005a44:	e3050513          	addi	a0,a0,-464 # 80007870 <userret+0x7e0>
    80005a48:	ffffb097          	auipc	ra,0xffffb
    80005a4c:	b06080e7          	jalr	-1274(ra) # 8000054e <panic>
  return -1;
    80005a50:	557d                	li	a0,-1
    80005a52:	a011                	j	80005a56 <sys_exec+0x112>
    return -1;
    80005a54:	557d                	li	a0,-1
}
    80005a56:	60be                	ld	ra,456(sp)
    80005a58:	641e                	ld	s0,448(sp)
    80005a5a:	74fa                	ld	s1,440(sp)
    80005a5c:	795a                	ld	s2,432(sp)
    80005a5e:	79ba                	ld	s3,424(sp)
    80005a60:	7a1a                	ld	s4,416(sp)
    80005a62:	6afa                	ld	s5,408(sp)
    80005a64:	6179                	addi	sp,sp,464
    80005a66:	8082                	ret
    return -1;
    80005a68:	557d                	li	a0,-1
    80005a6a:	b7f5                	j	80005a56 <sys_exec+0x112>

0000000080005a6c <sys_pipe>:

uint64
sys_pipe(void)
{
    80005a6c:	7139                	addi	sp,sp,-64
    80005a6e:	fc06                	sd	ra,56(sp)
    80005a70:	f822                	sd	s0,48(sp)
    80005a72:	f426                	sd	s1,40(sp)
    80005a74:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005a76:	ffffc097          	auipc	ra,0xffffc
    80005a7a:	048080e7          	jalr	72(ra) # 80001abe <myproc>
    80005a7e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005a80:	fd840593          	addi	a1,s0,-40
    80005a84:	4501                	li	a0,0
    80005a86:	ffffd097          	auipc	ra,0xffffd
    80005a8a:	0e6080e7          	jalr	230(ra) # 80002b6c <argaddr>
    return -1;
    80005a8e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005a90:	0e054063          	bltz	a0,80005b70 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005a94:	fc840593          	addi	a1,s0,-56
    80005a98:	fd040513          	addi	a0,s0,-48
    80005a9c:	fffff097          	auipc	ra,0xfffff
    80005aa0:	dde080e7          	jalr	-546(ra) # 8000487a <pipealloc>
    return -1;
    80005aa4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005aa6:	0c054563          	bltz	a0,80005b70 <sys_pipe+0x104>
  fd0 = -1;
    80005aaa:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005aae:	fd043503          	ld	a0,-48(s0)
    80005ab2:	fffff097          	auipc	ra,0xfffff
    80005ab6:	510080e7          	jalr	1296(ra) # 80004fc2 <fdalloc>
    80005aba:	fca42223          	sw	a0,-60(s0)
    80005abe:	08054c63          	bltz	a0,80005b56 <sys_pipe+0xea>
    80005ac2:	fc843503          	ld	a0,-56(s0)
    80005ac6:	fffff097          	auipc	ra,0xfffff
    80005aca:	4fc080e7          	jalr	1276(ra) # 80004fc2 <fdalloc>
    80005ace:	fca42023          	sw	a0,-64(s0)
    80005ad2:	06054863          	bltz	a0,80005b42 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ad6:	4691                	li	a3,4
    80005ad8:	fc440613          	addi	a2,s0,-60
    80005adc:	fd843583          	ld	a1,-40(s0)
    80005ae0:	68a8                	ld	a0,80(s1)
    80005ae2:	ffffc097          	auipc	ra,0xffffc
    80005ae6:	a56080e7          	jalr	-1450(ra) # 80001538 <copyout>
    80005aea:	02054063          	bltz	a0,80005b0a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005aee:	4691                	li	a3,4
    80005af0:	fc040613          	addi	a2,s0,-64
    80005af4:	fd843583          	ld	a1,-40(s0)
    80005af8:	0591                	addi	a1,a1,4
    80005afa:	68a8                	ld	a0,80(s1)
    80005afc:	ffffc097          	auipc	ra,0xffffc
    80005b00:	a3c080e7          	jalr	-1476(ra) # 80001538 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005b04:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b06:	06055563          	bgez	a0,80005b70 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005b0a:	fc442783          	lw	a5,-60(s0)
    80005b0e:	07e9                	addi	a5,a5,26
    80005b10:	078e                	slli	a5,a5,0x3
    80005b12:	97a6                	add	a5,a5,s1
    80005b14:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005b18:	fc042503          	lw	a0,-64(s0)
    80005b1c:	0569                	addi	a0,a0,26
    80005b1e:	050e                	slli	a0,a0,0x3
    80005b20:	9526                	add	a0,a0,s1
    80005b22:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005b26:	fd043503          	ld	a0,-48(s0)
    80005b2a:	fffff097          	auipc	ra,0xfffff
    80005b2e:	9fa080e7          	jalr	-1542(ra) # 80004524 <fileclose>
    fileclose(wf);
    80005b32:	fc843503          	ld	a0,-56(s0)
    80005b36:	fffff097          	auipc	ra,0xfffff
    80005b3a:	9ee080e7          	jalr	-1554(ra) # 80004524 <fileclose>
    return -1;
    80005b3e:	57fd                	li	a5,-1
    80005b40:	a805                	j	80005b70 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005b42:	fc442783          	lw	a5,-60(s0)
    80005b46:	0007c863          	bltz	a5,80005b56 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005b4a:	01a78513          	addi	a0,a5,26
    80005b4e:	050e                	slli	a0,a0,0x3
    80005b50:	9526                	add	a0,a0,s1
    80005b52:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005b56:	fd043503          	ld	a0,-48(s0)
    80005b5a:	fffff097          	auipc	ra,0xfffff
    80005b5e:	9ca080e7          	jalr	-1590(ra) # 80004524 <fileclose>
    fileclose(wf);
    80005b62:	fc843503          	ld	a0,-56(s0)
    80005b66:	fffff097          	auipc	ra,0xfffff
    80005b6a:	9be080e7          	jalr	-1602(ra) # 80004524 <fileclose>
    return -1;
    80005b6e:	57fd                	li	a5,-1
}
    80005b70:	853e                	mv	a0,a5
    80005b72:	70e2                	ld	ra,56(sp)
    80005b74:	7442                	ld	s0,48(sp)
    80005b76:	74a2                	ld	s1,40(sp)
    80005b78:	6121                	addi	sp,sp,64
    80005b7a:	8082                	ret
    80005b7c:	0000                	unimp
	...

0000000080005b80 <kernelvec>:
    80005b80:	7111                	addi	sp,sp,-256
    80005b82:	e006                	sd	ra,0(sp)
    80005b84:	e40a                	sd	sp,8(sp)
    80005b86:	e80e                	sd	gp,16(sp)
    80005b88:	ec12                	sd	tp,24(sp)
    80005b8a:	f016                	sd	t0,32(sp)
    80005b8c:	f41a                	sd	t1,40(sp)
    80005b8e:	f81e                	sd	t2,48(sp)
    80005b90:	fc22                	sd	s0,56(sp)
    80005b92:	e0a6                	sd	s1,64(sp)
    80005b94:	e4aa                	sd	a0,72(sp)
    80005b96:	e8ae                	sd	a1,80(sp)
    80005b98:	ecb2                	sd	a2,88(sp)
    80005b9a:	f0b6                	sd	a3,96(sp)
    80005b9c:	f4ba                	sd	a4,104(sp)
    80005b9e:	f8be                	sd	a5,112(sp)
    80005ba0:	fcc2                	sd	a6,120(sp)
    80005ba2:	e146                	sd	a7,128(sp)
    80005ba4:	e54a                	sd	s2,136(sp)
    80005ba6:	e94e                	sd	s3,144(sp)
    80005ba8:	ed52                	sd	s4,152(sp)
    80005baa:	f156                	sd	s5,160(sp)
    80005bac:	f55a                	sd	s6,168(sp)
    80005bae:	f95e                	sd	s7,176(sp)
    80005bb0:	fd62                	sd	s8,184(sp)
    80005bb2:	e1e6                	sd	s9,192(sp)
    80005bb4:	e5ea                	sd	s10,200(sp)
    80005bb6:	e9ee                	sd	s11,208(sp)
    80005bb8:	edf2                	sd	t3,216(sp)
    80005bba:	f1f6                	sd	t4,224(sp)
    80005bbc:	f5fa                	sd	t5,232(sp)
    80005bbe:	f9fe                	sd	t6,240(sp)
    80005bc0:	dbdfc0ef          	jal	ra,8000297c <kerneltrap>
    80005bc4:	6082                	ld	ra,0(sp)
    80005bc6:	6122                	ld	sp,8(sp)
    80005bc8:	61c2                	ld	gp,16(sp)
    80005bca:	7282                	ld	t0,32(sp)
    80005bcc:	7322                	ld	t1,40(sp)
    80005bce:	73c2                	ld	t2,48(sp)
    80005bd0:	7462                	ld	s0,56(sp)
    80005bd2:	6486                	ld	s1,64(sp)
    80005bd4:	6526                	ld	a0,72(sp)
    80005bd6:	65c6                	ld	a1,80(sp)
    80005bd8:	6666                	ld	a2,88(sp)
    80005bda:	7686                	ld	a3,96(sp)
    80005bdc:	7726                	ld	a4,104(sp)
    80005bde:	77c6                	ld	a5,112(sp)
    80005be0:	7866                	ld	a6,120(sp)
    80005be2:	688a                	ld	a7,128(sp)
    80005be4:	692a                	ld	s2,136(sp)
    80005be6:	69ca                	ld	s3,144(sp)
    80005be8:	6a6a                	ld	s4,152(sp)
    80005bea:	7a8a                	ld	s5,160(sp)
    80005bec:	7b2a                	ld	s6,168(sp)
    80005bee:	7bca                	ld	s7,176(sp)
    80005bf0:	7c6a                	ld	s8,184(sp)
    80005bf2:	6c8e                	ld	s9,192(sp)
    80005bf4:	6d2e                	ld	s10,200(sp)
    80005bf6:	6dce                	ld	s11,208(sp)
    80005bf8:	6e6e                	ld	t3,216(sp)
    80005bfa:	7e8e                	ld	t4,224(sp)
    80005bfc:	7f2e                	ld	t5,232(sp)
    80005bfe:	7fce                	ld	t6,240(sp)
    80005c00:	6111                	addi	sp,sp,256
    80005c02:	10200073          	sret
    80005c06:	00000013          	nop
    80005c0a:	00000013          	nop
    80005c0e:	0001                	nop

0000000080005c10 <timervec>:
    80005c10:	34051573          	csrrw	a0,mscratch,a0
    80005c14:	e10c                	sd	a1,0(a0)
    80005c16:	e510                	sd	a2,8(a0)
    80005c18:	e914                	sd	a3,16(a0)
    80005c1a:	710c                	ld	a1,32(a0)
    80005c1c:	7510                	ld	a2,40(a0)
    80005c1e:	6194                	ld	a3,0(a1)
    80005c20:	96b2                	add	a3,a3,a2
    80005c22:	e194                	sd	a3,0(a1)
    80005c24:	4589                	li	a1,2
    80005c26:	14459073          	csrw	sip,a1
    80005c2a:	6914                	ld	a3,16(a0)
    80005c2c:	6510                	ld	a2,8(a0)
    80005c2e:	610c                	ld	a1,0(a0)
    80005c30:	34051573          	csrrw	a0,mscratch,a0
    80005c34:	30200073          	mret
	...

0000000080005c3a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005c3a:	1141                	addi	sp,sp,-16
    80005c3c:	e422                	sd	s0,8(sp)
    80005c3e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005c40:	0c0007b7          	lui	a5,0xc000
    80005c44:	4705                	li	a4,1
    80005c46:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005c48:	c3d8                	sw	a4,4(a5)
}
    80005c4a:	6422                	ld	s0,8(sp)
    80005c4c:	0141                	addi	sp,sp,16
    80005c4e:	8082                	ret

0000000080005c50 <plicinithart>:

void
plicinithart(void)
{
    80005c50:	1141                	addi	sp,sp,-16
    80005c52:	e406                	sd	ra,8(sp)
    80005c54:	e022                	sd	s0,0(sp)
    80005c56:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005c58:	ffffc097          	auipc	ra,0xffffc
    80005c5c:	e3a080e7          	jalr	-454(ra) # 80001a92 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005c60:	0085171b          	slliw	a4,a0,0x8
    80005c64:	0c0027b7          	lui	a5,0xc002
    80005c68:	97ba                	add	a5,a5,a4
    80005c6a:	40200713          	li	a4,1026
    80005c6e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005c72:	00d5151b          	slliw	a0,a0,0xd
    80005c76:	0c2017b7          	lui	a5,0xc201
    80005c7a:	953e                	add	a0,a0,a5
    80005c7c:	00052023          	sw	zero,0(a0)
}
    80005c80:	60a2                	ld	ra,8(sp)
    80005c82:	6402                	ld	s0,0(sp)
    80005c84:	0141                	addi	sp,sp,16
    80005c86:	8082                	ret

0000000080005c88 <plic_pending>:

// return a bitmap of which IRQs are waiting
// to be served.
uint64
plic_pending(void)
{
    80005c88:	1141                	addi	sp,sp,-16
    80005c8a:	e422                	sd	s0,8(sp)
    80005c8c:	0800                	addi	s0,sp,16
  //mask = *(uint32*)(PLIC + 0x1000);
  //mask |= (uint64)*(uint32*)(PLIC + 0x1004) << 32;
  mask = *(uint64*)PLIC_PENDING;

  return mask;
}
    80005c8e:	0c0017b7          	lui	a5,0xc001
    80005c92:	6388                	ld	a0,0(a5)
    80005c94:	6422                	ld	s0,8(sp)
    80005c96:	0141                	addi	sp,sp,16
    80005c98:	8082                	ret

0000000080005c9a <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005c9a:	1141                	addi	sp,sp,-16
    80005c9c:	e406                	sd	ra,8(sp)
    80005c9e:	e022                	sd	s0,0(sp)
    80005ca0:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005ca2:	ffffc097          	auipc	ra,0xffffc
    80005ca6:	df0080e7          	jalr	-528(ra) # 80001a92 <cpuid>
  //int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005caa:	00d5179b          	slliw	a5,a0,0xd
    80005cae:	0c201537          	lui	a0,0xc201
    80005cb2:	953e                	add	a0,a0,a5
  return irq;
}
    80005cb4:	4148                	lw	a0,4(a0)
    80005cb6:	60a2                	ld	ra,8(sp)
    80005cb8:	6402                	ld	s0,0(sp)
    80005cba:	0141                	addi	sp,sp,16
    80005cbc:	8082                	ret

0000000080005cbe <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005cbe:	1101                	addi	sp,sp,-32
    80005cc0:	ec06                	sd	ra,24(sp)
    80005cc2:	e822                	sd	s0,16(sp)
    80005cc4:	e426                	sd	s1,8(sp)
    80005cc6:	1000                	addi	s0,sp,32
    80005cc8:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005cca:	ffffc097          	auipc	ra,0xffffc
    80005cce:	dc8080e7          	jalr	-568(ra) # 80001a92 <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005cd2:	00d5151b          	slliw	a0,a0,0xd
    80005cd6:	0c2017b7          	lui	a5,0xc201
    80005cda:	97aa                	add	a5,a5,a0
    80005cdc:	c3c4                	sw	s1,4(a5)
}
    80005cde:	60e2                	ld	ra,24(sp)
    80005ce0:	6442                	ld	s0,16(sp)
    80005ce2:	64a2                	ld	s1,8(sp)
    80005ce4:	6105                	addi	sp,sp,32
    80005ce6:	8082                	ret

0000000080005ce8 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005ce8:	1141                	addi	sp,sp,-16
    80005cea:	e406                	sd	ra,8(sp)
    80005cec:	e022                	sd	s0,0(sp)
    80005cee:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005cf0:	479d                	li	a5,7
    80005cf2:	04a7cc63          	blt	a5,a0,80005d4a <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005cf6:	0001d797          	auipc	a5,0x1d
    80005cfa:	30a78793          	addi	a5,a5,778 # 80023000 <disk>
    80005cfe:	00a78733          	add	a4,a5,a0
    80005d02:	6789                	lui	a5,0x2
    80005d04:	97ba                	add	a5,a5,a4
    80005d06:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005d0a:	eba1                	bnez	a5,80005d5a <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005d0c:	00451713          	slli	a4,a0,0x4
    80005d10:	0001f797          	auipc	a5,0x1f
    80005d14:	2f07b783          	ld	a5,752(a5) # 80025000 <disk+0x2000>
    80005d18:	97ba                	add	a5,a5,a4
    80005d1a:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005d1e:	0001d797          	auipc	a5,0x1d
    80005d22:	2e278793          	addi	a5,a5,738 # 80023000 <disk>
    80005d26:	97aa                	add	a5,a5,a0
    80005d28:	6509                	lui	a0,0x2
    80005d2a:	953e                	add	a0,a0,a5
    80005d2c:	4785                	li	a5,1
    80005d2e:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005d32:	0001f517          	auipc	a0,0x1f
    80005d36:	2e650513          	addi	a0,a0,742 # 80025018 <disk+0x2018>
    80005d3a:	ffffc097          	auipc	ra,0xffffc
    80005d3e:	6b0080e7          	jalr	1712(ra) # 800023ea <wakeup>
}
    80005d42:	60a2                	ld	ra,8(sp)
    80005d44:	6402                	ld	s0,0(sp)
    80005d46:	0141                	addi	sp,sp,16
    80005d48:	8082                	ret
    panic("virtio_disk_intr 1");
    80005d4a:	00002517          	auipc	a0,0x2
    80005d4e:	b3650513          	addi	a0,a0,-1226 # 80007880 <userret+0x7f0>
    80005d52:	ffffa097          	auipc	ra,0xffffa
    80005d56:	7fc080e7          	jalr	2044(ra) # 8000054e <panic>
    panic("virtio_disk_intr 2");
    80005d5a:	00002517          	auipc	a0,0x2
    80005d5e:	b3e50513          	addi	a0,a0,-1218 # 80007898 <userret+0x808>
    80005d62:	ffffa097          	auipc	ra,0xffffa
    80005d66:	7ec080e7          	jalr	2028(ra) # 8000054e <panic>

0000000080005d6a <virtio_disk_init>:
{
    80005d6a:	1101                	addi	sp,sp,-32
    80005d6c:	ec06                	sd	ra,24(sp)
    80005d6e:	e822                	sd	s0,16(sp)
    80005d70:	e426                	sd	s1,8(sp)
    80005d72:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005d74:	00002597          	auipc	a1,0x2
    80005d78:	b3c58593          	addi	a1,a1,-1220 # 800078b0 <userret+0x820>
    80005d7c:	0001f517          	auipc	a0,0x1f
    80005d80:	32c50513          	addi	a0,a0,812 # 800250a8 <disk+0x20a8>
    80005d84:	ffffb097          	auipc	ra,0xffffb
    80005d88:	c3c080e7          	jalr	-964(ra) # 800009c0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005d8c:	100017b7          	lui	a5,0x10001
    80005d90:	4398                	lw	a4,0(a5)
    80005d92:	2701                	sext.w	a4,a4
    80005d94:	747277b7          	lui	a5,0x74727
    80005d98:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005d9c:	0ef71163          	bne	a4,a5,80005e7e <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005da0:	100017b7          	lui	a5,0x10001
    80005da4:	43dc                	lw	a5,4(a5)
    80005da6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005da8:	4705                	li	a4,1
    80005daa:	0ce79a63          	bne	a5,a4,80005e7e <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005dae:	100017b7          	lui	a5,0x10001
    80005db2:	479c                	lw	a5,8(a5)
    80005db4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005db6:	4709                	li	a4,2
    80005db8:	0ce79363          	bne	a5,a4,80005e7e <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005dbc:	100017b7          	lui	a5,0x10001
    80005dc0:	47d8                	lw	a4,12(a5)
    80005dc2:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005dc4:	554d47b7          	lui	a5,0x554d4
    80005dc8:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005dcc:	0af71963          	bne	a4,a5,80005e7e <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005dd0:	100017b7          	lui	a5,0x10001
    80005dd4:	4705                	li	a4,1
    80005dd6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005dd8:	470d                	li	a4,3
    80005dda:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005ddc:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005dde:	c7ffe737          	lui	a4,0xc7ffe
    80005de2:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd8743>
    80005de6:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005de8:	2701                	sext.w	a4,a4
    80005dea:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005dec:	472d                	li	a4,11
    80005dee:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005df0:	473d                	li	a4,15
    80005df2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005df4:	6705                	lui	a4,0x1
    80005df6:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005df8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005dfc:	5bdc                	lw	a5,52(a5)
    80005dfe:	2781                	sext.w	a5,a5
  if(max == 0)
    80005e00:	c7d9                	beqz	a5,80005e8e <virtio_disk_init+0x124>
  if(max < NUM)
    80005e02:	471d                	li	a4,7
    80005e04:	08f77d63          	bgeu	a4,a5,80005e9e <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005e08:	100014b7          	lui	s1,0x10001
    80005e0c:	47a1                	li	a5,8
    80005e0e:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005e10:	6609                	lui	a2,0x2
    80005e12:	4581                	li	a1,0
    80005e14:	0001d517          	auipc	a0,0x1d
    80005e18:	1ec50513          	addi	a0,a0,492 # 80023000 <disk>
    80005e1c:	ffffb097          	auipc	ra,0xffffb
    80005e20:	d52080e7          	jalr	-686(ra) # 80000b6e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005e24:	0001d717          	auipc	a4,0x1d
    80005e28:	1dc70713          	addi	a4,a4,476 # 80023000 <disk>
    80005e2c:	00c75793          	srli	a5,a4,0xc
    80005e30:	2781                	sext.w	a5,a5
    80005e32:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80005e34:	0001f797          	auipc	a5,0x1f
    80005e38:	1cc78793          	addi	a5,a5,460 # 80025000 <disk+0x2000>
    80005e3c:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80005e3e:	0001d717          	auipc	a4,0x1d
    80005e42:	24270713          	addi	a4,a4,578 # 80023080 <disk+0x80>
    80005e46:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80005e48:	0001e717          	auipc	a4,0x1e
    80005e4c:	1b870713          	addi	a4,a4,440 # 80024000 <disk+0x1000>
    80005e50:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005e52:	4705                	li	a4,1
    80005e54:	00e78c23          	sb	a4,24(a5)
    80005e58:	00e78ca3          	sb	a4,25(a5)
    80005e5c:	00e78d23          	sb	a4,26(a5)
    80005e60:	00e78da3          	sb	a4,27(a5)
    80005e64:	00e78e23          	sb	a4,28(a5)
    80005e68:	00e78ea3          	sb	a4,29(a5)
    80005e6c:	00e78f23          	sb	a4,30(a5)
    80005e70:	00e78fa3          	sb	a4,31(a5)
}
    80005e74:	60e2                	ld	ra,24(sp)
    80005e76:	6442                	ld	s0,16(sp)
    80005e78:	64a2                	ld	s1,8(sp)
    80005e7a:	6105                	addi	sp,sp,32
    80005e7c:	8082                	ret
    panic("could not find virtio disk");
    80005e7e:	00002517          	auipc	a0,0x2
    80005e82:	a4250513          	addi	a0,a0,-1470 # 800078c0 <userret+0x830>
    80005e86:	ffffa097          	auipc	ra,0xffffa
    80005e8a:	6c8080e7          	jalr	1736(ra) # 8000054e <panic>
    panic("virtio disk has no queue 0");
    80005e8e:	00002517          	auipc	a0,0x2
    80005e92:	a5250513          	addi	a0,a0,-1454 # 800078e0 <userret+0x850>
    80005e96:	ffffa097          	auipc	ra,0xffffa
    80005e9a:	6b8080e7          	jalr	1720(ra) # 8000054e <panic>
    panic("virtio disk max queue too short");
    80005e9e:	00002517          	auipc	a0,0x2
    80005ea2:	a6250513          	addi	a0,a0,-1438 # 80007900 <userret+0x870>
    80005ea6:	ffffa097          	auipc	ra,0xffffa
    80005eaa:	6a8080e7          	jalr	1704(ra) # 8000054e <panic>

0000000080005eae <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005eae:	7119                	addi	sp,sp,-128
    80005eb0:	fc86                	sd	ra,120(sp)
    80005eb2:	f8a2                	sd	s0,112(sp)
    80005eb4:	f4a6                	sd	s1,104(sp)
    80005eb6:	f0ca                	sd	s2,96(sp)
    80005eb8:	ecce                	sd	s3,88(sp)
    80005eba:	e8d2                	sd	s4,80(sp)
    80005ebc:	e4d6                	sd	s5,72(sp)
    80005ebe:	e0da                	sd	s6,64(sp)
    80005ec0:	fc5e                	sd	s7,56(sp)
    80005ec2:	f862                	sd	s8,48(sp)
    80005ec4:	f466                	sd	s9,40(sp)
    80005ec6:	f06a                	sd	s10,32(sp)
    80005ec8:	0100                	addi	s0,sp,128
    80005eca:	892a                	mv	s2,a0
    80005ecc:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005ece:	00c52c83          	lw	s9,12(a0)
    80005ed2:	001c9c9b          	slliw	s9,s9,0x1
    80005ed6:	1c82                	slli	s9,s9,0x20
    80005ed8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005edc:	0001f517          	auipc	a0,0x1f
    80005ee0:	1cc50513          	addi	a0,a0,460 # 800250a8 <disk+0x20a8>
    80005ee4:	ffffb097          	auipc	ra,0xffffb
    80005ee8:	bee080e7          	jalr	-1042(ra) # 80000ad2 <acquire>
  for(int i = 0; i < 3; i++){
    80005eec:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005eee:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005ef0:	0001db97          	auipc	s7,0x1d
    80005ef4:	110b8b93          	addi	s7,s7,272 # 80023000 <disk>
    80005ef8:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005efa:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005efc:	8a4e                	mv	s4,s3
    80005efe:	a051                	j	80005f82 <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005f00:	00fb86b3          	add	a3,s7,a5
    80005f04:	96da                	add	a3,a3,s6
    80005f06:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005f0a:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005f0c:	0207c563          	bltz	a5,80005f36 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005f10:	2485                	addiw	s1,s1,1
    80005f12:	0711                	addi	a4,a4,4
    80005f14:	1b548863          	beq	s1,s5,800060c4 <virtio_disk_rw+0x216>
    idx[i] = alloc_desc();
    80005f18:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005f1a:	0001f697          	auipc	a3,0x1f
    80005f1e:	0fe68693          	addi	a3,a3,254 # 80025018 <disk+0x2018>
    80005f22:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005f24:	0006c583          	lbu	a1,0(a3)
    80005f28:	fde1                	bnez	a1,80005f00 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005f2a:	2785                	addiw	a5,a5,1
    80005f2c:	0685                	addi	a3,a3,1
    80005f2e:	ff879be3          	bne	a5,s8,80005f24 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005f32:	57fd                	li	a5,-1
    80005f34:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005f36:	02905a63          	blez	s1,80005f6a <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005f3a:	f9042503          	lw	a0,-112(s0)
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	daa080e7          	jalr	-598(ra) # 80005ce8 <free_desc>
      for(int j = 0; j < i; j++)
    80005f46:	4785                	li	a5,1
    80005f48:	0297d163          	bge	a5,s1,80005f6a <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005f4c:	f9442503          	lw	a0,-108(s0)
    80005f50:	00000097          	auipc	ra,0x0
    80005f54:	d98080e7          	jalr	-616(ra) # 80005ce8 <free_desc>
      for(int j = 0; j < i; j++)
    80005f58:	4789                	li	a5,2
    80005f5a:	0097d863          	bge	a5,s1,80005f6a <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005f5e:	f9842503          	lw	a0,-104(s0)
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	d86080e7          	jalr	-634(ra) # 80005ce8 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005f6a:	0001f597          	auipc	a1,0x1f
    80005f6e:	13e58593          	addi	a1,a1,318 # 800250a8 <disk+0x20a8>
    80005f72:	0001f517          	auipc	a0,0x1f
    80005f76:	0a650513          	addi	a0,a0,166 # 80025018 <disk+0x2018>
    80005f7a:	ffffc097          	auipc	ra,0xffffc
    80005f7e:	2ea080e7          	jalr	746(ra) # 80002264 <sleep>
  for(int i = 0; i < 3; i++){
    80005f82:	f9040713          	addi	a4,s0,-112
    80005f86:	84ce                	mv	s1,s3
    80005f88:	bf41                	j	80005f18 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005f8a:	0001f717          	auipc	a4,0x1f
    80005f8e:	07673703          	ld	a4,118(a4) # 80025000 <disk+0x2000>
    80005f92:	973e                	add	a4,a4,a5
    80005f94:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005f98:	0001d517          	auipc	a0,0x1d
    80005f9c:	06850513          	addi	a0,a0,104 # 80023000 <disk>
    80005fa0:	0001f717          	auipc	a4,0x1f
    80005fa4:	06070713          	addi	a4,a4,96 # 80025000 <disk+0x2000>
    80005fa8:	6310                	ld	a2,0(a4)
    80005faa:	963e                	add	a2,a2,a5
    80005fac:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80005fb0:	0015e593          	ori	a1,a1,1
    80005fb4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005fb8:	f9842683          	lw	a3,-104(s0)
    80005fbc:	6310                	ld	a2,0(a4)
    80005fbe:	97b2                	add	a5,a5,a2
    80005fc0:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    80005fc4:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    80005fc8:	0612                	slli	a2,a2,0x4
    80005fca:	962a                	add	a2,a2,a0
    80005fcc:	02060823          	sb	zero,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005fd0:	00469793          	slli	a5,a3,0x4
    80005fd4:	630c                	ld	a1,0(a4)
    80005fd6:	95be                	add	a1,a1,a5
    80005fd8:	6689                	lui	a3,0x2
    80005fda:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005fde:	96ce                	add	a3,a3,s3
    80005fe0:	96aa                	add	a3,a3,a0
    80005fe2:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    80005fe4:	6314                	ld	a3,0(a4)
    80005fe6:	96be                	add	a3,a3,a5
    80005fe8:	4585                	li	a1,1
    80005fea:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005fec:	6314                	ld	a3,0(a4)
    80005fee:	96be                	add	a3,a3,a5
    80005ff0:	4509                	li	a0,2
    80005ff2:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    80005ff6:	6314                	ld	a3,0(a4)
    80005ff8:	97b6                	add	a5,a5,a3
    80005ffa:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005ffe:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80006002:	03263423          	sd	s2,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    80006006:	6714                	ld	a3,8(a4)
    80006008:	0026d783          	lhu	a5,2(a3)
    8000600c:	8b9d                	andi	a5,a5,7
    8000600e:	2789                	addiw	a5,a5,2
    80006010:	0786                	slli	a5,a5,0x1
    80006012:	97b6                	add	a5,a5,a3
    80006014:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    80006018:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    8000601c:	6718                	ld	a4,8(a4)
    8000601e:	00275783          	lhu	a5,2(a4)
    80006022:	2785                	addiw	a5,a5,1
    80006024:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006028:	100017b7          	lui	a5,0x10001
    8000602c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006030:	00492783          	lw	a5,4(s2)
    80006034:	02b79163          	bne	a5,a1,80006056 <virtio_disk_rw+0x1a8>
    sleep(b, &disk.vdisk_lock);
    80006038:	0001f997          	auipc	s3,0x1f
    8000603c:	07098993          	addi	s3,s3,112 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    80006040:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006042:	85ce                	mv	a1,s3
    80006044:	854a                	mv	a0,s2
    80006046:	ffffc097          	auipc	ra,0xffffc
    8000604a:	21e080e7          	jalr	542(ra) # 80002264 <sleep>
  while(b->disk == 1) {
    8000604e:	00492783          	lw	a5,4(s2)
    80006052:	fe9788e3          	beq	a5,s1,80006042 <virtio_disk_rw+0x194>
  }

  disk.info[idx[0]].b = 0;
    80006056:	f9042483          	lw	s1,-112(s0)
    8000605a:	20048793          	addi	a5,s1,512
    8000605e:	00479713          	slli	a4,a5,0x4
    80006062:	0001d797          	auipc	a5,0x1d
    80006066:	f9e78793          	addi	a5,a5,-98 # 80023000 <disk>
    8000606a:	97ba                	add	a5,a5,a4
    8000606c:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80006070:	0001f917          	auipc	s2,0x1f
    80006074:	f9090913          	addi	s2,s2,-112 # 80025000 <disk+0x2000>
    free_desc(i);
    80006078:	8526                	mv	a0,s1
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	c6e080e7          	jalr	-914(ra) # 80005ce8 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80006082:	0492                	slli	s1,s1,0x4
    80006084:	00093783          	ld	a5,0(s2)
    80006088:	94be                	add	s1,s1,a5
    8000608a:	00c4d783          	lhu	a5,12(s1)
    8000608e:	8b85                	andi	a5,a5,1
    80006090:	c781                	beqz	a5,80006098 <virtio_disk_rw+0x1ea>
      i = disk.desc[i].next;
    80006092:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    80006096:	b7cd                	j	80006078 <virtio_disk_rw+0x1ca>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006098:	0001f517          	auipc	a0,0x1f
    8000609c:	01050513          	addi	a0,a0,16 # 800250a8 <disk+0x20a8>
    800060a0:	ffffb097          	auipc	ra,0xffffb
    800060a4:	a86080e7          	jalr	-1402(ra) # 80000b26 <release>
}
    800060a8:	70e6                	ld	ra,120(sp)
    800060aa:	7446                	ld	s0,112(sp)
    800060ac:	74a6                	ld	s1,104(sp)
    800060ae:	7906                	ld	s2,96(sp)
    800060b0:	69e6                	ld	s3,88(sp)
    800060b2:	6a46                	ld	s4,80(sp)
    800060b4:	6aa6                	ld	s5,72(sp)
    800060b6:	6b06                	ld	s6,64(sp)
    800060b8:	7be2                	ld	s7,56(sp)
    800060ba:	7c42                	ld	s8,48(sp)
    800060bc:	7ca2                	ld	s9,40(sp)
    800060be:	7d02                	ld	s10,32(sp)
    800060c0:	6109                	addi	sp,sp,128
    800060c2:	8082                	ret
  if(write)
    800060c4:	01a037b3          	snez	a5,s10
    800060c8:	f8f42023          	sw	a5,-128(s0)
  buf0.reserved = 0;
    800060cc:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    800060d0:	f9943423          	sd	s9,-120(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    800060d4:	f9042483          	lw	s1,-112(s0)
    800060d8:	00449993          	slli	s3,s1,0x4
    800060dc:	0001fa17          	auipc	s4,0x1f
    800060e0:	f24a0a13          	addi	s4,s4,-220 # 80025000 <disk+0x2000>
    800060e4:	000a3a83          	ld	s5,0(s4)
    800060e8:	9ace                	add	s5,s5,s3
    800060ea:	f8040513          	addi	a0,s0,-128
    800060ee:	ffffb097          	auipc	ra,0xffffb
    800060f2:	ebe080e7          	jalr	-322(ra) # 80000fac <kvmpa>
    800060f6:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    800060fa:	000a3783          	ld	a5,0(s4)
    800060fe:	97ce                	add	a5,a5,s3
    80006100:	4741                	li	a4,16
    80006102:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006104:	000a3783          	ld	a5,0(s4)
    80006108:	97ce                	add	a5,a5,s3
    8000610a:	4705                	li	a4,1
    8000610c:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006110:	f9442783          	lw	a5,-108(s0)
    80006114:	000a3703          	ld	a4,0(s4)
    80006118:	974e                	add	a4,a4,s3
    8000611a:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000611e:	0792                	slli	a5,a5,0x4
    80006120:	000a3703          	ld	a4,0(s4)
    80006124:	973e                	add	a4,a4,a5
    80006126:	06090693          	addi	a3,s2,96
    8000612a:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    8000612c:	000a3703          	ld	a4,0(s4)
    80006130:	973e                	add	a4,a4,a5
    80006132:	40000693          	li	a3,1024
    80006136:	c714                	sw	a3,8(a4)
  if(write)
    80006138:	e40d19e3          	bnez	s10,80005f8a <virtio_disk_rw+0xdc>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000613c:	0001f717          	auipc	a4,0x1f
    80006140:	ec473703          	ld	a4,-316(a4) # 80025000 <disk+0x2000>
    80006144:	973e                	add	a4,a4,a5
    80006146:	4689                	li	a3,2
    80006148:	00d71623          	sh	a3,12(a4)
    8000614c:	b5b1                	j	80005f98 <virtio_disk_rw+0xea>

000000008000614e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000614e:	1101                	addi	sp,sp,-32
    80006150:	ec06                	sd	ra,24(sp)
    80006152:	e822                	sd	s0,16(sp)
    80006154:	e426                	sd	s1,8(sp)
    80006156:	e04a                	sd	s2,0(sp)
    80006158:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000615a:	0001f517          	auipc	a0,0x1f
    8000615e:	f4e50513          	addi	a0,a0,-178 # 800250a8 <disk+0x20a8>
    80006162:	ffffb097          	auipc	ra,0xffffb
    80006166:	970080e7          	jalr	-1680(ra) # 80000ad2 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    8000616a:	0001f717          	auipc	a4,0x1f
    8000616e:	e9670713          	addi	a4,a4,-362 # 80025000 <disk+0x2000>
    80006172:	02075783          	lhu	a5,32(a4)
    80006176:	6b18                	ld	a4,16(a4)
    80006178:	00275683          	lhu	a3,2(a4)
    8000617c:	8ebd                	xor	a3,a3,a5
    8000617e:	8a9d                	andi	a3,a3,7
    80006180:	cab9                	beqz	a3,800061d6 <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    80006182:	0001d917          	auipc	s2,0x1d
    80006186:	e7e90913          	addi	s2,s2,-386 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    8000618a:	0001f497          	auipc	s1,0x1f
    8000618e:	e7648493          	addi	s1,s1,-394 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    80006192:	078e                	slli	a5,a5,0x3
    80006194:	97ba                	add	a5,a5,a4
    80006196:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    80006198:	20078713          	addi	a4,a5,512
    8000619c:	0712                	slli	a4,a4,0x4
    8000619e:	974a                	add	a4,a4,s2
    800061a0:	03074703          	lbu	a4,48(a4)
    800061a4:	e739                	bnez	a4,800061f2 <virtio_disk_intr+0xa4>
    disk.info[id].b->disk = 0;   // disk is done with buf
    800061a6:	20078793          	addi	a5,a5,512
    800061aa:	0792                	slli	a5,a5,0x4
    800061ac:	97ca                	add	a5,a5,s2
    800061ae:	7798                	ld	a4,40(a5)
    800061b0:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    800061b4:	7788                	ld	a0,40(a5)
    800061b6:	ffffc097          	auipc	ra,0xffffc
    800061ba:	234080e7          	jalr	564(ra) # 800023ea <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    800061be:	0204d783          	lhu	a5,32(s1)
    800061c2:	2785                	addiw	a5,a5,1
    800061c4:	8b9d                	andi	a5,a5,7
    800061c6:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800061ca:	6898                	ld	a4,16(s1)
    800061cc:	00275683          	lhu	a3,2(a4)
    800061d0:	8a9d                	andi	a3,a3,7
    800061d2:	fcf690e3          	bne	a3,a5,80006192 <virtio_disk_intr+0x44>
  }

  release(&disk.vdisk_lock);
    800061d6:	0001f517          	auipc	a0,0x1f
    800061da:	ed250513          	addi	a0,a0,-302 # 800250a8 <disk+0x20a8>
    800061de:	ffffb097          	auipc	ra,0xffffb
    800061e2:	948080e7          	jalr	-1720(ra) # 80000b26 <release>
}
    800061e6:	60e2                	ld	ra,24(sp)
    800061e8:	6442                	ld	s0,16(sp)
    800061ea:	64a2                	ld	s1,8(sp)
    800061ec:	6902                	ld	s2,0(sp)
    800061ee:	6105                	addi	sp,sp,32
    800061f0:	8082                	ret
      panic("virtio_disk_intr status");
    800061f2:	00001517          	auipc	a0,0x1
    800061f6:	72e50513          	addi	a0,a0,1838 # 80007920 <userret+0x890>
    800061fa:	ffffa097          	auipc	ra,0xffffa
    800061fe:	354080e7          	jalr	852(ra) # 8000054e <panic>
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
