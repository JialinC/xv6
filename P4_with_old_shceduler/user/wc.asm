
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	a2bd8d93          	addi	s11,s11,-1493 # a59 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	9a8a0a13          	addi	s4,s4,-1624 # 9e0 <malloc+0xe6>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1e8080e7          	jalr	488(ra) # 22e <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01248d63          	beq	s1,s2,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2b85                	addiw	s7,s7,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0997e3          	bnez	s3,52 <wc+0x52>
        w++;
  68:	2c05                	addiw	s8,s8,1
        inword = 1;
  6a:	4985                	li	s3,1
  6c:	b7dd                	j	52 <wc+0x52>
  6e:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	00001597          	auipc	a1,0x1
  7a:	9e258593          	addi	a1,a1,-1566 # a58 <buf>
  7e:	f8843503          	ld	a0,-120(s0)
  82:	00000097          	auipc	ra,0x0
  86:	3f2080e7          	jalr	1010(ra) # 474 <read>
  8a:	00a05f63          	blez	a0,a8 <wc+0xa8>
    for(i=0; i<n; i++){
  8e:	00001497          	auipc	s1,0x1
  92:	9ca48493          	addi	s1,s1,-1590 # a58 <buf>
  96:	00050d1b          	sext.w	s10,a0
  9a:	fff5091b          	addiw	s2,a0,-1
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	996e                	add	s2,s2,s11
  a6:	bf4d                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  a8:	02054e63          	bltz	a0,e4 <wc+0xe4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  ac:	f8043703          	ld	a4,-128(s0)
  b0:	86e6                	mv	a3,s9
  b2:	8662                	mv	a2,s8
  b4:	85de                	mv	a1,s7
  b6:	00001517          	auipc	a0,0x1
  ba:	94250513          	addi	a0,a0,-1726 # 9f8 <malloc+0xfe>
  be:	00000097          	auipc	ra,0x0
  c2:	726080e7          	jalr	1830(ra) # 7e4 <printf>
}
  c6:	70e6                	ld	ra,120(sp)
  c8:	7446                	ld	s0,112(sp)
  ca:	74a6                	ld	s1,104(sp)
  cc:	7906                	ld	s2,96(sp)
  ce:	69e6                	ld	s3,88(sp)
  d0:	6a46                	ld	s4,80(sp)
  d2:	6aa6                	ld	s5,72(sp)
  d4:	6b06                	ld	s6,64(sp)
  d6:	7be2                	ld	s7,56(sp)
  d8:	7c42                	ld	s8,48(sp)
  da:	7ca2                	ld	s9,40(sp)
  dc:	7d02                	ld	s10,32(sp)
  de:	6de2                	ld	s11,24(sp)
  e0:	6109                	addi	sp,sp,128
  e2:	8082                	ret
    printf("wc: read error\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	90450513          	addi	a0,a0,-1788 # 9e8 <malloc+0xee>
  ec:	00000097          	auipc	ra,0x0
  f0:	6f8080e7          	jalr	1784(ra) # 7e4 <printf>
    exit(1);
  f4:	4505                	li	a0,1
  f6:	00000097          	auipc	ra,0x0
  fa:	366080e7          	jalr	870(ra) # 45c <exit>

00000000000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	7179                	addi	sp,sp,-48
 100:	f406                	sd	ra,40(sp)
 102:	f022                	sd	s0,32(sp)
 104:	ec26                	sd	s1,24(sp)
 106:	e84a                	sd	s2,16(sp)
 108:	e44e                	sd	s3,8(sp)
 10a:	e052                	sd	s4,0(sp)
 10c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 10e:	4785                	li	a5,1
 110:	04a7d763          	bge	a5,a0,15e <main+0x60>
 114:	00858493          	addi	s1,a1,8
 118:	ffe5099b          	addiw	s3,a0,-2
 11c:	1982                	slli	s3,s3,0x20
 11e:	0209d993          	srli	s3,s3,0x20
 122:	098e                	slli	s3,s3,0x3
 124:	05c1                	addi	a1,a1,16
 126:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 128:	4581                	li	a1,0
 12a:	6088                	ld	a0,0(s1)
 12c:	00000097          	auipc	ra,0x0
 130:	370080e7          	jalr	880(ra) # 49c <open>
 134:	892a                	mv	s2,a0
 136:	04054263          	bltz	a0,17a <main+0x7c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 13a:	608c                	ld	a1,0(s1)
 13c:	00000097          	auipc	ra,0x0
 140:	ec4080e7          	jalr	-316(ra) # 0 <wc>
    close(fd);
 144:	854a                	mv	a0,s2
 146:	00000097          	auipc	ra,0x0
 14a:	33e080e7          	jalr	830(ra) # 484 <close>
  for(i = 1; i < argc; i++){
 14e:	04a1                	addi	s1,s1,8
 150:	fd349ce3          	bne	s1,s3,128 <main+0x2a>
  }
  exit(0);
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	306080e7          	jalr	774(ra) # 45c <exit>
    wc(0, "");
 15e:	00001597          	auipc	a1,0x1
 162:	8aa58593          	addi	a1,a1,-1878 # a08 <malloc+0x10e>
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	e98080e7          	jalr	-360(ra) # 0 <wc>
    exit(0);
 170:	4501                	li	a0,0
 172:	00000097          	auipc	ra,0x0
 176:	2ea080e7          	jalr	746(ra) # 45c <exit>
      printf("wc: cannot open %s\n", argv[i]);
 17a:	608c                	ld	a1,0(s1)
 17c:	00001517          	auipc	a0,0x1
 180:	89450513          	addi	a0,a0,-1900 # a10 <malloc+0x116>
 184:	00000097          	auipc	ra,0x0
 188:	660080e7          	jalr	1632(ra) # 7e4 <printf>
      exit(1);
 18c:	4505                	li	a0,1
 18e:	00000097          	auipc	ra,0x0
 192:	2ce080e7          	jalr	718(ra) # 45c <exit>

0000000000000196 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 19c:	87aa                	mv	a5,a0
 19e:	0585                	addi	a1,a1,1
 1a0:	0785                	addi	a5,a5,1
 1a2:	fff5c703          	lbu	a4,-1(a1)
 1a6:	fee78fa3          	sb	a4,-1(a5)
 1aa:	fb75                	bnez	a4,19e <strcpy+0x8>
    ;
  return os;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb91                	beqz	a5,1d0 <strcmp+0x1e>
 1be:	0005c703          	lbu	a4,0(a1)
 1c2:	00f71763          	bne	a4,a5,1d0 <strcmp+0x1e>
    p++, q++;
 1c6:	0505                	addi	a0,a0,1
 1c8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbe5                	bnez	a5,1be <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1d0:	0005c503          	lbu	a0,0(a1)
}
 1d4:	40a7853b          	subw	a0,a5,a0
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	addi	sp,sp,16
 1dc:	8082                	ret

00000000000001de <strlen>:

uint
strlen(const char *s)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e422                	sd	s0,8(sp)
 1e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	cf91                	beqz	a5,204 <strlen+0x26>
 1ea:	0505                	addi	a0,a0,1
 1ec:	87aa                	mv	a5,a0
 1ee:	4685                	li	a3,1
 1f0:	9e89                	subw	a3,a3,a0
 1f2:	00f6853b          	addw	a0,a3,a5
 1f6:	0785                	addi	a5,a5,1
 1f8:	fff7c703          	lbu	a4,-1(a5)
 1fc:	fb7d                	bnez	a4,1f2 <strlen+0x14>
    ;
  return n;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret
  for(n = 0; s[n]; n++)
 204:	4501                	li	a0,0
 206:	bfe5                	j	1fe <strlen+0x20>

0000000000000208 <memset>:

void*
memset(void *dst, int c, uint n)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 20e:	ce09                	beqz	a2,228 <memset+0x20>
 210:	87aa                	mv	a5,a0
 212:	fff6071b          	addiw	a4,a2,-1
 216:	1702                	slli	a4,a4,0x20
 218:	9301                	srli	a4,a4,0x20
 21a:	0705                	addi	a4,a4,1
 21c:	972a                	add	a4,a4,a0
    cdst[i] = c;
 21e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 222:	0785                	addi	a5,a5,1
 224:	fee79de3          	bne	a5,a4,21e <memset+0x16>
  }
  return dst;
}
 228:	6422                	ld	s0,8(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret

000000000000022e <strchr>:

char*
strchr(const char *s, char c)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  for(; *s; s++)
 234:	00054783          	lbu	a5,0(a0)
 238:	cb99                	beqz	a5,24e <strchr+0x20>
    if(*s == c)
 23a:	00f58763          	beq	a1,a5,248 <strchr+0x1a>
  for(; *s; s++)
 23e:	0505                	addi	a0,a0,1
 240:	00054783          	lbu	a5,0(a0)
 244:	fbfd                	bnez	a5,23a <strchr+0xc>
      return (char*)s;
  return 0;
 246:	4501                	li	a0,0
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
  return 0;
 24e:	4501                	li	a0,0
 250:	bfe5                	j	248 <strchr+0x1a>

0000000000000252 <gets>:

char*
gets(char *buf, int max)
{
 252:	711d                	addi	sp,sp,-96
 254:	ec86                	sd	ra,88(sp)
 256:	e8a2                	sd	s0,80(sp)
 258:	e4a6                	sd	s1,72(sp)
 25a:	e0ca                	sd	s2,64(sp)
 25c:	fc4e                	sd	s3,56(sp)
 25e:	f852                	sd	s4,48(sp)
 260:	f456                	sd	s5,40(sp)
 262:	f05a                	sd	s6,32(sp)
 264:	ec5e                	sd	s7,24(sp)
 266:	1080                	addi	s0,sp,96
 268:	8baa                	mv	s7,a0
 26a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26c:	892a                	mv	s2,a0
 26e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 270:	4aa9                	li	s5,10
 272:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 274:	89a6                	mv	s3,s1
 276:	2485                	addiw	s1,s1,1
 278:	0344d863          	bge	s1,s4,2a8 <gets+0x56>
    cc = read(0, &c, 1);
 27c:	4605                	li	a2,1
 27e:	faf40593          	addi	a1,s0,-81
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	1f0080e7          	jalr	496(ra) # 474 <read>
    if(cc < 1)
 28c:	00a05e63          	blez	a0,2a8 <gets+0x56>
    buf[i++] = c;
 290:	faf44783          	lbu	a5,-81(s0)
 294:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 298:	01578763          	beq	a5,s5,2a6 <gets+0x54>
 29c:	0905                	addi	s2,s2,1
 29e:	fd679be3          	bne	a5,s6,274 <gets+0x22>
  for(i=0; i+1 < max; ){
 2a2:	89a6                	mv	s3,s1
 2a4:	a011                	j	2a8 <gets+0x56>
 2a6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2a8:	99de                	add	s3,s3,s7
 2aa:	00098023          	sb	zero,0(s3)
  return buf;
}
 2ae:	855e                	mv	a0,s7
 2b0:	60e6                	ld	ra,88(sp)
 2b2:	6446                	ld	s0,80(sp)
 2b4:	64a6                	ld	s1,72(sp)
 2b6:	6906                	ld	s2,64(sp)
 2b8:	79e2                	ld	s3,56(sp)
 2ba:	7a42                	ld	s4,48(sp)
 2bc:	7aa2                	ld	s5,40(sp)
 2be:	7b02                	ld	s6,32(sp)
 2c0:	6be2                	ld	s7,24(sp)
 2c2:	6125                	addi	sp,sp,96
 2c4:	8082                	ret

00000000000002c6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c6:	1101                	addi	sp,sp,-32
 2c8:	ec06                	sd	ra,24(sp)
 2ca:	e822                	sd	s0,16(sp)
 2cc:	e426                	sd	s1,8(sp)
 2ce:	e04a                	sd	s2,0(sp)
 2d0:	1000                	addi	s0,sp,32
 2d2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d4:	4581                	li	a1,0
 2d6:	00000097          	auipc	ra,0x0
 2da:	1c6080e7          	jalr	454(ra) # 49c <open>
  if(fd < 0)
 2de:	02054563          	bltz	a0,308 <stat+0x42>
 2e2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2e4:	85ca                	mv	a1,s2
 2e6:	00000097          	auipc	ra,0x0
 2ea:	1ce080e7          	jalr	462(ra) # 4b4 <fstat>
 2ee:	892a                	mv	s2,a0
  close(fd);
 2f0:	8526                	mv	a0,s1
 2f2:	00000097          	auipc	ra,0x0
 2f6:	192080e7          	jalr	402(ra) # 484 <close>
  return r;
}
 2fa:	854a                	mv	a0,s2
 2fc:	60e2                	ld	ra,24(sp)
 2fe:	6442                	ld	s0,16(sp)
 300:	64a2                	ld	s1,8(sp)
 302:	6902                	ld	s2,0(sp)
 304:	6105                	addi	sp,sp,32
 306:	8082                	ret
    return -1;
 308:	597d                	li	s2,-1
 30a:	bfc5                	j	2fa <stat+0x34>

000000000000030c <atoi>:

int
atoi(const char *s)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 312:	00054603          	lbu	a2,0(a0)
 316:	fd06079b          	addiw	a5,a2,-48
 31a:	0ff7f793          	andi	a5,a5,255
 31e:	4725                	li	a4,9
 320:	02f76963          	bltu	a4,a5,352 <atoi+0x46>
 324:	86aa                	mv	a3,a0
  n = 0;
 326:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 328:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 32a:	0685                	addi	a3,a3,1
 32c:	0025179b          	slliw	a5,a0,0x2
 330:	9fa9                	addw	a5,a5,a0
 332:	0017979b          	slliw	a5,a5,0x1
 336:	9fb1                	addw	a5,a5,a2
 338:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 33c:	0006c603          	lbu	a2,0(a3)
 340:	fd06071b          	addiw	a4,a2,-48
 344:	0ff77713          	andi	a4,a4,255
 348:	fee5f1e3          	bgeu	a1,a4,32a <atoi+0x1e>
  return n;
}
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
  n = 0;
 352:	4501                	li	a0,0
 354:	bfe5                	j	34c <atoi+0x40>

0000000000000356 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e422                	sd	s0,8(sp)
 35a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35c:	02c05163          	blez	a2,37e <memmove+0x28>
 360:	fff6071b          	addiw	a4,a2,-1
 364:	1702                	slli	a4,a4,0x20
 366:	9301                	srli	a4,a4,0x20
 368:	0705                	addi	a4,a4,1
 36a:	972a                	add	a4,a4,a0
  dst = vdst;
 36c:	87aa                	mv	a5,a0
    *dst++ = *src++;
 36e:	0585                	addi	a1,a1,1
 370:	0785                	addi	a5,a5,1
 372:	fff5c683          	lbu	a3,-1(a1)
 376:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 37a:	fee79ae3          	bne	a5,a4,36e <memmove+0x18>
  return vdst;
}
 37e:	6422                	ld	s0,8(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <lock_init>:

void lock_init(lock_t *l, char *name) {
 384:	1141                	addi	sp,sp,-16
 386:	e422                	sd	s0,8(sp)
 388:	0800                	addi	s0,sp,16
 l->name = name;
 38a:	e10c                	sd	a1,0(a0)
 l->locked = 0;
 38c:	00052423          	sw	zero,8(a0)
 //l->guard = 0;
}
 390:	6422                	ld	s0,8(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret

0000000000000396 <lock_acquire>:

void lock_acquire(lock_t *l) {
 396:	1141                	addi	sp,sp,-16
 398:	e422                	sd	s0,8(sp)
 39a:	0800                	addi	s0,sp,16
  while(__sync_lock_test_and_set(&l->locked, 1) != 0)
 39c:	4705                	li	a4,1
 39e:	87ba                	mv	a5,a4
 3a0:	00850693          	addi	a3,a0,8
 3a4:	0cf6a7af          	amoswap.w.aq	a5,a5,(a3)
 3a8:	2781                	sext.w	a5,a5
 3aa:	fbf5                	bnez	a5,39e <lock_acquire+0x8>
    ;
  __sync_synchronize();
 3ac:	0ff0000f          	fence
}
 3b0:	6422                	ld	s0,8(sp)
 3b2:	0141                	addi	sp,sp,16
 3b4:	8082                	ret

00000000000003b6 <lock_release>:

void lock_release(lock_t *l) {
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e422                	sd	s0,8(sp)
 3ba:	0800                	addi	s0,sp,16
  __sync_synchronize();
 3bc:	0ff0000f          	fence
  __sync_lock_release(&l->locked);
 3c0:	00850793          	addi	a5,a0,8
 3c4:	0f50000f          	fence	iorw,ow
 3c8:	0807a02f          	amoswap.w	zero,zero,(a5)
//  l->locked = 0;
}
 3cc:	6422                	ld	s0,8(sp)
 3ce:	0141                	addi	sp,sp,16
 3d0:	8082                	ret

00000000000003d2 <thread_create>:
//    condwakeup(cond->curr);
//  }
//}
int
thread_create(void (*start_routine)(void*, void*), void *arg1, void *arg2)
{
 3d2:	7179                	addi	sp,sp,-48
 3d4:	f406                	sd	ra,40(sp)
 3d6:	f022                	sd	s0,32(sp)
 3d8:	ec26                	sd	s1,24(sp)
 3da:	e84a                	sd	s2,16(sp)
 3dc:	e44e                	sd	s3,8(sp)
 3de:	1800                	addi	s0,sp,48
 3e0:	84aa                	mv	s1,a0
 3e2:	892e                	mv	s2,a1
 3e4:	89b2                	mv	s3,a2
  void *stack = malloc(PGSIZE*2); //allocate space on the heap, should be 1 page in size and pagesize aligned
 3e6:	6509                	lui	a0,0x2
 3e8:	00000097          	auipc	ra,0x0
 3ec:	512080e7          	jalr	1298(ra) # 8fa <malloc>
 3f0:	86aa                	mv	a3,a0
  if((uint64)stack % PGSIZE) { //not aligned
 3f2:	03451793          	slli	a5,a0,0x34
 3f6:	c799                	beqz	a5,404 <thread_create+0x32>
 3f8:	0347d713          	srli	a4,a5,0x34
    stack = stack + (PGSIZE - (uint64)stack % PGSIZE); //make is pagesize aligned
 3fc:	6785                	lui	a5,0x1
 3fe:	8f99                	sub	a5,a5,a4
 400:	00f506b3          	add	a3,a0,a5
  }
  int pid = clone(start_routine, arg1, arg2, stack);
 404:	864e                	mv	a2,s3
 406:	85ca                	mv	a1,s2
 408:	8526                	mv	a0,s1
 40a:	00000097          	auipc	ra,0x0
 40e:	0f2080e7          	jalr	242(ra) # 4fc <clone>
  return pid;
}
 412:	70a2                	ld	ra,40(sp)
 414:	7402                	ld	s0,32(sp)
 416:	64e2                	ld	s1,24(sp)
 418:	6942                	ld	s2,16(sp)
 41a:	69a2                	ld	s3,8(sp)
 41c:	6145                	addi	sp,sp,48
 41e:	8082                	ret

0000000000000420 <thread_join>:

int thread_join() {
 420:	7179                	addi	sp,sp,-48
 422:	f406                	sd	ra,40(sp)
 424:	f022                	sd	s0,32(sp)
 426:	ec26                	sd	s1,24(sp)
 428:	1800                	addi	s0,sp,48
  void *ustack = 0;
 42a:	fc043c23          	sd	zero,-40(s0)
  int status = join(&ustack);
 42e:	fd840513          	addi	a0,s0,-40
 432:	00000097          	auipc	ra,0x0
 436:	0d2080e7          	jalr	210(ra) # 504 <join>
 43a:	84aa                	mv	s1,a0
  free(ustack);
 43c:	fd843503          	ld	a0,-40(s0)
 440:	00000097          	auipc	ra,0x0
 444:	432080e7          	jalr	1074(ra) # 872 <free>
  return status;
}
 448:	8526                	mv	a0,s1
 44a:	70a2                	ld	ra,40(sp)
 44c:	7402                	ld	s0,32(sp)
 44e:	64e2                	ld	s1,24(sp)
 450:	6145                	addi	sp,sp,48
 452:	8082                	ret

0000000000000454 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 454:	4885                	li	a7,1
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <exit>:
.global exit
exit:
 li a7, SYS_exit
 45c:	4889                	li	a7,2
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <wait>:
.global wait
wait:
 li a7, SYS_wait
 464:	488d                	li	a7,3
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 46c:	4891                	li	a7,4
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <read>:
.global read
read:
 li a7, SYS_read
 474:	4895                	li	a7,5
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <write>:
.global write
write:
 li a7, SYS_write
 47c:	48c1                	li	a7,16
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <close>:
.global close
close:
 li a7, SYS_close
 484:	48d5                	li	a7,21
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <kill>:
.global kill
kill:
 li a7, SYS_kill
 48c:	4899                	li	a7,6
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <exec>:
.global exec
exec:
 li a7, SYS_exec
 494:	489d                	li	a7,7
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <open>:
.global open
open:
 li a7, SYS_open
 49c:	48bd                	li	a7,15
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4a4:	48c5                	li	a7,17
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4ac:	48c9                	li	a7,18
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4b4:	48a1                	li	a7,8
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <link>:
.global link
link:
 li a7, SYS_link
 4bc:	48cd                	li	a7,19
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4c4:	48d1                	li	a7,20
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4cc:	48a5                	li	a7,9
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4d4:	48a9                	li	a7,10
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4dc:	48ad                	li	a7,11
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4e4:	48b1                	li	a7,12
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4ec:	48b5                	li	a7,13
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4f4:	48b9                	li	a7,14
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <clone>:
.global clone
clone:
 li a7, SYS_clone
 4fc:	48d9                	li	a7,22
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <join>:
.global join
join:
 li a7, SYS_join
 504:	48dd                	li	a7,23
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <putc>:
  int type;
};

static void
putc(int fd, char c)
{
 50c:	1101                	addi	sp,sp,-32
 50e:	ec06                	sd	ra,24(sp)
 510:	e822                	sd	s0,16(sp)
 512:	1000                	addi	s0,sp,32
 514:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 518:	4605                	li	a2,1
 51a:	fef40593          	addi	a1,s0,-17
 51e:	00000097          	auipc	ra,0x0
 522:	f5e080e7          	jalr	-162(ra) # 47c <write>
}
 526:	60e2                	ld	ra,24(sp)
 528:	6442                	ld	s0,16(sp)
 52a:	6105                	addi	sp,sp,32
 52c:	8082                	ret

000000000000052e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 52e:	7139                	addi	sp,sp,-64
 530:	fc06                	sd	ra,56(sp)
 532:	f822                	sd	s0,48(sp)
 534:	f426                	sd	s1,40(sp)
 536:	f04a                	sd	s2,32(sp)
 538:	ec4e                	sd	s3,24(sp)
 53a:	0080                	addi	s0,sp,64
 53c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 53e:	c299                	beqz	a3,544 <printint+0x16>
 540:	0805c863          	bltz	a1,5d0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 544:	2581                	sext.w	a1,a1
  neg = 0;
 546:	4881                	li	a7,0
 548:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 54c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 54e:	2601                	sext.w	a2,a2
 550:	00000517          	auipc	a0,0x0
 554:	4e850513          	addi	a0,a0,1256 # a38 <digits>
 558:	883a                	mv	a6,a4
 55a:	2705                	addiw	a4,a4,1
 55c:	02c5f7bb          	remuw	a5,a1,a2
 560:	1782                	slli	a5,a5,0x20
 562:	9381                	srli	a5,a5,0x20
 564:	97aa                	add	a5,a5,a0
 566:	0007c783          	lbu	a5,0(a5) # 1000 <__BSS_END__+0x380>
 56a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 56e:	0005879b          	sext.w	a5,a1
 572:	02c5d5bb          	divuw	a1,a1,a2
 576:	0685                	addi	a3,a3,1
 578:	fec7f0e3          	bgeu	a5,a2,558 <printint+0x2a>
  if(neg)
 57c:	00088b63          	beqz	a7,592 <printint+0x64>
    buf[i++] = '-';
 580:	fd040793          	addi	a5,s0,-48
 584:	973e                	add	a4,a4,a5
 586:	02d00793          	li	a5,45
 58a:	fef70823          	sb	a5,-16(a4)
 58e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 592:	02e05863          	blez	a4,5c2 <printint+0x94>
 596:	fc040793          	addi	a5,s0,-64
 59a:	00e78933          	add	s2,a5,a4
 59e:	fff78993          	addi	s3,a5,-1
 5a2:	99ba                	add	s3,s3,a4
 5a4:	377d                	addiw	a4,a4,-1
 5a6:	1702                	slli	a4,a4,0x20
 5a8:	9301                	srli	a4,a4,0x20
 5aa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5ae:	fff94583          	lbu	a1,-1(s2)
 5b2:	8526                	mv	a0,s1
 5b4:	00000097          	auipc	ra,0x0
 5b8:	f58080e7          	jalr	-168(ra) # 50c <putc>
  while(--i >= 0)
 5bc:	197d                	addi	s2,s2,-1
 5be:	ff3918e3          	bne	s2,s3,5ae <printint+0x80>
}
 5c2:	70e2                	ld	ra,56(sp)
 5c4:	7442                	ld	s0,48(sp)
 5c6:	74a2                	ld	s1,40(sp)
 5c8:	7902                	ld	s2,32(sp)
 5ca:	69e2                	ld	s3,24(sp)
 5cc:	6121                	addi	sp,sp,64
 5ce:	8082                	ret
    x = -xx;
 5d0:	40b005bb          	negw	a1,a1
    neg = 1;
 5d4:	4885                	li	a7,1
    x = -xx;
 5d6:	bf8d                	j	548 <printint+0x1a>

00000000000005d8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5d8:	7119                	addi	sp,sp,-128
 5da:	fc86                	sd	ra,120(sp)
 5dc:	f8a2                	sd	s0,112(sp)
 5de:	f4a6                	sd	s1,104(sp)
 5e0:	f0ca                	sd	s2,96(sp)
 5e2:	ecce                	sd	s3,88(sp)
 5e4:	e8d2                	sd	s4,80(sp)
 5e6:	e4d6                	sd	s5,72(sp)
 5e8:	e0da                	sd	s6,64(sp)
 5ea:	fc5e                	sd	s7,56(sp)
 5ec:	f862                	sd	s8,48(sp)
 5ee:	f466                	sd	s9,40(sp)
 5f0:	f06a                	sd	s10,32(sp)
 5f2:	ec6e                	sd	s11,24(sp)
 5f4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f6:	0005c903          	lbu	s2,0(a1)
 5fa:	18090f63          	beqz	s2,798 <vprintf+0x1c0>
 5fe:	8aaa                	mv	s5,a0
 600:	8b32                	mv	s6,a2
 602:	00158493          	addi	s1,a1,1
  state = 0;
 606:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 608:	02500a13          	li	s4,37
      if(c == 'd'){
 60c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 610:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 614:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 618:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 61c:	00000b97          	auipc	s7,0x0
 620:	41cb8b93          	addi	s7,s7,1052 # a38 <digits>
 624:	a839                	j	642 <vprintf+0x6a>
        putc(fd, c);
 626:	85ca                	mv	a1,s2
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	ee2080e7          	jalr	-286(ra) # 50c <putc>
 632:	a019                	j	638 <vprintf+0x60>
    } else if(state == '%'){
 634:	01498f63          	beq	s3,s4,652 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 638:	0485                	addi	s1,s1,1
 63a:	fff4c903          	lbu	s2,-1(s1)
 63e:	14090d63          	beqz	s2,798 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 642:	0009079b          	sext.w	a5,s2
    if(state == 0){
 646:	fe0997e3          	bnez	s3,634 <vprintf+0x5c>
      if(c == '%'){
 64a:	fd479ee3          	bne	a5,s4,626 <vprintf+0x4e>
        state = '%';
 64e:	89be                	mv	s3,a5
 650:	b7e5                	j	638 <vprintf+0x60>
      if(c == 'd'){
 652:	05878063          	beq	a5,s8,692 <vprintf+0xba>
      } else if(c == 'l') {
 656:	05978c63          	beq	a5,s9,6ae <vprintf+0xd6>
      } else if(c == 'x') {
 65a:	07a78863          	beq	a5,s10,6ca <vprintf+0xf2>
      } else if(c == 'p') {
 65e:	09b78463          	beq	a5,s11,6e6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 662:	07300713          	li	a4,115
 666:	0ce78663          	beq	a5,a4,732 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 66a:	06300713          	li	a4,99
 66e:	0ee78e63          	beq	a5,a4,76a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 672:	11478863          	beq	a5,s4,782 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 676:	85d2                	mv	a1,s4
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	e92080e7          	jalr	-366(ra) # 50c <putc>
        putc(fd, c);
 682:	85ca                	mv	a1,s2
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	e86080e7          	jalr	-378(ra) # 50c <putc>
      }
      state = 0;
 68e:	4981                	li	s3,0
 690:	b765                	j	638 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 692:	008b0913          	addi	s2,s6,8
 696:	4685                	li	a3,1
 698:	4629                	li	a2,10
 69a:	000b2583          	lw	a1,0(s6)
 69e:	8556                	mv	a0,s5
 6a0:	00000097          	auipc	ra,0x0
 6a4:	e8e080e7          	jalr	-370(ra) # 52e <printint>
 6a8:	8b4a                	mv	s6,s2
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b771                	j	638 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ae:	008b0913          	addi	s2,s6,8
 6b2:	4681                	li	a3,0
 6b4:	4629                	li	a2,10
 6b6:	000b2583          	lw	a1,0(s6)
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	e72080e7          	jalr	-398(ra) # 52e <printint>
 6c4:	8b4a                	mv	s6,s2
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	bf85                	j	638 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6ca:	008b0913          	addi	s2,s6,8
 6ce:	4681                	li	a3,0
 6d0:	4641                	li	a2,16
 6d2:	000b2583          	lw	a1,0(s6)
 6d6:	8556                	mv	a0,s5
 6d8:	00000097          	auipc	ra,0x0
 6dc:	e56080e7          	jalr	-426(ra) # 52e <printint>
 6e0:	8b4a                	mv	s6,s2
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	bf91                	j	638 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6e6:	008b0793          	addi	a5,s6,8
 6ea:	f8f43423          	sd	a5,-120(s0)
 6ee:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6f2:	03000593          	li	a1,48
 6f6:	8556                	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	e14080e7          	jalr	-492(ra) # 50c <putc>
  putc(fd, 'x');
 700:	85ea                	mv	a1,s10
 702:	8556                	mv	a0,s5
 704:	00000097          	auipc	ra,0x0
 708:	e08080e7          	jalr	-504(ra) # 50c <putc>
 70c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70e:	03c9d793          	srli	a5,s3,0x3c
 712:	97de                	add	a5,a5,s7
 714:	0007c583          	lbu	a1,0(a5)
 718:	8556                	mv	a0,s5
 71a:	00000097          	auipc	ra,0x0
 71e:	df2080e7          	jalr	-526(ra) # 50c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 722:	0992                	slli	s3,s3,0x4
 724:	397d                	addiw	s2,s2,-1
 726:	fe0914e3          	bnez	s2,70e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 72a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 72e:	4981                	li	s3,0
 730:	b721                	j	638 <vprintf+0x60>
        s = va_arg(ap, char*);
 732:	008b0993          	addi	s3,s6,8
 736:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 73a:	02090163          	beqz	s2,75c <vprintf+0x184>
        while(*s != 0){
 73e:	00094583          	lbu	a1,0(s2)
 742:	c9a1                	beqz	a1,792 <vprintf+0x1ba>
          putc(fd, *s);
 744:	8556                	mv	a0,s5
 746:	00000097          	auipc	ra,0x0
 74a:	dc6080e7          	jalr	-570(ra) # 50c <putc>
          s++;
 74e:	0905                	addi	s2,s2,1
        while(*s != 0){
 750:	00094583          	lbu	a1,0(s2)
 754:	f9e5                	bnez	a1,744 <vprintf+0x16c>
        s = va_arg(ap, char*);
 756:	8b4e                	mv	s6,s3
      state = 0;
 758:	4981                	li	s3,0
 75a:	bdf9                	j	638 <vprintf+0x60>
          s = "(null)";
 75c:	00000917          	auipc	s2,0x0
 760:	2cc90913          	addi	s2,s2,716 # a28 <malloc+0x12e>
        while(*s != 0){
 764:	02800593          	li	a1,40
 768:	bff1                	j	744 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 76a:	008b0913          	addi	s2,s6,8
 76e:	000b4583          	lbu	a1,0(s6)
 772:	8556                	mv	a0,s5
 774:	00000097          	auipc	ra,0x0
 778:	d98080e7          	jalr	-616(ra) # 50c <putc>
 77c:	8b4a                	mv	s6,s2
      state = 0;
 77e:	4981                	li	s3,0
 780:	bd65                	j	638 <vprintf+0x60>
        putc(fd, c);
 782:	85d2                	mv	a1,s4
 784:	8556                	mv	a0,s5
 786:	00000097          	auipc	ra,0x0
 78a:	d86080e7          	jalr	-634(ra) # 50c <putc>
      state = 0;
 78e:	4981                	li	s3,0
 790:	b565                	j	638 <vprintf+0x60>
        s = va_arg(ap, char*);
 792:	8b4e                	mv	s6,s3
      state = 0;
 794:	4981                	li	s3,0
 796:	b54d                	j	638 <vprintf+0x60>
    }
  }
}
 798:	70e6                	ld	ra,120(sp)
 79a:	7446                	ld	s0,112(sp)
 79c:	74a6                	ld	s1,104(sp)
 79e:	7906                	ld	s2,96(sp)
 7a0:	69e6                	ld	s3,88(sp)
 7a2:	6a46                	ld	s4,80(sp)
 7a4:	6aa6                	ld	s5,72(sp)
 7a6:	6b06                	ld	s6,64(sp)
 7a8:	7be2                	ld	s7,56(sp)
 7aa:	7c42                	ld	s8,48(sp)
 7ac:	7ca2                	ld	s9,40(sp)
 7ae:	7d02                	ld	s10,32(sp)
 7b0:	6de2                	ld	s11,24(sp)
 7b2:	6109                	addi	sp,sp,128
 7b4:	8082                	ret

00000000000007b6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b6:	715d                	addi	sp,sp,-80
 7b8:	ec06                	sd	ra,24(sp)
 7ba:	e822                	sd	s0,16(sp)
 7bc:	1000                	addi	s0,sp,32
 7be:	e010                	sd	a2,0(s0)
 7c0:	e414                	sd	a3,8(s0)
 7c2:	e818                	sd	a4,16(s0)
 7c4:	ec1c                	sd	a5,24(s0)
 7c6:	03043023          	sd	a6,32(s0)
 7ca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ce:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d2:	8622                	mv	a2,s0
 7d4:	00000097          	auipc	ra,0x0
 7d8:	e04080e7          	jalr	-508(ra) # 5d8 <vprintf>
}
 7dc:	60e2                	ld	ra,24(sp)
 7de:	6442                	ld	s0,16(sp)
 7e0:	6161                	addi	sp,sp,80
 7e2:	8082                	ret

00000000000007e4 <printf>:

void
printf(const char *fmt, ...)
{
 7e4:	7159                	addi	sp,sp,-112
 7e6:	f406                	sd	ra,40(sp)
 7e8:	f022                	sd	s0,32(sp)
 7ea:	ec26                	sd	s1,24(sp)
 7ec:	e84a                	sd	s2,16(sp)
 7ee:	1800                	addi	s0,sp,48
 7f0:	84aa                	mv	s1,a0
 7f2:	e40c                	sd	a1,8(s0)
 7f4:	e810                	sd	a2,16(s0)
 7f6:	ec14                	sd	a3,24(s0)
 7f8:	f018                	sd	a4,32(s0)
 7fa:	f41c                	sd	a5,40(s0)
 7fc:	03043823          	sd	a6,48(s0)
 800:	03143c23          	sd	a7,56(s0)
  va_list ap;
  lock_acquire(&pr.printf_lock);
 804:	00000917          	auipc	s2,0x0
 808:	45490913          	addi	s2,s2,1108 # c58 <pr>
 80c:	854a                	mv	a0,s2
 80e:	00000097          	auipc	ra,0x0
 812:	b88080e7          	jalr	-1144(ra) # 396 <lock_acquire>

  va_start(ap, fmt);
 816:	00840613          	addi	a2,s0,8
 81a:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 81e:	85a6                	mv	a1,s1
 820:	4505                	li	a0,1
 822:	00000097          	auipc	ra,0x0
 826:	db6080e7          	jalr	-586(ra) # 5d8 <vprintf>
  
  lock_release(&pr.printf_lock);
 82a:	854a                	mv	a0,s2
 82c:	00000097          	auipc	ra,0x0
 830:	b8a080e7          	jalr	-1142(ra) # 3b6 <lock_release>

}
 834:	70a2                	ld	ra,40(sp)
 836:	7402                	ld	s0,32(sp)
 838:	64e2                	ld	s1,24(sp)
 83a:	6942                	ld	s2,16(sp)
 83c:	6165                	addi	sp,sp,112
 83e:	8082                	ret

0000000000000840 <printfinit>:

void
printfinit(void)
{
 840:	1101                	addi	sp,sp,-32
 842:	ec06                	sd	ra,24(sp)
 844:	e822                	sd	s0,16(sp)
 846:	e426                	sd	s1,8(sp)
 848:	1000                	addi	s0,sp,32
  lock_init(&pr.printf_lock, "pr");
 84a:	00000497          	auipc	s1,0x0
 84e:	40e48493          	addi	s1,s1,1038 # c58 <pr>
 852:	00000597          	auipc	a1,0x0
 856:	1de58593          	addi	a1,a1,478 # a30 <malloc+0x136>
 85a:	8526                	mv	a0,s1
 85c:	00000097          	auipc	ra,0x0
 860:	b28080e7          	jalr	-1240(ra) # 384 <lock_init>
  pr.locking = 1;
 864:	4785                	li	a5,1
 866:	c89c                	sw	a5,16(s1)
}
 868:	60e2                	ld	ra,24(sp)
 86a:	6442                	ld	s0,16(sp)
 86c:	64a2                	ld	s1,8(sp)
 86e:	6105                	addi	sp,sp,32
 870:	8082                	ret

0000000000000872 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 872:	1141                	addi	sp,sp,-16
 874:	e422                	sd	s0,8(sp)
 876:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 878:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87c:	00000797          	auipc	a5,0x0
 880:	1d47b783          	ld	a5,468(a5) # a50 <freep>
 884:	a805                	j	8b4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 886:	4618                	lw	a4,8(a2)
 888:	9db9                	addw	a1,a1,a4
 88a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 88e:	6398                	ld	a4,0(a5)
 890:	6318                	ld	a4,0(a4)
 892:	fee53823          	sd	a4,-16(a0)
 896:	a091                	j	8da <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 898:	ff852703          	lw	a4,-8(a0)
 89c:	9e39                	addw	a2,a2,a4
 89e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8a0:	ff053703          	ld	a4,-16(a0)
 8a4:	e398                	sd	a4,0(a5)
 8a6:	a099                	j	8ec <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a8:	6398                	ld	a4,0(a5)
 8aa:	00e7e463          	bltu	a5,a4,8b2 <free+0x40>
 8ae:	00e6ea63          	bltu	a3,a4,8c2 <free+0x50>
{
 8b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b4:	fed7fae3          	bgeu	a5,a3,8a8 <free+0x36>
 8b8:	6398                	ld	a4,0(a5)
 8ba:	00e6e463          	bltu	a3,a4,8c2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8be:	fee7eae3          	bltu	a5,a4,8b2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8c2:	ff852583          	lw	a1,-8(a0)
 8c6:	6390                	ld	a2,0(a5)
 8c8:	02059713          	slli	a4,a1,0x20
 8cc:	9301                	srli	a4,a4,0x20
 8ce:	0712                	slli	a4,a4,0x4
 8d0:	9736                	add	a4,a4,a3
 8d2:	fae60ae3          	beq	a2,a4,886 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8d6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8da:	4790                	lw	a2,8(a5)
 8dc:	02061713          	slli	a4,a2,0x20
 8e0:	9301                	srli	a4,a4,0x20
 8e2:	0712                	slli	a4,a4,0x4
 8e4:	973e                	add	a4,a4,a5
 8e6:	fae689e3          	beq	a3,a4,898 <free+0x26>
  } else
    p->s.ptr = bp;
 8ea:	e394                	sd	a3,0(a5)
  freep = p;
 8ec:	00000717          	auipc	a4,0x0
 8f0:	16f73223          	sd	a5,356(a4) # a50 <freep>
}
 8f4:	6422                	ld	s0,8(sp)
 8f6:	0141                	addi	sp,sp,16
 8f8:	8082                	ret

00000000000008fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8fa:	7139                	addi	sp,sp,-64
 8fc:	fc06                	sd	ra,56(sp)
 8fe:	f822                	sd	s0,48(sp)
 900:	f426                	sd	s1,40(sp)
 902:	f04a                	sd	s2,32(sp)
 904:	ec4e                	sd	s3,24(sp)
 906:	e852                	sd	s4,16(sp)
 908:	e456                	sd	s5,8(sp)
 90a:	e05a                	sd	s6,0(sp)
 90c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 90e:	02051493          	slli	s1,a0,0x20
 912:	9081                	srli	s1,s1,0x20
 914:	04bd                	addi	s1,s1,15
 916:	8091                	srli	s1,s1,0x4
 918:	0014899b          	addiw	s3,s1,1
 91c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 91e:	00000517          	auipc	a0,0x0
 922:	13253503          	ld	a0,306(a0) # a50 <freep>
 926:	c515                	beqz	a0,952 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 928:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92a:	4798                	lw	a4,8(a5)
 92c:	02977f63          	bgeu	a4,s1,96a <malloc+0x70>
 930:	8a4e                	mv	s4,s3
 932:	0009871b          	sext.w	a4,s3
 936:	6685                	lui	a3,0x1
 938:	00d77363          	bgeu	a4,a3,93e <malloc+0x44>
 93c:	6a05                	lui	s4,0x1
 93e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 942:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 946:	00000917          	auipc	s2,0x0
 94a:	10a90913          	addi	s2,s2,266 # a50 <freep>
  if(p == (char*)-1)
 94e:	5afd                	li	s5,-1
 950:	a88d                	j	9c2 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 952:	00000797          	auipc	a5,0x0
 956:	31e78793          	addi	a5,a5,798 # c70 <base>
 95a:	00000717          	auipc	a4,0x0
 95e:	0ef73b23          	sd	a5,246(a4) # a50 <freep>
 962:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 964:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 968:	b7e1                	j	930 <malloc+0x36>
      if(p->s.size == nunits)
 96a:	02e48b63          	beq	s1,a4,9a0 <malloc+0xa6>
        p->s.size -= nunits;
 96e:	4137073b          	subw	a4,a4,s3
 972:	c798                	sw	a4,8(a5)
        p += p->s.size;
 974:	1702                	slli	a4,a4,0x20
 976:	9301                	srli	a4,a4,0x20
 978:	0712                	slli	a4,a4,0x4
 97a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 97c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 980:	00000717          	auipc	a4,0x0
 984:	0ca73823          	sd	a0,208(a4) # a50 <freep>
      return (void*)(p + 1);
 988:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 98c:	70e2                	ld	ra,56(sp)
 98e:	7442                	ld	s0,48(sp)
 990:	74a2                	ld	s1,40(sp)
 992:	7902                	ld	s2,32(sp)
 994:	69e2                	ld	s3,24(sp)
 996:	6a42                	ld	s4,16(sp)
 998:	6aa2                	ld	s5,8(sp)
 99a:	6b02                	ld	s6,0(sp)
 99c:	6121                	addi	sp,sp,64
 99e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9a0:	6398                	ld	a4,0(a5)
 9a2:	e118                	sd	a4,0(a0)
 9a4:	bff1                	j	980 <malloc+0x86>
  hp->s.size = nu;
 9a6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9aa:	0541                	addi	a0,a0,16
 9ac:	00000097          	auipc	ra,0x0
 9b0:	ec6080e7          	jalr	-314(ra) # 872 <free>
  return freep;
 9b4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9b8:	d971                	beqz	a0,98c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9bc:	4798                	lw	a4,8(a5)
 9be:	fa9776e3          	bgeu	a4,s1,96a <malloc+0x70>
    if(p == freep)
 9c2:	00093703          	ld	a4,0(s2)
 9c6:	853e                	mv	a0,a5
 9c8:	fef719e3          	bne	a4,a5,9ba <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9cc:	8552                	mv	a0,s4
 9ce:	00000097          	auipc	ra,0x0
 9d2:	b16080e7          	jalr	-1258(ra) # 4e4 <sbrk>
  if(p == (char*)-1)
 9d6:	fd5518e3          	bne	a0,s5,9a6 <malloc+0xac>
        return 0;
 9da:	4501                	li	a0,0
 9dc:	bf45                	j	98c <malloc+0x92>
