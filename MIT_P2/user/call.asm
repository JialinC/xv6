
user/_call:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <g>:
#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int g(int x) {
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  return x+3;
}
   6:	250d                	addiw	a0,a0,3
   8:	6422                	ld	s0,8(sp)
   a:	0141                	addi	sp,sp,16
   c:	8082                	ret

000000000000000e <f>:

int f(int x) {
   e:	1141                	addi	sp,sp,-16
  10:	e422                	sd	s0,8(sp)
  12:	0800                	addi	s0,sp,16
  return g(x);
}
  14:	250d                	addiw	a0,a0,3
  16:	6422                	ld	s0,8(sp)
  18:	0141                	addi	sp,sp,16
  1a:	8082                	ret

000000000000001c <main>:

void main(void) {
  1c:	1141                	addi	sp,sp,-16
  1e:	e406                	sd	ra,8(sp)
  20:	e022                	sd	s0,0(sp)
  22:	0800                	addi	s0,sp,16
  printf("%d %d\n", f(8)+1, 13);
  24:	4635                	li	a2,13
  26:	45b1                	li	a1,12
  28:	00000517          	auipc	a0,0x0
  2c:	75050513          	addi	a0,a0,1872 # 778 <malloc+0xea>
  30:	00000097          	auipc	ra,0x0
  34:	5a0080e7          	jalr	1440(ra) # 5d0 <printf>
  exit(0);
  38:	4501                	li	a0,0
  3a:	00000097          	auipc	ra,0x0
  3e:	1fe080e7          	jalr	510(ra) # 238 <exit>

0000000000000042 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  42:	1141                	addi	sp,sp,-16
  44:	e422                	sd	s0,8(sp)
  46:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  48:	87aa                	mv	a5,a0
  4a:	0585                	addi	a1,a1,1
  4c:	0785                	addi	a5,a5,1
  4e:	fff5c703          	lbu	a4,-1(a1)
  52:	fee78fa3          	sb	a4,-1(a5)
  56:	fb75                	bnez	a4,4a <strcpy+0x8>
    ;
  return os;
}
  58:	6422                	ld	s0,8(sp)
  5a:	0141                	addi	sp,sp,16
  5c:	8082                	ret

000000000000005e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e422                	sd	s0,8(sp)
  62:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	cb91                	beqz	a5,7c <strcmp+0x1e>
  6a:	0005c703          	lbu	a4,0(a1)
  6e:	00f71763          	bne	a4,a5,7c <strcmp+0x1e>
    p++, q++;
  72:	0505                	addi	a0,a0,1
  74:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  76:	00054783          	lbu	a5,0(a0)
  7a:	fbe5                	bnez	a5,6a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7c:	0005c503          	lbu	a0,0(a1)
}
  80:	40a7853b          	subw	a0,a5,a0
  84:	6422                	ld	s0,8(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret

000000000000008a <strlen>:

uint
strlen(const char *s)
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e422                	sd	s0,8(sp)
  8e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  90:	00054783          	lbu	a5,0(a0)
  94:	cf91                	beqz	a5,b0 <strlen+0x26>
  96:	0505                	addi	a0,a0,1
  98:	87aa                	mv	a5,a0
  9a:	4685                	li	a3,1
  9c:	9e89                	subw	a3,a3,a0
  9e:	00f6853b          	addw	a0,a3,a5
  a2:	0785                	addi	a5,a5,1
  a4:	fff7c703          	lbu	a4,-1(a5)
  a8:	fb7d                	bnez	a4,9e <strlen+0x14>
    ;
  return n;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret
  for(n = 0; s[n]; n++)
  b0:	4501                	li	a0,0
  b2:	bfe5                	j	aa <strlen+0x20>

00000000000000b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ba:	ce09                	beqz	a2,d4 <memset+0x20>
  bc:	87aa                	mv	a5,a0
  be:	fff6071b          	addiw	a4,a2,-1
  c2:	1702                	slli	a4,a4,0x20
  c4:	9301                	srli	a4,a4,0x20
  c6:	0705                	addi	a4,a4,1
  c8:	972a                	add	a4,a4,a0
    cdst[i] = c;
  ca:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ce:	0785                	addi	a5,a5,1
  d0:	fee79de3          	bne	a5,a4,ca <memset+0x16>
  }
  return dst;
}
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret

00000000000000da <strchr>:

char*
strchr(const char *s, char c)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	addi	s0,sp,16
  for(; *s; s++)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cb99                	beqz	a5,fa <strchr+0x20>
    if(*s == c)
  e6:	00f58763          	beq	a1,a5,f4 <strchr+0x1a>
  for(; *s; s++)
  ea:	0505                	addi	a0,a0,1
  ec:	00054783          	lbu	a5,0(a0)
  f0:	fbfd                	bnez	a5,e6 <strchr+0xc>
      return (char*)s;
  return 0;
  f2:	4501                	li	a0,0
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret
  return 0;
  fa:	4501                	li	a0,0
  fc:	bfe5                	j	f4 <strchr+0x1a>

00000000000000fe <gets>:

char*
gets(char *buf, int max)
{
  fe:	711d                	addi	sp,sp,-96
 100:	ec86                	sd	ra,88(sp)
 102:	e8a2                	sd	s0,80(sp)
 104:	e4a6                	sd	s1,72(sp)
 106:	e0ca                	sd	s2,64(sp)
 108:	fc4e                	sd	s3,56(sp)
 10a:	f852                	sd	s4,48(sp)
 10c:	f456                	sd	s5,40(sp)
 10e:	f05a                	sd	s6,32(sp)
 110:	ec5e                	sd	s7,24(sp)
 112:	1080                	addi	s0,sp,96
 114:	8baa                	mv	s7,a0
 116:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 118:	892a                	mv	s2,a0
 11a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 11c:	4aa9                	li	s5,10
 11e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 120:	89a6                	mv	s3,s1
 122:	2485                	addiw	s1,s1,1
 124:	0344d863          	bge	s1,s4,154 <gets+0x56>
    cc = read(0, &c, 1);
 128:	4605                	li	a2,1
 12a:	faf40593          	addi	a1,s0,-81
 12e:	4501                	li	a0,0
 130:	00000097          	auipc	ra,0x0
 134:	120080e7          	jalr	288(ra) # 250 <read>
    if(cc < 1)
 138:	00a05e63          	blez	a0,154 <gets+0x56>
    buf[i++] = c;
 13c:	faf44783          	lbu	a5,-81(s0)
 140:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 144:	01578763          	beq	a5,s5,152 <gets+0x54>
 148:	0905                	addi	s2,s2,1
 14a:	fd679be3          	bne	a5,s6,120 <gets+0x22>
  for(i=0; i+1 < max; ){
 14e:	89a6                	mv	s3,s1
 150:	a011                	j	154 <gets+0x56>
 152:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 154:	99de                	add	s3,s3,s7
 156:	00098023          	sb	zero,0(s3)
  return buf;
}
 15a:	855e                	mv	a0,s7
 15c:	60e6                	ld	ra,88(sp)
 15e:	6446                	ld	s0,80(sp)
 160:	64a6                	ld	s1,72(sp)
 162:	6906                	ld	s2,64(sp)
 164:	79e2                	ld	s3,56(sp)
 166:	7a42                	ld	s4,48(sp)
 168:	7aa2                	ld	s5,40(sp)
 16a:	7b02                	ld	s6,32(sp)
 16c:	6be2                	ld	s7,24(sp)
 16e:	6125                	addi	sp,sp,96
 170:	8082                	ret

0000000000000172 <stat>:

int
stat(const char *n, struct stat *st)
{
 172:	1101                	addi	sp,sp,-32
 174:	ec06                	sd	ra,24(sp)
 176:	e822                	sd	s0,16(sp)
 178:	e426                	sd	s1,8(sp)
 17a:	e04a                	sd	s2,0(sp)
 17c:	1000                	addi	s0,sp,32
 17e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 180:	4581                	li	a1,0
 182:	00000097          	auipc	ra,0x0
 186:	0f6080e7          	jalr	246(ra) # 278 <open>
  if(fd < 0)
 18a:	02054563          	bltz	a0,1b4 <stat+0x42>
 18e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 190:	85ca                	mv	a1,s2
 192:	00000097          	auipc	ra,0x0
 196:	0fe080e7          	jalr	254(ra) # 290 <fstat>
 19a:	892a                	mv	s2,a0
  close(fd);
 19c:	8526                	mv	a0,s1
 19e:	00000097          	auipc	ra,0x0
 1a2:	0c2080e7          	jalr	194(ra) # 260 <close>
  return r;
}
 1a6:	854a                	mv	a0,s2
 1a8:	60e2                	ld	ra,24(sp)
 1aa:	6442                	ld	s0,16(sp)
 1ac:	64a2                	ld	s1,8(sp)
 1ae:	6902                	ld	s2,0(sp)
 1b0:	6105                	addi	sp,sp,32
 1b2:	8082                	ret
    return -1;
 1b4:	597d                	li	s2,-1
 1b6:	bfc5                	j	1a6 <stat+0x34>

00000000000001b8 <atoi>:

int
atoi(const char *s)
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e422                	sd	s0,8(sp)
 1bc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1be:	00054603          	lbu	a2,0(a0)
 1c2:	fd06079b          	addiw	a5,a2,-48
 1c6:	0ff7f793          	andi	a5,a5,255
 1ca:	4725                	li	a4,9
 1cc:	02f76963          	bltu	a4,a5,1fe <atoi+0x46>
 1d0:	86aa                	mv	a3,a0
  n = 0;
 1d2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1d4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1d6:	0685                	addi	a3,a3,1
 1d8:	0025179b          	slliw	a5,a0,0x2
 1dc:	9fa9                	addw	a5,a5,a0
 1de:	0017979b          	slliw	a5,a5,0x1
 1e2:	9fb1                	addw	a5,a5,a2
 1e4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e8:	0006c603          	lbu	a2,0(a3)
 1ec:	fd06071b          	addiw	a4,a2,-48
 1f0:	0ff77713          	andi	a4,a4,255
 1f4:	fee5f1e3          	bgeu	a1,a4,1d6 <atoi+0x1e>
  return n;
}
 1f8:	6422                	ld	s0,8(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret
  n = 0;
 1fe:	4501                	li	a0,0
 200:	bfe5                	j	1f8 <atoi+0x40>

0000000000000202 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 208:	02c05163          	blez	a2,22a <memmove+0x28>
 20c:	fff6071b          	addiw	a4,a2,-1
 210:	1702                	slli	a4,a4,0x20
 212:	9301                	srli	a4,a4,0x20
 214:	0705                	addi	a4,a4,1
 216:	972a                	add	a4,a4,a0
  dst = vdst;
 218:	87aa                	mv	a5,a0
    *dst++ = *src++;
 21a:	0585                	addi	a1,a1,1
 21c:	0785                	addi	a5,a5,1
 21e:	fff5c683          	lbu	a3,-1(a1)
 222:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 226:	fee79ae3          	bne	a5,a4,21a <memmove+0x18>
  return vdst;
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret

0000000000000230 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 230:	4885                	li	a7,1
 ecall
 232:	00000073          	ecall
 ret
 236:	8082                	ret

0000000000000238 <exit>:
.global exit
exit:
 li a7, SYS_exit
 238:	4889                	li	a7,2
 ecall
 23a:	00000073          	ecall
 ret
 23e:	8082                	ret

0000000000000240 <wait>:
.global wait
wait:
 li a7, SYS_wait
 240:	488d                	li	a7,3
 ecall
 242:	00000073          	ecall
 ret
 246:	8082                	ret

0000000000000248 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 248:	4891                	li	a7,4
 ecall
 24a:	00000073          	ecall
 ret
 24e:	8082                	ret

0000000000000250 <read>:
.global read
read:
 li a7, SYS_read
 250:	4895                	li	a7,5
 ecall
 252:	00000073          	ecall
 ret
 256:	8082                	ret

0000000000000258 <write>:
.global write
write:
 li a7, SYS_write
 258:	48c1                	li	a7,16
 ecall
 25a:	00000073          	ecall
 ret
 25e:	8082                	ret

0000000000000260 <close>:
.global close
close:
 li a7, SYS_close
 260:	48d5                	li	a7,21
 ecall
 262:	00000073          	ecall
 ret
 266:	8082                	ret

0000000000000268 <kill>:
.global kill
kill:
 li a7, SYS_kill
 268:	4899                	li	a7,6
 ecall
 26a:	00000073          	ecall
 ret
 26e:	8082                	ret

0000000000000270 <exec>:
.global exec
exec:
 li a7, SYS_exec
 270:	489d                	li	a7,7
 ecall
 272:	00000073          	ecall
 ret
 276:	8082                	ret

0000000000000278 <open>:
.global open
open:
 li a7, SYS_open
 278:	48bd                	li	a7,15
 ecall
 27a:	00000073          	ecall
 ret
 27e:	8082                	ret

0000000000000280 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 280:	48c5                	li	a7,17
 ecall
 282:	00000073          	ecall
 ret
 286:	8082                	ret

0000000000000288 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 288:	48c9                	li	a7,18
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 290:	48a1                	li	a7,8
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <link>:
.global link
link:
 li a7, SYS_link
 298:	48cd                	li	a7,19
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2a0:	48d1                	li	a7,20
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2a8:	48a5                	li	a7,9
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2b0:	48a9                	li	a7,10
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2b8:	48ad                	li	a7,11
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2c0:	48b1                	li	a7,12
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2c8:	48b5                	li	a7,13
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 2d0:	48b9                	li	a7,14
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 2d8:	48d9                	li	a7,22
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <crash>:
.global crash
crash:
 li a7, SYS_crash
 2e0:	48dd                	li	a7,23
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <mount>:
.global mount
mount:
 li a7, SYS_mount
 2e8:	48e1                	li	a7,24
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <umount>:
.global umount
umount:
 li a7, SYS_umount
 2f0:	48e5                	li	a7,25
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 2f8:	1101                	addi	sp,sp,-32
 2fa:	ec06                	sd	ra,24(sp)
 2fc:	e822                	sd	s0,16(sp)
 2fe:	1000                	addi	s0,sp,32
 300:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 304:	4605                	li	a2,1
 306:	fef40593          	addi	a1,s0,-17
 30a:	00000097          	auipc	ra,0x0
 30e:	f4e080e7          	jalr	-178(ra) # 258 <write>
}
 312:	60e2                	ld	ra,24(sp)
 314:	6442                	ld	s0,16(sp)
 316:	6105                	addi	sp,sp,32
 318:	8082                	ret

000000000000031a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 31a:	7139                	addi	sp,sp,-64
 31c:	fc06                	sd	ra,56(sp)
 31e:	f822                	sd	s0,48(sp)
 320:	f426                	sd	s1,40(sp)
 322:	f04a                	sd	s2,32(sp)
 324:	ec4e                	sd	s3,24(sp)
 326:	0080                	addi	s0,sp,64
 328:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 32a:	c299                	beqz	a3,330 <printint+0x16>
 32c:	0805c863          	bltz	a1,3bc <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 330:	2581                	sext.w	a1,a1
  neg = 0;
 332:	4881                	li	a7,0
 334:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 338:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 33a:	2601                	sext.w	a2,a2
 33c:	00000517          	auipc	a0,0x0
 340:	44c50513          	addi	a0,a0,1100 # 788 <digits>
 344:	883a                	mv	a6,a4
 346:	2705                	addiw	a4,a4,1
 348:	02c5f7bb          	remuw	a5,a1,a2
 34c:	1782                	slli	a5,a5,0x20
 34e:	9381                	srli	a5,a5,0x20
 350:	97aa                	add	a5,a5,a0
 352:	0007c783          	lbu	a5,0(a5)
 356:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 35a:	0005879b          	sext.w	a5,a1
 35e:	02c5d5bb          	divuw	a1,a1,a2
 362:	0685                	addi	a3,a3,1
 364:	fec7f0e3          	bgeu	a5,a2,344 <printint+0x2a>
  if(neg)
 368:	00088b63          	beqz	a7,37e <printint+0x64>
    buf[i++] = '-';
 36c:	fd040793          	addi	a5,s0,-48
 370:	973e                	add	a4,a4,a5
 372:	02d00793          	li	a5,45
 376:	fef70823          	sb	a5,-16(a4)
 37a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 37e:	02e05863          	blez	a4,3ae <printint+0x94>
 382:	fc040793          	addi	a5,s0,-64
 386:	00e78933          	add	s2,a5,a4
 38a:	fff78993          	addi	s3,a5,-1
 38e:	99ba                	add	s3,s3,a4
 390:	377d                	addiw	a4,a4,-1
 392:	1702                	slli	a4,a4,0x20
 394:	9301                	srli	a4,a4,0x20
 396:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 39a:	fff94583          	lbu	a1,-1(s2)
 39e:	8526                	mv	a0,s1
 3a0:	00000097          	auipc	ra,0x0
 3a4:	f58080e7          	jalr	-168(ra) # 2f8 <putc>
  while(--i >= 0)
 3a8:	197d                	addi	s2,s2,-1
 3aa:	ff3918e3          	bne	s2,s3,39a <printint+0x80>
}
 3ae:	70e2                	ld	ra,56(sp)
 3b0:	7442                	ld	s0,48(sp)
 3b2:	74a2                	ld	s1,40(sp)
 3b4:	7902                	ld	s2,32(sp)
 3b6:	69e2                	ld	s3,24(sp)
 3b8:	6121                	addi	sp,sp,64
 3ba:	8082                	ret
    x = -xx;
 3bc:	40b005bb          	negw	a1,a1
    neg = 1;
 3c0:	4885                	li	a7,1
    x = -xx;
 3c2:	bf8d                	j	334 <printint+0x1a>

00000000000003c4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3c4:	7119                	addi	sp,sp,-128
 3c6:	fc86                	sd	ra,120(sp)
 3c8:	f8a2                	sd	s0,112(sp)
 3ca:	f4a6                	sd	s1,104(sp)
 3cc:	f0ca                	sd	s2,96(sp)
 3ce:	ecce                	sd	s3,88(sp)
 3d0:	e8d2                	sd	s4,80(sp)
 3d2:	e4d6                	sd	s5,72(sp)
 3d4:	e0da                	sd	s6,64(sp)
 3d6:	fc5e                	sd	s7,56(sp)
 3d8:	f862                	sd	s8,48(sp)
 3da:	f466                	sd	s9,40(sp)
 3dc:	f06a                	sd	s10,32(sp)
 3de:	ec6e                	sd	s11,24(sp)
 3e0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3e2:	0005c903          	lbu	s2,0(a1)
 3e6:	18090f63          	beqz	s2,584 <vprintf+0x1c0>
 3ea:	8aaa                	mv	s5,a0
 3ec:	8b32                	mv	s6,a2
 3ee:	00158493          	addi	s1,a1,1
  state = 0;
 3f2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3f4:	02500a13          	li	s4,37
      if(c == 'd'){
 3f8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 3fc:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 400:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 404:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 408:	00000b97          	auipc	s7,0x0
 40c:	380b8b93          	addi	s7,s7,896 # 788 <digits>
 410:	a839                	j	42e <vprintf+0x6a>
        putc(fd, c);
 412:	85ca                	mv	a1,s2
 414:	8556                	mv	a0,s5
 416:	00000097          	auipc	ra,0x0
 41a:	ee2080e7          	jalr	-286(ra) # 2f8 <putc>
 41e:	a019                	j	424 <vprintf+0x60>
    } else if(state == '%'){
 420:	01498f63          	beq	s3,s4,43e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 424:	0485                	addi	s1,s1,1
 426:	fff4c903          	lbu	s2,-1(s1)
 42a:	14090d63          	beqz	s2,584 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 42e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 432:	fe0997e3          	bnez	s3,420 <vprintf+0x5c>
      if(c == '%'){
 436:	fd479ee3          	bne	a5,s4,412 <vprintf+0x4e>
        state = '%';
 43a:	89be                	mv	s3,a5
 43c:	b7e5                	j	424 <vprintf+0x60>
      if(c == 'd'){
 43e:	05878063          	beq	a5,s8,47e <vprintf+0xba>
      } else if(c == 'l') {
 442:	05978c63          	beq	a5,s9,49a <vprintf+0xd6>
      } else if(c == 'x') {
 446:	07a78863          	beq	a5,s10,4b6 <vprintf+0xf2>
      } else if(c == 'p') {
 44a:	09b78463          	beq	a5,s11,4d2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 44e:	07300713          	li	a4,115
 452:	0ce78663          	beq	a5,a4,51e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 456:	06300713          	li	a4,99
 45a:	0ee78e63          	beq	a5,a4,556 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 45e:	11478863          	beq	a5,s4,56e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 462:	85d2                	mv	a1,s4
 464:	8556                	mv	a0,s5
 466:	00000097          	auipc	ra,0x0
 46a:	e92080e7          	jalr	-366(ra) # 2f8 <putc>
        putc(fd, c);
 46e:	85ca                	mv	a1,s2
 470:	8556                	mv	a0,s5
 472:	00000097          	auipc	ra,0x0
 476:	e86080e7          	jalr	-378(ra) # 2f8 <putc>
      }
      state = 0;
 47a:	4981                	li	s3,0
 47c:	b765                	j	424 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 47e:	008b0913          	addi	s2,s6,8
 482:	4685                	li	a3,1
 484:	4629                	li	a2,10
 486:	000b2583          	lw	a1,0(s6)
 48a:	8556                	mv	a0,s5
 48c:	00000097          	auipc	ra,0x0
 490:	e8e080e7          	jalr	-370(ra) # 31a <printint>
 494:	8b4a                	mv	s6,s2
      state = 0;
 496:	4981                	li	s3,0
 498:	b771                	j	424 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 49a:	008b0913          	addi	s2,s6,8
 49e:	4681                	li	a3,0
 4a0:	4629                	li	a2,10
 4a2:	000b2583          	lw	a1,0(s6)
 4a6:	8556                	mv	a0,s5
 4a8:	00000097          	auipc	ra,0x0
 4ac:	e72080e7          	jalr	-398(ra) # 31a <printint>
 4b0:	8b4a                	mv	s6,s2
      state = 0;
 4b2:	4981                	li	s3,0
 4b4:	bf85                	j	424 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4b6:	008b0913          	addi	s2,s6,8
 4ba:	4681                	li	a3,0
 4bc:	4641                	li	a2,16
 4be:	000b2583          	lw	a1,0(s6)
 4c2:	8556                	mv	a0,s5
 4c4:	00000097          	auipc	ra,0x0
 4c8:	e56080e7          	jalr	-426(ra) # 31a <printint>
 4cc:	8b4a                	mv	s6,s2
      state = 0;
 4ce:	4981                	li	s3,0
 4d0:	bf91                	j	424 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4d2:	008b0793          	addi	a5,s6,8
 4d6:	f8f43423          	sd	a5,-120(s0)
 4da:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 4de:	03000593          	li	a1,48
 4e2:	8556                	mv	a0,s5
 4e4:	00000097          	auipc	ra,0x0
 4e8:	e14080e7          	jalr	-492(ra) # 2f8 <putc>
  putc(fd, 'x');
 4ec:	85ea                	mv	a1,s10
 4ee:	8556                	mv	a0,s5
 4f0:	00000097          	auipc	ra,0x0
 4f4:	e08080e7          	jalr	-504(ra) # 2f8 <putc>
 4f8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4fa:	03c9d793          	srli	a5,s3,0x3c
 4fe:	97de                	add	a5,a5,s7
 500:	0007c583          	lbu	a1,0(a5)
 504:	8556                	mv	a0,s5
 506:	00000097          	auipc	ra,0x0
 50a:	df2080e7          	jalr	-526(ra) # 2f8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 50e:	0992                	slli	s3,s3,0x4
 510:	397d                	addiw	s2,s2,-1
 512:	fe0914e3          	bnez	s2,4fa <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 516:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 51a:	4981                	li	s3,0
 51c:	b721                	j	424 <vprintf+0x60>
        s = va_arg(ap, char*);
 51e:	008b0993          	addi	s3,s6,8
 522:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 526:	02090163          	beqz	s2,548 <vprintf+0x184>
        while(*s != 0){
 52a:	00094583          	lbu	a1,0(s2)
 52e:	c9a1                	beqz	a1,57e <vprintf+0x1ba>
          putc(fd, *s);
 530:	8556                	mv	a0,s5
 532:	00000097          	auipc	ra,0x0
 536:	dc6080e7          	jalr	-570(ra) # 2f8 <putc>
          s++;
 53a:	0905                	addi	s2,s2,1
        while(*s != 0){
 53c:	00094583          	lbu	a1,0(s2)
 540:	f9e5                	bnez	a1,530 <vprintf+0x16c>
        s = va_arg(ap, char*);
 542:	8b4e                	mv	s6,s3
      state = 0;
 544:	4981                	li	s3,0
 546:	bdf9                	j	424 <vprintf+0x60>
          s = "(null)";
 548:	00000917          	auipc	s2,0x0
 54c:	23890913          	addi	s2,s2,568 # 780 <malloc+0xf2>
        while(*s != 0){
 550:	02800593          	li	a1,40
 554:	bff1                	j	530 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 556:	008b0913          	addi	s2,s6,8
 55a:	000b4583          	lbu	a1,0(s6)
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	d98080e7          	jalr	-616(ra) # 2f8 <putc>
 568:	8b4a                	mv	s6,s2
      state = 0;
 56a:	4981                	li	s3,0
 56c:	bd65                	j	424 <vprintf+0x60>
        putc(fd, c);
 56e:	85d2                	mv	a1,s4
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	d86080e7          	jalr	-634(ra) # 2f8 <putc>
      state = 0;
 57a:	4981                	li	s3,0
 57c:	b565                	j	424 <vprintf+0x60>
        s = va_arg(ap, char*);
 57e:	8b4e                	mv	s6,s3
      state = 0;
 580:	4981                	li	s3,0
 582:	b54d                	j	424 <vprintf+0x60>
    }
  }
}
 584:	70e6                	ld	ra,120(sp)
 586:	7446                	ld	s0,112(sp)
 588:	74a6                	ld	s1,104(sp)
 58a:	7906                	ld	s2,96(sp)
 58c:	69e6                	ld	s3,88(sp)
 58e:	6a46                	ld	s4,80(sp)
 590:	6aa6                	ld	s5,72(sp)
 592:	6b06                	ld	s6,64(sp)
 594:	7be2                	ld	s7,56(sp)
 596:	7c42                	ld	s8,48(sp)
 598:	7ca2                	ld	s9,40(sp)
 59a:	7d02                	ld	s10,32(sp)
 59c:	6de2                	ld	s11,24(sp)
 59e:	6109                	addi	sp,sp,128
 5a0:	8082                	ret

00000000000005a2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5a2:	715d                	addi	sp,sp,-80
 5a4:	ec06                	sd	ra,24(sp)
 5a6:	e822                	sd	s0,16(sp)
 5a8:	1000                	addi	s0,sp,32
 5aa:	e010                	sd	a2,0(s0)
 5ac:	e414                	sd	a3,8(s0)
 5ae:	e818                	sd	a4,16(s0)
 5b0:	ec1c                	sd	a5,24(s0)
 5b2:	03043023          	sd	a6,32(s0)
 5b6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5ba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5be:	8622                	mv	a2,s0
 5c0:	00000097          	auipc	ra,0x0
 5c4:	e04080e7          	jalr	-508(ra) # 3c4 <vprintf>
}
 5c8:	60e2                	ld	ra,24(sp)
 5ca:	6442                	ld	s0,16(sp)
 5cc:	6161                	addi	sp,sp,80
 5ce:	8082                	ret

00000000000005d0 <printf>:

void
printf(const char *fmt, ...)
{
 5d0:	711d                	addi	sp,sp,-96
 5d2:	ec06                	sd	ra,24(sp)
 5d4:	e822                	sd	s0,16(sp)
 5d6:	1000                	addi	s0,sp,32
 5d8:	e40c                	sd	a1,8(s0)
 5da:	e810                	sd	a2,16(s0)
 5dc:	ec14                	sd	a3,24(s0)
 5de:	f018                	sd	a4,32(s0)
 5e0:	f41c                	sd	a5,40(s0)
 5e2:	03043823          	sd	a6,48(s0)
 5e6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 5ea:	00840613          	addi	a2,s0,8
 5ee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 5f2:	85aa                	mv	a1,a0
 5f4:	4505                	li	a0,1
 5f6:	00000097          	auipc	ra,0x0
 5fa:	dce080e7          	jalr	-562(ra) # 3c4 <vprintf>
}
 5fe:	60e2                	ld	ra,24(sp)
 600:	6442                	ld	s0,16(sp)
 602:	6125                	addi	sp,sp,96
 604:	8082                	ret

0000000000000606 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 606:	1141                	addi	sp,sp,-16
 608:	e422                	sd	s0,8(sp)
 60a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 610:	00000797          	auipc	a5,0x0
 614:	1907b783          	ld	a5,400(a5) # 7a0 <freep>
 618:	a805                	j	648 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 61a:	4618                	lw	a4,8(a2)
 61c:	9db9                	addw	a1,a1,a4
 61e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 622:	6398                	ld	a4,0(a5)
 624:	6318                	ld	a4,0(a4)
 626:	fee53823          	sd	a4,-16(a0)
 62a:	a091                	j	66e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 62c:	ff852703          	lw	a4,-8(a0)
 630:	9e39                	addw	a2,a2,a4
 632:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 634:	ff053703          	ld	a4,-16(a0)
 638:	e398                	sd	a4,0(a5)
 63a:	a099                	j	680 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63c:	6398                	ld	a4,0(a5)
 63e:	00e7e463          	bltu	a5,a4,646 <free+0x40>
 642:	00e6ea63          	bltu	a3,a4,656 <free+0x50>
{
 646:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 648:	fed7fae3          	bgeu	a5,a3,63c <free+0x36>
 64c:	6398                	ld	a4,0(a5)
 64e:	00e6e463          	bltu	a3,a4,656 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 652:	fee7eae3          	bltu	a5,a4,646 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 656:	ff852583          	lw	a1,-8(a0)
 65a:	6390                	ld	a2,0(a5)
 65c:	02059713          	slli	a4,a1,0x20
 660:	9301                	srli	a4,a4,0x20
 662:	0712                	slli	a4,a4,0x4
 664:	9736                	add	a4,a4,a3
 666:	fae60ae3          	beq	a2,a4,61a <free+0x14>
    bp->s.ptr = p->s.ptr;
 66a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 66e:	4790                	lw	a2,8(a5)
 670:	02061713          	slli	a4,a2,0x20
 674:	9301                	srli	a4,a4,0x20
 676:	0712                	slli	a4,a4,0x4
 678:	973e                	add	a4,a4,a5
 67a:	fae689e3          	beq	a3,a4,62c <free+0x26>
  } else
    p->s.ptr = bp;
 67e:	e394                	sd	a3,0(a5)
  freep = p;
 680:	00000717          	auipc	a4,0x0
 684:	12f73023          	sd	a5,288(a4) # 7a0 <freep>
}
 688:	6422                	ld	s0,8(sp)
 68a:	0141                	addi	sp,sp,16
 68c:	8082                	ret

000000000000068e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 68e:	7139                	addi	sp,sp,-64
 690:	fc06                	sd	ra,56(sp)
 692:	f822                	sd	s0,48(sp)
 694:	f426                	sd	s1,40(sp)
 696:	f04a                	sd	s2,32(sp)
 698:	ec4e                	sd	s3,24(sp)
 69a:	e852                	sd	s4,16(sp)
 69c:	e456                	sd	s5,8(sp)
 69e:	e05a                	sd	s6,0(sp)
 6a0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a2:	02051493          	slli	s1,a0,0x20
 6a6:	9081                	srli	s1,s1,0x20
 6a8:	04bd                	addi	s1,s1,15
 6aa:	8091                	srli	s1,s1,0x4
 6ac:	0014899b          	addiw	s3,s1,1
 6b0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6b2:	00000517          	auipc	a0,0x0
 6b6:	0ee53503          	ld	a0,238(a0) # 7a0 <freep>
 6ba:	c515                	beqz	a0,6e6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6be:	4798                	lw	a4,8(a5)
 6c0:	02977f63          	bgeu	a4,s1,6fe <malloc+0x70>
 6c4:	8a4e                	mv	s4,s3
 6c6:	0009871b          	sext.w	a4,s3
 6ca:	6685                	lui	a3,0x1
 6cc:	00d77363          	bgeu	a4,a3,6d2 <malloc+0x44>
 6d0:	6a05                	lui	s4,0x1
 6d2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6d6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6da:	00000917          	auipc	s2,0x0
 6de:	0c690913          	addi	s2,s2,198 # 7a0 <freep>
  if(p == (char*)-1)
 6e2:	5afd                	li	s5,-1
 6e4:	a88d                	j	756 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 6e6:	00000797          	auipc	a5,0x0
 6ea:	0c278793          	addi	a5,a5,194 # 7a8 <base>
 6ee:	00000717          	auipc	a4,0x0
 6f2:	0af73923          	sd	a5,178(a4) # 7a0 <freep>
 6f6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 6f8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 6fc:	b7e1                	j	6c4 <malloc+0x36>
      if(p->s.size == nunits)
 6fe:	02e48b63          	beq	s1,a4,734 <malloc+0xa6>
        p->s.size -= nunits;
 702:	4137073b          	subw	a4,a4,s3
 706:	c798                	sw	a4,8(a5)
        p += p->s.size;
 708:	1702                	slli	a4,a4,0x20
 70a:	9301                	srli	a4,a4,0x20
 70c:	0712                	slli	a4,a4,0x4
 70e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 710:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 714:	00000717          	auipc	a4,0x0
 718:	08a73623          	sd	a0,140(a4) # 7a0 <freep>
      return (void*)(p + 1);
 71c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 720:	70e2                	ld	ra,56(sp)
 722:	7442                	ld	s0,48(sp)
 724:	74a2                	ld	s1,40(sp)
 726:	7902                	ld	s2,32(sp)
 728:	69e2                	ld	s3,24(sp)
 72a:	6a42                	ld	s4,16(sp)
 72c:	6aa2                	ld	s5,8(sp)
 72e:	6b02                	ld	s6,0(sp)
 730:	6121                	addi	sp,sp,64
 732:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 734:	6398                	ld	a4,0(a5)
 736:	e118                	sd	a4,0(a0)
 738:	bff1                	j	714 <malloc+0x86>
  hp->s.size = nu;
 73a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 73e:	0541                	addi	a0,a0,16
 740:	00000097          	auipc	ra,0x0
 744:	ec6080e7          	jalr	-314(ra) # 606 <free>
  return freep;
 748:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 74c:	d971                	beqz	a0,720 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 750:	4798                	lw	a4,8(a5)
 752:	fa9776e3          	bgeu	a4,s1,6fe <malloc+0x70>
    if(p == freep)
 756:	00093703          	ld	a4,0(s2)
 75a:	853e                	mv	a0,a5
 75c:	fef719e3          	bne	a4,a5,74e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 760:	8552                	mv	a0,s4
 762:	00000097          	auipc	ra,0x0
 766:	b5e080e7          	jalr	-1186(ra) # 2c0 <sbrk>
  if(p == (char*)-1)
 76a:	fd5518e3          	bne	a0,s5,73a <malloc+0xac>
        return 0;
 76e:	4501                	li	a0,0
 770:	bf45                	j	720 <malloc+0x92>
