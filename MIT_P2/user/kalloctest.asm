
user/_kalloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
  test1();
  exit(0);
}

void test0()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  void *a, *a1;
  printf("start test0\n");  
  10:	00001517          	auipc	a0,0x1
  14:	9e850513          	addi	a0,a0,-1560 # 9f8 <malloc+0xe4>
  18:	00001097          	auipc	ra,0x1
  1c:	83e080e7          	jalr	-1986(ra) # 856 <printf>
  int n = ntas();
  20:	00000097          	auipc	ra,0x0
  24:	53e080e7          	jalr	1342(ra) # 55e <ntas>
  28:	84aa                	mv	s1,a0
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
  2a:	00000097          	auipc	ra,0x0
  2e:	48c080e7          	jalr	1164(ra) # 4b6 <fork>
    if(pid < 0){
  32:	04054a63          	bltz	a0,86 <test0+0x86>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
  36:	c52d                	beqz	a0,a0 <test0+0xa0>
    int pid = fork();
  38:	00000097          	auipc	ra,0x0
  3c:	47e080e7          	jalr	1150(ra) # 4b6 <fork>
    if(pid < 0){
  40:	04054363          	bltz	a0,86 <test0+0x86>
    if(pid == 0){
  44:	cd31                	beqz	a0,a0 <test0+0xa0>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
  46:	4501                	li	a0,0
  48:	00000097          	auipc	ra,0x0
  4c:	47e080e7          	jalr	1150(ra) # 4c6 <wait>
  50:	4501                	li	a0,0
  52:	00000097          	auipc	ra,0x0
  56:	474080e7          	jalr	1140(ra) # 4c6 <wait>
  }
  int t = ntas();
  5a:	00000097          	auipc	ra,0x0
  5e:	504080e7          	jalr	1284(ra) # 55e <ntas>
  printf("test0 done: #test-and-sets = %d\n", t - n);
  62:	409505bb          	subw	a1,a0,s1
  66:	00001517          	auipc	a0,0x1
  6a:	9c250513          	addi	a0,a0,-1598 # a28 <malloc+0x114>
  6e:	00000097          	auipc	ra,0x0
  72:	7e8080e7          	jalr	2024(ra) # 856 <printf>
}
  76:	70a2                	ld	ra,40(sp)
  78:	7402                	ld	s0,32(sp)
  7a:	64e2                	ld	s1,24(sp)
  7c:	6942                	ld	s2,16(sp)
  7e:	69a2                	ld	s3,8(sp)
  80:	6a02                	ld	s4,0(sp)
  82:	6145                	addi	sp,sp,48
  84:	8082                	ret
      printf("fork failed");
  86:	00001517          	auipc	a0,0x1
  8a:	98250513          	addi	a0,a0,-1662 # a08 <malloc+0xf4>
  8e:	00000097          	auipc	ra,0x0
  92:	7c8080e7          	jalr	1992(ra) # 856 <printf>
      exit(-1);
  96:	557d                	li	a0,-1
  98:	00000097          	auipc	ra,0x0
  9c:	426080e7          	jalr	1062(ra) # 4be <exit>
{
  a0:	6961                	lui	s2,0x18
  a2:	6a090913          	addi	s2,s2,1696 # 186a0 <__global_pointer$+0x17387>
        if(a == (char*)0xffffffffffffffffL){
  a6:	59fd                	li	s3,-1
        *(int *)(a+4) = 1;
  a8:	4a05                	li	s4,1
        a = sbrk(4096);
  aa:	6505                	lui	a0,0x1
  ac:	00000097          	auipc	ra,0x0
  b0:	49a080e7          	jalr	1178(ra) # 546 <sbrk>
  b4:	84aa                	mv	s1,a0
        if(a == (char*)0xffffffffffffffffL){
  b6:	03350063          	beq	a0,s3,d6 <test0+0xd6>
        *(int *)(a+4) = 1;
  ba:	01452223          	sw	s4,4(a0) # 1004 <__BSS_END__+0x4cc>
        a1 = sbrk(-4096);
  be:	757d                	lui	a0,0xfffff
  c0:	00000097          	auipc	ra,0x0
  c4:	486080e7          	jalr	1158(ra) # 546 <sbrk>
        if (a1 != a + 4096) {
  c8:	6785                	lui	a5,0x1
  ca:	94be                	add	s1,s1,a5
  cc:	00951a63          	bne	a0,s1,e0 <test0+0xe0>
      for(i = 0; i < N; i++) {
  d0:	397d                	addiw	s2,s2,-1
  d2:	fc091ce3          	bnez	s2,aa <test0+0xaa>
      exit(0);
  d6:	4501                	li	a0,0
  d8:	00000097          	auipc	ra,0x0
  dc:	3e6080e7          	jalr	998(ra) # 4be <exit>
          printf("wrong sbrk\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	93850513          	addi	a0,a0,-1736 # a18 <malloc+0x104>
  e8:	00000097          	auipc	ra,0x0
  ec:	76e080e7          	jalr	1902(ra) # 856 <printf>
          exit(-1);
  f0:	557d                	li	a0,-1
  f2:	00000097          	auipc	ra,0x0
  f6:	3cc080e7          	jalr	972(ra) # 4be <exit>

00000000000000fa <test1>:

// Run system out of memory and count tot memory allocated
void test1()
{
  fa:	715d                	addi	sp,sp,-80
  fc:	e486                	sd	ra,72(sp)
  fe:	e0a2                	sd	s0,64(sp)
 100:	fc26                	sd	s1,56(sp)
 102:	f84a                	sd	s2,48(sp)
 104:	f44e                	sd	s3,40(sp)
 106:	f052                	sd	s4,32(sp)
 108:	0880                	addi	s0,sp,80
  void *a;
  int pipes[NCHILD];
  int tot = 0;
  char buf[1];
  
  printf("start test1\n");  
 10a:	00001517          	auipc	a0,0x1
 10e:	94650513          	addi	a0,a0,-1722 # a50 <malloc+0x13c>
 112:	00000097          	auipc	ra,0x0
 116:	744080e7          	jalr	1860(ra) # 856 <printf>
  for(int i = 0; i < NCHILD; i++){
 11a:	fc840913          	addi	s2,s0,-56
    int fds[2];
    if(pipe(fds) != 0){
 11e:	fb840513          	addi	a0,s0,-72
 122:	00000097          	auipc	ra,0x0
 126:	3ac080e7          	jalr	940(ra) # 4ce <pipe>
 12a:	84aa                	mv	s1,a0
 12c:	e905                	bnez	a0,15c <test1+0x62>
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
 12e:	00000097          	auipc	ra,0x0
 132:	388080e7          	jalr	904(ra) # 4b6 <fork>
    if(pid < 0){
 136:	04054063          	bltz	a0,176 <test1+0x7c>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 13a:	c939                	beqz	a0,190 <test1+0x96>
          exit(-1);
        }
      }
      exit(-1);
    } else {
      close(fds[1]);
 13c:	fbc42503          	lw	a0,-68(s0)
 140:	00000097          	auipc	ra,0x0
 144:	3a6080e7          	jalr	934(ra) # 4e6 <close>
      pipes[i] = fds[0];
 148:	fb842783          	lw	a5,-72(s0)
 14c:	00f92023          	sw	a5,0(s2)
  for(int i = 0; i < NCHILD; i++){
 150:	0911                	addi	s2,s2,4
 152:	fd040793          	addi	a5,s0,-48
 156:	fd2794e3          	bne	a5,s2,11e <test1+0x24>
 15a:	a875                	j	216 <test1+0x11c>
      printf("pipe() failed\n");
 15c:	00001517          	auipc	a0,0x1
 160:	90450513          	addi	a0,a0,-1788 # a60 <malloc+0x14c>
 164:	00000097          	auipc	ra,0x0
 168:	6f2080e7          	jalr	1778(ra) # 856 <printf>
      exit(-1);
 16c:	557d                	li	a0,-1
 16e:	00000097          	auipc	ra,0x0
 172:	350080e7          	jalr	848(ra) # 4be <exit>
      printf("fork failed");
 176:	00001517          	auipc	a0,0x1
 17a:	89250513          	addi	a0,a0,-1902 # a08 <malloc+0xf4>
 17e:	00000097          	auipc	ra,0x0
 182:	6d8080e7          	jalr	1752(ra) # 856 <printf>
      exit(-1);
 186:	557d                	li	a0,-1
 188:	00000097          	auipc	ra,0x0
 18c:	336080e7          	jalr	822(ra) # 4be <exit>
      close(fds[0]);
 190:	fb842503          	lw	a0,-72(s0)
 194:	00000097          	auipc	ra,0x0
 198:	352080e7          	jalr	850(ra) # 4e6 <close>
 19c:	64e1                	lui	s1,0x18
 19e:	6a048493          	addi	s1,s1,1696 # 186a0 <__global_pointer$+0x17387>
        if(a == (char*)0xffffffffffffffffL){
 1a2:	5a7d                	li	s4,-1
        *(int *)(a+4) = 1;
 1a4:	4905                	li	s2,1
        if (write(fds[1], "x", 1) != 1) {
 1a6:	00001997          	auipc	s3,0x1
 1aa:	8ca98993          	addi	s3,s3,-1846 # a70 <malloc+0x15c>
        a = sbrk(PGSIZE);
 1ae:	6505                	lui	a0,0x1
 1b0:	00000097          	auipc	ra,0x0
 1b4:	396080e7          	jalr	918(ra) # 546 <sbrk>
        if(a == (char*)0xffffffffffffffffL){
 1b8:	03450063          	beq	a0,s4,1d8 <test1+0xde>
        *(int *)(a+4) = 1;
 1bc:	01252223          	sw	s2,4(a0) # 1004 <__BSS_END__+0x4cc>
        if (write(fds[1], "x", 1) != 1) {
 1c0:	864a                	mv	a2,s2
 1c2:	85ce                	mv	a1,s3
 1c4:	fbc42503          	lw	a0,-68(s0)
 1c8:	00000097          	auipc	ra,0x0
 1cc:	316080e7          	jalr	790(ra) # 4de <write>
 1d0:	01251963          	bne	a0,s2,1e2 <test1+0xe8>
      for(i = 0; i < N; i++) {
 1d4:	34fd                	addiw	s1,s1,-1
 1d6:	fce1                	bnez	s1,1ae <test1+0xb4>
      exit(-1);
 1d8:	557d                	li	a0,-1
 1da:	00000097          	auipc	ra,0x0
 1de:	2e4080e7          	jalr	740(ra) # 4be <exit>
          printf("write failed");
 1e2:	00001517          	auipc	a0,0x1
 1e6:	89650513          	addi	a0,a0,-1898 # a78 <malloc+0x164>
 1ea:	00000097          	auipc	ra,0x0
 1ee:	66c080e7          	jalr	1644(ra) # 856 <printf>
          exit(-1);
 1f2:	557d                	li	a0,-1
 1f4:	00000097          	auipc	ra,0x0
 1f8:	2ca080e7          	jalr	714(ra) # 4be <exit>
  int stop = 0;
  while (!stop) {
    stop = 1;
    for(int i = 0; i < NCHILD; i++){
      if (read(pipes[i], buf, 1) == 1) {
        tot += 1;
 1fc:	2485                	addiw	s1,s1,1
      if (read(pipes[i], buf, 1) == 1) {
 1fe:	4605                	li	a2,1
 200:	fc040593          	addi	a1,s0,-64
 204:	fcc42503          	lw	a0,-52(s0)
 208:	00000097          	auipc	ra,0x0
 20c:	2ce080e7          	jalr	718(ra) # 4d6 <read>
 210:	4785                	li	a5,1
 212:	02f50a63          	beq	a0,a5,246 <test1+0x14c>
 216:	4605                	li	a2,1
 218:	fc040593          	addi	a1,s0,-64
 21c:	fc842503          	lw	a0,-56(s0)
 220:	00000097          	auipc	ra,0x0
 224:	2b6080e7          	jalr	694(ra) # 4d6 <read>
 228:	4785                	li	a5,1
 22a:	fcf509e3          	beq	a0,a5,1fc <test1+0x102>
 22e:	4605                	li	a2,1
 230:	fc040593          	addi	a1,s0,-64
 234:	fcc42503          	lw	a0,-52(s0)
 238:	00000097          	auipc	ra,0x0
 23c:	29e080e7          	jalr	670(ra) # 4d6 <read>
 240:	4785                	li	a5,1
 242:	02f51163          	bne	a0,a5,264 <test1+0x16a>
        tot += 1;
 246:	2485                	addiw	s1,s1,1
  while (!stop) {
 248:	b7f9                	j	216 <test1+0x11c>
    }
  }
  int n = (PHYSTOP-KERNBASE)/PGSIZE;
  printf("total allocated number of pages: %d (out of %d)\n", tot, n);
  if(n - tot > 1000) {
    printf("test1 failed: cannot allocate enough memory\n");
 24a:	00001517          	auipc	a0,0x1
 24e:	83e50513          	addi	a0,a0,-1986 # a88 <malloc+0x174>
 252:	00000097          	auipc	ra,0x0
 256:	604080e7          	jalr	1540(ra) # 856 <printf>
    exit(-1);
 25a:	557d                	li	a0,-1
 25c:	00000097          	auipc	ra,0x0
 260:	262080e7          	jalr	610(ra) # 4be <exit>
  printf("total allocated number of pages: %d (out of %d)\n", tot, n);
 264:	6621                	lui	a2,0x8
 266:	85a6                	mv	a1,s1
 268:	00001517          	auipc	a0,0x1
 26c:	86050513          	addi	a0,a0,-1952 # ac8 <malloc+0x1b4>
 270:	00000097          	auipc	ra,0x0
 274:	5e6080e7          	jalr	1510(ra) # 856 <printf>
  if(n - tot > 1000) {
 278:	67a1                	lui	a5,0x8
 27a:	409784bb          	subw	s1,a5,s1
 27e:	3e800793          	li	a5,1000
 282:	fc97c4e3          	blt	a5,s1,24a <test1+0x150>
  }
  printf("test1 done\n");
 286:	00001517          	auipc	a0,0x1
 28a:	83250513          	addi	a0,a0,-1998 # ab8 <malloc+0x1a4>
 28e:	00000097          	auipc	ra,0x0
 292:	5c8080e7          	jalr	1480(ra) # 856 <printf>
}
 296:	60a6                	ld	ra,72(sp)
 298:	6406                	ld	s0,64(sp)
 29a:	74e2                	ld	s1,56(sp)
 29c:	7942                	ld	s2,48(sp)
 29e:	79a2                	ld	s3,40(sp)
 2a0:	7a02                	ld	s4,32(sp)
 2a2:	6161                	addi	sp,sp,80
 2a4:	8082                	ret

00000000000002a6 <main>:
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e406                	sd	ra,8(sp)
 2aa:	e022                	sd	s0,0(sp)
 2ac:	0800                	addi	s0,sp,16
  test0();
 2ae:	00000097          	auipc	ra,0x0
 2b2:	d52080e7          	jalr	-686(ra) # 0 <test0>
  test1();
 2b6:	00000097          	auipc	ra,0x0
 2ba:	e44080e7          	jalr	-444(ra) # fa <test1>
  exit(0);
 2be:	4501                	li	a0,0
 2c0:	00000097          	auipc	ra,0x0
 2c4:	1fe080e7          	jalr	510(ra) # 4be <exit>

00000000000002c8 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ce:	87aa                	mv	a5,a0
 2d0:	0585                	addi	a1,a1,1
 2d2:	0785                	addi	a5,a5,1
 2d4:	fff5c703          	lbu	a4,-1(a1)
 2d8:	fee78fa3          	sb	a4,-1(a5) # 7fff <__global_pointer$+0x6ce6>
 2dc:	fb75                	bnez	a4,2d0 <strcpy+0x8>
    ;
  return os;
}
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret

00000000000002e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e422                	sd	s0,8(sp)
 2e8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2ea:	00054783          	lbu	a5,0(a0)
 2ee:	cb91                	beqz	a5,302 <strcmp+0x1e>
 2f0:	0005c703          	lbu	a4,0(a1)
 2f4:	00f71763          	bne	a4,a5,302 <strcmp+0x1e>
    p++, q++;
 2f8:	0505                	addi	a0,a0,1
 2fa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2fc:	00054783          	lbu	a5,0(a0)
 300:	fbe5                	bnez	a5,2f0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 302:	0005c503          	lbu	a0,0(a1)
}
 306:	40a7853b          	subw	a0,a5,a0
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <strlen>:

uint
strlen(const char *s)
{
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 316:	00054783          	lbu	a5,0(a0)
 31a:	cf91                	beqz	a5,336 <strlen+0x26>
 31c:	0505                	addi	a0,a0,1
 31e:	87aa                	mv	a5,a0
 320:	4685                	li	a3,1
 322:	9e89                	subw	a3,a3,a0
 324:	00f6853b          	addw	a0,a3,a5
 328:	0785                	addi	a5,a5,1
 32a:	fff7c703          	lbu	a4,-1(a5)
 32e:	fb7d                	bnez	a4,324 <strlen+0x14>
    ;
  return n;
}
 330:	6422                	ld	s0,8(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret
  for(n = 0; s[n]; n++)
 336:	4501                	li	a0,0
 338:	bfe5                	j	330 <strlen+0x20>

000000000000033a <memset>:

void*
memset(void *dst, int c, uint n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 340:	ce09                	beqz	a2,35a <memset+0x20>
 342:	87aa                	mv	a5,a0
 344:	fff6071b          	addiw	a4,a2,-1
 348:	1702                	slli	a4,a4,0x20
 34a:	9301                	srli	a4,a4,0x20
 34c:	0705                	addi	a4,a4,1
 34e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 350:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 354:	0785                	addi	a5,a5,1
 356:	fee79de3          	bne	a5,a4,350 <memset+0x16>
  }
  return dst;
}
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <strchr>:

char*
strchr(const char *s, char c)
{
 360:	1141                	addi	sp,sp,-16
 362:	e422                	sd	s0,8(sp)
 364:	0800                	addi	s0,sp,16
  for(; *s; s++)
 366:	00054783          	lbu	a5,0(a0)
 36a:	cb99                	beqz	a5,380 <strchr+0x20>
    if(*s == c)
 36c:	00f58763          	beq	a1,a5,37a <strchr+0x1a>
  for(; *s; s++)
 370:	0505                	addi	a0,a0,1
 372:	00054783          	lbu	a5,0(a0)
 376:	fbfd                	bnez	a5,36c <strchr+0xc>
      return (char*)s;
  return 0;
 378:	4501                	li	a0,0
}
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret
  return 0;
 380:	4501                	li	a0,0
 382:	bfe5                	j	37a <strchr+0x1a>

0000000000000384 <gets>:

char*
gets(char *buf, int max)
{
 384:	711d                	addi	sp,sp,-96
 386:	ec86                	sd	ra,88(sp)
 388:	e8a2                	sd	s0,80(sp)
 38a:	e4a6                	sd	s1,72(sp)
 38c:	e0ca                	sd	s2,64(sp)
 38e:	fc4e                	sd	s3,56(sp)
 390:	f852                	sd	s4,48(sp)
 392:	f456                	sd	s5,40(sp)
 394:	f05a                	sd	s6,32(sp)
 396:	ec5e                	sd	s7,24(sp)
 398:	1080                	addi	s0,sp,96
 39a:	8baa                	mv	s7,a0
 39c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 39e:	892a                	mv	s2,a0
 3a0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3a2:	4aa9                	li	s5,10
 3a4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3a6:	89a6                	mv	s3,s1
 3a8:	2485                	addiw	s1,s1,1
 3aa:	0344d863          	bge	s1,s4,3da <gets+0x56>
    cc = read(0, &c, 1);
 3ae:	4605                	li	a2,1
 3b0:	faf40593          	addi	a1,s0,-81
 3b4:	4501                	li	a0,0
 3b6:	00000097          	auipc	ra,0x0
 3ba:	120080e7          	jalr	288(ra) # 4d6 <read>
    if(cc < 1)
 3be:	00a05e63          	blez	a0,3da <gets+0x56>
    buf[i++] = c;
 3c2:	faf44783          	lbu	a5,-81(s0)
 3c6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3ca:	01578763          	beq	a5,s5,3d8 <gets+0x54>
 3ce:	0905                	addi	s2,s2,1
 3d0:	fd679be3          	bne	a5,s6,3a6 <gets+0x22>
  for(i=0; i+1 < max; ){
 3d4:	89a6                	mv	s3,s1
 3d6:	a011                	j	3da <gets+0x56>
 3d8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3da:	99de                	add	s3,s3,s7
 3dc:	00098023          	sb	zero,0(s3)
  return buf;
}
 3e0:	855e                	mv	a0,s7
 3e2:	60e6                	ld	ra,88(sp)
 3e4:	6446                	ld	s0,80(sp)
 3e6:	64a6                	ld	s1,72(sp)
 3e8:	6906                	ld	s2,64(sp)
 3ea:	79e2                	ld	s3,56(sp)
 3ec:	7a42                	ld	s4,48(sp)
 3ee:	7aa2                	ld	s5,40(sp)
 3f0:	7b02                	ld	s6,32(sp)
 3f2:	6be2                	ld	s7,24(sp)
 3f4:	6125                	addi	sp,sp,96
 3f6:	8082                	ret

00000000000003f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f8:	1101                	addi	sp,sp,-32
 3fa:	ec06                	sd	ra,24(sp)
 3fc:	e822                	sd	s0,16(sp)
 3fe:	e426                	sd	s1,8(sp)
 400:	e04a                	sd	s2,0(sp)
 402:	1000                	addi	s0,sp,32
 404:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 406:	4581                	li	a1,0
 408:	00000097          	auipc	ra,0x0
 40c:	0f6080e7          	jalr	246(ra) # 4fe <open>
  if(fd < 0)
 410:	02054563          	bltz	a0,43a <stat+0x42>
 414:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 416:	85ca                	mv	a1,s2
 418:	00000097          	auipc	ra,0x0
 41c:	0fe080e7          	jalr	254(ra) # 516 <fstat>
 420:	892a                	mv	s2,a0
  close(fd);
 422:	8526                	mv	a0,s1
 424:	00000097          	auipc	ra,0x0
 428:	0c2080e7          	jalr	194(ra) # 4e6 <close>
  return r;
}
 42c:	854a                	mv	a0,s2
 42e:	60e2                	ld	ra,24(sp)
 430:	6442                	ld	s0,16(sp)
 432:	64a2                	ld	s1,8(sp)
 434:	6902                	ld	s2,0(sp)
 436:	6105                	addi	sp,sp,32
 438:	8082                	ret
    return -1;
 43a:	597d                	li	s2,-1
 43c:	bfc5                	j	42c <stat+0x34>

000000000000043e <atoi>:

int
atoi(const char *s)
{
 43e:	1141                	addi	sp,sp,-16
 440:	e422                	sd	s0,8(sp)
 442:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 444:	00054603          	lbu	a2,0(a0)
 448:	fd06079b          	addiw	a5,a2,-48
 44c:	0ff7f793          	andi	a5,a5,255
 450:	4725                	li	a4,9
 452:	02f76963          	bltu	a4,a5,484 <atoi+0x46>
 456:	86aa                	mv	a3,a0
  n = 0;
 458:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 45a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 45c:	0685                	addi	a3,a3,1
 45e:	0025179b          	slliw	a5,a0,0x2
 462:	9fa9                	addw	a5,a5,a0
 464:	0017979b          	slliw	a5,a5,0x1
 468:	9fb1                	addw	a5,a5,a2
 46a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 46e:	0006c603          	lbu	a2,0(a3)
 472:	fd06071b          	addiw	a4,a2,-48
 476:	0ff77713          	andi	a4,a4,255
 47a:	fee5f1e3          	bgeu	a1,a4,45c <atoi+0x1e>
  return n;
}
 47e:	6422                	ld	s0,8(sp)
 480:	0141                	addi	sp,sp,16
 482:	8082                	ret
  n = 0;
 484:	4501                	li	a0,0
 486:	bfe5                	j	47e <atoi+0x40>

0000000000000488 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 488:	1141                	addi	sp,sp,-16
 48a:	e422                	sd	s0,8(sp)
 48c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 48e:	02c05163          	blez	a2,4b0 <memmove+0x28>
 492:	fff6071b          	addiw	a4,a2,-1
 496:	1702                	slli	a4,a4,0x20
 498:	9301                	srli	a4,a4,0x20
 49a:	0705                	addi	a4,a4,1
 49c:	972a                	add	a4,a4,a0
  dst = vdst;
 49e:	87aa                	mv	a5,a0
    *dst++ = *src++;
 4a0:	0585                	addi	a1,a1,1
 4a2:	0785                	addi	a5,a5,1
 4a4:	fff5c683          	lbu	a3,-1(a1)
 4a8:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 4ac:	fee79ae3          	bne	a5,a4,4a0 <memmove+0x18>
  return vdst;
}
 4b0:	6422                	ld	s0,8(sp)
 4b2:	0141                	addi	sp,sp,16
 4b4:	8082                	ret

00000000000004b6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4b6:	4885                	li	a7,1
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <exit>:
.global exit
exit:
 li a7, SYS_exit
 4be:	4889                	li	a7,2
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4c6:	488d                	li	a7,3
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4ce:	4891                	li	a7,4
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <read>:
.global read
read:
 li a7, SYS_read
 4d6:	4895                	li	a7,5
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <write>:
.global write
write:
 li a7, SYS_write
 4de:	48c1                	li	a7,16
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <close>:
.global close
close:
 li a7, SYS_close
 4e6:	48d5                	li	a7,21
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ee:	4899                	li	a7,6
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4f6:	489d                	li	a7,7
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <open>:
.global open
open:
 li a7, SYS_open
 4fe:	48bd                	li	a7,15
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 506:	48c5                	li	a7,17
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 50e:	48c9                	li	a7,18
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 516:	48a1                	li	a7,8
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <link>:
.global link
link:
 li a7, SYS_link
 51e:	48cd                	li	a7,19
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 526:	48d1                	li	a7,20
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 52e:	48a5                	li	a7,9
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <dup>:
.global dup
dup:
 li a7, SYS_dup
 536:	48a9                	li	a7,10
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 53e:	48ad                	li	a7,11
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 546:	48b1                	li	a7,12
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 54e:	48b5                	li	a7,13
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 556:	48b9                	li	a7,14
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 55e:	48d9                	li	a7,22
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <crash>:
.global crash
crash:
 li a7, SYS_crash
 566:	48dd                	li	a7,23
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <mount>:
.global mount
mount:
 li a7, SYS_mount
 56e:	48e1                	li	a7,24
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <umount>:
.global umount
umount:
 li a7, SYS_umount
 576:	48e5                	li	a7,25
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 57e:	1101                	addi	sp,sp,-32
 580:	ec06                	sd	ra,24(sp)
 582:	e822                	sd	s0,16(sp)
 584:	1000                	addi	s0,sp,32
 586:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 58a:	4605                	li	a2,1
 58c:	fef40593          	addi	a1,s0,-17
 590:	00000097          	auipc	ra,0x0
 594:	f4e080e7          	jalr	-178(ra) # 4de <write>
}
 598:	60e2                	ld	ra,24(sp)
 59a:	6442                	ld	s0,16(sp)
 59c:	6105                	addi	sp,sp,32
 59e:	8082                	ret

00000000000005a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5a0:	7139                	addi	sp,sp,-64
 5a2:	fc06                	sd	ra,56(sp)
 5a4:	f822                	sd	s0,48(sp)
 5a6:	f426                	sd	s1,40(sp)
 5a8:	f04a                	sd	s2,32(sp)
 5aa:	ec4e                	sd	s3,24(sp)
 5ac:	0080                	addi	s0,sp,64
 5ae:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5b0:	c299                	beqz	a3,5b6 <printint+0x16>
 5b2:	0805c863          	bltz	a1,642 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5b6:	2581                	sext.w	a1,a1
  neg = 0;
 5b8:	4881                	li	a7,0
 5ba:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5be:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5c0:	2601                	sext.w	a2,a2
 5c2:	00000517          	auipc	a0,0x0
 5c6:	54650513          	addi	a0,a0,1350 # b08 <digits>
 5ca:	883a                	mv	a6,a4
 5cc:	2705                	addiw	a4,a4,1
 5ce:	02c5f7bb          	remuw	a5,a1,a2
 5d2:	1782                	slli	a5,a5,0x20
 5d4:	9381                	srli	a5,a5,0x20
 5d6:	97aa                	add	a5,a5,a0
 5d8:	0007c783          	lbu	a5,0(a5)
 5dc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5e0:	0005879b          	sext.w	a5,a1
 5e4:	02c5d5bb          	divuw	a1,a1,a2
 5e8:	0685                	addi	a3,a3,1
 5ea:	fec7f0e3          	bgeu	a5,a2,5ca <printint+0x2a>
  if(neg)
 5ee:	00088b63          	beqz	a7,604 <printint+0x64>
    buf[i++] = '-';
 5f2:	fd040793          	addi	a5,s0,-48
 5f6:	973e                	add	a4,a4,a5
 5f8:	02d00793          	li	a5,45
 5fc:	fef70823          	sb	a5,-16(a4)
 600:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 604:	02e05863          	blez	a4,634 <printint+0x94>
 608:	fc040793          	addi	a5,s0,-64
 60c:	00e78933          	add	s2,a5,a4
 610:	fff78993          	addi	s3,a5,-1
 614:	99ba                	add	s3,s3,a4
 616:	377d                	addiw	a4,a4,-1
 618:	1702                	slli	a4,a4,0x20
 61a:	9301                	srli	a4,a4,0x20
 61c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 620:	fff94583          	lbu	a1,-1(s2)
 624:	8526                	mv	a0,s1
 626:	00000097          	auipc	ra,0x0
 62a:	f58080e7          	jalr	-168(ra) # 57e <putc>
  while(--i >= 0)
 62e:	197d                	addi	s2,s2,-1
 630:	ff3918e3          	bne	s2,s3,620 <printint+0x80>
}
 634:	70e2                	ld	ra,56(sp)
 636:	7442                	ld	s0,48(sp)
 638:	74a2                	ld	s1,40(sp)
 63a:	7902                	ld	s2,32(sp)
 63c:	69e2                	ld	s3,24(sp)
 63e:	6121                	addi	sp,sp,64
 640:	8082                	ret
    x = -xx;
 642:	40b005bb          	negw	a1,a1
    neg = 1;
 646:	4885                	li	a7,1
    x = -xx;
 648:	bf8d                	j	5ba <printint+0x1a>

000000000000064a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 64a:	7119                	addi	sp,sp,-128
 64c:	fc86                	sd	ra,120(sp)
 64e:	f8a2                	sd	s0,112(sp)
 650:	f4a6                	sd	s1,104(sp)
 652:	f0ca                	sd	s2,96(sp)
 654:	ecce                	sd	s3,88(sp)
 656:	e8d2                	sd	s4,80(sp)
 658:	e4d6                	sd	s5,72(sp)
 65a:	e0da                	sd	s6,64(sp)
 65c:	fc5e                	sd	s7,56(sp)
 65e:	f862                	sd	s8,48(sp)
 660:	f466                	sd	s9,40(sp)
 662:	f06a                	sd	s10,32(sp)
 664:	ec6e                	sd	s11,24(sp)
 666:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 668:	0005c903          	lbu	s2,0(a1)
 66c:	18090f63          	beqz	s2,80a <vprintf+0x1c0>
 670:	8aaa                	mv	s5,a0
 672:	8b32                	mv	s6,a2
 674:	00158493          	addi	s1,a1,1
  state = 0;
 678:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 67a:	02500a13          	li	s4,37
      if(c == 'd'){
 67e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 682:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 686:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 68a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68e:	00000b97          	auipc	s7,0x0
 692:	47ab8b93          	addi	s7,s7,1146 # b08 <digits>
 696:	a839                	j	6b4 <vprintf+0x6a>
        putc(fd, c);
 698:	85ca                	mv	a1,s2
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	ee2080e7          	jalr	-286(ra) # 57e <putc>
 6a4:	a019                	j	6aa <vprintf+0x60>
    } else if(state == '%'){
 6a6:	01498f63          	beq	s3,s4,6c4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6aa:	0485                	addi	s1,s1,1
 6ac:	fff4c903          	lbu	s2,-1(s1)
 6b0:	14090d63          	beqz	s2,80a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6b4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6b8:	fe0997e3          	bnez	s3,6a6 <vprintf+0x5c>
      if(c == '%'){
 6bc:	fd479ee3          	bne	a5,s4,698 <vprintf+0x4e>
        state = '%';
 6c0:	89be                	mv	s3,a5
 6c2:	b7e5                	j	6aa <vprintf+0x60>
      if(c == 'd'){
 6c4:	05878063          	beq	a5,s8,704 <vprintf+0xba>
      } else if(c == 'l') {
 6c8:	05978c63          	beq	a5,s9,720 <vprintf+0xd6>
      } else if(c == 'x') {
 6cc:	07a78863          	beq	a5,s10,73c <vprintf+0xf2>
      } else if(c == 'p') {
 6d0:	09b78463          	beq	a5,s11,758 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6d4:	07300713          	li	a4,115
 6d8:	0ce78663          	beq	a5,a4,7a4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6dc:	06300713          	li	a4,99
 6e0:	0ee78e63          	beq	a5,a4,7dc <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6e4:	11478863          	beq	a5,s4,7f4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6e8:	85d2                	mv	a1,s4
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	e92080e7          	jalr	-366(ra) # 57e <putc>
        putc(fd, c);
 6f4:	85ca                	mv	a1,s2
 6f6:	8556                	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	e86080e7          	jalr	-378(ra) # 57e <putc>
      }
      state = 0;
 700:	4981                	li	s3,0
 702:	b765                	j	6aa <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 704:	008b0913          	addi	s2,s6,8
 708:	4685                	li	a3,1
 70a:	4629                	li	a2,10
 70c:	000b2583          	lw	a1,0(s6)
 710:	8556                	mv	a0,s5
 712:	00000097          	auipc	ra,0x0
 716:	e8e080e7          	jalr	-370(ra) # 5a0 <printint>
 71a:	8b4a                	mv	s6,s2
      state = 0;
 71c:	4981                	li	s3,0
 71e:	b771                	j	6aa <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 720:	008b0913          	addi	s2,s6,8
 724:	4681                	li	a3,0
 726:	4629                	li	a2,10
 728:	000b2583          	lw	a1,0(s6)
 72c:	8556                	mv	a0,s5
 72e:	00000097          	auipc	ra,0x0
 732:	e72080e7          	jalr	-398(ra) # 5a0 <printint>
 736:	8b4a                	mv	s6,s2
      state = 0;
 738:	4981                	li	s3,0
 73a:	bf85                	j	6aa <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 73c:	008b0913          	addi	s2,s6,8
 740:	4681                	li	a3,0
 742:	4641                	li	a2,16
 744:	000b2583          	lw	a1,0(s6)
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	e56080e7          	jalr	-426(ra) # 5a0 <printint>
 752:	8b4a                	mv	s6,s2
      state = 0;
 754:	4981                	li	s3,0
 756:	bf91                	j	6aa <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 758:	008b0793          	addi	a5,s6,8
 75c:	f8f43423          	sd	a5,-120(s0)
 760:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 764:	03000593          	li	a1,48
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	e14080e7          	jalr	-492(ra) # 57e <putc>
  putc(fd, 'x');
 772:	85ea                	mv	a1,s10
 774:	8556                	mv	a0,s5
 776:	00000097          	auipc	ra,0x0
 77a:	e08080e7          	jalr	-504(ra) # 57e <putc>
 77e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 780:	03c9d793          	srli	a5,s3,0x3c
 784:	97de                	add	a5,a5,s7
 786:	0007c583          	lbu	a1,0(a5)
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	df2080e7          	jalr	-526(ra) # 57e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 794:	0992                	slli	s3,s3,0x4
 796:	397d                	addiw	s2,s2,-1
 798:	fe0914e3          	bnez	s2,780 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 79c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	b721                	j	6aa <vprintf+0x60>
        s = va_arg(ap, char*);
 7a4:	008b0993          	addi	s3,s6,8
 7a8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7ac:	02090163          	beqz	s2,7ce <vprintf+0x184>
        while(*s != 0){
 7b0:	00094583          	lbu	a1,0(s2)
 7b4:	c9a1                	beqz	a1,804 <vprintf+0x1ba>
          putc(fd, *s);
 7b6:	8556                	mv	a0,s5
 7b8:	00000097          	auipc	ra,0x0
 7bc:	dc6080e7          	jalr	-570(ra) # 57e <putc>
          s++;
 7c0:	0905                	addi	s2,s2,1
        while(*s != 0){
 7c2:	00094583          	lbu	a1,0(s2)
 7c6:	f9e5                	bnez	a1,7b6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7c8:	8b4e                	mv	s6,s3
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	bdf9                	j	6aa <vprintf+0x60>
          s = "(null)";
 7ce:	00000917          	auipc	s2,0x0
 7d2:	33290913          	addi	s2,s2,818 # b00 <malloc+0x1ec>
        while(*s != 0){
 7d6:	02800593          	li	a1,40
 7da:	bff1                	j	7b6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7dc:	008b0913          	addi	s2,s6,8
 7e0:	000b4583          	lbu	a1,0(s6)
 7e4:	8556                	mv	a0,s5
 7e6:	00000097          	auipc	ra,0x0
 7ea:	d98080e7          	jalr	-616(ra) # 57e <putc>
 7ee:	8b4a                	mv	s6,s2
      state = 0;
 7f0:	4981                	li	s3,0
 7f2:	bd65                	j	6aa <vprintf+0x60>
        putc(fd, c);
 7f4:	85d2                	mv	a1,s4
 7f6:	8556                	mv	a0,s5
 7f8:	00000097          	auipc	ra,0x0
 7fc:	d86080e7          	jalr	-634(ra) # 57e <putc>
      state = 0;
 800:	4981                	li	s3,0
 802:	b565                	j	6aa <vprintf+0x60>
        s = va_arg(ap, char*);
 804:	8b4e                	mv	s6,s3
      state = 0;
 806:	4981                	li	s3,0
 808:	b54d                	j	6aa <vprintf+0x60>
    }
  }
}
 80a:	70e6                	ld	ra,120(sp)
 80c:	7446                	ld	s0,112(sp)
 80e:	74a6                	ld	s1,104(sp)
 810:	7906                	ld	s2,96(sp)
 812:	69e6                	ld	s3,88(sp)
 814:	6a46                	ld	s4,80(sp)
 816:	6aa6                	ld	s5,72(sp)
 818:	6b06                	ld	s6,64(sp)
 81a:	7be2                	ld	s7,56(sp)
 81c:	7c42                	ld	s8,48(sp)
 81e:	7ca2                	ld	s9,40(sp)
 820:	7d02                	ld	s10,32(sp)
 822:	6de2                	ld	s11,24(sp)
 824:	6109                	addi	sp,sp,128
 826:	8082                	ret

0000000000000828 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 828:	715d                	addi	sp,sp,-80
 82a:	ec06                	sd	ra,24(sp)
 82c:	e822                	sd	s0,16(sp)
 82e:	1000                	addi	s0,sp,32
 830:	e010                	sd	a2,0(s0)
 832:	e414                	sd	a3,8(s0)
 834:	e818                	sd	a4,16(s0)
 836:	ec1c                	sd	a5,24(s0)
 838:	03043023          	sd	a6,32(s0)
 83c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 840:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 844:	8622                	mv	a2,s0
 846:	00000097          	auipc	ra,0x0
 84a:	e04080e7          	jalr	-508(ra) # 64a <vprintf>
}
 84e:	60e2                	ld	ra,24(sp)
 850:	6442                	ld	s0,16(sp)
 852:	6161                	addi	sp,sp,80
 854:	8082                	ret

0000000000000856 <printf>:

void
printf(const char *fmt, ...)
{
 856:	711d                	addi	sp,sp,-96
 858:	ec06                	sd	ra,24(sp)
 85a:	e822                	sd	s0,16(sp)
 85c:	1000                	addi	s0,sp,32
 85e:	e40c                	sd	a1,8(s0)
 860:	e810                	sd	a2,16(s0)
 862:	ec14                	sd	a3,24(s0)
 864:	f018                	sd	a4,32(s0)
 866:	f41c                	sd	a5,40(s0)
 868:	03043823          	sd	a6,48(s0)
 86c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 870:	00840613          	addi	a2,s0,8
 874:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 878:	85aa                	mv	a1,a0
 87a:	4505                	li	a0,1
 87c:	00000097          	auipc	ra,0x0
 880:	dce080e7          	jalr	-562(ra) # 64a <vprintf>
}
 884:	60e2                	ld	ra,24(sp)
 886:	6442                	ld	s0,16(sp)
 888:	6125                	addi	sp,sp,96
 88a:	8082                	ret

000000000000088c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 88c:	1141                	addi	sp,sp,-16
 88e:	e422                	sd	s0,8(sp)
 890:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 892:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 896:	00000797          	auipc	a5,0x0
 89a:	28a7b783          	ld	a5,650(a5) # b20 <freep>
 89e:	a805                	j	8ce <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8a0:	4618                	lw	a4,8(a2)
 8a2:	9db9                	addw	a1,a1,a4
 8a4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a8:	6398                	ld	a4,0(a5)
 8aa:	6318                	ld	a4,0(a4)
 8ac:	fee53823          	sd	a4,-16(a0)
 8b0:	a091                	j	8f4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8b2:	ff852703          	lw	a4,-8(a0)
 8b6:	9e39                	addw	a2,a2,a4
 8b8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8ba:	ff053703          	ld	a4,-16(a0)
 8be:	e398                	sd	a4,0(a5)
 8c0:	a099                	j	906 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c2:	6398                	ld	a4,0(a5)
 8c4:	00e7e463          	bltu	a5,a4,8cc <free+0x40>
 8c8:	00e6ea63          	bltu	a3,a4,8dc <free+0x50>
{
 8cc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ce:	fed7fae3          	bgeu	a5,a3,8c2 <free+0x36>
 8d2:	6398                	ld	a4,0(a5)
 8d4:	00e6e463          	bltu	a3,a4,8dc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d8:	fee7eae3          	bltu	a5,a4,8cc <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8dc:	ff852583          	lw	a1,-8(a0)
 8e0:	6390                	ld	a2,0(a5)
 8e2:	02059713          	slli	a4,a1,0x20
 8e6:	9301                	srli	a4,a4,0x20
 8e8:	0712                	slli	a4,a4,0x4
 8ea:	9736                	add	a4,a4,a3
 8ec:	fae60ae3          	beq	a2,a4,8a0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8f0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8f4:	4790                	lw	a2,8(a5)
 8f6:	02061713          	slli	a4,a2,0x20
 8fa:	9301                	srli	a4,a4,0x20
 8fc:	0712                	slli	a4,a4,0x4
 8fe:	973e                	add	a4,a4,a5
 900:	fae689e3          	beq	a3,a4,8b2 <free+0x26>
  } else
    p->s.ptr = bp;
 904:	e394                	sd	a3,0(a5)
  freep = p;
 906:	00000717          	auipc	a4,0x0
 90a:	20f73d23          	sd	a5,538(a4) # b20 <freep>
}
 90e:	6422                	ld	s0,8(sp)
 910:	0141                	addi	sp,sp,16
 912:	8082                	ret

0000000000000914 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 914:	7139                	addi	sp,sp,-64
 916:	fc06                	sd	ra,56(sp)
 918:	f822                	sd	s0,48(sp)
 91a:	f426                	sd	s1,40(sp)
 91c:	f04a                	sd	s2,32(sp)
 91e:	ec4e                	sd	s3,24(sp)
 920:	e852                	sd	s4,16(sp)
 922:	e456                	sd	s5,8(sp)
 924:	e05a                	sd	s6,0(sp)
 926:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 928:	02051493          	slli	s1,a0,0x20
 92c:	9081                	srli	s1,s1,0x20
 92e:	04bd                	addi	s1,s1,15
 930:	8091                	srli	s1,s1,0x4
 932:	0014899b          	addiw	s3,s1,1
 936:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 938:	00000517          	auipc	a0,0x0
 93c:	1e853503          	ld	a0,488(a0) # b20 <freep>
 940:	c515                	beqz	a0,96c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 942:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 944:	4798                	lw	a4,8(a5)
 946:	02977f63          	bgeu	a4,s1,984 <malloc+0x70>
 94a:	8a4e                	mv	s4,s3
 94c:	0009871b          	sext.w	a4,s3
 950:	6685                	lui	a3,0x1
 952:	00d77363          	bgeu	a4,a3,958 <malloc+0x44>
 956:	6a05                	lui	s4,0x1
 958:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 95c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 960:	00000917          	auipc	s2,0x0
 964:	1c090913          	addi	s2,s2,448 # b20 <freep>
  if(p == (char*)-1)
 968:	5afd                	li	s5,-1
 96a:	a88d                	j	9dc <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 96c:	00000797          	auipc	a5,0x0
 970:	1bc78793          	addi	a5,a5,444 # b28 <base>
 974:	00000717          	auipc	a4,0x0
 978:	1af73623          	sd	a5,428(a4) # b20 <freep>
 97c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 97e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 982:	b7e1                	j	94a <malloc+0x36>
      if(p->s.size == nunits)
 984:	02e48b63          	beq	s1,a4,9ba <malloc+0xa6>
        p->s.size -= nunits;
 988:	4137073b          	subw	a4,a4,s3
 98c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 98e:	1702                	slli	a4,a4,0x20
 990:	9301                	srli	a4,a4,0x20
 992:	0712                	slli	a4,a4,0x4
 994:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 996:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 99a:	00000717          	auipc	a4,0x0
 99e:	18a73323          	sd	a0,390(a4) # b20 <freep>
      return (void*)(p + 1);
 9a2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9a6:	70e2                	ld	ra,56(sp)
 9a8:	7442                	ld	s0,48(sp)
 9aa:	74a2                	ld	s1,40(sp)
 9ac:	7902                	ld	s2,32(sp)
 9ae:	69e2                	ld	s3,24(sp)
 9b0:	6a42                	ld	s4,16(sp)
 9b2:	6aa2                	ld	s5,8(sp)
 9b4:	6b02                	ld	s6,0(sp)
 9b6:	6121                	addi	sp,sp,64
 9b8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9ba:	6398                	ld	a4,0(a5)
 9bc:	e118                	sd	a4,0(a0)
 9be:	bff1                	j	99a <malloc+0x86>
  hp->s.size = nu;
 9c0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9c4:	0541                	addi	a0,a0,16
 9c6:	00000097          	auipc	ra,0x0
 9ca:	ec6080e7          	jalr	-314(ra) # 88c <free>
  return freep;
 9ce:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9d2:	d971                	beqz	a0,9a6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d6:	4798                	lw	a4,8(a5)
 9d8:	fa9776e3          	bgeu	a4,s1,984 <malloc+0x70>
    if(p == freep)
 9dc:	00093703          	ld	a4,0(s2)
 9e0:	853e                	mv	a0,a5
 9e2:	fef719e3          	bne	a4,a5,9d4 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9e6:	8552                	mv	a0,s4
 9e8:	00000097          	auipc	ra,0x0
 9ec:	b5e080e7          	jalr	-1186(ra) # 546 <sbrk>
  if(p == (char*)-1)
 9f0:	fd5518e3          	bne	a0,s5,9c0 <malloc+0xac>
        return 0;
 9f4:	4501                	li	a0,0
 9f6:	bf45                	j	9a6 <malloc+0x92>
