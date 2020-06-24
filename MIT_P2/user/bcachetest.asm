
user/_bcachetest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <createfile>:
  exit(0);
}

void
createfile(char *file, int nblock)
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	21513423          	sd	s5,520(sp)
  20:	0480                	addi	s0,sp,576
  22:	8a2a                	mv	s4,a0
  24:	89ae                	mv	s3,a1
  int fd;
  char buf[512];
  int i;
  
  fd = open(file, O_CREATE | O_RDWR);
  26:	20200593          	li	a1,514
  2a:	00000097          	auipc	ra,0x0
  2e:	5b8080e7          	jalr	1464(ra) # 5e2 <open>
  if(fd < 0){
  32:	04054063          	bltz	a0,72 <createfile+0x72>
  36:	892a                	mv	s2,a0
    printf("test0 create %s failed\n", file);
    exit(-1);
  }
  for(i = 0; i < nblock; i++) {
  38:	4481                	li	s1,0
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)) {
      printf("write %s failed\n", file);
  3a:	00001a97          	auipc	s5,0x1
  3e:	abea8a93          	addi	s5,s5,-1346 # af8 <malloc+0x100>
  for(i = 0; i < nblock; i++) {
  42:	05304f63          	bgtz	s3,a0 <createfile+0xa0>
    }
  }
  close(fd);
  46:	854a                	mv	a0,s2
  48:	00000097          	auipc	ra,0x0
  4c:	582080e7          	jalr	1410(ra) # 5ca <close>
}
  50:	23813083          	ld	ra,568(sp)
  54:	23013403          	ld	s0,560(sp)
  58:	22813483          	ld	s1,552(sp)
  5c:	22013903          	ld	s2,544(sp)
  60:	21813983          	ld	s3,536(sp)
  64:	21013a03          	ld	s4,528(sp)
  68:	20813a83          	ld	s5,520(sp)
  6c:	24010113          	addi	sp,sp,576
  70:	8082                	ret
    printf("test0 create %s failed\n", file);
  72:	85d2                	mv	a1,s4
  74:	00001517          	auipc	a0,0x1
  78:	a6c50513          	addi	a0,a0,-1428 # ae0 <malloc+0xe8>
  7c:	00001097          	auipc	ra,0x1
  80:	8be080e7          	jalr	-1858(ra) # 93a <printf>
    exit(-1);
  84:	557d                	li	a0,-1
  86:	00000097          	auipc	ra,0x0
  8a:	51c080e7          	jalr	1308(ra) # 5a2 <exit>
      printf("write %s failed\n", file);
  8e:	85d2                	mv	a1,s4
  90:	8556                	mv	a0,s5
  92:	00001097          	auipc	ra,0x1
  96:	8a8080e7          	jalr	-1880(ra) # 93a <printf>
  for(i = 0; i < nblock; i++) {
  9a:	2485                	addiw	s1,s1,1
  9c:	fa9985e3          	beq	s3,s1,46 <createfile+0x46>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)) {
  a0:	20000613          	li	a2,512
  a4:	dc040593          	addi	a1,s0,-576
  a8:	854a                	mv	a0,s2
  aa:	00000097          	auipc	ra,0x0
  ae:	518080e7          	jalr	1304(ra) # 5c2 <write>
  b2:	20000793          	li	a5,512
  b6:	fef502e3          	beq	a0,a5,9a <createfile+0x9a>
  ba:	bfd1                	j	8e <createfile+0x8e>

00000000000000bc <readfile>:

void
readfile(char *file, int nblock)
{
  bc:	dd010113          	addi	sp,sp,-560
  c0:	22113423          	sd	ra,552(sp)
  c4:	22813023          	sd	s0,544(sp)
  c8:	20913c23          	sd	s1,536(sp)
  cc:	21213823          	sd	s2,528(sp)
  d0:	21313423          	sd	s3,520(sp)
  d4:	21413023          	sd	s4,512(sp)
  d8:	1c00                	addi	s0,sp,560
  da:	8a2a                	mv	s4,a0
  dc:	89ae                	mv	s3,a1
  char buf[512];
  int fd;
  int i;
  
  if ((fd = open(file, O_RDONLY)) < 0) {
  de:	4581                	li	a1,0
  e0:	00000097          	auipc	ra,0x0
  e4:	502080e7          	jalr	1282(ra) # 5e2 <open>
  e8:	04054a63          	bltz	a0,13c <readfile+0x80>
  ec:	892a                	mv	s2,a0
    printf("test0 open %s failed\n", file);
    exit(-1);
  }
  for (i = 0; i < nblock; i++) {
  ee:	4481                	li	s1,0
  f0:	03305263          	blez	s3,114 <readfile+0x58>
    if(read(fd, buf, sizeof(buf)) != sizeof(buf)) {
  f4:	20000613          	li	a2,512
  f8:	dd040593          	addi	a1,s0,-560
  fc:	854a                	mv	a0,s2
  fe:	00000097          	auipc	ra,0x0
 102:	4bc080e7          	jalr	1212(ra) # 5ba <read>
 106:	20000793          	li	a5,512
 10a:	04f51763          	bne	a0,a5,158 <readfile+0x9c>
  for (i = 0; i < nblock; i++) {
 10e:	2485                	addiw	s1,s1,1
 110:	fe9992e3          	bne	s3,s1,f4 <readfile+0x38>
      printf("read %s failed for block %d (%d)\n", file, i, nblock);
      exit(-1);
    }
  }
  close(fd);
 114:	854a                	mv	a0,s2
 116:	00000097          	auipc	ra,0x0
 11a:	4b4080e7          	jalr	1204(ra) # 5ca <close>
}
 11e:	22813083          	ld	ra,552(sp)
 122:	22013403          	ld	s0,544(sp)
 126:	21813483          	ld	s1,536(sp)
 12a:	21013903          	ld	s2,528(sp)
 12e:	20813983          	ld	s3,520(sp)
 132:	20013a03          	ld	s4,512(sp)
 136:	23010113          	addi	sp,sp,560
 13a:	8082                	ret
    printf("test0 open %s failed\n", file);
 13c:	85d2                	mv	a1,s4
 13e:	00001517          	auipc	a0,0x1
 142:	9d250513          	addi	a0,a0,-1582 # b10 <malloc+0x118>
 146:	00000097          	auipc	ra,0x0
 14a:	7f4080e7          	jalr	2036(ra) # 93a <printf>
    exit(-1);
 14e:	557d                	li	a0,-1
 150:	00000097          	auipc	ra,0x0
 154:	452080e7          	jalr	1106(ra) # 5a2 <exit>
      printf("read %s failed for block %d (%d)\n", file, i, nblock);
 158:	86ce                	mv	a3,s3
 15a:	8626                	mv	a2,s1
 15c:	85d2                	mv	a1,s4
 15e:	00001517          	auipc	a0,0x1
 162:	9ca50513          	addi	a0,a0,-1590 # b28 <malloc+0x130>
 166:	00000097          	auipc	ra,0x0
 16a:	7d4080e7          	jalr	2004(ra) # 93a <printf>
      exit(-1);
 16e:	557d                	li	a0,-1
 170:	00000097          	auipc	ra,0x0
 174:	432080e7          	jalr	1074(ra) # 5a2 <exit>

0000000000000178 <test0>:

void
test0()
{
 178:	7139                	addi	sp,sp,-64
 17a:	fc06                	sd	ra,56(sp)
 17c:	f822                	sd	s0,48(sp)
 17e:	f426                	sd	s1,40(sp)
 180:	f04a                	sd	s2,32(sp)
 182:	ec4e                	sd	s3,24(sp)
 184:	0080                	addi	s0,sp,64
  char file[3];

  file[0] = 'B';
 186:	04200793          	li	a5,66
 18a:	fcf40423          	sb	a5,-56(s0)
  file[2] = '\0';
 18e:	fc040523          	sb	zero,-54(s0)

  printf("start test0\n");
 192:	00001517          	auipc	a0,0x1
 196:	9be50513          	addi	a0,a0,-1602 # b50 <malloc+0x158>
 19a:	00000097          	auipc	ra,0x0
 19e:	7a0080e7          	jalr	1952(ra) # 93a <printf>
  int n = ntas();
 1a2:	00000097          	auipc	ra,0x0
 1a6:	4a0080e7          	jalr	1184(ra) # 642 <ntas>
 1aa:	892a                	mv	s2,a0
 1ac:	03000493          	li	s1,48
  for(int i = 0; i < NCHILD; i++){
 1b0:	03300993          	li	s3,51
    file[1] = '0' + i;
 1b4:	fc9404a3          	sb	s1,-55(s0)
    createfile(file, 1);
 1b8:	4585                	li	a1,1
 1ba:	fc840513          	addi	a0,s0,-56
 1be:	00000097          	auipc	ra,0x0
 1c2:	e42080e7          	jalr	-446(ra) # 0 <createfile>
    int pid = fork();
 1c6:	00000097          	auipc	ra,0x0
 1ca:	3d4080e7          	jalr	980(ra) # 59a <fork>
    if(pid < 0){
 1ce:	04054c63          	bltz	a0,226 <test0+0xae>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 1d2:	c53d                	beqz	a0,240 <test0+0xc8>
  for(int i = 0; i < NCHILD; i++){
 1d4:	2485                	addiw	s1,s1,1
 1d6:	0ff4f493          	andi	s1,s1,255
 1da:	fd349de3          	bne	s1,s3,1b4 <test0+0x3c>
      exit(-1);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 1de:	4501                	li	a0,0
 1e0:	00000097          	auipc	ra,0x0
 1e4:	3ca080e7          	jalr	970(ra) # 5aa <wait>
 1e8:	4501                	li	a0,0
 1ea:	00000097          	auipc	ra,0x0
 1ee:	3c0080e7          	jalr	960(ra) # 5aa <wait>
 1f2:	4501                	li	a0,0
 1f4:	00000097          	auipc	ra,0x0
 1f8:	3b6080e7          	jalr	950(ra) # 5aa <wait>
  }
  printf("test0 done: #test-and-sets: %d\n", ntas() - n);
 1fc:	00000097          	auipc	ra,0x0
 200:	446080e7          	jalr	1094(ra) # 642 <ntas>
 204:	412505bb          	subw	a1,a0,s2
 208:	00001517          	auipc	a0,0x1
 20c:	96850513          	addi	a0,a0,-1688 # b70 <malloc+0x178>
 210:	00000097          	auipc	ra,0x0
 214:	72a080e7          	jalr	1834(ra) # 93a <printf>
}
 218:	70e2                	ld	ra,56(sp)
 21a:	7442                	ld	s0,48(sp)
 21c:	74a2                	ld	s1,40(sp)
 21e:	7902                	ld	s2,32(sp)
 220:	69e2                	ld	s3,24(sp)
 222:	6121                	addi	sp,sp,64
 224:	8082                	ret
      printf("fork failed");
 226:	00001517          	auipc	a0,0x1
 22a:	93a50513          	addi	a0,a0,-1734 # b60 <malloc+0x168>
 22e:	00000097          	auipc	ra,0x0
 232:	70c080e7          	jalr	1804(ra) # 93a <printf>
      exit(-1);
 236:	557d                	li	a0,-1
 238:	00000097          	auipc	ra,0x0
 23c:	36a080e7          	jalr	874(ra) # 5a2 <exit>
 240:	3e800493          	li	s1,1000
        readfile(file, 1);
 244:	4585                	li	a1,1
 246:	fc840513          	addi	a0,s0,-56
 24a:	00000097          	auipc	ra,0x0
 24e:	e72080e7          	jalr	-398(ra) # bc <readfile>
      for (i = 0; i < N; i++) {
 252:	34fd                	addiw	s1,s1,-1
 254:	f8e5                	bnez	s1,244 <test0+0xcc>
      unlink(file);
 256:	fc840513          	addi	a0,s0,-56
 25a:	00000097          	auipc	ra,0x0
 25e:	398080e7          	jalr	920(ra) # 5f2 <unlink>
      exit(-1);
 262:	557d                	li	a0,-1
 264:	00000097          	auipc	ra,0x0
 268:	33e080e7          	jalr	830(ra) # 5a2 <exit>

000000000000026c <test1>:

void test1()
{
 26c:	7179                	addi	sp,sp,-48
 26e:	f406                	sd	ra,40(sp)
 270:	f022                	sd	s0,32(sp)
 272:	ec26                	sd	s1,24(sp)
 274:	1800                	addi	s0,sp,48
  char file[3];
  
  printf("start test1\n");
 276:	00001517          	auipc	a0,0x1
 27a:	91a50513          	addi	a0,a0,-1766 # b90 <malloc+0x198>
 27e:	00000097          	auipc	ra,0x0
 282:	6bc080e7          	jalr	1724(ra) # 93a <printf>
  file[0] = 'B';
 286:	04200793          	li	a5,66
 28a:	fcf40c23          	sb	a5,-40(s0)
  file[2] = '\0';
 28e:	fc040d23          	sb	zero,-38(s0)
  for(int i = 0; i < 2; i++){
    file[1] = '0' + i;
 292:	03000493          	li	s1,48
 296:	fc940ca3          	sb	s1,-39(s0)
    if (i == 0) {
      createfile(file, BIG);
 29a:	06400593          	li	a1,100
 29e:	fd840513          	addi	a0,s0,-40
 2a2:	00000097          	auipc	ra,0x0
 2a6:	d5e080e7          	jalr	-674(ra) # 0 <createfile>
    file[1] = '0' + i;
 2aa:	03100793          	li	a5,49
 2ae:	fcf40ca3          	sb	a5,-39(s0)
    } else {
      createfile(file, 1);
 2b2:	4585                	li	a1,1
 2b4:	fd840513          	addi	a0,s0,-40
 2b8:	00000097          	auipc	ra,0x0
 2bc:	d48080e7          	jalr	-696(ra) # 0 <createfile>
    }
  }
  for(int i = 0; i < 2; i++){
    file[1] = '0' + i;
 2c0:	fc940ca3          	sb	s1,-39(s0)
    int pid = fork();
 2c4:	00000097          	auipc	ra,0x0
 2c8:	2d6080e7          	jalr	726(ra) # 59a <fork>
    if(pid < 0){
 2cc:	04054563          	bltz	a0,316 <test1+0xaa>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 2d0:	c125                	beqz	a0,330 <test1+0xc4>
    file[1] = '0' + i;
 2d2:	03100793          	li	a5,49
 2d6:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
 2da:	00000097          	auipc	ra,0x0
 2de:	2c0080e7          	jalr	704(ra) # 59a <fork>
    if(pid < 0){
 2e2:	02054a63          	bltz	a0,316 <test1+0xaa>
    if(pid == 0){
 2e6:	cd25                	beqz	a0,35e <test1+0xf2>
      exit(0);
    }
  }

  for(int i = 0; i < 2; i++){
    wait(0);
 2e8:	4501                	li	a0,0
 2ea:	00000097          	auipc	ra,0x0
 2ee:	2c0080e7          	jalr	704(ra) # 5aa <wait>
 2f2:	4501                	li	a0,0
 2f4:	00000097          	auipc	ra,0x0
 2f8:	2b6080e7          	jalr	694(ra) # 5aa <wait>
  }
  printf("test1 done\n");
 2fc:	00001517          	auipc	a0,0x1
 300:	8a450513          	addi	a0,a0,-1884 # ba0 <malloc+0x1a8>
 304:	00000097          	auipc	ra,0x0
 308:	636080e7          	jalr	1590(ra) # 93a <printf>
}
 30c:	70a2                	ld	ra,40(sp)
 30e:	7402                	ld	s0,32(sp)
 310:	64e2                	ld	s1,24(sp)
 312:	6145                	addi	sp,sp,48
 314:	8082                	ret
      printf("fork failed");
 316:	00001517          	auipc	a0,0x1
 31a:	84a50513          	addi	a0,a0,-1974 # b60 <malloc+0x168>
 31e:	00000097          	auipc	ra,0x0
 322:	61c080e7          	jalr	1564(ra) # 93a <printf>
      exit(-1);
 326:	557d                	li	a0,-1
 328:	00000097          	auipc	ra,0x0
 32c:	27a080e7          	jalr	634(ra) # 5a2 <exit>
    if(pid == 0){
 330:	3e800493          	li	s1,1000
          readfile(file, BIG);
 334:	06400593          	li	a1,100
 338:	fd840513          	addi	a0,s0,-40
 33c:	00000097          	auipc	ra,0x0
 340:	d80080e7          	jalr	-640(ra) # bc <readfile>
        for (i = 0; i < N; i++) {
 344:	34fd                	addiw	s1,s1,-1
 346:	f4fd                	bnez	s1,334 <test1+0xc8>
        unlink(file);
 348:	fd840513          	addi	a0,s0,-40
 34c:	00000097          	auipc	ra,0x0
 350:	2a6080e7          	jalr	678(ra) # 5f2 <unlink>
        exit(0);
 354:	4501                	li	a0,0
 356:	00000097          	auipc	ra,0x0
 35a:	24c080e7          	jalr	588(ra) # 5a2 <exit>
 35e:	3e800493          	li	s1,1000
          readfile(file, 1);
 362:	4585                	li	a1,1
 364:	fd840513          	addi	a0,s0,-40
 368:	00000097          	auipc	ra,0x0
 36c:	d54080e7          	jalr	-684(ra) # bc <readfile>
        for (i = 0; i < N; i++) {
 370:	34fd                	addiw	s1,s1,-1
 372:	f8e5                	bnez	s1,362 <test1+0xf6>
        unlink(file);
 374:	fd840513          	addi	a0,s0,-40
 378:	00000097          	auipc	ra,0x0
 37c:	27a080e7          	jalr	634(ra) # 5f2 <unlink>
      exit(0);
 380:	4501                	li	a0,0
 382:	00000097          	auipc	ra,0x0
 386:	220080e7          	jalr	544(ra) # 5a2 <exit>

000000000000038a <main>:
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  test0();
 392:	00000097          	auipc	ra,0x0
 396:	de6080e7          	jalr	-538(ra) # 178 <test0>
  test1();
 39a:	00000097          	auipc	ra,0x0
 39e:	ed2080e7          	jalr	-302(ra) # 26c <test1>
  exit(0);
 3a2:	4501                	li	a0,0
 3a4:	00000097          	auipc	ra,0x0
 3a8:	1fe080e7          	jalr	510(ra) # 5a2 <exit>

00000000000003ac <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e422                	sd	s0,8(sp)
 3b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3b2:	87aa                	mv	a5,a0
 3b4:	0585                	addi	a1,a1,1
 3b6:	0785                	addi	a5,a5,1
 3b8:	fff5c703          	lbu	a4,-1(a1)
 3bc:	fee78fa3          	sb	a4,-1(a5)
 3c0:	fb75                	bnez	a4,3b4 <strcpy+0x8>
    ;
  return os;
}
 3c2:	6422                	ld	s0,8(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret

00000000000003c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3c8:	1141                	addi	sp,sp,-16
 3ca:	e422                	sd	s0,8(sp)
 3cc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3ce:	00054783          	lbu	a5,0(a0)
 3d2:	cb91                	beqz	a5,3e6 <strcmp+0x1e>
 3d4:	0005c703          	lbu	a4,0(a1)
 3d8:	00f71763          	bne	a4,a5,3e6 <strcmp+0x1e>
    p++, q++;
 3dc:	0505                	addi	a0,a0,1
 3de:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3e0:	00054783          	lbu	a5,0(a0)
 3e4:	fbe5                	bnez	a5,3d4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 3e6:	0005c503          	lbu	a0,0(a1)
}
 3ea:	40a7853b          	subw	a0,a5,a0
 3ee:	6422                	ld	s0,8(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret

00000000000003f4 <strlen>:

uint
strlen(const char *s)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e422                	sd	s0,8(sp)
 3f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3fa:	00054783          	lbu	a5,0(a0)
 3fe:	cf91                	beqz	a5,41a <strlen+0x26>
 400:	0505                	addi	a0,a0,1
 402:	87aa                	mv	a5,a0
 404:	4685                	li	a3,1
 406:	9e89                	subw	a3,a3,a0
 408:	00f6853b          	addw	a0,a3,a5
 40c:	0785                	addi	a5,a5,1
 40e:	fff7c703          	lbu	a4,-1(a5)
 412:	fb7d                	bnez	a4,408 <strlen+0x14>
    ;
  return n;
}
 414:	6422                	ld	s0,8(sp)
 416:	0141                	addi	sp,sp,16
 418:	8082                	ret
  for(n = 0; s[n]; n++)
 41a:	4501                	li	a0,0
 41c:	bfe5                	j	414 <strlen+0x20>

000000000000041e <memset>:

void*
memset(void *dst, int c, uint n)
{
 41e:	1141                	addi	sp,sp,-16
 420:	e422                	sd	s0,8(sp)
 422:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 424:	ce09                	beqz	a2,43e <memset+0x20>
 426:	87aa                	mv	a5,a0
 428:	fff6071b          	addiw	a4,a2,-1
 42c:	1702                	slli	a4,a4,0x20
 42e:	9301                	srli	a4,a4,0x20
 430:	0705                	addi	a4,a4,1
 432:	972a                	add	a4,a4,a0
    cdst[i] = c;
 434:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 438:	0785                	addi	a5,a5,1
 43a:	fee79de3          	bne	a5,a4,434 <memset+0x16>
  }
  return dst;
}
 43e:	6422                	ld	s0,8(sp)
 440:	0141                	addi	sp,sp,16
 442:	8082                	ret

0000000000000444 <strchr>:

char*
strchr(const char *s, char c)
{
 444:	1141                	addi	sp,sp,-16
 446:	e422                	sd	s0,8(sp)
 448:	0800                	addi	s0,sp,16
  for(; *s; s++)
 44a:	00054783          	lbu	a5,0(a0)
 44e:	cb99                	beqz	a5,464 <strchr+0x20>
    if(*s == c)
 450:	00f58763          	beq	a1,a5,45e <strchr+0x1a>
  for(; *s; s++)
 454:	0505                	addi	a0,a0,1
 456:	00054783          	lbu	a5,0(a0)
 45a:	fbfd                	bnez	a5,450 <strchr+0xc>
      return (char*)s;
  return 0;
 45c:	4501                	li	a0,0
}
 45e:	6422                	ld	s0,8(sp)
 460:	0141                	addi	sp,sp,16
 462:	8082                	ret
  return 0;
 464:	4501                	li	a0,0
 466:	bfe5                	j	45e <strchr+0x1a>

0000000000000468 <gets>:

char*
gets(char *buf, int max)
{
 468:	711d                	addi	sp,sp,-96
 46a:	ec86                	sd	ra,88(sp)
 46c:	e8a2                	sd	s0,80(sp)
 46e:	e4a6                	sd	s1,72(sp)
 470:	e0ca                	sd	s2,64(sp)
 472:	fc4e                	sd	s3,56(sp)
 474:	f852                	sd	s4,48(sp)
 476:	f456                	sd	s5,40(sp)
 478:	f05a                	sd	s6,32(sp)
 47a:	ec5e                	sd	s7,24(sp)
 47c:	1080                	addi	s0,sp,96
 47e:	8baa                	mv	s7,a0
 480:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 482:	892a                	mv	s2,a0
 484:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 486:	4aa9                	li	s5,10
 488:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 48a:	89a6                	mv	s3,s1
 48c:	2485                	addiw	s1,s1,1
 48e:	0344d863          	bge	s1,s4,4be <gets+0x56>
    cc = read(0, &c, 1);
 492:	4605                	li	a2,1
 494:	faf40593          	addi	a1,s0,-81
 498:	4501                	li	a0,0
 49a:	00000097          	auipc	ra,0x0
 49e:	120080e7          	jalr	288(ra) # 5ba <read>
    if(cc < 1)
 4a2:	00a05e63          	blez	a0,4be <gets+0x56>
    buf[i++] = c;
 4a6:	faf44783          	lbu	a5,-81(s0)
 4aa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4ae:	01578763          	beq	a5,s5,4bc <gets+0x54>
 4b2:	0905                	addi	s2,s2,1
 4b4:	fd679be3          	bne	a5,s6,48a <gets+0x22>
  for(i=0; i+1 < max; ){
 4b8:	89a6                	mv	s3,s1
 4ba:	a011                	j	4be <gets+0x56>
 4bc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4be:	99de                	add	s3,s3,s7
 4c0:	00098023          	sb	zero,0(s3)
  return buf;
}
 4c4:	855e                	mv	a0,s7
 4c6:	60e6                	ld	ra,88(sp)
 4c8:	6446                	ld	s0,80(sp)
 4ca:	64a6                	ld	s1,72(sp)
 4cc:	6906                	ld	s2,64(sp)
 4ce:	79e2                	ld	s3,56(sp)
 4d0:	7a42                	ld	s4,48(sp)
 4d2:	7aa2                	ld	s5,40(sp)
 4d4:	7b02                	ld	s6,32(sp)
 4d6:	6be2                	ld	s7,24(sp)
 4d8:	6125                	addi	sp,sp,96
 4da:	8082                	ret

00000000000004dc <stat>:

int
stat(const char *n, struct stat *st)
{
 4dc:	1101                	addi	sp,sp,-32
 4de:	ec06                	sd	ra,24(sp)
 4e0:	e822                	sd	s0,16(sp)
 4e2:	e426                	sd	s1,8(sp)
 4e4:	e04a                	sd	s2,0(sp)
 4e6:	1000                	addi	s0,sp,32
 4e8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4ea:	4581                	li	a1,0
 4ec:	00000097          	auipc	ra,0x0
 4f0:	0f6080e7          	jalr	246(ra) # 5e2 <open>
  if(fd < 0)
 4f4:	02054563          	bltz	a0,51e <stat+0x42>
 4f8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4fa:	85ca                	mv	a1,s2
 4fc:	00000097          	auipc	ra,0x0
 500:	0fe080e7          	jalr	254(ra) # 5fa <fstat>
 504:	892a                	mv	s2,a0
  close(fd);
 506:	8526                	mv	a0,s1
 508:	00000097          	auipc	ra,0x0
 50c:	0c2080e7          	jalr	194(ra) # 5ca <close>
  return r;
}
 510:	854a                	mv	a0,s2
 512:	60e2                	ld	ra,24(sp)
 514:	6442                	ld	s0,16(sp)
 516:	64a2                	ld	s1,8(sp)
 518:	6902                	ld	s2,0(sp)
 51a:	6105                	addi	sp,sp,32
 51c:	8082                	ret
    return -1;
 51e:	597d                	li	s2,-1
 520:	bfc5                	j	510 <stat+0x34>

0000000000000522 <atoi>:

int
atoi(const char *s)
{
 522:	1141                	addi	sp,sp,-16
 524:	e422                	sd	s0,8(sp)
 526:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 528:	00054603          	lbu	a2,0(a0)
 52c:	fd06079b          	addiw	a5,a2,-48
 530:	0ff7f793          	andi	a5,a5,255
 534:	4725                	li	a4,9
 536:	02f76963          	bltu	a4,a5,568 <atoi+0x46>
 53a:	86aa                	mv	a3,a0
  n = 0;
 53c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 53e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 540:	0685                	addi	a3,a3,1
 542:	0025179b          	slliw	a5,a0,0x2
 546:	9fa9                	addw	a5,a5,a0
 548:	0017979b          	slliw	a5,a5,0x1
 54c:	9fb1                	addw	a5,a5,a2
 54e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 552:	0006c603          	lbu	a2,0(a3)
 556:	fd06071b          	addiw	a4,a2,-48
 55a:	0ff77713          	andi	a4,a4,255
 55e:	fee5f1e3          	bgeu	a1,a4,540 <atoi+0x1e>
  return n;
}
 562:	6422                	ld	s0,8(sp)
 564:	0141                	addi	sp,sp,16
 566:	8082                	ret
  n = 0;
 568:	4501                	li	a0,0
 56a:	bfe5                	j	562 <atoi+0x40>

000000000000056c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 56c:	1141                	addi	sp,sp,-16
 56e:	e422                	sd	s0,8(sp)
 570:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 572:	02c05163          	blez	a2,594 <memmove+0x28>
 576:	fff6071b          	addiw	a4,a2,-1
 57a:	1702                	slli	a4,a4,0x20
 57c:	9301                	srli	a4,a4,0x20
 57e:	0705                	addi	a4,a4,1
 580:	972a                	add	a4,a4,a0
  dst = vdst;
 582:	87aa                	mv	a5,a0
    *dst++ = *src++;
 584:	0585                	addi	a1,a1,1
 586:	0785                	addi	a5,a5,1
 588:	fff5c683          	lbu	a3,-1(a1)
 58c:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 590:	fee79ae3          	bne	a5,a4,584 <memmove+0x18>
  return vdst;
}
 594:	6422                	ld	s0,8(sp)
 596:	0141                	addi	sp,sp,16
 598:	8082                	ret

000000000000059a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 59a:	4885                	li	a7,1
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5a2:	4889                	li	a7,2
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <wait>:
.global wait
wait:
 li a7, SYS_wait
 5aa:	488d                	li	a7,3
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5b2:	4891                	li	a7,4
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <read>:
.global read
read:
 li a7, SYS_read
 5ba:	4895                	li	a7,5
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <write>:
.global write
write:
 li a7, SYS_write
 5c2:	48c1                	li	a7,16
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <close>:
.global close
close:
 li a7, SYS_close
 5ca:	48d5                	li	a7,21
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5d2:	4899                	li	a7,6
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <exec>:
.global exec
exec:
 li a7, SYS_exec
 5da:	489d                	li	a7,7
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <open>:
.global open
open:
 li a7, SYS_open
 5e2:	48bd                	li	a7,15
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5ea:	48c5                	li	a7,17
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5f2:	48c9                	li	a7,18
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5fa:	48a1                	li	a7,8
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <link>:
.global link
link:
 li a7, SYS_link
 602:	48cd                	li	a7,19
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 60a:	48d1                	li	a7,20
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 612:	48a5                	li	a7,9
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <dup>:
.global dup
dup:
 li a7, SYS_dup
 61a:	48a9                	li	a7,10
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 622:	48ad                	li	a7,11
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 62a:	48b1                	li	a7,12
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 632:	48b5                	li	a7,13
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 63a:	48b9                	li	a7,14
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 642:	48d9                	li	a7,22
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <crash>:
.global crash
crash:
 li a7, SYS_crash
 64a:	48dd                	li	a7,23
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <mount>:
.global mount
mount:
 li a7, SYS_mount
 652:	48e1                	li	a7,24
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <umount>:
.global umount
umount:
 li a7, SYS_umount
 65a:	48e5                	li	a7,25
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 662:	1101                	addi	sp,sp,-32
 664:	ec06                	sd	ra,24(sp)
 666:	e822                	sd	s0,16(sp)
 668:	1000                	addi	s0,sp,32
 66a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 66e:	4605                	li	a2,1
 670:	fef40593          	addi	a1,s0,-17
 674:	00000097          	auipc	ra,0x0
 678:	f4e080e7          	jalr	-178(ra) # 5c2 <write>
}
 67c:	60e2                	ld	ra,24(sp)
 67e:	6442                	ld	s0,16(sp)
 680:	6105                	addi	sp,sp,32
 682:	8082                	ret

0000000000000684 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 684:	7139                	addi	sp,sp,-64
 686:	fc06                	sd	ra,56(sp)
 688:	f822                	sd	s0,48(sp)
 68a:	f426                	sd	s1,40(sp)
 68c:	f04a                	sd	s2,32(sp)
 68e:	ec4e                	sd	s3,24(sp)
 690:	0080                	addi	s0,sp,64
 692:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 694:	c299                	beqz	a3,69a <printint+0x16>
 696:	0805c863          	bltz	a1,726 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 69a:	2581                	sext.w	a1,a1
  neg = 0;
 69c:	4881                	li	a7,0
 69e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6a2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6a4:	2601                	sext.w	a2,a2
 6a6:	00000517          	auipc	a0,0x0
 6aa:	51250513          	addi	a0,a0,1298 # bb8 <digits>
 6ae:	883a                	mv	a6,a4
 6b0:	2705                	addiw	a4,a4,1
 6b2:	02c5f7bb          	remuw	a5,a1,a2
 6b6:	1782                	slli	a5,a5,0x20
 6b8:	9381                	srli	a5,a5,0x20
 6ba:	97aa                	add	a5,a5,a0
 6bc:	0007c783          	lbu	a5,0(a5)
 6c0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6c4:	0005879b          	sext.w	a5,a1
 6c8:	02c5d5bb          	divuw	a1,a1,a2
 6cc:	0685                	addi	a3,a3,1
 6ce:	fec7f0e3          	bgeu	a5,a2,6ae <printint+0x2a>
  if(neg)
 6d2:	00088b63          	beqz	a7,6e8 <printint+0x64>
    buf[i++] = '-';
 6d6:	fd040793          	addi	a5,s0,-48
 6da:	973e                	add	a4,a4,a5
 6dc:	02d00793          	li	a5,45
 6e0:	fef70823          	sb	a5,-16(a4)
 6e4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6e8:	02e05863          	blez	a4,718 <printint+0x94>
 6ec:	fc040793          	addi	a5,s0,-64
 6f0:	00e78933          	add	s2,a5,a4
 6f4:	fff78993          	addi	s3,a5,-1
 6f8:	99ba                	add	s3,s3,a4
 6fa:	377d                	addiw	a4,a4,-1
 6fc:	1702                	slli	a4,a4,0x20
 6fe:	9301                	srli	a4,a4,0x20
 700:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 704:	fff94583          	lbu	a1,-1(s2)
 708:	8526                	mv	a0,s1
 70a:	00000097          	auipc	ra,0x0
 70e:	f58080e7          	jalr	-168(ra) # 662 <putc>
  while(--i >= 0)
 712:	197d                	addi	s2,s2,-1
 714:	ff3918e3          	bne	s2,s3,704 <printint+0x80>
}
 718:	70e2                	ld	ra,56(sp)
 71a:	7442                	ld	s0,48(sp)
 71c:	74a2                	ld	s1,40(sp)
 71e:	7902                	ld	s2,32(sp)
 720:	69e2                	ld	s3,24(sp)
 722:	6121                	addi	sp,sp,64
 724:	8082                	ret
    x = -xx;
 726:	40b005bb          	negw	a1,a1
    neg = 1;
 72a:	4885                	li	a7,1
    x = -xx;
 72c:	bf8d                	j	69e <printint+0x1a>

000000000000072e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 72e:	7119                	addi	sp,sp,-128
 730:	fc86                	sd	ra,120(sp)
 732:	f8a2                	sd	s0,112(sp)
 734:	f4a6                	sd	s1,104(sp)
 736:	f0ca                	sd	s2,96(sp)
 738:	ecce                	sd	s3,88(sp)
 73a:	e8d2                	sd	s4,80(sp)
 73c:	e4d6                	sd	s5,72(sp)
 73e:	e0da                	sd	s6,64(sp)
 740:	fc5e                	sd	s7,56(sp)
 742:	f862                	sd	s8,48(sp)
 744:	f466                	sd	s9,40(sp)
 746:	f06a                	sd	s10,32(sp)
 748:	ec6e                	sd	s11,24(sp)
 74a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 74c:	0005c903          	lbu	s2,0(a1)
 750:	18090f63          	beqz	s2,8ee <vprintf+0x1c0>
 754:	8aaa                	mv	s5,a0
 756:	8b32                	mv	s6,a2
 758:	00158493          	addi	s1,a1,1
  state = 0;
 75c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 75e:	02500a13          	li	s4,37
      if(c == 'd'){
 762:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 766:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 76a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 76e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 772:	00000b97          	auipc	s7,0x0
 776:	446b8b93          	addi	s7,s7,1094 # bb8 <digits>
 77a:	a839                	j	798 <vprintf+0x6a>
        putc(fd, c);
 77c:	85ca                	mv	a1,s2
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	ee2080e7          	jalr	-286(ra) # 662 <putc>
 788:	a019                	j	78e <vprintf+0x60>
    } else if(state == '%'){
 78a:	01498f63          	beq	s3,s4,7a8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 78e:	0485                	addi	s1,s1,1
 790:	fff4c903          	lbu	s2,-1(s1)
 794:	14090d63          	beqz	s2,8ee <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 798:	0009079b          	sext.w	a5,s2
    if(state == 0){
 79c:	fe0997e3          	bnez	s3,78a <vprintf+0x5c>
      if(c == '%'){
 7a0:	fd479ee3          	bne	a5,s4,77c <vprintf+0x4e>
        state = '%';
 7a4:	89be                	mv	s3,a5
 7a6:	b7e5                	j	78e <vprintf+0x60>
      if(c == 'd'){
 7a8:	05878063          	beq	a5,s8,7e8 <vprintf+0xba>
      } else if(c == 'l') {
 7ac:	05978c63          	beq	a5,s9,804 <vprintf+0xd6>
      } else if(c == 'x') {
 7b0:	07a78863          	beq	a5,s10,820 <vprintf+0xf2>
      } else if(c == 'p') {
 7b4:	09b78463          	beq	a5,s11,83c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 7b8:	07300713          	li	a4,115
 7bc:	0ce78663          	beq	a5,a4,888 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7c0:	06300713          	li	a4,99
 7c4:	0ee78e63          	beq	a5,a4,8c0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 7c8:	11478863          	beq	a5,s4,8d8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7cc:	85d2                	mv	a1,s4
 7ce:	8556                	mv	a0,s5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	e92080e7          	jalr	-366(ra) # 662 <putc>
        putc(fd, c);
 7d8:	85ca                	mv	a1,s2
 7da:	8556                	mv	a0,s5
 7dc:	00000097          	auipc	ra,0x0
 7e0:	e86080e7          	jalr	-378(ra) # 662 <putc>
      }
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	b765                	j	78e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7e8:	008b0913          	addi	s2,s6,8
 7ec:	4685                	li	a3,1
 7ee:	4629                	li	a2,10
 7f0:	000b2583          	lw	a1,0(s6)
 7f4:	8556                	mv	a0,s5
 7f6:	00000097          	auipc	ra,0x0
 7fa:	e8e080e7          	jalr	-370(ra) # 684 <printint>
 7fe:	8b4a                	mv	s6,s2
      state = 0;
 800:	4981                	li	s3,0
 802:	b771                	j	78e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 804:	008b0913          	addi	s2,s6,8
 808:	4681                	li	a3,0
 80a:	4629                	li	a2,10
 80c:	000b2583          	lw	a1,0(s6)
 810:	8556                	mv	a0,s5
 812:	00000097          	auipc	ra,0x0
 816:	e72080e7          	jalr	-398(ra) # 684 <printint>
 81a:	8b4a                	mv	s6,s2
      state = 0;
 81c:	4981                	li	s3,0
 81e:	bf85                	j	78e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 820:	008b0913          	addi	s2,s6,8
 824:	4681                	li	a3,0
 826:	4641                	li	a2,16
 828:	000b2583          	lw	a1,0(s6)
 82c:	8556                	mv	a0,s5
 82e:	00000097          	auipc	ra,0x0
 832:	e56080e7          	jalr	-426(ra) # 684 <printint>
 836:	8b4a                	mv	s6,s2
      state = 0;
 838:	4981                	li	s3,0
 83a:	bf91                	j	78e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 83c:	008b0793          	addi	a5,s6,8
 840:	f8f43423          	sd	a5,-120(s0)
 844:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 848:	03000593          	li	a1,48
 84c:	8556                	mv	a0,s5
 84e:	00000097          	auipc	ra,0x0
 852:	e14080e7          	jalr	-492(ra) # 662 <putc>
  putc(fd, 'x');
 856:	85ea                	mv	a1,s10
 858:	8556                	mv	a0,s5
 85a:	00000097          	auipc	ra,0x0
 85e:	e08080e7          	jalr	-504(ra) # 662 <putc>
 862:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 864:	03c9d793          	srli	a5,s3,0x3c
 868:	97de                	add	a5,a5,s7
 86a:	0007c583          	lbu	a1,0(a5)
 86e:	8556                	mv	a0,s5
 870:	00000097          	auipc	ra,0x0
 874:	df2080e7          	jalr	-526(ra) # 662 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 878:	0992                	slli	s3,s3,0x4
 87a:	397d                	addiw	s2,s2,-1
 87c:	fe0914e3          	bnez	s2,864 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 880:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 884:	4981                	li	s3,0
 886:	b721                	j	78e <vprintf+0x60>
        s = va_arg(ap, char*);
 888:	008b0993          	addi	s3,s6,8
 88c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 890:	02090163          	beqz	s2,8b2 <vprintf+0x184>
        while(*s != 0){
 894:	00094583          	lbu	a1,0(s2)
 898:	c9a1                	beqz	a1,8e8 <vprintf+0x1ba>
          putc(fd, *s);
 89a:	8556                	mv	a0,s5
 89c:	00000097          	auipc	ra,0x0
 8a0:	dc6080e7          	jalr	-570(ra) # 662 <putc>
          s++;
 8a4:	0905                	addi	s2,s2,1
        while(*s != 0){
 8a6:	00094583          	lbu	a1,0(s2)
 8aa:	f9e5                	bnez	a1,89a <vprintf+0x16c>
        s = va_arg(ap, char*);
 8ac:	8b4e                	mv	s6,s3
      state = 0;
 8ae:	4981                	li	s3,0
 8b0:	bdf9                	j	78e <vprintf+0x60>
          s = "(null)";
 8b2:	00000917          	auipc	s2,0x0
 8b6:	2fe90913          	addi	s2,s2,766 # bb0 <malloc+0x1b8>
        while(*s != 0){
 8ba:	02800593          	li	a1,40
 8be:	bff1                	j	89a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 8c0:	008b0913          	addi	s2,s6,8
 8c4:	000b4583          	lbu	a1,0(s6)
 8c8:	8556                	mv	a0,s5
 8ca:	00000097          	auipc	ra,0x0
 8ce:	d98080e7          	jalr	-616(ra) # 662 <putc>
 8d2:	8b4a                	mv	s6,s2
      state = 0;
 8d4:	4981                	li	s3,0
 8d6:	bd65                	j	78e <vprintf+0x60>
        putc(fd, c);
 8d8:	85d2                	mv	a1,s4
 8da:	8556                	mv	a0,s5
 8dc:	00000097          	auipc	ra,0x0
 8e0:	d86080e7          	jalr	-634(ra) # 662 <putc>
      state = 0;
 8e4:	4981                	li	s3,0
 8e6:	b565                	j	78e <vprintf+0x60>
        s = va_arg(ap, char*);
 8e8:	8b4e                	mv	s6,s3
      state = 0;
 8ea:	4981                	li	s3,0
 8ec:	b54d                	j	78e <vprintf+0x60>
    }
  }
}
 8ee:	70e6                	ld	ra,120(sp)
 8f0:	7446                	ld	s0,112(sp)
 8f2:	74a6                	ld	s1,104(sp)
 8f4:	7906                	ld	s2,96(sp)
 8f6:	69e6                	ld	s3,88(sp)
 8f8:	6a46                	ld	s4,80(sp)
 8fa:	6aa6                	ld	s5,72(sp)
 8fc:	6b06                	ld	s6,64(sp)
 8fe:	7be2                	ld	s7,56(sp)
 900:	7c42                	ld	s8,48(sp)
 902:	7ca2                	ld	s9,40(sp)
 904:	7d02                	ld	s10,32(sp)
 906:	6de2                	ld	s11,24(sp)
 908:	6109                	addi	sp,sp,128
 90a:	8082                	ret

000000000000090c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 90c:	715d                	addi	sp,sp,-80
 90e:	ec06                	sd	ra,24(sp)
 910:	e822                	sd	s0,16(sp)
 912:	1000                	addi	s0,sp,32
 914:	e010                	sd	a2,0(s0)
 916:	e414                	sd	a3,8(s0)
 918:	e818                	sd	a4,16(s0)
 91a:	ec1c                	sd	a5,24(s0)
 91c:	03043023          	sd	a6,32(s0)
 920:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 924:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 928:	8622                	mv	a2,s0
 92a:	00000097          	auipc	ra,0x0
 92e:	e04080e7          	jalr	-508(ra) # 72e <vprintf>
}
 932:	60e2                	ld	ra,24(sp)
 934:	6442                	ld	s0,16(sp)
 936:	6161                	addi	sp,sp,80
 938:	8082                	ret

000000000000093a <printf>:

void
printf(const char *fmt, ...)
{
 93a:	711d                	addi	sp,sp,-96
 93c:	ec06                	sd	ra,24(sp)
 93e:	e822                	sd	s0,16(sp)
 940:	1000                	addi	s0,sp,32
 942:	e40c                	sd	a1,8(s0)
 944:	e810                	sd	a2,16(s0)
 946:	ec14                	sd	a3,24(s0)
 948:	f018                	sd	a4,32(s0)
 94a:	f41c                	sd	a5,40(s0)
 94c:	03043823          	sd	a6,48(s0)
 950:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 954:	00840613          	addi	a2,s0,8
 958:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 95c:	85aa                	mv	a1,a0
 95e:	4505                	li	a0,1
 960:	00000097          	auipc	ra,0x0
 964:	dce080e7          	jalr	-562(ra) # 72e <vprintf>
}
 968:	60e2                	ld	ra,24(sp)
 96a:	6442                	ld	s0,16(sp)
 96c:	6125                	addi	sp,sp,96
 96e:	8082                	ret

0000000000000970 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 970:	1141                	addi	sp,sp,-16
 972:	e422                	sd	s0,8(sp)
 974:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 976:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 97a:	00000797          	auipc	a5,0x0
 97e:	2567b783          	ld	a5,598(a5) # bd0 <freep>
 982:	a805                	j	9b2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 984:	4618                	lw	a4,8(a2)
 986:	9db9                	addw	a1,a1,a4
 988:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 98c:	6398                	ld	a4,0(a5)
 98e:	6318                	ld	a4,0(a4)
 990:	fee53823          	sd	a4,-16(a0)
 994:	a091                	j	9d8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 996:	ff852703          	lw	a4,-8(a0)
 99a:	9e39                	addw	a2,a2,a4
 99c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 99e:	ff053703          	ld	a4,-16(a0)
 9a2:	e398                	sd	a4,0(a5)
 9a4:	a099                	j	9ea <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a6:	6398                	ld	a4,0(a5)
 9a8:	00e7e463          	bltu	a5,a4,9b0 <free+0x40>
 9ac:	00e6ea63          	bltu	a3,a4,9c0 <free+0x50>
{
 9b0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b2:	fed7fae3          	bgeu	a5,a3,9a6 <free+0x36>
 9b6:	6398                	ld	a4,0(a5)
 9b8:	00e6e463          	bltu	a3,a4,9c0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9bc:	fee7eae3          	bltu	a5,a4,9b0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 9c0:	ff852583          	lw	a1,-8(a0)
 9c4:	6390                	ld	a2,0(a5)
 9c6:	02059713          	slli	a4,a1,0x20
 9ca:	9301                	srli	a4,a4,0x20
 9cc:	0712                	slli	a4,a4,0x4
 9ce:	9736                	add	a4,a4,a3
 9d0:	fae60ae3          	beq	a2,a4,984 <free+0x14>
    bp->s.ptr = p->s.ptr;
 9d4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9d8:	4790                	lw	a2,8(a5)
 9da:	02061713          	slli	a4,a2,0x20
 9de:	9301                	srli	a4,a4,0x20
 9e0:	0712                	slli	a4,a4,0x4
 9e2:	973e                	add	a4,a4,a5
 9e4:	fae689e3          	beq	a3,a4,996 <free+0x26>
  } else
    p->s.ptr = bp;
 9e8:	e394                	sd	a3,0(a5)
  freep = p;
 9ea:	00000717          	auipc	a4,0x0
 9ee:	1ef73323          	sd	a5,486(a4) # bd0 <freep>
}
 9f2:	6422                	ld	s0,8(sp)
 9f4:	0141                	addi	sp,sp,16
 9f6:	8082                	ret

00000000000009f8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9f8:	7139                	addi	sp,sp,-64
 9fa:	fc06                	sd	ra,56(sp)
 9fc:	f822                	sd	s0,48(sp)
 9fe:	f426                	sd	s1,40(sp)
 a00:	f04a                	sd	s2,32(sp)
 a02:	ec4e                	sd	s3,24(sp)
 a04:	e852                	sd	s4,16(sp)
 a06:	e456                	sd	s5,8(sp)
 a08:	e05a                	sd	s6,0(sp)
 a0a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a0c:	02051493          	slli	s1,a0,0x20
 a10:	9081                	srli	s1,s1,0x20
 a12:	04bd                	addi	s1,s1,15
 a14:	8091                	srli	s1,s1,0x4
 a16:	0014899b          	addiw	s3,s1,1
 a1a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a1c:	00000517          	auipc	a0,0x0
 a20:	1b453503          	ld	a0,436(a0) # bd0 <freep>
 a24:	c515                	beqz	a0,a50 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a26:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a28:	4798                	lw	a4,8(a5)
 a2a:	02977f63          	bgeu	a4,s1,a68 <malloc+0x70>
 a2e:	8a4e                	mv	s4,s3
 a30:	0009871b          	sext.w	a4,s3
 a34:	6685                	lui	a3,0x1
 a36:	00d77363          	bgeu	a4,a3,a3c <malloc+0x44>
 a3a:	6a05                	lui	s4,0x1
 a3c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a40:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a44:	00000917          	auipc	s2,0x0
 a48:	18c90913          	addi	s2,s2,396 # bd0 <freep>
  if(p == (char*)-1)
 a4c:	5afd                	li	s5,-1
 a4e:	a88d                	j	ac0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a50:	00000797          	auipc	a5,0x0
 a54:	18878793          	addi	a5,a5,392 # bd8 <base>
 a58:	00000717          	auipc	a4,0x0
 a5c:	16f73c23          	sd	a5,376(a4) # bd0 <freep>
 a60:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a62:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a66:	b7e1                	j	a2e <malloc+0x36>
      if(p->s.size == nunits)
 a68:	02e48b63          	beq	s1,a4,a9e <malloc+0xa6>
        p->s.size -= nunits;
 a6c:	4137073b          	subw	a4,a4,s3
 a70:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a72:	1702                	slli	a4,a4,0x20
 a74:	9301                	srli	a4,a4,0x20
 a76:	0712                	slli	a4,a4,0x4
 a78:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a7a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a7e:	00000717          	auipc	a4,0x0
 a82:	14a73923          	sd	a0,338(a4) # bd0 <freep>
      return (void*)(p + 1);
 a86:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a8a:	70e2                	ld	ra,56(sp)
 a8c:	7442                	ld	s0,48(sp)
 a8e:	74a2                	ld	s1,40(sp)
 a90:	7902                	ld	s2,32(sp)
 a92:	69e2                	ld	s3,24(sp)
 a94:	6a42                	ld	s4,16(sp)
 a96:	6aa2                	ld	s5,8(sp)
 a98:	6b02                	ld	s6,0(sp)
 a9a:	6121                	addi	sp,sp,64
 a9c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a9e:	6398                	ld	a4,0(a5)
 aa0:	e118                	sd	a4,0(a0)
 aa2:	bff1                	j	a7e <malloc+0x86>
  hp->s.size = nu;
 aa4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 aa8:	0541                	addi	a0,a0,16
 aaa:	00000097          	auipc	ra,0x0
 aae:	ec6080e7          	jalr	-314(ra) # 970 <free>
  return freep;
 ab2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ab6:	d971                	beqz	a0,a8a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aba:	4798                	lw	a4,8(a5)
 abc:	fa9776e3          	bgeu	a4,s1,a68 <malloc+0x70>
    if(p == freep)
 ac0:	00093703          	ld	a4,0(s2)
 ac4:	853e                	mv	a0,a5
 ac6:	fef719e3          	bne	a4,a5,ab8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 aca:	8552                	mv	a0,s4
 acc:	00000097          	auipc	ra,0x0
 ad0:	b5e080e7          	jalr	-1186(ra) # 62a <sbrk>
  if(p == (char*)-1)
 ad4:	fd5518e3          	bne	a0,s5,aa4 <malloc+0xac>
        return 0;
 ad8:	4501                	li	a0,0
 ada:	bf45                	j	a8a <malloc+0x92>
