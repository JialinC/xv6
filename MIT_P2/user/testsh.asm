
user/_testsh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <rand>:

// return a random integer.
// from Wikipedia, linear congruential generator, glibc's constants.
unsigned int
rand()
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
  unsigned int a = 1103515245;
  unsigned int c = 12345;
  unsigned int m = (1 << 31);
  seed = (a * seed + c) % m;
       6:	00002717          	auipc	a4,0x2
       a:	85e70713          	addi	a4,a4,-1954 # 1864 <seed>
       e:	4308                	lw	a0,0(a4)
      10:	41c657b7          	lui	a5,0x41c65
      14:	e6d7879b          	addiw	a5,a5,-403
      18:	02f5053b          	mulw	a0,a0,a5
      1c:	678d                	lui	a5,0x3
      1e:	0397879b          	addiw	a5,a5,57
      22:	9d3d                	addw	a0,a0,a5
      24:	1506                	slli	a0,a0,0x21
      26:	9105                	srli	a0,a0,0x21
      28:	c308                	sw	a0,0(a4)
  return seed;
}
      2a:	6422                	ld	s0,8(sp)
      2c:	0141                	addi	sp,sp,16
      2e:	8082                	ret

0000000000000030 <randstring>:

// generate a random string of the indicated length.
char *
randstring(char *buf, int n)
{
      30:	7139                	addi	sp,sp,-64
      32:	fc06                	sd	ra,56(sp)
      34:	f822                	sd	s0,48(sp)
      36:	f426                	sd	s1,40(sp)
      38:	f04a                	sd	s2,32(sp)
      3a:	ec4e                	sd	s3,24(sp)
      3c:	e852                	sd	s4,16(sp)
      3e:	e456                	sd	s5,8(sp)
      40:	e05a                	sd	s6,0(sp)
      42:	0080                	addi	s0,sp,64
      44:	8a2a                	mv	s4,a0
      46:	89ae                	mv	s3,a1
  for(int i = 0; i < n-1; i++)
      48:	4785                	li	a5,1
      4a:	02b7df63          	bge	a5,a1,88 <randstring+0x58>
      4e:	84aa                	mv	s1,a0
      50:	00150913          	addi	s2,a0,1
      54:	ffe5879b          	addiw	a5,a1,-2
      58:	1782                	slli	a5,a5,0x20
      5a:	9381                	srli	a5,a5,0x20
      5c:	993e                	add	s2,s2,a5
    buf[i] = "abcdefghijklmnopqrstuvwxyz"[rand() % 26];
      5e:	00001b17          	auipc	s6,0x1
      62:	3c2b0b13          	addi	s6,s6,962 # 1420 <malloc+0xe8>
      66:	4ae9                	li	s5,26
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <rand>
      70:	035577bb          	remuw	a5,a0,s5
      74:	1782                	slli	a5,a5,0x20
      76:	9381                	srli	a5,a5,0x20
      78:	97da                	add	a5,a5,s6
      7a:	0007c783          	lbu	a5,0(a5) # 3000 <__global_pointer$+0xf9f>
      7e:	00f48023          	sb	a5,0(s1)
  for(int i = 0; i < n-1; i++)
      82:	0485                	addi	s1,s1,1
      84:	ff2492e3          	bne	s1,s2,68 <randstring+0x38>
  buf[n-1] = '\0';
      88:	99d2                	add	s3,s3,s4
      8a:	fe098fa3          	sb	zero,-1(s3)
  return buf;
}
      8e:	8552                	mv	a0,s4
      90:	70e2                	ld	ra,56(sp)
      92:	7442                	ld	s0,48(sp)
      94:	74a2                	ld	s1,40(sp)
      96:	7902                	ld	s2,32(sp)
      98:	69e2                	ld	s3,24(sp)
      9a:	6a42                	ld	s4,16(sp)
      9c:	6aa2                	ld	s5,8(sp)
      9e:	6b02                	ld	s6,0(sp)
      a0:	6121                	addi	sp,sp,64
      a2:	8082                	ret

00000000000000a4 <writefile>:

// create a file with the indicated content.
void
writefile(char *name, char *data)
{
      a4:	7179                	addi	sp,sp,-48
      a6:	f406                	sd	ra,40(sp)
      a8:	f022                	sd	s0,32(sp)
      aa:	ec26                	sd	s1,24(sp)
      ac:	e84a                	sd	s2,16(sp)
      ae:	e44e                	sd	s3,8(sp)
      b0:	1800                	addi	s0,sp,48
      b2:	89aa                	mv	s3,a0
      b4:	892e                	mv	s2,a1
  unlink(name); // since no truncation
      b6:	00001097          	auipc	ra,0x1
      ba:	e7c080e7          	jalr	-388(ra) # f32 <unlink>
  int fd = open(name, O_CREATE|O_WRONLY);
      be:	20100593          	li	a1,513
      c2:	854e                	mv	a0,s3
      c4:	00001097          	auipc	ra,0x1
      c8:	e5e080e7          	jalr	-418(ra) # f22 <open>
  if(fd < 0){
      cc:	04054663          	bltz	a0,118 <writefile+0x74>
      d0:	84aa                	mv	s1,a0
    fprintf(2, "testsh: could not write %s\n", name);
    exit(-1);
  }
  if(write(fd, data, strlen(data)) != strlen(data)){
      d2:	854a                	mv	a0,s2
      d4:	00001097          	auipc	ra,0x1
      d8:	c60080e7          	jalr	-928(ra) # d34 <strlen>
      dc:	0005061b          	sext.w	a2,a0
      e0:	85ca                	mv	a1,s2
      e2:	8526                	mv	a0,s1
      e4:	00001097          	auipc	ra,0x1
      e8:	e1e080e7          	jalr	-482(ra) # f02 <write>
      ec:	89aa                	mv	s3,a0
      ee:	854a                	mv	a0,s2
      f0:	00001097          	auipc	ra,0x1
      f4:	c44080e7          	jalr	-956(ra) # d34 <strlen>
      f8:	2501                	sext.w	a0,a0
      fa:	2981                	sext.w	s3,s3
      fc:	02a99d63          	bne	s3,a0,136 <writefile+0x92>
    fprintf(2, "testsh: write failed\n");
    exit(-1);
  }
  close(fd);
     100:	8526                	mv	a0,s1
     102:	00001097          	auipc	ra,0x1
     106:	e08080e7          	jalr	-504(ra) # f0a <close>
}
     10a:	70a2                	ld	ra,40(sp)
     10c:	7402                	ld	s0,32(sp)
     10e:	64e2                	ld	s1,24(sp)
     110:	6942                	ld	s2,16(sp)
     112:	69a2                	ld	s3,8(sp)
     114:	6145                	addi	sp,sp,48
     116:	8082                	ret
    fprintf(2, "testsh: could not write %s\n", name);
     118:	864e                	mv	a2,s3
     11a:	00001597          	auipc	a1,0x1
     11e:	32658593          	addi	a1,a1,806 # 1440 <malloc+0x108>
     122:	4509                	li	a0,2
     124:	00001097          	auipc	ra,0x1
     128:	128080e7          	jalr	296(ra) # 124c <fprintf>
    exit(-1);
     12c:	557d                	li	a0,-1
     12e:	00001097          	auipc	ra,0x1
     132:	db4080e7          	jalr	-588(ra) # ee2 <exit>
    fprintf(2, "testsh: write failed\n");
     136:	00001597          	auipc	a1,0x1
     13a:	32a58593          	addi	a1,a1,810 # 1460 <malloc+0x128>
     13e:	4509                	li	a0,2
     140:	00001097          	auipc	ra,0x1
     144:	10c080e7          	jalr	268(ra) # 124c <fprintf>
    exit(-1);
     148:	557d                	li	a0,-1
     14a:	00001097          	auipc	ra,0x1
     14e:	d98080e7          	jalr	-616(ra) # ee2 <exit>

0000000000000152 <readfile>:

// return the content of a file.
void
readfile(char *name, char *data, int max)
{
     152:	7179                	addi	sp,sp,-48
     154:	f406                	sd	ra,40(sp)
     156:	f022                	sd	s0,32(sp)
     158:	ec26                	sd	s1,24(sp)
     15a:	e84a                	sd	s2,16(sp)
     15c:	e44e                	sd	s3,8(sp)
     15e:	e052                	sd	s4,0(sp)
     160:	1800                	addi	s0,sp,48
     162:	8a2a                	mv	s4,a0
     164:	84ae                	mv	s1,a1
     166:	89b2                	mv	s3,a2
  data[0] = '\0';
     168:	00058023          	sb	zero,0(a1)
  int fd = open(name, 0);
     16c:	4581                	li	a1,0
     16e:	00001097          	auipc	ra,0x1
     172:	db4080e7          	jalr	-588(ra) # f22 <open>
  if(fd < 0){
     176:	02054d63          	bltz	a0,1b0 <readfile+0x5e>
     17a:	892a                	mv	s2,a0
    fprintf(2, "testsh: open %s failed\n", name);
    return;
  }
  int n = read(fd, data, max-1);
     17c:	fff9861b          	addiw	a2,s3,-1
     180:	85a6                	mv	a1,s1
     182:	00001097          	auipc	ra,0x1
     186:	d78080e7          	jalr	-648(ra) # efa <read>
     18a:	89aa                	mv	s3,a0
  close(fd);
     18c:	854a                	mv	a0,s2
     18e:	00001097          	auipc	ra,0x1
     192:	d7c080e7          	jalr	-644(ra) # f0a <close>
  if(n < 0){
     196:	0209c863          	bltz	s3,1c6 <readfile+0x74>
    fprintf(2, "testsh: read %s failed\n", name);
    return;
  }
  data[n] = '\0';
     19a:	94ce                	add	s1,s1,s3
     19c:	00048023          	sb	zero,0(s1)
}
     1a0:	70a2                	ld	ra,40(sp)
     1a2:	7402                	ld	s0,32(sp)
     1a4:	64e2                	ld	s1,24(sp)
     1a6:	6942                	ld	s2,16(sp)
     1a8:	69a2                	ld	s3,8(sp)
     1aa:	6a02                	ld	s4,0(sp)
     1ac:	6145                	addi	sp,sp,48
     1ae:	8082                	ret
    fprintf(2, "testsh: open %s failed\n", name);
     1b0:	8652                	mv	a2,s4
     1b2:	00001597          	auipc	a1,0x1
     1b6:	2c658593          	addi	a1,a1,710 # 1478 <malloc+0x140>
     1ba:	4509                	li	a0,2
     1bc:	00001097          	auipc	ra,0x1
     1c0:	090080e7          	jalr	144(ra) # 124c <fprintf>
    return;
     1c4:	bff1                	j	1a0 <readfile+0x4e>
    fprintf(2, "testsh: read %s failed\n", name);
     1c6:	8652                	mv	a2,s4
     1c8:	00001597          	auipc	a1,0x1
     1cc:	2c858593          	addi	a1,a1,712 # 1490 <malloc+0x158>
     1d0:	4509                	li	a0,2
     1d2:	00001097          	auipc	ra,0x1
     1d6:	07a080e7          	jalr	122(ra) # 124c <fprintf>
    return;
     1da:	b7d9                	j	1a0 <readfile+0x4e>

00000000000001dc <strstr>:

// look for the small string in the big string;
// return the address in the big string, or 0.
char *
strstr(char *big, char *small)
{
     1dc:	1141                	addi	sp,sp,-16
     1de:	e422                	sd	s0,8(sp)
     1e0:	0800                	addi	s0,sp,16
  if(small[0] == '\0')
     1e2:	0005c883          	lbu	a7,0(a1)
     1e6:	02088b63          	beqz	a7,21c <strstr+0x40>
    return big;
  for(int i = 0; big[i]; i++){
     1ea:	00054783          	lbu	a5,0(a0)
     1ee:	eb89                	bnez	a5,200 <strstr+0x24>
    }
    if(small[j] == '\0'){
      return big + i;
    }
  }
  return 0;
     1f0:	4501                	li	a0,0
     1f2:	a02d                	j	21c <strstr+0x40>
    if(small[j] == '\0'){
     1f4:	c785                	beqz	a5,21c <strstr+0x40>
  for(int i = 0; big[i]; i++){
     1f6:	00180513          	addi	a0,a6,1
     1fa:	00184783          	lbu	a5,1(a6)
     1fe:	c395                	beqz	a5,222 <strstr+0x46>
    for(j = 0; small[j]; j++){
     200:	882a                	mv	a6,a0
     202:	00158693          	addi	a3,a1,1
{
     206:	872a                	mv	a4,a0
    for(j = 0; small[j]; j++){
     208:	87c6                	mv	a5,a7
      if(big[i+j] != small[j]){
     20a:	00074603          	lbu	a2,0(a4)
     20e:	fef613e3          	bne	a2,a5,1f4 <strstr+0x18>
    for(j = 0; small[j]; j++){
     212:	0006c783          	lbu	a5,0(a3)
     216:	0705                	addi	a4,a4,1
     218:	0685                	addi	a3,a3,1
     21a:	fbe5                	bnez	a5,20a <strstr+0x2e>
}
     21c:	6422                	ld	s0,8(sp)
     21e:	0141                	addi	sp,sp,16
     220:	8082                	ret
  return 0;
     222:	4501                	li	a0,0
     224:	bfe5                	j	21c <strstr+0x40>

0000000000000226 <one>:
// its input, collect the output, check that the
// output includes the expect argument.
// if tight = 1, don't allow much extraneous output.
int
one(char *cmd, char *expect, int tight)
{
     226:	710d                	addi	sp,sp,-352
     228:	ee86                	sd	ra,344(sp)
     22a:	eaa2                	sd	s0,336(sp)
     22c:	e6a6                	sd	s1,328(sp)
     22e:	e2ca                	sd	s2,320(sp)
     230:	fe4e                	sd	s3,312(sp)
     232:	1280                	addi	s0,sp,352
     234:	84aa                	mv	s1,a0
     236:	892e                	mv	s2,a1
     238:	89b2                	mv	s3,a2
  char infile[12], outfile[12];

  randstring(infile, sizeof(infile));
     23a:	45b1                	li	a1,12
     23c:	fc040513          	addi	a0,s0,-64
     240:	00000097          	auipc	ra,0x0
     244:	df0080e7          	jalr	-528(ra) # 30 <randstring>
  randstring(outfile, sizeof(outfile));
     248:	45b1                	li	a1,12
     24a:	fb040513          	addi	a0,s0,-80
     24e:	00000097          	auipc	ra,0x0
     252:	de2080e7          	jalr	-542(ra) # 30 <randstring>

  writefile(infile, cmd);
     256:	85a6                	mv	a1,s1
     258:	fc040513          	addi	a0,s0,-64
     25c:	00000097          	auipc	ra,0x0
     260:	e48080e7          	jalr	-440(ra) # a4 <writefile>
  unlink(outfile);
     264:	fb040513          	addi	a0,s0,-80
     268:	00001097          	auipc	ra,0x1
     26c:	cca080e7          	jalr	-822(ra) # f32 <unlink>

  int pid = fork();
     270:	00001097          	auipc	ra,0x1
     274:	c6a080e7          	jalr	-918(ra) # eda <fork>
  if(pid < 0){
     278:	04054f63          	bltz	a0,2d6 <one+0xb0>
     27c:	84aa                	mv	s1,a0
    fprintf(2, "testsh: fork() failed\n");
    exit(-1);
  }

  if(pid == 0){
     27e:	e571                	bnez	a0,34a <one+0x124>
    close(0);
     280:	4501                	li	a0,0
     282:	00001097          	auipc	ra,0x1
     286:	c88080e7          	jalr	-888(ra) # f0a <close>
    if(open(infile, 0) != 0){
     28a:	4581                	li	a1,0
     28c:	fc040513          	addi	a0,s0,-64
     290:	00001097          	auipc	ra,0x1
     294:	c92080e7          	jalr	-878(ra) # f22 <open>
     298:	ed29                	bnez	a0,2f2 <one+0xcc>
      fprintf(2, "testsh: child open != 0\n");
      exit(-1);
    }
    close(1);
     29a:	4505                	li	a0,1
     29c:	00001097          	auipc	ra,0x1
     2a0:	c6e080e7          	jalr	-914(ra) # f0a <close>
    if(open(outfile, O_CREATE|O_WRONLY) != 1){
     2a4:	20100593          	li	a1,513
     2a8:	fb040513          	addi	a0,s0,-80
     2ac:	00001097          	auipc	ra,0x1
     2b0:	c76080e7          	jalr	-906(ra) # f22 <open>
     2b4:	4785                	li	a5,1
     2b6:	04f50c63          	beq	a0,a5,30e <one+0xe8>
      fprintf(2, "testsh: child open != 1\n");
     2ba:	00001597          	auipc	a1,0x1
     2be:	22658593          	addi	a1,a1,550 # 14e0 <malloc+0x1a8>
     2c2:	4509                	li	a0,2
     2c4:	00001097          	auipc	ra,0x1
     2c8:	f88080e7          	jalr	-120(ra) # 124c <fprintf>
      exit(-1);
     2cc:	557d                	li	a0,-1
     2ce:	00001097          	auipc	ra,0x1
     2d2:	c14080e7          	jalr	-1004(ra) # ee2 <exit>
    fprintf(2, "testsh: fork() failed\n");
     2d6:	00001597          	auipc	a1,0x1
     2da:	1d258593          	addi	a1,a1,466 # 14a8 <malloc+0x170>
     2de:	4509                	li	a0,2
     2e0:	00001097          	auipc	ra,0x1
     2e4:	f6c080e7          	jalr	-148(ra) # 124c <fprintf>
    exit(-1);
     2e8:	557d                	li	a0,-1
     2ea:	00001097          	auipc	ra,0x1
     2ee:	bf8080e7          	jalr	-1032(ra) # ee2 <exit>
      fprintf(2, "testsh: child open != 0\n");
     2f2:	00001597          	auipc	a1,0x1
     2f6:	1ce58593          	addi	a1,a1,462 # 14c0 <malloc+0x188>
     2fa:	4509                	li	a0,2
     2fc:	00001097          	auipc	ra,0x1
     300:	f50080e7          	jalr	-176(ra) # 124c <fprintf>
      exit(-1);
     304:	557d                	li	a0,-1
     306:	00001097          	auipc	ra,0x1
     30a:	bdc080e7          	jalr	-1060(ra) # ee2 <exit>
    }
    char *argv[2];
    argv[0] = shname;
     30e:	00001497          	auipc	s1,0x1
     312:	55a48493          	addi	s1,s1,1370 # 1868 <shname>
     316:	6088                	ld	a0,0(s1)
     318:	eaa43023          	sd	a0,-352(s0)
    argv[1] = 0;
     31c:	ea043423          	sd	zero,-344(s0)
    exec(shname, argv);
     320:	ea040593          	addi	a1,s0,-352
     324:	00001097          	auipc	ra,0x1
     328:	bf6080e7          	jalr	-1034(ra) # f1a <exec>
    fprintf(2, "testsh: exec %s failed\n", shname);
     32c:	6090                	ld	a2,0(s1)
     32e:	00001597          	auipc	a1,0x1
     332:	1d258593          	addi	a1,a1,466 # 1500 <malloc+0x1c8>
     336:	4509                	li	a0,2
     338:	00001097          	auipc	ra,0x1
     33c:	f14080e7          	jalr	-236(ra) # 124c <fprintf>
    exit(-1);
     340:	557d                	li	a0,-1
     342:	00001097          	auipc	ra,0x1
     346:	ba0080e7          	jalr	-1120(ra) # ee2 <exit>
  }

  if(wait(0) != pid){
     34a:	4501                	li	a0,0
     34c:	00001097          	auipc	ra,0x1
     350:	b9e080e7          	jalr	-1122(ra) # eea <wait>
     354:	04951c63          	bne	a0,s1,3ac <one+0x186>
    fprintf(2, "testsh: unexpected wait() return\n");
    exit(-1);
  }
  unlink(infile);
     358:	fc040513          	addi	a0,s0,-64
     35c:	00001097          	auipc	ra,0x1
     360:	bd6080e7          	jalr	-1066(ra) # f32 <unlink>

  char out[256];
  readfile(outfile, out, sizeof(out));
     364:	10000613          	li	a2,256
     368:	eb040593          	addi	a1,s0,-336
     36c:	fb040513          	addi	a0,s0,-80
     370:	00000097          	auipc	ra,0x0
     374:	de2080e7          	jalr	-542(ra) # 152 <readfile>
  unlink(outfile);
     378:	fb040513          	addi	a0,s0,-80
     37c:	00001097          	auipc	ra,0x1
     380:	bb6080e7          	jalr	-1098(ra) # f32 <unlink>

  if(strstr(out, expect) != 0){
     384:	85ca                	mv	a1,s2
     386:	eb040513          	addi	a0,s0,-336
     38a:	00000097          	auipc	ra,0x0
     38e:	e52080e7          	jalr	-430(ra) # 1dc <strstr>
      fprintf(2, "testsh: saw expected output, but too much else as well\n");
      return 0; // fail
    }
    return 1; // pass
  }
  return 0; // fail
     392:	4781                	li	a5,0
  if(strstr(out, expect) != 0){
     394:	c501                	beqz	a0,39c <one+0x176>
    return 1; // pass
     396:	4785                	li	a5,1
    if(tight && strlen(out) > strlen(expect) + 10){
     398:	02099863          	bnez	s3,3c8 <one+0x1a2>
}
     39c:	853e                	mv	a0,a5
     39e:	60f6                	ld	ra,344(sp)
     3a0:	6456                	ld	s0,336(sp)
     3a2:	64b6                	ld	s1,328(sp)
     3a4:	6916                	ld	s2,320(sp)
     3a6:	79f2                	ld	s3,312(sp)
     3a8:	6135                	addi	sp,sp,352
     3aa:	8082                	ret
    fprintf(2, "testsh: unexpected wait() return\n");
     3ac:	00001597          	auipc	a1,0x1
     3b0:	16c58593          	addi	a1,a1,364 # 1518 <malloc+0x1e0>
     3b4:	4509                	li	a0,2
     3b6:	00001097          	auipc	ra,0x1
     3ba:	e96080e7          	jalr	-362(ra) # 124c <fprintf>
    exit(-1);
     3be:	557d                	li	a0,-1
     3c0:	00001097          	auipc	ra,0x1
     3c4:	b22080e7          	jalr	-1246(ra) # ee2 <exit>
    if(tight && strlen(out) > strlen(expect) + 10){
     3c8:	eb040513          	addi	a0,s0,-336
     3cc:	00001097          	auipc	ra,0x1
     3d0:	968080e7          	jalr	-1688(ra) # d34 <strlen>
     3d4:	0005049b          	sext.w	s1,a0
     3d8:	854a                	mv	a0,s2
     3da:	00001097          	auipc	ra,0x1
     3de:	95a080e7          	jalr	-1702(ra) # d34 <strlen>
     3e2:	2529                	addiw	a0,a0,10
    return 1; // pass
     3e4:	4785                	li	a5,1
    if(tight && strlen(out) > strlen(expect) + 10){
     3e6:	fa957be3          	bgeu	a0,s1,39c <one+0x176>
      fprintf(2, "testsh: saw expected output, but too much else as well\n");
     3ea:	00001597          	auipc	a1,0x1
     3ee:	15658593          	addi	a1,a1,342 # 1540 <malloc+0x208>
     3f2:	4509                	li	a0,2
     3f4:	00001097          	auipc	ra,0x1
     3f8:	e58080e7          	jalr	-424(ra) # 124c <fprintf>
      return 0; // fail
     3fc:	4781                	li	a5,0
     3fe:	bf79                	j	39c <one+0x176>

0000000000000400 <t1>:

// test a command with arguments.
void
t1(int *ok)
{
     400:	1101                	addi	sp,sp,-32
     402:	ec06                	sd	ra,24(sp)
     404:	e822                	sd	s0,16(sp)
     406:	e426                	sd	s1,8(sp)
     408:	1000                	addi	s0,sp,32
     40a:	84aa                	mv	s1,a0
  printf("simple echo: ");
     40c:	00001517          	auipc	a0,0x1
     410:	16c50513          	addi	a0,a0,364 # 1578 <malloc+0x240>
     414:	00001097          	auipc	ra,0x1
     418:	e66080e7          	jalr	-410(ra) # 127a <printf>
  if(one("echo hello goodbye\n", "hello goodbye", 1) == 0){
     41c:	4605                	li	a2,1
     41e:	00001597          	auipc	a1,0x1
     422:	16a58593          	addi	a1,a1,362 # 1588 <malloc+0x250>
     426:	00001517          	auipc	a0,0x1
     42a:	17250513          	addi	a0,a0,370 # 1598 <malloc+0x260>
     42e:	00000097          	auipc	ra,0x0
     432:	df8080e7          	jalr	-520(ra) # 226 <one>
     436:	e105                	bnez	a0,456 <t1+0x56>
    printf("FAIL\n");
     438:	00001517          	auipc	a0,0x1
     43c:	17850513          	addi	a0,a0,376 # 15b0 <malloc+0x278>
     440:	00001097          	auipc	ra,0x1
     444:	e3a080e7          	jalr	-454(ra) # 127a <printf>
    *ok = 0;
     448:	0004a023          	sw	zero,0(s1)
  } else {
    printf("PASS\n");
  }
}
     44c:	60e2                	ld	ra,24(sp)
     44e:	6442                	ld	s0,16(sp)
     450:	64a2                	ld	s1,8(sp)
     452:	6105                	addi	sp,sp,32
     454:	8082                	ret
    printf("PASS\n");
     456:	00001517          	auipc	a0,0x1
     45a:	16250513          	addi	a0,a0,354 # 15b8 <malloc+0x280>
     45e:	00001097          	auipc	ra,0x1
     462:	e1c080e7          	jalr	-484(ra) # 127a <printf>
}
     466:	b7dd                	j	44c <t1+0x4c>

0000000000000468 <t2>:

// test a command with arguments.
void
t2(int *ok)
{
     468:	1101                	addi	sp,sp,-32
     46a:	ec06                	sd	ra,24(sp)
     46c:	e822                	sd	s0,16(sp)
     46e:	e426                	sd	s1,8(sp)
     470:	1000                	addi	s0,sp,32
     472:	84aa                	mv	s1,a0
  printf("simple grep: ");
     474:	00001517          	auipc	a0,0x1
     478:	14c50513          	addi	a0,a0,332 # 15c0 <malloc+0x288>
     47c:	00001097          	auipc	ra,0x1
     480:	dfe080e7          	jalr	-514(ra) # 127a <printf>
  if(one("grep constitute README\n", "The code in the files that constitute xv6 is", 1) == 0){
     484:	4605                	li	a2,1
     486:	00001597          	auipc	a1,0x1
     48a:	14a58593          	addi	a1,a1,330 # 15d0 <malloc+0x298>
     48e:	00001517          	auipc	a0,0x1
     492:	17250513          	addi	a0,a0,370 # 1600 <malloc+0x2c8>
     496:	00000097          	auipc	ra,0x0
     49a:	d90080e7          	jalr	-624(ra) # 226 <one>
     49e:	e105                	bnez	a0,4be <t2+0x56>
    printf("FAIL\n");
     4a0:	00001517          	auipc	a0,0x1
     4a4:	11050513          	addi	a0,a0,272 # 15b0 <malloc+0x278>
     4a8:	00001097          	auipc	ra,0x1
     4ac:	dd2080e7          	jalr	-558(ra) # 127a <printf>
    *ok = 0;
     4b0:	0004a023          	sw	zero,0(s1)
  } else {
    printf("PASS\n");
  }
}
     4b4:	60e2                	ld	ra,24(sp)
     4b6:	6442                	ld	s0,16(sp)
     4b8:	64a2                	ld	s1,8(sp)
     4ba:	6105                	addi	sp,sp,32
     4bc:	8082                	ret
    printf("PASS\n");
     4be:	00001517          	auipc	a0,0x1
     4c2:	0fa50513          	addi	a0,a0,250 # 15b8 <malloc+0x280>
     4c6:	00001097          	auipc	ra,0x1
     4ca:	db4080e7          	jalr	-588(ra) # 127a <printf>
}
     4ce:	b7dd                	j	4b4 <t2+0x4c>

00000000000004d0 <t3>:

// test a command, then a newline, then another command.
void
t3(int *ok)
{
     4d0:	1101                	addi	sp,sp,-32
     4d2:	ec06                	sd	ra,24(sp)
     4d4:	e822                	sd	s0,16(sp)
     4d6:	e426                	sd	s1,8(sp)
     4d8:	1000                	addi	s0,sp,32
     4da:	84aa                	mv	s1,a0
  printf("two commands: ");
     4dc:	00001517          	auipc	a0,0x1
     4e0:	13c50513          	addi	a0,a0,316 # 1618 <malloc+0x2e0>
     4e4:	00001097          	auipc	ra,0x1
     4e8:	d96080e7          	jalr	-618(ra) # 127a <printf>
  if(one("echo x\necho goodbye\n", "goodbye", 1) == 0){
     4ec:	4605                	li	a2,1
     4ee:	00001597          	auipc	a1,0x1
     4f2:	13a58593          	addi	a1,a1,314 # 1628 <malloc+0x2f0>
     4f6:	00001517          	auipc	a0,0x1
     4fa:	13a50513          	addi	a0,a0,314 # 1630 <malloc+0x2f8>
     4fe:	00000097          	auipc	ra,0x0
     502:	d28080e7          	jalr	-728(ra) # 226 <one>
     506:	e105                	bnez	a0,526 <t3+0x56>
    printf("FAIL\n");
     508:	00001517          	auipc	a0,0x1
     50c:	0a850513          	addi	a0,a0,168 # 15b0 <malloc+0x278>
     510:	00001097          	auipc	ra,0x1
     514:	d6a080e7          	jalr	-662(ra) # 127a <printf>
    *ok = 0;
     518:	0004a023          	sw	zero,0(s1)
  } else {
    printf("PASS\n");
  }
}
     51c:	60e2                	ld	ra,24(sp)
     51e:	6442                	ld	s0,16(sp)
     520:	64a2                	ld	s1,8(sp)
     522:	6105                	addi	sp,sp,32
     524:	8082                	ret
    printf("PASS\n");
     526:	00001517          	auipc	a0,0x1
     52a:	09250513          	addi	a0,a0,146 # 15b8 <malloc+0x280>
     52e:	00001097          	auipc	ra,0x1
     532:	d4c080e7          	jalr	-692(ra) # 127a <printf>
}
     536:	b7dd                	j	51c <t3+0x4c>

0000000000000538 <t4>:

// test output redirection: echo xxx > file
void
t4(int *ok)
{
     538:	7131                	addi	sp,sp,-192
     53a:	fd06                	sd	ra,184(sp)
     53c:	f922                	sd	s0,176(sp)
     53e:	f526                	sd	s1,168(sp)
     540:	0180                	addi	s0,sp,192
     542:	84aa                	mv	s1,a0
  printf("output redirection: ");
     544:	00001517          	auipc	a0,0x1
     548:	10450513          	addi	a0,a0,260 # 1648 <malloc+0x310>
     54c:	00001097          	auipc	ra,0x1
     550:	d2e080e7          	jalr	-722(ra) # 127a <printf>

  char file[16];
  randstring(file, 12);
     554:	45b1                	li	a1,12
     556:	fd040513          	addi	a0,s0,-48
     55a:	00000097          	auipc	ra,0x0
     55e:	ad6080e7          	jalr	-1322(ra) # 30 <randstring>

  char data[16];
  randstring(data, 12);
     562:	45b1                	li	a1,12
     564:	fc040513          	addi	a0,s0,-64
     568:	00000097          	auipc	ra,0x0
     56c:	ac8080e7          	jalr	-1336(ra) # 30 <randstring>

  char cmd[64];
  strcpy(cmd, "echo ");
     570:	00001597          	auipc	a1,0x1
     574:	0f058593          	addi	a1,a1,240 # 1660 <malloc+0x328>
     578:	f8040513          	addi	a0,s0,-128
     57c:	00000097          	auipc	ra,0x0
     580:	770080e7          	jalr	1904(ra) # cec <strcpy>
  strcpy(cmd+strlen(cmd), data);
     584:	f8040513          	addi	a0,s0,-128
     588:	00000097          	auipc	ra,0x0
     58c:	7ac080e7          	jalr	1964(ra) # d34 <strlen>
     590:	1502                	slli	a0,a0,0x20
     592:	9101                	srli	a0,a0,0x20
     594:	fc040593          	addi	a1,s0,-64
     598:	f8040793          	addi	a5,s0,-128
     59c:	953e                	add	a0,a0,a5
     59e:	00000097          	auipc	ra,0x0
     5a2:	74e080e7          	jalr	1870(ra) # cec <strcpy>
  strcpy(cmd+strlen(cmd), " > ");
     5a6:	f8040513          	addi	a0,s0,-128
     5aa:	00000097          	auipc	ra,0x0
     5ae:	78a080e7          	jalr	1930(ra) # d34 <strlen>
     5b2:	1502                	slli	a0,a0,0x20
     5b4:	9101                	srli	a0,a0,0x20
     5b6:	00001597          	auipc	a1,0x1
     5ba:	0b258593          	addi	a1,a1,178 # 1668 <malloc+0x330>
     5be:	f8040793          	addi	a5,s0,-128
     5c2:	953e                	add	a0,a0,a5
     5c4:	00000097          	auipc	ra,0x0
     5c8:	728080e7          	jalr	1832(ra) # cec <strcpy>
  strcpy(cmd+strlen(cmd), file);
     5cc:	f8040513          	addi	a0,s0,-128
     5d0:	00000097          	auipc	ra,0x0
     5d4:	764080e7          	jalr	1892(ra) # d34 <strlen>
     5d8:	1502                	slli	a0,a0,0x20
     5da:	9101                	srli	a0,a0,0x20
     5dc:	fd040593          	addi	a1,s0,-48
     5e0:	f8040793          	addi	a5,s0,-128
     5e4:	953e                	add	a0,a0,a5
     5e6:	00000097          	auipc	ra,0x0
     5ea:	706080e7          	jalr	1798(ra) # cec <strcpy>
  strcpy(cmd+strlen(cmd), "\n");
     5ee:	f8040513          	addi	a0,s0,-128
     5f2:	00000097          	auipc	ra,0x0
     5f6:	742080e7          	jalr	1858(ra) # d34 <strlen>
     5fa:	1502                	slli	a0,a0,0x20
     5fc:	9101                	srli	a0,a0,0x20
     5fe:	00001597          	auipc	a1,0x1
     602:	f3a58593          	addi	a1,a1,-198 # 1538 <malloc+0x200>
     606:	f8040793          	addi	a5,s0,-128
     60a:	953e                	add	a0,a0,a5
     60c:	00000097          	auipc	ra,0x0
     610:	6e0080e7          	jalr	1760(ra) # cec <strcpy>

  if(one(cmd, "", 1) == 0){
     614:	4605                	li	a2,1
     616:	00001597          	auipc	a1,0x1
     61a:	ec258593          	addi	a1,a1,-318 # 14d8 <malloc+0x1a0>
     61e:	f8040513          	addi	a0,s0,-128
     622:	00000097          	auipc	ra,0x0
     626:	c04080e7          	jalr	-1020(ra) # 226 <one>
     62a:	e515                	bnez	a0,656 <t4+0x11e>
    printf("FAIL\n");
     62c:	00001517          	auipc	a0,0x1
     630:	f8450513          	addi	a0,a0,-124 # 15b0 <malloc+0x278>
     634:	00001097          	auipc	ra,0x1
     638:	c46080e7          	jalr	-954(ra) # 127a <printf>
    *ok = 0;
     63c:	0004a023          	sw	zero,0(s1)
    } else {
      printf("PASS\n");
    }
  }

  unlink(file);
     640:	fd040513          	addi	a0,s0,-48
     644:	00001097          	auipc	ra,0x1
     648:	8ee080e7          	jalr	-1810(ra) # f32 <unlink>
}
     64c:	70ea                	ld	ra,184(sp)
     64e:	744a                	ld	s0,176(sp)
     650:	74aa                	ld	s1,168(sp)
     652:	6129                	addi	sp,sp,192
     654:	8082                	ret
    readfile(file, buf, sizeof(buf));
     656:	04000613          	li	a2,64
     65a:	f4040593          	addi	a1,s0,-192
     65e:	fd040513          	addi	a0,s0,-48
     662:	00000097          	auipc	ra,0x0
     666:	af0080e7          	jalr	-1296(ra) # 152 <readfile>
    if(strstr(buf, data) == 0){
     66a:	fc040593          	addi	a1,s0,-64
     66e:	f4040513          	addi	a0,s0,-192
     672:	00000097          	auipc	ra,0x0
     676:	b6a080e7          	jalr	-1174(ra) # 1dc <strstr>
     67a:	c911                	beqz	a0,68e <t4+0x156>
      printf("PASS\n");
     67c:	00001517          	auipc	a0,0x1
     680:	f3c50513          	addi	a0,a0,-196 # 15b8 <malloc+0x280>
     684:	00001097          	auipc	ra,0x1
     688:	bf6080e7          	jalr	-1034(ra) # 127a <printf>
     68c:	bf55                	j	640 <t4+0x108>
      printf("FAIL\n");
     68e:	00001517          	auipc	a0,0x1
     692:	f2250513          	addi	a0,a0,-222 # 15b0 <malloc+0x278>
     696:	00001097          	auipc	ra,0x1
     69a:	be4080e7          	jalr	-1052(ra) # 127a <printf>
      *ok = 0;
     69e:	0004a023          	sw	zero,0(s1)
     6a2:	bf79                	j	640 <t4+0x108>

00000000000006a4 <t5>:

// test input redirection: cat < file
void
t5(int *ok)
{
     6a4:	7119                	addi	sp,sp,-128
     6a6:	fc86                	sd	ra,120(sp)
     6a8:	f8a2                	sd	s0,112(sp)
     6aa:	f4a6                	sd	s1,104(sp)
     6ac:	0100                	addi	s0,sp,128
     6ae:	84aa                	mv	s1,a0
  printf("input redirection: ");
     6b0:	00001517          	auipc	a0,0x1
     6b4:	fc050513          	addi	a0,a0,-64 # 1670 <malloc+0x338>
     6b8:	00001097          	auipc	ra,0x1
     6bc:	bc2080e7          	jalr	-1086(ra) # 127a <printf>

  char file[32];
  randstring(file, 12);
     6c0:	45b1                	li	a1,12
     6c2:	fc040513          	addi	a0,s0,-64
     6c6:	00000097          	auipc	ra,0x0
     6ca:	96a080e7          	jalr	-1686(ra) # 30 <randstring>

  char data[32];
  randstring(data, 12);
     6ce:	45b1                	li	a1,12
     6d0:	fa040513          	addi	a0,s0,-96
     6d4:	00000097          	auipc	ra,0x0
     6d8:	95c080e7          	jalr	-1700(ra) # 30 <randstring>
  writefile(file, data);
     6dc:	fa040593          	addi	a1,s0,-96
     6e0:	fc040513          	addi	a0,s0,-64
     6e4:	00000097          	auipc	ra,0x0
     6e8:	9c0080e7          	jalr	-1600(ra) # a4 <writefile>

  char cmd[32];
  strcpy(cmd, "cat < ");
     6ec:	00001597          	auipc	a1,0x1
     6f0:	f9c58593          	addi	a1,a1,-100 # 1688 <malloc+0x350>
     6f4:	f8040513          	addi	a0,s0,-128
     6f8:	00000097          	auipc	ra,0x0
     6fc:	5f4080e7          	jalr	1524(ra) # cec <strcpy>
  strcpy(cmd+strlen(cmd), file);
     700:	f8040513          	addi	a0,s0,-128
     704:	00000097          	auipc	ra,0x0
     708:	630080e7          	jalr	1584(ra) # d34 <strlen>
     70c:	1502                	slli	a0,a0,0x20
     70e:	9101                	srli	a0,a0,0x20
     710:	fc040593          	addi	a1,s0,-64
     714:	f8040793          	addi	a5,s0,-128
     718:	953e                	add	a0,a0,a5
     71a:	00000097          	auipc	ra,0x0
     71e:	5d2080e7          	jalr	1490(ra) # cec <strcpy>
  strcpy(cmd+strlen(cmd), "\n");
     722:	f8040513          	addi	a0,s0,-128
     726:	00000097          	auipc	ra,0x0
     72a:	60e080e7          	jalr	1550(ra) # d34 <strlen>
     72e:	1502                	slli	a0,a0,0x20
     730:	9101                	srli	a0,a0,0x20
     732:	00001597          	auipc	a1,0x1
     736:	e0658593          	addi	a1,a1,-506 # 1538 <malloc+0x200>
     73a:	f8040793          	addi	a5,s0,-128
     73e:	953e                	add	a0,a0,a5
     740:	00000097          	auipc	ra,0x0
     744:	5ac080e7          	jalr	1452(ra) # cec <strcpy>

  if(one(cmd, data, 1) == 0){
     748:	4605                	li	a2,1
     74a:	fa040593          	addi	a1,s0,-96
     74e:	f8040513          	addi	a0,s0,-128
     752:	00000097          	auipc	ra,0x0
     756:	ad4080e7          	jalr	-1324(ra) # 226 <one>
     75a:	e515                	bnez	a0,786 <t5+0xe2>
    printf("FAIL\n");
     75c:	00001517          	auipc	a0,0x1
     760:	e5450513          	addi	a0,a0,-428 # 15b0 <malloc+0x278>
     764:	00001097          	auipc	ra,0x1
     768:	b16080e7          	jalr	-1258(ra) # 127a <printf>
    *ok = 0;
     76c:	0004a023          	sw	zero,0(s1)
  } else {
    printf("PASS\n");
  }

  unlink(file);
     770:	fc040513          	addi	a0,s0,-64
     774:	00000097          	auipc	ra,0x0
     778:	7be080e7          	jalr	1982(ra) # f32 <unlink>
}
     77c:	70e6                	ld	ra,120(sp)
     77e:	7446                	ld	s0,112(sp)
     780:	74a6                	ld	s1,104(sp)
     782:	6109                	addi	sp,sp,128
     784:	8082                	ret
    printf("PASS\n");
     786:	00001517          	auipc	a0,0x1
     78a:	e3250513          	addi	a0,a0,-462 # 15b8 <malloc+0x280>
     78e:	00001097          	auipc	ra,0x1
     792:	aec080e7          	jalr	-1300(ra) # 127a <printf>
     796:	bfe9                	j	770 <t5+0xcc>

0000000000000798 <t6>:

// test a command with both input and output redirection.
void
t6(int *ok)
{
     798:	711d                	addi	sp,sp,-96
     79a:	ec86                	sd	ra,88(sp)
     79c:	e8a2                	sd	s0,80(sp)
     79e:	e4a6                	sd	s1,72(sp)
     7a0:	1080                	addi	s0,sp,96
     7a2:	84aa                	mv	s1,a0
  printf("both redirections: ");
     7a4:	00001517          	auipc	a0,0x1
     7a8:	eec50513          	addi	a0,a0,-276 # 1690 <malloc+0x358>
     7ac:	00001097          	auipc	ra,0x1
     7b0:	ace080e7          	jalr	-1330(ra) # 127a <printf>
  unlink("testsh.out");
     7b4:	00001517          	auipc	a0,0x1
     7b8:	ef450513          	addi	a0,a0,-268 # 16a8 <malloc+0x370>
     7bc:	00000097          	auipc	ra,0x0
     7c0:	776080e7          	jalr	1910(ra) # f32 <unlink>
  if(one("grep pointers < README > testsh.out\n", "", 1) == 0){
     7c4:	4605                	li	a2,1
     7c6:	00001597          	auipc	a1,0x1
     7ca:	d1258593          	addi	a1,a1,-750 # 14d8 <malloc+0x1a0>
     7ce:	00001517          	auipc	a0,0x1
     7d2:	eea50513          	addi	a0,a0,-278 # 16b8 <malloc+0x380>
     7d6:	00000097          	auipc	ra,0x0
     7da:	a50080e7          	jalr	-1456(ra) # 226 <one>
     7de:	e121                	bnez	a0,81e <t6+0x86>
    printf("FAIL\n");
     7e0:	00001517          	auipc	a0,0x1
     7e4:	dd050513          	addi	a0,a0,-560 # 15b0 <malloc+0x278>
     7e8:	00001097          	auipc	ra,0x1
     7ec:	a92080e7          	jalr	-1390(ra) # 127a <printf>
    printf("A\n");
     7f0:	00001517          	auipc	a0,0x1
     7f4:	ef050513          	addi	a0,a0,-272 # 16e0 <malloc+0x3a8>
     7f8:	00001097          	auipc	ra,0x1
     7fc:	a82080e7          	jalr	-1406(ra) # 127a <printf>
    *ok = 0;
     800:	0004a023          	sw	zero,0(s1)
      *ok = 0;
    } else {
      printf("PASS\n");
    }
  }
  unlink("testsh.out");
     804:	00001517          	auipc	a0,0x1
     808:	ea450513          	addi	a0,a0,-348 # 16a8 <malloc+0x370>
     80c:	00000097          	auipc	ra,0x0
     810:	726080e7          	jalr	1830(ra) # f32 <unlink>
}
     814:	60e6                	ld	ra,88(sp)
     816:	6446                	ld	s0,80(sp)
     818:	64a6                	ld	s1,72(sp)
     81a:	6125                	addi	sp,sp,96
     81c:	8082                	ret
    readfile("testsh.out", buf, sizeof(buf));
     81e:	04000613          	li	a2,64
     822:	fa040593          	addi	a1,s0,-96
     826:	00001517          	auipc	a0,0x1
     82a:	e8250513          	addi	a0,a0,-382 # 16a8 <malloc+0x370>
     82e:	00000097          	auipc	ra,0x0
     832:	924080e7          	jalr	-1756(ra) # 152 <readfile>
    if(strstr(buf, "provides pointers to on-line resources") == 0){
     836:	00001597          	auipc	a1,0x1
     83a:	eb258593          	addi	a1,a1,-334 # 16e8 <malloc+0x3b0>
     83e:	fa040513          	addi	a0,s0,-96
     842:	00000097          	auipc	ra,0x0
     846:	99a080e7          	jalr	-1638(ra) # 1dc <strstr>
     84a:	c911                	beqz	a0,85e <t6+0xc6>
      printf("PASS\n");
     84c:	00001517          	auipc	a0,0x1
     850:	d6c50513          	addi	a0,a0,-660 # 15b8 <malloc+0x280>
     854:	00001097          	auipc	ra,0x1
     858:	a26080e7          	jalr	-1498(ra) # 127a <printf>
     85c:	b765                	j	804 <t6+0x6c>
      printf("FAIL\n");
     85e:	00001517          	auipc	a0,0x1
     862:	d5250513          	addi	a0,a0,-686 # 15b0 <malloc+0x278>
     866:	00001097          	auipc	ra,0x1
     86a:	a14080e7          	jalr	-1516(ra) # 127a <printf>
      printf("B\n");
     86e:	00001517          	auipc	a0,0x1
     872:	ea250513          	addi	a0,a0,-350 # 1710 <malloc+0x3d8>
     876:	00001097          	auipc	ra,0x1
     87a:	a04080e7          	jalr	-1532(ra) # 127a <printf>
      printf("%s\n",buf);
     87e:	fa040593          	addi	a1,s0,-96
     882:	00001517          	auipc	a0,0x1
     886:	bd650513          	addi	a0,a0,-1066 # 1458 <malloc+0x120>
     88a:	00001097          	auipc	ra,0x1
     88e:	9f0080e7          	jalr	-1552(ra) # 127a <printf>
      *ok = 0;
     892:	0004a023          	sw	zero,0(s1)
     896:	b7bd                	j	804 <t6+0x6c>

0000000000000898 <t7>:

// test a pipe with cat filename | cat.
void
t7(int *ok)
{
     898:	7135                	addi	sp,sp,-160
     89a:	ed06                	sd	ra,152(sp)
     89c:	e922                	sd	s0,144(sp)
     89e:	e526                	sd	s1,136(sp)
     8a0:	1100                	addi	s0,sp,160
     8a2:	84aa                	mv	s1,a0
  printf("simple pipe: ");
     8a4:	00001517          	auipc	a0,0x1
     8a8:	e7450513          	addi	a0,a0,-396 # 1718 <malloc+0x3e0>
     8ac:	00001097          	auipc	ra,0x1
     8b0:	9ce080e7          	jalr	-1586(ra) # 127a <printf>

  char name[32], data[32];
  randstring(name, 12);
     8b4:	45b1                	li	a1,12
     8b6:	fc040513          	addi	a0,s0,-64
     8ba:	fffff097          	auipc	ra,0xfffff
     8be:	776080e7          	jalr	1910(ra) # 30 <randstring>
  randstring(data, 12);
     8c2:	45b1                	li	a1,12
     8c4:	fa040513          	addi	a0,s0,-96
     8c8:	fffff097          	auipc	ra,0xfffff
     8cc:	768080e7          	jalr	1896(ra) # 30 <randstring>
  writefile(name, data);
     8d0:	fa040593          	addi	a1,s0,-96
     8d4:	fc040513          	addi	a0,s0,-64
     8d8:	fffff097          	auipc	ra,0xfffff
     8dc:	7cc080e7          	jalr	1996(ra) # a4 <writefile>

  char cmd[64];
  strcpy(cmd, "cat ");
     8e0:	00001597          	auipc	a1,0x1
     8e4:	e4858593          	addi	a1,a1,-440 # 1728 <malloc+0x3f0>
     8e8:	f6040513          	addi	a0,s0,-160
     8ec:	00000097          	auipc	ra,0x0
     8f0:	400080e7          	jalr	1024(ra) # cec <strcpy>
  strcpy(cmd + strlen(cmd), name);
     8f4:	f6040513          	addi	a0,s0,-160
     8f8:	00000097          	auipc	ra,0x0
     8fc:	43c080e7          	jalr	1084(ra) # d34 <strlen>
     900:	1502                	slli	a0,a0,0x20
     902:	9101                	srli	a0,a0,0x20
     904:	fc040593          	addi	a1,s0,-64
     908:	f6040793          	addi	a5,s0,-160
     90c:	953e                	add	a0,a0,a5
     90e:	00000097          	auipc	ra,0x0
     912:	3de080e7          	jalr	990(ra) # cec <strcpy>
  strcpy(cmd + strlen(cmd), " | cat\n");
     916:	f6040513          	addi	a0,s0,-160
     91a:	00000097          	auipc	ra,0x0
     91e:	41a080e7          	jalr	1050(ra) # d34 <strlen>
     922:	1502                	slli	a0,a0,0x20
     924:	9101                	srli	a0,a0,0x20
     926:	00001597          	auipc	a1,0x1
     92a:	e0a58593          	addi	a1,a1,-502 # 1730 <malloc+0x3f8>
     92e:	f6040793          	addi	a5,s0,-160
     932:	953e                	add	a0,a0,a5
     934:	00000097          	auipc	ra,0x0
     938:	3b8080e7          	jalr	952(ra) # cec <strcpy>
  
  if(one(cmd, data, 1) == 0){
     93c:	4605                	li	a2,1
     93e:	fa040593          	addi	a1,s0,-96
     942:	f6040513          	addi	a0,s0,-160
     946:	00000097          	auipc	ra,0x0
     94a:	8e0080e7          	jalr	-1824(ra) # 226 <one>
     94e:	e515                	bnez	a0,97a <t7+0xe2>
    printf("FAIL\n");
     950:	00001517          	auipc	a0,0x1
     954:	c6050513          	addi	a0,a0,-928 # 15b0 <malloc+0x278>
     958:	00001097          	auipc	ra,0x1
     95c:	922080e7          	jalr	-1758(ra) # 127a <printf>
    *ok = 0;
     960:	0004a023          	sw	zero,0(s1)
  } else {
    printf("PASS\n");
  }

  unlink(name);
     964:	fc040513          	addi	a0,s0,-64
     968:	00000097          	auipc	ra,0x0
     96c:	5ca080e7          	jalr	1482(ra) # f32 <unlink>
}
     970:	60ea                	ld	ra,152(sp)
     972:	644a                	ld	s0,144(sp)
     974:	64aa                	ld	s1,136(sp)
     976:	610d                	addi	sp,sp,160
     978:	8082                	ret
    printf("PASS\n");
     97a:	00001517          	auipc	a0,0x1
     97e:	c3e50513          	addi	a0,a0,-962 # 15b8 <malloc+0x280>
     982:	00001097          	auipc	ra,0x1
     986:	8f8080e7          	jalr	-1800(ra) # 127a <printf>
     98a:	bfe9                	j	964 <t7+0xcc>

000000000000098c <t8>:

// test a pipeline that has both redirection and a pipe.
void
t8(int *ok)
{
     98c:	711d                	addi	sp,sp,-96
     98e:	ec86                	sd	ra,88(sp)
     990:	e8a2                	sd	s0,80(sp)
     992:	e4a6                	sd	s1,72(sp)
     994:	1080                	addi	s0,sp,96
     996:	84aa                	mv	s1,a0
  printf("pipe and redirects: ");
     998:	00001517          	auipc	a0,0x1
     99c:	da050513          	addi	a0,a0,-608 # 1738 <malloc+0x400>
     9a0:	00001097          	auipc	ra,0x1
     9a4:	8da080e7          	jalr	-1830(ra) # 127a <printf>
  
  if(one("grep suggestions < README | wc > testsh.out\n", "", 1) == 0){
     9a8:	4605                	li	a2,1
     9aa:	00001597          	auipc	a1,0x1
     9ae:	b2e58593          	addi	a1,a1,-1234 # 14d8 <malloc+0x1a0>
     9b2:	00001517          	auipc	a0,0x1
     9b6:	d9e50513          	addi	a0,a0,-610 # 1750 <malloc+0x418>
     9ba:	00000097          	auipc	ra,0x0
     9be:	86c080e7          	jalr	-1940(ra) # 226 <one>
     9c2:	e905                	bnez	a0,9f2 <t8+0x66>
    printf("FAIL\n");
     9c4:	00001517          	auipc	a0,0x1
     9c8:	bec50513          	addi	a0,a0,-1044 # 15b0 <malloc+0x278>
     9cc:	00001097          	auipc	ra,0x1
     9d0:	8ae080e7          	jalr	-1874(ra) # 127a <printf>
    *ok = 0;
     9d4:	0004a023          	sw	zero,0(s1)
    } else {
      printf("PASS\n");
    }
  }

  unlink("testsh.out");
     9d8:	00001517          	auipc	a0,0x1
     9dc:	cd050513          	addi	a0,a0,-816 # 16a8 <malloc+0x370>
     9e0:	00000097          	auipc	ra,0x0
     9e4:	552080e7          	jalr	1362(ra) # f32 <unlink>
}
     9e8:	60e6                	ld	ra,88(sp)
     9ea:	6446                	ld	s0,80(sp)
     9ec:	64a6                	ld	s1,72(sp)
     9ee:	6125                	addi	sp,sp,96
     9f0:	8082                	ret
    readfile("testsh.out", buf, sizeof(buf));
     9f2:	04000613          	li	a2,64
     9f6:	fa040593          	addi	a1,s0,-96
     9fa:	00001517          	auipc	a0,0x1
     9fe:	cae50513          	addi	a0,a0,-850 # 16a8 <malloc+0x370>
     a02:	fffff097          	auipc	ra,0xfffff
     a06:	750080e7          	jalr	1872(ra) # 152 <readfile>
    if(strstr(buf, "1 11 71") == 0){
     a0a:	00001597          	auipc	a1,0x1
     a0e:	d7658593          	addi	a1,a1,-650 # 1780 <malloc+0x448>
     a12:	fa040513          	addi	a0,s0,-96
     a16:	fffff097          	auipc	ra,0xfffff
     a1a:	7c6080e7          	jalr	1990(ra) # 1dc <strstr>
     a1e:	c911                	beqz	a0,a32 <t8+0xa6>
      printf("PASS\n");
     a20:	00001517          	auipc	a0,0x1
     a24:	b9850513          	addi	a0,a0,-1128 # 15b8 <malloc+0x280>
     a28:	00001097          	auipc	ra,0x1
     a2c:	852080e7          	jalr	-1966(ra) # 127a <printf>
     a30:	b765                	j	9d8 <t8+0x4c>
      printf("FAIL\n");
     a32:	00001517          	auipc	a0,0x1
     a36:	b7e50513          	addi	a0,a0,-1154 # 15b0 <malloc+0x278>
     a3a:	00001097          	auipc	ra,0x1
     a3e:	840080e7          	jalr	-1984(ra) # 127a <printf>
      *ok = 0;
     a42:	0004a023          	sw	zero,0(s1)
     a46:	bf49                	j	9d8 <t8+0x4c>

0000000000000a48 <t9>:

// ask the shell to execute many commands, to check
// if it leaks file descriptors.
void
t9(int *ok)
{
     a48:	7159                	addi	sp,sp,-112
     a4a:	f486                	sd	ra,104(sp)
     a4c:	f0a2                	sd	s0,96(sp)
     a4e:	eca6                	sd	s1,88(sp)
     a50:	e8ca                	sd	s2,80(sp)
     a52:	e4ce                	sd	s3,72(sp)
     a54:	e0d2                	sd	s4,64(sp)
     a56:	fc56                	sd	s5,56(sp)
     a58:	f85a                	sd	s6,48(sp)
     a5a:	f45e                	sd	s7,40(sp)
     a5c:	1880                	addi	s0,sp,112
     a5e:	8baa                	mv	s7,a0
  printf("lots of commands: ");
     a60:	00001517          	auipc	a0,0x1
     a64:	d2850513          	addi	a0,a0,-728 # 1788 <malloc+0x450>
     a68:	00001097          	auipc	ra,0x1
     a6c:	812080e7          	jalr	-2030(ra) # 127a <printf>

  char term[32];
  randstring(term, 12);
     a70:	45b1                	li	a1,12
     a72:	f9040513          	addi	a0,s0,-112
     a76:	fffff097          	auipc	ra,0xfffff
     a7a:	5ba080e7          	jalr	1466(ra) # 30 <randstring>
  
  char *cmd = malloc(25 * 36 + 100);
     a7e:	3e800513          	li	a0,1000
     a82:	00001097          	auipc	ra,0x1
     a86:	8b6080e7          	jalr	-1866(ra) # 1338 <malloc>
  if(cmd == 0){
     a8a:	14050363          	beqz	a0,bd0 <t9+0x188>
     a8e:	84aa                	mv	s1,a0
    fprintf(2, "testsh: malloc failed\n");
    exit(-1);
  }

  cmd[0] = '\0';
     a90:	00050023          	sb	zero,0(a0)
  for(int i = 0; i < 17+(rand()%6); i++){
     a94:	fffff097          	auipc	ra,0xfffff
     a98:	56c080e7          	jalr	1388(ra) # 0 <rand>
     a9c:	4981                	li	s3,0
    strcpy(cmd + strlen(cmd), "echo x < README > tso\n");
     a9e:	00001b17          	auipc	s6,0x1
     aa2:	d1ab0b13          	addi	s6,s6,-742 # 17b8 <malloc+0x480>
    strcpy(cmd + strlen(cmd), "echo x | echo\n");
     aa6:	00001a97          	auipc	s5,0x1
     aaa:	d2aa8a93          	addi	s5,s5,-726 # 17d0 <malloc+0x498>
  for(int i = 0; i < 17+(rand()%6); i++){
     aae:	4a19                	li	s4,6
    strcpy(cmd + strlen(cmd), "echo x < README > tso\n");
     ab0:	8526                	mv	a0,s1
     ab2:	00000097          	auipc	ra,0x0
     ab6:	282080e7          	jalr	642(ra) # d34 <strlen>
     aba:	1502                	slli	a0,a0,0x20
     abc:	9101                	srli	a0,a0,0x20
     abe:	85da                	mv	a1,s6
     ac0:	9526                	add	a0,a0,s1
     ac2:	00000097          	auipc	ra,0x0
     ac6:	22a080e7          	jalr	554(ra) # cec <strcpy>
    strcpy(cmd + strlen(cmd), "echo x | echo\n");
     aca:	8526                	mv	a0,s1
     acc:	00000097          	auipc	ra,0x0
     ad0:	268080e7          	jalr	616(ra) # d34 <strlen>
     ad4:	1502                	slli	a0,a0,0x20
     ad6:	9101                	srli	a0,a0,0x20
     ad8:	85d6                	mv	a1,s5
     ada:	9526                	add	a0,a0,s1
     adc:	00000097          	auipc	ra,0x0
     ae0:	210080e7          	jalr	528(ra) # cec <strcpy>
  for(int i = 0; i < 17+(rand()%6); i++){
     ae4:	0019891b          	addiw	s2,s3,1
     ae8:	0009099b          	sext.w	s3,s2
     aec:	fffff097          	auipc	ra,0xfffff
     af0:	514080e7          	jalr	1300(ra) # 0 <rand>
     af4:	034577bb          	remuw	a5,a0,s4
     af8:	27c5                	addiw	a5,a5,17
     afa:	faf9ebe3          	bltu	s3,a5,ab0 <t9+0x68>
  }
  strcpy(cmd + strlen(cmd), "echo ");
     afe:	8526                	mv	a0,s1
     b00:	00000097          	auipc	ra,0x0
     b04:	234080e7          	jalr	564(ra) # d34 <strlen>
     b08:	1502                	slli	a0,a0,0x20
     b0a:	9101                	srli	a0,a0,0x20
     b0c:	00001597          	auipc	a1,0x1
     b10:	b5458593          	addi	a1,a1,-1196 # 1660 <malloc+0x328>
     b14:	9526                	add	a0,a0,s1
     b16:	00000097          	auipc	ra,0x0
     b1a:	1d6080e7          	jalr	470(ra) # cec <strcpy>
  strcpy(cmd + strlen(cmd), term);
     b1e:	8526                	mv	a0,s1
     b20:	00000097          	auipc	ra,0x0
     b24:	214080e7          	jalr	532(ra) # d34 <strlen>
     b28:	1502                	slli	a0,a0,0x20
     b2a:	9101                	srli	a0,a0,0x20
     b2c:	f9040593          	addi	a1,s0,-112
     b30:	9526                	add	a0,a0,s1
     b32:	00000097          	auipc	ra,0x0
     b36:	1ba080e7          	jalr	442(ra) # cec <strcpy>
  strcpy(cmd + strlen(cmd), " > tso\n");
     b3a:	8526                	mv	a0,s1
     b3c:	00000097          	auipc	ra,0x0
     b40:	1f8080e7          	jalr	504(ra) # d34 <strlen>
     b44:	1502                	slli	a0,a0,0x20
     b46:	9101                	srli	a0,a0,0x20
     b48:	00001597          	auipc	a1,0x1
     b4c:	c9858593          	addi	a1,a1,-872 # 17e0 <malloc+0x4a8>
     b50:	9526                	add	a0,a0,s1
     b52:	00000097          	auipc	ra,0x0
     b56:	19a080e7          	jalr	410(ra) # cec <strcpy>
  strcpy(cmd + strlen(cmd), "cat < tso\n");
     b5a:	8526                	mv	a0,s1
     b5c:	00000097          	auipc	ra,0x0
     b60:	1d8080e7          	jalr	472(ra) # d34 <strlen>
     b64:	1502                	slli	a0,a0,0x20
     b66:	9101                	srli	a0,a0,0x20
     b68:	00001597          	auipc	a1,0x1
     b6c:	c8058593          	addi	a1,a1,-896 # 17e8 <malloc+0x4b0>
     b70:	9526                	add	a0,a0,s1
     b72:	00000097          	auipc	ra,0x0
     b76:	17a080e7          	jalr	378(ra) # cec <strcpy>

  if(one(cmd, term, 0) == 0){
     b7a:	4601                	li	a2,0
     b7c:	f9040593          	addi	a1,s0,-112
     b80:	8526                	mv	a0,s1
     b82:	fffff097          	auipc	ra,0xfffff
     b86:	6a4080e7          	jalr	1700(ra) # 226 <one>
     b8a:	e12d                	bnez	a0,bec <t9+0x1a4>
    printf("FAIL\n");
     b8c:	00001517          	auipc	a0,0x1
     b90:	a2450513          	addi	a0,a0,-1500 # 15b0 <malloc+0x278>
     b94:	00000097          	auipc	ra,0x0
     b98:	6e6080e7          	jalr	1766(ra) # 127a <printf>
    *ok = 0;
     b9c:	000ba023          	sw	zero,0(s7)
  } else {
    printf("PASS\n");
  }

  unlink("tso");
     ba0:	00001517          	auipc	a0,0x1
     ba4:	c5850513          	addi	a0,a0,-936 # 17f8 <malloc+0x4c0>
     ba8:	00000097          	auipc	ra,0x0
     bac:	38a080e7          	jalr	906(ra) # f32 <unlink>
  free(cmd);
     bb0:	8526                	mv	a0,s1
     bb2:	00000097          	auipc	ra,0x0
     bb6:	6fe080e7          	jalr	1790(ra) # 12b0 <free>
}
     bba:	70a6                	ld	ra,104(sp)
     bbc:	7406                	ld	s0,96(sp)
     bbe:	64e6                	ld	s1,88(sp)
     bc0:	6946                	ld	s2,80(sp)
     bc2:	69a6                	ld	s3,72(sp)
     bc4:	6a06                	ld	s4,64(sp)
     bc6:	7ae2                	ld	s5,56(sp)
     bc8:	7b42                	ld	s6,48(sp)
     bca:	7ba2                	ld	s7,40(sp)
     bcc:	6165                	addi	sp,sp,112
     bce:	8082                	ret
    fprintf(2, "testsh: malloc failed\n");
     bd0:	00001597          	auipc	a1,0x1
     bd4:	bd058593          	addi	a1,a1,-1072 # 17a0 <malloc+0x468>
     bd8:	4509                	li	a0,2
     bda:	00000097          	auipc	ra,0x0
     bde:	672080e7          	jalr	1650(ra) # 124c <fprintf>
    exit(-1);
     be2:	557d                	li	a0,-1
     be4:	00000097          	auipc	ra,0x0
     be8:	2fe080e7          	jalr	766(ra) # ee2 <exit>
    printf("PASS\n");
     bec:	00001517          	auipc	a0,0x1
     bf0:	9cc50513          	addi	a0,a0,-1588 # 15b8 <malloc+0x280>
     bf4:	00000097          	auipc	ra,0x0
     bf8:	686080e7          	jalr	1670(ra) # 127a <printf>
     bfc:	b755                	j	ba0 <t9+0x158>

0000000000000bfe <main>:

int
main(int argc, char *argv[])
{
     bfe:	1101                	addi	sp,sp,-32
     c00:	ec06                	sd	ra,24(sp)
     c02:	e822                	sd	s0,16(sp)
     c04:	1000                	addi	s0,sp,32
  if(argc != 2){
     c06:	4789                	li	a5,2
     c08:	02f50063          	beq	a0,a5,c28 <main+0x2a>
    fprintf(2, "Usage: testsh nsh\n");
     c0c:	00001597          	auipc	a1,0x1
     c10:	bf458593          	addi	a1,a1,-1036 # 1800 <malloc+0x4c8>
     c14:	4509                	li	a0,2
     c16:	00000097          	auipc	ra,0x0
     c1a:	636080e7          	jalr	1590(ra) # 124c <fprintf>
    exit(-1);
     c1e:	557d                	li	a0,-1
     c20:	00000097          	auipc	ra,0x0
     c24:	2c2080e7          	jalr	706(ra) # ee2 <exit>
  }
  shname = argv[1];
     c28:	659c                	ld	a5,8(a1)
     c2a:	00001717          	auipc	a4,0x1
     c2e:	c2f73f23          	sd	a5,-962(a4) # 1868 <shname>
  
  seed += getpid();
     c32:	00000097          	auipc	ra,0x0
     c36:	330080e7          	jalr	816(ra) # f62 <getpid>
     c3a:	00001717          	auipc	a4,0x1
     c3e:	c2a70713          	addi	a4,a4,-982 # 1864 <seed>
     c42:	431c                	lw	a5,0(a4)
     c44:	9fa9                	addw	a5,a5,a0
     c46:	c31c                	sw	a5,0(a4)

  int ok = 1;
     c48:	4785                	li	a5,1
     c4a:	fef42623          	sw	a5,-20(s0)

  t1(&ok);
     c4e:	fec40513          	addi	a0,s0,-20
     c52:	fffff097          	auipc	ra,0xfffff
     c56:	7ae080e7          	jalr	1966(ra) # 400 <t1>
  t2(&ok);
     c5a:	fec40513          	addi	a0,s0,-20
     c5e:	00000097          	auipc	ra,0x0
     c62:	80a080e7          	jalr	-2038(ra) # 468 <t2>
  t3(&ok);
     c66:	fec40513          	addi	a0,s0,-20
     c6a:	00000097          	auipc	ra,0x0
     c6e:	866080e7          	jalr	-1946(ra) # 4d0 <t3>
  t4(&ok);
     c72:	fec40513          	addi	a0,s0,-20
     c76:	00000097          	auipc	ra,0x0
     c7a:	8c2080e7          	jalr	-1854(ra) # 538 <t4>
  t5(&ok);
     c7e:	fec40513          	addi	a0,s0,-20
     c82:	00000097          	auipc	ra,0x0
     c86:	a22080e7          	jalr	-1502(ra) # 6a4 <t5>
  t6(&ok);
     c8a:	fec40513          	addi	a0,s0,-20
     c8e:	00000097          	auipc	ra,0x0
     c92:	b0a080e7          	jalr	-1270(ra) # 798 <t6>
  t7(&ok);
     c96:	fec40513          	addi	a0,s0,-20
     c9a:	00000097          	auipc	ra,0x0
     c9e:	bfe080e7          	jalr	-1026(ra) # 898 <t7>
  t8(&ok);
     ca2:	fec40513          	addi	a0,s0,-20
     ca6:	00000097          	auipc	ra,0x0
     caa:	ce6080e7          	jalr	-794(ra) # 98c <t8>
  t9(&ok);
     cae:	fec40513          	addi	a0,s0,-20
     cb2:	00000097          	auipc	ra,0x0
     cb6:	d96080e7          	jalr	-618(ra) # a48 <t9>

  if(ok){
     cba:	fec42783          	lw	a5,-20(s0)
     cbe:	cf91                	beqz	a5,cda <main+0xdc>
    printf("passed all tests\n");
     cc0:	00001517          	auipc	a0,0x1
     cc4:	b5850513          	addi	a0,a0,-1192 # 1818 <malloc+0x4e0>
     cc8:	00000097          	auipc	ra,0x0
     ccc:	5b2080e7          	jalr	1458(ra) # 127a <printf>
  } else {
    printf("failed some tests\n");
  }
  
  exit(0);
     cd0:	4501                	li	a0,0
     cd2:	00000097          	auipc	ra,0x0
     cd6:	210080e7          	jalr	528(ra) # ee2 <exit>
    printf("failed some tests\n");
     cda:	00001517          	auipc	a0,0x1
     cde:	b5650513          	addi	a0,a0,-1194 # 1830 <malloc+0x4f8>
     ce2:	00000097          	auipc	ra,0x0
     ce6:	598080e7          	jalr	1432(ra) # 127a <printf>
     cea:	b7dd                	j	cd0 <main+0xd2>

0000000000000cec <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     cec:	1141                	addi	sp,sp,-16
     cee:	e422                	sd	s0,8(sp)
     cf0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     cf2:	87aa                	mv	a5,a0
     cf4:	0585                	addi	a1,a1,1
     cf6:	0785                	addi	a5,a5,1
     cf8:	fff5c703          	lbu	a4,-1(a1)
     cfc:	fee78fa3          	sb	a4,-1(a5)
     d00:	fb75                	bnez	a4,cf4 <strcpy+0x8>
    ;
  return os;
}
     d02:	6422                	ld	s0,8(sp)
     d04:	0141                	addi	sp,sp,16
     d06:	8082                	ret

0000000000000d08 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     d08:	1141                	addi	sp,sp,-16
     d0a:	e422                	sd	s0,8(sp)
     d0c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     d0e:	00054783          	lbu	a5,0(a0)
     d12:	cb91                	beqz	a5,d26 <strcmp+0x1e>
     d14:	0005c703          	lbu	a4,0(a1)
     d18:	00f71763          	bne	a4,a5,d26 <strcmp+0x1e>
    p++, q++;
     d1c:	0505                	addi	a0,a0,1
     d1e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     d20:	00054783          	lbu	a5,0(a0)
     d24:	fbe5                	bnez	a5,d14 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     d26:	0005c503          	lbu	a0,0(a1)
}
     d2a:	40a7853b          	subw	a0,a5,a0
     d2e:	6422                	ld	s0,8(sp)
     d30:	0141                	addi	sp,sp,16
     d32:	8082                	ret

0000000000000d34 <strlen>:

uint
strlen(const char *s)
{
     d34:	1141                	addi	sp,sp,-16
     d36:	e422                	sd	s0,8(sp)
     d38:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     d3a:	00054783          	lbu	a5,0(a0)
     d3e:	cf91                	beqz	a5,d5a <strlen+0x26>
     d40:	0505                	addi	a0,a0,1
     d42:	87aa                	mv	a5,a0
     d44:	4685                	li	a3,1
     d46:	9e89                	subw	a3,a3,a0
     d48:	00f6853b          	addw	a0,a3,a5
     d4c:	0785                	addi	a5,a5,1
     d4e:	fff7c703          	lbu	a4,-1(a5)
     d52:	fb7d                	bnez	a4,d48 <strlen+0x14>
    ;
  return n;
}
     d54:	6422                	ld	s0,8(sp)
     d56:	0141                	addi	sp,sp,16
     d58:	8082                	ret
  for(n = 0; s[n]; n++)
     d5a:	4501                	li	a0,0
     d5c:	bfe5                	j	d54 <strlen+0x20>

0000000000000d5e <memset>:

void*
memset(void *dst, int c, uint n)
{
     d5e:	1141                	addi	sp,sp,-16
     d60:	e422                	sd	s0,8(sp)
     d62:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     d64:	ce09                	beqz	a2,d7e <memset+0x20>
     d66:	87aa                	mv	a5,a0
     d68:	fff6071b          	addiw	a4,a2,-1
     d6c:	1702                	slli	a4,a4,0x20
     d6e:	9301                	srli	a4,a4,0x20
     d70:	0705                	addi	a4,a4,1
     d72:	972a                	add	a4,a4,a0
    cdst[i] = c;
     d74:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     d78:	0785                	addi	a5,a5,1
     d7a:	fee79de3          	bne	a5,a4,d74 <memset+0x16>
  }
  return dst;
}
     d7e:	6422                	ld	s0,8(sp)
     d80:	0141                	addi	sp,sp,16
     d82:	8082                	ret

0000000000000d84 <strchr>:

char*
strchr(const char *s, char c)
{
     d84:	1141                	addi	sp,sp,-16
     d86:	e422                	sd	s0,8(sp)
     d88:	0800                	addi	s0,sp,16
  for(; *s; s++)
     d8a:	00054783          	lbu	a5,0(a0)
     d8e:	cb99                	beqz	a5,da4 <strchr+0x20>
    if(*s == c)
     d90:	00f58763          	beq	a1,a5,d9e <strchr+0x1a>
  for(; *s; s++)
     d94:	0505                	addi	a0,a0,1
     d96:	00054783          	lbu	a5,0(a0)
     d9a:	fbfd                	bnez	a5,d90 <strchr+0xc>
      return (char*)s;
  return 0;
     d9c:	4501                	li	a0,0
}
     d9e:	6422                	ld	s0,8(sp)
     da0:	0141                	addi	sp,sp,16
     da2:	8082                	ret
  return 0;
     da4:	4501                	li	a0,0
     da6:	bfe5                	j	d9e <strchr+0x1a>

0000000000000da8 <gets>:

char*
gets(char *buf, int max)
{
     da8:	711d                	addi	sp,sp,-96
     daa:	ec86                	sd	ra,88(sp)
     dac:	e8a2                	sd	s0,80(sp)
     dae:	e4a6                	sd	s1,72(sp)
     db0:	e0ca                	sd	s2,64(sp)
     db2:	fc4e                	sd	s3,56(sp)
     db4:	f852                	sd	s4,48(sp)
     db6:	f456                	sd	s5,40(sp)
     db8:	f05a                	sd	s6,32(sp)
     dba:	ec5e                	sd	s7,24(sp)
     dbc:	1080                	addi	s0,sp,96
     dbe:	8baa                	mv	s7,a0
     dc0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     dc2:	892a                	mv	s2,a0
     dc4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     dc6:	4aa9                	li	s5,10
     dc8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     dca:	89a6                	mv	s3,s1
     dcc:	2485                	addiw	s1,s1,1
     dce:	0344d863          	bge	s1,s4,dfe <gets+0x56>
    cc = read(0, &c, 1);
     dd2:	4605                	li	a2,1
     dd4:	faf40593          	addi	a1,s0,-81
     dd8:	4501                	li	a0,0
     dda:	00000097          	auipc	ra,0x0
     dde:	120080e7          	jalr	288(ra) # efa <read>
    if(cc < 1)
     de2:	00a05e63          	blez	a0,dfe <gets+0x56>
    buf[i++] = c;
     de6:	faf44783          	lbu	a5,-81(s0)
     dea:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     dee:	01578763          	beq	a5,s5,dfc <gets+0x54>
     df2:	0905                	addi	s2,s2,1
     df4:	fd679be3          	bne	a5,s6,dca <gets+0x22>
  for(i=0; i+1 < max; ){
     df8:	89a6                	mv	s3,s1
     dfa:	a011                	j	dfe <gets+0x56>
     dfc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     dfe:	99de                	add	s3,s3,s7
     e00:	00098023          	sb	zero,0(s3)
  return buf;
}
     e04:	855e                	mv	a0,s7
     e06:	60e6                	ld	ra,88(sp)
     e08:	6446                	ld	s0,80(sp)
     e0a:	64a6                	ld	s1,72(sp)
     e0c:	6906                	ld	s2,64(sp)
     e0e:	79e2                	ld	s3,56(sp)
     e10:	7a42                	ld	s4,48(sp)
     e12:	7aa2                	ld	s5,40(sp)
     e14:	7b02                	ld	s6,32(sp)
     e16:	6be2                	ld	s7,24(sp)
     e18:	6125                	addi	sp,sp,96
     e1a:	8082                	ret

0000000000000e1c <stat>:

int
stat(const char *n, struct stat *st)
{
     e1c:	1101                	addi	sp,sp,-32
     e1e:	ec06                	sd	ra,24(sp)
     e20:	e822                	sd	s0,16(sp)
     e22:	e426                	sd	s1,8(sp)
     e24:	e04a                	sd	s2,0(sp)
     e26:	1000                	addi	s0,sp,32
     e28:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e2a:	4581                	li	a1,0
     e2c:	00000097          	auipc	ra,0x0
     e30:	0f6080e7          	jalr	246(ra) # f22 <open>
  if(fd < 0)
     e34:	02054563          	bltz	a0,e5e <stat+0x42>
     e38:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     e3a:	85ca                	mv	a1,s2
     e3c:	00000097          	auipc	ra,0x0
     e40:	0fe080e7          	jalr	254(ra) # f3a <fstat>
     e44:	892a                	mv	s2,a0
  close(fd);
     e46:	8526                	mv	a0,s1
     e48:	00000097          	auipc	ra,0x0
     e4c:	0c2080e7          	jalr	194(ra) # f0a <close>
  return r;
}
     e50:	854a                	mv	a0,s2
     e52:	60e2                	ld	ra,24(sp)
     e54:	6442                	ld	s0,16(sp)
     e56:	64a2                	ld	s1,8(sp)
     e58:	6902                	ld	s2,0(sp)
     e5a:	6105                	addi	sp,sp,32
     e5c:	8082                	ret
    return -1;
     e5e:	597d                	li	s2,-1
     e60:	bfc5                	j	e50 <stat+0x34>

0000000000000e62 <atoi>:

int
atoi(const char *s)
{
     e62:	1141                	addi	sp,sp,-16
     e64:	e422                	sd	s0,8(sp)
     e66:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e68:	00054603          	lbu	a2,0(a0)
     e6c:	fd06079b          	addiw	a5,a2,-48
     e70:	0ff7f793          	andi	a5,a5,255
     e74:	4725                	li	a4,9
     e76:	02f76963          	bltu	a4,a5,ea8 <atoi+0x46>
     e7a:	86aa                	mv	a3,a0
  n = 0;
     e7c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     e7e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     e80:	0685                	addi	a3,a3,1
     e82:	0025179b          	slliw	a5,a0,0x2
     e86:	9fa9                	addw	a5,a5,a0
     e88:	0017979b          	slliw	a5,a5,0x1
     e8c:	9fb1                	addw	a5,a5,a2
     e8e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     e92:	0006c603          	lbu	a2,0(a3)
     e96:	fd06071b          	addiw	a4,a2,-48
     e9a:	0ff77713          	andi	a4,a4,255
     e9e:	fee5f1e3          	bgeu	a1,a4,e80 <atoi+0x1e>
  return n;
}
     ea2:	6422                	ld	s0,8(sp)
     ea4:	0141                	addi	sp,sp,16
     ea6:	8082                	ret
  n = 0;
     ea8:	4501                	li	a0,0
     eaa:	bfe5                	j	ea2 <atoi+0x40>

0000000000000eac <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     eac:	1141                	addi	sp,sp,-16
     eae:	e422                	sd	s0,8(sp)
     eb0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     eb2:	02c05163          	blez	a2,ed4 <memmove+0x28>
     eb6:	fff6071b          	addiw	a4,a2,-1
     eba:	1702                	slli	a4,a4,0x20
     ebc:	9301                	srli	a4,a4,0x20
     ebe:	0705                	addi	a4,a4,1
     ec0:	972a                	add	a4,a4,a0
  dst = vdst;
     ec2:	87aa                	mv	a5,a0
    *dst++ = *src++;
     ec4:	0585                	addi	a1,a1,1
     ec6:	0785                	addi	a5,a5,1
     ec8:	fff5c683          	lbu	a3,-1(a1)
     ecc:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
     ed0:	fee79ae3          	bne	a5,a4,ec4 <memmove+0x18>
  return vdst;
}
     ed4:	6422                	ld	s0,8(sp)
     ed6:	0141                	addi	sp,sp,16
     ed8:	8082                	ret

0000000000000eda <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     eda:	4885                	li	a7,1
 ecall
     edc:	00000073          	ecall
 ret
     ee0:	8082                	ret

0000000000000ee2 <exit>:
.global exit
exit:
 li a7, SYS_exit
     ee2:	4889                	li	a7,2
 ecall
     ee4:	00000073          	ecall
 ret
     ee8:	8082                	ret

0000000000000eea <wait>:
.global wait
wait:
 li a7, SYS_wait
     eea:	488d                	li	a7,3
 ecall
     eec:	00000073          	ecall
 ret
     ef0:	8082                	ret

0000000000000ef2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     ef2:	4891                	li	a7,4
 ecall
     ef4:	00000073          	ecall
 ret
     ef8:	8082                	ret

0000000000000efa <read>:
.global read
read:
 li a7, SYS_read
     efa:	4895                	li	a7,5
 ecall
     efc:	00000073          	ecall
 ret
     f00:	8082                	ret

0000000000000f02 <write>:
.global write
write:
 li a7, SYS_write
     f02:	48c1                	li	a7,16
 ecall
     f04:	00000073          	ecall
 ret
     f08:	8082                	ret

0000000000000f0a <close>:
.global close
close:
 li a7, SYS_close
     f0a:	48d5                	li	a7,21
 ecall
     f0c:	00000073          	ecall
 ret
     f10:	8082                	ret

0000000000000f12 <kill>:
.global kill
kill:
 li a7, SYS_kill
     f12:	4899                	li	a7,6
 ecall
     f14:	00000073          	ecall
 ret
     f18:	8082                	ret

0000000000000f1a <exec>:
.global exec
exec:
 li a7, SYS_exec
     f1a:	489d                	li	a7,7
 ecall
     f1c:	00000073          	ecall
 ret
     f20:	8082                	ret

0000000000000f22 <open>:
.global open
open:
 li a7, SYS_open
     f22:	48bd                	li	a7,15
 ecall
     f24:	00000073          	ecall
 ret
     f28:	8082                	ret

0000000000000f2a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     f2a:	48c5                	li	a7,17
 ecall
     f2c:	00000073          	ecall
 ret
     f30:	8082                	ret

0000000000000f32 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f32:	48c9                	li	a7,18
 ecall
     f34:	00000073          	ecall
 ret
     f38:	8082                	ret

0000000000000f3a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f3a:	48a1                	li	a7,8
 ecall
     f3c:	00000073          	ecall
 ret
     f40:	8082                	ret

0000000000000f42 <link>:
.global link
link:
 li a7, SYS_link
     f42:	48cd                	li	a7,19
 ecall
     f44:	00000073          	ecall
 ret
     f48:	8082                	ret

0000000000000f4a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f4a:	48d1                	li	a7,20
 ecall
     f4c:	00000073          	ecall
 ret
     f50:	8082                	ret

0000000000000f52 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f52:	48a5                	li	a7,9
 ecall
     f54:	00000073          	ecall
 ret
     f58:	8082                	ret

0000000000000f5a <dup>:
.global dup
dup:
 li a7, SYS_dup
     f5a:	48a9                	li	a7,10
 ecall
     f5c:	00000073          	ecall
 ret
     f60:	8082                	ret

0000000000000f62 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f62:	48ad                	li	a7,11
 ecall
     f64:	00000073          	ecall
 ret
     f68:	8082                	ret

0000000000000f6a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f6a:	48b1                	li	a7,12
 ecall
     f6c:	00000073          	ecall
 ret
     f70:	8082                	ret

0000000000000f72 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f72:	48b5                	li	a7,13
 ecall
     f74:	00000073          	ecall
 ret
     f78:	8082                	ret

0000000000000f7a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f7a:	48b9                	li	a7,14
 ecall
     f7c:	00000073          	ecall
 ret
     f80:	8082                	ret

0000000000000f82 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
     f82:	48d9                	li	a7,22
 ecall
     f84:	00000073          	ecall
 ret
     f88:	8082                	ret

0000000000000f8a <crash>:
.global crash
crash:
 li a7, SYS_crash
     f8a:	48dd                	li	a7,23
 ecall
     f8c:	00000073          	ecall
 ret
     f90:	8082                	ret

0000000000000f92 <mount>:
.global mount
mount:
 li a7, SYS_mount
     f92:	48e1                	li	a7,24
 ecall
     f94:	00000073          	ecall
 ret
     f98:	8082                	ret

0000000000000f9a <umount>:
.global umount
umount:
 li a7, SYS_umount
     f9a:	48e5                	li	a7,25
 ecall
     f9c:	00000073          	ecall
 ret
     fa0:	8082                	ret

0000000000000fa2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     fa2:	1101                	addi	sp,sp,-32
     fa4:	ec06                	sd	ra,24(sp)
     fa6:	e822                	sd	s0,16(sp)
     fa8:	1000                	addi	s0,sp,32
     faa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     fae:	4605                	li	a2,1
     fb0:	fef40593          	addi	a1,s0,-17
     fb4:	00000097          	auipc	ra,0x0
     fb8:	f4e080e7          	jalr	-178(ra) # f02 <write>
}
     fbc:	60e2                	ld	ra,24(sp)
     fbe:	6442                	ld	s0,16(sp)
     fc0:	6105                	addi	sp,sp,32
     fc2:	8082                	ret

0000000000000fc4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     fc4:	7139                	addi	sp,sp,-64
     fc6:	fc06                	sd	ra,56(sp)
     fc8:	f822                	sd	s0,48(sp)
     fca:	f426                	sd	s1,40(sp)
     fcc:	f04a                	sd	s2,32(sp)
     fce:	ec4e                	sd	s3,24(sp)
     fd0:	0080                	addi	s0,sp,64
     fd2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     fd4:	c299                	beqz	a3,fda <printint+0x16>
     fd6:	0805c863          	bltz	a1,1066 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     fda:	2581                	sext.w	a1,a1
  neg = 0;
     fdc:	4881                	li	a7,0
     fde:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     fe2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     fe4:	2601                	sext.w	a2,a2
     fe6:	00001517          	auipc	a0,0x1
     fea:	86a50513          	addi	a0,a0,-1942 # 1850 <digits>
     fee:	883a                	mv	a6,a4
     ff0:	2705                	addiw	a4,a4,1
     ff2:	02c5f7bb          	remuw	a5,a1,a2
     ff6:	1782                	slli	a5,a5,0x20
     ff8:	9381                	srli	a5,a5,0x20
     ffa:	97aa                	add	a5,a5,a0
     ffc:	0007c783          	lbu	a5,0(a5)
    1000:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1004:	0005879b          	sext.w	a5,a1
    1008:	02c5d5bb          	divuw	a1,a1,a2
    100c:	0685                	addi	a3,a3,1
    100e:	fec7f0e3          	bgeu	a5,a2,fee <printint+0x2a>
  if(neg)
    1012:	00088b63          	beqz	a7,1028 <printint+0x64>
    buf[i++] = '-';
    1016:	fd040793          	addi	a5,s0,-48
    101a:	973e                	add	a4,a4,a5
    101c:	02d00793          	li	a5,45
    1020:	fef70823          	sb	a5,-16(a4)
    1024:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1028:	02e05863          	blez	a4,1058 <printint+0x94>
    102c:	fc040793          	addi	a5,s0,-64
    1030:	00e78933          	add	s2,a5,a4
    1034:	fff78993          	addi	s3,a5,-1
    1038:	99ba                	add	s3,s3,a4
    103a:	377d                	addiw	a4,a4,-1
    103c:	1702                	slli	a4,a4,0x20
    103e:	9301                	srli	a4,a4,0x20
    1040:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1044:	fff94583          	lbu	a1,-1(s2)
    1048:	8526                	mv	a0,s1
    104a:	00000097          	auipc	ra,0x0
    104e:	f58080e7          	jalr	-168(ra) # fa2 <putc>
  while(--i >= 0)
    1052:	197d                	addi	s2,s2,-1
    1054:	ff3918e3          	bne	s2,s3,1044 <printint+0x80>
}
    1058:	70e2                	ld	ra,56(sp)
    105a:	7442                	ld	s0,48(sp)
    105c:	74a2                	ld	s1,40(sp)
    105e:	7902                	ld	s2,32(sp)
    1060:	69e2                	ld	s3,24(sp)
    1062:	6121                	addi	sp,sp,64
    1064:	8082                	ret
    x = -xx;
    1066:	40b005bb          	negw	a1,a1
    neg = 1;
    106a:	4885                	li	a7,1
    x = -xx;
    106c:	bf8d                	j	fde <printint+0x1a>

000000000000106e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    106e:	7119                	addi	sp,sp,-128
    1070:	fc86                	sd	ra,120(sp)
    1072:	f8a2                	sd	s0,112(sp)
    1074:	f4a6                	sd	s1,104(sp)
    1076:	f0ca                	sd	s2,96(sp)
    1078:	ecce                	sd	s3,88(sp)
    107a:	e8d2                	sd	s4,80(sp)
    107c:	e4d6                	sd	s5,72(sp)
    107e:	e0da                	sd	s6,64(sp)
    1080:	fc5e                	sd	s7,56(sp)
    1082:	f862                	sd	s8,48(sp)
    1084:	f466                	sd	s9,40(sp)
    1086:	f06a                	sd	s10,32(sp)
    1088:	ec6e                	sd	s11,24(sp)
    108a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    108c:	0005c903          	lbu	s2,0(a1)
    1090:	18090f63          	beqz	s2,122e <vprintf+0x1c0>
    1094:	8aaa                	mv	s5,a0
    1096:	8b32                	mv	s6,a2
    1098:	00158493          	addi	s1,a1,1
  state = 0;
    109c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    109e:	02500a13          	li	s4,37
      if(c == 'd'){
    10a2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    10a6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    10aa:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    10ae:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10b2:	00000b97          	auipc	s7,0x0
    10b6:	79eb8b93          	addi	s7,s7,1950 # 1850 <digits>
    10ba:	a839                	j	10d8 <vprintf+0x6a>
        putc(fd, c);
    10bc:	85ca                	mv	a1,s2
    10be:	8556                	mv	a0,s5
    10c0:	00000097          	auipc	ra,0x0
    10c4:	ee2080e7          	jalr	-286(ra) # fa2 <putc>
    10c8:	a019                	j	10ce <vprintf+0x60>
    } else if(state == '%'){
    10ca:	01498f63          	beq	s3,s4,10e8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    10ce:	0485                	addi	s1,s1,1
    10d0:	fff4c903          	lbu	s2,-1(s1)
    10d4:	14090d63          	beqz	s2,122e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    10d8:	0009079b          	sext.w	a5,s2
    if(state == 0){
    10dc:	fe0997e3          	bnez	s3,10ca <vprintf+0x5c>
      if(c == '%'){
    10e0:	fd479ee3          	bne	a5,s4,10bc <vprintf+0x4e>
        state = '%';
    10e4:	89be                	mv	s3,a5
    10e6:	b7e5                	j	10ce <vprintf+0x60>
      if(c == 'd'){
    10e8:	05878063          	beq	a5,s8,1128 <vprintf+0xba>
      } else if(c == 'l') {
    10ec:	05978c63          	beq	a5,s9,1144 <vprintf+0xd6>
      } else if(c == 'x') {
    10f0:	07a78863          	beq	a5,s10,1160 <vprintf+0xf2>
      } else if(c == 'p') {
    10f4:	09b78463          	beq	a5,s11,117c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    10f8:	07300713          	li	a4,115
    10fc:	0ce78663          	beq	a5,a4,11c8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1100:	06300713          	li	a4,99
    1104:	0ee78e63          	beq	a5,a4,1200 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    1108:	11478863          	beq	a5,s4,1218 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    110c:	85d2                	mv	a1,s4
    110e:	8556                	mv	a0,s5
    1110:	00000097          	auipc	ra,0x0
    1114:	e92080e7          	jalr	-366(ra) # fa2 <putc>
        putc(fd, c);
    1118:	85ca                	mv	a1,s2
    111a:	8556                	mv	a0,s5
    111c:	00000097          	auipc	ra,0x0
    1120:	e86080e7          	jalr	-378(ra) # fa2 <putc>
      }
      state = 0;
    1124:	4981                	li	s3,0
    1126:	b765                	j	10ce <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    1128:	008b0913          	addi	s2,s6,8
    112c:	4685                	li	a3,1
    112e:	4629                	li	a2,10
    1130:	000b2583          	lw	a1,0(s6)
    1134:	8556                	mv	a0,s5
    1136:	00000097          	auipc	ra,0x0
    113a:	e8e080e7          	jalr	-370(ra) # fc4 <printint>
    113e:	8b4a                	mv	s6,s2
      state = 0;
    1140:	4981                	li	s3,0
    1142:	b771                	j	10ce <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1144:	008b0913          	addi	s2,s6,8
    1148:	4681                	li	a3,0
    114a:	4629                	li	a2,10
    114c:	000b2583          	lw	a1,0(s6)
    1150:	8556                	mv	a0,s5
    1152:	00000097          	auipc	ra,0x0
    1156:	e72080e7          	jalr	-398(ra) # fc4 <printint>
    115a:	8b4a                	mv	s6,s2
      state = 0;
    115c:	4981                	li	s3,0
    115e:	bf85                	j	10ce <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1160:	008b0913          	addi	s2,s6,8
    1164:	4681                	li	a3,0
    1166:	4641                	li	a2,16
    1168:	000b2583          	lw	a1,0(s6)
    116c:	8556                	mv	a0,s5
    116e:	00000097          	auipc	ra,0x0
    1172:	e56080e7          	jalr	-426(ra) # fc4 <printint>
    1176:	8b4a                	mv	s6,s2
      state = 0;
    1178:	4981                	li	s3,0
    117a:	bf91                	j	10ce <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    117c:	008b0793          	addi	a5,s6,8
    1180:	f8f43423          	sd	a5,-120(s0)
    1184:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1188:	03000593          	li	a1,48
    118c:	8556                	mv	a0,s5
    118e:	00000097          	auipc	ra,0x0
    1192:	e14080e7          	jalr	-492(ra) # fa2 <putc>
  putc(fd, 'x');
    1196:	85ea                	mv	a1,s10
    1198:	8556                	mv	a0,s5
    119a:	00000097          	auipc	ra,0x0
    119e:	e08080e7          	jalr	-504(ra) # fa2 <putc>
    11a2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    11a4:	03c9d793          	srli	a5,s3,0x3c
    11a8:	97de                	add	a5,a5,s7
    11aa:	0007c583          	lbu	a1,0(a5)
    11ae:	8556                	mv	a0,s5
    11b0:	00000097          	auipc	ra,0x0
    11b4:	df2080e7          	jalr	-526(ra) # fa2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    11b8:	0992                	slli	s3,s3,0x4
    11ba:	397d                	addiw	s2,s2,-1
    11bc:	fe0914e3          	bnez	s2,11a4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    11c0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    11c4:	4981                	li	s3,0
    11c6:	b721                	j	10ce <vprintf+0x60>
        s = va_arg(ap, char*);
    11c8:	008b0993          	addi	s3,s6,8
    11cc:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    11d0:	02090163          	beqz	s2,11f2 <vprintf+0x184>
        while(*s != 0){
    11d4:	00094583          	lbu	a1,0(s2)
    11d8:	c9a1                	beqz	a1,1228 <vprintf+0x1ba>
          putc(fd, *s);
    11da:	8556                	mv	a0,s5
    11dc:	00000097          	auipc	ra,0x0
    11e0:	dc6080e7          	jalr	-570(ra) # fa2 <putc>
          s++;
    11e4:	0905                	addi	s2,s2,1
        while(*s != 0){
    11e6:	00094583          	lbu	a1,0(s2)
    11ea:	f9e5                	bnez	a1,11da <vprintf+0x16c>
        s = va_arg(ap, char*);
    11ec:	8b4e                	mv	s6,s3
      state = 0;
    11ee:	4981                	li	s3,0
    11f0:	bdf9                	j	10ce <vprintf+0x60>
          s = "(null)";
    11f2:	00000917          	auipc	s2,0x0
    11f6:	65690913          	addi	s2,s2,1622 # 1848 <malloc+0x510>
        while(*s != 0){
    11fa:	02800593          	li	a1,40
    11fe:	bff1                	j	11da <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    1200:	008b0913          	addi	s2,s6,8
    1204:	000b4583          	lbu	a1,0(s6)
    1208:	8556                	mv	a0,s5
    120a:	00000097          	auipc	ra,0x0
    120e:	d98080e7          	jalr	-616(ra) # fa2 <putc>
    1212:	8b4a                	mv	s6,s2
      state = 0;
    1214:	4981                	li	s3,0
    1216:	bd65                	j	10ce <vprintf+0x60>
        putc(fd, c);
    1218:	85d2                	mv	a1,s4
    121a:	8556                	mv	a0,s5
    121c:	00000097          	auipc	ra,0x0
    1220:	d86080e7          	jalr	-634(ra) # fa2 <putc>
      state = 0;
    1224:	4981                	li	s3,0
    1226:	b565                	j	10ce <vprintf+0x60>
        s = va_arg(ap, char*);
    1228:	8b4e                	mv	s6,s3
      state = 0;
    122a:	4981                	li	s3,0
    122c:	b54d                	j	10ce <vprintf+0x60>
    }
  }
}
    122e:	70e6                	ld	ra,120(sp)
    1230:	7446                	ld	s0,112(sp)
    1232:	74a6                	ld	s1,104(sp)
    1234:	7906                	ld	s2,96(sp)
    1236:	69e6                	ld	s3,88(sp)
    1238:	6a46                	ld	s4,80(sp)
    123a:	6aa6                	ld	s5,72(sp)
    123c:	6b06                	ld	s6,64(sp)
    123e:	7be2                	ld	s7,56(sp)
    1240:	7c42                	ld	s8,48(sp)
    1242:	7ca2                	ld	s9,40(sp)
    1244:	7d02                	ld	s10,32(sp)
    1246:	6de2                	ld	s11,24(sp)
    1248:	6109                	addi	sp,sp,128
    124a:	8082                	ret

000000000000124c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    124c:	715d                	addi	sp,sp,-80
    124e:	ec06                	sd	ra,24(sp)
    1250:	e822                	sd	s0,16(sp)
    1252:	1000                	addi	s0,sp,32
    1254:	e010                	sd	a2,0(s0)
    1256:	e414                	sd	a3,8(s0)
    1258:	e818                	sd	a4,16(s0)
    125a:	ec1c                	sd	a5,24(s0)
    125c:	03043023          	sd	a6,32(s0)
    1260:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1264:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1268:	8622                	mv	a2,s0
    126a:	00000097          	auipc	ra,0x0
    126e:	e04080e7          	jalr	-508(ra) # 106e <vprintf>
}
    1272:	60e2                	ld	ra,24(sp)
    1274:	6442                	ld	s0,16(sp)
    1276:	6161                	addi	sp,sp,80
    1278:	8082                	ret

000000000000127a <printf>:

void
printf(const char *fmt, ...)
{
    127a:	711d                	addi	sp,sp,-96
    127c:	ec06                	sd	ra,24(sp)
    127e:	e822                	sd	s0,16(sp)
    1280:	1000                	addi	s0,sp,32
    1282:	e40c                	sd	a1,8(s0)
    1284:	e810                	sd	a2,16(s0)
    1286:	ec14                	sd	a3,24(s0)
    1288:	f018                	sd	a4,32(s0)
    128a:	f41c                	sd	a5,40(s0)
    128c:	03043823          	sd	a6,48(s0)
    1290:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1294:	00840613          	addi	a2,s0,8
    1298:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    129c:	85aa                	mv	a1,a0
    129e:	4505                	li	a0,1
    12a0:	00000097          	auipc	ra,0x0
    12a4:	dce080e7          	jalr	-562(ra) # 106e <vprintf>
}
    12a8:	60e2                	ld	ra,24(sp)
    12aa:	6442                	ld	s0,16(sp)
    12ac:	6125                	addi	sp,sp,96
    12ae:	8082                	ret

00000000000012b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    12b0:	1141                	addi	sp,sp,-16
    12b2:	e422                	sd	s0,8(sp)
    12b4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12b6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12ba:	00000797          	auipc	a5,0x0
    12be:	5b67b783          	ld	a5,1462(a5) # 1870 <freep>
    12c2:	a805                	j	12f2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    12c4:	4618                	lw	a4,8(a2)
    12c6:	9db9                	addw	a1,a1,a4
    12c8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    12cc:	6398                	ld	a4,0(a5)
    12ce:	6318                	ld	a4,0(a4)
    12d0:	fee53823          	sd	a4,-16(a0)
    12d4:	a091                	j	1318 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    12d6:	ff852703          	lw	a4,-8(a0)
    12da:	9e39                	addw	a2,a2,a4
    12dc:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    12de:	ff053703          	ld	a4,-16(a0)
    12e2:	e398                	sd	a4,0(a5)
    12e4:	a099                	j	132a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12e6:	6398                	ld	a4,0(a5)
    12e8:	00e7e463          	bltu	a5,a4,12f0 <free+0x40>
    12ec:	00e6ea63          	bltu	a3,a4,1300 <free+0x50>
{
    12f0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12f2:	fed7fae3          	bgeu	a5,a3,12e6 <free+0x36>
    12f6:	6398                	ld	a4,0(a5)
    12f8:	00e6e463          	bltu	a3,a4,1300 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12fc:	fee7eae3          	bltu	a5,a4,12f0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1300:	ff852583          	lw	a1,-8(a0)
    1304:	6390                	ld	a2,0(a5)
    1306:	02059713          	slli	a4,a1,0x20
    130a:	9301                	srli	a4,a4,0x20
    130c:	0712                	slli	a4,a4,0x4
    130e:	9736                	add	a4,a4,a3
    1310:	fae60ae3          	beq	a2,a4,12c4 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1314:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1318:	4790                	lw	a2,8(a5)
    131a:	02061713          	slli	a4,a2,0x20
    131e:	9301                	srli	a4,a4,0x20
    1320:	0712                	slli	a4,a4,0x4
    1322:	973e                	add	a4,a4,a5
    1324:	fae689e3          	beq	a3,a4,12d6 <free+0x26>
  } else
    p->s.ptr = bp;
    1328:	e394                	sd	a3,0(a5)
  freep = p;
    132a:	00000717          	auipc	a4,0x0
    132e:	54f73323          	sd	a5,1350(a4) # 1870 <freep>
}
    1332:	6422                	ld	s0,8(sp)
    1334:	0141                	addi	sp,sp,16
    1336:	8082                	ret

0000000000001338 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1338:	7139                	addi	sp,sp,-64
    133a:	fc06                	sd	ra,56(sp)
    133c:	f822                	sd	s0,48(sp)
    133e:	f426                	sd	s1,40(sp)
    1340:	f04a                	sd	s2,32(sp)
    1342:	ec4e                	sd	s3,24(sp)
    1344:	e852                	sd	s4,16(sp)
    1346:	e456                	sd	s5,8(sp)
    1348:	e05a                	sd	s6,0(sp)
    134a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    134c:	02051493          	slli	s1,a0,0x20
    1350:	9081                	srli	s1,s1,0x20
    1352:	04bd                	addi	s1,s1,15
    1354:	8091                	srli	s1,s1,0x4
    1356:	0014899b          	addiw	s3,s1,1
    135a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    135c:	00000517          	auipc	a0,0x0
    1360:	51453503          	ld	a0,1300(a0) # 1870 <freep>
    1364:	c515                	beqz	a0,1390 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1366:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1368:	4798                	lw	a4,8(a5)
    136a:	02977f63          	bgeu	a4,s1,13a8 <malloc+0x70>
    136e:	8a4e                	mv	s4,s3
    1370:	0009871b          	sext.w	a4,s3
    1374:	6685                	lui	a3,0x1
    1376:	00d77363          	bgeu	a4,a3,137c <malloc+0x44>
    137a:	6a05                	lui	s4,0x1
    137c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1380:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1384:	00000917          	auipc	s2,0x0
    1388:	4ec90913          	addi	s2,s2,1260 # 1870 <freep>
  if(p == (char*)-1)
    138c:	5afd                	li	s5,-1
    138e:	a88d                	j	1400 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    1390:	00000797          	auipc	a5,0x0
    1394:	4e878793          	addi	a5,a5,1256 # 1878 <base>
    1398:	00000717          	auipc	a4,0x0
    139c:	4cf73c23          	sd	a5,1240(a4) # 1870 <freep>
    13a0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    13a2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    13a6:	b7e1                	j	136e <malloc+0x36>
      if(p->s.size == nunits)
    13a8:	02e48b63          	beq	s1,a4,13de <malloc+0xa6>
        p->s.size -= nunits;
    13ac:	4137073b          	subw	a4,a4,s3
    13b0:	c798                	sw	a4,8(a5)
        p += p->s.size;
    13b2:	1702                	slli	a4,a4,0x20
    13b4:	9301                	srli	a4,a4,0x20
    13b6:	0712                	slli	a4,a4,0x4
    13b8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    13ba:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    13be:	00000717          	auipc	a4,0x0
    13c2:	4aa73923          	sd	a0,1202(a4) # 1870 <freep>
      return (void*)(p + 1);
    13c6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    13ca:	70e2                	ld	ra,56(sp)
    13cc:	7442                	ld	s0,48(sp)
    13ce:	74a2                	ld	s1,40(sp)
    13d0:	7902                	ld	s2,32(sp)
    13d2:	69e2                	ld	s3,24(sp)
    13d4:	6a42                	ld	s4,16(sp)
    13d6:	6aa2                	ld	s5,8(sp)
    13d8:	6b02                	ld	s6,0(sp)
    13da:	6121                	addi	sp,sp,64
    13dc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    13de:	6398                	ld	a4,0(a5)
    13e0:	e118                	sd	a4,0(a0)
    13e2:	bff1                	j	13be <malloc+0x86>
  hp->s.size = nu;
    13e4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    13e8:	0541                	addi	a0,a0,16
    13ea:	00000097          	auipc	ra,0x0
    13ee:	ec6080e7          	jalr	-314(ra) # 12b0 <free>
  return freep;
    13f2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    13f6:	d971                	beqz	a0,13ca <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    13fa:	4798                	lw	a4,8(a5)
    13fc:	fa9776e3          	bgeu	a4,s1,13a8 <malloc+0x70>
    if(p == freep)
    1400:	00093703          	ld	a4,0(s2)
    1404:	853e                	mv	a0,a5
    1406:	fef719e3          	bne	a4,a5,13f8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    140a:	8552                	mv	a0,s4
    140c:	00000097          	auipc	ra,0x0
    1410:	b5e080e7          	jalr	-1186(ra) # f6a <sbrk>
  if(p == (char*)-1)
    1414:	fd5518e3          	bne	a0,s5,13e4 <malloc+0xac>
        return 0;
    1418:	4501                	li	a0,0
    141a:	bf45                	j	13ca <malloc+0x92>
