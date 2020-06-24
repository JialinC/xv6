
user/_mounttest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
  test4();
  exit(0);
}

void test0()
{
       0:	7139                	addi	sp,sp,-64
       2:	fc06                	sd	ra,56(sp)
       4:	f822                	sd	s0,48(sp)
       6:	f426                	sd	s1,40(sp)
       8:	0080                	addi	s0,sp,64
  int fd;
  char buf[4];
  struct stat st;
  
  printf("test0 start\n");
       a:	00001517          	auipc	a0,0x1
       e:	1d650513          	addi	a0,a0,470 # 11e0 <malloc+0xe4>
      12:	00001097          	auipc	ra,0x1
      16:	02c080e7          	jalr	44(ra) # 103e <printf>

  mknod("disk1", DISK, 1);
      1a:	4605                	li	a2,1
      1c:	4581                	li	a1,0
      1e:	00001517          	auipc	a0,0x1
      22:	1d250513          	addi	a0,a0,466 # 11f0 <malloc+0xf4>
      26:	00001097          	auipc	ra,0x1
      2a:	cc8080e7          	jalr	-824(ra) # cee <mknod>
  mkdir("/m");
      2e:	00001517          	auipc	a0,0x1
      32:	1ca50513          	addi	a0,a0,458 # 11f8 <malloc+0xfc>
      36:	00001097          	auipc	ra,0x1
      3a:	cd8080e7          	jalr	-808(ra) # d0e <mkdir>
  
  if (mount("/disk1", "/m") < 0) {
      3e:	00001597          	auipc	a1,0x1
      42:	1ba58593          	addi	a1,a1,442 # 11f8 <malloc+0xfc>
      46:	00001517          	auipc	a0,0x1
      4a:	1ba50513          	addi	a0,a0,442 # 1200 <malloc+0x104>
      4e:	00001097          	auipc	ra,0x1
      52:	d08080e7          	jalr	-760(ra) # d56 <mount>
      56:	1a054663          	bltz	a0,202 <test0+0x202>
    printf("mount failed\n");
    exit(-1);
  }    

  if (stat("/m", &st) < 0) {
      5a:	fc040593          	addi	a1,s0,-64
      5e:	00001517          	auipc	a0,0x1
      62:	19a50513          	addi	a0,a0,410 # 11f8 <malloc+0xfc>
      66:	00001097          	auipc	ra,0x1
      6a:	b7a080e7          	jalr	-1158(ra) # be0 <stat>
      6e:	1a054763          	bltz	a0,21c <test0+0x21c>
    printf("stat /m failed\n");
    exit(-1);
  }

  if (st.ino != 1 || minor(st.dev) != 1) {
      72:	f00017b7          	lui	a5,0xf0001
      76:	fc043703          	ld	a4,-64(s0)
      7a:	0792                	slli	a5,a5,0x4
      7c:	17fd                	addi	a5,a5,-1
      7e:	8f7d                	and	a4,a4,a5
      80:	4785                	li	a5,1
      82:	1782                	slli	a5,a5,0x20
      84:	0785                	addi	a5,a5,1
      86:	1af71863          	bne	a4,a5,236 <test0+0x236>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
    exit(-1);
  }
  
  if ((fd = open("/m/README", O_RDONLY)) < 0) {
      8a:	4581                	li	a1,0
      8c:	00001517          	auipc	a0,0x1
      90:	1bc50513          	addi	a0,a0,444 # 1248 <malloc+0x14c>
      94:	00001097          	auipc	ra,0x1
      98:	c52080e7          	jalr	-942(ra) # ce6 <open>
      9c:	84aa                	mv	s1,a0
      9e:	1a054d63          	bltz	a0,258 <test0+0x258>
    printf("open read failed\n");
    exit(-1);
  }
  if (read(fd, buf, sizeof(buf)-1) != sizeof(buf)-1) {
      a2:	460d                	li	a2,3
      a4:	fd840593          	addi	a1,s0,-40
      a8:	00001097          	auipc	ra,0x1
      ac:	c16080e7          	jalr	-1002(ra) # cbe <read>
      b0:	478d                	li	a5,3
      b2:	1cf51063          	bne	a0,a5,272 <test0+0x272>
    printf("read failed\n");
    exit(-1);
  }
  if (strcmp("xv6", buf) != 0) {
      b6:	fd840593          	addi	a1,s0,-40
      ba:	00001517          	auipc	a0,0x1
      be:	1c650513          	addi	a0,a0,454 # 1280 <malloc+0x184>
      c2:	00001097          	auipc	ra,0x1
      c6:	a0a080e7          	jalr	-1526(ra) # acc <strcmp>
      ca:	1c051163          	bnez	a0,28c <test0+0x28c>
    printf("read failed\n", buf);
  }
  close(fd);
      ce:	8526                	mv	a0,s1
      d0:	00001097          	auipc	ra,0x1
      d4:	bfe080e7          	jalr	-1026(ra) # cce <close>
  
  if ((fd = open("/m/a", O_CREATE|O_WRONLY)) < 0) {
      d8:	20100593          	li	a1,513
      dc:	00001517          	auipc	a0,0x1
      e0:	1ac50513          	addi	a0,a0,428 # 1288 <malloc+0x18c>
      e4:	00001097          	auipc	ra,0x1
      e8:	c02080e7          	jalr	-1022(ra) # ce6 <open>
      ec:	84aa                	mv	s1,a0
      ee:	1a054a63          	bltz	a0,2a2 <test0+0x2a2>
    printf("open write failed\n");
    exit(-1);
  }
  
  if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
      f2:	4611                	li	a2,4
      f4:	fd840593          	addi	a1,s0,-40
      f8:	00001097          	auipc	ra,0x1
      fc:	bce080e7          	jalr	-1074(ra) # cc6 <write>
     100:	4791                	li	a5,4
     102:	1af51d63          	bne	a0,a5,2bc <test0+0x2bc>
    printf("write failed\n");
    exit(-1);
  }

  close(fd);
     106:	8526                	mv	a0,s1
     108:	00001097          	auipc	ra,0x1
     10c:	bc6080e7          	jalr	-1082(ra) # cce <close>

  if (stat("/m/a", &st) < 0) {
     110:	fc040593          	addi	a1,s0,-64
     114:	00001517          	auipc	a0,0x1
     118:	17450513          	addi	a0,a0,372 # 1288 <malloc+0x18c>
     11c:	00001097          	auipc	ra,0x1
     120:	ac4080e7          	jalr	-1340(ra) # be0 <stat>
     124:	1a054963          	bltz	a0,2d6 <test0+0x2d6>
    printf("stat /m/a failed\n");
    exit(-1);
  }

  if (minor(st.dev) != 1) {
     128:	fc045583          	lhu	a1,-64(s0)
     12c:	4785                	li	a5,1
     12e:	1cf59163          	bne	a1,a5,2f0 <test0+0x2f0>
    printf("stat wrong minor %d\n", minor(st.dev));
    exit(-1);
  }


  if (link("m/a", "/a") == 0) {
     132:	00001597          	auipc	a1,0x1
     136:	1b658593          	addi	a1,a1,438 # 12e8 <malloc+0x1ec>
     13a:	00001517          	auipc	a0,0x1
     13e:	1b650513          	addi	a0,a0,438 # 12f0 <malloc+0x1f4>
     142:	00001097          	auipc	ra,0x1
     146:	bc4080e7          	jalr	-1084(ra) # d06 <link>
     14a:	1c050063          	beqz	a0,30a <test0+0x30a>
    printf("link m/a a succeeded\n");
    exit(-1);
  }

  if (unlink("m/a") < 0) {
     14e:	00001517          	auipc	a0,0x1
     152:	1a250513          	addi	a0,a0,418 # 12f0 <malloc+0x1f4>
     156:	00001097          	auipc	ra,0x1
     15a:	ba0080e7          	jalr	-1120(ra) # cf6 <unlink>
     15e:	1c054363          	bltz	a0,324 <test0+0x324>
    printf("unlink m/a failed\n");
    exit(-1);
  }

  if (chdir("/m") < 0) {
     162:	00001517          	auipc	a0,0x1
     166:	09650513          	addi	a0,a0,150 # 11f8 <malloc+0xfc>
     16a:	00001097          	auipc	ra,0x1
     16e:	bac080e7          	jalr	-1108(ra) # d16 <chdir>
     172:	1c054663          	bltz	a0,33e <test0+0x33e>
    printf("chdir /m failed\n");
    exit(-1);
  }

  if (stat(".", &st) < 0) {
     176:	fc040593          	addi	a1,s0,-64
     17a:	00001517          	auipc	a0,0x1
     17e:	1c650513          	addi	a0,a0,454 # 1340 <malloc+0x244>
     182:	00001097          	auipc	ra,0x1
     186:	a5e080e7          	jalr	-1442(ra) # be0 <stat>
     18a:	1c054763          	bltz	a0,358 <test0+0x358>
    printf("stat . failed\n");
    exit(-1);
  }

  if (st.ino != 1 || minor(st.dev) != 1) {
     18e:	f00017b7          	lui	a5,0xf0001
     192:	fc043703          	ld	a4,-64(s0)
     196:	0792                	slli	a5,a5,0x4
     198:	17fd                	addi	a5,a5,-1
     19a:	8f7d                	and	a4,a4,a5
     19c:	4785                	li	a5,1
     19e:	1782                	slli	a5,a5,0x20
     1a0:	0785                	addi	a5,a5,1
     1a2:	1cf71863          	bne	a4,a5,372 <test0+0x372>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
    exit(-1);
  }

  if (chdir("..") < 0) {
     1a6:	00001517          	auipc	a0,0x1
     1aa:	1b250513          	addi	a0,a0,434 # 1358 <malloc+0x25c>
     1ae:	00001097          	auipc	ra,0x1
     1b2:	b68080e7          	jalr	-1176(ra) # d16 <chdir>
     1b6:	1c054f63          	bltz	a0,394 <test0+0x394>
    printf("chdir .. failed\n");
    exit(-1);
  }

  if (stat(".", &st) < 0) {
     1ba:	fc040593          	addi	a1,s0,-64
     1be:	00001517          	auipc	a0,0x1
     1c2:	18250513          	addi	a0,a0,386 # 1340 <malloc+0x244>
     1c6:	00001097          	auipc	ra,0x1
     1ca:	a1a080e7          	jalr	-1510(ra) # be0 <stat>
     1ce:	1e054063          	bltz	a0,3ae <test0+0x3ae>
    printf("stat . failed\n");
    exit(-1);
  }

  if (st.ino == 1 && minor(st.dev) == 0) {
     1d2:	f00017b7          	lui	a5,0xf0001
     1d6:	fc043703          	ld	a4,-64(s0)
     1da:	0792                	slli	a5,a5,0x4
     1dc:	17fd                	addi	a5,a5,-1
     1de:	8ff9                	and	a5,a5,a4
     1e0:	4705                	li	a4,1
     1e2:	1702                	slli	a4,a4,0x20
     1e4:	1ee78263          	beq	a5,a4,3c8 <test0+0x3c8>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
    exit(-1);
  }

  printf("test0 done\n");
     1e8:	00001517          	auipc	a0,0x1
     1ec:	19050513          	addi	a0,a0,400 # 1378 <malloc+0x27c>
     1f0:	00001097          	auipc	ra,0x1
     1f4:	e4e080e7          	jalr	-434(ra) # 103e <printf>
}
     1f8:	70e2                	ld	ra,56(sp)
     1fa:	7442                	ld	s0,48(sp)
     1fc:	74a2                	ld	s1,40(sp)
     1fe:	6121                	addi	sp,sp,64
     200:	8082                	ret
    printf("mount failed\n");
     202:	00001517          	auipc	a0,0x1
     206:	00650513          	addi	a0,a0,6 # 1208 <malloc+0x10c>
     20a:	00001097          	auipc	ra,0x1
     20e:	e34080e7          	jalr	-460(ra) # 103e <printf>
    exit(-1);
     212:	557d                	li	a0,-1
     214:	00001097          	auipc	ra,0x1
     218:	a92080e7          	jalr	-1390(ra) # ca6 <exit>
    printf("stat /m failed\n");
     21c:	00001517          	auipc	a0,0x1
     220:	ffc50513          	addi	a0,a0,-4 # 1218 <malloc+0x11c>
     224:	00001097          	auipc	ra,0x1
     228:	e1a080e7          	jalr	-486(ra) # 103e <printf>
    exit(-1);
     22c:	557d                	li	a0,-1
     22e:	00001097          	auipc	ra,0x1
     232:	a78080e7          	jalr	-1416(ra) # ca6 <exit>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
     236:	fc045603          	lhu	a2,-64(s0)
     23a:	fc442583          	lw	a1,-60(s0)
     23e:	00001517          	auipc	a0,0x1
     242:	fea50513          	addi	a0,a0,-22 # 1228 <malloc+0x12c>
     246:	00001097          	auipc	ra,0x1
     24a:	df8080e7          	jalr	-520(ra) # 103e <printf>
    exit(-1);
     24e:	557d                	li	a0,-1
     250:	00001097          	auipc	ra,0x1
     254:	a56080e7          	jalr	-1450(ra) # ca6 <exit>
    printf("open read failed\n");
     258:	00001517          	auipc	a0,0x1
     25c:	00050513          	mv	a0,a0
     260:	00001097          	auipc	ra,0x1
     264:	dde080e7          	jalr	-546(ra) # 103e <printf>
    exit(-1);
     268:	557d                	li	a0,-1
     26a:	00001097          	auipc	ra,0x1
     26e:	a3c080e7          	jalr	-1476(ra) # ca6 <exit>
    printf("read failed\n");
     272:	00001517          	auipc	a0,0x1
     276:	ffe50513          	addi	a0,a0,-2 # 1270 <malloc+0x174>
     27a:	00001097          	auipc	ra,0x1
     27e:	dc4080e7          	jalr	-572(ra) # 103e <printf>
    exit(-1);
     282:	557d                	li	a0,-1
     284:	00001097          	auipc	ra,0x1
     288:	a22080e7          	jalr	-1502(ra) # ca6 <exit>
    printf("read failed\n", buf);
     28c:	fd840593          	addi	a1,s0,-40
     290:	00001517          	auipc	a0,0x1
     294:	fe050513          	addi	a0,a0,-32 # 1270 <malloc+0x174>
     298:	00001097          	auipc	ra,0x1
     29c:	da6080e7          	jalr	-602(ra) # 103e <printf>
     2a0:	b53d                	j	ce <test0+0xce>
    printf("open write failed\n");
     2a2:	00001517          	auipc	a0,0x1
     2a6:	fee50513          	addi	a0,a0,-18 # 1290 <malloc+0x194>
     2aa:	00001097          	auipc	ra,0x1
     2ae:	d94080e7          	jalr	-620(ra) # 103e <printf>
    exit(-1);
     2b2:	557d                	li	a0,-1
     2b4:	00001097          	auipc	ra,0x1
     2b8:	9f2080e7          	jalr	-1550(ra) # ca6 <exit>
    printf("write failed\n");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	fec50513          	addi	a0,a0,-20 # 12a8 <malloc+0x1ac>
     2c4:	00001097          	auipc	ra,0x1
     2c8:	d7a080e7          	jalr	-646(ra) # 103e <printf>
    exit(-1);
     2cc:	557d                	li	a0,-1
     2ce:	00001097          	auipc	ra,0x1
     2d2:	9d8080e7          	jalr	-1576(ra) # ca6 <exit>
    printf("stat /m/a failed\n");
     2d6:	00001517          	auipc	a0,0x1
     2da:	fe250513          	addi	a0,a0,-30 # 12b8 <malloc+0x1bc>
     2de:	00001097          	auipc	ra,0x1
     2e2:	d60080e7          	jalr	-672(ra) # 103e <printf>
    exit(-1);
     2e6:	557d                	li	a0,-1
     2e8:	00001097          	auipc	ra,0x1
     2ec:	9be080e7          	jalr	-1602(ra) # ca6 <exit>
    printf("stat wrong minor %d\n", minor(st.dev));
     2f0:	00001517          	auipc	a0,0x1
     2f4:	fe050513          	addi	a0,a0,-32 # 12d0 <malloc+0x1d4>
     2f8:	00001097          	auipc	ra,0x1
     2fc:	d46080e7          	jalr	-698(ra) # 103e <printf>
    exit(-1);
     300:	557d                	li	a0,-1
     302:	00001097          	auipc	ra,0x1
     306:	9a4080e7          	jalr	-1628(ra) # ca6 <exit>
    printf("link m/a a succeeded\n");
     30a:	00001517          	auipc	a0,0x1
     30e:	fee50513          	addi	a0,a0,-18 # 12f8 <malloc+0x1fc>
     312:	00001097          	auipc	ra,0x1
     316:	d2c080e7          	jalr	-724(ra) # 103e <printf>
    exit(-1);
     31a:	557d                	li	a0,-1
     31c:	00001097          	auipc	ra,0x1
     320:	98a080e7          	jalr	-1654(ra) # ca6 <exit>
    printf("unlink m/a failed\n");
     324:	00001517          	auipc	a0,0x1
     328:	fec50513          	addi	a0,a0,-20 # 1310 <malloc+0x214>
     32c:	00001097          	auipc	ra,0x1
     330:	d12080e7          	jalr	-750(ra) # 103e <printf>
    exit(-1);
     334:	557d                	li	a0,-1
     336:	00001097          	auipc	ra,0x1
     33a:	970080e7          	jalr	-1680(ra) # ca6 <exit>
    printf("chdir /m failed\n");
     33e:	00001517          	auipc	a0,0x1
     342:	fea50513          	addi	a0,a0,-22 # 1328 <malloc+0x22c>
     346:	00001097          	auipc	ra,0x1
     34a:	cf8080e7          	jalr	-776(ra) # 103e <printf>
    exit(-1);
     34e:	557d                	li	a0,-1
     350:	00001097          	auipc	ra,0x1
     354:	956080e7          	jalr	-1706(ra) # ca6 <exit>
    printf("stat . failed\n");
     358:	00001517          	auipc	a0,0x1
     35c:	ff050513          	addi	a0,a0,-16 # 1348 <malloc+0x24c>
     360:	00001097          	auipc	ra,0x1
     364:	cde080e7          	jalr	-802(ra) # 103e <printf>
    exit(-1);
     368:	557d                	li	a0,-1
     36a:	00001097          	auipc	ra,0x1
     36e:	93c080e7          	jalr	-1732(ra) # ca6 <exit>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
     372:	fc045603          	lhu	a2,-64(s0)
     376:	fc442583          	lw	a1,-60(s0)
     37a:	00001517          	auipc	a0,0x1
     37e:	eae50513          	addi	a0,a0,-338 # 1228 <malloc+0x12c>
     382:	00001097          	auipc	ra,0x1
     386:	cbc080e7          	jalr	-836(ra) # 103e <printf>
    exit(-1);
     38a:	557d                	li	a0,-1
     38c:	00001097          	auipc	ra,0x1
     390:	91a080e7          	jalr	-1766(ra) # ca6 <exit>
    printf("chdir .. failed\n");
     394:	00001517          	auipc	a0,0x1
     398:	fcc50513          	addi	a0,a0,-52 # 1360 <malloc+0x264>
     39c:	00001097          	auipc	ra,0x1
     3a0:	ca2080e7          	jalr	-862(ra) # 103e <printf>
    exit(-1);
     3a4:	557d                	li	a0,-1
     3a6:	00001097          	auipc	ra,0x1
     3aa:	900080e7          	jalr	-1792(ra) # ca6 <exit>
    printf("stat . failed\n");
     3ae:	00001517          	auipc	a0,0x1
     3b2:	f9a50513          	addi	a0,a0,-102 # 1348 <malloc+0x24c>
     3b6:	00001097          	auipc	ra,0x1
     3ba:	c88080e7          	jalr	-888(ra) # 103e <printf>
    exit(-1);
     3be:	557d                	li	a0,-1
     3c0:	00001097          	auipc	ra,0x1
     3c4:	8e6080e7          	jalr	-1818(ra) # ca6 <exit>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
     3c8:	fc045603          	lhu	a2,-64(s0)
     3cc:	fc442583          	lw	a1,-60(s0)
     3d0:	00001517          	auipc	a0,0x1
     3d4:	e5850513          	addi	a0,a0,-424 # 1228 <malloc+0x12c>
     3d8:	00001097          	auipc	ra,0x1
     3dc:	c66080e7          	jalr	-922(ra) # 103e <printf>
    exit(-1);
     3e0:	557d                	li	a0,-1
     3e2:	00001097          	auipc	ra,0x1
     3e6:	8c4080e7          	jalr	-1852(ra) # ca6 <exit>

00000000000003ea <test1>:

// depends on test0
void test1() {
     3ea:	715d                	addi	sp,sp,-80
     3ec:	e486                	sd	ra,72(sp)
     3ee:	e0a2                	sd	s0,64(sp)
     3f0:	fc26                	sd	s1,56(sp)
     3f2:	f84a                	sd	s2,48(sp)
     3f4:	f44e                	sd	s3,40(sp)
     3f6:	0880                	addi	s0,sp,80
  struct stat st;
  int fd;
  int i;
  
  printf("test1 start\n");
     3f8:	00001517          	auipc	a0,0x1
     3fc:	f9050513          	addi	a0,a0,-112 # 1388 <malloc+0x28c>
     400:	00001097          	auipc	ra,0x1
     404:	c3e080e7          	jalr	-962(ra) # 103e <printf>

  if (mount("/disk1", "/m") == 0) {
     408:	00001597          	auipc	a1,0x1
     40c:	df058593          	addi	a1,a1,-528 # 11f8 <malloc+0xfc>
     410:	00001517          	auipc	a0,0x1
     414:	df050513          	addi	a0,a0,-528 # 1200 <malloc+0x104>
     418:	00001097          	auipc	ra,0x1
     41c:	93e080e7          	jalr	-1730(ra) # d56 <mount>
     420:	10050d63          	beqz	a0,53a <test1+0x150>
    printf("mount should fail\n");
    exit(-1);
  }    

  if (umount("/m") < 0) {
     424:	00001517          	auipc	a0,0x1
     428:	dd450513          	addi	a0,a0,-556 # 11f8 <malloc+0xfc>
     42c:	00001097          	auipc	ra,0x1
     430:	932080e7          	jalr	-1742(ra) # d5e <umount>
     434:	12054063          	bltz	a0,554 <test1+0x16a>
    printf("umount /m failed\n");
    exit(-1);
  }    

  if (umount("/m") == 0) {
     438:	00001517          	auipc	a0,0x1
     43c:	dc050513          	addi	a0,a0,-576 # 11f8 <malloc+0xfc>
     440:	00001097          	auipc	ra,0x1
     444:	91e080e7          	jalr	-1762(ra) # d5e <umount>
     448:	12050363          	beqz	a0,56e <test1+0x184>
    printf("umount /m succeeded\n");
    exit(-1);
  }    

  if (umount("/") == 0) {
     44c:	00001517          	auipc	a0,0x1
     450:	f9450513          	addi	a0,a0,-108 # 13e0 <malloc+0x2e4>
     454:	00001097          	auipc	ra,0x1
     458:	90a080e7          	jalr	-1782(ra) # d5e <umount>
     45c:	12050663          	beqz	a0,588 <test1+0x19e>
    printf("umount / succeeded\n");
    exit(-1);
  }    

  if (stat("/m", &st) < 0) {
     460:	fb840593          	addi	a1,s0,-72
     464:	00001517          	auipc	a0,0x1
     468:	d9450513          	addi	a0,a0,-620 # 11f8 <malloc+0xfc>
     46c:	00000097          	auipc	ra,0x0
     470:	774080e7          	jalr	1908(ra) # be0 <stat>
     474:	12054763          	bltz	a0,5a2 <test1+0x1b8>
    printf("stat /m failed\n");
    exit(-1);
  }

  if (minor(st.dev) != 0) {
     478:	fb845603          	lhu	a2,-72(s0)
     47c:	06400493          	li	s1,100
    exit(-1);
  }

  // many mounts and umounts
  for (i = 0; i < 100; i++) {
    if (mount("/disk1", "/m") < 0) {
     480:	00001917          	auipc	s2,0x1
     484:	d7890913          	addi	s2,s2,-648 # 11f8 <malloc+0xfc>
     488:	00001997          	auipc	s3,0x1
     48c:	d7898993          	addi	s3,s3,-648 # 1200 <malloc+0x104>
  if (minor(st.dev) != 0) {
     490:	12061663          	bnez	a2,5bc <test1+0x1d2>
    if (mount("/disk1", "/m") < 0) {
     494:	85ca                	mv	a1,s2
     496:	854e                	mv	a0,s3
     498:	00001097          	auipc	ra,0x1
     49c:	8be080e7          	jalr	-1858(ra) # d56 <mount>
     4a0:	12054d63          	bltz	a0,5da <test1+0x1f0>
      printf("mount /m should succeed\n");
      exit(-1);
    }    

    if (umount("/m") < 0) {
     4a4:	854a                	mv	a0,s2
     4a6:	00001097          	auipc	ra,0x1
     4aa:	8b8080e7          	jalr	-1864(ra) # d5e <umount>
     4ae:	14054363          	bltz	a0,5f4 <test1+0x20a>
  for (i = 0; i < 100; i++) {
     4b2:	34fd                	addiw	s1,s1,-1
     4b4:	f0e5                	bnez	s1,494 <test1+0xaa>
      printf("umount /m failed\n");
      exit(-1);
    }
  }

  if (mount("/disk1", "/m") < 0) {
     4b6:	00001597          	auipc	a1,0x1
     4ba:	d4258593          	addi	a1,a1,-702 # 11f8 <malloc+0xfc>
     4be:	00001517          	auipc	a0,0x1
     4c2:	d4250513          	addi	a0,a0,-702 # 1200 <malloc+0x104>
     4c6:	00001097          	auipc	ra,0x1
     4ca:	890080e7          	jalr	-1904(ra) # d56 <mount>
     4ce:	14054063          	bltz	a0,60e <test1+0x224>
    printf("mount /m should succeed\n");
    exit(-1);
  }    

  if ((fd = open("/m/README", O_RDONLY)) < 0) {
     4d2:	4581                	li	a1,0
     4d4:	00001517          	auipc	a0,0x1
     4d8:	d7450513          	addi	a0,a0,-652 # 1248 <malloc+0x14c>
     4dc:	00001097          	auipc	ra,0x1
     4e0:	80a080e7          	jalr	-2038(ra) # ce6 <open>
     4e4:	84aa                	mv	s1,a0
     4e6:	14054163          	bltz	a0,628 <test1+0x23e>
    printf("open read failed\n");
    exit(-1);
  }

  if (umount("/m") == 0) {
     4ea:	00001517          	auipc	a0,0x1
     4ee:	d0e50513          	addi	a0,a0,-754 # 11f8 <malloc+0xfc>
     4f2:	00001097          	auipc	ra,0x1
     4f6:	86c080e7          	jalr	-1940(ra) # d5e <umount>
     4fa:	14050463          	beqz	a0,642 <test1+0x258>
    printf("umount /m succeeded\n");
    exit(-1);
  }

  close(fd);
     4fe:	8526                	mv	a0,s1
     500:	00000097          	auipc	ra,0x0
     504:	7ce080e7          	jalr	1998(ra) # cce <close>
  
  if (umount("/m") < 0) {
     508:	00001517          	auipc	a0,0x1
     50c:	cf050513          	addi	a0,a0,-784 # 11f8 <malloc+0xfc>
     510:	00001097          	auipc	ra,0x1
     514:	84e080e7          	jalr	-1970(ra) # d5e <umount>
     518:	14054263          	bltz	a0,65c <test1+0x272>
    printf("final umount failed\n");
    exit(-1);
  }

  printf("test1 done\n");
     51c:	00001517          	auipc	a0,0x1
     520:	f3c50513          	addi	a0,a0,-196 # 1458 <malloc+0x35c>
     524:	00001097          	auipc	ra,0x1
     528:	b1a080e7          	jalr	-1254(ra) # 103e <printf>
}
     52c:	60a6                	ld	ra,72(sp)
     52e:	6406                	ld	s0,64(sp)
     530:	74e2                	ld	s1,56(sp)
     532:	7942                	ld	s2,48(sp)
     534:	79a2                	ld	s3,40(sp)
     536:	6161                	addi	sp,sp,80
     538:	8082                	ret
    printf("mount should fail\n");
     53a:	00001517          	auipc	a0,0x1
     53e:	e5e50513          	addi	a0,a0,-418 # 1398 <malloc+0x29c>
     542:	00001097          	auipc	ra,0x1
     546:	afc080e7          	jalr	-1284(ra) # 103e <printf>
    exit(-1);
     54a:	557d                	li	a0,-1
     54c:	00000097          	auipc	ra,0x0
     550:	75a080e7          	jalr	1882(ra) # ca6 <exit>
    printf("umount /m failed\n");
     554:	00001517          	auipc	a0,0x1
     558:	e5c50513          	addi	a0,a0,-420 # 13b0 <malloc+0x2b4>
     55c:	00001097          	auipc	ra,0x1
     560:	ae2080e7          	jalr	-1310(ra) # 103e <printf>
    exit(-1);
     564:	557d                	li	a0,-1
     566:	00000097          	auipc	ra,0x0
     56a:	740080e7          	jalr	1856(ra) # ca6 <exit>
    printf("umount /m succeeded\n");
     56e:	00001517          	auipc	a0,0x1
     572:	e5a50513          	addi	a0,a0,-422 # 13c8 <malloc+0x2cc>
     576:	00001097          	auipc	ra,0x1
     57a:	ac8080e7          	jalr	-1336(ra) # 103e <printf>
    exit(-1);
     57e:	557d                	li	a0,-1
     580:	00000097          	auipc	ra,0x0
     584:	726080e7          	jalr	1830(ra) # ca6 <exit>
    printf("umount / succeeded\n");
     588:	00001517          	auipc	a0,0x1
     58c:	e6050513          	addi	a0,a0,-416 # 13e8 <malloc+0x2ec>
     590:	00001097          	auipc	ra,0x1
     594:	aae080e7          	jalr	-1362(ra) # 103e <printf>
    exit(-1);
     598:	557d                	li	a0,-1
     59a:	00000097          	auipc	ra,0x0
     59e:	70c080e7          	jalr	1804(ra) # ca6 <exit>
    printf("stat /m failed\n");
     5a2:	00001517          	auipc	a0,0x1
     5a6:	c7650513          	addi	a0,a0,-906 # 1218 <malloc+0x11c>
     5aa:	00001097          	auipc	ra,0x1
     5ae:	a94080e7          	jalr	-1388(ra) # 103e <printf>
    exit(-1);
     5b2:	557d                	li	a0,-1
     5b4:	00000097          	auipc	ra,0x0
     5b8:	6f2080e7          	jalr	1778(ra) # ca6 <exit>
    printf("stat wrong inum/dev %d %d\n", st.ino, minor(st.dev));
     5bc:	fbc42583          	lw	a1,-68(s0)
     5c0:	00001517          	auipc	a0,0x1
     5c4:	e4050513          	addi	a0,a0,-448 # 1400 <malloc+0x304>
     5c8:	00001097          	auipc	ra,0x1
     5cc:	a76080e7          	jalr	-1418(ra) # 103e <printf>
    exit(-1);
     5d0:	557d                	li	a0,-1
     5d2:	00000097          	auipc	ra,0x0
     5d6:	6d4080e7          	jalr	1748(ra) # ca6 <exit>
      printf("mount /m should succeed\n");
     5da:	00001517          	auipc	a0,0x1
     5de:	e4650513          	addi	a0,a0,-442 # 1420 <malloc+0x324>
     5e2:	00001097          	auipc	ra,0x1
     5e6:	a5c080e7          	jalr	-1444(ra) # 103e <printf>
      exit(-1);
     5ea:	557d                	li	a0,-1
     5ec:	00000097          	auipc	ra,0x0
     5f0:	6ba080e7          	jalr	1722(ra) # ca6 <exit>
      printf("umount /m failed\n");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	dbc50513          	addi	a0,a0,-580 # 13b0 <malloc+0x2b4>
     5fc:	00001097          	auipc	ra,0x1
     600:	a42080e7          	jalr	-1470(ra) # 103e <printf>
      exit(-1);
     604:	557d                	li	a0,-1
     606:	00000097          	auipc	ra,0x0
     60a:	6a0080e7          	jalr	1696(ra) # ca6 <exit>
    printf("mount /m should succeed\n");
     60e:	00001517          	auipc	a0,0x1
     612:	e1250513          	addi	a0,a0,-494 # 1420 <malloc+0x324>
     616:	00001097          	auipc	ra,0x1
     61a:	a28080e7          	jalr	-1496(ra) # 103e <printf>
    exit(-1);
     61e:	557d                	li	a0,-1
     620:	00000097          	auipc	ra,0x0
     624:	686080e7          	jalr	1670(ra) # ca6 <exit>
    printf("open read failed\n");
     628:	00001517          	auipc	a0,0x1
     62c:	c3050513          	addi	a0,a0,-976 # 1258 <malloc+0x15c>
     630:	00001097          	auipc	ra,0x1
     634:	a0e080e7          	jalr	-1522(ra) # 103e <printf>
    exit(-1);
     638:	557d                	li	a0,-1
     63a:	00000097          	auipc	ra,0x0
     63e:	66c080e7          	jalr	1644(ra) # ca6 <exit>
    printf("umount /m succeeded\n");
     642:	00001517          	auipc	a0,0x1
     646:	d8650513          	addi	a0,a0,-634 # 13c8 <malloc+0x2cc>
     64a:	00001097          	auipc	ra,0x1
     64e:	9f4080e7          	jalr	-1548(ra) # 103e <printf>
    exit(-1);
     652:	557d                	li	a0,-1
     654:	00000097          	auipc	ra,0x0
     658:	652080e7          	jalr	1618(ra) # ca6 <exit>
    printf("final umount failed\n");
     65c:	00001517          	auipc	a0,0x1
     660:	de450513          	addi	a0,a0,-540 # 1440 <malloc+0x344>
     664:	00001097          	auipc	ra,0x1
     668:	9da080e7          	jalr	-1574(ra) # 103e <printf>
    exit(-1);
     66c:	557d                	li	a0,-1
     66e:	00000097          	auipc	ra,0x0
     672:	638080e7          	jalr	1592(ra) # ca6 <exit>

0000000000000676 <test2>:
#define NOP 100

// try to trigger races/deadlocks in namex; it is helpful to add
// sleepticks(1) in if(ip->type != T_DIR) branch in namei, so that you
// will observe some more reliably.
void test2() {
     676:	715d                	addi	sp,sp,-80
     678:	e486                	sd	ra,72(sp)
     67a:	e0a2                	sd	s0,64(sp)
     67c:	fc26                	sd	s1,56(sp)
     67e:	f84a                	sd	s2,48(sp)
     680:	f44e                	sd	s3,40(sp)
     682:	f052                	sd	s4,32(sp)
     684:	0880                	addi	s0,sp,80
  int pid[NPID];
  int fd;
  int i;
  char buf[1];

  printf("test2\n");
     686:	00001517          	auipc	a0,0x1
     68a:	de250513          	addi	a0,a0,-542 # 1468 <malloc+0x36c>
     68e:	00001097          	auipc	ra,0x1
     692:	9b0080e7          	jalr	-1616(ra) # 103e <printf>

  mkdir("/m");
     696:	00001517          	auipc	a0,0x1
     69a:	b6250513          	addi	a0,a0,-1182 # 11f8 <malloc+0xfc>
     69e:	00000097          	auipc	ra,0x0
     6a2:	670080e7          	jalr	1648(ra) # d0e <mkdir>
  
  if (mount("/disk1", "/m") < 0) {
     6a6:	00001597          	auipc	a1,0x1
     6aa:	b5258593          	addi	a1,a1,-1198 # 11f8 <malloc+0xfc>
     6ae:	00001517          	auipc	a0,0x1
     6b2:	b5250513          	addi	a0,a0,-1198 # 1200 <malloc+0x104>
     6b6:	00000097          	auipc	ra,0x0
     6ba:	6a0080e7          	jalr	1696(ra) # d56 <mount>
     6be:	fc040a13          	addi	s4,s0,-64
     6c2:	84d2                	mv	s1,s4
     6c4:	0c054363          	bltz	a0,78a <test2+0x114>
      printf("mount failed\n");
      exit(-1);
  }    

  for (i = 0; i < NPID; i++) {
    if ((pid[i] = fork()) < 0) {
     6c8:	00000097          	auipc	ra,0x0
     6cc:	5d6080e7          	jalr	1494(ra) # c9e <fork>
     6d0:	c088                	sw	a0,0(s1)
     6d2:	0c054963          	bltz	a0,7a4 <test2+0x12e>
      printf("fork failed\n");
      exit(-1);
    }
    if (pid[i] == 0) {
     6d6:	c565                	beqz	a0,7be <test2+0x148>
  for (i = 0; i < NPID; i++) {
     6d8:	0491                	addi	s1,s1,4
     6da:	fd040793          	addi	a5,s0,-48
     6de:	fef495e3          	bne	s1,a5,6c8 <test2+0x52>
     6e2:	06400913          	li	s2,100
        }
      }
    }
  }
  for (i = 0; i < NOP; i++) {
    if ((fd = open("/m/b", O_CREATE|O_WRONLY)) < 0) {
     6e6:	00001997          	auipc	s3,0x1
     6ea:	da298993          	addi	s3,s3,-606 # 1488 <malloc+0x38c>
     6ee:	20100593          	li	a1,513
     6f2:	854e                	mv	a0,s3
     6f4:	00000097          	auipc	ra,0x0
     6f8:	5f2080e7          	jalr	1522(ra) # ce6 <open>
     6fc:	84aa                	mv	s1,a0
     6fe:	0e054163          	bltz	a0,7e0 <test2+0x16a>
      printf("open write failed");
      exit(-1);
    }
    if (unlink("/m/b") < 0) {
     702:	854e                	mv	a0,s3
     704:	00000097          	auipc	ra,0x0
     708:	5f2080e7          	jalr	1522(ra) # cf6 <unlink>
     70c:	0e054763          	bltz	a0,7fa <test2+0x184>
      printf("unlink failed\n");
      exit(-1);
    }
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
     710:	4605                	li	a2,1
     712:	fb840593          	addi	a1,s0,-72
     716:	8526                	mv	a0,s1
     718:	00000097          	auipc	ra,0x0
     71c:	5ae080e7          	jalr	1454(ra) # cc6 <write>
     720:	4785                	li	a5,1
     722:	0ef51963          	bne	a0,a5,814 <test2+0x19e>
      printf("write failed\n");
      exit(-1);
    }
    close(fd);
     726:	8526                	mv	a0,s1
     728:	00000097          	auipc	ra,0x0
     72c:	5a6080e7          	jalr	1446(ra) # cce <close>
  for (i = 0; i < NOP; i++) {
     730:	397d                	addiw	s2,s2,-1
     732:	fa091ee3          	bnez	s2,6ee <test2+0x78>
  }
  for (i = 0; i < NPID; i++) {
    kill(pid[i]);
     736:	000a2503          	lw	a0,0(s4)
     73a:	00000097          	auipc	ra,0x0
     73e:	59c080e7          	jalr	1436(ra) # cd6 <kill>
    wait(0);
     742:	4501                	li	a0,0
     744:	00000097          	auipc	ra,0x0
     748:	56a080e7          	jalr	1386(ra) # cae <wait>
  for (i = 0; i < NPID; i++) {
     74c:	0a11                	addi	s4,s4,4
     74e:	fd040793          	addi	a5,s0,-48
     752:	fefa12e3          	bne	s4,a5,736 <test2+0xc0>
  }
  if (umount("/m") < 0) {
     756:	00001517          	auipc	a0,0x1
     75a:	aa250513          	addi	a0,a0,-1374 # 11f8 <malloc+0xfc>
     75e:	00000097          	auipc	ra,0x0
     762:	600080e7          	jalr	1536(ra) # d5e <umount>
     766:	0c054463          	bltz	a0,82e <test2+0x1b8>
    printf("umount failed\n");
    exit(-1);
  }    

  printf("test2 ok\n");
     76a:	00001517          	auipc	a0,0x1
     76e:	d5e50513          	addi	a0,a0,-674 # 14c8 <malloc+0x3cc>
     772:	00001097          	auipc	ra,0x1
     776:	8cc080e7          	jalr	-1844(ra) # 103e <printf>
}
     77a:	60a6                	ld	ra,72(sp)
     77c:	6406                	ld	s0,64(sp)
     77e:	74e2                	ld	s1,56(sp)
     780:	7942                	ld	s2,48(sp)
     782:	79a2                	ld	s3,40(sp)
     784:	7a02                	ld	s4,32(sp)
     786:	6161                	addi	sp,sp,80
     788:	8082                	ret
      printf("mount failed\n");
     78a:	00001517          	auipc	a0,0x1
     78e:	a7e50513          	addi	a0,a0,-1410 # 1208 <malloc+0x10c>
     792:	00001097          	auipc	ra,0x1
     796:	8ac080e7          	jalr	-1876(ra) # 103e <printf>
      exit(-1);
     79a:	557d                	li	a0,-1
     79c:	00000097          	auipc	ra,0x0
     7a0:	50a080e7          	jalr	1290(ra) # ca6 <exit>
      printf("fork failed\n");
     7a4:	00001517          	auipc	a0,0x1
     7a8:	ccc50513          	addi	a0,a0,-820 # 1470 <malloc+0x374>
     7ac:	00001097          	auipc	ra,0x1
     7b0:	892080e7          	jalr	-1902(ra) # 103e <printf>
      exit(-1);
     7b4:	557d                	li	a0,-1
     7b6:	00000097          	auipc	ra,0x0
     7ba:	4f0080e7          	jalr	1264(ra) # ca6 <exit>
        if ((fd = open("/m/b/c", O_RDONLY)) >= 0) {
     7be:	00001497          	auipc	s1,0x1
     7c2:	cc248493          	addi	s1,s1,-830 # 1480 <malloc+0x384>
     7c6:	4581                	li	a1,0
     7c8:	8526                	mv	a0,s1
     7ca:	00000097          	auipc	ra,0x0
     7ce:	51c080e7          	jalr	1308(ra) # ce6 <open>
     7d2:	fe054ae3          	bltz	a0,7c6 <test2+0x150>
          close(fd);
     7d6:	00000097          	auipc	ra,0x0
     7da:	4f8080e7          	jalr	1272(ra) # cce <close>
     7de:	b7e5                	j	7c6 <test2+0x150>
      printf("open write failed");
     7e0:	00001517          	auipc	a0,0x1
     7e4:	cb050513          	addi	a0,a0,-848 # 1490 <malloc+0x394>
     7e8:	00001097          	auipc	ra,0x1
     7ec:	856080e7          	jalr	-1962(ra) # 103e <printf>
      exit(-1);
     7f0:	557d                	li	a0,-1
     7f2:	00000097          	auipc	ra,0x0
     7f6:	4b4080e7          	jalr	1204(ra) # ca6 <exit>
      printf("unlink failed\n");
     7fa:	00001517          	auipc	a0,0x1
     7fe:	cae50513          	addi	a0,a0,-850 # 14a8 <malloc+0x3ac>
     802:	00001097          	auipc	ra,0x1
     806:	83c080e7          	jalr	-1988(ra) # 103e <printf>
      exit(-1);
     80a:	557d                	li	a0,-1
     80c:	00000097          	auipc	ra,0x0
     810:	49a080e7          	jalr	1178(ra) # ca6 <exit>
      printf("write failed\n");
     814:	00001517          	auipc	a0,0x1
     818:	a9450513          	addi	a0,a0,-1388 # 12a8 <malloc+0x1ac>
     81c:	00001097          	auipc	ra,0x1
     820:	822080e7          	jalr	-2014(ra) # 103e <printf>
      exit(-1);
     824:	557d                	li	a0,-1
     826:	00000097          	auipc	ra,0x0
     82a:	480080e7          	jalr	1152(ra) # ca6 <exit>
    printf("umount failed\n");
     82e:	00001517          	auipc	a0,0x1
     832:	c8a50513          	addi	a0,a0,-886 # 14b8 <malloc+0x3bc>
     836:	00001097          	auipc	ra,0x1
     83a:	808080e7          	jalr	-2040(ra) # 103e <printf>
    exit(-1);
     83e:	557d                	li	a0,-1
     840:	00000097          	auipc	ra,0x0
     844:	466080e7          	jalr	1126(ra) # ca6 <exit>

0000000000000848 <test3>:


// Mount/unmount concurrently with creating files on the mounted fs
void test3() {
     848:	7159                	addi	sp,sp,-112
     84a:	f486                	sd	ra,104(sp)
     84c:	f0a2                	sd	s0,96(sp)
     84e:	eca6                	sd	s1,88(sp)
     850:	e8ca                	sd	s2,80(sp)
     852:	e4ce                	sd	s3,72(sp)
     854:	e0d2                	sd	s4,64(sp)
     856:	fc56                	sd	s5,56(sp)
     858:	f85a                	sd	s6,48(sp)
     85a:	f45e                	sd	s7,40(sp)
     85c:	1880                	addi	s0,sp,112
  int pid[NPID];
  int fd;
  int i;
  char buf[1];

  printf("test3\n");
     85e:	00001517          	auipc	a0,0x1
     862:	c7a50513          	addi	a0,a0,-902 # 14d8 <malloc+0x3dc>
     866:	00000097          	auipc	ra,0x0
     86a:	7d8080e7          	jalr	2008(ra) # 103e <printf>

  mkdir("/m");
     86e:	00001517          	auipc	a0,0x1
     872:	98a50513          	addi	a0,a0,-1654 # 11f8 <malloc+0xfc>
     876:	00000097          	auipc	ra,0x0
     87a:	498080e7          	jalr	1176(ra) # d0e <mkdir>
  for (i = 0; i < NPID; i++) {
     87e:	fa040b13          	addi	s6,s0,-96
     882:	fb040b93          	addi	s7,s0,-80
  mkdir("/m");
     886:	84da                	mv	s1,s6
    if ((pid[i] = fork()) < 0) {
     888:	00000097          	auipc	ra,0x0
     88c:	416080e7          	jalr	1046(ra) # c9e <fork>
     890:	c088                	sw	a0,0(s1)
     892:	02054663          	bltz	a0,8be <test3+0x76>
      printf("fork failed\n");
      exit(-1);
    }
    if (pid[i] == 0) {
     896:	c129                	beqz	a0,8d8 <test3+0x90>
  for (i = 0; i < NPID; i++) {
     898:	0491                	addi	s1,s1,4
     89a:	ff7497e3          	bne	s1,s7,888 <test3+0x40>
        close(fd);
        sleep(1);
      }
    }
  }
  for (i = 0; i < NOP; i++) {
     89e:	4481                	li	s1,0
    if (mount("/disk1", "/m") < 0) {
     8a0:	00001917          	auipc	s2,0x1
     8a4:	95890913          	addi	s2,s2,-1704 # 11f8 <malloc+0xfc>
     8a8:	00001a97          	auipc	s5,0x1
     8ac:	958a8a93          	addi	s5,s5,-1704 # 1200 <malloc+0x104>
      printf("mount failed\n");
      exit(-1);
    }    
    while (umount("/m") < 0) {
      printf("umount failed; try again %d\n", i);
     8b0:	00001997          	auipc	s3,0x1
     8b4:	c3098993          	addi	s3,s3,-976 # 14e0 <malloc+0x3e4>
  for (i = 0; i < NOP; i++) {
     8b8:	06400a13          	li	s4,100
     8bc:	a0c9                	j	97e <test3+0x136>
      printf("fork failed\n");
     8be:	00001517          	auipc	a0,0x1
     8c2:	bb250513          	addi	a0,a0,-1102 # 1470 <malloc+0x374>
     8c6:	00000097          	auipc	ra,0x0
     8ca:	778080e7          	jalr	1912(ra) # 103e <printf>
      exit(-1);
     8ce:	557d                	li	a0,-1
     8d0:	00000097          	auipc	ra,0x0
     8d4:	3d6080e7          	jalr	982(ra) # ca6 <exit>
        if ((fd = open("/m/b", O_CREATE|O_WRONLY)) < 0) {
     8d8:	00001917          	auipc	s2,0x1
     8dc:	bb090913          	addi	s2,s2,-1104 # 1488 <malloc+0x38c>
     8e0:	20100593          	li	a1,513
     8e4:	854a                	mv	a0,s2
     8e6:	00000097          	auipc	ra,0x0
     8ea:	400080e7          	jalr	1024(ra) # ce6 <open>
     8ee:	84aa                	mv	s1,a0
     8f0:	02054d63          	bltz	a0,92a <test3+0xe2>
        unlink("/m/b");
     8f4:	854a                	mv	a0,s2
     8f6:	00000097          	auipc	ra,0x0
     8fa:	400080e7          	jalr	1024(ra) # cf6 <unlink>
        if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
     8fe:	4605                	li	a2,1
     900:	f9840593          	addi	a1,s0,-104
     904:	8526                	mv	a0,s1
     906:	00000097          	auipc	ra,0x0
     90a:	3c0080e7          	jalr	960(ra) # cc6 <write>
     90e:	4785                	li	a5,1
     910:	02f51a63          	bne	a0,a5,944 <test3+0xfc>
        close(fd);
     914:	8526                	mv	a0,s1
     916:	00000097          	auipc	ra,0x0
     91a:	3b8080e7          	jalr	952(ra) # cce <close>
        sleep(1);
     91e:	4505                	li	a0,1
     920:	00000097          	auipc	ra,0x0
     924:	416080e7          	jalr	1046(ra) # d36 <sleep>
        if ((fd = open("/m/b", O_CREATE|O_WRONLY)) < 0) {
     928:	bf65                	j	8e0 <test3+0x98>
          printf("open write failed");
     92a:	00001517          	auipc	a0,0x1
     92e:	b6650513          	addi	a0,a0,-1178 # 1490 <malloc+0x394>
     932:	00000097          	auipc	ra,0x0
     936:	70c080e7          	jalr	1804(ra) # 103e <printf>
          exit(-1);
     93a:	557d                	li	a0,-1
     93c:	00000097          	auipc	ra,0x0
     940:	36a080e7          	jalr	874(ra) # ca6 <exit>
          printf("write failed\n");
     944:	00001517          	auipc	a0,0x1
     948:	96450513          	addi	a0,a0,-1692 # 12a8 <malloc+0x1ac>
     94c:	00000097          	auipc	ra,0x0
     950:	6f2080e7          	jalr	1778(ra) # 103e <printf>
          exit(-1);
     954:	557d                	li	a0,-1
     956:	00000097          	auipc	ra,0x0
     95a:	350080e7          	jalr	848(ra) # ca6 <exit>
      printf("umount failed; try again %d\n", i);
     95e:	85a6                	mv	a1,s1
     960:	854e                	mv	a0,s3
     962:	00000097          	auipc	ra,0x0
     966:	6dc080e7          	jalr	1756(ra) # 103e <printf>
    while (umount("/m") < 0) {
     96a:	854a                	mv	a0,s2
     96c:	00000097          	auipc	ra,0x0
     970:	3f2080e7          	jalr	1010(ra) # d5e <umount>
     974:	fe0545e3          	bltz	a0,95e <test3+0x116>
  for (i = 0; i < NOP; i++) {
     978:	2485                	addiw	s1,s1,1
     97a:	03448763          	beq	s1,s4,9a8 <test3+0x160>
    if (mount("/disk1", "/m") < 0) {
     97e:	85ca                	mv	a1,s2
     980:	8556                	mv	a0,s5
     982:	00000097          	auipc	ra,0x0
     986:	3d4080e7          	jalr	980(ra) # d56 <mount>
     98a:	fe0550e3          	bgez	a0,96a <test3+0x122>
      printf("mount failed\n");
     98e:	00001517          	auipc	a0,0x1
     992:	87a50513          	addi	a0,a0,-1926 # 1208 <malloc+0x10c>
     996:	00000097          	auipc	ra,0x0
     99a:	6a8080e7          	jalr	1704(ra) # 103e <printf>
      exit(-1);
     99e:	557d                	li	a0,-1
     9a0:	00000097          	auipc	ra,0x0
     9a4:	306080e7          	jalr	774(ra) # ca6 <exit>
    }    
  }
  for (i = 0; i < NPID; i++) {
    kill(pid[i]);
     9a8:	000b2503          	lw	a0,0(s6)
     9ac:	00000097          	auipc	ra,0x0
     9b0:	32a080e7          	jalr	810(ra) # cd6 <kill>
    wait(0);
     9b4:	4501                	li	a0,0
     9b6:	00000097          	auipc	ra,0x0
     9ba:	2f8080e7          	jalr	760(ra) # cae <wait>
  for (i = 0; i < NPID; i++) {
     9be:	0b11                	addi	s6,s6,4
     9c0:	ff7b14e3          	bne	s6,s7,9a8 <test3+0x160>
  }
  printf("test3 ok\n");
     9c4:	00001517          	auipc	a0,0x1
     9c8:	b3c50513          	addi	a0,a0,-1220 # 1500 <malloc+0x404>
     9cc:	00000097          	auipc	ra,0x0
     9d0:	672080e7          	jalr	1650(ra) # 103e <printf>
}
     9d4:	70a6                	ld	ra,104(sp)
     9d6:	7406                	ld	s0,96(sp)
     9d8:	64e6                	ld	s1,88(sp)
     9da:	6946                	ld	s2,80(sp)
     9dc:	69a6                	ld	s3,72(sp)
     9de:	6a06                	ld	s4,64(sp)
     9e0:	7ae2                	ld	s5,56(sp)
     9e2:	7b42                	ld	s6,48(sp)
     9e4:	7ba2                	ld	s7,40(sp)
     9e6:	6165                	addi	sp,sp,112
     9e8:	8082                	ret

00000000000009ea <test4>:

void
test4()
{
     9ea:	1141                	addi	sp,sp,-16
     9ec:	e406                	sd	ra,8(sp)
     9ee:	e022                	sd	s0,0(sp)
     9f0:	0800                	addi	s0,sp,16
  printf("test4\n");
     9f2:	00001517          	auipc	a0,0x1
     9f6:	b1e50513          	addi	a0,a0,-1250 # 1510 <malloc+0x414>
     9fa:	00000097          	auipc	ra,0x0
     9fe:	644080e7          	jalr	1604(ra) # 103e <printf>

  mknod("disk1", DISK, 1);
     a02:	4605                	li	a2,1
     a04:	4581                	li	a1,0
     a06:	00000517          	auipc	a0,0x0
     a0a:	7ea50513          	addi	a0,a0,2026 # 11f0 <malloc+0xf4>
     a0e:	00000097          	auipc	ra,0x0
     a12:	2e0080e7          	jalr	736(ra) # cee <mknod>
  mkdir("/m");
     a16:	00000517          	auipc	a0,0x0
     a1a:	7e250513          	addi	a0,a0,2018 # 11f8 <malloc+0xfc>
     a1e:	00000097          	auipc	ra,0x0
     a22:	2f0080e7          	jalr	752(ra) # d0e <mkdir>
  if (mount("/disk1", "/m") < 0) {
     a26:	00000597          	auipc	a1,0x0
     a2a:	7d258593          	addi	a1,a1,2002 # 11f8 <malloc+0xfc>
     a2e:	00000517          	auipc	a0,0x0
     a32:	7d250513          	addi	a0,a0,2002 # 1200 <malloc+0x104>
     a36:	00000097          	auipc	ra,0x0
     a3a:	320080e7          	jalr	800(ra) # d56 <mount>
     a3e:	00054f63          	bltz	a0,a5c <test4+0x72>
      printf("mount failed\n");
      exit(-1);
  }
  crash("/m/crashf", 1);
     a42:	4585                	li	a1,1
     a44:	00001517          	auipc	a0,0x1
     a48:	ad450513          	addi	a0,a0,-1324 # 1518 <malloc+0x41c>
     a4c:	00000097          	auipc	ra,0x0
     a50:	302080e7          	jalr	770(ra) # d4e <crash>
}
     a54:	60a2                	ld	ra,8(sp)
     a56:	6402                	ld	s0,0(sp)
     a58:	0141                	addi	sp,sp,16
     a5a:	8082                	ret
      printf("mount failed\n");
     a5c:	00000517          	auipc	a0,0x0
     a60:	7ac50513          	addi	a0,a0,1964 # 1208 <malloc+0x10c>
     a64:	00000097          	auipc	ra,0x0
     a68:	5da080e7          	jalr	1498(ra) # 103e <printf>
      exit(-1);
     a6c:	557d                	li	a0,-1
     a6e:	00000097          	auipc	ra,0x0
     a72:	238080e7          	jalr	568(ra) # ca6 <exit>

0000000000000a76 <main>:
{
     a76:	1141                	addi	sp,sp,-16
     a78:	e406                	sd	ra,8(sp)
     a7a:	e022                	sd	s0,0(sp)
     a7c:	0800                	addi	s0,sp,16
  test0();
     a7e:	fffff097          	auipc	ra,0xfffff
     a82:	582080e7          	jalr	1410(ra) # 0 <test0>
  test1();
     a86:	00000097          	auipc	ra,0x0
     a8a:	964080e7          	jalr	-1692(ra) # 3ea <test1>
  test2();
     a8e:	00000097          	auipc	ra,0x0
     a92:	be8080e7          	jalr	-1048(ra) # 676 <test2>
  test3();
     a96:	00000097          	auipc	ra,0x0
     a9a:	db2080e7          	jalr	-590(ra) # 848 <test3>
  test4();
     a9e:	00000097          	auipc	ra,0x0
     aa2:	f4c080e7          	jalr	-180(ra) # 9ea <test4>
  exit(0);
     aa6:	4501                	li	a0,0
     aa8:	00000097          	auipc	ra,0x0
     aac:	1fe080e7          	jalr	510(ra) # ca6 <exit>

0000000000000ab0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     ab0:	1141                	addi	sp,sp,-16
     ab2:	e422                	sd	s0,8(sp)
     ab4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     ab6:	87aa                	mv	a5,a0
     ab8:	0585                	addi	a1,a1,1
     aba:	0785                	addi	a5,a5,1
     abc:	fff5c703          	lbu	a4,-1(a1)
     ac0:	fee78fa3          	sb	a4,-1(a5) # fffffffff0000fff <__global_pointer$+0xffffffffeffff2be>
     ac4:	fb75                	bnez	a4,ab8 <strcpy+0x8>
    ;
  return os;
}
     ac6:	6422                	ld	s0,8(sp)
     ac8:	0141                	addi	sp,sp,16
     aca:	8082                	ret

0000000000000acc <strcmp>:

int
strcmp(const char *p, const char *q)
{
     acc:	1141                	addi	sp,sp,-16
     ace:	e422                	sd	s0,8(sp)
     ad0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     ad2:	00054783          	lbu	a5,0(a0)
     ad6:	cb91                	beqz	a5,aea <strcmp+0x1e>
     ad8:	0005c703          	lbu	a4,0(a1)
     adc:	00f71763          	bne	a4,a5,aea <strcmp+0x1e>
    p++, q++;
     ae0:	0505                	addi	a0,a0,1
     ae2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     ae4:	00054783          	lbu	a5,0(a0)
     ae8:	fbe5                	bnez	a5,ad8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     aea:	0005c503          	lbu	a0,0(a1)
}
     aee:	40a7853b          	subw	a0,a5,a0
     af2:	6422                	ld	s0,8(sp)
     af4:	0141                	addi	sp,sp,16
     af6:	8082                	ret

0000000000000af8 <strlen>:

uint
strlen(const char *s)
{
     af8:	1141                	addi	sp,sp,-16
     afa:	e422                	sd	s0,8(sp)
     afc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     afe:	00054783          	lbu	a5,0(a0)
     b02:	cf91                	beqz	a5,b1e <strlen+0x26>
     b04:	0505                	addi	a0,a0,1
     b06:	87aa                	mv	a5,a0
     b08:	4685                	li	a3,1
     b0a:	9e89                	subw	a3,a3,a0
     b0c:	00f6853b          	addw	a0,a3,a5
     b10:	0785                	addi	a5,a5,1
     b12:	fff7c703          	lbu	a4,-1(a5)
     b16:	fb7d                	bnez	a4,b0c <strlen+0x14>
    ;
  return n;
}
     b18:	6422                	ld	s0,8(sp)
     b1a:	0141                	addi	sp,sp,16
     b1c:	8082                	ret
  for(n = 0; s[n]; n++)
     b1e:	4501                	li	a0,0
     b20:	bfe5                	j	b18 <strlen+0x20>

0000000000000b22 <memset>:

void*
memset(void *dst, int c, uint n)
{
     b22:	1141                	addi	sp,sp,-16
     b24:	e422                	sd	s0,8(sp)
     b26:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     b28:	ce09                	beqz	a2,b42 <memset+0x20>
     b2a:	87aa                	mv	a5,a0
     b2c:	fff6071b          	addiw	a4,a2,-1
     b30:	1702                	slli	a4,a4,0x20
     b32:	9301                	srli	a4,a4,0x20
     b34:	0705                	addi	a4,a4,1
     b36:	972a                	add	a4,a4,a0
    cdst[i] = c;
     b38:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     b3c:	0785                	addi	a5,a5,1
     b3e:	fee79de3          	bne	a5,a4,b38 <memset+0x16>
  }
  return dst;
}
     b42:	6422                	ld	s0,8(sp)
     b44:	0141                	addi	sp,sp,16
     b46:	8082                	ret

0000000000000b48 <strchr>:

char*
strchr(const char *s, char c)
{
     b48:	1141                	addi	sp,sp,-16
     b4a:	e422                	sd	s0,8(sp)
     b4c:	0800                	addi	s0,sp,16
  for(; *s; s++)
     b4e:	00054783          	lbu	a5,0(a0)
     b52:	cb99                	beqz	a5,b68 <strchr+0x20>
    if(*s == c)
     b54:	00f58763          	beq	a1,a5,b62 <strchr+0x1a>
  for(; *s; s++)
     b58:	0505                	addi	a0,a0,1
     b5a:	00054783          	lbu	a5,0(a0)
     b5e:	fbfd                	bnez	a5,b54 <strchr+0xc>
      return (char*)s;
  return 0;
     b60:	4501                	li	a0,0
}
     b62:	6422                	ld	s0,8(sp)
     b64:	0141                	addi	sp,sp,16
     b66:	8082                	ret
  return 0;
     b68:	4501                	li	a0,0
     b6a:	bfe5                	j	b62 <strchr+0x1a>

0000000000000b6c <gets>:

char*
gets(char *buf, int max)
{
     b6c:	711d                	addi	sp,sp,-96
     b6e:	ec86                	sd	ra,88(sp)
     b70:	e8a2                	sd	s0,80(sp)
     b72:	e4a6                	sd	s1,72(sp)
     b74:	e0ca                	sd	s2,64(sp)
     b76:	fc4e                	sd	s3,56(sp)
     b78:	f852                	sd	s4,48(sp)
     b7a:	f456                	sd	s5,40(sp)
     b7c:	f05a                	sd	s6,32(sp)
     b7e:	ec5e                	sd	s7,24(sp)
     b80:	1080                	addi	s0,sp,96
     b82:	8baa                	mv	s7,a0
     b84:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     b86:	892a                	mv	s2,a0
     b88:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     b8a:	4aa9                	li	s5,10
     b8c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     b8e:	89a6                	mv	s3,s1
     b90:	2485                	addiw	s1,s1,1
     b92:	0344d863          	bge	s1,s4,bc2 <gets+0x56>
    cc = read(0, &c, 1);
     b96:	4605                	li	a2,1
     b98:	faf40593          	addi	a1,s0,-81
     b9c:	4501                	li	a0,0
     b9e:	00000097          	auipc	ra,0x0
     ba2:	120080e7          	jalr	288(ra) # cbe <read>
    if(cc < 1)
     ba6:	00a05e63          	blez	a0,bc2 <gets+0x56>
    buf[i++] = c;
     baa:	faf44783          	lbu	a5,-81(s0)
     bae:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     bb2:	01578763          	beq	a5,s5,bc0 <gets+0x54>
     bb6:	0905                	addi	s2,s2,1
     bb8:	fd679be3          	bne	a5,s6,b8e <gets+0x22>
  for(i=0; i+1 < max; ){
     bbc:	89a6                	mv	s3,s1
     bbe:	a011                	j	bc2 <gets+0x56>
     bc0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     bc2:	99de                	add	s3,s3,s7
     bc4:	00098023          	sb	zero,0(s3)
  return buf;
}
     bc8:	855e                	mv	a0,s7
     bca:	60e6                	ld	ra,88(sp)
     bcc:	6446                	ld	s0,80(sp)
     bce:	64a6                	ld	s1,72(sp)
     bd0:	6906                	ld	s2,64(sp)
     bd2:	79e2                	ld	s3,56(sp)
     bd4:	7a42                	ld	s4,48(sp)
     bd6:	7aa2                	ld	s5,40(sp)
     bd8:	7b02                	ld	s6,32(sp)
     bda:	6be2                	ld	s7,24(sp)
     bdc:	6125                	addi	sp,sp,96
     bde:	8082                	ret

0000000000000be0 <stat>:

int
stat(const char *n, struct stat *st)
{
     be0:	1101                	addi	sp,sp,-32
     be2:	ec06                	sd	ra,24(sp)
     be4:	e822                	sd	s0,16(sp)
     be6:	e426                	sd	s1,8(sp)
     be8:	e04a                	sd	s2,0(sp)
     bea:	1000                	addi	s0,sp,32
     bec:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     bee:	4581                	li	a1,0
     bf0:	00000097          	auipc	ra,0x0
     bf4:	0f6080e7          	jalr	246(ra) # ce6 <open>
  if(fd < 0)
     bf8:	02054563          	bltz	a0,c22 <stat+0x42>
     bfc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     bfe:	85ca                	mv	a1,s2
     c00:	00000097          	auipc	ra,0x0
     c04:	0fe080e7          	jalr	254(ra) # cfe <fstat>
     c08:	892a                	mv	s2,a0
  close(fd);
     c0a:	8526                	mv	a0,s1
     c0c:	00000097          	auipc	ra,0x0
     c10:	0c2080e7          	jalr	194(ra) # cce <close>
  return r;
}
     c14:	854a                	mv	a0,s2
     c16:	60e2                	ld	ra,24(sp)
     c18:	6442                	ld	s0,16(sp)
     c1a:	64a2                	ld	s1,8(sp)
     c1c:	6902                	ld	s2,0(sp)
     c1e:	6105                	addi	sp,sp,32
     c20:	8082                	ret
    return -1;
     c22:	597d                	li	s2,-1
     c24:	bfc5                	j	c14 <stat+0x34>

0000000000000c26 <atoi>:

int
atoi(const char *s)
{
     c26:	1141                	addi	sp,sp,-16
     c28:	e422                	sd	s0,8(sp)
     c2a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     c2c:	00054603          	lbu	a2,0(a0)
     c30:	fd06079b          	addiw	a5,a2,-48
     c34:	0ff7f793          	andi	a5,a5,255
     c38:	4725                	li	a4,9
     c3a:	02f76963          	bltu	a4,a5,c6c <atoi+0x46>
     c3e:	86aa                	mv	a3,a0
  n = 0;
     c40:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     c42:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     c44:	0685                	addi	a3,a3,1
     c46:	0025179b          	slliw	a5,a0,0x2
     c4a:	9fa9                	addw	a5,a5,a0
     c4c:	0017979b          	slliw	a5,a5,0x1
     c50:	9fb1                	addw	a5,a5,a2
     c52:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     c56:	0006c603          	lbu	a2,0(a3)
     c5a:	fd06071b          	addiw	a4,a2,-48
     c5e:	0ff77713          	andi	a4,a4,255
     c62:	fee5f1e3          	bgeu	a1,a4,c44 <atoi+0x1e>
  return n;
}
     c66:	6422                	ld	s0,8(sp)
     c68:	0141                	addi	sp,sp,16
     c6a:	8082                	ret
  n = 0;
     c6c:	4501                	li	a0,0
     c6e:	bfe5                	j	c66 <atoi+0x40>

0000000000000c70 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     c70:	1141                	addi	sp,sp,-16
     c72:	e422                	sd	s0,8(sp)
     c74:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     c76:	02c05163          	blez	a2,c98 <memmove+0x28>
     c7a:	fff6071b          	addiw	a4,a2,-1
     c7e:	1702                	slli	a4,a4,0x20
     c80:	9301                	srli	a4,a4,0x20
     c82:	0705                	addi	a4,a4,1
     c84:	972a                	add	a4,a4,a0
  dst = vdst;
     c86:	87aa                	mv	a5,a0
    *dst++ = *src++;
     c88:	0585                	addi	a1,a1,1
     c8a:	0785                	addi	a5,a5,1
     c8c:	fff5c683          	lbu	a3,-1(a1)
     c90:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
     c94:	fee79ae3          	bne	a5,a4,c88 <memmove+0x18>
  return vdst;
}
     c98:	6422                	ld	s0,8(sp)
     c9a:	0141                	addi	sp,sp,16
     c9c:	8082                	ret

0000000000000c9e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c9e:	4885                	li	a7,1
 ecall
     ca0:	00000073          	ecall
 ret
     ca4:	8082                	ret

0000000000000ca6 <exit>:
.global exit
exit:
 li a7, SYS_exit
     ca6:	4889                	li	a7,2
 ecall
     ca8:	00000073          	ecall
 ret
     cac:	8082                	ret

0000000000000cae <wait>:
.global wait
wait:
 li a7, SYS_wait
     cae:	488d                	li	a7,3
 ecall
     cb0:	00000073          	ecall
 ret
     cb4:	8082                	ret

0000000000000cb6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     cb6:	4891                	li	a7,4
 ecall
     cb8:	00000073          	ecall
 ret
     cbc:	8082                	ret

0000000000000cbe <read>:
.global read
read:
 li a7, SYS_read
     cbe:	4895                	li	a7,5
 ecall
     cc0:	00000073          	ecall
 ret
     cc4:	8082                	ret

0000000000000cc6 <write>:
.global write
write:
 li a7, SYS_write
     cc6:	48c1                	li	a7,16
 ecall
     cc8:	00000073          	ecall
 ret
     ccc:	8082                	ret

0000000000000cce <close>:
.global close
close:
 li a7, SYS_close
     cce:	48d5                	li	a7,21
 ecall
     cd0:	00000073          	ecall
 ret
     cd4:	8082                	ret

0000000000000cd6 <kill>:
.global kill
kill:
 li a7, SYS_kill
     cd6:	4899                	li	a7,6
 ecall
     cd8:	00000073          	ecall
 ret
     cdc:	8082                	ret

0000000000000cde <exec>:
.global exec
exec:
 li a7, SYS_exec
     cde:	489d                	li	a7,7
 ecall
     ce0:	00000073          	ecall
 ret
     ce4:	8082                	ret

0000000000000ce6 <open>:
.global open
open:
 li a7, SYS_open
     ce6:	48bd                	li	a7,15
 ecall
     ce8:	00000073          	ecall
 ret
     cec:	8082                	ret

0000000000000cee <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     cee:	48c5                	li	a7,17
 ecall
     cf0:	00000073          	ecall
 ret
     cf4:	8082                	ret

0000000000000cf6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     cf6:	48c9                	li	a7,18
 ecall
     cf8:	00000073          	ecall
 ret
     cfc:	8082                	ret

0000000000000cfe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     cfe:	48a1                	li	a7,8
 ecall
     d00:	00000073          	ecall
 ret
     d04:	8082                	ret

0000000000000d06 <link>:
.global link
link:
 li a7, SYS_link
     d06:	48cd                	li	a7,19
 ecall
     d08:	00000073          	ecall
 ret
     d0c:	8082                	ret

0000000000000d0e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     d0e:	48d1                	li	a7,20
 ecall
     d10:	00000073          	ecall
 ret
     d14:	8082                	ret

0000000000000d16 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     d16:	48a5                	li	a7,9
 ecall
     d18:	00000073          	ecall
 ret
     d1c:	8082                	ret

0000000000000d1e <dup>:
.global dup
dup:
 li a7, SYS_dup
     d1e:	48a9                	li	a7,10
 ecall
     d20:	00000073          	ecall
 ret
     d24:	8082                	ret

0000000000000d26 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     d26:	48ad                	li	a7,11
 ecall
     d28:	00000073          	ecall
 ret
     d2c:	8082                	ret

0000000000000d2e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     d2e:	48b1                	li	a7,12
 ecall
     d30:	00000073          	ecall
 ret
     d34:	8082                	ret

0000000000000d36 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     d36:	48b5                	li	a7,13
 ecall
     d38:	00000073          	ecall
 ret
     d3c:	8082                	ret

0000000000000d3e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     d3e:	48b9                	li	a7,14
 ecall
     d40:	00000073          	ecall
 ret
     d44:	8082                	ret

0000000000000d46 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
     d46:	48d9                	li	a7,22
 ecall
     d48:	00000073          	ecall
 ret
     d4c:	8082                	ret

0000000000000d4e <crash>:
.global crash
crash:
 li a7, SYS_crash
     d4e:	48dd                	li	a7,23
 ecall
     d50:	00000073          	ecall
 ret
     d54:	8082                	ret

0000000000000d56 <mount>:
.global mount
mount:
 li a7, SYS_mount
     d56:	48e1                	li	a7,24
 ecall
     d58:	00000073          	ecall
 ret
     d5c:	8082                	ret

0000000000000d5e <umount>:
.global umount
umount:
 li a7, SYS_umount
     d5e:	48e5                	li	a7,25
 ecall
     d60:	00000073          	ecall
 ret
     d64:	8082                	ret

0000000000000d66 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d66:	1101                	addi	sp,sp,-32
     d68:	ec06                	sd	ra,24(sp)
     d6a:	e822                	sd	s0,16(sp)
     d6c:	1000                	addi	s0,sp,32
     d6e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d72:	4605                	li	a2,1
     d74:	fef40593          	addi	a1,s0,-17
     d78:	00000097          	auipc	ra,0x0
     d7c:	f4e080e7          	jalr	-178(ra) # cc6 <write>
}
     d80:	60e2                	ld	ra,24(sp)
     d82:	6442                	ld	s0,16(sp)
     d84:	6105                	addi	sp,sp,32
     d86:	8082                	ret

0000000000000d88 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     d88:	7139                	addi	sp,sp,-64
     d8a:	fc06                	sd	ra,56(sp)
     d8c:	f822                	sd	s0,48(sp)
     d8e:	f426                	sd	s1,40(sp)
     d90:	f04a                	sd	s2,32(sp)
     d92:	ec4e                	sd	s3,24(sp)
     d94:	0080                	addi	s0,sp,64
     d96:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d98:	c299                	beqz	a3,d9e <printint+0x16>
     d9a:	0805c863          	bltz	a1,e2a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     d9e:	2581                	sext.w	a1,a1
  neg = 0;
     da0:	4881                	li	a7,0
     da2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     da6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     da8:	2601                	sext.w	a2,a2
     daa:	00000517          	auipc	a0,0x0
     dae:	78650513          	addi	a0,a0,1926 # 1530 <digits>
     db2:	883a                	mv	a6,a4
     db4:	2705                	addiw	a4,a4,1
     db6:	02c5f7bb          	remuw	a5,a1,a2
     dba:	1782                	slli	a5,a5,0x20
     dbc:	9381                	srli	a5,a5,0x20
     dbe:	97aa                	add	a5,a5,a0
     dc0:	0007c783          	lbu	a5,0(a5)
     dc4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     dc8:	0005879b          	sext.w	a5,a1
     dcc:	02c5d5bb          	divuw	a1,a1,a2
     dd0:	0685                	addi	a3,a3,1
     dd2:	fec7f0e3          	bgeu	a5,a2,db2 <printint+0x2a>
  if(neg)
     dd6:	00088b63          	beqz	a7,dec <printint+0x64>
    buf[i++] = '-';
     dda:	fd040793          	addi	a5,s0,-48
     dde:	973e                	add	a4,a4,a5
     de0:	02d00793          	li	a5,45
     de4:	fef70823          	sb	a5,-16(a4)
     de8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     dec:	02e05863          	blez	a4,e1c <printint+0x94>
     df0:	fc040793          	addi	a5,s0,-64
     df4:	00e78933          	add	s2,a5,a4
     df8:	fff78993          	addi	s3,a5,-1
     dfc:	99ba                	add	s3,s3,a4
     dfe:	377d                	addiw	a4,a4,-1
     e00:	1702                	slli	a4,a4,0x20
     e02:	9301                	srli	a4,a4,0x20
     e04:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     e08:	fff94583          	lbu	a1,-1(s2)
     e0c:	8526                	mv	a0,s1
     e0e:	00000097          	auipc	ra,0x0
     e12:	f58080e7          	jalr	-168(ra) # d66 <putc>
  while(--i >= 0)
     e16:	197d                	addi	s2,s2,-1
     e18:	ff3918e3          	bne	s2,s3,e08 <printint+0x80>
}
     e1c:	70e2                	ld	ra,56(sp)
     e1e:	7442                	ld	s0,48(sp)
     e20:	74a2                	ld	s1,40(sp)
     e22:	7902                	ld	s2,32(sp)
     e24:	69e2                	ld	s3,24(sp)
     e26:	6121                	addi	sp,sp,64
     e28:	8082                	ret
    x = -xx;
     e2a:	40b005bb          	negw	a1,a1
    neg = 1;
     e2e:	4885                	li	a7,1
    x = -xx;
     e30:	bf8d                	j	da2 <printint+0x1a>

0000000000000e32 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     e32:	7119                	addi	sp,sp,-128
     e34:	fc86                	sd	ra,120(sp)
     e36:	f8a2                	sd	s0,112(sp)
     e38:	f4a6                	sd	s1,104(sp)
     e3a:	f0ca                	sd	s2,96(sp)
     e3c:	ecce                	sd	s3,88(sp)
     e3e:	e8d2                	sd	s4,80(sp)
     e40:	e4d6                	sd	s5,72(sp)
     e42:	e0da                	sd	s6,64(sp)
     e44:	fc5e                	sd	s7,56(sp)
     e46:	f862                	sd	s8,48(sp)
     e48:	f466                	sd	s9,40(sp)
     e4a:	f06a                	sd	s10,32(sp)
     e4c:	ec6e                	sd	s11,24(sp)
     e4e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     e50:	0005c903          	lbu	s2,0(a1)
     e54:	18090f63          	beqz	s2,ff2 <vprintf+0x1c0>
     e58:	8aaa                	mv	s5,a0
     e5a:	8b32                	mv	s6,a2
     e5c:	00158493          	addi	s1,a1,1
  state = 0;
     e60:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     e62:	02500a13          	li	s4,37
      if(c == 'd'){
     e66:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     e6a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     e6e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     e72:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e76:	00000b97          	auipc	s7,0x0
     e7a:	6bab8b93          	addi	s7,s7,1722 # 1530 <digits>
     e7e:	a839                	j	e9c <vprintf+0x6a>
        putc(fd, c);
     e80:	85ca                	mv	a1,s2
     e82:	8556                	mv	a0,s5
     e84:	00000097          	auipc	ra,0x0
     e88:	ee2080e7          	jalr	-286(ra) # d66 <putc>
     e8c:	a019                	j	e92 <vprintf+0x60>
    } else if(state == '%'){
     e8e:	01498f63          	beq	s3,s4,eac <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     e92:	0485                	addi	s1,s1,1
     e94:	fff4c903          	lbu	s2,-1(s1)
     e98:	14090d63          	beqz	s2,ff2 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     e9c:	0009079b          	sext.w	a5,s2
    if(state == 0){
     ea0:	fe0997e3          	bnez	s3,e8e <vprintf+0x5c>
      if(c == '%'){
     ea4:	fd479ee3          	bne	a5,s4,e80 <vprintf+0x4e>
        state = '%';
     ea8:	89be                	mv	s3,a5
     eaa:	b7e5                	j	e92 <vprintf+0x60>
      if(c == 'd'){
     eac:	05878063          	beq	a5,s8,eec <vprintf+0xba>
      } else if(c == 'l') {
     eb0:	05978c63          	beq	a5,s9,f08 <vprintf+0xd6>
      } else if(c == 'x') {
     eb4:	07a78863          	beq	a5,s10,f24 <vprintf+0xf2>
      } else if(c == 'p') {
     eb8:	09b78463          	beq	a5,s11,f40 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     ebc:	07300713          	li	a4,115
     ec0:	0ce78663          	beq	a5,a4,f8c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     ec4:	06300713          	li	a4,99
     ec8:	0ee78e63          	beq	a5,a4,fc4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     ecc:	11478863          	beq	a5,s4,fdc <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     ed0:	85d2                	mv	a1,s4
     ed2:	8556                	mv	a0,s5
     ed4:	00000097          	auipc	ra,0x0
     ed8:	e92080e7          	jalr	-366(ra) # d66 <putc>
        putc(fd, c);
     edc:	85ca                	mv	a1,s2
     ede:	8556                	mv	a0,s5
     ee0:	00000097          	auipc	ra,0x0
     ee4:	e86080e7          	jalr	-378(ra) # d66 <putc>
      }
      state = 0;
     ee8:	4981                	li	s3,0
     eea:	b765                	j	e92 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     eec:	008b0913          	addi	s2,s6,8
     ef0:	4685                	li	a3,1
     ef2:	4629                	li	a2,10
     ef4:	000b2583          	lw	a1,0(s6)
     ef8:	8556                	mv	a0,s5
     efa:	00000097          	auipc	ra,0x0
     efe:	e8e080e7          	jalr	-370(ra) # d88 <printint>
     f02:	8b4a                	mv	s6,s2
      state = 0;
     f04:	4981                	li	s3,0
     f06:	b771                	j	e92 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f08:	008b0913          	addi	s2,s6,8
     f0c:	4681                	li	a3,0
     f0e:	4629                	li	a2,10
     f10:	000b2583          	lw	a1,0(s6)
     f14:	8556                	mv	a0,s5
     f16:	00000097          	auipc	ra,0x0
     f1a:	e72080e7          	jalr	-398(ra) # d88 <printint>
     f1e:	8b4a                	mv	s6,s2
      state = 0;
     f20:	4981                	li	s3,0
     f22:	bf85                	j	e92 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     f24:	008b0913          	addi	s2,s6,8
     f28:	4681                	li	a3,0
     f2a:	4641                	li	a2,16
     f2c:	000b2583          	lw	a1,0(s6)
     f30:	8556                	mv	a0,s5
     f32:	00000097          	auipc	ra,0x0
     f36:	e56080e7          	jalr	-426(ra) # d88 <printint>
     f3a:	8b4a                	mv	s6,s2
      state = 0;
     f3c:	4981                	li	s3,0
     f3e:	bf91                	j	e92 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     f40:	008b0793          	addi	a5,s6,8
     f44:	f8f43423          	sd	a5,-120(s0)
     f48:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     f4c:	03000593          	li	a1,48
     f50:	8556                	mv	a0,s5
     f52:	00000097          	auipc	ra,0x0
     f56:	e14080e7          	jalr	-492(ra) # d66 <putc>
  putc(fd, 'x');
     f5a:	85ea                	mv	a1,s10
     f5c:	8556                	mv	a0,s5
     f5e:	00000097          	auipc	ra,0x0
     f62:	e08080e7          	jalr	-504(ra) # d66 <putc>
     f66:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f68:	03c9d793          	srli	a5,s3,0x3c
     f6c:	97de                	add	a5,a5,s7
     f6e:	0007c583          	lbu	a1,0(a5)
     f72:	8556                	mv	a0,s5
     f74:	00000097          	auipc	ra,0x0
     f78:	df2080e7          	jalr	-526(ra) # d66 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f7c:	0992                	slli	s3,s3,0x4
     f7e:	397d                	addiw	s2,s2,-1
     f80:	fe0914e3          	bnez	s2,f68 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
     f84:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     f88:	4981                	li	s3,0
     f8a:	b721                	j	e92 <vprintf+0x60>
        s = va_arg(ap, char*);
     f8c:	008b0993          	addi	s3,s6,8
     f90:	000b3903          	ld	s2,0(s6)
        if(s == 0)
     f94:	02090163          	beqz	s2,fb6 <vprintf+0x184>
        while(*s != 0){
     f98:	00094583          	lbu	a1,0(s2)
     f9c:	c9a1                	beqz	a1,fec <vprintf+0x1ba>
          putc(fd, *s);
     f9e:	8556                	mv	a0,s5
     fa0:	00000097          	auipc	ra,0x0
     fa4:	dc6080e7          	jalr	-570(ra) # d66 <putc>
          s++;
     fa8:	0905                	addi	s2,s2,1
        while(*s != 0){
     faa:	00094583          	lbu	a1,0(s2)
     fae:	f9e5                	bnez	a1,f9e <vprintf+0x16c>
        s = va_arg(ap, char*);
     fb0:	8b4e                	mv	s6,s3
      state = 0;
     fb2:	4981                	li	s3,0
     fb4:	bdf9                	j	e92 <vprintf+0x60>
          s = "(null)";
     fb6:	00000917          	auipc	s2,0x0
     fba:	57290913          	addi	s2,s2,1394 # 1528 <malloc+0x42c>
        while(*s != 0){
     fbe:	02800593          	li	a1,40
     fc2:	bff1                	j	f9e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
     fc4:	008b0913          	addi	s2,s6,8
     fc8:	000b4583          	lbu	a1,0(s6)
     fcc:	8556                	mv	a0,s5
     fce:	00000097          	auipc	ra,0x0
     fd2:	d98080e7          	jalr	-616(ra) # d66 <putc>
     fd6:	8b4a                	mv	s6,s2
      state = 0;
     fd8:	4981                	li	s3,0
     fda:	bd65                	j	e92 <vprintf+0x60>
        putc(fd, c);
     fdc:	85d2                	mv	a1,s4
     fde:	8556                	mv	a0,s5
     fe0:	00000097          	auipc	ra,0x0
     fe4:	d86080e7          	jalr	-634(ra) # d66 <putc>
      state = 0;
     fe8:	4981                	li	s3,0
     fea:	b565                	j	e92 <vprintf+0x60>
        s = va_arg(ap, char*);
     fec:	8b4e                	mv	s6,s3
      state = 0;
     fee:	4981                	li	s3,0
     ff0:	b54d                	j	e92 <vprintf+0x60>
    }
  }
}
     ff2:	70e6                	ld	ra,120(sp)
     ff4:	7446                	ld	s0,112(sp)
     ff6:	74a6                	ld	s1,104(sp)
     ff8:	7906                	ld	s2,96(sp)
     ffa:	69e6                	ld	s3,88(sp)
     ffc:	6a46                	ld	s4,80(sp)
     ffe:	6aa6                	ld	s5,72(sp)
    1000:	6b06                	ld	s6,64(sp)
    1002:	7be2                	ld	s7,56(sp)
    1004:	7c42                	ld	s8,48(sp)
    1006:	7ca2                	ld	s9,40(sp)
    1008:	7d02                	ld	s10,32(sp)
    100a:	6de2                	ld	s11,24(sp)
    100c:	6109                	addi	sp,sp,128
    100e:	8082                	ret

0000000000001010 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1010:	715d                	addi	sp,sp,-80
    1012:	ec06                	sd	ra,24(sp)
    1014:	e822                	sd	s0,16(sp)
    1016:	1000                	addi	s0,sp,32
    1018:	e010                	sd	a2,0(s0)
    101a:	e414                	sd	a3,8(s0)
    101c:	e818                	sd	a4,16(s0)
    101e:	ec1c                	sd	a5,24(s0)
    1020:	03043023          	sd	a6,32(s0)
    1024:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1028:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    102c:	8622                	mv	a2,s0
    102e:	00000097          	auipc	ra,0x0
    1032:	e04080e7          	jalr	-508(ra) # e32 <vprintf>
}
    1036:	60e2                	ld	ra,24(sp)
    1038:	6442                	ld	s0,16(sp)
    103a:	6161                	addi	sp,sp,80
    103c:	8082                	ret

000000000000103e <printf>:

void
printf(const char *fmt, ...)
{
    103e:	711d                	addi	sp,sp,-96
    1040:	ec06                	sd	ra,24(sp)
    1042:	e822                	sd	s0,16(sp)
    1044:	1000                	addi	s0,sp,32
    1046:	e40c                	sd	a1,8(s0)
    1048:	e810                	sd	a2,16(s0)
    104a:	ec14                	sd	a3,24(s0)
    104c:	f018                	sd	a4,32(s0)
    104e:	f41c                	sd	a5,40(s0)
    1050:	03043823          	sd	a6,48(s0)
    1054:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1058:	00840613          	addi	a2,s0,8
    105c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1060:	85aa                	mv	a1,a0
    1062:	4505                	li	a0,1
    1064:	00000097          	auipc	ra,0x0
    1068:	dce080e7          	jalr	-562(ra) # e32 <vprintf>
}
    106c:	60e2                	ld	ra,24(sp)
    106e:	6442                	ld	s0,16(sp)
    1070:	6125                	addi	sp,sp,96
    1072:	8082                	ret

0000000000001074 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1074:	1141                	addi	sp,sp,-16
    1076:	e422                	sd	s0,8(sp)
    1078:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    107a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    107e:	00000797          	auipc	a5,0x0
    1082:	4ca7b783          	ld	a5,1226(a5) # 1548 <freep>
    1086:	a805                	j	10b6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1088:	4618                	lw	a4,8(a2)
    108a:	9db9                	addw	a1,a1,a4
    108c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1090:	6398                	ld	a4,0(a5)
    1092:	6318                	ld	a4,0(a4)
    1094:	fee53823          	sd	a4,-16(a0)
    1098:	a091                	j	10dc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    109a:	ff852703          	lw	a4,-8(a0)
    109e:	9e39                	addw	a2,a2,a4
    10a0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    10a2:	ff053703          	ld	a4,-16(a0)
    10a6:	e398                	sd	a4,0(a5)
    10a8:	a099                	j	10ee <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10aa:	6398                	ld	a4,0(a5)
    10ac:	00e7e463          	bltu	a5,a4,10b4 <free+0x40>
    10b0:	00e6ea63          	bltu	a3,a4,10c4 <free+0x50>
{
    10b4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10b6:	fed7fae3          	bgeu	a5,a3,10aa <free+0x36>
    10ba:	6398                	ld	a4,0(a5)
    10bc:	00e6e463          	bltu	a3,a4,10c4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10c0:	fee7eae3          	bltu	a5,a4,10b4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    10c4:	ff852583          	lw	a1,-8(a0)
    10c8:	6390                	ld	a2,0(a5)
    10ca:	02059713          	slli	a4,a1,0x20
    10ce:	9301                	srli	a4,a4,0x20
    10d0:	0712                	slli	a4,a4,0x4
    10d2:	9736                	add	a4,a4,a3
    10d4:	fae60ae3          	beq	a2,a4,1088 <free+0x14>
    bp->s.ptr = p->s.ptr;
    10d8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    10dc:	4790                	lw	a2,8(a5)
    10de:	02061713          	slli	a4,a2,0x20
    10e2:	9301                	srli	a4,a4,0x20
    10e4:	0712                	slli	a4,a4,0x4
    10e6:	973e                	add	a4,a4,a5
    10e8:	fae689e3          	beq	a3,a4,109a <free+0x26>
  } else
    p->s.ptr = bp;
    10ec:	e394                	sd	a3,0(a5)
  freep = p;
    10ee:	00000717          	auipc	a4,0x0
    10f2:	44f73d23          	sd	a5,1114(a4) # 1548 <freep>
}
    10f6:	6422                	ld	s0,8(sp)
    10f8:	0141                	addi	sp,sp,16
    10fa:	8082                	ret

00000000000010fc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    10fc:	7139                	addi	sp,sp,-64
    10fe:	fc06                	sd	ra,56(sp)
    1100:	f822                	sd	s0,48(sp)
    1102:	f426                	sd	s1,40(sp)
    1104:	f04a                	sd	s2,32(sp)
    1106:	ec4e                	sd	s3,24(sp)
    1108:	e852                	sd	s4,16(sp)
    110a:	e456                	sd	s5,8(sp)
    110c:	e05a                	sd	s6,0(sp)
    110e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1110:	02051493          	slli	s1,a0,0x20
    1114:	9081                	srli	s1,s1,0x20
    1116:	04bd                	addi	s1,s1,15
    1118:	8091                	srli	s1,s1,0x4
    111a:	0014899b          	addiw	s3,s1,1
    111e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1120:	00000517          	auipc	a0,0x0
    1124:	42853503          	ld	a0,1064(a0) # 1548 <freep>
    1128:	c515                	beqz	a0,1154 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    112a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    112c:	4798                	lw	a4,8(a5)
    112e:	02977f63          	bgeu	a4,s1,116c <malloc+0x70>
    1132:	8a4e                	mv	s4,s3
    1134:	0009871b          	sext.w	a4,s3
    1138:	6685                	lui	a3,0x1
    113a:	00d77363          	bgeu	a4,a3,1140 <malloc+0x44>
    113e:	6a05                	lui	s4,0x1
    1140:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1144:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1148:	00000917          	auipc	s2,0x0
    114c:	40090913          	addi	s2,s2,1024 # 1548 <freep>
  if(p == (char*)-1)
    1150:	5afd                	li	s5,-1
    1152:	a88d                	j	11c4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    1154:	00000797          	auipc	a5,0x0
    1158:	3fc78793          	addi	a5,a5,1020 # 1550 <base>
    115c:	00000717          	auipc	a4,0x0
    1160:	3ef73623          	sd	a5,1004(a4) # 1548 <freep>
    1164:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1166:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    116a:	b7e1                	j	1132 <malloc+0x36>
      if(p->s.size == nunits)
    116c:	02e48b63          	beq	s1,a4,11a2 <malloc+0xa6>
        p->s.size -= nunits;
    1170:	4137073b          	subw	a4,a4,s3
    1174:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1176:	1702                	slli	a4,a4,0x20
    1178:	9301                	srli	a4,a4,0x20
    117a:	0712                	slli	a4,a4,0x4
    117c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    117e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1182:	00000717          	auipc	a4,0x0
    1186:	3ca73323          	sd	a0,966(a4) # 1548 <freep>
      return (void*)(p + 1);
    118a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    118e:	70e2                	ld	ra,56(sp)
    1190:	7442                	ld	s0,48(sp)
    1192:	74a2                	ld	s1,40(sp)
    1194:	7902                	ld	s2,32(sp)
    1196:	69e2                	ld	s3,24(sp)
    1198:	6a42                	ld	s4,16(sp)
    119a:	6aa2                	ld	s5,8(sp)
    119c:	6b02                	ld	s6,0(sp)
    119e:	6121                	addi	sp,sp,64
    11a0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    11a2:	6398                	ld	a4,0(a5)
    11a4:	e118                	sd	a4,0(a0)
    11a6:	bff1                	j	1182 <malloc+0x86>
  hp->s.size = nu;
    11a8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11ac:	0541                	addi	a0,a0,16
    11ae:	00000097          	auipc	ra,0x0
    11b2:	ec6080e7          	jalr	-314(ra) # 1074 <free>
  return freep;
    11b6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    11ba:	d971                	beqz	a0,118e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11be:	4798                	lw	a4,8(a5)
    11c0:	fa9776e3          	bgeu	a4,s1,116c <malloc+0x70>
    if(p == freep)
    11c4:	00093703          	ld	a4,0(s2)
    11c8:	853e                	mv	a0,a5
    11ca:	fef719e3          	bne	a4,a5,11bc <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    11ce:	8552                	mv	a0,s4
    11d0:	00000097          	auipc	ra,0x0
    11d4:	b5e080e7          	jalr	-1186(ra) # d2e <sbrk>
  if(p == (char*)-1)
    11d8:	fd5518e3          	bne	a0,s5,11a8 <malloc+0xac>
        return 0;
    11dc:	4501                	li	a0,0
    11de:	bf45                	j	118e <malloc+0x92>
