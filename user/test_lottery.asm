
user/_test_lottery:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "kernel/pstat.h"
#include "user/user.h"

int
main(int argc, char *argv[]) {
   0:	bd010113          	addi	sp,sp,-1072
   4:	42113423          	sd	ra,1064(sp)
   8:	42813023          	sd	s0,1056(sp)
   c:	40913c23          	sd	s1,1048(sp)
  10:	41213823          	sd	s2,1040(sp)
  14:	41313423          	sd	s3,1032(sp)
  18:	43010413          	addi	s0,sp,1072
  int x1 = settickets(5);
  1c:	4515                	li	a0,5
  1e:	00000097          	auipc	ra,0x0
  22:	30c080e7          	jalr	780(ra) # 32a <settickets>
  26:	84aa                	mv	s1,a0
  struct pstat p;
  int x2 = getpinfo(&p);
  28:	bd040513          	addi	a0,s0,-1072
  2c:	00000097          	auipc	ra,0x0
  30:	306080e7          	jalr	774(ra) # 332 <getpinfo>
  34:	862a                	mv	a2,a0
  uint64 *pp = NULL;
  printf("XV6_TEST_OUTPUT %d, %d", x1, x2);
  36:	85a6                	mv	a1,s1
  38:	00000517          	auipc	a0,0x0
  3c:	78050513          	addi	a0,a0,1920 # 7b8 <malloc+0xe8>
  40:	00000097          	auipc	ra,0x0
  44:	5d2080e7          	jalr	1490(ra) # 612 <printf>
  for(int i = 0; i < NPROC; i++){
  48:	cd040493          	addi	s1,s0,-816
  4c:	dd040993          	addi	s3,s0,-560
    printf("pid:%d, tickets:%d\n", p.pid[i], p.tickets[i]);
  50:	00000917          	auipc	s2,0x0
  54:	78090913          	addi	s2,s2,1920 # 7d0 <malloc+0x100>
  58:	4090                	lw	a2,0(s1)
  5a:	1004a583          	lw	a1,256(s1)
  5e:	854a                	mv	a0,s2
  60:	00000097          	auipc	ra,0x0
  64:	5b2080e7          	jalr	1458(ra) # 612 <printf>
  for(int i = 0; i < NPROC; i++){
  68:	0491                	addi	s1,s1,4
  6a:	ff3497e3          	bne	s1,s3,58 <main+0x58>
  }
  printf("dereference of NULL pointer:%p\n", *pp);
  6e:	00003583          	ld	a1,0(zero) # 0 <main>
  72:	00000517          	auipc	a0,0x0
  76:	77650513          	addi	a0,a0,1910 # 7e8 <malloc+0x118>
  7a:	00000097          	auipc	ra,0x0
  7e:	598080e7          	jalr	1432(ra) # 612 <printf>
  exit(0);
  82:	4501                	li	a0,0
  84:	00000097          	auipc	ra,0x0
  88:	1fe080e7          	jalr	510(ra) # 282 <exit>

000000000000008c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  92:	87aa                	mv	a5,a0
  94:	0585                	addi	a1,a1,1
  96:	0785                	addi	a5,a5,1
  98:	fff5c703          	lbu	a4,-1(a1)
  9c:	fee78fa3          	sb	a4,-1(a5)
  a0:	fb75                	bnez	a4,94 <strcpy+0x8>
    ;
  return os;
}
  a2:	6422                	ld	s0,8(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret

00000000000000a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	cb91                	beqz	a5,c6 <strcmp+0x1e>
  b4:	0005c703          	lbu	a4,0(a1)
  b8:	00f71763          	bne	a4,a5,c6 <strcmp+0x1e>
    p++, q++;
  bc:	0505                	addi	a0,a0,1
  be:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c0:	00054783          	lbu	a5,0(a0)
  c4:	fbe5                	bnez	a5,b4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  c6:	0005c503          	lbu	a0,0(a1)
}
  ca:	40a7853b          	subw	a0,a5,a0
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret

00000000000000d4 <strlen>:

uint
strlen(const char *s)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  da:	00054783          	lbu	a5,0(a0)
  de:	cf91                	beqz	a5,fa <strlen+0x26>
  e0:	0505                	addi	a0,a0,1
  e2:	87aa                	mv	a5,a0
  e4:	4685                	li	a3,1
  e6:	9e89                	subw	a3,a3,a0
  e8:	00f6853b          	addw	a0,a3,a5
  ec:	0785                	addi	a5,a5,1
  ee:	fff7c703          	lbu	a4,-1(a5)
  f2:	fb7d                	bnez	a4,e8 <strlen+0x14>
    ;
  return n;
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret
  for(n = 0; s[n]; n++)
  fa:	4501                	li	a0,0
  fc:	bfe5                	j	f4 <strlen+0x20>

00000000000000fe <memset>:

void*
memset(void *dst, int c, uint n)
{
  fe:	1141                	addi	sp,sp,-16
 100:	e422                	sd	s0,8(sp)
 102:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 104:	ce09                	beqz	a2,11e <memset+0x20>
 106:	87aa                	mv	a5,a0
 108:	fff6071b          	addiw	a4,a2,-1
 10c:	1702                	slli	a4,a4,0x20
 10e:	9301                	srli	a4,a4,0x20
 110:	0705                	addi	a4,a4,1
 112:	972a                	add	a4,a4,a0
    cdst[i] = c;
 114:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 118:	0785                	addi	a5,a5,1
 11a:	fee79de3          	bne	a5,a4,114 <memset+0x16>
  }
  return dst;
}
 11e:	6422                	ld	s0,8(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret

0000000000000124 <strchr>:

char*
strchr(const char *s, char c)
{
 124:	1141                	addi	sp,sp,-16
 126:	e422                	sd	s0,8(sp)
 128:	0800                	addi	s0,sp,16
  for(; *s; s++)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	cb99                	beqz	a5,144 <strchr+0x20>
    if(*s == c)
 130:	00f58763          	beq	a1,a5,13e <strchr+0x1a>
  for(; *s; s++)
 134:	0505                	addi	a0,a0,1
 136:	00054783          	lbu	a5,0(a0)
 13a:	fbfd                	bnez	a5,130 <strchr+0xc>
      return (char*)s;
  return 0;
 13c:	4501                	li	a0,0
}
 13e:	6422                	ld	s0,8(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret
  return 0;
 144:	4501                	li	a0,0
 146:	bfe5                	j	13e <strchr+0x1a>

0000000000000148 <gets>:

char*
gets(char *buf, int max)
{
 148:	711d                	addi	sp,sp,-96
 14a:	ec86                	sd	ra,88(sp)
 14c:	e8a2                	sd	s0,80(sp)
 14e:	e4a6                	sd	s1,72(sp)
 150:	e0ca                	sd	s2,64(sp)
 152:	fc4e                	sd	s3,56(sp)
 154:	f852                	sd	s4,48(sp)
 156:	f456                	sd	s5,40(sp)
 158:	f05a                	sd	s6,32(sp)
 15a:	ec5e                	sd	s7,24(sp)
 15c:	1080                	addi	s0,sp,96
 15e:	8baa                	mv	s7,a0
 160:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 162:	892a                	mv	s2,a0
 164:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 166:	4aa9                	li	s5,10
 168:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 16a:	89a6                	mv	s3,s1
 16c:	2485                	addiw	s1,s1,1
 16e:	0344d863          	bge	s1,s4,19e <gets+0x56>
    cc = read(0, &c, 1);
 172:	4605                	li	a2,1
 174:	faf40593          	addi	a1,s0,-81
 178:	4501                	li	a0,0
 17a:	00000097          	auipc	ra,0x0
 17e:	120080e7          	jalr	288(ra) # 29a <read>
    if(cc < 1)
 182:	00a05e63          	blez	a0,19e <gets+0x56>
    buf[i++] = c;
 186:	faf44783          	lbu	a5,-81(s0)
 18a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 18e:	01578763          	beq	a5,s5,19c <gets+0x54>
 192:	0905                	addi	s2,s2,1
 194:	fd679be3          	bne	a5,s6,16a <gets+0x22>
  for(i=0; i+1 < max; ){
 198:	89a6                	mv	s3,s1
 19a:	a011                	j	19e <gets+0x56>
 19c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 19e:	99de                	add	s3,s3,s7
 1a0:	00098023          	sb	zero,0(s3)
  return buf;
}
 1a4:	855e                	mv	a0,s7
 1a6:	60e6                	ld	ra,88(sp)
 1a8:	6446                	ld	s0,80(sp)
 1aa:	64a6                	ld	s1,72(sp)
 1ac:	6906                	ld	s2,64(sp)
 1ae:	79e2                	ld	s3,56(sp)
 1b0:	7a42                	ld	s4,48(sp)
 1b2:	7aa2                	ld	s5,40(sp)
 1b4:	7b02                	ld	s6,32(sp)
 1b6:	6be2                	ld	s7,24(sp)
 1b8:	6125                	addi	sp,sp,96
 1ba:	8082                	ret

00000000000001bc <stat>:

int
stat(const char *n, struct stat *st)
{
 1bc:	1101                	addi	sp,sp,-32
 1be:	ec06                	sd	ra,24(sp)
 1c0:	e822                	sd	s0,16(sp)
 1c2:	e426                	sd	s1,8(sp)
 1c4:	e04a                	sd	s2,0(sp)
 1c6:	1000                	addi	s0,sp,32
 1c8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ca:	4581                	li	a1,0
 1cc:	00000097          	auipc	ra,0x0
 1d0:	0f6080e7          	jalr	246(ra) # 2c2 <open>
  if(fd < 0)
 1d4:	02054563          	bltz	a0,1fe <stat+0x42>
 1d8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1da:	85ca                	mv	a1,s2
 1dc:	00000097          	auipc	ra,0x0
 1e0:	0fe080e7          	jalr	254(ra) # 2da <fstat>
 1e4:	892a                	mv	s2,a0
  close(fd);
 1e6:	8526                	mv	a0,s1
 1e8:	00000097          	auipc	ra,0x0
 1ec:	0c2080e7          	jalr	194(ra) # 2aa <close>
  return r;
}
 1f0:	854a                	mv	a0,s2
 1f2:	60e2                	ld	ra,24(sp)
 1f4:	6442                	ld	s0,16(sp)
 1f6:	64a2                	ld	s1,8(sp)
 1f8:	6902                	ld	s2,0(sp)
 1fa:	6105                	addi	sp,sp,32
 1fc:	8082                	ret
    return -1;
 1fe:	597d                	li	s2,-1
 200:	bfc5                	j	1f0 <stat+0x34>

0000000000000202 <atoi>:

int
atoi(const char *s)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 208:	00054603          	lbu	a2,0(a0)
 20c:	fd06079b          	addiw	a5,a2,-48
 210:	0ff7f793          	andi	a5,a5,255
 214:	4725                	li	a4,9
 216:	02f76963          	bltu	a4,a5,248 <atoi+0x46>
 21a:	86aa                	mv	a3,a0
  n = 0;
 21c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 21e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 220:	0685                	addi	a3,a3,1
 222:	0025179b          	slliw	a5,a0,0x2
 226:	9fa9                	addw	a5,a5,a0
 228:	0017979b          	slliw	a5,a5,0x1
 22c:	9fb1                	addw	a5,a5,a2
 22e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 232:	0006c603          	lbu	a2,0(a3)
 236:	fd06071b          	addiw	a4,a2,-48
 23a:	0ff77713          	andi	a4,a4,255
 23e:	fee5f1e3          	bgeu	a1,a4,220 <atoi+0x1e>
  return n;
}
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
  n = 0;
 248:	4501                	li	a0,0
 24a:	bfe5                	j	242 <atoi+0x40>

000000000000024c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 252:	02c05163          	blez	a2,274 <memmove+0x28>
 256:	fff6071b          	addiw	a4,a2,-1
 25a:	1702                	slli	a4,a4,0x20
 25c:	9301                	srli	a4,a4,0x20
 25e:	0705                	addi	a4,a4,1
 260:	972a                	add	a4,a4,a0
  dst = vdst;
 262:	87aa                	mv	a5,a0
    *dst++ = *src++;
 264:	0585                	addi	a1,a1,1
 266:	0785                	addi	a5,a5,1
 268:	fff5c683          	lbu	a3,-1(a1)
 26c:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 270:	fee79ae3          	bne	a5,a4,264 <memmove+0x18>
  return vdst;
}
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret

000000000000027a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 27a:	4885                	li	a7,1
 ecall
 27c:	00000073          	ecall
 ret
 280:	8082                	ret

0000000000000282 <exit>:
.global exit
exit:
 li a7, SYS_exit
 282:	4889                	li	a7,2
 ecall
 284:	00000073          	ecall
 ret
 288:	8082                	ret

000000000000028a <wait>:
.global wait
wait:
 li a7, SYS_wait
 28a:	488d                	li	a7,3
 ecall
 28c:	00000073          	ecall
 ret
 290:	8082                	ret

0000000000000292 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 292:	4891                	li	a7,4
 ecall
 294:	00000073          	ecall
 ret
 298:	8082                	ret

000000000000029a <read>:
.global read
read:
 li a7, SYS_read
 29a:	4895                	li	a7,5
 ecall
 29c:	00000073          	ecall
 ret
 2a0:	8082                	ret

00000000000002a2 <write>:
.global write
write:
 li a7, SYS_write
 2a2:	48c1                	li	a7,16
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <close>:
.global close
close:
 li a7, SYS_close
 2aa:	48d5                	li	a7,21
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2b2:	4899                	li	a7,6
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <exec>:
.global exec
exec:
 li a7, SYS_exec
 2ba:	489d                	li	a7,7
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <open>:
.global open
open:
 li a7, SYS_open
 2c2:	48bd                	li	a7,15
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2ca:	48c5                	li	a7,17
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2d2:	48c9                	li	a7,18
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2da:	48a1                	li	a7,8
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <link>:
.global link
link:
 li a7, SYS_link
 2e2:	48cd                	li	a7,19
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2ea:	48d1                	li	a7,20
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2f2:	48a5                	li	a7,9
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <dup>:
.global dup
dup:
 li a7, SYS_dup
 2fa:	48a9                	li	a7,10
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 302:	48ad                	li	a7,11
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 30a:	48b1                	li	a7,12
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 312:	48b5                	li	a7,13
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 31a:	48b9                	li	a7,14
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
 322:	48d9                	li	a7,22
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 32a:	48dd                	li	a7,23
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 332:	48e1                	li	a7,24
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 33a:	1101                	addi	sp,sp,-32
 33c:	ec06                	sd	ra,24(sp)
 33e:	e822                	sd	s0,16(sp)
 340:	1000                	addi	s0,sp,32
 342:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 346:	4605                	li	a2,1
 348:	fef40593          	addi	a1,s0,-17
 34c:	00000097          	auipc	ra,0x0
 350:	f56080e7          	jalr	-170(ra) # 2a2 <write>
}
 354:	60e2                	ld	ra,24(sp)
 356:	6442                	ld	s0,16(sp)
 358:	6105                	addi	sp,sp,32
 35a:	8082                	ret

000000000000035c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 35c:	7139                	addi	sp,sp,-64
 35e:	fc06                	sd	ra,56(sp)
 360:	f822                	sd	s0,48(sp)
 362:	f426                	sd	s1,40(sp)
 364:	f04a                	sd	s2,32(sp)
 366:	ec4e                	sd	s3,24(sp)
 368:	0080                	addi	s0,sp,64
 36a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36c:	c299                	beqz	a3,372 <printint+0x16>
 36e:	0805c863          	bltz	a1,3fe <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 372:	2581                	sext.w	a1,a1
  neg = 0;
 374:	4881                	li	a7,0
 376:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 37a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 37c:	2601                	sext.w	a2,a2
 37e:	00000517          	auipc	a0,0x0
 382:	49250513          	addi	a0,a0,1170 # 810 <digits>
 386:	883a                	mv	a6,a4
 388:	2705                	addiw	a4,a4,1
 38a:	02c5f7bb          	remuw	a5,a1,a2
 38e:	1782                	slli	a5,a5,0x20
 390:	9381                	srli	a5,a5,0x20
 392:	97aa                	add	a5,a5,a0
 394:	0007c783          	lbu	a5,0(a5)
 398:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 39c:	0005879b          	sext.w	a5,a1
 3a0:	02c5d5bb          	divuw	a1,a1,a2
 3a4:	0685                	addi	a3,a3,1
 3a6:	fec7f0e3          	bgeu	a5,a2,386 <printint+0x2a>
  if(neg)
 3aa:	00088b63          	beqz	a7,3c0 <printint+0x64>
    buf[i++] = '-';
 3ae:	fd040793          	addi	a5,s0,-48
 3b2:	973e                	add	a4,a4,a5
 3b4:	02d00793          	li	a5,45
 3b8:	fef70823          	sb	a5,-16(a4)
 3bc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3c0:	02e05863          	blez	a4,3f0 <printint+0x94>
 3c4:	fc040793          	addi	a5,s0,-64
 3c8:	00e78933          	add	s2,a5,a4
 3cc:	fff78993          	addi	s3,a5,-1
 3d0:	99ba                	add	s3,s3,a4
 3d2:	377d                	addiw	a4,a4,-1
 3d4:	1702                	slli	a4,a4,0x20
 3d6:	9301                	srli	a4,a4,0x20
 3d8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3dc:	fff94583          	lbu	a1,-1(s2)
 3e0:	8526                	mv	a0,s1
 3e2:	00000097          	auipc	ra,0x0
 3e6:	f58080e7          	jalr	-168(ra) # 33a <putc>
  while(--i >= 0)
 3ea:	197d                	addi	s2,s2,-1
 3ec:	ff3918e3          	bne	s2,s3,3dc <printint+0x80>
}
 3f0:	70e2                	ld	ra,56(sp)
 3f2:	7442                	ld	s0,48(sp)
 3f4:	74a2                	ld	s1,40(sp)
 3f6:	7902                	ld	s2,32(sp)
 3f8:	69e2                	ld	s3,24(sp)
 3fa:	6121                	addi	sp,sp,64
 3fc:	8082                	ret
    x = -xx;
 3fe:	40b005bb          	negw	a1,a1
    neg = 1;
 402:	4885                	li	a7,1
    x = -xx;
 404:	bf8d                	j	376 <printint+0x1a>

0000000000000406 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 406:	7119                	addi	sp,sp,-128
 408:	fc86                	sd	ra,120(sp)
 40a:	f8a2                	sd	s0,112(sp)
 40c:	f4a6                	sd	s1,104(sp)
 40e:	f0ca                	sd	s2,96(sp)
 410:	ecce                	sd	s3,88(sp)
 412:	e8d2                	sd	s4,80(sp)
 414:	e4d6                	sd	s5,72(sp)
 416:	e0da                	sd	s6,64(sp)
 418:	fc5e                	sd	s7,56(sp)
 41a:	f862                	sd	s8,48(sp)
 41c:	f466                	sd	s9,40(sp)
 41e:	f06a                	sd	s10,32(sp)
 420:	ec6e                	sd	s11,24(sp)
 422:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 424:	0005c903          	lbu	s2,0(a1)
 428:	18090f63          	beqz	s2,5c6 <vprintf+0x1c0>
 42c:	8aaa                	mv	s5,a0
 42e:	8b32                	mv	s6,a2
 430:	00158493          	addi	s1,a1,1
  state = 0;
 434:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 436:	02500a13          	li	s4,37
      if(c == 'd'){
 43a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 43e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 442:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 446:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 44a:	00000b97          	auipc	s7,0x0
 44e:	3c6b8b93          	addi	s7,s7,966 # 810 <digits>
 452:	a839                	j	470 <vprintf+0x6a>
        putc(fd, c);
 454:	85ca                	mv	a1,s2
 456:	8556                	mv	a0,s5
 458:	00000097          	auipc	ra,0x0
 45c:	ee2080e7          	jalr	-286(ra) # 33a <putc>
 460:	a019                	j	466 <vprintf+0x60>
    } else if(state == '%'){
 462:	01498f63          	beq	s3,s4,480 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 466:	0485                	addi	s1,s1,1
 468:	fff4c903          	lbu	s2,-1(s1)
 46c:	14090d63          	beqz	s2,5c6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 470:	0009079b          	sext.w	a5,s2
    if(state == 0){
 474:	fe0997e3          	bnez	s3,462 <vprintf+0x5c>
      if(c == '%'){
 478:	fd479ee3          	bne	a5,s4,454 <vprintf+0x4e>
        state = '%';
 47c:	89be                	mv	s3,a5
 47e:	b7e5                	j	466 <vprintf+0x60>
      if(c == 'd'){
 480:	05878063          	beq	a5,s8,4c0 <vprintf+0xba>
      } else if(c == 'l') {
 484:	05978c63          	beq	a5,s9,4dc <vprintf+0xd6>
      } else if(c == 'x') {
 488:	07a78863          	beq	a5,s10,4f8 <vprintf+0xf2>
      } else if(c == 'p') {
 48c:	09b78463          	beq	a5,s11,514 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 490:	07300713          	li	a4,115
 494:	0ce78663          	beq	a5,a4,560 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 498:	06300713          	li	a4,99
 49c:	0ee78e63          	beq	a5,a4,598 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4a0:	11478863          	beq	a5,s4,5b0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4a4:	85d2                	mv	a1,s4
 4a6:	8556                	mv	a0,s5
 4a8:	00000097          	auipc	ra,0x0
 4ac:	e92080e7          	jalr	-366(ra) # 33a <putc>
        putc(fd, c);
 4b0:	85ca                	mv	a1,s2
 4b2:	8556                	mv	a0,s5
 4b4:	00000097          	auipc	ra,0x0
 4b8:	e86080e7          	jalr	-378(ra) # 33a <putc>
      }
      state = 0;
 4bc:	4981                	li	s3,0
 4be:	b765                	j	466 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4c0:	008b0913          	addi	s2,s6,8
 4c4:	4685                	li	a3,1
 4c6:	4629                	li	a2,10
 4c8:	000b2583          	lw	a1,0(s6)
 4cc:	8556                	mv	a0,s5
 4ce:	00000097          	auipc	ra,0x0
 4d2:	e8e080e7          	jalr	-370(ra) # 35c <printint>
 4d6:	8b4a                	mv	s6,s2
      state = 0;
 4d8:	4981                	li	s3,0
 4da:	b771                	j	466 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4dc:	008b0913          	addi	s2,s6,8
 4e0:	4681                	li	a3,0
 4e2:	4629                	li	a2,10
 4e4:	000b2583          	lw	a1,0(s6)
 4e8:	8556                	mv	a0,s5
 4ea:	00000097          	auipc	ra,0x0
 4ee:	e72080e7          	jalr	-398(ra) # 35c <printint>
 4f2:	8b4a                	mv	s6,s2
      state = 0;
 4f4:	4981                	li	s3,0
 4f6:	bf85                	j	466 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4f8:	008b0913          	addi	s2,s6,8
 4fc:	4681                	li	a3,0
 4fe:	4641                	li	a2,16
 500:	000b2583          	lw	a1,0(s6)
 504:	8556                	mv	a0,s5
 506:	00000097          	auipc	ra,0x0
 50a:	e56080e7          	jalr	-426(ra) # 35c <printint>
 50e:	8b4a                	mv	s6,s2
      state = 0;
 510:	4981                	li	s3,0
 512:	bf91                	j	466 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 514:	008b0793          	addi	a5,s6,8
 518:	f8f43423          	sd	a5,-120(s0)
 51c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 520:	03000593          	li	a1,48
 524:	8556                	mv	a0,s5
 526:	00000097          	auipc	ra,0x0
 52a:	e14080e7          	jalr	-492(ra) # 33a <putc>
  putc(fd, 'x');
 52e:	85ea                	mv	a1,s10
 530:	8556                	mv	a0,s5
 532:	00000097          	auipc	ra,0x0
 536:	e08080e7          	jalr	-504(ra) # 33a <putc>
 53a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 53c:	03c9d793          	srli	a5,s3,0x3c
 540:	97de                	add	a5,a5,s7
 542:	0007c583          	lbu	a1,0(a5)
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	df2080e7          	jalr	-526(ra) # 33a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 550:	0992                	slli	s3,s3,0x4
 552:	397d                	addiw	s2,s2,-1
 554:	fe0914e3          	bnez	s2,53c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 558:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 55c:	4981                	li	s3,0
 55e:	b721                	j	466 <vprintf+0x60>
        s = va_arg(ap, char*);
 560:	008b0993          	addi	s3,s6,8
 564:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 568:	02090163          	beqz	s2,58a <vprintf+0x184>
        while(*s != 0){
 56c:	00094583          	lbu	a1,0(s2)
 570:	c9a1                	beqz	a1,5c0 <vprintf+0x1ba>
          putc(fd, *s);
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	dc6080e7          	jalr	-570(ra) # 33a <putc>
          s++;
 57c:	0905                	addi	s2,s2,1
        while(*s != 0){
 57e:	00094583          	lbu	a1,0(s2)
 582:	f9e5                	bnez	a1,572 <vprintf+0x16c>
        s = va_arg(ap, char*);
 584:	8b4e                	mv	s6,s3
      state = 0;
 586:	4981                	li	s3,0
 588:	bdf9                	j	466 <vprintf+0x60>
          s = "(null)";
 58a:	00000917          	auipc	s2,0x0
 58e:	27e90913          	addi	s2,s2,638 # 808 <malloc+0x138>
        while(*s != 0){
 592:	02800593          	li	a1,40
 596:	bff1                	j	572 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 598:	008b0913          	addi	s2,s6,8
 59c:	000b4583          	lbu	a1,0(s6)
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	d98080e7          	jalr	-616(ra) # 33a <putc>
 5aa:	8b4a                	mv	s6,s2
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	bd65                	j	466 <vprintf+0x60>
        putc(fd, c);
 5b0:	85d2                	mv	a1,s4
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	d86080e7          	jalr	-634(ra) # 33a <putc>
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	b565                	j	466 <vprintf+0x60>
        s = va_arg(ap, char*);
 5c0:	8b4e                	mv	s6,s3
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b54d                	j	466 <vprintf+0x60>
    }
  }
}
 5c6:	70e6                	ld	ra,120(sp)
 5c8:	7446                	ld	s0,112(sp)
 5ca:	74a6                	ld	s1,104(sp)
 5cc:	7906                	ld	s2,96(sp)
 5ce:	69e6                	ld	s3,88(sp)
 5d0:	6a46                	ld	s4,80(sp)
 5d2:	6aa6                	ld	s5,72(sp)
 5d4:	6b06                	ld	s6,64(sp)
 5d6:	7be2                	ld	s7,56(sp)
 5d8:	7c42                	ld	s8,48(sp)
 5da:	7ca2                	ld	s9,40(sp)
 5dc:	7d02                	ld	s10,32(sp)
 5de:	6de2                	ld	s11,24(sp)
 5e0:	6109                	addi	sp,sp,128
 5e2:	8082                	ret

00000000000005e4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5e4:	715d                	addi	sp,sp,-80
 5e6:	ec06                	sd	ra,24(sp)
 5e8:	e822                	sd	s0,16(sp)
 5ea:	1000                	addi	s0,sp,32
 5ec:	e010                	sd	a2,0(s0)
 5ee:	e414                	sd	a3,8(s0)
 5f0:	e818                	sd	a4,16(s0)
 5f2:	ec1c                	sd	a5,24(s0)
 5f4:	03043023          	sd	a6,32(s0)
 5f8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 600:	8622                	mv	a2,s0
 602:	00000097          	auipc	ra,0x0
 606:	e04080e7          	jalr	-508(ra) # 406 <vprintf>
}
 60a:	60e2                	ld	ra,24(sp)
 60c:	6442                	ld	s0,16(sp)
 60e:	6161                	addi	sp,sp,80
 610:	8082                	ret

0000000000000612 <printf>:

void
printf(const char *fmt, ...)
{
 612:	711d                	addi	sp,sp,-96
 614:	ec06                	sd	ra,24(sp)
 616:	e822                	sd	s0,16(sp)
 618:	1000                	addi	s0,sp,32
 61a:	e40c                	sd	a1,8(s0)
 61c:	e810                	sd	a2,16(s0)
 61e:	ec14                	sd	a3,24(s0)
 620:	f018                	sd	a4,32(s0)
 622:	f41c                	sd	a5,40(s0)
 624:	03043823          	sd	a6,48(s0)
 628:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 62c:	00840613          	addi	a2,s0,8
 630:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 634:	85aa                	mv	a1,a0
 636:	4505                	li	a0,1
 638:	00000097          	auipc	ra,0x0
 63c:	dce080e7          	jalr	-562(ra) # 406 <vprintf>
}
 640:	60e2                	ld	ra,24(sp)
 642:	6442                	ld	s0,16(sp)
 644:	6125                	addi	sp,sp,96
 646:	8082                	ret

0000000000000648 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 648:	1141                	addi	sp,sp,-16
 64a:	e422                	sd	s0,8(sp)
 64c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 64e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 652:	00000797          	auipc	a5,0x0
 656:	1d67b783          	ld	a5,470(a5) # 828 <freep>
 65a:	a805                	j	68a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 65c:	4618                	lw	a4,8(a2)
 65e:	9db9                	addw	a1,a1,a4
 660:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 664:	6398                	ld	a4,0(a5)
 666:	6318                	ld	a4,0(a4)
 668:	fee53823          	sd	a4,-16(a0)
 66c:	a091                	j	6b0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 66e:	ff852703          	lw	a4,-8(a0)
 672:	9e39                	addw	a2,a2,a4
 674:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 676:	ff053703          	ld	a4,-16(a0)
 67a:	e398                	sd	a4,0(a5)
 67c:	a099                	j	6c2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67e:	6398                	ld	a4,0(a5)
 680:	00e7e463          	bltu	a5,a4,688 <free+0x40>
 684:	00e6ea63          	bltu	a3,a4,698 <free+0x50>
{
 688:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68a:	fed7fae3          	bgeu	a5,a3,67e <free+0x36>
 68e:	6398                	ld	a4,0(a5)
 690:	00e6e463          	bltu	a3,a4,698 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 694:	fee7eae3          	bltu	a5,a4,688 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 698:	ff852583          	lw	a1,-8(a0)
 69c:	6390                	ld	a2,0(a5)
 69e:	02059713          	slli	a4,a1,0x20
 6a2:	9301                	srli	a4,a4,0x20
 6a4:	0712                	slli	a4,a4,0x4
 6a6:	9736                	add	a4,a4,a3
 6a8:	fae60ae3          	beq	a2,a4,65c <free+0x14>
    bp->s.ptr = p->s.ptr;
 6ac:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6b0:	4790                	lw	a2,8(a5)
 6b2:	02061713          	slli	a4,a2,0x20
 6b6:	9301                	srli	a4,a4,0x20
 6b8:	0712                	slli	a4,a4,0x4
 6ba:	973e                	add	a4,a4,a5
 6bc:	fae689e3          	beq	a3,a4,66e <free+0x26>
  } else
    p->s.ptr = bp;
 6c0:	e394                	sd	a3,0(a5)
  freep = p;
 6c2:	00000717          	auipc	a4,0x0
 6c6:	16f73323          	sd	a5,358(a4) # 828 <freep>
}
 6ca:	6422                	ld	s0,8(sp)
 6cc:	0141                	addi	sp,sp,16
 6ce:	8082                	ret

00000000000006d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6d0:	7139                	addi	sp,sp,-64
 6d2:	fc06                	sd	ra,56(sp)
 6d4:	f822                	sd	s0,48(sp)
 6d6:	f426                	sd	s1,40(sp)
 6d8:	f04a                	sd	s2,32(sp)
 6da:	ec4e                	sd	s3,24(sp)
 6dc:	e852                	sd	s4,16(sp)
 6de:	e456                	sd	s5,8(sp)
 6e0:	e05a                	sd	s6,0(sp)
 6e2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e4:	02051493          	slli	s1,a0,0x20
 6e8:	9081                	srli	s1,s1,0x20
 6ea:	04bd                	addi	s1,s1,15
 6ec:	8091                	srli	s1,s1,0x4
 6ee:	0014899b          	addiw	s3,s1,1
 6f2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6f4:	00000517          	auipc	a0,0x0
 6f8:	13453503          	ld	a0,308(a0) # 828 <freep>
 6fc:	c515                	beqz	a0,728 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 700:	4798                	lw	a4,8(a5)
 702:	02977f63          	bgeu	a4,s1,740 <malloc+0x70>
 706:	8a4e                	mv	s4,s3
 708:	0009871b          	sext.w	a4,s3
 70c:	6685                	lui	a3,0x1
 70e:	00d77363          	bgeu	a4,a3,714 <malloc+0x44>
 712:	6a05                	lui	s4,0x1
 714:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 718:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 71c:	00000917          	auipc	s2,0x0
 720:	10c90913          	addi	s2,s2,268 # 828 <freep>
  if(p == (char*)-1)
 724:	5afd                	li	s5,-1
 726:	a88d                	j	798 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 728:	00000797          	auipc	a5,0x0
 72c:	10878793          	addi	a5,a5,264 # 830 <base>
 730:	00000717          	auipc	a4,0x0
 734:	0ef73c23          	sd	a5,248(a4) # 828 <freep>
 738:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 73a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 73e:	b7e1                	j	706 <malloc+0x36>
      if(p->s.size == nunits)
 740:	02e48b63          	beq	s1,a4,776 <malloc+0xa6>
        p->s.size -= nunits;
 744:	4137073b          	subw	a4,a4,s3
 748:	c798                	sw	a4,8(a5)
        p += p->s.size;
 74a:	1702                	slli	a4,a4,0x20
 74c:	9301                	srli	a4,a4,0x20
 74e:	0712                	slli	a4,a4,0x4
 750:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 752:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 756:	00000717          	auipc	a4,0x0
 75a:	0ca73923          	sd	a0,210(a4) # 828 <freep>
      return (void*)(p + 1);
 75e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 762:	70e2                	ld	ra,56(sp)
 764:	7442                	ld	s0,48(sp)
 766:	74a2                	ld	s1,40(sp)
 768:	7902                	ld	s2,32(sp)
 76a:	69e2                	ld	s3,24(sp)
 76c:	6a42                	ld	s4,16(sp)
 76e:	6aa2                	ld	s5,8(sp)
 770:	6b02                	ld	s6,0(sp)
 772:	6121                	addi	sp,sp,64
 774:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 776:	6398                	ld	a4,0(a5)
 778:	e118                	sd	a4,0(a0)
 77a:	bff1                	j	756 <malloc+0x86>
  hp->s.size = nu;
 77c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 780:	0541                	addi	a0,a0,16
 782:	00000097          	auipc	ra,0x0
 786:	ec6080e7          	jalr	-314(ra) # 648 <free>
  return freep;
 78a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 78e:	d971                	beqz	a0,762 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 790:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 792:	4798                	lw	a4,8(a5)
 794:	fa9776e3          	bgeu	a4,s1,740 <malloc+0x70>
    if(p == freep)
 798:	00093703          	ld	a4,0(s2)
 79c:	853e                	mv	a0,a5
 79e:	fef719e3          	bne	a4,a5,790 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7a2:	8552                	mv	a0,s4
 7a4:	00000097          	auipc	ra,0x0
 7a8:	b66080e7          	jalr	-1178(ra) # 30a <sbrk>
  if(p == (char*)-1)
 7ac:	fd5518e3          	bne	a0,s5,77c <malloc+0xac>
        return 0;
 7b0:	4501                	li	a0,0
 7b2:	bf45                	j	762 <malloc+0x92>
