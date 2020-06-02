
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
    80000060:	01478793          	addi	a5,a5,20 # 80006070 <timervec>
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
    80000144:	8c8080e7          	jalr	-1848(ra) # 80001a08 <myproc>
    80000148:	4d1c                	lw	a5,24(a0)
    8000014a:	e7b5                	bnez	a5,800001b6 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000014c:	85ce                	mv	a1,s3
    8000014e:	854a                	mv	a0,s2
    80000150:	00002097          	auipc	ra,0x2
    80000154:	4f0080e7          	jalr	1264(ra) # 80002640 <sleep>
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
    80000190:	7ec080e7          	jalr	2028(ra) # 80002978 <either_copyout>
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
    80000290:	742080e7          	jalr	1858(ra) # 800029ce <either_copyin>
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
    80000306:	722080e7          	jalr	1826(ra) # 80002a24 <procdump>
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
    8000045a:	3e6080e7          	jalr	998(ra) # 8000283c <wakeup>
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
    8000048c:	7d078793          	addi	a5,a5,2000 # 80021c58 <devsw>
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
    800004ce:	4e660613          	addi	a2,a2,1254 # 800079b0 <digits>
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
    80000580:	0ac50513          	addi	a0,a0,172 # 80007628 <userret+0x598>
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
    800005fa:	3bab8b93          	addi	s7,s7,954 # 800079b0 <digits>
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
    800009f2:	ffe080e7          	jalr	-2(ra) # 800019ec <mycpu>
    800009f6:	5d3c                	lw	a5,120(a0)
    800009f8:	cf89                	beqz	a5,80000a12 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800009fa:	00001097          	auipc	ra,0x1
    800009fe:	ff2080e7          	jalr	-14(ra) # 800019ec <mycpu>
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
    80000a16:	fda080e7          	jalr	-38(ra) # 800019ec <mycpu>
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
    80000a2e:	fc2080e7          	jalr	-62(ra) # 800019ec <mycpu>
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
    80000ac6:	f2a080e7          	jalr	-214(ra) # 800019ec <mycpu>
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
    80000b06:	eea080e7          	jalr	-278(ra) # 800019ec <mycpu>
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
    80000d2c:	cb4080e7          	jalr	-844(ra) # 800019dc <cpuid>
    __sync_synchronize();
    printf("synchronize works\n");
    printf("\n");
    started = 1;
  } else {
    while(started == 0)
    80000d30:	00025717          	auipc	a4,0x25
    80000d34:	2d870713          	addi	a4,a4,728 # 80026008 <started>
  if(cpuid() == 0){
    80000d38:	c515                	beqz	a0,80000d64 <main+0x44>
    while(started == 0)
    80000d3a:	431c                	lw	a5,0(a4)
    80000d3c:	2781                	sext.w	a5,a5
    80000d3e:	dff5                	beqz	a5,80000d3a <main+0x1a>
      ;
    __sync_synchronize();
    80000d40:	0ff0000f          	fence
    //printf("hart %d starting\n", cpuid());
    kvminithart();    // turn on paging
    80000d44:	00000097          	auipc	ra,0x0
    80000d48:	3c0080e7          	jalr	960(ra) # 80001104 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000d4c:	00002097          	auipc	ra,0x2
    80000d50:	e18080e7          	jalr	-488(ra) # 80002b64 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000d54:	00005097          	auipc	ra,0x5
    80000d58:	35c080e7          	jalr	860(ra) # 800060b0 <plicinithart>
    //noff= scheduler();
    //noff--;
    //printf("b, noff:%d\n", noff);
    //release(&l_r_c);
   //}
   scheduler();        
    80000d5c:	00001097          	auipc	ra,0x1
    80000d60:	4d2080e7          	jalr	1234(ra) # 8000222e <scheduler>
    initlock(&l_r_c,"readcounter"); //J
    80000d64:	00006597          	auipc	a1,0x6
    80000d68:	42458593          	addi	a1,a1,1060 # 80007188 <userret+0xf8>
    80000d6c:	00011517          	auipc	a0,0x11
    80000d70:	b7c50513          	addi	a0,a0,-1156 # 800118e8 <l_r_c>
    80000d74:	00000097          	auipc	ra,0x0
    80000d78:	c4c080e7          	jalr	-948(ra) # 800009c0 <initlock>
    consoleinit();
    80000d7c:	fffff097          	auipc	ra,0xfffff
    80000d80:	6e4080e7          	jalr	1764(ra) # 80000460 <consoleinit>
    printfinit();
    80000d84:	00000097          	auipc	ra,0x0
    80000d88:	9fa080e7          	jalr	-1542(ra) # 8000077e <printfinit>
    printf("\n");
    80000d8c:	00007517          	auipc	a0,0x7
    80000d90:	89c50513          	addi	a0,a0,-1892 # 80007628 <userret+0x598>
    80000d94:	00000097          	auipc	ra,0x0
    80000d98:	804080e7          	jalr	-2044(ra) # 80000598 <printf>
    printf("xv6 kernel is booting\n");
    80000d9c:	00006517          	auipc	a0,0x6
    80000da0:	3fc50513          	addi	a0,a0,1020 # 80007198 <userret+0x108>
    80000da4:	fffff097          	auipc	ra,0xfffff
    80000da8:	7f4080e7          	jalr	2036(ra) # 80000598 <printf>
    printf("\n");
    80000dac:	00007517          	auipc	a0,0x7
    80000db0:	87c50513          	addi	a0,a0,-1924 # 80007628 <userret+0x598>
    80000db4:	fffff097          	auipc	ra,0xfffff
    80000db8:	7e4080e7          	jalr	2020(ra) # 80000598 <printf>
    kinit();         // physical page allocator
    80000dbc:	00000097          	auipc	ra,0x0
    80000dc0:	b68080e7          	jalr	-1176(ra) # 80000924 <kinit>
    printf("kinit works\n");
    80000dc4:	00006517          	auipc	a0,0x6
    80000dc8:	3ec50513          	addi	a0,a0,1004 # 800071b0 <userret+0x120>
    80000dcc:	fffff097          	auipc	ra,0xfffff
    80000dd0:	7cc080e7          	jalr	1996(ra) # 80000598 <printf>
    printf("\n");
    80000dd4:	00007517          	auipc	a0,0x7
    80000dd8:	85450513          	addi	a0,a0,-1964 # 80007628 <userret+0x598>
    80000ddc:	fffff097          	auipc	ra,0xfffff
    80000de0:	7bc080e7          	jalr	1980(ra) # 80000598 <printf>
    kvminit();       // create kernel page table
    80000de4:	00000097          	auipc	ra,0x0
    80000de8:	4aa080e7          	jalr	1194(ra) # 8000128e <kvminit>
    printf("kvminit works\n");
    80000dec:	00006517          	auipc	a0,0x6
    80000df0:	3d450513          	addi	a0,a0,980 # 800071c0 <userret+0x130>
    80000df4:	fffff097          	auipc	ra,0xfffff
    80000df8:	7a4080e7          	jalr	1956(ra) # 80000598 <printf>
    printf("\n");
    80000dfc:	00007517          	auipc	a0,0x7
    80000e00:	82c50513          	addi	a0,a0,-2004 # 80007628 <userret+0x598>
    80000e04:	fffff097          	auipc	ra,0xfffff
    80000e08:	794080e7          	jalr	1940(ra) # 80000598 <printf>
    kvminithart();   // turn on paging
    80000e0c:	00000097          	auipc	ra,0x0
    80000e10:	2f8080e7          	jalr	760(ra) # 80001104 <kvminithart>
    printf("kvminithart works\n");
    80000e14:	00006517          	auipc	a0,0x6
    80000e18:	3bc50513          	addi	a0,a0,956 # 800071d0 <userret+0x140>
    80000e1c:	fffff097          	auipc	ra,0xfffff
    80000e20:	77c080e7          	jalr	1916(ra) # 80000598 <printf>
    printf("\n");
    80000e24:	00007517          	auipc	a0,0x7
    80000e28:	80450513          	addi	a0,a0,-2044 # 80007628 <userret+0x598>
    80000e2c:	fffff097          	auipc	ra,0xfffff
    80000e30:	76c080e7          	jalr	1900(ra) # 80000598 <printf>
    procinit();      // process table
    80000e34:	00001097          	auipc	ra,0x1
    80000e38:	ad6080e7          	jalr	-1322(ra) # 8000190a <procinit>
    printf("procinit works\n");
    80000e3c:	00006517          	auipc	a0,0x6
    80000e40:	3ac50513          	addi	a0,a0,940 # 800071e8 <userret+0x158>
    80000e44:	fffff097          	auipc	ra,0xfffff
    80000e48:	754080e7          	jalr	1876(ra) # 80000598 <printf>
    printf("\n");
    80000e4c:	00006517          	auipc	a0,0x6
    80000e50:	7dc50513          	addi	a0,a0,2012 # 80007628 <userret+0x598>
    80000e54:	fffff097          	auipc	ra,0xfffff
    80000e58:	744080e7          	jalr	1860(ra) # 80000598 <printf>
    trapinit();      // trap vectors
    80000e5c:	00002097          	auipc	ra,0x2
    80000e60:	ce0080e7          	jalr	-800(ra) # 80002b3c <trapinit>
    printf("trapinit works\n");
    80000e64:	00006517          	auipc	a0,0x6
    80000e68:	39450513          	addi	a0,a0,916 # 800071f8 <userret+0x168>
    80000e6c:	fffff097          	auipc	ra,0xfffff
    80000e70:	72c080e7          	jalr	1836(ra) # 80000598 <printf>
    printf("\n");
    80000e74:	00006517          	auipc	a0,0x6
    80000e78:	7b450513          	addi	a0,a0,1972 # 80007628 <userret+0x598>
    80000e7c:	fffff097          	auipc	ra,0xfffff
    80000e80:	71c080e7          	jalr	1820(ra) # 80000598 <printf>
    trapinithart();  // install kernel trap vector
    80000e84:	00002097          	auipc	ra,0x2
    80000e88:	ce0080e7          	jalr	-800(ra) # 80002b64 <trapinithart>
    printf("trapinithart works\n");
    80000e8c:	00006517          	auipc	a0,0x6
    80000e90:	37c50513          	addi	a0,a0,892 # 80007208 <userret+0x178>
    80000e94:	fffff097          	auipc	ra,0xfffff
    80000e98:	704080e7          	jalr	1796(ra) # 80000598 <printf>
    printf("\n");
    80000e9c:	00006517          	auipc	a0,0x6
    80000ea0:	78c50513          	addi	a0,a0,1932 # 80007628 <userret+0x598>
    80000ea4:	fffff097          	auipc	ra,0xfffff
    80000ea8:	6f4080e7          	jalr	1780(ra) # 80000598 <printf>
    plicinit();      // set up interrupt controller
    80000eac:	00005097          	auipc	ra,0x5
    80000eb0:	1ee080e7          	jalr	494(ra) # 8000609a <plicinit>
    printf("plicinit works\n");
    80000eb4:	00006517          	auipc	a0,0x6
    80000eb8:	36c50513          	addi	a0,a0,876 # 80007220 <userret+0x190>
    80000ebc:	fffff097          	auipc	ra,0xfffff
    80000ec0:	6dc080e7          	jalr	1756(ra) # 80000598 <printf>
    printf("\n");
    80000ec4:	00006517          	auipc	a0,0x6
    80000ec8:	76450513          	addi	a0,a0,1892 # 80007628 <userret+0x598>
    80000ecc:	fffff097          	auipc	ra,0xfffff
    80000ed0:	6cc080e7          	jalr	1740(ra) # 80000598 <printf>
    plicinithart();  // ask PLIC for device interrupts
    80000ed4:	00005097          	auipc	ra,0x5
    80000ed8:	1dc080e7          	jalr	476(ra) # 800060b0 <plicinithart>
    printf("plicinithart works\n");
    80000edc:	00006517          	auipc	a0,0x6
    80000ee0:	35450513          	addi	a0,a0,852 # 80007230 <userret+0x1a0>
    80000ee4:	fffff097          	auipc	ra,0xfffff
    80000ee8:	6b4080e7          	jalr	1716(ra) # 80000598 <printf>
    printf("\n");
    80000eec:	00006517          	auipc	a0,0x6
    80000ef0:	73c50513          	addi	a0,a0,1852 # 80007628 <userret+0x598>
    80000ef4:	fffff097          	auipc	ra,0xfffff
    80000ef8:	6a4080e7          	jalr	1700(ra) # 80000598 <printf>
    binit();         // buffer cache
    80000efc:	00002097          	auipc	ra,0x2
    80000f00:	3c2080e7          	jalr	962(ra) # 800032be <binit>
    printf("binit works\n");
    80000f04:	00006517          	auipc	a0,0x6
    80000f08:	34450513          	addi	a0,a0,836 # 80007248 <userret+0x1b8>
    80000f0c:	fffff097          	auipc	ra,0xfffff
    80000f10:	68c080e7          	jalr	1676(ra) # 80000598 <printf>
    printf("\n");
    80000f14:	00006517          	auipc	a0,0x6
    80000f18:	71450513          	addi	a0,a0,1812 # 80007628 <userret+0x598>
    80000f1c:	fffff097          	auipc	ra,0xfffff
    80000f20:	67c080e7          	jalr	1660(ra) # 80000598 <printf>
    iinit();         // inode cache
    80000f24:	00003097          	auipc	ra,0x3
    80000f28:	a32080e7          	jalr	-1486(ra) # 80003956 <iinit>
    printf("iinit works\n");
    80000f2c:	00006517          	auipc	a0,0x6
    80000f30:	32c50513          	addi	a0,a0,812 # 80007258 <userret+0x1c8>
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	664080e7          	jalr	1636(ra) # 80000598 <printf>
    printf("\n");
    80000f3c:	00006517          	auipc	a0,0x6
    80000f40:	6ec50513          	addi	a0,a0,1772 # 80007628 <userret+0x598>
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	654080e7          	jalr	1620(ra) # 80000598 <printf>
    fileinit();      // file table
    80000f4c:	00004097          	auipc	ra,0x4
    80000f50:	986080e7          	jalr	-1658(ra) # 800048d2 <fileinit>
    printf("fileinit works\n");
    80000f54:	00006517          	auipc	a0,0x6
    80000f58:	31450513          	addi	a0,a0,788 # 80007268 <userret+0x1d8>
    80000f5c:	fffff097          	auipc	ra,0xfffff
    80000f60:	63c080e7          	jalr	1596(ra) # 80000598 <printf>
    printf("\n");
    80000f64:	00006517          	auipc	a0,0x6
    80000f68:	6c450513          	addi	a0,a0,1732 # 80007628 <userret+0x598>
    80000f6c:	fffff097          	auipc	ra,0xfffff
    80000f70:	62c080e7          	jalr	1580(ra) # 80000598 <printf>
    virtio_disk_init(); // emulated hard disk
    80000f74:	00005097          	auipc	ra,0x5
    80000f78:	256080e7          	jalr	598(ra) # 800061ca <virtio_disk_init>
    printf("disk_init works\n");
    80000f7c:	00006517          	auipc	a0,0x6
    80000f80:	2fc50513          	addi	a0,a0,764 # 80007278 <userret+0x1e8>
    80000f84:	fffff097          	auipc	ra,0xfffff
    80000f88:	614080e7          	jalr	1556(ra) # 80000598 <printf>
    printf("\n");
    80000f8c:	00006517          	auipc	a0,0x6
    80000f90:	69c50513          	addi	a0,a0,1692 # 80007628 <userret+0x598>
    80000f94:	fffff097          	auipc	ra,0xfffff
    80000f98:	604080e7          	jalr	1540(ra) # 80000598 <printf>
    userinit();      // first user process
    80000f9c:	00001097          	auipc	ra,0x1
    80000fa0:	d44080e7          	jalr	-700(ra) # 80001ce0 <userinit>
    printf("userinit works\n");
    80000fa4:	00006517          	auipc	a0,0x6
    80000fa8:	2ec50513          	addi	a0,a0,748 # 80007290 <userret+0x200>
    80000fac:	fffff097          	auipc	ra,0xfffff
    80000fb0:	5ec080e7          	jalr	1516(ra) # 80000598 <printf>
    printf("\n");
    80000fb4:	00006517          	auipc	a0,0x6
    80000fb8:	67450513          	addi	a0,a0,1652 # 80007628 <userret+0x598>
    80000fbc:	fffff097          	auipc	ra,0xfffff
    80000fc0:	5dc080e7          	jalr	1500(ra) # 80000598 <printf>
    __sync_synchronize();
    80000fc4:	0ff0000f          	fence
    printf("synchronize works\n");
    80000fc8:	00006517          	auipc	a0,0x6
    80000fcc:	2d850513          	addi	a0,a0,728 # 800072a0 <userret+0x210>
    80000fd0:	fffff097          	auipc	ra,0xfffff
    80000fd4:	5c8080e7          	jalr	1480(ra) # 80000598 <printf>
    printf("\n");
    80000fd8:	00006517          	auipc	a0,0x6
    80000fdc:	65050513          	addi	a0,a0,1616 # 80007628 <userret+0x598>
    80000fe0:	fffff097          	auipc	ra,0xfffff
    80000fe4:	5b8080e7          	jalr	1464(ra) # 80000598 <printf>
    started = 1;
    80000fe8:	4785                	li	a5,1
    80000fea:	00025717          	auipc	a4,0x25
    80000fee:	00f72f23          	sw	a5,30(a4) # 80026008 <started>
    80000ff2:	b3ad                	j	80000d5c <main+0x3c>

0000000080000ff4 <walk>:
//   21..39 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..12 -- 12 bits of byte offset within the page.
static pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000ff4:	7139                	addi	sp,sp,-64
    80000ff6:	fc06                	sd	ra,56(sp)
    80000ff8:	f822                	sd	s0,48(sp)
    80000ffa:	f426                	sd	s1,40(sp)
    80000ffc:	f04a                	sd	s2,32(sp)
    80000ffe:	ec4e                	sd	s3,24(sp)
    80001000:	e852                	sd	s4,16(sp)
    80001002:	e456                	sd	s5,8(sp)
    80001004:	e05a                	sd	s6,0(sp)
    80001006:	0080                	addi	s0,sp,64
    80001008:	84aa                	mv	s1,a0
    8000100a:	89ae                	mv	s3,a1
    8000100c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000100e:	57fd                	li	a5,-1
    80001010:	83e9                	srli	a5,a5,0x1a
    80001012:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001014:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001016:	04b7f263          	bgeu	a5,a1,8000105a <walk+0x66>
    panic("walk");
    8000101a:	00006517          	auipc	a0,0x6
    8000101e:	29e50513          	addi	a0,a0,670 # 800072b8 <userret+0x228>
    80001022:	fffff097          	auipc	ra,0xfffff
    80001026:	52c080e7          	jalr	1324(ra) # 8000054e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000102a:	060a8663          	beqz	s5,80001096 <walk+0xa2>
    8000102e:	00000097          	auipc	ra,0x0
    80001032:	932080e7          	jalr	-1742(ra) # 80000960 <kalloc>
    80001036:	84aa                	mv	s1,a0
    80001038:	c529                	beqz	a0,80001082 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000103a:	6605                	lui	a2,0x1
    8000103c:	4581                	li	a1,0
    8000103e:	00000097          	auipc	ra,0x0
    80001042:	b30080e7          	jalr	-1232(ra) # 80000b6e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001046:	00c4d793          	srli	a5,s1,0xc
    8000104a:	07aa                	slli	a5,a5,0xa
    8000104c:	0017e793          	ori	a5,a5,1
    80001050:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001054:	3a5d                	addiw	s4,s4,-9
    80001056:	036a0063          	beq	s4,s6,80001076 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000105a:	0149d933          	srl	s2,s3,s4
    8000105e:	1ff97913          	andi	s2,s2,511
    80001062:	090e                	slli	s2,s2,0x3
    80001064:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001066:	00093483          	ld	s1,0(s2)
    8000106a:	0014f793          	andi	a5,s1,1
    8000106e:	dfd5                	beqz	a5,8000102a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001070:	80a9                	srli	s1,s1,0xa
    80001072:	04b2                	slli	s1,s1,0xc
    80001074:	b7c5                	j	80001054 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001076:	00c9d513          	srli	a0,s3,0xc
    8000107a:	1ff57513          	andi	a0,a0,511
    8000107e:	050e                	slli	a0,a0,0x3
    80001080:	9526                	add	a0,a0,s1
}
    80001082:	70e2                	ld	ra,56(sp)
    80001084:	7442                	ld	s0,48(sp)
    80001086:	74a2                	ld	s1,40(sp)
    80001088:	7902                	ld	s2,32(sp)
    8000108a:	69e2                	ld	s3,24(sp)
    8000108c:	6a42                	ld	s4,16(sp)
    8000108e:	6aa2                	ld	s5,8(sp)
    80001090:	6b02                	ld	s6,0(sp)
    80001092:	6121                	addi	sp,sp,64
    80001094:	8082                	ret
        return 0;
    80001096:	4501                	li	a0,0
    80001098:	b7ed                	j	80001082 <walk+0x8e>

000000008000109a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void
freewalk(pagetable_t pagetable)
{
    8000109a:	7179                	addi	sp,sp,-48
    8000109c:	f406                	sd	ra,40(sp)
    8000109e:	f022                	sd	s0,32(sp)
    800010a0:	ec26                	sd	s1,24(sp)
    800010a2:	e84a                	sd	s2,16(sp)
    800010a4:	e44e                	sd	s3,8(sp)
    800010a6:	e052                	sd	s4,0(sp)
    800010a8:	1800                	addi	s0,sp,48
    800010aa:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800010ac:	84aa                	mv	s1,a0
    800010ae:	6905                	lui	s2,0x1
    800010b0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800010b2:	4985                	li	s3,1
    800010b4:	a821                	j	800010cc <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800010b6:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800010b8:	0532                	slli	a0,a0,0xc
    800010ba:	00000097          	auipc	ra,0x0
    800010be:	fe0080e7          	jalr	-32(ra) # 8000109a <freewalk>
      pagetable[i] = 0;
    800010c2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800010c6:	04a1                	addi	s1,s1,8
    800010c8:	03248163          	beq	s1,s2,800010ea <freewalk+0x50>
    pte_t pte = pagetable[i];
    800010cc:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800010ce:	00f57793          	andi	a5,a0,15
    800010d2:	ff3782e3          	beq	a5,s3,800010b6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800010d6:	8905                	andi	a0,a0,1
    800010d8:	d57d                	beqz	a0,800010c6 <freewalk+0x2c>
      panic("freewalk: leaf");
    800010da:	00006517          	auipc	a0,0x6
    800010de:	1e650513          	addi	a0,a0,486 # 800072c0 <userret+0x230>
    800010e2:	fffff097          	auipc	ra,0xfffff
    800010e6:	46c080e7          	jalr	1132(ra) # 8000054e <panic>
    }
  }
  kfree((void*)pagetable);
    800010ea:	8552                	mv	a0,s4
    800010ec:	fffff097          	auipc	ra,0xfffff
    800010f0:	778080e7          	jalr	1912(ra) # 80000864 <kfree>
}
    800010f4:	70a2                	ld	ra,40(sp)
    800010f6:	7402                	ld	s0,32(sp)
    800010f8:	64e2                	ld	s1,24(sp)
    800010fa:	6942                	ld	s2,16(sp)
    800010fc:	69a2                	ld	s3,8(sp)
    800010fe:	6a02                	ld	s4,0(sp)
    80001100:	6145                	addi	sp,sp,48
    80001102:	8082                	ret

0000000080001104 <kvminithart>:
{
    80001104:	1141                	addi	sp,sp,-16
    80001106:	e422                	sd	s0,8(sp)
    80001108:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000110a:	00025797          	auipc	a5,0x25
    8000110e:	f067b783          	ld	a5,-250(a5) # 80026010 <kernel_pagetable>
    80001112:	83b1                	srli	a5,a5,0xc
    80001114:	577d                	li	a4,-1
    80001116:	177e                	slli	a4,a4,0x3f
    80001118:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000111a:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000111e:	12000073          	sfence.vma
}
    80001122:	6422                	ld	s0,8(sp)
    80001124:	0141                	addi	sp,sp,16
    80001126:	8082                	ret

0000000080001128 <walkaddr>:
  if(va >= MAXVA)
    80001128:	57fd                	li	a5,-1
    8000112a:	83e9                	srli	a5,a5,0x1a
    8000112c:	00b7f463          	bgeu	a5,a1,80001134 <walkaddr+0xc>
    return 0;
    80001130:	4501                	li	a0,0
}
    80001132:	8082                	ret
{
    80001134:	1141                	addi	sp,sp,-16
    80001136:	e406                	sd	ra,8(sp)
    80001138:	e022                	sd	s0,0(sp)
    8000113a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000113c:	4601                	li	a2,0
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	eb6080e7          	jalr	-330(ra) # 80000ff4 <walk>
  if(pte == 0)
    80001146:	c105                	beqz	a0,80001166 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001148:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000114a:	0117f693          	andi	a3,a5,17
    8000114e:	4745                	li	a4,17
    return 0;
    80001150:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001152:	00e68663          	beq	a3,a4,8000115e <walkaddr+0x36>
}
    80001156:	60a2                	ld	ra,8(sp)
    80001158:	6402                	ld	s0,0(sp)
    8000115a:	0141                	addi	sp,sp,16
    8000115c:	8082                	ret
  pa = PTE2PA(*pte);
    8000115e:	00a7d513          	srli	a0,a5,0xa
    80001162:	0532                	slli	a0,a0,0xc
  return pa;
    80001164:	bfcd                	j	80001156 <walkaddr+0x2e>
    return 0;
    80001166:	4501                	li	a0,0
    80001168:	b7fd                	j	80001156 <walkaddr+0x2e>

000000008000116a <kvmpa>:
{
    8000116a:	1101                	addi	sp,sp,-32
    8000116c:	ec06                	sd	ra,24(sp)
    8000116e:	e822                	sd	s0,16(sp)
    80001170:	e426                	sd	s1,8(sp)
    80001172:	1000                	addi	s0,sp,32
    80001174:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    80001176:	1552                	slli	a0,a0,0x34
    80001178:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    8000117c:	4601                	li	a2,0
    8000117e:	00025517          	auipc	a0,0x25
    80001182:	e9253503          	ld	a0,-366(a0) # 80026010 <kernel_pagetable>
    80001186:	00000097          	auipc	ra,0x0
    8000118a:	e6e080e7          	jalr	-402(ra) # 80000ff4 <walk>
  if(pte == 0)
    8000118e:	cd09                	beqz	a0,800011a8 <kvmpa+0x3e>
  if((*pte & PTE_V) == 0)
    80001190:	6108                	ld	a0,0(a0)
    80001192:	00157793          	andi	a5,a0,1
    80001196:	c38d                	beqz	a5,800011b8 <kvmpa+0x4e>
  pa = PTE2PA(*pte);
    80001198:	8129                	srli	a0,a0,0xa
    8000119a:	0532                	slli	a0,a0,0xc
}
    8000119c:	9526                	add	a0,a0,s1
    8000119e:	60e2                	ld	ra,24(sp)
    800011a0:	6442                	ld	s0,16(sp)
    800011a2:	64a2                	ld	s1,8(sp)
    800011a4:	6105                	addi	sp,sp,32
    800011a6:	8082                	ret
    panic("kvmpa");
    800011a8:	00006517          	auipc	a0,0x6
    800011ac:	12850513          	addi	a0,a0,296 # 800072d0 <userret+0x240>
    800011b0:	fffff097          	auipc	ra,0xfffff
    800011b4:	39e080e7          	jalr	926(ra) # 8000054e <panic>
    panic("kvmpa");
    800011b8:	00006517          	auipc	a0,0x6
    800011bc:	11850513          	addi	a0,a0,280 # 800072d0 <userret+0x240>
    800011c0:	fffff097          	auipc	ra,0xfffff
    800011c4:	38e080e7          	jalr	910(ra) # 8000054e <panic>

00000000800011c8 <mappages>:
{
    800011c8:	715d                	addi	sp,sp,-80
    800011ca:	e486                	sd	ra,72(sp)
    800011cc:	e0a2                	sd	s0,64(sp)
    800011ce:	fc26                	sd	s1,56(sp)
    800011d0:	f84a                	sd	s2,48(sp)
    800011d2:	f44e                	sd	s3,40(sp)
    800011d4:	f052                	sd	s4,32(sp)
    800011d6:	ec56                	sd	s5,24(sp)
    800011d8:	e85a                	sd	s6,16(sp)
    800011da:	e45e                	sd	s7,8(sp)
    800011dc:	0880                	addi	s0,sp,80
    800011de:	8aaa                	mv	s5,a0
    800011e0:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    800011e2:	777d                	lui	a4,0xfffff
    800011e4:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800011e8:	167d                	addi	a2,a2,-1
    800011ea:	00b609b3          	add	s3,a2,a1
    800011ee:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800011f2:	893e                	mv	s2,a5
    800011f4:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    800011f8:	6b85                	lui	s7,0x1
    800011fa:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800011fe:	4605                	li	a2,1
    80001200:	85ca                	mv	a1,s2
    80001202:	8556                	mv	a0,s5
    80001204:	00000097          	auipc	ra,0x0
    80001208:	df0080e7          	jalr	-528(ra) # 80000ff4 <walk>
    8000120c:	c51d                	beqz	a0,8000123a <mappages+0x72>
    if(*pte & PTE_V)
    8000120e:	611c                	ld	a5,0(a0)
    80001210:	8b85                	andi	a5,a5,1
    80001212:	ef81                	bnez	a5,8000122a <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001214:	80b1                	srli	s1,s1,0xc
    80001216:	04aa                	slli	s1,s1,0xa
    80001218:	0164e4b3          	or	s1,s1,s6
    8000121c:	0014e493          	ori	s1,s1,1
    80001220:	e104                	sd	s1,0(a0)
    if(a == last)
    80001222:	03390863          	beq	s2,s3,80001252 <mappages+0x8a>
    a += PGSIZE;
    80001226:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001228:	bfc9                	j	800011fa <mappages+0x32>
      panic("remap");
    8000122a:	00006517          	auipc	a0,0x6
    8000122e:	0ae50513          	addi	a0,a0,174 # 800072d8 <userret+0x248>
    80001232:	fffff097          	auipc	ra,0xfffff
    80001236:	31c080e7          	jalr	796(ra) # 8000054e <panic>
      return -1;
    8000123a:	557d                	li	a0,-1
}
    8000123c:	60a6                	ld	ra,72(sp)
    8000123e:	6406                	ld	s0,64(sp)
    80001240:	74e2                	ld	s1,56(sp)
    80001242:	7942                	ld	s2,48(sp)
    80001244:	79a2                	ld	s3,40(sp)
    80001246:	7a02                	ld	s4,32(sp)
    80001248:	6ae2                	ld	s5,24(sp)
    8000124a:	6b42                	ld	s6,16(sp)
    8000124c:	6ba2                	ld	s7,8(sp)
    8000124e:	6161                	addi	sp,sp,80
    80001250:	8082                	ret
  return 0;
    80001252:	4501                	li	a0,0
    80001254:	b7e5                	j	8000123c <mappages+0x74>

0000000080001256 <kvmmap>:
{
    80001256:	1141                	addi	sp,sp,-16
    80001258:	e406                	sd	ra,8(sp)
    8000125a:	e022                	sd	s0,0(sp)
    8000125c:	0800                	addi	s0,sp,16
    8000125e:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    80001260:	86ae                	mv	a3,a1
    80001262:	85aa                	mv	a1,a0
    80001264:	00025517          	auipc	a0,0x25
    80001268:	dac53503          	ld	a0,-596(a0) # 80026010 <kernel_pagetable>
    8000126c:	00000097          	auipc	ra,0x0
    80001270:	f5c080e7          	jalr	-164(ra) # 800011c8 <mappages>
    80001274:	e509                	bnez	a0,8000127e <kvmmap+0x28>
}
    80001276:	60a2                	ld	ra,8(sp)
    80001278:	6402                	ld	s0,0(sp)
    8000127a:	0141                	addi	sp,sp,16
    8000127c:	8082                	ret
    panic("kvmmap");
    8000127e:	00006517          	auipc	a0,0x6
    80001282:	06250513          	addi	a0,a0,98 # 800072e0 <userret+0x250>
    80001286:	fffff097          	auipc	ra,0xfffff
    8000128a:	2c8080e7          	jalr	712(ra) # 8000054e <panic>

000000008000128e <kvminit>:
{
    8000128e:	1101                	addi	sp,sp,-32
    80001290:	ec06                	sd	ra,24(sp)
    80001292:	e822                	sd	s0,16(sp)
    80001294:	e426                	sd	s1,8(sp)
    80001296:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    80001298:	fffff097          	auipc	ra,0xfffff
    8000129c:	6c8080e7          	jalr	1736(ra) # 80000960 <kalloc>
    800012a0:	00025797          	auipc	a5,0x25
    800012a4:	d6a7b823          	sd	a0,-656(a5) # 80026010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    800012a8:	6605                	lui	a2,0x1
    800012aa:	4581                	li	a1,0
    800012ac:	00000097          	auipc	ra,0x0
    800012b0:	8c2080e7          	jalr	-1854(ra) # 80000b6e <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800012b4:	4699                	li	a3,6
    800012b6:	6605                	lui	a2,0x1
    800012b8:	100005b7          	lui	a1,0x10000
    800012bc:	10000537          	lui	a0,0x10000
    800012c0:	00000097          	auipc	ra,0x0
    800012c4:	f96080e7          	jalr	-106(ra) # 80001256 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800012c8:	4699                	li	a3,6
    800012ca:	6605                	lui	a2,0x1
    800012cc:	100015b7          	lui	a1,0x10001
    800012d0:	10001537          	lui	a0,0x10001
    800012d4:	00000097          	auipc	ra,0x0
    800012d8:	f82080e7          	jalr	-126(ra) # 80001256 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    800012dc:	4699                	li	a3,6
    800012de:	6641                	lui	a2,0x10
    800012e0:	020005b7          	lui	a1,0x2000
    800012e4:	02000537          	lui	a0,0x2000
    800012e8:	00000097          	auipc	ra,0x0
    800012ec:	f6e080e7          	jalr	-146(ra) # 80001256 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800012f0:	4699                	li	a3,6
    800012f2:	00400637          	lui	a2,0x400
    800012f6:	0c0005b7          	lui	a1,0xc000
    800012fa:	0c000537          	lui	a0,0xc000
    800012fe:	00000097          	auipc	ra,0x0
    80001302:	f58080e7          	jalr	-168(ra) # 80001256 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001306:	00007497          	auipc	s1,0x7
    8000130a:	cfa48493          	addi	s1,s1,-774 # 80008000 <initcode>
    8000130e:	46a9                	li	a3,10
    80001310:	80007617          	auipc	a2,0x80007
    80001314:	cf060613          	addi	a2,a2,-784 # 8000 <_entry-0x7fff8000>
    80001318:	4585                	li	a1,1
    8000131a:	05fe                	slli	a1,a1,0x1f
    8000131c:	852e                	mv	a0,a1
    8000131e:	00000097          	auipc	ra,0x0
    80001322:	f38080e7          	jalr	-200(ra) # 80001256 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001326:	4699                	li	a3,6
    80001328:	4645                	li	a2,17
    8000132a:	066e                	slli	a2,a2,0x1b
    8000132c:	8e05                	sub	a2,a2,s1
    8000132e:	85a6                	mv	a1,s1
    80001330:	8526                	mv	a0,s1
    80001332:	00000097          	auipc	ra,0x0
    80001336:	f24080e7          	jalr	-220(ra) # 80001256 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000133a:	46a9                	li	a3,10
    8000133c:	6605                	lui	a2,0x1
    8000133e:	00006597          	auipc	a1,0x6
    80001342:	cc258593          	addi	a1,a1,-830 # 80007000 <trampoline>
    80001346:	04000537          	lui	a0,0x4000
    8000134a:	157d                	addi	a0,a0,-1
    8000134c:	0532                	slli	a0,a0,0xc
    8000134e:	00000097          	auipc	ra,0x0
    80001352:	f08080e7          	jalr	-248(ra) # 80001256 <kvmmap>
}
    80001356:	60e2                	ld	ra,24(sp)
    80001358:	6442                	ld	s0,16(sp)
    8000135a:	64a2                	ld	s1,8(sp)
    8000135c:	6105                	addi	sp,sp,32
    8000135e:	8082                	ret

0000000080001360 <uvmunmap>:
{
    80001360:	715d                	addi	sp,sp,-80
    80001362:	e486                	sd	ra,72(sp)
    80001364:	e0a2                	sd	s0,64(sp)
    80001366:	fc26                	sd	s1,56(sp)
    80001368:	f84a                	sd	s2,48(sp)
    8000136a:	f44e                	sd	s3,40(sp)
    8000136c:	f052                	sd	s4,32(sp)
    8000136e:	ec56                	sd	s5,24(sp)
    80001370:	e85a                	sd	s6,16(sp)
    80001372:	e45e                	sd	s7,8(sp)
    80001374:	0880                	addi	s0,sp,80
    80001376:	8a2a                	mv	s4,a0
    80001378:	8ab6                	mv	s5,a3
  a = PGROUNDDOWN(va);
    8000137a:	77fd                	lui	a5,0xfffff
    8000137c:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80001380:	167d                	addi	a2,a2,-1
    80001382:	00b609b3          	add	s3,a2,a1
    80001386:	00f9f9b3          	and	s3,s3,a5
    if(PTE_FLAGS(*pte) == PTE_V)
    8000138a:	4b05                	li	s6,1
    a += PGSIZE;
    8000138c:	6b85                	lui	s7,0x1
    8000138e:	a8b1                	j	800013ea <uvmunmap+0x8a>
      panic("uvmunmap: walk");
    80001390:	00006517          	auipc	a0,0x6
    80001394:	f5850513          	addi	a0,a0,-168 # 800072e8 <userret+0x258>
    80001398:	fffff097          	auipc	ra,0xfffff
    8000139c:	1b6080e7          	jalr	438(ra) # 8000054e <panic>
      printf("va=%p pte=%p\n", a, *pte);
    800013a0:	862a                	mv	a2,a0
    800013a2:	85ca                	mv	a1,s2
    800013a4:	00006517          	auipc	a0,0x6
    800013a8:	f5450513          	addi	a0,a0,-172 # 800072f8 <userret+0x268>
    800013ac:	fffff097          	auipc	ra,0xfffff
    800013b0:	1ec080e7          	jalr	492(ra) # 80000598 <printf>
      panic("uvmunmap: not mapped");
    800013b4:	00006517          	auipc	a0,0x6
    800013b8:	f5450513          	addi	a0,a0,-172 # 80007308 <userret+0x278>
    800013bc:	fffff097          	auipc	ra,0xfffff
    800013c0:	192080e7          	jalr	402(ra) # 8000054e <panic>
      panic("uvmunmap: not a leaf");
    800013c4:	00006517          	auipc	a0,0x6
    800013c8:	f5c50513          	addi	a0,a0,-164 # 80007320 <userret+0x290>
    800013cc:	fffff097          	auipc	ra,0xfffff
    800013d0:	182080e7          	jalr	386(ra) # 8000054e <panic>
      pa = PTE2PA(*pte);
    800013d4:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800013d6:	0532                	slli	a0,a0,0xc
    800013d8:	fffff097          	auipc	ra,0xfffff
    800013dc:	48c080e7          	jalr	1164(ra) # 80000864 <kfree>
    *pte = 0;
    800013e0:	0004b023          	sd	zero,0(s1)
    if(a == last)
    800013e4:	03390763          	beq	s2,s3,80001412 <uvmunmap+0xb2>
    a += PGSIZE;
    800013e8:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 0)) == 0)
    800013ea:	4601                	li	a2,0
    800013ec:	85ca                	mv	a1,s2
    800013ee:	8552                	mv	a0,s4
    800013f0:	00000097          	auipc	ra,0x0
    800013f4:	c04080e7          	jalr	-1020(ra) # 80000ff4 <walk>
    800013f8:	84aa                	mv	s1,a0
    800013fa:	d959                	beqz	a0,80001390 <uvmunmap+0x30>
    if((*pte & PTE_V) == 0){
    800013fc:	6108                	ld	a0,0(a0)
    800013fe:	00157793          	andi	a5,a0,1
    80001402:	dfd9                	beqz	a5,800013a0 <uvmunmap+0x40>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001404:	3ff57793          	andi	a5,a0,1023
    80001408:	fb678ee3          	beq	a5,s6,800013c4 <uvmunmap+0x64>
    if(do_free){
    8000140c:	fc0a8ae3          	beqz	s5,800013e0 <uvmunmap+0x80>
    80001410:	b7d1                	j	800013d4 <uvmunmap+0x74>
}
    80001412:	60a6                	ld	ra,72(sp)
    80001414:	6406                	ld	s0,64(sp)
    80001416:	74e2                	ld	s1,56(sp)
    80001418:	7942                	ld	s2,48(sp)
    8000141a:	79a2                	ld	s3,40(sp)
    8000141c:	7a02                	ld	s4,32(sp)
    8000141e:	6ae2                	ld	s5,24(sp)
    80001420:	6b42                	ld	s6,16(sp)
    80001422:	6ba2                	ld	s7,8(sp)
    80001424:	6161                	addi	sp,sp,80
    80001426:	8082                	ret

0000000080001428 <uvmcreate>:
{
    80001428:	1101                	addi	sp,sp,-32
    8000142a:	ec06                	sd	ra,24(sp)
    8000142c:	e822                	sd	s0,16(sp)
    8000142e:	e426                	sd	s1,8(sp)
    80001430:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    80001432:	fffff097          	auipc	ra,0xfffff
    80001436:	52e080e7          	jalr	1326(ra) # 80000960 <kalloc>
  if(pagetable == 0)
    8000143a:	cd11                	beqz	a0,80001456 <uvmcreate+0x2e>
    8000143c:	84aa                	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
    8000143e:	6605                	lui	a2,0x1
    80001440:	4581                	li	a1,0
    80001442:	fffff097          	auipc	ra,0xfffff
    80001446:	72c080e7          	jalr	1836(ra) # 80000b6e <memset>
}
    8000144a:	8526                	mv	a0,s1
    8000144c:	60e2                	ld	ra,24(sp)
    8000144e:	6442                	ld	s0,16(sp)
    80001450:	64a2                	ld	s1,8(sp)
    80001452:	6105                	addi	sp,sp,32
    80001454:	8082                	ret
    panic("uvmcreate: out of memory");
    80001456:	00006517          	auipc	a0,0x6
    8000145a:	ee250513          	addi	a0,a0,-286 # 80007338 <userret+0x2a8>
    8000145e:	fffff097          	auipc	ra,0xfffff
    80001462:	0f0080e7          	jalr	240(ra) # 8000054e <panic>

0000000080001466 <uvminit>:
{
    80001466:	7179                	addi	sp,sp,-48
    80001468:	f406                	sd	ra,40(sp)
    8000146a:	f022                	sd	s0,32(sp)
    8000146c:	ec26                	sd	s1,24(sp)
    8000146e:	e84a                	sd	s2,16(sp)
    80001470:	e44e                	sd	s3,8(sp)
    80001472:	e052                	sd	s4,0(sp)
    80001474:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    80001476:	6785                	lui	a5,0x1
    80001478:	04f67863          	bgeu	a2,a5,800014c8 <uvminit+0x62>
    8000147c:	8a2a                	mv	s4,a0
    8000147e:	89ae                	mv	s3,a1
    80001480:	84b2                	mv	s1,a2
  mem = kalloc();
    80001482:	fffff097          	auipc	ra,0xfffff
    80001486:	4de080e7          	jalr	1246(ra) # 80000960 <kalloc>
    8000148a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000148c:	6605                	lui	a2,0x1
    8000148e:	4581                	li	a1,0
    80001490:	fffff097          	auipc	ra,0xfffff
    80001494:	6de080e7          	jalr	1758(ra) # 80000b6e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001498:	4779                	li	a4,30
    8000149a:	86ca                	mv	a3,s2
    8000149c:	6605                	lui	a2,0x1
    8000149e:	4581                	li	a1,0
    800014a0:	8552                	mv	a0,s4
    800014a2:	00000097          	auipc	ra,0x0
    800014a6:	d26080e7          	jalr	-730(ra) # 800011c8 <mappages>
  memmove(mem, src, sz);
    800014aa:	8626                	mv	a2,s1
    800014ac:	85ce                	mv	a1,s3
    800014ae:	854a                	mv	a0,s2
    800014b0:	fffff097          	auipc	ra,0xfffff
    800014b4:	71e080e7          	jalr	1822(ra) # 80000bce <memmove>
}
    800014b8:	70a2                	ld	ra,40(sp)
    800014ba:	7402                	ld	s0,32(sp)
    800014bc:	64e2                	ld	s1,24(sp)
    800014be:	6942                	ld	s2,16(sp)
    800014c0:	69a2                	ld	s3,8(sp)
    800014c2:	6a02                	ld	s4,0(sp)
    800014c4:	6145                	addi	sp,sp,48
    800014c6:	8082                	ret
    panic("inituvm: more than a page");
    800014c8:	00006517          	auipc	a0,0x6
    800014cc:	e9050513          	addi	a0,a0,-368 # 80007358 <userret+0x2c8>
    800014d0:	fffff097          	auipc	ra,0xfffff
    800014d4:	07e080e7          	jalr	126(ra) # 8000054e <panic>

00000000800014d8 <uvmdealloc>:
{
    800014d8:	1101                	addi	sp,sp,-32
    800014da:	ec06                	sd	ra,24(sp)
    800014dc:	e822                	sd	s0,16(sp)
    800014de:	e426                	sd	s1,8(sp)
    800014e0:	1000                	addi	s0,sp,32
    return oldsz;
    800014e2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800014e4:	00b67d63          	bgeu	a2,a1,800014fe <uvmdealloc+0x26>
    800014e8:	84b2                	mv	s1,a2
  uint64 newup = PGROUNDUP(newsz);
    800014ea:	6785                	lui	a5,0x1
    800014ec:	17fd                	addi	a5,a5,-1
    800014ee:	00f60733          	add	a4,a2,a5
    800014f2:	76fd                	lui	a3,0xfffff
    800014f4:	8f75                	and	a4,a4,a3
  if(newup < PGROUNDUP(oldsz))
    800014f6:	97ae                	add	a5,a5,a1
    800014f8:	8ff5                	and	a5,a5,a3
    800014fa:	00f76863          	bltu	a4,a5,8000150a <uvmdealloc+0x32>
}
    800014fe:	8526                	mv	a0,s1
    80001500:	60e2                	ld	ra,24(sp)
    80001502:	6442                	ld	s0,16(sp)
    80001504:	64a2                	ld	s1,8(sp)
    80001506:	6105                	addi	sp,sp,32
    80001508:	8082                	ret
    uvmunmap(pagetable, newup, oldsz - newup, 1);
    8000150a:	4685                	li	a3,1
    8000150c:	40e58633          	sub	a2,a1,a4
    80001510:	85ba                	mv	a1,a4
    80001512:	00000097          	auipc	ra,0x0
    80001516:	e4e080e7          	jalr	-434(ra) # 80001360 <uvmunmap>
    8000151a:	b7d5                	j	800014fe <uvmdealloc+0x26>

000000008000151c <uvmalloc>:
  if(newsz < oldsz)
    8000151c:	0ab66163          	bltu	a2,a1,800015be <uvmalloc+0xa2>
{
    80001520:	7139                	addi	sp,sp,-64
    80001522:	fc06                	sd	ra,56(sp)
    80001524:	f822                	sd	s0,48(sp)
    80001526:	f426                	sd	s1,40(sp)
    80001528:	f04a                	sd	s2,32(sp)
    8000152a:	ec4e                	sd	s3,24(sp)
    8000152c:	e852                	sd	s4,16(sp)
    8000152e:	e456                	sd	s5,8(sp)
    80001530:	0080                	addi	s0,sp,64
    80001532:	8aaa                	mv	s5,a0
    80001534:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001536:	6985                	lui	s3,0x1
    80001538:	19fd                	addi	s3,s3,-1
    8000153a:	95ce                	add	a1,a1,s3
    8000153c:	79fd                	lui	s3,0xfffff
    8000153e:	0135f9b3          	and	s3,a1,s3
  for(; a < newsz; a += PGSIZE){
    80001542:	08c9f063          	bgeu	s3,a2,800015c2 <uvmalloc+0xa6>
  a = oldsz;
    80001546:	894e                	mv	s2,s3
    mem = kalloc();
    80001548:	fffff097          	auipc	ra,0xfffff
    8000154c:	418080e7          	jalr	1048(ra) # 80000960 <kalloc>
    80001550:	84aa                	mv	s1,a0
    if(mem == 0){
    80001552:	c51d                	beqz	a0,80001580 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001554:	6605                	lui	a2,0x1
    80001556:	4581                	li	a1,0
    80001558:	fffff097          	auipc	ra,0xfffff
    8000155c:	616080e7          	jalr	1558(ra) # 80000b6e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001560:	4779                	li	a4,30
    80001562:	86a6                	mv	a3,s1
    80001564:	6605                	lui	a2,0x1
    80001566:	85ca                	mv	a1,s2
    80001568:	8556                	mv	a0,s5
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	c5e080e7          	jalr	-930(ra) # 800011c8 <mappages>
    80001572:	e905                	bnez	a0,800015a2 <uvmalloc+0x86>
  for(; a < newsz; a += PGSIZE){
    80001574:	6785                	lui	a5,0x1
    80001576:	993e                	add	s2,s2,a5
    80001578:	fd4968e3          	bltu	s2,s4,80001548 <uvmalloc+0x2c>
  return newsz;
    8000157c:	8552                	mv	a0,s4
    8000157e:	a809                	j	80001590 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001580:	864e                	mv	a2,s3
    80001582:	85ca                	mv	a1,s2
    80001584:	8556                	mv	a0,s5
    80001586:	00000097          	auipc	ra,0x0
    8000158a:	f52080e7          	jalr	-174(ra) # 800014d8 <uvmdealloc>
      return 0;
    8000158e:	4501                	li	a0,0
}
    80001590:	70e2                	ld	ra,56(sp)
    80001592:	7442                	ld	s0,48(sp)
    80001594:	74a2                	ld	s1,40(sp)
    80001596:	7902                	ld	s2,32(sp)
    80001598:	69e2                	ld	s3,24(sp)
    8000159a:	6a42                	ld	s4,16(sp)
    8000159c:	6aa2                	ld	s5,8(sp)
    8000159e:	6121                	addi	sp,sp,64
    800015a0:	8082                	ret
      kfree(mem);
    800015a2:	8526                	mv	a0,s1
    800015a4:	fffff097          	auipc	ra,0xfffff
    800015a8:	2c0080e7          	jalr	704(ra) # 80000864 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800015ac:	864e                	mv	a2,s3
    800015ae:	85ca                	mv	a1,s2
    800015b0:	8556                	mv	a0,s5
    800015b2:	00000097          	auipc	ra,0x0
    800015b6:	f26080e7          	jalr	-218(ra) # 800014d8 <uvmdealloc>
      return 0;
    800015ba:	4501                	li	a0,0
    800015bc:	bfd1                	j	80001590 <uvmalloc+0x74>
    return oldsz;
    800015be:	852e                	mv	a0,a1
}
    800015c0:	8082                	ret
  return newsz;
    800015c2:	8532                	mv	a0,a2
    800015c4:	b7f1                	j	80001590 <uvmalloc+0x74>

00000000800015c6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015c6:	1101                	addi	sp,sp,-32
    800015c8:	ec06                	sd	ra,24(sp)
    800015ca:	e822                	sd	s0,16(sp)
    800015cc:	e426                	sd	s1,8(sp)
    800015ce:	1000                	addi	s0,sp,32
    800015d0:	84aa                	mv	s1,a0
    800015d2:	862e                	mv	a2,a1
  uvmunmap(pagetable, 0, sz, 1);
    800015d4:	4685                	li	a3,1
    800015d6:	4581                	li	a1,0
    800015d8:	00000097          	auipc	ra,0x0
    800015dc:	d88080e7          	jalr	-632(ra) # 80001360 <uvmunmap>
  freewalk(pagetable);
    800015e0:	8526                	mv	a0,s1
    800015e2:	00000097          	auipc	ra,0x0
    800015e6:	ab8080e7          	jalr	-1352(ra) # 8000109a <freewalk>
}
    800015ea:	60e2                	ld	ra,24(sp)
    800015ec:	6442                	ld	s0,16(sp)
    800015ee:	64a2                	ld	s1,8(sp)
    800015f0:	6105                	addi	sp,sp,32
    800015f2:	8082                	ret

00000000800015f4 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015f4:	c671                	beqz	a2,800016c0 <uvmcopy+0xcc>
{
    800015f6:	715d                	addi	sp,sp,-80
    800015f8:	e486                	sd	ra,72(sp)
    800015fa:	e0a2                	sd	s0,64(sp)
    800015fc:	fc26                	sd	s1,56(sp)
    800015fe:	f84a                	sd	s2,48(sp)
    80001600:	f44e                	sd	s3,40(sp)
    80001602:	f052                	sd	s4,32(sp)
    80001604:	ec56                	sd	s5,24(sp)
    80001606:	e85a                	sd	s6,16(sp)
    80001608:	e45e                	sd	s7,8(sp)
    8000160a:	0880                	addi	s0,sp,80
    8000160c:	8b2a                	mv	s6,a0
    8000160e:	8aae                	mv	s5,a1
    80001610:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001612:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001614:	4601                	li	a2,0
    80001616:	85ce                	mv	a1,s3
    80001618:	855a                	mv	a0,s6
    8000161a:	00000097          	auipc	ra,0x0
    8000161e:	9da080e7          	jalr	-1574(ra) # 80000ff4 <walk>
    80001622:	c531                	beqz	a0,8000166e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001624:	6118                	ld	a4,0(a0)
    80001626:	00177793          	andi	a5,a4,1
    8000162a:	cbb1                	beqz	a5,8000167e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000162c:	00a75593          	srli	a1,a4,0xa
    80001630:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001634:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001638:	fffff097          	auipc	ra,0xfffff
    8000163c:	328080e7          	jalr	808(ra) # 80000960 <kalloc>
    80001640:	892a                	mv	s2,a0
    80001642:	c939                	beqz	a0,80001698 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001644:	6605                	lui	a2,0x1
    80001646:	85de                	mv	a1,s7
    80001648:	fffff097          	auipc	ra,0xfffff
    8000164c:	586080e7          	jalr	1414(ra) # 80000bce <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001650:	8726                	mv	a4,s1
    80001652:	86ca                	mv	a3,s2
    80001654:	6605                	lui	a2,0x1
    80001656:	85ce                	mv	a1,s3
    80001658:	8556                	mv	a0,s5
    8000165a:	00000097          	auipc	ra,0x0
    8000165e:	b6e080e7          	jalr	-1170(ra) # 800011c8 <mappages>
    80001662:	e515                	bnez	a0,8000168e <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80001664:	6785                	lui	a5,0x1
    80001666:	99be                	add	s3,s3,a5
    80001668:	fb49e6e3          	bltu	s3,s4,80001614 <uvmcopy+0x20>
    8000166c:	a83d                	j	800016aa <uvmcopy+0xb6>
      panic("uvmcopy: pte should exist");
    8000166e:	00006517          	auipc	a0,0x6
    80001672:	d0a50513          	addi	a0,a0,-758 # 80007378 <userret+0x2e8>
    80001676:	fffff097          	auipc	ra,0xfffff
    8000167a:	ed8080e7          	jalr	-296(ra) # 8000054e <panic>
      panic("uvmcopy: page not present");
    8000167e:	00006517          	auipc	a0,0x6
    80001682:	d1a50513          	addi	a0,a0,-742 # 80007398 <userret+0x308>
    80001686:	fffff097          	auipc	ra,0xfffff
    8000168a:	ec8080e7          	jalr	-312(ra) # 8000054e <panic>
      kfree(mem);
    8000168e:	854a                	mv	a0,s2
    80001690:	fffff097          	auipc	ra,0xfffff
    80001694:	1d4080e7          	jalr	468(ra) # 80000864 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
    80001698:	4685                	li	a3,1
    8000169a:	864e                	mv	a2,s3
    8000169c:	4581                	li	a1,0
    8000169e:	8556                	mv	a0,s5
    800016a0:	00000097          	auipc	ra,0x0
    800016a4:	cc0080e7          	jalr	-832(ra) # 80001360 <uvmunmap>
  return -1;
    800016a8:	557d                	li	a0,-1
}
    800016aa:	60a6                	ld	ra,72(sp)
    800016ac:	6406                	ld	s0,64(sp)
    800016ae:	74e2                	ld	s1,56(sp)
    800016b0:	7942                	ld	s2,48(sp)
    800016b2:	79a2                	ld	s3,40(sp)
    800016b4:	7a02                	ld	s4,32(sp)
    800016b6:	6ae2                	ld	s5,24(sp)
    800016b8:	6b42                	ld	s6,16(sp)
    800016ba:	6ba2                	ld	s7,8(sp)
    800016bc:	6161                	addi	sp,sp,80
    800016be:	8082                	ret
  return 0;
    800016c0:	4501                	li	a0,0
}
    800016c2:	8082                	ret

00000000800016c4 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016c4:	1141                	addi	sp,sp,-16
    800016c6:	e406                	sd	ra,8(sp)
    800016c8:	e022                	sd	s0,0(sp)
    800016ca:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016cc:	4601                	li	a2,0
    800016ce:	00000097          	auipc	ra,0x0
    800016d2:	926080e7          	jalr	-1754(ra) # 80000ff4 <walk>
  if(pte == 0)
    800016d6:	c901                	beqz	a0,800016e6 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016d8:	611c                	ld	a5,0(a0)
    800016da:	9bbd                	andi	a5,a5,-17
    800016dc:	e11c                	sd	a5,0(a0)
}
    800016de:	60a2                	ld	ra,8(sp)
    800016e0:	6402                	ld	s0,0(sp)
    800016e2:	0141                	addi	sp,sp,16
    800016e4:	8082                	ret
    panic("uvmclear");
    800016e6:	00006517          	auipc	a0,0x6
    800016ea:	cd250513          	addi	a0,a0,-814 # 800073b8 <userret+0x328>
    800016ee:	fffff097          	auipc	ra,0xfffff
    800016f2:	e60080e7          	jalr	-416(ra) # 8000054e <panic>

00000000800016f6 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016f6:	c6bd                	beqz	a3,80001764 <copyout+0x6e>
{
    800016f8:	715d                	addi	sp,sp,-80
    800016fa:	e486                	sd	ra,72(sp)
    800016fc:	e0a2                	sd	s0,64(sp)
    800016fe:	fc26                	sd	s1,56(sp)
    80001700:	f84a                	sd	s2,48(sp)
    80001702:	f44e                	sd	s3,40(sp)
    80001704:	f052                	sd	s4,32(sp)
    80001706:	ec56                	sd	s5,24(sp)
    80001708:	e85a                	sd	s6,16(sp)
    8000170a:	e45e                	sd	s7,8(sp)
    8000170c:	e062                	sd	s8,0(sp)
    8000170e:	0880                	addi	s0,sp,80
    80001710:	8b2a                	mv	s6,a0
    80001712:	8c2e                	mv	s8,a1
    80001714:	8a32                	mv	s4,a2
    80001716:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001718:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000171a:	6a85                	lui	s5,0x1
    8000171c:	a015                	j	80001740 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000171e:	9562                	add	a0,a0,s8
    80001720:	0004861b          	sext.w	a2,s1
    80001724:	85d2                	mv	a1,s4
    80001726:	41250533          	sub	a0,a0,s2
    8000172a:	fffff097          	auipc	ra,0xfffff
    8000172e:	4a4080e7          	jalr	1188(ra) # 80000bce <memmove>

    len -= n;
    80001732:	409989b3          	sub	s3,s3,s1
    src += n;
    80001736:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001738:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000173c:	02098263          	beqz	s3,80001760 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001740:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001744:	85ca                	mv	a1,s2
    80001746:	855a                	mv	a0,s6
    80001748:	00000097          	auipc	ra,0x0
    8000174c:	9e0080e7          	jalr	-1568(ra) # 80001128 <walkaddr>
    if(pa0 == 0)
    80001750:	cd01                	beqz	a0,80001768 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001752:	418904b3          	sub	s1,s2,s8
    80001756:	94d6                	add	s1,s1,s5
    if(n > len)
    80001758:	fc99f3e3          	bgeu	s3,s1,8000171e <copyout+0x28>
    8000175c:	84ce                	mv	s1,s3
    8000175e:	b7c1                	j	8000171e <copyout+0x28>
  }
  return 0;
    80001760:	4501                	li	a0,0
    80001762:	a021                	j	8000176a <copyout+0x74>
    80001764:	4501                	li	a0,0
}
    80001766:	8082                	ret
      return -1;
    80001768:	557d                	li	a0,-1
}
    8000176a:	60a6                	ld	ra,72(sp)
    8000176c:	6406                	ld	s0,64(sp)
    8000176e:	74e2                	ld	s1,56(sp)
    80001770:	7942                	ld	s2,48(sp)
    80001772:	79a2                	ld	s3,40(sp)
    80001774:	7a02                	ld	s4,32(sp)
    80001776:	6ae2                	ld	s5,24(sp)
    80001778:	6b42                	ld	s6,16(sp)
    8000177a:	6ba2                	ld	s7,8(sp)
    8000177c:	6c02                	ld	s8,0(sp)
    8000177e:	6161                	addi	sp,sp,80
    80001780:	8082                	ret

0000000080001782 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001782:	c6bd                	beqz	a3,800017f0 <copyin+0x6e>
{
    80001784:	715d                	addi	sp,sp,-80
    80001786:	e486                	sd	ra,72(sp)
    80001788:	e0a2                	sd	s0,64(sp)
    8000178a:	fc26                	sd	s1,56(sp)
    8000178c:	f84a                	sd	s2,48(sp)
    8000178e:	f44e                	sd	s3,40(sp)
    80001790:	f052                	sd	s4,32(sp)
    80001792:	ec56                	sd	s5,24(sp)
    80001794:	e85a                	sd	s6,16(sp)
    80001796:	e45e                	sd	s7,8(sp)
    80001798:	e062                	sd	s8,0(sp)
    8000179a:	0880                	addi	s0,sp,80
    8000179c:	8b2a                	mv	s6,a0
    8000179e:	8a2e                	mv	s4,a1
    800017a0:	8c32                	mv	s8,a2
    800017a2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017a4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017a6:	6a85                	lui	s5,0x1
    800017a8:	a015                	j	800017cc <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017aa:	9562                	add	a0,a0,s8
    800017ac:	0004861b          	sext.w	a2,s1
    800017b0:	412505b3          	sub	a1,a0,s2
    800017b4:	8552                	mv	a0,s4
    800017b6:	fffff097          	auipc	ra,0xfffff
    800017ba:	418080e7          	jalr	1048(ra) # 80000bce <memmove>

    len -= n;
    800017be:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017c2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017c4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017c8:	02098263          	beqz	s3,800017ec <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    800017cc:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017d0:	85ca                	mv	a1,s2
    800017d2:	855a                	mv	a0,s6
    800017d4:	00000097          	auipc	ra,0x0
    800017d8:	954080e7          	jalr	-1708(ra) # 80001128 <walkaddr>
    if(pa0 == 0)
    800017dc:	cd01                	beqz	a0,800017f4 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    800017de:	418904b3          	sub	s1,s2,s8
    800017e2:	94d6                	add	s1,s1,s5
    if(n > len)
    800017e4:	fc99f3e3          	bgeu	s3,s1,800017aa <copyin+0x28>
    800017e8:	84ce                	mv	s1,s3
    800017ea:	b7c1                	j	800017aa <copyin+0x28>
  }
  return 0;
    800017ec:	4501                	li	a0,0
    800017ee:	a021                	j	800017f6 <copyin+0x74>
    800017f0:	4501                	li	a0,0
}
    800017f2:	8082                	ret
      return -1;
    800017f4:	557d                	li	a0,-1
}
    800017f6:	60a6                	ld	ra,72(sp)
    800017f8:	6406                	ld	s0,64(sp)
    800017fa:	74e2                	ld	s1,56(sp)
    800017fc:	7942                	ld	s2,48(sp)
    800017fe:	79a2                	ld	s3,40(sp)
    80001800:	7a02                	ld	s4,32(sp)
    80001802:	6ae2                	ld	s5,24(sp)
    80001804:	6b42                	ld	s6,16(sp)
    80001806:	6ba2                	ld	s7,8(sp)
    80001808:	6c02                	ld	s8,0(sp)
    8000180a:	6161                	addi	sp,sp,80
    8000180c:	8082                	ret

000000008000180e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000180e:	c6c5                	beqz	a3,800018b6 <copyinstr+0xa8>
{
    80001810:	715d                	addi	sp,sp,-80
    80001812:	e486                	sd	ra,72(sp)
    80001814:	e0a2                	sd	s0,64(sp)
    80001816:	fc26                	sd	s1,56(sp)
    80001818:	f84a                	sd	s2,48(sp)
    8000181a:	f44e                	sd	s3,40(sp)
    8000181c:	f052                	sd	s4,32(sp)
    8000181e:	ec56                	sd	s5,24(sp)
    80001820:	e85a                	sd	s6,16(sp)
    80001822:	e45e                	sd	s7,8(sp)
    80001824:	0880                	addi	s0,sp,80
    80001826:	8a2a                	mv	s4,a0
    80001828:	8b2e                	mv	s6,a1
    8000182a:	8bb2                	mv	s7,a2
    8000182c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000182e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001830:	6985                	lui	s3,0x1
    80001832:	a035                	j	8000185e <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001834:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001838:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000183a:	0017b793          	seqz	a5,a5
    8000183e:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001842:	60a6                	ld	ra,72(sp)
    80001844:	6406                	ld	s0,64(sp)
    80001846:	74e2                	ld	s1,56(sp)
    80001848:	7942                	ld	s2,48(sp)
    8000184a:	79a2                	ld	s3,40(sp)
    8000184c:	7a02                	ld	s4,32(sp)
    8000184e:	6ae2                	ld	s5,24(sp)
    80001850:	6b42                	ld	s6,16(sp)
    80001852:	6ba2                	ld	s7,8(sp)
    80001854:	6161                	addi	sp,sp,80
    80001856:	8082                	ret
    srcva = va0 + PGSIZE;
    80001858:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    8000185c:	c8a9                	beqz	s1,800018ae <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    8000185e:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001862:	85ca                	mv	a1,s2
    80001864:	8552                	mv	a0,s4
    80001866:	00000097          	auipc	ra,0x0
    8000186a:	8c2080e7          	jalr	-1854(ra) # 80001128 <walkaddr>
    if(pa0 == 0)
    8000186e:	c131                	beqz	a0,800018b2 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001870:	41790833          	sub	a6,s2,s7
    80001874:	984e                	add	a6,a6,s3
    if(n > max)
    80001876:	0104f363          	bgeu	s1,a6,8000187c <copyinstr+0x6e>
    8000187a:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000187c:	955e                	add	a0,a0,s7
    8000187e:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001882:	fc080be3          	beqz	a6,80001858 <copyinstr+0x4a>
    80001886:	985a                	add	a6,a6,s6
    80001888:	87da                	mv	a5,s6
      if(*p == '\0'){
    8000188a:	41650633          	sub	a2,a0,s6
    8000188e:	14fd                	addi	s1,s1,-1
    80001890:	9b26                	add	s6,s6,s1
    80001892:	00f60733          	add	a4,a2,a5
    80001896:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8fdc>
    8000189a:	df49                	beqz	a4,80001834 <copyinstr+0x26>
        *dst = *p;
    8000189c:	00e78023          	sb	a4,0(a5)
      --max;
    800018a0:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800018a4:	0785                	addi	a5,a5,1
    while(n > 0){
    800018a6:	ff0796e3          	bne	a5,a6,80001892 <copyinstr+0x84>
      dst++;
    800018aa:	8b42                	mv	s6,a6
    800018ac:	b775                	j	80001858 <copyinstr+0x4a>
    800018ae:	4781                	li	a5,0
    800018b0:	b769                	j	8000183a <copyinstr+0x2c>
      return -1;
    800018b2:	557d                	li	a0,-1
    800018b4:	b779                	j	80001842 <copyinstr+0x34>
  int got_null = 0;
    800018b6:	4781                	li	a5,0
  if(got_null){
    800018b8:	0017b793          	seqz	a5,a5
    800018bc:	40f00533          	neg	a0,a5
}
    800018c0:	8082                	ret

00000000800018c2 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    800018c2:	1101                	addi	sp,sp,-32
    800018c4:	ec06                	sd	ra,24(sp)
    800018c6:	e822                	sd	s0,16(sp)
    800018c8:	e426                	sd	s1,8(sp)
    800018ca:	1000                	addi	s0,sp,32
    800018cc:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800018ce:	15850513          	addi	a0,a0,344
    800018d2:	fffff097          	auipc	ra,0xfffff
    800018d6:	1c0080e7          	jalr	448(ra) # 80000a92 <holding>
    800018da:	c909                	beqz	a0,800018ec <wakeup1+0x2a>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    800018dc:	689c                	ld	a5,16(s1)
    800018de:	00978f63          	beq	a5,s1,800018fc <wakeup1+0x3a>
    p->state = RUNNABLE;
  }
}
    800018e2:	60e2                	ld	ra,24(sp)
    800018e4:	6442                	ld	s0,16(sp)
    800018e6:	64a2                	ld	s1,8(sp)
    800018e8:	6105                	addi	sp,sp,32
    800018ea:	8082                	ret
    panic("wakeup1");
    800018ec:	00006517          	auipc	a0,0x6
    800018f0:	adc50513          	addi	a0,a0,-1316 # 800073c8 <userret+0x338>
    800018f4:	fffff097          	auipc	ra,0xfffff
    800018f8:	c5a080e7          	jalr	-934(ra) # 8000054e <panic>
  if(p->chan == p && p->state == SLEEPING) {
    800018fc:	4098                	lw	a4,0(s1)
    800018fe:	4785                	li	a5,1
    80001900:	fef711e3          	bne	a4,a5,800018e2 <wakeup1+0x20>
    p->state = RUNNABLE;
    80001904:	4789                	li	a5,2
    80001906:	c09c                	sw	a5,0(s1)
}
    80001908:	bfe9                	j	800018e2 <wakeup1+0x20>

000000008000190a <procinit>:
{
    8000190a:	715d                	addi	sp,sp,-80
    8000190c:	e486                	sd	ra,72(sp)
    8000190e:	e0a2                	sd	s0,64(sp)
    80001910:	fc26                	sd	s1,56(sp)
    80001912:	f84a                	sd	s2,48(sp)
    80001914:	f44e                	sd	s3,40(sp)
    80001916:	f052                	sd	s4,32(sp)
    80001918:	ec56                	sd	s5,24(sp)
    8000191a:	e85a                	sd	s6,16(sp)
    8000191c:	e45e                	sd	s7,8(sp)
    8000191e:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001920:	00006597          	auipc	a1,0x6
    80001924:	ab058593          	addi	a1,a1,-1360 # 800073d0 <userret+0x340>
    80001928:	00010517          	auipc	a0,0x10
    8000192c:	fd850513          	addi	a0,a0,-40 # 80011900 <pid_lock>
    80001930:	fffff097          	auipc	ra,0xfffff
    80001934:	090080e7          	jalr	144(ra) # 800009c0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001938:	00010917          	auipc	s2,0x10
    8000193c:	3e090913          	addi	s2,s2,992 # 80011d18 <proc>
      initlock(&p->lock, "proc");
    80001940:	00006b97          	auipc	s7,0x6
    80001944:	a98b8b93          	addi	s7,s7,-1384 # 800073d8 <userret+0x348>
      uint64 va = KSTACK((int) (p - proc));
    80001948:	8b4a                	mv	s6,s2
    8000194a:	00006a97          	auipc	s5,0x6
    8000194e:	186a8a93          	addi	s5,s5,390 # 80007ad0 <syscalls+0xc8>
    80001952:	040009b7          	lui	s3,0x4000
    80001956:	19fd                	addi	s3,s3,-1
    80001958:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000195a:	00016a17          	auipc	s4,0x16
    8000195e:	fbea0a13          	addi	s4,s4,-66 # 80017918 <tickslock>
      initlock(&p->lock, "proc");
    80001962:	85de                	mv	a1,s7
    80001964:	15890513          	addi	a0,s2,344
    80001968:	fffff097          	auipc	ra,0xfffff
    8000196c:	058080e7          	jalr	88(ra) # 800009c0 <initlock>
      char *pa = kalloc();
    80001970:	fffff097          	auipc	ra,0xfffff
    80001974:	ff0080e7          	jalr	-16(ra) # 80000960 <kalloc>
    80001978:	85aa                	mv	a1,a0
      if(pa == 0)
    8000197a:	c929                	beqz	a0,800019cc <procinit+0xc2>
      uint64 va = KSTACK((int) (p - proc));
    8000197c:	416904b3          	sub	s1,s2,s6
    80001980:	8491                	srai	s1,s1,0x4
    80001982:	000ab783          	ld	a5,0(s5)
    80001986:	02f484b3          	mul	s1,s1,a5
    8000198a:	2485                	addiw	s1,s1,1
    8000198c:	00d4949b          	slliw	s1,s1,0xd
    80001990:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001994:	4699                	li	a3,6
    80001996:	6605                	lui	a2,0x1
    80001998:	8526                	mv	a0,s1
    8000199a:	00000097          	auipc	ra,0x0
    8000199e:	8bc080e7          	jalr	-1860(ra) # 80001256 <kvmmap>
      p->kstack = va;
    800019a2:	02993823          	sd	s1,48(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800019a6:	17090913          	addi	s2,s2,368
    800019aa:	fb491ce3          	bne	s2,s4,80001962 <procinit+0x58>
  kvminithart();
    800019ae:	fffff097          	auipc	ra,0xfffff
    800019b2:	756080e7          	jalr	1878(ra) # 80001104 <kvminithart>
}
    800019b6:	60a6                	ld	ra,72(sp)
    800019b8:	6406                	ld	s0,64(sp)
    800019ba:	74e2                	ld	s1,56(sp)
    800019bc:	7942                	ld	s2,48(sp)
    800019be:	79a2                	ld	s3,40(sp)
    800019c0:	7a02                	ld	s4,32(sp)
    800019c2:	6ae2                	ld	s5,24(sp)
    800019c4:	6b42                	ld	s6,16(sp)
    800019c6:	6ba2                	ld	s7,8(sp)
    800019c8:	6161                	addi	sp,sp,80
    800019ca:	8082                	ret
        panic("kalloc");
    800019cc:	00006517          	auipc	a0,0x6
    800019d0:	a1450513          	addi	a0,a0,-1516 # 800073e0 <userret+0x350>
    800019d4:	fffff097          	auipc	ra,0xfffff
    800019d8:	b7a080e7          	jalr	-1158(ra) # 8000054e <panic>

00000000800019dc <cpuid>:
{
    800019dc:	1141                	addi	sp,sp,-16
    800019de:	e422                	sd	s0,8(sp)
    800019e0:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800019e2:	8512                	mv	a0,tp
}
    800019e4:	2501                	sext.w	a0,a0
    800019e6:	6422                	ld	s0,8(sp)
    800019e8:	0141                	addi	sp,sp,16
    800019ea:	8082                	ret

00000000800019ec <mycpu>:
mycpu(void) {
    800019ec:	1141                	addi	sp,sp,-16
    800019ee:	e422                	sd	s0,8(sp)
    800019f0:	0800                	addi	s0,sp,16
    800019f2:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    800019f4:	2781                	sext.w	a5,a5
    800019f6:	079e                	slli	a5,a5,0x7
}
    800019f8:	00010517          	auipc	a0,0x10
    800019fc:	f2050513          	addi	a0,a0,-224 # 80011918 <cpus>
    80001a00:	953e                	add	a0,a0,a5
    80001a02:	6422                	ld	s0,8(sp)
    80001a04:	0141                	addi	sp,sp,16
    80001a06:	8082                	ret

0000000080001a08 <myproc>:
myproc(void) {
    80001a08:	1101                	addi	sp,sp,-32
    80001a0a:	ec06                	sd	ra,24(sp)
    80001a0c:	e822                	sd	s0,16(sp)
    80001a0e:	e426                	sd	s1,8(sp)
    80001a10:	1000                	addi	s0,sp,32
  push_off();
    80001a12:	fffff097          	auipc	ra,0xfffff
    80001a16:	fc4080e7          	jalr	-60(ra) # 800009d6 <push_off>
    80001a1a:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001a1c:	2781                	sext.w	a5,a5
    80001a1e:	079e                	slli	a5,a5,0x7
    80001a20:	00010717          	auipc	a4,0x10
    80001a24:	ee070713          	addi	a4,a4,-288 # 80011900 <pid_lock>
    80001a28:	97ba                	add	a5,a5,a4
    80001a2a:	6f84                	ld	s1,24(a5)
  pop_off();
    80001a2c:	fffff097          	auipc	ra,0xfffff
    80001a30:	ff6080e7          	jalr	-10(ra) # 80000a22 <pop_off>
}
    80001a34:	8526                	mv	a0,s1
    80001a36:	60e2                	ld	ra,24(sp)
    80001a38:	6442                	ld	s0,16(sp)
    80001a3a:	64a2                	ld	s1,8(sp)
    80001a3c:	6105                	addi	sp,sp,32
    80001a3e:	8082                	ret

0000000080001a40 <forkret>:
{
    80001a40:	1141                	addi	sp,sp,-16
    80001a42:	e406                	sd	ra,8(sp)
    80001a44:	e022                	sd	s0,0(sp)
    80001a46:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001a48:	00000097          	auipc	ra,0x0
    80001a4c:	fc0080e7          	jalr	-64(ra) # 80001a08 <myproc>
    80001a50:	15850513          	addi	a0,a0,344
    80001a54:	fffff097          	auipc	ra,0xfffff
    80001a58:	0d2080e7          	jalr	210(ra) # 80000b26 <release>
  release(&l_r_c);
    80001a5c:	00010517          	auipc	a0,0x10
    80001a60:	e8c50513          	addi	a0,a0,-372 # 800118e8 <l_r_c>
    80001a64:	fffff097          	auipc	ra,0xfffff
    80001a68:	0c2080e7          	jalr	194(ra) # 80000b26 <release>
  if (first) {
    80001a6c:	00006797          	auipc	a5,0x6
    80001a70:	5c87a783          	lw	a5,1480(a5) # 80008034 <first.1708>
    80001a74:	eb89                	bnez	a5,80001a86 <forkret+0x46>
  usertrapret();
    80001a76:	00001097          	auipc	ra,0x1
    80001a7a:	106080e7          	jalr	262(ra) # 80002b7c <usertrapret>
}
    80001a7e:	60a2                	ld	ra,8(sp)
    80001a80:	6402                	ld	s0,0(sp)
    80001a82:	0141                	addi	sp,sp,16
    80001a84:	8082                	ret
    first = 0;
    80001a86:	00006797          	auipc	a5,0x6
    80001a8a:	5a07a723          	sw	zero,1454(a5) # 80008034 <first.1708>
    fsinit(ROOTDEV);
    80001a8e:	4505                	li	a0,1
    80001a90:	00002097          	auipc	ra,0x2
    80001a94:	e46080e7          	jalr	-442(ra) # 800038d6 <fsinit>
    80001a98:	bff9                	j	80001a76 <forkret+0x36>

0000000080001a9a <allocpid>:
allocpid() {
    80001a9a:	1101                	addi	sp,sp,-32
    80001a9c:	ec06                	sd	ra,24(sp)
    80001a9e:	e822                	sd	s0,16(sp)
    80001aa0:	e426                	sd	s1,8(sp)
    80001aa2:	e04a                	sd	s2,0(sp)
    80001aa4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001aa6:	00010917          	auipc	s2,0x10
    80001aaa:	e5a90913          	addi	s2,s2,-422 # 80011900 <pid_lock>
    80001aae:	854a                	mv	a0,s2
    80001ab0:	fffff097          	auipc	ra,0xfffff
    80001ab4:	022080e7          	jalr	34(ra) # 80000ad2 <acquire>
  pid = nextpid;
    80001ab8:	00006797          	auipc	a5,0x6
    80001abc:	58078793          	addi	a5,a5,1408 # 80008038 <nextpid>
    80001ac0:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001ac2:	0014871b          	addiw	a4,s1,1
    80001ac6:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001ac8:	854a                	mv	a0,s2
    80001aca:	fffff097          	auipc	ra,0xfffff
    80001ace:	05c080e7          	jalr	92(ra) # 80000b26 <release>
}
    80001ad2:	8526                	mv	a0,s1
    80001ad4:	60e2                	ld	ra,24(sp)
    80001ad6:	6442                	ld	s0,16(sp)
    80001ad8:	64a2                	ld	s1,8(sp)
    80001ada:	6902                	ld	s2,0(sp)
    80001adc:	6105                	addi	sp,sp,32
    80001ade:	8082                	ret

0000000080001ae0 <proc_pagetable>:
{
    80001ae0:	1101                	addi	sp,sp,-32
    80001ae2:	ec06                	sd	ra,24(sp)
    80001ae4:	e822                	sd	s0,16(sp)
    80001ae6:	e426                	sd	s1,8(sp)
    80001ae8:	e04a                	sd	s2,0(sp)
    80001aea:	1000                	addi	s0,sp,32
    80001aec:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001aee:	00000097          	auipc	ra,0x0
    80001af2:	93a080e7          	jalr	-1734(ra) # 80001428 <uvmcreate>
    80001af6:	84aa                	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001af8:	4729                	li	a4,10
    80001afa:	00005697          	auipc	a3,0x5
    80001afe:	50668693          	addi	a3,a3,1286 # 80007000 <trampoline>
    80001b02:	6605                	lui	a2,0x1
    80001b04:	040005b7          	lui	a1,0x4000
    80001b08:	15fd                	addi	a1,a1,-1
    80001b0a:	05b2                	slli	a1,a1,0xc
    80001b0c:	fffff097          	auipc	ra,0xfffff
    80001b10:	6bc080e7          	jalr	1724(ra) # 800011c8 <mappages>
  mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b14:	4719                	li	a4,6
    80001b16:	04893683          	ld	a3,72(s2)
    80001b1a:	6605                	lui	a2,0x1
    80001b1c:	020005b7          	lui	a1,0x2000
    80001b20:	15fd                	addi	a1,a1,-1
    80001b22:	05b6                	slli	a1,a1,0xd
    80001b24:	8526                	mv	a0,s1
    80001b26:	fffff097          	auipc	ra,0xfffff
    80001b2a:	6a2080e7          	jalr	1698(ra) # 800011c8 <mappages>
}
    80001b2e:	8526                	mv	a0,s1
    80001b30:	60e2                	ld	ra,24(sp)
    80001b32:	6442                	ld	s0,16(sp)
    80001b34:	64a2                	ld	s1,8(sp)
    80001b36:	6902                	ld	s2,0(sp)
    80001b38:	6105                	addi	sp,sp,32
    80001b3a:	8082                	ret

0000000080001b3c <allocproc>:
{
    80001b3c:	7179                	addi	sp,sp,-48
    80001b3e:	f406                	sd	ra,40(sp)
    80001b40:	f022                	sd	s0,32(sp)
    80001b42:	ec26                	sd	s1,24(sp)
    80001b44:	e84a                	sd	s2,16(sp)
    80001b46:	e44e                	sd	s3,8(sp)
    80001b48:	1800                	addi	s0,sp,48
  acquire(&l_r_c);
    80001b4a:	00010517          	auipc	a0,0x10
    80001b4e:	d9e50513          	addi	a0,a0,-610 # 800118e8 <l_r_c>
    80001b52:	fffff097          	auipc	ra,0xfffff
    80001b56:	f80080e7          	jalr	-128(ra) # 80000ad2 <acquire>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b5a:	00010497          	auipc	s1,0x10
    80001b5e:	1be48493          	addi	s1,s1,446 # 80011d18 <proc>
    80001b62:	00016997          	auipc	s3,0x16
    80001b66:	db698993          	addi	s3,s3,-586 # 80017918 <tickslock>
    acquire(&p->lock);
    80001b6a:	15848913          	addi	s2,s1,344
    80001b6e:	854a                	mv	a0,s2
    80001b70:	fffff097          	auipc	ra,0xfffff
    80001b74:	f62080e7          	jalr	-158(ra) # 80000ad2 <acquire>
    if(p->state == UNUSED) {
    80001b78:	409c                	lw	a5,0(s1)
    80001b7a:	c785                	beqz	a5,80001ba2 <allocproc+0x66>
      release(&p->lock);
    80001b7c:	854a                	mv	a0,s2
    80001b7e:	fffff097          	auipc	ra,0xfffff
    80001b82:	fa8080e7          	jalr	-88(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b86:	17048493          	addi	s1,s1,368
    80001b8a:	ff3490e3          	bne	s1,s3,80001b6a <allocproc+0x2e>
  release(&l_r_c);
    80001b8e:	00010517          	auipc	a0,0x10
    80001b92:	d5a50513          	addi	a0,a0,-678 # 800118e8 <l_r_c>
    80001b96:	fffff097          	auipc	ra,0xfffff
    80001b9a:	f90080e7          	jalr	-112(ra) # 80000b26 <release>
  return 0;
    80001b9e:	4481                	li	s1,0
    80001ba0:	a899                	j	80001bf6 <allocproc+0xba>
  p->pid = allocpid();
    80001ba2:	00000097          	auipc	ra,0x0
    80001ba6:	ef8080e7          	jalr	-264(ra) # 80001a9a <allocpid>
    80001baa:	d088                	sw	a0,32(s1)
  p->ticket = 1; //p2b
    80001bac:	4785                	li	a5,1
    80001bae:	d0dc                	sw	a5,36(s1)
  p->start_tick = 0; //p2b
    80001bb0:	0204a423          	sw	zero,40(s1)
  p->total_tick = 0; //p2b
    80001bb4:	0204a623          	sw	zero,44(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    80001bb8:	fffff097          	auipc	ra,0xfffff
    80001bbc:	da8080e7          	jalr	-600(ra) # 80000960 <kalloc>
    80001bc0:	89aa                	mv	s3,a0
    80001bc2:	e4a8                	sd	a0,72(s1)
    80001bc4:	c129                	beqz	a0,80001c06 <allocproc+0xca>
  p->pagetable = proc_pagetable(p);
    80001bc6:	8526                	mv	a0,s1
    80001bc8:	00000097          	auipc	ra,0x0
    80001bcc:	f18080e7          	jalr	-232(ra) # 80001ae0 <proc_pagetable>
    80001bd0:	e0a8                	sd	a0,64(s1)
  memset(&p->context, 0, sizeof p->context);
    80001bd2:	07000613          	li	a2,112
    80001bd6:	4581                	li	a1,0
    80001bd8:	05048513          	addi	a0,s1,80
    80001bdc:	fffff097          	auipc	ra,0xfffff
    80001be0:	f92080e7          	jalr	-110(ra) # 80000b6e <memset>
  p->context.ra = (uint64)forkret; //return address
    80001be4:	00000797          	auipc	a5,0x0
    80001be8:	e5c78793          	addi	a5,a5,-420 # 80001a40 <forkret>
    80001bec:	e8bc                	sd	a5,80(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001bee:	789c                	ld	a5,48(s1)
    80001bf0:	6705                	lui	a4,0x1
    80001bf2:	97ba                	add	a5,a5,a4
    80001bf4:	ecbc                	sd	a5,88(s1)
}
    80001bf6:	8526                	mv	a0,s1
    80001bf8:	70a2                	ld	ra,40(sp)
    80001bfa:	7402                	ld	s0,32(sp)
    80001bfc:	64e2                	ld	s1,24(sp)
    80001bfe:	6942                	ld	s2,16(sp)
    80001c00:	69a2                	ld	s3,8(sp)
    80001c02:	6145                	addi	sp,sp,48
    80001c04:	8082                	ret
    release(&p->lock);
    80001c06:	854a                	mv	a0,s2
    80001c08:	fffff097          	auipc	ra,0xfffff
    80001c0c:	f1e080e7          	jalr	-226(ra) # 80000b26 <release>
    release(&l_r_c);
    80001c10:	00010517          	auipc	a0,0x10
    80001c14:	cd850513          	addi	a0,a0,-808 # 800118e8 <l_r_c>
    80001c18:	fffff097          	auipc	ra,0xfffff
    80001c1c:	f0e080e7          	jalr	-242(ra) # 80000b26 <release>
    return 0;
    80001c20:	84ce                	mv	s1,s3
    80001c22:	bfd1                	j	80001bf6 <allocproc+0xba>

0000000080001c24 <proc_freepagetable>:
{
    80001c24:	1101                	addi	sp,sp,-32
    80001c26:	ec06                	sd	ra,24(sp)
    80001c28:	e822                	sd	s0,16(sp)
    80001c2a:	e426                	sd	s1,8(sp)
    80001c2c:	e04a                	sd	s2,0(sp)
    80001c2e:	1000                	addi	s0,sp,32
    80001c30:	84aa                	mv	s1,a0
    80001c32:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    80001c34:	4681                	li	a3,0
    80001c36:	6605                	lui	a2,0x1
    80001c38:	040005b7          	lui	a1,0x4000
    80001c3c:	15fd                	addi	a1,a1,-1
    80001c3e:	05b2                	slli	a1,a1,0xc
    80001c40:	fffff097          	auipc	ra,0xfffff
    80001c44:	720080e7          	jalr	1824(ra) # 80001360 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, PGSIZE, 0);
    80001c48:	4681                	li	a3,0
    80001c4a:	6605                	lui	a2,0x1
    80001c4c:	020005b7          	lui	a1,0x2000
    80001c50:	15fd                	addi	a1,a1,-1
    80001c52:	05b6                	slli	a1,a1,0xd
    80001c54:	8526                	mv	a0,s1
    80001c56:	fffff097          	auipc	ra,0xfffff
    80001c5a:	70a080e7          	jalr	1802(ra) # 80001360 <uvmunmap>
  if(sz > 0)
    80001c5e:	00091863          	bnez	s2,80001c6e <proc_freepagetable+0x4a>
}
    80001c62:	60e2                	ld	ra,24(sp)
    80001c64:	6442                	ld	s0,16(sp)
    80001c66:	64a2                	ld	s1,8(sp)
    80001c68:	6902                	ld	s2,0(sp)
    80001c6a:	6105                	addi	sp,sp,32
    80001c6c:	8082                	ret
    uvmfree(pagetable, sz);
    80001c6e:	85ca                	mv	a1,s2
    80001c70:	8526                	mv	a0,s1
    80001c72:	00000097          	auipc	ra,0x0
    80001c76:	954080e7          	jalr	-1708(ra) # 800015c6 <uvmfree>
}
    80001c7a:	b7e5                	j	80001c62 <proc_freepagetable+0x3e>

0000000080001c7c <freeproc>:
{
    80001c7c:	1101                	addi	sp,sp,-32
    80001c7e:	ec06                	sd	ra,24(sp)
    80001c80:	e822                	sd	s0,16(sp)
    80001c82:	e426                	sd	s1,8(sp)
    80001c84:	1000                	addi	s0,sp,32
    80001c86:	84aa                	mv	s1,a0
  if(p->tf)
    80001c88:	6528                	ld	a0,72(a0)
    80001c8a:	c509                	beqz	a0,80001c94 <freeproc+0x18>
    kfree((void*)p->tf);
    80001c8c:	fffff097          	auipc	ra,0xfffff
    80001c90:	bd8080e7          	jalr	-1064(ra) # 80000864 <kfree>
  p->tf = 0;
    80001c94:	0404b423          	sd	zero,72(s1)
  if(p->pagetable)
    80001c98:	60a8                	ld	a0,64(s1)
    80001c9a:	c511                	beqz	a0,80001ca6 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001c9c:	7c8c                	ld	a1,56(s1)
    80001c9e:	00000097          	auipc	ra,0x0
    80001ca2:	f86080e7          	jalr	-122(ra) # 80001c24 <proc_freepagetable>
  p->pagetable = 0;
    80001ca6:	0404b023          	sd	zero,64(s1)
  p->sz = 0;
    80001caa:	0204bc23          	sd	zero,56(s1)
  p->pid = 0;
    80001cae:	0204a023          	sw	zero,32(s1)
  p->parent = 0;
    80001cb2:	0004b423          	sd	zero,8(s1)
  p->name[0] = 0;
    80001cb6:	14048423          	sb	zero,328(s1)
  p->chan = 0;
    80001cba:	0004b823          	sd	zero,16(s1)
  p->killed = 0;
    80001cbe:	0004ac23          	sw	zero,24(s1)
  p->xstate = 0;
    80001cc2:	0004ae23          	sw	zero,28(s1)
  p->state = UNUSED;
    80001cc6:	0004a023          	sw	zero,0(s1)
  p->ticket = 0; //p2b
    80001cca:	0204a223          	sw	zero,36(s1)
  p->start_tick = 0; //p2b
    80001cce:	0204a423          	sw	zero,40(s1)
  p->total_tick = 0; //p2b
    80001cd2:	0204a623          	sw	zero,44(s1)
}
    80001cd6:	60e2                	ld	ra,24(sp)
    80001cd8:	6442                	ld	s0,16(sp)
    80001cda:	64a2                	ld	s1,8(sp)
    80001cdc:	6105                	addi	sp,sp,32
    80001cde:	8082                	ret

0000000080001ce0 <userinit>:
{
    80001ce0:	1101                	addi	sp,sp,-32
    80001ce2:	ec06                	sd	ra,24(sp)
    80001ce4:	e822                	sd	s0,16(sp)
    80001ce6:	e426                	sd	s1,8(sp)
    80001ce8:	1000                	addi	s0,sp,32
  p = allocproc(); //get the return address
    80001cea:	00000097          	auipc	ra,0x0
    80001cee:	e52080e7          	jalr	-430(ra) # 80001b3c <allocproc>
    80001cf2:	84aa                	mv	s1,a0
  initproc = p;
    80001cf4:	00024797          	auipc	a5,0x24
    80001cf8:	32a7b223          	sd	a0,804(a5) # 80026018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001cfc:	03300613          	li	a2,51
    80001d00:	00006597          	auipc	a1,0x6
    80001d04:	30058593          	addi	a1,a1,768 # 80008000 <initcode>
    80001d08:	6128                	ld	a0,64(a0)
    80001d0a:	fffff097          	auipc	ra,0xfffff
    80001d0e:	75c080e7          	jalr	1884(ra) # 80001466 <uvminit>
  p->sz = PGSIZE;
    80001d12:	6785                	lui	a5,0x1
    80001d14:	fc9c                	sd	a5,56(s1)
  p->tf->epc = 0;      // user program counter
    80001d16:	64b8                	ld	a4,72(s1)
    80001d18:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->tf->sp = PGSIZE;  // user stack pointer
    80001d1c:	64b8                	ld	a4,72(s1)
    80001d1e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d20:	4641                	li	a2,16
    80001d22:	00005597          	auipc	a1,0x5
    80001d26:	6c658593          	addi	a1,a1,1734 # 800073e8 <userret+0x358>
    80001d2a:	14848513          	addi	a0,s1,328
    80001d2e:	fffff097          	auipc	ra,0xfffff
    80001d32:	f96080e7          	jalr	-106(ra) # 80000cc4 <safestrcpy>
  p->cwd = namei("/");
    80001d36:	00005517          	auipc	a0,0x5
    80001d3a:	6c250513          	addi	a0,a0,1730 # 800073f8 <userret+0x368>
    80001d3e:	00002097          	auipc	ra,0x2
    80001d42:	59a080e7          	jalr	1434(ra) # 800042d8 <namei>
    80001d46:	14a4b023          	sd	a0,320(s1)
  p->state = RUNNABLE;
    80001d4a:	4789                	li	a5,2
    80001d4c:	c09c                	sw	a5,0(s1)
  release(&p->lock);
    80001d4e:	15848513          	addi	a0,s1,344
    80001d52:	fffff097          	auipc	ra,0xfffff
    80001d56:	dd4080e7          	jalr	-556(ra) # 80000b26 <release>
  release(&l_r_c);
    80001d5a:	00010517          	auipc	a0,0x10
    80001d5e:	b8e50513          	addi	a0,a0,-1138 # 800118e8 <l_r_c>
    80001d62:	fffff097          	auipc	ra,0xfffff
    80001d66:	dc4080e7          	jalr	-572(ra) # 80000b26 <release>
}
    80001d6a:	60e2                	ld	ra,24(sp)
    80001d6c:	6442                	ld	s0,16(sp)
    80001d6e:	64a2                	ld	s1,8(sp)
    80001d70:	6105                	addi	sp,sp,32
    80001d72:	8082                	ret

0000000080001d74 <growproc>:
{
    80001d74:	1101                	addi	sp,sp,-32
    80001d76:	ec06                	sd	ra,24(sp)
    80001d78:	e822                	sd	s0,16(sp)
    80001d7a:	e426                	sd	s1,8(sp)
    80001d7c:	e04a                	sd	s2,0(sp)
    80001d7e:	1000                	addi	s0,sp,32
    80001d80:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d82:	00000097          	auipc	ra,0x0
    80001d86:	c86080e7          	jalr	-890(ra) # 80001a08 <myproc>
    80001d8a:	892a                	mv	s2,a0
  sz = p->sz;
    80001d8c:	7d0c                	ld	a1,56(a0)
    80001d8e:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001d92:	00904f63          	bgtz	s1,80001db0 <growproc+0x3c>
  } else if(n < 0){
    80001d96:	0204cc63          	bltz	s1,80001dce <growproc+0x5a>
  p->sz = sz;
    80001d9a:	1602                	slli	a2,a2,0x20
    80001d9c:	9201                	srli	a2,a2,0x20
    80001d9e:	02c93c23          	sd	a2,56(s2)
  return 0;
    80001da2:	4501                	li	a0,0
}
    80001da4:	60e2                	ld	ra,24(sp)
    80001da6:	6442                	ld	s0,16(sp)
    80001da8:	64a2                	ld	s1,8(sp)
    80001daa:	6902                	ld	s2,0(sp)
    80001dac:	6105                	addi	sp,sp,32
    80001dae:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001db0:	9e25                	addw	a2,a2,s1
    80001db2:	1602                	slli	a2,a2,0x20
    80001db4:	9201                	srli	a2,a2,0x20
    80001db6:	1582                	slli	a1,a1,0x20
    80001db8:	9181                	srli	a1,a1,0x20
    80001dba:	6128                	ld	a0,64(a0)
    80001dbc:	fffff097          	auipc	ra,0xfffff
    80001dc0:	760080e7          	jalr	1888(ra) # 8000151c <uvmalloc>
    80001dc4:	0005061b          	sext.w	a2,a0
    80001dc8:	fa69                	bnez	a2,80001d9a <growproc+0x26>
      return -1;
    80001dca:	557d                	li	a0,-1
    80001dcc:	bfe1                	j	80001da4 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001dce:	9e25                	addw	a2,a2,s1
    80001dd0:	1602                	slli	a2,a2,0x20
    80001dd2:	9201                	srli	a2,a2,0x20
    80001dd4:	1582                	slli	a1,a1,0x20
    80001dd6:	9181                	srli	a1,a1,0x20
    80001dd8:	6128                	ld	a0,64(a0)
    80001dda:	fffff097          	auipc	ra,0xfffff
    80001dde:	6fe080e7          	jalr	1790(ra) # 800014d8 <uvmdealloc>
    80001de2:	0005061b          	sext.w	a2,a0
    80001de6:	bf55                	j	80001d9a <growproc+0x26>

0000000080001de8 <fork>:
{
    80001de8:	7179                	addi	sp,sp,-48
    80001dea:	f406                	sd	ra,40(sp)
    80001dec:	f022                	sd	s0,32(sp)
    80001dee:	ec26                	sd	s1,24(sp)
    80001df0:	e84a                	sd	s2,16(sp)
    80001df2:	e44e                	sd	s3,8(sp)
    80001df4:	e052                	sd	s4,0(sp)
    80001df6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001df8:	00000097          	auipc	ra,0x0
    80001dfc:	c10080e7          	jalr	-1008(ra) # 80001a08 <myproc>
    80001e00:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001e02:	00000097          	auipc	ra,0x0
    80001e06:	d3a080e7          	jalr	-710(ra) # 80001b3c <allocproc>
    80001e0a:	10050963          	beqz	a0,80001f1c <fork+0x134>
    80001e0e:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e10:	03893603          	ld	a2,56(s2)
    80001e14:	612c                	ld	a1,64(a0)
    80001e16:	04093503          	ld	a0,64(s2)
    80001e1a:	fffff097          	auipc	ra,0xfffff
    80001e1e:	7da080e7          	jalr	2010(ra) # 800015f4 <uvmcopy>
    80001e22:	04054c63          	bltz	a0,80001e7a <fork+0x92>
  np->sz = p->sz;
    80001e26:	03893783          	ld	a5,56(s2)
    80001e2a:	02f9bc23          	sd	a5,56(s3)
  np->ticket = p->ticket; //p2b added
    80001e2e:	02492783          	lw	a5,36(s2)
    80001e32:	02f9a223          	sw	a5,36(s3)
  np->parent = p;
    80001e36:	0129b423          	sd	s2,8(s3)
  *(np->tf) = *(p->tf);
    80001e3a:	04893683          	ld	a3,72(s2)
    80001e3e:	87b6                	mv	a5,a3
    80001e40:	0489b703          	ld	a4,72(s3)
    80001e44:	12068693          	addi	a3,a3,288
    80001e48:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e4c:	6788                	ld	a0,8(a5)
    80001e4e:	6b8c                	ld	a1,16(a5)
    80001e50:	6f90                	ld	a2,24(a5)
    80001e52:	01073023          	sd	a6,0(a4)
    80001e56:	e708                	sd	a0,8(a4)
    80001e58:	eb0c                	sd	a1,16(a4)
    80001e5a:	ef10                	sd	a2,24(a4)
    80001e5c:	02078793          	addi	a5,a5,32
    80001e60:	02070713          	addi	a4,a4,32
    80001e64:	fed792e3          	bne	a5,a3,80001e48 <fork+0x60>
  np->tf->a0 = 0;
    80001e68:	0489b783          	ld	a5,72(s3)
    80001e6c:	0607b823          	sd	zero,112(a5)
    80001e70:	0c000493          	li	s1,192
  for(i = 0; i < NOFILE; i++)
    80001e74:	14000a13          	li	s4,320
    80001e78:	a081                	j	80001eb8 <fork+0xd0>
    freeproc(np);
    80001e7a:	854e                	mv	a0,s3
    80001e7c:	00000097          	auipc	ra,0x0
    80001e80:	e00080e7          	jalr	-512(ra) # 80001c7c <freeproc>
    release(&np->lock);
    80001e84:	15898513          	addi	a0,s3,344
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	c9e080e7          	jalr	-866(ra) # 80000b26 <release>
    release(&l_r_c);
    80001e90:	00010517          	auipc	a0,0x10
    80001e94:	a5850513          	addi	a0,a0,-1448 # 800118e8 <l_r_c>
    80001e98:	fffff097          	auipc	ra,0xfffff
    80001e9c:	c8e080e7          	jalr	-882(ra) # 80000b26 <release>
    return -1;
    80001ea0:	54fd                	li	s1,-1
    80001ea2:	a0a5                	j	80001f0a <fork+0x122>
      np->ofile[i] = filedup(p->ofile[i]);
    80001ea4:	00003097          	auipc	ra,0x3
    80001ea8:	ac0080e7          	jalr	-1344(ra) # 80004964 <filedup>
    80001eac:	009987b3          	add	a5,s3,s1
    80001eb0:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001eb2:	04a1                	addi	s1,s1,8
    80001eb4:	01448763          	beq	s1,s4,80001ec2 <fork+0xda>
    if(p->ofile[i])
    80001eb8:	009907b3          	add	a5,s2,s1
    80001ebc:	6388                	ld	a0,0(a5)
    80001ebe:	f17d                	bnez	a0,80001ea4 <fork+0xbc>
    80001ec0:	bfcd                	j	80001eb2 <fork+0xca>
  np->cwd = idup(p->cwd);
    80001ec2:	14093503          	ld	a0,320(s2)
    80001ec6:	00002097          	auipc	ra,0x2
    80001eca:	c4a080e7          	jalr	-950(ra) # 80003b10 <idup>
    80001ece:	14a9b023          	sd	a0,320(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ed2:	4641                	li	a2,16
    80001ed4:	14890593          	addi	a1,s2,328
    80001ed8:	14898513          	addi	a0,s3,328
    80001edc:	fffff097          	auipc	ra,0xfffff
    80001ee0:	de8080e7          	jalr	-536(ra) # 80000cc4 <safestrcpy>
  pid = np->pid;
    80001ee4:	0209a483          	lw	s1,32(s3)
  np->state = RUNNABLE;
    80001ee8:	4789                	li	a5,2
    80001eea:	00f9a023          	sw	a5,0(s3)
  release(&np->lock);
    80001eee:	15898513          	addi	a0,s3,344
    80001ef2:	fffff097          	auipc	ra,0xfffff
    80001ef6:	c34080e7          	jalr	-972(ra) # 80000b26 <release>
  release(&l_r_c);
    80001efa:	00010517          	auipc	a0,0x10
    80001efe:	9ee50513          	addi	a0,a0,-1554 # 800118e8 <l_r_c>
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	c24080e7          	jalr	-988(ra) # 80000b26 <release>
}
    80001f0a:	8526                	mv	a0,s1
    80001f0c:	70a2                	ld	ra,40(sp)
    80001f0e:	7402                	ld	s0,32(sp)
    80001f10:	64e2                	ld	s1,24(sp)
    80001f12:	6942                	ld	s2,16(sp)
    80001f14:	69a2                	ld	s3,8(sp)
    80001f16:	6a02                	ld	s4,0(sp)
    80001f18:	6145                	addi	sp,sp,48
    80001f1a:	8082                	ret
    return -1;
    80001f1c:	54fd                	li	s1,-1
    80001f1e:	b7f5                	j	80001f0a <fork+0x122>

0000000080001f20 <reparent>:
{
    80001f20:	7139                	addi	sp,sp,-64
    80001f22:	fc06                	sd	ra,56(sp)
    80001f24:	f822                	sd	s0,48(sp)
    80001f26:	f426                	sd	s1,40(sp)
    80001f28:	f04a                	sd	s2,32(sp)
    80001f2a:	ec4e                	sd	s3,24(sp)
    80001f2c:	e852                	sd	s4,16(sp)
    80001f2e:	e456                	sd	s5,8(sp)
    80001f30:	0080                	addi	s0,sp,64
    80001f32:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f34:	00010497          	auipc	s1,0x10
    80001f38:	de448493          	addi	s1,s1,-540 # 80011d18 <proc>
      pp->parent = initproc;
    80001f3c:	00024a97          	auipc	s5,0x24
    80001f40:	0dca8a93          	addi	s5,s5,220 # 80026018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f44:	00016997          	auipc	s3,0x16
    80001f48:	9d498993          	addi	s3,s3,-1580 # 80017918 <tickslock>
    80001f4c:	a029                	j	80001f56 <reparent+0x36>
    80001f4e:	17048493          	addi	s1,s1,368
    80001f52:	03348563          	beq	s1,s3,80001f7c <reparent+0x5c>
    if(pp->parent == p){
    80001f56:	649c                	ld	a5,8(s1)
    80001f58:	ff279be3          	bne	a5,s2,80001f4e <reparent+0x2e>
      acquire(&pp->lock);
    80001f5c:	15848a13          	addi	s4,s1,344
    80001f60:	8552                	mv	a0,s4
    80001f62:	fffff097          	auipc	ra,0xfffff
    80001f66:	b70080e7          	jalr	-1168(ra) # 80000ad2 <acquire>
      pp->parent = initproc;
    80001f6a:	000ab783          	ld	a5,0(s5)
    80001f6e:	e49c                	sd	a5,8(s1)
      release(&pp->lock);
    80001f70:	8552                	mv	a0,s4
    80001f72:	fffff097          	auipc	ra,0xfffff
    80001f76:	bb4080e7          	jalr	-1100(ra) # 80000b26 <release>
    80001f7a:	bfd1                	j	80001f4e <reparent+0x2e>
}
    80001f7c:	70e2                	ld	ra,56(sp)
    80001f7e:	7442                	ld	s0,48(sp)
    80001f80:	74a2                	ld	s1,40(sp)
    80001f82:	7902                	ld	s2,32(sp)
    80001f84:	69e2                	ld	s3,24(sp)
    80001f86:	6a42                	ld	s4,16(sp)
    80001f88:	6aa2                	ld	s5,8(sp)
    80001f8a:	6121                	addi	sp,sp,64
    80001f8c:	8082                	ret

0000000080001f8e <settickets>:
    if(num<1) //check
    80001f8e:	06a05163          	blez	a0,80001ff0 <settickets+0x62>
{
    80001f92:	7179                	addi	sp,sp,-48
    80001f94:	f406                	sd	ra,40(sp)
    80001f96:	f022                	sd	s0,32(sp)
    80001f98:	ec26                	sd	s1,24(sp)
    80001f9a:	e84a                	sd	s2,16(sp)
    80001f9c:	e44e                	sd	s3,8(sp)
    80001f9e:	1800                	addi	s0,sp,48
    80001fa0:	84aa                	mv	s1,a0
    80001fa2:	892e                	mv	s2,a1
    acquire(&l_r_c); //for access the process table
    80001fa4:	00010517          	auipc	a0,0x10
    80001fa8:	94450513          	addi	a0,a0,-1724 # 800118e8 <l_r_c>
    80001fac:	fffff097          	auipc	ra,0xfffff
    80001fb0:	b26080e7          	jalr	-1242(ra) # 80000ad2 <acquire>
    acquire(&p->lock);
    80001fb4:	15890993          	addi	s3,s2,344
    80001fb8:	854e                	mv	a0,s3
    80001fba:	fffff097          	auipc	ra,0xfffff
    80001fbe:	b18080e7          	jalr	-1256(ra) # 80000ad2 <acquire>
    p->ticket = num;
    80001fc2:	02992223          	sw	s1,36(s2)
    release(&p->lock);
    80001fc6:	854e                	mv	a0,s3
    80001fc8:	fffff097          	auipc	ra,0xfffff
    80001fcc:	b5e080e7          	jalr	-1186(ra) # 80000b26 <release>
    release(&l_r_c);
    80001fd0:	00010517          	auipc	a0,0x10
    80001fd4:	91850513          	addi	a0,a0,-1768 # 800118e8 <l_r_c>
    80001fd8:	fffff097          	auipc	ra,0xfffff
    80001fdc:	b4e080e7          	jalr	-1202(ra) # 80000b26 <release>
    return 0;	
    80001fe0:	4501                	li	a0,0
}
    80001fe2:	70a2                	ld	ra,40(sp)
    80001fe4:	7402                	ld	s0,32(sp)
    80001fe6:	64e2                	ld	s1,24(sp)
    80001fe8:	6942                	ld	s2,16(sp)
    80001fea:	69a2                	ld	s3,8(sp)
    80001fec:	6145                	addi	sp,sp,48
    80001fee:	8082                	ret
	   return -1;
    80001ff0:	557d                	li	a0,-1
}
    80001ff2:	8082                	ret

0000000080001ff4 <sys_settickets>:
{ 
    80001ff4:	7179                	addi	sp,sp,-48
    80001ff6:	f406                	sd	ra,40(sp)
    80001ff8:	f022                	sd	s0,32(sp)
    80001ffa:	ec26                	sd	s1,24(sp)
    80001ffc:	1800                	addi	s0,sp,48
   struct proc *p = myproc(); 
    80001ffe:	00000097          	auipc	ra,0x0
    80002002:	a0a080e7          	jalr	-1526(ra) # 80001a08 <myproc>
    80002006:	84aa                	mv	s1,a0
   if(argint(0, &ticket) < 0)
    80002008:	fdc40593          	addi	a1,s0,-36
    8000200c:	4501                	li	a0,0
    8000200e:	00001097          	auipc	ra,0x1
    80002012:	fac080e7          	jalr	-84(ra) # 80002fba <argint>
    80002016:	87aa                	mv	a5,a0
     return -1;
    80002018:	557d                	li	a0,-1
   if(argint(0, &ticket) < 0)
    8000201a:	0007c963          	bltz	a5,8000202c <sys_settickets+0x38>
   return settickets(ticket,p);
    8000201e:	85a6                	mv	a1,s1
    80002020:	fdc42503          	lw	a0,-36(s0)
    80002024:	00000097          	auipc	ra,0x0
    80002028:	f6a080e7          	jalr	-150(ra) # 80001f8e <settickets>
}
    8000202c:	70a2                	ld	ra,40(sp)
    8000202e:	7402                	ld	s0,32(sp)
    80002030:	64e2                	ld	s1,24(sp)
    80002032:	6145                	addi	sp,sp,48
    80002034:	8082                	ret

0000000080002036 <getpinfo>:
{
    80002036:	b8010113          	addi	sp,sp,-1152
    8000203a:	46113c23          	sd	ra,1144(sp)
    8000203e:	46813823          	sd	s0,1136(sp)
    80002042:	46913423          	sd	s1,1128(sp)
    80002046:	47213023          	sd	s2,1120(sp)
    8000204a:	45313c23          	sd	s3,1112(sp)
    8000204e:	45413823          	sd	s4,1104(sp)
    80002052:	45513423          	sd	s5,1096(sp)
    80002056:	45613023          	sd	s6,1088(sp)
    8000205a:	43713c23          	sd	s7,1080(sp)
    8000205e:	43813823          	sd	s8,1072(sp)
    80002062:	43913423          	sd	s9,1064(sp)
    80002066:	43a13023          	sd	s10,1056(sp)
    8000206a:	41b13c23          	sd	s11,1048(sp)
    8000206e:	48010413          	addi	s0,sp,1152
    80002072:	b8a43423          	sd	a0,-1144(s0)
    printf("getpinfo1\n");
    80002076:	00005517          	auipc	a0,0x5
    8000207a:	38a50513          	addi	a0,a0,906 # 80007400 <userret+0x370>
    8000207e:	ffffe097          	auipc	ra,0xffffe
    80002082:	51a080e7          	jalr	1306(ra) # 80000598 <printf>
    acquire(&l_r_c); //for access the process table
    80002086:	00010517          	auipc	a0,0x10
    8000208a:	86250513          	addi	a0,a0,-1950 # 800118e8 <l_r_c>
    8000208e:	fffff097          	auipc	ra,0xfffff
    80002092:	a44080e7          	jalr	-1468(ra) # 80000ad2 <acquire>
    printf("getpinfo2\n");
    80002096:	00005517          	auipc	a0,0x5
    8000209a:	37a50513          	addi	a0,a0,890 # 80007410 <userret+0x380>
    8000209e:	ffffe097          	auipc	ra,0xffffe
    800020a2:	4fa080e7          	jalr	1274(ra) # 80000598 <printf>
    for(p = proc; p < &proc[NPROC]; p++) {
    800020a6:	00010497          	auipc	s1,0x10
    800020aa:	dca48493          	addi	s1,s1,-566 # 80011e70 <proc+0x158>
    800020ae:	b9040913          	addi	s2,s0,-1136
    800020b2:	00016b97          	auipc	s7,0x16
    800020b6:	9beb8b93          	addi	s7,s7,-1602 # 80017a70 <bcache+0x140>
       printf("getpinfo3\n");
    800020ba:	00005b17          	auipc	s6,0x5
    800020be:	366b0b13          	addi	s6,s6,870 # 80007420 <userret+0x390>
       printf("getpinfo4\n");
    800020c2:	00005a97          	auipc	s5,0x5
    800020c6:	36ea8a93          	addi	s5,s5,878 # 80007430 <userret+0x3a0>
         printf("getpinfo7\n");
    800020ca:	00005d97          	auipc	s11,0x5
    800020ce:	396d8d93          	addi	s11,s11,918 # 80007460 <userret+0x3d0>
	       info.inuse[i] = 1;
    800020d2:	4d05                	li	s10,1
         printf("getpinfo5\n");
    800020d4:	00005c97          	auipc	s9,0x5
    800020d8:	36cc8c93          	addi	s9,s9,876 # 80007440 <userret+0x3b0>
         printf("getpinfo6\n");
    800020dc:	00005c17          	auipc	s8,0x5
    800020e0:	374c0c13          	addi	s8,s8,884 # 80007450 <userret+0x3c0>
	       info.tickets[i] = -1;
    800020e4:	5a7d                	li	s4,-1
    800020e6:	a0a9                	j	80002130 <getpinfo+0xfa>
         printf("getpinfo5\n");
    800020e8:	8566                	mv	a0,s9
    800020ea:	ffffe097          	auipc	ra,0xffffe
    800020ee:	4ae080e7          	jalr	1198(ra) # 80000598 <printf>
         info.inuse[i] = 0;
    800020f2:	00092023          	sw	zero,0(s2)
         printf("getpinfo6\n");
    800020f6:	8562                	mv	a0,s8
    800020f8:	ffffe097          	auipc	ra,0xffffe
    800020fc:	4a0080e7          	jalr	1184(ra) # 80000598 <printf>
	       info.tickets[i] = -1;
    80002100:	11492023          	sw	s4,256(s2)
	       info.pid[i] = -1;
    80002104:	21492023          	sw	s4,512(s2)
	       info.ticks[i] = 0;
    80002108:	30092023          	sw	zero,768(s2)
       release(&p->lock);
    8000210c:	854e                	mv	a0,s3
    8000210e:	fffff097          	auipc	ra,0xfffff
    80002112:	a18080e7          	jalr	-1512(ra) # 80000b26 <release>
       printf("getpinfo9\n");
    80002116:	00005517          	auipc	a0,0x5
    8000211a:	36a50513          	addi	a0,a0,874 # 80007480 <userret+0x3f0>
    8000211e:	ffffe097          	auipc	ra,0xffffe
    80002122:	47a080e7          	jalr	1146(ra) # 80000598 <printf>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002126:	17048493          	addi	s1,s1,368
    8000212a:	0911                	addi	s2,s2,4
    8000212c:	07748263          	beq	s1,s7,80002190 <getpinfo+0x15a>
       printf("getpinfo3\n");
    80002130:	855a                	mv	a0,s6
    80002132:	ffffe097          	auipc	ra,0xffffe
    80002136:	466080e7          	jalr	1126(ra) # 80000598 <printf>
       acquire(&p->lock);
    8000213a:	89a6                	mv	s3,s1
    8000213c:	8526                	mv	a0,s1
    8000213e:	fffff097          	auipc	ra,0xfffff
    80002142:	994080e7          	jalr	-1644(ra) # 80000ad2 <acquire>
       printf("getpinfo4\n");
    80002146:	8556                	mv	a0,s5
    80002148:	ffffe097          	auipc	ra,0xffffe
    8000214c:	450080e7          	jalr	1104(ra) # 80000598 <printf>
       if(p->state == UNUSED || p->state == ZOMBIE) {
    80002150:	ea84a783          	lw	a5,-344(s1)
    80002154:	9bed                	andi	a5,a5,-5
    80002156:	dbc9                	beqz	a5,800020e8 <getpinfo+0xb2>
         printf("getpinfo7\n");
    80002158:	856e                	mv	a0,s11
    8000215a:	ffffe097          	auipc	ra,0xffffe
    8000215e:	43e080e7          	jalr	1086(ra) # 80000598 <printf>
	       info.inuse[i] = 1;
    80002162:	01a92023          	sw	s10,0(s2)
         printf("getpinfo8\n");
    80002166:	00005517          	auipc	a0,0x5
    8000216a:	30a50513          	addi	a0,a0,778 # 80007470 <userret+0x3e0>
    8000216e:	ffffe097          	auipc	ra,0xffffe
    80002172:	42a080e7          	jalr	1066(ra) # 80000598 <printf>
         info.tickets[i] = p->ticket;
    80002176:	ecc4a783          	lw	a5,-308(s1)
    8000217a:	10f92023          	sw	a5,256(s2)
         info.pid[i] = p->pid;
    8000217e:	ec84a783          	lw	a5,-312(s1)
    80002182:	20f92023          	sw	a5,512(s2)
         info.ticks[i] = p->total_tick;
    80002186:	ed44a783          	lw	a5,-300(s1)
    8000218a:	30f92023          	sw	a5,768(s2)
    8000218e:	bfbd                	j	8000210c <getpinfo+0xd6>
    release(&l_r_c); //for access the process table
    80002190:	0000f517          	auipc	a0,0xf
    80002194:	75850513          	addi	a0,a0,1880 # 800118e8 <l_r_c>
    80002198:	fffff097          	auipc	ra,0xfffff
    8000219c:	98e080e7          	jalr	-1650(ra) # 80000b26 <release>
    p = myproc();
    800021a0:	00000097          	auipc	ra,0x0
    800021a4:	868080e7          	jalr	-1944(ra) # 80001a08 <myproc>
    if(copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0)
    800021a8:	40000693          	li	a3,1024
    800021ac:	b9040613          	addi	a2,s0,-1136
    800021b0:	b8843583          	ld	a1,-1144(s0)
    800021b4:	6128                	ld	a0,64(a0)
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	540080e7          	jalr	1344(ra) # 800016f6 <copyout>
}
    800021be:	41f5551b          	sraiw	a0,a0,0x1f
    800021c2:	47813083          	ld	ra,1144(sp)
    800021c6:	47013403          	ld	s0,1136(sp)
    800021ca:	46813483          	ld	s1,1128(sp)
    800021ce:	46013903          	ld	s2,1120(sp)
    800021d2:	45813983          	ld	s3,1112(sp)
    800021d6:	45013a03          	ld	s4,1104(sp)
    800021da:	44813a83          	ld	s5,1096(sp)
    800021de:	44013b03          	ld	s6,1088(sp)
    800021e2:	43813b83          	ld	s7,1080(sp)
    800021e6:	43013c03          	ld	s8,1072(sp)
    800021ea:	42813c83          	ld	s9,1064(sp)
    800021ee:	42013d03          	ld	s10,1056(sp)
    800021f2:	41813d83          	ld	s11,1048(sp)
    800021f6:	48010113          	addi	sp,sp,1152
    800021fa:	8082                	ret

00000000800021fc <sys_getpinfo>:
{	
    800021fc:	1101                	addi	sp,sp,-32
    800021fe:	ec06                	sd	ra,24(sp)
    80002200:	e822                	sd	s0,16(sp)
    80002202:	1000                	addi	s0,sp,32
    if(argaddr(0, &p) < 0)
    80002204:	fe840593          	addi	a1,s0,-24
    80002208:	4501                	li	a0,0
    8000220a:	00001097          	auipc	ra,0x1
    8000220e:	dd2080e7          	jalr	-558(ra) # 80002fdc <argaddr>
    80002212:	87aa                	mv	a5,a0
	     return -1;
    80002214:	557d                	li	a0,-1
    if(argaddr(0, &p) < 0)
    80002216:	0007c863          	bltz	a5,80002226 <sys_getpinfo+0x2a>
    return getpinfo(p);
    8000221a:	fe843503          	ld	a0,-24(s0)
    8000221e:	00000097          	auipc	ra,0x0
    80002222:	e18080e7          	jalr	-488(ra) # 80002036 <getpinfo>
}
    80002226:	60e2                	ld	ra,24(sp)
    80002228:	6442                	ld	s0,16(sp)
    8000222a:	6105                	addi	sp,sp,32
    8000222c:	8082                	ret

000000008000222e <scheduler>:
{
    8000222e:	d9010113          	addi	sp,sp,-624
    80002232:	26113423          	sd	ra,616(sp)
    80002236:	26813023          	sd	s0,608(sp)
    8000223a:	24913c23          	sd	s1,600(sp)
    8000223e:	25213823          	sd	s2,592(sp)
    80002242:	25313423          	sd	s3,584(sp)
    80002246:	25413023          	sd	s4,576(sp)
    8000224a:	23513c23          	sd	s5,568(sp)
    8000224e:	23613823          	sd	s6,560(sp)
    80002252:	23713423          	sd	s7,552(sp)
    80002256:	23813023          	sd	s8,544(sp)
    8000225a:	21913c23          	sd	s9,536(sp)
    8000225e:	21a13823          	sd	s10,528(sp)
    80002262:	21b13423          	sd	s11,520(sp)
    80002266:	1c80                	addi	s0,sp,624
    80002268:	8792                	mv	a5,tp
  int id = r_tp();
    8000226a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000226c:	00779d13          	slli	s10,a5,0x7
    80002270:	0000f717          	auipc	a4,0xf
    80002274:	69070713          	addi	a4,a4,1680 # 80011900 <pid_lock>
    80002278:	976a                	add	a4,a4,s10
    8000227a:	00073c23          	sd	zero,24(a4)
        swtch(&c->scheduler, &WP->context);
    8000227e:	0000f717          	auipc	a4,0xf
    80002282:	6a270713          	addi	a4,a4,1698 # 80011920 <cpus+0x8>
    80002286:	9d3a                	add	s10,s10,a4
    acquire(&l_r_c); //for access the process table
    80002288:	0000fc17          	auipc	s8,0xf
    8000228c:	660c0c13          	addi	s8,s8,1632 # 800118e8 <l_r_c>
    int i = 0;
    80002290:	4b81                	li	s7,0
      if(p->state == RUNNABLE){
    80002292:	4a89                	li	s5,2
    for(p = proc; p < &proc[NPROC]; p++){
    80002294:	00015a17          	auipc	s4,0x15
    80002298:	684a0a13          	addi	s4,s4,1668 # 80017918 <tickslock>
        WP->start_tick = ticks; //p2b the starting tick of this scheduling round
    8000229c:	00024d97          	auipc	s11,0x24
    800022a0:	d84d8d93          	addi	s11,s11,-636 # 80026020 <ticks>
        c->proc = WP;
    800022a4:	079e                	slli	a5,a5,0x7
    800022a6:	0000fc97          	auipc	s9,0xf
    800022aa:	65ac8c93          	addi	s9,s9,1626 # 80011900 <pid_lock>
    800022ae:	9cbe                	add	s9,s9,a5
    800022b0:	a0c1                	j	80002370 <scheduler+0x142>
      release(&p->lock);
    800022b2:	854a                	mv	a0,s2
    800022b4:	fffff097          	auipc	ra,0xfffff
    800022b8:	872080e7          	jalr	-1934(ra) # 80000b26 <release>
    for(p = proc; p < &proc[NPROC]; p++){
    800022bc:	17048493          	addi	s1,s1,368
    800022c0:	03448863          	beq	s1,s4,800022f0 <scheduler+0xc2>
      acquire(&p->lock);
    800022c4:	15848913          	addi	s2,s1,344
    800022c8:	854a                	mv	a0,s2
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	808080e7          	jalr	-2040(ra) # 80000ad2 <acquire>
      if(p->state == RUNNABLE){
    800022d2:	409c                	lw	a5,0(s1)
    800022d4:	fd579fe3          	bne	a5,s5,800022b2 <scheduler+0x84>
        runnable[i] = p;
    800022d8:	00399793          	slli	a5,s3,0x3
    800022dc:	f9040713          	addi	a4,s0,-112
    800022e0:	97ba                	add	a5,a5,a4
    800022e2:	e097b023          	sd	s1,-512(a5)
        ticket_sum += p->ticket;
    800022e6:	50dc                	lw	a5,36(s1)
    800022e8:	01678b3b          	addw	s6,a5,s6
        i++;
    800022ec:	2985                	addiw	s3,s3,1
    800022ee:	b7d1                	j	800022b2 <scheduler+0x84>
    uint32 win_num = rand_interval(1,ticket_sum); //the lottery winning number between [0, ticket_sum]
    800022f0:	85da                	mv	a1,s6
    800022f2:	4505                	li	a0,1
    800022f4:	00004097          	auipc	ra,0x4
    800022f8:	3cc080e7          	jalr	972(ra) # 800066c0 <rand_interval>
    800022fc:	0005059b          	sext.w	a1,a0
    for(int j = 0; j < i; j++){
    80002300:	07305363          	blez	s3,80002366 <scheduler+0x138>
      counter += runnable[j]->ticket;
    80002304:	d9043483          	ld	s1,-624(s0)
    80002308:	50d4                	lw	a3,36(s1)
      if(counter >= win_num){
    8000230a:	02b6f263          	bgeu	a3,a1,8000232e <scheduler+0x100>
    8000230e:	d9840713          	addi	a4,s0,-616
    80002312:	fff9879b          	addiw	a5,s3,-1
    80002316:	1782                	slli	a5,a5,0x20
    80002318:	9381                	srli	a5,a5,0x20
    8000231a:	078e                	slli	a5,a5,0x3
    8000231c:	97ba                	add	a5,a5,a4
    for(int j = 0; j < i; j++){
    8000231e:	04f70463          	beq	a4,a5,80002366 <scheduler+0x138>
      counter += runnable[j]->ticket;
    80002322:	6304                	ld	s1,0(a4)
    80002324:	50d0                	lw	a2,36(s1)
    80002326:	9eb1                	addw	a3,a3,a2
      if(counter >= win_num){
    80002328:	0721                	addi	a4,a4,8
    8000232a:	feb6eae3          	bltu	a3,a1,8000231e <scheduler+0xf0>
        acquire(&WP->lock);
    8000232e:	15848913          	addi	s2,s1,344
    80002332:	854a                	mv	a0,s2
    80002334:	ffffe097          	auipc	ra,0xffffe
    80002338:	79e080e7          	jalr	1950(ra) # 80000ad2 <acquire>
        WP->state = RUNNING;
    8000233c:	478d                	li	a5,3
    8000233e:	c09c                	sw	a5,0(s1)
        WP->start_tick = ticks; //p2b the starting tick of this scheduling round
    80002340:	000da783          	lw	a5,0(s11)
    80002344:	d49c                	sw	a5,40(s1)
        c->proc = WP;
    80002346:	009cbc23          	sd	s1,24(s9)
        swtch(&c->scheduler, &WP->context);
    8000234a:	05048593          	addi	a1,s1,80
    8000234e:	856a                	mv	a0,s10
    80002350:	00000097          	auipc	ra,0x0
    80002354:	782080e7          	jalr	1922(ra) # 80002ad2 <swtch>
        c->proc = 0;
    80002358:	000cbc23          	sd	zero,24(s9)
        release(&WP->lock);
    8000235c:	854a                	mv	a0,s2
    8000235e:	ffffe097          	auipc	ra,0xffffe
    80002362:	7c8080e7          	jalr	1992(ra) # 80000b26 <release>
    release(&l_r_c);
    80002366:	8562                	mv	a0,s8
    80002368:	ffffe097          	auipc	ra,0xffffe
    8000236c:	7be080e7          	jalr	1982(ra) # 80000b26 <release>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80002370:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80002374:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80002378:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000237c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002380:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002384:	10079073          	csrw	sstatus,a5
    acquire(&l_r_c); //for access the process table
    80002388:	8562                	mv	a0,s8
    8000238a:	ffffe097          	auipc	ra,0xffffe
    8000238e:	748080e7          	jalr	1864(ra) # 80000ad2 <acquire>
    int i = 0;
    80002392:	89de                	mv	s3,s7
    int ticket_sum = 0; 
    80002394:	8b5e                	mv	s6,s7
    for(p = proc; p < &proc[NPROC]; p++){
    80002396:	00010497          	auipc	s1,0x10
    8000239a:	98248493          	addi	s1,s1,-1662 # 80011d18 <proc>
    8000239e:	b71d                	j	800022c4 <scheduler+0x96>

00000000800023a0 <sched>:
{
    800023a0:	7179                	addi	sp,sp,-48
    800023a2:	f406                	sd	ra,40(sp)
    800023a4:	f022                	sd	s0,32(sp)
    800023a6:	ec26                	sd	s1,24(sp)
    800023a8:	e84a                	sd	s2,16(sp)
    800023aa:	e44e                	sd	s3,8(sp)
    800023ac:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800023ae:	fffff097          	auipc	ra,0xfffff
    800023b2:	65a080e7          	jalr	1626(ra) # 80001a08 <myproc>
    800023b6:	84aa                	mv	s1,a0
  if(!holding(&l_r_c))
    800023b8:	0000f517          	auipc	a0,0xf
    800023bc:	53050513          	addi	a0,a0,1328 # 800118e8 <l_r_c>
    800023c0:	ffffe097          	auipc	ra,0xffffe
    800023c4:	6d2080e7          	jalr	1746(ra) # 80000a92 <holding>
    800023c8:	c151                	beqz	a0,8000244c <sched+0xac>
  if(!holding(&p->lock))
    800023ca:	15848513          	addi	a0,s1,344
    800023ce:	ffffe097          	auipc	ra,0xffffe
    800023d2:	6c4080e7          	jalr	1732(ra) # 80000a92 <holding>
    800023d6:	c159                	beqz	a0,8000245c <sched+0xbc>
  asm volatile("mv %0, tp" : "=r" (x) );
    800023d8:	8792                	mv	a5,tp
  if(mycpu()->noff != 2) //originally is 1
    800023da:	2781                	sext.w	a5,a5
    800023dc:	079e                	slli	a5,a5,0x7
    800023de:	0000f717          	auipc	a4,0xf
    800023e2:	52270713          	addi	a4,a4,1314 # 80011900 <pid_lock>
    800023e6:	97ba                	add	a5,a5,a4
    800023e8:	0907a703          	lw	a4,144(a5)
    800023ec:	4789                	li	a5,2
    800023ee:	06f71f63          	bne	a4,a5,8000246c <sched+0xcc>
  if(p->state == RUNNING)
    800023f2:	4098                	lw	a4,0(s1)
    800023f4:	478d                	li	a5,3
    800023f6:	08f70363          	beq	a4,a5,8000247c <sched+0xdc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800023fa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800023fe:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002400:	e7d1                	bnez	a5,8000248c <sched+0xec>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002402:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002404:	0000f917          	auipc	s2,0xf
    80002408:	4fc90913          	addi	s2,s2,1276 # 80011900 <pid_lock>
    8000240c:	2781                	sext.w	a5,a5
    8000240e:	079e                	slli	a5,a5,0x7
    80002410:	97ca                	add	a5,a5,s2
    80002412:	0947a983          	lw	s3,148(a5)
    80002416:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->scheduler);
    80002418:	2781                	sext.w	a5,a5
    8000241a:	079e                	slli	a5,a5,0x7
    8000241c:	0000f597          	auipc	a1,0xf
    80002420:	50458593          	addi	a1,a1,1284 # 80011920 <cpus+0x8>
    80002424:	95be                	add	a1,a1,a5
    80002426:	05048513          	addi	a0,s1,80
    8000242a:	00000097          	auipc	ra,0x0
    8000242e:	6a8080e7          	jalr	1704(ra) # 80002ad2 <swtch>
    80002432:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002434:	2781                	sext.w	a5,a5
    80002436:	079e                	slli	a5,a5,0x7
    80002438:	97ca                	add	a5,a5,s2
    8000243a:	0937aa23          	sw	s3,148(a5)
}
    8000243e:	70a2                	ld	ra,40(sp)
    80002440:	7402                	ld	s0,32(sp)
    80002442:	64e2                	ld	s1,24(sp)
    80002444:	6942                	ld	s2,16(sp)
    80002446:	69a2                	ld	s3,8(sp)
    80002448:	6145                	addi	sp,sp,48
    8000244a:	8082                	ret
    panic("sched l_r_c");
    8000244c:	00005517          	auipc	a0,0x5
    80002450:	04450513          	addi	a0,a0,68 # 80007490 <userret+0x400>
    80002454:	ffffe097          	auipc	ra,0xffffe
    80002458:	0fa080e7          	jalr	250(ra) # 8000054e <panic>
    panic("sched p->lock");
    8000245c:	00005517          	auipc	a0,0x5
    80002460:	04450513          	addi	a0,a0,68 # 800074a0 <userret+0x410>
    80002464:	ffffe097          	auipc	ra,0xffffe
    80002468:	0ea080e7          	jalr	234(ra) # 8000054e <panic>
    panic("sched locks");
    8000246c:	00005517          	auipc	a0,0x5
    80002470:	04450513          	addi	a0,a0,68 # 800074b0 <userret+0x420>
    80002474:	ffffe097          	auipc	ra,0xffffe
    80002478:	0da080e7          	jalr	218(ra) # 8000054e <panic>
    panic("sched running");
    8000247c:	00005517          	auipc	a0,0x5
    80002480:	04450513          	addi	a0,a0,68 # 800074c0 <userret+0x430>
    80002484:	ffffe097          	auipc	ra,0xffffe
    80002488:	0ca080e7          	jalr	202(ra) # 8000054e <panic>
    panic("sched interruptible");
    8000248c:	00005517          	auipc	a0,0x5
    80002490:	04450513          	addi	a0,a0,68 # 800074d0 <userret+0x440>
    80002494:	ffffe097          	auipc	ra,0xffffe
    80002498:	0ba080e7          	jalr	186(ra) # 8000054e <panic>

000000008000249c <exit>:
{
    8000249c:	7139                	addi	sp,sp,-64
    8000249e:	fc06                	sd	ra,56(sp)
    800024a0:	f822                	sd	s0,48(sp)
    800024a2:	f426                	sd	s1,40(sp)
    800024a4:	f04a                	sd	s2,32(sp)
    800024a6:	ec4e                	sd	s3,24(sp)
    800024a8:	e852                	sd	s4,16(sp)
    800024aa:	e456                	sd	s5,8(sp)
    800024ac:	0080                	addi	s0,sp,64
    800024ae:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    800024b0:	fffff097          	auipc	ra,0xfffff
    800024b4:	558080e7          	jalr	1368(ra) # 80001a08 <myproc>
    800024b8:	89aa                	mv	s3,a0
  if(p == initproc)
    800024ba:	00024797          	auipc	a5,0x24
    800024be:	b5e7b783          	ld	a5,-1186(a5) # 80026018 <initproc>
    800024c2:	0c050493          	addi	s1,a0,192
    800024c6:	14050913          	addi	s2,a0,320
    800024ca:	02a79363          	bne	a5,a0,800024f0 <exit+0x54>
    panic("init exiting");
    800024ce:	00005517          	auipc	a0,0x5
    800024d2:	01a50513          	addi	a0,a0,26 # 800074e8 <userret+0x458>
    800024d6:	ffffe097          	auipc	ra,0xffffe
    800024da:	078080e7          	jalr	120(ra) # 8000054e <panic>
      fileclose(f);
    800024de:	00002097          	auipc	ra,0x2
    800024e2:	4d8080e7          	jalr	1240(ra) # 800049b6 <fileclose>
      p->ofile[fd] = 0;
    800024e6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800024ea:	04a1                	addi	s1,s1,8
    800024ec:	01248563          	beq	s1,s2,800024f6 <exit+0x5a>
    if(p->ofile[fd]){
    800024f0:	6088                	ld	a0,0(s1)
    800024f2:	f575                	bnez	a0,800024de <exit+0x42>
    800024f4:	bfdd                	j	800024ea <exit+0x4e>
  begin_op();
    800024f6:	00002097          	auipc	ra,0x2
    800024fa:	fee080e7          	jalr	-18(ra) # 800044e4 <begin_op>
  iput(p->cwd);
    800024fe:	1409b503          	ld	a0,320(s3)
    80002502:	00001097          	auipc	ra,0x1
    80002506:	75a080e7          	jalr	1882(ra) # 80003c5c <iput>
  end_op();
    8000250a:	00002097          	auipc	ra,0x2
    8000250e:	05a080e7          	jalr	90(ra) # 80004564 <end_op>
  p->cwd = 0;
    80002512:	1409b023          	sd	zero,320(s3)
  acquire(&l_r_c);
    80002516:	0000f517          	auipc	a0,0xf
    8000251a:	3d250513          	addi	a0,a0,978 # 800118e8 <l_r_c>
    8000251e:	ffffe097          	auipc	ra,0xffffe
    80002522:	5b4080e7          	jalr	1460(ra) # 80000ad2 <acquire>
  acquire(&initproc->lock);
    80002526:	00024497          	auipc	s1,0x24
    8000252a:	af248493          	addi	s1,s1,-1294 # 80026018 <initproc>
    8000252e:	6088                	ld	a0,0(s1)
    80002530:	15850513          	addi	a0,a0,344
    80002534:	ffffe097          	auipc	ra,0xffffe
    80002538:	59e080e7          	jalr	1438(ra) # 80000ad2 <acquire>
  wakeup1(initproc);
    8000253c:	6088                	ld	a0,0(s1)
    8000253e:	fffff097          	auipc	ra,0xfffff
    80002542:	384080e7          	jalr	900(ra) # 800018c2 <wakeup1>
  release(&initproc->lock);
    80002546:	6088                	ld	a0,0(s1)
    80002548:	15850513          	addi	a0,a0,344
    8000254c:	ffffe097          	auipc	ra,0xffffe
    80002550:	5da080e7          	jalr	1498(ra) # 80000b26 <release>
  acquire(&p->lock);
    80002554:	15898493          	addi	s1,s3,344
    80002558:	8526                	mv	a0,s1
    8000255a:	ffffe097          	auipc	ra,0xffffe
    8000255e:	578080e7          	jalr	1400(ra) # 80000ad2 <acquire>
  struct proc *original_parent = p->parent;
    80002562:	0089ba03          	ld	s4,8(s3)
  release(&p->lock);
    80002566:	8526                	mv	a0,s1
    80002568:	ffffe097          	auipc	ra,0xffffe
    8000256c:	5be080e7          	jalr	1470(ra) # 80000b26 <release>
  acquire(&original_parent->lock);
    80002570:	158a0913          	addi	s2,s4,344
    80002574:	854a                	mv	a0,s2
    80002576:	ffffe097          	auipc	ra,0xffffe
    8000257a:	55c080e7          	jalr	1372(ra) # 80000ad2 <acquire>
  acquire(&p->lock);
    8000257e:	8526                	mv	a0,s1
    80002580:	ffffe097          	auipc	ra,0xffffe
    80002584:	552080e7          	jalr	1362(ra) # 80000ad2 <acquire>
  reparent(p);
    80002588:	854e                	mv	a0,s3
    8000258a:	00000097          	auipc	ra,0x0
    8000258e:	996080e7          	jalr	-1642(ra) # 80001f20 <reparent>
  wakeup1(original_parent);
    80002592:	8552                	mv	a0,s4
    80002594:	fffff097          	auipc	ra,0xfffff
    80002598:	32e080e7          	jalr	814(ra) # 800018c2 <wakeup1>
  p->xstate = status;
    8000259c:	0159ae23          	sw	s5,28(s3)
  p->state = ZOMBIE;
    800025a0:	4791                	li	a5,4
    800025a2:	00f9a023          	sw	a5,0(s3)
  release(&original_parent->lock);
    800025a6:	854a                	mv	a0,s2
    800025a8:	ffffe097          	auipc	ra,0xffffe
    800025ac:	57e080e7          	jalr	1406(ra) # 80000b26 <release>
  sched();
    800025b0:	00000097          	auipc	ra,0x0
    800025b4:	df0080e7          	jalr	-528(ra) # 800023a0 <sched>
  panic("zombie exit");
    800025b8:	00005517          	auipc	a0,0x5
    800025bc:	f4050513          	addi	a0,a0,-192 # 800074f8 <userret+0x468>
    800025c0:	ffffe097          	auipc	ra,0xffffe
    800025c4:	f8e080e7          	jalr	-114(ra) # 8000054e <panic>

00000000800025c8 <yield>:
{
    800025c8:	1101                	addi	sp,sp,-32
    800025ca:	ec06                	sd	ra,24(sp)
    800025cc:	e822                	sd	s0,16(sp)
    800025ce:	e426                	sd	s1,8(sp)
    800025d0:	e04a                	sd	s2,0(sp)
    800025d2:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800025d4:	fffff097          	auipc	ra,0xfffff
    800025d8:	434080e7          	jalr	1076(ra) # 80001a08 <myproc>
    800025dc:	84aa                	mv	s1,a0
  acquire(&l_r_c); //for access the process table
    800025de:	0000f517          	auipc	a0,0xf
    800025e2:	30a50513          	addi	a0,a0,778 # 800118e8 <l_r_c>
    800025e6:	ffffe097          	auipc	ra,0xffffe
    800025ea:	4ec080e7          	jalr	1260(ra) # 80000ad2 <acquire>
  acquire(&p->lock);
    800025ee:	15848913          	addi	s2,s1,344
    800025f2:	854a                	mv	a0,s2
    800025f4:	ffffe097          	auipc	ra,0xffffe
    800025f8:	4de080e7          	jalr	1246(ra) # 80000ad2 <acquire>
  p->state = RUNNABLE;
    800025fc:	4789                	li	a5,2
    800025fe:	c09c                	sw	a5,0(s1)
  p->total_tick+=(ticks - p->start_tick); //p2b, calculate the total tick passed since first start up
    80002600:	54dc                	lw	a5,44(s1)
    80002602:	00024717          	auipc	a4,0x24
    80002606:	a1e72703          	lw	a4,-1506(a4) # 80026020 <ticks>
    8000260a:	9fb9                	addw	a5,a5,a4
    8000260c:	5498                	lw	a4,40(s1)
    8000260e:	9f99                	subw	a5,a5,a4
    80002610:	d4dc                	sw	a5,44(s1)
  sched();
    80002612:	00000097          	auipc	ra,0x0
    80002616:	d8e080e7          	jalr	-626(ra) # 800023a0 <sched>
  release(&p->lock);
    8000261a:	854a                	mv	a0,s2
    8000261c:	ffffe097          	auipc	ra,0xffffe
    80002620:	50a080e7          	jalr	1290(ra) # 80000b26 <release>
  release(&l_r_c); //for access the process table
    80002624:	0000f517          	auipc	a0,0xf
    80002628:	2c450513          	addi	a0,a0,708 # 800118e8 <l_r_c>
    8000262c:	ffffe097          	auipc	ra,0xffffe
    80002630:	4fa080e7          	jalr	1274(ra) # 80000b26 <release>
}
    80002634:	60e2                	ld	ra,24(sp)
    80002636:	6442                	ld	s0,16(sp)
    80002638:	64a2                	ld	s1,8(sp)
    8000263a:	6902                	ld	s2,0(sp)
    8000263c:	6105                	addi	sp,sp,32
    8000263e:	8082                	ret

0000000080002640 <sleep>:
{
    80002640:	7179                	addi	sp,sp,-48
    80002642:	f406                	sd	ra,40(sp)
    80002644:	f022                	sd	s0,32(sp)
    80002646:	ec26                	sd	s1,24(sp)
    80002648:	e84a                	sd	s2,16(sp)
    8000264a:	e44e                	sd	s3,8(sp)
    8000264c:	e052                	sd	s4,0(sp)
    8000264e:	1800                	addi	s0,sp,48
    80002650:	89aa                	mv	s3,a0
    80002652:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002654:	fffff097          	auipc	ra,0xfffff
    80002658:	3b4080e7          	jalr	948(ra) # 80001a08 <myproc>
    8000265c:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    8000265e:	15850a13          	addi	s4,a0,344
    80002662:	072a0863          	beq	s4,s2,800026d2 <sleep+0x92>
    acquire(&l_r_c);
    80002666:	0000f517          	auipc	a0,0xf
    8000266a:	28250513          	addi	a0,a0,642 # 800118e8 <l_r_c>
    8000266e:	ffffe097          	auipc	ra,0xffffe
    80002672:	464080e7          	jalr	1124(ra) # 80000ad2 <acquire>
    acquire(&p->lock);  //DOC: sleeplock1
    80002676:	8552                	mv	a0,s4
    80002678:	ffffe097          	auipc	ra,0xffffe
    8000267c:	45a080e7          	jalr	1114(ra) # 80000ad2 <acquire>
    release(lk);
    80002680:	854a                	mv	a0,s2
    80002682:	ffffe097          	auipc	ra,0xffffe
    80002686:	4a4080e7          	jalr	1188(ra) # 80000b26 <release>
  p->chan = chan;
    8000268a:	0134b823          	sd	s3,16(s1)
  p->state = SLEEPING;
    8000268e:	4785                	li	a5,1
    80002690:	c09c                	sw	a5,0(s1)
  sched();
    80002692:	00000097          	auipc	ra,0x0
    80002696:	d0e080e7          	jalr	-754(ra) # 800023a0 <sched>
  p->chan = 0;
    8000269a:	0004b823          	sd	zero,16(s1)
    release(&p->lock);
    8000269e:	8552                	mv	a0,s4
    800026a0:	ffffe097          	auipc	ra,0xffffe
    800026a4:	486080e7          	jalr	1158(ra) # 80000b26 <release>
    release(&l_r_c);
    800026a8:	0000f517          	auipc	a0,0xf
    800026ac:	24050513          	addi	a0,a0,576 # 800118e8 <l_r_c>
    800026b0:	ffffe097          	auipc	ra,0xffffe
    800026b4:	476080e7          	jalr	1142(ra) # 80000b26 <release>
    acquire(lk);
    800026b8:	854a                	mv	a0,s2
    800026ba:	ffffe097          	auipc	ra,0xffffe
    800026be:	418080e7          	jalr	1048(ra) # 80000ad2 <acquire>
}
    800026c2:	70a2                	ld	ra,40(sp)
    800026c4:	7402                	ld	s0,32(sp)
    800026c6:	64e2                	ld	s1,24(sp)
    800026c8:	6942                	ld	s2,16(sp)
    800026ca:	69a2                	ld	s3,8(sp)
    800026cc:	6a02                	ld	s4,0(sp)
    800026ce:	6145                	addi	sp,sp,48
    800026d0:	8082                	ret
  p->chan = chan;
    800026d2:	01353823          	sd	s3,16(a0)
  p->state = SLEEPING;
    800026d6:	4785                	li	a5,1
    800026d8:	c11c                	sw	a5,0(a0)
  sched();
    800026da:	00000097          	auipc	ra,0x0
    800026de:	cc6080e7          	jalr	-826(ra) # 800023a0 <sched>
  p->chan = 0;
    800026e2:	0004b823          	sd	zero,16(s1)
  if(lk != &p->lock){
    800026e6:	bff1                	j	800026c2 <sleep+0x82>

00000000800026e8 <wait>:
{
    800026e8:	711d                	addi	sp,sp,-96
    800026ea:	ec86                	sd	ra,88(sp)
    800026ec:	e8a2                	sd	s0,80(sp)
    800026ee:	e4a6                	sd	s1,72(sp)
    800026f0:	e0ca                	sd	s2,64(sp)
    800026f2:	fc4e                	sd	s3,56(sp)
    800026f4:	f852                	sd	s4,48(sp)
    800026f6:	f456                	sd	s5,40(sp)
    800026f8:	f05a                	sd	s6,32(sp)
    800026fa:	ec5e                	sd	s7,24(sp)
    800026fc:	e862                	sd	s8,16(sp)
    800026fe:	e466                	sd	s9,8(sp)
    80002700:	1080                	addi	s0,sp,96
    80002702:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002704:	fffff097          	auipc	ra,0xfffff
    80002708:	304080e7          	jalr	772(ra) # 80001a08 <myproc>
    8000270c:	892a                	mv	s2,a0
  acquire(&l_r_c);
    8000270e:	0000f517          	auipc	a0,0xf
    80002712:	1da50513          	addi	a0,a0,474 # 800118e8 <l_r_c>
    80002716:	ffffe097          	auipc	ra,0xffffe
    8000271a:	3bc080e7          	jalr	956(ra) # 80000ad2 <acquire>
  acquire(&p->lock);
    8000271e:	15890c13          	addi	s8,s2,344
    80002722:	8562                	mv	a0,s8
    80002724:	ffffe097          	auipc	ra,0xffffe
    80002728:	3ae080e7          	jalr	942(ra) # 80000ad2 <acquire>
    havekids = 0;
    8000272c:	4c81                	li	s9,0
        if(np->state == ZOMBIE){
    8000272e:	4a91                	li	s5,4
    for(np = proc; np < &proc[NPROC]; np++){
    80002730:	00015997          	auipc	s3,0x15
    80002734:	1e898993          	addi	s3,s3,488 # 80017918 <tickslock>
        havekids = 1;
    80002738:	4b05                	li	s6,1
    havekids = 0;
    8000273a:	8766                	mv	a4,s9
    for(np = proc; np < &proc[NPROC]; np++){
    8000273c:	0000f497          	auipc	s1,0xf
    80002740:	5dc48493          	addi	s1,s1,1500 # 80011d18 <proc>
    80002744:	a049                	j	800027c6 <wait+0xde>
          pid = np->pid;
    80002746:	0204a983          	lw	s3,32(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000274a:	000b8e63          	beqz	s7,80002766 <wait+0x7e>
    8000274e:	4691                	li	a3,4
    80002750:	01c48613          	addi	a2,s1,28
    80002754:	85de                	mv	a1,s7
    80002756:	04093503          	ld	a0,64(s2)
    8000275a:	fffff097          	auipc	ra,0xfffff
    8000275e:	f9c080e7          	jalr	-100(ra) # 800016f6 <copyout>
    80002762:	02054a63          	bltz	a0,80002796 <wait+0xae>
          freeproc(np);
    80002766:	8526                	mv	a0,s1
    80002768:	fffff097          	auipc	ra,0xfffff
    8000276c:	514080e7          	jalr	1300(ra) # 80001c7c <freeproc>
          release(&np->lock);
    80002770:	8552                	mv	a0,s4
    80002772:	ffffe097          	auipc	ra,0xffffe
    80002776:	3b4080e7          	jalr	948(ra) # 80000b26 <release>
          release(&p->lock);
    8000277a:	8562                	mv	a0,s8
    8000277c:	ffffe097          	auipc	ra,0xffffe
    80002780:	3aa080e7          	jalr	938(ra) # 80000b26 <release>
          release(&l_r_c);
    80002784:	0000f517          	auipc	a0,0xf
    80002788:	16450513          	addi	a0,a0,356 # 800118e8 <l_r_c>
    8000278c:	ffffe097          	auipc	ra,0xffffe
    80002790:	39a080e7          	jalr	922(ra) # 80000b26 <release>
          return pid;
    80002794:	a8bd                	j	80002812 <wait+0x12a>
            release(&np->lock);
    80002796:	8552                	mv	a0,s4
    80002798:	ffffe097          	auipc	ra,0xffffe
    8000279c:	38e080e7          	jalr	910(ra) # 80000b26 <release>
            release(&p->lock);
    800027a0:	8562                	mv	a0,s8
    800027a2:	ffffe097          	auipc	ra,0xffffe
    800027a6:	384080e7          	jalr	900(ra) # 80000b26 <release>
            release(&l_r_c);
    800027aa:	0000f517          	auipc	a0,0xf
    800027ae:	13e50513          	addi	a0,a0,318 # 800118e8 <l_r_c>
    800027b2:	ffffe097          	auipc	ra,0xffffe
    800027b6:	374080e7          	jalr	884(ra) # 80000b26 <release>
            return -1;
    800027ba:	59fd                	li	s3,-1
    800027bc:	a899                	j	80002812 <wait+0x12a>
    for(np = proc; np < &proc[NPROC]; np++){
    800027be:	17048493          	addi	s1,s1,368
    800027c2:	03348663          	beq	s1,s3,800027ee <wait+0x106>
      if(np->parent == p){
    800027c6:	649c                	ld	a5,8(s1)
    800027c8:	ff279be3          	bne	a5,s2,800027be <wait+0xd6>
        acquire(&np->lock);
    800027cc:	15848a13          	addi	s4,s1,344
    800027d0:	8552                	mv	a0,s4
    800027d2:	ffffe097          	auipc	ra,0xffffe
    800027d6:	300080e7          	jalr	768(ra) # 80000ad2 <acquire>
        if(np->state == ZOMBIE){
    800027da:	409c                	lw	a5,0(s1)
    800027dc:	f75785e3          	beq	a5,s5,80002746 <wait+0x5e>
        release(&np->lock);
    800027e0:	8552                	mv	a0,s4
    800027e2:	ffffe097          	auipc	ra,0xffffe
    800027e6:	344080e7          	jalr	836(ra) # 80000b26 <release>
        havekids = 1;
    800027ea:	875a                	mv	a4,s6
    800027ec:	bfc9                	j	800027be <wait+0xd6>
    if(!havekids || p->killed){
    800027ee:	c701                	beqz	a4,800027f6 <wait+0x10e>
    800027f0:	01892783          	lw	a5,24(s2)
    800027f4:	cf8d                	beqz	a5,8000282e <wait+0x146>
      release(&p->lock);
    800027f6:	8562                	mv	a0,s8
    800027f8:	ffffe097          	auipc	ra,0xffffe
    800027fc:	32e080e7          	jalr	814(ra) # 80000b26 <release>
      release(&l_r_c);
    80002800:	0000f517          	auipc	a0,0xf
    80002804:	0e850513          	addi	a0,a0,232 # 800118e8 <l_r_c>
    80002808:	ffffe097          	auipc	ra,0xffffe
    8000280c:	31e080e7          	jalr	798(ra) # 80000b26 <release>
      return -1;
    80002810:	59fd                	li	s3,-1
}
    80002812:	854e                	mv	a0,s3
    80002814:	60e6                	ld	ra,88(sp)
    80002816:	6446                	ld	s0,80(sp)
    80002818:	64a6                	ld	s1,72(sp)
    8000281a:	6906                	ld	s2,64(sp)
    8000281c:	79e2                	ld	s3,56(sp)
    8000281e:	7a42                	ld	s4,48(sp)
    80002820:	7aa2                	ld	s5,40(sp)
    80002822:	7b02                	ld	s6,32(sp)
    80002824:	6be2                	ld	s7,24(sp)
    80002826:	6c42                	ld	s8,16(sp)
    80002828:	6ca2                	ld	s9,8(sp)
    8000282a:	6125                	addi	sp,sp,96
    8000282c:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    8000282e:	85e2                	mv	a1,s8
    80002830:	854a                	mv	a0,s2
    80002832:	00000097          	auipc	ra,0x0
    80002836:	e0e080e7          	jalr	-498(ra) # 80002640 <sleep>
    havekids = 0;
    8000283a:	b701                	j	8000273a <wait+0x52>

000000008000283c <wakeup>:
{
    8000283c:	7139                	addi	sp,sp,-64
    8000283e:	fc06                	sd	ra,56(sp)
    80002840:	f822                	sd	s0,48(sp)
    80002842:	f426                	sd	s1,40(sp)
    80002844:	f04a                	sd	s2,32(sp)
    80002846:	ec4e                	sd	s3,24(sp)
    80002848:	e852                	sd	s4,16(sp)
    8000284a:	e456                	sd	s5,8(sp)
    8000284c:	e05a                	sd	s6,0(sp)
    8000284e:	0080                	addi	s0,sp,64
    80002850:	8aaa                	mv	s5,a0
  acquire(&l_r_c); //for access the process table
    80002852:	0000f517          	auipc	a0,0xf
    80002856:	09650513          	addi	a0,a0,150 # 800118e8 <l_r_c>
    8000285a:	ffffe097          	auipc	ra,0xffffe
    8000285e:	278080e7          	jalr	632(ra) # 80000ad2 <acquire>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002862:	0000f497          	auipc	s1,0xf
    80002866:	60e48493          	addi	s1,s1,1550 # 80011e70 <proc+0x158>
    8000286a:	00015a17          	auipc	s4,0x15
    8000286e:	206a0a13          	addi	s4,s4,518 # 80017a70 <bcache+0x140>
    if(p->state == SLEEPING && p->chan == chan) {
    80002872:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002874:	4b09                	li	s6,2
    80002876:	a821                	j	8000288e <wakeup+0x52>
    80002878:	eb64a423          	sw	s6,-344(s1)
    release(&p->lock);
    8000287c:	854a                	mv	a0,s2
    8000287e:	ffffe097          	auipc	ra,0xffffe
    80002882:	2a8080e7          	jalr	680(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002886:	17048493          	addi	s1,s1,368
    8000288a:	03448163          	beq	s1,s4,800028ac <wakeup+0x70>
    acquire(&p->lock);
    8000288e:	8926                	mv	s2,s1
    80002890:	8526                	mv	a0,s1
    80002892:	ffffe097          	auipc	ra,0xffffe
    80002896:	240080e7          	jalr	576(ra) # 80000ad2 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    8000289a:	ea84a783          	lw	a5,-344(s1)
    8000289e:	fd379fe3          	bne	a5,s3,8000287c <wakeup+0x40>
    800028a2:	eb84b783          	ld	a5,-328(s1)
    800028a6:	fd579be3          	bne	a5,s5,8000287c <wakeup+0x40>
    800028aa:	b7f9                	j	80002878 <wakeup+0x3c>
  release(&l_r_c); //for access the process table
    800028ac:	0000f517          	auipc	a0,0xf
    800028b0:	03c50513          	addi	a0,a0,60 # 800118e8 <l_r_c>
    800028b4:	ffffe097          	auipc	ra,0xffffe
    800028b8:	272080e7          	jalr	626(ra) # 80000b26 <release>
}
    800028bc:	70e2                	ld	ra,56(sp)
    800028be:	7442                	ld	s0,48(sp)
    800028c0:	74a2                	ld	s1,40(sp)
    800028c2:	7902                	ld	s2,32(sp)
    800028c4:	69e2                	ld	s3,24(sp)
    800028c6:	6a42                	ld	s4,16(sp)
    800028c8:	6aa2                	ld	s5,8(sp)
    800028ca:	6b02                	ld	s6,0(sp)
    800028cc:	6121                	addi	sp,sp,64
    800028ce:	8082                	ret

00000000800028d0 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800028d0:	7179                	addi	sp,sp,-48
    800028d2:	f406                	sd	ra,40(sp)
    800028d4:	f022                	sd	s0,32(sp)
    800028d6:	ec26                	sd	s1,24(sp)
    800028d8:	e84a                	sd	s2,16(sp)
    800028da:	e44e                	sd	s3,8(sp)
    800028dc:	e052                	sd	s4,0(sp)
    800028de:	1800                	addi	s0,sp,48
    800028e0:	89aa                	mv	s3,a0
  struct proc *p;
  acquire(&l_r_c); //for access the process table
    800028e2:	0000f517          	auipc	a0,0xf
    800028e6:	00650513          	addi	a0,a0,6 # 800118e8 <l_r_c>
    800028ea:	ffffe097          	auipc	ra,0xffffe
    800028ee:	1e8080e7          	jalr	488(ra) # 80000ad2 <acquire>
  for(p = proc; p < &proc[NPROC]; p++){
    800028f2:	0000f497          	auipc	s1,0xf
    800028f6:	42648493          	addi	s1,s1,1062 # 80011d18 <proc>
    800028fa:	00015a17          	auipc	s4,0x15
    800028fe:	01ea0a13          	addi	s4,s4,30 # 80017918 <tickslock>
    acquire(&p->lock);
    80002902:	15848913          	addi	s2,s1,344
    80002906:	854a                	mv	a0,s2
    80002908:	ffffe097          	auipc	ra,0xffffe
    8000290c:	1ca080e7          	jalr	458(ra) # 80000ad2 <acquire>
    if(p->pid == pid){
    80002910:	509c                	lw	a5,32(s1)
    80002912:	03378563          	beq	a5,s3,8000293c <kill+0x6c>
      }
      release(&p->lock);
      acquire(&l_r_c); //for access the process table
      return 0;
    }
    release(&p->lock);
    80002916:	854a                	mv	a0,s2
    80002918:	ffffe097          	auipc	ra,0xffffe
    8000291c:	20e080e7          	jalr	526(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002920:	17048493          	addi	s1,s1,368
    80002924:	fd449fe3          	bne	s1,s4,80002902 <kill+0x32>
  }
  release(&l_r_c); //for access the process table
    80002928:	0000f517          	auipc	a0,0xf
    8000292c:	fc050513          	addi	a0,a0,-64 # 800118e8 <l_r_c>
    80002930:	ffffe097          	auipc	ra,0xffffe
    80002934:	1f6080e7          	jalr	502(ra) # 80000b26 <release>
  return -1;
    80002938:	557d                	li	a0,-1
    8000293a:	a025                	j	80002962 <kill+0x92>
      p->killed = 1;
    8000293c:	4785                	li	a5,1
    8000293e:	cc9c                	sw	a5,24(s1)
      if(p->state == SLEEPING){
    80002940:	4098                	lw	a4,0(s1)
    80002942:	02f70863          	beq	a4,a5,80002972 <kill+0xa2>
      release(&p->lock);
    80002946:	854a                	mv	a0,s2
    80002948:	ffffe097          	auipc	ra,0xffffe
    8000294c:	1de080e7          	jalr	478(ra) # 80000b26 <release>
      acquire(&l_r_c); //for access the process table
    80002950:	0000f517          	auipc	a0,0xf
    80002954:	f9850513          	addi	a0,a0,-104 # 800118e8 <l_r_c>
    80002958:	ffffe097          	auipc	ra,0xffffe
    8000295c:	17a080e7          	jalr	378(ra) # 80000ad2 <acquire>
      return 0;
    80002960:	4501                	li	a0,0
}
    80002962:	70a2                	ld	ra,40(sp)
    80002964:	7402                	ld	s0,32(sp)
    80002966:	64e2                	ld	s1,24(sp)
    80002968:	6942                	ld	s2,16(sp)
    8000296a:	69a2                	ld	s3,8(sp)
    8000296c:	6a02                	ld	s4,0(sp)
    8000296e:	6145                	addi	sp,sp,48
    80002970:	8082                	ret
        p->state = RUNNABLE;
    80002972:	4789                	li	a5,2
    80002974:	c09c                	sw	a5,0(s1)
    80002976:	bfc1                	j	80002946 <kill+0x76>

0000000080002978 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002978:	7179                	addi	sp,sp,-48
    8000297a:	f406                	sd	ra,40(sp)
    8000297c:	f022                	sd	s0,32(sp)
    8000297e:	ec26                	sd	s1,24(sp)
    80002980:	e84a                	sd	s2,16(sp)
    80002982:	e44e                	sd	s3,8(sp)
    80002984:	e052                	sd	s4,0(sp)
    80002986:	1800                	addi	s0,sp,48
    80002988:	84aa                	mv	s1,a0
    8000298a:	892e                	mv	s2,a1
    8000298c:	89b2                	mv	s3,a2
    8000298e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002990:	fffff097          	auipc	ra,0xfffff
    80002994:	078080e7          	jalr	120(ra) # 80001a08 <myproc>
  if(user_dst){
    80002998:	c08d                	beqz	s1,800029ba <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000299a:	86d2                	mv	a3,s4
    8000299c:	864e                	mv	a2,s3
    8000299e:	85ca                	mv	a1,s2
    800029a0:	6128                	ld	a0,64(a0)
    800029a2:	fffff097          	auipc	ra,0xfffff
    800029a6:	d54080e7          	jalr	-684(ra) # 800016f6 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800029aa:	70a2                	ld	ra,40(sp)
    800029ac:	7402                	ld	s0,32(sp)
    800029ae:	64e2                	ld	s1,24(sp)
    800029b0:	6942                	ld	s2,16(sp)
    800029b2:	69a2                	ld	s3,8(sp)
    800029b4:	6a02                	ld	s4,0(sp)
    800029b6:	6145                	addi	sp,sp,48
    800029b8:	8082                	ret
    memmove((char *)dst, src, len);
    800029ba:	000a061b          	sext.w	a2,s4
    800029be:	85ce                	mv	a1,s3
    800029c0:	854a                	mv	a0,s2
    800029c2:	ffffe097          	auipc	ra,0xffffe
    800029c6:	20c080e7          	jalr	524(ra) # 80000bce <memmove>
    return 0;
    800029ca:	8526                	mv	a0,s1
    800029cc:	bff9                	j	800029aa <either_copyout+0x32>

00000000800029ce <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800029ce:	7179                	addi	sp,sp,-48
    800029d0:	f406                	sd	ra,40(sp)
    800029d2:	f022                	sd	s0,32(sp)
    800029d4:	ec26                	sd	s1,24(sp)
    800029d6:	e84a                	sd	s2,16(sp)
    800029d8:	e44e                	sd	s3,8(sp)
    800029da:	e052                	sd	s4,0(sp)
    800029dc:	1800                	addi	s0,sp,48
    800029de:	892a                	mv	s2,a0
    800029e0:	84ae                	mv	s1,a1
    800029e2:	89b2                	mv	s3,a2
    800029e4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800029e6:	fffff097          	auipc	ra,0xfffff
    800029ea:	022080e7          	jalr	34(ra) # 80001a08 <myproc>
  if(user_src){
    800029ee:	c08d                	beqz	s1,80002a10 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800029f0:	86d2                	mv	a3,s4
    800029f2:	864e                	mv	a2,s3
    800029f4:	85ca                	mv	a1,s2
    800029f6:	6128                	ld	a0,64(a0)
    800029f8:	fffff097          	auipc	ra,0xfffff
    800029fc:	d8a080e7          	jalr	-630(ra) # 80001782 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002a00:	70a2                	ld	ra,40(sp)
    80002a02:	7402                	ld	s0,32(sp)
    80002a04:	64e2                	ld	s1,24(sp)
    80002a06:	6942                	ld	s2,16(sp)
    80002a08:	69a2                	ld	s3,8(sp)
    80002a0a:	6a02                	ld	s4,0(sp)
    80002a0c:	6145                	addi	sp,sp,48
    80002a0e:	8082                	ret
    memmove(dst, (char*)src, len);
    80002a10:	000a061b          	sext.w	a2,s4
    80002a14:	85ce                	mv	a1,s3
    80002a16:	854a                	mv	a0,s2
    80002a18:	ffffe097          	auipc	ra,0xffffe
    80002a1c:	1b6080e7          	jalr	438(ra) # 80000bce <memmove>
    return 0;
    80002a20:	8526                	mv	a0,s1
    80002a22:	bff9                	j	80002a00 <either_copyin+0x32>

0000000080002a24 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002a24:	715d                	addi	sp,sp,-80
    80002a26:	e486                	sd	ra,72(sp)
    80002a28:	e0a2                	sd	s0,64(sp)
    80002a2a:	fc26                	sd	s1,56(sp)
    80002a2c:	f84a                	sd	s2,48(sp)
    80002a2e:	f44e                	sd	s3,40(sp)
    80002a30:	f052                	sd	s4,32(sp)
    80002a32:	ec56                	sd	s5,24(sp)
    80002a34:	e85a                	sd	s6,16(sp)
    80002a36:	e45e                	sd	s7,8(sp)
    80002a38:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002a3a:	00005517          	auipc	a0,0x5
    80002a3e:	bee50513          	addi	a0,a0,-1042 # 80007628 <userret+0x598>
    80002a42:	ffffe097          	auipc	ra,0xffffe
    80002a46:	b56080e7          	jalr	-1194(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002a4a:	0000f497          	auipc	s1,0xf
    80002a4e:	41648493          	addi	s1,s1,1046 # 80011e60 <proc+0x148>
    80002a52:	00015917          	auipc	s2,0x15
    80002a56:	00e90913          	addi	s2,s2,14 # 80017a60 <bcache+0x130>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a5a:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    80002a5c:	00005997          	auipc	s3,0x5
    80002a60:	aac98993          	addi	s3,s3,-1364 # 80007508 <userret+0x478>
    printf("%d %s %s", p->pid, state, p->name);
    80002a64:	00005a97          	auipc	s5,0x5
    80002a68:	aaca8a93          	addi	s5,s5,-1364 # 80007510 <userret+0x480>
    printf("\n");
    80002a6c:	00005a17          	auipc	s4,0x5
    80002a70:	bbca0a13          	addi	s4,s4,-1092 # 80007628 <userret+0x598>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a74:	00005b97          	auipc	s7,0x5
    80002a78:	f54b8b93          	addi	s7,s7,-172 # 800079c8 <states.1748>
    80002a7c:	a00d                	j	80002a9e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002a7e:	ed86a583          	lw	a1,-296(a3)
    80002a82:	8556                	mv	a0,s5
    80002a84:	ffffe097          	auipc	ra,0xffffe
    80002a88:	b14080e7          	jalr	-1260(ra) # 80000598 <printf>
    printf("\n");
    80002a8c:	8552                	mv	a0,s4
    80002a8e:	ffffe097          	auipc	ra,0xffffe
    80002a92:	b0a080e7          	jalr	-1270(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002a96:	17048493          	addi	s1,s1,368
    80002a9a:	03248163          	beq	s1,s2,80002abc <procdump+0x98>
    if(p->state == UNUSED)
    80002a9e:	86a6                	mv	a3,s1
    80002aa0:	eb84a783          	lw	a5,-328(s1)
    80002aa4:	dbed                	beqz	a5,80002a96 <procdump+0x72>
      state = "???";
    80002aa6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002aa8:	fcfb6be3          	bltu	s6,a5,80002a7e <procdump+0x5a>
    80002aac:	1782                	slli	a5,a5,0x20
    80002aae:	9381                	srli	a5,a5,0x20
    80002ab0:	078e                	slli	a5,a5,0x3
    80002ab2:	97de                	add	a5,a5,s7
    80002ab4:	6390                	ld	a2,0(a5)
    80002ab6:	f661                	bnez	a2,80002a7e <procdump+0x5a>
      state = "???";
    80002ab8:	864e                	mv	a2,s3
    80002aba:	b7d1                	j	80002a7e <procdump+0x5a>
  }
}
    80002abc:	60a6                	ld	ra,72(sp)
    80002abe:	6406                	ld	s0,64(sp)
    80002ac0:	74e2                	ld	s1,56(sp)
    80002ac2:	7942                	ld	s2,48(sp)
    80002ac4:	79a2                	ld	s3,40(sp)
    80002ac6:	7a02                	ld	s4,32(sp)
    80002ac8:	6ae2                	ld	s5,24(sp)
    80002aca:	6b42                	ld	s6,16(sp)
    80002acc:	6ba2                	ld	s7,8(sp)
    80002ace:	6161                	addi	sp,sp,80
    80002ad0:	8082                	ret

0000000080002ad2 <swtch>:
    80002ad2:	00153023          	sd	ra,0(a0)
    80002ad6:	00253423          	sd	sp,8(a0)
    80002ada:	e900                	sd	s0,16(a0)
    80002adc:	ed04                	sd	s1,24(a0)
    80002ade:	03253023          	sd	s2,32(a0)
    80002ae2:	03353423          	sd	s3,40(a0)
    80002ae6:	03453823          	sd	s4,48(a0)
    80002aea:	03553c23          	sd	s5,56(a0)
    80002aee:	05653023          	sd	s6,64(a0)
    80002af2:	05753423          	sd	s7,72(a0)
    80002af6:	05853823          	sd	s8,80(a0)
    80002afa:	05953c23          	sd	s9,88(a0)
    80002afe:	07a53023          	sd	s10,96(a0)
    80002b02:	07b53423          	sd	s11,104(a0)
    80002b06:	0005b083          	ld	ra,0(a1)
    80002b0a:	0085b103          	ld	sp,8(a1)
    80002b0e:	6980                	ld	s0,16(a1)
    80002b10:	6d84                	ld	s1,24(a1)
    80002b12:	0205b903          	ld	s2,32(a1)
    80002b16:	0285b983          	ld	s3,40(a1)
    80002b1a:	0305ba03          	ld	s4,48(a1)
    80002b1e:	0385ba83          	ld	s5,56(a1)
    80002b22:	0405bb03          	ld	s6,64(a1)
    80002b26:	0485bb83          	ld	s7,72(a1)
    80002b2a:	0505bc03          	ld	s8,80(a1)
    80002b2e:	0585bc83          	ld	s9,88(a1)
    80002b32:	0605bd03          	ld	s10,96(a1)
    80002b36:	0685bd83          	ld	s11,104(a1)
    80002b3a:	8082                	ret

0000000080002b3c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002b3c:	1141                	addi	sp,sp,-16
    80002b3e:	e406                	sd	ra,8(sp)
    80002b40:	e022                	sd	s0,0(sp)
    80002b42:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002b44:	00005597          	auipc	a1,0x5
    80002b48:	a0458593          	addi	a1,a1,-1532 # 80007548 <userret+0x4b8>
    80002b4c:	00015517          	auipc	a0,0x15
    80002b50:	dcc50513          	addi	a0,a0,-564 # 80017918 <tickslock>
    80002b54:	ffffe097          	auipc	ra,0xffffe
    80002b58:	e6c080e7          	jalr	-404(ra) # 800009c0 <initlock>
}
    80002b5c:	60a2                	ld	ra,8(sp)
    80002b5e:	6402                	ld	s0,0(sp)
    80002b60:	0141                	addi	sp,sp,16
    80002b62:	8082                	ret

0000000080002b64 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002b64:	1141                	addi	sp,sp,-16
    80002b66:	e422                	sd	s0,8(sp)
    80002b68:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b6a:	00003797          	auipc	a5,0x3
    80002b6e:	47678793          	addi	a5,a5,1142 # 80005fe0 <kernelvec>
    80002b72:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002b76:	6422                	ld	s0,8(sp)
    80002b78:	0141                	addi	sp,sp,16
    80002b7a:	8082                	ret

0000000080002b7c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002b7c:	1141                	addi	sp,sp,-16
    80002b7e:	e406                	sd	ra,8(sp)
    80002b80:	e022                	sd	s0,0(sp)
    80002b82:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002b84:	fffff097          	auipc	ra,0xfffff
    80002b88:	e84080e7          	jalr	-380(ra) # 80001a08 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b8c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002b90:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b92:	10079073          	csrw	sstatus,a5
  // turn off interrupts, since we're switching
  // now from kerneltrap() to usertrap().
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002b96:	00004617          	auipc	a2,0x4
    80002b9a:	46a60613          	addi	a2,a2,1130 # 80007000 <trampoline>
    80002b9e:	00004697          	auipc	a3,0x4
    80002ba2:	46268693          	addi	a3,a3,1122 # 80007000 <trampoline>
    80002ba6:	8e91                	sub	a3,a3,a2
    80002ba8:	040007b7          	lui	a5,0x4000
    80002bac:	17fd                	addi	a5,a5,-1
    80002bae:	07b2                	slli	a5,a5,0xc
    80002bb0:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bb2:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->tf->kernel_satp = r_satp();         // kernel page table
    80002bb6:	6538                	ld	a4,72(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002bb8:	180026f3          	csrr	a3,satp
    80002bbc:	e314                	sd	a3,0(a4)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002bbe:	6538                	ld	a4,72(a0)
    80002bc0:	7914                	ld	a3,48(a0)
    80002bc2:	6585                	lui	a1,0x1
    80002bc4:	96ae                	add	a3,a3,a1
    80002bc6:	e714                	sd	a3,8(a4)
  p->tf->kernel_trap = (uint64)usertrap;
    80002bc8:	6538                	ld	a4,72(a0)
    80002bca:	00000697          	auipc	a3,0x0
    80002bce:	12268693          	addi	a3,a3,290 # 80002cec <usertrap>
    80002bd2:	eb14                	sd	a3,16(a4)
  p->tf->kernel_hartid = r_tp();         // hartid for cpuid()
    80002bd4:	6538                	ld	a4,72(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002bd6:	8692                	mv	a3,tp
    80002bd8:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bda:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002bde:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002be2:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002be6:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->tf->epc);
    80002bea:	6538                	ld	a4,72(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002bec:	6f18                	ld	a4,24(a4)
    80002bee:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002bf2:	612c                	ld	a1,64(a0)
    80002bf4:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002bf6:	00004717          	auipc	a4,0x4
    80002bfa:	49a70713          	addi	a4,a4,1178 # 80007090 <userret>
    80002bfe:	8f11                	sub	a4,a4,a2
    80002c00:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002c02:	577d                	li	a4,-1
    80002c04:	177e                	slli	a4,a4,0x3f
    80002c06:	8dd9                	or	a1,a1,a4
    80002c08:	02000537          	lui	a0,0x2000
    80002c0c:	157d                	addi	a0,a0,-1
    80002c0e:	0536                	slli	a0,a0,0xd
    80002c10:	9782                	jalr	a5
}
    80002c12:	60a2                	ld	ra,8(sp)
    80002c14:	6402                	ld	s0,0(sp)
    80002c16:	0141                	addi	sp,sp,16
    80002c18:	8082                	ret

0000000080002c1a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002c1a:	1101                	addi	sp,sp,-32
    80002c1c:	ec06                	sd	ra,24(sp)
    80002c1e:	e822                	sd	s0,16(sp)
    80002c20:	e426                	sd	s1,8(sp)
    80002c22:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002c24:	00015497          	auipc	s1,0x15
    80002c28:	cf448493          	addi	s1,s1,-780 # 80017918 <tickslock>
    80002c2c:	8526                	mv	a0,s1
    80002c2e:	ffffe097          	auipc	ra,0xffffe
    80002c32:	ea4080e7          	jalr	-348(ra) # 80000ad2 <acquire>
  ticks++;
    80002c36:	00023517          	auipc	a0,0x23
    80002c3a:	3ea50513          	addi	a0,a0,1002 # 80026020 <ticks>
    80002c3e:	411c                	lw	a5,0(a0)
    80002c40:	2785                	addiw	a5,a5,1
    80002c42:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002c44:	00000097          	auipc	ra,0x0
    80002c48:	bf8080e7          	jalr	-1032(ra) # 8000283c <wakeup>
  release(&tickslock);
    80002c4c:	8526                	mv	a0,s1
    80002c4e:	ffffe097          	auipc	ra,0xffffe
    80002c52:	ed8080e7          	jalr	-296(ra) # 80000b26 <release>
}
    80002c56:	60e2                	ld	ra,24(sp)
    80002c58:	6442                	ld	s0,16(sp)
    80002c5a:	64a2                	ld	s1,8(sp)
    80002c5c:	6105                	addi	sp,sp,32
    80002c5e:	8082                	ret

0000000080002c60 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002c60:	1101                	addi	sp,sp,-32
    80002c62:	ec06                	sd	ra,24(sp)
    80002c64:	e822                	sd	s0,16(sp)
    80002c66:	e426                	sd	s1,8(sp)
    80002c68:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c6a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002c6e:	00074d63          	bltz	a4,80002c88 <devintr+0x28>
      virtio_disk_intr();
    }

    plic_complete(irq);
    return 1;
  } else if(scause == 0x8000000000000001L){
    80002c72:	57fd                	li	a5,-1
    80002c74:	17fe                	slli	a5,a5,0x3f
    80002c76:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002c78:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002c7a:	04f70863          	beq	a4,a5,80002cca <devintr+0x6a>
  }
}
    80002c7e:	60e2                	ld	ra,24(sp)
    80002c80:	6442                	ld	s0,16(sp)
    80002c82:	64a2                	ld	s1,8(sp)
    80002c84:	6105                	addi	sp,sp,32
    80002c86:	8082                	ret
     (scause & 0xff) == 9){
    80002c88:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002c8c:	46a5                	li	a3,9
    80002c8e:	fed792e3          	bne	a5,a3,80002c72 <devintr+0x12>
    int irq = plic_claim();
    80002c92:	00003097          	auipc	ra,0x3
    80002c96:	468080e7          	jalr	1128(ra) # 800060fa <plic_claim>
    80002c9a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002c9c:	47a9                	li	a5,10
    80002c9e:	00f50c63          	beq	a0,a5,80002cb6 <devintr+0x56>
    } else if(irq == VIRTIO0_IRQ){
    80002ca2:	4785                	li	a5,1
    80002ca4:	00f50e63          	beq	a0,a5,80002cc0 <devintr+0x60>
    plic_complete(irq);
    80002ca8:	8526                	mv	a0,s1
    80002caa:	00003097          	auipc	ra,0x3
    80002cae:	474080e7          	jalr	1140(ra) # 8000611e <plic_complete>
    return 1;
    80002cb2:	4505                	li	a0,1
    80002cb4:	b7e9                	j	80002c7e <devintr+0x1e>
      uartintr();
    80002cb6:	ffffe097          	auipc	ra,0xffffe
    80002cba:	b82080e7          	jalr	-1150(ra) # 80000838 <uartintr>
    80002cbe:	b7ed                	j	80002ca8 <devintr+0x48>
      virtio_disk_intr();
    80002cc0:	00004097          	auipc	ra,0x4
    80002cc4:	8ee080e7          	jalr	-1810(ra) # 800065ae <virtio_disk_intr>
    80002cc8:	b7c5                	j	80002ca8 <devintr+0x48>
    if(cpuid() == 0){
    80002cca:	fffff097          	auipc	ra,0xfffff
    80002cce:	d12080e7          	jalr	-750(ra) # 800019dc <cpuid>
    80002cd2:	c901                	beqz	a0,80002ce2 <devintr+0x82>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002cd4:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002cd8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002cda:	14479073          	csrw	sip,a5
    return 2;
    80002cde:	4509                	li	a0,2
    80002ce0:	bf79                	j	80002c7e <devintr+0x1e>
      clockintr();
    80002ce2:	00000097          	auipc	ra,0x0
    80002ce6:	f38080e7          	jalr	-200(ra) # 80002c1a <clockintr>
    80002cea:	b7ed                	j	80002cd4 <devintr+0x74>

0000000080002cec <usertrap>:
{
    80002cec:	1101                	addi	sp,sp,-32
    80002cee:	ec06                	sd	ra,24(sp)
    80002cf0:	e822                	sd	s0,16(sp)
    80002cf2:	e426                	sd	s1,8(sp)
    80002cf4:	e04a                	sd	s2,0(sp)
    80002cf6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cf8:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002cfc:	1007f793          	andi	a5,a5,256
    80002d00:	e7bd                	bnez	a5,80002d6e <usertrap+0x82>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002d02:	00003797          	auipc	a5,0x3
    80002d06:	2de78793          	addi	a5,a5,734 # 80005fe0 <kernelvec>
    80002d0a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002d0e:	fffff097          	auipc	ra,0xfffff
    80002d12:	cfa080e7          	jalr	-774(ra) # 80001a08 <myproc>
    80002d16:	84aa                	mv	s1,a0
  p->tf->epc = r_sepc();
    80002d18:	653c                	ld	a5,72(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d1a:	14102773          	csrr	a4,sepc
    80002d1e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d20:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002d24:	47a1                	li	a5,8
    80002d26:	06f71263          	bne	a4,a5,80002d8a <usertrap+0x9e>
    if(p->killed)
    80002d2a:	4d1c                	lw	a5,24(a0)
    80002d2c:	eba9                	bnez	a5,80002d7e <usertrap+0x92>
    p->tf->epc += 4;
    80002d2e:	64b8                	ld	a4,72(s1)
    80002d30:	6f1c                	ld	a5,24(a4)
    80002d32:	0791                	addi	a5,a5,4
    80002d34:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sie" : "=r" (x) );
    80002d36:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80002d3a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80002d3e:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d42:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002d46:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d4a:	10079073          	csrw	sstatus,a5
    syscall();
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	2e0080e7          	jalr	736(ra) # 8000302e <syscall>
  if(p->killed)
    80002d56:	4c9c                	lw	a5,24(s1)
    80002d58:	ebc1                	bnez	a5,80002de8 <usertrap+0xfc>
  usertrapret();
    80002d5a:	00000097          	auipc	ra,0x0
    80002d5e:	e22080e7          	jalr	-478(ra) # 80002b7c <usertrapret>
}
    80002d62:	60e2                	ld	ra,24(sp)
    80002d64:	6442                	ld	s0,16(sp)
    80002d66:	64a2                	ld	s1,8(sp)
    80002d68:	6902                	ld	s2,0(sp)
    80002d6a:	6105                	addi	sp,sp,32
    80002d6c:	8082                	ret
    panic("usertrap: not from user mode");
    80002d6e:	00004517          	auipc	a0,0x4
    80002d72:	7e250513          	addi	a0,a0,2018 # 80007550 <userret+0x4c0>
    80002d76:	ffffd097          	auipc	ra,0xffffd
    80002d7a:	7d8080e7          	jalr	2008(ra) # 8000054e <panic>
      exit(-1);
    80002d7e:	557d                	li	a0,-1
    80002d80:	fffff097          	auipc	ra,0xfffff
    80002d84:	71c080e7          	jalr	1820(ra) # 8000249c <exit>
    80002d88:	b75d                	j	80002d2e <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002d8a:	00000097          	auipc	ra,0x0
    80002d8e:	ed6080e7          	jalr	-298(ra) # 80002c60 <devintr>
    80002d92:	892a                	mv	s2,a0
    80002d94:	c501                	beqz	a0,80002d9c <usertrap+0xb0>
  if(p->killed)
    80002d96:	4c9c                	lw	a5,24(s1)
    80002d98:	c3a1                	beqz	a5,80002dd8 <usertrap+0xec>
    80002d9a:	a815                	j	80002dce <usertrap+0xe2>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d9c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002da0:	5090                	lw	a2,32(s1)
    80002da2:	00004517          	auipc	a0,0x4
    80002da6:	7ce50513          	addi	a0,a0,1998 # 80007570 <userret+0x4e0>
    80002daa:	ffffd097          	auipc	ra,0xffffd
    80002dae:	7ee080e7          	jalr	2030(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002db2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002db6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002dba:	00004517          	auipc	a0,0x4
    80002dbe:	7e650513          	addi	a0,a0,2022 # 800075a0 <userret+0x510>
    80002dc2:	ffffd097          	auipc	ra,0xffffd
    80002dc6:	7d6080e7          	jalr	2006(ra) # 80000598 <printf>
    p->killed = 1;
    80002dca:	4785                	li	a5,1
    80002dcc:	cc9c                	sw	a5,24(s1)
    exit(-1);
    80002dce:	557d                	li	a0,-1
    80002dd0:	fffff097          	auipc	ra,0xfffff
    80002dd4:	6cc080e7          	jalr	1740(ra) # 8000249c <exit>
  if(which_dev == 2)
    80002dd8:	4789                	li	a5,2
    80002dda:	f8f910e3          	bne	s2,a5,80002d5a <usertrap+0x6e>
    yield();
    80002dde:	fffff097          	auipc	ra,0xfffff
    80002de2:	7ea080e7          	jalr	2026(ra) # 800025c8 <yield>
    80002de6:	bf95                	j	80002d5a <usertrap+0x6e>
  int which_dev = 0;
    80002de8:	4901                	li	s2,0
    80002dea:	b7d5                	j	80002dce <usertrap+0xe2>

0000000080002dec <kerneltrap>:
{
    80002dec:	7179                	addi	sp,sp,-48
    80002dee:	f406                	sd	ra,40(sp)
    80002df0:	f022                	sd	s0,32(sp)
    80002df2:	ec26                	sd	s1,24(sp)
    80002df4:	e84a                	sd	s2,16(sp)
    80002df6:	e44e                	sd	s3,8(sp)
    80002df8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002dfa:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002dfe:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e02:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002e06:	1004f793          	andi	a5,s1,256
    80002e0a:	cb85                	beqz	a5,80002e3a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e0c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002e10:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002e12:	ef85                	bnez	a5,80002e4a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002e14:	00000097          	auipc	ra,0x0
    80002e18:	e4c080e7          	jalr	-436(ra) # 80002c60 <devintr>
    80002e1c:	cd1d                	beqz	a0,80002e5a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002e1e:	4789                	li	a5,2
    80002e20:	06f50a63          	beq	a0,a5,80002e94 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002e24:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e28:	10049073          	csrw	sstatus,s1
}
    80002e2c:	70a2                	ld	ra,40(sp)
    80002e2e:	7402                	ld	s0,32(sp)
    80002e30:	64e2                	ld	s1,24(sp)
    80002e32:	6942                	ld	s2,16(sp)
    80002e34:	69a2                	ld	s3,8(sp)
    80002e36:	6145                	addi	sp,sp,48
    80002e38:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002e3a:	00004517          	auipc	a0,0x4
    80002e3e:	78650513          	addi	a0,a0,1926 # 800075c0 <userret+0x530>
    80002e42:	ffffd097          	auipc	ra,0xffffd
    80002e46:	70c080e7          	jalr	1804(ra) # 8000054e <panic>
    panic("kerneltrap: interrupts enabled");
    80002e4a:	00004517          	auipc	a0,0x4
    80002e4e:	79e50513          	addi	a0,a0,1950 # 800075e8 <userret+0x558>
    80002e52:	ffffd097          	auipc	ra,0xffffd
    80002e56:	6fc080e7          	jalr	1788(ra) # 8000054e <panic>
    printf("scause %p\n", scause);
    80002e5a:	85ce                	mv	a1,s3
    80002e5c:	00004517          	auipc	a0,0x4
    80002e60:	7ac50513          	addi	a0,a0,1964 # 80007608 <userret+0x578>
    80002e64:	ffffd097          	auipc	ra,0xffffd
    80002e68:	734080e7          	jalr	1844(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e6c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002e70:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002e74:	00004517          	auipc	a0,0x4
    80002e78:	7a450513          	addi	a0,a0,1956 # 80007618 <userret+0x588>
    80002e7c:	ffffd097          	auipc	ra,0xffffd
    80002e80:	71c080e7          	jalr	1820(ra) # 80000598 <printf>
    panic("kerneltrap");
    80002e84:	00004517          	auipc	a0,0x4
    80002e88:	7ac50513          	addi	a0,a0,1964 # 80007630 <userret+0x5a0>
    80002e8c:	ffffd097          	auipc	ra,0xffffd
    80002e90:	6c2080e7          	jalr	1730(ra) # 8000054e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002e94:	fffff097          	auipc	ra,0xfffff
    80002e98:	b74080e7          	jalr	-1164(ra) # 80001a08 <myproc>
    80002e9c:	d541                	beqz	a0,80002e24 <kerneltrap+0x38>
    80002e9e:	fffff097          	auipc	ra,0xfffff
    80002ea2:	b6a080e7          	jalr	-1174(ra) # 80001a08 <myproc>
    80002ea6:	4118                	lw	a4,0(a0)
    80002ea8:	478d                	li	a5,3
    80002eaa:	f6f71de3          	bne	a4,a5,80002e24 <kerneltrap+0x38>
    yield();
    80002eae:	fffff097          	auipc	ra,0xfffff
    80002eb2:	71a080e7          	jalr	1818(ra) # 800025c8 <yield>
    80002eb6:	b7bd                	j	80002e24 <kerneltrap+0x38>

0000000080002eb8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002eb8:	1101                	addi	sp,sp,-32
    80002eba:	ec06                	sd	ra,24(sp)
    80002ebc:	e822                	sd	s0,16(sp)
    80002ebe:	e426                	sd	s1,8(sp)
    80002ec0:	1000                	addi	s0,sp,32
    80002ec2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002ec4:	fffff097          	auipc	ra,0xfffff
    80002ec8:	b44080e7          	jalr	-1212(ra) # 80001a08 <myproc>
  switch (n) {
    80002ecc:	4795                	li	a5,5
    80002ece:	0497e163          	bltu	a5,s1,80002f10 <argraw+0x58>
    80002ed2:	048a                	slli	s1,s1,0x2
    80002ed4:	00005717          	auipc	a4,0x5
    80002ed8:	b1c70713          	addi	a4,a4,-1252 # 800079f0 <states.1748+0x28>
    80002edc:	94ba                	add	s1,s1,a4
    80002ede:	409c                	lw	a5,0(s1)
    80002ee0:	97ba                	add	a5,a5,a4
    80002ee2:	8782                	jr	a5
  case 0:
    return p->tf->a0;
    80002ee4:	653c                	ld	a5,72(a0)
    80002ee6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
    80002ee8:	60e2                	ld	ra,24(sp)
    80002eea:	6442                	ld	s0,16(sp)
    80002eec:	64a2                	ld	s1,8(sp)
    80002eee:	6105                	addi	sp,sp,32
    80002ef0:	8082                	ret
    return p->tf->a1;
    80002ef2:	653c                	ld	a5,72(a0)
    80002ef4:	7fa8                	ld	a0,120(a5)
    80002ef6:	bfcd                	j	80002ee8 <argraw+0x30>
    return p->tf->a2;
    80002ef8:	653c                	ld	a5,72(a0)
    80002efa:	63c8                	ld	a0,128(a5)
    80002efc:	b7f5                	j	80002ee8 <argraw+0x30>
    return p->tf->a3;
    80002efe:	653c                	ld	a5,72(a0)
    80002f00:	67c8                	ld	a0,136(a5)
    80002f02:	b7dd                	j	80002ee8 <argraw+0x30>
    return p->tf->a4;
    80002f04:	653c                	ld	a5,72(a0)
    80002f06:	6bc8                	ld	a0,144(a5)
    80002f08:	b7c5                	j	80002ee8 <argraw+0x30>
    return p->tf->a5;
    80002f0a:	653c                	ld	a5,72(a0)
    80002f0c:	6fc8                	ld	a0,152(a5)
    80002f0e:	bfe9                	j	80002ee8 <argraw+0x30>
  panic("argraw");
    80002f10:	00004517          	auipc	a0,0x4
    80002f14:	73050513          	addi	a0,a0,1840 # 80007640 <userret+0x5b0>
    80002f18:	ffffd097          	auipc	ra,0xffffd
    80002f1c:	636080e7          	jalr	1590(ra) # 8000054e <panic>

0000000080002f20 <fetchaddr>:
{
    80002f20:	1101                	addi	sp,sp,-32
    80002f22:	ec06                	sd	ra,24(sp)
    80002f24:	e822                	sd	s0,16(sp)
    80002f26:	e426                	sd	s1,8(sp)
    80002f28:	e04a                	sd	s2,0(sp)
    80002f2a:	1000                	addi	s0,sp,32
    80002f2c:	84aa                	mv	s1,a0
    80002f2e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002f30:	fffff097          	auipc	ra,0xfffff
    80002f34:	ad8080e7          	jalr	-1320(ra) # 80001a08 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002f38:	7d1c                	ld	a5,56(a0)
    80002f3a:	02f4f863          	bgeu	s1,a5,80002f6a <fetchaddr+0x4a>
    80002f3e:	00848713          	addi	a4,s1,8
    80002f42:	02e7e663          	bltu	a5,a4,80002f6e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002f46:	46a1                	li	a3,8
    80002f48:	8626                	mv	a2,s1
    80002f4a:	85ca                	mv	a1,s2
    80002f4c:	6128                	ld	a0,64(a0)
    80002f4e:	fffff097          	auipc	ra,0xfffff
    80002f52:	834080e7          	jalr	-1996(ra) # 80001782 <copyin>
    80002f56:	00a03533          	snez	a0,a0
    80002f5a:	40a00533          	neg	a0,a0
}
    80002f5e:	60e2                	ld	ra,24(sp)
    80002f60:	6442                	ld	s0,16(sp)
    80002f62:	64a2                	ld	s1,8(sp)
    80002f64:	6902                	ld	s2,0(sp)
    80002f66:	6105                	addi	sp,sp,32
    80002f68:	8082                	ret
    return -1;
    80002f6a:	557d                	li	a0,-1
    80002f6c:	bfcd                	j	80002f5e <fetchaddr+0x3e>
    80002f6e:	557d                	li	a0,-1
    80002f70:	b7fd                	j	80002f5e <fetchaddr+0x3e>

0000000080002f72 <fetchstr>:
{
    80002f72:	7179                	addi	sp,sp,-48
    80002f74:	f406                	sd	ra,40(sp)
    80002f76:	f022                	sd	s0,32(sp)
    80002f78:	ec26                	sd	s1,24(sp)
    80002f7a:	e84a                	sd	s2,16(sp)
    80002f7c:	e44e                	sd	s3,8(sp)
    80002f7e:	1800                	addi	s0,sp,48
    80002f80:	892a                	mv	s2,a0
    80002f82:	84ae                	mv	s1,a1
    80002f84:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002f86:	fffff097          	auipc	ra,0xfffff
    80002f8a:	a82080e7          	jalr	-1406(ra) # 80001a08 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002f8e:	86ce                	mv	a3,s3
    80002f90:	864a                	mv	a2,s2
    80002f92:	85a6                	mv	a1,s1
    80002f94:	6128                	ld	a0,64(a0)
    80002f96:	fffff097          	auipc	ra,0xfffff
    80002f9a:	878080e7          	jalr	-1928(ra) # 8000180e <copyinstr>
  if(err < 0)
    80002f9e:	00054763          	bltz	a0,80002fac <fetchstr+0x3a>
  return strlen(buf);
    80002fa2:	8526                	mv	a0,s1
    80002fa4:	ffffe097          	auipc	ra,0xffffe
    80002fa8:	d52080e7          	jalr	-686(ra) # 80000cf6 <strlen>
}
    80002fac:	70a2                	ld	ra,40(sp)
    80002fae:	7402                	ld	s0,32(sp)
    80002fb0:	64e2                	ld	s1,24(sp)
    80002fb2:	6942                	ld	s2,16(sp)
    80002fb4:	69a2                	ld	s3,8(sp)
    80002fb6:	6145                	addi	sp,sp,48
    80002fb8:	8082                	ret

0000000080002fba <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002fba:	1101                	addi	sp,sp,-32
    80002fbc:	ec06                	sd	ra,24(sp)
    80002fbe:	e822                	sd	s0,16(sp)
    80002fc0:	e426                	sd	s1,8(sp)
    80002fc2:	1000                	addi	s0,sp,32
    80002fc4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002fc6:	00000097          	auipc	ra,0x0
    80002fca:	ef2080e7          	jalr	-270(ra) # 80002eb8 <argraw>
    80002fce:	c088                	sw	a0,0(s1)
  return 0;
}
    80002fd0:	4501                	li	a0,0
    80002fd2:	60e2                	ld	ra,24(sp)
    80002fd4:	6442                	ld	s0,16(sp)
    80002fd6:	64a2                	ld	s1,8(sp)
    80002fd8:	6105                	addi	sp,sp,32
    80002fda:	8082                	ret

0000000080002fdc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002fdc:	1101                	addi	sp,sp,-32
    80002fde:	ec06                	sd	ra,24(sp)
    80002fe0:	e822                	sd	s0,16(sp)
    80002fe2:	e426                	sd	s1,8(sp)
    80002fe4:	1000                	addi	s0,sp,32
    80002fe6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002fe8:	00000097          	auipc	ra,0x0
    80002fec:	ed0080e7          	jalr	-304(ra) # 80002eb8 <argraw>
    80002ff0:	e088                	sd	a0,0(s1)
  return 0;
}
    80002ff2:	4501                	li	a0,0
    80002ff4:	60e2                	ld	ra,24(sp)
    80002ff6:	6442                	ld	s0,16(sp)
    80002ff8:	64a2                	ld	s1,8(sp)
    80002ffa:	6105                	addi	sp,sp,32
    80002ffc:	8082                	ret

0000000080002ffe <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002ffe:	1101                	addi	sp,sp,-32
    80003000:	ec06                	sd	ra,24(sp)
    80003002:	e822                	sd	s0,16(sp)
    80003004:	e426                	sd	s1,8(sp)
    80003006:	e04a                	sd	s2,0(sp)
    80003008:	1000                	addi	s0,sp,32
    8000300a:	84ae                	mv	s1,a1
    8000300c:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000300e:	00000097          	auipc	ra,0x0
    80003012:	eaa080e7          	jalr	-342(ra) # 80002eb8 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80003016:	864a                	mv	a2,s2
    80003018:	85a6                	mv	a1,s1
    8000301a:	00000097          	auipc	ra,0x0
    8000301e:	f58080e7          	jalr	-168(ra) # 80002f72 <fetchstr>
}
    80003022:	60e2                	ld	ra,24(sp)
    80003024:	6442                	ld	s0,16(sp)
    80003026:	64a2                	ld	s1,8(sp)
    80003028:	6902                	ld	s2,0(sp)
    8000302a:	6105                	addi	sp,sp,32
    8000302c:	8082                	ret

000000008000302e <syscall>:
//[SYS_tester]	sys_tester, //general purpose tester
};

void
syscall(void)
{
    8000302e:	1101                	addi	sp,sp,-32
    80003030:	ec06                	sd	ra,24(sp)
    80003032:	e822                	sd	s0,16(sp)
    80003034:	e426                	sd	s1,8(sp)
    80003036:	e04a                	sd	s2,0(sp)
    80003038:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000303a:	fffff097          	auipc	ra,0xfffff
    8000303e:	9ce080e7          	jalr	-1586(ra) # 80001a08 <myproc>
    80003042:	84aa                	mv	s1,a0

  num = p->tf->a7;
    80003044:	04853903          	ld	s2,72(a0)
    80003048:	0a893783          	ld	a5,168(s2)
    8000304c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003050:	37fd                	addiw	a5,a5,-1
    80003052:	475d                	li	a4,23
    80003054:	00f76f63          	bltu	a4,a5,80003072 <syscall+0x44>
    80003058:	00369713          	slli	a4,a3,0x3
    8000305c:	00005797          	auipc	a5,0x5
    80003060:	9ac78793          	addi	a5,a5,-1620 # 80007a08 <syscalls>
    80003064:	97ba                	add	a5,a5,a4
    80003066:	639c                	ld	a5,0(a5)
    80003068:	c789                	beqz	a5,80003072 <syscall+0x44>
    p->tf->a0 = syscalls[num]();
    8000306a:	9782                	jalr	a5
    8000306c:	06a93823          	sd	a0,112(s2)
    80003070:	a839                	j	8000308e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003072:	14848613          	addi	a2,s1,328
    80003076:	508c                	lw	a1,32(s1)
    80003078:	00004517          	auipc	a0,0x4
    8000307c:	5d050513          	addi	a0,a0,1488 # 80007648 <userret+0x5b8>
    80003080:	ffffd097          	auipc	ra,0xffffd
    80003084:	518080e7          	jalr	1304(ra) # 80000598 <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
    80003088:	64bc                	ld	a5,72(s1)
    8000308a:	577d                	li	a4,-1
    8000308c:	fbb8                	sd	a4,112(a5)
  }
}
    8000308e:	60e2                	ld	ra,24(sp)
    80003090:	6442                	ld	s0,16(sp)
    80003092:	64a2                	ld	s1,8(sp)
    80003094:	6902                	ld	s2,0(sp)
    80003096:	6105                	addi	sp,sp,32
    80003098:	8082                	ret

000000008000309a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000309a:	1101                	addi	sp,sp,-32
    8000309c:	ec06                	sd	ra,24(sp)
    8000309e:	e822                	sd	s0,16(sp)
    800030a0:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800030a2:	fec40593          	addi	a1,s0,-20
    800030a6:	4501                	li	a0,0
    800030a8:	00000097          	auipc	ra,0x0
    800030ac:	f12080e7          	jalr	-238(ra) # 80002fba <argint>
    return -1;
    800030b0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800030b2:	00054963          	bltz	a0,800030c4 <sys_exit+0x2a>
  exit(n);
    800030b6:	fec42503          	lw	a0,-20(s0)
    800030ba:	fffff097          	auipc	ra,0xfffff
    800030be:	3e2080e7          	jalr	994(ra) # 8000249c <exit>
  return 0;  // not reached
    800030c2:	4781                	li	a5,0
}
    800030c4:	853e                	mv	a0,a5
    800030c6:	60e2                	ld	ra,24(sp)
    800030c8:	6442                	ld	s0,16(sp)
    800030ca:	6105                	addi	sp,sp,32
    800030cc:	8082                	ret

00000000800030ce <sys_getpid>:

uint64
sys_getpid(void)
{
    800030ce:	1141                	addi	sp,sp,-16
    800030d0:	e406                	sd	ra,8(sp)
    800030d2:	e022                	sd	s0,0(sp)
    800030d4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800030d6:	fffff097          	auipc	ra,0xfffff
    800030da:	932080e7          	jalr	-1742(ra) # 80001a08 <myproc>
}
    800030de:	5108                	lw	a0,32(a0)
    800030e0:	60a2                	ld	ra,8(sp)
    800030e2:	6402                	ld	s0,0(sp)
    800030e4:	0141                	addi	sp,sp,16
    800030e6:	8082                	ret

00000000800030e8 <sys_getreadcount>:

uint64
sys_getreadcount(void)
{
    800030e8:	1141                	addi	sp,sp,-16
    800030ea:	e422                	sd	s0,8(sp)
    800030ec:	0800                	addi	s0,sp,16
  return readcounter; //p1b edited
}
    800030ee:	00023517          	auipc	a0,0x23
    800030f2:	f1652503          	lw	a0,-234(a0) # 80026004 <readcounter>
    800030f6:	6422                	ld	s0,8(sp)
    800030f8:	0141                	addi	sp,sp,16
    800030fa:	8082                	ret

00000000800030fc <sys_fork>:

uint64
sys_fork(void)
{
    800030fc:	1141                	addi	sp,sp,-16
    800030fe:	e406                	sd	ra,8(sp)
    80003100:	e022                	sd	s0,0(sp)
    80003102:	0800                	addi	s0,sp,16
  return fork();
    80003104:	fffff097          	auipc	ra,0xfffff
    80003108:	ce4080e7          	jalr	-796(ra) # 80001de8 <fork>
}
    8000310c:	60a2                	ld	ra,8(sp)
    8000310e:	6402                	ld	s0,0(sp)
    80003110:	0141                	addi	sp,sp,16
    80003112:	8082                	ret

0000000080003114 <sys_wait>:

uint64
sys_wait(void)
{
    80003114:	1101                	addi	sp,sp,-32
    80003116:	ec06                	sd	ra,24(sp)
    80003118:	e822                	sd	s0,16(sp)
    8000311a:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000311c:	fe840593          	addi	a1,s0,-24
    80003120:	4501                	li	a0,0
    80003122:	00000097          	auipc	ra,0x0
    80003126:	eba080e7          	jalr	-326(ra) # 80002fdc <argaddr>
    8000312a:	87aa                	mv	a5,a0
    return -1;
    8000312c:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000312e:	0007c863          	bltz	a5,8000313e <sys_wait+0x2a>
  return wait(p);
    80003132:	fe843503          	ld	a0,-24(s0)
    80003136:	fffff097          	auipc	ra,0xfffff
    8000313a:	5b2080e7          	jalr	1458(ra) # 800026e8 <wait>
}
    8000313e:	60e2                	ld	ra,24(sp)
    80003140:	6442                	ld	s0,16(sp)
    80003142:	6105                	addi	sp,sp,32
    80003144:	8082                	ret

0000000080003146 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003146:	7179                	addi	sp,sp,-48
    80003148:	f406                	sd	ra,40(sp)
    8000314a:	f022                	sd	s0,32(sp)
    8000314c:	ec26                	sd	s1,24(sp)
    8000314e:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80003150:	fdc40593          	addi	a1,s0,-36
    80003154:	4501                	li	a0,0
    80003156:	00000097          	auipc	ra,0x0
    8000315a:	e64080e7          	jalr	-412(ra) # 80002fba <argint>
    8000315e:	87aa                	mv	a5,a0
    return -1;
    80003160:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80003162:	0207c063          	bltz	a5,80003182 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80003166:	fffff097          	auipc	ra,0xfffff
    8000316a:	8a2080e7          	jalr	-1886(ra) # 80001a08 <myproc>
    8000316e:	5d04                	lw	s1,56(a0)
  if(growproc(n) < 0)
    80003170:	fdc42503          	lw	a0,-36(s0)
    80003174:	fffff097          	auipc	ra,0xfffff
    80003178:	c00080e7          	jalr	-1024(ra) # 80001d74 <growproc>
    8000317c:	00054863          	bltz	a0,8000318c <sys_sbrk+0x46>
    return -1;
  return addr;
    80003180:	8526                	mv	a0,s1
}
    80003182:	70a2                	ld	ra,40(sp)
    80003184:	7402                	ld	s0,32(sp)
    80003186:	64e2                	ld	s1,24(sp)
    80003188:	6145                	addi	sp,sp,48
    8000318a:	8082                	ret
    return -1;
    8000318c:	557d                	li	a0,-1
    8000318e:	bfd5                	j	80003182 <sys_sbrk+0x3c>

0000000080003190 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003190:	7139                	addi	sp,sp,-64
    80003192:	fc06                	sd	ra,56(sp)
    80003194:	f822                	sd	s0,48(sp)
    80003196:	f426                	sd	s1,40(sp)
    80003198:	f04a                	sd	s2,32(sp)
    8000319a:	ec4e                	sd	s3,24(sp)
    8000319c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000319e:	fcc40593          	addi	a1,s0,-52
    800031a2:	4501                	li	a0,0
    800031a4:	00000097          	auipc	ra,0x0
    800031a8:	e16080e7          	jalr	-490(ra) # 80002fba <argint>
    return -1;
    800031ac:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800031ae:	06054563          	bltz	a0,80003218 <sys_sleep+0x88>
  acquire(&tickslock);
    800031b2:	00014517          	auipc	a0,0x14
    800031b6:	76650513          	addi	a0,a0,1894 # 80017918 <tickslock>
    800031ba:	ffffe097          	auipc	ra,0xffffe
    800031be:	918080e7          	jalr	-1768(ra) # 80000ad2 <acquire>
  ticks0 = ticks;
    800031c2:	00023917          	auipc	s2,0x23
    800031c6:	e5e92903          	lw	s2,-418(s2) # 80026020 <ticks>
  while(ticks - ticks0 < n){
    800031ca:	fcc42783          	lw	a5,-52(s0)
    800031ce:	cf85                	beqz	a5,80003206 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800031d0:	00014997          	auipc	s3,0x14
    800031d4:	74898993          	addi	s3,s3,1864 # 80017918 <tickslock>
    800031d8:	00023497          	auipc	s1,0x23
    800031dc:	e4848493          	addi	s1,s1,-440 # 80026020 <ticks>
    if(myproc()->killed){
    800031e0:	fffff097          	auipc	ra,0xfffff
    800031e4:	828080e7          	jalr	-2008(ra) # 80001a08 <myproc>
    800031e8:	4d1c                	lw	a5,24(a0)
    800031ea:	ef9d                	bnez	a5,80003228 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800031ec:	85ce                	mv	a1,s3
    800031ee:	8526                	mv	a0,s1
    800031f0:	fffff097          	auipc	ra,0xfffff
    800031f4:	450080e7          	jalr	1104(ra) # 80002640 <sleep>
  while(ticks - ticks0 < n){
    800031f8:	409c                	lw	a5,0(s1)
    800031fa:	412787bb          	subw	a5,a5,s2
    800031fe:	fcc42703          	lw	a4,-52(s0)
    80003202:	fce7efe3          	bltu	a5,a4,800031e0 <sys_sleep+0x50>
  }
  release(&tickslock);
    80003206:	00014517          	auipc	a0,0x14
    8000320a:	71250513          	addi	a0,a0,1810 # 80017918 <tickslock>
    8000320e:	ffffe097          	auipc	ra,0xffffe
    80003212:	918080e7          	jalr	-1768(ra) # 80000b26 <release>
  return 0;
    80003216:	4781                	li	a5,0
}
    80003218:	853e                	mv	a0,a5
    8000321a:	70e2                	ld	ra,56(sp)
    8000321c:	7442                	ld	s0,48(sp)
    8000321e:	74a2                	ld	s1,40(sp)
    80003220:	7902                	ld	s2,32(sp)
    80003222:	69e2                	ld	s3,24(sp)
    80003224:	6121                	addi	sp,sp,64
    80003226:	8082                	ret
      release(&tickslock);
    80003228:	00014517          	auipc	a0,0x14
    8000322c:	6f050513          	addi	a0,a0,1776 # 80017918 <tickslock>
    80003230:	ffffe097          	auipc	ra,0xffffe
    80003234:	8f6080e7          	jalr	-1802(ra) # 80000b26 <release>
      return -1;
    80003238:	57fd                	li	a5,-1
    8000323a:	bff9                	j	80003218 <sys_sleep+0x88>

000000008000323c <sys_kill>:

uint64
sys_kill(void)
{
    8000323c:	1101                	addi	sp,sp,-32
    8000323e:	ec06                	sd	ra,24(sp)
    80003240:	e822                	sd	s0,16(sp)
    80003242:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80003244:	fec40593          	addi	a1,s0,-20
    80003248:	4501                	li	a0,0
    8000324a:	00000097          	auipc	ra,0x0
    8000324e:	d70080e7          	jalr	-656(ra) # 80002fba <argint>
    80003252:	87aa                	mv	a5,a0
    return -1;
    80003254:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80003256:	0007c863          	bltz	a5,80003266 <sys_kill+0x2a>
  return kill(pid);
    8000325a:	fec42503          	lw	a0,-20(s0)
    8000325e:	fffff097          	auipc	ra,0xfffff
    80003262:	672080e7          	jalr	1650(ra) # 800028d0 <kill>
}
    80003266:	60e2                	ld	ra,24(sp)
    80003268:	6442                	ld	s0,16(sp)
    8000326a:	6105                	addi	sp,sp,32
    8000326c:	8082                	ret

000000008000326e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000326e:	1101                	addi	sp,sp,-32
    80003270:	ec06                	sd	ra,24(sp)
    80003272:	e822                	sd	s0,16(sp)
    80003274:	e426                	sd	s1,8(sp)
    80003276:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003278:	00014517          	auipc	a0,0x14
    8000327c:	6a050513          	addi	a0,a0,1696 # 80017918 <tickslock>
    80003280:	ffffe097          	auipc	ra,0xffffe
    80003284:	852080e7          	jalr	-1966(ra) # 80000ad2 <acquire>
  xticks = ticks;
    80003288:	00023497          	auipc	s1,0x23
    8000328c:	d984a483          	lw	s1,-616(s1) # 80026020 <ticks>
  release(&tickslock);
    80003290:	00014517          	auipc	a0,0x14
    80003294:	68850513          	addi	a0,a0,1672 # 80017918 <tickslock>
    80003298:	ffffe097          	auipc	ra,0xffffe
    8000329c:	88e080e7          	jalr	-1906(ra) # 80000b26 <release>
  return xticks;
}
    800032a0:	02049513          	slli	a0,s1,0x20
    800032a4:	9101                	srli	a0,a0,0x20
    800032a6:	60e2                	ld	ra,24(sp)
    800032a8:	6442                	ld	s0,16(sp)
    800032aa:	64a2                	ld	s1,8(sp)
    800032ac:	6105                	addi	sp,sp,32
    800032ae:	8082                	ret

00000000800032b0 <sys_tester>:

//self defined sys teseter
uint64
sys_tester(void)
{
    800032b0:	1141                	addi	sp,sp,-16
    800032b2:	e422                	sd	s0,8(sp)
    800032b4:	0800                	addi	s0,sp,16
  return 0;
}
    800032b6:	4501                	li	a0,0
    800032b8:	6422                	ld	s0,8(sp)
    800032ba:	0141                	addi	sp,sp,16
    800032bc:	8082                	ret

00000000800032be <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800032be:	7179                	addi	sp,sp,-48
    800032c0:	f406                	sd	ra,40(sp)
    800032c2:	f022                	sd	s0,32(sp)
    800032c4:	ec26                	sd	s1,24(sp)
    800032c6:	e84a                	sd	s2,16(sp)
    800032c8:	e44e                	sd	s3,8(sp)
    800032ca:	e052                	sd	s4,0(sp)
    800032cc:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800032ce:	00004597          	auipc	a1,0x4
    800032d2:	39a58593          	addi	a1,a1,922 # 80007668 <userret+0x5d8>
    800032d6:	00014517          	auipc	a0,0x14
    800032da:	65a50513          	addi	a0,a0,1626 # 80017930 <bcache>
    800032de:	ffffd097          	auipc	ra,0xffffd
    800032e2:	6e2080e7          	jalr	1762(ra) # 800009c0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800032e6:	0001c797          	auipc	a5,0x1c
    800032ea:	64a78793          	addi	a5,a5,1610 # 8001f930 <bcache+0x8000>
    800032ee:	0001d717          	auipc	a4,0x1d
    800032f2:	99a70713          	addi	a4,a4,-1638 # 8001fc88 <bcache+0x8358>
    800032f6:	3ae7b023          	sd	a4,928(a5)
  bcache.head.next = &bcache.head;
    800032fa:	3ae7b423          	sd	a4,936(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800032fe:	00014497          	auipc	s1,0x14
    80003302:	64a48493          	addi	s1,s1,1610 # 80017948 <bcache+0x18>
    b->next = bcache.head.next;
    80003306:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003308:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000330a:	00004a17          	auipc	s4,0x4
    8000330e:	366a0a13          	addi	s4,s4,870 # 80007670 <userret+0x5e0>
    b->next = bcache.head.next;
    80003312:	3a893783          	ld	a5,936(s2)
    80003316:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003318:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000331c:	85d2                	mv	a1,s4
    8000331e:	01048513          	addi	a0,s1,16
    80003322:	00001097          	auipc	ra,0x1
    80003326:	486080e7          	jalr	1158(ra) # 800047a8 <initsleeplock>
    bcache.head.next->prev = b;
    8000332a:	3a893783          	ld	a5,936(s2)
    8000332e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003330:	3a993423          	sd	s1,936(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003334:	46048493          	addi	s1,s1,1120
    80003338:	fd349de3          	bne	s1,s3,80003312 <binit+0x54>
  }
}
    8000333c:	70a2                	ld	ra,40(sp)
    8000333e:	7402                	ld	s0,32(sp)
    80003340:	64e2                	ld	s1,24(sp)
    80003342:	6942                	ld	s2,16(sp)
    80003344:	69a2                	ld	s3,8(sp)
    80003346:	6a02                	ld	s4,0(sp)
    80003348:	6145                	addi	sp,sp,48
    8000334a:	8082                	ret

000000008000334c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000334c:	7179                	addi	sp,sp,-48
    8000334e:	f406                	sd	ra,40(sp)
    80003350:	f022                	sd	s0,32(sp)
    80003352:	ec26                	sd	s1,24(sp)
    80003354:	e84a                	sd	s2,16(sp)
    80003356:	e44e                	sd	s3,8(sp)
    80003358:	1800                	addi	s0,sp,48
    8000335a:	89aa                	mv	s3,a0
    8000335c:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000335e:	00014517          	auipc	a0,0x14
    80003362:	5d250513          	addi	a0,a0,1490 # 80017930 <bcache>
    80003366:	ffffd097          	auipc	ra,0xffffd
    8000336a:	76c080e7          	jalr	1900(ra) # 80000ad2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000336e:	0001d497          	auipc	s1,0x1d
    80003372:	96a4b483          	ld	s1,-1686(s1) # 8001fcd8 <bcache+0x83a8>
    80003376:	0001d797          	auipc	a5,0x1d
    8000337a:	91278793          	addi	a5,a5,-1774 # 8001fc88 <bcache+0x8358>
    8000337e:	02f48f63          	beq	s1,a5,800033bc <bread+0x70>
    80003382:	873e                	mv	a4,a5
    80003384:	a021                	j	8000338c <bread+0x40>
    80003386:	68a4                	ld	s1,80(s1)
    80003388:	02e48a63          	beq	s1,a4,800033bc <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000338c:	449c                	lw	a5,8(s1)
    8000338e:	ff379ce3          	bne	a5,s3,80003386 <bread+0x3a>
    80003392:	44dc                	lw	a5,12(s1)
    80003394:	ff2799e3          	bne	a5,s2,80003386 <bread+0x3a>
      b->refcnt++;
    80003398:	40bc                	lw	a5,64(s1)
    8000339a:	2785                	addiw	a5,a5,1
    8000339c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000339e:	00014517          	auipc	a0,0x14
    800033a2:	59250513          	addi	a0,a0,1426 # 80017930 <bcache>
    800033a6:	ffffd097          	auipc	ra,0xffffd
    800033aa:	780080e7          	jalr	1920(ra) # 80000b26 <release>
      acquiresleep(&b->lock);
    800033ae:	01048513          	addi	a0,s1,16
    800033b2:	00001097          	auipc	ra,0x1
    800033b6:	430080e7          	jalr	1072(ra) # 800047e2 <acquiresleep>
      return b;
    800033ba:	a8b9                	j	80003418 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800033bc:	0001d497          	auipc	s1,0x1d
    800033c0:	9144b483          	ld	s1,-1772(s1) # 8001fcd0 <bcache+0x83a0>
    800033c4:	0001d797          	auipc	a5,0x1d
    800033c8:	8c478793          	addi	a5,a5,-1852 # 8001fc88 <bcache+0x8358>
    800033cc:	00f48863          	beq	s1,a5,800033dc <bread+0x90>
    800033d0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800033d2:	40bc                	lw	a5,64(s1)
    800033d4:	cf81                	beqz	a5,800033ec <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800033d6:	64a4                	ld	s1,72(s1)
    800033d8:	fee49de3          	bne	s1,a4,800033d2 <bread+0x86>
  panic("bget: no buffers");
    800033dc:	00004517          	auipc	a0,0x4
    800033e0:	29c50513          	addi	a0,a0,668 # 80007678 <userret+0x5e8>
    800033e4:	ffffd097          	auipc	ra,0xffffd
    800033e8:	16a080e7          	jalr	362(ra) # 8000054e <panic>
      b->dev = dev;
    800033ec:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800033f0:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800033f4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800033f8:	4785                	li	a5,1
    800033fa:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800033fc:	00014517          	auipc	a0,0x14
    80003400:	53450513          	addi	a0,a0,1332 # 80017930 <bcache>
    80003404:	ffffd097          	auipc	ra,0xffffd
    80003408:	722080e7          	jalr	1826(ra) # 80000b26 <release>
      acquiresleep(&b->lock);
    8000340c:	01048513          	addi	a0,s1,16
    80003410:	00001097          	auipc	ra,0x1
    80003414:	3d2080e7          	jalr	978(ra) # 800047e2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003418:	409c                	lw	a5,0(s1)
    8000341a:	cb89                	beqz	a5,8000342c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000341c:	8526                	mv	a0,s1
    8000341e:	70a2                	ld	ra,40(sp)
    80003420:	7402                	ld	s0,32(sp)
    80003422:	64e2                	ld	s1,24(sp)
    80003424:	6942                	ld	s2,16(sp)
    80003426:	69a2                	ld	s3,8(sp)
    80003428:	6145                	addi	sp,sp,48
    8000342a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000342c:	4581                	li	a1,0
    8000342e:	8526                	mv	a0,s1
    80003430:	00003097          	auipc	ra,0x3
    80003434:	ede080e7          	jalr	-290(ra) # 8000630e <virtio_disk_rw>
    b->valid = 1;
    80003438:	4785                	li	a5,1
    8000343a:	c09c                	sw	a5,0(s1)
  return b;
    8000343c:	b7c5                	j	8000341c <bread+0xd0>

000000008000343e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000343e:	1101                	addi	sp,sp,-32
    80003440:	ec06                	sd	ra,24(sp)
    80003442:	e822                	sd	s0,16(sp)
    80003444:	e426                	sd	s1,8(sp)
    80003446:	1000                	addi	s0,sp,32
    80003448:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000344a:	0541                	addi	a0,a0,16
    8000344c:	00001097          	auipc	ra,0x1
    80003450:	430080e7          	jalr	1072(ra) # 8000487c <holdingsleep>
    80003454:	cd01                	beqz	a0,8000346c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003456:	4585                	li	a1,1
    80003458:	8526                	mv	a0,s1
    8000345a:	00003097          	auipc	ra,0x3
    8000345e:	eb4080e7          	jalr	-332(ra) # 8000630e <virtio_disk_rw>
}
    80003462:	60e2                	ld	ra,24(sp)
    80003464:	6442                	ld	s0,16(sp)
    80003466:	64a2                	ld	s1,8(sp)
    80003468:	6105                	addi	sp,sp,32
    8000346a:	8082                	ret
    panic("bwrite");
    8000346c:	00004517          	auipc	a0,0x4
    80003470:	22450513          	addi	a0,a0,548 # 80007690 <userret+0x600>
    80003474:	ffffd097          	auipc	ra,0xffffd
    80003478:	0da080e7          	jalr	218(ra) # 8000054e <panic>

000000008000347c <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
    8000347c:	1101                	addi	sp,sp,-32
    8000347e:	ec06                	sd	ra,24(sp)
    80003480:	e822                	sd	s0,16(sp)
    80003482:	e426                	sd	s1,8(sp)
    80003484:	e04a                	sd	s2,0(sp)
    80003486:	1000                	addi	s0,sp,32
    80003488:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000348a:	01050913          	addi	s2,a0,16
    8000348e:	854a                	mv	a0,s2
    80003490:	00001097          	auipc	ra,0x1
    80003494:	3ec080e7          	jalr	1004(ra) # 8000487c <holdingsleep>
    80003498:	c92d                	beqz	a0,8000350a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000349a:	854a                	mv	a0,s2
    8000349c:	00001097          	auipc	ra,0x1
    800034a0:	39c080e7          	jalr	924(ra) # 80004838 <releasesleep>

  acquire(&bcache.lock);
    800034a4:	00014517          	auipc	a0,0x14
    800034a8:	48c50513          	addi	a0,a0,1164 # 80017930 <bcache>
    800034ac:	ffffd097          	auipc	ra,0xffffd
    800034b0:	626080e7          	jalr	1574(ra) # 80000ad2 <acquire>
  b->refcnt--;
    800034b4:	40bc                	lw	a5,64(s1)
    800034b6:	37fd                	addiw	a5,a5,-1
    800034b8:	0007871b          	sext.w	a4,a5
    800034bc:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800034be:	eb05                	bnez	a4,800034ee <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800034c0:	68bc                	ld	a5,80(s1)
    800034c2:	64b8                	ld	a4,72(s1)
    800034c4:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800034c6:	64bc                	ld	a5,72(s1)
    800034c8:	68b8                	ld	a4,80(s1)
    800034ca:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800034cc:	0001c797          	auipc	a5,0x1c
    800034d0:	46478793          	addi	a5,a5,1124 # 8001f930 <bcache+0x8000>
    800034d4:	3a87b703          	ld	a4,936(a5)
    800034d8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800034da:	0001c717          	auipc	a4,0x1c
    800034de:	7ae70713          	addi	a4,a4,1966 # 8001fc88 <bcache+0x8358>
    800034e2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800034e4:	3a87b703          	ld	a4,936(a5)
    800034e8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800034ea:	3a97b423          	sd	s1,936(a5)
  }
  
  release(&bcache.lock);
    800034ee:	00014517          	auipc	a0,0x14
    800034f2:	44250513          	addi	a0,a0,1090 # 80017930 <bcache>
    800034f6:	ffffd097          	auipc	ra,0xffffd
    800034fa:	630080e7          	jalr	1584(ra) # 80000b26 <release>
}
    800034fe:	60e2                	ld	ra,24(sp)
    80003500:	6442                	ld	s0,16(sp)
    80003502:	64a2                	ld	s1,8(sp)
    80003504:	6902                	ld	s2,0(sp)
    80003506:	6105                	addi	sp,sp,32
    80003508:	8082                	ret
    panic("brelse");
    8000350a:	00004517          	auipc	a0,0x4
    8000350e:	18e50513          	addi	a0,a0,398 # 80007698 <userret+0x608>
    80003512:	ffffd097          	auipc	ra,0xffffd
    80003516:	03c080e7          	jalr	60(ra) # 8000054e <panic>

000000008000351a <bpin>:

void
bpin(struct buf *b) {
    8000351a:	1101                	addi	sp,sp,-32
    8000351c:	ec06                	sd	ra,24(sp)
    8000351e:	e822                	sd	s0,16(sp)
    80003520:	e426                	sd	s1,8(sp)
    80003522:	1000                	addi	s0,sp,32
    80003524:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003526:	00014517          	auipc	a0,0x14
    8000352a:	40a50513          	addi	a0,a0,1034 # 80017930 <bcache>
    8000352e:	ffffd097          	auipc	ra,0xffffd
    80003532:	5a4080e7          	jalr	1444(ra) # 80000ad2 <acquire>
  b->refcnt++;
    80003536:	40bc                	lw	a5,64(s1)
    80003538:	2785                	addiw	a5,a5,1
    8000353a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000353c:	00014517          	auipc	a0,0x14
    80003540:	3f450513          	addi	a0,a0,1012 # 80017930 <bcache>
    80003544:	ffffd097          	auipc	ra,0xffffd
    80003548:	5e2080e7          	jalr	1506(ra) # 80000b26 <release>
}
    8000354c:	60e2                	ld	ra,24(sp)
    8000354e:	6442                	ld	s0,16(sp)
    80003550:	64a2                	ld	s1,8(sp)
    80003552:	6105                	addi	sp,sp,32
    80003554:	8082                	ret

0000000080003556 <bunpin>:

void
bunpin(struct buf *b) {
    80003556:	1101                	addi	sp,sp,-32
    80003558:	ec06                	sd	ra,24(sp)
    8000355a:	e822                	sd	s0,16(sp)
    8000355c:	e426                	sd	s1,8(sp)
    8000355e:	1000                	addi	s0,sp,32
    80003560:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003562:	00014517          	auipc	a0,0x14
    80003566:	3ce50513          	addi	a0,a0,974 # 80017930 <bcache>
    8000356a:	ffffd097          	auipc	ra,0xffffd
    8000356e:	568080e7          	jalr	1384(ra) # 80000ad2 <acquire>
  b->refcnt--;
    80003572:	40bc                	lw	a5,64(s1)
    80003574:	37fd                	addiw	a5,a5,-1
    80003576:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003578:	00014517          	auipc	a0,0x14
    8000357c:	3b850513          	addi	a0,a0,952 # 80017930 <bcache>
    80003580:	ffffd097          	auipc	ra,0xffffd
    80003584:	5a6080e7          	jalr	1446(ra) # 80000b26 <release>
}
    80003588:	60e2                	ld	ra,24(sp)
    8000358a:	6442                	ld	s0,16(sp)
    8000358c:	64a2                	ld	s1,8(sp)
    8000358e:	6105                	addi	sp,sp,32
    80003590:	8082                	ret

0000000080003592 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003592:	1101                	addi	sp,sp,-32
    80003594:	ec06                	sd	ra,24(sp)
    80003596:	e822                	sd	s0,16(sp)
    80003598:	e426                	sd	s1,8(sp)
    8000359a:	e04a                	sd	s2,0(sp)
    8000359c:	1000                	addi	s0,sp,32
    8000359e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800035a0:	00d5d59b          	srliw	a1,a1,0xd
    800035a4:	0001d797          	auipc	a5,0x1d
    800035a8:	b607a783          	lw	a5,-1184(a5) # 80020104 <sb+0x1c>
    800035ac:	9dbd                	addw	a1,a1,a5
    800035ae:	00000097          	auipc	ra,0x0
    800035b2:	d9e080e7          	jalr	-610(ra) # 8000334c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800035b6:	0074f713          	andi	a4,s1,7
    800035ba:	4785                	li	a5,1
    800035bc:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800035c0:	14ce                	slli	s1,s1,0x33
    800035c2:	90d9                	srli	s1,s1,0x36
    800035c4:	00950733          	add	a4,a0,s1
    800035c8:	06074703          	lbu	a4,96(a4)
    800035cc:	00e7f6b3          	and	a3,a5,a4
    800035d0:	c69d                	beqz	a3,800035fe <bfree+0x6c>
    800035d2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800035d4:	94aa                	add	s1,s1,a0
    800035d6:	fff7c793          	not	a5,a5
    800035da:	8ff9                	and	a5,a5,a4
    800035dc:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    800035e0:	00001097          	auipc	ra,0x1
    800035e4:	0da080e7          	jalr	218(ra) # 800046ba <log_write>
  brelse(bp);
    800035e8:	854a                	mv	a0,s2
    800035ea:	00000097          	auipc	ra,0x0
    800035ee:	e92080e7          	jalr	-366(ra) # 8000347c <brelse>
}
    800035f2:	60e2                	ld	ra,24(sp)
    800035f4:	6442                	ld	s0,16(sp)
    800035f6:	64a2                	ld	s1,8(sp)
    800035f8:	6902                	ld	s2,0(sp)
    800035fa:	6105                	addi	sp,sp,32
    800035fc:	8082                	ret
    panic("freeing free block");
    800035fe:	00004517          	auipc	a0,0x4
    80003602:	0a250513          	addi	a0,a0,162 # 800076a0 <userret+0x610>
    80003606:	ffffd097          	auipc	ra,0xffffd
    8000360a:	f48080e7          	jalr	-184(ra) # 8000054e <panic>

000000008000360e <balloc>:
{
    8000360e:	711d                	addi	sp,sp,-96
    80003610:	ec86                	sd	ra,88(sp)
    80003612:	e8a2                	sd	s0,80(sp)
    80003614:	e4a6                	sd	s1,72(sp)
    80003616:	e0ca                	sd	s2,64(sp)
    80003618:	fc4e                	sd	s3,56(sp)
    8000361a:	f852                	sd	s4,48(sp)
    8000361c:	f456                	sd	s5,40(sp)
    8000361e:	f05a                	sd	s6,32(sp)
    80003620:	ec5e                	sd	s7,24(sp)
    80003622:	e862                	sd	s8,16(sp)
    80003624:	e466                	sd	s9,8(sp)
    80003626:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003628:	0001d797          	auipc	a5,0x1d
    8000362c:	ac47a783          	lw	a5,-1340(a5) # 800200ec <sb+0x4>
    80003630:	cbd1                	beqz	a5,800036c4 <balloc+0xb6>
    80003632:	8baa                	mv	s7,a0
    80003634:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003636:	0001db17          	auipc	s6,0x1d
    8000363a:	ab2b0b13          	addi	s6,s6,-1358 # 800200e8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000363e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003640:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003642:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003644:	6c89                	lui	s9,0x2
    80003646:	a831                	j	80003662 <balloc+0x54>
    brelse(bp);
    80003648:	854a                	mv	a0,s2
    8000364a:	00000097          	auipc	ra,0x0
    8000364e:	e32080e7          	jalr	-462(ra) # 8000347c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003652:	015c87bb          	addw	a5,s9,s5
    80003656:	00078a9b          	sext.w	s5,a5
    8000365a:	004b2703          	lw	a4,4(s6)
    8000365e:	06eaf363          	bgeu	s5,a4,800036c4 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80003662:	41fad79b          	sraiw	a5,s5,0x1f
    80003666:	0137d79b          	srliw	a5,a5,0x13
    8000366a:	015787bb          	addw	a5,a5,s5
    8000366e:	40d7d79b          	sraiw	a5,a5,0xd
    80003672:	01cb2583          	lw	a1,28(s6)
    80003676:	9dbd                	addw	a1,a1,a5
    80003678:	855e                	mv	a0,s7
    8000367a:	00000097          	auipc	ra,0x0
    8000367e:	cd2080e7          	jalr	-814(ra) # 8000334c <bread>
    80003682:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003684:	004b2503          	lw	a0,4(s6)
    80003688:	000a849b          	sext.w	s1,s5
    8000368c:	8662                	mv	a2,s8
    8000368e:	faa4fde3          	bgeu	s1,a0,80003648 <balloc+0x3a>
      m = 1 << (bi % 8);
    80003692:	41f6579b          	sraiw	a5,a2,0x1f
    80003696:	01d7d69b          	srliw	a3,a5,0x1d
    8000369a:	00c6873b          	addw	a4,a3,a2
    8000369e:	00777793          	andi	a5,a4,7
    800036a2:	9f95                	subw	a5,a5,a3
    800036a4:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800036a8:	4037571b          	sraiw	a4,a4,0x3
    800036ac:	00e906b3          	add	a3,s2,a4
    800036b0:	0606c683          	lbu	a3,96(a3)
    800036b4:	00d7f5b3          	and	a1,a5,a3
    800036b8:	cd91                	beqz	a1,800036d4 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036ba:	2605                	addiw	a2,a2,1
    800036bc:	2485                	addiw	s1,s1,1
    800036be:	fd4618e3          	bne	a2,s4,8000368e <balloc+0x80>
    800036c2:	b759                	j	80003648 <balloc+0x3a>
  panic("balloc: out of blocks");
    800036c4:	00004517          	auipc	a0,0x4
    800036c8:	ff450513          	addi	a0,a0,-12 # 800076b8 <userret+0x628>
    800036cc:	ffffd097          	auipc	ra,0xffffd
    800036d0:	e82080e7          	jalr	-382(ra) # 8000054e <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800036d4:	974a                	add	a4,a4,s2
    800036d6:	8fd5                	or	a5,a5,a3
    800036d8:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    800036dc:	854a                	mv	a0,s2
    800036de:	00001097          	auipc	ra,0x1
    800036e2:	fdc080e7          	jalr	-36(ra) # 800046ba <log_write>
        brelse(bp);
    800036e6:	854a                	mv	a0,s2
    800036e8:	00000097          	auipc	ra,0x0
    800036ec:	d94080e7          	jalr	-620(ra) # 8000347c <brelse>
  bp = bread(dev, bno);
    800036f0:	85a6                	mv	a1,s1
    800036f2:	855e                	mv	a0,s7
    800036f4:	00000097          	auipc	ra,0x0
    800036f8:	c58080e7          	jalr	-936(ra) # 8000334c <bread>
    800036fc:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800036fe:	40000613          	li	a2,1024
    80003702:	4581                	li	a1,0
    80003704:	06050513          	addi	a0,a0,96
    80003708:	ffffd097          	auipc	ra,0xffffd
    8000370c:	466080e7          	jalr	1126(ra) # 80000b6e <memset>
  log_write(bp);
    80003710:	854a                	mv	a0,s2
    80003712:	00001097          	auipc	ra,0x1
    80003716:	fa8080e7          	jalr	-88(ra) # 800046ba <log_write>
  brelse(bp);
    8000371a:	854a                	mv	a0,s2
    8000371c:	00000097          	auipc	ra,0x0
    80003720:	d60080e7          	jalr	-672(ra) # 8000347c <brelse>
}
    80003724:	8526                	mv	a0,s1
    80003726:	60e6                	ld	ra,88(sp)
    80003728:	6446                	ld	s0,80(sp)
    8000372a:	64a6                	ld	s1,72(sp)
    8000372c:	6906                	ld	s2,64(sp)
    8000372e:	79e2                	ld	s3,56(sp)
    80003730:	7a42                	ld	s4,48(sp)
    80003732:	7aa2                	ld	s5,40(sp)
    80003734:	7b02                	ld	s6,32(sp)
    80003736:	6be2                	ld	s7,24(sp)
    80003738:	6c42                	ld	s8,16(sp)
    8000373a:	6ca2                	ld	s9,8(sp)
    8000373c:	6125                	addi	sp,sp,96
    8000373e:	8082                	ret

0000000080003740 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80003740:	7179                	addi	sp,sp,-48
    80003742:	f406                	sd	ra,40(sp)
    80003744:	f022                	sd	s0,32(sp)
    80003746:	ec26                	sd	s1,24(sp)
    80003748:	e84a                	sd	s2,16(sp)
    8000374a:	e44e                	sd	s3,8(sp)
    8000374c:	e052                	sd	s4,0(sp)
    8000374e:	1800                	addi	s0,sp,48
    80003750:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003752:	47ad                	li	a5,11
    80003754:	04b7fe63          	bgeu	a5,a1,800037b0 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003758:	ff45849b          	addiw	s1,a1,-12
    8000375c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003760:	0ff00793          	li	a5,255
    80003764:	0ae7e363          	bltu	a5,a4,8000380a <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003768:	08052583          	lw	a1,128(a0)
    8000376c:	c5ad                	beqz	a1,800037d6 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000376e:	00092503          	lw	a0,0(s2)
    80003772:	00000097          	auipc	ra,0x0
    80003776:	bda080e7          	jalr	-1062(ra) # 8000334c <bread>
    8000377a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000377c:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80003780:	02049593          	slli	a1,s1,0x20
    80003784:	9181                	srli	a1,a1,0x20
    80003786:	058a                	slli	a1,a1,0x2
    80003788:	00b784b3          	add	s1,a5,a1
    8000378c:	0004a983          	lw	s3,0(s1)
    80003790:	04098d63          	beqz	s3,800037ea <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003794:	8552                	mv	a0,s4
    80003796:	00000097          	auipc	ra,0x0
    8000379a:	ce6080e7          	jalr	-794(ra) # 8000347c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000379e:	854e                	mv	a0,s3
    800037a0:	70a2                	ld	ra,40(sp)
    800037a2:	7402                	ld	s0,32(sp)
    800037a4:	64e2                	ld	s1,24(sp)
    800037a6:	6942                	ld	s2,16(sp)
    800037a8:	69a2                	ld	s3,8(sp)
    800037aa:	6a02                	ld	s4,0(sp)
    800037ac:	6145                	addi	sp,sp,48
    800037ae:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800037b0:	02059493          	slli	s1,a1,0x20
    800037b4:	9081                	srli	s1,s1,0x20
    800037b6:	048a                	slli	s1,s1,0x2
    800037b8:	94aa                	add	s1,s1,a0
    800037ba:	0504a983          	lw	s3,80(s1)
    800037be:	fe0990e3          	bnez	s3,8000379e <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800037c2:	4108                	lw	a0,0(a0)
    800037c4:	00000097          	auipc	ra,0x0
    800037c8:	e4a080e7          	jalr	-438(ra) # 8000360e <balloc>
    800037cc:	0005099b          	sext.w	s3,a0
    800037d0:	0534a823          	sw	s3,80(s1)
    800037d4:	b7e9                	j	8000379e <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800037d6:	4108                	lw	a0,0(a0)
    800037d8:	00000097          	auipc	ra,0x0
    800037dc:	e36080e7          	jalr	-458(ra) # 8000360e <balloc>
    800037e0:	0005059b          	sext.w	a1,a0
    800037e4:	08b92023          	sw	a1,128(s2)
    800037e8:	b759                	j	8000376e <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800037ea:	00092503          	lw	a0,0(s2)
    800037ee:	00000097          	auipc	ra,0x0
    800037f2:	e20080e7          	jalr	-480(ra) # 8000360e <balloc>
    800037f6:	0005099b          	sext.w	s3,a0
    800037fa:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800037fe:	8552                	mv	a0,s4
    80003800:	00001097          	auipc	ra,0x1
    80003804:	eba080e7          	jalr	-326(ra) # 800046ba <log_write>
    80003808:	b771                	j	80003794 <bmap+0x54>
  panic("bmap: out of range");
    8000380a:	00004517          	auipc	a0,0x4
    8000380e:	ec650513          	addi	a0,a0,-314 # 800076d0 <userret+0x640>
    80003812:	ffffd097          	auipc	ra,0xffffd
    80003816:	d3c080e7          	jalr	-708(ra) # 8000054e <panic>

000000008000381a <iget>:
{
    8000381a:	7179                	addi	sp,sp,-48
    8000381c:	f406                	sd	ra,40(sp)
    8000381e:	f022                	sd	s0,32(sp)
    80003820:	ec26                	sd	s1,24(sp)
    80003822:	e84a                	sd	s2,16(sp)
    80003824:	e44e                	sd	s3,8(sp)
    80003826:	e052                	sd	s4,0(sp)
    80003828:	1800                	addi	s0,sp,48
    8000382a:	89aa                	mv	s3,a0
    8000382c:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    8000382e:	0001d517          	auipc	a0,0x1d
    80003832:	8da50513          	addi	a0,a0,-1830 # 80020108 <icache>
    80003836:	ffffd097          	auipc	ra,0xffffd
    8000383a:	29c080e7          	jalr	668(ra) # 80000ad2 <acquire>
  empty = 0;
    8000383e:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003840:	0001d497          	auipc	s1,0x1d
    80003844:	8e048493          	addi	s1,s1,-1824 # 80020120 <icache+0x18>
    80003848:	0001e697          	auipc	a3,0x1e
    8000384c:	36868693          	addi	a3,a3,872 # 80021bb0 <log>
    80003850:	a039                	j	8000385e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003852:	02090b63          	beqz	s2,80003888 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003856:	08848493          	addi	s1,s1,136
    8000385a:	02d48a63          	beq	s1,a3,8000388e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000385e:	449c                	lw	a5,8(s1)
    80003860:	fef059e3          	blez	a5,80003852 <iget+0x38>
    80003864:	4098                	lw	a4,0(s1)
    80003866:	ff3716e3          	bne	a4,s3,80003852 <iget+0x38>
    8000386a:	40d8                	lw	a4,4(s1)
    8000386c:	ff4713e3          	bne	a4,s4,80003852 <iget+0x38>
      ip->ref++;
    80003870:	2785                	addiw	a5,a5,1
    80003872:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003874:	0001d517          	auipc	a0,0x1d
    80003878:	89450513          	addi	a0,a0,-1900 # 80020108 <icache>
    8000387c:	ffffd097          	auipc	ra,0xffffd
    80003880:	2aa080e7          	jalr	682(ra) # 80000b26 <release>
      return ip;
    80003884:	8926                	mv	s2,s1
    80003886:	a03d                	j	800038b4 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003888:	f7f9                	bnez	a5,80003856 <iget+0x3c>
    8000388a:	8926                	mv	s2,s1
    8000388c:	b7e9                	j	80003856 <iget+0x3c>
  if(empty == 0)
    8000388e:	02090c63          	beqz	s2,800038c6 <iget+0xac>
  ip->dev = dev;
    80003892:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003896:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000389a:	4785                	li	a5,1
    8000389c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800038a0:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    800038a4:	0001d517          	auipc	a0,0x1d
    800038a8:	86450513          	addi	a0,a0,-1948 # 80020108 <icache>
    800038ac:	ffffd097          	auipc	ra,0xffffd
    800038b0:	27a080e7          	jalr	634(ra) # 80000b26 <release>
}
    800038b4:	854a                	mv	a0,s2
    800038b6:	70a2                	ld	ra,40(sp)
    800038b8:	7402                	ld	s0,32(sp)
    800038ba:	64e2                	ld	s1,24(sp)
    800038bc:	6942                	ld	s2,16(sp)
    800038be:	69a2                	ld	s3,8(sp)
    800038c0:	6a02                	ld	s4,0(sp)
    800038c2:	6145                	addi	sp,sp,48
    800038c4:	8082                	ret
    panic("iget: no inodes");
    800038c6:	00004517          	auipc	a0,0x4
    800038ca:	e2250513          	addi	a0,a0,-478 # 800076e8 <userret+0x658>
    800038ce:	ffffd097          	auipc	ra,0xffffd
    800038d2:	c80080e7          	jalr	-896(ra) # 8000054e <panic>

00000000800038d6 <fsinit>:
fsinit(int dev) {
    800038d6:	7179                	addi	sp,sp,-48
    800038d8:	f406                	sd	ra,40(sp)
    800038da:	f022                	sd	s0,32(sp)
    800038dc:	ec26                	sd	s1,24(sp)
    800038de:	e84a                	sd	s2,16(sp)
    800038e0:	e44e                	sd	s3,8(sp)
    800038e2:	1800                	addi	s0,sp,48
    800038e4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800038e6:	4585                	li	a1,1
    800038e8:	00000097          	auipc	ra,0x0
    800038ec:	a64080e7          	jalr	-1436(ra) # 8000334c <bread>
    800038f0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800038f2:	0001c997          	auipc	s3,0x1c
    800038f6:	7f698993          	addi	s3,s3,2038 # 800200e8 <sb>
    800038fa:	02000613          	li	a2,32
    800038fe:	06050593          	addi	a1,a0,96
    80003902:	854e                	mv	a0,s3
    80003904:	ffffd097          	auipc	ra,0xffffd
    80003908:	2ca080e7          	jalr	714(ra) # 80000bce <memmove>
  brelse(bp);
    8000390c:	8526                	mv	a0,s1
    8000390e:	00000097          	auipc	ra,0x0
    80003912:	b6e080e7          	jalr	-1170(ra) # 8000347c <brelse>
  if(sb.magic != FSMAGIC)
    80003916:	0009a703          	lw	a4,0(s3)
    8000391a:	102037b7          	lui	a5,0x10203
    8000391e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003922:	02f71263          	bne	a4,a5,80003946 <fsinit+0x70>
  initlog(dev, &sb);
    80003926:	0001c597          	auipc	a1,0x1c
    8000392a:	7c258593          	addi	a1,a1,1986 # 800200e8 <sb>
    8000392e:	854a                	mv	a0,s2
    80003930:	00001097          	auipc	ra,0x1
    80003934:	b12080e7          	jalr	-1262(ra) # 80004442 <initlog>
}
    80003938:	70a2                	ld	ra,40(sp)
    8000393a:	7402                	ld	s0,32(sp)
    8000393c:	64e2                	ld	s1,24(sp)
    8000393e:	6942                	ld	s2,16(sp)
    80003940:	69a2                	ld	s3,8(sp)
    80003942:	6145                	addi	sp,sp,48
    80003944:	8082                	ret
    panic("invalid file system");
    80003946:	00004517          	auipc	a0,0x4
    8000394a:	db250513          	addi	a0,a0,-590 # 800076f8 <userret+0x668>
    8000394e:	ffffd097          	auipc	ra,0xffffd
    80003952:	c00080e7          	jalr	-1024(ra) # 8000054e <panic>

0000000080003956 <iinit>:
{
    80003956:	7179                	addi	sp,sp,-48
    80003958:	f406                	sd	ra,40(sp)
    8000395a:	f022                	sd	s0,32(sp)
    8000395c:	ec26                	sd	s1,24(sp)
    8000395e:	e84a                	sd	s2,16(sp)
    80003960:	e44e                	sd	s3,8(sp)
    80003962:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003964:	00004597          	auipc	a1,0x4
    80003968:	dac58593          	addi	a1,a1,-596 # 80007710 <userret+0x680>
    8000396c:	0001c517          	auipc	a0,0x1c
    80003970:	79c50513          	addi	a0,a0,1948 # 80020108 <icache>
    80003974:	ffffd097          	auipc	ra,0xffffd
    80003978:	04c080e7          	jalr	76(ra) # 800009c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000397c:	0001c497          	auipc	s1,0x1c
    80003980:	7b448493          	addi	s1,s1,1972 # 80020130 <icache+0x28>
    80003984:	0001e997          	auipc	s3,0x1e
    80003988:	23c98993          	addi	s3,s3,572 # 80021bc0 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    8000398c:	00004917          	auipc	s2,0x4
    80003990:	d8c90913          	addi	s2,s2,-628 # 80007718 <userret+0x688>
    80003994:	85ca                	mv	a1,s2
    80003996:	8526                	mv	a0,s1
    80003998:	00001097          	auipc	ra,0x1
    8000399c:	e10080e7          	jalr	-496(ra) # 800047a8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800039a0:	08848493          	addi	s1,s1,136
    800039a4:	ff3498e3          	bne	s1,s3,80003994 <iinit+0x3e>
}
    800039a8:	70a2                	ld	ra,40(sp)
    800039aa:	7402                	ld	s0,32(sp)
    800039ac:	64e2                	ld	s1,24(sp)
    800039ae:	6942                	ld	s2,16(sp)
    800039b0:	69a2                	ld	s3,8(sp)
    800039b2:	6145                	addi	sp,sp,48
    800039b4:	8082                	ret

00000000800039b6 <ialloc>:
{
    800039b6:	715d                	addi	sp,sp,-80
    800039b8:	e486                	sd	ra,72(sp)
    800039ba:	e0a2                	sd	s0,64(sp)
    800039bc:	fc26                	sd	s1,56(sp)
    800039be:	f84a                	sd	s2,48(sp)
    800039c0:	f44e                	sd	s3,40(sp)
    800039c2:	f052                	sd	s4,32(sp)
    800039c4:	ec56                	sd	s5,24(sp)
    800039c6:	e85a                	sd	s6,16(sp)
    800039c8:	e45e                	sd	s7,8(sp)
    800039ca:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800039cc:	0001c717          	auipc	a4,0x1c
    800039d0:	72872703          	lw	a4,1832(a4) # 800200f4 <sb+0xc>
    800039d4:	4785                	li	a5,1
    800039d6:	04e7fa63          	bgeu	a5,a4,80003a2a <ialloc+0x74>
    800039da:	8aaa                	mv	s5,a0
    800039dc:	8bae                	mv	s7,a1
    800039de:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800039e0:	0001ca17          	auipc	s4,0x1c
    800039e4:	708a0a13          	addi	s4,s4,1800 # 800200e8 <sb>
    800039e8:	00048b1b          	sext.w	s6,s1
    800039ec:	0044d593          	srli	a1,s1,0x4
    800039f0:	018a2783          	lw	a5,24(s4)
    800039f4:	9dbd                	addw	a1,a1,a5
    800039f6:	8556                	mv	a0,s5
    800039f8:	00000097          	auipc	ra,0x0
    800039fc:	954080e7          	jalr	-1708(ra) # 8000334c <bread>
    80003a00:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003a02:	06050993          	addi	s3,a0,96
    80003a06:	00f4f793          	andi	a5,s1,15
    80003a0a:	079a                	slli	a5,a5,0x6
    80003a0c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003a0e:	00099783          	lh	a5,0(s3)
    80003a12:	c785                	beqz	a5,80003a3a <ialloc+0x84>
    brelse(bp);
    80003a14:	00000097          	auipc	ra,0x0
    80003a18:	a68080e7          	jalr	-1432(ra) # 8000347c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a1c:	0485                	addi	s1,s1,1
    80003a1e:	00ca2703          	lw	a4,12(s4)
    80003a22:	0004879b          	sext.w	a5,s1
    80003a26:	fce7e1e3          	bltu	a5,a4,800039e8 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003a2a:	00004517          	auipc	a0,0x4
    80003a2e:	cf650513          	addi	a0,a0,-778 # 80007720 <userret+0x690>
    80003a32:	ffffd097          	auipc	ra,0xffffd
    80003a36:	b1c080e7          	jalr	-1252(ra) # 8000054e <panic>
      memset(dip, 0, sizeof(*dip));
    80003a3a:	04000613          	li	a2,64
    80003a3e:	4581                	li	a1,0
    80003a40:	854e                	mv	a0,s3
    80003a42:	ffffd097          	auipc	ra,0xffffd
    80003a46:	12c080e7          	jalr	300(ra) # 80000b6e <memset>
      dip->type = type;
    80003a4a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003a4e:	854a                	mv	a0,s2
    80003a50:	00001097          	auipc	ra,0x1
    80003a54:	c6a080e7          	jalr	-918(ra) # 800046ba <log_write>
      brelse(bp);
    80003a58:	854a                	mv	a0,s2
    80003a5a:	00000097          	auipc	ra,0x0
    80003a5e:	a22080e7          	jalr	-1502(ra) # 8000347c <brelse>
      return iget(dev, inum);
    80003a62:	85da                	mv	a1,s6
    80003a64:	8556                	mv	a0,s5
    80003a66:	00000097          	auipc	ra,0x0
    80003a6a:	db4080e7          	jalr	-588(ra) # 8000381a <iget>
}
    80003a6e:	60a6                	ld	ra,72(sp)
    80003a70:	6406                	ld	s0,64(sp)
    80003a72:	74e2                	ld	s1,56(sp)
    80003a74:	7942                	ld	s2,48(sp)
    80003a76:	79a2                	ld	s3,40(sp)
    80003a78:	7a02                	ld	s4,32(sp)
    80003a7a:	6ae2                	ld	s5,24(sp)
    80003a7c:	6b42                	ld	s6,16(sp)
    80003a7e:	6ba2                	ld	s7,8(sp)
    80003a80:	6161                	addi	sp,sp,80
    80003a82:	8082                	ret

0000000080003a84 <iupdate>:
{
    80003a84:	1101                	addi	sp,sp,-32
    80003a86:	ec06                	sd	ra,24(sp)
    80003a88:	e822                	sd	s0,16(sp)
    80003a8a:	e426                	sd	s1,8(sp)
    80003a8c:	e04a                	sd	s2,0(sp)
    80003a8e:	1000                	addi	s0,sp,32
    80003a90:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003a92:	415c                	lw	a5,4(a0)
    80003a94:	0047d79b          	srliw	a5,a5,0x4
    80003a98:	0001c597          	auipc	a1,0x1c
    80003a9c:	6685a583          	lw	a1,1640(a1) # 80020100 <sb+0x18>
    80003aa0:	9dbd                	addw	a1,a1,a5
    80003aa2:	4108                	lw	a0,0(a0)
    80003aa4:	00000097          	auipc	ra,0x0
    80003aa8:	8a8080e7          	jalr	-1880(ra) # 8000334c <bread>
    80003aac:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003aae:	06050793          	addi	a5,a0,96
    80003ab2:	40c8                	lw	a0,4(s1)
    80003ab4:	893d                	andi	a0,a0,15
    80003ab6:	051a                	slli	a0,a0,0x6
    80003ab8:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003aba:	04449703          	lh	a4,68(s1)
    80003abe:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003ac2:	04649703          	lh	a4,70(s1)
    80003ac6:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003aca:	04849703          	lh	a4,72(s1)
    80003ace:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003ad2:	04a49703          	lh	a4,74(s1)
    80003ad6:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003ada:	44f8                	lw	a4,76(s1)
    80003adc:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003ade:	03400613          	li	a2,52
    80003ae2:	05048593          	addi	a1,s1,80
    80003ae6:	0531                	addi	a0,a0,12
    80003ae8:	ffffd097          	auipc	ra,0xffffd
    80003aec:	0e6080e7          	jalr	230(ra) # 80000bce <memmove>
  log_write(bp);
    80003af0:	854a                	mv	a0,s2
    80003af2:	00001097          	auipc	ra,0x1
    80003af6:	bc8080e7          	jalr	-1080(ra) # 800046ba <log_write>
  brelse(bp);
    80003afa:	854a                	mv	a0,s2
    80003afc:	00000097          	auipc	ra,0x0
    80003b00:	980080e7          	jalr	-1664(ra) # 8000347c <brelse>
}
    80003b04:	60e2                	ld	ra,24(sp)
    80003b06:	6442                	ld	s0,16(sp)
    80003b08:	64a2                	ld	s1,8(sp)
    80003b0a:	6902                	ld	s2,0(sp)
    80003b0c:	6105                	addi	sp,sp,32
    80003b0e:	8082                	ret

0000000080003b10 <idup>:
{
    80003b10:	1101                	addi	sp,sp,-32
    80003b12:	ec06                	sd	ra,24(sp)
    80003b14:	e822                	sd	s0,16(sp)
    80003b16:	e426                	sd	s1,8(sp)
    80003b18:	1000                	addi	s0,sp,32
    80003b1a:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003b1c:	0001c517          	auipc	a0,0x1c
    80003b20:	5ec50513          	addi	a0,a0,1516 # 80020108 <icache>
    80003b24:	ffffd097          	auipc	ra,0xffffd
    80003b28:	fae080e7          	jalr	-82(ra) # 80000ad2 <acquire>
  ip->ref++;
    80003b2c:	449c                	lw	a5,8(s1)
    80003b2e:	2785                	addiw	a5,a5,1
    80003b30:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003b32:	0001c517          	auipc	a0,0x1c
    80003b36:	5d650513          	addi	a0,a0,1494 # 80020108 <icache>
    80003b3a:	ffffd097          	auipc	ra,0xffffd
    80003b3e:	fec080e7          	jalr	-20(ra) # 80000b26 <release>
}
    80003b42:	8526                	mv	a0,s1
    80003b44:	60e2                	ld	ra,24(sp)
    80003b46:	6442                	ld	s0,16(sp)
    80003b48:	64a2                	ld	s1,8(sp)
    80003b4a:	6105                	addi	sp,sp,32
    80003b4c:	8082                	ret

0000000080003b4e <ilock>:
{
    80003b4e:	1101                	addi	sp,sp,-32
    80003b50:	ec06                	sd	ra,24(sp)
    80003b52:	e822                	sd	s0,16(sp)
    80003b54:	e426                	sd	s1,8(sp)
    80003b56:	e04a                	sd	s2,0(sp)
    80003b58:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003b5a:	c115                	beqz	a0,80003b7e <ilock+0x30>
    80003b5c:	84aa                	mv	s1,a0
    80003b5e:	451c                	lw	a5,8(a0)
    80003b60:	00f05f63          	blez	a5,80003b7e <ilock+0x30>
  acquiresleep(&ip->lock);
    80003b64:	0541                	addi	a0,a0,16
    80003b66:	00001097          	auipc	ra,0x1
    80003b6a:	c7c080e7          	jalr	-900(ra) # 800047e2 <acquiresleep>
  if(ip->valid == 0){
    80003b6e:	40bc                	lw	a5,64(s1)
    80003b70:	cf99                	beqz	a5,80003b8e <ilock+0x40>
}
    80003b72:	60e2                	ld	ra,24(sp)
    80003b74:	6442                	ld	s0,16(sp)
    80003b76:	64a2                	ld	s1,8(sp)
    80003b78:	6902                	ld	s2,0(sp)
    80003b7a:	6105                	addi	sp,sp,32
    80003b7c:	8082                	ret
    panic("ilock");
    80003b7e:	00004517          	auipc	a0,0x4
    80003b82:	bba50513          	addi	a0,a0,-1094 # 80007738 <userret+0x6a8>
    80003b86:	ffffd097          	auipc	ra,0xffffd
    80003b8a:	9c8080e7          	jalr	-1592(ra) # 8000054e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003b8e:	40dc                	lw	a5,4(s1)
    80003b90:	0047d79b          	srliw	a5,a5,0x4
    80003b94:	0001c597          	auipc	a1,0x1c
    80003b98:	56c5a583          	lw	a1,1388(a1) # 80020100 <sb+0x18>
    80003b9c:	9dbd                	addw	a1,a1,a5
    80003b9e:	4088                	lw	a0,0(s1)
    80003ba0:	fffff097          	auipc	ra,0xfffff
    80003ba4:	7ac080e7          	jalr	1964(ra) # 8000334c <bread>
    80003ba8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003baa:	06050593          	addi	a1,a0,96
    80003bae:	40dc                	lw	a5,4(s1)
    80003bb0:	8bbd                	andi	a5,a5,15
    80003bb2:	079a                	slli	a5,a5,0x6
    80003bb4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003bb6:	00059783          	lh	a5,0(a1)
    80003bba:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003bbe:	00259783          	lh	a5,2(a1)
    80003bc2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003bc6:	00459783          	lh	a5,4(a1)
    80003bca:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003bce:	00659783          	lh	a5,6(a1)
    80003bd2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003bd6:	459c                	lw	a5,8(a1)
    80003bd8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003bda:	03400613          	li	a2,52
    80003bde:	05b1                	addi	a1,a1,12
    80003be0:	05048513          	addi	a0,s1,80
    80003be4:	ffffd097          	auipc	ra,0xffffd
    80003be8:	fea080e7          	jalr	-22(ra) # 80000bce <memmove>
    brelse(bp);
    80003bec:	854a                	mv	a0,s2
    80003bee:	00000097          	auipc	ra,0x0
    80003bf2:	88e080e7          	jalr	-1906(ra) # 8000347c <brelse>
    ip->valid = 1;
    80003bf6:	4785                	li	a5,1
    80003bf8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003bfa:	04449783          	lh	a5,68(s1)
    80003bfe:	fbb5                	bnez	a5,80003b72 <ilock+0x24>
      panic("ilock: no type");
    80003c00:	00004517          	auipc	a0,0x4
    80003c04:	b4050513          	addi	a0,a0,-1216 # 80007740 <userret+0x6b0>
    80003c08:	ffffd097          	auipc	ra,0xffffd
    80003c0c:	946080e7          	jalr	-1722(ra) # 8000054e <panic>

0000000080003c10 <iunlock>:
{
    80003c10:	1101                	addi	sp,sp,-32
    80003c12:	ec06                	sd	ra,24(sp)
    80003c14:	e822                	sd	s0,16(sp)
    80003c16:	e426                	sd	s1,8(sp)
    80003c18:	e04a                	sd	s2,0(sp)
    80003c1a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003c1c:	c905                	beqz	a0,80003c4c <iunlock+0x3c>
    80003c1e:	84aa                	mv	s1,a0
    80003c20:	01050913          	addi	s2,a0,16
    80003c24:	854a                	mv	a0,s2
    80003c26:	00001097          	auipc	ra,0x1
    80003c2a:	c56080e7          	jalr	-938(ra) # 8000487c <holdingsleep>
    80003c2e:	cd19                	beqz	a0,80003c4c <iunlock+0x3c>
    80003c30:	449c                	lw	a5,8(s1)
    80003c32:	00f05d63          	blez	a5,80003c4c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003c36:	854a                	mv	a0,s2
    80003c38:	00001097          	auipc	ra,0x1
    80003c3c:	c00080e7          	jalr	-1024(ra) # 80004838 <releasesleep>
}
    80003c40:	60e2                	ld	ra,24(sp)
    80003c42:	6442                	ld	s0,16(sp)
    80003c44:	64a2                	ld	s1,8(sp)
    80003c46:	6902                	ld	s2,0(sp)
    80003c48:	6105                	addi	sp,sp,32
    80003c4a:	8082                	ret
    panic("iunlock");
    80003c4c:	00004517          	auipc	a0,0x4
    80003c50:	b0450513          	addi	a0,a0,-1276 # 80007750 <userret+0x6c0>
    80003c54:	ffffd097          	auipc	ra,0xffffd
    80003c58:	8fa080e7          	jalr	-1798(ra) # 8000054e <panic>

0000000080003c5c <iput>:
{
    80003c5c:	7139                	addi	sp,sp,-64
    80003c5e:	fc06                	sd	ra,56(sp)
    80003c60:	f822                	sd	s0,48(sp)
    80003c62:	f426                	sd	s1,40(sp)
    80003c64:	f04a                	sd	s2,32(sp)
    80003c66:	ec4e                	sd	s3,24(sp)
    80003c68:	e852                	sd	s4,16(sp)
    80003c6a:	e456                	sd	s5,8(sp)
    80003c6c:	0080                	addi	s0,sp,64
    80003c6e:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003c70:	0001c517          	auipc	a0,0x1c
    80003c74:	49850513          	addi	a0,a0,1176 # 80020108 <icache>
    80003c78:	ffffd097          	auipc	ra,0xffffd
    80003c7c:	e5a080e7          	jalr	-422(ra) # 80000ad2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c80:	4498                	lw	a4,8(s1)
    80003c82:	4785                	li	a5,1
    80003c84:	02f70663          	beq	a4,a5,80003cb0 <iput+0x54>
  ip->ref--;
    80003c88:	449c                	lw	a5,8(s1)
    80003c8a:	37fd                	addiw	a5,a5,-1
    80003c8c:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003c8e:	0001c517          	auipc	a0,0x1c
    80003c92:	47a50513          	addi	a0,a0,1146 # 80020108 <icache>
    80003c96:	ffffd097          	auipc	ra,0xffffd
    80003c9a:	e90080e7          	jalr	-368(ra) # 80000b26 <release>
}
    80003c9e:	70e2                	ld	ra,56(sp)
    80003ca0:	7442                	ld	s0,48(sp)
    80003ca2:	74a2                	ld	s1,40(sp)
    80003ca4:	7902                	ld	s2,32(sp)
    80003ca6:	69e2                	ld	s3,24(sp)
    80003ca8:	6a42                	ld	s4,16(sp)
    80003caa:	6aa2                	ld	s5,8(sp)
    80003cac:	6121                	addi	sp,sp,64
    80003cae:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003cb0:	40bc                	lw	a5,64(s1)
    80003cb2:	dbf9                	beqz	a5,80003c88 <iput+0x2c>
    80003cb4:	04a49783          	lh	a5,74(s1)
    80003cb8:	fbe1                	bnez	a5,80003c88 <iput+0x2c>
    acquiresleep(&ip->lock);
    80003cba:	01048a13          	addi	s4,s1,16
    80003cbe:	8552                	mv	a0,s4
    80003cc0:	00001097          	auipc	ra,0x1
    80003cc4:	b22080e7          	jalr	-1246(ra) # 800047e2 <acquiresleep>
    release(&icache.lock);
    80003cc8:	0001c517          	auipc	a0,0x1c
    80003ccc:	44050513          	addi	a0,a0,1088 # 80020108 <icache>
    80003cd0:	ffffd097          	auipc	ra,0xffffd
    80003cd4:	e56080e7          	jalr	-426(ra) # 80000b26 <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003cd8:	05048913          	addi	s2,s1,80
    80003cdc:	08048993          	addi	s3,s1,128
    80003ce0:	a819                	j	80003cf6 <iput+0x9a>
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
    80003ce2:	4088                	lw	a0,0(s1)
    80003ce4:	00000097          	auipc	ra,0x0
    80003ce8:	8ae080e7          	jalr	-1874(ra) # 80003592 <bfree>
      ip->addrs[i] = 0;
    80003cec:	00092023          	sw	zero,0(s2)
  for(i = 0; i < NDIRECT; i++){
    80003cf0:	0911                	addi	s2,s2,4
    80003cf2:	01390663          	beq	s2,s3,80003cfe <iput+0xa2>
    if(ip->addrs[i]){
    80003cf6:	00092583          	lw	a1,0(s2)
    80003cfa:	d9fd                	beqz	a1,80003cf0 <iput+0x94>
    80003cfc:	b7dd                	j	80003ce2 <iput+0x86>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003cfe:	0804a583          	lw	a1,128(s1)
    80003d02:	ed9d                	bnez	a1,80003d40 <iput+0xe4>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003d04:	0404a623          	sw	zero,76(s1)
  iupdate(ip);
    80003d08:	8526                	mv	a0,s1
    80003d0a:	00000097          	auipc	ra,0x0
    80003d0e:	d7a080e7          	jalr	-646(ra) # 80003a84 <iupdate>
    ip->type = 0;
    80003d12:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003d16:	8526                	mv	a0,s1
    80003d18:	00000097          	auipc	ra,0x0
    80003d1c:	d6c080e7          	jalr	-660(ra) # 80003a84 <iupdate>
    ip->valid = 0;
    80003d20:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003d24:	8552                	mv	a0,s4
    80003d26:	00001097          	auipc	ra,0x1
    80003d2a:	b12080e7          	jalr	-1262(ra) # 80004838 <releasesleep>
    acquire(&icache.lock);
    80003d2e:	0001c517          	auipc	a0,0x1c
    80003d32:	3da50513          	addi	a0,a0,986 # 80020108 <icache>
    80003d36:	ffffd097          	auipc	ra,0xffffd
    80003d3a:	d9c080e7          	jalr	-612(ra) # 80000ad2 <acquire>
    80003d3e:	b7a9                	j	80003c88 <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003d40:	4088                	lw	a0,0(s1)
    80003d42:	fffff097          	auipc	ra,0xfffff
    80003d46:	60a080e7          	jalr	1546(ra) # 8000334c <bread>
    80003d4a:	8aaa                	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
    80003d4c:	06050913          	addi	s2,a0,96
    80003d50:	46050993          	addi	s3,a0,1120
    80003d54:	a809                	j	80003d66 <iput+0x10a>
        bfree(ip->dev, a[j]);
    80003d56:	4088                	lw	a0,0(s1)
    80003d58:	00000097          	auipc	ra,0x0
    80003d5c:	83a080e7          	jalr	-1990(ra) # 80003592 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80003d60:	0911                	addi	s2,s2,4
    80003d62:	01390663          	beq	s2,s3,80003d6e <iput+0x112>
      if(a[j])
    80003d66:	00092583          	lw	a1,0(s2)
    80003d6a:	d9fd                	beqz	a1,80003d60 <iput+0x104>
    80003d6c:	b7ed                	j	80003d56 <iput+0xfa>
    brelse(bp);
    80003d6e:	8556                	mv	a0,s5
    80003d70:	fffff097          	auipc	ra,0xfffff
    80003d74:	70c080e7          	jalr	1804(ra) # 8000347c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003d78:	0804a583          	lw	a1,128(s1)
    80003d7c:	4088                	lw	a0,0(s1)
    80003d7e:	00000097          	auipc	ra,0x0
    80003d82:	814080e7          	jalr	-2028(ra) # 80003592 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003d86:	0804a023          	sw	zero,128(s1)
    80003d8a:	bfad                	j	80003d04 <iput+0xa8>

0000000080003d8c <iunlockput>:
{
    80003d8c:	1101                	addi	sp,sp,-32
    80003d8e:	ec06                	sd	ra,24(sp)
    80003d90:	e822                	sd	s0,16(sp)
    80003d92:	e426                	sd	s1,8(sp)
    80003d94:	1000                	addi	s0,sp,32
    80003d96:	84aa                	mv	s1,a0
  iunlock(ip);
    80003d98:	00000097          	auipc	ra,0x0
    80003d9c:	e78080e7          	jalr	-392(ra) # 80003c10 <iunlock>
  iput(ip);
    80003da0:	8526                	mv	a0,s1
    80003da2:	00000097          	auipc	ra,0x0
    80003da6:	eba080e7          	jalr	-326(ra) # 80003c5c <iput>
}
    80003daa:	60e2                	ld	ra,24(sp)
    80003dac:	6442                	ld	s0,16(sp)
    80003dae:	64a2                	ld	s1,8(sp)
    80003db0:	6105                	addi	sp,sp,32
    80003db2:	8082                	ret

0000000080003db4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003db4:	1141                	addi	sp,sp,-16
    80003db6:	e422                	sd	s0,8(sp)
    80003db8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003dba:	411c                	lw	a5,0(a0)
    80003dbc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003dbe:	415c                	lw	a5,4(a0)
    80003dc0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003dc2:	04451783          	lh	a5,68(a0)
    80003dc6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003dca:	04a51783          	lh	a5,74(a0)
    80003dce:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003dd2:	04c56783          	lwu	a5,76(a0)
    80003dd6:	e99c                	sd	a5,16(a1)
}
    80003dd8:	6422                	ld	s0,8(sp)
    80003dda:	0141                	addi	sp,sp,16
    80003ddc:	8082                	ret

0000000080003dde <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003dde:	457c                	lw	a5,76(a0)
    80003de0:	0ed7e563          	bltu	a5,a3,80003eca <readi+0xec>
{
    80003de4:	7159                	addi	sp,sp,-112
    80003de6:	f486                	sd	ra,104(sp)
    80003de8:	f0a2                	sd	s0,96(sp)
    80003dea:	eca6                	sd	s1,88(sp)
    80003dec:	e8ca                	sd	s2,80(sp)
    80003dee:	e4ce                	sd	s3,72(sp)
    80003df0:	e0d2                	sd	s4,64(sp)
    80003df2:	fc56                	sd	s5,56(sp)
    80003df4:	f85a                	sd	s6,48(sp)
    80003df6:	f45e                	sd	s7,40(sp)
    80003df8:	f062                	sd	s8,32(sp)
    80003dfa:	ec66                	sd	s9,24(sp)
    80003dfc:	e86a                	sd	s10,16(sp)
    80003dfe:	e46e                	sd	s11,8(sp)
    80003e00:	1880                	addi	s0,sp,112
    80003e02:	8baa                	mv	s7,a0
    80003e04:	8c2e                	mv	s8,a1
    80003e06:	8ab2                	mv	s5,a2
    80003e08:	8936                	mv	s2,a3
    80003e0a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003e0c:	9f35                	addw	a4,a4,a3
    80003e0e:	0cd76063          	bltu	a4,a3,80003ece <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    80003e12:	00e7f463          	bgeu	a5,a4,80003e1a <readi+0x3c>
    n = ip->size - off;
    80003e16:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e1a:	080b0763          	beqz	s6,80003ea8 <readi+0xca>
    80003e1e:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e20:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003e24:	5cfd                	li	s9,-1
    80003e26:	a82d                	j	80003e60 <readi+0x82>
    80003e28:	02099d93          	slli	s11,s3,0x20
    80003e2c:	020ddd93          	srli	s11,s11,0x20
    80003e30:	06048613          	addi	a2,s1,96
    80003e34:	86ee                	mv	a3,s11
    80003e36:	963a                	add	a2,a2,a4
    80003e38:	85d6                	mv	a1,s5
    80003e3a:	8562                	mv	a0,s8
    80003e3c:	fffff097          	auipc	ra,0xfffff
    80003e40:	b3c080e7          	jalr	-1220(ra) # 80002978 <either_copyout>
    80003e44:	05950d63          	beq	a0,s9,80003e9e <readi+0xc0>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003e48:	8526                	mv	a0,s1
    80003e4a:	fffff097          	auipc	ra,0xfffff
    80003e4e:	632080e7          	jalr	1586(ra) # 8000347c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e52:	01498a3b          	addw	s4,s3,s4
    80003e56:	0129893b          	addw	s2,s3,s2
    80003e5a:	9aee                	add	s5,s5,s11
    80003e5c:	056a7663          	bgeu	s4,s6,80003ea8 <readi+0xca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003e60:	000ba483          	lw	s1,0(s7)
    80003e64:	00a9559b          	srliw	a1,s2,0xa
    80003e68:	855e                	mv	a0,s7
    80003e6a:	00000097          	auipc	ra,0x0
    80003e6e:	8d6080e7          	jalr	-1834(ra) # 80003740 <bmap>
    80003e72:	0005059b          	sext.w	a1,a0
    80003e76:	8526                	mv	a0,s1
    80003e78:	fffff097          	auipc	ra,0xfffff
    80003e7c:	4d4080e7          	jalr	1236(ra) # 8000334c <bread>
    80003e80:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e82:	3ff97713          	andi	a4,s2,1023
    80003e86:	40ed07bb          	subw	a5,s10,a4
    80003e8a:	414b06bb          	subw	a3,s6,s4
    80003e8e:	89be                	mv	s3,a5
    80003e90:	2781                	sext.w	a5,a5
    80003e92:	0006861b          	sext.w	a2,a3
    80003e96:	f8f679e3          	bgeu	a2,a5,80003e28 <readi+0x4a>
    80003e9a:	89b6                	mv	s3,a3
    80003e9c:	b771                	j	80003e28 <readi+0x4a>
      brelse(bp);
    80003e9e:	8526                	mv	a0,s1
    80003ea0:	fffff097          	auipc	ra,0xfffff
    80003ea4:	5dc080e7          	jalr	1500(ra) # 8000347c <brelse>
  }
  return n;
    80003ea8:	000b051b          	sext.w	a0,s6
}
    80003eac:	70a6                	ld	ra,104(sp)
    80003eae:	7406                	ld	s0,96(sp)
    80003eb0:	64e6                	ld	s1,88(sp)
    80003eb2:	6946                	ld	s2,80(sp)
    80003eb4:	69a6                	ld	s3,72(sp)
    80003eb6:	6a06                	ld	s4,64(sp)
    80003eb8:	7ae2                	ld	s5,56(sp)
    80003eba:	7b42                	ld	s6,48(sp)
    80003ebc:	7ba2                	ld	s7,40(sp)
    80003ebe:	7c02                	ld	s8,32(sp)
    80003ec0:	6ce2                	ld	s9,24(sp)
    80003ec2:	6d42                	ld	s10,16(sp)
    80003ec4:	6da2                	ld	s11,8(sp)
    80003ec6:	6165                	addi	sp,sp,112
    80003ec8:	8082                	ret
    return -1;
    80003eca:	557d                	li	a0,-1
}
    80003ecc:	8082                	ret
    return -1;
    80003ece:	557d                	li	a0,-1
    80003ed0:	bff1                	j	80003eac <readi+0xce>

0000000080003ed2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ed2:	457c                	lw	a5,76(a0)
    80003ed4:	10d7e663          	bltu	a5,a3,80003fe0 <writei+0x10e>
{
    80003ed8:	7159                	addi	sp,sp,-112
    80003eda:	f486                	sd	ra,104(sp)
    80003edc:	f0a2                	sd	s0,96(sp)
    80003ede:	eca6                	sd	s1,88(sp)
    80003ee0:	e8ca                	sd	s2,80(sp)
    80003ee2:	e4ce                	sd	s3,72(sp)
    80003ee4:	e0d2                	sd	s4,64(sp)
    80003ee6:	fc56                	sd	s5,56(sp)
    80003ee8:	f85a                	sd	s6,48(sp)
    80003eea:	f45e                	sd	s7,40(sp)
    80003eec:	f062                	sd	s8,32(sp)
    80003eee:	ec66                	sd	s9,24(sp)
    80003ef0:	e86a                	sd	s10,16(sp)
    80003ef2:	e46e                	sd	s11,8(sp)
    80003ef4:	1880                	addi	s0,sp,112
    80003ef6:	8baa                	mv	s7,a0
    80003ef8:	8c2e                	mv	s8,a1
    80003efa:	8ab2                	mv	s5,a2
    80003efc:	8936                	mv	s2,a3
    80003efe:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003f00:	00e687bb          	addw	a5,a3,a4
    80003f04:	0ed7e063          	bltu	a5,a3,80003fe4 <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003f08:	00043737          	lui	a4,0x43
    80003f0c:	0cf76e63          	bltu	a4,a5,80003fe8 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f10:	0a0b0763          	beqz	s6,80003fbe <writei+0xec>
    80003f14:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f16:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003f1a:	5cfd                	li	s9,-1
    80003f1c:	a091                	j	80003f60 <writei+0x8e>
    80003f1e:	02099d93          	slli	s11,s3,0x20
    80003f22:	020ddd93          	srli	s11,s11,0x20
    80003f26:	06048513          	addi	a0,s1,96
    80003f2a:	86ee                	mv	a3,s11
    80003f2c:	8656                	mv	a2,s5
    80003f2e:	85e2                	mv	a1,s8
    80003f30:	953a                	add	a0,a0,a4
    80003f32:	fffff097          	auipc	ra,0xfffff
    80003f36:	a9c080e7          	jalr	-1380(ra) # 800029ce <either_copyin>
    80003f3a:	07950263          	beq	a0,s9,80003f9e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003f3e:	8526                	mv	a0,s1
    80003f40:	00000097          	auipc	ra,0x0
    80003f44:	77a080e7          	jalr	1914(ra) # 800046ba <log_write>
    brelse(bp);
    80003f48:	8526                	mv	a0,s1
    80003f4a:	fffff097          	auipc	ra,0xfffff
    80003f4e:	532080e7          	jalr	1330(ra) # 8000347c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f52:	01498a3b          	addw	s4,s3,s4
    80003f56:	0129893b          	addw	s2,s3,s2
    80003f5a:	9aee                	add	s5,s5,s11
    80003f5c:	056a7663          	bgeu	s4,s6,80003fa8 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003f60:	000ba483          	lw	s1,0(s7)
    80003f64:	00a9559b          	srliw	a1,s2,0xa
    80003f68:	855e                	mv	a0,s7
    80003f6a:	fffff097          	auipc	ra,0xfffff
    80003f6e:	7d6080e7          	jalr	2006(ra) # 80003740 <bmap>
    80003f72:	0005059b          	sext.w	a1,a0
    80003f76:	8526                	mv	a0,s1
    80003f78:	fffff097          	auipc	ra,0xfffff
    80003f7c:	3d4080e7          	jalr	980(ra) # 8000334c <bread>
    80003f80:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f82:	3ff97713          	andi	a4,s2,1023
    80003f86:	40ed07bb          	subw	a5,s10,a4
    80003f8a:	414b06bb          	subw	a3,s6,s4
    80003f8e:	89be                	mv	s3,a5
    80003f90:	2781                	sext.w	a5,a5
    80003f92:	0006861b          	sext.w	a2,a3
    80003f96:	f8f674e3          	bgeu	a2,a5,80003f1e <writei+0x4c>
    80003f9a:	89b6                	mv	s3,a3
    80003f9c:	b749                	j	80003f1e <writei+0x4c>
      brelse(bp);
    80003f9e:	8526                	mv	a0,s1
    80003fa0:	fffff097          	auipc	ra,0xfffff
    80003fa4:	4dc080e7          	jalr	1244(ra) # 8000347c <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003fa8:	04cba783          	lw	a5,76(s7)
    80003fac:	0127f463          	bgeu	a5,s2,80003fb4 <writei+0xe2>
      ip->size = off;
    80003fb0:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003fb4:	855e                	mv	a0,s7
    80003fb6:	00000097          	auipc	ra,0x0
    80003fba:	ace080e7          	jalr	-1330(ra) # 80003a84 <iupdate>
  }

  return n;
    80003fbe:	000b051b          	sext.w	a0,s6
}
    80003fc2:	70a6                	ld	ra,104(sp)
    80003fc4:	7406                	ld	s0,96(sp)
    80003fc6:	64e6                	ld	s1,88(sp)
    80003fc8:	6946                	ld	s2,80(sp)
    80003fca:	69a6                	ld	s3,72(sp)
    80003fcc:	6a06                	ld	s4,64(sp)
    80003fce:	7ae2                	ld	s5,56(sp)
    80003fd0:	7b42                	ld	s6,48(sp)
    80003fd2:	7ba2                	ld	s7,40(sp)
    80003fd4:	7c02                	ld	s8,32(sp)
    80003fd6:	6ce2                	ld	s9,24(sp)
    80003fd8:	6d42                	ld	s10,16(sp)
    80003fda:	6da2                	ld	s11,8(sp)
    80003fdc:	6165                	addi	sp,sp,112
    80003fde:	8082                	ret
    return -1;
    80003fe0:	557d                	li	a0,-1
}
    80003fe2:	8082                	ret
    return -1;
    80003fe4:	557d                	li	a0,-1
    80003fe6:	bff1                	j	80003fc2 <writei+0xf0>
    return -1;
    80003fe8:	557d                	li	a0,-1
    80003fea:	bfe1                	j	80003fc2 <writei+0xf0>

0000000080003fec <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003fec:	1141                	addi	sp,sp,-16
    80003fee:	e406                	sd	ra,8(sp)
    80003ff0:	e022                	sd	s0,0(sp)
    80003ff2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003ff4:	4639                	li	a2,14
    80003ff6:	ffffd097          	auipc	ra,0xffffd
    80003ffa:	c54080e7          	jalr	-940(ra) # 80000c4a <strncmp>
}
    80003ffe:	60a2                	ld	ra,8(sp)
    80004000:	6402                	ld	s0,0(sp)
    80004002:	0141                	addi	sp,sp,16
    80004004:	8082                	ret

0000000080004006 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004006:	7139                	addi	sp,sp,-64
    80004008:	fc06                	sd	ra,56(sp)
    8000400a:	f822                	sd	s0,48(sp)
    8000400c:	f426                	sd	s1,40(sp)
    8000400e:	f04a                	sd	s2,32(sp)
    80004010:	ec4e                	sd	s3,24(sp)
    80004012:	e852                	sd	s4,16(sp)
    80004014:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004016:	04451703          	lh	a4,68(a0)
    8000401a:	4785                	li	a5,1
    8000401c:	00f71a63          	bne	a4,a5,80004030 <dirlookup+0x2a>
    80004020:	892a                	mv	s2,a0
    80004022:	89ae                	mv	s3,a1
    80004024:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004026:	457c                	lw	a5,76(a0)
    80004028:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000402a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000402c:	e79d                	bnez	a5,8000405a <dirlookup+0x54>
    8000402e:	a8a5                	j	800040a6 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004030:	00003517          	auipc	a0,0x3
    80004034:	72850513          	addi	a0,a0,1832 # 80007758 <userret+0x6c8>
    80004038:	ffffc097          	auipc	ra,0xffffc
    8000403c:	516080e7          	jalr	1302(ra) # 8000054e <panic>
      panic("dirlookup read");
    80004040:	00003517          	auipc	a0,0x3
    80004044:	73050513          	addi	a0,a0,1840 # 80007770 <userret+0x6e0>
    80004048:	ffffc097          	auipc	ra,0xffffc
    8000404c:	506080e7          	jalr	1286(ra) # 8000054e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004050:	24c1                	addiw	s1,s1,16
    80004052:	04c92783          	lw	a5,76(s2)
    80004056:	04f4f763          	bgeu	s1,a5,800040a4 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000405a:	4741                	li	a4,16
    8000405c:	86a6                	mv	a3,s1
    8000405e:	fc040613          	addi	a2,s0,-64
    80004062:	4581                	li	a1,0
    80004064:	854a                	mv	a0,s2
    80004066:	00000097          	auipc	ra,0x0
    8000406a:	d78080e7          	jalr	-648(ra) # 80003dde <readi>
    8000406e:	47c1                	li	a5,16
    80004070:	fcf518e3          	bne	a0,a5,80004040 <dirlookup+0x3a>
    if(de.inum == 0)
    80004074:	fc045783          	lhu	a5,-64(s0)
    80004078:	dfe1                	beqz	a5,80004050 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000407a:	fc240593          	addi	a1,s0,-62
    8000407e:	854e                	mv	a0,s3
    80004080:	00000097          	auipc	ra,0x0
    80004084:	f6c080e7          	jalr	-148(ra) # 80003fec <namecmp>
    80004088:	f561                	bnez	a0,80004050 <dirlookup+0x4a>
      if(poff)
    8000408a:	000a0463          	beqz	s4,80004092 <dirlookup+0x8c>
        *poff = off;
    8000408e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004092:	fc045583          	lhu	a1,-64(s0)
    80004096:	00092503          	lw	a0,0(s2)
    8000409a:	fffff097          	auipc	ra,0xfffff
    8000409e:	780080e7          	jalr	1920(ra) # 8000381a <iget>
    800040a2:	a011                	j	800040a6 <dirlookup+0xa0>
  return 0;
    800040a4:	4501                	li	a0,0
}
    800040a6:	70e2                	ld	ra,56(sp)
    800040a8:	7442                	ld	s0,48(sp)
    800040aa:	74a2                	ld	s1,40(sp)
    800040ac:	7902                	ld	s2,32(sp)
    800040ae:	69e2                	ld	s3,24(sp)
    800040b0:	6a42                	ld	s4,16(sp)
    800040b2:	6121                	addi	sp,sp,64
    800040b4:	8082                	ret

00000000800040b6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800040b6:	711d                	addi	sp,sp,-96
    800040b8:	ec86                	sd	ra,88(sp)
    800040ba:	e8a2                	sd	s0,80(sp)
    800040bc:	e4a6                	sd	s1,72(sp)
    800040be:	e0ca                	sd	s2,64(sp)
    800040c0:	fc4e                	sd	s3,56(sp)
    800040c2:	f852                	sd	s4,48(sp)
    800040c4:	f456                	sd	s5,40(sp)
    800040c6:	f05a                	sd	s6,32(sp)
    800040c8:	ec5e                	sd	s7,24(sp)
    800040ca:	e862                	sd	s8,16(sp)
    800040cc:	e466                	sd	s9,8(sp)
    800040ce:	1080                	addi	s0,sp,96
    800040d0:	84aa                	mv	s1,a0
    800040d2:	8b2e                	mv	s6,a1
    800040d4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800040d6:	00054703          	lbu	a4,0(a0)
    800040da:	02f00793          	li	a5,47
    800040de:	02f70363          	beq	a4,a5,80004104 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800040e2:	ffffe097          	auipc	ra,0xffffe
    800040e6:	926080e7          	jalr	-1754(ra) # 80001a08 <myproc>
    800040ea:	14053503          	ld	a0,320(a0)
    800040ee:	00000097          	auipc	ra,0x0
    800040f2:	a22080e7          	jalr	-1502(ra) # 80003b10 <idup>
    800040f6:	89aa                	mv	s3,a0
  while(*path == '/')
    800040f8:	02f00913          	li	s2,47
  len = path - s;
    800040fc:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800040fe:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004100:	4c05                	li	s8,1
    80004102:	a865                	j	800041ba <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80004104:	4585                	li	a1,1
    80004106:	4505                	li	a0,1
    80004108:	fffff097          	auipc	ra,0xfffff
    8000410c:	712080e7          	jalr	1810(ra) # 8000381a <iget>
    80004110:	89aa                	mv	s3,a0
    80004112:	b7dd                	j	800040f8 <namex+0x42>
      iunlockput(ip);
    80004114:	854e                	mv	a0,s3
    80004116:	00000097          	auipc	ra,0x0
    8000411a:	c76080e7          	jalr	-906(ra) # 80003d8c <iunlockput>
      return 0;
    8000411e:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004120:	854e                	mv	a0,s3
    80004122:	60e6                	ld	ra,88(sp)
    80004124:	6446                	ld	s0,80(sp)
    80004126:	64a6                	ld	s1,72(sp)
    80004128:	6906                	ld	s2,64(sp)
    8000412a:	79e2                	ld	s3,56(sp)
    8000412c:	7a42                	ld	s4,48(sp)
    8000412e:	7aa2                	ld	s5,40(sp)
    80004130:	7b02                	ld	s6,32(sp)
    80004132:	6be2                	ld	s7,24(sp)
    80004134:	6c42                	ld	s8,16(sp)
    80004136:	6ca2                	ld	s9,8(sp)
    80004138:	6125                	addi	sp,sp,96
    8000413a:	8082                	ret
      iunlock(ip);
    8000413c:	854e                	mv	a0,s3
    8000413e:	00000097          	auipc	ra,0x0
    80004142:	ad2080e7          	jalr	-1326(ra) # 80003c10 <iunlock>
      return ip;
    80004146:	bfe9                	j	80004120 <namex+0x6a>
      iunlockput(ip);
    80004148:	854e                	mv	a0,s3
    8000414a:	00000097          	auipc	ra,0x0
    8000414e:	c42080e7          	jalr	-958(ra) # 80003d8c <iunlockput>
      return 0;
    80004152:	89d2                	mv	s3,s4
    80004154:	b7f1                	j	80004120 <namex+0x6a>
  len = path - s;
    80004156:	40b48633          	sub	a2,s1,a1
    8000415a:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000415e:	094cd463          	bge	s9,s4,800041e6 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80004162:	4639                	li	a2,14
    80004164:	8556                	mv	a0,s5
    80004166:	ffffd097          	auipc	ra,0xffffd
    8000416a:	a68080e7          	jalr	-1432(ra) # 80000bce <memmove>
  while(*path == '/')
    8000416e:	0004c783          	lbu	a5,0(s1)
    80004172:	01279763          	bne	a5,s2,80004180 <namex+0xca>
    path++;
    80004176:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004178:	0004c783          	lbu	a5,0(s1)
    8000417c:	ff278de3          	beq	a5,s2,80004176 <namex+0xc0>
    ilock(ip);
    80004180:	854e                	mv	a0,s3
    80004182:	00000097          	auipc	ra,0x0
    80004186:	9cc080e7          	jalr	-1588(ra) # 80003b4e <ilock>
    if(ip->type != T_DIR){
    8000418a:	04499783          	lh	a5,68(s3)
    8000418e:	f98793e3          	bne	a5,s8,80004114 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80004192:	000b0563          	beqz	s6,8000419c <namex+0xe6>
    80004196:	0004c783          	lbu	a5,0(s1)
    8000419a:	d3cd                	beqz	a5,8000413c <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000419c:	865e                	mv	a2,s7
    8000419e:	85d6                	mv	a1,s5
    800041a0:	854e                	mv	a0,s3
    800041a2:	00000097          	auipc	ra,0x0
    800041a6:	e64080e7          	jalr	-412(ra) # 80004006 <dirlookup>
    800041aa:	8a2a                	mv	s4,a0
    800041ac:	dd51                	beqz	a0,80004148 <namex+0x92>
    iunlockput(ip);
    800041ae:	854e                	mv	a0,s3
    800041b0:	00000097          	auipc	ra,0x0
    800041b4:	bdc080e7          	jalr	-1060(ra) # 80003d8c <iunlockput>
    ip = next;
    800041b8:	89d2                	mv	s3,s4
  while(*path == '/')
    800041ba:	0004c783          	lbu	a5,0(s1)
    800041be:	05279763          	bne	a5,s2,8000420c <namex+0x156>
    path++;
    800041c2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800041c4:	0004c783          	lbu	a5,0(s1)
    800041c8:	ff278de3          	beq	a5,s2,800041c2 <namex+0x10c>
  if(*path == 0)
    800041cc:	c79d                	beqz	a5,800041fa <namex+0x144>
    path++;
    800041ce:	85a6                	mv	a1,s1
  len = path - s;
    800041d0:	8a5e                	mv	s4,s7
    800041d2:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800041d4:	01278963          	beq	a5,s2,800041e6 <namex+0x130>
    800041d8:	dfbd                	beqz	a5,80004156 <namex+0xa0>
    path++;
    800041da:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800041dc:	0004c783          	lbu	a5,0(s1)
    800041e0:	ff279ce3          	bne	a5,s2,800041d8 <namex+0x122>
    800041e4:	bf8d                	j	80004156 <namex+0xa0>
    memmove(name, s, len);
    800041e6:	2601                	sext.w	a2,a2
    800041e8:	8556                	mv	a0,s5
    800041ea:	ffffd097          	auipc	ra,0xffffd
    800041ee:	9e4080e7          	jalr	-1564(ra) # 80000bce <memmove>
    name[len] = 0;
    800041f2:	9a56                	add	s4,s4,s5
    800041f4:	000a0023          	sb	zero,0(s4)
    800041f8:	bf9d                	j	8000416e <namex+0xb8>
  if(nameiparent){
    800041fa:	f20b03e3          	beqz	s6,80004120 <namex+0x6a>
    iput(ip);
    800041fe:	854e                	mv	a0,s3
    80004200:	00000097          	auipc	ra,0x0
    80004204:	a5c080e7          	jalr	-1444(ra) # 80003c5c <iput>
    return 0;
    80004208:	4981                	li	s3,0
    8000420a:	bf19                	j	80004120 <namex+0x6a>
  if(*path == 0)
    8000420c:	d7fd                	beqz	a5,800041fa <namex+0x144>
  while(*path != '/' && *path != 0)
    8000420e:	0004c783          	lbu	a5,0(s1)
    80004212:	85a6                	mv	a1,s1
    80004214:	b7d1                	j	800041d8 <namex+0x122>

0000000080004216 <dirlink>:
{
    80004216:	7139                	addi	sp,sp,-64
    80004218:	fc06                	sd	ra,56(sp)
    8000421a:	f822                	sd	s0,48(sp)
    8000421c:	f426                	sd	s1,40(sp)
    8000421e:	f04a                	sd	s2,32(sp)
    80004220:	ec4e                	sd	s3,24(sp)
    80004222:	e852                	sd	s4,16(sp)
    80004224:	0080                	addi	s0,sp,64
    80004226:	892a                	mv	s2,a0
    80004228:	8a2e                	mv	s4,a1
    8000422a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000422c:	4601                	li	a2,0
    8000422e:	00000097          	auipc	ra,0x0
    80004232:	dd8080e7          	jalr	-552(ra) # 80004006 <dirlookup>
    80004236:	e93d                	bnez	a0,800042ac <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004238:	04c92483          	lw	s1,76(s2)
    8000423c:	c49d                	beqz	s1,8000426a <dirlink+0x54>
    8000423e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004240:	4741                	li	a4,16
    80004242:	86a6                	mv	a3,s1
    80004244:	fc040613          	addi	a2,s0,-64
    80004248:	4581                	li	a1,0
    8000424a:	854a                	mv	a0,s2
    8000424c:	00000097          	auipc	ra,0x0
    80004250:	b92080e7          	jalr	-1134(ra) # 80003dde <readi>
    80004254:	47c1                	li	a5,16
    80004256:	06f51163          	bne	a0,a5,800042b8 <dirlink+0xa2>
    if(de.inum == 0)
    8000425a:	fc045783          	lhu	a5,-64(s0)
    8000425e:	c791                	beqz	a5,8000426a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004260:	24c1                	addiw	s1,s1,16
    80004262:	04c92783          	lw	a5,76(s2)
    80004266:	fcf4ede3          	bltu	s1,a5,80004240 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000426a:	4639                	li	a2,14
    8000426c:	85d2                	mv	a1,s4
    8000426e:	fc240513          	addi	a0,s0,-62
    80004272:	ffffd097          	auipc	ra,0xffffd
    80004276:	a14080e7          	jalr	-1516(ra) # 80000c86 <strncpy>
  de.inum = inum;
    8000427a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000427e:	4741                	li	a4,16
    80004280:	86a6                	mv	a3,s1
    80004282:	fc040613          	addi	a2,s0,-64
    80004286:	4581                	li	a1,0
    80004288:	854a                	mv	a0,s2
    8000428a:	00000097          	auipc	ra,0x0
    8000428e:	c48080e7          	jalr	-952(ra) # 80003ed2 <writei>
    80004292:	872a                	mv	a4,a0
    80004294:	47c1                	li	a5,16
  return 0;
    80004296:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004298:	02f71863          	bne	a4,a5,800042c8 <dirlink+0xb2>
}
    8000429c:	70e2                	ld	ra,56(sp)
    8000429e:	7442                	ld	s0,48(sp)
    800042a0:	74a2                	ld	s1,40(sp)
    800042a2:	7902                	ld	s2,32(sp)
    800042a4:	69e2                	ld	s3,24(sp)
    800042a6:	6a42                	ld	s4,16(sp)
    800042a8:	6121                	addi	sp,sp,64
    800042aa:	8082                	ret
    iput(ip);
    800042ac:	00000097          	auipc	ra,0x0
    800042b0:	9b0080e7          	jalr	-1616(ra) # 80003c5c <iput>
    return -1;
    800042b4:	557d                	li	a0,-1
    800042b6:	b7dd                	j	8000429c <dirlink+0x86>
      panic("dirlink read");
    800042b8:	00003517          	auipc	a0,0x3
    800042bc:	4c850513          	addi	a0,a0,1224 # 80007780 <userret+0x6f0>
    800042c0:	ffffc097          	auipc	ra,0xffffc
    800042c4:	28e080e7          	jalr	654(ra) # 8000054e <panic>
    panic("dirlink");
    800042c8:	00003517          	auipc	a0,0x3
    800042cc:	5d850513          	addi	a0,a0,1496 # 800078a0 <userret+0x810>
    800042d0:	ffffc097          	auipc	ra,0xffffc
    800042d4:	27e080e7          	jalr	638(ra) # 8000054e <panic>

00000000800042d8 <namei>:

struct inode*
namei(char *path)
{
    800042d8:	1101                	addi	sp,sp,-32
    800042da:	ec06                	sd	ra,24(sp)
    800042dc:	e822                	sd	s0,16(sp)
    800042de:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800042e0:	fe040613          	addi	a2,s0,-32
    800042e4:	4581                	li	a1,0
    800042e6:	00000097          	auipc	ra,0x0
    800042ea:	dd0080e7          	jalr	-560(ra) # 800040b6 <namex>
}
    800042ee:	60e2                	ld	ra,24(sp)
    800042f0:	6442                	ld	s0,16(sp)
    800042f2:	6105                	addi	sp,sp,32
    800042f4:	8082                	ret

00000000800042f6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800042f6:	1141                	addi	sp,sp,-16
    800042f8:	e406                	sd	ra,8(sp)
    800042fa:	e022                	sd	s0,0(sp)
    800042fc:	0800                	addi	s0,sp,16
    800042fe:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004300:	4585                	li	a1,1
    80004302:	00000097          	auipc	ra,0x0
    80004306:	db4080e7          	jalr	-588(ra) # 800040b6 <namex>
}
    8000430a:	60a2                	ld	ra,8(sp)
    8000430c:	6402                	ld	s0,0(sp)
    8000430e:	0141                	addi	sp,sp,16
    80004310:	8082                	ret

0000000080004312 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004312:	1101                	addi	sp,sp,-32
    80004314:	ec06                	sd	ra,24(sp)
    80004316:	e822                	sd	s0,16(sp)
    80004318:	e426                	sd	s1,8(sp)
    8000431a:	e04a                	sd	s2,0(sp)
    8000431c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000431e:	0001e917          	auipc	s2,0x1e
    80004322:	89290913          	addi	s2,s2,-1902 # 80021bb0 <log>
    80004326:	01892583          	lw	a1,24(s2)
    8000432a:	02892503          	lw	a0,40(s2)
    8000432e:	fffff097          	auipc	ra,0xfffff
    80004332:	01e080e7          	jalr	30(ra) # 8000334c <bread>
    80004336:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004338:	02c92683          	lw	a3,44(s2)
    8000433c:	d134                	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000433e:	02d05763          	blez	a3,8000436c <write_head+0x5a>
    80004342:	0001e797          	auipc	a5,0x1e
    80004346:	89e78793          	addi	a5,a5,-1890 # 80021be0 <log+0x30>
    8000434a:	06450713          	addi	a4,a0,100
    8000434e:	36fd                	addiw	a3,a3,-1
    80004350:	1682                	slli	a3,a3,0x20
    80004352:	9281                	srli	a3,a3,0x20
    80004354:	068a                	slli	a3,a3,0x2
    80004356:	0001e617          	auipc	a2,0x1e
    8000435a:	88e60613          	addi	a2,a2,-1906 # 80021be4 <log+0x34>
    8000435e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004360:	4390                	lw	a2,0(a5)
    80004362:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004364:	0791                	addi	a5,a5,4
    80004366:	0711                	addi	a4,a4,4
    80004368:	fed79ce3          	bne	a5,a3,80004360 <write_head+0x4e>
  }
  bwrite(buf);
    8000436c:	8526                	mv	a0,s1
    8000436e:	fffff097          	auipc	ra,0xfffff
    80004372:	0d0080e7          	jalr	208(ra) # 8000343e <bwrite>
  brelse(buf);
    80004376:	8526                	mv	a0,s1
    80004378:	fffff097          	auipc	ra,0xfffff
    8000437c:	104080e7          	jalr	260(ra) # 8000347c <brelse>
}
    80004380:	60e2                	ld	ra,24(sp)
    80004382:	6442                	ld	s0,16(sp)
    80004384:	64a2                	ld	s1,8(sp)
    80004386:	6902                	ld	s2,0(sp)
    80004388:	6105                	addi	sp,sp,32
    8000438a:	8082                	ret

000000008000438c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000438c:	0001e797          	auipc	a5,0x1e
    80004390:	8507a783          	lw	a5,-1968(a5) # 80021bdc <log+0x2c>
    80004394:	0af05663          	blez	a5,80004440 <install_trans+0xb4>
{
    80004398:	7139                	addi	sp,sp,-64
    8000439a:	fc06                	sd	ra,56(sp)
    8000439c:	f822                	sd	s0,48(sp)
    8000439e:	f426                	sd	s1,40(sp)
    800043a0:	f04a                	sd	s2,32(sp)
    800043a2:	ec4e                	sd	s3,24(sp)
    800043a4:	e852                	sd	s4,16(sp)
    800043a6:	e456                	sd	s5,8(sp)
    800043a8:	0080                	addi	s0,sp,64
    800043aa:	0001ea97          	auipc	s5,0x1e
    800043ae:	836a8a93          	addi	s5,s5,-1994 # 80021be0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800043b2:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800043b4:	0001d997          	auipc	s3,0x1d
    800043b8:	7fc98993          	addi	s3,s3,2044 # 80021bb0 <log>
    800043bc:	0189a583          	lw	a1,24(s3)
    800043c0:	014585bb          	addw	a1,a1,s4
    800043c4:	2585                	addiw	a1,a1,1
    800043c6:	0289a503          	lw	a0,40(s3)
    800043ca:	fffff097          	auipc	ra,0xfffff
    800043ce:	f82080e7          	jalr	-126(ra) # 8000334c <bread>
    800043d2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800043d4:	000aa583          	lw	a1,0(s5)
    800043d8:	0289a503          	lw	a0,40(s3)
    800043dc:	fffff097          	auipc	ra,0xfffff
    800043e0:	f70080e7          	jalr	-144(ra) # 8000334c <bread>
    800043e4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800043e6:	40000613          	li	a2,1024
    800043ea:	06090593          	addi	a1,s2,96
    800043ee:	06050513          	addi	a0,a0,96
    800043f2:	ffffc097          	auipc	ra,0xffffc
    800043f6:	7dc080e7          	jalr	2012(ra) # 80000bce <memmove>
    bwrite(dbuf);  // write dst to disk
    800043fa:	8526                	mv	a0,s1
    800043fc:	fffff097          	auipc	ra,0xfffff
    80004400:	042080e7          	jalr	66(ra) # 8000343e <bwrite>
    bunpin(dbuf);
    80004404:	8526                	mv	a0,s1
    80004406:	fffff097          	auipc	ra,0xfffff
    8000440a:	150080e7          	jalr	336(ra) # 80003556 <bunpin>
    brelse(lbuf);
    8000440e:	854a                	mv	a0,s2
    80004410:	fffff097          	auipc	ra,0xfffff
    80004414:	06c080e7          	jalr	108(ra) # 8000347c <brelse>
    brelse(dbuf);
    80004418:	8526                	mv	a0,s1
    8000441a:	fffff097          	auipc	ra,0xfffff
    8000441e:	062080e7          	jalr	98(ra) # 8000347c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004422:	2a05                	addiw	s4,s4,1
    80004424:	0a91                	addi	s5,s5,4
    80004426:	02c9a783          	lw	a5,44(s3)
    8000442a:	f8fa49e3          	blt	s4,a5,800043bc <install_trans+0x30>
}
    8000442e:	70e2                	ld	ra,56(sp)
    80004430:	7442                	ld	s0,48(sp)
    80004432:	74a2                	ld	s1,40(sp)
    80004434:	7902                	ld	s2,32(sp)
    80004436:	69e2                	ld	s3,24(sp)
    80004438:	6a42                	ld	s4,16(sp)
    8000443a:	6aa2                	ld	s5,8(sp)
    8000443c:	6121                	addi	sp,sp,64
    8000443e:	8082                	ret
    80004440:	8082                	ret

0000000080004442 <initlog>:
{
    80004442:	7179                	addi	sp,sp,-48
    80004444:	f406                	sd	ra,40(sp)
    80004446:	f022                	sd	s0,32(sp)
    80004448:	ec26                	sd	s1,24(sp)
    8000444a:	e84a                	sd	s2,16(sp)
    8000444c:	e44e                	sd	s3,8(sp)
    8000444e:	1800                	addi	s0,sp,48
    80004450:	892a                	mv	s2,a0
    80004452:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004454:	0001d497          	auipc	s1,0x1d
    80004458:	75c48493          	addi	s1,s1,1884 # 80021bb0 <log>
    8000445c:	00003597          	auipc	a1,0x3
    80004460:	33458593          	addi	a1,a1,820 # 80007790 <userret+0x700>
    80004464:	8526                	mv	a0,s1
    80004466:	ffffc097          	auipc	ra,0xffffc
    8000446a:	55a080e7          	jalr	1370(ra) # 800009c0 <initlock>
  log.start = sb->logstart;
    8000446e:	0149a583          	lw	a1,20(s3)
    80004472:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004474:	0109a783          	lw	a5,16(s3)
    80004478:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000447a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000447e:	854a                	mv	a0,s2
    80004480:	fffff097          	auipc	ra,0xfffff
    80004484:	ecc080e7          	jalr	-308(ra) # 8000334c <bread>
  log.lh.n = lh->n;
    80004488:	513c                	lw	a5,96(a0)
    8000448a:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000448c:	02f05563          	blez	a5,800044b6 <initlog+0x74>
    80004490:	06450713          	addi	a4,a0,100
    80004494:	0001d697          	auipc	a3,0x1d
    80004498:	74c68693          	addi	a3,a3,1868 # 80021be0 <log+0x30>
    8000449c:	37fd                	addiw	a5,a5,-1
    8000449e:	1782                	slli	a5,a5,0x20
    800044a0:	9381                	srli	a5,a5,0x20
    800044a2:	078a                	slli	a5,a5,0x2
    800044a4:	06850613          	addi	a2,a0,104
    800044a8:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800044aa:	4310                	lw	a2,0(a4)
    800044ac:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800044ae:	0711                	addi	a4,a4,4
    800044b0:	0691                	addi	a3,a3,4
    800044b2:	fef71ce3          	bne	a4,a5,800044aa <initlog+0x68>
  brelse(buf);
    800044b6:	fffff097          	auipc	ra,0xfffff
    800044ba:	fc6080e7          	jalr	-58(ra) # 8000347c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    800044be:	00000097          	auipc	ra,0x0
    800044c2:	ece080e7          	jalr	-306(ra) # 8000438c <install_trans>
  log.lh.n = 0;
    800044c6:	0001d797          	auipc	a5,0x1d
    800044ca:	7007ab23          	sw	zero,1814(a5) # 80021bdc <log+0x2c>
  write_head(); // clear the log
    800044ce:	00000097          	auipc	ra,0x0
    800044d2:	e44080e7          	jalr	-444(ra) # 80004312 <write_head>
}
    800044d6:	70a2                	ld	ra,40(sp)
    800044d8:	7402                	ld	s0,32(sp)
    800044da:	64e2                	ld	s1,24(sp)
    800044dc:	6942                	ld	s2,16(sp)
    800044de:	69a2                	ld	s3,8(sp)
    800044e0:	6145                	addi	sp,sp,48
    800044e2:	8082                	ret

00000000800044e4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800044e4:	1101                	addi	sp,sp,-32
    800044e6:	ec06                	sd	ra,24(sp)
    800044e8:	e822                	sd	s0,16(sp)
    800044ea:	e426                	sd	s1,8(sp)
    800044ec:	e04a                	sd	s2,0(sp)
    800044ee:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800044f0:	0001d517          	auipc	a0,0x1d
    800044f4:	6c050513          	addi	a0,a0,1728 # 80021bb0 <log>
    800044f8:	ffffc097          	auipc	ra,0xffffc
    800044fc:	5da080e7          	jalr	1498(ra) # 80000ad2 <acquire>
  while(1){
    if(log.committing){
    80004500:	0001d497          	auipc	s1,0x1d
    80004504:	6b048493          	addi	s1,s1,1712 # 80021bb0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004508:	4979                	li	s2,30
    8000450a:	a039                	j	80004518 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000450c:	85a6                	mv	a1,s1
    8000450e:	8526                	mv	a0,s1
    80004510:	ffffe097          	auipc	ra,0xffffe
    80004514:	130080e7          	jalr	304(ra) # 80002640 <sleep>
    if(log.committing){
    80004518:	50dc                	lw	a5,36(s1)
    8000451a:	fbed                	bnez	a5,8000450c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000451c:	509c                	lw	a5,32(s1)
    8000451e:	0017871b          	addiw	a4,a5,1
    80004522:	0007069b          	sext.w	a3,a4
    80004526:	0027179b          	slliw	a5,a4,0x2
    8000452a:	9fb9                	addw	a5,a5,a4
    8000452c:	0017979b          	slliw	a5,a5,0x1
    80004530:	54d8                	lw	a4,44(s1)
    80004532:	9fb9                	addw	a5,a5,a4
    80004534:	00f95963          	bge	s2,a5,80004546 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004538:	85a6                	mv	a1,s1
    8000453a:	8526                	mv	a0,s1
    8000453c:	ffffe097          	auipc	ra,0xffffe
    80004540:	104080e7          	jalr	260(ra) # 80002640 <sleep>
    80004544:	bfd1                	j	80004518 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004546:	0001d517          	auipc	a0,0x1d
    8000454a:	66a50513          	addi	a0,a0,1642 # 80021bb0 <log>
    8000454e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004550:	ffffc097          	auipc	ra,0xffffc
    80004554:	5d6080e7          	jalr	1494(ra) # 80000b26 <release>
      break;
    }
  }
}
    80004558:	60e2                	ld	ra,24(sp)
    8000455a:	6442                	ld	s0,16(sp)
    8000455c:	64a2                	ld	s1,8(sp)
    8000455e:	6902                	ld	s2,0(sp)
    80004560:	6105                	addi	sp,sp,32
    80004562:	8082                	ret

0000000080004564 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004564:	7139                	addi	sp,sp,-64
    80004566:	fc06                	sd	ra,56(sp)
    80004568:	f822                	sd	s0,48(sp)
    8000456a:	f426                	sd	s1,40(sp)
    8000456c:	f04a                	sd	s2,32(sp)
    8000456e:	ec4e                	sd	s3,24(sp)
    80004570:	e852                	sd	s4,16(sp)
    80004572:	e456                	sd	s5,8(sp)
    80004574:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004576:	0001d497          	auipc	s1,0x1d
    8000457a:	63a48493          	addi	s1,s1,1594 # 80021bb0 <log>
    8000457e:	8526                	mv	a0,s1
    80004580:	ffffc097          	auipc	ra,0xffffc
    80004584:	552080e7          	jalr	1362(ra) # 80000ad2 <acquire>
  log.outstanding -= 1;
    80004588:	509c                	lw	a5,32(s1)
    8000458a:	37fd                	addiw	a5,a5,-1
    8000458c:	0007891b          	sext.w	s2,a5
    80004590:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004592:	50dc                	lw	a5,36(s1)
    80004594:	efb9                	bnez	a5,800045f2 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004596:	06091663          	bnez	s2,80004602 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000459a:	0001d497          	auipc	s1,0x1d
    8000459e:	61648493          	addi	s1,s1,1558 # 80021bb0 <log>
    800045a2:	4785                	li	a5,1
    800045a4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800045a6:	8526                	mv	a0,s1
    800045a8:	ffffc097          	auipc	ra,0xffffc
    800045ac:	57e080e7          	jalr	1406(ra) # 80000b26 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800045b0:	54dc                	lw	a5,44(s1)
    800045b2:	06f04763          	bgtz	a5,80004620 <end_op+0xbc>
    acquire(&log.lock);
    800045b6:	0001d497          	auipc	s1,0x1d
    800045ba:	5fa48493          	addi	s1,s1,1530 # 80021bb0 <log>
    800045be:	8526                	mv	a0,s1
    800045c0:	ffffc097          	auipc	ra,0xffffc
    800045c4:	512080e7          	jalr	1298(ra) # 80000ad2 <acquire>
    log.committing = 0;
    800045c8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800045cc:	8526                	mv	a0,s1
    800045ce:	ffffe097          	auipc	ra,0xffffe
    800045d2:	26e080e7          	jalr	622(ra) # 8000283c <wakeup>
    release(&log.lock);
    800045d6:	8526                	mv	a0,s1
    800045d8:	ffffc097          	auipc	ra,0xffffc
    800045dc:	54e080e7          	jalr	1358(ra) # 80000b26 <release>
}
    800045e0:	70e2                	ld	ra,56(sp)
    800045e2:	7442                	ld	s0,48(sp)
    800045e4:	74a2                	ld	s1,40(sp)
    800045e6:	7902                	ld	s2,32(sp)
    800045e8:	69e2                	ld	s3,24(sp)
    800045ea:	6a42                	ld	s4,16(sp)
    800045ec:	6aa2                	ld	s5,8(sp)
    800045ee:	6121                	addi	sp,sp,64
    800045f0:	8082                	ret
    panic("log.committing");
    800045f2:	00003517          	auipc	a0,0x3
    800045f6:	1a650513          	addi	a0,a0,422 # 80007798 <userret+0x708>
    800045fa:	ffffc097          	auipc	ra,0xffffc
    800045fe:	f54080e7          	jalr	-172(ra) # 8000054e <panic>
    wakeup(&log);
    80004602:	0001d497          	auipc	s1,0x1d
    80004606:	5ae48493          	addi	s1,s1,1454 # 80021bb0 <log>
    8000460a:	8526                	mv	a0,s1
    8000460c:	ffffe097          	auipc	ra,0xffffe
    80004610:	230080e7          	jalr	560(ra) # 8000283c <wakeup>
  release(&log.lock);
    80004614:	8526                	mv	a0,s1
    80004616:	ffffc097          	auipc	ra,0xffffc
    8000461a:	510080e7          	jalr	1296(ra) # 80000b26 <release>
  if(do_commit){
    8000461e:	b7c9                	j	800045e0 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004620:	0001da97          	auipc	s5,0x1d
    80004624:	5c0a8a93          	addi	s5,s5,1472 # 80021be0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004628:	0001da17          	auipc	s4,0x1d
    8000462c:	588a0a13          	addi	s4,s4,1416 # 80021bb0 <log>
    80004630:	018a2583          	lw	a1,24(s4)
    80004634:	012585bb          	addw	a1,a1,s2
    80004638:	2585                	addiw	a1,a1,1
    8000463a:	028a2503          	lw	a0,40(s4)
    8000463e:	fffff097          	auipc	ra,0xfffff
    80004642:	d0e080e7          	jalr	-754(ra) # 8000334c <bread>
    80004646:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004648:	000aa583          	lw	a1,0(s5)
    8000464c:	028a2503          	lw	a0,40(s4)
    80004650:	fffff097          	auipc	ra,0xfffff
    80004654:	cfc080e7          	jalr	-772(ra) # 8000334c <bread>
    80004658:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000465a:	40000613          	li	a2,1024
    8000465e:	06050593          	addi	a1,a0,96
    80004662:	06048513          	addi	a0,s1,96
    80004666:	ffffc097          	auipc	ra,0xffffc
    8000466a:	568080e7          	jalr	1384(ra) # 80000bce <memmove>
    bwrite(to);  // write the log
    8000466e:	8526                	mv	a0,s1
    80004670:	fffff097          	auipc	ra,0xfffff
    80004674:	dce080e7          	jalr	-562(ra) # 8000343e <bwrite>
    brelse(from);
    80004678:	854e                	mv	a0,s3
    8000467a:	fffff097          	auipc	ra,0xfffff
    8000467e:	e02080e7          	jalr	-510(ra) # 8000347c <brelse>
    brelse(to);
    80004682:	8526                	mv	a0,s1
    80004684:	fffff097          	auipc	ra,0xfffff
    80004688:	df8080e7          	jalr	-520(ra) # 8000347c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000468c:	2905                	addiw	s2,s2,1
    8000468e:	0a91                	addi	s5,s5,4
    80004690:	02ca2783          	lw	a5,44(s4)
    80004694:	f8f94ee3          	blt	s2,a5,80004630 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004698:	00000097          	auipc	ra,0x0
    8000469c:	c7a080e7          	jalr	-902(ra) # 80004312 <write_head>
    install_trans(); // Now install writes to home locations
    800046a0:	00000097          	auipc	ra,0x0
    800046a4:	cec080e7          	jalr	-788(ra) # 8000438c <install_trans>
    log.lh.n = 0;
    800046a8:	0001d797          	auipc	a5,0x1d
    800046ac:	5207aa23          	sw	zero,1332(a5) # 80021bdc <log+0x2c>
    write_head();    // Erase the transaction from the log
    800046b0:	00000097          	auipc	ra,0x0
    800046b4:	c62080e7          	jalr	-926(ra) # 80004312 <write_head>
    800046b8:	bdfd                	j	800045b6 <end_op+0x52>

00000000800046ba <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800046ba:	1101                	addi	sp,sp,-32
    800046bc:	ec06                	sd	ra,24(sp)
    800046be:	e822                	sd	s0,16(sp)
    800046c0:	e426                	sd	s1,8(sp)
    800046c2:	e04a                	sd	s2,0(sp)
    800046c4:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800046c6:	0001d717          	auipc	a4,0x1d
    800046ca:	51672703          	lw	a4,1302(a4) # 80021bdc <log+0x2c>
    800046ce:	47f5                	li	a5,29
    800046d0:	08e7c063          	blt	a5,a4,80004750 <log_write+0x96>
    800046d4:	84aa                	mv	s1,a0
    800046d6:	0001d797          	auipc	a5,0x1d
    800046da:	4f67a783          	lw	a5,1270(a5) # 80021bcc <log+0x1c>
    800046de:	37fd                	addiw	a5,a5,-1
    800046e0:	06f75863          	bge	a4,a5,80004750 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800046e4:	0001d797          	auipc	a5,0x1d
    800046e8:	4ec7a783          	lw	a5,1260(a5) # 80021bd0 <log+0x20>
    800046ec:	06f05a63          	blez	a5,80004760 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    800046f0:	0001d917          	auipc	s2,0x1d
    800046f4:	4c090913          	addi	s2,s2,1216 # 80021bb0 <log>
    800046f8:	854a                	mv	a0,s2
    800046fa:	ffffc097          	auipc	ra,0xffffc
    800046fe:	3d8080e7          	jalr	984(ra) # 80000ad2 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    80004702:	02c92603          	lw	a2,44(s2)
    80004706:	06c05563          	blez	a2,80004770 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    8000470a:	44cc                	lw	a1,12(s1)
    8000470c:	0001d717          	auipc	a4,0x1d
    80004710:	4d470713          	addi	a4,a4,1236 # 80021be0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004714:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004716:	4314                	lw	a3,0(a4)
    80004718:	04b68d63          	beq	a3,a1,80004772 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    8000471c:	2785                	addiw	a5,a5,1
    8000471e:	0711                	addi	a4,a4,4
    80004720:	fec79be3          	bne	a5,a2,80004716 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004724:	0621                	addi	a2,a2,8
    80004726:	060a                	slli	a2,a2,0x2
    80004728:	0001d797          	auipc	a5,0x1d
    8000472c:	48878793          	addi	a5,a5,1160 # 80021bb0 <log>
    80004730:	963e                	add	a2,a2,a5
    80004732:	44dc                	lw	a5,12(s1)
    80004734:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004736:	8526                	mv	a0,s1
    80004738:	fffff097          	auipc	ra,0xfffff
    8000473c:	de2080e7          	jalr	-542(ra) # 8000351a <bpin>
    log.lh.n++;
    80004740:	0001d717          	auipc	a4,0x1d
    80004744:	47070713          	addi	a4,a4,1136 # 80021bb0 <log>
    80004748:	575c                	lw	a5,44(a4)
    8000474a:	2785                	addiw	a5,a5,1
    8000474c:	d75c                	sw	a5,44(a4)
    8000474e:	a83d                	j	8000478c <log_write+0xd2>
    panic("too big a transaction");
    80004750:	00003517          	auipc	a0,0x3
    80004754:	05850513          	addi	a0,a0,88 # 800077a8 <userret+0x718>
    80004758:	ffffc097          	auipc	ra,0xffffc
    8000475c:	df6080e7          	jalr	-522(ra) # 8000054e <panic>
    panic("log_write outside of trans");
    80004760:	00003517          	auipc	a0,0x3
    80004764:	06050513          	addi	a0,a0,96 # 800077c0 <userret+0x730>
    80004768:	ffffc097          	auipc	ra,0xffffc
    8000476c:	de6080e7          	jalr	-538(ra) # 8000054e <panic>
  for (i = 0; i < log.lh.n; i++) {
    80004770:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    80004772:	00878713          	addi	a4,a5,8
    80004776:	00271693          	slli	a3,a4,0x2
    8000477a:	0001d717          	auipc	a4,0x1d
    8000477e:	43670713          	addi	a4,a4,1078 # 80021bb0 <log>
    80004782:	9736                	add	a4,a4,a3
    80004784:	44d4                	lw	a3,12(s1)
    80004786:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004788:	faf607e3          	beq	a2,a5,80004736 <log_write+0x7c>
  }
  release(&log.lock);
    8000478c:	0001d517          	auipc	a0,0x1d
    80004790:	42450513          	addi	a0,a0,1060 # 80021bb0 <log>
    80004794:	ffffc097          	auipc	ra,0xffffc
    80004798:	392080e7          	jalr	914(ra) # 80000b26 <release>
}
    8000479c:	60e2                	ld	ra,24(sp)
    8000479e:	6442                	ld	s0,16(sp)
    800047a0:	64a2                	ld	s1,8(sp)
    800047a2:	6902                	ld	s2,0(sp)
    800047a4:	6105                	addi	sp,sp,32
    800047a6:	8082                	ret

00000000800047a8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800047a8:	1101                	addi	sp,sp,-32
    800047aa:	ec06                	sd	ra,24(sp)
    800047ac:	e822                	sd	s0,16(sp)
    800047ae:	e426                	sd	s1,8(sp)
    800047b0:	e04a                	sd	s2,0(sp)
    800047b2:	1000                	addi	s0,sp,32
    800047b4:	84aa                	mv	s1,a0
    800047b6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800047b8:	00003597          	auipc	a1,0x3
    800047bc:	02858593          	addi	a1,a1,40 # 800077e0 <userret+0x750>
    800047c0:	0521                	addi	a0,a0,8
    800047c2:	ffffc097          	auipc	ra,0xffffc
    800047c6:	1fe080e7          	jalr	510(ra) # 800009c0 <initlock>
  lk->name = name;
    800047ca:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800047ce:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800047d2:	0204a423          	sw	zero,40(s1)
}
    800047d6:	60e2                	ld	ra,24(sp)
    800047d8:	6442                	ld	s0,16(sp)
    800047da:	64a2                	ld	s1,8(sp)
    800047dc:	6902                	ld	s2,0(sp)
    800047de:	6105                	addi	sp,sp,32
    800047e0:	8082                	ret

00000000800047e2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800047e2:	1101                	addi	sp,sp,-32
    800047e4:	ec06                	sd	ra,24(sp)
    800047e6:	e822                	sd	s0,16(sp)
    800047e8:	e426                	sd	s1,8(sp)
    800047ea:	e04a                	sd	s2,0(sp)
    800047ec:	1000                	addi	s0,sp,32
    800047ee:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800047f0:	00850913          	addi	s2,a0,8
    800047f4:	854a                	mv	a0,s2
    800047f6:	ffffc097          	auipc	ra,0xffffc
    800047fa:	2dc080e7          	jalr	732(ra) # 80000ad2 <acquire>
  while (lk->locked) {
    800047fe:	409c                	lw	a5,0(s1)
    80004800:	cb89                	beqz	a5,80004812 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004802:	85ca                	mv	a1,s2
    80004804:	8526                	mv	a0,s1
    80004806:	ffffe097          	auipc	ra,0xffffe
    8000480a:	e3a080e7          	jalr	-454(ra) # 80002640 <sleep>
  while (lk->locked) {
    8000480e:	409c                	lw	a5,0(s1)
    80004810:	fbed                	bnez	a5,80004802 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004812:	4785                	li	a5,1
    80004814:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004816:	ffffd097          	auipc	ra,0xffffd
    8000481a:	1f2080e7          	jalr	498(ra) # 80001a08 <myproc>
    8000481e:	511c                	lw	a5,32(a0)
    80004820:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004822:	854a                	mv	a0,s2
    80004824:	ffffc097          	auipc	ra,0xffffc
    80004828:	302080e7          	jalr	770(ra) # 80000b26 <release>
}
    8000482c:	60e2                	ld	ra,24(sp)
    8000482e:	6442                	ld	s0,16(sp)
    80004830:	64a2                	ld	s1,8(sp)
    80004832:	6902                	ld	s2,0(sp)
    80004834:	6105                	addi	sp,sp,32
    80004836:	8082                	ret

0000000080004838 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004838:	1101                	addi	sp,sp,-32
    8000483a:	ec06                	sd	ra,24(sp)
    8000483c:	e822                	sd	s0,16(sp)
    8000483e:	e426                	sd	s1,8(sp)
    80004840:	e04a                	sd	s2,0(sp)
    80004842:	1000                	addi	s0,sp,32
    80004844:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004846:	00850913          	addi	s2,a0,8
    8000484a:	854a                	mv	a0,s2
    8000484c:	ffffc097          	auipc	ra,0xffffc
    80004850:	286080e7          	jalr	646(ra) # 80000ad2 <acquire>
  lk->locked = 0;
    80004854:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004858:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000485c:	8526                	mv	a0,s1
    8000485e:	ffffe097          	auipc	ra,0xffffe
    80004862:	fde080e7          	jalr	-34(ra) # 8000283c <wakeup>
  release(&lk->lk);
    80004866:	854a                	mv	a0,s2
    80004868:	ffffc097          	auipc	ra,0xffffc
    8000486c:	2be080e7          	jalr	702(ra) # 80000b26 <release>
}
    80004870:	60e2                	ld	ra,24(sp)
    80004872:	6442                	ld	s0,16(sp)
    80004874:	64a2                	ld	s1,8(sp)
    80004876:	6902                	ld	s2,0(sp)
    80004878:	6105                	addi	sp,sp,32
    8000487a:	8082                	ret

000000008000487c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000487c:	7179                	addi	sp,sp,-48
    8000487e:	f406                	sd	ra,40(sp)
    80004880:	f022                	sd	s0,32(sp)
    80004882:	ec26                	sd	s1,24(sp)
    80004884:	e84a                	sd	s2,16(sp)
    80004886:	e44e                	sd	s3,8(sp)
    80004888:	1800                	addi	s0,sp,48
    8000488a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000488c:	00850913          	addi	s2,a0,8
    80004890:	854a                	mv	a0,s2
    80004892:	ffffc097          	auipc	ra,0xffffc
    80004896:	240080e7          	jalr	576(ra) # 80000ad2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000489a:	409c                	lw	a5,0(s1)
    8000489c:	ef99                	bnez	a5,800048ba <holdingsleep+0x3e>
    8000489e:	4481                	li	s1,0
  release(&lk->lk);
    800048a0:	854a                	mv	a0,s2
    800048a2:	ffffc097          	auipc	ra,0xffffc
    800048a6:	284080e7          	jalr	644(ra) # 80000b26 <release>
  return r;
}
    800048aa:	8526                	mv	a0,s1
    800048ac:	70a2                	ld	ra,40(sp)
    800048ae:	7402                	ld	s0,32(sp)
    800048b0:	64e2                	ld	s1,24(sp)
    800048b2:	6942                	ld	s2,16(sp)
    800048b4:	69a2                	ld	s3,8(sp)
    800048b6:	6145                	addi	sp,sp,48
    800048b8:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800048ba:	0284a983          	lw	s3,40(s1)
    800048be:	ffffd097          	auipc	ra,0xffffd
    800048c2:	14a080e7          	jalr	330(ra) # 80001a08 <myproc>
    800048c6:	5104                	lw	s1,32(a0)
    800048c8:	413484b3          	sub	s1,s1,s3
    800048cc:	0014b493          	seqz	s1,s1
    800048d0:	bfc1                	j	800048a0 <holdingsleep+0x24>

00000000800048d2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800048d2:	1141                	addi	sp,sp,-16
    800048d4:	e406                	sd	ra,8(sp)
    800048d6:	e022                	sd	s0,0(sp)
    800048d8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800048da:	00003597          	auipc	a1,0x3
    800048de:	f1658593          	addi	a1,a1,-234 # 800077f0 <userret+0x760>
    800048e2:	0001d517          	auipc	a0,0x1d
    800048e6:	41650513          	addi	a0,a0,1046 # 80021cf8 <ftable>
    800048ea:	ffffc097          	auipc	ra,0xffffc
    800048ee:	0d6080e7          	jalr	214(ra) # 800009c0 <initlock>
}
    800048f2:	60a2                	ld	ra,8(sp)
    800048f4:	6402                	ld	s0,0(sp)
    800048f6:	0141                	addi	sp,sp,16
    800048f8:	8082                	ret

00000000800048fa <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800048fa:	1101                	addi	sp,sp,-32
    800048fc:	ec06                	sd	ra,24(sp)
    800048fe:	e822                	sd	s0,16(sp)
    80004900:	e426                	sd	s1,8(sp)
    80004902:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004904:	0001d517          	auipc	a0,0x1d
    80004908:	3f450513          	addi	a0,a0,1012 # 80021cf8 <ftable>
    8000490c:	ffffc097          	auipc	ra,0xffffc
    80004910:	1c6080e7          	jalr	454(ra) # 80000ad2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004914:	0001d497          	auipc	s1,0x1d
    80004918:	3fc48493          	addi	s1,s1,1020 # 80021d10 <ftable+0x18>
    8000491c:	0001e717          	auipc	a4,0x1e
    80004920:	39470713          	addi	a4,a4,916 # 80022cb0 <ftable+0xfb8>
    if(f->ref == 0){
    80004924:	40dc                	lw	a5,4(s1)
    80004926:	cf99                	beqz	a5,80004944 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004928:	02848493          	addi	s1,s1,40
    8000492c:	fee49ce3          	bne	s1,a4,80004924 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004930:	0001d517          	auipc	a0,0x1d
    80004934:	3c850513          	addi	a0,a0,968 # 80021cf8 <ftable>
    80004938:	ffffc097          	auipc	ra,0xffffc
    8000493c:	1ee080e7          	jalr	494(ra) # 80000b26 <release>
  return 0;
    80004940:	4481                	li	s1,0
    80004942:	a819                	j	80004958 <filealloc+0x5e>
      f->ref = 1;
    80004944:	4785                	li	a5,1
    80004946:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004948:	0001d517          	auipc	a0,0x1d
    8000494c:	3b050513          	addi	a0,a0,944 # 80021cf8 <ftable>
    80004950:	ffffc097          	auipc	ra,0xffffc
    80004954:	1d6080e7          	jalr	470(ra) # 80000b26 <release>
}
    80004958:	8526                	mv	a0,s1
    8000495a:	60e2                	ld	ra,24(sp)
    8000495c:	6442                	ld	s0,16(sp)
    8000495e:	64a2                	ld	s1,8(sp)
    80004960:	6105                	addi	sp,sp,32
    80004962:	8082                	ret

0000000080004964 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004964:	1101                	addi	sp,sp,-32
    80004966:	ec06                	sd	ra,24(sp)
    80004968:	e822                	sd	s0,16(sp)
    8000496a:	e426                	sd	s1,8(sp)
    8000496c:	1000                	addi	s0,sp,32
    8000496e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004970:	0001d517          	auipc	a0,0x1d
    80004974:	38850513          	addi	a0,a0,904 # 80021cf8 <ftable>
    80004978:	ffffc097          	auipc	ra,0xffffc
    8000497c:	15a080e7          	jalr	346(ra) # 80000ad2 <acquire>
  if(f->ref < 1)
    80004980:	40dc                	lw	a5,4(s1)
    80004982:	02f05263          	blez	a5,800049a6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004986:	2785                	addiw	a5,a5,1
    80004988:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000498a:	0001d517          	auipc	a0,0x1d
    8000498e:	36e50513          	addi	a0,a0,878 # 80021cf8 <ftable>
    80004992:	ffffc097          	auipc	ra,0xffffc
    80004996:	194080e7          	jalr	404(ra) # 80000b26 <release>
  return f;
}
    8000499a:	8526                	mv	a0,s1
    8000499c:	60e2                	ld	ra,24(sp)
    8000499e:	6442                	ld	s0,16(sp)
    800049a0:	64a2                	ld	s1,8(sp)
    800049a2:	6105                	addi	sp,sp,32
    800049a4:	8082                	ret
    panic("filedup");
    800049a6:	00003517          	auipc	a0,0x3
    800049aa:	e5250513          	addi	a0,a0,-430 # 800077f8 <userret+0x768>
    800049ae:	ffffc097          	auipc	ra,0xffffc
    800049b2:	ba0080e7          	jalr	-1120(ra) # 8000054e <panic>

00000000800049b6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800049b6:	7139                	addi	sp,sp,-64
    800049b8:	fc06                	sd	ra,56(sp)
    800049ba:	f822                	sd	s0,48(sp)
    800049bc:	f426                	sd	s1,40(sp)
    800049be:	f04a                	sd	s2,32(sp)
    800049c0:	ec4e                	sd	s3,24(sp)
    800049c2:	e852                	sd	s4,16(sp)
    800049c4:	e456                	sd	s5,8(sp)
    800049c6:	0080                	addi	s0,sp,64
    800049c8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800049ca:	0001d517          	auipc	a0,0x1d
    800049ce:	32e50513          	addi	a0,a0,814 # 80021cf8 <ftable>
    800049d2:	ffffc097          	auipc	ra,0xffffc
    800049d6:	100080e7          	jalr	256(ra) # 80000ad2 <acquire>
  if(f->ref < 1)
    800049da:	40dc                	lw	a5,4(s1)
    800049dc:	06f05163          	blez	a5,80004a3e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800049e0:	37fd                	addiw	a5,a5,-1
    800049e2:	0007871b          	sext.w	a4,a5
    800049e6:	c0dc                	sw	a5,4(s1)
    800049e8:	06e04363          	bgtz	a4,80004a4e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800049ec:	0004a903          	lw	s2,0(s1)
    800049f0:	0094ca83          	lbu	s5,9(s1)
    800049f4:	0104ba03          	ld	s4,16(s1)
    800049f8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800049fc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004a00:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004a04:	0001d517          	auipc	a0,0x1d
    80004a08:	2f450513          	addi	a0,a0,756 # 80021cf8 <ftable>
    80004a0c:	ffffc097          	auipc	ra,0xffffc
    80004a10:	11a080e7          	jalr	282(ra) # 80000b26 <release>

  if(ff.type == FD_PIPE){
    80004a14:	4785                	li	a5,1
    80004a16:	04f90d63          	beq	s2,a5,80004a70 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004a1a:	3979                	addiw	s2,s2,-2
    80004a1c:	4785                	li	a5,1
    80004a1e:	0527e063          	bltu	a5,s2,80004a5e <fileclose+0xa8>
    begin_op();
    80004a22:	00000097          	auipc	ra,0x0
    80004a26:	ac2080e7          	jalr	-1342(ra) # 800044e4 <begin_op>
    iput(ff.ip);
    80004a2a:	854e                	mv	a0,s3
    80004a2c:	fffff097          	auipc	ra,0xfffff
    80004a30:	230080e7          	jalr	560(ra) # 80003c5c <iput>
    end_op();
    80004a34:	00000097          	auipc	ra,0x0
    80004a38:	b30080e7          	jalr	-1232(ra) # 80004564 <end_op>
    80004a3c:	a00d                	j	80004a5e <fileclose+0xa8>
    panic("fileclose");
    80004a3e:	00003517          	auipc	a0,0x3
    80004a42:	dc250513          	addi	a0,a0,-574 # 80007800 <userret+0x770>
    80004a46:	ffffc097          	auipc	ra,0xffffc
    80004a4a:	b08080e7          	jalr	-1272(ra) # 8000054e <panic>
    release(&ftable.lock);
    80004a4e:	0001d517          	auipc	a0,0x1d
    80004a52:	2aa50513          	addi	a0,a0,682 # 80021cf8 <ftable>
    80004a56:	ffffc097          	auipc	ra,0xffffc
    80004a5a:	0d0080e7          	jalr	208(ra) # 80000b26 <release>
  }
}
    80004a5e:	70e2                	ld	ra,56(sp)
    80004a60:	7442                	ld	s0,48(sp)
    80004a62:	74a2                	ld	s1,40(sp)
    80004a64:	7902                	ld	s2,32(sp)
    80004a66:	69e2                	ld	s3,24(sp)
    80004a68:	6a42                	ld	s4,16(sp)
    80004a6a:	6aa2                	ld	s5,8(sp)
    80004a6c:	6121                	addi	sp,sp,64
    80004a6e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004a70:	85d6                	mv	a1,s5
    80004a72:	8552                	mv	a0,s4
    80004a74:	00000097          	auipc	ra,0x0
    80004a78:	372080e7          	jalr	882(ra) # 80004de6 <pipeclose>
    80004a7c:	b7cd                	j	80004a5e <fileclose+0xa8>

0000000080004a7e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004a7e:	715d                	addi	sp,sp,-80
    80004a80:	e486                	sd	ra,72(sp)
    80004a82:	e0a2                	sd	s0,64(sp)
    80004a84:	fc26                	sd	s1,56(sp)
    80004a86:	f84a                	sd	s2,48(sp)
    80004a88:	f44e                	sd	s3,40(sp)
    80004a8a:	0880                	addi	s0,sp,80
    80004a8c:	84aa                	mv	s1,a0
    80004a8e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004a90:	ffffd097          	auipc	ra,0xffffd
    80004a94:	f78080e7          	jalr	-136(ra) # 80001a08 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004a98:	409c                	lw	a5,0(s1)
    80004a9a:	37f9                	addiw	a5,a5,-2
    80004a9c:	4705                	li	a4,1
    80004a9e:	04f76763          	bltu	a4,a5,80004aec <filestat+0x6e>
    80004aa2:	892a                	mv	s2,a0
    ilock(f->ip);
    80004aa4:	6c88                	ld	a0,24(s1)
    80004aa6:	fffff097          	auipc	ra,0xfffff
    80004aaa:	0a8080e7          	jalr	168(ra) # 80003b4e <ilock>
    stati(f->ip, &st);
    80004aae:	fb840593          	addi	a1,s0,-72
    80004ab2:	6c88                	ld	a0,24(s1)
    80004ab4:	fffff097          	auipc	ra,0xfffff
    80004ab8:	300080e7          	jalr	768(ra) # 80003db4 <stati>
    iunlock(f->ip);
    80004abc:	6c88                	ld	a0,24(s1)
    80004abe:	fffff097          	auipc	ra,0xfffff
    80004ac2:	152080e7          	jalr	338(ra) # 80003c10 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004ac6:	46e1                	li	a3,24
    80004ac8:	fb840613          	addi	a2,s0,-72
    80004acc:	85ce                	mv	a1,s3
    80004ace:	04093503          	ld	a0,64(s2)
    80004ad2:	ffffd097          	auipc	ra,0xffffd
    80004ad6:	c24080e7          	jalr	-988(ra) # 800016f6 <copyout>
    80004ada:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004ade:	60a6                	ld	ra,72(sp)
    80004ae0:	6406                	ld	s0,64(sp)
    80004ae2:	74e2                	ld	s1,56(sp)
    80004ae4:	7942                	ld	s2,48(sp)
    80004ae6:	79a2                	ld	s3,40(sp)
    80004ae8:	6161                	addi	sp,sp,80
    80004aea:	8082                	ret
  return -1;
    80004aec:	557d                	li	a0,-1
    80004aee:	bfc5                	j	80004ade <filestat+0x60>

0000000080004af0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004af0:	7179                	addi	sp,sp,-48
    80004af2:	f406                	sd	ra,40(sp)
    80004af4:	f022                	sd	s0,32(sp)
    80004af6:	ec26                	sd	s1,24(sp)
    80004af8:	e84a                	sd	s2,16(sp)
    80004afa:	e44e                	sd	s3,8(sp)
    80004afc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004afe:	00854783          	lbu	a5,8(a0)
    80004b02:	c3d5                	beqz	a5,80004ba6 <fileread+0xb6>
    80004b04:	84aa                	mv	s1,a0
    80004b06:	89ae                	mv	s3,a1
    80004b08:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004b0a:	411c                	lw	a5,0(a0)
    80004b0c:	4705                	li	a4,1
    80004b0e:	04e78963          	beq	a5,a4,80004b60 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004b12:	470d                	li	a4,3
    80004b14:	04e78d63          	beq	a5,a4,80004b6e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004b18:	4709                	li	a4,2
    80004b1a:	06e79e63          	bne	a5,a4,80004b96 <fileread+0xa6>
    ilock(f->ip);
    80004b1e:	6d08                	ld	a0,24(a0)
    80004b20:	fffff097          	auipc	ra,0xfffff
    80004b24:	02e080e7          	jalr	46(ra) # 80003b4e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004b28:	874a                	mv	a4,s2
    80004b2a:	5094                	lw	a3,32(s1)
    80004b2c:	864e                	mv	a2,s3
    80004b2e:	4585                	li	a1,1
    80004b30:	6c88                	ld	a0,24(s1)
    80004b32:	fffff097          	auipc	ra,0xfffff
    80004b36:	2ac080e7          	jalr	684(ra) # 80003dde <readi>
    80004b3a:	892a                	mv	s2,a0
    80004b3c:	00a05563          	blez	a0,80004b46 <fileread+0x56>
      f->off += r;
    80004b40:	509c                	lw	a5,32(s1)
    80004b42:	9fa9                	addw	a5,a5,a0
    80004b44:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004b46:	6c88                	ld	a0,24(s1)
    80004b48:	fffff097          	auipc	ra,0xfffff
    80004b4c:	0c8080e7          	jalr	200(ra) # 80003c10 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004b50:	854a                	mv	a0,s2
    80004b52:	70a2                	ld	ra,40(sp)
    80004b54:	7402                	ld	s0,32(sp)
    80004b56:	64e2                	ld	s1,24(sp)
    80004b58:	6942                	ld	s2,16(sp)
    80004b5a:	69a2                	ld	s3,8(sp)
    80004b5c:	6145                	addi	sp,sp,48
    80004b5e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004b60:	6908                	ld	a0,16(a0)
    80004b62:	00000097          	auipc	ra,0x0
    80004b66:	408080e7          	jalr	1032(ra) # 80004f6a <piperead>
    80004b6a:	892a                	mv	s2,a0
    80004b6c:	b7d5                	j	80004b50 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004b6e:	02451783          	lh	a5,36(a0)
    80004b72:	03079693          	slli	a3,a5,0x30
    80004b76:	92c1                	srli	a3,a3,0x30
    80004b78:	4725                	li	a4,9
    80004b7a:	02d76863          	bltu	a4,a3,80004baa <fileread+0xba>
    80004b7e:	0792                	slli	a5,a5,0x4
    80004b80:	0001d717          	auipc	a4,0x1d
    80004b84:	0d870713          	addi	a4,a4,216 # 80021c58 <devsw>
    80004b88:	97ba                	add	a5,a5,a4
    80004b8a:	639c                	ld	a5,0(a5)
    80004b8c:	c38d                	beqz	a5,80004bae <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004b8e:	4505                	li	a0,1
    80004b90:	9782                	jalr	a5
    80004b92:	892a                	mv	s2,a0
    80004b94:	bf75                	j	80004b50 <fileread+0x60>
    panic("fileread");
    80004b96:	00003517          	auipc	a0,0x3
    80004b9a:	c7a50513          	addi	a0,a0,-902 # 80007810 <userret+0x780>
    80004b9e:	ffffc097          	auipc	ra,0xffffc
    80004ba2:	9b0080e7          	jalr	-1616(ra) # 8000054e <panic>
    return -1;
    80004ba6:	597d                	li	s2,-1
    80004ba8:	b765                	j	80004b50 <fileread+0x60>
      return -1;
    80004baa:	597d                	li	s2,-1
    80004bac:	b755                	j	80004b50 <fileread+0x60>
    80004bae:	597d                	li	s2,-1
    80004bb0:	b745                	j	80004b50 <fileread+0x60>

0000000080004bb2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004bb2:	00954783          	lbu	a5,9(a0)
    80004bb6:	14078563          	beqz	a5,80004d00 <filewrite+0x14e>
{
    80004bba:	715d                	addi	sp,sp,-80
    80004bbc:	e486                	sd	ra,72(sp)
    80004bbe:	e0a2                	sd	s0,64(sp)
    80004bc0:	fc26                	sd	s1,56(sp)
    80004bc2:	f84a                	sd	s2,48(sp)
    80004bc4:	f44e                	sd	s3,40(sp)
    80004bc6:	f052                	sd	s4,32(sp)
    80004bc8:	ec56                	sd	s5,24(sp)
    80004bca:	e85a                	sd	s6,16(sp)
    80004bcc:	e45e                	sd	s7,8(sp)
    80004bce:	e062                	sd	s8,0(sp)
    80004bd0:	0880                	addi	s0,sp,80
    80004bd2:	892a                	mv	s2,a0
    80004bd4:	8aae                	mv	s5,a1
    80004bd6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004bd8:	411c                	lw	a5,0(a0)
    80004bda:	4705                	li	a4,1
    80004bdc:	02e78263          	beq	a5,a4,80004c00 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004be0:	470d                	li	a4,3
    80004be2:	02e78563          	beq	a5,a4,80004c0c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004be6:	4709                	li	a4,2
    80004be8:	10e79463          	bne	a5,a4,80004cf0 <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004bec:	0ec05e63          	blez	a2,80004ce8 <filewrite+0x136>
    int i = 0;
    80004bf0:	4981                	li	s3,0
    80004bf2:	6b05                	lui	s6,0x1
    80004bf4:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004bf8:	6b85                	lui	s7,0x1
    80004bfa:	c00b8b9b          	addiw	s7,s7,-1024
    80004bfe:	a851                	j	80004c92 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004c00:	6908                	ld	a0,16(a0)
    80004c02:	00000097          	auipc	ra,0x0
    80004c06:	254080e7          	jalr	596(ra) # 80004e56 <pipewrite>
    80004c0a:	a85d                	j	80004cc0 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004c0c:	02451783          	lh	a5,36(a0)
    80004c10:	03079693          	slli	a3,a5,0x30
    80004c14:	92c1                	srli	a3,a3,0x30
    80004c16:	4725                	li	a4,9
    80004c18:	0ed76663          	bltu	a4,a3,80004d04 <filewrite+0x152>
    80004c1c:	0792                	slli	a5,a5,0x4
    80004c1e:	0001d717          	auipc	a4,0x1d
    80004c22:	03a70713          	addi	a4,a4,58 # 80021c58 <devsw>
    80004c26:	97ba                	add	a5,a5,a4
    80004c28:	679c                	ld	a5,8(a5)
    80004c2a:	cff9                	beqz	a5,80004d08 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004c2c:	4505                	li	a0,1
    80004c2e:	9782                	jalr	a5
    80004c30:	a841                	j	80004cc0 <filewrite+0x10e>
    80004c32:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004c36:	00000097          	auipc	ra,0x0
    80004c3a:	8ae080e7          	jalr	-1874(ra) # 800044e4 <begin_op>
      ilock(f->ip);
    80004c3e:	01893503          	ld	a0,24(s2)
    80004c42:	fffff097          	auipc	ra,0xfffff
    80004c46:	f0c080e7          	jalr	-244(ra) # 80003b4e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004c4a:	8762                	mv	a4,s8
    80004c4c:	02092683          	lw	a3,32(s2)
    80004c50:	01598633          	add	a2,s3,s5
    80004c54:	4585                	li	a1,1
    80004c56:	01893503          	ld	a0,24(s2)
    80004c5a:	fffff097          	auipc	ra,0xfffff
    80004c5e:	278080e7          	jalr	632(ra) # 80003ed2 <writei>
    80004c62:	84aa                	mv	s1,a0
    80004c64:	02a05f63          	blez	a0,80004ca2 <filewrite+0xf0>
        f->off += r;
    80004c68:	02092783          	lw	a5,32(s2)
    80004c6c:	9fa9                	addw	a5,a5,a0
    80004c6e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004c72:	01893503          	ld	a0,24(s2)
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	f9a080e7          	jalr	-102(ra) # 80003c10 <iunlock>
      end_op();
    80004c7e:	00000097          	auipc	ra,0x0
    80004c82:	8e6080e7          	jalr	-1818(ra) # 80004564 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004c86:	049c1963          	bne	s8,s1,80004cd8 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004c8a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004c8e:	0349d663          	bge	s3,s4,80004cba <filewrite+0x108>
      int n1 = n - i;
    80004c92:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004c96:	84be                	mv	s1,a5
    80004c98:	2781                	sext.w	a5,a5
    80004c9a:	f8fb5ce3          	bge	s6,a5,80004c32 <filewrite+0x80>
    80004c9e:	84de                	mv	s1,s7
    80004ca0:	bf49                	j	80004c32 <filewrite+0x80>
      iunlock(f->ip);
    80004ca2:	01893503          	ld	a0,24(s2)
    80004ca6:	fffff097          	auipc	ra,0xfffff
    80004caa:	f6a080e7          	jalr	-150(ra) # 80003c10 <iunlock>
      end_op();
    80004cae:	00000097          	auipc	ra,0x0
    80004cb2:	8b6080e7          	jalr	-1866(ra) # 80004564 <end_op>
      if(r < 0)
    80004cb6:	fc04d8e3          	bgez	s1,80004c86 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004cba:	8552                	mv	a0,s4
    80004cbc:	033a1863          	bne	s4,s3,80004cec <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004cc0:	60a6                	ld	ra,72(sp)
    80004cc2:	6406                	ld	s0,64(sp)
    80004cc4:	74e2                	ld	s1,56(sp)
    80004cc6:	7942                	ld	s2,48(sp)
    80004cc8:	79a2                	ld	s3,40(sp)
    80004cca:	7a02                	ld	s4,32(sp)
    80004ccc:	6ae2                	ld	s5,24(sp)
    80004cce:	6b42                	ld	s6,16(sp)
    80004cd0:	6ba2                	ld	s7,8(sp)
    80004cd2:	6c02                	ld	s8,0(sp)
    80004cd4:	6161                	addi	sp,sp,80
    80004cd6:	8082                	ret
        panic("short filewrite");
    80004cd8:	00003517          	auipc	a0,0x3
    80004cdc:	b4850513          	addi	a0,a0,-1208 # 80007820 <userret+0x790>
    80004ce0:	ffffc097          	auipc	ra,0xffffc
    80004ce4:	86e080e7          	jalr	-1938(ra) # 8000054e <panic>
    int i = 0;
    80004ce8:	4981                	li	s3,0
    80004cea:	bfc1                	j	80004cba <filewrite+0x108>
    ret = (i == n ? n : -1);
    80004cec:	557d                	li	a0,-1
    80004cee:	bfc9                	j	80004cc0 <filewrite+0x10e>
    panic("filewrite");
    80004cf0:	00003517          	auipc	a0,0x3
    80004cf4:	b4050513          	addi	a0,a0,-1216 # 80007830 <userret+0x7a0>
    80004cf8:	ffffc097          	auipc	ra,0xffffc
    80004cfc:	856080e7          	jalr	-1962(ra) # 8000054e <panic>
    return -1;
    80004d00:	557d                	li	a0,-1
}
    80004d02:	8082                	ret
      return -1;
    80004d04:	557d                	li	a0,-1
    80004d06:	bf6d                	j	80004cc0 <filewrite+0x10e>
    80004d08:	557d                	li	a0,-1
    80004d0a:	bf5d                	j	80004cc0 <filewrite+0x10e>

0000000080004d0c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004d0c:	7179                	addi	sp,sp,-48
    80004d0e:	f406                	sd	ra,40(sp)
    80004d10:	f022                	sd	s0,32(sp)
    80004d12:	ec26                	sd	s1,24(sp)
    80004d14:	e84a                	sd	s2,16(sp)
    80004d16:	e44e                	sd	s3,8(sp)
    80004d18:	e052                	sd	s4,0(sp)
    80004d1a:	1800                	addi	s0,sp,48
    80004d1c:	84aa                	mv	s1,a0
    80004d1e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004d20:	0005b023          	sd	zero,0(a1)
    80004d24:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004d28:	00000097          	auipc	ra,0x0
    80004d2c:	bd2080e7          	jalr	-1070(ra) # 800048fa <filealloc>
    80004d30:	e088                	sd	a0,0(s1)
    80004d32:	c551                	beqz	a0,80004dbe <pipealloc+0xb2>
    80004d34:	00000097          	auipc	ra,0x0
    80004d38:	bc6080e7          	jalr	-1082(ra) # 800048fa <filealloc>
    80004d3c:	00aa3023          	sd	a0,0(s4)
    80004d40:	c92d                	beqz	a0,80004db2 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004d42:	ffffc097          	auipc	ra,0xffffc
    80004d46:	c1e080e7          	jalr	-994(ra) # 80000960 <kalloc>
    80004d4a:	892a                	mv	s2,a0
    80004d4c:	c125                	beqz	a0,80004dac <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004d4e:	4985                	li	s3,1
    80004d50:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004d54:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004d58:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004d5c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004d60:	00003597          	auipc	a1,0x3
    80004d64:	ae058593          	addi	a1,a1,-1312 # 80007840 <userret+0x7b0>
    80004d68:	ffffc097          	auipc	ra,0xffffc
    80004d6c:	c58080e7          	jalr	-936(ra) # 800009c0 <initlock>
  (*f0)->type = FD_PIPE;
    80004d70:	609c                	ld	a5,0(s1)
    80004d72:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004d76:	609c                	ld	a5,0(s1)
    80004d78:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004d7c:	609c                	ld	a5,0(s1)
    80004d7e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004d82:	609c                	ld	a5,0(s1)
    80004d84:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004d88:	000a3783          	ld	a5,0(s4)
    80004d8c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004d90:	000a3783          	ld	a5,0(s4)
    80004d94:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004d98:	000a3783          	ld	a5,0(s4)
    80004d9c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004da0:	000a3783          	ld	a5,0(s4)
    80004da4:	0127b823          	sd	s2,16(a5)
  return 0;
    80004da8:	4501                	li	a0,0
    80004daa:	a025                	j	80004dd2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004dac:	6088                	ld	a0,0(s1)
    80004dae:	e501                	bnez	a0,80004db6 <pipealloc+0xaa>
    80004db0:	a039                	j	80004dbe <pipealloc+0xb2>
    80004db2:	6088                	ld	a0,0(s1)
    80004db4:	c51d                	beqz	a0,80004de2 <pipealloc+0xd6>
    fileclose(*f0);
    80004db6:	00000097          	auipc	ra,0x0
    80004dba:	c00080e7          	jalr	-1024(ra) # 800049b6 <fileclose>
  if(*f1)
    80004dbe:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004dc2:	557d                	li	a0,-1
  if(*f1)
    80004dc4:	c799                	beqz	a5,80004dd2 <pipealloc+0xc6>
    fileclose(*f1);
    80004dc6:	853e                	mv	a0,a5
    80004dc8:	00000097          	auipc	ra,0x0
    80004dcc:	bee080e7          	jalr	-1042(ra) # 800049b6 <fileclose>
  return -1;
    80004dd0:	557d                	li	a0,-1
}
    80004dd2:	70a2                	ld	ra,40(sp)
    80004dd4:	7402                	ld	s0,32(sp)
    80004dd6:	64e2                	ld	s1,24(sp)
    80004dd8:	6942                	ld	s2,16(sp)
    80004dda:	69a2                	ld	s3,8(sp)
    80004ddc:	6a02                	ld	s4,0(sp)
    80004dde:	6145                	addi	sp,sp,48
    80004de0:	8082                	ret
  return -1;
    80004de2:	557d                	li	a0,-1
    80004de4:	b7fd                	j	80004dd2 <pipealloc+0xc6>

0000000080004de6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004de6:	1101                	addi	sp,sp,-32
    80004de8:	ec06                	sd	ra,24(sp)
    80004dea:	e822                	sd	s0,16(sp)
    80004dec:	e426                	sd	s1,8(sp)
    80004dee:	e04a                	sd	s2,0(sp)
    80004df0:	1000                	addi	s0,sp,32
    80004df2:	84aa                	mv	s1,a0
    80004df4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004df6:	ffffc097          	auipc	ra,0xffffc
    80004dfa:	cdc080e7          	jalr	-804(ra) # 80000ad2 <acquire>
  if(writable){
    80004dfe:	02090d63          	beqz	s2,80004e38 <pipeclose+0x52>
    pi->writeopen = 0;
    80004e02:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004e06:	21848513          	addi	a0,s1,536
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	a32080e7          	jalr	-1486(ra) # 8000283c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004e12:	2204b783          	ld	a5,544(s1)
    80004e16:	eb95                	bnez	a5,80004e4a <pipeclose+0x64>
    release(&pi->lock);
    80004e18:	8526                	mv	a0,s1
    80004e1a:	ffffc097          	auipc	ra,0xffffc
    80004e1e:	d0c080e7          	jalr	-756(ra) # 80000b26 <release>
    kfree((char*)pi);
    80004e22:	8526                	mv	a0,s1
    80004e24:	ffffc097          	auipc	ra,0xffffc
    80004e28:	a40080e7          	jalr	-1472(ra) # 80000864 <kfree>
  } else
    release(&pi->lock);
}
    80004e2c:	60e2                	ld	ra,24(sp)
    80004e2e:	6442                	ld	s0,16(sp)
    80004e30:	64a2                	ld	s1,8(sp)
    80004e32:	6902                	ld	s2,0(sp)
    80004e34:	6105                	addi	sp,sp,32
    80004e36:	8082                	ret
    pi->readopen = 0;
    80004e38:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004e3c:	21c48513          	addi	a0,s1,540
    80004e40:	ffffe097          	auipc	ra,0xffffe
    80004e44:	9fc080e7          	jalr	-1540(ra) # 8000283c <wakeup>
    80004e48:	b7e9                	j	80004e12 <pipeclose+0x2c>
    release(&pi->lock);
    80004e4a:	8526                	mv	a0,s1
    80004e4c:	ffffc097          	auipc	ra,0xffffc
    80004e50:	cda080e7          	jalr	-806(ra) # 80000b26 <release>
}
    80004e54:	bfe1                	j	80004e2c <pipeclose+0x46>

0000000080004e56 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004e56:	7159                	addi	sp,sp,-112
    80004e58:	f486                	sd	ra,104(sp)
    80004e5a:	f0a2                	sd	s0,96(sp)
    80004e5c:	eca6                	sd	s1,88(sp)
    80004e5e:	e8ca                	sd	s2,80(sp)
    80004e60:	e4ce                	sd	s3,72(sp)
    80004e62:	e0d2                	sd	s4,64(sp)
    80004e64:	fc56                	sd	s5,56(sp)
    80004e66:	f85a                	sd	s6,48(sp)
    80004e68:	f45e                	sd	s7,40(sp)
    80004e6a:	f062                	sd	s8,32(sp)
    80004e6c:	ec66                	sd	s9,24(sp)
    80004e6e:	1880                	addi	s0,sp,112
    80004e70:	84aa                	mv	s1,a0
    80004e72:	8b2e                	mv	s6,a1
    80004e74:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004e76:	ffffd097          	auipc	ra,0xffffd
    80004e7a:	b92080e7          	jalr	-1134(ra) # 80001a08 <myproc>
    80004e7e:	8c2a                	mv	s8,a0

  acquire(&pi->lock);
    80004e80:	8526                	mv	a0,s1
    80004e82:	ffffc097          	auipc	ra,0xffffc
    80004e86:	c50080e7          	jalr	-944(ra) # 80000ad2 <acquire>
  for(i = 0; i < n; i++){
    80004e8a:	0b505063          	blez	s5,80004f2a <pipewrite+0xd4>
    80004e8e:	8926                	mv	s2,s1
    80004e90:	fffa8b9b          	addiw	s7,s5,-1
    80004e94:	1b82                	slli	s7,s7,0x20
    80004e96:	020bdb93          	srli	s7,s7,0x20
    80004e9a:	001b0793          	addi	a5,s6,1
    80004e9e:	9bbe                	add	s7,s7,a5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004ea0:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004ea4:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ea8:	5cfd                	li	s9,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004eaa:	2184a783          	lw	a5,536(s1)
    80004eae:	21c4a703          	lw	a4,540(s1)
    80004eb2:	2007879b          	addiw	a5,a5,512
    80004eb6:	02f71e63          	bne	a4,a5,80004ef2 <pipewrite+0x9c>
      if(pi->readopen == 0 || myproc()->killed){
    80004eba:	2204a783          	lw	a5,544(s1)
    80004ebe:	c3d9                	beqz	a5,80004f44 <pipewrite+0xee>
    80004ec0:	ffffd097          	auipc	ra,0xffffd
    80004ec4:	b48080e7          	jalr	-1208(ra) # 80001a08 <myproc>
    80004ec8:	4d1c                	lw	a5,24(a0)
    80004eca:	efad                	bnez	a5,80004f44 <pipewrite+0xee>
      wakeup(&pi->nread);
    80004ecc:	8552                	mv	a0,s4
    80004ece:	ffffe097          	auipc	ra,0xffffe
    80004ed2:	96e080e7          	jalr	-1682(ra) # 8000283c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004ed6:	85ca                	mv	a1,s2
    80004ed8:	854e                	mv	a0,s3
    80004eda:	ffffd097          	auipc	ra,0xffffd
    80004ede:	766080e7          	jalr	1894(ra) # 80002640 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004ee2:	2184a783          	lw	a5,536(s1)
    80004ee6:	21c4a703          	lw	a4,540(s1)
    80004eea:	2007879b          	addiw	a5,a5,512
    80004eee:	fcf706e3          	beq	a4,a5,80004eba <pipewrite+0x64>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ef2:	4685                	li	a3,1
    80004ef4:	865a                	mv	a2,s6
    80004ef6:	f9f40593          	addi	a1,s0,-97
    80004efa:	040c3503          	ld	a0,64(s8)
    80004efe:	ffffd097          	auipc	ra,0xffffd
    80004f02:	884080e7          	jalr	-1916(ra) # 80001782 <copyin>
    80004f06:	03950263          	beq	a0,s9,80004f2a <pipewrite+0xd4>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004f0a:	21c4a783          	lw	a5,540(s1)
    80004f0e:	0017871b          	addiw	a4,a5,1
    80004f12:	20e4ae23          	sw	a4,540(s1)
    80004f16:	1ff7f793          	andi	a5,a5,511
    80004f1a:	97a6                	add	a5,a5,s1
    80004f1c:	f9f44703          	lbu	a4,-97(s0)
    80004f20:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004f24:	0b05                	addi	s6,s6,1
    80004f26:	f97b12e3          	bne	s6,s7,80004eaa <pipewrite+0x54>
  }
  wakeup(&pi->nread);
    80004f2a:	21848513          	addi	a0,s1,536
    80004f2e:	ffffe097          	auipc	ra,0xffffe
    80004f32:	90e080e7          	jalr	-1778(ra) # 8000283c <wakeup>
  release(&pi->lock);
    80004f36:	8526                	mv	a0,s1
    80004f38:	ffffc097          	auipc	ra,0xffffc
    80004f3c:	bee080e7          	jalr	-1042(ra) # 80000b26 <release>
  return n;
    80004f40:	8556                	mv	a0,s5
    80004f42:	a039                	j	80004f50 <pipewrite+0xfa>
        release(&pi->lock);
    80004f44:	8526                	mv	a0,s1
    80004f46:	ffffc097          	auipc	ra,0xffffc
    80004f4a:	be0080e7          	jalr	-1056(ra) # 80000b26 <release>
        return -1;
    80004f4e:	557d                	li	a0,-1
}
    80004f50:	70a6                	ld	ra,104(sp)
    80004f52:	7406                	ld	s0,96(sp)
    80004f54:	64e6                	ld	s1,88(sp)
    80004f56:	6946                	ld	s2,80(sp)
    80004f58:	69a6                	ld	s3,72(sp)
    80004f5a:	6a06                	ld	s4,64(sp)
    80004f5c:	7ae2                	ld	s5,56(sp)
    80004f5e:	7b42                	ld	s6,48(sp)
    80004f60:	7ba2                	ld	s7,40(sp)
    80004f62:	7c02                	ld	s8,32(sp)
    80004f64:	6ce2                	ld	s9,24(sp)
    80004f66:	6165                	addi	sp,sp,112
    80004f68:	8082                	ret

0000000080004f6a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004f6a:	715d                	addi	sp,sp,-80
    80004f6c:	e486                	sd	ra,72(sp)
    80004f6e:	e0a2                	sd	s0,64(sp)
    80004f70:	fc26                	sd	s1,56(sp)
    80004f72:	f84a                	sd	s2,48(sp)
    80004f74:	f44e                	sd	s3,40(sp)
    80004f76:	f052                	sd	s4,32(sp)
    80004f78:	ec56                	sd	s5,24(sp)
    80004f7a:	e85a                	sd	s6,16(sp)
    80004f7c:	0880                	addi	s0,sp,80
    80004f7e:	84aa                	mv	s1,a0
    80004f80:	892e                	mv	s2,a1
    80004f82:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80004f84:	ffffd097          	auipc	ra,0xffffd
    80004f88:	a84080e7          	jalr	-1404(ra) # 80001a08 <myproc>
    80004f8c:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80004f8e:	8b26                	mv	s6,s1
    80004f90:	8526                	mv	a0,s1
    80004f92:	ffffc097          	auipc	ra,0xffffc
    80004f96:	b40080e7          	jalr	-1216(ra) # 80000ad2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f9a:	2184a703          	lw	a4,536(s1)
    80004f9e:	21c4a783          	lw	a5,540(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004fa2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004fa6:	02f71763          	bne	a4,a5,80004fd4 <piperead+0x6a>
    80004faa:	2244a783          	lw	a5,548(s1)
    80004fae:	c39d                	beqz	a5,80004fd4 <piperead+0x6a>
    if(myproc()->killed){
    80004fb0:	ffffd097          	auipc	ra,0xffffd
    80004fb4:	a58080e7          	jalr	-1448(ra) # 80001a08 <myproc>
    80004fb8:	4d1c                	lw	a5,24(a0)
    80004fba:	ebc1                	bnez	a5,8000504a <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004fbc:	85da                	mv	a1,s6
    80004fbe:	854e                	mv	a0,s3
    80004fc0:	ffffd097          	auipc	ra,0xffffd
    80004fc4:	680080e7          	jalr	1664(ra) # 80002640 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004fc8:	2184a703          	lw	a4,536(s1)
    80004fcc:	21c4a783          	lw	a5,540(s1)
    80004fd0:	fcf70de3          	beq	a4,a5,80004faa <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004fd4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004fd6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004fd8:	05405363          	blez	s4,8000501e <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004fdc:	2184a783          	lw	a5,536(s1)
    80004fe0:	21c4a703          	lw	a4,540(s1)
    80004fe4:	02f70d63          	beq	a4,a5,8000501e <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004fe8:	0017871b          	addiw	a4,a5,1
    80004fec:	20e4ac23          	sw	a4,536(s1)
    80004ff0:	1ff7f793          	andi	a5,a5,511
    80004ff4:	97a6                	add	a5,a5,s1
    80004ff6:	0187c783          	lbu	a5,24(a5)
    80004ffa:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ffe:	4685                	li	a3,1
    80005000:	fbf40613          	addi	a2,s0,-65
    80005004:	85ca                	mv	a1,s2
    80005006:	040ab503          	ld	a0,64(s5)
    8000500a:	ffffc097          	auipc	ra,0xffffc
    8000500e:	6ec080e7          	jalr	1772(ra) # 800016f6 <copyout>
    80005012:	01650663          	beq	a0,s6,8000501e <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005016:	2985                	addiw	s3,s3,1
    80005018:	0905                	addi	s2,s2,1
    8000501a:	fd3a11e3          	bne	s4,s3,80004fdc <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000501e:	21c48513          	addi	a0,s1,540
    80005022:	ffffe097          	auipc	ra,0xffffe
    80005026:	81a080e7          	jalr	-2022(ra) # 8000283c <wakeup>
  release(&pi->lock);
    8000502a:	8526                	mv	a0,s1
    8000502c:	ffffc097          	auipc	ra,0xffffc
    80005030:	afa080e7          	jalr	-1286(ra) # 80000b26 <release>
  return i;
}
    80005034:	854e                	mv	a0,s3
    80005036:	60a6                	ld	ra,72(sp)
    80005038:	6406                	ld	s0,64(sp)
    8000503a:	74e2                	ld	s1,56(sp)
    8000503c:	7942                	ld	s2,48(sp)
    8000503e:	79a2                	ld	s3,40(sp)
    80005040:	7a02                	ld	s4,32(sp)
    80005042:	6ae2                	ld	s5,24(sp)
    80005044:	6b42                	ld	s6,16(sp)
    80005046:	6161                	addi	sp,sp,80
    80005048:	8082                	ret
      release(&pi->lock);
    8000504a:	8526                	mv	a0,s1
    8000504c:	ffffc097          	auipc	ra,0xffffc
    80005050:	ada080e7          	jalr	-1318(ra) # 80000b26 <release>
      return -1;
    80005054:	59fd                	li	s3,-1
    80005056:	bff9                	j	80005034 <piperead+0xca>

0000000080005058 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80005058:	df010113          	addi	sp,sp,-528
    8000505c:	20113423          	sd	ra,520(sp)
    80005060:	20813023          	sd	s0,512(sp)
    80005064:	ffa6                	sd	s1,504(sp)
    80005066:	fbca                	sd	s2,496(sp)
    80005068:	f7ce                	sd	s3,488(sp)
    8000506a:	f3d2                	sd	s4,480(sp)
    8000506c:	efd6                	sd	s5,472(sp)
    8000506e:	ebda                	sd	s6,464(sp)
    80005070:	e7de                	sd	s7,456(sp)
    80005072:	e3e2                	sd	s8,448(sp)
    80005074:	ff66                	sd	s9,440(sp)
    80005076:	fb6a                	sd	s10,432(sp)
    80005078:	f76e                	sd	s11,424(sp)
    8000507a:	0c00                	addi	s0,sp,528
    8000507c:	84aa                	mv	s1,a0
    8000507e:	dea43c23          	sd	a0,-520(s0)
    80005082:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005086:	ffffd097          	auipc	ra,0xffffd
    8000508a:	982080e7          	jalr	-1662(ra) # 80001a08 <myproc>
    8000508e:	892a                	mv	s2,a0

  begin_op();
    80005090:	fffff097          	auipc	ra,0xfffff
    80005094:	454080e7          	jalr	1108(ra) # 800044e4 <begin_op>

  if((ip = namei(path)) == 0){
    80005098:	8526                	mv	a0,s1
    8000509a:	fffff097          	auipc	ra,0xfffff
    8000509e:	23e080e7          	jalr	574(ra) # 800042d8 <namei>
    800050a2:	c92d                	beqz	a0,80005114 <exec+0xbc>
    800050a4:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800050a6:	fffff097          	auipc	ra,0xfffff
    800050aa:	aa8080e7          	jalr	-1368(ra) # 80003b4e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800050ae:	04000713          	li	a4,64
    800050b2:	4681                	li	a3,0
    800050b4:	e4840613          	addi	a2,s0,-440
    800050b8:	4581                	li	a1,0
    800050ba:	8526                	mv	a0,s1
    800050bc:	fffff097          	auipc	ra,0xfffff
    800050c0:	d22080e7          	jalr	-734(ra) # 80003dde <readi>
    800050c4:	04000793          	li	a5,64
    800050c8:	00f51a63          	bne	a0,a5,800050dc <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800050cc:	e4842703          	lw	a4,-440(s0)
    800050d0:	464c47b7          	lui	a5,0x464c4
    800050d4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800050d8:	04f70463          	beq	a4,a5,80005120 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800050dc:	8526                	mv	a0,s1
    800050de:	fffff097          	auipc	ra,0xfffff
    800050e2:	cae080e7          	jalr	-850(ra) # 80003d8c <iunlockput>
    end_op();
    800050e6:	fffff097          	auipc	ra,0xfffff
    800050ea:	47e080e7          	jalr	1150(ra) # 80004564 <end_op>
  }
  return -1;
    800050ee:	557d                	li	a0,-1
}
    800050f0:	20813083          	ld	ra,520(sp)
    800050f4:	20013403          	ld	s0,512(sp)
    800050f8:	74fe                	ld	s1,504(sp)
    800050fa:	795e                	ld	s2,496(sp)
    800050fc:	79be                	ld	s3,488(sp)
    800050fe:	7a1e                	ld	s4,480(sp)
    80005100:	6afe                	ld	s5,472(sp)
    80005102:	6b5e                	ld	s6,464(sp)
    80005104:	6bbe                	ld	s7,456(sp)
    80005106:	6c1e                	ld	s8,448(sp)
    80005108:	7cfa                	ld	s9,440(sp)
    8000510a:	7d5a                	ld	s10,432(sp)
    8000510c:	7dba                	ld	s11,424(sp)
    8000510e:	21010113          	addi	sp,sp,528
    80005112:	8082                	ret
    end_op();
    80005114:	fffff097          	auipc	ra,0xfffff
    80005118:	450080e7          	jalr	1104(ra) # 80004564 <end_op>
    return -1;
    8000511c:	557d                	li	a0,-1
    8000511e:	bfc9                	j	800050f0 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80005120:	854a                	mv	a0,s2
    80005122:	ffffd097          	auipc	ra,0xffffd
    80005126:	9be080e7          	jalr	-1602(ra) # 80001ae0 <proc_pagetable>
    8000512a:	8c2a                	mv	s8,a0
    8000512c:	d945                	beqz	a0,800050dc <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000512e:	e6842983          	lw	s3,-408(s0)
    80005132:	e8045783          	lhu	a5,-384(s0)
    80005136:	c7fd                	beqz	a5,80005224 <exec+0x1cc>
  sz = 0;
    80005138:	e0043423          	sd	zero,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000513c:	4b81                	li	s7,0
    if(ph.vaddr % PGSIZE != 0)
    8000513e:	6b05                	lui	s6,0x1
    80005140:	fffb0793          	addi	a5,s6,-1 # fff <_entry-0x7ffff001>
    80005144:	def43823          	sd	a5,-528(s0)
    80005148:	a0a5                	j	800051b0 <exec+0x158>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000514a:	00002517          	auipc	a0,0x2
    8000514e:	6fe50513          	addi	a0,a0,1790 # 80007848 <userret+0x7b8>
    80005152:	ffffb097          	auipc	ra,0xffffb
    80005156:	3fc080e7          	jalr	1020(ra) # 8000054e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000515a:	8756                	mv	a4,s5
    8000515c:	012d86bb          	addw	a3,s11,s2
    80005160:	4581                	li	a1,0
    80005162:	8526                	mv	a0,s1
    80005164:	fffff097          	auipc	ra,0xfffff
    80005168:	c7a080e7          	jalr	-902(ra) # 80003dde <readi>
    8000516c:	2501                	sext.w	a0,a0
    8000516e:	10aa9163          	bne	s5,a0,80005270 <exec+0x218>
  for(i = 0; i < sz; i += PGSIZE){
    80005172:	6785                	lui	a5,0x1
    80005174:	0127893b          	addw	s2,a5,s2
    80005178:	77fd                	lui	a5,0xfffff
    8000517a:	01478a3b          	addw	s4,a5,s4
    8000517e:	03997263          	bgeu	s2,s9,800051a2 <exec+0x14a>
    pa = walkaddr(pagetable, va + i);
    80005182:	02091593          	slli	a1,s2,0x20
    80005186:	9181                	srli	a1,a1,0x20
    80005188:	95ea                	add	a1,a1,s10
    8000518a:	8562                	mv	a0,s8
    8000518c:	ffffc097          	auipc	ra,0xffffc
    80005190:	f9c080e7          	jalr	-100(ra) # 80001128 <walkaddr>
    80005194:	862a                	mv	a2,a0
    if(pa == 0)
    80005196:	d955                	beqz	a0,8000514a <exec+0xf2>
      n = PGSIZE;
    80005198:	8ada                	mv	s5,s6
    if(sz - i < PGSIZE)
    8000519a:	fd6a70e3          	bgeu	s4,s6,8000515a <exec+0x102>
      n = sz - i;
    8000519e:	8ad2                	mv	s5,s4
    800051a0:	bf6d                	j	8000515a <exec+0x102>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800051a2:	2b85                	addiw	s7,s7,1
    800051a4:	0389899b          	addiw	s3,s3,56
    800051a8:	e8045783          	lhu	a5,-384(s0)
    800051ac:	06fbde63          	bge	s7,a5,80005228 <exec+0x1d0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800051b0:	2981                	sext.w	s3,s3
    800051b2:	03800713          	li	a4,56
    800051b6:	86ce                	mv	a3,s3
    800051b8:	e1040613          	addi	a2,s0,-496
    800051bc:	4581                	li	a1,0
    800051be:	8526                	mv	a0,s1
    800051c0:	fffff097          	auipc	ra,0xfffff
    800051c4:	c1e080e7          	jalr	-994(ra) # 80003dde <readi>
    800051c8:	03800793          	li	a5,56
    800051cc:	0af51263          	bne	a0,a5,80005270 <exec+0x218>
    if(ph.type != ELF_PROG_LOAD)
    800051d0:	e1042783          	lw	a5,-496(s0)
    800051d4:	4705                	li	a4,1
    800051d6:	fce796e3          	bne	a5,a4,800051a2 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    800051da:	e3843603          	ld	a2,-456(s0)
    800051de:	e3043783          	ld	a5,-464(s0)
    800051e2:	08f66763          	bltu	a2,a5,80005270 <exec+0x218>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800051e6:	e2043783          	ld	a5,-480(s0)
    800051ea:	963e                	add	a2,a2,a5
    800051ec:	08f66263          	bltu	a2,a5,80005270 <exec+0x218>
    if((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800051f0:	e0843583          	ld	a1,-504(s0)
    800051f4:	8562                	mv	a0,s8
    800051f6:	ffffc097          	auipc	ra,0xffffc
    800051fa:	326080e7          	jalr	806(ra) # 8000151c <uvmalloc>
    800051fe:	e0a43423          	sd	a0,-504(s0)
    80005202:	c53d                	beqz	a0,80005270 <exec+0x218>
    if(ph.vaddr % PGSIZE != 0)
    80005204:	e2043d03          	ld	s10,-480(s0)
    80005208:	df043783          	ld	a5,-528(s0)
    8000520c:	00fd77b3          	and	a5,s10,a5
    80005210:	e3a5                	bnez	a5,80005270 <exec+0x218>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005212:	e1842d83          	lw	s11,-488(s0)
    80005216:	e3042c83          	lw	s9,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000521a:	f80c84e3          	beqz	s9,800051a2 <exec+0x14a>
    8000521e:	8a66                	mv	s4,s9
    80005220:	4901                	li	s2,0
    80005222:	b785                	j	80005182 <exec+0x12a>
  sz = 0;
    80005224:	e0043423          	sd	zero,-504(s0)
  iunlockput(ip);
    80005228:	8526                	mv	a0,s1
    8000522a:	fffff097          	auipc	ra,0xfffff
    8000522e:	b62080e7          	jalr	-1182(ra) # 80003d8c <iunlockput>
  end_op();
    80005232:	fffff097          	auipc	ra,0xfffff
    80005236:	332080e7          	jalr	818(ra) # 80004564 <end_op>
  p = myproc();
    8000523a:	ffffc097          	auipc	ra,0xffffc
    8000523e:	7ce080e7          	jalr	1998(ra) # 80001a08 <myproc>
    80005242:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80005244:	03853d03          	ld	s10,56(a0)
  sz = PGROUNDUP(sz);
    80005248:	6585                	lui	a1,0x1
    8000524a:	15fd                	addi	a1,a1,-1
    8000524c:	e0843783          	ld	a5,-504(s0)
    80005250:	00b78b33          	add	s6,a5,a1
    80005254:	75fd                	lui	a1,0xfffff
    80005256:	00bb75b3          	and	a1,s6,a1
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000525a:	6609                	lui	a2,0x2
    8000525c:	962e                	add	a2,a2,a1
    8000525e:	8562                	mv	a0,s8
    80005260:	ffffc097          	auipc	ra,0xffffc
    80005264:	2bc080e7          	jalr	700(ra) # 8000151c <uvmalloc>
    80005268:	e0a43423          	sd	a0,-504(s0)
  ip = 0;
    8000526c:	4481                	li	s1,0
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000526e:	ed01                	bnez	a0,80005286 <exec+0x22e>
    proc_freepagetable(pagetable, sz);
    80005270:	e0843583          	ld	a1,-504(s0)
    80005274:	8562                	mv	a0,s8
    80005276:	ffffd097          	auipc	ra,0xffffd
    8000527a:	9ae080e7          	jalr	-1618(ra) # 80001c24 <proc_freepagetable>
  if(ip){
    8000527e:	e4049fe3          	bnez	s1,800050dc <exec+0x84>
  return -1;
    80005282:	557d                	li	a0,-1
    80005284:	b5b5                	j	800050f0 <exec+0x98>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005286:	75f9                	lui	a1,0xffffe
    80005288:	84aa                	mv	s1,a0
    8000528a:	95aa                	add	a1,a1,a0
    8000528c:	8562                	mv	a0,s8
    8000528e:	ffffc097          	auipc	ra,0xffffc
    80005292:	436080e7          	jalr	1078(ra) # 800016c4 <uvmclear>
  stackbase = sp - PGSIZE;
    80005296:	7afd                	lui	s5,0xfffff
    80005298:	9aa6                	add	s5,s5,s1
  for(argc = 0; argv[argc]; argc++) {
    8000529a:	e0043783          	ld	a5,-512(s0)
    8000529e:	6388                	ld	a0,0(a5)
    800052a0:	c135                	beqz	a0,80005304 <exec+0x2ac>
    800052a2:	e8840993          	addi	s3,s0,-376
    800052a6:	f8840c93          	addi	s9,s0,-120
    800052aa:	4901                	li	s2,0
    sp -= strlen(argv[argc]) + 1;
    800052ac:	ffffc097          	auipc	ra,0xffffc
    800052b0:	a4a080e7          	jalr	-1462(ra) # 80000cf6 <strlen>
    800052b4:	2505                	addiw	a0,a0,1
    800052b6:	8c89                	sub	s1,s1,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800052b8:	98c1                	andi	s1,s1,-16
    if(sp < stackbase)
    800052ba:	0f54ea63          	bltu	s1,s5,800053ae <exec+0x356>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800052be:	e0043b03          	ld	s6,-512(s0)
    800052c2:	000b3a03          	ld	s4,0(s6)
    800052c6:	8552                	mv	a0,s4
    800052c8:	ffffc097          	auipc	ra,0xffffc
    800052cc:	a2e080e7          	jalr	-1490(ra) # 80000cf6 <strlen>
    800052d0:	0015069b          	addiw	a3,a0,1
    800052d4:	8652                	mv	a2,s4
    800052d6:	85a6                	mv	a1,s1
    800052d8:	8562                	mv	a0,s8
    800052da:	ffffc097          	auipc	ra,0xffffc
    800052de:	41c080e7          	jalr	1052(ra) # 800016f6 <copyout>
    800052e2:	0c054863          	bltz	a0,800053b2 <exec+0x35a>
    ustack[argc] = sp;
    800052e6:	0099b023          	sd	s1,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800052ea:	0905                	addi	s2,s2,1
    800052ec:	008b0793          	addi	a5,s6,8
    800052f0:	e0f43023          	sd	a5,-512(s0)
    800052f4:	008b3503          	ld	a0,8(s6)
    800052f8:	c909                	beqz	a0,8000530a <exec+0x2b2>
    if(argc >= MAXARG)
    800052fa:	09a1                	addi	s3,s3,8
    800052fc:	fb3c98e3          	bne	s9,s3,800052ac <exec+0x254>
  ip = 0;
    80005300:	4481                	li	s1,0
    80005302:	b7bd                	j	80005270 <exec+0x218>
  sp = sz;
    80005304:	e0843483          	ld	s1,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005308:	4901                	li	s2,0
  ustack[argc] = 0;
    8000530a:	00391793          	slli	a5,s2,0x3
    8000530e:	f9040713          	addi	a4,s0,-112
    80005312:	97ba                	add	a5,a5,a4
    80005314:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd8ed4>
  sp -= (argc+1) * sizeof(uint64);
    80005318:	00190693          	addi	a3,s2,1
    8000531c:	068e                	slli	a3,a3,0x3
    8000531e:	8c95                	sub	s1,s1,a3
  sp -= sp % 16;
    80005320:	ff04f993          	andi	s3,s1,-16
  ip = 0;
    80005324:	4481                	li	s1,0
  if(sp < stackbase)
    80005326:	f559e5e3          	bltu	s3,s5,80005270 <exec+0x218>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000532a:	e8840613          	addi	a2,s0,-376
    8000532e:	85ce                	mv	a1,s3
    80005330:	8562                	mv	a0,s8
    80005332:	ffffc097          	auipc	ra,0xffffc
    80005336:	3c4080e7          	jalr	964(ra) # 800016f6 <copyout>
    8000533a:	06054e63          	bltz	a0,800053b6 <exec+0x35e>
  p->tf->a1 = sp;
    8000533e:	048bb783          	ld	a5,72(s7) # 1048 <_entry-0x7fffefb8>
    80005342:	0737bc23          	sd	s3,120(a5)
  for(last=s=path; *s; s++)
    80005346:	df843783          	ld	a5,-520(s0)
    8000534a:	0007c703          	lbu	a4,0(a5)
    8000534e:	cf11                	beqz	a4,8000536a <exec+0x312>
    80005350:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005352:	02f00693          	li	a3,47
    80005356:	a029                	j	80005360 <exec+0x308>
  for(last=s=path; *s; s++)
    80005358:	0785                	addi	a5,a5,1
    8000535a:	fff7c703          	lbu	a4,-1(a5)
    8000535e:	c711                	beqz	a4,8000536a <exec+0x312>
    if(*s == '/')
    80005360:	fed71ce3          	bne	a4,a3,80005358 <exec+0x300>
      last = s+1;
    80005364:	def43c23          	sd	a5,-520(s0)
    80005368:	bfc5                	j	80005358 <exec+0x300>
  safestrcpy(p->name, last, sizeof(p->name));
    8000536a:	4641                	li	a2,16
    8000536c:	df843583          	ld	a1,-520(s0)
    80005370:	148b8513          	addi	a0,s7,328
    80005374:	ffffc097          	auipc	ra,0xffffc
    80005378:	950080e7          	jalr	-1712(ra) # 80000cc4 <safestrcpy>
  oldpagetable = p->pagetable;
    8000537c:	040bb503          	ld	a0,64(s7)
  p->pagetable = pagetable;
    80005380:	058bb023          	sd	s8,64(s7)
  p->sz = sz;
    80005384:	e0843783          	ld	a5,-504(s0)
    80005388:	02fbbc23          	sd	a5,56(s7)
  p->tf->epc = elf.entry;  // initial program counter = main
    8000538c:	048bb783          	ld	a5,72(s7)
    80005390:	e6043703          	ld	a4,-416(s0)
    80005394:	ef98                	sd	a4,24(a5)
  p->tf->sp = sp; // initial stack pointer
    80005396:	048bb783          	ld	a5,72(s7)
    8000539a:	0337b823          	sd	s3,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000539e:	85ea                	mv	a1,s10
    800053a0:	ffffd097          	auipc	ra,0xffffd
    800053a4:	884080e7          	jalr	-1916(ra) # 80001c24 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800053a8:	0009051b          	sext.w	a0,s2
    800053ac:	b391                	j	800050f0 <exec+0x98>
  ip = 0;
    800053ae:	4481                	li	s1,0
    800053b0:	b5c1                	j	80005270 <exec+0x218>
    800053b2:	4481                	li	s1,0
    800053b4:	bd75                	j	80005270 <exec+0x218>
    800053b6:	4481                	li	s1,0
    800053b8:	bd65                	j	80005270 <exec+0x218>

00000000800053ba <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800053ba:	7179                	addi	sp,sp,-48
    800053bc:	f406                	sd	ra,40(sp)
    800053be:	f022                	sd	s0,32(sp)
    800053c0:	ec26                	sd	s1,24(sp)
    800053c2:	e84a                	sd	s2,16(sp)
    800053c4:	1800                	addi	s0,sp,48
    800053c6:	892e                	mv	s2,a1
    800053c8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800053ca:	fdc40593          	addi	a1,s0,-36
    800053ce:	ffffe097          	auipc	ra,0xffffe
    800053d2:	bec080e7          	jalr	-1044(ra) # 80002fba <argint>
    800053d6:	04054063          	bltz	a0,80005416 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800053da:	fdc42703          	lw	a4,-36(s0)
    800053de:	47bd                	li	a5,15
    800053e0:	02e7ed63          	bltu	a5,a4,8000541a <argfd+0x60>
    800053e4:	ffffc097          	auipc	ra,0xffffc
    800053e8:	624080e7          	jalr	1572(ra) # 80001a08 <myproc>
    800053ec:	fdc42703          	lw	a4,-36(s0)
    800053f0:	01870793          	addi	a5,a4,24
    800053f4:	078e                	slli	a5,a5,0x3
    800053f6:	953e                	add	a0,a0,a5
    800053f8:	611c                	ld	a5,0(a0)
    800053fa:	c395                	beqz	a5,8000541e <argfd+0x64>
    return -1;
  if(pfd)
    800053fc:	00090463          	beqz	s2,80005404 <argfd+0x4a>
    *pfd = fd;
    80005400:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005404:	4501                	li	a0,0
  if(pf)
    80005406:	c091                	beqz	s1,8000540a <argfd+0x50>
    *pf = f;
    80005408:	e09c                	sd	a5,0(s1)
}
    8000540a:	70a2                	ld	ra,40(sp)
    8000540c:	7402                	ld	s0,32(sp)
    8000540e:	64e2                	ld	s1,24(sp)
    80005410:	6942                	ld	s2,16(sp)
    80005412:	6145                	addi	sp,sp,48
    80005414:	8082                	ret
    return -1;
    80005416:	557d                	li	a0,-1
    80005418:	bfcd                	j	8000540a <argfd+0x50>
    return -1;
    8000541a:	557d                	li	a0,-1
    8000541c:	b7fd                	j	8000540a <argfd+0x50>
    8000541e:	557d                	li	a0,-1
    80005420:	b7ed                	j	8000540a <argfd+0x50>

0000000080005422 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005422:	1101                	addi	sp,sp,-32
    80005424:	ec06                	sd	ra,24(sp)
    80005426:	e822                	sd	s0,16(sp)
    80005428:	e426                	sd	s1,8(sp)
    8000542a:	1000                	addi	s0,sp,32
    8000542c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000542e:	ffffc097          	auipc	ra,0xffffc
    80005432:	5da080e7          	jalr	1498(ra) # 80001a08 <myproc>
    80005436:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005438:	0c050793          	addi	a5,a0,192
    8000543c:	4501                	li	a0,0
    8000543e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005440:	6398                	ld	a4,0(a5)
    80005442:	cb19                	beqz	a4,80005458 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005444:	2505                	addiw	a0,a0,1
    80005446:	07a1                	addi	a5,a5,8
    80005448:	fed51ce3          	bne	a0,a3,80005440 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000544c:	557d                	li	a0,-1
}
    8000544e:	60e2                	ld	ra,24(sp)
    80005450:	6442                	ld	s0,16(sp)
    80005452:	64a2                	ld	s1,8(sp)
    80005454:	6105                	addi	sp,sp,32
    80005456:	8082                	ret
      p->ofile[fd] = f;
    80005458:	01850793          	addi	a5,a0,24
    8000545c:	078e                	slli	a5,a5,0x3
    8000545e:	963e                	add	a2,a2,a5
    80005460:	e204                	sd	s1,0(a2)
      return fd;
    80005462:	b7f5                	j	8000544e <fdalloc+0x2c>

0000000080005464 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005464:	715d                	addi	sp,sp,-80
    80005466:	e486                	sd	ra,72(sp)
    80005468:	e0a2                	sd	s0,64(sp)
    8000546a:	fc26                	sd	s1,56(sp)
    8000546c:	f84a                	sd	s2,48(sp)
    8000546e:	f44e                	sd	s3,40(sp)
    80005470:	f052                	sd	s4,32(sp)
    80005472:	ec56                	sd	s5,24(sp)
    80005474:	0880                	addi	s0,sp,80
    80005476:	89ae                	mv	s3,a1
    80005478:	8ab2                	mv	s5,a2
    8000547a:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000547c:	fb040593          	addi	a1,s0,-80
    80005480:	fffff097          	auipc	ra,0xfffff
    80005484:	e76080e7          	jalr	-394(ra) # 800042f6 <nameiparent>
    80005488:	892a                	mv	s2,a0
    8000548a:	12050e63          	beqz	a0,800055c6 <create+0x162>
    return 0;

  ilock(dp);
    8000548e:	ffffe097          	auipc	ra,0xffffe
    80005492:	6c0080e7          	jalr	1728(ra) # 80003b4e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005496:	4601                	li	a2,0
    80005498:	fb040593          	addi	a1,s0,-80
    8000549c:	854a                	mv	a0,s2
    8000549e:	fffff097          	auipc	ra,0xfffff
    800054a2:	b68080e7          	jalr	-1176(ra) # 80004006 <dirlookup>
    800054a6:	84aa                	mv	s1,a0
    800054a8:	c921                	beqz	a0,800054f8 <create+0x94>
    iunlockput(dp);
    800054aa:	854a                	mv	a0,s2
    800054ac:	fffff097          	auipc	ra,0xfffff
    800054b0:	8e0080e7          	jalr	-1824(ra) # 80003d8c <iunlockput>
    ilock(ip);
    800054b4:	8526                	mv	a0,s1
    800054b6:	ffffe097          	auipc	ra,0xffffe
    800054ba:	698080e7          	jalr	1688(ra) # 80003b4e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800054be:	2981                	sext.w	s3,s3
    800054c0:	4789                	li	a5,2
    800054c2:	02f99463          	bne	s3,a5,800054ea <create+0x86>
    800054c6:	0444d783          	lhu	a5,68(s1)
    800054ca:	37f9                	addiw	a5,a5,-2
    800054cc:	17c2                	slli	a5,a5,0x30
    800054ce:	93c1                	srli	a5,a5,0x30
    800054d0:	4705                	li	a4,1
    800054d2:	00f76c63          	bltu	a4,a5,800054ea <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800054d6:	8526                	mv	a0,s1
    800054d8:	60a6                	ld	ra,72(sp)
    800054da:	6406                	ld	s0,64(sp)
    800054dc:	74e2                	ld	s1,56(sp)
    800054de:	7942                	ld	s2,48(sp)
    800054e0:	79a2                	ld	s3,40(sp)
    800054e2:	7a02                	ld	s4,32(sp)
    800054e4:	6ae2                	ld	s5,24(sp)
    800054e6:	6161                	addi	sp,sp,80
    800054e8:	8082                	ret
    iunlockput(ip);
    800054ea:	8526                	mv	a0,s1
    800054ec:	fffff097          	auipc	ra,0xfffff
    800054f0:	8a0080e7          	jalr	-1888(ra) # 80003d8c <iunlockput>
    return 0;
    800054f4:	4481                	li	s1,0
    800054f6:	b7c5                	j	800054d6 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800054f8:	85ce                	mv	a1,s3
    800054fa:	00092503          	lw	a0,0(s2)
    800054fe:	ffffe097          	auipc	ra,0xffffe
    80005502:	4b8080e7          	jalr	1208(ra) # 800039b6 <ialloc>
    80005506:	84aa                	mv	s1,a0
    80005508:	c521                	beqz	a0,80005550 <create+0xec>
  ilock(ip);
    8000550a:	ffffe097          	auipc	ra,0xffffe
    8000550e:	644080e7          	jalr	1604(ra) # 80003b4e <ilock>
  ip->major = major;
    80005512:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005516:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000551a:	4a05                	li	s4,1
    8000551c:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005520:	8526                	mv	a0,s1
    80005522:	ffffe097          	auipc	ra,0xffffe
    80005526:	562080e7          	jalr	1378(ra) # 80003a84 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000552a:	2981                	sext.w	s3,s3
    8000552c:	03498a63          	beq	s3,s4,80005560 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005530:	40d0                	lw	a2,4(s1)
    80005532:	fb040593          	addi	a1,s0,-80
    80005536:	854a                	mv	a0,s2
    80005538:	fffff097          	auipc	ra,0xfffff
    8000553c:	cde080e7          	jalr	-802(ra) # 80004216 <dirlink>
    80005540:	06054b63          	bltz	a0,800055b6 <create+0x152>
  iunlockput(dp);
    80005544:	854a                	mv	a0,s2
    80005546:	fffff097          	auipc	ra,0xfffff
    8000554a:	846080e7          	jalr	-1978(ra) # 80003d8c <iunlockput>
  return ip;
    8000554e:	b761                	j	800054d6 <create+0x72>
    panic("create: ialloc");
    80005550:	00002517          	auipc	a0,0x2
    80005554:	31850513          	addi	a0,a0,792 # 80007868 <userret+0x7d8>
    80005558:	ffffb097          	auipc	ra,0xffffb
    8000555c:	ff6080e7          	jalr	-10(ra) # 8000054e <panic>
    dp->nlink++;  // for ".."
    80005560:	04a95783          	lhu	a5,74(s2)
    80005564:	2785                	addiw	a5,a5,1
    80005566:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000556a:	854a                	mv	a0,s2
    8000556c:	ffffe097          	auipc	ra,0xffffe
    80005570:	518080e7          	jalr	1304(ra) # 80003a84 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005574:	40d0                	lw	a2,4(s1)
    80005576:	00002597          	auipc	a1,0x2
    8000557a:	30258593          	addi	a1,a1,770 # 80007878 <userret+0x7e8>
    8000557e:	8526                	mv	a0,s1
    80005580:	fffff097          	auipc	ra,0xfffff
    80005584:	c96080e7          	jalr	-874(ra) # 80004216 <dirlink>
    80005588:	00054f63          	bltz	a0,800055a6 <create+0x142>
    8000558c:	00492603          	lw	a2,4(s2)
    80005590:	00002597          	auipc	a1,0x2
    80005594:	2f058593          	addi	a1,a1,752 # 80007880 <userret+0x7f0>
    80005598:	8526                	mv	a0,s1
    8000559a:	fffff097          	auipc	ra,0xfffff
    8000559e:	c7c080e7          	jalr	-900(ra) # 80004216 <dirlink>
    800055a2:	f80557e3          	bgez	a0,80005530 <create+0xcc>
      panic("create dots");
    800055a6:	00002517          	auipc	a0,0x2
    800055aa:	2e250513          	addi	a0,a0,738 # 80007888 <userret+0x7f8>
    800055ae:	ffffb097          	auipc	ra,0xffffb
    800055b2:	fa0080e7          	jalr	-96(ra) # 8000054e <panic>
    panic("create: dirlink");
    800055b6:	00002517          	auipc	a0,0x2
    800055ba:	2e250513          	addi	a0,a0,738 # 80007898 <userret+0x808>
    800055be:	ffffb097          	auipc	ra,0xffffb
    800055c2:	f90080e7          	jalr	-112(ra) # 8000054e <panic>
    return 0;
    800055c6:	84aa                	mv	s1,a0
    800055c8:	b739                	j	800054d6 <create+0x72>

00000000800055ca <sys_dup>:
{
    800055ca:	7179                	addi	sp,sp,-48
    800055cc:	f406                	sd	ra,40(sp)
    800055ce:	f022                	sd	s0,32(sp)
    800055d0:	ec26                	sd	s1,24(sp)
    800055d2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800055d4:	fd840613          	addi	a2,s0,-40
    800055d8:	4581                	li	a1,0
    800055da:	4501                	li	a0,0
    800055dc:	00000097          	auipc	ra,0x0
    800055e0:	dde080e7          	jalr	-546(ra) # 800053ba <argfd>
    return -1;
    800055e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800055e6:	02054363          	bltz	a0,8000560c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800055ea:	fd843503          	ld	a0,-40(s0)
    800055ee:	00000097          	auipc	ra,0x0
    800055f2:	e34080e7          	jalr	-460(ra) # 80005422 <fdalloc>
    800055f6:	84aa                	mv	s1,a0
    return -1;
    800055f8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800055fa:	00054963          	bltz	a0,8000560c <sys_dup+0x42>
  filedup(f);
    800055fe:	fd843503          	ld	a0,-40(s0)
    80005602:	fffff097          	auipc	ra,0xfffff
    80005606:	362080e7          	jalr	866(ra) # 80004964 <filedup>
  return fd;
    8000560a:	87a6                	mv	a5,s1
}
    8000560c:	853e                	mv	a0,a5
    8000560e:	70a2                	ld	ra,40(sp)
    80005610:	7402                	ld	s0,32(sp)
    80005612:	64e2                	ld	s1,24(sp)
    80005614:	6145                	addi	sp,sp,48
    80005616:	8082                	ret

0000000080005618 <sys_read>:
{
    80005618:	7179                	addi	sp,sp,-48
    8000561a:	f406                	sd	ra,40(sp)
    8000561c:	f022                	sd	s0,32(sp)
    8000561e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005620:	fe840613          	addi	a2,s0,-24
    80005624:	4581                	li	a1,0
    80005626:	4501                	li	a0,0
    80005628:	00000097          	auipc	ra,0x0
    8000562c:	d92080e7          	jalr	-622(ra) # 800053ba <argfd>
    return -1;
    80005630:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005632:	04054163          	bltz	a0,80005674 <sys_read+0x5c>
    80005636:	fe440593          	addi	a1,s0,-28
    8000563a:	4509                	li	a0,2
    8000563c:	ffffe097          	auipc	ra,0xffffe
    80005640:	97e080e7          	jalr	-1666(ra) # 80002fba <argint>
    return -1;
    80005644:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005646:	02054763          	bltz	a0,80005674 <sys_read+0x5c>
    8000564a:	fd840593          	addi	a1,s0,-40
    8000564e:	4505                	li	a0,1
    80005650:	ffffe097          	auipc	ra,0xffffe
    80005654:	98c080e7          	jalr	-1652(ra) # 80002fdc <argaddr>
    return -1;
    80005658:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000565a:	00054d63          	bltz	a0,80005674 <sys_read+0x5c>
  return fileread(f, p, n);
    8000565e:	fe442603          	lw	a2,-28(s0)
    80005662:	fd843583          	ld	a1,-40(s0)
    80005666:	fe843503          	ld	a0,-24(s0)
    8000566a:	fffff097          	auipc	ra,0xfffff
    8000566e:	486080e7          	jalr	1158(ra) # 80004af0 <fileread>
    80005672:	87aa                	mv	a5,a0
}
    80005674:	853e                	mv	a0,a5
    80005676:	70a2                	ld	ra,40(sp)
    80005678:	7402                	ld	s0,32(sp)
    8000567a:	6145                	addi	sp,sp,48
    8000567c:	8082                	ret

000000008000567e <sys_write>:
{
    8000567e:	7179                	addi	sp,sp,-48
    80005680:	f406                	sd	ra,40(sp)
    80005682:	f022                	sd	s0,32(sp)
    80005684:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005686:	fe840613          	addi	a2,s0,-24
    8000568a:	4581                	li	a1,0
    8000568c:	4501                	li	a0,0
    8000568e:	00000097          	auipc	ra,0x0
    80005692:	d2c080e7          	jalr	-724(ra) # 800053ba <argfd>
    return -1;
    80005696:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005698:	04054163          	bltz	a0,800056da <sys_write+0x5c>
    8000569c:	fe440593          	addi	a1,s0,-28
    800056a0:	4509                	li	a0,2
    800056a2:	ffffe097          	auipc	ra,0xffffe
    800056a6:	918080e7          	jalr	-1768(ra) # 80002fba <argint>
    return -1;
    800056aa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800056ac:	02054763          	bltz	a0,800056da <sys_write+0x5c>
    800056b0:	fd840593          	addi	a1,s0,-40
    800056b4:	4505                	li	a0,1
    800056b6:	ffffe097          	auipc	ra,0xffffe
    800056ba:	926080e7          	jalr	-1754(ra) # 80002fdc <argaddr>
    return -1;
    800056be:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800056c0:	00054d63          	bltz	a0,800056da <sys_write+0x5c>
  return filewrite(f, p, n);
    800056c4:	fe442603          	lw	a2,-28(s0)
    800056c8:	fd843583          	ld	a1,-40(s0)
    800056cc:	fe843503          	ld	a0,-24(s0)
    800056d0:	fffff097          	auipc	ra,0xfffff
    800056d4:	4e2080e7          	jalr	1250(ra) # 80004bb2 <filewrite>
    800056d8:	87aa                	mv	a5,a0
}
    800056da:	853e                	mv	a0,a5
    800056dc:	70a2                	ld	ra,40(sp)
    800056de:	7402                	ld	s0,32(sp)
    800056e0:	6145                	addi	sp,sp,48
    800056e2:	8082                	ret

00000000800056e4 <sys_close>:
{
    800056e4:	1101                	addi	sp,sp,-32
    800056e6:	ec06                	sd	ra,24(sp)
    800056e8:	e822                	sd	s0,16(sp)
    800056ea:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800056ec:	fe040613          	addi	a2,s0,-32
    800056f0:	fec40593          	addi	a1,s0,-20
    800056f4:	4501                	li	a0,0
    800056f6:	00000097          	auipc	ra,0x0
    800056fa:	cc4080e7          	jalr	-828(ra) # 800053ba <argfd>
    return -1;
    800056fe:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005700:	02054463          	bltz	a0,80005728 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005704:	ffffc097          	auipc	ra,0xffffc
    80005708:	304080e7          	jalr	772(ra) # 80001a08 <myproc>
    8000570c:	fec42783          	lw	a5,-20(s0)
    80005710:	07e1                	addi	a5,a5,24
    80005712:	078e                	slli	a5,a5,0x3
    80005714:	97aa                	add	a5,a5,a0
    80005716:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000571a:	fe043503          	ld	a0,-32(s0)
    8000571e:	fffff097          	auipc	ra,0xfffff
    80005722:	298080e7          	jalr	664(ra) # 800049b6 <fileclose>
  return 0;
    80005726:	4781                	li	a5,0
}
    80005728:	853e                	mv	a0,a5
    8000572a:	60e2                	ld	ra,24(sp)
    8000572c:	6442                	ld	s0,16(sp)
    8000572e:	6105                	addi	sp,sp,32
    80005730:	8082                	ret

0000000080005732 <sys_fstat>:
{
    80005732:	1101                	addi	sp,sp,-32
    80005734:	ec06                	sd	ra,24(sp)
    80005736:	e822                	sd	s0,16(sp)
    80005738:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000573a:	fe840613          	addi	a2,s0,-24
    8000573e:	4581                	li	a1,0
    80005740:	4501                	li	a0,0
    80005742:	00000097          	auipc	ra,0x0
    80005746:	c78080e7          	jalr	-904(ra) # 800053ba <argfd>
    return -1;
    8000574a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000574c:	02054563          	bltz	a0,80005776 <sys_fstat+0x44>
    80005750:	fe040593          	addi	a1,s0,-32
    80005754:	4505                	li	a0,1
    80005756:	ffffe097          	auipc	ra,0xffffe
    8000575a:	886080e7          	jalr	-1914(ra) # 80002fdc <argaddr>
    return -1;
    8000575e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005760:	00054b63          	bltz	a0,80005776 <sys_fstat+0x44>
  return filestat(f, st);
    80005764:	fe043583          	ld	a1,-32(s0)
    80005768:	fe843503          	ld	a0,-24(s0)
    8000576c:	fffff097          	auipc	ra,0xfffff
    80005770:	312080e7          	jalr	786(ra) # 80004a7e <filestat>
    80005774:	87aa                	mv	a5,a0
}
    80005776:	853e                	mv	a0,a5
    80005778:	60e2                	ld	ra,24(sp)
    8000577a:	6442                	ld	s0,16(sp)
    8000577c:	6105                	addi	sp,sp,32
    8000577e:	8082                	ret

0000000080005780 <sys_link>:
{
    80005780:	7169                	addi	sp,sp,-304
    80005782:	f606                	sd	ra,296(sp)
    80005784:	f222                	sd	s0,288(sp)
    80005786:	ee26                	sd	s1,280(sp)
    80005788:	ea4a                	sd	s2,272(sp)
    8000578a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000578c:	08000613          	li	a2,128
    80005790:	ed040593          	addi	a1,s0,-304
    80005794:	4501                	li	a0,0
    80005796:	ffffe097          	auipc	ra,0xffffe
    8000579a:	868080e7          	jalr	-1944(ra) # 80002ffe <argstr>
    return -1;
    8000579e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800057a0:	10054e63          	bltz	a0,800058bc <sys_link+0x13c>
    800057a4:	08000613          	li	a2,128
    800057a8:	f5040593          	addi	a1,s0,-176
    800057ac:	4505                	li	a0,1
    800057ae:	ffffe097          	auipc	ra,0xffffe
    800057b2:	850080e7          	jalr	-1968(ra) # 80002ffe <argstr>
    return -1;
    800057b6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800057b8:	10054263          	bltz	a0,800058bc <sys_link+0x13c>
  begin_op();
    800057bc:	fffff097          	auipc	ra,0xfffff
    800057c0:	d28080e7          	jalr	-728(ra) # 800044e4 <begin_op>
  if((ip = namei(old)) == 0){
    800057c4:	ed040513          	addi	a0,s0,-304
    800057c8:	fffff097          	auipc	ra,0xfffff
    800057cc:	b10080e7          	jalr	-1264(ra) # 800042d8 <namei>
    800057d0:	84aa                	mv	s1,a0
    800057d2:	c551                	beqz	a0,8000585e <sys_link+0xde>
  ilock(ip);
    800057d4:	ffffe097          	auipc	ra,0xffffe
    800057d8:	37a080e7          	jalr	890(ra) # 80003b4e <ilock>
  if(ip->type == T_DIR){
    800057dc:	04449703          	lh	a4,68(s1)
    800057e0:	4785                	li	a5,1
    800057e2:	08f70463          	beq	a4,a5,8000586a <sys_link+0xea>
  ip->nlink++;
    800057e6:	04a4d783          	lhu	a5,74(s1)
    800057ea:	2785                	addiw	a5,a5,1
    800057ec:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800057f0:	8526                	mv	a0,s1
    800057f2:	ffffe097          	auipc	ra,0xffffe
    800057f6:	292080e7          	jalr	658(ra) # 80003a84 <iupdate>
  iunlock(ip);
    800057fa:	8526                	mv	a0,s1
    800057fc:	ffffe097          	auipc	ra,0xffffe
    80005800:	414080e7          	jalr	1044(ra) # 80003c10 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005804:	fd040593          	addi	a1,s0,-48
    80005808:	f5040513          	addi	a0,s0,-176
    8000580c:	fffff097          	auipc	ra,0xfffff
    80005810:	aea080e7          	jalr	-1302(ra) # 800042f6 <nameiparent>
    80005814:	892a                	mv	s2,a0
    80005816:	c935                	beqz	a0,8000588a <sys_link+0x10a>
  ilock(dp);
    80005818:	ffffe097          	auipc	ra,0xffffe
    8000581c:	336080e7          	jalr	822(ra) # 80003b4e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005820:	00092703          	lw	a4,0(s2)
    80005824:	409c                	lw	a5,0(s1)
    80005826:	04f71d63          	bne	a4,a5,80005880 <sys_link+0x100>
    8000582a:	40d0                	lw	a2,4(s1)
    8000582c:	fd040593          	addi	a1,s0,-48
    80005830:	854a                	mv	a0,s2
    80005832:	fffff097          	auipc	ra,0xfffff
    80005836:	9e4080e7          	jalr	-1564(ra) # 80004216 <dirlink>
    8000583a:	04054363          	bltz	a0,80005880 <sys_link+0x100>
  iunlockput(dp);
    8000583e:	854a                	mv	a0,s2
    80005840:	ffffe097          	auipc	ra,0xffffe
    80005844:	54c080e7          	jalr	1356(ra) # 80003d8c <iunlockput>
  iput(ip);
    80005848:	8526                	mv	a0,s1
    8000584a:	ffffe097          	auipc	ra,0xffffe
    8000584e:	412080e7          	jalr	1042(ra) # 80003c5c <iput>
  end_op();
    80005852:	fffff097          	auipc	ra,0xfffff
    80005856:	d12080e7          	jalr	-750(ra) # 80004564 <end_op>
  return 0;
    8000585a:	4781                	li	a5,0
    8000585c:	a085                	j	800058bc <sys_link+0x13c>
    end_op();
    8000585e:	fffff097          	auipc	ra,0xfffff
    80005862:	d06080e7          	jalr	-762(ra) # 80004564 <end_op>
    return -1;
    80005866:	57fd                	li	a5,-1
    80005868:	a891                	j	800058bc <sys_link+0x13c>
    iunlockput(ip);
    8000586a:	8526                	mv	a0,s1
    8000586c:	ffffe097          	auipc	ra,0xffffe
    80005870:	520080e7          	jalr	1312(ra) # 80003d8c <iunlockput>
    end_op();
    80005874:	fffff097          	auipc	ra,0xfffff
    80005878:	cf0080e7          	jalr	-784(ra) # 80004564 <end_op>
    return -1;
    8000587c:	57fd                	li	a5,-1
    8000587e:	a83d                	j	800058bc <sys_link+0x13c>
    iunlockput(dp);
    80005880:	854a                	mv	a0,s2
    80005882:	ffffe097          	auipc	ra,0xffffe
    80005886:	50a080e7          	jalr	1290(ra) # 80003d8c <iunlockput>
  ilock(ip);
    8000588a:	8526                	mv	a0,s1
    8000588c:	ffffe097          	auipc	ra,0xffffe
    80005890:	2c2080e7          	jalr	706(ra) # 80003b4e <ilock>
  ip->nlink--;
    80005894:	04a4d783          	lhu	a5,74(s1)
    80005898:	37fd                	addiw	a5,a5,-1
    8000589a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000589e:	8526                	mv	a0,s1
    800058a0:	ffffe097          	auipc	ra,0xffffe
    800058a4:	1e4080e7          	jalr	484(ra) # 80003a84 <iupdate>
  iunlockput(ip);
    800058a8:	8526                	mv	a0,s1
    800058aa:	ffffe097          	auipc	ra,0xffffe
    800058ae:	4e2080e7          	jalr	1250(ra) # 80003d8c <iunlockput>
  end_op();
    800058b2:	fffff097          	auipc	ra,0xfffff
    800058b6:	cb2080e7          	jalr	-846(ra) # 80004564 <end_op>
  return -1;
    800058ba:	57fd                	li	a5,-1
}
    800058bc:	853e                	mv	a0,a5
    800058be:	70b2                	ld	ra,296(sp)
    800058c0:	7412                	ld	s0,288(sp)
    800058c2:	64f2                	ld	s1,280(sp)
    800058c4:	6952                	ld	s2,272(sp)
    800058c6:	6155                	addi	sp,sp,304
    800058c8:	8082                	ret

00000000800058ca <sys_unlink>:
{
    800058ca:	7151                	addi	sp,sp,-240
    800058cc:	f586                	sd	ra,232(sp)
    800058ce:	f1a2                	sd	s0,224(sp)
    800058d0:	eda6                	sd	s1,216(sp)
    800058d2:	e9ca                	sd	s2,208(sp)
    800058d4:	e5ce                	sd	s3,200(sp)
    800058d6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800058d8:	08000613          	li	a2,128
    800058dc:	f3040593          	addi	a1,s0,-208
    800058e0:	4501                	li	a0,0
    800058e2:	ffffd097          	auipc	ra,0xffffd
    800058e6:	71c080e7          	jalr	1820(ra) # 80002ffe <argstr>
    800058ea:	18054163          	bltz	a0,80005a6c <sys_unlink+0x1a2>
  begin_op();
    800058ee:	fffff097          	auipc	ra,0xfffff
    800058f2:	bf6080e7          	jalr	-1034(ra) # 800044e4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800058f6:	fb040593          	addi	a1,s0,-80
    800058fa:	f3040513          	addi	a0,s0,-208
    800058fe:	fffff097          	auipc	ra,0xfffff
    80005902:	9f8080e7          	jalr	-1544(ra) # 800042f6 <nameiparent>
    80005906:	84aa                	mv	s1,a0
    80005908:	c979                	beqz	a0,800059de <sys_unlink+0x114>
  ilock(dp);
    8000590a:	ffffe097          	auipc	ra,0xffffe
    8000590e:	244080e7          	jalr	580(ra) # 80003b4e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005912:	00002597          	auipc	a1,0x2
    80005916:	f6658593          	addi	a1,a1,-154 # 80007878 <userret+0x7e8>
    8000591a:	fb040513          	addi	a0,s0,-80
    8000591e:	ffffe097          	auipc	ra,0xffffe
    80005922:	6ce080e7          	jalr	1742(ra) # 80003fec <namecmp>
    80005926:	14050a63          	beqz	a0,80005a7a <sys_unlink+0x1b0>
    8000592a:	00002597          	auipc	a1,0x2
    8000592e:	f5658593          	addi	a1,a1,-170 # 80007880 <userret+0x7f0>
    80005932:	fb040513          	addi	a0,s0,-80
    80005936:	ffffe097          	auipc	ra,0xffffe
    8000593a:	6b6080e7          	jalr	1718(ra) # 80003fec <namecmp>
    8000593e:	12050e63          	beqz	a0,80005a7a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005942:	f2c40613          	addi	a2,s0,-212
    80005946:	fb040593          	addi	a1,s0,-80
    8000594a:	8526                	mv	a0,s1
    8000594c:	ffffe097          	auipc	ra,0xffffe
    80005950:	6ba080e7          	jalr	1722(ra) # 80004006 <dirlookup>
    80005954:	892a                	mv	s2,a0
    80005956:	12050263          	beqz	a0,80005a7a <sys_unlink+0x1b0>
  ilock(ip);
    8000595a:	ffffe097          	auipc	ra,0xffffe
    8000595e:	1f4080e7          	jalr	500(ra) # 80003b4e <ilock>
  if(ip->nlink < 1)
    80005962:	04a91783          	lh	a5,74(s2)
    80005966:	08f05263          	blez	a5,800059ea <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000596a:	04491703          	lh	a4,68(s2)
    8000596e:	4785                	li	a5,1
    80005970:	08f70563          	beq	a4,a5,800059fa <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005974:	4641                	li	a2,16
    80005976:	4581                	li	a1,0
    80005978:	fc040513          	addi	a0,s0,-64
    8000597c:	ffffb097          	auipc	ra,0xffffb
    80005980:	1f2080e7          	jalr	498(ra) # 80000b6e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005984:	4741                	li	a4,16
    80005986:	f2c42683          	lw	a3,-212(s0)
    8000598a:	fc040613          	addi	a2,s0,-64
    8000598e:	4581                	li	a1,0
    80005990:	8526                	mv	a0,s1
    80005992:	ffffe097          	auipc	ra,0xffffe
    80005996:	540080e7          	jalr	1344(ra) # 80003ed2 <writei>
    8000599a:	47c1                	li	a5,16
    8000599c:	0af51563          	bne	a0,a5,80005a46 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800059a0:	04491703          	lh	a4,68(s2)
    800059a4:	4785                	li	a5,1
    800059a6:	0af70863          	beq	a4,a5,80005a56 <sys_unlink+0x18c>
  iunlockput(dp);
    800059aa:	8526                	mv	a0,s1
    800059ac:	ffffe097          	auipc	ra,0xffffe
    800059b0:	3e0080e7          	jalr	992(ra) # 80003d8c <iunlockput>
  ip->nlink--;
    800059b4:	04a95783          	lhu	a5,74(s2)
    800059b8:	37fd                	addiw	a5,a5,-1
    800059ba:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800059be:	854a                	mv	a0,s2
    800059c0:	ffffe097          	auipc	ra,0xffffe
    800059c4:	0c4080e7          	jalr	196(ra) # 80003a84 <iupdate>
  iunlockput(ip);
    800059c8:	854a                	mv	a0,s2
    800059ca:	ffffe097          	auipc	ra,0xffffe
    800059ce:	3c2080e7          	jalr	962(ra) # 80003d8c <iunlockput>
  end_op();
    800059d2:	fffff097          	auipc	ra,0xfffff
    800059d6:	b92080e7          	jalr	-1134(ra) # 80004564 <end_op>
  return 0;
    800059da:	4501                	li	a0,0
    800059dc:	a84d                	j	80005a8e <sys_unlink+0x1c4>
    end_op();
    800059de:	fffff097          	auipc	ra,0xfffff
    800059e2:	b86080e7          	jalr	-1146(ra) # 80004564 <end_op>
    return -1;
    800059e6:	557d                	li	a0,-1
    800059e8:	a05d                	j	80005a8e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800059ea:	00002517          	auipc	a0,0x2
    800059ee:	ebe50513          	addi	a0,a0,-322 # 800078a8 <userret+0x818>
    800059f2:	ffffb097          	auipc	ra,0xffffb
    800059f6:	b5c080e7          	jalr	-1188(ra) # 8000054e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800059fa:	04c92703          	lw	a4,76(s2)
    800059fe:	02000793          	li	a5,32
    80005a02:	f6e7f9e3          	bgeu	a5,a4,80005974 <sys_unlink+0xaa>
    80005a06:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a0a:	4741                	li	a4,16
    80005a0c:	86ce                	mv	a3,s3
    80005a0e:	f1840613          	addi	a2,s0,-232
    80005a12:	4581                	li	a1,0
    80005a14:	854a                	mv	a0,s2
    80005a16:	ffffe097          	auipc	ra,0xffffe
    80005a1a:	3c8080e7          	jalr	968(ra) # 80003dde <readi>
    80005a1e:	47c1                	li	a5,16
    80005a20:	00f51b63          	bne	a0,a5,80005a36 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005a24:	f1845783          	lhu	a5,-232(s0)
    80005a28:	e7a1                	bnez	a5,80005a70 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005a2a:	29c1                	addiw	s3,s3,16
    80005a2c:	04c92783          	lw	a5,76(s2)
    80005a30:	fcf9ede3          	bltu	s3,a5,80005a0a <sys_unlink+0x140>
    80005a34:	b781                	j	80005974 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005a36:	00002517          	auipc	a0,0x2
    80005a3a:	e8a50513          	addi	a0,a0,-374 # 800078c0 <userret+0x830>
    80005a3e:	ffffb097          	auipc	ra,0xffffb
    80005a42:	b10080e7          	jalr	-1264(ra) # 8000054e <panic>
    panic("unlink: writei");
    80005a46:	00002517          	auipc	a0,0x2
    80005a4a:	e9250513          	addi	a0,a0,-366 # 800078d8 <userret+0x848>
    80005a4e:	ffffb097          	auipc	ra,0xffffb
    80005a52:	b00080e7          	jalr	-1280(ra) # 8000054e <panic>
    dp->nlink--;
    80005a56:	04a4d783          	lhu	a5,74(s1)
    80005a5a:	37fd                	addiw	a5,a5,-1
    80005a5c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005a60:	8526                	mv	a0,s1
    80005a62:	ffffe097          	auipc	ra,0xffffe
    80005a66:	022080e7          	jalr	34(ra) # 80003a84 <iupdate>
    80005a6a:	b781                	j	800059aa <sys_unlink+0xe0>
    return -1;
    80005a6c:	557d                	li	a0,-1
    80005a6e:	a005                	j	80005a8e <sys_unlink+0x1c4>
    iunlockput(ip);
    80005a70:	854a                	mv	a0,s2
    80005a72:	ffffe097          	auipc	ra,0xffffe
    80005a76:	31a080e7          	jalr	794(ra) # 80003d8c <iunlockput>
  iunlockput(dp);
    80005a7a:	8526                	mv	a0,s1
    80005a7c:	ffffe097          	auipc	ra,0xffffe
    80005a80:	310080e7          	jalr	784(ra) # 80003d8c <iunlockput>
  end_op();
    80005a84:	fffff097          	auipc	ra,0xfffff
    80005a88:	ae0080e7          	jalr	-1312(ra) # 80004564 <end_op>
  return -1;
    80005a8c:	557d                	li	a0,-1
}
    80005a8e:	70ae                	ld	ra,232(sp)
    80005a90:	740e                	ld	s0,224(sp)
    80005a92:	64ee                	ld	s1,216(sp)
    80005a94:	694e                	ld	s2,208(sp)
    80005a96:	69ae                	ld	s3,200(sp)
    80005a98:	616d                	addi	sp,sp,240
    80005a9a:	8082                	ret

0000000080005a9c <sys_open>:

uint64
sys_open(void)
{
    80005a9c:	7131                	addi	sp,sp,-192
    80005a9e:	fd06                	sd	ra,184(sp)
    80005aa0:	f922                	sd	s0,176(sp)
    80005aa2:	f526                	sd	s1,168(sp)
    80005aa4:	f14a                	sd	s2,160(sp)
    80005aa6:	ed4e                	sd	s3,152(sp)
    80005aa8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005aaa:	08000613          	li	a2,128
    80005aae:	f5040593          	addi	a1,s0,-176
    80005ab2:	4501                	li	a0,0
    80005ab4:	ffffd097          	auipc	ra,0xffffd
    80005ab8:	54a080e7          	jalr	1354(ra) # 80002ffe <argstr>
    return -1;
    80005abc:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005abe:	0a054763          	bltz	a0,80005b6c <sys_open+0xd0>
    80005ac2:	f4c40593          	addi	a1,s0,-180
    80005ac6:	4505                	li	a0,1
    80005ac8:	ffffd097          	auipc	ra,0xffffd
    80005acc:	4f2080e7          	jalr	1266(ra) # 80002fba <argint>
    80005ad0:	08054e63          	bltz	a0,80005b6c <sys_open+0xd0>

  begin_op();
    80005ad4:	fffff097          	auipc	ra,0xfffff
    80005ad8:	a10080e7          	jalr	-1520(ra) # 800044e4 <begin_op>

  if(omode & O_CREATE){
    80005adc:	f4c42783          	lw	a5,-180(s0)
    80005ae0:	2007f793          	andi	a5,a5,512
    80005ae4:	c3cd                	beqz	a5,80005b86 <sys_open+0xea>
    ip = create(path, T_FILE, 0, 0);
    80005ae6:	4681                	li	a3,0
    80005ae8:	4601                	li	a2,0
    80005aea:	4589                	li	a1,2
    80005aec:	f5040513          	addi	a0,s0,-176
    80005af0:	00000097          	auipc	ra,0x0
    80005af4:	974080e7          	jalr	-1676(ra) # 80005464 <create>
    80005af8:	892a                	mv	s2,a0
    if(ip == 0){
    80005afa:	c149                	beqz	a0,80005b7c <sys_open+0xe0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005afc:	04491703          	lh	a4,68(s2)
    80005b00:	478d                	li	a5,3
    80005b02:	00f71763          	bne	a4,a5,80005b10 <sys_open+0x74>
    80005b06:	04695703          	lhu	a4,70(s2)
    80005b0a:	47a5                	li	a5,9
    80005b0c:	0ce7e263          	bltu	a5,a4,80005bd0 <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005b10:	fffff097          	auipc	ra,0xfffff
    80005b14:	dea080e7          	jalr	-534(ra) # 800048fa <filealloc>
    80005b18:	89aa                	mv	s3,a0
    80005b1a:	c175                	beqz	a0,80005bfe <sys_open+0x162>
    80005b1c:	00000097          	auipc	ra,0x0
    80005b20:	906080e7          	jalr	-1786(ra) # 80005422 <fdalloc>
    80005b24:	84aa                	mv	s1,a0
    80005b26:	0c054763          	bltz	a0,80005bf4 <sys_open+0x158>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005b2a:	04491703          	lh	a4,68(s2)
    80005b2e:	478d                	li	a5,3
    80005b30:	0af70b63          	beq	a4,a5,80005be6 <sys_open+0x14a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005b34:	4789                	li	a5,2
    80005b36:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005b3a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005b3e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005b42:	f4c42783          	lw	a5,-180(s0)
    80005b46:	0017c713          	xori	a4,a5,1
    80005b4a:	8b05                	andi	a4,a4,1
    80005b4c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005b50:	8b8d                	andi	a5,a5,3
    80005b52:	00f037b3          	snez	a5,a5
    80005b56:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
    80005b5a:	854a                	mv	a0,s2
    80005b5c:	ffffe097          	auipc	ra,0xffffe
    80005b60:	0b4080e7          	jalr	180(ra) # 80003c10 <iunlock>
  end_op();
    80005b64:	fffff097          	auipc	ra,0xfffff
    80005b68:	a00080e7          	jalr	-1536(ra) # 80004564 <end_op>

  return fd;
}
    80005b6c:	8526                	mv	a0,s1
    80005b6e:	70ea                	ld	ra,184(sp)
    80005b70:	744a                	ld	s0,176(sp)
    80005b72:	74aa                	ld	s1,168(sp)
    80005b74:	790a                	ld	s2,160(sp)
    80005b76:	69ea                	ld	s3,152(sp)
    80005b78:	6129                	addi	sp,sp,192
    80005b7a:	8082                	ret
      end_op();
    80005b7c:	fffff097          	auipc	ra,0xfffff
    80005b80:	9e8080e7          	jalr	-1560(ra) # 80004564 <end_op>
      return -1;
    80005b84:	b7e5                	j	80005b6c <sys_open+0xd0>
    if((ip = namei(path)) == 0){
    80005b86:	f5040513          	addi	a0,s0,-176
    80005b8a:	ffffe097          	auipc	ra,0xffffe
    80005b8e:	74e080e7          	jalr	1870(ra) # 800042d8 <namei>
    80005b92:	892a                	mv	s2,a0
    80005b94:	c905                	beqz	a0,80005bc4 <sys_open+0x128>
    ilock(ip);
    80005b96:	ffffe097          	auipc	ra,0xffffe
    80005b9a:	fb8080e7          	jalr	-72(ra) # 80003b4e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005b9e:	04491703          	lh	a4,68(s2)
    80005ba2:	4785                	li	a5,1
    80005ba4:	f4f71ce3          	bne	a4,a5,80005afc <sys_open+0x60>
    80005ba8:	f4c42783          	lw	a5,-180(s0)
    80005bac:	d3b5                	beqz	a5,80005b10 <sys_open+0x74>
      iunlockput(ip);
    80005bae:	854a                	mv	a0,s2
    80005bb0:	ffffe097          	auipc	ra,0xffffe
    80005bb4:	1dc080e7          	jalr	476(ra) # 80003d8c <iunlockput>
      end_op();
    80005bb8:	fffff097          	auipc	ra,0xfffff
    80005bbc:	9ac080e7          	jalr	-1620(ra) # 80004564 <end_op>
      return -1;
    80005bc0:	54fd                	li	s1,-1
    80005bc2:	b76d                	j	80005b6c <sys_open+0xd0>
      end_op();
    80005bc4:	fffff097          	auipc	ra,0xfffff
    80005bc8:	9a0080e7          	jalr	-1632(ra) # 80004564 <end_op>
      return -1;
    80005bcc:	54fd                	li	s1,-1
    80005bce:	bf79                	j	80005b6c <sys_open+0xd0>
    iunlockput(ip);
    80005bd0:	854a                	mv	a0,s2
    80005bd2:	ffffe097          	auipc	ra,0xffffe
    80005bd6:	1ba080e7          	jalr	442(ra) # 80003d8c <iunlockput>
    end_op();
    80005bda:	fffff097          	auipc	ra,0xfffff
    80005bde:	98a080e7          	jalr	-1654(ra) # 80004564 <end_op>
    return -1;
    80005be2:	54fd                	li	s1,-1
    80005be4:	b761                	j	80005b6c <sys_open+0xd0>
    f->type = FD_DEVICE;
    80005be6:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005bea:	04691783          	lh	a5,70(s2)
    80005bee:	02f99223          	sh	a5,36(s3)
    80005bf2:	b7b1                	j	80005b3e <sys_open+0xa2>
      fileclose(f);
    80005bf4:	854e                	mv	a0,s3
    80005bf6:	fffff097          	auipc	ra,0xfffff
    80005bfa:	dc0080e7          	jalr	-576(ra) # 800049b6 <fileclose>
    iunlockput(ip);
    80005bfe:	854a                	mv	a0,s2
    80005c00:	ffffe097          	auipc	ra,0xffffe
    80005c04:	18c080e7          	jalr	396(ra) # 80003d8c <iunlockput>
    end_op();
    80005c08:	fffff097          	auipc	ra,0xfffff
    80005c0c:	95c080e7          	jalr	-1700(ra) # 80004564 <end_op>
    return -1;
    80005c10:	54fd                	li	s1,-1
    80005c12:	bfa9                	j	80005b6c <sys_open+0xd0>

0000000080005c14 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005c14:	7175                	addi	sp,sp,-144
    80005c16:	e506                	sd	ra,136(sp)
    80005c18:	e122                	sd	s0,128(sp)
    80005c1a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005c1c:	fffff097          	auipc	ra,0xfffff
    80005c20:	8c8080e7          	jalr	-1848(ra) # 800044e4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005c24:	08000613          	li	a2,128
    80005c28:	f7040593          	addi	a1,s0,-144
    80005c2c:	4501                	li	a0,0
    80005c2e:	ffffd097          	auipc	ra,0xffffd
    80005c32:	3d0080e7          	jalr	976(ra) # 80002ffe <argstr>
    80005c36:	02054963          	bltz	a0,80005c68 <sys_mkdir+0x54>
    80005c3a:	4681                	li	a3,0
    80005c3c:	4601                	li	a2,0
    80005c3e:	4585                	li	a1,1
    80005c40:	f7040513          	addi	a0,s0,-144
    80005c44:	00000097          	auipc	ra,0x0
    80005c48:	820080e7          	jalr	-2016(ra) # 80005464 <create>
    80005c4c:	cd11                	beqz	a0,80005c68 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005c4e:	ffffe097          	auipc	ra,0xffffe
    80005c52:	13e080e7          	jalr	318(ra) # 80003d8c <iunlockput>
  end_op();
    80005c56:	fffff097          	auipc	ra,0xfffff
    80005c5a:	90e080e7          	jalr	-1778(ra) # 80004564 <end_op>
  return 0;
    80005c5e:	4501                	li	a0,0
}
    80005c60:	60aa                	ld	ra,136(sp)
    80005c62:	640a                	ld	s0,128(sp)
    80005c64:	6149                	addi	sp,sp,144
    80005c66:	8082                	ret
    end_op();
    80005c68:	fffff097          	auipc	ra,0xfffff
    80005c6c:	8fc080e7          	jalr	-1796(ra) # 80004564 <end_op>
    return -1;
    80005c70:	557d                	li	a0,-1
    80005c72:	b7fd                	j	80005c60 <sys_mkdir+0x4c>

0000000080005c74 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005c74:	7135                	addi	sp,sp,-160
    80005c76:	ed06                	sd	ra,152(sp)
    80005c78:	e922                	sd	s0,144(sp)
    80005c7a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005c7c:	fffff097          	auipc	ra,0xfffff
    80005c80:	868080e7          	jalr	-1944(ra) # 800044e4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005c84:	08000613          	li	a2,128
    80005c88:	f7040593          	addi	a1,s0,-144
    80005c8c:	4501                	li	a0,0
    80005c8e:	ffffd097          	auipc	ra,0xffffd
    80005c92:	370080e7          	jalr	880(ra) # 80002ffe <argstr>
    80005c96:	04054a63          	bltz	a0,80005cea <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005c9a:	f6c40593          	addi	a1,s0,-148
    80005c9e:	4505                	li	a0,1
    80005ca0:	ffffd097          	auipc	ra,0xffffd
    80005ca4:	31a080e7          	jalr	794(ra) # 80002fba <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005ca8:	04054163          	bltz	a0,80005cea <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005cac:	f6840593          	addi	a1,s0,-152
    80005cb0:	4509                	li	a0,2
    80005cb2:	ffffd097          	auipc	ra,0xffffd
    80005cb6:	308080e7          	jalr	776(ra) # 80002fba <argint>
     argint(1, &major) < 0 ||
    80005cba:	02054863          	bltz	a0,80005cea <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005cbe:	f6841683          	lh	a3,-152(s0)
    80005cc2:	f6c41603          	lh	a2,-148(s0)
    80005cc6:	458d                	li	a1,3
    80005cc8:	f7040513          	addi	a0,s0,-144
    80005ccc:	fffff097          	auipc	ra,0xfffff
    80005cd0:	798080e7          	jalr	1944(ra) # 80005464 <create>
     argint(2, &minor) < 0 ||
    80005cd4:	c919                	beqz	a0,80005cea <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005cd6:	ffffe097          	auipc	ra,0xffffe
    80005cda:	0b6080e7          	jalr	182(ra) # 80003d8c <iunlockput>
  end_op();
    80005cde:	fffff097          	auipc	ra,0xfffff
    80005ce2:	886080e7          	jalr	-1914(ra) # 80004564 <end_op>
  return 0;
    80005ce6:	4501                	li	a0,0
    80005ce8:	a031                	j	80005cf4 <sys_mknod+0x80>
    end_op();
    80005cea:	fffff097          	auipc	ra,0xfffff
    80005cee:	87a080e7          	jalr	-1926(ra) # 80004564 <end_op>
    return -1;
    80005cf2:	557d                	li	a0,-1
}
    80005cf4:	60ea                	ld	ra,152(sp)
    80005cf6:	644a                	ld	s0,144(sp)
    80005cf8:	610d                	addi	sp,sp,160
    80005cfa:	8082                	ret

0000000080005cfc <sys_chdir>:

uint64
sys_chdir(void)
{
    80005cfc:	7135                	addi	sp,sp,-160
    80005cfe:	ed06                	sd	ra,152(sp)
    80005d00:	e922                	sd	s0,144(sp)
    80005d02:	e526                	sd	s1,136(sp)
    80005d04:	e14a                	sd	s2,128(sp)
    80005d06:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005d08:	ffffc097          	auipc	ra,0xffffc
    80005d0c:	d00080e7          	jalr	-768(ra) # 80001a08 <myproc>
    80005d10:	892a                	mv	s2,a0
  
  begin_op();
    80005d12:	ffffe097          	auipc	ra,0xffffe
    80005d16:	7d2080e7          	jalr	2002(ra) # 800044e4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005d1a:	08000613          	li	a2,128
    80005d1e:	f6040593          	addi	a1,s0,-160
    80005d22:	4501                	li	a0,0
    80005d24:	ffffd097          	auipc	ra,0xffffd
    80005d28:	2da080e7          	jalr	730(ra) # 80002ffe <argstr>
    80005d2c:	04054b63          	bltz	a0,80005d82 <sys_chdir+0x86>
    80005d30:	f6040513          	addi	a0,s0,-160
    80005d34:	ffffe097          	auipc	ra,0xffffe
    80005d38:	5a4080e7          	jalr	1444(ra) # 800042d8 <namei>
    80005d3c:	84aa                	mv	s1,a0
    80005d3e:	c131                	beqz	a0,80005d82 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005d40:	ffffe097          	auipc	ra,0xffffe
    80005d44:	e0e080e7          	jalr	-498(ra) # 80003b4e <ilock>
  if(ip->type != T_DIR){
    80005d48:	04449703          	lh	a4,68(s1)
    80005d4c:	4785                	li	a5,1
    80005d4e:	04f71063          	bne	a4,a5,80005d8e <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005d52:	8526                	mv	a0,s1
    80005d54:	ffffe097          	auipc	ra,0xffffe
    80005d58:	ebc080e7          	jalr	-324(ra) # 80003c10 <iunlock>
  iput(p->cwd);
    80005d5c:	14093503          	ld	a0,320(s2)
    80005d60:	ffffe097          	auipc	ra,0xffffe
    80005d64:	efc080e7          	jalr	-260(ra) # 80003c5c <iput>
  end_op();
    80005d68:	ffffe097          	auipc	ra,0xffffe
    80005d6c:	7fc080e7          	jalr	2044(ra) # 80004564 <end_op>
  p->cwd = ip;
    80005d70:	14993023          	sd	s1,320(s2)
  return 0;
    80005d74:	4501                	li	a0,0
}
    80005d76:	60ea                	ld	ra,152(sp)
    80005d78:	644a                	ld	s0,144(sp)
    80005d7a:	64aa                	ld	s1,136(sp)
    80005d7c:	690a                	ld	s2,128(sp)
    80005d7e:	610d                	addi	sp,sp,160
    80005d80:	8082                	ret
    end_op();
    80005d82:	ffffe097          	auipc	ra,0xffffe
    80005d86:	7e2080e7          	jalr	2018(ra) # 80004564 <end_op>
    return -1;
    80005d8a:	557d                	li	a0,-1
    80005d8c:	b7ed                	j	80005d76 <sys_chdir+0x7a>
    iunlockput(ip);
    80005d8e:	8526                	mv	a0,s1
    80005d90:	ffffe097          	auipc	ra,0xffffe
    80005d94:	ffc080e7          	jalr	-4(ra) # 80003d8c <iunlockput>
    end_op();
    80005d98:	ffffe097          	auipc	ra,0xffffe
    80005d9c:	7cc080e7          	jalr	1996(ra) # 80004564 <end_op>
    return -1;
    80005da0:	557d                	li	a0,-1
    80005da2:	bfd1                	j	80005d76 <sys_chdir+0x7a>

0000000080005da4 <sys_exec>:

uint64
sys_exec(void)
{
    80005da4:	7145                	addi	sp,sp,-464
    80005da6:	e786                	sd	ra,456(sp)
    80005da8:	e3a2                	sd	s0,448(sp)
    80005daa:	ff26                	sd	s1,440(sp)
    80005dac:	fb4a                	sd	s2,432(sp)
    80005dae:	f74e                	sd	s3,424(sp)
    80005db0:	f352                	sd	s4,416(sp)
    80005db2:	ef56                	sd	s5,408(sp)
    80005db4:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005db6:	08000613          	li	a2,128
    80005dba:	f4040593          	addi	a1,s0,-192
    80005dbe:	4501                	li	a0,0
    80005dc0:	ffffd097          	auipc	ra,0xffffd
    80005dc4:	23e080e7          	jalr	574(ra) # 80002ffe <argstr>
    80005dc8:	0e054663          	bltz	a0,80005eb4 <sys_exec+0x110>
    80005dcc:	e3840593          	addi	a1,s0,-456
    80005dd0:	4505                	li	a0,1
    80005dd2:	ffffd097          	auipc	ra,0xffffd
    80005dd6:	20a080e7          	jalr	522(ra) # 80002fdc <argaddr>
    80005dda:	0e054763          	bltz	a0,80005ec8 <sys_exec+0x124>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    80005dde:	10000613          	li	a2,256
    80005de2:	4581                	li	a1,0
    80005de4:	e4040513          	addi	a0,s0,-448
    80005de8:	ffffb097          	auipc	ra,0xffffb
    80005dec:	d86080e7          	jalr	-634(ra) # 80000b6e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005df0:	e4040913          	addi	s2,s0,-448
  memset(argv, 0, sizeof(argv));
    80005df4:	89ca                	mv	s3,s2
    80005df6:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    80005df8:	02000a13          	li	s4,32
    80005dfc:	00048a9b          	sext.w	s5,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005e00:	00349513          	slli	a0,s1,0x3
    80005e04:	e3040593          	addi	a1,s0,-464
    80005e08:	e3843783          	ld	a5,-456(s0)
    80005e0c:	953e                	add	a0,a0,a5
    80005e0e:	ffffd097          	auipc	ra,0xffffd
    80005e12:	112080e7          	jalr	274(ra) # 80002f20 <fetchaddr>
    80005e16:	02054a63          	bltz	a0,80005e4a <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005e1a:	e3043783          	ld	a5,-464(s0)
    80005e1e:	c7a1                	beqz	a5,80005e66 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005e20:	ffffb097          	auipc	ra,0xffffb
    80005e24:	b40080e7          	jalr	-1216(ra) # 80000960 <kalloc>
    80005e28:	85aa                	mv	a1,a0
    80005e2a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005e2e:	c92d                	beqz	a0,80005ea0 <sys_exec+0xfc>
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
    80005e30:	6605                	lui	a2,0x1
    80005e32:	e3043503          	ld	a0,-464(s0)
    80005e36:	ffffd097          	auipc	ra,0xffffd
    80005e3a:	13c080e7          	jalr	316(ra) # 80002f72 <fetchstr>
    80005e3e:	00054663          	bltz	a0,80005e4a <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005e42:	0485                	addi	s1,s1,1
    80005e44:	09a1                	addi	s3,s3,8
    80005e46:	fb449be3          	bne	s1,s4,80005dfc <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e4a:	10090493          	addi	s1,s2,256
    80005e4e:	00093503          	ld	a0,0(s2)
    80005e52:	cd39                	beqz	a0,80005eb0 <sys_exec+0x10c>
    kfree(argv[i]);
    80005e54:	ffffb097          	auipc	ra,0xffffb
    80005e58:	a10080e7          	jalr	-1520(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e5c:	0921                	addi	s2,s2,8
    80005e5e:	fe9918e3          	bne	s2,s1,80005e4e <sys_exec+0xaa>
  return -1;
    80005e62:	557d                	li	a0,-1
    80005e64:	a889                	j	80005eb6 <sys_exec+0x112>
      argv[i] = 0;
    80005e66:	0a8e                	slli	s5,s5,0x3
    80005e68:	fc040793          	addi	a5,s0,-64
    80005e6c:	9abe                	add	s5,s5,a5
    80005e6e:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8e5c>
  int ret = exec(path, argv);
    80005e72:	e4040593          	addi	a1,s0,-448
    80005e76:	f4040513          	addi	a0,s0,-192
    80005e7a:	fffff097          	auipc	ra,0xfffff
    80005e7e:	1de080e7          	jalr	478(ra) # 80005058 <exec>
    80005e82:	84aa                	mv	s1,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e84:	10090993          	addi	s3,s2,256
    80005e88:	00093503          	ld	a0,0(s2)
    80005e8c:	c901                	beqz	a0,80005e9c <sys_exec+0xf8>
    kfree(argv[i]);
    80005e8e:	ffffb097          	auipc	ra,0xffffb
    80005e92:	9d6080e7          	jalr	-1578(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e96:	0921                	addi	s2,s2,8
    80005e98:	ff3918e3          	bne	s2,s3,80005e88 <sys_exec+0xe4>
  return ret;
    80005e9c:	8526                	mv	a0,s1
    80005e9e:	a821                	j	80005eb6 <sys_exec+0x112>
      panic("sys_exec kalloc");
    80005ea0:	00002517          	auipc	a0,0x2
    80005ea4:	a4850513          	addi	a0,a0,-1464 # 800078e8 <userret+0x858>
    80005ea8:	ffffa097          	auipc	ra,0xffffa
    80005eac:	6a6080e7          	jalr	1702(ra) # 8000054e <panic>
  return -1;
    80005eb0:	557d                	li	a0,-1
    80005eb2:	a011                	j	80005eb6 <sys_exec+0x112>
    return -1;
    80005eb4:	557d                	li	a0,-1
}
    80005eb6:	60be                	ld	ra,456(sp)
    80005eb8:	641e                	ld	s0,448(sp)
    80005eba:	74fa                	ld	s1,440(sp)
    80005ebc:	795a                	ld	s2,432(sp)
    80005ebe:	79ba                	ld	s3,424(sp)
    80005ec0:	7a1a                	ld	s4,416(sp)
    80005ec2:	6afa                	ld	s5,408(sp)
    80005ec4:	6179                	addi	sp,sp,464
    80005ec6:	8082                	ret
    return -1;
    80005ec8:	557d                	li	a0,-1
    80005eca:	b7f5                	j	80005eb6 <sys_exec+0x112>

0000000080005ecc <sys_pipe>:

uint64
sys_pipe(void)
{
    80005ecc:	7139                	addi	sp,sp,-64
    80005ece:	fc06                	sd	ra,56(sp)
    80005ed0:	f822                	sd	s0,48(sp)
    80005ed2:	f426                	sd	s1,40(sp)
    80005ed4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005ed6:	ffffc097          	auipc	ra,0xffffc
    80005eda:	b32080e7          	jalr	-1230(ra) # 80001a08 <myproc>
    80005ede:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005ee0:	fd840593          	addi	a1,s0,-40
    80005ee4:	4501                	li	a0,0
    80005ee6:	ffffd097          	auipc	ra,0xffffd
    80005eea:	0f6080e7          	jalr	246(ra) # 80002fdc <argaddr>
    return -1;
    80005eee:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005ef0:	0e054063          	bltz	a0,80005fd0 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005ef4:	fc840593          	addi	a1,s0,-56
    80005ef8:	fd040513          	addi	a0,s0,-48
    80005efc:	fffff097          	auipc	ra,0xfffff
    80005f00:	e10080e7          	jalr	-496(ra) # 80004d0c <pipealloc>
    return -1;
    80005f04:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005f06:	0c054563          	bltz	a0,80005fd0 <sys_pipe+0x104>
  fd0 = -1;
    80005f0a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005f0e:	fd043503          	ld	a0,-48(s0)
    80005f12:	fffff097          	auipc	ra,0xfffff
    80005f16:	510080e7          	jalr	1296(ra) # 80005422 <fdalloc>
    80005f1a:	fca42223          	sw	a0,-60(s0)
    80005f1e:	08054c63          	bltz	a0,80005fb6 <sys_pipe+0xea>
    80005f22:	fc843503          	ld	a0,-56(s0)
    80005f26:	fffff097          	auipc	ra,0xfffff
    80005f2a:	4fc080e7          	jalr	1276(ra) # 80005422 <fdalloc>
    80005f2e:	fca42023          	sw	a0,-64(s0)
    80005f32:	06054863          	bltz	a0,80005fa2 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005f36:	4691                	li	a3,4
    80005f38:	fc440613          	addi	a2,s0,-60
    80005f3c:	fd843583          	ld	a1,-40(s0)
    80005f40:	60a8                	ld	a0,64(s1)
    80005f42:	ffffb097          	auipc	ra,0xffffb
    80005f46:	7b4080e7          	jalr	1972(ra) # 800016f6 <copyout>
    80005f4a:	02054063          	bltz	a0,80005f6a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005f4e:	4691                	li	a3,4
    80005f50:	fc040613          	addi	a2,s0,-64
    80005f54:	fd843583          	ld	a1,-40(s0)
    80005f58:	0591                	addi	a1,a1,4
    80005f5a:	60a8                	ld	a0,64(s1)
    80005f5c:	ffffb097          	auipc	ra,0xffffb
    80005f60:	79a080e7          	jalr	1946(ra) # 800016f6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005f64:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005f66:	06055563          	bgez	a0,80005fd0 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005f6a:	fc442783          	lw	a5,-60(s0)
    80005f6e:	07e1                	addi	a5,a5,24
    80005f70:	078e                	slli	a5,a5,0x3
    80005f72:	97a6                	add	a5,a5,s1
    80005f74:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005f78:	fc042503          	lw	a0,-64(s0)
    80005f7c:	0561                	addi	a0,a0,24
    80005f7e:	050e                	slli	a0,a0,0x3
    80005f80:	9526                	add	a0,a0,s1
    80005f82:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005f86:	fd043503          	ld	a0,-48(s0)
    80005f8a:	fffff097          	auipc	ra,0xfffff
    80005f8e:	a2c080e7          	jalr	-1492(ra) # 800049b6 <fileclose>
    fileclose(wf);
    80005f92:	fc843503          	ld	a0,-56(s0)
    80005f96:	fffff097          	auipc	ra,0xfffff
    80005f9a:	a20080e7          	jalr	-1504(ra) # 800049b6 <fileclose>
    return -1;
    80005f9e:	57fd                	li	a5,-1
    80005fa0:	a805                	j	80005fd0 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005fa2:	fc442783          	lw	a5,-60(s0)
    80005fa6:	0007c863          	bltz	a5,80005fb6 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005faa:	01878513          	addi	a0,a5,24
    80005fae:	050e                	slli	a0,a0,0x3
    80005fb0:	9526                	add	a0,a0,s1
    80005fb2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005fb6:	fd043503          	ld	a0,-48(s0)
    80005fba:	fffff097          	auipc	ra,0xfffff
    80005fbe:	9fc080e7          	jalr	-1540(ra) # 800049b6 <fileclose>
    fileclose(wf);
    80005fc2:	fc843503          	ld	a0,-56(s0)
    80005fc6:	fffff097          	auipc	ra,0xfffff
    80005fca:	9f0080e7          	jalr	-1552(ra) # 800049b6 <fileclose>
    return -1;
    80005fce:	57fd                	li	a5,-1
}
    80005fd0:	853e                	mv	a0,a5
    80005fd2:	70e2                	ld	ra,56(sp)
    80005fd4:	7442                	ld	s0,48(sp)
    80005fd6:	74a2                	ld	s1,40(sp)
    80005fd8:	6121                	addi	sp,sp,64
    80005fda:	8082                	ret
    80005fdc:	0000                	unimp
	...

0000000080005fe0 <kernelvec>:
    80005fe0:	7111                	addi	sp,sp,-256
    80005fe2:	e006                	sd	ra,0(sp)
    80005fe4:	e40a                	sd	sp,8(sp)
    80005fe6:	e80e                	sd	gp,16(sp)
    80005fe8:	ec12                	sd	tp,24(sp)
    80005fea:	f016                	sd	t0,32(sp)
    80005fec:	f41a                	sd	t1,40(sp)
    80005fee:	f81e                	sd	t2,48(sp)
    80005ff0:	fc22                	sd	s0,56(sp)
    80005ff2:	e0a6                	sd	s1,64(sp)
    80005ff4:	e4aa                	sd	a0,72(sp)
    80005ff6:	e8ae                	sd	a1,80(sp)
    80005ff8:	ecb2                	sd	a2,88(sp)
    80005ffa:	f0b6                	sd	a3,96(sp)
    80005ffc:	f4ba                	sd	a4,104(sp)
    80005ffe:	f8be                	sd	a5,112(sp)
    80006000:	fcc2                	sd	a6,120(sp)
    80006002:	e146                	sd	a7,128(sp)
    80006004:	e54a                	sd	s2,136(sp)
    80006006:	e94e                	sd	s3,144(sp)
    80006008:	ed52                	sd	s4,152(sp)
    8000600a:	f156                	sd	s5,160(sp)
    8000600c:	f55a                	sd	s6,168(sp)
    8000600e:	f95e                	sd	s7,176(sp)
    80006010:	fd62                	sd	s8,184(sp)
    80006012:	e1e6                	sd	s9,192(sp)
    80006014:	e5ea                	sd	s10,200(sp)
    80006016:	e9ee                	sd	s11,208(sp)
    80006018:	edf2                	sd	t3,216(sp)
    8000601a:	f1f6                	sd	t4,224(sp)
    8000601c:	f5fa                	sd	t5,232(sp)
    8000601e:	f9fe                	sd	t6,240(sp)
    80006020:	dcdfc0ef          	jal	ra,80002dec <kerneltrap>
    80006024:	6082                	ld	ra,0(sp)
    80006026:	6122                	ld	sp,8(sp)
    80006028:	61c2                	ld	gp,16(sp)
    8000602a:	7282                	ld	t0,32(sp)
    8000602c:	7322                	ld	t1,40(sp)
    8000602e:	73c2                	ld	t2,48(sp)
    80006030:	7462                	ld	s0,56(sp)
    80006032:	6486                	ld	s1,64(sp)
    80006034:	6526                	ld	a0,72(sp)
    80006036:	65c6                	ld	a1,80(sp)
    80006038:	6666                	ld	a2,88(sp)
    8000603a:	7686                	ld	a3,96(sp)
    8000603c:	7726                	ld	a4,104(sp)
    8000603e:	77c6                	ld	a5,112(sp)
    80006040:	7866                	ld	a6,120(sp)
    80006042:	688a                	ld	a7,128(sp)
    80006044:	692a                	ld	s2,136(sp)
    80006046:	69ca                	ld	s3,144(sp)
    80006048:	6a6a                	ld	s4,152(sp)
    8000604a:	7a8a                	ld	s5,160(sp)
    8000604c:	7b2a                	ld	s6,168(sp)
    8000604e:	7bca                	ld	s7,176(sp)
    80006050:	7c6a                	ld	s8,184(sp)
    80006052:	6c8e                	ld	s9,192(sp)
    80006054:	6d2e                	ld	s10,200(sp)
    80006056:	6dce                	ld	s11,208(sp)
    80006058:	6e6e                	ld	t3,216(sp)
    8000605a:	7e8e                	ld	t4,224(sp)
    8000605c:	7f2e                	ld	t5,232(sp)
    8000605e:	7fce                	ld	t6,240(sp)
    80006060:	6111                	addi	sp,sp,256
    80006062:	10200073          	sret
    80006066:	00000013          	nop
    8000606a:	00000013          	nop
    8000606e:	0001                	nop

0000000080006070 <timervec>:
    80006070:	34051573          	csrrw	a0,mscratch,a0
    80006074:	e10c                	sd	a1,0(a0)
    80006076:	e510                	sd	a2,8(a0)
    80006078:	e914                	sd	a3,16(a0)
    8000607a:	710c                	ld	a1,32(a0)
    8000607c:	7510                	ld	a2,40(a0)
    8000607e:	6194                	ld	a3,0(a1)
    80006080:	96b2                	add	a3,a3,a2
    80006082:	e194                	sd	a3,0(a1)
    80006084:	4589                	li	a1,2
    80006086:	14459073          	csrw	sip,a1
    8000608a:	6914                	ld	a3,16(a0)
    8000608c:	6510                	ld	a2,8(a0)
    8000608e:	610c                	ld	a1,0(a0)
    80006090:	34051573          	csrrw	a0,mscratch,a0
    80006094:	30200073          	mret
	...

000000008000609a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000609a:	1141                	addi	sp,sp,-16
    8000609c:	e422                	sd	s0,8(sp)
    8000609e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800060a0:	0c0007b7          	lui	a5,0xc000
    800060a4:	4705                	li	a4,1
    800060a6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800060a8:	c3d8                	sw	a4,4(a5)
}
    800060aa:	6422                	ld	s0,8(sp)
    800060ac:	0141                	addi	sp,sp,16
    800060ae:	8082                	ret

00000000800060b0 <plicinithart>:

void
plicinithart(void)
{
    800060b0:	1141                	addi	sp,sp,-16
    800060b2:	e406                	sd	ra,8(sp)
    800060b4:	e022                	sd	s0,0(sp)
    800060b6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800060b8:	ffffc097          	auipc	ra,0xffffc
    800060bc:	924080e7          	jalr	-1756(ra) # 800019dc <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800060c0:	0085171b          	slliw	a4,a0,0x8
    800060c4:	0c0027b7          	lui	a5,0xc002
    800060c8:	97ba                	add	a5,a5,a4
    800060ca:	40200713          	li	a4,1026
    800060ce:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800060d2:	00d5151b          	slliw	a0,a0,0xd
    800060d6:	0c2017b7          	lui	a5,0xc201
    800060da:	953e                	add	a0,a0,a5
    800060dc:	00052023          	sw	zero,0(a0)
}
    800060e0:	60a2                	ld	ra,8(sp)
    800060e2:	6402                	ld	s0,0(sp)
    800060e4:	0141                	addi	sp,sp,16
    800060e6:	8082                	ret

00000000800060e8 <plic_pending>:

// return a bitmap of which IRQs are waiting
// to be served.
uint64
plic_pending(void)
{
    800060e8:	1141                	addi	sp,sp,-16
    800060ea:	e422                	sd	s0,8(sp)
    800060ec:	0800                	addi	s0,sp,16
  //mask = *(uint32*)(PLIC + 0x1000);
  //mask |= (uint64)*(uint32*)(PLIC + 0x1004) << 32;
  mask = *(uint64*)PLIC_PENDING;

  return mask;
}
    800060ee:	0c0017b7          	lui	a5,0xc001
    800060f2:	6388                	ld	a0,0(a5)
    800060f4:	6422                	ld	s0,8(sp)
    800060f6:	0141                	addi	sp,sp,16
    800060f8:	8082                	ret

00000000800060fa <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800060fa:	1141                	addi	sp,sp,-16
    800060fc:	e406                	sd	ra,8(sp)
    800060fe:	e022                	sd	s0,0(sp)
    80006100:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006102:	ffffc097          	auipc	ra,0xffffc
    80006106:	8da080e7          	jalr	-1830(ra) # 800019dc <cpuid>
  //int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000610a:	00d5179b          	slliw	a5,a0,0xd
    8000610e:	0c201537          	lui	a0,0xc201
    80006112:	953e                	add	a0,a0,a5
  return irq;
}
    80006114:	4148                	lw	a0,4(a0)
    80006116:	60a2                	ld	ra,8(sp)
    80006118:	6402                	ld	s0,0(sp)
    8000611a:	0141                	addi	sp,sp,16
    8000611c:	8082                	ret

000000008000611e <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000611e:	1101                	addi	sp,sp,-32
    80006120:	ec06                	sd	ra,24(sp)
    80006122:	e822                	sd	s0,16(sp)
    80006124:	e426                	sd	s1,8(sp)
    80006126:	1000                	addi	s0,sp,32
    80006128:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000612a:	ffffc097          	auipc	ra,0xffffc
    8000612e:	8b2080e7          	jalr	-1870(ra) # 800019dc <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006132:	00d5151b          	slliw	a0,a0,0xd
    80006136:	0c2017b7          	lui	a5,0xc201
    8000613a:	97aa                	add	a5,a5,a0
    8000613c:	c3c4                	sw	s1,4(a5)
}
    8000613e:	60e2                	ld	ra,24(sp)
    80006140:	6442                	ld	s0,16(sp)
    80006142:	64a2                	ld	s1,8(sp)
    80006144:	6105                	addi	sp,sp,32
    80006146:	8082                	ret

0000000080006148 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006148:	1141                	addi	sp,sp,-16
    8000614a:	e406                	sd	ra,8(sp)
    8000614c:	e022                	sd	s0,0(sp)
    8000614e:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006150:	479d                	li	a5,7
    80006152:	04a7cc63          	blt	a5,a0,800061aa <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80006156:	0001d797          	auipc	a5,0x1d
    8000615a:	eaa78793          	addi	a5,a5,-342 # 80023000 <disk>
    8000615e:	00a78733          	add	a4,a5,a0
    80006162:	6789                	lui	a5,0x2
    80006164:	97ba                	add	a5,a5,a4
    80006166:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000616a:	eba1                	bnez	a5,800061ba <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    8000616c:	00451713          	slli	a4,a0,0x4
    80006170:	0001f797          	auipc	a5,0x1f
    80006174:	e907b783          	ld	a5,-368(a5) # 80025000 <disk+0x2000>
    80006178:	97ba                	add	a5,a5,a4
    8000617a:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    8000617e:	0001d797          	auipc	a5,0x1d
    80006182:	e8278793          	addi	a5,a5,-382 # 80023000 <disk>
    80006186:	97aa                	add	a5,a5,a0
    80006188:	6509                	lui	a0,0x2
    8000618a:	953e                	add	a0,a0,a5
    8000618c:	4785                	li	a5,1
    8000618e:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80006192:	0001f517          	auipc	a0,0x1f
    80006196:	e8650513          	addi	a0,a0,-378 # 80025018 <disk+0x2018>
    8000619a:	ffffc097          	auipc	ra,0xffffc
    8000619e:	6a2080e7          	jalr	1698(ra) # 8000283c <wakeup>
}
    800061a2:	60a2                	ld	ra,8(sp)
    800061a4:	6402                	ld	s0,0(sp)
    800061a6:	0141                	addi	sp,sp,16
    800061a8:	8082                	ret
    panic("virtio_disk_intr 1");
    800061aa:	00001517          	auipc	a0,0x1
    800061ae:	74e50513          	addi	a0,a0,1870 # 800078f8 <userret+0x868>
    800061b2:	ffffa097          	auipc	ra,0xffffa
    800061b6:	39c080e7          	jalr	924(ra) # 8000054e <panic>
    panic("virtio_disk_intr 2");
    800061ba:	00001517          	auipc	a0,0x1
    800061be:	75650513          	addi	a0,a0,1878 # 80007910 <userret+0x880>
    800061c2:	ffffa097          	auipc	ra,0xffffa
    800061c6:	38c080e7          	jalr	908(ra) # 8000054e <panic>

00000000800061ca <virtio_disk_init>:
{
    800061ca:	1101                	addi	sp,sp,-32
    800061cc:	ec06                	sd	ra,24(sp)
    800061ce:	e822                	sd	s0,16(sp)
    800061d0:	e426                	sd	s1,8(sp)
    800061d2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800061d4:	00001597          	auipc	a1,0x1
    800061d8:	75458593          	addi	a1,a1,1876 # 80007928 <userret+0x898>
    800061dc:	0001f517          	auipc	a0,0x1f
    800061e0:	ecc50513          	addi	a0,a0,-308 # 800250a8 <disk+0x20a8>
    800061e4:	ffffa097          	auipc	ra,0xffffa
    800061e8:	7dc080e7          	jalr	2012(ra) # 800009c0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800061ec:	100017b7          	lui	a5,0x10001
    800061f0:	4398                	lw	a4,0(a5)
    800061f2:	2701                	sext.w	a4,a4
    800061f4:	747277b7          	lui	a5,0x74727
    800061f8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800061fc:	0ef71163          	bne	a4,a5,800062de <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006200:	100017b7          	lui	a5,0x10001
    80006204:	43dc                	lw	a5,4(a5)
    80006206:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006208:	4705                	li	a4,1
    8000620a:	0ce79a63          	bne	a5,a4,800062de <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000620e:	100017b7          	lui	a5,0x10001
    80006212:	479c                	lw	a5,8(a5)
    80006214:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006216:	4709                	li	a4,2
    80006218:	0ce79363          	bne	a5,a4,800062de <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000621c:	100017b7          	lui	a5,0x10001
    80006220:	47d8                	lw	a4,12(a5)
    80006222:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006224:	554d47b7          	lui	a5,0x554d4
    80006228:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000622c:	0af71963          	bne	a4,a5,800062de <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006230:	100017b7          	lui	a5,0x10001
    80006234:	4705                	li	a4,1
    80006236:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006238:	470d                	li	a4,3
    8000623a:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000623c:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000623e:	c7ffe737          	lui	a4,0xc7ffe
    80006242:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd873b>
    80006246:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006248:	2701                	sext.w	a4,a4
    8000624a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000624c:	472d                	li	a4,11
    8000624e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006250:	473d                	li	a4,15
    80006252:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006254:	6705                	lui	a4,0x1
    80006256:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006258:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000625c:	5bdc                	lw	a5,52(a5)
    8000625e:	2781                	sext.w	a5,a5
  if(max == 0)
    80006260:	c7d9                	beqz	a5,800062ee <virtio_disk_init+0x124>
  if(max < NUM)
    80006262:	471d                	li	a4,7
    80006264:	08f77d63          	bgeu	a4,a5,800062fe <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006268:	100014b7          	lui	s1,0x10001
    8000626c:	47a1                	li	a5,8
    8000626e:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80006270:	6609                	lui	a2,0x2
    80006272:	4581                	li	a1,0
    80006274:	0001d517          	auipc	a0,0x1d
    80006278:	d8c50513          	addi	a0,a0,-628 # 80023000 <disk>
    8000627c:	ffffb097          	auipc	ra,0xffffb
    80006280:	8f2080e7          	jalr	-1806(ra) # 80000b6e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006284:	0001d717          	auipc	a4,0x1d
    80006288:	d7c70713          	addi	a4,a4,-644 # 80023000 <disk>
    8000628c:	00c75793          	srli	a5,a4,0xc
    80006290:	2781                	sext.w	a5,a5
    80006292:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80006294:	0001f797          	auipc	a5,0x1f
    80006298:	d6c78793          	addi	a5,a5,-660 # 80025000 <disk+0x2000>
    8000629c:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    8000629e:	0001d717          	auipc	a4,0x1d
    800062a2:	de270713          	addi	a4,a4,-542 # 80023080 <disk+0x80>
    800062a6:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    800062a8:	0001e717          	auipc	a4,0x1e
    800062ac:	d5870713          	addi	a4,a4,-680 # 80024000 <disk+0x1000>
    800062b0:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800062b2:	4705                	li	a4,1
    800062b4:	00e78c23          	sb	a4,24(a5)
    800062b8:	00e78ca3          	sb	a4,25(a5)
    800062bc:	00e78d23          	sb	a4,26(a5)
    800062c0:	00e78da3          	sb	a4,27(a5)
    800062c4:	00e78e23          	sb	a4,28(a5)
    800062c8:	00e78ea3          	sb	a4,29(a5)
    800062cc:	00e78f23          	sb	a4,30(a5)
    800062d0:	00e78fa3          	sb	a4,31(a5)
}
    800062d4:	60e2                	ld	ra,24(sp)
    800062d6:	6442                	ld	s0,16(sp)
    800062d8:	64a2                	ld	s1,8(sp)
    800062da:	6105                	addi	sp,sp,32
    800062dc:	8082                	ret
    panic("could not find virtio disk");
    800062de:	00001517          	auipc	a0,0x1
    800062e2:	65a50513          	addi	a0,a0,1626 # 80007938 <userret+0x8a8>
    800062e6:	ffffa097          	auipc	ra,0xffffa
    800062ea:	268080e7          	jalr	616(ra) # 8000054e <panic>
    panic("virtio disk has no queue 0");
    800062ee:	00001517          	auipc	a0,0x1
    800062f2:	66a50513          	addi	a0,a0,1642 # 80007958 <userret+0x8c8>
    800062f6:	ffffa097          	auipc	ra,0xffffa
    800062fa:	258080e7          	jalr	600(ra) # 8000054e <panic>
    panic("virtio disk max queue too short");
    800062fe:	00001517          	auipc	a0,0x1
    80006302:	67a50513          	addi	a0,a0,1658 # 80007978 <userret+0x8e8>
    80006306:	ffffa097          	auipc	ra,0xffffa
    8000630a:	248080e7          	jalr	584(ra) # 8000054e <panic>

000000008000630e <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000630e:	7119                	addi	sp,sp,-128
    80006310:	fc86                	sd	ra,120(sp)
    80006312:	f8a2                	sd	s0,112(sp)
    80006314:	f4a6                	sd	s1,104(sp)
    80006316:	f0ca                	sd	s2,96(sp)
    80006318:	ecce                	sd	s3,88(sp)
    8000631a:	e8d2                	sd	s4,80(sp)
    8000631c:	e4d6                	sd	s5,72(sp)
    8000631e:	e0da                	sd	s6,64(sp)
    80006320:	fc5e                	sd	s7,56(sp)
    80006322:	f862                	sd	s8,48(sp)
    80006324:	f466                	sd	s9,40(sp)
    80006326:	f06a                	sd	s10,32(sp)
    80006328:	0100                	addi	s0,sp,128
    8000632a:	892a                	mv	s2,a0
    8000632c:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000632e:	00c52c83          	lw	s9,12(a0)
    80006332:	001c9c9b          	slliw	s9,s9,0x1
    80006336:	1c82                	slli	s9,s9,0x20
    80006338:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000633c:	0001f517          	auipc	a0,0x1f
    80006340:	d6c50513          	addi	a0,a0,-660 # 800250a8 <disk+0x20a8>
    80006344:	ffffa097          	auipc	ra,0xffffa
    80006348:	78e080e7          	jalr	1934(ra) # 80000ad2 <acquire>
  for(int i = 0; i < 3; i++){
    8000634c:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000634e:	4c21                	li	s8,8
      disk.free[i] = 0;
    80006350:	0001db97          	auipc	s7,0x1d
    80006354:	cb0b8b93          	addi	s7,s7,-848 # 80023000 <disk>
    80006358:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000635a:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    8000635c:	8a4e                	mv	s4,s3
    8000635e:	a051                	j	800063e2 <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80006360:	00fb86b3          	add	a3,s7,a5
    80006364:	96da                	add	a3,a3,s6
    80006366:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    8000636a:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000636c:	0207c563          	bltz	a5,80006396 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80006370:	2485                	addiw	s1,s1,1
    80006372:	0711                	addi	a4,a4,4
    80006374:	1b548863          	beq	s1,s5,80006524 <virtio_disk_rw+0x216>
    idx[i] = alloc_desc();
    80006378:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    8000637a:	0001f697          	auipc	a3,0x1f
    8000637e:	c9e68693          	addi	a3,a3,-866 # 80025018 <disk+0x2018>
    80006382:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80006384:	0006c583          	lbu	a1,0(a3)
    80006388:	fde1                	bnez	a1,80006360 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000638a:	2785                	addiw	a5,a5,1
    8000638c:	0685                	addi	a3,a3,1
    8000638e:	ff879be3          	bne	a5,s8,80006384 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80006392:	57fd                	li	a5,-1
    80006394:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80006396:	02905a63          	blez	s1,800063ca <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    8000639a:	f9042503          	lw	a0,-112(s0)
    8000639e:	00000097          	auipc	ra,0x0
    800063a2:	daa080e7          	jalr	-598(ra) # 80006148 <free_desc>
      for(int j = 0; j < i; j++)
    800063a6:	4785                	li	a5,1
    800063a8:	0297d163          	bge	a5,s1,800063ca <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800063ac:	f9442503          	lw	a0,-108(s0)
    800063b0:	00000097          	auipc	ra,0x0
    800063b4:	d98080e7          	jalr	-616(ra) # 80006148 <free_desc>
      for(int j = 0; j < i; j++)
    800063b8:	4789                	li	a5,2
    800063ba:	0097d863          	bge	a5,s1,800063ca <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800063be:	f9842503          	lw	a0,-104(s0)
    800063c2:	00000097          	auipc	ra,0x0
    800063c6:	d86080e7          	jalr	-634(ra) # 80006148 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800063ca:	0001f597          	auipc	a1,0x1f
    800063ce:	cde58593          	addi	a1,a1,-802 # 800250a8 <disk+0x20a8>
    800063d2:	0001f517          	auipc	a0,0x1f
    800063d6:	c4650513          	addi	a0,a0,-954 # 80025018 <disk+0x2018>
    800063da:	ffffc097          	auipc	ra,0xffffc
    800063de:	266080e7          	jalr	614(ra) # 80002640 <sleep>
  for(int i = 0; i < 3; i++){
    800063e2:	f9040713          	addi	a4,s0,-112
    800063e6:	84ce                	mv	s1,s3
    800063e8:	bf41                	j	80006378 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800063ea:	0001f717          	auipc	a4,0x1f
    800063ee:	c1673703          	ld	a4,-1002(a4) # 80025000 <disk+0x2000>
    800063f2:	973e                	add	a4,a4,a5
    800063f4:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800063f8:	0001d517          	auipc	a0,0x1d
    800063fc:	c0850513          	addi	a0,a0,-1016 # 80023000 <disk>
    80006400:	0001f717          	auipc	a4,0x1f
    80006404:	c0070713          	addi	a4,a4,-1024 # 80025000 <disk+0x2000>
    80006408:	6310                	ld	a2,0(a4)
    8000640a:	963e                	add	a2,a2,a5
    8000640c:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006410:	0015e593          	ori	a1,a1,1
    80006414:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80006418:	f9842683          	lw	a3,-104(s0)
    8000641c:	6310                	ld	a2,0(a4)
    8000641e:	97b2                	add	a5,a5,a2
    80006420:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    80006424:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    80006428:	0612                	slli	a2,a2,0x4
    8000642a:	962a                	add	a2,a2,a0
    8000642c:	02060823          	sb	zero,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006430:	00469793          	slli	a5,a3,0x4
    80006434:	630c                	ld	a1,0(a4)
    80006436:	95be                	add	a1,a1,a5
    80006438:	6689                	lui	a3,0x2
    8000643a:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    8000643e:	96ce                	add	a3,a3,s3
    80006440:	96aa                	add	a3,a3,a0
    80006442:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    80006444:	6314                	ld	a3,0(a4)
    80006446:	96be                	add	a3,a3,a5
    80006448:	4585                	li	a1,1
    8000644a:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000644c:	6314                	ld	a3,0(a4)
    8000644e:	96be                	add	a3,a3,a5
    80006450:	4509                	li	a0,2
    80006452:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    80006456:	6314                	ld	a3,0(a4)
    80006458:	97b6                	add	a5,a5,a3
    8000645a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000645e:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80006462:	03263423          	sd	s2,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    80006466:	6714                	ld	a3,8(a4)
    80006468:	0026d783          	lhu	a5,2(a3)
    8000646c:	8b9d                	andi	a5,a5,7
    8000646e:	2789                	addiw	a5,a5,2
    80006470:	0786                	slli	a5,a5,0x1
    80006472:	97b6                	add	a5,a5,a3
    80006474:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    80006478:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    8000647c:	6718                	ld	a4,8(a4)
    8000647e:	00275783          	lhu	a5,2(a4)
    80006482:	2785                	addiw	a5,a5,1
    80006484:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006488:	100017b7          	lui	a5,0x10001
    8000648c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006490:	00492783          	lw	a5,4(s2)
    80006494:	02b79163          	bne	a5,a1,800064b6 <virtio_disk_rw+0x1a8>
    sleep(b, &disk.vdisk_lock);
    80006498:	0001f997          	auipc	s3,0x1f
    8000649c:	c1098993          	addi	s3,s3,-1008 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    800064a0:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800064a2:	85ce                	mv	a1,s3
    800064a4:	854a                	mv	a0,s2
    800064a6:	ffffc097          	auipc	ra,0xffffc
    800064aa:	19a080e7          	jalr	410(ra) # 80002640 <sleep>
  while(b->disk == 1) {
    800064ae:	00492783          	lw	a5,4(s2)
    800064b2:	fe9788e3          	beq	a5,s1,800064a2 <virtio_disk_rw+0x194>
  }

  disk.info[idx[0]].b = 0;
    800064b6:	f9042483          	lw	s1,-112(s0)
    800064ba:	20048793          	addi	a5,s1,512
    800064be:	00479713          	slli	a4,a5,0x4
    800064c2:	0001d797          	auipc	a5,0x1d
    800064c6:	b3e78793          	addi	a5,a5,-1218 # 80023000 <disk>
    800064ca:	97ba                	add	a5,a5,a4
    800064cc:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800064d0:	0001f917          	auipc	s2,0x1f
    800064d4:	b3090913          	addi	s2,s2,-1232 # 80025000 <disk+0x2000>
    free_desc(i);
    800064d8:	8526                	mv	a0,s1
    800064da:	00000097          	auipc	ra,0x0
    800064de:	c6e080e7          	jalr	-914(ra) # 80006148 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800064e2:	0492                	slli	s1,s1,0x4
    800064e4:	00093783          	ld	a5,0(s2)
    800064e8:	94be                	add	s1,s1,a5
    800064ea:	00c4d783          	lhu	a5,12(s1)
    800064ee:	8b85                	andi	a5,a5,1
    800064f0:	c781                	beqz	a5,800064f8 <virtio_disk_rw+0x1ea>
      i = disk.desc[i].next;
    800064f2:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    800064f6:	b7cd                	j	800064d8 <virtio_disk_rw+0x1ca>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800064f8:	0001f517          	auipc	a0,0x1f
    800064fc:	bb050513          	addi	a0,a0,-1104 # 800250a8 <disk+0x20a8>
    80006500:	ffffa097          	auipc	ra,0xffffa
    80006504:	626080e7          	jalr	1574(ra) # 80000b26 <release>
}
    80006508:	70e6                	ld	ra,120(sp)
    8000650a:	7446                	ld	s0,112(sp)
    8000650c:	74a6                	ld	s1,104(sp)
    8000650e:	7906                	ld	s2,96(sp)
    80006510:	69e6                	ld	s3,88(sp)
    80006512:	6a46                	ld	s4,80(sp)
    80006514:	6aa6                	ld	s5,72(sp)
    80006516:	6b06                	ld	s6,64(sp)
    80006518:	7be2                	ld	s7,56(sp)
    8000651a:	7c42                	ld	s8,48(sp)
    8000651c:	7ca2                	ld	s9,40(sp)
    8000651e:	7d02                	ld	s10,32(sp)
    80006520:	6109                	addi	sp,sp,128
    80006522:	8082                	ret
  if(write)
    80006524:	01a037b3          	snez	a5,s10
    80006528:	f8f42023          	sw	a5,-128(s0)
  buf0.reserved = 0;
    8000652c:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    80006530:	f9943423          	sd	s9,-120(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80006534:	f9042483          	lw	s1,-112(s0)
    80006538:	00449993          	slli	s3,s1,0x4
    8000653c:	0001fa17          	auipc	s4,0x1f
    80006540:	ac4a0a13          	addi	s4,s4,-1340 # 80025000 <disk+0x2000>
    80006544:	000a3a83          	ld	s5,0(s4)
    80006548:	9ace                	add	s5,s5,s3
    8000654a:	f8040513          	addi	a0,s0,-128
    8000654e:	ffffb097          	auipc	ra,0xffffb
    80006552:	c1c080e7          	jalr	-996(ra) # 8000116a <kvmpa>
    80006556:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    8000655a:	000a3783          	ld	a5,0(s4)
    8000655e:	97ce                	add	a5,a5,s3
    80006560:	4741                	li	a4,16
    80006562:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006564:	000a3783          	ld	a5,0(s4)
    80006568:	97ce                	add	a5,a5,s3
    8000656a:	4705                	li	a4,1
    8000656c:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006570:	f9442783          	lw	a5,-108(s0)
    80006574:	000a3703          	ld	a4,0(s4)
    80006578:	974e                	add	a4,a4,s3
    8000657a:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000657e:	0792                	slli	a5,a5,0x4
    80006580:	000a3703          	ld	a4,0(s4)
    80006584:	973e                	add	a4,a4,a5
    80006586:	06090693          	addi	a3,s2,96
    8000658a:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    8000658c:	000a3703          	ld	a4,0(s4)
    80006590:	973e                	add	a4,a4,a5
    80006592:	40000693          	li	a3,1024
    80006596:	c714                	sw	a3,8(a4)
  if(write)
    80006598:	e40d19e3          	bnez	s10,800063ea <virtio_disk_rw+0xdc>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000659c:	0001f717          	auipc	a4,0x1f
    800065a0:	a6473703          	ld	a4,-1436(a4) # 80025000 <disk+0x2000>
    800065a4:	973e                	add	a4,a4,a5
    800065a6:	4689                	li	a3,2
    800065a8:	00d71623          	sh	a3,12(a4)
    800065ac:	b5b1                	j	800063f8 <virtio_disk_rw+0xea>

00000000800065ae <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800065ae:	1101                	addi	sp,sp,-32
    800065b0:	ec06                	sd	ra,24(sp)
    800065b2:	e822                	sd	s0,16(sp)
    800065b4:	e426                	sd	s1,8(sp)
    800065b6:	e04a                	sd	s2,0(sp)
    800065b8:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800065ba:	0001f517          	auipc	a0,0x1f
    800065be:	aee50513          	addi	a0,a0,-1298 # 800250a8 <disk+0x20a8>
    800065c2:	ffffa097          	auipc	ra,0xffffa
    800065c6:	510080e7          	jalr	1296(ra) # 80000ad2 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800065ca:	0001f717          	auipc	a4,0x1f
    800065ce:	a3670713          	addi	a4,a4,-1482 # 80025000 <disk+0x2000>
    800065d2:	02075783          	lhu	a5,32(a4)
    800065d6:	6b18                	ld	a4,16(a4)
    800065d8:	00275683          	lhu	a3,2(a4)
    800065dc:	8ebd                	xor	a3,a3,a5
    800065de:	8a9d                	andi	a3,a3,7
    800065e0:	cab9                	beqz	a3,80006636 <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    800065e2:	0001d917          	auipc	s2,0x1d
    800065e6:	a1e90913          	addi	s2,s2,-1506 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    800065ea:	0001f497          	auipc	s1,0x1f
    800065ee:	a1648493          	addi	s1,s1,-1514 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    800065f2:	078e                	slli	a5,a5,0x3
    800065f4:	97ba                	add	a5,a5,a4
    800065f6:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    800065f8:	20078713          	addi	a4,a5,512
    800065fc:	0712                	slli	a4,a4,0x4
    800065fe:	974a                	add	a4,a4,s2
    80006600:	03074703          	lbu	a4,48(a4)
    80006604:	e739                	bnez	a4,80006652 <virtio_disk_intr+0xa4>
    disk.info[id].b->disk = 0;   // disk is done with buf
    80006606:	20078793          	addi	a5,a5,512
    8000660a:	0792                	slli	a5,a5,0x4
    8000660c:	97ca                	add	a5,a5,s2
    8000660e:	7798                	ld	a4,40(a5)
    80006610:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    80006614:	7788                	ld	a0,40(a5)
    80006616:	ffffc097          	auipc	ra,0xffffc
    8000661a:	226080e7          	jalr	550(ra) # 8000283c <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    8000661e:	0204d783          	lhu	a5,32(s1)
    80006622:	2785                	addiw	a5,a5,1
    80006624:	8b9d                	andi	a5,a5,7
    80006626:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    8000662a:	6898                	ld	a4,16(s1)
    8000662c:	00275683          	lhu	a3,2(a4)
    80006630:	8a9d                	andi	a3,a3,7
    80006632:	fcf690e3          	bne	a3,a5,800065f2 <virtio_disk_intr+0x44>
  }

  release(&disk.vdisk_lock);
    80006636:	0001f517          	auipc	a0,0x1f
    8000663a:	a7250513          	addi	a0,a0,-1422 # 800250a8 <disk+0x20a8>
    8000663e:	ffffa097          	auipc	ra,0xffffa
    80006642:	4e8080e7          	jalr	1256(ra) # 80000b26 <release>
}
    80006646:	60e2                	ld	ra,24(sp)
    80006648:	6442                	ld	s0,16(sp)
    8000664a:	64a2                	ld	s1,8(sp)
    8000664c:	6902                	ld	s2,0(sp)
    8000664e:	6105                	addi	sp,sp,32
    80006650:	8082                	ret
      panic("virtio_disk_intr status");
    80006652:	00001517          	auipc	a0,0x1
    80006656:	34650513          	addi	a0,a0,838 # 80007998 <userret+0x908>
    8000665a:	ffffa097          	auipc	ra,0xffffa
    8000665e:	ef4080e7          	jalr	-268(ra) # 8000054e <panic>

0000000080006662 <set_rnd_seed>:
#include "defs.h"

uint32 rnd_seed = 10;

void set_rnd_seed(uint32 seed)
{
    80006662:	1141                	addi	sp,sp,-16
    80006664:	e422                	sd	s0,8(sp)
    80006666:	0800                	addi	s0,sp,16
	rnd_seed = seed;
    80006668:	00002797          	auipc	a5,0x2
    8000666c:	9ca7aa23          	sw	a0,-1580(a5) # 8000803c <rnd_seed>
    //printf("rnd_seed:%p\n",rnd_seed);
}
    80006670:	6422                	ld	s0,8(sp)
    80006672:	0141                	addi	sp,sp,16
    80006674:	8082                	ret

0000000080006676 <rand_int>:

uint32 rand_int(uint32 *state) //from wikipedia, lehmer random number generator
{
    80006676:	1141                	addi	sp,sp,-16
    80006678:	e422                	sd	s0,8(sp)
    8000667a:	0800                	addi	s0,sp,16
	const uint32 A = 48271;

	uint32 low  = (*state & 0x7fff) * A;			// max: 32,767 * 48,271 = 1,581,695,857 = 0x5e46c371
    8000667c:	4118                	lw	a4,0(a0)
	uint32 high = (*state >> 15)    * A;			// max: 65,535 * 48,271 = 3,163,439,985 = 0xbc8e4371
    8000667e:	00f7569b          	srliw	a3,a4,0xf
    80006682:	67b1                	lui	a5,0xc
    80006684:	c8f7861b          	addiw	a2,a5,-881
    80006688:	02c686bb          	mulw	a3,a3,a2
	uint32 low  = (*state & 0x7fff) * A;			// max: 32,767 * 48,271 = 1,581,695,857 = 0x5e46c371
    8000668c:	03171793          	slli	a5,a4,0x31
    80006690:	93c5                	srli	a5,a5,0x31
    80006692:	02c787bb          	mulw	a5,a5,a2
	uint32 x = low + ((high & 0xffff) << 15) + (high >> 16);	// max: 0x5e46c371 + 0x7fff8000 + 0xbc8e = 0xde46ffff
    80006696:	0106d71b          	srliw	a4,a3,0x10
    8000669a:	9fb9                	addw	a5,a5,a4
    8000669c:	00f6969b          	slliw	a3,a3,0xf
    800066a0:	7fff8737          	lui	a4,0x7fff8
    800066a4:	8ef9                	and	a3,a3,a4
    800066a6:	9fb5                	addw	a5,a5,a3

	x = (x & 0x7fffffff) + (x >> 31);
    800066a8:	02179713          	slli	a4,a5,0x21
    800066ac:	9305                	srli	a4,a4,0x21
    800066ae:	01f7d79b          	srliw	a5,a5,0x1f
    800066b2:	9fb9                	addw	a5,a5,a4
	return *state = x;
    800066b4:	c11c                	sw	a5,0(a0)
}
    800066b6:	0007851b          	sext.w	a0,a5
    800066ba:	6422                	ld	s0,8(sp)
    800066bc:	0141                	addi	sp,sp,16
    800066be:	8082                	ret

00000000800066c0 <rand_interval>:

uint32
rand_interval(uint32 min, uint32 max)
{
    	if(max < min){
    800066c0:	04a5ec63          	bltu	a1,a0,80006718 <rand_interval+0x58>
{
    800066c4:	7179                	addi	sp,sp,-48
    800066c6:	f406                	sd	ra,40(sp)
    800066c8:	f022                	sd	s0,32(sp)
    800066ca:	ec26                	sd	s1,24(sp)
    800066cc:	e84a                	sd	s2,16(sp)
    800066ce:	e44e                	sd	s3,8(sp)
    800066d0:	e052                	sd	s4,0(sp)
    800066d2:	1800                	addi	s0,sp,48
    800066d4:	89aa                	mv	s3,a0
            return 0;
        }
        uint32 r;
    	const uint32 range = 1 + max - min;
    800066d6:	40a584bb          	subw	s1,a1,a0
    800066da:	2485                	addiw	s1,s1,1
        //printf("range:%d\n",range);
     	const uint32 buckets = 0x80000000 / range;//(MAX_UINT32/2) / range;
    800066dc:	800007b7          	lui	a5,0x80000
    800066e0:	0297da3b          	divuw	s4,a5,s1
        //printf("bucket:%d\n",buckets);
     	const uint32 limit = buckets * range;
    800066e4:	034484bb          	mulw	s1,s1,s4
     	/* Create equal size buckets all in a row, then fire randomly towards
      	* the buckets until you land in one of them. All buckets are equally
      	* likely. If you land off the end of the line of buckets, try again. */
     	do
     	{   
        	 r = rand_int(&rnd_seed);
    800066e8:	00002917          	auipc	s2,0x2
    800066ec:	95490913          	addi	s2,s2,-1708 # 8000803c <rnd_seed>
    800066f0:	854a                	mv	a0,s2
    800066f2:	00000097          	auipc	ra,0x0
    800066f6:	f84080e7          	jalr	-124(ra) # 80006676 <rand_int>
    800066fa:	2501                	sext.w	a0,a0
             //printf("rnd_seed:%p\n",r);
    	 }while (r >= limit);
    800066fc:	fe957ae3          	bgeu	a0,s1,800066f0 <rand_interval+0x30>
 
     	return min + (r / buckets);
    80006700:	034557bb          	divuw	a5,a0,s4
    80006704:	0137853b          	addw	a0,a5,s3
}
    80006708:	70a2                	ld	ra,40(sp)
    8000670a:	7402                	ld	s0,32(sp)
    8000670c:	64e2                	ld	s1,24(sp)
    8000670e:	6942                	ld	s2,16(sp)
    80006710:	69a2                	ld	s3,8(sp)
    80006712:	6a02                	ld	s4,0(sp)
    80006714:	6145                	addi	sp,sp,48
    80006716:	8082                	ret
            return 0;
    80006718:	4501                	li	a0,0
}
    8000671a:	8082                	ret
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
