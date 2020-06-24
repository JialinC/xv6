
user/_alloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
#include "kernel/fcntl.h"
#include "kernel/memlayout.h"
#include "user/user.h"

void
test0() {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	1800                	addi	s0,sp,48
  enum { NCHILD = 50, NFD = 10};
  int i, j;
  int fd;

  printf("filetest: start\n");
   c:	00001517          	auipc	a0,0x1
  10:	96c50513          	addi	a0,a0,-1684 # 978 <malloc+0xea>
  14:	00000097          	auipc	ra,0x0
  18:	7bc080e7          	jalr	1980(ra) # 7d0 <printf>
  1c:	03200493          	li	s1,50
    printf("test setup is wrong\n");
    exit(-1);
  }

  for (i = 0; i < NCHILD; i++) {
    int pid = fork();
  20:	00000097          	auipc	ra,0x0
  24:	410080e7          	jalr	1040(ra) # 430 <fork>
    if(pid < 0){
  28:	04054263          	bltz	a0,6c <test0+0x6c>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
  2c:	cd29                	beqz	a0,86 <test0+0x86>
  for (i = 0; i < NCHILD; i++) {
  2e:	34fd                	addiw	s1,s1,-1
  30:	f8e5                	bnez	s1,20 <test0+0x20>
  32:	03200493          	li	s1,50
  }

  int xstatus;
  for(int i = 0; i < NCHILD; i++){
    wait(&xstatus);
    if(xstatus == -1) {
  36:	597d                	li	s2,-1
    wait(&xstatus);
  38:	fdc40513          	addi	a0,s0,-36
  3c:	00000097          	auipc	ra,0x0
  40:	404080e7          	jalr	1028(ra) # 440 <wait>
    if(xstatus == -1) {
  44:	fdc42783          	lw	a5,-36(s0)
  48:	07278d63          	beq	a5,s2,c2 <test0+0xc2>
  for(int i = 0; i < NCHILD; i++){
  4c:	34fd                	addiw	s1,s1,-1
  4e:	f4ed                	bnez	s1,38 <test0+0x38>
       printf("filetest: FAILED\n");
       exit(-1);
    }
  }

   printf("filetest: OK\n");
  50:	00001517          	auipc	a0,0x1
  54:	97050513          	addi	a0,a0,-1680 # 9c0 <malloc+0x132>
  58:	00000097          	auipc	ra,0x0
  5c:	778080e7          	jalr	1912(ra) # 7d0 <printf>
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	6145                	addi	sp,sp,48
  6a:	8082                	ret
      printf("fork failed");
  6c:	00001517          	auipc	a0,0x1
  70:	92450513          	addi	a0,a0,-1756 # 990 <malloc+0x102>
  74:	00000097          	auipc	ra,0x0
  78:	75c080e7          	jalr	1884(ra) # 7d0 <printf>
      exit(-1);
  7c:	557d                	li	a0,-1
  7e:	00000097          	auipc	ra,0x0
  82:	3ba080e7          	jalr	954(ra) # 438 <exit>
  86:	44a9                	li	s1,10
        if ((fd = open("README", O_RDONLY)) < 0) {
  88:	00001917          	auipc	s2,0x1
  8c:	91890913          	addi	s2,s2,-1768 # 9a0 <malloc+0x112>
  90:	4581                	li	a1,0
  92:	854a                	mv	a0,s2
  94:	00000097          	auipc	ra,0x0
  98:	3e4080e7          	jalr	996(ra) # 478 <open>
  9c:	00054e63          	bltz	a0,b8 <test0+0xb8>
      for(j = 0; j < NFD; j++) {
  a0:	34fd                	addiw	s1,s1,-1
  a2:	f4fd                	bnez	s1,90 <test0+0x90>
      sleep(10);
  a4:	4529                	li	a0,10
  a6:	00000097          	auipc	ra,0x0
  aa:	422080e7          	jalr	1058(ra) # 4c8 <sleep>
      exit(0);  // no errors; exit with 0.
  ae:	4501                	li	a0,0
  b0:	00000097          	auipc	ra,0x0
  b4:	388080e7          	jalr	904(ra) # 438 <exit>
          exit(-1);
  b8:	557d                	li	a0,-1
  ba:	00000097          	auipc	ra,0x0
  be:	37e080e7          	jalr	894(ra) # 438 <exit>
       printf("filetest: FAILED\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	8e650513          	addi	a0,a0,-1818 # 9a8 <malloc+0x11a>
  ca:	00000097          	auipc	ra,0x0
  ce:	706080e7          	jalr	1798(ra) # 7d0 <printf>
       exit(-1);
  d2:	557d                	li	a0,-1
  d4:	00000097          	auipc	ra,0x0
  d8:	364080e7          	jalr	868(ra) # 438 <exit>

00000000000000dc <test1>:

// Allocate all free memory and count how it is
void test1()
{
  dc:	7139                	addi	sp,sp,-64
  de:	fc06                	sd	ra,56(sp)
  e0:	f822                	sd	s0,48(sp)
  e2:	f426                	sd	s1,40(sp)
  e4:	f04a                	sd	s2,32(sp)
  e6:	ec4e                	sd	s3,24(sp)
  e8:	0080                	addi	s0,sp,64
  void *a;
  int tot = 0;
  char buf[1];
  int fds[2];
  
  printf("memtest: start\n");  
  ea:	00001517          	auipc	a0,0x1
  ee:	8e650513          	addi	a0,a0,-1818 # 9d0 <malloc+0x142>
  f2:	00000097          	auipc	ra,0x0
  f6:	6de080e7          	jalr	1758(ra) # 7d0 <printf>
  if(pipe(fds) != 0){
  fa:	fc040513          	addi	a0,s0,-64
  fe:	00000097          	auipc	ra,0x0
 102:	34a080e7          	jalr	842(ra) # 448 <pipe>
 106:	e525                	bnez	a0,16e <test1+0x92>
 108:	84aa                	mv	s1,a0
    printf("pipe() failed\n");
    exit(-1);
  }
  int pid = fork();
 10a:	00000097          	auipc	ra,0x0
 10e:	326080e7          	jalr	806(ra) # 430 <fork>
  if(pid < 0){
 112:	06054b63          	bltz	a0,188 <test1+0xac>
    printf("fork failed");
    exit(-1);
  }
  if(pid == 0){
 116:	e959                	bnez	a0,1ac <test1+0xd0>
      close(fds[0]);
 118:	fc042503          	lw	a0,-64(s0)
 11c:	00000097          	auipc	ra,0x0
 120:	344080e7          	jalr	836(ra) # 460 <close>
      while(1) {
        a = sbrk(PGSIZE);
        if (a == (char*)0xffffffffffffffffL)
 124:	597d                	li	s2,-1
          exit(0);
        *(int *)(a+4) = 1;
 126:	4485                	li	s1,1
        if (write(fds[1], "x", 1) != 1) {
 128:	00001997          	auipc	s3,0x1
 12c:	8c898993          	addi	s3,s3,-1848 # 9f0 <malloc+0x162>
        a = sbrk(PGSIZE);
 130:	6505                	lui	a0,0x1
 132:	00000097          	auipc	ra,0x0
 136:	38e080e7          	jalr	910(ra) # 4c0 <sbrk>
        if (a == (char*)0xffffffffffffffffL)
 13a:	07250463          	beq	a0,s2,1a2 <test1+0xc6>
        *(int *)(a+4) = 1;
 13e:	c144                	sw	s1,4(a0)
        if (write(fds[1], "x", 1) != 1) {
 140:	8626                	mv	a2,s1
 142:	85ce                	mv	a1,s3
 144:	fc442503          	lw	a0,-60(s0)
 148:	00000097          	auipc	ra,0x0
 14c:	310080e7          	jalr	784(ra) # 458 <write>
 150:	fe9500e3          	beq	a0,s1,130 <test1+0x54>
          printf("write failed");
 154:	00001517          	auipc	a0,0x1
 158:	8a450513          	addi	a0,a0,-1884 # 9f8 <malloc+0x16a>
 15c:	00000097          	auipc	ra,0x0
 160:	674080e7          	jalr	1652(ra) # 7d0 <printf>
          exit(-1);
 164:	557d                	li	a0,-1
 166:	00000097          	auipc	ra,0x0
 16a:	2d2080e7          	jalr	722(ra) # 438 <exit>
    printf("pipe() failed\n");
 16e:	00001517          	auipc	a0,0x1
 172:	87250513          	addi	a0,a0,-1934 # 9e0 <malloc+0x152>
 176:	00000097          	auipc	ra,0x0
 17a:	65a080e7          	jalr	1626(ra) # 7d0 <printf>
    exit(-1);
 17e:	557d                	li	a0,-1
 180:	00000097          	auipc	ra,0x0
 184:	2b8080e7          	jalr	696(ra) # 438 <exit>
    printf("fork failed");
 188:	00001517          	auipc	a0,0x1
 18c:	80850513          	addi	a0,a0,-2040 # 990 <malloc+0x102>
 190:	00000097          	auipc	ra,0x0
 194:	640080e7          	jalr	1600(ra) # 7d0 <printf>
    exit(-1);
 198:	557d                	li	a0,-1
 19a:	00000097          	auipc	ra,0x0
 19e:	29e080e7          	jalr	670(ra) # 438 <exit>
          exit(0);
 1a2:	4501                	li	a0,0
 1a4:	00000097          	auipc	ra,0x0
 1a8:	294080e7          	jalr	660(ra) # 438 <exit>
        }
      }
      exit(0);
  }
  close(fds[1]);
 1ac:	fc442503          	lw	a0,-60(s0)
 1b0:	00000097          	auipc	ra,0x0
 1b4:	2b0080e7          	jalr	688(ra) # 460 <close>
  while(1) {
      if (read(fds[0], buf, 1) != 1) {
 1b8:	4605                	li	a2,1
 1ba:	fc840593          	addi	a1,s0,-56
 1be:	fc042503          	lw	a0,-64(s0)
 1c2:	00000097          	auipc	ra,0x0
 1c6:	28e080e7          	jalr	654(ra) # 450 <read>
 1ca:	4785                	li	a5,1
 1cc:	00f51463          	bne	a0,a5,1d4 <test1+0xf8>
        break;
      } else {
        tot += 1;
 1d0:	2485                	addiw	s1,s1,1
      if (read(fds[0], buf, 1) != 1) {
 1d2:	b7dd                	j	1b8 <test1+0xdc>
      }
  }
  //int n = (PHYSTOP-KERNBASE)/PGSIZE;
  //printf("allocated %d out of %d pages\n", tot, n);
  if(tot < 31950) {
 1d4:	67a1                	lui	a5,0x8
 1d6:	ccd78793          	addi	a5,a5,-819 # 7ccd <__global_pointer$+0x6a4c>
 1da:	0297ca63          	blt	a5,s1,20e <test1+0x132>
    printf("expected to allocate at least 31950, only got %d\n", tot);
 1de:	85a6                	mv	a1,s1
 1e0:	00001517          	auipc	a0,0x1
 1e4:	82850513          	addi	a0,a0,-2008 # a08 <malloc+0x17a>
 1e8:	00000097          	auipc	ra,0x0
 1ec:	5e8080e7          	jalr	1512(ra) # 7d0 <printf>
    printf("memtest: FAILED\n");  
 1f0:	00001517          	auipc	a0,0x1
 1f4:	85050513          	addi	a0,a0,-1968 # a40 <malloc+0x1b2>
 1f8:	00000097          	auipc	ra,0x0
 1fc:	5d8080e7          	jalr	1496(ra) # 7d0 <printf>
  } else {
    printf("memtest: OK\n");  
  }
}
 200:	70e2                	ld	ra,56(sp)
 202:	7442                	ld	s0,48(sp)
 204:	74a2                	ld	s1,40(sp)
 206:	7902                	ld	s2,32(sp)
 208:	69e2                	ld	s3,24(sp)
 20a:	6121                	addi	sp,sp,64
 20c:	8082                	ret
    printf("memtest: OK\n");  
 20e:	00001517          	auipc	a0,0x1
 212:	84a50513          	addi	a0,a0,-1974 # a58 <malloc+0x1ca>
 216:	00000097          	auipc	ra,0x0
 21a:	5ba080e7          	jalr	1466(ra) # 7d0 <printf>
}
 21e:	b7cd                	j	200 <test1+0x124>

0000000000000220 <main>:

int
main(int argc, char *argv[])
{
 220:	1141                	addi	sp,sp,-16
 222:	e406                	sd	ra,8(sp)
 224:	e022                	sd	s0,0(sp)
 226:	0800                	addi	s0,sp,16
  test0();
 228:	00000097          	auipc	ra,0x0
 22c:	dd8080e7          	jalr	-552(ra) # 0 <test0>
  test1();
 230:	00000097          	auipc	ra,0x0
 234:	eac080e7          	jalr	-340(ra) # dc <test1>
  exit(0);
 238:	4501                	li	a0,0
 23a:	00000097          	auipc	ra,0x0
 23e:	1fe080e7          	jalr	510(ra) # 438 <exit>

0000000000000242 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 248:	87aa                	mv	a5,a0
 24a:	0585                	addi	a1,a1,1
 24c:	0785                	addi	a5,a5,1
 24e:	fff5c703          	lbu	a4,-1(a1)
 252:	fee78fa3          	sb	a4,-1(a5)
 256:	fb75                	bnez	a4,24a <strcpy+0x8>
    ;
  return os;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret

000000000000025e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 264:	00054783          	lbu	a5,0(a0)
 268:	cb91                	beqz	a5,27c <strcmp+0x1e>
 26a:	0005c703          	lbu	a4,0(a1)
 26e:	00f71763          	bne	a4,a5,27c <strcmp+0x1e>
    p++, q++;
 272:	0505                	addi	a0,a0,1
 274:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 276:	00054783          	lbu	a5,0(a0)
 27a:	fbe5                	bnez	a5,26a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 27c:	0005c503          	lbu	a0,0(a1)
}
 280:	40a7853b          	subw	a0,a5,a0
 284:	6422                	ld	s0,8(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret

000000000000028a <strlen>:

uint
strlen(const char *s)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e422                	sd	s0,8(sp)
 28e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 290:	00054783          	lbu	a5,0(a0)
 294:	cf91                	beqz	a5,2b0 <strlen+0x26>
 296:	0505                	addi	a0,a0,1
 298:	87aa                	mv	a5,a0
 29a:	4685                	li	a3,1
 29c:	9e89                	subw	a3,a3,a0
 29e:	00f6853b          	addw	a0,a3,a5
 2a2:	0785                	addi	a5,a5,1
 2a4:	fff7c703          	lbu	a4,-1(a5)
 2a8:	fb7d                	bnez	a4,29e <strlen+0x14>
    ;
  return n;
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  for(n = 0; s[n]; n++)
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <strlen+0x20>

00000000000002b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ba:	ce09                	beqz	a2,2d4 <memset+0x20>
 2bc:	87aa                	mv	a5,a0
 2be:	fff6071b          	addiw	a4,a2,-1
 2c2:	1702                	slli	a4,a4,0x20
 2c4:	9301                	srli	a4,a4,0x20
 2c6:	0705                	addi	a4,a4,1
 2c8:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2ca:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2ce:	0785                	addi	a5,a5,1
 2d0:	fee79de3          	bne	a5,a4,2ca <memset+0x16>
  }
  return dst;
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret

00000000000002da <strchr>:

char*
strchr(const char *s, char c)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2e0:	00054783          	lbu	a5,0(a0)
 2e4:	cb99                	beqz	a5,2fa <strchr+0x20>
    if(*s == c)
 2e6:	00f58763          	beq	a1,a5,2f4 <strchr+0x1a>
  for(; *s; s++)
 2ea:	0505                	addi	a0,a0,1
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	fbfd                	bnez	a5,2e6 <strchr+0xc>
      return (char*)s;
  return 0;
 2f2:	4501                	li	a0,0
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret
  return 0;
 2fa:	4501                	li	a0,0
 2fc:	bfe5                	j	2f4 <strchr+0x1a>

00000000000002fe <gets>:

char*
gets(char *buf, int max)
{
 2fe:	711d                	addi	sp,sp,-96
 300:	ec86                	sd	ra,88(sp)
 302:	e8a2                	sd	s0,80(sp)
 304:	e4a6                	sd	s1,72(sp)
 306:	e0ca                	sd	s2,64(sp)
 308:	fc4e                	sd	s3,56(sp)
 30a:	f852                	sd	s4,48(sp)
 30c:	f456                	sd	s5,40(sp)
 30e:	f05a                	sd	s6,32(sp)
 310:	ec5e                	sd	s7,24(sp)
 312:	1080                	addi	s0,sp,96
 314:	8baa                	mv	s7,a0
 316:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 318:	892a                	mv	s2,a0
 31a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 31c:	4aa9                	li	s5,10
 31e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 320:	89a6                	mv	s3,s1
 322:	2485                	addiw	s1,s1,1
 324:	0344d863          	bge	s1,s4,354 <gets+0x56>
    cc = read(0, &c, 1);
 328:	4605                	li	a2,1
 32a:	faf40593          	addi	a1,s0,-81
 32e:	4501                	li	a0,0
 330:	00000097          	auipc	ra,0x0
 334:	120080e7          	jalr	288(ra) # 450 <read>
    if(cc < 1)
 338:	00a05e63          	blez	a0,354 <gets+0x56>
    buf[i++] = c;
 33c:	faf44783          	lbu	a5,-81(s0)
 340:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 344:	01578763          	beq	a5,s5,352 <gets+0x54>
 348:	0905                	addi	s2,s2,1
 34a:	fd679be3          	bne	a5,s6,320 <gets+0x22>
  for(i=0; i+1 < max; ){
 34e:	89a6                	mv	s3,s1
 350:	a011                	j	354 <gets+0x56>
 352:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 354:	99de                	add	s3,s3,s7
 356:	00098023          	sb	zero,0(s3)
  return buf;
}
 35a:	855e                	mv	a0,s7
 35c:	60e6                	ld	ra,88(sp)
 35e:	6446                	ld	s0,80(sp)
 360:	64a6                	ld	s1,72(sp)
 362:	6906                	ld	s2,64(sp)
 364:	79e2                	ld	s3,56(sp)
 366:	7a42                	ld	s4,48(sp)
 368:	7aa2                	ld	s5,40(sp)
 36a:	7b02                	ld	s6,32(sp)
 36c:	6be2                	ld	s7,24(sp)
 36e:	6125                	addi	sp,sp,96
 370:	8082                	ret

0000000000000372 <stat>:

int
stat(const char *n, struct stat *st)
{
 372:	1101                	addi	sp,sp,-32
 374:	ec06                	sd	ra,24(sp)
 376:	e822                	sd	s0,16(sp)
 378:	e426                	sd	s1,8(sp)
 37a:	e04a                	sd	s2,0(sp)
 37c:	1000                	addi	s0,sp,32
 37e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 380:	4581                	li	a1,0
 382:	00000097          	auipc	ra,0x0
 386:	0f6080e7          	jalr	246(ra) # 478 <open>
  if(fd < 0)
 38a:	02054563          	bltz	a0,3b4 <stat+0x42>
 38e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 390:	85ca                	mv	a1,s2
 392:	00000097          	auipc	ra,0x0
 396:	0fe080e7          	jalr	254(ra) # 490 <fstat>
 39a:	892a                	mv	s2,a0
  close(fd);
 39c:	8526                	mv	a0,s1
 39e:	00000097          	auipc	ra,0x0
 3a2:	0c2080e7          	jalr	194(ra) # 460 <close>
  return r;
}
 3a6:	854a                	mv	a0,s2
 3a8:	60e2                	ld	ra,24(sp)
 3aa:	6442                	ld	s0,16(sp)
 3ac:	64a2                	ld	s1,8(sp)
 3ae:	6902                	ld	s2,0(sp)
 3b0:	6105                	addi	sp,sp,32
 3b2:	8082                	ret
    return -1;
 3b4:	597d                	li	s2,-1
 3b6:	bfc5                	j	3a6 <stat+0x34>

00000000000003b8 <atoi>:

int
atoi(const char *s)
{
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e422                	sd	s0,8(sp)
 3bc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3be:	00054603          	lbu	a2,0(a0)
 3c2:	fd06079b          	addiw	a5,a2,-48
 3c6:	0ff7f793          	andi	a5,a5,255
 3ca:	4725                	li	a4,9
 3cc:	02f76963          	bltu	a4,a5,3fe <atoi+0x46>
 3d0:	86aa                	mv	a3,a0
  n = 0;
 3d2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3d4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3d6:	0685                	addi	a3,a3,1
 3d8:	0025179b          	slliw	a5,a0,0x2
 3dc:	9fa9                	addw	a5,a5,a0
 3de:	0017979b          	slliw	a5,a5,0x1
 3e2:	9fb1                	addw	a5,a5,a2
 3e4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3e8:	0006c603          	lbu	a2,0(a3)
 3ec:	fd06071b          	addiw	a4,a2,-48
 3f0:	0ff77713          	andi	a4,a4,255
 3f4:	fee5f1e3          	bgeu	a1,a4,3d6 <atoi+0x1e>
  return n;
}
 3f8:	6422                	ld	s0,8(sp)
 3fa:	0141                	addi	sp,sp,16
 3fc:	8082                	ret
  n = 0;
 3fe:	4501                	li	a0,0
 400:	bfe5                	j	3f8 <atoi+0x40>

0000000000000402 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 402:	1141                	addi	sp,sp,-16
 404:	e422                	sd	s0,8(sp)
 406:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 408:	02c05163          	blez	a2,42a <memmove+0x28>
 40c:	fff6071b          	addiw	a4,a2,-1
 410:	1702                	slli	a4,a4,0x20
 412:	9301                	srli	a4,a4,0x20
 414:	0705                	addi	a4,a4,1
 416:	972a                	add	a4,a4,a0
  dst = vdst;
 418:	87aa                	mv	a5,a0
    *dst++ = *src++;
 41a:	0585                	addi	a1,a1,1
 41c:	0785                	addi	a5,a5,1
 41e:	fff5c683          	lbu	a3,-1(a1)
 422:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 426:	fee79ae3          	bne	a5,a4,41a <memmove+0x18>
  return vdst;
}
 42a:	6422                	ld	s0,8(sp)
 42c:	0141                	addi	sp,sp,16
 42e:	8082                	ret

0000000000000430 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 430:	4885                	li	a7,1
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <exit>:
.global exit
exit:
 li a7, SYS_exit
 438:	4889                	li	a7,2
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <wait>:
.global wait
wait:
 li a7, SYS_wait
 440:	488d                	li	a7,3
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 448:	4891                	li	a7,4
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <read>:
.global read
read:
 li a7, SYS_read
 450:	4895                	li	a7,5
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <write>:
.global write
write:
 li a7, SYS_write
 458:	48c1                	li	a7,16
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <close>:
.global close
close:
 li a7, SYS_close
 460:	48d5                	li	a7,21
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <kill>:
.global kill
kill:
 li a7, SYS_kill
 468:	4899                	li	a7,6
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <exec>:
.global exec
exec:
 li a7, SYS_exec
 470:	489d                	li	a7,7
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <open>:
.global open
open:
 li a7, SYS_open
 478:	48bd                	li	a7,15
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 480:	48c5                	li	a7,17
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 488:	48c9                	li	a7,18
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 490:	48a1                	li	a7,8
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <link>:
.global link
link:
 li a7, SYS_link
 498:	48cd                	li	a7,19
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4a0:	48d1                	li	a7,20
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4a8:	48a5                	li	a7,9
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4b0:	48a9                	li	a7,10
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4b8:	48ad                	li	a7,11
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4c0:	48b1                	li	a7,12
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4c8:	48b5                	li	a7,13
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4d0:	48b9                	li	a7,14
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 4d8:	48d9                	li	a7,22
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <crash>:
.global crash
crash:
 li a7, SYS_crash
 4e0:	48dd                	li	a7,23
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <mount>:
.global mount
mount:
 li a7, SYS_mount
 4e8:	48e1                	li	a7,24
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <umount>:
.global umount
umount:
 li a7, SYS_umount
 4f0:	48e5                	li	a7,25
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4f8:	1101                	addi	sp,sp,-32
 4fa:	ec06                	sd	ra,24(sp)
 4fc:	e822                	sd	s0,16(sp)
 4fe:	1000                	addi	s0,sp,32
 500:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 504:	4605                	li	a2,1
 506:	fef40593          	addi	a1,s0,-17
 50a:	00000097          	auipc	ra,0x0
 50e:	f4e080e7          	jalr	-178(ra) # 458 <write>
}
 512:	60e2                	ld	ra,24(sp)
 514:	6442                	ld	s0,16(sp)
 516:	6105                	addi	sp,sp,32
 518:	8082                	ret

000000000000051a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51a:	7139                	addi	sp,sp,-64
 51c:	fc06                	sd	ra,56(sp)
 51e:	f822                	sd	s0,48(sp)
 520:	f426                	sd	s1,40(sp)
 522:	f04a                	sd	s2,32(sp)
 524:	ec4e                	sd	s3,24(sp)
 526:	0080                	addi	s0,sp,64
 528:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 52a:	c299                	beqz	a3,530 <printint+0x16>
 52c:	0805c863          	bltz	a1,5bc <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 530:	2581                	sext.w	a1,a1
  neg = 0;
 532:	4881                	li	a7,0
 534:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 538:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 53a:	2601                	sext.w	a2,a2
 53c:	00000517          	auipc	a0,0x0
 540:	53450513          	addi	a0,a0,1332 # a70 <digits>
 544:	883a                	mv	a6,a4
 546:	2705                	addiw	a4,a4,1
 548:	02c5f7bb          	remuw	a5,a1,a2
 54c:	1782                	slli	a5,a5,0x20
 54e:	9381                	srli	a5,a5,0x20
 550:	97aa                	add	a5,a5,a0
 552:	0007c783          	lbu	a5,0(a5)
 556:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 55a:	0005879b          	sext.w	a5,a1
 55e:	02c5d5bb          	divuw	a1,a1,a2
 562:	0685                	addi	a3,a3,1
 564:	fec7f0e3          	bgeu	a5,a2,544 <printint+0x2a>
  if(neg)
 568:	00088b63          	beqz	a7,57e <printint+0x64>
    buf[i++] = '-';
 56c:	fd040793          	addi	a5,s0,-48
 570:	973e                	add	a4,a4,a5
 572:	02d00793          	li	a5,45
 576:	fef70823          	sb	a5,-16(a4)
 57a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 57e:	02e05863          	blez	a4,5ae <printint+0x94>
 582:	fc040793          	addi	a5,s0,-64
 586:	00e78933          	add	s2,a5,a4
 58a:	fff78993          	addi	s3,a5,-1
 58e:	99ba                	add	s3,s3,a4
 590:	377d                	addiw	a4,a4,-1
 592:	1702                	slli	a4,a4,0x20
 594:	9301                	srli	a4,a4,0x20
 596:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 59a:	fff94583          	lbu	a1,-1(s2)
 59e:	8526                	mv	a0,s1
 5a0:	00000097          	auipc	ra,0x0
 5a4:	f58080e7          	jalr	-168(ra) # 4f8 <putc>
  while(--i >= 0)
 5a8:	197d                	addi	s2,s2,-1
 5aa:	ff3918e3          	bne	s2,s3,59a <printint+0x80>
}
 5ae:	70e2                	ld	ra,56(sp)
 5b0:	7442                	ld	s0,48(sp)
 5b2:	74a2                	ld	s1,40(sp)
 5b4:	7902                	ld	s2,32(sp)
 5b6:	69e2                	ld	s3,24(sp)
 5b8:	6121                	addi	sp,sp,64
 5ba:	8082                	ret
    x = -xx;
 5bc:	40b005bb          	negw	a1,a1
    neg = 1;
 5c0:	4885                	li	a7,1
    x = -xx;
 5c2:	bf8d                	j	534 <printint+0x1a>

00000000000005c4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5c4:	7119                	addi	sp,sp,-128
 5c6:	fc86                	sd	ra,120(sp)
 5c8:	f8a2                	sd	s0,112(sp)
 5ca:	f4a6                	sd	s1,104(sp)
 5cc:	f0ca                	sd	s2,96(sp)
 5ce:	ecce                	sd	s3,88(sp)
 5d0:	e8d2                	sd	s4,80(sp)
 5d2:	e4d6                	sd	s5,72(sp)
 5d4:	e0da                	sd	s6,64(sp)
 5d6:	fc5e                	sd	s7,56(sp)
 5d8:	f862                	sd	s8,48(sp)
 5da:	f466                	sd	s9,40(sp)
 5dc:	f06a                	sd	s10,32(sp)
 5de:	ec6e                	sd	s11,24(sp)
 5e0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5e2:	0005c903          	lbu	s2,0(a1)
 5e6:	18090f63          	beqz	s2,784 <vprintf+0x1c0>
 5ea:	8aaa                	mv	s5,a0
 5ec:	8b32                	mv	s6,a2
 5ee:	00158493          	addi	s1,a1,1
  state = 0;
 5f2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5f4:	02500a13          	li	s4,37
      if(c == 'd'){
 5f8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5fc:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 600:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 604:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 608:	00000b97          	auipc	s7,0x0
 60c:	468b8b93          	addi	s7,s7,1128 # a70 <digits>
 610:	a839                	j	62e <vprintf+0x6a>
        putc(fd, c);
 612:	85ca                	mv	a1,s2
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	ee2080e7          	jalr	-286(ra) # 4f8 <putc>
 61e:	a019                	j	624 <vprintf+0x60>
    } else if(state == '%'){
 620:	01498f63          	beq	s3,s4,63e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 624:	0485                	addi	s1,s1,1
 626:	fff4c903          	lbu	s2,-1(s1)
 62a:	14090d63          	beqz	s2,784 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 62e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 632:	fe0997e3          	bnez	s3,620 <vprintf+0x5c>
      if(c == '%'){
 636:	fd479ee3          	bne	a5,s4,612 <vprintf+0x4e>
        state = '%';
 63a:	89be                	mv	s3,a5
 63c:	b7e5                	j	624 <vprintf+0x60>
      if(c == 'd'){
 63e:	05878063          	beq	a5,s8,67e <vprintf+0xba>
      } else if(c == 'l') {
 642:	05978c63          	beq	a5,s9,69a <vprintf+0xd6>
      } else if(c == 'x') {
 646:	07a78863          	beq	a5,s10,6b6 <vprintf+0xf2>
      } else if(c == 'p') {
 64a:	09b78463          	beq	a5,s11,6d2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 64e:	07300713          	li	a4,115
 652:	0ce78663          	beq	a5,a4,71e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 656:	06300713          	li	a4,99
 65a:	0ee78e63          	beq	a5,a4,756 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 65e:	11478863          	beq	a5,s4,76e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 662:	85d2                	mv	a1,s4
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	e92080e7          	jalr	-366(ra) # 4f8 <putc>
        putc(fd, c);
 66e:	85ca                	mv	a1,s2
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	e86080e7          	jalr	-378(ra) # 4f8 <putc>
      }
      state = 0;
 67a:	4981                	li	s3,0
 67c:	b765                	j	624 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 67e:	008b0913          	addi	s2,s6,8
 682:	4685                	li	a3,1
 684:	4629                	li	a2,10
 686:	000b2583          	lw	a1,0(s6)
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	e8e080e7          	jalr	-370(ra) # 51a <printint>
 694:	8b4a                	mv	s6,s2
      state = 0;
 696:	4981                	li	s3,0
 698:	b771                	j	624 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69a:	008b0913          	addi	s2,s6,8
 69e:	4681                	li	a3,0
 6a0:	4629                	li	a2,10
 6a2:	000b2583          	lw	a1,0(s6)
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	e72080e7          	jalr	-398(ra) # 51a <printint>
 6b0:	8b4a                	mv	s6,s2
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	bf85                	j	624 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6b6:	008b0913          	addi	s2,s6,8
 6ba:	4681                	li	a3,0
 6bc:	4641                	li	a2,16
 6be:	000b2583          	lw	a1,0(s6)
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	e56080e7          	jalr	-426(ra) # 51a <printint>
 6cc:	8b4a                	mv	s6,s2
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	bf91                	j	624 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6d2:	008b0793          	addi	a5,s6,8
 6d6:	f8f43423          	sd	a5,-120(s0)
 6da:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6de:	03000593          	li	a1,48
 6e2:	8556                	mv	a0,s5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	e14080e7          	jalr	-492(ra) # 4f8 <putc>
  putc(fd, 'x');
 6ec:	85ea                	mv	a1,s10
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	e08080e7          	jalr	-504(ra) # 4f8 <putc>
 6f8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fa:	03c9d793          	srli	a5,s3,0x3c
 6fe:	97de                	add	a5,a5,s7
 700:	0007c583          	lbu	a1,0(a5)
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	df2080e7          	jalr	-526(ra) # 4f8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 70e:	0992                	slli	s3,s3,0x4
 710:	397d                	addiw	s2,s2,-1
 712:	fe0914e3          	bnez	s2,6fa <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 716:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 71a:	4981                	li	s3,0
 71c:	b721                	j	624 <vprintf+0x60>
        s = va_arg(ap, char*);
 71e:	008b0993          	addi	s3,s6,8
 722:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 726:	02090163          	beqz	s2,748 <vprintf+0x184>
        while(*s != 0){
 72a:	00094583          	lbu	a1,0(s2)
 72e:	c9a1                	beqz	a1,77e <vprintf+0x1ba>
          putc(fd, *s);
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	dc6080e7          	jalr	-570(ra) # 4f8 <putc>
          s++;
 73a:	0905                	addi	s2,s2,1
        while(*s != 0){
 73c:	00094583          	lbu	a1,0(s2)
 740:	f9e5                	bnez	a1,730 <vprintf+0x16c>
        s = va_arg(ap, char*);
 742:	8b4e                	mv	s6,s3
      state = 0;
 744:	4981                	li	s3,0
 746:	bdf9                	j	624 <vprintf+0x60>
          s = "(null)";
 748:	00000917          	auipc	s2,0x0
 74c:	32090913          	addi	s2,s2,800 # a68 <malloc+0x1da>
        while(*s != 0){
 750:	02800593          	li	a1,40
 754:	bff1                	j	730 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 756:	008b0913          	addi	s2,s6,8
 75a:	000b4583          	lbu	a1,0(s6)
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	d98080e7          	jalr	-616(ra) # 4f8 <putc>
 768:	8b4a                	mv	s6,s2
      state = 0;
 76a:	4981                	li	s3,0
 76c:	bd65                	j	624 <vprintf+0x60>
        putc(fd, c);
 76e:	85d2                	mv	a1,s4
 770:	8556                	mv	a0,s5
 772:	00000097          	auipc	ra,0x0
 776:	d86080e7          	jalr	-634(ra) # 4f8 <putc>
      state = 0;
 77a:	4981                	li	s3,0
 77c:	b565                	j	624 <vprintf+0x60>
        s = va_arg(ap, char*);
 77e:	8b4e                	mv	s6,s3
      state = 0;
 780:	4981                	li	s3,0
 782:	b54d                	j	624 <vprintf+0x60>
    }
  }
}
 784:	70e6                	ld	ra,120(sp)
 786:	7446                	ld	s0,112(sp)
 788:	74a6                	ld	s1,104(sp)
 78a:	7906                	ld	s2,96(sp)
 78c:	69e6                	ld	s3,88(sp)
 78e:	6a46                	ld	s4,80(sp)
 790:	6aa6                	ld	s5,72(sp)
 792:	6b06                	ld	s6,64(sp)
 794:	7be2                	ld	s7,56(sp)
 796:	7c42                	ld	s8,48(sp)
 798:	7ca2                	ld	s9,40(sp)
 79a:	7d02                	ld	s10,32(sp)
 79c:	6de2                	ld	s11,24(sp)
 79e:	6109                	addi	sp,sp,128
 7a0:	8082                	ret

00000000000007a2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a2:	715d                	addi	sp,sp,-80
 7a4:	ec06                	sd	ra,24(sp)
 7a6:	e822                	sd	s0,16(sp)
 7a8:	1000                	addi	s0,sp,32
 7aa:	e010                	sd	a2,0(s0)
 7ac:	e414                	sd	a3,8(s0)
 7ae:	e818                	sd	a4,16(s0)
 7b0:	ec1c                	sd	a5,24(s0)
 7b2:	03043023          	sd	a6,32(s0)
 7b6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7be:	8622                	mv	a2,s0
 7c0:	00000097          	auipc	ra,0x0
 7c4:	e04080e7          	jalr	-508(ra) # 5c4 <vprintf>
}
 7c8:	60e2                	ld	ra,24(sp)
 7ca:	6442                	ld	s0,16(sp)
 7cc:	6161                	addi	sp,sp,80
 7ce:	8082                	ret

00000000000007d0 <printf>:

void
printf(const char *fmt, ...)
{
 7d0:	711d                	addi	sp,sp,-96
 7d2:	ec06                	sd	ra,24(sp)
 7d4:	e822                	sd	s0,16(sp)
 7d6:	1000                	addi	s0,sp,32
 7d8:	e40c                	sd	a1,8(s0)
 7da:	e810                	sd	a2,16(s0)
 7dc:	ec14                	sd	a3,24(s0)
 7de:	f018                	sd	a4,32(s0)
 7e0:	f41c                	sd	a5,40(s0)
 7e2:	03043823          	sd	a6,48(s0)
 7e6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ea:	00840613          	addi	a2,s0,8
 7ee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f2:	85aa                	mv	a1,a0
 7f4:	4505                	li	a0,1
 7f6:	00000097          	auipc	ra,0x0
 7fa:	dce080e7          	jalr	-562(ra) # 5c4 <vprintf>
}
 7fe:	60e2                	ld	ra,24(sp)
 800:	6442                	ld	s0,16(sp)
 802:	6125                	addi	sp,sp,96
 804:	8082                	ret

0000000000000806 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 806:	1141                	addi	sp,sp,-16
 808:	e422                	sd	s0,8(sp)
 80a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 80c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 810:	00000797          	auipc	a5,0x0
 814:	2787b783          	ld	a5,632(a5) # a88 <freep>
 818:	a805                	j	848 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 81a:	4618                	lw	a4,8(a2)
 81c:	9db9                	addw	a1,a1,a4
 81e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 822:	6398                	ld	a4,0(a5)
 824:	6318                	ld	a4,0(a4)
 826:	fee53823          	sd	a4,-16(a0)
 82a:	a091                	j	86e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 82c:	ff852703          	lw	a4,-8(a0)
 830:	9e39                	addw	a2,a2,a4
 832:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 834:	ff053703          	ld	a4,-16(a0)
 838:	e398                	sd	a4,0(a5)
 83a:	a099                	j	880 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83c:	6398                	ld	a4,0(a5)
 83e:	00e7e463          	bltu	a5,a4,846 <free+0x40>
 842:	00e6ea63          	bltu	a3,a4,856 <free+0x50>
{
 846:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 848:	fed7fae3          	bgeu	a5,a3,83c <free+0x36>
 84c:	6398                	ld	a4,0(a5)
 84e:	00e6e463          	bltu	a3,a4,856 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 852:	fee7eae3          	bltu	a5,a4,846 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 856:	ff852583          	lw	a1,-8(a0)
 85a:	6390                	ld	a2,0(a5)
 85c:	02059713          	slli	a4,a1,0x20
 860:	9301                	srli	a4,a4,0x20
 862:	0712                	slli	a4,a4,0x4
 864:	9736                	add	a4,a4,a3
 866:	fae60ae3          	beq	a2,a4,81a <free+0x14>
    bp->s.ptr = p->s.ptr;
 86a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 86e:	4790                	lw	a2,8(a5)
 870:	02061713          	slli	a4,a2,0x20
 874:	9301                	srli	a4,a4,0x20
 876:	0712                	slli	a4,a4,0x4
 878:	973e                	add	a4,a4,a5
 87a:	fae689e3          	beq	a3,a4,82c <free+0x26>
  } else
    p->s.ptr = bp;
 87e:	e394                	sd	a3,0(a5)
  freep = p;
 880:	00000717          	auipc	a4,0x0
 884:	20f73423          	sd	a5,520(a4) # a88 <freep>
}
 888:	6422                	ld	s0,8(sp)
 88a:	0141                	addi	sp,sp,16
 88c:	8082                	ret

000000000000088e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 88e:	7139                	addi	sp,sp,-64
 890:	fc06                	sd	ra,56(sp)
 892:	f822                	sd	s0,48(sp)
 894:	f426                	sd	s1,40(sp)
 896:	f04a                	sd	s2,32(sp)
 898:	ec4e                	sd	s3,24(sp)
 89a:	e852                	sd	s4,16(sp)
 89c:	e456                	sd	s5,8(sp)
 89e:	e05a                	sd	s6,0(sp)
 8a0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a2:	02051493          	slli	s1,a0,0x20
 8a6:	9081                	srli	s1,s1,0x20
 8a8:	04bd                	addi	s1,s1,15
 8aa:	8091                	srli	s1,s1,0x4
 8ac:	0014899b          	addiw	s3,s1,1
 8b0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8b2:	00000517          	auipc	a0,0x0
 8b6:	1d653503          	ld	a0,470(a0) # a88 <freep>
 8ba:	c515                	beqz	a0,8e6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8be:	4798                	lw	a4,8(a5)
 8c0:	02977f63          	bgeu	a4,s1,8fe <malloc+0x70>
 8c4:	8a4e                	mv	s4,s3
 8c6:	0009871b          	sext.w	a4,s3
 8ca:	6685                	lui	a3,0x1
 8cc:	00d77363          	bgeu	a4,a3,8d2 <malloc+0x44>
 8d0:	6a05                	lui	s4,0x1
 8d2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8da:	00000917          	auipc	s2,0x0
 8de:	1ae90913          	addi	s2,s2,430 # a88 <freep>
  if(p == (char*)-1)
 8e2:	5afd                	li	s5,-1
 8e4:	a88d                	j	956 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8e6:	00000797          	auipc	a5,0x0
 8ea:	1aa78793          	addi	a5,a5,426 # a90 <base>
 8ee:	00000717          	auipc	a4,0x0
 8f2:	18f73d23          	sd	a5,410(a4) # a88 <freep>
 8f6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8fc:	b7e1                	j	8c4 <malloc+0x36>
      if(p->s.size == nunits)
 8fe:	02e48b63          	beq	s1,a4,934 <malloc+0xa6>
        p->s.size -= nunits;
 902:	4137073b          	subw	a4,a4,s3
 906:	c798                	sw	a4,8(a5)
        p += p->s.size;
 908:	1702                	slli	a4,a4,0x20
 90a:	9301                	srli	a4,a4,0x20
 90c:	0712                	slli	a4,a4,0x4
 90e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 910:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 914:	00000717          	auipc	a4,0x0
 918:	16a73a23          	sd	a0,372(a4) # a88 <freep>
      return (void*)(p + 1);
 91c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 920:	70e2                	ld	ra,56(sp)
 922:	7442                	ld	s0,48(sp)
 924:	74a2                	ld	s1,40(sp)
 926:	7902                	ld	s2,32(sp)
 928:	69e2                	ld	s3,24(sp)
 92a:	6a42                	ld	s4,16(sp)
 92c:	6aa2                	ld	s5,8(sp)
 92e:	6b02                	ld	s6,0(sp)
 930:	6121                	addi	sp,sp,64
 932:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 934:	6398                	ld	a4,0(a5)
 936:	e118                	sd	a4,0(a0)
 938:	bff1                	j	914 <malloc+0x86>
  hp->s.size = nu;
 93a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 93e:	0541                	addi	a0,a0,16
 940:	00000097          	auipc	ra,0x0
 944:	ec6080e7          	jalr	-314(ra) # 806 <free>
  return freep;
 948:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 94c:	d971                	beqz	a0,920 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 950:	4798                	lw	a4,8(a5)
 952:	fa9776e3          	bgeu	a4,s1,8fe <malloc+0x70>
    if(p == freep)
 956:	00093703          	ld	a4,0(s2)
 95a:	853e                	mv	a0,a5
 95c:	fef719e3          	bne	a4,a5,94e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 960:	8552                	mv	a0,s4
 962:	00000097          	auipc	ra,0x0
 966:	b5e080e7          	jalr	-1186(ra) # 4c0 <sbrk>
  if(p == (char*)-1)
 96a:	fd5518e3          	bne	a0,s5,93a <malloc+0xac>
        return 0;
 96e:	4501                	li	a0,0
 970:	bf45                	j	920 <malloc+0x92>
