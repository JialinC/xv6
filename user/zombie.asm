
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
   c:	210080e7          	jalr	528(ra) # 218 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	20a080e7          	jalr	522(ra) # 220 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	290080e7          	jalr	656(ra) # 2b0 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

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
 11c:	120080e7          	jalr	288(ra) # 238 <read>
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
 16e:	0f6080e7          	jalr	246(ra) # 260 <open>
  if(fd < 0)
 172:	02054563          	bltz	a0,19c <stat+0x42>
 176:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 178:	85ca                	mv	a1,s2
 17a:	00000097          	auipc	ra,0x0
 17e:	0fe080e7          	jalr	254(ra) # 278 <fstat>
 182:	892a                	mv	s2,a0
  close(fd);
 184:	8526                	mv	a0,s1
 186:	00000097          	auipc	ra,0x0
 18a:	0c2080e7          	jalr	194(ra) # 248 <close>
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

0000000000000218 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 218:	4885                	li	a7,1
 ecall
 21a:	00000073          	ecall
 ret
 21e:	8082                	ret

0000000000000220 <exit>:
.global exit
exit:
 li a7, SYS_exit
 220:	4889                	li	a7,2
 ecall
 222:	00000073          	ecall
 ret
 226:	8082                	ret

0000000000000228 <wait>:
.global wait
wait:
 li a7, SYS_wait
 228:	488d                	li	a7,3
 ecall
 22a:	00000073          	ecall
 ret
 22e:	8082                	ret

0000000000000230 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 230:	4891                	li	a7,4
 ecall
 232:	00000073          	ecall
 ret
 236:	8082                	ret

0000000000000238 <read>:
.global read
read:
 li a7, SYS_read
 238:	4895                	li	a7,5
 ecall
 23a:	00000073          	ecall
 ret
 23e:	8082                	ret

0000000000000240 <write>:
.global write
write:
 li a7, SYS_write
 240:	48c1                	li	a7,16
 ecall
 242:	00000073          	ecall
 ret
 246:	8082                	ret

0000000000000248 <close>:
.global close
close:
 li a7, SYS_close
 248:	48d5                	li	a7,21
 ecall
 24a:	00000073          	ecall
 ret
 24e:	8082                	ret

0000000000000250 <kill>:
.global kill
kill:
 li a7, SYS_kill
 250:	4899                	li	a7,6
 ecall
 252:	00000073          	ecall
 ret
 256:	8082                	ret

0000000000000258 <exec>:
.global exec
exec:
 li a7, SYS_exec
 258:	489d                	li	a7,7
 ecall
 25a:	00000073          	ecall
 ret
 25e:	8082                	ret

0000000000000260 <open>:
.global open
open:
 li a7, SYS_open
 260:	48bd                	li	a7,15
 ecall
 262:	00000073          	ecall
 ret
 266:	8082                	ret

0000000000000268 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 268:	48c5                	li	a7,17
 ecall
 26a:	00000073          	ecall
 ret
 26e:	8082                	ret

0000000000000270 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 270:	48c9                	li	a7,18
 ecall
 272:	00000073          	ecall
 ret
 276:	8082                	ret

0000000000000278 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 278:	48a1                	li	a7,8
 ecall
 27a:	00000073          	ecall
 ret
 27e:	8082                	ret

0000000000000280 <link>:
.global link
link:
 li a7, SYS_link
 280:	48cd                	li	a7,19
 ecall
 282:	00000073          	ecall
 ret
 286:	8082                	ret

0000000000000288 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 288:	48d1                	li	a7,20
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 290:	48a5                	li	a7,9
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <dup>:
.global dup
dup:
 li a7, SYS_dup
 298:	48a9                	li	a7,10
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2a0:	48ad                	li	a7,11
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2a8:	48b1                	li	a7,12
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2b0:	48b5                	li	a7,13
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 2b8:	48b9                	li	a7,14
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
 2c0:	48d9                	li	a7,22
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 2c8:	48dd                	li	a7,23
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 2d0:	48e1                	li	a7,24
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 2d8:	1101                	addi	sp,sp,-32
 2da:	ec06                	sd	ra,24(sp)
 2dc:	e822                	sd	s0,16(sp)
 2de:	1000                	addi	s0,sp,32
 2e0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 2e4:	4605                	li	a2,1
 2e6:	fef40593          	addi	a1,s0,-17
 2ea:	00000097          	auipc	ra,0x0
 2ee:	f56080e7          	jalr	-170(ra) # 240 <write>
}
 2f2:	60e2                	ld	ra,24(sp)
 2f4:	6442                	ld	s0,16(sp)
 2f6:	6105                	addi	sp,sp,32
 2f8:	8082                	ret

00000000000002fa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2fa:	7139                	addi	sp,sp,-64
 2fc:	fc06                	sd	ra,56(sp)
 2fe:	f822                	sd	s0,48(sp)
 300:	f426                	sd	s1,40(sp)
 302:	f04a                	sd	s2,32(sp)
 304:	ec4e                	sd	s3,24(sp)
 306:	0080                	addi	s0,sp,64
 308:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 30a:	c299                	beqz	a3,310 <printint+0x16>
 30c:	0805c863          	bltz	a1,39c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 310:	2581                	sext.w	a1,a1
  neg = 0;
 312:	4881                	li	a7,0
 314:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 318:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 31a:	2601                	sext.w	a2,a2
 31c:	00000517          	auipc	a0,0x0
 320:	44450513          	addi	a0,a0,1092 # 760 <digits>
 324:	883a                	mv	a6,a4
 326:	2705                	addiw	a4,a4,1
 328:	02c5f7bb          	remuw	a5,a1,a2
 32c:	1782                	slli	a5,a5,0x20
 32e:	9381                	srli	a5,a5,0x20
 330:	97aa                	add	a5,a5,a0
 332:	0007c783          	lbu	a5,0(a5)
 336:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 33a:	0005879b          	sext.w	a5,a1
 33e:	02c5d5bb          	divuw	a1,a1,a2
 342:	0685                	addi	a3,a3,1
 344:	fec7f0e3          	bgeu	a5,a2,324 <printint+0x2a>
  if(neg)
 348:	00088b63          	beqz	a7,35e <printint+0x64>
    buf[i++] = '-';
 34c:	fd040793          	addi	a5,s0,-48
 350:	973e                	add	a4,a4,a5
 352:	02d00793          	li	a5,45
 356:	fef70823          	sb	a5,-16(a4)
 35a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 35e:	02e05863          	blez	a4,38e <printint+0x94>
 362:	fc040793          	addi	a5,s0,-64
 366:	00e78933          	add	s2,a5,a4
 36a:	fff78993          	addi	s3,a5,-1
 36e:	99ba                	add	s3,s3,a4
 370:	377d                	addiw	a4,a4,-1
 372:	1702                	slli	a4,a4,0x20
 374:	9301                	srli	a4,a4,0x20
 376:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 37a:	fff94583          	lbu	a1,-1(s2)
 37e:	8526                	mv	a0,s1
 380:	00000097          	auipc	ra,0x0
 384:	f58080e7          	jalr	-168(ra) # 2d8 <putc>
  while(--i >= 0)
 388:	197d                	addi	s2,s2,-1
 38a:	ff3918e3          	bne	s2,s3,37a <printint+0x80>
}
 38e:	70e2                	ld	ra,56(sp)
 390:	7442                	ld	s0,48(sp)
 392:	74a2                	ld	s1,40(sp)
 394:	7902                	ld	s2,32(sp)
 396:	69e2                	ld	s3,24(sp)
 398:	6121                	addi	sp,sp,64
 39a:	8082                	ret
    x = -xx;
 39c:	40b005bb          	negw	a1,a1
    neg = 1;
 3a0:	4885                	li	a7,1
    x = -xx;
 3a2:	bf8d                	j	314 <printint+0x1a>

00000000000003a4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3a4:	7119                	addi	sp,sp,-128
 3a6:	fc86                	sd	ra,120(sp)
 3a8:	f8a2                	sd	s0,112(sp)
 3aa:	f4a6                	sd	s1,104(sp)
 3ac:	f0ca                	sd	s2,96(sp)
 3ae:	ecce                	sd	s3,88(sp)
 3b0:	e8d2                	sd	s4,80(sp)
 3b2:	e4d6                	sd	s5,72(sp)
 3b4:	e0da                	sd	s6,64(sp)
 3b6:	fc5e                	sd	s7,56(sp)
 3b8:	f862                	sd	s8,48(sp)
 3ba:	f466                	sd	s9,40(sp)
 3bc:	f06a                	sd	s10,32(sp)
 3be:	ec6e                	sd	s11,24(sp)
 3c0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3c2:	0005c903          	lbu	s2,0(a1)
 3c6:	18090f63          	beqz	s2,564 <vprintf+0x1c0>
 3ca:	8aaa                	mv	s5,a0
 3cc:	8b32                	mv	s6,a2
 3ce:	00158493          	addi	s1,a1,1
  state = 0;
 3d2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3d4:	02500a13          	li	s4,37
      if(c == 'd'){
 3d8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 3dc:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 3e0:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 3e4:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 3e8:	00000b97          	auipc	s7,0x0
 3ec:	378b8b93          	addi	s7,s7,888 # 760 <digits>
 3f0:	a839                	j	40e <vprintf+0x6a>
        putc(fd, c);
 3f2:	85ca                	mv	a1,s2
 3f4:	8556                	mv	a0,s5
 3f6:	00000097          	auipc	ra,0x0
 3fa:	ee2080e7          	jalr	-286(ra) # 2d8 <putc>
 3fe:	a019                	j	404 <vprintf+0x60>
    } else if(state == '%'){
 400:	01498f63          	beq	s3,s4,41e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 404:	0485                	addi	s1,s1,1
 406:	fff4c903          	lbu	s2,-1(s1)
 40a:	14090d63          	beqz	s2,564 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 40e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 412:	fe0997e3          	bnez	s3,400 <vprintf+0x5c>
      if(c == '%'){
 416:	fd479ee3          	bne	a5,s4,3f2 <vprintf+0x4e>
        state = '%';
 41a:	89be                	mv	s3,a5
 41c:	b7e5                	j	404 <vprintf+0x60>
      if(c == 'd'){
 41e:	05878063          	beq	a5,s8,45e <vprintf+0xba>
      } else if(c == 'l') {
 422:	05978c63          	beq	a5,s9,47a <vprintf+0xd6>
      } else if(c == 'x') {
 426:	07a78863          	beq	a5,s10,496 <vprintf+0xf2>
      } else if(c == 'p') {
 42a:	09b78463          	beq	a5,s11,4b2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 42e:	07300713          	li	a4,115
 432:	0ce78663          	beq	a5,a4,4fe <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 436:	06300713          	li	a4,99
 43a:	0ee78e63          	beq	a5,a4,536 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 43e:	11478863          	beq	a5,s4,54e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 442:	85d2                	mv	a1,s4
 444:	8556                	mv	a0,s5
 446:	00000097          	auipc	ra,0x0
 44a:	e92080e7          	jalr	-366(ra) # 2d8 <putc>
        putc(fd, c);
 44e:	85ca                	mv	a1,s2
 450:	8556                	mv	a0,s5
 452:	00000097          	auipc	ra,0x0
 456:	e86080e7          	jalr	-378(ra) # 2d8 <putc>
      }
      state = 0;
 45a:	4981                	li	s3,0
 45c:	b765                	j	404 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 45e:	008b0913          	addi	s2,s6,8
 462:	4685                	li	a3,1
 464:	4629                	li	a2,10
 466:	000b2583          	lw	a1,0(s6)
 46a:	8556                	mv	a0,s5
 46c:	00000097          	auipc	ra,0x0
 470:	e8e080e7          	jalr	-370(ra) # 2fa <printint>
 474:	8b4a                	mv	s6,s2
      state = 0;
 476:	4981                	li	s3,0
 478:	b771                	j	404 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 47a:	008b0913          	addi	s2,s6,8
 47e:	4681                	li	a3,0
 480:	4629                	li	a2,10
 482:	000b2583          	lw	a1,0(s6)
 486:	8556                	mv	a0,s5
 488:	00000097          	auipc	ra,0x0
 48c:	e72080e7          	jalr	-398(ra) # 2fa <printint>
 490:	8b4a                	mv	s6,s2
      state = 0;
 492:	4981                	li	s3,0
 494:	bf85                	j	404 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 496:	008b0913          	addi	s2,s6,8
 49a:	4681                	li	a3,0
 49c:	4641                	li	a2,16
 49e:	000b2583          	lw	a1,0(s6)
 4a2:	8556                	mv	a0,s5
 4a4:	00000097          	auipc	ra,0x0
 4a8:	e56080e7          	jalr	-426(ra) # 2fa <printint>
 4ac:	8b4a                	mv	s6,s2
      state = 0;
 4ae:	4981                	li	s3,0
 4b0:	bf91                	j	404 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4b2:	008b0793          	addi	a5,s6,8
 4b6:	f8f43423          	sd	a5,-120(s0)
 4ba:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 4be:	03000593          	li	a1,48
 4c2:	8556                	mv	a0,s5
 4c4:	00000097          	auipc	ra,0x0
 4c8:	e14080e7          	jalr	-492(ra) # 2d8 <putc>
  putc(fd, 'x');
 4cc:	85ea                	mv	a1,s10
 4ce:	8556                	mv	a0,s5
 4d0:	00000097          	auipc	ra,0x0
 4d4:	e08080e7          	jalr	-504(ra) # 2d8 <putc>
 4d8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4da:	03c9d793          	srli	a5,s3,0x3c
 4de:	97de                	add	a5,a5,s7
 4e0:	0007c583          	lbu	a1,0(a5)
 4e4:	8556                	mv	a0,s5
 4e6:	00000097          	auipc	ra,0x0
 4ea:	df2080e7          	jalr	-526(ra) # 2d8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 4ee:	0992                	slli	s3,s3,0x4
 4f0:	397d                	addiw	s2,s2,-1
 4f2:	fe0914e3          	bnez	s2,4da <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 4f6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 4fa:	4981                	li	s3,0
 4fc:	b721                	j	404 <vprintf+0x60>
        s = va_arg(ap, char*);
 4fe:	008b0993          	addi	s3,s6,8
 502:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 506:	02090163          	beqz	s2,528 <vprintf+0x184>
        while(*s != 0){
 50a:	00094583          	lbu	a1,0(s2)
 50e:	c9a1                	beqz	a1,55e <vprintf+0x1ba>
          putc(fd, *s);
 510:	8556                	mv	a0,s5
 512:	00000097          	auipc	ra,0x0
 516:	dc6080e7          	jalr	-570(ra) # 2d8 <putc>
          s++;
 51a:	0905                	addi	s2,s2,1
        while(*s != 0){
 51c:	00094583          	lbu	a1,0(s2)
 520:	f9e5                	bnez	a1,510 <vprintf+0x16c>
        s = va_arg(ap, char*);
 522:	8b4e                	mv	s6,s3
      state = 0;
 524:	4981                	li	s3,0
 526:	bdf9                	j	404 <vprintf+0x60>
          s = "(null)";
 528:	00000917          	auipc	s2,0x0
 52c:	23090913          	addi	s2,s2,560 # 758 <malloc+0xea>
        while(*s != 0){
 530:	02800593          	li	a1,40
 534:	bff1                	j	510 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 536:	008b0913          	addi	s2,s6,8
 53a:	000b4583          	lbu	a1,0(s6)
 53e:	8556                	mv	a0,s5
 540:	00000097          	auipc	ra,0x0
 544:	d98080e7          	jalr	-616(ra) # 2d8 <putc>
 548:	8b4a                	mv	s6,s2
      state = 0;
 54a:	4981                	li	s3,0
 54c:	bd65                	j	404 <vprintf+0x60>
        putc(fd, c);
 54e:	85d2                	mv	a1,s4
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	d86080e7          	jalr	-634(ra) # 2d8 <putc>
      state = 0;
 55a:	4981                	li	s3,0
 55c:	b565                	j	404 <vprintf+0x60>
        s = va_arg(ap, char*);
 55e:	8b4e                	mv	s6,s3
      state = 0;
 560:	4981                	li	s3,0
 562:	b54d                	j	404 <vprintf+0x60>
    }
  }
}
 564:	70e6                	ld	ra,120(sp)
 566:	7446                	ld	s0,112(sp)
 568:	74a6                	ld	s1,104(sp)
 56a:	7906                	ld	s2,96(sp)
 56c:	69e6                	ld	s3,88(sp)
 56e:	6a46                	ld	s4,80(sp)
 570:	6aa6                	ld	s5,72(sp)
 572:	6b06                	ld	s6,64(sp)
 574:	7be2                	ld	s7,56(sp)
 576:	7c42                	ld	s8,48(sp)
 578:	7ca2                	ld	s9,40(sp)
 57a:	7d02                	ld	s10,32(sp)
 57c:	6de2                	ld	s11,24(sp)
 57e:	6109                	addi	sp,sp,128
 580:	8082                	ret

0000000000000582 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 582:	715d                	addi	sp,sp,-80
 584:	ec06                	sd	ra,24(sp)
 586:	e822                	sd	s0,16(sp)
 588:	1000                	addi	s0,sp,32
 58a:	e010                	sd	a2,0(s0)
 58c:	e414                	sd	a3,8(s0)
 58e:	e818                	sd	a4,16(s0)
 590:	ec1c                	sd	a5,24(s0)
 592:	03043023          	sd	a6,32(s0)
 596:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 59a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 59e:	8622                	mv	a2,s0
 5a0:	00000097          	auipc	ra,0x0
 5a4:	e04080e7          	jalr	-508(ra) # 3a4 <vprintf>
}
 5a8:	60e2                	ld	ra,24(sp)
 5aa:	6442                	ld	s0,16(sp)
 5ac:	6161                	addi	sp,sp,80
 5ae:	8082                	ret

00000000000005b0 <printf>:

void
printf(const char *fmt, ...)
{
 5b0:	711d                	addi	sp,sp,-96
 5b2:	ec06                	sd	ra,24(sp)
 5b4:	e822                	sd	s0,16(sp)
 5b6:	1000                	addi	s0,sp,32
 5b8:	e40c                	sd	a1,8(s0)
 5ba:	e810                	sd	a2,16(s0)
 5bc:	ec14                	sd	a3,24(s0)
 5be:	f018                	sd	a4,32(s0)
 5c0:	f41c                	sd	a5,40(s0)
 5c2:	03043823          	sd	a6,48(s0)
 5c6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 5ca:	00840613          	addi	a2,s0,8
 5ce:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 5d2:	85aa                	mv	a1,a0
 5d4:	4505                	li	a0,1
 5d6:	00000097          	auipc	ra,0x0
 5da:	dce080e7          	jalr	-562(ra) # 3a4 <vprintf>
}
 5de:	60e2                	ld	ra,24(sp)
 5e0:	6442                	ld	s0,16(sp)
 5e2:	6125                	addi	sp,sp,96
 5e4:	8082                	ret

00000000000005e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e6:	1141                	addi	sp,sp,-16
 5e8:	e422                	sd	s0,8(sp)
 5ea:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ec:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f0:	00000797          	auipc	a5,0x0
 5f4:	1887b783          	ld	a5,392(a5) # 778 <freep>
 5f8:	a805                	j	628 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 5fa:	4618                	lw	a4,8(a2)
 5fc:	9db9                	addw	a1,a1,a4
 5fe:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 602:	6398                	ld	a4,0(a5)
 604:	6318                	ld	a4,0(a4)
 606:	fee53823          	sd	a4,-16(a0)
 60a:	a091                	j	64e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 60c:	ff852703          	lw	a4,-8(a0)
 610:	9e39                	addw	a2,a2,a4
 612:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 614:	ff053703          	ld	a4,-16(a0)
 618:	e398                	sd	a4,0(a5)
 61a:	a099                	j	660 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61c:	6398                	ld	a4,0(a5)
 61e:	00e7e463          	bltu	a5,a4,626 <free+0x40>
 622:	00e6ea63          	bltu	a3,a4,636 <free+0x50>
{
 626:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 628:	fed7fae3          	bgeu	a5,a3,61c <free+0x36>
 62c:	6398                	ld	a4,0(a5)
 62e:	00e6e463          	bltu	a3,a4,636 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 632:	fee7eae3          	bltu	a5,a4,626 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 636:	ff852583          	lw	a1,-8(a0)
 63a:	6390                	ld	a2,0(a5)
 63c:	02059713          	slli	a4,a1,0x20
 640:	9301                	srli	a4,a4,0x20
 642:	0712                	slli	a4,a4,0x4
 644:	9736                	add	a4,a4,a3
 646:	fae60ae3          	beq	a2,a4,5fa <free+0x14>
    bp->s.ptr = p->s.ptr;
 64a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 64e:	4790                	lw	a2,8(a5)
 650:	02061713          	slli	a4,a2,0x20
 654:	9301                	srli	a4,a4,0x20
 656:	0712                	slli	a4,a4,0x4
 658:	973e                	add	a4,a4,a5
 65a:	fae689e3          	beq	a3,a4,60c <free+0x26>
  } else
    p->s.ptr = bp;
 65e:	e394                	sd	a3,0(a5)
  freep = p;
 660:	00000717          	auipc	a4,0x0
 664:	10f73c23          	sd	a5,280(a4) # 778 <freep>
}
 668:	6422                	ld	s0,8(sp)
 66a:	0141                	addi	sp,sp,16
 66c:	8082                	ret

000000000000066e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 66e:	7139                	addi	sp,sp,-64
 670:	fc06                	sd	ra,56(sp)
 672:	f822                	sd	s0,48(sp)
 674:	f426                	sd	s1,40(sp)
 676:	f04a                	sd	s2,32(sp)
 678:	ec4e                	sd	s3,24(sp)
 67a:	e852                	sd	s4,16(sp)
 67c:	e456                	sd	s5,8(sp)
 67e:	e05a                	sd	s6,0(sp)
 680:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 682:	02051493          	slli	s1,a0,0x20
 686:	9081                	srli	s1,s1,0x20
 688:	04bd                	addi	s1,s1,15
 68a:	8091                	srli	s1,s1,0x4
 68c:	0014899b          	addiw	s3,s1,1
 690:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 692:	00000517          	auipc	a0,0x0
 696:	0e653503          	ld	a0,230(a0) # 778 <freep>
 69a:	c515                	beqz	a0,6c6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 69c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 69e:	4798                	lw	a4,8(a5)
 6a0:	02977f63          	bgeu	a4,s1,6de <malloc+0x70>
 6a4:	8a4e                	mv	s4,s3
 6a6:	0009871b          	sext.w	a4,s3
 6aa:	6685                	lui	a3,0x1
 6ac:	00d77363          	bgeu	a4,a3,6b2 <malloc+0x44>
 6b0:	6a05                	lui	s4,0x1
 6b2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6b6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6ba:	00000917          	auipc	s2,0x0
 6be:	0be90913          	addi	s2,s2,190 # 778 <freep>
  if(p == (char*)-1)
 6c2:	5afd                	li	s5,-1
 6c4:	a88d                	j	736 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 6c6:	00000797          	auipc	a5,0x0
 6ca:	0ba78793          	addi	a5,a5,186 # 780 <base>
 6ce:	00000717          	auipc	a4,0x0
 6d2:	0af73523          	sd	a5,170(a4) # 778 <freep>
 6d6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 6d8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 6dc:	b7e1                	j	6a4 <malloc+0x36>
      if(p->s.size == nunits)
 6de:	02e48b63          	beq	s1,a4,714 <malloc+0xa6>
        p->s.size -= nunits;
 6e2:	4137073b          	subw	a4,a4,s3
 6e6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 6e8:	1702                	slli	a4,a4,0x20
 6ea:	9301                	srli	a4,a4,0x20
 6ec:	0712                	slli	a4,a4,0x4
 6ee:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 6f0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 6f4:	00000717          	auipc	a4,0x0
 6f8:	08a73223          	sd	a0,132(a4) # 778 <freep>
      return (void*)(p + 1);
 6fc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 700:	70e2                	ld	ra,56(sp)
 702:	7442                	ld	s0,48(sp)
 704:	74a2                	ld	s1,40(sp)
 706:	7902                	ld	s2,32(sp)
 708:	69e2                	ld	s3,24(sp)
 70a:	6a42                	ld	s4,16(sp)
 70c:	6aa2                	ld	s5,8(sp)
 70e:	6b02                	ld	s6,0(sp)
 710:	6121                	addi	sp,sp,64
 712:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 714:	6398                	ld	a4,0(a5)
 716:	e118                	sd	a4,0(a0)
 718:	bff1                	j	6f4 <malloc+0x86>
  hp->s.size = nu;
 71a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 71e:	0541                	addi	a0,a0,16
 720:	00000097          	auipc	ra,0x0
 724:	ec6080e7          	jalr	-314(ra) # 5e6 <free>
  return freep;
 728:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 72c:	d971                	beqz	a0,700 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 730:	4798                	lw	a4,8(a5)
 732:	fa9776e3          	bgeu	a4,s1,6de <malloc+0x70>
    if(p == freep)
 736:	00093703          	ld	a4,0(s2)
 73a:	853e                	mv	a0,a5
 73c:	fef719e3          	bne	a4,a5,72e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 740:	8552                	mv	a0,s4
 742:	00000097          	auipc	ra,0x0
 746:	b66080e7          	jalr	-1178(ra) # 2a8 <sbrk>
  if(p == (char*)-1)
 74a:	fd5518e3          	bne	a0,s5,71a <malloc+0xac>
        return 0;
 74e:	4501                	li	a0,0
 750:	bf45                	j	700 <malloc+0x92>
