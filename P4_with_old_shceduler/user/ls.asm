
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	30c080e7          	jalr	780(ra) # 31c <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	2e0080e7          	jalr	736(ra) # 31c <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2be080e7          	jalr	702(ra) # 31c <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	b5a98993          	addi	s3,s3,-1190 # bc0 <buf.1129>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	41e080e7          	jalr	1054(ra) # 494 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	29c080e7          	jalr	668(ra) # 31c <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	28e080e7          	jalr	654(ra) # 31c <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	29e080e7          	jalr	670(ra) # 346 <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	addi	s0,sp,624
  d6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  d8:	4581                	li	a1,0
  da:	00000097          	auipc	ra,0x0
  de:	500080e7          	jalr	1280(ra) # 5da <open>
  e2:	06054f63          	bltz	a0,160 <ls+0xac>
  e6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  e8:	d9840593          	addi	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	506080e7          	jalr	1286(ra) # 5f2 <fstat>
  f4:	08054163          	bltz	a0,176 <ls+0xc2>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  f8:	da041783          	lh	a5,-608(s0)
  fc:	0007869b          	sext.w	a3,a5
 100:	4705                	li	a4,1
 102:	08e68a63          	beq	a3,a4,196 <ls+0xe2>
 106:	4709                	li	a4,2
 108:	02e69663          	bne	a3,a4,134 <ls+0x80>
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 10c:	854a                	mv	a0,s2
 10e:	00000097          	auipc	ra,0x0
 112:	ef2080e7          	jalr	-270(ra) # 0 <fmtname>
 116:	85aa                	mv	a1,a0
 118:	da843703          	ld	a4,-600(s0)
 11c:	d9c42683          	lw	a3,-612(s0)
 120:	da041603          	lh	a2,-608(s0)
 124:	00001517          	auipc	a0,0x1
 128:	a2c50513          	addi	a0,a0,-1492 # b50 <malloc+0x118>
 12c:	00000097          	auipc	ra,0x0
 130:	7f6080e7          	jalr	2038(ra) # 922 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 134:	8526                	mv	a0,s1
 136:	00000097          	auipc	ra,0x0
 13a:	48c080e7          	jalr	1164(ra) # 5c2 <close>
}
 13e:	26813083          	ld	ra,616(sp)
 142:	26013403          	ld	s0,608(sp)
 146:	25813483          	ld	s1,600(sp)
 14a:	25013903          	ld	s2,592(sp)
 14e:	24813983          	ld	s3,584(sp)
 152:	24013a03          	ld	s4,576(sp)
 156:	23813a83          	ld	s5,568(sp)
 15a:	27010113          	addi	sp,sp,624
 15e:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 160:	864a                	mv	a2,s2
 162:	00001597          	auipc	a1,0x1
 166:	9be58593          	addi	a1,a1,-1602 # b20 <malloc+0xe8>
 16a:	4509                	li	a0,2
 16c:	00000097          	auipc	ra,0x0
 170:	788080e7          	jalr	1928(ra) # 8f4 <fprintf>
    return;
 174:	b7e9                	j	13e <ls+0x8a>
    fprintf(2, "ls: cannot stat %s\n", path);
 176:	864a                	mv	a2,s2
 178:	00001597          	auipc	a1,0x1
 17c:	9c058593          	addi	a1,a1,-1600 # b38 <malloc+0x100>
 180:	4509                	li	a0,2
 182:	00000097          	auipc	ra,0x0
 186:	772080e7          	jalr	1906(ra) # 8f4 <fprintf>
    close(fd);
 18a:	8526                	mv	a0,s1
 18c:	00000097          	auipc	ra,0x0
 190:	436080e7          	jalr	1078(ra) # 5c2 <close>
    return;
 194:	b76d                	j	13e <ls+0x8a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 196:	854a                	mv	a0,s2
 198:	00000097          	auipc	ra,0x0
 19c:	184080e7          	jalr	388(ra) # 31c <strlen>
 1a0:	2541                	addiw	a0,a0,16
 1a2:	20000793          	li	a5,512
 1a6:	00a7fb63          	bgeu	a5,a0,1bc <ls+0x108>
      printf("ls: path too long\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	9b650513          	addi	a0,a0,-1610 # b60 <malloc+0x128>
 1b2:	00000097          	auipc	ra,0x0
 1b6:	770080e7          	jalr	1904(ra) # 922 <printf>
      break;
 1ba:	bfad                	j	134 <ls+0x80>
    strcpy(buf, path);
 1bc:	85ca                	mv	a1,s2
 1be:	dc040513          	addi	a0,s0,-576
 1c2:	00000097          	auipc	ra,0x0
 1c6:	112080e7          	jalr	274(ra) # 2d4 <strcpy>
    p = buf+strlen(buf);
 1ca:	dc040513          	addi	a0,s0,-576
 1ce:	00000097          	auipc	ra,0x0
 1d2:	14e080e7          	jalr	334(ra) # 31c <strlen>
 1d6:	02051913          	slli	s2,a0,0x20
 1da:	02095913          	srli	s2,s2,0x20
 1de:	dc040793          	addi	a5,s0,-576
 1e2:	993e                	add	s2,s2,a5
    *p++ = '/';
 1e4:	00190993          	addi	s3,s2,1
 1e8:	02f00793          	li	a5,47
 1ec:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1f0:	00001a17          	auipc	s4,0x1
 1f4:	988a0a13          	addi	s4,s4,-1656 # b78 <malloc+0x140>
        printf("ls: cannot stat %s\n", buf);
 1f8:	00001a97          	auipc	s5,0x1
 1fc:	940a8a93          	addi	s5,s5,-1728 # b38 <malloc+0x100>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 200:	a801                	j	210 <ls+0x15c>
        printf("ls: cannot stat %s\n", buf);
 202:	dc040593          	addi	a1,s0,-576
 206:	8556                	mv	a0,s5
 208:	00000097          	auipc	ra,0x0
 20c:	71a080e7          	jalr	1818(ra) # 922 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 210:	4641                	li	a2,16
 212:	db040593          	addi	a1,s0,-592
 216:	8526                	mv	a0,s1
 218:	00000097          	auipc	ra,0x0
 21c:	39a080e7          	jalr	922(ra) # 5b2 <read>
 220:	47c1                	li	a5,16
 222:	f0f519e3          	bne	a0,a5,134 <ls+0x80>
      if(de.inum == 0)
 226:	db045783          	lhu	a5,-592(s0)
 22a:	d3fd                	beqz	a5,210 <ls+0x15c>
      memmove(p, de.name, DIRSIZ);
 22c:	4639                	li	a2,14
 22e:	db240593          	addi	a1,s0,-590
 232:	854e                	mv	a0,s3
 234:	00000097          	auipc	ra,0x0
 238:	260080e7          	jalr	608(ra) # 494 <memmove>
      p[DIRSIZ] = 0;
 23c:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 240:	d9840593          	addi	a1,s0,-616
 244:	dc040513          	addi	a0,s0,-576
 248:	00000097          	auipc	ra,0x0
 24c:	1bc080e7          	jalr	444(ra) # 404 <stat>
 250:	fa0549e3          	bltz	a0,202 <ls+0x14e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 254:	dc040513          	addi	a0,s0,-576
 258:	00000097          	auipc	ra,0x0
 25c:	da8080e7          	jalr	-600(ra) # 0 <fmtname>
 260:	85aa                	mv	a1,a0
 262:	da843703          	ld	a4,-600(s0)
 266:	d9c42683          	lw	a3,-612(s0)
 26a:	da041603          	lh	a2,-608(s0)
 26e:	8552                	mv	a0,s4
 270:	00000097          	auipc	ra,0x0
 274:	6b2080e7          	jalr	1714(ra) # 922 <printf>
 278:	bf61                	j	210 <ls+0x15c>

000000000000027a <main>:

int
main(int argc, char *argv[])
{
 27a:	1101                	addi	sp,sp,-32
 27c:	ec06                	sd	ra,24(sp)
 27e:	e822                	sd	s0,16(sp)
 280:	e426                	sd	s1,8(sp)
 282:	e04a                	sd	s2,0(sp)
 284:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 286:	4785                	li	a5,1
 288:	02a7d963          	bge	a5,a0,2ba <main+0x40>
 28c:	00858493          	addi	s1,a1,8
 290:	ffe5091b          	addiw	s2,a0,-2
 294:	1902                	slli	s2,s2,0x20
 296:	02095913          	srli	s2,s2,0x20
 29a:	090e                	slli	s2,s2,0x3
 29c:	05c1                	addi	a1,a1,16
 29e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a0:	6088                	ld	a0,0(s1)
 2a2:	00000097          	auipc	ra,0x0
 2a6:	e12080e7          	jalr	-494(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2aa:	04a1                	addi	s1,s1,8
 2ac:	ff249ae3          	bne	s1,s2,2a0 <main+0x26>
  exit(0);
 2b0:	4501                	li	a0,0
 2b2:	00000097          	auipc	ra,0x0
 2b6:	2e8080e7          	jalr	744(ra) # 59a <exit>
    ls(".");
 2ba:	00001517          	auipc	a0,0x1
 2be:	8ce50513          	addi	a0,a0,-1842 # b88 <malloc+0x150>
 2c2:	00000097          	auipc	ra,0x0
 2c6:	df2080e7          	jalr	-526(ra) # b4 <ls>
    exit(0);
 2ca:	4501                	li	a0,0
 2cc:	00000097          	auipc	ra,0x0
 2d0:	2ce080e7          	jalr	718(ra) # 59a <exit>

00000000000002d4 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e422                	sd	s0,8(sp)
 2d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2da:	87aa                	mv	a5,a0
 2dc:	0585                	addi	a1,a1,1
 2de:	0785                	addi	a5,a5,1
 2e0:	fff5c703          	lbu	a4,-1(a1)
 2e4:	fee78fa3          	sb	a4,-1(a5)
 2e8:	fb75                	bnez	a4,2dc <strcpy+0x8>
    ;
  return os;
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret

00000000000002f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2f6:	00054783          	lbu	a5,0(a0)
 2fa:	cb91                	beqz	a5,30e <strcmp+0x1e>
 2fc:	0005c703          	lbu	a4,0(a1)
 300:	00f71763          	bne	a4,a5,30e <strcmp+0x1e>
    p++, q++;
 304:	0505                	addi	a0,a0,1
 306:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 308:	00054783          	lbu	a5,0(a0)
 30c:	fbe5                	bnez	a5,2fc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 30e:	0005c503          	lbu	a0,0(a1)
}
 312:	40a7853b          	subw	a0,a5,a0
 316:	6422                	ld	s0,8(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <strlen>:

uint
strlen(const char *s)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 322:	00054783          	lbu	a5,0(a0)
 326:	cf91                	beqz	a5,342 <strlen+0x26>
 328:	0505                	addi	a0,a0,1
 32a:	87aa                	mv	a5,a0
 32c:	4685                	li	a3,1
 32e:	9e89                	subw	a3,a3,a0
 330:	00f6853b          	addw	a0,a3,a5
 334:	0785                	addi	a5,a5,1
 336:	fff7c703          	lbu	a4,-1(a5)
 33a:	fb7d                	bnez	a4,330 <strlen+0x14>
    ;
  return n;
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
  for(n = 0; s[n]; n++)
 342:	4501                	li	a0,0
 344:	bfe5                	j	33c <strlen+0x20>

0000000000000346 <memset>:

void*
memset(void *dst, int c, uint n)
{
 346:	1141                	addi	sp,sp,-16
 348:	e422                	sd	s0,8(sp)
 34a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 34c:	ce09                	beqz	a2,366 <memset+0x20>
 34e:	87aa                	mv	a5,a0
 350:	fff6071b          	addiw	a4,a2,-1
 354:	1702                	slli	a4,a4,0x20
 356:	9301                	srli	a4,a4,0x20
 358:	0705                	addi	a4,a4,1
 35a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 35c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 360:	0785                	addi	a5,a5,1
 362:	fee79de3          	bne	a5,a4,35c <memset+0x16>
  }
  return dst;
}
 366:	6422                	ld	s0,8(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret

000000000000036c <strchr>:

char*
strchr(const char *s, char c)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e422                	sd	s0,8(sp)
 370:	0800                	addi	s0,sp,16
  for(; *s; s++)
 372:	00054783          	lbu	a5,0(a0)
 376:	cb99                	beqz	a5,38c <strchr+0x20>
    if(*s == c)
 378:	00f58763          	beq	a1,a5,386 <strchr+0x1a>
  for(; *s; s++)
 37c:	0505                	addi	a0,a0,1
 37e:	00054783          	lbu	a5,0(a0)
 382:	fbfd                	bnez	a5,378 <strchr+0xc>
      return (char*)s;
  return 0;
 384:	4501                	li	a0,0
}
 386:	6422                	ld	s0,8(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret
  return 0;
 38c:	4501                	li	a0,0
 38e:	bfe5                	j	386 <strchr+0x1a>

0000000000000390 <gets>:

char*
gets(char *buf, int max)
{
 390:	711d                	addi	sp,sp,-96
 392:	ec86                	sd	ra,88(sp)
 394:	e8a2                	sd	s0,80(sp)
 396:	e4a6                	sd	s1,72(sp)
 398:	e0ca                	sd	s2,64(sp)
 39a:	fc4e                	sd	s3,56(sp)
 39c:	f852                	sd	s4,48(sp)
 39e:	f456                	sd	s5,40(sp)
 3a0:	f05a                	sd	s6,32(sp)
 3a2:	ec5e                	sd	s7,24(sp)
 3a4:	1080                	addi	s0,sp,96
 3a6:	8baa                	mv	s7,a0
 3a8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3aa:	892a                	mv	s2,a0
 3ac:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3ae:	4aa9                	li	s5,10
 3b0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3b2:	89a6                	mv	s3,s1
 3b4:	2485                	addiw	s1,s1,1
 3b6:	0344d863          	bge	s1,s4,3e6 <gets+0x56>
    cc = read(0, &c, 1);
 3ba:	4605                	li	a2,1
 3bc:	faf40593          	addi	a1,s0,-81
 3c0:	4501                	li	a0,0
 3c2:	00000097          	auipc	ra,0x0
 3c6:	1f0080e7          	jalr	496(ra) # 5b2 <read>
    if(cc < 1)
 3ca:	00a05e63          	blez	a0,3e6 <gets+0x56>
    buf[i++] = c;
 3ce:	faf44783          	lbu	a5,-81(s0)
 3d2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3d6:	01578763          	beq	a5,s5,3e4 <gets+0x54>
 3da:	0905                	addi	s2,s2,1
 3dc:	fd679be3          	bne	a5,s6,3b2 <gets+0x22>
  for(i=0; i+1 < max; ){
 3e0:	89a6                	mv	s3,s1
 3e2:	a011                	j	3e6 <gets+0x56>
 3e4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3e6:	99de                	add	s3,s3,s7
 3e8:	00098023          	sb	zero,0(s3)
  return buf;
}
 3ec:	855e                	mv	a0,s7
 3ee:	60e6                	ld	ra,88(sp)
 3f0:	6446                	ld	s0,80(sp)
 3f2:	64a6                	ld	s1,72(sp)
 3f4:	6906                	ld	s2,64(sp)
 3f6:	79e2                	ld	s3,56(sp)
 3f8:	7a42                	ld	s4,48(sp)
 3fa:	7aa2                	ld	s5,40(sp)
 3fc:	7b02                	ld	s6,32(sp)
 3fe:	6be2                	ld	s7,24(sp)
 400:	6125                	addi	sp,sp,96
 402:	8082                	ret

0000000000000404 <stat>:

int
stat(const char *n, struct stat *st)
{
 404:	1101                	addi	sp,sp,-32
 406:	ec06                	sd	ra,24(sp)
 408:	e822                	sd	s0,16(sp)
 40a:	e426                	sd	s1,8(sp)
 40c:	e04a                	sd	s2,0(sp)
 40e:	1000                	addi	s0,sp,32
 410:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 412:	4581                	li	a1,0
 414:	00000097          	auipc	ra,0x0
 418:	1c6080e7          	jalr	454(ra) # 5da <open>
  if(fd < 0)
 41c:	02054563          	bltz	a0,446 <stat+0x42>
 420:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 422:	85ca                	mv	a1,s2
 424:	00000097          	auipc	ra,0x0
 428:	1ce080e7          	jalr	462(ra) # 5f2 <fstat>
 42c:	892a                	mv	s2,a0
  close(fd);
 42e:	8526                	mv	a0,s1
 430:	00000097          	auipc	ra,0x0
 434:	192080e7          	jalr	402(ra) # 5c2 <close>
  return r;
}
 438:	854a                	mv	a0,s2
 43a:	60e2                	ld	ra,24(sp)
 43c:	6442                	ld	s0,16(sp)
 43e:	64a2                	ld	s1,8(sp)
 440:	6902                	ld	s2,0(sp)
 442:	6105                	addi	sp,sp,32
 444:	8082                	ret
    return -1;
 446:	597d                	li	s2,-1
 448:	bfc5                	j	438 <stat+0x34>

000000000000044a <atoi>:

int
atoi(const char *s)
{
 44a:	1141                	addi	sp,sp,-16
 44c:	e422                	sd	s0,8(sp)
 44e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 450:	00054603          	lbu	a2,0(a0)
 454:	fd06079b          	addiw	a5,a2,-48
 458:	0ff7f793          	andi	a5,a5,255
 45c:	4725                	li	a4,9
 45e:	02f76963          	bltu	a4,a5,490 <atoi+0x46>
 462:	86aa                	mv	a3,a0
  n = 0;
 464:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 466:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 468:	0685                	addi	a3,a3,1
 46a:	0025179b          	slliw	a5,a0,0x2
 46e:	9fa9                	addw	a5,a5,a0
 470:	0017979b          	slliw	a5,a5,0x1
 474:	9fb1                	addw	a5,a5,a2
 476:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 47a:	0006c603          	lbu	a2,0(a3)
 47e:	fd06071b          	addiw	a4,a2,-48
 482:	0ff77713          	andi	a4,a4,255
 486:	fee5f1e3          	bgeu	a1,a4,468 <atoi+0x1e>
  return n;
}
 48a:	6422                	ld	s0,8(sp)
 48c:	0141                	addi	sp,sp,16
 48e:	8082                	ret
  n = 0;
 490:	4501                	li	a0,0
 492:	bfe5                	j	48a <atoi+0x40>

0000000000000494 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 494:	1141                	addi	sp,sp,-16
 496:	e422                	sd	s0,8(sp)
 498:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 49a:	02c05163          	blez	a2,4bc <memmove+0x28>
 49e:	fff6071b          	addiw	a4,a2,-1
 4a2:	1702                	slli	a4,a4,0x20
 4a4:	9301                	srli	a4,a4,0x20
 4a6:	0705                	addi	a4,a4,1
 4a8:	972a                	add	a4,a4,a0
  dst = vdst;
 4aa:	87aa                	mv	a5,a0
    *dst++ = *src++;
 4ac:	0585                	addi	a1,a1,1
 4ae:	0785                	addi	a5,a5,1
 4b0:	fff5c683          	lbu	a3,-1(a1)
 4b4:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 4b8:	fee79ae3          	bne	a5,a4,4ac <memmove+0x18>
  return vdst;
}
 4bc:	6422                	ld	s0,8(sp)
 4be:	0141                	addi	sp,sp,16
 4c0:	8082                	ret

00000000000004c2 <lock_init>:

void lock_init(lock_t *l, char *name) {
 4c2:	1141                	addi	sp,sp,-16
 4c4:	e422                	sd	s0,8(sp)
 4c6:	0800                	addi	s0,sp,16
 l->name = name;
 4c8:	e10c                	sd	a1,0(a0)
 l->locked = 0;
 4ca:	00052423          	sw	zero,8(a0)
 //l->guard = 0;
}
 4ce:	6422                	ld	s0,8(sp)
 4d0:	0141                	addi	sp,sp,16
 4d2:	8082                	ret

00000000000004d4 <lock_acquire>:

void lock_acquire(lock_t *l) {
 4d4:	1141                	addi	sp,sp,-16
 4d6:	e422                	sd	s0,8(sp)
 4d8:	0800                	addi	s0,sp,16
  while(__sync_lock_test_and_set(&l->locked, 1) != 0)
 4da:	4705                	li	a4,1
 4dc:	87ba                	mv	a5,a4
 4de:	00850693          	addi	a3,a0,8
 4e2:	0cf6a7af          	amoswap.w.aq	a5,a5,(a3)
 4e6:	2781                	sext.w	a5,a5
 4e8:	fbf5                	bnez	a5,4dc <lock_acquire+0x8>
    ;
  __sync_synchronize();
 4ea:	0ff0000f          	fence
}
 4ee:	6422                	ld	s0,8(sp)
 4f0:	0141                	addi	sp,sp,16
 4f2:	8082                	ret

00000000000004f4 <lock_release>:

void lock_release(lock_t *l) {
 4f4:	1141                	addi	sp,sp,-16
 4f6:	e422                	sd	s0,8(sp)
 4f8:	0800                	addi	s0,sp,16
  __sync_synchronize();
 4fa:	0ff0000f          	fence
  __sync_lock_release(&l->locked);
 4fe:	00850793          	addi	a5,a0,8
 502:	0f50000f          	fence	iorw,ow
 506:	0807a02f          	amoswap.w	zero,zero,(a5)
//  l->locked = 0;
}
 50a:	6422                	ld	s0,8(sp)
 50c:	0141                	addi	sp,sp,16
 50e:	8082                	ret

0000000000000510 <thread_create>:
//    condwakeup(cond->curr);
//  }
//}
int
thread_create(void (*start_routine)(void*, void*), void *arg1, void *arg2)
{
 510:	7179                	addi	sp,sp,-48
 512:	f406                	sd	ra,40(sp)
 514:	f022                	sd	s0,32(sp)
 516:	ec26                	sd	s1,24(sp)
 518:	e84a                	sd	s2,16(sp)
 51a:	e44e                	sd	s3,8(sp)
 51c:	1800                	addi	s0,sp,48
 51e:	84aa                	mv	s1,a0
 520:	892e                	mv	s2,a1
 522:	89b2                	mv	s3,a2
  void *stack = malloc(PGSIZE*2); //allocate space on the heap, should be 1 page in size and pagesize aligned
 524:	6509                	lui	a0,0x2
 526:	00000097          	auipc	ra,0x0
 52a:	512080e7          	jalr	1298(ra) # a38 <malloc>
 52e:	86aa                	mv	a3,a0
  if((uint64)stack % PGSIZE) { //not aligned
 530:	03451793          	slli	a5,a0,0x34
 534:	c799                	beqz	a5,542 <thread_create+0x32>
 536:	0347d713          	srli	a4,a5,0x34
    stack = stack + (PGSIZE - (uint64)stack % PGSIZE); //make is pagesize aligned
 53a:	6785                	lui	a5,0x1
 53c:	8f99                	sub	a5,a5,a4
 53e:	00f506b3          	add	a3,a0,a5
  }
  int pid = clone(start_routine, arg1, arg2, stack);
 542:	864e                	mv	a2,s3
 544:	85ca                	mv	a1,s2
 546:	8526                	mv	a0,s1
 548:	00000097          	auipc	ra,0x0
 54c:	0f2080e7          	jalr	242(ra) # 63a <clone>
  return pid;
}
 550:	70a2                	ld	ra,40(sp)
 552:	7402                	ld	s0,32(sp)
 554:	64e2                	ld	s1,24(sp)
 556:	6942                	ld	s2,16(sp)
 558:	69a2                	ld	s3,8(sp)
 55a:	6145                	addi	sp,sp,48
 55c:	8082                	ret

000000000000055e <thread_join>:

int thread_join() {
 55e:	7179                	addi	sp,sp,-48
 560:	f406                	sd	ra,40(sp)
 562:	f022                	sd	s0,32(sp)
 564:	ec26                	sd	s1,24(sp)
 566:	1800                	addi	s0,sp,48
  void *ustack = 0;
 568:	fc043c23          	sd	zero,-40(s0)
  int status = join(&ustack);
 56c:	fd840513          	addi	a0,s0,-40
 570:	00000097          	auipc	ra,0x0
 574:	0d2080e7          	jalr	210(ra) # 642 <join>
 578:	84aa                	mv	s1,a0
  free(ustack);
 57a:	fd843503          	ld	a0,-40(s0)
 57e:	00000097          	auipc	ra,0x0
 582:	432080e7          	jalr	1074(ra) # 9b0 <free>
  return status;
}
 586:	8526                	mv	a0,s1
 588:	70a2                	ld	ra,40(sp)
 58a:	7402                	ld	s0,32(sp)
 58c:	64e2                	ld	s1,24(sp)
 58e:	6145                	addi	sp,sp,48
 590:	8082                	ret

0000000000000592 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 592:	4885                	li	a7,1
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <exit>:
.global exit
exit:
 li a7, SYS_exit
 59a:	4889                	li	a7,2
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5a2:	488d                	li	a7,3
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5aa:	4891                	li	a7,4
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <read>:
.global read
read:
 li a7, SYS_read
 5b2:	4895                	li	a7,5
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <write>:
.global write
write:
 li a7, SYS_write
 5ba:	48c1                	li	a7,16
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <close>:
.global close
close:
 li a7, SYS_close
 5c2:	48d5                	li	a7,21
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <kill>:
.global kill
kill:
 li a7, SYS_kill
 5ca:	4899                	li	a7,6
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5d2:	489d                	li	a7,7
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <open>:
.global open
open:
 li a7, SYS_open
 5da:	48bd                	li	a7,15
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5e2:	48c5                	li	a7,17
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5ea:	48c9                	li	a7,18
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5f2:	48a1                	li	a7,8
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <link>:
.global link
link:
 li a7, SYS_link
 5fa:	48cd                	li	a7,19
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 602:	48d1                	li	a7,20
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 60a:	48a5                	li	a7,9
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <dup>:
.global dup
dup:
 li a7, SYS_dup
 612:	48a9                	li	a7,10
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 61a:	48ad                	li	a7,11
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 622:	48b1                	li	a7,12
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 62a:	48b5                	li	a7,13
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 632:	48b9                	li	a7,14
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <clone>:
.global clone
clone:
 li a7, SYS_clone
 63a:	48d9                	li	a7,22
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <join>:
.global join
join:
 li a7, SYS_join
 642:	48dd                	li	a7,23
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <putc>:
  int type;
};

static void
putc(int fd, char c)
{
 64a:	1101                	addi	sp,sp,-32
 64c:	ec06                	sd	ra,24(sp)
 64e:	e822                	sd	s0,16(sp)
 650:	1000                	addi	s0,sp,32
 652:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 656:	4605                	li	a2,1
 658:	fef40593          	addi	a1,s0,-17
 65c:	00000097          	auipc	ra,0x0
 660:	f5e080e7          	jalr	-162(ra) # 5ba <write>
}
 664:	60e2                	ld	ra,24(sp)
 666:	6442                	ld	s0,16(sp)
 668:	6105                	addi	sp,sp,32
 66a:	8082                	ret

000000000000066c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 66c:	7139                	addi	sp,sp,-64
 66e:	fc06                	sd	ra,56(sp)
 670:	f822                	sd	s0,48(sp)
 672:	f426                	sd	s1,40(sp)
 674:	f04a                	sd	s2,32(sp)
 676:	ec4e                	sd	s3,24(sp)
 678:	0080                	addi	s0,sp,64
 67a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 67c:	c299                	beqz	a3,682 <printint+0x16>
 67e:	0805c863          	bltz	a1,70e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 682:	2581                	sext.w	a1,a1
  neg = 0;
 684:	4881                	li	a7,0
 686:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 68a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 68c:	2601                	sext.w	a2,a2
 68e:	00000517          	auipc	a0,0x0
 692:	51250513          	addi	a0,a0,1298 # ba0 <digits>
 696:	883a                	mv	a6,a4
 698:	2705                	addiw	a4,a4,1
 69a:	02c5f7bb          	remuw	a5,a1,a2
 69e:	1782                	slli	a5,a5,0x20
 6a0:	9381                	srli	a5,a5,0x20
 6a2:	97aa                	add	a5,a5,a0
 6a4:	0007c783          	lbu	a5,0(a5) # 1000 <__BSS_END__+0x408>
 6a8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6ac:	0005879b          	sext.w	a5,a1
 6b0:	02c5d5bb          	divuw	a1,a1,a2
 6b4:	0685                	addi	a3,a3,1
 6b6:	fec7f0e3          	bgeu	a5,a2,696 <printint+0x2a>
  if(neg)
 6ba:	00088b63          	beqz	a7,6d0 <printint+0x64>
    buf[i++] = '-';
 6be:	fd040793          	addi	a5,s0,-48
 6c2:	973e                	add	a4,a4,a5
 6c4:	02d00793          	li	a5,45
 6c8:	fef70823          	sb	a5,-16(a4)
 6cc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6d0:	02e05863          	blez	a4,700 <printint+0x94>
 6d4:	fc040793          	addi	a5,s0,-64
 6d8:	00e78933          	add	s2,a5,a4
 6dc:	fff78993          	addi	s3,a5,-1
 6e0:	99ba                	add	s3,s3,a4
 6e2:	377d                	addiw	a4,a4,-1
 6e4:	1702                	slli	a4,a4,0x20
 6e6:	9301                	srli	a4,a4,0x20
 6e8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6ec:	fff94583          	lbu	a1,-1(s2)
 6f0:	8526                	mv	a0,s1
 6f2:	00000097          	auipc	ra,0x0
 6f6:	f58080e7          	jalr	-168(ra) # 64a <putc>
  while(--i >= 0)
 6fa:	197d                	addi	s2,s2,-1
 6fc:	ff3918e3          	bne	s2,s3,6ec <printint+0x80>
}
 700:	70e2                	ld	ra,56(sp)
 702:	7442                	ld	s0,48(sp)
 704:	74a2                	ld	s1,40(sp)
 706:	7902                	ld	s2,32(sp)
 708:	69e2                	ld	s3,24(sp)
 70a:	6121                	addi	sp,sp,64
 70c:	8082                	ret
    x = -xx;
 70e:	40b005bb          	negw	a1,a1
    neg = 1;
 712:	4885                	li	a7,1
    x = -xx;
 714:	bf8d                	j	686 <printint+0x1a>

0000000000000716 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 716:	7119                	addi	sp,sp,-128
 718:	fc86                	sd	ra,120(sp)
 71a:	f8a2                	sd	s0,112(sp)
 71c:	f4a6                	sd	s1,104(sp)
 71e:	f0ca                	sd	s2,96(sp)
 720:	ecce                	sd	s3,88(sp)
 722:	e8d2                	sd	s4,80(sp)
 724:	e4d6                	sd	s5,72(sp)
 726:	e0da                	sd	s6,64(sp)
 728:	fc5e                	sd	s7,56(sp)
 72a:	f862                	sd	s8,48(sp)
 72c:	f466                	sd	s9,40(sp)
 72e:	f06a                	sd	s10,32(sp)
 730:	ec6e                	sd	s11,24(sp)
 732:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 734:	0005c903          	lbu	s2,0(a1)
 738:	18090f63          	beqz	s2,8d6 <vprintf+0x1c0>
 73c:	8aaa                	mv	s5,a0
 73e:	8b32                	mv	s6,a2
 740:	00158493          	addi	s1,a1,1
  state = 0;
 744:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 746:	02500a13          	li	s4,37
      if(c == 'd'){
 74a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 74e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 752:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 756:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 75a:	00000b97          	auipc	s7,0x0
 75e:	446b8b93          	addi	s7,s7,1094 # ba0 <digits>
 762:	a839                	j	780 <vprintf+0x6a>
        putc(fd, c);
 764:	85ca                	mv	a1,s2
 766:	8556                	mv	a0,s5
 768:	00000097          	auipc	ra,0x0
 76c:	ee2080e7          	jalr	-286(ra) # 64a <putc>
 770:	a019                	j	776 <vprintf+0x60>
    } else if(state == '%'){
 772:	01498f63          	beq	s3,s4,790 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 776:	0485                	addi	s1,s1,1
 778:	fff4c903          	lbu	s2,-1(s1)
 77c:	14090d63          	beqz	s2,8d6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 780:	0009079b          	sext.w	a5,s2
    if(state == 0){
 784:	fe0997e3          	bnez	s3,772 <vprintf+0x5c>
      if(c == '%'){
 788:	fd479ee3          	bne	a5,s4,764 <vprintf+0x4e>
        state = '%';
 78c:	89be                	mv	s3,a5
 78e:	b7e5                	j	776 <vprintf+0x60>
      if(c == 'd'){
 790:	05878063          	beq	a5,s8,7d0 <vprintf+0xba>
      } else if(c == 'l') {
 794:	05978c63          	beq	a5,s9,7ec <vprintf+0xd6>
      } else if(c == 'x') {
 798:	07a78863          	beq	a5,s10,808 <vprintf+0xf2>
      } else if(c == 'p') {
 79c:	09b78463          	beq	a5,s11,824 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 7a0:	07300713          	li	a4,115
 7a4:	0ce78663          	beq	a5,a4,870 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7a8:	06300713          	li	a4,99
 7ac:	0ee78e63          	beq	a5,a4,8a8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 7b0:	11478863          	beq	a5,s4,8c0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7b4:	85d2                	mv	a1,s4
 7b6:	8556                	mv	a0,s5
 7b8:	00000097          	auipc	ra,0x0
 7bc:	e92080e7          	jalr	-366(ra) # 64a <putc>
        putc(fd, c);
 7c0:	85ca                	mv	a1,s2
 7c2:	8556                	mv	a0,s5
 7c4:	00000097          	auipc	ra,0x0
 7c8:	e86080e7          	jalr	-378(ra) # 64a <putc>
      }
      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	b765                	j	776 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7d0:	008b0913          	addi	s2,s6,8
 7d4:	4685                	li	a3,1
 7d6:	4629                	li	a2,10
 7d8:	000b2583          	lw	a1,0(s6)
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	e8e080e7          	jalr	-370(ra) # 66c <printint>
 7e6:	8b4a                	mv	s6,s2
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	b771                	j	776 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ec:	008b0913          	addi	s2,s6,8
 7f0:	4681                	li	a3,0
 7f2:	4629                	li	a2,10
 7f4:	000b2583          	lw	a1,0(s6)
 7f8:	8556                	mv	a0,s5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	e72080e7          	jalr	-398(ra) # 66c <printint>
 802:	8b4a                	mv	s6,s2
      state = 0;
 804:	4981                	li	s3,0
 806:	bf85                	j	776 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 808:	008b0913          	addi	s2,s6,8
 80c:	4681                	li	a3,0
 80e:	4641                	li	a2,16
 810:	000b2583          	lw	a1,0(s6)
 814:	8556                	mv	a0,s5
 816:	00000097          	auipc	ra,0x0
 81a:	e56080e7          	jalr	-426(ra) # 66c <printint>
 81e:	8b4a                	mv	s6,s2
      state = 0;
 820:	4981                	li	s3,0
 822:	bf91                	j	776 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 824:	008b0793          	addi	a5,s6,8
 828:	f8f43423          	sd	a5,-120(s0)
 82c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 830:	03000593          	li	a1,48
 834:	8556                	mv	a0,s5
 836:	00000097          	auipc	ra,0x0
 83a:	e14080e7          	jalr	-492(ra) # 64a <putc>
  putc(fd, 'x');
 83e:	85ea                	mv	a1,s10
 840:	8556                	mv	a0,s5
 842:	00000097          	auipc	ra,0x0
 846:	e08080e7          	jalr	-504(ra) # 64a <putc>
 84a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 84c:	03c9d793          	srli	a5,s3,0x3c
 850:	97de                	add	a5,a5,s7
 852:	0007c583          	lbu	a1,0(a5)
 856:	8556                	mv	a0,s5
 858:	00000097          	auipc	ra,0x0
 85c:	df2080e7          	jalr	-526(ra) # 64a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 860:	0992                	slli	s3,s3,0x4
 862:	397d                	addiw	s2,s2,-1
 864:	fe0914e3          	bnez	s2,84c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 868:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 86c:	4981                	li	s3,0
 86e:	b721                	j	776 <vprintf+0x60>
        s = va_arg(ap, char*);
 870:	008b0993          	addi	s3,s6,8
 874:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 878:	02090163          	beqz	s2,89a <vprintf+0x184>
        while(*s != 0){
 87c:	00094583          	lbu	a1,0(s2)
 880:	c9a1                	beqz	a1,8d0 <vprintf+0x1ba>
          putc(fd, *s);
 882:	8556                	mv	a0,s5
 884:	00000097          	auipc	ra,0x0
 888:	dc6080e7          	jalr	-570(ra) # 64a <putc>
          s++;
 88c:	0905                	addi	s2,s2,1
        while(*s != 0){
 88e:	00094583          	lbu	a1,0(s2)
 892:	f9e5                	bnez	a1,882 <vprintf+0x16c>
        s = va_arg(ap, char*);
 894:	8b4e                	mv	s6,s3
      state = 0;
 896:	4981                	li	s3,0
 898:	bdf9                	j	776 <vprintf+0x60>
          s = "(null)";
 89a:	00000917          	auipc	s2,0x0
 89e:	2f690913          	addi	s2,s2,758 # b90 <malloc+0x158>
        while(*s != 0){
 8a2:	02800593          	li	a1,40
 8a6:	bff1                	j	882 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 8a8:	008b0913          	addi	s2,s6,8
 8ac:	000b4583          	lbu	a1,0(s6)
 8b0:	8556                	mv	a0,s5
 8b2:	00000097          	auipc	ra,0x0
 8b6:	d98080e7          	jalr	-616(ra) # 64a <putc>
 8ba:	8b4a                	mv	s6,s2
      state = 0;
 8bc:	4981                	li	s3,0
 8be:	bd65                	j	776 <vprintf+0x60>
        putc(fd, c);
 8c0:	85d2                	mv	a1,s4
 8c2:	8556                	mv	a0,s5
 8c4:	00000097          	auipc	ra,0x0
 8c8:	d86080e7          	jalr	-634(ra) # 64a <putc>
      state = 0;
 8cc:	4981                	li	s3,0
 8ce:	b565                	j	776 <vprintf+0x60>
        s = va_arg(ap, char*);
 8d0:	8b4e                	mv	s6,s3
      state = 0;
 8d2:	4981                	li	s3,0
 8d4:	b54d                	j	776 <vprintf+0x60>
    }
  }
}
 8d6:	70e6                	ld	ra,120(sp)
 8d8:	7446                	ld	s0,112(sp)
 8da:	74a6                	ld	s1,104(sp)
 8dc:	7906                	ld	s2,96(sp)
 8de:	69e6                	ld	s3,88(sp)
 8e0:	6a46                	ld	s4,80(sp)
 8e2:	6aa6                	ld	s5,72(sp)
 8e4:	6b06                	ld	s6,64(sp)
 8e6:	7be2                	ld	s7,56(sp)
 8e8:	7c42                	ld	s8,48(sp)
 8ea:	7ca2                	ld	s9,40(sp)
 8ec:	7d02                	ld	s10,32(sp)
 8ee:	6de2                	ld	s11,24(sp)
 8f0:	6109                	addi	sp,sp,128
 8f2:	8082                	ret

00000000000008f4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8f4:	715d                	addi	sp,sp,-80
 8f6:	ec06                	sd	ra,24(sp)
 8f8:	e822                	sd	s0,16(sp)
 8fa:	1000                	addi	s0,sp,32
 8fc:	e010                	sd	a2,0(s0)
 8fe:	e414                	sd	a3,8(s0)
 900:	e818                	sd	a4,16(s0)
 902:	ec1c                	sd	a5,24(s0)
 904:	03043023          	sd	a6,32(s0)
 908:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 90c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 910:	8622                	mv	a2,s0
 912:	00000097          	auipc	ra,0x0
 916:	e04080e7          	jalr	-508(ra) # 716 <vprintf>
}
 91a:	60e2                	ld	ra,24(sp)
 91c:	6442                	ld	s0,16(sp)
 91e:	6161                	addi	sp,sp,80
 920:	8082                	ret

0000000000000922 <printf>:

void
printf(const char *fmt, ...)
{
 922:	7159                	addi	sp,sp,-112
 924:	f406                	sd	ra,40(sp)
 926:	f022                	sd	s0,32(sp)
 928:	ec26                	sd	s1,24(sp)
 92a:	e84a                	sd	s2,16(sp)
 92c:	1800                	addi	s0,sp,48
 92e:	84aa                	mv	s1,a0
 930:	e40c                	sd	a1,8(s0)
 932:	e810                	sd	a2,16(s0)
 934:	ec14                	sd	a3,24(s0)
 936:	f018                	sd	a4,32(s0)
 938:	f41c                	sd	a5,40(s0)
 93a:	03043823          	sd	a6,48(s0)
 93e:	03143c23          	sd	a7,56(s0)
  va_list ap;
  lock_acquire(&pr.printf_lock);
 942:	00000917          	auipc	s2,0x0
 946:	28e90913          	addi	s2,s2,654 # bd0 <pr>
 94a:	854a                	mv	a0,s2
 94c:	00000097          	auipc	ra,0x0
 950:	b88080e7          	jalr	-1144(ra) # 4d4 <lock_acquire>

  va_start(ap, fmt);
 954:	00840613          	addi	a2,s0,8
 958:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 95c:	85a6                	mv	a1,s1
 95e:	4505                	li	a0,1
 960:	00000097          	auipc	ra,0x0
 964:	db6080e7          	jalr	-586(ra) # 716 <vprintf>
  
  lock_release(&pr.printf_lock);
 968:	854a                	mv	a0,s2
 96a:	00000097          	auipc	ra,0x0
 96e:	b8a080e7          	jalr	-1142(ra) # 4f4 <lock_release>

}
 972:	70a2                	ld	ra,40(sp)
 974:	7402                	ld	s0,32(sp)
 976:	64e2                	ld	s1,24(sp)
 978:	6942                	ld	s2,16(sp)
 97a:	6165                	addi	sp,sp,112
 97c:	8082                	ret

000000000000097e <printfinit>:

void
printfinit(void)
{
 97e:	1101                	addi	sp,sp,-32
 980:	ec06                	sd	ra,24(sp)
 982:	e822                	sd	s0,16(sp)
 984:	e426                	sd	s1,8(sp)
 986:	1000                	addi	s0,sp,32
  lock_init(&pr.printf_lock, "pr");
 988:	00000497          	auipc	s1,0x0
 98c:	24848493          	addi	s1,s1,584 # bd0 <pr>
 990:	00000597          	auipc	a1,0x0
 994:	20858593          	addi	a1,a1,520 # b98 <malloc+0x160>
 998:	8526                	mv	a0,s1
 99a:	00000097          	auipc	ra,0x0
 99e:	b28080e7          	jalr	-1240(ra) # 4c2 <lock_init>
  pr.locking = 1;
 9a2:	4785                	li	a5,1
 9a4:	c89c                	sw	a5,16(s1)
}
 9a6:	60e2                	ld	ra,24(sp)
 9a8:	6442                	ld	s0,16(sp)
 9aa:	64a2                	ld	s1,8(sp)
 9ac:	6105                	addi	sp,sp,32
 9ae:	8082                	ret

00000000000009b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9b0:	1141                	addi	sp,sp,-16
 9b2:	e422                	sd	s0,8(sp)
 9b4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9b6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ba:	00000797          	auipc	a5,0x0
 9be:	1fe7b783          	ld	a5,510(a5) # bb8 <freep>
 9c2:	a805                	j	9f2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9c4:	4618                	lw	a4,8(a2)
 9c6:	9db9                	addw	a1,a1,a4
 9c8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9cc:	6398                	ld	a4,0(a5)
 9ce:	6318                	ld	a4,0(a4)
 9d0:	fee53823          	sd	a4,-16(a0)
 9d4:	a091                	j	a18 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9d6:	ff852703          	lw	a4,-8(a0)
 9da:	9e39                	addw	a2,a2,a4
 9dc:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 9de:	ff053703          	ld	a4,-16(a0)
 9e2:	e398                	sd	a4,0(a5)
 9e4:	a099                	j	a2a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9e6:	6398                	ld	a4,0(a5)
 9e8:	00e7e463          	bltu	a5,a4,9f0 <free+0x40>
 9ec:	00e6ea63          	bltu	a3,a4,a00 <free+0x50>
{
 9f0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f2:	fed7fae3          	bgeu	a5,a3,9e6 <free+0x36>
 9f6:	6398                	ld	a4,0(a5)
 9f8:	00e6e463          	bltu	a3,a4,a00 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9fc:	fee7eae3          	bltu	a5,a4,9f0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a00:	ff852583          	lw	a1,-8(a0)
 a04:	6390                	ld	a2,0(a5)
 a06:	02059713          	slli	a4,a1,0x20
 a0a:	9301                	srli	a4,a4,0x20
 a0c:	0712                	slli	a4,a4,0x4
 a0e:	9736                	add	a4,a4,a3
 a10:	fae60ae3          	beq	a2,a4,9c4 <free+0x14>
    bp->s.ptr = p->s.ptr;
 a14:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a18:	4790                	lw	a2,8(a5)
 a1a:	02061713          	slli	a4,a2,0x20
 a1e:	9301                	srli	a4,a4,0x20
 a20:	0712                	slli	a4,a4,0x4
 a22:	973e                	add	a4,a4,a5
 a24:	fae689e3          	beq	a3,a4,9d6 <free+0x26>
  } else
    p->s.ptr = bp;
 a28:	e394                	sd	a3,0(a5)
  freep = p;
 a2a:	00000717          	auipc	a4,0x0
 a2e:	18f73723          	sd	a5,398(a4) # bb8 <freep>
}
 a32:	6422                	ld	s0,8(sp)
 a34:	0141                	addi	sp,sp,16
 a36:	8082                	ret

0000000000000a38 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a38:	7139                	addi	sp,sp,-64
 a3a:	fc06                	sd	ra,56(sp)
 a3c:	f822                	sd	s0,48(sp)
 a3e:	f426                	sd	s1,40(sp)
 a40:	f04a                	sd	s2,32(sp)
 a42:	ec4e                	sd	s3,24(sp)
 a44:	e852                	sd	s4,16(sp)
 a46:	e456                	sd	s5,8(sp)
 a48:	e05a                	sd	s6,0(sp)
 a4a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a4c:	02051493          	slli	s1,a0,0x20
 a50:	9081                	srli	s1,s1,0x20
 a52:	04bd                	addi	s1,s1,15
 a54:	8091                	srli	s1,s1,0x4
 a56:	0014899b          	addiw	s3,s1,1
 a5a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a5c:	00000517          	auipc	a0,0x0
 a60:	15c53503          	ld	a0,348(a0) # bb8 <freep>
 a64:	c515                	beqz	a0,a90 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a66:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a68:	4798                	lw	a4,8(a5)
 a6a:	02977f63          	bgeu	a4,s1,aa8 <malloc+0x70>
 a6e:	8a4e                	mv	s4,s3
 a70:	0009871b          	sext.w	a4,s3
 a74:	6685                	lui	a3,0x1
 a76:	00d77363          	bgeu	a4,a3,a7c <malloc+0x44>
 a7a:	6a05                	lui	s4,0x1
 a7c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a80:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a84:	00000917          	auipc	s2,0x0
 a88:	13490913          	addi	s2,s2,308 # bb8 <freep>
  if(p == (char*)-1)
 a8c:	5afd                	li	s5,-1
 a8e:	a88d                	j	b00 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a90:	00000797          	auipc	a5,0x0
 a94:	15878793          	addi	a5,a5,344 # be8 <base>
 a98:	00000717          	auipc	a4,0x0
 a9c:	12f73023          	sd	a5,288(a4) # bb8 <freep>
 aa0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 aa2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 aa6:	b7e1                	j	a6e <malloc+0x36>
      if(p->s.size == nunits)
 aa8:	02e48b63          	beq	s1,a4,ade <malloc+0xa6>
        p->s.size -= nunits;
 aac:	4137073b          	subw	a4,a4,s3
 ab0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ab2:	1702                	slli	a4,a4,0x20
 ab4:	9301                	srli	a4,a4,0x20
 ab6:	0712                	slli	a4,a4,0x4
 ab8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aba:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 abe:	00000717          	auipc	a4,0x0
 ac2:	0ea73d23          	sd	a0,250(a4) # bb8 <freep>
      return (void*)(p + 1);
 ac6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 aca:	70e2                	ld	ra,56(sp)
 acc:	7442                	ld	s0,48(sp)
 ace:	74a2                	ld	s1,40(sp)
 ad0:	7902                	ld	s2,32(sp)
 ad2:	69e2                	ld	s3,24(sp)
 ad4:	6a42                	ld	s4,16(sp)
 ad6:	6aa2                	ld	s5,8(sp)
 ad8:	6b02                	ld	s6,0(sp)
 ada:	6121                	addi	sp,sp,64
 adc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 ade:	6398                	ld	a4,0(a5)
 ae0:	e118                	sd	a4,0(a0)
 ae2:	bff1                	j	abe <malloc+0x86>
  hp->s.size = nu;
 ae4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ae8:	0541                	addi	a0,a0,16
 aea:	00000097          	auipc	ra,0x0
 aee:	ec6080e7          	jalr	-314(ra) # 9b0 <free>
  return freep;
 af2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 af6:	d971                	beqz	a0,aca <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 af8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 afa:	4798                	lw	a4,8(a5)
 afc:	fa9776e3          	bgeu	a4,s1,aa8 <malloc+0x70>
    if(p == freep)
 b00:	00093703          	ld	a4,0(s2)
 b04:	853e                	mv	a0,a5
 b06:	fef719e3          	bne	a4,a5,af8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b0a:	8552                	mv	a0,s4
 b0c:	00000097          	auipc	ra,0x0
 b10:	b16080e7          	jalr	-1258(ra) # 622 <sbrk>
  if(p == (char*)-1)
 b14:	fd5518e3          	bne	a0,s5,ae4 <malloc+0xac>
        return 0;
 b18:	4501                	li	a0,0
 b1a:	bf45                	j	aca <malloc+0x92>
