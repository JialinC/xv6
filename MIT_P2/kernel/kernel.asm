
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
    80000060:	c2478793          	addi	a5,a5,-988 # 80005c80 <timervec>
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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd57bb>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	cba78793          	addi	a5,a5,-838 # 80000d60 <main>
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
    80000114:	9da080e7          	jalr	-1574(ra) # 80000aea <acquire>
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
    80000144:	70c080e7          	jalr	1804(ra) # 8000184c <myproc>
    80000148:	591c                	lw	a5,48(a0)
    8000014a:	e7b5                	bnez	a5,800001b6 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000014c:	85ce                	mv	a1,s3
    8000014e:	854a                	mv	a0,s2
    80000150:	00002097          	auipc	ra,0x2
    80000154:	f0e080e7          	jalr	-242(ra) # 8000205e <sleep>
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
    80000190:	132080e7          	jalr	306(ra) # 800022be <either_copyout>
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
    800001ac:	9aa080e7          	jalr	-1622(ra) # 80000b52 <release>

  return target - n;
    800001b0:	414b853b          	subw	a0,s7,s4
    800001b4:	a811                	j	800001c8 <consoleread+0xe8>
        release(&cons.lock);
    800001b6:	00011517          	auipc	a0,0x11
    800001ba:	64a50513          	addi	a0,a0,1610 # 80011800 <cons>
    800001be:	00001097          	auipc	ra,0x1
    800001c2:	994080e7          	jalr	-1644(ra) # 80000b52 <release>
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
    800001f8:	00029797          	auipc	a5,0x29
    800001fc:	e207a783          	lw	a5,-480(a5) # 80029018 <panicked>
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
    8000026a:	884080e7          	jalr	-1916(ra) # 80000aea <acquire>
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
    80000290:	088080e7          	jalr	136(ra) # 80002314 <either_copyin>
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
    800002b6:	8a0080e7          	jalr	-1888(ra) # 80000b52 <release>
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
    800002e4:	00001097          	auipc	ra,0x1
    800002e8:	806080e7          	jalr	-2042(ra) # 80000aea <acquire>

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
    80000306:	068080e7          	jalr	104(ra) # 8000236a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000030a:	00011517          	auipc	a0,0x11
    8000030e:	4f650513          	addi	a0,a0,1270 # 80011800 <cons>
    80000312:	00001097          	auipc	ra,0x1
    80000316:	840080e7          	jalr	-1984(ra) # 80000b52 <release>
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
    8000045a:	d8e080e7          	jalr	-626(ra) # 800021e4 <wakeup>
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
    8000047c:	560080e7          	jalr	1376(ra) # 800009d8 <initlock>

  uartinit();
    80000480:	00000097          	auipc	ra,0x0
    80000484:	330080e7          	jalr	816(ra) # 800007b0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000488:	00021797          	auipc	a5,0x21
    8000048c:	66078793          	addi	a5,a5,1632 # 80021ae8 <devsw>
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
    800004ce:	43660613          	addi	a2,a2,1078 # 80007900 <digits>
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
    80000580:	c3450513          	addi	a0,a0,-972 # 800071b0 <userret+0x120>
    80000584:	00000097          	auipc	ra,0x0
    80000588:	014080e7          	jalr	20(ra) # 80000598 <printf>
  panicked = 1; // freeze other CPUs
    8000058c:	4785                	li	a5,1
    8000058e:	00029717          	auipc	a4,0x29
    80000592:	a8f72523          	sw	a5,-1398(a4) # 80029018 <panicked>
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
    800005fa:	30ab8b93          	addi	s7,s7,778 # 80007900 <digits>
    switch(c){
    800005fe:	07300c93          	li	s9,115
    80000602:	06400c13          	li	s8,100
    80000606:	a82d                	j	80000640 <printf+0xa8>
    acquire(&pr.lock);
    80000608:	00011517          	auipc	a0,0x11
    8000060c:	2a050513          	addi	a0,a0,672 # 800118a8 <pr>
    80000610:	00000097          	auipc	ra,0x0
    80000614:	4da080e7          	jalr	1242(ra) # 80000aea <acquire>
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
    80000778:	3de080e7          	jalr	990(ra) # 80000b52 <release>
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
    8000079e:	23e080e7          	jalr	574(ra) # 800009d8 <initlock>
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
    80000878:	00028797          	auipc	a5,0x28
    8000087c:	7cc78793          	addi	a5,a5,1996 # 80029044 <end>
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
    80000894:	31e080e7          	jalr	798(ra) # 80000bae <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000898:	00011917          	auipc	s2,0x11
    8000089c:	03090913          	addi	s2,s2,48 # 800118c8 <kmem>
    800008a0:	854a                	mv	a0,s2
    800008a2:	00000097          	auipc	ra,0x0
    800008a6:	248080e7          	jalr	584(ra) # 80000aea <acquire>
  r->next = kmem.freelist;
    800008aa:	01893783          	ld	a5,24(s2)
    800008ae:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800008b0:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800008b4:	854a                	mv	a0,s2
    800008b6:	00000097          	auipc	ra,0x0
    800008ba:	29c080e7          	jalr	668(ra) # 80000b52 <release>
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
    80000924:	1101                	addi	sp,sp,-32
    80000926:	ec06                	sd	ra,24(sp)
    80000928:	e822                	sd	s0,16(sp)
    8000092a:	e426                	sd	s1,8(sp)
    8000092c:	1000                	addi	s0,sp,32
  initlock(&kmem.lock, "kmem");
    8000092e:	00007597          	auipc	a1,0x7
    80000932:	82258593          	addi	a1,a1,-2014 # 80007150 <userret+0xc0>
    80000936:	00011517          	auipc	a0,0x11
    8000093a:	f9250513          	addi	a0,a0,-110 # 800118c8 <kmem>
    8000093e:	00000097          	auipc	ra,0x0
    80000942:	09a080e7          	jalr	154(ra) # 800009d8 <initlock>
  freerange(end, p);
    80000946:	087ff4b7          	lui	s1,0x87ff
    8000094a:	00449593          	slli	a1,s1,0x4
    8000094e:	00028517          	auipc	a0,0x28
    80000952:	6f650513          	addi	a0,a0,1782 # 80029044 <end>
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	f84080e7          	jalr	-124(ra) # 800008da <freerange>
  bd_init(p, p+MAXHEAP);
    8000095e:	45c5                	li	a1,17
    80000960:	05ee                	slli	a1,a1,0x1b
    80000962:	00449513          	slli	a0,s1,0x4
    80000966:	00006097          	auipc	ra,0x6
    8000096a:	f46080e7          	jalr	-186(ra) # 800068ac <bd_init>
}
    8000096e:	60e2                	ld	ra,24(sp)
    80000970:	6442                	ld	s0,16(sp)
    80000972:	64a2                	ld	s1,8(sp)
    80000974:	6105                	addi	sp,sp,32
    80000976:	8082                	ret

0000000080000978 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000978:	1101                	addi	sp,sp,-32
    8000097a:	ec06                	sd	ra,24(sp)
    8000097c:	e822                	sd	s0,16(sp)
    8000097e:	e426                	sd	s1,8(sp)
    80000980:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000982:	00011497          	auipc	s1,0x11
    80000986:	f4648493          	addi	s1,s1,-186 # 800118c8 <kmem>
    8000098a:	8526                	mv	a0,s1
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	15e080e7          	jalr	350(ra) # 80000aea <acquire>
  r = kmem.freelist;
    80000994:	6c84                	ld	s1,24(s1)
  if(r)
    80000996:	c885                	beqz	s1,800009c6 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000998:	609c                	ld	a5,0(s1)
    8000099a:	00011517          	auipc	a0,0x11
    8000099e:	f2e50513          	addi	a0,a0,-210 # 800118c8 <kmem>
    800009a2:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    800009a4:	00000097          	auipc	ra,0x0
    800009a8:	1ae080e7          	jalr	430(ra) # 80000b52 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800009ac:	6605                	lui	a2,0x1
    800009ae:	4595                	li	a1,5
    800009b0:	8526                	mv	a0,s1
    800009b2:	00000097          	auipc	ra,0x0
    800009b6:	1fc080e7          	jalr	508(ra) # 80000bae <memset>
  return (void*)r;
}
    800009ba:	8526                	mv	a0,s1
    800009bc:	60e2                	ld	ra,24(sp)
    800009be:	6442                	ld	s0,16(sp)
    800009c0:	64a2                	ld	s1,8(sp)
    800009c2:	6105                	addi	sp,sp,32
    800009c4:	8082                	ret
  release(&kmem.lock);
    800009c6:	00011517          	auipc	a0,0x11
    800009ca:	f0250513          	addi	a0,a0,-254 # 800118c8 <kmem>
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	184080e7          	jalr	388(ra) # 80000b52 <release>
  if(r)
    800009d6:	b7d5                	j	800009ba <kalloc+0x42>

00000000800009d8 <initlock>:

uint64 ntest_and_set;

void
initlock(struct spinlock *lk, char *name)
{
    800009d8:	1141                	addi	sp,sp,-16
    800009da:	e422                	sd	s0,8(sp)
    800009dc:	0800                	addi	s0,sp,16
  lk->name = name;
    800009de:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800009e0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800009e4:	00053823          	sd	zero,16(a0)
}
    800009e8:	6422                	ld	s0,8(sp)
    800009ea:	0141                	addi	sp,sp,16
    800009ec:	8082                	ret

00000000800009ee <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800009ee:	1101                	addi	sp,sp,-32
    800009f0:	ec06                	sd	ra,24(sp)
    800009f2:	e822                	sd	s0,16(sp)
    800009f4:	e426                	sd	s1,8(sp)
    800009f6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800009f8:	100024f3          	csrr	s1,sstatus
    800009fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000a00:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000a02:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000a06:	00001097          	auipc	ra,0x1
    80000a0a:	e2a080e7          	jalr	-470(ra) # 80001830 <mycpu>
    80000a0e:	5d3c                	lw	a5,120(a0)
    80000a10:	cf89                	beqz	a5,80000a2a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000a12:	00001097          	auipc	ra,0x1
    80000a16:	e1e080e7          	jalr	-482(ra) # 80001830 <mycpu>
    80000a1a:	5d3c                	lw	a5,120(a0)
    80000a1c:	2785                	addiw	a5,a5,1
    80000a1e:	dd3c                	sw	a5,120(a0)
}
    80000a20:	60e2                	ld	ra,24(sp)
    80000a22:	6442                	ld	s0,16(sp)
    80000a24:	64a2                	ld	s1,8(sp)
    80000a26:	6105                	addi	sp,sp,32
    80000a28:	8082                	ret
    mycpu()->intena = old;
    80000a2a:	00001097          	auipc	ra,0x1
    80000a2e:	e06080e7          	jalr	-506(ra) # 80001830 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000a32:	8085                	srli	s1,s1,0x1
    80000a34:	8885                	andi	s1,s1,1
    80000a36:	dd64                	sw	s1,124(a0)
    80000a38:	bfe9                	j	80000a12 <push_off+0x24>

0000000080000a3a <pop_off>:

void
pop_off(void)
{
    80000a3a:	1141                	addi	sp,sp,-16
    80000a3c:	e406                	sd	ra,8(sp)
    80000a3e:	e022                	sd	s0,0(sp)
    80000a40:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000a42:	00001097          	auipc	ra,0x1
    80000a46:	dee080e7          	jalr	-530(ra) # 80001830 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a4a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000a4e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000a50:	ef8d                	bnez	a5,80000a8a <pop_off+0x50>
    panic("pop_off - interruptible");
  c->noff -= 1;
    80000a52:	5d3c                	lw	a5,120(a0)
    80000a54:	37fd                	addiw	a5,a5,-1
    80000a56:	0007871b          	sext.w	a4,a5
    80000a5a:	dd3c                	sw	a5,120(a0)
  if(c->noff < 0)
    80000a5c:	02079693          	slli	a3,a5,0x20
    80000a60:	0206cd63          	bltz	a3,80000a9a <pop_off+0x60>
    panic("pop_off");
  if(c->noff == 0 && c->intena)
    80000a64:	ef19                	bnez	a4,80000a82 <pop_off+0x48>
    80000a66:	5d7c                	lw	a5,124(a0)
    80000a68:	cf89                	beqz	a5,80000a82 <pop_off+0x48>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80000a6a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000a6e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80000a72:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a76:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000a7a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000a7e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000a82:	60a2                	ld	ra,8(sp)
    80000a84:	6402                	ld	s0,0(sp)
    80000a86:	0141                	addi	sp,sp,16
    80000a88:	8082                	ret
    panic("pop_off - interruptible");
    80000a8a:	00006517          	auipc	a0,0x6
    80000a8e:	6ce50513          	addi	a0,a0,1742 # 80007158 <userret+0xc8>
    80000a92:	00000097          	auipc	ra,0x0
    80000a96:	abc080e7          	jalr	-1348(ra) # 8000054e <panic>
    panic("pop_off");
    80000a9a:	00006517          	auipc	a0,0x6
    80000a9e:	6d650513          	addi	a0,a0,1750 # 80007170 <userret+0xe0>
    80000aa2:	00000097          	auipc	ra,0x0
    80000aa6:	aac080e7          	jalr	-1364(ra) # 8000054e <panic>

0000000080000aaa <holding>:
{
    80000aaa:	1101                	addi	sp,sp,-32
    80000aac:	ec06                	sd	ra,24(sp)
    80000aae:	e822                	sd	s0,16(sp)
    80000ab0:	e426                	sd	s1,8(sp)
    80000ab2:	1000                	addi	s0,sp,32
    80000ab4:	84aa                	mv	s1,a0
  push_off();
    80000ab6:	00000097          	auipc	ra,0x0
    80000aba:	f38080e7          	jalr	-200(ra) # 800009ee <push_off>
  r = (lk->locked && lk->cpu == mycpu());
    80000abe:	409c                	lw	a5,0(s1)
    80000ac0:	ef81                	bnez	a5,80000ad8 <holding+0x2e>
    80000ac2:	4481                	li	s1,0
  pop_off();
    80000ac4:	00000097          	auipc	ra,0x0
    80000ac8:	f76080e7          	jalr	-138(ra) # 80000a3a <pop_off>
}
    80000acc:	8526                	mv	a0,s1
    80000ace:	60e2                	ld	ra,24(sp)
    80000ad0:	6442                	ld	s0,16(sp)
    80000ad2:	64a2                	ld	s1,8(sp)
    80000ad4:	6105                	addi	sp,sp,32
    80000ad6:	8082                	ret
  r = (lk->locked && lk->cpu == mycpu());
    80000ad8:	6884                	ld	s1,16(s1)
    80000ada:	00001097          	auipc	ra,0x1
    80000ade:	d56080e7          	jalr	-682(ra) # 80001830 <mycpu>
    80000ae2:	8c89                	sub	s1,s1,a0
    80000ae4:	0014b493          	seqz	s1,s1
    80000ae8:	bff1                	j	80000ac4 <holding+0x1a>

0000000080000aea <acquire>:
{
    80000aea:	1101                	addi	sp,sp,-32
    80000aec:	ec06                	sd	ra,24(sp)
    80000aee:	e822                	sd	s0,16(sp)
    80000af0:	e426                	sd	s1,8(sp)
    80000af2:	1000                	addi	s0,sp,32
    80000af4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	ef8080e7          	jalr	-264(ra) # 800009ee <push_off>
  if(holding(lk))
    80000afe:	8526                	mv	a0,s1
    80000b00:	00000097          	auipc	ra,0x0
    80000b04:	faa080e7          	jalr	-86(ra) # 80000aaa <holding>
    80000b08:	e901                	bnez	a0,80000b18 <acquire+0x2e>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000b0a:	4685                	li	a3,1
     __sync_fetch_and_add(&ntest_and_set, 1);
    80000b0c:	00028717          	auipc	a4,0x28
    80000b10:	51470713          	addi	a4,a4,1300 # 80029020 <ntest_and_set>
    80000b14:	4605                	li	a2,1
    80000b16:	a829                	j	80000b30 <acquire+0x46>
    panic("acquire");
    80000b18:	00006517          	auipc	a0,0x6
    80000b1c:	66050513          	addi	a0,a0,1632 # 80007178 <userret+0xe8>
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	a2e080e7          	jalr	-1490(ra) # 8000054e <panic>
     __sync_fetch_and_add(&ntest_and_set, 1);
    80000b28:	0f50000f          	fence	iorw,ow
    80000b2c:	04c7302f          	amoadd.d.aq	zero,a2,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000b30:	87b6                	mv	a5,a3
    80000b32:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000b36:	2781                	sext.w	a5,a5
    80000b38:	fbe5                	bnez	a5,80000b28 <acquire+0x3e>
  __sync_synchronize();
    80000b3a:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000b3e:	00001097          	auipc	ra,0x1
    80000b42:	cf2080e7          	jalr	-782(ra) # 80001830 <mycpu>
    80000b46:	e888                	sd	a0,16(s1)
}
    80000b48:	60e2                	ld	ra,24(sp)
    80000b4a:	6442                	ld	s0,16(sp)
    80000b4c:	64a2                	ld	s1,8(sp)
    80000b4e:	6105                	addi	sp,sp,32
    80000b50:	8082                	ret

0000000080000b52 <release>:
{
    80000b52:	1101                	addi	sp,sp,-32
    80000b54:	ec06                	sd	ra,24(sp)
    80000b56:	e822                	sd	s0,16(sp)
    80000b58:	e426                	sd	s1,8(sp)
    80000b5a:	1000                	addi	s0,sp,32
    80000b5c:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000b5e:	00000097          	auipc	ra,0x0
    80000b62:	f4c080e7          	jalr	-180(ra) # 80000aaa <holding>
    80000b66:	c115                	beqz	a0,80000b8a <release+0x38>
  lk->cpu = 0;
    80000b68:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000b6c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000b70:	0f50000f          	fence	iorw,ow
    80000b74:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000b78:	00000097          	auipc	ra,0x0
    80000b7c:	ec2080e7          	jalr	-318(ra) # 80000a3a <pop_off>
}
    80000b80:	60e2                	ld	ra,24(sp)
    80000b82:	6442                	ld	s0,16(sp)
    80000b84:	64a2                	ld	s1,8(sp)
    80000b86:	6105                	addi	sp,sp,32
    80000b88:	8082                	ret
    panic("release");
    80000b8a:	00006517          	auipc	a0,0x6
    80000b8e:	5f650513          	addi	a0,a0,1526 # 80007180 <userret+0xf0>
    80000b92:	00000097          	auipc	ra,0x0
    80000b96:	9bc080e7          	jalr	-1604(ra) # 8000054e <panic>

0000000080000b9a <sys_ntas>:

uint64
sys_ntas(void)
{
    80000b9a:	1141                	addi	sp,sp,-16
    80000b9c:	e422                	sd	s0,8(sp)
    80000b9e:	0800                	addi	s0,sp,16
  return ntest_and_set;
}
    80000ba0:	00028517          	auipc	a0,0x28
    80000ba4:	48053503          	ld	a0,1152(a0) # 80029020 <ntest_and_set>
    80000ba8:	6422                	ld	s0,8(sp)
    80000baa:	0141                	addi	sp,sp,16
    80000bac:	8082                	ret

0000000080000bae <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000bae:	1141                	addi	sp,sp,-16
    80000bb0:	e422                	sd	s0,8(sp)
    80000bb2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000bb4:	ce09                	beqz	a2,80000bce <memset+0x20>
    80000bb6:	87aa                	mv	a5,a0
    80000bb8:	fff6071b          	addiw	a4,a2,-1
    80000bbc:	1702                	slli	a4,a4,0x20
    80000bbe:	9301                	srli	a4,a4,0x20
    80000bc0:	0705                	addi	a4,a4,1
    80000bc2:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000bc4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000bc8:	0785                	addi	a5,a5,1
    80000bca:	fee79de3          	bne	a5,a4,80000bc4 <memset+0x16>
  }
  return dst;
}
    80000bce:	6422                	ld	s0,8(sp)
    80000bd0:	0141                	addi	sp,sp,16
    80000bd2:	8082                	ret

0000000080000bd4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000bd4:	1141                	addi	sp,sp,-16
    80000bd6:	e422                	sd	s0,8(sp)
    80000bd8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000bda:	ca05                	beqz	a2,80000c0a <memcmp+0x36>
    80000bdc:	fff6069b          	addiw	a3,a2,-1
    80000be0:	1682                	slli	a3,a3,0x20
    80000be2:	9281                	srli	a3,a3,0x20
    80000be4:	0685                	addi	a3,a3,1
    80000be6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000be8:	00054783          	lbu	a5,0(a0)
    80000bec:	0005c703          	lbu	a4,0(a1)
    80000bf0:	00e79863          	bne	a5,a4,80000c00 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000bf4:	0505                	addi	a0,a0,1
    80000bf6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000bf8:	fed518e3          	bne	a0,a3,80000be8 <memcmp+0x14>
  }

  return 0;
    80000bfc:	4501                	li	a0,0
    80000bfe:	a019                	j	80000c04 <memcmp+0x30>
      return *s1 - *s2;
    80000c00:	40e7853b          	subw	a0,a5,a4
}
    80000c04:	6422                	ld	s0,8(sp)
    80000c06:	0141                	addi	sp,sp,16
    80000c08:	8082                	ret
  return 0;
    80000c0a:	4501                	li	a0,0
    80000c0c:	bfe5                	j	80000c04 <memcmp+0x30>

0000000080000c0e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000c0e:	1141                	addi	sp,sp,-16
    80000c10:	e422                	sd	s0,8(sp)
    80000c12:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000c14:	02a5e563          	bltu	a1,a0,80000c3e <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000c18:	fff6069b          	addiw	a3,a2,-1
    80000c1c:	ce11                	beqz	a2,80000c38 <memmove+0x2a>
    80000c1e:	1682                	slli	a3,a3,0x20
    80000c20:	9281                	srli	a3,a3,0x20
    80000c22:	0685                	addi	a3,a3,1
    80000c24:	96ae                	add	a3,a3,a1
    80000c26:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000c28:	0585                	addi	a1,a1,1
    80000c2a:	0785                	addi	a5,a5,1
    80000c2c:	fff5c703          	lbu	a4,-1(a1)
    80000c30:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000c34:	fed59ae3          	bne	a1,a3,80000c28 <memmove+0x1a>

  return dst;
}
    80000c38:	6422                	ld	s0,8(sp)
    80000c3a:	0141                	addi	sp,sp,16
    80000c3c:	8082                	ret
  if(s < d && s + n > d){
    80000c3e:	02061713          	slli	a4,a2,0x20
    80000c42:	9301                	srli	a4,a4,0x20
    80000c44:	00e587b3          	add	a5,a1,a4
    80000c48:	fcf578e3          	bgeu	a0,a5,80000c18 <memmove+0xa>
    d += n;
    80000c4c:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000c4e:	fff6069b          	addiw	a3,a2,-1
    80000c52:	d27d                	beqz	a2,80000c38 <memmove+0x2a>
    80000c54:	02069613          	slli	a2,a3,0x20
    80000c58:	9201                	srli	a2,a2,0x20
    80000c5a:	fff64613          	not	a2,a2
    80000c5e:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000c60:	17fd                	addi	a5,a5,-1
    80000c62:	177d                	addi	a4,a4,-1
    80000c64:	0007c683          	lbu	a3,0(a5)
    80000c68:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000c6c:	fec79ae3          	bne	a5,a2,80000c60 <memmove+0x52>
    80000c70:	b7e1                	j	80000c38 <memmove+0x2a>

0000000080000c72 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000c72:	1141                	addi	sp,sp,-16
    80000c74:	e406                	sd	ra,8(sp)
    80000c76:	e022                	sd	s0,0(sp)
    80000c78:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	f94080e7          	jalr	-108(ra) # 80000c0e <memmove>
}
    80000c82:	60a2                	ld	ra,8(sp)
    80000c84:	6402                	ld	s0,0(sp)
    80000c86:	0141                	addi	sp,sp,16
    80000c88:	8082                	ret

0000000080000c8a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000c8a:	1141                	addi	sp,sp,-16
    80000c8c:	e422                	sd	s0,8(sp)
    80000c8e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000c90:	ce11                	beqz	a2,80000cac <strncmp+0x22>
    80000c92:	00054783          	lbu	a5,0(a0)
    80000c96:	cf89                	beqz	a5,80000cb0 <strncmp+0x26>
    80000c98:	0005c703          	lbu	a4,0(a1)
    80000c9c:	00f71a63          	bne	a4,a5,80000cb0 <strncmp+0x26>
    n--, p++, q++;
    80000ca0:	367d                	addiw	a2,a2,-1
    80000ca2:	0505                	addi	a0,a0,1
    80000ca4:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000ca6:	f675                	bnez	a2,80000c92 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000ca8:	4501                	li	a0,0
    80000caa:	a809                	j	80000cbc <strncmp+0x32>
    80000cac:	4501                	li	a0,0
    80000cae:	a039                	j	80000cbc <strncmp+0x32>
  if(n == 0)
    80000cb0:	ca09                	beqz	a2,80000cc2 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000cb2:	00054503          	lbu	a0,0(a0)
    80000cb6:	0005c783          	lbu	a5,0(a1)
    80000cba:	9d1d                	subw	a0,a0,a5
}
    80000cbc:	6422                	ld	s0,8(sp)
    80000cbe:	0141                	addi	sp,sp,16
    80000cc0:	8082                	ret
    return 0;
    80000cc2:	4501                	li	a0,0
    80000cc4:	bfe5                	j	80000cbc <strncmp+0x32>

0000000080000cc6 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000cc6:	1141                	addi	sp,sp,-16
    80000cc8:	e422                	sd	s0,8(sp)
    80000cca:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000ccc:	872a                	mv	a4,a0
    80000cce:	8832                	mv	a6,a2
    80000cd0:	367d                	addiw	a2,a2,-1
    80000cd2:	01005963          	blez	a6,80000ce4 <strncpy+0x1e>
    80000cd6:	0705                	addi	a4,a4,1
    80000cd8:	0005c783          	lbu	a5,0(a1)
    80000cdc:	fef70fa3          	sb	a5,-1(a4)
    80000ce0:	0585                	addi	a1,a1,1
    80000ce2:	f7f5                	bnez	a5,80000cce <strncpy+0x8>
    ;
  while(n-- > 0)
    80000ce4:	86ba                	mv	a3,a4
    80000ce6:	00c05c63          	blez	a2,80000cfe <strncpy+0x38>
    *s++ = 0;
    80000cea:	0685                	addi	a3,a3,1
    80000cec:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000cf0:	fff6c793          	not	a5,a3
    80000cf4:	9fb9                	addw	a5,a5,a4
    80000cf6:	010787bb          	addw	a5,a5,a6
    80000cfa:	fef048e3          	bgtz	a5,80000cea <strncpy+0x24>
  return os;
}
    80000cfe:	6422                	ld	s0,8(sp)
    80000d00:	0141                	addi	sp,sp,16
    80000d02:	8082                	ret

0000000080000d04 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000d04:	1141                	addi	sp,sp,-16
    80000d06:	e422                	sd	s0,8(sp)
    80000d08:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000d0a:	02c05363          	blez	a2,80000d30 <safestrcpy+0x2c>
    80000d0e:	fff6069b          	addiw	a3,a2,-1
    80000d12:	1682                	slli	a3,a3,0x20
    80000d14:	9281                	srli	a3,a3,0x20
    80000d16:	96ae                	add	a3,a3,a1
    80000d18:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000d1a:	00d58963          	beq	a1,a3,80000d2c <safestrcpy+0x28>
    80000d1e:	0585                	addi	a1,a1,1
    80000d20:	0785                	addi	a5,a5,1
    80000d22:	fff5c703          	lbu	a4,-1(a1)
    80000d26:	fee78fa3          	sb	a4,-1(a5)
    80000d2a:	fb65                	bnez	a4,80000d1a <safestrcpy+0x16>
    ;
  *s = 0;
    80000d2c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000d30:	6422                	ld	s0,8(sp)
    80000d32:	0141                	addi	sp,sp,16
    80000d34:	8082                	ret

0000000080000d36 <strlen>:

int
strlen(const char *s)
{
    80000d36:	1141                	addi	sp,sp,-16
    80000d38:	e422                	sd	s0,8(sp)
    80000d3a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000d3c:	00054783          	lbu	a5,0(a0)
    80000d40:	cf91                	beqz	a5,80000d5c <strlen+0x26>
    80000d42:	0505                	addi	a0,a0,1
    80000d44:	87aa                	mv	a5,a0
    80000d46:	4685                	li	a3,1
    80000d48:	9e89                	subw	a3,a3,a0
    80000d4a:	00f6853b          	addw	a0,a3,a5
    80000d4e:	0785                	addi	a5,a5,1
    80000d50:	fff7c703          	lbu	a4,-1(a5)
    80000d54:	fb7d                	bnez	a4,80000d4a <strlen+0x14>
    ;
  return n;
}
    80000d56:	6422                	ld	s0,8(sp)
    80000d58:	0141                	addi	sp,sp,16
    80000d5a:	8082                	ret
  for(n = 0; s[n]; n++)
    80000d5c:	4501                	li	a0,0
    80000d5e:	bfe5                	j	80000d56 <strlen+0x20>

0000000080000d60 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000d60:	1141                	addi	sp,sp,-16
    80000d62:	e406                	sd	ra,8(sp)
    80000d64:	e022                	sd	s0,0(sp)
    80000d66:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000d68:	00001097          	auipc	ra,0x1
    80000d6c:	ab8080e7          	jalr	-1352(ra) # 80001820 <cpuid>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000d70:	00028717          	auipc	a4,0x28
    80000d74:	2b870713          	addi	a4,a4,696 # 80029028 <started>
  if(cpuid() == 0){
    80000d78:	c139                	beqz	a0,80000dbe <main+0x5e>
    while(started == 0)
    80000d7a:	431c                	lw	a5,0(a4)
    80000d7c:	2781                	sext.w	a5,a5
    80000d7e:	dff5                	beqz	a5,80000d7a <main+0x1a>
      ;
    __sync_synchronize();
    80000d80:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000d84:	00001097          	auipc	ra,0x1
    80000d88:	a9c080e7          	jalr	-1380(ra) # 80001820 <cpuid>
    80000d8c:	85aa                	mv	a1,a0
    80000d8e:	00006517          	auipc	a0,0x6
    80000d92:	41250513          	addi	a0,a0,1042 # 800071a0 <userret+0x110>
    80000d96:	00000097          	auipc	ra,0x0
    80000d9a:	802080e7          	jalr	-2046(ra) # 80000598 <printf>
    kvminithart();    // turn on paging
    80000d9e:	00000097          	auipc	ra,0x0
    80000da2:	1ea080e7          	jalr	490(ra) # 80000f88 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000da6:	00001097          	auipc	ra,0x1
    80000daa:	704080e7          	jalr	1796(ra) # 800024aa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	f12080e7          	jalr	-238(ra) # 80005cc0 <plicinithart>
  }

  scheduler();        
    80000db6:	00001097          	auipc	ra,0x1
    80000dba:	fd8080e7          	jalr	-40(ra) # 80001d8e <scheduler>
    consoleinit();
    80000dbe:	fffff097          	auipc	ra,0xfffff
    80000dc2:	6a2080e7          	jalr	1698(ra) # 80000460 <consoleinit>
    printfinit();
    80000dc6:	00000097          	auipc	ra,0x0
    80000dca:	9b8080e7          	jalr	-1608(ra) # 8000077e <printfinit>
    printf("\n");
    80000dce:	00006517          	auipc	a0,0x6
    80000dd2:	3e250513          	addi	a0,a0,994 # 800071b0 <userret+0x120>
    80000dd6:	fffff097          	auipc	ra,0xfffff
    80000dda:	7c2080e7          	jalr	1986(ra) # 80000598 <printf>
    printf("xv6 kernel is booting\n");
    80000dde:	00006517          	auipc	a0,0x6
    80000de2:	3aa50513          	addi	a0,a0,938 # 80007188 <userret+0xf8>
    80000de6:	fffff097          	auipc	ra,0xfffff
    80000dea:	7b2080e7          	jalr	1970(ra) # 80000598 <printf>
    printf("\n");
    80000dee:	00006517          	auipc	a0,0x6
    80000df2:	3c250513          	addi	a0,a0,962 # 800071b0 <userret+0x120>
    80000df6:	fffff097          	auipc	ra,0xfffff
    80000dfa:	7a2080e7          	jalr	1954(ra) # 80000598 <printf>
    kinit();         // physical page allocator
    80000dfe:	00000097          	auipc	ra,0x0
    80000e02:	b26080e7          	jalr	-1242(ra) # 80000924 <kinit>
    kvminit();       // create kernel page table
    80000e06:	00000097          	auipc	ra,0x0
    80000e0a:	300080e7          	jalr	768(ra) # 80001106 <kvminit>
    kvminithart();   // turn on paging
    80000e0e:	00000097          	auipc	ra,0x0
    80000e12:	17a080e7          	jalr	378(ra) # 80000f88 <kvminithart>
    procinit();      // process table
    80000e16:	00001097          	auipc	ra,0x1
    80000e1a:	93a080e7          	jalr	-1734(ra) # 80001750 <procinit>
    trapinit();      // trap vectors
    80000e1e:	00001097          	auipc	ra,0x1
    80000e22:	664080e7          	jalr	1636(ra) # 80002482 <trapinit>
    trapinithart();  // install kernel trap vector
    80000e26:	00001097          	auipc	ra,0x1
    80000e2a:	684080e7          	jalr	1668(ra) # 800024aa <trapinithart>
    plicinit();      // set up interrupt controller
    80000e2e:	00005097          	auipc	ra,0x5
    80000e32:	e7c080e7          	jalr	-388(ra) # 80005caa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000e36:	00005097          	auipc	ra,0x5
    80000e3a:	e8a080e7          	jalr	-374(ra) # 80005cc0 <plicinithart>
    binit();         // buffer cache
    80000e3e:	00002097          	auipc	ra,0x2
    80000e42:	daa080e7          	jalr	-598(ra) # 80002be8 <binit>
    iinit();         // inode cache
    80000e46:	00002097          	auipc	ra,0x2
    80000e4a:	43e080e7          	jalr	1086(ra) # 80003284 <iinit>
    fileinit();      // file table
    80000e4e:	00003097          	auipc	ra,0x3
    80000e52:	61a080e7          	jalr	1562(ra) # 80004468 <fileinit>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    80000e56:	4501                	li	a0,0
    80000e58:	00005097          	auipc	ra,0x5
    80000e5c:	f9c080e7          	jalr	-100(ra) # 80005df4 <virtio_disk_init>
    userinit();      // first user process
    80000e60:	00001097          	auipc	ra,0x1
    80000e64:	c60080e7          	jalr	-928(ra) # 80001ac0 <userinit>
    __sync_synchronize();
    80000e68:	0ff0000f          	fence
    started = 1;
    80000e6c:	4785                	li	a5,1
    80000e6e:	00028717          	auipc	a4,0x28
    80000e72:	1af72d23          	sw	a5,442(a4) # 80029028 <started>
    80000e76:	b781                	j	80000db6 <main+0x56>

0000000080000e78 <walk>:
//   21..39 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..12 -- 12 bits of byte offset within the page.
static pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000e78:	7139                	addi	sp,sp,-64
    80000e7a:	fc06                	sd	ra,56(sp)
    80000e7c:	f822                	sd	s0,48(sp)
    80000e7e:	f426                	sd	s1,40(sp)
    80000e80:	f04a                	sd	s2,32(sp)
    80000e82:	ec4e                	sd	s3,24(sp)
    80000e84:	e852                	sd	s4,16(sp)
    80000e86:	e456                	sd	s5,8(sp)
    80000e88:	e05a                	sd	s6,0(sp)
    80000e8a:	0080                	addi	s0,sp,64
    80000e8c:	84aa                	mv	s1,a0
    80000e8e:	89ae                	mv	s3,a1
    80000e90:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000e92:	57fd                	li	a5,-1
    80000e94:	83e9                	srli	a5,a5,0x1a
    80000e96:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000e98:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000e9a:	04b7f263          	bgeu	a5,a1,80000ede <walk+0x66>
    panic("walk");
    80000e9e:	00006517          	auipc	a0,0x6
    80000ea2:	31a50513          	addi	a0,a0,794 # 800071b8 <userret+0x128>
    80000ea6:	fffff097          	auipc	ra,0xfffff
    80000eaa:	6a8080e7          	jalr	1704(ra) # 8000054e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000eae:	060a8663          	beqz	s5,80000f1a <walk+0xa2>
    80000eb2:	00000097          	auipc	ra,0x0
    80000eb6:	ac6080e7          	jalr	-1338(ra) # 80000978 <kalloc>
    80000eba:	84aa                	mv	s1,a0
    80000ebc:	c529                	beqz	a0,80000f06 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ebe:	6605                	lui	a2,0x1
    80000ec0:	4581                	li	a1,0
    80000ec2:	00000097          	auipc	ra,0x0
    80000ec6:	cec080e7          	jalr	-788(ra) # 80000bae <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000eca:	00c4d793          	srli	a5,s1,0xc
    80000ece:	07aa                	slli	a5,a5,0xa
    80000ed0:	0017e793          	ori	a5,a5,1
    80000ed4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000ed8:	3a5d                	addiw	s4,s4,-9
    80000eda:	036a0063          	beq	s4,s6,80000efa <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000ede:	0149d933          	srl	s2,s3,s4
    80000ee2:	1ff97913          	andi	s2,s2,511
    80000ee6:	090e                	slli	s2,s2,0x3
    80000ee8:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000eea:	00093483          	ld	s1,0(s2)
    80000eee:	0014f793          	andi	a5,s1,1
    80000ef2:	dfd5                	beqz	a5,80000eae <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000ef4:	80a9                	srli	s1,s1,0xa
    80000ef6:	04b2                	slli	s1,s1,0xc
    80000ef8:	b7c5                	j	80000ed8 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000efa:	00c9d513          	srli	a0,s3,0xc
    80000efe:	1ff57513          	andi	a0,a0,511
    80000f02:	050e                	slli	a0,a0,0x3
    80000f04:	9526                	add	a0,a0,s1
}
    80000f06:	70e2                	ld	ra,56(sp)
    80000f08:	7442                	ld	s0,48(sp)
    80000f0a:	74a2                	ld	s1,40(sp)
    80000f0c:	7902                	ld	s2,32(sp)
    80000f0e:	69e2                	ld	s3,24(sp)
    80000f10:	6a42                	ld	s4,16(sp)
    80000f12:	6aa2                	ld	s5,8(sp)
    80000f14:	6b02                	ld	s6,0(sp)
    80000f16:	6121                	addi	sp,sp,64
    80000f18:	8082                	ret
        return 0;
    80000f1a:	4501                	li	a0,0
    80000f1c:	b7ed                	j	80000f06 <walk+0x8e>

0000000080000f1e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void
freewalk(pagetable_t pagetable)
{
    80000f1e:	7179                	addi	sp,sp,-48
    80000f20:	f406                	sd	ra,40(sp)
    80000f22:	f022                	sd	s0,32(sp)
    80000f24:	ec26                	sd	s1,24(sp)
    80000f26:	e84a                	sd	s2,16(sp)
    80000f28:	e44e                	sd	s3,8(sp)
    80000f2a:	e052                	sd	s4,0(sp)
    80000f2c:	1800                	addi	s0,sp,48
    80000f2e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000f30:	84aa                	mv	s1,a0
    80000f32:	6905                	lui	s2,0x1
    80000f34:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000f36:	4985                	li	s3,1
    80000f38:	a821                	j	80000f50 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000f3a:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000f3c:	0532                	slli	a0,a0,0xc
    80000f3e:	00000097          	auipc	ra,0x0
    80000f42:	fe0080e7          	jalr	-32(ra) # 80000f1e <freewalk>
      pagetable[i] = 0;
    80000f46:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000f4a:	04a1                	addi	s1,s1,8
    80000f4c:	03248163          	beq	s1,s2,80000f6e <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000f50:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000f52:	00f57793          	andi	a5,a0,15
    80000f56:	ff3782e3          	beq	a5,s3,80000f3a <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000f5a:	8905                	andi	a0,a0,1
    80000f5c:	d57d                	beqz	a0,80000f4a <freewalk+0x2c>
      panic("freewalk: leaf");
    80000f5e:	00006517          	auipc	a0,0x6
    80000f62:	26250513          	addi	a0,a0,610 # 800071c0 <userret+0x130>
    80000f66:	fffff097          	auipc	ra,0xfffff
    80000f6a:	5e8080e7          	jalr	1512(ra) # 8000054e <panic>
    }
  }
  kfree((void*)pagetable);
    80000f6e:	8552                	mv	a0,s4
    80000f70:	00000097          	auipc	ra,0x0
    80000f74:	8f4080e7          	jalr	-1804(ra) # 80000864 <kfree>
}
    80000f78:	70a2                	ld	ra,40(sp)
    80000f7a:	7402                	ld	s0,32(sp)
    80000f7c:	64e2                	ld	s1,24(sp)
    80000f7e:	6942                	ld	s2,16(sp)
    80000f80:	69a2                	ld	s3,8(sp)
    80000f82:	6a02                	ld	s4,0(sp)
    80000f84:	6145                	addi	sp,sp,48
    80000f86:	8082                	ret

0000000080000f88 <kvminithart>:
{
    80000f88:	1141                	addi	sp,sp,-16
    80000f8a:	e422                	sd	s0,8(sp)
    80000f8c:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f8e:	00028797          	auipc	a5,0x28
    80000f92:	0a27b783          	ld	a5,162(a5) # 80029030 <kernel_pagetable>
    80000f96:	83b1                	srli	a5,a5,0xc
    80000f98:	577d                	li	a4,-1
    80000f9a:	177e                	slli	a4,a4,0x3f
    80000f9c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f9e:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fa2:	12000073          	sfence.vma
}
    80000fa6:	6422                	ld	s0,8(sp)
    80000fa8:	0141                	addi	sp,sp,16
    80000faa:	8082                	ret

0000000080000fac <walkaddr>:
{
    80000fac:	1141                	addi	sp,sp,-16
    80000fae:	e406                	sd	ra,8(sp)
    80000fb0:	e022                	sd	s0,0(sp)
    80000fb2:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fb4:	4601                	li	a2,0
    80000fb6:	00000097          	auipc	ra,0x0
    80000fba:	ec2080e7          	jalr	-318(ra) # 80000e78 <walk>
  if(pte == 0)
    80000fbe:	c105                	beqz	a0,80000fde <walkaddr+0x32>
  if((*pte & PTE_V) == 0)
    80000fc0:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000fc2:	0117f693          	andi	a3,a5,17
    80000fc6:	4745                	li	a4,17
    return 0;
    80000fc8:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000fca:	00e68663          	beq	a3,a4,80000fd6 <walkaddr+0x2a>
}
    80000fce:	60a2                	ld	ra,8(sp)
    80000fd0:	6402                	ld	s0,0(sp)
    80000fd2:	0141                	addi	sp,sp,16
    80000fd4:	8082                	ret
  pa = PTE2PA(*pte);
    80000fd6:	83a9                	srli	a5,a5,0xa
    80000fd8:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000fdc:	bfcd                	j	80000fce <walkaddr+0x22>
    return 0;
    80000fde:	4501                	li	a0,0
    80000fe0:	b7fd                	j	80000fce <walkaddr+0x22>

0000000080000fe2 <kvmpa>:
{
    80000fe2:	1101                	addi	sp,sp,-32
    80000fe4:	ec06                	sd	ra,24(sp)
    80000fe6:	e822                	sd	s0,16(sp)
    80000fe8:	e426                	sd	s1,8(sp)
    80000fea:	1000                	addi	s0,sp,32
    80000fec:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    80000fee:	1552                	slli	a0,a0,0x34
    80000ff0:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    80000ff4:	4601                	li	a2,0
    80000ff6:	00028517          	auipc	a0,0x28
    80000ffa:	03a53503          	ld	a0,58(a0) # 80029030 <kernel_pagetable>
    80000ffe:	00000097          	auipc	ra,0x0
    80001002:	e7a080e7          	jalr	-390(ra) # 80000e78 <walk>
  if(pte == 0)
    80001006:	cd09                	beqz	a0,80001020 <kvmpa+0x3e>
  if((*pte & PTE_V) == 0)
    80001008:	6108                	ld	a0,0(a0)
    8000100a:	00157793          	andi	a5,a0,1
    8000100e:	c38d                	beqz	a5,80001030 <kvmpa+0x4e>
  pa = PTE2PA(*pte);
    80001010:	8129                	srli	a0,a0,0xa
    80001012:	0532                	slli	a0,a0,0xc
}
    80001014:	9526                	add	a0,a0,s1
    80001016:	60e2                	ld	ra,24(sp)
    80001018:	6442                	ld	s0,16(sp)
    8000101a:	64a2                	ld	s1,8(sp)
    8000101c:	6105                	addi	sp,sp,32
    8000101e:	8082                	ret
    panic("kvmpa");
    80001020:	00006517          	auipc	a0,0x6
    80001024:	1b050513          	addi	a0,a0,432 # 800071d0 <userret+0x140>
    80001028:	fffff097          	auipc	ra,0xfffff
    8000102c:	526080e7          	jalr	1318(ra) # 8000054e <panic>
    panic("kvmpa");
    80001030:	00006517          	auipc	a0,0x6
    80001034:	1a050513          	addi	a0,a0,416 # 800071d0 <userret+0x140>
    80001038:	fffff097          	auipc	ra,0xfffff
    8000103c:	516080e7          	jalr	1302(ra) # 8000054e <panic>

0000000080001040 <mappages>:
{
    80001040:	715d                	addi	sp,sp,-80
    80001042:	e486                	sd	ra,72(sp)
    80001044:	e0a2                	sd	s0,64(sp)
    80001046:	fc26                	sd	s1,56(sp)
    80001048:	f84a                	sd	s2,48(sp)
    8000104a:	f44e                	sd	s3,40(sp)
    8000104c:	f052                	sd	s4,32(sp)
    8000104e:	ec56                	sd	s5,24(sp)
    80001050:	e85a                	sd	s6,16(sp)
    80001052:	e45e                	sd	s7,8(sp)
    80001054:	0880                	addi	s0,sp,80
    80001056:	8aaa                	mv	s5,a0
    80001058:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    8000105a:	777d                	lui	a4,0xfffff
    8000105c:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001060:	167d                	addi	a2,a2,-1
    80001062:	00b609b3          	add	s3,a2,a1
    80001066:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000106a:	893e                	mv	s2,a5
    8000106c:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    80001070:	6b85                	lui	s7,0x1
    80001072:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001076:	4605                	li	a2,1
    80001078:	85ca                	mv	a1,s2
    8000107a:	8556                	mv	a0,s5
    8000107c:	00000097          	auipc	ra,0x0
    80001080:	dfc080e7          	jalr	-516(ra) # 80000e78 <walk>
    80001084:	c51d                	beqz	a0,800010b2 <mappages+0x72>
    if(*pte & PTE_V)
    80001086:	611c                	ld	a5,0(a0)
    80001088:	8b85                	andi	a5,a5,1
    8000108a:	ef81                	bnez	a5,800010a2 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000108c:	80b1                	srli	s1,s1,0xc
    8000108e:	04aa                	slli	s1,s1,0xa
    80001090:	0164e4b3          	or	s1,s1,s6
    80001094:	0014e493          	ori	s1,s1,1
    80001098:	e104                	sd	s1,0(a0)
    if(a == last)
    8000109a:	03390863          	beq	s2,s3,800010ca <mappages+0x8a>
    a += PGSIZE;
    8000109e:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010a0:	bfc9                	j	80001072 <mappages+0x32>
      panic("remap");
    800010a2:	00006517          	auipc	a0,0x6
    800010a6:	13650513          	addi	a0,a0,310 # 800071d8 <userret+0x148>
    800010aa:	fffff097          	auipc	ra,0xfffff
    800010ae:	4a4080e7          	jalr	1188(ra) # 8000054e <panic>
      return -1;
    800010b2:	557d                	li	a0,-1
}
    800010b4:	60a6                	ld	ra,72(sp)
    800010b6:	6406                	ld	s0,64(sp)
    800010b8:	74e2                	ld	s1,56(sp)
    800010ba:	7942                	ld	s2,48(sp)
    800010bc:	79a2                	ld	s3,40(sp)
    800010be:	7a02                	ld	s4,32(sp)
    800010c0:	6ae2                	ld	s5,24(sp)
    800010c2:	6b42                	ld	s6,16(sp)
    800010c4:	6ba2                	ld	s7,8(sp)
    800010c6:	6161                	addi	sp,sp,80
    800010c8:	8082                	ret
  return 0;
    800010ca:	4501                	li	a0,0
    800010cc:	b7e5                	j	800010b4 <mappages+0x74>

00000000800010ce <kvmmap>:
{
    800010ce:	1141                	addi	sp,sp,-16
    800010d0:	e406                	sd	ra,8(sp)
    800010d2:	e022                	sd	s0,0(sp)
    800010d4:	0800                	addi	s0,sp,16
    800010d6:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800010d8:	86ae                	mv	a3,a1
    800010da:	85aa                	mv	a1,a0
    800010dc:	00028517          	auipc	a0,0x28
    800010e0:	f5453503          	ld	a0,-172(a0) # 80029030 <kernel_pagetable>
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	f5c080e7          	jalr	-164(ra) # 80001040 <mappages>
    800010ec:	e509                	bnez	a0,800010f6 <kvmmap+0x28>
}
    800010ee:	60a2                	ld	ra,8(sp)
    800010f0:	6402                	ld	s0,0(sp)
    800010f2:	0141                	addi	sp,sp,16
    800010f4:	8082                	ret
    panic("kvmmap");
    800010f6:	00006517          	auipc	a0,0x6
    800010fa:	0ea50513          	addi	a0,a0,234 # 800071e0 <userret+0x150>
    800010fe:	fffff097          	auipc	ra,0xfffff
    80001102:	450080e7          	jalr	1104(ra) # 8000054e <panic>

0000000080001106 <kvminit>:
{
    80001106:	1101                	addi	sp,sp,-32
    80001108:	ec06                	sd	ra,24(sp)
    8000110a:	e822                	sd	s0,16(sp)
    8000110c:	e426                	sd	s1,8(sp)
    8000110e:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    80001110:	00000097          	auipc	ra,0x0
    80001114:	868080e7          	jalr	-1944(ra) # 80000978 <kalloc>
    80001118:	00028797          	auipc	a5,0x28
    8000111c:	f0a7bc23          	sd	a0,-232(a5) # 80029030 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    80001120:	6605                	lui	a2,0x1
    80001122:	4581                	li	a1,0
    80001124:	00000097          	auipc	ra,0x0
    80001128:	a8a080e7          	jalr	-1398(ra) # 80000bae <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000112c:	4699                	li	a3,6
    8000112e:	6605                	lui	a2,0x1
    80001130:	100005b7          	lui	a1,0x10000
    80001134:	10000537          	lui	a0,0x10000
    80001138:	00000097          	auipc	ra,0x0
    8000113c:	f96080e7          	jalr	-106(ra) # 800010ce <kvmmap>
  kvmmap(VIRTION(0), VIRTION(0), PGSIZE, PTE_R | PTE_W);
    80001140:	4699                	li	a3,6
    80001142:	6605                	lui	a2,0x1
    80001144:	100015b7          	lui	a1,0x10001
    80001148:	10001537          	lui	a0,0x10001
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	f82080e7          	jalr	-126(ra) # 800010ce <kvmmap>
  kvmmap(VIRTION(1), VIRTION(1), PGSIZE, PTE_R | PTE_W);
    80001154:	4699                	li	a3,6
    80001156:	6605                	lui	a2,0x1
    80001158:	100025b7          	lui	a1,0x10002
    8000115c:	10002537          	lui	a0,0x10002
    80001160:	00000097          	auipc	ra,0x0
    80001164:	f6e080e7          	jalr	-146(ra) # 800010ce <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001168:	4699                	li	a3,6
    8000116a:	6641                	lui	a2,0x10
    8000116c:	020005b7          	lui	a1,0x2000
    80001170:	02000537          	lui	a0,0x2000
    80001174:	00000097          	auipc	ra,0x0
    80001178:	f5a080e7          	jalr	-166(ra) # 800010ce <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000117c:	4699                	li	a3,6
    8000117e:	00400637          	lui	a2,0x400
    80001182:	0c0005b7          	lui	a1,0xc000
    80001186:	0c000537          	lui	a0,0xc000
    8000118a:	00000097          	auipc	ra,0x0
    8000118e:	f44080e7          	jalr	-188(ra) # 800010ce <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001192:	00007497          	auipc	s1,0x7
    80001196:	e6e48493          	addi	s1,s1,-402 # 80008000 <initcode>
    8000119a:	46a9                	li	a3,10
    8000119c:	80007617          	auipc	a2,0x80007
    800011a0:	e6460613          	addi	a2,a2,-412 # 8000 <_entry-0x7fff8000>
    800011a4:	4585                	li	a1,1
    800011a6:	05fe                	slli	a1,a1,0x1f
    800011a8:	852e                	mv	a0,a1
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	f24080e7          	jalr	-220(ra) # 800010ce <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011b2:	4699                	li	a3,6
    800011b4:	4645                	li	a2,17
    800011b6:	066e                	slli	a2,a2,0x1b
    800011b8:	8e05                	sub	a2,a2,s1
    800011ba:	85a6                	mv	a1,s1
    800011bc:	8526                	mv	a0,s1
    800011be:	00000097          	auipc	ra,0x0
    800011c2:	f10080e7          	jalr	-240(ra) # 800010ce <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011c6:	46a9                	li	a3,10
    800011c8:	6605                	lui	a2,0x1
    800011ca:	00006597          	auipc	a1,0x6
    800011ce:	e3658593          	addi	a1,a1,-458 # 80007000 <trampoline>
    800011d2:	04000537          	lui	a0,0x4000
    800011d6:	157d                	addi	a0,a0,-1
    800011d8:	0532                	slli	a0,a0,0xc
    800011da:	00000097          	auipc	ra,0x0
    800011de:	ef4080e7          	jalr	-268(ra) # 800010ce <kvmmap>
}
    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret

00000000800011ec <uvmunmap>:
{
    800011ec:	715d                	addi	sp,sp,-80
    800011ee:	e486                	sd	ra,72(sp)
    800011f0:	e0a2                	sd	s0,64(sp)
    800011f2:	fc26                	sd	s1,56(sp)
    800011f4:	f84a                	sd	s2,48(sp)
    800011f6:	f44e                	sd	s3,40(sp)
    800011f8:	f052                	sd	s4,32(sp)
    800011fa:	ec56                	sd	s5,24(sp)
    800011fc:	e85a                	sd	s6,16(sp)
    800011fe:	e45e                	sd	s7,8(sp)
    80001200:	0880                	addi	s0,sp,80
    80001202:	8a2a                	mv	s4,a0
    80001204:	8ab6                	mv	s5,a3
  a = PGROUNDDOWN(va);
    80001206:	77fd                	lui	a5,0xfffff
    80001208:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000120c:	167d                	addi	a2,a2,-1
    8000120e:	00b609b3          	add	s3,a2,a1
    80001212:	00f9f9b3          	and	s3,s3,a5
    if(PTE_FLAGS(*pte) == PTE_V)
    80001216:	4b05                	li	s6,1
    a += PGSIZE;
    80001218:	6b85                	lui	s7,0x1
    8000121a:	a8b1                	j	80001276 <uvmunmap+0x8a>
      panic("uvmunmap: walk");
    8000121c:	00006517          	auipc	a0,0x6
    80001220:	fcc50513          	addi	a0,a0,-52 # 800071e8 <userret+0x158>
    80001224:	fffff097          	auipc	ra,0xfffff
    80001228:	32a080e7          	jalr	810(ra) # 8000054e <panic>
      printf("va=%p pte=%p\n", a, *pte);
    8000122c:	862a                	mv	a2,a0
    8000122e:	85ca                	mv	a1,s2
    80001230:	00006517          	auipc	a0,0x6
    80001234:	fc850513          	addi	a0,a0,-56 # 800071f8 <userret+0x168>
    80001238:	fffff097          	auipc	ra,0xfffff
    8000123c:	360080e7          	jalr	864(ra) # 80000598 <printf>
      panic("uvmunmap: not mapped");
    80001240:	00006517          	auipc	a0,0x6
    80001244:	fc850513          	addi	a0,a0,-56 # 80007208 <userret+0x178>
    80001248:	fffff097          	auipc	ra,0xfffff
    8000124c:	306080e7          	jalr	774(ra) # 8000054e <panic>
      panic("uvmunmap: not a leaf");
    80001250:	00006517          	auipc	a0,0x6
    80001254:	fd050513          	addi	a0,a0,-48 # 80007220 <userret+0x190>
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	2f6080e7          	jalr	758(ra) # 8000054e <panic>
      pa = PTE2PA(*pte);
    80001260:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001262:	0532                	slli	a0,a0,0xc
    80001264:	fffff097          	auipc	ra,0xfffff
    80001268:	600080e7          	jalr	1536(ra) # 80000864 <kfree>
    *pte = 0;
    8000126c:	0004b023          	sd	zero,0(s1)
    if(a == last)
    80001270:	03390763          	beq	s2,s3,8000129e <uvmunmap+0xb2>
    a += PGSIZE;
    80001274:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 0)) == 0)
    80001276:	4601                	li	a2,0
    80001278:	85ca                	mv	a1,s2
    8000127a:	8552                	mv	a0,s4
    8000127c:	00000097          	auipc	ra,0x0
    80001280:	bfc080e7          	jalr	-1028(ra) # 80000e78 <walk>
    80001284:	84aa                	mv	s1,a0
    80001286:	d959                	beqz	a0,8000121c <uvmunmap+0x30>
    if((*pte & PTE_V) == 0){
    80001288:	6108                	ld	a0,0(a0)
    8000128a:	00157793          	andi	a5,a0,1
    8000128e:	dfd9                	beqz	a5,8000122c <uvmunmap+0x40>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001290:	01f57793          	andi	a5,a0,31
    80001294:	fb678ee3          	beq	a5,s6,80001250 <uvmunmap+0x64>
    if(do_free){
    80001298:	fc0a8ae3          	beqz	s5,8000126c <uvmunmap+0x80>
    8000129c:	b7d1                	j	80001260 <uvmunmap+0x74>
}
    8000129e:	60a6                	ld	ra,72(sp)
    800012a0:	6406                	ld	s0,64(sp)
    800012a2:	74e2                	ld	s1,56(sp)
    800012a4:	7942                	ld	s2,48(sp)
    800012a6:	79a2                	ld	s3,40(sp)
    800012a8:	7a02                	ld	s4,32(sp)
    800012aa:	6ae2                	ld	s5,24(sp)
    800012ac:	6b42                	ld	s6,16(sp)
    800012ae:	6ba2                	ld	s7,8(sp)
    800012b0:	6161                	addi	sp,sp,80
    800012b2:	8082                	ret

00000000800012b4 <uvmcreate>:
{
    800012b4:	1101                	addi	sp,sp,-32
    800012b6:	ec06                	sd	ra,24(sp)
    800012b8:	e822                	sd	s0,16(sp)
    800012ba:	e426                	sd	s1,8(sp)
    800012bc:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    800012be:	fffff097          	auipc	ra,0xfffff
    800012c2:	6ba080e7          	jalr	1722(ra) # 80000978 <kalloc>
  if(pagetable == 0)
    800012c6:	cd11                	beqz	a0,800012e2 <uvmcreate+0x2e>
    800012c8:	84aa                	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
    800012ca:	6605                	lui	a2,0x1
    800012cc:	4581                	li	a1,0
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	8e0080e7          	jalr	-1824(ra) # 80000bae <memset>
}
    800012d6:	8526                	mv	a0,s1
    800012d8:	60e2                	ld	ra,24(sp)
    800012da:	6442                	ld	s0,16(sp)
    800012dc:	64a2                	ld	s1,8(sp)
    800012de:	6105                	addi	sp,sp,32
    800012e0:	8082                	ret
    panic("uvmcreate: out of memory");
    800012e2:	00006517          	auipc	a0,0x6
    800012e6:	f5650513          	addi	a0,a0,-170 # 80007238 <userret+0x1a8>
    800012ea:	fffff097          	auipc	ra,0xfffff
    800012ee:	264080e7          	jalr	612(ra) # 8000054e <panic>

00000000800012f2 <uvminit>:
{
    800012f2:	7179                	addi	sp,sp,-48
    800012f4:	f406                	sd	ra,40(sp)
    800012f6:	f022                	sd	s0,32(sp)
    800012f8:	ec26                	sd	s1,24(sp)
    800012fa:	e84a                	sd	s2,16(sp)
    800012fc:	e44e                	sd	s3,8(sp)
    800012fe:	e052                	sd	s4,0(sp)
    80001300:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    80001302:	6785                	lui	a5,0x1
    80001304:	04f67863          	bgeu	a2,a5,80001354 <uvminit+0x62>
    80001308:	8a2a                	mv	s4,a0
    8000130a:	89ae                	mv	s3,a1
    8000130c:	84b2                	mv	s1,a2
  mem = kalloc();
    8000130e:	fffff097          	auipc	ra,0xfffff
    80001312:	66a080e7          	jalr	1642(ra) # 80000978 <kalloc>
    80001316:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001318:	6605                	lui	a2,0x1
    8000131a:	4581                	li	a1,0
    8000131c:	00000097          	auipc	ra,0x0
    80001320:	892080e7          	jalr	-1902(ra) # 80000bae <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001324:	4779                	li	a4,30
    80001326:	86ca                	mv	a3,s2
    80001328:	6605                	lui	a2,0x1
    8000132a:	4581                	li	a1,0
    8000132c:	8552                	mv	a0,s4
    8000132e:	00000097          	auipc	ra,0x0
    80001332:	d12080e7          	jalr	-750(ra) # 80001040 <mappages>
  memmove(mem, src, sz);
    80001336:	8626                	mv	a2,s1
    80001338:	85ce                	mv	a1,s3
    8000133a:	854a                	mv	a0,s2
    8000133c:	00000097          	auipc	ra,0x0
    80001340:	8d2080e7          	jalr	-1838(ra) # 80000c0e <memmove>
}
    80001344:	70a2                	ld	ra,40(sp)
    80001346:	7402                	ld	s0,32(sp)
    80001348:	64e2                	ld	s1,24(sp)
    8000134a:	6942                	ld	s2,16(sp)
    8000134c:	69a2                	ld	s3,8(sp)
    8000134e:	6a02                	ld	s4,0(sp)
    80001350:	6145                	addi	sp,sp,48
    80001352:	8082                	ret
    panic("inituvm: more than a page");
    80001354:	00006517          	auipc	a0,0x6
    80001358:	f0450513          	addi	a0,a0,-252 # 80007258 <userret+0x1c8>
    8000135c:	fffff097          	auipc	ra,0xfffff
    80001360:	1f2080e7          	jalr	498(ra) # 8000054e <panic>

0000000080001364 <uvmdealloc>:
{
    80001364:	87aa                	mv	a5,a0
    80001366:	852e                	mv	a0,a1
  if(newsz >= oldsz)
    80001368:	00b66363          	bltu	a2,a1,8000136e <uvmdealloc+0xa>
}
    8000136c:	8082                	ret
{
    8000136e:	1101                	addi	sp,sp,-32
    80001370:	ec06                	sd	ra,24(sp)
    80001372:	e822                	sd	s0,16(sp)
    80001374:	e426                	sd	s1,8(sp)
    80001376:	1000                	addi	s0,sp,32
    80001378:	84b2                	mv	s1,a2
  uvmunmap(pagetable, newsz, oldsz - newsz, 1);
    8000137a:	4685                	li	a3,1
    8000137c:	40c58633          	sub	a2,a1,a2
    80001380:	85a6                	mv	a1,s1
    80001382:	853e                	mv	a0,a5
    80001384:	00000097          	auipc	ra,0x0
    80001388:	e68080e7          	jalr	-408(ra) # 800011ec <uvmunmap>
  return newsz;
    8000138c:	8526                	mv	a0,s1
}
    8000138e:	60e2                	ld	ra,24(sp)
    80001390:	6442                	ld	s0,16(sp)
    80001392:	64a2                	ld	s1,8(sp)
    80001394:	6105                	addi	sp,sp,32
    80001396:	8082                	ret

0000000080001398 <uvmalloc>:
  if(newsz < oldsz)
    80001398:	0ab66163          	bltu	a2,a1,8000143a <uvmalloc+0xa2>
{
    8000139c:	7139                	addi	sp,sp,-64
    8000139e:	fc06                	sd	ra,56(sp)
    800013a0:	f822                	sd	s0,48(sp)
    800013a2:	f426                	sd	s1,40(sp)
    800013a4:	f04a                	sd	s2,32(sp)
    800013a6:	ec4e                	sd	s3,24(sp)
    800013a8:	e852                	sd	s4,16(sp)
    800013aa:	e456                	sd	s5,8(sp)
    800013ac:	0080                	addi	s0,sp,64
    800013ae:	8aaa                	mv	s5,a0
    800013b0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800013b2:	6985                	lui	s3,0x1
    800013b4:	19fd                	addi	s3,s3,-1
    800013b6:	95ce                	add	a1,a1,s3
    800013b8:	79fd                	lui	s3,0xfffff
    800013ba:	0135f9b3          	and	s3,a1,s3
  for(; a < newsz; a += PGSIZE){
    800013be:	08c9f063          	bgeu	s3,a2,8000143e <uvmalloc+0xa6>
  a = oldsz;
    800013c2:	894e                	mv	s2,s3
    mem = kalloc();
    800013c4:	fffff097          	auipc	ra,0xfffff
    800013c8:	5b4080e7          	jalr	1460(ra) # 80000978 <kalloc>
    800013cc:	84aa                	mv	s1,a0
    if(mem == 0){
    800013ce:	c51d                	beqz	a0,800013fc <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800013d0:	6605                	lui	a2,0x1
    800013d2:	4581                	li	a1,0
    800013d4:	fffff097          	auipc	ra,0xfffff
    800013d8:	7da080e7          	jalr	2010(ra) # 80000bae <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800013dc:	4779                	li	a4,30
    800013de:	86a6                	mv	a3,s1
    800013e0:	6605                	lui	a2,0x1
    800013e2:	85ca                	mv	a1,s2
    800013e4:	8556                	mv	a0,s5
    800013e6:	00000097          	auipc	ra,0x0
    800013ea:	c5a080e7          	jalr	-934(ra) # 80001040 <mappages>
    800013ee:	e905                	bnez	a0,8000141e <uvmalloc+0x86>
  for(; a < newsz; a += PGSIZE){
    800013f0:	6785                	lui	a5,0x1
    800013f2:	993e                	add	s2,s2,a5
    800013f4:	fd4968e3          	bltu	s2,s4,800013c4 <uvmalloc+0x2c>
  return newsz;
    800013f8:	8552                	mv	a0,s4
    800013fa:	a809                	j	8000140c <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800013fc:	864e                	mv	a2,s3
    800013fe:	85ca                	mv	a1,s2
    80001400:	8556                	mv	a0,s5
    80001402:	00000097          	auipc	ra,0x0
    80001406:	f62080e7          	jalr	-158(ra) # 80001364 <uvmdealloc>
      return 0;
    8000140a:	4501                	li	a0,0
}
    8000140c:	70e2                	ld	ra,56(sp)
    8000140e:	7442                	ld	s0,48(sp)
    80001410:	74a2                	ld	s1,40(sp)
    80001412:	7902                	ld	s2,32(sp)
    80001414:	69e2                	ld	s3,24(sp)
    80001416:	6a42                	ld	s4,16(sp)
    80001418:	6aa2                	ld	s5,8(sp)
    8000141a:	6121                	addi	sp,sp,64
    8000141c:	8082                	ret
      kfree(mem);
    8000141e:	8526                	mv	a0,s1
    80001420:	fffff097          	auipc	ra,0xfffff
    80001424:	444080e7          	jalr	1092(ra) # 80000864 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001428:	864e                	mv	a2,s3
    8000142a:	85ca                	mv	a1,s2
    8000142c:	8556                	mv	a0,s5
    8000142e:	00000097          	auipc	ra,0x0
    80001432:	f36080e7          	jalr	-202(ra) # 80001364 <uvmdealloc>
      return 0;
    80001436:	4501                	li	a0,0
    80001438:	bfd1                	j	8000140c <uvmalloc+0x74>
    return oldsz;
    8000143a:	852e                	mv	a0,a1
}
    8000143c:	8082                	ret
  return newsz;
    8000143e:	8532                	mv	a0,a2
    80001440:	b7f1                	j	8000140c <uvmalloc+0x74>

0000000080001442 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001442:	1101                	addi	sp,sp,-32
    80001444:	ec06                	sd	ra,24(sp)
    80001446:	e822                	sd	s0,16(sp)
    80001448:	e426                	sd	s1,8(sp)
    8000144a:	1000                	addi	s0,sp,32
    8000144c:	84aa                	mv	s1,a0
    8000144e:	862e                	mv	a2,a1
  uvmunmap(pagetable, 0, sz, 1);
    80001450:	4685                	li	a3,1
    80001452:	4581                	li	a1,0
    80001454:	00000097          	auipc	ra,0x0
    80001458:	d98080e7          	jalr	-616(ra) # 800011ec <uvmunmap>
  freewalk(pagetable);
    8000145c:	8526                	mv	a0,s1
    8000145e:	00000097          	auipc	ra,0x0
    80001462:	ac0080e7          	jalr	-1344(ra) # 80000f1e <freewalk>
}
    80001466:	60e2                	ld	ra,24(sp)
    80001468:	6442                	ld	s0,16(sp)
    8000146a:	64a2                	ld	s1,8(sp)
    8000146c:	6105                	addi	sp,sp,32
    8000146e:	8082                	ret

0000000080001470 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001470:	c671                	beqz	a2,8000153c <uvmcopy+0xcc>
{
    80001472:	715d                	addi	sp,sp,-80
    80001474:	e486                	sd	ra,72(sp)
    80001476:	e0a2                	sd	s0,64(sp)
    80001478:	fc26                	sd	s1,56(sp)
    8000147a:	f84a                	sd	s2,48(sp)
    8000147c:	f44e                	sd	s3,40(sp)
    8000147e:	f052                	sd	s4,32(sp)
    80001480:	ec56                	sd	s5,24(sp)
    80001482:	e85a                	sd	s6,16(sp)
    80001484:	e45e                	sd	s7,8(sp)
    80001486:	0880                	addi	s0,sp,80
    80001488:	8b2a                	mv	s6,a0
    8000148a:	8aae                	mv	s5,a1
    8000148c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000148e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001490:	4601                	li	a2,0
    80001492:	85ce                	mv	a1,s3
    80001494:	855a                	mv	a0,s6
    80001496:	00000097          	auipc	ra,0x0
    8000149a:	9e2080e7          	jalr	-1566(ra) # 80000e78 <walk>
    8000149e:	c531                	beqz	a0,800014ea <uvmcopy+0x7a>
      panic("copyuvm: pte should exist");
    if((*pte & PTE_V) == 0)
    800014a0:	6118                	ld	a4,0(a0)
    800014a2:	00177793          	andi	a5,a4,1
    800014a6:	cbb1                	beqz	a5,800014fa <uvmcopy+0x8a>
      panic("copyuvm: page not present");
    pa = PTE2PA(*pte);
    800014a8:	00a75593          	srli	a1,a4,0xa
    800014ac:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014b0:	01f77493          	andi	s1,a4,31
    if((mem = kalloc()) == 0)
    800014b4:	fffff097          	auipc	ra,0xfffff
    800014b8:	4c4080e7          	jalr	1220(ra) # 80000978 <kalloc>
    800014bc:	892a                	mv	s2,a0
    800014be:	c939                	beqz	a0,80001514 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014c0:	6605                	lui	a2,0x1
    800014c2:	85de                	mv	a1,s7
    800014c4:	fffff097          	auipc	ra,0xfffff
    800014c8:	74a080e7          	jalr	1866(ra) # 80000c0e <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014cc:	8726                	mv	a4,s1
    800014ce:	86ca                	mv	a3,s2
    800014d0:	6605                	lui	a2,0x1
    800014d2:	85ce                	mv	a1,s3
    800014d4:	8556                	mv	a0,s5
    800014d6:	00000097          	auipc	ra,0x0
    800014da:	b6a080e7          	jalr	-1174(ra) # 80001040 <mappages>
    800014de:	e515                	bnez	a0,8000150a <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800014e0:	6785                	lui	a5,0x1
    800014e2:	99be                	add	s3,s3,a5
    800014e4:	fb49e6e3          	bltu	s3,s4,80001490 <uvmcopy+0x20>
    800014e8:	a83d                	j	80001526 <uvmcopy+0xb6>
      panic("copyuvm: pte should exist");
    800014ea:	00006517          	auipc	a0,0x6
    800014ee:	d8e50513          	addi	a0,a0,-626 # 80007278 <userret+0x1e8>
    800014f2:	fffff097          	auipc	ra,0xfffff
    800014f6:	05c080e7          	jalr	92(ra) # 8000054e <panic>
      panic("copyuvm: page not present");
    800014fa:	00006517          	auipc	a0,0x6
    800014fe:	d9e50513          	addi	a0,a0,-610 # 80007298 <userret+0x208>
    80001502:	fffff097          	auipc	ra,0xfffff
    80001506:	04c080e7          	jalr	76(ra) # 8000054e <panic>
      kfree(mem);
    8000150a:	854a                	mv	a0,s2
    8000150c:	fffff097          	auipc	ra,0xfffff
    80001510:	358080e7          	jalr	856(ra) # 80000864 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
    80001514:	4685                	li	a3,1
    80001516:	864e                	mv	a2,s3
    80001518:	4581                	li	a1,0
    8000151a:	8556                	mv	a0,s5
    8000151c:	00000097          	auipc	ra,0x0
    80001520:	cd0080e7          	jalr	-816(ra) # 800011ec <uvmunmap>
  return -1;
    80001524:	557d                	li	a0,-1
}
    80001526:	60a6                	ld	ra,72(sp)
    80001528:	6406                	ld	s0,64(sp)
    8000152a:	74e2                	ld	s1,56(sp)
    8000152c:	7942                	ld	s2,48(sp)
    8000152e:	79a2                	ld	s3,40(sp)
    80001530:	7a02                	ld	s4,32(sp)
    80001532:	6ae2                	ld	s5,24(sp)
    80001534:	6b42                	ld	s6,16(sp)
    80001536:	6ba2                	ld	s7,8(sp)
    80001538:	6161                	addi	sp,sp,80
    8000153a:	8082                	ret
  return 0;
    8000153c:	4501                	li	a0,0
}
    8000153e:	8082                	ret

0000000080001540 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001540:	1141                	addi	sp,sp,-16
    80001542:	e406                	sd	ra,8(sp)
    80001544:	e022                	sd	s0,0(sp)
    80001546:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001548:	4601                	li	a2,0
    8000154a:	00000097          	auipc	ra,0x0
    8000154e:	92e080e7          	jalr	-1746(ra) # 80000e78 <walk>
  if(pte == 0)
    80001552:	c901                	beqz	a0,80001562 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001554:	611c                	ld	a5,0(a0)
    80001556:	9bbd                	andi	a5,a5,-17
    80001558:	e11c                	sd	a5,0(a0)
}
    8000155a:	60a2                	ld	ra,8(sp)
    8000155c:	6402                	ld	s0,0(sp)
    8000155e:	0141                	addi	sp,sp,16
    80001560:	8082                	ret
    panic("uvmclear");
    80001562:	00006517          	auipc	a0,0x6
    80001566:	d5650513          	addi	a0,a0,-682 # 800072b8 <userret+0x228>
    8000156a:	fffff097          	auipc	ra,0xfffff
    8000156e:	fe4080e7          	jalr	-28(ra) # 8000054e <panic>

0000000080001572 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001572:	cab5                	beqz	a3,800015e6 <copyout+0x74>
{
    80001574:	715d                	addi	sp,sp,-80
    80001576:	e486                	sd	ra,72(sp)
    80001578:	e0a2                	sd	s0,64(sp)
    8000157a:	fc26                	sd	s1,56(sp)
    8000157c:	f84a                	sd	s2,48(sp)
    8000157e:	f44e                	sd	s3,40(sp)
    80001580:	f052                	sd	s4,32(sp)
    80001582:	ec56                	sd	s5,24(sp)
    80001584:	e85a                	sd	s6,16(sp)
    80001586:	e45e                	sd	s7,8(sp)
    80001588:	e062                	sd	s8,0(sp)
    8000158a:	0880                	addi	s0,sp,80
    8000158c:	8baa                	mv	s7,a0
    8000158e:	8c2e                	mv	s8,a1
    80001590:	8a32                	mv	s4,a2
    80001592:	89b6                	mv	s3,a3
    va0 = (uint)PGROUNDDOWN(dstva);
    80001594:	00100b37          	lui	s6,0x100
    80001598:	1b7d                	addi	s6,s6,-1
    8000159a:	0b32                	slli	s6,s6,0xc
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000159c:	6a85                	lui	s5,0x1
    8000159e:	a015                	j	800015c2 <copyout+0x50>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015a0:	9562                	add	a0,a0,s8
    800015a2:	0004861b          	sext.w	a2,s1
    800015a6:	85d2                	mv	a1,s4
    800015a8:	41250533          	sub	a0,a0,s2
    800015ac:	fffff097          	auipc	ra,0xfffff
    800015b0:	662080e7          	jalr	1634(ra) # 80000c0e <memmove>

    len -= n;
    800015b4:	409989b3          	sub	s3,s3,s1
    src += n;
    800015b8:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800015ba:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800015be:	02098263          	beqz	s3,800015e2 <copyout+0x70>
    va0 = (uint)PGROUNDDOWN(dstva);
    800015c2:	016c7933          	and	s2,s8,s6
    pa0 = walkaddr(pagetable, va0);
    800015c6:	85ca                	mv	a1,s2
    800015c8:	855e                	mv	a0,s7
    800015ca:	00000097          	auipc	ra,0x0
    800015ce:	9e2080e7          	jalr	-1566(ra) # 80000fac <walkaddr>
    if(pa0 == 0)
    800015d2:	cd01                	beqz	a0,800015ea <copyout+0x78>
    n = PGSIZE - (dstva - va0);
    800015d4:	418904b3          	sub	s1,s2,s8
    800015d8:	94d6                	add	s1,s1,s5
    if(n > len)
    800015da:	fc99f3e3          	bgeu	s3,s1,800015a0 <copyout+0x2e>
    800015de:	84ce                	mv	s1,s3
    800015e0:	b7c1                	j	800015a0 <copyout+0x2e>
  }
  return 0;
    800015e2:	4501                	li	a0,0
    800015e4:	a021                	j	800015ec <copyout+0x7a>
    800015e6:	4501                	li	a0,0
}
    800015e8:	8082                	ret
      return -1;
    800015ea:	557d                	li	a0,-1
}
    800015ec:	60a6                	ld	ra,72(sp)
    800015ee:	6406                	ld	s0,64(sp)
    800015f0:	74e2                	ld	s1,56(sp)
    800015f2:	7942                	ld	s2,48(sp)
    800015f4:	79a2                	ld	s3,40(sp)
    800015f6:	7a02                	ld	s4,32(sp)
    800015f8:	6ae2                	ld	s5,24(sp)
    800015fa:	6b42                	ld	s6,16(sp)
    800015fc:	6ba2                	ld	s7,8(sp)
    800015fe:	6c02                	ld	s8,0(sp)
    80001600:	6161                	addi	sp,sp,80
    80001602:	8082                	ret

0000000080001604 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001604:	cab5                	beqz	a3,80001678 <copyin+0x74>
{
    80001606:	715d                	addi	sp,sp,-80
    80001608:	e486                	sd	ra,72(sp)
    8000160a:	e0a2                	sd	s0,64(sp)
    8000160c:	fc26                	sd	s1,56(sp)
    8000160e:	f84a                	sd	s2,48(sp)
    80001610:	f44e                	sd	s3,40(sp)
    80001612:	f052                	sd	s4,32(sp)
    80001614:	ec56                	sd	s5,24(sp)
    80001616:	e85a                	sd	s6,16(sp)
    80001618:	e45e                	sd	s7,8(sp)
    8000161a:	e062                	sd	s8,0(sp)
    8000161c:	0880                	addi	s0,sp,80
    8000161e:	8baa                	mv	s7,a0
    80001620:	8a2e                	mv	s4,a1
    80001622:	8c32                	mv	s8,a2
    80001624:	89b6                	mv	s3,a3
    va0 = (uint)PGROUNDDOWN(srcva);
    80001626:	00100b37          	lui	s6,0x100
    8000162a:	1b7d                	addi	s6,s6,-1
    8000162c:	0b32                	slli	s6,s6,0xc
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000162e:	6a85                	lui	s5,0x1
    80001630:	a015                	j	80001654 <copyin+0x50>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001632:	9562                	add	a0,a0,s8
    80001634:	0004861b          	sext.w	a2,s1
    80001638:	412505b3          	sub	a1,a0,s2
    8000163c:	8552                	mv	a0,s4
    8000163e:	fffff097          	auipc	ra,0xfffff
    80001642:	5d0080e7          	jalr	1488(ra) # 80000c0e <memmove>

    len -= n;
    80001646:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000164a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000164c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001650:	02098263          	beqz	s3,80001674 <copyin+0x70>
    va0 = (uint)PGROUNDDOWN(srcva);
    80001654:	016c7933          	and	s2,s8,s6
    pa0 = walkaddr(pagetable, va0);
    80001658:	85ca                	mv	a1,s2
    8000165a:	855e                	mv	a0,s7
    8000165c:	00000097          	auipc	ra,0x0
    80001660:	950080e7          	jalr	-1712(ra) # 80000fac <walkaddr>
    if(pa0 == 0)
    80001664:	cd01                	beqz	a0,8000167c <copyin+0x78>
    n = PGSIZE - (srcva - va0);
    80001666:	418904b3          	sub	s1,s2,s8
    8000166a:	94d6                	add	s1,s1,s5
    if(n > len)
    8000166c:	fc99f3e3          	bgeu	s3,s1,80001632 <copyin+0x2e>
    80001670:	84ce                	mv	s1,s3
    80001672:	b7c1                	j	80001632 <copyin+0x2e>
  }
  return 0;
    80001674:	4501                	li	a0,0
    80001676:	a021                	j	8000167e <copyin+0x7a>
    80001678:	4501                	li	a0,0
}
    8000167a:	8082                	ret
      return -1;
    8000167c:	557d                	li	a0,-1
}
    8000167e:	60a6                	ld	ra,72(sp)
    80001680:	6406                	ld	s0,64(sp)
    80001682:	74e2                	ld	s1,56(sp)
    80001684:	7942                	ld	s2,48(sp)
    80001686:	79a2                	ld	s3,40(sp)
    80001688:	7a02                	ld	s4,32(sp)
    8000168a:	6ae2                	ld	s5,24(sp)
    8000168c:	6b42                	ld	s6,16(sp)
    8000168e:	6ba2                	ld	s7,8(sp)
    80001690:	6c02                	ld	s8,0(sp)
    80001692:	6161                	addi	sp,sp,80
    80001694:	8082                	ret

0000000080001696 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001696:	c6dd                	beqz	a3,80001744 <copyinstr+0xae>
{
    80001698:	715d                	addi	sp,sp,-80
    8000169a:	e486                	sd	ra,72(sp)
    8000169c:	e0a2                	sd	s0,64(sp)
    8000169e:	fc26                	sd	s1,56(sp)
    800016a0:	f84a                	sd	s2,48(sp)
    800016a2:	f44e                	sd	s3,40(sp)
    800016a4:	f052                	sd	s4,32(sp)
    800016a6:	ec56                	sd	s5,24(sp)
    800016a8:	e85a                	sd	s6,16(sp)
    800016aa:	e45e                	sd	s7,8(sp)
    800016ac:	0880                	addi	s0,sp,80
    800016ae:	8aaa                	mv	s5,a0
    800016b0:	8b2e                	mv	s6,a1
    800016b2:	8bb2                	mv	s7,a2
    800016b4:	84b6                	mv	s1,a3
    va0 = (uint)PGROUNDDOWN(srcva);
    800016b6:	00100a37          	lui	s4,0x100
    800016ba:	1a7d                	addi	s4,s4,-1
    800016bc:	0a32                	slli	s4,s4,0xc
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016be:	6985                	lui	s3,0x1
    800016c0:	a035                	j	800016ec <copyinstr+0x56>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016c2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016c6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016c8:	0017b793          	seqz	a5,a5
    800016cc:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016d0:	60a6                	ld	ra,72(sp)
    800016d2:	6406                	ld	s0,64(sp)
    800016d4:	74e2                	ld	s1,56(sp)
    800016d6:	7942                	ld	s2,48(sp)
    800016d8:	79a2                	ld	s3,40(sp)
    800016da:	7a02                	ld	s4,32(sp)
    800016dc:	6ae2                	ld	s5,24(sp)
    800016de:	6b42                	ld	s6,16(sp)
    800016e0:	6ba2                	ld	s7,8(sp)
    800016e2:	6161                	addi	sp,sp,80
    800016e4:	8082                	ret
    srcva = va0 + PGSIZE;
    800016e6:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800016ea:	c8a9                	beqz	s1,8000173c <copyinstr+0xa6>
    va0 = (uint)PGROUNDDOWN(srcva);
    800016ec:	014bf933          	and	s2,s7,s4
    pa0 = walkaddr(pagetable, va0);
    800016f0:	85ca                	mv	a1,s2
    800016f2:	8556                	mv	a0,s5
    800016f4:	00000097          	auipc	ra,0x0
    800016f8:	8b8080e7          	jalr	-1864(ra) # 80000fac <walkaddr>
    if(pa0 == 0)
    800016fc:	c131                	beqz	a0,80001740 <copyinstr+0xaa>
    n = PGSIZE - (srcva - va0);
    800016fe:	41790833          	sub	a6,s2,s7
    80001702:	984e                	add	a6,a6,s3
    if(n > max)
    80001704:	0104f363          	bgeu	s1,a6,8000170a <copyinstr+0x74>
    80001708:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000170a:	955e                	add	a0,a0,s7
    8000170c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001710:	fc080be3          	beqz	a6,800016e6 <copyinstr+0x50>
    80001714:	985a                	add	a6,a6,s6
    80001716:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001718:	41650633          	sub	a2,a0,s6
    8000171c:	14fd                	addi	s1,s1,-1
    8000171e:	9b26                	add	s6,s6,s1
    80001720:	00f60733          	add	a4,a2,a5
    80001724:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd5fbc>
    80001728:	df49                	beqz	a4,800016c2 <copyinstr+0x2c>
        *dst = *p;
    8000172a:	00e78023          	sb	a4,0(a5)
      --max;
    8000172e:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001732:	0785                	addi	a5,a5,1
    while(n > 0){
    80001734:	ff0796e3          	bne	a5,a6,80001720 <copyinstr+0x8a>
      dst++;
    80001738:	8b42                	mv	s6,a6
    8000173a:	b775                	j	800016e6 <copyinstr+0x50>
    8000173c:	4781                	li	a5,0
    8000173e:	b769                	j	800016c8 <copyinstr+0x32>
      return -1;
    80001740:	557d                	li	a0,-1
    80001742:	b779                	j	800016d0 <copyinstr+0x3a>
  int got_null = 0;
    80001744:	4781                	li	a5,0
  if(got_null){
    80001746:	0017b793          	seqz	a5,a5
    8000174a:	40f00533          	neg	a0,a5
}
    8000174e:	8082                	ret

0000000080001750 <procinit>:

extern char trampoline[]; // trampoline.S

void
procinit(void)
{
    80001750:	715d                	addi	sp,sp,-80
    80001752:	e486                	sd	ra,72(sp)
    80001754:	e0a2                	sd	s0,64(sp)
    80001756:	fc26                	sd	s1,56(sp)
    80001758:	f84a                	sd	s2,48(sp)
    8000175a:	f44e                	sd	s3,40(sp)
    8000175c:	f052                	sd	s4,32(sp)
    8000175e:	ec56                	sd	s5,24(sp)
    80001760:	e85a                	sd	s6,16(sp)
    80001762:	e45e                	sd	s7,8(sp)
    80001764:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001766:	00006597          	auipc	a1,0x6
    8000176a:	b6258593          	addi	a1,a1,-1182 # 800072c8 <userret+0x238>
    8000176e:	00010517          	auipc	a0,0x10
    80001772:	17a50513          	addi	a0,a0,378 # 800118e8 <pid_lock>
    80001776:	fffff097          	auipc	ra,0xfffff
    8000177a:	262080e7          	jalr	610(ra) # 800009d8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000177e:	00010917          	auipc	s2,0x10
    80001782:	58290913          	addi	s2,s2,1410 # 80011d00 <proc>
      initlock(&p->lock, "proc");
    80001786:	00006b97          	auipc	s7,0x6
    8000178a:	b4ab8b93          	addi	s7,s7,-1206 # 800072d0 <userret+0x240>
      // Map it high in memory, followed by an invalid
      // guard page.
      char *pa = kalloc();
      if(pa == 0)
        panic("kalloc");
      uint64 va = KSTACK((int) (p - proc));
    8000178e:	8b4a                	mv	s6,s2
    80001790:	00006a97          	auipc	s5,0x6
    80001794:	288a8a93          	addi	s5,s5,648 # 80007a18 <syscalls+0xc0>
    80001798:	040009b7          	lui	s3,0x4000
    8000179c:	19fd                	addi	s3,s3,-1
    8000179e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017a0:	00016a17          	auipc	s4,0x16
    800017a4:	f60a0a13          	addi	s4,s4,-160 # 80017700 <tickslock>
      initlock(&p->lock, "proc");
    800017a8:	85de                	mv	a1,s7
    800017aa:	854a                	mv	a0,s2
    800017ac:	fffff097          	auipc	ra,0xfffff
    800017b0:	22c080e7          	jalr	556(ra) # 800009d8 <initlock>
      char *pa = kalloc();
    800017b4:	fffff097          	auipc	ra,0xfffff
    800017b8:	1c4080e7          	jalr	452(ra) # 80000978 <kalloc>
    800017bc:	85aa                	mv	a1,a0
      if(pa == 0)
    800017be:	c929                	beqz	a0,80001810 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    800017c0:	416904b3          	sub	s1,s2,s6
    800017c4:	848d                	srai	s1,s1,0x3
    800017c6:	000ab783          	ld	a5,0(s5)
    800017ca:	02f484b3          	mul	s1,s1,a5
    800017ce:	2485                	addiw	s1,s1,1
    800017d0:	00d4949b          	slliw	s1,s1,0xd
    800017d4:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017d8:	4699                	li	a3,6
    800017da:	6605                	lui	a2,0x1
    800017dc:	8526                	mv	a0,s1
    800017de:	00000097          	auipc	ra,0x0
    800017e2:	8f0080e7          	jalr	-1808(ra) # 800010ce <kvmmap>
      p->kstack = va;
    800017e6:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ea:	16890913          	addi	s2,s2,360
    800017ee:	fb491de3          	bne	s2,s4,800017a8 <procinit+0x58>
  }
  kvminithart();
    800017f2:	fffff097          	auipc	ra,0xfffff
    800017f6:	796080e7          	jalr	1942(ra) # 80000f88 <kvminithart>
}
    800017fa:	60a6                	ld	ra,72(sp)
    800017fc:	6406                	ld	s0,64(sp)
    800017fe:	74e2                	ld	s1,56(sp)
    80001800:	7942                	ld	s2,48(sp)
    80001802:	79a2                	ld	s3,40(sp)
    80001804:	7a02                	ld	s4,32(sp)
    80001806:	6ae2                	ld	s5,24(sp)
    80001808:	6b42                	ld	s6,16(sp)
    8000180a:	6ba2                	ld	s7,8(sp)
    8000180c:	6161                	addi	sp,sp,80
    8000180e:	8082                	ret
        panic("kalloc");
    80001810:	00006517          	auipc	a0,0x6
    80001814:	ac850513          	addi	a0,a0,-1336 # 800072d8 <userret+0x248>
    80001818:	fffff097          	auipc	ra,0xfffff
    8000181c:	d36080e7          	jalr	-714(ra) # 8000054e <panic>

0000000080001820 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001820:	1141                	addi	sp,sp,-16
    80001822:	e422                	sd	s0,8(sp)
    80001824:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001826:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001828:	2501                	sext.w	a0,a0
    8000182a:	6422                	ld	s0,8(sp)
    8000182c:	0141                	addi	sp,sp,16
    8000182e:	8082                	ret

0000000080001830 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001830:	1141                	addi	sp,sp,-16
    80001832:	e422                	sd	s0,8(sp)
    80001834:	0800                	addi	s0,sp,16
    80001836:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001838:	2781                	sext.w	a5,a5
    8000183a:	079e                	slli	a5,a5,0x7
  return c;
}
    8000183c:	00010517          	auipc	a0,0x10
    80001840:	0c450513          	addi	a0,a0,196 # 80011900 <cpus>
    80001844:	953e                	add	a0,a0,a5
    80001846:	6422                	ld	s0,8(sp)
    80001848:	0141                	addi	sp,sp,16
    8000184a:	8082                	ret

000000008000184c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    8000184c:	1101                	addi	sp,sp,-32
    8000184e:	ec06                	sd	ra,24(sp)
    80001850:	e822                	sd	s0,16(sp)
    80001852:	e426                	sd	s1,8(sp)
    80001854:	1000                	addi	s0,sp,32
  push_off();
    80001856:	fffff097          	auipc	ra,0xfffff
    8000185a:	198080e7          	jalr	408(ra) # 800009ee <push_off>
    8000185e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001860:	2781                	sext.w	a5,a5
    80001862:	079e                	slli	a5,a5,0x7
    80001864:	00010717          	auipc	a4,0x10
    80001868:	08470713          	addi	a4,a4,132 # 800118e8 <pid_lock>
    8000186c:	97ba                	add	a5,a5,a4
    8000186e:	6f84                	ld	s1,24(a5)
  pop_off();
    80001870:	fffff097          	auipc	ra,0xfffff
    80001874:	1ca080e7          	jalr	458(ra) # 80000a3a <pop_off>
  return p;
}
    80001878:	8526                	mv	a0,s1
    8000187a:	60e2                	ld	ra,24(sp)
    8000187c:	6442                	ld	s0,16(sp)
    8000187e:	64a2                	ld	s1,8(sp)
    80001880:	6105                	addi	sp,sp,32
    80001882:	8082                	ret

0000000080001884 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001884:	1141                	addi	sp,sp,-16
    80001886:	e406                	sd	ra,8(sp)
    80001888:	e022                	sd	s0,0(sp)
    8000188a:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000188c:	00000097          	auipc	ra,0x0
    80001890:	fc0080e7          	jalr	-64(ra) # 8000184c <myproc>
    80001894:	fffff097          	auipc	ra,0xfffff
    80001898:	2be080e7          	jalr	702(ra) # 80000b52 <release>

  if (first) {
    8000189c:	00006797          	auipc	a5,0x6
    800018a0:	7987a783          	lw	a5,1944(a5) # 80008034 <first.1743>
    800018a4:	eb89                	bnez	a5,800018b6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(minor(ROOTDEV));
  }

  usertrapret();
    800018a6:	00001097          	auipc	ra,0x1
    800018aa:	c1c080e7          	jalr	-996(ra) # 800024c2 <usertrapret>
}
    800018ae:	60a2                	ld	ra,8(sp)
    800018b0:	6402                	ld	s0,0(sp)
    800018b2:	0141                	addi	sp,sp,16
    800018b4:	8082                	ret
    first = 0;
    800018b6:	00006797          	auipc	a5,0x6
    800018ba:	7607af23          	sw	zero,1918(a5) # 80008034 <first.1743>
    fsinit(minor(ROOTDEV));
    800018be:	4501                	li	a0,0
    800018c0:	00002097          	auipc	ra,0x2
    800018c4:	944080e7          	jalr	-1724(ra) # 80003204 <fsinit>
    800018c8:	bff9                	j	800018a6 <forkret+0x22>

00000000800018ca <allocpid>:
allocpid() {
    800018ca:	1101                	addi	sp,sp,-32
    800018cc:	ec06                	sd	ra,24(sp)
    800018ce:	e822                	sd	s0,16(sp)
    800018d0:	e426                	sd	s1,8(sp)
    800018d2:	e04a                	sd	s2,0(sp)
    800018d4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800018d6:	00010917          	auipc	s2,0x10
    800018da:	01290913          	addi	s2,s2,18 # 800118e8 <pid_lock>
    800018de:	854a                	mv	a0,s2
    800018e0:	fffff097          	auipc	ra,0xfffff
    800018e4:	20a080e7          	jalr	522(ra) # 80000aea <acquire>
  pid = nextpid;
    800018e8:	00006797          	auipc	a5,0x6
    800018ec:	75078793          	addi	a5,a5,1872 # 80008038 <nextpid>
    800018f0:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018f2:	0014871b          	addiw	a4,s1,1
    800018f6:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018f8:	854a                	mv	a0,s2
    800018fa:	fffff097          	auipc	ra,0xfffff
    800018fe:	258080e7          	jalr	600(ra) # 80000b52 <release>
}
    80001902:	8526                	mv	a0,s1
    80001904:	60e2                	ld	ra,24(sp)
    80001906:	6442                	ld	s0,16(sp)
    80001908:	64a2                	ld	s1,8(sp)
    8000190a:	6902                	ld	s2,0(sp)
    8000190c:	6105                	addi	sp,sp,32
    8000190e:	8082                	ret

0000000080001910 <proc_pagetable>:
{
    80001910:	1101                	addi	sp,sp,-32
    80001912:	ec06                	sd	ra,24(sp)
    80001914:	e822                	sd	s0,16(sp)
    80001916:	e426                	sd	s1,8(sp)
    80001918:	e04a                	sd	s2,0(sp)
    8000191a:	1000                	addi	s0,sp,32
    8000191c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000191e:	00000097          	auipc	ra,0x0
    80001922:	996080e7          	jalr	-1642(ra) # 800012b4 <uvmcreate>
    80001926:	84aa                	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001928:	4729                	li	a4,10
    8000192a:	00005697          	auipc	a3,0x5
    8000192e:	6d668693          	addi	a3,a3,1750 # 80007000 <trampoline>
    80001932:	6605                	lui	a2,0x1
    80001934:	040005b7          	lui	a1,0x4000
    80001938:	15fd                	addi	a1,a1,-1
    8000193a:	05b2                	slli	a1,a1,0xc
    8000193c:	fffff097          	auipc	ra,0xfffff
    80001940:	704080e7          	jalr	1796(ra) # 80001040 <mappages>
  mappages(pagetable, TRAPFRAME, PGSIZE,
    80001944:	4719                	li	a4,6
    80001946:	05893683          	ld	a3,88(s2)
    8000194a:	6605                	lui	a2,0x1
    8000194c:	020005b7          	lui	a1,0x2000
    80001950:	15fd                	addi	a1,a1,-1
    80001952:	05b6                	slli	a1,a1,0xd
    80001954:	8526                	mv	a0,s1
    80001956:	fffff097          	auipc	ra,0xfffff
    8000195a:	6ea080e7          	jalr	1770(ra) # 80001040 <mappages>
}
    8000195e:	8526                	mv	a0,s1
    80001960:	60e2                	ld	ra,24(sp)
    80001962:	6442                	ld	s0,16(sp)
    80001964:	64a2                	ld	s1,8(sp)
    80001966:	6902                	ld	s2,0(sp)
    80001968:	6105                	addi	sp,sp,32
    8000196a:	8082                	ret

000000008000196c <allocproc>:
{
    8000196c:	1101                	addi	sp,sp,-32
    8000196e:	ec06                	sd	ra,24(sp)
    80001970:	e822                	sd	s0,16(sp)
    80001972:	e426                	sd	s1,8(sp)
    80001974:	e04a                	sd	s2,0(sp)
    80001976:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001978:	00010497          	auipc	s1,0x10
    8000197c:	38848493          	addi	s1,s1,904 # 80011d00 <proc>
    80001980:	00016917          	auipc	s2,0x16
    80001984:	d8090913          	addi	s2,s2,-640 # 80017700 <tickslock>
    acquire(&p->lock);
    80001988:	8526                	mv	a0,s1
    8000198a:	fffff097          	auipc	ra,0xfffff
    8000198e:	160080e7          	jalr	352(ra) # 80000aea <acquire>
    if(p->state == UNUSED) {
    80001992:	4c9c                	lw	a5,24(s1)
    80001994:	cf81                	beqz	a5,800019ac <allocproc+0x40>
      release(&p->lock);
    80001996:	8526                	mv	a0,s1
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	1ba080e7          	jalr	442(ra) # 80000b52 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019a0:	16848493          	addi	s1,s1,360
    800019a4:	ff2492e3          	bne	s1,s2,80001988 <allocproc+0x1c>
  return 0;
    800019a8:	4481                	li	s1,0
    800019aa:	a0a9                	j	800019f4 <allocproc+0x88>
  p->pid = allocpid();
    800019ac:	00000097          	auipc	ra,0x0
    800019b0:	f1e080e7          	jalr	-226(ra) # 800018ca <allocpid>
    800019b4:	dc88                	sw	a0,56(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    800019b6:	fffff097          	auipc	ra,0xfffff
    800019ba:	fc2080e7          	jalr	-62(ra) # 80000978 <kalloc>
    800019be:	892a                	mv	s2,a0
    800019c0:	eca8                	sd	a0,88(s1)
    800019c2:	c121                	beqz	a0,80001a02 <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    800019c4:	8526                	mv	a0,s1
    800019c6:	00000097          	auipc	ra,0x0
    800019ca:	f4a080e7          	jalr	-182(ra) # 80001910 <proc_pagetable>
    800019ce:	e8a8                	sd	a0,80(s1)
  memset(&p->context, 0, sizeof p->context);
    800019d0:	07000613          	li	a2,112
    800019d4:	4581                	li	a1,0
    800019d6:	06048513          	addi	a0,s1,96
    800019da:	fffff097          	auipc	ra,0xfffff
    800019de:	1d4080e7          	jalr	468(ra) # 80000bae <memset>
  p->context.ra = (uint64)forkret;
    800019e2:	00000797          	auipc	a5,0x0
    800019e6:	ea278793          	addi	a5,a5,-350 # 80001884 <forkret>
    800019ea:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800019ec:	60bc                	ld	a5,64(s1)
    800019ee:	6705                	lui	a4,0x1
    800019f0:	97ba                	add	a5,a5,a4
    800019f2:	f4bc                	sd	a5,104(s1)
}
    800019f4:	8526                	mv	a0,s1
    800019f6:	60e2                	ld	ra,24(sp)
    800019f8:	6442                	ld	s0,16(sp)
    800019fa:	64a2                	ld	s1,8(sp)
    800019fc:	6902                	ld	s2,0(sp)
    800019fe:	6105                	addi	sp,sp,32
    80001a00:	8082                	ret
    release(&p->lock);
    80001a02:	8526                	mv	a0,s1
    80001a04:	fffff097          	auipc	ra,0xfffff
    80001a08:	14e080e7          	jalr	334(ra) # 80000b52 <release>
    return 0;
    80001a0c:	84ca                	mv	s1,s2
    80001a0e:	b7dd                	j	800019f4 <allocproc+0x88>

0000000080001a10 <proc_freepagetable>:
{
    80001a10:	1101                	addi	sp,sp,-32
    80001a12:	ec06                	sd	ra,24(sp)
    80001a14:	e822                	sd	s0,16(sp)
    80001a16:	e426                	sd	s1,8(sp)
    80001a18:	e04a                	sd	s2,0(sp)
    80001a1a:	1000                	addi	s0,sp,32
    80001a1c:	84aa                	mv	s1,a0
    80001a1e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    80001a20:	4681                	li	a3,0
    80001a22:	6605                	lui	a2,0x1
    80001a24:	040005b7          	lui	a1,0x4000
    80001a28:	15fd                	addi	a1,a1,-1
    80001a2a:	05b2                	slli	a1,a1,0xc
    80001a2c:	fffff097          	auipc	ra,0xfffff
    80001a30:	7c0080e7          	jalr	1984(ra) # 800011ec <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, PGSIZE, 0);
    80001a34:	4681                	li	a3,0
    80001a36:	6605                	lui	a2,0x1
    80001a38:	020005b7          	lui	a1,0x2000
    80001a3c:	15fd                	addi	a1,a1,-1
    80001a3e:	05b6                	slli	a1,a1,0xd
    80001a40:	8526                	mv	a0,s1
    80001a42:	fffff097          	auipc	ra,0xfffff
    80001a46:	7aa080e7          	jalr	1962(ra) # 800011ec <uvmunmap>
  if(sz > 0)
    80001a4a:	00091863          	bnez	s2,80001a5a <proc_freepagetable+0x4a>
}
    80001a4e:	60e2                	ld	ra,24(sp)
    80001a50:	6442                	ld	s0,16(sp)
    80001a52:	64a2                	ld	s1,8(sp)
    80001a54:	6902                	ld	s2,0(sp)
    80001a56:	6105                	addi	sp,sp,32
    80001a58:	8082                	ret
    uvmfree(pagetable, sz);
    80001a5a:	85ca                	mv	a1,s2
    80001a5c:	8526                	mv	a0,s1
    80001a5e:	00000097          	auipc	ra,0x0
    80001a62:	9e4080e7          	jalr	-1564(ra) # 80001442 <uvmfree>
}
    80001a66:	b7e5                	j	80001a4e <proc_freepagetable+0x3e>

0000000080001a68 <freeproc>:
{
    80001a68:	1101                	addi	sp,sp,-32
    80001a6a:	ec06                	sd	ra,24(sp)
    80001a6c:	e822                	sd	s0,16(sp)
    80001a6e:	e426                	sd	s1,8(sp)
    80001a70:	1000                	addi	s0,sp,32
    80001a72:	84aa                	mv	s1,a0
  if(p->tf)
    80001a74:	6d28                	ld	a0,88(a0)
    80001a76:	c509                	beqz	a0,80001a80 <freeproc+0x18>
    kfree((void*)p->tf);
    80001a78:	fffff097          	auipc	ra,0xfffff
    80001a7c:	dec080e7          	jalr	-532(ra) # 80000864 <kfree>
  p->tf = 0;
    80001a80:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a84:	68a8                	ld	a0,80(s1)
    80001a86:	c511                	beqz	a0,80001a92 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001a88:	64ac                	ld	a1,72(s1)
    80001a8a:	00000097          	auipc	ra,0x0
    80001a8e:	f86080e7          	jalr	-122(ra) # 80001a10 <proc_freepagetable>
  p->pagetable = 0;
    80001a92:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001a96:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001a9a:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001a9e:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001aa2:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001aa6:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001aaa:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001aae:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001ab2:	0004ac23          	sw	zero,24(s1)
}
    80001ab6:	60e2                	ld	ra,24(sp)
    80001ab8:	6442                	ld	s0,16(sp)
    80001aba:	64a2                	ld	s1,8(sp)
    80001abc:	6105                	addi	sp,sp,32
    80001abe:	8082                	ret

0000000080001ac0 <userinit>:
{
    80001ac0:	1101                	addi	sp,sp,-32
    80001ac2:	ec06                	sd	ra,24(sp)
    80001ac4:	e822                	sd	s0,16(sp)
    80001ac6:	e426                	sd	s1,8(sp)
    80001ac8:	1000                	addi	s0,sp,32
  p = allocproc();
    80001aca:	00000097          	auipc	ra,0x0
    80001ace:	ea2080e7          	jalr	-350(ra) # 8000196c <allocproc>
    80001ad2:	84aa                	mv	s1,a0
  initproc = p;
    80001ad4:	00027797          	auipc	a5,0x27
    80001ad8:	56a7b223          	sd	a0,1380(a5) # 80029038 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001adc:	03300613          	li	a2,51
    80001ae0:	00006597          	auipc	a1,0x6
    80001ae4:	52058593          	addi	a1,a1,1312 # 80008000 <initcode>
    80001ae8:	6928                	ld	a0,80(a0)
    80001aea:	00000097          	auipc	ra,0x0
    80001aee:	808080e7          	jalr	-2040(ra) # 800012f2 <uvminit>
  p->sz = PGSIZE;
    80001af2:	6785                	lui	a5,0x1
    80001af4:	e4bc                	sd	a5,72(s1)
  p->tf->epc = 0;      // user program counter
    80001af6:	6cb8                	ld	a4,88(s1)
    80001af8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->tf->sp = PGSIZE;  // user stack pointer
    80001afc:	6cb8                	ld	a4,88(s1)
    80001afe:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001b00:	4641                	li	a2,16
    80001b02:	00005597          	auipc	a1,0x5
    80001b06:	7de58593          	addi	a1,a1,2014 # 800072e0 <userret+0x250>
    80001b0a:	15848513          	addi	a0,s1,344
    80001b0e:	fffff097          	auipc	ra,0xfffff
    80001b12:	1f6080e7          	jalr	502(ra) # 80000d04 <safestrcpy>
  p->cwd = namei("/");
    80001b16:	00005517          	auipc	a0,0x5
    80001b1a:	7da50513          	addi	a0,a0,2010 # 800072f0 <userret+0x260>
    80001b1e:	00002097          	auipc	ra,0x2
    80001b22:	0ea080e7          	jalr	234(ra) # 80003c08 <namei>
    80001b26:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001b2a:	4789                	li	a5,2
    80001b2c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001b2e:	8526                	mv	a0,s1
    80001b30:	fffff097          	auipc	ra,0xfffff
    80001b34:	022080e7          	jalr	34(ra) # 80000b52 <release>
}
    80001b38:	60e2                	ld	ra,24(sp)
    80001b3a:	6442                	ld	s0,16(sp)
    80001b3c:	64a2                	ld	s1,8(sp)
    80001b3e:	6105                	addi	sp,sp,32
    80001b40:	8082                	ret

0000000080001b42 <growproc>:
{
    80001b42:	1101                	addi	sp,sp,-32
    80001b44:	ec06                	sd	ra,24(sp)
    80001b46:	e822                	sd	s0,16(sp)
    80001b48:	e426                	sd	s1,8(sp)
    80001b4a:	e04a                	sd	s2,0(sp)
    80001b4c:	1000                	addi	s0,sp,32
    80001b4e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b50:	00000097          	auipc	ra,0x0
    80001b54:	cfc080e7          	jalr	-772(ra) # 8000184c <myproc>
    80001b58:	892a                	mv	s2,a0
  sz = p->sz;
    80001b5a:	652c                	ld	a1,72(a0)
    80001b5c:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001b60:	00904f63          	bgtz	s1,80001b7e <growproc+0x3c>
  } else if(n < 0){
    80001b64:	0204cc63          	bltz	s1,80001b9c <growproc+0x5a>
  p->sz = sz;
    80001b68:	1602                	slli	a2,a2,0x20
    80001b6a:	9201                	srli	a2,a2,0x20
    80001b6c:	04c93423          	sd	a2,72(s2)
  return 0;
    80001b70:	4501                	li	a0,0
}
    80001b72:	60e2                	ld	ra,24(sp)
    80001b74:	6442                	ld	s0,16(sp)
    80001b76:	64a2                	ld	s1,8(sp)
    80001b78:	6902                	ld	s2,0(sp)
    80001b7a:	6105                	addi	sp,sp,32
    80001b7c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001b7e:	9e25                	addw	a2,a2,s1
    80001b80:	1602                	slli	a2,a2,0x20
    80001b82:	9201                	srli	a2,a2,0x20
    80001b84:	1582                	slli	a1,a1,0x20
    80001b86:	9181                	srli	a1,a1,0x20
    80001b88:	6928                	ld	a0,80(a0)
    80001b8a:	00000097          	auipc	ra,0x0
    80001b8e:	80e080e7          	jalr	-2034(ra) # 80001398 <uvmalloc>
    80001b92:	0005061b          	sext.w	a2,a0
    80001b96:	fa69                	bnez	a2,80001b68 <growproc+0x26>
      return -1;
    80001b98:	557d                	li	a0,-1
    80001b9a:	bfe1                	j	80001b72 <growproc+0x30>
    if((sz = uvmdealloc(p->pagetable, sz, sz + n)) == 0) {
    80001b9c:	9e25                	addw	a2,a2,s1
    80001b9e:	1602                	slli	a2,a2,0x20
    80001ba0:	9201                	srli	a2,a2,0x20
    80001ba2:	1582                	slli	a1,a1,0x20
    80001ba4:	9181                	srli	a1,a1,0x20
    80001ba6:	6928                	ld	a0,80(a0)
    80001ba8:	fffff097          	auipc	ra,0xfffff
    80001bac:	7bc080e7          	jalr	1980(ra) # 80001364 <uvmdealloc>
    80001bb0:	0005061b          	sext.w	a2,a0
    80001bb4:	fa55                	bnez	a2,80001b68 <growproc+0x26>
      return -1;
    80001bb6:	557d                	li	a0,-1
    80001bb8:	bf6d                	j	80001b72 <growproc+0x30>

0000000080001bba <fork>:
{
    80001bba:	7179                	addi	sp,sp,-48
    80001bbc:	f406                	sd	ra,40(sp)
    80001bbe:	f022                	sd	s0,32(sp)
    80001bc0:	ec26                	sd	s1,24(sp)
    80001bc2:	e84a                	sd	s2,16(sp)
    80001bc4:	e44e                	sd	s3,8(sp)
    80001bc6:	e052                	sd	s4,0(sp)
    80001bc8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001bca:	00000097          	auipc	ra,0x0
    80001bce:	c82080e7          	jalr	-894(ra) # 8000184c <myproc>
    80001bd2:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001bd4:	00000097          	auipc	ra,0x0
    80001bd8:	d98080e7          	jalr	-616(ra) # 8000196c <allocproc>
    80001bdc:	c175                	beqz	a0,80001cc0 <fork+0x106>
    80001bde:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001be0:	04893603          	ld	a2,72(s2)
    80001be4:	692c                	ld	a1,80(a0)
    80001be6:	05093503          	ld	a0,80(s2)
    80001bea:	00000097          	auipc	ra,0x0
    80001bee:	886080e7          	jalr	-1914(ra) # 80001470 <uvmcopy>
    80001bf2:	04054863          	bltz	a0,80001c42 <fork+0x88>
  np->sz = p->sz;
    80001bf6:	04893783          	ld	a5,72(s2)
    80001bfa:	04f9b423          	sd	a5,72(s3) # 4000048 <_entry-0x7bffffb8>
  np->parent = p;
    80001bfe:	0329b023          	sd	s2,32(s3)
  *(np->tf) = *(p->tf);
    80001c02:	05893683          	ld	a3,88(s2)
    80001c06:	87b6                	mv	a5,a3
    80001c08:	0589b703          	ld	a4,88(s3)
    80001c0c:	12068693          	addi	a3,a3,288
    80001c10:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c14:	6788                	ld	a0,8(a5)
    80001c16:	6b8c                	ld	a1,16(a5)
    80001c18:	6f90                	ld	a2,24(a5)
    80001c1a:	01073023          	sd	a6,0(a4)
    80001c1e:	e708                	sd	a0,8(a4)
    80001c20:	eb0c                	sd	a1,16(a4)
    80001c22:	ef10                	sd	a2,24(a4)
    80001c24:	02078793          	addi	a5,a5,32
    80001c28:	02070713          	addi	a4,a4,32
    80001c2c:	fed792e3          	bne	a5,a3,80001c10 <fork+0x56>
  np->tf->a0 = 0;
    80001c30:	0589b783          	ld	a5,88(s3)
    80001c34:	0607b823          	sd	zero,112(a5)
    80001c38:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001c3c:	15000a13          	li	s4,336
    80001c40:	a03d                	j	80001c6e <fork+0xb4>
    freeproc(np);
    80001c42:	854e                	mv	a0,s3
    80001c44:	00000097          	auipc	ra,0x0
    80001c48:	e24080e7          	jalr	-476(ra) # 80001a68 <freeproc>
    release(&np->lock);
    80001c4c:	854e                	mv	a0,s3
    80001c4e:	fffff097          	auipc	ra,0xfffff
    80001c52:	f04080e7          	jalr	-252(ra) # 80000b52 <release>
    return -1;
    80001c56:	54fd                	li	s1,-1
    80001c58:	a899                	j	80001cae <fork+0xf4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001c5a:	00003097          	auipc	ra,0x3
    80001c5e:	8a0080e7          	jalr	-1888(ra) # 800044fa <filedup>
    80001c62:	009987b3          	add	a5,s3,s1
    80001c66:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001c68:	04a1                	addi	s1,s1,8
    80001c6a:	01448763          	beq	s1,s4,80001c78 <fork+0xbe>
    if(p->ofile[i])
    80001c6e:	009907b3          	add	a5,s2,s1
    80001c72:	6388                	ld	a0,0(a5)
    80001c74:	f17d                	bnez	a0,80001c5a <fork+0xa0>
    80001c76:	bfcd                	j	80001c68 <fork+0xae>
  np->cwd = idup(p->cwd);
    80001c78:	15093503          	ld	a0,336(s2)
    80001c7c:	00001097          	auipc	ra,0x1
    80001c80:	7c2080e7          	jalr	1986(ra) # 8000343e <idup>
    80001c84:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c88:	4641                	li	a2,16
    80001c8a:	15890593          	addi	a1,s2,344
    80001c8e:	15898513          	addi	a0,s3,344
    80001c92:	fffff097          	auipc	ra,0xfffff
    80001c96:	072080e7          	jalr	114(ra) # 80000d04 <safestrcpy>
  pid = np->pid;
    80001c9a:	0389a483          	lw	s1,56(s3)
  np->state = RUNNABLE;
    80001c9e:	4789                	li	a5,2
    80001ca0:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001ca4:	854e                	mv	a0,s3
    80001ca6:	fffff097          	auipc	ra,0xfffff
    80001caa:	eac080e7          	jalr	-340(ra) # 80000b52 <release>
}
    80001cae:	8526                	mv	a0,s1
    80001cb0:	70a2                	ld	ra,40(sp)
    80001cb2:	7402                	ld	s0,32(sp)
    80001cb4:	64e2                	ld	s1,24(sp)
    80001cb6:	6942                	ld	s2,16(sp)
    80001cb8:	69a2                	ld	s3,8(sp)
    80001cba:	6a02                	ld	s4,0(sp)
    80001cbc:	6145                	addi	sp,sp,48
    80001cbe:	8082                	ret
    return -1;
    80001cc0:	54fd                	li	s1,-1
    80001cc2:	b7f5                	j	80001cae <fork+0xf4>

0000000080001cc4 <reparent>:
reparent(struct proc *p, struct proc *parent) {
    80001cc4:	711d                	addi	sp,sp,-96
    80001cc6:	ec86                	sd	ra,88(sp)
    80001cc8:	e8a2                	sd	s0,80(sp)
    80001cca:	e4a6                	sd	s1,72(sp)
    80001ccc:	e0ca                	sd	s2,64(sp)
    80001cce:	fc4e                	sd	s3,56(sp)
    80001cd0:	f852                	sd	s4,48(sp)
    80001cd2:	f456                	sd	s5,40(sp)
    80001cd4:	f05a                	sd	s6,32(sp)
    80001cd6:	ec5e                	sd	s7,24(sp)
    80001cd8:	e862                	sd	s8,16(sp)
    80001cda:	e466                	sd	s9,8(sp)
    80001cdc:	1080                	addi	s0,sp,96
    80001cde:	892a                	mv	s2,a0
  int child_of_init = (p->parent == initproc);
    80001ce0:	02053b83          	ld	s7,32(a0)
    80001ce4:	00027b17          	auipc	s6,0x27
    80001ce8:	354b3b03          	ld	s6,852(s6) # 80029038 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001cec:	00010497          	auipc	s1,0x10
    80001cf0:	01448493          	addi	s1,s1,20 # 80011d00 <proc>
      pp->parent = initproc;
    80001cf4:	00027a17          	auipc	s4,0x27
    80001cf8:	344a0a13          	addi	s4,s4,836 # 80029038 <initproc>
      if(pp->state == ZOMBIE) {
    80001cfc:	4a91                	li	s5,4
// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
  if(p->chan == p && p->state == SLEEPING) {
    80001cfe:	4c05                	li	s8,1
    p->state = RUNNABLE;
    80001d00:	4c89                	li	s9,2
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001d02:	00016997          	auipc	s3,0x16
    80001d06:	9fe98993          	addi	s3,s3,-1538 # 80017700 <tickslock>
    80001d0a:	a805                	j	80001d3a <reparent+0x76>
  if(p->chan == p && p->state == SLEEPING) {
    80001d0c:	751c                	ld	a5,40(a0)
    80001d0e:	00f51d63          	bne	a0,a5,80001d28 <reparent+0x64>
    80001d12:	4d1c                	lw	a5,24(a0)
    80001d14:	01879a63          	bne	a5,s8,80001d28 <reparent+0x64>
    p->state = RUNNABLE;
    80001d18:	01952c23          	sw	s9,24(a0)
        if(!child_of_init)
    80001d1c:	016b8663          	beq	s7,s6,80001d28 <reparent+0x64>
          release(&initproc->lock);
    80001d20:	fffff097          	auipc	ra,0xfffff
    80001d24:	e32080e7          	jalr	-462(ra) # 80000b52 <release>
      release(&pp->lock);
    80001d28:	8526                	mv	a0,s1
    80001d2a:	fffff097          	auipc	ra,0xfffff
    80001d2e:	e28080e7          	jalr	-472(ra) # 80000b52 <release>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001d32:	16848493          	addi	s1,s1,360
    80001d36:	03348f63          	beq	s1,s3,80001d74 <reparent+0xb0>
    if(pp->parent == p){
    80001d3a:	709c                	ld	a5,32(s1)
    80001d3c:	ff279be3          	bne	a5,s2,80001d32 <reparent+0x6e>
      acquire(&pp->lock);
    80001d40:	8526                	mv	a0,s1
    80001d42:	fffff097          	auipc	ra,0xfffff
    80001d46:	da8080e7          	jalr	-600(ra) # 80000aea <acquire>
      pp->parent = initproc;
    80001d4a:	000a3503          	ld	a0,0(s4)
    80001d4e:	f088                	sd	a0,32(s1)
      if(pp->state == ZOMBIE) {
    80001d50:	4c9c                	lw	a5,24(s1)
    80001d52:	fd579be3          	bne	a5,s5,80001d28 <reparent+0x64>
        if(!child_of_init)
    80001d56:	fb6b8be3          	beq	s7,s6,80001d0c <reparent+0x48>
          acquire(&initproc->lock);
    80001d5a:	fffff097          	auipc	ra,0xfffff
    80001d5e:	d90080e7          	jalr	-624(ra) # 80000aea <acquire>
        wakeup1(initproc);
    80001d62:	000a3503          	ld	a0,0(s4)
  if(p->chan == p && p->state == SLEEPING) {
    80001d66:	751c                	ld	a5,40(a0)
    80001d68:	faa79ce3          	bne	a5,a0,80001d20 <reparent+0x5c>
    80001d6c:	4d1c                	lw	a5,24(a0)
    80001d6e:	fb8799e3          	bne	a5,s8,80001d20 <reparent+0x5c>
    80001d72:	b75d                	j	80001d18 <reparent+0x54>
}
    80001d74:	60e6                	ld	ra,88(sp)
    80001d76:	6446                	ld	s0,80(sp)
    80001d78:	64a6                	ld	s1,72(sp)
    80001d7a:	6906                	ld	s2,64(sp)
    80001d7c:	79e2                	ld	s3,56(sp)
    80001d7e:	7a42                	ld	s4,48(sp)
    80001d80:	7aa2                	ld	s5,40(sp)
    80001d82:	7b02                	ld	s6,32(sp)
    80001d84:	6be2                	ld	s7,24(sp)
    80001d86:	6c42                	ld	s8,16(sp)
    80001d88:	6ca2                	ld	s9,8(sp)
    80001d8a:	6125                	addi	sp,sp,96
    80001d8c:	8082                	ret

0000000080001d8e <scheduler>:
{
    80001d8e:	715d                	addi	sp,sp,-80
    80001d90:	e486                	sd	ra,72(sp)
    80001d92:	e0a2                	sd	s0,64(sp)
    80001d94:	fc26                	sd	s1,56(sp)
    80001d96:	f84a                	sd	s2,48(sp)
    80001d98:	f44e                	sd	s3,40(sp)
    80001d9a:	f052                	sd	s4,32(sp)
    80001d9c:	ec56                	sd	s5,24(sp)
    80001d9e:	e85a                	sd	s6,16(sp)
    80001da0:	e45e                	sd	s7,8(sp)
    80001da2:	e062                	sd	s8,0(sp)
    80001da4:	0880                	addi	s0,sp,80
    80001da6:	8792                	mv	a5,tp
  int id = r_tp();
    80001da8:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001daa:	00779b13          	slli	s6,a5,0x7
    80001dae:	00010717          	auipc	a4,0x10
    80001db2:	b3a70713          	addi	a4,a4,-1222 # 800118e8 <pid_lock>
    80001db6:	975a                	add	a4,a4,s6
    80001db8:	00073c23          	sd	zero,24(a4)
        swtch(&c->scheduler, &p->context);
    80001dbc:	00010717          	auipc	a4,0x10
    80001dc0:	b4c70713          	addi	a4,a4,-1204 # 80011908 <cpus+0x8>
    80001dc4:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001dc6:	4c0d                	li	s8,3
        c->proc = p;
    80001dc8:	079e                	slli	a5,a5,0x7
    80001dca:	00010a17          	auipc	s4,0x10
    80001dce:	b1ea0a13          	addi	s4,s4,-1250 # 800118e8 <pid_lock>
    80001dd2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dd4:	00016997          	auipc	s3,0x16
    80001dd8:	92c98993          	addi	s3,s3,-1748 # 80017700 <tickslock>
        found = 1;
    80001ddc:	4b85                	li	s7,1
    80001dde:	a08d                	j	80001e40 <scheduler+0xb2>
        p->state = RUNNING;
    80001de0:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001de4:	009a3c23          	sd	s1,24(s4)
        swtch(&c->scheduler, &p->context);
    80001de8:	06048593          	addi	a1,s1,96
    80001dec:	855a                	mv	a0,s6
    80001dee:	00000097          	auipc	ra,0x0
    80001df2:	62a080e7          	jalr	1578(ra) # 80002418 <swtch>
        c->proc = 0;
    80001df6:	000a3c23          	sd	zero,24(s4)
        found = 1;
    80001dfa:	8ade                	mv	s5,s7
      release(&p->lock);
    80001dfc:	8526                	mv	a0,s1
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	d54080e7          	jalr	-684(ra) # 80000b52 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e06:	16848493          	addi	s1,s1,360
    80001e0a:	01348b63          	beq	s1,s3,80001e20 <scheduler+0x92>
      acquire(&p->lock);
    80001e0e:	8526                	mv	a0,s1
    80001e10:	fffff097          	auipc	ra,0xfffff
    80001e14:	cda080e7          	jalr	-806(ra) # 80000aea <acquire>
      if(p->state == RUNNABLE) {
    80001e18:	4c9c                	lw	a5,24(s1)
    80001e1a:	ff2791e3          	bne	a5,s2,80001dfc <scheduler+0x6e>
    80001e1e:	b7c9                	j	80001de0 <scheduler+0x52>
    if(found == 0){
    80001e20:	020a9063          	bnez	s5,80001e40 <scheduler+0xb2>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80001e24:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80001e28:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80001e2c:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e30:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e34:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e38:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001e3c:	10500073          	wfi
  asm volatile("csrr %0, sie" : "=r" (x) );
    80001e40:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80001e44:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80001e48:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e4c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e50:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e54:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001e58:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e5a:	00010497          	auipc	s1,0x10
    80001e5e:	ea648493          	addi	s1,s1,-346 # 80011d00 <proc>
      if(p->state == RUNNABLE) {
    80001e62:	4909                	li	s2,2
    80001e64:	b76d                	j	80001e0e <scheduler+0x80>

0000000080001e66 <sched>:
{
    80001e66:	7179                	addi	sp,sp,-48
    80001e68:	f406                	sd	ra,40(sp)
    80001e6a:	f022                	sd	s0,32(sp)
    80001e6c:	ec26                	sd	s1,24(sp)
    80001e6e:	e84a                	sd	s2,16(sp)
    80001e70:	e44e                	sd	s3,8(sp)
    80001e72:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e74:	00000097          	auipc	ra,0x0
    80001e78:	9d8080e7          	jalr	-1576(ra) # 8000184c <myproc>
    80001e7c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	c2c080e7          	jalr	-980(ra) # 80000aaa <holding>
    80001e86:	c93d                	beqz	a0,80001efc <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e88:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001e8a:	2781                	sext.w	a5,a5
    80001e8c:	079e                	slli	a5,a5,0x7
    80001e8e:	00010717          	auipc	a4,0x10
    80001e92:	a5a70713          	addi	a4,a4,-1446 # 800118e8 <pid_lock>
    80001e96:	97ba                	add	a5,a5,a4
    80001e98:	0907a703          	lw	a4,144(a5)
    80001e9c:	4785                	li	a5,1
    80001e9e:	06f71763          	bne	a4,a5,80001f0c <sched+0xa6>
  if(p->state == RUNNING)
    80001ea2:	4c98                	lw	a4,24(s1)
    80001ea4:	478d                	li	a5,3
    80001ea6:	06f70b63          	beq	a4,a5,80001f1c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eaa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001eae:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001eb0:	efb5                	bnez	a5,80001f2c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001eb2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001eb4:	00010917          	auipc	s2,0x10
    80001eb8:	a3490913          	addi	s2,s2,-1484 # 800118e8 <pid_lock>
    80001ebc:	2781                	sext.w	a5,a5
    80001ebe:	079e                	slli	a5,a5,0x7
    80001ec0:	97ca                	add	a5,a5,s2
    80001ec2:	0947a983          	lw	s3,148(a5)
    80001ec6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->scheduler);
    80001ec8:	2781                	sext.w	a5,a5
    80001eca:	079e                	slli	a5,a5,0x7
    80001ecc:	00010597          	auipc	a1,0x10
    80001ed0:	a3c58593          	addi	a1,a1,-1476 # 80011908 <cpus+0x8>
    80001ed4:	95be                	add	a1,a1,a5
    80001ed6:	06048513          	addi	a0,s1,96
    80001eda:	00000097          	auipc	ra,0x0
    80001ede:	53e080e7          	jalr	1342(ra) # 80002418 <swtch>
    80001ee2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001ee4:	2781                	sext.w	a5,a5
    80001ee6:	079e                	slli	a5,a5,0x7
    80001ee8:	97ca                	add	a5,a5,s2
    80001eea:	0937aa23          	sw	s3,148(a5)
}
    80001eee:	70a2                	ld	ra,40(sp)
    80001ef0:	7402                	ld	s0,32(sp)
    80001ef2:	64e2                	ld	s1,24(sp)
    80001ef4:	6942                	ld	s2,16(sp)
    80001ef6:	69a2                	ld	s3,8(sp)
    80001ef8:	6145                	addi	sp,sp,48
    80001efa:	8082                	ret
    panic("sched p->lock");
    80001efc:	00005517          	auipc	a0,0x5
    80001f00:	3fc50513          	addi	a0,a0,1020 # 800072f8 <userret+0x268>
    80001f04:	ffffe097          	auipc	ra,0xffffe
    80001f08:	64a080e7          	jalr	1610(ra) # 8000054e <panic>
    panic("sched locks");
    80001f0c:	00005517          	auipc	a0,0x5
    80001f10:	3fc50513          	addi	a0,a0,1020 # 80007308 <userret+0x278>
    80001f14:	ffffe097          	auipc	ra,0xffffe
    80001f18:	63a080e7          	jalr	1594(ra) # 8000054e <panic>
    panic("sched running");
    80001f1c:	00005517          	auipc	a0,0x5
    80001f20:	3fc50513          	addi	a0,a0,1020 # 80007318 <userret+0x288>
    80001f24:	ffffe097          	auipc	ra,0xffffe
    80001f28:	62a080e7          	jalr	1578(ra) # 8000054e <panic>
    panic("sched interruptible");
    80001f2c:	00005517          	auipc	a0,0x5
    80001f30:	3fc50513          	addi	a0,a0,1020 # 80007328 <userret+0x298>
    80001f34:	ffffe097          	auipc	ra,0xffffe
    80001f38:	61a080e7          	jalr	1562(ra) # 8000054e <panic>

0000000080001f3c <exit>:
{
    80001f3c:	7179                	addi	sp,sp,-48
    80001f3e:	f406                	sd	ra,40(sp)
    80001f40:	f022                	sd	s0,32(sp)
    80001f42:	ec26                	sd	s1,24(sp)
    80001f44:	e84a                	sd	s2,16(sp)
    80001f46:	e44e                	sd	s3,8(sp)
    80001f48:	e052                	sd	s4,0(sp)
    80001f4a:	1800                	addi	s0,sp,48
    80001f4c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001f4e:	00000097          	auipc	ra,0x0
    80001f52:	8fe080e7          	jalr	-1794(ra) # 8000184c <myproc>
    80001f56:	89aa                	mv	s3,a0
  if(p == initproc)
    80001f58:	00027797          	auipc	a5,0x27
    80001f5c:	0e07b783          	ld	a5,224(a5) # 80029038 <initproc>
    80001f60:	0d050493          	addi	s1,a0,208
    80001f64:	15050913          	addi	s2,a0,336
    80001f68:	02a79363          	bne	a5,a0,80001f8e <exit+0x52>
    panic("init exiting");
    80001f6c:	00005517          	auipc	a0,0x5
    80001f70:	3d450513          	addi	a0,a0,980 # 80007340 <userret+0x2b0>
    80001f74:	ffffe097          	auipc	ra,0xffffe
    80001f78:	5da080e7          	jalr	1498(ra) # 8000054e <panic>
      fileclose(f);
    80001f7c:	00002097          	auipc	ra,0x2
    80001f80:	5d0080e7          	jalr	1488(ra) # 8000454c <fileclose>
      p->ofile[fd] = 0;
    80001f84:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001f88:	04a1                	addi	s1,s1,8
    80001f8a:	01248563          	beq	s1,s2,80001f94 <exit+0x58>
    if(p->ofile[fd]){
    80001f8e:	6088                	ld	a0,0(s1)
    80001f90:	f575                	bnez	a0,80001f7c <exit+0x40>
    80001f92:	bfdd                	j	80001f88 <exit+0x4c>
  begin_op(ROOTDEV);
    80001f94:	4501                	li	a0,0
    80001f96:	00002097          	auipc	ra,0x2
    80001f9a:	f8e080e7          	jalr	-114(ra) # 80003f24 <begin_op>
  iput(p->cwd);
    80001f9e:	1509b503          	ld	a0,336(s3)
    80001fa2:	00001097          	auipc	ra,0x1
    80001fa6:	5e8080e7          	jalr	1512(ra) # 8000358a <iput>
  end_op(ROOTDEV);
    80001faa:	4501                	li	a0,0
    80001fac:	00002097          	auipc	ra,0x2
    80001fb0:	022080e7          	jalr	34(ra) # 80003fce <end_op>
  p->cwd = 0;
    80001fb4:	1409b823          	sd	zero,336(s3)
  acquire(&p->parent->lock);
    80001fb8:	0209b503          	ld	a0,32(s3)
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	b2e080e7          	jalr	-1234(ra) # 80000aea <acquire>
  acquire(&p->lock);
    80001fc4:	854e                	mv	a0,s3
    80001fc6:	fffff097          	auipc	ra,0xfffff
    80001fca:	b24080e7          	jalr	-1244(ra) # 80000aea <acquire>
  reparent(p, p->parent);
    80001fce:	0209b583          	ld	a1,32(s3)
    80001fd2:	854e                	mv	a0,s3
    80001fd4:	00000097          	auipc	ra,0x0
    80001fd8:	cf0080e7          	jalr	-784(ra) # 80001cc4 <reparent>
  wakeup1(p->parent);
    80001fdc:	0209b783          	ld	a5,32(s3)
  if(p->chan == p && p->state == SLEEPING) {
    80001fe0:	7798                	ld	a4,40(a5)
    80001fe2:	02e78963          	beq	a5,a4,80002014 <exit+0xd8>
  p->xstate = status;
    80001fe6:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001fea:	4791                	li	a5,4
    80001fec:	00f9ac23          	sw	a5,24(s3)
  release(&p->parent->lock);
    80001ff0:	0209b503          	ld	a0,32(s3)
    80001ff4:	fffff097          	auipc	ra,0xfffff
    80001ff8:	b5e080e7          	jalr	-1186(ra) # 80000b52 <release>
  sched();
    80001ffc:	00000097          	auipc	ra,0x0
    80002000:	e6a080e7          	jalr	-406(ra) # 80001e66 <sched>
  panic("zombie exit");
    80002004:	00005517          	auipc	a0,0x5
    80002008:	34c50513          	addi	a0,a0,844 # 80007350 <userret+0x2c0>
    8000200c:	ffffe097          	auipc	ra,0xffffe
    80002010:	542080e7          	jalr	1346(ra) # 8000054e <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80002014:	4f94                	lw	a3,24(a5)
    80002016:	4705                	li	a4,1
    80002018:	fce697e3          	bne	a3,a4,80001fe6 <exit+0xaa>
    p->state = RUNNABLE;
    8000201c:	4709                	li	a4,2
    8000201e:	cf98                	sw	a4,24(a5)
    80002020:	b7d9                	j	80001fe6 <exit+0xaa>

0000000080002022 <yield>:
{
    80002022:	1101                	addi	sp,sp,-32
    80002024:	ec06                	sd	ra,24(sp)
    80002026:	e822                	sd	s0,16(sp)
    80002028:	e426                	sd	s1,8(sp)
    8000202a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000202c:	00000097          	auipc	ra,0x0
    80002030:	820080e7          	jalr	-2016(ra) # 8000184c <myproc>
    80002034:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002036:	fffff097          	auipc	ra,0xfffff
    8000203a:	ab4080e7          	jalr	-1356(ra) # 80000aea <acquire>
  p->state = RUNNABLE;
    8000203e:	4789                	li	a5,2
    80002040:	cc9c                	sw	a5,24(s1)
  sched();
    80002042:	00000097          	auipc	ra,0x0
    80002046:	e24080e7          	jalr	-476(ra) # 80001e66 <sched>
  release(&p->lock);
    8000204a:	8526                	mv	a0,s1
    8000204c:	fffff097          	auipc	ra,0xfffff
    80002050:	b06080e7          	jalr	-1274(ra) # 80000b52 <release>
}
    80002054:	60e2                	ld	ra,24(sp)
    80002056:	6442                	ld	s0,16(sp)
    80002058:	64a2                	ld	s1,8(sp)
    8000205a:	6105                	addi	sp,sp,32
    8000205c:	8082                	ret

000000008000205e <sleep>:
{
    8000205e:	7179                	addi	sp,sp,-48
    80002060:	f406                	sd	ra,40(sp)
    80002062:	f022                	sd	s0,32(sp)
    80002064:	ec26                	sd	s1,24(sp)
    80002066:	e84a                	sd	s2,16(sp)
    80002068:	e44e                	sd	s3,8(sp)
    8000206a:	1800                	addi	s0,sp,48
    8000206c:	89aa                	mv	s3,a0
    8000206e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002070:	fffff097          	auipc	ra,0xfffff
    80002074:	7dc080e7          	jalr	2012(ra) # 8000184c <myproc>
    80002078:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    8000207a:	05250663          	beq	a0,s2,800020c6 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	a6c080e7          	jalr	-1428(ra) # 80000aea <acquire>
    release(lk);
    80002086:	854a                	mv	a0,s2
    80002088:	fffff097          	auipc	ra,0xfffff
    8000208c:	aca080e7          	jalr	-1334(ra) # 80000b52 <release>
  p->chan = chan;
    80002090:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80002094:	4785                	li	a5,1
    80002096:	cc9c                	sw	a5,24(s1)
  sched();
    80002098:	00000097          	auipc	ra,0x0
    8000209c:	dce080e7          	jalr	-562(ra) # 80001e66 <sched>
  p->chan = 0;
    800020a0:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800020a4:	8526                	mv	a0,s1
    800020a6:	fffff097          	auipc	ra,0xfffff
    800020aa:	aac080e7          	jalr	-1364(ra) # 80000b52 <release>
    acquire(lk);
    800020ae:	854a                	mv	a0,s2
    800020b0:	fffff097          	auipc	ra,0xfffff
    800020b4:	a3a080e7          	jalr	-1478(ra) # 80000aea <acquire>
}
    800020b8:	70a2                	ld	ra,40(sp)
    800020ba:	7402                	ld	s0,32(sp)
    800020bc:	64e2                	ld	s1,24(sp)
    800020be:	6942                	ld	s2,16(sp)
    800020c0:	69a2                	ld	s3,8(sp)
    800020c2:	6145                	addi	sp,sp,48
    800020c4:	8082                	ret
  p->chan = chan;
    800020c6:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800020ca:	4785                	li	a5,1
    800020cc:	cd1c                	sw	a5,24(a0)
  sched();
    800020ce:	00000097          	auipc	ra,0x0
    800020d2:	d98080e7          	jalr	-616(ra) # 80001e66 <sched>
  p->chan = 0;
    800020d6:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    800020da:	bff9                	j	800020b8 <sleep+0x5a>

00000000800020dc <wait>:
{
    800020dc:	715d                	addi	sp,sp,-80
    800020de:	e486                	sd	ra,72(sp)
    800020e0:	e0a2                	sd	s0,64(sp)
    800020e2:	fc26                	sd	s1,56(sp)
    800020e4:	f84a                	sd	s2,48(sp)
    800020e6:	f44e                	sd	s3,40(sp)
    800020e8:	f052                	sd	s4,32(sp)
    800020ea:	ec56                	sd	s5,24(sp)
    800020ec:	e85a                	sd	s6,16(sp)
    800020ee:	e45e                	sd	s7,8(sp)
    800020f0:	e062                	sd	s8,0(sp)
    800020f2:	0880                	addi	s0,sp,80
    800020f4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800020f6:	fffff097          	auipc	ra,0xfffff
    800020fa:	756080e7          	jalr	1878(ra) # 8000184c <myproc>
    800020fe:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002100:	8c2a                	mv	s8,a0
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	9e8080e7          	jalr	-1560(ra) # 80000aea <acquire>
    havekids = 0;
    8000210a:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000210c:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    8000210e:	00015997          	auipc	s3,0x15
    80002112:	5f298993          	addi	s3,s3,1522 # 80017700 <tickslock>
        havekids = 1;
    80002116:	4a85                	li	s5,1
    havekids = 0;
    80002118:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000211a:	00010497          	auipc	s1,0x10
    8000211e:	be648493          	addi	s1,s1,-1050 # 80011d00 <proc>
    80002122:	a08d                	j	80002184 <wait+0xa8>
          pid = np->pid;
    80002124:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002128:	000b0e63          	beqz	s6,80002144 <wait+0x68>
    8000212c:	4691                	li	a3,4
    8000212e:	03448613          	addi	a2,s1,52
    80002132:	85da                	mv	a1,s6
    80002134:	05093503          	ld	a0,80(s2)
    80002138:	fffff097          	auipc	ra,0xfffff
    8000213c:	43a080e7          	jalr	1082(ra) # 80001572 <copyout>
    80002140:	02054263          	bltz	a0,80002164 <wait+0x88>
          freeproc(np);
    80002144:	8526                	mv	a0,s1
    80002146:	00000097          	auipc	ra,0x0
    8000214a:	922080e7          	jalr	-1758(ra) # 80001a68 <freeproc>
          release(&np->lock);
    8000214e:	8526                	mv	a0,s1
    80002150:	fffff097          	auipc	ra,0xfffff
    80002154:	a02080e7          	jalr	-1534(ra) # 80000b52 <release>
          release(&p->lock);
    80002158:	854a                	mv	a0,s2
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	9f8080e7          	jalr	-1544(ra) # 80000b52 <release>
          return pid;
    80002162:	a8a9                	j	800021bc <wait+0xe0>
            release(&np->lock);
    80002164:	8526                	mv	a0,s1
    80002166:	fffff097          	auipc	ra,0xfffff
    8000216a:	9ec080e7          	jalr	-1556(ra) # 80000b52 <release>
            release(&p->lock);
    8000216e:	854a                	mv	a0,s2
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	9e2080e7          	jalr	-1566(ra) # 80000b52 <release>
            return -1;
    80002178:	59fd                	li	s3,-1
    8000217a:	a089                	j	800021bc <wait+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    8000217c:	16848493          	addi	s1,s1,360
    80002180:	03348463          	beq	s1,s3,800021a8 <wait+0xcc>
      if(np->parent == p){
    80002184:	709c                	ld	a5,32(s1)
    80002186:	ff279be3          	bne	a5,s2,8000217c <wait+0xa0>
        acquire(&np->lock);
    8000218a:	8526                	mv	a0,s1
    8000218c:	fffff097          	auipc	ra,0xfffff
    80002190:	95e080e7          	jalr	-1698(ra) # 80000aea <acquire>
        if(np->state == ZOMBIE){
    80002194:	4c9c                	lw	a5,24(s1)
    80002196:	f94787e3          	beq	a5,s4,80002124 <wait+0x48>
        release(&np->lock);
    8000219a:	8526                	mv	a0,s1
    8000219c:	fffff097          	auipc	ra,0xfffff
    800021a0:	9b6080e7          	jalr	-1610(ra) # 80000b52 <release>
        havekids = 1;
    800021a4:	8756                	mv	a4,s5
    800021a6:	bfd9                	j	8000217c <wait+0xa0>
    if(!havekids || p->killed){
    800021a8:	c701                	beqz	a4,800021b0 <wait+0xd4>
    800021aa:	03092783          	lw	a5,48(s2)
    800021ae:	c785                	beqz	a5,800021d6 <wait+0xfa>
      release(&p->lock);
    800021b0:	854a                	mv	a0,s2
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	9a0080e7          	jalr	-1632(ra) # 80000b52 <release>
      return -1;
    800021ba:	59fd                	li	s3,-1
}
    800021bc:	854e                	mv	a0,s3
    800021be:	60a6                	ld	ra,72(sp)
    800021c0:	6406                	ld	s0,64(sp)
    800021c2:	74e2                	ld	s1,56(sp)
    800021c4:	7942                	ld	s2,48(sp)
    800021c6:	79a2                	ld	s3,40(sp)
    800021c8:	7a02                	ld	s4,32(sp)
    800021ca:	6ae2                	ld	s5,24(sp)
    800021cc:	6b42                	ld	s6,16(sp)
    800021ce:	6ba2                	ld	s7,8(sp)
    800021d0:	6c02                	ld	s8,0(sp)
    800021d2:	6161                	addi	sp,sp,80
    800021d4:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    800021d6:	85e2                	mv	a1,s8
    800021d8:	854a                	mv	a0,s2
    800021da:	00000097          	auipc	ra,0x0
    800021de:	e84080e7          	jalr	-380(ra) # 8000205e <sleep>
    havekids = 0;
    800021e2:	bf1d                	j	80002118 <wait+0x3c>

00000000800021e4 <wakeup>:
{
    800021e4:	7139                	addi	sp,sp,-64
    800021e6:	fc06                	sd	ra,56(sp)
    800021e8:	f822                	sd	s0,48(sp)
    800021ea:	f426                	sd	s1,40(sp)
    800021ec:	f04a                	sd	s2,32(sp)
    800021ee:	ec4e                	sd	s3,24(sp)
    800021f0:	e852                	sd	s4,16(sp)
    800021f2:	e456                	sd	s5,8(sp)
    800021f4:	0080                	addi	s0,sp,64
    800021f6:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800021f8:	00010497          	auipc	s1,0x10
    800021fc:	b0848493          	addi	s1,s1,-1272 # 80011d00 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002200:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002202:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80002204:	00015917          	auipc	s2,0x15
    80002208:	4fc90913          	addi	s2,s2,1276 # 80017700 <tickslock>
    8000220c:	a821                	j	80002224 <wakeup+0x40>
      p->state = RUNNABLE;
    8000220e:	0154ac23          	sw	s5,24(s1)
    release(&p->lock);
    80002212:	8526                	mv	a0,s1
    80002214:	fffff097          	auipc	ra,0xfffff
    80002218:	93e080e7          	jalr	-1730(ra) # 80000b52 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000221c:	16848493          	addi	s1,s1,360
    80002220:	01248e63          	beq	s1,s2,8000223c <wakeup+0x58>
    acquire(&p->lock);
    80002224:	8526                	mv	a0,s1
    80002226:	fffff097          	auipc	ra,0xfffff
    8000222a:	8c4080e7          	jalr	-1852(ra) # 80000aea <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    8000222e:	4c9c                	lw	a5,24(s1)
    80002230:	ff3791e3          	bne	a5,s3,80002212 <wakeup+0x2e>
    80002234:	749c                	ld	a5,40(s1)
    80002236:	fd479ee3          	bne	a5,s4,80002212 <wakeup+0x2e>
    8000223a:	bfd1                	j	8000220e <wakeup+0x2a>
}
    8000223c:	70e2                	ld	ra,56(sp)
    8000223e:	7442                	ld	s0,48(sp)
    80002240:	74a2                	ld	s1,40(sp)
    80002242:	7902                	ld	s2,32(sp)
    80002244:	69e2                	ld	s3,24(sp)
    80002246:	6a42                	ld	s4,16(sp)
    80002248:	6aa2                	ld	s5,8(sp)
    8000224a:	6121                	addi	sp,sp,64
    8000224c:	8082                	ret

000000008000224e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000224e:	7179                	addi	sp,sp,-48
    80002250:	f406                	sd	ra,40(sp)
    80002252:	f022                	sd	s0,32(sp)
    80002254:	ec26                	sd	s1,24(sp)
    80002256:	e84a                	sd	s2,16(sp)
    80002258:	e44e                	sd	s3,8(sp)
    8000225a:	1800                	addi	s0,sp,48
    8000225c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000225e:	00010497          	auipc	s1,0x10
    80002262:	aa248493          	addi	s1,s1,-1374 # 80011d00 <proc>
    80002266:	00015997          	auipc	s3,0x15
    8000226a:	49a98993          	addi	s3,s3,1178 # 80017700 <tickslock>
    acquire(&p->lock);
    8000226e:	8526                	mv	a0,s1
    80002270:	fffff097          	auipc	ra,0xfffff
    80002274:	87a080e7          	jalr	-1926(ra) # 80000aea <acquire>
    if(p->pid == pid){
    80002278:	5c9c                	lw	a5,56(s1)
    8000227a:	01278d63          	beq	a5,s2,80002294 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000227e:	8526                	mv	a0,s1
    80002280:	fffff097          	auipc	ra,0xfffff
    80002284:	8d2080e7          	jalr	-1838(ra) # 80000b52 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002288:	16848493          	addi	s1,s1,360
    8000228c:	ff3491e3          	bne	s1,s3,8000226e <kill+0x20>
  }
  return -1;
    80002290:	557d                	li	a0,-1
    80002292:	a821                	j	800022aa <kill+0x5c>
      p->killed = 1;
    80002294:	4785                	li	a5,1
    80002296:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002298:	4c98                	lw	a4,24(s1)
    8000229a:	00f70f63          	beq	a4,a5,800022b8 <kill+0x6a>
      release(&p->lock);
    8000229e:	8526                	mv	a0,s1
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	8b2080e7          	jalr	-1870(ra) # 80000b52 <release>
      return 0;
    800022a8:	4501                	li	a0,0
}
    800022aa:	70a2                	ld	ra,40(sp)
    800022ac:	7402                	ld	s0,32(sp)
    800022ae:	64e2                	ld	s1,24(sp)
    800022b0:	6942                	ld	s2,16(sp)
    800022b2:	69a2                	ld	s3,8(sp)
    800022b4:	6145                	addi	sp,sp,48
    800022b6:	8082                	ret
        p->state = RUNNABLE;
    800022b8:	4789                	li	a5,2
    800022ba:	cc9c                	sw	a5,24(s1)
    800022bc:	b7cd                	j	8000229e <kill+0x50>

00000000800022be <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800022be:	7179                	addi	sp,sp,-48
    800022c0:	f406                	sd	ra,40(sp)
    800022c2:	f022                	sd	s0,32(sp)
    800022c4:	ec26                	sd	s1,24(sp)
    800022c6:	e84a                	sd	s2,16(sp)
    800022c8:	e44e                	sd	s3,8(sp)
    800022ca:	e052                	sd	s4,0(sp)
    800022cc:	1800                	addi	s0,sp,48
    800022ce:	84aa                	mv	s1,a0
    800022d0:	892e                	mv	s2,a1
    800022d2:	89b2                	mv	s3,a2
    800022d4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	576080e7          	jalr	1398(ra) # 8000184c <myproc>
  if(user_dst){
    800022de:	c08d                	beqz	s1,80002300 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800022e0:	86d2                	mv	a3,s4
    800022e2:	864e                	mv	a2,s3
    800022e4:	85ca                	mv	a1,s2
    800022e6:	6928                	ld	a0,80(a0)
    800022e8:	fffff097          	auipc	ra,0xfffff
    800022ec:	28a080e7          	jalr	650(ra) # 80001572 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800022f0:	70a2                	ld	ra,40(sp)
    800022f2:	7402                	ld	s0,32(sp)
    800022f4:	64e2                	ld	s1,24(sp)
    800022f6:	6942                	ld	s2,16(sp)
    800022f8:	69a2                	ld	s3,8(sp)
    800022fa:	6a02                	ld	s4,0(sp)
    800022fc:	6145                	addi	sp,sp,48
    800022fe:	8082                	ret
    memmove((char *)dst, src, len);
    80002300:	000a061b          	sext.w	a2,s4
    80002304:	85ce                	mv	a1,s3
    80002306:	854a                	mv	a0,s2
    80002308:	fffff097          	auipc	ra,0xfffff
    8000230c:	906080e7          	jalr	-1786(ra) # 80000c0e <memmove>
    return 0;
    80002310:	8526                	mv	a0,s1
    80002312:	bff9                	j	800022f0 <either_copyout+0x32>

0000000080002314 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002314:	7179                	addi	sp,sp,-48
    80002316:	f406                	sd	ra,40(sp)
    80002318:	f022                	sd	s0,32(sp)
    8000231a:	ec26                	sd	s1,24(sp)
    8000231c:	e84a                	sd	s2,16(sp)
    8000231e:	e44e                	sd	s3,8(sp)
    80002320:	e052                	sd	s4,0(sp)
    80002322:	1800                	addi	s0,sp,48
    80002324:	892a                	mv	s2,a0
    80002326:	84ae                	mv	s1,a1
    80002328:	89b2                	mv	s3,a2
    8000232a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000232c:	fffff097          	auipc	ra,0xfffff
    80002330:	520080e7          	jalr	1312(ra) # 8000184c <myproc>
  if(user_src){
    80002334:	c08d                	beqz	s1,80002356 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002336:	86d2                	mv	a3,s4
    80002338:	864e                	mv	a2,s3
    8000233a:	85ca                	mv	a1,s2
    8000233c:	6928                	ld	a0,80(a0)
    8000233e:	fffff097          	auipc	ra,0xfffff
    80002342:	2c6080e7          	jalr	710(ra) # 80001604 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002346:	70a2                	ld	ra,40(sp)
    80002348:	7402                	ld	s0,32(sp)
    8000234a:	64e2                	ld	s1,24(sp)
    8000234c:	6942                	ld	s2,16(sp)
    8000234e:	69a2                	ld	s3,8(sp)
    80002350:	6a02                	ld	s4,0(sp)
    80002352:	6145                	addi	sp,sp,48
    80002354:	8082                	ret
    memmove(dst, (char*)src, len);
    80002356:	000a061b          	sext.w	a2,s4
    8000235a:	85ce                	mv	a1,s3
    8000235c:	854a                	mv	a0,s2
    8000235e:	fffff097          	auipc	ra,0xfffff
    80002362:	8b0080e7          	jalr	-1872(ra) # 80000c0e <memmove>
    return 0;
    80002366:	8526                	mv	a0,s1
    80002368:	bff9                	j	80002346 <either_copyin+0x32>

000000008000236a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000236a:	715d                	addi	sp,sp,-80
    8000236c:	e486                	sd	ra,72(sp)
    8000236e:	e0a2                	sd	s0,64(sp)
    80002370:	fc26                	sd	s1,56(sp)
    80002372:	f84a                	sd	s2,48(sp)
    80002374:	f44e                	sd	s3,40(sp)
    80002376:	f052                	sd	s4,32(sp)
    80002378:	ec56                	sd	s5,24(sp)
    8000237a:	e85a                	sd	s6,16(sp)
    8000237c:	e45e                	sd	s7,8(sp)
    8000237e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002380:	00005517          	auipc	a0,0x5
    80002384:	e3050513          	addi	a0,a0,-464 # 800071b0 <userret+0x120>
    80002388:	ffffe097          	auipc	ra,0xffffe
    8000238c:	210080e7          	jalr	528(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002390:	00010497          	auipc	s1,0x10
    80002394:	ac848493          	addi	s1,s1,-1336 # 80011e58 <proc+0x158>
    80002398:	00015917          	auipc	s2,0x15
    8000239c:	4c090913          	addi	s2,s2,1216 # 80017858 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023a0:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800023a2:	00005997          	auipc	s3,0x5
    800023a6:	fbe98993          	addi	s3,s3,-66 # 80007360 <userret+0x2d0>
    printf("%d %s %s", p->pid, state, p->name);
    800023aa:	00005a97          	auipc	s5,0x5
    800023ae:	fbea8a93          	addi	s5,s5,-66 # 80007368 <userret+0x2d8>
    printf("\n");
    800023b2:	00005a17          	auipc	s4,0x5
    800023b6:	dfea0a13          	addi	s4,s4,-514 # 800071b0 <userret+0x120>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023ba:	00005b97          	auipc	s7,0x5
    800023be:	55eb8b93          	addi	s7,s7,1374 # 80007918 <states.1783>
    800023c2:	a00d                	j	800023e4 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800023c4:	ee06a583          	lw	a1,-288(a3)
    800023c8:	8556                	mv	a0,s5
    800023ca:	ffffe097          	auipc	ra,0xffffe
    800023ce:	1ce080e7          	jalr	462(ra) # 80000598 <printf>
    printf("\n");
    800023d2:	8552                	mv	a0,s4
    800023d4:	ffffe097          	auipc	ra,0xffffe
    800023d8:	1c4080e7          	jalr	452(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800023dc:	16848493          	addi	s1,s1,360
    800023e0:	03248163          	beq	s1,s2,80002402 <procdump+0x98>
    if(p->state == UNUSED)
    800023e4:	86a6                	mv	a3,s1
    800023e6:	ec04a783          	lw	a5,-320(s1)
    800023ea:	dbed                	beqz	a5,800023dc <procdump+0x72>
      state = "???";
    800023ec:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023ee:	fcfb6be3          	bltu	s6,a5,800023c4 <procdump+0x5a>
    800023f2:	1782                	slli	a5,a5,0x20
    800023f4:	9381                	srli	a5,a5,0x20
    800023f6:	078e                	slli	a5,a5,0x3
    800023f8:	97de                	add	a5,a5,s7
    800023fa:	6390                	ld	a2,0(a5)
    800023fc:	f661                	bnez	a2,800023c4 <procdump+0x5a>
      state = "???";
    800023fe:	864e                	mv	a2,s3
    80002400:	b7d1                	j	800023c4 <procdump+0x5a>
  }
}
    80002402:	60a6                	ld	ra,72(sp)
    80002404:	6406                	ld	s0,64(sp)
    80002406:	74e2                	ld	s1,56(sp)
    80002408:	7942                	ld	s2,48(sp)
    8000240a:	79a2                	ld	s3,40(sp)
    8000240c:	7a02                	ld	s4,32(sp)
    8000240e:	6ae2                	ld	s5,24(sp)
    80002410:	6b42                	ld	s6,16(sp)
    80002412:	6ba2                	ld	s7,8(sp)
    80002414:	6161                	addi	sp,sp,80
    80002416:	8082                	ret

0000000080002418 <swtch>:
    80002418:	00153023          	sd	ra,0(a0)
    8000241c:	00253423          	sd	sp,8(a0)
    80002420:	e900                	sd	s0,16(a0)
    80002422:	ed04                	sd	s1,24(a0)
    80002424:	03253023          	sd	s2,32(a0)
    80002428:	03353423          	sd	s3,40(a0)
    8000242c:	03453823          	sd	s4,48(a0)
    80002430:	03553c23          	sd	s5,56(a0)
    80002434:	05653023          	sd	s6,64(a0)
    80002438:	05753423          	sd	s7,72(a0)
    8000243c:	05853823          	sd	s8,80(a0)
    80002440:	05953c23          	sd	s9,88(a0)
    80002444:	07a53023          	sd	s10,96(a0)
    80002448:	07b53423          	sd	s11,104(a0)
    8000244c:	0005b083          	ld	ra,0(a1)
    80002450:	0085b103          	ld	sp,8(a1)
    80002454:	6980                	ld	s0,16(a1)
    80002456:	6d84                	ld	s1,24(a1)
    80002458:	0205b903          	ld	s2,32(a1)
    8000245c:	0285b983          	ld	s3,40(a1)
    80002460:	0305ba03          	ld	s4,48(a1)
    80002464:	0385ba83          	ld	s5,56(a1)
    80002468:	0405bb03          	ld	s6,64(a1)
    8000246c:	0485bb83          	ld	s7,72(a1)
    80002470:	0505bc03          	ld	s8,80(a1)
    80002474:	0585bc83          	ld	s9,88(a1)
    80002478:	0605bd03          	ld	s10,96(a1)
    8000247c:	0685bd83          	ld	s11,104(a1)
    80002480:	8082                	ret

0000000080002482 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002482:	1141                	addi	sp,sp,-16
    80002484:	e406                	sd	ra,8(sp)
    80002486:	e022                	sd	s0,0(sp)
    80002488:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000248a:	00005597          	auipc	a1,0x5
    8000248e:	f1658593          	addi	a1,a1,-234 # 800073a0 <userret+0x310>
    80002492:	00015517          	auipc	a0,0x15
    80002496:	26e50513          	addi	a0,a0,622 # 80017700 <tickslock>
    8000249a:	ffffe097          	auipc	ra,0xffffe
    8000249e:	53e080e7          	jalr	1342(ra) # 800009d8 <initlock>
}
    800024a2:	60a2                	ld	ra,8(sp)
    800024a4:	6402                	ld	s0,0(sp)
    800024a6:	0141                	addi	sp,sp,16
    800024a8:	8082                	ret

00000000800024aa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800024aa:	1141                	addi	sp,sp,-16
    800024ac:	e422                	sd	s0,8(sp)
    800024ae:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800024b0:	00003797          	auipc	a5,0x3
    800024b4:	74078793          	addi	a5,a5,1856 # 80005bf0 <kernelvec>
    800024b8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800024bc:	6422                	ld	s0,8(sp)
    800024be:	0141                	addi	sp,sp,16
    800024c0:	8082                	ret

00000000800024c2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800024c2:	1141                	addi	sp,sp,-16
    800024c4:	e406                	sd	ra,8(sp)
    800024c6:	e022                	sd	s0,0(sp)
    800024c8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800024ca:	fffff097          	auipc	ra,0xfffff
    800024ce:	382080e7          	jalr	898(ra) # 8000184c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024d2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800024d6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024d8:	10079073          	csrw	sstatus,a5
  // turn off interrupts, since we're switching
  // now from kerneltrap() to usertrap().
  intr_off();

  // send interrupts and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    800024dc:	00005617          	auipc	a2,0x5
    800024e0:	b2460613          	addi	a2,a2,-1244 # 80007000 <trampoline>
    800024e4:	00005697          	auipc	a3,0x5
    800024e8:	b1c68693          	addi	a3,a3,-1252 # 80007000 <trampoline>
    800024ec:	8e91                	sub	a3,a3,a2
    800024ee:	040007b7          	lui	a5,0x4000
    800024f2:	17fd                	addi	a5,a5,-1
    800024f4:	07b2                	slli	a5,a5,0xc
    800024f6:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800024f8:	10569073          	csrw	stvec,a3

  // set up values that uservec will need when
  // the process next re-enters the kernel.
  p->tf->kernel_satp = r_satp();         // kernel page table
    800024fc:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800024fe:	180026f3          	csrr	a3,satp
    80002502:	e314                	sd	a3,0(a4)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002504:	6d38                	ld	a4,88(a0)
    80002506:	6134                	ld	a3,64(a0)
    80002508:	6585                	lui	a1,0x1
    8000250a:	96ae                	add	a3,a3,a1
    8000250c:	e714                	sd	a3,8(a4)
  p->tf->kernel_trap = (uint64)usertrap;
    8000250e:	6d38                	ld	a4,88(a0)
    80002510:	00000697          	auipc	a3,0x0
    80002514:	12868693          	addi	a3,a3,296 # 80002638 <usertrap>
    80002518:	eb14                	sd	a3,16(a4)
  p->tf->kernel_hartid = r_tp();         // hartid for cpuid()
    8000251a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000251c:	8692                	mv	a3,tp
    8000251e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002520:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002524:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002528:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000252c:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->tf->epc);
    80002530:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002532:	6f18                	ld	a4,24(a4)
    80002534:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002538:	692c                	ld	a1,80(a0)
    8000253a:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    8000253c:	00005717          	auipc	a4,0x5
    80002540:	b5470713          	addi	a4,a4,-1196 # 80007090 <userret>
    80002544:	8f11                	sub	a4,a4,a2
    80002546:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002548:	577d                	li	a4,-1
    8000254a:	177e                	slli	a4,a4,0x3f
    8000254c:	8dd9                	or	a1,a1,a4
    8000254e:	02000537          	lui	a0,0x2000
    80002552:	157d                	addi	a0,a0,-1
    80002554:	0536                	slli	a0,a0,0xd
    80002556:	9782                	jalr	a5
}
    80002558:	60a2                	ld	ra,8(sp)
    8000255a:	6402                	ld	s0,0(sp)
    8000255c:	0141                	addi	sp,sp,16
    8000255e:	8082                	ret

0000000080002560 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002560:	1101                	addi	sp,sp,-32
    80002562:	ec06                	sd	ra,24(sp)
    80002564:	e822                	sd	s0,16(sp)
    80002566:	e426                	sd	s1,8(sp)
    80002568:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    8000256a:	00015497          	auipc	s1,0x15
    8000256e:	19648493          	addi	s1,s1,406 # 80017700 <tickslock>
    80002572:	8526                	mv	a0,s1
    80002574:	ffffe097          	auipc	ra,0xffffe
    80002578:	576080e7          	jalr	1398(ra) # 80000aea <acquire>
  ticks++;
    8000257c:	00027517          	auipc	a0,0x27
    80002580:	ac450513          	addi	a0,a0,-1340 # 80029040 <ticks>
    80002584:	411c                	lw	a5,0(a0)
    80002586:	2785                	addiw	a5,a5,1
    80002588:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    8000258a:	00000097          	auipc	ra,0x0
    8000258e:	c5a080e7          	jalr	-934(ra) # 800021e4 <wakeup>
  release(&tickslock);
    80002592:	8526                	mv	a0,s1
    80002594:	ffffe097          	auipc	ra,0xffffe
    80002598:	5be080e7          	jalr	1470(ra) # 80000b52 <release>
}
    8000259c:	60e2                	ld	ra,24(sp)
    8000259e:	6442                	ld	s0,16(sp)
    800025a0:	64a2                	ld	s1,8(sp)
    800025a2:	6105                	addi	sp,sp,32
    800025a4:	8082                	ret

00000000800025a6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800025a6:	1101                	addi	sp,sp,-32
    800025a8:	ec06                	sd	ra,24(sp)
    800025aa:	e822                	sd	s0,16(sp)
    800025ac:	e426                	sd	s1,8(sp)
    800025ae:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025b0:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800025b4:	00074d63          	bltz	a4,800025ce <devintr+0x28>
      virtio_disk_intr(irq - VIRTIO0_IRQ);
    }

    plic_complete(irq);
    return 1;
  } else if(scause == 0x8000000000000001L){
    800025b8:	57fd                	li	a5,-1
    800025ba:	17fe                	slli	a5,a5,0x3f
    800025bc:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800025be:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800025c0:	04f70b63          	beq	a4,a5,80002616 <devintr+0x70>
  }
}
    800025c4:	60e2                	ld	ra,24(sp)
    800025c6:	6442                	ld	s0,16(sp)
    800025c8:	64a2                	ld	s1,8(sp)
    800025ca:	6105                	addi	sp,sp,32
    800025cc:	8082                	ret
     (scause & 0xff) == 9){
    800025ce:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    800025d2:	46a5                	li	a3,9
    800025d4:	fed792e3          	bne	a5,a3,800025b8 <devintr+0x12>
    int irq = plic_claim();
    800025d8:	00003097          	auipc	ra,0x3
    800025dc:	732080e7          	jalr	1842(ra) # 80005d0a <plic_claim>
    800025e0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800025e2:	47a9                	li	a5,10
    800025e4:	00f50e63          	beq	a0,a5,80002600 <devintr+0x5a>
    } else if(irq == VIRTIO0_IRQ || irq == VIRTIO1_IRQ ){
    800025e8:	fff5079b          	addiw	a5,a0,-1
    800025ec:	4705                	li	a4,1
    800025ee:	00f77e63          	bgeu	a4,a5,8000260a <devintr+0x64>
    plic_complete(irq);
    800025f2:	8526                	mv	a0,s1
    800025f4:	00003097          	auipc	ra,0x3
    800025f8:	73a080e7          	jalr	1850(ra) # 80005d2e <plic_complete>
    return 1;
    800025fc:	4505                	li	a0,1
    800025fe:	b7d9                	j	800025c4 <devintr+0x1e>
      uartintr();
    80002600:	ffffe097          	auipc	ra,0xffffe
    80002604:	238080e7          	jalr	568(ra) # 80000838 <uartintr>
    80002608:	b7ed                	j	800025f2 <devintr+0x4c>
      virtio_disk_intr(irq - VIRTIO0_IRQ);
    8000260a:	853e                	mv	a0,a5
    8000260c:	00004097          	auipc	ra,0x4
    80002610:	cf2080e7          	jalr	-782(ra) # 800062fe <virtio_disk_intr>
    80002614:	bff9                	j	800025f2 <devintr+0x4c>
    if(cpuid() == 0){
    80002616:	fffff097          	auipc	ra,0xfffff
    8000261a:	20a080e7          	jalr	522(ra) # 80001820 <cpuid>
    8000261e:	c901                	beqz	a0,8000262e <devintr+0x88>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002620:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002624:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002626:	14479073          	csrw	sip,a5
    return 2;
    8000262a:	4509                	li	a0,2
    8000262c:	bf61                	j	800025c4 <devintr+0x1e>
      clockintr();
    8000262e:	00000097          	auipc	ra,0x0
    80002632:	f32080e7          	jalr	-206(ra) # 80002560 <clockintr>
    80002636:	b7ed                	j	80002620 <devintr+0x7a>

0000000080002638 <usertrap>:
{
    80002638:	1101                	addi	sp,sp,-32
    8000263a:	ec06                	sd	ra,24(sp)
    8000263c:	e822                	sd	s0,16(sp)
    8000263e:	e426                	sd	s1,8(sp)
    80002640:	e04a                	sd	s2,0(sp)
    80002642:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002644:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002648:	1007f793          	andi	a5,a5,256
    8000264c:	e7bd                	bnez	a5,800026ba <usertrap+0x82>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000264e:	00003797          	auipc	a5,0x3
    80002652:	5a278793          	addi	a5,a5,1442 # 80005bf0 <kernelvec>
    80002656:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000265a:	fffff097          	auipc	ra,0xfffff
    8000265e:	1f2080e7          	jalr	498(ra) # 8000184c <myproc>
    80002662:	84aa                	mv	s1,a0
  p->tf->epc = r_sepc();
    80002664:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002666:	14102773          	csrr	a4,sepc
    8000266a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000266c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002670:	47a1                	li	a5,8
    80002672:	06f71263          	bne	a4,a5,800026d6 <usertrap+0x9e>
    if(p->killed)
    80002676:	591c                	lw	a5,48(a0)
    80002678:	eba9                	bnez	a5,800026ca <usertrap+0x92>
    p->tf->epc += 4;
    8000267a:	6cb8                	ld	a4,88(s1)
    8000267c:	6f1c                	ld	a5,24(a4)
    8000267e:	0791                	addi	a5,a5,4
    80002680:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sie" : "=r" (x) );
    80002682:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80002686:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000268a:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000268e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002692:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002696:	10079073          	csrw	sstatus,a5
    syscall();
    8000269a:	00000097          	auipc	ra,0x0
    8000269e:	2e0080e7          	jalr	736(ra) # 8000297a <syscall>
  if(p->killed)
    800026a2:	589c                	lw	a5,48(s1)
    800026a4:	ebc1                	bnez	a5,80002734 <usertrap+0xfc>
  usertrapret();
    800026a6:	00000097          	auipc	ra,0x0
    800026aa:	e1c080e7          	jalr	-484(ra) # 800024c2 <usertrapret>
}
    800026ae:	60e2                	ld	ra,24(sp)
    800026b0:	6442                	ld	s0,16(sp)
    800026b2:	64a2                	ld	s1,8(sp)
    800026b4:	6902                	ld	s2,0(sp)
    800026b6:	6105                	addi	sp,sp,32
    800026b8:	8082                	ret
    panic("usertrap: not from user mode");
    800026ba:	00005517          	auipc	a0,0x5
    800026be:	cee50513          	addi	a0,a0,-786 # 800073a8 <userret+0x318>
    800026c2:	ffffe097          	auipc	ra,0xffffe
    800026c6:	e8c080e7          	jalr	-372(ra) # 8000054e <panic>
      exit(-1);
    800026ca:	557d                	li	a0,-1
    800026cc:	00000097          	auipc	ra,0x0
    800026d0:	870080e7          	jalr	-1936(ra) # 80001f3c <exit>
    800026d4:	b75d                	j	8000267a <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    800026d6:	00000097          	auipc	ra,0x0
    800026da:	ed0080e7          	jalr	-304(ra) # 800025a6 <devintr>
    800026de:	892a                	mv	s2,a0
    800026e0:	c501                	beqz	a0,800026e8 <usertrap+0xb0>
  if(p->killed)
    800026e2:	589c                	lw	a5,48(s1)
    800026e4:	c3a1                	beqz	a5,80002724 <usertrap+0xec>
    800026e6:	a815                	j	8000271a <usertrap+0xe2>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026e8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800026ec:	5c90                	lw	a2,56(s1)
    800026ee:	00005517          	auipc	a0,0x5
    800026f2:	cda50513          	addi	a0,a0,-806 # 800073c8 <userret+0x338>
    800026f6:	ffffe097          	auipc	ra,0xffffe
    800026fa:	ea2080e7          	jalr	-350(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026fe:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002702:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002706:	00005517          	auipc	a0,0x5
    8000270a:	cf250513          	addi	a0,a0,-782 # 800073f8 <userret+0x368>
    8000270e:	ffffe097          	auipc	ra,0xffffe
    80002712:	e8a080e7          	jalr	-374(ra) # 80000598 <printf>
    p->killed = 1;
    80002716:	4785                	li	a5,1
    80002718:	d89c                	sw	a5,48(s1)
    exit(-1);
    8000271a:	557d                	li	a0,-1
    8000271c:	00000097          	auipc	ra,0x0
    80002720:	820080e7          	jalr	-2016(ra) # 80001f3c <exit>
  if(which_dev == 2)
    80002724:	4789                	li	a5,2
    80002726:	f8f910e3          	bne	s2,a5,800026a6 <usertrap+0x6e>
    yield();
    8000272a:	00000097          	auipc	ra,0x0
    8000272e:	8f8080e7          	jalr	-1800(ra) # 80002022 <yield>
    80002732:	bf95                	j	800026a6 <usertrap+0x6e>
  int which_dev = 0;
    80002734:	4901                	li	s2,0
    80002736:	b7d5                	j	8000271a <usertrap+0xe2>

0000000080002738 <kerneltrap>:
{
    80002738:	7179                	addi	sp,sp,-48
    8000273a:	f406                	sd	ra,40(sp)
    8000273c:	f022                	sd	s0,32(sp)
    8000273e:	ec26                	sd	s1,24(sp)
    80002740:	e84a                	sd	s2,16(sp)
    80002742:	e44e                	sd	s3,8(sp)
    80002744:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002746:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000274a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000274e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002752:	1004f793          	andi	a5,s1,256
    80002756:	cb85                	beqz	a5,80002786 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002758:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000275c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000275e:	ef85                	bnez	a5,80002796 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002760:	00000097          	auipc	ra,0x0
    80002764:	e46080e7          	jalr	-442(ra) # 800025a6 <devintr>
    80002768:	cd1d                	beqz	a0,800027a6 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000276a:	4789                	li	a5,2
    8000276c:	06f50a63          	beq	a0,a5,800027e0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002770:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002774:	10049073          	csrw	sstatus,s1
}
    80002778:	70a2                	ld	ra,40(sp)
    8000277a:	7402                	ld	s0,32(sp)
    8000277c:	64e2                	ld	s1,24(sp)
    8000277e:	6942                	ld	s2,16(sp)
    80002780:	69a2                	ld	s3,8(sp)
    80002782:	6145                	addi	sp,sp,48
    80002784:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002786:	00005517          	auipc	a0,0x5
    8000278a:	c9250513          	addi	a0,a0,-878 # 80007418 <userret+0x388>
    8000278e:	ffffe097          	auipc	ra,0xffffe
    80002792:	dc0080e7          	jalr	-576(ra) # 8000054e <panic>
    panic("kerneltrap: interrupts enabled");
    80002796:	00005517          	auipc	a0,0x5
    8000279a:	caa50513          	addi	a0,a0,-854 # 80007440 <userret+0x3b0>
    8000279e:	ffffe097          	auipc	ra,0xffffe
    800027a2:	db0080e7          	jalr	-592(ra) # 8000054e <panic>
    printf("scause %p\n", scause);
    800027a6:	85ce                	mv	a1,s3
    800027a8:	00005517          	auipc	a0,0x5
    800027ac:	cb850513          	addi	a0,a0,-840 # 80007460 <userret+0x3d0>
    800027b0:	ffffe097          	auipc	ra,0xffffe
    800027b4:	de8080e7          	jalr	-536(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027b8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800027bc:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800027c0:	00005517          	auipc	a0,0x5
    800027c4:	cb050513          	addi	a0,a0,-848 # 80007470 <userret+0x3e0>
    800027c8:	ffffe097          	auipc	ra,0xffffe
    800027cc:	dd0080e7          	jalr	-560(ra) # 80000598 <printf>
    panic("kerneltrap");
    800027d0:	00005517          	auipc	a0,0x5
    800027d4:	cb850513          	addi	a0,a0,-840 # 80007488 <userret+0x3f8>
    800027d8:	ffffe097          	auipc	ra,0xffffe
    800027dc:	d76080e7          	jalr	-650(ra) # 8000054e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800027e0:	fffff097          	auipc	ra,0xfffff
    800027e4:	06c080e7          	jalr	108(ra) # 8000184c <myproc>
    800027e8:	d541                	beqz	a0,80002770 <kerneltrap+0x38>
    800027ea:	fffff097          	auipc	ra,0xfffff
    800027ee:	062080e7          	jalr	98(ra) # 8000184c <myproc>
    800027f2:	4d18                	lw	a4,24(a0)
    800027f4:	478d                	li	a5,3
    800027f6:	f6f71de3          	bne	a4,a5,80002770 <kerneltrap+0x38>
    yield();
    800027fa:	00000097          	auipc	ra,0x0
    800027fe:	828080e7          	jalr	-2008(ra) # 80002022 <yield>
    80002802:	b7bd                	j	80002770 <kerneltrap+0x38>

0000000080002804 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002804:	1101                	addi	sp,sp,-32
    80002806:	ec06                	sd	ra,24(sp)
    80002808:	e822                	sd	s0,16(sp)
    8000280a:	e426                	sd	s1,8(sp)
    8000280c:	1000                	addi	s0,sp,32
    8000280e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002810:	fffff097          	auipc	ra,0xfffff
    80002814:	03c080e7          	jalr	60(ra) # 8000184c <myproc>
  switch (n) {
    80002818:	4795                	li	a5,5
    8000281a:	0497e163          	bltu	a5,s1,8000285c <argraw+0x58>
    8000281e:	048a                	slli	s1,s1,0x2
    80002820:	00005717          	auipc	a4,0x5
    80002824:	12070713          	addi	a4,a4,288 # 80007940 <states.1783+0x28>
    80002828:	94ba                	add	s1,s1,a4
    8000282a:	409c                	lw	a5,0(s1)
    8000282c:	97ba                	add	a5,a5,a4
    8000282e:	8782                	jr	a5
  case 0:
    return p->tf->a0;
    80002830:	6d3c                	ld	a5,88(a0)
    80002832:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
    80002834:	60e2                	ld	ra,24(sp)
    80002836:	6442                	ld	s0,16(sp)
    80002838:	64a2                	ld	s1,8(sp)
    8000283a:	6105                	addi	sp,sp,32
    8000283c:	8082                	ret
    return p->tf->a1;
    8000283e:	6d3c                	ld	a5,88(a0)
    80002840:	7fa8                	ld	a0,120(a5)
    80002842:	bfcd                	j	80002834 <argraw+0x30>
    return p->tf->a2;
    80002844:	6d3c                	ld	a5,88(a0)
    80002846:	63c8                	ld	a0,128(a5)
    80002848:	b7f5                	j	80002834 <argraw+0x30>
    return p->tf->a3;
    8000284a:	6d3c                	ld	a5,88(a0)
    8000284c:	67c8                	ld	a0,136(a5)
    8000284e:	b7dd                	j	80002834 <argraw+0x30>
    return p->tf->a4;
    80002850:	6d3c                	ld	a5,88(a0)
    80002852:	6bc8                	ld	a0,144(a5)
    80002854:	b7c5                	j	80002834 <argraw+0x30>
    return p->tf->a5;
    80002856:	6d3c                	ld	a5,88(a0)
    80002858:	6fc8                	ld	a0,152(a5)
    8000285a:	bfe9                	j	80002834 <argraw+0x30>
  panic("argraw");
    8000285c:	00005517          	auipc	a0,0x5
    80002860:	c3c50513          	addi	a0,a0,-964 # 80007498 <userret+0x408>
    80002864:	ffffe097          	auipc	ra,0xffffe
    80002868:	cea080e7          	jalr	-790(ra) # 8000054e <panic>

000000008000286c <fetchaddr>:
{
    8000286c:	1101                	addi	sp,sp,-32
    8000286e:	ec06                	sd	ra,24(sp)
    80002870:	e822                	sd	s0,16(sp)
    80002872:	e426                	sd	s1,8(sp)
    80002874:	e04a                	sd	s2,0(sp)
    80002876:	1000                	addi	s0,sp,32
    80002878:	84aa                	mv	s1,a0
    8000287a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000287c:	fffff097          	auipc	ra,0xfffff
    80002880:	fd0080e7          	jalr	-48(ra) # 8000184c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002884:	653c                	ld	a5,72(a0)
    80002886:	02f4f863          	bgeu	s1,a5,800028b6 <fetchaddr+0x4a>
    8000288a:	00848713          	addi	a4,s1,8
    8000288e:	02e7e663          	bltu	a5,a4,800028ba <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002892:	46a1                	li	a3,8
    80002894:	8626                	mv	a2,s1
    80002896:	85ca                	mv	a1,s2
    80002898:	6928                	ld	a0,80(a0)
    8000289a:	fffff097          	auipc	ra,0xfffff
    8000289e:	d6a080e7          	jalr	-662(ra) # 80001604 <copyin>
    800028a2:	00a03533          	snez	a0,a0
    800028a6:	40a00533          	neg	a0,a0
}
    800028aa:	60e2                	ld	ra,24(sp)
    800028ac:	6442                	ld	s0,16(sp)
    800028ae:	64a2                	ld	s1,8(sp)
    800028b0:	6902                	ld	s2,0(sp)
    800028b2:	6105                	addi	sp,sp,32
    800028b4:	8082                	ret
    return -1;
    800028b6:	557d                	li	a0,-1
    800028b8:	bfcd                	j	800028aa <fetchaddr+0x3e>
    800028ba:	557d                	li	a0,-1
    800028bc:	b7fd                	j	800028aa <fetchaddr+0x3e>

00000000800028be <fetchstr>:
{
    800028be:	7179                	addi	sp,sp,-48
    800028c0:	f406                	sd	ra,40(sp)
    800028c2:	f022                	sd	s0,32(sp)
    800028c4:	ec26                	sd	s1,24(sp)
    800028c6:	e84a                	sd	s2,16(sp)
    800028c8:	e44e                	sd	s3,8(sp)
    800028ca:	1800                	addi	s0,sp,48
    800028cc:	892a                	mv	s2,a0
    800028ce:	84ae                	mv	s1,a1
    800028d0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800028d2:	fffff097          	auipc	ra,0xfffff
    800028d6:	f7a080e7          	jalr	-134(ra) # 8000184c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800028da:	86ce                	mv	a3,s3
    800028dc:	864a                	mv	a2,s2
    800028de:	85a6                	mv	a1,s1
    800028e0:	6928                	ld	a0,80(a0)
    800028e2:	fffff097          	auipc	ra,0xfffff
    800028e6:	db4080e7          	jalr	-588(ra) # 80001696 <copyinstr>
  if(err < 0)
    800028ea:	00054763          	bltz	a0,800028f8 <fetchstr+0x3a>
  return strlen(buf);
    800028ee:	8526                	mv	a0,s1
    800028f0:	ffffe097          	auipc	ra,0xffffe
    800028f4:	446080e7          	jalr	1094(ra) # 80000d36 <strlen>
}
    800028f8:	70a2                	ld	ra,40(sp)
    800028fa:	7402                	ld	s0,32(sp)
    800028fc:	64e2                	ld	s1,24(sp)
    800028fe:	6942                	ld	s2,16(sp)
    80002900:	69a2                	ld	s3,8(sp)
    80002902:	6145                	addi	sp,sp,48
    80002904:	8082                	ret

0000000080002906 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002906:	1101                	addi	sp,sp,-32
    80002908:	ec06                	sd	ra,24(sp)
    8000290a:	e822                	sd	s0,16(sp)
    8000290c:	e426                	sd	s1,8(sp)
    8000290e:	1000                	addi	s0,sp,32
    80002910:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002912:	00000097          	auipc	ra,0x0
    80002916:	ef2080e7          	jalr	-270(ra) # 80002804 <argraw>
    8000291a:	c088                	sw	a0,0(s1)
  return 0;
}
    8000291c:	4501                	li	a0,0
    8000291e:	60e2                	ld	ra,24(sp)
    80002920:	6442                	ld	s0,16(sp)
    80002922:	64a2                	ld	s1,8(sp)
    80002924:	6105                	addi	sp,sp,32
    80002926:	8082                	ret

0000000080002928 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002928:	1101                	addi	sp,sp,-32
    8000292a:	ec06                	sd	ra,24(sp)
    8000292c:	e822                	sd	s0,16(sp)
    8000292e:	e426                	sd	s1,8(sp)
    80002930:	1000                	addi	s0,sp,32
    80002932:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002934:	00000097          	auipc	ra,0x0
    80002938:	ed0080e7          	jalr	-304(ra) # 80002804 <argraw>
    8000293c:	e088                	sd	a0,0(s1)
  return 0;
}
    8000293e:	4501                	li	a0,0
    80002940:	60e2                	ld	ra,24(sp)
    80002942:	6442                	ld	s0,16(sp)
    80002944:	64a2                	ld	s1,8(sp)
    80002946:	6105                	addi	sp,sp,32
    80002948:	8082                	ret

000000008000294a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000294a:	1101                	addi	sp,sp,-32
    8000294c:	ec06                	sd	ra,24(sp)
    8000294e:	e822                	sd	s0,16(sp)
    80002950:	e426                	sd	s1,8(sp)
    80002952:	e04a                	sd	s2,0(sp)
    80002954:	1000                	addi	s0,sp,32
    80002956:	84ae                	mv	s1,a1
    80002958:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000295a:	00000097          	auipc	ra,0x0
    8000295e:	eaa080e7          	jalr	-342(ra) # 80002804 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002962:	864a                	mv	a2,s2
    80002964:	85a6                	mv	a1,s1
    80002966:	00000097          	auipc	ra,0x0
    8000296a:	f58080e7          	jalr	-168(ra) # 800028be <fetchstr>
}
    8000296e:	60e2                	ld	ra,24(sp)
    80002970:	6442                	ld	s0,16(sp)
    80002972:	64a2                	ld	s1,8(sp)
    80002974:	6902                	ld	s2,0(sp)
    80002976:	6105                	addi	sp,sp,32
    80002978:	8082                	ret

000000008000297a <syscall>:
[SYS_crash]   sys_crash,
};

void
syscall(void)
{
    8000297a:	1101                	addi	sp,sp,-32
    8000297c:	ec06                	sd	ra,24(sp)
    8000297e:	e822                	sd	s0,16(sp)
    80002980:	e426                	sd	s1,8(sp)
    80002982:	e04a                	sd	s2,0(sp)
    80002984:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002986:	fffff097          	auipc	ra,0xfffff
    8000298a:	ec6080e7          	jalr	-314(ra) # 8000184c <myproc>
    8000298e:	84aa                	mv	s1,a0

  num = p->tf->a7;
    80002990:	05853903          	ld	s2,88(a0)
    80002994:	0a893783          	ld	a5,168(s2)
    80002998:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000299c:	37fd                	addiw	a5,a5,-1
    8000299e:	4759                	li	a4,22
    800029a0:	00f76f63          	bltu	a4,a5,800029be <syscall+0x44>
    800029a4:	00369713          	slli	a4,a3,0x3
    800029a8:	00005797          	auipc	a5,0x5
    800029ac:	fb078793          	addi	a5,a5,-80 # 80007958 <syscalls>
    800029b0:	97ba                	add	a5,a5,a4
    800029b2:	639c                	ld	a5,0(a5)
    800029b4:	c789                	beqz	a5,800029be <syscall+0x44>
    p->tf->a0 = syscalls[num]();
    800029b6:	9782                	jalr	a5
    800029b8:	06a93823          	sd	a0,112(s2)
    800029bc:	a839                	j	800029da <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800029be:	15848613          	addi	a2,s1,344
    800029c2:	5c8c                	lw	a1,56(s1)
    800029c4:	00005517          	auipc	a0,0x5
    800029c8:	adc50513          	addi	a0,a0,-1316 # 800074a0 <userret+0x410>
    800029cc:	ffffe097          	auipc	ra,0xffffe
    800029d0:	bcc080e7          	jalr	-1076(ra) # 80000598 <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
    800029d4:	6cbc                	ld	a5,88(s1)
    800029d6:	577d                	li	a4,-1
    800029d8:	fbb8                	sd	a4,112(a5)
  }
}
    800029da:	60e2                	ld	ra,24(sp)
    800029dc:	6442                	ld	s0,16(sp)
    800029de:	64a2                	ld	s1,8(sp)
    800029e0:	6902                	ld	s2,0(sp)
    800029e2:	6105                	addi	sp,sp,32
    800029e4:	8082                	ret

00000000800029e6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800029e6:	1101                	addi	sp,sp,-32
    800029e8:	ec06                	sd	ra,24(sp)
    800029ea:	e822                	sd	s0,16(sp)
    800029ec:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800029ee:	fec40593          	addi	a1,s0,-20
    800029f2:	4501                	li	a0,0
    800029f4:	00000097          	auipc	ra,0x0
    800029f8:	f12080e7          	jalr	-238(ra) # 80002906 <argint>
    return -1;
    800029fc:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800029fe:	00054963          	bltz	a0,80002a10 <sys_exit+0x2a>
  exit(n);
    80002a02:	fec42503          	lw	a0,-20(s0)
    80002a06:	fffff097          	auipc	ra,0xfffff
    80002a0a:	536080e7          	jalr	1334(ra) # 80001f3c <exit>
  return 0;  // not reached
    80002a0e:	4781                	li	a5,0
}
    80002a10:	853e                	mv	a0,a5
    80002a12:	60e2                	ld	ra,24(sp)
    80002a14:	6442                	ld	s0,16(sp)
    80002a16:	6105                	addi	sp,sp,32
    80002a18:	8082                	ret

0000000080002a1a <sys_getpid>:

uint64
sys_getpid(void)
{
    80002a1a:	1141                	addi	sp,sp,-16
    80002a1c:	e406                	sd	ra,8(sp)
    80002a1e:	e022                	sd	s0,0(sp)
    80002a20:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002a22:	fffff097          	auipc	ra,0xfffff
    80002a26:	e2a080e7          	jalr	-470(ra) # 8000184c <myproc>
}
    80002a2a:	5d08                	lw	a0,56(a0)
    80002a2c:	60a2                	ld	ra,8(sp)
    80002a2e:	6402                	ld	s0,0(sp)
    80002a30:	0141                	addi	sp,sp,16
    80002a32:	8082                	ret

0000000080002a34 <sys_fork>:

uint64
sys_fork(void)
{
    80002a34:	1141                	addi	sp,sp,-16
    80002a36:	e406                	sd	ra,8(sp)
    80002a38:	e022                	sd	s0,0(sp)
    80002a3a:	0800                	addi	s0,sp,16
  return fork();
    80002a3c:	fffff097          	auipc	ra,0xfffff
    80002a40:	17e080e7          	jalr	382(ra) # 80001bba <fork>
}
    80002a44:	60a2                	ld	ra,8(sp)
    80002a46:	6402                	ld	s0,0(sp)
    80002a48:	0141                	addi	sp,sp,16
    80002a4a:	8082                	ret

0000000080002a4c <sys_wait>:

uint64
sys_wait(void)
{
    80002a4c:	1101                	addi	sp,sp,-32
    80002a4e:	ec06                	sd	ra,24(sp)
    80002a50:	e822                	sd	s0,16(sp)
    80002a52:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002a54:	fe840593          	addi	a1,s0,-24
    80002a58:	4501                	li	a0,0
    80002a5a:	00000097          	auipc	ra,0x0
    80002a5e:	ece080e7          	jalr	-306(ra) # 80002928 <argaddr>
    80002a62:	87aa                	mv	a5,a0
    return -1;
    80002a64:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002a66:	0007c863          	bltz	a5,80002a76 <sys_wait+0x2a>
  return wait(p);
    80002a6a:	fe843503          	ld	a0,-24(s0)
    80002a6e:	fffff097          	auipc	ra,0xfffff
    80002a72:	66e080e7          	jalr	1646(ra) # 800020dc <wait>
}
    80002a76:	60e2                	ld	ra,24(sp)
    80002a78:	6442                	ld	s0,16(sp)
    80002a7a:	6105                	addi	sp,sp,32
    80002a7c:	8082                	ret

0000000080002a7e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002a7e:	7179                	addi	sp,sp,-48
    80002a80:	f406                	sd	ra,40(sp)
    80002a82:	f022                	sd	s0,32(sp)
    80002a84:	ec26                	sd	s1,24(sp)
    80002a86:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002a88:	fdc40593          	addi	a1,s0,-36
    80002a8c:	4501                	li	a0,0
    80002a8e:	00000097          	auipc	ra,0x0
    80002a92:	e78080e7          	jalr	-392(ra) # 80002906 <argint>
    80002a96:	87aa                	mv	a5,a0
    return -1;
    80002a98:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002a9a:	0207c063          	bltz	a5,80002aba <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002a9e:	fffff097          	auipc	ra,0xfffff
    80002aa2:	dae080e7          	jalr	-594(ra) # 8000184c <myproc>
    80002aa6:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002aa8:	fdc42503          	lw	a0,-36(s0)
    80002aac:	fffff097          	auipc	ra,0xfffff
    80002ab0:	096080e7          	jalr	150(ra) # 80001b42 <growproc>
    80002ab4:	00054863          	bltz	a0,80002ac4 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002ab8:	8526                	mv	a0,s1
}
    80002aba:	70a2                	ld	ra,40(sp)
    80002abc:	7402                	ld	s0,32(sp)
    80002abe:	64e2                	ld	s1,24(sp)
    80002ac0:	6145                	addi	sp,sp,48
    80002ac2:	8082                	ret
    return -1;
    80002ac4:	557d                	li	a0,-1
    80002ac6:	bfd5                	j	80002aba <sys_sbrk+0x3c>

0000000080002ac8 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002ac8:	7139                	addi	sp,sp,-64
    80002aca:	fc06                	sd	ra,56(sp)
    80002acc:	f822                	sd	s0,48(sp)
    80002ace:	f426                	sd	s1,40(sp)
    80002ad0:	f04a                	sd	s2,32(sp)
    80002ad2:	ec4e                	sd	s3,24(sp)
    80002ad4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002ad6:	fcc40593          	addi	a1,s0,-52
    80002ada:	4501                	li	a0,0
    80002adc:	00000097          	auipc	ra,0x0
    80002ae0:	e2a080e7          	jalr	-470(ra) # 80002906 <argint>
    return -1;
    80002ae4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002ae6:	06054563          	bltz	a0,80002b50 <sys_sleep+0x88>
  acquire(&tickslock);
    80002aea:	00015517          	auipc	a0,0x15
    80002aee:	c1650513          	addi	a0,a0,-1002 # 80017700 <tickslock>
    80002af2:	ffffe097          	auipc	ra,0xffffe
    80002af6:	ff8080e7          	jalr	-8(ra) # 80000aea <acquire>
  ticks0 = ticks;
    80002afa:	00026917          	auipc	s2,0x26
    80002afe:	54692903          	lw	s2,1350(s2) # 80029040 <ticks>
  while(ticks - ticks0 < n){
    80002b02:	fcc42783          	lw	a5,-52(s0)
    80002b06:	cf85                	beqz	a5,80002b3e <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002b08:	00015997          	auipc	s3,0x15
    80002b0c:	bf898993          	addi	s3,s3,-1032 # 80017700 <tickslock>
    80002b10:	00026497          	auipc	s1,0x26
    80002b14:	53048493          	addi	s1,s1,1328 # 80029040 <ticks>
    if(myproc()->killed){
    80002b18:	fffff097          	auipc	ra,0xfffff
    80002b1c:	d34080e7          	jalr	-716(ra) # 8000184c <myproc>
    80002b20:	591c                	lw	a5,48(a0)
    80002b22:	ef9d                	bnez	a5,80002b60 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002b24:	85ce                	mv	a1,s3
    80002b26:	8526                	mv	a0,s1
    80002b28:	fffff097          	auipc	ra,0xfffff
    80002b2c:	536080e7          	jalr	1334(ra) # 8000205e <sleep>
  while(ticks - ticks0 < n){
    80002b30:	409c                	lw	a5,0(s1)
    80002b32:	412787bb          	subw	a5,a5,s2
    80002b36:	fcc42703          	lw	a4,-52(s0)
    80002b3a:	fce7efe3          	bltu	a5,a4,80002b18 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002b3e:	00015517          	auipc	a0,0x15
    80002b42:	bc250513          	addi	a0,a0,-1086 # 80017700 <tickslock>
    80002b46:	ffffe097          	auipc	ra,0xffffe
    80002b4a:	00c080e7          	jalr	12(ra) # 80000b52 <release>
  return 0;
    80002b4e:	4781                	li	a5,0
}
    80002b50:	853e                	mv	a0,a5
    80002b52:	70e2                	ld	ra,56(sp)
    80002b54:	7442                	ld	s0,48(sp)
    80002b56:	74a2                	ld	s1,40(sp)
    80002b58:	7902                	ld	s2,32(sp)
    80002b5a:	69e2                	ld	s3,24(sp)
    80002b5c:	6121                	addi	sp,sp,64
    80002b5e:	8082                	ret
      release(&tickslock);
    80002b60:	00015517          	auipc	a0,0x15
    80002b64:	ba050513          	addi	a0,a0,-1120 # 80017700 <tickslock>
    80002b68:	ffffe097          	auipc	ra,0xffffe
    80002b6c:	fea080e7          	jalr	-22(ra) # 80000b52 <release>
      return -1;
    80002b70:	57fd                	li	a5,-1
    80002b72:	bff9                	j	80002b50 <sys_sleep+0x88>

0000000080002b74 <sys_kill>:

uint64
sys_kill(void)
{
    80002b74:	1101                	addi	sp,sp,-32
    80002b76:	ec06                	sd	ra,24(sp)
    80002b78:	e822                	sd	s0,16(sp)
    80002b7a:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002b7c:	fec40593          	addi	a1,s0,-20
    80002b80:	4501                	li	a0,0
    80002b82:	00000097          	auipc	ra,0x0
    80002b86:	d84080e7          	jalr	-636(ra) # 80002906 <argint>
    80002b8a:	87aa                	mv	a5,a0
    return -1;
    80002b8c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002b8e:	0007c863          	bltz	a5,80002b9e <sys_kill+0x2a>
  return kill(pid);
    80002b92:	fec42503          	lw	a0,-20(s0)
    80002b96:	fffff097          	auipc	ra,0xfffff
    80002b9a:	6b8080e7          	jalr	1720(ra) # 8000224e <kill>
}
    80002b9e:	60e2                	ld	ra,24(sp)
    80002ba0:	6442                	ld	s0,16(sp)
    80002ba2:	6105                	addi	sp,sp,32
    80002ba4:	8082                	ret

0000000080002ba6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002ba6:	1101                	addi	sp,sp,-32
    80002ba8:	ec06                	sd	ra,24(sp)
    80002baa:	e822                	sd	s0,16(sp)
    80002bac:	e426                	sd	s1,8(sp)
    80002bae:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002bb0:	00015517          	auipc	a0,0x15
    80002bb4:	b5050513          	addi	a0,a0,-1200 # 80017700 <tickslock>
    80002bb8:	ffffe097          	auipc	ra,0xffffe
    80002bbc:	f32080e7          	jalr	-206(ra) # 80000aea <acquire>
  xticks = ticks;
    80002bc0:	00026497          	auipc	s1,0x26
    80002bc4:	4804a483          	lw	s1,1152(s1) # 80029040 <ticks>
  release(&tickslock);
    80002bc8:	00015517          	auipc	a0,0x15
    80002bcc:	b3850513          	addi	a0,a0,-1224 # 80017700 <tickslock>
    80002bd0:	ffffe097          	auipc	ra,0xffffe
    80002bd4:	f82080e7          	jalr	-126(ra) # 80000b52 <release>
  return xticks;
}
    80002bd8:	02049513          	slli	a0,s1,0x20
    80002bdc:	9101                	srli	a0,a0,0x20
    80002bde:	60e2                	ld	ra,24(sp)
    80002be0:	6442                	ld	s0,16(sp)
    80002be2:	64a2                	ld	s1,8(sp)
    80002be4:	6105                	addi	sp,sp,32
    80002be6:	8082                	ret

0000000080002be8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002be8:	7179                	addi	sp,sp,-48
    80002bea:	f406                	sd	ra,40(sp)
    80002bec:	f022                	sd	s0,32(sp)
    80002bee:	ec26                	sd	s1,24(sp)
    80002bf0:	e84a                	sd	s2,16(sp)
    80002bf2:	e44e                	sd	s3,8(sp)
    80002bf4:	e052                	sd	s4,0(sp)
    80002bf6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002bf8:	00005597          	auipc	a1,0x5
    80002bfc:	8c858593          	addi	a1,a1,-1848 # 800074c0 <userret+0x430>
    80002c00:	00015517          	auipc	a0,0x15
    80002c04:	b1850513          	addi	a0,a0,-1256 # 80017718 <bcache>
    80002c08:	ffffe097          	auipc	ra,0xffffe
    80002c0c:	dd0080e7          	jalr	-560(ra) # 800009d8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002c10:	0001d797          	auipc	a5,0x1d
    80002c14:	b0878793          	addi	a5,a5,-1272 # 8001f718 <bcache+0x8000>
    80002c18:	0001d717          	auipc	a4,0x1d
    80002c1c:	e5870713          	addi	a4,a4,-424 # 8001fa70 <bcache+0x8358>
    80002c20:	3ae7b023          	sd	a4,928(a5)
  bcache.head.next = &bcache.head;
    80002c24:	3ae7b423          	sd	a4,936(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c28:	00015497          	auipc	s1,0x15
    80002c2c:	b0848493          	addi	s1,s1,-1272 # 80017730 <bcache+0x18>
    b->next = bcache.head.next;
    80002c30:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002c32:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002c34:	00005a17          	auipc	s4,0x5
    80002c38:	894a0a13          	addi	s4,s4,-1900 # 800074c8 <userret+0x438>
    b->next = bcache.head.next;
    80002c3c:	3a893783          	ld	a5,936(s2)
    80002c40:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002c42:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002c46:	85d2                	mv	a1,s4
    80002c48:	01048513          	addi	a0,s1,16
    80002c4c:	00001097          	auipc	ra,0x1
    80002c50:	6f2080e7          	jalr	1778(ra) # 8000433e <initsleeplock>
    bcache.head.next->prev = b;
    80002c54:	3a893783          	ld	a5,936(s2)
    80002c58:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002c5a:	3a993423          	sd	s1,936(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c5e:	46048493          	addi	s1,s1,1120
    80002c62:	fd349de3          	bne	s1,s3,80002c3c <binit+0x54>
  }
}
    80002c66:	70a2                	ld	ra,40(sp)
    80002c68:	7402                	ld	s0,32(sp)
    80002c6a:	64e2                	ld	s1,24(sp)
    80002c6c:	6942                	ld	s2,16(sp)
    80002c6e:	69a2                	ld	s3,8(sp)
    80002c70:	6a02                	ld	s4,0(sp)
    80002c72:	6145                	addi	sp,sp,48
    80002c74:	8082                	ret

0000000080002c76 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002c76:	7179                	addi	sp,sp,-48
    80002c78:	f406                	sd	ra,40(sp)
    80002c7a:	f022                	sd	s0,32(sp)
    80002c7c:	ec26                	sd	s1,24(sp)
    80002c7e:	e84a                	sd	s2,16(sp)
    80002c80:	e44e                	sd	s3,8(sp)
    80002c82:	1800                	addi	s0,sp,48
    80002c84:	89aa                	mv	s3,a0
    80002c86:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002c88:	00015517          	auipc	a0,0x15
    80002c8c:	a9050513          	addi	a0,a0,-1392 # 80017718 <bcache>
    80002c90:	ffffe097          	auipc	ra,0xffffe
    80002c94:	e5a080e7          	jalr	-422(ra) # 80000aea <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002c98:	0001d497          	auipc	s1,0x1d
    80002c9c:	e284b483          	ld	s1,-472(s1) # 8001fac0 <bcache+0x83a8>
    80002ca0:	0001d797          	auipc	a5,0x1d
    80002ca4:	dd078793          	addi	a5,a5,-560 # 8001fa70 <bcache+0x8358>
    80002ca8:	02f48f63          	beq	s1,a5,80002ce6 <bread+0x70>
    80002cac:	873e                	mv	a4,a5
    80002cae:	a021                	j	80002cb6 <bread+0x40>
    80002cb0:	68a4                	ld	s1,80(s1)
    80002cb2:	02e48a63          	beq	s1,a4,80002ce6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002cb6:	449c                	lw	a5,8(s1)
    80002cb8:	ff379ce3          	bne	a5,s3,80002cb0 <bread+0x3a>
    80002cbc:	44dc                	lw	a5,12(s1)
    80002cbe:	ff2799e3          	bne	a5,s2,80002cb0 <bread+0x3a>
      b->refcnt++;
    80002cc2:	40bc                	lw	a5,64(s1)
    80002cc4:	2785                	addiw	a5,a5,1
    80002cc6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002cc8:	00015517          	auipc	a0,0x15
    80002ccc:	a5050513          	addi	a0,a0,-1456 # 80017718 <bcache>
    80002cd0:	ffffe097          	auipc	ra,0xffffe
    80002cd4:	e82080e7          	jalr	-382(ra) # 80000b52 <release>
      acquiresleep(&b->lock);
    80002cd8:	01048513          	addi	a0,s1,16
    80002cdc:	00001097          	auipc	ra,0x1
    80002ce0:	69c080e7          	jalr	1692(ra) # 80004378 <acquiresleep>
      return b;
    80002ce4:	a8b9                	j	80002d42 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002ce6:	0001d497          	auipc	s1,0x1d
    80002cea:	dd24b483          	ld	s1,-558(s1) # 8001fab8 <bcache+0x83a0>
    80002cee:	0001d797          	auipc	a5,0x1d
    80002cf2:	d8278793          	addi	a5,a5,-638 # 8001fa70 <bcache+0x8358>
    80002cf6:	00f48863          	beq	s1,a5,80002d06 <bread+0x90>
    80002cfa:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002cfc:	40bc                	lw	a5,64(s1)
    80002cfe:	cf81                	beqz	a5,80002d16 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d00:	64a4                	ld	s1,72(s1)
    80002d02:	fee49de3          	bne	s1,a4,80002cfc <bread+0x86>
  panic("bget: no buffers");
    80002d06:	00004517          	auipc	a0,0x4
    80002d0a:	7ca50513          	addi	a0,a0,1994 # 800074d0 <userret+0x440>
    80002d0e:	ffffe097          	auipc	ra,0xffffe
    80002d12:	840080e7          	jalr	-1984(ra) # 8000054e <panic>
      b->dev = dev;
    80002d16:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002d1a:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002d1e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002d22:	4785                	li	a5,1
    80002d24:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d26:	00015517          	auipc	a0,0x15
    80002d2a:	9f250513          	addi	a0,a0,-1550 # 80017718 <bcache>
    80002d2e:	ffffe097          	auipc	ra,0xffffe
    80002d32:	e24080e7          	jalr	-476(ra) # 80000b52 <release>
      acquiresleep(&b->lock);
    80002d36:	01048513          	addi	a0,s1,16
    80002d3a:	00001097          	auipc	ra,0x1
    80002d3e:	63e080e7          	jalr	1598(ra) # 80004378 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002d42:	409c                	lw	a5,0(s1)
    80002d44:	cb89                	beqz	a5,80002d56 <bread+0xe0>
    virtio_disk_rw(b->dev, b, 0);
    b->valid = 1;
  }
  return b;
}
    80002d46:	8526                	mv	a0,s1
    80002d48:	70a2                	ld	ra,40(sp)
    80002d4a:	7402                	ld	s0,32(sp)
    80002d4c:	64e2                	ld	s1,24(sp)
    80002d4e:	6942                	ld	s2,16(sp)
    80002d50:	69a2                	ld	s3,8(sp)
    80002d52:	6145                	addi	sp,sp,48
    80002d54:	8082                	ret
    virtio_disk_rw(b->dev, b, 0);
    80002d56:	4601                	li	a2,0
    80002d58:	85a6                	mv	a1,s1
    80002d5a:	4488                	lw	a0,8(s1)
    80002d5c:	00003097          	auipc	ra,0x3
    80002d60:	280080e7          	jalr	640(ra) # 80005fdc <virtio_disk_rw>
    b->valid = 1;
    80002d64:	4785                	li	a5,1
    80002d66:	c09c                	sw	a5,0(s1)
  return b;
    80002d68:	bff9                	j	80002d46 <bread+0xd0>

0000000080002d6a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002d6a:	1101                	addi	sp,sp,-32
    80002d6c:	ec06                	sd	ra,24(sp)
    80002d6e:	e822                	sd	s0,16(sp)
    80002d70:	e426                	sd	s1,8(sp)
    80002d72:	1000                	addi	s0,sp,32
    80002d74:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d76:	0541                	addi	a0,a0,16
    80002d78:	00001097          	auipc	ra,0x1
    80002d7c:	69a080e7          	jalr	1690(ra) # 80004412 <holdingsleep>
    80002d80:	cd09                	beqz	a0,80002d9a <bwrite+0x30>
    panic("bwrite");
  virtio_disk_rw(b->dev, b, 1);
    80002d82:	4605                	li	a2,1
    80002d84:	85a6                	mv	a1,s1
    80002d86:	4488                	lw	a0,8(s1)
    80002d88:	00003097          	auipc	ra,0x3
    80002d8c:	254080e7          	jalr	596(ra) # 80005fdc <virtio_disk_rw>
}
    80002d90:	60e2                	ld	ra,24(sp)
    80002d92:	6442                	ld	s0,16(sp)
    80002d94:	64a2                	ld	s1,8(sp)
    80002d96:	6105                	addi	sp,sp,32
    80002d98:	8082                	ret
    panic("bwrite");
    80002d9a:	00004517          	auipc	a0,0x4
    80002d9e:	74e50513          	addi	a0,a0,1870 # 800074e8 <userret+0x458>
    80002da2:	ffffd097          	auipc	ra,0xffffd
    80002da6:	7ac080e7          	jalr	1964(ra) # 8000054e <panic>

0000000080002daa <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
    80002daa:	1101                	addi	sp,sp,-32
    80002dac:	ec06                	sd	ra,24(sp)
    80002dae:	e822                	sd	s0,16(sp)
    80002db0:	e426                	sd	s1,8(sp)
    80002db2:	e04a                	sd	s2,0(sp)
    80002db4:	1000                	addi	s0,sp,32
    80002db6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002db8:	01050913          	addi	s2,a0,16
    80002dbc:	854a                	mv	a0,s2
    80002dbe:	00001097          	auipc	ra,0x1
    80002dc2:	654080e7          	jalr	1620(ra) # 80004412 <holdingsleep>
    80002dc6:	c92d                	beqz	a0,80002e38 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002dc8:	854a                	mv	a0,s2
    80002dca:	00001097          	auipc	ra,0x1
    80002dce:	604080e7          	jalr	1540(ra) # 800043ce <releasesleep>

  acquire(&bcache.lock);
    80002dd2:	00015517          	auipc	a0,0x15
    80002dd6:	94650513          	addi	a0,a0,-1722 # 80017718 <bcache>
    80002dda:	ffffe097          	auipc	ra,0xffffe
    80002dde:	d10080e7          	jalr	-752(ra) # 80000aea <acquire>
  b->refcnt--;
    80002de2:	40bc                	lw	a5,64(s1)
    80002de4:	37fd                	addiw	a5,a5,-1
    80002de6:	0007871b          	sext.w	a4,a5
    80002dea:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002dec:	eb05                	bnez	a4,80002e1c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002dee:	68bc                	ld	a5,80(s1)
    80002df0:	64b8                	ld	a4,72(s1)
    80002df2:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002df4:	64bc                	ld	a5,72(s1)
    80002df6:	68b8                	ld	a4,80(s1)
    80002df8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002dfa:	0001d797          	auipc	a5,0x1d
    80002dfe:	91e78793          	addi	a5,a5,-1762 # 8001f718 <bcache+0x8000>
    80002e02:	3a87b703          	ld	a4,936(a5)
    80002e06:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002e08:	0001d717          	auipc	a4,0x1d
    80002e0c:	c6870713          	addi	a4,a4,-920 # 8001fa70 <bcache+0x8358>
    80002e10:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002e12:	3a87b703          	ld	a4,936(a5)
    80002e16:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002e18:	3a97b423          	sd	s1,936(a5)
  }
  
  release(&bcache.lock);
    80002e1c:	00015517          	auipc	a0,0x15
    80002e20:	8fc50513          	addi	a0,a0,-1796 # 80017718 <bcache>
    80002e24:	ffffe097          	auipc	ra,0xffffe
    80002e28:	d2e080e7          	jalr	-722(ra) # 80000b52 <release>
}
    80002e2c:	60e2                	ld	ra,24(sp)
    80002e2e:	6442                	ld	s0,16(sp)
    80002e30:	64a2                	ld	s1,8(sp)
    80002e32:	6902                	ld	s2,0(sp)
    80002e34:	6105                	addi	sp,sp,32
    80002e36:	8082                	ret
    panic("brelse");
    80002e38:	00004517          	auipc	a0,0x4
    80002e3c:	6b850513          	addi	a0,a0,1720 # 800074f0 <userret+0x460>
    80002e40:	ffffd097          	auipc	ra,0xffffd
    80002e44:	70e080e7          	jalr	1806(ra) # 8000054e <panic>

0000000080002e48 <bpin>:

void
bpin(struct buf *b) {
    80002e48:	1101                	addi	sp,sp,-32
    80002e4a:	ec06                	sd	ra,24(sp)
    80002e4c:	e822                	sd	s0,16(sp)
    80002e4e:	e426                	sd	s1,8(sp)
    80002e50:	1000                	addi	s0,sp,32
    80002e52:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e54:	00015517          	auipc	a0,0x15
    80002e58:	8c450513          	addi	a0,a0,-1852 # 80017718 <bcache>
    80002e5c:	ffffe097          	auipc	ra,0xffffe
    80002e60:	c8e080e7          	jalr	-882(ra) # 80000aea <acquire>
  b->refcnt++;
    80002e64:	40bc                	lw	a5,64(s1)
    80002e66:	2785                	addiw	a5,a5,1
    80002e68:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e6a:	00015517          	auipc	a0,0x15
    80002e6e:	8ae50513          	addi	a0,a0,-1874 # 80017718 <bcache>
    80002e72:	ffffe097          	auipc	ra,0xffffe
    80002e76:	ce0080e7          	jalr	-800(ra) # 80000b52 <release>
}
    80002e7a:	60e2                	ld	ra,24(sp)
    80002e7c:	6442                	ld	s0,16(sp)
    80002e7e:	64a2                	ld	s1,8(sp)
    80002e80:	6105                	addi	sp,sp,32
    80002e82:	8082                	ret

0000000080002e84 <bunpin>:

void
bunpin(struct buf *b) {
    80002e84:	1101                	addi	sp,sp,-32
    80002e86:	ec06                	sd	ra,24(sp)
    80002e88:	e822                	sd	s0,16(sp)
    80002e8a:	e426                	sd	s1,8(sp)
    80002e8c:	1000                	addi	s0,sp,32
    80002e8e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e90:	00015517          	auipc	a0,0x15
    80002e94:	88850513          	addi	a0,a0,-1912 # 80017718 <bcache>
    80002e98:	ffffe097          	auipc	ra,0xffffe
    80002e9c:	c52080e7          	jalr	-942(ra) # 80000aea <acquire>
  b->refcnt--;
    80002ea0:	40bc                	lw	a5,64(s1)
    80002ea2:	37fd                	addiw	a5,a5,-1
    80002ea4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002ea6:	00015517          	auipc	a0,0x15
    80002eaa:	87250513          	addi	a0,a0,-1934 # 80017718 <bcache>
    80002eae:	ffffe097          	auipc	ra,0xffffe
    80002eb2:	ca4080e7          	jalr	-860(ra) # 80000b52 <release>
}
    80002eb6:	60e2                	ld	ra,24(sp)
    80002eb8:	6442                	ld	s0,16(sp)
    80002eba:	64a2                	ld	s1,8(sp)
    80002ebc:	6105                	addi	sp,sp,32
    80002ebe:	8082                	ret

0000000080002ec0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002ec0:	1101                	addi	sp,sp,-32
    80002ec2:	ec06                	sd	ra,24(sp)
    80002ec4:	e822                	sd	s0,16(sp)
    80002ec6:	e426                	sd	s1,8(sp)
    80002ec8:	e04a                	sd	s2,0(sp)
    80002eca:	1000                	addi	s0,sp,32
    80002ecc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002ece:	00d5d59b          	srliw	a1,a1,0xd
    80002ed2:	0001d797          	auipc	a5,0x1d
    80002ed6:	01a7a783          	lw	a5,26(a5) # 8001feec <sb+0x1c>
    80002eda:	9dbd                	addw	a1,a1,a5
    80002edc:	00000097          	auipc	ra,0x0
    80002ee0:	d9a080e7          	jalr	-614(ra) # 80002c76 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002ee4:	0074f713          	andi	a4,s1,7
    80002ee8:	4785                	li	a5,1
    80002eea:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002eee:	14ce                	slli	s1,s1,0x33
    80002ef0:	90d9                	srli	s1,s1,0x36
    80002ef2:	00950733          	add	a4,a0,s1
    80002ef6:	06074703          	lbu	a4,96(a4)
    80002efa:	00e7f6b3          	and	a3,a5,a4
    80002efe:	c69d                	beqz	a3,80002f2c <bfree+0x6c>
    80002f00:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002f02:	94aa                	add	s1,s1,a0
    80002f04:	fff7c793          	not	a5,a5
    80002f08:	8ff9                	and	a5,a5,a4
    80002f0a:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    80002f0e:	00001097          	auipc	ra,0x1
    80002f12:	1d2080e7          	jalr	466(ra) # 800040e0 <log_write>
  brelse(bp);
    80002f16:	854a                	mv	a0,s2
    80002f18:	00000097          	auipc	ra,0x0
    80002f1c:	e92080e7          	jalr	-366(ra) # 80002daa <brelse>
}
    80002f20:	60e2                	ld	ra,24(sp)
    80002f22:	6442                	ld	s0,16(sp)
    80002f24:	64a2                	ld	s1,8(sp)
    80002f26:	6902                	ld	s2,0(sp)
    80002f28:	6105                	addi	sp,sp,32
    80002f2a:	8082                	ret
    panic("freeing free block");
    80002f2c:	00004517          	auipc	a0,0x4
    80002f30:	5cc50513          	addi	a0,a0,1484 # 800074f8 <userret+0x468>
    80002f34:	ffffd097          	auipc	ra,0xffffd
    80002f38:	61a080e7          	jalr	1562(ra) # 8000054e <panic>

0000000080002f3c <balloc>:
{
    80002f3c:	711d                	addi	sp,sp,-96
    80002f3e:	ec86                	sd	ra,88(sp)
    80002f40:	e8a2                	sd	s0,80(sp)
    80002f42:	e4a6                	sd	s1,72(sp)
    80002f44:	e0ca                	sd	s2,64(sp)
    80002f46:	fc4e                	sd	s3,56(sp)
    80002f48:	f852                	sd	s4,48(sp)
    80002f4a:	f456                	sd	s5,40(sp)
    80002f4c:	f05a                	sd	s6,32(sp)
    80002f4e:	ec5e                	sd	s7,24(sp)
    80002f50:	e862                	sd	s8,16(sp)
    80002f52:	e466                	sd	s9,8(sp)
    80002f54:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002f56:	0001d797          	auipc	a5,0x1d
    80002f5a:	f7e7a783          	lw	a5,-130(a5) # 8001fed4 <sb+0x4>
    80002f5e:	cbd1                	beqz	a5,80002ff2 <balloc+0xb6>
    80002f60:	8baa                	mv	s7,a0
    80002f62:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002f64:	0001db17          	auipc	s6,0x1d
    80002f68:	f6cb0b13          	addi	s6,s6,-148 # 8001fed0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f6c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002f6e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f70:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002f72:	6c89                	lui	s9,0x2
    80002f74:	a831                	j	80002f90 <balloc+0x54>
    brelse(bp);
    80002f76:	854a                	mv	a0,s2
    80002f78:	00000097          	auipc	ra,0x0
    80002f7c:	e32080e7          	jalr	-462(ra) # 80002daa <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002f80:	015c87bb          	addw	a5,s9,s5
    80002f84:	00078a9b          	sext.w	s5,a5
    80002f88:	004b2703          	lw	a4,4(s6)
    80002f8c:	06eaf363          	bgeu	s5,a4,80002ff2 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002f90:	41fad79b          	sraiw	a5,s5,0x1f
    80002f94:	0137d79b          	srliw	a5,a5,0x13
    80002f98:	015787bb          	addw	a5,a5,s5
    80002f9c:	40d7d79b          	sraiw	a5,a5,0xd
    80002fa0:	01cb2583          	lw	a1,28(s6)
    80002fa4:	9dbd                	addw	a1,a1,a5
    80002fa6:	855e                	mv	a0,s7
    80002fa8:	00000097          	auipc	ra,0x0
    80002fac:	cce080e7          	jalr	-818(ra) # 80002c76 <bread>
    80002fb0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002fb2:	004b2503          	lw	a0,4(s6)
    80002fb6:	000a849b          	sext.w	s1,s5
    80002fba:	8662                	mv	a2,s8
    80002fbc:	faa4fde3          	bgeu	s1,a0,80002f76 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002fc0:	41f6579b          	sraiw	a5,a2,0x1f
    80002fc4:	01d7d69b          	srliw	a3,a5,0x1d
    80002fc8:	00c6873b          	addw	a4,a3,a2
    80002fcc:	00777793          	andi	a5,a4,7
    80002fd0:	9f95                	subw	a5,a5,a3
    80002fd2:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002fd6:	4037571b          	sraiw	a4,a4,0x3
    80002fda:	00e906b3          	add	a3,s2,a4
    80002fde:	0606c683          	lbu	a3,96(a3)
    80002fe2:	00d7f5b3          	and	a1,a5,a3
    80002fe6:	cd91                	beqz	a1,80003002 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002fe8:	2605                	addiw	a2,a2,1
    80002fea:	2485                	addiw	s1,s1,1
    80002fec:	fd4618e3          	bne	a2,s4,80002fbc <balloc+0x80>
    80002ff0:	b759                	j	80002f76 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002ff2:	00004517          	auipc	a0,0x4
    80002ff6:	51e50513          	addi	a0,a0,1310 # 80007510 <userret+0x480>
    80002ffa:	ffffd097          	auipc	ra,0xffffd
    80002ffe:	554080e7          	jalr	1364(ra) # 8000054e <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003002:	974a                	add	a4,a4,s2
    80003004:	8fd5                	or	a5,a5,a3
    80003006:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    8000300a:	854a                	mv	a0,s2
    8000300c:	00001097          	auipc	ra,0x1
    80003010:	0d4080e7          	jalr	212(ra) # 800040e0 <log_write>
        brelse(bp);
    80003014:	854a                	mv	a0,s2
    80003016:	00000097          	auipc	ra,0x0
    8000301a:	d94080e7          	jalr	-620(ra) # 80002daa <brelse>
  bp = bread(dev, bno);
    8000301e:	85a6                	mv	a1,s1
    80003020:	855e                	mv	a0,s7
    80003022:	00000097          	auipc	ra,0x0
    80003026:	c54080e7          	jalr	-940(ra) # 80002c76 <bread>
    8000302a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000302c:	40000613          	li	a2,1024
    80003030:	4581                	li	a1,0
    80003032:	06050513          	addi	a0,a0,96
    80003036:	ffffe097          	auipc	ra,0xffffe
    8000303a:	b78080e7          	jalr	-1160(ra) # 80000bae <memset>
  log_write(bp);
    8000303e:	854a                	mv	a0,s2
    80003040:	00001097          	auipc	ra,0x1
    80003044:	0a0080e7          	jalr	160(ra) # 800040e0 <log_write>
  brelse(bp);
    80003048:	854a                	mv	a0,s2
    8000304a:	00000097          	auipc	ra,0x0
    8000304e:	d60080e7          	jalr	-672(ra) # 80002daa <brelse>
}
    80003052:	8526                	mv	a0,s1
    80003054:	60e6                	ld	ra,88(sp)
    80003056:	6446                	ld	s0,80(sp)
    80003058:	64a6                	ld	s1,72(sp)
    8000305a:	6906                	ld	s2,64(sp)
    8000305c:	79e2                	ld	s3,56(sp)
    8000305e:	7a42                	ld	s4,48(sp)
    80003060:	7aa2                	ld	s5,40(sp)
    80003062:	7b02                	ld	s6,32(sp)
    80003064:	6be2                	ld	s7,24(sp)
    80003066:	6c42                	ld	s8,16(sp)
    80003068:	6ca2                	ld	s9,8(sp)
    8000306a:	6125                	addi	sp,sp,96
    8000306c:	8082                	ret

000000008000306e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000306e:	7179                	addi	sp,sp,-48
    80003070:	f406                	sd	ra,40(sp)
    80003072:	f022                	sd	s0,32(sp)
    80003074:	ec26                	sd	s1,24(sp)
    80003076:	e84a                	sd	s2,16(sp)
    80003078:	e44e                	sd	s3,8(sp)
    8000307a:	e052                	sd	s4,0(sp)
    8000307c:	1800                	addi	s0,sp,48
    8000307e:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003080:	47ad                	li	a5,11
    80003082:	04b7fe63          	bgeu	a5,a1,800030de <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003086:	ff45849b          	addiw	s1,a1,-12
    8000308a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000308e:	0ff00793          	li	a5,255
    80003092:	0ae7e363          	bltu	a5,a4,80003138 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003096:	08052583          	lw	a1,128(a0)
    8000309a:	c5ad                	beqz	a1,80003104 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000309c:	00092503          	lw	a0,0(s2)
    800030a0:	00000097          	auipc	ra,0x0
    800030a4:	bd6080e7          	jalr	-1066(ra) # 80002c76 <bread>
    800030a8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800030aa:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    800030ae:	02049593          	slli	a1,s1,0x20
    800030b2:	9181                	srli	a1,a1,0x20
    800030b4:	058a                	slli	a1,a1,0x2
    800030b6:	00b784b3          	add	s1,a5,a1
    800030ba:	0004a983          	lw	s3,0(s1)
    800030be:	04098d63          	beqz	s3,80003118 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800030c2:	8552                	mv	a0,s4
    800030c4:	00000097          	auipc	ra,0x0
    800030c8:	ce6080e7          	jalr	-794(ra) # 80002daa <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800030cc:	854e                	mv	a0,s3
    800030ce:	70a2                	ld	ra,40(sp)
    800030d0:	7402                	ld	s0,32(sp)
    800030d2:	64e2                	ld	s1,24(sp)
    800030d4:	6942                	ld	s2,16(sp)
    800030d6:	69a2                	ld	s3,8(sp)
    800030d8:	6a02                	ld	s4,0(sp)
    800030da:	6145                	addi	sp,sp,48
    800030dc:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800030de:	02059493          	slli	s1,a1,0x20
    800030e2:	9081                	srli	s1,s1,0x20
    800030e4:	048a                	slli	s1,s1,0x2
    800030e6:	94aa                	add	s1,s1,a0
    800030e8:	0504a983          	lw	s3,80(s1)
    800030ec:	fe0990e3          	bnez	s3,800030cc <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800030f0:	4108                	lw	a0,0(a0)
    800030f2:	00000097          	auipc	ra,0x0
    800030f6:	e4a080e7          	jalr	-438(ra) # 80002f3c <balloc>
    800030fa:	0005099b          	sext.w	s3,a0
    800030fe:	0534a823          	sw	s3,80(s1)
    80003102:	b7e9                	j	800030cc <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003104:	4108                	lw	a0,0(a0)
    80003106:	00000097          	auipc	ra,0x0
    8000310a:	e36080e7          	jalr	-458(ra) # 80002f3c <balloc>
    8000310e:	0005059b          	sext.w	a1,a0
    80003112:	08b92023          	sw	a1,128(s2)
    80003116:	b759                	j	8000309c <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003118:	00092503          	lw	a0,0(s2)
    8000311c:	00000097          	auipc	ra,0x0
    80003120:	e20080e7          	jalr	-480(ra) # 80002f3c <balloc>
    80003124:	0005099b          	sext.w	s3,a0
    80003128:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000312c:	8552                	mv	a0,s4
    8000312e:	00001097          	auipc	ra,0x1
    80003132:	fb2080e7          	jalr	-78(ra) # 800040e0 <log_write>
    80003136:	b771                	j	800030c2 <bmap+0x54>
  panic("bmap: out of range");
    80003138:	00004517          	auipc	a0,0x4
    8000313c:	3f050513          	addi	a0,a0,1008 # 80007528 <userret+0x498>
    80003140:	ffffd097          	auipc	ra,0xffffd
    80003144:	40e080e7          	jalr	1038(ra) # 8000054e <panic>

0000000080003148 <iget>:
{
    80003148:	7179                	addi	sp,sp,-48
    8000314a:	f406                	sd	ra,40(sp)
    8000314c:	f022                	sd	s0,32(sp)
    8000314e:	ec26                	sd	s1,24(sp)
    80003150:	e84a                	sd	s2,16(sp)
    80003152:	e44e                	sd	s3,8(sp)
    80003154:	e052                	sd	s4,0(sp)
    80003156:	1800                	addi	s0,sp,48
    80003158:	89aa                	mv	s3,a0
    8000315a:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    8000315c:	0001d517          	auipc	a0,0x1d
    80003160:	d9450513          	addi	a0,a0,-620 # 8001fef0 <icache>
    80003164:	ffffe097          	auipc	ra,0xffffe
    80003168:	986080e7          	jalr	-1658(ra) # 80000aea <acquire>
  empty = 0;
    8000316c:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000316e:	0001d497          	auipc	s1,0x1d
    80003172:	d9a48493          	addi	s1,s1,-614 # 8001ff08 <icache+0x18>
    80003176:	0001f697          	auipc	a3,0x1f
    8000317a:	82268693          	addi	a3,a3,-2014 # 80021998 <log>
    8000317e:	a039                	j	8000318c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003180:	02090b63          	beqz	s2,800031b6 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003184:	08848493          	addi	s1,s1,136
    80003188:	02d48a63          	beq	s1,a3,800031bc <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000318c:	449c                	lw	a5,8(s1)
    8000318e:	fef059e3          	blez	a5,80003180 <iget+0x38>
    80003192:	4098                	lw	a4,0(s1)
    80003194:	ff3716e3          	bne	a4,s3,80003180 <iget+0x38>
    80003198:	40d8                	lw	a4,4(s1)
    8000319a:	ff4713e3          	bne	a4,s4,80003180 <iget+0x38>
      ip->ref++;
    8000319e:	2785                	addiw	a5,a5,1
    800031a0:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    800031a2:	0001d517          	auipc	a0,0x1d
    800031a6:	d4e50513          	addi	a0,a0,-690 # 8001fef0 <icache>
    800031aa:	ffffe097          	auipc	ra,0xffffe
    800031ae:	9a8080e7          	jalr	-1624(ra) # 80000b52 <release>
      return ip;
    800031b2:	8926                	mv	s2,s1
    800031b4:	a03d                	j	800031e2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800031b6:	f7f9                	bnez	a5,80003184 <iget+0x3c>
    800031b8:	8926                	mv	s2,s1
    800031ba:	b7e9                	j	80003184 <iget+0x3c>
  if(empty == 0)
    800031bc:	02090c63          	beqz	s2,800031f4 <iget+0xac>
  ip->dev = dev;
    800031c0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800031c4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800031c8:	4785                	li	a5,1
    800031ca:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800031ce:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    800031d2:	0001d517          	auipc	a0,0x1d
    800031d6:	d1e50513          	addi	a0,a0,-738 # 8001fef0 <icache>
    800031da:	ffffe097          	auipc	ra,0xffffe
    800031de:	978080e7          	jalr	-1672(ra) # 80000b52 <release>
}
    800031e2:	854a                	mv	a0,s2
    800031e4:	70a2                	ld	ra,40(sp)
    800031e6:	7402                	ld	s0,32(sp)
    800031e8:	64e2                	ld	s1,24(sp)
    800031ea:	6942                	ld	s2,16(sp)
    800031ec:	69a2                	ld	s3,8(sp)
    800031ee:	6a02                	ld	s4,0(sp)
    800031f0:	6145                	addi	sp,sp,48
    800031f2:	8082                	ret
    panic("iget: no inodes");
    800031f4:	00004517          	auipc	a0,0x4
    800031f8:	34c50513          	addi	a0,a0,844 # 80007540 <userret+0x4b0>
    800031fc:	ffffd097          	auipc	ra,0xffffd
    80003200:	352080e7          	jalr	850(ra) # 8000054e <panic>

0000000080003204 <fsinit>:
fsinit(int dev) {
    80003204:	7179                	addi	sp,sp,-48
    80003206:	f406                	sd	ra,40(sp)
    80003208:	f022                	sd	s0,32(sp)
    8000320a:	ec26                	sd	s1,24(sp)
    8000320c:	e84a                	sd	s2,16(sp)
    8000320e:	e44e                	sd	s3,8(sp)
    80003210:	1800                	addi	s0,sp,48
    80003212:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003214:	4585                	li	a1,1
    80003216:	00000097          	auipc	ra,0x0
    8000321a:	a60080e7          	jalr	-1440(ra) # 80002c76 <bread>
    8000321e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003220:	0001d997          	auipc	s3,0x1d
    80003224:	cb098993          	addi	s3,s3,-848 # 8001fed0 <sb>
    80003228:	02000613          	li	a2,32
    8000322c:	06050593          	addi	a1,a0,96
    80003230:	854e                	mv	a0,s3
    80003232:	ffffe097          	auipc	ra,0xffffe
    80003236:	9dc080e7          	jalr	-1572(ra) # 80000c0e <memmove>
  brelse(bp);
    8000323a:	8526                	mv	a0,s1
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	b6e080e7          	jalr	-1170(ra) # 80002daa <brelse>
  if(sb.magic != FSMAGIC)
    80003244:	0009a703          	lw	a4,0(s3)
    80003248:	102037b7          	lui	a5,0x10203
    8000324c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003250:	02f71263          	bne	a4,a5,80003274 <fsinit+0x70>
  initlog(dev, &sb);
    80003254:	0001d597          	auipc	a1,0x1d
    80003258:	c7c58593          	addi	a1,a1,-900 # 8001fed0 <sb>
    8000325c:	854a                	mv	a0,s2
    8000325e:	00001097          	auipc	ra,0x1
    80003262:	bfc080e7          	jalr	-1028(ra) # 80003e5a <initlog>
}
    80003266:	70a2                	ld	ra,40(sp)
    80003268:	7402                	ld	s0,32(sp)
    8000326a:	64e2                	ld	s1,24(sp)
    8000326c:	6942                	ld	s2,16(sp)
    8000326e:	69a2                	ld	s3,8(sp)
    80003270:	6145                	addi	sp,sp,48
    80003272:	8082                	ret
    panic("invalid file system");
    80003274:	00004517          	auipc	a0,0x4
    80003278:	2dc50513          	addi	a0,a0,732 # 80007550 <userret+0x4c0>
    8000327c:	ffffd097          	auipc	ra,0xffffd
    80003280:	2d2080e7          	jalr	722(ra) # 8000054e <panic>

0000000080003284 <iinit>:
{
    80003284:	7179                	addi	sp,sp,-48
    80003286:	f406                	sd	ra,40(sp)
    80003288:	f022                	sd	s0,32(sp)
    8000328a:	ec26                	sd	s1,24(sp)
    8000328c:	e84a                	sd	s2,16(sp)
    8000328e:	e44e                	sd	s3,8(sp)
    80003290:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003292:	00004597          	auipc	a1,0x4
    80003296:	2d658593          	addi	a1,a1,726 # 80007568 <userret+0x4d8>
    8000329a:	0001d517          	auipc	a0,0x1d
    8000329e:	c5650513          	addi	a0,a0,-938 # 8001fef0 <icache>
    800032a2:	ffffd097          	auipc	ra,0xffffd
    800032a6:	736080e7          	jalr	1846(ra) # 800009d8 <initlock>
  for(i = 0; i < NINODE; i++) {
    800032aa:	0001d497          	auipc	s1,0x1d
    800032ae:	c6e48493          	addi	s1,s1,-914 # 8001ff18 <icache+0x28>
    800032b2:	0001e997          	auipc	s3,0x1e
    800032b6:	6f698993          	addi	s3,s3,1782 # 800219a8 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    800032ba:	00004917          	auipc	s2,0x4
    800032be:	2b690913          	addi	s2,s2,694 # 80007570 <userret+0x4e0>
    800032c2:	85ca                	mv	a1,s2
    800032c4:	8526                	mv	a0,s1
    800032c6:	00001097          	auipc	ra,0x1
    800032ca:	078080e7          	jalr	120(ra) # 8000433e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800032ce:	08848493          	addi	s1,s1,136
    800032d2:	ff3498e3          	bne	s1,s3,800032c2 <iinit+0x3e>
}
    800032d6:	70a2                	ld	ra,40(sp)
    800032d8:	7402                	ld	s0,32(sp)
    800032da:	64e2                	ld	s1,24(sp)
    800032dc:	6942                	ld	s2,16(sp)
    800032de:	69a2                	ld	s3,8(sp)
    800032e0:	6145                	addi	sp,sp,48
    800032e2:	8082                	ret

00000000800032e4 <ialloc>:
{
    800032e4:	715d                	addi	sp,sp,-80
    800032e6:	e486                	sd	ra,72(sp)
    800032e8:	e0a2                	sd	s0,64(sp)
    800032ea:	fc26                	sd	s1,56(sp)
    800032ec:	f84a                	sd	s2,48(sp)
    800032ee:	f44e                	sd	s3,40(sp)
    800032f0:	f052                	sd	s4,32(sp)
    800032f2:	ec56                	sd	s5,24(sp)
    800032f4:	e85a                	sd	s6,16(sp)
    800032f6:	e45e                	sd	s7,8(sp)
    800032f8:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800032fa:	0001d717          	auipc	a4,0x1d
    800032fe:	be272703          	lw	a4,-1054(a4) # 8001fedc <sb+0xc>
    80003302:	4785                	li	a5,1
    80003304:	04e7fa63          	bgeu	a5,a4,80003358 <ialloc+0x74>
    80003308:	8aaa                	mv	s5,a0
    8000330a:	8bae                	mv	s7,a1
    8000330c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000330e:	0001da17          	auipc	s4,0x1d
    80003312:	bc2a0a13          	addi	s4,s4,-1086 # 8001fed0 <sb>
    80003316:	00048b1b          	sext.w	s6,s1
    8000331a:	0044d593          	srli	a1,s1,0x4
    8000331e:	018a2783          	lw	a5,24(s4)
    80003322:	9dbd                	addw	a1,a1,a5
    80003324:	8556                	mv	a0,s5
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	950080e7          	jalr	-1712(ra) # 80002c76 <bread>
    8000332e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003330:	06050993          	addi	s3,a0,96
    80003334:	00f4f793          	andi	a5,s1,15
    80003338:	079a                	slli	a5,a5,0x6
    8000333a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000333c:	00099783          	lh	a5,0(s3)
    80003340:	c785                	beqz	a5,80003368 <ialloc+0x84>
    brelse(bp);
    80003342:	00000097          	auipc	ra,0x0
    80003346:	a68080e7          	jalr	-1432(ra) # 80002daa <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000334a:	0485                	addi	s1,s1,1
    8000334c:	00ca2703          	lw	a4,12(s4)
    80003350:	0004879b          	sext.w	a5,s1
    80003354:	fce7e1e3          	bltu	a5,a4,80003316 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003358:	00004517          	auipc	a0,0x4
    8000335c:	22050513          	addi	a0,a0,544 # 80007578 <userret+0x4e8>
    80003360:	ffffd097          	auipc	ra,0xffffd
    80003364:	1ee080e7          	jalr	494(ra) # 8000054e <panic>
      memset(dip, 0, sizeof(*dip));
    80003368:	04000613          	li	a2,64
    8000336c:	4581                	li	a1,0
    8000336e:	854e                	mv	a0,s3
    80003370:	ffffe097          	auipc	ra,0xffffe
    80003374:	83e080e7          	jalr	-1986(ra) # 80000bae <memset>
      dip->type = type;
    80003378:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000337c:	854a                	mv	a0,s2
    8000337e:	00001097          	auipc	ra,0x1
    80003382:	d62080e7          	jalr	-670(ra) # 800040e0 <log_write>
      brelse(bp);
    80003386:	854a                	mv	a0,s2
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	a22080e7          	jalr	-1502(ra) # 80002daa <brelse>
      return iget(dev, inum);
    80003390:	85da                	mv	a1,s6
    80003392:	8556                	mv	a0,s5
    80003394:	00000097          	auipc	ra,0x0
    80003398:	db4080e7          	jalr	-588(ra) # 80003148 <iget>
}
    8000339c:	60a6                	ld	ra,72(sp)
    8000339e:	6406                	ld	s0,64(sp)
    800033a0:	74e2                	ld	s1,56(sp)
    800033a2:	7942                	ld	s2,48(sp)
    800033a4:	79a2                	ld	s3,40(sp)
    800033a6:	7a02                	ld	s4,32(sp)
    800033a8:	6ae2                	ld	s5,24(sp)
    800033aa:	6b42                	ld	s6,16(sp)
    800033ac:	6ba2                	ld	s7,8(sp)
    800033ae:	6161                	addi	sp,sp,80
    800033b0:	8082                	ret

00000000800033b2 <iupdate>:
{
    800033b2:	1101                	addi	sp,sp,-32
    800033b4:	ec06                	sd	ra,24(sp)
    800033b6:	e822                	sd	s0,16(sp)
    800033b8:	e426                	sd	s1,8(sp)
    800033ba:	e04a                	sd	s2,0(sp)
    800033bc:	1000                	addi	s0,sp,32
    800033be:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800033c0:	415c                	lw	a5,4(a0)
    800033c2:	0047d79b          	srliw	a5,a5,0x4
    800033c6:	0001d597          	auipc	a1,0x1d
    800033ca:	b225a583          	lw	a1,-1246(a1) # 8001fee8 <sb+0x18>
    800033ce:	9dbd                	addw	a1,a1,a5
    800033d0:	4108                	lw	a0,0(a0)
    800033d2:	00000097          	auipc	ra,0x0
    800033d6:	8a4080e7          	jalr	-1884(ra) # 80002c76 <bread>
    800033da:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800033dc:	06050793          	addi	a5,a0,96
    800033e0:	40c8                	lw	a0,4(s1)
    800033e2:	893d                	andi	a0,a0,15
    800033e4:	051a                	slli	a0,a0,0x6
    800033e6:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800033e8:	04449703          	lh	a4,68(s1)
    800033ec:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800033f0:	04649703          	lh	a4,70(s1)
    800033f4:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800033f8:	04849703          	lh	a4,72(s1)
    800033fc:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003400:	04a49703          	lh	a4,74(s1)
    80003404:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003408:	44f8                	lw	a4,76(s1)
    8000340a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000340c:	03400613          	li	a2,52
    80003410:	05048593          	addi	a1,s1,80
    80003414:	0531                	addi	a0,a0,12
    80003416:	ffffd097          	auipc	ra,0xffffd
    8000341a:	7f8080e7          	jalr	2040(ra) # 80000c0e <memmove>
  log_write(bp);
    8000341e:	854a                	mv	a0,s2
    80003420:	00001097          	auipc	ra,0x1
    80003424:	cc0080e7          	jalr	-832(ra) # 800040e0 <log_write>
  brelse(bp);
    80003428:	854a                	mv	a0,s2
    8000342a:	00000097          	auipc	ra,0x0
    8000342e:	980080e7          	jalr	-1664(ra) # 80002daa <brelse>
}
    80003432:	60e2                	ld	ra,24(sp)
    80003434:	6442                	ld	s0,16(sp)
    80003436:	64a2                	ld	s1,8(sp)
    80003438:	6902                	ld	s2,0(sp)
    8000343a:	6105                	addi	sp,sp,32
    8000343c:	8082                	ret

000000008000343e <idup>:
{
    8000343e:	1101                	addi	sp,sp,-32
    80003440:	ec06                	sd	ra,24(sp)
    80003442:	e822                	sd	s0,16(sp)
    80003444:	e426                	sd	s1,8(sp)
    80003446:	1000                	addi	s0,sp,32
    80003448:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000344a:	0001d517          	auipc	a0,0x1d
    8000344e:	aa650513          	addi	a0,a0,-1370 # 8001fef0 <icache>
    80003452:	ffffd097          	auipc	ra,0xffffd
    80003456:	698080e7          	jalr	1688(ra) # 80000aea <acquire>
  ip->ref++;
    8000345a:	449c                	lw	a5,8(s1)
    8000345c:	2785                	addiw	a5,a5,1
    8000345e:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003460:	0001d517          	auipc	a0,0x1d
    80003464:	a9050513          	addi	a0,a0,-1392 # 8001fef0 <icache>
    80003468:	ffffd097          	auipc	ra,0xffffd
    8000346c:	6ea080e7          	jalr	1770(ra) # 80000b52 <release>
}
    80003470:	8526                	mv	a0,s1
    80003472:	60e2                	ld	ra,24(sp)
    80003474:	6442                	ld	s0,16(sp)
    80003476:	64a2                	ld	s1,8(sp)
    80003478:	6105                	addi	sp,sp,32
    8000347a:	8082                	ret

000000008000347c <ilock>:
{
    8000347c:	1101                	addi	sp,sp,-32
    8000347e:	ec06                	sd	ra,24(sp)
    80003480:	e822                	sd	s0,16(sp)
    80003482:	e426                	sd	s1,8(sp)
    80003484:	e04a                	sd	s2,0(sp)
    80003486:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003488:	c115                	beqz	a0,800034ac <ilock+0x30>
    8000348a:	84aa                	mv	s1,a0
    8000348c:	451c                	lw	a5,8(a0)
    8000348e:	00f05f63          	blez	a5,800034ac <ilock+0x30>
  acquiresleep(&ip->lock);
    80003492:	0541                	addi	a0,a0,16
    80003494:	00001097          	auipc	ra,0x1
    80003498:	ee4080e7          	jalr	-284(ra) # 80004378 <acquiresleep>
  if(ip->valid == 0){
    8000349c:	40bc                	lw	a5,64(s1)
    8000349e:	cf99                	beqz	a5,800034bc <ilock+0x40>
}
    800034a0:	60e2                	ld	ra,24(sp)
    800034a2:	6442                	ld	s0,16(sp)
    800034a4:	64a2                	ld	s1,8(sp)
    800034a6:	6902                	ld	s2,0(sp)
    800034a8:	6105                	addi	sp,sp,32
    800034aa:	8082                	ret
    panic("ilock");
    800034ac:	00004517          	auipc	a0,0x4
    800034b0:	0e450513          	addi	a0,a0,228 # 80007590 <userret+0x500>
    800034b4:	ffffd097          	auipc	ra,0xffffd
    800034b8:	09a080e7          	jalr	154(ra) # 8000054e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800034bc:	40dc                	lw	a5,4(s1)
    800034be:	0047d79b          	srliw	a5,a5,0x4
    800034c2:	0001d597          	auipc	a1,0x1d
    800034c6:	a265a583          	lw	a1,-1498(a1) # 8001fee8 <sb+0x18>
    800034ca:	9dbd                	addw	a1,a1,a5
    800034cc:	4088                	lw	a0,0(s1)
    800034ce:	fffff097          	auipc	ra,0xfffff
    800034d2:	7a8080e7          	jalr	1960(ra) # 80002c76 <bread>
    800034d6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800034d8:	06050593          	addi	a1,a0,96
    800034dc:	40dc                	lw	a5,4(s1)
    800034de:	8bbd                	andi	a5,a5,15
    800034e0:	079a                	slli	a5,a5,0x6
    800034e2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800034e4:	00059783          	lh	a5,0(a1)
    800034e8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800034ec:	00259783          	lh	a5,2(a1)
    800034f0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800034f4:	00459783          	lh	a5,4(a1)
    800034f8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800034fc:	00659783          	lh	a5,6(a1)
    80003500:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003504:	459c                	lw	a5,8(a1)
    80003506:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003508:	03400613          	li	a2,52
    8000350c:	05b1                	addi	a1,a1,12
    8000350e:	05048513          	addi	a0,s1,80
    80003512:	ffffd097          	auipc	ra,0xffffd
    80003516:	6fc080e7          	jalr	1788(ra) # 80000c0e <memmove>
    brelse(bp);
    8000351a:	854a                	mv	a0,s2
    8000351c:	00000097          	auipc	ra,0x0
    80003520:	88e080e7          	jalr	-1906(ra) # 80002daa <brelse>
    ip->valid = 1;
    80003524:	4785                	li	a5,1
    80003526:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003528:	04449783          	lh	a5,68(s1)
    8000352c:	fbb5                	bnez	a5,800034a0 <ilock+0x24>
      panic("ilock: no type");
    8000352e:	00004517          	auipc	a0,0x4
    80003532:	06a50513          	addi	a0,a0,106 # 80007598 <userret+0x508>
    80003536:	ffffd097          	auipc	ra,0xffffd
    8000353a:	018080e7          	jalr	24(ra) # 8000054e <panic>

000000008000353e <iunlock>:
{
    8000353e:	1101                	addi	sp,sp,-32
    80003540:	ec06                	sd	ra,24(sp)
    80003542:	e822                	sd	s0,16(sp)
    80003544:	e426                	sd	s1,8(sp)
    80003546:	e04a                	sd	s2,0(sp)
    80003548:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000354a:	c905                	beqz	a0,8000357a <iunlock+0x3c>
    8000354c:	84aa                	mv	s1,a0
    8000354e:	01050913          	addi	s2,a0,16
    80003552:	854a                	mv	a0,s2
    80003554:	00001097          	auipc	ra,0x1
    80003558:	ebe080e7          	jalr	-322(ra) # 80004412 <holdingsleep>
    8000355c:	cd19                	beqz	a0,8000357a <iunlock+0x3c>
    8000355e:	449c                	lw	a5,8(s1)
    80003560:	00f05d63          	blez	a5,8000357a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003564:	854a                	mv	a0,s2
    80003566:	00001097          	auipc	ra,0x1
    8000356a:	e68080e7          	jalr	-408(ra) # 800043ce <releasesleep>
}
    8000356e:	60e2                	ld	ra,24(sp)
    80003570:	6442                	ld	s0,16(sp)
    80003572:	64a2                	ld	s1,8(sp)
    80003574:	6902                	ld	s2,0(sp)
    80003576:	6105                	addi	sp,sp,32
    80003578:	8082                	ret
    panic("iunlock");
    8000357a:	00004517          	auipc	a0,0x4
    8000357e:	02e50513          	addi	a0,a0,46 # 800075a8 <userret+0x518>
    80003582:	ffffd097          	auipc	ra,0xffffd
    80003586:	fcc080e7          	jalr	-52(ra) # 8000054e <panic>

000000008000358a <iput>:
{
    8000358a:	7139                	addi	sp,sp,-64
    8000358c:	fc06                	sd	ra,56(sp)
    8000358e:	f822                	sd	s0,48(sp)
    80003590:	f426                	sd	s1,40(sp)
    80003592:	f04a                	sd	s2,32(sp)
    80003594:	ec4e                	sd	s3,24(sp)
    80003596:	e852                	sd	s4,16(sp)
    80003598:	e456                	sd	s5,8(sp)
    8000359a:	0080                	addi	s0,sp,64
    8000359c:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000359e:	0001d517          	auipc	a0,0x1d
    800035a2:	95250513          	addi	a0,a0,-1710 # 8001fef0 <icache>
    800035a6:	ffffd097          	auipc	ra,0xffffd
    800035aa:	544080e7          	jalr	1348(ra) # 80000aea <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800035ae:	4498                	lw	a4,8(s1)
    800035b0:	4785                	li	a5,1
    800035b2:	02f70663          	beq	a4,a5,800035de <iput+0x54>
  ip->ref--;
    800035b6:	449c                	lw	a5,8(s1)
    800035b8:	37fd                	addiw	a5,a5,-1
    800035ba:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800035bc:	0001d517          	auipc	a0,0x1d
    800035c0:	93450513          	addi	a0,a0,-1740 # 8001fef0 <icache>
    800035c4:	ffffd097          	auipc	ra,0xffffd
    800035c8:	58e080e7          	jalr	1422(ra) # 80000b52 <release>
}
    800035cc:	70e2                	ld	ra,56(sp)
    800035ce:	7442                	ld	s0,48(sp)
    800035d0:	74a2                	ld	s1,40(sp)
    800035d2:	7902                	ld	s2,32(sp)
    800035d4:	69e2                	ld	s3,24(sp)
    800035d6:	6a42                	ld	s4,16(sp)
    800035d8:	6aa2                	ld	s5,8(sp)
    800035da:	6121                	addi	sp,sp,64
    800035dc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800035de:	40bc                	lw	a5,64(s1)
    800035e0:	dbf9                	beqz	a5,800035b6 <iput+0x2c>
    800035e2:	04a49783          	lh	a5,74(s1)
    800035e6:	fbe1                	bnez	a5,800035b6 <iput+0x2c>
    acquiresleep(&ip->lock);
    800035e8:	01048a13          	addi	s4,s1,16
    800035ec:	8552                	mv	a0,s4
    800035ee:	00001097          	auipc	ra,0x1
    800035f2:	d8a080e7          	jalr	-630(ra) # 80004378 <acquiresleep>
    release(&icache.lock);
    800035f6:	0001d517          	auipc	a0,0x1d
    800035fa:	8fa50513          	addi	a0,a0,-1798 # 8001fef0 <icache>
    800035fe:	ffffd097          	auipc	ra,0xffffd
    80003602:	554080e7          	jalr	1364(ra) # 80000b52 <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003606:	05048913          	addi	s2,s1,80
    8000360a:	08048993          	addi	s3,s1,128
    8000360e:	a819                	j	80003624 <iput+0x9a>
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
    80003610:	4088                	lw	a0,0(s1)
    80003612:	00000097          	auipc	ra,0x0
    80003616:	8ae080e7          	jalr	-1874(ra) # 80002ec0 <bfree>
      ip->addrs[i] = 0;
    8000361a:	00092023          	sw	zero,0(s2)
  for(i = 0; i < NDIRECT; i++){
    8000361e:	0911                	addi	s2,s2,4
    80003620:	01390663          	beq	s2,s3,8000362c <iput+0xa2>
    if(ip->addrs[i]){
    80003624:	00092583          	lw	a1,0(s2)
    80003628:	d9fd                	beqz	a1,8000361e <iput+0x94>
    8000362a:	b7dd                	j	80003610 <iput+0x86>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000362c:	0804a583          	lw	a1,128(s1)
    80003630:	ed9d                	bnez	a1,8000366e <iput+0xe4>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003632:	0404a623          	sw	zero,76(s1)
  iupdate(ip);
    80003636:	8526                	mv	a0,s1
    80003638:	00000097          	auipc	ra,0x0
    8000363c:	d7a080e7          	jalr	-646(ra) # 800033b2 <iupdate>
    ip->type = 0;
    80003640:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003644:	8526                	mv	a0,s1
    80003646:	00000097          	auipc	ra,0x0
    8000364a:	d6c080e7          	jalr	-660(ra) # 800033b2 <iupdate>
    ip->valid = 0;
    8000364e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003652:	8552                	mv	a0,s4
    80003654:	00001097          	auipc	ra,0x1
    80003658:	d7a080e7          	jalr	-646(ra) # 800043ce <releasesleep>
    acquire(&icache.lock);
    8000365c:	0001d517          	auipc	a0,0x1d
    80003660:	89450513          	addi	a0,a0,-1900 # 8001fef0 <icache>
    80003664:	ffffd097          	auipc	ra,0xffffd
    80003668:	486080e7          	jalr	1158(ra) # 80000aea <acquire>
    8000366c:	b7a9                	j	800035b6 <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000366e:	4088                	lw	a0,0(s1)
    80003670:	fffff097          	auipc	ra,0xfffff
    80003674:	606080e7          	jalr	1542(ra) # 80002c76 <bread>
    80003678:	8aaa                	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
    8000367a:	06050913          	addi	s2,a0,96
    8000367e:	46050993          	addi	s3,a0,1120
    80003682:	a809                	j	80003694 <iput+0x10a>
        bfree(ip->dev, a[j]);
    80003684:	4088                	lw	a0,0(s1)
    80003686:	00000097          	auipc	ra,0x0
    8000368a:	83a080e7          	jalr	-1990(ra) # 80002ec0 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    8000368e:	0911                	addi	s2,s2,4
    80003690:	01390663          	beq	s2,s3,8000369c <iput+0x112>
      if(a[j])
    80003694:	00092583          	lw	a1,0(s2)
    80003698:	d9fd                	beqz	a1,8000368e <iput+0x104>
    8000369a:	b7ed                	j	80003684 <iput+0xfa>
    brelse(bp);
    8000369c:	8556                	mv	a0,s5
    8000369e:	fffff097          	auipc	ra,0xfffff
    800036a2:	70c080e7          	jalr	1804(ra) # 80002daa <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800036a6:	0804a583          	lw	a1,128(s1)
    800036aa:	4088                	lw	a0,0(s1)
    800036ac:	00000097          	auipc	ra,0x0
    800036b0:	814080e7          	jalr	-2028(ra) # 80002ec0 <bfree>
    ip->addrs[NDIRECT] = 0;
    800036b4:	0804a023          	sw	zero,128(s1)
    800036b8:	bfad                	j	80003632 <iput+0xa8>

00000000800036ba <iunlockput>:
{
    800036ba:	1101                	addi	sp,sp,-32
    800036bc:	ec06                	sd	ra,24(sp)
    800036be:	e822                	sd	s0,16(sp)
    800036c0:	e426                	sd	s1,8(sp)
    800036c2:	1000                	addi	s0,sp,32
    800036c4:	84aa                	mv	s1,a0
  iunlock(ip);
    800036c6:	00000097          	auipc	ra,0x0
    800036ca:	e78080e7          	jalr	-392(ra) # 8000353e <iunlock>
  iput(ip);
    800036ce:	8526                	mv	a0,s1
    800036d0:	00000097          	auipc	ra,0x0
    800036d4:	eba080e7          	jalr	-326(ra) # 8000358a <iput>
}
    800036d8:	60e2                	ld	ra,24(sp)
    800036da:	6442                	ld	s0,16(sp)
    800036dc:	64a2                	ld	s1,8(sp)
    800036de:	6105                	addi	sp,sp,32
    800036e0:	8082                	ret

00000000800036e2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800036e2:	1141                	addi	sp,sp,-16
    800036e4:	e422                	sd	s0,8(sp)
    800036e6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800036e8:	411c                	lw	a5,0(a0)
    800036ea:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800036ec:	415c                	lw	a5,4(a0)
    800036ee:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800036f0:	04451783          	lh	a5,68(a0)
    800036f4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800036f8:	04a51783          	lh	a5,74(a0)
    800036fc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003700:	04c56783          	lwu	a5,76(a0)
    80003704:	e99c                	sd	a5,16(a1)
}
    80003706:	6422                	ld	s0,8(sp)
    80003708:	0141                	addi	sp,sp,16
    8000370a:	8082                	ret

000000008000370c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000370c:	457c                	lw	a5,76(a0)
    8000370e:	0ed7e563          	bltu	a5,a3,800037f8 <readi+0xec>
{
    80003712:	7159                	addi	sp,sp,-112
    80003714:	f486                	sd	ra,104(sp)
    80003716:	f0a2                	sd	s0,96(sp)
    80003718:	eca6                	sd	s1,88(sp)
    8000371a:	e8ca                	sd	s2,80(sp)
    8000371c:	e4ce                	sd	s3,72(sp)
    8000371e:	e0d2                	sd	s4,64(sp)
    80003720:	fc56                	sd	s5,56(sp)
    80003722:	f85a                	sd	s6,48(sp)
    80003724:	f45e                	sd	s7,40(sp)
    80003726:	f062                	sd	s8,32(sp)
    80003728:	ec66                	sd	s9,24(sp)
    8000372a:	e86a                	sd	s10,16(sp)
    8000372c:	e46e                	sd	s11,8(sp)
    8000372e:	1880                	addi	s0,sp,112
    80003730:	8baa                	mv	s7,a0
    80003732:	8c2e                	mv	s8,a1
    80003734:	8ab2                	mv	s5,a2
    80003736:	8936                	mv	s2,a3
    80003738:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000373a:	9f35                	addw	a4,a4,a3
    8000373c:	0cd76063          	bltu	a4,a3,800037fc <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    80003740:	00e7f463          	bgeu	a5,a4,80003748 <readi+0x3c>
    n = ip->size - off;
    80003744:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003748:	080b0763          	beqz	s6,800037d6 <readi+0xca>
    8000374c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000374e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003752:	5cfd                	li	s9,-1
    80003754:	a82d                	j	8000378e <readi+0x82>
    80003756:	02099d93          	slli	s11,s3,0x20
    8000375a:	020ddd93          	srli	s11,s11,0x20
    8000375e:	06048613          	addi	a2,s1,96
    80003762:	86ee                	mv	a3,s11
    80003764:	963a                	add	a2,a2,a4
    80003766:	85d6                	mv	a1,s5
    80003768:	8562                	mv	a0,s8
    8000376a:	fffff097          	auipc	ra,0xfffff
    8000376e:	b54080e7          	jalr	-1196(ra) # 800022be <either_copyout>
    80003772:	05950d63          	beq	a0,s9,800037cc <readi+0xc0>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003776:	8526                	mv	a0,s1
    80003778:	fffff097          	auipc	ra,0xfffff
    8000377c:	632080e7          	jalr	1586(ra) # 80002daa <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003780:	01498a3b          	addw	s4,s3,s4
    80003784:	0129893b          	addw	s2,s3,s2
    80003788:	9aee                	add	s5,s5,s11
    8000378a:	056a7663          	bgeu	s4,s6,800037d6 <readi+0xca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000378e:	000ba483          	lw	s1,0(s7)
    80003792:	00a9559b          	srliw	a1,s2,0xa
    80003796:	855e                	mv	a0,s7
    80003798:	00000097          	auipc	ra,0x0
    8000379c:	8d6080e7          	jalr	-1834(ra) # 8000306e <bmap>
    800037a0:	0005059b          	sext.w	a1,a0
    800037a4:	8526                	mv	a0,s1
    800037a6:	fffff097          	auipc	ra,0xfffff
    800037aa:	4d0080e7          	jalr	1232(ra) # 80002c76 <bread>
    800037ae:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800037b0:	3ff97713          	andi	a4,s2,1023
    800037b4:	40ed07bb          	subw	a5,s10,a4
    800037b8:	414b06bb          	subw	a3,s6,s4
    800037bc:	89be                	mv	s3,a5
    800037be:	2781                	sext.w	a5,a5
    800037c0:	0006861b          	sext.w	a2,a3
    800037c4:	f8f679e3          	bgeu	a2,a5,80003756 <readi+0x4a>
    800037c8:	89b6                	mv	s3,a3
    800037ca:	b771                	j	80003756 <readi+0x4a>
      brelse(bp);
    800037cc:	8526                	mv	a0,s1
    800037ce:	fffff097          	auipc	ra,0xfffff
    800037d2:	5dc080e7          	jalr	1500(ra) # 80002daa <brelse>
  }
  return n;
    800037d6:	000b051b          	sext.w	a0,s6
}
    800037da:	70a6                	ld	ra,104(sp)
    800037dc:	7406                	ld	s0,96(sp)
    800037de:	64e6                	ld	s1,88(sp)
    800037e0:	6946                	ld	s2,80(sp)
    800037e2:	69a6                	ld	s3,72(sp)
    800037e4:	6a06                	ld	s4,64(sp)
    800037e6:	7ae2                	ld	s5,56(sp)
    800037e8:	7b42                	ld	s6,48(sp)
    800037ea:	7ba2                	ld	s7,40(sp)
    800037ec:	7c02                	ld	s8,32(sp)
    800037ee:	6ce2                	ld	s9,24(sp)
    800037f0:	6d42                	ld	s10,16(sp)
    800037f2:	6da2                	ld	s11,8(sp)
    800037f4:	6165                	addi	sp,sp,112
    800037f6:	8082                	ret
    return -1;
    800037f8:	557d                	li	a0,-1
}
    800037fa:	8082                	ret
    return -1;
    800037fc:	557d                	li	a0,-1
    800037fe:	bff1                	j	800037da <readi+0xce>

0000000080003800 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003800:	457c                	lw	a5,76(a0)
    80003802:	10d7e763          	bltu	a5,a3,80003910 <writei+0x110>
{
    80003806:	7159                	addi	sp,sp,-112
    80003808:	f486                	sd	ra,104(sp)
    8000380a:	f0a2                	sd	s0,96(sp)
    8000380c:	eca6                	sd	s1,88(sp)
    8000380e:	e8ca                	sd	s2,80(sp)
    80003810:	e4ce                	sd	s3,72(sp)
    80003812:	e0d2                	sd	s4,64(sp)
    80003814:	fc56                	sd	s5,56(sp)
    80003816:	f85a                	sd	s6,48(sp)
    80003818:	f45e                	sd	s7,40(sp)
    8000381a:	f062                	sd	s8,32(sp)
    8000381c:	ec66                	sd	s9,24(sp)
    8000381e:	e86a                	sd	s10,16(sp)
    80003820:	e46e                	sd	s11,8(sp)
    80003822:	1880                	addi	s0,sp,112
    80003824:	8baa                	mv	s7,a0
    80003826:	8c2e                	mv	s8,a1
    80003828:	8ab2                	mv	s5,a2
    8000382a:	8936                	mv	s2,a3
    8000382c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000382e:	00e687bb          	addw	a5,a3,a4
    80003832:	0ed7e163          	bltu	a5,a3,80003914 <writei+0x114>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003836:	00043737          	lui	a4,0x43
    8000383a:	0cf76f63          	bltu	a4,a5,80003918 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000383e:	0a0b0063          	beqz	s6,800038de <writei+0xde>
    80003842:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003844:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003848:	5cfd                	li	s9,-1
    8000384a:	a091                	j	8000388e <writei+0x8e>
    8000384c:	02099d93          	slli	s11,s3,0x20
    80003850:	020ddd93          	srli	s11,s11,0x20
    80003854:	06048513          	addi	a0,s1,96
    80003858:	86ee                	mv	a3,s11
    8000385a:	8656                	mv	a2,s5
    8000385c:	85e2                	mv	a1,s8
    8000385e:	953a                	add	a0,a0,a4
    80003860:	fffff097          	auipc	ra,0xfffff
    80003864:	ab4080e7          	jalr	-1356(ra) # 80002314 <either_copyin>
    80003868:	07950263          	beq	a0,s9,800038cc <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000386c:	8526                	mv	a0,s1
    8000386e:	00001097          	auipc	ra,0x1
    80003872:	872080e7          	jalr	-1934(ra) # 800040e0 <log_write>
    brelse(bp);
    80003876:	8526                	mv	a0,s1
    80003878:	fffff097          	auipc	ra,0xfffff
    8000387c:	532080e7          	jalr	1330(ra) # 80002daa <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003880:	01498a3b          	addw	s4,s3,s4
    80003884:	0129893b          	addw	s2,s3,s2
    80003888:	9aee                	add	s5,s5,s11
    8000388a:	056a7663          	bgeu	s4,s6,800038d6 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000388e:	000ba483          	lw	s1,0(s7)
    80003892:	00a9559b          	srliw	a1,s2,0xa
    80003896:	855e                	mv	a0,s7
    80003898:	fffff097          	auipc	ra,0xfffff
    8000389c:	7d6080e7          	jalr	2006(ra) # 8000306e <bmap>
    800038a0:	0005059b          	sext.w	a1,a0
    800038a4:	8526                	mv	a0,s1
    800038a6:	fffff097          	auipc	ra,0xfffff
    800038aa:	3d0080e7          	jalr	976(ra) # 80002c76 <bread>
    800038ae:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800038b0:	3ff97713          	andi	a4,s2,1023
    800038b4:	40ed07bb          	subw	a5,s10,a4
    800038b8:	414b06bb          	subw	a3,s6,s4
    800038bc:	89be                	mv	s3,a5
    800038be:	2781                	sext.w	a5,a5
    800038c0:	0006861b          	sext.w	a2,a3
    800038c4:	f8f674e3          	bgeu	a2,a5,8000384c <writei+0x4c>
    800038c8:	89b6                	mv	s3,a3
    800038ca:	b749                	j	8000384c <writei+0x4c>
      brelse(bp);
    800038cc:	8526                	mv	a0,s1
    800038ce:	fffff097          	auipc	ra,0xfffff
    800038d2:	4dc080e7          	jalr	1244(ra) # 80002daa <brelse>
  }

  if(n > 0 && off > ip->size){
    800038d6:	04cba783          	lw	a5,76(s7)
    800038da:	0327e363          	bltu	a5,s2,80003900 <writei+0x100>
    ip->size = off;
    iupdate(ip);
  }
  return n;
    800038de:	000b051b          	sext.w	a0,s6
}
    800038e2:	70a6                	ld	ra,104(sp)
    800038e4:	7406                	ld	s0,96(sp)
    800038e6:	64e6                	ld	s1,88(sp)
    800038e8:	6946                	ld	s2,80(sp)
    800038ea:	69a6                	ld	s3,72(sp)
    800038ec:	6a06                	ld	s4,64(sp)
    800038ee:	7ae2                	ld	s5,56(sp)
    800038f0:	7b42                	ld	s6,48(sp)
    800038f2:	7ba2                	ld	s7,40(sp)
    800038f4:	7c02                	ld	s8,32(sp)
    800038f6:	6ce2                	ld	s9,24(sp)
    800038f8:	6d42                	ld	s10,16(sp)
    800038fa:	6da2                	ld	s11,8(sp)
    800038fc:	6165                	addi	sp,sp,112
    800038fe:	8082                	ret
    ip->size = off;
    80003900:	052ba623          	sw	s2,76(s7)
    iupdate(ip);
    80003904:	855e                	mv	a0,s7
    80003906:	00000097          	auipc	ra,0x0
    8000390a:	aac080e7          	jalr	-1364(ra) # 800033b2 <iupdate>
    8000390e:	bfc1                	j	800038de <writei+0xde>
    return -1;
    80003910:	557d                	li	a0,-1
}
    80003912:	8082                	ret
    return -1;
    80003914:	557d                	li	a0,-1
    80003916:	b7f1                	j	800038e2 <writei+0xe2>
    return -1;
    80003918:	557d                	li	a0,-1
    8000391a:	b7e1                	j	800038e2 <writei+0xe2>

000000008000391c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000391c:	1141                	addi	sp,sp,-16
    8000391e:	e406                	sd	ra,8(sp)
    80003920:	e022                	sd	s0,0(sp)
    80003922:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003924:	4639                	li	a2,14
    80003926:	ffffd097          	auipc	ra,0xffffd
    8000392a:	364080e7          	jalr	868(ra) # 80000c8a <strncmp>
}
    8000392e:	60a2                	ld	ra,8(sp)
    80003930:	6402                	ld	s0,0(sp)
    80003932:	0141                	addi	sp,sp,16
    80003934:	8082                	ret

0000000080003936 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003936:	7139                	addi	sp,sp,-64
    80003938:	fc06                	sd	ra,56(sp)
    8000393a:	f822                	sd	s0,48(sp)
    8000393c:	f426                	sd	s1,40(sp)
    8000393e:	f04a                	sd	s2,32(sp)
    80003940:	ec4e                	sd	s3,24(sp)
    80003942:	e852                	sd	s4,16(sp)
    80003944:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003946:	04451703          	lh	a4,68(a0)
    8000394a:	4785                	li	a5,1
    8000394c:	00f71a63          	bne	a4,a5,80003960 <dirlookup+0x2a>
    80003950:	892a                	mv	s2,a0
    80003952:	89ae                	mv	s3,a1
    80003954:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003956:	457c                	lw	a5,76(a0)
    80003958:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000395a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000395c:	e79d                	bnez	a5,8000398a <dirlookup+0x54>
    8000395e:	a8a5                	j	800039d6 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003960:	00004517          	auipc	a0,0x4
    80003964:	c5050513          	addi	a0,a0,-944 # 800075b0 <userret+0x520>
    80003968:	ffffd097          	auipc	ra,0xffffd
    8000396c:	be6080e7          	jalr	-1050(ra) # 8000054e <panic>
      panic("dirlookup read");
    80003970:	00004517          	auipc	a0,0x4
    80003974:	c5850513          	addi	a0,a0,-936 # 800075c8 <userret+0x538>
    80003978:	ffffd097          	auipc	ra,0xffffd
    8000397c:	bd6080e7          	jalr	-1066(ra) # 8000054e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003980:	24c1                	addiw	s1,s1,16
    80003982:	04c92783          	lw	a5,76(s2)
    80003986:	04f4f763          	bgeu	s1,a5,800039d4 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000398a:	4741                	li	a4,16
    8000398c:	86a6                	mv	a3,s1
    8000398e:	fc040613          	addi	a2,s0,-64
    80003992:	4581                	li	a1,0
    80003994:	854a                	mv	a0,s2
    80003996:	00000097          	auipc	ra,0x0
    8000399a:	d76080e7          	jalr	-650(ra) # 8000370c <readi>
    8000399e:	47c1                	li	a5,16
    800039a0:	fcf518e3          	bne	a0,a5,80003970 <dirlookup+0x3a>
    if(de.inum == 0)
    800039a4:	fc045783          	lhu	a5,-64(s0)
    800039a8:	dfe1                	beqz	a5,80003980 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800039aa:	fc240593          	addi	a1,s0,-62
    800039ae:	854e                	mv	a0,s3
    800039b0:	00000097          	auipc	ra,0x0
    800039b4:	f6c080e7          	jalr	-148(ra) # 8000391c <namecmp>
    800039b8:	f561                	bnez	a0,80003980 <dirlookup+0x4a>
      if(poff)
    800039ba:	000a0463          	beqz	s4,800039c2 <dirlookup+0x8c>
        *poff = off;
    800039be:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800039c2:	fc045583          	lhu	a1,-64(s0)
    800039c6:	00092503          	lw	a0,0(s2)
    800039ca:	fffff097          	auipc	ra,0xfffff
    800039ce:	77e080e7          	jalr	1918(ra) # 80003148 <iget>
    800039d2:	a011                	j	800039d6 <dirlookup+0xa0>
  return 0;
    800039d4:	4501                	li	a0,0
}
    800039d6:	70e2                	ld	ra,56(sp)
    800039d8:	7442                	ld	s0,48(sp)
    800039da:	74a2                	ld	s1,40(sp)
    800039dc:	7902                	ld	s2,32(sp)
    800039de:	69e2                	ld	s3,24(sp)
    800039e0:	6a42                	ld	s4,16(sp)
    800039e2:	6121                	addi	sp,sp,64
    800039e4:	8082                	ret

00000000800039e6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800039e6:	711d                	addi	sp,sp,-96
    800039e8:	ec86                	sd	ra,88(sp)
    800039ea:	e8a2                	sd	s0,80(sp)
    800039ec:	e4a6                	sd	s1,72(sp)
    800039ee:	e0ca                	sd	s2,64(sp)
    800039f0:	fc4e                	sd	s3,56(sp)
    800039f2:	f852                	sd	s4,48(sp)
    800039f4:	f456                	sd	s5,40(sp)
    800039f6:	f05a                	sd	s6,32(sp)
    800039f8:	ec5e                	sd	s7,24(sp)
    800039fa:	e862                	sd	s8,16(sp)
    800039fc:	e466                	sd	s9,8(sp)
    800039fe:	1080                	addi	s0,sp,96
    80003a00:	84aa                	mv	s1,a0
    80003a02:	8b2e                	mv	s6,a1
    80003a04:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003a06:	00054703          	lbu	a4,0(a0)
    80003a0a:	02f00793          	li	a5,47
    80003a0e:	02f70363          	beq	a4,a5,80003a34 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003a12:	ffffe097          	auipc	ra,0xffffe
    80003a16:	e3a080e7          	jalr	-454(ra) # 8000184c <myproc>
    80003a1a:	15053503          	ld	a0,336(a0)
    80003a1e:	00000097          	auipc	ra,0x0
    80003a22:	a20080e7          	jalr	-1504(ra) # 8000343e <idup>
    80003a26:	89aa                	mv	s3,a0
  while(*path == '/')
    80003a28:	02f00913          	li	s2,47
  len = path - s;
    80003a2c:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003a2e:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003a30:	4c05                	li	s8,1
    80003a32:	a865                	j	80003aea <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003a34:	4585                	li	a1,1
    80003a36:	4501                	li	a0,0
    80003a38:	fffff097          	auipc	ra,0xfffff
    80003a3c:	710080e7          	jalr	1808(ra) # 80003148 <iget>
    80003a40:	89aa                	mv	s3,a0
    80003a42:	b7dd                	j	80003a28 <namex+0x42>
      iunlockput(ip);
    80003a44:	854e                	mv	a0,s3
    80003a46:	00000097          	auipc	ra,0x0
    80003a4a:	c74080e7          	jalr	-908(ra) # 800036ba <iunlockput>
      return 0;
    80003a4e:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003a50:	854e                	mv	a0,s3
    80003a52:	60e6                	ld	ra,88(sp)
    80003a54:	6446                	ld	s0,80(sp)
    80003a56:	64a6                	ld	s1,72(sp)
    80003a58:	6906                	ld	s2,64(sp)
    80003a5a:	79e2                	ld	s3,56(sp)
    80003a5c:	7a42                	ld	s4,48(sp)
    80003a5e:	7aa2                	ld	s5,40(sp)
    80003a60:	7b02                	ld	s6,32(sp)
    80003a62:	6be2                	ld	s7,24(sp)
    80003a64:	6c42                	ld	s8,16(sp)
    80003a66:	6ca2                	ld	s9,8(sp)
    80003a68:	6125                	addi	sp,sp,96
    80003a6a:	8082                	ret
      iunlock(ip);
    80003a6c:	854e                	mv	a0,s3
    80003a6e:	00000097          	auipc	ra,0x0
    80003a72:	ad0080e7          	jalr	-1328(ra) # 8000353e <iunlock>
      return ip;
    80003a76:	bfe9                	j	80003a50 <namex+0x6a>
      iunlockput(ip);
    80003a78:	854e                	mv	a0,s3
    80003a7a:	00000097          	auipc	ra,0x0
    80003a7e:	c40080e7          	jalr	-960(ra) # 800036ba <iunlockput>
      return 0;
    80003a82:	89d2                	mv	s3,s4
    80003a84:	b7f1                	j	80003a50 <namex+0x6a>
  len = path - s;
    80003a86:	40b48633          	sub	a2,s1,a1
    80003a8a:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003a8e:	094cd463          	bge	s9,s4,80003b16 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003a92:	4639                	li	a2,14
    80003a94:	8556                	mv	a0,s5
    80003a96:	ffffd097          	auipc	ra,0xffffd
    80003a9a:	178080e7          	jalr	376(ra) # 80000c0e <memmove>
  while(*path == '/')
    80003a9e:	0004c783          	lbu	a5,0(s1)
    80003aa2:	01279763          	bne	a5,s2,80003ab0 <namex+0xca>
    path++;
    80003aa6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003aa8:	0004c783          	lbu	a5,0(s1)
    80003aac:	ff278de3          	beq	a5,s2,80003aa6 <namex+0xc0>
    ilock(ip);
    80003ab0:	854e                	mv	a0,s3
    80003ab2:	00000097          	auipc	ra,0x0
    80003ab6:	9ca080e7          	jalr	-1590(ra) # 8000347c <ilock>
    if(ip->type != T_DIR){
    80003aba:	04499783          	lh	a5,68(s3)
    80003abe:	f98793e3          	bne	a5,s8,80003a44 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003ac2:	000b0563          	beqz	s6,80003acc <namex+0xe6>
    80003ac6:	0004c783          	lbu	a5,0(s1)
    80003aca:	d3cd                	beqz	a5,80003a6c <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003acc:	865e                	mv	a2,s7
    80003ace:	85d6                	mv	a1,s5
    80003ad0:	854e                	mv	a0,s3
    80003ad2:	00000097          	auipc	ra,0x0
    80003ad6:	e64080e7          	jalr	-412(ra) # 80003936 <dirlookup>
    80003ada:	8a2a                	mv	s4,a0
    80003adc:	dd51                	beqz	a0,80003a78 <namex+0x92>
    iunlockput(ip);
    80003ade:	854e                	mv	a0,s3
    80003ae0:	00000097          	auipc	ra,0x0
    80003ae4:	bda080e7          	jalr	-1062(ra) # 800036ba <iunlockput>
    ip = next;
    80003ae8:	89d2                	mv	s3,s4
  while(*path == '/')
    80003aea:	0004c783          	lbu	a5,0(s1)
    80003aee:	05279763          	bne	a5,s2,80003b3c <namex+0x156>
    path++;
    80003af2:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003af4:	0004c783          	lbu	a5,0(s1)
    80003af8:	ff278de3          	beq	a5,s2,80003af2 <namex+0x10c>
  if(*path == 0)
    80003afc:	c79d                	beqz	a5,80003b2a <namex+0x144>
    path++;
    80003afe:	85a6                	mv	a1,s1
  len = path - s;
    80003b00:	8a5e                	mv	s4,s7
    80003b02:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003b04:	01278963          	beq	a5,s2,80003b16 <namex+0x130>
    80003b08:	dfbd                	beqz	a5,80003a86 <namex+0xa0>
    path++;
    80003b0a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003b0c:	0004c783          	lbu	a5,0(s1)
    80003b10:	ff279ce3          	bne	a5,s2,80003b08 <namex+0x122>
    80003b14:	bf8d                	j	80003a86 <namex+0xa0>
    memmove(name, s, len);
    80003b16:	2601                	sext.w	a2,a2
    80003b18:	8556                	mv	a0,s5
    80003b1a:	ffffd097          	auipc	ra,0xffffd
    80003b1e:	0f4080e7          	jalr	244(ra) # 80000c0e <memmove>
    name[len] = 0;
    80003b22:	9a56                	add	s4,s4,s5
    80003b24:	000a0023          	sb	zero,0(s4)
    80003b28:	bf9d                	j	80003a9e <namex+0xb8>
  if(nameiparent){
    80003b2a:	f20b03e3          	beqz	s6,80003a50 <namex+0x6a>
    iput(ip);
    80003b2e:	854e                	mv	a0,s3
    80003b30:	00000097          	auipc	ra,0x0
    80003b34:	a5a080e7          	jalr	-1446(ra) # 8000358a <iput>
    return 0;
    80003b38:	4981                	li	s3,0
    80003b3a:	bf19                	j	80003a50 <namex+0x6a>
  if(*path == 0)
    80003b3c:	d7fd                	beqz	a5,80003b2a <namex+0x144>
  while(*path != '/' && *path != 0)
    80003b3e:	0004c783          	lbu	a5,0(s1)
    80003b42:	85a6                	mv	a1,s1
    80003b44:	b7d1                	j	80003b08 <namex+0x122>

0000000080003b46 <dirlink>:
{
    80003b46:	7139                	addi	sp,sp,-64
    80003b48:	fc06                	sd	ra,56(sp)
    80003b4a:	f822                	sd	s0,48(sp)
    80003b4c:	f426                	sd	s1,40(sp)
    80003b4e:	f04a                	sd	s2,32(sp)
    80003b50:	ec4e                	sd	s3,24(sp)
    80003b52:	e852                	sd	s4,16(sp)
    80003b54:	0080                	addi	s0,sp,64
    80003b56:	892a                	mv	s2,a0
    80003b58:	8a2e                	mv	s4,a1
    80003b5a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003b5c:	4601                	li	a2,0
    80003b5e:	00000097          	auipc	ra,0x0
    80003b62:	dd8080e7          	jalr	-552(ra) # 80003936 <dirlookup>
    80003b66:	e93d                	bnez	a0,80003bdc <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b68:	04c92483          	lw	s1,76(s2)
    80003b6c:	c49d                	beqz	s1,80003b9a <dirlink+0x54>
    80003b6e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b70:	4741                	li	a4,16
    80003b72:	86a6                	mv	a3,s1
    80003b74:	fc040613          	addi	a2,s0,-64
    80003b78:	4581                	li	a1,0
    80003b7a:	854a                	mv	a0,s2
    80003b7c:	00000097          	auipc	ra,0x0
    80003b80:	b90080e7          	jalr	-1136(ra) # 8000370c <readi>
    80003b84:	47c1                	li	a5,16
    80003b86:	06f51163          	bne	a0,a5,80003be8 <dirlink+0xa2>
    if(de.inum == 0)
    80003b8a:	fc045783          	lhu	a5,-64(s0)
    80003b8e:	c791                	beqz	a5,80003b9a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b90:	24c1                	addiw	s1,s1,16
    80003b92:	04c92783          	lw	a5,76(s2)
    80003b96:	fcf4ede3          	bltu	s1,a5,80003b70 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003b9a:	4639                	li	a2,14
    80003b9c:	85d2                	mv	a1,s4
    80003b9e:	fc240513          	addi	a0,s0,-62
    80003ba2:	ffffd097          	auipc	ra,0xffffd
    80003ba6:	124080e7          	jalr	292(ra) # 80000cc6 <strncpy>
  de.inum = inum;
    80003baa:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003bae:	4741                	li	a4,16
    80003bb0:	86a6                	mv	a3,s1
    80003bb2:	fc040613          	addi	a2,s0,-64
    80003bb6:	4581                	li	a1,0
    80003bb8:	854a                	mv	a0,s2
    80003bba:	00000097          	auipc	ra,0x0
    80003bbe:	c46080e7          	jalr	-954(ra) # 80003800 <writei>
    80003bc2:	872a                	mv	a4,a0
    80003bc4:	47c1                	li	a5,16
  return 0;
    80003bc6:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003bc8:	02f71863          	bne	a4,a5,80003bf8 <dirlink+0xb2>
}
    80003bcc:	70e2                	ld	ra,56(sp)
    80003bce:	7442                	ld	s0,48(sp)
    80003bd0:	74a2                	ld	s1,40(sp)
    80003bd2:	7902                	ld	s2,32(sp)
    80003bd4:	69e2                	ld	s3,24(sp)
    80003bd6:	6a42                	ld	s4,16(sp)
    80003bd8:	6121                	addi	sp,sp,64
    80003bda:	8082                	ret
    iput(ip);
    80003bdc:	00000097          	auipc	ra,0x0
    80003be0:	9ae080e7          	jalr	-1618(ra) # 8000358a <iput>
    return -1;
    80003be4:	557d                	li	a0,-1
    80003be6:	b7dd                	j	80003bcc <dirlink+0x86>
      panic("dirlink read");
    80003be8:	00004517          	auipc	a0,0x4
    80003bec:	9f050513          	addi	a0,a0,-1552 # 800075d8 <userret+0x548>
    80003bf0:	ffffd097          	auipc	ra,0xffffd
    80003bf4:	95e080e7          	jalr	-1698(ra) # 8000054e <panic>
    panic("dirlink");
    80003bf8:	00004517          	auipc	a0,0x4
    80003bfc:	b9050513          	addi	a0,a0,-1136 # 80007788 <userret+0x6f8>
    80003c00:	ffffd097          	auipc	ra,0xffffd
    80003c04:	94e080e7          	jalr	-1714(ra) # 8000054e <panic>

0000000080003c08 <namei>:

struct inode*
namei(char *path)
{
    80003c08:	1101                	addi	sp,sp,-32
    80003c0a:	ec06                	sd	ra,24(sp)
    80003c0c:	e822                	sd	s0,16(sp)
    80003c0e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003c10:	fe040613          	addi	a2,s0,-32
    80003c14:	4581                	li	a1,0
    80003c16:	00000097          	auipc	ra,0x0
    80003c1a:	dd0080e7          	jalr	-560(ra) # 800039e6 <namex>
}
    80003c1e:	60e2                	ld	ra,24(sp)
    80003c20:	6442                	ld	s0,16(sp)
    80003c22:	6105                	addi	sp,sp,32
    80003c24:	8082                	ret

0000000080003c26 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003c26:	1141                	addi	sp,sp,-16
    80003c28:	e406                	sd	ra,8(sp)
    80003c2a:	e022                	sd	s0,0(sp)
    80003c2c:	0800                	addi	s0,sp,16
    80003c2e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003c30:	4585                	li	a1,1
    80003c32:	00000097          	auipc	ra,0x0
    80003c36:	db4080e7          	jalr	-588(ra) # 800039e6 <namex>
}
    80003c3a:	60a2                	ld	ra,8(sp)
    80003c3c:	6402                	ld	s0,0(sp)
    80003c3e:	0141                	addi	sp,sp,16
    80003c40:	8082                	ret

0000000080003c42 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(int dev)
{
    80003c42:	7179                	addi	sp,sp,-48
    80003c44:	f406                	sd	ra,40(sp)
    80003c46:	f022                	sd	s0,32(sp)
    80003c48:	ec26                	sd	s1,24(sp)
    80003c4a:	e84a                	sd	s2,16(sp)
    80003c4c:	e44e                	sd	s3,8(sp)
    80003c4e:	1800                	addi	s0,sp,48
    80003c50:	84aa                	mv	s1,a0
  struct buf *buf = bread(dev, log[dev].start);
    80003c52:	0a800993          	li	s3,168
    80003c56:	033507b3          	mul	a5,a0,s3
    80003c5a:	0001e997          	auipc	s3,0x1e
    80003c5e:	d3e98993          	addi	s3,s3,-706 # 80021998 <log>
    80003c62:	99be                	add	s3,s3,a5
    80003c64:	0189a583          	lw	a1,24(s3)
    80003c68:	fffff097          	auipc	ra,0xfffff
    80003c6c:	00e080e7          	jalr	14(ra) # 80002c76 <bread>
    80003c70:	892a                	mv	s2,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log[dev].lh.n;
    80003c72:	02c9a783          	lw	a5,44(s3)
    80003c76:	d13c                	sw	a5,96(a0)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003c78:	02c9a783          	lw	a5,44(s3)
    80003c7c:	02f05763          	blez	a5,80003caa <write_head+0x68>
    80003c80:	0a800793          	li	a5,168
    80003c84:	02f487b3          	mul	a5,s1,a5
    80003c88:	0001e717          	auipc	a4,0x1e
    80003c8c:	d4070713          	addi	a4,a4,-704 # 800219c8 <log+0x30>
    80003c90:	97ba                	add	a5,a5,a4
    80003c92:	06450693          	addi	a3,a0,100
    80003c96:	4701                	li	a4,0
    80003c98:	85ce                	mv	a1,s3
    hb->block[i] = log[dev].lh.block[i];
    80003c9a:	4390                	lw	a2,0(a5)
    80003c9c:	c290                	sw	a2,0(a3)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003c9e:	2705                	addiw	a4,a4,1
    80003ca0:	0791                	addi	a5,a5,4
    80003ca2:	0691                	addi	a3,a3,4
    80003ca4:	55d0                	lw	a2,44(a1)
    80003ca6:	fec74ae3          	blt	a4,a2,80003c9a <write_head+0x58>
  }
  bwrite(buf);
    80003caa:	854a                	mv	a0,s2
    80003cac:	fffff097          	auipc	ra,0xfffff
    80003cb0:	0be080e7          	jalr	190(ra) # 80002d6a <bwrite>
  brelse(buf);
    80003cb4:	854a                	mv	a0,s2
    80003cb6:	fffff097          	auipc	ra,0xfffff
    80003cba:	0f4080e7          	jalr	244(ra) # 80002daa <brelse>
}
    80003cbe:	70a2                	ld	ra,40(sp)
    80003cc0:	7402                	ld	s0,32(sp)
    80003cc2:	64e2                	ld	s1,24(sp)
    80003cc4:	6942                	ld	s2,16(sp)
    80003cc6:	69a2                	ld	s3,8(sp)
    80003cc8:	6145                	addi	sp,sp,48
    80003cca:	8082                	ret

0000000080003ccc <write_log>:
static void
write_log(int dev)
{
  int tail;

  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003ccc:	0a800793          	li	a5,168
    80003cd0:	02f50733          	mul	a4,a0,a5
    80003cd4:	0001e797          	auipc	a5,0x1e
    80003cd8:	cc478793          	addi	a5,a5,-828 # 80021998 <log>
    80003cdc:	97ba                	add	a5,a5,a4
    80003cde:	57dc                	lw	a5,44(a5)
    80003ce0:	0af05663          	blez	a5,80003d8c <write_log+0xc0>
{
    80003ce4:	7139                	addi	sp,sp,-64
    80003ce6:	fc06                	sd	ra,56(sp)
    80003ce8:	f822                	sd	s0,48(sp)
    80003cea:	f426                	sd	s1,40(sp)
    80003cec:	f04a                	sd	s2,32(sp)
    80003cee:	ec4e                	sd	s3,24(sp)
    80003cf0:	e852                	sd	s4,16(sp)
    80003cf2:	e456                	sd	s5,8(sp)
    80003cf4:	e05a                	sd	s6,0(sp)
    80003cf6:	0080                	addi	s0,sp,64
    80003cf8:	0001e797          	auipc	a5,0x1e
    80003cfc:	cd078793          	addi	a5,a5,-816 # 800219c8 <log+0x30>
    80003d00:	00f70a33          	add	s4,a4,a5
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003d04:	4981                	li	s3,0
    struct buf *to = bread(dev, log[dev].start+tail+1); // log block
    80003d06:	00050b1b          	sext.w	s6,a0
    80003d0a:	0001ea97          	auipc	s5,0x1e
    80003d0e:	c8ea8a93          	addi	s5,s5,-882 # 80021998 <log>
    80003d12:	9aba                	add	s5,s5,a4
    80003d14:	018aa583          	lw	a1,24(s5)
    80003d18:	013585bb          	addw	a1,a1,s3
    80003d1c:	2585                	addiw	a1,a1,1
    80003d1e:	855a                	mv	a0,s6
    80003d20:	fffff097          	auipc	ra,0xfffff
    80003d24:	f56080e7          	jalr	-170(ra) # 80002c76 <bread>
    80003d28:	84aa                	mv	s1,a0
    struct buf *from = bread(dev, log[dev].lh.block[tail]); // cache block
    80003d2a:	000a2583          	lw	a1,0(s4)
    80003d2e:	855a                	mv	a0,s6
    80003d30:	fffff097          	auipc	ra,0xfffff
    80003d34:	f46080e7          	jalr	-186(ra) # 80002c76 <bread>
    80003d38:	892a                	mv	s2,a0
    memmove(to->data, from->data, BSIZE);
    80003d3a:	40000613          	li	a2,1024
    80003d3e:	06050593          	addi	a1,a0,96
    80003d42:	06048513          	addi	a0,s1,96
    80003d46:	ffffd097          	auipc	ra,0xffffd
    80003d4a:	ec8080e7          	jalr	-312(ra) # 80000c0e <memmove>
    bwrite(to);  // write the log
    80003d4e:	8526                	mv	a0,s1
    80003d50:	fffff097          	auipc	ra,0xfffff
    80003d54:	01a080e7          	jalr	26(ra) # 80002d6a <bwrite>
    brelse(from);
    80003d58:	854a                	mv	a0,s2
    80003d5a:	fffff097          	auipc	ra,0xfffff
    80003d5e:	050080e7          	jalr	80(ra) # 80002daa <brelse>
    brelse(to);
    80003d62:	8526                	mv	a0,s1
    80003d64:	fffff097          	auipc	ra,0xfffff
    80003d68:	046080e7          	jalr	70(ra) # 80002daa <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003d6c:	2985                	addiw	s3,s3,1
    80003d6e:	0a11                	addi	s4,s4,4
    80003d70:	02caa783          	lw	a5,44(s5)
    80003d74:	faf9c0e3          	blt	s3,a5,80003d14 <write_log+0x48>
  }
}
    80003d78:	70e2                	ld	ra,56(sp)
    80003d7a:	7442                	ld	s0,48(sp)
    80003d7c:	74a2                	ld	s1,40(sp)
    80003d7e:	7902                	ld	s2,32(sp)
    80003d80:	69e2                	ld	s3,24(sp)
    80003d82:	6a42                	ld	s4,16(sp)
    80003d84:	6aa2                	ld	s5,8(sp)
    80003d86:	6b02                	ld	s6,0(sp)
    80003d88:	6121                	addi	sp,sp,64
    80003d8a:	8082                	ret
    80003d8c:	8082                	ret

0000000080003d8e <install_trans>:
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003d8e:	0a800793          	li	a5,168
    80003d92:	02f50733          	mul	a4,a0,a5
    80003d96:	0001e797          	auipc	a5,0x1e
    80003d9a:	c0278793          	addi	a5,a5,-1022 # 80021998 <log>
    80003d9e:	97ba                	add	a5,a5,a4
    80003da0:	57dc                	lw	a5,44(a5)
    80003da2:	0af05b63          	blez	a5,80003e58 <install_trans+0xca>
{
    80003da6:	7139                	addi	sp,sp,-64
    80003da8:	fc06                	sd	ra,56(sp)
    80003daa:	f822                	sd	s0,48(sp)
    80003dac:	f426                	sd	s1,40(sp)
    80003dae:	f04a                	sd	s2,32(sp)
    80003db0:	ec4e                	sd	s3,24(sp)
    80003db2:	e852                	sd	s4,16(sp)
    80003db4:	e456                	sd	s5,8(sp)
    80003db6:	e05a                	sd	s6,0(sp)
    80003db8:	0080                	addi	s0,sp,64
    80003dba:	0001e797          	auipc	a5,0x1e
    80003dbe:	c0e78793          	addi	a5,a5,-1010 # 800219c8 <log+0x30>
    80003dc2:	00f70a33          	add	s4,a4,a5
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003dc6:	4981                	li	s3,0
    struct buf *lbuf = bread(dev, log[dev].start+tail+1); // read log block
    80003dc8:	00050b1b          	sext.w	s6,a0
    80003dcc:	0001ea97          	auipc	s5,0x1e
    80003dd0:	bcca8a93          	addi	s5,s5,-1076 # 80021998 <log>
    80003dd4:	9aba                	add	s5,s5,a4
    80003dd6:	018aa583          	lw	a1,24(s5)
    80003dda:	013585bb          	addw	a1,a1,s3
    80003dde:	2585                	addiw	a1,a1,1
    80003de0:	855a                	mv	a0,s6
    80003de2:	fffff097          	auipc	ra,0xfffff
    80003de6:	e94080e7          	jalr	-364(ra) # 80002c76 <bread>
    80003dea:	892a                	mv	s2,a0
    struct buf *dbuf = bread(dev, log[dev].lh.block[tail]); // read dst
    80003dec:	000a2583          	lw	a1,0(s4)
    80003df0:	855a                	mv	a0,s6
    80003df2:	fffff097          	auipc	ra,0xfffff
    80003df6:	e84080e7          	jalr	-380(ra) # 80002c76 <bread>
    80003dfa:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003dfc:	40000613          	li	a2,1024
    80003e00:	06090593          	addi	a1,s2,96
    80003e04:	06050513          	addi	a0,a0,96
    80003e08:	ffffd097          	auipc	ra,0xffffd
    80003e0c:	e06080e7          	jalr	-506(ra) # 80000c0e <memmove>
    bwrite(dbuf);  // write dst to disk
    80003e10:	8526                	mv	a0,s1
    80003e12:	fffff097          	auipc	ra,0xfffff
    80003e16:	f58080e7          	jalr	-168(ra) # 80002d6a <bwrite>
    bunpin(dbuf);
    80003e1a:	8526                	mv	a0,s1
    80003e1c:	fffff097          	auipc	ra,0xfffff
    80003e20:	068080e7          	jalr	104(ra) # 80002e84 <bunpin>
    brelse(lbuf);
    80003e24:	854a                	mv	a0,s2
    80003e26:	fffff097          	auipc	ra,0xfffff
    80003e2a:	f84080e7          	jalr	-124(ra) # 80002daa <brelse>
    brelse(dbuf);
    80003e2e:	8526                	mv	a0,s1
    80003e30:	fffff097          	auipc	ra,0xfffff
    80003e34:	f7a080e7          	jalr	-134(ra) # 80002daa <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003e38:	2985                	addiw	s3,s3,1
    80003e3a:	0a11                	addi	s4,s4,4
    80003e3c:	02caa783          	lw	a5,44(s5)
    80003e40:	f8f9cbe3          	blt	s3,a5,80003dd6 <install_trans+0x48>
}
    80003e44:	70e2                	ld	ra,56(sp)
    80003e46:	7442                	ld	s0,48(sp)
    80003e48:	74a2                	ld	s1,40(sp)
    80003e4a:	7902                	ld	s2,32(sp)
    80003e4c:	69e2                	ld	s3,24(sp)
    80003e4e:	6a42                	ld	s4,16(sp)
    80003e50:	6aa2                	ld	s5,8(sp)
    80003e52:	6b02                	ld	s6,0(sp)
    80003e54:	6121                	addi	sp,sp,64
    80003e56:	8082                	ret
    80003e58:	8082                	ret

0000000080003e5a <initlog>:
{
    80003e5a:	7179                	addi	sp,sp,-48
    80003e5c:	f406                	sd	ra,40(sp)
    80003e5e:	f022                	sd	s0,32(sp)
    80003e60:	ec26                	sd	s1,24(sp)
    80003e62:	e84a                	sd	s2,16(sp)
    80003e64:	e44e                	sd	s3,8(sp)
    80003e66:	e052                	sd	s4,0(sp)
    80003e68:	1800                	addi	s0,sp,48
    80003e6a:	84aa                	mv	s1,a0
    80003e6c:	8a2e                	mv	s4,a1
  initlock(&log[dev].lock, "log");
    80003e6e:	0a800713          	li	a4,168
    80003e72:	02e509b3          	mul	s3,a0,a4
    80003e76:	0001e917          	auipc	s2,0x1e
    80003e7a:	b2290913          	addi	s2,s2,-1246 # 80021998 <log>
    80003e7e:	994e                	add	s2,s2,s3
    80003e80:	00003597          	auipc	a1,0x3
    80003e84:	76858593          	addi	a1,a1,1896 # 800075e8 <userret+0x558>
    80003e88:	854a                	mv	a0,s2
    80003e8a:	ffffd097          	auipc	ra,0xffffd
    80003e8e:	b4e080e7          	jalr	-1202(ra) # 800009d8 <initlock>
  log[dev].start = sb->logstart;
    80003e92:	014a2583          	lw	a1,20(s4)
    80003e96:	00b92c23          	sw	a1,24(s2)
  log[dev].size = sb->nlog;
    80003e9a:	010a2783          	lw	a5,16(s4)
    80003e9e:	00f92e23          	sw	a5,28(s2)
  log[dev].dev = dev;
    80003ea2:	02992423          	sw	s1,40(s2)
  struct buf *buf = bread(dev, log[dev].start);
    80003ea6:	8526                	mv	a0,s1
    80003ea8:	fffff097          	auipc	ra,0xfffff
    80003eac:	dce080e7          	jalr	-562(ra) # 80002c76 <bread>
  log[dev].lh.n = lh->n;
    80003eb0:	513c                	lw	a5,96(a0)
    80003eb2:	02f92623          	sw	a5,44(s2)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003eb6:	02f05663          	blez	a5,80003ee2 <initlog+0x88>
    80003eba:	06450693          	addi	a3,a0,100
    80003ebe:	0001e717          	auipc	a4,0x1e
    80003ec2:	b0a70713          	addi	a4,a4,-1270 # 800219c8 <log+0x30>
    80003ec6:	974e                	add	a4,a4,s3
    80003ec8:	37fd                	addiw	a5,a5,-1
    80003eca:	1782                	slli	a5,a5,0x20
    80003ecc:	9381                	srli	a5,a5,0x20
    80003ece:	078a                	slli	a5,a5,0x2
    80003ed0:	06850613          	addi	a2,a0,104
    80003ed4:	97b2                	add	a5,a5,a2
    log[dev].lh.block[i] = lh->block[i];
    80003ed6:	4290                	lw	a2,0(a3)
    80003ed8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003eda:	0691                	addi	a3,a3,4
    80003edc:	0711                	addi	a4,a4,4
    80003ede:	fef69ce3          	bne	a3,a5,80003ed6 <initlog+0x7c>
  brelse(buf);
    80003ee2:	fffff097          	auipc	ra,0xfffff
    80003ee6:	ec8080e7          	jalr	-312(ra) # 80002daa <brelse>
  install_trans(dev); // if committed, copy from log to disk
    80003eea:	8526                	mv	a0,s1
    80003eec:	00000097          	auipc	ra,0x0
    80003ef0:	ea2080e7          	jalr	-350(ra) # 80003d8e <install_trans>
  log[dev].lh.n = 0;
    80003ef4:	0a800793          	li	a5,168
    80003ef8:	02f48733          	mul	a4,s1,a5
    80003efc:	0001e797          	auipc	a5,0x1e
    80003f00:	a9c78793          	addi	a5,a5,-1380 # 80021998 <log>
    80003f04:	97ba                	add	a5,a5,a4
    80003f06:	0207a623          	sw	zero,44(a5)
  write_head(dev); // clear the log
    80003f0a:	8526                	mv	a0,s1
    80003f0c:	00000097          	auipc	ra,0x0
    80003f10:	d36080e7          	jalr	-714(ra) # 80003c42 <write_head>
}
    80003f14:	70a2                	ld	ra,40(sp)
    80003f16:	7402                	ld	s0,32(sp)
    80003f18:	64e2                	ld	s1,24(sp)
    80003f1a:	6942                	ld	s2,16(sp)
    80003f1c:	69a2                	ld	s3,8(sp)
    80003f1e:	6a02                	ld	s4,0(sp)
    80003f20:	6145                	addi	sp,sp,48
    80003f22:	8082                	ret

0000000080003f24 <begin_op>:
{
    80003f24:	7139                	addi	sp,sp,-64
    80003f26:	fc06                	sd	ra,56(sp)
    80003f28:	f822                	sd	s0,48(sp)
    80003f2a:	f426                	sd	s1,40(sp)
    80003f2c:	f04a                	sd	s2,32(sp)
    80003f2e:	ec4e                	sd	s3,24(sp)
    80003f30:	e852                	sd	s4,16(sp)
    80003f32:	e456                	sd	s5,8(sp)
    80003f34:	0080                	addi	s0,sp,64
    80003f36:	8aaa                	mv	s5,a0
  acquire(&log[dev].lock);
    80003f38:	0a800913          	li	s2,168
    80003f3c:	032507b3          	mul	a5,a0,s2
    80003f40:	0001e917          	auipc	s2,0x1e
    80003f44:	a5890913          	addi	s2,s2,-1448 # 80021998 <log>
    80003f48:	993e                	add	s2,s2,a5
    80003f4a:	854a                	mv	a0,s2
    80003f4c:	ffffd097          	auipc	ra,0xffffd
    80003f50:	b9e080e7          	jalr	-1122(ra) # 80000aea <acquire>
    if(log[dev].committing){
    80003f54:	0001e997          	auipc	s3,0x1e
    80003f58:	a4498993          	addi	s3,s3,-1468 # 80021998 <log>
    80003f5c:	84ca                	mv	s1,s2
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003f5e:	4a79                	li	s4,30
    80003f60:	a039                	j	80003f6e <begin_op+0x4a>
      sleep(&log, &log[dev].lock);
    80003f62:	85ca                	mv	a1,s2
    80003f64:	854e                	mv	a0,s3
    80003f66:	ffffe097          	auipc	ra,0xffffe
    80003f6a:	0f8080e7          	jalr	248(ra) # 8000205e <sleep>
    if(log[dev].committing){
    80003f6e:	50dc                	lw	a5,36(s1)
    80003f70:	fbed                	bnez	a5,80003f62 <begin_op+0x3e>
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003f72:	509c                	lw	a5,32(s1)
    80003f74:	0017871b          	addiw	a4,a5,1
    80003f78:	0007069b          	sext.w	a3,a4
    80003f7c:	0027179b          	slliw	a5,a4,0x2
    80003f80:	9fb9                	addw	a5,a5,a4
    80003f82:	0017979b          	slliw	a5,a5,0x1
    80003f86:	54d8                	lw	a4,44(s1)
    80003f88:	9fb9                	addw	a5,a5,a4
    80003f8a:	00fa5963          	bge	s4,a5,80003f9c <begin_op+0x78>
      sleep(&log, &log[dev].lock);
    80003f8e:	85ca                	mv	a1,s2
    80003f90:	854e                	mv	a0,s3
    80003f92:	ffffe097          	auipc	ra,0xffffe
    80003f96:	0cc080e7          	jalr	204(ra) # 8000205e <sleep>
    80003f9a:	bfd1                	j	80003f6e <begin_op+0x4a>
      log[dev].outstanding += 1;
    80003f9c:	0a800513          	li	a0,168
    80003fa0:	02aa8ab3          	mul	s5,s5,a0
    80003fa4:	0001e797          	auipc	a5,0x1e
    80003fa8:	9f478793          	addi	a5,a5,-1548 # 80021998 <log>
    80003fac:	9abe                	add	s5,s5,a5
    80003fae:	02daa023          	sw	a3,32(s5)
      release(&log[dev].lock);
    80003fb2:	854a                	mv	a0,s2
    80003fb4:	ffffd097          	auipc	ra,0xffffd
    80003fb8:	b9e080e7          	jalr	-1122(ra) # 80000b52 <release>
}
    80003fbc:	70e2                	ld	ra,56(sp)
    80003fbe:	7442                	ld	s0,48(sp)
    80003fc0:	74a2                	ld	s1,40(sp)
    80003fc2:	7902                	ld	s2,32(sp)
    80003fc4:	69e2                	ld	s3,24(sp)
    80003fc6:	6a42                	ld	s4,16(sp)
    80003fc8:	6aa2                	ld	s5,8(sp)
    80003fca:	6121                	addi	sp,sp,64
    80003fcc:	8082                	ret

0000000080003fce <end_op>:
{
    80003fce:	7179                	addi	sp,sp,-48
    80003fd0:	f406                	sd	ra,40(sp)
    80003fd2:	f022                	sd	s0,32(sp)
    80003fd4:	ec26                	sd	s1,24(sp)
    80003fd6:	e84a                	sd	s2,16(sp)
    80003fd8:	e44e                	sd	s3,8(sp)
    80003fda:	1800                	addi	s0,sp,48
    80003fdc:	892a                	mv	s2,a0
  acquire(&log[dev].lock);
    80003fde:	0a800493          	li	s1,168
    80003fe2:	029507b3          	mul	a5,a0,s1
    80003fe6:	0001e497          	auipc	s1,0x1e
    80003fea:	9b248493          	addi	s1,s1,-1614 # 80021998 <log>
    80003fee:	94be                	add	s1,s1,a5
    80003ff0:	8526                	mv	a0,s1
    80003ff2:	ffffd097          	auipc	ra,0xffffd
    80003ff6:	af8080e7          	jalr	-1288(ra) # 80000aea <acquire>
  log[dev].outstanding -= 1;
    80003ffa:	509c                	lw	a5,32(s1)
    80003ffc:	37fd                	addiw	a5,a5,-1
    80003ffe:	0007871b          	sext.w	a4,a5
    80004002:	d09c                	sw	a5,32(s1)
  if(log[dev].committing)
    80004004:	50dc                	lw	a5,36(s1)
    80004006:	e3ad                	bnez	a5,80004068 <end_op+0x9a>
  if(log[dev].outstanding == 0){
    80004008:	eb25                	bnez	a4,80004078 <end_op+0xaa>
    log[dev].committing = 1;
    8000400a:	0a800993          	li	s3,168
    8000400e:	033907b3          	mul	a5,s2,s3
    80004012:	0001e997          	auipc	s3,0x1e
    80004016:	98698993          	addi	s3,s3,-1658 # 80021998 <log>
    8000401a:	99be                	add	s3,s3,a5
    8000401c:	4785                	li	a5,1
    8000401e:	02f9a223          	sw	a5,36(s3)
  release(&log[dev].lock);
    80004022:	8526                	mv	a0,s1
    80004024:	ffffd097          	auipc	ra,0xffffd
    80004028:	b2e080e7          	jalr	-1234(ra) # 80000b52 <release>

static void
commit(int dev)
{
  if (log[dev].lh.n > 0) {
    8000402c:	02c9a783          	lw	a5,44(s3)
    80004030:	06f04863          	bgtz	a5,800040a0 <end_op+0xd2>
    acquire(&log[dev].lock);
    80004034:	8526                	mv	a0,s1
    80004036:	ffffd097          	auipc	ra,0xffffd
    8000403a:	ab4080e7          	jalr	-1356(ra) # 80000aea <acquire>
    log[dev].committing = 0;
    8000403e:	0001e517          	auipc	a0,0x1e
    80004042:	95a50513          	addi	a0,a0,-1702 # 80021998 <log>
    80004046:	0a800793          	li	a5,168
    8000404a:	02f90933          	mul	s2,s2,a5
    8000404e:	992a                	add	s2,s2,a0
    80004050:	02092223          	sw	zero,36(s2)
    wakeup(&log);
    80004054:	ffffe097          	auipc	ra,0xffffe
    80004058:	190080e7          	jalr	400(ra) # 800021e4 <wakeup>
    release(&log[dev].lock);
    8000405c:	8526                	mv	a0,s1
    8000405e:	ffffd097          	auipc	ra,0xffffd
    80004062:	af4080e7          	jalr	-1292(ra) # 80000b52 <release>
}
    80004066:	a035                	j	80004092 <end_op+0xc4>
    panic("log[dev].committing");
    80004068:	00003517          	auipc	a0,0x3
    8000406c:	58850513          	addi	a0,a0,1416 # 800075f0 <userret+0x560>
    80004070:	ffffc097          	auipc	ra,0xffffc
    80004074:	4de080e7          	jalr	1246(ra) # 8000054e <panic>
    wakeup(&log);
    80004078:	0001e517          	auipc	a0,0x1e
    8000407c:	92050513          	addi	a0,a0,-1760 # 80021998 <log>
    80004080:	ffffe097          	auipc	ra,0xffffe
    80004084:	164080e7          	jalr	356(ra) # 800021e4 <wakeup>
  release(&log[dev].lock);
    80004088:	8526                	mv	a0,s1
    8000408a:	ffffd097          	auipc	ra,0xffffd
    8000408e:	ac8080e7          	jalr	-1336(ra) # 80000b52 <release>
}
    80004092:	70a2                	ld	ra,40(sp)
    80004094:	7402                	ld	s0,32(sp)
    80004096:	64e2                	ld	s1,24(sp)
    80004098:	6942                	ld	s2,16(sp)
    8000409a:	69a2                	ld	s3,8(sp)
    8000409c:	6145                	addi	sp,sp,48
    8000409e:	8082                	ret
    write_log(dev);     // Write modified blocks from cache to log
    800040a0:	854a                	mv	a0,s2
    800040a2:	00000097          	auipc	ra,0x0
    800040a6:	c2a080e7          	jalr	-982(ra) # 80003ccc <write_log>
    write_head(dev);    // Write header to disk -- the real commit
    800040aa:	854a                	mv	a0,s2
    800040ac:	00000097          	auipc	ra,0x0
    800040b0:	b96080e7          	jalr	-1130(ra) # 80003c42 <write_head>
    install_trans(dev); // Now install writes to home locations
    800040b4:	854a                	mv	a0,s2
    800040b6:	00000097          	auipc	ra,0x0
    800040ba:	cd8080e7          	jalr	-808(ra) # 80003d8e <install_trans>
    log[dev].lh.n = 0;
    800040be:	0a800793          	li	a5,168
    800040c2:	02f90733          	mul	a4,s2,a5
    800040c6:	0001e797          	auipc	a5,0x1e
    800040ca:	8d278793          	addi	a5,a5,-1838 # 80021998 <log>
    800040ce:	97ba                	add	a5,a5,a4
    800040d0:	0207a623          	sw	zero,44(a5)
    write_head(dev);    // Erase the transaction from the log
    800040d4:	854a                	mv	a0,s2
    800040d6:	00000097          	auipc	ra,0x0
    800040da:	b6c080e7          	jalr	-1172(ra) # 80003c42 <write_head>
    800040de:	bf99                	j	80004034 <end_op+0x66>

00000000800040e0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800040e0:	7179                	addi	sp,sp,-48
    800040e2:	f406                	sd	ra,40(sp)
    800040e4:	f022                	sd	s0,32(sp)
    800040e6:	ec26                	sd	s1,24(sp)
    800040e8:	e84a                	sd	s2,16(sp)
    800040ea:	e44e                	sd	s3,8(sp)
    800040ec:	e052                	sd	s4,0(sp)
    800040ee:	1800                	addi	s0,sp,48
  int i;

  int dev = b->dev;
    800040f0:	00852903          	lw	s2,8(a0)
  if (log[dev].lh.n >= LOGSIZE || log[dev].lh.n >= log[dev].size - 1)
    800040f4:	0a800793          	li	a5,168
    800040f8:	02f90733          	mul	a4,s2,a5
    800040fc:	0001e797          	auipc	a5,0x1e
    80004100:	89c78793          	addi	a5,a5,-1892 # 80021998 <log>
    80004104:	97ba                	add	a5,a5,a4
    80004106:	57d4                	lw	a3,44(a5)
    80004108:	47f5                	li	a5,29
    8000410a:	0ad7cc63          	blt	a5,a3,800041c2 <log_write+0xe2>
    8000410e:	89aa                	mv	s3,a0
    80004110:	0001e797          	auipc	a5,0x1e
    80004114:	88878793          	addi	a5,a5,-1912 # 80021998 <log>
    80004118:	97ba                	add	a5,a5,a4
    8000411a:	4fdc                	lw	a5,28(a5)
    8000411c:	37fd                	addiw	a5,a5,-1
    8000411e:	0af6d263          	bge	a3,a5,800041c2 <log_write+0xe2>
    panic("too big a transaction");
  if (log[dev].outstanding < 1)
    80004122:	0a800793          	li	a5,168
    80004126:	02f90733          	mul	a4,s2,a5
    8000412a:	0001e797          	auipc	a5,0x1e
    8000412e:	86e78793          	addi	a5,a5,-1938 # 80021998 <log>
    80004132:	97ba                	add	a5,a5,a4
    80004134:	539c                	lw	a5,32(a5)
    80004136:	08f05e63          	blez	a5,800041d2 <log_write+0xf2>
    panic("log_write outside of trans");

  acquire(&log[dev].lock);
    8000413a:	0a800793          	li	a5,168
    8000413e:	02f904b3          	mul	s1,s2,a5
    80004142:	0001ea17          	auipc	s4,0x1e
    80004146:	856a0a13          	addi	s4,s4,-1962 # 80021998 <log>
    8000414a:	9a26                	add	s4,s4,s1
    8000414c:	8552                	mv	a0,s4
    8000414e:	ffffd097          	auipc	ra,0xffffd
    80004152:	99c080e7          	jalr	-1636(ra) # 80000aea <acquire>
  for (i = 0; i < log[dev].lh.n; i++) {
    80004156:	02ca2603          	lw	a2,44(s4)
    8000415a:	08c05463          	blez	a2,800041e2 <log_write+0x102>
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    8000415e:	00c9a583          	lw	a1,12(s3)
    80004162:	0001e797          	auipc	a5,0x1e
    80004166:	86678793          	addi	a5,a5,-1946 # 800219c8 <log+0x30>
    8000416a:	97a6                	add	a5,a5,s1
  for (i = 0; i < log[dev].lh.n; i++) {
    8000416c:	4701                	li	a4,0
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    8000416e:	4394                	lw	a3,0(a5)
    80004170:	06b68a63          	beq	a3,a1,800041e4 <log_write+0x104>
  for (i = 0; i < log[dev].lh.n; i++) {
    80004174:	2705                	addiw	a4,a4,1
    80004176:	0791                	addi	a5,a5,4
    80004178:	fec71be3          	bne	a4,a2,8000416e <log_write+0x8e>
      break;
  }
  log[dev].lh.block[i] = b->blockno;
    8000417c:	02a00793          	li	a5,42
    80004180:	02f907b3          	mul	a5,s2,a5
    80004184:	97b2                	add	a5,a5,a2
    80004186:	07a1                	addi	a5,a5,8
    80004188:	078a                	slli	a5,a5,0x2
    8000418a:	0001e717          	auipc	a4,0x1e
    8000418e:	80e70713          	addi	a4,a4,-2034 # 80021998 <log>
    80004192:	97ba                	add	a5,a5,a4
    80004194:	00c9a703          	lw	a4,12(s3)
    80004198:	cb98                	sw	a4,16(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    bpin(b);
    8000419a:	854e                	mv	a0,s3
    8000419c:	fffff097          	auipc	ra,0xfffff
    800041a0:	cac080e7          	jalr	-852(ra) # 80002e48 <bpin>
    log[dev].lh.n++;
    800041a4:	0a800793          	li	a5,168
    800041a8:	02f90933          	mul	s2,s2,a5
    800041ac:	0001d797          	auipc	a5,0x1d
    800041b0:	7ec78793          	addi	a5,a5,2028 # 80021998 <log>
    800041b4:	993e                	add	s2,s2,a5
    800041b6:	02c92783          	lw	a5,44(s2)
    800041ba:	2785                	addiw	a5,a5,1
    800041bc:	02f92623          	sw	a5,44(s2)
    800041c0:	a099                	j	80004206 <log_write+0x126>
    panic("too big a transaction");
    800041c2:	00003517          	auipc	a0,0x3
    800041c6:	44650513          	addi	a0,a0,1094 # 80007608 <userret+0x578>
    800041ca:	ffffc097          	auipc	ra,0xffffc
    800041ce:	384080e7          	jalr	900(ra) # 8000054e <panic>
    panic("log_write outside of trans");
    800041d2:	00003517          	auipc	a0,0x3
    800041d6:	44e50513          	addi	a0,a0,1102 # 80007620 <userret+0x590>
    800041da:	ffffc097          	auipc	ra,0xffffc
    800041de:	374080e7          	jalr	884(ra) # 8000054e <panic>
  for (i = 0; i < log[dev].lh.n; i++) {
    800041e2:	4701                	li	a4,0
  log[dev].lh.block[i] = b->blockno;
    800041e4:	02a00793          	li	a5,42
    800041e8:	02f907b3          	mul	a5,s2,a5
    800041ec:	97ba                	add	a5,a5,a4
    800041ee:	07a1                	addi	a5,a5,8
    800041f0:	078a                	slli	a5,a5,0x2
    800041f2:	0001d697          	auipc	a3,0x1d
    800041f6:	7a668693          	addi	a3,a3,1958 # 80021998 <log>
    800041fa:	97b6                	add	a5,a5,a3
    800041fc:	00c9a683          	lw	a3,12(s3)
    80004200:	cb94                	sw	a3,16(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    80004202:	f8e60ce3          	beq	a2,a4,8000419a <log_write+0xba>
  }
  release(&log[dev].lock);
    80004206:	8552                	mv	a0,s4
    80004208:	ffffd097          	auipc	ra,0xffffd
    8000420c:	94a080e7          	jalr	-1718(ra) # 80000b52 <release>
}
    80004210:	70a2                	ld	ra,40(sp)
    80004212:	7402                	ld	s0,32(sp)
    80004214:	64e2                	ld	s1,24(sp)
    80004216:	6942                	ld	s2,16(sp)
    80004218:	69a2                	ld	s3,8(sp)
    8000421a:	6a02                	ld	s4,0(sp)
    8000421c:	6145                	addi	sp,sp,48
    8000421e:	8082                	ret

0000000080004220 <crash_op>:

// crash before commit or after commit
void
crash_op(int dev, int docommit)
{
    80004220:	7179                	addi	sp,sp,-48
    80004222:	f406                	sd	ra,40(sp)
    80004224:	f022                	sd	s0,32(sp)
    80004226:	ec26                	sd	s1,24(sp)
    80004228:	e84a                	sd	s2,16(sp)
    8000422a:	e44e                	sd	s3,8(sp)
    8000422c:	1800                	addi	s0,sp,48
    8000422e:	84aa                	mv	s1,a0
    80004230:	89ae                	mv	s3,a1
  int do_commit = 0;
    
  acquire(&log[dev].lock);
    80004232:	0a800913          	li	s2,168
    80004236:	032507b3          	mul	a5,a0,s2
    8000423a:	0001d917          	auipc	s2,0x1d
    8000423e:	75e90913          	addi	s2,s2,1886 # 80021998 <log>
    80004242:	993e                	add	s2,s2,a5
    80004244:	854a                	mv	a0,s2
    80004246:	ffffd097          	auipc	ra,0xffffd
    8000424a:	8a4080e7          	jalr	-1884(ra) # 80000aea <acquire>

  if (dev < 0 || dev >= NDISK)
    8000424e:	0004871b          	sext.w	a4,s1
    80004252:	4785                	li	a5,1
    80004254:	0ae7e063          	bltu	a5,a4,800042f4 <crash_op+0xd4>
    panic("end_op: invalid disk");
  if(log[dev].outstanding == 0)
    80004258:	0a800793          	li	a5,168
    8000425c:	02f48733          	mul	a4,s1,a5
    80004260:	0001d797          	auipc	a5,0x1d
    80004264:	73878793          	addi	a5,a5,1848 # 80021998 <log>
    80004268:	97ba                	add	a5,a5,a4
    8000426a:	539c                	lw	a5,32(a5)
    8000426c:	cfc1                	beqz	a5,80004304 <crash_op+0xe4>
    panic("end_op: already closed");
  log[dev].outstanding -= 1;
    8000426e:	37fd                	addiw	a5,a5,-1
    80004270:	0007861b          	sext.w	a2,a5
    80004274:	0a800713          	li	a4,168
    80004278:	02e486b3          	mul	a3,s1,a4
    8000427c:	0001d717          	auipc	a4,0x1d
    80004280:	71c70713          	addi	a4,a4,1820 # 80021998 <log>
    80004284:	9736                	add	a4,a4,a3
    80004286:	d31c                	sw	a5,32(a4)
  if(log[dev].committing)
    80004288:	535c                	lw	a5,36(a4)
    8000428a:	e7c9                	bnez	a5,80004314 <crash_op+0xf4>
    panic("log[dev].committing");
  if(log[dev].outstanding == 0){
    8000428c:	ee41                	bnez	a2,80004324 <crash_op+0x104>
    do_commit = 1;
    log[dev].committing = 1;
    8000428e:	0a800793          	li	a5,168
    80004292:	02f48733          	mul	a4,s1,a5
    80004296:	0001d797          	auipc	a5,0x1d
    8000429a:	70278793          	addi	a5,a5,1794 # 80021998 <log>
    8000429e:	97ba                	add	a5,a5,a4
    800042a0:	4705                	li	a4,1
    800042a2:	d3d8                	sw	a4,36(a5)
  }
  
  release(&log[dev].lock);
    800042a4:	854a                	mv	a0,s2
    800042a6:	ffffd097          	auipc	ra,0xffffd
    800042aa:	8ac080e7          	jalr	-1876(ra) # 80000b52 <release>

  if(docommit & do_commit){
    800042ae:	0019f993          	andi	s3,s3,1
    800042b2:	06098e63          	beqz	s3,8000432e <crash_op+0x10e>
    printf("crash_op: commit\n");
    800042b6:	00003517          	auipc	a0,0x3
    800042ba:	3ba50513          	addi	a0,a0,954 # 80007670 <userret+0x5e0>
    800042be:	ffffc097          	auipc	ra,0xffffc
    800042c2:	2da080e7          	jalr	730(ra) # 80000598 <printf>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.

    if (log[dev].lh.n > 0) {
    800042c6:	0a800793          	li	a5,168
    800042ca:	02f48733          	mul	a4,s1,a5
    800042ce:	0001d797          	auipc	a5,0x1d
    800042d2:	6ca78793          	addi	a5,a5,1738 # 80021998 <log>
    800042d6:	97ba                	add	a5,a5,a4
    800042d8:	57dc                	lw	a5,44(a5)
    800042da:	04f05a63          	blez	a5,8000432e <crash_op+0x10e>
      write_log(dev);     // Write modified blocks from cache to log
    800042de:	8526                	mv	a0,s1
    800042e0:	00000097          	auipc	ra,0x0
    800042e4:	9ec080e7          	jalr	-1556(ra) # 80003ccc <write_log>
      write_head(dev);    // Write header to disk -- the real commit
    800042e8:	8526                	mv	a0,s1
    800042ea:	00000097          	auipc	ra,0x0
    800042ee:	958080e7          	jalr	-1704(ra) # 80003c42 <write_head>
    800042f2:	a835                	j	8000432e <crash_op+0x10e>
    panic("end_op: invalid disk");
    800042f4:	00003517          	auipc	a0,0x3
    800042f8:	34c50513          	addi	a0,a0,844 # 80007640 <userret+0x5b0>
    800042fc:	ffffc097          	auipc	ra,0xffffc
    80004300:	252080e7          	jalr	594(ra) # 8000054e <panic>
    panic("end_op: already closed");
    80004304:	00003517          	auipc	a0,0x3
    80004308:	35450513          	addi	a0,a0,852 # 80007658 <userret+0x5c8>
    8000430c:	ffffc097          	auipc	ra,0xffffc
    80004310:	242080e7          	jalr	578(ra) # 8000054e <panic>
    panic("log[dev].committing");
    80004314:	00003517          	auipc	a0,0x3
    80004318:	2dc50513          	addi	a0,a0,732 # 800075f0 <userret+0x560>
    8000431c:	ffffc097          	auipc	ra,0xffffc
    80004320:	232080e7          	jalr	562(ra) # 8000054e <panic>
  release(&log[dev].lock);
    80004324:	854a                	mv	a0,s2
    80004326:	ffffd097          	auipc	ra,0xffffd
    8000432a:	82c080e7          	jalr	-2004(ra) # 80000b52 <release>
    }
  }
  panic("crashed file system; please restart xv6 and run crashtest\n");
    8000432e:	00003517          	auipc	a0,0x3
    80004332:	35a50513          	addi	a0,a0,858 # 80007688 <userret+0x5f8>
    80004336:	ffffc097          	auipc	ra,0xffffc
    8000433a:	218080e7          	jalr	536(ra) # 8000054e <panic>

000000008000433e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000433e:	1101                	addi	sp,sp,-32
    80004340:	ec06                	sd	ra,24(sp)
    80004342:	e822                	sd	s0,16(sp)
    80004344:	e426                	sd	s1,8(sp)
    80004346:	e04a                	sd	s2,0(sp)
    80004348:	1000                	addi	s0,sp,32
    8000434a:	84aa                	mv	s1,a0
    8000434c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000434e:	00003597          	auipc	a1,0x3
    80004352:	37a58593          	addi	a1,a1,890 # 800076c8 <userret+0x638>
    80004356:	0521                	addi	a0,a0,8
    80004358:	ffffc097          	auipc	ra,0xffffc
    8000435c:	680080e7          	jalr	1664(ra) # 800009d8 <initlock>
  lk->name = name;
    80004360:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004364:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004368:	0204a423          	sw	zero,40(s1)
}
    8000436c:	60e2                	ld	ra,24(sp)
    8000436e:	6442                	ld	s0,16(sp)
    80004370:	64a2                	ld	s1,8(sp)
    80004372:	6902                	ld	s2,0(sp)
    80004374:	6105                	addi	sp,sp,32
    80004376:	8082                	ret

0000000080004378 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004378:	1101                	addi	sp,sp,-32
    8000437a:	ec06                	sd	ra,24(sp)
    8000437c:	e822                	sd	s0,16(sp)
    8000437e:	e426                	sd	s1,8(sp)
    80004380:	e04a                	sd	s2,0(sp)
    80004382:	1000                	addi	s0,sp,32
    80004384:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004386:	00850913          	addi	s2,a0,8
    8000438a:	854a                	mv	a0,s2
    8000438c:	ffffc097          	auipc	ra,0xffffc
    80004390:	75e080e7          	jalr	1886(ra) # 80000aea <acquire>
  while (lk->locked) {
    80004394:	409c                	lw	a5,0(s1)
    80004396:	cb89                	beqz	a5,800043a8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004398:	85ca                	mv	a1,s2
    8000439a:	8526                	mv	a0,s1
    8000439c:	ffffe097          	auipc	ra,0xffffe
    800043a0:	cc2080e7          	jalr	-830(ra) # 8000205e <sleep>
  while (lk->locked) {
    800043a4:	409c                	lw	a5,0(s1)
    800043a6:	fbed                	bnez	a5,80004398 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800043a8:	4785                	li	a5,1
    800043aa:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800043ac:	ffffd097          	auipc	ra,0xffffd
    800043b0:	4a0080e7          	jalr	1184(ra) # 8000184c <myproc>
    800043b4:	5d1c                	lw	a5,56(a0)
    800043b6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800043b8:	854a                	mv	a0,s2
    800043ba:	ffffc097          	auipc	ra,0xffffc
    800043be:	798080e7          	jalr	1944(ra) # 80000b52 <release>
}
    800043c2:	60e2                	ld	ra,24(sp)
    800043c4:	6442                	ld	s0,16(sp)
    800043c6:	64a2                	ld	s1,8(sp)
    800043c8:	6902                	ld	s2,0(sp)
    800043ca:	6105                	addi	sp,sp,32
    800043cc:	8082                	ret

00000000800043ce <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800043ce:	1101                	addi	sp,sp,-32
    800043d0:	ec06                	sd	ra,24(sp)
    800043d2:	e822                	sd	s0,16(sp)
    800043d4:	e426                	sd	s1,8(sp)
    800043d6:	e04a                	sd	s2,0(sp)
    800043d8:	1000                	addi	s0,sp,32
    800043da:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043dc:	00850913          	addi	s2,a0,8
    800043e0:	854a                	mv	a0,s2
    800043e2:	ffffc097          	auipc	ra,0xffffc
    800043e6:	708080e7          	jalr	1800(ra) # 80000aea <acquire>
  lk->locked = 0;
    800043ea:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043ee:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800043f2:	8526                	mv	a0,s1
    800043f4:	ffffe097          	auipc	ra,0xffffe
    800043f8:	df0080e7          	jalr	-528(ra) # 800021e4 <wakeup>
  release(&lk->lk);
    800043fc:	854a                	mv	a0,s2
    800043fe:	ffffc097          	auipc	ra,0xffffc
    80004402:	754080e7          	jalr	1876(ra) # 80000b52 <release>
}
    80004406:	60e2                	ld	ra,24(sp)
    80004408:	6442                	ld	s0,16(sp)
    8000440a:	64a2                	ld	s1,8(sp)
    8000440c:	6902                	ld	s2,0(sp)
    8000440e:	6105                	addi	sp,sp,32
    80004410:	8082                	ret

0000000080004412 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004412:	7179                	addi	sp,sp,-48
    80004414:	f406                	sd	ra,40(sp)
    80004416:	f022                	sd	s0,32(sp)
    80004418:	ec26                	sd	s1,24(sp)
    8000441a:	e84a                	sd	s2,16(sp)
    8000441c:	e44e                	sd	s3,8(sp)
    8000441e:	1800                	addi	s0,sp,48
    80004420:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004422:	00850913          	addi	s2,a0,8
    80004426:	854a                	mv	a0,s2
    80004428:	ffffc097          	auipc	ra,0xffffc
    8000442c:	6c2080e7          	jalr	1730(ra) # 80000aea <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004430:	409c                	lw	a5,0(s1)
    80004432:	ef99                	bnez	a5,80004450 <holdingsleep+0x3e>
    80004434:	4481                	li	s1,0
  release(&lk->lk);
    80004436:	854a                	mv	a0,s2
    80004438:	ffffc097          	auipc	ra,0xffffc
    8000443c:	71a080e7          	jalr	1818(ra) # 80000b52 <release>
  return r;
}
    80004440:	8526                	mv	a0,s1
    80004442:	70a2                	ld	ra,40(sp)
    80004444:	7402                	ld	s0,32(sp)
    80004446:	64e2                	ld	s1,24(sp)
    80004448:	6942                	ld	s2,16(sp)
    8000444a:	69a2                	ld	s3,8(sp)
    8000444c:	6145                	addi	sp,sp,48
    8000444e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004450:	0284a983          	lw	s3,40(s1)
    80004454:	ffffd097          	auipc	ra,0xffffd
    80004458:	3f8080e7          	jalr	1016(ra) # 8000184c <myproc>
    8000445c:	5d04                	lw	s1,56(a0)
    8000445e:	413484b3          	sub	s1,s1,s3
    80004462:	0014b493          	seqz	s1,s1
    80004466:	bfc1                	j	80004436 <holdingsleep+0x24>

0000000080004468 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004468:	1141                	addi	sp,sp,-16
    8000446a:	e406                	sd	ra,8(sp)
    8000446c:	e022                	sd	s0,0(sp)
    8000446e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004470:	00003597          	auipc	a1,0x3
    80004474:	26858593          	addi	a1,a1,616 # 800076d8 <userret+0x648>
    80004478:	0001d517          	auipc	a0,0x1d
    8000447c:	71050513          	addi	a0,a0,1808 # 80021b88 <ftable>
    80004480:	ffffc097          	auipc	ra,0xffffc
    80004484:	558080e7          	jalr	1368(ra) # 800009d8 <initlock>
}
    80004488:	60a2                	ld	ra,8(sp)
    8000448a:	6402                	ld	s0,0(sp)
    8000448c:	0141                	addi	sp,sp,16
    8000448e:	8082                	ret

0000000080004490 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004490:	1101                	addi	sp,sp,-32
    80004492:	ec06                	sd	ra,24(sp)
    80004494:	e822                	sd	s0,16(sp)
    80004496:	e426                	sd	s1,8(sp)
    80004498:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000449a:	0001d517          	auipc	a0,0x1d
    8000449e:	6ee50513          	addi	a0,a0,1774 # 80021b88 <ftable>
    800044a2:	ffffc097          	auipc	ra,0xffffc
    800044a6:	648080e7          	jalr	1608(ra) # 80000aea <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800044aa:	0001d497          	auipc	s1,0x1d
    800044ae:	6f648493          	addi	s1,s1,1782 # 80021ba0 <ftable+0x18>
    800044b2:	0001e717          	auipc	a4,0x1e
    800044b6:	68e70713          	addi	a4,a4,1678 # 80022b40 <ftable+0xfb8>
    if(f->ref == 0){
    800044ba:	40dc                	lw	a5,4(s1)
    800044bc:	cf99                	beqz	a5,800044da <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800044be:	02848493          	addi	s1,s1,40
    800044c2:	fee49ce3          	bne	s1,a4,800044ba <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800044c6:	0001d517          	auipc	a0,0x1d
    800044ca:	6c250513          	addi	a0,a0,1730 # 80021b88 <ftable>
    800044ce:	ffffc097          	auipc	ra,0xffffc
    800044d2:	684080e7          	jalr	1668(ra) # 80000b52 <release>
  return 0;
    800044d6:	4481                	li	s1,0
    800044d8:	a819                	j	800044ee <filealloc+0x5e>
      f->ref = 1;
    800044da:	4785                	li	a5,1
    800044dc:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800044de:	0001d517          	auipc	a0,0x1d
    800044e2:	6aa50513          	addi	a0,a0,1706 # 80021b88 <ftable>
    800044e6:	ffffc097          	auipc	ra,0xffffc
    800044ea:	66c080e7          	jalr	1644(ra) # 80000b52 <release>
}
    800044ee:	8526                	mv	a0,s1
    800044f0:	60e2                	ld	ra,24(sp)
    800044f2:	6442                	ld	s0,16(sp)
    800044f4:	64a2                	ld	s1,8(sp)
    800044f6:	6105                	addi	sp,sp,32
    800044f8:	8082                	ret

00000000800044fa <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800044fa:	1101                	addi	sp,sp,-32
    800044fc:	ec06                	sd	ra,24(sp)
    800044fe:	e822                	sd	s0,16(sp)
    80004500:	e426                	sd	s1,8(sp)
    80004502:	1000                	addi	s0,sp,32
    80004504:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004506:	0001d517          	auipc	a0,0x1d
    8000450a:	68250513          	addi	a0,a0,1666 # 80021b88 <ftable>
    8000450e:	ffffc097          	auipc	ra,0xffffc
    80004512:	5dc080e7          	jalr	1500(ra) # 80000aea <acquire>
  if(f->ref < 1)
    80004516:	40dc                	lw	a5,4(s1)
    80004518:	02f05263          	blez	a5,8000453c <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000451c:	2785                	addiw	a5,a5,1
    8000451e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004520:	0001d517          	auipc	a0,0x1d
    80004524:	66850513          	addi	a0,a0,1640 # 80021b88 <ftable>
    80004528:	ffffc097          	auipc	ra,0xffffc
    8000452c:	62a080e7          	jalr	1578(ra) # 80000b52 <release>
  return f;
}
    80004530:	8526                	mv	a0,s1
    80004532:	60e2                	ld	ra,24(sp)
    80004534:	6442                	ld	s0,16(sp)
    80004536:	64a2                	ld	s1,8(sp)
    80004538:	6105                	addi	sp,sp,32
    8000453a:	8082                	ret
    panic("filedup");
    8000453c:	00003517          	auipc	a0,0x3
    80004540:	1a450513          	addi	a0,a0,420 # 800076e0 <userret+0x650>
    80004544:	ffffc097          	auipc	ra,0xffffc
    80004548:	00a080e7          	jalr	10(ra) # 8000054e <panic>

000000008000454c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000454c:	7139                	addi	sp,sp,-64
    8000454e:	fc06                	sd	ra,56(sp)
    80004550:	f822                	sd	s0,48(sp)
    80004552:	f426                	sd	s1,40(sp)
    80004554:	f04a                	sd	s2,32(sp)
    80004556:	ec4e                	sd	s3,24(sp)
    80004558:	e852                	sd	s4,16(sp)
    8000455a:	e456                	sd	s5,8(sp)
    8000455c:	0080                	addi	s0,sp,64
    8000455e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004560:	0001d517          	auipc	a0,0x1d
    80004564:	62850513          	addi	a0,a0,1576 # 80021b88 <ftable>
    80004568:	ffffc097          	auipc	ra,0xffffc
    8000456c:	582080e7          	jalr	1410(ra) # 80000aea <acquire>
  if(f->ref < 1)
    80004570:	40dc                	lw	a5,4(s1)
    80004572:	06f05563          	blez	a5,800045dc <fileclose+0x90>
    panic("fileclose");
  if(--f->ref > 0){
    80004576:	37fd                	addiw	a5,a5,-1
    80004578:	0007871b          	sext.w	a4,a5
    8000457c:	c0dc                	sw	a5,4(s1)
    8000457e:	06e04763          	bgtz	a4,800045ec <fileclose+0xa0>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004582:	0004a903          	lw	s2,0(s1)
    80004586:	0094ca83          	lbu	s5,9(s1)
    8000458a:	0104ba03          	ld	s4,16(s1)
    8000458e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004592:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004596:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000459a:	0001d517          	auipc	a0,0x1d
    8000459e:	5ee50513          	addi	a0,a0,1518 # 80021b88 <ftable>
    800045a2:	ffffc097          	auipc	ra,0xffffc
    800045a6:	5b0080e7          	jalr	1456(ra) # 80000b52 <release>

  if(ff.type == FD_PIPE){
    800045aa:	4785                	li	a5,1
    800045ac:	06f90163          	beq	s2,a5,8000460e <fileclose+0xc2>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800045b0:	3979                	addiw	s2,s2,-2
    800045b2:	4785                	li	a5,1
    800045b4:	0527e463          	bltu	a5,s2,800045fc <fileclose+0xb0>
    begin_op(ff.ip->dev);
    800045b8:	0009a503          	lw	a0,0(s3)
    800045bc:	00000097          	auipc	ra,0x0
    800045c0:	968080e7          	jalr	-1688(ra) # 80003f24 <begin_op>
    iput(ff.ip);
    800045c4:	854e                	mv	a0,s3
    800045c6:	fffff097          	auipc	ra,0xfffff
    800045ca:	fc4080e7          	jalr	-60(ra) # 8000358a <iput>
    end_op(ff.ip->dev);
    800045ce:	0009a503          	lw	a0,0(s3)
    800045d2:	00000097          	auipc	ra,0x0
    800045d6:	9fc080e7          	jalr	-1540(ra) # 80003fce <end_op>
    800045da:	a00d                	j	800045fc <fileclose+0xb0>
    panic("fileclose");
    800045dc:	00003517          	auipc	a0,0x3
    800045e0:	10c50513          	addi	a0,a0,268 # 800076e8 <userret+0x658>
    800045e4:	ffffc097          	auipc	ra,0xffffc
    800045e8:	f6a080e7          	jalr	-150(ra) # 8000054e <panic>
    release(&ftable.lock);
    800045ec:	0001d517          	auipc	a0,0x1d
    800045f0:	59c50513          	addi	a0,a0,1436 # 80021b88 <ftable>
    800045f4:	ffffc097          	auipc	ra,0xffffc
    800045f8:	55e080e7          	jalr	1374(ra) # 80000b52 <release>
  }
}
    800045fc:	70e2                	ld	ra,56(sp)
    800045fe:	7442                	ld	s0,48(sp)
    80004600:	74a2                	ld	s1,40(sp)
    80004602:	7902                	ld	s2,32(sp)
    80004604:	69e2                	ld	s3,24(sp)
    80004606:	6a42                	ld	s4,16(sp)
    80004608:	6aa2                	ld	s5,8(sp)
    8000460a:	6121                	addi	sp,sp,64
    8000460c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000460e:	85d6                	mv	a1,s5
    80004610:	8552                	mv	a0,s4
    80004612:	00000097          	auipc	ra,0x0
    80004616:	348080e7          	jalr	840(ra) # 8000495a <pipeclose>
    8000461a:	b7cd                	j	800045fc <fileclose+0xb0>

000000008000461c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000461c:	715d                	addi	sp,sp,-80
    8000461e:	e486                	sd	ra,72(sp)
    80004620:	e0a2                	sd	s0,64(sp)
    80004622:	fc26                	sd	s1,56(sp)
    80004624:	f84a                	sd	s2,48(sp)
    80004626:	f44e                	sd	s3,40(sp)
    80004628:	0880                	addi	s0,sp,80
    8000462a:	84aa                	mv	s1,a0
    8000462c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000462e:	ffffd097          	auipc	ra,0xffffd
    80004632:	21e080e7          	jalr	542(ra) # 8000184c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004636:	409c                	lw	a5,0(s1)
    80004638:	37f9                	addiw	a5,a5,-2
    8000463a:	4705                	li	a4,1
    8000463c:	04f76763          	bltu	a4,a5,8000468a <filestat+0x6e>
    80004640:	892a                	mv	s2,a0
    ilock(f->ip);
    80004642:	6c88                	ld	a0,24(s1)
    80004644:	fffff097          	auipc	ra,0xfffff
    80004648:	e38080e7          	jalr	-456(ra) # 8000347c <ilock>
    stati(f->ip, &st);
    8000464c:	fb840593          	addi	a1,s0,-72
    80004650:	6c88                	ld	a0,24(s1)
    80004652:	fffff097          	auipc	ra,0xfffff
    80004656:	090080e7          	jalr	144(ra) # 800036e2 <stati>
    iunlock(f->ip);
    8000465a:	6c88                	ld	a0,24(s1)
    8000465c:	fffff097          	auipc	ra,0xfffff
    80004660:	ee2080e7          	jalr	-286(ra) # 8000353e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004664:	46e1                	li	a3,24
    80004666:	fb840613          	addi	a2,s0,-72
    8000466a:	85ce                	mv	a1,s3
    8000466c:	05093503          	ld	a0,80(s2)
    80004670:	ffffd097          	auipc	ra,0xffffd
    80004674:	f02080e7          	jalr	-254(ra) # 80001572 <copyout>
    80004678:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000467c:	60a6                	ld	ra,72(sp)
    8000467e:	6406                	ld	s0,64(sp)
    80004680:	74e2                	ld	s1,56(sp)
    80004682:	7942                	ld	s2,48(sp)
    80004684:	79a2                	ld	s3,40(sp)
    80004686:	6161                	addi	sp,sp,80
    80004688:	8082                	ret
  return -1;
    8000468a:	557d                	li	a0,-1
    8000468c:	bfc5                	j	8000467c <filestat+0x60>

000000008000468e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000468e:	7179                	addi	sp,sp,-48
    80004690:	f406                	sd	ra,40(sp)
    80004692:	f022                	sd	s0,32(sp)
    80004694:	ec26                	sd	s1,24(sp)
    80004696:	e84a                	sd	s2,16(sp)
    80004698:	e44e                	sd	s3,8(sp)
    8000469a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000469c:	00854783          	lbu	a5,8(a0)
    800046a0:	cfc1                	beqz	a5,80004738 <fileread+0xaa>
    800046a2:	84aa                	mv	s1,a0
    800046a4:	89ae                	mv	s3,a1
    800046a6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800046a8:	411c                	lw	a5,0(a0)
    800046aa:	4705                	li	a4,1
    800046ac:	04e78963          	beq	a5,a4,800046fe <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046b0:	470d                	li	a4,3
    800046b2:	04e78d63          	beq	a5,a4,8000470c <fileread+0x7e>
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800046b6:	4709                	li	a4,2
    800046b8:	06e79863          	bne	a5,a4,80004728 <fileread+0x9a>
    ilock(f->ip);
    800046bc:	6d08                	ld	a0,24(a0)
    800046be:	fffff097          	auipc	ra,0xfffff
    800046c2:	dbe080e7          	jalr	-578(ra) # 8000347c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800046c6:	874a                	mv	a4,s2
    800046c8:	5094                	lw	a3,32(s1)
    800046ca:	864e                	mv	a2,s3
    800046cc:	4585                	li	a1,1
    800046ce:	6c88                	ld	a0,24(s1)
    800046d0:	fffff097          	auipc	ra,0xfffff
    800046d4:	03c080e7          	jalr	60(ra) # 8000370c <readi>
    800046d8:	892a                	mv	s2,a0
    800046da:	00a05563          	blez	a0,800046e4 <fileread+0x56>
      f->off += r;
    800046de:	509c                	lw	a5,32(s1)
    800046e0:	9fa9                	addw	a5,a5,a0
    800046e2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800046e4:	6c88                	ld	a0,24(s1)
    800046e6:	fffff097          	auipc	ra,0xfffff
    800046ea:	e58080e7          	jalr	-424(ra) # 8000353e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800046ee:	854a                	mv	a0,s2
    800046f0:	70a2                	ld	ra,40(sp)
    800046f2:	7402                	ld	s0,32(sp)
    800046f4:	64e2                	ld	s1,24(sp)
    800046f6:	6942                	ld	s2,16(sp)
    800046f8:	69a2                	ld	s3,8(sp)
    800046fa:	6145                	addi	sp,sp,48
    800046fc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800046fe:	6908                	ld	a0,16(a0)
    80004700:	00000097          	auipc	ra,0x0
    80004704:	3de080e7          	jalr	990(ra) # 80004ade <piperead>
    80004708:	892a                	mv	s2,a0
    8000470a:	b7d5                	j	800046ee <fileread+0x60>
    r = devsw[f->major].read(1, addr, n);
    8000470c:	02451783          	lh	a5,36(a0)
    80004710:	00479713          	slli	a4,a5,0x4
    80004714:	0001d797          	auipc	a5,0x1d
    80004718:	3d478793          	addi	a5,a5,980 # 80021ae8 <devsw>
    8000471c:	97ba                	add	a5,a5,a4
    8000471e:	639c                	ld	a5,0(a5)
    80004720:	4505                	li	a0,1
    80004722:	9782                	jalr	a5
    80004724:	892a                	mv	s2,a0
    80004726:	b7e1                	j	800046ee <fileread+0x60>
    panic("fileread");
    80004728:	00003517          	auipc	a0,0x3
    8000472c:	fd050513          	addi	a0,a0,-48 # 800076f8 <userret+0x668>
    80004730:	ffffc097          	auipc	ra,0xffffc
    80004734:	e1e080e7          	jalr	-482(ra) # 8000054e <panic>
    return -1;
    80004738:	597d                	li	s2,-1
    8000473a:	bf55                	j	800046ee <fileread+0x60>

000000008000473c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000473c:	00954783          	lbu	a5,9(a0)
    80004740:	12078e63          	beqz	a5,8000487c <filewrite+0x140>
{
    80004744:	715d                	addi	sp,sp,-80
    80004746:	e486                	sd	ra,72(sp)
    80004748:	e0a2                	sd	s0,64(sp)
    8000474a:	fc26                	sd	s1,56(sp)
    8000474c:	f84a                	sd	s2,48(sp)
    8000474e:	f44e                	sd	s3,40(sp)
    80004750:	f052                	sd	s4,32(sp)
    80004752:	ec56                	sd	s5,24(sp)
    80004754:	e85a                	sd	s6,16(sp)
    80004756:	e45e                	sd	s7,8(sp)
    80004758:	e062                	sd	s8,0(sp)
    8000475a:	0880                	addi	s0,sp,80
    8000475c:	84aa                	mv	s1,a0
    8000475e:	8aae                	mv	s5,a1
    80004760:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004762:	411c                	lw	a5,0(a0)
    80004764:	4705                	li	a4,1
    80004766:	02e78263          	beq	a5,a4,8000478a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000476a:	470d                	li	a4,3
    8000476c:	02e78563          	beq	a5,a4,80004796 <filewrite+0x5a>
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004770:	4709                	li	a4,2
    80004772:	0ee79d63          	bne	a5,a4,8000486c <filewrite+0x130>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004776:	0ec05763          	blez	a2,80004864 <filewrite+0x128>
    int i = 0;
    8000477a:	4981                	li	s3,0
    8000477c:	6b05                	lui	s6,0x1
    8000477e:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004782:	6b85                	lui	s7,0x1
    80004784:	c00b8b9b          	addiw	s7,s7,-1024
    80004788:	a051                	j	8000480c <filewrite+0xd0>
    ret = pipewrite(f->pipe, addr, n);
    8000478a:	6908                	ld	a0,16(a0)
    8000478c:	00000097          	auipc	ra,0x0
    80004790:	23e080e7          	jalr	574(ra) # 800049ca <pipewrite>
    80004794:	a065                	j	8000483c <filewrite+0x100>
    ret = devsw[f->major].write(1, addr, n);
    80004796:	02451783          	lh	a5,36(a0)
    8000479a:	00479713          	slli	a4,a5,0x4
    8000479e:	0001d797          	auipc	a5,0x1d
    800047a2:	34a78793          	addi	a5,a5,842 # 80021ae8 <devsw>
    800047a6:	97ba                	add	a5,a5,a4
    800047a8:	679c                	ld	a5,8(a5)
    800047aa:	4505                	li	a0,1
    800047ac:	9782                	jalr	a5
    800047ae:	a079                	j	8000483c <filewrite+0x100>
    800047b0:	00090c1b          	sext.w	s8,s2
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op(f->ip->dev);
    800047b4:	6c9c                	ld	a5,24(s1)
    800047b6:	4388                	lw	a0,0(a5)
    800047b8:	fffff097          	auipc	ra,0xfffff
    800047bc:	76c080e7          	jalr	1900(ra) # 80003f24 <begin_op>
      ilock(f->ip);
    800047c0:	6c88                	ld	a0,24(s1)
    800047c2:	fffff097          	auipc	ra,0xfffff
    800047c6:	cba080e7          	jalr	-838(ra) # 8000347c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800047ca:	8762                	mv	a4,s8
    800047cc:	5094                	lw	a3,32(s1)
    800047ce:	01598633          	add	a2,s3,s5
    800047d2:	4585                	li	a1,1
    800047d4:	6c88                	ld	a0,24(s1)
    800047d6:	fffff097          	auipc	ra,0xfffff
    800047da:	02a080e7          	jalr	42(ra) # 80003800 <writei>
    800047de:	892a                	mv	s2,a0
    800047e0:	02a05e63          	blez	a0,8000481c <filewrite+0xe0>
        f->off += r;
    800047e4:	509c                	lw	a5,32(s1)
    800047e6:	9fa9                	addw	a5,a5,a0
    800047e8:	d09c                	sw	a5,32(s1)
      iunlock(f->ip);
    800047ea:	6c88                	ld	a0,24(s1)
    800047ec:	fffff097          	auipc	ra,0xfffff
    800047f0:	d52080e7          	jalr	-686(ra) # 8000353e <iunlock>
      end_op(f->ip->dev);
    800047f4:	6c9c                	ld	a5,24(s1)
    800047f6:	4388                	lw	a0,0(a5)
    800047f8:	fffff097          	auipc	ra,0xfffff
    800047fc:	7d6080e7          	jalr	2006(ra) # 80003fce <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004800:	052c1a63          	bne	s8,s2,80004854 <filewrite+0x118>
        panic("short filewrite");
      i += r;
    80004804:	013909bb          	addw	s3,s2,s3
    while(i < n){
    80004808:	0349d763          	bge	s3,s4,80004836 <filewrite+0xfa>
      int n1 = n - i;
    8000480c:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004810:	893e                	mv	s2,a5
    80004812:	2781                	sext.w	a5,a5
    80004814:	f8fb5ee3          	bge	s6,a5,800047b0 <filewrite+0x74>
    80004818:	895e                	mv	s2,s7
    8000481a:	bf59                	j	800047b0 <filewrite+0x74>
      iunlock(f->ip);
    8000481c:	6c88                	ld	a0,24(s1)
    8000481e:	fffff097          	auipc	ra,0xfffff
    80004822:	d20080e7          	jalr	-736(ra) # 8000353e <iunlock>
      end_op(f->ip->dev);
    80004826:	6c9c                	ld	a5,24(s1)
    80004828:	4388                	lw	a0,0(a5)
    8000482a:	fffff097          	auipc	ra,0xfffff
    8000482e:	7a4080e7          	jalr	1956(ra) # 80003fce <end_op>
      if(r < 0)
    80004832:	fc0957e3          	bgez	s2,80004800 <filewrite+0xc4>
    }
    ret = (i == n ? n : -1);
    80004836:	8552                	mv	a0,s4
    80004838:	033a1863          	bne	s4,s3,80004868 <filewrite+0x12c>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000483c:	60a6                	ld	ra,72(sp)
    8000483e:	6406                	ld	s0,64(sp)
    80004840:	74e2                	ld	s1,56(sp)
    80004842:	7942                	ld	s2,48(sp)
    80004844:	79a2                	ld	s3,40(sp)
    80004846:	7a02                	ld	s4,32(sp)
    80004848:	6ae2                	ld	s5,24(sp)
    8000484a:	6b42                	ld	s6,16(sp)
    8000484c:	6ba2                	ld	s7,8(sp)
    8000484e:	6c02                	ld	s8,0(sp)
    80004850:	6161                	addi	sp,sp,80
    80004852:	8082                	ret
        panic("short filewrite");
    80004854:	00003517          	auipc	a0,0x3
    80004858:	eb450513          	addi	a0,a0,-332 # 80007708 <userret+0x678>
    8000485c:	ffffc097          	auipc	ra,0xffffc
    80004860:	cf2080e7          	jalr	-782(ra) # 8000054e <panic>
    int i = 0;
    80004864:	4981                	li	s3,0
    80004866:	bfc1                	j	80004836 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    80004868:	557d                	li	a0,-1
    8000486a:	bfc9                	j	8000483c <filewrite+0x100>
    panic("filewrite");
    8000486c:	00003517          	auipc	a0,0x3
    80004870:	eac50513          	addi	a0,a0,-340 # 80007718 <userret+0x688>
    80004874:	ffffc097          	auipc	ra,0xffffc
    80004878:	cda080e7          	jalr	-806(ra) # 8000054e <panic>
    return -1;
    8000487c:	557d                	li	a0,-1
}
    8000487e:	8082                	ret

0000000080004880 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004880:	7179                	addi	sp,sp,-48
    80004882:	f406                	sd	ra,40(sp)
    80004884:	f022                	sd	s0,32(sp)
    80004886:	ec26                	sd	s1,24(sp)
    80004888:	e84a                	sd	s2,16(sp)
    8000488a:	e44e                	sd	s3,8(sp)
    8000488c:	e052                	sd	s4,0(sp)
    8000488e:	1800                	addi	s0,sp,48
    80004890:	84aa                	mv	s1,a0
    80004892:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004894:	0005b023          	sd	zero,0(a1)
    80004898:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000489c:	00000097          	auipc	ra,0x0
    800048a0:	bf4080e7          	jalr	-1036(ra) # 80004490 <filealloc>
    800048a4:	e088                	sd	a0,0(s1)
    800048a6:	c551                	beqz	a0,80004932 <pipealloc+0xb2>
    800048a8:	00000097          	auipc	ra,0x0
    800048ac:	be8080e7          	jalr	-1048(ra) # 80004490 <filealloc>
    800048b0:	00aa3023          	sd	a0,0(s4)
    800048b4:	c92d                	beqz	a0,80004926 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800048b6:	ffffc097          	auipc	ra,0xffffc
    800048ba:	0c2080e7          	jalr	194(ra) # 80000978 <kalloc>
    800048be:	892a                	mv	s2,a0
    800048c0:	c125                	beqz	a0,80004920 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800048c2:	4985                	li	s3,1
    800048c4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800048c8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800048cc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800048d0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800048d4:	00003597          	auipc	a1,0x3
    800048d8:	e5458593          	addi	a1,a1,-428 # 80007728 <userret+0x698>
    800048dc:	ffffc097          	auipc	ra,0xffffc
    800048e0:	0fc080e7          	jalr	252(ra) # 800009d8 <initlock>
  (*f0)->type = FD_PIPE;
    800048e4:	609c                	ld	a5,0(s1)
    800048e6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800048ea:	609c                	ld	a5,0(s1)
    800048ec:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800048f0:	609c                	ld	a5,0(s1)
    800048f2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800048f6:	609c                	ld	a5,0(s1)
    800048f8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800048fc:	000a3783          	ld	a5,0(s4)
    80004900:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004904:	000a3783          	ld	a5,0(s4)
    80004908:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000490c:	000a3783          	ld	a5,0(s4)
    80004910:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004914:	000a3783          	ld	a5,0(s4)
    80004918:	0127b823          	sd	s2,16(a5)
  return 0;
    8000491c:	4501                	li	a0,0
    8000491e:	a025                	j	80004946 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004920:	6088                	ld	a0,0(s1)
    80004922:	e501                	bnez	a0,8000492a <pipealloc+0xaa>
    80004924:	a039                	j	80004932 <pipealloc+0xb2>
    80004926:	6088                	ld	a0,0(s1)
    80004928:	c51d                	beqz	a0,80004956 <pipealloc+0xd6>
    fileclose(*f0);
    8000492a:	00000097          	auipc	ra,0x0
    8000492e:	c22080e7          	jalr	-990(ra) # 8000454c <fileclose>
  if(*f1)
    80004932:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004936:	557d                	li	a0,-1
  if(*f1)
    80004938:	c799                	beqz	a5,80004946 <pipealloc+0xc6>
    fileclose(*f1);
    8000493a:	853e                	mv	a0,a5
    8000493c:	00000097          	auipc	ra,0x0
    80004940:	c10080e7          	jalr	-1008(ra) # 8000454c <fileclose>
  return -1;
    80004944:	557d                	li	a0,-1
}
    80004946:	70a2                	ld	ra,40(sp)
    80004948:	7402                	ld	s0,32(sp)
    8000494a:	64e2                	ld	s1,24(sp)
    8000494c:	6942                	ld	s2,16(sp)
    8000494e:	69a2                	ld	s3,8(sp)
    80004950:	6a02                	ld	s4,0(sp)
    80004952:	6145                	addi	sp,sp,48
    80004954:	8082                	ret
  return -1;
    80004956:	557d                	li	a0,-1
    80004958:	b7fd                	j	80004946 <pipealloc+0xc6>

000000008000495a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000495a:	1101                	addi	sp,sp,-32
    8000495c:	ec06                	sd	ra,24(sp)
    8000495e:	e822                	sd	s0,16(sp)
    80004960:	e426                	sd	s1,8(sp)
    80004962:	e04a                	sd	s2,0(sp)
    80004964:	1000                	addi	s0,sp,32
    80004966:	84aa                	mv	s1,a0
    80004968:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000496a:	ffffc097          	auipc	ra,0xffffc
    8000496e:	180080e7          	jalr	384(ra) # 80000aea <acquire>
  if(writable){
    80004972:	02090d63          	beqz	s2,800049ac <pipeclose+0x52>
    pi->writeopen = 0;
    80004976:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000497a:	21848513          	addi	a0,s1,536
    8000497e:	ffffe097          	auipc	ra,0xffffe
    80004982:	866080e7          	jalr	-1946(ra) # 800021e4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004986:	2204b783          	ld	a5,544(s1)
    8000498a:	eb95                	bnez	a5,800049be <pipeclose+0x64>
    release(&pi->lock);
    8000498c:	8526                	mv	a0,s1
    8000498e:	ffffc097          	auipc	ra,0xffffc
    80004992:	1c4080e7          	jalr	452(ra) # 80000b52 <release>
    kfree((char*)pi);
    80004996:	8526                	mv	a0,s1
    80004998:	ffffc097          	auipc	ra,0xffffc
    8000499c:	ecc080e7          	jalr	-308(ra) # 80000864 <kfree>
  } else
    release(&pi->lock);
}
    800049a0:	60e2                	ld	ra,24(sp)
    800049a2:	6442                	ld	s0,16(sp)
    800049a4:	64a2                	ld	s1,8(sp)
    800049a6:	6902                	ld	s2,0(sp)
    800049a8:	6105                	addi	sp,sp,32
    800049aa:	8082                	ret
    pi->readopen = 0;
    800049ac:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800049b0:	21c48513          	addi	a0,s1,540
    800049b4:	ffffe097          	auipc	ra,0xffffe
    800049b8:	830080e7          	jalr	-2000(ra) # 800021e4 <wakeup>
    800049bc:	b7e9                	j	80004986 <pipeclose+0x2c>
    release(&pi->lock);
    800049be:	8526                	mv	a0,s1
    800049c0:	ffffc097          	auipc	ra,0xffffc
    800049c4:	192080e7          	jalr	402(ra) # 80000b52 <release>
}
    800049c8:	bfe1                	j	800049a0 <pipeclose+0x46>

00000000800049ca <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800049ca:	7159                	addi	sp,sp,-112
    800049cc:	f486                	sd	ra,104(sp)
    800049ce:	f0a2                	sd	s0,96(sp)
    800049d0:	eca6                	sd	s1,88(sp)
    800049d2:	e8ca                	sd	s2,80(sp)
    800049d4:	e4ce                	sd	s3,72(sp)
    800049d6:	e0d2                	sd	s4,64(sp)
    800049d8:	fc56                	sd	s5,56(sp)
    800049da:	f85a                	sd	s6,48(sp)
    800049dc:	f45e                	sd	s7,40(sp)
    800049de:	f062                	sd	s8,32(sp)
    800049e0:	ec66                	sd	s9,24(sp)
    800049e2:	1880                	addi	s0,sp,112
    800049e4:	84aa                	mv	s1,a0
    800049e6:	8b2e                	mv	s6,a1
    800049e8:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    800049ea:	ffffd097          	auipc	ra,0xffffd
    800049ee:	e62080e7          	jalr	-414(ra) # 8000184c <myproc>
    800049f2:	8c2a                	mv	s8,a0

  acquire(&pi->lock);
    800049f4:	8526                	mv	a0,s1
    800049f6:	ffffc097          	auipc	ra,0xffffc
    800049fa:	0f4080e7          	jalr	244(ra) # 80000aea <acquire>
  for(i = 0; i < n; i++){
    800049fe:	0b505063          	blez	s5,80004a9e <pipewrite+0xd4>
    80004a02:	8926                	mv	s2,s1
    80004a04:	fffa8b9b          	addiw	s7,s5,-1
    80004a08:	1b82                	slli	s7,s7,0x20
    80004a0a:	020bdb93          	srli	s7,s7,0x20
    80004a0e:	001b0793          	addi	a5,s6,1
    80004a12:	9bbe                	add	s7,s7,a5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004a14:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004a18:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a1c:	5cfd                	li	s9,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004a1e:	2184a783          	lw	a5,536(s1)
    80004a22:	21c4a703          	lw	a4,540(s1)
    80004a26:	2007879b          	addiw	a5,a5,512
    80004a2a:	02f71e63          	bne	a4,a5,80004a66 <pipewrite+0x9c>
      if(pi->readopen == 0 || myproc()->killed){
    80004a2e:	2204a783          	lw	a5,544(s1)
    80004a32:	c3d9                	beqz	a5,80004ab8 <pipewrite+0xee>
    80004a34:	ffffd097          	auipc	ra,0xffffd
    80004a38:	e18080e7          	jalr	-488(ra) # 8000184c <myproc>
    80004a3c:	591c                	lw	a5,48(a0)
    80004a3e:	efad                	bnez	a5,80004ab8 <pipewrite+0xee>
      wakeup(&pi->nread);
    80004a40:	8552                	mv	a0,s4
    80004a42:	ffffd097          	auipc	ra,0xffffd
    80004a46:	7a2080e7          	jalr	1954(ra) # 800021e4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004a4a:	85ca                	mv	a1,s2
    80004a4c:	854e                	mv	a0,s3
    80004a4e:	ffffd097          	auipc	ra,0xffffd
    80004a52:	610080e7          	jalr	1552(ra) # 8000205e <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004a56:	2184a783          	lw	a5,536(s1)
    80004a5a:	21c4a703          	lw	a4,540(s1)
    80004a5e:	2007879b          	addiw	a5,a5,512
    80004a62:	fcf706e3          	beq	a4,a5,80004a2e <pipewrite+0x64>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a66:	4685                	li	a3,1
    80004a68:	865a                	mv	a2,s6
    80004a6a:	f9f40593          	addi	a1,s0,-97
    80004a6e:	050c3503          	ld	a0,80(s8)
    80004a72:	ffffd097          	auipc	ra,0xffffd
    80004a76:	b92080e7          	jalr	-1134(ra) # 80001604 <copyin>
    80004a7a:	03950263          	beq	a0,s9,80004a9e <pipewrite+0xd4>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004a7e:	21c4a783          	lw	a5,540(s1)
    80004a82:	0017871b          	addiw	a4,a5,1
    80004a86:	20e4ae23          	sw	a4,540(s1)
    80004a8a:	1ff7f793          	andi	a5,a5,511
    80004a8e:	97a6                	add	a5,a5,s1
    80004a90:	f9f44703          	lbu	a4,-97(s0)
    80004a94:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004a98:	0b05                	addi	s6,s6,1
    80004a9a:	f97b12e3          	bne	s6,s7,80004a1e <pipewrite+0x54>
  }
  wakeup(&pi->nread);
    80004a9e:	21848513          	addi	a0,s1,536
    80004aa2:	ffffd097          	auipc	ra,0xffffd
    80004aa6:	742080e7          	jalr	1858(ra) # 800021e4 <wakeup>
  release(&pi->lock);
    80004aaa:	8526                	mv	a0,s1
    80004aac:	ffffc097          	auipc	ra,0xffffc
    80004ab0:	0a6080e7          	jalr	166(ra) # 80000b52 <release>
  return n;
    80004ab4:	8556                	mv	a0,s5
    80004ab6:	a039                	j	80004ac4 <pipewrite+0xfa>
        release(&pi->lock);
    80004ab8:	8526                	mv	a0,s1
    80004aba:	ffffc097          	auipc	ra,0xffffc
    80004abe:	098080e7          	jalr	152(ra) # 80000b52 <release>
        return -1;
    80004ac2:	557d                	li	a0,-1
}
    80004ac4:	70a6                	ld	ra,104(sp)
    80004ac6:	7406                	ld	s0,96(sp)
    80004ac8:	64e6                	ld	s1,88(sp)
    80004aca:	6946                	ld	s2,80(sp)
    80004acc:	69a6                	ld	s3,72(sp)
    80004ace:	6a06                	ld	s4,64(sp)
    80004ad0:	7ae2                	ld	s5,56(sp)
    80004ad2:	7b42                	ld	s6,48(sp)
    80004ad4:	7ba2                	ld	s7,40(sp)
    80004ad6:	7c02                	ld	s8,32(sp)
    80004ad8:	6ce2                	ld	s9,24(sp)
    80004ada:	6165                	addi	sp,sp,112
    80004adc:	8082                	ret

0000000080004ade <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004ade:	715d                	addi	sp,sp,-80
    80004ae0:	e486                	sd	ra,72(sp)
    80004ae2:	e0a2                	sd	s0,64(sp)
    80004ae4:	fc26                	sd	s1,56(sp)
    80004ae6:	f84a                	sd	s2,48(sp)
    80004ae8:	f44e                	sd	s3,40(sp)
    80004aea:	f052                	sd	s4,32(sp)
    80004aec:	ec56                	sd	s5,24(sp)
    80004aee:	e85a                	sd	s6,16(sp)
    80004af0:	0880                	addi	s0,sp,80
    80004af2:	84aa                	mv	s1,a0
    80004af4:	892e                	mv	s2,a1
    80004af6:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80004af8:	ffffd097          	auipc	ra,0xffffd
    80004afc:	d54080e7          	jalr	-684(ra) # 8000184c <myproc>
    80004b00:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80004b02:	8b26                	mv	s6,s1
    80004b04:	8526                	mv	a0,s1
    80004b06:	ffffc097          	auipc	ra,0xffffc
    80004b0a:	fe4080e7          	jalr	-28(ra) # 80000aea <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b0e:	2184a703          	lw	a4,536(s1)
    80004b12:	21c4a783          	lw	a5,540(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b16:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b1a:	02f71763          	bne	a4,a5,80004b48 <piperead+0x6a>
    80004b1e:	2244a783          	lw	a5,548(s1)
    80004b22:	c39d                	beqz	a5,80004b48 <piperead+0x6a>
    if(myproc()->killed){
    80004b24:	ffffd097          	auipc	ra,0xffffd
    80004b28:	d28080e7          	jalr	-728(ra) # 8000184c <myproc>
    80004b2c:	591c                	lw	a5,48(a0)
    80004b2e:	ebc1                	bnez	a5,80004bbe <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b30:	85da                	mv	a1,s6
    80004b32:	854e                	mv	a0,s3
    80004b34:	ffffd097          	auipc	ra,0xffffd
    80004b38:	52a080e7          	jalr	1322(ra) # 8000205e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b3c:	2184a703          	lw	a4,536(s1)
    80004b40:	21c4a783          	lw	a5,540(s1)
    80004b44:	fcf70de3          	beq	a4,a5,80004b1e <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b48:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004b4a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b4c:	05405363          	blez	s4,80004b92 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004b50:	2184a783          	lw	a5,536(s1)
    80004b54:	21c4a703          	lw	a4,540(s1)
    80004b58:	02f70d63          	beq	a4,a5,80004b92 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004b5c:	0017871b          	addiw	a4,a5,1
    80004b60:	20e4ac23          	sw	a4,536(s1)
    80004b64:	1ff7f793          	andi	a5,a5,511
    80004b68:	97a6                	add	a5,a5,s1
    80004b6a:	0187c783          	lbu	a5,24(a5)
    80004b6e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004b72:	4685                	li	a3,1
    80004b74:	fbf40613          	addi	a2,s0,-65
    80004b78:	85ca                	mv	a1,s2
    80004b7a:	050ab503          	ld	a0,80(s5)
    80004b7e:	ffffd097          	auipc	ra,0xffffd
    80004b82:	9f4080e7          	jalr	-1548(ra) # 80001572 <copyout>
    80004b86:	01650663          	beq	a0,s6,80004b92 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b8a:	2985                	addiw	s3,s3,1
    80004b8c:	0905                	addi	s2,s2,1
    80004b8e:	fd3a11e3          	bne	s4,s3,80004b50 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004b92:	21c48513          	addi	a0,s1,540
    80004b96:	ffffd097          	auipc	ra,0xffffd
    80004b9a:	64e080e7          	jalr	1614(ra) # 800021e4 <wakeup>
  release(&pi->lock);
    80004b9e:	8526                	mv	a0,s1
    80004ba0:	ffffc097          	auipc	ra,0xffffc
    80004ba4:	fb2080e7          	jalr	-78(ra) # 80000b52 <release>
  return i;
}
    80004ba8:	854e                	mv	a0,s3
    80004baa:	60a6                	ld	ra,72(sp)
    80004bac:	6406                	ld	s0,64(sp)
    80004bae:	74e2                	ld	s1,56(sp)
    80004bb0:	7942                	ld	s2,48(sp)
    80004bb2:	79a2                	ld	s3,40(sp)
    80004bb4:	7a02                	ld	s4,32(sp)
    80004bb6:	6ae2                	ld	s5,24(sp)
    80004bb8:	6b42                	ld	s6,16(sp)
    80004bba:	6161                	addi	sp,sp,80
    80004bbc:	8082                	ret
      release(&pi->lock);
    80004bbe:	8526                	mv	a0,s1
    80004bc0:	ffffc097          	auipc	ra,0xffffc
    80004bc4:	f92080e7          	jalr	-110(ra) # 80000b52 <release>
      return -1;
    80004bc8:	59fd                	li	s3,-1
    80004bca:	bff9                	j	80004ba8 <piperead+0xca>

0000000080004bcc <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004bcc:	df010113          	addi	sp,sp,-528
    80004bd0:	20113423          	sd	ra,520(sp)
    80004bd4:	20813023          	sd	s0,512(sp)
    80004bd8:	ffa6                	sd	s1,504(sp)
    80004bda:	fbca                	sd	s2,496(sp)
    80004bdc:	f7ce                	sd	s3,488(sp)
    80004bde:	f3d2                	sd	s4,480(sp)
    80004be0:	efd6                	sd	s5,472(sp)
    80004be2:	ebda                	sd	s6,464(sp)
    80004be4:	e7de                	sd	s7,456(sp)
    80004be6:	e3e2                	sd	s8,448(sp)
    80004be8:	ff66                	sd	s9,440(sp)
    80004bea:	fb6a                	sd	s10,432(sp)
    80004bec:	f76e                	sd	s11,424(sp)
    80004bee:	0c00                	addi	s0,sp,528
    80004bf0:	84aa                	mv	s1,a0
    80004bf2:	dea43c23          	sd	a0,-520(s0)
    80004bf6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004bfa:	ffffd097          	auipc	ra,0xffffd
    80004bfe:	c52080e7          	jalr	-942(ra) # 8000184c <myproc>
    80004c02:	892a                	mv	s2,a0

  begin_op(ROOTDEV);
    80004c04:	4501                	li	a0,0
    80004c06:	fffff097          	auipc	ra,0xfffff
    80004c0a:	31e080e7          	jalr	798(ra) # 80003f24 <begin_op>

  if((ip = namei(path)) == 0){
    80004c0e:	8526                	mv	a0,s1
    80004c10:	fffff097          	auipc	ra,0xfffff
    80004c14:	ff8080e7          	jalr	-8(ra) # 80003c08 <namei>
    80004c18:	c935                	beqz	a0,80004c8c <exec+0xc0>
    80004c1a:	84aa                	mv	s1,a0
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    80004c1c:	fffff097          	auipc	ra,0xfffff
    80004c20:	860080e7          	jalr	-1952(ra) # 8000347c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004c24:	04000713          	li	a4,64
    80004c28:	4681                	li	a3,0
    80004c2a:	e4840613          	addi	a2,s0,-440
    80004c2e:	4581                	li	a1,0
    80004c30:	8526                	mv	a0,s1
    80004c32:	fffff097          	auipc	ra,0xfffff
    80004c36:	ada080e7          	jalr	-1318(ra) # 8000370c <readi>
    80004c3a:	04000793          	li	a5,64
    80004c3e:	00f51a63          	bne	a0,a5,80004c52 <exec+0x86>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004c42:	e4842703          	lw	a4,-440(s0)
    80004c46:	464c47b7          	lui	a5,0x464c4
    80004c4a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004c4e:	04f70663          	beq	a4,a5,80004c9a <exec+0xce>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004c52:	8526                	mv	a0,s1
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	a66080e7          	jalr	-1434(ra) # 800036ba <iunlockput>
    end_op(ROOTDEV);
    80004c5c:	4501                	li	a0,0
    80004c5e:	fffff097          	auipc	ra,0xfffff
    80004c62:	370080e7          	jalr	880(ra) # 80003fce <end_op>
  }
  return -1;
    80004c66:	557d                	li	a0,-1
}
    80004c68:	20813083          	ld	ra,520(sp)
    80004c6c:	20013403          	ld	s0,512(sp)
    80004c70:	74fe                	ld	s1,504(sp)
    80004c72:	795e                	ld	s2,496(sp)
    80004c74:	79be                	ld	s3,488(sp)
    80004c76:	7a1e                	ld	s4,480(sp)
    80004c78:	6afe                	ld	s5,472(sp)
    80004c7a:	6b5e                	ld	s6,464(sp)
    80004c7c:	6bbe                	ld	s7,456(sp)
    80004c7e:	6c1e                	ld	s8,448(sp)
    80004c80:	7cfa                	ld	s9,440(sp)
    80004c82:	7d5a                	ld	s10,432(sp)
    80004c84:	7dba                	ld	s11,424(sp)
    80004c86:	21010113          	addi	sp,sp,528
    80004c8a:	8082                	ret
    end_op(ROOTDEV);
    80004c8c:	4501                	li	a0,0
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	340080e7          	jalr	832(ra) # 80003fce <end_op>
    return -1;
    80004c96:	557d                	li	a0,-1
    80004c98:	bfc1                	j	80004c68 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004c9a:	854a                	mv	a0,s2
    80004c9c:	ffffd097          	auipc	ra,0xffffd
    80004ca0:	c74080e7          	jalr	-908(ra) # 80001910 <proc_pagetable>
    80004ca4:	8c2a                	mv	s8,a0
    80004ca6:	d555                	beqz	a0,80004c52 <exec+0x86>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004ca8:	e6842983          	lw	s3,-408(s0)
    80004cac:	e8045783          	lhu	a5,-384(s0)
    80004cb0:	c7fd                	beqz	a5,80004d9e <exec+0x1d2>
  sz = 0;
    80004cb2:	e0043423          	sd	zero,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004cb6:	4b81                	li	s7,0
    if(ph.vaddr % PGSIZE != 0)
    80004cb8:	6b05                	lui	s6,0x1
    80004cba:	fffb0793          	addi	a5,s6,-1 # fff <_entry-0x7ffff001>
    80004cbe:	def43823          	sd	a5,-528(s0)
    80004cc2:	a0a5                	j	80004d2a <exec+0x15e>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004cc4:	00003517          	auipc	a0,0x3
    80004cc8:	a6c50513          	addi	a0,a0,-1428 # 80007730 <userret+0x6a0>
    80004ccc:	ffffc097          	auipc	ra,0xffffc
    80004cd0:	882080e7          	jalr	-1918(ra) # 8000054e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004cd4:	8756                	mv	a4,s5
    80004cd6:	012d86bb          	addw	a3,s11,s2
    80004cda:	4581                	li	a1,0
    80004cdc:	8526                	mv	a0,s1
    80004cde:	fffff097          	auipc	ra,0xfffff
    80004ce2:	a2e080e7          	jalr	-1490(ra) # 8000370c <readi>
    80004ce6:	2501                	sext.w	a0,a0
    80004ce8:	10aa9263          	bne	s5,a0,80004dec <exec+0x220>
  for(i = 0; i < sz; i += PGSIZE){
    80004cec:	6785                	lui	a5,0x1
    80004cee:	0127893b          	addw	s2,a5,s2
    80004cf2:	77fd                	lui	a5,0xfffff
    80004cf4:	01478a3b          	addw	s4,a5,s4
    80004cf8:	03997263          	bgeu	s2,s9,80004d1c <exec+0x150>
    pa = walkaddr(pagetable, va + i);
    80004cfc:	02091593          	slli	a1,s2,0x20
    80004d00:	9181                	srli	a1,a1,0x20
    80004d02:	95ea                	add	a1,a1,s10
    80004d04:	8562                	mv	a0,s8
    80004d06:	ffffc097          	auipc	ra,0xffffc
    80004d0a:	2a6080e7          	jalr	678(ra) # 80000fac <walkaddr>
    80004d0e:	862a                	mv	a2,a0
    if(pa == 0)
    80004d10:	d955                	beqz	a0,80004cc4 <exec+0xf8>
      n = PGSIZE;
    80004d12:	8ada                	mv	s5,s6
    if(sz - i < PGSIZE)
    80004d14:	fd6a70e3          	bgeu	s4,s6,80004cd4 <exec+0x108>
      n = sz - i;
    80004d18:	8ad2                	mv	s5,s4
    80004d1a:	bf6d                	j	80004cd4 <exec+0x108>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d1c:	2b85                	addiw	s7,s7,1
    80004d1e:	0389899b          	addiw	s3,s3,56
    80004d22:	e8045783          	lhu	a5,-384(s0)
    80004d26:	06fbde63          	bge	s7,a5,80004da2 <exec+0x1d6>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004d2a:	2981                	sext.w	s3,s3
    80004d2c:	03800713          	li	a4,56
    80004d30:	86ce                	mv	a3,s3
    80004d32:	e1040613          	addi	a2,s0,-496
    80004d36:	4581                	li	a1,0
    80004d38:	8526                	mv	a0,s1
    80004d3a:	fffff097          	auipc	ra,0xfffff
    80004d3e:	9d2080e7          	jalr	-1582(ra) # 8000370c <readi>
    80004d42:	03800793          	li	a5,56
    80004d46:	0af51363          	bne	a0,a5,80004dec <exec+0x220>
    if(ph.type != ELF_PROG_LOAD)
    80004d4a:	e1042783          	lw	a5,-496(s0)
    80004d4e:	4705                	li	a4,1
    80004d50:	fce796e3          	bne	a5,a4,80004d1c <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004d54:	e3843603          	ld	a2,-456(s0)
    80004d58:	e3043783          	ld	a5,-464(s0)
    80004d5c:	08f66863          	bltu	a2,a5,80004dec <exec+0x220>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004d60:	e2043783          	ld	a5,-480(s0)
    80004d64:	963e                	add	a2,a2,a5
    80004d66:	08f66363          	bltu	a2,a5,80004dec <exec+0x220>
    if((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004d6a:	e0843583          	ld	a1,-504(s0)
    80004d6e:	8562                	mv	a0,s8
    80004d70:	ffffc097          	auipc	ra,0xffffc
    80004d74:	628080e7          	jalr	1576(ra) # 80001398 <uvmalloc>
    80004d78:	e0a43423          	sd	a0,-504(s0)
    80004d7c:	c925                	beqz	a0,80004dec <exec+0x220>
    if(ph.vaddr % PGSIZE != 0)
    80004d7e:	e2043d03          	ld	s10,-480(s0)
    80004d82:	df043783          	ld	a5,-528(s0)
    80004d86:	00fd77b3          	and	a5,s10,a5
    80004d8a:	e3ad                	bnez	a5,80004dec <exec+0x220>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004d8c:	e1842d83          	lw	s11,-488(s0)
    80004d90:	e3042c83          	lw	s9,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004d94:	f80c84e3          	beqz	s9,80004d1c <exec+0x150>
    80004d98:	8a66                	mv	s4,s9
    80004d9a:	4901                	li	s2,0
    80004d9c:	b785                	j	80004cfc <exec+0x130>
  sz = 0;
    80004d9e:	e0043423          	sd	zero,-504(s0)
  iunlockput(ip);
    80004da2:	8526                	mv	a0,s1
    80004da4:	fffff097          	auipc	ra,0xfffff
    80004da8:	916080e7          	jalr	-1770(ra) # 800036ba <iunlockput>
  end_op(ROOTDEV);
    80004dac:	4501                	li	a0,0
    80004dae:	fffff097          	auipc	ra,0xfffff
    80004db2:	220080e7          	jalr	544(ra) # 80003fce <end_op>
  p = myproc();
    80004db6:	ffffd097          	auipc	ra,0xffffd
    80004dba:	a96080e7          	jalr	-1386(ra) # 8000184c <myproc>
    80004dbe:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004dc0:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004dc4:	6585                	lui	a1,0x1
    80004dc6:	15fd                	addi	a1,a1,-1
    80004dc8:	e0843783          	ld	a5,-504(s0)
    80004dcc:	00b78b33          	add	s6,a5,a1
    80004dd0:	75fd                	lui	a1,0xfffff
    80004dd2:	00bb75b3          	and	a1,s6,a1
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004dd6:	6609                	lui	a2,0x2
    80004dd8:	962e                	add	a2,a2,a1
    80004dda:	8562                	mv	a0,s8
    80004ddc:	ffffc097          	auipc	ra,0xffffc
    80004de0:	5bc080e7          	jalr	1468(ra) # 80001398 <uvmalloc>
    80004de4:	e0a43423          	sd	a0,-504(s0)
  ip = 0;
    80004de8:	4481                	li	s1,0
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004dea:	ed01                	bnez	a0,80004e02 <exec+0x236>
    proc_freepagetable(pagetable, sz);
    80004dec:	e0843583          	ld	a1,-504(s0)
    80004df0:	8562                	mv	a0,s8
    80004df2:	ffffd097          	auipc	ra,0xffffd
    80004df6:	c1e080e7          	jalr	-994(ra) # 80001a10 <proc_freepagetable>
  if(ip){
    80004dfa:	e4049ce3          	bnez	s1,80004c52 <exec+0x86>
  return -1;
    80004dfe:	557d                	li	a0,-1
    80004e00:	b5a5                	j	80004c68 <exec+0x9c>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004e02:	75f9                	lui	a1,0xffffe
    80004e04:	84aa                	mv	s1,a0
    80004e06:	95aa                	add	a1,a1,a0
    80004e08:	8562                	mv	a0,s8
    80004e0a:	ffffc097          	auipc	ra,0xffffc
    80004e0e:	736080e7          	jalr	1846(ra) # 80001540 <uvmclear>
  stackbase = sp - PGSIZE;
    80004e12:	7afd                	lui	s5,0xfffff
    80004e14:	9aa6                	add	s5,s5,s1
  for(argc = 0; argv[argc]; argc++) {
    80004e16:	e0043783          	ld	a5,-512(s0)
    80004e1a:	6388                	ld	a0,0(a5)
    80004e1c:	c135                	beqz	a0,80004e80 <exec+0x2b4>
    80004e1e:	e8840993          	addi	s3,s0,-376
    80004e22:	f8840c93          	addi	s9,s0,-120
    80004e26:	4901                	li	s2,0
    sp -= strlen(argv[argc]) + 1;
    80004e28:	ffffc097          	auipc	ra,0xffffc
    80004e2c:	f0e080e7          	jalr	-242(ra) # 80000d36 <strlen>
    80004e30:	2505                	addiw	a0,a0,1
    80004e32:	8c89                	sub	s1,s1,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004e34:	98c1                	andi	s1,s1,-16
    if(sp < stackbase)
    80004e36:	0f54ea63          	bltu	s1,s5,80004f2a <exec+0x35e>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004e3a:	e0043b03          	ld	s6,-512(s0)
    80004e3e:	000b3a03          	ld	s4,0(s6)
    80004e42:	8552                	mv	a0,s4
    80004e44:	ffffc097          	auipc	ra,0xffffc
    80004e48:	ef2080e7          	jalr	-270(ra) # 80000d36 <strlen>
    80004e4c:	0015069b          	addiw	a3,a0,1
    80004e50:	8652                	mv	a2,s4
    80004e52:	85a6                	mv	a1,s1
    80004e54:	8562                	mv	a0,s8
    80004e56:	ffffc097          	auipc	ra,0xffffc
    80004e5a:	71c080e7          	jalr	1820(ra) # 80001572 <copyout>
    80004e5e:	0c054863          	bltz	a0,80004f2e <exec+0x362>
    ustack[argc] = sp;
    80004e62:	0099b023          	sd	s1,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004e66:	0905                	addi	s2,s2,1
    80004e68:	008b0793          	addi	a5,s6,8
    80004e6c:	e0f43023          	sd	a5,-512(s0)
    80004e70:	008b3503          	ld	a0,8(s6)
    80004e74:	c909                	beqz	a0,80004e86 <exec+0x2ba>
    if(argc >= MAXARG)
    80004e76:	09a1                	addi	s3,s3,8
    80004e78:	fb3c98e3          	bne	s9,s3,80004e28 <exec+0x25c>
  ip = 0;
    80004e7c:	4481                	li	s1,0
    80004e7e:	b7bd                	j	80004dec <exec+0x220>
  sp = sz;
    80004e80:	e0843483          	ld	s1,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004e84:	4901                	li	s2,0
  ustack[argc] = 0;
    80004e86:	00391793          	slli	a5,s2,0x3
    80004e8a:	f9040713          	addi	a4,s0,-112
    80004e8e:	97ba                	add	a5,a5,a4
    80004e90:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd5eb4>
  sp -= (argc+1) * sizeof(uint64);
    80004e94:	00190693          	addi	a3,s2,1
    80004e98:	068e                	slli	a3,a3,0x3
    80004e9a:	8c95                	sub	s1,s1,a3
  sp -= sp % 16;
    80004e9c:	ff04f993          	andi	s3,s1,-16
  ip = 0;
    80004ea0:	4481                	li	s1,0
  if(sp < stackbase)
    80004ea2:	f559e5e3          	bltu	s3,s5,80004dec <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004ea6:	e8840613          	addi	a2,s0,-376
    80004eaa:	85ce                	mv	a1,s3
    80004eac:	8562                	mv	a0,s8
    80004eae:	ffffc097          	auipc	ra,0xffffc
    80004eb2:	6c4080e7          	jalr	1732(ra) # 80001572 <copyout>
    80004eb6:	06054e63          	bltz	a0,80004f32 <exec+0x366>
  p->tf->a1 = sp;
    80004eba:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004ebe:	0737bc23          	sd	s3,120(a5)
  for(last=s=path; *s; s++)
    80004ec2:	df843783          	ld	a5,-520(s0)
    80004ec6:	0007c703          	lbu	a4,0(a5)
    80004eca:	cf11                	beqz	a4,80004ee6 <exec+0x31a>
    80004ecc:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004ece:	02f00693          	li	a3,47
    80004ed2:	a029                	j	80004edc <exec+0x310>
  for(last=s=path; *s; s++)
    80004ed4:	0785                	addi	a5,a5,1
    80004ed6:	fff7c703          	lbu	a4,-1(a5)
    80004eda:	c711                	beqz	a4,80004ee6 <exec+0x31a>
    if(*s == '/')
    80004edc:	fed71ce3          	bne	a4,a3,80004ed4 <exec+0x308>
      last = s+1;
    80004ee0:	def43c23          	sd	a5,-520(s0)
    80004ee4:	bfc5                	j	80004ed4 <exec+0x308>
  safestrcpy(p->name, last, sizeof(p->name));
    80004ee6:	4641                	li	a2,16
    80004ee8:	df843583          	ld	a1,-520(s0)
    80004eec:	158b8513          	addi	a0,s7,344
    80004ef0:	ffffc097          	auipc	ra,0xffffc
    80004ef4:	e14080e7          	jalr	-492(ra) # 80000d04 <safestrcpy>
  oldpagetable = p->pagetable;
    80004ef8:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004efc:	058bb823          	sd	s8,80(s7)
  p->sz = sz;
    80004f00:	e0843783          	ld	a5,-504(s0)
    80004f04:	04fbb423          	sd	a5,72(s7)
  p->tf->epc = elf.entry;  // initial program counter = main
    80004f08:	058bb783          	ld	a5,88(s7)
    80004f0c:	e6043703          	ld	a4,-416(s0)
    80004f10:	ef98                	sd	a4,24(a5)
  p->tf->sp = sp; // initial stack pointer
    80004f12:	058bb783          	ld	a5,88(s7)
    80004f16:	0337b823          	sd	s3,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004f1a:	85ea                	mv	a1,s10
    80004f1c:	ffffd097          	auipc	ra,0xffffd
    80004f20:	af4080e7          	jalr	-1292(ra) # 80001a10 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004f24:	0009051b          	sext.w	a0,s2
    80004f28:	b381                	j	80004c68 <exec+0x9c>
  ip = 0;
    80004f2a:	4481                	li	s1,0
    80004f2c:	b5c1                	j	80004dec <exec+0x220>
    80004f2e:	4481                	li	s1,0
    80004f30:	bd75                	j	80004dec <exec+0x220>
    80004f32:	4481                	li	s1,0
    80004f34:	bd65                	j	80004dec <exec+0x220>

0000000080004f36 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004f36:	7179                	addi	sp,sp,-48
    80004f38:	f406                	sd	ra,40(sp)
    80004f3a:	f022                	sd	s0,32(sp)
    80004f3c:	ec26                	sd	s1,24(sp)
    80004f3e:	e84a                	sd	s2,16(sp)
    80004f40:	1800                	addi	s0,sp,48
    80004f42:	892e                	mv	s2,a1
    80004f44:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004f46:	fdc40593          	addi	a1,s0,-36
    80004f4a:	ffffe097          	auipc	ra,0xffffe
    80004f4e:	9bc080e7          	jalr	-1604(ra) # 80002906 <argint>
    80004f52:	04054063          	bltz	a0,80004f92 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004f56:	fdc42703          	lw	a4,-36(s0)
    80004f5a:	47bd                	li	a5,15
    80004f5c:	02e7ed63          	bltu	a5,a4,80004f96 <argfd+0x60>
    80004f60:	ffffd097          	auipc	ra,0xffffd
    80004f64:	8ec080e7          	jalr	-1812(ra) # 8000184c <myproc>
    80004f68:	fdc42703          	lw	a4,-36(s0)
    80004f6c:	01a70793          	addi	a5,a4,26
    80004f70:	078e                	slli	a5,a5,0x3
    80004f72:	953e                	add	a0,a0,a5
    80004f74:	611c                	ld	a5,0(a0)
    80004f76:	c395                	beqz	a5,80004f9a <argfd+0x64>
    return -1;
  if(pfd)
    80004f78:	00090463          	beqz	s2,80004f80 <argfd+0x4a>
    *pfd = fd;
    80004f7c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004f80:	4501                	li	a0,0
  if(pf)
    80004f82:	c091                	beqz	s1,80004f86 <argfd+0x50>
    *pf = f;
    80004f84:	e09c                	sd	a5,0(s1)
}
    80004f86:	70a2                	ld	ra,40(sp)
    80004f88:	7402                	ld	s0,32(sp)
    80004f8a:	64e2                	ld	s1,24(sp)
    80004f8c:	6942                	ld	s2,16(sp)
    80004f8e:	6145                	addi	sp,sp,48
    80004f90:	8082                	ret
    return -1;
    80004f92:	557d                	li	a0,-1
    80004f94:	bfcd                	j	80004f86 <argfd+0x50>
    return -1;
    80004f96:	557d                	li	a0,-1
    80004f98:	b7fd                	j	80004f86 <argfd+0x50>
    80004f9a:	557d                	li	a0,-1
    80004f9c:	b7ed                	j	80004f86 <argfd+0x50>

0000000080004f9e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004f9e:	1101                	addi	sp,sp,-32
    80004fa0:	ec06                	sd	ra,24(sp)
    80004fa2:	e822                	sd	s0,16(sp)
    80004fa4:	e426                	sd	s1,8(sp)
    80004fa6:	1000                	addi	s0,sp,32
    80004fa8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004faa:	ffffd097          	auipc	ra,0xffffd
    80004fae:	8a2080e7          	jalr	-1886(ra) # 8000184c <myproc>
    80004fb2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004fb4:	0d050793          	addi	a5,a0,208
    80004fb8:	4501                	li	a0,0
    80004fba:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004fbc:	6398                	ld	a4,0(a5)
    80004fbe:	cb19                	beqz	a4,80004fd4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004fc0:	2505                	addiw	a0,a0,1
    80004fc2:	07a1                	addi	a5,a5,8
    80004fc4:	fed51ce3          	bne	a0,a3,80004fbc <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004fc8:	557d                	li	a0,-1
}
    80004fca:	60e2                	ld	ra,24(sp)
    80004fcc:	6442                	ld	s0,16(sp)
    80004fce:	64a2                	ld	s1,8(sp)
    80004fd0:	6105                	addi	sp,sp,32
    80004fd2:	8082                	ret
      p->ofile[fd] = f;
    80004fd4:	01a50793          	addi	a5,a0,26
    80004fd8:	078e                	slli	a5,a5,0x3
    80004fda:	963e                	add	a2,a2,a5
    80004fdc:	e204                	sd	s1,0(a2)
      return fd;
    80004fde:	b7f5                	j	80004fca <fdalloc+0x2c>

0000000080004fe0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004fe0:	715d                	addi	sp,sp,-80
    80004fe2:	e486                	sd	ra,72(sp)
    80004fe4:	e0a2                	sd	s0,64(sp)
    80004fe6:	fc26                	sd	s1,56(sp)
    80004fe8:	f84a                	sd	s2,48(sp)
    80004fea:	f44e                	sd	s3,40(sp)
    80004fec:	f052                	sd	s4,32(sp)
    80004fee:	ec56                	sd	s5,24(sp)
    80004ff0:	0880                	addi	s0,sp,80
    80004ff2:	89ae                	mv	s3,a1
    80004ff4:	8ab2                	mv	s5,a2
    80004ff6:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004ff8:	fb040593          	addi	a1,s0,-80
    80004ffc:	fffff097          	auipc	ra,0xfffff
    80005000:	c2a080e7          	jalr	-982(ra) # 80003c26 <nameiparent>
    80005004:	892a                	mv	s2,a0
    80005006:	12050e63          	beqz	a0,80005142 <create+0x162>
    return 0;

  ilock(dp);
    8000500a:	ffffe097          	auipc	ra,0xffffe
    8000500e:	472080e7          	jalr	1138(ra) # 8000347c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005012:	4601                	li	a2,0
    80005014:	fb040593          	addi	a1,s0,-80
    80005018:	854a                	mv	a0,s2
    8000501a:	fffff097          	auipc	ra,0xfffff
    8000501e:	91c080e7          	jalr	-1764(ra) # 80003936 <dirlookup>
    80005022:	84aa                	mv	s1,a0
    80005024:	c921                	beqz	a0,80005074 <create+0x94>
    iunlockput(dp);
    80005026:	854a                	mv	a0,s2
    80005028:	ffffe097          	auipc	ra,0xffffe
    8000502c:	692080e7          	jalr	1682(ra) # 800036ba <iunlockput>
    ilock(ip);
    80005030:	8526                	mv	a0,s1
    80005032:	ffffe097          	auipc	ra,0xffffe
    80005036:	44a080e7          	jalr	1098(ra) # 8000347c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000503a:	2981                	sext.w	s3,s3
    8000503c:	4789                	li	a5,2
    8000503e:	02f99463          	bne	s3,a5,80005066 <create+0x86>
    80005042:	0444d783          	lhu	a5,68(s1)
    80005046:	37f9                	addiw	a5,a5,-2
    80005048:	17c2                	slli	a5,a5,0x30
    8000504a:	93c1                	srli	a5,a5,0x30
    8000504c:	4705                	li	a4,1
    8000504e:	00f76c63          	bltu	a4,a5,80005066 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005052:	8526                	mv	a0,s1
    80005054:	60a6                	ld	ra,72(sp)
    80005056:	6406                	ld	s0,64(sp)
    80005058:	74e2                	ld	s1,56(sp)
    8000505a:	7942                	ld	s2,48(sp)
    8000505c:	79a2                	ld	s3,40(sp)
    8000505e:	7a02                	ld	s4,32(sp)
    80005060:	6ae2                	ld	s5,24(sp)
    80005062:	6161                	addi	sp,sp,80
    80005064:	8082                	ret
    iunlockput(ip);
    80005066:	8526                	mv	a0,s1
    80005068:	ffffe097          	auipc	ra,0xffffe
    8000506c:	652080e7          	jalr	1618(ra) # 800036ba <iunlockput>
    return 0;
    80005070:	4481                	li	s1,0
    80005072:	b7c5                	j	80005052 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005074:	85ce                	mv	a1,s3
    80005076:	00092503          	lw	a0,0(s2)
    8000507a:	ffffe097          	auipc	ra,0xffffe
    8000507e:	26a080e7          	jalr	618(ra) # 800032e4 <ialloc>
    80005082:	84aa                	mv	s1,a0
    80005084:	c521                	beqz	a0,800050cc <create+0xec>
  ilock(ip);
    80005086:	ffffe097          	auipc	ra,0xffffe
    8000508a:	3f6080e7          	jalr	1014(ra) # 8000347c <ilock>
  ip->major = major;
    8000508e:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005092:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005096:	4a05                	li	s4,1
    80005098:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000509c:	8526                	mv	a0,s1
    8000509e:	ffffe097          	auipc	ra,0xffffe
    800050a2:	314080e7          	jalr	788(ra) # 800033b2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800050a6:	2981                	sext.w	s3,s3
    800050a8:	03498a63          	beq	s3,s4,800050dc <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800050ac:	40d0                	lw	a2,4(s1)
    800050ae:	fb040593          	addi	a1,s0,-80
    800050b2:	854a                	mv	a0,s2
    800050b4:	fffff097          	auipc	ra,0xfffff
    800050b8:	a92080e7          	jalr	-1390(ra) # 80003b46 <dirlink>
    800050bc:	06054b63          	bltz	a0,80005132 <create+0x152>
  iunlockput(dp);
    800050c0:	854a                	mv	a0,s2
    800050c2:	ffffe097          	auipc	ra,0xffffe
    800050c6:	5f8080e7          	jalr	1528(ra) # 800036ba <iunlockput>
  return ip;
    800050ca:	b761                	j	80005052 <create+0x72>
    panic("create: ialloc");
    800050cc:	00002517          	auipc	a0,0x2
    800050d0:	68450513          	addi	a0,a0,1668 # 80007750 <userret+0x6c0>
    800050d4:	ffffb097          	auipc	ra,0xffffb
    800050d8:	47a080e7          	jalr	1146(ra) # 8000054e <panic>
    dp->nlink++;  // for ".."
    800050dc:	04a95783          	lhu	a5,74(s2)
    800050e0:	2785                	addiw	a5,a5,1
    800050e2:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800050e6:	854a                	mv	a0,s2
    800050e8:	ffffe097          	auipc	ra,0xffffe
    800050ec:	2ca080e7          	jalr	714(ra) # 800033b2 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800050f0:	40d0                	lw	a2,4(s1)
    800050f2:	00002597          	auipc	a1,0x2
    800050f6:	66e58593          	addi	a1,a1,1646 # 80007760 <userret+0x6d0>
    800050fa:	8526                	mv	a0,s1
    800050fc:	fffff097          	auipc	ra,0xfffff
    80005100:	a4a080e7          	jalr	-1462(ra) # 80003b46 <dirlink>
    80005104:	00054f63          	bltz	a0,80005122 <create+0x142>
    80005108:	00492603          	lw	a2,4(s2)
    8000510c:	00002597          	auipc	a1,0x2
    80005110:	65c58593          	addi	a1,a1,1628 # 80007768 <userret+0x6d8>
    80005114:	8526                	mv	a0,s1
    80005116:	fffff097          	auipc	ra,0xfffff
    8000511a:	a30080e7          	jalr	-1488(ra) # 80003b46 <dirlink>
    8000511e:	f80557e3          	bgez	a0,800050ac <create+0xcc>
      panic("create dots");
    80005122:	00002517          	auipc	a0,0x2
    80005126:	64e50513          	addi	a0,a0,1614 # 80007770 <userret+0x6e0>
    8000512a:	ffffb097          	auipc	ra,0xffffb
    8000512e:	424080e7          	jalr	1060(ra) # 8000054e <panic>
    panic("create: dirlink");
    80005132:	00002517          	auipc	a0,0x2
    80005136:	64e50513          	addi	a0,a0,1614 # 80007780 <userret+0x6f0>
    8000513a:	ffffb097          	auipc	ra,0xffffb
    8000513e:	414080e7          	jalr	1044(ra) # 8000054e <panic>
    return 0;
    80005142:	84aa                	mv	s1,a0
    80005144:	b739                	j	80005052 <create+0x72>

0000000080005146 <sys_dup>:
{
    80005146:	7179                	addi	sp,sp,-48
    80005148:	f406                	sd	ra,40(sp)
    8000514a:	f022                	sd	s0,32(sp)
    8000514c:	ec26                	sd	s1,24(sp)
    8000514e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005150:	fd840613          	addi	a2,s0,-40
    80005154:	4581                	li	a1,0
    80005156:	4501                	li	a0,0
    80005158:	00000097          	auipc	ra,0x0
    8000515c:	dde080e7          	jalr	-546(ra) # 80004f36 <argfd>
    return -1;
    80005160:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005162:	02054363          	bltz	a0,80005188 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005166:	fd843503          	ld	a0,-40(s0)
    8000516a:	00000097          	auipc	ra,0x0
    8000516e:	e34080e7          	jalr	-460(ra) # 80004f9e <fdalloc>
    80005172:	84aa                	mv	s1,a0
    return -1;
    80005174:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005176:	00054963          	bltz	a0,80005188 <sys_dup+0x42>
  filedup(f);
    8000517a:	fd843503          	ld	a0,-40(s0)
    8000517e:	fffff097          	auipc	ra,0xfffff
    80005182:	37c080e7          	jalr	892(ra) # 800044fa <filedup>
  return fd;
    80005186:	87a6                	mv	a5,s1
}
    80005188:	853e                	mv	a0,a5
    8000518a:	70a2                	ld	ra,40(sp)
    8000518c:	7402                	ld	s0,32(sp)
    8000518e:	64e2                	ld	s1,24(sp)
    80005190:	6145                	addi	sp,sp,48
    80005192:	8082                	ret

0000000080005194 <sys_read>:
{
    80005194:	7179                	addi	sp,sp,-48
    80005196:	f406                	sd	ra,40(sp)
    80005198:	f022                	sd	s0,32(sp)
    8000519a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000519c:	fe840613          	addi	a2,s0,-24
    800051a0:	4581                	li	a1,0
    800051a2:	4501                	li	a0,0
    800051a4:	00000097          	auipc	ra,0x0
    800051a8:	d92080e7          	jalr	-622(ra) # 80004f36 <argfd>
    return -1;
    800051ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051ae:	04054163          	bltz	a0,800051f0 <sys_read+0x5c>
    800051b2:	fe440593          	addi	a1,s0,-28
    800051b6:	4509                	li	a0,2
    800051b8:	ffffd097          	auipc	ra,0xffffd
    800051bc:	74e080e7          	jalr	1870(ra) # 80002906 <argint>
    return -1;
    800051c0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051c2:	02054763          	bltz	a0,800051f0 <sys_read+0x5c>
    800051c6:	fd840593          	addi	a1,s0,-40
    800051ca:	4505                	li	a0,1
    800051cc:	ffffd097          	auipc	ra,0xffffd
    800051d0:	75c080e7          	jalr	1884(ra) # 80002928 <argaddr>
    return -1;
    800051d4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051d6:	00054d63          	bltz	a0,800051f0 <sys_read+0x5c>
  return fileread(f, p, n);
    800051da:	fe442603          	lw	a2,-28(s0)
    800051de:	fd843583          	ld	a1,-40(s0)
    800051e2:	fe843503          	ld	a0,-24(s0)
    800051e6:	fffff097          	auipc	ra,0xfffff
    800051ea:	4a8080e7          	jalr	1192(ra) # 8000468e <fileread>
    800051ee:	87aa                	mv	a5,a0
}
    800051f0:	853e                	mv	a0,a5
    800051f2:	70a2                	ld	ra,40(sp)
    800051f4:	7402                	ld	s0,32(sp)
    800051f6:	6145                	addi	sp,sp,48
    800051f8:	8082                	ret

00000000800051fa <sys_write>:
{
    800051fa:	7179                	addi	sp,sp,-48
    800051fc:	f406                	sd	ra,40(sp)
    800051fe:	f022                	sd	s0,32(sp)
    80005200:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005202:	fe840613          	addi	a2,s0,-24
    80005206:	4581                	li	a1,0
    80005208:	4501                	li	a0,0
    8000520a:	00000097          	auipc	ra,0x0
    8000520e:	d2c080e7          	jalr	-724(ra) # 80004f36 <argfd>
    return -1;
    80005212:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005214:	04054163          	bltz	a0,80005256 <sys_write+0x5c>
    80005218:	fe440593          	addi	a1,s0,-28
    8000521c:	4509                	li	a0,2
    8000521e:	ffffd097          	auipc	ra,0xffffd
    80005222:	6e8080e7          	jalr	1768(ra) # 80002906 <argint>
    return -1;
    80005226:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005228:	02054763          	bltz	a0,80005256 <sys_write+0x5c>
    8000522c:	fd840593          	addi	a1,s0,-40
    80005230:	4505                	li	a0,1
    80005232:	ffffd097          	auipc	ra,0xffffd
    80005236:	6f6080e7          	jalr	1782(ra) # 80002928 <argaddr>
    return -1;
    8000523a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000523c:	00054d63          	bltz	a0,80005256 <sys_write+0x5c>
  return filewrite(f, p, n);
    80005240:	fe442603          	lw	a2,-28(s0)
    80005244:	fd843583          	ld	a1,-40(s0)
    80005248:	fe843503          	ld	a0,-24(s0)
    8000524c:	fffff097          	auipc	ra,0xfffff
    80005250:	4f0080e7          	jalr	1264(ra) # 8000473c <filewrite>
    80005254:	87aa                	mv	a5,a0
}
    80005256:	853e                	mv	a0,a5
    80005258:	70a2                	ld	ra,40(sp)
    8000525a:	7402                	ld	s0,32(sp)
    8000525c:	6145                	addi	sp,sp,48
    8000525e:	8082                	ret

0000000080005260 <sys_close>:
{
    80005260:	1101                	addi	sp,sp,-32
    80005262:	ec06                	sd	ra,24(sp)
    80005264:	e822                	sd	s0,16(sp)
    80005266:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005268:	fe040613          	addi	a2,s0,-32
    8000526c:	fec40593          	addi	a1,s0,-20
    80005270:	4501                	li	a0,0
    80005272:	00000097          	auipc	ra,0x0
    80005276:	cc4080e7          	jalr	-828(ra) # 80004f36 <argfd>
    return -1;
    8000527a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000527c:	02054463          	bltz	a0,800052a4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005280:	ffffc097          	auipc	ra,0xffffc
    80005284:	5cc080e7          	jalr	1484(ra) # 8000184c <myproc>
    80005288:	fec42783          	lw	a5,-20(s0)
    8000528c:	07e9                	addi	a5,a5,26
    8000528e:	078e                	slli	a5,a5,0x3
    80005290:	97aa                	add	a5,a5,a0
    80005292:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005296:	fe043503          	ld	a0,-32(s0)
    8000529a:	fffff097          	auipc	ra,0xfffff
    8000529e:	2b2080e7          	jalr	690(ra) # 8000454c <fileclose>
  return 0;
    800052a2:	4781                	li	a5,0
}
    800052a4:	853e                	mv	a0,a5
    800052a6:	60e2                	ld	ra,24(sp)
    800052a8:	6442                	ld	s0,16(sp)
    800052aa:	6105                	addi	sp,sp,32
    800052ac:	8082                	ret

00000000800052ae <sys_fstat>:
{
    800052ae:	1101                	addi	sp,sp,-32
    800052b0:	ec06                	sd	ra,24(sp)
    800052b2:	e822                	sd	s0,16(sp)
    800052b4:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800052b6:	fe840613          	addi	a2,s0,-24
    800052ba:	4581                	li	a1,0
    800052bc:	4501                	li	a0,0
    800052be:	00000097          	auipc	ra,0x0
    800052c2:	c78080e7          	jalr	-904(ra) # 80004f36 <argfd>
    return -1;
    800052c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800052c8:	02054563          	bltz	a0,800052f2 <sys_fstat+0x44>
    800052cc:	fe040593          	addi	a1,s0,-32
    800052d0:	4505                	li	a0,1
    800052d2:	ffffd097          	auipc	ra,0xffffd
    800052d6:	656080e7          	jalr	1622(ra) # 80002928 <argaddr>
    return -1;
    800052da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800052dc:	00054b63          	bltz	a0,800052f2 <sys_fstat+0x44>
  return filestat(f, st);
    800052e0:	fe043583          	ld	a1,-32(s0)
    800052e4:	fe843503          	ld	a0,-24(s0)
    800052e8:	fffff097          	auipc	ra,0xfffff
    800052ec:	334080e7          	jalr	820(ra) # 8000461c <filestat>
    800052f0:	87aa                	mv	a5,a0
}
    800052f2:	853e                	mv	a0,a5
    800052f4:	60e2                	ld	ra,24(sp)
    800052f6:	6442                	ld	s0,16(sp)
    800052f8:	6105                	addi	sp,sp,32
    800052fa:	8082                	ret

00000000800052fc <sys_link>:
{
    800052fc:	7169                	addi	sp,sp,-304
    800052fe:	f606                	sd	ra,296(sp)
    80005300:	f222                	sd	s0,288(sp)
    80005302:	ee26                	sd	s1,280(sp)
    80005304:	ea4a                	sd	s2,272(sp)
    80005306:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005308:	08000613          	li	a2,128
    8000530c:	ed040593          	addi	a1,s0,-304
    80005310:	4501                	li	a0,0
    80005312:	ffffd097          	auipc	ra,0xffffd
    80005316:	638080e7          	jalr	1592(ra) # 8000294a <argstr>
    return -1;
    8000531a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000531c:	12054363          	bltz	a0,80005442 <sys_link+0x146>
    80005320:	08000613          	li	a2,128
    80005324:	f5040593          	addi	a1,s0,-176
    80005328:	4505                	li	a0,1
    8000532a:	ffffd097          	auipc	ra,0xffffd
    8000532e:	620080e7          	jalr	1568(ra) # 8000294a <argstr>
    return -1;
    80005332:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005334:	10054763          	bltz	a0,80005442 <sys_link+0x146>
  begin_op(ROOTDEV);
    80005338:	4501                	li	a0,0
    8000533a:	fffff097          	auipc	ra,0xfffff
    8000533e:	bea080e7          	jalr	-1046(ra) # 80003f24 <begin_op>
  if((ip = namei(old)) == 0){
    80005342:	ed040513          	addi	a0,s0,-304
    80005346:	fffff097          	auipc	ra,0xfffff
    8000534a:	8c2080e7          	jalr	-1854(ra) # 80003c08 <namei>
    8000534e:	84aa                	mv	s1,a0
    80005350:	c559                	beqz	a0,800053de <sys_link+0xe2>
  ilock(ip);
    80005352:	ffffe097          	auipc	ra,0xffffe
    80005356:	12a080e7          	jalr	298(ra) # 8000347c <ilock>
  if(ip->type == T_DIR){
    8000535a:	04449703          	lh	a4,68(s1)
    8000535e:	4785                	li	a5,1
    80005360:	08f70663          	beq	a4,a5,800053ec <sys_link+0xf0>
  ip->nlink++;
    80005364:	04a4d783          	lhu	a5,74(s1)
    80005368:	2785                	addiw	a5,a5,1
    8000536a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000536e:	8526                	mv	a0,s1
    80005370:	ffffe097          	auipc	ra,0xffffe
    80005374:	042080e7          	jalr	66(ra) # 800033b2 <iupdate>
  iunlock(ip);
    80005378:	8526                	mv	a0,s1
    8000537a:	ffffe097          	auipc	ra,0xffffe
    8000537e:	1c4080e7          	jalr	452(ra) # 8000353e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005382:	fd040593          	addi	a1,s0,-48
    80005386:	f5040513          	addi	a0,s0,-176
    8000538a:	fffff097          	auipc	ra,0xfffff
    8000538e:	89c080e7          	jalr	-1892(ra) # 80003c26 <nameiparent>
    80005392:	892a                	mv	s2,a0
    80005394:	cd2d                	beqz	a0,8000540e <sys_link+0x112>
  ilock(dp);
    80005396:	ffffe097          	auipc	ra,0xffffe
    8000539a:	0e6080e7          	jalr	230(ra) # 8000347c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000539e:	00092703          	lw	a4,0(s2)
    800053a2:	409c                	lw	a5,0(s1)
    800053a4:	06f71063          	bne	a4,a5,80005404 <sys_link+0x108>
    800053a8:	40d0                	lw	a2,4(s1)
    800053aa:	fd040593          	addi	a1,s0,-48
    800053ae:	854a                	mv	a0,s2
    800053b0:	ffffe097          	auipc	ra,0xffffe
    800053b4:	796080e7          	jalr	1942(ra) # 80003b46 <dirlink>
    800053b8:	04054663          	bltz	a0,80005404 <sys_link+0x108>
  iunlockput(dp);
    800053bc:	854a                	mv	a0,s2
    800053be:	ffffe097          	auipc	ra,0xffffe
    800053c2:	2fc080e7          	jalr	764(ra) # 800036ba <iunlockput>
  iput(ip);
    800053c6:	8526                	mv	a0,s1
    800053c8:	ffffe097          	auipc	ra,0xffffe
    800053cc:	1c2080e7          	jalr	450(ra) # 8000358a <iput>
  end_op(ROOTDEV);
    800053d0:	4501                	li	a0,0
    800053d2:	fffff097          	auipc	ra,0xfffff
    800053d6:	bfc080e7          	jalr	-1028(ra) # 80003fce <end_op>
  return 0;
    800053da:	4781                	li	a5,0
    800053dc:	a09d                	j	80005442 <sys_link+0x146>
    end_op(ROOTDEV);
    800053de:	4501                	li	a0,0
    800053e0:	fffff097          	auipc	ra,0xfffff
    800053e4:	bee080e7          	jalr	-1042(ra) # 80003fce <end_op>
    return -1;
    800053e8:	57fd                	li	a5,-1
    800053ea:	a8a1                	j	80005442 <sys_link+0x146>
    iunlockput(ip);
    800053ec:	8526                	mv	a0,s1
    800053ee:	ffffe097          	auipc	ra,0xffffe
    800053f2:	2cc080e7          	jalr	716(ra) # 800036ba <iunlockput>
    end_op(ROOTDEV);
    800053f6:	4501                	li	a0,0
    800053f8:	fffff097          	auipc	ra,0xfffff
    800053fc:	bd6080e7          	jalr	-1066(ra) # 80003fce <end_op>
    return -1;
    80005400:	57fd                	li	a5,-1
    80005402:	a081                	j	80005442 <sys_link+0x146>
    iunlockput(dp);
    80005404:	854a                	mv	a0,s2
    80005406:	ffffe097          	auipc	ra,0xffffe
    8000540a:	2b4080e7          	jalr	692(ra) # 800036ba <iunlockput>
  ilock(ip);
    8000540e:	8526                	mv	a0,s1
    80005410:	ffffe097          	auipc	ra,0xffffe
    80005414:	06c080e7          	jalr	108(ra) # 8000347c <ilock>
  ip->nlink--;
    80005418:	04a4d783          	lhu	a5,74(s1)
    8000541c:	37fd                	addiw	a5,a5,-1
    8000541e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005422:	8526                	mv	a0,s1
    80005424:	ffffe097          	auipc	ra,0xffffe
    80005428:	f8e080e7          	jalr	-114(ra) # 800033b2 <iupdate>
  iunlockput(ip);
    8000542c:	8526                	mv	a0,s1
    8000542e:	ffffe097          	auipc	ra,0xffffe
    80005432:	28c080e7          	jalr	652(ra) # 800036ba <iunlockput>
  end_op(ROOTDEV);
    80005436:	4501                	li	a0,0
    80005438:	fffff097          	auipc	ra,0xfffff
    8000543c:	b96080e7          	jalr	-1130(ra) # 80003fce <end_op>
  return -1;
    80005440:	57fd                	li	a5,-1
}
    80005442:	853e                	mv	a0,a5
    80005444:	70b2                	ld	ra,296(sp)
    80005446:	7412                	ld	s0,288(sp)
    80005448:	64f2                	ld	s1,280(sp)
    8000544a:	6952                	ld	s2,272(sp)
    8000544c:	6155                	addi	sp,sp,304
    8000544e:	8082                	ret

0000000080005450 <sys_unlink>:
{
    80005450:	7151                	addi	sp,sp,-240
    80005452:	f586                	sd	ra,232(sp)
    80005454:	f1a2                	sd	s0,224(sp)
    80005456:	eda6                	sd	s1,216(sp)
    80005458:	e9ca                	sd	s2,208(sp)
    8000545a:	e5ce                	sd	s3,200(sp)
    8000545c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000545e:	08000613          	li	a2,128
    80005462:	f3040593          	addi	a1,s0,-208
    80005466:	4501                	li	a0,0
    80005468:	ffffd097          	auipc	ra,0xffffd
    8000546c:	4e2080e7          	jalr	1250(ra) # 8000294a <argstr>
    80005470:	18054463          	bltz	a0,800055f8 <sys_unlink+0x1a8>
  begin_op(ROOTDEV);
    80005474:	4501                	li	a0,0
    80005476:	fffff097          	auipc	ra,0xfffff
    8000547a:	aae080e7          	jalr	-1362(ra) # 80003f24 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000547e:	fb040593          	addi	a1,s0,-80
    80005482:	f3040513          	addi	a0,s0,-208
    80005486:	ffffe097          	auipc	ra,0xffffe
    8000548a:	7a0080e7          	jalr	1952(ra) # 80003c26 <nameiparent>
    8000548e:	84aa                	mv	s1,a0
    80005490:	cd61                	beqz	a0,80005568 <sys_unlink+0x118>
  ilock(dp);
    80005492:	ffffe097          	auipc	ra,0xffffe
    80005496:	fea080e7          	jalr	-22(ra) # 8000347c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000549a:	00002597          	auipc	a1,0x2
    8000549e:	2c658593          	addi	a1,a1,710 # 80007760 <userret+0x6d0>
    800054a2:	fb040513          	addi	a0,s0,-80
    800054a6:	ffffe097          	auipc	ra,0xffffe
    800054aa:	476080e7          	jalr	1142(ra) # 8000391c <namecmp>
    800054ae:	14050c63          	beqz	a0,80005606 <sys_unlink+0x1b6>
    800054b2:	00002597          	auipc	a1,0x2
    800054b6:	2b658593          	addi	a1,a1,694 # 80007768 <userret+0x6d8>
    800054ba:	fb040513          	addi	a0,s0,-80
    800054be:	ffffe097          	auipc	ra,0xffffe
    800054c2:	45e080e7          	jalr	1118(ra) # 8000391c <namecmp>
    800054c6:	14050063          	beqz	a0,80005606 <sys_unlink+0x1b6>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800054ca:	f2c40613          	addi	a2,s0,-212
    800054ce:	fb040593          	addi	a1,s0,-80
    800054d2:	8526                	mv	a0,s1
    800054d4:	ffffe097          	auipc	ra,0xffffe
    800054d8:	462080e7          	jalr	1122(ra) # 80003936 <dirlookup>
    800054dc:	892a                	mv	s2,a0
    800054de:	12050463          	beqz	a0,80005606 <sys_unlink+0x1b6>
  ilock(ip);
    800054e2:	ffffe097          	auipc	ra,0xffffe
    800054e6:	f9a080e7          	jalr	-102(ra) # 8000347c <ilock>
  if(ip->nlink < 1)
    800054ea:	04a91783          	lh	a5,74(s2)
    800054ee:	08f05463          	blez	a5,80005576 <sys_unlink+0x126>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800054f2:	04491703          	lh	a4,68(s2)
    800054f6:	4785                	li	a5,1
    800054f8:	08f70763          	beq	a4,a5,80005586 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    800054fc:	4641                	li	a2,16
    800054fe:	4581                	li	a1,0
    80005500:	fc040513          	addi	a0,s0,-64
    80005504:	ffffb097          	auipc	ra,0xffffb
    80005508:	6aa080e7          	jalr	1706(ra) # 80000bae <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000550c:	4741                	li	a4,16
    8000550e:	f2c42683          	lw	a3,-212(s0)
    80005512:	fc040613          	addi	a2,s0,-64
    80005516:	4581                	li	a1,0
    80005518:	8526                	mv	a0,s1
    8000551a:	ffffe097          	auipc	ra,0xffffe
    8000551e:	2e6080e7          	jalr	742(ra) # 80003800 <writei>
    80005522:	47c1                	li	a5,16
    80005524:	0af51763          	bne	a0,a5,800055d2 <sys_unlink+0x182>
  if(ip->type == T_DIR){
    80005528:	04491703          	lh	a4,68(s2)
    8000552c:	4785                	li	a5,1
    8000552e:	0af70a63          	beq	a4,a5,800055e2 <sys_unlink+0x192>
  iunlockput(dp);
    80005532:	8526                	mv	a0,s1
    80005534:	ffffe097          	auipc	ra,0xffffe
    80005538:	186080e7          	jalr	390(ra) # 800036ba <iunlockput>
  ip->nlink--;
    8000553c:	04a95783          	lhu	a5,74(s2)
    80005540:	37fd                	addiw	a5,a5,-1
    80005542:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005546:	854a                	mv	a0,s2
    80005548:	ffffe097          	auipc	ra,0xffffe
    8000554c:	e6a080e7          	jalr	-406(ra) # 800033b2 <iupdate>
  iunlockput(ip);
    80005550:	854a                	mv	a0,s2
    80005552:	ffffe097          	auipc	ra,0xffffe
    80005556:	168080e7          	jalr	360(ra) # 800036ba <iunlockput>
  end_op(ROOTDEV);
    8000555a:	4501                	li	a0,0
    8000555c:	fffff097          	auipc	ra,0xfffff
    80005560:	a72080e7          	jalr	-1422(ra) # 80003fce <end_op>
  return 0;
    80005564:	4501                	li	a0,0
    80005566:	a85d                	j	8000561c <sys_unlink+0x1cc>
    end_op(ROOTDEV);
    80005568:	4501                	li	a0,0
    8000556a:	fffff097          	auipc	ra,0xfffff
    8000556e:	a64080e7          	jalr	-1436(ra) # 80003fce <end_op>
    return -1;
    80005572:	557d                	li	a0,-1
    80005574:	a065                	j	8000561c <sys_unlink+0x1cc>
    panic("unlink: nlink < 1");
    80005576:	00002517          	auipc	a0,0x2
    8000557a:	21a50513          	addi	a0,a0,538 # 80007790 <userret+0x700>
    8000557e:	ffffb097          	auipc	ra,0xffffb
    80005582:	fd0080e7          	jalr	-48(ra) # 8000054e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005586:	04c92703          	lw	a4,76(s2)
    8000558a:	02000793          	li	a5,32
    8000558e:	f6e7f7e3          	bgeu	a5,a4,800054fc <sys_unlink+0xac>
    80005592:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005596:	4741                	li	a4,16
    80005598:	86ce                	mv	a3,s3
    8000559a:	f1840613          	addi	a2,s0,-232
    8000559e:	4581                	li	a1,0
    800055a0:	854a                	mv	a0,s2
    800055a2:	ffffe097          	auipc	ra,0xffffe
    800055a6:	16a080e7          	jalr	362(ra) # 8000370c <readi>
    800055aa:	47c1                	li	a5,16
    800055ac:	00f51b63          	bne	a0,a5,800055c2 <sys_unlink+0x172>
    if(de.inum != 0)
    800055b0:	f1845783          	lhu	a5,-232(s0)
    800055b4:	e7a1                	bnez	a5,800055fc <sys_unlink+0x1ac>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800055b6:	29c1                	addiw	s3,s3,16
    800055b8:	04c92783          	lw	a5,76(s2)
    800055bc:	fcf9ede3          	bltu	s3,a5,80005596 <sys_unlink+0x146>
    800055c0:	bf35                	j	800054fc <sys_unlink+0xac>
      panic("isdirempty: readi");
    800055c2:	00002517          	auipc	a0,0x2
    800055c6:	1e650513          	addi	a0,a0,486 # 800077a8 <userret+0x718>
    800055ca:	ffffb097          	auipc	ra,0xffffb
    800055ce:	f84080e7          	jalr	-124(ra) # 8000054e <panic>
    panic("unlink: writei");
    800055d2:	00002517          	auipc	a0,0x2
    800055d6:	1ee50513          	addi	a0,a0,494 # 800077c0 <userret+0x730>
    800055da:	ffffb097          	auipc	ra,0xffffb
    800055de:	f74080e7          	jalr	-140(ra) # 8000054e <panic>
    dp->nlink--;
    800055e2:	04a4d783          	lhu	a5,74(s1)
    800055e6:	37fd                	addiw	a5,a5,-1
    800055e8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800055ec:	8526                	mv	a0,s1
    800055ee:	ffffe097          	auipc	ra,0xffffe
    800055f2:	dc4080e7          	jalr	-572(ra) # 800033b2 <iupdate>
    800055f6:	bf35                	j	80005532 <sys_unlink+0xe2>
    return -1;
    800055f8:	557d                	li	a0,-1
    800055fa:	a00d                	j	8000561c <sys_unlink+0x1cc>
    iunlockput(ip);
    800055fc:	854a                	mv	a0,s2
    800055fe:	ffffe097          	auipc	ra,0xffffe
    80005602:	0bc080e7          	jalr	188(ra) # 800036ba <iunlockput>
  iunlockput(dp);
    80005606:	8526                	mv	a0,s1
    80005608:	ffffe097          	auipc	ra,0xffffe
    8000560c:	0b2080e7          	jalr	178(ra) # 800036ba <iunlockput>
  end_op(ROOTDEV);
    80005610:	4501                	li	a0,0
    80005612:	fffff097          	auipc	ra,0xfffff
    80005616:	9bc080e7          	jalr	-1604(ra) # 80003fce <end_op>
  return -1;
    8000561a:	557d                	li	a0,-1
}
    8000561c:	70ae                	ld	ra,232(sp)
    8000561e:	740e                	ld	s0,224(sp)
    80005620:	64ee                	ld	s1,216(sp)
    80005622:	694e                	ld	s2,208(sp)
    80005624:	69ae                	ld	s3,200(sp)
    80005626:	616d                	addi	sp,sp,240
    80005628:	8082                	ret

000000008000562a <sys_open>:

uint64
sys_open(void)
{
    8000562a:	7131                	addi	sp,sp,-192
    8000562c:	fd06                	sd	ra,184(sp)
    8000562e:	f922                	sd	s0,176(sp)
    80005630:	f526                	sd	s1,168(sp)
    80005632:	f14a                	sd	s2,160(sp)
    80005634:	ed4e                	sd	s3,152(sp)
    80005636:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005638:	08000613          	li	a2,128
    8000563c:	f5040593          	addi	a1,s0,-176
    80005640:	4501                	li	a0,0
    80005642:	ffffd097          	auipc	ra,0xffffd
    80005646:	308080e7          	jalr	776(ra) # 8000294a <argstr>
    return -1;
    8000564a:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000564c:	0a054963          	bltz	a0,800056fe <sys_open+0xd4>
    80005650:	f4c40593          	addi	a1,s0,-180
    80005654:	4505                	li	a0,1
    80005656:	ffffd097          	auipc	ra,0xffffd
    8000565a:	2b0080e7          	jalr	688(ra) # 80002906 <argint>
    8000565e:	0a054063          	bltz	a0,800056fe <sys_open+0xd4>

  begin_op(ROOTDEV);
    80005662:	4501                	li	a0,0
    80005664:	fffff097          	auipc	ra,0xfffff
    80005668:	8c0080e7          	jalr	-1856(ra) # 80003f24 <begin_op>

  if(omode & O_CREATE){
    8000566c:	f4c42783          	lw	a5,-180(s0)
    80005670:	2007f793          	andi	a5,a5,512
    80005674:	c3dd                	beqz	a5,8000571a <sys_open+0xf0>
    ip = create(path, T_FILE, 0, 0);
    80005676:	4681                	li	a3,0
    80005678:	4601                	li	a2,0
    8000567a:	4589                	li	a1,2
    8000567c:	f5040513          	addi	a0,s0,-176
    80005680:	00000097          	auipc	ra,0x0
    80005684:	960080e7          	jalr	-1696(ra) # 80004fe0 <create>
    80005688:	892a                	mv	s2,a0
    if(ip == 0){
    8000568a:	c151                	beqz	a0,8000570e <sys_open+0xe4>
      end_op(ROOTDEV);
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000568c:	04491703          	lh	a4,68(s2)
    80005690:	478d                	li	a5,3
    80005692:	00f71763          	bne	a4,a5,800056a0 <sys_open+0x76>
    80005696:	04695703          	lhu	a4,70(s2)
    8000569a:	47a5                	li	a5,9
    8000569c:	0ce7e663          	bltu	a5,a4,80005768 <sys_open+0x13e>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800056a0:	fffff097          	auipc	ra,0xfffff
    800056a4:	df0080e7          	jalr	-528(ra) # 80004490 <filealloc>
    800056a8:	89aa                	mv	s3,a0
    800056aa:	c57d                	beqz	a0,80005798 <sys_open+0x16e>
    800056ac:	00000097          	auipc	ra,0x0
    800056b0:	8f2080e7          	jalr	-1806(ra) # 80004f9e <fdalloc>
    800056b4:	84aa                	mv	s1,a0
    800056b6:	0c054c63          	bltz	a0,8000578e <sys_open+0x164>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if(ip->type == T_DEVICE){
    800056ba:	04491703          	lh	a4,68(s2)
    800056be:	478d                	li	a5,3
    800056c0:	0cf70063          	beq	a4,a5,80005780 <sys_open+0x156>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800056c4:	4789                	li	a5,2
    800056c6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800056ca:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800056ce:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    800056d2:	f4c42783          	lw	a5,-180(s0)
    800056d6:	0017c713          	xori	a4,a5,1
    800056da:	8b05                	andi	a4,a4,1
    800056dc:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800056e0:	8b8d                	andi	a5,a5,3
    800056e2:	00f037b3          	snez	a5,a5
    800056e6:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
    800056ea:	854a                	mv	a0,s2
    800056ec:	ffffe097          	auipc	ra,0xffffe
    800056f0:	e52080e7          	jalr	-430(ra) # 8000353e <iunlock>
  end_op(ROOTDEV);
    800056f4:	4501                	li	a0,0
    800056f6:	fffff097          	auipc	ra,0xfffff
    800056fa:	8d8080e7          	jalr	-1832(ra) # 80003fce <end_op>

  return fd;
}
    800056fe:	8526                	mv	a0,s1
    80005700:	70ea                	ld	ra,184(sp)
    80005702:	744a                	ld	s0,176(sp)
    80005704:	74aa                	ld	s1,168(sp)
    80005706:	790a                	ld	s2,160(sp)
    80005708:	69ea                	ld	s3,152(sp)
    8000570a:	6129                	addi	sp,sp,192
    8000570c:	8082                	ret
      end_op(ROOTDEV);
    8000570e:	4501                	li	a0,0
    80005710:	fffff097          	auipc	ra,0xfffff
    80005714:	8be080e7          	jalr	-1858(ra) # 80003fce <end_op>
      return -1;
    80005718:	b7dd                	j	800056fe <sys_open+0xd4>
    if((ip = namei(path)) == 0){
    8000571a:	f5040513          	addi	a0,s0,-176
    8000571e:	ffffe097          	auipc	ra,0xffffe
    80005722:	4ea080e7          	jalr	1258(ra) # 80003c08 <namei>
    80005726:	892a                	mv	s2,a0
    80005728:	c90d                	beqz	a0,8000575a <sys_open+0x130>
    ilock(ip);
    8000572a:	ffffe097          	auipc	ra,0xffffe
    8000572e:	d52080e7          	jalr	-686(ra) # 8000347c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005732:	04491703          	lh	a4,68(s2)
    80005736:	4785                	li	a5,1
    80005738:	f4f71ae3          	bne	a4,a5,8000568c <sys_open+0x62>
    8000573c:	f4c42783          	lw	a5,-180(s0)
    80005740:	d3a5                	beqz	a5,800056a0 <sys_open+0x76>
      iunlockput(ip);
    80005742:	854a                	mv	a0,s2
    80005744:	ffffe097          	auipc	ra,0xffffe
    80005748:	f76080e7          	jalr	-138(ra) # 800036ba <iunlockput>
      end_op(ROOTDEV);
    8000574c:	4501                	li	a0,0
    8000574e:	fffff097          	auipc	ra,0xfffff
    80005752:	880080e7          	jalr	-1920(ra) # 80003fce <end_op>
      return -1;
    80005756:	54fd                	li	s1,-1
    80005758:	b75d                	j	800056fe <sys_open+0xd4>
      end_op(ROOTDEV);
    8000575a:	4501                	li	a0,0
    8000575c:	fffff097          	auipc	ra,0xfffff
    80005760:	872080e7          	jalr	-1934(ra) # 80003fce <end_op>
      return -1;
    80005764:	54fd                	li	s1,-1
    80005766:	bf61                	j	800056fe <sys_open+0xd4>
    iunlockput(ip);
    80005768:	854a                	mv	a0,s2
    8000576a:	ffffe097          	auipc	ra,0xffffe
    8000576e:	f50080e7          	jalr	-176(ra) # 800036ba <iunlockput>
    end_op(ROOTDEV);
    80005772:	4501                	li	a0,0
    80005774:	fffff097          	auipc	ra,0xfffff
    80005778:	85a080e7          	jalr	-1958(ra) # 80003fce <end_op>
    return -1;
    8000577c:	54fd                	li	s1,-1
    8000577e:	b741                	j	800056fe <sys_open+0xd4>
    f->type = FD_DEVICE;
    80005780:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005784:	04691783          	lh	a5,70(s2)
    80005788:	02f99223          	sh	a5,36(s3)
    8000578c:	b789                	j	800056ce <sys_open+0xa4>
      fileclose(f);
    8000578e:	854e                	mv	a0,s3
    80005790:	fffff097          	auipc	ra,0xfffff
    80005794:	dbc080e7          	jalr	-580(ra) # 8000454c <fileclose>
    iunlockput(ip);
    80005798:	854a                	mv	a0,s2
    8000579a:	ffffe097          	auipc	ra,0xffffe
    8000579e:	f20080e7          	jalr	-224(ra) # 800036ba <iunlockput>
    end_op(ROOTDEV);
    800057a2:	4501                	li	a0,0
    800057a4:	fffff097          	auipc	ra,0xfffff
    800057a8:	82a080e7          	jalr	-2006(ra) # 80003fce <end_op>
    return -1;
    800057ac:	54fd                	li	s1,-1
    800057ae:	bf81                	j	800056fe <sys_open+0xd4>

00000000800057b0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800057b0:	7175                	addi	sp,sp,-144
    800057b2:	e506                	sd	ra,136(sp)
    800057b4:	e122                	sd	s0,128(sp)
    800057b6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op(ROOTDEV);
    800057b8:	4501                	li	a0,0
    800057ba:	ffffe097          	auipc	ra,0xffffe
    800057be:	76a080e7          	jalr	1898(ra) # 80003f24 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800057c2:	08000613          	li	a2,128
    800057c6:	f7040593          	addi	a1,s0,-144
    800057ca:	4501                	li	a0,0
    800057cc:	ffffd097          	auipc	ra,0xffffd
    800057d0:	17e080e7          	jalr	382(ra) # 8000294a <argstr>
    800057d4:	02054a63          	bltz	a0,80005808 <sys_mkdir+0x58>
    800057d8:	4681                	li	a3,0
    800057da:	4601                	li	a2,0
    800057dc:	4585                	li	a1,1
    800057de:	f7040513          	addi	a0,s0,-144
    800057e2:	fffff097          	auipc	ra,0xfffff
    800057e6:	7fe080e7          	jalr	2046(ra) # 80004fe0 <create>
    800057ea:	cd19                	beqz	a0,80005808 <sys_mkdir+0x58>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    800057ec:	ffffe097          	auipc	ra,0xffffe
    800057f0:	ece080e7          	jalr	-306(ra) # 800036ba <iunlockput>
  end_op(ROOTDEV);
    800057f4:	4501                	li	a0,0
    800057f6:	ffffe097          	auipc	ra,0xffffe
    800057fa:	7d8080e7          	jalr	2008(ra) # 80003fce <end_op>
  return 0;
    800057fe:	4501                	li	a0,0
}
    80005800:	60aa                	ld	ra,136(sp)
    80005802:	640a                	ld	s0,128(sp)
    80005804:	6149                	addi	sp,sp,144
    80005806:	8082                	ret
    end_op(ROOTDEV);
    80005808:	4501                	li	a0,0
    8000580a:	ffffe097          	auipc	ra,0xffffe
    8000580e:	7c4080e7          	jalr	1988(ra) # 80003fce <end_op>
    return -1;
    80005812:	557d                	li	a0,-1
    80005814:	b7f5                	j	80005800 <sys_mkdir+0x50>

0000000080005816 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005816:	7135                	addi	sp,sp,-160
    80005818:	ed06                	sd	ra,152(sp)
    8000581a:	e922                	sd	s0,144(sp)
    8000581c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op(ROOTDEV);
    8000581e:	4501                	li	a0,0
    80005820:	ffffe097          	auipc	ra,0xffffe
    80005824:	704080e7          	jalr	1796(ra) # 80003f24 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005828:	08000613          	li	a2,128
    8000582c:	f7040593          	addi	a1,s0,-144
    80005830:	4501                	li	a0,0
    80005832:	ffffd097          	auipc	ra,0xffffd
    80005836:	118080e7          	jalr	280(ra) # 8000294a <argstr>
    8000583a:	04054b63          	bltz	a0,80005890 <sys_mknod+0x7a>
     argint(1, &major) < 0 ||
    8000583e:	f6c40593          	addi	a1,s0,-148
    80005842:	4505                	li	a0,1
    80005844:	ffffd097          	auipc	ra,0xffffd
    80005848:	0c2080e7          	jalr	194(ra) # 80002906 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000584c:	04054263          	bltz	a0,80005890 <sys_mknod+0x7a>
     argint(2, &minor) < 0 ||
    80005850:	f6840593          	addi	a1,s0,-152
    80005854:	4509                	li	a0,2
    80005856:	ffffd097          	auipc	ra,0xffffd
    8000585a:	0b0080e7          	jalr	176(ra) # 80002906 <argint>
     argint(1, &major) < 0 ||
    8000585e:	02054963          	bltz	a0,80005890 <sys_mknod+0x7a>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005862:	f6841683          	lh	a3,-152(s0)
    80005866:	f6c41603          	lh	a2,-148(s0)
    8000586a:	458d                	li	a1,3
    8000586c:	f7040513          	addi	a0,s0,-144
    80005870:	fffff097          	auipc	ra,0xfffff
    80005874:	770080e7          	jalr	1904(ra) # 80004fe0 <create>
     argint(2, &minor) < 0 ||
    80005878:	cd01                	beqz	a0,80005890 <sys_mknod+0x7a>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    8000587a:	ffffe097          	auipc	ra,0xffffe
    8000587e:	e40080e7          	jalr	-448(ra) # 800036ba <iunlockput>
  end_op(ROOTDEV);
    80005882:	4501                	li	a0,0
    80005884:	ffffe097          	auipc	ra,0xffffe
    80005888:	74a080e7          	jalr	1866(ra) # 80003fce <end_op>
  return 0;
    8000588c:	4501                	li	a0,0
    8000588e:	a039                	j	8000589c <sys_mknod+0x86>
    end_op(ROOTDEV);
    80005890:	4501                	li	a0,0
    80005892:	ffffe097          	auipc	ra,0xffffe
    80005896:	73c080e7          	jalr	1852(ra) # 80003fce <end_op>
    return -1;
    8000589a:	557d                	li	a0,-1
}
    8000589c:	60ea                	ld	ra,152(sp)
    8000589e:	644a                	ld	s0,144(sp)
    800058a0:	610d                	addi	sp,sp,160
    800058a2:	8082                	ret

00000000800058a4 <sys_chdir>:

uint64
sys_chdir(void)
{
    800058a4:	7135                	addi	sp,sp,-160
    800058a6:	ed06                	sd	ra,152(sp)
    800058a8:	e922                	sd	s0,144(sp)
    800058aa:	e526                	sd	s1,136(sp)
    800058ac:	e14a                	sd	s2,128(sp)
    800058ae:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800058b0:	ffffc097          	auipc	ra,0xffffc
    800058b4:	f9c080e7          	jalr	-100(ra) # 8000184c <myproc>
    800058b8:	892a                	mv	s2,a0
  
  begin_op(ROOTDEV);
    800058ba:	4501                	li	a0,0
    800058bc:	ffffe097          	auipc	ra,0xffffe
    800058c0:	668080e7          	jalr	1640(ra) # 80003f24 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800058c4:	08000613          	li	a2,128
    800058c8:	f6040593          	addi	a1,s0,-160
    800058cc:	4501                	li	a0,0
    800058ce:	ffffd097          	auipc	ra,0xffffd
    800058d2:	07c080e7          	jalr	124(ra) # 8000294a <argstr>
    800058d6:	04054c63          	bltz	a0,8000592e <sys_chdir+0x8a>
    800058da:	f6040513          	addi	a0,s0,-160
    800058de:	ffffe097          	auipc	ra,0xffffe
    800058e2:	32a080e7          	jalr	810(ra) # 80003c08 <namei>
    800058e6:	84aa                	mv	s1,a0
    800058e8:	c139                	beqz	a0,8000592e <sys_chdir+0x8a>
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    800058ea:	ffffe097          	auipc	ra,0xffffe
    800058ee:	b92080e7          	jalr	-1134(ra) # 8000347c <ilock>
  if(ip->type != T_DIR){
    800058f2:	04449703          	lh	a4,68(s1)
    800058f6:	4785                	li	a5,1
    800058f8:	04f71263          	bne	a4,a5,8000593c <sys_chdir+0x98>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }
  iunlock(ip);
    800058fc:	8526                	mv	a0,s1
    800058fe:	ffffe097          	auipc	ra,0xffffe
    80005902:	c40080e7          	jalr	-960(ra) # 8000353e <iunlock>
  iput(p->cwd);
    80005906:	15093503          	ld	a0,336(s2)
    8000590a:	ffffe097          	auipc	ra,0xffffe
    8000590e:	c80080e7          	jalr	-896(ra) # 8000358a <iput>
  end_op(ROOTDEV);
    80005912:	4501                	li	a0,0
    80005914:	ffffe097          	auipc	ra,0xffffe
    80005918:	6ba080e7          	jalr	1722(ra) # 80003fce <end_op>
  p->cwd = ip;
    8000591c:	14993823          	sd	s1,336(s2)
  return 0;
    80005920:	4501                	li	a0,0
}
    80005922:	60ea                	ld	ra,152(sp)
    80005924:	644a                	ld	s0,144(sp)
    80005926:	64aa                	ld	s1,136(sp)
    80005928:	690a                	ld	s2,128(sp)
    8000592a:	610d                	addi	sp,sp,160
    8000592c:	8082                	ret
    end_op(ROOTDEV);
    8000592e:	4501                	li	a0,0
    80005930:	ffffe097          	auipc	ra,0xffffe
    80005934:	69e080e7          	jalr	1694(ra) # 80003fce <end_op>
    return -1;
    80005938:	557d                	li	a0,-1
    8000593a:	b7e5                	j	80005922 <sys_chdir+0x7e>
    iunlockput(ip);
    8000593c:	8526                	mv	a0,s1
    8000593e:	ffffe097          	auipc	ra,0xffffe
    80005942:	d7c080e7          	jalr	-644(ra) # 800036ba <iunlockput>
    end_op(ROOTDEV);
    80005946:	4501                	li	a0,0
    80005948:	ffffe097          	auipc	ra,0xffffe
    8000594c:	686080e7          	jalr	1670(ra) # 80003fce <end_op>
    return -1;
    80005950:	557d                	li	a0,-1
    80005952:	bfc1                	j	80005922 <sys_chdir+0x7e>

0000000080005954 <sys_exec>:

uint64
sys_exec(void)
{
    80005954:	7145                	addi	sp,sp,-464
    80005956:	e786                	sd	ra,456(sp)
    80005958:	e3a2                	sd	s0,448(sp)
    8000595a:	ff26                	sd	s1,440(sp)
    8000595c:	fb4a                	sd	s2,432(sp)
    8000595e:	f74e                	sd	s3,424(sp)
    80005960:	f352                	sd	s4,416(sp)
    80005962:	ef56                	sd	s5,408(sp)
    80005964:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005966:	08000613          	li	a2,128
    8000596a:	f4040593          	addi	a1,s0,-192
    8000596e:	4501                	li	a0,0
    80005970:	ffffd097          	auipc	ra,0xffffd
    80005974:	fda080e7          	jalr	-38(ra) # 8000294a <argstr>
    80005978:	0c054863          	bltz	a0,80005a48 <sys_exec+0xf4>
    8000597c:	e3840593          	addi	a1,s0,-456
    80005980:	4505                	li	a0,1
    80005982:	ffffd097          	auipc	ra,0xffffd
    80005986:	fa6080e7          	jalr	-90(ra) # 80002928 <argaddr>
    8000598a:	0c054963          	bltz	a0,80005a5c <sys_exec+0x108>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    8000598e:	10000613          	li	a2,256
    80005992:	4581                	li	a1,0
    80005994:	e4040513          	addi	a0,s0,-448
    80005998:	ffffb097          	auipc	ra,0xffffb
    8000599c:	216080e7          	jalr	534(ra) # 80000bae <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800059a0:	e4040993          	addi	s3,s0,-448
  memset(argv, 0, sizeof(argv));
    800059a4:	894e                	mv	s2,s3
    800059a6:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    800059a8:	02000a13          	li	s4,32
    800059ac:	00048a9b          	sext.w	s5,s1
      return -1;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800059b0:	00349513          	slli	a0,s1,0x3
    800059b4:	e3040593          	addi	a1,s0,-464
    800059b8:	e3843783          	ld	a5,-456(s0)
    800059bc:	953e                	add	a0,a0,a5
    800059be:	ffffd097          	auipc	ra,0xffffd
    800059c2:	eae080e7          	jalr	-338(ra) # 8000286c <fetchaddr>
    800059c6:	08054d63          	bltz	a0,80005a60 <sys_exec+0x10c>
      return -1;
    }
    if(uarg == 0){
    800059ca:	e3043783          	ld	a5,-464(s0)
    800059ce:	cb85                	beqz	a5,800059fe <sys_exec+0xaa>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800059d0:	ffffb097          	auipc	ra,0xffffb
    800059d4:	fa8080e7          	jalr	-88(ra) # 80000978 <kalloc>
    800059d8:	85aa                	mv	a1,a0
    800059da:	00a93023          	sd	a0,0(s2)
    if(argv[i] == 0)
    800059de:	cd29                	beqz	a0,80005a38 <sys_exec+0xe4>
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
    800059e0:	6605                	lui	a2,0x1
    800059e2:	e3043503          	ld	a0,-464(s0)
    800059e6:	ffffd097          	auipc	ra,0xffffd
    800059ea:	ed8080e7          	jalr	-296(ra) # 800028be <fetchstr>
    800059ee:	06054b63          	bltz	a0,80005a64 <sys_exec+0x110>
    if(i >= NELEM(argv)){
    800059f2:	0485                	addi	s1,s1,1
    800059f4:	0921                	addi	s2,s2,8
    800059f6:	fb449be3          	bne	s1,s4,800059ac <sys_exec+0x58>
      return -1;
    800059fa:	557d                	li	a0,-1
    800059fc:	a0b9                	j	80005a4a <sys_exec+0xf6>
      argv[i] = 0;
    800059fe:	0a8e                	slli	s5,s5,0x3
    80005a00:	fc040793          	addi	a5,s0,-64
    80005a04:	9abe                	add	s5,s5,a5
    80005a06:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd5e3c>
      return -1;
    }
  }

  int ret = exec(path, argv);
    80005a0a:	e4040593          	addi	a1,s0,-448
    80005a0e:	f4040513          	addi	a0,s0,-192
    80005a12:	fffff097          	auipc	ra,0xfffff
    80005a16:	1ba080e7          	jalr	442(ra) # 80004bcc <exec>
    80005a1a:	84aa                	mv	s1,a0

  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a1c:	10098913          	addi	s2,s3,256
    80005a20:	0009b503          	ld	a0,0(s3)
    80005a24:	c901                	beqz	a0,80005a34 <sys_exec+0xe0>
    kfree(argv[i]);
    80005a26:	ffffb097          	auipc	ra,0xffffb
    80005a2a:	e3e080e7          	jalr	-450(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a2e:	09a1                	addi	s3,s3,8
    80005a30:	ff2998e3          	bne	s3,s2,80005a20 <sys_exec+0xcc>

  return ret;
    80005a34:	8526                	mv	a0,s1
    80005a36:	a811                	j	80005a4a <sys_exec+0xf6>
      panic("sys_exec kalloc");
    80005a38:	00002517          	auipc	a0,0x2
    80005a3c:	d9850513          	addi	a0,a0,-616 # 800077d0 <userret+0x740>
    80005a40:	ffffb097          	auipc	ra,0xffffb
    80005a44:	b0e080e7          	jalr	-1266(ra) # 8000054e <panic>
    return -1;
    80005a48:	557d                	li	a0,-1
}
    80005a4a:	60be                	ld	ra,456(sp)
    80005a4c:	641e                	ld	s0,448(sp)
    80005a4e:	74fa                	ld	s1,440(sp)
    80005a50:	795a                	ld	s2,432(sp)
    80005a52:	79ba                	ld	s3,424(sp)
    80005a54:	7a1a                	ld	s4,416(sp)
    80005a56:	6afa                	ld	s5,408(sp)
    80005a58:	6179                	addi	sp,sp,464
    80005a5a:	8082                	ret
    return -1;
    80005a5c:	557d                	li	a0,-1
    80005a5e:	b7f5                	j	80005a4a <sys_exec+0xf6>
      return -1;
    80005a60:	557d                	li	a0,-1
    80005a62:	b7e5                	j	80005a4a <sys_exec+0xf6>
      return -1;
    80005a64:	557d                	li	a0,-1
    80005a66:	b7d5                	j	80005a4a <sys_exec+0xf6>

0000000080005a68 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005a68:	7139                	addi	sp,sp,-64
    80005a6a:	fc06                	sd	ra,56(sp)
    80005a6c:	f822                	sd	s0,48(sp)
    80005a6e:	f426                	sd	s1,40(sp)
    80005a70:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005a72:	ffffc097          	auipc	ra,0xffffc
    80005a76:	dda080e7          	jalr	-550(ra) # 8000184c <myproc>
    80005a7a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005a7c:	fd840593          	addi	a1,s0,-40
    80005a80:	4501                	li	a0,0
    80005a82:	ffffd097          	auipc	ra,0xffffd
    80005a86:	ea6080e7          	jalr	-346(ra) # 80002928 <argaddr>
    return -1;
    80005a8a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005a8c:	0e054063          	bltz	a0,80005b6c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005a90:	fc840593          	addi	a1,s0,-56
    80005a94:	fd040513          	addi	a0,s0,-48
    80005a98:	fffff097          	auipc	ra,0xfffff
    80005a9c:	de8080e7          	jalr	-536(ra) # 80004880 <pipealloc>
    return -1;
    80005aa0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005aa2:	0c054563          	bltz	a0,80005b6c <sys_pipe+0x104>
  fd0 = -1;
    80005aa6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005aaa:	fd043503          	ld	a0,-48(s0)
    80005aae:	fffff097          	auipc	ra,0xfffff
    80005ab2:	4f0080e7          	jalr	1264(ra) # 80004f9e <fdalloc>
    80005ab6:	fca42223          	sw	a0,-60(s0)
    80005aba:	08054c63          	bltz	a0,80005b52 <sys_pipe+0xea>
    80005abe:	fc843503          	ld	a0,-56(s0)
    80005ac2:	fffff097          	auipc	ra,0xfffff
    80005ac6:	4dc080e7          	jalr	1244(ra) # 80004f9e <fdalloc>
    80005aca:	fca42023          	sw	a0,-64(s0)
    80005ace:	06054863          	bltz	a0,80005b3e <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ad2:	4691                	li	a3,4
    80005ad4:	fc440613          	addi	a2,s0,-60
    80005ad8:	fd843583          	ld	a1,-40(s0)
    80005adc:	68a8                	ld	a0,80(s1)
    80005ade:	ffffc097          	auipc	ra,0xffffc
    80005ae2:	a94080e7          	jalr	-1388(ra) # 80001572 <copyout>
    80005ae6:	02054063          	bltz	a0,80005b06 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005aea:	4691                	li	a3,4
    80005aec:	fc040613          	addi	a2,s0,-64
    80005af0:	fd843583          	ld	a1,-40(s0)
    80005af4:	0591                	addi	a1,a1,4
    80005af6:	68a8                	ld	a0,80(s1)
    80005af8:	ffffc097          	auipc	ra,0xffffc
    80005afc:	a7a080e7          	jalr	-1414(ra) # 80001572 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005b00:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b02:	06055563          	bgez	a0,80005b6c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005b06:	fc442783          	lw	a5,-60(s0)
    80005b0a:	07e9                	addi	a5,a5,26
    80005b0c:	078e                	slli	a5,a5,0x3
    80005b0e:	97a6                	add	a5,a5,s1
    80005b10:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005b14:	fc042503          	lw	a0,-64(s0)
    80005b18:	0569                	addi	a0,a0,26
    80005b1a:	050e                	slli	a0,a0,0x3
    80005b1c:	9526                	add	a0,a0,s1
    80005b1e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005b22:	fd043503          	ld	a0,-48(s0)
    80005b26:	fffff097          	auipc	ra,0xfffff
    80005b2a:	a26080e7          	jalr	-1498(ra) # 8000454c <fileclose>
    fileclose(wf);
    80005b2e:	fc843503          	ld	a0,-56(s0)
    80005b32:	fffff097          	auipc	ra,0xfffff
    80005b36:	a1a080e7          	jalr	-1510(ra) # 8000454c <fileclose>
    return -1;
    80005b3a:	57fd                	li	a5,-1
    80005b3c:	a805                	j	80005b6c <sys_pipe+0x104>
    if(fd0 >= 0)
    80005b3e:	fc442783          	lw	a5,-60(s0)
    80005b42:	0007c863          	bltz	a5,80005b52 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005b46:	01a78513          	addi	a0,a5,26
    80005b4a:	050e                	slli	a0,a0,0x3
    80005b4c:	9526                	add	a0,a0,s1
    80005b4e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005b52:	fd043503          	ld	a0,-48(s0)
    80005b56:	fffff097          	auipc	ra,0xfffff
    80005b5a:	9f6080e7          	jalr	-1546(ra) # 8000454c <fileclose>
    fileclose(wf);
    80005b5e:	fc843503          	ld	a0,-56(s0)
    80005b62:	fffff097          	auipc	ra,0xfffff
    80005b66:	9ea080e7          	jalr	-1558(ra) # 8000454c <fileclose>
    return -1;
    80005b6a:	57fd                	li	a5,-1
}
    80005b6c:	853e                	mv	a0,a5
    80005b6e:	70e2                	ld	ra,56(sp)
    80005b70:	7442                	ld	s0,48(sp)
    80005b72:	74a2                	ld	s1,40(sp)
    80005b74:	6121                	addi	sp,sp,64
    80005b76:	8082                	ret

0000000080005b78 <sys_crash>:

// system call to test crashes
uint64
sys_crash(void)
{
    80005b78:	7171                	addi	sp,sp,-176
    80005b7a:	f506                	sd	ra,168(sp)
    80005b7c:	f122                	sd	s0,160(sp)
    80005b7e:	ed26                	sd	s1,152(sp)
    80005b80:	1900                	addi	s0,sp,176
  char path[MAXPATH];
  struct inode *ip;
  int crash;
  
  if(argstr(0, path, MAXPATH) < 0 || argint(1, &crash) < 0)
    80005b82:	08000613          	li	a2,128
    80005b86:	f6040593          	addi	a1,s0,-160
    80005b8a:	4501                	li	a0,0
    80005b8c:	ffffd097          	auipc	ra,0xffffd
    80005b90:	dbe080e7          	jalr	-578(ra) # 8000294a <argstr>
    return -1;
    80005b94:	57fd                	li	a5,-1
  if(argstr(0, path, MAXPATH) < 0 || argint(1, &crash) < 0)
    80005b96:	04054363          	bltz	a0,80005bdc <sys_crash+0x64>
    80005b9a:	f5c40593          	addi	a1,s0,-164
    80005b9e:	4505                	li	a0,1
    80005ba0:	ffffd097          	auipc	ra,0xffffd
    80005ba4:	d66080e7          	jalr	-666(ra) # 80002906 <argint>
    return -1;
    80005ba8:	57fd                	li	a5,-1
  if(argstr(0, path, MAXPATH) < 0 || argint(1, &crash) < 0)
    80005baa:	02054963          	bltz	a0,80005bdc <sys_crash+0x64>
  ip = create(path, T_FILE, 0, 0);
    80005bae:	4681                	li	a3,0
    80005bb0:	4601                	li	a2,0
    80005bb2:	4589                	li	a1,2
    80005bb4:	f6040513          	addi	a0,s0,-160
    80005bb8:	fffff097          	auipc	ra,0xfffff
    80005bbc:	428080e7          	jalr	1064(ra) # 80004fe0 <create>
    80005bc0:	84aa                	mv	s1,a0
  if(ip == 0){
    80005bc2:	c11d                	beqz	a0,80005be8 <sys_crash+0x70>
    return -1;
  }
  iunlockput(ip);
    80005bc4:	ffffe097          	auipc	ra,0xffffe
    80005bc8:	af6080e7          	jalr	-1290(ra) # 800036ba <iunlockput>
  crash_op(ip->dev, crash);
    80005bcc:	f5c42583          	lw	a1,-164(s0)
    80005bd0:	4088                	lw	a0,0(s1)
    80005bd2:	ffffe097          	auipc	ra,0xffffe
    80005bd6:	64e080e7          	jalr	1614(ra) # 80004220 <crash_op>
  return 0;
    80005bda:	4781                	li	a5,0
}
    80005bdc:	853e                	mv	a0,a5
    80005bde:	70aa                	ld	ra,168(sp)
    80005be0:	740a                	ld	s0,160(sp)
    80005be2:	64ea                	ld	s1,152(sp)
    80005be4:	614d                	addi	sp,sp,176
    80005be6:	8082                	ret
    return -1;
    80005be8:	57fd                	li	a5,-1
    80005bea:	bfcd                	j	80005bdc <sys_crash+0x64>
    80005bec:	0000                	unimp
	...

0000000080005bf0 <kernelvec>:
    80005bf0:	7111                	addi	sp,sp,-256
    80005bf2:	e006                	sd	ra,0(sp)
    80005bf4:	e40a                	sd	sp,8(sp)
    80005bf6:	e80e                	sd	gp,16(sp)
    80005bf8:	ec12                	sd	tp,24(sp)
    80005bfa:	f016                	sd	t0,32(sp)
    80005bfc:	f41a                	sd	t1,40(sp)
    80005bfe:	f81e                	sd	t2,48(sp)
    80005c00:	fc22                	sd	s0,56(sp)
    80005c02:	e0a6                	sd	s1,64(sp)
    80005c04:	e4aa                	sd	a0,72(sp)
    80005c06:	e8ae                	sd	a1,80(sp)
    80005c08:	ecb2                	sd	a2,88(sp)
    80005c0a:	f0b6                	sd	a3,96(sp)
    80005c0c:	f4ba                	sd	a4,104(sp)
    80005c0e:	f8be                	sd	a5,112(sp)
    80005c10:	fcc2                	sd	a6,120(sp)
    80005c12:	e146                	sd	a7,128(sp)
    80005c14:	e54a                	sd	s2,136(sp)
    80005c16:	e94e                	sd	s3,144(sp)
    80005c18:	ed52                	sd	s4,152(sp)
    80005c1a:	f156                	sd	s5,160(sp)
    80005c1c:	f55a                	sd	s6,168(sp)
    80005c1e:	f95e                	sd	s7,176(sp)
    80005c20:	fd62                	sd	s8,184(sp)
    80005c22:	e1e6                	sd	s9,192(sp)
    80005c24:	e5ea                	sd	s10,200(sp)
    80005c26:	e9ee                	sd	s11,208(sp)
    80005c28:	edf2                	sd	t3,216(sp)
    80005c2a:	f1f6                	sd	t4,224(sp)
    80005c2c:	f5fa                	sd	t5,232(sp)
    80005c2e:	f9fe                	sd	t6,240(sp)
    80005c30:	b09fc0ef          	jal	ra,80002738 <kerneltrap>
    80005c34:	6082                	ld	ra,0(sp)
    80005c36:	6122                	ld	sp,8(sp)
    80005c38:	61c2                	ld	gp,16(sp)
    80005c3a:	7282                	ld	t0,32(sp)
    80005c3c:	7322                	ld	t1,40(sp)
    80005c3e:	73c2                	ld	t2,48(sp)
    80005c40:	7462                	ld	s0,56(sp)
    80005c42:	6486                	ld	s1,64(sp)
    80005c44:	6526                	ld	a0,72(sp)
    80005c46:	65c6                	ld	a1,80(sp)
    80005c48:	6666                	ld	a2,88(sp)
    80005c4a:	7686                	ld	a3,96(sp)
    80005c4c:	7726                	ld	a4,104(sp)
    80005c4e:	77c6                	ld	a5,112(sp)
    80005c50:	7866                	ld	a6,120(sp)
    80005c52:	688a                	ld	a7,128(sp)
    80005c54:	692a                	ld	s2,136(sp)
    80005c56:	69ca                	ld	s3,144(sp)
    80005c58:	6a6a                	ld	s4,152(sp)
    80005c5a:	7a8a                	ld	s5,160(sp)
    80005c5c:	7b2a                	ld	s6,168(sp)
    80005c5e:	7bca                	ld	s7,176(sp)
    80005c60:	7c6a                	ld	s8,184(sp)
    80005c62:	6c8e                	ld	s9,192(sp)
    80005c64:	6d2e                	ld	s10,200(sp)
    80005c66:	6dce                	ld	s11,208(sp)
    80005c68:	6e6e                	ld	t3,216(sp)
    80005c6a:	7e8e                	ld	t4,224(sp)
    80005c6c:	7f2e                	ld	t5,232(sp)
    80005c6e:	7fce                	ld	t6,240(sp)
    80005c70:	6111                	addi	sp,sp,256
    80005c72:	10200073          	sret
    80005c76:	00000013          	nop
    80005c7a:	00000013          	nop
    80005c7e:	0001                	nop

0000000080005c80 <timervec>:
    80005c80:	34051573          	csrrw	a0,mscratch,a0
    80005c84:	e10c                	sd	a1,0(a0)
    80005c86:	e510                	sd	a2,8(a0)
    80005c88:	e914                	sd	a3,16(a0)
    80005c8a:	710c                	ld	a1,32(a0)
    80005c8c:	7510                	ld	a2,40(a0)
    80005c8e:	6194                	ld	a3,0(a1)
    80005c90:	96b2                	add	a3,a3,a2
    80005c92:	e194                	sd	a3,0(a1)
    80005c94:	4589                	li	a1,2
    80005c96:	14459073          	csrw	sip,a1
    80005c9a:	6914                	ld	a3,16(a0)
    80005c9c:	6510                	ld	a2,8(a0)
    80005c9e:	610c                	ld	a1,0(a0)
    80005ca0:	34051573          	csrrw	a0,mscratch,a0
    80005ca4:	30200073          	mret
	...

0000000080005caa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005caa:	1141                	addi	sp,sp,-16
    80005cac:	e422                	sd	s0,8(sp)
    80005cae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005cb0:	0c0007b7          	lui	a5,0xc000
    80005cb4:	4705                	li	a4,1
    80005cb6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005cb8:	c3d8                	sw	a4,4(a5)
}
    80005cba:	6422                	ld	s0,8(sp)
    80005cbc:	0141                	addi	sp,sp,16
    80005cbe:	8082                	ret

0000000080005cc0 <plicinithart>:

void
plicinithart(void)
{
    80005cc0:	1141                	addi	sp,sp,-16
    80005cc2:	e406                	sd	ra,8(sp)
    80005cc4:	e022                	sd	s0,0(sp)
    80005cc6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005cc8:	ffffc097          	auipc	ra,0xffffc
    80005ccc:	b58080e7          	jalr	-1192(ra) # 80001820 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005cd0:	0085171b          	slliw	a4,a0,0x8
    80005cd4:	0c0027b7          	lui	a5,0xc002
    80005cd8:	97ba                	add	a5,a5,a4
    80005cda:	40200713          	li	a4,1026
    80005cde:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005ce2:	00d5151b          	slliw	a0,a0,0xd
    80005ce6:	0c2017b7          	lui	a5,0xc201
    80005cea:	953e                	add	a0,a0,a5
    80005cec:	00052023          	sw	zero,0(a0)
}
    80005cf0:	60a2                	ld	ra,8(sp)
    80005cf2:	6402                	ld	s0,0(sp)
    80005cf4:	0141                	addi	sp,sp,16
    80005cf6:	8082                	ret

0000000080005cf8 <plic_pending>:

// return a bitmap of which IRQs are waiting
// to be served.
uint64
plic_pending(void)
{
    80005cf8:	1141                	addi	sp,sp,-16
    80005cfa:	e422                	sd	s0,8(sp)
    80005cfc:	0800                	addi	s0,sp,16
  //mask = *(uint32*)(PLIC + 0x1000);
  //mask |= (uint64)*(uint32*)(PLIC + 0x1004) << 32;
  mask = *(uint64*)PLIC_PENDING;

  return mask;
}
    80005cfe:	0c0017b7          	lui	a5,0xc001
    80005d02:	6388                	ld	a0,0(a5)
    80005d04:	6422                	ld	s0,8(sp)
    80005d06:	0141                	addi	sp,sp,16
    80005d08:	8082                	ret

0000000080005d0a <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005d0a:	1141                	addi	sp,sp,-16
    80005d0c:	e406                	sd	ra,8(sp)
    80005d0e:	e022                	sd	s0,0(sp)
    80005d10:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005d12:	ffffc097          	auipc	ra,0xffffc
    80005d16:	b0e080e7          	jalr	-1266(ra) # 80001820 <cpuid>
  //int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005d1a:	00d5179b          	slliw	a5,a0,0xd
    80005d1e:	0c201537          	lui	a0,0xc201
    80005d22:	953e                	add	a0,a0,a5
  return irq;
}
    80005d24:	4148                	lw	a0,4(a0)
    80005d26:	60a2                	ld	ra,8(sp)
    80005d28:	6402                	ld	s0,0(sp)
    80005d2a:	0141                	addi	sp,sp,16
    80005d2c:	8082                	ret

0000000080005d2e <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005d2e:	1101                	addi	sp,sp,-32
    80005d30:	ec06                	sd	ra,24(sp)
    80005d32:	e822                	sd	s0,16(sp)
    80005d34:	e426                	sd	s1,8(sp)
    80005d36:	1000                	addi	s0,sp,32
    80005d38:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005d3a:	ffffc097          	auipc	ra,0xffffc
    80005d3e:	ae6080e7          	jalr	-1306(ra) # 80001820 <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005d42:	00d5151b          	slliw	a0,a0,0xd
    80005d46:	0c2017b7          	lui	a5,0xc201
    80005d4a:	97aa                	add	a5,a5,a0
    80005d4c:	c3c4                	sw	s1,4(a5)
}
    80005d4e:	60e2                	ld	ra,24(sp)
    80005d50:	6442                	ld	s0,16(sp)
    80005d52:	64a2                	ld	s1,8(sp)
    80005d54:	6105                	addi	sp,sp,32
    80005d56:	8082                	ret

0000000080005d58 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int n, int i)
{
    80005d58:	1141                	addi	sp,sp,-16
    80005d5a:	e406                	sd	ra,8(sp)
    80005d5c:	e022                	sd	s0,0(sp)
    80005d5e:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005d60:	479d                	li	a5,7
    80005d62:	06b7c963          	blt	a5,a1,80005dd4 <free_desc+0x7c>
    panic("virtio_disk_intr 1");
  if(disk[n].free[i])
    80005d66:	00151793          	slli	a5,a0,0x1
    80005d6a:	97aa                	add	a5,a5,a0
    80005d6c:	00c79713          	slli	a4,a5,0xc
    80005d70:	0001d797          	auipc	a5,0x1d
    80005d74:	29078793          	addi	a5,a5,656 # 80023000 <disk>
    80005d78:	97ba                	add	a5,a5,a4
    80005d7a:	97ae                	add	a5,a5,a1
    80005d7c:	6709                	lui	a4,0x2
    80005d7e:	97ba                	add	a5,a5,a4
    80005d80:	0187c783          	lbu	a5,24(a5)
    80005d84:	e3a5                	bnez	a5,80005de4 <free_desc+0x8c>
    panic("virtio_disk_intr 2");
  disk[n].desc[i].addr = 0;
    80005d86:	0001d817          	auipc	a6,0x1d
    80005d8a:	27a80813          	addi	a6,a6,634 # 80023000 <disk>
    80005d8e:	00151693          	slli	a3,a0,0x1
    80005d92:	00a68733          	add	a4,a3,a0
    80005d96:	0732                	slli	a4,a4,0xc
    80005d98:	00e807b3          	add	a5,a6,a4
    80005d9c:	6709                	lui	a4,0x2
    80005d9e:	00f70633          	add	a2,a4,a5
    80005da2:	6210                	ld	a2,0(a2)
    80005da4:	00459893          	slli	a7,a1,0x4
    80005da8:	9646                	add	a2,a2,a7
    80005daa:	00063023          	sd	zero,0(a2) # 1000 <_entry-0x7ffff000>
  disk[n].free[i] = 1;
    80005dae:	97ae                	add	a5,a5,a1
    80005db0:	97ba                	add	a5,a5,a4
    80005db2:	4605                	li	a2,1
    80005db4:	00c78c23          	sb	a2,24(a5)
  wakeup(&disk[n].free[0]);
    80005db8:	96aa                	add	a3,a3,a0
    80005dba:	06b2                	slli	a3,a3,0xc
    80005dbc:	0761                	addi	a4,a4,24
    80005dbe:	96ba                	add	a3,a3,a4
    80005dc0:	00d80533          	add	a0,a6,a3
    80005dc4:	ffffc097          	auipc	ra,0xffffc
    80005dc8:	420080e7          	jalr	1056(ra) # 800021e4 <wakeup>
}
    80005dcc:	60a2                	ld	ra,8(sp)
    80005dce:	6402                	ld	s0,0(sp)
    80005dd0:	0141                	addi	sp,sp,16
    80005dd2:	8082                	ret
    panic("virtio_disk_intr 1");
    80005dd4:	00002517          	auipc	a0,0x2
    80005dd8:	a0c50513          	addi	a0,a0,-1524 # 800077e0 <userret+0x750>
    80005ddc:	ffffa097          	auipc	ra,0xffffa
    80005de0:	772080e7          	jalr	1906(ra) # 8000054e <panic>
    panic("virtio_disk_intr 2");
    80005de4:	00002517          	auipc	a0,0x2
    80005de8:	a1450513          	addi	a0,a0,-1516 # 800077f8 <userret+0x768>
    80005dec:	ffffa097          	auipc	ra,0xffffa
    80005df0:	762080e7          	jalr	1890(ra) # 8000054e <panic>

0000000080005df4 <virtio_disk_init>:
  __sync_synchronize();
    80005df4:	0ff0000f          	fence
  if(disk[n].init)
    80005df8:	00151793          	slli	a5,a0,0x1
    80005dfc:	97aa                	add	a5,a5,a0
    80005dfe:	07b2                	slli	a5,a5,0xc
    80005e00:	0001d717          	auipc	a4,0x1d
    80005e04:	20070713          	addi	a4,a4,512 # 80023000 <disk>
    80005e08:	973e                	add	a4,a4,a5
    80005e0a:	6789                	lui	a5,0x2
    80005e0c:	97ba                	add	a5,a5,a4
    80005e0e:	0a87a783          	lw	a5,168(a5) # 20a8 <_entry-0x7fffdf58>
    80005e12:	c391                	beqz	a5,80005e16 <virtio_disk_init+0x22>
    80005e14:	8082                	ret
{
    80005e16:	7139                	addi	sp,sp,-64
    80005e18:	fc06                	sd	ra,56(sp)
    80005e1a:	f822                	sd	s0,48(sp)
    80005e1c:	f426                	sd	s1,40(sp)
    80005e1e:	f04a                	sd	s2,32(sp)
    80005e20:	ec4e                	sd	s3,24(sp)
    80005e22:	e852                	sd	s4,16(sp)
    80005e24:	e456                	sd	s5,8(sp)
    80005e26:	0080                	addi	s0,sp,64
    80005e28:	84aa                	mv	s1,a0
  printf("virtio disk init %d\n", n);
    80005e2a:	85aa                	mv	a1,a0
    80005e2c:	00002517          	auipc	a0,0x2
    80005e30:	9e450513          	addi	a0,a0,-1564 # 80007810 <userret+0x780>
    80005e34:	ffffa097          	auipc	ra,0xffffa
    80005e38:	764080e7          	jalr	1892(ra) # 80000598 <printf>
  initlock(&disk[n].vdisk_lock, "virtio_disk");
    80005e3c:	00149993          	slli	s3,s1,0x1
    80005e40:	99a6                	add	s3,s3,s1
    80005e42:	09b2                	slli	s3,s3,0xc
    80005e44:	6789                	lui	a5,0x2
    80005e46:	0b078793          	addi	a5,a5,176 # 20b0 <_entry-0x7fffdf50>
    80005e4a:	97ce                	add	a5,a5,s3
    80005e4c:	00002597          	auipc	a1,0x2
    80005e50:	9dc58593          	addi	a1,a1,-1572 # 80007828 <userret+0x798>
    80005e54:	0001d517          	auipc	a0,0x1d
    80005e58:	1ac50513          	addi	a0,a0,428 # 80023000 <disk>
    80005e5c:	953e                	add	a0,a0,a5
    80005e5e:	ffffb097          	auipc	ra,0xffffb
    80005e62:	b7a080e7          	jalr	-1158(ra) # 800009d8 <initlock>
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e66:	0014891b          	addiw	s2,s1,1
    80005e6a:	00c9191b          	slliw	s2,s2,0xc
    80005e6e:	100007b7          	lui	a5,0x10000
    80005e72:	97ca                	add	a5,a5,s2
    80005e74:	4398                	lw	a4,0(a5)
    80005e76:	2701                	sext.w	a4,a4
    80005e78:	747277b7          	lui	a5,0x74727
    80005e7c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005e80:	12f71663          	bne	a4,a5,80005fac <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80005e84:	100007b7          	lui	a5,0x10000
    80005e88:	0791                	addi	a5,a5,4
    80005e8a:	97ca                	add	a5,a5,s2
    80005e8c:	439c                	lw	a5,0(a5)
    80005e8e:	2781                	sext.w	a5,a5
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e90:	4705                	li	a4,1
    80005e92:	10e79d63          	bne	a5,a4,80005fac <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e96:	100007b7          	lui	a5,0x10000
    80005e9a:	07a1                	addi	a5,a5,8
    80005e9c:	97ca                	add	a5,a5,s2
    80005e9e:	439c                	lw	a5,0(a5)
    80005ea0:	2781                	sext.w	a5,a5
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80005ea2:	4709                	li	a4,2
    80005ea4:	10e79463          	bne	a5,a4,80005fac <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005ea8:	100007b7          	lui	a5,0x10000
    80005eac:	07b1                	addi	a5,a5,12
    80005eae:	97ca                	add	a5,a5,s2
    80005eb0:	4398                	lw	a4,0(a5)
    80005eb2:	2701                	sext.w	a4,a4
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005eb4:	554d47b7          	lui	a5,0x554d4
    80005eb8:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005ebc:	0ef71863          	bne	a4,a5,80005fac <virtio_disk_init+0x1b8>
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005ec0:	100007b7          	lui	a5,0x10000
    80005ec4:	07078693          	addi	a3,a5,112 # 10000070 <_entry-0x6fffff90>
    80005ec8:	96ca                	add	a3,a3,s2
    80005eca:	4705                	li	a4,1
    80005ecc:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005ece:	470d                	li	a4,3
    80005ed0:	c298                	sw	a4,0(a3)
  uint64 features = *R(n, VIRTIO_MMIO_DEVICE_FEATURES);
    80005ed2:	01078713          	addi	a4,a5,16
    80005ed6:	974a                	add	a4,a4,s2
    80005ed8:	430c                	lw	a1,0(a4)
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005eda:	02078613          	addi	a2,a5,32
    80005ede:	964a                	add	a2,a2,s2
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005ee0:	c7ffe737          	lui	a4,0xc7ffe
    80005ee4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd571b>
    80005ee8:	8f6d                	and	a4,a4,a1
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005eea:	2701                	sext.w	a4,a4
    80005eec:	c218                	sw	a4,0(a2)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005eee:	472d                	li	a4,11
    80005ef0:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005ef2:	473d                	li	a4,15
    80005ef4:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005ef6:	02878713          	addi	a4,a5,40
    80005efa:	974a                	add	a4,a4,s2
    80005efc:	6685                	lui	a3,0x1
    80005efe:	c314                	sw	a3,0(a4)
  *R(n, VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005f00:	03078713          	addi	a4,a5,48
    80005f04:	974a                	add	a4,a4,s2
    80005f06:	00072023          	sw	zero,0(a4)
  uint32 max = *R(n, VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005f0a:	03478793          	addi	a5,a5,52
    80005f0e:	97ca                	add	a5,a5,s2
    80005f10:	439c                	lw	a5,0(a5)
    80005f12:	2781                	sext.w	a5,a5
  if(max == 0)
    80005f14:	c7c5                	beqz	a5,80005fbc <virtio_disk_init+0x1c8>
  if(max < NUM)
    80005f16:	471d                	li	a4,7
    80005f18:	0af77a63          	bgeu	a4,a5,80005fcc <virtio_disk_init+0x1d8>
  *R(n, VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005f1c:	10000ab7          	lui	s5,0x10000
    80005f20:	038a8793          	addi	a5,s5,56 # 10000038 <_entry-0x6fffffc8>
    80005f24:	97ca                	add	a5,a5,s2
    80005f26:	4721                	li	a4,8
    80005f28:	c398                	sw	a4,0(a5)
  memset(disk[n].pages, 0, sizeof(disk[n].pages));
    80005f2a:	0001da17          	auipc	s4,0x1d
    80005f2e:	0d6a0a13          	addi	s4,s4,214 # 80023000 <disk>
    80005f32:	99d2                	add	s3,s3,s4
    80005f34:	6609                	lui	a2,0x2
    80005f36:	4581                	li	a1,0
    80005f38:	854e                	mv	a0,s3
    80005f3a:	ffffb097          	auipc	ra,0xffffb
    80005f3e:	c74080e7          	jalr	-908(ra) # 80000bae <memset>
  *R(n, VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk[n].pages) >> PGSHIFT;
    80005f42:	040a8a93          	addi	s5,s5,64
    80005f46:	9956                	add	s2,s2,s5
    80005f48:	00c9d793          	srli	a5,s3,0xc
    80005f4c:	2781                	sext.w	a5,a5
    80005f4e:	00f92023          	sw	a5,0(s2)
  disk[n].desc = (struct VRingDesc *) disk[n].pages;
    80005f52:	00149513          	slli	a0,s1,0x1
    80005f56:	009507b3          	add	a5,a0,s1
    80005f5a:	07b2                	slli	a5,a5,0xc
    80005f5c:	97d2                	add	a5,a5,s4
    80005f5e:	6689                	lui	a3,0x2
    80005f60:	97b6                	add	a5,a5,a3
    80005f62:	0137b023          	sd	s3,0(a5)
  disk[n].avail = (uint16*)(((char*)disk[n].desc) + NUM*sizeof(struct VRingDesc));
    80005f66:	08098713          	addi	a4,s3,128
    80005f6a:	e798                	sd	a4,8(a5)
  disk[n].used = (struct UsedArea *) (disk[n].pages + PGSIZE);
    80005f6c:	6705                	lui	a4,0x1
    80005f6e:	99ba                	add	s3,s3,a4
    80005f70:	0137b823          	sd	s3,16(a5)
    disk[n].free[i] = 1;
    80005f74:	4705                	li	a4,1
    80005f76:	00e78c23          	sb	a4,24(a5)
    80005f7a:	00e78ca3          	sb	a4,25(a5)
    80005f7e:	00e78d23          	sb	a4,26(a5)
    80005f82:	00e78da3          	sb	a4,27(a5)
    80005f86:	00e78e23          	sb	a4,28(a5)
    80005f8a:	00e78ea3          	sb	a4,29(a5)
    80005f8e:	00e78f23          	sb	a4,30(a5)
    80005f92:	00e78fa3          	sb	a4,31(a5)
  disk[n].init = 1;
    80005f96:	0ae7a423          	sw	a4,168(a5)
}
    80005f9a:	70e2                	ld	ra,56(sp)
    80005f9c:	7442                	ld	s0,48(sp)
    80005f9e:	74a2                	ld	s1,40(sp)
    80005fa0:	7902                	ld	s2,32(sp)
    80005fa2:	69e2                	ld	s3,24(sp)
    80005fa4:	6a42                	ld	s4,16(sp)
    80005fa6:	6aa2                	ld	s5,8(sp)
    80005fa8:	6121                	addi	sp,sp,64
    80005faa:	8082                	ret
    panic("could not find virtio disk");
    80005fac:	00002517          	auipc	a0,0x2
    80005fb0:	88c50513          	addi	a0,a0,-1908 # 80007838 <userret+0x7a8>
    80005fb4:	ffffa097          	auipc	ra,0xffffa
    80005fb8:	59a080e7          	jalr	1434(ra) # 8000054e <panic>
    panic("virtio disk has no queue 0");
    80005fbc:	00002517          	auipc	a0,0x2
    80005fc0:	89c50513          	addi	a0,a0,-1892 # 80007858 <userret+0x7c8>
    80005fc4:	ffffa097          	auipc	ra,0xffffa
    80005fc8:	58a080e7          	jalr	1418(ra) # 8000054e <panic>
    panic("virtio disk max queue too short");
    80005fcc:	00002517          	auipc	a0,0x2
    80005fd0:	8ac50513          	addi	a0,a0,-1876 # 80007878 <userret+0x7e8>
    80005fd4:	ffffa097          	auipc	ra,0xffffa
    80005fd8:	57a080e7          	jalr	1402(ra) # 8000054e <panic>

0000000080005fdc <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(int n, struct buf *b, int write)
{
    80005fdc:	7135                	addi	sp,sp,-160
    80005fde:	ed06                	sd	ra,152(sp)
    80005fe0:	e922                	sd	s0,144(sp)
    80005fe2:	e526                	sd	s1,136(sp)
    80005fe4:	e14a                	sd	s2,128(sp)
    80005fe6:	fcce                	sd	s3,120(sp)
    80005fe8:	f8d2                	sd	s4,112(sp)
    80005fea:	f4d6                	sd	s5,104(sp)
    80005fec:	f0da                	sd	s6,96(sp)
    80005fee:	ecde                	sd	s7,88(sp)
    80005ff0:	e8e2                	sd	s8,80(sp)
    80005ff2:	e4e6                	sd	s9,72(sp)
    80005ff4:	e0ea                	sd	s10,64(sp)
    80005ff6:	fc6e                	sd	s11,56(sp)
    80005ff8:	1100                	addi	s0,sp,160
    80005ffa:	892a                	mv	s2,a0
    80005ffc:	89ae                	mv	s3,a1
    80005ffe:	8db2                	mv	s11,a2
  uint64 sector = b->blockno * (BSIZE / 512);
    80006000:	45dc                	lw	a5,12(a1)
    80006002:	0017979b          	slliw	a5,a5,0x1
    80006006:	1782                	slli	a5,a5,0x20
    80006008:	9381                	srli	a5,a5,0x20
    8000600a:	f6f43423          	sd	a5,-152(s0)

  acquire(&disk[n].vdisk_lock);
    8000600e:	00151493          	slli	s1,a0,0x1
    80006012:	94aa                	add	s1,s1,a0
    80006014:	04b2                	slli	s1,s1,0xc
    80006016:	6a89                	lui	s5,0x2
    80006018:	0b0a8a13          	addi	s4,s5,176 # 20b0 <_entry-0x7fffdf50>
    8000601c:	9a26                	add	s4,s4,s1
    8000601e:	0001db97          	auipc	s7,0x1d
    80006022:	fe2b8b93          	addi	s7,s7,-30 # 80023000 <disk>
    80006026:	9a5e                	add	s4,s4,s7
    80006028:	8552                	mv	a0,s4
    8000602a:	ffffb097          	auipc	ra,0xffffb
    8000602e:	ac0080e7          	jalr	-1344(ra) # 80000aea <acquire>
  int idx[3];
  while(1){
    if(alloc3_desc(n, idx) == 0) {
      break;
    }
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    80006032:	0ae1                	addi	s5,s5,24
    80006034:	94d6                	add	s1,s1,s5
    80006036:	01748ab3          	add	s5,s1,s7
    8000603a:	8d56                	mv	s10,s5
  for(int i = 0; i < 3; i++){
    8000603c:	4b81                	li	s7,0
  for(int i = 0; i < NUM; i++){
    8000603e:	4ca1                	li	s9,8
      disk[n].free[i] = 0;
    80006040:	00191b13          	slli	s6,s2,0x1
    80006044:	9b4a                	add	s6,s6,s2
    80006046:	00cb1793          	slli	a5,s6,0xc
    8000604a:	0001db17          	auipc	s6,0x1d
    8000604e:	fb6b0b13          	addi	s6,s6,-74 # 80023000 <disk>
    80006052:	9b3e                	add	s6,s6,a5
  for(int i = 0; i < NUM; i++){
    80006054:	8c5e                	mv	s8,s7
    80006056:	a8ad                	j	800060d0 <virtio_disk_rw+0xf4>
      disk[n].free[i] = 0;
    80006058:	00fb06b3          	add	a3,s6,a5
    8000605c:	96aa                	add	a3,a3,a0
    8000605e:	00068c23          	sb	zero,24(a3) # 2018 <_entry-0x7fffdfe8>
    idx[i] = alloc_desc(n);
    80006062:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80006064:	0207c363          	bltz	a5,8000608a <virtio_disk_rw+0xae>
  for(int i = 0; i < 3; i++){
    80006068:	2485                	addiw	s1,s1,1
    8000606a:	0711                	addi	a4,a4,4
    8000606c:	1eb48363          	beq	s1,a1,80006252 <virtio_disk_rw+0x276>
    idx[i] = alloc_desc(n);
    80006070:	863a                	mv	a2,a4
    80006072:	86ea                	mv	a3,s10
  for(int i = 0; i < NUM; i++){
    80006074:	87e2                	mv	a5,s8
    if(disk[n].free[i]){
    80006076:	0006c803          	lbu	a6,0(a3)
    8000607a:	fc081fe3          	bnez	a6,80006058 <virtio_disk_rw+0x7c>
  for(int i = 0; i < NUM; i++){
    8000607e:	2785                	addiw	a5,a5,1
    80006080:	0685                	addi	a3,a3,1
    80006082:	ff979ae3          	bne	a5,s9,80006076 <virtio_disk_rw+0x9a>
    idx[i] = alloc_desc(n);
    80006086:	57fd                	li	a5,-1
    80006088:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000608a:	02905d63          	blez	s1,800060c4 <virtio_disk_rw+0xe8>
        free_desc(n, idx[j]);
    8000608e:	f8042583          	lw	a1,-128(s0)
    80006092:	854a                	mv	a0,s2
    80006094:	00000097          	auipc	ra,0x0
    80006098:	cc4080e7          	jalr	-828(ra) # 80005d58 <free_desc>
      for(int j = 0; j < i; j++)
    8000609c:	4785                	li	a5,1
    8000609e:	0297d363          	bge	a5,s1,800060c4 <virtio_disk_rw+0xe8>
        free_desc(n, idx[j]);
    800060a2:	f8442583          	lw	a1,-124(s0)
    800060a6:	854a                	mv	a0,s2
    800060a8:	00000097          	auipc	ra,0x0
    800060ac:	cb0080e7          	jalr	-848(ra) # 80005d58 <free_desc>
      for(int j = 0; j < i; j++)
    800060b0:	4789                	li	a5,2
    800060b2:	0097d963          	bge	a5,s1,800060c4 <virtio_disk_rw+0xe8>
        free_desc(n, idx[j]);
    800060b6:	f8842583          	lw	a1,-120(s0)
    800060ba:	854a                	mv	a0,s2
    800060bc:	00000097          	auipc	ra,0x0
    800060c0:	c9c080e7          	jalr	-868(ra) # 80005d58 <free_desc>
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    800060c4:	85d2                	mv	a1,s4
    800060c6:	8556                	mv	a0,s5
    800060c8:	ffffc097          	auipc	ra,0xffffc
    800060cc:	f96080e7          	jalr	-106(ra) # 8000205e <sleep>
  for(int i = 0; i < 3; i++){
    800060d0:	f8040713          	addi	a4,s0,-128
    800060d4:	84de                	mv	s1,s7
      disk[n].free[i] = 0;
    800060d6:	6509                	lui	a0,0x2
  for(int i = 0; i < 3; i++){
    800060d8:	458d                	li	a1,3
    800060da:	bf59                	j	80006070 <virtio_disk_rw+0x94>
  disk[n].desc[idx[0]].next = idx[1];

  disk[n].desc[idx[1]].addr = (uint64) b->data;
  disk[n].desc[idx[1]].len = BSIZE;
  if(write)
    disk[n].desc[idx[1]].flags = 0; // device reads b->data
    800060dc:	00191793          	slli	a5,s2,0x1
    800060e0:	97ca                	add	a5,a5,s2
    800060e2:	07b2                	slli	a5,a5,0xc
    800060e4:	0001d717          	auipc	a4,0x1d
    800060e8:	f1c70713          	addi	a4,a4,-228 # 80023000 <disk>
    800060ec:	973e                	add	a4,a4,a5
    800060ee:	6789                	lui	a5,0x2
    800060f0:	97ba                	add	a5,a5,a4
    800060f2:	639c                	ld	a5,0(a5)
    800060f4:	97b6                	add	a5,a5,a3
    800060f6:	00079623          	sh	zero,12(a5) # 200c <_entry-0x7fffdff4>
  else
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk[n].desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800060fa:	0001d517          	auipc	a0,0x1d
    800060fe:	f0650513          	addi	a0,a0,-250 # 80023000 <disk>
    80006102:	00191793          	slli	a5,s2,0x1
    80006106:	01278733          	add	a4,a5,s2
    8000610a:	0732                	slli	a4,a4,0xc
    8000610c:	972a                	add	a4,a4,a0
    8000610e:	6609                	lui	a2,0x2
    80006110:	9732                	add	a4,a4,a2
    80006112:	630c                	ld	a1,0(a4)
    80006114:	95b6                	add	a1,a1,a3
    80006116:	00c5d603          	lhu	a2,12(a1)
    8000611a:	00166613          	ori	a2,a2,1
    8000611e:	00c59623          	sh	a2,12(a1)
  disk[n].desc[idx[1]].next = idx[2];
    80006122:	f8842603          	lw	a2,-120(s0)
    80006126:	630c                	ld	a1,0(a4)
    80006128:	96ae                	add	a3,a3,a1
    8000612a:	00c69723          	sh	a2,14(a3)

  disk[n].info[idx[0]].status = 0;
    8000612e:	97ca                	add	a5,a5,s2
    80006130:	07a2                	slli	a5,a5,0x8
    80006132:	97a6                	add	a5,a5,s1
    80006134:	20078793          	addi	a5,a5,512
    80006138:	0792                	slli	a5,a5,0x4
    8000613a:	97aa                	add	a5,a5,a0
    8000613c:	02078823          	sb	zero,48(a5)
  disk[n].desc[idx[2]].addr = (uint64) &disk[n].info[idx[0]].status;
    80006140:	00461693          	slli	a3,a2,0x4
    80006144:	00073803          	ld	a6,0(a4)
    80006148:	9836                	add	a6,a6,a3
    8000614a:	20348613          	addi	a2,s1,515
    8000614e:	00191593          	slli	a1,s2,0x1
    80006152:	95ca                	add	a1,a1,s2
    80006154:	05a2                	slli	a1,a1,0x8
    80006156:	962e                	add	a2,a2,a1
    80006158:	0612                	slli	a2,a2,0x4
    8000615a:	962a                	add	a2,a2,a0
    8000615c:	00c83023          	sd	a2,0(a6)
  disk[n].desc[idx[2]].len = 1;
    80006160:	630c                	ld	a1,0(a4)
    80006162:	95b6                	add	a1,a1,a3
    80006164:	4605                	li	a2,1
    80006166:	c590                	sw	a2,8(a1)
  disk[n].desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006168:	630c                	ld	a1,0(a4)
    8000616a:	95b6                	add	a1,a1,a3
    8000616c:	4509                	li	a0,2
    8000616e:	00a59623          	sh	a0,12(a1)
  disk[n].desc[idx[2]].next = 0;
    80006172:	630c                	ld	a1,0(a4)
    80006174:	96ae                	add	a3,a3,a1
    80006176:	00069723          	sh	zero,14(a3)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000617a:	00c9a223          	sw	a2,4(s3)
  disk[n].info[idx[0]].b = b;
    8000617e:	0337b423          	sd	s3,40(a5)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk[n].avail[2 + (disk[n].avail[1] % NUM)] = idx[0];
    80006182:	6714                	ld	a3,8(a4)
    80006184:	0026d783          	lhu	a5,2(a3)
    80006188:	8b9d                	andi	a5,a5,7
    8000618a:	2789                	addiw	a5,a5,2
    8000618c:	0786                	slli	a5,a5,0x1
    8000618e:	97b6                	add	a5,a5,a3
    80006190:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    80006194:	0ff0000f          	fence
  disk[n].avail[1] = disk[n].avail[1] + 1;
    80006198:	6718                	ld	a4,8(a4)
    8000619a:	00275783          	lhu	a5,2(a4)
    8000619e:	2785                	addiw	a5,a5,1
    800061a0:	00f71123          	sh	a5,2(a4)

  *R(n, VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800061a4:	0019079b          	addiw	a5,s2,1
    800061a8:	00c7979b          	slliw	a5,a5,0xc
    800061ac:	10000737          	lui	a4,0x10000
    800061b0:	05070713          	addi	a4,a4,80 # 10000050 <_entry-0x6fffffb0>
    800061b4:	97ba                	add	a5,a5,a4
    800061b6:	0007a023          	sw	zero,0(a5)

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800061ba:	0049a783          	lw	a5,4(s3)
    800061be:	00c79d63          	bne	a5,a2,800061d8 <virtio_disk_rw+0x1fc>
    800061c2:	4485                	li	s1,1
    sleep(b, &disk[n].vdisk_lock);
    800061c4:	85d2                	mv	a1,s4
    800061c6:	854e                	mv	a0,s3
    800061c8:	ffffc097          	auipc	ra,0xffffc
    800061cc:	e96080e7          	jalr	-362(ra) # 8000205e <sleep>
  while(b->disk == 1) {
    800061d0:	0049a783          	lw	a5,4(s3)
    800061d4:	fe9788e3          	beq	a5,s1,800061c4 <virtio_disk_rw+0x1e8>
  }

  disk[n].info[idx[0]].b = 0;
    800061d8:	f8042483          	lw	s1,-128(s0)
    800061dc:	00191793          	slli	a5,s2,0x1
    800061e0:	97ca                	add	a5,a5,s2
    800061e2:	07a2                	slli	a5,a5,0x8
    800061e4:	97a6                	add	a5,a5,s1
    800061e6:	20078793          	addi	a5,a5,512
    800061ea:	0792                	slli	a5,a5,0x4
    800061ec:	0001d717          	auipc	a4,0x1d
    800061f0:	e1470713          	addi	a4,a4,-492 # 80023000 <disk>
    800061f4:	97ba                	add	a5,a5,a4
    800061f6:	0207b423          	sd	zero,40(a5)
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    800061fa:	00191793          	slli	a5,s2,0x1
    800061fe:	97ca                	add	a5,a5,s2
    80006200:	07b2                	slli	a5,a5,0xc
    80006202:	97ba                	add	a5,a5,a4
    80006204:	6989                	lui	s3,0x2
    80006206:	99be                	add	s3,s3,a5
    free_desc(n, i);
    80006208:	85a6                	mv	a1,s1
    8000620a:	854a                	mv	a0,s2
    8000620c:	00000097          	auipc	ra,0x0
    80006210:	b4c080e7          	jalr	-1204(ra) # 80005d58 <free_desc>
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    80006214:	0492                	slli	s1,s1,0x4
    80006216:	0009b783          	ld	a5,0(s3) # 2000 <_entry-0x7fffe000>
    8000621a:	94be                	add	s1,s1,a5
    8000621c:	00c4d783          	lhu	a5,12(s1)
    80006220:	8b85                	andi	a5,a5,1
    80006222:	c781                	beqz	a5,8000622a <virtio_disk_rw+0x24e>
      i = disk[n].desc[i].next;
    80006224:	00e4d483          	lhu	s1,14(s1)
    free_desc(n, i);
    80006228:	b7c5                	j	80006208 <virtio_disk_rw+0x22c>
  free_chain(n, idx[0]);

  release(&disk[n].vdisk_lock);
    8000622a:	8552                	mv	a0,s4
    8000622c:	ffffb097          	auipc	ra,0xffffb
    80006230:	926080e7          	jalr	-1754(ra) # 80000b52 <release>
}
    80006234:	60ea                	ld	ra,152(sp)
    80006236:	644a                	ld	s0,144(sp)
    80006238:	64aa                	ld	s1,136(sp)
    8000623a:	690a                	ld	s2,128(sp)
    8000623c:	79e6                	ld	s3,120(sp)
    8000623e:	7a46                	ld	s4,112(sp)
    80006240:	7aa6                	ld	s5,104(sp)
    80006242:	7b06                	ld	s6,96(sp)
    80006244:	6be6                	ld	s7,88(sp)
    80006246:	6c46                	ld	s8,80(sp)
    80006248:	6ca6                	ld	s9,72(sp)
    8000624a:	6d06                	ld	s10,64(sp)
    8000624c:	7de2                	ld	s11,56(sp)
    8000624e:	610d                	addi	sp,sp,160
    80006250:	8082                	ret
  if(write)
    80006252:	01b037b3          	snez	a5,s11
    80006256:	f6f42823          	sw	a5,-144(s0)
  buf0.reserved = 0;
    8000625a:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    8000625e:	f6843783          	ld	a5,-152(s0)
    80006262:	f6f43c23          	sd	a5,-136(s0)
  disk[n].desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80006266:	f8042483          	lw	s1,-128(s0)
    8000626a:	00449b13          	slli	s6,s1,0x4
    8000626e:	00191793          	slli	a5,s2,0x1
    80006272:	97ca                	add	a5,a5,s2
    80006274:	07b2                	slli	a5,a5,0xc
    80006276:	0001da97          	auipc	s5,0x1d
    8000627a:	d8aa8a93          	addi	s5,s5,-630 # 80023000 <disk>
    8000627e:	97d6                	add	a5,a5,s5
    80006280:	6a89                	lui	s5,0x2
    80006282:	9abe                	add	s5,s5,a5
    80006284:	000abb83          	ld	s7,0(s5) # 2000 <_entry-0x7fffe000>
    80006288:	9bda                	add	s7,s7,s6
    8000628a:	f7040513          	addi	a0,s0,-144
    8000628e:	ffffb097          	auipc	ra,0xffffb
    80006292:	d54080e7          	jalr	-684(ra) # 80000fe2 <kvmpa>
    80006296:	00abb023          	sd	a0,0(s7)
  disk[n].desc[idx[0]].len = sizeof(buf0);
    8000629a:	000ab783          	ld	a5,0(s5)
    8000629e:	97da                	add	a5,a5,s6
    800062a0:	4741                	li	a4,16
    800062a2:	c798                	sw	a4,8(a5)
  disk[n].desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800062a4:	000ab783          	ld	a5,0(s5)
    800062a8:	97da                	add	a5,a5,s6
    800062aa:	4705                	li	a4,1
    800062ac:	00e79623          	sh	a4,12(a5)
  disk[n].desc[idx[0]].next = idx[1];
    800062b0:	f8442683          	lw	a3,-124(s0)
    800062b4:	000ab783          	ld	a5,0(s5)
    800062b8:	9b3e                	add	s6,s6,a5
    800062ba:	00db1723          	sh	a3,14(s6)
  disk[n].desc[idx[1]].addr = (uint64) b->data;
    800062be:	0692                	slli	a3,a3,0x4
    800062c0:	000ab783          	ld	a5,0(s5)
    800062c4:	97b6                	add	a5,a5,a3
    800062c6:	06098713          	addi	a4,s3,96
    800062ca:	e398                	sd	a4,0(a5)
  disk[n].desc[idx[1]].len = BSIZE;
    800062cc:	000ab783          	ld	a5,0(s5)
    800062d0:	97b6                	add	a5,a5,a3
    800062d2:	40000713          	li	a4,1024
    800062d6:	c798                	sw	a4,8(a5)
  if(write)
    800062d8:	e00d92e3          	bnez	s11,800060dc <virtio_disk_rw+0x100>
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800062dc:	00191793          	slli	a5,s2,0x1
    800062e0:	97ca                	add	a5,a5,s2
    800062e2:	07b2                	slli	a5,a5,0xc
    800062e4:	0001d717          	auipc	a4,0x1d
    800062e8:	d1c70713          	addi	a4,a4,-740 # 80023000 <disk>
    800062ec:	973e                	add	a4,a4,a5
    800062ee:	6789                	lui	a5,0x2
    800062f0:	97ba                	add	a5,a5,a4
    800062f2:	639c                	ld	a5,0(a5)
    800062f4:	97b6                	add	a5,a5,a3
    800062f6:	4709                	li	a4,2
    800062f8:	00e79623          	sh	a4,12(a5) # 200c <_entry-0x7fffdff4>
    800062fc:	bbfd                	j	800060fa <virtio_disk_rw+0x11e>

00000000800062fe <virtio_disk_intr>:

void
virtio_disk_intr(int n)
{
    800062fe:	7139                	addi	sp,sp,-64
    80006300:	fc06                	sd	ra,56(sp)
    80006302:	f822                	sd	s0,48(sp)
    80006304:	f426                	sd	s1,40(sp)
    80006306:	f04a                	sd	s2,32(sp)
    80006308:	ec4e                	sd	s3,24(sp)
    8000630a:	e852                	sd	s4,16(sp)
    8000630c:	e456                	sd	s5,8(sp)
    8000630e:	0080                	addi	s0,sp,64
    80006310:	84aa                	mv	s1,a0
  acquire(&disk[n].vdisk_lock);
    80006312:	00151913          	slli	s2,a0,0x1
    80006316:	00a90a33          	add	s4,s2,a0
    8000631a:	0a32                	slli	s4,s4,0xc
    8000631c:	6989                	lui	s3,0x2
    8000631e:	0b098793          	addi	a5,s3,176 # 20b0 <_entry-0x7fffdf50>
    80006322:	9a3e                	add	s4,s4,a5
    80006324:	0001da97          	auipc	s5,0x1d
    80006328:	cdca8a93          	addi	s5,s5,-804 # 80023000 <disk>
    8000632c:	9a56                	add	s4,s4,s5
    8000632e:	8552                	mv	a0,s4
    80006330:	ffffa097          	auipc	ra,0xffffa
    80006334:	7ba080e7          	jalr	1978(ra) # 80000aea <acquire>

  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    80006338:	9926                	add	s2,s2,s1
    8000633a:	0932                	slli	s2,s2,0xc
    8000633c:	9956                	add	s2,s2,s5
    8000633e:	99ca                	add	s3,s3,s2
    80006340:	0209d783          	lhu	a5,32(s3)
    80006344:	0109b703          	ld	a4,16(s3)
    80006348:	00275683          	lhu	a3,2(a4)
    8000634c:	8ebd                	xor	a3,a3,a5
    8000634e:	8a9d                	andi	a3,a3,7
    80006350:	c2a5                	beqz	a3,800063b0 <virtio_disk_intr+0xb2>
    int id = disk[n].used->elems[disk[n].used_idx].id;

    if(disk[n].info[id].status != 0)
    80006352:	8956                	mv	s2,s5
    80006354:	00149693          	slli	a3,s1,0x1
    80006358:	96a6                	add	a3,a3,s1
    8000635a:	00869993          	slli	s3,a3,0x8
      panic("virtio_disk_intr status");
    
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk[n].info[id].b);

    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    8000635e:	06b2                	slli	a3,a3,0xc
    80006360:	96d6                	add	a3,a3,s5
    80006362:	6489                	lui	s1,0x2
    80006364:	94b6                	add	s1,s1,a3
    int id = disk[n].used->elems[disk[n].used_idx].id;
    80006366:	078e                	slli	a5,a5,0x3
    80006368:	97ba                	add	a5,a5,a4
    8000636a:	43dc                	lw	a5,4(a5)
    if(disk[n].info[id].status != 0)
    8000636c:	00f98733          	add	a4,s3,a5
    80006370:	20070713          	addi	a4,a4,512
    80006374:	0712                	slli	a4,a4,0x4
    80006376:	974a                	add	a4,a4,s2
    80006378:	03074703          	lbu	a4,48(a4)
    8000637c:	eb21                	bnez	a4,800063cc <virtio_disk_intr+0xce>
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    8000637e:	97ce                	add	a5,a5,s3
    80006380:	20078793          	addi	a5,a5,512
    80006384:	0792                	slli	a5,a5,0x4
    80006386:	97ca                	add	a5,a5,s2
    80006388:	7798                	ld	a4,40(a5)
    8000638a:	00072223          	sw	zero,4(a4)
    wakeup(disk[n].info[id].b);
    8000638e:	7788                	ld	a0,40(a5)
    80006390:	ffffc097          	auipc	ra,0xffffc
    80006394:	e54080e7          	jalr	-428(ra) # 800021e4 <wakeup>
    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    80006398:	0204d783          	lhu	a5,32(s1) # 2020 <_entry-0x7fffdfe0>
    8000639c:	2785                	addiw	a5,a5,1
    8000639e:	8b9d                	andi	a5,a5,7
    800063a0:	02f49023          	sh	a5,32(s1)
  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    800063a4:	6898                	ld	a4,16(s1)
    800063a6:	00275683          	lhu	a3,2(a4)
    800063aa:	8a9d                	andi	a3,a3,7
    800063ac:	faf69de3          	bne	a3,a5,80006366 <virtio_disk_intr+0x68>
  }

  release(&disk[n].vdisk_lock);
    800063b0:	8552                	mv	a0,s4
    800063b2:	ffffa097          	auipc	ra,0xffffa
    800063b6:	7a0080e7          	jalr	1952(ra) # 80000b52 <release>
}
    800063ba:	70e2                	ld	ra,56(sp)
    800063bc:	7442                	ld	s0,48(sp)
    800063be:	74a2                	ld	s1,40(sp)
    800063c0:	7902                	ld	s2,32(sp)
    800063c2:	69e2                	ld	s3,24(sp)
    800063c4:	6a42                	ld	s4,16(sp)
    800063c6:	6aa2                	ld	s5,8(sp)
    800063c8:	6121                	addi	sp,sp,64
    800063ca:	8082                	ret
      panic("virtio_disk_intr status");
    800063cc:	00001517          	auipc	a0,0x1
    800063d0:	4cc50513          	addi	a0,a0,1228 # 80007898 <userret+0x808>
    800063d4:	ffffa097          	auipc	ra,0xffffa
    800063d8:	17a080e7          	jalr	378(ra) # 8000054e <panic>

00000000800063dc <bit_isset>:
static Sz_info *bd_sizes;
static void *bd_base;   // start address of memory managed by the buddy allocator
static struct spinlock lock;

// Return 1 if bit at position index in array is set to 1
int bit_isset(char *array, int index) {
    800063dc:	1141                	addi	sp,sp,-16
    800063de:	e422                	sd	s0,8(sp)
    800063e0:	0800                	addi	s0,sp,16
  char b = array[index/8];
  char m = (1 << (index % 8));
    800063e2:	41f5d79b          	sraiw	a5,a1,0x1f
    800063e6:	01d7d79b          	srliw	a5,a5,0x1d
    800063ea:	9dbd                	addw	a1,a1,a5
    800063ec:	0075f713          	andi	a4,a1,7
    800063f0:	9f1d                	subw	a4,a4,a5
    800063f2:	4785                	li	a5,1
    800063f4:	00e797bb          	sllw	a5,a5,a4
    800063f8:	0ff7f793          	andi	a5,a5,255
  char b = array[index/8];
    800063fc:	4035d59b          	sraiw	a1,a1,0x3
    80006400:	95aa                	add	a1,a1,a0
  return (b & m) == m;
    80006402:	0005c503          	lbu	a0,0(a1)
    80006406:	8d7d                	and	a0,a0,a5
    80006408:	8d1d                	sub	a0,a0,a5
}
    8000640a:	00153513          	seqz	a0,a0
    8000640e:	6422                	ld	s0,8(sp)
    80006410:	0141                	addi	sp,sp,16
    80006412:	8082                	ret

0000000080006414 <bit_set>:

// Set bit at position index in array to 1
void bit_set(char *array, int index) {
    80006414:	1141                	addi	sp,sp,-16
    80006416:	e422                	sd	s0,8(sp)
    80006418:	0800                	addi	s0,sp,16
  char b = array[index/8];
    8000641a:	41f5d79b          	sraiw	a5,a1,0x1f
    8000641e:	01d7d79b          	srliw	a5,a5,0x1d
    80006422:	9dbd                	addw	a1,a1,a5
    80006424:	4035d71b          	sraiw	a4,a1,0x3
    80006428:	953a                	add	a0,a0,a4
  char m = (1 << (index % 8));
    8000642a:	899d                	andi	a1,a1,7
    8000642c:	9d9d                	subw	a1,a1,a5
  array[index/8] = (b | m);
    8000642e:	4785                	li	a5,1
    80006430:	00b795bb          	sllw	a1,a5,a1
    80006434:	00054783          	lbu	a5,0(a0)
    80006438:	8ddd                	or	a1,a1,a5
    8000643a:	00b50023          	sb	a1,0(a0)
}
    8000643e:	6422                	ld	s0,8(sp)
    80006440:	0141                	addi	sp,sp,16
    80006442:	8082                	ret

0000000080006444 <bit_clear>:

// Clear bit at position index in array
void bit_clear(char *array, int index) {
    80006444:	1141                	addi	sp,sp,-16
    80006446:	e422                	sd	s0,8(sp)
    80006448:	0800                	addi	s0,sp,16
  char b = array[index/8];
    8000644a:	41f5d79b          	sraiw	a5,a1,0x1f
    8000644e:	01d7d79b          	srliw	a5,a5,0x1d
    80006452:	9dbd                	addw	a1,a1,a5
    80006454:	4035d71b          	sraiw	a4,a1,0x3
    80006458:	953a                	add	a0,a0,a4
  char m = (1 << (index % 8));
    8000645a:	899d                	andi	a1,a1,7
    8000645c:	9d9d                	subw	a1,a1,a5
  array[index/8] = (b & ~m);
    8000645e:	4785                	li	a5,1
    80006460:	00b795bb          	sllw	a1,a5,a1
    80006464:	fff5c593          	not	a1,a1
    80006468:	00054783          	lbu	a5,0(a0)
    8000646c:	8dfd                	and	a1,a1,a5
    8000646e:	00b50023          	sb	a1,0(a0)
}
    80006472:	6422                	ld	s0,8(sp)
    80006474:	0141                	addi	sp,sp,16
    80006476:	8082                	ret

0000000080006478 <bd_print>:

void
bd_print() {
    80006478:	7159                	addi	sp,sp,-112
    8000647a:	f486                	sd	ra,104(sp)
    8000647c:	f0a2                	sd	s0,96(sp)
    8000647e:	eca6                	sd	s1,88(sp)
    80006480:	e8ca                	sd	s2,80(sp)
    80006482:	e4ce                	sd	s3,72(sp)
    80006484:	e0d2                	sd	s4,64(sp)
    80006486:	fc56                	sd	s5,56(sp)
    80006488:	f85a                	sd	s6,48(sp)
    8000648a:	f45e                	sd	s7,40(sp)
    8000648c:	f062                	sd	s8,32(sp)
    8000648e:	ec66                	sd	s9,24(sp)
    80006490:	e86a                	sd	s10,16(sp)
    80006492:	e46e                	sd	s11,8(sp)
    80006494:	1880                	addi	s0,sp,112
    80006496:	4b01                	li	s6,0
  for (int k = 0; k < nsizes; k++) {
    80006498:	4a81                	li	s5,0
    printf("size %d (%d):", k, BLK_SIZE(k));
    8000649a:	4dc1                	li	s11,16
    8000649c:	00001d17          	auipc	s10,0x1
    800064a0:	414d0d13          	addi	s10,s10,1044 # 800078b0 <userret+0x820>
    lst_print(&bd_sizes[k].free);
    printf("  alloc:");
    for (int b = 0; b < NBLK(k); b++) {
    800064a4:	4c91                	li	s9,4
    800064a6:	4c05                	li	s8,1
     printf(" %d", bit_isset(bd_sizes[k].alloc, b));
    }
    printf("\n");
    800064a8:	00001b97          	auipc	s7,0x1
    800064ac:	d08b8b93          	addi	s7,s7,-760 # 800071b0 <userret+0x120>
     printf(" %d", bit_isset(bd_sizes[k].alloc, b));
    800064b0:	00001a17          	auipc	s4,0x1
    800064b4:	420a0a13          	addi	s4,s4,1056 # 800078d0 <userret+0x840>
    800064b8:	a0a9                	j	80006502 <bd_print+0x8a>
    if(k > 0) {
      printf("  split:");
    800064ba:	00001517          	auipc	a0,0x1
    800064be:	41e50513          	addi	a0,a0,1054 # 800078d8 <userret+0x848>
    800064c2:	ffffa097          	auipc	ra,0xffffa
    800064c6:	0d6080e7          	jalr	214(ra) # 80000598 <printf>
    800064ca:	4481                	li	s1,0
      for (int b = 0; b < NBLK(k); b++) {
        printf(" %d", bit_isset(bd_sizes[k].split, b));
    800064cc:	85a6                	mv	a1,s1
    800064ce:	0189b503          	ld	a0,24(s3)
    800064d2:	00000097          	auipc	ra,0x0
    800064d6:	f0a080e7          	jalr	-246(ra) # 800063dc <bit_isset>
    800064da:	85aa                	mv	a1,a0
    800064dc:	8552                	mv	a0,s4
    800064de:	ffffa097          	auipc	ra,0xffffa
    800064e2:	0ba080e7          	jalr	186(ra) # 80000598 <printf>
      for (int b = 0; b < NBLK(k); b++) {
    800064e6:	2485                	addiw	s1,s1,1
    800064e8:	fe9912e3          	bne	s2,s1,800064cc <bd_print+0x54>
      }
      printf("\n");
    800064ec:	855e                	mv	a0,s7
    800064ee:	ffffa097          	auipc	ra,0xffffa
    800064f2:	0aa080e7          	jalr	170(ra) # 80000598 <printf>
  for (int k = 0; k < nsizes; k++) {
    800064f6:	2a85                	addiw	s5,s5,1
    800064f8:	020b0b13          	addi	s6,s6,32
    800064fc:	4795                	li	a5,5
    800064fe:	08fa8763          	beq	s5,a5,8000658c <bd_print+0x114>
    printf("size %d (%d):", k, BLK_SIZE(k));
    80006502:	015d9633          	sll	a2,s11,s5
    80006506:	85d6                	mv	a1,s5
    80006508:	856a                	mv	a0,s10
    8000650a:	ffffa097          	auipc	ra,0xffffa
    8000650e:	08e080e7          	jalr	142(ra) # 80000598 <printf>
    lst_print(&bd_sizes[k].free);
    80006512:	89da                	mv	s3,s6
    80006514:	855a                	mv	a0,s6
    80006516:	00000097          	auipc	ra,0x0
    8000651a:	448080e7          	jalr	1096(ra) # 8000695e <lst_print>
    printf("  alloc:");
    8000651e:	00001517          	auipc	a0,0x1
    80006522:	3a250513          	addi	a0,a0,930 # 800078c0 <userret+0x830>
    80006526:	ffffa097          	auipc	ra,0xffffa
    8000652a:	072080e7          	jalr	114(ra) # 80000598 <printf>
    for (int b = 0; b < NBLK(k); b++) {
    8000652e:	415c893b          	subw	s2,s9,s5
    80006532:	012c193b          	sllw	s2,s8,s2
    80006536:	03205b63          	blez	s2,8000656c <bd_print+0xf4>
    8000653a:	4481                	li	s1,0
     printf(" %d", bit_isset(bd_sizes[k].alloc, b));
    8000653c:	85a6                	mv	a1,s1
    8000653e:	0109b503          	ld	a0,16(s3)
    80006542:	00000097          	auipc	ra,0x0
    80006546:	e9a080e7          	jalr	-358(ra) # 800063dc <bit_isset>
    8000654a:	85aa                	mv	a1,a0
    8000654c:	8552                	mv	a0,s4
    8000654e:	ffffa097          	auipc	ra,0xffffa
    80006552:	04a080e7          	jalr	74(ra) # 80000598 <printf>
    for (int b = 0; b < NBLK(k); b++) {
    80006556:	2485                	addiw	s1,s1,1
    80006558:	fe9912e3          	bne	s2,s1,8000653c <bd_print+0xc4>
    printf("\n");
    8000655c:	855e                	mv	a0,s7
    8000655e:	ffffa097          	auipc	ra,0xffffa
    80006562:	03a080e7          	jalr	58(ra) # 80000598 <printf>
    if(k > 0) {
    80006566:	f95058e3          	blez	s5,800064f6 <bd_print+0x7e>
    8000656a:	bf81                	j	800064ba <bd_print+0x42>
    printf("\n");
    8000656c:	855e                	mv	a0,s7
    8000656e:	ffffa097          	auipc	ra,0xffffa
    80006572:	02a080e7          	jalr	42(ra) # 80000598 <printf>
    if(k > 0) {
    80006576:	f95050e3          	blez	s5,800064f6 <bd_print+0x7e>
      printf("  split:");
    8000657a:	00001517          	auipc	a0,0x1
    8000657e:	35e50513          	addi	a0,a0,862 # 800078d8 <userret+0x848>
    80006582:	ffffa097          	auipc	ra,0xffffa
    80006586:	016080e7          	jalr	22(ra) # 80000598 <printf>
      for (int b = 0; b < NBLK(k); b++) {
    8000658a:	b78d                	j	800064ec <bd_print+0x74>
    }
  }
}
    8000658c:	70a6                	ld	ra,104(sp)
    8000658e:	7406                	ld	s0,96(sp)
    80006590:	64e6                	ld	s1,88(sp)
    80006592:	6946                	ld	s2,80(sp)
    80006594:	69a6                	ld	s3,72(sp)
    80006596:	6a06                	ld	s4,64(sp)
    80006598:	7ae2                	ld	s5,56(sp)
    8000659a:	7b42                	ld	s6,48(sp)
    8000659c:	7ba2                	ld	s7,40(sp)
    8000659e:	7c02                	ld	s8,32(sp)
    800065a0:	6ce2                	ld	s9,24(sp)
    800065a2:	6d42                	ld	s10,16(sp)
    800065a4:	6da2                	ld	s11,8(sp)
    800065a6:	6165                	addi	sp,sp,112
    800065a8:	8082                	ret

00000000800065aa <firstk>:

// What is the first k such that 2^k >= n?
int
firstk(uint64 n) {
    800065aa:	1141                	addi	sp,sp,-16
    800065ac:	e422                	sd	s0,8(sp)
    800065ae:	0800                	addi	s0,sp,16
  int k = 0;
  uint64 size = LEAF_SIZE;

  while (size < n) {
    800065b0:	47c1                	li	a5,16
    800065b2:	00a7fb63          	bgeu	a5,a0,800065c8 <firstk+0x1e>
    800065b6:	872a                	mv	a4,a0
  int k = 0;
    800065b8:	4501                	li	a0,0
    k++;
    800065ba:	2505                	addiw	a0,a0,1
    size *= 2;
    800065bc:	0786                	slli	a5,a5,0x1
  while (size < n) {
    800065be:	fee7eee3          	bltu	a5,a4,800065ba <firstk+0x10>
  }
  return k;
}
    800065c2:	6422                	ld	s0,8(sp)
    800065c4:	0141                	addi	sp,sp,16
    800065c6:	8082                	ret
  int k = 0;
    800065c8:	4501                	li	a0,0
    800065ca:	bfe5                	j	800065c2 <firstk+0x18>

00000000800065cc <blk_index>:

// Compute the block index for address p at size k
int
blk_index(int k, char *p) {
    800065cc:	1141                	addi	sp,sp,-16
    800065ce:	e422                	sd	s0,8(sp)
    800065d0:	0800                	addi	s0,sp,16
  int n = p - (char *) bd_base;
  return n / BLK_SIZE(k);
    800065d2:	2581                	sext.w	a1,a1
    800065d4:	47c1                	li	a5,16
    800065d6:	00a79533          	sll	a0,a5,a0
    800065da:	02a5c533          	div	a0,a1,a0
}
    800065de:	2501                	sext.w	a0,a0
    800065e0:	6422                	ld	s0,8(sp)
    800065e2:	0141                	addi	sp,sp,16
    800065e4:	8082                	ret

00000000800065e6 <addr>:

// Convert a block index at size k back into an address
void *addr(int k, int bi) {
    800065e6:	1141                	addi	sp,sp,-16
    800065e8:	e422                	sd	s0,8(sp)
    800065ea:	0800                	addi	s0,sp,16
  int n = bi * BLK_SIZE(k);
    800065ec:	47c1                	li	a5,16
    800065ee:	00a79533          	sll	a0,a5,a0
  return (char *) bd_base + n;
}
    800065f2:	02b5053b          	mulw	a0,a0,a1
    800065f6:	6422                	ld	s0,8(sp)
    800065f8:	0141                	addi	sp,sp,16
    800065fa:	8082                	ret

00000000800065fc <bd_malloc>:

void *
bd_malloc(uint64 nbytes)
{
    800065fc:	715d                	addi	sp,sp,-80
    800065fe:	e486                	sd	ra,72(sp)
    80006600:	e0a2                	sd	s0,64(sp)
    80006602:	fc26                	sd	s1,56(sp)
    80006604:	f84a                	sd	s2,48(sp)
    80006606:	f44e                	sd	s3,40(sp)
    80006608:	f052                	sd	s4,32(sp)
    8000660a:	ec56                	sd	s5,24(sp)
    8000660c:	e85a                	sd	s6,16(sp)
    8000660e:	e45e                	sd	s7,8(sp)
    80006610:	e062                	sd	s8,0(sp)
    80006612:	0880                	addi	s0,sp,80
    80006614:	84aa                	mv	s1,a0
  int fk, k;

  acquire(&lock);
    80006616:	00023517          	auipc	a0,0x23
    8000661a:	9ea50513          	addi	a0,a0,-1558 # 80029000 <lock>
    8000661e:	ffffa097          	auipc	ra,0xffffa
    80006622:	4cc080e7          	jalr	1228(ra) # 80000aea <acquire>
  // Find a free block >= nbytes, starting with smallest k possible
  fk = firstk(nbytes);
    80006626:	8526                	mv	a0,s1
    80006628:	00000097          	auipc	ra,0x0
    8000662c:	f82080e7          	jalr	-126(ra) # 800065aa <firstk>
  for (k = fk; k < nsizes; k++) {
    80006630:	4791                	li	a5,4
    80006632:	02a7c263          	blt	a5,a0,80006656 <bd_malloc+0x5a>
    80006636:	8b2a                	mv	s6,a0
    80006638:	00551913          	slli	s2,a0,0x5
    8000663c:	84aa                	mv	s1,a0
    8000663e:	4995                	li	s3,5
    if(!lst_empty(&bd_sizes[k].free))
    80006640:	854a                	mv	a0,s2
    80006642:	00000097          	auipc	ra,0x0
    80006646:	2a2080e7          	jalr	674(ra) # 800068e4 <lst_empty>
    8000664a:	c105                	beqz	a0,8000666a <bd_malloc+0x6e>
  for (k = fk; k < nsizes; k++) {
    8000664c:	2485                	addiw	s1,s1,1
    8000664e:	02090913          	addi	s2,s2,32
    80006652:	ff3497e3          	bne	s1,s3,80006640 <bd_malloc+0x44>
      break;
  }
  if(k >= nsizes) { // No free blocks?
    release(&lock);
    80006656:	00023517          	auipc	a0,0x23
    8000665a:	9aa50513          	addi	a0,a0,-1622 # 80029000 <lock>
    8000665e:	ffffa097          	auipc	ra,0xffffa
    80006662:	4f4080e7          	jalr	1268(ra) # 80000b52 <release>
    return 0;
    80006666:	4c01                	li	s8,0
    80006668:	a849                	j	800066fa <bd_malloc+0xfe>
  if(k >= nsizes) { // No free blocks?
    8000666a:	4791                	li	a5,4
    8000666c:	fe97c5e3          	blt	a5,s1,80006656 <bd_malloc+0x5a>
  }

  // Found one; pop it and potentially split it.
  char *p = lst_pop(&bd_sizes[k].free);
    80006670:	00549913          	slli	s2,s1,0x5
    80006674:	854a                	mv	a0,s2
    80006676:	00000097          	auipc	ra,0x0
    8000667a:	29a080e7          	jalr	666(ra) # 80006910 <lst_pop>
    8000667e:	8c2a                	mv	s8,a0
  return n / BLK_SIZE(k);
    80006680:	00050a1b          	sext.w	s4,a0
    80006684:	45c1                	li	a1,16
    80006686:	009595b3          	sll	a1,a1,s1
    8000668a:	02ba45b3          	div	a1,s4,a1
  bit_set(bd_sizes[k].alloc, blk_index(k, p));
    8000668e:	2581                	sext.w	a1,a1
    80006690:	01093503          	ld	a0,16(s2)
    80006694:	00000097          	auipc	ra,0x0
    80006698:	d80080e7          	jalr	-640(ra) # 80006414 <bit_set>
  for(; k > fk; k--) {
    8000669c:	049b5763          	bge	s6,s1,800066ea <bd_malloc+0xee>
    800066a0:	1901                	addi	s2,s2,-32
    char *q = p + BLK_SIZE(k-1);
    800066a2:	4ac1                	li	s5,16
    800066a4:	85a6                	mv	a1,s1
    800066a6:	34fd                	addiw	s1,s1,-1
    800066a8:	009a99b3          	sll	s3,s5,s1
    800066ac:	013c0bb3          	add	s7,s8,s3
  return n / BLK_SIZE(k);
    800066b0:	00ba95b3          	sll	a1,s5,a1
    800066b4:	02ba45b3          	div	a1,s4,a1
    bit_set(bd_sizes[k].split, blk_index(k, p));
    800066b8:	2581                	sext.w	a1,a1
    800066ba:	03893503          	ld	a0,56(s2)
    800066be:	00000097          	auipc	ra,0x0
    800066c2:	d56080e7          	jalr	-682(ra) # 80006414 <bit_set>
  return n / BLK_SIZE(k);
    800066c6:	033a45b3          	div	a1,s4,s3
    bit_set(bd_sizes[k-1].alloc, blk_index(k-1, p));
    800066ca:	2581                	sext.w	a1,a1
    800066cc:	01093503          	ld	a0,16(s2)
    800066d0:	00000097          	auipc	ra,0x0
    800066d4:	d44080e7          	jalr	-700(ra) # 80006414 <bit_set>
    lst_push(&bd_sizes[k-1].free, q);
    800066d8:	85de                	mv	a1,s7
    800066da:	854a                	mv	a0,s2
    800066dc:	00000097          	auipc	ra,0x0
    800066e0:	26a080e7          	jalr	618(ra) # 80006946 <lst_push>
  for(; k > fk; k--) {
    800066e4:	1901                	addi	s2,s2,-32
    800066e6:	fb649fe3          	bne	s1,s6,800066a4 <bd_malloc+0xa8>
  }
  //printf("malloc: %p size class %d\n", p, fk);
  release(&lock);
    800066ea:	00023517          	auipc	a0,0x23
    800066ee:	91650513          	addi	a0,a0,-1770 # 80029000 <lock>
    800066f2:	ffffa097          	auipc	ra,0xffffa
    800066f6:	460080e7          	jalr	1120(ra) # 80000b52 <release>
  return p;
}
    800066fa:	8562                	mv	a0,s8
    800066fc:	60a6                	ld	ra,72(sp)
    800066fe:	6406                	ld	s0,64(sp)
    80006700:	74e2                	ld	s1,56(sp)
    80006702:	7942                	ld	s2,48(sp)
    80006704:	79a2                	ld	s3,40(sp)
    80006706:	7a02                	ld	s4,32(sp)
    80006708:	6ae2                	ld	s5,24(sp)
    8000670a:	6b42                	ld	s6,16(sp)
    8000670c:	6ba2                	ld	s7,8(sp)
    8000670e:	6c02                	ld	s8,0(sp)
    80006710:	6161                	addi	sp,sp,80
    80006712:	8082                	ret

0000000080006714 <size>:

// Find the size of the block that p points to.
int
size(char *p) {
    80006714:	7139                	addi	sp,sp,-64
    80006716:	fc06                	sd	ra,56(sp)
    80006718:	f822                	sd	s0,48(sp)
    8000671a:	f426                	sd	s1,40(sp)
    8000671c:	f04a                	sd	s2,32(sp)
    8000671e:	ec4e                	sd	s3,24(sp)
    80006720:	e852                	sd	s4,16(sp)
    80006722:	e456                	sd	s5,8(sp)
    80006724:	e05a                	sd	s6,0(sp)
    80006726:	0080                	addi	s0,sp,64
    80006728:	02000913          	li	s2,32
  for (int k = 0; k < nsizes; k++) {
    8000672c:	4481                	li	s1,0
  return n / BLK_SIZE(k);
    8000672e:	0005099b          	sext.w	s3,a0
    80006732:	4a41                	li	s4,16
  for (int k = 0; k < nsizes; k++) {
    80006734:	4a95                	li	s5,5
    if(bit_isset(bd_sizes[k+1].split, blk_index(k+1, p))) {
    80006736:	8b26                	mv	s6,s1
    80006738:	2485                	addiw	s1,s1,1
  return n / BLK_SIZE(k);
    8000673a:	009a15b3          	sll	a1,s4,s1
    8000673e:	02b9c5b3          	div	a1,s3,a1
    if(bit_isset(bd_sizes[k+1].split, blk_index(k+1, p))) {
    80006742:	2581                	sext.w	a1,a1
    80006744:	01893503          	ld	a0,24(s2)
    80006748:	00000097          	auipc	ra,0x0
    8000674c:	c94080e7          	jalr	-876(ra) # 800063dc <bit_isset>
    80006750:	ed19                	bnez	a0,8000676e <size+0x5a>
  for (int k = 0; k < nsizes; k++) {
    80006752:	02090913          	addi	s2,s2,32
    80006756:	ff5490e3          	bne	s1,s5,80006736 <size+0x22>
      return k;
    }
  }
  return 0;
}
    8000675a:	70e2                	ld	ra,56(sp)
    8000675c:	7442                	ld	s0,48(sp)
    8000675e:	74a2                	ld	s1,40(sp)
    80006760:	7902                	ld	s2,32(sp)
    80006762:	69e2                	ld	s3,24(sp)
    80006764:	6a42                	ld	s4,16(sp)
    80006766:	6aa2                	ld	s5,8(sp)
    80006768:	6b02                	ld	s6,0(sp)
    8000676a:	6121                	addi	sp,sp,64
    8000676c:	8082                	ret
    8000676e:	855a                	mv	a0,s6
    80006770:	b7ed                	j	8000675a <size+0x46>

0000000080006772 <bd_free>:

void
bd_free(void *p) {
    80006772:	715d                	addi	sp,sp,-80
    80006774:	e486                	sd	ra,72(sp)
    80006776:	e0a2                	sd	s0,64(sp)
    80006778:	fc26                	sd	s1,56(sp)
    8000677a:	f84a                	sd	s2,48(sp)
    8000677c:	f44e                	sd	s3,40(sp)
    8000677e:	f052                	sd	s4,32(sp)
    80006780:	ec56                	sd	s5,24(sp)
    80006782:	e85a                	sd	s6,16(sp)
    80006784:	e45e                	sd	s7,8(sp)
    80006786:	e062                	sd	s8,0(sp)
    80006788:	0880                	addi	s0,sp,80
    8000678a:	89aa                	mv	s3,a0
  void *q;
  int k;

  acquire(&lock);
    8000678c:	00023517          	auipc	a0,0x23
    80006790:	87450513          	addi	a0,a0,-1932 # 80029000 <lock>
    80006794:	ffffa097          	auipc	ra,0xffffa
    80006798:	356080e7          	jalr	854(ra) # 80000aea <acquire>
  for (k = size(p); k < MAXSIZE; k++) {
    8000679c:	854e                	mv	a0,s3
    8000679e:	00000097          	auipc	ra,0x0
    800067a2:	f76080e7          	jalr	-138(ra) # 80006714 <size>
    800067a6:	84aa                	mv	s1,a0
    800067a8:	478d                	li	a5,3
    800067aa:	08a7c563          	blt	a5,a0,80006834 <bd_free+0xc2>
    800067ae:	00551913          	slli	s2,a0,0x5
  return n / BLK_SIZE(k);
    800067b2:	4a41                	li	s4,16
  for (k = size(p); k < MAXSIZE; k++) {
    800067b4:	4a91                	li	s5,4
    800067b6:	a035                	j	800067e2 <bd_free+0x70>
    int bi = blk_index(k, p);
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    800067b8:	fff58b9b          	addiw	s7,a1,-1
    800067bc:	a83d                	j	800067fa <bd_free+0x88>
    q = addr(k, buddy);
    lst_remove(q);
    if(buddy % 2 == 0) {
      p = q;
    }
    bit_clear(bd_sizes[k+1].split, blk_index(k+1, p));
    800067be:	02090913          	addi	s2,s2,32
    800067c2:	2485                	addiw	s1,s1,1
  return n / BLK_SIZE(k);
    800067c4:	0009859b          	sext.w	a1,s3
    800067c8:	009a17b3          	sll	a5,s4,s1
    800067cc:	02f5c5b3          	div	a1,a1,a5
    bit_clear(bd_sizes[k+1].split, blk_index(k+1, p));
    800067d0:	2581                	sext.w	a1,a1
    800067d2:	01893503          	ld	a0,24(s2)
    800067d6:	00000097          	auipc	ra,0x0
    800067da:	c6e080e7          	jalr	-914(ra) # 80006444 <bit_clear>
  for (k = size(p); k < MAXSIZE; k++) {
    800067de:	05548b63          	beq	s1,s5,80006834 <bd_free+0xc2>
  return n / BLK_SIZE(k);
    800067e2:	009a1b33          	sll	s6,s4,s1
    800067e6:	0009879b          	sext.w	a5,s3
    800067ea:	0367c7b3          	div	a5,a5,s6
    800067ee:	0007859b          	sext.w	a1,a5
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    800067f2:	8b85                	andi	a5,a5,1
    800067f4:	f3f1                	bnez	a5,800067b8 <bd_free+0x46>
    800067f6:	00158b9b          	addiw	s7,a1,1
    bit_clear(bd_sizes[k].alloc, bi);
    800067fa:	01093503          	ld	a0,16(s2)
    800067fe:	00000097          	auipc	ra,0x0
    80006802:	c46080e7          	jalr	-954(ra) # 80006444 <bit_clear>
    if (bit_isset(bd_sizes[k].alloc, buddy)) {
    80006806:	85de                	mv	a1,s7
    80006808:	01093503          	ld	a0,16(s2)
    8000680c:	00000097          	auipc	ra,0x0
    80006810:	bd0080e7          	jalr	-1072(ra) # 800063dc <bit_isset>
    80006814:	e105                	bnez	a0,80006834 <bd_free+0xc2>
  int n = bi * BLK_SIZE(k);
    80006816:	000b8c1b          	sext.w	s8,s7
  return (char *) bd_base + n;
    8000681a:	037b0b3b          	mulw	s6,s6,s7
    lst_remove(q);
    8000681e:	855a                	mv	a0,s6
    80006820:	00000097          	auipc	ra,0x0
    80006824:	0da080e7          	jalr	218(ra) # 800068fa <lst_remove>
    if(buddy % 2 == 0) {
    80006828:	001c7c13          	andi	s8,s8,1
    8000682c:	f80c19e3          	bnez	s8,800067be <bd_free+0x4c>
      p = q;
    80006830:	89da                	mv	s3,s6
    80006832:	b771                	j	800067be <bd_free+0x4c>
  }
  //printf("free %p @ %d\n", p, k);
  lst_push(&bd_sizes[k].free, p);
    80006834:	85ce                	mv	a1,s3
    80006836:	00549513          	slli	a0,s1,0x5
    8000683a:	00000097          	auipc	ra,0x0
    8000683e:	10c080e7          	jalr	268(ra) # 80006946 <lst_push>
  release(&lock);
    80006842:	00022517          	auipc	a0,0x22
    80006846:	7be50513          	addi	a0,a0,1982 # 80029000 <lock>
    8000684a:	ffffa097          	auipc	ra,0xffffa
    8000684e:	308080e7          	jalr	776(ra) # 80000b52 <release>
}
    80006852:	60a6                	ld	ra,72(sp)
    80006854:	6406                	ld	s0,64(sp)
    80006856:	74e2                	ld	s1,56(sp)
    80006858:	7942                	ld	s2,48(sp)
    8000685a:	79a2                	ld	s3,40(sp)
    8000685c:	7a02                	ld	s4,32(sp)
    8000685e:	6ae2                	ld	s5,24(sp)
    80006860:	6b42                	ld	s6,16(sp)
    80006862:	6ba2                	ld	s7,8(sp)
    80006864:	6c02                	ld	s8,0(sp)
    80006866:	6161                	addi	sp,sp,80
    80006868:	8082                	ret

000000008000686a <blk_index_next>:

int
blk_index_next(int k, char *p) {
    8000686a:	1141                	addi	sp,sp,-16
    8000686c:	e422                	sd	s0,8(sp)
    8000686e:	0800                	addi	s0,sp,16
  int n = (p - (char *) bd_base) / BLK_SIZE(k);
    80006870:	47c1                	li	a5,16
    80006872:	00a797b3          	sll	a5,a5,a0
    80006876:	02f5c533          	div	a0,a1,a5
    8000687a:	2501                	sext.w	a0,a0
  if((p - (char*) bd_base) % BLK_SIZE(k) != 0)
    8000687c:	02f5e5b3          	rem	a1,a1,a5
    80006880:	c191                	beqz	a1,80006884 <blk_index_next+0x1a>
      n++;
    80006882:	2505                	addiw	a0,a0,1
  return n ;
}
    80006884:	6422                	ld	s0,8(sp)
    80006886:	0141                	addi	sp,sp,16
    80006888:	8082                	ret

000000008000688a <log2>:

int
log2(uint64 n) {
    8000688a:	1141                	addi	sp,sp,-16
    8000688c:	e422                	sd	s0,8(sp)
    8000688e:	0800                	addi	s0,sp,16
  int k = 0;
  while (n > 1) {
    80006890:	4705                	li	a4,1
    80006892:	00a77b63          	bgeu	a4,a0,800068a8 <log2+0x1e>
    80006896:	87aa                	mv	a5,a0
  int k = 0;
    80006898:	4501                	li	a0,0
    k++;
    8000689a:	2505                	addiw	a0,a0,1
    n = n >> 1;
    8000689c:	8385                	srli	a5,a5,0x1
  while (n > 1) {
    8000689e:	fef76ee3          	bltu	a4,a5,8000689a <log2+0x10>
  }
  return k;
}
    800068a2:	6422                	ld	s0,8(sp)
    800068a4:	0141                	addi	sp,sp,16
    800068a6:	8082                	ret
  int k = 0;
    800068a8:	4501                	li	a0,0
    800068aa:	bfe5                	j	800068a2 <log2+0x18>

00000000800068ac <bd_init>:

// The buddy allocator manages the memory from base till end.
void
bd_init(void *base, void *end) {
    800068ac:	1141                	addi	sp,sp,-16
    800068ae:	e406                	sd	ra,8(sp)
    800068b0:	e022                	sd	s0,0(sp)
    800068b2:	0800                	addi	s0,sp,16

  initlock(&lock, "buddy");
    800068b4:	00001597          	auipc	a1,0x1
    800068b8:	03458593          	addi	a1,a1,52 # 800078e8 <userret+0x858>
    800068bc:	00022517          	auipc	a0,0x22
    800068c0:	74450513          	addi	a0,a0,1860 # 80029000 <lock>
    800068c4:	ffffa097          	auipc	ra,0xffffa
    800068c8:	114080e7          	jalr	276(ra) # 800009d8 <initlock>

  // YOUR CODE HERE TO INITIALIZE THE BUDDY ALLOCATOR.  FEEL FREE TO
  // BORROW CODE FROM bd_init() in the lecture notes.

  return;
}
    800068cc:	60a2                	ld	ra,8(sp)
    800068ce:	6402                	ld	s0,0(sp)
    800068d0:	0141                	addi	sp,sp,16
    800068d2:	8082                	ret

00000000800068d4 <lst_init>:
// fast. circular simplifies code, because don't have to check for
// empty list in insert and remove.

void
lst_init(struct list *lst)
{
    800068d4:	1141                	addi	sp,sp,-16
    800068d6:	e422                	sd	s0,8(sp)
    800068d8:	0800                	addi	s0,sp,16
  lst->next = lst;
    800068da:	e108                	sd	a0,0(a0)
  lst->prev = lst;
    800068dc:	e508                	sd	a0,8(a0)
}
    800068de:	6422                	ld	s0,8(sp)
    800068e0:	0141                	addi	sp,sp,16
    800068e2:	8082                	ret

00000000800068e4 <lst_empty>:

int
lst_empty(struct list *lst) {
    800068e4:	1141                	addi	sp,sp,-16
    800068e6:	e422                	sd	s0,8(sp)
    800068e8:	0800                	addi	s0,sp,16
  return lst->next == lst;
    800068ea:	611c                	ld	a5,0(a0)
    800068ec:	40a78533          	sub	a0,a5,a0
}
    800068f0:	00153513          	seqz	a0,a0
    800068f4:	6422                	ld	s0,8(sp)
    800068f6:	0141                	addi	sp,sp,16
    800068f8:	8082                	ret

00000000800068fa <lst_remove>:

void
lst_remove(struct list *e) {
    800068fa:	1141                	addi	sp,sp,-16
    800068fc:	e422                	sd	s0,8(sp)
    800068fe:	0800                	addi	s0,sp,16
  e->prev->next = e->next;
    80006900:	6518                	ld	a4,8(a0)
    80006902:	611c                	ld	a5,0(a0)
    80006904:	e31c                	sd	a5,0(a4)
  e->next->prev = e->prev;
    80006906:	6518                	ld	a4,8(a0)
    80006908:	e798                	sd	a4,8(a5)
}
    8000690a:	6422                	ld	s0,8(sp)
    8000690c:	0141                	addi	sp,sp,16
    8000690e:	8082                	ret

0000000080006910 <lst_pop>:

void*
lst_pop(struct list *lst) {
    80006910:	1101                	addi	sp,sp,-32
    80006912:	ec06                	sd	ra,24(sp)
    80006914:	e822                	sd	s0,16(sp)
    80006916:	e426                	sd	s1,8(sp)
    80006918:	1000                	addi	s0,sp,32
  if(lst->next == lst)
    8000691a:	6104                	ld	s1,0(a0)
    8000691c:	00a48d63          	beq	s1,a0,80006936 <lst_pop+0x26>
    panic("lst_pop");
  struct list *p = lst->next;
  lst_remove(p);
    80006920:	8526                	mv	a0,s1
    80006922:	00000097          	auipc	ra,0x0
    80006926:	fd8080e7          	jalr	-40(ra) # 800068fa <lst_remove>
  return (void *)p;
}
    8000692a:	8526                	mv	a0,s1
    8000692c:	60e2                	ld	ra,24(sp)
    8000692e:	6442                	ld	s0,16(sp)
    80006930:	64a2                	ld	s1,8(sp)
    80006932:	6105                	addi	sp,sp,32
    80006934:	8082                	ret
    panic("lst_pop");
    80006936:	00001517          	auipc	a0,0x1
    8000693a:	fba50513          	addi	a0,a0,-70 # 800078f0 <userret+0x860>
    8000693e:	ffffa097          	auipc	ra,0xffffa
    80006942:	c10080e7          	jalr	-1008(ra) # 8000054e <panic>

0000000080006946 <lst_push>:

void
lst_push(struct list *lst, void *p)
{
    80006946:	1141                	addi	sp,sp,-16
    80006948:	e422                	sd	s0,8(sp)
    8000694a:	0800                	addi	s0,sp,16
  struct list *e = (struct list *) p;
  e->next = lst->next;
    8000694c:	611c                	ld	a5,0(a0)
    8000694e:	e19c                	sd	a5,0(a1)
  e->prev = lst;
    80006950:	e588                	sd	a0,8(a1)
  lst->next->prev = p;
    80006952:	611c                	ld	a5,0(a0)
    80006954:	e78c                	sd	a1,8(a5)
  lst->next = e;
    80006956:	e10c                	sd	a1,0(a0)
}
    80006958:	6422                	ld	s0,8(sp)
    8000695a:	0141                	addi	sp,sp,16
    8000695c:	8082                	ret

000000008000695e <lst_print>:

void
lst_print(struct list *lst)
{
    8000695e:	7179                	addi	sp,sp,-48
    80006960:	f406                	sd	ra,40(sp)
    80006962:	f022                	sd	s0,32(sp)
    80006964:	ec26                	sd	s1,24(sp)
    80006966:	e84a                	sd	s2,16(sp)
    80006968:	e44e                	sd	s3,8(sp)
    8000696a:	1800                	addi	s0,sp,48
  for (struct list *p = lst->next; p != lst; p = p->next) {
    8000696c:	6104                	ld	s1,0(a0)
    8000696e:	02950063          	beq	a0,s1,8000698e <lst_print+0x30>
    80006972:	892a                	mv	s2,a0
    printf(" %p", p);
    80006974:	00001997          	auipc	s3,0x1
    80006978:	f8498993          	addi	s3,s3,-124 # 800078f8 <userret+0x868>
    8000697c:	85a6                	mv	a1,s1
    8000697e:	854e                	mv	a0,s3
    80006980:	ffffa097          	auipc	ra,0xffffa
    80006984:	c18080e7          	jalr	-1000(ra) # 80000598 <printf>
  for (struct list *p = lst->next; p != lst; p = p->next) {
    80006988:	6084                	ld	s1,0(s1)
    8000698a:	fe9919e3          	bne	s2,s1,8000697c <lst_print+0x1e>
  }
  printf("\n");
    8000698e:	00001517          	auipc	a0,0x1
    80006992:	82250513          	addi	a0,a0,-2014 # 800071b0 <userret+0x120>
    80006996:	ffffa097          	auipc	ra,0xffffa
    8000699a:	c02080e7          	jalr	-1022(ra) # 80000598 <printf>
}
    8000699e:	70a2                	ld	ra,40(sp)
    800069a0:	7402                	ld	s0,32(sp)
    800069a2:	64e2                	ld	s1,24(sp)
    800069a4:	6942                	ld	s2,16(sp)
    800069a6:	69a2                	ld	s3,8(sp)
    800069a8:	6145                	addi	sp,sp,48
    800069aa:	8082                	ret
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
