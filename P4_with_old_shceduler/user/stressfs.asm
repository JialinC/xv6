
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	97278793          	addi	a5,a5,-1678 # 988 <malloc+0x118>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	92c50513          	addi	a0,a0,-1748 # 958 <malloc+0xe8>
  34:	00000097          	auipc	ra,0x0
  38:	726080e7          	jalr	1830(ra) # 75a <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	136080e7          	jalr	310(ra) # 17e <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	376080e7          	jalr	886(ra) # 3ca <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	90850513          	addi	a0,a0,-1784 # 970 <malloc+0x100>
  70:	00000097          	auipc	ra,0x0
  74:	6ea080e7          	jalr	1770(ra) # 75a <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9cbd                	addw	s1,s1,a5
  7e:	fc940c23          	sb	s1,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	388080e7          	jalr	904(ra) # 412 <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	352080e7          	jalr	850(ra) # 3f2 <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	34c080e7          	jalr	844(ra) # 3fa <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	8ca50513          	addi	a0,a0,-1846 # 980 <malloc+0x110>
  be:	00000097          	auipc	ra,0x0
  c2:	69c080e7          	jalr	1692(ra) # 75a <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	346080e7          	jalr	838(ra) # 412 <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	308080e7          	jalr	776(ra) # 3ea <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	30a080e7          	jalr	778(ra) # 3fa <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2e0080e7          	jalr	736(ra) # 3da <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	2ce080e7          	jalr	718(ra) # 3d2 <exit>

000000000000010c <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 112:	87aa                	mv	a5,a0
 114:	0585                	addi	a1,a1,1
 116:	0785                	addi	a5,a5,1
 118:	fff5c703          	lbu	a4,-1(a1)
 11c:	fee78fa3          	sb	a4,-1(a5)
 120:	fb75                	bnez	a4,114 <strcpy+0x8>
    ;
  return os;
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb91                	beqz	a5,146 <strcmp+0x1e>
 134:	0005c703          	lbu	a4,0(a1)
 138:	00f71763          	bne	a4,a5,146 <strcmp+0x1e>
    p++, q++;
 13c:	0505                	addi	a0,a0,1
 13e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	fbe5                	bnez	a5,134 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 146:	0005c503          	lbu	a0,0(a1)
}
 14a:	40a7853b          	subw	a0,a5,a0
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret

0000000000000154 <strlen>:

uint
strlen(const char *s)
{
 154:	1141                	addi	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	cf91                	beqz	a5,17a <strlen+0x26>
 160:	0505                	addi	a0,a0,1
 162:	87aa                	mv	a5,a0
 164:	4685                	li	a3,1
 166:	9e89                	subw	a3,a3,a0
 168:	00f6853b          	addw	a0,a3,a5
 16c:	0785                	addi	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	fb7d                	bnez	a4,168 <strlen+0x14>
    ;
  return n;
}
 174:	6422                	ld	s0,8(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret
  for(n = 0; s[n]; n++)
 17a:	4501                	li	a0,0
 17c:	bfe5                	j	174 <strlen+0x20>

000000000000017e <memset>:

void*
memset(void *dst, int c, uint n)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 184:	ce09                	beqz	a2,19e <memset+0x20>
 186:	87aa                	mv	a5,a0
 188:	fff6071b          	addiw	a4,a2,-1
 18c:	1702                	slli	a4,a4,0x20
 18e:	9301                	srli	a4,a4,0x20
 190:	0705                	addi	a4,a4,1
 192:	972a                	add	a4,a4,a0
    cdst[i] = c;
 194:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 198:	0785                	addi	a5,a5,1
 19a:	fee79de3          	bne	a5,a4,194 <memset+0x16>
  }
  return dst;
}
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <strchr>:

char*
strchr(const char *s, char c)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cb99                	beqz	a5,1c4 <strchr+0x20>
    if(*s == c)
 1b0:	00f58763          	beq	a1,a5,1be <strchr+0x1a>
  for(; *s; s++)
 1b4:	0505                	addi	a0,a0,1
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	fbfd                	bnez	a5,1b0 <strchr+0xc>
      return (char*)s;
  return 0;
 1bc:	4501                	li	a0,0
}
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	addi	sp,sp,16
 1c2:	8082                	ret
  return 0;
 1c4:	4501                	li	a0,0
 1c6:	bfe5                	j	1be <strchr+0x1a>

00000000000001c8 <gets>:

char*
gets(char *buf, int max)
{
 1c8:	711d                	addi	sp,sp,-96
 1ca:	ec86                	sd	ra,88(sp)
 1cc:	e8a2                	sd	s0,80(sp)
 1ce:	e4a6                	sd	s1,72(sp)
 1d0:	e0ca                	sd	s2,64(sp)
 1d2:	fc4e                	sd	s3,56(sp)
 1d4:	f852                	sd	s4,48(sp)
 1d6:	f456                	sd	s5,40(sp)
 1d8:	f05a                	sd	s6,32(sp)
 1da:	ec5e                	sd	s7,24(sp)
 1dc:	1080                	addi	s0,sp,96
 1de:	8baa                	mv	s7,a0
 1e0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e2:	892a                	mv	s2,a0
 1e4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e6:	4aa9                	li	s5,10
 1e8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ea:	89a6                	mv	s3,s1
 1ec:	2485                	addiw	s1,s1,1
 1ee:	0344d863          	bge	s1,s4,21e <gets+0x56>
    cc = read(0, &c, 1);
 1f2:	4605                	li	a2,1
 1f4:	faf40593          	addi	a1,s0,-81
 1f8:	4501                	li	a0,0
 1fa:	00000097          	auipc	ra,0x0
 1fe:	1f0080e7          	jalr	496(ra) # 3ea <read>
    if(cc < 1)
 202:	00a05e63          	blez	a0,21e <gets+0x56>
    buf[i++] = c;
 206:	faf44783          	lbu	a5,-81(s0)
 20a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20e:	01578763          	beq	a5,s5,21c <gets+0x54>
 212:	0905                	addi	s2,s2,1
 214:	fd679be3          	bne	a5,s6,1ea <gets+0x22>
  for(i=0; i+1 < max; ){
 218:	89a6                	mv	s3,s1
 21a:	a011                	j	21e <gets+0x56>
 21c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 21e:	99de                	add	s3,s3,s7
 220:	00098023          	sb	zero,0(s3)
  return buf;
}
 224:	855e                	mv	a0,s7
 226:	60e6                	ld	ra,88(sp)
 228:	6446                	ld	s0,80(sp)
 22a:	64a6                	ld	s1,72(sp)
 22c:	6906                	ld	s2,64(sp)
 22e:	79e2                	ld	s3,56(sp)
 230:	7a42                	ld	s4,48(sp)
 232:	7aa2                	ld	s5,40(sp)
 234:	7b02                	ld	s6,32(sp)
 236:	6be2                	ld	s7,24(sp)
 238:	6125                	addi	sp,sp,96
 23a:	8082                	ret

000000000000023c <stat>:

int
stat(const char *n, struct stat *st)
{
 23c:	1101                	addi	sp,sp,-32
 23e:	ec06                	sd	ra,24(sp)
 240:	e822                	sd	s0,16(sp)
 242:	e426                	sd	s1,8(sp)
 244:	e04a                	sd	s2,0(sp)
 246:	1000                	addi	s0,sp,32
 248:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24a:	4581                	li	a1,0
 24c:	00000097          	auipc	ra,0x0
 250:	1c6080e7          	jalr	454(ra) # 412 <open>
  if(fd < 0)
 254:	02054563          	bltz	a0,27e <stat+0x42>
 258:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25a:	85ca                	mv	a1,s2
 25c:	00000097          	auipc	ra,0x0
 260:	1ce080e7          	jalr	462(ra) # 42a <fstat>
 264:	892a                	mv	s2,a0
  close(fd);
 266:	8526                	mv	a0,s1
 268:	00000097          	auipc	ra,0x0
 26c:	192080e7          	jalr	402(ra) # 3fa <close>
  return r;
}
 270:	854a                	mv	a0,s2
 272:	60e2                	ld	ra,24(sp)
 274:	6442                	ld	s0,16(sp)
 276:	64a2                	ld	s1,8(sp)
 278:	6902                	ld	s2,0(sp)
 27a:	6105                	addi	sp,sp,32
 27c:	8082                	ret
    return -1;
 27e:	597d                	li	s2,-1
 280:	bfc5                	j	270 <stat+0x34>

0000000000000282 <atoi>:

int
atoi(const char *s)
{
 282:	1141                	addi	sp,sp,-16
 284:	e422                	sd	s0,8(sp)
 286:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 288:	00054603          	lbu	a2,0(a0)
 28c:	fd06079b          	addiw	a5,a2,-48
 290:	0ff7f793          	andi	a5,a5,255
 294:	4725                	li	a4,9
 296:	02f76963          	bltu	a4,a5,2c8 <atoi+0x46>
 29a:	86aa                	mv	a3,a0
  n = 0;
 29c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 29e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2a0:	0685                	addi	a3,a3,1
 2a2:	0025179b          	slliw	a5,a0,0x2
 2a6:	9fa9                	addw	a5,a5,a0
 2a8:	0017979b          	slliw	a5,a5,0x1
 2ac:	9fb1                	addw	a5,a5,a2
 2ae:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b2:	0006c603          	lbu	a2,0(a3)
 2b6:	fd06071b          	addiw	a4,a2,-48
 2ba:	0ff77713          	andi	a4,a4,255
 2be:	fee5f1e3          	bgeu	a1,a4,2a0 <atoi+0x1e>
  return n;
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
  n = 0;
 2c8:	4501                	li	a0,0
 2ca:	bfe5                	j	2c2 <atoi+0x40>

00000000000002cc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d2:	02c05163          	blez	a2,2f4 <memmove+0x28>
 2d6:	fff6071b          	addiw	a4,a2,-1
 2da:	1702                	slli	a4,a4,0x20
 2dc:	9301                	srli	a4,a4,0x20
 2de:	0705                	addi	a4,a4,1
 2e0:	972a                	add	a4,a4,a0
  dst = vdst;
 2e2:	87aa                	mv	a5,a0
    *dst++ = *src++;
 2e4:	0585                	addi	a1,a1,1
 2e6:	0785                	addi	a5,a5,1
 2e8:	fff5c683          	lbu	a3,-1(a1)
 2ec:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 2f0:	fee79ae3          	bne	a5,a4,2e4 <memmove+0x18>
  return vdst;
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret

00000000000002fa <lock_init>:

void lock_init(lock_t *l, char *name) {
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e422                	sd	s0,8(sp)
 2fe:	0800                	addi	s0,sp,16
 l->name = name;
 300:	e10c                	sd	a1,0(a0)
 l->locked = 0;
 302:	00052423          	sw	zero,8(a0)
 //l->guard = 0;
}
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <lock_acquire>:

void lock_acquire(lock_t *l) {
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  while(__sync_lock_test_and_set(&l->locked, 1) != 0)
 312:	4705                	li	a4,1
 314:	87ba                	mv	a5,a4
 316:	00850693          	addi	a3,a0,8
 31a:	0cf6a7af          	amoswap.w.aq	a5,a5,(a3)
 31e:	2781                	sext.w	a5,a5
 320:	fbf5                	bnez	a5,314 <lock_acquire+0x8>
    ;
  __sync_synchronize();
 322:	0ff0000f          	fence
}
 326:	6422                	ld	s0,8(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret

000000000000032c <lock_release>:

void lock_release(lock_t *l) {
 32c:	1141                	addi	sp,sp,-16
 32e:	e422                	sd	s0,8(sp)
 330:	0800                	addi	s0,sp,16
  __sync_synchronize();
 332:	0ff0000f          	fence
  __sync_lock_release(&l->locked);
 336:	00850793          	addi	a5,a0,8
 33a:	0f50000f          	fence	iorw,ow
 33e:	0807a02f          	amoswap.w	zero,zero,(a5)
//  l->locked = 0;
}
 342:	6422                	ld	s0,8(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret

0000000000000348 <thread_create>:
//    condwakeup(cond->curr);
//  }
//}
int
thread_create(void (*start_routine)(void*, void*), void *arg1, void *arg2)
{
 348:	7179                	addi	sp,sp,-48
 34a:	f406                	sd	ra,40(sp)
 34c:	f022                	sd	s0,32(sp)
 34e:	ec26                	sd	s1,24(sp)
 350:	e84a                	sd	s2,16(sp)
 352:	e44e                	sd	s3,8(sp)
 354:	1800                	addi	s0,sp,48
 356:	84aa                	mv	s1,a0
 358:	892e                	mv	s2,a1
 35a:	89b2                	mv	s3,a2
  void *stack = malloc(PGSIZE*2); //allocate space on the heap, should be 1 page in size and pagesize aligned
 35c:	6509                	lui	a0,0x2
 35e:	00000097          	auipc	ra,0x0
 362:	512080e7          	jalr	1298(ra) # 870 <malloc>
 366:	86aa                	mv	a3,a0
  if((uint64)stack % PGSIZE) { //not aligned
 368:	03451793          	slli	a5,a0,0x34
 36c:	c799                	beqz	a5,37a <thread_create+0x32>
 36e:	0347d713          	srli	a4,a5,0x34
    stack = stack + (PGSIZE - (uint64)stack % PGSIZE); //make is pagesize aligned
 372:	6785                	lui	a5,0x1
 374:	8f99                	sub	a5,a5,a4
 376:	00f506b3          	add	a3,a0,a5
  }
  int pid = clone(start_routine, arg1, arg2, stack);
 37a:	864e                	mv	a2,s3
 37c:	85ca                	mv	a1,s2
 37e:	8526                	mv	a0,s1
 380:	00000097          	auipc	ra,0x0
 384:	0f2080e7          	jalr	242(ra) # 472 <clone>
  return pid;
}
 388:	70a2                	ld	ra,40(sp)
 38a:	7402                	ld	s0,32(sp)
 38c:	64e2                	ld	s1,24(sp)
 38e:	6942                	ld	s2,16(sp)
 390:	69a2                	ld	s3,8(sp)
 392:	6145                	addi	sp,sp,48
 394:	8082                	ret

0000000000000396 <thread_join>:

int thread_join() {
 396:	7179                	addi	sp,sp,-48
 398:	f406                	sd	ra,40(sp)
 39a:	f022                	sd	s0,32(sp)
 39c:	ec26                	sd	s1,24(sp)
 39e:	1800                	addi	s0,sp,48
  void *ustack = 0;
 3a0:	fc043c23          	sd	zero,-40(s0)
  int status = join(&ustack);
 3a4:	fd840513          	addi	a0,s0,-40
 3a8:	00000097          	auipc	ra,0x0
 3ac:	0d2080e7          	jalr	210(ra) # 47a <join>
 3b0:	84aa                	mv	s1,a0
  free(ustack);
 3b2:	fd843503          	ld	a0,-40(s0)
 3b6:	00000097          	auipc	ra,0x0
 3ba:	432080e7          	jalr	1074(ra) # 7e8 <free>
  return status;
}
 3be:	8526                	mv	a0,s1
 3c0:	70a2                	ld	ra,40(sp)
 3c2:	7402                	ld	s0,32(sp)
 3c4:	64e2                	ld	s1,24(sp)
 3c6:	6145                	addi	sp,sp,48
 3c8:	8082                	ret

00000000000003ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ca:	4885                	li	a7,1
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d2:	4889                	li	a7,2
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <wait>:
.global wait
wait:
 li a7, SYS_wait
 3da:	488d                	li	a7,3
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e2:	4891                	li	a7,4
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <read>:
.global read
read:
 li a7, SYS_read
 3ea:	4895                	li	a7,5
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <write>:
.global write
write:
 li a7, SYS_write
 3f2:	48c1                	li	a7,16
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <close>:
.global close
close:
 li a7, SYS_close
 3fa:	48d5                	li	a7,21
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <kill>:
.global kill
kill:
 li a7, SYS_kill
 402:	4899                	li	a7,6
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <exec>:
.global exec
exec:
 li a7, SYS_exec
 40a:	489d                	li	a7,7
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <open>:
.global open
open:
 li a7, SYS_open
 412:	48bd                	li	a7,15
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 41a:	48c5                	li	a7,17
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 422:	48c9                	li	a7,18
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 42a:	48a1                	li	a7,8
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <link>:
.global link
link:
 li a7, SYS_link
 432:	48cd                	li	a7,19
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 43a:	48d1                	li	a7,20
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 442:	48a5                	li	a7,9
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <dup>:
.global dup
dup:
 li a7, SYS_dup
 44a:	48a9                	li	a7,10
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 452:	48ad                	li	a7,11
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 45a:	48b1                	li	a7,12
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 462:	48b5                	li	a7,13
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 46a:	48b9                	li	a7,14
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <clone>:
.global clone
clone:
 li a7, SYS_clone
 472:	48d9                	li	a7,22
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <join>:
.global join
join:
 li a7, SYS_join
 47a:	48dd                	li	a7,23
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <putc>:
  int type;
};

static void
putc(int fd, char c)
{
 482:	1101                	addi	sp,sp,-32
 484:	ec06                	sd	ra,24(sp)
 486:	e822                	sd	s0,16(sp)
 488:	1000                	addi	s0,sp,32
 48a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 48e:	4605                	li	a2,1
 490:	fef40593          	addi	a1,s0,-17
 494:	00000097          	auipc	ra,0x0
 498:	f5e080e7          	jalr	-162(ra) # 3f2 <write>
}
 49c:	60e2                	ld	ra,24(sp)
 49e:	6442                	ld	s0,16(sp)
 4a0:	6105                	addi	sp,sp,32
 4a2:	8082                	ret

00000000000004a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a4:	7139                	addi	sp,sp,-64
 4a6:	fc06                	sd	ra,56(sp)
 4a8:	f822                	sd	s0,48(sp)
 4aa:	f426                	sd	s1,40(sp)
 4ac:	f04a                	sd	s2,32(sp)
 4ae:	ec4e                	sd	s3,24(sp)
 4b0:	0080                	addi	s0,sp,64
 4b2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4b4:	c299                	beqz	a3,4ba <printint+0x16>
 4b6:	0805c863          	bltz	a1,546 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4ba:	2581                	sext.w	a1,a1
  neg = 0;
 4bc:	4881                	li	a7,0
 4be:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4c2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4c4:	2601                	sext.w	a2,a2
 4c6:	00000517          	auipc	a0,0x0
 4ca:	4e250513          	addi	a0,a0,1250 # 9a8 <digits>
 4ce:	883a                	mv	a6,a4
 4d0:	2705                	addiw	a4,a4,1
 4d2:	02c5f7bb          	remuw	a5,a1,a2
 4d6:	1782                	slli	a5,a5,0x20
 4d8:	9381                	srli	a5,a5,0x20
 4da:	97aa                	add	a5,a5,a0
 4dc:	0007c783          	lbu	a5,0(a5) # 1000 <__BSS_END__+0x610>
 4e0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4e4:	0005879b          	sext.w	a5,a1
 4e8:	02c5d5bb          	divuw	a1,a1,a2
 4ec:	0685                	addi	a3,a3,1
 4ee:	fec7f0e3          	bgeu	a5,a2,4ce <printint+0x2a>
  if(neg)
 4f2:	00088b63          	beqz	a7,508 <printint+0x64>
    buf[i++] = '-';
 4f6:	fd040793          	addi	a5,s0,-48
 4fa:	973e                	add	a4,a4,a5
 4fc:	02d00793          	li	a5,45
 500:	fef70823          	sb	a5,-16(a4)
 504:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 508:	02e05863          	blez	a4,538 <printint+0x94>
 50c:	fc040793          	addi	a5,s0,-64
 510:	00e78933          	add	s2,a5,a4
 514:	fff78993          	addi	s3,a5,-1
 518:	99ba                	add	s3,s3,a4
 51a:	377d                	addiw	a4,a4,-1
 51c:	1702                	slli	a4,a4,0x20
 51e:	9301                	srli	a4,a4,0x20
 520:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 524:	fff94583          	lbu	a1,-1(s2)
 528:	8526                	mv	a0,s1
 52a:	00000097          	auipc	ra,0x0
 52e:	f58080e7          	jalr	-168(ra) # 482 <putc>
  while(--i >= 0)
 532:	197d                	addi	s2,s2,-1
 534:	ff3918e3          	bne	s2,s3,524 <printint+0x80>
}
 538:	70e2                	ld	ra,56(sp)
 53a:	7442                	ld	s0,48(sp)
 53c:	74a2                	ld	s1,40(sp)
 53e:	7902                	ld	s2,32(sp)
 540:	69e2                	ld	s3,24(sp)
 542:	6121                	addi	sp,sp,64
 544:	8082                	ret
    x = -xx;
 546:	40b005bb          	negw	a1,a1
    neg = 1;
 54a:	4885                	li	a7,1
    x = -xx;
 54c:	bf8d                	j	4be <printint+0x1a>

000000000000054e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 54e:	7119                	addi	sp,sp,-128
 550:	fc86                	sd	ra,120(sp)
 552:	f8a2                	sd	s0,112(sp)
 554:	f4a6                	sd	s1,104(sp)
 556:	f0ca                	sd	s2,96(sp)
 558:	ecce                	sd	s3,88(sp)
 55a:	e8d2                	sd	s4,80(sp)
 55c:	e4d6                	sd	s5,72(sp)
 55e:	e0da                	sd	s6,64(sp)
 560:	fc5e                	sd	s7,56(sp)
 562:	f862                	sd	s8,48(sp)
 564:	f466                	sd	s9,40(sp)
 566:	f06a                	sd	s10,32(sp)
 568:	ec6e                	sd	s11,24(sp)
 56a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 56c:	0005c903          	lbu	s2,0(a1)
 570:	18090f63          	beqz	s2,70e <vprintf+0x1c0>
 574:	8aaa                	mv	s5,a0
 576:	8b32                	mv	s6,a2
 578:	00158493          	addi	s1,a1,1
  state = 0;
 57c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 57e:	02500a13          	li	s4,37
      if(c == 'd'){
 582:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 586:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 58a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 58e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 592:	00000b97          	auipc	s7,0x0
 596:	416b8b93          	addi	s7,s7,1046 # 9a8 <digits>
 59a:	a839                	j	5b8 <vprintf+0x6a>
        putc(fd, c);
 59c:	85ca                	mv	a1,s2
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	ee2080e7          	jalr	-286(ra) # 482 <putc>
 5a8:	a019                	j	5ae <vprintf+0x60>
    } else if(state == '%'){
 5aa:	01498f63          	beq	s3,s4,5c8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5ae:	0485                	addi	s1,s1,1
 5b0:	fff4c903          	lbu	s2,-1(s1)
 5b4:	14090d63          	beqz	s2,70e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5b8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5bc:	fe0997e3          	bnez	s3,5aa <vprintf+0x5c>
      if(c == '%'){
 5c0:	fd479ee3          	bne	a5,s4,59c <vprintf+0x4e>
        state = '%';
 5c4:	89be                	mv	s3,a5
 5c6:	b7e5                	j	5ae <vprintf+0x60>
      if(c == 'd'){
 5c8:	05878063          	beq	a5,s8,608 <vprintf+0xba>
      } else if(c == 'l') {
 5cc:	05978c63          	beq	a5,s9,624 <vprintf+0xd6>
      } else if(c == 'x') {
 5d0:	07a78863          	beq	a5,s10,640 <vprintf+0xf2>
      } else if(c == 'p') {
 5d4:	09b78463          	beq	a5,s11,65c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5d8:	07300713          	li	a4,115
 5dc:	0ce78663          	beq	a5,a4,6a8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e0:	06300713          	li	a4,99
 5e4:	0ee78e63          	beq	a5,a4,6e0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5e8:	11478863          	beq	a5,s4,6f8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ec:	85d2                	mv	a1,s4
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e92080e7          	jalr	-366(ra) # 482 <putc>
        putc(fd, c);
 5f8:	85ca                	mv	a1,s2
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	e86080e7          	jalr	-378(ra) # 482 <putc>
      }
      state = 0;
 604:	4981                	li	s3,0
 606:	b765                	j	5ae <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 608:	008b0913          	addi	s2,s6,8
 60c:	4685                	li	a3,1
 60e:	4629                	li	a2,10
 610:	000b2583          	lw	a1,0(s6)
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	e8e080e7          	jalr	-370(ra) # 4a4 <printint>
 61e:	8b4a                	mv	s6,s2
      state = 0;
 620:	4981                	li	s3,0
 622:	b771                	j	5ae <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 624:	008b0913          	addi	s2,s6,8
 628:	4681                	li	a3,0
 62a:	4629                	li	a2,10
 62c:	000b2583          	lw	a1,0(s6)
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	e72080e7          	jalr	-398(ra) # 4a4 <printint>
 63a:	8b4a                	mv	s6,s2
      state = 0;
 63c:	4981                	li	s3,0
 63e:	bf85                	j	5ae <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 640:	008b0913          	addi	s2,s6,8
 644:	4681                	li	a3,0
 646:	4641                	li	a2,16
 648:	000b2583          	lw	a1,0(s6)
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	e56080e7          	jalr	-426(ra) # 4a4 <printint>
 656:	8b4a                	mv	s6,s2
      state = 0;
 658:	4981                	li	s3,0
 65a:	bf91                	j	5ae <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 65c:	008b0793          	addi	a5,s6,8
 660:	f8f43423          	sd	a5,-120(s0)
 664:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 668:	03000593          	li	a1,48
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	e14080e7          	jalr	-492(ra) # 482 <putc>
  putc(fd, 'x');
 676:	85ea                	mv	a1,s10
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	e08080e7          	jalr	-504(ra) # 482 <putc>
 682:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 684:	03c9d793          	srli	a5,s3,0x3c
 688:	97de                	add	a5,a5,s7
 68a:	0007c583          	lbu	a1,0(a5)
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	df2080e7          	jalr	-526(ra) # 482 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 698:	0992                	slli	s3,s3,0x4
 69a:	397d                	addiw	s2,s2,-1
 69c:	fe0914e3          	bnez	s2,684 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6a0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b721                	j	5ae <vprintf+0x60>
        s = va_arg(ap, char*);
 6a8:	008b0993          	addi	s3,s6,8
 6ac:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6b0:	02090163          	beqz	s2,6d2 <vprintf+0x184>
        while(*s != 0){
 6b4:	00094583          	lbu	a1,0(s2)
 6b8:	c9a1                	beqz	a1,708 <vprintf+0x1ba>
          putc(fd, *s);
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	dc6080e7          	jalr	-570(ra) # 482 <putc>
          s++;
 6c4:	0905                	addi	s2,s2,1
        while(*s != 0){
 6c6:	00094583          	lbu	a1,0(s2)
 6ca:	f9e5                	bnez	a1,6ba <vprintf+0x16c>
        s = va_arg(ap, char*);
 6cc:	8b4e                	mv	s6,s3
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	bdf9                	j	5ae <vprintf+0x60>
          s = "(null)";
 6d2:	00000917          	auipc	s2,0x0
 6d6:	2c690913          	addi	s2,s2,710 # 998 <malloc+0x128>
        while(*s != 0){
 6da:	02800593          	li	a1,40
 6de:	bff1                	j	6ba <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6e0:	008b0913          	addi	s2,s6,8
 6e4:	000b4583          	lbu	a1,0(s6)
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	d98080e7          	jalr	-616(ra) # 482 <putc>
 6f2:	8b4a                	mv	s6,s2
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	bd65                	j	5ae <vprintf+0x60>
        putc(fd, c);
 6f8:	85d2                	mv	a1,s4
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	d86080e7          	jalr	-634(ra) # 482 <putc>
      state = 0;
 704:	4981                	li	s3,0
 706:	b565                	j	5ae <vprintf+0x60>
        s = va_arg(ap, char*);
 708:	8b4e                	mv	s6,s3
      state = 0;
 70a:	4981                	li	s3,0
 70c:	b54d                	j	5ae <vprintf+0x60>
    }
  }
}
 70e:	70e6                	ld	ra,120(sp)
 710:	7446                	ld	s0,112(sp)
 712:	74a6                	ld	s1,104(sp)
 714:	7906                	ld	s2,96(sp)
 716:	69e6                	ld	s3,88(sp)
 718:	6a46                	ld	s4,80(sp)
 71a:	6aa6                	ld	s5,72(sp)
 71c:	6b06                	ld	s6,64(sp)
 71e:	7be2                	ld	s7,56(sp)
 720:	7c42                	ld	s8,48(sp)
 722:	7ca2                	ld	s9,40(sp)
 724:	7d02                	ld	s10,32(sp)
 726:	6de2                	ld	s11,24(sp)
 728:	6109                	addi	sp,sp,128
 72a:	8082                	ret

000000000000072c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 72c:	715d                	addi	sp,sp,-80
 72e:	ec06                	sd	ra,24(sp)
 730:	e822                	sd	s0,16(sp)
 732:	1000                	addi	s0,sp,32
 734:	e010                	sd	a2,0(s0)
 736:	e414                	sd	a3,8(s0)
 738:	e818                	sd	a4,16(s0)
 73a:	ec1c                	sd	a5,24(s0)
 73c:	03043023          	sd	a6,32(s0)
 740:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 744:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 748:	8622                	mv	a2,s0
 74a:	00000097          	auipc	ra,0x0
 74e:	e04080e7          	jalr	-508(ra) # 54e <vprintf>
}
 752:	60e2                	ld	ra,24(sp)
 754:	6442                	ld	s0,16(sp)
 756:	6161                	addi	sp,sp,80
 758:	8082                	ret

000000000000075a <printf>:

void
printf(const char *fmt, ...)
{
 75a:	7159                	addi	sp,sp,-112
 75c:	f406                	sd	ra,40(sp)
 75e:	f022                	sd	s0,32(sp)
 760:	ec26                	sd	s1,24(sp)
 762:	e84a                	sd	s2,16(sp)
 764:	1800                	addi	s0,sp,48
 766:	84aa                	mv	s1,a0
 768:	e40c                	sd	a1,8(s0)
 76a:	e810                	sd	a2,16(s0)
 76c:	ec14                	sd	a3,24(s0)
 76e:	f018                	sd	a4,32(s0)
 770:	f41c                	sd	a5,40(s0)
 772:	03043823          	sd	a6,48(s0)
 776:	03143c23          	sd	a7,56(s0)
  va_list ap;
  lock_acquire(&pr.printf_lock);
 77a:	00000917          	auipc	s2,0x0
 77e:	24e90913          	addi	s2,s2,590 # 9c8 <pr>
 782:	854a                	mv	a0,s2
 784:	00000097          	auipc	ra,0x0
 788:	b88080e7          	jalr	-1144(ra) # 30c <lock_acquire>

  va_start(ap, fmt);
 78c:	00840613          	addi	a2,s0,8
 790:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 794:	85a6                	mv	a1,s1
 796:	4505                	li	a0,1
 798:	00000097          	auipc	ra,0x0
 79c:	db6080e7          	jalr	-586(ra) # 54e <vprintf>
  
  lock_release(&pr.printf_lock);
 7a0:	854a                	mv	a0,s2
 7a2:	00000097          	auipc	ra,0x0
 7a6:	b8a080e7          	jalr	-1142(ra) # 32c <lock_release>

}
 7aa:	70a2                	ld	ra,40(sp)
 7ac:	7402                	ld	s0,32(sp)
 7ae:	64e2                	ld	s1,24(sp)
 7b0:	6942                	ld	s2,16(sp)
 7b2:	6165                	addi	sp,sp,112
 7b4:	8082                	ret

00000000000007b6 <printfinit>:

void
printfinit(void)
{
 7b6:	1101                	addi	sp,sp,-32
 7b8:	ec06                	sd	ra,24(sp)
 7ba:	e822                	sd	s0,16(sp)
 7bc:	e426                	sd	s1,8(sp)
 7be:	1000                	addi	s0,sp,32
  lock_init(&pr.printf_lock, "pr");
 7c0:	00000497          	auipc	s1,0x0
 7c4:	20848493          	addi	s1,s1,520 # 9c8 <pr>
 7c8:	00000597          	auipc	a1,0x0
 7cc:	1d858593          	addi	a1,a1,472 # 9a0 <malloc+0x130>
 7d0:	8526                	mv	a0,s1
 7d2:	00000097          	auipc	ra,0x0
 7d6:	b28080e7          	jalr	-1240(ra) # 2fa <lock_init>
  pr.locking = 1;
 7da:	4785                	li	a5,1
 7dc:	c89c                	sw	a5,16(s1)
}
 7de:	60e2                	ld	ra,24(sp)
 7e0:	6442                	ld	s0,16(sp)
 7e2:	64a2                	ld	s1,8(sp)
 7e4:	6105                	addi	sp,sp,32
 7e6:	8082                	ret

00000000000007e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e8:	1141                	addi	sp,sp,-16
 7ea:	e422                	sd	s0,8(sp)
 7ec:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ee:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f2:	00000797          	auipc	a5,0x0
 7f6:	1ce7b783          	ld	a5,462(a5) # 9c0 <freep>
 7fa:	a805                	j	82a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7fc:	4618                	lw	a4,8(a2)
 7fe:	9db9                	addw	a1,a1,a4
 800:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 804:	6398                	ld	a4,0(a5)
 806:	6318                	ld	a4,0(a4)
 808:	fee53823          	sd	a4,-16(a0)
 80c:	a091                	j	850 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 80e:	ff852703          	lw	a4,-8(a0)
 812:	9e39                	addw	a2,a2,a4
 814:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 816:	ff053703          	ld	a4,-16(a0)
 81a:	e398                	sd	a4,0(a5)
 81c:	a099                	j	862 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81e:	6398                	ld	a4,0(a5)
 820:	00e7e463          	bltu	a5,a4,828 <free+0x40>
 824:	00e6ea63          	bltu	a3,a4,838 <free+0x50>
{
 828:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82a:	fed7fae3          	bgeu	a5,a3,81e <free+0x36>
 82e:	6398                	ld	a4,0(a5)
 830:	00e6e463          	bltu	a3,a4,838 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 834:	fee7eae3          	bltu	a5,a4,828 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 838:	ff852583          	lw	a1,-8(a0)
 83c:	6390                	ld	a2,0(a5)
 83e:	02059713          	slli	a4,a1,0x20
 842:	9301                	srli	a4,a4,0x20
 844:	0712                	slli	a4,a4,0x4
 846:	9736                	add	a4,a4,a3
 848:	fae60ae3          	beq	a2,a4,7fc <free+0x14>
    bp->s.ptr = p->s.ptr;
 84c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 850:	4790                	lw	a2,8(a5)
 852:	02061713          	slli	a4,a2,0x20
 856:	9301                	srli	a4,a4,0x20
 858:	0712                	slli	a4,a4,0x4
 85a:	973e                	add	a4,a4,a5
 85c:	fae689e3          	beq	a3,a4,80e <free+0x26>
  } else
    p->s.ptr = bp;
 860:	e394                	sd	a3,0(a5)
  freep = p;
 862:	00000717          	auipc	a4,0x0
 866:	14f73f23          	sd	a5,350(a4) # 9c0 <freep>
}
 86a:	6422                	ld	s0,8(sp)
 86c:	0141                	addi	sp,sp,16
 86e:	8082                	ret

0000000000000870 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 870:	7139                	addi	sp,sp,-64
 872:	fc06                	sd	ra,56(sp)
 874:	f822                	sd	s0,48(sp)
 876:	f426                	sd	s1,40(sp)
 878:	f04a                	sd	s2,32(sp)
 87a:	ec4e                	sd	s3,24(sp)
 87c:	e852                	sd	s4,16(sp)
 87e:	e456                	sd	s5,8(sp)
 880:	e05a                	sd	s6,0(sp)
 882:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 884:	02051493          	slli	s1,a0,0x20
 888:	9081                	srli	s1,s1,0x20
 88a:	04bd                	addi	s1,s1,15
 88c:	8091                	srli	s1,s1,0x4
 88e:	0014899b          	addiw	s3,s1,1
 892:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 894:	00000517          	auipc	a0,0x0
 898:	12c53503          	ld	a0,300(a0) # 9c0 <freep>
 89c:	c515                	beqz	a0,8c8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a0:	4798                	lw	a4,8(a5)
 8a2:	02977f63          	bgeu	a4,s1,8e0 <malloc+0x70>
 8a6:	8a4e                	mv	s4,s3
 8a8:	0009871b          	sext.w	a4,s3
 8ac:	6685                	lui	a3,0x1
 8ae:	00d77363          	bgeu	a4,a3,8b4 <malloc+0x44>
 8b2:	6a05                	lui	s4,0x1
 8b4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8bc:	00000917          	auipc	s2,0x0
 8c0:	10490913          	addi	s2,s2,260 # 9c0 <freep>
  if(p == (char*)-1)
 8c4:	5afd                	li	s5,-1
 8c6:	a88d                	j	938 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8c8:	00000797          	auipc	a5,0x0
 8cc:	11878793          	addi	a5,a5,280 # 9e0 <base>
 8d0:	00000717          	auipc	a4,0x0
 8d4:	0ef73823          	sd	a5,240(a4) # 9c0 <freep>
 8d8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8da:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8de:	b7e1                	j	8a6 <malloc+0x36>
      if(p->s.size == nunits)
 8e0:	02e48b63          	beq	s1,a4,916 <malloc+0xa6>
        p->s.size -= nunits;
 8e4:	4137073b          	subw	a4,a4,s3
 8e8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ea:	1702                	slli	a4,a4,0x20
 8ec:	9301                	srli	a4,a4,0x20
 8ee:	0712                	slli	a4,a4,0x4
 8f0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f6:	00000717          	auipc	a4,0x0
 8fa:	0ca73523          	sd	a0,202(a4) # 9c0 <freep>
      return (void*)(p + 1);
 8fe:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 902:	70e2                	ld	ra,56(sp)
 904:	7442                	ld	s0,48(sp)
 906:	74a2                	ld	s1,40(sp)
 908:	7902                	ld	s2,32(sp)
 90a:	69e2                	ld	s3,24(sp)
 90c:	6a42                	ld	s4,16(sp)
 90e:	6aa2                	ld	s5,8(sp)
 910:	6b02                	ld	s6,0(sp)
 912:	6121                	addi	sp,sp,64
 914:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 916:	6398                	ld	a4,0(a5)
 918:	e118                	sd	a4,0(a0)
 91a:	bff1                	j	8f6 <malloc+0x86>
  hp->s.size = nu;
 91c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 920:	0541                	addi	a0,a0,16
 922:	00000097          	auipc	ra,0x0
 926:	ec6080e7          	jalr	-314(ra) # 7e8 <free>
  return freep;
 92a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 92e:	d971                	beqz	a0,902 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 930:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 932:	4798                	lw	a4,8(a5)
 934:	fa9776e3          	bgeu	a4,s1,8e0 <malloc+0x70>
    if(p == freep)
 938:	00093703          	ld	a4,0(s2)
 93c:	853e                	mv	a0,a5
 93e:	fef719e3          	bne	a4,a5,930 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 942:	8552                	mv	a0,s4
 944:	00000097          	auipc	ra,0x0
 948:	b16080e7          	jalr	-1258(ra) # 45a <sbrk>
  if(p == (char*)-1)
 94c:	fd5518e3          	bne	a0,s5,91c <malloc+0xac>
        return 0;
 950:	4501                	li	a0,0
 952:	bf45                	j	902 <malloc+0x92>
