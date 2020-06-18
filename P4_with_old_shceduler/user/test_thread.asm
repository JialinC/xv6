
user/_test_thread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <produce1>:
  //  printf(1, "TEST PASSED\n");
  exit(0);
}

void
produce1(void *arg1,void *arg2) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    //while(bufsize == N)
    //  cv_wait(&nonfull, &lock);
    //printf("produce\n");
    //result <<= 1;
    //result |= 1;
    printf("print out something1 %p\n", result);
   8:	00001597          	auipc	a1,0x1
   c:	9c45a583          	lw	a1,-1596(a1) # 9cc <result>
  10:	00001517          	auipc	a0,0x1
  14:	93850513          	addi	a0,a0,-1736 # 948 <malloc+0xe8>
  18:	00000097          	auipc	ra,0x0
  1c:	732080e7          	jalr	1842(ra) # 74a <printf>
    //bufsize++;
    //cv_signal(&nonempty);
    //lock_release(&lock);
  //}
  exit(0);
  20:	4501                	li	a0,0
  22:	00000097          	auipc	ra,0x0
  26:	3a0080e7          	jalr	928(ra) # 3c2 <exit>

000000000000002a <produce2>:
}
void
produce2(void *arg1,void *arg2) {
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
    //while(bufsize == N)
    //  cv_wait(&nonfull, &lock);
    //printf("produce\n");
    //result <<= 1;
    //result |= 1;
    printf("print out something2 %p\n", result);
  32:	00001597          	auipc	a1,0x1
  36:	99a5a583          	lw	a1,-1638(a1) # 9cc <result>
  3a:	00001517          	auipc	a0,0x1
  3e:	92e50513          	addi	a0,a0,-1746 # 968 <malloc+0x108>
  42:	00000097          	auipc	ra,0x0
  46:	708080e7          	jalr	1800(ra) # 74a <printf>
    //bufsize++;
    //cv_signal(&nonempty);
    //lock_release(&lock);
  //}
  exit(0);
  4a:	4501                	li	a0,0
  4c:	00000097          	auipc	ra,0x0
  50:	376080e7          	jalr	886(ra) # 3c2 <exit>

0000000000000054 <main>:
{
  54:	1101                	addi	sp,sp,-32
  56:	ec06                	sd	ra,24(sp)
  58:	e822                	sd	s0,16(sp)
  5a:	e426                	sd	s1,8(sp)
  5c:	e04a                	sd	s2,0(sp)
  5e:	1000                	addi	s0,sp,32
  printf("ppid%p\n", ppid);
  60:	00001597          	auipc	a1,0x1
  64:	9785a583          	lw	a1,-1672(a1) # 9d8 <ppid>
  68:	00001517          	auipc	a0,0x1
  6c:	92050513          	addi	a0,a0,-1760 # 988 <malloc+0x128>
  70:	00000097          	auipc	ra,0x0
  74:	6da080e7          	jalr	1754(ra) # 74a <printf>
  pid1 = thread_create(produce1, NULL, NULL);
  78:	4601                	li	a2,0
  7a:	4581                	li	a1,0
  7c:	00000517          	auipc	a0,0x0
  80:	f8450513          	addi	a0,a0,-124 # 0 <produce1>
  84:	00000097          	auipc	ra,0x0
  88:	2b4080e7          	jalr	692(ra) # 338 <thread_create>
  8c:	00001917          	auipc	s2,0x1
  90:	94890913          	addi	s2,s2,-1720 # 9d4 <pid1>
  94:	00a92023          	sw	a0,0(s2)
  pid2 = thread_create(produce2, NULL, NULL);
  98:	4601                	li	a2,0
  9a:	4581                	li	a1,0
  9c:	00000517          	auipc	a0,0x0
  a0:	f8e50513          	addi	a0,a0,-114 # 2a <produce2>
  a4:	00000097          	auipc	ra,0x0
  a8:	294080e7          	jalr	660(ra) # 338 <thread_create>
  ac:	00001497          	auipc	s1,0x1
  b0:	92448493          	addi	s1,s1,-1756 # 9d0 <pid2>
  b4:	c088                	sw	a0,0(s1)
  pid1 = thread_join();
  b6:	00000097          	auipc	ra,0x0
  ba:	2d0080e7          	jalr	720(ra) # 386 <thread_join>
  be:	00a92023          	sw	a0,0(s2)
  pid2 = thread_join();
  c2:	00000097          	auipc	ra,0x0
  c6:	2c4080e7          	jalr	708(ra) # 386 <thread_join>
  ca:	c088                	sw	a0,0(s1)
  printf("join success %p\n",pid1);
  cc:	00092583          	lw	a1,0(s2)
  d0:	00001517          	auipc	a0,0x1
  d4:	8c050513          	addi	a0,a0,-1856 # 990 <malloc+0x130>
  d8:	00000097          	auipc	ra,0x0
  dc:	672080e7          	jalr	1650(ra) # 74a <printf>
  printf("join success %p\n",pid2);
  e0:	408c                	lw	a1,0(s1)
  e2:	00001517          	auipc	a0,0x1
  e6:	8ae50513          	addi	a0,a0,-1874 # 990 <malloc+0x130>
  ea:	00000097          	auipc	ra,0x0
  ee:	660080e7          	jalr	1632(ra) # 74a <printf>
  exit(0);
  f2:	4501                	li	a0,0
  f4:	00000097          	auipc	ra,0x0
  f8:	2ce080e7          	jalr	718(ra) # 3c2 <exit>

00000000000000fc <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e422                	sd	s0,8(sp)
 100:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 102:	87aa                	mv	a5,a0
 104:	0585                	addi	a1,a1,1
 106:	0785                	addi	a5,a5,1
 108:	fff5c703          	lbu	a4,-1(a1)
 10c:	fee78fa3          	sb	a4,-1(a5)
 110:	fb75                	bnez	a4,104 <strcpy+0x8>
    ;
  return os;
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	cb91                	beqz	a5,136 <strcmp+0x1e>
 124:	0005c703          	lbu	a4,0(a1)
 128:	00f71763          	bne	a4,a5,136 <strcmp+0x1e>
    p++, q++;
 12c:	0505                	addi	a0,a0,1
 12e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 130:	00054783          	lbu	a5,0(a0)
 134:	fbe5                	bnez	a5,124 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 136:	0005c503          	lbu	a0,0(a1)
}
 13a:	40a7853b          	subw	a0,a5,a0
 13e:	6422                	ld	s0,8(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret

0000000000000144 <strlen>:

uint
strlen(const char *s)
{
 144:	1141                	addi	sp,sp,-16
 146:	e422                	sd	s0,8(sp)
 148:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 14a:	00054783          	lbu	a5,0(a0)
 14e:	cf91                	beqz	a5,16a <strlen+0x26>
 150:	0505                	addi	a0,a0,1
 152:	87aa                	mv	a5,a0
 154:	4685                	li	a3,1
 156:	9e89                	subw	a3,a3,a0
 158:	00f6853b          	addw	a0,a3,a5
 15c:	0785                	addi	a5,a5,1
 15e:	fff7c703          	lbu	a4,-1(a5)
 162:	fb7d                	bnez	a4,158 <strlen+0x14>
    ;
  return n;
}
 164:	6422                	ld	s0,8(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret
  for(n = 0; s[n]; n++)
 16a:	4501                	li	a0,0
 16c:	bfe5                	j	164 <strlen+0x20>

000000000000016e <memset>:

void*
memset(void *dst, int c, uint n)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 174:	ce09                	beqz	a2,18e <memset+0x20>
 176:	87aa                	mv	a5,a0
 178:	fff6071b          	addiw	a4,a2,-1
 17c:	1702                	slli	a4,a4,0x20
 17e:	9301                	srli	a4,a4,0x20
 180:	0705                	addi	a4,a4,1
 182:	972a                	add	a4,a4,a0
    cdst[i] = c;
 184:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 188:	0785                	addi	a5,a5,1
 18a:	fee79de3          	bne	a5,a4,184 <memset+0x16>
  }
  return dst;
}
 18e:	6422                	ld	s0,8(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret

0000000000000194 <strchr>:

char*
strchr(const char *s, char c)
{
 194:	1141                	addi	sp,sp,-16
 196:	e422                	sd	s0,8(sp)
 198:	0800                	addi	s0,sp,16
  for(; *s; s++)
 19a:	00054783          	lbu	a5,0(a0)
 19e:	cb99                	beqz	a5,1b4 <strchr+0x20>
    if(*s == c)
 1a0:	00f58763          	beq	a1,a5,1ae <strchr+0x1a>
  for(; *s; s++)
 1a4:	0505                	addi	a0,a0,1
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	fbfd                	bnez	a5,1a0 <strchr+0xc>
      return (char*)s;
  return 0;
 1ac:	4501                	li	a0,0
}
 1ae:	6422                	ld	s0,8(sp)
 1b0:	0141                	addi	sp,sp,16
 1b2:	8082                	ret
  return 0;
 1b4:	4501                	li	a0,0
 1b6:	bfe5                	j	1ae <strchr+0x1a>

00000000000001b8 <gets>:

char*
gets(char *buf, int max)
{
 1b8:	711d                	addi	sp,sp,-96
 1ba:	ec86                	sd	ra,88(sp)
 1bc:	e8a2                	sd	s0,80(sp)
 1be:	e4a6                	sd	s1,72(sp)
 1c0:	e0ca                	sd	s2,64(sp)
 1c2:	fc4e                	sd	s3,56(sp)
 1c4:	f852                	sd	s4,48(sp)
 1c6:	f456                	sd	s5,40(sp)
 1c8:	f05a                	sd	s6,32(sp)
 1ca:	ec5e                	sd	s7,24(sp)
 1cc:	1080                	addi	s0,sp,96
 1ce:	8baa                	mv	s7,a0
 1d0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d2:	892a                	mv	s2,a0
 1d4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1d6:	4aa9                	li	s5,10
 1d8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1da:	89a6                	mv	s3,s1
 1dc:	2485                	addiw	s1,s1,1
 1de:	0344d863          	bge	s1,s4,20e <gets+0x56>
    cc = read(0, &c, 1);
 1e2:	4605                	li	a2,1
 1e4:	faf40593          	addi	a1,s0,-81
 1e8:	4501                	li	a0,0
 1ea:	00000097          	auipc	ra,0x0
 1ee:	1f0080e7          	jalr	496(ra) # 3da <read>
    if(cc < 1)
 1f2:	00a05e63          	blez	a0,20e <gets+0x56>
    buf[i++] = c;
 1f6:	faf44783          	lbu	a5,-81(s0)
 1fa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1fe:	01578763          	beq	a5,s5,20c <gets+0x54>
 202:	0905                	addi	s2,s2,1
 204:	fd679be3          	bne	a5,s6,1da <gets+0x22>
  for(i=0; i+1 < max; ){
 208:	89a6                	mv	s3,s1
 20a:	a011                	j	20e <gets+0x56>
 20c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 20e:	99de                	add	s3,s3,s7
 210:	00098023          	sb	zero,0(s3)
  return buf;
}
 214:	855e                	mv	a0,s7
 216:	60e6                	ld	ra,88(sp)
 218:	6446                	ld	s0,80(sp)
 21a:	64a6                	ld	s1,72(sp)
 21c:	6906                	ld	s2,64(sp)
 21e:	79e2                	ld	s3,56(sp)
 220:	7a42                	ld	s4,48(sp)
 222:	7aa2                	ld	s5,40(sp)
 224:	7b02                	ld	s6,32(sp)
 226:	6be2                	ld	s7,24(sp)
 228:	6125                	addi	sp,sp,96
 22a:	8082                	ret

000000000000022c <stat>:

int
stat(const char *n, struct stat *st)
{
 22c:	1101                	addi	sp,sp,-32
 22e:	ec06                	sd	ra,24(sp)
 230:	e822                	sd	s0,16(sp)
 232:	e426                	sd	s1,8(sp)
 234:	e04a                	sd	s2,0(sp)
 236:	1000                	addi	s0,sp,32
 238:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 23a:	4581                	li	a1,0
 23c:	00000097          	auipc	ra,0x0
 240:	1c6080e7          	jalr	454(ra) # 402 <open>
  if(fd < 0)
 244:	02054563          	bltz	a0,26e <stat+0x42>
 248:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 24a:	85ca                	mv	a1,s2
 24c:	00000097          	auipc	ra,0x0
 250:	1ce080e7          	jalr	462(ra) # 41a <fstat>
 254:	892a                	mv	s2,a0
  close(fd);
 256:	8526                	mv	a0,s1
 258:	00000097          	auipc	ra,0x0
 25c:	192080e7          	jalr	402(ra) # 3ea <close>
  return r;
}
 260:	854a                	mv	a0,s2
 262:	60e2                	ld	ra,24(sp)
 264:	6442                	ld	s0,16(sp)
 266:	64a2                	ld	s1,8(sp)
 268:	6902                	ld	s2,0(sp)
 26a:	6105                	addi	sp,sp,32
 26c:	8082                	ret
    return -1;
 26e:	597d                	li	s2,-1
 270:	bfc5                	j	260 <stat+0x34>

0000000000000272 <atoi>:

int
atoi(const char *s)
{
 272:	1141                	addi	sp,sp,-16
 274:	e422                	sd	s0,8(sp)
 276:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 278:	00054603          	lbu	a2,0(a0)
 27c:	fd06079b          	addiw	a5,a2,-48
 280:	0ff7f793          	andi	a5,a5,255
 284:	4725                	li	a4,9
 286:	02f76963          	bltu	a4,a5,2b8 <atoi+0x46>
 28a:	86aa                	mv	a3,a0
  n = 0;
 28c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 28e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 290:	0685                	addi	a3,a3,1
 292:	0025179b          	slliw	a5,a0,0x2
 296:	9fa9                	addw	a5,a5,a0
 298:	0017979b          	slliw	a5,a5,0x1
 29c:	9fb1                	addw	a5,a5,a2
 29e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2a2:	0006c603          	lbu	a2,0(a3)
 2a6:	fd06071b          	addiw	a4,a2,-48
 2aa:	0ff77713          	andi	a4,a4,255
 2ae:	fee5f1e3          	bgeu	a1,a4,290 <atoi+0x1e>
  return n;
}
 2b2:	6422                	ld	s0,8(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
  n = 0;
 2b8:	4501                	li	a0,0
 2ba:	bfe5                	j	2b2 <atoi+0x40>

00000000000002bc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e422                	sd	s0,8(sp)
 2c0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c2:	02c05163          	blez	a2,2e4 <memmove+0x28>
 2c6:	fff6071b          	addiw	a4,a2,-1
 2ca:	1702                	slli	a4,a4,0x20
 2cc:	9301                	srli	a4,a4,0x20
 2ce:	0705                	addi	a4,a4,1
 2d0:	972a                	add	a4,a4,a0
  dst = vdst;
 2d2:	87aa                	mv	a5,a0
    *dst++ = *src++;
 2d4:	0585                	addi	a1,a1,1
 2d6:	0785                	addi	a5,a5,1
 2d8:	fff5c683          	lbu	a3,-1(a1)
 2dc:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 2e0:	fee79ae3          	bne	a5,a4,2d4 <memmove+0x18>
  return vdst;
}
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <lock_init>:

void lock_init(lock_t *l, char *name) {
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	addi	s0,sp,16
 l->name = name;
 2f0:	e10c                	sd	a1,0(a0)
 l->locked = 0;
 2f2:	00052423          	sw	zero,8(a0)
 //l->guard = 0;
}
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <lock_acquire>:

void lock_acquire(lock_t *l) {
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e422                	sd	s0,8(sp)
 300:	0800                	addi	s0,sp,16
  while(__sync_lock_test_and_set(&l->locked, 1) != 0)
 302:	4705                	li	a4,1
 304:	87ba                	mv	a5,a4
 306:	00850693          	addi	a3,a0,8
 30a:	0cf6a7af          	amoswap.w.aq	a5,a5,(a3)
 30e:	2781                	sext.w	a5,a5
 310:	fbf5                	bnez	a5,304 <lock_acquire+0x8>
    ;
  __sync_synchronize();
 312:	0ff0000f          	fence
}
 316:	6422                	ld	s0,8(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <lock_release>:

void lock_release(lock_t *l) {
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  __sync_synchronize();
 322:	0ff0000f          	fence
  __sync_lock_release(&l->locked);
 326:	00850793          	addi	a5,a0,8
 32a:	0f50000f          	fence	iorw,ow
 32e:	0807a02f          	amoswap.w	zero,zero,(a5)
//  l->locked = 0;
}
 332:	6422                	ld	s0,8(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret

0000000000000338 <thread_create>:
//    condwakeup(cond->curr);
//  }
//}
int
thread_create(void (*start_routine)(void*, void*), void *arg1, void *arg2)
{
 338:	7179                	addi	sp,sp,-48
 33a:	f406                	sd	ra,40(sp)
 33c:	f022                	sd	s0,32(sp)
 33e:	ec26                	sd	s1,24(sp)
 340:	e84a                	sd	s2,16(sp)
 342:	e44e                	sd	s3,8(sp)
 344:	1800                	addi	s0,sp,48
 346:	84aa                	mv	s1,a0
 348:	892e                	mv	s2,a1
 34a:	89b2                	mv	s3,a2
  void *stack = malloc(PGSIZE*2); //allocate space on the heap, should be 1 page in size and pagesize aligned
 34c:	6509                	lui	a0,0x2
 34e:	00000097          	auipc	ra,0x0
 352:	512080e7          	jalr	1298(ra) # 860 <malloc>
 356:	86aa                	mv	a3,a0
  if((uint64)stack % PGSIZE) { //not aligned
 358:	03451793          	slli	a5,a0,0x34
 35c:	c799                	beqz	a5,36a <thread_create+0x32>
 35e:	0347d713          	srli	a4,a5,0x34
    stack = stack + (PGSIZE - (uint64)stack % PGSIZE); //make is pagesize aligned
 362:	6785                	lui	a5,0x1
 364:	8f99                	sub	a5,a5,a4
 366:	00f506b3          	add	a3,a0,a5
  }
  int pid = clone(start_routine, arg1, arg2, stack);
 36a:	864e                	mv	a2,s3
 36c:	85ca                	mv	a1,s2
 36e:	8526                	mv	a0,s1
 370:	00000097          	auipc	ra,0x0
 374:	0f2080e7          	jalr	242(ra) # 462 <clone>
  return pid;
}
 378:	70a2                	ld	ra,40(sp)
 37a:	7402                	ld	s0,32(sp)
 37c:	64e2                	ld	s1,24(sp)
 37e:	6942                	ld	s2,16(sp)
 380:	69a2                	ld	s3,8(sp)
 382:	6145                	addi	sp,sp,48
 384:	8082                	ret

0000000000000386 <thread_join>:

int thread_join() {
 386:	7179                	addi	sp,sp,-48
 388:	f406                	sd	ra,40(sp)
 38a:	f022                	sd	s0,32(sp)
 38c:	ec26                	sd	s1,24(sp)
 38e:	1800                	addi	s0,sp,48
  void *ustack = 0;
 390:	fc043c23          	sd	zero,-40(s0)
  int status = join(&ustack);
 394:	fd840513          	addi	a0,s0,-40
 398:	00000097          	auipc	ra,0x0
 39c:	0d2080e7          	jalr	210(ra) # 46a <join>
 3a0:	84aa                	mv	s1,a0
  free(ustack);
 3a2:	fd843503          	ld	a0,-40(s0)
 3a6:	00000097          	auipc	ra,0x0
 3aa:	432080e7          	jalr	1074(ra) # 7d8 <free>
  return status;
}
 3ae:	8526                	mv	a0,s1
 3b0:	70a2                	ld	ra,40(sp)
 3b2:	7402                	ld	s0,32(sp)
 3b4:	64e2                	ld	s1,24(sp)
 3b6:	6145                	addi	sp,sp,48
 3b8:	8082                	ret

00000000000003ba <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ba:	4885                	li	a7,1
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c2:	4889                	li	a7,2
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ca:	488d                	li	a7,3
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d2:	4891                	li	a7,4
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <read>:
.global read
read:
 li a7, SYS_read
 3da:	4895                	li	a7,5
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <write>:
.global write
write:
 li a7, SYS_write
 3e2:	48c1                	li	a7,16
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <close>:
.global close
close:
 li a7, SYS_close
 3ea:	48d5                	li	a7,21
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f2:	4899                	li	a7,6
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <exec>:
.global exec
exec:
 li a7, SYS_exec
 3fa:	489d                	li	a7,7
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <open>:
.global open
open:
 li a7, SYS_open
 402:	48bd                	li	a7,15
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 40a:	48c5                	li	a7,17
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 412:	48c9                	li	a7,18
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 41a:	48a1                	li	a7,8
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <link>:
.global link
link:
 li a7, SYS_link
 422:	48cd                	li	a7,19
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 42a:	48d1                	li	a7,20
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 432:	48a5                	li	a7,9
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <dup>:
.global dup
dup:
 li a7, SYS_dup
 43a:	48a9                	li	a7,10
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 442:	48ad                	li	a7,11
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 44a:	48b1                	li	a7,12
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 452:	48b5                	li	a7,13
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 45a:	48b9                	li	a7,14
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <clone>:
.global clone
clone:
 li a7, SYS_clone
 462:	48d9                	li	a7,22
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <join>:
.global join
join:
 li a7, SYS_join
 46a:	48dd                	li	a7,23
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <putc>:
  int type;
};

static void
putc(int fd, char c)
{
 472:	1101                	addi	sp,sp,-32
 474:	ec06                	sd	ra,24(sp)
 476:	e822                	sd	s0,16(sp)
 478:	1000                	addi	s0,sp,32
 47a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47e:	4605                	li	a2,1
 480:	fef40593          	addi	a1,s0,-17
 484:	00000097          	auipc	ra,0x0
 488:	f5e080e7          	jalr	-162(ra) # 3e2 <write>
}
 48c:	60e2                	ld	ra,24(sp)
 48e:	6442                	ld	s0,16(sp)
 490:	6105                	addi	sp,sp,32
 492:	8082                	ret

0000000000000494 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 494:	7139                	addi	sp,sp,-64
 496:	fc06                	sd	ra,56(sp)
 498:	f822                	sd	s0,48(sp)
 49a:	f426                	sd	s1,40(sp)
 49c:	f04a                	sd	s2,32(sp)
 49e:	ec4e                	sd	s3,24(sp)
 4a0:	0080                	addi	s0,sp,64
 4a2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a4:	c299                	beqz	a3,4aa <printint+0x16>
 4a6:	0805c863          	bltz	a1,536 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4aa:	2581                	sext.w	a1,a1
  neg = 0;
 4ac:	4881                	li	a7,0
 4ae:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4b2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4b4:	2601                	sext.w	a2,a2
 4b6:	00000517          	auipc	a0,0x0
 4ba:	50250513          	addi	a0,a0,1282 # 9b8 <digits>
 4be:	883a                	mv	a6,a4
 4c0:	2705                	addiw	a4,a4,1
 4c2:	02c5f7bb          	remuw	a5,a1,a2
 4c6:	1782                	slli	a5,a5,0x20
 4c8:	9381                	srli	a5,a5,0x20
 4ca:	97aa                	add	a5,a5,a0
 4cc:	0007c783          	lbu	a5,0(a5) # 1000 <__BSS_END__+0x5f0>
 4d0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4d4:	0005879b          	sext.w	a5,a1
 4d8:	02c5d5bb          	divuw	a1,a1,a2
 4dc:	0685                	addi	a3,a3,1
 4de:	fec7f0e3          	bgeu	a5,a2,4be <printint+0x2a>
  if(neg)
 4e2:	00088b63          	beqz	a7,4f8 <printint+0x64>
    buf[i++] = '-';
 4e6:	fd040793          	addi	a5,s0,-48
 4ea:	973e                	add	a4,a4,a5
 4ec:	02d00793          	li	a5,45
 4f0:	fef70823          	sb	a5,-16(a4)
 4f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4f8:	02e05863          	blez	a4,528 <printint+0x94>
 4fc:	fc040793          	addi	a5,s0,-64
 500:	00e78933          	add	s2,a5,a4
 504:	fff78993          	addi	s3,a5,-1
 508:	99ba                	add	s3,s3,a4
 50a:	377d                	addiw	a4,a4,-1
 50c:	1702                	slli	a4,a4,0x20
 50e:	9301                	srli	a4,a4,0x20
 510:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 514:	fff94583          	lbu	a1,-1(s2)
 518:	8526                	mv	a0,s1
 51a:	00000097          	auipc	ra,0x0
 51e:	f58080e7          	jalr	-168(ra) # 472 <putc>
  while(--i >= 0)
 522:	197d                	addi	s2,s2,-1
 524:	ff3918e3          	bne	s2,s3,514 <printint+0x80>
}
 528:	70e2                	ld	ra,56(sp)
 52a:	7442                	ld	s0,48(sp)
 52c:	74a2                	ld	s1,40(sp)
 52e:	7902                	ld	s2,32(sp)
 530:	69e2                	ld	s3,24(sp)
 532:	6121                	addi	sp,sp,64
 534:	8082                	ret
    x = -xx;
 536:	40b005bb          	negw	a1,a1
    neg = 1;
 53a:	4885                	li	a7,1
    x = -xx;
 53c:	bf8d                	j	4ae <printint+0x1a>

000000000000053e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 53e:	7119                	addi	sp,sp,-128
 540:	fc86                	sd	ra,120(sp)
 542:	f8a2                	sd	s0,112(sp)
 544:	f4a6                	sd	s1,104(sp)
 546:	f0ca                	sd	s2,96(sp)
 548:	ecce                	sd	s3,88(sp)
 54a:	e8d2                	sd	s4,80(sp)
 54c:	e4d6                	sd	s5,72(sp)
 54e:	e0da                	sd	s6,64(sp)
 550:	fc5e                	sd	s7,56(sp)
 552:	f862                	sd	s8,48(sp)
 554:	f466                	sd	s9,40(sp)
 556:	f06a                	sd	s10,32(sp)
 558:	ec6e                	sd	s11,24(sp)
 55a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 55c:	0005c903          	lbu	s2,0(a1)
 560:	18090f63          	beqz	s2,6fe <vprintf+0x1c0>
 564:	8aaa                	mv	s5,a0
 566:	8b32                	mv	s6,a2
 568:	00158493          	addi	s1,a1,1
  state = 0;
 56c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 56e:	02500a13          	li	s4,37
      if(c == 'd'){
 572:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 576:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 57a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 57e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 582:	00000b97          	auipc	s7,0x0
 586:	436b8b93          	addi	s7,s7,1078 # 9b8 <digits>
 58a:	a839                	j	5a8 <vprintf+0x6a>
        putc(fd, c);
 58c:	85ca                	mv	a1,s2
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	ee2080e7          	jalr	-286(ra) # 472 <putc>
 598:	a019                	j	59e <vprintf+0x60>
    } else if(state == '%'){
 59a:	01498f63          	beq	s3,s4,5b8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 59e:	0485                	addi	s1,s1,1
 5a0:	fff4c903          	lbu	s2,-1(s1)
 5a4:	14090d63          	beqz	s2,6fe <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5a8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5ac:	fe0997e3          	bnez	s3,59a <vprintf+0x5c>
      if(c == '%'){
 5b0:	fd479ee3          	bne	a5,s4,58c <vprintf+0x4e>
        state = '%';
 5b4:	89be                	mv	s3,a5
 5b6:	b7e5                	j	59e <vprintf+0x60>
      if(c == 'd'){
 5b8:	05878063          	beq	a5,s8,5f8 <vprintf+0xba>
      } else if(c == 'l') {
 5bc:	05978c63          	beq	a5,s9,614 <vprintf+0xd6>
      } else if(c == 'x') {
 5c0:	07a78863          	beq	a5,s10,630 <vprintf+0xf2>
      } else if(c == 'p') {
 5c4:	09b78463          	beq	a5,s11,64c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5c8:	07300713          	li	a4,115
 5cc:	0ce78663          	beq	a5,a4,698 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d0:	06300713          	li	a4,99
 5d4:	0ee78e63          	beq	a5,a4,6d0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5d8:	11478863          	beq	a5,s4,6e8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5dc:	85d2                	mv	a1,s4
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e92080e7          	jalr	-366(ra) # 472 <putc>
        putc(fd, c);
 5e8:	85ca                	mv	a1,s2
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	e86080e7          	jalr	-378(ra) # 472 <putc>
      }
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b765                	j	59e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5f8:	008b0913          	addi	s2,s6,8
 5fc:	4685                	li	a3,1
 5fe:	4629                	li	a2,10
 600:	000b2583          	lw	a1,0(s6)
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	e8e080e7          	jalr	-370(ra) # 494 <printint>
 60e:	8b4a                	mv	s6,s2
      state = 0;
 610:	4981                	li	s3,0
 612:	b771                	j	59e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	008b0913          	addi	s2,s6,8
 618:	4681                	li	a3,0
 61a:	4629                	li	a2,10
 61c:	000b2583          	lw	a1,0(s6)
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	e72080e7          	jalr	-398(ra) # 494 <printint>
 62a:	8b4a                	mv	s6,s2
      state = 0;
 62c:	4981                	li	s3,0
 62e:	bf85                	j	59e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 630:	008b0913          	addi	s2,s6,8
 634:	4681                	li	a3,0
 636:	4641                	li	a2,16
 638:	000b2583          	lw	a1,0(s6)
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	e56080e7          	jalr	-426(ra) # 494 <printint>
 646:	8b4a                	mv	s6,s2
      state = 0;
 648:	4981                	li	s3,0
 64a:	bf91                	j	59e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 64c:	008b0793          	addi	a5,s6,8
 650:	f8f43423          	sd	a5,-120(s0)
 654:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 658:	03000593          	li	a1,48
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	e14080e7          	jalr	-492(ra) # 472 <putc>
  putc(fd, 'x');
 666:	85ea                	mv	a1,s10
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	e08080e7          	jalr	-504(ra) # 472 <putc>
 672:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 674:	03c9d793          	srli	a5,s3,0x3c
 678:	97de                	add	a5,a5,s7
 67a:	0007c583          	lbu	a1,0(a5)
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	df2080e7          	jalr	-526(ra) # 472 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 688:	0992                	slli	s3,s3,0x4
 68a:	397d                	addiw	s2,s2,-1
 68c:	fe0914e3          	bnez	s2,674 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 690:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 694:	4981                	li	s3,0
 696:	b721                	j	59e <vprintf+0x60>
        s = va_arg(ap, char*);
 698:	008b0993          	addi	s3,s6,8
 69c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6a0:	02090163          	beqz	s2,6c2 <vprintf+0x184>
        while(*s != 0){
 6a4:	00094583          	lbu	a1,0(s2)
 6a8:	c9a1                	beqz	a1,6f8 <vprintf+0x1ba>
          putc(fd, *s);
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	dc6080e7          	jalr	-570(ra) # 472 <putc>
          s++;
 6b4:	0905                	addi	s2,s2,1
        while(*s != 0){
 6b6:	00094583          	lbu	a1,0(s2)
 6ba:	f9e5                	bnez	a1,6aa <vprintf+0x16c>
        s = va_arg(ap, char*);
 6bc:	8b4e                	mv	s6,s3
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	bdf9                	j	59e <vprintf+0x60>
          s = "(null)";
 6c2:	00000917          	auipc	s2,0x0
 6c6:	2e690913          	addi	s2,s2,742 # 9a8 <malloc+0x148>
        while(*s != 0){
 6ca:	02800593          	li	a1,40
 6ce:	bff1                	j	6aa <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6d0:	008b0913          	addi	s2,s6,8
 6d4:	000b4583          	lbu	a1,0(s6)
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	d98080e7          	jalr	-616(ra) # 472 <putc>
 6e2:	8b4a                	mv	s6,s2
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	bd65                	j	59e <vprintf+0x60>
        putc(fd, c);
 6e8:	85d2                	mv	a1,s4
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	d86080e7          	jalr	-634(ra) # 472 <putc>
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b565                	j	59e <vprintf+0x60>
        s = va_arg(ap, char*);
 6f8:	8b4e                	mv	s6,s3
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b54d                	j	59e <vprintf+0x60>
    }
  }
}
 6fe:	70e6                	ld	ra,120(sp)
 700:	7446                	ld	s0,112(sp)
 702:	74a6                	ld	s1,104(sp)
 704:	7906                	ld	s2,96(sp)
 706:	69e6                	ld	s3,88(sp)
 708:	6a46                	ld	s4,80(sp)
 70a:	6aa6                	ld	s5,72(sp)
 70c:	6b06                	ld	s6,64(sp)
 70e:	7be2                	ld	s7,56(sp)
 710:	7c42                	ld	s8,48(sp)
 712:	7ca2                	ld	s9,40(sp)
 714:	7d02                	ld	s10,32(sp)
 716:	6de2                	ld	s11,24(sp)
 718:	6109                	addi	sp,sp,128
 71a:	8082                	ret

000000000000071c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 71c:	715d                	addi	sp,sp,-80
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	addi	s0,sp,32
 724:	e010                	sd	a2,0(s0)
 726:	e414                	sd	a3,8(s0)
 728:	e818                	sd	a4,16(s0)
 72a:	ec1c                	sd	a5,24(s0)
 72c:	03043023          	sd	a6,32(s0)
 730:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 734:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 738:	8622                	mv	a2,s0
 73a:	00000097          	auipc	ra,0x0
 73e:	e04080e7          	jalr	-508(ra) # 53e <vprintf>
}
 742:	60e2                	ld	ra,24(sp)
 744:	6442                	ld	s0,16(sp)
 746:	6161                	addi	sp,sp,80
 748:	8082                	ret

000000000000074a <printf>:

void
printf(const char *fmt, ...)
{
 74a:	7159                	addi	sp,sp,-112
 74c:	f406                	sd	ra,40(sp)
 74e:	f022                	sd	s0,32(sp)
 750:	ec26                	sd	s1,24(sp)
 752:	e84a                	sd	s2,16(sp)
 754:	1800                	addi	s0,sp,48
 756:	84aa                	mv	s1,a0
 758:	e40c                	sd	a1,8(s0)
 75a:	e810                	sd	a2,16(s0)
 75c:	ec14                	sd	a3,24(s0)
 75e:	f018                	sd	a4,32(s0)
 760:	f41c                	sd	a5,40(s0)
 762:	03043823          	sd	a6,48(s0)
 766:	03143c23          	sd	a7,56(s0)
  va_list ap;
  lock_acquire(&pr.printf_lock);
 76a:	00000917          	auipc	s2,0x0
 76e:	27e90913          	addi	s2,s2,638 # 9e8 <pr>
 772:	854a                	mv	a0,s2
 774:	00000097          	auipc	ra,0x0
 778:	b88080e7          	jalr	-1144(ra) # 2fc <lock_acquire>

  va_start(ap, fmt);
 77c:	00840613          	addi	a2,s0,8
 780:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 784:	85a6                	mv	a1,s1
 786:	4505                	li	a0,1
 788:	00000097          	auipc	ra,0x0
 78c:	db6080e7          	jalr	-586(ra) # 53e <vprintf>
  
  lock_release(&pr.printf_lock);
 790:	854a                	mv	a0,s2
 792:	00000097          	auipc	ra,0x0
 796:	b8a080e7          	jalr	-1142(ra) # 31c <lock_release>

}
 79a:	70a2                	ld	ra,40(sp)
 79c:	7402                	ld	s0,32(sp)
 79e:	64e2                	ld	s1,24(sp)
 7a0:	6942                	ld	s2,16(sp)
 7a2:	6165                	addi	sp,sp,112
 7a4:	8082                	ret

00000000000007a6 <printfinit>:

void
printfinit(void)
{
 7a6:	1101                	addi	sp,sp,-32
 7a8:	ec06                	sd	ra,24(sp)
 7aa:	e822                	sd	s0,16(sp)
 7ac:	e426                	sd	s1,8(sp)
 7ae:	1000                	addi	s0,sp,32
  lock_init(&pr.printf_lock, "pr");
 7b0:	00000497          	auipc	s1,0x0
 7b4:	23848493          	addi	s1,s1,568 # 9e8 <pr>
 7b8:	00000597          	auipc	a1,0x0
 7bc:	1f858593          	addi	a1,a1,504 # 9b0 <malloc+0x150>
 7c0:	8526                	mv	a0,s1
 7c2:	00000097          	auipc	ra,0x0
 7c6:	b28080e7          	jalr	-1240(ra) # 2ea <lock_init>
  pr.locking = 1;
 7ca:	4785                	li	a5,1
 7cc:	c89c                	sw	a5,16(s1)
}
 7ce:	60e2                	ld	ra,24(sp)
 7d0:	6442                	ld	s0,16(sp)
 7d2:	64a2                	ld	s1,8(sp)
 7d4:	6105                	addi	sp,sp,32
 7d6:	8082                	ret

00000000000007d8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d8:	1141                	addi	sp,sp,-16
 7da:	e422                	sd	s0,8(sp)
 7dc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7de:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e2:	00000797          	auipc	a5,0x0
 7e6:	1fe7b783          	ld	a5,510(a5) # 9e0 <freep>
 7ea:	a805                	j	81a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ec:	4618                	lw	a4,8(a2)
 7ee:	9db9                	addw	a1,a1,a4
 7f0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f4:	6398                	ld	a4,0(a5)
 7f6:	6318                	ld	a4,0(a4)
 7f8:	fee53823          	sd	a4,-16(a0)
 7fc:	a091                	j	840 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7fe:	ff852703          	lw	a4,-8(a0)
 802:	9e39                	addw	a2,a2,a4
 804:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 806:	ff053703          	ld	a4,-16(a0)
 80a:	e398                	sd	a4,0(a5)
 80c:	a099                	j	852 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80e:	6398                	ld	a4,0(a5)
 810:	00e7e463          	bltu	a5,a4,818 <free+0x40>
 814:	00e6ea63          	bltu	a3,a4,828 <free+0x50>
{
 818:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81a:	fed7fae3          	bgeu	a5,a3,80e <free+0x36>
 81e:	6398                	ld	a4,0(a5)
 820:	00e6e463          	bltu	a3,a4,828 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 824:	fee7eae3          	bltu	a5,a4,818 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 828:	ff852583          	lw	a1,-8(a0)
 82c:	6390                	ld	a2,0(a5)
 82e:	02059713          	slli	a4,a1,0x20
 832:	9301                	srli	a4,a4,0x20
 834:	0712                	slli	a4,a4,0x4
 836:	9736                	add	a4,a4,a3
 838:	fae60ae3          	beq	a2,a4,7ec <free+0x14>
    bp->s.ptr = p->s.ptr;
 83c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 840:	4790                	lw	a2,8(a5)
 842:	02061713          	slli	a4,a2,0x20
 846:	9301                	srli	a4,a4,0x20
 848:	0712                	slli	a4,a4,0x4
 84a:	973e                	add	a4,a4,a5
 84c:	fae689e3          	beq	a3,a4,7fe <free+0x26>
  } else
    p->s.ptr = bp;
 850:	e394                	sd	a3,0(a5)
  freep = p;
 852:	00000717          	auipc	a4,0x0
 856:	18f73723          	sd	a5,398(a4) # 9e0 <freep>
}
 85a:	6422                	ld	s0,8(sp)
 85c:	0141                	addi	sp,sp,16
 85e:	8082                	ret

0000000000000860 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 860:	7139                	addi	sp,sp,-64
 862:	fc06                	sd	ra,56(sp)
 864:	f822                	sd	s0,48(sp)
 866:	f426                	sd	s1,40(sp)
 868:	f04a                	sd	s2,32(sp)
 86a:	ec4e                	sd	s3,24(sp)
 86c:	e852                	sd	s4,16(sp)
 86e:	e456                	sd	s5,8(sp)
 870:	e05a                	sd	s6,0(sp)
 872:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 874:	02051493          	slli	s1,a0,0x20
 878:	9081                	srli	s1,s1,0x20
 87a:	04bd                	addi	s1,s1,15
 87c:	8091                	srli	s1,s1,0x4
 87e:	0014899b          	addiw	s3,s1,1
 882:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 884:	00000517          	auipc	a0,0x0
 888:	15c53503          	ld	a0,348(a0) # 9e0 <freep>
 88c:	c515                	beqz	a0,8b8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 890:	4798                	lw	a4,8(a5)
 892:	02977f63          	bgeu	a4,s1,8d0 <malloc+0x70>
 896:	8a4e                	mv	s4,s3
 898:	0009871b          	sext.w	a4,s3
 89c:	6685                	lui	a3,0x1
 89e:	00d77363          	bgeu	a4,a3,8a4 <malloc+0x44>
 8a2:	6a05                	lui	s4,0x1
 8a4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8a8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ac:	00000917          	auipc	s2,0x0
 8b0:	13490913          	addi	s2,s2,308 # 9e0 <freep>
  if(p == (char*)-1)
 8b4:	5afd                	li	s5,-1
 8b6:	a88d                	j	928 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8b8:	00000797          	auipc	a5,0x0
 8bc:	14878793          	addi	a5,a5,328 # a00 <base>
 8c0:	00000717          	auipc	a4,0x0
 8c4:	12f73023          	sd	a5,288(a4) # 9e0 <freep>
 8c8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ca:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ce:	b7e1                	j	896 <malloc+0x36>
      if(p->s.size == nunits)
 8d0:	02e48b63          	beq	s1,a4,906 <malloc+0xa6>
        p->s.size -= nunits;
 8d4:	4137073b          	subw	a4,a4,s3
 8d8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8da:	1702                	slli	a4,a4,0x20
 8dc:	9301                	srli	a4,a4,0x20
 8de:	0712                	slli	a4,a4,0x4
 8e0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e6:	00000717          	auipc	a4,0x0
 8ea:	0ea73d23          	sd	a0,250(a4) # 9e0 <freep>
      return (void*)(p + 1);
 8ee:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8f2:	70e2                	ld	ra,56(sp)
 8f4:	7442                	ld	s0,48(sp)
 8f6:	74a2                	ld	s1,40(sp)
 8f8:	7902                	ld	s2,32(sp)
 8fa:	69e2                	ld	s3,24(sp)
 8fc:	6a42                	ld	s4,16(sp)
 8fe:	6aa2                	ld	s5,8(sp)
 900:	6b02                	ld	s6,0(sp)
 902:	6121                	addi	sp,sp,64
 904:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 906:	6398                	ld	a4,0(a5)
 908:	e118                	sd	a4,0(a0)
 90a:	bff1                	j	8e6 <malloc+0x86>
  hp->s.size = nu;
 90c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 910:	0541                	addi	a0,a0,16
 912:	00000097          	auipc	ra,0x0
 916:	ec6080e7          	jalr	-314(ra) # 7d8 <free>
  return freep;
 91a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 91e:	d971                	beqz	a0,8f2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 920:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 922:	4798                	lw	a4,8(a5)
 924:	fa9776e3          	bgeu	a4,s1,8d0 <malloc+0x70>
    if(p == freep)
 928:	00093703          	ld	a4,0(s2)
 92c:	853e                	mv	a0,a5
 92e:	fef719e3          	bne	a4,a5,920 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 932:	8552                	mv	a0,s4
 934:	00000097          	auipc	ra,0x0
 938:	b16080e7          	jalr	-1258(ra) # 44a <sbrk>
  if(p == (char*)-1)
 93c:	fd5518e3          	bne	a0,s5,90c <malloc+0xac>
        return 0;
 940:	4501                	li	a0,0
 942:	bf45                	j	8f2 <malloc+0x92>
