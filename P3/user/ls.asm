
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
    1000:	7179                	addi	sp,sp,-48
    1002:	f406                	sd	ra,40(sp)
    1004:	f022                	sd	s0,32(sp)
    1006:	ec26                	sd	s1,24(sp)
    1008:	e84a                	sd	s2,16(sp)
    100a:	e44e                	sd	s3,8(sp)
    100c:	1800                	addi	s0,sp,48
    100e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    1010:	00000097          	auipc	ra,0x0
    1014:	30c080e7          	jalr	780(ra) # 131c <strlen>
    1018:	02051793          	slli	a5,a0,0x20
    101c:	9381                	srli	a5,a5,0x20
    101e:	97a6                	add	a5,a5,s1
    1020:	02f00693          	li	a3,47
    1024:	0097e963          	bltu	a5,s1,1036 <fmtname+0x36>
    1028:	0007c703          	lbu	a4,0(a5)
    102c:	00d70563          	beq	a4,a3,1036 <fmtname+0x36>
    1030:	17fd                	addi	a5,a5,-1
    1032:	fe97fbe3          	bgeu	a5,s1,1028 <fmtname+0x28>
    ;
  p++;
    1036:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    103a:	8526                	mv	a0,s1
    103c:	00000097          	auipc	ra,0x0
    1040:	2e0080e7          	jalr	736(ra) # 131c <strlen>
    1044:	2501                	sext.w	a0,a0
    1046:	47b5                	li	a5,13
    1048:	00a7fa63          	bgeu	a5,a0,105c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
    104c:	8526                	mv	a0,s1
    104e:	70a2                	ld	ra,40(sp)
    1050:	7402                	ld	s0,32(sp)
    1052:	64e2                	ld	s1,24(sp)
    1054:	6942                	ld	s2,16(sp)
    1056:	69a2                	ld	s3,8(sp)
    1058:	6145                	addi	sp,sp,48
    105a:	8082                	ret
  memmove(buf, p, strlen(p));
    105c:	8526                	mv	a0,s1
    105e:	00000097          	auipc	ra,0x0
    1062:	2be080e7          	jalr	702(ra) # 131c <strlen>
    1066:	00001997          	auipc	s3,0x1
    106a:	a2a98993          	addi	s3,s3,-1494 # 1a90 <buf.1106>
    106e:	0005061b          	sext.w	a2,a0
    1072:	85a6                	mv	a1,s1
    1074:	854e                	mv	a0,s3
    1076:	00000097          	auipc	ra,0x0
    107a:	41e080e7          	jalr	1054(ra) # 1494 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
    107e:	8526                	mv	a0,s1
    1080:	00000097          	auipc	ra,0x0
    1084:	29c080e7          	jalr	668(ra) # 131c <strlen>
    1088:	0005091b          	sext.w	s2,a0
    108c:	8526                	mv	a0,s1
    108e:	00000097          	auipc	ra,0x0
    1092:	28e080e7          	jalr	654(ra) # 131c <strlen>
    1096:	1902                	slli	s2,s2,0x20
    1098:	02095913          	srli	s2,s2,0x20
    109c:	4639                	li	a2,14
    109e:	9e09                	subw	a2,a2,a0
    10a0:	02000593          	li	a1,32
    10a4:	01298533          	add	a0,s3,s2
    10a8:	00000097          	auipc	ra,0x0
    10ac:	29e080e7          	jalr	670(ra) # 1346 <memset>
  return buf;
    10b0:	84ce                	mv	s1,s3
    10b2:	bf69                	j	104c <fmtname+0x4c>

00000000000010b4 <ls>:

void
ls(char *path)
{
    10b4:	d9010113          	addi	sp,sp,-624
    10b8:	26113423          	sd	ra,616(sp)
    10bc:	26813023          	sd	s0,608(sp)
    10c0:	24913c23          	sd	s1,600(sp)
    10c4:	25213823          	sd	s2,592(sp)
    10c8:	25313423          	sd	s3,584(sp)
    10cc:	25413023          	sd	s4,576(sp)
    10d0:	23513c23          	sd	s5,568(sp)
    10d4:	1c80                	addi	s0,sp,624
    10d6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    10d8:	4581                	li	a1,0
    10da:	00000097          	auipc	ra,0x0
    10de:	430080e7          	jalr	1072(ra) # 150a <open>
    10e2:	06054f63          	bltz	a0,1160 <ls+0xac>
    10e6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    10e8:	d9840593          	addi	a1,s0,-616
    10ec:	00000097          	auipc	ra,0x0
    10f0:	436080e7          	jalr	1078(ra) # 1522 <fstat>
    10f4:	08054163          	bltz	a0,1176 <ls+0xc2>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
    10f8:	da041783          	lh	a5,-608(s0)
    10fc:	0007869b          	sext.w	a3,a5
    1100:	4705                	li	a4,1
    1102:	08e68a63          	beq	a3,a4,1196 <ls+0xe2>
    1106:	4709                	li	a4,2
    1108:	02e69663          	bne	a3,a4,1134 <ls+0x80>
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
    110c:	854a                	mv	a0,s2
    110e:	00000097          	auipc	ra,0x0
    1112:	ef2080e7          	jalr	-270(ra) # 1000 <fmtname>
    1116:	85aa                	mv	a1,a0
    1118:	da843703          	ld	a4,-600(s0)
    111c:	d9c42683          	lw	a3,-612(s0)
    1120:	da041603          	lh	a2,-608(s0)
    1124:	00001517          	auipc	a0,0x1
    1128:	90450513          	addi	a0,a0,-1788 # 1a28 <malloc+0x118>
    112c:	00000097          	auipc	ra,0x0
    1130:	726080e7          	jalr	1830(ra) # 1852 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
    1134:	8526                	mv	a0,s1
    1136:	00000097          	auipc	ra,0x0
    113a:	3bc080e7          	jalr	956(ra) # 14f2 <close>
}
    113e:	26813083          	ld	ra,616(sp)
    1142:	26013403          	ld	s0,608(sp)
    1146:	25813483          	ld	s1,600(sp)
    114a:	25013903          	ld	s2,592(sp)
    114e:	24813983          	ld	s3,584(sp)
    1152:	24013a03          	ld	s4,576(sp)
    1156:	23813a83          	ld	s5,568(sp)
    115a:	27010113          	addi	sp,sp,624
    115e:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
    1160:	864a                	mv	a2,s2
    1162:	00001597          	auipc	a1,0x1
    1166:	89658593          	addi	a1,a1,-1898 # 19f8 <malloc+0xe8>
    116a:	4509                	li	a0,2
    116c:	00000097          	auipc	ra,0x0
    1170:	6b8080e7          	jalr	1720(ra) # 1824 <fprintf>
    return;
    1174:	b7e9                	j	113e <ls+0x8a>
    fprintf(2, "ls: cannot stat %s\n", path);
    1176:	864a                	mv	a2,s2
    1178:	00001597          	auipc	a1,0x1
    117c:	89858593          	addi	a1,a1,-1896 # 1a10 <malloc+0x100>
    1180:	4509                	li	a0,2
    1182:	00000097          	auipc	ra,0x0
    1186:	6a2080e7          	jalr	1698(ra) # 1824 <fprintf>
    close(fd);
    118a:	8526                	mv	a0,s1
    118c:	00000097          	auipc	ra,0x0
    1190:	366080e7          	jalr	870(ra) # 14f2 <close>
    return;
    1194:	b76d                	j	113e <ls+0x8a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
    1196:	854a                	mv	a0,s2
    1198:	00000097          	auipc	ra,0x0
    119c:	184080e7          	jalr	388(ra) # 131c <strlen>
    11a0:	2541                	addiw	a0,a0,16
    11a2:	20000793          	li	a5,512
    11a6:	00a7fb63          	bgeu	a5,a0,11bc <ls+0x108>
      printf("ls: path too long\n");
    11aa:	00001517          	auipc	a0,0x1
    11ae:	88e50513          	addi	a0,a0,-1906 # 1a38 <malloc+0x128>
    11b2:	00000097          	auipc	ra,0x0
    11b6:	6a0080e7          	jalr	1696(ra) # 1852 <printf>
      break;
    11ba:	bfad                	j	1134 <ls+0x80>
    strcpy(buf, path);
    11bc:	85ca                	mv	a1,s2
    11be:	dc040513          	addi	a0,s0,-576
    11c2:	00000097          	auipc	ra,0x0
    11c6:	112080e7          	jalr	274(ra) # 12d4 <strcpy>
    p = buf+strlen(buf);
    11ca:	dc040513          	addi	a0,s0,-576
    11ce:	00000097          	auipc	ra,0x0
    11d2:	14e080e7          	jalr	334(ra) # 131c <strlen>
    11d6:	02051913          	slli	s2,a0,0x20
    11da:	02095913          	srli	s2,s2,0x20
    11de:	dc040793          	addi	a5,s0,-576
    11e2:	993e                	add	s2,s2,a5
    *p++ = '/';
    11e4:	00190993          	addi	s3,s2,1
    11e8:	02f00793          	li	a5,47
    11ec:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    11f0:	00001a17          	auipc	s4,0x1
    11f4:	860a0a13          	addi	s4,s4,-1952 # 1a50 <malloc+0x140>
        printf("ls: cannot stat %s\n", buf);
    11f8:	00001a97          	auipc	s5,0x1
    11fc:	818a8a93          	addi	s5,s5,-2024 # 1a10 <malloc+0x100>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    1200:	a801                	j	1210 <ls+0x15c>
        printf("ls: cannot stat %s\n", buf);
    1202:	dc040593          	addi	a1,s0,-576
    1206:	8556                	mv	a0,s5
    1208:	00000097          	auipc	ra,0x0
    120c:	64a080e7          	jalr	1610(ra) # 1852 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    1210:	4641                	li	a2,16
    1212:	db040593          	addi	a1,s0,-592
    1216:	8526                	mv	a0,s1
    1218:	00000097          	auipc	ra,0x0
    121c:	2ca080e7          	jalr	714(ra) # 14e2 <read>
    1220:	47c1                	li	a5,16
    1222:	f0f519e3          	bne	a0,a5,1134 <ls+0x80>
      if(de.inum == 0)
    1226:	db045783          	lhu	a5,-592(s0)
    122a:	d3fd                	beqz	a5,1210 <ls+0x15c>
      memmove(p, de.name, DIRSIZ);
    122c:	4639                	li	a2,14
    122e:	db240593          	addi	a1,s0,-590
    1232:	854e                	mv	a0,s3
    1234:	00000097          	auipc	ra,0x0
    1238:	260080e7          	jalr	608(ra) # 1494 <memmove>
      p[DIRSIZ] = 0;
    123c:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
    1240:	d9840593          	addi	a1,s0,-616
    1244:	dc040513          	addi	a0,s0,-576
    1248:	00000097          	auipc	ra,0x0
    124c:	1bc080e7          	jalr	444(ra) # 1404 <stat>
    1250:	fa0549e3          	bltz	a0,1202 <ls+0x14e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    1254:	dc040513          	addi	a0,s0,-576
    1258:	00000097          	auipc	ra,0x0
    125c:	da8080e7          	jalr	-600(ra) # 1000 <fmtname>
    1260:	85aa                	mv	a1,a0
    1262:	da843703          	ld	a4,-600(s0)
    1266:	d9c42683          	lw	a3,-612(s0)
    126a:	da041603          	lh	a2,-608(s0)
    126e:	8552                	mv	a0,s4
    1270:	00000097          	auipc	ra,0x0
    1274:	5e2080e7          	jalr	1506(ra) # 1852 <printf>
    1278:	bf61                	j	1210 <ls+0x15c>

000000000000127a <main>:

int
main(int argc, char *argv[])
{
    127a:	1101                	addi	sp,sp,-32
    127c:	ec06                	sd	ra,24(sp)
    127e:	e822                	sd	s0,16(sp)
    1280:	e426                	sd	s1,8(sp)
    1282:	e04a                	sd	s2,0(sp)
    1284:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
    1286:	4785                	li	a5,1
    1288:	02a7d963          	bge	a5,a0,12ba <main+0x40>
    128c:	00858493          	addi	s1,a1,8
    1290:	ffe5091b          	addiw	s2,a0,-2
    1294:	1902                	slli	s2,s2,0x20
    1296:	02095913          	srli	s2,s2,0x20
    129a:	090e                	slli	s2,s2,0x3
    129c:	05c1                	addi	a1,a1,16
    129e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
    12a0:	6088                	ld	a0,0(s1)
    12a2:	00000097          	auipc	ra,0x0
    12a6:	e12080e7          	jalr	-494(ra) # 10b4 <ls>
  for(i=1; i<argc; i++)
    12aa:	04a1                	addi	s1,s1,8
    12ac:	ff249ae3          	bne	s1,s2,12a0 <main+0x26>
  exit(0);
    12b0:	4501                	li	a0,0
    12b2:	00000097          	auipc	ra,0x0
    12b6:	218080e7          	jalr	536(ra) # 14ca <exit>
    ls(".");
    12ba:	00000517          	auipc	a0,0x0
    12be:	7a650513          	addi	a0,a0,1958 # 1a60 <malloc+0x150>
    12c2:	00000097          	auipc	ra,0x0
    12c6:	df2080e7          	jalr	-526(ra) # 10b4 <ls>
    exit(0);
    12ca:	4501                	li	a0,0
    12cc:	00000097          	auipc	ra,0x0
    12d0:	1fe080e7          	jalr	510(ra) # 14ca <exit>

00000000000012d4 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
    12d4:	1141                	addi	sp,sp,-16
    12d6:	e422                	sd	s0,8(sp)
    12d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    12da:	87aa                	mv	a5,a0
    12dc:	0585                	addi	a1,a1,1
    12de:	0785                	addi	a5,a5,1
    12e0:	fff5c703          	lbu	a4,-1(a1)
    12e4:	fee78fa3          	sb	a4,-1(a5)
    12e8:	fb75                	bnez	a4,12dc <strcpy+0x8>
    ;
  return os;
}
    12ea:	6422                	ld	s0,8(sp)
    12ec:	0141                	addi	sp,sp,16
    12ee:	8082                	ret

00000000000012f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    12f0:	1141                	addi	sp,sp,-16
    12f2:	e422                	sd	s0,8(sp)
    12f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    12f6:	00054783          	lbu	a5,0(a0)
    12fa:	cb91                	beqz	a5,130e <strcmp+0x1e>
    12fc:	0005c703          	lbu	a4,0(a1)
    1300:	00f71763          	bne	a4,a5,130e <strcmp+0x1e>
    p++, q++;
    1304:	0505                	addi	a0,a0,1
    1306:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    1308:	00054783          	lbu	a5,0(a0)
    130c:	fbe5                	bnez	a5,12fc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    130e:	0005c503          	lbu	a0,0(a1)
}
    1312:	40a7853b          	subw	a0,a5,a0
    1316:	6422                	ld	s0,8(sp)
    1318:	0141                	addi	sp,sp,16
    131a:	8082                	ret

000000000000131c <strlen>:

uint
strlen(const char *s)
{
    131c:	1141                	addi	sp,sp,-16
    131e:	e422                	sd	s0,8(sp)
    1320:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    1322:	00054783          	lbu	a5,0(a0)
    1326:	cf91                	beqz	a5,1342 <strlen+0x26>
    1328:	0505                	addi	a0,a0,1
    132a:	87aa                	mv	a5,a0
    132c:	4685                	li	a3,1
    132e:	9e89                	subw	a3,a3,a0
    1330:	00f6853b          	addw	a0,a3,a5
    1334:	0785                	addi	a5,a5,1
    1336:	fff7c703          	lbu	a4,-1(a5)
    133a:	fb7d                	bnez	a4,1330 <strlen+0x14>
    ;
  return n;
}
    133c:	6422                	ld	s0,8(sp)
    133e:	0141                	addi	sp,sp,16
    1340:	8082                	ret
  for(n = 0; s[n]; n++)
    1342:	4501                	li	a0,0
    1344:	bfe5                	j	133c <strlen+0x20>

0000000000001346 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1346:	1141                	addi	sp,sp,-16
    1348:	e422                	sd	s0,8(sp)
    134a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    134c:	ce09                	beqz	a2,1366 <memset+0x20>
    134e:	87aa                	mv	a5,a0
    1350:	fff6071b          	addiw	a4,a2,-1
    1354:	1702                	slli	a4,a4,0x20
    1356:	9301                	srli	a4,a4,0x20
    1358:	0705                	addi	a4,a4,1
    135a:	972a                	add	a4,a4,a0
    cdst[i] = c;
    135c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    1360:	0785                	addi	a5,a5,1
    1362:	fee79de3          	bne	a5,a4,135c <memset+0x16>
  }
  return dst;
}
    1366:	6422                	ld	s0,8(sp)
    1368:	0141                	addi	sp,sp,16
    136a:	8082                	ret

000000000000136c <strchr>:

char*
strchr(const char *s, char c)
{
    136c:	1141                	addi	sp,sp,-16
    136e:	e422                	sd	s0,8(sp)
    1370:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1372:	00054783          	lbu	a5,0(a0)
    1376:	cb99                	beqz	a5,138c <strchr+0x20>
    if(*s == c)
    1378:	00f58763          	beq	a1,a5,1386 <strchr+0x1a>
  for(; *s; s++)
    137c:	0505                	addi	a0,a0,1
    137e:	00054783          	lbu	a5,0(a0)
    1382:	fbfd                	bnez	a5,1378 <strchr+0xc>
      return (char*)s;
  return 0;
    1384:	4501                	li	a0,0
}
    1386:	6422                	ld	s0,8(sp)
    1388:	0141                	addi	sp,sp,16
    138a:	8082                	ret
  return 0;
    138c:	4501                	li	a0,0
    138e:	bfe5                	j	1386 <strchr+0x1a>

0000000000001390 <gets>:

char*
gets(char *buf, int max)
{
    1390:	711d                	addi	sp,sp,-96
    1392:	ec86                	sd	ra,88(sp)
    1394:	e8a2                	sd	s0,80(sp)
    1396:	e4a6                	sd	s1,72(sp)
    1398:	e0ca                	sd	s2,64(sp)
    139a:	fc4e                	sd	s3,56(sp)
    139c:	f852                	sd	s4,48(sp)
    139e:	f456                	sd	s5,40(sp)
    13a0:	f05a                	sd	s6,32(sp)
    13a2:	ec5e                	sd	s7,24(sp)
    13a4:	1080                	addi	s0,sp,96
    13a6:	8baa                	mv	s7,a0
    13a8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    13aa:	892a                	mv	s2,a0
    13ac:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    13ae:	4aa9                	li	s5,10
    13b0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    13b2:	89a6                	mv	s3,s1
    13b4:	2485                	addiw	s1,s1,1
    13b6:	0344d863          	bge	s1,s4,13e6 <gets+0x56>
    cc = read(0, &c, 1);
    13ba:	4605                	li	a2,1
    13bc:	faf40593          	addi	a1,s0,-81
    13c0:	4501                	li	a0,0
    13c2:	00000097          	auipc	ra,0x0
    13c6:	120080e7          	jalr	288(ra) # 14e2 <read>
    if(cc < 1)
    13ca:	00a05e63          	blez	a0,13e6 <gets+0x56>
    buf[i++] = c;
    13ce:	faf44783          	lbu	a5,-81(s0)
    13d2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    13d6:	01578763          	beq	a5,s5,13e4 <gets+0x54>
    13da:	0905                	addi	s2,s2,1
    13dc:	fd679be3          	bne	a5,s6,13b2 <gets+0x22>
  for(i=0; i+1 < max; ){
    13e0:	89a6                	mv	s3,s1
    13e2:	a011                	j	13e6 <gets+0x56>
    13e4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    13e6:	99de                	add	s3,s3,s7
    13e8:	00098023          	sb	zero,0(s3)
  return buf;
}
    13ec:	855e                	mv	a0,s7
    13ee:	60e6                	ld	ra,88(sp)
    13f0:	6446                	ld	s0,80(sp)
    13f2:	64a6                	ld	s1,72(sp)
    13f4:	6906                	ld	s2,64(sp)
    13f6:	79e2                	ld	s3,56(sp)
    13f8:	7a42                	ld	s4,48(sp)
    13fa:	7aa2                	ld	s5,40(sp)
    13fc:	7b02                	ld	s6,32(sp)
    13fe:	6be2                	ld	s7,24(sp)
    1400:	6125                	addi	sp,sp,96
    1402:	8082                	ret

0000000000001404 <stat>:

int
stat(const char *n, struct stat *st)
{
    1404:	1101                	addi	sp,sp,-32
    1406:	ec06                	sd	ra,24(sp)
    1408:	e822                	sd	s0,16(sp)
    140a:	e426                	sd	s1,8(sp)
    140c:	e04a                	sd	s2,0(sp)
    140e:	1000                	addi	s0,sp,32
    1410:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1412:	4581                	li	a1,0
    1414:	00000097          	auipc	ra,0x0
    1418:	0f6080e7          	jalr	246(ra) # 150a <open>
  if(fd < 0)
    141c:	02054563          	bltz	a0,1446 <stat+0x42>
    1420:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    1422:	85ca                	mv	a1,s2
    1424:	00000097          	auipc	ra,0x0
    1428:	0fe080e7          	jalr	254(ra) # 1522 <fstat>
    142c:	892a                	mv	s2,a0
  close(fd);
    142e:	8526                	mv	a0,s1
    1430:	00000097          	auipc	ra,0x0
    1434:	0c2080e7          	jalr	194(ra) # 14f2 <close>
  return r;
}
    1438:	854a                	mv	a0,s2
    143a:	60e2                	ld	ra,24(sp)
    143c:	6442                	ld	s0,16(sp)
    143e:	64a2                	ld	s1,8(sp)
    1440:	6902                	ld	s2,0(sp)
    1442:	6105                	addi	sp,sp,32
    1444:	8082                	ret
    return -1;
    1446:	597d                	li	s2,-1
    1448:	bfc5                	j	1438 <stat+0x34>

000000000000144a <atoi>:

int
atoi(const char *s)
{
    144a:	1141                	addi	sp,sp,-16
    144c:	e422                	sd	s0,8(sp)
    144e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1450:	00054603          	lbu	a2,0(a0)
    1454:	fd06079b          	addiw	a5,a2,-48
    1458:	0ff7f793          	andi	a5,a5,255
    145c:	4725                	li	a4,9
    145e:	02f76963          	bltu	a4,a5,1490 <atoi+0x46>
    1462:	86aa                	mv	a3,a0
  n = 0;
    1464:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    1466:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    1468:	0685                	addi	a3,a3,1
    146a:	0025179b          	slliw	a5,a0,0x2
    146e:	9fa9                	addw	a5,a5,a0
    1470:	0017979b          	slliw	a5,a5,0x1
    1474:	9fb1                	addw	a5,a5,a2
    1476:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    147a:	0006c603          	lbu	a2,0(a3)
    147e:	fd06071b          	addiw	a4,a2,-48
    1482:	0ff77713          	andi	a4,a4,255
    1486:	fee5f1e3          	bgeu	a1,a4,1468 <atoi+0x1e>
  return n;
}
    148a:	6422                	ld	s0,8(sp)
    148c:	0141                	addi	sp,sp,16
    148e:	8082                	ret
  n = 0;
    1490:	4501                	li	a0,0
    1492:	bfe5                	j	148a <atoi+0x40>

0000000000001494 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1494:	1141                	addi	sp,sp,-16
    1496:	e422                	sd	s0,8(sp)
    1498:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    149a:	02c05163          	blez	a2,14bc <memmove+0x28>
    149e:	fff6071b          	addiw	a4,a2,-1
    14a2:	1702                	slli	a4,a4,0x20
    14a4:	9301                	srli	a4,a4,0x20
    14a6:	0705                	addi	a4,a4,1
    14a8:	972a                	add	a4,a4,a0
  dst = vdst;
    14aa:	87aa                	mv	a5,a0
    *dst++ = *src++;
    14ac:	0585                	addi	a1,a1,1
    14ae:	0785                	addi	a5,a5,1
    14b0:	fff5c683          	lbu	a3,-1(a1)
    14b4:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    14b8:	fee79ae3          	bne	a5,a4,14ac <memmove+0x18>
  return vdst;
}
    14bc:	6422                	ld	s0,8(sp)
    14be:	0141                	addi	sp,sp,16
    14c0:	8082                	ret

00000000000014c2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    14c2:	4885                	li	a7,1
 ecall
    14c4:	00000073          	ecall
 ret
    14c8:	8082                	ret

00000000000014ca <exit>:
.global exit
exit:
 li a7, SYS_exit
    14ca:	4889                	li	a7,2
 ecall
    14cc:	00000073          	ecall
 ret
    14d0:	8082                	ret

00000000000014d2 <wait>:
.global wait
wait:
 li a7, SYS_wait
    14d2:	488d                	li	a7,3
 ecall
    14d4:	00000073          	ecall
 ret
    14d8:	8082                	ret

00000000000014da <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    14da:	4891                	li	a7,4
 ecall
    14dc:	00000073          	ecall
 ret
    14e0:	8082                	ret

00000000000014e2 <read>:
.global read
read:
 li a7, SYS_read
    14e2:	4895                	li	a7,5
 ecall
    14e4:	00000073          	ecall
 ret
    14e8:	8082                	ret

00000000000014ea <write>:
.global write
write:
 li a7, SYS_write
    14ea:	48c1                	li	a7,16
 ecall
    14ec:	00000073          	ecall
 ret
    14f0:	8082                	ret

00000000000014f2 <close>:
.global close
close:
 li a7, SYS_close
    14f2:	48d5                	li	a7,21
 ecall
    14f4:	00000073          	ecall
 ret
    14f8:	8082                	ret

00000000000014fa <kill>:
.global kill
kill:
 li a7, SYS_kill
    14fa:	4899                	li	a7,6
 ecall
    14fc:	00000073          	ecall
 ret
    1500:	8082                	ret

0000000000001502 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1502:	489d                	li	a7,7
 ecall
    1504:	00000073          	ecall
 ret
    1508:	8082                	ret

000000000000150a <open>:
.global open
open:
 li a7, SYS_open
    150a:	48bd                	li	a7,15
 ecall
    150c:	00000073          	ecall
 ret
    1510:	8082                	ret

0000000000001512 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1512:	48c5                	li	a7,17
 ecall
    1514:	00000073          	ecall
 ret
    1518:	8082                	ret

000000000000151a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    151a:	48c9                	li	a7,18
 ecall
    151c:	00000073          	ecall
 ret
    1520:	8082                	ret

0000000000001522 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1522:	48a1                	li	a7,8
 ecall
    1524:	00000073          	ecall
 ret
    1528:	8082                	ret

000000000000152a <link>:
.global link
link:
 li a7, SYS_link
    152a:	48cd                	li	a7,19
 ecall
    152c:	00000073          	ecall
 ret
    1530:	8082                	ret

0000000000001532 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1532:	48d1                	li	a7,20
 ecall
    1534:	00000073          	ecall
 ret
    1538:	8082                	ret

000000000000153a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    153a:	48a5                	li	a7,9
 ecall
    153c:	00000073          	ecall
 ret
    1540:	8082                	ret

0000000000001542 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1542:	48a9                	li	a7,10
 ecall
    1544:	00000073          	ecall
 ret
    1548:	8082                	ret

000000000000154a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    154a:	48ad                	li	a7,11
 ecall
    154c:	00000073          	ecall
 ret
    1550:	8082                	ret

0000000000001552 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1552:	48b1                	li	a7,12
 ecall
    1554:	00000073          	ecall
 ret
    1558:	8082                	ret

000000000000155a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    155a:	48b5                	li	a7,13
 ecall
    155c:	00000073          	ecall
 ret
    1560:	8082                	ret

0000000000001562 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1562:	48b9                	li	a7,14
 ecall
    1564:	00000073          	ecall
 ret
    1568:	8082                	ret

000000000000156a <mprotect>:
.global mprotect
mprotect:
 li a7, SYS_mprotect
    156a:	48d9                	li	a7,22
 ecall
    156c:	00000073          	ecall
 ret
    1570:	8082                	ret

0000000000001572 <munprotect>:
.global munprotect
munprotect:
 li a7, SYS_munprotect
    1572:	48dd                	li	a7,23
 ecall
    1574:	00000073          	ecall
 ret
    1578:	8082                	ret

000000000000157a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    157a:	1101                	addi	sp,sp,-32
    157c:	ec06                	sd	ra,24(sp)
    157e:	e822                	sd	s0,16(sp)
    1580:	1000                	addi	s0,sp,32
    1582:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1586:	4605                	li	a2,1
    1588:	fef40593          	addi	a1,s0,-17
    158c:	00000097          	auipc	ra,0x0
    1590:	f5e080e7          	jalr	-162(ra) # 14ea <write>
}
    1594:	60e2                	ld	ra,24(sp)
    1596:	6442                	ld	s0,16(sp)
    1598:	6105                	addi	sp,sp,32
    159a:	8082                	ret

000000000000159c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    159c:	7139                	addi	sp,sp,-64
    159e:	fc06                	sd	ra,56(sp)
    15a0:	f822                	sd	s0,48(sp)
    15a2:	f426                	sd	s1,40(sp)
    15a4:	f04a                	sd	s2,32(sp)
    15a6:	ec4e                	sd	s3,24(sp)
    15a8:	0080                	addi	s0,sp,64
    15aa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    15ac:	c299                	beqz	a3,15b2 <printint+0x16>
    15ae:	0805c863          	bltz	a1,163e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    15b2:	2581                	sext.w	a1,a1
  neg = 0;
    15b4:	4881                	li	a7,0
    15b6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    15ba:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    15bc:	2601                	sext.w	a2,a2
    15be:	00000517          	auipc	a0,0x0
    15c2:	4b250513          	addi	a0,a0,1202 # 1a70 <digits>
    15c6:	883a                	mv	a6,a4
    15c8:	2705                	addiw	a4,a4,1
    15ca:	02c5f7bb          	remuw	a5,a1,a2
    15ce:	1782                	slli	a5,a5,0x20
    15d0:	9381                	srli	a5,a5,0x20
    15d2:	97aa                	add	a5,a5,a0
    15d4:	0007c783          	lbu	a5,0(a5)
    15d8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    15dc:	0005879b          	sext.w	a5,a1
    15e0:	02c5d5bb          	divuw	a1,a1,a2
    15e4:	0685                	addi	a3,a3,1
    15e6:	fec7f0e3          	bgeu	a5,a2,15c6 <printint+0x2a>
  if(neg)
    15ea:	00088b63          	beqz	a7,1600 <printint+0x64>
    buf[i++] = '-';
    15ee:	fd040793          	addi	a5,s0,-48
    15f2:	973e                	add	a4,a4,a5
    15f4:	02d00793          	li	a5,45
    15f8:	fef70823          	sb	a5,-16(a4)
    15fc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1600:	02e05863          	blez	a4,1630 <printint+0x94>
    1604:	fc040793          	addi	a5,s0,-64
    1608:	00e78933          	add	s2,a5,a4
    160c:	fff78993          	addi	s3,a5,-1
    1610:	99ba                	add	s3,s3,a4
    1612:	377d                	addiw	a4,a4,-1
    1614:	1702                	slli	a4,a4,0x20
    1616:	9301                	srli	a4,a4,0x20
    1618:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    161c:	fff94583          	lbu	a1,-1(s2)
    1620:	8526                	mv	a0,s1
    1622:	00000097          	auipc	ra,0x0
    1626:	f58080e7          	jalr	-168(ra) # 157a <putc>
  while(--i >= 0)
    162a:	197d                	addi	s2,s2,-1
    162c:	ff3918e3          	bne	s2,s3,161c <printint+0x80>
}
    1630:	70e2                	ld	ra,56(sp)
    1632:	7442                	ld	s0,48(sp)
    1634:	74a2                	ld	s1,40(sp)
    1636:	7902                	ld	s2,32(sp)
    1638:	69e2                	ld	s3,24(sp)
    163a:	6121                	addi	sp,sp,64
    163c:	8082                	ret
    x = -xx;
    163e:	40b005bb          	negw	a1,a1
    neg = 1;
    1642:	4885                	li	a7,1
    x = -xx;
    1644:	bf8d                	j	15b6 <printint+0x1a>

0000000000001646 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1646:	7119                	addi	sp,sp,-128
    1648:	fc86                	sd	ra,120(sp)
    164a:	f8a2                	sd	s0,112(sp)
    164c:	f4a6                	sd	s1,104(sp)
    164e:	f0ca                	sd	s2,96(sp)
    1650:	ecce                	sd	s3,88(sp)
    1652:	e8d2                	sd	s4,80(sp)
    1654:	e4d6                	sd	s5,72(sp)
    1656:	e0da                	sd	s6,64(sp)
    1658:	fc5e                	sd	s7,56(sp)
    165a:	f862                	sd	s8,48(sp)
    165c:	f466                	sd	s9,40(sp)
    165e:	f06a                	sd	s10,32(sp)
    1660:	ec6e                	sd	s11,24(sp)
    1662:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1664:	0005c903          	lbu	s2,0(a1)
    1668:	18090f63          	beqz	s2,1806 <vprintf+0x1c0>
    166c:	8aaa                	mv	s5,a0
    166e:	8b32                	mv	s6,a2
    1670:	00158493          	addi	s1,a1,1
  state = 0;
    1674:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1676:	02500a13          	li	s4,37
      if(c == 'd'){
    167a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    167e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    1682:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    1686:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    168a:	00000b97          	auipc	s7,0x0
    168e:	3e6b8b93          	addi	s7,s7,998 # 1a70 <digits>
    1692:	a839                	j	16b0 <vprintf+0x6a>
        putc(fd, c);
    1694:	85ca                	mv	a1,s2
    1696:	8556                	mv	a0,s5
    1698:	00000097          	auipc	ra,0x0
    169c:	ee2080e7          	jalr	-286(ra) # 157a <putc>
    16a0:	a019                	j	16a6 <vprintf+0x60>
    } else if(state == '%'){
    16a2:	01498f63          	beq	s3,s4,16c0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    16a6:	0485                	addi	s1,s1,1
    16a8:	fff4c903          	lbu	s2,-1(s1)
    16ac:	14090d63          	beqz	s2,1806 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    16b0:	0009079b          	sext.w	a5,s2
    if(state == 0){
    16b4:	fe0997e3          	bnez	s3,16a2 <vprintf+0x5c>
      if(c == '%'){
    16b8:	fd479ee3          	bne	a5,s4,1694 <vprintf+0x4e>
        state = '%';
    16bc:	89be                	mv	s3,a5
    16be:	b7e5                	j	16a6 <vprintf+0x60>
      if(c == 'd'){
    16c0:	05878063          	beq	a5,s8,1700 <vprintf+0xba>
      } else if(c == 'l') {
    16c4:	05978c63          	beq	a5,s9,171c <vprintf+0xd6>
      } else if(c == 'x') {
    16c8:	07a78863          	beq	a5,s10,1738 <vprintf+0xf2>
      } else if(c == 'p') {
    16cc:	09b78463          	beq	a5,s11,1754 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    16d0:	07300713          	li	a4,115
    16d4:	0ce78663          	beq	a5,a4,17a0 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    16d8:	06300713          	li	a4,99
    16dc:	0ee78e63          	beq	a5,a4,17d8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    16e0:	11478863          	beq	a5,s4,17f0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    16e4:	85d2                	mv	a1,s4
    16e6:	8556                	mv	a0,s5
    16e8:	00000097          	auipc	ra,0x0
    16ec:	e92080e7          	jalr	-366(ra) # 157a <putc>
        putc(fd, c);
    16f0:	85ca                	mv	a1,s2
    16f2:	8556                	mv	a0,s5
    16f4:	00000097          	auipc	ra,0x0
    16f8:	e86080e7          	jalr	-378(ra) # 157a <putc>
      }
      state = 0;
    16fc:	4981                	li	s3,0
    16fe:	b765                	j	16a6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    1700:	008b0913          	addi	s2,s6,8
    1704:	4685                	li	a3,1
    1706:	4629                	li	a2,10
    1708:	000b2583          	lw	a1,0(s6)
    170c:	8556                	mv	a0,s5
    170e:	00000097          	auipc	ra,0x0
    1712:	e8e080e7          	jalr	-370(ra) # 159c <printint>
    1716:	8b4a                	mv	s6,s2
      state = 0;
    1718:	4981                	li	s3,0
    171a:	b771                	j	16a6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    171c:	008b0913          	addi	s2,s6,8
    1720:	4681                	li	a3,0
    1722:	4629                	li	a2,10
    1724:	000b2583          	lw	a1,0(s6)
    1728:	8556                	mv	a0,s5
    172a:	00000097          	auipc	ra,0x0
    172e:	e72080e7          	jalr	-398(ra) # 159c <printint>
    1732:	8b4a                	mv	s6,s2
      state = 0;
    1734:	4981                	li	s3,0
    1736:	bf85                	j	16a6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1738:	008b0913          	addi	s2,s6,8
    173c:	4681                	li	a3,0
    173e:	4641                	li	a2,16
    1740:	000b2583          	lw	a1,0(s6)
    1744:	8556                	mv	a0,s5
    1746:	00000097          	auipc	ra,0x0
    174a:	e56080e7          	jalr	-426(ra) # 159c <printint>
    174e:	8b4a                	mv	s6,s2
      state = 0;
    1750:	4981                	li	s3,0
    1752:	bf91                	j	16a6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1754:	008b0793          	addi	a5,s6,8
    1758:	f8f43423          	sd	a5,-120(s0)
    175c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1760:	03000593          	li	a1,48
    1764:	8556                	mv	a0,s5
    1766:	00000097          	auipc	ra,0x0
    176a:	e14080e7          	jalr	-492(ra) # 157a <putc>
  putc(fd, 'x');
    176e:	85ea                	mv	a1,s10
    1770:	8556                	mv	a0,s5
    1772:	00000097          	auipc	ra,0x0
    1776:	e08080e7          	jalr	-504(ra) # 157a <putc>
    177a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    177c:	03c9d793          	srli	a5,s3,0x3c
    1780:	97de                	add	a5,a5,s7
    1782:	0007c583          	lbu	a1,0(a5)
    1786:	8556                	mv	a0,s5
    1788:	00000097          	auipc	ra,0x0
    178c:	df2080e7          	jalr	-526(ra) # 157a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1790:	0992                	slli	s3,s3,0x4
    1792:	397d                	addiw	s2,s2,-1
    1794:	fe0914e3          	bnez	s2,177c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    1798:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    179c:	4981                	li	s3,0
    179e:	b721                	j	16a6 <vprintf+0x60>
        s = va_arg(ap, char*);
    17a0:	008b0993          	addi	s3,s6,8
    17a4:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    17a8:	02090163          	beqz	s2,17ca <vprintf+0x184>
        while(*s != 0){
    17ac:	00094583          	lbu	a1,0(s2)
    17b0:	c9a1                	beqz	a1,1800 <vprintf+0x1ba>
          putc(fd, *s);
    17b2:	8556                	mv	a0,s5
    17b4:	00000097          	auipc	ra,0x0
    17b8:	dc6080e7          	jalr	-570(ra) # 157a <putc>
          s++;
    17bc:	0905                	addi	s2,s2,1
        while(*s != 0){
    17be:	00094583          	lbu	a1,0(s2)
    17c2:	f9e5                	bnez	a1,17b2 <vprintf+0x16c>
        s = va_arg(ap, char*);
    17c4:	8b4e                	mv	s6,s3
      state = 0;
    17c6:	4981                	li	s3,0
    17c8:	bdf9                	j	16a6 <vprintf+0x60>
          s = "(null)";
    17ca:	00000917          	auipc	s2,0x0
    17ce:	29e90913          	addi	s2,s2,670 # 1a68 <malloc+0x158>
        while(*s != 0){
    17d2:	02800593          	li	a1,40
    17d6:	bff1                	j	17b2 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    17d8:	008b0913          	addi	s2,s6,8
    17dc:	000b4583          	lbu	a1,0(s6)
    17e0:	8556                	mv	a0,s5
    17e2:	00000097          	auipc	ra,0x0
    17e6:	d98080e7          	jalr	-616(ra) # 157a <putc>
    17ea:	8b4a                	mv	s6,s2
      state = 0;
    17ec:	4981                	li	s3,0
    17ee:	bd65                	j	16a6 <vprintf+0x60>
        putc(fd, c);
    17f0:	85d2                	mv	a1,s4
    17f2:	8556                	mv	a0,s5
    17f4:	00000097          	auipc	ra,0x0
    17f8:	d86080e7          	jalr	-634(ra) # 157a <putc>
      state = 0;
    17fc:	4981                	li	s3,0
    17fe:	b565                	j	16a6 <vprintf+0x60>
        s = va_arg(ap, char*);
    1800:	8b4e                	mv	s6,s3
      state = 0;
    1802:	4981                	li	s3,0
    1804:	b54d                	j	16a6 <vprintf+0x60>
    }
  }
}
    1806:	70e6                	ld	ra,120(sp)
    1808:	7446                	ld	s0,112(sp)
    180a:	74a6                	ld	s1,104(sp)
    180c:	7906                	ld	s2,96(sp)
    180e:	69e6                	ld	s3,88(sp)
    1810:	6a46                	ld	s4,80(sp)
    1812:	6aa6                	ld	s5,72(sp)
    1814:	6b06                	ld	s6,64(sp)
    1816:	7be2                	ld	s7,56(sp)
    1818:	7c42                	ld	s8,48(sp)
    181a:	7ca2                	ld	s9,40(sp)
    181c:	7d02                	ld	s10,32(sp)
    181e:	6de2                	ld	s11,24(sp)
    1820:	6109                	addi	sp,sp,128
    1822:	8082                	ret

0000000000001824 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1824:	715d                	addi	sp,sp,-80
    1826:	ec06                	sd	ra,24(sp)
    1828:	e822                	sd	s0,16(sp)
    182a:	1000                	addi	s0,sp,32
    182c:	e010                	sd	a2,0(s0)
    182e:	e414                	sd	a3,8(s0)
    1830:	e818                	sd	a4,16(s0)
    1832:	ec1c                	sd	a5,24(s0)
    1834:	03043023          	sd	a6,32(s0)
    1838:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    183c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1840:	8622                	mv	a2,s0
    1842:	00000097          	auipc	ra,0x0
    1846:	e04080e7          	jalr	-508(ra) # 1646 <vprintf>
}
    184a:	60e2                	ld	ra,24(sp)
    184c:	6442                	ld	s0,16(sp)
    184e:	6161                	addi	sp,sp,80
    1850:	8082                	ret

0000000000001852 <printf>:

void
printf(const char *fmt, ...)
{
    1852:	711d                	addi	sp,sp,-96
    1854:	ec06                	sd	ra,24(sp)
    1856:	e822                	sd	s0,16(sp)
    1858:	1000                	addi	s0,sp,32
    185a:	e40c                	sd	a1,8(s0)
    185c:	e810                	sd	a2,16(s0)
    185e:	ec14                	sd	a3,24(s0)
    1860:	f018                	sd	a4,32(s0)
    1862:	f41c                	sd	a5,40(s0)
    1864:	03043823          	sd	a6,48(s0)
    1868:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    186c:	00840613          	addi	a2,s0,8
    1870:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1874:	85aa                	mv	a1,a0
    1876:	4505                	li	a0,1
    1878:	00000097          	auipc	ra,0x0
    187c:	dce080e7          	jalr	-562(ra) # 1646 <vprintf>
}
    1880:	60e2                	ld	ra,24(sp)
    1882:	6442                	ld	s0,16(sp)
    1884:	6125                	addi	sp,sp,96
    1886:	8082                	ret

0000000000001888 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1888:	1141                	addi	sp,sp,-16
    188a:	e422                	sd	s0,8(sp)
    188c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    188e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1892:	00000797          	auipc	a5,0x0
    1896:	1f67b783          	ld	a5,502(a5) # 1a88 <freep>
    189a:	a805                	j	18ca <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    189c:	4618                	lw	a4,8(a2)
    189e:	9db9                	addw	a1,a1,a4
    18a0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    18a4:	6398                	ld	a4,0(a5)
    18a6:	6318                	ld	a4,0(a4)
    18a8:	fee53823          	sd	a4,-16(a0)
    18ac:	a091                	j	18f0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    18ae:	ff852703          	lw	a4,-8(a0)
    18b2:	9e39                	addw	a2,a2,a4
    18b4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    18b6:	ff053703          	ld	a4,-16(a0)
    18ba:	e398                	sd	a4,0(a5)
    18bc:	a099                	j	1902 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    18be:	6398                	ld	a4,0(a5)
    18c0:	00e7e463          	bltu	a5,a4,18c8 <free+0x40>
    18c4:	00e6ea63          	bltu	a3,a4,18d8 <free+0x50>
{
    18c8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    18ca:	fed7fae3          	bgeu	a5,a3,18be <free+0x36>
    18ce:	6398                	ld	a4,0(a5)
    18d0:	00e6e463          	bltu	a3,a4,18d8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    18d4:	fee7eae3          	bltu	a5,a4,18c8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    18d8:	ff852583          	lw	a1,-8(a0)
    18dc:	6390                	ld	a2,0(a5)
    18de:	02059713          	slli	a4,a1,0x20
    18e2:	9301                	srli	a4,a4,0x20
    18e4:	0712                	slli	a4,a4,0x4
    18e6:	9736                	add	a4,a4,a3
    18e8:	fae60ae3          	beq	a2,a4,189c <free+0x14>
    bp->s.ptr = p->s.ptr;
    18ec:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    18f0:	4790                	lw	a2,8(a5)
    18f2:	02061713          	slli	a4,a2,0x20
    18f6:	9301                	srli	a4,a4,0x20
    18f8:	0712                	slli	a4,a4,0x4
    18fa:	973e                	add	a4,a4,a5
    18fc:	fae689e3          	beq	a3,a4,18ae <free+0x26>
  } else
    p->s.ptr = bp;
    1900:	e394                	sd	a3,0(a5)
  freep = p;
    1902:	00000717          	auipc	a4,0x0
    1906:	18f73323          	sd	a5,390(a4) # 1a88 <freep>
}
    190a:	6422                	ld	s0,8(sp)
    190c:	0141                	addi	sp,sp,16
    190e:	8082                	ret

0000000000001910 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1910:	7139                	addi	sp,sp,-64
    1912:	fc06                	sd	ra,56(sp)
    1914:	f822                	sd	s0,48(sp)
    1916:	f426                	sd	s1,40(sp)
    1918:	f04a                	sd	s2,32(sp)
    191a:	ec4e                	sd	s3,24(sp)
    191c:	e852                	sd	s4,16(sp)
    191e:	e456                	sd	s5,8(sp)
    1920:	e05a                	sd	s6,0(sp)
    1922:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1924:	02051493          	slli	s1,a0,0x20
    1928:	9081                	srli	s1,s1,0x20
    192a:	04bd                	addi	s1,s1,15
    192c:	8091                	srli	s1,s1,0x4
    192e:	0014899b          	addiw	s3,s1,1
    1932:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1934:	00000517          	auipc	a0,0x0
    1938:	15453503          	ld	a0,340(a0) # 1a88 <freep>
    193c:	c515                	beqz	a0,1968 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    193e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1940:	4798                	lw	a4,8(a5)
    1942:	02977f63          	bgeu	a4,s1,1980 <malloc+0x70>
    1946:	8a4e                	mv	s4,s3
    1948:	0009871b          	sext.w	a4,s3
    194c:	6685                	lui	a3,0x1
    194e:	00d77363          	bgeu	a4,a3,1954 <malloc+0x44>
    1952:	6a05                	lui	s4,0x1
    1954:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1958:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    195c:	00000917          	auipc	s2,0x0
    1960:	12c90913          	addi	s2,s2,300 # 1a88 <freep>
  if(p == (char*)-1)
    1964:	5afd                	li	s5,-1
    1966:	a88d                	j	19d8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    1968:	00000797          	auipc	a5,0x0
    196c:	13878793          	addi	a5,a5,312 # 1aa0 <base>
    1970:	00000717          	auipc	a4,0x0
    1974:	10f73c23          	sd	a5,280(a4) # 1a88 <freep>
    1978:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    197a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    197e:	b7e1                	j	1946 <malloc+0x36>
      if(p->s.size == nunits)
    1980:	02e48b63          	beq	s1,a4,19b6 <malloc+0xa6>
        p->s.size -= nunits;
    1984:	4137073b          	subw	a4,a4,s3
    1988:	c798                	sw	a4,8(a5)
        p += p->s.size;
    198a:	1702                	slli	a4,a4,0x20
    198c:	9301                	srli	a4,a4,0x20
    198e:	0712                	slli	a4,a4,0x4
    1990:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1992:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1996:	00000717          	auipc	a4,0x0
    199a:	0ea73923          	sd	a0,242(a4) # 1a88 <freep>
      return (void*)(p + 1);
    199e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    19a2:	70e2                	ld	ra,56(sp)
    19a4:	7442                	ld	s0,48(sp)
    19a6:	74a2                	ld	s1,40(sp)
    19a8:	7902                	ld	s2,32(sp)
    19aa:	69e2                	ld	s3,24(sp)
    19ac:	6a42                	ld	s4,16(sp)
    19ae:	6aa2                	ld	s5,8(sp)
    19b0:	6b02                	ld	s6,0(sp)
    19b2:	6121                	addi	sp,sp,64
    19b4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    19b6:	6398                	ld	a4,0(a5)
    19b8:	e118                	sd	a4,0(a0)
    19ba:	bff1                	j	1996 <malloc+0x86>
  hp->s.size = nu;
    19bc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    19c0:	0541                	addi	a0,a0,16
    19c2:	00000097          	auipc	ra,0x0
    19c6:	ec6080e7          	jalr	-314(ra) # 1888 <free>
  return freep;
    19ca:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    19ce:	d971                	beqz	a0,19a2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    19d0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    19d2:	4798                	lw	a4,8(a5)
    19d4:	fa9776e3          	bgeu	a4,s1,1980 <malloc+0x70>
    if(p == freep)
    19d8:	00093703          	ld	a4,0(s2)
    19dc:	853e                	mv	a0,a5
    19de:	fef719e3          	bne	a4,a5,19d0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    19e2:	8552                	mv	a0,s4
    19e4:	00000097          	auipc	ra,0x0
    19e8:	b6e080e7          	jalr	-1170(ra) # 1552 <sbrk>
  if(p == (char*)-1)
    19ec:	fd5518e3          	bne	a0,s5,19bc <malloc+0xac>
        return 0;
    19f0:	4501                	li	a0,0
    19f2:	bf45                	j	19a2 <malloc+0x92>
