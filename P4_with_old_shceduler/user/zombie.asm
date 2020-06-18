
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	2e0080e7          	jalr	736(ra) # 2e8 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	2da080e7          	jalr	730(ra) # 2f0 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	360080e7          	jalr	864(ra) # 380 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e422                	sd	s0,8(sp)
  2e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  30:	87aa                	mv	a5,a0
  32:	0585                	addi	a1,a1,1
  34:	0785                	addi	a5,a5,1
  36:	fff5c703          	lbu	a4,-1(a1)
  3a:	fee78fa3          	sb	a4,-1(a5)
  3e:	fb75                	bnez	a4,32 <strcpy+0x8>
    ;
  return os;
}
  40:	6422                	ld	s0,8(sp)
  42:	0141                	addi	sp,sp,16
  44:	8082                	ret

0000000000000046 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  46:	1141                	addi	sp,sp,-16
  48:	e422                	sd	s0,8(sp)
  4a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4c:	00054783          	lbu	a5,0(a0)
  50:	cb91                	beqz	a5,64 <strcmp+0x1e>
  52:	0005c703          	lbu	a4,0(a1)
  56:	00f71763          	bne	a4,a5,64 <strcmp+0x1e>
    p++, q++;
  5a:	0505                	addi	a0,a0,1
  5c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	fbe5                	bnez	a5,52 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  64:	0005c503          	lbu	a0,0(a1)
}
  68:	40a7853b          	subw	a0,a5,a0
  6c:	6422                	ld	s0,8(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	addi	sp,sp,-16
  74:	e422                	sd	s0,8(sp)
  76:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  78:	00054783          	lbu	a5,0(a0)
  7c:	cf91                	beqz	a5,98 <strlen+0x26>
  7e:	0505                	addi	a0,a0,1
  80:	87aa                	mv	a5,a0
  82:	4685                	li	a3,1
  84:	9e89                	subw	a3,a3,a0
  86:	00f6853b          	addw	a0,a3,a5
  8a:	0785                	addi	a5,a5,1
  8c:	fff7c703          	lbu	a4,-1(a5)
  90:	fb7d                	bnez	a4,86 <strlen+0x14>
    ;
  return n;
}
  92:	6422                	ld	s0,8(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret
  for(n = 0; s[n]; n++)
  98:	4501                	li	a0,0
  9a:	bfe5                	j	92 <strlen+0x20>

000000000000009c <memset>:

void*
memset(void *dst, int c, uint n)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a2:	ce09                	beqz	a2,bc <memset+0x20>
  a4:	87aa                	mv	a5,a0
  a6:	fff6071b          	addiw	a4,a2,-1
  aa:	1702                	slli	a4,a4,0x20
  ac:	9301                	srli	a4,a4,0x20
  ae:	0705                	addi	a4,a4,1
  b0:	972a                	add	a4,a4,a0
    cdst[i] = c;
  b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b6:	0785                	addi	a5,a5,1
  b8:	fee79de3          	bne	a5,a4,b2 <memset+0x16>
  }
  return dst;
}
  bc:	6422                	ld	s0,8(sp)
  be:	0141                	addi	sp,sp,16
  c0:	8082                	ret

00000000000000c2 <strchr>:

char*
strchr(const char *s, char c)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e422                	sd	s0,8(sp)
  c6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	cb99                	beqz	a5,e2 <strchr+0x20>
    if(*s == c)
  ce:	00f58763          	beq	a1,a5,dc <strchr+0x1a>
  for(; *s; s++)
  d2:	0505                	addi	a0,a0,1
  d4:	00054783          	lbu	a5,0(a0)
  d8:	fbfd                	bnez	a5,ce <strchr+0xc>
      return (char*)s;
  return 0;
  da:	4501                	li	a0,0
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret
  return 0;
  e2:	4501                	li	a0,0
  e4:	bfe5                	j	dc <strchr+0x1a>

00000000000000e6 <gets>:

char*
gets(char *buf, int max)
{
  e6:	711d                	addi	sp,sp,-96
  e8:	ec86                	sd	ra,88(sp)
  ea:	e8a2                	sd	s0,80(sp)
  ec:	e4a6                	sd	s1,72(sp)
  ee:	e0ca                	sd	s2,64(sp)
  f0:	fc4e                	sd	s3,56(sp)
  f2:	f852                	sd	s4,48(sp)
  f4:	f456                	sd	s5,40(sp)
  f6:	f05a                	sd	s6,32(sp)
  f8:	ec5e                	sd	s7,24(sp)
  fa:	1080                	addi	s0,sp,96
  fc:	8baa                	mv	s7,a0
  fe:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 100:	892a                	mv	s2,a0
 102:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 104:	4aa9                	li	s5,10
 106:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 108:	89a6                	mv	s3,s1
 10a:	2485                	addiw	s1,s1,1
 10c:	0344d863          	bge	s1,s4,13c <gets+0x56>
    cc = read(0, &c, 1);
 110:	4605                	li	a2,1
 112:	faf40593          	addi	a1,s0,-81
 116:	4501                	li	a0,0
 118:	00000097          	auipc	ra,0x0
 11c:	1f0080e7          	jalr	496(ra) # 308 <read>
    if(cc < 1)
 120:	00a05e63          	blez	a0,13c <gets+0x56>
    buf[i++] = c;
 124:	faf44783          	lbu	a5,-81(s0)
 128:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12c:	01578763          	beq	a5,s5,13a <gets+0x54>
 130:	0905                	addi	s2,s2,1
 132:	fd679be3          	bne	a5,s6,108 <gets+0x22>
  for(i=0; i+1 < max; ){
 136:	89a6                	mv	s3,s1
 138:	a011                	j	13c <gets+0x56>
 13a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13c:	99de                	add	s3,s3,s7
 13e:	00098023          	sb	zero,0(s3)
  return buf;
}
 142:	855e                	mv	a0,s7
 144:	60e6                	ld	ra,88(sp)
 146:	6446                	ld	s0,80(sp)
 148:	64a6                	ld	s1,72(sp)
 14a:	6906                	ld	s2,64(sp)
 14c:	79e2                	ld	s3,56(sp)
 14e:	7a42                	ld	s4,48(sp)
 150:	7aa2                	ld	s5,40(sp)
 152:	7b02                	ld	s6,32(sp)
 154:	6be2                	ld	s7,24(sp)
 156:	6125                	addi	sp,sp,96
 158:	8082                	ret

000000000000015a <stat>:

int
stat(const char *n, struct stat *st)
{
 15a:	1101                	addi	sp,sp,-32
 15c:	ec06                	sd	ra,24(sp)
 15e:	e822                	sd	s0,16(sp)
 160:	e426                	sd	s1,8(sp)
 162:	e04a                	sd	s2,0(sp)
 164:	1000                	addi	s0,sp,32
 166:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 168:	4581                	li	a1,0
 16a:	00000097          	auipc	ra,0x0
 16e:	1c6080e7          	jalr	454(ra) # 330 <open>
  if(fd < 0)
 172:	02054563          	bltz	a0,19c <stat+0x42>
 176:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 178:	85ca                	mv	a1,s2
 17a:	00000097          	auipc	ra,0x0
 17e:	1ce080e7          	jalr	462(ra) # 348 <fstat>
 182:	892a                	mv	s2,a0
  close(fd);
 184:	8526                	mv	a0,s1
 186:	00000097          	auipc	ra,0x0
 18a:	192080e7          	jalr	402(ra) # 318 <close>
  return r;
}
 18e:	854a                	mv	a0,s2
 190:	60e2                	ld	ra,24(sp)
 192:	6442                	ld	s0,16(sp)
 194:	64a2                	ld	s1,8(sp)
 196:	6902                	ld	s2,0(sp)
 198:	6105                	addi	sp,sp,32
 19a:	8082                	ret
    return -1;
 19c:	597d                	li	s2,-1
 19e:	bfc5                	j	18e <stat+0x34>

00000000000001a0 <atoi>:

int
atoi(const char *s)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a6:	00054603          	lbu	a2,0(a0)
 1aa:	fd06079b          	addiw	a5,a2,-48
 1ae:	0ff7f793          	andi	a5,a5,255
 1b2:	4725                	li	a4,9
 1b4:	02f76963          	bltu	a4,a5,1e6 <atoi+0x46>
 1b8:	86aa                	mv	a3,a0
  n = 0;
 1ba:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1bc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1be:	0685                	addi	a3,a3,1
 1c0:	0025179b          	slliw	a5,a0,0x2
 1c4:	9fa9                	addw	a5,a5,a0
 1c6:	0017979b          	slliw	a5,a5,0x1
 1ca:	9fb1                	addw	a5,a5,a2
 1cc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d0:	0006c603          	lbu	a2,0(a3)
 1d4:	fd06071b          	addiw	a4,a2,-48
 1d8:	0ff77713          	andi	a4,a4,255
 1dc:	fee5f1e3          	bgeu	a1,a4,1be <atoi+0x1e>
  return n;
}
 1e0:	6422                	ld	s0,8(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  n = 0;
 1e6:	4501                	li	a0,0
 1e8:	bfe5                	j	1e0 <atoi+0x40>

00000000000001ea <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e422                	sd	s0,8(sp)
 1ee:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1f0:	02c05163          	blez	a2,212 <memmove+0x28>
 1f4:	fff6071b          	addiw	a4,a2,-1
 1f8:	1702                	slli	a4,a4,0x20
 1fa:	9301                	srli	a4,a4,0x20
 1fc:	0705                	addi	a4,a4,1
 1fe:	972a                	add	a4,a4,a0
  dst = vdst;
 200:	87aa                	mv	a5,a0
    *dst++ = *src++;
 202:	0585                	addi	a1,a1,1
 204:	0785                	addi	a5,a5,1
 206:	fff5c683          	lbu	a3,-1(a1)
 20a:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 20e:	fee79ae3          	bne	a5,a4,202 <memmove+0x18>
  return vdst;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret

0000000000000218 <lock_init>:

void lock_init(lock_t *l, char *name) {
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
 l->name = name;
 21e:	e10c                	sd	a1,0(a0)
 l->locked = 0;
 220:	00052423          	sw	zero,8(a0)
 //l->guard = 0;
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret

000000000000022a <lock_acquire>:

void lock_acquire(lock_t *l) {
 22a:	1141                	addi	sp,sp,-16
 22c:	e422                	sd	s0,8(sp)
 22e:	0800                	addi	s0,sp,16
  while(__sync_lock_test_and_set(&l->locked, 1) != 0)
 230:	4705                	li	a4,1
 232:	87ba                	mv	a5,a4
 234:	00850693          	addi	a3,a0,8
 238:	0cf6a7af          	amoswap.w.aq	a5,a5,(a3)
 23c:	2781                	sext.w	a5,a5
 23e:	fbf5                	bnez	a5,232 <lock_acquire+0x8>
    ;
  __sync_synchronize();
 240:	0ff0000f          	fence
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret

000000000000024a <lock_release>:

void lock_release(lock_t *l) {
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  __sync_synchronize();
 250:	0ff0000f          	fence
  __sync_lock_release(&l->locked);
 254:	00850793          	addi	a5,a0,8
 258:	0f50000f          	fence	iorw,ow
 25c:	0807a02f          	amoswap.w	zero,zero,(a5)
//  l->locked = 0;
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret

0000000000000266 <thread_create>:
//    condwakeup(cond->curr);
//  }
//}
int
thread_create(void (*start_routine)(void*, void*), void *arg1, void *arg2)
{
 266:	7179                	addi	sp,sp,-48
 268:	f406                	sd	ra,40(sp)
 26a:	f022                	sd	s0,32(sp)
 26c:	ec26                	sd	s1,24(sp)
 26e:	e84a                	sd	s2,16(sp)
 270:	e44e                	sd	s3,8(sp)
 272:	1800                	addi	s0,sp,48
 274:	84aa                	mv	s1,a0
 276:	892e                	mv	s2,a1
 278:	89b2                	mv	s3,a2
  void *stack = malloc(PGSIZE*2); //allocate space on the heap, should be 1 page in size and pagesize aligned
 27a:	6509                	lui	a0,0x2
 27c:	00000097          	auipc	ra,0x0
 280:	512080e7          	jalr	1298(ra) # 78e <malloc>
 284:	86aa                	mv	a3,a0
  if((uint64)stack % PGSIZE) { //not aligned
 286:	03451793          	slli	a5,a0,0x34
 28a:	c799                	beqz	a5,298 <thread_create+0x32>
 28c:	0347d713          	srli	a4,a5,0x34
    stack = stack + (PGSIZE - (uint64)stack % PGSIZE); //make is pagesize aligned
 290:	6785                	lui	a5,0x1
 292:	8f99                	sub	a5,a5,a4
 294:	00f506b3          	add	a3,a0,a5
  }
  int pid = clone(start_routine, arg1, arg2, stack);
 298:	864e                	mv	a2,s3
 29a:	85ca                	mv	a1,s2
 29c:	8526                	mv	a0,s1
 29e:	00000097          	auipc	ra,0x0
 2a2:	0f2080e7          	jalr	242(ra) # 390 <clone>
  return pid;
}
 2a6:	70a2                	ld	ra,40(sp)
 2a8:	7402                	ld	s0,32(sp)
 2aa:	64e2                	ld	s1,24(sp)
 2ac:	6942                	ld	s2,16(sp)
 2ae:	69a2                	ld	s3,8(sp)
 2b0:	6145                	addi	sp,sp,48
 2b2:	8082                	ret

00000000000002b4 <thread_join>:

int thread_join() {
 2b4:	7179                	addi	sp,sp,-48
 2b6:	f406                	sd	ra,40(sp)
 2b8:	f022                	sd	s0,32(sp)
 2ba:	ec26                	sd	s1,24(sp)
 2bc:	1800                	addi	s0,sp,48
  void *ustack = 0;
 2be:	fc043c23          	sd	zero,-40(s0)
  int status = join(&ustack);
 2c2:	fd840513          	addi	a0,s0,-40
 2c6:	00000097          	auipc	ra,0x0
 2ca:	0d2080e7          	jalr	210(ra) # 398 <join>
 2ce:	84aa                	mv	s1,a0
  free(ustack);
 2d0:	fd843503          	ld	a0,-40(s0)
 2d4:	00000097          	auipc	ra,0x0
 2d8:	432080e7          	jalr	1074(ra) # 706 <free>
  return status;
}
 2dc:	8526                	mv	a0,s1
 2de:	70a2                	ld	ra,40(sp)
 2e0:	7402                	ld	s0,32(sp)
 2e2:	64e2                	ld	s1,24(sp)
 2e4:	6145                	addi	sp,sp,48
 2e6:	8082                	ret

00000000000002e8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e8:	4885                	li	a7,1
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2f0:	4889                	li	a7,2
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f8:	488d                	li	a7,3
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 300:	4891                	li	a7,4
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <read>:
.global read
read:
 li a7, SYS_read
 308:	4895                	li	a7,5
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <write>:
.global write
write:
 li a7, SYS_write
 310:	48c1                	li	a7,16
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <close>:
.global close
close:
 li a7, SYS_close
 318:	48d5                	li	a7,21
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <kill>:
.global kill
kill:
 li a7, SYS_kill
 320:	4899                	li	a7,6
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <exec>:
.global exec
exec:
 li a7, SYS_exec
 328:	489d                	li	a7,7
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <open>:
.global open
open:
 li a7, SYS_open
 330:	48bd                	li	a7,15
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 338:	48c5                	li	a7,17
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 340:	48c9                	li	a7,18
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 348:	48a1                	li	a7,8
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <link>:
.global link
link:
 li a7, SYS_link
 350:	48cd                	li	a7,19
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 358:	48d1                	li	a7,20
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 360:	48a5                	li	a7,9
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <dup>:
.global dup
dup:
 li a7, SYS_dup
 368:	48a9                	li	a7,10
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 370:	48ad                	li	a7,11
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 378:	48b1                	li	a7,12
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 380:	48b5                	li	a7,13
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 388:	48b9                	li	a7,14
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <clone>:
.global clone
clone:
 li a7, SYS_clone
 390:	48d9                	li	a7,22
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <join>:
.global join
join:
 li a7, SYS_join
 398:	48dd                	li	a7,23
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <putc>:
  int type;
};

static void
putc(int fd, char c)
{
 3a0:	1101                	addi	sp,sp,-32
 3a2:	ec06                	sd	ra,24(sp)
 3a4:	e822                	sd	s0,16(sp)
 3a6:	1000                	addi	s0,sp,32
 3a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ac:	4605                	li	a2,1
 3ae:	fef40593          	addi	a1,s0,-17
 3b2:	00000097          	auipc	ra,0x0
 3b6:	f5e080e7          	jalr	-162(ra) # 310 <write>
}
 3ba:	60e2                	ld	ra,24(sp)
 3bc:	6442                	ld	s0,16(sp)
 3be:	6105                	addi	sp,sp,32
 3c0:	8082                	ret

00000000000003c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c2:	7139                	addi	sp,sp,-64
 3c4:	fc06                	sd	ra,56(sp)
 3c6:	f822                	sd	s0,48(sp)
 3c8:	f426                	sd	s1,40(sp)
 3ca:	f04a                	sd	s2,32(sp)
 3cc:	ec4e                	sd	s3,24(sp)
 3ce:	0080                	addi	s0,sp,64
 3d0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d2:	c299                	beqz	a3,3d8 <printint+0x16>
 3d4:	0805c863          	bltz	a1,464 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3d8:	2581                	sext.w	a1,a1
  neg = 0;
 3da:	4881                	li	a7,0
 3dc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3e0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3e2:	2601                	sext.w	a2,a2
 3e4:	00000517          	auipc	a0,0x0
 3e8:	4a450513          	addi	a0,a0,1188 # 888 <digits>
 3ec:	883a                	mv	a6,a4
 3ee:	2705                	addiw	a4,a4,1
 3f0:	02c5f7bb          	remuw	a5,a1,a2
 3f4:	1782                	slli	a5,a5,0x20
 3f6:	9381                	srli	a5,a5,0x20
 3f8:	97aa                	add	a5,a5,a0
 3fa:	0007c783          	lbu	a5,0(a5) # 1000 <__BSS_END__+0x730>
 3fe:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 402:	0005879b          	sext.w	a5,a1
 406:	02c5d5bb          	divuw	a1,a1,a2
 40a:	0685                	addi	a3,a3,1
 40c:	fec7f0e3          	bgeu	a5,a2,3ec <printint+0x2a>
  if(neg)
 410:	00088b63          	beqz	a7,426 <printint+0x64>
    buf[i++] = '-';
 414:	fd040793          	addi	a5,s0,-48
 418:	973e                	add	a4,a4,a5
 41a:	02d00793          	li	a5,45
 41e:	fef70823          	sb	a5,-16(a4)
 422:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 426:	02e05863          	blez	a4,456 <printint+0x94>
 42a:	fc040793          	addi	a5,s0,-64
 42e:	00e78933          	add	s2,a5,a4
 432:	fff78993          	addi	s3,a5,-1
 436:	99ba                	add	s3,s3,a4
 438:	377d                	addiw	a4,a4,-1
 43a:	1702                	slli	a4,a4,0x20
 43c:	9301                	srli	a4,a4,0x20
 43e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 442:	fff94583          	lbu	a1,-1(s2)
 446:	8526                	mv	a0,s1
 448:	00000097          	auipc	ra,0x0
 44c:	f58080e7          	jalr	-168(ra) # 3a0 <putc>
  while(--i >= 0)
 450:	197d                	addi	s2,s2,-1
 452:	ff3918e3          	bne	s2,s3,442 <printint+0x80>
}
 456:	70e2                	ld	ra,56(sp)
 458:	7442                	ld	s0,48(sp)
 45a:	74a2                	ld	s1,40(sp)
 45c:	7902                	ld	s2,32(sp)
 45e:	69e2                	ld	s3,24(sp)
 460:	6121                	addi	sp,sp,64
 462:	8082                	ret
    x = -xx;
 464:	40b005bb          	negw	a1,a1
    neg = 1;
 468:	4885                	li	a7,1
    x = -xx;
 46a:	bf8d                	j	3dc <printint+0x1a>

000000000000046c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 46c:	7119                	addi	sp,sp,-128
 46e:	fc86                	sd	ra,120(sp)
 470:	f8a2                	sd	s0,112(sp)
 472:	f4a6                	sd	s1,104(sp)
 474:	f0ca                	sd	s2,96(sp)
 476:	ecce                	sd	s3,88(sp)
 478:	e8d2                	sd	s4,80(sp)
 47a:	e4d6                	sd	s5,72(sp)
 47c:	e0da                	sd	s6,64(sp)
 47e:	fc5e                	sd	s7,56(sp)
 480:	f862                	sd	s8,48(sp)
 482:	f466                	sd	s9,40(sp)
 484:	f06a                	sd	s10,32(sp)
 486:	ec6e                	sd	s11,24(sp)
 488:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 48a:	0005c903          	lbu	s2,0(a1)
 48e:	18090f63          	beqz	s2,62c <vprintf+0x1c0>
 492:	8aaa                	mv	s5,a0
 494:	8b32                	mv	s6,a2
 496:	00158493          	addi	s1,a1,1
  state = 0;
 49a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 49c:	02500a13          	li	s4,37
      if(c == 'd'){
 4a0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4a4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4a8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4ac:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4b0:	00000b97          	auipc	s7,0x0
 4b4:	3d8b8b93          	addi	s7,s7,984 # 888 <digits>
 4b8:	a839                	j	4d6 <vprintf+0x6a>
        putc(fd, c);
 4ba:	85ca                	mv	a1,s2
 4bc:	8556                	mv	a0,s5
 4be:	00000097          	auipc	ra,0x0
 4c2:	ee2080e7          	jalr	-286(ra) # 3a0 <putc>
 4c6:	a019                	j	4cc <vprintf+0x60>
    } else if(state == '%'){
 4c8:	01498f63          	beq	s3,s4,4e6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4cc:	0485                	addi	s1,s1,1
 4ce:	fff4c903          	lbu	s2,-1(s1)
 4d2:	14090d63          	beqz	s2,62c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4d6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4da:	fe0997e3          	bnez	s3,4c8 <vprintf+0x5c>
      if(c == '%'){
 4de:	fd479ee3          	bne	a5,s4,4ba <vprintf+0x4e>
        state = '%';
 4e2:	89be                	mv	s3,a5
 4e4:	b7e5                	j	4cc <vprintf+0x60>
      if(c == 'd'){
 4e6:	05878063          	beq	a5,s8,526 <vprintf+0xba>
      } else if(c == 'l') {
 4ea:	05978c63          	beq	a5,s9,542 <vprintf+0xd6>
      } else if(c == 'x') {
 4ee:	07a78863          	beq	a5,s10,55e <vprintf+0xf2>
      } else if(c == 'p') {
 4f2:	09b78463          	beq	a5,s11,57a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4f6:	07300713          	li	a4,115
 4fa:	0ce78663          	beq	a5,a4,5c6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4fe:	06300713          	li	a4,99
 502:	0ee78e63          	beq	a5,a4,5fe <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 506:	11478863          	beq	a5,s4,616 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 50a:	85d2                	mv	a1,s4
 50c:	8556                	mv	a0,s5
 50e:	00000097          	auipc	ra,0x0
 512:	e92080e7          	jalr	-366(ra) # 3a0 <putc>
        putc(fd, c);
 516:	85ca                	mv	a1,s2
 518:	8556                	mv	a0,s5
 51a:	00000097          	auipc	ra,0x0
 51e:	e86080e7          	jalr	-378(ra) # 3a0 <putc>
      }
      state = 0;
 522:	4981                	li	s3,0
 524:	b765                	j	4cc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 526:	008b0913          	addi	s2,s6,8
 52a:	4685                	li	a3,1
 52c:	4629                	li	a2,10
 52e:	000b2583          	lw	a1,0(s6)
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	e8e080e7          	jalr	-370(ra) # 3c2 <printint>
 53c:	8b4a                	mv	s6,s2
      state = 0;
 53e:	4981                	li	s3,0
 540:	b771                	j	4cc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 542:	008b0913          	addi	s2,s6,8
 546:	4681                	li	a3,0
 548:	4629                	li	a2,10
 54a:	000b2583          	lw	a1,0(s6)
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	e72080e7          	jalr	-398(ra) # 3c2 <printint>
 558:	8b4a                	mv	s6,s2
      state = 0;
 55a:	4981                	li	s3,0
 55c:	bf85                	j	4cc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 55e:	008b0913          	addi	s2,s6,8
 562:	4681                	li	a3,0
 564:	4641                	li	a2,16
 566:	000b2583          	lw	a1,0(s6)
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	e56080e7          	jalr	-426(ra) # 3c2 <printint>
 574:	8b4a                	mv	s6,s2
      state = 0;
 576:	4981                	li	s3,0
 578:	bf91                	j	4cc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 57a:	008b0793          	addi	a5,s6,8
 57e:	f8f43423          	sd	a5,-120(s0)
 582:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 586:	03000593          	li	a1,48
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	e14080e7          	jalr	-492(ra) # 3a0 <putc>
  putc(fd, 'x');
 594:	85ea                	mv	a1,s10
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	e08080e7          	jalr	-504(ra) # 3a0 <putc>
 5a0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5a2:	03c9d793          	srli	a5,s3,0x3c
 5a6:	97de                	add	a5,a5,s7
 5a8:	0007c583          	lbu	a1,0(a5)
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	df2080e7          	jalr	-526(ra) # 3a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5b6:	0992                	slli	s3,s3,0x4
 5b8:	397d                	addiw	s2,s2,-1
 5ba:	fe0914e3          	bnez	s2,5a2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5be:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b721                	j	4cc <vprintf+0x60>
        s = va_arg(ap, char*);
 5c6:	008b0993          	addi	s3,s6,8
 5ca:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5ce:	02090163          	beqz	s2,5f0 <vprintf+0x184>
        while(*s != 0){
 5d2:	00094583          	lbu	a1,0(s2)
 5d6:	c9a1                	beqz	a1,626 <vprintf+0x1ba>
          putc(fd, *s);
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	dc6080e7          	jalr	-570(ra) # 3a0 <putc>
          s++;
 5e2:	0905                	addi	s2,s2,1
        while(*s != 0){
 5e4:	00094583          	lbu	a1,0(s2)
 5e8:	f9e5                	bnez	a1,5d8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 5ea:	8b4e                	mv	s6,s3
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	bdf9                	j	4cc <vprintf+0x60>
          s = "(null)";
 5f0:	00000917          	auipc	s2,0x0
 5f4:	28890913          	addi	s2,s2,648 # 878 <malloc+0xea>
        while(*s != 0){
 5f8:	02800593          	li	a1,40
 5fc:	bff1                	j	5d8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5fe:	008b0913          	addi	s2,s6,8
 602:	000b4583          	lbu	a1,0(s6)
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	d98080e7          	jalr	-616(ra) # 3a0 <putc>
 610:	8b4a                	mv	s6,s2
      state = 0;
 612:	4981                	li	s3,0
 614:	bd65                	j	4cc <vprintf+0x60>
        putc(fd, c);
 616:	85d2                	mv	a1,s4
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	d86080e7          	jalr	-634(ra) # 3a0 <putc>
      state = 0;
 622:	4981                	li	s3,0
 624:	b565                	j	4cc <vprintf+0x60>
        s = va_arg(ap, char*);
 626:	8b4e                	mv	s6,s3
      state = 0;
 628:	4981                	li	s3,0
 62a:	b54d                	j	4cc <vprintf+0x60>
    }
  }
}
 62c:	70e6                	ld	ra,120(sp)
 62e:	7446                	ld	s0,112(sp)
 630:	74a6                	ld	s1,104(sp)
 632:	7906                	ld	s2,96(sp)
 634:	69e6                	ld	s3,88(sp)
 636:	6a46                	ld	s4,80(sp)
 638:	6aa6                	ld	s5,72(sp)
 63a:	6b06                	ld	s6,64(sp)
 63c:	7be2                	ld	s7,56(sp)
 63e:	7c42                	ld	s8,48(sp)
 640:	7ca2                	ld	s9,40(sp)
 642:	7d02                	ld	s10,32(sp)
 644:	6de2                	ld	s11,24(sp)
 646:	6109                	addi	sp,sp,128
 648:	8082                	ret

000000000000064a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 64a:	715d                	addi	sp,sp,-80
 64c:	ec06                	sd	ra,24(sp)
 64e:	e822                	sd	s0,16(sp)
 650:	1000                	addi	s0,sp,32
 652:	e010                	sd	a2,0(s0)
 654:	e414                	sd	a3,8(s0)
 656:	e818                	sd	a4,16(s0)
 658:	ec1c                	sd	a5,24(s0)
 65a:	03043023          	sd	a6,32(s0)
 65e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 662:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 666:	8622                	mv	a2,s0
 668:	00000097          	auipc	ra,0x0
 66c:	e04080e7          	jalr	-508(ra) # 46c <vprintf>
}
 670:	60e2                	ld	ra,24(sp)
 672:	6442                	ld	s0,16(sp)
 674:	6161                	addi	sp,sp,80
 676:	8082                	ret

0000000000000678 <printf>:

void
printf(const char *fmt, ...)
{
 678:	7159                	addi	sp,sp,-112
 67a:	f406                	sd	ra,40(sp)
 67c:	f022                	sd	s0,32(sp)
 67e:	ec26                	sd	s1,24(sp)
 680:	e84a                	sd	s2,16(sp)
 682:	1800                	addi	s0,sp,48
 684:	84aa                	mv	s1,a0
 686:	e40c                	sd	a1,8(s0)
 688:	e810                	sd	a2,16(s0)
 68a:	ec14                	sd	a3,24(s0)
 68c:	f018                	sd	a4,32(s0)
 68e:	f41c                	sd	a5,40(s0)
 690:	03043823          	sd	a6,48(s0)
 694:	03143c23          	sd	a7,56(s0)
  va_list ap;
  lock_acquire(&pr.printf_lock);
 698:	00000917          	auipc	s2,0x0
 69c:	21090913          	addi	s2,s2,528 # 8a8 <pr>
 6a0:	854a                	mv	a0,s2
 6a2:	00000097          	auipc	ra,0x0
 6a6:	b88080e7          	jalr	-1144(ra) # 22a <lock_acquire>

  va_start(ap, fmt);
 6aa:	00840613          	addi	a2,s0,8
 6ae:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 6b2:	85a6                	mv	a1,s1
 6b4:	4505                	li	a0,1
 6b6:	00000097          	auipc	ra,0x0
 6ba:	db6080e7          	jalr	-586(ra) # 46c <vprintf>
  
  lock_release(&pr.printf_lock);
 6be:	854a                	mv	a0,s2
 6c0:	00000097          	auipc	ra,0x0
 6c4:	b8a080e7          	jalr	-1142(ra) # 24a <lock_release>

}
 6c8:	70a2                	ld	ra,40(sp)
 6ca:	7402                	ld	s0,32(sp)
 6cc:	64e2                	ld	s1,24(sp)
 6ce:	6942                	ld	s2,16(sp)
 6d0:	6165                	addi	sp,sp,112
 6d2:	8082                	ret

00000000000006d4 <printfinit>:

void
printfinit(void)
{
 6d4:	1101                	addi	sp,sp,-32
 6d6:	ec06                	sd	ra,24(sp)
 6d8:	e822                	sd	s0,16(sp)
 6da:	e426                	sd	s1,8(sp)
 6dc:	1000                	addi	s0,sp,32
  lock_init(&pr.printf_lock, "pr");
 6de:	00000497          	auipc	s1,0x0
 6e2:	1ca48493          	addi	s1,s1,458 # 8a8 <pr>
 6e6:	00000597          	auipc	a1,0x0
 6ea:	19a58593          	addi	a1,a1,410 # 880 <malloc+0xf2>
 6ee:	8526                	mv	a0,s1
 6f0:	00000097          	auipc	ra,0x0
 6f4:	b28080e7          	jalr	-1240(ra) # 218 <lock_init>
  pr.locking = 1;
 6f8:	4785                	li	a5,1
 6fa:	c89c                	sw	a5,16(s1)
}
 6fc:	60e2                	ld	ra,24(sp)
 6fe:	6442                	ld	s0,16(sp)
 700:	64a2                	ld	s1,8(sp)
 702:	6105                	addi	sp,sp,32
 704:	8082                	ret

0000000000000706 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 706:	1141                	addi	sp,sp,-16
 708:	e422                	sd	s0,8(sp)
 70a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 70c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 710:	00000797          	auipc	a5,0x0
 714:	1907b783          	ld	a5,400(a5) # 8a0 <freep>
 718:	a805                	j	748 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 71a:	4618                	lw	a4,8(a2)
 71c:	9db9                	addw	a1,a1,a4
 71e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 722:	6398                	ld	a4,0(a5)
 724:	6318                	ld	a4,0(a4)
 726:	fee53823          	sd	a4,-16(a0)
 72a:	a091                	j	76e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 72c:	ff852703          	lw	a4,-8(a0)
 730:	9e39                	addw	a2,a2,a4
 732:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 734:	ff053703          	ld	a4,-16(a0)
 738:	e398                	sd	a4,0(a5)
 73a:	a099                	j	780 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73c:	6398                	ld	a4,0(a5)
 73e:	00e7e463          	bltu	a5,a4,746 <free+0x40>
 742:	00e6ea63          	bltu	a3,a4,756 <free+0x50>
{
 746:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 748:	fed7fae3          	bgeu	a5,a3,73c <free+0x36>
 74c:	6398                	ld	a4,0(a5)
 74e:	00e6e463          	bltu	a3,a4,756 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 752:	fee7eae3          	bltu	a5,a4,746 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 756:	ff852583          	lw	a1,-8(a0)
 75a:	6390                	ld	a2,0(a5)
 75c:	02059713          	slli	a4,a1,0x20
 760:	9301                	srli	a4,a4,0x20
 762:	0712                	slli	a4,a4,0x4
 764:	9736                	add	a4,a4,a3
 766:	fae60ae3          	beq	a2,a4,71a <free+0x14>
    bp->s.ptr = p->s.ptr;
 76a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 76e:	4790                	lw	a2,8(a5)
 770:	02061713          	slli	a4,a2,0x20
 774:	9301                	srli	a4,a4,0x20
 776:	0712                	slli	a4,a4,0x4
 778:	973e                	add	a4,a4,a5
 77a:	fae689e3          	beq	a3,a4,72c <free+0x26>
  } else
    p->s.ptr = bp;
 77e:	e394                	sd	a3,0(a5)
  freep = p;
 780:	00000717          	auipc	a4,0x0
 784:	12f73023          	sd	a5,288(a4) # 8a0 <freep>
}
 788:	6422                	ld	s0,8(sp)
 78a:	0141                	addi	sp,sp,16
 78c:	8082                	ret

000000000000078e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 78e:	7139                	addi	sp,sp,-64
 790:	fc06                	sd	ra,56(sp)
 792:	f822                	sd	s0,48(sp)
 794:	f426                	sd	s1,40(sp)
 796:	f04a                	sd	s2,32(sp)
 798:	ec4e                	sd	s3,24(sp)
 79a:	e852                	sd	s4,16(sp)
 79c:	e456                	sd	s5,8(sp)
 79e:	e05a                	sd	s6,0(sp)
 7a0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a2:	02051493          	slli	s1,a0,0x20
 7a6:	9081                	srli	s1,s1,0x20
 7a8:	04bd                	addi	s1,s1,15
 7aa:	8091                	srli	s1,s1,0x4
 7ac:	0014899b          	addiw	s3,s1,1
 7b0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7b2:	00000517          	auipc	a0,0x0
 7b6:	0ee53503          	ld	a0,238(a0) # 8a0 <freep>
 7ba:	c515                	beqz	a0,7e6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7be:	4798                	lw	a4,8(a5)
 7c0:	02977f63          	bgeu	a4,s1,7fe <malloc+0x70>
 7c4:	8a4e                	mv	s4,s3
 7c6:	0009871b          	sext.w	a4,s3
 7ca:	6685                	lui	a3,0x1
 7cc:	00d77363          	bgeu	a4,a3,7d2 <malloc+0x44>
 7d0:	6a05                	lui	s4,0x1
 7d2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7d6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7da:	00000917          	auipc	s2,0x0
 7de:	0c690913          	addi	s2,s2,198 # 8a0 <freep>
  if(p == (char*)-1)
 7e2:	5afd                	li	s5,-1
 7e4:	a88d                	j	856 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7e6:	00000797          	auipc	a5,0x0
 7ea:	0da78793          	addi	a5,a5,218 # 8c0 <base>
 7ee:	00000717          	auipc	a4,0x0
 7f2:	0af73923          	sd	a5,178(a4) # 8a0 <freep>
 7f6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7f8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7fc:	b7e1                	j	7c4 <malloc+0x36>
      if(p->s.size == nunits)
 7fe:	02e48b63          	beq	s1,a4,834 <malloc+0xa6>
        p->s.size -= nunits;
 802:	4137073b          	subw	a4,a4,s3
 806:	c798                	sw	a4,8(a5)
        p += p->s.size;
 808:	1702                	slli	a4,a4,0x20
 80a:	9301                	srli	a4,a4,0x20
 80c:	0712                	slli	a4,a4,0x4
 80e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 810:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 814:	00000717          	auipc	a4,0x0
 818:	08a73623          	sd	a0,140(a4) # 8a0 <freep>
      return (void*)(p + 1);
 81c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 820:	70e2                	ld	ra,56(sp)
 822:	7442                	ld	s0,48(sp)
 824:	74a2                	ld	s1,40(sp)
 826:	7902                	ld	s2,32(sp)
 828:	69e2                	ld	s3,24(sp)
 82a:	6a42                	ld	s4,16(sp)
 82c:	6aa2                	ld	s5,8(sp)
 82e:	6b02                	ld	s6,0(sp)
 830:	6121                	addi	sp,sp,64
 832:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 834:	6398                	ld	a4,0(a5)
 836:	e118                	sd	a4,0(a0)
 838:	bff1                	j	814 <malloc+0x86>
  hp->s.size = nu;
 83a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 83e:	0541                	addi	a0,a0,16
 840:	00000097          	auipc	ra,0x0
 844:	ec6080e7          	jalr	-314(ra) # 706 <free>
  return freep;
 848:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 84c:	d971                	beqz	a0,820 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 850:	4798                	lw	a4,8(a5)
 852:	fa9776e3          	bgeu	a4,s1,7fe <malloc+0x70>
    if(p == freep)
 856:	00093703          	ld	a4,0(s2)
 85a:	853e                	mv	a0,a5
 85c:	fef719e3          	bne	a4,a5,84e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 860:	8552                	mv	a0,s4
 862:	00000097          	auipc	ra,0x0
 866:	b16080e7          	jalr	-1258(ra) # 378 <sbrk>
  if(p == (char*)-1)
 86a:	fd5518e3          	bne	a0,s5,83a <malloc+0xac>
        return 0;
 86e:	4501                	li	a0,0
 870:	bf45                	j	820 <malloc+0x92>
