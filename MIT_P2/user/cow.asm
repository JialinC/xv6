
user/_cow:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:
// allocate more than half of physical memory,
// then fork. this will fail in the default
// kernel, which does not support copy-on-write.
void
simpletest()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = (phys_size / 3) * 2;

  printf("simple: ");
   e:	00001517          	auipc	a0,0x1
  12:	c1a50513          	addi	a0,a0,-998 # c28 <malloc+0xe6>
  16:	00001097          	auipc	ra,0x1
  1a:	a6e080e7          	jalr	-1426(ra) # a84 <printf>
  
  char *p = sbrk(sz);
  1e:	05555537          	lui	a0,0x5555
  22:	55450513          	addi	a0,a0,1364 # 5555554 <__BSS_END__+0x55507dc>
  26:	00000097          	auipc	ra,0x0
  2a:	74e080e7          	jalr	1870(ra) # 774 <sbrk>
  if(p == (char*)0xffffffffffffffffL){
  2e:	57fd                	li	a5,-1
  30:	06f50563          	beq	a0,a5,9a <simpletest+0x9a>
  34:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  for(char *q = p; q < p + sz; q += 4096){
  36:	05556937          	lui	s2,0x5556
  3a:	992a                	add	s2,s2,a0
  3c:	6985                	lui	s3,0x1
    *(int*)q = getpid();
  3e:	00000097          	auipc	ra,0x0
  42:	72e080e7          	jalr	1838(ra) # 76c <getpid>
  46:	c088                	sw	a0,0(s1)
  for(char *q = p; q < p + sz; q += 4096){
  48:	94ce                	add	s1,s1,s3
  4a:	fe991ae3          	bne	s2,s1,3e <simpletest+0x3e>
  }

  int pid = fork();
  4e:	00000097          	auipc	ra,0x0
  52:	696080e7          	jalr	1686(ra) # 6e4 <fork>
  if(pid < 0){
  56:	06054363          	bltz	a0,bc <simpletest+0xbc>
    printf("fork() failed\n");
    exit(-1);
  }

  if(pid == 0)
  5a:	cd35                	beqz	a0,d6 <simpletest+0xd6>
    exit(0);

  wait(0);
  5c:	4501                	li	a0,0
  5e:	00000097          	auipc	ra,0x0
  62:	696080e7          	jalr	1686(ra) # 6f4 <wait>

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
  66:	faaab537          	lui	a0,0xfaaab
  6a:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <__BSS_END__+0xfffffffffaaa5d34>
  6e:	00000097          	auipc	ra,0x0
  72:	706080e7          	jalr	1798(ra) # 774 <sbrk>
  76:	57fd                	li	a5,-1
  78:	06f50363          	beq	a0,a5,de <simpletest+0xde>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
  7c:	00001517          	auipc	a0,0x1
  80:	bfc50513          	addi	a0,a0,-1028 # c78 <malloc+0x136>
  84:	00001097          	auipc	ra,0x1
  88:	a00080e7          	jalr	-1536(ra) # a84 <printf>
}
  8c:	70a2                	ld	ra,40(sp)
  8e:	7402                	ld	s0,32(sp)
  90:	64e2                	ld	s1,24(sp)
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	6145                	addi	sp,sp,48
  98:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  9a:	055555b7          	lui	a1,0x5555
  9e:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x55507dc>
  a2:	00001517          	auipc	a0,0x1
  a6:	b9650513          	addi	a0,a0,-1130 # c38 <malloc+0xf6>
  aa:	00001097          	auipc	ra,0x1
  ae:	9da080e7          	jalr	-1574(ra) # a84 <printf>
    exit(-1);
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	638080e7          	jalr	1592(ra) # 6ec <exit>
    printf("fork() failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	b9450513          	addi	a0,a0,-1132 # c50 <malloc+0x10e>
  c4:	00001097          	auipc	ra,0x1
  c8:	9c0080e7          	jalr	-1600(ra) # a84 <printf>
    exit(-1);
  cc:	557d                	li	a0,-1
  ce:	00000097          	auipc	ra,0x0
  d2:	61e080e7          	jalr	1566(ra) # 6ec <exit>
    exit(0);
  d6:	00000097          	auipc	ra,0x0
  da:	616080e7          	jalr	1558(ra) # 6ec <exit>
    printf("sbrk(-%d) failed\n", sz);
  de:	055555b7          	lui	a1,0x5555
  e2:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x55507dc>
  e6:	00001517          	auipc	a0,0x1
  ea:	b7a50513          	addi	a0,a0,-1158 # c60 <malloc+0x11e>
  ee:	00001097          	auipc	ra,0x1
  f2:	996080e7          	jalr	-1642(ra) # a84 <printf>
    exit(-1);
  f6:	557d                	li	a0,-1
  f8:	00000097          	auipc	ra,0x0
  fc:	5f4080e7          	jalr	1524(ra) # 6ec <exit>

0000000000000100 <threetest>:
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void
threetest()
{
 100:	7179                	addi	sp,sp,-48
 102:	f406                	sd	ra,40(sp)
 104:	f022                	sd	s0,32(sp)
 106:	ec26                	sd	s1,24(sp)
 108:	e84a                	sd	s2,16(sp)
 10a:	e44e                	sd	s3,8(sp)
 10c:	e052                	sd	s4,0(sp)
 10e:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;

  printf("three: ");
 110:	00001517          	auipc	a0,0x1
 114:	b7050513          	addi	a0,a0,-1168 # c80 <malloc+0x13e>
 118:	00001097          	auipc	ra,0x1
 11c:	96c080e7          	jalr	-1684(ra) # a84 <printf>
  
  char *p = sbrk(sz);
 120:	02000537          	lui	a0,0x2000
 124:	00000097          	auipc	ra,0x0
 128:	650080e7          	jalr	1616(ra) # 774 <sbrk>
  if(p == (char*)0xffffffffffffffffL){
 12c:	57fd                	li	a5,-1
 12e:	08f50763          	beq	a0,a5,1bc <threetest+0xbc>
 132:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  pid1 = fork();
 134:	00000097          	auipc	ra,0x0
 138:	5b0080e7          	jalr	1456(ra) # 6e4 <fork>
  if(pid1 < 0){
 13c:	08054f63          	bltz	a0,1da <threetest+0xda>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid1 == 0){
 140:	c955                	beqz	a0,1f4 <threetest+0xf4>
      *(int*)q = 9999;
    }
    exit(0);
  }

  for(char *q = p; q < p + sz; q += 4096){
 142:	020009b7          	lui	s3,0x2000
 146:	99a6                	add	s3,s3,s1
 148:	8926                	mv	s2,s1
 14a:	6a05                	lui	s4,0x1
    *(int*)q = getpid();
 14c:	00000097          	auipc	ra,0x0
 150:	620080e7          	jalr	1568(ra) # 76c <getpid>
 154:	00a92023          	sw	a0,0(s2) # 5556000 <__BSS_END__+0x5551288>
  for(char *q = p; q < p + sz; q += 4096){
 158:	9952                	add	s2,s2,s4
 15a:	ff3919e3          	bne	s2,s3,14c <threetest+0x4c>
  }

  wait(0);
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	594080e7          	jalr	1428(ra) # 6f4 <wait>

  sleep(1);
 168:	4505                	li	a0,1
 16a:	00000097          	auipc	ra,0x0
 16e:	612080e7          	jalr	1554(ra) # 77c <sleep>

  for(char *q = p; q < p + sz; q += 4096){
 172:	6a05                	lui	s4,0x1
    if(*(int*)q != getpid()){
 174:	0004a903          	lw	s2,0(s1)
 178:	00000097          	auipc	ra,0x0
 17c:	5f4080e7          	jalr	1524(ra) # 76c <getpid>
 180:	10a91a63          	bne	s2,a0,294 <threetest+0x194>
  for(char *q = p; q < p + sz; q += 4096){
 184:	94d2                	add	s1,s1,s4
 186:	ff3497e3          	bne	s1,s3,174 <threetest+0x74>
      printf("wrong content\n");
      exit(-1);
    }
  }

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
 18a:	fe000537          	lui	a0,0xfe000
 18e:	00000097          	auipc	ra,0x0
 192:	5e6080e7          	jalr	1510(ra) # 774 <sbrk>
 196:	57fd                	li	a5,-1
 198:	10f50b63          	beq	a0,a5,2ae <threetest+0x1ae>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	adc50513          	addi	a0,a0,-1316 # c78 <malloc+0x136>
 1a4:	00001097          	auipc	ra,0x1
 1a8:	8e0080e7          	jalr	-1824(ra) # a84 <printf>
}
 1ac:	70a2                	ld	ra,40(sp)
 1ae:	7402                	ld	s0,32(sp)
 1b0:	64e2                	ld	s1,24(sp)
 1b2:	6942                	ld	s2,16(sp)
 1b4:	69a2                	ld	s3,8(sp)
 1b6:	6a02                	ld	s4,0(sp)
 1b8:	6145                	addi	sp,sp,48
 1ba:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 1bc:	020005b7          	lui	a1,0x2000
 1c0:	00001517          	auipc	a0,0x1
 1c4:	a7850513          	addi	a0,a0,-1416 # c38 <malloc+0xf6>
 1c8:	00001097          	auipc	ra,0x1
 1cc:	8bc080e7          	jalr	-1860(ra) # a84 <printf>
    exit(-1);
 1d0:	557d                	li	a0,-1
 1d2:	00000097          	auipc	ra,0x0
 1d6:	51a080e7          	jalr	1306(ra) # 6ec <exit>
    printf("fork failed\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	aae50513          	addi	a0,a0,-1362 # c88 <malloc+0x146>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	8a2080e7          	jalr	-1886(ra) # a84 <printf>
    exit(-1);
 1ea:	557d                	li	a0,-1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	500080e7          	jalr	1280(ra) # 6ec <exit>
    pid2 = fork();
 1f4:	00000097          	auipc	ra,0x0
 1f8:	4f0080e7          	jalr	1264(ra) # 6e4 <fork>
    if(pid2 < 0){
 1fc:	04054263          	bltz	a0,240 <threetest+0x140>
    if(pid2 == 0){
 200:	ed29                	bnez	a0,25a <threetest+0x15a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 202:	0199a9b7          	lui	s3,0x199a
 206:	99a6                	add	s3,s3,s1
 208:	8926                	mv	s2,s1
 20a:	6a05                	lui	s4,0x1
        *(int*)q = getpid();
 20c:	00000097          	auipc	ra,0x0
 210:	560080e7          	jalr	1376(ra) # 76c <getpid>
 214:	00a92023          	sw	a0,0(s2)
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 218:	9952                	add	s2,s2,s4
 21a:	ff2999e3          	bne	s3,s2,20c <threetest+0x10c>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 21e:	6a05                	lui	s4,0x1
        if(*(int*)q != getpid()){
 220:	0004a903          	lw	s2,0(s1)
 224:	00000097          	auipc	ra,0x0
 228:	548080e7          	jalr	1352(ra) # 76c <getpid>
 22c:	04a91763          	bne	s2,a0,27a <threetest+0x17a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 230:	94d2                	add	s1,s1,s4
 232:	fe9997e3          	bne	s3,s1,220 <threetest+0x120>
      exit(-1);
 236:	557d                	li	a0,-1
 238:	00000097          	auipc	ra,0x0
 23c:	4b4080e7          	jalr	1204(ra) # 6ec <exit>
      printf("fork failed");
 240:	00001517          	auipc	a0,0x1
 244:	a5850513          	addi	a0,a0,-1448 # c98 <malloc+0x156>
 248:	00001097          	auipc	ra,0x1
 24c:	83c080e7          	jalr	-1988(ra) # a84 <printf>
      exit(-1);
 250:	557d                	li	a0,-1
 252:	00000097          	auipc	ra,0x0
 256:	49a080e7          	jalr	1178(ra) # 6ec <exit>
    for(char *q = p; q < p + (sz/2); q += 4096){
 25a:	01000737          	lui	a4,0x1000
 25e:	9726                	add	a4,a4,s1
      *(int*)q = 9999;
 260:	6789                	lui	a5,0x2
 262:	70f78793          	addi	a5,a5,1807 # 270f <buf+0x9a7>
    for(char *q = p; q < p + (sz/2); q += 4096){
 266:	6685                	lui	a3,0x1
      *(int*)q = 9999;
 268:	c09c                	sw	a5,0(s1)
    for(char *q = p; q < p + (sz/2); q += 4096){
 26a:	94b6                	add	s1,s1,a3
 26c:	fee49ee3          	bne	s1,a4,268 <threetest+0x168>
    exit(0);
 270:	4501                	li	a0,0
 272:	00000097          	auipc	ra,0x0
 276:	47a080e7          	jalr	1146(ra) # 6ec <exit>
          printf("wrong content\n");
 27a:	00001517          	auipc	a0,0x1
 27e:	a2e50513          	addi	a0,a0,-1490 # ca8 <malloc+0x166>
 282:	00001097          	auipc	ra,0x1
 286:	802080e7          	jalr	-2046(ra) # a84 <printf>
          exit(-1);
 28a:	557d                	li	a0,-1
 28c:	00000097          	auipc	ra,0x0
 290:	460080e7          	jalr	1120(ra) # 6ec <exit>
      printf("wrong content\n");
 294:	00001517          	auipc	a0,0x1
 298:	a1450513          	addi	a0,a0,-1516 # ca8 <malloc+0x166>
 29c:	00000097          	auipc	ra,0x0
 2a0:	7e8080e7          	jalr	2024(ra) # a84 <printf>
      exit(-1);
 2a4:	557d                	li	a0,-1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	446080e7          	jalr	1094(ra) # 6ec <exit>
    printf("sbrk(-%d) failed\n", sz);
 2ae:	020005b7          	lui	a1,0x2000
 2b2:	00001517          	auipc	a0,0x1
 2b6:	9ae50513          	addi	a0,a0,-1618 # c60 <malloc+0x11e>
 2ba:	00000097          	auipc	ra,0x0
 2be:	7ca080e7          	jalr	1994(ra) # a84 <printf>
    exit(-1);
 2c2:	557d                	li	a0,-1
 2c4:	00000097          	auipc	ra,0x0
 2c8:	428080e7          	jalr	1064(ra) # 6ec <exit>

00000000000002cc <filetest>:
char junk3[4096];

// test whether copyout() simulates COW faults.
void
filetest()
{
 2cc:	7139                	addi	sp,sp,-64
 2ce:	fc06                	sd	ra,56(sp)
 2d0:	f822                	sd	s0,48(sp)
 2d2:	f426                	sd	s1,40(sp)
 2d4:	f04a                	sd	s2,32(sp)
 2d6:	ec4e                	sd	s3,24(sp)
 2d8:	0080                	addi	s0,sp,64
  int parent = getpid();
 2da:	00000097          	auipc	ra,0x0
 2de:	492080e7          	jalr	1170(ra) # 76c <getpid>
 2e2:	89aa                	mv	s3,a0
  
  printf("file: ");
 2e4:	00001517          	auipc	a0,0x1
 2e8:	9d450513          	addi	a0,a0,-1580 # cb8 <malloc+0x176>
 2ec:	00000097          	auipc	ra,0x0
 2f0:	798080e7          	jalr	1944(ra) # a84 <printf>
  
  buf[0] = 99;
 2f4:	06300793          	li	a5,99
 2f8:	00002717          	auipc	a4,0x2
 2fc:	a6f70823          	sb	a5,-1424(a4) # 1d68 <buf>

  for(int i = 0; i < 4; i++){
 300:	fc042623          	sw	zero,-52(s0)
    if(pipe(fds) != 0){
 304:	00001497          	auipc	s1,0x1
 308:	a5448493          	addi	s1,s1,-1452 # d58 <fds>
  for(int i = 0; i < 4; i++){
 30c:	490d                	li	s2,3
    if(pipe(fds) != 0){
 30e:	8526                	mv	a0,s1
 310:	00000097          	auipc	ra,0x0
 314:	3ec080e7          	jalr	1004(ra) # 6fc <pipe>
 318:	e559                	bnez	a0,3a6 <filetest+0xda>
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
 31a:	00000097          	auipc	ra,0x0
 31e:	3ca080e7          	jalr	970(ra) # 6e4 <fork>
    if(pid < 0){
 322:	08054f63          	bltz	a0,3c0 <filetest+0xf4>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid == 0){
 326:	c955                	beqz	a0,3da <filetest+0x10e>
        kill(parent);
        exit(-1);
      }
      exit(0);
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
 328:	4611                	li	a2,4
 32a:	fcc40593          	addi	a1,s0,-52
 32e:	40c8                	lw	a0,4(s1)
 330:	00000097          	auipc	ra,0x0
 334:	3dc080e7          	jalr	988(ra) # 70c <write>
 338:	4791                	li	a5,4
 33a:	12f51b63          	bne	a0,a5,470 <filetest+0x1a4>
  for(int i = 0; i < 4; i++){
 33e:	fcc42783          	lw	a5,-52(s0)
 342:	2785                	addiw	a5,a5,1
 344:	0007871b          	sext.w	a4,a5
 348:	fcf42623          	sw	a5,-52(s0)
 34c:	fce951e3          	bge	s2,a4,30e <filetest+0x42>
      exit(-1);
    }
  }

  for(int i = 0; i < 4; i++)
    wait(0);
 350:	4501                	li	a0,0
 352:	00000097          	auipc	ra,0x0
 356:	3a2080e7          	jalr	930(ra) # 6f4 <wait>
 35a:	4501                	li	a0,0
 35c:	00000097          	auipc	ra,0x0
 360:	398080e7          	jalr	920(ra) # 6f4 <wait>
 364:	4501                	li	a0,0
 366:	00000097          	auipc	ra,0x0
 36a:	38e080e7          	jalr	910(ra) # 6f4 <wait>
 36e:	4501                	li	a0,0
 370:	00000097          	auipc	ra,0x0
 374:	384080e7          	jalr	900(ra) # 6f4 <wait>

  if(buf[0] != 99){
 378:	00002717          	auipc	a4,0x2
 37c:	9f074703          	lbu	a4,-1552(a4) # 1d68 <buf>
 380:	06300793          	li	a5,99
 384:	10f71363          	bne	a4,a5,48a <filetest+0x1be>
    printf("child overwrote parent\n");
    exit(-1);
  }

  printf("ok\n");
 388:	00001517          	auipc	a0,0x1
 38c:	8f050513          	addi	a0,a0,-1808 # c78 <malloc+0x136>
 390:	00000097          	auipc	ra,0x0
 394:	6f4080e7          	jalr	1780(ra) # a84 <printf>
}
 398:	70e2                	ld	ra,56(sp)
 39a:	7442                	ld	s0,48(sp)
 39c:	74a2                	ld	s1,40(sp)
 39e:	7902                	ld	s2,32(sp)
 3a0:	69e2                	ld	s3,24(sp)
 3a2:	6121                	addi	sp,sp,64
 3a4:	8082                	ret
      printf("pipe() failed\n");
 3a6:	00001517          	auipc	a0,0x1
 3aa:	91a50513          	addi	a0,a0,-1766 # cc0 <malloc+0x17e>
 3ae:	00000097          	auipc	ra,0x0
 3b2:	6d6080e7          	jalr	1750(ra) # a84 <printf>
      exit(-1);
 3b6:	557d                	li	a0,-1
 3b8:	00000097          	auipc	ra,0x0
 3bc:	334080e7          	jalr	820(ra) # 6ec <exit>
      printf("fork failed\n");
 3c0:	00001517          	auipc	a0,0x1
 3c4:	8c850513          	addi	a0,a0,-1848 # c88 <malloc+0x146>
 3c8:	00000097          	auipc	ra,0x0
 3cc:	6bc080e7          	jalr	1724(ra) # a84 <printf>
      exit(-1);
 3d0:	557d                	li	a0,-1
 3d2:	00000097          	auipc	ra,0x0
 3d6:	31a080e7          	jalr	794(ra) # 6ec <exit>
      sleep(1);
 3da:	4505                	li	a0,1
 3dc:	00000097          	auipc	ra,0x0
 3e0:	3a0080e7          	jalr	928(ra) # 77c <sleep>
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
 3e4:	4611                	li	a2,4
 3e6:	00002597          	auipc	a1,0x2
 3ea:	98258593          	addi	a1,a1,-1662 # 1d68 <buf>
 3ee:	00001517          	auipc	a0,0x1
 3f2:	96a52503          	lw	a0,-1686(a0) # d58 <fds>
 3f6:	00000097          	auipc	ra,0x0
 3fa:	30e080e7          	jalr	782(ra) # 704 <read>
 3fe:	4791                	li	a5,4
 400:	04f51163          	bne	a0,a5,442 <filetest+0x176>
      sleep(1);
 404:	4505                	li	a0,1
 406:	00000097          	auipc	ra,0x0
 40a:	376080e7          	jalr	886(ra) # 77c <sleep>
      if(j != i){
 40e:	fcc42703          	lw	a4,-52(s0)
 412:	00002797          	auipc	a5,0x2
 416:	9567a783          	lw	a5,-1706(a5) # 1d68 <buf>
 41a:	04f70663          	beq	a4,a5,466 <filetest+0x19a>
        printf("read the wrong value\n");
 41e:	00001517          	auipc	a0,0x1
 422:	8c250513          	addi	a0,a0,-1854 # ce0 <malloc+0x19e>
 426:	00000097          	auipc	ra,0x0
 42a:	65e080e7          	jalr	1630(ra) # a84 <printf>
        kill(parent);
 42e:	854e                	mv	a0,s3
 430:	00000097          	auipc	ra,0x0
 434:	2ec080e7          	jalr	748(ra) # 71c <kill>
        exit(-1);
 438:	557d                	li	a0,-1
 43a:	00000097          	auipc	ra,0x0
 43e:	2b2080e7          	jalr	690(ra) # 6ec <exit>
        printf("read failed\n");
 442:	00001517          	auipc	a0,0x1
 446:	88e50513          	addi	a0,a0,-1906 # cd0 <malloc+0x18e>
 44a:	00000097          	auipc	ra,0x0
 44e:	63a080e7          	jalr	1594(ra) # a84 <printf>
        kill(parent);
 452:	854e                	mv	a0,s3
 454:	00000097          	auipc	ra,0x0
 458:	2c8080e7          	jalr	712(ra) # 71c <kill>
        exit(-1);
 45c:	557d                	li	a0,-1
 45e:	00000097          	auipc	ra,0x0
 462:	28e080e7          	jalr	654(ra) # 6ec <exit>
      exit(0);
 466:	4501                	li	a0,0
 468:	00000097          	auipc	ra,0x0
 46c:	284080e7          	jalr	644(ra) # 6ec <exit>
      printf("write failed\n");
 470:	00001517          	auipc	a0,0x1
 474:	88850513          	addi	a0,a0,-1912 # cf8 <malloc+0x1b6>
 478:	00000097          	auipc	ra,0x0
 47c:	60c080e7          	jalr	1548(ra) # a84 <printf>
      exit(-1);
 480:	557d                	li	a0,-1
 482:	00000097          	auipc	ra,0x0
 486:	26a080e7          	jalr	618(ra) # 6ec <exit>
    printf("child overwrote parent\n");
 48a:	00001517          	auipc	a0,0x1
 48e:	87e50513          	addi	a0,a0,-1922 # d08 <malloc+0x1c6>
 492:	00000097          	auipc	ra,0x0
 496:	5f2080e7          	jalr	1522(ra) # a84 <printf>
    exit(-1);
 49a:	557d                	li	a0,-1
 49c:	00000097          	auipc	ra,0x0
 4a0:	250080e7          	jalr	592(ra) # 6ec <exit>

00000000000004a4 <main>:

int
main(int argc, char *argv[])
{
 4a4:	1141                	addi	sp,sp,-16
 4a6:	e406                	sd	ra,8(sp)
 4a8:	e022                	sd	s0,0(sp)
 4aa:	0800                	addi	s0,sp,16
  simpletest();
 4ac:	00000097          	auipc	ra,0x0
 4b0:	b54080e7          	jalr	-1196(ra) # 0 <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 4b4:	00000097          	auipc	ra,0x0
 4b8:	b4c080e7          	jalr	-1204(ra) # 0 <simpletest>

  threetest();
 4bc:	00000097          	auipc	ra,0x0
 4c0:	c44080e7          	jalr	-956(ra) # 100 <threetest>
  threetest();
 4c4:	00000097          	auipc	ra,0x0
 4c8:	c3c080e7          	jalr	-964(ra) # 100 <threetest>
  threetest();
 4cc:	00000097          	auipc	ra,0x0
 4d0:	c34080e7          	jalr	-972(ra) # 100 <threetest>

  filetest();
 4d4:	00000097          	auipc	ra,0x0
 4d8:	df8080e7          	jalr	-520(ra) # 2cc <filetest>

  printf("ALL COW TESTS PASSED\n");
 4dc:	00001517          	auipc	a0,0x1
 4e0:	84450513          	addi	a0,a0,-1980 # d20 <malloc+0x1de>
 4e4:	00000097          	auipc	ra,0x0
 4e8:	5a0080e7          	jalr	1440(ra) # a84 <printf>

  exit(0);
 4ec:	4501                	li	a0,0
 4ee:	00000097          	auipc	ra,0x0
 4f2:	1fe080e7          	jalr	510(ra) # 6ec <exit>

00000000000004f6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 4f6:	1141                	addi	sp,sp,-16
 4f8:	e422                	sd	s0,8(sp)
 4fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4fc:	87aa                	mv	a5,a0
 4fe:	0585                	addi	a1,a1,1
 500:	0785                	addi	a5,a5,1
 502:	fff5c703          	lbu	a4,-1(a1)
 506:	fee78fa3          	sb	a4,-1(a5)
 50a:	fb75                	bnez	a4,4fe <strcpy+0x8>
    ;
  return os;
}
 50c:	6422                	ld	s0,8(sp)
 50e:	0141                	addi	sp,sp,16
 510:	8082                	ret

0000000000000512 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 512:	1141                	addi	sp,sp,-16
 514:	e422                	sd	s0,8(sp)
 516:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 518:	00054783          	lbu	a5,0(a0)
 51c:	cb91                	beqz	a5,530 <strcmp+0x1e>
 51e:	0005c703          	lbu	a4,0(a1)
 522:	00f71763          	bne	a4,a5,530 <strcmp+0x1e>
    p++, q++;
 526:	0505                	addi	a0,a0,1
 528:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 52a:	00054783          	lbu	a5,0(a0)
 52e:	fbe5                	bnez	a5,51e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 530:	0005c503          	lbu	a0,0(a1)
}
 534:	40a7853b          	subw	a0,a5,a0
 538:	6422                	ld	s0,8(sp)
 53a:	0141                	addi	sp,sp,16
 53c:	8082                	ret

000000000000053e <strlen>:

uint
strlen(const char *s)
{
 53e:	1141                	addi	sp,sp,-16
 540:	e422                	sd	s0,8(sp)
 542:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 544:	00054783          	lbu	a5,0(a0)
 548:	cf91                	beqz	a5,564 <strlen+0x26>
 54a:	0505                	addi	a0,a0,1
 54c:	87aa                	mv	a5,a0
 54e:	4685                	li	a3,1
 550:	9e89                	subw	a3,a3,a0
 552:	00f6853b          	addw	a0,a3,a5
 556:	0785                	addi	a5,a5,1
 558:	fff7c703          	lbu	a4,-1(a5)
 55c:	fb7d                	bnez	a4,552 <strlen+0x14>
    ;
  return n;
}
 55e:	6422                	ld	s0,8(sp)
 560:	0141                	addi	sp,sp,16
 562:	8082                	ret
  for(n = 0; s[n]; n++)
 564:	4501                	li	a0,0
 566:	bfe5                	j	55e <strlen+0x20>

0000000000000568 <memset>:

void*
memset(void *dst, int c, uint n)
{
 568:	1141                	addi	sp,sp,-16
 56a:	e422                	sd	s0,8(sp)
 56c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 56e:	ce09                	beqz	a2,588 <memset+0x20>
 570:	87aa                	mv	a5,a0
 572:	fff6071b          	addiw	a4,a2,-1
 576:	1702                	slli	a4,a4,0x20
 578:	9301                	srli	a4,a4,0x20
 57a:	0705                	addi	a4,a4,1
 57c:	972a                	add	a4,a4,a0
    cdst[i] = c;
 57e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 582:	0785                	addi	a5,a5,1
 584:	fee79de3          	bne	a5,a4,57e <memset+0x16>
  }
  return dst;
}
 588:	6422                	ld	s0,8(sp)
 58a:	0141                	addi	sp,sp,16
 58c:	8082                	ret

000000000000058e <strchr>:

char*
strchr(const char *s, char c)
{
 58e:	1141                	addi	sp,sp,-16
 590:	e422                	sd	s0,8(sp)
 592:	0800                	addi	s0,sp,16
  for(; *s; s++)
 594:	00054783          	lbu	a5,0(a0)
 598:	cb99                	beqz	a5,5ae <strchr+0x20>
    if(*s == c)
 59a:	00f58763          	beq	a1,a5,5a8 <strchr+0x1a>
  for(; *s; s++)
 59e:	0505                	addi	a0,a0,1
 5a0:	00054783          	lbu	a5,0(a0)
 5a4:	fbfd                	bnez	a5,59a <strchr+0xc>
      return (char*)s;
  return 0;
 5a6:	4501                	li	a0,0
}
 5a8:	6422                	ld	s0,8(sp)
 5aa:	0141                	addi	sp,sp,16
 5ac:	8082                	ret
  return 0;
 5ae:	4501                	li	a0,0
 5b0:	bfe5                	j	5a8 <strchr+0x1a>

00000000000005b2 <gets>:

char*
gets(char *buf, int max)
{
 5b2:	711d                	addi	sp,sp,-96
 5b4:	ec86                	sd	ra,88(sp)
 5b6:	e8a2                	sd	s0,80(sp)
 5b8:	e4a6                	sd	s1,72(sp)
 5ba:	e0ca                	sd	s2,64(sp)
 5bc:	fc4e                	sd	s3,56(sp)
 5be:	f852                	sd	s4,48(sp)
 5c0:	f456                	sd	s5,40(sp)
 5c2:	f05a                	sd	s6,32(sp)
 5c4:	ec5e                	sd	s7,24(sp)
 5c6:	1080                	addi	s0,sp,96
 5c8:	8baa                	mv	s7,a0
 5ca:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5cc:	892a                	mv	s2,a0
 5ce:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5d0:	4aa9                	li	s5,10
 5d2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5d4:	89a6                	mv	s3,s1
 5d6:	2485                	addiw	s1,s1,1
 5d8:	0344d863          	bge	s1,s4,608 <gets+0x56>
    cc = read(0, &c, 1);
 5dc:	4605                	li	a2,1
 5de:	faf40593          	addi	a1,s0,-81
 5e2:	4501                	li	a0,0
 5e4:	00000097          	auipc	ra,0x0
 5e8:	120080e7          	jalr	288(ra) # 704 <read>
    if(cc < 1)
 5ec:	00a05e63          	blez	a0,608 <gets+0x56>
    buf[i++] = c;
 5f0:	faf44783          	lbu	a5,-81(s0)
 5f4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5f8:	01578763          	beq	a5,s5,606 <gets+0x54>
 5fc:	0905                	addi	s2,s2,1
 5fe:	fd679be3          	bne	a5,s6,5d4 <gets+0x22>
  for(i=0; i+1 < max; ){
 602:	89a6                	mv	s3,s1
 604:	a011                	j	608 <gets+0x56>
 606:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 608:	99de                	add	s3,s3,s7
 60a:	00098023          	sb	zero,0(s3) # 199a000 <__BSS_END__+0x1995288>
  return buf;
}
 60e:	855e                	mv	a0,s7
 610:	60e6                	ld	ra,88(sp)
 612:	6446                	ld	s0,80(sp)
 614:	64a6                	ld	s1,72(sp)
 616:	6906                	ld	s2,64(sp)
 618:	79e2                	ld	s3,56(sp)
 61a:	7a42                	ld	s4,48(sp)
 61c:	7aa2                	ld	s5,40(sp)
 61e:	7b02                	ld	s6,32(sp)
 620:	6be2                	ld	s7,24(sp)
 622:	6125                	addi	sp,sp,96
 624:	8082                	ret

0000000000000626 <stat>:

int
stat(const char *n, struct stat *st)
{
 626:	1101                	addi	sp,sp,-32
 628:	ec06                	sd	ra,24(sp)
 62a:	e822                	sd	s0,16(sp)
 62c:	e426                	sd	s1,8(sp)
 62e:	e04a                	sd	s2,0(sp)
 630:	1000                	addi	s0,sp,32
 632:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 634:	4581                	li	a1,0
 636:	00000097          	auipc	ra,0x0
 63a:	0f6080e7          	jalr	246(ra) # 72c <open>
  if(fd < 0)
 63e:	02054563          	bltz	a0,668 <stat+0x42>
 642:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 644:	85ca                	mv	a1,s2
 646:	00000097          	auipc	ra,0x0
 64a:	0fe080e7          	jalr	254(ra) # 744 <fstat>
 64e:	892a                	mv	s2,a0
  close(fd);
 650:	8526                	mv	a0,s1
 652:	00000097          	auipc	ra,0x0
 656:	0c2080e7          	jalr	194(ra) # 714 <close>
  return r;
}
 65a:	854a                	mv	a0,s2
 65c:	60e2                	ld	ra,24(sp)
 65e:	6442                	ld	s0,16(sp)
 660:	64a2                	ld	s1,8(sp)
 662:	6902                	ld	s2,0(sp)
 664:	6105                	addi	sp,sp,32
 666:	8082                	ret
    return -1;
 668:	597d                	li	s2,-1
 66a:	bfc5                	j	65a <stat+0x34>

000000000000066c <atoi>:

int
atoi(const char *s)
{
 66c:	1141                	addi	sp,sp,-16
 66e:	e422                	sd	s0,8(sp)
 670:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 672:	00054603          	lbu	a2,0(a0)
 676:	fd06079b          	addiw	a5,a2,-48
 67a:	0ff7f793          	andi	a5,a5,255
 67e:	4725                	li	a4,9
 680:	02f76963          	bltu	a4,a5,6b2 <atoi+0x46>
 684:	86aa                	mv	a3,a0
  n = 0;
 686:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 688:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 68a:	0685                	addi	a3,a3,1
 68c:	0025179b          	slliw	a5,a0,0x2
 690:	9fa9                	addw	a5,a5,a0
 692:	0017979b          	slliw	a5,a5,0x1
 696:	9fb1                	addw	a5,a5,a2
 698:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 69c:	0006c603          	lbu	a2,0(a3) # 1000 <junk3+0x298>
 6a0:	fd06071b          	addiw	a4,a2,-48
 6a4:	0ff77713          	andi	a4,a4,255
 6a8:	fee5f1e3          	bgeu	a1,a4,68a <atoi+0x1e>
  return n;
}
 6ac:	6422                	ld	s0,8(sp)
 6ae:	0141                	addi	sp,sp,16
 6b0:	8082                	ret
  n = 0;
 6b2:	4501                	li	a0,0
 6b4:	bfe5                	j	6ac <atoi+0x40>

00000000000006b6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6b6:	1141                	addi	sp,sp,-16
 6b8:	e422                	sd	s0,8(sp)
 6ba:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6bc:	02c05163          	blez	a2,6de <memmove+0x28>
 6c0:	fff6071b          	addiw	a4,a2,-1
 6c4:	1702                	slli	a4,a4,0x20
 6c6:	9301                	srli	a4,a4,0x20
 6c8:	0705                	addi	a4,a4,1
 6ca:	972a                	add	a4,a4,a0
  dst = vdst;
 6cc:	87aa                	mv	a5,a0
    *dst++ = *src++;
 6ce:	0585                	addi	a1,a1,1
 6d0:	0785                	addi	a5,a5,1
 6d2:	fff5c683          	lbu	a3,-1(a1)
 6d6:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 6da:	fee79ae3          	bne	a5,a4,6ce <memmove+0x18>
  return vdst;
}
 6de:	6422                	ld	s0,8(sp)
 6e0:	0141                	addi	sp,sp,16
 6e2:	8082                	ret

00000000000006e4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6e4:	4885                	li	a7,1
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <exit>:
.global exit
exit:
 li a7, SYS_exit
 6ec:	4889                	li	a7,2
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6f4:	488d                	li	a7,3
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6fc:	4891                	li	a7,4
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <read>:
.global read
read:
 li a7, SYS_read
 704:	4895                	li	a7,5
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <write>:
.global write
write:
 li a7, SYS_write
 70c:	48c1                	li	a7,16
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <close>:
.global close
close:
 li a7, SYS_close
 714:	48d5                	li	a7,21
 ecall
 716:	00000073          	ecall
 ret
 71a:	8082                	ret

000000000000071c <kill>:
.global kill
kill:
 li a7, SYS_kill
 71c:	4899                	li	a7,6
 ecall
 71e:	00000073          	ecall
 ret
 722:	8082                	ret

0000000000000724 <exec>:
.global exec
exec:
 li a7, SYS_exec
 724:	489d                	li	a7,7
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <open>:
.global open
open:
 li a7, SYS_open
 72c:	48bd                	li	a7,15
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 734:	48c5                	li	a7,17
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 73c:	48c9                	li	a7,18
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 744:	48a1                	li	a7,8
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <link>:
.global link
link:
 li a7, SYS_link
 74c:	48cd                	li	a7,19
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 754:	48d1                	li	a7,20
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 75c:	48a5                	li	a7,9
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <dup>:
.global dup
dup:
 li a7, SYS_dup
 764:	48a9                	li	a7,10
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 76c:	48ad                	li	a7,11
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 774:	48b1                	li	a7,12
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 77c:	48b5                	li	a7,13
 ecall
 77e:	00000073          	ecall
 ret
 782:	8082                	ret

0000000000000784 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 784:	48b9                	li	a7,14
 ecall
 786:	00000073          	ecall
 ret
 78a:	8082                	ret

000000000000078c <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 78c:	48d9                	li	a7,22
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

0000000000000794 <crash>:
.global crash
crash:
 li a7, SYS_crash
 794:	48dd                	li	a7,23
 ecall
 796:	00000073          	ecall
 ret
 79a:	8082                	ret

000000000000079c <mount>:
.global mount
mount:
 li a7, SYS_mount
 79c:	48e1                	li	a7,24
 ecall
 79e:	00000073          	ecall
 ret
 7a2:	8082                	ret

00000000000007a4 <umount>:
.global umount
umount:
 li a7, SYS_umount
 7a4:	48e5                	li	a7,25
 ecall
 7a6:	00000073          	ecall
 ret
 7aa:	8082                	ret

00000000000007ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7ac:	1101                	addi	sp,sp,-32
 7ae:	ec06                	sd	ra,24(sp)
 7b0:	e822                	sd	s0,16(sp)
 7b2:	1000                	addi	s0,sp,32
 7b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7b8:	4605                	li	a2,1
 7ba:	fef40593          	addi	a1,s0,-17
 7be:	00000097          	auipc	ra,0x0
 7c2:	f4e080e7          	jalr	-178(ra) # 70c <write>
}
 7c6:	60e2                	ld	ra,24(sp)
 7c8:	6442                	ld	s0,16(sp)
 7ca:	6105                	addi	sp,sp,32
 7cc:	8082                	ret

00000000000007ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7ce:	7139                	addi	sp,sp,-64
 7d0:	fc06                	sd	ra,56(sp)
 7d2:	f822                	sd	s0,48(sp)
 7d4:	f426                	sd	s1,40(sp)
 7d6:	f04a                	sd	s2,32(sp)
 7d8:	ec4e                	sd	s3,24(sp)
 7da:	0080                	addi	s0,sp,64
 7dc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7de:	c299                	beqz	a3,7e4 <printint+0x16>
 7e0:	0805c863          	bltz	a1,870 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7e4:	2581                	sext.w	a1,a1
  neg = 0;
 7e6:	4881                	li	a7,0
 7e8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7ec:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7ee:	2601                	sext.w	a2,a2
 7f0:	00000517          	auipc	a0,0x0
 7f4:	55050513          	addi	a0,a0,1360 # d40 <digits>
 7f8:	883a                	mv	a6,a4
 7fa:	2705                	addiw	a4,a4,1
 7fc:	02c5f7bb          	remuw	a5,a1,a2
 800:	1782                	slli	a5,a5,0x20
 802:	9381                	srli	a5,a5,0x20
 804:	97aa                	add	a5,a5,a0
 806:	0007c783          	lbu	a5,0(a5)
 80a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 80e:	0005879b          	sext.w	a5,a1
 812:	02c5d5bb          	divuw	a1,a1,a2
 816:	0685                	addi	a3,a3,1
 818:	fec7f0e3          	bgeu	a5,a2,7f8 <printint+0x2a>
  if(neg)
 81c:	00088b63          	beqz	a7,832 <printint+0x64>
    buf[i++] = '-';
 820:	fd040793          	addi	a5,s0,-48
 824:	973e                	add	a4,a4,a5
 826:	02d00793          	li	a5,45
 82a:	fef70823          	sb	a5,-16(a4)
 82e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 832:	02e05863          	blez	a4,862 <printint+0x94>
 836:	fc040793          	addi	a5,s0,-64
 83a:	00e78933          	add	s2,a5,a4
 83e:	fff78993          	addi	s3,a5,-1
 842:	99ba                	add	s3,s3,a4
 844:	377d                	addiw	a4,a4,-1
 846:	1702                	slli	a4,a4,0x20
 848:	9301                	srli	a4,a4,0x20
 84a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 84e:	fff94583          	lbu	a1,-1(s2)
 852:	8526                	mv	a0,s1
 854:	00000097          	auipc	ra,0x0
 858:	f58080e7          	jalr	-168(ra) # 7ac <putc>
  while(--i >= 0)
 85c:	197d                	addi	s2,s2,-1
 85e:	ff3918e3          	bne	s2,s3,84e <printint+0x80>
}
 862:	70e2                	ld	ra,56(sp)
 864:	7442                	ld	s0,48(sp)
 866:	74a2                	ld	s1,40(sp)
 868:	7902                	ld	s2,32(sp)
 86a:	69e2                	ld	s3,24(sp)
 86c:	6121                	addi	sp,sp,64
 86e:	8082                	ret
    x = -xx;
 870:	40b005bb          	negw	a1,a1
    neg = 1;
 874:	4885                	li	a7,1
    x = -xx;
 876:	bf8d                	j	7e8 <printint+0x1a>

0000000000000878 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 878:	7119                	addi	sp,sp,-128
 87a:	fc86                	sd	ra,120(sp)
 87c:	f8a2                	sd	s0,112(sp)
 87e:	f4a6                	sd	s1,104(sp)
 880:	f0ca                	sd	s2,96(sp)
 882:	ecce                	sd	s3,88(sp)
 884:	e8d2                	sd	s4,80(sp)
 886:	e4d6                	sd	s5,72(sp)
 888:	e0da                	sd	s6,64(sp)
 88a:	fc5e                	sd	s7,56(sp)
 88c:	f862                	sd	s8,48(sp)
 88e:	f466                	sd	s9,40(sp)
 890:	f06a                	sd	s10,32(sp)
 892:	ec6e                	sd	s11,24(sp)
 894:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 896:	0005c903          	lbu	s2,0(a1)
 89a:	18090f63          	beqz	s2,a38 <vprintf+0x1c0>
 89e:	8aaa                	mv	s5,a0
 8a0:	8b32                	mv	s6,a2
 8a2:	00158493          	addi	s1,a1,1
  state = 0;
 8a6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8a8:	02500a13          	li	s4,37
      if(c == 'd'){
 8ac:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 8b0:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 8b4:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 8b8:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8bc:	00000b97          	auipc	s7,0x0
 8c0:	484b8b93          	addi	s7,s7,1156 # d40 <digits>
 8c4:	a839                	j	8e2 <vprintf+0x6a>
        putc(fd, c);
 8c6:	85ca                	mv	a1,s2
 8c8:	8556                	mv	a0,s5
 8ca:	00000097          	auipc	ra,0x0
 8ce:	ee2080e7          	jalr	-286(ra) # 7ac <putc>
 8d2:	a019                	j	8d8 <vprintf+0x60>
    } else if(state == '%'){
 8d4:	01498f63          	beq	s3,s4,8f2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 8d8:	0485                	addi	s1,s1,1
 8da:	fff4c903          	lbu	s2,-1(s1)
 8de:	14090d63          	beqz	s2,a38 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 8e2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8e6:	fe0997e3          	bnez	s3,8d4 <vprintf+0x5c>
      if(c == '%'){
 8ea:	fd479ee3          	bne	a5,s4,8c6 <vprintf+0x4e>
        state = '%';
 8ee:	89be                	mv	s3,a5
 8f0:	b7e5                	j	8d8 <vprintf+0x60>
      if(c == 'd'){
 8f2:	05878063          	beq	a5,s8,932 <vprintf+0xba>
      } else if(c == 'l') {
 8f6:	05978c63          	beq	a5,s9,94e <vprintf+0xd6>
      } else if(c == 'x') {
 8fa:	07a78863          	beq	a5,s10,96a <vprintf+0xf2>
      } else if(c == 'p') {
 8fe:	09b78463          	beq	a5,s11,986 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 902:	07300713          	li	a4,115
 906:	0ce78663          	beq	a5,a4,9d2 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 90a:	06300713          	li	a4,99
 90e:	0ee78e63          	beq	a5,a4,a0a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 912:	11478863          	beq	a5,s4,a22 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 916:	85d2                	mv	a1,s4
 918:	8556                	mv	a0,s5
 91a:	00000097          	auipc	ra,0x0
 91e:	e92080e7          	jalr	-366(ra) # 7ac <putc>
        putc(fd, c);
 922:	85ca                	mv	a1,s2
 924:	8556                	mv	a0,s5
 926:	00000097          	auipc	ra,0x0
 92a:	e86080e7          	jalr	-378(ra) # 7ac <putc>
      }
      state = 0;
 92e:	4981                	li	s3,0
 930:	b765                	j	8d8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 932:	008b0913          	addi	s2,s6,8
 936:	4685                	li	a3,1
 938:	4629                	li	a2,10
 93a:	000b2583          	lw	a1,0(s6)
 93e:	8556                	mv	a0,s5
 940:	00000097          	auipc	ra,0x0
 944:	e8e080e7          	jalr	-370(ra) # 7ce <printint>
 948:	8b4a                	mv	s6,s2
      state = 0;
 94a:	4981                	li	s3,0
 94c:	b771                	j	8d8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 94e:	008b0913          	addi	s2,s6,8
 952:	4681                	li	a3,0
 954:	4629                	li	a2,10
 956:	000b2583          	lw	a1,0(s6)
 95a:	8556                	mv	a0,s5
 95c:	00000097          	auipc	ra,0x0
 960:	e72080e7          	jalr	-398(ra) # 7ce <printint>
 964:	8b4a                	mv	s6,s2
      state = 0;
 966:	4981                	li	s3,0
 968:	bf85                	j	8d8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 96a:	008b0913          	addi	s2,s6,8
 96e:	4681                	li	a3,0
 970:	4641                	li	a2,16
 972:	000b2583          	lw	a1,0(s6)
 976:	8556                	mv	a0,s5
 978:	00000097          	auipc	ra,0x0
 97c:	e56080e7          	jalr	-426(ra) # 7ce <printint>
 980:	8b4a                	mv	s6,s2
      state = 0;
 982:	4981                	li	s3,0
 984:	bf91                	j	8d8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 986:	008b0793          	addi	a5,s6,8
 98a:	f8f43423          	sd	a5,-120(s0)
 98e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 992:	03000593          	li	a1,48
 996:	8556                	mv	a0,s5
 998:	00000097          	auipc	ra,0x0
 99c:	e14080e7          	jalr	-492(ra) # 7ac <putc>
  putc(fd, 'x');
 9a0:	85ea                	mv	a1,s10
 9a2:	8556                	mv	a0,s5
 9a4:	00000097          	auipc	ra,0x0
 9a8:	e08080e7          	jalr	-504(ra) # 7ac <putc>
 9ac:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9ae:	03c9d793          	srli	a5,s3,0x3c
 9b2:	97de                	add	a5,a5,s7
 9b4:	0007c583          	lbu	a1,0(a5)
 9b8:	8556                	mv	a0,s5
 9ba:	00000097          	auipc	ra,0x0
 9be:	df2080e7          	jalr	-526(ra) # 7ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9c2:	0992                	slli	s3,s3,0x4
 9c4:	397d                	addiw	s2,s2,-1
 9c6:	fe0914e3          	bnez	s2,9ae <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 9ca:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 9ce:	4981                	li	s3,0
 9d0:	b721                	j	8d8 <vprintf+0x60>
        s = va_arg(ap, char*);
 9d2:	008b0993          	addi	s3,s6,8
 9d6:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 9da:	02090163          	beqz	s2,9fc <vprintf+0x184>
        while(*s != 0){
 9de:	00094583          	lbu	a1,0(s2)
 9e2:	c9a1                	beqz	a1,a32 <vprintf+0x1ba>
          putc(fd, *s);
 9e4:	8556                	mv	a0,s5
 9e6:	00000097          	auipc	ra,0x0
 9ea:	dc6080e7          	jalr	-570(ra) # 7ac <putc>
          s++;
 9ee:	0905                	addi	s2,s2,1
        while(*s != 0){
 9f0:	00094583          	lbu	a1,0(s2)
 9f4:	f9e5                	bnez	a1,9e4 <vprintf+0x16c>
        s = va_arg(ap, char*);
 9f6:	8b4e                	mv	s6,s3
      state = 0;
 9f8:	4981                	li	s3,0
 9fa:	bdf9                	j	8d8 <vprintf+0x60>
          s = "(null)";
 9fc:	00000917          	auipc	s2,0x0
 a00:	33c90913          	addi	s2,s2,828 # d38 <malloc+0x1f6>
        while(*s != 0){
 a04:	02800593          	li	a1,40
 a08:	bff1                	j	9e4 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 a0a:	008b0913          	addi	s2,s6,8
 a0e:	000b4583          	lbu	a1,0(s6)
 a12:	8556                	mv	a0,s5
 a14:	00000097          	auipc	ra,0x0
 a18:	d98080e7          	jalr	-616(ra) # 7ac <putc>
 a1c:	8b4a                	mv	s6,s2
      state = 0;
 a1e:	4981                	li	s3,0
 a20:	bd65                	j	8d8 <vprintf+0x60>
        putc(fd, c);
 a22:	85d2                	mv	a1,s4
 a24:	8556                	mv	a0,s5
 a26:	00000097          	auipc	ra,0x0
 a2a:	d86080e7          	jalr	-634(ra) # 7ac <putc>
      state = 0;
 a2e:	4981                	li	s3,0
 a30:	b565                	j	8d8 <vprintf+0x60>
        s = va_arg(ap, char*);
 a32:	8b4e                	mv	s6,s3
      state = 0;
 a34:	4981                	li	s3,0
 a36:	b54d                	j	8d8 <vprintf+0x60>
    }
  }
}
 a38:	70e6                	ld	ra,120(sp)
 a3a:	7446                	ld	s0,112(sp)
 a3c:	74a6                	ld	s1,104(sp)
 a3e:	7906                	ld	s2,96(sp)
 a40:	69e6                	ld	s3,88(sp)
 a42:	6a46                	ld	s4,80(sp)
 a44:	6aa6                	ld	s5,72(sp)
 a46:	6b06                	ld	s6,64(sp)
 a48:	7be2                	ld	s7,56(sp)
 a4a:	7c42                	ld	s8,48(sp)
 a4c:	7ca2                	ld	s9,40(sp)
 a4e:	7d02                	ld	s10,32(sp)
 a50:	6de2                	ld	s11,24(sp)
 a52:	6109                	addi	sp,sp,128
 a54:	8082                	ret

0000000000000a56 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a56:	715d                	addi	sp,sp,-80
 a58:	ec06                	sd	ra,24(sp)
 a5a:	e822                	sd	s0,16(sp)
 a5c:	1000                	addi	s0,sp,32
 a5e:	e010                	sd	a2,0(s0)
 a60:	e414                	sd	a3,8(s0)
 a62:	e818                	sd	a4,16(s0)
 a64:	ec1c                	sd	a5,24(s0)
 a66:	03043023          	sd	a6,32(s0)
 a6a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a6e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a72:	8622                	mv	a2,s0
 a74:	00000097          	auipc	ra,0x0
 a78:	e04080e7          	jalr	-508(ra) # 878 <vprintf>
}
 a7c:	60e2                	ld	ra,24(sp)
 a7e:	6442                	ld	s0,16(sp)
 a80:	6161                	addi	sp,sp,80
 a82:	8082                	ret

0000000000000a84 <printf>:

void
printf(const char *fmt, ...)
{
 a84:	711d                	addi	sp,sp,-96
 a86:	ec06                	sd	ra,24(sp)
 a88:	e822                	sd	s0,16(sp)
 a8a:	1000                	addi	s0,sp,32
 a8c:	e40c                	sd	a1,8(s0)
 a8e:	e810                	sd	a2,16(s0)
 a90:	ec14                	sd	a3,24(s0)
 a92:	f018                	sd	a4,32(s0)
 a94:	f41c                	sd	a5,40(s0)
 a96:	03043823          	sd	a6,48(s0)
 a9a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a9e:	00840613          	addi	a2,s0,8
 aa2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 aa6:	85aa                	mv	a1,a0
 aa8:	4505                	li	a0,1
 aaa:	00000097          	auipc	ra,0x0
 aae:	dce080e7          	jalr	-562(ra) # 878 <vprintf>
}
 ab2:	60e2                	ld	ra,24(sp)
 ab4:	6442                	ld	s0,16(sp)
 ab6:	6125                	addi	sp,sp,96
 ab8:	8082                	ret

0000000000000aba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 aba:	1141                	addi	sp,sp,-16
 abc:	e422                	sd	s0,8(sp)
 abe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ac0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac4:	00000797          	auipc	a5,0x0
 ac8:	29c7b783          	ld	a5,668(a5) # d60 <freep>
 acc:	a805                	j	afc <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ace:	4618                	lw	a4,8(a2)
 ad0:	9db9                	addw	a1,a1,a4
 ad2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ad6:	6398                	ld	a4,0(a5)
 ad8:	6318                	ld	a4,0(a4)
 ada:	fee53823          	sd	a4,-16(a0)
 ade:	a091                	j	b22 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ae0:	ff852703          	lw	a4,-8(a0)
 ae4:	9e39                	addw	a2,a2,a4
 ae6:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 ae8:	ff053703          	ld	a4,-16(a0)
 aec:	e398                	sd	a4,0(a5)
 aee:	a099                	j	b34 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 af0:	6398                	ld	a4,0(a5)
 af2:	00e7e463          	bltu	a5,a4,afa <free+0x40>
 af6:	00e6ea63          	bltu	a3,a4,b0a <free+0x50>
{
 afa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 afc:	fed7fae3          	bgeu	a5,a3,af0 <free+0x36>
 b00:	6398                	ld	a4,0(a5)
 b02:	00e6e463          	bltu	a3,a4,b0a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b06:	fee7eae3          	bltu	a5,a4,afa <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 b0a:	ff852583          	lw	a1,-8(a0)
 b0e:	6390                	ld	a2,0(a5)
 b10:	02059713          	slli	a4,a1,0x20
 b14:	9301                	srli	a4,a4,0x20
 b16:	0712                	slli	a4,a4,0x4
 b18:	9736                	add	a4,a4,a3
 b1a:	fae60ae3          	beq	a2,a4,ace <free+0x14>
    bp->s.ptr = p->s.ptr;
 b1e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b22:	4790                	lw	a2,8(a5)
 b24:	02061713          	slli	a4,a2,0x20
 b28:	9301                	srli	a4,a4,0x20
 b2a:	0712                	slli	a4,a4,0x4
 b2c:	973e                	add	a4,a4,a5
 b2e:	fae689e3          	beq	a3,a4,ae0 <free+0x26>
  } else
    p->s.ptr = bp;
 b32:	e394                	sd	a3,0(a5)
  freep = p;
 b34:	00000717          	auipc	a4,0x0
 b38:	22f73623          	sd	a5,556(a4) # d60 <freep>
}
 b3c:	6422                	ld	s0,8(sp)
 b3e:	0141                	addi	sp,sp,16
 b40:	8082                	ret

0000000000000b42 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b42:	7139                	addi	sp,sp,-64
 b44:	fc06                	sd	ra,56(sp)
 b46:	f822                	sd	s0,48(sp)
 b48:	f426                	sd	s1,40(sp)
 b4a:	f04a                	sd	s2,32(sp)
 b4c:	ec4e                	sd	s3,24(sp)
 b4e:	e852                	sd	s4,16(sp)
 b50:	e456                	sd	s5,8(sp)
 b52:	e05a                	sd	s6,0(sp)
 b54:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b56:	02051493          	slli	s1,a0,0x20
 b5a:	9081                	srli	s1,s1,0x20
 b5c:	04bd                	addi	s1,s1,15
 b5e:	8091                	srli	s1,s1,0x4
 b60:	0014899b          	addiw	s3,s1,1
 b64:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b66:	00000517          	auipc	a0,0x0
 b6a:	1fa53503          	ld	a0,506(a0) # d60 <freep>
 b6e:	c515                	beqz	a0,b9a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b70:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b72:	4798                	lw	a4,8(a5)
 b74:	02977f63          	bgeu	a4,s1,bb2 <malloc+0x70>
 b78:	8a4e                	mv	s4,s3
 b7a:	0009871b          	sext.w	a4,s3
 b7e:	6685                	lui	a3,0x1
 b80:	00d77363          	bgeu	a4,a3,b86 <malloc+0x44>
 b84:	6a05                	lui	s4,0x1
 b86:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b8a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b8e:	00000917          	auipc	s2,0x0
 b92:	1d290913          	addi	s2,s2,466 # d60 <freep>
  if(p == (char*)-1)
 b96:	5afd                	li	s5,-1
 b98:	a88d                	j	c0a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 b9a:	00004797          	auipc	a5,0x4
 b9e:	1ce78793          	addi	a5,a5,462 # 4d68 <base>
 ba2:	00000717          	auipc	a4,0x0
 ba6:	1af73f23          	sd	a5,446(a4) # d60 <freep>
 baa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 bac:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bb0:	b7e1                	j	b78 <malloc+0x36>
      if(p->s.size == nunits)
 bb2:	02e48b63          	beq	s1,a4,be8 <malloc+0xa6>
        p->s.size -= nunits;
 bb6:	4137073b          	subw	a4,a4,s3
 bba:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bbc:	1702                	slli	a4,a4,0x20
 bbe:	9301                	srli	a4,a4,0x20
 bc0:	0712                	slli	a4,a4,0x4
 bc2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bc4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bc8:	00000717          	auipc	a4,0x0
 bcc:	18a73c23          	sd	a0,408(a4) # d60 <freep>
      return (void*)(p + 1);
 bd0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bd4:	70e2                	ld	ra,56(sp)
 bd6:	7442                	ld	s0,48(sp)
 bd8:	74a2                	ld	s1,40(sp)
 bda:	7902                	ld	s2,32(sp)
 bdc:	69e2                	ld	s3,24(sp)
 bde:	6a42                	ld	s4,16(sp)
 be0:	6aa2                	ld	s5,8(sp)
 be2:	6b02                	ld	s6,0(sp)
 be4:	6121                	addi	sp,sp,64
 be6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 be8:	6398                	ld	a4,0(a5)
 bea:	e118                	sd	a4,0(a0)
 bec:	bff1                	j	bc8 <malloc+0x86>
  hp->s.size = nu;
 bee:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bf2:	0541                	addi	a0,a0,16
 bf4:	00000097          	auipc	ra,0x0
 bf8:	ec6080e7          	jalr	-314(ra) # aba <free>
  return freep;
 bfc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c00:	d971                	beqz	a0,bd4 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c02:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c04:	4798                	lw	a4,8(a5)
 c06:	fa9776e3          	bgeu	a4,s1,bb2 <malloc+0x70>
    if(p == freep)
 c0a:	00093703          	ld	a4,0(s2)
 c0e:	853e                	mv	a0,a5
 c10:	fef719e3          	bne	a4,a5,c02 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 c14:	8552                	mv	a0,s4
 c16:	00000097          	auipc	ra,0x0
 c1a:	b5e080e7          	jalr	-1186(ra) # 774 <sbrk>
  if(p == (char*)-1)
 c1e:	fd5518e3          	bne	a0,s5,bee <malloc+0xac>
        return 0;
 c22:	4501                	li	a0,0
 c24:	bf45                	j	bd4 <malloc+0x92>
