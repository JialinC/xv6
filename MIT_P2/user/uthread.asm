
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_schedule>:
  current_thread->state = RUNNING;
}

static void 
thread_schedule(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  thread_p t;

  /* Find another runnable thread. */
  next_thread = 0;
   8:	00001797          	auipc	a5,0x1
   c:	9e07b023          	sd	zero,-1568(a5) # 9e8 <next_thread>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == RUNNABLE && t != current_thread) {
  10:	00001817          	auipc	a6,0x1
  14:	9e083803          	ld	a6,-1568(a6) # 9f0 <current_thread>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  18:	00001797          	auipc	a5,0x1
  1c:	9e878793          	addi	a5,a5,-1560 # a00 <all_thread>
    if (t->state == RUNNABLE && t != current_thread) {
  20:	6709                	lui	a4,0x2
  22:	00870593          	addi	a1,a4,8 # 2008 <__global_pointer$+0xe27>
  26:	4609                	li	a2,2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  28:	0741                	addi	a4,a4,16
  2a:	00009517          	auipc	a0,0x9
  2e:	a1650513          	addi	a0,a0,-1514 # 8a40 <base>
  32:	a021                	j	3a <thread_schedule+0x3a>
  34:	97ba                	add	a5,a5,a4
  36:	08a78163          	beq	a5,a0,b8 <thread_schedule+0xb8>
    if (t->state == RUNNABLE && t != current_thread) {
  3a:	00b786b3          	add	a3,a5,a1
  3e:	4294                	lw	a3,0(a3)
  40:	fec69ae3          	bne	a3,a2,34 <thread_schedule+0x34>
  44:	fef808e3          	beq	a6,a5,34 <thread_schedule+0x34>
       next_thread = t;
  48:	00001717          	auipc	a4,0x1
  4c:	9af73023          	sd	a5,-1632(a4) # 9e8 <next_thread>
      break;
    }
  }

  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
  50:	00009717          	auipc	a4,0x9
  54:	9f070713          	addi	a4,a4,-1552 # 8a40 <base>
  58:	00e7ef63          	bltu	a5,a4,76 <thread_schedule+0x76>
  5c:	6789                	lui	a5,0x2
  5e:	97c2                	add	a5,a5,a6
  60:	4798                	lw	a4,8(a5)
  62:	4789                	li	a5,2
  64:	06f70163          	beq	a4,a5,c6 <thread_schedule+0xc6>
    /* The current thread is the only runnable thread; run it. */
    next_thread = current_thread;
  }

  if (next_thread == 0) {
  68:	00001797          	auipc	a5,0x1
  6c:	9807b783          	ld	a5,-1664(a5) # 9e8 <next_thread>
  70:	c79d                	beqz	a5,9e <thread_schedule+0x9e>
    printf("thread_schedule: no runnable threads\n");
    exit(-1);
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  72:	04f80a63          	beq	a6,a5,c6 <thread_schedule+0xc6>
    next_thread->state = RUNNING;
  76:	6709                	lui	a4,0x2
  78:	97ba                	add	a5,a5,a4
  7a:	4705                	li	a4,1
  7c:	c798                	sw	a4,8(a5)
     uthread_switch((uint64) &current_thread, (uint64) &next_thread);
  7e:	00001597          	auipc	a1,0x1
  82:	96a58593          	addi	a1,a1,-1686 # 9e8 <next_thread>
  86:	00001517          	auipc	a0,0x1
  8a:	96a50513          	addi	a0,a0,-1686 # 9f0 <current_thread>
  8e:	00000097          	auipc	ra,0x0
  92:	19e080e7          	jalr	414(ra) # 22c <strcpy>
  } else
    next_thread = 0;
}
  96:	60a2                	ld	ra,8(sp)
  98:	6402                	ld	s0,0(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret
    printf("thread_schedule: no runnable threads\n");
  9e:	00001517          	auipc	a0,0x1
  a2:	8c250513          	addi	a0,a0,-1854 # 960 <malloc+0xe8>
  a6:	00000097          	auipc	ra,0x0
  aa:	714080e7          	jalr	1812(ra) # 7ba <printf>
    exit(-1);
  ae:	557d                	li	a0,-1
  b0:	00000097          	auipc	ra,0x0
  b4:	372080e7          	jalr	882(ra) # 422 <exit>
  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
  b8:	6789                	lui	a5,0x2
  ba:	983e                	add	a6,a6,a5
  bc:	00882703          	lw	a4,8(a6)
  c0:	4789                	li	a5,2
  c2:	fcf71ee3          	bne	a4,a5,9e <thread_schedule+0x9e>
    next_thread = 0;
  c6:	00001797          	auipc	a5,0x1
  ca:	9207b123          	sd	zero,-1758(a5) # 9e8 <next_thread>
}
  ce:	b7e1                	j	96 <thread_schedule+0x96>

00000000000000d0 <thread_init>:
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e422                	sd	s0,8(sp)
  d4:	0800                	addi	s0,sp,16
  current_thread = &all_thread[0];
  d6:	00001797          	auipc	a5,0x1
  da:	92a78793          	addi	a5,a5,-1750 # a00 <all_thread>
  de:	00001717          	auipc	a4,0x1
  e2:	90f73923          	sd	a5,-1774(a4) # 9f0 <current_thread>
  current_thread->state = RUNNING;
  e6:	4785                	li	a5,1
  e8:	00003717          	auipc	a4,0x3
  ec:	92f72023          	sw	a5,-1760(a4) # 2a08 <__global_pointer$+0x1827>
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <thread_create>:

void 
thread_create(void (*func)())
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  fc:	00001797          	auipc	a5,0x1
 100:	90478793          	addi	a5,a5,-1788 # a00 <all_thread>
    if (t->state == FREE) break;
 104:	6709                	lui	a4,0x2
 106:	00870613          	addi	a2,a4,8 # 2008 <__global_pointer$+0xe27>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 10a:	0741                	addi	a4,a4,16
 10c:	00009597          	auipc	a1,0x9
 110:	93458593          	addi	a1,a1,-1740 # 8a40 <base>
    if (t->state == FREE) break;
 114:	00c786b3          	add	a3,a5,a2
 118:	4294                	lw	a3,0(a3)
 11a:	c681                	beqz	a3,122 <thread_create+0x2c>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 11c:	97ba                	add	a5,a5,a4
 11e:	feb79be3          	bne	a5,a1,114 <thread_create+0x1e>
  }
  t->sp = (uint64) (t->stack + STACK_SIZE);// set sp to the top of the stack
 122:	6689                	lui	a3,0x2
 124:	00868713          	addi	a4,a3,8 # 2008 <__global_pointer$+0xe27>
 128:	973e                	add	a4,a4,a5
  t->sp -= 104;                            // space for registers that uthread_switch expects
 12a:	f9870613          	addi	a2,a4,-104
 12e:	e390                	sd	a2,0(a5)
  * (uint64 *) (t->sp) = (uint64)func;     // push return address on stack
 130:	f8a73c23          	sd	a0,-104(a4)
  t->state = RUNNABLE;
 134:	97b6                	add	a5,a5,a3
 136:	4709                	li	a4,2
 138:	c798                	sw	a4,8(a5)
}
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <thread_yield>:

void 
thread_yield(void)
{
 140:	1141                	addi	sp,sp,-16
 142:	e406                	sd	ra,8(sp)
 144:	e022                	sd	s0,0(sp)
 146:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
 148:	00001797          	auipc	a5,0x1
 14c:	8a87b783          	ld	a5,-1880(a5) # 9f0 <current_thread>
 150:	6709                	lui	a4,0x2
 152:	97ba                	add	a5,a5,a4
 154:	4709                	li	a4,2
 156:	c798                	sw	a4,8(a5)
  thread_schedule();
 158:	00000097          	auipc	ra,0x0
 15c:	ea8080e7          	jalr	-344(ra) # 0 <thread_schedule>
}
 160:	60a2                	ld	ra,8(sp)
 162:	6402                	ld	s0,0(sp)
 164:	0141                	addi	sp,sp,16
 166:	8082                	ret

0000000000000168 <mythread>:

static void 
mythread(void)
{
 168:	7179                	addi	sp,sp,-48
 16a:	f406                	sd	ra,40(sp)
 16c:	f022                	sd	s0,32(sp)
 16e:	ec26                	sd	s1,24(sp)
 170:	e84a                	sd	s2,16(sp)
 172:	e44e                	sd	s3,8(sp)
 174:	1800                	addi	s0,sp,48
  int i;
  printf("my thread running\n");
 176:	00001517          	auipc	a0,0x1
 17a:	81250513          	addi	a0,a0,-2030 # 988 <malloc+0x110>
 17e:	00000097          	auipc	ra,0x0
 182:	63c080e7          	jalr	1596(ra) # 7ba <printf>
 186:	06400493          	li	s1,100
  for (i = 0; i < 100; i++) {
    printf("my thread %p\n", (uint64) current_thread);
 18a:	00001997          	auipc	s3,0x1
 18e:	86698993          	addi	s3,s3,-1946 # 9f0 <current_thread>
 192:	00001917          	auipc	s2,0x1
 196:	80e90913          	addi	s2,s2,-2034 # 9a0 <malloc+0x128>
 19a:	0009b583          	ld	a1,0(s3)
 19e:	854a                	mv	a0,s2
 1a0:	00000097          	auipc	ra,0x0
 1a4:	61a080e7          	jalr	1562(ra) # 7ba <printf>
    thread_yield();
 1a8:	00000097          	auipc	ra,0x0
 1ac:	f98080e7          	jalr	-104(ra) # 140 <thread_yield>
  for (i = 0; i < 100; i++) {
 1b0:	34fd                	addiw	s1,s1,-1
 1b2:	f4e5                	bnez	s1,19a <mythread+0x32>
  }
  printf("my thread: exit\n");
 1b4:	00000517          	auipc	a0,0x0
 1b8:	7fc50513          	addi	a0,a0,2044 # 9b0 <malloc+0x138>
 1bc:	00000097          	auipc	ra,0x0
 1c0:	5fe080e7          	jalr	1534(ra) # 7ba <printf>
  current_thread->state = FREE;
 1c4:	00001797          	auipc	a5,0x1
 1c8:	82c7b783          	ld	a5,-2004(a5) # 9f0 <current_thread>
 1cc:	6709                	lui	a4,0x2
 1ce:	97ba                	add	a5,a5,a4
 1d0:	0007a423          	sw	zero,8(a5)
  thread_schedule();
 1d4:	00000097          	auipc	ra,0x0
 1d8:	e2c080e7          	jalr	-468(ra) # 0 <thread_schedule>
}
 1dc:	70a2                	ld	ra,40(sp)
 1de:	7402                	ld	s0,32(sp)
 1e0:	64e2                	ld	s1,24(sp)
 1e2:	6942                	ld	s2,16(sp)
 1e4:	69a2                	ld	s3,8(sp)
 1e6:	6145                	addi	sp,sp,48
 1e8:	8082                	ret

00000000000001ea <main>:


int 
main(int argc, char *argv[]) 
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  thread_init();
 1f2:	00000097          	auipc	ra,0x0
 1f6:	ede080e7          	jalr	-290(ra) # d0 <thread_init>
  thread_create(mythread);
 1fa:	00000517          	auipc	a0,0x0
 1fe:	f6e50513          	addi	a0,a0,-146 # 168 <mythread>
 202:	00000097          	auipc	ra,0x0
 206:	ef4080e7          	jalr	-268(ra) # f6 <thread_create>
  thread_create(mythread);
 20a:	00000517          	auipc	a0,0x0
 20e:	f5e50513          	addi	a0,a0,-162 # 168 <mythread>
 212:	00000097          	auipc	ra,0x0
 216:	ee4080e7          	jalr	-284(ra) # f6 <thread_create>
  thread_schedule();
 21a:	00000097          	auipc	ra,0x0
 21e:	de6080e7          	jalr	-538(ra) # 0 <thread_schedule>
  exit(0);
 222:	4501                	li	a0,0
 224:	00000097          	auipc	ra,0x0
 228:	1fe080e7          	jalr	510(ra) # 422 <exit>

000000000000022c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e422                	sd	s0,8(sp)
 230:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 232:	87aa                	mv	a5,a0
 234:	0585                	addi	a1,a1,1
 236:	0785                	addi	a5,a5,1
 238:	fff5c703          	lbu	a4,-1(a1)
 23c:	fee78fa3          	sb	a4,-1(a5)
 240:	fb75                	bnez	a4,234 <strcpy+0x8>
    ;
  return os;
}
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret

0000000000000248 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e422                	sd	s0,8(sp)
 24c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 24e:	00054783          	lbu	a5,0(a0)
 252:	cb91                	beqz	a5,266 <strcmp+0x1e>
 254:	0005c703          	lbu	a4,0(a1)
 258:	00f71763          	bne	a4,a5,266 <strcmp+0x1e>
    p++, q++;
 25c:	0505                	addi	a0,a0,1
 25e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 260:	00054783          	lbu	a5,0(a0)
 264:	fbe5                	bnez	a5,254 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 266:	0005c503          	lbu	a0,0(a1)
}
 26a:	40a7853b          	subw	a0,a5,a0
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret

0000000000000274 <strlen>:

uint
strlen(const char *s)
{
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 27a:	00054783          	lbu	a5,0(a0)
 27e:	cf91                	beqz	a5,29a <strlen+0x26>
 280:	0505                	addi	a0,a0,1
 282:	87aa                	mv	a5,a0
 284:	4685                	li	a3,1
 286:	9e89                	subw	a3,a3,a0
 288:	00f6853b          	addw	a0,a3,a5
 28c:	0785                	addi	a5,a5,1
 28e:	fff7c703          	lbu	a4,-1(a5)
 292:	fb7d                	bnez	a4,288 <strlen+0x14>
    ;
  return n;
}
 294:	6422                	ld	s0,8(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret
  for(n = 0; s[n]; n++)
 29a:	4501                	li	a0,0
 29c:	bfe5                	j	294 <strlen+0x20>

000000000000029e <memset>:

void*
memset(void *dst, int c, uint n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2a4:	ce09                	beqz	a2,2be <memset+0x20>
 2a6:	87aa                	mv	a5,a0
 2a8:	fff6071b          	addiw	a4,a2,-1
 2ac:	1702                	slli	a4,a4,0x20
 2ae:	9301                	srli	a4,a4,0x20
 2b0:	0705                	addi	a4,a4,1
 2b2:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2b8:	0785                	addi	a5,a5,1
 2ba:	fee79de3          	bne	a5,a4,2b4 <memset+0x16>
  }
  return dst;
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret

00000000000002c4 <strchr>:

char*
strchr(const char *s, char c)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2ca:	00054783          	lbu	a5,0(a0)
 2ce:	cb99                	beqz	a5,2e4 <strchr+0x20>
    if(*s == c)
 2d0:	00f58763          	beq	a1,a5,2de <strchr+0x1a>
  for(; *s; s++)
 2d4:	0505                	addi	a0,a0,1
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	fbfd                	bnez	a5,2d0 <strchr+0xc>
      return (char*)s;
  return 0;
 2dc:	4501                	li	a0,0
}
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  return 0;
 2e4:	4501                	li	a0,0
 2e6:	bfe5                	j	2de <strchr+0x1a>

00000000000002e8 <gets>:

char*
gets(char *buf, int max)
{
 2e8:	711d                	addi	sp,sp,-96
 2ea:	ec86                	sd	ra,88(sp)
 2ec:	e8a2                	sd	s0,80(sp)
 2ee:	e4a6                	sd	s1,72(sp)
 2f0:	e0ca                	sd	s2,64(sp)
 2f2:	fc4e                	sd	s3,56(sp)
 2f4:	f852                	sd	s4,48(sp)
 2f6:	f456                	sd	s5,40(sp)
 2f8:	f05a                	sd	s6,32(sp)
 2fa:	ec5e                	sd	s7,24(sp)
 2fc:	1080                	addi	s0,sp,96
 2fe:	8baa                	mv	s7,a0
 300:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 302:	892a                	mv	s2,a0
 304:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 306:	4aa9                	li	s5,10
 308:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 30a:	89a6                	mv	s3,s1
 30c:	2485                	addiw	s1,s1,1
 30e:	0344d863          	bge	s1,s4,33e <gets+0x56>
    cc = read(0, &c, 1);
 312:	4605                	li	a2,1
 314:	faf40593          	addi	a1,s0,-81
 318:	4501                	li	a0,0
 31a:	00000097          	auipc	ra,0x0
 31e:	120080e7          	jalr	288(ra) # 43a <read>
    if(cc < 1)
 322:	00a05e63          	blez	a0,33e <gets+0x56>
    buf[i++] = c;
 326:	faf44783          	lbu	a5,-81(s0)
 32a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 32e:	01578763          	beq	a5,s5,33c <gets+0x54>
 332:	0905                	addi	s2,s2,1
 334:	fd679be3          	bne	a5,s6,30a <gets+0x22>
  for(i=0; i+1 < max; ){
 338:	89a6                	mv	s3,s1
 33a:	a011                	j	33e <gets+0x56>
 33c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 33e:	99de                	add	s3,s3,s7
 340:	00098023          	sb	zero,0(s3)
  return buf;
}
 344:	855e                	mv	a0,s7
 346:	60e6                	ld	ra,88(sp)
 348:	6446                	ld	s0,80(sp)
 34a:	64a6                	ld	s1,72(sp)
 34c:	6906                	ld	s2,64(sp)
 34e:	79e2                	ld	s3,56(sp)
 350:	7a42                	ld	s4,48(sp)
 352:	7aa2                	ld	s5,40(sp)
 354:	7b02                	ld	s6,32(sp)
 356:	6be2                	ld	s7,24(sp)
 358:	6125                	addi	sp,sp,96
 35a:	8082                	ret

000000000000035c <stat>:

int
stat(const char *n, struct stat *st)
{
 35c:	1101                	addi	sp,sp,-32
 35e:	ec06                	sd	ra,24(sp)
 360:	e822                	sd	s0,16(sp)
 362:	e426                	sd	s1,8(sp)
 364:	e04a                	sd	s2,0(sp)
 366:	1000                	addi	s0,sp,32
 368:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 36a:	4581                	li	a1,0
 36c:	00000097          	auipc	ra,0x0
 370:	0f6080e7          	jalr	246(ra) # 462 <open>
  if(fd < 0)
 374:	02054563          	bltz	a0,39e <stat+0x42>
 378:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 37a:	85ca                	mv	a1,s2
 37c:	00000097          	auipc	ra,0x0
 380:	0fe080e7          	jalr	254(ra) # 47a <fstat>
 384:	892a                	mv	s2,a0
  close(fd);
 386:	8526                	mv	a0,s1
 388:	00000097          	auipc	ra,0x0
 38c:	0c2080e7          	jalr	194(ra) # 44a <close>
  return r;
}
 390:	854a                	mv	a0,s2
 392:	60e2                	ld	ra,24(sp)
 394:	6442                	ld	s0,16(sp)
 396:	64a2                	ld	s1,8(sp)
 398:	6902                	ld	s2,0(sp)
 39a:	6105                	addi	sp,sp,32
 39c:	8082                	ret
    return -1;
 39e:	597d                	li	s2,-1
 3a0:	bfc5                	j	390 <stat+0x34>

00000000000003a2 <atoi>:

int
atoi(const char *s)
{
 3a2:	1141                	addi	sp,sp,-16
 3a4:	e422                	sd	s0,8(sp)
 3a6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3a8:	00054603          	lbu	a2,0(a0)
 3ac:	fd06079b          	addiw	a5,a2,-48
 3b0:	0ff7f793          	andi	a5,a5,255
 3b4:	4725                	li	a4,9
 3b6:	02f76963          	bltu	a4,a5,3e8 <atoi+0x46>
 3ba:	86aa                	mv	a3,a0
  n = 0;
 3bc:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3be:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3c0:	0685                	addi	a3,a3,1
 3c2:	0025179b          	slliw	a5,a0,0x2
 3c6:	9fa9                	addw	a5,a5,a0
 3c8:	0017979b          	slliw	a5,a5,0x1
 3cc:	9fb1                	addw	a5,a5,a2
 3ce:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3d2:	0006c603          	lbu	a2,0(a3)
 3d6:	fd06071b          	addiw	a4,a2,-48
 3da:	0ff77713          	andi	a4,a4,255
 3de:	fee5f1e3          	bgeu	a1,a4,3c0 <atoi+0x1e>
  return n;
}
 3e2:	6422                	ld	s0,8(sp)
 3e4:	0141                	addi	sp,sp,16
 3e6:	8082                	ret
  n = 0;
 3e8:	4501                	li	a0,0
 3ea:	bfe5                	j	3e2 <atoi+0x40>

00000000000003ec <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3ec:	1141                	addi	sp,sp,-16
 3ee:	e422                	sd	s0,8(sp)
 3f0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3f2:	02c05163          	blez	a2,414 <memmove+0x28>
 3f6:	fff6071b          	addiw	a4,a2,-1
 3fa:	1702                	slli	a4,a4,0x20
 3fc:	9301                	srli	a4,a4,0x20
 3fe:	0705                	addi	a4,a4,1
 400:	972a                	add	a4,a4,a0
  dst = vdst;
 402:	87aa                	mv	a5,a0
    *dst++ = *src++;
 404:	0585                	addi	a1,a1,1
 406:	0785                	addi	a5,a5,1
 408:	fff5c683          	lbu	a3,-1(a1)
 40c:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 410:	fee79ae3          	bne	a5,a4,404 <memmove+0x18>
  return vdst;
}
 414:	6422                	ld	s0,8(sp)
 416:	0141                	addi	sp,sp,16
 418:	8082                	ret

000000000000041a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 41a:	4885                	li	a7,1
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <exit>:
.global exit
exit:
 li a7, SYS_exit
 422:	4889                	li	a7,2
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <wait>:
.global wait
wait:
 li a7, SYS_wait
 42a:	488d                	li	a7,3
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 432:	4891                	li	a7,4
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <read>:
.global read
read:
 li a7, SYS_read
 43a:	4895                	li	a7,5
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <write>:
.global write
write:
 li a7, SYS_write
 442:	48c1                	li	a7,16
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <close>:
.global close
close:
 li a7, SYS_close
 44a:	48d5                	li	a7,21
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <kill>:
.global kill
kill:
 li a7, SYS_kill
 452:	4899                	li	a7,6
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <exec>:
.global exec
exec:
 li a7, SYS_exec
 45a:	489d                	li	a7,7
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <open>:
.global open
open:
 li a7, SYS_open
 462:	48bd                	li	a7,15
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 46a:	48c5                	li	a7,17
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 472:	48c9                	li	a7,18
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 47a:	48a1                	li	a7,8
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <link>:
.global link
link:
 li a7, SYS_link
 482:	48cd                	li	a7,19
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 48a:	48d1                	li	a7,20
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 492:	48a5                	li	a7,9
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <dup>:
.global dup
dup:
 li a7, SYS_dup
 49a:	48a9                	li	a7,10
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4a2:	48ad                	li	a7,11
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4aa:	48b1                	li	a7,12
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4b2:	48b5                	li	a7,13
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ba:	48b9                	li	a7,14
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 4c2:	48d9                	li	a7,22
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <crash>:
.global crash
crash:
 li a7, SYS_crash
 4ca:	48dd                	li	a7,23
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <mount>:
.global mount
mount:
 li a7, SYS_mount
 4d2:	48e1                	li	a7,24
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <umount>:
.global umount
umount:
 li a7, SYS_umount
 4da:	48e5                	li	a7,25
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4e2:	1101                	addi	sp,sp,-32
 4e4:	ec06                	sd	ra,24(sp)
 4e6:	e822                	sd	s0,16(sp)
 4e8:	1000                	addi	s0,sp,32
 4ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ee:	4605                	li	a2,1
 4f0:	fef40593          	addi	a1,s0,-17
 4f4:	00000097          	auipc	ra,0x0
 4f8:	f4e080e7          	jalr	-178(ra) # 442 <write>
}
 4fc:	60e2                	ld	ra,24(sp)
 4fe:	6442                	ld	s0,16(sp)
 500:	6105                	addi	sp,sp,32
 502:	8082                	ret

0000000000000504 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 504:	7139                	addi	sp,sp,-64
 506:	fc06                	sd	ra,56(sp)
 508:	f822                	sd	s0,48(sp)
 50a:	f426                	sd	s1,40(sp)
 50c:	f04a                	sd	s2,32(sp)
 50e:	ec4e                	sd	s3,24(sp)
 510:	0080                	addi	s0,sp,64
 512:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 514:	c299                	beqz	a3,51a <printint+0x16>
 516:	0805c863          	bltz	a1,5a6 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 51a:	2581                	sext.w	a1,a1
  neg = 0;
 51c:	4881                	li	a7,0
 51e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 522:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 524:	2601                	sext.w	a2,a2
 526:	00000517          	auipc	a0,0x0
 52a:	4aa50513          	addi	a0,a0,1194 # 9d0 <digits>
 52e:	883a                	mv	a6,a4
 530:	2705                	addiw	a4,a4,1
 532:	02c5f7bb          	remuw	a5,a1,a2
 536:	1782                	slli	a5,a5,0x20
 538:	9381                	srli	a5,a5,0x20
 53a:	97aa                	add	a5,a5,a0
 53c:	0007c783          	lbu	a5,0(a5)
 540:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 544:	0005879b          	sext.w	a5,a1
 548:	02c5d5bb          	divuw	a1,a1,a2
 54c:	0685                	addi	a3,a3,1
 54e:	fec7f0e3          	bgeu	a5,a2,52e <printint+0x2a>
  if(neg)
 552:	00088b63          	beqz	a7,568 <printint+0x64>
    buf[i++] = '-';
 556:	fd040793          	addi	a5,s0,-48
 55a:	973e                	add	a4,a4,a5
 55c:	02d00793          	li	a5,45
 560:	fef70823          	sb	a5,-16(a4) # 1ff0 <__global_pointer$+0xe0f>
 564:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 568:	02e05863          	blez	a4,598 <printint+0x94>
 56c:	fc040793          	addi	a5,s0,-64
 570:	00e78933          	add	s2,a5,a4
 574:	fff78993          	addi	s3,a5,-1
 578:	99ba                	add	s3,s3,a4
 57a:	377d                	addiw	a4,a4,-1
 57c:	1702                	slli	a4,a4,0x20
 57e:	9301                	srli	a4,a4,0x20
 580:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 584:	fff94583          	lbu	a1,-1(s2)
 588:	8526                	mv	a0,s1
 58a:	00000097          	auipc	ra,0x0
 58e:	f58080e7          	jalr	-168(ra) # 4e2 <putc>
  while(--i >= 0)
 592:	197d                	addi	s2,s2,-1
 594:	ff3918e3          	bne	s2,s3,584 <printint+0x80>
}
 598:	70e2                	ld	ra,56(sp)
 59a:	7442                	ld	s0,48(sp)
 59c:	74a2                	ld	s1,40(sp)
 59e:	7902                	ld	s2,32(sp)
 5a0:	69e2                	ld	s3,24(sp)
 5a2:	6121                	addi	sp,sp,64
 5a4:	8082                	ret
    x = -xx;
 5a6:	40b005bb          	negw	a1,a1
    neg = 1;
 5aa:	4885                	li	a7,1
    x = -xx;
 5ac:	bf8d                	j	51e <printint+0x1a>

00000000000005ae <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ae:	7119                	addi	sp,sp,-128
 5b0:	fc86                	sd	ra,120(sp)
 5b2:	f8a2                	sd	s0,112(sp)
 5b4:	f4a6                	sd	s1,104(sp)
 5b6:	f0ca                	sd	s2,96(sp)
 5b8:	ecce                	sd	s3,88(sp)
 5ba:	e8d2                	sd	s4,80(sp)
 5bc:	e4d6                	sd	s5,72(sp)
 5be:	e0da                	sd	s6,64(sp)
 5c0:	fc5e                	sd	s7,56(sp)
 5c2:	f862                	sd	s8,48(sp)
 5c4:	f466                	sd	s9,40(sp)
 5c6:	f06a                	sd	s10,32(sp)
 5c8:	ec6e                	sd	s11,24(sp)
 5ca:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5cc:	0005c903          	lbu	s2,0(a1)
 5d0:	18090f63          	beqz	s2,76e <vprintf+0x1c0>
 5d4:	8aaa                	mv	s5,a0
 5d6:	8b32                	mv	s6,a2
 5d8:	00158493          	addi	s1,a1,1
  state = 0;
 5dc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5de:	02500a13          	li	s4,37
      if(c == 'd'){
 5e2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5e6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5ea:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5ee:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f2:	00000b97          	auipc	s7,0x0
 5f6:	3deb8b93          	addi	s7,s7,990 # 9d0 <digits>
 5fa:	a839                	j	618 <vprintf+0x6a>
        putc(fd, c);
 5fc:	85ca                	mv	a1,s2
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	ee2080e7          	jalr	-286(ra) # 4e2 <putc>
 608:	a019                	j	60e <vprintf+0x60>
    } else if(state == '%'){
 60a:	01498f63          	beq	s3,s4,628 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 60e:	0485                	addi	s1,s1,1
 610:	fff4c903          	lbu	s2,-1(s1)
 614:	14090d63          	beqz	s2,76e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 618:	0009079b          	sext.w	a5,s2
    if(state == 0){
 61c:	fe0997e3          	bnez	s3,60a <vprintf+0x5c>
      if(c == '%'){
 620:	fd479ee3          	bne	a5,s4,5fc <vprintf+0x4e>
        state = '%';
 624:	89be                	mv	s3,a5
 626:	b7e5                	j	60e <vprintf+0x60>
      if(c == 'd'){
 628:	05878063          	beq	a5,s8,668 <vprintf+0xba>
      } else if(c == 'l') {
 62c:	05978c63          	beq	a5,s9,684 <vprintf+0xd6>
      } else if(c == 'x') {
 630:	07a78863          	beq	a5,s10,6a0 <vprintf+0xf2>
      } else if(c == 'p') {
 634:	09b78463          	beq	a5,s11,6bc <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 638:	07300713          	li	a4,115
 63c:	0ce78663          	beq	a5,a4,708 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 640:	06300713          	li	a4,99
 644:	0ee78e63          	beq	a5,a4,740 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 648:	11478863          	beq	a5,s4,758 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 64c:	85d2                	mv	a1,s4
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	e92080e7          	jalr	-366(ra) # 4e2 <putc>
        putc(fd, c);
 658:	85ca                	mv	a1,s2
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	e86080e7          	jalr	-378(ra) # 4e2 <putc>
      }
      state = 0;
 664:	4981                	li	s3,0
 666:	b765                	j	60e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 668:	008b0913          	addi	s2,s6,8
 66c:	4685                	li	a3,1
 66e:	4629                	li	a2,10
 670:	000b2583          	lw	a1,0(s6)
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	e8e080e7          	jalr	-370(ra) # 504 <printint>
 67e:	8b4a                	mv	s6,s2
      state = 0;
 680:	4981                	li	s3,0
 682:	b771                	j	60e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 684:	008b0913          	addi	s2,s6,8
 688:	4681                	li	a3,0
 68a:	4629                	li	a2,10
 68c:	000b2583          	lw	a1,0(s6)
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	e72080e7          	jalr	-398(ra) # 504 <printint>
 69a:	8b4a                	mv	s6,s2
      state = 0;
 69c:	4981                	li	s3,0
 69e:	bf85                	j	60e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6a0:	008b0913          	addi	s2,s6,8
 6a4:	4681                	li	a3,0
 6a6:	4641                	li	a2,16
 6a8:	000b2583          	lw	a1,0(s6)
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	e56080e7          	jalr	-426(ra) # 504 <printint>
 6b6:	8b4a                	mv	s6,s2
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bf91                	j	60e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6bc:	008b0793          	addi	a5,s6,8
 6c0:	f8f43423          	sd	a5,-120(s0)
 6c4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6c8:	03000593          	li	a1,48
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e14080e7          	jalr	-492(ra) # 4e2 <putc>
  putc(fd, 'x');
 6d6:	85ea                	mv	a1,s10
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	e08080e7          	jalr	-504(ra) # 4e2 <putc>
 6e2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e4:	03c9d793          	srli	a5,s3,0x3c
 6e8:	97de                	add	a5,a5,s7
 6ea:	0007c583          	lbu	a1,0(a5)
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	df2080e7          	jalr	-526(ra) # 4e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f8:	0992                	slli	s3,s3,0x4
 6fa:	397d                	addiw	s2,s2,-1
 6fc:	fe0914e3          	bnez	s2,6e4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 700:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 704:	4981                	li	s3,0
 706:	b721                	j	60e <vprintf+0x60>
        s = va_arg(ap, char*);
 708:	008b0993          	addi	s3,s6,8
 70c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 710:	02090163          	beqz	s2,732 <vprintf+0x184>
        while(*s != 0){
 714:	00094583          	lbu	a1,0(s2)
 718:	c9a1                	beqz	a1,768 <vprintf+0x1ba>
          putc(fd, *s);
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	dc6080e7          	jalr	-570(ra) # 4e2 <putc>
          s++;
 724:	0905                	addi	s2,s2,1
        while(*s != 0){
 726:	00094583          	lbu	a1,0(s2)
 72a:	f9e5                	bnez	a1,71a <vprintf+0x16c>
        s = va_arg(ap, char*);
 72c:	8b4e                	mv	s6,s3
      state = 0;
 72e:	4981                	li	s3,0
 730:	bdf9                	j	60e <vprintf+0x60>
          s = "(null)";
 732:	00000917          	auipc	s2,0x0
 736:	29690913          	addi	s2,s2,662 # 9c8 <malloc+0x150>
        while(*s != 0){
 73a:	02800593          	li	a1,40
 73e:	bff1                	j	71a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 740:	008b0913          	addi	s2,s6,8
 744:	000b4583          	lbu	a1,0(s6)
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	d98080e7          	jalr	-616(ra) # 4e2 <putc>
 752:	8b4a                	mv	s6,s2
      state = 0;
 754:	4981                	li	s3,0
 756:	bd65                	j	60e <vprintf+0x60>
        putc(fd, c);
 758:	85d2                	mv	a1,s4
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	d86080e7          	jalr	-634(ra) # 4e2 <putc>
      state = 0;
 764:	4981                	li	s3,0
 766:	b565                	j	60e <vprintf+0x60>
        s = va_arg(ap, char*);
 768:	8b4e                	mv	s6,s3
      state = 0;
 76a:	4981                	li	s3,0
 76c:	b54d                	j	60e <vprintf+0x60>
    }
  }
}
 76e:	70e6                	ld	ra,120(sp)
 770:	7446                	ld	s0,112(sp)
 772:	74a6                	ld	s1,104(sp)
 774:	7906                	ld	s2,96(sp)
 776:	69e6                	ld	s3,88(sp)
 778:	6a46                	ld	s4,80(sp)
 77a:	6aa6                	ld	s5,72(sp)
 77c:	6b06                	ld	s6,64(sp)
 77e:	7be2                	ld	s7,56(sp)
 780:	7c42                	ld	s8,48(sp)
 782:	7ca2                	ld	s9,40(sp)
 784:	7d02                	ld	s10,32(sp)
 786:	6de2                	ld	s11,24(sp)
 788:	6109                	addi	sp,sp,128
 78a:	8082                	ret

000000000000078c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 78c:	715d                	addi	sp,sp,-80
 78e:	ec06                	sd	ra,24(sp)
 790:	e822                	sd	s0,16(sp)
 792:	1000                	addi	s0,sp,32
 794:	e010                	sd	a2,0(s0)
 796:	e414                	sd	a3,8(s0)
 798:	e818                	sd	a4,16(s0)
 79a:	ec1c                	sd	a5,24(s0)
 79c:	03043023          	sd	a6,32(s0)
 7a0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a8:	8622                	mv	a2,s0
 7aa:	00000097          	auipc	ra,0x0
 7ae:	e04080e7          	jalr	-508(ra) # 5ae <vprintf>
}
 7b2:	60e2                	ld	ra,24(sp)
 7b4:	6442                	ld	s0,16(sp)
 7b6:	6161                	addi	sp,sp,80
 7b8:	8082                	ret

00000000000007ba <printf>:

void
printf(const char *fmt, ...)
{
 7ba:	711d                	addi	sp,sp,-96
 7bc:	ec06                	sd	ra,24(sp)
 7be:	e822                	sd	s0,16(sp)
 7c0:	1000                	addi	s0,sp,32
 7c2:	e40c                	sd	a1,8(s0)
 7c4:	e810                	sd	a2,16(s0)
 7c6:	ec14                	sd	a3,24(s0)
 7c8:	f018                	sd	a4,32(s0)
 7ca:	f41c                	sd	a5,40(s0)
 7cc:	03043823          	sd	a6,48(s0)
 7d0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d4:	00840613          	addi	a2,s0,8
 7d8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7dc:	85aa                	mv	a1,a0
 7de:	4505                	li	a0,1
 7e0:	00000097          	auipc	ra,0x0
 7e4:	dce080e7          	jalr	-562(ra) # 5ae <vprintf>
}
 7e8:	60e2                	ld	ra,24(sp)
 7ea:	6442                	ld	s0,16(sp)
 7ec:	6125                	addi	sp,sp,96
 7ee:	8082                	ret

00000000000007f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f0:	1141                	addi	sp,sp,-16
 7f2:	e422                	sd	s0,8(sp)
 7f4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fa:	00000797          	auipc	a5,0x0
 7fe:	1fe7b783          	ld	a5,510(a5) # 9f8 <freep>
 802:	a805                	j	832 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 804:	4618                	lw	a4,8(a2)
 806:	9db9                	addw	a1,a1,a4
 808:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 80c:	6398                	ld	a4,0(a5)
 80e:	6318                	ld	a4,0(a4)
 810:	fee53823          	sd	a4,-16(a0)
 814:	a091                	j	858 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 816:	ff852703          	lw	a4,-8(a0)
 81a:	9e39                	addw	a2,a2,a4
 81c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 81e:	ff053703          	ld	a4,-16(a0)
 822:	e398                	sd	a4,0(a5)
 824:	a099                	j	86a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 826:	6398                	ld	a4,0(a5)
 828:	00e7e463          	bltu	a5,a4,830 <free+0x40>
 82c:	00e6ea63          	bltu	a3,a4,840 <free+0x50>
{
 830:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 832:	fed7fae3          	bgeu	a5,a3,826 <free+0x36>
 836:	6398                	ld	a4,0(a5)
 838:	00e6e463          	bltu	a3,a4,840 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83c:	fee7eae3          	bltu	a5,a4,830 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 840:	ff852583          	lw	a1,-8(a0)
 844:	6390                	ld	a2,0(a5)
 846:	02059713          	slli	a4,a1,0x20
 84a:	9301                	srli	a4,a4,0x20
 84c:	0712                	slli	a4,a4,0x4
 84e:	9736                	add	a4,a4,a3
 850:	fae60ae3          	beq	a2,a4,804 <free+0x14>
    bp->s.ptr = p->s.ptr;
 854:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 858:	4790                	lw	a2,8(a5)
 85a:	02061713          	slli	a4,a2,0x20
 85e:	9301                	srli	a4,a4,0x20
 860:	0712                	slli	a4,a4,0x4
 862:	973e                	add	a4,a4,a5
 864:	fae689e3          	beq	a3,a4,816 <free+0x26>
  } else
    p->s.ptr = bp;
 868:	e394                	sd	a3,0(a5)
  freep = p;
 86a:	00000717          	auipc	a4,0x0
 86e:	18f73723          	sd	a5,398(a4) # 9f8 <freep>
}
 872:	6422                	ld	s0,8(sp)
 874:	0141                	addi	sp,sp,16
 876:	8082                	ret

0000000000000878 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 878:	7139                	addi	sp,sp,-64
 87a:	fc06                	sd	ra,56(sp)
 87c:	f822                	sd	s0,48(sp)
 87e:	f426                	sd	s1,40(sp)
 880:	f04a                	sd	s2,32(sp)
 882:	ec4e                	sd	s3,24(sp)
 884:	e852                	sd	s4,16(sp)
 886:	e456                	sd	s5,8(sp)
 888:	e05a                	sd	s6,0(sp)
 88a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88c:	02051493          	slli	s1,a0,0x20
 890:	9081                	srli	s1,s1,0x20
 892:	04bd                	addi	s1,s1,15
 894:	8091                	srli	s1,s1,0x4
 896:	0014899b          	addiw	s3,s1,1
 89a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 89c:	00000517          	auipc	a0,0x0
 8a0:	15c53503          	ld	a0,348(a0) # 9f8 <freep>
 8a4:	c515                	beqz	a0,8d0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a8:	4798                	lw	a4,8(a5)
 8aa:	02977f63          	bgeu	a4,s1,8e8 <malloc+0x70>
 8ae:	8a4e                	mv	s4,s3
 8b0:	0009871b          	sext.w	a4,s3
 8b4:	6685                	lui	a3,0x1
 8b6:	00d77363          	bgeu	a4,a3,8bc <malloc+0x44>
 8ba:	6a05                	lui	s4,0x1
 8bc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c4:	00000917          	auipc	s2,0x0
 8c8:	13490913          	addi	s2,s2,308 # 9f8 <freep>
  if(p == (char*)-1)
 8cc:	5afd                	li	s5,-1
 8ce:	a88d                	j	940 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8d0:	00008797          	auipc	a5,0x8
 8d4:	17078793          	addi	a5,a5,368 # 8a40 <base>
 8d8:	00000717          	auipc	a4,0x0
 8dc:	12f73023          	sd	a5,288(a4) # 9f8 <freep>
 8e0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8e2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8e6:	b7e1                	j	8ae <malloc+0x36>
      if(p->s.size == nunits)
 8e8:	02e48b63          	beq	s1,a4,91e <malloc+0xa6>
        p->s.size -= nunits;
 8ec:	4137073b          	subw	a4,a4,s3
 8f0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f2:	1702                	slli	a4,a4,0x20
 8f4:	9301                	srli	a4,a4,0x20
 8f6:	0712                	slli	a4,a4,0x4
 8f8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8fa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8fe:	00000717          	auipc	a4,0x0
 902:	0ea73d23          	sd	a0,250(a4) # 9f8 <freep>
      return (void*)(p + 1);
 906:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 90a:	70e2                	ld	ra,56(sp)
 90c:	7442                	ld	s0,48(sp)
 90e:	74a2                	ld	s1,40(sp)
 910:	7902                	ld	s2,32(sp)
 912:	69e2                	ld	s3,24(sp)
 914:	6a42                	ld	s4,16(sp)
 916:	6aa2                	ld	s5,8(sp)
 918:	6b02                	ld	s6,0(sp)
 91a:	6121                	addi	sp,sp,64
 91c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 91e:	6398                	ld	a4,0(a5)
 920:	e118                	sd	a4,0(a0)
 922:	bff1                	j	8fe <malloc+0x86>
  hp->s.size = nu;
 924:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 928:	0541                	addi	a0,a0,16
 92a:	00000097          	auipc	ra,0x0
 92e:	ec6080e7          	jalr	-314(ra) # 7f0 <free>
  return freep;
 932:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 936:	d971                	beqz	a0,90a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 938:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93a:	4798                	lw	a4,8(a5)
 93c:	fa9776e3          	bgeu	a4,s1,8e8 <malloc+0x70>
    if(p == freep)
 940:	00093703          	ld	a4,0(s2)
 944:	853e                	mv	a0,a5
 946:	fef719e3          	bne	a4,a5,938 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 94a:	8552                	mv	a0,s4
 94c:	00000097          	auipc	ra,0x0
 950:	b5e080e7          	jalr	-1186(ra) # 4aa <sbrk>
  if(p == (char*)-1)
 954:	fd5518e3          	bne	a0,s5,924 <malloc+0xac>
        return 0;
 958:	4501                	li	a0,0
 95a:	bf45                	j	90a <malloc+0x92>
