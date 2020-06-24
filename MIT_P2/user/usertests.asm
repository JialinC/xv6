
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <iputtest>:
char *echoargv[] = { "echo", "ALL", "TESTS", "PASSED", 0 };

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  printf("iput test\n");
       8:	00004517          	auipc	a0,0x4
       c:	6a850513          	addi	a0,a0,1704 # 46b0 <malloc+0x108>
      10:	00004097          	auipc	ra,0x4
      14:	4da080e7          	jalr	1242(ra) # 44ea <printf>

  if(mkdir("iputdir") < 0){
      18:	00004517          	auipc	a0,0x4
      1c:	6a850513          	addi	a0,a0,1704 # 46c0 <malloc+0x118>
      20:	00004097          	auipc	ra,0x4
      24:	19a080e7          	jalr	410(ra) # 41ba <mkdir>
      28:	04054c63          	bltz	a0,80 <iputtest+0x80>
    printf("mkdir failed\n");
    exit(-1);
  }
  if(chdir("iputdir") < 0){
      2c:	00004517          	auipc	a0,0x4
      30:	69450513          	addi	a0,a0,1684 # 46c0 <malloc+0x118>
      34:	00004097          	auipc	ra,0x4
      38:	18e080e7          	jalr	398(ra) # 41c2 <chdir>
      3c:	04054f63          	bltz	a0,9a <iputtest+0x9a>
    printf("chdir iputdir failed\n");
    exit(-1);
  }
  if(unlink("../iputdir") < 0){
      40:	00004517          	auipc	a0,0x4
      44:	6b050513          	addi	a0,a0,1712 # 46f0 <malloc+0x148>
      48:	00004097          	auipc	ra,0x4
      4c:	15a080e7          	jalr	346(ra) # 41a2 <unlink>
      50:	06054263          	bltz	a0,b4 <iputtest+0xb4>
    printf("unlink ../iputdir failed\n");
    exit(-1);
  }
  if(chdir("/") < 0){
      54:	00004517          	auipc	a0,0x4
      58:	6cc50513          	addi	a0,a0,1740 # 4720 <malloc+0x178>
      5c:	00004097          	auipc	ra,0x4
      60:	166080e7          	jalr	358(ra) # 41c2 <chdir>
      64:	06054563          	bltz	a0,ce <iputtest+0xce>
    printf("chdir / failed\n");
    exit(-1);
  }
  printf("iput test ok\n");
      68:	00004517          	auipc	a0,0x4
      6c:	6d050513          	addi	a0,a0,1744 # 4738 <malloc+0x190>
      70:	00004097          	auipc	ra,0x4
      74:	47a080e7          	jalr	1146(ra) # 44ea <printf>
}
      78:	60a2                	ld	ra,8(sp)
      7a:	6402                	ld	s0,0(sp)
      7c:	0141                	addi	sp,sp,16
      7e:	8082                	ret
    printf("mkdir failed\n");
      80:	00004517          	auipc	a0,0x4
      84:	64850513          	addi	a0,a0,1608 # 46c8 <malloc+0x120>
      88:	00004097          	auipc	ra,0x4
      8c:	462080e7          	jalr	1122(ra) # 44ea <printf>
    exit(-1);
      90:	557d                	li	a0,-1
      92:	00004097          	auipc	ra,0x4
      96:	0c0080e7          	jalr	192(ra) # 4152 <exit>
    printf("chdir iputdir failed\n");
      9a:	00004517          	auipc	a0,0x4
      9e:	63e50513          	addi	a0,a0,1598 # 46d8 <malloc+0x130>
      a2:	00004097          	auipc	ra,0x4
      a6:	448080e7          	jalr	1096(ra) # 44ea <printf>
    exit(-1);
      aa:	557d                	li	a0,-1
      ac:	00004097          	auipc	ra,0x4
      b0:	0a6080e7          	jalr	166(ra) # 4152 <exit>
    printf("unlink ../iputdir failed\n");
      b4:	00004517          	auipc	a0,0x4
      b8:	64c50513          	addi	a0,a0,1612 # 4700 <malloc+0x158>
      bc:	00004097          	auipc	ra,0x4
      c0:	42e080e7          	jalr	1070(ra) # 44ea <printf>
    exit(-1);
      c4:	557d                	li	a0,-1
      c6:	00004097          	auipc	ra,0x4
      ca:	08c080e7          	jalr	140(ra) # 4152 <exit>
    printf("chdir / failed\n");
      ce:	00004517          	auipc	a0,0x4
      d2:	65a50513          	addi	a0,a0,1626 # 4728 <malloc+0x180>
      d6:	00004097          	auipc	ra,0x4
      da:	414080e7          	jalr	1044(ra) # 44ea <printf>
    exit(-1);
      de:	557d                	li	a0,-1
      e0:	00004097          	auipc	ra,0x4
      e4:	072080e7          	jalr	114(ra) # 4152 <exit>

00000000000000e8 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      e8:	1141                	addi	sp,sp,-16
      ea:	e406                	sd	ra,8(sp)
      ec:	e022                	sd	s0,0(sp)
      ee:	0800                	addi	s0,sp,16
  int pid;

  printf("exitiput test\n");
      f0:	00004517          	auipc	a0,0x4
      f4:	65850513          	addi	a0,a0,1624 # 4748 <malloc+0x1a0>
      f8:	00004097          	auipc	ra,0x4
      fc:	3f2080e7          	jalr	1010(ra) # 44ea <printf>

  pid = fork();
     100:	00004097          	auipc	ra,0x4
     104:	04a080e7          	jalr	74(ra) # 414a <fork>
  if(pid < 0){
     108:	04054663          	bltz	a0,154 <exitiputtest+0x6c>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid == 0){
     10c:	e945                	bnez	a0,1bc <exitiputtest+0xd4>
    if(mkdir("iputdir") < 0){
     10e:	00004517          	auipc	a0,0x4
     112:	5b250513          	addi	a0,a0,1458 # 46c0 <malloc+0x118>
     116:	00004097          	auipc	ra,0x4
     11a:	0a4080e7          	jalr	164(ra) # 41ba <mkdir>
     11e:	04054863          	bltz	a0,16e <exitiputtest+0x86>
      printf("mkdir failed\n");
      exit(-1);
    }
    if(chdir("iputdir") < 0){
     122:	00004517          	auipc	a0,0x4
     126:	59e50513          	addi	a0,a0,1438 # 46c0 <malloc+0x118>
     12a:	00004097          	auipc	ra,0x4
     12e:	098080e7          	jalr	152(ra) # 41c2 <chdir>
     132:	04054b63          	bltz	a0,188 <exitiputtest+0xa0>
      printf("child chdir failed\n");
      exit(-1);
    }
    if(unlink("../iputdir") < 0){
     136:	00004517          	auipc	a0,0x4
     13a:	5ba50513          	addi	a0,a0,1466 # 46f0 <malloc+0x148>
     13e:	00004097          	auipc	ra,0x4
     142:	064080e7          	jalr	100(ra) # 41a2 <unlink>
     146:	04054e63          	bltz	a0,1a2 <exitiputtest+0xba>
      printf("unlink ../iputdir failed\n");
      exit(-1);
    }
    exit(0);
     14a:	4501                	li	a0,0
     14c:	00004097          	auipc	ra,0x4
     150:	006080e7          	jalr	6(ra) # 4152 <exit>
    printf("fork failed\n");
     154:	00004517          	auipc	a0,0x4
     158:	60450513          	addi	a0,a0,1540 # 4758 <malloc+0x1b0>
     15c:	00004097          	auipc	ra,0x4
     160:	38e080e7          	jalr	910(ra) # 44ea <printf>
    exit(-1);
     164:	557d                	li	a0,-1
     166:	00004097          	auipc	ra,0x4
     16a:	fec080e7          	jalr	-20(ra) # 4152 <exit>
      printf("mkdir failed\n");
     16e:	00004517          	auipc	a0,0x4
     172:	55a50513          	addi	a0,a0,1370 # 46c8 <malloc+0x120>
     176:	00004097          	auipc	ra,0x4
     17a:	374080e7          	jalr	884(ra) # 44ea <printf>
      exit(-1);
     17e:	557d                	li	a0,-1
     180:	00004097          	auipc	ra,0x4
     184:	fd2080e7          	jalr	-46(ra) # 4152 <exit>
      printf("child chdir failed\n");
     188:	00004517          	auipc	a0,0x4
     18c:	5e050513          	addi	a0,a0,1504 # 4768 <malloc+0x1c0>
     190:	00004097          	auipc	ra,0x4
     194:	35a080e7          	jalr	858(ra) # 44ea <printf>
      exit(-1);
     198:	557d                	li	a0,-1
     19a:	00004097          	auipc	ra,0x4
     19e:	fb8080e7          	jalr	-72(ra) # 4152 <exit>
      printf("unlink ../iputdir failed\n");
     1a2:	00004517          	auipc	a0,0x4
     1a6:	55e50513          	addi	a0,a0,1374 # 4700 <malloc+0x158>
     1aa:	00004097          	auipc	ra,0x4
     1ae:	340080e7          	jalr	832(ra) # 44ea <printf>
      exit(-1);
     1b2:	557d                	li	a0,-1
     1b4:	00004097          	auipc	ra,0x4
     1b8:	f9e080e7          	jalr	-98(ra) # 4152 <exit>
  }
  wait(0);
     1bc:	4501                	li	a0,0
     1be:	00004097          	auipc	ra,0x4
     1c2:	f9c080e7          	jalr	-100(ra) # 415a <wait>
  printf("exitiput test ok\n");
     1c6:	00004517          	auipc	a0,0x4
     1ca:	5ba50513          	addi	a0,a0,1466 # 4780 <malloc+0x1d8>
     1ce:	00004097          	auipc	ra,0x4
     1d2:	31c080e7          	jalr	796(ra) # 44ea <printf>
}
     1d6:	60a2                	ld	ra,8(sp)
     1d8:	6402                	ld	s0,0(sp)
     1da:	0141                	addi	sp,sp,16
     1dc:	8082                	ret

00000000000001de <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1de:	1141                	addi	sp,sp,-16
     1e0:	e406                	sd	ra,8(sp)
     1e2:	e022                	sd	s0,0(sp)
     1e4:	0800                	addi	s0,sp,16
  int pid;

  printf("openiput test\n");
     1e6:	00004517          	auipc	a0,0x4
     1ea:	5b250513          	addi	a0,a0,1458 # 4798 <malloc+0x1f0>
     1ee:	00004097          	auipc	ra,0x4
     1f2:	2fc080e7          	jalr	764(ra) # 44ea <printf>
  if(mkdir("oidir") < 0){
     1f6:	00004517          	auipc	a0,0x4
     1fa:	5b250513          	addi	a0,a0,1458 # 47a8 <malloc+0x200>
     1fe:	00004097          	auipc	ra,0x4
     202:	fbc080e7          	jalr	-68(ra) # 41ba <mkdir>
     206:	04054163          	bltz	a0,248 <openiputtest+0x6a>
    printf("mkdir oidir failed\n");
    exit(-1);
  }
  pid = fork();
     20a:	00004097          	auipc	ra,0x4
     20e:	f40080e7          	jalr	-192(ra) # 414a <fork>
  if(pid < 0){
     212:	04054863          	bltz	a0,262 <openiputtest+0x84>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid == 0){
     216:	e925                	bnez	a0,286 <openiputtest+0xa8>
    int fd = open("oidir", O_RDWR);
     218:	4589                	li	a1,2
     21a:	00004517          	auipc	a0,0x4
     21e:	58e50513          	addi	a0,a0,1422 # 47a8 <malloc+0x200>
     222:	00004097          	auipc	ra,0x4
     226:	f70080e7          	jalr	-144(ra) # 4192 <open>
    if(fd >= 0){
     22a:	04054963          	bltz	a0,27c <openiputtest+0x9e>
      printf("open directory for write succeeded\n");
     22e:	00004517          	auipc	a0,0x4
     232:	59a50513          	addi	a0,a0,1434 # 47c8 <malloc+0x220>
     236:	00004097          	auipc	ra,0x4
     23a:	2b4080e7          	jalr	692(ra) # 44ea <printf>
      exit(-1);
     23e:	557d                	li	a0,-1
     240:	00004097          	auipc	ra,0x4
     244:	f12080e7          	jalr	-238(ra) # 4152 <exit>
    printf("mkdir oidir failed\n");
     248:	00004517          	auipc	a0,0x4
     24c:	56850513          	addi	a0,a0,1384 # 47b0 <malloc+0x208>
     250:	00004097          	auipc	ra,0x4
     254:	29a080e7          	jalr	666(ra) # 44ea <printf>
    exit(-1);
     258:	557d                	li	a0,-1
     25a:	00004097          	auipc	ra,0x4
     25e:	ef8080e7          	jalr	-264(ra) # 4152 <exit>
    printf("fork failed\n");
     262:	00004517          	auipc	a0,0x4
     266:	4f650513          	addi	a0,a0,1270 # 4758 <malloc+0x1b0>
     26a:	00004097          	auipc	ra,0x4
     26e:	280080e7          	jalr	640(ra) # 44ea <printf>
    exit(-1);
     272:	557d                	li	a0,-1
     274:	00004097          	auipc	ra,0x4
     278:	ede080e7          	jalr	-290(ra) # 4152 <exit>
    }
    exit(0);
     27c:	4501                	li	a0,0
     27e:	00004097          	auipc	ra,0x4
     282:	ed4080e7          	jalr	-300(ra) # 4152 <exit>
  }
  sleep(1);
     286:	4505                	li	a0,1
     288:	00004097          	auipc	ra,0x4
     28c:	f5a080e7          	jalr	-166(ra) # 41e2 <sleep>
  if(unlink("oidir") != 0){
     290:	00004517          	auipc	a0,0x4
     294:	51850513          	addi	a0,a0,1304 # 47a8 <malloc+0x200>
     298:	00004097          	auipc	ra,0x4
     29c:	f0a080e7          	jalr	-246(ra) # 41a2 <unlink>
     2a0:	e115                	bnez	a0,2c4 <openiputtest+0xe6>
    printf("unlink failed\n");
    exit(-1);
  }
  wait(0);
     2a2:	4501                	li	a0,0
     2a4:	00004097          	auipc	ra,0x4
     2a8:	eb6080e7          	jalr	-330(ra) # 415a <wait>
  printf("openiput test ok\n");
     2ac:	00004517          	auipc	a0,0x4
     2b0:	55450513          	addi	a0,a0,1364 # 4800 <malloc+0x258>
     2b4:	00004097          	auipc	ra,0x4
     2b8:	236080e7          	jalr	566(ra) # 44ea <printf>
}
     2bc:	60a2                	ld	ra,8(sp)
     2be:	6402                	ld	s0,0(sp)
     2c0:	0141                	addi	sp,sp,16
     2c2:	8082                	ret
    printf("unlink failed\n");
     2c4:	00004517          	auipc	a0,0x4
     2c8:	52c50513          	addi	a0,a0,1324 # 47f0 <malloc+0x248>
     2cc:	00004097          	auipc	ra,0x4
     2d0:	21e080e7          	jalr	542(ra) # 44ea <printf>
    exit(-1);
     2d4:	557d                	li	a0,-1
     2d6:	00004097          	auipc	ra,0x4
     2da:	e7c080e7          	jalr	-388(ra) # 4152 <exit>

00000000000002de <opentest>:

// simple file system tests

void
opentest(void)
{
     2de:	1141                	addi	sp,sp,-16
     2e0:	e406                	sd	ra,8(sp)
     2e2:	e022                	sd	s0,0(sp)
     2e4:	0800                	addi	s0,sp,16
  int fd;

  printf("open test\n");
     2e6:	00004517          	auipc	a0,0x4
     2ea:	53250513          	addi	a0,a0,1330 # 4818 <malloc+0x270>
     2ee:	00004097          	auipc	ra,0x4
     2f2:	1fc080e7          	jalr	508(ra) # 44ea <printf>
  fd = open("echo", 0);
     2f6:	4581                	li	a1,0
     2f8:	00004517          	auipc	a0,0x4
     2fc:	53050513          	addi	a0,a0,1328 # 4828 <malloc+0x280>
     300:	00004097          	auipc	ra,0x4
     304:	e92080e7          	jalr	-366(ra) # 4192 <open>
  if(fd < 0){
     308:	02054d63          	bltz	a0,342 <opentest+0x64>
    printf("open echo failed!\n");
    exit(-1);
  }
  close(fd);
     30c:	00004097          	auipc	ra,0x4
     310:	e6e080e7          	jalr	-402(ra) # 417a <close>
  fd = open("doesnotexist", 0);
     314:	4581                	li	a1,0
     316:	00004517          	auipc	a0,0x4
     31a:	53250513          	addi	a0,a0,1330 # 4848 <malloc+0x2a0>
     31e:	00004097          	auipc	ra,0x4
     322:	e74080e7          	jalr	-396(ra) # 4192 <open>
  if(fd >= 0){
     326:	02055b63          	bgez	a0,35c <opentest+0x7e>
    printf("open doesnotexist succeeded!\n");
    exit(-1);
  }
  printf("open test ok\n");
     32a:	00004517          	auipc	a0,0x4
     32e:	54e50513          	addi	a0,a0,1358 # 4878 <malloc+0x2d0>
     332:	00004097          	auipc	ra,0x4
     336:	1b8080e7          	jalr	440(ra) # 44ea <printf>
}
     33a:	60a2                	ld	ra,8(sp)
     33c:	6402                	ld	s0,0(sp)
     33e:	0141                	addi	sp,sp,16
     340:	8082                	ret
    printf("open echo failed!\n");
     342:	00004517          	auipc	a0,0x4
     346:	4ee50513          	addi	a0,a0,1262 # 4830 <malloc+0x288>
     34a:	00004097          	auipc	ra,0x4
     34e:	1a0080e7          	jalr	416(ra) # 44ea <printf>
    exit(-1);
     352:	557d                	li	a0,-1
     354:	00004097          	auipc	ra,0x4
     358:	dfe080e7          	jalr	-514(ra) # 4152 <exit>
    printf("open doesnotexist succeeded!\n");
     35c:	00004517          	auipc	a0,0x4
     360:	4fc50513          	addi	a0,a0,1276 # 4858 <malloc+0x2b0>
     364:	00004097          	auipc	ra,0x4
     368:	186080e7          	jalr	390(ra) # 44ea <printf>
    exit(-1);
     36c:	557d                	li	a0,-1
     36e:	00004097          	auipc	ra,0x4
     372:	de4080e7          	jalr	-540(ra) # 4152 <exit>

0000000000000376 <writetest>:

void
writetest(void)
{
     376:	7139                	addi	sp,sp,-64
     378:	fc06                	sd	ra,56(sp)
     37a:	f822                	sd	s0,48(sp)
     37c:	f426                	sd	s1,40(sp)
     37e:	f04a                	sd	s2,32(sp)
     380:	ec4e                	sd	s3,24(sp)
     382:	e852                	sd	s4,16(sp)
     384:	e456                	sd	s5,8(sp)
     386:	0080                	addi	s0,sp,64
  int fd;
  int i;
  enum { N=100, SZ=10 };
  
  printf("small file test\n");
     388:	00004517          	auipc	a0,0x4
     38c:	50050513          	addi	a0,a0,1280 # 4888 <malloc+0x2e0>
     390:	00004097          	auipc	ra,0x4
     394:	15a080e7          	jalr	346(ra) # 44ea <printf>
  fd = open("small", O_CREATE|O_RDWR);
     398:	20200593          	li	a1,514
     39c:	00004517          	auipc	a0,0x4
     3a0:	50450513          	addi	a0,a0,1284 # 48a0 <malloc+0x2f8>
     3a4:	00004097          	auipc	ra,0x4
     3a8:	dee080e7          	jalr	-530(ra) # 4192 <open>
  if(fd >= 0){
     3ac:	10054563          	bltz	a0,4b6 <writetest+0x140>
     3b0:	892a                	mv	s2,a0
    printf("creat small succeeded; ok\n");
     3b2:	00004517          	auipc	a0,0x4
     3b6:	4f650513          	addi	a0,a0,1270 # 48a8 <malloc+0x300>
     3ba:	00004097          	auipc	ra,0x4
     3be:	130080e7          	jalr	304(ra) # 44ea <printf>
  } else {
    printf("error: creat small failed!\n");
    exit(-1);
  }
  for(i = 0; i < N; i++){
     3c2:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     3c4:	00004997          	auipc	s3,0x4
     3c8:	52498993          	addi	s3,s3,1316 # 48e8 <malloc+0x340>
      printf("error: write aa %d new file failed\n", i);
      exit(-1);
    }
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     3cc:	00004a97          	auipc	s5,0x4
     3d0:	554a8a93          	addi	s5,s5,1364 # 4920 <malloc+0x378>
  for(i = 0; i < N; i++){
     3d4:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     3d8:	4629                	li	a2,10
     3da:	85ce                	mv	a1,s3
     3dc:	854a                	mv	a0,s2
     3de:	00004097          	auipc	ra,0x4
     3e2:	d94080e7          	jalr	-620(ra) # 4172 <write>
     3e6:	47a9                	li	a5,10
     3e8:	0ef51463          	bne	a0,a5,4d0 <writetest+0x15a>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     3ec:	4629                	li	a2,10
     3ee:	85d6                	mv	a1,s5
     3f0:	854a                	mv	a0,s2
     3f2:	00004097          	auipc	ra,0x4
     3f6:	d80080e7          	jalr	-640(ra) # 4172 <write>
     3fa:	47a9                	li	a5,10
     3fc:	0ef51863          	bne	a0,a5,4ec <writetest+0x176>
  for(i = 0; i < N; i++){
     400:	2485                	addiw	s1,s1,1
     402:	fd449be3          	bne	s1,s4,3d8 <writetest+0x62>
      printf("error: write bb %d new file failed\n", i);
      exit(-1);
    }
  }
  printf("writes ok\n");
     406:	00004517          	auipc	a0,0x4
     40a:	55250513          	addi	a0,a0,1362 # 4958 <malloc+0x3b0>
     40e:	00004097          	auipc	ra,0x4
     412:	0dc080e7          	jalr	220(ra) # 44ea <printf>
  close(fd);
     416:	854a                	mv	a0,s2
     418:	00004097          	auipc	ra,0x4
     41c:	d62080e7          	jalr	-670(ra) # 417a <close>
  fd = open("small", O_RDONLY);
     420:	4581                	li	a1,0
     422:	00004517          	auipc	a0,0x4
     426:	47e50513          	addi	a0,a0,1150 # 48a0 <malloc+0x2f8>
     42a:	00004097          	auipc	ra,0x4
     42e:	d68080e7          	jalr	-664(ra) # 4192 <open>
     432:	84aa                	mv	s1,a0
  if(fd >= 0){
     434:	0c054a63          	bltz	a0,508 <writetest+0x192>
    printf("open small succeeded ok\n");
     438:	00004517          	auipc	a0,0x4
     43c:	53050513          	addi	a0,a0,1328 # 4968 <malloc+0x3c0>
     440:	00004097          	auipc	ra,0x4
     444:	0aa080e7          	jalr	170(ra) # 44ea <printf>
  } else {
    printf("error: open small failed!\n");
    exit(-1);
  }
  i = read(fd, buf, N*SZ*2);
     448:	7d000613          	li	a2,2000
     44c:	00009597          	auipc	a1,0x9
     450:	84458593          	addi	a1,a1,-1980 # 8c90 <buf>
     454:	8526                	mv	a0,s1
     456:	00004097          	auipc	ra,0x4
     45a:	d14080e7          	jalr	-748(ra) # 416a <read>
  if(i == N*SZ*2){
     45e:	7d000793          	li	a5,2000
     462:	0cf51063          	bne	a0,a5,522 <writetest+0x1ac>
    printf("read succeeded ok\n");
     466:	00004517          	auipc	a0,0x4
     46a:	54250513          	addi	a0,a0,1346 # 49a8 <malloc+0x400>
     46e:	00004097          	auipc	ra,0x4
     472:	07c080e7          	jalr	124(ra) # 44ea <printf>
  } else {
    printf("read failed\n");
    exit(-1);
  }
  close(fd);
     476:	8526                	mv	a0,s1
     478:	00004097          	auipc	ra,0x4
     47c:	d02080e7          	jalr	-766(ra) # 417a <close>

  if(unlink("small") < 0){
     480:	00004517          	auipc	a0,0x4
     484:	42050513          	addi	a0,a0,1056 # 48a0 <malloc+0x2f8>
     488:	00004097          	auipc	ra,0x4
     48c:	d1a080e7          	jalr	-742(ra) # 41a2 <unlink>
     490:	0a054663          	bltz	a0,53c <writetest+0x1c6>
    printf("unlink small failed\n");
    exit(-1);
  }
  printf("small file test ok\n");
     494:	00004517          	auipc	a0,0x4
     498:	55450513          	addi	a0,a0,1364 # 49e8 <malloc+0x440>
     49c:	00004097          	auipc	ra,0x4
     4a0:	04e080e7          	jalr	78(ra) # 44ea <printf>
}
     4a4:	70e2                	ld	ra,56(sp)
     4a6:	7442                	ld	s0,48(sp)
     4a8:	74a2                	ld	s1,40(sp)
     4aa:	7902                	ld	s2,32(sp)
     4ac:	69e2                	ld	s3,24(sp)
     4ae:	6a42                	ld	s4,16(sp)
     4b0:	6aa2                	ld	s5,8(sp)
     4b2:	6121                	addi	sp,sp,64
     4b4:	8082                	ret
    printf("error: creat small failed!\n");
     4b6:	00004517          	auipc	a0,0x4
     4ba:	41250513          	addi	a0,a0,1042 # 48c8 <malloc+0x320>
     4be:	00004097          	auipc	ra,0x4
     4c2:	02c080e7          	jalr	44(ra) # 44ea <printf>
    exit(-1);
     4c6:	557d                	li	a0,-1
     4c8:	00004097          	auipc	ra,0x4
     4cc:	c8a080e7          	jalr	-886(ra) # 4152 <exit>
      printf("error: write aa %d new file failed\n", i);
     4d0:	85a6                	mv	a1,s1
     4d2:	00004517          	auipc	a0,0x4
     4d6:	42650513          	addi	a0,a0,1062 # 48f8 <malloc+0x350>
     4da:	00004097          	auipc	ra,0x4
     4de:	010080e7          	jalr	16(ra) # 44ea <printf>
      exit(-1);
     4e2:	557d                	li	a0,-1
     4e4:	00004097          	auipc	ra,0x4
     4e8:	c6e080e7          	jalr	-914(ra) # 4152 <exit>
      printf("error: write bb %d new file failed\n", i);
     4ec:	85a6                	mv	a1,s1
     4ee:	00004517          	auipc	a0,0x4
     4f2:	44250513          	addi	a0,a0,1090 # 4930 <malloc+0x388>
     4f6:	00004097          	auipc	ra,0x4
     4fa:	ff4080e7          	jalr	-12(ra) # 44ea <printf>
      exit(-1);
     4fe:	557d                	li	a0,-1
     500:	00004097          	auipc	ra,0x4
     504:	c52080e7          	jalr	-942(ra) # 4152 <exit>
    printf("error: open small failed!\n");
     508:	00004517          	auipc	a0,0x4
     50c:	48050513          	addi	a0,a0,1152 # 4988 <malloc+0x3e0>
     510:	00004097          	auipc	ra,0x4
     514:	fda080e7          	jalr	-38(ra) # 44ea <printf>
    exit(-1);
     518:	557d                	li	a0,-1
     51a:	00004097          	auipc	ra,0x4
     51e:	c38080e7          	jalr	-968(ra) # 4152 <exit>
    printf("read failed\n");
     522:	00004517          	auipc	a0,0x4
     526:	49e50513          	addi	a0,a0,1182 # 49c0 <malloc+0x418>
     52a:	00004097          	auipc	ra,0x4
     52e:	fc0080e7          	jalr	-64(ra) # 44ea <printf>
    exit(-1);
     532:	557d                	li	a0,-1
     534:	00004097          	auipc	ra,0x4
     538:	c1e080e7          	jalr	-994(ra) # 4152 <exit>
    printf("unlink small failed\n");
     53c:	00004517          	auipc	a0,0x4
     540:	49450513          	addi	a0,a0,1172 # 49d0 <malloc+0x428>
     544:	00004097          	auipc	ra,0x4
     548:	fa6080e7          	jalr	-90(ra) # 44ea <printf>
    exit(-1);
     54c:	557d                	li	a0,-1
     54e:	00004097          	auipc	ra,0x4
     552:	c04080e7          	jalr	-1020(ra) # 4152 <exit>

0000000000000556 <writetest1>:

void
writetest1(void)
{
     556:	7179                	addi	sp,sp,-48
     558:	f406                	sd	ra,40(sp)
     55a:	f022                	sd	s0,32(sp)
     55c:	ec26                	sd	s1,24(sp)
     55e:	e84a                	sd	s2,16(sp)
     560:	e44e                	sd	s3,8(sp)
     562:	e052                	sd	s4,0(sp)
     564:	1800                	addi	s0,sp,48
  int i, fd, n;

  printf("big files test\n");
     566:	00004517          	auipc	a0,0x4
     56a:	49a50513          	addi	a0,a0,1178 # 4a00 <malloc+0x458>
     56e:	00004097          	auipc	ra,0x4
     572:	f7c080e7          	jalr	-132(ra) # 44ea <printf>

  fd = open("big", O_CREATE|O_RDWR);
     576:	20200593          	li	a1,514
     57a:	00004517          	auipc	a0,0x4
     57e:	49650513          	addi	a0,a0,1174 # 4a10 <malloc+0x468>
     582:	00004097          	auipc	ra,0x4
     586:	c10080e7          	jalr	-1008(ra) # 4192 <open>
     58a:	89aa                	mv	s3,a0
  if(fd < 0){
    printf("error: creat big failed!\n");
    exit(-1);
  }

  for(i = 0; i < MAXFILE; i++){
     58c:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     58e:	00008917          	auipc	s2,0x8
     592:	70290913          	addi	s2,s2,1794 # 8c90 <buf>
  for(i = 0; i < MAXFILE; i++){
     596:	10c00a13          	li	s4,268
  if(fd < 0){
     59a:	06054c63          	bltz	a0,612 <writetest1+0xbc>
    ((int*)buf)[0] = i;
     59e:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     5a2:	40000613          	li	a2,1024
     5a6:	85ca                	mv	a1,s2
     5a8:	854e                	mv	a0,s3
     5aa:	00004097          	auipc	ra,0x4
     5ae:	bc8080e7          	jalr	-1080(ra) # 4172 <write>
     5b2:	40000793          	li	a5,1024
     5b6:	06f51b63          	bne	a0,a5,62c <writetest1+0xd6>
  for(i = 0; i < MAXFILE; i++){
     5ba:	2485                	addiw	s1,s1,1
     5bc:	ff4491e3          	bne	s1,s4,59e <writetest1+0x48>
      printf("error: write big file failed\n", i);
      exit(-1);
    }
  }

  close(fd);
     5c0:	854e                	mv	a0,s3
     5c2:	00004097          	auipc	ra,0x4
     5c6:	bb8080e7          	jalr	-1096(ra) # 417a <close>

  fd = open("big", O_RDONLY);
     5ca:	4581                	li	a1,0
     5cc:	00004517          	auipc	a0,0x4
     5d0:	44450513          	addi	a0,a0,1092 # 4a10 <malloc+0x468>
     5d4:	00004097          	auipc	ra,0x4
     5d8:	bbe080e7          	jalr	-1090(ra) # 4192 <open>
     5dc:	89aa                	mv	s3,a0
  if(fd < 0){
    printf("error: open big failed!\n");
    exit(-1);
  }

  n = 0;
     5de:	4481                	li	s1,0
  for(;;){
    i = read(fd, buf, BSIZE);
     5e0:	00008917          	auipc	s2,0x8
     5e4:	6b090913          	addi	s2,s2,1712 # 8c90 <buf>
  if(fd < 0){
     5e8:	06054063          	bltz	a0,648 <writetest1+0xf2>
    i = read(fd, buf, BSIZE);
     5ec:	40000613          	li	a2,1024
     5f0:	85ca                	mv	a1,s2
     5f2:	854e                	mv	a0,s3
     5f4:	00004097          	auipc	ra,0x4
     5f8:	b76080e7          	jalr	-1162(ra) # 416a <read>
    if(i == 0){
     5fc:	c13d                	beqz	a0,662 <writetest1+0x10c>
      if(n == MAXFILE - 1){
        printf("read only %d blocks from big", n);
        exit(-1);
      }
      break;
    } else if(i != BSIZE){
     5fe:	40000793          	li	a5,1024
     602:	0cf51263          	bne	a0,a5,6c6 <writetest1+0x170>
      printf("read failed %d\n", i);
      exit(-1);
    }
    if(((int*)buf)[0] != n){
     606:	00092603          	lw	a2,0(s2)
     60a:	0c961c63          	bne	a2,s1,6e2 <writetest1+0x18c>
      printf("read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit(-1);
    }
    n++;
     60e:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     610:	bff1                	j	5ec <writetest1+0x96>
    printf("error: creat big failed!\n");
     612:	00004517          	auipc	a0,0x4
     616:	40650513          	addi	a0,a0,1030 # 4a18 <malloc+0x470>
     61a:	00004097          	auipc	ra,0x4
     61e:	ed0080e7          	jalr	-304(ra) # 44ea <printf>
    exit(-1);
     622:	557d                	li	a0,-1
     624:	00004097          	auipc	ra,0x4
     628:	b2e080e7          	jalr	-1234(ra) # 4152 <exit>
      printf("error: write big file failed\n", i);
     62c:	85a6                	mv	a1,s1
     62e:	00004517          	auipc	a0,0x4
     632:	40a50513          	addi	a0,a0,1034 # 4a38 <malloc+0x490>
     636:	00004097          	auipc	ra,0x4
     63a:	eb4080e7          	jalr	-332(ra) # 44ea <printf>
      exit(-1);
     63e:	557d                	li	a0,-1
     640:	00004097          	auipc	ra,0x4
     644:	b12080e7          	jalr	-1262(ra) # 4152 <exit>
    printf("error: open big failed!\n");
     648:	00004517          	auipc	a0,0x4
     64c:	41050513          	addi	a0,a0,1040 # 4a58 <malloc+0x4b0>
     650:	00004097          	auipc	ra,0x4
     654:	e9a080e7          	jalr	-358(ra) # 44ea <printf>
    exit(-1);
     658:	557d                	li	a0,-1
     65a:	00004097          	auipc	ra,0x4
     65e:	af8080e7          	jalr	-1288(ra) # 4152 <exit>
      if(n == MAXFILE - 1){
     662:	10b00793          	li	a5,267
     666:	04f48163          	beq	s1,a5,6a8 <writetest1+0x152>
  }
  close(fd);
     66a:	854e                	mv	a0,s3
     66c:	00004097          	auipc	ra,0x4
     670:	b0e080e7          	jalr	-1266(ra) # 417a <close>
  if(unlink("big") < 0){
     674:	00004517          	auipc	a0,0x4
     678:	39c50513          	addi	a0,a0,924 # 4a10 <malloc+0x468>
     67c:	00004097          	auipc	ra,0x4
     680:	b26080e7          	jalr	-1242(ra) # 41a2 <unlink>
     684:	06054d63          	bltz	a0,6fe <writetest1+0x1a8>
    printf("unlink big failed\n");
    exit(-1);
  }
  printf("big files ok\n");
     688:	00004517          	auipc	a0,0x4
     68c:	45850513          	addi	a0,a0,1112 # 4ae0 <malloc+0x538>
     690:	00004097          	auipc	ra,0x4
     694:	e5a080e7          	jalr	-422(ra) # 44ea <printf>
}
     698:	70a2                	ld	ra,40(sp)
     69a:	7402                	ld	s0,32(sp)
     69c:	64e2                	ld	s1,24(sp)
     69e:	6942                	ld	s2,16(sp)
     6a0:	69a2                	ld	s3,8(sp)
     6a2:	6a02                	ld	s4,0(sp)
     6a4:	6145                	addi	sp,sp,48
     6a6:	8082                	ret
        printf("read only %d blocks from big", n);
     6a8:	10b00593          	li	a1,267
     6ac:	00004517          	auipc	a0,0x4
     6b0:	3cc50513          	addi	a0,a0,972 # 4a78 <malloc+0x4d0>
     6b4:	00004097          	auipc	ra,0x4
     6b8:	e36080e7          	jalr	-458(ra) # 44ea <printf>
        exit(-1);
     6bc:	557d                	li	a0,-1
     6be:	00004097          	auipc	ra,0x4
     6c2:	a94080e7          	jalr	-1388(ra) # 4152 <exit>
      printf("read failed %d\n", i);
     6c6:	85aa                	mv	a1,a0
     6c8:	00004517          	auipc	a0,0x4
     6cc:	3d050513          	addi	a0,a0,976 # 4a98 <malloc+0x4f0>
     6d0:	00004097          	auipc	ra,0x4
     6d4:	e1a080e7          	jalr	-486(ra) # 44ea <printf>
      exit(-1);
     6d8:	557d                	li	a0,-1
     6da:	00004097          	auipc	ra,0x4
     6de:	a78080e7          	jalr	-1416(ra) # 4152 <exit>
      printf("read content of block %d is %d\n",
     6e2:	85a6                	mv	a1,s1
     6e4:	00004517          	auipc	a0,0x4
     6e8:	3c450513          	addi	a0,a0,964 # 4aa8 <malloc+0x500>
     6ec:	00004097          	auipc	ra,0x4
     6f0:	dfe080e7          	jalr	-514(ra) # 44ea <printf>
      exit(-1);
     6f4:	557d                	li	a0,-1
     6f6:	00004097          	auipc	ra,0x4
     6fa:	a5c080e7          	jalr	-1444(ra) # 4152 <exit>
    printf("unlink big failed\n");
     6fe:	00004517          	auipc	a0,0x4
     702:	3ca50513          	addi	a0,a0,970 # 4ac8 <malloc+0x520>
     706:	00004097          	auipc	ra,0x4
     70a:	de4080e7          	jalr	-540(ra) # 44ea <printf>
    exit(-1);
     70e:	557d                	li	a0,-1
     710:	00004097          	auipc	ra,0x4
     714:	a42080e7          	jalr	-1470(ra) # 4152 <exit>

0000000000000718 <createtest>:

void
createtest(void)
{
     718:	7179                	addi	sp,sp,-48
     71a:	f406                	sd	ra,40(sp)
     71c:	f022                	sd	s0,32(sp)
     71e:	ec26                	sd	s1,24(sp)
     720:	e84a                	sd	s2,16(sp)
     722:	e44e                	sd	s3,8(sp)
     724:	1800                	addi	s0,sp,48
  int i, fd;
  enum { N=52 };
  
  printf("many creates, followed by unlink test\n");
     726:	00004517          	auipc	a0,0x4
     72a:	3ca50513          	addi	a0,a0,970 # 4af0 <malloc+0x548>
     72e:	00004097          	auipc	ra,0x4
     732:	dbc080e7          	jalr	-580(ra) # 44ea <printf>

  name[0] = 'a';
     736:	00006797          	auipc	a5,0x6
     73a:	d3a78793          	addi	a5,a5,-710 # 6470 <name>
     73e:	06100713          	li	a4,97
     742:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     746:	00078123          	sb	zero,2(a5)
     74a:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
    name[1] = '0' + i;
     74e:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     750:	06400993          	li	s3,100
    name[1] = '0' + i;
     754:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
     758:	20200593          	li	a1,514
     75c:	854a                	mv	a0,s2
     75e:	00004097          	auipc	ra,0x4
     762:	a34080e7          	jalr	-1484(ra) # 4192 <open>
    close(fd);
     766:	00004097          	auipc	ra,0x4
     76a:	a14080e7          	jalr	-1516(ra) # 417a <close>
  for(i = 0; i < N; i++){
     76e:	2485                	addiw	s1,s1,1
     770:	0ff4f493          	andi	s1,s1,255
     774:	ff3490e3          	bne	s1,s3,754 <createtest+0x3c>
  }
  name[0] = 'a';
     778:	00006797          	auipc	a5,0x6
     77c:	cf878793          	addi	a5,a5,-776 # 6470 <name>
     780:	06100713          	li	a4,97
     784:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     788:	00078123          	sb	zero,2(a5)
     78c:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
    name[1] = '0' + i;
     790:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     792:	06400993          	li	s3,100
    name[1] = '0' + i;
     796:	009900a3          	sb	s1,1(s2)
    unlink(name);
     79a:	854a                	mv	a0,s2
     79c:	00004097          	auipc	ra,0x4
     7a0:	a06080e7          	jalr	-1530(ra) # 41a2 <unlink>
  for(i = 0; i < N; i++){
     7a4:	2485                	addiw	s1,s1,1
     7a6:	0ff4f493          	andi	s1,s1,255
     7aa:	ff3496e3          	bne	s1,s3,796 <createtest+0x7e>
  }
  printf("many creates, followed by unlink; ok\n");
     7ae:	00004517          	auipc	a0,0x4
     7b2:	36a50513          	addi	a0,a0,874 # 4b18 <malloc+0x570>
     7b6:	00004097          	auipc	ra,0x4
     7ba:	d34080e7          	jalr	-716(ra) # 44ea <printf>
}
     7be:	70a2                	ld	ra,40(sp)
     7c0:	7402                	ld	s0,32(sp)
     7c2:	64e2                	ld	s1,24(sp)
     7c4:	6942                	ld	s2,16(sp)
     7c6:	69a2                	ld	s3,8(sp)
     7c8:	6145                	addi	sp,sp,48
     7ca:	8082                	ret

00000000000007cc <dirtest>:

void dirtest(void)
{
     7cc:	1141                	addi	sp,sp,-16
     7ce:	e406                	sd	ra,8(sp)
     7d0:	e022                	sd	s0,0(sp)
     7d2:	0800                	addi	s0,sp,16
  printf("mkdir test\n");
     7d4:	00004517          	auipc	a0,0x4
     7d8:	36c50513          	addi	a0,a0,876 # 4b40 <malloc+0x598>
     7dc:	00004097          	auipc	ra,0x4
     7e0:	d0e080e7          	jalr	-754(ra) # 44ea <printf>

  if(mkdir("dir0") < 0){
     7e4:	00004517          	auipc	a0,0x4
     7e8:	36c50513          	addi	a0,a0,876 # 4b50 <malloc+0x5a8>
     7ec:	00004097          	auipc	ra,0x4
     7f0:	9ce080e7          	jalr	-1586(ra) # 41ba <mkdir>
     7f4:	04054c63          	bltz	a0,84c <dirtest+0x80>
    printf("mkdir failed\n");
    exit(-1);
  }

  if(chdir("dir0") < 0){
     7f8:	00004517          	auipc	a0,0x4
     7fc:	35850513          	addi	a0,a0,856 # 4b50 <malloc+0x5a8>
     800:	00004097          	auipc	ra,0x4
     804:	9c2080e7          	jalr	-1598(ra) # 41c2 <chdir>
     808:	04054f63          	bltz	a0,866 <dirtest+0x9a>
    printf("chdir dir0 failed\n");
    exit(-1);
  }

  if(chdir("..") < 0){
     80c:	00004517          	auipc	a0,0x4
     810:	36450513          	addi	a0,a0,868 # 4b70 <malloc+0x5c8>
     814:	00004097          	auipc	ra,0x4
     818:	9ae080e7          	jalr	-1618(ra) # 41c2 <chdir>
     81c:	06054263          	bltz	a0,880 <dirtest+0xb4>
    printf("chdir .. failed\n");
    exit(-1);
  }

  if(unlink("dir0") < 0){
     820:	00004517          	auipc	a0,0x4
     824:	33050513          	addi	a0,a0,816 # 4b50 <malloc+0x5a8>
     828:	00004097          	auipc	ra,0x4
     82c:	97a080e7          	jalr	-1670(ra) # 41a2 <unlink>
     830:	06054563          	bltz	a0,89a <dirtest+0xce>
    printf("unlink dir0 failed\n");
    exit(-1);
  }
  printf("mkdir test ok\n");
     834:	00004517          	auipc	a0,0x4
     838:	37450513          	addi	a0,a0,884 # 4ba8 <malloc+0x600>
     83c:	00004097          	auipc	ra,0x4
     840:	cae080e7          	jalr	-850(ra) # 44ea <printf>
}
     844:	60a2                	ld	ra,8(sp)
     846:	6402                	ld	s0,0(sp)
     848:	0141                	addi	sp,sp,16
     84a:	8082                	ret
    printf("mkdir failed\n");
     84c:	00004517          	auipc	a0,0x4
     850:	e7c50513          	addi	a0,a0,-388 # 46c8 <malloc+0x120>
     854:	00004097          	auipc	ra,0x4
     858:	c96080e7          	jalr	-874(ra) # 44ea <printf>
    exit(-1);
     85c:	557d                	li	a0,-1
     85e:	00004097          	auipc	ra,0x4
     862:	8f4080e7          	jalr	-1804(ra) # 4152 <exit>
    printf("chdir dir0 failed\n");
     866:	00004517          	auipc	a0,0x4
     86a:	2f250513          	addi	a0,a0,754 # 4b58 <malloc+0x5b0>
     86e:	00004097          	auipc	ra,0x4
     872:	c7c080e7          	jalr	-900(ra) # 44ea <printf>
    exit(-1);
     876:	557d                	li	a0,-1
     878:	00004097          	auipc	ra,0x4
     87c:	8da080e7          	jalr	-1830(ra) # 4152 <exit>
    printf("chdir .. failed\n");
     880:	00004517          	auipc	a0,0x4
     884:	2f850513          	addi	a0,a0,760 # 4b78 <malloc+0x5d0>
     888:	00004097          	auipc	ra,0x4
     88c:	c62080e7          	jalr	-926(ra) # 44ea <printf>
    exit(-1);
     890:	557d                	li	a0,-1
     892:	00004097          	auipc	ra,0x4
     896:	8c0080e7          	jalr	-1856(ra) # 4152 <exit>
    printf("unlink dir0 failed\n");
     89a:	00004517          	auipc	a0,0x4
     89e:	2f650513          	addi	a0,a0,758 # 4b90 <malloc+0x5e8>
     8a2:	00004097          	auipc	ra,0x4
     8a6:	c48080e7          	jalr	-952(ra) # 44ea <printf>
    exit(-1);
     8aa:	557d                	li	a0,-1
     8ac:	00004097          	auipc	ra,0x4
     8b0:	8a6080e7          	jalr	-1882(ra) # 4152 <exit>

00000000000008b4 <exectest>:

void
exectest(void)
{
     8b4:	1141                	addi	sp,sp,-16
     8b6:	e406                	sd	ra,8(sp)
     8b8:	e022                	sd	s0,0(sp)
     8ba:	0800                	addi	s0,sp,16
  printf("exec test\n");
     8bc:	00004517          	auipc	a0,0x4
     8c0:	2fc50513          	addi	a0,a0,764 # 4bb8 <malloc+0x610>
     8c4:	00004097          	auipc	ra,0x4
     8c8:	c26080e7          	jalr	-986(ra) # 44ea <printf>
  if(exec("echo", echoargv) < 0){
     8cc:	00006597          	auipc	a1,0x6
     8d0:	b7458593          	addi	a1,a1,-1164 # 6440 <echoargv>
     8d4:	00004517          	auipc	a0,0x4
     8d8:	f5450513          	addi	a0,a0,-172 # 4828 <malloc+0x280>
     8dc:	00004097          	auipc	ra,0x4
     8e0:	8ae080e7          	jalr	-1874(ra) # 418a <exec>
     8e4:	00054663          	bltz	a0,8f0 <exectest+0x3c>
    printf("exec echo failed\n");
    exit(-1);
  }
}
     8e8:	60a2                	ld	ra,8(sp)
     8ea:	6402                	ld	s0,0(sp)
     8ec:	0141                	addi	sp,sp,16
     8ee:	8082                	ret
    printf("exec echo failed\n");
     8f0:	00004517          	auipc	a0,0x4
     8f4:	2d850513          	addi	a0,a0,728 # 4bc8 <malloc+0x620>
     8f8:	00004097          	auipc	ra,0x4
     8fc:	bf2080e7          	jalr	-1038(ra) # 44ea <printf>
    exit(-1);
     900:	557d                	li	a0,-1
     902:	00004097          	auipc	ra,0x4
     906:	850080e7          	jalr	-1968(ra) # 4152 <exit>

000000000000090a <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     90a:	715d                	addi	sp,sp,-80
     90c:	e486                	sd	ra,72(sp)
     90e:	e0a2                	sd	s0,64(sp)
     910:	fc26                	sd	s1,56(sp)
     912:	f84a                	sd	s2,48(sp)
     914:	f44e                	sd	s3,40(sp)
     916:	f052                	sd	s4,32(sp)
     918:	ec56                	sd	s5,24(sp)
     91a:	e85a                	sd	s6,16(sp)
     91c:	0880                	addi	s0,sp,80
  int fds[2], pid;
  int seq, i, n, cc, total;
  enum { N=5, SZ=1033 };
  
  if(pipe(fds) != 0){
     91e:	fb840513          	addi	a0,s0,-72
     922:	00004097          	auipc	ra,0x4
     926:	840080e7          	jalr	-1984(ra) # 4162 <pipe>
     92a:	ed25                	bnez	a0,9a2 <pipe1+0x98>
     92c:	84aa                	mv	s1,a0
    printf("pipe() failed\n");
    exit(-1);
  }
  pid = fork();
     92e:	00004097          	auipc	ra,0x4
     932:	81c080e7          	jalr	-2020(ra) # 414a <fork>
     936:	89aa                	mv	s3,a0
  seq = 0;
  if(pid == 0){
     938:	c151                	beqz	a0,9bc <pipe1+0xb2>
        printf("pipe1 oops 1\n");
        exit(-1);
      }
    }
    exit(0);
  } else if(pid > 0){
     93a:	16a05c63          	blez	a0,ab2 <pipe1+0x1a8>
    close(fds[1]);
     93e:	fbc42503          	lw	a0,-68(s0)
     942:	00004097          	auipc	ra,0x4
     946:	838080e7          	jalr	-1992(ra) # 417a <close>
    total = 0;
     94a:	89a6                	mv	s3,s1
    cc = 1;
     94c:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
     94e:	00008a17          	auipc	s4,0x8
     952:	342a0a13          	addi	s4,s4,834 # 8c90 <buf>
          return;
        }
      }
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
     956:	6a8d                	lui	s5,0x3
    while((n = read(fds[0], buf, cc)) > 0){
     958:	864a                	mv	a2,s2
     95a:	85d2                	mv	a1,s4
     95c:	fb842503          	lw	a0,-72(s0)
     960:	00004097          	auipc	ra,0x4
     964:	80a080e7          	jalr	-2038(ra) # 416a <read>
     968:	0ea05e63          	blez	a0,a64 <pipe1+0x15a>
      for(i = 0; i < n; i++){
     96c:	00008717          	auipc	a4,0x8
     970:	32470713          	addi	a4,a4,804 # 8c90 <buf>
     974:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     978:	00074683          	lbu	a3,0(a4)
     97c:	0ff4f793          	andi	a5,s1,255
     980:	2485                	addiw	s1,s1,1
     982:	0af69f63          	bne	a3,a5,a40 <pipe1+0x136>
      for(i = 0; i < n; i++){
     986:	0705                	addi	a4,a4,1
     988:	fec498e3          	bne	s1,a2,978 <pipe1+0x6e>
      total += n;
     98c:	00a989bb          	addw	s3,s3,a0
      cc = cc * 2;
     990:	0019179b          	slliw	a5,s2,0x1
     994:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
     998:	012af363          	bgeu	s5,s2,99e <pipe1+0x94>
        cc = sizeof(buf);
     99c:	8956                	mv	s2,s5
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     99e:	84b2                	mv	s1,a2
     9a0:	bf65                	j	958 <pipe1+0x4e>
    printf("pipe() failed\n");
     9a2:	00004517          	auipc	a0,0x4
     9a6:	23e50513          	addi	a0,a0,574 # 4be0 <malloc+0x638>
     9aa:	00004097          	auipc	ra,0x4
     9ae:	b40080e7          	jalr	-1216(ra) # 44ea <printf>
    exit(-1);
     9b2:	557d                	li	a0,-1
     9b4:	00003097          	auipc	ra,0x3
     9b8:	79e080e7          	jalr	1950(ra) # 4152 <exit>
    close(fds[0]);
     9bc:	fb842503          	lw	a0,-72(s0)
     9c0:	00003097          	auipc	ra,0x3
     9c4:	7ba080e7          	jalr	1978(ra) # 417a <close>
    for(n = 0; n < N; n++){
     9c8:	00008a97          	auipc	s5,0x8
     9cc:	2c8a8a93          	addi	s5,s5,712 # 8c90 <buf>
     9d0:	415004bb          	negw	s1,s5
     9d4:	0ff4f493          	andi	s1,s1,255
     9d8:	409a8913          	addi	s2,s5,1033
      if(write(fds[1], buf, SZ) != SZ){
     9dc:	8b56                	mv	s6,s5
    for(n = 0; n < N; n++){
     9de:	6a05                	lui	s4,0x1
     9e0:	42da0a13          	addi	s4,s4,1069 # 142d <fourfiles+0x10b>
{
     9e4:	87d6                	mv	a5,s5
        buf[i] = seq++;
     9e6:	0097873b          	addw	a4,a5,s1
     9ea:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
     9ee:	0785                	addi	a5,a5,1
     9f0:	fef91be3          	bne	s2,a5,9e6 <pipe1+0xdc>
     9f4:	4099899b          	addiw	s3,s3,1033
      if(write(fds[1], buf, SZ) != SZ){
     9f8:	40900613          	li	a2,1033
     9fc:	85da                	mv	a1,s6
     9fe:	fbc42503          	lw	a0,-68(s0)
     a02:	00003097          	auipc	ra,0x3
     a06:	770080e7          	jalr	1904(ra) # 4172 <write>
     a0a:	40900793          	li	a5,1033
     a0e:	00f51c63          	bne	a0,a5,a26 <pipe1+0x11c>
    for(n = 0; n < N; n++){
     a12:	24a5                	addiw	s1,s1,9
     a14:	0ff4f493          	andi	s1,s1,255
     a18:	fd4996e3          	bne	s3,s4,9e4 <pipe1+0xda>
    exit(0);
     a1c:	4501                	li	a0,0
     a1e:	00003097          	auipc	ra,0x3
     a22:	734080e7          	jalr	1844(ra) # 4152 <exit>
        printf("pipe1 oops 1\n");
     a26:	00004517          	auipc	a0,0x4
     a2a:	1ca50513          	addi	a0,a0,458 # 4bf0 <malloc+0x648>
     a2e:	00004097          	auipc	ra,0x4
     a32:	abc080e7          	jalr	-1348(ra) # 44ea <printf>
        exit(-1);
     a36:	557d                	li	a0,-1
     a38:	00003097          	auipc	ra,0x3
     a3c:	71a080e7          	jalr	1818(ra) # 4152 <exit>
          printf("pipe1 oops 2\n");
     a40:	00004517          	auipc	a0,0x4
     a44:	1c050513          	addi	a0,a0,448 # 4c00 <malloc+0x658>
     a48:	00004097          	auipc	ra,0x4
     a4c:	aa2080e7          	jalr	-1374(ra) # 44ea <printf>
  } else {
    printf("fork() failed\n");
    exit(-1);
  }
  printf("pipe1 ok\n");
}
     a50:	60a6                	ld	ra,72(sp)
     a52:	6406                	ld	s0,64(sp)
     a54:	74e2                	ld	s1,56(sp)
     a56:	7942                	ld	s2,48(sp)
     a58:	79a2                	ld	s3,40(sp)
     a5a:	7a02                	ld	s4,32(sp)
     a5c:	6ae2                	ld	s5,24(sp)
     a5e:	6b42                	ld	s6,16(sp)
     a60:	6161                	addi	sp,sp,80
     a62:	8082                	ret
    if(total != N * SZ){
     a64:	6785                	lui	a5,0x1
     a66:	42d78793          	addi	a5,a5,1069 # 142d <fourfiles+0x10b>
     a6a:	02f99663          	bne	s3,a5,a96 <pipe1+0x18c>
    close(fds[0]);
     a6e:	fb842503          	lw	a0,-72(s0)
     a72:	00003097          	auipc	ra,0x3
     a76:	708080e7          	jalr	1800(ra) # 417a <close>
    wait(0);
     a7a:	4501                	li	a0,0
     a7c:	00003097          	auipc	ra,0x3
     a80:	6de080e7          	jalr	1758(ra) # 415a <wait>
  printf("pipe1 ok\n");
     a84:	00004517          	auipc	a0,0x4
     a88:	1a450513          	addi	a0,a0,420 # 4c28 <malloc+0x680>
     a8c:	00004097          	auipc	ra,0x4
     a90:	a5e080e7          	jalr	-1442(ra) # 44ea <printf>
     a94:	bf75                	j	a50 <pipe1+0x146>
      printf("pipe1 oops 3 total %d\n", total);
     a96:	85ce                	mv	a1,s3
     a98:	00004517          	auipc	a0,0x4
     a9c:	17850513          	addi	a0,a0,376 # 4c10 <malloc+0x668>
     aa0:	00004097          	auipc	ra,0x4
     aa4:	a4a080e7          	jalr	-1462(ra) # 44ea <printf>
      exit(-1);
     aa8:	557d                	li	a0,-1
     aaa:	00003097          	auipc	ra,0x3
     aae:	6a8080e7          	jalr	1704(ra) # 4152 <exit>
    printf("fork() failed\n");
     ab2:	00004517          	auipc	a0,0x4
     ab6:	18650513          	addi	a0,a0,390 # 4c38 <malloc+0x690>
     aba:	00004097          	auipc	ra,0x4
     abe:	a30080e7          	jalr	-1488(ra) # 44ea <printf>
    exit(-1);
     ac2:	557d                	li	a0,-1
     ac4:	00003097          	auipc	ra,0x3
     ac8:	68e080e7          	jalr	1678(ra) # 4152 <exit>

0000000000000acc <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     acc:	7139                	addi	sp,sp,-64
     ace:	fc06                	sd	ra,56(sp)
     ad0:	f822                	sd	s0,48(sp)
     ad2:	f426                	sd	s1,40(sp)
     ad4:	f04a                	sd	s2,32(sp)
     ad6:	ec4e                	sd	s3,24(sp)
     ad8:	0080                	addi	s0,sp,64
  int pid1, pid2, pid3;
  int pfds[2];

  printf("preempt: ");
     ada:	00004517          	auipc	a0,0x4
     ade:	16e50513          	addi	a0,a0,366 # 4c48 <malloc+0x6a0>
     ae2:	00004097          	auipc	ra,0x4
     ae6:	a08080e7          	jalr	-1528(ra) # 44ea <printf>
  pid1 = fork();
     aea:	00003097          	auipc	ra,0x3
     aee:	660080e7          	jalr	1632(ra) # 414a <fork>
  if(pid1 < 0) {
     af2:	00054563          	bltz	a0,afc <preempt+0x30>
     af6:	89aa                	mv	s3,a0
    printf("fork failed");
    exit(-1);
  }
  if(pid1 == 0)
     af8:	ed19                	bnez	a0,b16 <preempt+0x4a>
    for(;;)
     afa:	a001                	j	afa <preempt+0x2e>
    printf("fork failed");
     afc:	00004517          	auipc	a0,0x4
     b00:	15c50513          	addi	a0,a0,348 # 4c58 <malloc+0x6b0>
     b04:	00004097          	auipc	ra,0x4
     b08:	9e6080e7          	jalr	-1562(ra) # 44ea <printf>
    exit(-1);
     b0c:	557d                	li	a0,-1
     b0e:	00003097          	auipc	ra,0x3
     b12:	644080e7          	jalr	1604(ra) # 4152 <exit>
      ;

  pid2 = fork();
     b16:	00003097          	auipc	ra,0x3
     b1a:	634080e7          	jalr	1588(ra) # 414a <fork>
     b1e:	892a                	mv	s2,a0
  if(pid2 < 0) {
     b20:	00054463          	bltz	a0,b28 <preempt+0x5c>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid2 == 0)
     b24:	ed19                	bnez	a0,b42 <preempt+0x76>
    for(;;)
     b26:	a001                	j	b26 <preempt+0x5a>
    printf("fork failed\n");
     b28:	00004517          	auipc	a0,0x4
     b2c:	c3050513          	addi	a0,a0,-976 # 4758 <malloc+0x1b0>
     b30:	00004097          	auipc	ra,0x4
     b34:	9ba080e7          	jalr	-1606(ra) # 44ea <printf>
    exit(-1);
     b38:	557d                	li	a0,-1
     b3a:	00003097          	auipc	ra,0x3
     b3e:	618080e7          	jalr	1560(ra) # 4152 <exit>
      ;

  pipe(pfds);
     b42:	fc840513          	addi	a0,s0,-56
     b46:	00003097          	auipc	ra,0x3
     b4a:	61c080e7          	jalr	1564(ra) # 4162 <pipe>
  pid3 = fork();
     b4e:	00003097          	auipc	ra,0x3
     b52:	5fc080e7          	jalr	1532(ra) # 414a <fork>
     b56:	84aa                	mv	s1,a0
  if(pid3 < 0) {
     b58:	02054e63          	bltz	a0,b94 <preempt+0xc8>
     printf("fork failed\n");
     exit(-1);
  }
  if(pid3 == 0){
     b5c:	e135                	bnez	a0,bc0 <preempt+0xf4>
    close(pfds[0]);
     b5e:	fc842503          	lw	a0,-56(s0)
     b62:	00003097          	auipc	ra,0x3
     b66:	618080e7          	jalr	1560(ra) # 417a <close>
    if(write(pfds[1], "x", 1) != 1)
     b6a:	4605                	li	a2,1
     b6c:	00004597          	auipc	a1,0x4
     b70:	0fc58593          	addi	a1,a1,252 # 4c68 <malloc+0x6c0>
     b74:	fcc42503          	lw	a0,-52(s0)
     b78:	00003097          	auipc	ra,0x3
     b7c:	5fa080e7          	jalr	1530(ra) # 4172 <write>
     b80:	4785                	li	a5,1
     b82:	02f51663          	bne	a0,a5,bae <preempt+0xe2>
      printf("preempt write error");
    close(pfds[1]);
     b86:	fcc42503          	lw	a0,-52(s0)
     b8a:	00003097          	auipc	ra,0x3
     b8e:	5f0080e7          	jalr	1520(ra) # 417a <close>
    for(;;)
     b92:	a001                	j	b92 <preempt+0xc6>
     printf("fork failed\n");
     b94:	00004517          	auipc	a0,0x4
     b98:	bc450513          	addi	a0,a0,-1084 # 4758 <malloc+0x1b0>
     b9c:	00004097          	auipc	ra,0x4
     ba0:	94e080e7          	jalr	-1714(ra) # 44ea <printf>
     exit(-1);
     ba4:	557d                	li	a0,-1
     ba6:	00003097          	auipc	ra,0x3
     baa:	5ac080e7          	jalr	1452(ra) # 4152 <exit>
      printf("preempt write error");
     bae:	00004517          	auipc	a0,0x4
     bb2:	0c250513          	addi	a0,a0,194 # 4c70 <malloc+0x6c8>
     bb6:	00004097          	auipc	ra,0x4
     bba:	934080e7          	jalr	-1740(ra) # 44ea <printf>
     bbe:	b7e1                	j	b86 <preempt+0xba>
      ;
  }

  close(pfds[1]);
     bc0:	fcc42503          	lw	a0,-52(s0)
     bc4:	00003097          	auipc	ra,0x3
     bc8:	5b6080e7          	jalr	1462(ra) # 417a <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     bcc:	660d                	lui	a2,0x3
     bce:	00008597          	auipc	a1,0x8
     bd2:	0c258593          	addi	a1,a1,194 # 8c90 <buf>
     bd6:	fc842503          	lw	a0,-56(s0)
     bda:	00003097          	auipc	ra,0x3
     bde:	590080e7          	jalr	1424(ra) # 416a <read>
     be2:	4785                	li	a5,1
     be4:	02f50163          	beq	a0,a5,c06 <preempt+0x13a>
    printf("preempt read error");
     be8:	00004517          	auipc	a0,0x4
     bec:	0a050513          	addi	a0,a0,160 # 4c88 <malloc+0x6e0>
     bf0:	00004097          	auipc	ra,0x4
     bf4:	8fa080e7          	jalr	-1798(ra) # 44ea <printf>
  printf("wait... ");
  wait(0);
  wait(0);
  wait(0);
  printf("preempt ok\n");
}
     bf8:	70e2                	ld	ra,56(sp)
     bfa:	7442                	ld	s0,48(sp)
     bfc:	74a2                	ld	s1,40(sp)
     bfe:	7902                	ld	s2,32(sp)
     c00:	69e2                	ld	s3,24(sp)
     c02:	6121                	addi	sp,sp,64
     c04:	8082                	ret
  close(pfds[0]);
     c06:	fc842503          	lw	a0,-56(s0)
     c0a:	00003097          	auipc	ra,0x3
     c0e:	570080e7          	jalr	1392(ra) # 417a <close>
  printf("kill... ");
     c12:	00004517          	auipc	a0,0x4
     c16:	08e50513          	addi	a0,a0,142 # 4ca0 <malloc+0x6f8>
     c1a:	00004097          	auipc	ra,0x4
     c1e:	8d0080e7          	jalr	-1840(ra) # 44ea <printf>
  kill(pid1);
     c22:	854e                	mv	a0,s3
     c24:	00003097          	auipc	ra,0x3
     c28:	55e080e7          	jalr	1374(ra) # 4182 <kill>
  kill(pid2);
     c2c:	854a                	mv	a0,s2
     c2e:	00003097          	auipc	ra,0x3
     c32:	554080e7          	jalr	1364(ra) # 4182 <kill>
  kill(pid3);
     c36:	8526                	mv	a0,s1
     c38:	00003097          	auipc	ra,0x3
     c3c:	54a080e7          	jalr	1354(ra) # 4182 <kill>
  printf("wait... ");
     c40:	00004517          	auipc	a0,0x4
     c44:	07050513          	addi	a0,a0,112 # 4cb0 <malloc+0x708>
     c48:	00004097          	auipc	ra,0x4
     c4c:	8a2080e7          	jalr	-1886(ra) # 44ea <printf>
  wait(0);
     c50:	4501                	li	a0,0
     c52:	00003097          	auipc	ra,0x3
     c56:	508080e7          	jalr	1288(ra) # 415a <wait>
  wait(0);
     c5a:	4501                	li	a0,0
     c5c:	00003097          	auipc	ra,0x3
     c60:	4fe080e7          	jalr	1278(ra) # 415a <wait>
  wait(0);
     c64:	4501                	li	a0,0
     c66:	00003097          	auipc	ra,0x3
     c6a:	4f4080e7          	jalr	1268(ra) # 415a <wait>
  printf("preempt ok\n");
     c6e:	00004517          	auipc	a0,0x4
     c72:	05250513          	addi	a0,a0,82 # 4cc0 <malloc+0x718>
     c76:	00004097          	auipc	ra,0x4
     c7a:	874080e7          	jalr	-1932(ra) # 44ea <printf>
     c7e:	bfad                	j	bf8 <preempt+0x12c>

0000000000000c80 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     c80:	7139                	addi	sp,sp,-64
     c82:	fc06                	sd	ra,56(sp)
     c84:	f822                	sd	s0,48(sp)
     c86:	f426                	sd	s1,40(sp)
     c88:	f04a                	sd	s2,32(sp)
     c8a:	ec4e                	sd	s3,24(sp)
     c8c:	0080                	addi	s0,sp,64
  int i, pid;

  printf("exitwait test\n");
     c8e:	00004517          	auipc	a0,0x4
     c92:	04250513          	addi	a0,a0,66 # 4cd0 <malloc+0x728>
     c96:	00004097          	auipc	ra,0x4
     c9a:	854080e7          	jalr	-1964(ra) # 44ea <printf>

  for(i = 0; i < 100; i++){
     c9e:	4901                	li	s2,0
     ca0:	06400993          	li	s3,100
    pid = fork();
     ca4:	00003097          	auipc	ra,0x3
     ca8:	4a6080e7          	jalr	1190(ra) # 414a <fork>
     cac:	84aa                	mv	s1,a0
    if(pid < 0){
     cae:	04054163          	bltz	a0,cf0 <exitwait+0x70>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid){
     cb2:	c551                	beqz	a0,d3e <exitwait+0xbe>
      int xstate;
      if(wait(&xstate) != pid){
     cb4:	fcc40513          	addi	a0,s0,-52
     cb8:	00003097          	auipc	ra,0x3
     cbc:	4a2080e7          	jalr	1186(ra) # 415a <wait>
     cc0:	04951563          	bne	a0,s1,d0a <exitwait+0x8a>
        printf("wait wrong pid\n");
        exit(-1);
      }
      if(i != xstate) {
     cc4:	fcc42783          	lw	a5,-52(s0)
     cc8:	05279e63          	bne	a5,s2,d24 <exitwait+0xa4>
  for(i = 0; i < 100; i++){
     ccc:	2905                	addiw	s2,s2,1
     cce:	fd391be3          	bne	s2,s3,ca4 <exitwait+0x24>
      }
    } else {
      exit(i);
    }
  }
  printf("exitwait ok\n");
     cd2:	00004517          	auipc	a0,0x4
     cd6:	03650513          	addi	a0,a0,54 # 4d08 <malloc+0x760>
     cda:	00004097          	auipc	ra,0x4
     cde:	810080e7          	jalr	-2032(ra) # 44ea <printf>
}
     ce2:	70e2                	ld	ra,56(sp)
     ce4:	7442                	ld	s0,48(sp)
     ce6:	74a2                	ld	s1,40(sp)
     ce8:	7902                	ld	s2,32(sp)
     cea:	69e2                	ld	s3,24(sp)
     cec:	6121                	addi	sp,sp,64
     cee:	8082                	ret
      printf("fork failed\n");
     cf0:	00004517          	auipc	a0,0x4
     cf4:	a6850513          	addi	a0,a0,-1432 # 4758 <malloc+0x1b0>
     cf8:	00003097          	auipc	ra,0x3
     cfc:	7f2080e7          	jalr	2034(ra) # 44ea <printf>
      exit(-1);
     d00:	557d                	li	a0,-1
     d02:	00003097          	auipc	ra,0x3
     d06:	450080e7          	jalr	1104(ra) # 4152 <exit>
        printf("wait wrong pid\n");
     d0a:	00004517          	auipc	a0,0x4
     d0e:	fd650513          	addi	a0,a0,-42 # 4ce0 <malloc+0x738>
     d12:	00003097          	auipc	ra,0x3
     d16:	7d8080e7          	jalr	2008(ra) # 44ea <printf>
        exit(-1);
     d1a:	557d                	li	a0,-1
     d1c:	00003097          	auipc	ra,0x3
     d20:	436080e7          	jalr	1078(ra) # 4152 <exit>
        printf("wait wrong exit status\n");
     d24:	00004517          	auipc	a0,0x4
     d28:	fcc50513          	addi	a0,a0,-52 # 4cf0 <malloc+0x748>
     d2c:	00003097          	auipc	ra,0x3
     d30:	7be080e7          	jalr	1982(ra) # 44ea <printf>
        exit(-1);
     d34:	557d                	li	a0,-1
     d36:	00003097          	auipc	ra,0x3
     d3a:	41c080e7          	jalr	1052(ra) # 4152 <exit>
      exit(i);
     d3e:	854a                	mv	a0,s2
     d40:	00003097          	auipc	ra,0x3
     d44:	412080e7          	jalr	1042(ra) # 4152 <exit>

0000000000000d48 <reparent>:
// try to find races in the reparenting
// code that handles a parent exiting
// when it still has live children.
void
reparent(void)
{
     d48:	7179                	addi	sp,sp,-48
     d4a:	f406                	sd	ra,40(sp)
     d4c:	f022                	sd	s0,32(sp)
     d4e:	ec26                	sd	s1,24(sp)
     d50:	e84a                	sd	s2,16(sp)
     d52:	e44e                	sd	s3,8(sp)
     d54:	1800                	addi	s0,sp,48
  int master_pid = getpid();
     d56:	00003097          	auipc	ra,0x3
     d5a:	47c080e7          	jalr	1148(ra) # 41d2 <getpid>
     d5e:	89aa                	mv	s3,a0
  
  printf("reparent test\n");
     d60:	00004517          	auipc	a0,0x4
     d64:	fb850513          	addi	a0,a0,-72 # 4d18 <malloc+0x770>
     d68:	00003097          	auipc	ra,0x3
     d6c:	782080e7          	jalr	1922(ra) # 44ea <printf>
     d70:	0c800913          	li	s2,200

  for(int i = 0; i < 200; i++){
    int pid = fork();
     d74:	00003097          	auipc	ra,0x3
     d78:	3d6080e7          	jalr	982(ra) # 414a <fork>
     d7c:	84aa                	mv	s1,a0
    if(pid < 0){
     d7e:	02054c63          	bltz	a0,db6 <reparent+0x6e>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid){
     d82:	c525                	beqz	a0,dea <reparent+0xa2>
      if(wait(0) != pid){
     d84:	4501                	li	a0,0
     d86:	00003097          	auipc	ra,0x3
     d8a:	3d4080e7          	jalr	980(ra) # 415a <wait>
     d8e:	04951163          	bne	a0,s1,dd0 <reparent+0x88>
  for(int i = 0; i < 200; i++){
     d92:	397d                	addiw	s2,s2,-1
     d94:	fe0910e3          	bnez	s2,d74 <reparent+0x2c>
      } else {
        exit(0);
      }
    }
  }
  printf("reparent ok\n");
     d98:	00004517          	auipc	a0,0x4
     d9c:	f9050513          	addi	a0,a0,-112 # 4d28 <malloc+0x780>
     da0:	00003097          	auipc	ra,0x3
     da4:	74a080e7          	jalr	1866(ra) # 44ea <printf>
}
     da8:	70a2                	ld	ra,40(sp)
     daa:	7402                	ld	s0,32(sp)
     dac:	64e2                	ld	s1,24(sp)
     dae:	6942                	ld	s2,16(sp)
     db0:	69a2                	ld	s3,8(sp)
     db2:	6145                	addi	sp,sp,48
     db4:	8082                	ret
      printf("fork failed\n");
     db6:	00004517          	auipc	a0,0x4
     dba:	9a250513          	addi	a0,a0,-1630 # 4758 <malloc+0x1b0>
     dbe:	00003097          	auipc	ra,0x3
     dc2:	72c080e7          	jalr	1836(ra) # 44ea <printf>
      exit(-1);
     dc6:	557d                	li	a0,-1
     dc8:	00003097          	auipc	ra,0x3
     dcc:	38a080e7          	jalr	906(ra) # 4152 <exit>
        printf("wait wrong pid\n");
     dd0:	00004517          	auipc	a0,0x4
     dd4:	f1050513          	addi	a0,a0,-240 # 4ce0 <malloc+0x738>
     dd8:	00003097          	auipc	ra,0x3
     ddc:	712080e7          	jalr	1810(ra) # 44ea <printf>
        exit(-1);
     de0:	557d                	li	a0,-1
     de2:	00003097          	auipc	ra,0x3
     de6:	370080e7          	jalr	880(ra) # 4152 <exit>
      int pid2 = fork();
     dea:	00003097          	auipc	ra,0x3
     dee:	360080e7          	jalr	864(ra) # 414a <fork>
      if(pid2 < 0){
     df2:	00054763          	bltz	a0,e00 <reparent+0xb8>
      if(pid2 == 0){
     df6:	e51d                	bnez	a0,e24 <reparent+0xdc>
        exit(0);
     df8:	00003097          	auipc	ra,0x3
     dfc:	35a080e7          	jalr	858(ra) # 4152 <exit>
        printf("fork failed\n");
     e00:	00004517          	auipc	a0,0x4
     e04:	95850513          	addi	a0,a0,-1704 # 4758 <malloc+0x1b0>
     e08:	00003097          	auipc	ra,0x3
     e0c:	6e2080e7          	jalr	1762(ra) # 44ea <printf>
        kill(master_pid);
     e10:	854e                	mv	a0,s3
     e12:	00003097          	auipc	ra,0x3
     e16:	370080e7          	jalr	880(ra) # 4182 <kill>
        exit(-1);
     e1a:	557d                	li	a0,-1
     e1c:	00003097          	auipc	ra,0x3
     e20:	336080e7          	jalr	822(ra) # 4152 <exit>
        exit(0);
     e24:	4501                	li	a0,0
     e26:	00003097          	auipc	ra,0x3
     e2a:	32c080e7          	jalr	812(ra) # 4152 <exit>

0000000000000e2e <twochildren>:

// what if two children exit() at the same time?
void
twochildren(void)
{
     e2e:	1101                	addi	sp,sp,-32
     e30:	ec06                	sd	ra,24(sp)
     e32:	e822                	sd	s0,16(sp)
     e34:	e426                	sd	s1,8(sp)
     e36:	1000                	addi	s0,sp,32
  printf("twochildren test\n");
     e38:	00004517          	auipc	a0,0x4
     e3c:	f0050513          	addi	a0,a0,-256 # 4d38 <malloc+0x790>
     e40:	00003097          	auipc	ra,0x3
     e44:	6aa080e7          	jalr	1706(ra) # 44ea <printf>
     e48:	3e800493          	li	s1,1000

  for(int i = 0; i < 1000; i++){
    int pid1 = fork();
     e4c:	00003097          	auipc	ra,0x3
     e50:	2fe080e7          	jalr	766(ra) # 414a <fork>
    if(pid1 < 0){
     e54:	04054363          	bltz	a0,e9a <twochildren+0x6c>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid1 == 0){
     e58:	cd31                	beqz	a0,eb4 <twochildren+0x86>
      exit(0);
    } else {
      int pid2 = fork();
     e5a:	00003097          	auipc	ra,0x3
     e5e:	2f0080e7          	jalr	752(ra) # 414a <fork>
      if(pid2 < 0){
     e62:	04054d63          	bltz	a0,ebc <twochildren+0x8e>
        printf("fork failed\n");
        exit(-1);
      }
      if(pid2 == 0){
     e66:	c925                	beqz	a0,ed6 <twochildren+0xa8>
        exit(0);
      } else {
        wait(0);
     e68:	4501                	li	a0,0
     e6a:	00003097          	auipc	ra,0x3
     e6e:	2f0080e7          	jalr	752(ra) # 415a <wait>
        wait(0);
     e72:	4501                	li	a0,0
     e74:	00003097          	auipc	ra,0x3
     e78:	2e6080e7          	jalr	742(ra) # 415a <wait>
  for(int i = 0; i < 1000; i++){
     e7c:	34fd                	addiw	s1,s1,-1
     e7e:	f4f9                	bnez	s1,e4c <twochildren+0x1e>
      }
    }
  }
  printf("twochildren ok\n");
     e80:	00004517          	auipc	a0,0x4
     e84:	ed050513          	addi	a0,a0,-304 # 4d50 <malloc+0x7a8>
     e88:	00003097          	auipc	ra,0x3
     e8c:	662080e7          	jalr	1634(ra) # 44ea <printf>
}
     e90:	60e2                	ld	ra,24(sp)
     e92:	6442                	ld	s0,16(sp)
     e94:	64a2                	ld	s1,8(sp)
     e96:	6105                	addi	sp,sp,32
     e98:	8082                	ret
      printf("fork failed\n");
     e9a:	00004517          	auipc	a0,0x4
     e9e:	8be50513          	addi	a0,a0,-1858 # 4758 <malloc+0x1b0>
     ea2:	00003097          	auipc	ra,0x3
     ea6:	648080e7          	jalr	1608(ra) # 44ea <printf>
      exit(-1);
     eaa:	557d                	li	a0,-1
     eac:	00003097          	auipc	ra,0x3
     eb0:	2a6080e7          	jalr	678(ra) # 4152 <exit>
      exit(0);
     eb4:	00003097          	auipc	ra,0x3
     eb8:	29e080e7          	jalr	670(ra) # 4152 <exit>
        printf("fork failed\n");
     ebc:	00004517          	auipc	a0,0x4
     ec0:	89c50513          	addi	a0,a0,-1892 # 4758 <malloc+0x1b0>
     ec4:	00003097          	auipc	ra,0x3
     ec8:	626080e7          	jalr	1574(ra) # 44ea <printf>
        exit(-1);
     ecc:	557d                	li	a0,-1
     ece:	00003097          	auipc	ra,0x3
     ed2:	284080e7          	jalr	644(ra) # 4152 <exit>
        exit(0);
     ed6:	00003097          	auipc	ra,0x3
     eda:	27c080e7          	jalr	636(ra) # 4152 <exit>

0000000000000ede <forkfork>:

// concurrent forks to try to expose locking bugs.
void
forkfork(void)
{
     ede:	1101                	addi	sp,sp,-32
     ee0:	ec06                	sd	ra,24(sp)
     ee2:	e822                	sd	s0,16(sp)
     ee4:	e426                	sd	s1,8(sp)
     ee6:	e04a                	sd	s2,0(sp)
     ee8:	1000                	addi	s0,sp,32
  int ppid = getpid();
     eea:	00003097          	auipc	ra,0x3
     eee:	2e8080e7          	jalr	744(ra) # 41d2 <getpid>
     ef2:	892a                	mv	s2,a0
  enum { N=2 };
  
  printf("forkfork test\n");
     ef4:	00004517          	auipc	a0,0x4
     ef8:	e6c50513          	addi	a0,a0,-404 # 4d60 <malloc+0x7b8>
     efc:	00003097          	auipc	ra,0x3
     f00:	5ee080e7          	jalr	1518(ra) # 44ea <printf>

  for(int i = 0; i < N; i++){
    int pid = fork();
     f04:	00003097          	auipc	ra,0x3
     f08:	246080e7          	jalr	582(ra) # 414a <fork>
    if(pid < 0){
     f0c:	04054263          	bltz	a0,f50 <forkfork+0x72>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
     f10:	cd29                	beqz	a0,f6a <forkfork+0x8c>
    int pid = fork();
     f12:	00003097          	auipc	ra,0x3
     f16:	238080e7          	jalr	568(ra) # 414a <fork>
    if(pid < 0){
     f1a:	02054b63          	bltz	a0,f50 <forkfork+0x72>
    if(pid == 0){
     f1e:	c531                	beqz	a0,f6a <forkfork+0x8c>
      exit(0);
    }
  }

  for(int i = 0; i < N; i++){
    wait(0);
     f20:	4501                	li	a0,0
     f22:	00003097          	auipc	ra,0x3
     f26:	238080e7          	jalr	568(ra) # 415a <wait>
     f2a:	4501                	li	a0,0
     f2c:	00003097          	auipc	ra,0x3
     f30:	22e080e7          	jalr	558(ra) # 415a <wait>
  }

  printf("forkfork ok\n");
     f34:	00004517          	auipc	a0,0x4
     f38:	e3c50513          	addi	a0,a0,-452 # 4d70 <malloc+0x7c8>
     f3c:	00003097          	auipc	ra,0x3
     f40:	5ae080e7          	jalr	1454(ra) # 44ea <printf>
}
     f44:	60e2                	ld	ra,24(sp)
     f46:	6442                	ld	s0,16(sp)
     f48:	64a2                	ld	s1,8(sp)
     f4a:	6902                	ld	s2,0(sp)
     f4c:	6105                	addi	sp,sp,32
     f4e:	8082                	ret
      printf("fork failed");
     f50:	00004517          	auipc	a0,0x4
     f54:	d0850513          	addi	a0,a0,-760 # 4c58 <malloc+0x6b0>
     f58:	00003097          	auipc	ra,0x3
     f5c:	592080e7          	jalr	1426(ra) # 44ea <printf>
      exit(-1);
     f60:	557d                	li	a0,-1
     f62:	00003097          	auipc	ra,0x3
     f66:	1f0080e7          	jalr	496(ra) # 4152 <exit>
{
     f6a:	0c800493          	li	s1,200
        int pid1 = fork();
     f6e:	00003097          	auipc	ra,0x3
     f72:	1dc080e7          	jalr	476(ra) # 414a <fork>
        if(pid1 < 0){
     f76:	00054f63          	bltz	a0,f94 <forkfork+0xb6>
        if(pid1 == 0){
     f7a:	cd1d                	beqz	a0,fb8 <forkfork+0xda>
        wait(0);
     f7c:	4501                	li	a0,0
     f7e:	00003097          	auipc	ra,0x3
     f82:	1dc080e7          	jalr	476(ra) # 415a <wait>
      for(int j = 0; j < 200; j++){
     f86:	34fd                	addiw	s1,s1,-1
     f88:	f0fd                	bnez	s1,f6e <forkfork+0x90>
      exit(0);
     f8a:	4501                	li	a0,0
     f8c:	00003097          	auipc	ra,0x3
     f90:	1c6080e7          	jalr	454(ra) # 4152 <exit>
          printf("fork failed\n");
     f94:	00003517          	auipc	a0,0x3
     f98:	7c450513          	addi	a0,a0,1988 # 4758 <malloc+0x1b0>
     f9c:	00003097          	auipc	ra,0x3
     fa0:	54e080e7          	jalr	1358(ra) # 44ea <printf>
          kill(ppid);
     fa4:	854a                	mv	a0,s2
     fa6:	00003097          	auipc	ra,0x3
     faa:	1dc080e7          	jalr	476(ra) # 4182 <kill>
          exit(-1);
     fae:	557d                	li	a0,-1
     fb0:	00003097          	auipc	ra,0x3
     fb4:	1a2080e7          	jalr	418(ra) # 4152 <exit>
          exit(0);
     fb8:	00003097          	auipc	ra,0x3
     fbc:	19a080e7          	jalr	410(ra) # 4152 <exit>

0000000000000fc0 <forkforkfork>:

void
forkforkfork(void)
{
     fc0:	1101                	addi	sp,sp,-32
     fc2:	ec06                	sd	ra,24(sp)
     fc4:	e822                	sd	s0,16(sp)
     fc6:	e426                	sd	s1,8(sp)
     fc8:	1000                	addi	s0,sp,32
  printf("forkforkfork test\n");
     fca:	00004517          	auipc	a0,0x4
     fce:	db650513          	addi	a0,a0,-586 # 4d80 <malloc+0x7d8>
     fd2:	00003097          	auipc	ra,0x3
     fd6:	518080e7          	jalr	1304(ra) # 44ea <printf>

  unlink("stopforking");
     fda:	00004517          	auipc	a0,0x4
     fde:	dbe50513          	addi	a0,a0,-578 # 4d98 <malloc+0x7f0>
     fe2:	00003097          	auipc	ra,0x3
     fe6:	1c0080e7          	jalr	448(ra) # 41a2 <unlink>

  int pid = fork();
     fea:	00003097          	auipc	ra,0x3
     fee:	160080e7          	jalr	352(ra) # 414a <fork>
  if(pid < 0){
     ff2:	04054d63          	bltz	a0,104c <forkforkfork+0x8c>
    printf("fork failed");
    exit(-1);
  }
  if(pid == 0){
     ff6:	c925                	beqz	a0,1066 <forkforkfork+0xa6>
    }

    exit(0);
  }

  sleep(20); // two seconds
     ff8:	4551                	li	a0,20
     ffa:	00003097          	auipc	ra,0x3
     ffe:	1e8080e7          	jalr	488(ra) # 41e2 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    1002:	20200593          	li	a1,514
    1006:	00004517          	auipc	a0,0x4
    100a:	d9250513          	addi	a0,a0,-622 # 4d98 <malloc+0x7f0>
    100e:	00003097          	auipc	ra,0x3
    1012:	184080e7          	jalr	388(ra) # 4192 <open>
    1016:	00003097          	auipc	ra,0x3
    101a:	164080e7          	jalr	356(ra) # 417a <close>
  wait(0);
    101e:	4501                	li	a0,0
    1020:	00003097          	auipc	ra,0x3
    1024:	13a080e7          	jalr	314(ra) # 415a <wait>
  sleep(10); // one second
    1028:	4529                	li	a0,10
    102a:	00003097          	auipc	ra,0x3
    102e:	1b8080e7          	jalr	440(ra) # 41e2 <sleep>

  printf("forkforkfork ok\n");
    1032:	00004517          	auipc	a0,0x4
    1036:	d7650513          	addi	a0,a0,-650 # 4da8 <malloc+0x800>
    103a:	00003097          	auipc	ra,0x3
    103e:	4b0080e7          	jalr	1200(ra) # 44ea <printf>
}
    1042:	60e2                	ld	ra,24(sp)
    1044:	6442                	ld	s0,16(sp)
    1046:	64a2                	ld	s1,8(sp)
    1048:	6105                	addi	sp,sp,32
    104a:	8082                	ret
    printf("fork failed");
    104c:	00004517          	auipc	a0,0x4
    1050:	c0c50513          	addi	a0,a0,-1012 # 4c58 <malloc+0x6b0>
    1054:	00003097          	auipc	ra,0x3
    1058:	496080e7          	jalr	1174(ra) # 44ea <printf>
    exit(-1);
    105c:	557d                	li	a0,-1
    105e:	00003097          	auipc	ra,0x3
    1062:	0f4080e7          	jalr	244(ra) # 4152 <exit>
      int fd = open("stopforking", 0);
    1066:	00004497          	auipc	s1,0x4
    106a:	d3248493          	addi	s1,s1,-718 # 4d98 <malloc+0x7f0>
    106e:	4581                	li	a1,0
    1070:	8526                	mv	a0,s1
    1072:	00003097          	auipc	ra,0x3
    1076:	120080e7          	jalr	288(ra) # 4192 <open>
      if(fd >= 0){
    107a:	02055463          	bgez	a0,10a2 <forkforkfork+0xe2>
      if(fork() < 0){
    107e:	00003097          	auipc	ra,0x3
    1082:	0cc080e7          	jalr	204(ra) # 414a <fork>
    1086:	fe0554e3          	bgez	a0,106e <forkforkfork+0xae>
        close(open("stopforking", O_CREATE|O_RDWR));
    108a:	20200593          	li	a1,514
    108e:	8526                	mv	a0,s1
    1090:	00003097          	auipc	ra,0x3
    1094:	102080e7          	jalr	258(ra) # 4192 <open>
    1098:	00003097          	auipc	ra,0x3
    109c:	0e2080e7          	jalr	226(ra) # 417a <close>
    10a0:	b7f9                	j	106e <forkforkfork+0xae>
        exit(0);
    10a2:	4501                	li	a0,0
    10a4:	00003097          	auipc	ra,0x3
    10a8:	0ae080e7          	jalr	174(ra) # 4152 <exit>

00000000000010ac <mem>:

void
mem(void)
{
    10ac:	7179                	addi	sp,sp,-48
    10ae:	f406                	sd	ra,40(sp)
    10b0:	f022                	sd	s0,32(sp)
    10b2:	ec26                	sd	s1,24(sp)
    10b4:	e84a                	sd	s2,16(sp)
    10b6:	e44e                	sd	s3,8(sp)
    10b8:	1800                	addi	s0,sp,48
  void *m1, *m2;
  int pid, ppid;

  printf("mem test\n");
    10ba:	00004517          	auipc	a0,0x4
    10be:	d0650513          	addi	a0,a0,-762 # 4dc0 <malloc+0x818>
    10c2:	00003097          	auipc	ra,0x3
    10c6:	428080e7          	jalr	1064(ra) # 44ea <printf>
  ppid = getpid();
    10ca:	00003097          	auipc	ra,0x3
    10ce:	108080e7          	jalr	264(ra) # 41d2 <getpid>
    10d2:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    10d4:	00003097          	auipc	ra,0x3
    10d8:	076080e7          	jalr	118(ra) # 414a <fork>
    m1 = 0;
    10dc:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    10de:	6909                	lui	s2,0x2
    10e0:	71190913          	addi	s2,s2,1809 # 2711 <subdir+0x5a7>
  if((pid = fork()) == 0){
    10e4:	e93d                	bnez	a0,115a <mem+0xae>
    while((m2 = malloc(10001)) != 0){
    10e6:	854a                	mv	a0,s2
    10e8:	00003097          	auipc	ra,0x3
    10ec:	4c0080e7          	jalr	1216(ra) # 45a8 <malloc>
    10f0:	c501                	beqz	a0,10f8 <mem+0x4c>
      *(char**)m2 = m1;
    10f2:	e104                	sd	s1,0(a0)
      m1 = m2;
    10f4:	84aa                	mv	s1,a0
    10f6:	bfc5                	j	10e6 <mem+0x3a>
    }
    while(m1){
    10f8:	c881                	beqz	s1,1108 <mem+0x5c>
      m2 = *(char**)m1;
    10fa:	8526                	mv	a0,s1
    10fc:	6084                	ld	s1,0(s1)
      free(m1);
    10fe:	00003097          	auipc	ra,0x3
    1102:	422080e7          	jalr	1058(ra) # 4520 <free>
    while(m1){
    1106:	f8f5                	bnez	s1,10fa <mem+0x4e>
      m1 = m2;
    }
    m1 = malloc(1024*20);
    1108:	6515                	lui	a0,0x5
    110a:	00003097          	auipc	ra,0x3
    110e:	49e080e7          	jalr	1182(ra) # 45a8 <malloc>
    if(m1 == 0){
    1112:	c115                	beqz	a0,1136 <mem+0x8a>
      printf("couldn't allocate mem?!!\n");
      kill(ppid);
      exit(-1);
    }
    free(m1);
    1114:	00003097          	auipc	ra,0x3
    1118:	40c080e7          	jalr	1036(ra) # 4520 <free>
    printf("mem ok\n");
    111c:	00004517          	auipc	a0,0x4
    1120:	cd450513          	addi	a0,a0,-812 # 4df0 <malloc+0x848>
    1124:	00003097          	auipc	ra,0x3
    1128:	3c6080e7          	jalr	966(ra) # 44ea <printf>
    exit(0);
    112c:	4501                	li	a0,0
    112e:	00003097          	auipc	ra,0x3
    1132:	024080e7          	jalr	36(ra) # 4152 <exit>
      printf("couldn't allocate mem?!!\n");
    1136:	00004517          	auipc	a0,0x4
    113a:	c9a50513          	addi	a0,a0,-870 # 4dd0 <malloc+0x828>
    113e:	00003097          	auipc	ra,0x3
    1142:	3ac080e7          	jalr	940(ra) # 44ea <printf>
      kill(ppid);
    1146:	854e                	mv	a0,s3
    1148:	00003097          	auipc	ra,0x3
    114c:	03a080e7          	jalr	58(ra) # 4182 <kill>
      exit(-1);
    1150:	557d                	li	a0,-1
    1152:	00003097          	auipc	ra,0x3
    1156:	000080e7          	jalr	ra # 4152 <exit>
  } else {
    wait(0);
    115a:	4501                	li	a0,0
    115c:	00003097          	auipc	ra,0x3
    1160:	ffe080e7          	jalr	-2(ra) # 415a <wait>
  }
}
    1164:	70a2                	ld	ra,40(sp)
    1166:	7402                	ld	s0,32(sp)
    1168:	64e2                	ld	s1,24(sp)
    116a:	6942                	ld	s2,16(sp)
    116c:	69a2                	ld	s3,8(sp)
    116e:	6145                	addi	sp,sp,48
    1170:	8082                	ret

0000000000001172 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
    1172:	715d                	addi	sp,sp,-80
    1174:	e486                	sd	ra,72(sp)
    1176:	e0a2                	sd	s0,64(sp)
    1178:	fc26                	sd	s1,56(sp)
    117a:	f84a                	sd	s2,48(sp)
    117c:	f44e                	sd	s3,40(sp)
    117e:	f052                	sd	s4,32(sp)
    1180:	ec56                	sd	s5,24(sp)
    1182:	e85a                	sd	s6,16(sp)
    1184:	0880                	addi	s0,sp,80
  int fd, pid, i, n, nc, np;
  enum { N = 1000, SZ=10};
  char buf[SZ];

  printf("sharedfd test\n");
    1186:	00004517          	auipc	a0,0x4
    118a:	c7250513          	addi	a0,a0,-910 # 4df8 <malloc+0x850>
    118e:	00003097          	auipc	ra,0x3
    1192:	35c080e7          	jalr	860(ra) # 44ea <printf>

  unlink("sharedfd");
    1196:	00004517          	auipc	a0,0x4
    119a:	c7250513          	addi	a0,a0,-910 # 4e08 <malloc+0x860>
    119e:	00003097          	auipc	ra,0x3
    11a2:	004080e7          	jalr	4(ra) # 41a2 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    11a6:	20200593          	li	a1,514
    11aa:	00004517          	auipc	a0,0x4
    11ae:	c5e50513          	addi	a0,a0,-930 # 4e08 <malloc+0x860>
    11b2:	00003097          	auipc	ra,0x3
    11b6:	fe0080e7          	jalr	-32(ra) # 4192 <open>
  if(fd < 0){
    11ba:	04054463          	bltz	a0,1202 <sharedfd+0x90>
    11be:	892a                	mv	s2,a0
    printf("fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
    11c0:	00003097          	auipc	ra,0x3
    11c4:	f8a080e7          	jalr	-118(ra) # 414a <fork>
    11c8:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    11ca:	06300593          	li	a1,99
    11ce:	c119                	beqz	a0,11d4 <sharedfd+0x62>
    11d0:	07000593          	li	a1,112
    11d4:	4629                	li	a2,10
    11d6:	fb040513          	addi	a0,s0,-80
    11da:	00003097          	auipc	ra,0x3
    11de:	df4080e7          	jalr	-524(ra) # 3fce <memset>
    11e2:	3e800493          	li	s1,1000
  for(i = 0; i < N; i++){
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    11e6:	4629                	li	a2,10
    11e8:	fb040593          	addi	a1,s0,-80
    11ec:	854a                	mv	a0,s2
    11ee:	00003097          	auipc	ra,0x3
    11f2:	f84080e7          	jalr	-124(ra) # 4172 <write>
    11f6:	47a9                	li	a5,10
    11f8:	00f51e63          	bne	a0,a5,1214 <sharedfd+0xa2>
  for(i = 0; i < N; i++){
    11fc:	34fd                	addiw	s1,s1,-1
    11fe:	f4e5                	bnez	s1,11e6 <sharedfd+0x74>
    1200:	a015                	j	1224 <sharedfd+0xb2>
    printf("fstests: cannot open sharedfd for writing");
    1202:	00004517          	auipc	a0,0x4
    1206:	c1650513          	addi	a0,a0,-1002 # 4e18 <malloc+0x870>
    120a:	00003097          	auipc	ra,0x3
    120e:	2e0080e7          	jalr	736(ra) # 44ea <printf>
    return;
    1212:	a8f9                	j	12f0 <sharedfd+0x17e>
      printf("fstests: write sharedfd failed\n");
    1214:	00004517          	auipc	a0,0x4
    1218:	c3450513          	addi	a0,a0,-972 # 4e48 <malloc+0x8a0>
    121c:	00003097          	auipc	ra,0x3
    1220:	2ce080e7          	jalr	718(ra) # 44ea <printf>
      break;
    }
  }
  if(pid == 0)
    1224:	04098d63          	beqz	s3,127e <sharedfd+0x10c>
    exit(0);
  else
    wait(0);
    1228:	4501                	li	a0,0
    122a:	00003097          	auipc	ra,0x3
    122e:	f30080e7          	jalr	-208(ra) # 415a <wait>
  close(fd);
    1232:	854a                	mv	a0,s2
    1234:	00003097          	auipc	ra,0x3
    1238:	f46080e7          	jalr	-186(ra) # 417a <close>
  fd = open("sharedfd", 0);
    123c:	4581                	li	a1,0
    123e:	00004517          	auipc	a0,0x4
    1242:	bca50513          	addi	a0,a0,-1078 # 4e08 <malloc+0x860>
    1246:	00003097          	auipc	ra,0x3
    124a:	f4c080e7          	jalr	-180(ra) # 4192 <open>
    124e:	8b2a                	mv	s6,a0
  if(fd < 0){
    printf("fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
    1250:	4a01                	li	s4,0
    1252:	4981                	li	s3,0
  if(fd < 0){
    1254:	02054a63          	bltz	a0,1288 <sharedfd+0x116>
    1258:	fba40913          	addi	s2,s0,-70
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
      if(buf[i] == 'c')
    125c:	06300493          	li	s1,99
        nc++;
      if(buf[i] == 'p')
    1260:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1264:	4629                	li	a2,10
    1266:	fb040593          	addi	a1,s0,-80
    126a:	855a                	mv	a0,s6
    126c:	00003097          	auipc	ra,0x3
    1270:	efe080e7          	jalr	-258(ra) # 416a <read>
    1274:	02a05f63          	blez	a0,12b2 <sharedfd+0x140>
    1278:	fb040793          	addi	a5,s0,-80
    127c:	a01d                	j	12a2 <sharedfd+0x130>
    exit(0);
    127e:	4501                	li	a0,0
    1280:	00003097          	auipc	ra,0x3
    1284:	ed2080e7          	jalr	-302(ra) # 4152 <exit>
    printf("fstests: cannot open sharedfd for reading\n");
    1288:	00004517          	auipc	a0,0x4
    128c:	be050513          	addi	a0,a0,-1056 # 4e68 <malloc+0x8c0>
    1290:	00003097          	auipc	ra,0x3
    1294:	25a080e7          	jalr	602(ra) # 44ea <printf>
    return;
    1298:	a8a1                	j	12f0 <sharedfd+0x17e>
        nc++;
    129a:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    129c:	0785                	addi	a5,a5,1
    129e:	fd2783e3          	beq	a5,s2,1264 <sharedfd+0xf2>
      if(buf[i] == 'c')
    12a2:	0007c703          	lbu	a4,0(a5)
    12a6:	fe970ae3          	beq	a4,s1,129a <sharedfd+0x128>
      if(buf[i] == 'p')
    12aa:	ff5719e3          	bne	a4,s5,129c <sharedfd+0x12a>
        np++;
    12ae:	2a05                	addiw	s4,s4,1
    12b0:	b7f5                	j	129c <sharedfd+0x12a>
    }
  }
  close(fd);
    12b2:	855a                	mv	a0,s6
    12b4:	00003097          	auipc	ra,0x3
    12b8:	ec6080e7          	jalr	-314(ra) # 417a <close>
  unlink("sharedfd");
    12bc:	00004517          	auipc	a0,0x4
    12c0:	b4c50513          	addi	a0,a0,-1204 # 4e08 <malloc+0x860>
    12c4:	00003097          	auipc	ra,0x3
    12c8:	ede080e7          	jalr	-290(ra) # 41a2 <unlink>
  if(nc == N*SZ && np == N*SZ){
    12cc:	6789                	lui	a5,0x2
    12ce:	71078793          	addi	a5,a5,1808 # 2710 <subdir+0x5a6>
    12d2:	02f99963          	bne	s3,a5,1304 <sharedfd+0x192>
    12d6:	6789                	lui	a5,0x2
    12d8:	71078793          	addi	a5,a5,1808 # 2710 <subdir+0x5a6>
    12dc:	02fa1463          	bne	s4,a5,1304 <sharedfd+0x192>
    printf("sharedfd ok\n");
    12e0:	00004517          	auipc	a0,0x4
    12e4:	bb850513          	addi	a0,a0,-1096 # 4e98 <malloc+0x8f0>
    12e8:	00003097          	auipc	ra,0x3
    12ec:	202080e7          	jalr	514(ra) # 44ea <printf>
  } else {
    printf("sharedfd oops %d %d\n", nc, np);
    exit(-1);
  }
}
    12f0:	60a6                	ld	ra,72(sp)
    12f2:	6406                	ld	s0,64(sp)
    12f4:	74e2                	ld	s1,56(sp)
    12f6:	7942                	ld	s2,48(sp)
    12f8:	79a2                	ld	s3,40(sp)
    12fa:	7a02                	ld	s4,32(sp)
    12fc:	6ae2                	ld	s5,24(sp)
    12fe:	6b42                	ld	s6,16(sp)
    1300:	6161                	addi	sp,sp,80
    1302:	8082                	ret
    printf("sharedfd oops %d %d\n", nc, np);
    1304:	8652                	mv	a2,s4
    1306:	85ce                	mv	a1,s3
    1308:	00004517          	auipc	a0,0x4
    130c:	ba050513          	addi	a0,a0,-1120 # 4ea8 <malloc+0x900>
    1310:	00003097          	auipc	ra,0x3
    1314:	1da080e7          	jalr	474(ra) # 44ea <printf>
    exit(-1);
    1318:	557d                	li	a0,-1
    131a:	00003097          	auipc	ra,0x3
    131e:	e38080e7          	jalr	-456(ra) # 4152 <exit>

0000000000001322 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    1322:	7119                	addi	sp,sp,-128
    1324:	fc86                	sd	ra,120(sp)
    1326:	f8a2                	sd	s0,112(sp)
    1328:	f4a6                	sd	s1,104(sp)
    132a:	f0ca                	sd	s2,96(sp)
    132c:	ecce                	sd	s3,88(sp)
    132e:	e8d2                	sd	s4,80(sp)
    1330:	e4d6                	sd	s5,72(sp)
    1332:	e0da                	sd	s6,64(sp)
    1334:	fc5e                	sd	s7,56(sp)
    1336:	f862                	sd	s8,48(sp)
    1338:	f466                	sd	s9,40(sp)
    133a:	f06a                	sd	s10,32(sp)
    133c:	0100                	addi	s0,sp,128
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    133e:	00003797          	auipc	a5,0x3
    1342:	35278793          	addi	a5,a5,850 # 4690 <malloc+0xe8>
    1346:	f8f43023          	sd	a5,-128(s0)
    134a:	00003797          	auipc	a5,0x3
    134e:	34e78793          	addi	a5,a5,846 # 4698 <malloc+0xf0>
    1352:	f8f43423          	sd	a5,-120(s0)
    1356:	00003797          	auipc	a5,0x3
    135a:	34a78793          	addi	a5,a5,842 # 46a0 <malloc+0xf8>
    135e:	f8f43823          	sd	a5,-112(s0)
    1362:	00003797          	auipc	a5,0x3
    1366:	34678793          	addi	a5,a5,838 # 46a8 <malloc+0x100>
    136a:	f8f43c23          	sd	a5,-104(s0)
  char *fname;
  enum { N=12, NCHILD=4, SZ=500 };
  
  printf("fourfiles test\n");
    136e:	00004517          	auipc	a0,0x4
    1372:	b5250513          	addi	a0,a0,-1198 # 4ec0 <malloc+0x918>
    1376:	00003097          	auipc	ra,0x3
    137a:	174080e7          	jalr	372(ra) # 44ea <printf>

  for(pi = 0; pi < NCHILD; pi++){
    137e:	f8040b93          	addi	s7,s0,-128
  printf("fourfiles test\n");
    1382:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    1384:	4481                	li	s1,0
    1386:	4a11                	li	s4,4
    fname = names[pi];
    1388:	00093983          	ld	s3,0(s2)
    unlink(fname);
    138c:	854e                	mv	a0,s3
    138e:	00003097          	auipc	ra,0x3
    1392:	e14080e7          	jalr	-492(ra) # 41a2 <unlink>

    pid = fork();
    1396:	00003097          	auipc	ra,0x3
    139a:	db4080e7          	jalr	-588(ra) # 414a <fork>
    if(pid < 0){
    139e:	04054b63          	bltz	a0,13f4 <fourfiles+0xd2>
      printf("fork failed\n");
      exit(-1);
    }

    if(pid == 0){
    13a2:	c535                	beqz	a0,140e <fourfiles+0xec>
  for(pi = 0; pi < NCHILD; pi++){
    13a4:	2485                	addiw	s1,s1,1
    13a6:	0921                	addi	s2,s2,8
    13a8:	ff4490e3          	bne	s1,s4,1388 <fourfiles+0x66>
      exit(0);
    }
  }

  for(pi = 0; pi < NCHILD; pi++){
    wait(0);
    13ac:	4501                	li	a0,0
    13ae:	00003097          	auipc	ra,0x3
    13b2:	dac080e7          	jalr	-596(ra) # 415a <wait>
    13b6:	4501                	li	a0,0
    13b8:	00003097          	auipc	ra,0x3
    13bc:	da2080e7          	jalr	-606(ra) # 415a <wait>
    13c0:	4501                	li	a0,0
    13c2:	00003097          	auipc	ra,0x3
    13c6:	d98080e7          	jalr	-616(ra) # 415a <wait>
    13ca:	4501                	li	a0,0
    13cc:	00003097          	auipc	ra,0x3
    13d0:	d8e080e7          	jalr	-626(ra) # 415a <wait>
    13d4:	03000b13          	li	s6,48

  for(i = 0; i < NCHILD; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    13d8:	00008a17          	auipc	s4,0x8
    13dc:	8b8a0a13          	addi	s4,s4,-1864 # 8c90 <buf>
    13e0:	00008a97          	auipc	s5,0x8
    13e4:	8b1a8a93          	addi	s5,s5,-1871 # 8c91 <buf+0x1>
        }
      }
      total += n;
    }
    close(fd);
    if(total != N*SZ){
    13e8:	6c85                	lui	s9,0x1
    13ea:	770c8c93          	addi	s9,s9,1904 # 1770 <createdelete+0x1fc>
  for(i = 0; i < NCHILD; i++){
    13ee:	03400d13          	li	s10,52
    13f2:	a205                	j	1512 <fourfiles+0x1f0>
      printf("fork failed\n");
    13f4:	00003517          	auipc	a0,0x3
    13f8:	36450513          	addi	a0,a0,868 # 4758 <malloc+0x1b0>
    13fc:	00003097          	auipc	ra,0x3
    1400:	0ee080e7          	jalr	238(ra) # 44ea <printf>
      exit(-1);
    1404:	557d                	li	a0,-1
    1406:	00003097          	auipc	ra,0x3
    140a:	d4c080e7          	jalr	-692(ra) # 4152 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    140e:	20200593          	li	a1,514
    1412:	854e                	mv	a0,s3
    1414:	00003097          	auipc	ra,0x3
    1418:	d7e080e7          	jalr	-642(ra) # 4192 <open>
    141c:	892a                	mv	s2,a0
      if(fd < 0){
    141e:	04054763          	bltz	a0,146c <fourfiles+0x14a>
      memset(buf, '0'+pi, SZ);
    1422:	1f400613          	li	a2,500
    1426:	0304859b          	addiw	a1,s1,48
    142a:	00008517          	auipc	a0,0x8
    142e:	86650513          	addi	a0,a0,-1946 # 8c90 <buf>
    1432:	00003097          	auipc	ra,0x3
    1436:	b9c080e7          	jalr	-1124(ra) # 3fce <memset>
    143a:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    143c:	00008997          	auipc	s3,0x8
    1440:	85498993          	addi	s3,s3,-1964 # 8c90 <buf>
    1444:	1f400613          	li	a2,500
    1448:	85ce                	mv	a1,s3
    144a:	854a                	mv	a0,s2
    144c:	00003097          	auipc	ra,0x3
    1450:	d26080e7          	jalr	-730(ra) # 4172 <write>
    1454:	85aa                	mv	a1,a0
    1456:	1f400793          	li	a5,500
    145a:	02f51663          	bne	a0,a5,1486 <fourfiles+0x164>
      for(i = 0; i < N; i++){
    145e:	34fd                	addiw	s1,s1,-1
    1460:	f0f5                	bnez	s1,1444 <fourfiles+0x122>
      exit(0);
    1462:	4501                	li	a0,0
    1464:	00003097          	auipc	ra,0x3
    1468:	cee080e7          	jalr	-786(ra) # 4152 <exit>
        printf("create failed\n");
    146c:	00004517          	auipc	a0,0x4
    1470:	a6450513          	addi	a0,a0,-1436 # 4ed0 <malloc+0x928>
    1474:	00003097          	auipc	ra,0x3
    1478:	076080e7          	jalr	118(ra) # 44ea <printf>
        exit(-1);
    147c:	557d                	li	a0,-1
    147e:	00003097          	auipc	ra,0x3
    1482:	cd4080e7          	jalr	-812(ra) # 4152 <exit>
          printf("write failed %d\n", n);
    1486:	00004517          	auipc	a0,0x4
    148a:	a5a50513          	addi	a0,a0,-1446 # 4ee0 <malloc+0x938>
    148e:	00003097          	auipc	ra,0x3
    1492:	05c080e7          	jalr	92(ra) # 44ea <printf>
          exit(-1);
    1496:	557d                	li	a0,-1
    1498:	00003097          	auipc	ra,0x3
    149c:	cba080e7          	jalr	-838(ra) # 4152 <exit>
          printf("wrong char\n");
    14a0:	00004517          	auipc	a0,0x4
    14a4:	a5850513          	addi	a0,a0,-1448 # 4ef8 <malloc+0x950>
    14a8:	00003097          	auipc	ra,0x3
    14ac:	042080e7          	jalr	66(ra) # 44ea <printf>
          exit(-1);
    14b0:	557d                	li	a0,-1
    14b2:	00003097          	auipc	ra,0x3
    14b6:	ca0080e7          	jalr	-864(ra) # 4152 <exit>
      total += n;
    14ba:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    14be:	660d                	lui	a2,0x3
    14c0:	85d2                	mv	a1,s4
    14c2:	854e                	mv	a0,s3
    14c4:	00003097          	auipc	ra,0x3
    14c8:	ca6080e7          	jalr	-858(ra) # 416a <read>
    14cc:	02a05363          	blez	a0,14f2 <fourfiles+0x1d0>
    14d0:	00007797          	auipc	a5,0x7
    14d4:	7c078793          	addi	a5,a5,1984 # 8c90 <buf>
    14d8:	fff5069b          	addiw	a3,a0,-1
    14dc:	1682                	slli	a3,a3,0x20
    14de:	9281                	srli	a3,a3,0x20
    14e0:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    14e2:	0007c703          	lbu	a4,0(a5)
    14e6:	fa971de3          	bne	a4,s1,14a0 <fourfiles+0x17e>
      for(j = 0; j < n; j++){
    14ea:	0785                	addi	a5,a5,1
    14ec:	fed79be3          	bne	a5,a3,14e2 <fourfiles+0x1c0>
    14f0:	b7e9                	j	14ba <fourfiles+0x198>
    close(fd);
    14f2:	854e                	mv	a0,s3
    14f4:	00003097          	auipc	ra,0x3
    14f8:	c86080e7          	jalr	-890(ra) # 417a <close>
    if(total != N*SZ){
    14fc:	03991863          	bne	s2,s9,152c <fourfiles+0x20a>
      printf("wrong length %d\n", total);
      exit(-1);
    }
    unlink(fname);
    1500:	8562                	mv	a0,s8
    1502:	00003097          	auipc	ra,0x3
    1506:	ca0080e7          	jalr	-864(ra) # 41a2 <unlink>
  for(i = 0; i < NCHILD; i++){
    150a:	0ba1                	addi	s7,s7,8
    150c:	2b05                	addiw	s6,s6,1
    150e:	03ab0d63          	beq	s6,s10,1548 <fourfiles+0x226>
    fname = names[i];
    1512:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    1516:	4581                	li	a1,0
    1518:	8562                	mv	a0,s8
    151a:	00003097          	auipc	ra,0x3
    151e:	c78080e7          	jalr	-904(ra) # 4192 <open>
    1522:	89aa                	mv	s3,a0
    total = 0;
    1524:	4901                	li	s2,0
        if(buf[j] != '0'+i){
    1526:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    152a:	bf51                	j	14be <fourfiles+0x19c>
      printf("wrong length %d\n", total);
    152c:	85ca                	mv	a1,s2
    152e:	00004517          	auipc	a0,0x4
    1532:	9da50513          	addi	a0,a0,-1574 # 4f08 <malloc+0x960>
    1536:	00003097          	auipc	ra,0x3
    153a:	fb4080e7          	jalr	-76(ra) # 44ea <printf>
      exit(-1);
    153e:	557d                	li	a0,-1
    1540:	00003097          	auipc	ra,0x3
    1544:	c12080e7          	jalr	-1006(ra) # 4152 <exit>
  }

  printf("fourfiles ok\n");
    1548:	00004517          	auipc	a0,0x4
    154c:	9d850513          	addi	a0,a0,-1576 # 4f20 <malloc+0x978>
    1550:	00003097          	auipc	ra,0x3
    1554:	f9a080e7          	jalr	-102(ra) # 44ea <printf>
}
    1558:	70e6                	ld	ra,120(sp)
    155a:	7446                	ld	s0,112(sp)
    155c:	74a6                	ld	s1,104(sp)
    155e:	7906                	ld	s2,96(sp)
    1560:	69e6                	ld	s3,88(sp)
    1562:	6a46                	ld	s4,80(sp)
    1564:	6aa6                	ld	s5,72(sp)
    1566:	6b06                	ld	s6,64(sp)
    1568:	7be2                	ld	s7,56(sp)
    156a:	7c42                	ld	s8,48(sp)
    156c:	7ca2                	ld	s9,40(sp)
    156e:	7d02                	ld	s10,32(sp)
    1570:	6109                	addi	sp,sp,128
    1572:	8082                	ret

0000000000001574 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    1574:	7159                	addi	sp,sp,-112
    1576:	f486                	sd	ra,104(sp)
    1578:	f0a2                	sd	s0,96(sp)
    157a:	eca6                	sd	s1,88(sp)
    157c:	e8ca                	sd	s2,80(sp)
    157e:	e4ce                	sd	s3,72(sp)
    1580:	e0d2                	sd	s4,64(sp)
    1582:	fc56                	sd	s5,56(sp)
    1584:	f85a                	sd	s6,48(sp)
    1586:	f45e                	sd	s7,40(sp)
    1588:	f062                	sd	s8,32(sp)
    158a:	1880                	addi	s0,sp,112
  enum { N = 20, NCHILD=4 };
  int pid, i, fd, pi;
  char name[32];

  printf("createdelete test\n");
    158c:	00004517          	auipc	a0,0x4
    1590:	9a450513          	addi	a0,a0,-1628 # 4f30 <malloc+0x988>
    1594:	00003097          	auipc	ra,0x3
    1598:	f56080e7          	jalr	-170(ra) # 44ea <printf>

  for(pi = 0; pi < NCHILD; pi++){
    159c:	4901                	li	s2,0
    159e:	4991                	li	s3,4
    pid = fork();
    15a0:	00003097          	auipc	ra,0x3
    15a4:	baa080e7          	jalr	-1110(ra) # 414a <fork>
    15a8:	84aa                	mv	s1,a0
    if(pid < 0){
    15aa:	04054763          	bltz	a0,15f8 <createdelete+0x84>
      printf("fork failed\n");
      exit(-1);
    }

    if(pid == 0){
    15ae:	c135                	beqz	a0,1612 <createdelete+0x9e>
  for(pi = 0; pi < NCHILD; pi++){
    15b0:	2905                	addiw	s2,s2,1
    15b2:	ff3917e3          	bne	s2,s3,15a0 <createdelete+0x2c>
      exit(0);
    }
  }

  for(pi = 0; pi < NCHILD; pi++){
    wait(0);
    15b6:	4501                	li	a0,0
    15b8:	00003097          	auipc	ra,0x3
    15bc:	ba2080e7          	jalr	-1118(ra) # 415a <wait>
    15c0:	4501                	li	a0,0
    15c2:	00003097          	auipc	ra,0x3
    15c6:	b98080e7          	jalr	-1128(ra) # 415a <wait>
    15ca:	4501                	li	a0,0
    15cc:	00003097          	auipc	ra,0x3
    15d0:	b8e080e7          	jalr	-1138(ra) # 415a <wait>
    15d4:	4501                	li	a0,0
    15d6:	00003097          	auipc	ra,0x3
    15da:	b84080e7          	jalr	-1148(ra) # 415a <wait>
  }

  name[0] = name[1] = name[2] = 0;
    15de:	f8040923          	sb	zero,-110(s0)
    15e2:	03000993          	li	s3,48
    15e6:	5a7d                	li	s4,-1
  for(i = 0; i < N; i++){
    15e8:	4901                	li	s2,0
  for(pi = 0; pi < NCHILD; pi++){
    15ea:	07000c13          	li	s8,112
      name[1] = '0' + i;
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
        printf("oops createdelete %s didn't exist\n", name);
        exit(-1);
      } else if((i >= 1 && i < N/2) && fd >= 0){
    15ee:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    15f0:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    15f2:	07400a93          	li	s5,116
    15f6:	aa89                	j	1748 <createdelete+0x1d4>
      printf("fork failed\n");
    15f8:	00003517          	auipc	a0,0x3
    15fc:	16050513          	addi	a0,a0,352 # 4758 <malloc+0x1b0>
    1600:	00003097          	auipc	ra,0x3
    1604:	eea080e7          	jalr	-278(ra) # 44ea <printf>
      exit(-1);
    1608:	557d                	li	a0,-1
    160a:	00003097          	auipc	ra,0x3
    160e:	b48080e7          	jalr	-1208(ra) # 4152 <exit>
      name[0] = 'p' + pi;
    1612:	0709091b          	addiw	s2,s2,112
    1616:	f9240823          	sb	s2,-112(s0)
      name[2] = '\0';
    161a:	f8040923          	sb	zero,-110(s0)
      for(i = 0; i < N; i++){
    161e:	4951                	li	s2,20
    1620:	a00d                	j	1642 <createdelete+0xce>
          printf("create failed\n");
    1622:	00004517          	auipc	a0,0x4
    1626:	8ae50513          	addi	a0,a0,-1874 # 4ed0 <malloc+0x928>
    162a:	00003097          	auipc	ra,0x3
    162e:	ec0080e7          	jalr	-320(ra) # 44ea <printf>
          exit(-1);
    1632:	557d                	li	a0,-1
    1634:	00003097          	auipc	ra,0x3
    1638:	b1e080e7          	jalr	-1250(ra) # 4152 <exit>
      for(i = 0; i < N; i++){
    163c:	2485                	addiw	s1,s1,1
    163e:	07248763          	beq	s1,s2,16ac <createdelete+0x138>
        name[1] = '0' + i;
    1642:	0304879b          	addiw	a5,s1,48
    1646:	f8f408a3          	sb	a5,-111(s0)
        fd = open(name, O_CREATE | O_RDWR);
    164a:	20200593          	li	a1,514
    164e:	f9040513          	addi	a0,s0,-112
    1652:	00003097          	auipc	ra,0x3
    1656:	b40080e7          	jalr	-1216(ra) # 4192 <open>
        if(fd < 0){
    165a:	fc0544e3          	bltz	a0,1622 <createdelete+0xae>
        close(fd);
    165e:	00003097          	auipc	ra,0x3
    1662:	b1c080e7          	jalr	-1252(ra) # 417a <close>
        if(i > 0 && (i % 2 ) == 0){
    1666:	fc905be3          	blez	s1,163c <createdelete+0xc8>
    166a:	0014f793          	andi	a5,s1,1
    166e:	f7f9                	bnez	a5,163c <createdelete+0xc8>
          name[1] = '0' + (i / 2);
    1670:	01f4d79b          	srliw	a5,s1,0x1f
    1674:	9fa5                	addw	a5,a5,s1
    1676:	4017d79b          	sraiw	a5,a5,0x1
    167a:	0307879b          	addiw	a5,a5,48
    167e:	f8f408a3          	sb	a5,-111(s0)
          if(unlink(name) < 0){
    1682:	f9040513          	addi	a0,s0,-112
    1686:	00003097          	auipc	ra,0x3
    168a:	b1c080e7          	jalr	-1252(ra) # 41a2 <unlink>
    168e:	fa0557e3          	bgez	a0,163c <createdelete+0xc8>
            printf("unlink failed\n");
    1692:	00003517          	auipc	a0,0x3
    1696:	15e50513          	addi	a0,a0,350 # 47f0 <malloc+0x248>
    169a:	00003097          	auipc	ra,0x3
    169e:	e50080e7          	jalr	-432(ra) # 44ea <printf>
            exit(-1);
    16a2:	557d                	li	a0,-1
    16a4:	00003097          	auipc	ra,0x3
    16a8:	aae080e7          	jalr	-1362(ra) # 4152 <exit>
      exit(0);
    16ac:	4501                	li	a0,0
    16ae:	00003097          	auipc	ra,0x3
    16b2:	aa4080e7          	jalr	-1372(ra) # 4152 <exit>
        printf("oops createdelete %s didn't exist\n", name);
    16b6:	f9040593          	addi	a1,s0,-112
    16ba:	00004517          	auipc	a0,0x4
    16be:	88e50513          	addi	a0,a0,-1906 # 4f48 <malloc+0x9a0>
    16c2:	00003097          	auipc	ra,0x3
    16c6:	e28080e7          	jalr	-472(ra) # 44ea <printf>
        exit(-1);
    16ca:	557d                	li	a0,-1
    16cc:	00003097          	auipc	ra,0x3
    16d0:	a86080e7          	jalr	-1402(ra) # 4152 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    16d4:	054b7163          	bgeu	s6,s4,1716 <createdelete+0x1a2>
        printf("oops createdelete %s did exist\n", name);
        exit(-1);
      }
      if(fd >= 0)
    16d8:	02055a63          	bgez	a0,170c <createdelete+0x198>
    for(pi = 0; pi < NCHILD; pi++){
    16dc:	2485                	addiw	s1,s1,1
    16de:	0ff4f493          	andi	s1,s1,255
    16e2:	05548b63          	beq	s1,s5,1738 <createdelete+0x1c4>
      name[0] = 'p' + pi;
    16e6:	f8940823          	sb	s1,-112(s0)
      name[1] = '0' + i;
    16ea:	f93408a3          	sb	s3,-111(s0)
      fd = open(name, 0);
    16ee:	4581                	li	a1,0
    16f0:	f9040513          	addi	a0,s0,-112
    16f4:	00003097          	auipc	ra,0x3
    16f8:	a9e080e7          	jalr	-1378(ra) # 4192 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    16fc:	00090463          	beqz	s2,1704 <createdelete+0x190>
    1700:	fd2bdae3          	bge	s7,s2,16d4 <createdelete+0x160>
    1704:	fa0549e3          	bltz	a0,16b6 <createdelete+0x142>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1708:	014b7963          	bgeu	s6,s4,171a <createdelete+0x1a6>
        close(fd);
    170c:	00003097          	auipc	ra,0x3
    1710:	a6e080e7          	jalr	-1426(ra) # 417a <close>
    1714:	b7e1                	j	16dc <createdelete+0x168>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1716:	fc0543e3          	bltz	a0,16dc <createdelete+0x168>
        printf("oops createdelete %s did exist\n", name);
    171a:	f9040593          	addi	a1,s0,-112
    171e:	00004517          	auipc	a0,0x4
    1722:	85250513          	addi	a0,a0,-1966 # 4f70 <malloc+0x9c8>
    1726:	00003097          	auipc	ra,0x3
    172a:	dc4080e7          	jalr	-572(ra) # 44ea <printf>
        exit(-1);
    172e:	557d                	li	a0,-1
    1730:	00003097          	auipc	ra,0x3
    1734:	a22080e7          	jalr	-1502(ra) # 4152 <exit>
  for(i = 0; i < N; i++){
    1738:	2905                	addiw	s2,s2,1
    173a:	2a05                	addiw	s4,s4,1
    173c:	2985                	addiw	s3,s3,1
    173e:	0ff9f993          	andi	s3,s3,255
    1742:	47d1                	li	a5,20
    1744:	02f90a63          	beq	s2,a5,1778 <createdelete+0x204>
  for(pi = 0; pi < NCHILD; pi++){
    1748:	84e2                	mv	s1,s8
    174a:	bf71                	j	16e6 <createdelete+0x172>
    }
  }

  for(i = 0; i < N; i++){
    174c:	2905                	addiw	s2,s2,1
    174e:	0ff97913          	andi	s2,s2,255
    1752:	2985                	addiw	s3,s3,1
    1754:	0ff9f993          	andi	s3,s3,255
    1758:	03490863          	beq	s2,s4,1788 <createdelete+0x214>
  for(i = 0; i < N; i++){
    175c:	84d6                	mv	s1,s5
    for(pi = 0; pi < NCHILD; pi++){
      name[0] = 'p' + i;
    175e:	f9240823          	sb	s2,-112(s0)
      name[1] = '0' + i;
    1762:	f93408a3          	sb	s3,-111(s0)
      unlink(name);
    1766:	f9040513          	addi	a0,s0,-112
    176a:	00003097          	auipc	ra,0x3
    176e:	a38080e7          	jalr	-1480(ra) # 41a2 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1772:	34fd                	addiw	s1,s1,-1
    1774:	f4ed                	bnez	s1,175e <createdelete+0x1ea>
    1776:	bfd9                	j	174c <createdelete+0x1d8>
    1778:	03000993          	li	s3,48
    177c:	07000913          	li	s2,112
  for(i = 0; i < N; i++){
    1780:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1782:	08400a13          	li	s4,132
    1786:	bfd9                	j	175c <createdelete+0x1e8>
    }
  }

  printf("createdelete ok\n");
    1788:	00004517          	auipc	a0,0x4
    178c:	80850513          	addi	a0,a0,-2040 # 4f90 <malloc+0x9e8>
    1790:	00003097          	auipc	ra,0x3
    1794:	d5a080e7          	jalr	-678(ra) # 44ea <printf>
}
    1798:	70a6                	ld	ra,104(sp)
    179a:	7406                	ld	s0,96(sp)
    179c:	64e6                	ld	s1,88(sp)
    179e:	6946                	ld	s2,80(sp)
    17a0:	69a6                	ld	s3,72(sp)
    17a2:	6a06                	ld	s4,64(sp)
    17a4:	7ae2                	ld	s5,56(sp)
    17a6:	7b42                	ld	s6,48(sp)
    17a8:	7ba2                	ld	s7,40(sp)
    17aa:	7c02                	ld	s8,32(sp)
    17ac:	6165                	addi	sp,sp,112
    17ae:	8082                	ret

00000000000017b0 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    17b0:	1101                	addi	sp,sp,-32
    17b2:	ec06                	sd	ra,24(sp)
    17b4:	e822                	sd	s0,16(sp)
    17b6:	e426                	sd	s1,8(sp)
    17b8:	e04a                	sd	s2,0(sp)
    17ba:	1000                	addi	s0,sp,32
  enum { SZ = 5 };
  int fd, fd1;

  printf("unlinkread test\n");
    17bc:	00003517          	auipc	a0,0x3
    17c0:	7ec50513          	addi	a0,a0,2028 # 4fa8 <malloc+0xa00>
    17c4:	00003097          	auipc	ra,0x3
    17c8:	d26080e7          	jalr	-730(ra) # 44ea <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    17cc:	20200593          	li	a1,514
    17d0:	00003517          	auipc	a0,0x3
    17d4:	7f050513          	addi	a0,a0,2032 # 4fc0 <malloc+0xa18>
    17d8:	00003097          	auipc	ra,0x3
    17dc:	9ba080e7          	jalr	-1606(ra) # 4192 <open>
  if(fd < 0){
    17e0:	0e054c63          	bltz	a0,18d8 <unlinkread+0x128>
    17e4:	84aa                	mv	s1,a0
    printf("create unlinkread failed\n");
    exit(-1);
  }
  write(fd, "hello", SZ);
    17e6:	4615                	li	a2,5
    17e8:	00004597          	auipc	a1,0x4
    17ec:	80858593          	addi	a1,a1,-2040 # 4ff0 <malloc+0xa48>
    17f0:	00003097          	auipc	ra,0x3
    17f4:	982080e7          	jalr	-1662(ra) # 4172 <write>
  close(fd);
    17f8:	8526                	mv	a0,s1
    17fa:	00003097          	auipc	ra,0x3
    17fe:	980080e7          	jalr	-1664(ra) # 417a <close>

  fd = open("unlinkread", O_RDWR);
    1802:	4589                	li	a1,2
    1804:	00003517          	auipc	a0,0x3
    1808:	7bc50513          	addi	a0,a0,1980 # 4fc0 <malloc+0xa18>
    180c:	00003097          	auipc	ra,0x3
    1810:	986080e7          	jalr	-1658(ra) # 4192 <open>
    1814:	84aa                	mv	s1,a0
  if(fd < 0){
    1816:	0c054e63          	bltz	a0,18f2 <unlinkread+0x142>
    printf("open unlinkread failed\n");
    exit(-1);
  }
  if(unlink("unlinkread") != 0){
    181a:	00003517          	auipc	a0,0x3
    181e:	7a650513          	addi	a0,a0,1958 # 4fc0 <malloc+0xa18>
    1822:	00003097          	auipc	ra,0x3
    1826:	980080e7          	jalr	-1664(ra) # 41a2 <unlink>
    182a:	e16d                	bnez	a0,190c <unlinkread+0x15c>
    printf("unlink unlinkread failed\n");
    exit(-1);
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    182c:	20200593          	li	a1,514
    1830:	00003517          	auipc	a0,0x3
    1834:	79050513          	addi	a0,a0,1936 # 4fc0 <malloc+0xa18>
    1838:	00003097          	auipc	ra,0x3
    183c:	95a080e7          	jalr	-1702(ra) # 4192 <open>
    1840:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
    1842:	460d                	li	a2,3
    1844:	00003597          	auipc	a1,0x3
    1848:	7ec58593          	addi	a1,a1,2028 # 5030 <malloc+0xa88>
    184c:	00003097          	auipc	ra,0x3
    1850:	926080e7          	jalr	-1754(ra) # 4172 <write>
  close(fd1);
    1854:	854a                	mv	a0,s2
    1856:	00003097          	auipc	ra,0x3
    185a:	924080e7          	jalr	-1756(ra) # 417a <close>

  if(read(fd, buf, sizeof(buf)) != SZ){
    185e:	660d                	lui	a2,0x3
    1860:	00007597          	auipc	a1,0x7
    1864:	43058593          	addi	a1,a1,1072 # 8c90 <buf>
    1868:	8526                	mv	a0,s1
    186a:	00003097          	auipc	ra,0x3
    186e:	900080e7          	jalr	-1792(ra) # 416a <read>
    1872:	4795                	li	a5,5
    1874:	0af51963          	bne	a0,a5,1926 <unlinkread+0x176>
    printf("unlinkread read failed");
    exit(-1);
  }
  if(buf[0] != 'h'){
    1878:	00007717          	auipc	a4,0x7
    187c:	41874703          	lbu	a4,1048(a4) # 8c90 <buf>
    1880:	06800793          	li	a5,104
    1884:	0af71e63          	bne	a4,a5,1940 <unlinkread+0x190>
    printf("unlinkread wrong data\n");
    exit(-1);
  }
  if(write(fd, buf, 10) != 10){
    1888:	4629                	li	a2,10
    188a:	00007597          	auipc	a1,0x7
    188e:	40658593          	addi	a1,a1,1030 # 8c90 <buf>
    1892:	8526                	mv	a0,s1
    1894:	00003097          	auipc	ra,0x3
    1898:	8de080e7          	jalr	-1826(ra) # 4172 <write>
    189c:	47a9                	li	a5,10
    189e:	0af51e63          	bne	a0,a5,195a <unlinkread+0x1aa>
    printf("unlinkread write failed\n");
    exit(-1);
  }
  close(fd);
    18a2:	8526                	mv	a0,s1
    18a4:	00003097          	auipc	ra,0x3
    18a8:	8d6080e7          	jalr	-1834(ra) # 417a <close>
  unlink("unlinkread");
    18ac:	00003517          	auipc	a0,0x3
    18b0:	71450513          	addi	a0,a0,1812 # 4fc0 <malloc+0xa18>
    18b4:	00003097          	auipc	ra,0x3
    18b8:	8ee080e7          	jalr	-1810(ra) # 41a2 <unlink>
  printf("unlinkread ok\n");
    18bc:	00003517          	auipc	a0,0x3
    18c0:	7cc50513          	addi	a0,a0,1996 # 5088 <malloc+0xae0>
    18c4:	00003097          	auipc	ra,0x3
    18c8:	c26080e7          	jalr	-986(ra) # 44ea <printf>
}
    18cc:	60e2                	ld	ra,24(sp)
    18ce:	6442                	ld	s0,16(sp)
    18d0:	64a2                	ld	s1,8(sp)
    18d2:	6902                	ld	s2,0(sp)
    18d4:	6105                	addi	sp,sp,32
    18d6:	8082                	ret
    printf("create unlinkread failed\n");
    18d8:	00003517          	auipc	a0,0x3
    18dc:	6f850513          	addi	a0,a0,1784 # 4fd0 <malloc+0xa28>
    18e0:	00003097          	auipc	ra,0x3
    18e4:	c0a080e7          	jalr	-1014(ra) # 44ea <printf>
    exit(-1);
    18e8:	557d                	li	a0,-1
    18ea:	00003097          	auipc	ra,0x3
    18ee:	868080e7          	jalr	-1944(ra) # 4152 <exit>
    printf("open unlinkread failed\n");
    18f2:	00003517          	auipc	a0,0x3
    18f6:	70650513          	addi	a0,a0,1798 # 4ff8 <malloc+0xa50>
    18fa:	00003097          	auipc	ra,0x3
    18fe:	bf0080e7          	jalr	-1040(ra) # 44ea <printf>
    exit(-1);
    1902:	557d                	li	a0,-1
    1904:	00003097          	auipc	ra,0x3
    1908:	84e080e7          	jalr	-1970(ra) # 4152 <exit>
    printf("unlink unlinkread failed\n");
    190c:	00003517          	auipc	a0,0x3
    1910:	70450513          	addi	a0,a0,1796 # 5010 <malloc+0xa68>
    1914:	00003097          	auipc	ra,0x3
    1918:	bd6080e7          	jalr	-1066(ra) # 44ea <printf>
    exit(-1);
    191c:	557d                	li	a0,-1
    191e:	00003097          	auipc	ra,0x3
    1922:	834080e7          	jalr	-1996(ra) # 4152 <exit>
    printf("unlinkread read failed");
    1926:	00003517          	auipc	a0,0x3
    192a:	71250513          	addi	a0,a0,1810 # 5038 <malloc+0xa90>
    192e:	00003097          	auipc	ra,0x3
    1932:	bbc080e7          	jalr	-1092(ra) # 44ea <printf>
    exit(-1);
    1936:	557d                	li	a0,-1
    1938:	00003097          	auipc	ra,0x3
    193c:	81a080e7          	jalr	-2022(ra) # 4152 <exit>
    printf("unlinkread wrong data\n");
    1940:	00003517          	auipc	a0,0x3
    1944:	71050513          	addi	a0,a0,1808 # 5050 <malloc+0xaa8>
    1948:	00003097          	auipc	ra,0x3
    194c:	ba2080e7          	jalr	-1118(ra) # 44ea <printf>
    exit(-1);
    1950:	557d                	li	a0,-1
    1952:	00003097          	auipc	ra,0x3
    1956:	800080e7          	jalr	-2048(ra) # 4152 <exit>
    printf("unlinkread write failed\n");
    195a:	00003517          	auipc	a0,0x3
    195e:	70e50513          	addi	a0,a0,1806 # 5068 <malloc+0xac0>
    1962:	00003097          	auipc	ra,0x3
    1966:	b88080e7          	jalr	-1144(ra) # 44ea <printf>
    exit(-1);
    196a:	557d                	li	a0,-1
    196c:	00002097          	auipc	ra,0x2
    1970:	7e6080e7          	jalr	2022(ra) # 4152 <exit>

0000000000001974 <linktest>:

void
linktest(void)
{
    1974:	1101                	addi	sp,sp,-32
    1976:	ec06                	sd	ra,24(sp)
    1978:	e822                	sd	s0,16(sp)
    197a:	e426                	sd	s1,8(sp)
    197c:	1000                	addi	s0,sp,32
  enum { SZ = 5 };
  int fd;

  printf("linktest\n");
    197e:	00003517          	auipc	a0,0x3
    1982:	71a50513          	addi	a0,a0,1818 # 5098 <malloc+0xaf0>
    1986:	00003097          	auipc	ra,0x3
    198a:	b64080e7          	jalr	-1180(ra) # 44ea <printf>

  unlink("lf1");
    198e:	00003517          	auipc	a0,0x3
    1992:	71a50513          	addi	a0,a0,1818 # 50a8 <malloc+0xb00>
    1996:	00003097          	auipc	ra,0x3
    199a:	80c080e7          	jalr	-2036(ra) # 41a2 <unlink>
  unlink("lf2");
    199e:	00003517          	auipc	a0,0x3
    19a2:	71250513          	addi	a0,a0,1810 # 50b0 <malloc+0xb08>
    19a6:	00002097          	auipc	ra,0x2
    19aa:	7fc080e7          	jalr	2044(ra) # 41a2 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    19ae:	20200593          	li	a1,514
    19b2:	00003517          	auipc	a0,0x3
    19b6:	6f650513          	addi	a0,a0,1782 # 50a8 <malloc+0xb00>
    19ba:	00002097          	auipc	ra,0x2
    19be:	7d8080e7          	jalr	2008(ra) # 4192 <open>
  if(fd < 0){
    19c2:	10054e63          	bltz	a0,1ade <linktest+0x16a>
    19c6:	84aa                	mv	s1,a0
    printf("create lf1 failed\n");
    exit(-1);
  }
  if(write(fd, "hello", SZ) != SZ){
    19c8:	4615                	li	a2,5
    19ca:	00003597          	auipc	a1,0x3
    19ce:	62658593          	addi	a1,a1,1574 # 4ff0 <malloc+0xa48>
    19d2:	00002097          	auipc	ra,0x2
    19d6:	7a0080e7          	jalr	1952(ra) # 4172 <write>
    19da:	4795                	li	a5,5
    19dc:	10f51e63          	bne	a0,a5,1af8 <linktest+0x184>
    printf("write lf1 failed\n");
    exit(-1);
  }
  close(fd);
    19e0:	8526                	mv	a0,s1
    19e2:	00002097          	auipc	ra,0x2
    19e6:	798080e7          	jalr	1944(ra) # 417a <close>

  if(link("lf1", "lf2") < 0){
    19ea:	00003597          	auipc	a1,0x3
    19ee:	6c658593          	addi	a1,a1,1734 # 50b0 <malloc+0xb08>
    19f2:	00003517          	auipc	a0,0x3
    19f6:	6b650513          	addi	a0,a0,1718 # 50a8 <malloc+0xb00>
    19fa:	00002097          	auipc	ra,0x2
    19fe:	7b8080e7          	jalr	1976(ra) # 41b2 <link>
    1a02:	10054863          	bltz	a0,1b12 <linktest+0x19e>
    printf("link lf1 lf2 failed\n");
    exit(-1);
  }
  unlink("lf1");
    1a06:	00003517          	auipc	a0,0x3
    1a0a:	6a250513          	addi	a0,a0,1698 # 50a8 <malloc+0xb00>
    1a0e:	00002097          	auipc	ra,0x2
    1a12:	794080e7          	jalr	1940(ra) # 41a2 <unlink>

  if(open("lf1", 0) >= 0){
    1a16:	4581                	li	a1,0
    1a18:	00003517          	auipc	a0,0x3
    1a1c:	69050513          	addi	a0,a0,1680 # 50a8 <malloc+0xb00>
    1a20:	00002097          	auipc	ra,0x2
    1a24:	772080e7          	jalr	1906(ra) # 4192 <open>
    1a28:	10055263          	bgez	a0,1b2c <linktest+0x1b8>
    printf("unlinked lf1 but it is still there!\n");
    exit(-1);
  }

  fd = open("lf2", 0);
    1a2c:	4581                	li	a1,0
    1a2e:	00003517          	auipc	a0,0x3
    1a32:	68250513          	addi	a0,a0,1666 # 50b0 <malloc+0xb08>
    1a36:	00002097          	auipc	ra,0x2
    1a3a:	75c080e7          	jalr	1884(ra) # 4192 <open>
    1a3e:	84aa                	mv	s1,a0
  if(fd < 0){
    1a40:	10054363          	bltz	a0,1b46 <linktest+0x1d2>
    printf("open lf2 failed\n");
    exit(-1);
  }
  if(read(fd, buf, sizeof(buf)) != SZ){
    1a44:	660d                	lui	a2,0x3
    1a46:	00007597          	auipc	a1,0x7
    1a4a:	24a58593          	addi	a1,a1,586 # 8c90 <buf>
    1a4e:	00002097          	auipc	ra,0x2
    1a52:	71c080e7          	jalr	1820(ra) # 416a <read>
    1a56:	4795                	li	a5,5
    1a58:	10f51463          	bne	a0,a5,1b60 <linktest+0x1ec>
    printf("read lf2 failed\n");
    exit(-1);
  }
  close(fd);
    1a5c:	8526                	mv	a0,s1
    1a5e:	00002097          	auipc	ra,0x2
    1a62:	71c080e7          	jalr	1820(ra) # 417a <close>

  if(link("lf2", "lf2") >= 0){
    1a66:	00003597          	auipc	a1,0x3
    1a6a:	64a58593          	addi	a1,a1,1610 # 50b0 <malloc+0xb08>
    1a6e:	852e                	mv	a0,a1
    1a70:	00002097          	auipc	ra,0x2
    1a74:	742080e7          	jalr	1858(ra) # 41b2 <link>
    1a78:	10055163          	bgez	a0,1b7a <linktest+0x206>
    printf("link lf2 lf2 succeeded! oops\n");
    exit(-1);
  }

  unlink("lf2");
    1a7c:	00003517          	auipc	a0,0x3
    1a80:	63450513          	addi	a0,a0,1588 # 50b0 <malloc+0xb08>
    1a84:	00002097          	auipc	ra,0x2
    1a88:	71e080e7          	jalr	1822(ra) # 41a2 <unlink>
  if(link("lf2", "lf1") >= 0){
    1a8c:	00003597          	auipc	a1,0x3
    1a90:	61c58593          	addi	a1,a1,1564 # 50a8 <malloc+0xb00>
    1a94:	00003517          	auipc	a0,0x3
    1a98:	61c50513          	addi	a0,a0,1564 # 50b0 <malloc+0xb08>
    1a9c:	00002097          	auipc	ra,0x2
    1aa0:	716080e7          	jalr	1814(ra) # 41b2 <link>
    1aa4:	0e055863          	bgez	a0,1b94 <linktest+0x220>
    printf("link non-existant succeeded! oops\n");
    exit(-1);
  }

  if(link(".", "lf1") >= 0){
    1aa8:	00003597          	auipc	a1,0x3
    1aac:	60058593          	addi	a1,a1,1536 # 50a8 <malloc+0xb00>
    1ab0:	00003517          	auipc	a0,0x3
    1ab4:	6f050513          	addi	a0,a0,1776 # 51a0 <malloc+0xbf8>
    1ab8:	00002097          	auipc	ra,0x2
    1abc:	6fa080e7          	jalr	1786(ra) # 41b2 <link>
    1ac0:	0e055763          	bgez	a0,1bae <linktest+0x23a>
    printf("link . lf1 succeeded! oops\n");
    exit(-1);
  }

  printf("linktest ok\n");
    1ac4:	00003517          	auipc	a0,0x3
    1ac8:	70450513          	addi	a0,a0,1796 # 51c8 <malloc+0xc20>
    1acc:	00003097          	auipc	ra,0x3
    1ad0:	a1e080e7          	jalr	-1506(ra) # 44ea <printf>
}
    1ad4:	60e2                	ld	ra,24(sp)
    1ad6:	6442                	ld	s0,16(sp)
    1ad8:	64a2                	ld	s1,8(sp)
    1ada:	6105                	addi	sp,sp,32
    1adc:	8082                	ret
    printf("create lf1 failed\n");
    1ade:	00003517          	auipc	a0,0x3
    1ae2:	5da50513          	addi	a0,a0,1498 # 50b8 <malloc+0xb10>
    1ae6:	00003097          	auipc	ra,0x3
    1aea:	a04080e7          	jalr	-1532(ra) # 44ea <printf>
    exit(-1);
    1aee:	557d                	li	a0,-1
    1af0:	00002097          	auipc	ra,0x2
    1af4:	662080e7          	jalr	1634(ra) # 4152 <exit>
    printf("write lf1 failed\n");
    1af8:	00003517          	auipc	a0,0x3
    1afc:	5d850513          	addi	a0,a0,1496 # 50d0 <malloc+0xb28>
    1b00:	00003097          	auipc	ra,0x3
    1b04:	9ea080e7          	jalr	-1558(ra) # 44ea <printf>
    exit(-1);
    1b08:	557d                	li	a0,-1
    1b0a:	00002097          	auipc	ra,0x2
    1b0e:	648080e7          	jalr	1608(ra) # 4152 <exit>
    printf("link lf1 lf2 failed\n");
    1b12:	00003517          	auipc	a0,0x3
    1b16:	5d650513          	addi	a0,a0,1494 # 50e8 <malloc+0xb40>
    1b1a:	00003097          	auipc	ra,0x3
    1b1e:	9d0080e7          	jalr	-1584(ra) # 44ea <printf>
    exit(-1);
    1b22:	557d                	li	a0,-1
    1b24:	00002097          	auipc	ra,0x2
    1b28:	62e080e7          	jalr	1582(ra) # 4152 <exit>
    printf("unlinked lf1 but it is still there!\n");
    1b2c:	00003517          	auipc	a0,0x3
    1b30:	5d450513          	addi	a0,a0,1492 # 5100 <malloc+0xb58>
    1b34:	00003097          	auipc	ra,0x3
    1b38:	9b6080e7          	jalr	-1610(ra) # 44ea <printf>
    exit(-1);
    1b3c:	557d                	li	a0,-1
    1b3e:	00002097          	auipc	ra,0x2
    1b42:	614080e7          	jalr	1556(ra) # 4152 <exit>
    printf("open lf2 failed\n");
    1b46:	00003517          	auipc	a0,0x3
    1b4a:	5e250513          	addi	a0,a0,1506 # 5128 <malloc+0xb80>
    1b4e:	00003097          	auipc	ra,0x3
    1b52:	99c080e7          	jalr	-1636(ra) # 44ea <printf>
    exit(-1);
    1b56:	557d                	li	a0,-1
    1b58:	00002097          	auipc	ra,0x2
    1b5c:	5fa080e7          	jalr	1530(ra) # 4152 <exit>
    printf("read lf2 failed\n");
    1b60:	00003517          	auipc	a0,0x3
    1b64:	5e050513          	addi	a0,a0,1504 # 5140 <malloc+0xb98>
    1b68:	00003097          	auipc	ra,0x3
    1b6c:	982080e7          	jalr	-1662(ra) # 44ea <printf>
    exit(-1);
    1b70:	557d                	li	a0,-1
    1b72:	00002097          	auipc	ra,0x2
    1b76:	5e0080e7          	jalr	1504(ra) # 4152 <exit>
    printf("link lf2 lf2 succeeded! oops\n");
    1b7a:	00003517          	auipc	a0,0x3
    1b7e:	5de50513          	addi	a0,a0,1502 # 5158 <malloc+0xbb0>
    1b82:	00003097          	auipc	ra,0x3
    1b86:	968080e7          	jalr	-1688(ra) # 44ea <printf>
    exit(-1);
    1b8a:	557d                	li	a0,-1
    1b8c:	00002097          	auipc	ra,0x2
    1b90:	5c6080e7          	jalr	1478(ra) # 4152 <exit>
    printf("link non-existant succeeded! oops\n");
    1b94:	00003517          	auipc	a0,0x3
    1b98:	5e450513          	addi	a0,a0,1508 # 5178 <malloc+0xbd0>
    1b9c:	00003097          	auipc	ra,0x3
    1ba0:	94e080e7          	jalr	-1714(ra) # 44ea <printf>
    exit(-1);
    1ba4:	557d                	li	a0,-1
    1ba6:	00002097          	auipc	ra,0x2
    1baa:	5ac080e7          	jalr	1452(ra) # 4152 <exit>
    printf("link . lf1 succeeded! oops\n");
    1bae:	00003517          	auipc	a0,0x3
    1bb2:	5fa50513          	addi	a0,a0,1530 # 51a8 <malloc+0xc00>
    1bb6:	00003097          	auipc	ra,0x3
    1bba:	934080e7          	jalr	-1740(ra) # 44ea <printf>
    exit(-1);
    1bbe:	557d                	li	a0,-1
    1bc0:	00002097          	auipc	ra,0x2
    1bc4:	592080e7          	jalr	1426(ra) # 4152 <exit>

0000000000001bc8 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1bc8:	7119                	addi	sp,sp,-128
    1bca:	fc86                	sd	ra,120(sp)
    1bcc:	f8a2                	sd	s0,112(sp)
    1bce:	f4a6                	sd	s1,104(sp)
    1bd0:	f0ca                	sd	s2,96(sp)
    1bd2:	ecce                	sd	s3,88(sp)
    1bd4:	e8d2                	sd	s4,80(sp)
    1bd6:	e4d6                	sd	s5,72(sp)
    1bd8:	0100                	addi	s0,sp,128
  struct {
    ushort inum;
    char name[DIRSIZ];
  } de;

  printf("concreate test\n");
    1bda:	00003517          	auipc	a0,0x3
    1bde:	5fe50513          	addi	a0,a0,1534 # 51d8 <malloc+0xc30>
    1be2:	00003097          	auipc	ra,0x3
    1be6:	908080e7          	jalr	-1784(ra) # 44ea <printf>
  file[0] = 'C';
    1bea:	04300793          	li	a5,67
    1bee:	faf40c23          	sb	a5,-72(s0)
  file[2] = '\0';
    1bf2:	fa040d23          	sb	zero,-70(s0)
  for(i = 0; i < N; i++){
    1bf6:	4481                	li	s1,0
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
    1bf8:	4a0d                	li	s4,3
    1bfa:	4985                	li	s3,1
      link("C0", file);
    1bfc:	00003a97          	auipc	s5,0x3
    1c00:	5eca8a93          	addi	s5,s5,1516 # 51e8 <malloc+0xc40>
  for(i = 0; i < N; i++){
    1c04:	02800913          	li	s2,40
    1c08:	ac49                	j	1e9a <concreate+0x2d2>
      link("C0", file);
    1c0a:	fb840593          	addi	a1,s0,-72
    1c0e:	8556                	mv	a0,s5
    1c10:	00002097          	auipc	ra,0x2
    1c14:	5a2080e7          	jalr	1442(ra) # 41b2 <link>
        printf("concreate create %s failed\n", file);
        exit(-1);
      }
      close(fd);
    }
    if(pid == 0)
    1c18:	ac8d                	j	1e8a <concreate+0x2c2>
    } else if(pid == 0 && (i % 5) == 1){
    1c1a:	4795                	li	a5,5
    1c1c:	02f4e4bb          	remw	s1,s1,a5
    1c20:	4785                	li	a5,1
    1c22:	02f48b63          	beq	s1,a5,1c58 <concreate+0x90>
      fd = open(file, O_CREATE | O_RDWR);
    1c26:	20200593          	li	a1,514
    1c2a:	fb840513          	addi	a0,s0,-72
    1c2e:	00002097          	auipc	ra,0x2
    1c32:	564080e7          	jalr	1380(ra) # 4192 <open>
      if(fd < 0){
    1c36:	24055163          	bgez	a0,1e78 <concreate+0x2b0>
        printf("concreate create %s failed\n", file);
    1c3a:	fb840593          	addi	a1,s0,-72
    1c3e:	00003517          	auipc	a0,0x3
    1c42:	5b250513          	addi	a0,a0,1458 # 51f0 <malloc+0xc48>
    1c46:	00003097          	auipc	ra,0x3
    1c4a:	8a4080e7          	jalr	-1884(ra) # 44ea <printf>
        exit(-1);
    1c4e:	557d                	li	a0,-1
    1c50:	00002097          	auipc	ra,0x2
    1c54:	502080e7          	jalr	1282(ra) # 4152 <exit>
      link("C0", file);
    1c58:	fb840593          	addi	a1,s0,-72
    1c5c:	00003517          	auipc	a0,0x3
    1c60:	58c50513          	addi	a0,a0,1420 # 51e8 <malloc+0xc40>
    1c64:	00002097          	auipc	ra,0x2
    1c68:	54e080e7          	jalr	1358(ra) # 41b2 <link>
      exit(0);
    1c6c:	4501                	li	a0,0
    1c6e:	00002097          	auipc	ra,0x2
    1c72:	4e4080e7          	jalr	1252(ra) # 4152 <exit>
    else
      wait(0);
  }

  memset(fa, 0, sizeof(fa));
    1c76:	02800613          	li	a2,40
    1c7a:	4581                	li	a1,0
    1c7c:	f9040513          	addi	a0,s0,-112
    1c80:	00002097          	auipc	ra,0x2
    1c84:	34e080e7          	jalr	846(ra) # 3fce <memset>
  fd = open(".", 0);
    1c88:	4581                	li	a1,0
    1c8a:	00003517          	auipc	a0,0x3
    1c8e:	51650513          	addi	a0,a0,1302 # 51a0 <malloc+0xbf8>
    1c92:	00002097          	auipc	ra,0x2
    1c96:	500080e7          	jalr	1280(ra) # 4192 <open>
    1c9a:	84aa                	mv	s1,a0
  n = 0;
    1c9c:	4981                	li	s3,0
  while(read(fd, &de, sizeof(de)) > 0){
    if(de.inum == 0)
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1c9e:	04300913          	li	s2,67
      i = de.name[1] - '0';
      if(i < 0 || i >= sizeof(fa)){
    1ca2:	02700a13          	li	s4,39
      }
      if(fa[i]){
        printf("concreate duplicate file %s\n", de.name);
        exit(-1);
      }
      fa[i] = 1;
    1ca6:	4a85                	li	s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    1ca8:	4641                	li	a2,16
    1caa:	f8040593          	addi	a1,s0,-128
    1cae:	8526                	mv	a0,s1
    1cb0:	00002097          	auipc	ra,0x2
    1cb4:	4ba080e7          	jalr	1210(ra) # 416a <read>
    1cb8:	06a05f63          	blez	a0,1d36 <concreate+0x16e>
    if(de.inum == 0)
    1cbc:	f8045783          	lhu	a5,-128(s0)
    1cc0:	d7e5                	beqz	a5,1ca8 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1cc2:	f8244783          	lbu	a5,-126(s0)
    1cc6:	ff2791e3          	bne	a5,s2,1ca8 <concreate+0xe0>
    1cca:	f8444783          	lbu	a5,-124(s0)
    1cce:	ffe9                	bnez	a5,1ca8 <concreate+0xe0>
      i = de.name[1] - '0';
    1cd0:	f8344783          	lbu	a5,-125(s0)
    1cd4:	fd07879b          	addiw	a5,a5,-48
    1cd8:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    1cdc:	00ea6f63          	bltu	s4,a4,1cfa <concreate+0x132>
      if(fa[i]){
    1ce0:	fc040793          	addi	a5,s0,-64
    1ce4:	97ba                	add	a5,a5,a4
    1ce6:	fd07c783          	lbu	a5,-48(a5)
    1cea:	e79d                	bnez	a5,1d18 <concreate+0x150>
      fa[i] = 1;
    1cec:	fc040793          	addi	a5,s0,-64
    1cf0:	973e                	add	a4,a4,a5
    1cf2:	fd570823          	sb	s5,-48(a4)
      n++;
    1cf6:	2985                	addiw	s3,s3,1
    1cf8:	bf45                	j	1ca8 <concreate+0xe0>
        printf("concreate weird file %s\n", de.name);
    1cfa:	f8240593          	addi	a1,s0,-126
    1cfe:	00003517          	auipc	a0,0x3
    1d02:	51250513          	addi	a0,a0,1298 # 5210 <malloc+0xc68>
    1d06:	00002097          	auipc	ra,0x2
    1d0a:	7e4080e7          	jalr	2020(ra) # 44ea <printf>
        exit(-1);
    1d0e:	557d                	li	a0,-1
    1d10:	00002097          	auipc	ra,0x2
    1d14:	442080e7          	jalr	1090(ra) # 4152 <exit>
        printf("concreate duplicate file %s\n", de.name);
    1d18:	f8240593          	addi	a1,s0,-126
    1d1c:	00003517          	auipc	a0,0x3
    1d20:	51450513          	addi	a0,a0,1300 # 5230 <malloc+0xc88>
    1d24:	00002097          	auipc	ra,0x2
    1d28:	7c6080e7          	jalr	1990(ra) # 44ea <printf>
        exit(-1);
    1d2c:	557d                	li	a0,-1
    1d2e:	00002097          	auipc	ra,0x2
    1d32:	424080e7          	jalr	1060(ra) # 4152 <exit>
    }
  }
  close(fd);
    1d36:	8526                	mv	a0,s1
    1d38:	00002097          	auipc	ra,0x2
    1d3c:	442080e7          	jalr	1090(ra) # 417a <close>

  if(n != N){
    1d40:	02800793          	li	a5,40
    printf("concreate not enough files in directory listing\n");
    exit(-1);
  }

  for(i = 0; i < N; i++){
    1d44:	4901                	li	s2,0
  if(n != N){
    1d46:	00f99763          	bne	s3,a5,1d54 <concreate+0x18c>
    pid = fork();
    if(pid < 0){
      printf("fork failed\n");
      exit(-1);
    }
    if(((i % 3) == 0 && pid == 0) ||
    1d4a:	4a0d                	li	s4,3
    1d4c:	4a85                	li	s5,1
  for(i = 0; i < N; i++){
    1d4e:	02800993          	li	s3,40
    1d52:	a045                	j	1df2 <concreate+0x22a>
    printf("concreate not enough files in directory listing\n");
    1d54:	00003517          	auipc	a0,0x3
    1d58:	4fc50513          	addi	a0,a0,1276 # 5250 <malloc+0xca8>
    1d5c:	00002097          	auipc	ra,0x2
    1d60:	78e080e7          	jalr	1934(ra) # 44ea <printf>
    exit(-1);
    1d64:	557d                	li	a0,-1
    1d66:	00002097          	auipc	ra,0x2
    1d6a:	3ec080e7          	jalr	1004(ra) # 4152 <exit>
      printf("fork failed\n");
    1d6e:	00003517          	auipc	a0,0x3
    1d72:	9ea50513          	addi	a0,a0,-1558 # 4758 <malloc+0x1b0>
    1d76:	00002097          	auipc	ra,0x2
    1d7a:	774080e7          	jalr	1908(ra) # 44ea <printf>
      exit(-1);
    1d7e:	557d                	li	a0,-1
    1d80:	00002097          	auipc	ra,0x2
    1d84:	3d2080e7          	jalr	978(ra) # 4152 <exit>
       ((i % 3) == 1 && pid != 0)){
      close(open(file, 0));
    1d88:	4581                	li	a1,0
    1d8a:	fb840513          	addi	a0,s0,-72
    1d8e:	00002097          	auipc	ra,0x2
    1d92:	404080e7          	jalr	1028(ra) # 4192 <open>
    1d96:	00002097          	auipc	ra,0x2
    1d9a:	3e4080e7          	jalr	996(ra) # 417a <close>
      close(open(file, 0));
    1d9e:	4581                	li	a1,0
    1da0:	fb840513          	addi	a0,s0,-72
    1da4:	00002097          	auipc	ra,0x2
    1da8:	3ee080e7          	jalr	1006(ra) # 4192 <open>
    1dac:	00002097          	auipc	ra,0x2
    1db0:	3ce080e7          	jalr	974(ra) # 417a <close>
      close(open(file, 0));
    1db4:	4581                	li	a1,0
    1db6:	fb840513          	addi	a0,s0,-72
    1dba:	00002097          	auipc	ra,0x2
    1dbe:	3d8080e7          	jalr	984(ra) # 4192 <open>
    1dc2:	00002097          	auipc	ra,0x2
    1dc6:	3b8080e7          	jalr	952(ra) # 417a <close>
      close(open(file, 0));
    1dca:	4581                	li	a1,0
    1dcc:	fb840513          	addi	a0,s0,-72
    1dd0:	00002097          	auipc	ra,0x2
    1dd4:	3c2080e7          	jalr	962(ra) # 4192 <open>
    1dd8:	00002097          	auipc	ra,0x2
    1ddc:	3a2080e7          	jalr	930(ra) # 417a <close>
      unlink(file);
      unlink(file);
      unlink(file);
      unlink(file);
    }
    if(pid == 0)
    1de0:	c4b5                	beqz	s1,1e4c <concreate+0x284>
      exit(0);
    else
      wait(0);
    1de2:	4501                	li	a0,0
    1de4:	00002097          	auipc	ra,0x2
    1de8:	376080e7          	jalr	886(ra) # 415a <wait>
  for(i = 0; i < N; i++){
    1dec:	2905                	addiw	s2,s2,1
    1dee:	07390463          	beq	s2,s3,1e56 <concreate+0x28e>
    file[1] = '0' + i;
    1df2:	0309079b          	addiw	a5,s2,48
    1df6:	faf40ca3          	sb	a5,-71(s0)
    pid = fork();
    1dfa:	00002097          	auipc	ra,0x2
    1dfe:	350080e7          	jalr	848(ra) # 414a <fork>
    1e02:	84aa                	mv	s1,a0
    if(pid < 0){
    1e04:	f60545e3          	bltz	a0,1d6e <concreate+0x1a6>
    if(((i % 3) == 0 && pid == 0) ||
    1e08:	0349673b          	remw	a4,s2,s4
    1e0c:	00a767b3          	or	a5,a4,a0
    1e10:	2781                	sext.w	a5,a5
    1e12:	dbbd                	beqz	a5,1d88 <concreate+0x1c0>
    1e14:	01571363          	bne	a4,s5,1e1a <concreate+0x252>
       ((i % 3) == 1 && pid != 0)){
    1e18:	f925                	bnez	a0,1d88 <concreate+0x1c0>
      unlink(file);
    1e1a:	fb840513          	addi	a0,s0,-72
    1e1e:	00002097          	auipc	ra,0x2
    1e22:	384080e7          	jalr	900(ra) # 41a2 <unlink>
      unlink(file);
    1e26:	fb840513          	addi	a0,s0,-72
    1e2a:	00002097          	auipc	ra,0x2
    1e2e:	378080e7          	jalr	888(ra) # 41a2 <unlink>
      unlink(file);
    1e32:	fb840513          	addi	a0,s0,-72
    1e36:	00002097          	auipc	ra,0x2
    1e3a:	36c080e7          	jalr	876(ra) # 41a2 <unlink>
      unlink(file);
    1e3e:	fb840513          	addi	a0,s0,-72
    1e42:	00002097          	auipc	ra,0x2
    1e46:	360080e7          	jalr	864(ra) # 41a2 <unlink>
    1e4a:	bf59                	j	1de0 <concreate+0x218>
      exit(0);
    1e4c:	4501                	li	a0,0
    1e4e:	00002097          	auipc	ra,0x2
    1e52:	304080e7          	jalr	772(ra) # 4152 <exit>
  }

  printf("concreate ok\n");
    1e56:	00003517          	auipc	a0,0x3
    1e5a:	43250513          	addi	a0,a0,1074 # 5288 <malloc+0xce0>
    1e5e:	00002097          	auipc	ra,0x2
    1e62:	68c080e7          	jalr	1676(ra) # 44ea <printf>
}
    1e66:	70e6                	ld	ra,120(sp)
    1e68:	7446                	ld	s0,112(sp)
    1e6a:	74a6                	ld	s1,104(sp)
    1e6c:	7906                	ld	s2,96(sp)
    1e6e:	69e6                	ld	s3,88(sp)
    1e70:	6a46                	ld	s4,80(sp)
    1e72:	6aa6                	ld	s5,72(sp)
    1e74:	6109                	addi	sp,sp,128
    1e76:	8082                	ret
      close(fd);
    1e78:	00002097          	auipc	ra,0x2
    1e7c:	302080e7          	jalr	770(ra) # 417a <close>
    if(pid == 0)
    1e80:	b3f5                	j	1c6c <concreate+0xa4>
      close(fd);
    1e82:	00002097          	auipc	ra,0x2
    1e86:	2f8080e7          	jalr	760(ra) # 417a <close>
      wait(0);
    1e8a:	4501                	li	a0,0
    1e8c:	00002097          	auipc	ra,0x2
    1e90:	2ce080e7          	jalr	718(ra) # 415a <wait>
  for(i = 0; i < N; i++){
    1e94:	2485                	addiw	s1,s1,1
    1e96:	df2480e3          	beq	s1,s2,1c76 <concreate+0xae>
    file[1] = '0' + i;
    1e9a:	0304879b          	addiw	a5,s1,48
    1e9e:	faf40ca3          	sb	a5,-71(s0)
    unlink(file);
    1ea2:	fb840513          	addi	a0,s0,-72
    1ea6:	00002097          	auipc	ra,0x2
    1eaa:	2fc080e7          	jalr	764(ra) # 41a2 <unlink>
    pid = fork();
    1eae:	00002097          	auipc	ra,0x2
    1eb2:	29c080e7          	jalr	668(ra) # 414a <fork>
    if(pid && (i % 3) == 1){
    1eb6:	d60502e3          	beqz	a0,1c1a <concreate+0x52>
    1eba:	0344e7bb          	remw	a5,s1,s4
    1ebe:	d53786e3          	beq	a5,s3,1c0a <concreate+0x42>
      fd = open(file, O_CREATE | O_RDWR);
    1ec2:	20200593          	li	a1,514
    1ec6:	fb840513          	addi	a0,s0,-72
    1eca:	00002097          	auipc	ra,0x2
    1ece:	2c8080e7          	jalr	712(ra) # 4192 <open>
      if(fd < 0){
    1ed2:	fa0558e3          	bgez	a0,1e82 <concreate+0x2ba>
    1ed6:	b395                	j	1c3a <concreate+0x72>

0000000000001ed8 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1ed8:	711d                	addi	sp,sp,-96
    1eda:	ec86                	sd	ra,88(sp)
    1edc:	e8a2                	sd	s0,80(sp)
    1ede:	e4a6                	sd	s1,72(sp)
    1ee0:	e0ca                	sd	s2,64(sp)
    1ee2:	fc4e                	sd	s3,56(sp)
    1ee4:	f852                	sd	s4,48(sp)
    1ee6:	f456                	sd	s5,40(sp)
    1ee8:	f05a                	sd	s6,32(sp)
    1eea:	ec5e                	sd	s7,24(sp)
    1eec:	e862                	sd	s8,16(sp)
    1eee:	e466                	sd	s9,8(sp)
    1ef0:	1080                	addi	s0,sp,96
  int pid, i;

  printf("linkunlink test\n");
    1ef2:	00003517          	auipc	a0,0x3
    1ef6:	3a650513          	addi	a0,a0,934 # 5298 <malloc+0xcf0>
    1efa:	00002097          	auipc	ra,0x2
    1efe:	5f0080e7          	jalr	1520(ra) # 44ea <printf>

  unlink("x");
    1f02:	00003517          	auipc	a0,0x3
    1f06:	d6650513          	addi	a0,a0,-666 # 4c68 <malloc+0x6c0>
    1f0a:	00002097          	auipc	ra,0x2
    1f0e:	298080e7          	jalr	664(ra) # 41a2 <unlink>
  pid = fork();
    1f12:	00002097          	auipc	ra,0x2
    1f16:	238080e7          	jalr	568(ra) # 414a <fork>
  if(pid < 0){
    1f1a:	02054b63          	bltz	a0,1f50 <linkunlink+0x78>
    1f1e:	8c2a                	mv	s8,a0
    printf("fork failed\n");
    exit(-1);
  }

  unsigned int x = (pid ? 1 : 97);
    1f20:	4c85                	li	s9,1
    1f22:	e119                	bnez	a0,1f28 <linkunlink+0x50>
    1f24:	06100c93          	li	s9,97
    1f28:	06400493          	li	s1,100
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    1f2c:	41c659b7          	lui	s3,0x41c65
    1f30:	e6d9899b          	addiw	s3,s3,-403
    1f34:	690d                	lui	s2,0x3
    1f36:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1f3a:	4a0d                	li	s4,3
      close(open("x", O_RDWR | O_CREATE));
    } else if((x % 3) == 1){
    1f3c:	4b05                	li	s6,1
      link("cat", "x");
    } else {
      unlink("x");
    1f3e:	00003a97          	auipc	s5,0x3
    1f42:	d2aa8a93          	addi	s5,s5,-726 # 4c68 <malloc+0x6c0>
      link("cat", "x");
    1f46:	00003b97          	auipc	s7,0x3
    1f4a:	36ab8b93          	addi	s7,s7,874 # 52b0 <malloc+0xd08>
    1f4e:	a089                	j	1f90 <linkunlink+0xb8>
    printf("fork failed\n");
    1f50:	00003517          	auipc	a0,0x3
    1f54:	80850513          	addi	a0,a0,-2040 # 4758 <malloc+0x1b0>
    1f58:	00002097          	auipc	ra,0x2
    1f5c:	592080e7          	jalr	1426(ra) # 44ea <printf>
    exit(-1);
    1f60:	557d                	li	a0,-1
    1f62:	00002097          	auipc	ra,0x2
    1f66:	1f0080e7          	jalr	496(ra) # 4152 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1f6a:	20200593          	li	a1,514
    1f6e:	8556                	mv	a0,s5
    1f70:	00002097          	auipc	ra,0x2
    1f74:	222080e7          	jalr	546(ra) # 4192 <open>
    1f78:	00002097          	auipc	ra,0x2
    1f7c:	202080e7          	jalr	514(ra) # 417a <close>
    1f80:	a031                	j	1f8c <linkunlink+0xb4>
      unlink("x");
    1f82:	8556                	mv	a0,s5
    1f84:	00002097          	auipc	ra,0x2
    1f88:	21e080e7          	jalr	542(ra) # 41a2 <unlink>
  for(i = 0; i < 100; i++){
    1f8c:	34fd                	addiw	s1,s1,-1
    1f8e:	c09d                	beqz	s1,1fb4 <linkunlink+0xdc>
    x = x * 1103515245 + 12345;
    1f90:	033c87bb          	mulw	a5,s9,s3
    1f94:	012787bb          	addw	a5,a5,s2
    1f98:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1f9c:	0347f7bb          	remuw	a5,a5,s4
    1fa0:	d7e9                	beqz	a5,1f6a <linkunlink+0x92>
    } else if((x % 3) == 1){
    1fa2:	ff6790e3          	bne	a5,s6,1f82 <linkunlink+0xaa>
      link("cat", "x");
    1fa6:	85d6                	mv	a1,s5
    1fa8:	855e                	mv	a0,s7
    1faa:	00002097          	auipc	ra,0x2
    1fae:	208080e7          	jalr	520(ra) # 41b2 <link>
    1fb2:	bfe9                	j	1f8c <linkunlink+0xb4>
    }
  }

  if(pid)
    1fb4:	020c0c63          	beqz	s8,1fec <linkunlink+0x114>
    wait(0);
    1fb8:	4501                	li	a0,0
    1fba:	00002097          	auipc	ra,0x2
    1fbe:	1a0080e7          	jalr	416(ra) # 415a <wait>
  else
    exit(0);

  printf("linkunlink ok\n");
    1fc2:	00003517          	auipc	a0,0x3
    1fc6:	2f650513          	addi	a0,a0,758 # 52b8 <malloc+0xd10>
    1fca:	00002097          	auipc	ra,0x2
    1fce:	520080e7          	jalr	1312(ra) # 44ea <printf>
}
    1fd2:	60e6                	ld	ra,88(sp)
    1fd4:	6446                	ld	s0,80(sp)
    1fd6:	64a6                	ld	s1,72(sp)
    1fd8:	6906                	ld	s2,64(sp)
    1fda:	79e2                	ld	s3,56(sp)
    1fdc:	7a42                	ld	s4,48(sp)
    1fde:	7aa2                	ld	s5,40(sp)
    1fe0:	7b02                	ld	s6,32(sp)
    1fe2:	6be2                	ld	s7,24(sp)
    1fe4:	6c42                	ld	s8,16(sp)
    1fe6:	6ca2                	ld	s9,8(sp)
    1fe8:	6125                	addi	sp,sp,96
    1fea:	8082                	ret
    exit(0);
    1fec:	4501                	li	a0,0
    1fee:	00002097          	auipc	ra,0x2
    1ff2:	164080e7          	jalr	356(ra) # 4152 <exit>

0000000000001ff6 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1ff6:	715d                	addi	sp,sp,-80
    1ff8:	e486                	sd	ra,72(sp)
    1ffa:	e0a2                	sd	s0,64(sp)
    1ffc:	fc26                	sd	s1,56(sp)
    1ffe:	f84a                	sd	s2,48(sp)
    2000:	f44e                	sd	s3,40(sp)
    2002:	f052                	sd	s4,32(sp)
    2004:	ec56                	sd	s5,24(sp)
    2006:	0880                	addi	s0,sp,80
  enum { N = 500 };
  int i, fd;
  char name[10];

  printf("bigdir test\n");
    2008:	00003517          	auipc	a0,0x3
    200c:	2c050513          	addi	a0,a0,704 # 52c8 <malloc+0xd20>
    2010:	00002097          	auipc	ra,0x2
    2014:	4da080e7          	jalr	1242(ra) # 44ea <printf>
  unlink("bd");
    2018:	00003517          	auipc	a0,0x3
    201c:	2c050513          	addi	a0,a0,704 # 52d8 <malloc+0xd30>
    2020:	00002097          	auipc	ra,0x2
    2024:	182080e7          	jalr	386(ra) # 41a2 <unlink>

  fd = open("bd", O_CREATE);
    2028:	20000593          	li	a1,512
    202c:	00003517          	auipc	a0,0x3
    2030:	2ac50513          	addi	a0,a0,684 # 52d8 <malloc+0xd30>
    2034:	00002097          	auipc	ra,0x2
    2038:	15e080e7          	jalr	350(ra) # 4192 <open>
  if(fd < 0){
    203c:	0e054063          	bltz	a0,211c <bigdir+0x126>
    printf("bigdir create failed\n");
    exit(-1);
  }
  close(fd);
    2040:	00002097          	auipc	ra,0x2
    2044:	13a080e7          	jalr	314(ra) # 417a <close>

  for(i = 0; i < N; i++){
    2048:	4901                	li	s2,0
    name[0] = 'x';
    204a:	07800a13          	li	s4,120
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(link("bd", name) != 0){
    204e:	00003997          	auipc	s3,0x3
    2052:	28a98993          	addi	s3,s3,650 # 52d8 <malloc+0xd30>
  for(i = 0; i < N; i++){
    2056:	1f400a93          	li	s5,500
    name[0] = 'x';
    205a:	fb440823          	sb	s4,-80(s0)
    name[1] = '0' + (i / 64);
    205e:	41f9579b          	sraiw	a5,s2,0x1f
    2062:	01a7d71b          	srliw	a4,a5,0x1a
    2066:	012707bb          	addw	a5,a4,s2
    206a:	4067d69b          	sraiw	a3,a5,0x6
    206e:	0306869b          	addiw	a3,a3,48
    2072:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    2076:	03f7f793          	andi	a5,a5,63
    207a:	9f99                	subw	a5,a5,a4
    207c:	0307879b          	addiw	a5,a5,48
    2080:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    2084:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    2088:	fb040593          	addi	a1,s0,-80
    208c:	854e                	mv	a0,s3
    208e:	00002097          	auipc	ra,0x2
    2092:	124080e7          	jalr	292(ra) # 41b2 <link>
    2096:	84aa                	mv	s1,a0
    2098:	ed59                	bnez	a0,2136 <bigdir+0x140>
  for(i = 0; i < N; i++){
    209a:	2905                	addiw	s2,s2,1
    209c:	fb591fe3          	bne	s2,s5,205a <bigdir+0x64>
      printf("bigdir link failed\n");
      exit(-1);
    }
  }

  unlink("bd");
    20a0:	00003517          	auipc	a0,0x3
    20a4:	23850513          	addi	a0,a0,568 # 52d8 <malloc+0xd30>
    20a8:	00002097          	auipc	ra,0x2
    20ac:	0fa080e7          	jalr	250(ra) # 41a2 <unlink>
  for(i = 0; i < N; i++){
    name[0] = 'x';
    20b0:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    20b4:	1f400993          	li	s3,500
    name[0] = 'x';
    20b8:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    20bc:	41f4d79b          	sraiw	a5,s1,0x1f
    20c0:	01a7d71b          	srliw	a4,a5,0x1a
    20c4:	009707bb          	addw	a5,a4,s1
    20c8:	4067d69b          	sraiw	a3,a5,0x6
    20cc:	0306869b          	addiw	a3,a3,48
    20d0:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    20d4:	03f7f793          	andi	a5,a5,63
    20d8:	9f99                	subw	a5,a5,a4
    20da:	0307879b          	addiw	a5,a5,48
    20de:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    20e2:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    20e6:	fb040513          	addi	a0,s0,-80
    20ea:	00002097          	auipc	ra,0x2
    20ee:	0b8080e7          	jalr	184(ra) # 41a2 <unlink>
    20f2:	ed39                	bnez	a0,2150 <bigdir+0x15a>
  for(i = 0; i < N; i++){
    20f4:	2485                	addiw	s1,s1,1
    20f6:	fd3491e3          	bne	s1,s3,20b8 <bigdir+0xc2>
      printf("bigdir unlink failed");
      exit(-1);
    }
  }

  printf("bigdir ok\n");
    20fa:	00003517          	auipc	a0,0x3
    20fe:	22e50513          	addi	a0,a0,558 # 5328 <malloc+0xd80>
    2102:	00002097          	auipc	ra,0x2
    2106:	3e8080e7          	jalr	1000(ra) # 44ea <printf>
}
    210a:	60a6                	ld	ra,72(sp)
    210c:	6406                	ld	s0,64(sp)
    210e:	74e2                	ld	s1,56(sp)
    2110:	7942                	ld	s2,48(sp)
    2112:	79a2                	ld	s3,40(sp)
    2114:	7a02                	ld	s4,32(sp)
    2116:	6ae2                	ld	s5,24(sp)
    2118:	6161                	addi	sp,sp,80
    211a:	8082                	ret
    printf("bigdir create failed\n");
    211c:	00003517          	auipc	a0,0x3
    2120:	1c450513          	addi	a0,a0,452 # 52e0 <malloc+0xd38>
    2124:	00002097          	auipc	ra,0x2
    2128:	3c6080e7          	jalr	966(ra) # 44ea <printf>
    exit(-1);
    212c:	557d                	li	a0,-1
    212e:	00002097          	auipc	ra,0x2
    2132:	024080e7          	jalr	36(ra) # 4152 <exit>
      printf("bigdir link failed\n");
    2136:	00003517          	auipc	a0,0x3
    213a:	1c250513          	addi	a0,a0,450 # 52f8 <malloc+0xd50>
    213e:	00002097          	auipc	ra,0x2
    2142:	3ac080e7          	jalr	940(ra) # 44ea <printf>
      exit(-1);
    2146:	557d                	li	a0,-1
    2148:	00002097          	auipc	ra,0x2
    214c:	00a080e7          	jalr	10(ra) # 4152 <exit>
      printf("bigdir unlink failed");
    2150:	00003517          	auipc	a0,0x3
    2154:	1c050513          	addi	a0,a0,448 # 5310 <malloc+0xd68>
    2158:	00002097          	auipc	ra,0x2
    215c:	392080e7          	jalr	914(ra) # 44ea <printf>
      exit(-1);
    2160:	557d                	li	a0,-1
    2162:	00002097          	auipc	ra,0x2
    2166:	ff0080e7          	jalr	-16(ra) # 4152 <exit>

000000000000216a <subdir>:

void
subdir(void)
{
    216a:	1101                	addi	sp,sp,-32
    216c:	ec06                	sd	ra,24(sp)
    216e:	e822                	sd	s0,16(sp)
    2170:	e426                	sd	s1,8(sp)
    2172:	1000                	addi	s0,sp,32
  int fd, cc;

  printf("subdir test\n");
    2174:	00003517          	auipc	a0,0x3
    2178:	1c450513          	addi	a0,a0,452 # 5338 <malloc+0xd90>
    217c:	00002097          	auipc	ra,0x2
    2180:	36e080e7          	jalr	878(ra) # 44ea <printf>

  unlink("ff");
    2184:	00003517          	auipc	a0,0x3
    2188:	2dc50513          	addi	a0,a0,732 # 5460 <malloc+0xeb8>
    218c:	00002097          	auipc	ra,0x2
    2190:	016080e7          	jalr	22(ra) # 41a2 <unlink>
  if(mkdir("dd") != 0){
    2194:	00003517          	auipc	a0,0x3
    2198:	1b450513          	addi	a0,a0,436 # 5348 <malloc+0xda0>
    219c:	00002097          	auipc	ra,0x2
    21a0:	01e080e7          	jalr	30(ra) # 41ba <mkdir>
    21a4:	38051d63          	bnez	a0,253e <subdir+0x3d4>
    printf("subdir mkdir dd failed\n");
    exit(-1);
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    21a8:	20200593          	li	a1,514
    21ac:	00003517          	auipc	a0,0x3
    21b0:	1bc50513          	addi	a0,a0,444 # 5368 <malloc+0xdc0>
    21b4:	00002097          	auipc	ra,0x2
    21b8:	fde080e7          	jalr	-34(ra) # 4192 <open>
    21bc:	84aa                	mv	s1,a0
  if(fd < 0){
    21be:	38054d63          	bltz	a0,2558 <subdir+0x3ee>
    printf("create dd/ff failed\n");
    exit(-1);
  }
  write(fd, "ff", 2);
    21c2:	4609                	li	a2,2
    21c4:	00003597          	auipc	a1,0x3
    21c8:	29c58593          	addi	a1,a1,668 # 5460 <malloc+0xeb8>
    21cc:	00002097          	auipc	ra,0x2
    21d0:	fa6080e7          	jalr	-90(ra) # 4172 <write>
  close(fd);
    21d4:	8526                	mv	a0,s1
    21d6:	00002097          	auipc	ra,0x2
    21da:	fa4080e7          	jalr	-92(ra) # 417a <close>

  if(unlink("dd") >= 0){
    21de:	00003517          	auipc	a0,0x3
    21e2:	16a50513          	addi	a0,a0,362 # 5348 <malloc+0xda0>
    21e6:	00002097          	auipc	ra,0x2
    21ea:	fbc080e7          	jalr	-68(ra) # 41a2 <unlink>
    21ee:	38055263          	bgez	a0,2572 <subdir+0x408>
    printf("unlink dd (non-empty dir) succeeded!\n");
    exit(-1);
  }

  if(mkdir("/dd/dd") != 0){
    21f2:	00003517          	auipc	a0,0x3
    21f6:	1be50513          	addi	a0,a0,446 # 53b0 <malloc+0xe08>
    21fa:	00002097          	auipc	ra,0x2
    21fe:	fc0080e7          	jalr	-64(ra) # 41ba <mkdir>
    2202:	38051563          	bnez	a0,258c <subdir+0x422>
    printf("subdir mkdir dd/dd failed\n");
    exit(-1);
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2206:	20200593          	li	a1,514
    220a:	00003517          	auipc	a0,0x3
    220e:	1ce50513          	addi	a0,a0,462 # 53d8 <malloc+0xe30>
    2212:	00002097          	auipc	ra,0x2
    2216:	f80080e7          	jalr	-128(ra) # 4192 <open>
    221a:	84aa                	mv	s1,a0
  if(fd < 0){
    221c:	38054563          	bltz	a0,25a6 <subdir+0x43c>
    printf("create dd/dd/ff failed\n");
    exit(-1);
  }
  write(fd, "FF", 2);
    2220:	4609                	li	a2,2
    2222:	00003597          	auipc	a1,0x3
    2226:	1de58593          	addi	a1,a1,478 # 5400 <malloc+0xe58>
    222a:	00002097          	auipc	ra,0x2
    222e:	f48080e7          	jalr	-184(ra) # 4172 <write>
  close(fd);
    2232:	8526                	mv	a0,s1
    2234:	00002097          	auipc	ra,0x2
    2238:	f46080e7          	jalr	-186(ra) # 417a <close>

  fd = open("dd/dd/../ff", 0);
    223c:	4581                	li	a1,0
    223e:	00003517          	auipc	a0,0x3
    2242:	1ca50513          	addi	a0,a0,458 # 5408 <malloc+0xe60>
    2246:	00002097          	auipc	ra,0x2
    224a:	f4c080e7          	jalr	-180(ra) # 4192 <open>
    224e:	84aa                	mv	s1,a0
  if(fd < 0){
    2250:	36054863          	bltz	a0,25c0 <subdir+0x456>
    printf("open dd/dd/../ff failed\n");
    exit(-1);
  }
  cc = read(fd, buf, sizeof(buf));
    2254:	660d                	lui	a2,0x3
    2256:	00007597          	auipc	a1,0x7
    225a:	a3a58593          	addi	a1,a1,-1478 # 8c90 <buf>
    225e:	00002097          	auipc	ra,0x2
    2262:	f0c080e7          	jalr	-244(ra) # 416a <read>
  if(cc != 2 || buf[0] != 'f'){
    2266:	4789                	li	a5,2
    2268:	36f51963          	bne	a0,a5,25da <subdir+0x470>
    226c:	00007717          	auipc	a4,0x7
    2270:	a2474703          	lbu	a4,-1500(a4) # 8c90 <buf>
    2274:	06600793          	li	a5,102
    2278:	36f71163          	bne	a4,a5,25da <subdir+0x470>
    printf("dd/dd/../ff wrong content\n");
    exit(-1);
  }
  close(fd);
    227c:	8526                	mv	a0,s1
    227e:	00002097          	auipc	ra,0x2
    2282:	efc080e7          	jalr	-260(ra) # 417a <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2286:	00003597          	auipc	a1,0x3
    228a:	1d258593          	addi	a1,a1,466 # 5458 <malloc+0xeb0>
    228e:	00003517          	auipc	a0,0x3
    2292:	14a50513          	addi	a0,a0,330 # 53d8 <malloc+0xe30>
    2296:	00002097          	auipc	ra,0x2
    229a:	f1c080e7          	jalr	-228(ra) # 41b2 <link>
    229e:	34051b63          	bnez	a0,25f4 <subdir+0x48a>
    printf("link dd/dd/ff dd/dd/ffff failed\n");
    exit(-1);
  }

  if(unlink("dd/dd/ff") != 0){
    22a2:	00003517          	auipc	a0,0x3
    22a6:	13650513          	addi	a0,a0,310 # 53d8 <malloc+0xe30>
    22aa:	00002097          	auipc	ra,0x2
    22ae:	ef8080e7          	jalr	-264(ra) # 41a2 <unlink>
    22b2:	34051e63          	bnez	a0,260e <subdir+0x4a4>
    printf("unlink dd/dd/ff failed\n");
    exit(-1);
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    22b6:	4581                	li	a1,0
    22b8:	00003517          	auipc	a0,0x3
    22bc:	12050513          	addi	a0,a0,288 # 53d8 <malloc+0xe30>
    22c0:	00002097          	auipc	ra,0x2
    22c4:	ed2080e7          	jalr	-302(ra) # 4192 <open>
    22c8:	36055063          	bgez	a0,2628 <subdir+0x4be>
    printf("open (unlinked) dd/dd/ff succeeded\n");
    exit(-1);
  }

  if(chdir("dd") != 0){
    22cc:	00003517          	auipc	a0,0x3
    22d0:	07c50513          	addi	a0,a0,124 # 5348 <malloc+0xda0>
    22d4:	00002097          	auipc	ra,0x2
    22d8:	eee080e7          	jalr	-274(ra) # 41c2 <chdir>
    22dc:	36051363          	bnez	a0,2642 <subdir+0x4d8>
    printf("chdir dd failed\n");
    exit(-1);
  }
  if(chdir("dd/../../dd") != 0){
    22e0:	00003517          	auipc	a0,0x3
    22e4:	20850513          	addi	a0,a0,520 # 54e8 <malloc+0xf40>
    22e8:	00002097          	auipc	ra,0x2
    22ec:	eda080e7          	jalr	-294(ra) # 41c2 <chdir>
    22f0:	36051663          	bnez	a0,265c <subdir+0x4f2>
    printf("chdir dd/../../dd failed\n");
    exit(-1);
  }
  if(chdir("dd/../../../dd") != 0){
    22f4:	00003517          	auipc	a0,0x3
    22f8:	22450513          	addi	a0,a0,548 # 5518 <malloc+0xf70>
    22fc:	00002097          	auipc	ra,0x2
    2300:	ec6080e7          	jalr	-314(ra) # 41c2 <chdir>
    2304:	36051963          	bnez	a0,2676 <subdir+0x50c>
    printf("chdir dd/../../dd failed\n");
    exit(-1);
  }
  if(chdir("./..") != 0){
    2308:	00003517          	auipc	a0,0x3
    230c:	22050513          	addi	a0,a0,544 # 5528 <malloc+0xf80>
    2310:	00002097          	auipc	ra,0x2
    2314:	eb2080e7          	jalr	-334(ra) # 41c2 <chdir>
    2318:	36051c63          	bnez	a0,2690 <subdir+0x526>
    printf("chdir ./.. failed\n");
    exit(-1);
  }

  fd = open("dd/dd/ffff", 0);
    231c:	4581                	li	a1,0
    231e:	00003517          	auipc	a0,0x3
    2322:	13a50513          	addi	a0,a0,314 # 5458 <malloc+0xeb0>
    2326:	00002097          	auipc	ra,0x2
    232a:	e6c080e7          	jalr	-404(ra) # 4192 <open>
    232e:	84aa                	mv	s1,a0
  if(fd < 0){
    2330:	36054d63          	bltz	a0,26aa <subdir+0x540>
    printf("open dd/dd/ffff failed\n");
    exit(-1);
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    2334:	660d                	lui	a2,0x3
    2336:	00007597          	auipc	a1,0x7
    233a:	95a58593          	addi	a1,a1,-1702 # 8c90 <buf>
    233e:	00002097          	auipc	ra,0x2
    2342:	e2c080e7          	jalr	-468(ra) # 416a <read>
    2346:	4789                	li	a5,2
    2348:	36f51e63          	bne	a0,a5,26c4 <subdir+0x55a>
    printf("read dd/dd/ffff wrong len\n");
    exit(-1);
  }
  close(fd);
    234c:	8526                	mv	a0,s1
    234e:	00002097          	auipc	ra,0x2
    2352:	e2c080e7          	jalr	-468(ra) # 417a <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2356:	4581                	li	a1,0
    2358:	00003517          	auipc	a0,0x3
    235c:	08050513          	addi	a0,a0,128 # 53d8 <malloc+0xe30>
    2360:	00002097          	auipc	ra,0x2
    2364:	e32080e7          	jalr	-462(ra) # 4192 <open>
    2368:	36055b63          	bgez	a0,26de <subdir+0x574>
    printf("open (unlinked) dd/dd/ff succeeded!\n");
    exit(-1);
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    236c:	20200593          	li	a1,514
    2370:	00003517          	auipc	a0,0x3
    2374:	23850513          	addi	a0,a0,568 # 55a8 <malloc+0x1000>
    2378:	00002097          	auipc	ra,0x2
    237c:	e1a080e7          	jalr	-486(ra) # 4192 <open>
    2380:	36055c63          	bgez	a0,26f8 <subdir+0x58e>
    printf("create dd/ff/ff succeeded!\n");
    exit(-1);
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2384:	20200593          	li	a1,514
    2388:	00003517          	auipc	a0,0x3
    238c:	25050513          	addi	a0,a0,592 # 55d8 <malloc+0x1030>
    2390:	00002097          	auipc	ra,0x2
    2394:	e02080e7          	jalr	-510(ra) # 4192 <open>
    2398:	36055d63          	bgez	a0,2712 <subdir+0x5a8>
    printf("create dd/xx/ff succeeded!\n");
    exit(-1);
  }
  if(open("dd", O_CREATE) >= 0){
    239c:	20000593          	li	a1,512
    23a0:	00003517          	auipc	a0,0x3
    23a4:	fa850513          	addi	a0,a0,-88 # 5348 <malloc+0xda0>
    23a8:	00002097          	auipc	ra,0x2
    23ac:	dea080e7          	jalr	-534(ra) # 4192 <open>
    23b0:	36055e63          	bgez	a0,272c <subdir+0x5c2>
    printf("create dd succeeded!\n");
    exit(-1);
  }
  if(open("dd", O_RDWR) >= 0){
    23b4:	4589                	li	a1,2
    23b6:	00003517          	auipc	a0,0x3
    23ba:	f9250513          	addi	a0,a0,-110 # 5348 <malloc+0xda0>
    23be:	00002097          	auipc	ra,0x2
    23c2:	dd4080e7          	jalr	-556(ra) # 4192 <open>
    23c6:	38055063          	bgez	a0,2746 <subdir+0x5dc>
    printf("open dd rdwr succeeded!\n");
    exit(-1);
  }
  if(open("dd", O_WRONLY) >= 0){
    23ca:	4585                	li	a1,1
    23cc:	00003517          	auipc	a0,0x3
    23d0:	f7c50513          	addi	a0,a0,-132 # 5348 <malloc+0xda0>
    23d4:	00002097          	auipc	ra,0x2
    23d8:	dbe080e7          	jalr	-578(ra) # 4192 <open>
    23dc:	38055263          	bgez	a0,2760 <subdir+0x5f6>
    printf("open dd wronly succeeded!\n");
    exit(-1);
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    23e0:	00003597          	auipc	a1,0x3
    23e4:	28058593          	addi	a1,a1,640 # 5660 <malloc+0x10b8>
    23e8:	00003517          	auipc	a0,0x3
    23ec:	1c050513          	addi	a0,a0,448 # 55a8 <malloc+0x1000>
    23f0:	00002097          	auipc	ra,0x2
    23f4:	dc2080e7          	jalr	-574(ra) # 41b2 <link>
    23f8:	38050163          	beqz	a0,277a <subdir+0x610>
    printf("link dd/ff/ff dd/dd/xx succeeded!\n");
    exit(-1);
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    23fc:	00003597          	auipc	a1,0x3
    2400:	26458593          	addi	a1,a1,612 # 5660 <malloc+0x10b8>
    2404:	00003517          	auipc	a0,0x3
    2408:	1d450513          	addi	a0,a0,468 # 55d8 <malloc+0x1030>
    240c:	00002097          	auipc	ra,0x2
    2410:	da6080e7          	jalr	-602(ra) # 41b2 <link>
    2414:	38050063          	beqz	a0,2794 <subdir+0x62a>
    printf("link dd/xx/ff dd/dd/xx succeeded!\n");
    exit(-1);
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2418:	00003597          	auipc	a1,0x3
    241c:	04058593          	addi	a1,a1,64 # 5458 <malloc+0xeb0>
    2420:	00003517          	auipc	a0,0x3
    2424:	f4850513          	addi	a0,a0,-184 # 5368 <malloc+0xdc0>
    2428:	00002097          	auipc	ra,0x2
    242c:	d8a080e7          	jalr	-630(ra) # 41b2 <link>
    2430:	36050f63          	beqz	a0,27ae <subdir+0x644>
    printf("link dd/ff dd/dd/ffff succeeded!\n");
    exit(-1);
  }
  if(mkdir("dd/ff/ff") == 0){
    2434:	00003517          	auipc	a0,0x3
    2438:	17450513          	addi	a0,a0,372 # 55a8 <malloc+0x1000>
    243c:	00002097          	auipc	ra,0x2
    2440:	d7e080e7          	jalr	-642(ra) # 41ba <mkdir>
    2444:	38050263          	beqz	a0,27c8 <subdir+0x65e>
    printf("mkdir dd/ff/ff succeeded!\n");
    exit(-1);
  }
  if(mkdir("dd/xx/ff") == 0){
    2448:	00003517          	auipc	a0,0x3
    244c:	19050513          	addi	a0,a0,400 # 55d8 <malloc+0x1030>
    2450:	00002097          	auipc	ra,0x2
    2454:	d6a080e7          	jalr	-662(ra) # 41ba <mkdir>
    2458:	38050563          	beqz	a0,27e2 <subdir+0x678>
    printf("mkdir dd/xx/ff succeeded!\n");
    exit(-1);
  }
  if(mkdir("dd/dd/ffff") == 0){
    245c:	00003517          	auipc	a0,0x3
    2460:	ffc50513          	addi	a0,a0,-4 # 5458 <malloc+0xeb0>
    2464:	00002097          	auipc	ra,0x2
    2468:	d56080e7          	jalr	-682(ra) # 41ba <mkdir>
    246c:	38050863          	beqz	a0,27fc <subdir+0x692>
    printf("mkdir dd/dd/ffff succeeded!\n");
    exit(-1);
  }
  if(unlink("dd/xx/ff") == 0){
    2470:	00003517          	auipc	a0,0x3
    2474:	16850513          	addi	a0,a0,360 # 55d8 <malloc+0x1030>
    2478:	00002097          	auipc	ra,0x2
    247c:	d2a080e7          	jalr	-726(ra) # 41a2 <unlink>
    2480:	38050b63          	beqz	a0,2816 <subdir+0x6ac>
    printf("unlink dd/xx/ff succeeded!\n");
    exit(-1);
  }
  if(unlink("dd/ff/ff") == 0){
    2484:	00003517          	auipc	a0,0x3
    2488:	12450513          	addi	a0,a0,292 # 55a8 <malloc+0x1000>
    248c:	00002097          	auipc	ra,0x2
    2490:	d16080e7          	jalr	-746(ra) # 41a2 <unlink>
    2494:	38050e63          	beqz	a0,2830 <subdir+0x6c6>
    printf("unlink dd/ff/ff succeeded!\n");
    exit(-1);
  }
  if(chdir("dd/ff") == 0){
    2498:	00003517          	auipc	a0,0x3
    249c:	ed050513          	addi	a0,a0,-304 # 5368 <malloc+0xdc0>
    24a0:	00002097          	auipc	ra,0x2
    24a4:	d22080e7          	jalr	-734(ra) # 41c2 <chdir>
    24a8:	3a050163          	beqz	a0,284a <subdir+0x6e0>
    printf("chdir dd/ff succeeded!\n");
    exit(-1);
  }
  if(chdir("dd/xx") == 0){
    24ac:	00003517          	auipc	a0,0x3
    24b0:	2f450513          	addi	a0,a0,756 # 57a0 <malloc+0x11f8>
    24b4:	00002097          	auipc	ra,0x2
    24b8:	d0e080e7          	jalr	-754(ra) # 41c2 <chdir>
    24bc:	3a050463          	beqz	a0,2864 <subdir+0x6fa>
    printf("chdir dd/xx succeeded!\n");
    exit(-1);
  }

  if(unlink("dd/dd/ffff") != 0){
    24c0:	00003517          	auipc	a0,0x3
    24c4:	f9850513          	addi	a0,a0,-104 # 5458 <malloc+0xeb0>
    24c8:	00002097          	auipc	ra,0x2
    24cc:	cda080e7          	jalr	-806(ra) # 41a2 <unlink>
    24d0:	3a051763          	bnez	a0,287e <subdir+0x714>
    printf("unlink dd/dd/ff failed\n");
    exit(-1);
  }
  if(unlink("dd/ff") != 0){
    24d4:	00003517          	auipc	a0,0x3
    24d8:	e9450513          	addi	a0,a0,-364 # 5368 <malloc+0xdc0>
    24dc:	00002097          	auipc	ra,0x2
    24e0:	cc6080e7          	jalr	-826(ra) # 41a2 <unlink>
    24e4:	3a051a63          	bnez	a0,2898 <subdir+0x72e>
    printf("unlink dd/ff failed\n");
    exit(-1);
  }
  if(unlink("dd") == 0){
    24e8:	00003517          	auipc	a0,0x3
    24ec:	e6050513          	addi	a0,a0,-416 # 5348 <malloc+0xda0>
    24f0:	00002097          	auipc	ra,0x2
    24f4:	cb2080e7          	jalr	-846(ra) # 41a2 <unlink>
    24f8:	3a050d63          	beqz	a0,28b2 <subdir+0x748>
    printf("unlink non-empty dd succeeded!\n");
    exit(-1);
  }
  if(unlink("dd/dd") < 0){
    24fc:	00003517          	auipc	a0,0x3
    2500:	2fc50513          	addi	a0,a0,764 # 57f8 <malloc+0x1250>
    2504:	00002097          	auipc	ra,0x2
    2508:	c9e080e7          	jalr	-866(ra) # 41a2 <unlink>
    250c:	3c054063          	bltz	a0,28cc <subdir+0x762>
    printf("unlink dd/dd failed\n");
    exit(-1);
  }
  if(unlink("dd") < 0){
    2510:	00003517          	auipc	a0,0x3
    2514:	e3850513          	addi	a0,a0,-456 # 5348 <malloc+0xda0>
    2518:	00002097          	auipc	ra,0x2
    251c:	c8a080e7          	jalr	-886(ra) # 41a2 <unlink>
    2520:	3c054363          	bltz	a0,28e6 <subdir+0x77c>
    printf("unlink dd failed\n");
    exit(-1);
  }

  printf("subdir ok\n");
    2524:	00003517          	auipc	a0,0x3
    2528:	30c50513          	addi	a0,a0,780 # 5830 <malloc+0x1288>
    252c:	00002097          	auipc	ra,0x2
    2530:	fbe080e7          	jalr	-66(ra) # 44ea <printf>
}
    2534:	60e2                	ld	ra,24(sp)
    2536:	6442                	ld	s0,16(sp)
    2538:	64a2                	ld	s1,8(sp)
    253a:	6105                	addi	sp,sp,32
    253c:	8082                	ret
    printf("subdir mkdir dd failed\n");
    253e:	00003517          	auipc	a0,0x3
    2542:	e1250513          	addi	a0,a0,-494 # 5350 <malloc+0xda8>
    2546:	00002097          	auipc	ra,0x2
    254a:	fa4080e7          	jalr	-92(ra) # 44ea <printf>
    exit(-1);
    254e:	557d                	li	a0,-1
    2550:	00002097          	auipc	ra,0x2
    2554:	c02080e7          	jalr	-1022(ra) # 4152 <exit>
    printf("create dd/ff failed\n");
    2558:	00003517          	auipc	a0,0x3
    255c:	e1850513          	addi	a0,a0,-488 # 5370 <malloc+0xdc8>
    2560:	00002097          	auipc	ra,0x2
    2564:	f8a080e7          	jalr	-118(ra) # 44ea <printf>
    exit(-1);
    2568:	557d                	li	a0,-1
    256a:	00002097          	auipc	ra,0x2
    256e:	be8080e7          	jalr	-1048(ra) # 4152 <exit>
    printf("unlink dd (non-empty dir) succeeded!\n");
    2572:	00003517          	auipc	a0,0x3
    2576:	e1650513          	addi	a0,a0,-490 # 5388 <malloc+0xde0>
    257a:	00002097          	auipc	ra,0x2
    257e:	f70080e7          	jalr	-144(ra) # 44ea <printf>
    exit(-1);
    2582:	557d                	li	a0,-1
    2584:	00002097          	auipc	ra,0x2
    2588:	bce080e7          	jalr	-1074(ra) # 4152 <exit>
    printf("subdir mkdir dd/dd failed\n");
    258c:	00003517          	auipc	a0,0x3
    2590:	e2c50513          	addi	a0,a0,-468 # 53b8 <malloc+0xe10>
    2594:	00002097          	auipc	ra,0x2
    2598:	f56080e7          	jalr	-170(ra) # 44ea <printf>
    exit(-1);
    259c:	557d                	li	a0,-1
    259e:	00002097          	auipc	ra,0x2
    25a2:	bb4080e7          	jalr	-1100(ra) # 4152 <exit>
    printf("create dd/dd/ff failed\n");
    25a6:	00003517          	auipc	a0,0x3
    25aa:	e4250513          	addi	a0,a0,-446 # 53e8 <malloc+0xe40>
    25ae:	00002097          	auipc	ra,0x2
    25b2:	f3c080e7          	jalr	-196(ra) # 44ea <printf>
    exit(-1);
    25b6:	557d                	li	a0,-1
    25b8:	00002097          	auipc	ra,0x2
    25bc:	b9a080e7          	jalr	-1126(ra) # 4152 <exit>
    printf("open dd/dd/../ff failed\n");
    25c0:	00003517          	auipc	a0,0x3
    25c4:	e5850513          	addi	a0,a0,-424 # 5418 <malloc+0xe70>
    25c8:	00002097          	auipc	ra,0x2
    25cc:	f22080e7          	jalr	-222(ra) # 44ea <printf>
    exit(-1);
    25d0:	557d                	li	a0,-1
    25d2:	00002097          	auipc	ra,0x2
    25d6:	b80080e7          	jalr	-1152(ra) # 4152 <exit>
    printf("dd/dd/../ff wrong content\n");
    25da:	00003517          	auipc	a0,0x3
    25de:	e5e50513          	addi	a0,a0,-418 # 5438 <malloc+0xe90>
    25e2:	00002097          	auipc	ra,0x2
    25e6:	f08080e7          	jalr	-248(ra) # 44ea <printf>
    exit(-1);
    25ea:	557d                	li	a0,-1
    25ec:	00002097          	auipc	ra,0x2
    25f0:	b66080e7          	jalr	-1178(ra) # 4152 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n");
    25f4:	00003517          	auipc	a0,0x3
    25f8:	e7450513          	addi	a0,a0,-396 # 5468 <malloc+0xec0>
    25fc:	00002097          	auipc	ra,0x2
    2600:	eee080e7          	jalr	-274(ra) # 44ea <printf>
    exit(-1);
    2604:	557d                	li	a0,-1
    2606:	00002097          	auipc	ra,0x2
    260a:	b4c080e7          	jalr	-1204(ra) # 4152 <exit>
    printf("unlink dd/dd/ff failed\n");
    260e:	00003517          	auipc	a0,0x3
    2612:	e8250513          	addi	a0,a0,-382 # 5490 <malloc+0xee8>
    2616:	00002097          	auipc	ra,0x2
    261a:	ed4080e7          	jalr	-300(ra) # 44ea <printf>
    exit(-1);
    261e:	557d                	li	a0,-1
    2620:	00002097          	auipc	ra,0x2
    2624:	b32080e7          	jalr	-1230(ra) # 4152 <exit>
    printf("open (unlinked) dd/dd/ff succeeded\n");
    2628:	00003517          	auipc	a0,0x3
    262c:	e8050513          	addi	a0,a0,-384 # 54a8 <malloc+0xf00>
    2630:	00002097          	auipc	ra,0x2
    2634:	eba080e7          	jalr	-326(ra) # 44ea <printf>
    exit(-1);
    2638:	557d                	li	a0,-1
    263a:	00002097          	auipc	ra,0x2
    263e:	b18080e7          	jalr	-1256(ra) # 4152 <exit>
    printf("chdir dd failed\n");
    2642:	00003517          	auipc	a0,0x3
    2646:	e8e50513          	addi	a0,a0,-370 # 54d0 <malloc+0xf28>
    264a:	00002097          	auipc	ra,0x2
    264e:	ea0080e7          	jalr	-352(ra) # 44ea <printf>
    exit(-1);
    2652:	557d                	li	a0,-1
    2654:	00002097          	auipc	ra,0x2
    2658:	afe080e7          	jalr	-1282(ra) # 4152 <exit>
    printf("chdir dd/../../dd failed\n");
    265c:	00003517          	auipc	a0,0x3
    2660:	e9c50513          	addi	a0,a0,-356 # 54f8 <malloc+0xf50>
    2664:	00002097          	auipc	ra,0x2
    2668:	e86080e7          	jalr	-378(ra) # 44ea <printf>
    exit(-1);
    266c:	557d                	li	a0,-1
    266e:	00002097          	auipc	ra,0x2
    2672:	ae4080e7          	jalr	-1308(ra) # 4152 <exit>
    printf("chdir dd/../../dd failed\n");
    2676:	00003517          	auipc	a0,0x3
    267a:	e8250513          	addi	a0,a0,-382 # 54f8 <malloc+0xf50>
    267e:	00002097          	auipc	ra,0x2
    2682:	e6c080e7          	jalr	-404(ra) # 44ea <printf>
    exit(-1);
    2686:	557d                	li	a0,-1
    2688:	00002097          	auipc	ra,0x2
    268c:	aca080e7          	jalr	-1334(ra) # 4152 <exit>
    printf("chdir ./.. failed\n");
    2690:	00003517          	auipc	a0,0x3
    2694:	ea050513          	addi	a0,a0,-352 # 5530 <malloc+0xf88>
    2698:	00002097          	auipc	ra,0x2
    269c:	e52080e7          	jalr	-430(ra) # 44ea <printf>
    exit(-1);
    26a0:	557d                	li	a0,-1
    26a2:	00002097          	auipc	ra,0x2
    26a6:	ab0080e7          	jalr	-1360(ra) # 4152 <exit>
    printf("open dd/dd/ffff failed\n");
    26aa:	00003517          	auipc	a0,0x3
    26ae:	e9e50513          	addi	a0,a0,-354 # 5548 <malloc+0xfa0>
    26b2:	00002097          	auipc	ra,0x2
    26b6:	e38080e7          	jalr	-456(ra) # 44ea <printf>
    exit(-1);
    26ba:	557d                	li	a0,-1
    26bc:	00002097          	auipc	ra,0x2
    26c0:	a96080e7          	jalr	-1386(ra) # 4152 <exit>
    printf("read dd/dd/ffff wrong len\n");
    26c4:	00003517          	auipc	a0,0x3
    26c8:	e9c50513          	addi	a0,a0,-356 # 5560 <malloc+0xfb8>
    26cc:	00002097          	auipc	ra,0x2
    26d0:	e1e080e7          	jalr	-482(ra) # 44ea <printf>
    exit(-1);
    26d4:	557d                	li	a0,-1
    26d6:	00002097          	auipc	ra,0x2
    26da:	a7c080e7          	jalr	-1412(ra) # 4152 <exit>
    printf("open (unlinked) dd/dd/ff succeeded!\n");
    26de:	00003517          	auipc	a0,0x3
    26e2:	ea250513          	addi	a0,a0,-350 # 5580 <malloc+0xfd8>
    26e6:	00002097          	auipc	ra,0x2
    26ea:	e04080e7          	jalr	-508(ra) # 44ea <printf>
    exit(-1);
    26ee:	557d                	li	a0,-1
    26f0:	00002097          	auipc	ra,0x2
    26f4:	a62080e7          	jalr	-1438(ra) # 4152 <exit>
    printf("create dd/ff/ff succeeded!\n");
    26f8:	00003517          	auipc	a0,0x3
    26fc:	ec050513          	addi	a0,a0,-320 # 55b8 <malloc+0x1010>
    2700:	00002097          	auipc	ra,0x2
    2704:	dea080e7          	jalr	-534(ra) # 44ea <printf>
    exit(-1);
    2708:	557d                	li	a0,-1
    270a:	00002097          	auipc	ra,0x2
    270e:	a48080e7          	jalr	-1464(ra) # 4152 <exit>
    printf("create dd/xx/ff succeeded!\n");
    2712:	00003517          	auipc	a0,0x3
    2716:	ed650513          	addi	a0,a0,-298 # 55e8 <malloc+0x1040>
    271a:	00002097          	auipc	ra,0x2
    271e:	dd0080e7          	jalr	-560(ra) # 44ea <printf>
    exit(-1);
    2722:	557d                	li	a0,-1
    2724:	00002097          	auipc	ra,0x2
    2728:	a2e080e7          	jalr	-1490(ra) # 4152 <exit>
    printf("create dd succeeded!\n");
    272c:	00003517          	auipc	a0,0x3
    2730:	edc50513          	addi	a0,a0,-292 # 5608 <malloc+0x1060>
    2734:	00002097          	auipc	ra,0x2
    2738:	db6080e7          	jalr	-586(ra) # 44ea <printf>
    exit(-1);
    273c:	557d                	li	a0,-1
    273e:	00002097          	auipc	ra,0x2
    2742:	a14080e7          	jalr	-1516(ra) # 4152 <exit>
    printf("open dd rdwr succeeded!\n");
    2746:	00003517          	auipc	a0,0x3
    274a:	eda50513          	addi	a0,a0,-294 # 5620 <malloc+0x1078>
    274e:	00002097          	auipc	ra,0x2
    2752:	d9c080e7          	jalr	-612(ra) # 44ea <printf>
    exit(-1);
    2756:	557d                	li	a0,-1
    2758:	00002097          	auipc	ra,0x2
    275c:	9fa080e7          	jalr	-1542(ra) # 4152 <exit>
    printf("open dd wronly succeeded!\n");
    2760:	00003517          	auipc	a0,0x3
    2764:	ee050513          	addi	a0,a0,-288 # 5640 <malloc+0x1098>
    2768:	00002097          	auipc	ra,0x2
    276c:	d82080e7          	jalr	-638(ra) # 44ea <printf>
    exit(-1);
    2770:	557d                	li	a0,-1
    2772:	00002097          	auipc	ra,0x2
    2776:	9e0080e7          	jalr	-1568(ra) # 4152 <exit>
    printf("link dd/ff/ff dd/dd/xx succeeded!\n");
    277a:	00003517          	auipc	a0,0x3
    277e:	ef650513          	addi	a0,a0,-266 # 5670 <malloc+0x10c8>
    2782:	00002097          	auipc	ra,0x2
    2786:	d68080e7          	jalr	-664(ra) # 44ea <printf>
    exit(-1);
    278a:	557d                	li	a0,-1
    278c:	00002097          	auipc	ra,0x2
    2790:	9c6080e7          	jalr	-1594(ra) # 4152 <exit>
    printf("link dd/xx/ff dd/dd/xx succeeded!\n");
    2794:	00003517          	auipc	a0,0x3
    2798:	f0450513          	addi	a0,a0,-252 # 5698 <malloc+0x10f0>
    279c:	00002097          	auipc	ra,0x2
    27a0:	d4e080e7          	jalr	-690(ra) # 44ea <printf>
    exit(-1);
    27a4:	557d                	li	a0,-1
    27a6:	00002097          	auipc	ra,0x2
    27aa:	9ac080e7          	jalr	-1620(ra) # 4152 <exit>
    printf("link dd/ff dd/dd/ffff succeeded!\n");
    27ae:	00003517          	auipc	a0,0x3
    27b2:	f1250513          	addi	a0,a0,-238 # 56c0 <malloc+0x1118>
    27b6:	00002097          	auipc	ra,0x2
    27ba:	d34080e7          	jalr	-716(ra) # 44ea <printf>
    exit(-1);
    27be:	557d                	li	a0,-1
    27c0:	00002097          	auipc	ra,0x2
    27c4:	992080e7          	jalr	-1646(ra) # 4152 <exit>
    printf("mkdir dd/ff/ff succeeded!\n");
    27c8:	00003517          	auipc	a0,0x3
    27cc:	f2050513          	addi	a0,a0,-224 # 56e8 <malloc+0x1140>
    27d0:	00002097          	auipc	ra,0x2
    27d4:	d1a080e7          	jalr	-742(ra) # 44ea <printf>
    exit(-1);
    27d8:	557d                	li	a0,-1
    27da:	00002097          	auipc	ra,0x2
    27de:	978080e7          	jalr	-1672(ra) # 4152 <exit>
    printf("mkdir dd/xx/ff succeeded!\n");
    27e2:	00003517          	auipc	a0,0x3
    27e6:	f2650513          	addi	a0,a0,-218 # 5708 <malloc+0x1160>
    27ea:	00002097          	auipc	ra,0x2
    27ee:	d00080e7          	jalr	-768(ra) # 44ea <printf>
    exit(-1);
    27f2:	557d                	li	a0,-1
    27f4:	00002097          	auipc	ra,0x2
    27f8:	95e080e7          	jalr	-1698(ra) # 4152 <exit>
    printf("mkdir dd/dd/ffff succeeded!\n");
    27fc:	00003517          	auipc	a0,0x3
    2800:	f2c50513          	addi	a0,a0,-212 # 5728 <malloc+0x1180>
    2804:	00002097          	auipc	ra,0x2
    2808:	ce6080e7          	jalr	-794(ra) # 44ea <printf>
    exit(-1);
    280c:	557d                	li	a0,-1
    280e:	00002097          	auipc	ra,0x2
    2812:	944080e7          	jalr	-1724(ra) # 4152 <exit>
    printf("unlink dd/xx/ff succeeded!\n");
    2816:	00003517          	auipc	a0,0x3
    281a:	f3250513          	addi	a0,a0,-206 # 5748 <malloc+0x11a0>
    281e:	00002097          	auipc	ra,0x2
    2822:	ccc080e7          	jalr	-820(ra) # 44ea <printf>
    exit(-1);
    2826:	557d                	li	a0,-1
    2828:	00002097          	auipc	ra,0x2
    282c:	92a080e7          	jalr	-1750(ra) # 4152 <exit>
    printf("unlink dd/ff/ff succeeded!\n");
    2830:	00003517          	auipc	a0,0x3
    2834:	f3850513          	addi	a0,a0,-200 # 5768 <malloc+0x11c0>
    2838:	00002097          	auipc	ra,0x2
    283c:	cb2080e7          	jalr	-846(ra) # 44ea <printf>
    exit(-1);
    2840:	557d                	li	a0,-1
    2842:	00002097          	auipc	ra,0x2
    2846:	910080e7          	jalr	-1776(ra) # 4152 <exit>
    printf("chdir dd/ff succeeded!\n");
    284a:	00003517          	auipc	a0,0x3
    284e:	f3e50513          	addi	a0,a0,-194 # 5788 <malloc+0x11e0>
    2852:	00002097          	auipc	ra,0x2
    2856:	c98080e7          	jalr	-872(ra) # 44ea <printf>
    exit(-1);
    285a:	557d                	li	a0,-1
    285c:	00002097          	auipc	ra,0x2
    2860:	8f6080e7          	jalr	-1802(ra) # 4152 <exit>
    printf("chdir dd/xx succeeded!\n");
    2864:	00003517          	auipc	a0,0x3
    2868:	f4450513          	addi	a0,a0,-188 # 57a8 <malloc+0x1200>
    286c:	00002097          	auipc	ra,0x2
    2870:	c7e080e7          	jalr	-898(ra) # 44ea <printf>
    exit(-1);
    2874:	557d                	li	a0,-1
    2876:	00002097          	auipc	ra,0x2
    287a:	8dc080e7          	jalr	-1828(ra) # 4152 <exit>
    printf("unlink dd/dd/ff failed\n");
    287e:	00003517          	auipc	a0,0x3
    2882:	c1250513          	addi	a0,a0,-1006 # 5490 <malloc+0xee8>
    2886:	00002097          	auipc	ra,0x2
    288a:	c64080e7          	jalr	-924(ra) # 44ea <printf>
    exit(-1);
    288e:	557d                	li	a0,-1
    2890:	00002097          	auipc	ra,0x2
    2894:	8c2080e7          	jalr	-1854(ra) # 4152 <exit>
    printf("unlink dd/ff failed\n");
    2898:	00003517          	auipc	a0,0x3
    289c:	f2850513          	addi	a0,a0,-216 # 57c0 <malloc+0x1218>
    28a0:	00002097          	auipc	ra,0x2
    28a4:	c4a080e7          	jalr	-950(ra) # 44ea <printf>
    exit(-1);
    28a8:	557d                	li	a0,-1
    28aa:	00002097          	auipc	ra,0x2
    28ae:	8a8080e7          	jalr	-1880(ra) # 4152 <exit>
    printf("unlink non-empty dd succeeded!\n");
    28b2:	00003517          	auipc	a0,0x3
    28b6:	f2650513          	addi	a0,a0,-218 # 57d8 <malloc+0x1230>
    28ba:	00002097          	auipc	ra,0x2
    28be:	c30080e7          	jalr	-976(ra) # 44ea <printf>
    exit(-1);
    28c2:	557d                	li	a0,-1
    28c4:	00002097          	auipc	ra,0x2
    28c8:	88e080e7          	jalr	-1906(ra) # 4152 <exit>
    printf("unlink dd/dd failed\n");
    28cc:	00003517          	auipc	a0,0x3
    28d0:	f3450513          	addi	a0,a0,-204 # 5800 <malloc+0x1258>
    28d4:	00002097          	auipc	ra,0x2
    28d8:	c16080e7          	jalr	-1002(ra) # 44ea <printf>
    exit(-1);
    28dc:	557d                	li	a0,-1
    28de:	00002097          	auipc	ra,0x2
    28e2:	874080e7          	jalr	-1932(ra) # 4152 <exit>
    printf("unlink dd failed\n");
    28e6:	00003517          	auipc	a0,0x3
    28ea:	f3250513          	addi	a0,a0,-206 # 5818 <malloc+0x1270>
    28ee:	00002097          	auipc	ra,0x2
    28f2:	bfc080e7          	jalr	-1028(ra) # 44ea <printf>
    exit(-1);
    28f6:	557d                	li	a0,-1
    28f8:	00002097          	auipc	ra,0x2
    28fc:	85a080e7          	jalr	-1958(ra) # 4152 <exit>

0000000000002900 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    2900:	7139                	addi	sp,sp,-64
    2902:	fc06                	sd	ra,56(sp)
    2904:	f822                	sd	s0,48(sp)
    2906:	f426                	sd	s1,40(sp)
    2908:	f04a                	sd	s2,32(sp)
    290a:	ec4e                	sd	s3,24(sp)
    290c:	e852                	sd	s4,16(sp)
    290e:	e456                	sd	s5,8(sp)
    2910:	e05a                	sd	s6,0(sp)
    2912:	0080                	addi	s0,sp,64
  int fd, sz;

  printf("bigwrite test\n");
    2914:	00003517          	auipc	a0,0x3
    2918:	f2c50513          	addi	a0,a0,-212 # 5840 <malloc+0x1298>
    291c:	00002097          	auipc	ra,0x2
    2920:	bce080e7          	jalr	-1074(ra) # 44ea <printf>

  unlink("bigwrite");
    2924:	00003517          	auipc	a0,0x3
    2928:	f2c50513          	addi	a0,a0,-212 # 5850 <malloc+0x12a8>
    292c:	00002097          	auipc	ra,0x2
    2930:	876080e7          	jalr	-1930(ra) # 41a2 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    2934:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2938:	00003a97          	auipc	s5,0x3
    293c:	f18a8a93          	addi	s5,s5,-232 # 5850 <malloc+0x12a8>
      printf("cannot create bigwrite\n");
      exit(-1);
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
    2940:	00006a17          	auipc	s4,0x6
    2944:	350a0a13          	addi	s4,s4,848 # 8c90 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    2948:	6b0d                	lui	s6,0x3
    294a:	1c9b0b13          	addi	s6,s6,457 # 31c9 <iref+0xbd>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    294e:	20200593          	li	a1,514
    2952:	8556                	mv	a0,s5
    2954:	00002097          	auipc	ra,0x2
    2958:	83e080e7          	jalr	-1986(ra) # 4192 <open>
    295c:	892a                	mv	s2,a0
    if(fd < 0){
    295e:	06054463          	bltz	a0,29c6 <bigwrite+0xc6>
      int cc = write(fd, buf, sz);
    2962:	8626                	mv	a2,s1
    2964:	85d2                	mv	a1,s4
    2966:	00002097          	auipc	ra,0x2
    296a:	80c080e7          	jalr	-2036(ra) # 4172 <write>
    296e:	89aa                	mv	s3,a0
      if(cc != sz){
    2970:	06a49a63          	bne	s1,a0,29e4 <bigwrite+0xe4>
      int cc = write(fd, buf, sz);
    2974:	8626                	mv	a2,s1
    2976:	85d2                	mv	a1,s4
    2978:	854a                	mv	a0,s2
    297a:	00001097          	auipc	ra,0x1
    297e:	7f8080e7          	jalr	2040(ra) # 4172 <write>
      if(cc != sz){
    2982:	04951f63          	bne	a0,s1,29e0 <bigwrite+0xe0>
        printf("write(%d) ret %d\n", sz, cc);
        exit(-1);
      }
    }
    close(fd);
    2986:	854a                	mv	a0,s2
    2988:	00001097          	auipc	ra,0x1
    298c:	7f2080e7          	jalr	2034(ra) # 417a <close>
    unlink("bigwrite");
    2990:	8556                	mv	a0,s5
    2992:	00002097          	auipc	ra,0x2
    2996:	810080e7          	jalr	-2032(ra) # 41a2 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    299a:	1d74849b          	addiw	s1,s1,471
    299e:	fb6498e3          	bne	s1,s6,294e <bigwrite+0x4e>
  }

  printf("bigwrite ok\n");
    29a2:	00003517          	auipc	a0,0x3
    29a6:	eee50513          	addi	a0,a0,-274 # 5890 <malloc+0x12e8>
    29aa:	00002097          	auipc	ra,0x2
    29ae:	b40080e7          	jalr	-1216(ra) # 44ea <printf>
}
    29b2:	70e2                	ld	ra,56(sp)
    29b4:	7442                	ld	s0,48(sp)
    29b6:	74a2                	ld	s1,40(sp)
    29b8:	7902                	ld	s2,32(sp)
    29ba:	69e2                	ld	s3,24(sp)
    29bc:	6a42                	ld	s4,16(sp)
    29be:	6aa2                	ld	s5,8(sp)
    29c0:	6b02                	ld	s6,0(sp)
    29c2:	6121                	addi	sp,sp,64
    29c4:	8082                	ret
      printf("cannot create bigwrite\n");
    29c6:	00003517          	auipc	a0,0x3
    29ca:	e9a50513          	addi	a0,a0,-358 # 5860 <malloc+0x12b8>
    29ce:	00002097          	auipc	ra,0x2
    29d2:	b1c080e7          	jalr	-1252(ra) # 44ea <printf>
      exit(-1);
    29d6:	557d                	li	a0,-1
    29d8:	00001097          	auipc	ra,0x1
    29dc:	77a080e7          	jalr	1914(ra) # 4152 <exit>
    29e0:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
    29e2:	89aa                	mv	s3,a0
        printf("write(%d) ret %d\n", sz, cc);
    29e4:	864e                	mv	a2,s3
    29e6:	85a6                	mv	a1,s1
    29e8:	00003517          	auipc	a0,0x3
    29ec:	e9050513          	addi	a0,a0,-368 # 5878 <malloc+0x12d0>
    29f0:	00002097          	auipc	ra,0x2
    29f4:	afa080e7          	jalr	-1286(ra) # 44ea <printf>
        exit(-1);
    29f8:	557d                	li	a0,-1
    29fa:	00001097          	auipc	ra,0x1
    29fe:	758080e7          	jalr	1880(ra) # 4152 <exit>

0000000000002a02 <bigfile>:

void
bigfile(void)
{
    2a02:	7179                	addi	sp,sp,-48
    2a04:	f406                	sd	ra,40(sp)
    2a06:	f022                	sd	s0,32(sp)
    2a08:	ec26                	sd	s1,24(sp)
    2a0a:	e84a                	sd	s2,16(sp)
    2a0c:	e44e                	sd	s3,8(sp)
    2a0e:	e052                	sd	s4,0(sp)
    2a10:	1800                	addi	s0,sp,48
  enum { N = 20, SZ=600 };
  int fd, i, total, cc;

  printf("bigfile test\n");
    2a12:	00003517          	auipc	a0,0x3
    2a16:	e8e50513          	addi	a0,a0,-370 # 58a0 <malloc+0x12f8>
    2a1a:	00002097          	auipc	ra,0x2
    2a1e:	ad0080e7          	jalr	-1328(ra) # 44ea <printf>

  unlink("bigfile");
    2a22:	00003517          	auipc	a0,0x3
    2a26:	e8e50513          	addi	a0,a0,-370 # 58b0 <malloc+0x1308>
    2a2a:	00001097          	auipc	ra,0x1
    2a2e:	778080e7          	jalr	1912(ra) # 41a2 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2a32:	20200593          	li	a1,514
    2a36:	00003517          	auipc	a0,0x3
    2a3a:	e7a50513          	addi	a0,a0,-390 # 58b0 <malloc+0x1308>
    2a3e:	00001097          	auipc	ra,0x1
    2a42:	754080e7          	jalr	1876(ra) # 4192 <open>
    2a46:	89aa                	mv	s3,a0
  if(fd < 0){
    printf("cannot create bigfile");
    exit(-1);
  }
  for(i = 0; i < N; i++){
    2a48:	4481                	li	s1,0
    memset(buf, i, SZ);
    2a4a:	00006917          	auipc	s2,0x6
    2a4e:	24690913          	addi	s2,s2,582 # 8c90 <buf>
  for(i = 0; i < N; i++){
    2a52:	4a51                	li	s4,20
  if(fd < 0){
    2a54:	0a054063          	bltz	a0,2af4 <bigfile+0xf2>
    memset(buf, i, SZ);
    2a58:	25800613          	li	a2,600
    2a5c:	85a6                	mv	a1,s1
    2a5e:	854a                	mv	a0,s2
    2a60:	00001097          	auipc	ra,0x1
    2a64:	56e080e7          	jalr	1390(ra) # 3fce <memset>
    if(write(fd, buf, SZ) != SZ){
    2a68:	25800613          	li	a2,600
    2a6c:	85ca                	mv	a1,s2
    2a6e:	854e                	mv	a0,s3
    2a70:	00001097          	auipc	ra,0x1
    2a74:	702080e7          	jalr	1794(ra) # 4172 <write>
    2a78:	25800793          	li	a5,600
    2a7c:	08f51963          	bne	a0,a5,2b0e <bigfile+0x10c>
  for(i = 0; i < N; i++){
    2a80:	2485                	addiw	s1,s1,1
    2a82:	fd449be3          	bne	s1,s4,2a58 <bigfile+0x56>
      printf("write bigfile failed\n");
      exit(-1);
    }
  }
  close(fd);
    2a86:	854e                	mv	a0,s3
    2a88:	00001097          	auipc	ra,0x1
    2a8c:	6f2080e7          	jalr	1778(ra) # 417a <close>

  fd = open("bigfile", 0);
    2a90:	4581                	li	a1,0
    2a92:	00003517          	auipc	a0,0x3
    2a96:	e1e50513          	addi	a0,a0,-482 # 58b0 <malloc+0x1308>
    2a9a:	00001097          	auipc	ra,0x1
    2a9e:	6f8080e7          	jalr	1784(ra) # 4192 <open>
    2aa2:	8a2a                	mv	s4,a0
  if(fd < 0){
    printf("cannot open bigfile\n");
    exit(-1);
  }
  total = 0;
    2aa4:	4981                	li	s3,0
  for(i = 0; ; i++){
    2aa6:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    2aa8:	00006917          	auipc	s2,0x6
    2aac:	1e890913          	addi	s2,s2,488 # 8c90 <buf>
  if(fd < 0){
    2ab0:	06054c63          	bltz	a0,2b28 <bigfile+0x126>
    cc = read(fd, buf, SZ/2);
    2ab4:	12c00613          	li	a2,300
    2ab8:	85ca                	mv	a1,s2
    2aba:	8552                	mv	a0,s4
    2abc:	00001097          	auipc	ra,0x1
    2ac0:	6ae080e7          	jalr	1710(ra) # 416a <read>
    if(cc < 0){
    2ac4:	06054f63          	bltz	a0,2b42 <bigfile+0x140>
      printf("read bigfile failed\n");
      exit(-1);
    }
    if(cc == 0)
    2ac8:	c561                	beqz	a0,2b90 <bigfile+0x18e>
      break;
    if(cc != SZ/2){
    2aca:	12c00793          	li	a5,300
    2ace:	08f51763          	bne	a0,a5,2b5c <bigfile+0x15a>
      printf("short read bigfile\n");
      exit(-1);
    }
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    2ad2:	01f4d79b          	srliw	a5,s1,0x1f
    2ad6:	9fa5                	addw	a5,a5,s1
    2ad8:	4017d79b          	sraiw	a5,a5,0x1
    2adc:	00094703          	lbu	a4,0(s2)
    2ae0:	08f71b63          	bne	a4,a5,2b76 <bigfile+0x174>
    2ae4:	12b94703          	lbu	a4,299(s2)
    2ae8:	08f71763          	bne	a4,a5,2b76 <bigfile+0x174>
      printf("read bigfile wrong data\n");
      exit(-1);
    }
    total += cc;
    2aec:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    2af0:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    2af2:	b7c9                	j	2ab4 <bigfile+0xb2>
    printf("cannot create bigfile");
    2af4:	00003517          	auipc	a0,0x3
    2af8:	dc450513          	addi	a0,a0,-572 # 58b8 <malloc+0x1310>
    2afc:	00002097          	auipc	ra,0x2
    2b00:	9ee080e7          	jalr	-1554(ra) # 44ea <printf>
    exit(-1);
    2b04:	557d                	li	a0,-1
    2b06:	00001097          	auipc	ra,0x1
    2b0a:	64c080e7          	jalr	1612(ra) # 4152 <exit>
      printf("write bigfile failed\n");
    2b0e:	00003517          	auipc	a0,0x3
    2b12:	dc250513          	addi	a0,a0,-574 # 58d0 <malloc+0x1328>
    2b16:	00002097          	auipc	ra,0x2
    2b1a:	9d4080e7          	jalr	-1580(ra) # 44ea <printf>
      exit(-1);
    2b1e:	557d                	li	a0,-1
    2b20:	00001097          	auipc	ra,0x1
    2b24:	632080e7          	jalr	1586(ra) # 4152 <exit>
    printf("cannot open bigfile\n");
    2b28:	00003517          	auipc	a0,0x3
    2b2c:	dc050513          	addi	a0,a0,-576 # 58e8 <malloc+0x1340>
    2b30:	00002097          	auipc	ra,0x2
    2b34:	9ba080e7          	jalr	-1606(ra) # 44ea <printf>
    exit(-1);
    2b38:	557d                	li	a0,-1
    2b3a:	00001097          	auipc	ra,0x1
    2b3e:	618080e7          	jalr	1560(ra) # 4152 <exit>
      printf("read bigfile failed\n");
    2b42:	00003517          	auipc	a0,0x3
    2b46:	dbe50513          	addi	a0,a0,-578 # 5900 <malloc+0x1358>
    2b4a:	00002097          	auipc	ra,0x2
    2b4e:	9a0080e7          	jalr	-1632(ra) # 44ea <printf>
      exit(-1);
    2b52:	557d                	li	a0,-1
    2b54:	00001097          	auipc	ra,0x1
    2b58:	5fe080e7          	jalr	1534(ra) # 4152 <exit>
      printf("short read bigfile\n");
    2b5c:	00003517          	auipc	a0,0x3
    2b60:	dbc50513          	addi	a0,a0,-580 # 5918 <malloc+0x1370>
    2b64:	00002097          	auipc	ra,0x2
    2b68:	986080e7          	jalr	-1658(ra) # 44ea <printf>
      exit(-1);
    2b6c:	557d                	li	a0,-1
    2b6e:	00001097          	auipc	ra,0x1
    2b72:	5e4080e7          	jalr	1508(ra) # 4152 <exit>
      printf("read bigfile wrong data\n");
    2b76:	00003517          	auipc	a0,0x3
    2b7a:	dba50513          	addi	a0,a0,-582 # 5930 <malloc+0x1388>
    2b7e:	00002097          	auipc	ra,0x2
    2b82:	96c080e7          	jalr	-1684(ra) # 44ea <printf>
      exit(-1);
    2b86:	557d                	li	a0,-1
    2b88:	00001097          	auipc	ra,0x1
    2b8c:	5ca080e7          	jalr	1482(ra) # 4152 <exit>
  }
  close(fd);
    2b90:	8552                	mv	a0,s4
    2b92:	00001097          	auipc	ra,0x1
    2b96:	5e8080e7          	jalr	1512(ra) # 417a <close>
  if(total != N*SZ){
    2b9a:	678d                	lui	a5,0x3
    2b9c:	ee078793          	addi	a5,a5,-288 # 2ee0 <dirfile+0x10>
    2ba0:	02f99a63          	bne	s3,a5,2bd4 <bigfile+0x1d2>
    printf("read bigfile wrong total\n");
    exit(-1);
  }
  unlink("bigfile");
    2ba4:	00003517          	auipc	a0,0x3
    2ba8:	d0c50513          	addi	a0,a0,-756 # 58b0 <malloc+0x1308>
    2bac:	00001097          	auipc	ra,0x1
    2bb0:	5f6080e7          	jalr	1526(ra) # 41a2 <unlink>

  printf("bigfile test ok\n");
    2bb4:	00003517          	auipc	a0,0x3
    2bb8:	dbc50513          	addi	a0,a0,-580 # 5970 <malloc+0x13c8>
    2bbc:	00002097          	auipc	ra,0x2
    2bc0:	92e080e7          	jalr	-1746(ra) # 44ea <printf>
}
    2bc4:	70a2                	ld	ra,40(sp)
    2bc6:	7402                	ld	s0,32(sp)
    2bc8:	64e2                	ld	s1,24(sp)
    2bca:	6942                	ld	s2,16(sp)
    2bcc:	69a2                	ld	s3,8(sp)
    2bce:	6a02                	ld	s4,0(sp)
    2bd0:	6145                	addi	sp,sp,48
    2bd2:	8082                	ret
    printf("read bigfile wrong total\n");
    2bd4:	00003517          	auipc	a0,0x3
    2bd8:	d7c50513          	addi	a0,a0,-644 # 5950 <malloc+0x13a8>
    2bdc:	00002097          	auipc	ra,0x2
    2be0:	90e080e7          	jalr	-1778(ra) # 44ea <printf>
    exit(-1);
    2be4:	557d                	li	a0,-1
    2be6:	00001097          	auipc	ra,0x1
    2bea:	56c080e7          	jalr	1388(ra) # 4152 <exit>

0000000000002bee <fourteen>:

void
fourteen(void)
{
    2bee:	1141                	addi	sp,sp,-16
    2bf0:	e406                	sd	ra,8(sp)
    2bf2:	e022                	sd	s0,0(sp)
    2bf4:	0800                	addi	s0,sp,16
  int fd;

  // DIRSIZ is 14.
  printf("fourteen test\n");
    2bf6:	00003517          	auipc	a0,0x3
    2bfa:	d9250513          	addi	a0,a0,-622 # 5988 <malloc+0x13e0>
    2bfe:	00002097          	auipc	ra,0x2
    2c02:	8ec080e7          	jalr	-1812(ra) # 44ea <printf>

  if(mkdir("12345678901234") != 0){
    2c06:	00003517          	auipc	a0,0x3
    2c0a:	f4250513          	addi	a0,a0,-190 # 5b48 <malloc+0x15a0>
    2c0e:	00001097          	auipc	ra,0x1
    2c12:	5ac080e7          	jalr	1452(ra) # 41ba <mkdir>
    2c16:	e559                	bnez	a0,2ca4 <fourteen+0xb6>
    printf("mkdir 12345678901234 failed\n");
    exit(-1);
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2c18:	00003517          	auipc	a0,0x3
    2c1c:	da050513          	addi	a0,a0,-608 # 59b8 <malloc+0x1410>
    2c20:	00001097          	auipc	ra,0x1
    2c24:	59a080e7          	jalr	1434(ra) # 41ba <mkdir>
    2c28:	e959                	bnez	a0,2cbe <fourteen+0xd0>
    printf("mkdir 12345678901234/123456789012345 failed\n");
    exit(-1);
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2c2a:	20000593          	li	a1,512
    2c2e:	00003517          	auipc	a0,0x3
    2c32:	dda50513          	addi	a0,a0,-550 # 5a08 <malloc+0x1460>
    2c36:	00001097          	auipc	ra,0x1
    2c3a:	55c080e7          	jalr	1372(ra) # 4192 <open>
  if(fd < 0){
    2c3e:	08054d63          	bltz	a0,2cd8 <fourteen+0xea>
    printf("create 123456789012345/123456789012345/123456789012345 failed\n");
    exit(-1);
  }
  close(fd);
    2c42:	00001097          	auipc	ra,0x1
    2c46:	538080e7          	jalr	1336(ra) # 417a <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2c4a:	4581                	li	a1,0
    2c4c:	00003517          	auipc	a0,0x3
    2c50:	e2c50513          	addi	a0,a0,-468 # 5a78 <malloc+0x14d0>
    2c54:	00001097          	auipc	ra,0x1
    2c58:	53e080e7          	jalr	1342(ra) # 4192 <open>
  if(fd < 0){
    2c5c:	08054b63          	bltz	a0,2cf2 <fourteen+0x104>
    printf("open 12345678901234/12345678901234/12345678901234 failed\n");
    exit(-1);
  }
  close(fd);
    2c60:	00001097          	auipc	ra,0x1
    2c64:	51a080e7          	jalr	1306(ra) # 417a <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2c68:	00003517          	auipc	a0,0x3
    2c6c:	e8050513          	addi	a0,a0,-384 # 5ae8 <malloc+0x1540>
    2c70:	00001097          	auipc	ra,0x1
    2c74:	54a080e7          	jalr	1354(ra) # 41ba <mkdir>
    2c78:	c951                	beqz	a0,2d0c <fourteen+0x11e>
    printf("mkdir 12345678901234/12345678901234 succeeded!\n");
    exit(-1);
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2c7a:	00003517          	auipc	a0,0x3
    2c7e:	ebe50513          	addi	a0,a0,-322 # 5b38 <malloc+0x1590>
    2c82:	00001097          	auipc	ra,0x1
    2c86:	538080e7          	jalr	1336(ra) # 41ba <mkdir>
    2c8a:	cd51                	beqz	a0,2d26 <fourteen+0x138>
    printf("mkdir 12345678901234/123456789012345 succeeded!\n");
    exit(-1);
  }

  printf("fourteen ok\n");
    2c8c:	00003517          	auipc	a0,0x3
    2c90:	f0450513          	addi	a0,a0,-252 # 5b90 <malloc+0x15e8>
    2c94:	00002097          	auipc	ra,0x2
    2c98:	856080e7          	jalr	-1962(ra) # 44ea <printf>
}
    2c9c:	60a2                	ld	ra,8(sp)
    2c9e:	6402                	ld	s0,0(sp)
    2ca0:	0141                	addi	sp,sp,16
    2ca2:	8082                	ret
    printf("mkdir 12345678901234 failed\n");
    2ca4:	00003517          	auipc	a0,0x3
    2ca8:	cf450513          	addi	a0,a0,-780 # 5998 <malloc+0x13f0>
    2cac:	00002097          	auipc	ra,0x2
    2cb0:	83e080e7          	jalr	-1986(ra) # 44ea <printf>
    exit(-1);
    2cb4:	557d                	li	a0,-1
    2cb6:	00001097          	auipc	ra,0x1
    2cba:	49c080e7          	jalr	1180(ra) # 4152 <exit>
    printf("mkdir 12345678901234/123456789012345 failed\n");
    2cbe:	00003517          	auipc	a0,0x3
    2cc2:	d1a50513          	addi	a0,a0,-742 # 59d8 <malloc+0x1430>
    2cc6:	00002097          	auipc	ra,0x2
    2cca:	824080e7          	jalr	-2012(ra) # 44ea <printf>
    exit(-1);
    2cce:	557d                	li	a0,-1
    2cd0:	00001097          	auipc	ra,0x1
    2cd4:	482080e7          	jalr	1154(ra) # 4152 <exit>
    printf("create 123456789012345/123456789012345/123456789012345 failed\n");
    2cd8:	00003517          	auipc	a0,0x3
    2cdc:	d6050513          	addi	a0,a0,-672 # 5a38 <malloc+0x1490>
    2ce0:	00002097          	auipc	ra,0x2
    2ce4:	80a080e7          	jalr	-2038(ra) # 44ea <printf>
    exit(-1);
    2ce8:	557d                	li	a0,-1
    2cea:	00001097          	auipc	ra,0x1
    2cee:	468080e7          	jalr	1128(ra) # 4152 <exit>
    printf("open 12345678901234/12345678901234/12345678901234 failed\n");
    2cf2:	00003517          	auipc	a0,0x3
    2cf6:	db650513          	addi	a0,a0,-586 # 5aa8 <malloc+0x1500>
    2cfa:	00001097          	auipc	ra,0x1
    2cfe:	7f0080e7          	jalr	2032(ra) # 44ea <printf>
    exit(-1);
    2d02:	557d                	li	a0,-1
    2d04:	00001097          	auipc	ra,0x1
    2d08:	44e080e7          	jalr	1102(ra) # 4152 <exit>
    printf("mkdir 12345678901234/12345678901234 succeeded!\n");
    2d0c:	00003517          	auipc	a0,0x3
    2d10:	dfc50513          	addi	a0,a0,-516 # 5b08 <malloc+0x1560>
    2d14:	00001097          	auipc	ra,0x1
    2d18:	7d6080e7          	jalr	2006(ra) # 44ea <printf>
    exit(-1);
    2d1c:	557d                	li	a0,-1
    2d1e:	00001097          	auipc	ra,0x1
    2d22:	434080e7          	jalr	1076(ra) # 4152 <exit>
    printf("mkdir 12345678901234/123456789012345 succeeded!\n");
    2d26:	00003517          	auipc	a0,0x3
    2d2a:	e3250513          	addi	a0,a0,-462 # 5b58 <malloc+0x15b0>
    2d2e:	00001097          	auipc	ra,0x1
    2d32:	7bc080e7          	jalr	1980(ra) # 44ea <printf>
    exit(-1);
    2d36:	557d                	li	a0,-1
    2d38:	00001097          	auipc	ra,0x1
    2d3c:	41a080e7          	jalr	1050(ra) # 4152 <exit>

0000000000002d40 <rmdot>:

void
rmdot(void)
{
    2d40:	1141                	addi	sp,sp,-16
    2d42:	e406                	sd	ra,8(sp)
    2d44:	e022                	sd	s0,0(sp)
    2d46:	0800                	addi	s0,sp,16
  printf("rmdot test\n");
    2d48:	00003517          	auipc	a0,0x3
    2d4c:	e5850513          	addi	a0,a0,-424 # 5ba0 <malloc+0x15f8>
    2d50:	00001097          	auipc	ra,0x1
    2d54:	79a080e7          	jalr	1946(ra) # 44ea <printf>
  if(mkdir("dots") != 0){
    2d58:	00003517          	auipc	a0,0x3
    2d5c:	e5850513          	addi	a0,a0,-424 # 5bb0 <malloc+0x1608>
    2d60:	00001097          	auipc	ra,0x1
    2d64:	45a080e7          	jalr	1114(ra) # 41ba <mkdir>
    2d68:	ed41                	bnez	a0,2e00 <rmdot+0xc0>
    printf("mkdir dots failed\n");
    exit(-1);
  }
  if(chdir("dots") != 0){
    2d6a:	00003517          	auipc	a0,0x3
    2d6e:	e4650513          	addi	a0,a0,-442 # 5bb0 <malloc+0x1608>
    2d72:	00001097          	auipc	ra,0x1
    2d76:	450080e7          	jalr	1104(ra) # 41c2 <chdir>
    2d7a:	e145                	bnez	a0,2e1a <rmdot+0xda>
    printf("chdir dots failed\n");
    exit(-1);
  }
  if(unlink(".") == 0){
    2d7c:	00002517          	auipc	a0,0x2
    2d80:	42450513          	addi	a0,a0,1060 # 51a0 <malloc+0xbf8>
    2d84:	00001097          	auipc	ra,0x1
    2d88:	41e080e7          	jalr	1054(ra) # 41a2 <unlink>
    2d8c:	c545                	beqz	a0,2e34 <rmdot+0xf4>
    printf("rm . worked!\n");
    exit(-1);
  }
  if(unlink("..") == 0){
    2d8e:	00002517          	auipc	a0,0x2
    2d92:	de250513          	addi	a0,a0,-542 # 4b70 <malloc+0x5c8>
    2d96:	00001097          	auipc	ra,0x1
    2d9a:	40c080e7          	jalr	1036(ra) # 41a2 <unlink>
    2d9e:	c945                	beqz	a0,2e4e <rmdot+0x10e>
    printf("rm .. worked!\n");
    exit(-1);
  }
  if(chdir("/") != 0){
    2da0:	00002517          	auipc	a0,0x2
    2da4:	98050513          	addi	a0,a0,-1664 # 4720 <malloc+0x178>
    2da8:	00001097          	auipc	ra,0x1
    2dac:	41a080e7          	jalr	1050(ra) # 41c2 <chdir>
    2db0:	ed45                	bnez	a0,2e68 <rmdot+0x128>
    printf("chdir / failed\n");
    exit(-1);
  }
  if(unlink("dots/.") == 0){
    2db2:	00003517          	auipc	a0,0x3
    2db6:	e5650513          	addi	a0,a0,-426 # 5c08 <malloc+0x1660>
    2dba:	00001097          	auipc	ra,0x1
    2dbe:	3e8080e7          	jalr	1000(ra) # 41a2 <unlink>
    2dc2:	c161                	beqz	a0,2e82 <rmdot+0x142>
    printf("unlink dots/. worked!\n");
    exit(-1);
  }
  if(unlink("dots/..") == 0){
    2dc4:	00003517          	auipc	a0,0x3
    2dc8:	e6450513          	addi	a0,a0,-412 # 5c28 <malloc+0x1680>
    2dcc:	00001097          	auipc	ra,0x1
    2dd0:	3d6080e7          	jalr	982(ra) # 41a2 <unlink>
    2dd4:	c561                	beqz	a0,2e9c <rmdot+0x15c>
    printf("unlink dots/.. worked!\n");
    exit(-1);
  }
  if(unlink("dots") != 0){
    2dd6:	00003517          	auipc	a0,0x3
    2dda:	dda50513          	addi	a0,a0,-550 # 5bb0 <malloc+0x1608>
    2dde:	00001097          	auipc	ra,0x1
    2de2:	3c4080e7          	jalr	964(ra) # 41a2 <unlink>
    2de6:	e961                	bnez	a0,2eb6 <rmdot+0x176>
    printf("unlink dots failed!\n");
    exit(-1);
  }
  printf("rmdot ok\n");
    2de8:	00003517          	auipc	a0,0x3
    2dec:	e7850513          	addi	a0,a0,-392 # 5c60 <malloc+0x16b8>
    2df0:	00001097          	auipc	ra,0x1
    2df4:	6fa080e7          	jalr	1786(ra) # 44ea <printf>
}
    2df8:	60a2                	ld	ra,8(sp)
    2dfa:	6402                	ld	s0,0(sp)
    2dfc:	0141                	addi	sp,sp,16
    2dfe:	8082                	ret
    printf("mkdir dots failed\n");
    2e00:	00003517          	auipc	a0,0x3
    2e04:	db850513          	addi	a0,a0,-584 # 5bb8 <malloc+0x1610>
    2e08:	00001097          	auipc	ra,0x1
    2e0c:	6e2080e7          	jalr	1762(ra) # 44ea <printf>
    exit(-1);
    2e10:	557d                	li	a0,-1
    2e12:	00001097          	auipc	ra,0x1
    2e16:	340080e7          	jalr	832(ra) # 4152 <exit>
    printf("chdir dots failed\n");
    2e1a:	00003517          	auipc	a0,0x3
    2e1e:	db650513          	addi	a0,a0,-586 # 5bd0 <malloc+0x1628>
    2e22:	00001097          	auipc	ra,0x1
    2e26:	6c8080e7          	jalr	1736(ra) # 44ea <printf>
    exit(-1);
    2e2a:	557d                	li	a0,-1
    2e2c:	00001097          	auipc	ra,0x1
    2e30:	326080e7          	jalr	806(ra) # 4152 <exit>
    printf("rm . worked!\n");
    2e34:	00003517          	auipc	a0,0x3
    2e38:	db450513          	addi	a0,a0,-588 # 5be8 <malloc+0x1640>
    2e3c:	00001097          	auipc	ra,0x1
    2e40:	6ae080e7          	jalr	1710(ra) # 44ea <printf>
    exit(-1);
    2e44:	557d                	li	a0,-1
    2e46:	00001097          	auipc	ra,0x1
    2e4a:	30c080e7          	jalr	780(ra) # 4152 <exit>
    printf("rm .. worked!\n");
    2e4e:	00003517          	auipc	a0,0x3
    2e52:	daa50513          	addi	a0,a0,-598 # 5bf8 <malloc+0x1650>
    2e56:	00001097          	auipc	ra,0x1
    2e5a:	694080e7          	jalr	1684(ra) # 44ea <printf>
    exit(-1);
    2e5e:	557d                	li	a0,-1
    2e60:	00001097          	auipc	ra,0x1
    2e64:	2f2080e7          	jalr	754(ra) # 4152 <exit>
    printf("chdir / failed\n");
    2e68:	00002517          	auipc	a0,0x2
    2e6c:	8c050513          	addi	a0,a0,-1856 # 4728 <malloc+0x180>
    2e70:	00001097          	auipc	ra,0x1
    2e74:	67a080e7          	jalr	1658(ra) # 44ea <printf>
    exit(-1);
    2e78:	557d                	li	a0,-1
    2e7a:	00001097          	auipc	ra,0x1
    2e7e:	2d8080e7          	jalr	728(ra) # 4152 <exit>
    printf("unlink dots/. worked!\n");
    2e82:	00003517          	auipc	a0,0x3
    2e86:	d8e50513          	addi	a0,a0,-626 # 5c10 <malloc+0x1668>
    2e8a:	00001097          	auipc	ra,0x1
    2e8e:	660080e7          	jalr	1632(ra) # 44ea <printf>
    exit(-1);
    2e92:	557d                	li	a0,-1
    2e94:	00001097          	auipc	ra,0x1
    2e98:	2be080e7          	jalr	702(ra) # 4152 <exit>
    printf("unlink dots/.. worked!\n");
    2e9c:	00003517          	auipc	a0,0x3
    2ea0:	d9450513          	addi	a0,a0,-620 # 5c30 <malloc+0x1688>
    2ea4:	00001097          	auipc	ra,0x1
    2ea8:	646080e7          	jalr	1606(ra) # 44ea <printf>
    exit(-1);
    2eac:	557d                	li	a0,-1
    2eae:	00001097          	auipc	ra,0x1
    2eb2:	2a4080e7          	jalr	676(ra) # 4152 <exit>
    printf("unlink dots failed!\n");
    2eb6:	00003517          	auipc	a0,0x3
    2eba:	d9250513          	addi	a0,a0,-622 # 5c48 <malloc+0x16a0>
    2ebe:	00001097          	auipc	ra,0x1
    2ec2:	62c080e7          	jalr	1580(ra) # 44ea <printf>
    exit(-1);
    2ec6:	557d                	li	a0,-1
    2ec8:	00001097          	auipc	ra,0x1
    2ecc:	28a080e7          	jalr	650(ra) # 4152 <exit>

0000000000002ed0 <dirfile>:

void
dirfile(void)
{
    2ed0:	1101                	addi	sp,sp,-32
    2ed2:	ec06                	sd	ra,24(sp)
    2ed4:	e822                	sd	s0,16(sp)
    2ed6:	e426                	sd	s1,8(sp)
    2ed8:	1000                	addi	s0,sp,32
  int fd;

  printf("dir vs file\n");
    2eda:	00003517          	auipc	a0,0x3
    2ede:	d9650513          	addi	a0,a0,-618 # 5c70 <malloc+0x16c8>
    2ee2:	00001097          	auipc	ra,0x1
    2ee6:	608080e7          	jalr	1544(ra) # 44ea <printf>

  fd = open("dirfile", O_CREATE);
    2eea:	20000593          	li	a1,512
    2eee:	00003517          	auipc	a0,0x3
    2ef2:	d9250513          	addi	a0,a0,-622 # 5c80 <malloc+0x16d8>
    2ef6:	00001097          	auipc	ra,0x1
    2efa:	29c080e7          	jalr	668(ra) # 4192 <open>
  if(fd < 0){
    2efe:	10054563          	bltz	a0,3008 <dirfile+0x138>
    printf("create dirfile failed\n");
    exit(-1);
  }
  close(fd);
    2f02:	00001097          	auipc	ra,0x1
    2f06:	278080e7          	jalr	632(ra) # 417a <close>
  if(chdir("dirfile") == 0){
    2f0a:	00003517          	auipc	a0,0x3
    2f0e:	d7650513          	addi	a0,a0,-650 # 5c80 <malloc+0x16d8>
    2f12:	00001097          	auipc	ra,0x1
    2f16:	2b0080e7          	jalr	688(ra) # 41c2 <chdir>
    2f1a:	10050463          	beqz	a0,3022 <dirfile+0x152>
    printf("chdir dirfile succeeded!\n");
    exit(-1);
  }
  fd = open("dirfile/xx", 0);
    2f1e:	4581                	li	a1,0
    2f20:	00003517          	auipc	a0,0x3
    2f24:	da050513          	addi	a0,a0,-608 # 5cc0 <malloc+0x1718>
    2f28:	00001097          	auipc	ra,0x1
    2f2c:	26a080e7          	jalr	618(ra) # 4192 <open>
  if(fd >= 0){
    2f30:	10055663          	bgez	a0,303c <dirfile+0x16c>
    printf("create dirfile/xx succeeded!\n");
    exit(-1);
  }
  fd = open("dirfile/xx", O_CREATE);
    2f34:	20000593          	li	a1,512
    2f38:	00003517          	auipc	a0,0x3
    2f3c:	d8850513          	addi	a0,a0,-632 # 5cc0 <malloc+0x1718>
    2f40:	00001097          	auipc	ra,0x1
    2f44:	252080e7          	jalr	594(ra) # 4192 <open>
  if(fd >= 0){
    2f48:	10055763          	bgez	a0,3056 <dirfile+0x186>
    printf("create dirfile/xx succeeded!\n");
    exit(-1);
  }
  if(mkdir("dirfile/xx") == 0){
    2f4c:	00003517          	auipc	a0,0x3
    2f50:	d7450513          	addi	a0,a0,-652 # 5cc0 <malloc+0x1718>
    2f54:	00001097          	auipc	ra,0x1
    2f58:	266080e7          	jalr	614(ra) # 41ba <mkdir>
    2f5c:	10050a63          	beqz	a0,3070 <dirfile+0x1a0>
    printf("mkdir dirfile/xx succeeded!\n");
    exit(-1);
  }
  if(unlink("dirfile/xx") == 0){
    2f60:	00003517          	auipc	a0,0x3
    2f64:	d6050513          	addi	a0,a0,-672 # 5cc0 <malloc+0x1718>
    2f68:	00001097          	auipc	ra,0x1
    2f6c:	23a080e7          	jalr	570(ra) # 41a2 <unlink>
    2f70:	10050d63          	beqz	a0,308a <dirfile+0x1ba>
    printf("unlink dirfile/xx succeeded!\n");
    exit(-1);
  }
  if(link("README", "dirfile/xx") == 0){
    2f74:	00003597          	auipc	a1,0x3
    2f78:	d4c58593          	addi	a1,a1,-692 # 5cc0 <malloc+0x1718>
    2f7c:	00003517          	auipc	a0,0x3
    2f80:	db450513          	addi	a0,a0,-588 # 5d30 <malloc+0x1788>
    2f84:	00001097          	auipc	ra,0x1
    2f88:	22e080e7          	jalr	558(ra) # 41b2 <link>
    2f8c:	10050c63          	beqz	a0,30a4 <dirfile+0x1d4>
    printf("link to dirfile/xx succeeded!\n");
    exit(-1);
  }
  if(unlink("dirfile") != 0){
    2f90:	00003517          	auipc	a0,0x3
    2f94:	cf050513          	addi	a0,a0,-784 # 5c80 <malloc+0x16d8>
    2f98:	00001097          	auipc	ra,0x1
    2f9c:	20a080e7          	jalr	522(ra) # 41a2 <unlink>
    2fa0:	10051f63          	bnez	a0,30be <dirfile+0x1ee>
    printf("unlink dirfile failed!\n");
    exit(-1);
  }

  fd = open(".", O_RDWR);
    2fa4:	4589                	li	a1,2
    2fa6:	00002517          	auipc	a0,0x2
    2faa:	1fa50513          	addi	a0,a0,506 # 51a0 <malloc+0xbf8>
    2fae:	00001097          	auipc	ra,0x1
    2fb2:	1e4080e7          	jalr	484(ra) # 4192 <open>
  if(fd >= 0){
    2fb6:	12055163          	bgez	a0,30d8 <dirfile+0x208>
    printf("open . for writing succeeded!\n");
    exit(-1);
  }
  fd = open(".", 0);
    2fba:	4581                	li	a1,0
    2fbc:	00002517          	auipc	a0,0x2
    2fc0:	1e450513          	addi	a0,a0,484 # 51a0 <malloc+0xbf8>
    2fc4:	00001097          	auipc	ra,0x1
    2fc8:	1ce080e7          	jalr	462(ra) # 4192 <open>
    2fcc:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    2fce:	4605                	li	a2,1
    2fd0:	00002597          	auipc	a1,0x2
    2fd4:	c9858593          	addi	a1,a1,-872 # 4c68 <malloc+0x6c0>
    2fd8:	00001097          	auipc	ra,0x1
    2fdc:	19a080e7          	jalr	410(ra) # 4172 <write>
    2fe0:	10a04963          	bgtz	a0,30f2 <dirfile+0x222>
    printf("write . succeeded!\n");
    exit(-1);
  }
  close(fd);
    2fe4:	8526                	mv	a0,s1
    2fe6:	00001097          	auipc	ra,0x1
    2fea:	194080e7          	jalr	404(ra) # 417a <close>

  printf("dir vs file OK\n");
    2fee:	00003517          	auipc	a0,0x3
    2ff2:	dba50513          	addi	a0,a0,-582 # 5da8 <malloc+0x1800>
    2ff6:	00001097          	auipc	ra,0x1
    2ffa:	4f4080e7          	jalr	1268(ra) # 44ea <printf>
}
    2ffe:	60e2                	ld	ra,24(sp)
    3000:	6442                	ld	s0,16(sp)
    3002:	64a2                	ld	s1,8(sp)
    3004:	6105                	addi	sp,sp,32
    3006:	8082                	ret
    printf("create dirfile failed\n");
    3008:	00003517          	auipc	a0,0x3
    300c:	c8050513          	addi	a0,a0,-896 # 5c88 <malloc+0x16e0>
    3010:	00001097          	auipc	ra,0x1
    3014:	4da080e7          	jalr	1242(ra) # 44ea <printf>
    exit(-1);
    3018:	557d                	li	a0,-1
    301a:	00001097          	auipc	ra,0x1
    301e:	138080e7          	jalr	312(ra) # 4152 <exit>
    printf("chdir dirfile succeeded!\n");
    3022:	00003517          	auipc	a0,0x3
    3026:	c7e50513          	addi	a0,a0,-898 # 5ca0 <malloc+0x16f8>
    302a:	00001097          	auipc	ra,0x1
    302e:	4c0080e7          	jalr	1216(ra) # 44ea <printf>
    exit(-1);
    3032:	557d                	li	a0,-1
    3034:	00001097          	auipc	ra,0x1
    3038:	11e080e7          	jalr	286(ra) # 4152 <exit>
    printf("create dirfile/xx succeeded!\n");
    303c:	00003517          	auipc	a0,0x3
    3040:	c9450513          	addi	a0,a0,-876 # 5cd0 <malloc+0x1728>
    3044:	00001097          	auipc	ra,0x1
    3048:	4a6080e7          	jalr	1190(ra) # 44ea <printf>
    exit(-1);
    304c:	557d                	li	a0,-1
    304e:	00001097          	auipc	ra,0x1
    3052:	104080e7          	jalr	260(ra) # 4152 <exit>
    printf("create dirfile/xx succeeded!\n");
    3056:	00003517          	auipc	a0,0x3
    305a:	c7a50513          	addi	a0,a0,-902 # 5cd0 <malloc+0x1728>
    305e:	00001097          	auipc	ra,0x1
    3062:	48c080e7          	jalr	1164(ra) # 44ea <printf>
    exit(-1);
    3066:	557d                	li	a0,-1
    3068:	00001097          	auipc	ra,0x1
    306c:	0ea080e7          	jalr	234(ra) # 4152 <exit>
    printf("mkdir dirfile/xx succeeded!\n");
    3070:	00003517          	auipc	a0,0x3
    3074:	c8050513          	addi	a0,a0,-896 # 5cf0 <malloc+0x1748>
    3078:	00001097          	auipc	ra,0x1
    307c:	472080e7          	jalr	1138(ra) # 44ea <printf>
    exit(-1);
    3080:	557d                	li	a0,-1
    3082:	00001097          	auipc	ra,0x1
    3086:	0d0080e7          	jalr	208(ra) # 4152 <exit>
    printf("unlink dirfile/xx succeeded!\n");
    308a:	00003517          	auipc	a0,0x3
    308e:	c8650513          	addi	a0,a0,-890 # 5d10 <malloc+0x1768>
    3092:	00001097          	auipc	ra,0x1
    3096:	458080e7          	jalr	1112(ra) # 44ea <printf>
    exit(-1);
    309a:	557d                	li	a0,-1
    309c:	00001097          	auipc	ra,0x1
    30a0:	0b6080e7          	jalr	182(ra) # 4152 <exit>
    printf("link to dirfile/xx succeeded!\n");
    30a4:	00003517          	auipc	a0,0x3
    30a8:	c9450513          	addi	a0,a0,-876 # 5d38 <malloc+0x1790>
    30ac:	00001097          	auipc	ra,0x1
    30b0:	43e080e7          	jalr	1086(ra) # 44ea <printf>
    exit(-1);
    30b4:	557d                	li	a0,-1
    30b6:	00001097          	auipc	ra,0x1
    30ba:	09c080e7          	jalr	156(ra) # 4152 <exit>
    printf("unlink dirfile failed!\n");
    30be:	00003517          	auipc	a0,0x3
    30c2:	c9a50513          	addi	a0,a0,-870 # 5d58 <malloc+0x17b0>
    30c6:	00001097          	auipc	ra,0x1
    30ca:	424080e7          	jalr	1060(ra) # 44ea <printf>
    exit(-1);
    30ce:	557d                	li	a0,-1
    30d0:	00001097          	auipc	ra,0x1
    30d4:	082080e7          	jalr	130(ra) # 4152 <exit>
    printf("open . for writing succeeded!\n");
    30d8:	00003517          	auipc	a0,0x3
    30dc:	c9850513          	addi	a0,a0,-872 # 5d70 <malloc+0x17c8>
    30e0:	00001097          	auipc	ra,0x1
    30e4:	40a080e7          	jalr	1034(ra) # 44ea <printf>
    exit(-1);
    30e8:	557d                	li	a0,-1
    30ea:	00001097          	auipc	ra,0x1
    30ee:	068080e7          	jalr	104(ra) # 4152 <exit>
    printf("write . succeeded!\n");
    30f2:	00003517          	auipc	a0,0x3
    30f6:	c9e50513          	addi	a0,a0,-866 # 5d90 <malloc+0x17e8>
    30fa:	00001097          	auipc	ra,0x1
    30fe:	3f0080e7          	jalr	1008(ra) # 44ea <printf>
    exit(-1);
    3102:	557d                	li	a0,-1
    3104:	00001097          	auipc	ra,0x1
    3108:	04e080e7          	jalr	78(ra) # 4152 <exit>

000000000000310c <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    310c:	7139                	addi	sp,sp,-64
    310e:	fc06                	sd	ra,56(sp)
    3110:	f822                	sd	s0,48(sp)
    3112:	f426                	sd	s1,40(sp)
    3114:	f04a                	sd	s2,32(sp)
    3116:	ec4e                	sd	s3,24(sp)
    3118:	e852                	sd	s4,16(sp)
    311a:	e456                	sd	s5,8(sp)
    311c:	0080                	addi	s0,sp,64
  int i, fd;

  printf("empty file name\n");
    311e:	00003517          	auipc	a0,0x3
    3122:	c9a50513          	addi	a0,a0,-870 # 5db8 <malloc+0x1810>
    3126:	00001097          	auipc	ra,0x1
    312a:	3c4080e7          	jalr	964(ra) # 44ea <printf>
    312e:	03300913          	li	s2,51

  for(i = 0; i < NINODE + 1; i++){
    if(mkdir("irefd") != 0){
    3132:	00003a17          	auipc	s4,0x3
    3136:	c9ea0a13          	addi	s4,s4,-866 # 5dd0 <malloc+0x1828>
    if(chdir("irefd") != 0){
      printf("chdir irefd failed\n");
      exit(-1);
    }

    mkdir("");
    313a:	00003497          	auipc	s1,0x3
    313e:	a4e48493          	addi	s1,s1,-1458 # 5b88 <malloc+0x15e0>
    link("README", "");
    3142:	00003a97          	auipc	s5,0x3
    3146:	beea8a93          	addi	s5,s5,-1042 # 5d30 <malloc+0x1788>
    fd = open("", O_CREATE);
    if(fd >= 0)
      close(fd);
    fd = open("xx", O_CREATE);
    314a:	00003997          	auipc	s3,0x3
    314e:	b7e98993          	addi	s3,s3,-1154 # 5cc8 <malloc+0x1720>
    3152:	a881                	j	31a2 <iref+0x96>
      printf("mkdir irefd failed\n");
    3154:	00003517          	auipc	a0,0x3
    3158:	c8450513          	addi	a0,a0,-892 # 5dd8 <malloc+0x1830>
    315c:	00001097          	auipc	ra,0x1
    3160:	38e080e7          	jalr	910(ra) # 44ea <printf>
      exit(-1);
    3164:	557d                	li	a0,-1
    3166:	00001097          	auipc	ra,0x1
    316a:	fec080e7          	jalr	-20(ra) # 4152 <exit>
      printf("chdir irefd failed\n");
    316e:	00003517          	auipc	a0,0x3
    3172:	c8250513          	addi	a0,a0,-894 # 5df0 <malloc+0x1848>
    3176:	00001097          	auipc	ra,0x1
    317a:	374080e7          	jalr	884(ra) # 44ea <printf>
      exit(-1);
    317e:	557d                	li	a0,-1
    3180:	00001097          	auipc	ra,0x1
    3184:	fd2080e7          	jalr	-46(ra) # 4152 <exit>
      close(fd);
    3188:	00001097          	auipc	ra,0x1
    318c:	ff2080e7          	jalr	-14(ra) # 417a <close>
    3190:	a889                	j	31e2 <iref+0xd6>
    if(fd >= 0)
      close(fd);
    unlink("xx");
    3192:	854e                	mv	a0,s3
    3194:	00001097          	auipc	ra,0x1
    3198:	00e080e7          	jalr	14(ra) # 41a2 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    319c:	397d                	addiw	s2,s2,-1
    319e:	06090063          	beqz	s2,31fe <iref+0xf2>
    if(mkdir("irefd") != 0){
    31a2:	8552                	mv	a0,s4
    31a4:	00001097          	auipc	ra,0x1
    31a8:	016080e7          	jalr	22(ra) # 41ba <mkdir>
    31ac:	f545                	bnez	a0,3154 <iref+0x48>
    if(chdir("irefd") != 0){
    31ae:	8552                	mv	a0,s4
    31b0:	00001097          	auipc	ra,0x1
    31b4:	012080e7          	jalr	18(ra) # 41c2 <chdir>
    31b8:	f95d                	bnez	a0,316e <iref+0x62>
    mkdir("");
    31ba:	8526                	mv	a0,s1
    31bc:	00001097          	auipc	ra,0x1
    31c0:	ffe080e7          	jalr	-2(ra) # 41ba <mkdir>
    link("README", "");
    31c4:	85a6                	mv	a1,s1
    31c6:	8556                	mv	a0,s5
    31c8:	00001097          	auipc	ra,0x1
    31cc:	fea080e7          	jalr	-22(ra) # 41b2 <link>
    fd = open("", O_CREATE);
    31d0:	20000593          	li	a1,512
    31d4:	8526                	mv	a0,s1
    31d6:	00001097          	auipc	ra,0x1
    31da:	fbc080e7          	jalr	-68(ra) # 4192 <open>
    if(fd >= 0)
    31de:	fa0555e3          	bgez	a0,3188 <iref+0x7c>
    fd = open("xx", O_CREATE);
    31e2:	20000593          	li	a1,512
    31e6:	854e                	mv	a0,s3
    31e8:	00001097          	auipc	ra,0x1
    31ec:	faa080e7          	jalr	-86(ra) # 4192 <open>
    if(fd >= 0)
    31f0:	fa0541e3          	bltz	a0,3192 <iref+0x86>
      close(fd);
    31f4:	00001097          	auipc	ra,0x1
    31f8:	f86080e7          	jalr	-122(ra) # 417a <close>
    31fc:	bf59                	j	3192 <iref+0x86>
  }

  chdir("/");
    31fe:	00001517          	auipc	a0,0x1
    3202:	52250513          	addi	a0,a0,1314 # 4720 <malloc+0x178>
    3206:	00001097          	auipc	ra,0x1
    320a:	fbc080e7          	jalr	-68(ra) # 41c2 <chdir>
  printf("empty file name OK\n");
    320e:	00003517          	auipc	a0,0x3
    3212:	bfa50513          	addi	a0,a0,-1030 # 5e08 <malloc+0x1860>
    3216:	00001097          	auipc	ra,0x1
    321a:	2d4080e7          	jalr	724(ra) # 44ea <printf>
}
    321e:	70e2                	ld	ra,56(sp)
    3220:	7442                	ld	s0,48(sp)
    3222:	74a2                	ld	s1,40(sp)
    3224:	7902                	ld	s2,32(sp)
    3226:	69e2                	ld	s3,24(sp)
    3228:	6a42                	ld	s4,16(sp)
    322a:	6aa2                	ld	s5,8(sp)
    322c:	6121                	addi	sp,sp,64
    322e:	8082                	ret

0000000000003230 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    3230:	1101                	addi	sp,sp,-32
    3232:	ec06                	sd	ra,24(sp)
    3234:	e822                	sd	s0,16(sp)
    3236:	e426                	sd	s1,8(sp)
    3238:	e04a                	sd	s2,0(sp)
    323a:	1000                	addi	s0,sp,32
  enum{ N = 1000 };
  int n, pid;

  printf("fork test\n");
    323c:	00002517          	auipc	a0,0x2
    3240:	b4c50513          	addi	a0,a0,-1204 # 4d88 <malloc+0x7e0>
    3244:	00001097          	auipc	ra,0x1
    3248:	2a6080e7          	jalr	678(ra) # 44ea <printf>

  for(n=0; n<N; n++){
    324c:	4481                	li	s1,0
    324e:	3e800913          	li	s2,1000
    pid = fork();
    3252:	00001097          	auipc	ra,0x1
    3256:	ef8080e7          	jalr	-264(ra) # 414a <fork>
    if(pid < 0)
    325a:	02054763          	bltz	a0,3288 <forktest+0x58>
      break;
    if(pid == 0)
    325e:	c10d                	beqz	a0,3280 <forktest+0x50>
  for(n=0; n<N; n++){
    3260:	2485                	addiw	s1,s1,1
    3262:	ff2498e3          	bne	s1,s2,3252 <forktest+0x22>
    printf("no fork at all!\n");
    exit(-1);
  }

  if(n == N){
    printf("fork claimed to work 1000 times!\n");
    3266:	00003517          	auipc	a0,0x3
    326a:	bd250513          	addi	a0,a0,-1070 # 5e38 <malloc+0x1890>
    326e:	00001097          	auipc	ra,0x1
    3272:	27c080e7          	jalr	636(ra) # 44ea <printf>
    exit(-1);
    3276:	557d                	li	a0,-1
    3278:	00001097          	auipc	ra,0x1
    327c:	eda080e7          	jalr	-294(ra) # 4152 <exit>
      exit(0);
    3280:	00001097          	auipc	ra,0x1
    3284:	ed2080e7          	jalr	-302(ra) # 4152 <exit>
  if (n == 0) {
    3288:	c4b1                	beqz	s1,32d4 <forktest+0xa4>
  if(n == N){
    328a:	3e800793          	li	a5,1000
    328e:	fcf48ce3          	beq	s1,a5,3266 <forktest+0x36>
  }

  for(; n > 0; n--){
    3292:	00905b63          	blez	s1,32a8 <forktest+0x78>
    if(wait(0) < 0){
    3296:	4501                	li	a0,0
    3298:	00001097          	auipc	ra,0x1
    329c:	ec2080e7          	jalr	-318(ra) # 415a <wait>
    32a0:	04054763          	bltz	a0,32ee <forktest+0xbe>
  for(; n > 0; n--){
    32a4:	34fd                	addiw	s1,s1,-1
    32a6:	f8e5                	bnez	s1,3296 <forktest+0x66>
      printf("wait stopped early\n");
      exit(-1);
    }
  }

  if(wait(0) != -1){
    32a8:	4501                	li	a0,0
    32aa:	00001097          	auipc	ra,0x1
    32ae:	eb0080e7          	jalr	-336(ra) # 415a <wait>
    32b2:	57fd                	li	a5,-1
    32b4:	04f51a63          	bne	a0,a5,3308 <forktest+0xd8>
    printf("wait got too many\n");
    exit(-1);
  }

  printf("fork test OK\n");
    32b8:	00003517          	auipc	a0,0x3
    32bc:	bd850513          	addi	a0,a0,-1064 # 5e90 <malloc+0x18e8>
    32c0:	00001097          	auipc	ra,0x1
    32c4:	22a080e7          	jalr	554(ra) # 44ea <printf>
}
    32c8:	60e2                	ld	ra,24(sp)
    32ca:	6442                	ld	s0,16(sp)
    32cc:	64a2                	ld	s1,8(sp)
    32ce:	6902                	ld	s2,0(sp)
    32d0:	6105                	addi	sp,sp,32
    32d2:	8082                	ret
    printf("no fork at all!\n");
    32d4:	00003517          	auipc	a0,0x3
    32d8:	b4c50513          	addi	a0,a0,-1204 # 5e20 <malloc+0x1878>
    32dc:	00001097          	auipc	ra,0x1
    32e0:	20e080e7          	jalr	526(ra) # 44ea <printf>
    exit(-1);
    32e4:	557d                	li	a0,-1
    32e6:	00001097          	auipc	ra,0x1
    32ea:	e6c080e7          	jalr	-404(ra) # 4152 <exit>
      printf("wait stopped early\n");
    32ee:	00003517          	auipc	a0,0x3
    32f2:	b7250513          	addi	a0,a0,-1166 # 5e60 <malloc+0x18b8>
    32f6:	00001097          	auipc	ra,0x1
    32fa:	1f4080e7          	jalr	500(ra) # 44ea <printf>
      exit(-1);
    32fe:	557d                	li	a0,-1
    3300:	00001097          	auipc	ra,0x1
    3304:	e52080e7          	jalr	-430(ra) # 4152 <exit>
    printf("wait got too many\n");
    3308:	00003517          	auipc	a0,0x3
    330c:	b7050513          	addi	a0,a0,-1168 # 5e78 <malloc+0x18d0>
    3310:	00001097          	auipc	ra,0x1
    3314:	1da080e7          	jalr	474(ra) # 44ea <printf>
    exit(-1);
    3318:	557d                	li	a0,-1
    331a:	00001097          	auipc	ra,0x1
    331e:	e38080e7          	jalr	-456(ra) # 4152 <exit>

0000000000003322 <sbrktest>:

void
sbrktest(void)
{
    3322:	7119                	addi	sp,sp,-128
    3324:	fc86                	sd	ra,120(sp)
    3326:	f8a2                	sd	s0,112(sp)
    3328:	f4a6                	sd	s1,104(sp)
    332a:	f0ca                	sd	s2,96(sp)
    332c:	ecce                	sd	s3,88(sp)
    332e:	e8d2                	sd	s4,80(sp)
    3330:	e4d6                	sd	s5,72(sp)
    3332:	0100                	addi	s0,sp,128
  char *c, *oldbrk, scratch, *a, *b, *lastaddr, *p;
  uint64 amt;
  int fd;
  int n;

  printf("sbrk test\n");
    3334:	00003517          	auipc	a0,0x3
    3338:	b6c50513          	addi	a0,a0,-1172 # 5ea0 <malloc+0x18f8>
    333c:	00001097          	auipc	ra,0x1
    3340:	1ae080e7          	jalr	430(ra) # 44ea <printf>
  oldbrk = sbrk(0);
    3344:	4501                	li	a0,0
    3346:	00001097          	auipc	ra,0x1
    334a:	e94080e7          	jalr	-364(ra) # 41da <sbrk>
    334e:	89aa                	mv	s3,a0

  // does sbrk() return the expected failure value?
  a = sbrk(TOOMUCH);
    3350:	40000537          	lui	a0,0x40000
    3354:	00001097          	auipc	ra,0x1
    3358:	e86080e7          	jalr	-378(ra) # 41da <sbrk>
  if(a != (char*)0xffffffffffffffffL){
    335c:	57fd                	li	a5,-1
    335e:	00f51d63          	bne	a0,a5,3378 <sbrktest+0x56>
    printf("sbrk(<toomuch>) returned %p\n", a);
    exit(-1);
  }

  // can one sbrk() less than a page?
  a = sbrk(0);
    3362:	4501                	li	a0,0
    3364:	00001097          	auipc	ra,0x1
    3368:	e76080e7          	jalr	-394(ra) # 41da <sbrk>
    336c:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    336e:	4901                	li	s2,0
    3370:	6a05                	lui	s4,0x1
    3372:	388a0a13          	addi	s4,s4,904 # 1388 <fourfiles+0x66>
    3376:	a005                	j	3396 <sbrktest+0x74>
    3378:	85aa                	mv	a1,a0
    printf("sbrk(<toomuch>) returned %p\n", a);
    337a:	00003517          	auipc	a0,0x3
    337e:	b3650513          	addi	a0,a0,-1226 # 5eb0 <malloc+0x1908>
    3382:	00001097          	auipc	ra,0x1
    3386:	168080e7          	jalr	360(ra) # 44ea <printf>
    exit(-1);
    338a:	557d                	li	a0,-1
    338c:	00001097          	auipc	ra,0x1
    3390:	dc6080e7          	jalr	-570(ra) # 4152 <exit>
    if(b != a){
      printf("sbrk test failed %d %x %x\n", i, a, b);
      exit(-1);
    }
    *b = 1;
    a = b + 1;
    3394:	84be                	mv	s1,a5
    b = sbrk(1);
    3396:	4505                	li	a0,1
    3398:	00001097          	auipc	ra,0x1
    339c:	e42080e7          	jalr	-446(ra) # 41da <sbrk>
    if(b != a){
    33a0:	16951363          	bne	a0,s1,3506 <sbrktest+0x1e4>
    *b = 1;
    33a4:	4785                	li	a5,1
    33a6:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    33aa:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    33ae:	2905                	addiw	s2,s2,1
    33b0:	ff4912e3          	bne	s2,s4,3394 <sbrktest+0x72>
  }
  pid = fork();
    33b4:	00001097          	auipc	ra,0x1
    33b8:	d96080e7          	jalr	-618(ra) # 414a <fork>
    33bc:	892a                	mv	s2,a0
  if(pid < 0){
    33be:	16054463          	bltz	a0,3526 <sbrktest+0x204>
    printf("sbrk test fork failed\n");
    exit(-1);
  }
  c = sbrk(1);
    33c2:	4505                	li	a0,1
    33c4:	00001097          	auipc	ra,0x1
    33c8:	e16080e7          	jalr	-490(ra) # 41da <sbrk>
  c = sbrk(1);
    33cc:	4505                	li	a0,1
    33ce:	00001097          	auipc	ra,0x1
    33d2:	e0c080e7          	jalr	-500(ra) # 41da <sbrk>
  if(c != a + 1){
    33d6:	0489                	addi	s1,s1,2
    33d8:	16a49463          	bne	s1,a0,3540 <sbrktest+0x21e>
    printf("sbrk test failed post-fork\n");
    exit(-1);
  }
  if(pid == 0)
    33dc:	16090f63          	beqz	s2,355a <sbrktest+0x238>
    exit(0);
  wait(0);
    33e0:	4501                	li	a0,0
    33e2:	00001097          	auipc	ra,0x1
    33e6:	d78080e7          	jalr	-648(ra) # 415a <wait>

  // can one grow address space to something big?
  a = sbrk(0);
    33ea:	4501                	li	a0,0
    33ec:	00001097          	auipc	ra,0x1
    33f0:	dee080e7          	jalr	-530(ra) # 41da <sbrk>
    33f4:	84aa                	mv	s1,a0
  amt = BIG - (uint64)a;
  p = sbrk(amt);
    33f6:	06400537          	lui	a0,0x6400
    33fa:	9d05                	subw	a0,a0,s1
    33fc:	00001097          	auipc	ra,0x1
    3400:	dde080e7          	jalr	-546(ra) # 41da <sbrk>
  if (p != a) {
    3404:	16a49063          	bne	s1,a0,3564 <sbrktest+0x242>
    printf("sbrk test failed to grow big address space; enough phys mem?\n");
    exit(-1);
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    3408:	064007b7          	lui	a5,0x6400
    340c:	06300713          	li	a4,99
    3410:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f435f>

  // can one de-allocate?
  a = sbrk(0);
    3414:	4501                	li	a0,0
    3416:	00001097          	auipc	ra,0x1
    341a:	dc4080e7          	jalr	-572(ra) # 41da <sbrk>
    341e:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    3420:	757d                	lui	a0,0xfffff
    3422:	00001097          	auipc	ra,0x1
    3426:	db8080e7          	jalr	-584(ra) # 41da <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    342a:	57fd                	li	a5,-1
    342c:	14f50963          	beq	a0,a5,357e <sbrktest+0x25c>
    printf("sbrk could not deallocate\n");
    exit(-1);
  }
  c = sbrk(0);
    3430:	4501                	li	a0,0
    3432:	00001097          	auipc	ra,0x1
    3436:	da8080e7          	jalr	-600(ra) # 41da <sbrk>
    343a:	862a                	mv	a2,a0
  if(c != a - PGSIZE){
    343c:	77fd                	lui	a5,0xfffff
    343e:	97a6                	add	a5,a5,s1
    3440:	14f51c63          	bne	a0,a5,3598 <sbrktest+0x276>
    printf("sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit(-1);
  }

  // can one re-allocate that page?
  a = sbrk(0);
    3444:	4501                	li	a0,0
    3446:	00001097          	auipc	ra,0x1
    344a:	d94080e7          	jalr	-620(ra) # 41da <sbrk>
    344e:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    3450:	6505                	lui	a0,0x1
    3452:	00001097          	auipc	ra,0x1
    3456:	d88080e7          	jalr	-632(ra) # 41da <sbrk>
    345a:	892a                	mv	s2,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    345c:	14a49c63          	bne	s1,a0,35b4 <sbrktest+0x292>
    3460:	4501                	li	a0,0
    3462:	00001097          	auipc	ra,0x1
    3466:	d78080e7          	jalr	-648(ra) # 41da <sbrk>
    346a:	6785                	lui	a5,0x1
    346c:	97a6                	add	a5,a5,s1
    346e:	14f51363          	bne	a0,a5,35b4 <sbrktest+0x292>
    printf("sbrk re-allocation failed, a %x c %x\n", a, c);
    exit(-1);
  }
  if(*lastaddr == 99){
    3472:	064007b7          	lui	a5,0x6400
    3476:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f435f>
    347a:	06300793          	li	a5,99
    347e:	14f70a63          	beq	a4,a5,35d2 <sbrktest+0x2b0>
    // should be zero
    printf("sbrk de-allocation didn't really deallocate\n");
    exit(-1);
  }

  a = sbrk(0);
    3482:	4501                	li	a0,0
    3484:	00001097          	auipc	ra,0x1
    3488:	d56080e7          	jalr	-682(ra) # 41da <sbrk>
    348c:	892a                	mv	s2,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    348e:	4501                	li	a0,0
    3490:	00001097          	auipc	ra,0x1
    3494:	d4a080e7          	jalr	-694(ra) # 41da <sbrk>
    3498:	40a9853b          	subw	a0,s3,a0
    349c:	00001097          	auipc	ra,0x1
    34a0:	d3e080e7          	jalr	-706(ra) # 41da <sbrk>
    34a4:	862a                	mv	a2,a0
    printf("sbrk downsize failed, a %x c %x\n", a, c);
    exit(-1);
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    34a6:	4485                	li	s1,1
    34a8:	04fe                	slli	s1,s1,0x1f
  if(c != a){
    34aa:	14a91163          	bne	s2,a0,35ec <sbrktest+0x2ca>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    34ae:	6ab1                	lui	s5,0xc
    34b0:	350a8a93          	addi	s5,s5,848 # c350 <__BSS_END__+0x6b0>
    34b4:	1003da37          	lui	s4,0x1003d
    34b8:	0a0e                	slli	s4,s4,0x3
    34ba:	480a0a13          	addi	s4,s4,1152 # 1003d480 <__BSS_END__+0x100317e0>
    ppid = getpid();
    34be:	00001097          	auipc	ra,0x1
    34c2:	d14080e7          	jalr	-748(ra) # 41d2 <getpid>
    34c6:	892a                	mv	s2,a0
    pid = fork();
    34c8:	00001097          	auipc	ra,0x1
    34cc:	c82080e7          	jalr	-894(ra) # 414a <fork>
    if(pid < 0){
    34d0:	12054c63          	bltz	a0,3608 <sbrktest+0x2e6>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid == 0){
    34d4:	14050763          	beqz	a0,3622 <sbrktest+0x300>
      printf("oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit(-1);
    }
    wait(0);
    34d8:	4501                	li	a0,0
    34da:	00001097          	auipc	ra,0x1
    34de:	c80080e7          	jalr	-896(ra) # 415a <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    34e2:	94d6                	add	s1,s1,s5
    34e4:	fd449de3          	bne	s1,s4,34be <sbrktest+0x19c>
  }
    
  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    34e8:	fb840513          	addi	a0,s0,-72
    34ec:	00001097          	auipc	ra,0x1
    34f0:	c76080e7          	jalr	-906(ra) # 4162 <pipe>
    34f4:	14051c63          	bnez	a0,364c <sbrktest+0x32a>
    34f8:	f9040493          	addi	s1,s0,-112
    34fc:	fb840a13          	addi	s4,s0,-72
    3500:	8926                	mv	s2,s1
      sbrk(BIG - (uint64)sbrk(0));
      write(fds[1], "x", 1);
      // sit around until killed
      for(;;) sleep(1000);
    }
    if(pids[i] != -1)
    3502:	5afd                	li	s5,-1
    3504:	a25d                	j	36aa <sbrktest+0x388>
      printf("sbrk test failed %d %x %x\n", i, a, b);
    3506:	86aa                	mv	a3,a0
    3508:	8626                	mv	a2,s1
    350a:	85ca                	mv	a1,s2
    350c:	00003517          	auipc	a0,0x3
    3510:	9c450513          	addi	a0,a0,-1596 # 5ed0 <malloc+0x1928>
    3514:	00001097          	auipc	ra,0x1
    3518:	fd6080e7          	jalr	-42(ra) # 44ea <printf>
      exit(-1);
    351c:	557d                	li	a0,-1
    351e:	00001097          	auipc	ra,0x1
    3522:	c34080e7          	jalr	-972(ra) # 4152 <exit>
    printf("sbrk test fork failed\n");
    3526:	00003517          	auipc	a0,0x3
    352a:	9ca50513          	addi	a0,a0,-1590 # 5ef0 <malloc+0x1948>
    352e:	00001097          	auipc	ra,0x1
    3532:	fbc080e7          	jalr	-68(ra) # 44ea <printf>
    exit(-1);
    3536:	557d                	li	a0,-1
    3538:	00001097          	auipc	ra,0x1
    353c:	c1a080e7          	jalr	-998(ra) # 4152 <exit>
    printf("sbrk test failed post-fork\n");
    3540:	00003517          	auipc	a0,0x3
    3544:	9c850513          	addi	a0,a0,-1592 # 5f08 <malloc+0x1960>
    3548:	00001097          	auipc	ra,0x1
    354c:	fa2080e7          	jalr	-94(ra) # 44ea <printf>
    exit(-1);
    3550:	557d                	li	a0,-1
    3552:	00001097          	auipc	ra,0x1
    3556:	c00080e7          	jalr	-1024(ra) # 4152 <exit>
    exit(0);
    355a:	4501                	li	a0,0
    355c:	00001097          	auipc	ra,0x1
    3560:	bf6080e7          	jalr	-1034(ra) # 4152 <exit>
    printf("sbrk test failed to grow big address space; enough phys mem?\n");
    3564:	00003517          	auipc	a0,0x3
    3568:	9c450513          	addi	a0,a0,-1596 # 5f28 <malloc+0x1980>
    356c:	00001097          	auipc	ra,0x1
    3570:	f7e080e7          	jalr	-130(ra) # 44ea <printf>
    exit(-1);
    3574:	557d                	li	a0,-1
    3576:	00001097          	auipc	ra,0x1
    357a:	bdc080e7          	jalr	-1060(ra) # 4152 <exit>
    printf("sbrk could not deallocate\n");
    357e:	00003517          	auipc	a0,0x3
    3582:	9ea50513          	addi	a0,a0,-1558 # 5f68 <malloc+0x19c0>
    3586:	00001097          	auipc	ra,0x1
    358a:	f64080e7          	jalr	-156(ra) # 44ea <printf>
    exit(-1);
    358e:	557d                	li	a0,-1
    3590:	00001097          	auipc	ra,0x1
    3594:	bc2080e7          	jalr	-1086(ra) # 4152 <exit>
    printf("sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    3598:	85a6                	mv	a1,s1
    359a:	00003517          	auipc	a0,0x3
    359e:	9ee50513          	addi	a0,a0,-1554 # 5f88 <malloc+0x19e0>
    35a2:	00001097          	auipc	ra,0x1
    35a6:	f48080e7          	jalr	-184(ra) # 44ea <printf>
    exit(-1);
    35aa:	557d                	li	a0,-1
    35ac:	00001097          	auipc	ra,0x1
    35b0:	ba6080e7          	jalr	-1114(ra) # 4152 <exit>
    printf("sbrk re-allocation failed, a %x c %x\n", a, c);
    35b4:	864a                	mv	a2,s2
    35b6:	85a6                	mv	a1,s1
    35b8:	00003517          	auipc	a0,0x3
    35bc:	a0850513          	addi	a0,a0,-1528 # 5fc0 <malloc+0x1a18>
    35c0:	00001097          	auipc	ra,0x1
    35c4:	f2a080e7          	jalr	-214(ra) # 44ea <printf>
    exit(-1);
    35c8:	557d                	li	a0,-1
    35ca:	00001097          	auipc	ra,0x1
    35ce:	b88080e7          	jalr	-1144(ra) # 4152 <exit>
    printf("sbrk de-allocation didn't really deallocate\n");
    35d2:	00003517          	auipc	a0,0x3
    35d6:	a1650513          	addi	a0,a0,-1514 # 5fe8 <malloc+0x1a40>
    35da:	00001097          	auipc	ra,0x1
    35de:	f10080e7          	jalr	-240(ra) # 44ea <printf>
    exit(-1);
    35e2:	557d                	li	a0,-1
    35e4:	00001097          	auipc	ra,0x1
    35e8:	b6e080e7          	jalr	-1170(ra) # 4152 <exit>
    printf("sbrk downsize failed, a %x c %x\n", a, c);
    35ec:	85ca                	mv	a1,s2
    35ee:	00003517          	auipc	a0,0x3
    35f2:	a2a50513          	addi	a0,a0,-1494 # 6018 <malloc+0x1a70>
    35f6:	00001097          	auipc	ra,0x1
    35fa:	ef4080e7          	jalr	-268(ra) # 44ea <printf>
    exit(-1);
    35fe:	557d                	li	a0,-1
    3600:	00001097          	auipc	ra,0x1
    3604:	b52080e7          	jalr	-1198(ra) # 4152 <exit>
      printf("fork failed\n");
    3608:	00001517          	auipc	a0,0x1
    360c:	15050513          	addi	a0,a0,336 # 4758 <malloc+0x1b0>
    3610:	00001097          	auipc	ra,0x1
    3614:	eda080e7          	jalr	-294(ra) # 44ea <printf>
      exit(-1);
    3618:	557d                	li	a0,-1
    361a:	00001097          	auipc	ra,0x1
    361e:	b38080e7          	jalr	-1224(ra) # 4152 <exit>
      printf("oops could read %x = %x\n", a, *a);
    3622:	0004c603          	lbu	a2,0(s1)
    3626:	85a6                	mv	a1,s1
    3628:	00003517          	auipc	a0,0x3
    362c:	a1850513          	addi	a0,a0,-1512 # 6040 <malloc+0x1a98>
    3630:	00001097          	auipc	ra,0x1
    3634:	eba080e7          	jalr	-326(ra) # 44ea <printf>
      kill(ppid);
    3638:	854a                	mv	a0,s2
    363a:	00001097          	auipc	ra,0x1
    363e:	b48080e7          	jalr	-1208(ra) # 4182 <kill>
      exit(-1);
    3642:	557d                	li	a0,-1
    3644:	00001097          	auipc	ra,0x1
    3648:	b0e080e7          	jalr	-1266(ra) # 4152 <exit>
    printf("pipe() failed\n");
    364c:	00001517          	auipc	a0,0x1
    3650:	59450513          	addi	a0,a0,1428 # 4be0 <malloc+0x638>
    3654:	00001097          	auipc	ra,0x1
    3658:	e96080e7          	jalr	-362(ra) # 44ea <printf>
    exit(-1);
    365c:	557d                	li	a0,-1
    365e:	00001097          	auipc	ra,0x1
    3662:	af4080e7          	jalr	-1292(ra) # 4152 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3666:	4501                	li	a0,0
    3668:	00001097          	auipc	ra,0x1
    366c:	b72080e7          	jalr	-1166(ra) # 41da <sbrk>
    3670:	064007b7          	lui	a5,0x6400
    3674:	40a7853b          	subw	a0,a5,a0
    3678:	00001097          	auipc	ra,0x1
    367c:	b62080e7          	jalr	-1182(ra) # 41da <sbrk>
      write(fds[1], "x", 1);
    3680:	4605                	li	a2,1
    3682:	00001597          	auipc	a1,0x1
    3686:	5e658593          	addi	a1,a1,1510 # 4c68 <malloc+0x6c0>
    368a:	fbc42503          	lw	a0,-68(s0)
    368e:	00001097          	auipc	ra,0x1
    3692:	ae4080e7          	jalr	-1308(ra) # 4172 <write>
      for(;;) sleep(1000);
    3696:	3e800513          	li	a0,1000
    369a:	00001097          	auipc	ra,0x1
    369e:	b48080e7          	jalr	-1208(ra) # 41e2 <sleep>
    36a2:	bfd5                	j	3696 <sbrktest+0x374>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    36a4:	0911                	addi	s2,s2,4
    36a6:	03490563          	beq	s2,s4,36d0 <sbrktest+0x3ae>
    if((pids[i] = fork()) == 0){
    36aa:	00001097          	auipc	ra,0x1
    36ae:	aa0080e7          	jalr	-1376(ra) # 414a <fork>
    36b2:	00a92023          	sw	a0,0(s2)
    36b6:	d945                	beqz	a0,3666 <sbrktest+0x344>
    if(pids[i] != -1)
    36b8:	ff5506e3          	beq	a0,s5,36a4 <sbrktest+0x382>
      read(fds[0], &scratch, 1);
    36bc:	4605                	li	a2,1
    36be:	f8f40593          	addi	a1,s0,-113
    36c2:	fb842503          	lw	a0,-72(s0)
    36c6:	00001097          	auipc	ra,0x1
    36ca:	aa4080e7          	jalr	-1372(ra) # 416a <read>
    36ce:	bfd9                	j	36a4 <sbrktest+0x382>
  }

  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(PGSIZE);
    36d0:	6505                	lui	a0,0x1
    36d2:	00001097          	auipc	ra,0x1
    36d6:	b08080e7          	jalr	-1272(ra) # 41da <sbrk>
    36da:	892a                	mv	s2,a0
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
    36dc:	5afd                	li	s5,-1
    36de:	a021                	j	36e6 <sbrktest+0x3c4>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    36e0:	0491                	addi	s1,s1,4
    36e2:	01448f63          	beq	s1,s4,3700 <sbrktest+0x3de>
    if(pids[i] == -1)
    36e6:	4088                	lw	a0,0(s1)
    36e8:	ff550ce3          	beq	a0,s5,36e0 <sbrktest+0x3be>
      continue;
    kill(pids[i]);
    36ec:	00001097          	auipc	ra,0x1
    36f0:	a96080e7          	jalr	-1386(ra) # 4182 <kill>
    wait(0);
    36f4:	4501                	li	a0,0
    36f6:	00001097          	auipc	ra,0x1
    36fa:	a64080e7          	jalr	-1436(ra) # 415a <wait>
    36fe:	b7cd                	j	36e0 <sbrktest+0x3be>
  }
  if(c == (char*)0xffffffffffffffffL){
    3700:	57fd                	li	a5,-1
    3702:	0af90f63          	beq	s2,a5,37c0 <sbrktest+0x49e>
    printf("failed sbrk leaked memory\n");
    exit(-1);
  }

  // test running fork with the above allocated page 
  ppid = getpid();
    3706:	00001097          	auipc	ra,0x1
    370a:	acc080e7          	jalr	-1332(ra) # 41d2 <getpid>
    370e:	8a2a                	mv	s4,a0
  pid = fork();
    3710:	00001097          	auipc	ra,0x1
    3714:	a3a080e7          	jalr	-1478(ra) # 414a <fork>
    3718:	84aa                	mv	s1,a0
  if(pid < 0){
    371a:	0c054063          	bltz	a0,37da <sbrktest+0x4b8>
    printf("fork failed\n");
    exit(-1);
  }

  // test out of memory during sbrk
  if(pid == 0){
    371e:	c979                	beqz	a0,37f4 <sbrktest+0x4d2>
    }
    printf("allocate a lot of memory succeeded %d\n", n);
    kill(ppid);
    exit(-1);
  }
  wait(0);
    3720:	4501                	li	a0,0
    3722:	00001097          	auipc	ra,0x1
    3726:	a38080e7          	jalr	-1480(ra) # 415a <wait>

  // test reads from allocated memory
  a = sbrk(PGSIZE);
    372a:	6505                	lui	a0,0x1
    372c:	00001097          	auipc	ra,0x1
    3730:	aae080e7          	jalr	-1362(ra) # 41da <sbrk>
    3734:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    3736:	20100593          	li	a1,513
    373a:	00003517          	auipc	a0,0x3
    373e:	96e50513          	addi	a0,a0,-1682 # 60a8 <malloc+0x1b00>
    3742:	00001097          	auipc	ra,0x1
    3746:	a50080e7          	jalr	-1456(ra) # 4192 <open>
    374a:	84aa                	mv	s1,a0
  unlink("sbrk");
    374c:	00003517          	auipc	a0,0x3
    3750:	95c50513          	addi	a0,a0,-1700 # 60a8 <malloc+0x1b00>
    3754:	00001097          	auipc	ra,0x1
    3758:	a4e080e7          	jalr	-1458(ra) # 41a2 <unlink>
  if(fd < 0)  {
    375c:	0e04c663          	bltz	s1,3848 <sbrktest+0x526>
    printf("open sbrk failed\n");
    exit(-1);
  }
  if ((n = write(fd, a, 10)) < 0) {
    3760:	4629                	li	a2,10
    3762:	85ca                	mv	a1,s2
    3764:	8526                	mv	a0,s1
    3766:	00001097          	auipc	ra,0x1
    376a:	a0c080e7          	jalr	-1524(ra) # 4172 <write>
    376e:	0e054a63          	bltz	a0,3862 <sbrktest+0x540>
    printf("write sbrk failed\n");
    exit(-1);
  }
  close(fd);
    3772:	8526                	mv	a0,s1
    3774:	00001097          	auipc	ra,0x1
    3778:	a06080e7          	jalr	-1530(ra) # 417a <close>

  // test writes to allocated memory
  a = sbrk(PGSIZE);
    377c:	6505                	lui	a0,0x1
    377e:	00001097          	auipc	ra,0x1
    3782:	a5c080e7          	jalr	-1444(ra) # 41da <sbrk>
  if(pipe((int *) a) != 0){
    3786:	00001097          	auipc	ra,0x1
    378a:	9dc080e7          	jalr	-1572(ra) # 4162 <pipe>
    378e:	e57d                	bnez	a0,387c <sbrktest+0x55a>
    printf("pipe() failed\n");
    exit(-1);
  } 

  if(sbrk(0) > oldbrk)
    3790:	4501                	li	a0,0
    3792:	00001097          	auipc	ra,0x1
    3796:	a48080e7          	jalr	-1464(ra) # 41da <sbrk>
    379a:	0ea9ee63          	bltu	s3,a0,3896 <sbrktest+0x574>
    sbrk(-(sbrk(0) - oldbrk));

  printf("sbrk test OK\n");
    379e:	00003517          	auipc	a0,0x3
    37a2:	94250513          	addi	a0,a0,-1726 # 60e0 <malloc+0x1b38>
    37a6:	00001097          	auipc	ra,0x1
    37aa:	d44080e7          	jalr	-700(ra) # 44ea <printf>
}
    37ae:	70e6                	ld	ra,120(sp)
    37b0:	7446                	ld	s0,112(sp)
    37b2:	74a6                	ld	s1,104(sp)
    37b4:	7906                	ld	s2,96(sp)
    37b6:	69e6                	ld	s3,88(sp)
    37b8:	6a46                	ld	s4,80(sp)
    37ba:	6aa6                	ld	s5,72(sp)
    37bc:	6109                	addi	sp,sp,128
    37be:	8082                	ret
    printf("failed sbrk leaked memory\n");
    37c0:	00003517          	auipc	a0,0x3
    37c4:	8a050513          	addi	a0,a0,-1888 # 6060 <malloc+0x1ab8>
    37c8:	00001097          	auipc	ra,0x1
    37cc:	d22080e7          	jalr	-734(ra) # 44ea <printf>
    exit(-1);
    37d0:	557d                	li	a0,-1
    37d2:	00001097          	auipc	ra,0x1
    37d6:	980080e7          	jalr	-1664(ra) # 4152 <exit>
    printf("fork failed\n");
    37da:	00001517          	auipc	a0,0x1
    37de:	f7e50513          	addi	a0,a0,-130 # 4758 <malloc+0x1b0>
    37e2:	00001097          	auipc	ra,0x1
    37e6:	d08080e7          	jalr	-760(ra) # 44ea <printf>
    exit(-1);
    37ea:	557d                	li	a0,-1
    37ec:	00001097          	auipc	ra,0x1
    37f0:	966080e7          	jalr	-1690(ra) # 4152 <exit>
    a = sbrk(0);
    37f4:	4501                	li	a0,0
    37f6:	00001097          	auipc	ra,0x1
    37fa:	9e4080e7          	jalr	-1564(ra) # 41da <sbrk>
    37fe:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3800:	3e800537          	lui	a0,0x3e800
    3804:	00001097          	auipc	ra,0x1
    3808:	9d6080e7          	jalr	-1578(ra) # 41da <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    380c:	87ca                	mv	a5,s2
    380e:	3e800737          	lui	a4,0x3e800
    3812:	993a                	add	s2,s2,a4
    3814:	6705                	lui	a4,0x1
      n += *(a+i);
    3816:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f4360>
    381a:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    381c:	97ba                	add	a5,a5,a4
    381e:	ff279ce3          	bne	a5,s2,3816 <sbrktest+0x4f4>
    printf("allocate a lot of memory succeeded %d\n", n);
    3822:	85a6                	mv	a1,s1
    3824:	00003517          	auipc	a0,0x3
    3828:	85c50513          	addi	a0,a0,-1956 # 6080 <malloc+0x1ad8>
    382c:	00001097          	auipc	ra,0x1
    3830:	cbe080e7          	jalr	-834(ra) # 44ea <printf>
    kill(ppid);
    3834:	8552                	mv	a0,s4
    3836:	00001097          	auipc	ra,0x1
    383a:	94c080e7          	jalr	-1716(ra) # 4182 <kill>
    exit(-1);
    383e:	557d                	li	a0,-1
    3840:	00001097          	auipc	ra,0x1
    3844:	912080e7          	jalr	-1774(ra) # 4152 <exit>
    printf("open sbrk failed\n");
    3848:	00003517          	auipc	a0,0x3
    384c:	86850513          	addi	a0,a0,-1944 # 60b0 <malloc+0x1b08>
    3850:	00001097          	auipc	ra,0x1
    3854:	c9a080e7          	jalr	-870(ra) # 44ea <printf>
    exit(-1);
    3858:	557d                	li	a0,-1
    385a:	00001097          	auipc	ra,0x1
    385e:	8f8080e7          	jalr	-1800(ra) # 4152 <exit>
    printf("write sbrk failed\n");
    3862:	00003517          	auipc	a0,0x3
    3866:	86650513          	addi	a0,a0,-1946 # 60c8 <malloc+0x1b20>
    386a:	00001097          	auipc	ra,0x1
    386e:	c80080e7          	jalr	-896(ra) # 44ea <printf>
    exit(-1);
    3872:	557d                	li	a0,-1
    3874:	00001097          	auipc	ra,0x1
    3878:	8de080e7          	jalr	-1826(ra) # 4152 <exit>
    printf("pipe() failed\n");
    387c:	00001517          	auipc	a0,0x1
    3880:	36450513          	addi	a0,a0,868 # 4be0 <malloc+0x638>
    3884:	00001097          	auipc	ra,0x1
    3888:	c66080e7          	jalr	-922(ra) # 44ea <printf>
    exit(-1);
    388c:	557d                	li	a0,-1
    388e:	00001097          	auipc	ra,0x1
    3892:	8c4080e7          	jalr	-1852(ra) # 4152 <exit>
    sbrk(-(sbrk(0) - oldbrk));
    3896:	4501                	li	a0,0
    3898:	00001097          	auipc	ra,0x1
    389c:	942080e7          	jalr	-1726(ra) # 41da <sbrk>
    38a0:	40a9853b          	subw	a0,s3,a0
    38a4:	00001097          	auipc	ra,0x1
    38a8:	936080e7          	jalr	-1738(ra) # 41da <sbrk>
    38ac:	bdcd                	j	379e <sbrktest+0x47c>

00000000000038ae <validatetest>:

void
validatetest(void)
{
    38ae:	7139                	addi	sp,sp,-64
    38b0:	fc06                	sd	ra,56(sp)
    38b2:	f822                	sd	s0,48(sp)
    38b4:	f426                	sd	s1,40(sp)
    38b6:	f04a                	sd	s2,32(sp)
    38b8:	ec4e                	sd	s3,24(sp)
    38ba:	e852                	sd	s4,16(sp)
    38bc:	e456                	sd	s5,8(sp)
    38be:	0080                	addi	s0,sp,64
  int hi;
  uint64 p;

  printf("validate test\n");
    38c0:	00003517          	auipc	a0,0x3
    38c4:	83050513          	addi	a0,a0,-2000 # 60f0 <malloc+0x1b48>
    38c8:	00001097          	auipc	ra,0x1
    38cc:	c22080e7          	jalr	-990(ra) # 44ea <printf>
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += PGSIZE){
    38d0:	4481                	li	s1,0
    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    38d2:	00003997          	auipc	s3,0x3
    38d6:	82e98993          	addi	s3,s3,-2002 # 6100 <malloc+0x1b58>
    38da:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    38dc:	6a85                	lui	s5,0x1
    38de:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    38e2:	85a6                	mv	a1,s1
    38e4:	854e                	mv	a0,s3
    38e6:	00001097          	auipc	ra,0x1
    38ea:	8cc080e7          	jalr	-1844(ra) # 41b2 <link>
    38ee:	03251663          	bne	a0,s2,391a <validatetest+0x6c>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    38f2:	94d6                	add	s1,s1,s5
    38f4:	ff4497e3          	bne	s1,s4,38e2 <validatetest+0x34>
      printf("link should not succeed\n");
      exit(-1);
    }
  }

  printf("validate ok\n");
    38f8:	00003517          	auipc	a0,0x3
    38fc:	83850513          	addi	a0,a0,-1992 # 6130 <malloc+0x1b88>
    3900:	00001097          	auipc	ra,0x1
    3904:	bea080e7          	jalr	-1046(ra) # 44ea <printf>
}
    3908:	70e2                	ld	ra,56(sp)
    390a:	7442                	ld	s0,48(sp)
    390c:	74a2                	ld	s1,40(sp)
    390e:	7902                	ld	s2,32(sp)
    3910:	69e2                	ld	s3,24(sp)
    3912:	6a42                	ld	s4,16(sp)
    3914:	6aa2                	ld	s5,8(sp)
    3916:	6121                	addi	sp,sp,64
    3918:	8082                	ret
      printf("link should not succeed\n");
    391a:	00002517          	auipc	a0,0x2
    391e:	7f650513          	addi	a0,a0,2038 # 6110 <malloc+0x1b68>
    3922:	00001097          	auipc	ra,0x1
    3926:	bc8080e7          	jalr	-1080(ra) # 44ea <printf>
      exit(-1);
    392a:	557d                	li	a0,-1
    392c:	00001097          	auipc	ra,0x1
    3930:	826080e7          	jalr	-2010(ra) # 4152 <exit>

0000000000003934 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    3934:	1141                	addi	sp,sp,-16
    3936:	e406                	sd	ra,8(sp)
    3938:	e022                	sd	s0,0(sp)
    393a:	0800                	addi	s0,sp,16
  int i;

  printf("bss test\n");
    393c:	00003517          	auipc	a0,0x3
    3940:	80450513          	addi	a0,a0,-2044 # 6140 <malloc+0x1b98>
    3944:	00001097          	auipc	ra,0x1
    3948:	ba6080e7          	jalr	-1114(ra) # 44ea <printf>
  for(i = 0; i < sizeof(uninit); i++){
    394c:	00003797          	auipc	a5,0x3
    3950:	c3478793          	addi	a5,a5,-972 # 6580 <uninit>
    3954:	00005697          	auipc	a3,0x5
    3958:	33c68693          	addi	a3,a3,828 # 8c90 <buf>
    if(uninit[i] != '\0'){
    395c:	0007c703          	lbu	a4,0(a5)
    3960:	e305                	bnez	a4,3980 <bsstest+0x4c>
  for(i = 0; i < sizeof(uninit); i++){
    3962:	0785                	addi	a5,a5,1
    3964:	fed79ce3          	bne	a5,a3,395c <bsstest+0x28>
      printf("bss test failed\n");
      exit(-1);
    }
  }
  printf("bss test ok\n");
    3968:	00003517          	auipc	a0,0x3
    396c:	80050513          	addi	a0,a0,-2048 # 6168 <malloc+0x1bc0>
    3970:	00001097          	auipc	ra,0x1
    3974:	b7a080e7          	jalr	-1158(ra) # 44ea <printf>
}
    3978:	60a2                	ld	ra,8(sp)
    397a:	6402                	ld	s0,0(sp)
    397c:	0141                	addi	sp,sp,16
    397e:	8082                	ret
      printf("bss test failed\n");
    3980:	00002517          	auipc	a0,0x2
    3984:	7d050513          	addi	a0,a0,2000 # 6150 <malloc+0x1ba8>
    3988:	00001097          	auipc	ra,0x1
    398c:	b62080e7          	jalr	-1182(ra) # 44ea <printf>
      exit(-1);
    3990:	557d                	li	a0,-1
    3992:	00000097          	auipc	ra,0x0
    3996:	7c0080e7          	jalr	1984(ra) # 4152 <exit>

000000000000399a <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    399a:	1101                	addi	sp,sp,-32
    399c:	ec06                	sd	ra,24(sp)
    399e:	e822                	sd	s0,16(sp)
    39a0:	e426                	sd	s1,8(sp)
    39a2:	1000                	addi	s0,sp,32
  int pid, fd;

  unlink("bigarg-ok");
    39a4:	00002517          	auipc	a0,0x2
    39a8:	7d450513          	addi	a0,a0,2004 # 6178 <malloc+0x1bd0>
    39ac:	00000097          	auipc	ra,0x0
    39b0:	7f6080e7          	jalr	2038(ra) # 41a2 <unlink>
  pid = fork();
    39b4:	00000097          	auipc	ra,0x0
    39b8:	796080e7          	jalr	1942(ra) # 414a <fork>
  if(pid == 0){
    39bc:	c521                	beqz	a0,3a04 <bigargtest+0x6a>
    exec("echo", args);
    printf("bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit(0);
  } else if(pid < 0){
    39be:	0c054563          	bltz	a0,3a88 <bigargtest+0xee>
    printf("bigargtest: fork failed\n");
    exit(-1);
  }
  wait(0);
    39c2:	4501                	li	a0,0
    39c4:	00000097          	auipc	ra,0x0
    39c8:	796080e7          	jalr	1942(ra) # 415a <wait>
  fd = open("bigarg-ok", 0);
    39cc:	4581                	li	a1,0
    39ce:	00002517          	auipc	a0,0x2
    39d2:	7aa50513          	addi	a0,a0,1962 # 6178 <malloc+0x1bd0>
    39d6:	00000097          	auipc	ra,0x0
    39da:	7bc080e7          	jalr	1980(ra) # 4192 <open>
  if(fd < 0){
    39de:	0c054263          	bltz	a0,3aa2 <bigargtest+0x108>
    printf("bigarg test failed!\n");
    exit(-1);
  }
  close(fd);
    39e2:	00000097          	auipc	ra,0x0
    39e6:	798080e7          	jalr	1944(ra) # 417a <close>
  unlink("bigarg-ok");
    39ea:	00002517          	auipc	a0,0x2
    39ee:	78e50513          	addi	a0,a0,1934 # 6178 <malloc+0x1bd0>
    39f2:	00000097          	auipc	ra,0x0
    39f6:	7b0080e7          	jalr	1968(ra) # 41a2 <unlink>
}
    39fa:	60e2                	ld	ra,24(sp)
    39fc:	6442                	ld	s0,16(sp)
    39fe:	64a2                	ld	s1,8(sp)
    3a00:	6105                	addi	sp,sp,32
    3a02:	8082                	ret
    3a04:	00003797          	auipc	a5,0x3
    3a08:	a7c78793          	addi	a5,a5,-1412 # 6480 <args.1652>
    3a0c:	00003697          	auipc	a3,0x3
    3a10:	b6c68693          	addi	a3,a3,-1172 # 6578 <args.1652+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3a14:	00002717          	auipc	a4,0x2
    3a18:	77470713          	addi	a4,a4,1908 # 6188 <malloc+0x1be0>
    3a1c:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    3a1e:	07a1                	addi	a5,a5,8
    3a20:	fed79ee3          	bne	a5,a3,3a1c <bigargtest+0x82>
    args[MAXARG-1] = 0;
    3a24:	00003497          	auipc	s1,0x3
    3a28:	a5c48493          	addi	s1,s1,-1444 # 6480 <args.1652>
    3a2c:	0e04bc23          	sd	zero,248(s1)
    printf("bigarg test\n");
    3a30:	00003517          	auipc	a0,0x3
    3a34:	83850513          	addi	a0,a0,-1992 # 6268 <malloc+0x1cc0>
    3a38:	00001097          	auipc	ra,0x1
    3a3c:	ab2080e7          	jalr	-1358(ra) # 44ea <printf>
    exec("echo", args);
    3a40:	85a6                	mv	a1,s1
    3a42:	00001517          	auipc	a0,0x1
    3a46:	de650513          	addi	a0,a0,-538 # 4828 <malloc+0x280>
    3a4a:	00000097          	auipc	ra,0x0
    3a4e:	740080e7          	jalr	1856(ra) # 418a <exec>
    printf("bigarg test ok\n");
    3a52:	00003517          	auipc	a0,0x3
    3a56:	82650513          	addi	a0,a0,-2010 # 6278 <malloc+0x1cd0>
    3a5a:	00001097          	auipc	ra,0x1
    3a5e:	a90080e7          	jalr	-1392(ra) # 44ea <printf>
    fd = open("bigarg-ok", O_CREATE);
    3a62:	20000593          	li	a1,512
    3a66:	00002517          	auipc	a0,0x2
    3a6a:	71250513          	addi	a0,a0,1810 # 6178 <malloc+0x1bd0>
    3a6e:	00000097          	auipc	ra,0x0
    3a72:	724080e7          	jalr	1828(ra) # 4192 <open>
    close(fd);
    3a76:	00000097          	auipc	ra,0x0
    3a7a:	704080e7          	jalr	1796(ra) # 417a <close>
    exit(0);
    3a7e:	4501                	li	a0,0
    3a80:	00000097          	auipc	ra,0x0
    3a84:	6d2080e7          	jalr	1746(ra) # 4152 <exit>
    printf("bigargtest: fork failed\n");
    3a88:	00003517          	auipc	a0,0x3
    3a8c:	80050513          	addi	a0,a0,-2048 # 6288 <malloc+0x1ce0>
    3a90:	00001097          	auipc	ra,0x1
    3a94:	a5a080e7          	jalr	-1446(ra) # 44ea <printf>
    exit(-1);
    3a98:	557d                	li	a0,-1
    3a9a:	00000097          	auipc	ra,0x0
    3a9e:	6b8080e7          	jalr	1720(ra) # 4152 <exit>
    printf("bigarg test failed!\n");
    3aa2:	00003517          	auipc	a0,0x3
    3aa6:	80650513          	addi	a0,a0,-2042 # 62a8 <malloc+0x1d00>
    3aaa:	00001097          	auipc	ra,0x1
    3aae:	a40080e7          	jalr	-1472(ra) # 44ea <printf>
    exit(-1);
    3ab2:	557d                	li	a0,-1
    3ab4:	00000097          	auipc	ra,0x0
    3ab8:	69e080e7          	jalr	1694(ra) # 4152 <exit>

0000000000003abc <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3abc:	7171                	addi	sp,sp,-176
    3abe:	f506                	sd	ra,168(sp)
    3ac0:	f122                	sd	s0,160(sp)
    3ac2:	ed26                	sd	s1,152(sp)
    3ac4:	e94a                	sd	s2,144(sp)
    3ac6:	e54e                	sd	s3,136(sp)
    3ac8:	e152                	sd	s4,128(sp)
    3aca:	fcd6                	sd	s5,120(sp)
    3acc:	f8da                	sd	s6,112(sp)
    3ace:	f4de                	sd	s7,104(sp)
    3ad0:	f0e2                	sd	s8,96(sp)
    3ad2:	ece6                	sd	s9,88(sp)
    3ad4:	e8ea                	sd	s10,80(sp)
    3ad6:	e4ee                	sd	s11,72(sp)
    3ad8:	1900                	addi	s0,sp,176
  int nfiles;
  int fsblocks = 0;

  printf("fsfull test\n");
    3ada:	00002517          	auipc	a0,0x2
    3ade:	7e650513          	addi	a0,a0,2022 # 62c0 <malloc+0x1d18>
    3ae2:	00001097          	auipc	ra,0x1
    3ae6:	a08080e7          	jalr	-1528(ra) # 44ea <printf>

  for(nfiles = 0; ; nfiles++){
    3aea:	4481                	li	s1,0
    char name[64];
    name[0] = 'f';
    3aec:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    3af0:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    3af4:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    3af8:	4b29                	li	s6,10
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    printf("writing %s\n", name);
    3afa:	00002c97          	auipc	s9,0x2
    3afe:	7d6c8c93          	addi	s9,s9,2006 # 62d0 <malloc+0x1d28>
    int fd = open(name, O_CREATE|O_RDWR);
    if(fd < 0){
      printf("open %s failed\n", name);
      break;
    }
    int total = 0;
    3b02:	4d81                	li	s11,0
    while(1){
      int cc = write(fd, buf, BSIZE);
    3b04:	00005a17          	auipc	s4,0x5
    3b08:	18ca0a13          	addi	s4,s4,396 # 8c90 <buf>
    name[0] = 'f';
    3b0c:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    3b10:	0384c7bb          	divw	a5,s1,s8
    3b14:	0307879b          	addiw	a5,a5,48
    3b18:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    3b1c:	0384e7bb          	remw	a5,s1,s8
    3b20:	0377c7bb          	divw	a5,a5,s7
    3b24:	0307879b          	addiw	a5,a5,48
    3b28:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    3b2c:	0374e7bb          	remw	a5,s1,s7
    3b30:	0367c7bb          	divw	a5,a5,s6
    3b34:	0307879b          	addiw	a5,a5,48
    3b38:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    3b3c:	0364e7bb          	remw	a5,s1,s6
    3b40:	0307879b          	addiw	a5,a5,48
    3b44:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    3b48:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    3b4c:	f5040593          	addi	a1,s0,-176
    3b50:	8566                	mv	a0,s9
    3b52:	00001097          	auipc	ra,0x1
    3b56:	998080e7          	jalr	-1640(ra) # 44ea <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3b5a:	20200593          	li	a1,514
    3b5e:	f5040513          	addi	a0,s0,-176
    3b62:	00000097          	auipc	ra,0x0
    3b66:	630080e7          	jalr	1584(ra) # 4192 <open>
    3b6a:	892a                	mv	s2,a0
    if(fd < 0){
    3b6c:	0a055663          	bgez	a0,3c18 <fsfull+0x15c>
      printf("open %s failed\n", name);
    3b70:	f5040593          	addi	a1,s0,-176
    3b74:	00002517          	auipc	a0,0x2
    3b78:	76c50513          	addi	a0,a0,1900 # 62e0 <malloc+0x1d38>
    3b7c:	00001097          	auipc	ra,0x1
    3b80:	96e080e7          	jalr	-1682(ra) # 44ea <printf>
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3b84:	0604c363          	bltz	s1,3bea <fsfull+0x12e>
    char name[64];
    name[0] = 'f';
    3b88:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    3b8c:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    3b90:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    3b94:	4929                	li	s2,10
  while(nfiles >= 0){
    3b96:	5afd                	li	s5,-1
    name[0] = 'f';
    3b98:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    3b9c:	0344c7bb          	divw	a5,s1,s4
    3ba0:	0307879b          	addiw	a5,a5,48
    3ba4:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    3ba8:	0344e7bb          	remw	a5,s1,s4
    3bac:	0337c7bb          	divw	a5,a5,s3
    3bb0:	0307879b          	addiw	a5,a5,48
    3bb4:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    3bb8:	0334e7bb          	remw	a5,s1,s3
    3bbc:	0327c7bb          	divw	a5,a5,s2
    3bc0:	0307879b          	addiw	a5,a5,48
    3bc4:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    3bc8:	0324e7bb          	remw	a5,s1,s2
    3bcc:	0307879b          	addiw	a5,a5,48
    3bd0:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    3bd4:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    3bd8:	f5040513          	addi	a0,s0,-176
    3bdc:	00000097          	auipc	ra,0x0
    3be0:	5c6080e7          	jalr	1478(ra) # 41a2 <unlink>
    nfiles--;
    3be4:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    3be6:	fb5499e3          	bne	s1,s5,3b98 <fsfull+0xdc>
  }

  printf("fsfull test finished\n");
    3bea:	00002517          	auipc	a0,0x2
    3bee:	71650513          	addi	a0,a0,1814 # 6300 <malloc+0x1d58>
    3bf2:	00001097          	auipc	ra,0x1
    3bf6:	8f8080e7          	jalr	-1800(ra) # 44ea <printf>
}
    3bfa:	70aa                	ld	ra,168(sp)
    3bfc:	740a                	ld	s0,160(sp)
    3bfe:	64ea                	ld	s1,152(sp)
    3c00:	694a                	ld	s2,144(sp)
    3c02:	69aa                	ld	s3,136(sp)
    3c04:	6a0a                	ld	s4,128(sp)
    3c06:	7ae6                	ld	s5,120(sp)
    3c08:	7b46                	ld	s6,112(sp)
    3c0a:	7ba6                	ld	s7,104(sp)
    3c0c:	7c06                	ld	s8,96(sp)
    3c0e:	6ce6                	ld	s9,88(sp)
    3c10:	6d46                	ld	s10,80(sp)
    3c12:	6da6                	ld	s11,72(sp)
    3c14:	614d                	addi	sp,sp,176
    3c16:	8082                	ret
    int total = 0;
    3c18:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    3c1a:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    3c1e:	40000613          	li	a2,1024
    3c22:	85d2                	mv	a1,s4
    3c24:	854a                	mv	a0,s2
    3c26:	00000097          	auipc	ra,0x0
    3c2a:	54c080e7          	jalr	1356(ra) # 4172 <write>
      if(cc < BSIZE)
    3c2e:	00aad563          	bge	s5,a0,3c38 <fsfull+0x17c>
      total += cc;
    3c32:	00a989bb          	addw	s3,s3,a0
    while(1){
    3c36:	b7e5                	j	3c1e <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    3c38:	85ce                	mv	a1,s3
    3c3a:	00002517          	auipc	a0,0x2
    3c3e:	6b650513          	addi	a0,a0,1718 # 62f0 <malloc+0x1d48>
    3c42:	00001097          	auipc	ra,0x1
    3c46:	8a8080e7          	jalr	-1880(ra) # 44ea <printf>
    close(fd);
    3c4a:	854a                	mv	a0,s2
    3c4c:	00000097          	auipc	ra,0x0
    3c50:	52e080e7          	jalr	1326(ra) # 417a <close>
    if(total == 0)
    3c54:	f20988e3          	beqz	s3,3b84 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    3c58:	2485                	addiw	s1,s1,1
    3c5a:	bd4d                	j	3b0c <fsfull+0x50>

0000000000003c5c <argptest>:

void argptest()
{
    3c5c:	1101                	addi	sp,sp,-32
    3c5e:	ec06                	sd	ra,24(sp)
    3c60:	e822                	sd	s0,16(sp)
    3c62:	e426                	sd	s1,8(sp)
    3c64:	1000                	addi	s0,sp,32
  int fd;
  fd = open("init", O_RDONLY);
    3c66:	4581                	li	a1,0
    3c68:	00002517          	auipc	a0,0x2
    3c6c:	6b050513          	addi	a0,a0,1712 # 6318 <malloc+0x1d70>
    3c70:	00000097          	auipc	ra,0x0
    3c74:	522080e7          	jalr	1314(ra) # 4192 <open>
  if (fd < 0) {
    3c78:	04054263          	bltz	a0,3cbc <argptest+0x60>
    3c7c:	84aa                	mv	s1,a0
    fprintf(2, "open failed\n");
    exit(-1);
  }
  read(fd, sbrk(0) - 1, -1);
    3c7e:	4501                	li	a0,0
    3c80:	00000097          	auipc	ra,0x0
    3c84:	55a080e7          	jalr	1370(ra) # 41da <sbrk>
    3c88:	567d                	li	a2,-1
    3c8a:	fff50593          	addi	a1,a0,-1
    3c8e:	8526                	mv	a0,s1
    3c90:	00000097          	auipc	ra,0x0
    3c94:	4da080e7          	jalr	1242(ra) # 416a <read>
  close(fd);
    3c98:	8526                	mv	a0,s1
    3c9a:	00000097          	auipc	ra,0x0
    3c9e:	4e0080e7          	jalr	1248(ra) # 417a <close>
  printf("arg test passed\n");
    3ca2:	00002517          	auipc	a0,0x2
    3ca6:	68e50513          	addi	a0,a0,1678 # 6330 <malloc+0x1d88>
    3caa:	00001097          	auipc	ra,0x1
    3cae:	840080e7          	jalr	-1984(ra) # 44ea <printf>
}
    3cb2:	60e2                	ld	ra,24(sp)
    3cb4:	6442                	ld	s0,16(sp)
    3cb6:	64a2                	ld	s1,8(sp)
    3cb8:	6105                	addi	sp,sp,32
    3cba:	8082                	ret
    fprintf(2, "open failed\n");
    3cbc:	00002597          	auipc	a1,0x2
    3cc0:	66458593          	addi	a1,a1,1636 # 6320 <malloc+0x1d78>
    3cc4:	4509                	li	a0,2
    3cc6:	00000097          	auipc	ra,0x0
    3cca:	7f6080e7          	jalr	2038(ra) # 44bc <fprintf>
    exit(-1);
    3cce:	557d                	li	a0,-1
    3cd0:	00000097          	auipc	ra,0x0
    3cd4:	482080e7          	jalr	1154(ra) # 4152 <exit>

0000000000003cd8 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3cd8:	1141                	addi	sp,sp,-16
    3cda:	e422                	sd	s0,8(sp)
    3cdc:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    3cde:	00002717          	auipc	a4,0x2
    3ce2:	78a70713          	addi	a4,a4,1930 # 6468 <randstate>
    3ce6:	6308                	ld	a0,0(a4)
    3ce8:	001967b7          	lui	a5,0x196
    3cec:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x18a96d>
    3cf0:	02f50533          	mul	a0,a0,a5
    3cf4:	3c6ef7b7          	lui	a5,0x3c6ef
    3cf8:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e36bf>
    3cfc:	953e                	add	a0,a0,a5
    3cfe:	e308                	sd	a0,0(a4)
  return randstate;
}
    3d00:	2501                	sext.w	a0,a0
    3d02:	6422                	ld	s0,8(sp)
    3d04:	0141                	addi	sp,sp,16
    3d06:	8082                	ret

0000000000003d08 <stacktest>:

// check that there's an invalid page beneath
// the user stack, to catch stack overflow.
void
stacktest()
{
    3d08:	1101                	addi	sp,sp,-32
    3d0a:	ec06                	sd	ra,24(sp)
    3d0c:	e822                	sd	s0,16(sp)
    3d0e:	e426                	sd	s1,8(sp)
    3d10:	1000                	addi	s0,sp,32
  int pid;
  int ppid = getpid();
    3d12:	00000097          	auipc	ra,0x0
    3d16:	4c0080e7          	jalr	1216(ra) # 41d2 <getpid>
    3d1a:	84aa                	mv	s1,a0
  
  printf("stack guard test\n");
    3d1c:	00002517          	auipc	a0,0x2
    3d20:	62c50513          	addi	a0,a0,1580 # 6348 <malloc+0x1da0>
    3d24:	00000097          	auipc	ra,0x0
    3d28:	7c6080e7          	jalr	1990(ra) # 44ea <printf>
  pid = fork();
    3d2c:	00000097          	auipc	ra,0x0
    3d30:	41e080e7          	jalr	1054(ra) # 414a <fork>
  if(pid == 0) {
    3d34:	c50d                	beqz	a0,3d5e <stacktest+0x56>
    // the *sp should cause a trap.
    printf("stacktest: read below stack %p\n", *sp);
    printf("stacktest: test FAILED\n");
    kill(ppid);
    exit(-1);
  } else if(pid < 0){
    3d36:	06054363          	bltz	a0,3d9c <stacktest+0x94>
    printf("fork failed\n");
    exit(-1);
  }
  wait(0);
    3d3a:	4501                	li	a0,0
    3d3c:	00000097          	auipc	ra,0x0
    3d40:	41e080e7          	jalr	1054(ra) # 415a <wait>
  printf("stack guard test ok\n");
    3d44:	00002517          	auipc	a0,0x2
    3d48:	65450513          	addi	a0,a0,1620 # 6398 <malloc+0x1df0>
    3d4c:	00000097          	auipc	ra,0x0
    3d50:	79e080e7          	jalr	1950(ra) # 44ea <printf>
}
    3d54:	60e2                	ld	ra,24(sp)
    3d56:	6442                	ld	s0,16(sp)
    3d58:	64a2                	ld	s1,8(sp)
    3d5a:	6105                	addi	sp,sp,32
    3d5c:	8082                	ret

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    3d5e:	870a                	mv	a4,sp
    printf("stacktest: read below stack %p\n", *sp);
    3d60:	77fd                	lui	a5,0xfffff
    3d62:	97ba                	add	a5,a5,a4
    3d64:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff3360>
    3d68:	00002517          	auipc	a0,0x2
    3d6c:	5f850513          	addi	a0,a0,1528 # 6360 <malloc+0x1db8>
    3d70:	00000097          	auipc	ra,0x0
    3d74:	77a080e7          	jalr	1914(ra) # 44ea <printf>
    printf("stacktest: test FAILED\n");
    3d78:	00002517          	auipc	a0,0x2
    3d7c:	60850513          	addi	a0,a0,1544 # 6380 <malloc+0x1dd8>
    3d80:	00000097          	auipc	ra,0x0
    3d84:	76a080e7          	jalr	1898(ra) # 44ea <printf>
    kill(ppid);
    3d88:	8526                	mv	a0,s1
    3d8a:	00000097          	auipc	ra,0x0
    3d8e:	3f8080e7          	jalr	1016(ra) # 4182 <kill>
    exit(-1);
    3d92:	557d                	li	a0,-1
    3d94:	00000097          	auipc	ra,0x0
    3d98:	3be080e7          	jalr	958(ra) # 4152 <exit>
    printf("fork failed\n");
    3d9c:	00001517          	auipc	a0,0x1
    3da0:	9bc50513          	addi	a0,a0,-1604 # 4758 <malloc+0x1b0>
    3da4:	00000097          	auipc	ra,0x0
    3da8:	746080e7          	jalr	1862(ra) # 44ea <printf>
    exit(-1);
    3dac:	557d                	li	a0,-1
    3dae:	00000097          	auipc	ra,0x0
    3db2:	3a4080e7          	jalr	932(ra) # 4152 <exit>

0000000000003db6 <main>:

int
main(int argc, char *argv[])
{
    3db6:	1141                	addi	sp,sp,-16
    3db8:	e406                	sd	ra,8(sp)
    3dba:	e022                	sd	s0,0(sp)
    3dbc:	0800                	addi	s0,sp,16
  printf("usertests starting\n");
    3dbe:	00002517          	auipc	a0,0x2
    3dc2:	5f250513          	addi	a0,a0,1522 # 63b0 <malloc+0x1e08>
    3dc6:	00000097          	auipc	ra,0x0
    3dca:	724080e7          	jalr	1828(ra) # 44ea <printf>

  if(open("usertests.ran", 0) >= 0){
    3dce:	4581                	li	a1,0
    3dd0:	00002517          	auipc	a0,0x2
    3dd4:	5f850513          	addi	a0,a0,1528 # 63c8 <malloc+0x1e20>
    3dd8:	00000097          	auipc	ra,0x0
    3ddc:	3ba080e7          	jalr	954(ra) # 4192 <open>
    3de0:	00054f63          	bltz	a0,3dfe <main+0x48>
    printf("already ran user tests -- rebuild fs.img\n");
    3de4:	00002517          	auipc	a0,0x2
    3de8:	5f450513          	addi	a0,a0,1524 # 63d8 <malloc+0x1e30>
    3dec:	00000097          	auipc	ra,0x0
    3df0:	6fe080e7          	jalr	1790(ra) # 44ea <printf>
    exit(-1);
    3df4:	557d                	li	a0,-1
    3df6:	00000097          	auipc	ra,0x0
    3dfa:	35c080e7          	jalr	860(ra) # 4152 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3dfe:	20000593          	li	a1,512
    3e02:	00002517          	auipc	a0,0x2
    3e06:	5c650513          	addi	a0,a0,1478 # 63c8 <malloc+0x1e20>
    3e0a:	00000097          	auipc	ra,0x0
    3e0e:	388080e7          	jalr	904(ra) # 4192 <open>
    3e12:	00000097          	auipc	ra,0x0
    3e16:	368080e7          	jalr	872(ra) # 417a <close>

  reparent();
    3e1a:	ffffd097          	auipc	ra,0xffffd
    3e1e:	f2e080e7          	jalr	-210(ra) # d48 <reparent>
  twochildren();
    3e22:	ffffd097          	auipc	ra,0xffffd
    3e26:	00c080e7          	jalr	12(ra) # e2e <twochildren>
  forkfork();
    3e2a:	ffffd097          	auipc	ra,0xffffd
    3e2e:	0b4080e7          	jalr	180(ra) # ede <forkfork>
  forkforkfork();
    3e32:	ffffd097          	auipc	ra,0xffffd
    3e36:	18e080e7          	jalr	398(ra) # fc0 <forkforkfork>
  
  argptest();
    3e3a:	00000097          	auipc	ra,0x0
    3e3e:	e22080e7          	jalr	-478(ra) # 3c5c <argptest>
  createdelete();
    3e42:	ffffd097          	auipc	ra,0xffffd
    3e46:	732080e7          	jalr	1842(ra) # 1574 <createdelete>
  linkunlink();
    3e4a:	ffffe097          	auipc	ra,0xffffe
    3e4e:	08e080e7          	jalr	142(ra) # 1ed8 <linkunlink>
  concreate();
    3e52:	ffffe097          	auipc	ra,0xffffe
    3e56:	d76080e7          	jalr	-650(ra) # 1bc8 <concreate>
  fourfiles();
    3e5a:	ffffd097          	auipc	ra,0xffffd
    3e5e:	4c8080e7          	jalr	1224(ra) # 1322 <fourfiles>
  sharedfd();
    3e62:	ffffd097          	auipc	ra,0xffffd
    3e66:	310080e7          	jalr	784(ra) # 1172 <sharedfd>

  bigargtest();
    3e6a:	00000097          	auipc	ra,0x0
    3e6e:	b30080e7          	jalr	-1232(ra) # 399a <bigargtest>
  bigwrite();
    3e72:	fffff097          	auipc	ra,0xfffff
    3e76:	a8e080e7          	jalr	-1394(ra) # 2900 <bigwrite>
  bigargtest();
    3e7a:	00000097          	auipc	ra,0x0
    3e7e:	b20080e7          	jalr	-1248(ra) # 399a <bigargtest>
  bsstest();
    3e82:	00000097          	auipc	ra,0x0
    3e86:	ab2080e7          	jalr	-1358(ra) # 3934 <bsstest>
  sbrktest();
    3e8a:	fffff097          	auipc	ra,0xfffff
    3e8e:	498080e7          	jalr	1176(ra) # 3322 <sbrktest>
  validatetest();
    3e92:	00000097          	auipc	ra,0x0
    3e96:	a1c080e7          	jalr	-1508(ra) # 38ae <validatetest>
  stacktest();
    3e9a:	00000097          	auipc	ra,0x0
    3e9e:	e6e080e7          	jalr	-402(ra) # 3d08 <stacktest>
  
  opentest();
    3ea2:	ffffc097          	auipc	ra,0xffffc
    3ea6:	43c080e7          	jalr	1084(ra) # 2de <opentest>
  writetest();
    3eaa:	ffffc097          	auipc	ra,0xffffc
    3eae:	4cc080e7          	jalr	1228(ra) # 376 <writetest>
  writetest1();
    3eb2:	ffffc097          	auipc	ra,0xffffc
    3eb6:	6a4080e7          	jalr	1700(ra) # 556 <writetest1>
  createtest();
    3eba:	ffffd097          	auipc	ra,0xffffd
    3ebe:	85e080e7          	jalr	-1954(ra) # 718 <createtest>

  openiputtest();
    3ec2:	ffffc097          	auipc	ra,0xffffc
    3ec6:	31c080e7          	jalr	796(ra) # 1de <openiputtest>
  exitiputtest();
    3eca:	ffffc097          	auipc	ra,0xffffc
    3ece:	21e080e7          	jalr	542(ra) # e8 <exitiputtest>
  iputtest();
    3ed2:	ffffc097          	auipc	ra,0xffffc
    3ed6:	12e080e7          	jalr	302(ra) # 0 <iputtest>

  mem();
    3eda:	ffffd097          	auipc	ra,0xffffd
    3ede:	1d2080e7          	jalr	466(ra) # 10ac <mem>
  pipe1();
    3ee2:	ffffd097          	auipc	ra,0xffffd
    3ee6:	a28080e7          	jalr	-1496(ra) # 90a <pipe1>
  preempt();
    3eea:	ffffd097          	auipc	ra,0xffffd
    3eee:	be2080e7          	jalr	-1054(ra) # acc <preempt>
  exitwait();
    3ef2:	ffffd097          	auipc	ra,0xffffd
    3ef6:	d8e080e7          	jalr	-626(ra) # c80 <exitwait>

  rmdot();
    3efa:	fffff097          	auipc	ra,0xfffff
    3efe:	e46080e7          	jalr	-442(ra) # 2d40 <rmdot>
  fourteen();
    3f02:	fffff097          	auipc	ra,0xfffff
    3f06:	cec080e7          	jalr	-788(ra) # 2bee <fourteen>
  bigfile();
    3f0a:	fffff097          	auipc	ra,0xfffff
    3f0e:	af8080e7          	jalr	-1288(ra) # 2a02 <bigfile>
  subdir();
    3f12:	ffffe097          	auipc	ra,0xffffe
    3f16:	258080e7          	jalr	600(ra) # 216a <subdir>
  linktest();
    3f1a:	ffffe097          	auipc	ra,0xffffe
    3f1e:	a5a080e7          	jalr	-1446(ra) # 1974 <linktest>
  unlinkread();
    3f22:	ffffe097          	auipc	ra,0xffffe
    3f26:	88e080e7          	jalr	-1906(ra) # 17b0 <unlinkread>
  dirfile();
    3f2a:	fffff097          	auipc	ra,0xfffff
    3f2e:	fa6080e7          	jalr	-90(ra) # 2ed0 <dirfile>
  iref();
    3f32:	fffff097          	auipc	ra,0xfffff
    3f36:	1da080e7          	jalr	474(ra) # 310c <iref>
  forktest();
    3f3a:	fffff097          	auipc	ra,0xfffff
    3f3e:	2f6080e7          	jalr	758(ra) # 3230 <forktest>
  bigdir(); // slow
    3f42:	ffffe097          	auipc	ra,0xffffe
    3f46:	0b4080e7          	jalr	180(ra) # 1ff6 <bigdir>

  exectest();
    3f4a:	ffffd097          	auipc	ra,0xffffd
    3f4e:	96a080e7          	jalr	-1686(ra) # 8b4 <exectest>

  exit(0);
    3f52:	4501                	li	a0,0
    3f54:	00000097          	auipc	ra,0x0
    3f58:	1fe080e7          	jalr	510(ra) # 4152 <exit>

0000000000003f5c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    3f5c:	1141                	addi	sp,sp,-16
    3f5e:	e422                	sd	s0,8(sp)
    3f60:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    3f62:	87aa                	mv	a5,a0
    3f64:	0585                	addi	a1,a1,1
    3f66:	0785                	addi	a5,a5,1
    3f68:	fff5c703          	lbu	a4,-1(a1)
    3f6c:	fee78fa3          	sb	a4,-1(a5)
    3f70:	fb75                	bnez	a4,3f64 <strcpy+0x8>
    ;
  return os;
}
    3f72:	6422                	ld	s0,8(sp)
    3f74:	0141                	addi	sp,sp,16
    3f76:	8082                	ret

0000000000003f78 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3f78:	1141                	addi	sp,sp,-16
    3f7a:	e422                	sd	s0,8(sp)
    3f7c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    3f7e:	00054783          	lbu	a5,0(a0)
    3f82:	cb91                	beqz	a5,3f96 <strcmp+0x1e>
    3f84:	0005c703          	lbu	a4,0(a1)
    3f88:	00f71763          	bne	a4,a5,3f96 <strcmp+0x1e>
    p++, q++;
    3f8c:	0505                	addi	a0,a0,1
    3f8e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    3f90:	00054783          	lbu	a5,0(a0)
    3f94:	fbe5                	bnez	a5,3f84 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    3f96:	0005c503          	lbu	a0,0(a1)
}
    3f9a:	40a7853b          	subw	a0,a5,a0
    3f9e:	6422                	ld	s0,8(sp)
    3fa0:	0141                	addi	sp,sp,16
    3fa2:	8082                	ret

0000000000003fa4 <strlen>:

uint
strlen(const char *s)
{
    3fa4:	1141                	addi	sp,sp,-16
    3fa6:	e422                	sd	s0,8(sp)
    3fa8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    3faa:	00054783          	lbu	a5,0(a0)
    3fae:	cf91                	beqz	a5,3fca <strlen+0x26>
    3fb0:	0505                	addi	a0,a0,1
    3fb2:	87aa                	mv	a5,a0
    3fb4:	4685                	li	a3,1
    3fb6:	9e89                	subw	a3,a3,a0
    3fb8:	00f6853b          	addw	a0,a3,a5
    3fbc:	0785                	addi	a5,a5,1
    3fbe:	fff7c703          	lbu	a4,-1(a5)
    3fc2:	fb7d                	bnez	a4,3fb8 <strlen+0x14>
    ;
  return n;
}
    3fc4:	6422                	ld	s0,8(sp)
    3fc6:	0141                	addi	sp,sp,16
    3fc8:	8082                	ret
  for(n = 0; s[n]; n++)
    3fca:	4501                	li	a0,0
    3fcc:	bfe5                	j	3fc4 <strlen+0x20>

0000000000003fce <memset>:

void*
memset(void *dst, int c, uint n)
{
    3fce:	1141                	addi	sp,sp,-16
    3fd0:	e422                	sd	s0,8(sp)
    3fd2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    3fd4:	ce09                	beqz	a2,3fee <memset+0x20>
    3fd6:	87aa                	mv	a5,a0
    3fd8:	fff6071b          	addiw	a4,a2,-1
    3fdc:	1702                	slli	a4,a4,0x20
    3fde:	9301                	srli	a4,a4,0x20
    3fe0:	0705                	addi	a4,a4,1
    3fe2:	972a                	add	a4,a4,a0
    cdst[i] = c;
    3fe4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    3fe8:	0785                	addi	a5,a5,1
    3fea:	fee79de3          	bne	a5,a4,3fe4 <memset+0x16>
  }
  return dst;
}
    3fee:	6422                	ld	s0,8(sp)
    3ff0:	0141                	addi	sp,sp,16
    3ff2:	8082                	ret

0000000000003ff4 <strchr>:

char*
strchr(const char *s, char c)
{
    3ff4:	1141                	addi	sp,sp,-16
    3ff6:	e422                	sd	s0,8(sp)
    3ff8:	0800                	addi	s0,sp,16
  for(; *s; s++)
    3ffa:	00054783          	lbu	a5,0(a0)
    3ffe:	cb99                	beqz	a5,4014 <strchr+0x20>
    if(*s == c)
    4000:	00f58763          	beq	a1,a5,400e <strchr+0x1a>
  for(; *s; s++)
    4004:	0505                	addi	a0,a0,1
    4006:	00054783          	lbu	a5,0(a0)
    400a:	fbfd                	bnez	a5,4000 <strchr+0xc>
      return (char*)s;
  return 0;
    400c:	4501                	li	a0,0
}
    400e:	6422                	ld	s0,8(sp)
    4010:	0141                	addi	sp,sp,16
    4012:	8082                	ret
  return 0;
    4014:	4501                	li	a0,0
    4016:	bfe5                	j	400e <strchr+0x1a>

0000000000004018 <gets>:

char*
gets(char *buf, int max)
{
    4018:	711d                	addi	sp,sp,-96
    401a:	ec86                	sd	ra,88(sp)
    401c:	e8a2                	sd	s0,80(sp)
    401e:	e4a6                	sd	s1,72(sp)
    4020:	e0ca                	sd	s2,64(sp)
    4022:	fc4e                	sd	s3,56(sp)
    4024:	f852                	sd	s4,48(sp)
    4026:	f456                	sd	s5,40(sp)
    4028:	f05a                	sd	s6,32(sp)
    402a:	ec5e                	sd	s7,24(sp)
    402c:	1080                	addi	s0,sp,96
    402e:	8baa                	mv	s7,a0
    4030:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4032:	892a                	mv	s2,a0
    4034:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    4036:	4aa9                	li	s5,10
    4038:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    403a:	89a6                	mv	s3,s1
    403c:	2485                	addiw	s1,s1,1
    403e:	0344d863          	bge	s1,s4,406e <gets+0x56>
    cc = read(0, &c, 1);
    4042:	4605                	li	a2,1
    4044:	faf40593          	addi	a1,s0,-81
    4048:	4501                	li	a0,0
    404a:	00000097          	auipc	ra,0x0
    404e:	120080e7          	jalr	288(ra) # 416a <read>
    if(cc < 1)
    4052:	00a05e63          	blez	a0,406e <gets+0x56>
    buf[i++] = c;
    4056:	faf44783          	lbu	a5,-81(s0)
    405a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    405e:	01578763          	beq	a5,s5,406c <gets+0x54>
    4062:	0905                	addi	s2,s2,1
    4064:	fd679be3          	bne	a5,s6,403a <gets+0x22>
  for(i=0; i+1 < max; ){
    4068:	89a6                	mv	s3,s1
    406a:	a011                	j	406e <gets+0x56>
    406c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    406e:	99de                	add	s3,s3,s7
    4070:	00098023          	sb	zero,0(s3)
  return buf;
}
    4074:	855e                	mv	a0,s7
    4076:	60e6                	ld	ra,88(sp)
    4078:	6446                	ld	s0,80(sp)
    407a:	64a6                	ld	s1,72(sp)
    407c:	6906                	ld	s2,64(sp)
    407e:	79e2                	ld	s3,56(sp)
    4080:	7a42                	ld	s4,48(sp)
    4082:	7aa2                	ld	s5,40(sp)
    4084:	7b02                	ld	s6,32(sp)
    4086:	6be2                	ld	s7,24(sp)
    4088:	6125                	addi	sp,sp,96
    408a:	8082                	ret

000000000000408c <stat>:

int
stat(const char *n, struct stat *st)
{
    408c:	1101                	addi	sp,sp,-32
    408e:	ec06                	sd	ra,24(sp)
    4090:	e822                	sd	s0,16(sp)
    4092:	e426                	sd	s1,8(sp)
    4094:	e04a                	sd	s2,0(sp)
    4096:	1000                	addi	s0,sp,32
    4098:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    409a:	4581                	li	a1,0
    409c:	00000097          	auipc	ra,0x0
    40a0:	0f6080e7          	jalr	246(ra) # 4192 <open>
  if(fd < 0)
    40a4:	02054563          	bltz	a0,40ce <stat+0x42>
    40a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    40aa:	85ca                	mv	a1,s2
    40ac:	00000097          	auipc	ra,0x0
    40b0:	0fe080e7          	jalr	254(ra) # 41aa <fstat>
    40b4:	892a                	mv	s2,a0
  close(fd);
    40b6:	8526                	mv	a0,s1
    40b8:	00000097          	auipc	ra,0x0
    40bc:	0c2080e7          	jalr	194(ra) # 417a <close>
  return r;
}
    40c0:	854a                	mv	a0,s2
    40c2:	60e2                	ld	ra,24(sp)
    40c4:	6442                	ld	s0,16(sp)
    40c6:	64a2                	ld	s1,8(sp)
    40c8:	6902                	ld	s2,0(sp)
    40ca:	6105                	addi	sp,sp,32
    40cc:	8082                	ret
    return -1;
    40ce:	597d                	li	s2,-1
    40d0:	bfc5                	j	40c0 <stat+0x34>

00000000000040d2 <atoi>:

int
atoi(const char *s)
{
    40d2:	1141                	addi	sp,sp,-16
    40d4:	e422                	sd	s0,8(sp)
    40d6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    40d8:	00054603          	lbu	a2,0(a0)
    40dc:	fd06079b          	addiw	a5,a2,-48
    40e0:	0ff7f793          	andi	a5,a5,255
    40e4:	4725                	li	a4,9
    40e6:	02f76963          	bltu	a4,a5,4118 <atoi+0x46>
    40ea:	86aa                	mv	a3,a0
  n = 0;
    40ec:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    40ee:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    40f0:	0685                	addi	a3,a3,1
    40f2:	0025179b          	slliw	a5,a0,0x2
    40f6:	9fa9                	addw	a5,a5,a0
    40f8:	0017979b          	slliw	a5,a5,0x1
    40fc:	9fb1                	addw	a5,a5,a2
    40fe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4102:	0006c603          	lbu	a2,0(a3)
    4106:	fd06071b          	addiw	a4,a2,-48
    410a:	0ff77713          	andi	a4,a4,255
    410e:	fee5f1e3          	bgeu	a1,a4,40f0 <atoi+0x1e>
  return n;
}
    4112:	6422                	ld	s0,8(sp)
    4114:	0141                	addi	sp,sp,16
    4116:	8082                	ret
  n = 0;
    4118:	4501                	li	a0,0
    411a:	bfe5                	j	4112 <atoi+0x40>

000000000000411c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    411c:	1141                	addi	sp,sp,-16
    411e:	e422                	sd	s0,8(sp)
    4120:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    4122:	02c05163          	blez	a2,4144 <memmove+0x28>
    4126:	fff6071b          	addiw	a4,a2,-1
    412a:	1702                	slli	a4,a4,0x20
    412c:	9301                	srli	a4,a4,0x20
    412e:	0705                	addi	a4,a4,1
    4130:	972a                	add	a4,a4,a0
  dst = vdst;
    4132:	87aa                	mv	a5,a0
    *dst++ = *src++;
    4134:	0585                	addi	a1,a1,1
    4136:	0785                	addi	a5,a5,1
    4138:	fff5c683          	lbu	a3,-1(a1)
    413c:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    4140:	fee79ae3          	bne	a5,a4,4134 <memmove+0x18>
  return vdst;
}
    4144:	6422                	ld	s0,8(sp)
    4146:	0141                	addi	sp,sp,16
    4148:	8082                	ret

000000000000414a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    414a:	4885                	li	a7,1
 ecall
    414c:	00000073          	ecall
 ret
    4150:	8082                	ret

0000000000004152 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4152:	4889                	li	a7,2
 ecall
    4154:	00000073          	ecall
 ret
    4158:	8082                	ret

000000000000415a <wait>:
.global wait
wait:
 li a7, SYS_wait
    415a:	488d                	li	a7,3
 ecall
    415c:	00000073          	ecall
 ret
    4160:	8082                	ret

0000000000004162 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4162:	4891                	li	a7,4
 ecall
    4164:	00000073          	ecall
 ret
    4168:	8082                	ret

000000000000416a <read>:
.global read
read:
 li a7, SYS_read
    416a:	4895                	li	a7,5
 ecall
    416c:	00000073          	ecall
 ret
    4170:	8082                	ret

0000000000004172 <write>:
.global write
write:
 li a7, SYS_write
    4172:	48c1                	li	a7,16
 ecall
    4174:	00000073          	ecall
 ret
    4178:	8082                	ret

000000000000417a <close>:
.global close
close:
 li a7, SYS_close
    417a:	48d5                	li	a7,21
 ecall
    417c:	00000073          	ecall
 ret
    4180:	8082                	ret

0000000000004182 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4182:	4899                	li	a7,6
 ecall
    4184:	00000073          	ecall
 ret
    4188:	8082                	ret

000000000000418a <exec>:
.global exec
exec:
 li a7, SYS_exec
    418a:	489d                	li	a7,7
 ecall
    418c:	00000073          	ecall
 ret
    4190:	8082                	ret

0000000000004192 <open>:
.global open
open:
 li a7, SYS_open
    4192:	48bd                	li	a7,15
 ecall
    4194:	00000073          	ecall
 ret
    4198:	8082                	ret

000000000000419a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    419a:	48c5                	li	a7,17
 ecall
    419c:	00000073          	ecall
 ret
    41a0:	8082                	ret

00000000000041a2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    41a2:	48c9                	li	a7,18
 ecall
    41a4:	00000073          	ecall
 ret
    41a8:	8082                	ret

00000000000041aa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    41aa:	48a1                	li	a7,8
 ecall
    41ac:	00000073          	ecall
 ret
    41b0:	8082                	ret

00000000000041b2 <link>:
.global link
link:
 li a7, SYS_link
    41b2:	48cd                	li	a7,19
 ecall
    41b4:	00000073          	ecall
 ret
    41b8:	8082                	ret

00000000000041ba <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    41ba:	48d1                	li	a7,20
 ecall
    41bc:	00000073          	ecall
 ret
    41c0:	8082                	ret

00000000000041c2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    41c2:	48a5                	li	a7,9
 ecall
    41c4:	00000073          	ecall
 ret
    41c8:	8082                	ret

00000000000041ca <dup>:
.global dup
dup:
 li a7, SYS_dup
    41ca:	48a9                	li	a7,10
 ecall
    41cc:	00000073          	ecall
 ret
    41d0:	8082                	ret

00000000000041d2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    41d2:	48ad                	li	a7,11
 ecall
    41d4:	00000073          	ecall
 ret
    41d8:	8082                	ret

00000000000041da <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    41da:	48b1                	li	a7,12
 ecall
    41dc:	00000073          	ecall
 ret
    41e0:	8082                	ret

00000000000041e2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    41e2:	48b5                	li	a7,13
 ecall
    41e4:	00000073          	ecall
 ret
    41e8:	8082                	ret

00000000000041ea <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    41ea:	48b9                	li	a7,14
 ecall
    41ec:	00000073          	ecall
 ret
    41f0:	8082                	ret

00000000000041f2 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
    41f2:	48d9                	li	a7,22
 ecall
    41f4:	00000073          	ecall
 ret
    41f8:	8082                	ret

00000000000041fa <crash>:
.global crash
crash:
 li a7, SYS_crash
    41fa:	48dd                	li	a7,23
 ecall
    41fc:	00000073          	ecall
 ret
    4200:	8082                	ret

0000000000004202 <mount>:
.global mount
mount:
 li a7, SYS_mount
    4202:	48e1                	li	a7,24
 ecall
    4204:	00000073          	ecall
 ret
    4208:	8082                	ret

000000000000420a <umount>:
.global umount
umount:
 li a7, SYS_umount
    420a:	48e5                	li	a7,25
 ecall
    420c:	00000073          	ecall
 ret
    4210:	8082                	ret

0000000000004212 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4212:	1101                	addi	sp,sp,-32
    4214:	ec06                	sd	ra,24(sp)
    4216:	e822                	sd	s0,16(sp)
    4218:	1000                	addi	s0,sp,32
    421a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    421e:	4605                	li	a2,1
    4220:	fef40593          	addi	a1,s0,-17
    4224:	00000097          	auipc	ra,0x0
    4228:	f4e080e7          	jalr	-178(ra) # 4172 <write>
}
    422c:	60e2                	ld	ra,24(sp)
    422e:	6442                	ld	s0,16(sp)
    4230:	6105                	addi	sp,sp,32
    4232:	8082                	ret

0000000000004234 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4234:	7139                	addi	sp,sp,-64
    4236:	fc06                	sd	ra,56(sp)
    4238:	f822                	sd	s0,48(sp)
    423a:	f426                	sd	s1,40(sp)
    423c:	f04a                	sd	s2,32(sp)
    423e:	ec4e                	sd	s3,24(sp)
    4240:	0080                	addi	s0,sp,64
    4242:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4244:	c299                	beqz	a3,424a <printint+0x16>
    4246:	0805c863          	bltz	a1,42d6 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    424a:	2581                	sext.w	a1,a1
  neg = 0;
    424c:	4881                	li	a7,0
    424e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    4252:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4254:	2601                	sext.w	a2,a2
    4256:	00002517          	auipc	a0,0x2
    425a:	1d250513          	addi	a0,a0,466 # 6428 <digits>
    425e:	883a                	mv	a6,a4
    4260:	2705                	addiw	a4,a4,1
    4262:	02c5f7bb          	remuw	a5,a1,a2
    4266:	1782                	slli	a5,a5,0x20
    4268:	9381                	srli	a5,a5,0x20
    426a:	97aa                	add	a5,a5,a0
    426c:	0007c783          	lbu	a5,0(a5)
    4270:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4274:	0005879b          	sext.w	a5,a1
    4278:	02c5d5bb          	divuw	a1,a1,a2
    427c:	0685                	addi	a3,a3,1
    427e:	fec7f0e3          	bgeu	a5,a2,425e <printint+0x2a>
  if(neg)
    4282:	00088b63          	beqz	a7,4298 <printint+0x64>
    buf[i++] = '-';
    4286:	fd040793          	addi	a5,s0,-48
    428a:	973e                	add	a4,a4,a5
    428c:	02d00793          	li	a5,45
    4290:	fef70823          	sb	a5,-16(a4)
    4294:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    4298:	02e05863          	blez	a4,42c8 <printint+0x94>
    429c:	fc040793          	addi	a5,s0,-64
    42a0:	00e78933          	add	s2,a5,a4
    42a4:	fff78993          	addi	s3,a5,-1
    42a8:	99ba                	add	s3,s3,a4
    42aa:	377d                	addiw	a4,a4,-1
    42ac:	1702                	slli	a4,a4,0x20
    42ae:	9301                	srli	a4,a4,0x20
    42b0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    42b4:	fff94583          	lbu	a1,-1(s2)
    42b8:	8526                	mv	a0,s1
    42ba:	00000097          	auipc	ra,0x0
    42be:	f58080e7          	jalr	-168(ra) # 4212 <putc>
  while(--i >= 0)
    42c2:	197d                	addi	s2,s2,-1
    42c4:	ff3918e3          	bne	s2,s3,42b4 <printint+0x80>
}
    42c8:	70e2                	ld	ra,56(sp)
    42ca:	7442                	ld	s0,48(sp)
    42cc:	74a2                	ld	s1,40(sp)
    42ce:	7902                	ld	s2,32(sp)
    42d0:	69e2                	ld	s3,24(sp)
    42d2:	6121                	addi	sp,sp,64
    42d4:	8082                	ret
    x = -xx;
    42d6:	40b005bb          	negw	a1,a1
    neg = 1;
    42da:	4885                	li	a7,1
    x = -xx;
    42dc:	bf8d                	j	424e <printint+0x1a>

00000000000042de <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    42de:	7119                	addi	sp,sp,-128
    42e0:	fc86                	sd	ra,120(sp)
    42e2:	f8a2                	sd	s0,112(sp)
    42e4:	f4a6                	sd	s1,104(sp)
    42e6:	f0ca                	sd	s2,96(sp)
    42e8:	ecce                	sd	s3,88(sp)
    42ea:	e8d2                	sd	s4,80(sp)
    42ec:	e4d6                	sd	s5,72(sp)
    42ee:	e0da                	sd	s6,64(sp)
    42f0:	fc5e                	sd	s7,56(sp)
    42f2:	f862                	sd	s8,48(sp)
    42f4:	f466                	sd	s9,40(sp)
    42f6:	f06a                	sd	s10,32(sp)
    42f8:	ec6e                	sd	s11,24(sp)
    42fa:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    42fc:	0005c903          	lbu	s2,0(a1)
    4300:	18090f63          	beqz	s2,449e <vprintf+0x1c0>
    4304:	8aaa                	mv	s5,a0
    4306:	8b32                	mv	s6,a2
    4308:	00158493          	addi	s1,a1,1
  state = 0;
    430c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    430e:	02500a13          	li	s4,37
      if(c == 'd'){
    4312:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    4316:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    431a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    431e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4322:	00002b97          	auipc	s7,0x2
    4326:	106b8b93          	addi	s7,s7,262 # 6428 <digits>
    432a:	a839                	j	4348 <vprintf+0x6a>
        putc(fd, c);
    432c:	85ca                	mv	a1,s2
    432e:	8556                	mv	a0,s5
    4330:	00000097          	auipc	ra,0x0
    4334:	ee2080e7          	jalr	-286(ra) # 4212 <putc>
    4338:	a019                	j	433e <vprintf+0x60>
    } else if(state == '%'){
    433a:	01498f63          	beq	s3,s4,4358 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    433e:	0485                	addi	s1,s1,1
    4340:	fff4c903          	lbu	s2,-1(s1)
    4344:	14090d63          	beqz	s2,449e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    4348:	0009079b          	sext.w	a5,s2
    if(state == 0){
    434c:	fe0997e3          	bnez	s3,433a <vprintf+0x5c>
      if(c == '%'){
    4350:	fd479ee3          	bne	a5,s4,432c <vprintf+0x4e>
        state = '%';
    4354:	89be                	mv	s3,a5
    4356:	b7e5                	j	433e <vprintf+0x60>
      if(c == 'd'){
    4358:	05878063          	beq	a5,s8,4398 <vprintf+0xba>
      } else if(c == 'l') {
    435c:	05978c63          	beq	a5,s9,43b4 <vprintf+0xd6>
      } else if(c == 'x') {
    4360:	07a78863          	beq	a5,s10,43d0 <vprintf+0xf2>
      } else if(c == 'p') {
    4364:	09b78463          	beq	a5,s11,43ec <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    4368:	07300713          	li	a4,115
    436c:	0ce78663          	beq	a5,a4,4438 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4370:	06300713          	li	a4,99
    4374:	0ee78e63          	beq	a5,a4,4470 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    4378:	11478863          	beq	a5,s4,4488 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    437c:	85d2                	mv	a1,s4
    437e:	8556                	mv	a0,s5
    4380:	00000097          	auipc	ra,0x0
    4384:	e92080e7          	jalr	-366(ra) # 4212 <putc>
        putc(fd, c);
    4388:	85ca                	mv	a1,s2
    438a:	8556                	mv	a0,s5
    438c:	00000097          	auipc	ra,0x0
    4390:	e86080e7          	jalr	-378(ra) # 4212 <putc>
      }
      state = 0;
    4394:	4981                	li	s3,0
    4396:	b765                	j	433e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    4398:	008b0913          	addi	s2,s6,8
    439c:	4685                	li	a3,1
    439e:	4629                	li	a2,10
    43a0:	000b2583          	lw	a1,0(s6)
    43a4:	8556                	mv	a0,s5
    43a6:	00000097          	auipc	ra,0x0
    43aa:	e8e080e7          	jalr	-370(ra) # 4234 <printint>
    43ae:	8b4a                	mv	s6,s2
      state = 0;
    43b0:	4981                	li	s3,0
    43b2:	b771                	j	433e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    43b4:	008b0913          	addi	s2,s6,8
    43b8:	4681                	li	a3,0
    43ba:	4629                	li	a2,10
    43bc:	000b2583          	lw	a1,0(s6)
    43c0:	8556                	mv	a0,s5
    43c2:	00000097          	auipc	ra,0x0
    43c6:	e72080e7          	jalr	-398(ra) # 4234 <printint>
    43ca:	8b4a                	mv	s6,s2
      state = 0;
    43cc:	4981                	li	s3,0
    43ce:	bf85                	j	433e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    43d0:	008b0913          	addi	s2,s6,8
    43d4:	4681                	li	a3,0
    43d6:	4641                	li	a2,16
    43d8:	000b2583          	lw	a1,0(s6)
    43dc:	8556                	mv	a0,s5
    43de:	00000097          	auipc	ra,0x0
    43e2:	e56080e7          	jalr	-426(ra) # 4234 <printint>
    43e6:	8b4a                	mv	s6,s2
      state = 0;
    43e8:	4981                	li	s3,0
    43ea:	bf91                	j	433e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    43ec:	008b0793          	addi	a5,s6,8
    43f0:	f8f43423          	sd	a5,-120(s0)
    43f4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    43f8:	03000593          	li	a1,48
    43fc:	8556                	mv	a0,s5
    43fe:	00000097          	auipc	ra,0x0
    4402:	e14080e7          	jalr	-492(ra) # 4212 <putc>
  putc(fd, 'x');
    4406:	85ea                	mv	a1,s10
    4408:	8556                	mv	a0,s5
    440a:	00000097          	auipc	ra,0x0
    440e:	e08080e7          	jalr	-504(ra) # 4212 <putc>
    4412:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4414:	03c9d793          	srli	a5,s3,0x3c
    4418:	97de                	add	a5,a5,s7
    441a:	0007c583          	lbu	a1,0(a5)
    441e:	8556                	mv	a0,s5
    4420:	00000097          	auipc	ra,0x0
    4424:	df2080e7          	jalr	-526(ra) # 4212 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    4428:	0992                	slli	s3,s3,0x4
    442a:	397d                	addiw	s2,s2,-1
    442c:	fe0914e3          	bnez	s2,4414 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    4430:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    4434:	4981                	li	s3,0
    4436:	b721                	j	433e <vprintf+0x60>
        s = va_arg(ap, char*);
    4438:	008b0993          	addi	s3,s6,8
    443c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    4440:	02090163          	beqz	s2,4462 <vprintf+0x184>
        while(*s != 0){
    4444:	00094583          	lbu	a1,0(s2)
    4448:	c9a1                	beqz	a1,4498 <vprintf+0x1ba>
          putc(fd, *s);
    444a:	8556                	mv	a0,s5
    444c:	00000097          	auipc	ra,0x0
    4450:	dc6080e7          	jalr	-570(ra) # 4212 <putc>
          s++;
    4454:	0905                	addi	s2,s2,1
        while(*s != 0){
    4456:	00094583          	lbu	a1,0(s2)
    445a:	f9e5                	bnez	a1,444a <vprintf+0x16c>
        s = va_arg(ap, char*);
    445c:	8b4e                	mv	s6,s3
      state = 0;
    445e:	4981                	li	s3,0
    4460:	bdf9                	j	433e <vprintf+0x60>
          s = "(null)";
    4462:	00002917          	auipc	s2,0x2
    4466:	fbe90913          	addi	s2,s2,-66 # 6420 <malloc+0x1e78>
        while(*s != 0){
    446a:	02800593          	li	a1,40
    446e:	bff1                	j	444a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    4470:	008b0913          	addi	s2,s6,8
    4474:	000b4583          	lbu	a1,0(s6)
    4478:	8556                	mv	a0,s5
    447a:	00000097          	auipc	ra,0x0
    447e:	d98080e7          	jalr	-616(ra) # 4212 <putc>
    4482:	8b4a                	mv	s6,s2
      state = 0;
    4484:	4981                	li	s3,0
    4486:	bd65                	j	433e <vprintf+0x60>
        putc(fd, c);
    4488:	85d2                	mv	a1,s4
    448a:	8556                	mv	a0,s5
    448c:	00000097          	auipc	ra,0x0
    4490:	d86080e7          	jalr	-634(ra) # 4212 <putc>
      state = 0;
    4494:	4981                	li	s3,0
    4496:	b565                	j	433e <vprintf+0x60>
        s = va_arg(ap, char*);
    4498:	8b4e                	mv	s6,s3
      state = 0;
    449a:	4981                	li	s3,0
    449c:	b54d                	j	433e <vprintf+0x60>
    }
  }
}
    449e:	70e6                	ld	ra,120(sp)
    44a0:	7446                	ld	s0,112(sp)
    44a2:	74a6                	ld	s1,104(sp)
    44a4:	7906                	ld	s2,96(sp)
    44a6:	69e6                	ld	s3,88(sp)
    44a8:	6a46                	ld	s4,80(sp)
    44aa:	6aa6                	ld	s5,72(sp)
    44ac:	6b06                	ld	s6,64(sp)
    44ae:	7be2                	ld	s7,56(sp)
    44b0:	7c42                	ld	s8,48(sp)
    44b2:	7ca2                	ld	s9,40(sp)
    44b4:	7d02                	ld	s10,32(sp)
    44b6:	6de2                	ld	s11,24(sp)
    44b8:	6109                	addi	sp,sp,128
    44ba:	8082                	ret

00000000000044bc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    44bc:	715d                	addi	sp,sp,-80
    44be:	ec06                	sd	ra,24(sp)
    44c0:	e822                	sd	s0,16(sp)
    44c2:	1000                	addi	s0,sp,32
    44c4:	e010                	sd	a2,0(s0)
    44c6:	e414                	sd	a3,8(s0)
    44c8:	e818                	sd	a4,16(s0)
    44ca:	ec1c                	sd	a5,24(s0)
    44cc:	03043023          	sd	a6,32(s0)
    44d0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    44d4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    44d8:	8622                	mv	a2,s0
    44da:	00000097          	auipc	ra,0x0
    44de:	e04080e7          	jalr	-508(ra) # 42de <vprintf>
}
    44e2:	60e2                	ld	ra,24(sp)
    44e4:	6442                	ld	s0,16(sp)
    44e6:	6161                	addi	sp,sp,80
    44e8:	8082                	ret

00000000000044ea <printf>:

void
printf(const char *fmt, ...)
{
    44ea:	711d                	addi	sp,sp,-96
    44ec:	ec06                	sd	ra,24(sp)
    44ee:	e822                	sd	s0,16(sp)
    44f0:	1000                	addi	s0,sp,32
    44f2:	e40c                	sd	a1,8(s0)
    44f4:	e810                	sd	a2,16(s0)
    44f6:	ec14                	sd	a3,24(s0)
    44f8:	f018                	sd	a4,32(s0)
    44fa:	f41c                	sd	a5,40(s0)
    44fc:	03043823          	sd	a6,48(s0)
    4500:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    4504:	00840613          	addi	a2,s0,8
    4508:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    450c:	85aa                	mv	a1,a0
    450e:	4505                	li	a0,1
    4510:	00000097          	auipc	ra,0x0
    4514:	dce080e7          	jalr	-562(ra) # 42de <vprintf>
}
    4518:	60e2                	ld	ra,24(sp)
    451a:	6442                	ld	s0,16(sp)
    451c:	6125                	addi	sp,sp,96
    451e:	8082                	ret

0000000000004520 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4520:	1141                	addi	sp,sp,-16
    4522:	e422                	sd	s0,8(sp)
    4524:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4526:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    452a:	00002797          	auipc	a5,0x2
    452e:	f4e7b783          	ld	a5,-178(a5) # 6478 <freep>
    4532:	a805                	j	4562 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    4534:	4618                	lw	a4,8(a2)
    4536:	9db9                	addw	a1,a1,a4
    4538:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    453c:	6398                	ld	a4,0(a5)
    453e:	6318                	ld	a4,0(a4)
    4540:	fee53823          	sd	a4,-16(a0)
    4544:	a091                	j	4588 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    4546:	ff852703          	lw	a4,-8(a0)
    454a:	9e39                	addw	a2,a2,a4
    454c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    454e:	ff053703          	ld	a4,-16(a0)
    4552:	e398                	sd	a4,0(a5)
    4554:	a099                	j	459a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4556:	6398                	ld	a4,0(a5)
    4558:	00e7e463          	bltu	a5,a4,4560 <free+0x40>
    455c:	00e6ea63          	bltu	a3,a4,4570 <free+0x50>
{
    4560:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4562:	fed7fae3          	bgeu	a5,a3,4556 <free+0x36>
    4566:	6398                	ld	a4,0(a5)
    4568:	00e6e463          	bltu	a3,a4,4570 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    456c:	fee7eae3          	bltu	a5,a4,4560 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    4570:	ff852583          	lw	a1,-8(a0)
    4574:	6390                	ld	a2,0(a5)
    4576:	02059713          	slli	a4,a1,0x20
    457a:	9301                	srli	a4,a4,0x20
    457c:	0712                	slli	a4,a4,0x4
    457e:	9736                	add	a4,a4,a3
    4580:	fae60ae3          	beq	a2,a4,4534 <free+0x14>
    bp->s.ptr = p->s.ptr;
    4584:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    4588:	4790                	lw	a2,8(a5)
    458a:	02061713          	slli	a4,a2,0x20
    458e:	9301                	srli	a4,a4,0x20
    4590:	0712                	slli	a4,a4,0x4
    4592:	973e                	add	a4,a4,a5
    4594:	fae689e3          	beq	a3,a4,4546 <free+0x26>
  } else
    p->s.ptr = bp;
    4598:	e394                	sd	a3,0(a5)
  freep = p;
    459a:	00002717          	auipc	a4,0x2
    459e:	ecf73f23          	sd	a5,-290(a4) # 6478 <freep>
}
    45a2:	6422                	ld	s0,8(sp)
    45a4:	0141                	addi	sp,sp,16
    45a6:	8082                	ret

00000000000045a8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    45a8:	7139                	addi	sp,sp,-64
    45aa:	fc06                	sd	ra,56(sp)
    45ac:	f822                	sd	s0,48(sp)
    45ae:	f426                	sd	s1,40(sp)
    45b0:	f04a                	sd	s2,32(sp)
    45b2:	ec4e                	sd	s3,24(sp)
    45b4:	e852                	sd	s4,16(sp)
    45b6:	e456                	sd	s5,8(sp)
    45b8:	e05a                	sd	s6,0(sp)
    45ba:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    45bc:	02051493          	slli	s1,a0,0x20
    45c0:	9081                	srli	s1,s1,0x20
    45c2:	04bd                	addi	s1,s1,15
    45c4:	8091                	srli	s1,s1,0x4
    45c6:	0014899b          	addiw	s3,s1,1
    45ca:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    45cc:	00002517          	auipc	a0,0x2
    45d0:	eac53503          	ld	a0,-340(a0) # 6478 <freep>
    45d4:	c515                	beqz	a0,4600 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    45d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    45d8:	4798                	lw	a4,8(a5)
    45da:	02977f63          	bgeu	a4,s1,4618 <malloc+0x70>
    45de:	8a4e                	mv	s4,s3
    45e0:	0009871b          	sext.w	a4,s3
    45e4:	6685                	lui	a3,0x1
    45e6:	00d77363          	bgeu	a4,a3,45ec <malloc+0x44>
    45ea:	6a05                	lui	s4,0x1
    45ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    45f0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    45f4:	00002917          	auipc	s2,0x2
    45f8:	e8490913          	addi	s2,s2,-380 # 6478 <freep>
  if(p == (char*)-1)
    45fc:	5afd                	li	s5,-1
    45fe:	a88d                	j	4670 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    4600:	00007797          	auipc	a5,0x7
    4604:	69078793          	addi	a5,a5,1680 # bc90 <base>
    4608:	00002717          	auipc	a4,0x2
    460c:	e6f73823          	sd	a5,-400(a4) # 6478 <freep>
    4610:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    4612:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    4616:	b7e1                	j	45de <malloc+0x36>
      if(p->s.size == nunits)
    4618:	02e48b63          	beq	s1,a4,464e <malloc+0xa6>
        p->s.size -= nunits;
    461c:	4137073b          	subw	a4,a4,s3
    4620:	c798                	sw	a4,8(a5)
        p += p->s.size;
    4622:	1702                	slli	a4,a4,0x20
    4624:	9301                	srli	a4,a4,0x20
    4626:	0712                	slli	a4,a4,0x4
    4628:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    462a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    462e:	00002717          	auipc	a4,0x2
    4632:	e4a73523          	sd	a0,-438(a4) # 6478 <freep>
      return (void*)(p + 1);
    4636:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    463a:	70e2                	ld	ra,56(sp)
    463c:	7442                	ld	s0,48(sp)
    463e:	74a2                	ld	s1,40(sp)
    4640:	7902                	ld	s2,32(sp)
    4642:	69e2                	ld	s3,24(sp)
    4644:	6a42                	ld	s4,16(sp)
    4646:	6aa2                	ld	s5,8(sp)
    4648:	6b02                	ld	s6,0(sp)
    464a:	6121                	addi	sp,sp,64
    464c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    464e:	6398                	ld	a4,0(a5)
    4650:	e118                	sd	a4,0(a0)
    4652:	bff1                	j	462e <malloc+0x86>
  hp->s.size = nu;
    4654:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    4658:	0541                	addi	a0,a0,16
    465a:	00000097          	auipc	ra,0x0
    465e:	ec6080e7          	jalr	-314(ra) # 4520 <free>
  return freep;
    4662:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    4666:	d971                	beqz	a0,463a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4668:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    466a:	4798                	lw	a4,8(a5)
    466c:	fa9776e3          	bgeu	a4,s1,4618 <malloc+0x70>
    if(p == freep)
    4670:	00093703          	ld	a4,0(s2)
    4674:	853e                	mv	a0,a5
    4676:	fef719e3          	bne	a4,a5,4668 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    467a:	8552                	mv	a0,s4
    467c:	00000097          	auipc	ra,0x0
    4680:	b5e080e7          	jalr	-1186(ra) # 41da <sbrk>
  if(p == (char*)-1)
    4684:	fd5518e3          	bne	a0,s5,4654 <malloc+0xac>
        return 0;
    4688:	4501                	li	a0,0
    468a:	bf45                	j	463a <malloc+0x92>
