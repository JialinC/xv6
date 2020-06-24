
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
  6a:	a3a98993          	addi	s3,s3,-1478 # aa0 <buf.1108>
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
  de:	430080e7          	jalr	1072(ra) # 50a <open>
  e2:	06054f63          	bltz	a0,160 <ls+0xac>
  e6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  e8:	d9840593          	addi	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	436080e7          	jalr	1078(ra) # 522 <fstat>
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
 128:	91450513          	addi	a0,a0,-1772 # a38 <malloc+0x118>
 12c:	00000097          	auipc	ra,0x0
 130:	736080e7          	jalr	1846(ra) # 862 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 134:	8526                	mv	a0,s1
 136:	00000097          	auipc	ra,0x0
 13a:	3bc080e7          	jalr	956(ra) # 4f2 <close>
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
 166:	8a658593          	addi	a1,a1,-1882 # a08 <malloc+0xe8>
 16a:	4509                	li	a0,2
 16c:	00000097          	auipc	ra,0x0
 170:	6c8080e7          	jalr	1736(ra) # 834 <fprintf>
    return;
 174:	b7e9                	j	13e <ls+0x8a>
    fprintf(2, "ls: cannot stat %s\n", path);
 176:	864a                	mv	a2,s2
 178:	00001597          	auipc	a1,0x1
 17c:	8a858593          	addi	a1,a1,-1880 # a20 <malloc+0x100>
 180:	4509                	li	a0,2
 182:	00000097          	auipc	ra,0x0
 186:	6b2080e7          	jalr	1714(ra) # 834 <fprintf>
    close(fd);
 18a:	8526                	mv	a0,s1
 18c:	00000097          	auipc	ra,0x0
 190:	366080e7          	jalr	870(ra) # 4f2 <close>
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
 1ae:	89e50513          	addi	a0,a0,-1890 # a48 <malloc+0x128>
 1b2:	00000097          	auipc	ra,0x0
 1b6:	6b0080e7          	jalr	1712(ra) # 862 <printf>
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
 1f4:	870a0a13          	addi	s4,s4,-1936 # a60 <malloc+0x140>
        printf("ls: cannot stat %s\n", buf);
 1f8:	00001a97          	auipc	s5,0x1
 1fc:	828a8a93          	addi	s5,s5,-2008 # a20 <malloc+0x100>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 200:	a801                	j	210 <ls+0x15c>
        printf("ls: cannot stat %s\n", buf);
 202:	dc040593          	addi	a1,s0,-576
 206:	8556                	mv	a0,s5
 208:	00000097          	auipc	ra,0x0
 20c:	65a080e7          	jalr	1626(ra) # 862 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 210:	4641                	li	a2,16
 212:	db040593          	addi	a1,s0,-592
 216:	8526                	mv	a0,s1
 218:	00000097          	auipc	ra,0x0
 21c:	2ca080e7          	jalr	714(ra) # 4e2 <read>
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
 274:	5f2080e7          	jalr	1522(ra) # 862 <printf>
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
 2b6:	218080e7          	jalr	536(ra) # 4ca <exit>
    ls(".");
 2ba:	00000517          	auipc	a0,0x0
 2be:	7b650513          	addi	a0,a0,1974 # a70 <malloc+0x150>
 2c2:	00000097          	auipc	ra,0x0
 2c6:	df2080e7          	jalr	-526(ra) # b4 <ls>
    exit(0);
 2ca:	4501                	li	a0,0
 2cc:	00000097          	auipc	ra,0x0
 2d0:	1fe080e7          	jalr	510(ra) # 4ca <exit>

00000000000002d4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

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
 3c6:	120080e7          	jalr	288(ra) # 4e2 <read>
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
 418:	0f6080e7          	jalr	246(ra) # 50a <open>
  if(fd < 0)
 41c:	02054563          	bltz	a0,446 <stat+0x42>
 420:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 422:	85ca                	mv	a1,s2
 424:	00000097          	auipc	ra,0x0
 428:	0fe080e7          	jalr	254(ra) # 522 <fstat>
 42c:	892a                	mv	s2,a0
  close(fd);
 42e:	8526                	mv	a0,s1
 430:	00000097          	auipc	ra,0x0
 434:	0c2080e7          	jalr	194(ra) # 4f2 <close>
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

00000000000004c2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4c2:	4885                	li	a7,1
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <exit>:
.global exit
exit:
 li a7, SYS_exit
 4ca:	4889                	li	a7,2
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4d2:	488d                	li	a7,3
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4da:	4891                	li	a7,4
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <read>:
.global read
read:
 li a7, SYS_read
 4e2:	4895                	li	a7,5
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <write>:
.global write
write:
 li a7, SYS_write
 4ea:	48c1                	li	a7,16
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <close>:
.global close
close:
 li a7, SYS_close
 4f2:	48d5                	li	a7,21
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <kill>:
.global kill
kill:
 li a7, SYS_kill
 4fa:	4899                	li	a7,6
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <exec>:
.global exec
exec:
 li a7, SYS_exec
 502:	489d                	li	a7,7
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <open>:
.global open
open:
 li a7, SYS_open
 50a:	48bd                	li	a7,15
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 512:	48c5                	li	a7,17
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 51a:	48c9                	li	a7,18
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 522:	48a1                	li	a7,8
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <link>:
.global link
link:
 li a7, SYS_link
 52a:	48cd                	li	a7,19
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 532:	48d1                	li	a7,20
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 53a:	48a5                	li	a7,9
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <dup>:
.global dup
dup:
 li a7, SYS_dup
 542:	48a9                	li	a7,10
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 54a:	48ad                	li	a7,11
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 552:	48b1                	li	a7,12
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 55a:	48b5                	li	a7,13
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 562:	48b9                	li	a7,14
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 56a:	48d9                	li	a7,22
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <crash>:
.global crash
crash:
 li a7, SYS_crash
 572:	48dd                	li	a7,23
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <mount>:
.global mount
mount:
 li a7, SYS_mount
 57a:	48e1                	li	a7,24
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <umount>:
.global umount
umount:
 li a7, SYS_umount
 582:	48e5                	li	a7,25
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 58a:	1101                	addi	sp,sp,-32
 58c:	ec06                	sd	ra,24(sp)
 58e:	e822                	sd	s0,16(sp)
 590:	1000                	addi	s0,sp,32
 592:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 596:	4605                	li	a2,1
 598:	fef40593          	addi	a1,s0,-17
 59c:	00000097          	auipc	ra,0x0
 5a0:	f4e080e7          	jalr	-178(ra) # 4ea <write>
}
 5a4:	60e2                	ld	ra,24(sp)
 5a6:	6442                	ld	s0,16(sp)
 5a8:	6105                	addi	sp,sp,32
 5aa:	8082                	ret

00000000000005ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ac:	7139                	addi	sp,sp,-64
 5ae:	fc06                	sd	ra,56(sp)
 5b0:	f822                	sd	s0,48(sp)
 5b2:	f426                	sd	s1,40(sp)
 5b4:	f04a                	sd	s2,32(sp)
 5b6:	ec4e                	sd	s3,24(sp)
 5b8:	0080                	addi	s0,sp,64
 5ba:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5bc:	c299                	beqz	a3,5c2 <printint+0x16>
 5be:	0805c863          	bltz	a1,64e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5c2:	2581                	sext.w	a1,a1
  neg = 0;
 5c4:	4881                	li	a7,0
 5c6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5ca:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5cc:	2601                	sext.w	a2,a2
 5ce:	00000517          	auipc	a0,0x0
 5d2:	4b250513          	addi	a0,a0,1202 # a80 <digits>
 5d6:	883a                	mv	a6,a4
 5d8:	2705                	addiw	a4,a4,1
 5da:	02c5f7bb          	remuw	a5,a1,a2
 5de:	1782                	slli	a5,a5,0x20
 5e0:	9381                	srli	a5,a5,0x20
 5e2:	97aa                	add	a5,a5,a0
 5e4:	0007c783          	lbu	a5,0(a5)
 5e8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5ec:	0005879b          	sext.w	a5,a1
 5f0:	02c5d5bb          	divuw	a1,a1,a2
 5f4:	0685                	addi	a3,a3,1
 5f6:	fec7f0e3          	bgeu	a5,a2,5d6 <printint+0x2a>
  if(neg)
 5fa:	00088b63          	beqz	a7,610 <printint+0x64>
    buf[i++] = '-';
 5fe:	fd040793          	addi	a5,s0,-48
 602:	973e                	add	a4,a4,a5
 604:	02d00793          	li	a5,45
 608:	fef70823          	sb	a5,-16(a4)
 60c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 610:	02e05863          	blez	a4,640 <printint+0x94>
 614:	fc040793          	addi	a5,s0,-64
 618:	00e78933          	add	s2,a5,a4
 61c:	fff78993          	addi	s3,a5,-1
 620:	99ba                	add	s3,s3,a4
 622:	377d                	addiw	a4,a4,-1
 624:	1702                	slli	a4,a4,0x20
 626:	9301                	srli	a4,a4,0x20
 628:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 62c:	fff94583          	lbu	a1,-1(s2)
 630:	8526                	mv	a0,s1
 632:	00000097          	auipc	ra,0x0
 636:	f58080e7          	jalr	-168(ra) # 58a <putc>
  while(--i >= 0)
 63a:	197d                	addi	s2,s2,-1
 63c:	ff3918e3          	bne	s2,s3,62c <printint+0x80>
}
 640:	70e2                	ld	ra,56(sp)
 642:	7442                	ld	s0,48(sp)
 644:	74a2                	ld	s1,40(sp)
 646:	7902                	ld	s2,32(sp)
 648:	69e2                	ld	s3,24(sp)
 64a:	6121                	addi	sp,sp,64
 64c:	8082                	ret
    x = -xx;
 64e:	40b005bb          	negw	a1,a1
    neg = 1;
 652:	4885                	li	a7,1
    x = -xx;
 654:	bf8d                	j	5c6 <printint+0x1a>

0000000000000656 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 656:	7119                	addi	sp,sp,-128
 658:	fc86                	sd	ra,120(sp)
 65a:	f8a2                	sd	s0,112(sp)
 65c:	f4a6                	sd	s1,104(sp)
 65e:	f0ca                	sd	s2,96(sp)
 660:	ecce                	sd	s3,88(sp)
 662:	e8d2                	sd	s4,80(sp)
 664:	e4d6                	sd	s5,72(sp)
 666:	e0da                	sd	s6,64(sp)
 668:	fc5e                	sd	s7,56(sp)
 66a:	f862                	sd	s8,48(sp)
 66c:	f466                	sd	s9,40(sp)
 66e:	f06a                	sd	s10,32(sp)
 670:	ec6e                	sd	s11,24(sp)
 672:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 674:	0005c903          	lbu	s2,0(a1)
 678:	18090f63          	beqz	s2,816 <vprintf+0x1c0>
 67c:	8aaa                	mv	s5,a0
 67e:	8b32                	mv	s6,a2
 680:	00158493          	addi	s1,a1,1
  state = 0;
 684:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 686:	02500a13          	li	s4,37
      if(c == 'd'){
 68a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 68e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 692:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 696:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 69a:	00000b97          	auipc	s7,0x0
 69e:	3e6b8b93          	addi	s7,s7,998 # a80 <digits>
 6a2:	a839                	j	6c0 <vprintf+0x6a>
        putc(fd, c);
 6a4:	85ca                	mv	a1,s2
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	ee2080e7          	jalr	-286(ra) # 58a <putc>
 6b0:	a019                	j	6b6 <vprintf+0x60>
    } else if(state == '%'){
 6b2:	01498f63          	beq	s3,s4,6d0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6b6:	0485                	addi	s1,s1,1
 6b8:	fff4c903          	lbu	s2,-1(s1)
 6bc:	14090d63          	beqz	s2,816 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6c0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6c4:	fe0997e3          	bnez	s3,6b2 <vprintf+0x5c>
      if(c == '%'){
 6c8:	fd479ee3          	bne	a5,s4,6a4 <vprintf+0x4e>
        state = '%';
 6cc:	89be                	mv	s3,a5
 6ce:	b7e5                	j	6b6 <vprintf+0x60>
      if(c == 'd'){
 6d0:	05878063          	beq	a5,s8,710 <vprintf+0xba>
      } else if(c == 'l') {
 6d4:	05978c63          	beq	a5,s9,72c <vprintf+0xd6>
      } else if(c == 'x') {
 6d8:	07a78863          	beq	a5,s10,748 <vprintf+0xf2>
      } else if(c == 'p') {
 6dc:	09b78463          	beq	a5,s11,764 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6e0:	07300713          	li	a4,115
 6e4:	0ce78663          	beq	a5,a4,7b0 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6e8:	06300713          	li	a4,99
 6ec:	0ee78e63          	beq	a5,a4,7e8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6f0:	11478863          	beq	a5,s4,800 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6f4:	85d2                	mv	a1,s4
 6f6:	8556                	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	e92080e7          	jalr	-366(ra) # 58a <putc>
        putc(fd, c);
 700:	85ca                	mv	a1,s2
 702:	8556                	mv	a0,s5
 704:	00000097          	auipc	ra,0x0
 708:	e86080e7          	jalr	-378(ra) # 58a <putc>
      }
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b765                	j	6b6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 710:	008b0913          	addi	s2,s6,8
 714:	4685                	li	a3,1
 716:	4629                	li	a2,10
 718:	000b2583          	lw	a1,0(s6)
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	e8e080e7          	jalr	-370(ra) # 5ac <printint>
 726:	8b4a                	mv	s6,s2
      state = 0;
 728:	4981                	li	s3,0
 72a:	b771                	j	6b6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 72c:	008b0913          	addi	s2,s6,8
 730:	4681                	li	a3,0
 732:	4629                	li	a2,10
 734:	000b2583          	lw	a1,0(s6)
 738:	8556                	mv	a0,s5
 73a:	00000097          	auipc	ra,0x0
 73e:	e72080e7          	jalr	-398(ra) # 5ac <printint>
 742:	8b4a                	mv	s6,s2
      state = 0;
 744:	4981                	li	s3,0
 746:	bf85                	j	6b6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 748:	008b0913          	addi	s2,s6,8
 74c:	4681                	li	a3,0
 74e:	4641                	li	a2,16
 750:	000b2583          	lw	a1,0(s6)
 754:	8556                	mv	a0,s5
 756:	00000097          	auipc	ra,0x0
 75a:	e56080e7          	jalr	-426(ra) # 5ac <printint>
 75e:	8b4a                	mv	s6,s2
      state = 0;
 760:	4981                	li	s3,0
 762:	bf91                	j	6b6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 764:	008b0793          	addi	a5,s6,8
 768:	f8f43423          	sd	a5,-120(s0)
 76c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 770:	03000593          	li	a1,48
 774:	8556                	mv	a0,s5
 776:	00000097          	auipc	ra,0x0
 77a:	e14080e7          	jalr	-492(ra) # 58a <putc>
  putc(fd, 'x');
 77e:	85ea                	mv	a1,s10
 780:	8556                	mv	a0,s5
 782:	00000097          	auipc	ra,0x0
 786:	e08080e7          	jalr	-504(ra) # 58a <putc>
 78a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 78c:	03c9d793          	srli	a5,s3,0x3c
 790:	97de                	add	a5,a5,s7
 792:	0007c583          	lbu	a1,0(a5)
 796:	8556                	mv	a0,s5
 798:	00000097          	auipc	ra,0x0
 79c:	df2080e7          	jalr	-526(ra) # 58a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a0:	0992                	slli	s3,s3,0x4
 7a2:	397d                	addiw	s2,s2,-1
 7a4:	fe0914e3          	bnez	s2,78c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7a8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	b721                	j	6b6 <vprintf+0x60>
        s = va_arg(ap, char*);
 7b0:	008b0993          	addi	s3,s6,8
 7b4:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7b8:	02090163          	beqz	s2,7da <vprintf+0x184>
        while(*s != 0){
 7bc:	00094583          	lbu	a1,0(s2)
 7c0:	c9a1                	beqz	a1,810 <vprintf+0x1ba>
          putc(fd, *s);
 7c2:	8556                	mv	a0,s5
 7c4:	00000097          	auipc	ra,0x0
 7c8:	dc6080e7          	jalr	-570(ra) # 58a <putc>
          s++;
 7cc:	0905                	addi	s2,s2,1
        while(*s != 0){
 7ce:	00094583          	lbu	a1,0(s2)
 7d2:	f9e5                	bnez	a1,7c2 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7d4:	8b4e                	mv	s6,s3
      state = 0;
 7d6:	4981                	li	s3,0
 7d8:	bdf9                	j	6b6 <vprintf+0x60>
          s = "(null)";
 7da:	00000917          	auipc	s2,0x0
 7de:	29e90913          	addi	s2,s2,670 # a78 <malloc+0x158>
        while(*s != 0){
 7e2:	02800593          	li	a1,40
 7e6:	bff1                	j	7c2 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7e8:	008b0913          	addi	s2,s6,8
 7ec:	000b4583          	lbu	a1,0(s6)
 7f0:	8556                	mv	a0,s5
 7f2:	00000097          	auipc	ra,0x0
 7f6:	d98080e7          	jalr	-616(ra) # 58a <putc>
 7fa:	8b4a                	mv	s6,s2
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	bd65                	j	6b6 <vprintf+0x60>
        putc(fd, c);
 800:	85d2                	mv	a1,s4
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	d86080e7          	jalr	-634(ra) # 58a <putc>
      state = 0;
 80c:	4981                	li	s3,0
 80e:	b565                	j	6b6 <vprintf+0x60>
        s = va_arg(ap, char*);
 810:	8b4e                	mv	s6,s3
      state = 0;
 812:	4981                	li	s3,0
 814:	b54d                	j	6b6 <vprintf+0x60>
    }
  }
}
 816:	70e6                	ld	ra,120(sp)
 818:	7446                	ld	s0,112(sp)
 81a:	74a6                	ld	s1,104(sp)
 81c:	7906                	ld	s2,96(sp)
 81e:	69e6                	ld	s3,88(sp)
 820:	6a46                	ld	s4,80(sp)
 822:	6aa6                	ld	s5,72(sp)
 824:	6b06                	ld	s6,64(sp)
 826:	7be2                	ld	s7,56(sp)
 828:	7c42                	ld	s8,48(sp)
 82a:	7ca2                	ld	s9,40(sp)
 82c:	7d02                	ld	s10,32(sp)
 82e:	6de2                	ld	s11,24(sp)
 830:	6109                	addi	sp,sp,128
 832:	8082                	ret

0000000000000834 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 834:	715d                	addi	sp,sp,-80
 836:	ec06                	sd	ra,24(sp)
 838:	e822                	sd	s0,16(sp)
 83a:	1000                	addi	s0,sp,32
 83c:	e010                	sd	a2,0(s0)
 83e:	e414                	sd	a3,8(s0)
 840:	e818                	sd	a4,16(s0)
 842:	ec1c                	sd	a5,24(s0)
 844:	03043023          	sd	a6,32(s0)
 848:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 84c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 850:	8622                	mv	a2,s0
 852:	00000097          	auipc	ra,0x0
 856:	e04080e7          	jalr	-508(ra) # 656 <vprintf>
}
 85a:	60e2                	ld	ra,24(sp)
 85c:	6442                	ld	s0,16(sp)
 85e:	6161                	addi	sp,sp,80
 860:	8082                	ret

0000000000000862 <printf>:

void
printf(const char *fmt, ...)
{
 862:	711d                	addi	sp,sp,-96
 864:	ec06                	sd	ra,24(sp)
 866:	e822                	sd	s0,16(sp)
 868:	1000                	addi	s0,sp,32
 86a:	e40c                	sd	a1,8(s0)
 86c:	e810                	sd	a2,16(s0)
 86e:	ec14                	sd	a3,24(s0)
 870:	f018                	sd	a4,32(s0)
 872:	f41c                	sd	a5,40(s0)
 874:	03043823          	sd	a6,48(s0)
 878:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 87c:	00840613          	addi	a2,s0,8
 880:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 884:	85aa                	mv	a1,a0
 886:	4505                	li	a0,1
 888:	00000097          	auipc	ra,0x0
 88c:	dce080e7          	jalr	-562(ra) # 656 <vprintf>
}
 890:	60e2                	ld	ra,24(sp)
 892:	6442                	ld	s0,16(sp)
 894:	6125                	addi	sp,sp,96
 896:	8082                	ret

0000000000000898 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 898:	1141                	addi	sp,sp,-16
 89a:	e422                	sd	s0,8(sp)
 89c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 89e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a2:	00000797          	auipc	a5,0x0
 8a6:	1f67b783          	ld	a5,502(a5) # a98 <freep>
 8aa:	a805                	j	8da <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8ac:	4618                	lw	a4,8(a2)
 8ae:	9db9                	addw	a1,a1,a4
 8b0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b4:	6398                	ld	a4,0(a5)
 8b6:	6318                	ld	a4,0(a4)
 8b8:	fee53823          	sd	a4,-16(a0)
 8bc:	a091                	j	900 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8be:	ff852703          	lw	a4,-8(a0)
 8c2:	9e39                	addw	a2,a2,a4
 8c4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8c6:	ff053703          	ld	a4,-16(a0)
 8ca:	e398                	sd	a4,0(a5)
 8cc:	a099                	j	912 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ce:	6398                	ld	a4,0(a5)
 8d0:	00e7e463          	bltu	a5,a4,8d8 <free+0x40>
 8d4:	00e6ea63          	bltu	a3,a4,8e8 <free+0x50>
{
 8d8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8da:	fed7fae3          	bgeu	a5,a3,8ce <free+0x36>
 8de:	6398                	ld	a4,0(a5)
 8e0:	00e6e463          	bltu	a3,a4,8e8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e4:	fee7eae3          	bltu	a5,a4,8d8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8e8:	ff852583          	lw	a1,-8(a0)
 8ec:	6390                	ld	a2,0(a5)
 8ee:	02059713          	slli	a4,a1,0x20
 8f2:	9301                	srli	a4,a4,0x20
 8f4:	0712                	slli	a4,a4,0x4
 8f6:	9736                	add	a4,a4,a3
 8f8:	fae60ae3          	beq	a2,a4,8ac <free+0x14>
    bp->s.ptr = p->s.ptr;
 8fc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 900:	4790                	lw	a2,8(a5)
 902:	02061713          	slli	a4,a2,0x20
 906:	9301                	srli	a4,a4,0x20
 908:	0712                	slli	a4,a4,0x4
 90a:	973e                	add	a4,a4,a5
 90c:	fae689e3          	beq	a3,a4,8be <free+0x26>
  } else
    p->s.ptr = bp;
 910:	e394                	sd	a3,0(a5)
  freep = p;
 912:	00000717          	auipc	a4,0x0
 916:	18f73323          	sd	a5,390(a4) # a98 <freep>
}
 91a:	6422                	ld	s0,8(sp)
 91c:	0141                	addi	sp,sp,16
 91e:	8082                	ret

0000000000000920 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 920:	7139                	addi	sp,sp,-64
 922:	fc06                	sd	ra,56(sp)
 924:	f822                	sd	s0,48(sp)
 926:	f426                	sd	s1,40(sp)
 928:	f04a                	sd	s2,32(sp)
 92a:	ec4e                	sd	s3,24(sp)
 92c:	e852                	sd	s4,16(sp)
 92e:	e456                	sd	s5,8(sp)
 930:	e05a                	sd	s6,0(sp)
 932:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 934:	02051493          	slli	s1,a0,0x20
 938:	9081                	srli	s1,s1,0x20
 93a:	04bd                	addi	s1,s1,15
 93c:	8091                	srli	s1,s1,0x4
 93e:	0014899b          	addiw	s3,s1,1
 942:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 944:	00000517          	auipc	a0,0x0
 948:	15453503          	ld	a0,340(a0) # a98 <freep>
 94c:	c515                	beqz	a0,978 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 950:	4798                	lw	a4,8(a5)
 952:	02977f63          	bgeu	a4,s1,990 <malloc+0x70>
 956:	8a4e                	mv	s4,s3
 958:	0009871b          	sext.w	a4,s3
 95c:	6685                	lui	a3,0x1
 95e:	00d77363          	bgeu	a4,a3,964 <malloc+0x44>
 962:	6a05                	lui	s4,0x1
 964:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 968:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 96c:	00000917          	auipc	s2,0x0
 970:	12c90913          	addi	s2,s2,300 # a98 <freep>
  if(p == (char*)-1)
 974:	5afd                	li	s5,-1
 976:	a88d                	j	9e8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 978:	00000797          	auipc	a5,0x0
 97c:	13878793          	addi	a5,a5,312 # ab0 <base>
 980:	00000717          	auipc	a4,0x0
 984:	10f73c23          	sd	a5,280(a4) # a98 <freep>
 988:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 98a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 98e:	b7e1                	j	956 <malloc+0x36>
      if(p->s.size == nunits)
 990:	02e48b63          	beq	s1,a4,9c6 <malloc+0xa6>
        p->s.size -= nunits;
 994:	4137073b          	subw	a4,a4,s3
 998:	c798                	sw	a4,8(a5)
        p += p->s.size;
 99a:	1702                	slli	a4,a4,0x20
 99c:	9301                	srli	a4,a4,0x20
 99e:	0712                	slli	a4,a4,0x4
 9a0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9a2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9a6:	00000717          	auipc	a4,0x0
 9aa:	0ea73923          	sd	a0,242(a4) # a98 <freep>
      return (void*)(p + 1);
 9ae:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9b2:	70e2                	ld	ra,56(sp)
 9b4:	7442                	ld	s0,48(sp)
 9b6:	74a2                	ld	s1,40(sp)
 9b8:	7902                	ld	s2,32(sp)
 9ba:	69e2                	ld	s3,24(sp)
 9bc:	6a42                	ld	s4,16(sp)
 9be:	6aa2                	ld	s5,8(sp)
 9c0:	6b02                	ld	s6,0(sp)
 9c2:	6121                	addi	sp,sp,64
 9c4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9c6:	6398                	ld	a4,0(a5)
 9c8:	e118                	sd	a4,0(a0)
 9ca:	bff1                	j	9a6 <malloc+0x86>
  hp->s.size = nu;
 9cc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9d0:	0541                	addi	a0,a0,16
 9d2:	00000097          	auipc	ra,0x0
 9d6:	ec6080e7          	jalr	-314(ra) # 898 <free>
  return freep;
 9da:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9de:	d971                	beqz	a0,9b2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e2:	4798                	lw	a4,8(a5)
 9e4:	fa9776e3          	bgeu	a4,s1,990 <malloc+0x70>
    if(p == freep)
 9e8:	00093703          	ld	a4,0(s2)
 9ec:	853e                	mv	a0,a5
 9ee:	fef719e3          	bne	a4,a5,9e0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9f2:	8552                	mv	a0,s4
 9f4:	00000097          	auipc	ra,0x0
 9f8:	b5e080e7          	jalr	-1186(ra) # 552 <sbrk>
  if(p == (char*)-1)
 9fc:	fd5518e3          	bne	a0,s5,9cc <malloc+0xac>
        return 0;
 a00:	4501                	li	a0,0
 a02:	bf45                	j	9b2 <malloc+0x92>
