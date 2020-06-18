
user/_echo:     file format elf64-littleriscv


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
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i;

  for(i = 1; i < argc; i++){
  10:	4785                	li	a5,1
  12:	06a7d463          	bge	a5,a0,7a <main+0x7a>
  16:	00858493          	addi	s1,a1,8
  1a:	ffe5099b          	addiw	s3,a0,-2
  1e:	1982                	slli	s3,s3,0x20
  20:	0209d993          	srli	s3,s3,0x20
  24:	098e                	slli	s3,s3,0x3
  26:	05c1                	addi	a1,a1,16
  28:	99ae                	add	s3,s3,a1
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  2a:	00001a17          	auipc	s4,0x1
  2e:	8a6a0a13          	addi	s4,s4,-1882 # 8d0 <malloc+0xe8>
    write(1, argv[i], strlen(argv[i]));
  32:	0004b903          	ld	s2,0(s1)
  36:	854a                	mv	a0,s2
  38:	00000097          	auipc	ra,0x0
  3c:	094080e7          	jalr	148(ra) # cc <strlen>
  40:	0005061b          	sext.w	a2,a0
  44:	85ca                	mv	a1,s2
  46:	4505                	li	a0,1
  48:	00000097          	auipc	ra,0x0
  4c:	322080e7          	jalr	802(ra) # 36a <write>
    if(i + 1 < argc){
  50:	04a1                	addi	s1,s1,8
  52:	01348a63          	beq	s1,s3,66 <main+0x66>
      write(1, " ", 1);
  56:	4605                	li	a2,1
  58:	85d2                	mv	a1,s4
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	30e080e7          	jalr	782(ra) # 36a <write>
  for(i = 1; i < argc; i++){
  64:	b7f9                	j	32 <main+0x32>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00001597          	auipc	a1,0x1
  6c:	87058593          	addi	a1,a1,-1936 # 8d8 <malloc+0xf0>
  70:	4505                	li	a0,1
  72:	00000097          	auipc	ra,0x0
  76:	2f8080e7          	jalr	760(ra) # 36a <write>
    }
  }
  exit(0);
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	2ce080e7          	jalr	718(ra) # 34a <exit>

0000000000000084 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8a:	87aa                	mv	a5,a0
  8c:	0585                	addi	a1,a1,1
  8e:	0785                	addi	a5,a5,1
  90:	fff5c703          	lbu	a4,-1(a1)
  94:	fee78fa3          	sb	a4,-1(a5)
  98:	fb75                	bnez	a4,8c <strcpy+0x8>
    ;
  return os;
}
  9a:	6422                	ld	s0,8(sp)
  9c:	0141                	addi	sp,sp,16
  9e:	8082                	ret

00000000000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a6:	00054783          	lbu	a5,0(a0)
  aa:	cb91                	beqz	a5,be <strcmp+0x1e>
  ac:	0005c703          	lbu	a4,0(a1)
  b0:	00f71763          	bne	a4,a5,be <strcmp+0x1e>
    p++, q++;
  b4:	0505                	addi	a0,a0,1
  b6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b8:	00054783          	lbu	a5,0(a0)
  bc:	fbe5                	bnez	a5,ac <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  be:	0005c503          	lbu	a0,0(a1)
}
  c2:	40a7853b          	subw	a0,a5,a0
  c6:	6422                	ld	s0,8(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret

00000000000000cc <strlen>:

uint
strlen(const char *s)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e422                	sd	s0,8(sp)
  d0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cf91                	beqz	a5,f2 <strlen+0x26>
  d8:	0505                	addi	a0,a0,1
  da:	87aa                	mv	a5,a0
  dc:	4685                	li	a3,1
  de:	9e89                	subw	a3,a3,a0
  e0:	00f6853b          	addw	a0,a3,a5
  e4:	0785                	addi	a5,a5,1
  e6:	fff7c703          	lbu	a4,-1(a5)
  ea:	fb7d                	bnez	a4,e0 <strlen+0x14>
    ;
  return n;
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret
  for(n = 0; s[n]; n++)
  f2:	4501                	li	a0,0
  f4:	bfe5                	j	ec <strlen+0x20>

00000000000000f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fc:	ce09                	beqz	a2,116 <memset+0x20>
  fe:	87aa                	mv	a5,a0
 100:	fff6071b          	addiw	a4,a2,-1
 104:	1702                	slli	a4,a4,0x20
 106:	9301                	srli	a4,a4,0x20
 108:	0705                	addi	a4,a4,1
 10a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 10c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 110:	0785                	addi	a5,a5,1
 112:	fee79de3          	bne	a5,a4,10c <memset+0x16>
  }
  return dst;
}
 116:	6422                	ld	s0,8(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strchr>:

char*
strchr(const char *s, char c)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e422                	sd	s0,8(sp)
 120:	0800                	addi	s0,sp,16
  for(; *s; s++)
 122:	00054783          	lbu	a5,0(a0)
 126:	cb99                	beqz	a5,13c <strchr+0x20>
    if(*s == c)
 128:	00f58763          	beq	a1,a5,136 <strchr+0x1a>
  for(; *s; s++)
 12c:	0505                	addi	a0,a0,1
 12e:	00054783          	lbu	a5,0(a0)
 132:	fbfd                	bnez	a5,128 <strchr+0xc>
      return (char*)s;
  return 0;
 134:	4501                	li	a0,0
}
 136:	6422                	ld	s0,8(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret
  return 0;
 13c:	4501                	li	a0,0
 13e:	bfe5                	j	136 <strchr+0x1a>

0000000000000140 <gets>:

char*
gets(char *buf, int max)
{
 140:	711d                	addi	sp,sp,-96
 142:	ec86                	sd	ra,88(sp)
 144:	e8a2                	sd	s0,80(sp)
 146:	e4a6                	sd	s1,72(sp)
 148:	e0ca                	sd	s2,64(sp)
 14a:	fc4e                	sd	s3,56(sp)
 14c:	f852                	sd	s4,48(sp)
 14e:	f456                	sd	s5,40(sp)
 150:	f05a                	sd	s6,32(sp)
 152:	ec5e                	sd	s7,24(sp)
 154:	1080                	addi	s0,sp,96
 156:	8baa                	mv	s7,a0
 158:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15a:	892a                	mv	s2,a0
 15c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 15e:	4aa9                	li	s5,10
 160:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 162:	89a6                	mv	s3,s1
 164:	2485                	addiw	s1,s1,1
 166:	0344d863          	bge	s1,s4,196 <gets+0x56>
    cc = read(0, &c, 1);
 16a:	4605                	li	a2,1
 16c:	faf40593          	addi	a1,s0,-81
 170:	4501                	li	a0,0
 172:	00000097          	auipc	ra,0x0
 176:	1f0080e7          	jalr	496(ra) # 362 <read>
    if(cc < 1)
 17a:	00a05e63          	blez	a0,196 <gets+0x56>
    buf[i++] = c;
 17e:	faf44783          	lbu	a5,-81(s0)
 182:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 186:	01578763          	beq	a5,s5,194 <gets+0x54>
 18a:	0905                	addi	s2,s2,1
 18c:	fd679be3          	bne	a5,s6,162 <gets+0x22>
  for(i=0; i+1 < max; ){
 190:	89a6                	mv	s3,s1
 192:	a011                	j	196 <gets+0x56>
 194:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 196:	99de                	add	s3,s3,s7
 198:	00098023          	sb	zero,0(s3)
  return buf;
}
 19c:	855e                	mv	a0,s7
 19e:	60e6                	ld	ra,88(sp)
 1a0:	6446                	ld	s0,80(sp)
 1a2:	64a6                	ld	s1,72(sp)
 1a4:	6906                	ld	s2,64(sp)
 1a6:	79e2                	ld	s3,56(sp)
 1a8:	7a42                	ld	s4,48(sp)
 1aa:	7aa2                	ld	s5,40(sp)
 1ac:	7b02                	ld	s6,32(sp)
 1ae:	6be2                	ld	s7,24(sp)
 1b0:	6125                	addi	sp,sp,96
 1b2:	8082                	ret

00000000000001b4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b4:	1101                	addi	sp,sp,-32
 1b6:	ec06                	sd	ra,24(sp)
 1b8:	e822                	sd	s0,16(sp)
 1ba:	e426                	sd	s1,8(sp)
 1bc:	e04a                	sd	s2,0(sp)
 1be:	1000                	addi	s0,sp,32
 1c0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c2:	4581                	li	a1,0
 1c4:	00000097          	auipc	ra,0x0
 1c8:	1c6080e7          	jalr	454(ra) # 38a <open>
  if(fd < 0)
 1cc:	02054563          	bltz	a0,1f6 <stat+0x42>
 1d0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d2:	85ca                	mv	a1,s2
 1d4:	00000097          	auipc	ra,0x0
 1d8:	1ce080e7          	jalr	462(ra) # 3a2 <fstat>
 1dc:	892a                	mv	s2,a0
  close(fd);
 1de:	8526                	mv	a0,s1
 1e0:	00000097          	auipc	ra,0x0
 1e4:	192080e7          	jalr	402(ra) # 372 <close>
  return r;
}
 1e8:	854a                	mv	a0,s2
 1ea:	60e2                	ld	ra,24(sp)
 1ec:	6442                	ld	s0,16(sp)
 1ee:	64a2                	ld	s1,8(sp)
 1f0:	6902                	ld	s2,0(sp)
 1f2:	6105                	addi	sp,sp,32
 1f4:	8082                	ret
    return -1;
 1f6:	597d                	li	s2,-1
 1f8:	bfc5                	j	1e8 <stat+0x34>

00000000000001fa <atoi>:

int
atoi(const char *s)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e422                	sd	s0,8(sp)
 1fe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 200:	00054603          	lbu	a2,0(a0)
 204:	fd06079b          	addiw	a5,a2,-48
 208:	0ff7f793          	andi	a5,a5,255
 20c:	4725                	li	a4,9
 20e:	02f76963          	bltu	a4,a5,240 <atoi+0x46>
 212:	86aa                	mv	a3,a0
  n = 0;
 214:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 216:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 218:	0685                	addi	a3,a3,1
 21a:	0025179b          	slliw	a5,a0,0x2
 21e:	9fa9                	addw	a5,a5,a0
 220:	0017979b          	slliw	a5,a5,0x1
 224:	9fb1                	addw	a5,a5,a2
 226:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 22a:	0006c603          	lbu	a2,0(a3)
 22e:	fd06071b          	addiw	a4,a2,-48
 232:	0ff77713          	andi	a4,a4,255
 236:	fee5f1e3          	bgeu	a1,a4,218 <atoi+0x1e>
  return n;
}
 23a:	6422                	ld	s0,8(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret
  n = 0;
 240:	4501                	li	a0,0
 242:	bfe5                	j	23a <atoi+0x40>

0000000000000244 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 24a:	02c05163          	blez	a2,26c <memmove+0x28>
 24e:	fff6071b          	addiw	a4,a2,-1
 252:	1702                	slli	a4,a4,0x20
 254:	9301                	srli	a4,a4,0x20
 256:	0705                	addi	a4,a4,1
 258:	972a                	add	a4,a4,a0
  dst = vdst;
 25a:	87aa                	mv	a5,a0
    *dst++ = *src++;
 25c:	0585                	addi	a1,a1,1
 25e:	0785                	addi	a5,a5,1
 260:	fff5c683          	lbu	a3,-1(a1)
 264:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 268:	fee79ae3          	bne	a5,a4,25c <memmove+0x18>
  return vdst;
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret

0000000000000272 <lock_init>:

void lock_init(lock_t *l, char *name) {
 272:	1141                	addi	sp,sp,-16
 274:	e422                	sd	s0,8(sp)
 276:	0800                	addi	s0,sp,16
 l->name = name;
 278:	e10c                	sd	a1,0(a0)
 l->locked = 0;
 27a:	00052423          	sw	zero,8(a0)
 //l->guard = 0;
}
 27e:	6422                	ld	s0,8(sp)
 280:	0141                	addi	sp,sp,16
 282:	8082                	ret

0000000000000284 <lock_acquire>:

void lock_acquire(lock_t *l) {
 284:	1141                	addi	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	addi	s0,sp,16
  while(__sync_lock_test_and_set(&l->locked, 1) != 0)
 28a:	4705                	li	a4,1
 28c:	87ba                	mv	a5,a4
 28e:	00850693          	addi	a3,a0,8
 292:	0cf6a7af          	amoswap.w.aq	a5,a5,(a3)
 296:	2781                	sext.w	a5,a5
 298:	fbf5                	bnez	a5,28c <lock_acquire+0x8>
    ;
  __sync_synchronize();
 29a:	0ff0000f          	fence
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret

00000000000002a4 <lock_release>:

void lock_release(lock_t *l) {
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  __sync_synchronize();
 2aa:	0ff0000f          	fence
  __sync_lock_release(&l->locked);
 2ae:	00850793          	addi	a5,a0,8
 2b2:	0f50000f          	fence	iorw,ow
 2b6:	0807a02f          	amoswap.w	zero,zero,(a5)
//  l->locked = 0;
}
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret

00000000000002c0 <thread_create>:
//    condwakeup(cond->curr);
//  }
//}
int
thread_create(void (*start_routine)(void*, void*), void *arg1, void *arg2)
{
 2c0:	7179                	addi	sp,sp,-48
 2c2:	f406                	sd	ra,40(sp)
 2c4:	f022                	sd	s0,32(sp)
 2c6:	ec26                	sd	s1,24(sp)
 2c8:	e84a                	sd	s2,16(sp)
 2ca:	e44e                	sd	s3,8(sp)
 2cc:	1800                	addi	s0,sp,48
 2ce:	84aa                	mv	s1,a0
 2d0:	892e                	mv	s2,a1
 2d2:	89b2                	mv	s3,a2
  void *stack = malloc(PGSIZE*2); //allocate space on the heap, should be 1 page in size and pagesize aligned
 2d4:	6509                	lui	a0,0x2
 2d6:	00000097          	auipc	ra,0x0
 2da:	512080e7          	jalr	1298(ra) # 7e8 <malloc>
 2de:	86aa                	mv	a3,a0
  if((uint64)stack % PGSIZE) { //not aligned
 2e0:	03451793          	slli	a5,a0,0x34
 2e4:	c799                	beqz	a5,2f2 <thread_create+0x32>
 2e6:	0347d713          	srli	a4,a5,0x34
    stack = stack + (PGSIZE - (uint64)stack % PGSIZE); //make is pagesize aligned
 2ea:	6785                	lui	a5,0x1
 2ec:	8f99                	sub	a5,a5,a4
 2ee:	00f506b3          	add	a3,a0,a5
  }
  int pid = clone(start_routine, arg1, arg2, stack);
 2f2:	864e                	mv	a2,s3
 2f4:	85ca                	mv	a1,s2
 2f6:	8526                	mv	a0,s1
 2f8:	00000097          	auipc	ra,0x0
 2fc:	0f2080e7          	jalr	242(ra) # 3ea <clone>
  return pid;
}
 300:	70a2                	ld	ra,40(sp)
 302:	7402                	ld	s0,32(sp)
 304:	64e2                	ld	s1,24(sp)
 306:	6942                	ld	s2,16(sp)
 308:	69a2                	ld	s3,8(sp)
 30a:	6145                	addi	sp,sp,48
 30c:	8082                	ret

000000000000030e <thread_join>:

int thread_join() {
 30e:	7179                	addi	sp,sp,-48
 310:	f406                	sd	ra,40(sp)
 312:	f022                	sd	s0,32(sp)
 314:	ec26                	sd	s1,24(sp)
 316:	1800                	addi	s0,sp,48
  void *ustack = 0;
 318:	fc043c23          	sd	zero,-40(s0)
  int status = join(&ustack);
 31c:	fd840513          	addi	a0,s0,-40
 320:	00000097          	auipc	ra,0x0
 324:	0d2080e7          	jalr	210(ra) # 3f2 <join>
 328:	84aa                	mv	s1,a0
  free(ustack);
 32a:	fd843503          	ld	a0,-40(s0)
 32e:	00000097          	auipc	ra,0x0
 332:	432080e7          	jalr	1074(ra) # 760 <free>
  return status;
}
 336:	8526                	mv	a0,s1
 338:	70a2                	ld	ra,40(sp)
 33a:	7402                	ld	s0,32(sp)
 33c:	64e2                	ld	s1,24(sp)
 33e:	6145                	addi	sp,sp,48
 340:	8082                	ret

0000000000000342 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 342:	4885                	li	a7,1
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <exit>:
.global exit
exit:
 li a7, SYS_exit
 34a:	4889                	li	a7,2
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <wait>:
.global wait
wait:
 li a7, SYS_wait
 352:	488d                	li	a7,3
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 35a:	4891                	li	a7,4
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <read>:
.global read
read:
 li a7, SYS_read
 362:	4895                	li	a7,5
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <write>:
.global write
write:
 li a7, SYS_write
 36a:	48c1                	li	a7,16
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <close>:
.global close
close:
 li a7, SYS_close
 372:	48d5                	li	a7,21
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <kill>:
.global kill
kill:
 li a7, SYS_kill
 37a:	4899                	li	a7,6
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <exec>:
.global exec
exec:
 li a7, SYS_exec
 382:	489d                	li	a7,7
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <open>:
.global open
open:
 li a7, SYS_open
 38a:	48bd                	li	a7,15
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 392:	48c5                	li	a7,17
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 39a:	48c9                	li	a7,18
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a2:	48a1                	li	a7,8
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <link>:
.global link
link:
 li a7, SYS_link
 3aa:	48cd                	li	a7,19
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b2:	48d1                	li	a7,20
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ba:	48a5                	li	a7,9
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c2:	48a9                	li	a7,10
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ca:	48ad                	li	a7,11
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d2:	48b1                	li	a7,12
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3da:	48b5                	li	a7,13
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e2:	48b9                	li	a7,14
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <clone>:
.global clone
clone:
 li a7, SYS_clone
 3ea:	48d9                	li	a7,22
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <join>:
.global join
join:
 li a7, SYS_join
 3f2:	48dd                	li	a7,23
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <putc>:
  int type;
};

static void
putc(int fd, char c)
{
 3fa:	1101                	addi	sp,sp,-32
 3fc:	ec06                	sd	ra,24(sp)
 3fe:	e822                	sd	s0,16(sp)
 400:	1000                	addi	s0,sp,32
 402:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 406:	4605                	li	a2,1
 408:	fef40593          	addi	a1,s0,-17
 40c:	00000097          	auipc	ra,0x0
 410:	f5e080e7          	jalr	-162(ra) # 36a <write>
}
 414:	60e2                	ld	ra,24(sp)
 416:	6442                	ld	s0,16(sp)
 418:	6105                	addi	sp,sp,32
 41a:	8082                	ret

000000000000041c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41c:	7139                	addi	sp,sp,-64
 41e:	fc06                	sd	ra,56(sp)
 420:	f822                	sd	s0,48(sp)
 422:	f426                	sd	s1,40(sp)
 424:	f04a                	sd	s2,32(sp)
 426:	ec4e                	sd	s3,24(sp)
 428:	0080                	addi	s0,sp,64
 42a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 42c:	c299                	beqz	a3,432 <printint+0x16>
 42e:	0805c863          	bltz	a1,4be <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 432:	2581                	sext.w	a1,a1
  neg = 0;
 434:	4881                	li	a7,0
 436:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 43a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 43c:	2601                	sext.w	a2,a2
 43e:	00000517          	auipc	a0,0x0
 442:	4b250513          	addi	a0,a0,1202 # 8f0 <digits>
 446:	883a                	mv	a6,a4
 448:	2705                	addiw	a4,a4,1
 44a:	02c5f7bb          	remuw	a5,a1,a2
 44e:	1782                	slli	a5,a5,0x20
 450:	9381                	srli	a5,a5,0x20
 452:	97aa                	add	a5,a5,a0
 454:	0007c783          	lbu	a5,0(a5) # 1000 <__BSS_END__+0x6c8>
 458:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 45c:	0005879b          	sext.w	a5,a1
 460:	02c5d5bb          	divuw	a1,a1,a2
 464:	0685                	addi	a3,a3,1
 466:	fec7f0e3          	bgeu	a5,a2,446 <printint+0x2a>
  if(neg)
 46a:	00088b63          	beqz	a7,480 <printint+0x64>
    buf[i++] = '-';
 46e:	fd040793          	addi	a5,s0,-48
 472:	973e                	add	a4,a4,a5
 474:	02d00793          	li	a5,45
 478:	fef70823          	sb	a5,-16(a4)
 47c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 480:	02e05863          	blez	a4,4b0 <printint+0x94>
 484:	fc040793          	addi	a5,s0,-64
 488:	00e78933          	add	s2,a5,a4
 48c:	fff78993          	addi	s3,a5,-1
 490:	99ba                	add	s3,s3,a4
 492:	377d                	addiw	a4,a4,-1
 494:	1702                	slli	a4,a4,0x20
 496:	9301                	srli	a4,a4,0x20
 498:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 49c:	fff94583          	lbu	a1,-1(s2)
 4a0:	8526                	mv	a0,s1
 4a2:	00000097          	auipc	ra,0x0
 4a6:	f58080e7          	jalr	-168(ra) # 3fa <putc>
  while(--i >= 0)
 4aa:	197d                	addi	s2,s2,-1
 4ac:	ff3918e3          	bne	s2,s3,49c <printint+0x80>
}
 4b0:	70e2                	ld	ra,56(sp)
 4b2:	7442                	ld	s0,48(sp)
 4b4:	74a2                	ld	s1,40(sp)
 4b6:	7902                	ld	s2,32(sp)
 4b8:	69e2                	ld	s3,24(sp)
 4ba:	6121                	addi	sp,sp,64
 4bc:	8082                	ret
    x = -xx;
 4be:	40b005bb          	negw	a1,a1
    neg = 1;
 4c2:	4885                	li	a7,1
    x = -xx;
 4c4:	bf8d                	j	436 <printint+0x1a>

00000000000004c6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c6:	7119                	addi	sp,sp,-128
 4c8:	fc86                	sd	ra,120(sp)
 4ca:	f8a2                	sd	s0,112(sp)
 4cc:	f4a6                	sd	s1,104(sp)
 4ce:	f0ca                	sd	s2,96(sp)
 4d0:	ecce                	sd	s3,88(sp)
 4d2:	e8d2                	sd	s4,80(sp)
 4d4:	e4d6                	sd	s5,72(sp)
 4d6:	e0da                	sd	s6,64(sp)
 4d8:	fc5e                	sd	s7,56(sp)
 4da:	f862                	sd	s8,48(sp)
 4dc:	f466                	sd	s9,40(sp)
 4de:	f06a                	sd	s10,32(sp)
 4e0:	ec6e                	sd	s11,24(sp)
 4e2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4e4:	0005c903          	lbu	s2,0(a1)
 4e8:	18090f63          	beqz	s2,686 <vprintf+0x1c0>
 4ec:	8aaa                	mv	s5,a0
 4ee:	8b32                	mv	s6,a2
 4f0:	00158493          	addi	s1,a1,1
  state = 0;
 4f4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4f6:	02500a13          	li	s4,37
      if(c == 'd'){
 4fa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4fe:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 502:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 506:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 50a:	00000b97          	auipc	s7,0x0
 50e:	3e6b8b93          	addi	s7,s7,998 # 8f0 <digits>
 512:	a839                	j	530 <vprintf+0x6a>
        putc(fd, c);
 514:	85ca                	mv	a1,s2
 516:	8556                	mv	a0,s5
 518:	00000097          	auipc	ra,0x0
 51c:	ee2080e7          	jalr	-286(ra) # 3fa <putc>
 520:	a019                	j	526 <vprintf+0x60>
    } else if(state == '%'){
 522:	01498f63          	beq	s3,s4,540 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 526:	0485                	addi	s1,s1,1
 528:	fff4c903          	lbu	s2,-1(s1)
 52c:	14090d63          	beqz	s2,686 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 530:	0009079b          	sext.w	a5,s2
    if(state == 0){
 534:	fe0997e3          	bnez	s3,522 <vprintf+0x5c>
      if(c == '%'){
 538:	fd479ee3          	bne	a5,s4,514 <vprintf+0x4e>
        state = '%';
 53c:	89be                	mv	s3,a5
 53e:	b7e5                	j	526 <vprintf+0x60>
      if(c == 'd'){
 540:	05878063          	beq	a5,s8,580 <vprintf+0xba>
      } else if(c == 'l') {
 544:	05978c63          	beq	a5,s9,59c <vprintf+0xd6>
      } else if(c == 'x') {
 548:	07a78863          	beq	a5,s10,5b8 <vprintf+0xf2>
      } else if(c == 'p') {
 54c:	09b78463          	beq	a5,s11,5d4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 550:	07300713          	li	a4,115
 554:	0ce78663          	beq	a5,a4,620 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 558:	06300713          	li	a4,99
 55c:	0ee78e63          	beq	a5,a4,658 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 560:	11478863          	beq	a5,s4,670 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 564:	85d2                	mv	a1,s4
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	e92080e7          	jalr	-366(ra) # 3fa <putc>
        putc(fd, c);
 570:	85ca                	mv	a1,s2
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	e86080e7          	jalr	-378(ra) # 3fa <putc>
      }
      state = 0;
 57c:	4981                	li	s3,0
 57e:	b765                	j	526 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 580:	008b0913          	addi	s2,s6,8
 584:	4685                	li	a3,1
 586:	4629                	li	a2,10
 588:	000b2583          	lw	a1,0(s6)
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	e8e080e7          	jalr	-370(ra) # 41c <printint>
 596:	8b4a                	mv	s6,s2
      state = 0;
 598:	4981                	li	s3,0
 59a:	b771                	j	526 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59c:	008b0913          	addi	s2,s6,8
 5a0:	4681                	li	a3,0
 5a2:	4629                	li	a2,10
 5a4:	000b2583          	lw	a1,0(s6)
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	e72080e7          	jalr	-398(ra) # 41c <printint>
 5b2:	8b4a                	mv	s6,s2
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	bf85                	j	526 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5b8:	008b0913          	addi	s2,s6,8
 5bc:	4681                	li	a3,0
 5be:	4641                	li	a2,16
 5c0:	000b2583          	lw	a1,0(s6)
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	e56080e7          	jalr	-426(ra) # 41c <printint>
 5ce:	8b4a                	mv	s6,s2
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	bf91                	j	526 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5d4:	008b0793          	addi	a5,s6,8
 5d8:	f8f43423          	sd	a5,-120(s0)
 5dc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5e0:	03000593          	li	a1,48
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e14080e7          	jalr	-492(ra) # 3fa <putc>
  putc(fd, 'x');
 5ee:	85ea                	mv	a1,s10
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	e08080e7          	jalr	-504(ra) # 3fa <putc>
 5fa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fc:	03c9d793          	srli	a5,s3,0x3c
 600:	97de                	add	a5,a5,s7
 602:	0007c583          	lbu	a1,0(a5)
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	df2080e7          	jalr	-526(ra) # 3fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 610:	0992                	slli	s3,s3,0x4
 612:	397d                	addiw	s2,s2,-1
 614:	fe0914e3          	bnez	s2,5fc <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 618:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b721                	j	526 <vprintf+0x60>
        s = va_arg(ap, char*);
 620:	008b0993          	addi	s3,s6,8
 624:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 628:	02090163          	beqz	s2,64a <vprintf+0x184>
        while(*s != 0){
 62c:	00094583          	lbu	a1,0(s2)
 630:	c9a1                	beqz	a1,680 <vprintf+0x1ba>
          putc(fd, *s);
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	dc6080e7          	jalr	-570(ra) # 3fa <putc>
          s++;
 63c:	0905                	addi	s2,s2,1
        while(*s != 0){
 63e:	00094583          	lbu	a1,0(s2)
 642:	f9e5                	bnez	a1,632 <vprintf+0x16c>
        s = va_arg(ap, char*);
 644:	8b4e                	mv	s6,s3
      state = 0;
 646:	4981                	li	s3,0
 648:	bdf9                	j	526 <vprintf+0x60>
          s = "(null)";
 64a:	00000917          	auipc	s2,0x0
 64e:	29690913          	addi	s2,s2,662 # 8e0 <malloc+0xf8>
        while(*s != 0){
 652:	02800593          	li	a1,40
 656:	bff1                	j	632 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 658:	008b0913          	addi	s2,s6,8
 65c:	000b4583          	lbu	a1,0(s6)
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	d98080e7          	jalr	-616(ra) # 3fa <putc>
 66a:	8b4a                	mv	s6,s2
      state = 0;
 66c:	4981                	li	s3,0
 66e:	bd65                	j	526 <vprintf+0x60>
        putc(fd, c);
 670:	85d2                	mv	a1,s4
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	d86080e7          	jalr	-634(ra) # 3fa <putc>
      state = 0;
 67c:	4981                	li	s3,0
 67e:	b565                	j	526 <vprintf+0x60>
        s = va_arg(ap, char*);
 680:	8b4e                	mv	s6,s3
      state = 0;
 682:	4981                	li	s3,0
 684:	b54d                	j	526 <vprintf+0x60>
    }
  }
}
 686:	70e6                	ld	ra,120(sp)
 688:	7446                	ld	s0,112(sp)
 68a:	74a6                	ld	s1,104(sp)
 68c:	7906                	ld	s2,96(sp)
 68e:	69e6                	ld	s3,88(sp)
 690:	6a46                	ld	s4,80(sp)
 692:	6aa6                	ld	s5,72(sp)
 694:	6b06                	ld	s6,64(sp)
 696:	7be2                	ld	s7,56(sp)
 698:	7c42                	ld	s8,48(sp)
 69a:	7ca2                	ld	s9,40(sp)
 69c:	7d02                	ld	s10,32(sp)
 69e:	6de2                	ld	s11,24(sp)
 6a0:	6109                	addi	sp,sp,128
 6a2:	8082                	ret

00000000000006a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6a4:	715d                	addi	sp,sp,-80
 6a6:	ec06                	sd	ra,24(sp)
 6a8:	e822                	sd	s0,16(sp)
 6aa:	1000                	addi	s0,sp,32
 6ac:	e010                	sd	a2,0(s0)
 6ae:	e414                	sd	a3,8(s0)
 6b0:	e818                	sd	a4,16(s0)
 6b2:	ec1c                	sd	a5,24(s0)
 6b4:	03043023          	sd	a6,32(s0)
 6b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6c0:	8622                	mv	a2,s0
 6c2:	00000097          	auipc	ra,0x0
 6c6:	e04080e7          	jalr	-508(ra) # 4c6 <vprintf>
}
 6ca:	60e2                	ld	ra,24(sp)
 6cc:	6442                	ld	s0,16(sp)
 6ce:	6161                	addi	sp,sp,80
 6d0:	8082                	ret

00000000000006d2 <printf>:

void
printf(const char *fmt, ...)
{
 6d2:	7159                	addi	sp,sp,-112
 6d4:	f406                	sd	ra,40(sp)
 6d6:	f022                	sd	s0,32(sp)
 6d8:	ec26                	sd	s1,24(sp)
 6da:	e84a                	sd	s2,16(sp)
 6dc:	1800                	addi	s0,sp,48
 6de:	84aa                	mv	s1,a0
 6e0:	e40c                	sd	a1,8(s0)
 6e2:	e810                	sd	a2,16(s0)
 6e4:	ec14                	sd	a3,24(s0)
 6e6:	f018                	sd	a4,32(s0)
 6e8:	f41c                	sd	a5,40(s0)
 6ea:	03043823          	sd	a6,48(s0)
 6ee:	03143c23          	sd	a7,56(s0)
  va_list ap;
  lock_acquire(&pr.printf_lock);
 6f2:	00000917          	auipc	s2,0x0
 6f6:	21e90913          	addi	s2,s2,542 # 910 <pr>
 6fa:	854a                	mv	a0,s2
 6fc:	00000097          	auipc	ra,0x0
 700:	b88080e7          	jalr	-1144(ra) # 284 <lock_acquire>

  va_start(ap, fmt);
 704:	00840613          	addi	a2,s0,8
 708:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 70c:	85a6                	mv	a1,s1
 70e:	4505                	li	a0,1
 710:	00000097          	auipc	ra,0x0
 714:	db6080e7          	jalr	-586(ra) # 4c6 <vprintf>
  
  lock_release(&pr.printf_lock);
 718:	854a                	mv	a0,s2
 71a:	00000097          	auipc	ra,0x0
 71e:	b8a080e7          	jalr	-1142(ra) # 2a4 <lock_release>

}
 722:	70a2                	ld	ra,40(sp)
 724:	7402                	ld	s0,32(sp)
 726:	64e2                	ld	s1,24(sp)
 728:	6942                	ld	s2,16(sp)
 72a:	6165                	addi	sp,sp,112
 72c:	8082                	ret

000000000000072e <printfinit>:

void
printfinit(void)
{
 72e:	1101                	addi	sp,sp,-32
 730:	ec06                	sd	ra,24(sp)
 732:	e822                	sd	s0,16(sp)
 734:	e426                	sd	s1,8(sp)
 736:	1000                	addi	s0,sp,32
  lock_init(&pr.printf_lock, "pr");
 738:	00000497          	auipc	s1,0x0
 73c:	1d848493          	addi	s1,s1,472 # 910 <pr>
 740:	00000597          	auipc	a1,0x0
 744:	1a858593          	addi	a1,a1,424 # 8e8 <malloc+0x100>
 748:	8526                	mv	a0,s1
 74a:	00000097          	auipc	ra,0x0
 74e:	b28080e7          	jalr	-1240(ra) # 272 <lock_init>
  pr.locking = 1;
 752:	4785                	li	a5,1
 754:	c89c                	sw	a5,16(s1)
}
 756:	60e2                	ld	ra,24(sp)
 758:	6442                	ld	s0,16(sp)
 75a:	64a2                	ld	s1,8(sp)
 75c:	6105                	addi	sp,sp,32
 75e:	8082                	ret

0000000000000760 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 760:	1141                	addi	sp,sp,-16
 762:	e422                	sd	s0,8(sp)
 764:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 766:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76a:	00000797          	auipc	a5,0x0
 76e:	19e7b783          	ld	a5,414(a5) # 908 <freep>
 772:	a805                	j	7a2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 774:	4618                	lw	a4,8(a2)
 776:	9db9                	addw	a1,a1,a4
 778:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 77c:	6398                	ld	a4,0(a5)
 77e:	6318                	ld	a4,0(a4)
 780:	fee53823          	sd	a4,-16(a0)
 784:	a091                	j	7c8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 786:	ff852703          	lw	a4,-8(a0)
 78a:	9e39                	addw	a2,a2,a4
 78c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 78e:	ff053703          	ld	a4,-16(a0)
 792:	e398                	sd	a4,0(a5)
 794:	a099                	j	7da <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 796:	6398                	ld	a4,0(a5)
 798:	00e7e463          	bltu	a5,a4,7a0 <free+0x40>
 79c:	00e6ea63          	bltu	a3,a4,7b0 <free+0x50>
{
 7a0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a2:	fed7fae3          	bgeu	a5,a3,796 <free+0x36>
 7a6:	6398                	ld	a4,0(a5)
 7a8:	00e6e463          	bltu	a3,a4,7b0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ac:	fee7eae3          	bltu	a5,a4,7a0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7b0:	ff852583          	lw	a1,-8(a0)
 7b4:	6390                	ld	a2,0(a5)
 7b6:	02059713          	slli	a4,a1,0x20
 7ba:	9301                	srli	a4,a4,0x20
 7bc:	0712                	slli	a4,a4,0x4
 7be:	9736                	add	a4,a4,a3
 7c0:	fae60ae3          	beq	a2,a4,774 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7c4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c8:	4790                	lw	a2,8(a5)
 7ca:	02061713          	slli	a4,a2,0x20
 7ce:	9301                	srli	a4,a4,0x20
 7d0:	0712                	slli	a4,a4,0x4
 7d2:	973e                	add	a4,a4,a5
 7d4:	fae689e3          	beq	a3,a4,786 <free+0x26>
  } else
    p->s.ptr = bp;
 7d8:	e394                	sd	a3,0(a5)
  freep = p;
 7da:	00000717          	auipc	a4,0x0
 7de:	12f73723          	sd	a5,302(a4) # 908 <freep>
}
 7e2:	6422                	ld	s0,8(sp)
 7e4:	0141                	addi	sp,sp,16
 7e6:	8082                	ret

00000000000007e8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e8:	7139                	addi	sp,sp,-64
 7ea:	fc06                	sd	ra,56(sp)
 7ec:	f822                	sd	s0,48(sp)
 7ee:	f426                	sd	s1,40(sp)
 7f0:	f04a                	sd	s2,32(sp)
 7f2:	ec4e                	sd	s3,24(sp)
 7f4:	e852                	sd	s4,16(sp)
 7f6:	e456                	sd	s5,8(sp)
 7f8:	e05a                	sd	s6,0(sp)
 7fa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fc:	02051493          	slli	s1,a0,0x20
 800:	9081                	srli	s1,s1,0x20
 802:	04bd                	addi	s1,s1,15
 804:	8091                	srli	s1,s1,0x4
 806:	0014899b          	addiw	s3,s1,1
 80a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 80c:	00000517          	auipc	a0,0x0
 810:	0fc53503          	ld	a0,252(a0) # 908 <freep>
 814:	c515                	beqz	a0,840 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 816:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 818:	4798                	lw	a4,8(a5)
 81a:	02977f63          	bgeu	a4,s1,858 <malloc+0x70>
 81e:	8a4e                	mv	s4,s3
 820:	0009871b          	sext.w	a4,s3
 824:	6685                	lui	a3,0x1
 826:	00d77363          	bgeu	a4,a3,82c <malloc+0x44>
 82a:	6a05                	lui	s4,0x1
 82c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 830:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 834:	00000917          	auipc	s2,0x0
 838:	0d490913          	addi	s2,s2,212 # 908 <freep>
  if(p == (char*)-1)
 83c:	5afd                	li	s5,-1
 83e:	a88d                	j	8b0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 840:	00000797          	auipc	a5,0x0
 844:	0e878793          	addi	a5,a5,232 # 928 <base>
 848:	00000717          	auipc	a4,0x0
 84c:	0cf73023          	sd	a5,192(a4) # 908 <freep>
 850:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 852:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 856:	b7e1                	j	81e <malloc+0x36>
      if(p->s.size == nunits)
 858:	02e48b63          	beq	s1,a4,88e <malloc+0xa6>
        p->s.size -= nunits;
 85c:	4137073b          	subw	a4,a4,s3
 860:	c798                	sw	a4,8(a5)
        p += p->s.size;
 862:	1702                	slli	a4,a4,0x20
 864:	9301                	srli	a4,a4,0x20
 866:	0712                	slli	a4,a4,0x4
 868:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 86a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 86e:	00000717          	auipc	a4,0x0
 872:	08a73d23          	sd	a0,154(a4) # 908 <freep>
      return (void*)(p + 1);
 876:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 87a:	70e2                	ld	ra,56(sp)
 87c:	7442                	ld	s0,48(sp)
 87e:	74a2                	ld	s1,40(sp)
 880:	7902                	ld	s2,32(sp)
 882:	69e2                	ld	s3,24(sp)
 884:	6a42                	ld	s4,16(sp)
 886:	6aa2                	ld	s5,8(sp)
 888:	6b02                	ld	s6,0(sp)
 88a:	6121                	addi	sp,sp,64
 88c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 88e:	6398                	ld	a4,0(a5)
 890:	e118                	sd	a4,0(a0)
 892:	bff1                	j	86e <malloc+0x86>
  hp->s.size = nu;
 894:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 898:	0541                	addi	a0,a0,16
 89a:	00000097          	auipc	ra,0x0
 89e:	ec6080e7          	jalr	-314(ra) # 760 <free>
  return freep;
 8a2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8a6:	d971                	beqz	a0,87a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8aa:	4798                	lw	a4,8(a5)
 8ac:	fa9776e3          	bgeu	a4,s1,858 <malloc+0x70>
    if(p == freep)
 8b0:	00093703          	ld	a4,0(s2)
 8b4:	853e                	mv	a0,a5
 8b6:	fef719e3          	bne	a4,a5,8a8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8ba:	8552                	mv	a0,s4
 8bc:	00000097          	auipc	ra,0x0
 8c0:	b16080e7          	jalr	-1258(ra) # 3d2 <sbrk>
  if(p == (char*)-1)
 8c4:	fd5518e3          	bne	a0,s5,894 <malloc+0xac>
        return 0;
 8c8:	4501                	li	a0,0
 8ca:	bf45                	j	87a <malloc+0x92>
