
user/_test_2:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[]) {
   0:	7135                	addi	sp,sp,-160
   2:	ed06                	sd	ra,152(sp)
   4:	e922                	sd	s0,144(sp)
   6:	e526                	sd	s1,136(sp)
   8:	e14a                	sd	s2,128(sp)
   a:	fcce                	sd	s3,120(sp)
   c:	1100                	addi	s0,sp,160
    int x1 = getreadcount();
   e:	00000097          	auipc	ra,0x0
  12:	2fa080e7          	jalr	762(ra) # 308 <getreadcount>
  16:	89aa                	mv	s3,a0

    int rc = fork();
  18:	00000097          	auipc	ra,0x0
  1c:	248080e7          	jalr	584(ra) # 260 <fork>
  20:	892a                	mv	s2,a0
  22:	64e1                	lui	s1,0x18
  24:	6a048493          	addi	s1,s1,1696 # 186a0 <__global_pointer$+0x176cf>

    int total = 0;
    int i;
    for (i = 0; i < 100000; i++) {
	char buf[100];
	(void) read(4, buf, 1);
  28:	4605                	li	a2,1
  2a:	f6840593          	addi	a1,s0,-152
  2e:	4511                	li	a0,4
  30:	00000097          	auipc	ra,0x0
  34:	250080e7          	jalr	592(ra) # 280 <read>
    for (i = 0; i < 100000; i++) {
  38:	34fd                	addiw	s1,s1,-1
  3a:	f4fd                	bnez	s1,28 <main+0x28>
    }
    // https://wiki.osdev.org/Shutdown
    // (void) shutdown();

    if (rc > 0) {
  3c:	01204763          	bgtz	s2,4a <main+0x4a>
	(void) wait(0);
	int x2 = getreadcount();
	total += (x2 - x1);
	printf("XV6_TEST_OUTPUT %d\n", total);
    }
    exit(0);
  40:	4501                	li	a0,0
  42:	00000097          	auipc	ra,0x0
  46:	226080e7          	jalr	550(ra) # 268 <exit>
	(void) wait(0);
  4a:	4501                	li	a0,0
  4c:	00000097          	auipc	ra,0x0
  50:	224080e7          	jalr	548(ra) # 270 <wait>
	int x2 = getreadcount();
  54:	00000097          	auipc	ra,0x0
  58:	2b4080e7          	jalr	692(ra) # 308 <getreadcount>
	printf("XV6_TEST_OUTPUT %d\n", total);
  5c:	413505bb          	subw	a1,a0,s3
  60:	00000517          	auipc	a0,0x0
  64:	74050513          	addi	a0,a0,1856 # 7a0 <malloc+0xea>
  68:	00000097          	auipc	ra,0x0
  6c:	590080e7          	jalr	1424(ra) # 5f8 <printf>
  70:	bfc1                	j	40 <main+0x40>

0000000000000072 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  72:	1141                	addi	sp,sp,-16
  74:	e422                	sd	s0,8(sp)
  76:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  78:	87aa                	mv	a5,a0
  7a:	0585                	addi	a1,a1,1
  7c:	0785                	addi	a5,a5,1
  7e:	fff5c703          	lbu	a4,-1(a1)
  82:	fee78fa3          	sb	a4,-1(a5)
  86:	fb75                	bnez	a4,7a <strcpy+0x8>
    ;
  return os;
}
  88:	6422                	ld	s0,8(sp)
  8a:	0141                	addi	sp,sp,16
  8c:	8082                	ret

000000000000008e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8e:	1141                	addi	sp,sp,-16
  90:	e422                	sd	s0,8(sp)
  92:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  94:	00054783          	lbu	a5,0(a0)
  98:	cb91                	beqz	a5,ac <strcmp+0x1e>
  9a:	0005c703          	lbu	a4,0(a1)
  9e:	00f71763          	bne	a4,a5,ac <strcmp+0x1e>
    p++, q++;
  a2:	0505                	addi	a0,a0,1
  a4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a6:	00054783          	lbu	a5,0(a0)
  aa:	fbe5                	bnez	a5,9a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ac:	0005c503          	lbu	a0,0(a1)
}
  b0:	40a7853b          	subw	a0,a5,a0
  b4:	6422                	ld	s0,8(sp)
  b6:	0141                	addi	sp,sp,16
  b8:	8082                	ret

00000000000000ba <strlen>:

uint
strlen(const char *s)
{
  ba:	1141                	addi	sp,sp,-16
  bc:	e422                	sd	s0,8(sp)
  be:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c0:	00054783          	lbu	a5,0(a0)
  c4:	cf91                	beqz	a5,e0 <strlen+0x26>
  c6:	0505                	addi	a0,a0,1
  c8:	87aa                	mv	a5,a0
  ca:	4685                	li	a3,1
  cc:	9e89                	subw	a3,a3,a0
  ce:	00f6853b          	addw	a0,a3,a5
  d2:	0785                	addi	a5,a5,1
  d4:	fff7c703          	lbu	a4,-1(a5)
  d8:	fb7d                	bnez	a4,ce <strlen+0x14>
    ;
  return n;
}
  da:	6422                	ld	s0,8(sp)
  dc:	0141                	addi	sp,sp,16
  de:	8082                	ret
  for(n = 0; s[n]; n++)
  e0:	4501                	li	a0,0
  e2:	bfe5                	j	da <strlen+0x20>

00000000000000e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e422                	sd	s0,8(sp)
  e8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ea:	ce09                	beqz	a2,104 <memset+0x20>
  ec:	87aa                	mv	a5,a0
  ee:	fff6071b          	addiw	a4,a2,-1
  f2:	1702                	slli	a4,a4,0x20
  f4:	9301                	srli	a4,a4,0x20
  f6:	0705                	addi	a4,a4,1
  f8:	972a                	add	a4,a4,a0
    cdst[i] = c;
  fa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  fe:	0785                	addi	a5,a5,1
 100:	fee79de3          	bne	a5,a4,fa <memset+0x16>
  }
  return dst;
}
 104:	6422                	ld	s0,8(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret

000000000000010a <strchr>:

char*
strchr(const char *s, char c)
{
 10a:	1141                	addi	sp,sp,-16
 10c:	e422                	sd	s0,8(sp)
 10e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 110:	00054783          	lbu	a5,0(a0)
 114:	cb99                	beqz	a5,12a <strchr+0x20>
    if(*s == c)
 116:	00f58763          	beq	a1,a5,124 <strchr+0x1a>
  for(; *s; s++)
 11a:	0505                	addi	a0,a0,1
 11c:	00054783          	lbu	a5,0(a0)
 120:	fbfd                	bnez	a5,116 <strchr+0xc>
      return (char*)s;
  return 0;
 122:	4501                	li	a0,0
}
 124:	6422                	ld	s0,8(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret
  return 0;
 12a:	4501                	li	a0,0
 12c:	bfe5                	j	124 <strchr+0x1a>

000000000000012e <gets>:

char*
gets(char *buf, int max)
{
 12e:	711d                	addi	sp,sp,-96
 130:	ec86                	sd	ra,88(sp)
 132:	e8a2                	sd	s0,80(sp)
 134:	e4a6                	sd	s1,72(sp)
 136:	e0ca                	sd	s2,64(sp)
 138:	fc4e                	sd	s3,56(sp)
 13a:	f852                	sd	s4,48(sp)
 13c:	f456                	sd	s5,40(sp)
 13e:	f05a                	sd	s6,32(sp)
 140:	ec5e                	sd	s7,24(sp)
 142:	1080                	addi	s0,sp,96
 144:	8baa                	mv	s7,a0
 146:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 148:	892a                	mv	s2,a0
 14a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 14c:	4aa9                	li	s5,10
 14e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 150:	89a6                	mv	s3,s1
 152:	2485                	addiw	s1,s1,1
 154:	0344d863          	bge	s1,s4,184 <gets+0x56>
    cc = read(0, &c, 1);
 158:	4605                	li	a2,1
 15a:	faf40593          	addi	a1,s0,-81
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	120080e7          	jalr	288(ra) # 280 <read>
    if(cc < 1)
 168:	00a05e63          	blez	a0,184 <gets+0x56>
    buf[i++] = c;
 16c:	faf44783          	lbu	a5,-81(s0)
 170:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 174:	01578763          	beq	a5,s5,182 <gets+0x54>
 178:	0905                	addi	s2,s2,1
 17a:	fd679be3          	bne	a5,s6,150 <gets+0x22>
  for(i=0; i+1 < max; ){
 17e:	89a6                	mv	s3,s1
 180:	a011                	j	184 <gets+0x56>
 182:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 184:	99de                	add	s3,s3,s7
 186:	00098023          	sb	zero,0(s3)
  return buf;
}
 18a:	855e                	mv	a0,s7
 18c:	60e6                	ld	ra,88(sp)
 18e:	6446                	ld	s0,80(sp)
 190:	64a6                	ld	s1,72(sp)
 192:	6906                	ld	s2,64(sp)
 194:	79e2                	ld	s3,56(sp)
 196:	7a42                	ld	s4,48(sp)
 198:	7aa2                	ld	s5,40(sp)
 19a:	7b02                	ld	s6,32(sp)
 19c:	6be2                	ld	s7,24(sp)
 19e:	6125                	addi	sp,sp,96
 1a0:	8082                	ret

00000000000001a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a2:	1101                	addi	sp,sp,-32
 1a4:	ec06                	sd	ra,24(sp)
 1a6:	e822                	sd	s0,16(sp)
 1a8:	e426                	sd	s1,8(sp)
 1aa:	e04a                	sd	s2,0(sp)
 1ac:	1000                	addi	s0,sp,32
 1ae:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b0:	4581                	li	a1,0
 1b2:	00000097          	auipc	ra,0x0
 1b6:	0f6080e7          	jalr	246(ra) # 2a8 <open>
  if(fd < 0)
 1ba:	02054563          	bltz	a0,1e4 <stat+0x42>
 1be:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c0:	85ca                	mv	a1,s2
 1c2:	00000097          	auipc	ra,0x0
 1c6:	0fe080e7          	jalr	254(ra) # 2c0 <fstat>
 1ca:	892a                	mv	s2,a0
  close(fd);
 1cc:	8526                	mv	a0,s1
 1ce:	00000097          	auipc	ra,0x0
 1d2:	0c2080e7          	jalr	194(ra) # 290 <close>
  return r;
}
 1d6:	854a                	mv	a0,s2
 1d8:	60e2                	ld	ra,24(sp)
 1da:	6442                	ld	s0,16(sp)
 1dc:	64a2                	ld	s1,8(sp)
 1de:	6902                	ld	s2,0(sp)
 1e0:	6105                	addi	sp,sp,32
 1e2:	8082                	ret
    return -1;
 1e4:	597d                	li	s2,-1
 1e6:	bfc5                	j	1d6 <stat+0x34>

00000000000001e8 <atoi>:

int
atoi(const char *s)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e422                	sd	s0,8(sp)
 1ec:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ee:	00054603          	lbu	a2,0(a0)
 1f2:	fd06079b          	addiw	a5,a2,-48
 1f6:	0ff7f793          	andi	a5,a5,255
 1fa:	4725                	li	a4,9
 1fc:	02f76963          	bltu	a4,a5,22e <atoi+0x46>
 200:	86aa                	mv	a3,a0
  n = 0;
 202:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 204:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 206:	0685                	addi	a3,a3,1
 208:	0025179b          	slliw	a5,a0,0x2
 20c:	9fa9                	addw	a5,a5,a0
 20e:	0017979b          	slliw	a5,a5,0x1
 212:	9fb1                	addw	a5,a5,a2
 214:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 218:	0006c603          	lbu	a2,0(a3)
 21c:	fd06071b          	addiw	a4,a2,-48
 220:	0ff77713          	andi	a4,a4,255
 224:	fee5f1e3          	bgeu	a1,a4,206 <atoi+0x1e>
  return n;
}
 228:	6422                	ld	s0,8(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret
  n = 0;
 22e:	4501                	li	a0,0
 230:	bfe5                	j	228 <atoi+0x40>

0000000000000232 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 238:	02c05163          	blez	a2,25a <memmove+0x28>
 23c:	fff6071b          	addiw	a4,a2,-1
 240:	1702                	slli	a4,a4,0x20
 242:	9301                	srli	a4,a4,0x20
 244:	0705                	addi	a4,a4,1
 246:	972a                	add	a4,a4,a0
  dst = vdst;
 248:	87aa                	mv	a5,a0
    *dst++ = *src++;
 24a:	0585                	addi	a1,a1,1
 24c:	0785                	addi	a5,a5,1
 24e:	fff5c683          	lbu	a3,-1(a1)
 252:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 256:	fee79ae3          	bne	a5,a4,24a <memmove+0x18>
  return vdst;
}
 25a:	6422                	ld	s0,8(sp)
 25c:	0141                	addi	sp,sp,16
 25e:	8082                	ret

0000000000000260 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 260:	4885                	li	a7,1
 ecall
 262:	00000073          	ecall
 ret
 266:	8082                	ret

0000000000000268 <exit>:
.global exit
exit:
 li a7, SYS_exit
 268:	4889                	li	a7,2
 ecall
 26a:	00000073          	ecall
 ret
 26e:	8082                	ret

0000000000000270 <wait>:
.global wait
wait:
 li a7, SYS_wait
 270:	488d                	li	a7,3
 ecall
 272:	00000073          	ecall
 ret
 276:	8082                	ret

0000000000000278 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 278:	4891                	li	a7,4
 ecall
 27a:	00000073          	ecall
 ret
 27e:	8082                	ret

0000000000000280 <read>:
.global read
read:
 li a7, SYS_read
 280:	4895                	li	a7,5
 ecall
 282:	00000073          	ecall
 ret
 286:	8082                	ret

0000000000000288 <write>:
.global write
write:
 li a7, SYS_write
 288:	48c1                	li	a7,16
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <close>:
.global close
close:
 li a7, SYS_close
 290:	48d5                	li	a7,21
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <kill>:
.global kill
kill:
 li a7, SYS_kill
 298:	4899                	li	a7,6
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2a0:	489d                	li	a7,7
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <open>:
.global open
open:
 li a7, SYS_open
 2a8:	48bd                	li	a7,15
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2b0:	48c5                	li	a7,17
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2b8:	48c9                	li	a7,18
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2c0:	48a1                	li	a7,8
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <link>:
.global link
link:
 li a7, SYS_link
 2c8:	48cd                	li	a7,19
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2d0:	48d1                	li	a7,20
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2d8:	48a5                	li	a7,9
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2e0:	48a9                	li	a7,10
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2e8:	48ad                	li	a7,11
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2f0:	48b1                	li	a7,12
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2f8:	48b5                	li	a7,13
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 300:	48b9                	li	a7,14
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
 308:	48d9                	li	a7,22
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 310:	48dd                	li	a7,23
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 318:	48e1                	li	a7,24
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 320:	1101                	addi	sp,sp,-32
 322:	ec06                	sd	ra,24(sp)
 324:	e822                	sd	s0,16(sp)
 326:	1000                	addi	s0,sp,32
 328:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 32c:	4605                	li	a2,1
 32e:	fef40593          	addi	a1,s0,-17
 332:	00000097          	auipc	ra,0x0
 336:	f56080e7          	jalr	-170(ra) # 288 <write>
}
 33a:	60e2                	ld	ra,24(sp)
 33c:	6442                	ld	s0,16(sp)
 33e:	6105                	addi	sp,sp,32
 340:	8082                	ret

0000000000000342 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 342:	7139                	addi	sp,sp,-64
 344:	fc06                	sd	ra,56(sp)
 346:	f822                	sd	s0,48(sp)
 348:	f426                	sd	s1,40(sp)
 34a:	f04a                	sd	s2,32(sp)
 34c:	ec4e                	sd	s3,24(sp)
 34e:	0080                	addi	s0,sp,64
 350:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 352:	c299                	beqz	a3,358 <printint+0x16>
 354:	0805c863          	bltz	a1,3e4 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 358:	2581                	sext.w	a1,a1
  neg = 0;
 35a:	4881                	li	a7,0
 35c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 360:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 362:	2601                	sext.w	a2,a2
 364:	00000517          	auipc	a0,0x0
 368:	45c50513          	addi	a0,a0,1116 # 7c0 <digits>
 36c:	883a                	mv	a6,a4
 36e:	2705                	addiw	a4,a4,1
 370:	02c5f7bb          	remuw	a5,a1,a2
 374:	1782                	slli	a5,a5,0x20
 376:	9381                	srli	a5,a5,0x20
 378:	97aa                	add	a5,a5,a0
 37a:	0007c783          	lbu	a5,0(a5)
 37e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 382:	0005879b          	sext.w	a5,a1
 386:	02c5d5bb          	divuw	a1,a1,a2
 38a:	0685                	addi	a3,a3,1
 38c:	fec7f0e3          	bgeu	a5,a2,36c <printint+0x2a>
  if(neg)
 390:	00088b63          	beqz	a7,3a6 <printint+0x64>
    buf[i++] = '-';
 394:	fd040793          	addi	a5,s0,-48
 398:	973e                	add	a4,a4,a5
 39a:	02d00793          	li	a5,45
 39e:	fef70823          	sb	a5,-16(a4)
 3a2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3a6:	02e05863          	blez	a4,3d6 <printint+0x94>
 3aa:	fc040793          	addi	a5,s0,-64
 3ae:	00e78933          	add	s2,a5,a4
 3b2:	fff78993          	addi	s3,a5,-1
 3b6:	99ba                	add	s3,s3,a4
 3b8:	377d                	addiw	a4,a4,-1
 3ba:	1702                	slli	a4,a4,0x20
 3bc:	9301                	srli	a4,a4,0x20
 3be:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3c2:	fff94583          	lbu	a1,-1(s2)
 3c6:	8526                	mv	a0,s1
 3c8:	00000097          	auipc	ra,0x0
 3cc:	f58080e7          	jalr	-168(ra) # 320 <putc>
  while(--i >= 0)
 3d0:	197d                	addi	s2,s2,-1
 3d2:	ff3918e3          	bne	s2,s3,3c2 <printint+0x80>
}
 3d6:	70e2                	ld	ra,56(sp)
 3d8:	7442                	ld	s0,48(sp)
 3da:	74a2                	ld	s1,40(sp)
 3dc:	7902                	ld	s2,32(sp)
 3de:	69e2                	ld	s3,24(sp)
 3e0:	6121                	addi	sp,sp,64
 3e2:	8082                	ret
    x = -xx;
 3e4:	40b005bb          	negw	a1,a1
    neg = 1;
 3e8:	4885                	li	a7,1
    x = -xx;
 3ea:	bf8d                	j	35c <printint+0x1a>

00000000000003ec <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3ec:	7119                	addi	sp,sp,-128
 3ee:	fc86                	sd	ra,120(sp)
 3f0:	f8a2                	sd	s0,112(sp)
 3f2:	f4a6                	sd	s1,104(sp)
 3f4:	f0ca                	sd	s2,96(sp)
 3f6:	ecce                	sd	s3,88(sp)
 3f8:	e8d2                	sd	s4,80(sp)
 3fa:	e4d6                	sd	s5,72(sp)
 3fc:	e0da                	sd	s6,64(sp)
 3fe:	fc5e                	sd	s7,56(sp)
 400:	f862                	sd	s8,48(sp)
 402:	f466                	sd	s9,40(sp)
 404:	f06a                	sd	s10,32(sp)
 406:	ec6e                	sd	s11,24(sp)
 408:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 40a:	0005c903          	lbu	s2,0(a1)
 40e:	18090f63          	beqz	s2,5ac <vprintf+0x1c0>
 412:	8aaa                	mv	s5,a0
 414:	8b32                	mv	s6,a2
 416:	00158493          	addi	s1,a1,1
  state = 0;
 41a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 41c:	02500a13          	li	s4,37
      if(c == 'd'){
 420:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 424:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 428:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 42c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 430:	00000b97          	auipc	s7,0x0
 434:	390b8b93          	addi	s7,s7,912 # 7c0 <digits>
 438:	a839                	j	456 <vprintf+0x6a>
        putc(fd, c);
 43a:	85ca                	mv	a1,s2
 43c:	8556                	mv	a0,s5
 43e:	00000097          	auipc	ra,0x0
 442:	ee2080e7          	jalr	-286(ra) # 320 <putc>
 446:	a019                	j	44c <vprintf+0x60>
    } else if(state == '%'){
 448:	01498f63          	beq	s3,s4,466 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 44c:	0485                	addi	s1,s1,1
 44e:	fff4c903          	lbu	s2,-1(s1)
 452:	14090d63          	beqz	s2,5ac <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 456:	0009079b          	sext.w	a5,s2
    if(state == 0){
 45a:	fe0997e3          	bnez	s3,448 <vprintf+0x5c>
      if(c == '%'){
 45e:	fd479ee3          	bne	a5,s4,43a <vprintf+0x4e>
        state = '%';
 462:	89be                	mv	s3,a5
 464:	b7e5                	j	44c <vprintf+0x60>
      if(c == 'd'){
 466:	05878063          	beq	a5,s8,4a6 <vprintf+0xba>
      } else if(c == 'l') {
 46a:	05978c63          	beq	a5,s9,4c2 <vprintf+0xd6>
      } else if(c == 'x') {
 46e:	07a78863          	beq	a5,s10,4de <vprintf+0xf2>
      } else if(c == 'p') {
 472:	09b78463          	beq	a5,s11,4fa <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 476:	07300713          	li	a4,115
 47a:	0ce78663          	beq	a5,a4,546 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 47e:	06300713          	li	a4,99
 482:	0ee78e63          	beq	a5,a4,57e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 486:	11478863          	beq	a5,s4,596 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 48a:	85d2                	mv	a1,s4
 48c:	8556                	mv	a0,s5
 48e:	00000097          	auipc	ra,0x0
 492:	e92080e7          	jalr	-366(ra) # 320 <putc>
        putc(fd, c);
 496:	85ca                	mv	a1,s2
 498:	8556                	mv	a0,s5
 49a:	00000097          	auipc	ra,0x0
 49e:	e86080e7          	jalr	-378(ra) # 320 <putc>
      }
      state = 0;
 4a2:	4981                	li	s3,0
 4a4:	b765                	j	44c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4a6:	008b0913          	addi	s2,s6,8
 4aa:	4685                	li	a3,1
 4ac:	4629                	li	a2,10
 4ae:	000b2583          	lw	a1,0(s6)
 4b2:	8556                	mv	a0,s5
 4b4:	00000097          	auipc	ra,0x0
 4b8:	e8e080e7          	jalr	-370(ra) # 342 <printint>
 4bc:	8b4a                	mv	s6,s2
      state = 0;
 4be:	4981                	li	s3,0
 4c0:	b771                	j	44c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4c2:	008b0913          	addi	s2,s6,8
 4c6:	4681                	li	a3,0
 4c8:	4629                	li	a2,10
 4ca:	000b2583          	lw	a1,0(s6)
 4ce:	8556                	mv	a0,s5
 4d0:	00000097          	auipc	ra,0x0
 4d4:	e72080e7          	jalr	-398(ra) # 342 <printint>
 4d8:	8b4a                	mv	s6,s2
      state = 0;
 4da:	4981                	li	s3,0
 4dc:	bf85                	j	44c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4de:	008b0913          	addi	s2,s6,8
 4e2:	4681                	li	a3,0
 4e4:	4641                	li	a2,16
 4e6:	000b2583          	lw	a1,0(s6)
 4ea:	8556                	mv	a0,s5
 4ec:	00000097          	auipc	ra,0x0
 4f0:	e56080e7          	jalr	-426(ra) # 342 <printint>
 4f4:	8b4a                	mv	s6,s2
      state = 0;
 4f6:	4981                	li	s3,0
 4f8:	bf91                	j	44c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4fa:	008b0793          	addi	a5,s6,8
 4fe:	f8f43423          	sd	a5,-120(s0)
 502:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 506:	03000593          	li	a1,48
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	e14080e7          	jalr	-492(ra) # 320 <putc>
  putc(fd, 'x');
 514:	85ea                	mv	a1,s10
 516:	8556                	mv	a0,s5
 518:	00000097          	auipc	ra,0x0
 51c:	e08080e7          	jalr	-504(ra) # 320 <putc>
 520:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 522:	03c9d793          	srli	a5,s3,0x3c
 526:	97de                	add	a5,a5,s7
 528:	0007c583          	lbu	a1,0(a5)
 52c:	8556                	mv	a0,s5
 52e:	00000097          	auipc	ra,0x0
 532:	df2080e7          	jalr	-526(ra) # 320 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 536:	0992                	slli	s3,s3,0x4
 538:	397d                	addiw	s2,s2,-1
 53a:	fe0914e3          	bnez	s2,522 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 53e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 542:	4981                	li	s3,0
 544:	b721                	j	44c <vprintf+0x60>
        s = va_arg(ap, char*);
 546:	008b0993          	addi	s3,s6,8
 54a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 54e:	02090163          	beqz	s2,570 <vprintf+0x184>
        while(*s != 0){
 552:	00094583          	lbu	a1,0(s2)
 556:	c9a1                	beqz	a1,5a6 <vprintf+0x1ba>
          putc(fd, *s);
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	dc6080e7          	jalr	-570(ra) # 320 <putc>
          s++;
 562:	0905                	addi	s2,s2,1
        while(*s != 0){
 564:	00094583          	lbu	a1,0(s2)
 568:	f9e5                	bnez	a1,558 <vprintf+0x16c>
        s = va_arg(ap, char*);
 56a:	8b4e                	mv	s6,s3
      state = 0;
 56c:	4981                	li	s3,0
 56e:	bdf9                	j	44c <vprintf+0x60>
          s = "(null)";
 570:	00000917          	auipc	s2,0x0
 574:	24890913          	addi	s2,s2,584 # 7b8 <malloc+0x102>
        while(*s != 0){
 578:	02800593          	li	a1,40
 57c:	bff1                	j	558 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 57e:	008b0913          	addi	s2,s6,8
 582:	000b4583          	lbu	a1,0(s6)
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	d98080e7          	jalr	-616(ra) # 320 <putc>
 590:	8b4a                	mv	s6,s2
      state = 0;
 592:	4981                	li	s3,0
 594:	bd65                	j	44c <vprintf+0x60>
        putc(fd, c);
 596:	85d2                	mv	a1,s4
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	d86080e7          	jalr	-634(ra) # 320 <putc>
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	b565                	j	44c <vprintf+0x60>
        s = va_arg(ap, char*);
 5a6:	8b4e                	mv	s6,s3
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	b54d                	j	44c <vprintf+0x60>
    }
  }
}
 5ac:	70e6                	ld	ra,120(sp)
 5ae:	7446                	ld	s0,112(sp)
 5b0:	74a6                	ld	s1,104(sp)
 5b2:	7906                	ld	s2,96(sp)
 5b4:	69e6                	ld	s3,88(sp)
 5b6:	6a46                	ld	s4,80(sp)
 5b8:	6aa6                	ld	s5,72(sp)
 5ba:	6b06                	ld	s6,64(sp)
 5bc:	7be2                	ld	s7,56(sp)
 5be:	7c42                	ld	s8,48(sp)
 5c0:	7ca2                	ld	s9,40(sp)
 5c2:	7d02                	ld	s10,32(sp)
 5c4:	6de2                	ld	s11,24(sp)
 5c6:	6109                	addi	sp,sp,128
 5c8:	8082                	ret

00000000000005ca <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5ca:	715d                	addi	sp,sp,-80
 5cc:	ec06                	sd	ra,24(sp)
 5ce:	e822                	sd	s0,16(sp)
 5d0:	1000                	addi	s0,sp,32
 5d2:	e010                	sd	a2,0(s0)
 5d4:	e414                	sd	a3,8(s0)
 5d6:	e818                	sd	a4,16(s0)
 5d8:	ec1c                	sd	a5,24(s0)
 5da:	03043023          	sd	a6,32(s0)
 5de:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5e2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5e6:	8622                	mv	a2,s0
 5e8:	00000097          	auipc	ra,0x0
 5ec:	e04080e7          	jalr	-508(ra) # 3ec <vprintf>
}
 5f0:	60e2                	ld	ra,24(sp)
 5f2:	6442                	ld	s0,16(sp)
 5f4:	6161                	addi	sp,sp,80
 5f6:	8082                	ret

00000000000005f8 <printf>:

void
printf(const char *fmt, ...)
{
 5f8:	711d                	addi	sp,sp,-96
 5fa:	ec06                	sd	ra,24(sp)
 5fc:	e822                	sd	s0,16(sp)
 5fe:	1000                	addi	s0,sp,32
 600:	e40c                	sd	a1,8(s0)
 602:	e810                	sd	a2,16(s0)
 604:	ec14                	sd	a3,24(s0)
 606:	f018                	sd	a4,32(s0)
 608:	f41c                	sd	a5,40(s0)
 60a:	03043823          	sd	a6,48(s0)
 60e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 612:	00840613          	addi	a2,s0,8
 616:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 61a:	85aa                	mv	a1,a0
 61c:	4505                	li	a0,1
 61e:	00000097          	auipc	ra,0x0
 622:	dce080e7          	jalr	-562(ra) # 3ec <vprintf>
}
 626:	60e2                	ld	ra,24(sp)
 628:	6442                	ld	s0,16(sp)
 62a:	6125                	addi	sp,sp,96
 62c:	8082                	ret

000000000000062e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 62e:	1141                	addi	sp,sp,-16
 630:	e422                	sd	s0,8(sp)
 632:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 634:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 638:	00000797          	auipc	a5,0x0
 63c:	1a07b783          	ld	a5,416(a5) # 7d8 <freep>
 640:	a805                	j	670 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 642:	4618                	lw	a4,8(a2)
 644:	9db9                	addw	a1,a1,a4
 646:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 64a:	6398                	ld	a4,0(a5)
 64c:	6318                	ld	a4,0(a4)
 64e:	fee53823          	sd	a4,-16(a0)
 652:	a091                	j	696 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 654:	ff852703          	lw	a4,-8(a0)
 658:	9e39                	addw	a2,a2,a4
 65a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 65c:	ff053703          	ld	a4,-16(a0)
 660:	e398                	sd	a4,0(a5)
 662:	a099                	j	6a8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 664:	6398                	ld	a4,0(a5)
 666:	00e7e463          	bltu	a5,a4,66e <free+0x40>
 66a:	00e6ea63          	bltu	a3,a4,67e <free+0x50>
{
 66e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 670:	fed7fae3          	bgeu	a5,a3,664 <free+0x36>
 674:	6398                	ld	a4,0(a5)
 676:	00e6e463          	bltu	a3,a4,67e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67a:	fee7eae3          	bltu	a5,a4,66e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 67e:	ff852583          	lw	a1,-8(a0)
 682:	6390                	ld	a2,0(a5)
 684:	02059713          	slli	a4,a1,0x20
 688:	9301                	srli	a4,a4,0x20
 68a:	0712                	slli	a4,a4,0x4
 68c:	9736                	add	a4,a4,a3
 68e:	fae60ae3          	beq	a2,a4,642 <free+0x14>
    bp->s.ptr = p->s.ptr;
 692:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 696:	4790                	lw	a2,8(a5)
 698:	02061713          	slli	a4,a2,0x20
 69c:	9301                	srli	a4,a4,0x20
 69e:	0712                	slli	a4,a4,0x4
 6a0:	973e                	add	a4,a4,a5
 6a2:	fae689e3          	beq	a3,a4,654 <free+0x26>
  } else
    p->s.ptr = bp;
 6a6:	e394                	sd	a3,0(a5)
  freep = p;
 6a8:	00000717          	auipc	a4,0x0
 6ac:	12f73823          	sd	a5,304(a4) # 7d8 <freep>
}
 6b0:	6422                	ld	s0,8(sp)
 6b2:	0141                	addi	sp,sp,16
 6b4:	8082                	ret

00000000000006b6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6b6:	7139                	addi	sp,sp,-64
 6b8:	fc06                	sd	ra,56(sp)
 6ba:	f822                	sd	s0,48(sp)
 6bc:	f426                	sd	s1,40(sp)
 6be:	f04a                	sd	s2,32(sp)
 6c0:	ec4e                	sd	s3,24(sp)
 6c2:	e852                	sd	s4,16(sp)
 6c4:	e456                	sd	s5,8(sp)
 6c6:	e05a                	sd	s6,0(sp)
 6c8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ca:	02051493          	slli	s1,a0,0x20
 6ce:	9081                	srli	s1,s1,0x20
 6d0:	04bd                	addi	s1,s1,15
 6d2:	8091                	srli	s1,s1,0x4
 6d4:	0014899b          	addiw	s3,s1,1
 6d8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6da:	00000517          	auipc	a0,0x0
 6de:	0fe53503          	ld	a0,254(a0) # 7d8 <freep>
 6e2:	c515                	beqz	a0,70e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6e6:	4798                	lw	a4,8(a5)
 6e8:	02977f63          	bgeu	a4,s1,726 <malloc+0x70>
 6ec:	8a4e                	mv	s4,s3
 6ee:	0009871b          	sext.w	a4,s3
 6f2:	6685                	lui	a3,0x1
 6f4:	00d77363          	bgeu	a4,a3,6fa <malloc+0x44>
 6f8:	6a05                	lui	s4,0x1
 6fa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6fe:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 702:	00000917          	auipc	s2,0x0
 706:	0d690913          	addi	s2,s2,214 # 7d8 <freep>
  if(p == (char*)-1)
 70a:	5afd                	li	s5,-1
 70c:	a88d                	j	77e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 70e:	00000797          	auipc	a5,0x0
 712:	0d278793          	addi	a5,a5,210 # 7e0 <base>
 716:	00000717          	auipc	a4,0x0
 71a:	0cf73123          	sd	a5,194(a4) # 7d8 <freep>
 71e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 720:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 724:	b7e1                	j	6ec <malloc+0x36>
      if(p->s.size == nunits)
 726:	02e48b63          	beq	s1,a4,75c <malloc+0xa6>
        p->s.size -= nunits;
 72a:	4137073b          	subw	a4,a4,s3
 72e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 730:	1702                	slli	a4,a4,0x20
 732:	9301                	srli	a4,a4,0x20
 734:	0712                	slli	a4,a4,0x4
 736:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 738:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 73c:	00000717          	auipc	a4,0x0
 740:	08a73e23          	sd	a0,156(a4) # 7d8 <freep>
      return (void*)(p + 1);
 744:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 748:	70e2                	ld	ra,56(sp)
 74a:	7442                	ld	s0,48(sp)
 74c:	74a2                	ld	s1,40(sp)
 74e:	7902                	ld	s2,32(sp)
 750:	69e2                	ld	s3,24(sp)
 752:	6a42                	ld	s4,16(sp)
 754:	6aa2                	ld	s5,8(sp)
 756:	6b02                	ld	s6,0(sp)
 758:	6121                	addi	sp,sp,64
 75a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 75c:	6398                	ld	a4,0(a5)
 75e:	e118                	sd	a4,0(a0)
 760:	bff1                	j	73c <malloc+0x86>
  hp->s.size = nu;
 762:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 766:	0541                	addi	a0,a0,16
 768:	00000097          	auipc	ra,0x0
 76c:	ec6080e7          	jalr	-314(ra) # 62e <free>
  return freep;
 770:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 774:	d971                	beqz	a0,748 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 776:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 778:	4798                	lw	a4,8(a5)
 77a:	fa9776e3          	bgeu	a4,s1,726 <malloc+0x70>
    if(p == freep)
 77e:	00093703          	ld	a4,0(s2)
 782:	853e                	mv	a0,a5
 784:	fef719e3          	bne	a4,a5,776 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 788:	8552                	mv	a0,s4
 78a:	00000097          	auipc	ra,0x0
 78e:	b66080e7          	jalr	-1178(ra) # 2f0 <sbrk>
  if(p == (char*)-1)
 792:	fd5518e3          	bne	a0,s5,762 <malloc+0xac>
        return 0;
 796:	4501                	li	a0,0
 798:	bf45                	j	748 <malloc+0x92>
