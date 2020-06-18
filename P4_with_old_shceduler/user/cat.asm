
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	9c890913          	addi	s2,s2,-1592 # 9d8 <buf>
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	3d6080e7          	jalr	982(ra) # 3f6 <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05863          	blez	a0,5a <cat+0x5a>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	3ca080e7          	jalr	970(ra) # 3fe <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      printf("cat: write error\n");
  40:	00001517          	auipc	a0,0x1
  44:	92050513          	addi	a0,a0,-1760 # 960 <malloc+0xe4>
  48:	00000097          	auipc	ra,0x0
  4c:	71e080e7          	jalr	1822(ra) # 766 <printf>
      exit(1);
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	38c080e7          	jalr	908(ra) # 3de <exit>
    }
  }
  if(n < 0){
  5a:	00054963          	bltz	a0,6c <cat+0x6c>
    printf("cat: read error\n");
    exit(1);
  }
}
  5e:	70a2                	ld	ra,40(sp)
  60:	7402                	ld	s0,32(sp)
  62:	64e2                	ld	s1,24(sp)
  64:	6942                	ld	s2,16(sp)
  66:	69a2                	ld	s3,8(sp)
  68:	6145                	addi	sp,sp,48
  6a:	8082                	ret
    printf("cat: read error\n");
  6c:	00001517          	auipc	a0,0x1
  70:	90c50513          	addi	a0,a0,-1780 # 978 <malloc+0xfc>
  74:	00000097          	auipc	ra,0x0
  78:	6f2080e7          	jalr	1778(ra) # 766 <printf>
    exit(1);
  7c:	4505                	li	a0,1
  7e:	00000097          	auipc	ra,0x0
  82:	360080e7          	jalr	864(ra) # 3de <exit>

0000000000000086 <main>:

int
main(int argc, char *argv[])
{
  86:	7179                	addi	sp,sp,-48
  88:	f406                	sd	ra,40(sp)
  8a:	f022                	sd	s0,32(sp)
  8c:	ec26                	sd	s1,24(sp)
  8e:	e84a                	sd	s2,16(sp)
  90:	e44e                	sd	s3,8(sp)
  92:	e052                	sd	s4,0(sp)
  94:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  96:	4785                	li	a5,1
  98:	04a7d763          	bge	a5,a0,e6 <main+0x60>
  9c:	00858913          	addi	s2,a1,8
  a0:	ffe5099b          	addiw	s3,a0,-2
  a4:	1982                	slli	s3,s3,0x20
  a6:	0209d993          	srli	s3,s3,0x20
  aa:	098e                	slli	s3,s3,0x3
  ac:	05c1                	addi	a1,a1,16
  ae:	99ae                	add	s3,s3,a1
    cat(0);
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b0:	4581                	li	a1,0
  b2:	00093503          	ld	a0,0(s2)
  b6:	00000097          	auipc	ra,0x0
  ba:	368080e7          	jalr	872(ra) # 41e <open>
  be:	84aa                	mv	s1,a0
  c0:	02054d63          	bltz	a0,fa <main+0x74>
      printf("cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c4:	00000097          	auipc	ra,0x0
  c8:	f3c080e7          	jalr	-196(ra) # 0 <cat>
    close(fd);
  cc:	8526                	mv	a0,s1
  ce:	00000097          	auipc	ra,0x0
  d2:	338080e7          	jalr	824(ra) # 406 <close>
  for(i = 1; i < argc; i++){
  d6:	0921                	addi	s2,s2,8
  d8:	fd391ce3          	bne	s2,s3,b0 <main+0x2a>
  }
  exit(0);
  dc:	4501                	li	a0,0
  de:	00000097          	auipc	ra,0x0
  e2:	300080e7          	jalr	768(ra) # 3de <exit>
    cat(0);
  e6:	4501                	li	a0,0
  e8:	00000097          	auipc	ra,0x0
  ec:	f18080e7          	jalr	-232(ra) # 0 <cat>
    exit(1);
  f0:	4505                	li	a0,1
  f2:	00000097          	auipc	ra,0x0
  f6:	2ec080e7          	jalr	748(ra) # 3de <exit>
      printf("cat: cannot open %s\n", argv[i]);
  fa:	00093583          	ld	a1,0(s2)
  fe:	00001517          	auipc	a0,0x1
 102:	89250513          	addi	a0,a0,-1902 # 990 <malloc+0x114>
 106:	00000097          	auipc	ra,0x0
 10a:	660080e7          	jalr	1632(ra) # 766 <printf>
      exit(1);
 10e:	4505                	li	a0,1
 110:	00000097          	auipc	ra,0x0
 114:	2ce080e7          	jalr	718(ra) # 3de <exit>

0000000000000118 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11e:	87aa                	mv	a5,a0
 120:	0585                	addi	a1,a1,1
 122:	0785                	addi	a5,a5,1
 124:	fff5c703          	lbu	a4,-1(a1)
 128:	fee78fa3          	sb	a4,-1(a5)
 12c:	fb75                	bnez	a4,120 <strcpy+0x8>
    ;
  return os;
}
 12e:	6422                	ld	s0,8(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret

0000000000000134 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 134:	1141                	addi	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cb91                	beqz	a5,152 <strcmp+0x1e>
 140:	0005c703          	lbu	a4,0(a1)
 144:	00f71763          	bne	a4,a5,152 <strcmp+0x1e>
    p++, q++;
 148:	0505                	addi	a0,a0,1
 14a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 14c:	00054783          	lbu	a5,0(a0)
 150:	fbe5                	bnez	a5,140 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 152:	0005c503          	lbu	a0,0(a1)
}
 156:	40a7853b          	subw	a0,a5,a0
 15a:	6422                	ld	s0,8(sp)
 15c:	0141                	addi	sp,sp,16
 15e:	8082                	ret

0000000000000160 <strlen>:

uint
strlen(const char *s)
{
 160:	1141                	addi	sp,sp,-16
 162:	e422                	sd	s0,8(sp)
 164:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 166:	00054783          	lbu	a5,0(a0)
 16a:	cf91                	beqz	a5,186 <strlen+0x26>
 16c:	0505                	addi	a0,a0,1
 16e:	87aa                	mv	a5,a0
 170:	4685                	li	a3,1
 172:	9e89                	subw	a3,a3,a0
 174:	00f6853b          	addw	a0,a3,a5
 178:	0785                	addi	a5,a5,1
 17a:	fff7c703          	lbu	a4,-1(a5)
 17e:	fb7d                	bnez	a4,174 <strlen+0x14>
    ;
  return n;
}
 180:	6422                	ld	s0,8(sp)
 182:	0141                	addi	sp,sp,16
 184:	8082                	ret
  for(n = 0; s[n]; n++)
 186:	4501                	li	a0,0
 188:	bfe5                	j	180 <strlen+0x20>

000000000000018a <memset>:

void*
memset(void *dst, int c, uint n)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 190:	ce09                	beqz	a2,1aa <memset+0x20>
 192:	87aa                	mv	a5,a0
 194:	fff6071b          	addiw	a4,a2,-1
 198:	1702                	slli	a4,a4,0x20
 19a:	9301                	srli	a4,a4,0x20
 19c:	0705                	addi	a4,a4,1
 19e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1a0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a4:	0785                	addi	a5,a5,1
 1a6:	fee79de3          	bne	a5,a4,1a0 <memset+0x16>
  }
  return dst;
}
 1aa:	6422                	ld	s0,8(sp)
 1ac:	0141                	addi	sp,sp,16
 1ae:	8082                	ret

00000000000001b0 <strchr>:

char*
strchr(const char *s, char c)
{
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	cb99                	beqz	a5,1d0 <strchr+0x20>
    if(*s == c)
 1bc:	00f58763          	beq	a1,a5,1ca <strchr+0x1a>
  for(; *s; s++)
 1c0:	0505                	addi	a0,a0,1
 1c2:	00054783          	lbu	a5,0(a0)
 1c6:	fbfd                	bnez	a5,1bc <strchr+0xc>
      return (char*)s;
  return 0;
 1c8:	4501                	li	a0,0
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret
  return 0;
 1d0:	4501                	li	a0,0
 1d2:	bfe5                	j	1ca <strchr+0x1a>

00000000000001d4 <gets>:

char*
gets(char *buf, int max)
{
 1d4:	711d                	addi	sp,sp,-96
 1d6:	ec86                	sd	ra,88(sp)
 1d8:	e8a2                	sd	s0,80(sp)
 1da:	e4a6                	sd	s1,72(sp)
 1dc:	e0ca                	sd	s2,64(sp)
 1de:	fc4e                	sd	s3,56(sp)
 1e0:	f852                	sd	s4,48(sp)
 1e2:	f456                	sd	s5,40(sp)
 1e4:	f05a                	sd	s6,32(sp)
 1e6:	ec5e                	sd	s7,24(sp)
 1e8:	1080                	addi	s0,sp,96
 1ea:	8baa                	mv	s7,a0
 1ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ee:	892a                	mv	s2,a0
 1f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f2:	4aa9                	li	s5,10
 1f4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1f6:	89a6                	mv	s3,s1
 1f8:	2485                	addiw	s1,s1,1
 1fa:	0344d863          	bge	s1,s4,22a <gets+0x56>
    cc = read(0, &c, 1);
 1fe:	4605                	li	a2,1
 200:	faf40593          	addi	a1,s0,-81
 204:	4501                	li	a0,0
 206:	00000097          	auipc	ra,0x0
 20a:	1f0080e7          	jalr	496(ra) # 3f6 <read>
    if(cc < 1)
 20e:	00a05e63          	blez	a0,22a <gets+0x56>
    buf[i++] = c;
 212:	faf44783          	lbu	a5,-81(s0)
 216:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21a:	01578763          	beq	a5,s5,228 <gets+0x54>
 21e:	0905                	addi	s2,s2,1
 220:	fd679be3          	bne	a5,s6,1f6 <gets+0x22>
  for(i=0; i+1 < max; ){
 224:	89a6                	mv	s3,s1
 226:	a011                	j	22a <gets+0x56>
 228:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 22a:	99de                	add	s3,s3,s7
 22c:	00098023          	sb	zero,0(s3)
  return buf;
}
 230:	855e                	mv	a0,s7
 232:	60e6                	ld	ra,88(sp)
 234:	6446                	ld	s0,80(sp)
 236:	64a6                	ld	s1,72(sp)
 238:	6906                	ld	s2,64(sp)
 23a:	79e2                	ld	s3,56(sp)
 23c:	7a42                	ld	s4,48(sp)
 23e:	7aa2                	ld	s5,40(sp)
 240:	7b02                	ld	s6,32(sp)
 242:	6be2                	ld	s7,24(sp)
 244:	6125                	addi	sp,sp,96
 246:	8082                	ret

0000000000000248 <stat>:

int
stat(const char *n, struct stat *st)
{
 248:	1101                	addi	sp,sp,-32
 24a:	ec06                	sd	ra,24(sp)
 24c:	e822                	sd	s0,16(sp)
 24e:	e426                	sd	s1,8(sp)
 250:	e04a                	sd	s2,0(sp)
 252:	1000                	addi	s0,sp,32
 254:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 256:	4581                	li	a1,0
 258:	00000097          	auipc	ra,0x0
 25c:	1c6080e7          	jalr	454(ra) # 41e <open>
  if(fd < 0)
 260:	02054563          	bltz	a0,28a <stat+0x42>
 264:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 266:	85ca                	mv	a1,s2
 268:	00000097          	auipc	ra,0x0
 26c:	1ce080e7          	jalr	462(ra) # 436 <fstat>
 270:	892a                	mv	s2,a0
  close(fd);
 272:	8526                	mv	a0,s1
 274:	00000097          	auipc	ra,0x0
 278:	192080e7          	jalr	402(ra) # 406 <close>
  return r;
}
 27c:	854a                	mv	a0,s2
 27e:	60e2                	ld	ra,24(sp)
 280:	6442                	ld	s0,16(sp)
 282:	64a2                	ld	s1,8(sp)
 284:	6902                	ld	s2,0(sp)
 286:	6105                	addi	sp,sp,32
 288:	8082                	ret
    return -1;
 28a:	597d                	li	s2,-1
 28c:	bfc5                	j	27c <stat+0x34>

000000000000028e <atoi>:

int
atoi(const char *s)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 294:	00054603          	lbu	a2,0(a0)
 298:	fd06079b          	addiw	a5,a2,-48
 29c:	0ff7f793          	andi	a5,a5,255
 2a0:	4725                	li	a4,9
 2a2:	02f76963          	bltu	a4,a5,2d4 <atoi+0x46>
 2a6:	86aa                	mv	a3,a0
  n = 0;
 2a8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2aa:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2ac:	0685                	addi	a3,a3,1
 2ae:	0025179b          	slliw	a5,a0,0x2
 2b2:	9fa9                	addw	a5,a5,a0
 2b4:	0017979b          	slliw	a5,a5,0x1
 2b8:	9fb1                	addw	a5,a5,a2
 2ba:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2be:	0006c603          	lbu	a2,0(a3)
 2c2:	fd06071b          	addiw	a4,a2,-48
 2c6:	0ff77713          	andi	a4,a4,255
 2ca:	fee5f1e3          	bgeu	a1,a4,2ac <atoi+0x1e>
  return n;
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
  n = 0;
 2d4:	4501                	li	a0,0
 2d6:	bfe5                	j	2ce <atoi+0x40>

00000000000002d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2de:	02c05163          	blez	a2,300 <memmove+0x28>
 2e2:	fff6071b          	addiw	a4,a2,-1
 2e6:	1702                	slli	a4,a4,0x20
 2e8:	9301                	srli	a4,a4,0x20
 2ea:	0705                	addi	a4,a4,1
 2ec:	972a                	add	a4,a4,a0
  dst = vdst;
 2ee:	87aa                	mv	a5,a0
    *dst++ = *src++;
 2f0:	0585                	addi	a1,a1,1
 2f2:	0785                	addi	a5,a5,1
 2f4:	fff5c683          	lbu	a3,-1(a1)
 2f8:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 2fc:	fee79ae3          	bne	a5,a4,2f0 <memmove+0x18>
  return vdst;
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <lock_init>:

void lock_init(lock_t *l, char *name) {
 306:	1141                	addi	sp,sp,-16
 308:	e422                	sd	s0,8(sp)
 30a:	0800                	addi	s0,sp,16
 l->name = name;
 30c:	e10c                	sd	a1,0(a0)
 l->locked = 0;
 30e:	00052423          	sw	zero,8(a0)
 //l->guard = 0;
}
 312:	6422                	ld	s0,8(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <lock_acquire>:

void lock_acquire(lock_t *l) {
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  while(__sync_lock_test_and_set(&l->locked, 1) != 0)
 31e:	4705                	li	a4,1
 320:	87ba                	mv	a5,a4
 322:	00850693          	addi	a3,a0,8
 326:	0cf6a7af          	amoswap.w.aq	a5,a5,(a3)
 32a:	2781                	sext.w	a5,a5
 32c:	fbf5                	bnez	a5,320 <lock_acquire+0x8>
    ;
  __sync_synchronize();
 32e:	0ff0000f          	fence
}
 332:	6422                	ld	s0,8(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret

0000000000000338 <lock_release>:

void lock_release(lock_t *l) {
 338:	1141                	addi	sp,sp,-16
 33a:	e422                	sd	s0,8(sp)
 33c:	0800                	addi	s0,sp,16
  __sync_synchronize();
 33e:	0ff0000f          	fence
  __sync_lock_release(&l->locked);
 342:	00850793          	addi	a5,a0,8
 346:	0f50000f          	fence	iorw,ow
 34a:	0807a02f          	amoswap.w	zero,zero,(a5)
//  l->locked = 0;
}
 34e:	6422                	ld	s0,8(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret

0000000000000354 <thread_create>:
//    condwakeup(cond->curr);
//  }
//}
int
thread_create(void (*start_routine)(void*, void*), void *arg1, void *arg2)
{
 354:	7179                	addi	sp,sp,-48
 356:	f406                	sd	ra,40(sp)
 358:	f022                	sd	s0,32(sp)
 35a:	ec26                	sd	s1,24(sp)
 35c:	e84a                	sd	s2,16(sp)
 35e:	e44e                	sd	s3,8(sp)
 360:	1800                	addi	s0,sp,48
 362:	84aa                	mv	s1,a0
 364:	892e                	mv	s2,a1
 366:	89b2                	mv	s3,a2
  void *stack = malloc(PGSIZE*2); //allocate space on the heap, should be 1 page in size and pagesize aligned
 368:	6509                	lui	a0,0x2
 36a:	00000097          	auipc	ra,0x0
 36e:	512080e7          	jalr	1298(ra) # 87c <malloc>
 372:	86aa                	mv	a3,a0
  if((uint64)stack % PGSIZE) { //not aligned
 374:	03451793          	slli	a5,a0,0x34
 378:	c799                	beqz	a5,386 <thread_create+0x32>
 37a:	0347d713          	srli	a4,a5,0x34
    stack = stack + (PGSIZE - (uint64)stack % PGSIZE); //make is pagesize aligned
 37e:	6785                	lui	a5,0x1
 380:	8f99                	sub	a5,a5,a4
 382:	00f506b3          	add	a3,a0,a5
  }
  int pid = clone(start_routine, arg1, arg2, stack);
 386:	864e                	mv	a2,s3
 388:	85ca                	mv	a1,s2
 38a:	8526                	mv	a0,s1
 38c:	00000097          	auipc	ra,0x0
 390:	0f2080e7          	jalr	242(ra) # 47e <clone>
  return pid;
}
 394:	70a2                	ld	ra,40(sp)
 396:	7402                	ld	s0,32(sp)
 398:	64e2                	ld	s1,24(sp)
 39a:	6942                	ld	s2,16(sp)
 39c:	69a2                	ld	s3,8(sp)
 39e:	6145                	addi	sp,sp,48
 3a0:	8082                	ret

00000000000003a2 <thread_join>:

int thread_join() {
 3a2:	7179                	addi	sp,sp,-48
 3a4:	f406                	sd	ra,40(sp)
 3a6:	f022                	sd	s0,32(sp)
 3a8:	ec26                	sd	s1,24(sp)
 3aa:	1800                	addi	s0,sp,48
  void *ustack = 0;
 3ac:	fc043c23          	sd	zero,-40(s0)
  int status = join(&ustack);
 3b0:	fd840513          	addi	a0,s0,-40
 3b4:	00000097          	auipc	ra,0x0
 3b8:	0d2080e7          	jalr	210(ra) # 486 <join>
 3bc:	84aa                	mv	s1,a0
  free(ustack);
 3be:	fd843503          	ld	a0,-40(s0)
 3c2:	00000097          	auipc	ra,0x0
 3c6:	432080e7          	jalr	1074(ra) # 7f4 <free>
  return status;
}
 3ca:	8526                	mv	a0,s1
 3cc:	70a2                	ld	ra,40(sp)
 3ce:	7402                	ld	s0,32(sp)
 3d0:	64e2                	ld	s1,24(sp)
 3d2:	6145                	addi	sp,sp,48
 3d4:	8082                	ret

00000000000003d6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3d6:	4885                	li	a7,1
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <exit>:
.global exit
exit:
 li a7, SYS_exit
 3de:	4889                	li	a7,2
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3e6:	488d                	li	a7,3
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ee:	4891                	li	a7,4
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <read>:
.global read
read:
 li a7, SYS_read
 3f6:	4895                	li	a7,5
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <write>:
.global write
write:
 li a7, SYS_write
 3fe:	48c1                	li	a7,16
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <close>:
.global close
close:
 li a7, SYS_close
 406:	48d5                	li	a7,21
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <kill>:
.global kill
kill:
 li a7, SYS_kill
 40e:	4899                	li	a7,6
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <exec>:
.global exec
exec:
 li a7, SYS_exec
 416:	489d                	li	a7,7
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <open>:
.global open
open:
 li a7, SYS_open
 41e:	48bd                	li	a7,15
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 426:	48c5                	li	a7,17
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 42e:	48c9                	li	a7,18
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 436:	48a1                	li	a7,8
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <link>:
.global link
link:
 li a7, SYS_link
 43e:	48cd                	li	a7,19
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 446:	48d1                	li	a7,20
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 44e:	48a5                	li	a7,9
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <dup>:
.global dup
dup:
 li a7, SYS_dup
 456:	48a9                	li	a7,10
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 45e:	48ad                	li	a7,11
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 466:	48b1                	li	a7,12
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 46e:	48b5                	li	a7,13
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 476:	48b9                	li	a7,14
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <clone>:
.global clone
clone:
 li a7, SYS_clone
 47e:	48d9                	li	a7,22
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <join>:
.global join
join:
 li a7, SYS_join
 486:	48dd                	li	a7,23
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <putc>:
  int type;
};

static void
putc(int fd, char c)
{
 48e:	1101                	addi	sp,sp,-32
 490:	ec06                	sd	ra,24(sp)
 492:	e822                	sd	s0,16(sp)
 494:	1000                	addi	s0,sp,32
 496:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 49a:	4605                	li	a2,1
 49c:	fef40593          	addi	a1,s0,-17
 4a0:	00000097          	auipc	ra,0x0
 4a4:	f5e080e7          	jalr	-162(ra) # 3fe <write>
}
 4a8:	60e2                	ld	ra,24(sp)
 4aa:	6442                	ld	s0,16(sp)
 4ac:	6105                	addi	sp,sp,32
 4ae:	8082                	ret

00000000000004b0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b0:	7139                	addi	sp,sp,-64
 4b2:	fc06                	sd	ra,56(sp)
 4b4:	f822                	sd	s0,48(sp)
 4b6:	f426                	sd	s1,40(sp)
 4b8:	f04a                	sd	s2,32(sp)
 4ba:	ec4e                	sd	s3,24(sp)
 4bc:	0080                	addi	s0,sp,64
 4be:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4c0:	c299                	beqz	a3,4c6 <printint+0x16>
 4c2:	0805c863          	bltz	a1,552 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c6:	2581                	sext.w	a1,a1
  neg = 0;
 4c8:	4881                	li	a7,0
 4ca:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4ce:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4d0:	2601                	sext.w	a2,a2
 4d2:	00000517          	auipc	a0,0x0
 4d6:	4e650513          	addi	a0,a0,1254 # 9b8 <digits>
 4da:	883a                	mv	a6,a4
 4dc:	2705                	addiw	a4,a4,1
 4de:	02c5f7bb          	remuw	a5,a1,a2
 4e2:	1782                	slli	a5,a5,0x20
 4e4:	9381                	srli	a5,a5,0x20
 4e6:	97aa                	add	a5,a5,a0
 4e8:	0007c783          	lbu	a5,0(a5) # 1000 <__BSS_END__+0x400>
 4ec:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4f0:	0005879b          	sext.w	a5,a1
 4f4:	02c5d5bb          	divuw	a1,a1,a2
 4f8:	0685                	addi	a3,a3,1
 4fa:	fec7f0e3          	bgeu	a5,a2,4da <printint+0x2a>
  if(neg)
 4fe:	00088b63          	beqz	a7,514 <printint+0x64>
    buf[i++] = '-';
 502:	fd040793          	addi	a5,s0,-48
 506:	973e                	add	a4,a4,a5
 508:	02d00793          	li	a5,45
 50c:	fef70823          	sb	a5,-16(a4)
 510:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 514:	02e05863          	blez	a4,544 <printint+0x94>
 518:	fc040793          	addi	a5,s0,-64
 51c:	00e78933          	add	s2,a5,a4
 520:	fff78993          	addi	s3,a5,-1
 524:	99ba                	add	s3,s3,a4
 526:	377d                	addiw	a4,a4,-1
 528:	1702                	slli	a4,a4,0x20
 52a:	9301                	srli	a4,a4,0x20
 52c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 530:	fff94583          	lbu	a1,-1(s2)
 534:	8526                	mv	a0,s1
 536:	00000097          	auipc	ra,0x0
 53a:	f58080e7          	jalr	-168(ra) # 48e <putc>
  while(--i >= 0)
 53e:	197d                	addi	s2,s2,-1
 540:	ff3918e3          	bne	s2,s3,530 <printint+0x80>
}
 544:	70e2                	ld	ra,56(sp)
 546:	7442                	ld	s0,48(sp)
 548:	74a2                	ld	s1,40(sp)
 54a:	7902                	ld	s2,32(sp)
 54c:	69e2                	ld	s3,24(sp)
 54e:	6121                	addi	sp,sp,64
 550:	8082                	ret
    x = -xx;
 552:	40b005bb          	negw	a1,a1
    neg = 1;
 556:	4885                	li	a7,1
    x = -xx;
 558:	bf8d                	j	4ca <printint+0x1a>

000000000000055a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 55a:	7119                	addi	sp,sp,-128
 55c:	fc86                	sd	ra,120(sp)
 55e:	f8a2                	sd	s0,112(sp)
 560:	f4a6                	sd	s1,104(sp)
 562:	f0ca                	sd	s2,96(sp)
 564:	ecce                	sd	s3,88(sp)
 566:	e8d2                	sd	s4,80(sp)
 568:	e4d6                	sd	s5,72(sp)
 56a:	e0da                	sd	s6,64(sp)
 56c:	fc5e                	sd	s7,56(sp)
 56e:	f862                	sd	s8,48(sp)
 570:	f466                	sd	s9,40(sp)
 572:	f06a                	sd	s10,32(sp)
 574:	ec6e                	sd	s11,24(sp)
 576:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 578:	0005c903          	lbu	s2,0(a1)
 57c:	18090f63          	beqz	s2,71a <vprintf+0x1c0>
 580:	8aaa                	mv	s5,a0
 582:	8b32                	mv	s6,a2
 584:	00158493          	addi	s1,a1,1
  state = 0;
 588:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 58a:	02500a13          	li	s4,37
      if(c == 'd'){
 58e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 592:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 596:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 59a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 59e:	00000b97          	auipc	s7,0x0
 5a2:	41ab8b93          	addi	s7,s7,1050 # 9b8 <digits>
 5a6:	a839                	j	5c4 <vprintf+0x6a>
        putc(fd, c);
 5a8:	85ca                	mv	a1,s2
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	ee2080e7          	jalr	-286(ra) # 48e <putc>
 5b4:	a019                	j	5ba <vprintf+0x60>
    } else if(state == '%'){
 5b6:	01498f63          	beq	s3,s4,5d4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5ba:	0485                	addi	s1,s1,1
 5bc:	fff4c903          	lbu	s2,-1(s1)
 5c0:	14090d63          	beqz	s2,71a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5c4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5c8:	fe0997e3          	bnez	s3,5b6 <vprintf+0x5c>
      if(c == '%'){
 5cc:	fd479ee3          	bne	a5,s4,5a8 <vprintf+0x4e>
        state = '%';
 5d0:	89be                	mv	s3,a5
 5d2:	b7e5                	j	5ba <vprintf+0x60>
      if(c == 'd'){
 5d4:	05878063          	beq	a5,s8,614 <vprintf+0xba>
      } else if(c == 'l') {
 5d8:	05978c63          	beq	a5,s9,630 <vprintf+0xd6>
      } else if(c == 'x') {
 5dc:	07a78863          	beq	a5,s10,64c <vprintf+0xf2>
      } else if(c == 'p') {
 5e0:	09b78463          	beq	a5,s11,668 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5e4:	07300713          	li	a4,115
 5e8:	0ce78663          	beq	a5,a4,6b4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ec:	06300713          	li	a4,99
 5f0:	0ee78e63          	beq	a5,a4,6ec <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5f4:	11478863          	beq	a5,s4,704 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f8:	85d2                	mv	a1,s4
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	e92080e7          	jalr	-366(ra) # 48e <putc>
        putc(fd, c);
 604:	85ca                	mv	a1,s2
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	e86080e7          	jalr	-378(ra) # 48e <putc>
      }
      state = 0;
 610:	4981                	li	s3,0
 612:	b765                	j	5ba <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 614:	008b0913          	addi	s2,s6,8
 618:	4685                	li	a3,1
 61a:	4629                	li	a2,10
 61c:	000b2583          	lw	a1,0(s6)
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	e8e080e7          	jalr	-370(ra) # 4b0 <printint>
 62a:	8b4a                	mv	s6,s2
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b771                	j	5ba <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 630:	008b0913          	addi	s2,s6,8
 634:	4681                	li	a3,0
 636:	4629                	li	a2,10
 638:	000b2583          	lw	a1,0(s6)
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	e72080e7          	jalr	-398(ra) # 4b0 <printint>
 646:	8b4a                	mv	s6,s2
      state = 0;
 648:	4981                	li	s3,0
 64a:	bf85                	j	5ba <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 64c:	008b0913          	addi	s2,s6,8
 650:	4681                	li	a3,0
 652:	4641                	li	a2,16
 654:	000b2583          	lw	a1,0(s6)
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	e56080e7          	jalr	-426(ra) # 4b0 <printint>
 662:	8b4a                	mv	s6,s2
      state = 0;
 664:	4981                	li	s3,0
 666:	bf91                	j	5ba <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 668:	008b0793          	addi	a5,s6,8
 66c:	f8f43423          	sd	a5,-120(s0)
 670:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 674:	03000593          	li	a1,48
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	e14080e7          	jalr	-492(ra) # 48e <putc>
  putc(fd, 'x');
 682:	85ea                	mv	a1,s10
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	e08080e7          	jalr	-504(ra) # 48e <putc>
 68e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 690:	03c9d793          	srli	a5,s3,0x3c
 694:	97de                	add	a5,a5,s7
 696:	0007c583          	lbu	a1,0(a5)
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	df2080e7          	jalr	-526(ra) # 48e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a4:	0992                	slli	s3,s3,0x4
 6a6:	397d                	addiw	s2,s2,-1
 6a8:	fe0914e3          	bnez	s2,690 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6ac:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b721                	j	5ba <vprintf+0x60>
        s = va_arg(ap, char*);
 6b4:	008b0993          	addi	s3,s6,8
 6b8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6bc:	02090163          	beqz	s2,6de <vprintf+0x184>
        while(*s != 0){
 6c0:	00094583          	lbu	a1,0(s2)
 6c4:	c9a1                	beqz	a1,714 <vprintf+0x1ba>
          putc(fd, *s);
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	dc6080e7          	jalr	-570(ra) # 48e <putc>
          s++;
 6d0:	0905                	addi	s2,s2,1
        while(*s != 0){
 6d2:	00094583          	lbu	a1,0(s2)
 6d6:	f9e5                	bnez	a1,6c6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6d8:	8b4e                	mv	s6,s3
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	bdf9                	j	5ba <vprintf+0x60>
          s = "(null)";
 6de:	00000917          	auipc	s2,0x0
 6e2:	2ca90913          	addi	s2,s2,714 # 9a8 <malloc+0x12c>
        while(*s != 0){
 6e6:	02800593          	li	a1,40
 6ea:	bff1                	j	6c6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6ec:	008b0913          	addi	s2,s6,8
 6f0:	000b4583          	lbu	a1,0(s6)
 6f4:	8556                	mv	a0,s5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	d98080e7          	jalr	-616(ra) # 48e <putc>
 6fe:	8b4a                	mv	s6,s2
      state = 0;
 700:	4981                	li	s3,0
 702:	bd65                	j	5ba <vprintf+0x60>
        putc(fd, c);
 704:	85d2                	mv	a1,s4
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	d86080e7          	jalr	-634(ra) # 48e <putc>
      state = 0;
 710:	4981                	li	s3,0
 712:	b565                	j	5ba <vprintf+0x60>
        s = va_arg(ap, char*);
 714:	8b4e                	mv	s6,s3
      state = 0;
 716:	4981                	li	s3,0
 718:	b54d                	j	5ba <vprintf+0x60>
    }
  }
}
 71a:	70e6                	ld	ra,120(sp)
 71c:	7446                	ld	s0,112(sp)
 71e:	74a6                	ld	s1,104(sp)
 720:	7906                	ld	s2,96(sp)
 722:	69e6                	ld	s3,88(sp)
 724:	6a46                	ld	s4,80(sp)
 726:	6aa6                	ld	s5,72(sp)
 728:	6b06                	ld	s6,64(sp)
 72a:	7be2                	ld	s7,56(sp)
 72c:	7c42                	ld	s8,48(sp)
 72e:	7ca2                	ld	s9,40(sp)
 730:	7d02                	ld	s10,32(sp)
 732:	6de2                	ld	s11,24(sp)
 734:	6109                	addi	sp,sp,128
 736:	8082                	ret

0000000000000738 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 738:	715d                	addi	sp,sp,-80
 73a:	ec06                	sd	ra,24(sp)
 73c:	e822                	sd	s0,16(sp)
 73e:	1000                	addi	s0,sp,32
 740:	e010                	sd	a2,0(s0)
 742:	e414                	sd	a3,8(s0)
 744:	e818                	sd	a4,16(s0)
 746:	ec1c                	sd	a5,24(s0)
 748:	03043023          	sd	a6,32(s0)
 74c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 750:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 754:	8622                	mv	a2,s0
 756:	00000097          	auipc	ra,0x0
 75a:	e04080e7          	jalr	-508(ra) # 55a <vprintf>
}
 75e:	60e2                	ld	ra,24(sp)
 760:	6442                	ld	s0,16(sp)
 762:	6161                	addi	sp,sp,80
 764:	8082                	ret

0000000000000766 <printf>:

void
printf(const char *fmt, ...)
{
 766:	7159                	addi	sp,sp,-112
 768:	f406                	sd	ra,40(sp)
 76a:	f022                	sd	s0,32(sp)
 76c:	ec26                	sd	s1,24(sp)
 76e:	e84a                	sd	s2,16(sp)
 770:	1800                	addi	s0,sp,48
 772:	84aa                	mv	s1,a0
 774:	e40c                	sd	a1,8(s0)
 776:	e810                	sd	a2,16(s0)
 778:	ec14                	sd	a3,24(s0)
 77a:	f018                	sd	a4,32(s0)
 77c:	f41c                	sd	a5,40(s0)
 77e:	03043823          	sd	a6,48(s0)
 782:	03143c23          	sd	a7,56(s0)
  va_list ap;
  lock_acquire(&pr.printf_lock);
 786:	00000917          	auipc	s2,0x0
 78a:	45290913          	addi	s2,s2,1106 # bd8 <pr>
 78e:	854a                	mv	a0,s2
 790:	00000097          	auipc	ra,0x0
 794:	b88080e7          	jalr	-1144(ra) # 318 <lock_acquire>

  va_start(ap, fmt);
 798:	00840613          	addi	a2,s0,8
 79c:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 7a0:	85a6                	mv	a1,s1
 7a2:	4505                	li	a0,1
 7a4:	00000097          	auipc	ra,0x0
 7a8:	db6080e7          	jalr	-586(ra) # 55a <vprintf>
  
  lock_release(&pr.printf_lock);
 7ac:	854a                	mv	a0,s2
 7ae:	00000097          	auipc	ra,0x0
 7b2:	b8a080e7          	jalr	-1142(ra) # 338 <lock_release>

}
 7b6:	70a2                	ld	ra,40(sp)
 7b8:	7402                	ld	s0,32(sp)
 7ba:	64e2                	ld	s1,24(sp)
 7bc:	6942                	ld	s2,16(sp)
 7be:	6165                	addi	sp,sp,112
 7c0:	8082                	ret

00000000000007c2 <printfinit>:

void
printfinit(void)
{
 7c2:	1101                	addi	sp,sp,-32
 7c4:	ec06                	sd	ra,24(sp)
 7c6:	e822                	sd	s0,16(sp)
 7c8:	e426                	sd	s1,8(sp)
 7ca:	1000                	addi	s0,sp,32
  lock_init(&pr.printf_lock, "pr");
 7cc:	00000497          	auipc	s1,0x0
 7d0:	40c48493          	addi	s1,s1,1036 # bd8 <pr>
 7d4:	00000597          	auipc	a1,0x0
 7d8:	1dc58593          	addi	a1,a1,476 # 9b0 <malloc+0x134>
 7dc:	8526                	mv	a0,s1
 7de:	00000097          	auipc	ra,0x0
 7e2:	b28080e7          	jalr	-1240(ra) # 306 <lock_init>
  pr.locking = 1;
 7e6:	4785                	li	a5,1
 7e8:	c89c                	sw	a5,16(s1)
}
 7ea:	60e2                	ld	ra,24(sp)
 7ec:	6442                	ld	s0,16(sp)
 7ee:	64a2                	ld	s1,8(sp)
 7f0:	6105                	addi	sp,sp,32
 7f2:	8082                	ret

00000000000007f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f4:	1141                	addi	sp,sp,-16
 7f6:	e422                	sd	s0,8(sp)
 7f8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7fa:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fe:	00000797          	auipc	a5,0x0
 802:	1d27b783          	ld	a5,466(a5) # 9d0 <freep>
 806:	a805                	j	836 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 808:	4618                	lw	a4,8(a2)
 80a:	9db9                	addw	a1,a1,a4
 80c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 810:	6398                	ld	a4,0(a5)
 812:	6318                	ld	a4,0(a4)
 814:	fee53823          	sd	a4,-16(a0)
 818:	a091                	j	85c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 81a:	ff852703          	lw	a4,-8(a0)
 81e:	9e39                	addw	a2,a2,a4
 820:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 822:	ff053703          	ld	a4,-16(a0)
 826:	e398                	sd	a4,0(a5)
 828:	a099                	j	86e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82a:	6398                	ld	a4,0(a5)
 82c:	00e7e463          	bltu	a5,a4,834 <free+0x40>
 830:	00e6ea63          	bltu	a3,a4,844 <free+0x50>
{
 834:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 836:	fed7fae3          	bgeu	a5,a3,82a <free+0x36>
 83a:	6398                	ld	a4,0(a5)
 83c:	00e6e463          	bltu	a3,a4,844 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 840:	fee7eae3          	bltu	a5,a4,834 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 844:	ff852583          	lw	a1,-8(a0)
 848:	6390                	ld	a2,0(a5)
 84a:	02059713          	slli	a4,a1,0x20
 84e:	9301                	srli	a4,a4,0x20
 850:	0712                	slli	a4,a4,0x4
 852:	9736                	add	a4,a4,a3
 854:	fae60ae3          	beq	a2,a4,808 <free+0x14>
    bp->s.ptr = p->s.ptr;
 858:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 85c:	4790                	lw	a2,8(a5)
 85e:	02061713          	slli	a4,a2,0x20
 862:	9301                	srli	a4,a4,0x20
 864:	0712                	slli	a4,a4,0x4
 866:	973e                	add	a4,a4,a5
 868:	fae689e3          	beq	a3,a4,81a <free+0x26>
  } else
    p->s.ptr = bp;
 86c:	e394                	sd	a3,0(a5)
  freep = p;
 86e:	00000717          	auipc	a4,0x0
 872:	16f73123          	sd	a5,354(a4) # 9d0 <freep>
}
 876:	6422                	ld	s0,8(sp)
 878:	0141                	addi	sp,sp,16
 87a:	8082                	ret

000000000000087c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 87c:	7139                	addi	sp,sp,-64
 87e:	fc06                	sd	ra,56(sp)
 880:	f822                	sd	s0,48(sp)
 882:	f426                	sd	s1,40(sp)
 884:	f04a                	sd	s2,32(sp)
 886:	ec4e                	sd	s3,24(sp)
 888:	e852                	sd	s4,16(sp)
 88a:	e456                	sd	s5,8(sp)
 88c:	e05a                	sd	s6,0(sp)
 88e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 890:	02051493          	slli	s1,a0,0x20
 894:	9081                	srli	s1,s1,0x20
 896:	04bd                	addi	s1,s1,15
 898:	8091                	srli	s1,s1,0x4
 89a:	0014899b          	addiw	s3,s1,1
 89e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8a0:	00000517          	auipc	a0,0x0
 8a4:	13053503          	ld	a0,304(a0) # 9d0 <freep>
 8a8:	c515                	beqz	a0,8d4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ac:	4798                	lw	a4,8(a5)
 8ae:	02977f63          	bgeu	a4,s1,8ec <malloc+0x70>
 8b2:	8a4e                	mv	s4,s3
 8b4:	0009871b          	sext.w	a4,s3
 8b8:	6685                	lui	a3,0x1
 8ba:	00d77363          	bgeu	a4,a3,8c0 <malloc+0x44>
 8be:	6a05                	lui	s4,0x1
 8c0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c8:	00000917          	auipc	s2,0x0
 8cc:	10890913          	addi	s2,s2,264 # 9d0 <freep>
  if(p == (char*)-1)
 8d0:	5afd                	li	s5,-1
 8d2:	a88d                	j	944 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8d4:	00000797          	auipc	a5,0x0
 8d8:	31c78793          	addi	a5,a5,796 # bf0 <base>
 8dc:	00000717          	auipc	a4,0x0
 8e0:	0ef73a23          	sd	a5,244(a4) # 9d0 <freep>
 8e4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8e6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ea:	b7e1                	j	8b2 <malloc+0x36>
      if(p->s.size == nunits)
 8ec:	02e48b63          	beq	s1,a4,922 <malloc+0xa6>
        p->s.size -= nunits;
 8f0:	4137073b          	subw	a4,a4,s3
 8f4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f6:	1702                	slli	a4,a4,0x20
 8f8:	9301                	srli	a4,a4,0x20
 8fa:	0712                	slli	a4,a4,0x4
 8fc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8fe:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 902:	00000717          	auipc	a4,0x0
 906:	0ca73723          	sd	a0,206(a4) # 9d0 <freep>
      return (void*)(p + 1);
 90a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 90e:	70e2                	ld	ra,56(sp)
 910:	7442                	ld	s0,48(sp)
 912:	74a2                	ld	s1,40(sp)
 914:	7902                	ld	s2,32(sp)
 916:	69e2                	ld	s3,24(sp)
 918:	6a42                	ld	s4,16(sp)
 91a:	6aa2                	ld	s5,8(sp)
 91c:	6b02                	ld	s6,0(sp)
 91e:	6121                	addi	sp,sp,64
 920:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 922:	6398                	ld	a4,0(a5)
 924:	e118                	sd	a4,0(a0)
 926:	bff1                	j	902 <malloc+0x86>
  hp->s.size = nu;
 928:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 92c:	0541                	addi	a0,a0,16
 92e:	00000097          	auipc	ra,0x0
 932:	ec6080e7          	jalr	-314(ra) # 7f4 <free>
  return freep;
 936:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 93a:	d971                	beqz	a0,90e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93e:	4798                	lw	a4,8(a5)
 940:	fa9776e3          	bgeu	a4,s1,8ec <malloc+0x70>
    if(p == freep)
 944:	00093703          	ld	a4,0(s2)
 948:	853e                	mv	a0,a5
 94a:	fef719e3          	bne	a4,a5,93c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 94e:	8552                	mv	a0,s4
 950:	00000097          	auipc	ra,0x0
 954:	b16080e7          	jalr	-1258(ra) # 466 <sbrk>
  if(p == (char*)-1)
 958:	fd5518e3          	bne	a0,s5,928 <malloc+0xac>
        return 0;
 95c:	4501                	li	a0,0
 95e:	bf45                	j	90e <malloc+0x92>
