
user/_test1:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int main(int argc, char *argv[]){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
	int answer;
	answer = getreadcount();
   8:	00000097          	auipc	ra,0x0
   c:	2ba080e7          	jalr	698(ra) # 2c2 <getreadcount>
  10:	85aa                	mv	a1,a0
	printf("answer: %d\n", answer);
  12:	00000517          	auipc	a0,0x0
  16:	74650513          	addi	a0,a0,1862 # 758 <malloc+0xe8>
  1a:	00000097          	auipc	ra,0x0
  1e:	598080e7          	jalr	1432(ra) # 5b2 <printf>
	exit(0);
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	1fe080e7          	jalr	510(ra) # 222 <exit>

000000000000002c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  2c:	1141                	addi	sp,sp,-16
  2e:	e422                	sd	s0,8(sp)
  30:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  32:	87aa                	mv	a5,a0
  34:	0585                	addi	a1,a1,1
  36:	0785                	addi	a5,a5,1
  38:	fff5c703          	lbu	a4,-1(a1)
  3c:	fee78fa3          	sb	a4,-1(a5)
  40:	fb75                	bnez	a4,34 <strcpy+0x8>
    ;
  return os;
}
  42:	6422                	ld	s0,8(sp)
  44:	0141                	addi	sp,sp,16
  46:	8082                	ret

0000000000000048 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  48:	1141                	addi	sp,sp,-16
  4a:	e422                	sd	s0,8(sp)
  4c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4e:	00054783          	lbu	a5,0(a0)
  52:	cb91                	beqz	a5,66 <strcmp+0x1e>
  54:	0005c703          	lbu	a4,0(a1)
  58:	00f71763          	bne	a4,a5,66 <strcmp+0x1e>
    p++, q++;
  5c:	0505                	addi	a0,a0,1
  5e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  60:	00054783          	lbu	a5,0(a0)
  64:	fbe5                	bnez	a5,54 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  66:	0005c503          	lbu	a0,0(a1)
}
  6a:	40a7853b          	subw	a0,a5,a0
  6e:	6422                	ld	s0,8(sp)
  70:	0141                	addi	sp,sp,16
  72:	8082                	ret

0000000000000074 <strlen>:

uint
strlen(const char *s)
{
  74:	1141                	addi	sp,sp,-16
  76:	e422                	sd	s0,8(sp)
  78:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7a:	00054783          	lbu	a5,0(a0)
  7e:	cf91                	beqz	a5,9a <strlen+0x26>
  80:	0505                	addi	a0,a0,1
  82:	87aa                	mv	a5,a0
  84:	4685                	li	a3,1
  86:	9e89                	subw	a3,a3,a0
  88:	00f6853b          	addw	a0,a3,a5
  8c:	0785                	addi	a5,a5,1
  8e:	fff7c703          	lbu	a4,-1(a5)
  92:	fb7d                	bnez	a4,88 <strlen+0x14>
    ;
  return n;
}
  94:	6422                	ld	s0,8(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret
  for(n = 0; s[n]; n++)
  9a:	4501                	li	a0,0
  9c:	bfe5                	j	94 <strlen+0x20>

000000000000009e <memset>:

void*
memset(void *dst, int c, uint n)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e422                	sd	s0,8(sp)
  a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a4:	ce09                	beqz	a2,be <memset+0x20>
  a6:	87aa                	mv	a5,a0
  a8:	fff6071b          	addiw	a4,a2,-1
  ac:	1702                	slli	a4,a4,0x20
  ae:	9301                	srli	a4,a4,0x20
  b0:	0705                	addi	a4,a4,1
  b2:	972a                	add	a4,a4,a0
    cdst[i] = c;
  b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b8:	0785                	addi	a5,a5,1
  ba:	fee79de3          	bne	a5,a4,b4 <memset+0x16>
  }
  return dst;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char*
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb99                	beqz	a5,e4 <strchr+0x20>
    if(*s == c)
  d0:	00f58763          	beq	a1,a5,de <strchr+0x1a>
  for(; *s; s++)
  d4:	0505                	addi	a0,a0,1
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbfd                	bnez	a5,d0 <strchr+0xc>
      return (char*)s;
  return 0;
  dc:	4501                	li	a0,0
}
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret
  return 0;
  e4:	4501                	li	a0,0
  e6:	bfe5                	j	de <strchr+0x1a>

00000000000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	711d                	addi	sp,sp,-96
  ea:	ec86                	sd	ra,88(sp)
  ec:	e8a2                	sd	s0,80(sp)
  ee:	e4a6                	sd	s1,72(sp)
  f0:	e0ca                	sd	s2,64(sp)
  f2:	fc4e                	sd	s3,56(sp)
  f4:	f852                	sd	s4,48(sp)
  f6:	f456                	sd	s5,40(sp)
  f8:	f05a                	sd	s6,32(sp)
  fa:	ec5e                	sd	s7,24(sp)
  fc:	1080                	addi	s0,sp,96
  fe:	8baa                	mv	s7,a0
 100:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 102:	892a                	mv	s2,a0
 104:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 106:	4aa9                	li	s5,10
 108:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 10a:	89a6                	mv	s3,s1
 10c:	2485                	addiw	s1,s1,1
 10e:	0344d863          	bge	s1,s4,13e <gets+0x56>
    cc = read(0, &c, 1);
 112:	4605                	li	a2,1
 114:	faf40593          	addi	a1,s0,-81
 118:	4501                	li	a0,0
 11a:	00000097          	auipc	ra,0x0
 11e:	120080e7          	jalr	288(ra) # 23a <read>
    if(cc < 1)
 122:	00a05e63          	blez	a0,13e <gets+0x56>
    buf[i++] = c;
 126:	faf44783          	lbu	a5,-81(s0)
 12a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12e:	01578763          	beq	a5,s5,13c <gets+0x54>
 132:	0905                	addi	s2,s2,1
 134:	fd679be3          	bne	a5,s6,10a <gets+0x22>
  for(i=0; i+1 < max; ){
 138:	89a6                	mv	s3,s1
 13a:	a011                	j	13e <gets+0x56>
 13c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13e:	99de                	add	s3,s3,s7
 140:	00098023          	sb	zero,0(s3)
  return buf;
}
 144:	855e                	mv	a0,s7
 146:	60e6                	ld	ra,88(sp)
 148:	6446                	ld	s0,80(sp)
 14a:	64a6                	ld	s1,72(sp)
 14c:	6906                	ld	s2,64(sp)
 14e:	79e2                	ld	s3,56(sp)
 150:	7a42                	ld	s4,48(sp)
 152:	7aa2                	ld	s5,40(sp)
 154:	7b02                	ld	s6,32(sp)
 156:	6be2                	ld	s7,24(sp)
 158:	6125                	addi	sp,sp,96
 15a:	8082                	ret

000000000000015c <stat>:

int
stat(const char *n, struct stat *st)
{
 15c:	1101                	addi	sp,sp,-32
 15e:	ec06                	sd	ra,24(sp)
 160:	e822                	sd	s0,16(sp)
 162:	e426                	sd	s1,8(sp)
 164:	e04a                	sd	s2,0(sp)
 166:	1000                	addi	s0,sp,32
 168:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 16a:	4581                	li	a1,0
 16c:	00000097          	auipc	ra,0x0
 170:	0f6080e7          	jalr	246(ra) # 262 <open>
  if(fd < 0)
 174:	02054563          	bltz	a0,19e <stat+0x42>
 178:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 17a:	85ca                	mv	a1,s2
 17c:	00000097          	auipc	ra,0x0
 180:	0fe080e7          	jalr	254(ra) # 27a <fstat>
 184:	892a                	mv	s2,a0
  close(fd);
 186:	8526                	mv	a0,s1
 188:	00000097          	auipc	ra,0x0
 18c:	0c2080e7          	jalr	194(ra) # 24a <close>
  return r;
}
 190:	854a                	mv	a0,s2
 192:	60e2                	ld	ra,24(sp)
 194:	6442                	ld	s0,16(sp)
 196:	64a2                	ld	s1,8(sp)
 198:	6902                	ld	s2,0(sp)
 19a:	6105                	addi	sp,sp,32
 19c:	8082                	ret
    return -1;
 19e:	597d                	li	s2,-1
 1a0:	bfc5                	j	190 <stat+0x34>

00000000000001a2 <atoi>:

int
atoi(const char *s)
{
 1a2:	1141                	addi	sp,sp,-16
 1a4:	e422                	sd	s0,8(sp)
 1a6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a8:	00054603          	lbu	a2,0(a0)
 1ac:	fd06079b          	addiw	a5,a2,-48
 1b0:	0ff7f793          	andi	a5,a5,255
 1b4:	4725                	li	a4,9
 1b6:	02f76963          	bltu	a4,a5,1e8 <atoi+0x46>
 1ba:	86aa                	mv	a3,a0
  n = 0;
 1bc:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1be:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1c0:	0685                	addi	a3,a3,1
 1c2:	0025179b          	slliw	a5,a0,0x2
 1c6:	9fa9                	addw	a5,a5,a0
 1c8:	0017979b          	slliw	a5,a5,0x1
 1cc:	9fb1                	addw	a5,a5,a2
 1ce:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d2:	0006c603          	lbu	a2,0(a3)
 1d6:	fd06071b          	addiw	a4,a2,-48
 1da:	0ff77713          	andi	a4,a4,255
 1de:	fee5f1e3          	bgeu	a1,a4,1c0 <atoi+0x1e>
  return n;
}
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret
  n = 0;
 1e8:	4501                	li	a0,0
 1ea:	bfe5                	j	1e2 <atoi+0x40>

00000000000001ec <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1f2:	02c05163          	blez	a2,214 <memmove+0x28>
 1f6:	fff6071b          	addiw	a4,a2,-1
 1fa:	1702                	slli	a4,a4,0x20
 1fc:	9301                	srli	a4,a4,0x20
 1fe:	0705                	addi	a4,a4,1
 200:	972a                	add	a4,a4,a0
  dst = vdst;
 202:	87aa                	mv	a5,a0
    *dst++ = *src++;
 204:	0585                	addi	a1,a1,1
 206:	0785                	addi	a5,a5,1
 208:	fff5c683          	lbu	a3,-1(a1)
 20c:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 210:	fee79ae3          	bne	a5,a4,204 <memmove+0x18>
  return vdst;
}
 214:	6422                	ld	s0,8(sp)
 216:	0141                	addi	sp,sp,16
 218:	8082                	ret

000000000000021a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 21a:	4885                	li	a7,1
 ecall
 21c:	00000073          	ecall
 ret
 220:	8082                	ret

0000000000000222 <exit>:
.global exit
exit:
 li a7, SYS_exit
 222:	4889                	li	a7,2
 ecall
 224:	00000073          	ecall
 ret
 228:	8082                	ret

000000000000022a <wait>:
.global wait
wait:
 li a7, SYS_wait
 22a:	488d                	li	a7,3
 ecall
 22c:	00000073          	ecall
 ret
 230:	8082                	ret

0000000000000232 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 232:	4891                	li	a7,4
 ecall
 234:	00000073          	ecall
 ret
 238:	8082                	ret

000000000000023a <read>:
.global read
read:
 li a7, SYS_read
 23a:	4895                	li	a7,5
 ecall
 23c:	00000073          	ecall
 ret
 240:	8082                	ret

0000000000000242 <write>:
.global write
write:
 li a7, SYS_write
 242:	48c1                	li	a7,16
 ecall
 244:	00000073          	ecall
 ret
 248:	8082                	ret

000000000000024a <close>:
.global close
close:
 li a7, SYS_close
 24a:	48d5                	li	a7,21
 ecall
 24c:	00000073          	ecall
 ret
 250:	8082                	ret

0000000000000252 <kill>:
.global kill
kill:
 li a7, SYS_kill
 252:	4899                	li	a7,6
 ecall
 254:	00000073          	ecall
 ret
 258:	8082                	ret

000000000000025a <exec>:
.global exec
exec:
 li a7, SYS_exec
 25a:	489d                	li	a7,7
 ecall
 25c:	00000073          	ecall
 ret
 260:	8082                	ret

0000000000000262 <open>:
.global open
open:
 li a7, SYS_open
 262:	48bd                	li	a7,15
 ecall
 264:	00000073          	ecall
 ret
 268:	8082                	ret

000000000000026a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 26a:	48c5                	li	a7,17
 ecall
 26c:	00000073          	ecall
 ret
 270:	8082                	ret

0000000000000272 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 272:	48c9                	li	a7,18
 ecall
 274:	00000073          	ecall
 ret
 278:	8082                	ret

000000000000027a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 27a:	48a1                	li	a7,8
 ecall
 27c:	00000073          	ecall
 ret
 280:	8082                	ret

0000000000000282 <link>:
.global link
link:
 li a7, SYS_link
 282:	48cd                	li	a7,19
 ecall
 284:	00000073          	ecall
 ret
 288:	8082                	ret

000000000000028a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 28a:	48d1                	li	a7,20
 ecall
 28c:	00000073          	ecall
 ret
 290:	8082                	ret

0000000000000292 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 292:	48a5                	li	a7,9
 ecall
 294:	00000073          	ecall
 ret
 298:	8082                	ret

000000000000029a <dup>:
.global dup
dup:
 li a7, SYS_dup
 29a:	48a9                	li	a7,10
 ecall
 29c:	00000073          	ecall
 ret
 2a0:	8082                	ret

00000000000002a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2a2:	48ad                	li	a7,11
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2aa:	48b1                	li	a7,12
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2b2:	48b5                	li	a7,13
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 2ba:	48b9                	li	a7,14
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
 2c2:	48d9                	li	a7,22
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 2ca:	48dd                	li	a7,23
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 2d2:	48e1                	li	a7,24
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 2da:	1101                	addi	sp,sp,-32
 2dc:	ec06                	sd	ra,24(sp)
 2de:	e822                	sd	s0,16(sp)
 2e0:	1000                	addi	s0,sp,32
 2e2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 2e6:	4605                	li	a2,1
 2e8:	fef40593          	addi	a1,s0,-17
 2ec:	00000097          	auipc	ra,0x0
 2f0:	f56080e7          	jalr	-170(ra) # 242 <write>
}
 2f4:	60e2                	ld	ra,24(sp)
 2f6:	6442                	ld	s0,16(sp)
 2f8:	6105                	addi	sp,sp,32
 2fa:	8082                	ret

00000000000002fc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2fc:	7139                	addi	sp,sp,-64
 2fe:	fc06                	sd	ra,56(sp)
 300:	f822                	sd	s0,48(sp)
 302:	f426                	sd	s1,40(sp)
 304:	f04a                	sd	s2,32(sp)
 306:	ec4e                	sd	s3,24(sp)
 308:	0080                	addi	s0,sp,64
 30a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 30c:	c299                	beqz	a3,312 <printint+0x16>
 30e:	0805c863          	bltz	a1,39e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 312:	2581                	sext.w	a1,a1
  neg = 0;
 314:	4881                	li	a7,0
 316:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 31a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 31c:	2601                	sext.w	a2,a2
 31e:	00000517          	auipc	a0,0x0
 322:	45250513          	addi	a0,a0,1106 # 770 <digits>
 326:	883a                	mv	a6,a4
 328:	2705                	addiw	a4,a4,1
 32a:	02c5f7bb          	remuw	a5,a1,a2
 32e:	1782                	slli	a5,a5,0x20
 330:	9381                	srli	a5,a5,0x20
 332:	97aa                	add	a5,a5,a0
 334:	0007c783          	lbu	a5,0(a5)
 338:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 33c:	0005879b          	sext.w	a5,a1
 340:	02c5d5bb          	divuw	a1,a1,a2
 344:	0685                	addi	a3,a3,1
 346:	fec7f0e3          	bgeu	a5,a2,326 <printint+0x2a>
  if(neg)
 34a:	00088b63          	beqz	a7,360 <printint+0x64>
    buf[i++] = '-';
 34e:	fd040793          	addi	a5,s0,-48
 352:	973e                	add	a4,a4,a5
 354:	02d00793          	li	a5,45
 358:	fef70823          	sb	a5,-16(a4)
 35c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 360:	02e05863          	blez	a4,390 <printint+0x94>
 364:	fc040793          	addi	a5,s0,-64
 368:	00e78933          	add	s2,a5,a4
 36c:	fff78993          	addi	s3,a5,-1
 370:	99ba                	add	s3,s3,a4
 372:	377d                	addiw	a4,a4,-1
 374:	1702                	slli	a4,a4,0x20
 376:	9301                	srli	a4,a4,0x20
 378:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 37c:	fff94583          	lbu	a1,-1(s2)
 380:	8526                	mv	a0,s1
 382:	00000097          	auipc	ra,0x0
 386:	f58080e7          	jalr	-168(ra) # 2da <putc>
  while(--i >= 0)
 38a:	197d                	addi	s2,s2,-1
 38c:	ff3918e3          	bne	s2,s3,37c <printint+0x80>
}
 390:	70e2                	ld	ra,56(sp)
 392:	7442                	ld	s0,48(sp)
 394:	74a2                	ld	s1,40(sp)
 396:	7902                	ld	s2,32(sp)
 398:	69e2                	ld	s3,24(sp)
 39a:	6121                	addi	sp,sp,64
 39c:	8082                	ret
    x = -xx;
 39e:	40b005bb          	negw	a1,a1
    neg = 1;
 3a2:	4885                	li	a7,1
    x = -xx;
 3a4:	bf8d                	j	316 <printint+0x1a>

00000000000003a6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3a6:	7119                	addi	sp,sp,-128
 3a8:	fc86                	sd	ra,120(sp)
 3aa:	f8a2                	sd	s0,112(sp)
 3ac:	f4a6                	sd	s1,104(sp)
 3ae:	f0ca                	sd	s2,96(sp)
 3b0:	ecce                	sd	s3,88(sp)
 3b2:	e8d2                	sd	s4,80(sp)
 3b4:	e4d6                	sd	s5,72(sp)
 3b6:	e0da                	sd	s6,64(sp)
 3b8:	fc5e                	sd	s7,56(sp)
 3ba:	f862                	sd	s8,48(sp)
 3bc:	f466                	sd	s9,40(sp)
 3be:	f06a                	sd	s10,32(sp)
 3c0:	ec6e                	sd	s11,24(sp)
 3c2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3c4:	0005c903          	lbu	s2,0(a1)
 3c8:	18090f63          	beqz	s2,566 <vprintf+0x1c0>
 3cc:	8aaa                	mv	s5,a0
 3ce:	8b32                	mv	s6,a2
 3d0:	00158493          	addi	s1,a1,1
  state = 0;
 3d4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3d6:	02500a13          	li	s4,37
      if(c == 'd'){
 3da:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 3de:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 3e2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 3e6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 3ea:	00000b97          	auipc	s7,0x0
 3ee:	386b8b93          	addi	s7,s7,902 # 770 <digits>
 3f2:	a839                	j	410 <vprintf+0x6a>
        putc(fd, c);
 3f4:	85ca                	mv	a1,s2
 3f6:	8556                	mv	a0,s5
 3f8:	00000097          	auipc	ra,0x0
 3fc:	ee2080e7          	jalr	-286(ra) # 2da <putc>
 400:	a019                	j	406 <vprintf+0x60>
    } else if(state == '%'){
 402:	01498f63          	beq	s3,s4,420 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 406:	0485                	addi	s1,s1,1
 408:	fff4c903          	lbu	s2,-1(s1)
 40c:	14090d63          	beqz	s2,566 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 410:	0009079b          	sext.w	a5,s2
    if(state == 0){
 414:	fe0997e3          	bnez	s3,402 <vprintf+0x5c>
      if(c == '%'){
 418:	fd479ee3          	bne	a5,s4,3f4 <vprintf+0x4e>
        state = '%';
 41c:	89be                	mv	s3,a5
 41e:	b7e5                	j	406 <vprintf+0x60>
      if(c == 'd'){
 420:	05878063          	beq	a5,s8,460 <vprintf+0xba>
      } else if(c == 'l') {
 424:	05978c63          	beq	a5,s9,47c <vprintf+0xd6>
      } else if(c == 'x') {
 428:	07a78863          	beq	a5,s10,498 <vprintf+0xf2>
      } else if(c == 'p') {
 42c:	09b78463          	beq	a5,s11,4b4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 430:	07300713          	li	a4,115
 434:	0ce78663          	beq	a5,a4,500 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 438:	06300713          	li	a4,99
 43c:	0ee78e63          	beq	a5,a4,538 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 440:	11478863          	beq	a5,s4,550 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 444:	85d2                	mv	a1,s4
 446:	8556                	mv	a0,s5
 448:	00000097          	auipc	ra,0x0
 44c:	e92080e7          	jalr	-366(ra) # 2da <putc>
        putc(fd, c);
 450:	85ca                	mv	a1,s2
 452:	8556                	mv	a0,s5
 454:	00000097          	auipc	ra,0x0
 458:	e86080e7          	jalr	-378(ra) # 2da <putc>
      }
      state = 0;
 45c:	4981                	li	s3,0
 45e:	b765                	j	406 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 460:	008b0913          	addi	s2,s6,8
 464:	4685                	li	a3,1
 466:	4629                	li	a2,10
 468:	000b2583          	lw	a1,0(s6)
 46c:	8556                	mv	a0,s5
 46e:	00000097          	auipc	ra,0x0
 472:	e8e080e7          	jalr	-370(ra) # 2fc <printint>
 476:	8b4a                	mv	s6,s2
      state = 0;
 478:	4981                	li	s3,0
 47a:	b771                	j	406 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 47c:	008b0913          	addi	s2,s6,8
 480:	4681                	li	a3,0
 482:	4629                	li	a2,10
 484:	000b2583          	lw	a1,0(s6)
 488:	8556                	mv	a0,s5
 48a:	00000097          	auipc	ra,0x0
 48e:	e72080e7          	jalr	-398(ra) # 2fc <printint>
 492:	8b4a                	mv	s6,s2
      state = 0;
 494:	4981                	li	s3,0
 496:	bf85                	j	406 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 498:	008b0913          	addi	s2,s6,8
 49c:	4681                	li	a3,0
 49e:	4641                	li	a2,16
 4a0:	000b2583          	lw	a1,0(s6)
 4a4:	8556                	mv	a0,s5
 4a6:	00000097          	auipc	ra,0x0
 4aa:	e56080e7          	jalr	-426(ra) # 2fc <printint>
 4ae:	8b4a                	mv	s6,s2
      state = 0;
 4b0:	4981                	li	s3,0
 4b2:	bf91                	j	406 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4b4:	008b0793          	addi	a5,s6,8
 4b8:	f8f43423          	sd	a5,-120(s0)
 4bc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 4c0:	03000593          	li	a1,48
 4c4:	8556                	mv	a0,s5
 4c6:	00000097          	auipc	ra,0x0
 4ca:	e14080e7          	jalr	-492(ra) # 2da <putc>
  putc(fd, 'x');
 4ce:	85ea                	mv	a1,s10
 4d0:	8556                	mv	a0,s5
 4d2:	00000097          	auipc	ra,0x0
 4d6:	e08080e7          	jalr	-504(ra) # 2da <putc>
 4da:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4dc:	03c9d793          	srli	a5,s3,0x3c
 4e0:	97de                	add	a5,a5,s7
 4e2:	0007c583          	lbu	a1,0(a5)
 4e6:	8556                	mv	a0,s5
 4e8:	00000097          	auipc	ra,0x0
 4ec:	df2080e7          	jalr	-526(ra) # 2da <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 4f0:	0992                	slli	s3,s3,0x4
 4f2:	397d                	addiw	s2,s2,-1
 4f4:	fe0914e3          	bnez	s2,4dc <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 4f8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 4fc:	4981                	li	s3,0
 4fe:	b721                	j	406 <vprintf+0x60>
        s = va_arg(ap, char*);
 500:	008b0993          	addi	s3,s6,8
 504:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 508:	02090163          	beqz	s2,52a <vprintf+0x184>
        while(*s != 0){
 50c:	00094583          	lbu	a1,0(s2)
 510:	c9a1                	beqz	a1,560 <vprintf+0x1ba>
          putc(fd, *s);
 512:	8556                	mv	a0,s5
 514:	00000097          	auipc	ra,0x0
 518:	dc6080e7          	jalr	-570(ra) # 2da <putc>
          s++;
 51c:	0905                	addi	s2,s2,1
        while(*s != 0){
 51e:	00094583          	lbu	a1,0(s2)
 522:	f9e5                	bnez	a1,512 <vprintf+0x16c>
        s = va_arg(ap, char*);
 524:	8b4e                	mv	s6,s3
      state = 0;
 526:	4981                	li	s3,0
 528:	bdf9                	j	406 <vprintf+0x60>
          s = "(null)";
 52a:	00000917          	auipc	s2,0x0
 52e:	23e90913          	addi	s2,s2,574 # 768 <malloc+0xf8>
        while(*s != 0){
 532:	02800593          	li	a1,40
 536:	bff1                	j	512 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 538:	008b0913          	addi	s2,s6,8
 53c:	000b4583          	lbu	a1,0(s6)
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	d98080e7          	jalr	-616(ra) # 2da <putc>
 54a:	8b4a                	mv	s6,s2
      state = 0;
 54c:	4981                	li	s3,0
 54e:	bd65                	j	406 <vprintf+0x60>
        putc(fd, c);
 550:	85d2                	mv	a1,s4
 552:	8556                	mv	a0,s5
 554:	00000097          	auipc	ra,0x0
 558:	d86080e7          	jalr	-634(ra) # 2da <putc>
      state = 0;
 55c:	4981                	li	s3,0
 55e:	b565                	j	406 <vprintf+0x60>
        s = va_arg(ap, char*);
 560:	8b4e                	mv	s6,s3
      state = 0;
 562:	4981                	li	s3,0
 564:	b54d                	j	406 <vprintf+0x60>
    }
  }
}
 566:	70e6                	ld	ra,120(sp)
 568:	7446                	ld	s0,112(sp)
 56a:	74a6                	ld	s1,104(sp)
 56c:	7906                	ld	s2,96(sp)
 56e:	69e6                	ld	s3,88(sp)
 570:	6a46                	ld	s4,80(sp)
 572:	6aa6                	ld	s5,72(sp)
 574:	6b06                	ld	s6,64(sp)
 576:	7be2                	ld	s7,56(sp)
 578:	7c42                	ld	s8,48(sp)
 57a:	7ca2                	ld	s9,40(sp)
 57c:	7d02                	ld	s10,32(sp)
 57e:	6de2                	ld	s11,24(sp)
 580:	6109                	addi	sp,sp,128
 582:	8082                	ret

0000000000000584 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 584:	715d                	addi	sp,sp,-80
 586:	ec06                	sd	ra,24(sp)
 588:	e822                	sd	s0,16(sp)
 58a:	1000                	addi	s0,sp,32
 58c:	e010                	sd	a2,0(s0)
 58e:	e414                	sd	a3,8(s0)
 590:	e818                	sd	a4,16(s0)
 592:	ec1c                	sd	a5,24(s0)
 594:	03043023          	sd	a6,32(s0)
 598:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 59c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5a0:	8622                	mv	a2,s0
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e04080e7          	jalr	-508(ra) # 3a6 <vprintf>
}
 5aa:	60e2                	ld	ra,24(sp)
 5ac:	6442                	ld	s0,16(sp)
 5ae:	6161                	addi	sp,sp,80
 5b0:	8082                	ret

00000000000005b2 <printf>:

void
printf(const char *fmt, ...)
{
 5b2:	711d                	addi	sp,sp,-96
 5b4:	ec06                	sd	ra,24(sp)
 5b6:	e822                	sd	s0,16(sp)
 5b8:	1000                	addi	s0,sp,32
 5ba:	e40c                	sd	a1,8(s0)
 5bc:	e810                	sd	a2,16(s0)
 5be:	ec14                	sd	a3,24(s0)
 5c0:	f018                	sd	a4,32(s0)
 5c2:	f41c                	sd	a5,40(s0)
 5c4:	03043823          	sd	a6,48(s0)
 5c8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 5cc:	00840613          	addi	a2,s0,8
 5d0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 5d4:	85aa                	mv	a1,a0
 5d6:	4505                	li	a0,1
 5d8:	00000097          	auipc	ra,0x0
 5dc:	dce080e7          	jalr	-562(ra) # 3a6 <vprintf>
}
 5e0:	60e2                	ld	ra,24(sp)
 5e2:	6442                	ld	s0,16(sp)
 5e4:	6125                	addi	sp,sp,96
 5e6:	8082                	ret

00000000000005e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e8:	1141                	addi	sp,sp,-16
 5ea:	e422                	sd	s0,8(sp)
 5ec:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ee:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f2:	00000797          	auipc	a5,0x0
 5f6:	1967b783          	ld	a5,406(a5) # 788 <freep>
 5fa:	a805                	j	62a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 5fc:	4618                	lw	a4,8(a2)
 5fe:	9db9                	addw	a1,a1,a4
 600:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 604:	6398                	ld	a4,0(a5)
 606:	6318                	ld	a4,0(a4)
 608:	fee53823          	sd	a4,-16(a0)
 60c:	a091                	j	650 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 60e:	ff852703          	lw	a4,-8(a0)
 612:	9e39                	addw	a2,a2,a4
 614:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 616:	ff053703          	ld	a4,-16(a0)
 61a:	e398                	sd	a4,0(a5)
 61c:	a099                	j	662 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61e:	6398                	ld	a4,0(a5)
 620:	00e7e463          	bltu	a5,a4,628 <free+0x40>
 624:	00e6ea63          	bltu	a3,a4,638 <free+0x50>
{
 628:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62a:	fed7fae3          	bgeu	a5,a3,61e <free+0x36>
 62e:	6398                	ld	a4,0(a5)
 630:	00e6e463          	bltu	a3,a4,638 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 634:	fee7eae3          	bltu	a5,a4,628 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 638:	ff852583          	lw	a1,-8(a0)
 63c:	6390                	ld	a2,0(a5)
 63e:	02059713          	slli	a4,a1,0x20
 642:	9301                	srli	a4,a4,0x20
 644:	0712                	slli	a4,a4,0x4
 646:	9736                	add	a4,a4,a3
 648:	fae60ae3          	beq	a2,a4,5fc <free+0x14>
    bp->s.ptr = p->s.ptr;
 64c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 650:	4790                	lw	a2,8(a5)
 652:	02061713          	slli	a4,a2,0x20
 656:	9301                	srli	a4,a4,0x20
 658:	0712                	slli	a4,a4,0x4
 65a:	973e                	add	a4,a4,a5
 65c:	fae689e3          	beq	a3,a4,60e <free+0x26>
  } else
    p->s.ptr = bp;
 660:	e394                	sd	a3,0(a5)
  freep = p;
 662:	00000717          	auipc	a4,0x0
 666:	12f73323          	sd	a5,294(a4) # 788 <freep>
}
 66a:	6422                	ld	s0,8(sp)
 66c:	0141                	addi	sp,sp,16
 66e:	8082                	ret

0000000000000670 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 670:	7139                	addi	sp,sp,-64
 672:	fc06                	sd	ra,56(sp)
 674:	f822                	sd	s0,48(sp)
 676:	f426                	sd	s1,40(sp)
 678:	f04a                	sd	s2,32(sp)
 67a:	ec4e                	sd	s3,24(sp)
 67c:	e852                	sd	s4,16(sp)
 67e:	e456                	sd	s5,8(sp)
 680:	e05a                	sd	s6,0(sp)
 682:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 684:	02051493          	slli	s1,a0,0x20
 688:	9081                	srli	s1,s1,0x20
 68a:	04bd                	addi	s1,s1,15
 68c:	8091                	srli	s1,s1,0x4
 68e:	0014899b          	addiw	s3,s1,1
 692:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 694:	00000517          	auipc	a0,0x0
 698:	0f453503          	ld	a0,244(a0) # 788 <freep>
 69c:	c515                	beqz	a0,6c8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 69e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6a0:	4798                	lw	a4,8(a5)
 6a2:	02977f63          	bgeu	a4,s1,6e0 <malloc+0x70>
 6a6:	8a4e                	mv	s4,s3
 6a8:	0009871b          	sext.w	a4,s3
 6ac:	6685                	lui	a3,0x1
 6ae:	00d77363          	bgeu	a4,a3,6b4 <malloc+0x44>
 6b2:	6a05                	lui	s4,0x1
 6b4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6b8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6bc:	00000917          	auipc	s2,0x0
 6c0:	0cc90913          	addi	s2,s2,204 # 788 <freep>
  if(p == (char*)-1)
 6c4:	5afd                	li	s5,-1
 6c6:	a88d                	j	738 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 6c8:	00000797          	auipc	a5,0x0
 6cc:	0c878793          	addi	a5,a5,200 # 790 <base>
 6d0:	00000717          	auipc	a4,0x0
 6d4:	0af73c23          	sd	a5,184(a4) # 788 <freep>
 6d8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 6da:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 6de:	b7e1                	j	6a6 <malloc+0x36>
      if(p->s.size == nunits)
 6e0:	02e48b63          	beq	s1,a4,716 <malloc+0xa6>
        p->s.size -= nunits;
 6e4:	4137073b          	subw	a4,a4,s3
 6e8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 6ea:	1702                	slli	a4,a4,0x20
 6ec:	9301                	srli	a4,a4,0x20
 6ee:	0712                	slli	a4,a4,0x4
 6f0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 6f2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 6f6:	00000717          	auipc	a4,0x0
 6fa:	08a73923          	sd	a0,146(a4) # 788 <freep>
      return (void*)(p + 1);
 6fe:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 702:	70e2                	ld	ra,56(sp)
 704:	7442                	ld	s0,48(sp)
 706:	74a2                	ld	s1,40(sp)
 708:	7902                	ld	s2,32(sp)
 70a:	69e2                	ld	s3,24(sp)
 70c:	6a42                	ld	s4,16(sp)
 70e:	6aa2                	ld	s5,8(sp)
 710:	6b02                	ld	s6,0(sp)
 712:	6121                	addi	sp,sp,64
 714:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 716:	6398                	ld	a4,0(a5)
 718:	e118                	sd	a4,0(a0)
 71a:	bff1                	j	6f6 <malloc+0x86>
  hp->s.size = nu;
 71c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 720:	0541                	addi	a0,a0,16
 722:	00000097          	auipc	ra,0x0
 726:	ec6080e7          	jalr	-314(ra) # 5e8 <free>
  return freep;
 72a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 72e:	d971                	beqz	a0,702 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 730:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 732:	4798                	lw	a4,8(a5)
 734:	fa9776e3          	bgeu	a4,s1,6e0 <malloc+0x70>
    if(p == freep)
 738:	00093703          	ld	a4,0(s2)
 73c:	853e                	mv	a0,a5
 73e:	fef719e3          	bne	a4,a5,730 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 742:	8552                	mv	a0,s4
 744:	00000097          	auipc	ra,0x0
 748:	b66080e7          	jalr	-1178(ra) # 2aa <sbrk>
  if(p == (char*)-1)
 74c:	fd5518e3          	bne	a0,s5,71c <malloc+0xac>
        return 0;
 750:	4501                	li	a0,0
 752:	bf45                	j	702 <malloc+0x92>
