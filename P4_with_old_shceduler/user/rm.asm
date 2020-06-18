
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d763          	bge	a5,a0,3e <main+0x3e>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	1902                	slli	s2,s2,0x20
  1e:	02095913          	srli	s2,s2,0x20
  22:	090e                	slli	s2,s2,0x3
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	364080e7          	jalr	868(ra) # 38e <unlink>
  32:	02054463          	bltz	a0,5a <main+0x5a>
  for(i = 1; i < argc; i++){
  36:	04a1                	addi	s1,s1,8
  38:	ff2498e3          	bne	s1,s2,28 <main+0x28>
  3c:	a80d                	j	6e <main+0x6e>
    fprintf(2, "Usage: rm files...\n");
  3e:	00001597          	auipc	a1,0x1
  42:	88258593          	addi	a1,a1,-1918 # 8c0 <malloc+0xe4>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	650080e7          	jalr	1616(ra) # 698 <fprintf>
    exit(1);
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	2ec080e7          	jalr	748(ra) # 33e <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	6090                	ld	a2,0(s1)
  5c:	00001597          	auipc	a1,0x1
  60:	87c58593          	addi	a1,a1,-1924 # 8d8 <malloc+0xfc>
  64:	4509                	li	a0,2
  66:	00000097          	auipc	ra,0x0
  6a:	632080e7          	jalr	1586(ra) # 698 <fprintf>
      break;
    }
  }

  exit(0);
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	2ce080e7          	jalr	718(ra) # 33e <exit>

0000000000000078 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0x8>
    ;
  return os;
}
  8e:	6422                	ld	s0,8(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	cb91                	beqz	a5,b2 <strcmp+0x1e>
  a0:	0005c703          	lbu	a4,0(a1)
  a4:	00f71763          	bne	a4,a5,b2 <strcmp+0x1e>
    p++, q++;
  a8:	0505                	addi	a0,a0,1
  aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	fbe5                	bnez	a5,a0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b2:	0005c503          	lbu	a0,0(a1)
}
  b6:	40a7853b          	subw	a0,a5,a0
  ba:	6422                	ld	s0,8(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	cf91                	beqz	a5,e6 <strlen+0x26>
  cc:	0505                	addi	a0,a0,1
  ce:	87aa                	mv	a5,a0
  d0:	4685                	li	a3,1
  d2:	9e89                	subw	a3,a3,a0
  d4:	00f6853b          	addw	a0,a3,a5
  d8:	0785                	addi	a5,a5,1
  da:	fff7c703          	lbu	a4,-1(a5)
  de:	fb7d                	bnez	a4,d4 <strlen+0x14>
    ;
  return n;
}
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret
  for(n = 0; s[n]; n++)
  e6:	4501                	li	a0,0
  e8:	bfe5                	j	e0 <strlen+0x20>

00000000000000ea <memset>:

void*
memset(void *dst, int c, uint n)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f0:	ce09                	beqz	a2,10a <memset+0x20>
  f2:	87aa                	mv	a5,a0
  f4:	fff6071b          	addiw	a4,a2,-1
  f8:	1702                	slli	a4,a4,0x20
  fa:	9301                	srli	a4,a4,0x20
  fc:	0705                	addi	a4,a4,1
  fe:	972a                	add	a4,a4,a0
    cdst[i] = c;
 100:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 104:	0785                	addi	a5,a5,1
 106:	fee79de3          	bne	a5,a4,100 <memset+0x16>
  }
  return dst;
}
 10a:	6422                	ld	s0,8(sp)
 10c:	0141                	addi	sp,sp,16
 10e:	8082                	ret

0000000000000110 <strchr>:

char*
strchr(const char *s, char c)
{
 110:	1141                	addi	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	addi	s0,sp,16
  for(; *s; s++)
 116:	00054783          	lbu	a5,0(a0)
 11a:	cb99                	beqz	a5,130 <strchr+0x20>
    if(*s == c)
 11c:	00f58763          	beq	a1,a5,12a <strchr+0x1a>
  for(; *s; s++)
 120:	0505                	addi	a0,a0,1
 122:	00054783          	lbu	a5,0(a0)
 126:	fbfd                	bnez	a5,11c <strchr+0xc>
      return (char*)s;
  return 0;
 128:	4501                	li	a0,0
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret
  return 0;
 130:	4501                	li	a0,0
 132:	bfe5                	j	12a <strchr+0x1a>

0000000000000134 <gets>:

char*
gets(char *buf, int max)
{
 134:	711d                	addi	sp,sp,-96
 136:	ec86                	sd	ra,88(sp)
 138:	e8a2                	sd	s0,80(sp)
 13a:	e4a6                	sd	s1,72(sp)
 13c:	e0ca                	sd	s2,64(sp)
 13e:	fc4e                	sd	s3,56(sp)
 140:	f852                	sd	s4,48(sp)
 142:	f456                	sd	s5,40(sp)
 144:	f05a                	sd	s6,32(sp)
 146:	ec5e                	sd	s7,24(sp)
 148:	1080                	addi	s0,sp,96
 14a:	8baa                	mv	s7,a0
 14c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14e:	892a                	mv	s2,a0
 150:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 152:	4aa9                	li	s5,10
 154:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 156:	89a6                	mv	s3,s1
 158:	2485                	addiw	s1,s1,1
 15a:	0344d863          	bge	s1,s4,18a <gets+0x56>
    cc = read(0, &c, 1);
 15e:	4605                	li	a2,1
 160:	faf40593          	addi	a1,s0,-81
 164:	4501                	li	a0,0
 166:	00000097          	auipc	ra,0x0
 16a:	1f0080e7          	jalr	496(ra) # 356 <read>
    if(cc < 1)
 16e:	00a05e63          	blez	a0,18a <gets+0x56>
    buf[i++] = c;
 172:	faf44783          	lbu	a5,-81(s0)
 176:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17a:	01578763          	beq	a5,s5,188 <gets+0x54>
 17e:	0905                	addi	s2,s2,1
 180:	fd679be3          	bne	a5,s6,156 <gets+0x22>
  for(i=0; i+1 < max; ){
 184:	89a6                	mv	s3,s1
 186:	a011                	j	18a <gets+0x56>
 188:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 18a:	99de                	add	s3,s3,s7
 18c:	00098023          	sb	zero,0(s3)
  return buf;
}
 190:	855e                	mv	a0,s7
 192:	60e6                	ld	ra,88(sp)
 194:	6446                	ld	s0,80(sp)
 196:	64a6                	ld	s1,72(sp)
 198:	6906                	ld	s2,64(sp)
 19a:	79e2                	ld	s3,56(sp)
 19c:	7a42                	ld	s4,48(sp)
 19e:	7aa2                	ld	s5,40(sp)
 1a0:	7b02                	ld	s6,32(sp)
 1a2:	6be2                	ld	s7,24(sp)
 1a4:	6125                	addi	sp,sp,96
 1a6:	8082                	ret

00000000000001a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a8:	1101                	addi	sp,sp,-32
 1aa:	ec06                	sd	ra,24(sp)
 1ac:	e822                	sd	s0,16(sp)
 1ae:	e426                	sd	s1,8(sp)
 1b0:	e04a                	sd	s2,0(sp)
 1b2:	1000                	addi	s0,sp,32
 1b4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b6:	4581                	li	a1,0
 1b8:	00000097          	auipc	ra,0x0
 1bc:	1c6080e7          	jalr	454(ra) # 37e <open>
  if(fd < 0)
 1c0:	02054563          	bltz	a0,1ea <stat+0x42>
 1c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c6:	85ca                	mv	a1,s2
 1c8:	00000097          	auipc	ra,0x0
 1cc:	1ce080e7          	jalr	462(ra) # 396 <fstat>
 1d0:	892a                	mv	s2,a0
  close(fd);
 1d2:	8526                	mv	a0,s1
 1d4:	00000097          	auipc	ra,0x0
 1d8:	192080e7          	jalr	402(ra) # 366 <close>
  return r;
}
 1dc:	854a                	mv	a0,s2
 1de:	60e2                	ld	ra,24(sp)
 1e0:	6442                	ld	s0,16(sp)
 1e2:	64a2                	ld	s1,8(sp)
 1e4:	6902                	ld	s2,0(sp)
 1e6:	6105                	addi	sp,sp,32
 1e8:	8082                	ret
    return -1;
 1ea:	597d                	li	s2,-1
 1ec:	bfc5                	j	1dc <stat+0x34>

00000000000001ee <atoi>:

int
atoi(const char *s)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f4:	00054603          	lbu	a2,0(a0)
 1f8:	fd06079b          	addiw	a5,a2,-48
 1fc:	0ff7f793          	andi	a5,a5,255
 200:	4725                	li	a4,9
 202:	02f76963          	bltu	a4,a5,234 <atoi+0x46>
 206:	86aa                	mv	a3,a0
  n = 0;
 208:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 20a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 20c:	0685                	addi	a3,a3,1
 20e:	0025179b          	slliw	a5,a0,0x2
 212:	9fa9                	addw	a5,a5,a0
 214:	0017979b          	slliw	a5,a5,0x1
 218:	9fb1                	addw	a5,a5,a2
 21a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21e:	0006c603          	lbu	a2,0(a3)
 222:	fd06071b          	addiw	a4,a2,-48
 226:	0ff77713          	andi	a4,a4,255
 22a:	fee5f1e3          	bgeu	a1,a4,20c <atoi+0x1e>
  return n;
}
 22e:	6422                	ld	s0,8(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
  n = 0;
 234:	4501                	li	a0,0
 236:	bfe5                	j	22e <atoi+0x40>

0000000000000238 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 23e:	02c05163          	blez	a2,260 <memmove+0x28>
 242:	fff6071b          	addiw	a4,a2,-1
 246:	1702                	slli	a4,a4,0x20
 248:	9301                	srli	a4,a4,0x20
 24a:	0705                	addi	a4,a4,1
 24c:	972a                	add	a4,a4,a0
  dst = vdst;
 24e:	87aa                	mv	a5,a0
    *dst++ = *src++;
 250:	0585                	addi	a1,a1,1
 252:	0785                	addi	a5,a5,1
 254:	fff5c683          	lbu	a3,-1(a1)
 258:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x18>
  return vdst;
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret

0000000000000266 <lock_init>:

void lock_init(lock_t *l, char *name) {
 266:	1141                	addi	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	addi	s0,sp,16
 l->name = name;
 26c:	e10c                	sd	a1,0(a0)
 l->locked = 0;
 26e:	00052423          	sw	zero,8(a0)
 //l->guard = 0;
}
 272:	6422                	ld	s0,8(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret

0000000000000278 <lock_acquire>:

void lock_acquire(lock_t *l) {
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  while(__sync_lock_test_and_set(&l->locked, 1) != 0)
 27e:	4705                	li	a4,1
 280:	87ba                	mv	a5,a4
 282:	00850693          	addi	a3,a0,8
 286:	0cf6a7af          	amoswap.w.aq	a5,a5,(a3)
 28a:	2781                	sext.w	a5,a5
 28c:	fbf5                	bnez	a5,280 <lock_acquire+0x8>
    ;
  __sync_synchronize();
 28e:	0ff0000f          	fence
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret

0000000000000298 <lock_release>:

void lock_release(lock_t *l) {
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  __sync_synchronize();
 29e:	0ff0000f          	fence
  __sync_lock_release(&l->locked);
 2a2:	00850793          	addi	a5,a0,8
 2a6:	0f50000f          	fence	iorw,ow
 2aa:	0807a02f          	amoswap.w	zero,zero,(a5)
//  l->locked = 0;
}
 2ae:	6422                	ld	s0,8(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <thread_create>:
//    condwakeup(cond->curr);
//  }
//}
int
thread_create(void (*start_routine)(void*, void*), void *arg1, void *arg2)
{
 2b4:	7179                	addi	sp,sp,-48
 2b6:	f406                	sd	ra,40(sp)
 2b8:	f022                	sd	s0,32(sp)
 2ba:	ec26                	sd	s1,24(sp)
 2bc:	e84a                	sd	s2,16(sp)
 2be:	e44e                	sd	s3,8(sp)
 2c0:	1800                	addi	s0,sp,48
 2c2:	84aa                	mv	s1,a0
 2c4:	892e                	mv	s2,a1
 2c6:	89b2                	mv	s3,a2
  void *stack = malloc(PGSIZE*2); //allocate space on the heap, should be 1 page in size and pagesize aligned
 2c8:	6509                	lui	a0,0x2
 2ca:	00000097          	auipc	ra,0x0
 2ce:	512080e7          	jalr	1298(ra) # 7dc <malloc>
 2d2:	86aa                	mv	a3,a0
  if((uint64)stack % PGSIZE) { //not aligned
 2d4:	03451793          	slli	a5,a0,0x34
 2d8:	c799                	beqz	a5,2e6 <thread_create+0x32>
 2da:	0347d713          	srli	a4,a5,0x34
    stack = stack + (PGSIZE - (uint64)stack % PGSIZE); //make is pagesize aligned
 2de:	6785                	lui	a5,0x1
 2e0:	8f99                	sub	a5,a5,a4
 2e2:	00f506b3          	add	a3,a0,a5
  }
  int pid = clone(start_routine, arg1, arg2, stack);
 2e6:	864e                	mv	a2,s3
 2e8:	85ca                	mv	a1,s2
 2ea:	8526                	mv	a0,s1
 2ec:	00000097          	auipc	ra,0x0
 2f0:	0f2080e7          	jalr	242(ra) # 3de <clone>
  return pid;
}
 2f4:	70a2                	ld	ra,40(sp)
 2f6:	7402                	ld	s0,32(sp)
 2f8:	64e2                	ld	s1,24(sp)
 2fa:	6942                	ld	s2,16(sp)
 2fc:	69a2                	ld	s3,8(sp)
 2fe:	6145                	addi	sp,sp,48
 300:	8082                	ret

0000000000000302 <thread_join>:

int thread_join() {
 302:	7179                	addi	sp,sp,-48
 304:	f406                	sd	ra,40(sp)
 306:	f022                	sd	s0,32(sp)
 308:	ec26                	sd	s1,24(sp)
 30a:	1800                	addi	s0,sp,48
  void *ustack = 0;
 30c:	fc043c23          	sd	zero,-40(s0)
  int status = join(&ustack);
 310:	fd840513          	addi	a0,s0,-40
 314:	00000097          	auipc	ra,0x0
 318:	0d2080e7          	jalr	210(ra) # 3e6 <join>
 31c:	84aa                	mv	s1,a0
  free(ustack);
 31e:	fd843503          	ld	a0,-40(s0)
 322:	00000097          	auipc	ra,0x0
 326:	432080e7          	jalr	1074(ra) # 754 <free>
  return status;
}
 32a:	8526                	mv	a0,s1
 32c:	70a2                	ld	ra,40(sp)
 32e:	7402                	ld	s0,32(sp)
 330:	64e2                	ld	s1,24(sp)
 332:	6145                	addi	sp,sp,48
 334:	8082                	ret

0000000000000336 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 336:	4885                	li	a7,1
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <exit>:
.global exit
exit:
 li a7, SYS_exit
 33e:	4889                	li	a7,2
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <wait>:
.global wait
wait:
 li a7, SYS_wait
 346:	488d                	li	a7,3
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 34e:	4891                	li	a7,4
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <read>:
.global read
read:
 li a7, SYS_read
 356:	4895                	li	a7,5
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <write>:
.global write
write:
 li a7, SYS_write
 35e:	48c1                	li	a7,16
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <close>:
.global close
close:
 li a7, SYS_close
 366:	48d5                	li	a7,21
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <kill>:
.global kill
kill:
 li a7, SYS_kill
 36e:	4899                	li	a7,6
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <exec>:
.global exec
exec:
 li a7, SYS_exec
 376:	489d                	li	a7,7
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <open>:
.global open
open:
 li a7, SYS_open
 37e:	48bd                	li	a7,15
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 386:	48c5                	li	a7,17
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 38e:	48c9                	li	a7,18
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 396:	48a1                	li	a7,8
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <link>:
.global link
link:
 li a7, SYS_link
 39e:	48cd                	li	a7,19
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3a6:	48d1                	li	a7,20
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ae:	48a5                	li	a7,9
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3b6:	48a9                	li	a7,10
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3be:	48ad                	li	a7,11
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3c6:	48b1                	li	a7,12
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ce:	48b5                	li	a7,13
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3d6:	48b9                	li	a7,14
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <clone>:
.global clone
clone:
 li a7, SYS_clone
 3de:	48d9                	li	a7,22
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <join>:
.global join
join:
 li a7, SYS_join
 3e6:	48dd                	li	a7,23
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <putc>:
  int type;
};

static void
putc(int fd, char c)
{
 3ee:	1101                	addi	sp,sp,-32
 3f0:	ec06                	sd	ra,24(sp)
 3f2:	e822                	sd	s0,16(sp)
 3f4:	1000                	addi	s0,sp,32
 3f6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3fa:	4605                	li	a2,1
 3fc:	fef40593          	addi	a1,s0,-17
 400:	00000097          	auipc	ra,0x0
 404:	f5e080e7          	jalr	-162(ra) # 35e <write>
}
 408:	60e2                	ld	ra,24(sp)
 40a:	6442                	ld	s0,16(sp)
 40c:	6105                	addi	sp,sp,32
 40e:	8082                	ret

0000000000000410 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 410:	7139                	addi	sp,sp,-64
 412:	fc06                	sd	ra,56(sp)
 414:	f822                	sd	s0,48(sp)
 416:	f426                	sd	s1,40(sp)
 418:	f04a                	sd	s2,32(sp)
 41a:	ec4e                	sd	s3,24(sp)
 41c:	0080                	addi	s0,sp,64
 41e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 420:	c299                	beqz	a3,426 <printint+0x16>
 422:	0805c863          	bltz	a1,4b2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 426:	2581                	sext.w	a1,a1
  neg = 0;
 428:	4881                	li	a7,0
 42a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 42e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 430:	2601                	sext.w	a2,a2
 432:	00000517          	auipc	a0,0x0
 436:	4d650513          	addi	a0,a0,1238 # 908 <digits>
 43a:	883a                	mv	a6,a4
 43c:	2705                	addiw	a4,a4,1
 43e:	02c5f7bb          	remuw	a5,a1,a2
 442:	1782                	slli	a5,a5,0x20
 444:	9381                	srli	a5,a5,0x20
 446:	97aa                	add	a5,a5,a0
 448:	0007c783          	lbu	a5,0(a5) # 1000 <__BSS_END__+0x6b0>
 44c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 450:	0005879b          	sext.w	a5,a1
 454:	02c5d5bb          	divuw	a1,a1,a2
 458:	0685                	addi	a3,a3,1
 45a:	fec7f0e3          	bgeu	a5,a2,43a <printint+0x2a>
  if(neg)
 45e:	00088b63          	beqz	a7,474 <printint+0x64>
    buf[i++] = '-';
 462:	fd040793          	addi	a5,s0,-48
 466:	973e                	add	a4,a4,a5
 468:	02d00793          	li	a5,45
 46c:	fef70823          	sb	a5,-16(a4)
 470:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 474:	02e05863          	blez	a4,4a4 <printint+0x94>
 478:	fc040793          	addi	a5,s0,-64
 47c:	00e78933          	add	s2,a5,a4
 480:	fff78993          	addi	s3,a5,-1
 484:	99ba                	add	s3,s3,a4
 486:	377d                	addiw	a4,a4,-1
 488:	1702                	slli	a4,a4,0x20
 48a:	9301                	srli	a4,a4,0x20
 48c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 490:	fff94583          	lbu	a1,-1(s2)
 494:	8526                	mv	a0,s1
 496:	00000097          	auipc	ra,0x0
 49a:	f58080e7          	jalr	-168(ra) # 3ee <putc>
  while(--i >= 0)
 49e:	197d                	addi	s2,s2,-1
 4a0:	ff3918e3          	bne	s2,s3,490 <printint+0x80>
}
 4a4:	70e2                	ld	ra,56(sp)
 4a6:	7442                	ld	s0,48(sp)
 4a8:	74a2                	ld	s1,40(sp)
 4aa:	7902                	ld	s2,32(sp)
 4ac:	69e2                	ld	s3,24(sp)
 4ae:	6121                	addi	sp,sp,64
 4b0:	8082                	ret
    x = -xx;
 4b2:	40b005bb          	negw	a1,a1
    neg = 1;
 4b6:	4885                	li	a7,1
    x = -xx;
 4b8:	bf8d                	j	42a <printint+0x1a>

00000000000004ba <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ba:	7119                	addi	sp,sp,-128
 4bc:	fc86                	sd	ra,120(sp)
 4be:	f8a2                	sd	s0,112(sp)
 4c0:	f4a6                	sd	s1,104(sp)
 4c2:	f0ca                	sd	s2,96(sp)
 4c4:	ecce                	sd	s3,88(sp)
 4c6:	e8d2                	sd	s4,80(sp)
 4c8:	e4d6                	sd	s5,72(sp)
 4ca:	e0da                	sd	s6,64(sp)
 4cc:	fc5e                	sd	s7,56(sp)
 4ce:	f862                	sd	s8,48(sp)
 4d0:	f466                	sd	s9,40(sp)
 4d2:	f06a                	sd	s10,32(sp)
 4d4:	ec6e                	sd	s11,24(sp)
 4d6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d8:	0005c903          	lbu	s2,0(a1)
 4dc:	18090f63          	beqz	s2,67a <vprintf+0x1c0>
 4e0:	8aaa                	mv	s5,a0
 4e2:	8b32                	mv	s6,a2
 4e4:	00158493          	addi	s1,a1,1
  state = 0;
 4e8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ea:	02500a13          	li	s4,37
      if(c == 'd'){
 4ee:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4f2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4f6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4fa:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4fe:	00000b97          	auipc	s7,0x0
 502:	40ab8b93          	addi	s7,s7,1034 # 908 <digits>
 506:	a839                	j	524 <vprintf+0x6a>
        putc(fd, c);
 508:	85ca                	mv	a1,s2
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	ee2080e7          	jalr	-286(ra) # 3ee <putc>
 514:	a019                	j	51a <vprintf+0x60>
    } else if(state == '%'){
 516:	01498f63          	beq	s3,s4,534 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 51a:	0485                	addi	s1,s1,1
 51c:	fff4c903          	lbu	s2,-1(s1)
 520:	14090d63          	beqz	s2,67a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 524:	0009079b          	sext.w	a5,s2
    if(state == 0){
 528:	fe0997e3          	bnez	s3,516 <vprintf+0x5c>
      if(c == '%'){
 52c:	fd479ee3          	bne	a5,s4,508 <vprintf+0x4e>
        state = '%';
 530:	89be                	mv	s3,a5
 532:	b7e5                	j	51a <vprintf+0x60>
      if(c == 'd'){
 534:	05878063          	beq	a5,s8,574 <vprintf+0xba>
      } else if(c == 'l') {
 538:	05978c63          	beq	a5,s9,590 <vprintf+0xd6>
      } else if(c == 'x') {
 53c:	07a78863          	beq	a5,s10,5ac <vprintf+0xf2>
      } else if(c == 'p') {
 540:	09b78463          	beq	a5,s11,5c8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 544:	07300713          	li	a4,115
 548:	0ce78663          	beq	a5,a4,614 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 54c:	06300713          	li	a4,99
 550:	0ee78e63          	beq	a5,a4,64c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 554:	11478863          	beq	a5,s4,664 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 558:	85d2                	mv	a1,s4
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	e92080e7          	jalr	-366(ra) # 3ee <putc>
        putc(fd, c);
 564:	85ca                	mv	a1,s2
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	e86080e7          	jalr	-378(ra) # 3ee <putc>
      }
      state = 0;
 570:	4981                	li	s3,0
 572:	b765                	j	51a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 574:	008b0913          	addi	s2,s6,8
 578:	4685                	li	a3,1
 57a:	4629                	li	a2,10
 57c:	000b2583          	lw	a1,0(s6)
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	e8e080e7          	jalr	-370(ra) # 410 <printint>
 58a:	8b4a                	mv	s6,s2
      state = 0;
 58c:	4981                	li	s3,0
 58e:	b771                	j	51a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 590:	008b0913          	addi	s2,s6,8
 594:	4681                	li	a3,0
 596:	4629                	li	a2,10
 598:	000b2583          	lw	a1,0(s6)
 59c:	8556                	mv	a0,s5
 59e:	00000097          	auipc	ra,0x0
 5a2:	e72080e7          	jalr	-398(ra) # 410 <printint>
 5a6:	8b4a                	mv	s6,s2
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	bf85                	j	51a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5ac:	008b0913          	addi	s2,s6,8
 5b0:	4681                	li	a3,0
 5b2:	4641                	li	a2,16
 5b4:	000b2583          	lw	a1,0(s6)
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	e56080e7          	jalr	-426(ra) # 410 <printint>
 5c2:	8b4a                	mv	s6,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bf91                	j	51a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5c8:	008b0793          	addi	a5,s6,8
 5cc:	f8f43423          	sd	a5,-120(s0)
 5d0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5d4:	03000593          	li	a1,48
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	e14080e7          	jalr	-492(ra) # 3ee <putc>
  putc(fd, 'x');
 5e2:	85ea                	mv	a1,s10
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e08080e7          	jalr	-504(ra) # 3ee <putc>
 5ee:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f0:	03c9d793          	srli	a5,s3,0x3c
 5f4:	97de                	add	a5,a5,s7
 5f6:	0007c583          	lbu	a1,0(a5)
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	df2080e7          	jalr	-526(ra) # 3ee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 604:	0992                	slli	s3,s3,0x4
 606:	397d                	addiw	s2,s2,-1
 608:	fe0914e3          	bnez	s2,5f0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 60c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 610:	4981                	li	s3,0
 612:	b721                	j	51a <vprintf+0x60>
        s = va_arg(ap, char*);
 614:	008b0993          	addi	s3,s6,8
 618:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 61c:	02090163          	beqz	s2,63e <vprintf+0x184>
        while(*s != 0){
 620:	00094583          	lbu	a1,0(s2)
 624:	c9a1                	beqz	a1,674 <vprintf+0x1ba>
          putc(fd, *s);
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	dc6080e7          	jalr	-570(ra) # 3ee <putc>
          s++;
 630:	0905                	addi	s2,s2,1
        while(*s != 0){
 632:	00094583          	lbu	a1,0(s2)
 636:	f9e5                	bnez	a1,626 <vprintf+0x16c>
        s = va_arg(ap, char*);
 638:	8b4e                	mv	s6,s3
      state = 0;
 63a:	4981                	li	s3,0
 63c:	bdf9                	j	51a <vprintf+0x60>
          s = "(null)";
 63e:	00000917          	auipc	s2,0x0
 642:	2ba90913          	addi	s2,s2,698 # 8f8 <malloc+0x11c>
        while(*s != 0){
 646:	02800593          	li	a1,40
 64a:	bff1                	j	626 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 64c:	008b0913          	addi	s2,s6,8
 650:	000b4583          	lbu	a1,0(s6)
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	d98080e7          	jalr	-616(ra) # 3ee <putc>
 65e:	8b4a                	mv	s6,s2
      state = 0;
 660:	4981                	li	s3,0
 662:	bd65                	j	51a <vprintf+0x60>
        putc(fd, c);
 664:	85d2                	mv	a1,s4
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	d86080e7          	jalr	-634(ra) # 3ee <putc>
      state = 0;
 670:	4981                	li	s3,0
 672:	b565                	j	51a <vprintf+0x60>
        s = va_arg(ap, char*);
 674:	8b4e                	mv	s6,s3
      state = 0;
 676:	4981                	li	s3,0
 678:	b54d                	j	51a <vprintf+0x60>
    }
  }
}
 67a:	70e6                	ld	ra,120(sp)
 67c:	7446                	ld	s0,112(sp)
 67e:	74a6                	ld	s1,104(sp)
 680:	7906                	ld	s2,96(sp)
 682:	69e6                	ld	s3,88(sp)
 684:	6a46                	ld	s4,80(sp)
 686:	6aa6                	ld	s5,72(sp)
 688:	6b06                	ld	s6,64(sp)
 68a:	7be2                	ld	s7,56(sp)
 68c:	7c42                	ld	s8,48(sp)
 68e:	7ca2                	ld	s9,40(sp)
 690:	7d02                	ld	s10,32(sp)
 692:	6de2                	ld	s11,24(sp)
 694:	6109                	addi	sp,sp,128
 696:	8082                	ret

0000000000000698 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 698:	715d                	addi	sp,sp,-80
 69a:	ec06                	sd	ra,24(sp)
 69c:	e822                	sd	s0,16(sp)
 69e:	1000                	addi	s0,sp,32
 6a0:	e010                	sd	a2,0(s0)
 6a2:	e414                	sd	a3,8(s0)
 6a4:	e818                	sd	a4,16(s0)
 6a6:	ec1c                	sd	a5,24(s0)
 6a8:	03043023          	sd	a6,32(s0)
 6ac:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6b0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6b4:	8622                	mv	a2,s0
 6b6:	00000097          	auipc	ra,0x0
 6ba:	e04080e7          	jalr	-508(ra) # 4ba <vprintf>
}
 6be:	60e2                	ld	ra,24(sp)
 6c0:	6442                	ld	s0,16(sp)
 6c2:	6161                	addi	sp,sp,80
 6c4:	8082                	ret

00000000000006c6 <printf>:

void
printf(const char *fmt, ...)
{
 6c6:	7159                	addi	sp,sp,-112
 6c8:	f406                	sd	ra,40(sp)
 6ca:	f022                	sd	s0,32(sp)
 6cc:	ec26                	sd	s1,24(sp)
 6ce:	e84a                	sd	s2,16(sp)
 6d0:	1800                	addi	s0,sp,48
 6d2:	84aa                	mv	s1,a0
 6d4:	e40c                	sd	a1,8(s0)
 6d6:	e810                	sd	a2,16(s0)
 6d8:	ec14                	sd	a3,24(s0)
 6da:	f018                	sd	a4,32(s0)
 6dc:	f41c                	sd	a5,40(s0)
 6de:	03043823          	sd	a6,48(s0)
 6e2:	03143c23          	sd	a7,56(s0)
  va_list ap;
  lock_acquire(&pr.printf_lock);
 6e6:	00000917          	auipc	s2,0x0
 6ea:	24290913          	addi	s2,s2,578 # 928 <pr>
 6ee:	854a                	mv	a0,s2
 6f0:	00000097          	auipc	ra,0x0
 6f4:	b88080e7          	jalr	-1144(ra) # 278 <lock_acquire>

  va_start(ap, fmt);
 6f8:	00840613          	addi	a2,s0,8
 6fc:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 700:	85a6                	mv	a1,s1
 702:	4505                	li	a0,1
 704:	00000097          	auipc	ra,0x0
 708:	db6080e7          	jalr	-586(ra) # 4ba <vprintf>
  
  lock_release(&pr.printf_lock);
 70c:	854a                	mv	a0,s2
 70e:	00000097          	auipc	ra,0x0
 712:	b8a080e7          	jalr	-1142(ra) # 298 <lock_release>

}
 716:	70a2                	ld	ra,40(sp)
 718:	7402                	ld	s0,32(sp)
 71a:	64e2                	ld	s1,24(sp)
 71c:	6942                	ld	s2,16(sp)
 71e:	6165                	addi	sp,sp,112
 720:	8082                	ret

0000000000000722 <printfinit>:

void
printfinit(void)
{
 722:	1101                	addi	sp,sp,-32
 724:	ec06                	sd	ra,24(sp)
 726:	e822                	sd	s0,16(sp)
 728:	e426                	sd	s1,8(sp)
 72a:	1000                	addi	s0,sp,32
  lock_init(&pr.printf_lock, "pr");
 72c:	00000497          	auipc	s1,0x0
 730:	1fc48493          	addi	s1,s1,508 # 928 <pr>
 734:	00000597          	auipc	a1,0x0
 738:	1cc58593          	addi	a1,a1,460 # 900 <malloc+0x124>
 73c:	8526                	mv	a0,s1
 73e:	00000097          	auipc	ra,0x0
 742:	b28080e7          	jalr	-1240(ra) # 266 <lock_init>
  pr.locking = 1;
 746:	4785                	li	a5,1
 748:	c89c                	sw	a5,16(s1)
}
 74a:	60e2                	ld	ra,24(sp)
 74c:	6442                	ld	s0,16(sp)
 74e:	64a2                	ld	s1,8(sp)
 750:	6105                	addi	sp,sp,32
 752:	8082                	ret

0000000000000754 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 754:	1141                	addi	sp,sp,-16
 756:	e422                	sd	s0,8(sp)
 758:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75e:	00000797          	auipc	a5,0x0
 762:	1c27b783          	ld	a5,450(a5) # 920 <freep>
 766:	a805                	j	796 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 768:	4618                	lw	a4,8(a2)
 76a:	9db9                	addw	a1,a1,a4
 76c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 770:	6398                	ld	a4,0(a5)
 772:	6318                	ld	a4,0(a4)
 774:	fee53823          	sd	a4,-16(a0)
 778:	a091                	j	7bc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 77a:	ff852703          	lw	a4,-8(a0)
 77e:	9e39                	addw	a2,a2,a4
 780:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 782:	ff053703          	ld	a4,-16(a0)
 786:	e398                	sd	a4,0(a5)
 788:	a099                	j	7ce <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78a:	6398                	ld	a4,0(a5)
 78c:	00e7e463          	bltu	a5,a4,794 <free+0x40>
 790:	00e6ea63          	bltu	a3,a4,7a4 <free+0x50>
{
 794:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 796:	fed7fae3          	bgeu	a5,a3,78a <free+0x36>
 79a:	6398                	ld	a4,0(a5)
 79c:	00e6e463          	bltu	a3,a4,7a4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a0:	fee7eae3          	bltu	a5,a4,794 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7a4:	ff852583          	lw	a1,-8(a0)
 7a8:	6390                	ld	a2,0(a5)
 7aa:	02059713          	slli	a4,a1,0x20
 7ae:	9301                	srli	a4,a4,0x20
 7b0:	0712                	slli	a4,a4,0x4
 7b2:	9736                	add	a4,a4,a3
 7b4:	fae60ae3          	beq	a2,a4,768 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7b8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7bc:	4790                	lw	a2,8(a5)
 7be:	02061713          	slli	a4,a2,0x20
 7c2:	9301                	srli	a4,a4,0x20
 7c4:	0712                	slli	a4,a4,0x4
 7c6:	973e                	add	a4,a4,a5
 7c8:	fae689e3          	beq	a3,a4,77a <free+0x26>
  } else
    p->s.ptr = bp;
 7cc:	e394                	sd	a3,0(a5)
  freep = p;
 7ce:	00000717          	auipc	a4,0x0
 7d2:	14f73923          	sd	a5,338(a4) # 920 <freep>
}
 7d6:	6422                	ld	s0,8(sp)
 7d8:	0141                	addi	sp,sp,16
 7da:	8082                	ret

00000000000007dc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7dc:	7139                	addi	sp,sp,-64
 7de:	fc06                	sd	ra,56(sp)
 7e0:	f822                	sd	s0,48(sp)
 7e2:	f426                	sd	s1,40(sp)
 7e4:	f04a                	sd	s2,32(sp)
 7e6:	ec4e                	sd	s3,24(sp)
 7e8:	e852                	sd	s4,16(sp)
 7ea:	e456                	sd	s5,8(sp)
 7ec:	e05a                	sd	s6,0(sp)
 7ee:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f0:	02051493          	slli	s1,a0,0x20
 7f4:	9081                	srli	s1,s1,0x20
 7f6:	04bd                	addi	s1,s1,15
 7f8:	8091                	srli	s1,s1,0x4
 7fa:	0014899b          	addiw	s3,s1,1
 7fe:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 800:	00000517          	auipc	a0,0x0
 804:	12053503          	ld	a0,288(a0) # 920 <freep>
 808:	c515                	beqz	a0,834 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80c:	4798                	lw	a4,8(a5)
 80e:	02977f63          	bgeu	a4,s1,84c <malloc+0x70>
 812:	8a4e                	mv	s4,s3
 814:	0009871b          	sext.w	a4,s3
 818:	6685                	lui	a3,0x1
 81a:	00d77363          	bgeu	a4,a3,820 <malloc+0x44>
 81e:	6a05                	lui	s4,0x1
 820:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 824:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 828:	00000917          	auipc	s2,0x0
 82c:	0f890913          	addi	s2,s2,248 # 920 <freep>
  if(p == (char*)-1)
 830:	5afd                	li	s5,-1
 832:	a88d                	j	8a4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 834:	00000797          	auipc	a5,0x0
 838:	10c78793          	addi	a5,a5,268 # 940 <base>
 83c:	00000717          	auipc	a4,0x0
 840:	0ef73223          	sd	a5,228(a4) # 920 <freep>
 844:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 846:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 84a:	b7e1                	j	812 <malloc+0x36>
      if(p->s.size == nunits)
 84c:	02e48b63          	beq	s1,a4,882 <malloc+0xa6>
        p->s.size -= nunits;
 850:	4137073b          	subw	a4,a4,s3
 854:	c798                	sw	a4,8(a5)
        p += p->s.size;
 856:	1702                	slli	a4,a4,0x20
 858:	9301                	srli	a4,a4,0x20
 85a:	0712                	slli	a4,a4,0x4
 85c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 85e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 862:	00000717          	auipc	a4,0x0
 866:	0aa73f23          	sd	a0,190(a4) # 920 <freep>
      return (void*)(p + 1);
 86a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 86e:	70e2                	ld	ra,56(sp)
 870:	7442                	ld	s0,48(sp)
 872:	74a2                	ld	s1,40(sp)
 874:	7902                	ld	s2,32(sp)
 876:	69e2                	ld	s3,24(sp)
 878:	6a42                	ld	s4,16(sp)
 87a:	6aa2                	ld	s5,8(sp)
 87c:	6b02                	ld	s6,0(sp)
 87e:	6121                	addi	sp,sp,64
 880:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 882:	6398                	ld	a4,0(a5)
 884:	e118                	sd	a4,0(a0)
 886:	bff1                	j	862 <malloc+0x86>
  hp->s.size = nu;
 888:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 88c:	0541                	addi	a0,a0,16
 88e:	00000097          	auipc	ra,0x0
 892:	ec6080e7          	jalr	-314(ra) # 754 <free>
  return freep;
 896:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 89a:	d971                	beqz	a0,86e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89e:	4798                	lw	a4,8(a5)
 8a0:	fa9776e3          	bgeu	a4,s1,84c <malloc+0x70>
    if(p == freep)
 8a4:	00093703          	ld	a4,0(s2)
 8a8:	853e                	mv	a0,a5
 8aa:	fef719e3          	bne	a4,a5,89c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8ae:	8552                	mv	a0,s4
 8b0:	00000097          	auipc	ra,0x0
 8b4:	b16080e7          	jalr	-1258(ra) # 3c6 <sbrk>
  if(p == (char*)-1)
 8b8:	fd5518e3          	bne	a0,s5,888 <malloc+0xac>
        return 0;
 8bc:	4501                	li	a0,0
 8be:	bf45                	j	86e <malloc+0x92>
