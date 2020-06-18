
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	711d                	addi	sp,sp,-96
 11c:	ec86                	sd	ra,88(sp)
 11e:	e8a2                	sd	s0,80(sp)
 120:	e4a6                	sd	s1,72(sp)
 122:	e0ca                	sd	s2,64(sp)
 124:	fc4e                	sd	s3,56(sp)
 126:	f852                	sd	s4,48(sp)
 128:	f456                	sd	s5,40(sp)
 12a:	f05a                	sd	s6,32(sp)
 12c:	ec5e                	sd	s7,24(sp)
 12e:	e862                	sd	s8,16(sp)
 130:	e466                	sd	s9,8(sp)
 132:	1080                	addi	s0,sp,96
 134:	89aa                	mv	s3,a0
 136:	8b2e                	mv	s6,a1
  m = 0;
 138:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 13a:	3ff00b93          	li	s7,1023
 13e:	00001a97          	auipc	s5,0x1
 142:	a22a8a93          	addi	s5,s5,-1502 # b60 <buf>
    p = buf;
 146:	8cd6                	mv	s9,s5
 148:	8c56                	mv	s8,s5
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 14a:	a0a1                	j	192 <grep+0x78>
        *q = '\n';
 14c:	47a9                	li	a5,10
 14e:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 152:	00148613          	addi	a2,s1,1
 156:	4126063b          	subw	a2,a2,s2
 15a:	85ca                	mv	a1,s2
 15c:	4505                	li	a0,1
 15e:	00000097          	auipc	ra,0x0
 162:	432080e7          	jalr	1074(ra) # 590 <write>
      p = q+1;
 166:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 16a:	45a9                	li	a1,10
 16c:	854a                	mv	a0,s2
 16e:	00000097          	auipc	ra,0x0
 172:	1d4080e7          	jalr	468(ra) # 342 <strchr>
 176:	84aa                	mv	s1,a0
 178:	c919                	beqz	a0,18e <grep+0x74>
      *q = 0;
 17a:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 17e:	85ca                	mv	a1,s2
 180:	854e                	mv	a0,s3
 182:	00000097          	auipc	ra,0x0
 186:	f4a080e7          	jalr	-182(ra) # cc <match>
 18a:	dd71                	beqz	a0,166 <grep+0x4c>
 18c:	b7c1                	j	14c <grep+0x32>
    if(m > 0){
 18e:	03404563          	bgtz	s4,1b8 <grep+0x9e>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 192:	414b863b          	subw	a2,s7,s4
 196:	014a85b3          	add	a1,s5,s4
 19a:	855a                	mv	a0,s6
 19c:	00000097          	auipc	ra,0x0
 1a0:	3ec080e7          	jalr	1004(ra) # 588 <read>
 1a4:	02a05663          	blez	a0,1d0 <grep+0xb6>
    m += n;
 1a8:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
 1ac:	014a87b3          	add	a5,s5,s4
 1b0:	00078023          	sb	zero,0(a5)
    p = buf;
 1b4:	8962                	mv	s2,s8
    while((q = strchr(p, '\n')) != 0){
 1b6:	bf55                	j	16a <grep+0x50>
      m -= p - buf;
 1b8:	415907b3          	sub	a5,s2,s5
 1bc:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
 1c0:	8652                	mv	a2,s4
 1c2:	85ca                	mv	a1,s2
 1c4:	8566                	mv	a0,s9
 1c6:	00000097          	auipc	ra,0x0
 1ca:	2a4080e7          	jalr	676(ra) # 46a <memmove>
 1ce:	b7d1                	j	192 <grep+0x78>
}
 1d0:	60e6                	ld	ra,88(sp)
 1d2:	6446                	ld	s0,80(sp)
 1d4:	64a6                	ld	s1,72(sp)
 1d6:	6906                	ld	s2,64(sp)
 1d8:	79e2                	ld	s3,56(sp)
 1da:	7a42                	ld	s4,48(sp)
 1dc:	7aa2                	ld	s5,40(sp)
 1de:	7b02                	ld	s6,32(sp)
 1e0:	6be2                	ld	s7,24(sp)
 1e2:	6c42                	ld	s8,16(sp)
 1e4:	6ca2                	ld	s9,8(sp)
 1e6:	6125                	addi	sp,sp,96
 1e8:	8082                	ret

00000000000001ea <main>:
{
 1ea:	7139                	addi	sp,sp,-64
 1ec:	fc06                	sd	ra,56(sp)
 1ee:	f822                	sd	s0,48(sp)
 1f0:	f426                	sd	s1,40(sp)
 1f2:	f04a                	sd	s2,32(sp)
 1f4:	ec4e                	sd	s3,24(sp)
 1f6:	e852                	sd	s4,16(sp)
 1f8:	e456                	sd	s5,8(sp)
 1fa:	0080                	addi	s0,sp,64
  if(argc <= 1){
 1fc:	4785                	li	a5,1
 1fe:	04a7de63          	bge	a5,a0,25a <main+0x70>
  pattern = argv[1];
 202:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 206:	4789                	li	a5,2
 208:	06a7d763          	bge	a5,a0,276 <main+0x8c>
 20c:	01058913          	addi	s2,a1,16
 210:	ffd5099b          	addiw	s3,a0,-3
 214:	1982                	slli	s3,s3,0x20
 216:	0209d993          	srli	s3,s3,0x20
 21a:	098e                	slli	s3,s3,0x3
 21c:	05e1                	addi	a1,a1,24
 21e:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 220:	4581                	li	a1,0
 222:	00093503          	ld	a0,0(s2)
 226:	00000097          	auipc	ra,0x0
 22a:	38a080e7          	jalr	906(ra) # 5b0 <open>
 22e:	84aa                	mv	s1,a0
 230:	04054e63          	bltz	a0,28c <main+0xa2>
    grep(pattern, fd);
 234:	85aa                	mv	a1,a0
 236:	8552                	mv	a0,s4
 238:	00000097          	auipc	ra,0x0
 23c:	ee2080e7          	jalr	-286(ra) # 11a <grep>
    close(fd);
 240:	8526                	mv	a0,s1
 242:	00000097          	auipc	ra,0x0
 246:	356080e7          	jalr	854(ra) # 598 <close>
  for(i = 2; i < argc; i++){
 24a:	0921                	addi	s2,s2,8
 24c:	fd391ae3          	bne	s2,s3,220 <main+0x36>
  exit(0);
 250:	4501                	li	a0,0
 252:	00000097          	auipc	ra,0x0
 256:	31e080e7          	jalr	798(ra) # 570 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 25a:	00001597          	auipc	a1,0x1
 25e:	89e58593          	addi	a1,a1,-1890 # af8 <malloc+0xea>
 262:	4509                	li	a0,2
 264:	00000097          	auipc	ra,0x0
 268:	666080e7          	jalr	1638(ra) # 8ca <fprintf>
    exit(1);
 26c:	4505                	li	a0,1
 26e:	00000097          	auipc	ra,0x0
 272:	302080e7          	jalr	770(ra) # 570 <exit>
    grep(pattern, 0);
 276:	4581                	li	a1,0
 278:	8552                	mv	a0,s4
 27a:	00000097          	auipc	ra,0x0
 27e:	ea0080e7          	jalr	-352(ra) # 11a <grep>
    exit(0);
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	2ec080e7          	jalr	748(ra) # 570 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 28c:	00093583          	ld	a1,0(s2)
 290:	00001517          	auipc	a0,0x1
 294:	88850513          	addi	a0,a0,-1912 # b18 <malloc+0x10a>
 298:	00000097          	auipc	ra,0x0
 29c:	660080e7          	jalr	1632(ra) # 8f8 <printf>
      exit(1);
 2a0:	4505                	li	a0,1
 2a2:	00000097          	auipc	ra,0x0
 2a6:	2ce080e7          	jalr	718(ra) # 570 <exit>

00000000000002aa <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2b0:	87aa                	mv	a5,a0
 2b2:	0585                	addi	a1,a1,1
 2b4:	0785                	addi	a5,a5,1
 2b6:	fff5c703          	lbu	a4,-1(a1)
 2ba:	fee78fa3          	sb	a4,-1(a5)
 2be:	fb75                	bnez	a4,2b2 <strcpy+0x8>
    ;
  return os;
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret

00000000000002c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e422                	sd	s0,8(sp)
 2ca:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2cc:	00054783          	lbu	a5,0(a0)
 2d0:	cb91                	beqz	a5,2e4 <strcmp+0x1e>
 2d2:	0005c703          	lbu	a4,0(a1)
 2d6:	00f71763          	bne	a4,a5,2e4 <strcmp+0x1e>
    p++, q++;
 2da:	0505                	addi	a0,a0,1
 2dc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2de:	00054783          	lbu	a5,0(a0)
 2e2:	fbe5                	bnez	a5,2d2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2e4:	0005c503          	lbu	a0,0(a1)
}
 2e8:	40a7853b          	subw	a0,a5,a0
 2ec:	6422                	ld	s0,8(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret

00000000000002f2 <strlen>:

uint
strlen(const char *s)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e422                	sd	s0,8(sp)
 2f6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f8:	00054783          	lbu	a5,0(a0)
 2fc:	cf91                	beqz	a5,318 <strlen+0x26>
 2fe:	0505                	addi	a0,a0,1
 300:	87aa                	mv	a5,a0
 302:	4685                	li	a3,1
 304:	9e89                	subw	a3,a3,a0
 306:	00f6853b          	addw	a0,a3,a5
 30a:	0785                	addi	a5,a5,1
 30c:	fff7c703          	lbu	a4,-1(a5)
 310:	fb7d                	bnez	a4,306 <strlen+0x14>
    ;
  return n;
}
 312:	6422                	ld	s0,8(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret
  for(n = 0; s[n]; n++)
 318:	4501                	li	a0,0
 31a:	bfe5                	j	312 <strlen+0x20>

000000000000031c <memset>:

void*
memset(void *dst, int c, uint n)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 322:	ce09                	beqz	a2,33c <memset+0x20>
 324:	87aa                	mv	a5,a0
 326:	fff6071b          	addiw	a4,a2,-1
 32a:	1702                	slli	a4,a4,0x20
 32c:	9301                	srli	a4,a4,0x20
 32e:	0705                	addi	a4,a4,1
 330:	972a                	add	a4,a4,a0
    cdst[i] = c;
 332:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 336:	0785                	addi	a5,a5,1
 338:	fee79de3          	bne	a5,a4,332 <memset+0x16>
  }
  return dst;
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret

0000000000000342 <strchr>:

char*
strchr(const char *s, char c)
{
 342:	1141                	addi	sp,sp,-16
 344:	e422                	sd	s0,8(sp)
 346:	0800                	addi	s0,sp,16
  for(; *s; s++)
 348:	00054783          	lbu	a5,0(a0)
 34c:	cb99                	beqz	a5,362 <strchr+0x20>
    if(*s == c)
 34e:	00f58763          	beq	a1,a5,35c <strchr+0x1a>
  for(; *s; s++)
 352:	0505                	addi	a0,a0,1
 354:	00054783          	lbu	a5,0(a0)
 358:	fbfd                	bnez	a5,34e <strchr+0xc>
      return (char*)s;
  return 0;
 35a:	4501                	li	a0,0
}
 35c:	6422                	ld	s0,8(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret
  return 0;
 362:	4501                	li	a0,0
 364:	bfe5                	j	35c <strchr+0x1a>

0000000000000366 <gets>:

char*
gets(char *buf, int max)
{
 366:	711d                	addi	sp,sp,-96
 368:	ec86                	sd	ra,88(sp)
 36a:	e8a2                	sd	s0,80(sp)
 36c:	e4a6                	sd	s1,72(sp)
 36e:	e0ca                	sd	s2,64(sp)
 370:	fc4e                	sd	s3,56(sp)
 372:	f852                	sd	s4,48(sp)
 374:	f456                	sd	s5,40(sp)
 376:	f05a                	sd	s6,32(sp)
 378:	ec5e                	sd	s7,24(sp)
 37a:	1080                	addi	s0,sp,96
 37c:	8baa                	mv	s7,a0
 37e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 380:	892a                	mv	s2,a0
 382:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 384:	4aa9                	li	s5,10
 386:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 388:	89a6                	mv	s3,s1
 38a:	2485                	addiw	s1,s1,1
 38c:	0344d863          	bge	s1,s4,3bc <gets+0x56>
    cc = read(0, &c, 1);
 390:	4605                	li	a2,1
 392:	faf40593          	addi	a1,s0,-81
 396:	4501                	li	a0,0
 398:	00000097          	auipc	ra,0x0
 39c:	1f0080e7          	jalr	496(ra) # 588 <read>
    if(cc < 1)
 3a0:	00a05e63          	blez	a0,3bc <gets+0x56>
    buf[i++] = c;
 3a4:	faf44783          	lbu	a5,-81(s0)
 3a8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3ac:	01578763          	beq	a5,s5,3ba <gets+0x54>
 3b0:	0905                	addi	s2,s2,1
 3b2:	fd679be3          	bne	a5,s6,388 <gets+0x22>
  for(i=0; i+1 < max; ){
 3b6:	89a6                	mv	s3,s1
 3b8:	a011                	j	3bc <gets+0x56>
 3ba:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3bc:	99de                	add	s3,s3,s7
 3be:	00098023          	sb	zero,0(s3)
  return buf;
}
 3c2:	855e                	mv	a0,s7
 3c4:	60e6                	ld	ra,88(sp)
 3c6:	6446                	ld	s0,80(sp)
 3c8:	64a6                	ld	s1,72(sp)
 3ca:	6906                	ld	s2,64(sp)
 3cc:	79e2                	ld	s3,56(sp)
 3ce:	7a42                	ld	s4,48(sp)
 3d0:	7aa2                	ld	s5,40(sp)
 3d2:	7b02                	ld	s6,32(sp)
 3d4:	6be2                	ld	s7,24(sp)
 3d6:	6125                	addi	sp,sp,96
 3d8:	8082                	ret

00000000000003da <stat>:

int
stat(const char *n, struct stat *st)
{
 3da:	1101                	addi	sp,sp,-32
 3dc:	ec06                	sd	ra,24(sp)
 3de:	e822                	sd	s0,16(sp)
 3e0:	e426                	sd	s1,8(sp)
 3e2:	e04a                	sd	s2,0(sp)
 3e4:	1000                	addi	s0,sp,32
 3e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e8:	4581                	li	a1,0
 3ea:	00000097          	auipc	ra,0x0
 3ee:	1c6080e7          	jalr	454(ra) # 5b0 <open>
  if(fd < 0)
 3f2:	02054563          	bltz	a0,41c <stat+0x42>
 3f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3f8:	85ca                	mv	a1,s2
 3fa:	00000097          	auipc	ra,0x0
 3fe:	1ce080e7          	jalr	462(ra) # 5c8 <fstat>
 402:	892a                	mv	s2,a0
  close(fd);
 404:	8526                	mv	a0,s1
 406:	00000097          	auipc	ra,0x0
 40a:	192080e7          	jalr	402(ra) # 598 <close>
  return r;
}
 40e:	854a                	mv	a0,s2
 410:	60e2                	ld	ra,24(sp)
 412:	6442                	ld	s0,16(sp)
 414:	64a2                	ld	s1,8(sp)
 416:	6902                	ld	s2,0(sp)
 418:	6105                	addi	sp,sp,32
 41a:	8082                	ret
    return -1;
 41c:	597d                	li	s2,-1
 41e:	bfc5                	j	40e <stat+0x34>

0000000000000420 <atoi>:

int
atoi(const char *s)
{
 420:	1141                	addi	sp,sp,-16
 422:	e422                	sd	s0,8(sp)
 424:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 426:	00054603          	lbu	a2,0(a0)
 42a:	fd06079b          	addiw	a5,a2,-48
 42e:	0ff7f793          	andi	a5,a5,255
 432:	4725                	li	a4,9
 434:	02f76963          	bltu	a4,a5,466 <atoi+0x46>
 438:	86aa                	mv	a3,a0
  n = 0;
 43a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 43c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 43e:	0685                	addi	a3,a3,1
 440:	0025179b          	slliw	a5,a0,0x2
 444:	9fa9                	addw	a5,a5,a0
 446:	0017979b          	slliw	a5,a5,0x1
 44a:	9fb1                	addw	a5,a5,a2
 44c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 450:	0006c603          	lbu	a2,0(a3)
 454:	fd06071b          	addiw	a4,a2,-48
 458:	0ff77713          	andi	a4,a4,255
 45c:	fee5f1e3          	bgeu	a1,a4,43e <atoi+0x1e>
  return n;
}
 460:	6422                	ld	s0,8(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret
  n = 0;
 466:	4501                	li	a0,0
 468:	bfe5                	j	460 <atoi+0x40>

000000000000046a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 46a:	1141                	addi	sp,sp,-16
 46c:	e422                	sd	s0,8(sp)
 46e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 470:	02c05163          	blez	a2,492 <memmove+0x28>
 474:	fff6071b          	addiw	a4,a2,-1
 478:	1702                	slli	a4,a4,0x20
 47a:	9301                	srli	a4,a4,0x20
 47c:	0705                	addi	a4,a4,1
 47e:	972a                	add	a4,a4,a0
  dst = vdst;
 480:	87aa                	mv	a5,a0
    *dst++ = *src++;
 482:	0585                	addi	a1,a1,1
 484:	0785                	addi	a5,a5,1
 486:	fff5c683          	lbu	a3,-1(a1)
 48a:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 48e:	fee79ae3          	bne	a5,a4,482 <memmove+0x18>
  return vdst;
}
 492:	6422                	ld	s0,8(sp)
 494:	0141                	addi	sp,sp,16
 496:	8082                	ret

0000000000000498 <lock_init>:

void lock_init(lock_t *l, char *name) {
 498:	1141                	addi	sp,sp,-16
 49a:	e422                	sd	s0,8(sp)
 49c:	0800                	addi	s0,sp,16
 l->name = name;
 49e:	e10c                	sd	a1,0(a0)
 l->locked = 0;
 4a0:	00052423          	sw	zero,8(a0)
 //l->guard = 0;
}
 4a4:	6422                	ld	s0,8(sp)
 4a6:	0141                	addi	sp,sp,16
 4a8:	8082                	ret

00000000000004aa <lock_acquire>:

void lock_acquire(lock_t *l) {
 4aa:	1141                	addi	sp,sp,-16
 4ac:	e422                	sd	s0,8(sp)
 4ae:	0800                	addi	s0,sp,16
  while(__sync_lock_test_and_set(&l->locked, 1) != 0)
 4b0:	4705                	li	a4,1
 4b2:	87ba                	mv	a5,a4
 4b4:	00850693          	addi	a3,a0,8
 4b8:	0cf6a7af          	amoswap.w.aq	a5,a5,(a3)
 4bc:	2781                	sext.w	a5,a5
 4be:	fbf5                	bnez	a5,4b2 <lock_acquire+0x8>
    ;
  __sync_synchronize();
 4c0:	0ff0000f          	fence
}
 4c4:	6422                	ld	s0,8(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret

00000000000004ca <lock_release>:

void lock_release(lock_t *l) {
 4ca:	1141                	addi	sp,sp,-16
 4cc:	e422                	sd	s0,8(sp)
 4ce:	0800                	addi	s0,sp,16
  __sync_synchronize();
 4d0:	0ff0000f          	fence
  __sync_lock_release(&l->locked);
 4d4:	00850793          	addi	a5,a0,8
 4d8:	0f50000f          	fence	iorw,ow
 4dc:	0807a02f          	amoswap.w	zero,zero,(a5)
//  l->locked = 0;
}
 4e0:	6422                	ld	s0,8(sp)
 4e2:	0141                	addi	sp,sp,16
 4e4:	8082                	ret

00000000000004e6 <thread_create>:
//    condwakeup(cond->curr);
//  }
//}
int
thread_create(void (*start_routine)(void*, void*), void *arg1, void *arg2)
{
 4e6:	7179                	addi	sp,sp,-48
 4e8:	f406                	sd	ra,40(sp)
 4ea:	f022                	sd	s0,32(sp)
 4ec:	ec26                	sd	s1,24(sp)
 4ee:	e84a                	sd	s2,16(sp)
 4f0:	e44e                	sd	s3,8(sp)
 4f2:	1800                	addi	s0,sp,48
 4f4:	84aa                	mv	s1,a0
 4f6:	892e                	mv	s2,a1
 4f8:	89b2                	mv	s3,a2
  void *stack = malloc(PGSIZE*2); //allocate space on the heap, should be 1 page in size and pagesize aligned
 4fa:	6509                	lui	a0,0x2
 4fc:	00000097          	auipc	ra,0x0
 500:	512080e7          	jalr	1298(ra) # a0e <malloc>
 504:	86aa                	mv	a3,a0
  if((uint64)stack % PGSIZE) { //not aligned
 506:	03451793          	slli	a5,a0,0x34
 50a:	c799                	beqz	a5,518 <thread_create+0x32>
 50c:	0347d713          	srli	a4,a5,0x34
    stack = stack + (PGSIZE - (uint64)stack % PGSIZE); //make is pagesize aligned
 510:	6785                	lui	a5,0x1
 512:	8f99                	sub	a5,a5,a4
 514:	00f506b3          	add	a3,a0,a5
  }
  int pid = clone(start_routine, arg1, arg2, stack);
 518:	864e                	mv	a2,s3
 51a:	85ca                	mv	a1,s2
 51c:	8526                	mv	a0,s1
 51e:	00000097          	auipc	ra,0x0
 522:	0f2080e7          	jalr	242(ra) # 610 <clone>
  return pid;
}
 526:	70a2                	ld	ra,40(sp)
 528:	7402                	ld	s0,32(sp)
 52a:	64e2                	ld	s1,24(sp)
 52c:	6942                	ld	s2,16(sp)
 52e:	69a2                	ld	s3,8(sp)
 530:	6145                	addi	sp,sp,48
 532:	8082                	ret

0000000000000534 <thread_join>:

int thread_join() {
 534:	7179                	addi	sp,sp,-48
 536:	f406                	sd	ra,40(sp)
 538:	f022                	sd	s0,32(sp)
 53a:	ec26                	sd	s1,24(sp)
 53c:	1800                	addi	s0,sp,48
  void *ustack = 0;
 53e:	fc043c23          	sd	zero,-40(s0)
  int status = join(&ustack);
 542:	fd840513          	addi	a0,s0,-40
 546:	00000097          	auipc	ra,0x0
 54a:	0d2080e7          	jalr	210(ra) # 618 <join>
 54e:	84aa                	mv	s1,a0
  free(ustack);
 550:	fd843503          	ld	a0,-40(s0)
 554:	00000097          	auipc	ra,0x0
 558:	432080e7          	jalr	1074(ra) # 986 <free>
  return status;
}
 55c:	8526                	mv	a0,s1
 55e:	70a2                	ld	ra,40(sp)
 560:	7402                	ld	s0,32(sp)
 562:	64e2                	ld	s1,24(sp)
 564:	6145                	addi	sp,sp,48
 566:	8082                	ret

0000000000000568 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 568:	4885                	li	a7,1
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <exit>:
.global exit
exit:
 li a7, SYS_exit
 570:	4889                	li	a7,2
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <wait>:
.global wait
wait:
 li a7, SYS_wait
 578:	488d                	li	a7,3
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 580:	4891                	li	a7,4
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <read>:
.global read
read:
 li a7, SYS_read
 588:	4895                	li	a7,5
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <write>:
.global write
write:
 li a7, SYS_write
 590:	48c1                	li	a7,16
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <close>:
.global close
close:
 li a7, SYS_close
 598:	48d5                	li	a7,21
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5a0:	4899                	li	a7,6
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5a8:	489d                	li	a7,7
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <open>:
.global open
open:
 li a7, SYS_open
 5b0:	48bd                	li	a7,15
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5b8:	48c5                	li	a7,17
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5c0:	48c9                	li	a7,18
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5c8:	48a1                	li	a7,8
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <link>:
.global link
link:
 li a7, SYS_link
 5d0:	48cd                	li	a7,19
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5d8:	48d1                	li	a7,20
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5e0:	48a5                	li	a7,9
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5e8:	48a9                	li	a7,10
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5f0:	48ad                	li	a7,11
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5f8:	48b1                	li	a7,12
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 600:	48b5                	li	a7,13
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 608:	48b9                	li	a7,14
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <clone>:
.global clone
clone:
 li a7, SYS_clone
 610:	48d9                	li	a7,22
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <join>:
.global join
join:
 li a7, SYS_join
 618:	48dd                	li	a7,23
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <putc>:
  int type;
};

static void
putc(int fd, char c)
{
 620:	1101                	addi	sp,sp,-32
 622:	ec06                	sd	ra,24(sp)
 624:	e822                	sd	s0,16(sp)
 626:	1000                	addi	s0,sp,32
 628:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 62c:	4605                	li	a2,1
 62e:	fef40593          	addi	a1,s0,-17
 632:	00000097          	auipc	ra,0x0
 636:	f5e080e7          	jalr	-162(ra) # 590 <write>
}
 63a:	60e2                	ld	ra,24(sp)
 63c:	6442                	ld	s0,16(sp)
 63e:	6105                	addi	sp,sp,32
 640:	8082                	ret

0000000000000642 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 642:	7139                	addi	sp,sp,-64
 644:	fc06                	sd	ra,56(sp)
 646:	f822                	sd	s0,48(sp)
 648:	f426                	sd	s1,40(sp)
 64a:	f04a                	sd	s2,32(sp)
 64c:	ec4e                	sd	s3,24(sp)
 64e:	0080                	addi	s0,sp,64
 650:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 652:	c299                	beqz	a3,658 <printint+0x16>
 654:	0805c863          	bltz	a1,6e4 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 658:	2581                	sext.w	a1,a1
  neg = 0;
 65a:	4881                	li	a7,0
 65c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 660:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 662:	2601                	sext.w	a2,a2
 664:	00000517          	auipc	a0,0x0
 668:	4dc50513          	addi	a0,a0,1244 # b40 <digits>
 66c:	883a                	mv	a6,a4
 66e:	2705                	addiw	a4,a4,1
 670:	02c5f7bb          	remuw	a5,a1,a2
 674:	1782                	slli	a5,a5,0x20
 676:	9381                	srli	a5,a5,0x20
 678:	97aa                	add	a5,a5,a0
 67a:	0007c783          	lbu	a5,0(a5) # 1000 <__BSS_END__+0x78>
 67e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 682:	0005879b          	sext.w	a5,a1
 686:	02c5d5bb          	divuw	a1,a1,a2
 68a:	0685                	addi	a3,a3,1
 68c:	fec7f0e3          	bgeu	a5,a2,66c <printint+0x2a>
  if(neg)
 690:	00088b63          	beqz	a7,6a6 <printint+0x64>
    buf[i++] = '-';
 694:	fd040793          	addi	a5,s0,-48
 698:	973e                	add	a4,a4,a5
 69a:	02d00793          	li	a5,45
 69e:	fef70823          	sb	a5,-16(a4)
 6a2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6a6:	02e05863          	blez	a4,6d6 <printint+0x94>
 6aa:	fc040793          	addi	a5,s0,-64
 6ae:	00e78933          	add	s2,a5,a4
 6b2:	fff78993          	addi	s3,a5,-1
 6b6:	99ba                	add	s3,s3,a4
 6b8:	377d                	addiw	a4,a4,-1
 6ba:	1702                	slli	a4,a4,0x20
 6bc:	9301                	srli	a4,a4,0x20
 6be:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6c2:	fff94583          	lbu	a1,-1(s2)
 6c6:	8526                	mv	a0,s1
 6c8:	00000097          	auipc	ra,0x0
 6cc:	f58080e7          	jalr	-168(ra) # 620 <putc>
  while(--i >= 0)
 6d0:	197d                	addi	s2,s2,-1
 6d2:	ff3918e3          	bne	s2,s3,6c2 <printint+0x80>
}
 6d6:	70e2                	ld	ra,56(sp)
 6d8:	7442                	ld	s0,48(sp)
 6da:	74a2                	ld	s1,40(sp)
 6dc:	7902                	ld	s2,32(sp)
 6de:	69e2                	ld	s3,24(sp)
 6e0:	6121                	addi	sp,sp,64
 6e2:	8082                	ret
    x = -xx;
 6e4:	40b005bb          	negw	a1,a1
    neg = 1;
 6e8:	4885                	li	a7,1
    x = -xx;
 6ea:	bf8d                	j	65c <printint+0x1a>

00000000000006ec <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6ec:	7119                	addi	sp,sp,-128
 6ee:	fc86                	sd	ra,120(sp)
 6f0:	f8a2                	sd	s0,112(sp)
 6f2:	f4a6                	sd	s1,104(sp)
 6f4:	f0ca                	sd	s2,96(sp)
 6f6:	ecce                	sd	s3,88(sp)
 6f8:	e8d2                	sd	s4,80(sp)
 6fa:	e4d6                	sd	s5,72(sp)
 6fc:	e0da                	sd	s6,64(sp)
 6fe:	fc5e                	sd	s7,56(sp)
 700:	f862                	sd	s8,48(sp)
 702:	f466                	sd	s9,40(sp)
 704:	f06a                	sd	s10,32(sp)
 706:	ec6e                	sd	s11,24(sp)
 708:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 70a:	0005c903          	lbu	s2,0(a1)
 70e:	18090f63          	beqz	s2,8ac <vprintf+0x1c0>
 712:	8aaa                	mv	s5,a0
 714:	8b32                	mv	s6,a2
 716:	00158493          	addi	s1,a1,1
  state = 0;
 71a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 71c:	02500a13          	li	s4,37
      if(c == 'd'){
 720:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 724:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 728:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 72c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 730:	00000b97          	auipc	s7,0x0
 734:	410b8b93          	addi	s7,s7,1040 # b40 <digits>
 738:	a839                	j	756 <vprintf+0x6a>
        putc(fd, c);
 73a:	85ca                	mv	a1,s2
 73c:	8556                	mv	a0,s5
 73e:	00000097          	auipc	ra,0x0
 742:	ee2080e7          	jalr	-286(ra) # 620 <putc>
 746:	a019                	j	74c <vprintf+0x60>
    } else if(state == '%'){
 748:	01498f63          	beq	s3,s4,766 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 74c:	0485                	addi	s1,s1,1
 74e:	fff4c903          	lbu	s2,-1(s1)
 752:	14090d63          	beqz	s2,8ac <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 756:	0009079b          	sext.w	a5,s2
    if(state == 0){
 75a:	fe0997e3          	bnez	s3,748 <vprintf+0x5c>
      if(c == '%'){
 75e:	fd479ee3          	bne	a5,s4,73a <vprintf+0x4e>
        state = '%';
 762:	89be                	mv	s3,a5
 764:	b7e5                	j	74c <vprintf+0x60>
      if(c == 'd'){
 766:	05878063          	beq	a5,s8,7a6 <vprintf+0xba>
      } else if(c == 'l') {
 76a:	05978c63          	beq	a5,s9,7c2 <vprintf+0xd6>
      } else if(c == 'x') {
 76e:	07a78863          	beq	a5,s10,7de <vprintf+0xf2>
      } else if(c == 'p') {
 772:	09b78463          	beq	a5,s11,7fa <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 776:	07300713          	li	a4,115
 77a:	0ce78663          	beq	a5,a4,846 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 77e:	06300713          	li	a4,99
 782:	0ee78e63          	beq	a5,a4,87e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 786:	11478863          	beq	a5,s4,896 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 78a:	85d2                	mv	a1,s4
 78c:	8556                	mv	a0,s5
 78e:	00000097          	auipc	ra,0x0
 792:	e92080e7          	jalr	-366(ra) # 620 <putc>
        putc(fd, c);
 796:	85ca                	mv	a1,s2
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	e86080e7          	jalr	-378(ra) # 620 <putc>
      }
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	b765                	j	74c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7a6:	008b0913          	addi	s2,s6,8
 7aa:	4685                	li	a3,1
 7ac:	4629                	li	a2,10
 7ae:	000b2583          	lw	a1,0(s6)
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	e8e080e7          	jalr	-370(ra) # 642 <printint>
 7bc:	8b4a                	mv	s6,s2
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	b771                	j	74c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c2:	008b0913          	addi	s2,s6,8
 7c6:	4681                	li	a3,0
 7c8:	4629                	li	a2,10
 7ca:	000b2583          	lw	a1,0(s6)
 7ce:	8556                	mv	a0,s5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	e72080e7          	jalr	-398(ra) # 642 <printint>
 7d8:	8b4a                	mv	s6,s2
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	bf85                	j	74c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7de:	008b0913          	addi	s2,s6,8
 7e2:	4681                	li	a3,0
 7e4:	4641                	li	a2,16
 7e6:	000b2583          	lw	a1,0(s6)
 7ea:	8556                	mv	a0,s5
 7ec:	00000097          	auipc	ra,0x0
 7f0:	e56080e7          	jalr	-426(ra) # 642 <printint>
 7f4:	8b4a                	mv	s6,s2
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	bf91                	j	74c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7fa:	008b0793          	addi	a5,s6,8
 7fe:	f8f43423          	sd	a5,-120(s0)
 802:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 806:	03000593          	li	a1,48
 80a:	8556                	mv	a0,s5
 80c:	00000097          	auipc	ra,0x0
 810:	e14080e7          	jalr	-492(ra) # 620 <putc>
  putc(fd, 'x');
 814:	85ea                	mv	a1,s10
 816:	8556                	mv	a0,s5
 818:	00000097          	auipc	ra,0x0
 81c:	e08080e7          	jalr	-504(ra) # 620 <putc>
 820:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 822:	03c9d793          	srli	a5,s3,0x3c
 826:	97de                	add	a5,a5,s7
 828:	0007c583          	lbu	a1,0(a5)
 82c:	8556                	mv	a0,s5
 82e:	00000097          	auipc	ra,0x0
 832:	df2080e7          	jalr	-526(ra) # 620 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 836:	0992                	slli	s3,s3,0x4
 838:	397d                	addiw	s2,s2,-1
 83a:	fe0914e3          	bnez	s2,822 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 83e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 842:	4981                	li	s3,0
 844:	b721                	j	74c <vprintf+0x60>
        s = va_arg(ap, char*);
 846:	008b0993          	addi	s3,s6,8
 84a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 84e:	02090163          	beqz	s2,870 <vprintf+0x184>
        while(*s != 0){
 852:	00094583          	lbu	a1,0(s2)
 856:	c9a1                	beqz	a1,8a6 <vprintf+0x1ba>
          putc(fd, *s);
 858:	8556                	mv	a0,s5
 85a:	00000097          	auipc	ra,0x0
 85e:	dc6080e7          	jalr	-570(ra) # 620 <putc>
          s++;
 862:	0905                	addi	s2,s2,1
        while(*s != 0){
 864:	00094583          	lbu	a1,0(s2)
 868:	f9e5                	bnez	a1,858 <vprintf+0x16c>
        s = va_arg(ap, char*);
 86a:	8b4e                	mv	s6,s3
      state = 0;
 86c:	4981                	li	s3,0
 86e:	bdf9                	j	74c <vprintf+0x60>
          s = "(null)";
 870:	00000917          	auipc	s2,0x0
 874:	2c090913          	addi	s2,s2,704 # b30 <malloc+0x122>
        while(*s != 0){
 878:	02800593          	li	a1,40
 87c:	bff1                	j	858 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 87e:	008b0913          	addi	s2,s6,8
 882:	000b4583          	lbu	a1,0(s6)
 886:	8556                	mv	a0,s5
 888:	00000097          	auipc	ra,0x0
 88c:	d98080e7          	jalr	-616(ra) # 620 <putc>
 890:	8b4a                	mv	s6,s2
      state = 0;
 892:	4981                	li	s3,0
 894:	bd65                	j	74c <vprintf+0x60>
        putc(fd, c);
 896:	85d2                	mv	a1,s4
 898:	8556                	mv	a0,s5
 89a:	00000097          	auipc	ra,0x0
 89e:	d86080e7          	jalr	-634(ra) # 620 <putc>
      state = 0;
 8a2:	4981                	li	s3,0
 8a4:	b565                	j	74c <vprintf+0x60>
        s = va_arg(ap, char*);
 8a6:	8b4e                	mv	s6,s3
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	b54d                	j	74c <vprintf+0x60>
    }
  }
}
 8ac:	70e6                	ld	ra,120(sp)
 8ae:	7446                	ld	s0,112(sp)
 8b0:	74a6                	ld	s1,104(sp)
 8b2:	7906                	ld	s2,96(sp)
 8b4:	69e6                	ld	s3,88(sp)
 8b6:	6a46                	ld	s4,80(sp)
 8b8:	6aa6                	ld	s5,72(sp)
 8ba:	6b06                	ld	s6,64(sp)
 8bc:	7be2                	ld	s7,56(sp)
 8be:	7c42                	ld	s8,48(sp)
 8c0:	7ca2                	ld	s9,40(sp)
 8c2:	7d02                	ld	s10,32(sp)
 8c4:	6de2                	ld	s11,24(sp)
 8c6:	6109                	addi	sp,sp,128
 8c8:	8082                	ret

00000000000008ca <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8ca:	715d                	addi	sp,sp,-80
 8cc:	ec06                	sd	ra,24(sp)
 8ce:	e822                	sd	s0,16(sp)
 8d0:	1000                	addi	s0,sp,32
 8d2:	e010                	sd	a2,0(s0)
 8d4:	e414                	sd	a3,8(s0)
 8d6:	e818                	sd	a4,16(s0)
 8d8:	ec1c                	sd	a5,24(s0)
 8da:	03043023          	sd	a6,32(s0)
 8de:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8e2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8e6:	8622                	mv	a2,s0
 8e8:	00000097          	auipc	ra,0x0
 8ec:	e04080e7          	jalr	-508(ra) # 6ec <vprintf>
}
 8f0:	60e2                	ld	ra,24(sp)
 8f2:	6442                	ld	s0,16(sp)
 8f4:	6161                	addi	sp,sp,80
 8f6:	8082                	ret

00000000000008f8 <printf>:

void
printf(const char *fmt, ...)
{
 8f8:	7159                	addi	sp,sp,-112
 8fa:	f406                	sd	ra,40(sp)
 8fc:	f022                	sd	s0,32(sp)
 8fe:	ec26                	sd	s1,24(sp)
 900:	e84a                	sd	s2,16(sp)
 902:	1800                	addi	s0,sp,48
 904:	84aa                	mv	s1,a0
 906:	e40c                	sd	a1,8(s0)
 908:	e810                	sd	a2,16(s0)
 90a:	ec14                	sd	a3,24(s0)
 90c:	f018                	sd	a4,32(s0)
 90e:	f41c                	sd	a5,40(s0)
 910:	03043823          	sd	a6,48(s0)
 914:	03143c23          	sd	a7,56(s0)
  va_list ap;
  lock_acquire(&pr.printf_lock);
 918:	00000917          	auipc	s2,0x0
 91c:	64890913          	addi	s2,s2,1608 # f60 <pr>
 920:	854a                	mv	a0,s2
 922:	00000097          	auipc	ra,0x0
 926:	b88080e7          	jalr	-1144(ra) # 4aa <lock_acquire>

  va_start(ap, fmt);
 92a:	00840613          	addi	a2,s0,8
 92e:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 932:	85a6                	mv	a1,s1
 934:	4505                	li	a0,1
 936:	00000097          	auipc	ra,0x0
 93a:	db6080e7          	jalr	-586(ra) # 6ec <vprintf>
  
  lock_release(&pr.printf_lock);
 93e:	854a                	mv	a0,s2
 940:	00000097          	auipc	ra,0x0
 944:	b8a080e7          	jalr	-1142(ra) # 4ca <lock_release>

}
 948:	70a2                	ld	ra,40(sp)
 94a:	7402                	ld	s0,32(sp)
 94c:	64e2                	ld	s1,24(sp)
 94e:	6942                	ld	s2,16(sp)
 950:	6165                	addi	sp,sp,112
 952:	8082                	ret

0000000000000954 <printfinit>:

void
printfinit(void)
{
 954:	1101                	addi	sp,sp,-32
 956:	ec06                	sd	ra,24(sp)
 958:	e822                	sd	s0,16(sp)
 95a:	e426                	sd	s1,8(sp)
 95c:	1000                	addi	s0,sp,32
  lock_init(&pr.printf_lock, "pr");
 95e:	00000497          	auipc	s1,0x0
 962:	60248493          	addi	s1,s1,1538 # f60 <pr>
 966:	00000597          	auipc	a1,0x0
 96a:	1d258593          	addi	a1,a1,466 # b38 <malloc+0x12a>
 96e:	8526                	mv	a0,s1
 970:	00000097          	auipc	ra,0x0
 974:	b28080e7          	jalr	-1240(ra) # 498 <lock_init>
  pr.locking = 1;
 978:	4785                	li	a5,1
 97a:	c89c                	sw	a5,16(s1)
}
 97c:	60e2                	ld	ra,24(sp)
 97e:	6442                	ld	s0,16(sp)
 980:	64a2                	ld	s1,8(sp)
 982:	6105                	addi	sp,sp,32
 984:	8082                	ret

0000000000000986 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 986:	1141                	addi	sp,sp,-16
 988:	e422                	sd	s0,8(sp)
 98a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 98c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 990:	00000797          	auipc	a5,0x0
 994:	1c87b783          	ld	a5,456(a5) # b58 <freep>
 998:	a805                	j	9c8 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 99a:	4618                	lw	a4,8(a2)
 99c:	9db9                	addw	a1,a1,a4
 99e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9a2:	6398                	ld	a4,0(a5)
 9a4:	6318                	ld	a4,0(a4)
 9a6:	fee53823          	sd	a4,-16(a0)
 9aa:	a091                	j	9ee <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9ac:	ff852703          	lw	a4,-8(a0)
 9b0:	9e39                	addw	a2,a2,a4
 9b2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 9b4:	ff053703          	ld	a4,-16(a0)
 9b8:	e398                	sd	a4,0(a5)
 9ba:	a099                	j	a00 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9bc:	6398                	ld	a4,0(a5)
 9be:	00e7e463          	bltu	a5,a4,9c6 <free+0x40>
 9c2:	00e6ea63          	bltu	a3,a4,9d6 <free+0x50>
{
 9c6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9c8:	fed7fae3          	bgeu	a5,a3,9bc <free+0x36>
 9cc:	6398                	ld	a4,0(a5)
 9ce:	00e6e463          	bltu	a3,a4,9d6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9d2:	fee7eae3          	bltu	a5,a4,9c6 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 9d6:	ff852583          	lw	a1,-8(a0)
 9da:	6390                	ld	a2,0(a5)
 9dc:	02059713          	slli	a4,a1,0x20
 9e0:	9301                	srli	a4,a4,0x20
 9e2:	0712                	slli	a4,a4,0x4
 9e4:	9736                	add	a4,a4,a3
 9e6:	fae60ae3          	beq	a2,a4,99a <free+0x14>
    bp->s.ptr = p->s.ptr;
 9ea:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ee:	4790                	lw	a2,8(a5)
 9f0:	02061713          	slli	a4,a2,0x20
 9f4:	9301                	srli	a4,a4,0x20
 9f6:	0712                	slli	a4,a4,0x4
 9f8:	973e                	add	a4,a4,a5
 9fa:	fae689e3          	beq	a3,a4,9ac <free+0x26>
  } else
    p->s.ptr = bp;
 9fe:	e394                	sd	a3,0(a5)
  freep = p;
 a00:	00000717          	auipc	a4,0x0
 a04:	14f73c23          	sd	a5,344(a4) # b58 <freep>
}
 a08:	6422                	ld	s0,8(sp)
 a0a:	0141                	addi	sp,sp,16
 a0c:	8082                	ret

0000000000000a0e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a0e:	7139                	addi	sp,sp,-64
 a10:	fc06                	sd	ra,56(sp)
 a12:	f822                	sd	s0,48(sp)
 a14:	f426                	sd	s1,40(sp)
 a16:	f04a                	sd	s2,32(sp)
 a18:	ec4e                	sd	s3,24(sp)
 a1a:	e852                	sd	s4,16(sp)
 a1c:	e456                	sd	s5,8(sp)
 a1e:	e05a                	sd	s6,0(sp)
 a20:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a22:	02051493          	slli	s1,a0,0x20
 a26:	9081                	srli	s1,s1,0x20
 a28:	04bd                	addi	s1,s1,15
 a2a:	8091                	srli	s1,s1,0x4
 a2c:	0014899b          	addiw	s3,s1,1
 a30:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a32:	00000517          	auipc	a0,0x0
 a36:	12653503          	ld	a0,294(a0) # b58 <freep>
 a3a:	c515                	beqz	a0,a66 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a3c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a3e:	4798                	lw	a4,8(a5)
 a40:	02977f63          	bgeu	a4,s1,a7e <malloc+0x70>
 a44:	8a4e                	mv	s4,s3
 a46:	0009871b          	sext.w	a4,s3
 a4a:	6685                	lui	a3,0x1
 a4c:	00d77363          	bgeu	a4,a3,a52 <malloc+0x44>
 a50:	6a05                	lui	s4,0x1
 a52:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a56:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a5a:	00000917          	auipc	s2,0x0
 a5e:	0fe90913          	addi	s2,s2,254 # b58 <freep>
  if(p == (char*)-1)
 a62:	5afd                	li	s5,-1
 a64:	a88d                	j	ad6 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a66:	00000797          	auipc	a5,0x0
 a6a:	51278793          	addi	a5,a5,1298 # f78 <base>
 a6e:	00000717          	auipc	a4,0x0
 a72:	0ef73523          	sd	a5,234(a4) # b58 <freep>
 a76:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a78:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a7c:	b7e1                	j	a44 <malloc+0x36>
      if(p->s.size == nunits)
 a7e:	02e48b63          	beq	s1,a4,ab4 <malloc+0xa6>
        p->s.size -= nunits;
 a82:	4137073b          	subw	a4,a4,s3
 a86:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a88:	1702                	slli	a4,a4,0x20
 a8a:	9301                	srli	a4,a4,0x20
 a8c:	0712                	slli	a4,a4,0x4
 a8e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a90:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a94:	00000717          	auipc	a4,0x0
 a98:	0ca73223          	sd	a0,196(a4) # b58 <freep>
      return (void*)(p + 1);
 a9c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 aa0:	70e2                	ld	ra,56(sp)
 aa2:	7442                	ld	s0,48(sp)
 aa4:	74a2                	ld	s1,40(sp)
 aa6:	7902                	ld	s2,32(sp)
 aa8:	69e2                	ld	s3,24(sp)
 aaa:	6a42                	ld	s4,16(sp)
 aac:	6aa2                	ld	s5,8(sp)
 aae:	6b02                	ld	s6,0(sp)
 ab0:	6121                	addi	sp,sp,64
 ab2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 ab4:	6398                	ld	a4,0(a5)
 ab6:	e118                	sd	a4,0(a0)
 ab8:	bff1                	j	a94 <malloc+0x86>
  hp->s.size = nu;
 aba:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 abe:	0541                	addi	a0,a0,16
 ac0:	00000097          	auipc	ra,0x0
 ac4:	ec6080e7          	jalr	-314(ra) # 986 <free>
  return freep;
 ac8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 acc:	d971                	beqz	a0,aa0 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ace:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ad0:	4798                	lw	a4,8(a5)
 ad2:	fa9776e3          	bgeu	a4,s1,a7e <malloc+0x70>
    if(p == freep)
 ad6:	00093703          	ld	a4,0(s2)
 ada:	853e                	mv	a0,a5
 adc:	fef719e3          	bne	a4,a5,ace <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 ae0:	8552                	mv	a0,s4
 ae2:	00000097          	auipc	ra,0x0
 ae6:	b16080e7          	jalr	-1258(ra) # 5f8 <sbrk>
  if(p == (char*)-1)
 aea:	fd5518e3          	bne	a0,s5,aba <malloc+0xac>
        return 0;
 aee:	4501                	li	a0,0
 af0:	bf45                	j	aa0 <malloc+0x92>
