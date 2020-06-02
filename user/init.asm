
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

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00000517          	auipc	a0,0x0
  12:	7fa50513          	addi	a0,a0,2042 # 808 <malloc+0xe4>
  16:	00000097          	auipc	ra,0x0
  1a:	300080e7          	jalr	768(ra) # 316 <open>
  1e:	04054763          	bltz	a0,6c <main+0x6c>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	32a080e7          	jalr	810(ra) # 34e <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	320080e7          	jalr	800(ra) # 34e <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00000917          	auipc	s2,0x0
  3a:	7da90913          	addi	s2,s2,2010 # 810 <malloc+0xec>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	626080e7          	jalr	1574(ra) # 666 <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	286080e7          	jalr	646(ra) # 2ce <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054163          	bltz	a0,94 <main+0x94>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  56:	cd21                	beqz	a0,ae <main+0xae>
      exec("sh", argv);
      printf("init: exec sh failed\n");
      exit(1);
    }
    while((wpid=wait(0)) >= 0 && wpid != pid){
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	284080e7          	jalr	644(ra) # 2de <wait>
  62:	fc054ee3          	bltz	a0,3e <main+0x3e>
  66:	fea499e3          	bne	s1,a0,58 <main+0x58>
  6a:	bfd1                	j	3e <main+0x3e>
    mknod("console", 1, 1);
  6c:	4605                	li	a2,1
  6e:	4585                	li	a1,1
  70:	00000517          	auipc	a0,0x0
  74:	79850513          	addi	a0,a0,1944 # 808 <malloc+0xe4>
  78:	00000097          	auipc	ra,0x0
  7c:	2a6080e7          	jalr	678(ra) # 31e <mknod>
    open("console", O_RDWR);
  80:	4589                	li	a1,2
  82:	00000517          	auipc	a0,0x0
  86:	78650513          	addi	a0,a0,1926 # 808 <malloc+0xe4>
  8a:	00000097          	auipc	ra,0x0
  8e:	28c080e7          	jalr	652(ra) # 316 <open>
  92:	bf41                	j	22 <main+0x22>
      printf("init: fork failed\n");
  94:	00000517          	auipc	a0,0x0
  98:	79450513          	addi	a0,a0,1940 # 828 <malloc+0x104>
  9c:	00000097          	auipc	ra,0x0
  a0:	5ca080e7          	jalr	1482(ra) # 666 <printf>
      exit(1);
  a4:	4505                	li	a0,1
  a6:	00000097          	auipc	ra,0x0
  aa:	230080e7          	jalr	560(ra) # 2d6 <exit>
      exec("sh", argv);
  ae:	00000597          	auipc	a1,0x0
  b2:	7d258593          	addi	a1,a1,2002 # 880 <argv>
  b6:	00000517          	auipc	a0,0x0
  ba:	78a50513          	addi	a0,a0,1930 # 840 <malloc+0x11c>
  be:	00000097          	auipc	ra,0x0
  c2:	250080e7          	jalr	592(ra) # 30e <exec>
      printf("init: exec sh failed\n");
  c6:	00000517          	auipc	a0,0x0
  ca:	78250513          	addi	a0,a0,1922 # 848 <malloc+0x124>
  ce:	00000097          	auipc	ra,0x0
  d2:	598080e7          	jalr	1432(ra) # 666 <printf>
      exit(1);
  d6:	4505                	li	a0,1
  d8:	00000097          	auipc	ra,0x0
  dc:	1fe080e7          	jalr	510(ra) # 2d6 <exit>

00000000000000e0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  e0:	1141                	addi	sp,sp,-16
  e2:	e422                	sd	s0,8(sp)
  e4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e6:	87aa                	mv	a5,a0
  e8:	0585                	addi	a1,a1,1
  ea:	0785                	addi	a5,a5,1
  ec:	fff5c703          	lbu	a4,-1(a1)
  f0:	fee78fa3          	sb	a4,-1(a5)
  f4:	fb75                	bnez	a4,e8 <strcpy+0x8>
    ;
  return os;
}
  f6:	6422                	ld	s0,8(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret

00000000000000fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e422                	sd	s0,8(sp)
 100:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 102:	00054783          	lbu	a5,0(a0)
 106:	cb91                	beqz	a5,11a <strcmp+0x1e>
 108:	0005c703          	lbu	a4,0(a1)
 10c:	00f71763          	bne	a4,a5,11a <strcmp+0x1e>
    p++, q++;
 110:	0505                	addi	a0,a0,1
 112:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 114:	00054783          	lbu	a5,0(a0)
 118:	fbe5                	bnez	a5,108 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 11a:	0005c503          	lbu	a0,0(a1)
}
 11e:	40a7853b          	subw	a0,a5,a0
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strlen>:

uint
strlen(const char *s)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cf91                	beqz	a5,14e <strlen+0x26>
 134:	0505                	addi	a0,a0,1
 136:	87aa                	mv	a5,a0
 138:	4685                	li	a3,1
 13a:	9e89                	subw	a3,a3,a0
 13c:	00f6853b          	addw	a0,a3,a5
 140:	0785                	addi	a5,a5,1
 142:	fff7c703          	lbu	a4,-1(a5)
 146:	fb7d                	bnez	a4,13c <strlen+0x14>
    ;
  return n;
}
 148:	6422                	ld	s0,8(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret
  for(n = 0; s[n]; n++)
 14e:	4501                	li	a0,0
 150:	bfe5                	j	148 <strlen+0x20>

0000000000000152 <memset>:

void*
memset(void *dst, int c, uint n)
{
 152:	1141                	addi	sp,sp,-16
 154:	e422                	sd	s0,8(sp)
 156:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 158:	ce09                	beqz	a2,172 <memset+0x20>
 15a:	87aa                	mv	a5,a0
 15c:	fff6071b          	addiw	a4,a2,-1
 160:	1702                	slli	a4,a4,0x20
 162:	9301                	srli	a4,a4,0x20
 164:	0705                	addi	a4,a4,1
 166:	972a                	add	a4,a4,a0
    cdst[i] = c;
 168:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 16c:	0785                	addi	a5,a5,1
 16e:	fee79de3          	bne	a5,a4,168 <memset+0x16>
  }
  return dst;
}
 172:	6422                	ld	s0,8(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret

0000000000000178 <strchr>:

char*
strchr(const char *s, char c)
{
 178:	1141                	addi	sp,sp,-16
 17a:	e422                	sd	s0,8(sp)
 17c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 17e:	00054783          	lbu	a5,0(a0)
 182:	cb99                	beqz	a5,198 <strchr+0x20>
    if(*s == c)
 184:	00f58763          	beq	a1,a5,192 <strchr+0x1a>
  for(; *s; s++)
 188:	0505                	addi	a0,a0,1
 18a:	00054783          	lbu	a5,0(a0)
 18e:	fbfd                	bnez	a5,184 <strchr+0xc>
      return (char*)s;
  return 0;
 190:	4501                	li	a0,0
}
 192:	6422                	ld	s0,8(sp)
 194:	0141                	addi	sp,sp,16
 196:	8082                	ret
  return 0;
 198:	4501                	li	a0,0
 19a:	bfe5                	j	192 <strchr+0x1a>

000000000000019c <gets>:

char*
gets(char *buf, int max)
{
 19c:	711d                	addi	sp,sp,-96
 19e:	ec86                	sd	ra,88(sp)
 1a0:	e8a2                	sd	s0,80(sp)
 1a2:	e4a6                	sd	s1,72(sp)
 1a4:	e0ca                	sd	s2,64(sp)
 1a6:	fc4e                	sd	s3,56(sp)
 1a8:	f852                	sd	s4,48(sp)
 1aa:	f456                	sd	s5,40(sp)
 1ac:	f05a                	sd	s6,32(sp)
 1ae:	ec5e                	sd	s7,24(sp)
 1b0:	1080                	addi	s0,sp,96
 1b2:	8baa                	mv	s7,a0
 1b4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b6:	892a                	mv	s2,a0
 1b8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ba:	4aa9                	li	s5,10
 1bc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1be:	89a6                	mv	s3,s1
 1c0:	2485                	addiw	s1,s1,1
 1c2:	0344d863          	bge	s1,s4,1f2 <gets+0x56>
    cc = read(0, &c, 1);
 1c6:	4605                	li	a2,1
 1c8:	faf40593          	addi	a1,s0,-81
 1cc:	4501                	li	a0,0
 1ce:	00000097          	auipc	ra,0x0
 1d2:	120080e7          	jalr	288(ra) # 2ee <read>
    if(cc < 1)
 1d6:	00a05e63          	blez	a0,1f2 <gets+0x56>
    buf[i++] = c;
 1da:	faf44783          	lbu	a5,-81(s0)
 1de:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e2:	01578763          	beq	a5,s5,1f0 <gets+0x54>
 1e6:	0905                	addi	s2,s2,1
 1e8:	fd679be3          	bne	a5,s6,1be <gets+0x22>
  for(i=0; i+1 < max; ){
 1ec:	89a6                	mv	s3,s1
 1ee:	a011                	j	1f2 <gets+0x56>
 1f0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1f2:	99de                	add	s3,s3,s7
 1f4:	00098023          	sb	zero,0(s3)
  return buf;
}
 1f8:	855e                	mv	a0,s7
 1fa:	60e6                	ld	ra,88(sp)
 1fc:	6446                	ld	s0,80(sp)
 1fe:	64a6                	ld	s1,72(sp)
 200:	6906                	ld	s2,64(sp)
 202:	79e2                	ld	s3,56(sp)
 204:	7a42                	ld	s4,48(sp)
 206:	7aa2                	ld	s5,40(sp)
 208:	7b02                	ld	s6,32(sp)
 20a:	6be2                	ld	s7,24(sp)
 20c:	6125                	addi	sp,sp,96
 20e:	8082                	ret

0000000000000210 <stat>:

int
stat(const char *n, struct stat *st)
{
 210:	1101                	addi	sp,sp,-32
 212:	ec06                	sd	ra,24(sp)
 214:	e822                	sd	s0,16(sp)
 216:	e426                	sd	s1,8(sp)
 218:	e04a                	sd	s2,0(sp)
 21a:	1000                	addi	s0,sp,32
 21c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21e:	4581                	li	a1,0
 220:	00000097          	auipc	ra,0x0
 224:	0f6080e7          	jalr	246(ra) # 316 <open>
  if(fd < 0)
 228:	02054563          	bltz	a0,252 <stat+0x42>
 22c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 22e:	85ca                	mv	a1,s2
 230:	00000097          	auipc	ra,0x0
 234:	0fe080e7          	jalr	254(ra) # 32e <fstat>
 238:	892a                	mv	s2,a0
  close(fd);
 23a:	8526                	mv	a0,s1
 23c:	00000097          	auipc	ra,0x0
 240:	0c2080e7          	jalr	194(ra) # 2fe <close>
  return r;
}
 244:	854a                	mv	a0,s2
 246:	60e2                	ld	ra,24(sp)
 248:	6442                	ld	s0,16(sp)
 24a:	64a2                	ld	s1,8(sp)
 24c:	6902                	ld	s2,0(sp)
 24e:	6105                	addi	sp,sp,32
 250:	8082                	ret
    return -1;
 252:	597d                	li	s2,-1
 254:	bfc5                	j	244 <stat+0x34>

0000000000000256 <atoi>:

int
atoi(const char *s)
{
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25c:	00054603          	lbu	a2,0(a0)
 260:	fd06079b          	addiw	a5,a2,-48
 264:	0ff7f793          	andi	a5,a5,255
 268:	4725                	li	a4,9
 26a:	02f76963          	bltu	a4,a5,29c <atoi+0x46>
 26e:	86aa                	mv	a3,a0
  n = 0;
 270:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 272:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 274:	0685                	addi	a3,a3,1
 276:	0025179b          	slliw	a5,a0,0x2
 27a:	9fa9                	addw	a5,a5,a0
 27c:	0017979b          	slliw	a5,a5,0x1
 280:	9fb1                	addw	a5,a5,a2
 282:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 286:	0006c603          	lbu	a2,0(a3)
 28a:	fd06071b          	addiw	a4,a2,-48
 28e:	0ff77713          	andi	a4,a4,255
 292:	fee5f1e3          	bgeu	a1,a4,274 <atoi+0x1e>
  return n;
}
 296:	6422                	ld	s0,8(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
  n = 0;
 29c:	4501                	li	a0,0
 29e:	bfe5                	j	296 <atoi+0x40>

00000000000002a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e422                	sd	s0,8(sp)
 2a4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a6:	02c05163          	blez	a2,2c8 <memmove+0x28>
 2aa:	fff6071b          	addiw	a4,a2,-1
 2ae:	1702                	slli	a4,a4,0x20
 2b0:	9301                	srli	a4,a4,0x20
 2b2:	0705                	addi	a4,a4,1
 2b4:	972a                	add	a4,a4,a0
  dst = vdst;
 2b6:	87aa                	mv	a5,a0
    *dst++ = *src++;
 2b8:	0585                	addi	a1,a1,1
 2ba:	0785                	addi	a5,a5,1
 2bc:	fff5c683          	lbu	a3,-1(a1)
 2c0:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 2c4:	fee79ae3          	bne	a5,a4,2b8 <memmove+0x18>
  return vdst;
}
 2c8:	6422                	ld	s0,8(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret

00000000000002ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ce:	4885                	li	a7,1
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d6:	4889                	li	a7,2
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <wait>:
.global wait
wait:
 li a7, SYS_wait
 2de:	488d                	li	a7,3
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e6:	4891                	li	a7,4
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <read>:
.global read
read:
 li a7, SYS_read
 2ee:	4895                	li	a7,5
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <write>:
.global write
write:
 li a7, SYS_write
 2f6:	48c1                	li	a7,16
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <close>:
.global close
close:
 li a7, SYS_close
 2fe:	48d5                	li	a7,21
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <kill>:
.global kill
kill:
 li a7, SYS_kill
 306:	4899                	li	a7,6
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <exec>:
.global exec
exec:
 li a7, SYS_exec
 30e:	489d                	li	a7,7
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <open>:
.global open
open:
 li a7, SYS_open
 316:	48bd                	li	a7,15
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 31e:	48c5                	li	a7,17
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 326:	48c9                	li	a7,18
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 32e:	48a1                	li	a7,8
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <link>:
.global link
link:
 li a7, SYS_link
 336:	48cd                	li	a7,19
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 33e:	48d1                	li	a7,20
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 346:	48a5                	li	a7,9
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <dup>:
.global dup
dup:
 li a7, SYS_dup
 34e:	48a9                	li	a7,10
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 356:	48ad                	li	a7,11
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 35e:	48b1                	li	a7,12
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 366:	48b5                	li	a7,13
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 36e:	48b9                	li	a7,14
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
 376:	48d9                	li	a7,22
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 37e:	48dd                	li	a7,23
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 386:	48e1                	li	a7,24
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 38e:	1101                	addi	sp,sp,-32
 390:	ec06                	sd	ra,24(sp)
 392:	e822                	sd	s0,16(sp)
 394:	1000                	addi	s0,sp,32
 396:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 39a:	4605                	li	a2,1
 39c:	fef40593          	addi	a1,s0,-17
 3a0:	00000097          	auipc	ra,0x0
 3a4:	f56080e7          	jalr	-170(ra) # 2f6 <write>
}
 3a8:	60e2                	ld	ra,24(sp)
 3aa:	6442                	ld	s0,16(sp)
 3ac:	6105                	addi	sp,sp,32
 3ae:	8082                	ret

00000000000003b0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	7139                	addi	sp,sp,-64
 3b2:	fc06                	sd	ra,56(sp)
 3b4:	f822                	sd	s0,48(sp)
 3b6:	f426                	sd	s1,40(sp)
 3b8:	f04a                	sd	s2,32(sp)
 3ba:	ec4e                	sd	s3,24(sp)
 3bc:	0080                	addi	s0,sp,64
 3be:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c0:	c299                	beqz	a3,3c6 <printint+0x16>
 3c2:	0805c863          	bltz	a1,452 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c6:	2581                	sext.w	a1,a1
  neg = 0;
 3c8:	4881                	li	a7,0
 3ca:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3ce:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3d0:	2601                	sext.w	a2,a2
 3d2:	00000517          	auipc	a0,0x0
 3d6:	49650513          	addi	a0,a0,1174 # 868 <digits>
 3da:	883a                	mv	a6,a4
 3dc:	2705                	addiw	a4,a4,1
 3de:	02c5f7bb          	remuw	a5,a1,a2
 3e2:	1782                	slli	a5,a5,0x20
 3e4:	9381                	srli	a5,a5,0x20
 3e6:	97aa                	add	a5,a5,a0
 3e8:	0007c783          	lbu	a5,0(a5)
 3ec:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3f0:	0005879b          	sext.w	a5,a1
 3f4:	02c5d5bb          	divuw	a1,a1,a2
 3f8:	0685                	addi	a3,a3,1
 3fa:	fec7f0e3          	bgeu	a5,a2,3da <printint+0x2a>
  if(neg)
 3fe:	00088b63          	beqz	a7,414 <printint+0x64>
    buf[i++] = '-';
 402:	fd040793          	addi	a5,s0,-48
 406:	973e                	add	a4,a4,a5
 408:	02d00793          	li	a5,45
 40c:	fef70823          	sb	a5,-16(a4)
 410:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 414:	02e05863          	blez	a4,444 <printint+0x94>
 418:	fc040793          	addi	a5,s0,-64
 41c:	00e78933          	add	s2,a5,a4
 420:	fff78993          	addi	s3,a5,-1
 424:	99ba                	add	s3,s3,a4
 426:	377d                	addiw	a4,a4,-1
 428:	1702                	slli	a4,a4,0x20
 42a:	9301                	srli	a4,a4,0x20
 42c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 430:	fff94583          	lbu	a1,-1(s2)
 434:	8526                	mv	a0,s1
 436:	00000097          	auipc	ra,0x0
 43a:	f58080e7          	jalr	-168(ra) # 38e <putc>
  while(--i >= 0)
 43e:	197d                	addi	s2,s2,-1
 440:	ff3918e3          	bne	s2,s3,430 <printint+0x80>
}
 444:	70e2                	ld	ra,56(sp)
 446:	7442                	ld	s0,48(sp)
 448:	74a2                	ld	s1,40(sp)
 44a:	7902                	ld	s2,32(sp)
 44c:	69e2                	ld	s3,24(sp)
 44e:	6121                	addi	sp,sp,64
 450:	8082                	ret
    x = -xx;
 452:	40b005bb          	negw	a1,a1
    neg = 1;
 456:	4885                	li	a7,1
    x = -xx;
 458:	bf8d                	j	3ca <printint+0x1a>

000000000000045a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 45a:	7119                	addi	sp,sp,-128
 45c:	fc86                	sd	ra,120(sp)
 45e:	f8a2                	sd	s0,112(sp)
 460:	f4a6                	sd	s1,104(sp)
 462:	f0ca                	sd	s2,96(sp)
 464:	ecce                	sd	s3,88(sp)
 466:	e8d2                	sd	s4,80(sp)
 468:	e4d6                	sd	s5,72(sp)
 46a:	e0da                	sd	s6,64(sp)
 46c:	fc5e                	sd	s7,56(sp)
 46e:	f862                	sd	s8,48(sp)
 470:	f466                	sd	s9,40(sp)
 472:	f06a                	sd	s10,32(sp)
 474:	ec6e                	sd	s11,24(sp)
 476:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 478:	0005c903          	lbu	s2,0(a1)
 47c:	18090f63          	beqz	s2,61a <vprintf+0x1c0>
 480:	8aaa                	mv	s5,a0
 482:	8b32                	mv	s6,a2
 484:	00158493          	addi	s1,a1,1
  state = 0;
 488:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 48a:	02500a13          	li	s4,37
      if(c == 'd'){
 48e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 492:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 496:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 49a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 49e:	00000b97          	auipc	s7,0x0
 4a2:	3cab8b93          	addi	s7,s7,970 # 868 <digits>
 4a6:	a839                	j	4c4 <vprintf+0x6a>
        putc(fd, c);
 4a8:	85ca                	mv	a1,s2
 4aa:	8556                	mv	a0,s5
 4ac:	00000097          	auipc	ra,0x0
 4b0:	ee2080e7          	jalr	-286(ra) # 38e <putc>
 4b4:	a019                	j	4ba <vprintf+0x60>
    } else if(state == '%'){
 4b6:	01498f63          	beq	s3,s4,4d4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4ba:	0485                	addi	s1,s1,1
 4bc:	fff4c903          	lbu	s2,-1(s1)
 4c0:	14090d63          	beqz	s2,61a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4c4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4c8:	fe0997e3          	bnez	s3,4b6 <vprintf+0x5c>
      if(c == '%'){
 4cc:	fd479ee3          	bne	a5,s4,4a8 <vprintf+0x4e>
        state = '%';
 4d0:	89be                	mv	s3,a5
 4d2:	b7e5                	j	4ba <vprintf+0x60>
      if(c == 'd'){
 4d4:	05878063          	beq	a5,s8,514 <vprintf+0xba>
      } else if(c == 'l') {
 4d8:	05978c63          	beq	a5,s9,530 <vprintf+0xd6>
      } else if(c == 'x') {
 4dc:	07a78863          	beq	a5,s10,54c <vprintf+0xf2>
      } else if(c == 'p') {
 4e0:	09b78463          	beq	a5,s11,568 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4e4:	07300713          	li	a4,115
 4e8:	0ce78663          	beq	a5,a4,5b4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ec:	06300713          	li	a4,99
 4f0:	0ee78e63          	beq	a5,a4,5ec <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4f4:	11478863          	beq	a5,s4,604 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4f8:	85d2                	mv	a1,s4
 4fa:	8556                	mv	a0,s5
 4fc:	00000097          	auipc	ra,0x0
 500:	e92080e7          	jalr	-366(ra) # 38e <putc>
        putc(fd, c);
 504:	85ca                	mv	a1,s2
 506:	8556                	mv	a0,s5
 508:	00000097          	auipc	ra,0x0
 50c:	e86080e7          	jalr	-378(ra) # 38e <putc>
      }
      state = 0;
 510:	4981                	li	s3,0
 512:	b765                	j	4ba <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 514:	008b0913          	addi	s2,s6,8
 518:	4685                	li	a3,1
 51a:	4629                	li	a2,10
 51c:	000b2583          	lw	a1,0(s6)
 520:	8556                	mv	a0,s5
 522:	00000097          	auipc	ra,0x0
 526:	e8e080e7          	jalr	-370(ra) # 3b0 <printint>
 52a:	8b4a                	mv	s6,s2
      state = 0;
 52c:	4981                	li	s3,0
 52e:	b771                	j	4ba <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 530:	008b0913          	addi	s2,s6,8
 534:	4681                	li	a3,0
 536:	4629                	li	a2,10
 538:	000b2583          	lw	a1,0(s6)
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	e72080e7          	jalr	-398(ra) # 3b0 <printint>
 546:	8b4a                	mv	s6,s2
      state = 0;
 548:	4981                	li	s3,0
 54a:	bf85                	j	4ba <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 54c:	008b0913          	addi	s2,s6,8
 550:	4681                	li	a3,0
 552:	4641                	li	a2,16
 554:	000b2583          	lw	a1,0(s6)
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e56080e7          	jalr	-426(ra) # 3b0 <printint>
 562:	8b4a                	mv	s6,s2
      state = 0;
 564:	4981                	li	s3,0
 566:	bf91                	j	4ba <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 568:	008b0793          	addi	a5,s6,8
 56c:	f8f43423          	sd	a5,-120(s0)
 570:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 574:	03000593          	li	a1,48
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	e14080e7          	jalr	-492(ra) # 38e <putc>
  putc(fd, 'x');
 582:	85ea                	mv	a1,s10
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	e08080e7          	jalr	-504(ra) # 38e <putc>
 58e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 590:	03c9d793          	srli	a5,s3,0x3c
 594:	97de                	add	a5,a5,s7
 596:	0007c583          	lbu	a1,0(a5)
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	df2080e7          	jalr	-526(ra) # 38e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5a4:	0992                	slli	s3,s3,0x4
 5a6:	397d                	addiw	s2,s2,-1
 5a8:	fe0914e3          	bnez	s2,590 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5ac:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	b721                	j	4ba <vprintf+0x60>
        s = va_arg(ap, char*);
 5b4:	008b0993          	addi	s3,s6,8
 5b8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5bc:	02090163          	beqz	s2,5de <vprintf+0x184>
        while(*s != 0){
 5c0:	00094583          	lbu	a1,0(s2)
 5c4:	c9a1                	beqz	a1,614 <vprintf+0x1ba>
          putc(fd, *s);
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	dc6080e7          	jalr	-570(ra) # 38e <putc>
          s++;
 5d0:	0905                	addi	s2,s2,1
        while(*s != 0){
 5d2:	00094583          	lbu	a1,0(s2)
 5d6:	f9e5                	bnez	a1,5c6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 5d8:	8b4e                	mv	s6,s3
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	bdf9                	j	4ba <vprintf+0x60>
          s = "(null)";
 5de:	00000917          	auipc	s2,0x0
 5e2:	28290913          	addi	s2,s2,642 # 860 <malloc+0x13c>
        while(*s != 0){
 5e6:	02800593          	li	a1,40
 5ea:	bff1                	j	5c6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5ec:	008b0913          	addi	s2,s6,8
 5f0:	000b4583          	lbu	a1,0(s6)
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	d98080e7          	jalr	-616(ra) # 38e <putc>
 5fe:	8b4a                	mv	s6,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	bd65                	j	4ba <vprintf+0x60>
        putc(fd, c);
 604:	85d2                	mv	a1,s4
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	d86080e7          	jalr	-634(ra) # 38e <putc>
      state = 0;
 610:	4981                	li	s3,0
 612:	b565                	j	4ba <vprintf+0x60>
        s = va_arg(ap, char*);
 614:	8b4e                	mv	s6,s3
      state = 0;
 616:	4981                	li	s3,0
 618:	b54d                	j	4ba <vprintf+0x60>
    }
  }
}
 61a:	70e6                	ld	ra,120(sp)
 61c:	7446                	ld	s0,112(sp)
 61e:	74a6                	ld	s1,104(sp)
 620:	7906                	ld	s2,96(sp)
 622:	69e6                	ld	s3,88(sp)
 624:	6a46                	ld	s4,80(sp)
 626:	6aa6                	ld	s5,72(sp)
 628:	6b06                	ld	s6,64(sp)
 62a:	7be2                	ld	s7,56(sp)
 62c:	7c42                	ld	s8,48(sp)
 62e:	7ca2                	ld	s9,40(sp)
 630:	7d02                	ld	s10,32(sp)
 632:	6de2                	ld	s11,24(sp)
 634:	6109                	addi	sp,sp,128
 636:	8082                	ret

0000000000000638 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 638:	715d                	addi	sp,sp,-80
 63a:	ec06                	sd	ra,24(sp)
 63c:	e822                	sd	s0,16(sp)
 63e:	1000                	addi	s0,sp,32
 640:	e010                	sd	a2,0(s0)
 642:	e414                	sd	a3,8(s0)
 644:	e818                	sd	a4,16(s0)
 646:	ec1c                	sd	a5,24(s0)
 648:	03043023          	sd	a6,32(s0)
 64c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 650:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 654:	8622                	mv	a2,s0
 656:	00000097          	auipc	ra,0x0
 65a:	e04080e7          	jalr	-508(ra) # 45a <vprintf>
}
 65e:	60e2                	ld	ra,24(sp)
 660:	6442                	ld	s0,16(sp)
 662:	6161                	addi	sp,sp,80
 664:	8082                	ret

0000000000000666 <printf>:

void
printf(const char *fmt, ...)
{
 666:	711d                	addi	sp,sp,-96
 668:	ec06                	sd	ra,24(sp)
 66a:	e822                	sd	s0,16(sp)
 66c:	1000                	addi	s0,sp,32
 66e:	e40c                	sd	a1,8(s0)
 670:	e810                	sd	a2,16(s0)
 672:	ec14                	sd	a3,24(s0)
 674:	f018                	sd	a4,32(s0)
 676:	f41c                	sd	a5,40(s0)
 678:	03043823          	sd	a6,48(s0)
 67c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 680:	00840613          	addi	a2,s0,8
 684:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 688:	85aa                	mv	a1,a0
 68a:	4505                	li	a0,1
 68c:	00000097          	auipc	ra,0x0
 690:	dce080e7          	jalr	-562(ra) # 45a <vprintf>
}
 694:	60e2                	ld	ra,24(sp)
 696:	6442                	ld	s0,16(sp)
 698:	6125                	addi	sp,sp,96
 69a:	8082                	ret

000000000000069c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 69c:	1141                	addi	sp,sp,-16
 69e:	e422                	sd	s0,8(sp)
 6a0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a6:	00000797          	auipc	a5,0x0
 6aa:	1ea7b783          	ld	a5,490(a5) # 890 <freep>
 6ae:	a805                	j	6de <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6b0:	4618                	lw	a4,8(a2)
 6b2:	9db9                	addw	a1,a1,a4
 6b4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b8:	6398                	ld	a4,0(a5)
 6ba:	6318                	ld	a4,0(a4)
 6bc:	fee53823          	sd	a4,-16(a0)
 6c0:	a091                	j	704 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6c2:	ff852703          	lw	a4,-8(a0)
 6c6:	9e39                	addw	a2,a2,a4
 6c8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6ca:	ff053703          	ld	a4,-16(a0)
 6ce:	e398                	sd	a4,0(a5)
 6d0:	a099                	j	716 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d2:	6398                	ld	a4,0(a5)
 6d4:	00e7e463          	bltu	a5,a4,6dc <free+0x40>
 6d8:	00e6ea63          	bltu	a3,a4,6ec <free+0x50>
{
 6dc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6de:	fed7fae3          	bgeu	a5,a3,6d2 <free+0x36>
 6e2:	6398                	ld	a4,0(a5)
 6e4:	00e6e463          	bltu	a3,a4,6ec <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e8:	fee7eae3          	bltu	a5,a4,6dc <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6ec:	ff852583          	lw	a1,-8(a0)
 6f0:	6390                	ld	a2,0(a5)
 6f2:	02059713          	slli	a4,a1,0x20
 6f6:	9301                	srli	a4,a4,0x20
 6f8:	0712                	slli	a4,a4,0x4
 6fa:	9736                	add	a4,a4,a3
 6fc:	fae60ae3          	beq	a2,a4,6b0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 700:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 704:	4790                	lw	a2,8(a5)
 706:	02061713          	slli	a4,a2,0x20
 70a:	9301                	srli	a4,a4,0x20
 70c:	0712                	slli	a4,a4,0x4
 70e:	973e                	add	a4,a4,a5
 710:	fae689e3          	beq	a3,a4,6c2 <free+0x26>
  } else
    p->s.ptr = bp;
 714:	e394                	sd	a3,0(a5)
  freep = p;
 716:	00000717          	auipc	a4,0x0
 71a:	16f73d23          	sd	a5,378(a4) # 890 <freep>
}
 71e:	6422                	ld	s0,8(sp)
 720:	0141                	addi	sp,sp,16
 722:	8082                	ret

0000000000000724 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 724:	7139                	addi	sp,sp,-64
 726:	fc06                	sd	ra,56(sp)
 728:	f822                	sd	s0,48(sp)
 72a:	f426                	sd	s1,40(sp)
 72c:	f04a                	sd	s2,32(sp)
 72e:	ec4e                	sd	s3,24(sp)
 730:	e852                	sd	s4,16(sp)
 732:	e456                	sd	s5,8(sp)
 734:	e05a                	sd	s6,0(sp)
 736:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 738:	02051493          	slli	s1,a0,0x20
 73c:	9081                	srli	s1,s1,0x20
 73e:	04bd                	addi	s1,s1,15
 740:	8091                	srli	s1,s1,0x4
 742:	0014899b          	addiw	s3,s1,1
 746:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 748:	00000517          	auipc	a0,0x0
 74c:	14853503          	ld	a0,328(a0) # 890 <freep>
 750:	c515                	beqz	a0,77c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 752:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 754:	4798                	lw	a4,8(a5)
 756:	02977f63          	bgeu	a4,s1,794 <malloc+0x70>
 75a:	8a4e                	mv	s4,s3
 75c:	0009871b          	sext.w	a4,s3
 760:	6685                	lui	a3,0x1
 762:	00d77363          	bgeu	a4,a3,768 <malloc+0x44>
 766:	6a05                	lui	s4,0x1
 768:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 76c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 770:	00000917          	auipc	s2,0x0
 774:	12090913          	addi	s2,s2,288 # 890 <freep>
  if(p == (char*)-1)
 778:	5afd                	li	s5,-1
 77a:	a88d                	j	7ec <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 77c:	00000797          	auipc	a5,0x0
 780:	11c78793          	addi	a5,a5,284 # 898 <base>
 784:	00000717          	auipc	a4,0x0
 788:	10f73623          	sd	a5,268(a4) # 890 <freep>
 78c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 78e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 792:	b7e1                	j	75a <malloc+0x36>
      if(p->s.size == nunits)
 794:	02e48b63          	beq	s1,a4,7ca <malloc+0xa6>
        p->s.size -= nunits;
 798:	4137073b          	subw	a4,a4,s3
 79c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 79e:	1702                	slli	a4,a4,0x20
 7a0:	9301                	srli	a4,a4,0x20
 7a2:	0712                	slli	a4,a4,0x4
 7a4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7a6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7aa:	00000717          	auipc	a4,0x0
 7ae:	0ea73323          	sd	a0,230(a4) # 890 <freep>
      return (void*)(p + 1);
 7b2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7b6:	70e2                	ld	ra,56(sp)
 7b8:	7442                	ld	s0,48(sp)
 7ba:	74a2                	ld	s1,40(sp)
 7bc:	7902                	ld	s2,32(sp)
 7be:	69e2                	ld	s3,24(sp)
 7c0:	6a42                	ld	s4,16(sp)
 7c2:	6aa2                	ld	s5,8(sp)
 7c4:	6b02                	ld	s6,0(sp)
 7c6:	6121                	addi	sp,sp,64
 7c8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7ca:	6398                	ld	a4,0(a5)
 7cc:	e118                	sd	a4,0(a0)
 7ce:	bff1                	j	7aa <malloc+0x86>
  hp->s.size = nu;
 7d0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7d4:	0541                	addi	a0,a0,16
 7d6:	00000097          	auipc	ra,0x0
 7da:	ec6080e7          	jalr	-314(ra) # 69c <free>
  return freep;
 7de:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7e2:	d971                	beqz	a0,7b6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e6:	4798                	lw	a4,8(a5)
 7e8:	fa9776e3          	bgeu	a4,s1,794 <malloc+0x70>
    if(p == freep)
 7ec:	00093703          	ld	a4,0(s2)
 7f0:	853e                	mv	a0,a5
 7f2:	fef719e3          	bne	a4,a5,7e4 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7f6:	8552                	mv	a0,s4
 7f8:	00000097          	auipc	ra,0x0
 7fc:	b66080e7          	jalr	-1178(ra) # 35e <sbrk>
  if(p == (char*)-1)
 800:	fd5518e3          	bne	a0,s5,7d0 <malloc+0xac>
        return 0;
 804:	4501                	li	a0,0
 806:	bf45                	j	7b6 <malloc+0x92>
