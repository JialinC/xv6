
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
       0:	00007797          	auipc	a5,0x7
       4:	bd078793          	addi	a5,a5,-1072 # 6bd0 <uninit>
       8:	00009697          	auipc	a3,0x9
       c:	2d868693          	addi	a3,a3,728 # 92e0 <buf>
    if(uninit[i] != '\0'){
      10:	0007c703          	lbu	a4,0(a5)
      14:	e709                	bnez	a4,1e <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      16:	0785                	addi	a5,a5,1
      18:	fed79ce3          	bne	a5,a3,10 <bsstest+0x10>
      1c:	8082                	ret
{
      1e:	1141                	addi	sp,sp,-16
      20:	e406                	sd	ra,8(sp)
      22:	e022                	sd	s0,0(sp)
      24:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      26:	85aa                	mv	a1,a0
      28:	00005517          	auipc	a0,0x5
      2c:	c6050513          	addi	a0,a0,-928 # 4c88 <malloc+0x372>
      30:	00004097          	auipc	ra,0x4
      34:	7d0080e7          	jalr	2000(ra) # 4800 <printf>
      exit(1);
      38:	4505                	li	a0,1
      3a:	00004097          	auipc	ra,0x4
      3e:	43e080e7          	jalr	1086(ra) # 4478 <exit>

0000000000000042 <iputtest>:
{
      42:	1101                	addi	sp,sp,-32
      44:	ec06                	sd	ra,24(sp)
      46:	e822                	sd	s0,16(sp)
      48:	e426                	sd	s1,8(sp)
      4a:	1000                	addi	s0,sp,32
      4c:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
      4e:	00005517          	auipc	a0,0x5
      52:	c5250513          	addi	a0,a0,-942 # 4ca0 <malloc+0x38a>
      56:	00004097          	auipc	ra,0x4
      5a:	48a080e7          	jalr	1162(ra) # 44e0 <mkdir>
      5e:	04054563          	bltz	a0,a8 <iputtest+0x66>
  if(chdir("iputdir") < 0){
      62:	00005517          	auipc	a0,0x5
      66:	c3e50513          	addi	a0,a0,-962 # 4ca0 <malloc+0x38a>
      6a:	00004097          	auipc	ra,0x4
      6e:	47e080e7          	jalr	1150(ra) # 44e8 <chdir>
      72:	04054963          	bltz	a0,c4 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
      76:	00005517          	auipc	a0,0x5
      7a:	c6a50513          	addi	a0,a0,-918 # 4ce0 <malloc+0x3ca>
      7e:	00004097          	auipc	ra,0x4
      82:	44a080e7          	jalr	1098(ra) # 44c8 <unlink>
      86:	04054d63          	bltz	a0,e0 <iputtest+0x9e>
  if(chdir("/") < 0){
      8a:	00005517          	auipc	a0,0x5
      8e:	c8650513          	addi	a0,a0,-890 # 4d10 <malloc+0x3fa>
      92:	00004097          	auipc	ra,0x4
      96:	456080e7          	jalr	1110(ra) # 44e8 <chdir>
      9a:	06054163          	bltz	a0,fc <iputtest+0xba>
}
      9e:	60e2                	ld	ra,24(sp)
      a0:	6442                	ld	s0,16(sp)
      a2:	64a2                	ld	s1,8(sp)
      a4:	6105                	addi	sp,sp,32
      a6:	8082                	ret
    printf("%s: mkdir failed\n", s);
      a8:	85a6                	mv	a1,s1
      aa:	00005517          	auipc	a0,0x5
      ae:	bfe50513          	addi	a0,a0,-1026 # 4ca8 <malloc+0x392>
      b2:	00004097          	auipc	ra,0x4
      b6:	74e080e7          	jalr	1870(ra) # 4800 <printf>
    exit(1);
      ba:	4505                	li	a0,1
      bc:	00004097          	auipc	ra,0x4
      c0:	3bc080e7          	jalr	956(ra) # 4478 <exit>
    printf("%s: chdir iputdir failed\n", s);
      c4:	85a6                	mv	a1,s1
      c6:	00005517          	auipc	a0,0x5
      ca:	bfa50513          	addi	a0,a0,-1030 # 4cc0 <malloc+0x3aa>
      ce:	00004097          	auipc	ra,0x4
      d2:	732080e7          	jalr	1842(ra) # 4800 <printf>
    exit(1);
      d6:	4505                	li	a0,1
      d8:	00004097          	auipc	ra,0x4
      dc:	3a0080e7          	jalr	928(ra) # 4478 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
      e0:	85a6                	mv	a1,s1
      e2:	00005517          	auipc	a0,0x5
      e6:	c0e50513          	addi	a0,a0,-1010 # 4cf0 <malloc+0x3da>
      ea:	00004097          	auipc	ra,0x4
      ee:	716080e7          	jalr	1814(ra) # 4800 <printf>
    exit(1);
      f2:	4505                	li	a0,1
      f4:	00004097          	auipc	ra,0x4
      f8:	384080e7          	jalr	900(ra) # 4478 <exit>
    printf("%s: chdir / failed\n", s);
      fc:	85a6                	mv	a1,s1
      fe:	00005517          	auipc	a0,0x5
     102:	c1a50513          	addi	a0,a0,-998 # 4d18 <malloc+0x402>
     106:	00004097          	auipc	ra,0x4
     10a:	6fa080e7          	jalr	1786(ra) # 4800 <printf>
    exit(1);
     10e:	4505                	li	a0,1
     110:	00004097          	auipc	ra,0x4
     114:	368080e7          	jalr	872(ra) # 4478 <exit>

0000000000000118 <rmdot>:
{
     118:	1101                	addi	sp,sp,-32
     11a:	ec06                	sd	ra,24(sp)
     11c:	e822                	sd	s0,16(sp)
     11e:	e426                	sd	s1,8(sp)
     120:	1000                	addi	s0,sp,32
     122:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
     124:	00005517          	auipc	a0,0x5
     128:	c0c50513          	addi	a0,a0,-1012 # 4d30 <malloc+0x41a>
     12c:	00004097          	auipc	ra,0x4
     130:	3b4080e7          	jalr	948(ra) # 44e0 <mkdir>
     134:	e549                	bnez	a0,1be <rmdot+0xa6>
  if(chdir("dots") != 0){
     136:	00005517          	auipc	a0,0x5
     13a:	bfa50513          	addi	a0,a0,-1030 # 4d30 <malloc+0x41a>
     13e:	00004097          	auipc	ra,0x4
     142:	3aa080e7          	jalr	938(ra) # 44e8 <chdir>
     146:	e951                	bnez	a0,1da <rmdot+0xc2>
  if(unlink(".") == 0){
     148:	00005517          	auipc	a0,0x5
     14c:	c2050513          	addi	a0,a0,-992 # 4d68 <malloc+0x452>
     150:	00004097          	auipc	ra,0x4
     154:	378080e7          	jalr	888(ra) # 44c8 <unlink>
     158:	cd59                	beqz	a0,1f6 <rmdot+0xde>
  if(unlink("..") == 0){
     15a:	00005517          	auipc	a0,0x5
     15e:	c2e50513          	addi	a0,a0,-978 # 4d88 <malloc+0x472>
     162:	00004097          	auipc	ra,0x4
     166:	366080e7          	jalr	870(ra) # 44c8 <unlink>
     16a:	c545                	beqz	a0,212 <rmdot+0xfa>
  if(chdir("/") != 0){
     16c:	00005517          	auipc	a0,0x5
     170:	ba450513          	addi	a0,a0,-1116 # 4d10 <malloc+0x3fa>
     174:	00004097          	auipc	ra,0x4
     178:	374080e7          	jalr	884(ra) # 44e8 <chdir>
     17c:	e94d                	bnez	a0,22e <rmdot+0x116>
  if(unlink("dots/.") == 0){
     17e:	00005517          	auipc	a0,0x5
     182:	c2a50513          	addi	a0,a0,-982 # 4da8 <malloc+0x492>
     186:	00004097          	auipc	ra,0x4
     18a:	342080e7          	jalr	834(ra) # 44c8 <unlink>
     18e:	cd55                	beqz	a0,24a <rmdot+0x132>
  if(unlink("dots/..") == 0){
     190:	00005517          	auipc	a0,0x5
     194:	c4050513          	addi	a0,a0,-960 # 4dd0 <malloc+0x4ba>
     198:	00004097          	auipc	ra,0x4
     19c:	330080e7          	jalr	816(ra) # 44c8 <unlink>
     1a0:	c179                	beqz	a0,266 <rmdot+0x14e>
  if(unlink("dots") != 0){
     1a2:	00005517          	auipc	a0,0x5
     1a6:	b8e50513          	addi	a0,a0,-1138 # 4d30 <malloc+0x41a>
     1aa:	00004097          	auipc	ra,0x4
     1ae:	31e080e7          	jalr	798(ra) # 44c8 <unlink>
     1b2:	e961                	bnez	a0,282 <rmdot+0x16a>
}
     1b4:	60e2                	ld	ra,24(sp)
     1b6:	6442                	ld	s0,16(sp)
     1b8:	64a2                	ld	s1,8(sp)
     1ba:	6105                	addi	sp,sp,32
     1bc:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
     1be:	85a6                	mv	a1,s1
     1c0:	00005517          	auipc	a0,0x5
     1c4:	b7850513          	addi	a0,a0,-1160 # 4d38 <malloc+0x422>
     1c8:	00004097          	auipc	ra,0x4
     1cc:	638080e7          	jalr	1592(ra) # 4800 <printf>
    exit(1);
     1d0:	4505                	li	a0,1
     1d2:	00004097          	auipc	ra,0x4
     1d6:	2a6080e7          	jalr	678(ra) # 4478 <exit>
    printf("%s: chdir dots failed\n", s);
     1da:	85a6                	mv	a1,s1
     1dc:	00005517          	auipc	a0,0x5
     1e0:	b7450513          	addi	a0,a0,-1164 # 4d50 <malloc+0x43a>
     1e4:	00004097          	auipc	ra,0x4
     1e8:	61c080e7          	jalr	1564(ra) # 4800 <printf>
    exit(1);
     1ec:	4505                	li	a0,1
     1ee:	00004097          	auipc	ra,0x4
     1f2:	28a080e7          	jalr	650(ra) # 4478 <exit>
    printf("%s: rm . worked!\n", s);
     1f6:	85a6                	mv	a1,s1
     1f8:	00005517          	auipc	a0,0x5
     1fc:	b7850513          	addi	a0,a0,-1160 # 4d70 <malloc+0x45a>
     200:	00004097          	auipc	ra,0x4
     204:	600080e7          	jalr	1536(ra) # 4800 <printf>
    exit(1);
     208:	4505                	li	a0,1
     20a:	00004097          	auipc	ra,0x4
     20e:	26e080e7          	jalr	622(ra) # 4478 <exit>
    printf("%s: rm .. worked!\n", s);
     212:	85a6                	mv	a1,s1
     214:	00005517          	auipc	a0,0x5
     218:	b7c50513          	addi	a0,a0,-1156 # 4d90 <malloc+0x47a>
     21c:	00004097          	auipc	ra,0x4
     220:	5e4080e7          	jalr	1508(ra) # 4800 <printf>
    exit(1);
     224:	4505                	li	a0,1
     226:	00004097          	auipc	ra,0x4
     22a:	252080e7          	jalr	594(ra) # 4478 <exit>
    printf("%s: chdir / failed\n", s);
     22e:	85a6                	mv	a1,s1
     230:	00005517          	auipc	a0,0x5
     234:	ae850513          	addi	a0,a0,-1304 # 4d18 <malloc+0x402>
     238:	00004097          	auipc	ra,0x4
     23c:	5c8080e7          	jalr	1480(ra) # 4800 <printf>
    exit(1);
     240:	4505                	li	a0,1
     242:	00004097          	auipc	ra,0x4
     246:	236080e7          	jalr	566(ra) # 4478 <exit>
    printf("%s: unlink dots/. worked!\n", s);
     24a:	85a6                	mv	a1,s1
     24c:	00005517          	auipc	a0,0x5
     250:	b6450513          	addi	a0,a0,-1180 # 4db0 <malloc+0x49a>
     254:	00004097          	auipc	ra,0x4
     258:	5ac080e7          	jalr	1452(ra) # 4800 <printf>
    exit(1);
     25c:	4505                	li	a0,1
     25e:	00004097          	auipc	ra,0x4
     262:	21a080e7          	jalr	538(ra) # 4478 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
     266:	85a6                	mv	a1,s1
     268:	00005517          	auipc	a0,0x5
     26c:	b7050513          	addi	a0,a0,-1168 # 4dd8 <malloc+0x4c2>
     270:	00004097          	auipc	ra,0x4
     274:	590080e7          	jalr	1424(ra) # 4800 <printf>
    exit(1);
     278:	4505                	li	a0,1
     27a:	00004097          	auipc	ra,0x4
     27e:	1fe080e7          	jalr	510(ra) # 4478 <exit>
    printf("%s: unlink dots failed!\n", s);
     282:	85a6                	mv	a1,s1
     284:	00005517          	auipc	a0,0x5
     288:	b7450513          	addi	a0,a0,-1164 # 4df8 <malloc+0x4e2>
     28c:	00004097          	auipc	ra,0x4
     290:	574080e7          	jalr	1396(ra) # 4800 <printf>
    exit(1);
     294:	4505                	li	a0,1
     296:	00004097          	auipc	ra,0x4
     29a:	1e2080e7          	jalr	482(ra) # 4478 <exit>

000000000000029e <exitiputtest>:
{
     29e:	7179                	addi	sp,sp,-48
     2a0:	f406                	sd	ra,40(sp)
     2a2:	f022                	sd	s0,32(sp)
     2a4:	ec26                	sd	s1,24(sp)
     2a6:	1800                	addi	s0,sp,48
     2a8:	84aa                	mv	s1,a0
  pid = fork();
     2aa:	00004097          	auipc	ra,0x4
     2ae:	1c6080e7          	jalr	454(ra) # 4470 <fork>
  if(pid < 0){
     2b2:	04054663          	bltz	a0,2fe <exitiputtest+0x60>
  if(pid == 0){
     2b6:	ed45                	bnez	a0,36e <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
     2b8:	00005517          	auipc	a0,0x5
     2bc:	9e850513          	addi	a0,a0,-1560 # 4ca0 <malloc+0x38a>
     2c0:	00004097          	auipc	ra,0x4
     2c4:	220080e7          	jalr	544(ra) # 44e0 <mkdir>
     2c8:	04054963          	bltz	a0,31a <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
     2cc:	00005517          	auipc	a0,0x5
     2d0:	9d450513          	addi	a0,a0,-1580 # 4ca0 <malloc+0x38a>
     2d4:	00004097          	auipc	ra,0x4
     2d8:	214080e7          	jalr	532(ra) # 44e8 <chdir>
     2dc:	04054d63          	bltz	a0,336 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
     2e0:	00005517          	auipc	a0,0x5
     2e4:	a0050513          	addi	a0,a0,-1536 # 4ce0 <malloc+0x3ca>
     2e8:	00004097          	auipc	ra,0x4
     2ec:	1e0080e7          	jalr	480(ra) # 44c8 <unlink>
     2f0:	06054163          	bltz	a0,352 <exitiputtest+0xb4>
    exit(0);
     2f4:	4501                	li	a0,0
     2f6:	00004097          	auipc	ra,0x4
     2fa:	182080e7          	jalr	386(ra) # 4478 <exit>
    printf("%s: fork failed\n", s);
     2fe:	85a6                	mv	a1,s1
     300:	00005517          	auipc	a0,0x5
     304:	b1850513          	addi	a0,a0,-1256 # 4e18 <malloc+0x502>
     308:	00004097          	auipc	ra,0x4
     30c:	4f8080e7          	jalr	1272(ra) # 4800 <printf>
    exit(1);
     310:	4505                	li	a0,1
     312:	00004097          	auipc	ra,0x4
     316:	166080e7          	jalr	358(ra) # 4478 <exit>
      printf("%s: mkdir failed\n", s);
     31a:	85a6                	mv	a1,s1
     31c:	00005517          	auipc	a0,0x5
     320:	98c50513          	addi	a0,a0,-1652 # 4ca8 <malloc+0x392>
     324:	00004097          	auipc	ra,0x4
     328:	4dc080e7          	jalr	1244(ra) # 4800 <printf>
      exit(1);
     32c:	4505                	li	a0,1
     32e:	00004097          	auipc	ra,0x4
     332:	14a080e7          	jalr	330(ra) # 4478 <exit>
      printf("%s: child chdir failed\n", s);
     336:	85a6                	mv	a1,s1
     338:	00005517          	auipc	a0,0x5
     33c:	af850513          	addi	a0,a0,-1288 # 4e30 <malloc+0x51a>
     340:	00004097          	auipc	ra,0x4
     344:	4c0080e7          	jalr	1216(ra) # 4800 <printf>
      exit(1);
     348:	4505                	li	a0,1
     34a:	00004097          	auipc	ra,0x4
     34e:	12e080e7          	jalr	302(ra) # 4478 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
     352:	85a6                	mv	a1,s1
     354:	00005517          	auipc	a0,0x5
     358:	99c50513          	addi	a0,a0,-1636 # 4cf0 <malloc+0x3da>
     35c:	00004097          	auipc	ra,0x4
     360:	4a4080e7          	jalr	1188(ra) # 4800 <printf>
      exit(1);
     364:	4505                	li	a0,1
     366:	00004097          	auipc	ra,0x4
     36a:	112080e7          	jalr	274(ra) # 4478 <exit>
  wait(&xstatus);
     36e:	fdc40513          	addi	a0,s0,-36
     372:	00004097          	auipc	ra,0x4
     376:	10e080e7          	jalr	270(ra) # 4480 <wait>
  exit(xstatus);
     37a:	fdc42503          	lw	a0,-36(s0)
     37e:	00004097          	auipc	ra,0x4
     382:	0fa080e7          	jalr	250(ra) # 4478 <exit>

0000000000000386 <exitwait>:
{
     386:	7139                	addi	sp,sp,-64
     388:	fc06                	sd	ra,56(sp)
     38a:	f822                	sd	s0,48(sp)
     38c:	f426                	sd	s1,40(sp)
     38e:	f04a                	sd	s2,32(sp)
     390:	ec4e                	sd	s3,24(sp)
     392:	e852                	sd	s4,16(sp)
     394:	0080                	addi	s0,sp,64
     396:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
     398:	4901                	li	s2,0
     39a:	06400993          	li	s3,100
    pid = fork();
     39e:	00004097          	auipc	ra,0x4
     3a2:	0d2080e7          	jalr	210(ra) # 4470 <fork>
     3a6:	84aa                	mv	s1,a0
    if(pid < 0){
     3a8:	02054a63          	bltz	a0,3dc <exitwait+0x56>
    if(pid){
     3ac:	c151                	beqz	a0,430 <exitwait+0xaa>
      if(wait(&xstate) != pid){
     3ae:	fcc40513          	addi	a0,s0,-52
     3b2:	00004097          	auipc	ra,0x4
     3b6:	0ce080e7          	jalr	206(ra) # 4480 <wait>
     3ba:	02951f63          	bne	a0,s1,3f8 <exitwait+0x72>
      if(i != xstate) {
     3be:	fcc42783          	lw	a5,-52(s0)
     3c2:	05279963          	bne	a5,s2,414 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
     3c6:	2905                	addiw	s2,s2,1
     3c8:	fd391be3          	bne	s2,s3,39e <exitwait+0x18>
}
     3cc:	70e2                	ld	ra,56(sp)
     3ce:	7442                	ld	s0,48(sp)
     3d0:	74a2                	ld	s1,40(sp)
     3d2:	7902                	ld	s2,32(sp)
     3d4:	69e2                	ld	s3,24(sp)
     3d6:	6a42                	ld	s4,16(sp)
     3d8:	6121                	addi	sp,sp,64
     3da:	8082                	ret
      printf("%s: fork failed\n", s);
     3dc:	85d2                	mv	a1,s4
     3de:	00005517          	auipc	a0,0x5
     3e2:	a3a50513          	addi	a0,a0,-1478 # 4e18 <malloc+0x502>
     3e6:	00004097          	auipc	ra,0x4
     3ea:	41a080e7          	jalr	1050(ra) # 4800 <printf>
      exit(1);
     3ee:	4505                	li	a0,1
     3f0:	00004097          	auipc	ra,0x4
     3f4:	088080e7          	jalr	136(ra) # 4478 <exit>
        printf("%s: wait wrong pid\n", s);
     3f8:	85d2                	mv	a1,s4
     3fa:	00005517          	auipc	a0,0x5
     3fe:	a4e50513          	addi	a0,a0,-1458 # 4e48 <malloc+0x532>
     402:	00004097          	auipc	ra,0x4
     406:	3fe080e7          	jalr	1022(ra) # 4800 <printf>
        exit(1);
     40a:	4505                	li	a0,1
     40c:	00004097          	auipc	ra,0x4
     410:	06c080e7          	jalr	108(ra) # 4478 <exit>
        printf("%s: wait wrong exit status\n", s);
     414:	85d2                	mv	a1,s4
     416:	00005517          	auipc	a0,0x5
     41a:	a4a50513          	addi	a0,a0,-1462 # 4e60 <malloc+0x54a>
     41e:	00004097          	auipc	ra,0x4
     422:	3e2080e7          	jalr	994(ra) # 4800 <printf>
        exit(1);
     426:	4505                	li	a0,1
     428:	00004097          	auipc	ra,0x4
     42c:	050080e7          	jalr	80(ra) # 4478 <exit>
      exit(i);
     430:	854a                	mv	a0,s2
     432:	00004097          	auipc	ra,0x4
     436:	046080e7          	jalr	70(ra) # 4478 <exit>

000000000000043a <twochildren>:
{
     43a:	1101                	addi	sp,sp,-32
     43c:	ec06                	sd	ra,24(sp)
     43e:	e822                	sd	s0,16(sp)
     440:	e426                	sd	s1,8(sp)
     442:	e04a                	sd	s2,0(sp)
     444:	1000                	addi	s0,sp,32
     446:	892a                	mv	s2,a0
     448:	3e800493          	li	s1,1000
    int pid1 = fork();
     44c:	00004097          	auipc	ra,0x4
     450:	024080e7          	jalr	36(ra) # 4470 <fork>
    if(pid1 < 0){
     454:	02054c63          	bltz	a0,48c <twochildren+0x52>
    if(pid1 == 0){
     458:	c921                	beqz	a0,4a8 <twochildren+0x6e>
      int pid2 = fork();
     45a:	00004097          	auipc	ra,0x4
     45e:	016080e7          	jalr	22(ra) # 4470 <fork>
      if(pid2 < 0){
     462:	04054763          	bltz	a0,4b0 <twochildren+0x76>
      if(pid2 == 0){
     466:	c13d                	beqz	a0,4cc <twochildren+0x92>
        wait(0);
     468:	4501                	li	a0,0
     46a:	00004097          	auipc	ra,0x4
     46e:	016080e7          	jalr	22(ra) # 4480 <wait>
        wait(0);
     472:	4501                	li	a0,0
     474:	00004097          	auipc	ra,0x4
     478:	00c080e7          	jalr	12(ra) # 4480 <wait>
  for(int i = 0; i < 1000; i++){
     47c:	34fd                	addiw	s1,s1,-1
     47e:	f4f9                	bnez	s1,44c <twochildren+0x12>
}
     480:	60e2                	ld	ra,24(sp)
     482:	6442                	ld	s0,16(sp)
     484:	64a2                	ld	s1,8(sp)
     486:	6902                	ld	s2,0(sp)
     488:	6105                	addi	sp,sp,32
     48a:	8082                	ret
      printf("%s: fork failed\n", s);
     48c:	85ca                	mv	a1,s2
     48e:	00005517          	auipc	a0,0x5
     492:	98a50513          	addi	a0,a0,-1654 # 4e18 <malloc+0x502>
     496:	00004097          	auipc	ra,0x4
     49a:	36a080e7          	jalr	874(ra) # 4800 <printf>
      exit(1);
     49e:	4505                	li	a0,1
     4a0:	00004097          	auipc	ra,0x4
     4a4:	fd8080e7          	jalr	-40(ra) # 4478 <exit>
      exit(0);
     4a8:	00004097          	auipc	ra,0x4
     4ac:	fd0080e7          	jalr	-48(ra) # 4478 <exit>
        printf("%s: fork failed\n", s);
     4b0:	85ca                	mv	a1,s2
     4b2:	00005517          	auipc	a0,0x5
     4b6:	96650513          	addi	a0,a0,-1690 # 4e18 <malloc+0x502>
     4ba:	00004097          	auipc	ra,0x4
     4be:	346080e7          	jalr	838(ra) # 4800 <printf>
        exit(1);
     4c2:	4505                	li	a0,1
     4c4:	00004097          	auipc	ra,0x4
     4c8:	fb4080e7          	jalr	-76(ra) # 4478 <exit>
        exit(0);
     4cc:	00004097          	auipc	ra,0x4
     4d0:	fac080e7          	jalr	-84(ra) # 4478 <exit>

00000000000004d4 <forkfork>:
{
     4d4:	7179                	addi	sp,sp,-48
     4d6:	f406                	sd	ra,40(sp)
     4d8:	f022                	sd	s0,32(sp)
     4da:	ec26                	sd	s1,24(sp)
     4dc:	1800                	addi	s0,sp,48
     4de:	84aa                	mv	s1,a0
    int pid = fork();
     4e0:	00004097          	auipc	ra,0x4
     4e4:	f90080e7          	jalr	-112(ra) # 4470 <fork>
    if(pid < 0){
     4e8:	04054163          	bltz	a0,52a <forkfork+0x56>
    if(pid == 0){
     4ec:	cd29                	beqz	a0,546 <forkfork+0x72>
    int pid = fork();
     4ee:	00004097          	auipc	ra,0x4
     4f2:	f82080e7          	jalr	-126(ra) # 4470 <fork>
    if(pid < 0){
     4f6:	02054a63          	bltz	a0,52a <forkfork+0x56>
    if(pid == 0){
     4fa:	c531                	beqz	a0,546 <forkfork+0x72>
    wait(&xstatus);
     4fc:	fdc40513          	addi	a0,s0,-36
     500:	00004097          	auipc	ra,0x4
     504:	f80080e7          	jalr	-128(ra) # 4480 <wait>
    if(xstatus != 0) {
     508:	fdc42783          	lw	a5,-36(s0)
     50c:	ebbd                	bnez	a5,582 <forkfork+0xae>
    wait(&xstatus);
     50e:	fdc40513          	addi	a0,s0,-36
     512:	00004097          	auipc	ra,0x4
     516:	f6e080e7          	jalr	-146(ra) # 4480 <wait>
    if(xstatus != 0) {
     51a:	fdc42783          	lw	a5,-36(s0)
     51e:	e3b5                	bnez	a5,582 <forkfork+0xae>
}
     520:	70a2                	ld	ra,40(sp)
     522:	7402                	ld	s0,32(sp)
     524:	64e2                	ld	s1,24(sp)
     526:	6145                	addi	sp,sp,48
     528:	8082                	ret
      printf("%s: fork failed", s);
     52a:	85a6                	mv	a1,s1
     52c:	00005517          	auipc	a0,0x5
     530:	95450513          	addi	a0,a0,-1708 # 4e80 <malloc+0x56a>
     534:	00004097          	auipc	ra,0x4
     538:	2cc080e7          	jalr	716(ra) # 4800 <printf>
      exit(1);
     53c:	4505                	li	a0,1
     53e:	00004097          	auipc	ra,0x4
     542:	f3a080e7          	jalr	-198(ra) # 4478 <exit>
{
     546:	0c800493          	li	s1,200
        int pid1 = fork();
     54a:	00004097          	auipc	ra,0x4
     54e:	f26080e7          	jalr	-218(ra) # 4470 <fork>
        if(pid1 < 0){
     552:	00054f63          	bltz	a0,570 <forkfork+0x9c>
        if(pid1 == 0){
     556:	c115                	beqz	a0,57a <forkfork+0xa6>
        wait(0);
     558:	4501                	li	a0,0
     55a:	00004097          	auipc	ra,0x4
     55e:	f26080e7          	jalr	-218(ra) # 4480 <wait>
      for(int j = 0; j < 200; j++){
     562:	34fd                	addiw	s1,s1,-1
     564:	f0fd                	bnez	s1,54a <forkfork+0x76>
      exit(0);
     566:	4501                	li	a0,0
     568:	00004097          	auipc	ra,0x4
     56c:	f10080e7          	jalr	-240(ra) # 4478 <exit>
          exit(1);
     570:	4505                	li	a0,1
     572:	00004097          	auipc	ra,0x4
     576:	f06080e7          	jalr	-250(ra) # 4478 <exit>
          exit(0);
     57a:	00004097          	auipc	ra,0x4
     57e:	efe080e7          	jalr	-258(ra) # 4478 <exit>
      printf("%s: fork in child failed", s);
     582:	85a6                	mv	a1,s1
     584:	00005517          	auipc	a0,0x5
     588:	90c50513          	addi	a0,a0,-1780 # 4e90 <malloc+0x57a>
     58c:	00004097          	auipc	ra,0x4
     590:	274080e7          	jalr	628(ra) # 4800 <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	00004097          	auipc	ra,0x4
     59a:	ee2080e7          	jalr	-286(ra) # 4478 <exit>

000000000000059e <reparent2>:
{
     59e:	1101                	addi	sp,sp,-32
     5a0:	ec06                	sd	ra,24(sp)
     5a2:	e822                	sd	s0,16(sp)
     5a4:	e426                	sd	s1,8(sp)
     5a6:	1000                	addi	s0,sp,32
     5a8:	32000493          	li	s1,800
    int pid1 = fork();
     5ac:	00004097          	auipc	ra,0x4
     5b0:	ec4080e7          	jalr	-316(ra) # 4470 <fork>
    if(pid1 < 0){
     5b4:	00054f63          	bltz	a0,5d2 <reparent2+0x34>
    if(pid1 == 0){
     5b8:	c915                	beqz	a0,5ec <reparent2+0x4e>
    wait(0);
     5ba:	4501                	li	a0,0
     5bc:	00004097          	auipc	ra,0x4
     5c0:	ec4080e7          	jalr	-316(ra) # 4480 <wait>
  for(int i = 0; i < 800; i++){
     5c4:	34fd                	addiw	s1,s1,-1
     5c6:	f0fd                	bnez	s1,5ac <reparent2+0xe>
  exit(0);
     5c8:	4501                	li	a0,0
     5ca:	00004097          	auipc	ra,0x4
     5ce:	eae080e7          	jalr	-338(ra) # 4478 <exit>
      printf("fork failed\n");
     5d2:	00005517          	auipc	a0,0x5
     5d6:	14650513          	addi	a0,a0,326 # 5718 <malloc+0xe02>
     5da:	00004097          	auipc	ra,0x4
     5de:	226080e7          	jalr	550(ra) # 4800 <printf>
      exit(1);
     5e2:	4505                	li	a0,1
     5e4:	00004097          	auipc	ra,0x4
     5e8:	e94080e7          	jalr	-364(ra) # 4478 <exit>
      fork();
     5ec:	00004097          	auipc	ra,0x4
     5f0:	e84080e7          	jalr	-380(ra) # 4470 <fork>
      fork();
     5f4:	00004097          	auipc	ra,0x4
     5f8:	e7c080e7          	jalr	-388(ra) # 4470 <fork>
      exit(0);
     5fc:	4501                	li	a0,0
     5fe:	00004097          	auipc	ra,0x4
     602:	e7a080e7          	jalr	-390(ra) # 4478 <exit>

0000000000000606 <forktest>:
{
     606:	7179                	addi	sp,sp,-48
     608:	f406                	sd	ra,40(sp)
     60a:	f022                	sd	s0,32(sp)
     60c:	ec26                	sd	s1,24(sp)
     60e:	e84a                	sd	s2,16(sp)
     610:	e44e                	sd	s3,8(sp)
     612:	1800                	addi	s0,sp,48
     614:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
     616:	4481                	li	s1,0
     618:	3e800913          	li	s2,1000
    pid = fork();
     61c:	00004097          	auipc	ra,0x4
     620:	e54080e7          	jalr	-428(ra) # 4470 <fork>
    if(pid < 0)
     624:	02054863          	bltz	a0,654 <forktest+0x4e>
    if(pid == 0)
     628:	c115                	beqz	a0,64c <forktest+0x46>
  for(n=0; n<N; n++){
     62a:	2485                	addiw	s1,s1,1
     62c:	ff2498e3          	bne	s1,s2,61c <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
     630:	85ce                	mv	a1,s3
     632:	00005517          	auipc	a0,0x5
     636:	89650513          	addi	a0,a0,-1898 # 4ec8 <malloc+0x5b2>
     63a:	00004097          	auipc	ra,0x4
     63e:	1c6080e7          	jalr	454(ra) # 4800 <printf>
    exit(1);
     642:	4505                	li	a0,1
     644:	00004097          	auipc	ra,0x4
     648:	e34080e7          	jalr	-460(ra) # 4478 <exit>
      exit(0);
     64c:	00004097          	auipc	ra,0x4
     650:	e2c080e7          	jalr	-468(ra) # 4478 <exit>
  if (n == 0) {
     654:	cc9d                	beqz	s1,692 <forktest+0x8c>
  if(n == N){
     656:	3e800793          	li	a5,1000
     65a:	fcf48be3          	beq	s1,a5,630 <forktest+0x2a>
  for(; n > 0; n--){
     65e:	00905b63          	blez	s1,674 <forktest+0x6e>
    if(wait(0) < 0){
     662:	4501                	li	a0,0
     664:	00004097          	auipc	ra,0x4
     668:	e1c080e7          	jalr	-484(ra) # 4480 <wait>
     66c:	04054163          	bltz	a0,6ae <forktest+0xa8>
  for(; n > 0; n--){
     670:	34fd                	addiw	s1,s1,-1
     672:	f8e5                	bnez	s1,662 <forktest+0x5c>
  if(wait(0) != -1){
     674:	4501                	li	a0,0
     676:	00004097          	auipc	ra,0x4
     67a:	e0a080e7          	jalr	-502(ra) # 4480 <wait>
     67e:	57fd                	li	a5,-1
     680:	04f51563          	bne	a0,a5,6ca <forktest+0xc4>
}
     684:	70a2                	ld	ra,40(sp)
     686:	7402                	ld	s0,32(sp)
     688:	64e2                	ld	s1,24(sp)
     68a:	6942                	ld	s2,16(sp)
     68c:	69a2                	ld	s3,8(sp)
     68e:	6145                	addi	sp,sp,48
     690:	8082                	ret
    printf("%s: no fork at all!\n", s);
     692:	85ce                	mv	a1,s3
     694:	00005517          	auipc	a0,0x5
     698:	81c50513          	addi	a0,a0,-2020 # 4eb0 <malloc+0x59a>
     69c:	00004097          	auipc	ra,0x4
     6a0:	164080e7          	jalr	356(ra) # 4800 <printf>
    exit(1);
     6a4:	4505                	li	a0,1
     6a6:	00004097          	auipc	ra,0x4
     6aa:	dd2080e7          	jalr	-558(ra) # 4478 <exit>
      printf("%s: wait stopped early\n", s);
     6ae:	85ce                	mv	a1,s3
     6b0:	00005517          	auipc	a0,0x5
     6b4:	84050513          	addi	a0,a0,-1984 # 4ef0 <malloc+0x5da>
     6b8:	00004097          	auipc	ra,0x4
     6bc:	148080e7          	jalr	328(ra) # 4800 <printf>
      exit(1);
     6c0:	4505                	li	a0,1
     6c2:	00004097          	auipc	ra,0x4
     6c6:	db6080e7          	jalr	-586(ra) # 4478 <exit>
    printf("%s: wait got too many\n", s);
     6ca:	85ce                	mv	a1,s3
     6cc:	00005517          	auipc	a0,0x5
     6d0:	83c50513          	addi	a0,a0,-1988 # 4f08 <malloc+0x5f2>
     6d4:	00004097          	auipc	ra,0x4
     6d8:	12c080e7          	jalr	300(ra) # 4800 <printf>
    exit(1);
     6dc:	4505                	li	a0,1
     6de:	00004097          	auipc	ra,0x4
     6e2:	d9a080e7          	jalr	-614(ra) # 4478 <exit>

00000000000006e6 <kernmem>:
{
     6e6:	715d                	addi	sp,sp,-80
     6e8:	e486                	sd	ra,72(sp)
     6ea:	e0a2                	sd	s0,64(sp)
     6ec:	fc26                	sd	s1,56(sp)
     6ee:	f84a                	sd	s2,48(sp)
     6f0:	f44e                	sd	s3,40(sp)
     6f2:	f052                	sd	s4,32(sp)
     6f4:	ec56                	sd	s5,24(sp)
     6f6:	0880                	addi	s0,sp,80
     6f8:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     6fa:	4485                	li	s1,1
     6fc:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
     6fe:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     700:	69b1                	lui	s3,0xc
     702:	35098993          	addi	s3,s3,848 # c350 <__BSS_END__+0x48>
     706:	1003d937          	lui	s2,0x1003d
     70a:	090e                	slli	s2,s2,0x3
     70c:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x10031178>
    pid = fork();
     710:	00004097          	auipc	ra,0x4
     714:	d60080e7          	jalr	-672(ra) # 4470 <fork>
    if(pid < 0){
     718:	02054963          	bltz	a0,74a <kernmem+0x64>
    if(pid == 0){
     71c:	c529                	beqz	a0,766 <kernmem+0x80>
    wait(&xstatus);
     71e:	fbc40513          	addi	a0,s0,-68
     722:	00004097          	auipc	ra,0x4
     726:	d5e080e7          	jalr	-674(ra) # 4480 <wait>
    if(xstatus != -1)  // did kernel kill child?
     72a:	fbc42783          	lw	a5,-68(s0)
     72e:	05579c63          	bne	a5,s5,786 <kernmem+0xa0>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     732:	94ce                	add	s1,s1,s3
     734:	fd249ee3          	bne	s1,s2,710 <kernmem+0x2a>
}
     738:	60a6                	ld	ra,72(sp)
     73a:	6406                	ld	s0,64(sp)
     73c:	74e2                	ld	s1,56(sp)
     73e:	7942                	ld	s2,48(sp)
     740:	79a2                	ld	s3,40(sp)
     742:	7a02                	ld	s4,32(sp)
     744:	6ae2                	ld	s5,24(sp)
     746:	6161                	addi	sp,sp,80
     748:	8082                	ret
      printf("%s: fork failed\n", s);
     74a:	85d2                	mv	a1,s4
     74c:	00004517          	auipc	a0,0x4
     750:	6cc50513          	addi	a0,a0,1740 # 4e18 <malloc+0x502>
     754:	00004097          	auipc	ra,0x4
     758:	0ac080e7          	jalr	172(ra) # 4800 <printf>
      exit(1);
     75c:	4505                	li	a0,1
     75e:	00004097          	auipc	ra,0x4
     762:	d1a080e7          	jalr	-742(ra) # 4478 <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
     766:	0004c603          	lbu	a2,0(s1)
     76a:	85a6                	mv	a1,s1
     76c:	00004517          	auipc	a0,0x4
     770:	7b450513          	addi	a0,a0,1972 # 4f20 <malloc+0x60a>
     774:	00004097          	auipc	ra,0x4
     778:	08c080e7          	jalr	140(ra) # 4800 <printf>
      exit(1);
     77c:	4505                	li	a0,1
     77e:	00004097          	auipc	ra,0x4
     782:	cfa080e7          	jalr	-774(ra) # 4478 <exit>
      exit(1);
     786:	4505                	li	a0,1
     788:	00004097          	auipc	ra,0x4
     78c:	cf0080e7          	jalr	-784(ra) # 4478 <exit>

0000000000000790 <stacktest>:

// check that there's an invalid page beneath
// the user stack, to catch stack overflow.
void
stacktest(char *s)
{
     790:	7179                	addi	sp,sp,-48
     792:	f406                	sd	ra,40(sp)
     794:	f022                	sd	s0,32(sp)
     796:	ec26                	sd	s1,24(sp)
     798:	1800                	addi	s0,sp,48
     79a:	84aa                	mv	s1,a0
  int pid;
  int xstatus;
  
  pid = fork();
     79c:	00004097          	auipc	ra,0x4
     7a0:	cd4080e7          	jalr	-812(ra) # 4470 <fork>
  if(pid == 0) {
     7a4:	c115                	beqz	a0,7c8 <stacktest+0x38>
    char *sp = (char *) r_sp();
    sp -= PGSIZE;
    // the *sp should cause a trap.
    printf("%s: stacktest: read below stack %p\n", *sp);
    exit(1);
  } else if(pid < 0){
     7a6:	04054363          	bltz	a0,7ec <stacktest+0x5c>
    printf("%s: fork failed\n", s);
    exit(1);
  }
  wait(&xstatus);
     7aa:	fdc40513          	addi	a0,s0,-36
     7ae:	00004097          	auipc	ra,0x4
     7b2:	cd2080e7          	jalr	-814(ra) # 4480 <wait>
  if(xstatus == -1)  // kernel killed child?
     7b6:	fdc42503          	lw	a0,-36(s0)
     7ba:	57fd                	li	a5,-1
     7bc:	04f50663          	beq	a0,a5,808 <stacktest+0x78>
    exit(0);
  else
    exit(xstatus);
     7c0:	00004097          	auipc	ra,0x4
     7c4:	cb8080e7          	jalr	-840(ra) # 4478 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
     7c8:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
     7ca:	77fd                	lui	a5,0xfffff
     7cc:	97ba                	add	a5,a5,a4
     7ce:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff2cf8>
     7d2:	00004517          	auipc	a0,0x4
     7d6:	76e50513          	addi	a0,a0,1902 # 4f40 <malloc+0x62a>
     7da:	00004097          	auipc	ra,0x4
     7de:	026080e7          	jalr	38(ra) # 4800 <printf>
    exit(1);
     7e2:	4505                	li	a0,1
     7e4:	00004097          	auipc	ra,0x4
     7e8:	c94080e7          	jalr	-876(ra) # 4478 <exit>
    printf("%s: fork failed\n", s);
     7ec:	85a6                	mv	a1,s1
     7ee:	00004517          	auipc	a0,0x4
     7f2:	62a50513          	addi	a0,a0,1578 # 4e18 <malloc+0x502>
     7f6:	00004097          	auipc	ra,0x4
     7fa:	00a080e7          	jalr	10(ra) # 4800 <printf>
    exit(1);
     7fe:	4505                	li	a0,1
     800:	00004097          	auipc	ra,0x4
     804:	c78080e7          	jalr	-904(ra) # 4478 <exit>
    exit(0);
     808:	4501                	li	a0,0
     80a:	00004097          	auipc	ra,0x4
     80e:	c6e080e7          	jalr	-914(ra) # 4478 <exit>

0000000000000812 <openiputtest>:
{
     812:	7179                	addi	sp,sp,-48
     814:	f406                	sd	ra,40(sp)
     816:	f022                	sd	s0,32(sp)
     818:	ec26                	sd	s1,24(sp)
     81a:	1800                	addi	s0,sp,48
     81c:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
     81e:	00004517          	auipc	a0,0x4
     822:	74a50513          	addi	a0,a0,1866 # 4f68 <malloc+0x652>
     826:	00004097          	auipc	ra,0x4
     82a:	cba080e7          	jalr	-838(ra) # 44e0 <mkdir>
     82e:	04054263          	bltz	a0,872 <openiputtest+0x60>
  pid = fork();
     832:	00004097          	auipc	ra,0x4
     836:	c3e080e7          	jalr	-962(ra) # 4470 <fork>
  if(pid < 0){
     83a:	04054a63          	bltz	a0,88e <openiputtest+0x7c>
  if(pid == 0){
     83e:	e93d                	bnez	a0,8b4 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
     840:	4589                	li	a1,2
     842:	00004517          	auipc	a0,0x4
     846:	72650513          	addi	a0,a0,1830 # 4f68 <malloc+0x652>
     84a:	00004097          	auipc	ra,0x4
     84e:	c6e080e7          	jalr	-914(ra) # 44b8 <open>
    if(fd >= 0){
     852:	04054c63          	bltz	a0,8aa <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
     856:	85a6                	mv	a1,s1
     858:	00004517          	auipc	a0,0x4
     85c:	73050513          	addi	a0,a0,1840 # 4f88 <malloc+0x672>
     860:	00004097          	auipc	ra,0x4
     864:	fa0080e7          	jalr	-96(ra) # 4800 <printf>
      exit(1);
     868:	4505                	li	a0,1
     86a:	00004097          	auipc	ra,0x4
     86e:	c0e080e7          	jalr	-1010(ra) # 4478 <exit>
    printf("%s: mkdir oidir failed\n", s);
     872:	85a6                	mv	a1,s1
     874:	00004517          	auipc	a0,0x4
     878:	6fc50513          	addi	a0,a0,1788 # 4f70 <malloc+0x65a>
     87c:	00004097          	auipc	ra,0x4
     880:	f84080e7          	jalr	-124(ra) # 4800 <printf>
    exit(1);
     884:	4505                	li	a0,1
     886:	00004097          	auipc	ra,0x4
     88a:	bf2080e7          	jalr	-1038(ra) # 4478 <exit>
    printf("%s: fork failed\n", s);
     88e:	85a6                	mv	a1,s1
     890:	00004517          	auipc	a0,0x4
     894:	58850513          	addi	a0,a0,1416 # 4e18 <malloc+0x502>
     898:	00004097          	auipc	ra,0x4
     89c:	f68080e7          	jalr	-152(ra) # 4800 <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	00004097          	auipc	ra,0x4
     8a6:	bd6080e7          	jalr	-1066(ra) # 4478 <exit>
    exit(0);
     8aa:	4501                	li	a0,0
     8ac:	00004097          	auipc	ra,0x4
     8b0:	bcc080e7          	jalr	-1076(ra) # 4478 <exit>
  sleep(1);
     8b4:	4505                	li	a0,1
     8b6:	00004097          	auipc	ra,0x4
     8ba:	c52080e7          	jalr	-942(ra) # 4508 <sleep>
  if(unlink("oidir") != 0){
     8be:	00004517          	auipc	a0,0x4
     8c2:	6aa50513          	addi	a0,a0,1706 # 4f68 <malloc+0x652>
     8c6:	00004097          	auipc	ra,0x4
     8ca:	c02080e7          	jalr	-1022(ra) # 44c8 <unlink>
     8ce:	cd19                	beqz	a0,8ec <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
     8d0:	85a6                	mv	a1,s1
     8d2:	00004517          	auipc	a0,0x4
     8d6:	6de50513          	addi	a0,a0,1758 # 4fb0 <malloc+0x69a>
     8da:	00004097          	auipc	ra,0x4
     8de:	f26080e7          	jalr	-218(ra) # 4800 <printf>
    exit(1);
     8e2:	4505                	li	a0,1
     8e4:	00004097          	auipc	ra,0x4
     8e8:	b94080e7          	jalr	-1132(ra) # 4478 <exit>
  wait(&xstatus);
     8ec:	fdc40513          	addi	a0,s0,-36
     8f0:	00004097          	auipc	ra,0x4
     8f4:	b90080e7          	jalr	-1136(ra) # 4480 <wait>
  exit(xstatus);
     8f8:	fdc42503          	lw	a0,-36(s0)
     8fc:	00004097          	auipc	ra,0x4
     900:	b7c080e7          	jalr	-1156(ra) # 4478 <exit>

0000000000000904 <opentest>:
{
     904:	1101                	addi	sp,sp,-32
     906:	ec06                	sd	ra,24(sp)
     908:	e822                	sd	s0,16(sp)
     90a:	e426                	sd	s1,8(sp)
     90c:	1000                	addi	s0,sp,32
     90e:	84aa                	mv	s1,a0
  fd = open("echo", 0);
     910:	4581                	li	a1,0
     912:	00004517          	auipc	a0,0x4
     916:	6b650513          	addi	a0,a0,1718 # 4fc8 <malloc+0x6b2>
     91a:	00004097          	auipc	ra,0x4
     91e:	b9e080e7          	jalr	-1122(ra) # 44b8 <open>
  if(fd < 0){
     922:	02054663          	bltz	a0,94e <opentest+0x4a>
  close(fd);
     926:	00004097          	auipc	ra,0x4
     92a:	b7a080e7          	jalr	-1158(ra) # 44a0 <close>
  fd = open("doesnotexist", 0);
     92e:	4581                	li	a1,0
     930:	00004517          	auipc	a0,0x4
     934:	6b850513          	addi	a0,a0,1720 # 4fe8 <malloc+0x6d2>
     938:	00004097          	auipc	ra,0x4
     93c:	b80080e7          	jalr	-1152(ra) # 44b8 <open>
  if(fd >= 0){
     940:	02055563          	bgez	a0,96a <opentest+0x66>
}
     944:	60e2                	ld	ra,24(sp)
     946:	6442                	ld	s0,16(sp)
     948:	64a2                	ld	s1,8(sp)
     94a:	6105                	addi	sp,sp,32
     94c:	8082                	ret
    printf("%s: open echo failed!\n", s);
     94e:	85a6                	mv	a1,s1
     950:	00004517          	auipc	a0,0x4
     954:	68050513          	addi	a0,a0,1664 # 4fd0 <malloc+0x6ba>
     958:	00004097          	auipc	ra,0x4
     95c:	ea8080e7          	jalr	-344(ra) # 4800 <printf>
    exit(1);
     960:	4505                	li	a0,1
     962:	00004097          	auipc	ra,0x4
     966:	b16080e7          	jalr	-1258(ra) # 4478 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     96a:	85a6                	mv	a1,s1
     96c:	00004517          	auipc	a0,0x4
     970:	68c50513          	addi	a0,a0,1676 # 4ff8 <malloc+0x6e2>
     974:	00004097          	auipc	ra,0x4
     978:	e8c080e7          	jalr	-372(ra) # 4800 <printf>
    exit(1);
     97c:	4505                	li	a0,1
     97e:	00004097          	auipc	ra,0x4
     982:	afa080e7          	jalr	-1286(ra) # 4478 <exit>

0000000000000986 <createtest>:
{
     986:	7179                	addi	sp,sp,-48
     988:	f406                	sd	ra,40(sp)
     98a:	f022                	sd	s0,32(sp)
     98c:	ec26                	sd	s1,24(sp)
     98e:	e84a                	sd	s2,16(sp)
     990:	e44e                	sd	s3,8(sp)
     992:	1800                	addi	s0,sp,48
  name[0] = 'a';
     994:	00006797          	auipc	a5,0x6
     998:	12c78793          	addi	a5,a5,300 # 6ac0 <name>
     99c:	06100713          	li	a4,97
     9a0:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     9a4:	00078123          	sb	zero,2(a5)
     9a8:	03000493          	li	s1,48
    name[1] = '0' + i;
     9ac:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     9ae:	06400993          	li	s3,100
    name[1] = '0' + i;
     9b2:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
     9b6:	20200593          	li	a1,514
     9ba:	854a                	mv	a0,s2
     9bc:	00004097          	auipc	ra,0x4
     9c0:	afc080e7          	jalr	-1284(ra) # 44b8 <open>
    close(fd);
     9c4:	00004097          	auipc	ra,0x4
     9c8:	adc080e7          	jalr	-1316(ra) # 44a0 <close>
  for(i = 0; i < N; i++){
     9cc:	2485                	addiw	s1,s1,1
     9ce:	0ff4f493          	andi	s1,s1,255
     9d2:	ff3490e3          	bne	s1,s3,9b2 <createtest+0x2c>
  name[0] = 'a';
     9d6:	00006797          	auipc	a5,0x6
     9da:	0ea78793          	addi	a5,a5,234 # 6ac0 <name>
     9de:	06100713          	li	a4,97
     9e2:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     9e6:	00078123          	sb	zero,2(a5)
     9ea:	03000493          	li	s1,48
    name[1] = '0' + i;
     9ee:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     9f0:	06400993          	li	s3,100
    name[1] = '0' + i;
     9f4:	009900a3          	sb	s1,1(s2)
    unlink(name);
     9f8:	854a                	mv	a0,s2
     9fa:	00004097          	auipc	ra,0x4
     9fe:	ace080e7          	jalr	-1330(ra) # 44c8 <unlink>
  for(i = 0; i < N; i++){
     a02:	2485                	addiw	s1,s1,1
     a04:	0ff4f493          	andi	s1,s1,255
     a08:	ff3496e3          	bne	s1,s3,9f4 <createtest+0x6e>
}
     a0c:	70a2                	ld	ra,40(sp)
     a0e:	7402                	ld	s0,32(sp)
     a10:	64e2                	ld	s1,24(sp)
     a12:	6942                	ld	s2,16(sp)
     a14:	69a2                	ld	s3,8(sp)
     a16:	6145                	addi	sp,sp,48
     a18:	8082                	ret

0000000000000a1a <forkforkfork>:
{
     a1a:	1101                	addi	sp,sp,-32
     a1c:	ec06                	sd	ra,24(sp)
     a1e:	e822                	sd	s0,16(sp)
     a20:	e426                	sd	s1,8(sp)
     a22:	1000                	addi	s0,sp,32
     a24:	84aa                	mv	s1,a0
  unlink("stopforking");
     a26:	00004517          	auipc	a0,0x4
     a2a:	5fa50513          	addi	a0,a0,1530 # 5020 <malloc+0x70a>
     a2e:	00004097          	auipc	ra,0x4
     a32:	a9a080e7          	jalr	-1382(ra) # 44c8 <unlink>
  int pid = fork();
     a36:	00004097          	auipc	ra,0x4
     a3a:	a3a080e7          	jalr	-1478(ra) # 4470 <fork>
  if(pid < 0){
     a3e:	04054563          	bltz	a0,a88 <forkforkfork+0x6e>
  if(pid == 0){
     a42:	c12d                	beqz	a0,aa4 <forkforkfork+0x8a>
  sleep(20); // two seconds
     a44:	4551                	li	a0,20
     a46:	00004097          	auipc	ra,0x4
     a4a:	ac2080e7          	jalr	-1342(ra) # 4508 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
     a4e:	20200593          	li	a1,514
     a52:	00004517          	auipc	a0,0x4
     a56:	5ce50513          	addi	a0,a0,1486 # 5020 <malloc+0x70a>
     a5a:	00004097          	auipc	ra,0x4
     a5e:	a5e080e7          	jalr	-1442(ra) # 44b8 <open>
     a62:	00004097          	auipc	ra,0x4
     a66:	a3e080e7          	jalr	-1474(ra) # 44a0 <close>
  wait(0);
     a6a:	4501                	li	a0,0
     a6c:	00004097          	auipc	ra,0x4
     a70:	a14080e7          	jalr	-1516(ra) # 4480 <wait>
  sleep(10); // one second
     a74:	4529                	li	a0,10
     a76:	00004097          	auipc	ra,0x4
     a7a:	a92080e7          	jalr	-1390(ra) # 4508 <sleep>
}
     a7e:	60e2                	ld	ra,24(sp)
     a80:	6442                	ld	s0,16(sp)
     a82:	64a2                	ld	s1,8(sp)
     a84:	6105                	addi	sp,sp,32
     a86:	8082                	ret
    printf("%s: fork failed", s);
     a88:	85a6                	mv	a1,s1
     a8a:	00004517          	auipc	a0,0x4
     a8e:	3f650513          	addi	a0,a0,1014 # 4e80 <malloc+0x56a>
     a92:	00004097          	auipc	ra,0x4
     a96:	d6e080e7          	jalr	-658(ra) # 4800 <printf>
    exit(1);
     a9a:	4505                	li	a0,1
     a9c:	00004097          	auipc	ra,0x4
     aa0:	9dc080e7          	jalr	-1572(ra) # 4478 <exit>
      int fd = open("stopforking", 0);
     aa4:	00004497          	auipc	s1,0x4
     aa8:	57c48493          	addi	s1,s1,1404 # 5020 <malloc+0x70a>
     aac:	4581                	li	a1,0
     aae:	8526                	mv	a0,s1
     ab0:	00004097          	auipc	ra,0x4
     ab4:	a08080e7          	jalr	-1528(ra) # 44b8 <open>
      if(fd >= 0){
     ab8:	02055463          	bgez	a0,ae0 <forkforkfork+0xc6>
      if(fork() < 0){
     abc:	00004097          	auipc	ra,0x4
     ac0:	9b4080e7          	jalr	-1612(ra) # 4470 <fork>
     ac4:	fe0554e3          	bgez	a0,aac <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
     ac8:	20200593          	li	a1,514
     acc:	8526                	mv	a0,s1
     ace:	00004097          	auipc	ra,0x4
     ad2:	9ea080e7          	jalr	-1558(ra) # 44b8 <open>
     ad6:	00004097          	auipc	ra,0x4
     ada:	9ca080e7          	jalr	-1590(ra) # 44a0 <close>
     ade:	b7f9                	j	aac <forkforkfork+0x92>
        exit(0);
     ae0:	4501                	li	a0,0
     ae2:	00004097          	auipc	ra,0x4
     ae6:	996080e7          	jalr	-1642(ra) # 4478 <exit>

0000000000000aea <createdelete>:
{
     aea:	7175                	addi	sp,sp,-144
     aec:	e506                	sd	ra,136(sp)
     aee:	e122                	sd	s0,128(sp)
     af0:	fca6                	sd	s1,120(sp)
     af2:	f8ca                	sd	s2,112(sp)
     af4:	f4ce                	sd	s3,104(sp)
     af6:	f0d2                	sd	s4,96(sp)
     af8:	ecd6                	sd	s5,88(sp)
     afa:	e8da                	sd	s6,80(sp)
     afc:	e4de                	sd	s7,72(sp)
     afe:	e0e2                	sd	s8,64(sp)
     b00:	fc66                	sd	s9,56(sp)
     b02:	0900                	addi	s0,sp,144
     b04:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
     b06:	4901                	li	s2,0
     b08:	4991                	li	s3,4
    pid = fork();
     b0a:	00004097          	auipc	ra,0x4
     b0e:	966080e7          	jalr	-1690(ra) # 4470 <fork>
     b12:	84aa                	mv	s1,a0
    if(pid < 0){
     b14:	02054f63          	bltz	a0,b52 <createdelete+0x68>
    if(pid == 0){
     b18:	c939                	beqz	a0,b6e <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
     b1a:	2905                	addiw	s2,s2,1
     b1c:	ff3917e3          	bne	s2,s3,b0a <createdelete+0x20>
     b20:	4491                	li	s1,4
    wait(&xstatus);
     b22:	f7c40513          	addi	a0,s0,-132
     b26:	00004097          	auipc	ra,0x4
     b2a:	95a080e7          	jalr	-1702(ra) # 4480 <wait>
    if(xstatus != 0)
     b2e:	f7c42903          	lw	s2,-132(s0)
     b32:	0e091263          	bnez	s2,c16 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
     b36:	34fd                	addiw	s1,s1,-1
     b38:	f4ed                	bnez	s1,b22 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
     b3a:	f8040123          	sb	zero,-126(s0)
     b3e:	03000993          	li	s3,48
     b42:	5a7d                	li	s4,-1
     b44:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
     b48:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
     b4a:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
     b4c:	07400a93          	li	s5,116
     b50:	a29d                	j	cb6 <createdelete+0x1cc>
      printf("fork failed\n", s);
     b52:	85e6                	mv	a1,s9
     b54:	00005517          	auipc	a0,0x5
     b58:	bc450513          	addi	a0,a0,-1084 # 5718 <malloc+0xe02>
     b5c:	00004097          	auipc	ra,0x4
     b60:	ca4080e7          	jalr	-860(ra) # 4800 <printf>
      exit(1);
     b64:	4505                	li	a0,1
     b66:	00004097          	auipc	ra,0x4
     b6a:	912080e7          	jalr	-1774(ra) # 4478 <exit>
      name[0] = 'p' + pi;
     b6e:	0709091b          	addiw	s2,s2,112
     b72:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
     b76:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
     b7a:	4951                	li	s2,20
     b7c:	a015                	j	ba0 <createdelete+0xb6>
          printf("%s: create failed\n", s);
     b7e:	85e6                	mv	a1,s9
     b80:	00004517          	auipc	a0,0x4
     b84:	4b050513          	addi	a0,a0,1200 # 5030 <malloc+0x71a>
     b88:	00004097          	auipc	ra,0x4
     b8c:	c78080e7          	jalr	-904(ra) # 4800 <printf>
          exit(1);
     b90:	4505                	li	a0,1
     b92:	00004097          	auipc	ra,0x4
     b96:	8e6080e7          	jalr	-1818(ra) # 4478 <exit>
      for(i = 0; i < N; i++){
     b9a:	2485                	addiw	s1,s1,1
     b9c:	07248863          	beq	s1,s2,c0c <createdelete+0x122>
        name[1] = '0' + i;
     ba0:	0304879b          	addiw	a5,s1,48
     ba4:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
     ba8:	20200593          	li	a1,514
     bac:	f8040513          	addi	a0,s0,-128
     bb0:	00004097          	auipc	ra,0x4
     bb4:	908080e7          	jalr	-1784(ra) # 44b8 <open>
        if(fd < 0){
     bb8:	fc0543e3          	bltz	a0,b7e <createdelete+0x94>
        close(fd);
     bbc:	00004097          	auipc	ra,0x4
     bc0:	8e4080e7          	jalr	-1820(ra) # 44a0 <close>
        if(i > 0 && (i % 2 ) == 0){
     bc4:	fc905be3          	blez	s1,b9a <createdelete+0xb0>
     bc8:	0014f793          	andi	a5,s1,1
     bcc:	f7f9                	bnez	a5,b9a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
     bce:	01f4d79b          	srliw	a5,s1,0x1f
     bd2:	9fa5                	addw	a5,a5,s1
     bd4:	4017d79b          	sraiw	a5,a5,0x1
     bd8:	0307879b          	addiw	a5,a5,48
     bdc:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
     be0:	f8040513          	addi	a0,s0,-128
     be4:	00004097          	auipc	ra,0x4
     be8:	8e4080e7          	jalr	-1820(ra) # 44c8 <unlink>
     bec:	fa0557e3          	bgez	a0,b9a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
     bf0:	85e6                	mv	a1,s9
     bf2:	00004517          	auipc	a0,0x4
     bf6:	3be50513          	addi	a0,a0,958 # 4fb0 <malloc+0x69a>
     bfa:	00004097          	auipc	ra,0x4
     bfe:	c06080e7          	jalr	-1018(ra) # 4800 <printf>
            exit(1);
     c02:	4505                	li	a0,1
     c04:	00004097          	auipc	ra,0x4
     c08:	874080e7          	jalr	-1932(ra) # 4478 <exit>
      exit(0);
     c0c:	4501                	li	a0,0
     c0e:	00004097          	auipc	ra,0x4
     c12:	86a080e7          	jalr	-1942(ra) # 4478 <exit>
      exit(1);
     c16:	4505                	li	a0,1
     c18:	00004097          	auipc	ra,0x4
     c1c:	860080e7          	jalr	-1952(ra) # 4478 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
     c20:	f8040613          	addi	a2,s0,-128
     c24:	85e6                	mv	a1,s9
     c26:	00004517          	auipc	a0,0x4
     c2a:	42250513          	addi	a0,a0,1058 # 5048 <malloc+0x732>
     c2e:	00004097          	auipc	ra,0x4
     c32:	bd2080e7          	jalr	-1070(ra) # 4800 <printf>
        exit(1);
     c36:	4505                	li	a0,1
     c38:	00004097          	auipc	ra,0x4
     c3c:	840080e7          	jalr	-1984(ra) # 4478 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
     c40:	054b7163          	bgeu	s6,s4,c82 <createdelete+0x198>
      if(fd >= 0)
     c44:	02055a63          	bgez	a0,c78 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
     c48:	2485                	addiw	s1,s1,1
     c4a:	0ff4f493          	andi	s1,s1,255
     c4e:	05548c63          	beq	s1,s5,ca6 <createdelete+0x1bc>
      name[0] = 'p' + pi;
     c52:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
     c56:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
     c5a:	4581                	li	a1,0
     c5c:	f8040513          	addi	a0,s0,-128
     c60:	00004097          	auipc	ra,0x4
     c64:	858080e7          	jalr	-1960(ra) # 44b8 <open>
      if((i == 0 || i >= N/2) && fd < 0){
     c68:	00090463          	beqz	s2,c70 <createdelete+0x186>
     c6c:	fd2bdae3          	bge	s7,s2,c40 <createdelete+0x156>
     c70:	fa0548e3          	bltz	a0,c20 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
     c74:	014b7963          	bgeu	s6,s4,c86 <createdelete+0x19c>
        close(fd);
     c78:	00004097          	auipc	ra,0x4
     c7c:	828080e7          	jalr	-2008(ra) # 44a0 <close>
     c80:	b7e1                	j	c48 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
     c82:	fc0543e3          	bltz	a0,c48 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
     c86:	f8040613          	addi	a2,s0,-128
     c8a:	85e6                	mv	a1,s9
     c8c:	00004517          	auipc	a0,0x4
     c90:	3e450513          	addi	a0,a0,996 # 5070 <malloc+0x75a>
     c94:	00004097          	auipc	ra,0x4
     c98:	b6c080e7          	jalr	-1172(ra) # 4800 <printf>
        exit(1);
     c9c:	4505                	li	a0,1
     c9e:	00003097          	auipc	ra,0x3
     ca2:	7da080e7          	jalr	2010(ra) # 4478 <exit>
  for(i = 0; i < N; i++){
     ca6:	2905                	addiw	s2,s2,1
     ca8:	2a05                	addiw	s4,s4,1
     caa:	2985                	addiw	s3,s3,1
     cac:	0ff9f993          	andi	s3,s3,255
     cb0:	47d1                	li	a5,20
     cb2:	02f90a63          	beq	s2,a5,ce6 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
     cb6:	84e2                	mv	s1,s8
     cb8:	bf69                	j	c52 <createdelete+0x168>
  for(i = 0; i < N; i++){
     cba:	2905                	addiw	s2,s2,1
     cbc:	0ff97913          	andi	s2,s2,255
     cc0:	2985                	addiw	s3,s3,1
     cc2:	0ff9f993          	andi	s3,s3,255
     cc6:	03490863          	beq	s2,s4,cf6 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
     cca:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
     ccc:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
     cd0:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
     cd4:	f8040513          	addi	a0,s0,-128
     cd8:	00003097          	auipc	ra,0x3
     cdc:	7f0080e7          	jalr	2032(ra) # 44c8 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
     ce0:	34fd                	addiw	s1,s1,-1
     ce2:	f4ed                	bnez	s1,ccc <createdelete+0x1e2>
     ce4:	bfd9                	j	cba <createdelete+0x1d0>
     ce6:	03000993          	li	s3,48
     cea:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
     cee:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
     cf0:	08400a13          	li	s4,132
     cf4:	bfd9                	j	cca <createdelete+0x1e0>
}
     cf6:	60aa                	ld	ra,136(sp)
     cf8:	640a                	ld	s0,128(sp)
     cfa:	74e6                	ld	s1,120(sp)
     cfc:	7946                	ld	s2,112(sp)
     cfe:	79a6                	ld	s3,104(sp)
     d00:	7a06                	ld	s4,96(sp)
     d02:	6ae6                	ld	s5,88(sp)
     d04:	6b46                	ld	s6,80(sp)
     d06:	6ba6                	ld	s7,72(sp)
     d08:	6c06                	ld	s8,64(sp)
     d0a:	7ce2                	ld	s9,56(sp)
     d0c:	6149                	addi	sp,sp,144
     d0e:	8082                	ret

0000000000000d10 <fourteen>:
{
     d10:	1101                	addi	sp,sp,-32
     d12:	ec06                	sd	ra,24(sp)
     d14:	e822                	sd	s0,16(sp)
     d16:	e426                	sd	s1,8(sp)
     d18:	1000                	addi	s0,sp,32
     d1a:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
     d1c:	00004517          	auipc	a0,0x4
     d20:	54c50513          	addi	a0,a0,1356 # 5268 <malloc+0x952>
     d24:	00003097          	auipc	ra,0x3
     d28:	7bc080e7          	jalr	1980(ra) # 44e0 <mkdir>
     d2c:	e141                	bnez	a0,dac <fourteen+0x9c>
  if(mkdir("12345678901234/123456789012345") != 0){
     d2e:	00004517          	auipc	a0,0x4
     d32:	39250513          	addi	a0,a0,914 # 50c0 <malloc+0x7aa>
     d36:	00003097          	auipc	ra,0x3
     d3a:	7aa080e7          	jalr	1962(ra) # 44e0 <mkdir>
     d3e:	e549                	bnez	a0,dc8 <fourteen+0xb8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
     d40:	20000593          	li	a1,512
     d44:	00004517          	auipc	a0,0x4
     d48:	3d450513          	addi	a0,a0,980 # 5118 <malloc+0x802>
     d4c:	00003097          	auipc	ra,0x3
     d50:	76c080e7          	jalr	1900(ra) # 44b8 <open>
  if(fd < 0){
     d54:	08054863          	bltz	a0,de4 <fourteen+0xd4>
  close(fd);
     d58:	00003097          	auipc	ra,0x3
     d5c:	748080e7          	jalr	1864(ra) # 44a0 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
     d60:	4581                	li	a1,0
     d62:	00004517          	auipc	a0,0x4
     d66:	42e50513          	addi	a0,a0,1070 # 5190 <malloc+0x87a>
     d6a:	00003097          	auipc	ra,0x3
     d6e:	74e080e7          	jalr	1870(ra) # 44b8 <open>
  if(fd < 0){
     d72:	08054763          	bltz	a0,e00 <fourteen+0xf0>
  close(fd);
     d76:	00003097          	auipc	ra,0x3
     d7a:	72a080e7          	jalr	1834(ra) # 44a0 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
     d7e:	00004517          	auipc	a0,0x4
     d82:	48250513          	addi	a0,a0,1154 # 5200 <malloc+0x8ea>
     d86:	00003097          	auipc	ra,0x3
     d8a:	75a080e7          	jalr	1882(ra) # 44e0 <mkdir>
     d8e:	c559                	beqz	a0,e1c <fourteen+0x10c>
  if(mkdir("123456789012345/12345678901234") == 0){
     d90:	00004517          	auipc	a0,0x4
     d94:	4c850513          	addi	a0,a0,1224 # 5258 <malloc+0x942>
     d98:	00003097          	auipc	ra,0x3
     d9c:	748080e7          	jalr	1864(ra) # 44e0 <mkdir>
     da0:	cd41                	beqz	a0,e38 <fourteen+0x128>
}
     da2:	60e2                	ld	ra,24(sp)
     da4:	6442                	ld	s0,16(sp)
     da6:	64a2                	ld	s1,8(sp)
     da8:	6105                	addi	sp,sp,32
     daa:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
     dac:	85a6                	mv	a1,s1
     dae:	00004517          	auipc	a0,0x4
     db2:	2ea50513          	addi	a0,a0,746 # 5098 <malloc+0x782>
     db6:	00004097          	auipc	ra,0x4
     dba:	a4a080e7          	jalr	-1462(ra) # 4800 <printf>
    exit(1);
     dbe:	4505                	li	a0,1
     dc0:	00003097          	auipc	ra,0x3
     dc4:	6b8080e7          	jalr	1720(ra) # 4478 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
     dc8:	85a6                	mv	a1,s1
     dca:	00004517          	auipc	a0,0x4
     dce:	31650513          	addi	a0,a0,790 # 50e0 <malloc+0x7ca>
     dd2:	00004097          	auipc	ra,0x4
     dd6:	a2e080e7          	jalr	-1490(ra) # 4800 <printf>
    exit(1);
     dda:	4505                	li	a0,1
     ddc:	00003097          	auipc	ra,0x3
     de0:	69c080e7          	jalr	1692(ra) # 4478 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
     de4:	85a6                	mv	a1,s1
     de6:	00004517          	auipc	a0,0x4
     dea:	36250513          	addi	a0,a0,866 # 5148 <malloc+0x832>
     dee:	00004097          	auipc	ra,0x4
     df2:	a12080e7          	jalr	-1518(ra) # 4800 <printf>
    exit(1);
     df6:	4505                	li	a0,1
     df8:	00003097          	auipc	ra,0x3
     dfc:	680080e7          	jalr	1664(ra) # 4478 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
     e00:	85a6                	mv	a1,s1
     e02:	00004517          	auipc	a0,0x4
     e06:	3be50513          	addi	a0,a0,958 # 51c0 <malloc+0x8aa>
     e0a:	00004097          	auipc	ra,0x4
     e0e:	9f6080e7          	jalr	-1546(ra) # 4800 <printf>
    exit(1);
     e12:	4505                	li	a0,1
     e14:	00003097          	auipc	ra,0x3
     e18:	664080e7          	jalr	1636(ra) # 4478 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
     e1c:	85a6                	mv	a1,s1
     e1e:	00004517          	auipc	a0,0x4
     e22:	40250513          	addi	a0,a0,1026 # 5220 <malloc+0x90a>
     e26:	00004097          	auipc	ra,0x4
     e2a:	9da080e7          	jalr	-1574(ra) # 4800 <printf>
    exit(1);
     e2e:	4505                	li	a0,1
     e30:	00003097          	auipc	ra,0x3
     e34:	648080e7          	jalr	1608(ra) # 4478 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
     e38:	85a6                	mv	a1,s1
     e3a:	00004517          	auipc	a0,0x4
     e3e:	43e50513          	addi	a0,a0,1086 # 5278 <malloc+0x962>
     e42:	00004097          	auipc	ra,0x4
     e46:	9be080e7          	jalr	-1602(ra) # 4800 <printf>
    exit(1);
     e4a:	4505                	li	a0,1
     e4c:	00003097          	auipc	ra,0x3
     e50:	62c080e7          	jalr	1580(ra) # 4478 <exit>

0000000000000e54 <bigwrite>:
{
     e54:	715d                	addi	sp,sp,-80
     e56:	e486                	sd	ra,72(sp)
     e58:	e0a2                	sd	s0,64(sp)
     e5a:	fc26                	sd	s1,56(sp)
     e5c:	f84a                	sd	s2,48(sp)
     e5e:	f44e                	sd	s3,40(sp)
     e60:	f052                	sd	s4,32(sp)
     e62:	ec56                	sd	s5,24(sp)
     e64:	e85a                	sd	s6,16(sp)
     e66:	e45e                	sd	s7,8(sp)
     e68:	0880                	addi	s0,sp,80
     e6a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     e6c:	00004517          	auipc	a0,0x4
     e70:	ccc50513          	addi	a0,a0,-820 # 4b38 <malloc+0x222>
     e74:	00003097          	auipc	ra,0x3
     e78:	654080e7          	jalr	1620(ra) # 44c8 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     e7c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     e80:	00004a97          	auipc	s5,0x4
     e84:	cb8a8a93          	addi	s5,s5,-840 # 4b38 <malloc+0x222>
      int cc = write(fd, buf, sz);
     e88:	00008a17          	auipc	s4,0x8
     e8c:	458a0a13          	addi	s4,s4,1112 # 92e0 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     e90:	6b0d                	lui	s6,0x3
     e92:	1c9b0b13          	addi	s6,s6,457 # 31c9 <dirfile+0x2b>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     e96:	20200593          	li	a1,514
     e9a:	8556                	mv	a0,s5
     e9c:	00003097          	auipc	ra,0x3
     ea0:	61c080e7          	jalr	1564(ra) # 44b8 <open>
     ea4:	892a                	mv	s2,a0
    if(fd < 0){
     ea6:	04054d63          	bltz	a0,f00 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     eaa:	8626                	mv	a2,s1
     eac:	85d2                	mv	a1,s4
     eae:	00003097          	auipc	ra,0x3
     eb2:	5ea080e7          	jalr	1514(ra) # 4498 <write>
     eb6:	89aa                	mv	s3,a0
      if(cc != sz){
     eb8:	06a49463          	bne	s1,a0,f20 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     ebc:	8626                	mv	a2,s1
     ebe:	85d2                	mv	a1,s4
     ec0:	854a                	mv	a0,s2
     ec2:	00003097          	auipc	ra,0x3
     ec6:	5d6080e7          	jalr	1494(ra) # 4498 <write>
      if(cc != sz){
     eca:	04951963          	bne	a0,s1,f1c <bigwrite+0xc8>
    close(fd);
     ece:	854a                	mv	a0,s2
     ed0:	00003097          	auipc	ra,0x3
     ed4:	5d0080e7          	jalr	1488(ra) # 44a0 <close>
    unlink("bigwrite");
     ed8:	8556                	mv	a0,s5
     eda:	00003097          	auipc	ra,0x3
     ede:	5ee080e7          	jalr	1518(ra) # 44c8 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     ee2:	1d74849b          	addiw	s1,s1,471
     ee6:	fb6498e3          	bne	s1,s6,e96 <bigwrite+0x42>
}
     eea:	60a6                	ld	ra,72(sp)
     eec:	6406                	ld	s0,64(sp)
     eee:	74e2                	ld	s1,56(sp)
     ef0:	7942                	ld	s2,48(sp)
     ef2:	79a2                	ld	s3,40(sp)
     ef4:	7a02                	ld	s4,32(sp)
     ef6:	6ae2                	ld	s5,24(sp)
     ef8:	6b42                	ld	s6,16(sp)
     efa:	6ba2                	ld	s7,8(sp)
     efc:	6161                	addi	sp,sp,80
     efe:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     f00:	85de                	mv	a1,s7
     f02:	00004517          	auipc	a0,0x4
     f06:	3ae50513          	addi	a0,a0,942 # 52b0 <malloc+0x99a>
     f0a:	00004097          	auipc	ra,0x4
     f0e:	8f6080e7          	jalr	-1802(ra) # 4800 <printf>
      exit(1);
     f12:	4505                	li	a0,1
     f14:	00003097          	auipc	ra,0x3
     f18:	564080e7          	jalr	1380(ra) # 4478 <exit>
     f1c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     f1e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     f20:	86ce                	mv	a3,s3
     f22:	8626                	mv	a2,s1
     f24:	85de                	mv	a1,s7
     f26:	00004517          	auipc	a0,0x4
     f2a:	3aa50513          	addi	a0,a0,938 # 52d0 <malloc+0x9ba>
     f2e:	00004097          	auipc	ra,0x4
     f32:	8d2080e7          	jalr	-1838(ra) # 4800 <printf>
        exit(1);
     f36:	4505                	li	a0,1
     f38:	00003097          	auipc	ra,0x3
     f3c:	540080e7          	jalr	1344(ra) # 4478 <exit>

0000000000000f40 <writetest>:
{
     f40:	7139                	addi	sp,sp,-64
     f42:	fc06                	sd	ra,56(sp)
     f44:	f822                	sd	s0,48(sp)
     f46:	f426                	sd	s1,40(sp)
     f48:	f04a                	sd	s2,32(sp)
     f4a:	ec4e                	sd	s3,24(sp)
     f4c:	e852                	sd	s4,16(sp)
     f4e:	e456                	sd	s5,8(sp)
     f50:	e05a                	sd	s6,0(sp)
     f52:	0080                	addi	s0,sp,64
     f54:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     f56:	20200593          	li	a1,514
     f5a:	00004517          	auipc	a0,0x4
     f5e:	38e50513          	addi	a0,a0,910 # 52e8 <malloc+0x9d2>
     f62:	00003097          	auipc	ra,0x3
     f66:	556080e7          	jalr	1366(ra) # 44b8 <open>
  if(fd < 0){
     f6a:	0a054d63          	bltz	a0,1024 <writetest+0xe4>
     f6e:	892a                	mv	s2,a0
     f70:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     f72:	00004997          	auipc	s3,0x4
     f76:	39e98993          	addi	s3,s3,926 # 5310 <malloc+0x9fa>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     f7a:	00004a97          	auipc	s5,0x4
     f7e:	3cea8a93          	addi	s5,s5,974 # 5348 <malloc+0xa32>
  for(i = 0; i < N; i++){
     f82:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     f86:	4629                	li	a2,10
     f88:	85ce                	mv	a1,s3
     f8a:	854a                	mv	a0,s2
     f8c:	00003097          	auipc	ra,0x3
     f90:	50c080e7          	jalr	1292(ra) # 4498 <write>
     f94:	47a9                	li	a5,10
     f96:	0af51563          	bne	a0,a5,1040 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     f9a:	4629                	li	a2,10
     f9c:	85d6                	mv	a1,s5
     f9e:	854a                	mv	a0,s2
     fa0:	00003097          	auipc	ra,0x3
     fa4:	4f8080e7          	jalr	1272(ra) # 4498 <write>
     fa8:	47a9                	li	a5,10
     faa:	0af51963          	bne	a0,a5,105c <writetest+0x11c>
  for(i = 0; i < N; i++){
     fae:	2485                	addiw	s1,s1,1
     fb0:	fd449be3          	bne	s1,s4,f86 <writetest+0x46>
  close(fd);
     fb4:	854a                	mv	a0,s2
     fb6:	00003097          	auipc	ra,0x3
     fba:	4ea080e7          	jalr	1258(ra) # 44a0 <close>
  fd = open("small", O_RDONLY);
     fbe:	4581                	li	a1,0
     fc0:	00004517          	auipc	a0,0x4
     fc4:	32850513          	addi	a0,a0,808 # 52e8 <malloc+0x9d2>
     fc8:	00003097          	auipc	ra,0x3
     fcc:	4f0080e7          	jalr	1264(ra) # 44b8 <open>
     fd0:	84aa                	mv	s1,a0
  if(fd < 0){
     fd2:	0a054363          	bltz	a0,1078 <writetest+0x138>
  i = read(fd, buf, N*SZ*2);
     fd6:	7d000613          	li	a2,2000
     fda:	00008597          	auipc	a1,0x8
     fde:	30658593          	addi	a1,a1,774 # 92e0 <buf>
     fe2:	00003097          	auipc	ra,0x3
     fe6:	4ae080e7          	jalr	1198(ra) # 4490 <read>
  if(i != N*SZ*2){
     fea:	7d000793          	li	a5,2000
     fee:	0af51363          	bne	a0,a5,1094 <writetest+0x154>
  close(fd);
     ff2:	8526                	mv	a0,s1
     ff4:	00003097          	auipc	ra,0x3
     ff8:	4ac080e7          	jalr	1196(ra) # 44a0 <close>
  if(unlink("small") < 0){
     ffc:	00004517          	auipc	a0,0x4
    1000:	2ec50513          	addi	a0,a0,748 # 52e8 <malloc+0x9d2>
    1004:	00003097          	auipc	ra,0x3
    1008:	4c4080e7          	jalr	1220(ra) # 44c8 <unlink>
    100c:	0a054263          	bltz	a0,10b0 <writetest+0x170>
}
    1010:	70e2                	ld	ra,56(sp)
    1012:	7442                	ld	s0,48(sp)
    1014:	74a2                	ld	s1,40(sp)
    1016:	7902                	ld	s2,32(sp)
    1018:	69e2                	ld	s3,24(sp)
    101a:	6a42                	ld	s4,16(sp)
    101c:	6aa2                	ld	s5,8(sp)
    101e:	6b02                	ld	s6,0(sp)
    1020:	6121                	addi	sp,sp,64
    1022:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
    1024:	85da                	mv	a1,s6
    1026:	00004517          	auipc	a0,0x4
    102a:	2ca50513          	addi	a0,a0,714 # 52f0 <malloc+0x9da>
    102e:	00003097          	auipc	ra,0x3
    1032:	7d2080e7          	jalr	2002(ra) # 4800 <printf>
    exit(1);
    1036:	4505                	li	a0,1
    1038:	00003097          	auipc	ra,0x3
    103c:	440080e7          	jalr	1088(ra) # 4478 <exit>
      printf("%s: error: write aa %d new file failed\n", i);
    1040:	85a6                	mv	a1,s1
    1042:	00004517          	auipc	a0,0x4
    1046:	2de50513          	addi	a0,a0,734 # 5320 <malloc+0xa0a>
    104a:	00003097          	auipc	ra,0x3
    104e:	7b6080e7          	jalr	1974(ra) # 4800 <printf>
      exit(1);
    1052:	4505                	li	a0,1
    1054:	00003097          	auipc	ra,0x3
    1058:	424080e7          	jalr	1060(ra) # 4478 <exit>
      printf("%s: error: write bb %d new file failed\n", i);
    105c:	85a6                	mv	a1,s1
    105e:	00004517          	auipc	a0,0x4
    1062:	2fa50513          	addi	a0,a0,762 # 5358 <malloc+0xa42>
    1066:	00003097          	auipc	ra,0x3
    106a:	79a080e7          	jalr	1946(ra) # 4800 <printf>
      exit(1);
    106e:	4505                	li	a0,1
    1070:	00003097          	auipc	ra,0x3
    1074:	408080e7          	jalr	1032(ra) # 4478 <exit>
    printf("%s: error: open small failed!\n", s);
    1078:	85da                	mv	a1,s6
    107a:	00004517          	auipc	a0,0x4
    107e:	30650513          	addi	a0,a0,774 # 5380 <malloc+0xa6a>
    1082:	00003097          	auipc	ra,0x3
    1086:	77e080e7          	jalr	1918(ra) # 4800 <printf>
    exit(1);
    108a:	4505                	li	a0,1
    108c:	00003097          	auipc	ra,0x3
    1090:	3ec080e7          	jalr	1004(ra) # 4478 <exit>
    printf("%s: read failed\n", s);
    1094:	85da                	mv	a1,s6
    1096:	00004517          	auipc	a0,0x4
    109a:	30a50513          	addi	a0,a0,778 # 53a0 <malloc+0xa8a>
    109e:	00003097          	auipc	ra,0x3
    10a2:	762080e7          	jalr	1890(ra) # 4800 <printf>
    exit(1);
    10a6:	4505                	li	a0,1
    10a8:	00003097          	auipc	ra,0x3
    10ac:	3d0080e7          	jalr	976(ra) # 4478 <exit>
    printf("%s: unlink small failed\n", s);
    10b0:	85da                	mv	a1,s6
    10b2:	00004517          	auipc	a0,0x4
    10b6:	30650513          	addi	a0,a0,774 # 53b8 <malloc+0xaa2>
    10ba:	00003097          	auipc	ra,0x3
    10be:	746080e7          	jalr	1862(ra) # 4800 <printf>
    exit(1);
    10c2:	4505                	li	a0,1
    10c4:	00003097          	auipc	ra,0x3
    10c8:	3b4080e7          	jalr	948(ra) # 4478 <exit>

00000000000010cc <writebig>:
{
    10cc:	7139                	addi	sp,sp,-64
    10ce:	fc06                	sd	ra,56(sp)
    10d0:	f822                	sd	s0,48(sp)
    10d2:	f426                	sd	s1,40(sp)
    10d4:	f04a                	sd	s2,32(sp)
    10d6:	ec4e                	sd	s3,24(sp)
    10d8:	e852                	sd	s4,16(sp)
    10da:	e456                	sd	s5,8(sp)
    10dc:	0080                	addi	s0,sp,64
    10de:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
    10e0:	20200593          	li	a1,514
    10e4:	00004517          	auipc	a0,0x4
    10e8:	2f450513          	addi	a0,a0,756 # 53d8 <malloc+0xac2>
    10ec:	00003097          	auipc	ra,0x3
    10f0:	3cc080e7          	jalr	972(ra) # 44b8 <open>
    10f4:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
    10f6:	4481                	li	s1,0
    ((int*)buf)[0] = i;
    10f8:	00008917          	auipc	s2,0x8
    10fc:	1e890913          	addi	s2,s2,488 # 92e0 <buf>
  for(i = 0; i < MAXFILE; i++){
    1100:	10c00a13          	li	s4,268
  if(fd < 0){
    1104:	06054c63          	bltz	a0,117c <writebig+0xb0>
    ((int*)buf)[0] = i;
    1108:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
    110c:	40000613          	li	a2,1024
    1110:	85ca                	mv	a1,s2
    1112:	854e                	mv	a0,s3
    1114:	00003097          	auipc	ra,0x3
    1118:	384080e7          	jalr	900(ra) # 4498 <write>
    111c:	40000793          	li	a5,1024
    1120:	06f51c63          	bne	a0,a5,1198 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
    1124:	2485                	addiw	s1,s1,1
    1126:	ff4491e3          	bne	s1,s4,1108 <writebig+0x3c>
  close(fd);
    112a:	854e                	mv	a0,s3
    112c:	00003097          	auipc	ra,0x3
    1130:	374080e7          	jalr	884(ra) # 44a0 <close>
  fd = open("big", O_RDONLY);
    1134:	4581                	li	a1,0
    1136:	00004517          	auipc	a0,0x4
    113a:	2a250513          	addi	a0,a0,674 # 53d8 <malloc+0xac2>
    113e:	00003097          	auipc	ra,0x3
    1142:	37a080e7          	jalr	890(ra) # 44b8 <open>
    1146:	89aa                	mv	s3,a0
  n = 0;
    1148:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
    114a:	00008917          	auipc	s2,0x8
    114e:	19690913          	addi	s2,s2,406 # 92e0 <buf>
  if(fd < 0){
    1152:	06054163          	bltz	a0,11b4 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
    1156:	40000613          	li	a2,1024
    115a:	85ca                	mv	a1,s2
    115c:	854e                	mv	a0,s3
    115e:	00003097          	auipc	ra,0x3
    1162:	332080e7          	jalr	818(ra) # 4490 <read>
    if(i == 0){
    1166:	c52d                	beqz	a0,11d0 <writebig+0x104>
    } else if(i != BSIZE){
    1168:	40000793          	li	a5,1024
    116c:	0af51d63          	bne	a0,a5,1226 <writebig+0x15a>
    if(((int*)buf)[0] != n){
    1170:	00092603          	lw	a2,0(s2)
    1174:	0c961763          	bne	a2,s1,1242 <writebig+0x176>
    n++;
    1178:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
    117a:	bff1                	j	1156 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
    117c:	85d6                	mv	a1,s5
    117e:	00004517          	auipc	a0,0x4
    1182:	26250513          	addi	a0,a0,610 # 53e0 <malloc+0xaca>
    1186:	00003097          	auipc	ra,0x3
    118a:	67a080e7          	jalr	1658(ra) # 4800 <printf>
    exit(1);
    118e:	4505                	li	a0,1
    1190:	00003097          	auipc	ra,0x3
    1194:	2e8080e7          	jalr	744(ra) # 4478 <exit>
      printf("%s: error: write big file failed\n", i);
    1198:	85a6                	mv	a1,s1
    119a:	00004517          	auipc	a0,0x4
    119e:	26650513          	addi	a0,a0,614 # 5400 <malloc+0xaea>
    11a2:	00003097          	auipc	ra,0x3
    11a6:	65e080e7          	jalr	1630(ra) # 4800 <printf>
      exit(1);
    11aa:	4505                	li	a0,1
    11ac:	00003097          	auipc	ra,0x3
    11b0:	2cc080e7          	jalr	716(ra) # 4478 <exit>
    printf("%s: error: open big failed!\n", s);
    11b4:	85d6                	mv	a1,s5
    11b6:	00004517          	auipc	a0,0x4
    11ba:	27250513          	addi	a0,a0,626 # 5428 <malloc+0xb12>
    11be:	00003097          	auipc	ra,0x3
    11c2:	642080e7          	jalr	1602(ra) # 4800 <printf>
    exit(1);
    11c6:	4505                	li	a0,1
    11c8:	00003097          	auipc	ra,0x3
    11cc:	2b0080e7          	jalr	688(ra) # 4478 <exit>
      if(n == MAXFILE - 1){
    11d0:	10b00793          	li	a5,267
    11d4:	02f48a63          	beq	s1,a5,1208 <writebig+0x13c>
  close(fd);
    11d8:	854e                	mv	a0,s3
    11da:	00003097          	auipc	ra,0x3
    11de:	2c6080e7          	jalr	710(ra) # 44a0 <close>
  if(unlink("big") < 0){
    11e2:	00004517          	auipc	a0,0x4
    11e6:	1f650513          	addi	a0,a0,502 # 53d8 <malloc+0xac2>
    11ea:	00003097          	auipc	ra,0x3
    11ee:	2de080e7          	jalr	734(ra) # 44c8 <unlink>
    11f2:	06054663          	bltz	a0,125e <writebig+0x192>
}
    11f6:	70e2                	ld	ra,56(sp)
    11f8:	7442                	ld	s0,48(sp)
    11fa:	74a2                	ld	s1,40(sp)
    11fc:	7902                	ld	s2,32(sp)
    11fe:	69e2                	ld	s3,24(sp)
    1200:	6a42                	ld	s4,16(sp)
    1202:	6aa2                	ld	s5,8(sp)
    1204:	6121                	addi	sp,sp,64
    1206:	8082                	ret
        printf("%s: read only %d blocks from big", n);
    1208:	10b00593          	li	a1,267
    120c:	00004517          	auipc	a0,0x4
    1210:	23c50513          	addi	a0,a0,572 # 5448 <malloc+0xb32>
    1214:	00003097          	auipc	ra,0x3
    1218:	5ec080e7          	jalr	1516(ra) # 4800 <printf>
        exit(1);
    121c:	4505                	li	a0,1
    121e:	00003097          	auipc	ra,0x3
    1222:	25a080e7          	jalr	602(ra) # 4478 <exit>
      printf("%s: read failed %d\n", i);
    1226:	85aa                	mv	a1,a0
    1228:	00004517          	auipc	a0,0x4
    122c:	24850513          	addi	a0,a0,584 # 5470 <malloc+0xb5a>
    1230:	00003097          	auipc	ra,0x3
    1234:	5d0080e7          	jalr	1488(ra) # 4800 <printf>
      exit(1);
    1238:	4505                	li	a0,1
    123a:	00003097          	auipc	ra,0x3
    123e:	23e080e7          	jalr	574(ra) # 4478 <exit>
      printf("%s: read content of block %d is %d\n",
    1242:	85a6                	mv	a1,s1
    1244:	00004517          	auipc	a0,0x4
    1248:	24450513          	addi	a0,a0,580 # 5488 <malloc+0xb72>
    124c:	00003097          	auipc	ra,0x3
    1250:	5b4080e7          	jalr	1460(ra) # 4800 <printf>
      exit(1);
    1254:	4505                	li	a0,1
    1256:	00003097          	auipc	ra,0x3
    125a:	222080e7          	jalr	546(ra) # 4478 <exit>
    printf("%s: unlink big failed\n", s);
    125e:	85d6                	mv	a1,s5
    1260:	00004517          	auipc	a0,0x4
    1264:	25050513          	addi	a0,a0,592 # 54b0 <malloc+0xb9a>
    1268:	00003097          	auipc	ra,0x3
    126c:	598080e7          	jalr	1432(ra) # 4800 <printf>
    exit(1);
    1270:	4505                	li	a0,1
    1272:	00003097          	auipc	ra,0x3
    1276:	206080e7          	jalr	518(ra) # 4478 <exit>

000000000000127a <unlinkread>:
{
    127a:	7179                	addi	sp,sp,-48
    127c:	f406                	sd	ra,40(sp)
    127e:	f022                	sd	s0,32(sp)
    1280:	ec26                	sd	s1,24(sp)
    1282:	e84a                	sd	s2,16(sp)
    1284:	e44e                	sd	s3,8(sp)
    1286:	1800                	addi	s0,sp,48
    1288:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
    128a:	20200593          	li	a1,514
    128e:	00004517          	auipc	a0,0x4
    1292:	84250513          	addi	a0,a0,-1982 # 4ad0 <malloc+0x1ba>
    1296:	00003097          	auipc	ra,0x3
    129a:	222080e7          	jalr	546(ra) # 44b8 <open>
  if(fd < 0){
    129e:	0e054563          	bltz	a0,1388 <unlinkread+0x10e>
    12a2:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
    12a4:	4615                	li	a2,5
    12a6:	00004597          	auipc	a1,0x4
    12aa:	24258593          	addi	a1,a1,578 # 54e8 <malloc+0xbd2>
    12ae:	00003097          	auipc	ra,0x3
    12b2:	1ea080e7          	jalr	490(ra) # 4498 <write>
  close(fd);
    12b6:	8526                	mv	a0,s1
    12b8:	00003097          	auipc	ra,0x3
    12bc:	1e8080e7          	jalr	488(ra) # 44a0 <close>
  fd = open("unlinkread", O_RDWR);
    12c0:	4589                	li	a1,2
    12c2:	00004517          	auipc	a0,0x4
    12c6:	80e50513          	addi	a0,a0,-2034 # 4ad0 <malloc+0x1ba>
    12ca:	00003097          	auipc	ra,0x3
    12ce:	1ee080e7          	jalr	494(ra) # 44b8 <open>
    12d2:	84aa                	mv	s1,a0
  if(fd < 0){
    12d4:	0c054863          	bltz	a0,13a4 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
    12d8:	00003517          	auipc	a0,0x3
    12dc:	7f850513          	addi	a0,a0,2040 # 4ad0 <malloc+0x1ba>
    12e0:	00003097          	auipc	ra,0x3
    12e4:	1e8080e7          	jalr	488(ra) # 44c8 <unlink>
    12e8:	ed61                	bnez	a0,13c0 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    12ea:	20200593          	li	a1,514
    12ee:	00003517          	auipc	a0,0x3
    12f2:	7e250513          	addi	a0,a0,2018 # 4ad0 <malloc+0x1ba>
    12f6:	00003097          	auipc	ra,0x3
    12fa:	1c2080e7          	jalr	450(ra) # 44b8 <open>
    12fe:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
    1300:	460d                	li	a2,3
    1302:	00004597          	auipc	a1,0x4
    1306:	22e58593          	addi	a1,a1,558 # 5530 <malloc+0xc1a>
    130a:	00003097          	auipc	ra,0x3
    130e:	18e080e7          	jalr	398(ra) # 4498 <write>
  close(fd1);
    1312:	854a                	mv	a0,s2
    1314:	00003097          	auipc	ra,0x3
    1318:	18c080e7          	jalr	396(ra) # 44a0 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
    131c:	660d                	lui	a2,0x3
    131e:	00008597          	auipc	a1,0x8
    1322:	fc258593          	addi	a1,a1,-62 # 92e0 <buf>
    1326:	8526                	mv	a0,s1
    1328:	00003097          	auipc	ra,0x3
    132c:	168080e7          	jalr	360(ra) # 4490 <read>
    1330:	4795                	li	a5,5
    1332:	0af51563          	bne	a0,a5,13dc <unlinkread+0x162>
  if(buf[0] != 'h'){
    1336:	00008717          	auipc	a4,0x8
    133a:	faa74703          	lbu	a4,-86(a4) # 92e0 <buf>
    133e:	06800793          	li	a5,104
    1342:	0af71b63          	bne	a4,a5,13f8 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
    1346:	4629                	li	a2,10
    1348:	00008597          	auipc	a1,0x8
    134c:	f9858593          	addi	a1,a1,-104 # 92e0 <buf>
    1350:	8526                	mv	a0,s1
    1352:	00003097          	auipc	ra,0x3
    1356:	146080e7          	jalr	326(ra) # 4498 <write>
    135a:	47a9                	li	a5,10
    135c:	0af51c63          	bne	a0,a5,1414 <unlinkread+0x19a>
  close(fd);
    1360:	8526                	mv	a0,s1
    1362:	00003097          	auipc	ra,0x3
    1366:	13e080e7          	jalr	318(ra) # 44a0 <close>
  unlink("unlinkread");
    136a:	00003517          	auipc	a0,0x3
    136e:	76650513          	addi	a0,a0,1894 # 4ad0 <malloc+0x1ba>
    1372:	00003097          	auipc	ra,0x3
    1376:	156080e7          	jalr	342(ra) # 44c8 <unlink>
}
    137a:	70a2                	ld	ra,40(sp)
    137c:	7402                	ld	s0,32(sp)
    137e:	64e2                	ld	s1,24(sp)
    1380:	6942                	ld	s2,16(sp)
    1382:	69a2                	ld	s3,8(sp)
    1384:	6145                	addi	sp,sp,48
    1386:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
    1388:	85ce                	mv	a1,s3
    138a:	00004517          	auipc	a0,0x4
    138e:	13e50513          	addi	a0,a0,318 # 54c8 <malloc+0xbb2>
    1392:	00003097          	auipc	ra,0x3
    1396:	46e080e7          	jalr	1134(ra) # 4800 <printf>
    exit(1);
    139a:	4505                	li	a0,1
    139c:	00003097          	auipc	ra,0x3
    13a0:	0dc080e7          	jalr	220(ra) # 4478 <exit>
    printf("%s: open unlinkread failed\n", s);
    13a4:	85ce                	mv	a1,s3
    13a6:	00004517          	auipc	a0,0x4
    13aa:	14a50513          	addi	a0,a0,330 # 54f0 <malloc+0xbda>
    13ae:	00003097          	auipc	ra,0x3
    13b2:	452080e7          	jalr	1106(ra) # 4800 <printf>
    exit(1);
    13b6:	4505                	li	a0,1
    13b8:	00003097          	auipc	ra,0x3
    13bc:	0c0080e7          	jalr	192(ra) # 4478 <exit>
    printf("%s: unlink unlinkread failed\n", s);
    13c0:	85ce                	mv	a1,s3
    13c2:	00004517          	auipc	a0,0x4
    13c6:	14e50513          	addi	a0,a0,334 # 5510 <malloc+0xbfa>
    13ca:	00003097          	auipc	ra,0x3
    13ce:	436080e7          	jalr	1078(ra) # 4800 <printf>
    exit(1);
    13d2:	4505                	li	a0,1
    13d4:	00003097          	auipc	ra,0x3
    13d8:	0a4080e7          	jalr	164(ra) # 4478 <exit>
    printf("%s: unlinkread read failed", s);
    13dc:	85ce                	mv	a1,s3
    13de:	00004517          	auipc	a0,0x4
    13e2:	15a50513          	addi	a0,a0,346 # 5538 <malloc+0xc22>
    13e6:	00003097          	auipc	ra,0x3
    13ea:	41a080e7          	jalr	1050(ra) # 4800 <printf>
    exit(1);
    13ee:	4505                	li	a0,1
    13f0:	00003097          	auipc	ra,0x3
    13f4:	088080e7          	jalr	136(ra) # 4478 <exit>
    printf("%s: unlinkread wrong data\n", s);
    13f8:	85ce                	mv	a1,s3
    13fa:	00004517          	auipc	a0,0x4
    13fe:	15e50513          	addi	a0,a0,350 # 5558 <malloc+0xc42>
    1402:	00003097          	auipc	ra,0x3
    1406:	3fe080e7          	jalr	1022(ra) # 4800 <printf>
    exit(1);
    140a:	4505                	li	a0,1
    140c:	00003097          	auipc	ra,0x3
    1410:	06c080e7          	jalr	108(ra) # 4478 <exit>
    printf("%s: unlinkread write failed\n", s);
    1414:	85ce                	mv	a1,s3
    1416:	00004517          	auipc	a0,0x4
    141a:	16250513          	addi	a0,a0,354 # 5578 <malloc+0xc62>
    141e:	00003097          	auipc	ra,0x3
    1422:	3e2080e7          	jalr	994(ra) # 4800 <printf>
    exit(1);
    1426:	4505                	li	a0,1
    1428:	00003097          	auipc	ra,0x3
    142c:	050080e7          	jalr	80(ra) # 4478 <exit>

0000000000001430 <exectest>:
{
    1430:	715d                	addi	sp,sp,-80
    1432:	e486                	sd	ra,72(sp)
    1434:	e0a2                	sd	s0,64(sp)
    1436:	fc26                	sd	s1,56(sp)
    1438:	f84a                	sd	s2,48(sp)
    143a:	0880                	addi	s0,sp,80
    143c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    143e:	00004797          	auipc	a5,0x4
    1442:	b8a78793          	addi	a5,a5,-1142 # 4fc8 <malloc+0x6b2>
    1446:	fcf43023          	sd	a5,-64(s0)
    144a:	00004797          	auipc	a5,0x4
    144e:	14e78793          	addi	a5,a5,334 # 5598 <malloc+0xc82>
    1452:	fcf43423          	sd	a5,-56(s0)
    1456:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    145a:	00004517          	auipc	a0,0x4
    145e:	14650513          	addi	a0,a0,326 # 55a0 <malloc+0xc8a>
    1462:	00003097          	auipc	ra,0x3
    1466:	066080e7          	jalr	102(ra) # 44c8 <unlink>
  pid = fork();
    146a:	00003097          	auipc	ra,0x3
    146e:	006080e7          	jalr	6(ra) # 4470 <fork>
  if(pid < 0) {
    1472:	04054663          	bltz	a0,14be <exectest+0x8e>
    1476:	84aa                	mv	s1,a0
  if(pid == 0) {
    1478:	e959                	bnez	a0,150e <exectest+0xde>
    close(1);
    147a:	4505                	li	a0,1
    147c:	00003097          	auipc	ra,0x3
    1480:	024080e7          	jalr	36(ra) # 44a0 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1484:	20100593          	li	a1,513
    1488:	00004517          	auipc	a0,0x4
    148c:	11850513          	addi	a0,a0,280 # 55a0 <malloc+0xc8a>
    1490:	00003097          	auipc	ra,0x3
    1494:	028080e7          	jalr	40(ra) # 44b8 <open>
    if(fd < 0) {
    1498:	04054163          	bltz	a0,14da <exectest+0xaa>
    if(fd != 1) {
    149c:	4785                	li	a5,1
    149e:	04f50c63          	beq	a0,a5,14f6 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    14a2:	85ca                	mv	a1,s2
    14a4:	00004517          	auipc	a0,0x4
    14a8:	10450513          	addi	a0,a0,260 # 55a8 <malloc+0xc92>
    14ac:	00003097          	auipc	ra,0x3
    14b0:	354080e7          	jalr	852(ra) # 4800 <printf>
      exit(1);
    14b4:	4505                	li	a0,1
    14b6:	00003097          	auipc	ra,0x3
    14ba:	fc2080e7          	jalr	-62(ra) # 4478 <exit>
     printf("%s: fork failed\n", s);
    14be:	85ca                	mv	a1,s2
    14c0:	00004517          	auipc	a0,0x4
    14c4:	95850513          	addi	a0,a0,-1704 # 4e18 <malloc+0x502>
    14c8:	00003097          	auipc	ra,0x3
    14cc:	338080e7          	jalr	824(ra) # 4800 <printf>
     exit(1);
    14d0:	4505                	li	a0,1
    14d2:	00003097          	auipc	ra,0x3
    14d6:	fa6080e7          	jalr	-90(ra) # 4478 <exit>
      printf("%s: create failed\n", s);
    14da:	85ca                	mv	a1,s2
    14dc:	00004517          	auipc	a0,0x4
    14e0:	b5450513          	addi	a0,a0,-1196 # 5030 <malloc+0x71a>
    14e4:	00003097          	auipc	ra,0x3
    14e8:	31c080e7          	jalr	796(ra) # 4800 <printf>
      exit(1);
    14ec:	4505                	li	a0,1
    14ee:	00003097          	auipc	ra,0x3
    14f2:	f8a080e7          	jalr	-118(ra) # 4478 <exit>
    if(exec("echo", echoargv) < 0){
    14f6:	fc040593          	addi	a1,s0,-64
    14fa:	00004517          	auipc	a0,0x4
    14fe:	ace50513          	addi	a0,a0,-1330 # 4fc8 <malloc+0x6b2>
    1502:	00003097          	auipc	ra,0x3
    1506:	fae080e7          	jalr	-82(ra) # 44b0 <exec>
    150a:	02054163          	bltz	a0,152c <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    150e:	fdc40513          	addi	a0,s0,-36
    1512:	00003097          	auipc	ra,0x3
    1516:	f6e080e7          	jalr	-146(ra) # 4480 <wait>
    151a:	02951763          	bne	a0,s1,1548 <exectest+0x118>
  if(xstatus != 0)
    151e:	fdc42503          	lw	a0,-36(s0)
    1522:	cd0d                	beqz	a0,155c <exectest+0x12c>
    exit(xstatus);
    1524:	00003097          	auipc	ra,0x3
    1528:	f54080e7          	jalr	-172(ra) # 4478 <exit>
      printf("%s: exec echo failed\n", s);
    152c:	85ca                	mv	a1,s2
    152e:	00004517          	auipc	a0,0x4
    1532:	08a50513          	addi	a0,a0,138 # 55b8 <malloc+0xca2>
    1536:	00003097          	auipc	ra,0x3
    153a:	2ca080e7          	jalr	714(ra) # 4800 <printf>
      exit(1);
    153e:	4505                	li	a0,1
    1540:	00003097          	auipc	ra,0x3
    1544:	f38080e7          	jalr	-200(ra) # 4478 <exit>
    printf("%s: wait failed!\n", s);
    1548:	85ca                	mv	a1,s2
    154a:	00004517          	auipc	a0,0x4
    154e:	08650513          	addi	a0,a0,134 # 55d0 <malloc+0xcba>
    1552:	00003097          	auipc	ra,0x3
    1556:	2ae080e7          	jalr	686(ra) # 4800 <printf>
    155a:	b7d1                	j	151e <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    155c:	4581                	li	a1,0
    155e:	00004517          	auipc	a0,0x4
    1562:	04250513          	addi	a0,a0,66 # 55a0 <malloc+0xc8a>
    1566:	00003097          	auipc	ra,0x3
    156a:	f52080e7          	jalr	-174(ra) # 44b8 <open>
  if(fd < 0) {
    156e:	02054a63          	bltz	a0,15a2 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1572:	4609                	li	a2,2
    1574:	fb840593          	addi	a1,s0,-72
    1578:	00003097          	auipc	ra,0x3
    157c:	f18080e7          	jalr	-232(ra) # 4490 <read>
    1580:	4789                	li	a5,2
    1582:	02f50e63          	beq	a0,a5,15be <exectest+0x18e>
    printf("%s: read failed\n", s);
    1586:	85ca                	mv	a1,s2
    1588:	00004517          	auipc	a0,0x4
    158c:	e1850513          	addi	a0,a0,-488 # 53a0 <malloc+0xa8a>
    1590:	00003097          	auipc	ra,0x3
    1594:	270080e7          	jalr	624(ra) # 4800 <printf>
    exit(1);
    1598:	4505                	li	a0,1
    159a:	00003097          	auipc	ra,0x3
    159e:	ede080e7          	jalr	-290(ra) # 4478 <exit>
    printf("%s: open failed\n", s);
    15a2:	85ca                	mv	a1,s2
    15a4:	00004517          	auipc	a0,0x4
    15a8:	04450513          	addi	a0,a0,68 # 55e8 <malloc+0xcd2>
    15ac:	00003097          	auipc	ra,0x3
    15b0:	254080e7          	jalr	596(ra) # 4800 <printf>
    exit(1);
    15b4:	4505                	li	a0,1
    15b6:	00003097          	auipc	ra,0x3
    15ba:	ec2080e7          	jalr	-318(ra) # 4478 <exit>
  unlink("echo-ok");
    15be:	00004517          	auipc	a0,0x4
    15c2:	fe250513          	addi	a0,a0,-30 # 55a0 <malloc+0xc8a>
    15c6:	00003097          	auipc	ra,0x3
    15ca:	f02080e7          	jalr	-254(ra) # 44c8 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    15ce:	fb844703          	lbu	a4,-72(s0)
    15d2:	04f00793          	li	a5,79
    15d6:	00f71863          	bne	a4,a5,15e6 <exectest+0x1b6>
    15da:	fb944703          	lbu	a4,-71(s0)
    15de:	04b00793          	li	a5,75
    15e2:	02f70063          	beq	a4,a5,1602 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    15e6:	85ca                	mv	a1,s2
    15e8:	00004517          	auipc	a0,0x4
    15ec:	01850513          	addi	a0,a0,24 # 5600 <malloc+0xcea>
    15f0:	00003097          	auipc	ra,0x3
    15f4:	210080e7          	jalr	528(ra) # 4800 <printf>
    exit(1);
    15f8:	4505                	li	a0,1
    15fa:	00003097          	auipc	ra,0x3
    15fe:	e7e080e7          	jalr	-386(ra) # 4478 <exit>
    exit(0);
    1602:	4501                	li	a0,0
    1604:	00003097          	auipc	ra,0x3
    1608:	e74080e7          	jalr	-396(ra) # 4478 <exit>

000000000000160c <bigargtest>:
{
    160c:	7179                	addi	sp,sp,-48
    160e:	f406                	sd	ra,40(sp)
    1610:	f022                	sd	s0,32(sp)
    1612:	ec26                	sd	s1,24(sp)
    1614:	1800                	addi	s0,sp,48
    1616:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    1618:	00004517          	auipc	a0,0x4
    161c:	00050513          	mv	a0,a0
    1620:	00003097          	auipc	ra,0x3
    1624:	ea8080e7          	jalr	-344(ra) # 44c8 <unlink>
  pid = fork();
    1628:	00003097          	auipc	ra,0x3
    162c:	e48080e7          	jalr	-440(ra) # 4470 <fork>
  if(pid == 0){
    1630:	c121                	beqz	a0,1670 <bigargtest+0x64>
  } else if(pid < 0){
    1632:	0a054063          	bltz	a0,16d2 <bigargtest+0xc6>
  wait(&xstatus);
    1636:	fdc40513          	addi	a0,s0,-36
    163a:	00003097          	auipc	ra,0x3
    163e:	e46080e7          	jalr	-442(ra) # 4480 <wait>
  if(xstatus != 0)
    1642:	fdc42503          	lw	a0,-36(s0)
    1646:	e545                	bnez	a0,16ee <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    1648:	4581                	li	a1,0
    164a:	00004517          	auipc	a0,0x4
    164e:	fce50513          	addi	a0,a0,-50 # 5618 <malloc+0xd02>
    1652:	00003097          	auipc	ra,0x3
    1656:	e66080e7          	jalr	-410(ra) # 44b8 <open>
  if(fd < 0){
    165a:	08054e63          	bltz	a0,16f6 <bigargtest+0xea>
  close(fd);
    165e:	00003097          	auipc	ra,0x3
    1662:	e42080e7          	jalr	-446(ra) # 44a0 <close>
}
    1666:	70a2                	ld	ra,40(sp)
    1668:	7402                	ld	s0,32(sp)
    166a:	64e2                	ld	s1,24(sp)
    166c:	6145                	addi	sp,sp,48
    166e:	8082                	ret
    1670:	00005797          	auipc	a5,0x5
    1674:	46078793          	addi	a5,a5,1120 # 6ad0 <args.1720>
    1678:	00005697          	auipc	a3,0x5
    167c:	55068693          	addi	a3,a3,1360 # 6bc8 <args.1720+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    1680:	00004717          	auipc	a4,0x4
    1684:	fa870713          	addi	a4,a4,-88 # 5628 <malloc+0xd12>
    1688:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    168a:	07a1                	addi	a5,a5,8
    168c:	fed79ee3          	bne	a5,a3,1688 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    1690:	00005597          	auipc	a1,0x5
    1694:	44058593          	addi	a1,a1,1088 # 6ad0 <args.1720>
    1698:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    169c:	00004517          	auipc	a0,0x4
    16a0:	92c50513          	addi	a0,a0,-1748 # 4fc8 <malloc+0x6b2>
    16a4:	00003097          	auipc	ra,0x3
    16a8:	e0c080e7          	jalr	-500(ra) # 44b0 <exec>
    fd = open("bigarg-ok", O_CREATE);
    16ac:	20000593          	li	a1,512
    16b0:	00004517          	auipc	a0,0x4
    16b4:	f6850513          	addi	a0,a0,-152 # 5618 <malloc+0xd02>
    16b8:	00003097          	auipc	ra,0x3
    16bc:	e00080e7          	jalr	-512(ra) # 44b8 <open>
    close(fd);
    16c0:	00003097          	auipc	ra,0x3
    16c4:	de0080e7          	jalr	-544(ra) # 44a0 <close>
    exit(0);
    16c8:	4501                	li	a0,0
    16ca:	00003097          	auipc	ra,0x3
    16ce:	dae080e7          	jalr	-594(ra) # 4478 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    16d2:	85a6                	mv	a1,s1
    16d4:	00004517          	auipc	a0,0x4
    16d8:	03450513          	addi	a0,a0,52 # 5708 <malloc+0xdf2>
    16dc:	00003097          	auipc	ra,0x3
    16e0:	124080e7          	jalr	292(ra) # 4800 <printf>
    exit(1);
    16e4:	4505                	li	a0,1
    16e6:	00003097          	auipc	ra,0x3
    16ea:	d92080e7          	jalr	-622(ra) # 4478 <exit>
    exit(xstatus);
    16ee:	00003097          	auipc	ra,0x3
    16f2:	d8a080e7          	jalr	-630(ra) # 4478 <exit>
    printf("%s: bigarg test failed!\n", s);
    16f6:	85a6                	mv	a1,s1
    16f8:	00004517          	auipc	a0,0x4
    16fc:	03050513          	addi	a0,a0,48 # 5728 <malloc+0xe12>
    1700:	00003097          	auipc	ra,0x3
    1704:	100080e7          	jalr	256(ra) # 4800 <printf>
    exit(1);
    1708:	4505                	li	a0,1
    170a:	00003097          	auipc	ra,0x3
    170e:	d6e080e7          	jalr	-658(ra) # 4478 <exit>

0000000000001712 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1712:	7139                	addi	sp,sp,-64
    1714:	fc06                	sd	ra,56(sp)
    1716:	f822                	sd	s0,48(sp)
    1718:	f426                	sd	s1,40(sp)
    171a:	f04a                	sd	s2,32(sp)
    171c:	ec4e                	sd	s3,24(sp)
    171e:	0080                	addi	s0,sp,64
    1720:	64b1                	lui	s1,0xc
    1722:	35048493          	addi	s1,s1,848 # c350 <__BSS_END__+0x48>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1726:	597d                	li	s2,-1
    1728:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    172c:	00004997          	auipc	s3,0x4
    1730:	89c98993          	addi	s3,s3,-1892 # 4fc8 <malloc+0x6b2>
    argv[0] = (char*)0xffffffff;
    1734:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1738:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    173c:	fc040593          	addi	a1,s0,-64
    1740:	854e                	mv	a0,s3
    1742:	00003097          	auipc	ra,0x3
    1746:	d6e080e7          	jalr	-658(ra) # 44b0 <exec>
  for(int i = 0; i < 50000; i++){
    174a:	34fd                	addiw	s1,s1,-1
    174c:	f4e5                	bnez	s1,1734 <badarg+0x22>
  }
  
  exit(0);
    174e:	4501                	li	a0,0
    1750:	00003097          	auipc	ra,0x3
    1754:	d28080e7          	jalr	-728(ra) # 4478 <exit>

0000000000001758 <pipe1>:
{
    1758:	711d                	addi	sp,sp,-96
    175a:	ec86                	sd	ra,88(sp)
    175c:	e8a2                	sd	s0,80(sp)
    175e:	e4a6                	sd	s1,72(sp)
    1760:	e0ca                	sd	s2,64(sp)
    1762:	fc4e                	sd	s3,56(sp)
    1764:	f852                	sd	s4,48(sp)
    1766:	f456                	sd	s5,40(sp)
    1768:	f05a                	sd	s6,32(sp)
    176a:	ec5e                	sd	s7,24(sp)
    176c:	1080                	addi	s0,sp,96
    176e:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1770:	fa840513          	addi	a0,s0,-88
    1774:	00003097          	auipc	ra,0x3
    1778:	d14080e7          	jalr	-748(ra) # 4488 <pipe>
    177c:	ed25                	bnez	a0,17f4 <pipe1+0x9c>
    177e:	84aa                	mv	s1,a0
  pid = fork();
    1780:	00003097          	auipc	ra,0x3
    1784:	cf0080e7          	jalr	-784(ra) # 4470 <fork>
    1788:	8a2a                	mv	s4,a0
  if(pid == 0){
    178a:	c159                	beqz	a0,1810 <pipe1+0xb8>
  } else if(pid > 0){
    178c:	16a05e63          	blez	a0,1908 <pipe1+0x1b0>
    close(fds[1]);
    1790:	fac42503          	lw	a0,-84(s0)
    1794:	00003097          	auipc	ra,0x3
    1798:	d0c080e7          	jalr	-756(ra) # 44a0 <close>
    total = 0;
    179c:	8a26                	mv	s4,s1
    cc = 1;
    179e:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    17a0:	00008a97          	auipc	s5,0x8
    17a4:	b40a8a93          	addi	s5,s5,-1216 # 92e0 <buf>
      if(cc > sizeof(buf))
    17a8:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    17aa:	864e                	mv	a2,s3
    17ac:	85d6                	mv	a1,s5
    17ae:	fa842503          	lw	a0,-88(s0)
    17b2:	00003097          	auipc	ra,0x3
    17b6:	cde080e7          	jalr	-802(ra) # 4490 <read>
    17ba:	10a05263          	blez	a0,18be <pipe1+0x166>
      for(i = 0; i < n; i++){
    17be:	00008717          	auipc	a4,0x8
    17c2:	b2270713          	addi	a4,a4,-1246 # 92e0 <buf>
    17c6:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17ca:	00074683          	lbu	a3,0(a4)
    17ce:	0ff4f793          	andi	a5,s1,255
    17d2:	2485                	addiw	s1,s1,1
    17d4:	0cf69163          	bne	a3,a5,1896 <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17d8:	0705                	addi	a4,a4,1
    17da:	fec498e3          	bne	s1,a2,17ca <pipe1+0x72>
      total += n;
    17de:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17e2:	0019979b          	slliw	a5,s3,0x1
    17e6:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17ea:	013b7363          	bgeu	s6,s3,17f0 <pipe1+0x98>
        cc = sizeof(buf);
    17ee:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17f0:	84b2                	mv	s1,a2
    17f2:	bf65                	j	17aa <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17f4:	85ca                	mv	a1,s2
    17f6:	00004517          	auipc	a0,0x4
    17fa:	f5250513          	addi	a0,a0,-174 # 5748 <malloc+0xe32>
    17fe:	00003097          	auipc	ra,0x3
    1802:	002080e7          	jalr	2(ra) # 4800 <printf>
    exit(1);
    1806:	4505                	li	a0,1
    1808:	00003097          	auipc	ra,0x3
    180c:	c70080e7          	jalr	-912(ra) # 4478 <exit>
    close(fds[0]);
    1810:	fa842503          	lw	a0,-88(s0)
    1814:	00003097          	auipc	ra,0x3
    1818:	c8c080e7          	jalr	-884(ra) # 44a0 <close>
    for(n = 0; n < N; n++){
    181c:	00008b17          	auipc	s6,0x8
    1820:	ac4b0b13          	addi	s6,s6,-1340 # 92e0 <buf>
    1824:	416004bb          	negw	s1,s6
    1828:	0ff4f493          	andi	s1,s1,255
    182c:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1830:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1832:	6a85                	lui	s5,0x1
    1834:	42da8a93          	addi	s5,s5,1069 # 142d <unlinkread+0x1b3>
{
    1838:	87da                	mv	a5,s6
        buf[i] = seq++;
    183a:	0097873b          	addw	a4,a5,s1
    183e:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1842:	0785                	addi	a5,a5,1
    1844:	fef99be3          	bne	s3,a5,183a <pipe1+0xe2>
    1848:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    184c:	40900613          	li	a2,1033
    1850:	85de                	mv	a1,s7
    1852:	fac42503          	lw	a0,-84(s0)
    1856:	00003097          	auipc	ra,0x3
    185a:	c42080e7          	jalr	-958(ra) # 4498 <write>
    185e:	40900793          	li	a5,1033
    1862:	00f51c63          	bne	a0,a5,187a <pipe1+0x122>
    for(n = 0; n < N; n++){
    1866:	24a5                	addiw	s1,s1,9
    1868:	0ff4f493          	andi	s1,s1,255
    186c:	fd5a16e3          	bne	s4,s5,1838 <pipe1+0xe0>
    exit(0);
    1870:	4501                	li	a0,0
    1872:	00003097          	auipc	ra,0x3
    1876:	c06080e7          	jalr	-1018(ra) # 4478 <exit>
        printf("%s: pipe1 oops 1\n", s);
    187a:	85ca                	mv	a1,s2
    187c:	00004517          	auipc	a0,0x4
    1880:	ee450513          	addi	a0,a0,-284 # 5760 <malloc+0xe4a>
    1884:	00003097          	auipc	ra,0x3
    1888:	f7c080e7          	jalr	-132(ra) # 4800 <printf>
        exit(1);
    188c:	4505                	li	a0,1
    188e:	00003097          	auipc	ra,0x3
    1892:	bea080e7          	jalr	-1046(ra) # 4478 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1896:	85ca                	mv	a1,s2
    1898:	00004517          	auipc	a0,0x4
    189c:	ee050513          	addi	a0,a0,-288 # 5778 <malloc+0xe62>
    18a0:	00003097          	auipc	ra,0x3
    18a4:	f60080e7          	jalr	-160(ra) # 4800 <printf>
}
    18a8:	60e6                	ld	ra,88(sp)
    18aa:	6446                	ld	s0,80(sp)
    18ac:	64a6                	ld	s1,72(sp)
    18ae:	6906                	ld	s2,64(sp)
    18b0:	79e2                	ld	s3,56(sp)
    18b2:	7a42                	ld	s4,48(sp)
    18b4:	7aa2                	ld	s5,40(sp)
    18b6:	7b02                	ld	s6,32(sp)
    18b8:	6be2                	ld	s7,24(sp)
    18ba:	6125                	addi	sp,sp,96
    18bc:	8082                	ret
    if(total != N * SZ){
    18be:	6785                	lui	a5,0x1
    18c0:	42d78793          	addi	a5,a5,1069 # 142d <unlinkread+0x1b3>
    18c4:	02fa0063          	beq	s4,a5,18e4 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18c8:	85d2                	mv	a1,s4
    18ca:	00004517          	auipc	a0,0x4
    18ce:	ec650513          	addi	a0,a0,-314 # 5790 <malloc+0xe7a>
    18d2:	00003097          	auipc	ra,0x3
    18d6:	f2e080e7          	jalr	-210(ra) # 4800 <printf>
      exit(1);
    18da:	4505                	li	a0,1
    18dc:	00003097          	auipc	ra,0x3
    18e0:	b9c080e7          	jalr	-1124(ra) # 4478 <exit>
    close(fds[0]);
    18e4:	fa842503          	lw	a0,-88(s0)
    18e8:	00003097          	auipc	ra,0x3
    18ec:	bb8080e7          	jalr	-1096(ra) # 44a0 <close>
    wait(&xstatus);
    18f0:	fa440513          	addi	a0,s0,-92
    18f4:	00003097          	auipc	ra,0x3
    18f8:	b8c080e7          	jalr	-1140(ra) # 4480 <wait>
    exit(xstatus);
    18fc:	fa442503          	lw	a0,-92(s0)
    1900:	00003097          	auipc	ra,0x3
    1904:	b78080e7          	jalr	-1160(ra) # 4478 <exit>
    printf("%s: fork() failed\n", s);
    1908:	85ca                	mv	a1,s2
    190a:	00004517          	auipc	a0,0x4
    190e:	ea650513          	addi	a0,a0,-346 # 57b0 <malloc+0xe9a>
    1912:	00003097          	auipc	ra,0x3
    1916:	eee080e7          	jalr	-274(ra) # 4800 <printf>
    exit(1);
    191a:	4505                	li	a0,1
    191c:	00003097          	auipc	ra,0x3
    1920:	b5c080e7          	jalr	-1188(ra) # 4478 <exit>

0000000000001924 <pgbug>:
{
    1924:	7179                	addi	sp,sp,-48
    1926:	f406                	sd	ra,40(sp)
    1928:	f022                	sd	s0,32(sp)
    192a:	ec26                	sd	s1,24(sp)
    192c:	1800                	addi	s0,sp,48
  argv[0] = 0;
    192e:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1932:	00005497          	auipc	s1,0x5
    1936:	17e4b483          	ld	s1,382(s1) # 6ab0 <__SDATA_BEGIN__>
    193a:	fd840593          	addi	a1,s0,-40
    193e:	8526                	mv	a0,s1
    1940:	00003097          	auipc	ra,0x3
    1944:	b70080e7          	jalr	-1168(ra) # 44b0 <exec>
  pipe((int*)0xeaeb0b5b00002f5e);
    1948:	8526                	mv	a0,s1
    194a:	00003097          	auipc	ra,0x3
    194e:	b3e080e7          	jalr	-1218(ra) # 4488 <pipe>
  exit(0);
    1952:	4501                	li	a0,0
    1954:	00003097          	auipc	ra,0x3
    1958:	b24080e7          	jalr	-1244(ra) # 4478 <exit>

000000000000195c <preempt>:
{
    195c:	7139                	addi	sp,sp,-64
    195e:	fc06                	sd	ra,56(sp)
    1960:	f822                	sd	s0,48(sp)
    1962:	f426                	sd	s1,40(sp)
    1964:	f04a                	sd	s2,32(sp)
    1966:	ec4e                	sd	s3,24(sp)
    1968:	e852                	sd	s4,16(sp)
    196a:	0080                	addi	s0,sp,64
    196c:	8a2a                	mv	s4,a0
  pid1 = fork();
    196e:	00003097          	auipc	ra,0x3
    1972:	b02080e7          	jalr	-1278(ra) # 4470 <fork>
  if(pid1 < 0) {
    1976:	00054563          	bltz	a0,1980 <preempt+0x24>
    197a:	89aa                	mv	s3,a0
  if(pid1 == 0)
    197c:	ed19                	bnez	a0,199a <preempt+0x3e>
    for(;;)
    197e:	a001                	j	197e <preempt+0x22>
    printf("%s: fork failed");
    1980:	00003517          	auipc	a0,0x3
    1984:	50050513          	addi	a0,a0,1280 # 4e80 <malloc+0x56a>
    1988:	00003097          	auipc	ra,0x3
    198c:	e78080e7          	jalr	-392(ra) # 4800 <printf>
    exit(1);
    1990:	4505                	li	a0,1
    1992:	00003097          	auipc	ra,0x3
    1996:	ae6080e7          	jalr	-1306(ra) # 4478 <exit>
  pid2 = fork();
    199a:	00003097          	auipc	ra,0x3
    199e:	ad6080e7          	jalr	-1322(ra) # 4470 <fork>
    19a2:	892a                	mv	s2,a0
  if(pid2 < 0) {
    19a4:	00054463          	bltz	a0,19ac <preempt+0x50>
  if(pid2 == 0)
    19a8:	e105                	bnez	a0,19c8 <preempt+0x6c>
    for(;;)
    19aa:	a001                	j	19aa <preempt+0x4e>
    printf("%s: fork failed\n", s);
    19ac:	85d2                	mv	a1,s4
    19ae:	00003517          	auipc	a0,0x3
    19b2:	46a50513          	addi	a0,a0,1130 # 4e18 <malloc+0x502>
    19b6:	00003097          	auipc	ra,0x3
    19ba:	e4a080e7          	jalr	-438(ra) # 4800 <printf>
    exit(1);
    19be:	4505                	li	a0,1
    19c0:	00003097          	auipc	ra,0x3
    19c4:	ab8080e7          	jalr	-1352(ra) # 4478 <exit>
  pipe(pfds);
    19c8:	fc840513          	addi	a0,s0,-56
    19cc:	00003097          	auipc	ra,0x3
    19d0:	abc080e7          	jalr	-1348(ra) # 4488 <pipe>
  pid3 = fork();
    19d4:	00003097          	auipc	ra,0x3
    19d8:	a9c080e7          	jalr	-1380(ra) # 4470 <fork>
    19dc:	84aa                	mv	s1,a0
  if(pid3 < 0) {
    19de:	02054e63          	bltz	a0,1a1a <preempt+0xbe>
  if(pid3 == 0){
    19e2:	e13d                	bnez	a0,1a48 <preempt+0xec>
    close(pfds[0]);
    19e4:	fc842503          	lw	a0,-56(s0)
    19e8:	00003097          	auipc	ra,0x3
    19ec:	ab8080e7          	jalr	-1352(ra) # 44a0 <close>
    if(write(pfds[1], "x", 1) != 1)
    19f0:	4605                	li	a2,1
    19f2:	00004597          	auipc	a1,0x4
    19f6:	dd658593          	addi	a1,a1,-554 # 57c8 <malloc+0xeb2>
    19fa:	fcc42503          	lw	a0,-52(s0)
    19fe:	00003097          	auipc	ra,0x3
    1a02:	a9a080e7          	jalr	-1382(ra) # 4498 <write>
    1a06:	4785                	li	a5,1
    1a08:	02f51763          	bne	a0,a5,1a36 <preempt+0xda>
    close(pfds[1]);
    1a0c:	fcc42503          	lw	a0,-52(s0)
    1a10:	00003097          	auipc	ra,0x3
    1a14:	a90080e7          	jalr	-1392(ra) # 44a0 <close>
    for(;;)
    1a18:	a001                	j	1a18 <preempt+0xbc>
     printf("%s: fork failed\n", s);
    1a1a:	85d2                	mv	a1,s4
    1a1c:	00003517          	auipc	a0,0x3
    1a20:	3fc50513          	addi	a0,a0,1020 # 4e18 <malloc+0x502>
    1a24:	00003097          	auipc	ra,0x3
    1a28:	ddc080e7          	jalr	-548(ra) # 4800 <printf>
     exit(1);
    1a2c:	4505                	li	a0,1
    1a2e:	00003097          	auipc	ra,0x3
    1a32:	a4a080e7          	jalr	-1462(ra) # 4478 <exit>
      printf("%s: preempt write error");
    1a36:	00004517          	auipc	a0,0x4
    1a3a:	d9a50513          	addi	a0,a0,-614 # 57d0 <malloc+0xeba>
    1a3e:	00003097          	auipc	ra,0x3
    1a42:	dc2080e7          	jalr	-574(ra) # 4800 <printf>
    1a46:	b7d9                	j	1a0c <preempt+0xb0>
  close(pfds[1]);
    1a48:	fcc42503          	lw	a0,-52(s0)
    1a4c:	00003097          	auipc	ra,0x3
    1a50:	a54080e7          	jalr	-1452(ra) # 44a0 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    1a54:	660d                	lui	a2,0x3
    1a56:	00008597          	auipc	a1,0x8
    1a5a:	88a58593          	addi	a1,a1,-1910 # 92e0 <buf>
    1a5e:	fc842503          	lw	a0,-56(s0)
    1a62:	00003097          	auipc	ra,0x3
    1a66:	a2e080e7          	jalr	-1490(ra) # 4490 <read>
    1a6a:	4785                	li	a5,1
    1a6c:	02f50263          	beq	a0,a5,1a90 <preempt+0x134>
    printf("%s: preempt read error");
    1a70:	00004517          	auipc	a0,0x4
    1a74:	d7850513          	addi	a0,a0,-648 # 57e8 <malloc+0xed2>
    1a78:	00003097          	auipc	ra,0x3
    1a7c:	d88080e7          	jalr	-632(ra) # 4800 <printf>
}
    1a80:	70e2                	ld	ra,56(sp)
    1a82:	7442                	ld	s0,48(sp)
    1a84:	74a2                	ld	s1,40(sp)
    1a86:	7902                	ld	s2,32(sp)
    1a88:	69e2                	ld	s3,24(sp)
    1a8a:	6a42                	ld	s4,16(sp)
    1a8c:	6121                	addi	sp,sp,64
    1a8e:	8082                	ret
  close(pfds[0]);
    1a90:	fc842503          	lw	a0,-56(s0)
    1a94:	00003097          	auipc	ra,0x3
    1a98:	a0c080e7          	jalr	-1524(ra) # 44a0 <close>
  printf("kill... ");
    1a9c:	00004517          	auipc	a0,0x4
    1aa0:	d6450513          	addi	a0,a0,-668 # 5800 <malloc+0xeea>
    1aa4:	00003097          	auipc	ra,0x3
    1aa8:	d5c080e7          	jalr	-676(ra) # 4800 <printf>
  kill(pid1);
    1aac:	854e                	mv	a0,s3
    1aae:	00003097          	auipc	ra,0x3
    1ab2:	9fa080e7          	jalr	-1542(ra) # 44a8 <kill>
  kill(pid2);
    1ab6:	854a                	mv	a0,s2
    1ab8:	00003097          	auipc	ra,0x3
    1abc:	9f0080e7          	jalr	-1552(ra) # 44a8 <kill>
  kill(pid3);
    1ac0:	8526                	mv	a0,s1
    1ac2:	00003097          	auipc	ra,0x3
    1ac6:	9e6080e7          	jalr	-1562(ra) # 44a8 <kill>
  printf("wait... ");
    1aca:	00004517          	auipc	a0,0x4
    1ace:	d4650513          	addi	a0,a0,-698 # 5810 <malloc+0xefa>
    1ad2:	00003097          	auipc	ra,0x3
    1ad6:	d2e080e7          	jalr	-722(ra) # 4800 <printf>
  wait(0);
    1ada:	4501                	li	a0,0
    1adc:	00003097          	auipc	ra,0x3
    1ae0:	9a4080e7          	jalr	-1628(ra) # 4480 <wait>
  wait(0);
    1ae4:	4501                	li	a0,0
    1ae6:	00003097          	auipc	ra,0x3
    1aea:	99a080e7          	jalr	-1638(ra) # 4480 <wait>
  wait(0);
    1aee:	4501                	li	a0,0
    1af0:	00003097          	auipc	ra,0x3
    1af4:	990080e7          	jalr	-1648(ra) # 4480 <wait>
    1af8:	b761                	j	1a80 <preempt+0x124>

0000000000001afa <reparent>:
{
    1afa:	7179                	addi	sp,sp,-48
    1afc:	f406                	sd	ra,40(sp)
    1afe:	f022                	sd	s0,32(sp)
    1b00:	ec26                	sd	s1,24(sp)
    1b02:	e84a                	sd	s2,16(sp)
    1b04:	e44e                	sd	s3,8(sp)
    1b06:	e052                	sd	s4,0(sp)
    1b08:	1800                	addi	s0,sp,48
    1b0a:	89aa                	mv	s3,a0
  int master_pid = getpid();
    1b0c:	00003097          	auipc	ra,0x3
    1b10:	9ec080e7          	jalr	-1556(ra) # 44f8 <getpid>
    1b14:	8a2a                	mv	s4,a0
    1b16:	0c800913          	li	s2,200
    int pid = fork();
    1b1a:	00003097          	auipc	ra,0x3
    1b1e:	956080e7          	jalr	-1706(ra) # 4470 <fork>
    1b22:	84aa                	mv	s1,a0
    if(pid < 0){
    1b24:	02054263          	bltz	a0,1b48 <reparent+0x4e>
    if(pid){
    1b28:	cd21                	beqz	a0,1b80 <reparent+0x86>
      if(wait(0) != pid){
    1b2a:	4501                	li	a0,0
    1b2c:	00003097          	auipc	ra,0x3
    1b30:	954080e7          	jalr	-1708(ra) # 4480 <wait>
    1b34:	02951863          	bne	a0,s1,1b64 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    1b38:	397d                	addiw	s2,s2,-1
    1b3a:	fe0910e3          	bnez	s2,1b1a <reparent+0x20>
  exit(0);
    1b3e:	4501                	li	a0,0
    1b40:	00003097          	auipc	ra,0x3
    1b44:	938080e7          	jalr	-1736(ra) # 4478 <exit>
      printf("%s: fork failed\n", s);
    1b48:	85ce                	mv	a1,s3
    1b4a:	00003517          	auipc	a0,0x3
    1b4e:	2ce50513          	addi	a0,a0,718 # 4e18 <malloc+0x502>
    1b52:	00003097          	auipc	ra,0x3
    1b56:	cae080e7          	jalr	-850(ra) # 4800 <printf>
      exit(1);
    1b5a:	4505                	li	a0,1
    1b5c:	00003097          	auipc	ra,0x3
    1b60:	91c080e7          	jalr	-1764(ra) # 4478 <exit>
        printf("%s: wait wrong pid\n", s);
    1b64:	85ce                	mv	a1,s3
    1b66:	00003517          	auipc	a0,0x3
    1b6a:	2e250513          	addi	a0,a0,738 # 4e48 <malloc+0x532>
    1b6e:	00003097          	auipc	ra,0x3
    1b72:	c92080e7          	jalr	-878(ra) # 4800 <printf>
        exit(1);
    1b76:	4505                	li	a0,1
    1b78:	00003097          	auipc	ra,0x3
    1b7c:	900080e7          	jalr	-1792(ra) # 4478 <exit>
      int pid2 = fork();
    1b80:	00003097          	auipc	ra,0x3
    1b84:	8f0080e7          	jalr	-1808(ra) # 4470 <fork>
      if(pid2 < 0){
    1b88:	00054763          	bltz	a0,1b96 <reparent+0x9c>
      exit(0);
    1b8c:	4501                	li	a0,0
    1b8e:	00003097          	auipc	ra,0x3
    1b92:	8ea080e7          	jalr	-1814(ra) # 4478 <exit>
        kill(master_pid);
    1b96:	8552                	mv	a0,s4
    1b98:	00003097          	auipc	ra,0x3
    1b9c:	910080e7          	jalr	-1776(ra) # 44a8 <kill>
        exit(1);
    1ba0:	4505                	li	a0,1
    1ba2:	00003097          	auipc	ra,0x3
    1ba6:	8d6080e7          	jalr	-1834(ra) # 4478 <exit>

0000000000001baa <mem>:
{
    1baa:	7139                	addi	sp,sp,-64
    1bac:	fc06                	sd	ra,56(sp)
    1bae:	f822                	sd	s0,48(sp)
    1bb0:	f426                	sd	s1,40(sp)
    1bb2:	f04a                	sd	s2,32(sp)
    1bb4:	ec4e                	sd	s3,24(sp)
    1bb6:	0080                	addi	s0,sp,64
    1bb8:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    1bba:	00003097          	auipc	ra,0x3
    1bbe:	8b6080e7          	jalr	-1866(ra) # 4470 <fork>
    m1 = 0;
    1bc2:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    1bc4:	6909                	lui	s2,0x2
    1bc6:	71190913          	addi	s2,s2,1809 # 2711 <concreate+0x2b1>
  if((pid = fork()) == 0){
    1bca:	ed39                	bnez	a0,1c28 <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    1bcc:	854a                	mv	a0,s2
    1bce:	00003097          	auipc	ra,0x3
    1bd2:	d48080e7          	jalr	-696(ra) # 4916 <malloc>
    1bd6:	c501                	beqz	a0,1bde <mem+0x34>
      *(char**)m2 = m1;
    1bd8:	e104                	sd	s1,0(a0)
      m1 = m2;
    1bda:	84aa                	mv	s1,a0
    1bdc:	bfc5                	j	1bcc <mem+0x22>
    while(m1){
    1bde:	c881                	beqz	s1,1bee <mem+0x44>
      m2 = *(char**)m1;
    1be0:	8526                	mv	a0,s1
    1be2:	6084                	ld	s1,0(s1)
      free(m1);
    1be4:	00003097          	auipc	ra,0x3
    1be8:	caa080e7          	jalr	-854(ra) # 488e <free>
    while(m1){
    1bec:	f8f5                	bnez	s1,1be0 <mem+0x36>
    m1 = malloc(1024*20);
    1bee:	6515                	lui	a0,0x5
    1bf0:	00003097          	auipc	ra,0x3
    1bf4:	d26080e7          	jalr	-730(ra) # 4916 <malloc>
    if(m1 == 0){
    1bf8:	c911                	beqz	a0,1c0c <mem+0x62>
    free(m1);
    1bfa:	00003097          	auipc	ra,0x3
    1bfe:	c94080e7          	jalr	-876(ra) # 488e <free>
    exit(0);
    1c02:	4501                	li	a0,0
    1c04:	00003097          	auipc	ra,0x3
    1c08:	874080e7          	jalr	-1932(ra) # 4478 <exit>
      printf("couldn't allocate mem?!!\n", s);
    1c0c:	85ce                	mv	a1,s3
    1c0e:	00004517          	auipc	a0,0x4
    1c12:	c1250513          	addi	a0,a0,-1006 # 5820 <malloc+0xf0a>
    1c16:	00003097          	auipc	ra,0x3
    1c1a:	bea080e7          	jalr	-1046(ra) # 4800 <printf>
      exit(1);
    1c1e:	4505                	li	a0,1
    1c20:	00003097          	auipc	ra,0x3
    1c24:	858080e7          	jalr	-1960(ra) # 4478 <exit>
    wait(&xstatus);
    1c28:	fcc40513          	addi	a0,s0,-52
    1c2c:	00003097          	auipc	ra,0x3
    1c30:	854080e7          	jalr	-1964(ra) # 4480 <wait>
    exit(xstatus);
    1c34:	fcc42503          	lw	a0,-52(s0)
    1c38:	00003097          	auipc	ra,0x3
    1c3c:	840080e7          	jalr	-1984(ra) # 4478 <exit>

0000000000001c40 <sharedfd>:
{
    1c40:	7159                	addi	sp,sp,-112
    1c42:	f486                	sd	ra,104(sp)
    1c44:	f0a2                	sd	s0,96(sp)
    1c46:	eca6                	sd	s1,88(sp)
    1c48:	e8ca                	sd	s2,80(sp)
    1c4a:	e4ce                	sd	s3,72(sp)
    1c4c:	e0d2                	sd	s4,64(sp)
    1c4e:	fc56                	sd	s5,56(sp)
    1c50:	f85a                	sd	s6,48(sp)
    1c52:	f45e                	sd	s7,40(sp)
    1c54:	1880                	addi	s0,sp,112
    1c56:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    1c58:	00003517          	auipc	a0,0x3
    1c5c:	eb050513          	addi	a0,a0,-336 # 4b08 <malloc+0x1f2>
    1c60:	00003097          	auipc	ra,0x3
    1c64:	868080e7          	jalr	-1944(ra) # 44c8 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    1c68:	20200593          	li	a1,514
    1c6c:	00003517          	auipc	a0,0x3
    1c70:	e9c50513          	addi	a0,a0,-356 # 4b08 <malloc+0x1f2>
    1c74:	00003097          	auipc	ra,0x3
    1c78:	844080e7          	jalr	-1980(ra) # 44b8 <open>
  if(fd < 0){
    1c7c:	04054a63          	bltz	a0,1cd0 <sharedfd+0x90>
    1c80:	892a                	mv	s2,a0
  pid = fork();
    1c82:	00002097          	auipc	ra,0x2
    1c86:	7ee080e7          	jalr	2030(ra) # 4470 <fork>
    1c8a:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    1c8c:	06300593          	li	a1,99
    1c90:	c119                	beqz	a0,1c96 <sharedfd+0x56>
    1c92:	07000593          	li	a1,112
    1c96:	4629                	li	a2,10
    1c98:	fa040513          	addi	a0,s0,-96
    1c9c:	00002097          	auipc	ra,0x2
    1ca0:	588080e7          	jalr	1416(ra) # 4224 <memset>
    1ca4:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    1ca8:	4629                	li	a2,10
    1caa:	fa040593          	addi	a1,s0,-96
    1cae:	854a                	mv	a0,s2
    1cb0:	00002097          	auipc	ra,0x2
    1cb4:	7e8080e7          	jalr	2024(ra) # 4498 <write>
    1cb8:	47a9                	li	a5,10
    1cba:	02f51963          	bne	a0,a5,1cec <sharedfd+0xac>
  for(i = 0; i < N; i++){
    1cbe:	34fd                	addiw	s1,s1,-1
    1cc0:	f4e5                	bnez	s1,1ca8 <sharedfd+0x68>
  if(pid == 0) {
    1cc2:	04099363          	bnez	s3,1d08 <sharedfd+0xc8>
    exit(0);
    1cc6:	4501                	li	a0,0
    1cc8:	00002097          	auipc	ra,0x2
    1ccc:	7b0080e7          	jalr	1968(ra) # 4478 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    1cd0:	85d2                	mv	a1,s4
    1cd2:	00004517          	auipc	a0,0x4
    1cd6:	b6e50513          	addi	a0,a0,-1170 # 5840 <malloc+0xf2a>
    1cda:	00003097          	auipc	ra,0x3
    1cde:	b26080e7          	jalr	-1242(ra) # 4800 <printf>
    exit(1);
    1ce2:	4505                	li	a0,1
    1ce4:	00002097          	auipc	ra,0x2
    1ce8:	794080e7          	jalr	1940(ra) # 4478 <exit>
      printf("%s: write sharedfd failed\n", s);
    1cec:	85d2                	mv	a1,s4
    1cee:	00004517          	auipc	a0,0x4
    1cf2:	b7a50513          	addi	a0,a0,-1158 # 5868 <malloc+0xf52>
    1cf6:	00003097          	auipc	ra,0x3
    1cfa:	b0a080e7          	jalr	-1270(ra) # 4800 <printf>
      exit(1);
    1cfe:	4505                	li	a0,1
    1d00:	00002097          	auipc	ra,0x2
    1d04:	778080e7          	jalr	1912(ra) # 4478 <exit>
    wait(&xstatus);
    1d08:	f9c40513          	addi	a0,s0,-100
    1d0c:	00002097          	auipc	ra,0x2
    1d10:	774080e7          	jalr	1908(ra) # 4480 <wait>
    if(xstatus != 0)
    1d14:	f9c42983          	lw	s3,-100(s0)
    1d18:	00098763          	beqz	s3,1d26 <sharedfd+0xe6>
      exit(xstatus);
    1d1c:	854e                	mv	a0,s3
    1d1e:	00002097          	auipc	ra,0x2
    1d22:	75a080e7          	jalr	1882(ra) # 4478 <exit>
  close(fd);
    1d26:	854a                	mv	a0,s2
    1d28:	00002097          	auipc	ra,0x2
    1d2c:	778080e7          	jalr	1912(ra) # 44a0 <close>
  fd = open("sharedfd", 0);
    1d30:	4581                	li	a1,0
    1d32:	00003517          	auipc	a0,0x3
    1d36:	dd650513          	addi	a0,a0,-554 # 4b08 <malloc+0x1f2>
    1d3a:	00002097          	auipc	ra,0x2
    1d3e:	77e080e7          	jalr	1918(ra) # 44b8 <open>
    1d42:	8baa                	mv	s7,a0
  nc = np = 0;
    1d44:	8ace                	mv	s5,s3
  if(fd < 0){
    1d46:	02054563          	bltz	a0,1d70 <sharedfd+0x130>
    1d4a:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    1d4e:	06300493          	li	s1,99
      if(buf[i] == 'p')
    1d52:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1d56:	4629                	li	a2,10
    1d58:	fa040593          	addi	a1,s0,-96
    1d5c:	855e                	mv	a0,s7
    1d5e:	00002097          	auipc	ra,0x2
    1d62:	732080e7          	jalr	1842(ra) # 4490 <read>
    1d66:	02a05f63          	blez	a0,1da4 <sharedfd+0x164>
    1d6a:	fa040793          	addi	a5,s0,-96
    1d6e:	a01d                	j	1d94 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    1d70:	85d2                	mv	a1,s4
    1d72:	00004517          	auipc	a0,0x4
    1d76:	b1650513          	addi	a0,a0,-1258 # 5888 <malloc+0xf72>
    1d7a:	00003097          	auipc	ra,0x3
    1d7e:	a86080e7          	jalr	-1402(ra) # 4800 <printf>
    exit(1);
    1d82:	4505                	li	a0,1
    1d84:	00002097          	auipc	ra,0x2
    1d88:	6f4080e7          	jalr	1780(ra) # 4478 <exit>
        nc++;
    1d8c:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    1d8e:	0785                	addi	a5,a5,1
    1d90:	fd2783e3          	beq	a5,s2,1d56 <sharedfd+0x116>
      if(buf[i] == 'c')
    1d94:	0007c703          	lbu	a4,0(a5)
    1d98:	fe970ae3          	beq	a4,s1,1d8c <sharedfd+0x14c>
      if(buf[i] == 'p')
    1d9c:	ff6719e3          	bne	a4,s6,1d8e <sharedfd+0x14e>
        np++;
    1da0:	2a85                	addiw	s5,s5,1
    1da2:	b7f5                	j	1d8e <sharedfd+0x14e>
  close(fd);
    1da4:	855e                	mv	a0,s7
    1da6:	00002097          	auipc	ra,0x2
    1daa:	6fa080e7          	jalr	1786(ra) # 44a0 <close>
  unlink("sharedfd");
    1dae:	00003517          	auipc	a0,0x3
    1db2:	d5a50513          	addi	a0,a0,-678 # 4b08 <malloc+0x1f2>
    1db6:	00002097          	auipc	ra,0x2
    1dba:	712080e7          	jalr	1810(ra) # 44c8 <unlink>
  if(nc == N*SZ && np == N*SZ){
    1dbe:	6789                	lui	a5,0x2
    1dc0:	71078793          	addi	a5,a5,1808 # 2710 <concreate+0x2b0>
    1dc4:	00f99763          	bne	s3,a5,1dd2 <sharedfd+0x192>
    1dc8:	6789                	lui	a5,0x2
    1dca:	71078793          	addi	a5,a5,1808 # 2710 <concreate+0x2b0>
    1dce:	02fa8063          	beq	s5,a5,1dee <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    1dd2:	85d2                	mv	a1,s4
    1dd4:	00004517          	auipc	a0,0x4
    1dd8:	adc50513          	addi	a0,a0,-1316 # 58b0 <malloc+0xf9a>
    1ddc:	00003097          	auipc	ra,0x3
    1de0:	a24080e7          	jalr	-1500(ra) # 4800 <printf>
    exit(1);
    1de4:	4505                	li	a0,1
    1de6:	00002097          	auipc	ra,0x2
    1dea:	692080e7          	jalr	1682(ra) # 4478 <exit>
    exit(0);
    1dee:	4501                	li	a0,0
    1df0:	00002097          	auipc	ra,0x2
    1df4:	688080e7          	jalr	1672(ra) # 4478 <exit>

0000000000001df8 <fourfiles>:
{
    1df8:	7171                	addi	sp,sp,-176
    1dfa:	f506                	sd	ra,168(sp)
    1dfc:	f122                	sd	s0,160(sp)
    1dfe:	ed26                	sd	s1,152(sp)
    1e00:	e94a                	sd	s2,144(sp)
    1e02:	e54e                	sd	s3,136(sp)
    1e04:	e152                	sd	s4,128(sp)
    1e06:	fcd6                	sd	s5,120(sp)
    1e08:	f8da                	sd	s6,112(sp)
    1e0a:	f4de                	sd	s7,104(sp)
    1e0c:	f0e2                	sd	s8,96(sp)
    1e0e:	ece6                	sd	s9,88(sp)
    1e10:	e8ea                	sd	s10,80(sp)
    1e12:	e4ee                	sd	s11,72(sp)
    1e14:	1900                	addi	s0,sp,176
    1e16:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    1e18:	00003797          	auipc	a5,0x3
    1e1c:	be878793          	addi	a5,a5,-1048 # 4a00 <malloc+0xea>
    1e20:	f6f43823          	sd	a5,-144(s0)
    1e24:	00003797          	auipc	a5,0x3
    1e28:	be478793          	addi	a5,a5,-1052 # 4a08 <malloc+0xf2>
    1e2c:	f6f43c23          	sd	a5,-136(s0)
    1e30:	00003797          	auipc	a5,0x3
    1e34:	be078793          	addi	a5,a5,-1056 # 4a10 <malloc+0xfa>
    1e38:	f8f43023          	sd	a5,-128(s0)
    1e3c:	00003797          	auipc	a5,0x3
    1e40:	bdc78793          	addi	a5,a5,-1060 # 4a18 <malloc+0x102>
    1e44:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    1e48:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    1e4c:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    1e4e:	4481                	li	s1,0
    1e50:	4a11                	li	s4,4
    fname = names[pi];
    1e52:	00093983          	ld	s3,0(s2)
    unlink(fname);
    1e56:	854e                	mv	a0,s3
    1e58:	00002097          	auipc	ra,0x2
    1e5c:	670080e7          	jalr	1648(ra) # 44c8 <unlink>
    pid = fork();
    1e60:	00002097          	auipc	ra,0x2
    1e64:	610080e7          	jalr	1552(ra) # 4470 <fork>
    if(pid < 0){
    1e68:	04054563          	bltz	a0,1eb2 <fourfiles+0xba>
    if(pid == 0){
    1e6c:	c12d                	beqz	a0,1ece <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    1e6e:	2485                	addiw	s1,s1,1
    1e70:	0921                	addi	s2,s2,8
    1e72:	ff4490e3          	bne	s1,s4,1e52 <fourfiles+0x5a>
    1e76:	4491                	li	s1,4
    wait(&xstatus);
    1e78:	f6c40513          	addi	a0,s0,-148
    1e7c:	00002097          	auipc	ra,0x2
    1e80:	604080e7          	jalr	1540(ra) # 4480 <wait>
    if(xstatus != 0)
    1e84:	f6c42503          	lw	a0,-148(s0)
    1e88:	ed69                	bnez	a0,1f62 <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    1e8a:	34fd                	addiw	s1,s1,-1
    1e8c:	f4f5                	bnez	s1,1e78 <fourfiles+0x80>
    1e8e:	03000b13          	li	s6,48
    total = 0;
    1e92:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1e96:	00007a17          	auipc	s4,0x7
    1e9a:	44aa0a13          	addi	s4,s4,1098 # 92e0 <buf>
    1e9e:	00007a97          	auipc	s5,0x7
    1ea2:	443a8a93          	addi	s5,s5,1091 # 92e1 <buf+0x1>
    if(total != N*SZ){
    1ea6:	6d05                	lui	s10,0x1
    1ea8:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x18>
  for(i = 0; i < NCHILD; i++){
    1eac:	03400d93          	li	s11,52
    1eb0:	a23d                	j	1fde <fourfiles+0x1e6>
      printf("fork failed\n", s);
    1eb2:	85e6                	mv	a1,s9
    1eb4:	00004517          	auipc	a0,0x4
    1eb8:	86450513          	addi	a0,a0,-1948 # 5718 <malloc+0xe02>
    1ebc:	00003097          	auipc	ra,0x3
    1ec0:	944080e7          	jalr	-1724(ra) # 4800 <printf>
      exit(1);
    1ec4:	4505                	li	a0,1
    1ec6:	00002097          	auipc	ra,0x2
    1eca:	5b2080e7          	jalr	1458(ra) # 4478 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    1ece:	20200593          	li	a1,514
    1ed2:	854e                	mv	a0,s3
    1ed4:	00002097          	auipc	ra,0x2
    1ed8:	5e4080e7          	jalr	1508(ra) # 44b8 <open>
    1edc:	892a                	mv	s2,a0
      if(fd < 0){
    1ede:	04054763          	bltz	a0,1f2c <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    1ee2:	1f400613          	li	a2,500
    1ee6:	0304859b          	addiw	a1,s1,48
    1eea:	00007517          	auipc	a0,0x7
    1eee:	3f650513          	addi	a0,a0,1014 # 92e0 <buf>
    1ef2:	00002097          	auipc	ra,0x2
    1ef6:	332080e7          	jalr	818(ra) # 4224 <memset>
    1efa:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    1efc:	00007997          	auipc	s3,0x7
    1f00:	3e498993          	addi	s3,s3,996 # 92e0 <buf>
    1f04:	1f400613          	li	a2,500
    1f08:	85ce                	mv	a1,s3
    1f0a:	854a                	mv	a0,s2
    1f0c:	00002097          	auipc	ra,0x2
    1f10:	58c080e7          	jalr	1420(ra) # 4498 <write>
    1f14:	85aa                	mv	a1,a0
    1f16:	1f400793          	li	a5,500
    1f1a:	02f51763          	bne	a0,a5,1f48 <fourfiles+0x150>
      for(i = 0; i < N; i++){
    1f1e:	34fd                	addiw	s1,s1,-1
    1f20:	f0f5                	bnez	s1,1f04 <fourfiles+0x10c>
      exit(0);
    1f22:	4501                	li	a0,0
    1f24:	00002097          	auipc	ra,0x2
    1f28:	554080e7          	jalr	1364(ra) # 4478 <exit>
        printf("create failed\n", s);
    1f2c:	85e6                	mv	a1,s9
    1f2e:	00004517          	auipc	a0,0x4
    1f32:	99a50513          	addi	a0,a0,-1638 # 58c8 <malloc+0xfb2>
    1f36:	00003097          	auipc	ra,0x3
    1f3a:	8ca080e7          	jalr	-1846(ra) # 4800 <printf>
        exit(1);
    1f3e:	4505                	li	a0,1
    1f40:	00002097          	auipc	ra,0x2
    1f44:	538080e7          	jalr	1336(ra) # 4478 <exit>
          printf("write failed %d\n", n);
    1f48:	00004517          	auipc	a0,0x4
    1f4c:	99050513          	addi	a0,a0,-1648 # 58d8 <malloc+0xfc2>
    1f50:	00003097          	auipc	ra,0x3
    1f54:	8b0080e7          	jalr	-1872(ra) # 4800 <printf>
          exit(1);
    1f58:	4505                	li	a0,1
    1f5a:	00002097          	auipc	ra,0x2
    1f5e:	51e080e7          	jalr	1310(ra) # 4478 <exit>
      exit(xstatus);
    1f62:	00002097          	auipc	ra,0x2
    1f66:	516080e7          	jalr	1302(ra) # 4478 <exit>
          printf("wrong char\n", s);
    1f6a:	85e6                	mv	a1,s9
    1f6c:	00004517          	auipc	a0,0x4
    1f70:	98450513          	addi	a0,a0,-1660 # 58f0 <malloc+0xfda>
    1f74:	00003097          	auipc	ra,0x3
    1f78:	88c080e7          	jalr	-1908(ra) # 4800 <printf>
          exit(1);
    1f7c:	4505                	li	a0,1
    1f7e:	00002097          	auipc	ra,0x2
    1f82:	4fa080e7          	jalr	1274(ra) # 4478 <exit>
      total += n;
    1f86:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1f8a:	660d                	lui	a2,0x3
    1f8c:	85d2                	mv	a1,s4
    1f8e:	854e                	mv	a0,s3
    1f90:	00002097          	auipc	ra,0x2
    1f94:	500080e7          	jalr	1280(ra) # 4490 <read>
    1f98:	02a05363          	blez	a0,1fbe <fourfiles+0x1c6>
    1f9c:	00007797          	auipc	a5,0x7
    1fa0:	34478793          	addi	a5,a5,836 # 92e0 <buf>
    1fa4:	fff5069b          	addiw	a3,a0,-1
    1fa8:	1682                	slli	a3,a3,0x20
    1faa:	9281                	srli	a3,a3,0x20
    1fac:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    1fae:	0007c703          	lbu	a4,0(a5)
    1fb2:	fa971ce3          	bne	a4,s1,1f6a <fourfiles+0x172>
      for(j = 0; j < n; j++){
    1fb6:	0785                	addi	a5,a5,1
    1fb8:	fed79be3          	bne	a5,a3,1fae <fourfiles+0x1b6>
    1fbc:	b7e9                	j	1f86 <fourfiles+0x18e>
    close(fd);
    1fbe:	854e                	mv	a0,s3
    1fc0:	00002097          	auipc	ra,0x2
    1fc4:	4e0080e7          	jalr	1248(ra) # 44a0 <close>
    if(total != N*SZ){
    1fc8:	03a91963          	bne	s2,s10,1ffa <fourfiles+0x202>
    unlink(fname);
    1fcc:	8562                	mv	a0,s8
    1fce:	00002097          	auipc	ra,0x2
    1fd2:	4fa080e7          	jalr	1274(ra) # 44c8 <unlink>
  for(i = 0; i < NCHILD; i++){
    1fd6:	0ba1                	addi	s7,s7,8
    1fd8:	2b05                	addiw	s6,s6,1
    1fda:	03bb0e63          	beq	s6,s11,2016 <fourfiles+0x21e>
    fname = names[i];
    1fde:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    1fe2:	4581                	li	a1,0
    1fe4:	8562                	mv	a0,s8
    1fe6:	00002097          	auipc	ra,0x2
    1fea:	4d2080e7          	jalr	1234(ra) # 44b8 <open>
    1fee:	89aa                	mv	s3,a0
    total = 0;
    1ff0:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    1ff4:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1ff8:	bf49                	j	1f8a <fourfiles+0x192>
      printf("wrong length %d\n", total);
    1ffa:	85ca                	mv	a1,s2
    1ffc:	00004517          	auipc	a0,0x4
    2000:	90450513          	addi	a0,a0,-1788 # 5900 <malloc+0xfea>
    2004:	00002097          	auipc	ra,0x2
    2008:	7fc080e7          	jalr	2044(ra) # 4800 <printf>
      exit(1);
    200c:	4505                	li	a0,1
    200e:	00002097          	auipc	ra,0x2
    2012:	46a080e7          	jalr	1130(ra) # 4478 <exit>
}
    2016:	70aa                	ld	ra,168(sp)
    2018:	740a                	ld	s0,160(sp)
    201a:	64ea                	ld	s1,152(sp)
    201c:	694a                	ld	s2,144(sp)
    201e:	69aa                	ld	s3,136(sp)
    2020:	6a0a                	ld	s4,128(sp)
    2022:	7ae6                	ld	s5,120(sp)
    2024:	7b46                	ld	s6,112(sp)
    2026:	7ba6                	ld	s7,104(sp)
    2028:	7c06                	ld	s8,96(sp)
    202a:	6ce6                	ld	s9,88(sp)
    202c:	6d46                	ld	s10,80(sp)
    202e:	6da6                	ld	s11,72(sp)
    2030:	614d                	addi	sp,sp,176
    2032:	8082                	ret

0000000000002034 <bigfile>:
{
    2034:	7139                	addi	sp,sp,-64
    2036:	fc06                	sd	ra,56(sp)
    2038:	f822                	sd	s0,48(sp)
    203a:	f426                	sd	s1,40(sp)
    203c:	f04a                	sd	s2,32(sp)
    203e:	ec4e                	sd	s3,24(sp)
    2040:	e852                	sd	s4,16(sp)
    2042:	e456                	sd	s5,8(sp)
    2044:	0080                	addi	s0,sp,64
    2046:	8aaa                	mv	s5,a0
  unlink("bigfile");
    2048:	00003517          	auipc	a0,0x3
    204c:	c1050513          	addi	a0,a0,-1008 # 4c58 <malloc+0x342>
    2050:	00002097          	auipc	ra,0x2
    2054:	478080e7          	jalr	1144(ra) # 44c8 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2058:	20200593          	li	a1,514
    205c:	00003517          	auipc	a0,0x3
    2060:	bfc50513          	addi	a0,a0,-1028 # 4c58 <malloc+0x342>
    2064:	00002097          	auipc	ra,0x2
    2068:	454080e7          	jalr	1108(ra) # 44b8 <open>
    206c:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    206e:	4481                	li	s1,0
    memset(buf, i, SZ);
    2070:	00007917          	auipc	s2,0x7
    2074:	27090913          	addi	s2,s2,624 # 92e0 <buf>
  for(i = 0; i < N; i++){
    2078:	4a51                	li	s4,20
  if(fd < 0){
    207a:	0a054063          	bltz	a0,211a <bigfile+0xe6>
    memset(buf, i, SZ);
    207e:	25800613          	li	a2,600
    2082:	85a6                	mv	a1,s1
    2084:	854a                	mv	a0,s2
    2086:	00002097          	auipc	ra,0x2
    208a:	19e080e7          	jalr	414(ra) # 4224 <memset>
    if(write(fd, buf, SZ) != SZ){
    208e:	25800613          	li	a2,600
    2092:	85ca                	mv	a1,s2
    2094:	854e                	mv	a0,s3
    2096:	00002097          	auipc	ra,0x2
    209a:	402080e7          	jalr	1026(ra) # 4498 <write>
    209e:	25800793          	li	a5,600
    20a2:	08f51a63          	bne	a0,a5,2136 <bigfile+0x102>
  for(i = 0; i < N; i++){
    20a6:	2485                	addiw	s1,s1,1
    20a8:	fd449be3          	bne	s1,s4,207e <bigfile+0x4a>
  close(fd);
    20ac:	854e                	mv	a0,s3
    20ae:	00002097          	auipc	ra,0x2
    20b2:	3f2080e7          	jalr	1010(ra) # 44a0 <close>
  fd = open("bigfile", 0);
    20b6:	4581                	li	a1,0
    20b8:	00003517          	auipc	a0,0x3
    20bc:	ba050513          	addi	a0,a0,-1120 # 4c58 <malloc+0x342>
    20c0:	00002097          	auipc	ra,0x2
    20c4:	3f8080e7          	jalr	1016(ra) # 44b8 <open>
    20c8:	8a2a                	mv	s4,a0
  total = 0;
    20ca:	4981                	li	s3,0
  for(i = 0; ; i++){
    20cc:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    20ce:	00007917          	auipc	s2,0x7
    20d2:	21290913          	addi	s2,s2,530 # 92e0 <buf>
  if(fd < 0){
    20d6:	06054e63          	bltz	a0,2152 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    20da:	12c00613          	li	a2,300
    20de:	85ca                	mv	a1,s2
    20e0:	8552                	mv	a0,s4
    20e2:	00002097          	auipc	ra,0x2
    20e6:	3ae080e7          	jalr	942(ra) # 4490 <read>
    if(cc < 0){
    20ea:	08054263          	bltz	a0,216e <bigfile+0x13a>
    if(cc == 0)
    20ee:	c971                	beqz	a0,21c2 <bigfile+0x18e>
    if(cc != SZ/2){
    20f0:	12c00793          	li	a5,300
    20f4:	08f51b63          	bne	a0,a5,218a <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    20f8:	01f4d79b          	srliw	a5,s1,0x1f
    20fc:	9fa5                	addw	a5,a5,s1
    20fe:	4017d79b          	sraiw	a5,a5,0x1
    2102:	00094703          	lbu	a4,0(s2)
    2106:	0af71063          	bne	a4,a5,21a6 <bigfile+0x172>
    210a:	12b94703          	lbu	a4,299(s2)
    210e:	08f71c63          	bne	a4,a5,21a6 <bigfile+0x172>
    total += cc;
    2112:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    2116:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    2118:	b7c9                	j	20da <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    211a:	85d6                	mv	a1,s5
    211c:	00003517          	auipc	a0,0x3
    2120:	7fc50513          	addi	a0,a0,2044 # 5918 <malloc+0x1002>
    2124:	00002097          	auipc	ra,0x2
    2128:	6dc080e7          	jalr	1756(ra) # 4800 <printf>
    exit(1);
    212c:	4505                	li	a0,1
    212e:	00002097          	auipc	ra,0x2
    2132:	34a080e7          	jalr	842(ra) # 4478 <exit>
      printf("%s: write bigfile failed\n", s);
    2136:	85d6                	mv	a1,s5
    2138:	00004517          	auipc	a0,0x4
    213c:	80050513          	addi	a0,a0,-2048 # 5938 <malloc+0x1022>
    2140:	00002097          	auipc	ra,0x2
    2144:	6c0080e7          	jalr	1728(ra) # 4800 <printf>
      exit(1);
    2148:	4505                	li	a0,1
    214a:	00002097          	auipc	ra,0x2
    214e:	32e080e7          	jalr	814(ra) # 4478 <exit>
    printf("%s: cannot open bigfile\n", s);
    2152:	85d6                	mv	a1,s5
    2154:	00004517          	auipc	a0,0x4
    2158:	80450513          	addi	a0,a0,-2044 # 5958 <malloc+0x1042>
    215c:	00002097          	auipc	ra,0x2
    2160:	6a4080e7          	jalr	1700(ra) # 4800 <printf>
    exit(1);
    2164:	4505                	li	a0,1
    2166:	00002097          	auipc	ra,0x2
    216a:	312080e7          	jalr	786(ra) # 4478 <exit>
      printf("%s: read bigfile failed\n", s);
    216e:	85d6                	mv	a1,s5
    2170:	00004517          	auipc	a0,0x4
    2174:	80850513          	addi	a0,a0,-2040 # 5978 <malloc+0x1062>
    2178:	00002097          	auipc	ra,0x2
    217c:	688080e7          	jalr	1672(ra) # 4800 <printf>
      exit(1);
    2180:	4505                	li	a0,1
    2182:	00002097          	auipc	ra,0x2
    2186:	2f6080e7          	jalr	758(ra) # 4478 <exit>
      printf("%s: short read bigfile\n", s);
    218a:	85d6                	mv	a1,s5
    218c:	00004517          	auipc	a0,0x4
    2190:	80c50513          	addi	a0,a0,-2036 # 5998 <malloc+0x1082>
    2194:	00002097          	auipc	ra,0x2
    2198:	66c080e7          	jalr	1644(ra) # 4800 <printf>
      exit(1);
    219c:	4505                	li	a0,1
    219e:	00002097          	auipc	ra,0x2
    21a2:	2da080e7          	jalr	730(ra) # 4478 <exit>
      printf("%s: read bigfile wrong data\n", s);
    21a6:	85d6                	mv	a1,s5
    21a8:	00004517          	auipc	a0,0x4
    21ac:	80850513          	addi	a0,a0,-2040 # 59b0 <malloc+0x109a>
    21b0:	00002097          	auipc	ra,0x2
    21b4:	650080e7          	jalr	1616(ra) # 4800 <printf>
      exit(1);
    21b8:	4505                	li	a0,1
    21ba:	00002097          	auipc	ra,0x2
    21be:	2be080e7          	jalr	702(ra) # 4478 <exit>
  close(fd);
    21c2:	8552                	mv	a0,s4
    21c4:	00002097          	auipc	ra,0x2
    21c8:	2dc080e7          	jalr	732(ra) # 44a0 <close>
  if(total != N*SZ){
    21cc:	678d                	lui	a5,0x3
    21ce:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x508>
    21d2:	02f99363          	bne	s3,a5,21f8 <bigfile+0x1c4>
  unlink("bigfile");
    21d6:	00003517          	auipc	a0,0x3
    21da:	a8250513          	addi	a0,a0,-1406 # 4c58 <malloc+0x342>
    21de:	00002097          	auipc	ra,0x2
    21e2:	2ea080e7          	jalr	746(ra) # 44c8 <unlink>
}
    21e6:	70e2                	ld	ra,56(sp)
    21e8:	7442                	ld	s0,48(sp)
    21ea:	74a2                	ld	s1,40(sp)
    21ec:	7902                	ld	s2,32(sp)
    21ee:	69e2                	ld	s3,24(sp)
    21f0:	6a42                	ld	s4,16(sp)
    21f2:	6aa2                	ld	s5,8(sp)
    21f4:	6121                	addi	sp,sp,64
    21f6:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    21f8:	85d6                	mv	a1,s5
    21fa:	00003517          	auipc	a0,0x3
    21fe:	7d650513          	addi	a0,a0,2006 # 59d0 <malloc+0x10ba>
    2202:	00002097          	auipc	ra,0x2
    2206:	5fe080e7          	jalr	1534(ra) # 4800 <printf>
    exit(1);
    220a:	4505                	li	a0,1
    220c:	00002097          	auipc	ra,0x2
    2210:	26c080e7          	jalr	620(ra) # 4478 <exit>

0000000000002214 <linktest>:
{
    2214:	1101                	addi	sp,sp,-32
    2216:	ec06                	sd	ra,24(sp)
    2218:	e822                	sd	s0,16(sp)
    221a:	e426                	sd	s1,8(sp)
    221c:	e04a                	sd	s2,0(sp)
    221e:	1000                	addi	s0,sp,32
    2220:	892a                	mv	s2,a0
  unlink("lf1");
    2222:	00003517          	auipc	a0,0x3
    2226:	7ce50513          	addi	a0,a0,1998 # 59f0 <malloc+0x10da>
    222a:	00002097          	auipc	ra,0x2
    222e:	29e080e7          	jalr	670(ra) # 44c8 <unlink>
  unlink("lf2");
    2232:	00003517          	auipc	a0,0x3
    2236:	7c650513          	addi	a0,a0,1990 # 59f8 <malloc+0x10e2>
    223a:	00002097          	auipc	ra,0x2
    223e:	28e080e7          	jalr	654(ra) # 44c8 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    2242:	20200593          	li	a1,514
    2246:	00003517          	auipc	a0,0x3
    224a:	7aa50513          	addi	a0,a0,1962 # 59f0 <malloc+0x10da>
    224e:	00002097          	auipc	ra,0x2
    2252:	26a080e7          	jalr	618(ra) # 44b8 <open>
  if(fd < 0){
    2256:	10054763          	bltz	a0,2364 <linktest+0x150>
    225a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
    225c:	4615                	li	a2,5
    225e:	00003597          	auipc	a1,0x3
    2262:	28a58593          	addi	a1,a1,650 # 54e8 <malloc+0xbd2>
    2266:	00002097          	auipc	ra,0x2
    226a:	232080e7          	jalr	562(ra) # 4498 <write>
    226e:	4795                	li	a5,5
    2270:	10f51863          	bne	a0,a5,2380 <linktest+0x16c>
  close(fd);
    2274:	8526                	mv	a0,s1
    2276:	00002097          	auipc	ra,0x2
    227a:	22a080e7          	jalr	554(ra) # 44a0 <close>
  if(link("lf1", "lf2") < 0){
    227e:	00003597          	auipc	a1,0x3
    2282:	77a58593          	addi	a1,a1,1914 # 59f8 <malloc+0x10e2>
    2286:	00003517          	auipc	a0,0x3
    228a:	76a50513          	addi	a0,a0,1898 # 59f0 <malloc+0x10da>
    228e:	00002097          	auipc	ra,0x2
    2292:	24a080e7          	jalr	586(ra) # 44d8 <link>
    2296:	10054363          	bltz	a0,239c <linktest+0x188>
  unlink("lf1");
    229a:	00003517          	auipc	a0,0x3
    229e:	75650513          	addi	a0,a0,1878 # 59f0 <malloc+0x10da>
    22a2:	00002097          	auipc	ra,0x2
    22a6:	226080e7          	jalr	550(ra) # 44c8 <unlink>
  if(open("lf1", 0) >= 0){
    22aa:	4581                	li	a1,0
    22ac:	00003517          	auipc	a0,0x3
    22b0:	74450513          	addi	a0,a0,1860 # 59f0 <malloc+0x10da>
    22b4:	00002097          	auipc	ra,0x2
    22b8:	204080e7          	jalr	516(ra) # 44b8 <open>
    22bc:	0e055e63          	bgez	a0,23b8 <linktest+0x1a4>
  fd = open("lf2", 0);
    22c0:	4581                	li	a1,0
    22c2:	00003517          	auipc	a0,0x3
    22c6:	73650513          	addi	a0,a0,1846 # 59f8 <malloc+0x10e2>
    22ca:	00002097          	auipc	ra,0x2
    22ce:	1ee080e7          	jalr	494(ra) # 44b8 <open>
    22d2:	84aa                	mv	s1,a0
  if(fd < 0){
    22d4:	10054063          	bltz	a0,23d4 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
    22d8:	660d                	lui	a2,0x3
    22da:	00007597          	auipc	a1,0x7
    22de:	00658593          	addi	a1,a1,6 # 92e0 <buf>
    22e2:	00002097          	auipc	ra,0x2
    22e6:	1ae080e7          	jalr	430(ra) # 4490 <read>
    22ea:	4795                	li	a5,5
    22ec:	10f51263          	bne	a0,a5,23f0 <linktest+0x1dc>
  close(fd);
    22f0:	8526                	mv	a0,s1
    22f2:	00002097          	auipc	ra,0x2
    22f6:	1ae080e7          	jalr	430(ra) # 44a0 <close>
  if(link("lf2", "lf2") >= 0){
    22fa:	00003597          	auipc	a1,0x3
    22fe:	6fe58593          	addi	a1,a1,1790 # 59f8 <malloc+0x10e2>
    2302:	852e                	mv	a0,a1
    2304:	00002097          	auipc	ra,0x2
    2308:	1d4080e7          	jalr	468(ra) # 44d8 <link>
    230c:	10055063          	bgez	a0,240c <linktest+0x1f8>
  unlink("lf2");
    2310:	00003517          	auipc	a0,0x3
    2314:	6e850513          	addi	a0,a0,1768 # 59f8 <malloc+0x10e2>
    2318:	00002097          	auipc	ra,0x2
    231c:	1b0080e7          	jalr	432(ra) # 44c8 <unlink>
  if(link("lf2", "lf1") >= 0){
    2320:	00003597          	auipc	a1,0x3
    2324:	6d058593          	addi	a1,a1,1744 # 59f0 <malloc+0x10da>
    2328:	00003517          	auipc	a0,0x3
    232c:	6d050513          	addi	a0,a0,1744 # 59f8 <malloc+0x10e2>
    2330:	00002097          	auipc	ra,0x2
    2334:	1a8080e7          	jalr	424(ra) # 44d8 <link>
    2338:	0e055863          	bgez	a0,2428 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    233c:	00003597          	auipc	a1,0x3
    2340:	6b458593          	addi	a1,a1,1716 # 59f0 <malloc+0x10da>
    2344:	00003517          	auipc	a0,0x3
    2348:	a2450513          	addi	a0,a0,-1500 # 4d68 <malloc+0x452>
    234c:	00002097          	auipc	ra,0x2
    2350:	18c080e7          	jalr	396(ra) # 44d8 <link>
    2354:	0e055863          	bgez	a0,2444 <linktest+0x230>
}
    2358:	60e2                	ld	ra,24(sp)
    235a:	6442                	ld	s0,16(sp)
    235c:	64a2                	ld	s1,8(sp)
    235e:	6902                	ld	s2,0(sp)
    2360:	6105                	addi	sp,sp,32
    2362:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    2364:	85ca                	mv	a1,s2
    2366:	00003517          	auipc	a0,0x3
    236a:	69a50513          	addi	a0,a0,1690 # 5a00 <malloc+0x10ea>
    236e:	00002097          	auipc	ra,0x2
    2372:	492080e7          	jalr	1170(ra) # 4800 <printf>
    exit(1);
    2376:	4505                	li	a0,1
    2378:	00002097          	auipc	ra,0x2
    237c:	100080e7          	jalr	256(ra) # 4478 <exit>
    printf("%s: write lf1 failed\n", s);
    2380:	85ca                	mv	a1,s2
    2382:	00003517          	auipc	a0,0x3
    2386:	69650513          	addi	a0,a0,1686 # 5a18 <malloc+0x1102>
    238a:	00002097          	auipc	ra,0x2
    238e:	476080e7          	jalr	1142(ra) # 4800 <printf>
    exit(1);
    2392:	4505                	li	a0,1
    2394:	00002097          	auipc	ra,0x2
    2398:	0e4080e7          	jalr	228(ra) # 4478 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    239c:	85ca                	mv	a1,s2
    239e:	00003517          	auipc	a0,0x3
    23a2:	69250513          	addi	a0,a0,1682 # 5a30 <malloc+0x111a>
    23a6:	00002097          	auipc	ra,0x2
    23aa:	45a080e7          	jalr	1114(ra) # 4800 <printf>
    exit(1);
    23ae:	4505                	li	a0,1
    23b0:	00002097          	auipc	ra,0x2
    23b4:	0c8080e7          	jalr	200(ra) # 4478 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    23b8:	85ca                	mv	a1,s2
    23ba:	00003517          	auipc	a0,0x3
    23be:	69650513          	addi	a0,a0,1686 # 5a50 <malloc+0x113a>
    23c2:	00002097          	auipc	ra,0x2
    23c6:	43e080e7          	jalr	1086(ra) # 4800 <printf>
    exit(1);
    23ca:	4505                	li	a0,1
    23cc:	00002097          	auipc	ra,0x2
    23d0:	0ac080e7          	jalr	172(ra) # 4478 <exit>
    printf("%s: open lf2 failed\n", s);
    23d4:	85ca                	mv	a1,s2
    23d6:	00003517          	auipc	a0,0x3
    23da:	6aa50513          	addi	a0,a0,1706 # 5a80 <malloc+0x116a>
    23de:	00002097          	auipc	ra,0x2
    23e2:	422080e7          	jalr	1058(ra) # 4800 <printf>
    exit(1);
    23e6:	4505                	li	a0,1
    23e8:	00002097          	auipc	ra,0x2
    23ec:	090080e7          	jalr	144(ra) # 4478 <exit>
    printf("%s: read lf2 failed\n", s);
    23f0:	85ca                	mv	a1,s2
    23f2:	00003517          	auipc	a0,0x3
    23f6:	6a650513          	addi	a0,a0,1702 # 5a98 <malloc+0x1182>
    23fa:	00002097          	auipc	ra,0x2
    23fe:	406080e7          	jalr	1030(ra) # 4800 <printf>
    exit(1);
    2402:	4505                	li	a0,1
    2404:	00002097          	auipc	ra,0x2
    2408:	074080e7          	jalr	116(ra) # 4478 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    240c:	85ca                	mv	a1,s2
    240e:	00003517          	auipc	a0,0x3
    2412:	6a250513          	addi	a0,a0,1698 # 5ab0 <malloc+0x119a>
    2416:	00002097          	auipc	ra,0x2
    241a:	3ea080e7          	jalr	1002(ra) # 4800 <printf>
    exit(1);
    241e:	4505                	li	a0,1
    2420:	00002097          	auipc	ra,0x2
    2424:	058080e7          	jalr	88(ra) # 4478 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
    2428:	85ca                	mv	a1,s2
    242a:	00003517          	auipc	a0,0x3
    242e:	6ae50513          	addi	a0,a0,1710 # 5ad8 <malloc+0x11c2>
    2432:	00002097          	auipc	ra,0x2
    2436:	3ce080e7          	jalr	974(ra) # 4800 <printf>
    exit(1);
    243a:	4505                	li	a0,1
    243c:	00002097          	auipc	ra,0x2
    2440:	03c080e7          	jalr	60(ra) # 4478 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    2444:	85ca                	mv	a1,s2
    2446:	00003517          	auipc	a0,0x3
    244a:	6ba50513          	addi	a0,a0,1722 # 5b00 <malloc+0x11ea>
    244e:	00002097          	auipc	ra,0x2
    2452:	3b2080e7          	jalr	946(ra) # 4800 <printf>
    exit(1);
    2456:	4505                	li	a0,1
    2458:	00002097          	auipc	ra,0x2
    245c:	020080e7          	jalr	32(ra) # 4478 <exit>

0000000000002460 <concreate>:
{
    2460:	7135                	addi	sp,sp,-160
    2462:	ed06                	sd	ra,152(sp)
    2464:	e922                	sd	s0,144(sp)
    2466:	e526                	sd	s1,136(sp)
    2468:	e14a                	sd	s2,128(sp)
    246a:	fcce                	sd	s3,120(sp)
    246c:	f8d2                	sd	s4,112(sp)
    246e:	f4d6                	sd	s5,104(sp)
    2470:	f0da                	sd	s6,96(sp)
    2472:	ecde                	sd	s7,88(sp)
    2474:	1100                	addi	s0,sp,160
    2476:	89aa                	mv	s3,a0
  file[0] = 'C';
    2478:	04300793          	li	a5,67
    247c:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    2480:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    2484:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    2486:	4b0d                	li	s6,3
    2488:	4a85                	li	s5,1
      link("C0", file);
    248a:	00003b97          	auipc	s7,0x3
    248e:	696b8b93          	addi	s7,s7,1686 # 5b20 <malloc+0x120a>
  for(i = 0; i < N; i++){
    2492:	02800a13          	li	s4,40
    2496:	a471                	j	2722 <concreate+0x2c2>
      link("C0", file);
    2498:	fa840593          	addi	a1,s0,-88
    249c:	855e                	mv	a0,s7
    249e:	00002097          	auipc	ra,0x2
    24a2:	03a080e7          	jalr	58(ra) # 44d8 <link>
    if(pid == 0) {
    24a6:	a48d                	j	2708 <concreate+0x2a8>
    } else if(pid == 0 && (i % 5) == 1){
    24a8:	4795                	li	a5,5
    24aa:	02f9693b          	remw	s2,s2,a5
    24ae:	4785                	li	a5,1
    24b0:	02f90b63          	beq	s2,a5,24e6 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    24b4:	20200593          	li	a1,514
    24b8:	fa840513          	addi	a0,s0,-88
    24bc:	00002097          	auipc	ra,0x2
    24c0:	ffc080e7          	jalr	-4(ra) # 44b8 <open>
      if(fd < 0){
    24c4:	22055963          	bgez	a0,26f6 <concreate+0x296>
        printf("concreate create %s failed\n", file);
    24c8:	fa840593          	addi	a1,s0,-88
    24cc:	00003517          	auipc	a0,0x3
    24d0:	65c50513          	addi	a0,a0,1628 # 5b28 <malloc+0x1212>
    24d4:	00002097          	auipc	ra,0x2
    24d8:	32c080e7          	jalr	812(ra) # 4800 <printf>
        exit(1);
    24dc:	4505                	li	a0,1
    24de:	00002097          	auipc	ra,0x2
    24e2:	f9a080e7          	jalr	-102(ra) # 4478 <exit>
      link("C0", file);
    24e6:	fa840593          	addi	a1,s0,-88
    24ea:	00003517          	auipc	a0,0x3
    24ee:	63650513          	addi	a0,a0,1590 # 5b20 <malloc+0x120a>
    24f2:	00002097          	auipc	ra,0x2
    24f6:	fe6080e7          	jalr	-26(ra) # 44d8 <link>
      exit(0);
    24fa:	4501                	li	a0,0
    24fc:	00002097          	auipc	ra,0x2
    2500:	f7c080e7          	jalr	-132(ra) # 4478 <exit>
        exit(1);
    2504:	4505                	li	a0,1
    2506:	00002097          	auipc	ra,0x2
    250a:	f72080e7          	jalr	-142(ra) # 4478 <exit>
  memset(fa, 0, sizeof(fa));
    250e:	02800613          	li	a2,40
    2512:	4581                	li	a1,0
    2514:	f8040513          	addi	a0,s0,-128
    2518:	00002097          	auipc	ra,0x2
    251c:	d0c080e7          	jalr	-756(ra) # 4224 <memset>
  fd = open(".", 0);
    2520:	4581                	li	a1,0
    2522:	00003517          	auipc	a0,0x3
    2526:	84650513          	addi	a0,a0,-1978 # 4d68 <malloc+0x452>
    252a:	00002097          	auipc	ra,0x2
    252e:	f8e080e7          	jalr	-114(ra) # 44b8 <open>
    2532:	892a                	mv	s2,a0
  n = 0;
    2534:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    2536:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    253a:	02700b13          	li	s6,39
      fa[i] = 1;
    253e:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    2540:	a03d                	j	256e <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    2542:	f7240613          	addi	a2,s0,-142
    2546:	85ce                	mv	a1,s3
    2548:	00003517          	auipc	a0,0x3
    254c:	60050513          	addi	a0,a0,1536 # 5b48 <malloc+0x1232>
    2550:	00002097          	auipc	ra,0x2
    2554:	2b0080e7          	jalr	688(ra) # 4800 <printf>
        exit(1);
    2558:	4505                	li	a0,1
    255a:	00002097          	auipc	ra,0x2
    255e:	f1e080e7          	jalr	-226(ra) # 4478 <exit>
      fa[i] = 1;
    2562:	fb040793          	addi	a5,s0,-80
    2566:	973e                	add	a4,a4,a5
    2568:	fd770823          	sb	s7,-48(a4)
      n++;
    256c:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    256e:	4641                	li	a2,16
    2570:	f7040593          	addi	a1,s0,-144
    2574:	854a                	mv	a0,s2
    2576:	00002097          	auipc	ra,0x2
    257a:	f1a080e7          	jalr	-230(ra) # 4490 <read>
    257e:	04a05a63          	blez	a0,25d2 <concreate+0x172>
    if(de.inum == 0)
    2582:	f7045783          	lhu	a5,-144(s0)
    2586:	d7e5                	beqz	a5,256e <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    2588:	f7244783          	lbu	a5,-142(s0)
    258c:	ff4791e3          	bne	a5,s4,256e <concreate+0x10e>
    2590:	f7444783          	lbu	a5,-140(s0)
    2594:	ffe9                	bnez	a5,256e <concreate+0x10e>
      i = de.name[1] - '0';
    2596:	f7344783          	lbu	a5,-141(s0)
    259a:	fd07879b          	addiw	a5,a5,-48
    259e:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    25a2:	faeb60e3          	bltu	s6,a4,2542 <concreate+0xe2>
      if(fa[i]){
    25a6:	fb040793          	addi	a5,s0,-80
    25aa:	97ba                	add	a5,a5,a4
    25ac:	fd07c783          	lbu	a5,-48(a5)
    25b0:	dbcd                	beqz	a5,2562 <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    25b2:	f7240613          	addi	a2,s0,-142
    25b6:	85ce                	mv	a1,s3
    25b8:	00003517          	auipc	a0,0x3
    25bc:	5b050513          	addi	a0,a0,1456 # 5b68 <malloc+0x1252>
    25c0:	00002097          	auipc	ra,0x2
    25c4:	240080e7          	jalr	576(ra) # 4800 <printf>
        exit(1);
    25c8:	4505                	li	a0,1
    25ca:	00002097          	auipc	ra,0x2
    25ce:	eae080e7          	jalr	-338(ra) # 4478 <exit>
  close(fd);
    25d2:	854a                	mv	a0,s2
    25d4:	00002097          	auipc	ra,0x2
    25d8:	ecc080e7          	jalr	-308(ra) # 44a0 <close>
  if(n != N){
    25dc:	02800793          	li	a5,40
    25e0:	00fa9763          	bne	s5,a5,25ee <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    25e4:	4a8d                	li	s5,3
    25e6:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    25e8:	02800a13          	li	s4,40
    25ec:	a05d                	j	2692 <concreate+0x232>
    printf("%s: concreate not enough files in directory listing\n", s);
    25ee:	85ce                	mv	a1,s3
    25f0:	00003517          	auipc	a0,0x3
    25f4:	5a050513          	addi	a0,a0,1440 # 5b90 <malloc+0x127a>
    25f8:	00002097          	auipc	ra,0x2
    25fc:	208080e7          	jalr	520(ra) # 4800 <printf>
    exit(1);
    2600:	4505                	li	a0,1
    2602:	00002097          	auipc	ra,0x2
    2606:	e76080e7          	jalr	-394(ra) # 4478 <exit>
      printf("%s: fork failed\n", s);
    260a:	85ce                	mv	a1,s3
    260c:	00003517          	auipc	a0,0x3
    2610:	80c50513          	addi	a0,a0,-2036 # 4e18 <malloc+0x502>
    2614:	00002097          	auipc	ra,0x2
    2618:	1ec080e7          	jalr	492(ra) # 4800 <printf>
      exit(1);
    261c:	4505                	li	a0,1
    261e:	00002097          	auipc	ra,0x2
    2622:	e5a080e7          	jalr	-422(ra) # 4478 <exit>
      close(open(file, 0));
    2626:	4581                	li	a1,0
    2628:	fa840513          	addi	a0,s0,-88
    262c:	00002097          	auipc	ra,0x2
    2630:	e8c080e7          	jalr	-372(ra) # 44b8 <open>
    2634:	00002097          	auipc	ra,0x2
    2638:	e6c080e7          	jalr	-404(ra) # 44a0 <close>
      close(open(file, 0));
    263c:	4581                	li	a1,0
    263e:	fa840513          	addi	a0,s0,-88
    2642:	00002097          	auipc	ra,0x2
    2646:	e76080e7          	jalr	-394(ra) # 44b8 <open>
    264a:	00002097          	auipc	ra,0x2
    264e:	e56080e7          	jalr	-426(ra) # 44a0 <close>
      close(open(file, 0));
    2652:	4581                	li	a1,0
    2654:	fa840513          	addi	a0,s0,-88
    2658:	00002097          	auipc	ra,0x2
    265c:	e60080e7          	jalr	-416(ra) # 44b8 <open>
    2660:	00002097          	auipc	ra,0x2
    2664:	e40080e7          	jalr	-448(ra) # 44a0 <close>
      close(open(file, 0));
    2668:	4581                	li	a1,0
    266a:	fa840513          	addi	a0,s0,-88
    266e:	00002097          	auipc	ra,0x2
    2672:	e4a080e7          	jalr	-438(ra) # 44b8 <open>
    2676:	00002097          	auipc	ra,0x2
    267a:	e2a080e7          	jalr	-470(ra) # 44a0 <close>
    if(pid == 0)
    267e:	06090763          	beqz	s2,26ec <concreate+0x28c>
      wait(0);
    2682:	4501                	li	a0,0
    2684:	00002097          	auipc	ra,0x2
    2688:	dfc080e7          	jalr	-516(ra) # 4480 <wait>
  for(i = 0; i < N; i++){
    268c:	2485                	addiw	s1,s1,1
    268e:	0d448963          	beq	s1,s4,2760 <concreate+0x300>
    file[1] = '0' + i;
    2692:	0304879b          	addiw	a5,s1,48
    2696:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    269a:	00002097          	auipc	ra,0x2
    269e:	dd6080e7          	jalr	-554(ra) # 4470 <fork>
    26a2:	892a                	mv	s2,a0
    if(pid < 0){
    26a4:	f60543e3          	bltz	a0,260a <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    26a8:	0354e73b          	remw	a4,s1,s5
    26ac:	00a767b3          	or	a5,a4,a0
    26b0:	2781                	sext.w	a5,a5
    26b2:	dbb5                	beqz	a5,2626 <concreate+0x1c6>
    26b4:	01671363          	bne	a4,s6,26ba <concreate+0x25a>
       ((i % 3) == 1 && pid != 0)){
    26b8:	f53d                	bnez	a0,2626 <concreate+0x1c6>
      unlink(file);
    26ba:	fa840513          	addi	a0,s0,-88
    26be:	00002097          	auipc	ra,0x2
    26c2:	e0a080e7          	jalr	-502(ra) # 44c8 <unlink>
      unlink(file);
    26c6:	fa840513          	addi	a0,s0,-88
    26ca:	00002097          	auipc	ra,0x2
    26ce:	dfe080e7          	jalr	-514(ra) # 44c8 <unlink>
      unlink(file);
    26d2:	fa840513          	addi	a0,s0,-88
    26d6:	00002097          	auipc	ra,0x2
    26da:	df2080e7          	jalr	-526(ra) # 44c8 <unlink>
      unlink(file);
    26de:	fa840513          	addi	a0,s0,-88
    26e2:	00002097          	auipc	ra,0x2
    26e6:	de6080e7          	jalr	-538(ra) # 44c8 <unlink>
    26ea:	bf51                	j	267e <concreate+0x21e>
      exit(0);
    26ec:	4501                	li	a0,0
    26ee:	00002097          	auipc	ra,0x2
    26f2:	d8a080e7          	jalr	-630(ra) # 4478 <exit>
      close(fd);
    26f6:	00002097          	auipc	ra,0x2
    26fa:	daa080e7          	jalr	-598(ra) # 44a0 <close>
    if(pid == 0) {
    26fe:	bbf5                	j	24fa <concreate+0x9a>
      close(fd);
    2700:	00002097          	auipc	ra,0x2
    2704:	da0080e7          	jalr	-608(ra) # 44a0 <close>
      wait(&xstatus);
    2708:	f6c40513          	addi	a0,s0,-148
    270c:	00002097          	auipc	ra,0x2
    2710:	d74080e7          	jalr	-652(ra) # 4480 <wait>
      if(xstatus != 0)
    2714:	f6c42483          	lw	s1,-148(s0)
    2718:	de0496e3          	bnez	s1,2504 <concreate+0xa4>
  for(i = 0; i < N; i++){
    271c:	2905                	addiw	s2,s2,1
    271e:	df4908e3          	beq	s2,s4,250e <concreate+0xae>
    file[1] = '0' + i;
    2722:	0309079b          	addiw	a5,s2,48
    2726:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    272a:	fa840513          	addi	a0,s0,-88
    272e:	00002097          	auipc	ra,0x2
    2732:	d9a080e7          	jalr	-614(ra) # 44c8 <unlink>
    pid = fork();
    2736:	00002097          	auipc	ra,0x2
    273a:	d3a080e7          	jalr	-710(ra) # 4470 <fork>
    if(pid && (i % 3) == 1){
    273e:	d60505e3          	beqz	a0,24a8 <concreate+0x48>
    2742:	036967bb          	remw	a5,s2,s6
    2746:	d55789e3          	beq	a5,s5,2498 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    274a:	20200593          	li	a1,514
    274e:	fa840513          	addi	a0,s0,-88
    2752:	00002097          	auipc	ra,0x2
    2756:	d66080e7          	jalr	-666(ra) # 44b8 <open>
      if(fd < 0){
    275a:	fa0553e3          	bgez	a0,2700 <concreate+0x2a0>
    275e:	b3ad                	j	24c8 <concreate+0x68>
}
    2760:	60ea                	ld	ra,152(sp)
    2762:	644a                	ld	s0,144(sp)
    2764:	64aa                	ld	s1,136(sp)
    2766:	690a                	ld	s2,128(sp)
    2768:	79e6                	ld	s3,120(sp)
    276a:	7a46                	ld	s4,112(sp)
    276c:	7aa6                	ld	s5,104(sp)
    276e:	7b06                	ld	s6,96(sp)
    2770:	6be6                	ld	s7,88(sp)
    2772:	610d                	addi	sp,sp,160
    2774:	8082                	ret

0000000000002776 <linkunlink>:
{
    2776:	711d                	addi	sp,sp,-96
    2778:	ec86                	sd	ra,88(sp)
    277a:	e8a2                	sd	s0,80(sp)
    277c:	e4a6                	sd	s1,72(sp)
    277e:	e0ca                	sd	s2,64(sp)
    2780:	fc4e                	sd	s3,56(sp)
    2782:	f852                	sd	s4,48(sp)
    2784:	f456                	sd	s5,40(sp)
    2786:	f05a                	sd	s6,32(sp)
    2788:	ec5e                	sd	s7,24(sp)
    278a:	e862                	sd	s8,16(sp)
    278c:	e466                	sd	s9,8(sp)
    278e:	1080                	addi	s0,sp,96
    2790:	84aa                	mv	s1,a0
  unlink("x");
    2792:	00003517          	auipc	a0,0x3
    2796:	03650513          	addi	a0,a0,54 # 57c8 <malloc+0xeb2>
    279a:	00002097          	auipc	ra,0x2
    279e:	d2e080e7          	jalr	-722(ra) # 44c8 <unlink>
  pid = fork();
    27a2:	00002097          	auipc	ra,0x2
    27a6:	cce080e7          	jalr	-818(ra) # 4470 <fork>
  if(pid < 0){
    27aa:	02054b63          	bltz	a0,27e0 <linkunlink+0x6a>
    27ae:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    27b0:	4c85                	li	s9,1
    27b2:	e119                	bnez	a0,27b8 <linkunlink+0x42>
    27b4:	06100c93          	li	s9,97
    27b8:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    27bc:	41c659b7          	lui	s3,0x41c65
    27c0:	e6d9899b          	addiw	s3,s3,-403
    27c4:	690d                	lui	s2,0x3
    27c6:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    27ca:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    27cc:	4b05                	li	s6,1
      unlink("x");
    27ce:	00003a97          	auipc	s5,0x3
    27d2:	ffaa8a93          	addi	s5,s5,-6 # 57c8 <malloc+0xeb2>
      link("cat", "x");
    27d6:	00003b97          	auipc	s7,0x3
    27da:	3f2b8b93          	addi	s7,s7,1010 # 5bc8 <malloc+0x12b2>
    27de:	a091                	j	2822 <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    27e0:	85a6                	mv	a1,s1
    27e2:	00002517          	auipc	a0,0x2
    27e6:	63650513          	addi	a0,a0,1590 # 4e18 <malloc+0x502>
    27ea:	00002097          	auipc	ra,0x2
    27ee:	016080e7          	jalr	22(ra) # 4800 <printf>
    exit(1);
    27f2:	4505                	li	a0,1
    27f4:	00002097          	auipc	ra,0x2
    27f8:	c84080e7          	jalr	-892(ra) # 4478 <exit>
      close(open("x", O_RDWR | O_CREATE));
    27fc:	20200593          	li	a1,514
    2800:	8556                	mv	a0,s5
    2802:	00002097          	auipc	ra,0x2
    2806:	cb6080e7          	jalr	-842(ra) # 44b8 <open>
    280a:	00002097          	auipc	ra,0x2
    280e:	c96080e7          	jalr	-874(ra) # 44a0 <close>
    2812:	a031                	j	281e <linkunlink+0xa8>
      unlink("x");
    2814:	8556                	mv	a0,s5
    2816:	00002097          	auipc	ra,0x2
    281a:	cb2080e7          	jalr	-846(ra) # 44c8 <unlink>
  for(i = 0; i < 100; i++){
    281e:	34fd                	addiw	s1,s1,-1
    2820:	c09d                	beqz	s1,2846 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    2822:	033c87bb          	mulw	a5,s9,s3
    2826:	012787bb          	addw	a5,a5,s2
    282a:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    282e:	0347f7bb          	remuw	a5,a5,s4
    2832:	d7e9                	beqz	a5,27fc <linkunlink+0x86>
    } else if((x % 3) == 1){
    2834:	ff6790e3          	bne	a5,s6,2814 <linkunlink+0x9e>
      link("cat", "x");
    2838:	85d6                	mv	a1,s5
    283a:	855e                	mv	a0,s7
    283c:	00002097          	auipc	ra,0x2
    2840:	c9c080e7          	jalr	-868(ra) # 44d8 <link>
    2844:	bfe9                	j	281e <linkunlink+0xa8>
  if(pid)
    2846:	020c0463          	beqz	s8,286e <linkunlink+0xf8>
    wait(0);
    284a:	4501                	li	a0,0
    284c:	00002097          	auipc	ra,0x2
    2850:	c34080e7          	jalr	-972(ra) # 4480 <wait>
}
    2854:	60e6                	ld	ra,88(sp)
    2856:	6446                	ld	s0,80(sp)
    2858:	64a6                	ld	s1,72(sp)
    285a:	6906                	ld	s2,64(sp)
    285c:	79e2                	ld	s3,56(sp)
    285e:	7a42                	ld	s4,48(sp)
    2860:	7aa2                	ld	s5,40(sp)
    2862:	7b02                	ld	s6,32(sp)
    2864:	6be2                	ld	s7,24(sp)
    2866:	6c42                	ld	s8,16(sp)
    2868:	6ca2                	ld	s9,8(sp)
    286a:	6125                	addi	sp,sp,96
    286c:	8082                	ret
    exit(0);
    286e:	4501                	li	a0,0
    2870:	00002097          	auipc	ra,0x2
    2874:	c08080e7          	jalr	-1016(ra) # 4478 <exit>

0000000000002878 <bigdir>:
{
    2878:	715d                	addi	sp,sp,-80
    287a:	e486                	sd	ra,72(sp)
    287c:	e0a2                	sd	s0,64(sp)
    287e:	fc26                	sd	s1,56(sp)
    2880:	f84a                	sd	s2,48(sp)
    2882:	f44e                	sd	s3,40(sp)
    2884:	f052                	sd	s4,32(sp)
    2886:	ec56                	sd	s5,24(sp)
    2888:	e85a                	sd	s6,16(sp)
    288a:	0880                	addi	s0,sp,80
    288c:	89aa                	mv	s3,a0
  unlink("bd");
    288e:	00003517          	auipc	a0,0x3
    2892:	34250513          	addi	a0,a0,834 # 5bd0 <malloc+0x12ba>
    2896:	00002097          	auipc	ra,0x2
    289a:	c32080e7          	jalr	-974(ra) # 44c8 <unlink>
  fd = open("bd", O_CREATE);
    289e:	20000593          	li	a1,512
    28a2:	00003517          	auipc	a0,0x3
    28a6:	32e50513          	addi	a0,a0,814 # 5bd0 <malloc+0x12ba>
    28aa:	00002097          	auipc	ra,0x2
    28ae:	c0e080e7          	jalr	-1010(ra) # 44b8 <open>
  if(fd < 0){
    28b2:	0c054963          	bltz	a0,2984 <bigdir+0x10c>
  close(fd);
    28b6:	00002097          	auipc	ra,0x2
    28ba:	bea080e7          	jalr	-1046(ra) # 44a0 <close>
  for(i = 0; i < N; i++){
    28be:	4901                	li	s2,0
    name[0] = 'x';
    28c0:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    28c4:	00003a17          	auipc	s4,0x3
    28c8:	30ca0a13          	addi	s4,s4,780 # 5bd0 <malloc+0x12ba>
  for(i = 0; i < N; i++){
    28cc:	1f400b13          	li	s6,500
    name[0] = 'x';
    28d0:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    28d4:	41f9579b          	sraiw	a5,s2,0x1f
    28d8:	01a7d71b          	srliw	a4,a5,0x1a
    28dc:	012707bb          	addw	a5,a4,s2
    28e0:	4067d69b          	sraiw	a3,a5,0x6
    28e4:	0306869b          	addiw	a3,a3,48
    28e8:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    28ec:	03f7f793          	andi	a5,a5,63
    28f0:	9f99                	subw	a5,a5,a4
    28f2:	0307879b          	addiw	a5,a5,48
    28f6:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    28fa:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    28fe:	fb040593          	addi	a1,s0,-80
    2902:	8552                	mv	a0,s4
    2904:	00002097          	auipc	ra,0x2
    2908:	bd4080e7          	jalr	-1068(ra) # 44d8 <link>
    290c:	84aa                	mv	s1,a0
    290e:	e949                	bnez	a0,29a0 <bigdir+0x128>
  for(i = 0; i < N; i++){
    2910:	2905                	addiw	s2,s2,1
    2912:	fb691fe3          	bne	s2,s6,28d0 <bigdir+0x58>
  unlink("bd");
    2916:	00003517          	auipc	a0,0x3
    291a:	2ba50513          	addi	a0,a0,698 # 5bd0 <malloc+0x12ba>
    291e:	00002097          	auipc	ra,0x2
    2922:	baa080e7          	jalr	-1110(ra) # 44c8 <unlink>
    name[0] = 'x';
    2926:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    292a:	1f400a13          	li	s4,500
    name[0] = 'x';
    292e:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    2932:	41f4d79b          	sraiw	a5,s1,0x1f
    2936:	01a7d71b          	srliw	a4,a5,0x1a
    293a:	009707bb          	addw	a5,a4,s1
    293e:	4067d69b          	sraiw	a3,a5,0x6
    2942:	0306869b          	addiw	a3,a3,48
    2946:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    294a:	03f7f793          	andi	a5,a5,63
    294e:	9f99                	subw	a5,a5,a4
    2950:	0307879b          	addiw	a5,a5,48
    2954:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    2958:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    295c:	fb040513          	addi	a0,s0,-80
    2960:	00002097          	auipc	ra,0x2
    2964:	b68080e7          	jalr	-1176(ra) # 44c8 <unlink>
    2968:	e931                	bnez	a0,29bc <bigdir+0x144>
  for(i = 0; i < N; i++){
    296a:	2485                	addiw	s1,s1,1
    296c:	fd4491e3          	bne	s1,s4,292e <bigdir+0xb6>
}
    2970:	60a6                	ld	ra,72(sp)
    2972:	6406                	ld	s0,64(sp)
    2974:	74e2                	ld	s1,56(sp)
    2976:	7942                	ld	s2,48(sp)
    2978:	79a2                	ld	s3,40(sp)
    297a:	7a02                	ld	s4,32(sp)
    297c:	6ae2                	ld	s5,24(sp)
    297e:	6b42                	ld	s6,16(sp)
    2980:	6161                	addi	sp,sp,80
    2982:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    2984:	85ce                	mv	a1,s3
    2986:	00003517          	auipc	a0,0x3
    298a:	25250513          	addi	a0,a0,594 # 5bd8 <malloc+0x12c2>
    298e:	00002097          	auipc	ra,0x2
    2992:	e72080e7          	jalr	-398(ra) # 4800 <printf>
    exit(1);
    2996:	4505                	li	a0,1
    2998:	00002097          	auipc	ra,0x2
    299c:	ae0080e7          	jalr	-1312(ra) # 4478 <exit>
      printf("%s: bigdir link failed\n", s);
    29a0:	85ce                	mv	a1,s3
    29a2:	00003517          	auipc	a0,0x3
    29a6:	25650513          	addi	a0,a0,598 # 5bf8 <malloc+0x12e2>
    29aa:	00002097          	auipc	ra,0x2
    29ae:	e56080e7          	jalr	-426(ra) # 4800 <printf>
      exit(1);
    29b2:	4505                	li	a0,1
    29b4:	00002097          	auipc	ra,0x2
    29b8:	ac4080e7          	jalr	-1340(ra) # 4478 <exit>
      printf("%s: bigdir unlink failed", s);
    29bc:	85ce                	mv	a1,s3
    29be:	00003517          	auipc	a0,0x3
    29c2:	25250513          	addi	a0,a0,594 # 5c10 <malloc+0x12fa>
    29c6:	00002097          	auipc	ra,0x2
    29ca:	e3a080e7          	jalr	-454(ra) # 4800 <printf>
      exit(1);
    29ce:	4505                	li	a0,1
    29d0:	00002097          	auipc	ra,0x2
    29d4:	aa8080e7          	jalr	-1368(ra) # 4478 <exit>

00000000000029d8 <subdir>:
{
    29d8:	1101                	addi	sp,sp,-32
    29da:	ec06                	sd	ra,24(sp)
    29dc:	e822                	sd	s0,16(sp)
    29de:	e426                	sd	s1,8(sp)
    29e0:	e04a                	sd	s2,0(sp)
    29e2:	1000                	addi	s0,sp,32
    29e4:	892a                	mv	s2,a0
  unlink("ff");
    29e6:	00003517          	auipc	a0,0x3
    29ea:	37a50513          	addi	a0,a0,890 # 5d60 <malloc+0x144a>
    29ee:	00002097          	auipc	ra,0x2
    29f2:	ada080e7          	jalr	-1318(ra) # 44c8 <unlink>
  if(mkdir("dd") != 0){
    29f6:	00003517          	auipc	a0,0x3
    29fa:	23a50513          	addi	a0,a0,570 # 5c30 <malloc+0x131a>
    29fe:	00002097          	auipc	ra,0x2
    2a02:	ae2080e7          	jalr	-1310(ra) # 44e0 <mkdir>
    2a06:	38051663          	bnez	a0,2d92 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2a0a:	20200593          	li	a1,514
    2a0e:	00003517          	auipc	a0,0x3
    2a12:	24250513          	addi	a0,a0,578 # 5c50 <malloc+0x133a>
    2a16:	00002097          	auipc	ra,0x2
    2a1a:	aa2080e7          	jalr	-1374(ra) # 44b8 <open>
    2a1e:	84aa                	mv	s1,a0
  if(fd < 0){
    2a20:	38054763          	bltz	a0,2dae <subdir+0x3d6>
  write(fd, "ff", 2);
    2a24:	4609                	li	a2,2
    2a26:	00003597          	auipc	a1,0x3
    2a2a:	33a58593          	addi	a1,a1,826 # 5d60 <malloc+0x144a>
    2a2e:	00002097          	auipc	ra,0x2
    2a32:	a6a080e7          	jalr	-1430(ra) # 4498 <write>
  close(fd);
    2a36:	8526                	mv	a0,s1
    2a38:	00002097          	auipc	ra,0x2
    2a3c:	a68080e7          	jalr	-1432(ra) # 44a0 <close>
  if(unlink("dd") >= 0){
    2a40:	00003517          	auipc	a0,0x3
    2a44:	1f050513          	addi	a0,a0,496 # 5c30 <malloc+0x131a>
    2a48:	00002097          	auipc	ra,0x2
    2a4c:	a80080e7          	jalr	-1408(ra) # 44c8 <unlink>
    2a50:	36055d63          	bgez	a0,2dca <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    2a54:	00003517          	auipc	a0,0x3
    2a58:	25450513          	addi	a0,a0,596 # 5ca8 <malloc+0x1392>
    2a5c:	00002097          	auipc	ra,0x2
    2a60:	a84080e7          	jalr	-1404(ra) # 44e0 <mkdir>
    2a64:	38051163          	bnez	a0,2de6 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2a68:	20200593          	li	a1,514
    2a6c:	00003517          	auipc	a0,0x3
    2a70:	26450513          	addi	a0,a0,612 # 5cd0 <malloc+0x13ba>
    2a74:	00002097          	auipc	ra,0x2
    2a78:	a44080e7          	jalr	-1468(ra) # 44b8 <open>
    2a7c:	84aa                	mv	s1,a0
  if(fd < 0){
    2a7e:	38054263          	bltz	a0,2e02 <subdir+0x42a>
  write(fd, "FF", 2);
    2a82:	4609                	li	a2,2
    2a84:	00003597          	auipc	a1,0x3
    2a88:	27c58593          	addi	a1,a1,636 # 5d00 <malloc+0x13ea>
    2a8c:	00002097          	auipc	ra,0x2
    2a90:	a0c080e7          	jalr	-1524(ra) # 4498 <write>
  close(fd);
    2a94:	8526                	mv	a0,s1
    2a96:	00002097          	auipc	ra,0x2
    2a9a:	a0a080e7          	jalr	-1526(ra) # 44a0 <close>
  fd = open("dd/dd/../ff", 0);
    2a9e:	4581                	li	a1,0
    2aa0:	00003517          	auipc	a0,0x3
    2aa4:	26850513          	addi	a0,a0,616 # 5d08 <malloc+0x13f2>
    2aa8:	00002097          	auipc	ra,0x2
    2aac:	a10080e7          	jalr	-1520(ra) # 44b8 <open>
    2ab0:	84aa                	mv	s1,a0
  if(fd < 0){
    2ab2:	36054663          	bltz	a0,2e1e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2ab6:	660d                	lui	a2,0x3
    2ab8:	00007597          	auipc	a1,0x7
    2abc:	82858593          	addi	a1,a1,-2008 # 92e0 <buf>
    2ac0:	00002097          	auipc	ra,0x2
    2ac4:	9d0080e7          	jalr	-1584(ra) # 4490 <read>
  if(cc != 2 || buf[0] != 'f'){
    2ac8:	4789                	li	a5,2
    2aca:	36f51863          	bne	a0,a5,2e3a <subdir+0x462>
    2ace:	00007717          	auipc	a4,0x7
    2ad2:	81274703          	lbu	a4,-2030(a4) # 92e0 <buf>
    2ad6:	06600793          	li	a5,102
    2ada:	36f71063          	bne	a4,a5,2e3a <subdir+0x462>
  close(fd);
    2ade:	8526                	mv	a0,s1
    2ae0:	00002097          	auipc	ra,0x2
    2ae4:	9c0080e7          	jalr	-1600(ra) # 44a0 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2ae8:	00003597          	auipc	a1,0x3
    2aec:	27058593          	addi	a1,a1,624 # 5d58 <malloc+0x1442>
    2af0:	00003517          	auipc	a0,0x3
    2af4:	1e050513          	addi	a0,a0,480 # 5cd0 <malloc+0x13ba>
    2af8:	00002097          	auipc	ra,0x2
    2afc:	9e0080e7          	jalr	-1568(ra) # 44d8 <link>
    2b00:	34051b63          	bnez	a0,2e56 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    2b04:	00003517          	auipc	a0,0x3
    2b08:	1cc50513          	addi	a0,a0,460 # 5cd0 <malloc+0x13ba>
    2b0c:	00002097          	auipc	ra,0x2
    2b10:	9bc080e7          	jalr	-1604(ra) # 44c8 <unlink>
    2b14:	34051f63          	bnez	a0,2e72 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2b18:	4581                	li	a1,0
    2b1a:	00003517          	auipc	a0,0x3
    2b1e:	1b650513          	addi	a0,a0,438 # 5cd0 <malloc+0x13ba>
    2b22:	00002097          	auipc	ra,0x2
    2b26:	996080e7          	jalr	-1642(ra) # 44b8 <open>
    2b2a:	36055263          	bgez	a0,2e8e <subdir+0x4b6>
  if(chdir("dd") != 0){
    2b2e:	00003517          	auipc	a0,0x3
    2b32:	10250513          	addi	a0,a0,258 # 5c30 <malloc+0x131a>
    2b36:	00002097          	auipc	ra,0x2
    2b3a:	9b2080e7          	jalr	-1614(ra) # 44e8 <chdir>
    2b3e:	36051663          	bnez	a0,2eaa <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    2b42:	00003517          	auipc	a0,0x3
    2b46:	2ae50513          	addi	a0,a0,686 # 5df0 <malloc+0x14da>
    2b4a:	00002097          	auipc	ra,0x2
    2b4e:	99e080e7          	jalr	-1634(ra) # 44e8 <chdir>
    2b52:	36051a63          	bnez	a0,2ec6 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    2b56:	00003517          	auipc	a0,0x3
    2b5a:	2ca50513          	addi	a0,a0,714 # 5e20 <malloc+0x150a>
    2b5e:	00002097          	auipc	ra,0x2
    2b62:	98a080e7          	jalr	-1654(ra) # 44e8 <chdir>
    2b66:	36051e63          	bnez	a0,2ee2 <subdir+0x50a>
  if(chdir("./..") != 0){
    2b6a:	00003517          	auipc	a0,0x3
    2b6e:	2e650513          	addi	a0,a0,742 # 5e50 <malloc+0x153a>
    2b72:	00002097          	auipc	ra,0x2
    2b76:	976080e7          	jalr	-1674(ra) # 44e8 <chdir>
    2b7a:	38051263          	bnez	a0,2efe <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2b7e:	4581                	li	a1,0
    2b80:	00003517          	auipc	a0,0x3
    2b84:	1d850513          	addi	a0,a0,472 # 5d58 <malloc+0x1442>
    2b88:	00002097          	auipc	ra,0x2
    2b8c:	930080e7          	jalr	-1744(ra) # 44b8 <open>
    2b90:	84aa                	mv	s1,a0
  if(fd < 0){
    2b92:	38054463          	bltz	a0,2f1a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    2b96:	660d                	lui	a2,0x3
    2b98:	00006597          	auipc	a1,0x6
    2b9c:	74858593          	addi	a1,a1,1864 # 92e0 <buf>
    2ba0:	00002097          	auipc	ra,0x2
    2ba4:	8f0080e7          	jalr	-1808(ra) # 4490 <read>
    2ba8:	4789                	li	a5,2
    2baa:	38f51663          	bne	a0,a5,2f36 <subdir+0x55e>
  close(fd);
    2bae:	8526                	mv	a0,s1
    2bb0:	00002097          	auipc	ra,0x2
    2bb4:	8f0080e7          	jalr	-1808(ra) # 44a0 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2bb8:	4581                	li	a1,0
    2bba:	00003517          	auipc	a0,0x3
    2bbe:	11650513          	addi	a0,a0,278 # 5cd0 <malloc+0x13ba>
    2bc2:	00002097          	auipc	ra,0x2
    2bc6:	8f6080e7          	jalr	-1802(ra) # 44b8 <open>
    2bca:	38055463          	bgez	a0,2f52 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2bce:	20200593          	li	a1,514
    2bd2:	00003517          	auipc	a0,0x3
    2bd6:	30e50513          	addi	a0,a0,782 # 5ee0 <malloc+0x15ca>
    2bda:	00002097          	auipc	ra,0x2
    2bde:	8de080e7          	jalr	-1826(ra) # 44b8 <open>
    2be2:	38055663          	bgez	a0,2f6e <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2be6:	20200593          	li	a1,514
    2bea:	00003517          	auipc	a0,0x3
    2bee:	32650513          	addi	a0,a0,806 # 5f10 <malloc+0x15fa>
    2bf2:	00002097          	auipc	ra,0x2
    2bf6:	8c6080e7          	jalr	-1850(ra) # 44b8 <open>
    2bfa:	38055863          	bgez	a0,2f8a <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    2bfe:	20000593          	li	a1,512
    2c02:	00003517          	auipc	a0,0x3
    2c06:	02e50513          	addi	a0,a0,46 # 5c30 <malloc+0x131a>
    2c0a:	00002097          	auipc	ra,0x2
    2c0e:	8ae080e7          	jalr	-1874(ra) # 44b8 <open>
    2c12:	38055a63          	bgez	a0,2fa6 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    2c16:	4589                	li	a1,2
    2c18:	00003517          	auipc	a0,0x3
    2c1c:	01850513          	addi	a0,a0,24 # 5c30 <malloc+0x131a>
    2c20:	00002097          	auipc	ra,0x2
    2c24:	898080e7          	jalr	-1896(ra) # 44b8 <open>
    2c28:	38055d63          	bgez	a0,2fc2 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    2c2c:	4585                	li	a1,1
    2c2e:	00003517          	auipc	a0,0x3
    2c32:	00250513          	addi	a0,a0,2 # 5c30 <malloc+0x131a>
    2c36:	00002097          	auipc	ra,0x2
    2c3a:	882080e7          	jalr	-1918(ra) # 44b8 <open>
    2c3e:	3a055063          	bgez	a0,2fde <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2c42:	00003597          	auipc	a1,0x3
    2c46:	35e58593          	addi	a1,a1,862 # 5fa0 <malloc+0x168a>
    2c4a:	00003517          	auipc	a0,0x3
    2c4e:	29650513          	addi	a0,a0,662 # 5ee0 <malloc+0x15ca>
    2c52:	00002097          	auipc	ra,0x2
    2c56:	886080e7          	jalr	-1914(ra) # 44d8 <link>
    2c5a:	3a050063          	beqz	a0,2ffa <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2c5e:	00003597          	auipc	a1,0x3
    2c62:	34258593          	addi	a1,a1,834 # 5fa0 <malloc+0x168a>
    2c66:	00003517          	auipc	a0,0x3
    2c6a:	2aa50513          	addi	a0,a0,682 # 5f10 <malloc+0x15fa>
    2c6e:	00002097          	auipc	ra,0x2
    2c72:	86a080e7          	jalr	-1942(ra) # 44d8 <link>
    2c76:	3a050063          	beqz	a0,3016 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2c7a:	00003597          	auipc	a1,0x3
    2c7e:	0de58593          	addi	a1,a1,222 # 5d58 <malloc+0x1442>
    2c82:	00003517          	auipc	a0,0x3
    2c86:	fce50513          	addi	a0,a0,-50 # 5c50 <malloc+0x133a>
    2c8a:	00002097          	auipc	ra,0x2
    2c8e:	84e080e7          	jalr	-1970(ra) # 44d8 <link>
    2c92:	3a050063          	beqz	a0,3032 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    2c96:	00003517          	auipc	a0,0x3
    2c9a:	24a50513          	addi	a0,a0,586 # 5ee0 <malloc+0x15ca>
    2c9e:	00002097          	auipc	ra,0x2
    2ca2:	842080e7          	jalr	-1982(ra) # 44e0 <mkdir>
    2ca6:	3a050463          	beqz	a0,304e <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    2caa:	00003517          	auipc	a0,0x3
    2cae:	26650513          	addi	a0,a0,614 # 5f10 <malloc+0x15fa>
    2cb2:	00002097          	auipc	ra,0x2
    2cb6:	82e080e7          	jalr	-2002(ra) # 44e0 <mkdir>
    2cba:	3a050863          	beqz	a0,306a <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    2cbe:	00003517          	auipc	a0,0x3
    2cc2:	09a50513          	addi	a0,a0,154 # 5d58 <malloc+0x1442>
    2cc6:	00002097          	auipc	ra,0x2
    2cca:	81a080e7          	jalr	-2022(ra) # 44e0 <mkdir>
    2cce:	3a050c63          	beqz	a0,3086 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    2cd2:	00003517          	auipc	a0,0x3
    2cd6:	23e50513          	addi	a0,a0,574 # 5f10 <malloc+0x15fa>
    2cda:	00001097          	auipc	ra,0x1
    2cde:	7ee080e7          	jalr	2030(ra) # 44c8 <unlink>
    2ce2:	3c050063          	beqz	a0,30a2 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    2ce6:	00003517          	auipc	a0,0x3
    2cea:	1fa50513          	addi	a0,a0,506 # 5ee0 <malloc+0x15ca>
    2cee:	00001097          	auipc	ra,0x1
    2cf2:	7da080e7          	jalr	2010(ra) # 44c8 <unlink>
    2cf6:	3c050463          	beqz	a0,30be <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    2cfa:	00003517          	auipc	a0,0x3
    2cfe:	f5650513          	addi	a0,a0,-170 # 5c50 <malloc+0x133a>
    2d02:	00001097          	auipc	ra,0x1
    2d06:	7e6080e7          	jalr	2022(ra) # 44e8 <chdir>
    2d0a:	3c050863          	beqz	a0,30da <subdir+0x702>
  if(chdir("dd/xx") == 0){
    2d0e:	00003517          	auipc	a0,0x3
    2d12:	3e250513          	addi	a0,a0,994 # 60f0 <malloc+0x17da>
    2d16:	00001097          	auipc	ra,0x1
    2d1a:	7d2080e7          	jalr	2002(ra) # 44e8 <chdir>
    2d1e:	3c050c63          	beqz	a0,30f6 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    2d22:	00003517          	auipc	a0,0x3
    2d26:	03650513          	addi	a0,a0,54 # 5d58 <malloc+0x1442>
    2d2a:	00001097          	auipc	ra,0x1
    2d2e:	79e080e7          	jalr	1950(ra) # 44c8 <unlink>
    2d32:	3e051063          	bnez	a0,3112 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    2d36:	00003517          	auipc	a0,0x3
    2d3a:	f1a50513          	addi	a0,a0,-230 # 5c50 <malloc+0x133a>
    2d3e:	00001097          	auipc	ra,0x1
    2d42:	78a080e7          	jalr	1930(ra) # 44c8 <unlink>
    2d46:	3e051463          	bnez	a0,312e <subdir+0x756>
  if(unlink("dd") == 0){
    2d4a:	00003517          	auipc	a0,0x3
    2d4e:	ee650513          	addi	a0,a0,-282 # 5c30 <malloc+0x131a>
    2d52:	00001097          	auipc	ra,0x1
    2d56:	776080e7          	jalr	1910(ra) # 44c8 <unlink>
    2d5a:	3e050863          	beqz	a0,314a <subdir+0x772>
  if(unlink("dd/dd") < 0){
    2d5e:	00003517          	auipc	a0,0x3
    2d62:	40250513          	addi	a0,a0,1026 # 6160 <malloc+0x184a>
    2d66:	00001097          	auipc	ra,0x1
    2d6a:	762080e7          	jalr	1890(ra) # 44c8 <unlink>
    2d6e:	3e054c63          	bltz	a0,3166 <subdir+0x78e>
  if(unlink("dd") < 0){
    2d72:	00003517          	auipc	a0,0x3
    2d76:	ebe50513          	addi	a0,a0,-322 # 5c30 <malloc+0x131a>
    2d7a:	00001097          	auipc	ra,0x1
    2d7e:	74e080e7          	jalr	1870(ra) # 44c8 <unlink>
    2d82:	40054063          	bltz	a0,3182 <subdir+0x7aa>
}
    2d86:	60e2                	ld	ra,24(sp)
    2d88:	6442                	ld	s0,16(sp)
    2d8a:	64a2                	ld	s1,8(sp)
    2d8c:	6902                	ld	s2,0(sp)
    2d8e:	6105                	addi	sp,sp,32
    2d90:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2d92:	85ca                	mv	a1,s2
    2d94:	00003517          	auipc	a0,0x3
    2d98:	ea450513          	addi	a0,a0,-348 # 5c38 <malloc+0x1322>
    2d9c:	00002097          	auipc	ra,0x2
    2da0:	a64080e7          	jalr	-1436(ra) # 4800 <printf>
    exit(1);
    2da4:	4505                	li	a0,1
    2da6:	00001097          	auipc	ra,0x1
    2daa:	6d2080e7          	jalr	1746(ra) # 4478 <exit>
    printf("%s: create dd/ff failed\n", s);
    2dae:	85ca                	mv	a1,s2
    2db0:	00003517          	auipc	a0,0x3
    2db4:	ea850513          	addi	a0,a0,-344 # 5c58 <malloc+0x1342>
    2db8:	00002097          	auipc	ra,0x2
    2dbc:	a48080e7          	jalr	-1464(ra) # 4800 <printf>
    exit(1);
    2dc0:	4505                	li	a0,1
    2dc2:	00001097          	auipc	ra,0x1
    2dc6:	6b6080e7          	jalr	1718(ra) # 4478 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2dca:	85ca                	mv	a1,s2
    2dcc:	00003517          	auipc	a0,0x3
    2dd0:	eac50513          	addi	a0,a0,-340 # 5c78 <malloc+0x1362>
    2dd4:	00002097          	auipc	ra,0x2
    2dd8:	a2c080e7          	jalr	-1492(ra) # 4800 <printf>
    exit(1);
    2ddc:	4505                	li	a0,1
    2dde:	00001097          	auipc	ra,0x1
    2de2:	69a080e7          	jalr	1690(ra) # 4478 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    2de6:	85ca                	mv	a1,s2
    2de8:	00003517          	auipc	a0,0x3
    2dec:	ec850513          	addi	a0,a0,-312 # 5cb0 <malloc+0x139a>
    2df0:	00002097          	auipc	ra,0x2
    2df4:	a10080e7          	jalr	-1520(ra) # 4800 <printf>
    exit(1);
    2df8:	4505                	li	a0,1
    2dfa:	00001097          	auipc	ra,0x1
    2dfe:	67e080e7          	jalr	1662(ra) # 4478 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2e02:	85ca                	mv	a1,s2
    2e04:	00003517          	auipc	a0,0x3
    2e08:	edc50513          	addi	a0,a0,-292 # 5ce0 <malloc+0x13ca>
    2e0c:	00002097          	auipc	ra,0x2
    2e10:	9f4080e7          	jalr	-1548(ra) # 4800 <printf>
    exit(1);
    2e14:	4505                	li	a0,1
    2e16:	00001097          	auipc	ra,0x1
    2e1a:	662080e7          	jalr	1634(ra) # 4478 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2e1e:	85ca                	mv	a1,s2
    2e20:	00003517          	auipc	a0,0x3
    2e24:	ef850513          	addi	a0,a0,-264 # 5d18 <malloc+0x1402>
    2e28:	00002097          	auipc	ra,0x2
    2e2c:	9d8080e7          	jalr	-1576(ra) # 4800 <printf>
    exit(1);
    2e30:	4505                	li	a0,1
    2e32:	00001097          	auipc	ra,0x1
    2e36:	646080e7          	jalr	1606(ra) # 4478 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2e3a:	85ca                	mv	a1,s2
    2e3c:	00003517          	auipc	a0,0x3
    2e40:	efc50513          	addi	a0,a0,-260 # 5d38 <malloc+0x1422>
    2e44:	00002097          	auipc	ra,0x2
    2e48:	9bc080e7          	jalr	-1604(ra) # 4800 <printf>
    exit(1);
    2e4c:	4505                	li	a0,1
    2e4e:	00001097          	auipc	ra,0x1
    2e52:	62a080e7          	jalr	1578(ra) # 4478 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    2e56:	85ca                	mv	a1,s2
    2e58:	00003517          	auipc	a0,0x3
    2e5c:	f1050513          	addi	a0,a0,-240 # 5d68 <malloc+0x1452>
    2e60:	00002097          	auipc	ra,0x2
    2e64:	9a0080e7          	jalr	-1632(ra) # 4800 <printf>
    exit(1);
    2e68:	4505                	li	a0,1
    2e6a:	00001097          	auipc	ra,0x1
    2e6e:	60e080e7          	jalr	1550(ra) # 4478 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2e72:	85ca                	mv	a1,s2
    2e74:	00003517          	auipc	a0,0x3
    2e78:	f1c50513          	addi	a0,a0,-228 # 5d90 <malloc+0x147a>
    2e7c:	00002097          	auipc	ra,0x2
    2e80:	984080e7          	jalr	-1660(ra) # 4800 <printf>
    exit(1);
    2e84:	4505                	li	a0,1
    2e86:	00001097          	auipc	ra,0x1
    2e8a:	5f2080e7          	jalr	1522(ra) # 4478 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2e8e:	85ca                	mv	a1,s2
    2e90:	00003517          	auipc	a0,0x3
    2e94:	f2050513          	addi	a0,a0,-224 # 5db0 <malloc+0x149a>
    2e98:	00002097          	auipc	ra,0x2
    2e9c:	968080e7          	jalr	-1688(ra) # 4800 <printf>
    exit(1);
    2ea0:	4505                	li	a0,1
    2ea2:	00001097          	auipc	ra,0x1
    2ea6:	5d6080e7          	jalr	1494(ra) # 4478 <exit>
    printf("%s: chdir dd failed\n", s);
    2eaa:	85ca                	mv	a1,s2
    2eac:	00003517          	auipc	a0,0x3
    2eb0:	f2c50513          	addi	a0,a0,-212 # 5dd8 <malloc+0x14c2>
    2eb4:	00002097          	auipc	ra,0x2
    2eb8:	94c080e7          	jalr	-1716(ra) # 4800 <printf>
    exit(1);
    2ebc:	4505                	li	a0,1
    2ebe:	00001097          	auipc	ra,0x1
    2ec2:	5ba080e7          	jalr	1466(ra) # 4478 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2ec6:	85ca                	mv	a1,s2
    2ec8:	00003517          	auipc	a0,0x3
    2ecc:	f3850513          	addi	a0,a0,-200 # 5e00 <malloc+0x14ea>
    2ed0:	00002097          	auipc	ra,0x2
    2ed4:	930080e7          	jalr	-1744(ra) # 4800 <printf>
    exit(1);
    2ed8:	4505                	li	a0,1
    2eda:	00001097          	auipc	ra,0x1
    2ede:	59e080e7          	jalr	1438(ra) # 4478 <exit>
    printf("chdir dd/../../dd failed\n", s);
    2ee2:	85ca                	mv	a1,s2
    2ee4:	00003517          	auipc	a0,0x3
    2ee8:	f4c50513          	addi	a0,a0,-180 # 5e30 <malloc+0x151a>
    2eec:	00002097          	auipc	ra,0x2
    2ef0:	914080e7          	jalr	-1772(ra) # 4800 <printf>
    exit(1);
    2ef4:	4505                	li	a0,1
    2ef6:	00001097          	auipc	ra,0x1
    2efa:	582080e7          	jalr	1410(ra) # 4478 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2efe:	85ca                	mv	a1,s2
    2f00:	00003517          	auipc	a0,0x3
    2f04:	f5850513          	addi	a0,a0,-168 # 5e58 <malloc+0x1542>
    2f08:	00002097          	auipc	ra,0x2
    2f0c:	8f8080e7          	jalr	-1800(ra) # 4800 <printf>
    exit(1);
    2f10:	4505                	li	a0,1
    2f12:	00001097          	auipc	ra,0x1
    2f16:	566080e7          	jalr	1382(ra) # 4478 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2f1a:	85ca                	mv	a1,s2
    2f1c:	00003517          	auipc	a0,0x3
    2f20:	f5450513          	addi	a0,a0,-172 # 5e70 <malloc+0x155a>
    2f24:	00002097          	auipc	ra,0x2
    2f28:	8dc080e7          	jalr	-1828(ra) # 4800 <printf>
    exit(1);
    2f2c:	4505                	li	a0,1
    2f2e:	00001097          	auipc	ra,0x1
    2f32:	54a080e7          	jalr	1354(ra) # 4478 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2f36:	85ca                	mv	a1,s2
    2f38:	00003517          	auipc	a0,0x3
    2f3c:	f5850513          	addi	a0,a0,-168 # 5e90 <malloc+0x157a>
    2f40:	00002097          	auipc	ra,0x2
    2f44:	8c0080e7          	jalr	-1856(ra) # 4800 <printf>
    exit(1);
    2f48:	4505                	li	a0,1
    2f4a:	00001097          	auipc	ra,0x1
    2f4e:	52e080e7          	jalr	1326(ra) # 4478 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2f52:	85ca                	mv	a1,s2
    2f54:	00003517          	auipc	a0,0x3
    2f58:	f5c50513          	addi	a0,a0,-164 # 5eb0 <malloc+0x159a>
    2f5c:	00002097          	auipc	ra,0x2
    2f60:	8a4080e7          	jalr	-1884(ra) # 4800 <printf>
    exit(1);
    2f64:	4505                	li	a0,1
    2f66:	00001097          	auipc	ra,0x1
    2f6a:	512080e7          	jalr	1298(ra) # 4478 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2f6e:	85ca                	mv	a1,s2
    2f70:	00003517          	auipc	a0,0x3
    2f74:	f8050513          	addi	a0,a0,-128 # 5ef0 <malloc+0x15da>
    2f78:	00002097          	auipc	ra,0x2
    2f7c:	888080e7          	jalr	-1912(ra) # 4800 <printf>
    exit(1);
    2f80:	4505                	li	a0,1
    2f82:	00001097          	auipc	ra,0x1
    2f86:	4f6080e7          	jalr	1270(ra) # 4478 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2f8a:	85ca                	mv	a1,s2
    2f8c:	00003517          	auipc	a0,0x3
    2f90:	f9450513          	addi	a0,a0,-108 # 5f20 <malloc+0x160a>
    2f94:	00002097          	auipc	ra,0x2
    2f98:	86c080e7          	jalr	-1940(ra) # 4800 <printf>
    exit(1);
    2f9c:	4505                	li	a0,1
    2f9e:	00001097          	auipc	ra,0x1
    2fa2:	4da080e7          	jalr	1242(ra) # 4478 <exit>
    printf("%s: create dd succeeded!\n", s);
    2fa6:	85ca                	mv	a1,s2
    2fa8:	00003517          	auipc	a0,0x3
    2fac:	f9850513          	addi	a0,a0,-104 # 5f40 <malloc+0x162a>
    2fb0:	00002097          	auipc	ra,0x2
    2fb4:	850080e7          	jalr	-1968(ra) # 4800 <printf>
    exit(1);
    2fb8:	4505                	li	a0,1
    2fba:	00001097          	auipc	ra,0x1
    2fbe:	4be080e7          	jalr	1214(ra) # 4478 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    2fc2:	85ca                	mv	a1,s2
    2fc4:	00003517          	auipc	a0,0x3
    2fc8:	f9c50513          	addi	a0,a0,-100 # 5f60 <malloc+0x164a>
    2fcc:	00002097          	auipc	ra,0x2
    2fd0:	834080e7          	jalr	-1996(ra) # 4800 <printf>
    exit(1);
    2fd4:	4505                	li	a0,1
    2fd6:	00001097          	auipc	ra,0x1
    2fda:	4a2080e7          	jalr	1186(ra) # 4478 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    2fde:	85ca                	mv	a1,s2
    2fe0:	00003517          	auipc	a0,0x3
    2fe4:	fa050513          	addi	a0,a0,-96 # 5f80 <malloc+0x166a>
    2fe8:	00002097          	auipc	ra,0x2
    2fec:	818080e7          	jalr	-2024(ra) # 4800 <printf>
    exit(1);
    2ff0:	4505                	li	a0,1
    2ff2:	00001097          	auipc	ra,0x1
    2ff6:	486080e7          	jalr	1158(ra) # 4478 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    2ffa:	85ca                	mv	a1,s2
    2ffc:	00003517          	auipc	a0,0x3
    3000:	fb450513          	addi	a0,a0,-76 # 5fb0 <malloc+0x169a>
    3004:	00001097          	auipc	ra,0x1
    3008:	7fc080e7          	jalr	2044(ra) # 4800 <printf>
    exit(1);
    300c:	4505                	li	a0,1
    300e:	00001097          	auipc	ra,0x1
    3012:	46a080e7          	jalr	1130(ra) # 4478 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3016:	85ca                	mv	a1,s2
    3018:	00003517          	auipc	a0,0x3
    301c:	fc050513          	addi	a0,a0,-64 # 5fd8 <malloc+0x16c2>
    3020:	00001097          	auipc	ra,0x1
    3024:	7e0080e7          	jalr	2016(ra) # 4800 <printf>
    exit(1);
    3028:	4505                	li	a0,1
    302a:	00001097          	auipc	ra,0x1
    302e:	44e080e7          	jalr	1102(ra) # 4478 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3032:	85ca                	mv	a1,s2
    3034:	00003517          	auipc	a0,0x3
    3038:	fcc50513          	addi	a0,a0,-52 # 6000 <malloc+0x16ea>
    303c:	00001097          	auipc	ra,0x1
    3040:	7c4080e7          	jalr	1988(ra) # 4800 <printf>
    exit(1);
    3044:	4505                	li	a0,1
    3046:	00001097          	auipc	ra,0x1
    304a:	432080e7          	jalr	1074(ra) # 4478 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    304e:	85ca                	mv	a1,s2
    3050:	00003517          	auipc	a0,0x3
    3054:	fd850513          	addi	a0,a0,-40 # 6028 <malloc+0x1712>
    3058:	00001097          	auipc	ra,0x1
    305c:	7a8080e7          	jalr	1960(ra) # 4800 <printf>
    exit(1);
    3060:	4505                	li	a0,1
    3062:	00001097          	auipc	ra,0x1
    3066:	416080e7          	jalr	1046(ra) # 4478 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    306a:	85ca                	mv	a1,s2
    306c:	00003517          	auipc	a0,0x3
    3070:	fdc50513          	addi	a0,a0,-36 # 6048 <malloc+0x1732>
    3074:	00001097          	auipc	ra,0x1
    3078:	78c080e7          	jalr	1932(ra) # 4800 <printf>
    exit(1);
    307c:	4505                	li	a0,1
    307e:	00001097          	auipc	ra,0x1
    3082:	3fa080e7          	jalr	1018(ra) # 4478 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3086:	85ca                	mv	a1,s2
    3088:	00003517          	auipc	a0,0x3
    308c:	fe050513          	addi	a0,a0,-32 # 6068 <malloc+0x1752>
    3090:	00001097          	auipc	ra,0x1
    3094:	770080e7          	jalr	1904(ra) # 4800 <printf>
    exit(1);
    3098:	4505                	li	a0,1
    309a:	00001097          	auipc	ra,0x1
    309e:	3de080e7          	jalr	990(ra) # 4478 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30a2:	85ca                	mv	a1,s2
    30a4:	00003517          	auipc	a0,0x3
    30a8:	fec50513          	addi	a0,a0,-20 # 6090 <malloc+0x177a>
    30ac:	00001097          	auipc	ra,0x1
    30b0:	754080e7          	jalr	1876(ra) # 4800 <printf>
    exit(1);
    30b4:	4505                	li	a0,1
    30b6:	00001097          	auipc	ra,0x1
    30ba:	3c2080e7          	jalr	962(ra) # 4478 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30be:	85ca                	mv	a1,s2
    30c0:	00003517          	auipc	a0,0x3
    30c4:	ff050513          	addi	a0,a0,-16 # 60b0 <malloc+0x179a>
    30c8:	00001097          	auipc	ra,0x1
    30cc:	738080e7          	jalr	1848(ra) # 4800 <printf>
    exit(1);
    30d0:	4505                	li	a0,1
    30d2:	00001097          	auipc	ra,0x1
    30d6:	3a6080e7          	jalr	934(ra) # 4478 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30da:	85ca                	mv	a1,s2
    30dc:	00003517          	auipc	a0,0x3
    30e0:	ff450513          	addi	a0,a0,-12 # 60d0 <malloc+0x17ba>
    30e4:	00001097          	auipc	ra,0x1
    30e8:	71c080e7          	jalr	1820(ra) # 4800 <printf>
    exit(1);
    30ec:	4505                	li	a0,1
    30ee:	00001097          	auipc	ra,0x1
    30f2:	38a080e7          	jalr	906(ra) # 4478 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    30f6:	85ca                	mv	a1,s2
    30f8:	00003517          	auipc	a0,0x3
    30fc:	00050513          	mv	a0,a0
    3100:	00001097          	auipc	ra,0x1
    3104:	700080e7          	jalr	1792(ra) # 4800 <printf>
    exit(1);
    3108:	4505                	li	a0,1
    310a:	00001097          	auipc	ra,0x1
    310e:	36e080e7          	jalr	878(ra) # 4478 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3112:	85ca                	mv	a1,s2
    3114:	00003517          	auipc	a0,0x3
    3118:	c7c50513          	addi	a0,a0,-900 # 5d90 <malloc+0x147a>
    311c:	00001097          	auipc	ra,0x1
    3120:	6e4080e7          	jalr	1764(ra) # 4800 <printf>
    exit(1);
    3124:	4505                	li	a0,1
    3126:	00001097          	auipc	ra,0x1
    312a:	352080e7          	jalr	850(ra) # 4478 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    312e:	85ca                	mv	a1,s2
    3130:	00003517          	auipc	a0,0x3
    3134:	fe850513          	addi	a0,a0,-24 # 6118 <malloc+0x1802>
    3138:	00001097          	auipc	ra,0x1
    313c:	6c8080e7          	jalr	1736(ra) # 4800 <printf>
    exit(1);
    3140:	4505                	li	a0,1
    3142:	00001097          	auipc	ra,0x1
    3146:	336080e7          	jalr	822(ra) # 4478 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    314a:	85ca                	mv	a1,s2
    314c:	00003517          	auipc	a0,0x3
    3150:	fec50513          	addi	a0,a0,-20 # 6138 <malloc+0x1822>
    3154:	00001097          	auipc	ra,0x1
    3158:	6ac080e7          	jalr	1708(ra) # 4800 <printf>
    exit(1);
    315c:	4505                	li	a0,1
    315e:	00001097          	auipc	ra,0x1
    3162:	31a080e7          	jalr	794(ra) # 4478 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3166:	85ca                	mv	a1,s2
    3168:	00003517          	auipc	a0,0x3
    316c:	00050513          	mv	a0,a0
    3170:	00001097          	auipc	ra,0x1
    3174:	690080e7          	jalr	1680(ra) # 4800 <printf>
    exit(1);
    3178:	4505                	li	a0,1
    317a:	00001097          	auipc	ra,0x1
    317e:	2fe080e7          	jalr	766(ra) # 4478 <exit>
    printf("%s: unlink dd failed\n", s);
    3182:	85ca                	mv	a1,s2
    3184:	00003517          	auipc	a0,0x3
    3188:	00450513          	addi	a0,a0,4 # 6188 <malloc+0x1872>
    318c:	00001097          	auipc	ra,0x1
    3190:	674080e7          	jalr	1652(ra) # 4800 <printf>
    exit(1);
    3194:	4505                	li	a0,1
    3196:	00001097          	auipc	ra,0x1
    319a:	2e2080e7          	jalr	738(ra) # 4478 <exit>

000000000000319e <dirfile>:
{
    319e:	1101                	addi	sp,sp,-32
    31a0:	ec06                	sd	ra,24(sp)
    31a2:	e822                	sd	s0,16(sp)
    31a4:	e426                	sd	s1,8(sp)
    31a6:	e04a                	sd	s2,0(sp)
    31a8:	1000                	addi	s0,sp,32
    31aa:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    31ac:	20000593          	li	a1,512
    31b0:	00002517          	auipc	a0,0x2
    31b4:	ab050513          	addi	a0,a0,-1360 # 4c60 <malloc+0x34a>
    31b8:	00001097          	auipc	ra,0x1
    31bc:	300080e7          	jalr	768(ra) # 44b8 <open>
  if(fd < 0){
    31c0:	0e054d63          	bltz	a0,32ba <dirfile+0x11c>
  close(fd);
    31c4:	00001097          	auipc	ra,0x1
    31c8:	2dc080e7          	jalr	732(ra) # 44a0 <close>
  if(chdir("dirfile") == 0){
    31cc:	00002517          	auipc	a0,0x2
    31d0:	a9450513          	addi	a0,a0,-1388 # 4c60 <malloc+0x34a>
    31d4:	00001097          	auipc	ra,0x1
    31d8:	314080e7          	jalr	788(ra) # 44e8 <chdir>
    31dc:	cd6d                	beqz	a0,32d6 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    31de:	4581                	li	a1,0
    31e0:	00003517          	auipc	a0,0x3
    31e4:	00050513          	mv	a0,a0
    31e8:	00001097          	auipc	ra,0x1
    31ec:	2d0080e7          	jalr	720(ra) # 44b8 <open>
  if(fd >= 0){
    31f0:	10055163          	bgez	a0,32f2 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    31f4:	20000593          	li	a1,512
    31f8:	00003517          	auipc	a0,0x3
    31fc:	fe850513          	addi	a0,a0,-24 # 61e0 <malloc+0x18ca>
    3200:	00001097          	auipc	ra,0x1
    3204:	2b8080e7          	jalr	696(ra) # 44b8 <open>
  if(fd >= 0){
    3208:	10055363          	bgez	a0,330e <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    320c:	00003517          	auipc	a0,0x3
    3210:	fd450513          	addi	a0,a0,-44 # 61e0 <malloc+0x18ca>
    3214:	00001097          	auipc	ra,0x1
    3218:	2cc080e7          	jalr	716(ra) # 44e0 <mkdir>
    321c:	10050763          	beqz	a0,332a <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3220:	00003517          	auipc	a0,0x3
    3224:	fc050513          	addi	a0,a0,-64 # 61e0 <malloc+0x18ca>
    3228:	00001097          	auipc	ra,0x1
    322c:	2a0080e7          	jalr	672(ra) # 44c8 <unlink>
    3230:	10050b63          	beqz	a0,3346 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3234:	00003597          	auipc	a1,0x3
    3238:	fac58593          	addi	a1,a1,-84 # 61e0 <malloc+0x18ca>
    323c:	00003517          	auipc	a0,0x3
    3240:	02c50513          	addi	a0,a0,44 # 6268 <malloc+0x1952>
    3244:	00001097          	auipc	ra,0x1
    3248:	294080e7          	jalr	660(ra) # 44d8 <link>
    324c:	10050b63          	beqz	a0,3362 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3250:	00002517          	auipc	a0,0x2
    3254:	a1050513          	addi	a0,a0,-1520 # 4c60 <malloc+0x34a>
    3258:	00001097          	auipc	ra,0x1
    325c:	270080e7          	jalr	624(ra) # 44c8 <unlink>
    3260:	10051f63          	bnez	a0,337e <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3264:	4589                	li	a1,2
    3266:	00002517          	auipc	a0,0x2
    326a:	b0250513          	addi	a0,a0,-1278 # 4d68 <malloc+0x452>
    326e:	00001097          	auipc	ra,0x1
    3272:	24a080e7          	jalr	586(ra) # 44b8 <open>
  if(fd >= 0){
    3276:	12055263          	bgez	a0,339a <dirfile+0x1fc>
  fd = open(".", 0);
    327a:	4581                	li	a1,0
    327c:	00002517          	auipc	a0,0x2
    3280:	aec50513          	addi	a0,a0,-1300 # 4d68 <malloc+0x452>
    3284:	00001097          	auipc	ra,0x1
    3288:	234080e7          	jalr	564(ra) # 44b8 <open>
    328c:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    328e:	4605                	li	a2,1
    3290:	00002597          	auipc	a1,0x2
    3294:	53858593          	addi	a1,a1,1336 # 57c8 <malloc+0xeb2>
    3298:	00001097          	auipc	ra,0x1
    329c:	200080e7          	jalr	512(ra) # 4498 <write>
    32a0:	10a04b63          	bgtz	a0,33b6 <dirfile+0x218>
  close(fd);
    32a4:	8526                	mv	a0,s1
    32a6:	00001097          	auipc	ra,0x1
    32aa:	1fa080e7          	jalr	506(ra) # 44a0 <close>
}
    32ae:	60e2                	ld	ra,24(sp)
    32b0:	6442                	ld	s0,16(sp)
    32b2:	64a2                	ld	s1,8(sp)
    32b4:	6902                	ld	s2,0(sp)
    32b6:	6105                	addi	sp,sp,32
    32b8:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    32ba:	85ca                	mv	a1,s2
    32bc:	00003517          	auipc	a0,0x3
    32c0:	ee450513          	addi	a0,a0,-284 # 61a0 <malloc+0x188a>
    32c4:	00001097          	auipc	ra,0x1
    32c8:	53c080e7          	jalr	1340(ra) # 4800 <printf>
    exit(1);
    32cc:	4505                	li	a0,1
    32ce:	00001097          	auipc	ra,0x1
    32d2:	1aa080e7          	jalr	426(ra) # 4478 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    32d6:	85ca                	mv	a1,s2
    32d8:	00003517          	auipc	a0,0x3
    32dc:	ee850513          	addi	a0,a0,-280 # 61c0 <malloc+0x18aa>
    32e0:	00001097          	auipc	ra,0x1
    32e4:	520080e7          	jalr	1312(ra) # 4800 <printf>
    exit(1);
    32e8:	4505                	li	a0,1
    32ea:	00001097          	auipc	ra,0x1
    32ee:	18e080e7          	jalr	398(ra) # 4478 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    32f2:	85ca                	mv	a1,s2
    32f4:	00003517          	auipc	a0,0x3
    32f8:	efc50513          	addi	a0,a0,-260 # 61f0 <malloc+0x18da>
    32fc:	00001097          	auipc	ra,0x1
    3300:	504080e7          	jalr	1284(ra) # 4800 <printf>
    exit(1);
    3304:	4505                	li	a0,1
    3306:	00001097          	auipc	ra,0x1
    330a:	172080e7          	jalr	370(ra) # 4478 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    330e:	85ca                	mv	a1,s2
    3310:	00003517          	auipc	a0,0x3
    3314:	ee050513          	addi	a0,a0,-288 # 61f0 <malloc+0x18da>
    3318:	00001097          	auipc	ra,0x1
    331c:	4e8080e7          	jalr	1256(ra) # 4800 <printf>
    exit(1);
    3320:	4505                	li	a0,1
    3322:	00001097          	auipc	ra,0x1
    3326:	156080e7          	jalr	342(ra) # 4478 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    332a:	85ca                	mv	a1,s2
    332c:	00003517          	auipc	a0,0x3
    3330:	eec50513          	addi	a0,a0,-276 # 6218 <malloc+0x1902>
    3334:	00001097          	auipc	ra,0x1
    3338:	4cc080e7          	jalr	1228(ra) # 4800 <printf>
    exit(1);
    333c:	4505                	li	a0,1
    333e:	00001097          	auipc	ra,0x1
    3342:	13a080e7          	jalr	314(ra) # 4478 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3346:	85ca                	mv	a1,s2
    3348:	00003517          	auipc	a0,0x3
    334c:	ef850513          	addi	a0,a0,-264 # 6240 <malloc+0x192a>
    3350:	00001097          	auipc	ra,0x1
    3354:	4b0080e7          	jalr	1200(ra) # 4800 <printf>
    exit(1);
    3358:	4505                	li	a0,1
    335a:	00001097          	auipc	ra,0x1
    335e:	11e080e7          	jalr	286(ra) # 4478 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3362:	85ca                	mv	a1,s2
    3364:	00003517          	auipc	a0,0x3
    3368:	f0c50513          	addi	a0,a0,-244 # 6270 <malloc+0x195a>
    336c:	00001097          	auipc	ra,0x1
    3370:	494080e7          	jalr	1172(ra) # 4800 <printf>
    exit(1);
    3374:	4505                	li	a0,1
    3376:	00001097          	auipc	ra,0x1
    337a:	102080e7          	jalr	258(ra) # 4478 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    337e:	85ca                	mv	a1,s2
    3380:	00003517          	auipc	a0,0x3
    3384:	f1850513          	addi	a0,a0,-232 # 6298 <malloc+0x1982>
    3388:	00001097          	auipc	ra,0x1
    338c:	478080e7          	jalr	1144(ra) # 4800 <printf>
    exit(1);
    3390:	4505                	li	a0,1
    3392:	00001097          	auipc	ra,0x1
    3396:	0e6080e7          	jalr	230(ra) # 4478 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    339a:	85ca                	mv	a1,s2
    339c:	00003517          	auipc	a0,0x3
    33a0:	f1c50513          	addi	a0,a0,-228 # 62b8 <malloc+0x19a2>
    33a4:	00001097          	auipc	ra,0x1
    33a8:	45c080e7          	jalr	1116(ra) # 4800 <printf>
    exit(1);
    33ac:	4505                	li	a0,1
    33ae:	00001097          	auipc	ra,0x1
    33b2:	0ca080e7          	jalr	202(ra) # 4478 <exit>
    printf("%s: write . succeeded!\n", s);
    33b6:	85ca                	mv	a1,s2
    33b8:	00003517          	auipc	a0,0x3
    33bc:	f2850513          	addi	a0,a0,-216 # 62e0 <malloc+0x19ca>
    33c0:	00001097          	auipc	ra,0x1
    33c4:	440080e7          	jalr	1088(ra) # 4800 <printf>
    exit(1);
    33c8:	4505                	li	a0,1
    33ca:	00001097          	auipc	ra,0x1
    33ce:	0ae080e7          	jalr	174(ra) # 4478 <exit>

00000000000033d2 <iref>:
{
    33d2:	7139                	addi	sp,sp,-64
    33d4:	fc06                	sd	ra,56(sp)
    33d6:	f822                	sd	s0,48(sp)
    33d8:	f426                	sd	s1,40(sp)
    33da:	f04a                	sd	s2,32(sp)
    33dc:	ec4e                	sd	s3,24(sp)
    33de:	e852                	sd	s4,16(sp)
    33e0:	e456                	sd	s5,8(sp)
    33e2:	e05a                	sd	s6,0(sp)
    33e4:	0080                	addi	s0,sp,64
    33e6:	8b2a                	mv	s6,a0
    33e8:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    33ec:	00003a17          	auipc	s4,0x3
    33f0:	f0ca0a13          	addi	s4,s4,-244 # 62f8 <malloc+0x19e2>
    mkdir("");
    33f4:	00003497          	auipc	s1,0x3
    33f8:	ae448493          	addi	s1,s1,-1308 # 5ed8 <malloc+0x15c2>
    link("README", "");
    33fc:	00003a97          	auipc	s5,0x3
    3400:	e6ca8a93          	addi	s5,s5,-404 # 6268 <malloc+0x1952>
    fd = open("xx", O_CREATE);
    3404:	00003997          	auipc	s3,0x3
    3408:	de498993          	addi	s3,s3,-540 # 61e8 <malloc+0x18d2>
    340c:	a891                	j	3460 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    340e:	85da                	mv	a1,s6
    3410:	00003517          	auipc	a0,0x3
    3414:	ef050513          	addi	a0,a0,-272 # 6300 <malloc+0x19ea>
    3418:	00001097          	auipc	ra,0x1
    341c:	3e8080e7          	jalr	1000(ra) # 4800 <printf>
      exit(1);
    3420:	4505                	li	a0,1
    3422:	00001097          	auipc	ra,0x1
    3426:	056080e7          	jalr	86(ra) # 4478 <exit>
      printf("%s: chdir irefd failed\n", s);
    342a:	85da                	mv	a1,s6
    342c:	00003517          	auipc	a0,0x3
    3430:	eec50513          	addi	a0,a0,-276 # 6318 <malloc+0x1a02>
    3434:	00001097          	auipc	ra,0x1
    3438:	3cc080e7          	jalr	972(ra) # 4800 <printf>
      exit(1);
    343c:	4505                	li	a0,1
    343e:	00001097          	auipc	ra,0x1
    3442:	03a080e7          	jalr	58(ra) # 4478 <exit>
      close(fd);
    3446:	00001097          	auipc	ra,0x1
    344a:	05a080e7          	jalr	90(ra) # 44a0 <close>
    344e:	a889                	j	34a0 <iref+0xce>
    unlink("xx");
    3450:	854e                	mv	a0,s3
    3452:	00001097          	auipc	ra,0x1
    3456:	076080e7          	jalr	118(ra) # 44c8 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    345a:	397d                	addiw	s2,s2,-1
    345c:	06090063          	beqz	s2,34bc <iref+0xea>
    if(mkdir("irefd") != 0){
    3460:	8552                	mv	a0,s4
    3462:	00001097          	auipc	ra,0x1
    3466:	07e080e7          	jalr	126(ra) # 44e0 <mkdir>
    346a:	f155                	bnez	a0,340e <iref+0x3c>
    if(chdir("irefd") != 0){
    346c:	8552                	mv	a0,s4
    346e:	00001097          	auipc	ra,0x1
    3472:	07a080e7          	jalr	122(ra) # 44e8 <chdir>
    3476:	f955                	bnez	a0,342a <iref+0x58>
    mkdir("");
    3478:	8526                	mv	a0,s1
    347a:	00001097          	auipc	ra,0x1
    347e:	066080e7          	jalr	102(ra) # 44e0 <mkdir>
    link("README", "");
    3482:	85a6                	mv	a1,s1
    3484:	8556                	mv	a0,s5
    3486:	00001097          	auipc	ra,0x1
    348a:	052080e7          	jalr	82(ra) # 44d8 <link>
    fd = open("", O_CREATE);
    348e:	20000593          	li	a1,512
    3492:	8526                	mv	a0,s1
    3494:	00001097          	auipc	ra,0x1
    3498:	024080e7          	jalr	36(ra) # 44b8 <open>
    if(fd >= 0)
    349c:	fa0555e3          	bgez	a0,3446 <iref+0x74>
    fd = open("xx", O_CREATE);
    34a0:	20000593          	li	a1,512
    34a4:	854e                	mv	a0,s3
    34a6:	00001097          	auipc	ra,0x1
    34aa:	012080e7          	jalr	18(ra) # 44b8 <open>
    if(fd >= 0)
    34ae:	fa0541e3          	bltz	a0,3450 <iref+0x7e>
      close(fd);
    34b2:	00001097          	auipc	ra,0x1
    34b6:	fee080e7          	jalr	-18(ra) # 44a0 <close>
    34ba:	bf59                	j	3450 <iref+0x7e>
  chdir("/");
    34bc:	00002517          	auipc	a0,0x2
    34c0:	85450513          	addi	a0,a0,-1964 # 4d10 <malloc+0x3fa>
    34c4:	00001097          	auipc	ra,0x1
    34c8:	024080e7          	jalr	36(ra) # 44e8 <chdir>
}
    34cc:	70e2                	ld	ra,56(sp)
    34ce:	7442                	ld	s0,48(sp)
    34d0:	74a2                	ld	s1,40(sp)
    34d2:	7902                	ld	s2,32(sp)
    34d4:	69e2                	ld	s3,24(sp)
    34d6:	6a42                	ld	s4,16(sp)
    34d8:	6aa2                	ld	s5,8(sp)
    34da:	6b02                	ld	s6,0(sp)
    34dc:	6121                	addi	sp,sp,64
    34de:	8082                	ret

00000000000034e0 <validatetest>:
{
    34e0:	7139                	addi	sp,sp,-64
    34e2:	fc06                	sd	ra,56(sp)
    34e4:	f822                	sd	s0,48(sp)
    34e6:	f426                	sd	s1,40(sp)
    34e8:	f04a                	sd	s2,32(sp)
    34ea:	ec4e                	sd	s3,24(sp)
    34ec:	e852                	sd	s4,16(sp)
    34ee:	e456                	sd	s5,8(sp)
    34f0:	e05a                	sd	s6,0(sp)
    34f2:	0080                	addi	s0,sp,64
    34f4:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    34f6:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    34f8:	00003997          	auipc	s3,0x3
    34fc:	e3898993          	addi	s3,s3,-456 # 6330 <malloc+0x1a1a>
    3500:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    3502:	6a85                	lui	s5,0x1
    3504:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    3508:	85a6                	mv	a1,s1
    350a:	854e                	mv	a0,s3
    350c:	00001097          	auipc	ra,0x1
    3510:	fcc080e7          	jalr	-52(ra) # 44d8 <link>
    3514:	01251f63          	bne	a0,s2,3532 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    3518:	94d6                	add	s1,s1,s5
    351a:	ff4497e3          	bne	s1,s4,3508 <validatetest+0x28>
}
    351e:	70e2                	ld	ra,56(sp)
    3520:	7442                	ld	s0,48(sp)
    3522:	74a2                	ld	s1,40(sp)
    3524:	7902                	ld	s2,32(sp)
    3526:	69e2                	ld	s3,24(sp)
    3528:	6a42                	ld	s4,16(sp)
    352a:	6aa2                	ld	s5,8(sp)
    352c:	6b02                	ld	s6,0(sp)
    352e:	6121                	addi	sp,sp,64
    3530:	8082                	ret
      printf("%s: link should not succeed\n", s);
    3532:	85da                	mv	a1,s6
    3534:	00003517          	auipc	a0,0x3
    3538:	e0c50513          	addi	a0,a0,-500 # 6340 <malloc+0x1a2a>
    353c:	00001097          	auipc	ra,0x1
    3540:	2c4080e7          	jalr	708(ra) # 4800 <printf>
      exit(1);
    3544:	4505                	li	a0,1
    3546:	00001097          	auipc	ra,0x1
    354a:	f32080e7          	jalr	-206(ra) # 4478 <exit>

000000000000354e <sbrkbasic>:
{
    354e:	7139                	addi	sp,sp,-64
    3550:	fc06                	sd	ra,56(sp)
    3552:	f822                	sd	s0,48(sp)
    3554:	f426                	sd	s1,40(sp)
    3556:	f04a                	sd	s2,32(sp)
    3558:	ec4e                	sd	s3,24(sp)
    355a:	e852                	sd	s4,16(sp)
    355c:	0080                	addi	s0,sp,64
    355e:	8a2a                	mv	s4,a0
  a = sbrk(TOOMUCH);
    3560:	40000537          	lui	a0,0x40000
    3564:	00001097          	auipc	ra,0x1
    3568:	f9c080e7          	jalr	-100(ra) # 4500 <sbrk>
  if(a != (char*)0xffffffffffffffffL){
    356c:	57fd                	li	a5,-1
    356e:	02f50063          	beq	a0,a5,358e <sbrkbasic+0x40>
    3572:	85aa                	mv	a1,a0
    printf("%s: sbrk(<toomuch>) returned %p\n", a);
    3574:	00003517          	auipc	a0,0x3
    3578:	dec50513          	addi	a0,a0,-532 # 6360 <malloc+0x1a4a>
    357c:	00001097          	auipc	ra,0x1
    3580:	284080e7          	jalr	644(ra) # 4800 <printf>
    exit(1);
    3584:	4505                	li	a0,1
    3586:	00001097          	auipc	ra,0x1
    358a:	ef2080e7          	jalr	-270(ra) # 4478 <exit>
  a = sbrk(0);
    358e:	4501                	li	a0,0
    3590:	00001097          	auipc	ra,0x1
    3594:	f70080e7          	jalr	-144(ra) # 4500 <sbrk>
    3598:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    359a:	4901                	li	s2,0
    359c:	6985                	lui	s3,0x1
    359e:	38898993          	addi	s3,s3,904 # 1388 <unlinkread+0x10e>
    35a2:	a011                	j	35a6 <sbrkbasic+0x58>
    a = b + 1;
    35a4:	84be                	mv	s1,a5
    b = sbrk(1);
    35a6:	4505                	li	a0,1
    35a8:	00001097          	auipc	ra,0x1
    35ac:	f58080e7          	jalr	-168(ra) # 4500 <sbrk>
    if(b != a){
    35b0:	04951c63          	bne	a0,s1,3608 <sbrkbasic+0xba>
    *b = 1;
    35b4:	4785                	li	a5,1
    35b6:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    35ba:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    35be:	2905                	addiw	s2,s2,1
    35c0:	ff3912e3          	bne	s2,s3,35a4 <sbrkbasic+0x56>
  pid = fork();
    35c4:	00001097          	auipc	ra,0x1
    35c8:	eac080e7          	jalr	-340(ra) # 4470 <fork>
    35cc:	892a                	mv	s2,a0
  if(pid < 0){
    35ce:	04054d63          	bltz	a0,3628 <sbrkbasic+0xda>
  c = sbrk(1);
    35d2:	4505                	li	a0,1
    35d4:	00001097          	auipc	ra,0x1
    35d8:	f2c080e7          	jalr	-212(ra) # 4500 <sbrk>
  c = sbrk(1);
    35dc:	4505                	li	a0,1
    35de:	00001097          	auipc	ra,0x1
    35e2:	f22080e7          	jalr	-222(ra) # 4500 <sbrk>
  if(c != a + 1){
    35e6:	0489                	addi	s1,s1,2
    35e8:	04a48e63          	beq	s1,a0,3644 <sbrkbasic+0xf6>
    printf("%s: sbrk test failed post-fork\n", s);
    35ec:	85d2                	mv	a1,s4
    35ee:	00003517          	auipc	a0,0x3
    35f2:	dda50513          	addi	a0,a0,-550 # 63c8 <malloc+0x1ab2>
    35f6:	00001097          	auipc	ra,0x1
    35fa:	20a080e7          	jalr	522(ra) # 4800 <printf>
    exit(1);
    35fe:	4505                	li	a0,1
    3600:	00001097          	auipc	ra,0x1
    3604:	e78080e7          	jalr	-392(ra) # 4478 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    3608:	86aa                	mv	a3,a0
    360a:	8626                	mv	a2,s1
    360c:	85ca                	mv	a1,s2
    360e:	00003517          	auipc	a0,0x3
    3612:	d7a50513          	addi	a0,a0,-646 # 6388 <malloc+0x1a72>
    3616:	00001097          	auipc	ra,0x1
    361a:	1ea080e7          	jalr	490(ra) # 4800 <printf>
      exit(1);
    361e:	4505                	li	a0,1
    3620:	00001097          	auipc	ra,0x1
    3624:	e58080e7          	jalr	-424(ra) # 4478 <exit>
    printf("%s: sbrk test fork failed\n", s);
    3628:	85d2                	mv	a1,s4
    362a:	00003517          	auipc	a0,0x3
    362e:	d7e50513          	addi	a0,a0,-642 # 63a8 <malloc+0x1a92>
    3632:	00001097          	auipc	ra,0x1
    3636:	1ce080e7          	jalr	462(ra) # 4800 <printf>
    exit(1);
    363a:	4505                	li	a0,1
    363c:	00001097          	auipc	ra,0x1
    3640:	e3c080e7          	jalr	-452(ra) # 4478 <exit>
  if(pid == 0)
    3644:	00091763          	bnez	s2,3652 <sbrkbasic+0x104>
    exit(0);
    3648:	4501                	li	a0,0
    364a:	00001097          	auipc	ra,0x1
    364e:	e2e080e7          	jalr	-466(ra) # 4478 <exit>
  wait(&xstatus);
    3652:	fcc40513          	addi	a0,s0,-52
    3656:	00001097          	auipc	ra,0x1
    365a:	e2a080e7          	jalr	-470(ra) # 4480 <wait>
  exit(xstatus);
    365e:	fcc42503          	lw	a0,-52(s0)
    3662:	00001097          	auipc	ra,0x1
    3666:	e16080e7          	jalr	-490(ra) # 4478 <exit>

000000000000366a <sbrkmuch>:
{
    366a:	7179                	addi	sp,sp,-48
    366c:	f406                	sd	ra,40(sp)
    366e:	f022                	sd	s0,32(sp)
    3670:	ec26                	sd	s1,24(sp)
    3672:	e84a                	sd	s2,16(sp)
    3674:	e44e                	sd	s3,8(sp)
    3676:	e052                	sd	s4,0(sp)
    3678:	1800                	addi	s0,sp,48
    367a:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    367c:	4501                	li	a0,0
    367e:	00001097          	auipc	ra,0x1
    3682:	e82080e7          	jalr	-382(ra) # 4500 <sbrk>
    3686:	892a                	mv	s2,a0
  a = sbrk(0);
    3688:	4501                	li	a0,0
    368a:	00001097          	auipc	ra,0x1
    368e:	e76080e7          	jalr	-394(ra) # 4500 <sbrk>
    3692:	84aa                	mv	s1,a0
  p = sbrk(amt);
    3694:	06400537          	lui	a0,0x6400
    3698:	9d05                	subw	a0,a0,s1
    369a:	00001097          	auipc	ra,0x1
    369e:	e66080e7          	jalr	-410(ra) # 4500 <sbrk>
  if (p != a) {
    36a2:	0aa49963          	bne	s1,a0,3754 <sbrkmuch+0xea>
  *lastaddr = 99;
    36a6:	064007b7          	lui	a5,0x6400
    36aa:	06300713          	li	a4,99
    36ae:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f3cf7>
  a = sbrk(0);
    36b2:	4501                	li	a0,0
    36b4:	00001097          	auipc	ra,0x1
    36b8:	e4c080e7          	jalr	-436(ra) # 4500 <sbrk>
    36bc:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    36be:	757d                	lui	a0,0xfffff
    36c0:	00001097          	auipc	ra,0x1
    36c4:	e40080e7          	jalr	-448(ra) # 4500 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    36c8:	57fd                	li	a5,-1
    36ca:	0af50363          	beq	a0,a5,3770 <sbrkmuch+0x106>
  c = sbrk(0);
    36ce:	4501                	li	a0,0
    36d0:	00001097          	auipc	ra,0x1
    36d4:	e30080e7          	jalr	-464(ra) # 4500 <sbrk>
  if(c != a - PGSIZE){
    36d8:	77fd                	lui	a5,0xfffff
    36da:	97a6                	add	a5,a5,s1
    36dc:	0af51863          	bne	a0,a5,378c <sbrkmuch+0x122>
  a = sbrk(0);
    36e0:	4501                	li	a0,0
    36e2:	00001097          	auipc	ra,0x1
    36e6:	e1e080e7          	jalr	-482(ra) # 4500 <sbrk>
    36ea:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    36ec:	6505                	lui	a0,0x1
    36ee:	00001097          	auipc	ra,0x1
    36f2:	e12080e7          	jalr	-494(ra) # 4500 <sbrk>
    36f6:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    36f8:	0aa49963          	bne	s1,a0,37aa <sbrkmuch+0x140>
    36fc:	4501                	li	a0,0
    36fe:	00001097          	auipc	ra,0x1
    3702:	e02080e7          	jalr	-510(ra) # 4500 <sbrk>
    3706:	6785                	lui	a5,0x1
    3708:	97a6                	add	a5,a5,s1
    370a:	0af51063          	bne	a0,a5,37aa <sbrkmuch+0x140>
  if(*lastaddr == 99){
    370e:	064007b7          	lui	a5,0x6400
    3712:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f3cf7>
    3716:	06300793          	li	a5,99
    371a:	0af70763          	beq	a4,a5,37c8 <sbrkmuch+0x15e>
  a = sbrk(0);
    371e:	4501                	li	a0,0
    3720:	00001097          	auipc	ra,0x1
    3724:	de0080e7          	jalr	-544(ra) # 4500 <sbrk>
    3728:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    372a:	4501                	li	a0,0
    372c:	00001097          	auipc	ra,0x1
    3730:	dd4080e7          	jalr	-556(ra) # 4500 <sbrk>
    3734:	40a9053b          	subw	a0,s2,a0
    3738:	00001097          	auipc	ra,0x1
    373c:	dc8080e7          	jalr	-568(ra) # 4500 <sbrk>
  if(c != a){
    3740:	0aa49263          	bne	s1,a0,37e4 <sbrkmuch+0x17a>
}
    3744:	70a2                	ld	ra,40(sp)
    3746:	7402                	ld	s0,32(sp)
    3748:	64e2                	ld	s1,24(sp)
    374a:	6942                	ld	s2,16(sp)
    374c:	69a2                	ld	s3,8(sp)
    374e:	6a02                	ld	s4,0(sp)
    3750:	6145                	addi	sp,sp,48
    3752:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    3754:	85ce                	mv	a1,s3
    3756:	00003517          	auipc	a0,0x3
    375a:	c9250513          	addi	a0,a0,-878 # 63e8 <malloc+0x1ad2>
    375e:	00001097          	auipc	ra,0x1
    3762:	0a2080e7          	jalr	162(ra) # 4800 <printf>
    exit(1);
    3766:	4505                	li	a0,1
    3768:	00001097          	auipc	ra,0x1
    376c:	d10080e7          	jalr	-752(ra) # 4478 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    3770:	85ce                	mv	a1,s3
    3772:	00003517          	auipc	a0,0x3
    3776:	cbe50513          	addi	a0,a0,-834 # 6430 <malloc+0x1b1a>
    377a:	00001097          	auipc	ra,0x1
    377e:	086080e7          	jalr	134(ra) # 4800 <printf>
    exit(1);
    3782:	4505                	li	a0,1
    3784:	00001097          	auipc	ra,0x1
    3788:	cf4080e7          	jalr	-780(ra) # 4478 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    378c:	862a                	mv	a2,a0
    378e:	85a6                	mv	a1,s1
    3790:	00003517          	auipc	a0,0x3
    3794:	cc050513          	addi	a0,a0,-832 # 6450 <malloc+0x1b3a>
    3798:	00001097          	auipc	ra,0x1
    379c:	068080e7          	jalr	104(ra) # 4800 <printf>
    exit(1);
    37a0:	4505                	li	a0,1
    37a2:	00001097          	auipc	ra,0x1
    37a6:	cd6080e7          	jalr	-810(ra) # 4478 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    37aa:	8652                	mv	a2,s4
    37ac:	85a6                	mv	a1,s1
    37ae:	00003517          	auipc	a0,0x3
    37b2:	ce250513          	addi	a0,a0,-798 # 6490 <malloc+0x1b7a>
    37b6:	00001097          	auipc	ra,0x1
    37ba:	04a080e7          	jalr	74(ra) # 4800 <printf>
    exit(1);
    37be:	4505                	li	a0,1
    37c0:	00001097          	auipc	ra,0x1
    37c4:	cb8080e7          	jalr	-840(ra) # 4478 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    37c8:	85ce                	mv	a1,s3
    37ca:	00003517          	auipc	a0,0x3
    37ce:	cf650513          	addi	a0,a0,-778 # 64c0 <malloc+0x1baa>
    37d2:	00001097          	auipc	ra,0x1
    37d6:	02e080e7          	jalr	46(ra) # 4800 <printf>
    exit(1);
    37da:	4505                	li	a0,1
    37dc:	00001097          	auipc	ra,0x1
    37e0:	c9c080e7          	jalr	-868(ra) # 4478 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    37e4:	862a                	mv	a2,a0
    37e6:	85a6                	mv	a1,s1
    37e8:	00003517          	auipc	a0,0x3
    37ec:	d1050513          	addi	a0,a0,-752 # 64f8 <malloc+0x1be2>
    37f0:	00001097          	auipc	ra,0x1
    37f4:	010080e7          	jalr	16(ra) # 4800 <printf>
    exit(1);
    37f8:	4505                	li	a0,1
    37fa:	00001097          	auipc	ra,0x1
    37fe:	c7e080e7          	jalr	-898(ra) # 4478 <exit>

0000000000003802 <sbrkfail>:
{
    3802:	7119                	addi	sp,sp,-128
    3804:	fc86                	sd	ra,120(sp)
    3806:	f8a2                	sd	s0,112(sp)
    3808:	f4a6                	sd	s1,104(sp)
    380a:	f0ca                	sd	s2,96(sp)
    380c:	ecce                	sd	s3,88(sp)
    380e:	e8d2                	sd	s4,80(sp)
    3810:	e4d6                	sd	s5,72(sp)
    3812:	0100                	addi	s0,sp,128
    3814:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    3816:	fb040513          	addi	a0,s0,-80
    381a:	00001097          	auipc	ra,0x1
    381e:	c6e080e7          	jalr	-914(ra) # 4488 <pipe>
    3822:	e901                	bnez	a0,3832 <sbrkfail+0x30>
    3824:	f8040493          	addi	s1,s0,-128
    3828:	fa840a13          	addi	s4,s0,-88
    382c:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    382e:	5afd                	li	s5,-1
    3830:	a08d                	j	3892 <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    3832:	85ca                	mv	a1,s2
    3834:	00002517          	auipc	a0,0x2
    3838:	f1450513          	addi	a0,a0,-236 # 5748 <malloc+0xe32>
    383c:	00001097          	auipc	ra,0x1
    3840:	fc4080e7          	jalr	-60(ra) # 4800 <printf>
    exit(1);
    3844:	4505                	li	a0,1
    3846:	00001097          	auipc	ra,0x1
    384a:	c32080e7          	jalr	-974(ra) # 4478 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    384e:	4501                	li	a0,0
    3850:	00001097          	auipc	ra,0x1
    3854:	cb0080e7          	jalr	-848(ra) # 4500 <sbrk>
    3858:	064007b7          	lui	a5,0x6400
    385c:	40a7853b          	subw	a0,a5,a0
    3860:	00001097          	auipc	ra,0x1
    3864:	ca0080e7          	jalr	-864(ra) # 4500 <sbrk>
      write(fds[1], "x", 1);
    3868:	4605                	li	a2,1
    386a:	00002597          	auipc	a1,0x2
    386e:	f5e58593          	addi	a1,a1,-162 # 57c8 <malloc+0xeb2>
    3872:	fb442503          	lw	a0,-76(s0)
    3876:	00001097          	auipc	ra,0x1
    387a:	c22080e7          	jalr	-990(ra) # 4498 <write>
      for(;;) sleep(1000);
    387e:	3e800513          	li	a0,1000
    3882:	00001097          	auipc	ra,0x1
    3886:	c86080e7          	jalr	-890(ra) # 4508 <sleep>
    388a:	bfd5                	j	387e <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    388c:	0991                	addi	s3,s3,4
    388e:	03498563          	beq	s3,s4,38b8 <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    3892:	00001097          	auipc	ra,0x1
    3896:	bde080e7          	jalr	-1058(ra) # 4470 <fork>
    389a:	00a9a023          	sw	a0,0(s3)
    389e:	d945                	beqz	a0,384e <sbrkfail+0x4c>
    if(pids[i] != -1)
    38a0:	ff5506e3          	beq	a0,s5,388c <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    38a4:	4605                	li	a2,1
    38a6:	faf40593          	addi	a1,s0,-81
    38aa:	fb042503          	lw	a0,-80(s0)
    38ae:	00001097          	auipc	ra,0x1
    38b2:	be2080e7          	jalr	-1054(ra) # 4490 <read>
    38b6:	bfd9                	j	388c <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    38b8:	6505                	lui	a0,0x1
    38ba:	00001097          	auipc	ra,0x1
    38be:	c46080e7          	jalr	-954(ra) # 4500 <sbrk>
    38c2:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    38c4:	5afd                	li	s5,-1
    38c6:	a021                	j	38ce <sbrkfail+0xcc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    38c8:	0491                	addi	s1,s1,4
    38ca:	01448f63          	beq	s1,s4,38e8 <sbrkfail+0xe6>
    if(pids[i] == -1)
    38ce:	4088                	lw	a0,0(s1)
    38d0:	ff550ce3          	beq	a0,s5,38c8 <sbrkfail+0xc6>
    kill(pids[i]);
    38d4:	00001097          	auipc	ra,0x1
    38d8:	bd4080e7          	jalr	-1068(ra) # 44a8 <kill>
    wait(0);
    38dc:	4501                	li	a0,0
    38de:	00001097          	auipc	ra,0x1
    38e2:	ba2080e7          	jalr	-1118(ra) # 4480 <wait>
    38e6:	b7cd                	j	38c8 <sbrkfail+0xc6>
  if(c == (char*)0xffffffffffffffffL){
    38e8:	57fd                	li	a5,-1
    38ea:	02f98e63          	beq	s3,a5,3926 <sbrkfail+0x124>
  pid = fork();
    38ee:	00001097          	auipc	ra,0x1
    38f2:	b82080e7          	jalr	-1150(ra) # 4470 <fork>
    38f6:	84aa                	mv	s1,a0
  if(pid < 0){
    38f8:	04054563          	bltz	a0,3942 <sbrkfail+0x140>
  if(pid == 0){
    38fc:	c12d                	beqz	a0,395e <sbrkfail+0x15c>
  wait(&xstatus);
    38fe:	fbc40513          	addi	a0,s0,-68
    3902:	00001097          	auipc	ra,0x1
    3906:	b7e080e7          	jalr	-1154(ra) # 4480 <wait>
  if(xstatus != -1)
    390a:	fbc42703          	lw	a4,-68(s0)
    390e:	57fd                	li	a5,-1
    3910:	08f71c63          	bne	a4,a5,39a8 <sbrkfail+0x1a6>
}
    3914:	70e6                	ld	ra,120(sp)
    3916:	7446                	ld	s0,112(sp)
    3918:	74a6                	ld	s1,104(sp)
    391a:	7906                	ld	s2,96(sp)
    391c:	69e6                	ld	s3,88(sp)
    391e:	6a46                	ld	s4,80(sp)
    3920:	6aa6                	ld	s5,72(sp)
    3922:	6109                	addi	sp,sp,128
    3924:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3926:	85ca                	mv	a1,s2
    3928:	00003517          	auipc	a0,0x3
    392c:	bf850513          	addi	a0,a0,-1032 # 6520 <malloc+0x1c0a>
    3930:	00001097          	auipc	ra,0x1
    3934:	ed0080e7          	jalr	-304(ra) # 4800 <printf>
    exit(1);
    3938:	4505                	li	a0,1
    393a:	00001097          	auipc	ra,0x1
    393e:	b3e080e7          	jalr	-1218(ra) # 4478 <exit>
    printf("%s: fork failed\n", s);
    3942:	85ca                	mv	a1,s2
    3944:	00001517          	auipc	a0,0x1
    3948:	4d450513          	addi	a0,a0,1236 # 4e18 <malloc+0x502>
    394c:	00001097          	auipc	ra,0x1
    3950:	eb4080e7          	jalr	-332(ra) # 4800 <printf>
    exit(1);
    3954:	4505                	li	a0,1
    3956:	00001097          	auipc	ra,0x1
    395a:	b22080e7          	jalr	-1246(ra) # 4478 <exit>
    a = sbrk(0);
    395e:	4501                	li	a0,0
    3960:	00001097          	auipc	ra,0x1
    3964:	ba0080e7          	jalr	-1120(ra) # 4500 <sbrk>
    3968:	892a                	mv	s2,a0
    sbrk(10*BIG);
    396a:	3e800537          	lui	a0,0x3e800
    396e:	00001097          	auipc	ra,0x1
    3972:	b92080e7          	jalr	-1134(ra) # 4500 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3976:	874a                	mv	a4,s2
    3978:	3e8007b7          	lui	a5,0x3e800
    397c:	97ca                	add	a5,a5,s2
    397e:	6685                	lui	a3,0x1
      n += *(a+i);
    3980:	00074603          	lbu	a2,0(a4)
    3984:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3986:	9736                	add	a4,a4,a3
    3988:	fef71ce3          	bne	a4,a5,3980 <sbrkfail+0x17e>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    398c:	85a6                	mv	a1,s1
    398e:	00003517          	auipc	a0,0x3
    3992:	bb250513          	addi	a0,a0,-1102 # 6540 <malloc+0x1c2a>
    3996:	00001097          	auipc	ra,0x1
    399a:	e6a080e7          	jalr	-406(ra) # 4800 <printf>
    exit(1);
    399e:	4505                	li	a0,1
    39a0:	00001097          	auipc	ra,0x1
    39a4:	ad8080e7          	jalr	-1320(ra) # 4478 <exit>
    exit(1);
    39a8:	4505                	li	a0,1
    39aa:	00001097          	auipc	ra,0x1
    39ae:	ace080e7          	jalr	-1330(ra) # 4478 <exit>

00000000000039b2 <sbrkarg>:
{
    39b2:	7179                	addi	sp,sp,-48
    39b4:	f406                	sd	ra,40(sp)
    39b6:	f022                	sd	s0,32(sp)
    39b8:	ec26                	sd	s1,24(sp)
    39ba:	e84a                	sd	s2,16(sp)
    39bc:	e44e                	sd	s3,8(sp)
    39be:	1800                	addi	s0,sp,48
    39c0:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    39c2:	6505                	lui	a0,0x1
    39c4:	00001097          	auipc	ra,0x1
    39c8:	b3c080e7          	jalr	-1220(ra) # 4500 <sbrk>
    39cc:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    39ce:	20100593          	li	a1,513
    39d2:	00003517          	auipc	a0,0x3
    39d6:	b9e50513          	addi	a0,a0,-1122 # 6570 <malloc+0x1c5a>
    39da:	00001097          	auipc	ra,0x1
    39de:	ade080e7          	jalr	-1314(ra) # 44b8 <open>
    39e2:	84aa                	mv	s1,a0
  unlink("sbrk");
    39e4:	00003517          	auipc	a0,0x3
    39e8:	b8c50513          	addi	a0,a0,-1140 # 6570 <malloc+0x1c5a>
    39ec:	00001097          	auipc	ra,0x1
    39f0:	adc080e7          	jalr	-1316(ra) # 44c8 <unlink>
  if(fd < 0)  {
    39f4:	0404c163          	bltz	s1,3a36 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    39f8:	6605                	lui	a2,0x1
    39fa:	85ca                	mv	a1,s2
    39fc:	8526                	mv	a0,s1
    39fe:	00001097          	auipc	ra,0x1
    3a02:	a9a080e7          	jalr	-1382(ra) # 4498 <write>
    3a06:	04054663          	bltz	a0,3a52 <sbrkarg+0xa0>
  close(fd);
    3a0a:	8526                	mv	a0,s1
    3a0c:	00001097          	auipc	ra,0x1
    3a10:	a94080e7          	jalr	-1388(ra) # 44a0 <close>
  a = sbrk(PGSIZE);
    3a14:	6505                	lui	a0,0x1
    3a16:	00001097          	auipc	ra,0x1
    3a1a:	aea080e7          	jalr	-1302(ra) # 4500 <sbrk>
  if(pipe((int *) a) != 0){
    3a1e:	00001097          	auipc	ra,0x1
    3a22:	a6a080e7          	jalr	-1430(ra) # 4488 <pipe>
    3a26:	e521                	bnez	a0,3a6e <sbrkarg+0xbc>
}
    3a28:	70a2                	ld	ra,40(sp)
    3a2a:	7402                	ld	s0,32(sp)
    3a2c:	64e2                	ld	s1,24(sp)
    3a2e:	6942                	ld	s2,16(sp)
    3a30:	69a2                	ld	s3,8(sp)
    3a32:	6145                	addi	sp,sp,48
    3a34:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    3a36:	85ce                	mv	a1,s3
    3a38:	00003517          	auipc	a0,0x3
    3a3c:	b4050513          	addi	a0,a0,-1216 # 6578 <malloc+0x1c62>
    3a40:	00001097          	auipc	ra,0x1
    3a44:	dc0080e7          	jalr	-576(ra) # 4800 <printf>
    exit(1);
    3a48:	4505                	li	a0,1
    3a4a:	00001097          	auipc	ra,0x1
    3a4e:	a2e080e7          	jalr	-1490(ra) # 4478 <exit>
    printf("%s: write sbrk failed\n", s);
    3a52:	85ce                	mv	a1,s3
    3a54:	00003517          	auipc	a0,0x3
    3a58:	b3c50513          	addi	a0,a0,-1220 # 6590 <malloc+0x1c7a>
    3a5c:	00001097          	auipc	ra,0x1
    3a60:	da4080e7          	jalr	-604(ra) # 4800 <printf>
    exit(1);
    3a64:	4505                	li	a0,1
    3a66:	00001097          	auipc	ra,0x1
    3a6a:	a12080e7          	jalr	-1518(ra) # 4478 <exit>
    printf("%s: pipe() failed\n", s);
    3a6e:	85ce                	mv	a1,s3
    3a70:	00002517          	auipc	a0,0x2
    3a74:	cd850513          	addi	a0,a0,-808 # 5748 <malloc+0xe32>
    3a78:	00001097          	auipc	ra,0x1
    3a7c:	d88080e7          	jalr	-632(ra) # 4800 <printf>
    exit(1);
    3a80:	4505                	li	a0,1
    3a82:	00001097          	auipc	ra,0x1
    3a86:	9f6080e7          	jalr	-1546(ra) # 4478 <exit>

0000000000003a8a <argptest>:
{
    3a8a:	1101                	addi	sp,sp,-32
    3a8c:	ec06                	sd	ra,24(sp)
    3a8e:	e822                	sd	s0,16(sp)
    3a90:	e426                	sd	s1,8(sp)
    3a92:	e04a                	sd	s2,0(sp)
    3a94:	1000                	addi	s0,sp,32
    3a96:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    3a98:	4581                	li	a1,0
    3a9a:	00003517          	auipc	a0,0x3
    3a9e:	b0e50513          	addi	a0,a0,-1266 # 65a8 <malloc+0x1c92>
    3aa2:	00001097          	auipc	ra,0x1
    3aa6:	a16080e7          	jalr	-1514(ra) # 44b8 <open>
  if (fd < 0) {
    3aaa:	02054b63          	bltz	a0,3ae0 <argptest+0x56>
    3aae:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    3ab0:	4501                	li	a0,0
    3ab2:	00001097          	auipc	ra,0x1
    3ab6:	a4e080e7          	jalr	-1458(ra) # 4500 <sbrk>
    3aba:	567d                	li	a2,-1
    3abc:	fff50593          	addi	a1,a0,-1
    3ac0:	8526                	mv	a0,s1
    3ac2:	00001097          	auipc	ra,0x1
    3ac6:	9ce080e7          	jalr	-1586(ra) # 4490 <read>
  close(fd);
    3aca:	8526                	mv	a0,s1
    3acc:	00001097          	auipc	ra,0x1
    3ad0:	9d4080e7          	jalr	-1580(ra) # 44a0 <close>
}
    3ad4:	60e2                	ld	ra,24(sp)
    3ad6:	6442                	ld	s0,16(sp)
    3ad8:	64a2                	ld	s1,8(sp)
    3ada:	6902                	ld	s2,0(sp)
    3adc:	6105                	addi	sp,sp,32
    3ade:	8082                	ret
    printf("%s: open failed\n", s);
    3ae0:	85ca                	mv	a1,s2
    3ae2:	00002517          	auipc	a0,0x2
    3ae6:	b0650513          	addi	a0,a0,-1274 # 55e8 <malloc+0xcd2>
    3aea:	00001097          	auipc	ra,0x1
    3aee:	d16080e7          	jalr	-746(ra) # 4800 <printf>
    exit(1);
    3af2:	4505                	li	a0,1
    3af4:	00001097          	auipc	ra,0x1
    3af8:	984080e7          	jalr	-1660(ra) # 4478 <exit>

0000000000003afc <sbrkbugs>:
{
    3afc:	1141                	addi	sp,sp,-16
    3afe:	e406                	sd	ra,8(sp)
    3b00:	e022                	sd	s0,0(sp)
    3b02:	0800                	addi	s0,sp,16
  int pid = fork();
    3b04:	00001097          	auipc	ra,0x1
    3b08:	96c080e7          	jalr	-1684(ra) # 4470 <fork>
  if(pid < 0){
    3b0c:	02054263          	bltz	a0,3b30 <sbrkbugs+0x34>
  if(pid == 0){
    3b10:	ed0d                	bnez	a0,3b4a <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    3b12:	00001097          	auipc	ra,0x1
    3b16:	9ee080e7          	jalr	-1554(ra) # 4500 <sbrk>
    sbrk(-sz);
    3b1a:	40a0053b          	negw	a0,a0
    3b1e:	00001097          	auipc	ra,0x1
    3b22:	9e2080e7          	jalr	-1566(ra) # 4500 <sbrk>
    exit(0);
    3b26:	4501                	li	a0,0
    3b28:	00001097          	auipc	ra,0x1
    3b2c:	950080e7          	jalr	-1712(ra) # 4478 <exit>
    printf("fork failed\n");
    3b30:	00002517          	auipc	a0,0x2
    3b34:	be850513          	addi	a0,a0,-1048 # 5718 <malloc+0xe02>
    3b38:	00001097          	auipc	ra,0x1
    3b3c:	cc8080e7          	jalr	-824(ra) # 4800 <printf>
    exit(1);
    3b40:	4505                	li	a0,1
    3b42:	00001097          	auipc	ra,0x1
    3b46:	936080e7          	jalr	-1738(ra) # 4478 <exit>
  wait(0);
    3b4a:	4501                	li	a0,0
    3b4c:	00001097          	auipc	ra,0x1
    3b50:	934080e7          	jalr	-1740(ra) # 4480 <wait>
  pid = fork();
    3b54:	00001097          	auipc	ra,0x1
    3b58:	91c080e7          	jalr	-1764(ra) # 4470 <fork>
  if(pid < 0){
    3b5c:	02054563          	bltz	a0,3b86 <sbrkbugs+0x8a>
  if(pid == 0){
    3b60:	e121                	bnez	a0,3ba0 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    3b62:	00001097          	auipc	ra,0x1
    3b66:	99e080e7          	jalr	-1634(ra) # 4500 <sbrk>
    sbrk(-(sz - 3500));
    3b6a:	6785                	lui	a5,0x1
    3b6c:	dac7879b          	addiw	a5,a5,-596
    3b70:	40a7853b          	subw	a0,a5,a0
    3b74:	00001097          	auipc	ra,0x1
    3b78:	98c080e7          	jalr	-1652(ra) # 4500 <sbrk>
    exit(0);
    3b7c:	4501                	li	a0,0
    3b7e:	00001097          	auipc	ra,0x1
    3b82:	8fa080e7          	jalr	-1798(ra) # 4478 <exit>
    printf("fork failed\n");
    3b86:	00002517          	auipc	a0,0x2
    3b8a:	b9250513          	addi	a0,a0,-1134 # 5718 <malloc+0xe02>
    3b8e:	00001097          	auipc	ra,0x1
    3b92:	c72080e7          	jalr	-910(ra) # 4800 <printf>
    exit(1);
    3b96:	4505                	li	a0,1
    3b98:	00001097          	auipc	ra,0x1
    3b9c:	8e0080e7          	jalr	-1824(ra) # 4478 <exit>
  wait(0);
    3ba0:	4501                	li	a0,0
    3ba2:	00001097          	auipc	ra,0x1
    3ba6:	8de080e7          	jalr	-1826(ra) # 4480 <wait>
  pid = fork();
    3baa:	00001097          	auipc	ra,0x1
    3bae:	8c6080e7          	jalr	-1850(ra) # 4470 <fork>
  if(pid < 0){
    3bb2:	02054a63          	bltz	a0,3be6 <sbrkbugs+0xea>
  if(pid == 0){
    3bb6:	e529                	bnez	a0,3c00 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    3bb8:	00001097          	auipc	ra,0x1
    3bbc:	948080e7          	jalr	-1720(ra) # 4500 <sbrk>
    3bc0:	67ad                	lui	a5,0xb
    3bc2:	8007879b          	addiw	a5,a5,-2048
    3bc6:	40a7853b          	subw	a0,a5,a0
    3bca:	00001097          	auipc	ra,0x1
    3bce:	936080e7          	jalr	-1738(ra) # 4500 <sbrk>
    sbrk(-10);
    3bd2:	5559                	li	a0,-10
    3bd4:	00001097          	auipc	ra,0x1
    3bd8:	92c080e7          	jalr	-1748(ra) # 4500 <sbrk>
    exit(0);
    3bdc:	4501                	li	a0,0
    3bde:	00001097          	auipc	ra,0x1
    3be2:	89a080e7          	jalr	-1894(ra) # 4478 <exit>
    printf("fork failed\n");
    3be6:	00002517          	auipc	a0,0x2
    3bea:	b3250513          	addi	a0,a0,-1230 # 5718 <malloc+0xe02>
    3bee:	00001097          	auipc	ra,0x1
    3bf2:	c12080e7          	jalr	-1006(ra) # 4800 <printf>
    exit(1);
    3bf6:	4505                	li	a0,1
    3bf8:	00001097          	auipc	ra,0x1
    3bfc:	880080e7          	jalr	-1920(ra) # 4478 <exit>
  wait(0);
    3c00:	4501                	li	a0,0
    3c02:	00001097          	auipc	ra,0x1
    3c06:	87e080e7          	jalr	-1922(ra) # 4480 <wait>
  exit(0);
    3c0a:	4501                	li	a0,0
    3c0c:	00001097          	auipc	ra,0x1
    3c10:	86c080e7          	jalr	-1940(ra) # 4478 <exit>

0000000000003c14 <dirtest>:
{
    3c14:	1101                	addi	sp,sp,-32
    3c16:	ec06                	sd	ra,24(sp)
    3c18:	e822                	sd	s0,16(sp)
    3c1a:	e426                	sd	s1,8(sp)
    3c1c:	1000                	addi	s0,sp,32
    3c1e:	84aa                	mv	s1,a0
  printf("mkdir test\n");
    3c20:	00003517          	auipc	a0,0x3
    3c24:	99050513          	addi	a0,a0,-1648 # 65b0 <malloc+0x1c9a>
    3c28:	00001097          	auipc	ra,0x1
    3c2c:	bd8080e7          	jalr	-1064(ra) # 4800 <printf>
  if(mkdir("dir0") < 0){
    3c30:	00003517          	auipc	a0,0x3
    3c34:	99050513          	addi	a0,a0,-1648 # 65c0 <malloc+0x1caa>
    3c38:	00001097          	auipc	ra,0x1
    3c3c:	8a8080e7          	jalr	-1880(ra) # 44e0 <mkdir>
    3c40:	04054d63          	bltz	a0,3c9a <dirtest+0x86>
  if(chdir("dir0") < 0){
    3c44:	00003517          	auipc	a0,0x3
    3c48:	97c50513          	addi	a0,a0,-1668 # 65c0 <malloc+0x1caa>
    3c4c:	00001097          	auipc	ra,0x1
    3c50:	89c080e7          	jalr	-1892(ra) # 44e8 <chdir>
    3c54:	06054163          	bltz	a0,3cb6 <dirtest+0xa2>
  if(chdir("..") < 0){
    3c58:	00001517          	auipc	a0,0x1
    3c5c:	13050513          	addi	a0,a0,304 # 4d88 <malloc+0x472>
    3c60:	00001097          	auipc	ra,0x1
    3c64:	888080e7          	jalr	-1912(ra) # 44e8 <chdir>
    3c68:	06054563          	bltz	a0,3cd2 <dirtest+0xbe>
  if(unlink("dir0") < 0){
    3c6c:	00003517          	auipc	a0,0x3
    3c70:	95450513          	addi	a0,a0,-1708 # 65c0 <malloc+0x1caa>
    3c74:	00001097          	auipc	ra,0x1
    3c78:	854080e7          	jalr	-1964(ra) # 44c8 <unlink>
    3c7c:	06054963          	bltz	a0,3cee <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    3c80:	00003517          	auipc	a0,0x3
    3c84:	99050513          	addi	a0,a0,-1648 # 6610 <malloc+0x1cfa>
    3c88:	00001097          	auipc	ra,0x1
    3c8c:	b78080e7          	jalr	-1160(ra) # 4800 <printf>
}
    3c90:	60e2                	ld	ra,24(sp)
    3c92:	6442                	ld	s0,16(sp)
    3c94:	64a2                	ld	s1,8(sp)
    3c96:	6105                	addi	sp,sp,32
    3c98:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3c9a:	85a6                	mv	a1,s1
    3c9c:	00001517          	auipc	a0,0x1
    3ca0:	00c50513          	addi	a0,a0,12 # 4ca8 <malloc+0x392>
    3ca4:	00001097          	auipc	ra,0x1
    3ca8:	b5c080e7          	jalr	-1188(ra) # 4800 <printf>
    exit(1);
    3cac:	4505                	li	a0,1
    3cae:	00000097          	auipc	ra,0x0
    3cb2:	7ca080e7          	jalr	1994(ra) # 4478 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3cb6:	85a6                	mv	a1,s1
    3cb8:	00003517          	auipc	a0,0x3
    3cbc:	91050513          	addi	a0,a0,-1776 # 65c8 <malloc+0x1cb2>
    3cc0:	00001097          	auipc	ra,0x1
    3cc4:	b40080e7          	jalr	-1216(ra) # 4800 <printf>
    exit(1);
    3cc8:	4505                	li	a0,1
    3cca:	00000097          	auipc	ra,0x0
    3cce:	7ae080e7          	jalr	1966(ra) # 4478 <exit>
    printf("%s: chdir .. failed\n", s);
    3cd2:	85a6                	mv	a1,s1
    3cd4:	00003517          	auipc	a0,0x3
    3cd8:	90c50513          	addi	a0,a0,-1780 # 65e0 <malloc+0x1cca>
    3cdc:	00001097          	auipc	ra,0x1
    3ce0:	b24080e7          	jalr	-1244(ra) # 4800 <printf>
    exit(1);
    3ce4:	4505                	li	a0,1
    3ce6:	00000097          	auipc	ra,0x0
    3cea:	792080e7          	jalr	1938(ra) # 4478 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3cee:	85a6                	mv	a1,s1
    3cf0:	00003517          	auipc	a0,0x3
    3cf4:	90850513          	addi	a0,a0,-1784 # 65f8 <malloc+0x1ce2>
    3cf8:	00001097          	auipc	ra,0x1
    3cfc:	b08080e7          	jalr	-1272(ra) # 4800 <printf>
    exit(1);
    3d00:	4505                	li	a0,1
    3d02:	00000097          	auipc	ra,0x0
    3d06:	776080e7          	jalr	1910(ra) # 4478 <exit>

0000000000003d0a <fsfull>:
{
    3d0a:	7171                	addi	sp,sp,-176
    3d0c:	f506                	sd	ra,168(sp)
    3d0e:	f122                	sd	s0,160(sp)
    3d10:	ed26                	sd	s1,152(sp)
    3d12:	e94a                	sd	s2,144(sp)
    3d14:	e54e                	sd	s3,136(sp)
    3d16:	e152                	sd	s4,128(sp)
    3d18:	fcd6                	sd	s5,120(sp)
    3d1a:	f8da                	sd	s6,112(sp)
    3d1c:	f4de                	sd	s7,104(sp)
    3d1e:	f0e2                	sd	s8,96(sp)
    3d20:	ece6                	sd	s9,88(sp)
    3d22:	e8ea                	sd	s10,80(sp)
    3d24:	e4ee                	sd	s11,72(sp)
    3d26:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    3d28:	00003517          	auipc	a0,0x3
    3d2c:	90050513          	addi	a0,a0,-1792 # 6628 <malloc+0x1d12>
    3d30:	00001097          	auipc	ra,0x1
    3d34:	ad0080e7          	jalr	-1328(ra) # 4800 <printf>
  for(nfiles = 0; ; nfiles++){
    3d38:	4481                	li	s1,0
    name[0] = 'f';
    3d3a:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    3d3e:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    3d42:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    3d46:	4b29                	li	s6,10
    printf("%s: writing %s\n", name);
    3d48:	00003c97          	auipc	s9,0x3
    3d4c:	8f0c8c93          	addi	s9,s9,-1808 # 6638 <malloc+0x1d22>
    int total = 0;
    3d50:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    3d52:	00005a17          	auipc	s4,0x5
    3d56:	58ea0a13          	addi	s4,s4,1422 # 92e0 <buf>
    name[0] = 'f';
    3d5a:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    3d5e:	0384c7bb          	divw	a5,s1,s8
    3d62:	0307879b          	addiw	a5,a5,48
    3d66:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    3d6a:	0384e7bb          	remw	a5,s1,s8
    3d6e:	0377c7bb          	divw	a5,a5,s7
    3d72:	0307879b          	addiw	a5,a5,48
    3d76:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    3d7a:	0374e7bb          	remw	a5,s1,s7
    3d7e:	0367c7bb          	divw	a5,a5,s6
    3d82:	0307879b          	addiw	a5,a5,48
    3d86:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    3d8a:	0364e7bb          	remw	a5,s1,s6
    3d8e:	0307879b          	addiw	a5,a5,48
    3d92:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    3d96:	f4040aa3          	sb	zero,-171(s0)
    printf("%s: writing %s\n", name);
    3d9a:	f5040593          	addi	a1,s0,-176
    3d9e:	8566                	mv	a0,s9
    3da0:	00001097          	auipc	ra,0x1
    3da4:	a60080e7          	jalr	-1440(ra) # 4800 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3da8:	20200593          	li	a1,514
    3dac:	f5040513          	addi	a0,s0,-176
    3db0:	00000097          	auipc	ra,0x0
    3db4:	708080e7          	jalr	1800(ra) # 44b8 <open>
    3db8:	892a                	mv	s2,a0
    if(fd < 0){
    3dba:	0a055663          	bgez	a0,3e66 <fsfull+0x15c>
      printf("%s: open %s failed\n", name);
    3dbe:	f5040593          	addi	a1,s0,-176
    3dc2:	00003517          	auipc	a0,0x3
    3dc6:	88650513          	addi	a0,a0,-1914 # 6648 <malloc+0x1d32>
    3dca:	00001097          	auipc	ra,0x1
    3dce:	a36080e7          	jalr	-1482(ra) # 4800 <printf>
  while(nfiles >= 0){
    3dd2:	0604c363          	bltz	s1,3e38 <fsfull+0x12e>
    name[0] = 'f';
    3dd6:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    3dda:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    3dde:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    3de2:	4929                	li	s2,10
  while(nfiles >= 0){
    3de4:	5afd                	li	s5,-1
    name[0] = 'f';
    3de6:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    3dea:	0344c7bb          	divw	a5,s1,s4
    3dee:	0307879b          	addiw	a5,a5,48
    3df2:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    3df6:	0344e7bb          	remw	a5,s1,s4
    3dfa:	0337c7bb          	divw	a5,a5,s3
    3dfe:	0307879b          	addiw	a5,a5,48
    3e02:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    3e06:	0334e7bb          	remw	a5,s1,s3
    3e0a:	0327c7bb          	divw	a5,a5,s2
    3e0e:	0307879b          	addiw	a5,a5,48
    3e12:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    3e16:	0324e7bb          	remw	a5,s1,s2
    3e1a:	0307879b          	addiw	a5,a5,48
    3e1e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    3e22:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    3e26:	f5040513          	addi	a0,s0,-176
    3e2a:	00000097          	auipc	ra,0x0
    3e2e:	69e080e7          	jalr	1694(ra) # 44c8 <unlink>
    nfiles--;
    3e32:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    3e34:	fb5499e3          	bne	s1,s5,3de6 <fsfull+0xdc>
  printf("fsfull test finished\n");
    3e38:	00003517          	auipc	a0,0x3
    3e3c:	84050513          	addi	a0,a0,-1984 # 6678 <malloc+0x1d62>
    3e40:	00001097          	auipc	ra,0x1
    3e44:	9c0080e7          	jalr	-1600(ra) # 4800 <printf>
}
    3e48:	70aa                	ld	ra,168(sp)
    3e4a:	740a                	ld	s0,160(sp)
    3e4c:	64ea                	ld	s1,152(sp)
    3e4e:	694a                	ld	s2,144(sp)
    3e50:	69aa                	ld	s3,136(sp)
    3e52:	6a0a                	ld	s4,128(sp)
    3e54:	7ae6                	ld	s5,120(sp)
    3e56:	7b46                	ld	s6,112(sp)
    3e58:	7ba6                	ld	s7,104(sp)
    3e5a:	7c06                	ld	s8,96(sp)
    3e5c:	6ce6                	ld	s9,88(sp)
    3e5e:	6d46                	ld	s10,80(sp)
    3e60:	6da6                	ld	s11,72(sp)
    3e62:	614d                	addi	sp,sp,176
    3e64:	8082                	ret
    int total = 0;
    3e66:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    3e68:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    3e6c:	40000613          	li	a2,1024
    3e70:	85d2                	mv	a1,s4
    3e72:	854a                	mv	a0,s2
    3e74:	00000097          	auipc	ra,0x0
    3e78:	624080e7          	jalr	1572(ra) # 4498 <write>
      if(cc < BSIZE)
    3e7c:	00aad563          	bge	s5,a0,3e86 <fsfull+0x17c>
      total += cc;
    3e80:	00a989bb          	addw	s3,s3,a0
    while(1){
    3e84:	b7e5                	j	3e6c <fsfull+0x162>
    printf("%s: wrote %d bytes\n", total);
    3e86:	85ce                	mv	a1,s3
    3e88:	00002517          	auipc	a0,0x2
    3e8c:	7d850513          	addi	a0,a0,2008 # 6660 <malloc+0x1d4a>
    3e90:	00001097          	auipc	ra,0x1
    3e94:	970080e7          	jalr	-1680(ra) # 4800 <printf>
    close(fd);
    3e98:	854a                	mv	a0,s2
    3e9a:	00000097          	auipc	ra,0x0
    3e9e:	606080e7          	jalr	1542(ra) # 44a0 <close>
    if(total == 0)
    3ea2:	f20988e3          	beqz	s3,3dd2 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    3ea6:	2485                	addiw	s1,s1,1
    3ea8:	bd4d                	j	3d5a <fsfull+0x50>

0000000000003eaa <rand>:
{
    3eaa:	1141                	addi	sp,sp,-16
    3eac:	e422                	sd	s0,8(sp)
    3eae:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    3eb0:	00003717          	auipc	a4,0x3
    3eb4:	c0870713          	addi	a4,a4,-1016 # 6ab8 <randstate>
    3eb8:	6308                	ld	a0,0(a4)
    3eba:	001967b7          	lui	a5,0x196
    3ebe:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x18a305>
    3ec2:	02f50533          	mul	a0,a0,a5
    3ec6:	3c6ef7b7          	lui	a5,0x3c6ef
    3eca:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e3057>
    3ece:	953e                	add	a0,a0,a5
    3ed0:	e308                	sd	a0,0(a4)
}
    3ed2:	2501                	sext.w	a0,a0
    3ed4:	6422                	ld	s0,8(sp)
    3ed6:	0141                	addi	sp,sp,16
    3ed8:	8082                	ret

0000000000003eda <badwrite>:
{
    3eda:	7179                	addi	sp,sp,-48
    3edc:	f406                	sd	ra,40(sp)
    3ede:	f022                	sd	s0,32(sp)
    3ee0:	ec26                	sd	s1,24(sp)
    3ee2:	e84a                	sd	s2,16(sp)
    3ee4:	e44e                	sd	s3,8(sp)
    3ee6:	e052                	sd	s4,0(sp)
    3ee8:	1800                	addi	s0,sp,48
  unlink("junk");
    3eea:	00002517          	auipc	a0,0x2
    3eee:	7a650513          	addi	a0,a0,1958 # 6690 <malloc+0x1d7a>
    3ef2:	00000097          	auipc	ra,0x0
    3ef6:	5d6080e7          	jalr	1494(ra) # 44c8 <unlink>
    3efa:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    3efe:	00002997          	auipc	s3,0x2
    3f02:	79298993          	addi	s3,s3,1938 # 6690 <malloc+0x1d7a>
    write(fd, (char*)0xffffffffffL, 1);
    3f06:	5a7d                	li	s4,-1
    3f08:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    3f0c:	20100593          	li	a1,513
    3f10:	854e                	mv	a0,s3
    3f12:	00000097          	auipc	ra,0x0
    3f16:	5a6080e7          	jalr	1446(ra) # 44b8 <open>
    3f1a:	84aa                	mv	s1,a0
    if(fd < 0){
    3f1c:	06054b63          	bltz	a0,3f92 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    3f20:	4605                	li	a2,1
    3f22:	85d2                	mv	a1,s4
    3f24:	00000097          	auipc	ra,0x0
    3f28:	574080e7          	jalr	1396(ra) # 4498 <write>
    close(fd);
    3f2c:	8526                	mv	a0,s1
    3f2e:	00000097          	auipc	ra,0x0
    3f32:	572080e7          	jalr	1394(ra) # 44a0 <close>
    unlink("junk");
    3f36:	854e                	mv	a0,s3
    3f38:	00000097          	auipc	ra,0x0
    3f3c:	590080e7          	jalr	1424(ra) # 44c8 <unlink>
  for(int i = 0; i < assumed_free; i++){
    3f40:	397d                	addiw	s2,s2,-1
    3f42:	fc0915e3          	bnez	s2,3f0c <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    3f46:	20100593          	li	a1,513
    3f4a:	00002517          	auipc	a0,0x2
    3f4e:	74650513          	addi	a0,a0,1862 # 6690 <malloc+0x1d7a>
    3f52:	00000097          	auipc	ra,0x0
    3f56:	566080e7          	jalr	1382(ra) # 44b8 <open>
    3f5a:	84aa                	mv	s1,a0
  if(fd < 0){
    3f5c:	04054863          	bltz	a0,3fac <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    3f60:	4605                	li	a2,1
    3f62:	00002597          	auipc	a1,0x2
    3f66:	86658593          	addi	a1,a1,-1946 # 57c8 <malloc+0xeb2>
    3f6a:	00000097          	auipc	ra,0x0
    3f6e:	52e080e7          	jalr	1326(ra) # 4498 <write>
    3f72:	4785                	li	a5,1
    3f74:	04f50963          	beq	a0,a5,3fc6 <badwrite+0xec>
    printf("write failed\n");
    3f78:	00002517          	auipc	a0,0x2
    3f7c:	73850513          	addi	a0,a0,1848 # 66b0 <malloc+0x1d9a>
    3f80:	00001097          	auipc	ra,0x1
    3f84:	880080e7          	jalr	-1920(ra) # 4800 <printf>
    exit(1);
    3f88:	4505                	li	a0,1
    3f8a:	00000097          	auipc	ra,0x0
    3f8e:	4ee080e7          	jalr	1262(ra) # 4478 <exit>
      printf("open junk failed\n");
    3f92:	00002517          	auipc	a0,0x2
    3f96:	70650513          	addi	a0,a0,1798 # 6698 <malloc+0x1d82>
    3f9a:	00001097          	auipc	ra,0x1
    3f9e:	866080e7          	jalr	-1946(ra) # 4800 <printf>
      exit(1);
    3fa2:	4505                	li	a0,1
    3fa4:	00000097          	auipc	ra,0x0
    3fa8:	4d4080e7          	jalr	1236(ra) # 4478 <exit>
    printf("open junk failed\n");
    3fac:	00002517          	auipc	a0,0x2
    3fb0:	6ec50513          	addi	a0,a0,1772 # 6698 <malloc+0x1d82>
    3fb4:	00001097          	auipc	ra,0x1
    3fb8:	84c080e7          	jalr	-1972(ra) # 4800 <printf>
    exit(1);
    3fbc:	4505                	li	a0,1
    3fbe:	00000097          	auipc	ra,0x0
    3fc2:	4ba080e7          	jalr	1210(ra) # 4478 <exit>
  close(fd);
    3fc6:	8526                	mv	a0,s1
    3fc8:	00000097          	auipc	ra,0x0
    3fcc:	4d8080e7          	jalr	1240(ra) # 44a0 <close>
  unlink("junk");
    3fd0:	00002517          	auipc	a0,0x2
    3fd4:	6c050513          	addi	a0,a0,1728 # 6690 <malloc+0x1d7a>
    3fd8:	00000097          	auipc	ra,0x0
    3fdc:	4f0080e7          	jalr	1264(ra) # 44c8 <unlink>
  exit(0);
    3fe0:	4501                	li	a0,0
    3fe2:	00000097          	auipc	ra,0x0
    3fe6:	496080e7          	jalr	1174(ra) # 4478 <exit>

0000000000003fea <run>:
}

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    3fea:	7179                	addi	sp,sp,-48
    3fec:	f406                	sd	ra,40(sp)
    3fee:	f022                	sd	s0,32(sp)
    3ff0:	ec26                	sd	s1,24(sp)
    3ff2:	e84a                	sd	s2,16(sp)
    3ff4:	1800                	addi	s0,sp,48
    3ff6:	892a                	mv	s2,a0
    3ff8:	84ae                	mv	s1,a1
  int pid;
  int xstatus;
  
  printf("test %s: ", s);
    3ffa:	00002517          	auipc	a0,0x2
    3ffe:	6c650513          	addi	a0,a0,1734 # 66c0 <malloc+0x1daa>
    4002:	00000097          	auipc	ra,0x0
    4006:	7fe080e7          	jalr	2046(ra) # 4800 <printf>
  if((pid = fork()) < 0) {
    400a:	00000097          	auipc	ra,0x0
    400e:	466080e7          	jalr	1126(ra) # 4470 <fork>
    4012:	02054f63          	bltz	a0,4050 <run+0x66>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4016:	c931                	beqz	a0,406a <run+0x80>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4018:	fdc40513          	addi	a0,s0,-36
    401c:	00000097          	auipc	ra,0x0
    4020:	464080e7          	jalr	1124(ra) # 4480 <wait>
    if(xstatus != 0) 
    4024:	fdc42783          	lw	a5,-36(s0)
    4028:	cba1                	beqz	a5,4078 <run+0x8e>
      printf("FAILED\n", s);
    402a:	85a6                	mv	a1,s1
    402c:	00002517          	auipc	a0,0x2
    4030:	6bc50513          	addi	a0,a0,1724 # 66e8 <malloc+0x1dd2>
    4034:	00000097          	auipc	ra,0x0
    4038:	7cc080e7          	jalr	1996(ra) # 4800 <printf>
    else
      printf("OK\n", s);
    return xstatus == 0;
    403c:	fdc42503          	lw	a0,-36(s0)
  }
}
    4040:	00153513          	seqz	a0,a0
    4044:	70a2                	ld	ra,40(sp)
    4046:	7402                	ld	s0,32(sp)
    4048:	64e2                	ld	s1,24(sp)
    404a:	6942                	ld	s2,16(sp)
    404c:	6145                	addi	sp,sp,48
    404e:	8082                	ret
    printf("runtest: fork error\n");
    4050:	00002517          	auipc	a0,0x2
    4054:	68050513          	addi	a0,a0,1664 # 66d0 <malloc+0x1dba>
    4058:	00000097          	auipc	ra,0x0
    405c:	7a8080e7          	jalr	1960(ra) # 4800 <printf>
    exit(1);
    4060:	4505                	li	a0,1
    4062:	00000097          	auipc	ra,0x0
    4066:	416080e7          	jalr	1046(ra) # 4478 <exit>
    f(s);
    406a:	8526                	mv	a0,s1
    406c:	9902                	jalr	s2
    exit(0);
    406e:	4501                	li	a0,0
    4070:	00000097          	auipc	ra,0x0
    4074:	408080e7          	jalr	1032(ra) # 4478 <exit>
      printf("OK\n", s);
    4078:	85a6                	mv	a1,s1
    407a:	00002517          	auipc	a0,0x2
    407e:	67650513          	addi	a0,a0,1654 # 66f0 <malloc+0x1dda>
    4082:	00000097          	auipc	ra,0x0
    4086:	77e080e7          	jalr	1918(ra) # 4800 <printf>
    408a:	bf4d                	j	403c <run+0x52>

000000000000408c <main>:

int
main(int argc, char *argv[])
{
    408c:	ce010113          	addi	sp,sp,-800
    4090:	30113c23          	sd	ra,792(sp)
    4094:	30813823          	sd	s0,784(sp)
    4098:	30913423          	sd	s1,776(sp)
    409c:	31213023          	sd	s2,768(sp)
    40a0:	2f313c23          	sd	s3,760(sp)
    40a4:	2f413823          	sd	s4,752(sp)
    40a8:	1600                	addi	s0,sp,800
  char *n = 0;
  if(argc > 1) {
    40aa:	4785                	li	a5,1
  char *n = 0;
    40ac:	4901                	li	s2,0
  if(argc > 1) {
    40ae:	00a7d463          	bge	a5,a0,40b6 <main+0x2a>
    n = argv[1];
    40b2:	0085b903          	ld	s2,8(a1)
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    40b6:	00002797          	auipc	a5,0x2
    40ba:	6e278793          	addi	a5,a5,1762 # 6798 <malloc+0x1e82>
    40be:	ce040713          	addi	a4,s0,-800
    40c2:	00003817          	auipc	a6,0x3
    40c6:	9b680813          	addi	a6,a6,-1610 # 6a78 <malloc+0x2162>
    40ca:	6388                	ld	a0,0(a5)
    40cc:	678c                	ld	a1,8(a5)
    40ce:	6b90                	ld	a2,16(a5)
    40d0:	6f94                	ld	a3,24(a5)
    40d2:	e308                	sd	a0,0(a4)
    40d4:	e70c                	sd	a1,8(a4)
    40d6:	eb10                	sd	a2,16(a4)
    40d8:	ef14                	sd	a3,24(a4)
    40da:	02078793          	addi	a5,a5,32
    40de:	02070713          	addi	a4,a4,32
    40e2:	ff0794e3          	bne	a5,a6,40ca <main+0x3e>
    40e6:	6394                	ld	a3,0(a5)
    40e8:	679c                	ld	a5,8(a5)
    40ea:	e314                	sd	a3,0(a4)
    40ec:	e71c                	sd	a5,8(a4)
    {forktest, "forktest"},
    {bigdir, "bigdir"}, // slow
    { 0, 0},
  };
    
  printf("usertests starting\n");
    40ee:	00002517          	auipc	a0,0x2
    40f2:	60a50513          	addi	a0,a0,1546 # 66f8 <malloc+0x1de2>
    40f6:	00000097          	auipc	ra,0x0
    40fa:	70a080e7          	jalr	1802(ra) # 4800 <printf>

  if(open("usertests.ran", 0) >= 0){
    40fe:	4581                	li	a1,0
    4100:	00002517          	auipc	a0,0x2
    4104:	61050513          	addi	a0,a0,1552 # 6710 <malloc+0x1dfa>
    4108:	00000097          	auipc	ra,0x0
    410c:	3b0080e7          	jalr	944(ra) # 44b8 <open>
    4110:	00054f63          	bltz	a0,412e <main+0xa2>
    printf("already ran user tests -- rebuild fs.img (rm fs.img; make fs.img)\n");
    4114:	00002517          	auipc	a0,0x2
    4118:	60c50513          	addi	a0,a0,1548 # 6720 <malloc+0x1e0a>
    411c:	00000097          	auipc	ra,0x0
    4120:	6e4080e7          	jalr	1764(ra) # 4800 <printf>
    exit(1);
    4124:	4505                	li	a0,1
    4126:	00000097          	auipc	ra,0x0
    412a:	352080e7          	jalr	850(ra) # 4478 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    412e:	20000593          	li	a1,512
    4132:	00002517          	auipc	a0,0x2
    4136:	5de50513          	addi	a0,a0,1502 # 6710 <malloc+0x1dfa>
    413a:	00000097          	auipc	ra,0x0
    413e:	37e080e7          	jalr	894(ra) # 44b8 <open>
    4142:	00000097          	auipc	ra,0x0
    4146:	35e080e7          	jalr	862(ra) # 44a0 <close>

  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    414a:	ce843503          	ld	a0,-792(s0)
    414e:	c529                	beqz	a0,4198 <main+0x10c>
    4150:	ce040493          	addi	s1,s0,-800
  int fail = 0;
    4154:	4981                	li	s3,0
    if((n == 0) || strcmp(t->s, n) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    4156:	4a05                	li	s4,1
    4158:	a021                	j	4160 <main+0xd4>
  for (struct test *t = tests; t->s != 0; t++) {
    415a:	04c1                	addi	s1,s1,16
    415c:	6488                	ld	a0,8(s1)
    415e:	c115                	beqz	a0,4182 <main+0xf6>
    if((n == 0) || strcmp(t->s, n) == 0) {
    4160:	00090863          	beqz	s2,4170 <main+0xe4>
    4164:	85ca                	mv	a1,s2
    4166:	00000097          	auipc	ra,0x0
    416a:	068080e7          	jalr	104(ra) # 41ce <strcmp>
    416e:	f575                	bnez	a0,415a <main+0xce>
      if(!run(t->f, t->s))
    4170:	648c                	ld	a1,8(s1)
    4172:	6088                	ld	a0,0(s1)
    4174:	00000097          	auipc	ra,0x0
    4178:	e76080e7          	jalr	-394(ra) # 3fea <run>
    417c:	fd79                	bnez	a0,415a <main+0xce>
        fail = 1;
    417e:	89d2                	mv	s3,s4
    4180:	bfe9                	j	415a <main+0xce>
    }
  }
  if(!fail)
    4182:	00098b63          	beqz	s3,4198 <main+0x10c>
    printf("ALL TESTS PASSED\n");
  else
    printf("SOME TESTS FAILED\n");
    4186:	00002517          	auipc	a0,0x2
    418a:	5fa50513          	addi	a0,a0,1530 # 6780 <malloc+0x1e6a>
    418e:	00000097          	auipc	ra,0x0
    4192:	672080e7          	jalr	1650(ra) # 4800 <printf>
    4196:	a809                	j	41a8 <main+0x11c>
    printf("ALL TESTS PASSED\n");
    4198:	00002517          	auipc	a0,0x2
    419c:	5d050513          	addi	a0,a0,1488 # 6768 <malloc+0x1e52>
    41a0:	00000097          	auipc	ra,0x0
    41a4:	660080e7          	jalr	1632(ra) # 4800 <printf>
  exit(1);   // not reached.
    41a8:	4505                	li	a0,1
    41aa:	00000097          	auipc	ra,0x0
    41ae:	2ce080e7          	jalr	718(ra) # 4478 <exit>

00000000000041b2 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
    41b2:	1141                	addi	sp,sp,-16
    41b4:	e422                	sd	s0,8(sp)
    41b6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    41b8:	87aa                	mv	a5,a0
    41ba:	0585                	addi	a1,a1,1
    41bc:	0785                	addi	a5,a5,1
    41be:	fff5c703          	lbu	a4,-1(a1)
    41c2:	fee78fa3          	sb	a4,-1(a5)
    41c6:	fb75                	bnez	a4,41ba <strcpy+0x8>
    ;
  return os;
}
    41c8:	6422                	ld	s0,8(sp)
    41ca:	0141                	addi	sp,sp,16
    41cc:	8082                	ret

00000000000041ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
    41ce:	1141                	addi	sp,sp,-16
    41d0:	e422                	sd	s0,8(sp)
    41d2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    41d4:	00054783          	lbu	a5,0(a0)
    41d8:	cb91                	beqz	a5,41ec <strcmp+0x1e>
    41da:	0005c703          	lbu	a4,0(a1)
    41de:	00f71763          	bne	a4,a5,41ec <strcmp+0x1e>
    p++, q++;
    41e2:	0505                	addi	a0,a0,1
    41e4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    41e6:	00054783          	lbu	a5,0(a0)
    41ea:	fbe5                	bnez	a5,41da <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    41ec:	0005c503          	lbu	a0,0(a1)
}
    41f0:	40a7853b          	subw	a0,a5,a0
    41f4:	6422                	ld	s0,8(sp)
    41f6:	0141                	addi	sp,sp,16
    41f8:	8082                	ret

00000000000041fa <strlen>:

uint
strlen(const char *s)
{
    41fa:	1141                	addi	sp,sp,-16
    41fc:	e422                	sd	s0,8(sp)
    41fe:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4200:	00054783          	lbu	a5,0(a0)
    4204:	cf91                	beqz	a5,4220 <strlen+0x26>
    4206:	0505                	addi	a0,a0,1
    4208:	87aa                	mv	a5,a0
    420a:	4685                	li	a3,1
    420c:	9e89                	subw	a3,a3,a0
    420e:	00f6853b          	addw	a0,a3,a5
    4212:	0785                	addi	a5,a5,1
    4214:	fff7c703          	lbu	a4,-1(a5)
    4218:	fb7d                	bnez	a4,420e <strlen+0x14>
    ;
  return n;
}
    421a:	6422                	ld	s0,8(sp)
    421c:	0141                	addi	sp,sp,16
    421e:	8082                	ret
  for(n = 0; s[n]; n++)
    4220:	4501                	li	a0,0
    4222:	bfe5                	j	421a <strlen+0x20>

0000000000004224 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4224:	1141                	addi	sp,sp,-16
    4226:	e422                	sd	s0,8(sp)
    4228:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    422a:	ce09                	beqz	a2,4244 <memset+0x20>
    422c:	87aa                	mv	a5,a0
    422e:	fff6071b          	addiw	a4,a2,-1
    4232:	1702                	slli	a4,a4,0x20
    4234:	9301                	srli	a4,a4,0x20
    4236:	0705                	addi	a4,a4,1
    4238:	972a                	add	a4,a4,a0
    cdst[i] = c;
    423a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    423e:	0785                	addi	a5,a5,1
    4240:	fee79de3          	bne	a5,a4,423a <memset+0x16>
  }
  return dst;
}
    4244:	6422                	ld	s0,8(sp)
    4246:	0141                	addi	sp,sp,16
    4248:	8082                	ret

000000000000424a <strchr>:

char*
strchr(const char *s, char c)
{
    424a:	1141                	addi	sp,sp,-16
    424c:	e422                	sd	s0,8(sp)
    424e:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4250:	00054783          	lbu	a5,0(a0)
    4254:	cb99                	beqz	a5,426a <strchr+0x20>
    if(*s == c)
    4256:	00f58763          	beq	a1,a5,4264 <strchr+0x1a>
  for(; *s; s++)
    425a:	0505                	addi	a0,a0,1
    425c:	00054783          	lbu	a5,0(a0)
    4260:	fbfd                	bnez	a5,4256 <strchr+0xc>
      return (char*)s;
  return 0;
    4262:	4501                	li	a0,0
}
    4264:	6422                	ld	s0,8(sp)
    4266:	0141                	addi	sp,sp,16
    4268:	8082                	ret
  return 0;
    426a:	4501                	li	a0,0
    426c:	bfe5                	j	4264 <strchr+0x1a>

000000000000426e <gets>:

char*
gets(char *buf, int max)
{
    426e:	711d                	addi	sp,sp,-96
    4270:	ec86                	sd	ra,88(sp)
    4272:	e8a2                	sd	s0,80(sp)
    4274:	e4a6                	sd	s1,72(sp)
    4276:	e0ca                	sd	s2,64(sp)
    4278:	fc4e                	sd	s3,56(sp)
    427a:	f852                	sd	s4,48(sp)
    427c:	f456                	sd	s5,40(sp)
    427e:	f05a                	sd	s6,32(sp)
    4280:	ec5e                	sd	s7,24(sp)
    4282:	1080                	addi	s0,sp,96
    4284:	8baa                	mv	s7,a0
    4286:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4288:	892a                	mv	s2,a0
    428a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    428c:	4aa9                	li	s5,10
    428e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    4290:	89a6                	mv	s3,s1
    4292:	2485                	addiw	s1,s1,1
    4294:	0344d863          	bge	s1,s4,42c4 <gets+0x56>
    cc = read(0, &c, 1);
    4298:	4605                	li	a2,1
    429a:	faf40593          	addi	a1,s0,-81
    429e:	4501                	li	a0,0
    42a0:	00000097          	auipc	ra,0x0
    42a4:	1f0080e7          	jalr	496(ra) # 4490 <read>
    if(cc < 1)
    42a8:	00a05e63          	blez	a0,42c4 <gets+0x56>
    buf[i++] = c;
    42ac:	faf44783          	lbu	a5,-81(s0)
    42b0:	00f90023          	sb	a5,0(s2) # 3000 <subdir+0x628>
    if(c == '\n' || c == '\r')
    42b4:	01578763          	beq	a5,s5,42c2 <gets+0x54>
    42b8:	0905                	addi	s2,s2,1
    42ba:	fd679be3          	bne	a5,s6,4290 <gets+0x22>
  for(i=0; i+1 < max; ){
    42be:	89a6                	mv	s3,s1
    42c0:	a011                	j	42c4 <gets+0x56>
    42c2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    42c4:	99de                	add	s3,s3,s7
    42c6:	00098023          	sb	zero,0(s3)
  return buf;
}
    42ca:	855e                	mv	a0,s7
    42cc:	60e6                	ld	ra,88(sp)
    42ce:	6446                	ld	s0,80(sp)
    42d0:	64a6                	ld	s1,72(sp)
    42d2:	6906                	ld	s2,64(sp)
    42d4:	79e2                	ld	s3,56(sp)
    42d6:	7a42                	ld	s4,48(sp)
    42d8:	7aa2                	ld	s5,40(sp)
    42da:	7b02                	ld	s6,32(sp)
    42dc:	6be2                	ld	s7,24(sp)
    42de:	6125                	addi	sp,sp,96
    42e0:	8082                	ret

00000000000042e2 <stat>:

int
stat(const char *n, struct stat *st)
{
    42e2:	1101                	addi	sp,sp,-32
    42e4:	ec06                	sd	ra,24(sp)
    42e6:	e822                	sd	s0,16(sp)
    42e8:	e426                	sd	s1,8(sp)
    42ea:	e04a                	sd	s2,0(sp)
    42ec:	1000                	addi	s0,sp,32
    42ee:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    42f0:	4581                	li	a1,0
    42f2:	00000097          	auipc	ra,0x0
    42f6:	1c6080e7          	jalr	454(ra) # 44b8 <open>
  if(fd < 0)
    42fa:	02054563          	bltz	a0,4324 <stat+0x42>
    42fe:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4300:	85ca                	mv	a1,s2
    4302:	00000097          	auipc	ra,0x0
    4306:	1ce080e7          	jalr	462(ra) # 44d0 <fstat>
    430a:	892a                	mv	s2,a0
  close(fd);
    430c:	8526                	mv	a0,s1
    430e:	00000097          	auipc	ra,0x0
    4312:	192080e7          	jalr	402(ra) # 44a0 <close>
  return r;
}
    4316:	854a                	mv	a0,s2
    4318:	60e2                	ld	ra,24(sp)
    431a:	6442                	ld	s0,16(sp)
    431c:	64a2                	ld	s1,8(sp)
    431e:	6902                	ld	s2,0(sp)
    4320:	6105                	addi	sp,sp,32
    4322:	8082                	ret
    return -1;
    4324:	597d                	li	s2,-1
    4326:	bfc5                	j	4316 <stat+0x34>

0000000000004328 <atoi>:

int
atoi(const char *s)
{
    4328:	1141                	addi	sp,sp,-16
    432a:	e422                	sd	s0,8(sp)
    432c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    432e:	00054603          	lbu	a2,0(a0)
    4332:	fd06079b          	addiw	a5,a2,-48
    4336:	0ff7f793          	andi	a5,a5,255
    433a:	4725                	li	a4,9
    433c:	02f76963          	bltu	a4,a5,436e <atoi+0x46>
    4340:	86aa                	mv	a3,a0
  n = 0;
    4342:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    4344:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    4346:	0685                	addi	a3,a3,1
    4348:	0025179b          	slliw	a5,a0,0x2
    434c:	9fa9                	addw	a5,a5,a0
    434e:	0017979b          	slliw	a5,a5,0x1
    4352:	9fb1                	addw	a5,a5,a2
    4354:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4358:	0006c603          	lbu	a2,0(a3) # 1000 <writetest+0xc0>
    435c:	fd06071b          	addiw	a4,a2,-48
    4360:	0ff77713          	andi	a4,a4,255
    4364:	fee5f1e3          	bgeu	a1,a4,4346 <atoi+0x1e>
  return n;
}
    4368:	6422                	ld	s0,8(sp)
    436a:	0141                	addi	sp,sp,16
    436c:	8082                	ret
  n = 0;
    436e:	4501                	li	a0,0
    4370:	bfe5                	j	4368 <atoi+0x40>

0000000000004372 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4372:	1141                	addi	sp,sp,-16
    4374:	e422                	sd	s0,8(sp)
    4376:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    4378:	02c05163          	blez	a2,439a <memmove+0x28>
    437c:	fff6071b          	addiw	a4,a2,-1
    4380:	1702                	slli	a4,a4,0x20
    4382:	9301                	srli	a4,a4,0x20
    4384:	0705                	addi	a4,a4,1
    4386:	972a                	add	a4,a4,a0
  dst = vdst;
    4388:	87aa                	mv	a5,a0
    *dst++ = *src++;
    438a:	0585                	addi	a1,a1,1
    438c:	0785                	addi	a5,a5,1
    438e:	fff5c683          	lbu	a3,-1(a1)
    4392:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    4396:	fee79ae3          	bne	a5,a4,438a <memmove+0x18>
  return vdst;
}
    439a:	6422                	ld	s0,8(sp)
    439c:	0141                	addi	sp,sp,16
    439e:	8082                	ret

00000000000043a0 <lock_init>:

void lock_init(lock_t *l, char *name) {
    43a0:	1141                	addi	sp,sp,-16
    43a2:	e422                	sd	s0,8(sp)
    43a4:	0800                	addi	s0,sp,16
 l->name = name;
    43a6:	e10c                	sd	a1,0(a0)
 l->locked = 0;
    43a8:	00052423          	sw	zero,8(a0)
 //l->guard = 0;
}
    43ac:	6422                	ld	s0,8(sp)
    43ae:	0141                	addi	sp,sp,16
    43b0:	8082                	ret

00000000000043b2 <lock_acquire>:

void lock_acquire(lock_t *l) {
    43b2:	1141                	addi	sp,sp,-16
    43b4:	e422                	sd	s0,8(sp)
    43b6:	0800                	addi	s0,sp,16
  while(__sync_lock_test_and_set(&l->locked, 1) != 0)
    43b8:	4705                	li	a4,1
    43ba:	87ba                	mv	a5,a4
    43bc:	00850693          	addi	a3,a0,8
    43c0:	0cf6a7af          	amoswap.w.aq	a5,a5,(a3)
    43c4:	2781                	sext.w	a5,a5
    43c6:	fbf5                	bnez	a5,43ba <lock_acquire+0x8>
    ;
  __sync_synchronize();
    43c8:	0ff0000f          	fence
}
    43cc:	6422                	ld	s0,8(sp)
    43ce:	0141                	addi	sp,sp,16
    43d0:	8082                	ret

00000000000043d2 <lock_release>:

void lock_release(lock_t *l) {
    43d2:	1141                	addi	sp,sp,-16
    43d4:	e422                	sd	s0,8(sp)
    43d6:	0800                	addi	s0,sp,16
  __sync_synchronize();
    43d8:	0ff0000f          	fence
  __sync_lock_release(&l->locked);
    43dc:	00850793          	addi	a5,a0,8
    43e0:	0f50000f          	fence	iorw,ow
    43e4:	0807a02f          	amoswap.w	zero,zero,(a5)
//  l->locked = 0;
}
    43e8:	6422                	ld	s0,8(sp)
    43ea:	0141                	addi	sp,sp,16
    43ec:	8082                	ret

00000000000043ee <thread_create>:
//    condwakeup(cond->curr);
//  }
//}
int
thread_create(void (*start_routine)(void*, void*), void *arg1, void *arg2)
{
    43ee:	7179                	addi	sp,sp,-48
    43f0:	f406                	sd	ra,40(sp)
    43f2:	f022                	sd	s0,32(sp)
    43f4:	ec26                	sd	s1,24(sp)
    43f6:	e84a                	sd	s2,16(sp)
    43f8:	e44e                	sd	s3,8(sp)
    43fa:	1800                	addi	s0,sp,48
    43fc:	84aa                	mv	s1,a0
    43fe:	892e                	mv	s2,a1
    4400:	89b2                	mv	s3,a2
  void *stack = malloc(PGSIZE*2); //allocate space on the heap, should be 1 page in size and pagesize aligned
    4402:	6509                	lui	a0,0x2
    4404:	00000097          	auipc	ra,0x0
    4408:	512080e7          	jalr	1298(ra) # 4916 <malloc>
    440c:	86aa                	mv	a3,a0
  if((uint64)stack % PGSIZE) { //not aligned
    440e:	03451793          	slli	a5,a0,0x34
    4412:	c799                	beqz	a5,4420 <thread_create+0x32>
    4414:	0347d713          	srli	a4,a5,0x34
    stack = stack + (PGSIZE - (uint64)stack % PGSIZE); //make is pagesize aligned
    4418:	6785                	lui	a5,0x1
    441a:	8f99                	sub	a5,a5,a4
    441c:	00f506b3          	add	a3,a0,a5
  }
  int pid = clone(start_routine, arg1, arg2, stack);
    4420:	864e                	mv	a2,s3
    4422:	85ca                	mv	a1,s2
    4424:	8526                	mv	a0,s1
    4426:	00000097          	auipc	ra,0x0
    442a:	0f2080e7          	jalr	242(ra) # 4518 <clone>
  return pid;
}
    442e:	70a2                	ld	ra,40(sp)
    4430:	7402                	ld	s0,32(sp)
    4432:	64e2                	ld	s1,24(sp)
    4434:	6942                	ld	s2,16(sp)
    4436:	69a2                	ld	s3,8(sp)
    4438:	6145                	addi	sp,sp,48
    443a:	8082                	ret

000000000000443c <thread_join>:

int thread_join() {
    443c:	7179                	addi	sp,sp,-48
    443e:	f406                	sd	ra,40(sp)
    4440:	f022                	sd	s0,32(sp)
    4442:	ec26                	sd	s1,24(sp)
    4444:	1800                	addi	s0,sp,48
  void *ustack = 0;
    4446:	fc043c23          	sd	zero,-40(s0)
  int status = join(&ustack);
    444a:	fd840513          	addi	a0,s0,-40
    444e:	00000097          	auipc	ra,0x0
    4452:	0d2080e7          	jalr	210(ra) # 4520 <join>
    4456:	84aa                	mv	s1,a0
  free(ustack);
    4458:	fd843503          	ld	a0,-40(s0)
    445c:	00000097          	auipc	ra,0x0
    4460:	432080e7          	jalr	1074(ra) # 488e <free>
  return status;
}
    4464:	8526                	mv	a0,s1
    4466:	70a2                	ld	ra,40(sp)
    4468:	7402                	ld	s0,32(sp)
    446a:	64e2                	ld	s1,24(sp)
    446c:	6145                	addi	sp,sp,48
    446e:	8082                	ret

0000000000004470 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4470:	4885                	li	a7,1
 ecall
    4472:	00000073          	ecall
 ret
    4476:	8082                	ret

0000000000004478 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4478:	4889                	li	a7,2
 ecall
    447a:	00000073          	ecall
 ret
    447e:	8082                	ret

0000000000004480 <wait>:
.global wait
wait:
 li a7, SYS_wait
    4480:	488d                	li	a7,3
 ecall
    4482:	00000073          	ecall
 ret
    4486:	8082                	ret

0000000000004488 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4488:	4891                	li	a7,4
 ecall
    448a:	00000073          	ecall
 ret
    448e:	8082                	ret

0000000000004490 <read>:
.global read
read:
 li a7, SYS_read
    4490:	4895                	li	a7,5
 ecall
    4492:	00000073          	ecall
 ret
    4496:	8082                	ret

0000000000004498 <write>:
.global write
write:
 li a7, SYS_write
    4498:	48c1                	li	a7,16
 ecall
    449a:	00000073          	ecall
 ret
    449e:	8082                	ret

00000000000044a0 <close>:
.global close
close:
 li a7, SYS_close
    44a0:	48d5                	li	a7,21
 ecall
    44a2:	00000073          	ecall
 ret
    44a6:	8082                	ret

00000000000044a8 <kill>:
.global kill
kill:
 li a7, SYS_kill
    44a8:	4899                	li	a7,6
 ecall
    44aa:	00000073          	ecall
 ret
    44ae:	8082                	ret

00000000000044b0 <exec>:
.global exec
exec:
 li a7, SYS_exec
    44b0:	489d                	li	a7,7
 ecall
    44b2:	00000073          	ecall
 ret
    44b6:	8082                	ret

00000000000044b8 <open>:
.global open
open:
 li a7, SYS_open
    44b8:	48bd                	li	a7,15
 ecall
    44ba:	00000073          	ecall
 ret
    44be:	8082                	ret

00000000000044c0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    44c0:	48c5                	li	a7,17
 ecall
    44c2:	00000073          	ecall
 ret
    44c6:	8082                	ret

00000000000044c8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    44c8:	48c9                	li	a7,18
 ecall
    44ca:	00000073          	ecall
 ret
    44ce:	8082                	ret

00000000000044d0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    44d0:	48a1                	li	a7,8
 ecall
    44d2:	00000073          	ecall
 ret
    44d6:	8082                	ret

00000000000044d8 <link>:
.global link
link:
 li a7, SYS_link
    44d8:	48cd                	li	a7,19
 ecall
    44da:	00000073          	ecall
 ret
    44de:	8082                	ret

00000000000044e0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    44e0:	48d1                	li	a7,20
 ecall
    44e2:	00000073          	ecall
 ret
    44e6:	8082                	ret

00000000000044e8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    44e8:	48a5                	li	a7,9
 ecall
    44ea:	00000073          	ecall
 ret
    44ee:	8082                	ret

00000000000044f0 <dup>:
.global dup
dup:
 li a7, SYS_dup
    44f0:	48a9                	li	a7,10
 ecall
    44f2:	00000073          	ecall
 ret
    44f6:	8082                	ret

00000000000044f8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    44f8:	48ad                	li	a7,11
 ecall
    44fa:	00000073          	ecall
 ret
    44fe:	8082                	ret

0000000000004500 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    4500:	48b1                	li	a7,12
 ecall
    4502:	00000073          	ecall
 ret
    4506:	8082                	ret

0000000000004508 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    4508:	48b5                	li	a7,13
 ecall
    450a:	00000073          	ecall
 ret
    450e:	8082                	ret

0000000000004510 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4510:	48b9                	li	a7,14
 ecall
    4512:	00000073          	ecall
 ret
    4516:	8082                	ret

0000000000004518 <clone>:
.global clone
clone:
 li a7, SYS_clone
    4518:	48d9                	li	a7,22
 ecall
    451a:	00000073          	ecall
 ret
    451e:	8082                	ret

0000000000004520 <join>:
.global join
join:
 li a7, SYS_join
    4520:	48dd                	li	a7,23
 ecall
    4522:	00000073          	ecall
 ret
    4526:	8082                	ret

0000000000004528 <putc>:
  int type;
};

static void
putc(int fd, char c)
{
    4528:	1101                	addi	sp,sp,-32
    452a:	ec06                	sd	ra,24(sp)
    452c:	e822                	sd	s0,16(sp)
    452e:	1000                	addi	s0,sp,32
    4530:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4534:	4605                	li	a2,1
    4536:	fef40593          	addi	a1,s0,-17
    453a:	00000097          	auipc	ra,0x0
    453e:	f5e080e7          	jalr	-162(ra) # 4498 <write>
}
    4542:	60e2                	ld	ra,24(sp)
    4544:	6442                	ld	s0,16(sp)
    4546:	6105                	addi	sp,sp,32
    4548:	8082                	ret

000000000000454a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    454a:	7139                	addi	sp,sp,-64
    454c:	fc06                	sd	ra,56(sp)
    454e:	f822                	sd	s0,48(sp)
    4550:	f426                	sd	s1,40(sp)
    4552:	f04a                	sd	s2,32(sp)
    4554:	ec4e                	sd	s3,24(sp)
    4556:	0080                	addi	s0,sp,64
    4558:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    455a:	c299                	beqz	a3,4560 <printint+0x16>
    455c:	0805c863          	bltz	a1,45ec <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4560:	2581                	sext.w	a1,a1
  neg = 0;
    4562:	4881                	li	a7,0
    4564:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    4568:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    456a:	2601                	sext.w	a2,a2
    456c:	00002517          	auipc	a0,0x2
    4570:	52c50513          	addi	a0,a0,1324 # 6a98 <digits>
    4574:	883a                	mv	a6,a4
    4576:	2705                	addiw	a4,a4,1
    4578:	02c5f7bb          	remuw	a5,a1,a2
    457c:	1782                	slli	a5,a5,0x20
    457e:	9381                	srli	a5,a5,0x20
    4580:	97aa                	add	a5,a5,a0
    4582:	0007c783          	lbu	a5,0(a5) # 1000 <writetest+0xc0>
    4586:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    458a:	0005879b          	sext.w	a5,a1
    458e:	02c5d5bb          	divuw	a1,a1,a2
    4592:	0685                	addi	a3,a3,1
    4594:	fec7f0e3          	bgeu	a5,a2,4574 <printint+0x2a>
  if(neg)
    4598:	00088b63          	beqz	a7,45ae <printint+0x64>
    buf[i++] = '-';
    459c:	fd040793          	addi	a5,s0,-48
    45a0:	973e                	add	a4,a4,a5
    45a2:	02d00793          	li	a5,45
    45a6:	fef70823          	sb	a5,-16(a4)
    45aa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    45ae:	02e05863          	blez	a4,45de <printint+0x94>
    45b2:	fc040793          	addi	a5,s0,-64
    45b6:	00e78933          	add	s2,a5,a4
    45ba:	fff78993          	addi	s3,a5,-1
    45be:	99ba                	add	s3,s3,a4
    45c0:	377d                	addiw	a4,a4,-1
    45c2:	1702                	slli	a4,a4,0x20
    45c4:	9301                	srli	a4,a4,0x20
    45c6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    45ca:	fff94583          	lbu	a1,-1(s2)
    45ce:	8526                	mv	a0,s1
    45d0:	00000097          	auipc	ra,0x0
    45d4:	f58080e7          	jalr	-168(ra) # 4528 <putc>
  while(--i >= 0)
    45d8:	197d                	addi	s2,s2,-1
    45da:	ff3918e3          	bne	s2,s3,45ca <printint+0x80>
}
    45de:	70e2                	ld	ra,56(sp)
    45e0:	7442                	ld	s0,48(sp)
    45e2:	74a2                	ld	s1,40(sp)
    45e4:	7902                	ld	s2,32(sp)
    45e6:	69e2                	ld	s3,24(sp)
    45e8:	6121                	addi	sp,sp,64
    45ea:	8082                	ret
    x = -xx;
    45ec:	40b005bb          	negw	a1,a1
    neg = 1;
    45f0:	4885                	li	a7,1
    x = -xx;
    45f2:	bf8d                	j	4564 <printint+0x1a>

00000000000045f4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    45f4:	7119                	addi	sp,sp,-128
    45f6:	fc86                	sd	ra,120(sp)
    45f8:	f8a2                	sd	s0,112(sp)
    45fa:	f4a6                	sd	s1,104(sp)
    45fc:	f0ca                	sd	s2,96(sp)
    45fe:	ecce                	sd	s3,88(sp)
    4600:	e8d2                	sd	s4,80(sp)
    4602:	e4d6                	sd	s5,72(sp)
    4604:	e0da                	sd	s6,64(sp)
    4606:	fc5e                	sd	s7,56(sp)
    4608:	f862                	sd	s8,48(sp)
    460a:	f466                	sd	s9,40(sp)
    460c:	f06a                	sd	s10,32(sp)
    460e:	ec6e                	sd	s11,24(sp)
    4610:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4612:	0005c903          	lbu	s2,0(a1)
    4616:	18090f63          	beqz	s2,47b4 <vprintf+0x1c0>
    461a:	8aaa                	mv	s5,a0
    461c:	8b32                	mv	s6,a2
    461e:	00158493          	addi	s1,a1,1
  state = 0;
    4622:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    4624:	02500a13          	li	s4,37
      if(c == 'd'){
    4628:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    462c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    4630:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    4634:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4638:	00002b97          	auipc	s7,0x2
    463c:	460b8b93          	addi	s7,s7,1120 # 6a98 <digits>
    4640:	a839                	j	465e <vprintf+0x6a>
        putc(fd, c);
    4642:	85ca                	mv	a1,s2
    4644:	8556                	mv	a0,s5
    4646:	00000097          	auipc	ra,0x0
    464a:	ee2080e7          	jalr	-286(ra) # 4528 <putc>
    464e:	a019                	j	4654 <vprintf+0x60>
    } else if(state == '%'){
    4650:	01498f63          	beq	s3,s4,466e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    4654:	0485                	addi	s1,s1,1
    4656:	fff4c903          	lbu	s2,-1(s1)
    465a:	14090d63          	beqz	s2,47b4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    465e:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4662:	fe0997e3          	bnez	s3,4650 <vprintf+0x5c>
      if(c == '%'){
    4666:	fd479ee3          	bne	a5,s4,4642 <vprintf+0x4e>
        state = '%';
    466a:	89be                	mv	s3,a5
    466c:	b7e5                	j	4654 <vprintf+0x60>
      if(c == 'd'){
    466e:	05878063          	beq	a5,s8,46ae <vprintf+0xba>
      } else if(c == 'l') {
    4672:	05978c63          	beq	a5,s9,46ca <vprintf+0xd6>
      } else if(c == 'x') {
    4676:	07a78863          	beq	a5,s10,46e6 <vprintf+0xf2>
      } else if(c == 'p') {
    467a:	09b78463          	beq	a5,s11,4702 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    467e:	07300713          	li	a4,115
    4682:	0ce78663          	beq	a5,a4,474e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4686:	06300713          	li	a4,99
    468a:	0ee78e63          	beq	a5,a4,4786 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    468e:	11478863          	beq	a5,s4,479e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    4692:	85d2                	mv	a1,s4
    4694:	8556                	mv	a0,s5
    4696:	00000097          	auipc	ra,0x0
    469a:	e92080e7          	jalr	-366(ra) # 4528 <putc>
        putc(fd, c);
    469e:	85ca                	mv	a1,s2
    46a0:	8556                	mv	a0,s5
    46a2:	00000097          	auipc	ra,0x0
    46a6:	e86080e7          	jalr	-378(ra) # 4528 <putc>
      }
      state = 0;
    46aa:	4981                	li	s3,0
    46ac:	b765                	j	4654 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    46ae:	008b0913          	addi	s2,s6,8
    46b2:	4685                	li	a3,1
    46b4:	4629                	li	a2,10
    46b6:	000b2583          	lw	a1,0(s6)
    46ba:	8556                	mv	a0,s5
    46bc:	00000097          	auipc	ra,0x0
    46c0:	e8e080e7          	jalr	-370(ra) # 454a <printint>
    46c4:	8b4a                	mv	s6,s2
      state = 0;
    46c6:	4981                	li	s3,0
    46c8:	b771                	j	4654 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    46ca:	008b0913          	addi	s2,s6,8
    46ce:	4681                	li	a3,0
    46d0:	4629                	li	a2,10
    46d2:	000b2583          	lw	a1,0(s6)
    46d6:	8556                	mv	a0,s5
    46d8:	00000097          	auipc	ra,0x0
    46dc:	e72080e7          	jalr	-398(ra) # 454a <printint>
    46e0:	8b4a                	mv	s6,s2
      state = 0;
    46e2:	4981                	li	s3,0
    46e4:	bf85                	j	4654 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    46e6:	008b0913          	addi	s2,s6,8
    46ea:	4681                	li	a3,0
    46ec:	4641                	li	a2,16
    46ee:	000b2583          	lw	a1,0(s6)
    46f2:	8556                	mv	a0,s5
    46f4:	00000097          	auipc	ra,0x0
    46f8:	e56080e7          	jalr	-426(ra) # 454a <printint>
    46fc:	8b4a                	mv	s6,s2
      state = 0;
    46fe:	4981                	li	s3,0
    4700:	bf91                	j	4654 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    4702:	008b0793          	addi	a5,s6,8
    4706:	f8f43423          	sd	a5,-120(s0)
    470a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    470e:	03000593          	li	a1,48
    4712:	8556                	mv	a0,s5
    4714:	00000097          	auipc	ra,0x0
    4718:	e14080e7          	jalr	-492(ra) # 4528 <putc>
  putc(fd, 'x');
    471c:	85ea                	mv	a1,s10
    471e:	8556                	mv	a0,s5
    4720:	00000097          	auipc	ra,0x0
    4724:	e08080e7          	jalr	-504(ra) # 4528 <putc>
    4728:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    472a:	03c9d793          	srli	a5,s3,0x3c
    472e:	97de                	add	a5,a5,s7
    4730:	0007c583          	lbu	a1,0(a5)
    4734:	8556                	mv	a0,s5
    4736:	00000097          	auipc	ra,0x0
    473a:	df2080e7          	jalr	-526(ra) # 4528 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    473e:	0992                	slli	s3,s3,0x4
    4740:	397d                	addiw	s2,s2,-1
    4742:	fe0914e3          	bnez	s2,472a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    4746:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    474a:	4981                	li	s3,0
    474c:	b721                	j	4654 <vprintf+0x60>
        s = va_arg(ap, char*);
    474e:	008b0993          	addi	s3,s6,8
    4752:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    4756:	02090163          	beqz	s2,4778 <vprintf+0x184>
        while(*s != 0){
    475a:	00094583          	lbu	a1,0(s2)
    475e:	c9a1                	beqz	a1,47ae <vprintf+0x1ba>
          putc(fd, *s);
    4760:	8556                	mv	a0,s5
    4762:	00000097          	auipc	ra,0x0
    4766:	dc6080e7          	jalr	-570(ra) # 4528 <putc>
          s++;
    476a:	0905                	addi	s2,s2,1
        while(*s != 0){
    476c:	00094583          	lbu	a1,0(s2)
    4770:	f9e5                	bnez	a1,4760 <vprintf+0x16c>
        s = va_arg(ap, char*);
    4772:	8b4e                	mv	s6,s3
      state = 0;
    4774:	4981                	li	s3,0
    4776:	bdf9                	j	4654 <vprintf+0x60>
          s = "(null)";
    4778:	00002917          	auipc	s2,0x2
    477c:	31090913          	addi	s2,s2,784 # 6a88 <malloc+0x2172>
        while(*s != 0){
    4780:	02800593          	li	a1,40
    4784:	bff1                	j	4760 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    4786:	008b0913          	addi	s2,s6,8
    478a:	000b4583          	lbu	a1,0(s6)
    478e:	8556                	mv	a0,s5
    4790:	00000097          	auipc	ra,0x0
    4794:	d98080e7          	jalr	-616(ra) # 4528 <putc>
    4798:	8b4a                	mv	s6,s2
      state = 0;
    479a:	4981                	li	s3,0
    479c:	bd65                	j	4654 <vprintf+0x60>
        putc(fd, c);
    479e:	85d2                	mv	a1,s4
    47a0:	8556                	mv	a0,s5
    47a2:	00000097          	auipc	ra,0x0
    47a6:	d86080e7          	jalr	-634(ra) # 4528 <putc>
      state = 0;
    47aa:	4981                	li	s3,0
    47ac:	b565                	j	4654 <vprintf+0x60>
        s = va_arg(ap, char*);
    47ae:	8b4e                	mv	s6,s3
      state = 0;
    47b0:	4981                	li	s3,0
    47b2:	b54d                	j	4654 <vprintf+0x60>
    }
  }
}
    47b4:	70e6                	ld	ra,120(sp)
    47b6:	7446                	ld	s0,112(sp)
    47b8:	74a6                	ld	s1,104(sp)
    47ba:	7906                	ld	s2,96(sp)
    47bc:	69e6                	ld	s3,88(sp)
    47be:	6a46                	ld	s4,80(sp)
    47c0:	6aa6                	ld	s5,72(sp)
    47c2:	6b06                	ld	s6,64(sp)
    47c4:	7be2                	ld	s7,56(sp)
    47c6:	7c42                	ld	s8,48(sp)
    47c8:	7ca2                	ld	s9,40(sp)
    47ca:	7d02                	ld	s10,32(sp)
    47cc:	6de2                	ld	s11,24(sp)
    47ce:	6109                	addi	sp,sp,128
    47d0:	8082                	ret

00000000000047d2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    47d2:	715d                	addi	sp,sp,-80
    47d4:	ec06                	sd	ra,24(sp)
    47d6:	e822                	sd	s0,16(sp)
    47d8:	1000                	addi	s0,sp,32
    47da:	e010                	sd	a2,0(s0)
    47dc:	e414                	sd	a3,8(s0)
    47de:	e818                	sd	a4,16(s0)
    47e0:	ec1c                	sd	a5,24(s0)
    47e2:	03043023          	sd	a6,32(s0)
    47e6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    47ea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    47ee:	8622                	mv	a2,s0
    47f0:	00000097          	auipc	ra,0x0
    47f4:	e04080e7          	jalr	-508(ra) # 45f4 <vprintf>
}
    47f8:	60e2                	ld	ra,24(sp)
    47fa:	6442                	ld	s0,16(sp)
    47fc:	6161                	addi	sp,sp,80
    47fe:	8082                	ret

0000000000004800 <printf>:

void
printf(const char *fmt, ...)
{
    4800:	7159                	addi	sp,sp,-112
    4802:	f406                	sd	ra,40(sp)
    4804:	f022                	sd	s0,32(sp)
    4806:	ec26                	sd	s1,24(sp)
    4808:	e84a                	sd	s2,16(sp)
    480a:	1800                	addi	s0,sp,48
    480c:	84aa                	mv	s1,a0
    480e:	e40c                	sd	a1,8(s0)
    4810:	e810                	sd	a2,16(s0)
    4812:	ec14                	sd	a3,24(s0)
    4814:	f018                	sd	a4,32(s0)
    4816:	f41c                	sd	a5,40(s0)
    4818:	03043823          	sd	a6,48(s0)
    481c:	03143c23          	sd	a7,56(s0)
  va_list ap;
  lock_acquire(&pr.printf_lock);
    4820:	00008917          	auipc	s2,0x8
    4824:	ac090913          	addi	s2,s2,-1344 # c2e0 <pr>
    4828:	854a                	mv	a0,s2
    482a:	00000097          	auipc	ra,0x0
    482e:	b88080e7          	jalr	-1144(ra) # 43b2 <lock_acquire>

  va_start(ap, fmt);
    4832:	00840613          	addi	a2,s0,8
    4836:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
    483a:	85a6                	mv	a1,s1
    483c:	4505                	li	a0,1
    483e:	00000097          	auipc	ra,0x0
    4842:	db6080e7          	jalr	-586(ra) # 45f4 <vprintf>
  
  lock_release(&pr.printf_lock);
    4846:	854a                	mv	a0,s2
    4848:	00000097          	auipc	ra,0x0
    484c:	b8a080e7          	jalr	-1142(ra) # 43d2 <lock_release>

}
    4850:	70a2                	ld	ra,40(sp)
    4852:	7402                	ld	s0,32(sp)
    4854:	64e2                	ld	s1,24(sp)
    4856:	6942                	ld	s2,16(sp)
    4858:	6165                	addi	sp,sp,112
    485a:	8082                	ret

000000000000485c <printfinit>:

void
printfinit(void)
{
    485c:	1101                	addi	sp,sp,-32
    485e:	ec06                	sd	ra,24(sp)
    4860:	e822                	sd	s0,16(sp)
    4862:	e426                	sd	s1,8(sp)
    4864:	1000                	addi	s0,sp,32
  lock_init(&pr.printf_lock, "pr");
    4866:	00008497          	auipc	s1,0x8
    486a:	a7a48493          	addi	s1,s1,-1414 # c2e0 <pr>
    486e:	00002597          	auipc	a1,0x2
    4872:	22258593          	addi	a1,a1,546 # 6a90 <malloc+0x217a>
    4876:	8526                	mv	a0,s1
    4878:	00000097          	auipc	ra,0x0
    487c:	b28080e7          	jalr	-1240(ra) # 43a0 <lock_init>
  pr.locking = 1;
    4880:	4785                	li	a5,1
    4882:	c89c                	sw	a5,16(s1)
}
    4884:	60e2                	ld	ra,24(sp)
    4886:	6442                	ld	s0,16(sp)
    4888:	64a2                	ld	s1,8(sp)
    488a:	6105                	addi	sp,sp,32
    488c:	8082                	ret

000000000000488e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    488e:	1141                	addi	sp,sp,-16
    4890:	e422                	sd	s0,8(sp)
    4892:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4894:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4898:	00002797          	auipc	a5,0x2
    489c:	2307b783          	ld	a5,560(a5) # 6ac8 <freep>
    48a0:	a805                	j	48d0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    48a2:	4618                	lw	a4,8(a2)
    48a4:	9db9                	addw	a1,a1,a4
    48a6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    48aa:	6398                	ld	a4,0(a5)
    48ac:	6318                	ld	a4,0(a4)
    48ae:	fee53823          	sd	a4,-16(a0)
    48b2:	a091                	j	48f6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    48b4:	ff852703          	lw	a4,-8(a0)
    48b8:	9e39                	addw	a2,a2,a4
    48ba:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    48bc:	ff053703          	ld	a4,-16(a0)
    48c0:	e398                	sd	a4,0(a5)
    48c2:	a099                	j	4908 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    48c4:	6398                	ld	a4,0(a5)
    48c6:	00e7e463          	bltu	a5,a4,48ce <free+0x40>
    48ca:	00e6ea63          	bltu	a3,a4,48de <free+0x50>
{
    48ce:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    48d0:	fed7fae3          	bgeu	a5,a3,48c4 <free+0x36>
    48d4:	6398                	ld	a4,0(a5)
    48d6:	00e6e463          	bltu	a3,a4,48de <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    48da:	fee7eae3          	bltu	a5,a4,48ce <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    48de:	ff852583          	lw	a1,-8(a0)
    48e2:	6390                	ld	a2,0(a5)
    48e4:	02059713          	slli	a4,a1,0x20
    48e8:	9301                	srli	a4,a4,0x20
    48ea:	0712                	slli	a4,a4,0x4
    48ec:	9736                	add	a4,a4,a3
    48ee:	fae60ae3          	beq	a2,a4,48a2 <free+0x14>
    bp->s.ptr = p->s.ptr;
    48f2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    48f6:	4790                	lw	a2,8(a5)
    48f8:	02061713          	slli	a4,a2,0x20
    48fc:	9301                	srli	a4,a4,0x20
    48fe:	0712                	slli	a4,a4,0x4
    4900:	973e                	add	a4,a4,a5
    4902:	fae689e3          	beq	a3,a4,48b4 <free+0x26>
  } else
    p->s.ptr = bp;
    4906:	e394                	sd	a3,0(a5)
  freep = p;
    4908:	00002717          	auipc	a4,0x2
    490c:	1cf73023          	sd	a5,448(a4) # 6ac8 <freep>
}
    4910:	6422                	ld	s0,8(sp)
    4912:	0141                	addi	sp,sp,16
    4914:	8082                	ret

0000000000004916 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    4916:	7139                	addi	sp,sp,-64
    4918:	fc06                	sd	ra,56(sp)
    491a:	f822                	sd	s0,48(sp)
    491c:	f426                	sd	s1,40(sp)
    491e:	f04a                	sd	s2,32(sp)
    4920:	ec4e                	sd	s3,24(sp)
    4922:	e852                	sd	s4,16(sp)
    4924:	e456                	sd	s5,8(sp)
    4926:	e05a                	sd	s6,0(sp)
    4928:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    492a:	02051493          	slli	s1,a0,0x20
    492e:	9081                	srli	s1,s1,0x20
    4930:	04bd                	addi	s1,s1,15
    4932:	8091                	srli	s1,s1,0x4
    4934:	0014899b          	addiw	s3,s1,1
    4938:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    493a:	00002517          	auipc	a0,0x2
    493e:	18e53503          	ld	a0,398(a0) # 6ac8 <freep>
    4942:	c515                	beqz	a0,496e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4944:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4946:	4798                	lw	a4,8(a5)
    4948:	02977f63          	bgeu	a4,s1,4986 <malloc+0x70>
    494c:	8a4e                	mv	s4,s3
    494e:	0009871b          	sext.w	a4,s3
    4952:	6685                	lui	a3,0x1
    4954:	00d77363          	bgeu	a4,a3,495a <malloc+0x44>
    4958:	6a05                	lui	s4,0x1
    495a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    495e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    4962:	00002917          	auipc	s2,0x2
    4966:	16690913          	addi	s2,s2,358 # 6ac8 <freep>
  if(p == (char*)-1)
    496a:	5afd                	li	s5,-1
    496c:	a88d                	j	49de <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    496e:	00008797          	auipc	a5,0x8
    4972:	98a78793          	addi	a5,a5,-1654 # c2f8 <base>
    4976:	00002717          	auipc	a4,0x2
    497a:	14f73923          	sd	a5,338(a4) # 6ac8 <freep>
    497e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    4980:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    4984:	b7e1                	j	494c <malloc+0x36>
      if(p->s.size == nunits)
    4986:	02e48b63          	beq	s1,a4,49bc <malloc+0xa6>
        p->s.size -= nunits;
    498a:	4137073b          	subw	a4,a4,s3
    498e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    4990:	1702                	slli	a4,a4,0x20
    4992:	9301                	srli	a4,a4,0x20
    4994:	0712                	slli	a4,a4,0x4
    4996:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    4998:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    499c:	00002717          	auipc	a4,0x2
    49a0:	12a73623          	sd	a0,300(a4) # 6ac8 <freep>
      return (void*)(p + 1);
    49a4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    49a8:	70e2                	ld	ra,56(sp)
    49aa:	7442                	ld	s0,48(sp)
    49ac:	74a2                	ld	s1,40(sp)
    49ae:	7902                	ld	s2,32(sp)
    49b0:	69e2                	ld	s3,24(sp)
    49b2:	6a42                	ld	s4,16(sp)
    49b4:	6aa2                	ld	s5,8(sp)
    49b6:	6b02                	ld	s6,0(sp)
    49b8:	6121                	addi	sp,sp,64
    49ba:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    49bc:	6398                	ld	a4,0(a5)
    49be:	e118                	sd	a4,0(a0)
    49c0:	bff1                	j	499c <malloc+0x86>
  hp->s.size = nu;
    49c2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    49c6:	0541                	addi	a0,a0,16
    49c8:	00000097          	auipc	ra,0x0
    49cc:	ec6080e7          	jalr	-314(ra) # 488e <free>
  return freep;
    49d0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    49d4:	d971                	beqz	a0,49a8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    49d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    49d8:	4798                	lw	a4,8(a5)
    49da:	fa9776e3          	bgeu	a4,s1,4986 <malloc+0x70>
    if(p == freep)
    49de:	00093703          	ld	a4,0(s2)
    49e2:	853e                	mv	a0,a5
    49e4:	fef719e3          	bne	a4,a5,49d6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    49e8:	8552                	mv	a0,s4
    49ea:	00000097          	auipc	ra,0x0
    49ee:	b16080e7          	jalr	-1258(ra) # 4500 <sbrk>
  if(p == (char*)-1)
    49f2:	fd5518e3          	bne	a0,s5,49c2 <malloc+0xac>
        return 0;
    49f6:	4501                	li	a0,0
    49f8:	bf45                	j	49a8 <malloc+0x92>
