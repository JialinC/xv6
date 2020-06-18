
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;
  printfinit(); //p4
   c:	00000097          	auipc	ra,0x0
  10:	786080e7          	jalr	1926(ra) # 792 <printfinit>
  if(open("console", O_RDWR) < 0){
  14:	4589                	li	a1,2
  16:	00001517          	auipc	a0,0x1
  1a:	91a50513          	addi	a0,a0,-1766 # 930 <malloc+0xe4>
  1e:	00000097          	auipc	ra,0x0
  22:	3d0080e7          	jalr	976(ra) # 3ee <open>
  26:	04054763          	bltz	a0,74 <main+0x74>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  2a:	4501                	li	a0,0
  2c:	00000097          	auipc	ra,0x0
  30:	3fa080e7          	jalr	1018(ra) # 426 <dup>
  dup(0);  // stderr
  34:	4501                	li	a0,0
  36:	00000097          	auipc	ra,0x0
  3a:	3f0080e7          	jalr	1008(ra) # 426 <dup>

  for(;;){
    printf("init: starting sh\n");
  3e:	00001917          	auipc	s2,0x1
  42:	8fa90913          	addi	s2,s2,-1798 # 938 <malloc+0xec>
  46:	854a                	mv	a0,s2
  48:	00000097          	auipc	ra,0x0
  4c:	6ee080e7          	jalr	1774(ra) # 736 <printf>
    pid = fork();
  50:	00000097          	auipc	ra,0x0
  54:	356080e7          	jalr	854(ra) # 3a6 <fork>
  58:	84aa                	mv	s1,a0
    if(pid < 0){
  5a:	04054163          	bltz	a0,9c <main+0x9c>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  5e:	cd21                	beqz	a0,b6 <main+0xb6>
      exec("sh", argv);
      printf("init: exec sh failed\n");
      exit(1);
    }
    while((wpid=wait(0)) >= 0 && wpid != pid){
  60:	4501                	li	a0,0
  62:	00000097          	auipc	ra,0x0
  66:	354080e7          	jalr	852(ra) # 3b6 <wait>
  6a:	fc054ee3          	bltz	a0,46 <main+0x46>
  6e:	fea499e3          	bne	s1,a0,60 <main+0x60>
  72:	bfd1                	j	46 <main+0x46>
    mknod("console", 1, 1);
  74:	4605                	li	a2,1
  76:	4585                	li	a1,1
  78:	00001517          	auipc	a0,0x1
  7c:	8b850513          	addi	a0,a0,-1864 # 930 <malloc+0xe4>
  80:	00000097          	auipc	ra,0x0
  84:	376080e7          	jalr	886(ra) # 3f6 <mknod>
    open("console", O_RDWR);
  88:	4589                	li	a1,2
  8a:	00001517          	auipc	a0,0x1
  8e:	8a650513          	addi	a0,a0,-1882 # 930 <malloc+0xe4>
  92:	00000097          	auipc	ra,0x0
  96:	35c080e7          	jalr	860(ra) # 3ee <open>
  9a:	bf41                	j	2a <main+0x2a>
      printf("init: fork failed\n");
  9c:	00001517          	auipc	a0,0x1
  a0:	8b450513          	addi	a0,a0,-1868 # 950 <malloc+0x104>
  a4:	00000097          	auipc	ra,0x0
  a8:	692080e7          	jalr	1682(ra) # 736 <printf>
      exit(1);
  ac:	4505                	li	a0,1
  ae:	00000097          	auipc	ra,0x0
  b2:	300080e7          	jalr	768(ra) # 3ae <exit>
      exec("sh", argv);
  b6:	00001597          	auipc	a1,0x1
  ba:	8fa58593          	addi	a1,a1,-1798 # 9b0 <argv>
  be:	00001517          	auipc	a0,0x1
  c2:	8aa50513          	addi	a0,a0,-1878 # 968 <malloc+0x11c>
  c6:	00000097          	auipc	ra,0x0
  ca:	320080e7          	jalr	800(ra) # 3e6 <exec>
      printf("init: exec sh failed\n");
  ce:	00001517          	auipc	a0,0x1
  d2:	8a250513          	addi	a0,a0,-1886 # 970 <malloc+0x124>
  d6:	00000097          	auipc	ra,0x0
  da:	660080e7          	jalr	1632(ra) # 736 <printf>
      exit(1);
  de:	4505                	li	a0,1
  e0:	00000097          	auipc	ra,0x0
  e4:	2ce080e7          	jalr	718(ra) # 3ae <exit>

00000000000000e8 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ee:	87aa                	mv	a5,a0
  f0:	0585                	addi	a1,a1,1
  f2:	0785                	addi	a5,a5,1
  f4:	fff5c703          	lbu	a4,-1(a1)
  f8:	fee78fa3          	sb	a4,-1(a5)
  fc:	fb75                	bnez	a4,f0 <strcpy+0x8>
    ;
  return os;
}
  fe:	6422                	ld	s0,8(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret

0000000000000104 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 104:	1141                	addi	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cb91                	beqz	a5,122 <strcmp+0x1e>
 110:	0005c703          	lbu	a4,0(a1)
 114:	00f71763          	bne	a4,a5,122 <strcmp+0x1e>
    p++, q++;
 118:	0505                	addi	a0,a0,1
 11a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 11c:	00054783          	lbu	a5,0(a0)
 120:	fbe5                	bnez	a5,110 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 122:	0005c503          	lbu	a0,0(a1)
}
 126:	40a7853b          	subw	a0,a5,a0
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strlen>:

uint
strlen(const char *s)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cf91                	beqz	a5,156 <strlen+0x26>
 13c:	0505                	addi	a0,a0,1
 13e:	87aa                	mv	a5,a0
 140:	4685                	li	a3,1
 142:	9e89                	subw	a3,a3,a0
 144:	00f6853b          	addw	a0,a3,a5
 148:	0785                	addi	a5,a5,1
 14a:	fff7c703          	lbu	a4,-1(a5)
 14e:	fb7d                	bnez	a4,144 <strlen+0x14>
    ;
  return n;
}
 150:	6422                	ld	s0,8(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret
  for(n = 0; s[n]; n++)
 156:	4501                	li	a0,0
 158:	bfe5                	j	150 <strlen+0x20>

000000000000015a <memset>:

void*
memset(void *dst, int c, uint n)
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 160:	ce09                	beqz	a2,17a <memset+0x20>
 162:	87aa                	mv	a5,a0
 164:	fff6071b          	addiw	a4,a2,-1
 168:	1702                	slli	a4,a4,0x20
 16a:	9301                	srli	a4,a4,0x20
 16c:	0705                	addi	a4,a4,1
 16e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 170:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 174:	0785                	addi	a5,a5,1
 176:	fee79de3          	bne	a5,a4,170 <memset+0x16>
  }
  return dst;
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret

0000000000000180 <strchr>:

char*
strchr(const char *s, char c)
{
 180:	1141                	addi	sp,sp,-16
 182:	e422                	sd	s0,8(sp)
 184:	0800                	addi	s0,sp,16
  for(; *s; s++)
 186:	00054783          	lbu	a5,0(a0)
 18a:	cb99                	beqz	a5,1a0 <strchr+0x20>
    if(*s == c)
 18c:	00f58763          	beq	a1,a5,19a <strchr+0x1a>
  for(; *s; s++)
 190:	0505                	addi	a0,a0,1
 192:	00054783          	lbu	a5,0(a0)
 196:	fbfd                	bnez	a5,18c <strchr+0xc>
      return (char*)s;
  return 0;
 198:	4501                	li	a0,0
}
 19a:	6422                	ld	s0,8(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret
  return 0;
 1a0:	4501                	li	a0,0
 1a2:	bfe5                	j	19a <strchr+0x1a>

00000000000001a4 <gets>:

char*
gets(char *buf, int max)
{
 1a4:	711d                	addi	sp,sp,-96
 1a6:	ec86                	sd	ra,88(sp)
 1a8:	e8a2                	sd	s0,80(sp)
 1aa:	e4a6                	sd	s1,72(sp)
 1ac:	e0ca                	sd	s2,64(sp)
 1ae:	fc4e                	sd	s3,56(sp)
 1b0:	f852                	sd	s4,48(sp)
 1b2:	f456                	sd	s5,40(sp)
 1b4:	f05a                	sd	s6,32(sp)
 1b6:	ec5e                	sd	s7,24(sp)
 1b8:	1080                	addi	s0,sp,96
 1ba:	8baa                	mv	s7,a0
 1bc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1be:	892a                	mv	s2,a0
 1c0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c2:	4aa9                	li	s5,10
 1c4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1c6:	89a6                	mv	s3,s1
 1c8:	2485                	addiw	s1,s1,1
 1ca:	0344d863          	bge	s1,s4,1fa <gets+0x56>
    cc = read(0, &c, 1);
 1ce:	4605                	li	a2,1
 1d0:	faf40593          	addi	a1,s0,-81
 1d4:	4501                	li	a0,0
 1d6:	00000097          	auipc	ra,0x0
 1da:	1f0080e7          	jalr	496(ra) # 3c6 <read>
    if(cc < 1)
 1de:	00a05e63          	blez	a0,1fa <gets+0x56>
    buf[i++] = c;
 1e2:	faf44783          	lbu	a5,-81(s0)
 1e6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ea:	01578763          	beq	a5,s5,1f8 <gets+0x54>
 1ee:	0905                	addi	s2,s2,1
 1f0:	fd679be3          	bne	a5,s6,1c6 <gets+0x22>
  for(i=0; i+1 < max; ){
 1f4:	89a6                	mv	s3,s1
 1f6:	a011                	j	1fa <gets+0x56>
 1f8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1fa:	99de                	add	s3,s3,s7
 1fc:	00098023          	sb	zero,0(s3)
  return buf;
}
 200:	855e                	mv	a0,s7
 202:	60e6                	ld	ra,88(sp)
 204:	6446                	ld	s0,80(sp)
 206:	64a6                	ld	s1,72(sp)
 208:	6906                	ld	s2,64(sp)
 20a:	79e2                	ld	s3,56(sp)
 20c:	7a42                	ld	s4,48(sp)
 20e:	7aa2                	ld	s5,40(sp)
 210:	7b02                	ld	s6,32(sp)
 212:	6be2                	ld	s7,24(sp)
 214:	6125                	addi	sp,sp,96
 216:	8082                	ret

0000000000000218 <stat>:

int
stat(const char *n, struct stat *st)
{
 218:	1101                	addi	sp,sp,-32
 21a:	ec06                	sd	ra,24(sp)
 21c:	e822                	sd	s0,16(sp)
 21e:	e426                	sd	s1,8(sp)
 220:	e04a                	sd	s2,0(sp)
 222:	1000                	addi	s0,sp,32
 224:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 226:	4581                	li	a1,0
 228:	00000097          	auipc	ra,0x0
 22c:	1c6080e7          	jalr	454(ra) # 3ee <open>
  if(fd < 0)
 230:	02054563          	bltz	a0,25a <stat+0x42>
 234:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 236:	85ca                	mv	a1,s2
 238:	00000097          	auipc	ra,0x0
 23c:	1ce080e7          	jalr	462(ra) # 406 <fstat>
 240:	892a                	mv	s2,a0
  close(fd);
 242:	8526                	mv	a0,s1
 244:	00000097          	auipc	ra,0x0
 248:	192080e7          	jalr	402(ra) # 3d6 <close>
  return r;
}
 24c:	854a                	mv	a0,s2
 24e:	60e2                	ld	ra,24(sp)
 250:	6442                	ld	s0,16(sp)
 252:	64a2                	ld	s1,8(sp)
 254:	6902                	ld	s2,0(sp)
 256:	6105                	addi	sp,sp,32
 258:	8082                	ret
    return -1;
 25a:	597d                	li	s2,-1
 25c:	bfc5                	j	24c <stat+0x34>

000000000000025e <atoi>:

int
atoi(const char *s)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 264:	00054603          	lbu	a2,0(a0)
 268:	fd06079b          	addiw	a5,a2,-48
 26c:	0ff7f793          	andi	a5,a5,255
 270:	4725                	li	a4,9
 272:	02f76963          	bltu	a4,a5,2a4 <atoi+0x46>
 276:	86aa                	mv	a3,a0
  n = 0;
 278:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 27a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 27c:	0685                	addi	a3,a3,1
 27e:	0025179b          	slliw	a5,a0,0x2
 282:	9fa9                	addw	a5,a5,a0
 284:	0017979b          	slliw	a5,a5,0x1
 288:	9fb1                	addw	a5,a5,a2
 28a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 28e:	0006c603          	lbu	a2,0(a3)
 292:	fd06071b          	addiw	a4,a2,-48
 296:	0ff77713          	andi	a4,a4,255
 29a:	fee5f1e3          	bgeu	a1,a4,27c <atoi+0x1e>
  return n;
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  n = 0;
 2a4:	4501                	li	a0,0
 2a6:	bfe5                	j	29e <atoi+0x40>

00000000000002a8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ae:	02c05163          	blez	a2,2d0 <memmove+0x28>
 2b2:	fff6071b          	addiw	a4,a2,-1
 2b6:	1702                	slli	a4,a4,0x20
 2b8:	9301                	srli	a4,a4,0x20
 2ba:	0705                	addi	a4,a4,1
 2bc:	972a                	add	a4,a4,a0
  dst = vdst;
 2be:	87aa                	mv	a5,a0
    *dst++ = *src++;
 2c0:	0585                	addi	a1,a1,1
 2c2:	0785                	addi	a5,a5,1
 2c4:	fff5c683          	lbu	a3,-1(a1)
 2c8:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 2cc:	fee79ae3          	bne	a5,a4,2c0 <memmove+0x18>
  return vdst;
}
 2d0:	6422                	ld	s0,8(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret

00000000000002d6 <lock_init>:

void lock_init(lock_t *l, char *name) {
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e422                	sd	s0,8(sp)
 2da:	0800                	addi	s0,sp,16
 l->name = name;
 2dc:	e10c                	sd	a1,0(a0)
 l->locked = 0;
 2de:	00052423          	sw	zero,8(a0)
 //l->guard = 0;
}
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <lock_acquire>:

void lock_acquire(lock_t *l) {
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e422                	sd	s0,8(sp)
 2ec:	0800                	addi	s0,sp,16
  while(__sync_lock_test_and_set(&l->locked, 1) != 0)
 2ee:	4705                	li	a4,1
 2f0:	87ba                	mv	a5,a4
 2f2:	00850693          	addi	a3,a0,8
 2f6:	0cf6a7af          	amoswap.w.aq	a5,a5,(a3)
 2fa:	2781                	sext.w	a5,a5
 2fc:	fbf5                	bnez	a5,2f0 <lock_acquire+0x8>
    ;
  __sync_synchronize();
 2fe:	0ff0000f          	fence
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret

0000000000000308 <lock_release>:

void lock_release(lock_t *l) {
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  __sync_synchronize();
 30e:	0ff0000f          	fence
  __sync_lock_release(&l->locked);
 312:	00850793          	addi	a5,a0,8
 316:	0f50000f          	fence	iorw,ow
 31a:	0807a02f          	amoswap.w	zero,zero,(a5)
//  l->locked = 0;
}
 31e:	6422                	ld	s0,8(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret

0000000000000324 <thread_create>:
//    condwakeup(cond->curr);
//  }
//}
int
thread_create(void (*start_routine)(void*, void*), void *arg1, void *arg2)
{
 324:	7179                	addi	sp,sp,-48
 326:	f406                	sd	ra,40(sp)
 328:	f022                	sd	s0,32(sp)
 32a:	ec26                	sd	s1,24(sp)
 32c:	e84a                	sd	s2,16(sp)
 32e:	e44e                	sd	s3,8(sp)
 330:	1800                	addi	s0,sp,48
 332:	84aa                	mv	s1,a0
 334:	892e                	mv	s2,a1
 336:	89b2                	mv	s3,a2
  void *stack = malloc(PGSIZE*2); //allocate space on the heap, should be 1 page in size and pagesize aligned
 338:	6509                	lui	a0,0x2
 33a:	00000097          	auipc	ra,0x0
 33e:	512080e7          	jalr	1298(ra) # 84c <malloc>
 342:	86aa                	mv	a3,a0
  if((uint64)stack % PGSIZE) { //not aligned
 344:	03451793          	slli	a5,a0,0x34
 348:	c799                	beqz	a5,356 <thread_create+0x32>
 34a:	0347d713          	srli	a4,a5,0x34
    stack = stack + (PGSIZE - (uint64)stack % PGSIZE); //make is pagesize aligned
 34e:	6785                	lui	a5,0x1
 350:	8f99                	sub	a5,a5,a4
 352:	00f506b3          	add	a3,a0,a5
  }
  int pid = clone(start_routine, arg1, arg2, stack);
 356:	864e                	mv	a2,s3
 358:	85ca                	mv	a1,s2
 35a:	8526                	mv	a0,s1
 35c:	00000097          	auipc	ra,0x0
 360:	0f2080e7          	jalr	242(ra) # 44e <clone>
  return pid;
}
 364:	70a2                	ld	ra,40(sp)
 366:	7402                	ld	s0,32(sp)
 368:	64e2                	ld	s1,24(sp)
 36a:	6942                	ld	s2,16(sp)
 36c:	69a2                	ld	s3,8(sp)
 36e:	6145                	addi	sp,sp,48
 370:	8082                	ret

0000000000000372 <thread_join>:

int thread_join() {
 372:	7179                	addi	sp,sp,-48
 374:	f406                	sd	ra,40(sp)
 376:	f022                	sd	s0,32(sp)
 378:	ec26                	sd	s1,24(sp)
 37a:	1800                	addi	s0,sp,48
  void *ustack = 0;
 37c:	fc043c23          	sd	zero,-40(s0)
  int status = join(&ustack);
 380:	fd840513          	addi	a0,s0,-40
 384:	00000097          	auipc	ra,0x0
 388:	0d2080e7          	jalr	210(ra) # 456 <join>
 38c:	84aa                	mv	s1,a0
  free(ustack);
 38e:	fd843503          	ld	a0,-40(s0)
 392:	00000097          	auipc	ra,0x0
 396:	432080e7          	jalr	1074(ra) # 7c4 <free>
  return status;
}
 39a:	8526                	mv	a0,s1
 39c:	70a2                	ld	ra,40(sp)
 39e:	7402                	ld	s0,32(sp)
 3a0:	64e2                	ld	s1,24(sp)
 3a2:	6145                	addi	sp,sp,48
 3a4:	8082                	ret

00000000000003a6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a6:	4885                	li	a7,1
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ae:	4889                	li	a7,2
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b6:	488d                	li	a7,3
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3be:	4891                	li	a7,4
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <read>:
.global read
read:
 li a7, SYS_read
 3c6:	4895                	li	a7,5
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <write>:
.global write
write:
 li a7, SYS_write
 3ce:	48c1                	li	a7,16
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <close>:
.global close
close:
 li a7, SYS_close
 3d6:	48d5                	li	a7,21
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <kill>:
.global kill
kill:
 li a7, SYS_kill
 3de:	4899                	li	a7,6
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e6:	489d                	li	a7,7
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <open>:
.global open
open:
 li a7, SYS_open
 3ee:	48bd                	li	a7,15
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f6:	48c5                	li	a7,17
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fe:	48c9                	li	a7,18
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 406:	48a1                	li	a7,8
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <link>:
.global link
link:
 li a7, SYS_link
 40e:	48cd                	li	a7,19
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 416:	48d1                	li	a7,20
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41e:	48a5                	li	a7,9
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <dup>:
.global dup
dup:
 li a7, SYS_dup
 426:	48a9                	li	a7,10
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42e:	48ad                	li	a7,11
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 436:	48b1                	li	a7,12
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 43e:	48b5                	li	a7,13
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 446:	48b9                	li	a7,14
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <clone>:
.global clone
clone:
 li a7, SYS_clone
 44e:	48d9                	li	a7,22
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <join>:
.global join
join:
 li a7, SYS_join
 456:	48dd                	li	a7,23
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <putc>:
  int type;
};

static void
putc(int fd, char c)
{
 45e:	1101                	addi	sp,sp,-32
 460:	ec06                	sd	ra,24(sp)
 462:	e822                	sd	s0,16(sp)
 464:	1000                	addi	s0,sp,32
 466:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46a:	4605                	li	a2,1
 46c:	fef40593          	addi	a1,s0,-17
 470:	00000097          	auipc	ra,0x0
 474:	f5e080e7          	jalr	-162(ra) # 3ce <write>
}
 478:	60e2                	ld	ra,24(sp)
 47a:	6442                	ld	s0,16(sp)
 47c:	6105                	addi	sp,sp,32
 47e:	8082                	ret

0000000000000480 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 480:	7139                	addi	sp,sp,-64
 482:	fc06                	sd	ra,56(sp)
 484:	f822                	sd	s0,48(sp)
 486:	f426                	sd	s1,40(sp)
 488:	f04a                	sd	s2,32(sp)
 48a:	ec4e                	sd	s3,24(sp)
 48c:	0080                	addi	s0,sp,64
 48e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 490:	c299                	beqz	a3,496 <printint+0x16>
 492:	0805c863          	bltz	a1,522 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 496:	2581                	sext.w	a1,a1
  neg = 0;
 498:	4881                	li	a7,0
 49a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 49e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a0:	2601                	sext.w	a2,a2
 4a2:	00000517          	auipc	a0,0x0
 4a6:	4f650513          	addi	a0,a0,1270 # 998 <digits>
 4aa:	883a                	mv	a6,a4
 4ac:	2705                	addiw	a4,a4,1
 4ae:	02c5f7bb          	remuw	a5,a1,a2
 4b2:	1782                	slli	a5,a5,0x20
 4b4:	9381                	srli	a5,a5,0x20
 4b6:	97aa                	add	a5,a5,a0
 4b8:	0007c783          	lbu	a5,0(a5) # 1000 <__BSS_END__+0x610>
 4bc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c0:	0005879b          	sext.w	a5,a1
 4c4:	02c5d5bb          	divuw	a1,a1,a2
 4c8:	0685                	addi	a3,a3,1
 4ca:	fec7f0e3          	bgeu	a5,a2,4aa <printint+0x2a>
  if(neg)
 4ce:	00088b63          	beqz	a7,4e4 <printint+0x64>
    buf[i++] = '-';
 4d2:	fd040793          	addi	a5,s0,-48
 4d6:	973e                	add	a4,a4,a5
 4d8:	02d00793          	li	a5,45
 4dc:	fef70823          	sb	a5,-16(a4)
 4e0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4e4:	02e05863          	blez	a4,514 <printint+0x94>
 4e8:	fc040793          	addi	a5,s0,-64
 4ec:	00e78933          	add	s2,a5,a4
 4f0:	fff78993          	addi	s3,a5,-1
 4f4:	99ba                	add	s3,s3,a4
 4f6:	377d                	addiw	a4,a4,-1
 4f8:	1702                	slli	a4,a4,0x20
 4fa:	9301                	srli	a4,a4,0x20
 4fc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 500:	fff94583          	lbu	a1,-1(s2)
 504:	8526                	mv	a0,s1
 506:	00000097          	auipc	ra,0x0
 50a:	f58080e7          	jalr	-168(ra) # 45e <putc>
  while(--i >= 0)
 50e:	197d                	addi	s2,s2,-1
 510:	ff3918e3          	bne	s2,s3,500 <printint+0x80>
}
 514:	70e2                	ld	ra,56(sp)
 516:	7442                	ld	s0,48(sp)
 518:	74a2                	ld	s1,40(sp)
 51a:	7902                	ld	s2,32(sp)
 51c:	69e2                	ld	s3,24(sp)
 51e:	6121                	addi	sp,sp,64
 520:	8082                	ret
    x = -xx;
 522:	40b005bb          	negw	a1,a1
    neg = 1;
 526:	4885                	li	a7,1
    x = -xx;
 528:	bf8d                	j	49a <printint+0x1a>

000000000000052a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 52a:	7119                	addi	sp,sp,-128
 52c:	fc86                	sd	ra,120(sp)
 52e:	f8a2                	sd	s0,112(sp)
 530:	f4a6                	sd	s1,104(sp)
 532:	f0ca                	sd	s2,96(sp)
 534:	ecce                	sd	s3,88(sp)
 536:	e8d2                	sd	s4,80(sp)
 538:	e4d6                	sd	s5,72(sp)
 53a:	e0da                	sd	s6,64(sp)
 53c:	fc5e                	sd	s7,56(sp)
 53e:	f862                	sd	s8,48(sp)
 540:	f466                	sd	s9,40(sp)
 542:	f06a                	sd	s10,32(sp)
 544:	ec6e                	sd	s11,24(sp)
 546:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 548:	0005c903          	lbu	s2,0(a1)
 54c:	18090f63          	beqz	s2,6ea <vprintf+0x1c0>
 550:	8aaa                	mv	s5,a0
 552:	8b32                	mv	s6,a2
 554:	00158493          	addi	s1,a1,1
  state = 0;
 558:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 55a:	02500a13          	li	s4,37
      if(c == 'd'){
 55e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 562:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 566:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 56a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 56e:	00000b97          	auipc	s7,0x0
 572:	42ab8b93          	addi	s7,s7,1066 # 998 <digits>
 576:	a839                	j	594 <vprintf+0x6a>
        putc(fd, c);
 578:	85ca                	mv	a1,s2
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	ee2080e7          	jalr	-286(ra) # 45e <putc>
 584:	a019                	j	58a <vprintf+0x60>
    } else if(state == '%'){
 586:	01498f63          	beq	s3,s4,5a4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 58a:	0485                	addi	s1,s1,1
 58c:	fff4c903          	lbu	s2,-1(s1)
 590:	14090d63          	beqz	s2,6ea <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 594:	0009079b          	sext.w	a5,s2
    if(state == 0){
 598:	fe0997e3          	bnez	s3,586 <vprintf+0x5c>
      if(c == '%'){
 59c:	fd479ee3          	bne	a5,s4,578 <vprintf+0x4e>
        state = '%';
 5a0:	89be                	mv	s3,a5
 5a2:	b7e5                	j	58a <vprintf+0x60>
      if(c == 'd'){
 5a4:	05878063          	beq	a5,s8,5e4 <vprintf+0xba>
      } else if(c == 'l') {
 5a8:	05978c63          	beq	a5,s9,600 <vprintf+0xd6>
      } else if(c == 'x') {
 5ac:	07a78863          	beq	a5,s10,61c <vprintf+0xf2>
      } else if(c == 'p') {
 5b0:	09b78463          	beq	a5,s11,638 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5b4:	07300713          	li	a4,115
 5b8:	0ce78663          	beq	a5,a4,684 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5bc:	06300713          	li	a4,99
 5c0:	0ee78e63          	beq	a5,a4,6bc <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5c4:	11478863          	beq	a5,s4,6d4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5c8:	85d2                	mv	a1,s4
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	e92080e7          	jalr	-366(ra) # 45e <putc>
        putc(fd, c);
 5d4:	85ca                	mv	a1,s2
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e86080e7          	jalr	-378(ra) # 45e <putc>
      }
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b765                	j	58a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5e4:	008b0913          	addi	s2,s6,8
 5e8:	4685                	li	a3,1
 5ea:	4629                	li	a2,10
 5ec:	000b2583          	lw	a1,0(s6)
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	e8e080e7          	jalr	-370(ra) # 480 <printint>
 5fa:	8b4a                	mv	s6,s2
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b771                	j	58a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 600:	008b0913          	addi	s2,s6,8
 604:	4681                	li	a3,0
 606:	4629                	li	a2,10
 608:	000b2583          	lw	a1,0(s6)
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	e72080e7          	jalr	-398(ra) # 480 <printint>
 616:	8b4a                	mv	s6,s2
      state = 0;
 618:	4981                	li	s3,0
 61a:	bf85                	j	58a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 61c:	008b0913          	addi	s2,s6,8
 620:	4681                	li	a3,0
 622:	4641                	li	a2,16
 624:	000b2583          	lw	a1,0(s6)
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	e56080e7          	jalr	-426(ra) # 480 <printint>
 632:	8b4a                	mv	s6,s2
      state = 0;
 634:	4981                	li	s3,0
 636:	bf91                	j	58a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 638:	008b0793          	addi	a5,s6,8
 63c:	f8f43423          	sd	a5,-120(s0)
 640:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 644:	03000593          	li	a1,48
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	e14080e7          	jalr	-492(ra) # 45e <putc>
  putc(fd, 'x');
 652:	85ea                	mv	a1,s10
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	e08080e7          	jalr	-504(ra) # 45e <putc>
 65e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 660:	03c9d793          	srli	a5,s3,0x3c
 664:	97de                	add	a5,a5,s7
 666:	0007c583          	lbu	a1,0(a5)
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	df2080e7          	jalr	-526(ra) # 45e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 674:	0992                	slli	s3,s3,0x4
 676:	397d                	addiw	s2,s2,-1
 678:	fe0914e3          	bnez	s2,660 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 67c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 680:	4981                	li	s3,0
 682:	b721                	j	58a <vprintf+0x60>
        s = va_arg(ap, char*);
 684:	008b0993          	addi	s3,s6,8
 688:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 68c:	02090163          	beqz	s2,6ae <vprintf+0x184>
        while(*s != 0){
 690:	00094583          	lbu	a1,0(s2)
 694:	c9a1                	beqz	a1,6e4 <vprintf+0x1ba>
          putc(fd, *s);
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	dc6080e7          	jalr	-570(ra) # 45e <putc>
          s++;
 6a0:	0905                	addi	s2,s2,1
        while(*s != 0){
 6a2:	00094583          	lbu	a1,0(s2)
 6a6:	f9e5                	bnez	a1,696 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6a8:	8b4e                	mv	s6,s3
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bdf9                	j	58a <vprintf+0x60>
          s = "(null)";
 6ae:	00000917          	auipc	s2,0x0
 6b2:	2da90913          	addi	s2,s2,730 # 988 <malloc+0x13c>
        while(*s != 0){
 6b6:	02800593          	li	a1,40
 6ba:	bff1                	j	696 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6bc:	008b0913          	addi	s2,s6,8
 6c0:	000b4583          	lbu	a1,0(s6)
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	d98080e7          	jalr	-616(ra) # 45e <putc>
 6ce:	8b4a                	mv	s6,s2
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bd65                	j	58a <vprintf+0x60>
        putc(fd, c);
 6d4:	85d2                	mv	a1,s4
 6d6:	8556                	mv	a0,s5
 6d8:	00000097          	auipc	ra,0x0
 6dc:	d86080e7          	jalr	-634(ra) # 45e <putc>
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	b565                	j	58a <vprintf+0x60>
        s = va_arg(ap, char*);
 6e4:	8b4e                	mv	s6,s3
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	b54d                	j	58a <vprintf+0x60>
    }
  }
}
 6ea:	70e6                	ld	ra,120(sp)
 6ec:	7446                	ld	s0,112(sp)
 6ee:	74a6                	ld	s1,104(sp)
 6f0:	7906                	ld	s2,96(sp)
 6f2:	69e6                	ld	s3,88(sp)
 6f4:	6a46                	ld	s4,80(sp)
 6f6:	6aa6                	ld	s5,72(sp)
 6f8:	6b06                	ld	s6,64(sp)
 6fa:	7be2                	ld	s7,56(sp)
 6fc:	7c42                	ld	s8,48(sp)
 6fe:	7ca2                	ld	s9,40(sp)
 700:	7d02                	ld	s10,32(sp)
 702:	6de2                	ld	s11,24(sp)
 704:	6109                	addi	sp,sp,128
 706:	8082                	ret

0000000000000708 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 708:	715d                	addi	sp,sp,-80
 70a:	ec06                	sd	ra,24(sp)
 70c:	e822                	sd	s0,16(sp)
 70e:	1000                	addi	s0,sp,32
 710:	e010                	sd	a2,0(s0)
 712:	e414                	sd	a3,8(s0)
 714:	e818                	sd	a4,16(s0)
 716:	ec1c                	sd	a5,24(s0)
 718:	03043023          	sd	a6,32(s0)
 71c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 720:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 724:	8622                	mv	a2,s0
 726:	00000097          	auipc	ra,0x0
 72a:	e04080e7          	jalr	-508(ra) # 52a <vprintf>
}
 72e:	60e2                	ld	ra,24(sp)
 730:	6442                	ld	s0,16(sp)
 732:	6161                	addi	sp,sp,80
 734:	8082                	ret

0000000000000736 <printf>:

void
printf(const char *fmt, ...)
{
 736:	7159                	addi	sp,sp,-112
 738:	f406                	sd	ra,40(sp)
 73a:	f022                	sd	s0,32(sp)
 73c:	ec26                	sd	s1,24(sp)
 73e:	e84a                	sd	s2,16(sp)
 740:	1800                	addi	s0,sp,48
 742:	84aa                	mv	s1,a0
 744:	e40c                	sd	a1,8(s0)
 746:	e810                	sd	a2,16(s0)
 748:	ec14                	sd	a3,24(s0)
 74a:	f018                	sd	a4,32(s0)
 74c:	f41c                	sd	a5,40(s0)
 74e:	03043823          	sd	a6,48(s0)
 752:	03143c23          	sd	a7,56(s0)
  va_list ap;
  lock_acquire(&pr.printf_lock);
 756:	00000917          	auipc	s2,0x0
 75a:	27290913          	addi	s2,s2,626 # 9c8 <pr>
 75e:	854a                	mv	a0,s2
 760:	00000097          	auipc	ra,0x0
 764:	b88080e7          	jalr	-1144(ra) # 2e8 <lock_acquire>

  va_start(ap, fmt);
 768:	00840613          	addi	a2,s0,8
 76c:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 770:	85a6                	mv	a1,s1
 772:	4505                	li	a0,1
 774:	00000097          	auipc	ra,0x0
 778:	db6080e7          	jalr	-586(ra) # 52a <vprintf>
  
  lock_release(&pr.printf_lock);
 77c:	854a                	mv	a0,s2
 77e:	00000097          	auipc	ra,0x0
 782:	b8a080e7          	jalr	-1142(ra) # 308 <lock_release>

}
 786:	70a2                	ld	ra,40(sp)
 788:	7402                	ld	s0,32(sp)
 78a:	64e2                	ld	s1,24(sp)
 78c:	6942                	ld	s2,16(sp)
 78e:	6165                	addi	sp,sp,112
 790:	8082                	ret

0000000000000792 <printfinit>:

void
printfinit(void)
{
 792:	1101                	addi	sp,sp,-32
 794:	ec06                	sd	ra,24(sp)
 796:	e822                	sd	s0,16(sp)
 798:	e426                	sd	s1,8(sp)
 79a:	1000                	addi	s0,sp,32
  lock_init(&pr.printf_lock, "pr");
 79c:	00000497          	auipc	s1,0x0
 7a0:	22c48493          	addi	s1,s1,556 # 9c8 <pr>
 7a4:	00000597          	auipc	a1,0x0
 7a8:	1ec58593          	addi	a1,a1,492 # 990 <malloc+0x144>
 7ac:	8526                	mv	a0,s1
 7ae:	00000097          	auipc	ra,0x0
 7b2:	b28080e7          	jalr	-1240(ra) # 2d6 <lock_init>
  pr.locking = 1;
 7b6:	4785                	li	a5,1
 7b8:	c89c                	sw	a5,16(s1)
}
 7ba:	60e2                	ld	ra,24(sp)
 7bc:	6442                	ld	s0,16(sp)
 7be:	64a2                	ld	s1,8(sp)
 7c0:	6105                	addi	sp,sp,32
 7c2:	8082                	ret

00000000000007c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c4:	1141                	addi	sp,sp,-16
 7c6:	e422                	sd	s0,8(sp)
 7c8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ca:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ce:	00000797          	auipc	a5,0x0
 7d2:	1f27b783          	ld	a5,498(a5) # 9c0 <freep>
 7d6:	a805                	j	806 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7d8:	4618                	lw	a4,8(a2)
 7da:	9db9                	addw	a1,a1,a4
 7dc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e0:	6398                	ld	a4,0(a5)
 7e2:	6318                	ld	a4,0(a4)
 7e4:	fee53823          	sd	a4,-16(a0)
 7e8:	a091                	j	82c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ea:	ff852703          	lw	a4,-8(a0)
 7ee:	9e39                	addw	a2,a2,a4
 7f0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7f2:	ff053703          	ld	a4,-16(a0)
 7f6:	e398                	sd	a4,0(a5)
 7f8:	a099                	j	83e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fa:	6398                	ld	a4,0(a5)
 7fc:	00e7e463          	bltu	a5,a4,804 <free+0x40>
 800:	00e6ea63          	bltu	a3,a4,814 <free+0x50>
{
 804:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 806:	fed7fae3          	bgeu	a5,a3,7fa <free+0x36>
 80a:	6398                	ld	a4,0(a5)
 80c:	00e6e463          	bltu	a3,a4,814 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 810:	fee7eae3          	bltu	a5,a4,804 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 814:	ff852583          	lw	a1,-8(a0)
 818:	6390                	ld	a2,0(a5)
 81a:	02059713          	slli	a4,a1,0x20
 81e:	9301                	srli	a4,a4,0x20
 820:	0712                	slli	a4,a4,0x4
 822:	9736                	add	a4,a4,a3
 824:	fae60ae3          	beq	a2,a4,7d8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 828:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 82c:	4790                	lw	a2,8(a5)
 82e:	02061713          	slli	a4,a2,0x20
 832:	9301                	srli	a4,a4,0x20
 834:	0712                	slli	a4,a4,0x4
 836:	973e                	add	a4,a4,a5
 838:	fae689e3          	beq	a3,a4,7ea <free+0x26>
  } else
    p->s.ptr = bp;
 83c:	e394                	sd	a3,0(a5)
  freep = p;
 83e:	00000717          	auipc	a4,0x0
 842:	18f73123          	sd	a5,386(a4) # 9c0 <freep>
}
 846:	6422                	ld	s0,8(sp)
 848:	0141                	addi	sp,sp,16
 84a:	8082                	ret

000000000000084c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 84c:	7139                	addi	sp,sp,-64
 84e:	fc06                	sd	ra,56(sp)
 850:	f822                	sd	s0,48(sp)
 852:	f426                	sd	s1,40(sp)
 854:	f04a                	sd	s2,32(sp)
 856:	ec4e                	sd	s3,24(sp)
 858:	e852                	sd	s4,16(sp)
 85a:	e456                	sd	s5,8(sp)
 85c:	e05a                	sd	s6,0(sp)
 85e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 860:	02051493          	slli	s1,a0,0x20
 864:	9081                	srli	s1,s1,0x20
 866:	04bd                	addi	s1,s1,15
 868:	8091                	srli	s1,s1,0x4
 86a:	0014899b          	addiw	s3,s1,1
 86e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 870:	00000517          	auipc	a0,0x0
 874:	15053503          	ld	a0,336(a0) # 9c0 <freep>
 878:	c515                	beqz	a0,8a4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87c:	4798                	lw	a4,8(a5)
 87e:	02977f63          	bgeu	a4,s1,8bc <malloc+0x70>
 882:	8a4e                	mv	s4,s3
 884:	0009871b          	sext.w	a4,s3
 888:	6685                	lui	a3,0x1
 88a:	00d77363          	bgeu	a4,a3,890 <malloc+0x44>
 88e:	6a05                	lui	s4,0x1
 890:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 894:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 898:	00000917          	auipc	s2,0x0
 89c:	12890913          	addi	s2,s2,296 # 9c0 <freep>
  if(p == (char*)-1)
 8a0:	5afd                	li	s5,-1
 8a2:	a88d                	j	914 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8a4:	00000797          	auipc	a5,0x0
 8a8:	13c78793          	addi	a5,a5,316 # 9e0 <base>
 8ac:	00000717          	auipc	a4,0x0
 8b0:	10f73a23          	sd	a5,276(a4) # 9c0 <freep>
 8b4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ba:	b7e1                	j	882 <malloc+0x36>
      if(p->s.size == nunits)
 8bc:	02e48b63          	beq	s1,a4,8f2 <malloc+0xa6>
        p->s.size -= nunits;
 8c0:	4137073b          	subw	a4,a4,s3
 8c4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c6:	1702                	slli	a4,a4,0x20
 8c8:	9301                	srli	a4,a4,0x20
 8ca:	0712                	slli	a4,a4,0x4
 8cc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ce:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8d2:	00000717          	auipc	a4,0x0
 8d6:	0ea73723          	sd	a0,238(a4) # 9c0 <freep>
      return (void*)(p + 1);
 8da:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8de:	70e2                	ld	ra,56(sp)
 8e0:	7442                	ld	s0,48(sp)
 8e2:	74a2                	ld	s1,40(sp)
 8e4:	7902                	ld	s2,32(sp)
 8e6:	69e2                	ld	s3,24(sp)
 8e8:	6a42                	ld	s4,16(sp)
 8ea:	6aa2                	ld	s5,8(sp)
 8ec:	6b02                	ld	s6,0(sp)
 8ee:	6121                	addi	sp,sp,64
 8f0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8f2:	6398                	ld	a4,0(a5)
 8f4:	e118                	sd	a4,0(a0)
 8f6:	bff1                	j	8d2 <malloc+0x86>
  hp->s.size = nu;
 8f8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8fc:	0541                	addi	a0,a0,16
 8fe:	00000097          	auipc	ra,0x0
 902:	ec6080e7          	jalr	-314(ra) # 7c4 <free>
  return freep;
 906:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 90a:	d971                	beqz	a0,8de <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 90e:	4798                	lw	a4,8(a5)
 910:	fa9776e3          	bgeu	a4,s1,8bc <malloc+0x70>
    if(p == freep)
 914:	00093703          	ld	a4,0(s2)
 918:	853e                	mv	a0,a5
 91a:	fef719e3          	bne	a4,a5,90c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 91e:	8552                	mv	a0,s4
 920:	00000097          	auipc	ra,0x0
 924:	b16080e7          	jalr	-1258(ra) # 436 <sbrk>
  if(p == (char*)-1)
 928:	fd5518e3          	bne	a0,s5,8f8 <malloc+0xac>
        return 0;
 92c:	4501                	li	a0,0
 92e:	bf45                	j	8de <malloc+0x92>
