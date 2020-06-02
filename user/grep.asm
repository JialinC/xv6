
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
 142:	8faa8a93          	addi	s5,s5,-1798 # a38 <buf>
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
 162:	362080e7          	jalr	866(ra) # 4c0 <write>
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
 1a0:	31c080e7          	jalr	796(ra) # 4b8 <read>
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
 22a:	2ba080e7          	jalr	698(ra) # 4e0 <open>
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
 246:	286080e7          	jalr	646(ra) # 4c8 <close>
  for(i = 2; i < argc; i++){
 24a:	0921                	addi	s2,s2,8
 24c:	fd391ae3          	bne	s2,s3,220 <main+0x36>
  exit(0);
 250:	4501                	li	a0,0
 252:	00000097          	auipc	ra,0x0
 256:	24e080e7          	jalr	590(ra) # 4a0 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 25a:	00000597          	auipc	a1,0x0
 25e:	77e58593          	addi	a1,a1,1918 # 9d8 <malloc+0xea>
 262:	4509                	li	a0,2
 264:	00000097          	auipc	ra,0x0
 268:	59e080e7          	jalr	1438(ra) # 802 <fprintf>
    exit(1);
 26c:	4505                	li	a0,1
 26e:	00000097          	auipc	ra,0x0
 272:	232080e7          	jalr	562(ra) # 4a0 <exit>
    grep(pattern, 0);
 276:	4581                	li	a1,0
 278:	8552                	mv	a0,s4
 27a:	00000097          	auipc	ra,0x0
 27e:	ea0080e7          	jalr	-352(ra) # 11a <grep>
    exit(0);
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	21c080e7          	jalr	540(ra) # 4a0 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 28c:	00093583          	ld	a1,0(s2)
 290:	00000517          	auipc	a0,0x0
 294:	76850513          	addi	a0,a0,1896 # 9f8 <malloc+0x10a>
 298:	00000097          	auipc	ra,0x0
 29c:	598080e7          	jalr	1432(ra) # 830 <printf>
      exit(1);
 2a0:	4505                	li	a0,1
 2a2:	00000097          	auipc	ra,0x0
 2a6:	1fe080e7          	jalr	510(ra) # 4a0 <exit>

00000000000002aa <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

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
 39c:	120080e7          	jalr	288(ra) # 4b8 <read>
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
 3ee:	0f6080e7          	jalr	246(ra) # 4e0 <open>
  if(fd < 0)
 3f2:	02054563          	bltz	a0,41c <stat+0x42>
 3f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3f8:	85ca                	mv	a1,s2
 3fa:	00000097          	auipc	ra,0x0
 3fe:	0fe080e7          	jalr	254(ra) # 4f8 <fstat>
 402:	892a                	mv	s2,a0
  close(fd);
 404:	8526                	mv	a0,s1
 406:	00000097          	auipc	ra,0x0
 40a:	0c2080e7          	jalr	194(ra) # 4c8 <close>
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

0000000000000498 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 498:	4885                	li	a7,1
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4a0:	4889                	li	a7,2
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4a8:	488d                	li	a7,3
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4b0:	4891                	li	a7,4
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <read>:
.global read
read:
 li a7, SYS_read
 4b8:	4895                	li	a7,5
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <write>:
.global write
write:
 li a7, SYS_write
 4c0:	48c1                	li	a7,16
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <close>:
.global close
close:
 li a7, SYS_close
 4c8:	48d5                	li	a7,21
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4d0:	4899                	li	a7,6
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4d8:	489d                	li	a7,7
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <open>:
.global open
open:
 li a7, SYS_open
 4e0:	48bd                	li	a7,15
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4e8:	48c5                	li	a7,17
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4f0:	48c9                	li	a7,18
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4f8:	48a1                	li	a7,8
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <link>:
.global link
link:
 li a7, SYS_link
 500:	48cd                	li	a7,19
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 508:	48d1                	li	a7,20
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 510:	48a5                	li	a7,9
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <dup>:
.global dup
dup:
 li a7, SYS_dup
 518:	48a9                	li	a7,10
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 520:	48ad                	li	a7,11
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 528:	48b1                	li	a7,12
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 530:	48b5                	li	a7,13
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 538:	48b9                	li	a7,14
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
 540:	48d9                	li	a7,22
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 548:	48dd                	li	a7,23
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 550:	48e1                	li	a7,24
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 558:	1101                	addi	sp,sp,-32
 55a:	ec06                	sd	ra,24(sp)
 55c:	e822                	sd	s0,16(sp)
 55e:	1000                	addi	s0,sp,32
 560:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 564:	4605                	li	a2,1
 566:	fef40593          	addi	a1,s0,-17
 56a:	00000097          	auipc	ra,0x0
 56e:	f56080e7          	jalr	-170(ra) # 4c0 <write>
}
 572:	60e2                	ld	ra,24(sp)
 574:	6442                	ld	s0,16(sp)
 576:	6105                	addi	sp,sp,32
 578:	8082                	ret

000000000000057a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 57a:	7139                	addi	sp,sp,-64
 57c:	fc06                	sd	ra,56(sp)
 57e:	f822                	sd	s0,48(sp)
 580:	f426                	sd	s1,40(sp)
 582:	f04a                	sd	s2,32(sp)
 584:	ec4e                	sd	s3,24(sp)
 586:	0080                	addi	s0,sp,64
 588:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 58a:	c299                	beqz	a3,590 <printint+0x16>
 58c:	0805c863          	bltz	a1,61c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 590:	2581                	sext.w	a1,a1
  neg = 0;
 592:	4881                	li	a7,0
 594:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 598:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 59a:	2601                	sext.w	a2,a2
 59c:	00000517          	auipc	a0,0x0
 5a0:	47c50513          	addi	a0,a0,1148 # a18 <digits>
 5a4:	883a                	mv	a6,a4
 5a6:	2705                	addiw	a4,a4,1
 5a8:	02c5f7bb          	remuw	a5,a1,a2
 5ac:	1782                	slli	a5,a5,0x20
 5ae:	9381                	srli	a5,a5,0x20
 5b0:	97aa                	add	a5,a5,a0
 5b2:	0007c783          	lbu	a5,0(a5)
 5b6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5ba:	0005879b          	sext.w	a5,a1
 5be:	02c5d5bb          	divuw	a1,a1,a2
 5c2:	0685                	addi	a3,a3,1
 5c4:	fec7f0e3          	bgeu	a5,a2,5a4 <printint+0x2a>
  if(neg)
 5c8:	00088b63          	beqz	a7,5de <printint+0x64>
    buf[i++] = '-';
 5cc:	fd040793          	addi	a5,s0,-48
 5d0:	973e                	add	a4,a4,a5
 5d2:	02d00793          	li	a5,45
 5d6:	fef70823          	sb	a5,-16(a4)
 5da:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5de:	02e05863          	blez	a4,60e <printint+0x94>
 5e2:	fc040793          	addi	a5,s0,-64
 5e6:	00e78933          	add	s2,a5,a4
 5ea:	fff78993          	addi	s3,a5,-1
 5ee:	99ba                	add	s3,s3,a4
 5f0:	377d                	addiw	a4,a4,-1
 5f2:	1702                	slli	a4,a4,0x20
 5f4:	9301                	srli	a4,a4,0x20
 5f6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5fa:	fff94583          	lbu	a1,-1(s2)
 5fe:	8526                	mv	a0,s1
 600:	00000097          	auipc	ra,0x0
 604:	f58080e7          	jalr	-168(ra) # 558 <putc>
  while(--i >= 0)
 608:	197d                	addi	s2,s2,-1
 60a:	ff3918e3          	bne	s2,s3,5fa <printint+0x80>
}
 60e:	70e2                	ld	ra,56(sp)
 610:	7442                	ld	s0,48(sp)
 612:	74a2                	ld	s1,40(sp)
 614:	7902                	ld	s2,32(sp)
 616:	69e2                	ld	s3,24(sp)
 618:	6121                	addi	sp,sp,64
 61a:	8082                	ret
    x = -xx;
 61c:	40b005bb          	negw	a1,a1
    neg = 1;
 620:	4885                	li	a7,1
    x = -xx;
 622:	bf8d                	j	594 <printint+0x1a>

0000000000000624 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 624:	7119                	addi	sp,sp,-128
 626:	fc86                	sd	ra,120(sp)
 628:	f8a2                	sd	s0,112(sp)
 62a:	f4a6                	sd	s1,104(sp)
 62c:	f0ca                	sd	s2,96(sp)
 62e:	ecce                	sd	s3,88(sp)
 630:	e8d2                	sd	s4,80(sp)
 632:	e4d6                	sd	s5,72(sp)
 634:	e0da                	sd	s6,64(sp)
 636:	fc5e                	sd	s7,56(sp)
 638:	f862                	sd	s8,48(sp)
 63a:	f466                	sd	s9,40(sp)
 63c:	f06a                	sd	s10,32(sp)
 63e:	ec6e                	sd	s11,24(sp)
 640:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 642:	0005c903          	lbu	s2,0(a1)
 646:	18090f63          	beqz	s2,7e4 <vprintf+0x1c0>
 64a:	8aaa                	mv	s5,a0
 64c:	8b32                	mv	s6,a2
 64e:	00158493          	addi	s1,a1,1
  state = 0;
 652:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 654:	02500a13          	li	s4,37
      if(c == 'd'){
 658:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 65c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 660:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 664:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 668:	00000b97          	auipc	s7,0x0
 66c:	3b0b8b93          	addi	s7,s7,944 # a18 <digits>
 670:	a839                	j	68e <vprintf+0x6a>
        putc(fd, c);
 672:	85ca                	mv	a1,s2
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	ee2080e7          	jalr	-286(ra) # 558 <putc>
 67e:	a019                	j	684 <vprintf+0x60>
    } else if(state == '%'){
 680:	01498f63          	beq	s3,s4,69e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 684:	0485                	addi	s1,s1,1
 686:	fff4c903          	lbu	s2,-1(s1)
 68a:	14090d63          	beqz	s2,7e4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 68e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 692:	fe0997e3          	bnez	s3,680 <vprintf+0x5c>
      if(c == '%'){
 696:	fd479ee3          	bne	a5,s4,672 <vprintf+0x4e>
        state = '%';
 69a:	89be                	mv	s3,a5
 69c:	b7e5                	j	684 <vprintf+0x60>
      if(c == 'd'){
 69e:	05878063          	beq	a5,s8,6de <vprintf+0xba>
      } else if(c == 'l') {
 6a2:	05978c63          	beq	a5,s9,6fa <vprintf+0xd6>
      } else if(c == 'x') {
 6a6:	07a78863          	beq	a5,s10,716 <vprintf+0xf2>
      } else if(c == 'p') {
 6aa:	09b78463          	beq	a5,s11,732 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6ae:	07300713          	li	a4,115
 6b2:	0ce78663          	beq	a5,a4,77e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6b6:	06300713          	li	a4,99
 6ba:	0ee78e63          	beq	a5,a4,7b6 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6be:	11478863          	beq	a5,s4,7ce <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c2:	85d2                	mv	a1,s4
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	e92080e7          	jalr	-366(ra) # 558 <putc>
        putc(fd, c);
 6ce:	85ca                	mv	a1,s2
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	e86080e7          	jalr	-378(ra) # 558 <putc>
      }
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	b765                	j	684 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6de:	008b0913          	addi	s2,s6,8
 6e2:	4685                	li	a3,1
 6e4:	4629                	li	a2,10
 6e6:	000b2583          	lw	a1,0(s6)
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	e8e080e7          	jalr	-370(ra) # 57a <printint>
 6f4:	8b4a                	mv	s6,s2
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	b771                	j	684 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fa:	008b0913          	addi	s2,s6,8
 6fe:	4681                	li	a3,0
 700:	4629                	li	a2,10
 702:	000b2583          	lw	a1,0(s6)
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	e72080e7          	jalr	-398(ra) # 57a <printint>
 710:	8b4a                	mv	s6,s2
      state = 0;
 712:	4981                	li	s3,0
 714:	bf85                	j	684 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 716:	008b0913          	addi	s2,s6,8
 71a:	4681                	li	a3,0
 71c:	4641                	li	a2,16
 71e:	000b2583          	lw	a1,0(s6)
 722:	8556                	mv	a0,s5
 724:	00000097          	auipc	ra,0x0
 728:	e56080e7          	jalr	-426(ra) # 57a <printint>
 72c:	8b4a                	mv	s6,s2
      state = 0;
 72e:	4981                	li	s3,0
 730:	bf91                	j	684 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 732:	008b0793          	addi	a5,s6,8
 736:	f8f43423          	sd	a5,-120(s0)
 73a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 73e:	03000593          	li	a1,48
 742:	8556                	mv	a0,s5
 744:	00000097          	auipc	ra,0x0
 748:	e14080e7          	jalr	-492(ra) # 558 <putc>
  putc(fd, 'x');
 74c:	85ea                	mv	a1,s10
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	e08080e7          	jalr	-504(ra) # 558 <putc>
 758:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 75a:	03c9d793          	srli	a5,s3,0x3c
 75e:	97de                	add	a5,a5,s7
 760:	0007c583          	lbu	a1,0(a5)
 764:	8556                	mv	a0,s5
 766:	00000097          	auipc	ra,0x0
 76a:	df2080e7          	jalr	-526(ra) # 558 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 76e:	0992                	slli	s3,s3,0x4
 770:	397d                	addiw	s2,s2,-1
 772:	fe0914e3          	bnez	s2,75a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 776:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 77a:	4981                	li	s3,0
 77c:	b721                	j	684 <vprintf+0x60>
        s = va_arg(ap, char*);
 77e:	008b0993          	addi	s3,s6,8
 782:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 786:	02090163          	beqz	s2,7a8 <vprintf+0x184>
        while(*s != 0){
 78a:	00094583          	lbu	a1,0(s2)
 78e:	c9a1                	beqz	a1,7de <vprintf+0x1ba>
          putc(fd, *s);
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	dc6080e7          	jalr	-570(ra) # 558 <putc>
          s++;
 79a:	0905                	addi	s2,s2,1
        while(*s != 0){
 79c:	00094583          	lbu	a1,0(s2)
 7a0:	f9e5                	bnez	a1,790 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7a2:	8b4e                	mv	s6,s3
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	bdf9                	j	684 <vprintf+0x60>
          s = "(null)";
 7a8:	00000917          	auipc	s2,0x0
 7ac:	26890913          	addi	s2,s2,616 # a10 <malloc+0x122>
        while(*s != 0){
 7b0:	02800593          	li	a1,40
 7b4:	bff1                	j	790 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7b6:	008b0913          	addi	s2,s6,8
 7ba:	000b4583          	lbu	a1,0(s6)
 7be:	8556                	mv	a0,s5
 7c0:	00000097          	auipc	ra,0x0
 7c4:	d98080e7          	jalr	-616(ra) # 558 <putc>
 7c8:	8b4a                	mv	s6,s2
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	bd65                	j	684 <vprintf+0x60>
        putc(fd, c);
 7ce:	85d2                	mv	a1,s4
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	d86080e7          	jalr	-634(ra) # 558 <putc>
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	b565                	j	684 <vprintf+0x60>
        s = va_arg(ap, char*);
 7de:	8b4e                	mv	s6,s3
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	b54d                	j	684 <vprintf+0x60>
    }
  }
}
 7e4:	70e6                	ld	ra,120(sp)
 7e6:	7446                	ld	s0,112(sp)
 7e8:	74a6                	ld	s1,104(sp)
 7ea:	7906                	ld	s2,96(sp)
 7ec:	69e6                	ld	s3,88(sp)
 7ee:	6a46                	ld	s4,80(sp)
 7f0:	6aa6                	ld	s5,72(sp)
 7f2:	6b06                	ld	s6,64(sp)
 7f4:	7be2                	ld	s7,56(sp)
 7f6:	7c42                	ld	s8,48(sp)
 7f8:	7ca2                	ld	s9,40(sp)
 7fa:	7d02                	ld	s10,32(sp)
 7fc:	6de2                	ld	s11,24(sp)
 7fe:	6109                	addi	sp,sp,128
 800:	8082                	ret

0000000000000802 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 802:	715d                	addi	sp,sp,-80
 804:	ec06                	sd	ra,24(sp)
 806:	e822                	sd	s0,16(sp)
 808:	1000                	addi	s0,sp,32
 80a:	e010                	sd	a2,0(s0)
 80c:	e414                	sd	a3,8(s0)
 80e:	e818                	sd	a4,16(s0)
 810:	ec1c                	sd	a5,24(s0)
 812:	03043023          	sd	a6,32(s0)
 816:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 81e:	8622                	mv	a2,s0
 820:	00000097          	auipc	ra,0x0
 824:	e04080e7          	jalr	-508(ra) # 624 <vprintf>
}
 828:	60e2                	ld	ra,24(sp)
 82a:	6442                	ld	s0,16(sp)
 82c:	6161                	addi	sp,sp,80
 82e:	8082                	ret

0000000000000830 <printf>:

void
printf(const char *fmt, ...)
{
 830:	711d                	addi	sp,sp,-96
 832:	ec06                	sd	ra,24(sp)
 834:	e822                	sd	s0,16(sp)
 836:	1000                	addi	s0,sp,32
 838:	e40c                	sd	a1,8(s0)
 83a:	e810                	sd	a2,16(s0)
 83c:	ec14                	sd	a3,24(s0)
 83e:	f018                	sd	a4,32(s0)
 840:	f41c                	sd	a5,40(s0)
 842:	03043823          	sd	a6,48(s0)
 846:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 84a:	00840613          	addi	a2,s0,8
 84e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 852:	85aa                	mv	a1,a0
 854:	4505                	li	a0,1
 856:	00000097          	auipc	ra,0x0
 85a:	dce080e7          	jalr	-562(ra) # 624 <vprintf>
}
 85e:	60e2                	ld	ra,24(sp)
 860:	6442                	ld	s0,16(sp)
 862:	6125                	addi	sp,sp,96
 864:	8082                	ret

0000000000000866 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 866:	1141                	addi	sp,sp,-16
 868:	e422                	sd	s0,8(sp)
 86a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 86c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 870:	00000797          	auipc	a5,0x0
 874:	1c07b783          	ld	a5,448(a5) # a30 <freep>
 878:	a805                	j	8a8 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 87a:	4618                	lw	a4,8(a2)
 87c:	9db9                	addw	a1,a1,a4
 87e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 882:	6398                	ld	a4,0(a5)
 884:	6318                	ld	a4,0(a4)
 886:	fee53823          	sd	a4,-16(a0)
 88a:	a091                	j	8ce <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 88c:	ff852703          	lw	a4,-8(a0)
 890:	9e39                	addw	a2,a2,a4
 892:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 894:	ff053703          	ld	a4,-16(a0)
 898:	e398                	sd	a4,0(a5)
 89a:	a099                	j	8e0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89c:	6398                	ld	a4,0(a5)
 89e:	00e7e463          	bltu	a5,a4,8a6 <free+0x40>
 8a2:	00e6ea63          	bltu	a3,a4,8b6 <free+0x50>
{
 8a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a8:	fed7fae3          	bgeu	a5,a3,89c <free+0x36>
 8ac:	6398                	ld	a4,0(a5)
 8ae:	00e6e463          	bltu	a3,a4,8b6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b2:	fee7eae3          	bltu	a5,a4,8a6 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8b6:	ff852583          	lw	a1,-8(a0)
 8ba:	6390                	ld	a2,0(a5)
 8bc:	02059713          	slli	a4,a1,0x20
 8c0:	9301                	srli	a4,a4,0x20
 8c2:	0712                	slli	a4,a4,0x4
 8c4:	9736                	add	a4,a4,a3
 8c6:	fae60ae3          	beq	a2,a4,87a <free+0x14>
    bp->s.ptr = p->s.ptr;
 8ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ce:	4790                	lw	a2,8(a5)
 8d0:	02061713          	slli	a4,a2,0x20
 8d4:	9301                	srli	a4,a4,0x20
 8d6:	0712                	slli	a4,a4,0x4
 8d8:	973e                	add	a4,a4,a5
 8da:	fae689e3          	beq	a3,a4,88c <free+0x26>
  } else
    p->s.ptr = bp;
 8de:	e394                	sd	a3,0(a5)
  freep = p;
 8e0:	00000717          	auipc	a4,0x0
 8e4:	14f73823          	sd	a5,336(a4) # a30 <freep>
}
 8e8:	6422                	ld	s0,8(sp)
 8ea:	0141                	addi	sp,sp,16
 8ec:	8082                	ret

00000000000008ee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ee:	7139                	addi	sp,sp,-64
 8f0:	fc06                	sd	ra,56(sp)
 8f2:	f822                	sd	s0,48(sp)
 8f4:	f426                	sd	s1,40(sp)
 8f6:	f04a                	sd	s2,32(sp)
 8f8:	ec4e                	sd	s3,24(sp)
 8fa:	e852                	sd	s4,16(sp)
 8fc:	e456                	sd	s5,8(sp)
 8fe:	e05a                	sd	s6,0(sp)
 900:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 902:	02051493          	slli	s1,a0,0x20
 906:	9081                	srli	s1,s1,0x20
 908:	04bd                	addi	s1,s1,15
 90a:	8091                	srli	s1,s1,0x4
 90c:	0014899b          	addiw	s3,s1,1
 910:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 912:	00000517          	auipc	a0,0x0
 916:	11e53503          	ld	a0,286(a0) # a30 <freep>
 91a:	c515                	beqz	a0,946 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91e:	4798                	lw	a4,8(a5)
 920:	02977f63          	bgeu	a4,s1,95e <malloc+0x70>
 924:	8a4e                	mv	s4,s3
 926:	0009871b          	sext.w	a4,s3
 92a:	6685                	lui	a3,0x1
 92c:	00d77363          	bgeu	a4,a3,932 <malloc+0x44>
 930:	6a05                	lui	s4,0x1
 932:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 936:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 93a:	00000917          	auipc	s2,0x0
 93e:	0f690913          	addi	s2,s2,246 # a30 <freep>
  if(p == (char*)-1)
 942:	5afd                	li	s5,-1
 944:	a88d                	j	9b6 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 946:	00000797          	auipc	a5,0x0
 94a:	4f278793          	addi	a5,a5,1266 # e38 <base>
 94e:	00000717          	auipc	a4,0x0
 952:	0ef73123          	sd	a5,226(a4) # a30 <freep>
 956:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 958:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 95c:	b7e1                	j	924 <malloc+0x36>
      if(p->s.size == nunits)
 95e:	02e48b63          	beq	s1,a4,994 <malloc+0xa6>
        p->s.size -= nunits;
 962:	4137073b          	subw	a4,a4,s3
 966:	c798                	sw	a4,8(a5)
        p += p->s.size;
 968:	1702                	slli	a4,a4,0x20
 96a:	9301                	srli	a4,a4,0x20
 96c:	0712                	slli	a4,a4,0x4
 96e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 970:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 974:	00000717          	auipc	a4,0x0
 978:	0aa73e23          	sd	a0,188(a4) # a30 <freep>
      return (void*)(p + 1);
 97c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 980:	70e2                	ld	ra,56(sp)
 982:	7442                	ld	s0,48(sp)
 984:	74a2                	ld	s1,40(sp)
 986:	7902                	ld	s2,32(sp)
 988:	69e2                	ld	s3,24(sp)
 98a:	6a42                	ld	s4,16(sp)
 98c:	6aa2                	ld	s5,8(sp)
 98e:	6b02                	ld	s6,0(sp)
 990:	6121                	addi	sp,sp,64
 992:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 994:	6398                	ld	a4,0(a5)
 996:	e118                	sd	a4,0(a0)
 998:	bff1                	j	974 <malloc+0x86>
  hp->s.size = nu;
 99a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 99e:	0541                	addi	a0,a0,16
 9a0:	00000097          	auipc	ra,0x0
 9a4:	ec6080e7          	jalr	-314(ra) # 866 <free>
  return freep;
 9a8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9ac:	d971                	beqz	a0,980 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b0:	4798                	lw	a4,8(a5)
 9b2:	fa9776e3          	bgeu	a4,s1,95e <malloc+0x70>
    if(p == freep)
 9b6:	00093703          	ld	a4,0(s2)
 9ba:	853e                	mv	a0,a5
 9bc:	fef719e3          	bne	a4,a5,9ae <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9c0:	8552                	mv	a0,s4
 9c2:	00000097          	auipc	ra,0x0
 9c6:	b66080e7          	jalr	-1178(ra) # 528 <sbrk>
  if(p == (char*)-1)
 9ca:	fd5518e3          	bne	a0,s5,99a <malloc+0xac>
        return 0;
 9ce:	4501                	li	a0,0
 9d0:	bf45                	j	980 <malloc+0x92>
