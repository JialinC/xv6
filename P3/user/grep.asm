
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
    1000:	7179                	addi	sp,sp,-48
    1002:	f406                	sd	ra,40(sp)
    1004:	f022                	sd	s0,32(sp)
    1006:	ec26                	sd	s1,24(sp)
    1008:	e84a                	sd	s2,16(sp)
    100a:	e44e                	sd	s3,8(sp)
    100c:	e052                	sd	s4,0(sp)
    100e:	1800                	addi	s0,sp,48
    1010:	892a                	mv	s2,a0
    1012:	89ae                	mv	s3,a1
    1014:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
    1016:	02e00a13          	li	s4,46
    if(matchhere(re, text))
    101a:	85a6                	mv	a1,s1
    101c:	854e                	mv	a0,s3
    101e:	00000097          	auipc	ra,0x0
    1022:	030080e7          	jalr	48(ra) # 104e <matchhere>
    1026:	e919                	bnez	a0,103c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
    1028:	0004c783          	lbu	a5,0(s1)
    102c:	cb89                	beqz	a5,103e <matchstar+0x3e>
    102e:	0485                	addi	s1,s1,1
    1030:	2781                	sext.w	a5,a5
    1032:	ff2784e3          	beq	a5,s2,101a <matchstar+0x1a>
    1036:	ff4902e3          	beq	s2,s4,101a <matchstar+0x1a>
    103a:	a011                	j	103e <matchstar+0x3e>
      return 1;
    103c:	4505                	li	a0,1
  return 0;
}
    103e:	70a2                	ld	ra,40(sp)
    1040:	7402                	ld	s0,32(sp)
    1042:	64e2                	ld	s1,24(sp)
    1044:	6942                	ld	s2,16(sp)
    1046:	69a2                	ld	s3,8(sp)
    1048:	6a02                	ld	s4,0(sp)
    104a:	6145                	addi	sp,sp,48
    104c:	8082                	ret

000000000000104e <matchhere>:
  if(re[0] == '\0')
    104e:	00054703          	lbu	a4,0(a0)
    1052:	cb3d                	beqz	a4,10c8 <matchhere+0x7a>
{
    1054:	1141                	addi	sp,sp,-16
    1056:	e406                	sd	ra,8(sp)
    1058:	e022                	sd	s0,0(sp)
    105a:	0800                	addi	s0,sp,16
    105c:	87aa                	mv	a5,a0
  if(re[1] == '*')
    105e:	00154683          	lbu	a3,1(a0)
    1062:	02a00613          	li	a2,42
    1066:	02c68563          	beq	a3,a2,1090 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
    106a:	02400613          	li	a2,36
    106e:	02c70a63          	beq	a4,a2,10a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    1072:	0005c683          	lbu	a3,0(a1)
  return 0;
    1076:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    1078:	ca81                	beqz	a3,1088 <matchhere+0x3a>
    107a:	02e00613          	li	a2,46
    107e:	02c70d63          	beq	a4,a2,10b8 <matchhere+0x6a>
  return 0;
    1082:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    1084:	02d70a63          	beq	a4,a3,10b8 <matchhere+0x6a>
}
    1088:	60a2                	ld	ra,8(sp)
    108a:	6402                	ld	s0,0(sp)
    108c:	0141                	addi	sp,sp,16
    108e:	8082                	ret
    return matchstar(re[0], re+2, text);
    1090:	862e                	mv	a2,a1
    1092:	00250593          	addi	a1,a0,2
    1096:	853a                	mv	a0,a4
    1098:	00000097          	auipc	ra,0x0
    109c:	f68080e7          	jalr	-152(ra) # 1000 <matchstar>
    10a0:	b7e5                	j	1088 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
    10a2:	c691                	beqz	a3,10ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    10a4:	0005c683          	lbu	a3,0(a1)
    10a8:	fee9                	bnez	a3,1082 <matchhere+0x34>
  return 0;
    10aa:	4501                	li	a0,0
    10ac:	bff1                	j	1088 <matchhere+0x3a>
    return *text == '\0';
    10ae:	0005c503          	lbu	a0,0(a1)
    10b2:	00153513          	seqz	a0,a0
    10b6:	bfc9                	j	1088 <matchhere+0x3a>
    return matchhere(re+1, text+1);
    10b8:	0585                	addi	a1,a1,1
    10ba:	00178513          	addi	a0,a5,1
    10be:	00000097          	auipc	ra,0x0
    10c2:	f90080e7          	jalr	-112(ra) # 104e <matchhere>
    10c6:	b7c9                	j	1088 <matchhere+0x3a>
    return 1;
    10c8:	4505                	li	a0,1
}
    10ca:	8082                	ret

00000000000010cc <match>:
{
    10cc:	1101                	addi	sp,sp,-32
    10ce:	ec06                	sd	ra,24(sp)
    10d0:	e822                	sd	s0,16(sp)
    10d2:	e426                	sd	s1,8(sp)
    10d4:	e04a                	sd	s2,0(sp)
    10d6:	1000                	addi	s0,sp,32
    10d8:	892a                	mv	s2,a0
    10da:	84ae                	mv	s1,a1
  if(re[0] == '^')
    10dc:	00054703          	lbu	a4,0(a0)
    10e0:	05e00793          	li	a5,94
    10e4:	00f70e63          	beq	a4,a5,1100 <match+0x34>
    if(matchhere(re, text))
    10e8:	85a6                	mv	a1,s1
    10ea:	854a                	mv	a0,s2
    10ec:	00000097          	auipc	ra,0x0
    10f0:	f62080e7          	jalr	-158(ra) # 104e <matchhere>
    10f4:	ed01                	bnez	a0,110c <match+0x40>
  }while(*text++ != '\0');
    10f6:	0485                	addi	s1,s1,1
    10f8:	fff4c783          	lbu	a5,-1(s1)
    10fc:	f7f5                	bnez	a5,10e8 <match+0x1c>
    10fe:	a801                	j	110e <match+0x42>
    return matchhere(re+1, text);
    1100:	0505                	addi	a0,a0,1
    1102:	00000097          	auipc	ra,0x0
    1106:	f4c080e7          	jalr	-180(ra) # 104e <matchhere>
    110a:	a011                	j	110e <match+0x42>
      return 1;
    110c:	4505                	li	a0,1
}
    110e:	60e2                	ld	ra,24(sp)
    1110:	6442                	ld	s0,16(sp)
    1112:	64a2                	ld	s1,8(sp)
    1114:	6902                	ld	s2,0(sp)
    1116:	6105                	addi	sp,sp,32
    1118:	8082                	ret

000000000000111a <grep>:
{
    111a:	711d                	addi	sp,sp,-96
    111c:	ec86                	sd	ra,88(sp)
    111e:	e8a2                	sd	s0,80(sp)
    1120:	e4a6                	sd	s1,72(sp)
    1122:	e0ca                	sd	s2,64(sp)
    1124:	fc4e                	sd	s3,56(sp)
    1126:	f852                	sd	s4,48(sp)
    1128:	f456                	sd	s5,40(sp)
    112a:	f05a                	sd	s6,32(sp)
    112c:	ec5e                	sd	s7,24(sp)
    112e:	e862                	sd	s8,16(sp)
    1130:	e466                	sd	s9,8(sp)
    1132:	1080                	addi	s0,sp,96
    1134:	89aa                	mv	s3,a0
    1136:	8b2e                	mv	s6,a1
  m = 0;
    1138:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    113a:	3ff00b93          	li	s7,1023
    113e:	00001a97          	auipc	s5,0x1
    1142:	8f2a8a93          	addi	s5,s5,-1806 # 1a30 <buf>
    p = buf;
    1146:	8cd6                	mv	s9,s5
    1148:	8c56                	mv	s8,s5
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    114a:	a0a1                	j	1192 <grep+0x78>
        *q = '\n';
    114c:	47a9                	li	a5,10
    114e:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
    1152:	00148613          	addi	a2,s1,1
    1156:	4126063b          	subw	a2,a2,s2
    115a:	85ca                	mv	a1,s2
    115c:	4505                	li	a0,1
    115e:	00000097          	auipc	ra,0x0
    1162:	362080e7          	jalr	866(ra) # 14c0 <write>
      p = q+1;
    1166:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
    116a:	45a9                	li	a1,10
    116c:	854a                	mv	a0,s2
    116e:	00000097          	auipc	ra,0x0
    1172:	1d4080e7          	jalr	468(ra) # 1342 <strchr>
    1176:	84aa                	mv	s1,a0
    1178:	c919                	beqz	a0,118e <grep+0x74>
      *q = 0;
    117a:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
    117e:	85ca                	mv	a1,s2
    1180:	854e                	mv	a0,s3
    1182:	00000097          	auipc	ra,0x0
    1186:	f4a080e7          	jalr	-182(ra) # 10cc <match>
    118a:	dd71                	beqz	a0,1166 <grep+0x4c>
    118c:	b7c1                	j	114c <grep+0x32>
    if(m > 0){
    118e:	03404563          	bgtz	s4,11b8 <grep+0x9e>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    1192:	414b863b          	subw	a2,s7,s4
    1196:	014a85b3          	add	a1,s5,s4
    119a:	855a                	mv	a0,s6
    119c:	00000097          	auipc	ra,0x0
    11a0:	31c080e7          	jalr	796(ra) # 14b8 <read>
    11a4:	02a05663          	blez	a0,11d0 <grep+0xb6>
    m += n;
    11a8:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
    11ac:	014a87b3          	add	a5,s5,s4
    11b0:	00078023          	sb	zero,0(a5)
    p = buf;
    11b4:	8962                	mv	s2,s8
    while((q = strchr(p, '\n')) != 0){
    11b6:	bf55                	j	116a <grep+0x50>
      m -= p - buf;
    11b8:	415907b3          	sub	a5,s2,s5
    11bc:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
    11c0:	8652                	mv	a2,s4
    11c2:	85ca                	mv	a1,s2
    11c4:	8566                	mv	a0,s9
    11c6:	00000097          	auipc	ra,0x0
    11ca:	2a4080e7          	jalr	676(ra) # 146a <memmove>
    11ce:	b7d1                	j	1192 <grep+0x78>
}
    11d0:	60e6                	ld	ra,88(sp)
    11d2:	6446                	ld	s0,80(sp)
    11d4:	64a6                	ld	s1,72(sp)
    11d6:	6906                	ld	s2,64(sp)
    11d8:	79e2                	ld	s3,56(sp)
    11da:	7a42                	ld	s4,48(sp)
    11dc:	7aa2                	ld	s5,40(sp)
    11de:	7b02                	ld	s6,32(sp)
    11e0:	6be2                	ld	s7,24(sp)
    11e2:	6c42                	ld	s8,16(sp)
    11e4:	6ca2                	ld	s9,8(sp)
    11e6:	6125                	addi	sp,sp,96
    11e8:	8082                	ret

00000000000011ea <main>:
{
    11ea:	7139                	addi	sp,sp,-64
    11ec:	fc06                	sd	ra,56(sp)
    11ee:	f822                	sd	s0,48(sp)
    11f0:	f426                	sd	s1,40(sp)
    11f2:	f04a                	sd	s2,32(sp)
    11f4:	ec4e                	sd	s3,24(sp)
    11f6:	e852                	sd	s4,16(sp)
    11f8:	e456                	sd	s5,8(sp)
    11fa:	0080                	addi	s0,sp,64
  if(argc <= 1){
    11fc:	4785                	li	a5,1
    11fe:	04a7de63          	bge	a5,a0,125a <main+0x70>
  pattern = argv[1];
    1202:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
    1206:	4789                	li	a5,2
    1208:	06a7d763          	bge	a5,a0,1276 <main+0x8c>
    120c:	01058913          	addi	s2,a1,16
    1210:	ffd5099b          	addiw	s3,a0,-3
    1214:	1982                	slli	s3,s3,0x20
    1216:	0209d993          	srli	s3,s3,0x20
    121a:	098e                	slli	s3,s3,0x3
    121c:	05e1                	addi	a1,a1,24
    121e:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
    1220:	4581                	li	a1,0
    1222:	00093503          	ld	a0,0(s2)
    1226:	00000097          	auipc	ra,0x0
    122a:	2ba080e7          	jalr	698(ra) # 14e0 <open>
    122e:	84aa                	mv	s1,a0
    1230:	04054e63          	bltz	a0,128c <main+0xa2>
    grep(pattern, fd);
    1234:	85aa                	mv	a1,a0
    1236:	8552                	mv	a0,s4
    1238:	00000097          	auipc	ra,0x0
    123c:	ee2080e7          	jalr	-286(ra) # 111a <grep>
    close(fd);
    1240:	8526                	mv	a0,s1
    1242:	00000097          	auipc	ra,0x0
    1246:	286080e7          	jalr	646(ra) # 14c8 <close>
  for(i = 2; i < argc; i++){
    124a:	0921                	addi	s2,s2,8
    124c:	fd391ae3          	bne	s2,s3,1220 <main+0x36>
  exit(0);
    1250:	4501                	li	a0,0
    1252:	00000097          	auipc	ra,0x0
    1256:	24e080e7          	jalr	590(ra) # 14a0 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
    125a:	00000597          	auipc	a1,0x0
    125e:	77658593          	addi	a1,a1,1910 # 19d0 <malloc+0xea>
    1262:	4509                	li	a0,2
    1264:	00000097          	auipc	ra,0x0
    1268:	596080e7          	jalr	1430(ra) # 17fa <fprintf>
    exit(1);
    126c:	4505                	li	a0,1
    126e:	00000097          	auipc	ra,0x0
    1272:	232080e7          	jalr	562(ra) # 14a0 <exit>
    grep(pattern, 0);
    1276:	4581                	li	a1,0
    1278:	8552                	mv	a0,s4
    127a:	00000097          	auipc	ra,0x0
    127e:	ea0080e7          	jalr	-352(ra) # 111a <grep>
    exit(0);
    1282:	4501                	li	a0,0
    1284:	00000097          	auipc	ra,0x0
    1288:	21c080e7          	jalr	540(ra) # 14a0 <exit>
      printf("grep: cannot open %s\n", argv[i]);
    128c:	00093583          	ld	a1,0(s2)
    1290:	00000517          	auipc	a0,0x0
    1294:	76050513          	addi	a0,a0,1888 # 19f0 <malloc+0x10a>
    1298:	00000097          	auipc	ra,0x0
    129c:	590080e7          	jalr	1424(ra) # 1828 <printf>
      exit(1);
    12a0:	4505                	li	a0,1
    12a2:	00000097          	auipc	ra,0x0
    12a6:	1fe080e7          	jalr	510(ra) # 14a0 <exit>

00000000000012aa <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
    12aa:	1141                	addi	sp,sp,-16
    12ac:	e422                	sd	s0,8(sp)
    12ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    12b0:	87aa                	mv	a5,a0
    12b2:	0585                	addi	a1,a1,1
    12b4:	0785                	addi	a5,a5,1
    12b6:	fff5c703          	lbu	a4,-1(a1)
    12ba:	fee78fa3          	sb	a4,-1(a5)
    12be:	fb75                	bnez	a4,12b2 <strcpy+0x8>
    ;
  return os;
}
    12c0:	6422                	ld	s0,8(sp)
    12c2:	0141                	addi	sp,sp,16
    12c4:	8082                	ret

00000000000012c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    12c6:	1141                	addi	sp,sp,-16
    12c8:	e422                	sd	s0,8(sp)
    12ca:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    12cc:	00054783          	lbu	a5,0(a0)
    12d0:	cb91                	beqz	a5,12e4 <strcmp+0x1e>
    12d2:	0005c703          	lbu	a4,0(a1)
    12d6:	00f71763          	bne	a4,a5,12e4 <strcmp+0x1e>
    p++, q++;
    12da:	0505                	addi	a0,a0,1
    12dc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    12de:	00054783          	lbu	a5,0(a0)
    12e2:	fbe5                	bnez	a5,12d2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    12e4:	0005c503          	lbu	a0,0(a1)
}
    12e8:	40a7853b          	subw	a0,a5,a0
    12ec:	6422                	ld	s0,8(sp)
    12ee:	0141                	addi	sp,sp,16
    12f0:	8082                	ret

00000000000012f2 <strlen>:

uint
strlen(const char *s)
{
    12f2:	1141                	addi	sp,sp,-16
    12f4:	e422                	sd	s0,8(sp)
    12f6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    12f8:	00054783          	lbu	a5,0(a0)
    12fc:	cf91                	beqz	a5,1318 <strlen+0x26>
    12fe:	0505                	addi	a0,a0,1
    1300:	87aa                	mv	a5,a0
    1302:	4685                	li	a3,1
    1304:	9e89                	subw	a3,a3,a0
    1306:	00f6853b          	addw	a0,a3,a5
    130a:	0785                	addi	a5,a5,1
    130c:	fff7c703          	lbu	a4,-1(a5)
    1310:	fb7d                	bnez	a4,1306 <strlen+0x14>
    ;
  return n;
}
    1312:	6422                	ld	s0,8(sp)
    1314:	0141                	addi	sp,sp,16
    1316:	8082                	ret
  for(n = 0; s[n]; n++)
    1318:	4501                	li	a0,0
    131a:	bfe5                	j	1312 <strlen+0x20>

000000000000131c <memset>:

void*
memset(void *dst, int c, uint n)
{
    131c:	1141                	addi	sp,sp,-16
    131e:	e422                	sd	s0,8(sp)
    1320:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    1322:	ce09                	beqz	a2,133c <memset+0x20>
    1324:	87aa                	mv	a5,a0
    1326:	fff6071b          	addiw	a4,a2,-1
    132a:	1702                	slli	a4,a4,0x20
    132c:	9301                	srli	a4,a4,0x20
    132e:	0705                	addi	a4,a4,1
    1330:	972a                	add	a4,a4,a0
    cdst[i] = c;
    1332:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    1336:	0785                	addi	a5,a5,1
    1338:	fee79de3          	bne	a5,a4,1332 <memset+0x16>
  }
  return dst;
}
    133c:	6422                	ld	s0,8(sp)
    133e:	0141                	addi	sp,sp,16
    1340:	8082                	ret

0000000000001342 <strchr>:

char*
strchr(const char *s, char c)
{
    1342:	1141                	addi	sp,sp,-16
    1344:	e422                	sd	s0,8(sp)
    1346:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1348:	00054783          	lbu	a5,0(a0)
    134c:	cb99                	beqz	a5,1362 <strchr+0x20>
    if(*s == c)
    134e:	00f58763          	beq	a1,a5,135c <strchr+0x1a>
  for(; *s; s++)
    1352:	0505                	addi	a0,a0,1
    1354:	00054783          	lbu	a5,0(a0)
    1358:	fbfd                	bnez	a5,134e <strchr+0xc>
      return (char*)s;
  return 0;
    135a:	4501                	li	a0,0
}
    135c:	6422                	ld	s0,8(sp)
    135e:	0141                	addi	sp,sp,16
    1360:	8082                	ret
  return 0;
    1362:	4501                	li	a0,0
    1364:	bfe5                	j	135c <strchr+0x1a>

0000000000001366 <gets>:

char*
gets(char *buf, int max)
{
    1366:	711d                	addi	sp,sp,-96
    1368:	ec86                	sd	ra,88(sp)
    136a:	e8a2                	sd	s0,80(sp)
    136c:	e4a6                	sd	s1,72(sp)
    136e:	e0ca                	sd	s2,64(sp)
    1370:	fc4e                	sd	s3,56(sp)
    1372:	f852                	sd	s4,48(sp)
    1374:	f456                	sd	s5,40(sp)
    1376:	f05a                	sd	s6,32(sp)
    1378:	ec5e                	sd	s7,24(sp)
    137a:	1080                	addi	s0,sp,96
    137c:	8baa                	mv	s7,a0
    137e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1380:	892a                	mv	s2,a0
    1382:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1384:	4aa9                	li	s5,10
    1386:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1388:	89a6                	mv	s3,s1
    138a:	2485                	addiw	s1,s1,1
    138c:	0344d863          	bge	s1,s4,13bc <gets+0x56>
    cc = read(0, &c, 1);
    1390:	4605                	li	a2,1
    1392:	faf40593          	addi	a1,s0,-81
    1396:	4501                	li	a0,0
    1398:	00000097          	auipc	ra,0x0
    139c:	120080e7          	jalr	288(ra) # 14b8 <read>
    if(cc < 1)
    13a0:	00a05e63          	blez	a0,13bc <gets+0x56>
    buf[i++] = c;
    13a4:	faf44783          	lbu	a5,-81(s0)
    13a8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    13ac:	01578763          	beq	a5,s5,13ba <gets+0x54>
    13b0:	0905                	addi	s2,s2,1
    13b2:	fd679be3          	bne	a5,s6,1388 <gets+0x22>
  for(i=0; i+1 < max; ){
    13b6:	89a6                	mv	s3,s1
    13b8:	a011                	j	13bc <gets+0x56>
    13ba:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    13bc:	99de                	add	s3,s3,s7
    13be:	00098023          	sb	zero,0(s3)
  return buf;
}
    13c2:	855e                	mv	a0,s7
    13c4:	60e6                	ld	ra,88(sp)
    13c6:	6446                	ld	s0,80(sp)
    13c8:	64a6                	ld	s1,72(sp)
    13ca:	6906                	ld	s2,64(sp)
    13cc:	79e2                	ld	s3,56(sp)
    13ce:	7a42                	ld	s4,48(sp)
    13d0:	7aa2                	ld	s5,40(sp)
    13d2:	7b02                	ld	s6,32(sp)
    13d4:	6be2                	ld	s7,24(sp)
    13d6:	6125                	addi	sp,sp,96
    13d8:	8082                	ret

00000000000013da <stat>:

int
stat(const char *n, struct stat *st)
{
    13da:	1101                	addi	sp,sp,-32
    13dc:	ec06                	sd	ra,24(sp)
    13de:	e822                	sd	s0,16(sp)
    13e0:	e426                	sd	s1,8(sp)
    13e2:	e04a                	sd	s2,0(sp)
    13e4:	1000                	addi	s0,sp,32
    13e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13e8:	4581                	li	a1,0
    13ea:	00000097          	auipc	ra,0x0
    13ee:	0f6080e7          	jalr	246(ra) # 14e0 <open>
  if(fd < 0)
    13f2:	02054563          	bltz	a0,141c <stat+0x42>
    13f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    13f8:	85ca                	mv	a1,s2
    13fa:	00000097          	auipc	ra,0x0
    13fe:	0fe080e7          	jalr	254(ra) # 14f8 <fstat>
    1402:	892a                	mv	s2,a0
  close(fd);
    1404:	8526                	mv	a0,s1
    1406:	00000097          	auipc	ra,0x0
    140a:	0c2080e7          	jalr	194(ra) # 14c8 <close>
  return r;
}
    140e:	854a                	mv	a0,s2
    1410:	60e2                	ld	ra,24(sp)
    1412:	6442                	ld	s0,16(sp)
    1414:	64a2                	ld	s1,8(sp)
    1416:	6902                	ld	s2,0(sp)
    1418:	6105                	addi	sp,sp,32
    141a:	8082                	ret
    return -1;
    141c:	597d                	li	s2,-1
    141e:	bfc5                	j	140e <stat+0x34>

0000000000001420 <atoi>:

int
atoi(const char *s)
{
    1420:	1141                	addi	sp,sp,-16
    1422:	e422                	sd	s0,8(sp)
    1424:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1426:	00054603          	lbu	a2,0(a0)
    142a:	fd06079b          	addiw	a5,a2,-48
    142e:	0ff7f793          	andi	a5,a5,255
    1432:	4725                	li	a4,9
    1434:	02f76963          	bltu	a4,a5,1466 <atoi+0x46>
    1438:	86aa                	mv	a3,a0
  n = 0;
    143a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    143c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    143e:	0685                	addi	a3,a3,1
    1440:	0025179b          	slliw	a5,a0,0x2
    1444:	9fa9                	addw	a5,a5,a0
    1446:	0017979b          	slliw	a5,a5,0x1
    144a:	9fb1                	addw	a5,a5,a2
    144c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    1450:	0006c603          	lbu	a2,0(a3)
    1454:	fd06071b          	addiw	a4,a2,-48
    1458:	0ff77713          	andi	a4,a4,255
    145c:	fee5f1e3          	bgeu	a1,a4,143e <atoi+0x1e>
  return n;
}
    1460:	6422                	ld	s0,8(sp)
    1462:	0141                	addi	sp,sp,16
    1464:	8082                	ret
  n = 0;
    1466:	4501                	li	a0,0
    1468:	bfe5                	j	1460 <atoi+0x40>

000000000000146a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    146a:	1141                	addi	sp,sp,-16
    146c:	e422                	sd	s0,8(sp)
    146e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1470:	02c05163          	blez	a2,1492 <memmove+0x28>
    1474:	fff6071b          	addiw	a4,a2,-1
    1478:	1702                	slli	a4,a4,0x20
    147a:	9301                	srli	a4,a4,0x20
    147c:	0705                	addi	a4,a4,1
    147e:	972a                	add	a4,a4,a0
  dst = vdst;
    1480:	87aa                	mv	a5,a0
    *dst++ = *src++;
    1482:	0585                	addi	a1,a1,1
    1484:	0785                	addi	a5,a5,1
    1486:	fff5c683          	lbu	a3,-1(a1)
    148a:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    148e:	fee79ae3          	bne	a5,a4,1482 <memmove+0x18>
  return vdst;
}
    1492:	6422                	ld	s0,8(sp)
    1494:	0141                	addi	sp,sp,16
    1496:	8082                	ret

0000000000001498 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1498:	4885                	li	a7,1
 ecall
    149a:	00000073          	ecall
 ret
    149e:	8082                	ret

00000000000014a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
    14a0:	4889                	li	a7,2
 ecall
    14a2:	00000073          	ecall
 ret
    14a6:	8082                	ret

00000000000014a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
    14a8:	488d                	li	a7,3
 ecall
    14aa:	00000073          	ecall
 ret
    14ae:	8082                	ret

00000000000014b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    14b0:	4891                	li	a7,4
 ecall
    14b2:	00000073          	ecall
 ret
    14b6:	8082                	ret

00000000000014b8 <read>:
.global read
read:
 li a7, SYS_read
    14b8:	4895                	li	a7,5
 ecall
    14ba:	00000073          	ecall
 ret
    14be:	8082                	ret

00000000000014c0 <write>:
.global write
write:
 li a7, SYS_write
    14c0:	48c1                	li	a7,16
 ecall
    14c2:	00000073          	ecall
 ret
    14c6:	8082                	ret

00000000000014c8 <close>:
.global close
close:
 li a7, SYS_close
    14c8:	48d5                	li	a7,21
 ecall
    14ca:	00000073          	ecall
 ret
    14ce:	8082                	ret

00000000000014d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
    14d0:	4899                	li	a7,6
 ecall
    14d2:	00000073          	ecall
 ret
    14d6:	8082                	ret

00000000000014d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
    14d8:	489d                	li	a7,7
 ecall
    14da:	00000073          	ecall
 ret
    14de:	8082                	ret

00000000000014e0 <open>:
.global open
open:
 li a7, SYS_open
    14e0:	48bd                	li	a7,15
 ecall
    14e2:	00000073          	ecall
 ret
    14e6:	8082                	ret

00000000000014e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    14e8:	48c5                	li	a7,17
 ecall
    14ea:	00000073          	ecall
 ret
    14ee:	8082                	ret

00000000000014f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    14f0:	48c9                	li	a7,18
 ecall
    14f2:	00000073          	ecall
 ret
    14f6:	8082                	ret

00000000000014f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    14f8:	48a1                	li	a7,8
 ecall
    14fa:	00000073          	ecall
 ret
    14fe:	8082                	ret

0000000000001500 <link>:
.global link
link:
 li a7, SYS_link
    1500:	48cd                	li	a7,19
 ecall
    1502:	00000073          	ecall
 ret
    1506:	8082                	ret

0000000000001508 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1508:	48d1                	li	a7,20
 ecall
    150a:	00000073          	ecall
 ret
    150e:	8082                	ret

0000000000001510 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1510:	48a5                	li	a7,9
 ecall
    1512:	00000073          	ecall
 ret
    1516:	8082                	ret

0000000000001518 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1518:	48a9                	li	a7,10
 ecall
    151a:	00000073          	ecall
 ret
    151e:	8082                	ret

0000000000001520 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1520:	48ad                	li	a7,11
 ecall
    1522:	00000073          	ecall
 ret
    1526:	8082                	ret

0000000000001528 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1528:	48b1                	li	a7,12
 ecall
    152a:	00000073          	ecall
 ret
    152e:	8082                	ret

0000000000001530 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1530:	48b5                	li	a7,13
 ecall
    1532:	00000073          	ecall
 ret
    1536:	8082                	ret

0000000000001538 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1538:	48b9                	li	a7,14
 ecall
    153a:	00000073          	ecall
 ret
    153e:	8082                	ret

0000000000001540 <mprotect>:
.global mprotect
mprotect:
 li a7, SYS_mprotect
    1540:	48d9                	li	a7,22
 ecall
    1542:	00000073          	ecall
 ret
    1546:	8082                	ret

0000000000001548 <munprotect>:
.global munprotect
munprotect:
 li a7, SYS_munprotect
    1548:	48dd                	li	a7,23
 ecall
    154a:	00000073          	ecall
 ret
    154e:	8082                	ret

0000000000001550 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1550:	1101                	addi	sp,sp,-32
    1552:	ec06                	sd	ra,24(sp)
    1554:	e822                	sd	s0,16(sp)
    1556:	1000                	addi	s0,sp,32
    1558:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    155c:	4605                	li	a2,1
    155e:	fef40593          	addi	a1,s0,-17
    1562:	00000097          	auipc	ra,0x0
    1566:	f5e080e7          	jalr	-162(ra) # 14c0 <write>
}
    156a:	60e2                	ld	ra,24(sp)
    156c:	6442                	ld	s0,16(sp)
    156e:	6105                	addi	sp,sp,32
    1570:	8082                	ret

0000000000001572 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1572:	7139                	addi	sp,sp,-64
    1574:	fc06                	sd	ra,56(sp)
    1576:	f822                	sd	s0,48(sp)
    1578:	f426                	sd	s1,40(sp)
    157a:	f04a                	sd	s2,32(sp)
    157c:	ec4e                	sd	s3,24(sp)
    157e:	0080                	addi	s0,sp,64
    1580:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1582:	c299                	beqz	a3,1588 <printint+0x16>
    1584:	0805c863          	bltz	a1,1614 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1588:	2581                	sext.w	a1,a1
  neg = 0;
    158a:	4881                	li	a7,0
    158c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1590:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1592:	2601                	sext.w	a2,a2
    1594:	00000517          	auipc	a0,0x0
    1598:	47c50513          	addi	a0,a0,1148 # 1a10 <digits>
    159c:	883a                	mv	a6,a4
    159e:	2705                	addiw	a4,a4,1
    15a0:	02c5f7bb          	remuw	a5,a1,a2
    15a4:	1782                	slli	a5,a5,0x20
    15a6:	9381                	srli	a5,a5,0x20
    15a8:	97aa                	add	a5,a5,a0
    15aa:	0007c783          	lbu	a5,0(a5)
    15ae:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    15b2:	0005879b          	sext.w	a5,a1
    15b6:	02c5d5bb          	divuw	a1,a1,a2
    15ba:	0685                	addi	a3,a3,1
    15bc:	fec7f0e3          	bgeu	a5,a2,159c <printint+0x2a>
  if(neg)
    15c0:	00088b63          	beqz	a7,15d6 <printint+0x64>
    buf[i++] = '-';
    15c4:	fd040793          	addi	a5,s0,-48
    15c8:	973e                	add	a4,a4,a5
    15ca:	02d00793          	li	a5,45
    15ce:	fef70823          	sb	a5,-16(a4)
    15d2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    15d6:	02e05863          	blez	a4,1606 <printint+0x94>
    15da:	fc040793          	addi	a5,s0,-64
    15de:	00e78933          	add	s2,a5,a4
    15e2:	fff78993          	addi	s3,a5,-1
    15e6:	99ba                	add	s3,s3,a4
    15e8:	377d                	addiw	a4,a4,-1
    15ea:	1702                	slli	a4,a4,0x20
    15ec:	9301                	srli	a4,a4,0x20
    15ee:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    15f2:	fff94583          	lbu	a1,-1(s2)
    15f6:	8526                	mv	a0,s1
    15f8:	00000097          	auipc	ra,0x0
    15fc:	f58080e7          	jalr	-168(ra) # 1550 <putc>
  while(--i >= 0)
    1600:	197d                	addi	s2,s2,-1
    1602:	ff3918e3          	bne	s2,s3,15f2 <printint+0x80>
}
    1606:	70e2                	ld	ra,56(sp)
    1608:	7442                	ld	s0,48(sp)
    160a:	74a2                	ld	s1,40(sp)
    160c:	7902                	ld	s2,32(sp)
    160e:	69e2                	ld	s3,24(sp)
    1610:	6121                	addi	sp,sp,64
    1612:	8082                	ret
    x = -xx;
    1614:	40b005bb          	negw	a1,a1
    neg = 1;
    1618:	4885                	li	a7,1
    x = -xx;
    161a:	bf8d                	j	158c <printint+0x1a>

000000000000161c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    161c:	7119                	addi	sp,sp,-128
    161e:	fc86                	sd	ra,120(sp)
    1620:	f8a2                	sd	s0,112(sp)
    1622:	f4a6                	sd	s1,104(sp)
    1624:	f0ca                	sd	s2,96(sp)
    1626:	ecce                	sd	s3,88(sp)
    1628:	e8d2                	sd	s4,80(sp)
    162a:	e4d6                	sd	s5,72(sp)
    162c:	e0da                	sd	s6,64(sp)
    162e:	fc5e                	sd	s7,56(sp)
    1630:	f862                	sd	s8,48(sp)
    1632:	f466                	sd	s9,40(sp)
    1634:	f06a                	sd	s10,32(sp)
    1636:	ec6e                	sd	s11,24(sp)
    1638:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    163a:	0005c903          	lbu	s2,0(a1)
    163e:	18090f63          	beqz	s2,17dc <vprintf+0x1c0>
    1642:	8aaa                	mv	s5,a0
    1644:	8b32                	mv	s6,a2
    1646:	00158493          	addi	s1,a1,1
  state = 0;
    164a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    164c:	02500a13          	li	s4,37
      if(c == 'd'){
    1650:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    1654:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    1658:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    165c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1660:	00000b97          	auipc	s7,0x0
    1664:	3b0b8b93          	addi	s7,s7,944 # 1a10 <digits>
    1668:	a839                	j	1686 <vprintf+0x6a>
        putc(fd, c);
    166a:	85ca                	mv	a1,s2
    166c:	8556                	mv	a0,s5
    166e:	00000097          	auipc	ra,0x0
    1672:	ee2080e7          	jalr	-286(ra) # 1550 <putc>
    1676:	a019                	j	167c <vprintf+0x60>
    } else if(state == '%'){
    1678:	01498f63          	beq	s3,s4,1696 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    167c:	0485                	addi	s1,s1,1
    167e:	fff4c903          	lbu	s2,-1(s1)
    1682:	14090d63          	beqz	s2,17dc <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    1686:	0009079b          	sext.w	a5,s2
    if(state == 0){
    168a:	fe0997e3          	bnez	s3,1678 <vprintf+0x5c>
      if(c == '%'){
    168e:	fd479ee3          	bne	a5,s4,166a <vprintf+0x4e>
        state = '%';
    1692:	89be                	mv	s3,a5
    1694:	b7e5                	j	167c <vprintf+0x60>
      if(c == 'd'){
    1696:	05878063          	beq	a5,s8,16d6 <vprintf+0xba>
      } else if(c == 'l') {
    169a:	05978c63          	beq	a5,s9,16f2 <vprintf+0xd6>
      } else if(c == 'x') {
    169e:	07a78863          	beq	a5,s10,170e <vprintf+0xf2>
      } else if(c == 'p') {
    16a2:	09b78463          	beq	a5,s11,172a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    16a6:	07300713          	li	a4,115
    16aa:	0ce78663          	beq	a5,a4,1776 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    16ae:	06300713          	li	a4,99
    16b2:	0ee78e63          	beq	a5,a4,17ae <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    16b6:	11478863          	beq	a5,s4,17c6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    16ba:	85d2                	mv	a1,s4
    16bc:	8556                	mv	a0,s5
    16be:	00000097          	auipc	ra,0x0
    16c2:	e92080e7          	jalr	-366(ra) # 1550 <putc>
        putc(fd, c);
    16c6:	85ca                	mv	a1,s2
    16c8:	8556                	mv	a0,s5
    16ca:	00000097          	auipc	ra,0x0
    16ce:	e86080e7          	jalr	-378(ra) # 1550 <putc>
      }
      state = 0;
    16d2:	4981                	li	s3,0
    16d4:	b765                	j	167c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    16d6:	008b0913          	addi	s2,s6,8
    16da:	4685                	li	a3,1
    16dc:	4629                	li	a2,10
    16de:	000b2583          	lw	a1,0(s6)
    16e2:	8556                	mv	a0,s5
    16e4:	00000097          	auipc	ra,0x0
    16e8:	e8e080e7          	jalr	-370(ra) # 1572 <printint>
    16ec:	8b4a                	mv	s6,s2
      state = 0;
    16ee:	4981                	li	s3,0
    16f0:	b771                	j	167c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    16f2:	008b0913          	addi	s2,s6,8
    16f6:	4681                	li	a3,0
    16f8:	4629                	li	a2,10
    16fa:	000b2583          	lw	a1,0(s6)
    16fe:	8556                	mv	a0,s5
    1700:	00000097          	auipc	ra,0x0
    1704:	e72080e7          	jalr	-398(ra) # 1572 <printint>
    1708:	8b4a                	mv	s6,s2
      state = 0;
    170a:	4981                	li	s3,0
    170c:	bf85                	j	167c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    170e:	008b0913          	addi	s2,s6,8
    1712:	4681                	li	a3,0
    1714:	4641                	li	a2,16
    1716:	000b2583          	lw	a1,0(s6)
    171a:	8556                	mv	a0,s5
    171c:	00000097          	auipc	ra,0x0
    1720:	e56080e7          	jalr	-426(ra) # 1572 <printint>
    1724:	8b4a                	mv	s6,s2
      state = 0;
    1726:	4981                	li	s3,0
    1728:	bf91                	j	167c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    172a:	008b0793          	addi	a5,s6,8
    172e:	f8f43423          	sd	a5,-120(s0)
    1732:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1736:	03000593          	li	a1,48
    173a:	8556                	mv	a0,s5
    173c:	00000097          	auipc	ra,0x0
    1740:	e14080e7          	jalr	-492(ra) # 1550 <putc>
  putc(fd, 'x');
    1744:	85ea                	mv	a1,s10
    1746:	8556                	mv	a0,s5
    1748:	00000097          	auipc	ra,0x0
    174c:	e08080e7          	jalr	-504(ra) # 1550 <putc>
    1750:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1752:	03c9d793          	srli	a5,s3,0x3c
    1756:	97de                	add	a5,a5,s7
    1758:	0007c583          	lbu	a1,0(a5)
    175c:	8556                	mv	a0,s5
    175e:	00000097          	auipc	ra,0x0
    1762:	df2080e7          	jalr	-526(ra) # 1550 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1766:	0992                	slli	s3,s3,0x4
    1768:	397d                	addiw	s2,s2,-1
    176a:	fe0914e3          	bnez	s2,1752 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    176e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1772:	4981                	li	s3,0
    1774:	b721                	j	167c <vprintf+0x60>
        s = va_arg(ap, char*);
    1776:	008b0993          	addi	s3,s6,8
    177a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    177e:	02090163          	beqz	s2,17a0 <vprintf+0x184>
        while(*s != 0){
    1782:	00094583          	lbu	a1,0(s2)
    1786:	c9a1                	beqz	a1,17d6 <vprintf+0x1ba>
          putc(fd, *s);
    1788:	8556                	mv	a0,s5
    178a:	00000097          	auipc	ra,0x0
    178e:	dc6080e7          	jalr	-570(ra) # 1550 <putc>
          s++;
    1792:	0905                	addi	s2,s2,1
        while(*s != 0){
    1794:	00094583          	lbu	a1,0(s2)
    1798:	f9e5                	bnez	a1,1788 <vprintf+0x16c>
        s = va_arg(ap, char*);
    179a:	8b4e                	mv	s6,s3
      state = 0;
    179c:	4981                	li	s3,0
    179e:	bdf9                	j	167c <vprintf+0x60>
          s = "(null)";
    17a0:	00000917          	auipc	s2,0x0
    17a4:	26890913          	addi	s2,s2,616 # 1a08 <malloc+0x122>
        while(*s != 0){
    17a8:	02800593          	li	a1,40
    17ac:	bff1                	j	1788 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    17ae:	008b0913          	addi	s2,s6,8
    17b2:	000b4583          	lbu	a1,0(s6)
    17b6:	8556                	mv	a0,s5
    17b8:	00000097          	auipc	ra,0x0
    17bc:	d98080e7          	jalr	-616(ra) # 1550 <putc>
    17c0:	8b4a                	mv	s6,s2
      state = 0;
    17c2:	4981                	li	s3,0
    17c4:	bd65                	j	167c <vprintf+0x60>
        putc(fd, c);
    17c6:	85d2                	mv	a1,s4
    17c8:	8556                	mv	a0,s5
    17ca:	00000097          	auipc	ra,0x0
    17ce:	d86080e7          	jalr	-634(ra) # 1550 <putc>
      state = 0;
    17d2:	4981                	li	s3,0
    17d4:	b565                	j	167c <vprintf+0x60>
        s = va_arg(ap, char*);
    17d6:	8b4e                	mv	s6,s3
      state = 0;
    17d8:	4981                	li	s3,0
    17da:	b54d                	j	167c <vprintf+0x60>
    }
  }
}
    17dc:	70e6                	ld	ra,120(sp)
    17de:	7446                	ld	s0,112(sp)
    17e0:	74a6                	ld	s1,104(sp)
    17e2:	7906                	ld	s2,96(sp)
    17e4:	69e6                	ld	s3,88(sp)
    17e6:	6a46                	ld	s4,80(sp)
    17e8:	6aa6                	ld	s5,72(sp)
    17ea:	6b06                	ld	s6,64(sp)
    17ec:	7be2                	ld	s7,56(sp)
    17ee:	7c42                	ld	s8,48(sp)
    17f0:	7ca2                	ld	s9,40(sp)
    17f2:	7d02                	ld	s10,32(sp)
    17f4:	6de2                	ld	s11,24(sp)
    17f6:	6109                	addi	sp,sp,128
    17f8:	8082                	ret

00000000000017fa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    17fa:	715d                	addi	sp,sp,-80
    17fc:	ec06                	sd	ra,24(sp)
    17fe:	e822                	sd	s0,16(sp)
    1800:	1000                	addi	s0,sp,32
    1802:	e010                	sd	a2,0(s0)
    1804:	e414                	sd	a3,8(s0)
    1806:	e818                	sd	a4,16(s0)
    1808:	ec1c                	sd	a5,24(s0)
    180a:	03043023          	sd	a6,32(s0)
    180e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1812:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1816:	8622                	mv	a2,s0
    1818:	00000097          	auipc	ra,0x0
    181c:	e04080e7          	jalr	-508(ra) # 161c <vprintf>
}
    1820:	60e2                	ld	ra,24(sp)
    1822:	6442                	ld	s0,16(sp)
    1824:	6161                	addi	sp,sp,80
    1826:	8082                	ret

0000000000001828 <printf>:

void
printf(const char *fmt, ...)
{
    1828:	711d                	addi	sp,sp,-96
    182a:	ec06                	sd	ra,24(sp)
    182c:	e822                	sd	s0,16(sp)
    182e:	1000                	addi	s0,sp,32
    1830:	e40c                	sd	a1,8(s0)
    1832:	e810                	sd	a2,16(s0)
    1834:	ec14                	sd	a3,24(s0)
    1836:	f018                	sd	a4,32(s0)
    1838:	f41c                	sd	a5,40(s0)
    183a:	03043823          	sd	a6,48(s0)
    183e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1842:	00840613          	addi	a2,s0,8
    1846:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    184a:	85aa                	mv	a1,a0
    184c:	4505                	li	a0,1
    184e:	00000097          	auipc	ra,0x0
    1852:	dce080e7          	jalr	-562(ra) # 161c <vprintf>
}
    1856:	60e2                	ld	ra,24(sp)
    1858:	6442                	ld	s0,16(sp)
    185a:	6125                	addi	sp,sp,96
    185c:	8082                	ret

000000000000185e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    185e:	1141                	addi	sp,sp,-16
    1860:	e422                	sd	s0,8(sp)
    1862:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1864:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1868:	00000797          	auipc	a5,0x0
    186c:	1c07b783          	ld	a5,448(a5) # 1a28 <freep>
    1870:	a805                	j	18a0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1872:	4618                	lw	a4,8(a2)
    1874:	9db9                	addw	a1,a1,a4
    1876:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    187a:	6398                	ld	a4,0(a5)
    187c:	6318                	ld	a4,0(a4)
    187e:	fee53823          	sd	a4,-16(a0)
    1882:	a091                	j	18c6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1884:	ff852703          	lw	a4,-8(a0)
    1888:	9e39                	addw	a2,a2,a4
    188a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    188c:	ff053703          	ld	a4,-16(a0)
    1890:	e398                	sd	a4,0(a5)
    1892:	a099                	j	18d8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1894:	6398                	ld	a4,0(a5)
    1896:	00e7e463          	bltu	a5,a4,189e <free+0x40>
    189a:	00e6ea63          	bltu	a3,a4,18ae <free+0x50>
{
    189e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    18a0:	fed7fae3          	bgeu	a5,a3,1894 <free+0x36>
    18a4:	6398                	ld	a4,0(a5)
    18a6:	00e6e463          	bltu	a3,a4,18ae <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    18aa:	fee7eae3          	bltu	a5,a4,189e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    18ae:	ff852583          	lw	a1,-8(a0)
    18b2:	6390                	ld	a2,0(a5)
    18b4:	02059713          	slli	a4,a1,0x20
    18b8:	9301                	srli	a4,a4,0x20
    18ba:	0712                	slli	a4,a4,0x4
    18bc:	9736                	add	a4,a4,a3
    18be:	fae60ae3          	beq	a2,a4,1872 <free+0x14>
    bp->s.ptr = p->s.ptr;
    18c2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    18c6:	4790                	lw	a2,8(a5)
    18c8:	02061713          	slli	a4,a2,0x20
    18cc:	9301                	srli	a4,a4,0x20
    18ce:	0712                	slli	a4,a4,0x4
    18d0:	973e                	add	a4,a4,a5
    18d2:	fae689e3          	beq	a3,a4,1884 <free+0x26>
  } else
    p->s.ptr = bp;
    18d6:	e394                	sd	a3,0(a5)
  freep = p;
    18d8:	00000717          	auipc	a4,0x0
    18dc:	14f73823          	sd	a5,336(a4) # 1a28 <freep>
}
    18e0:	6422                	ld	s0,8(sp)
    18e2:	0141                	addi	sp,sp,16
    18e4:	8082                	ret

00000000000018e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    18e6:	7139                	addi	sp,sp,-64
    18e8:	fc06                	sd	ra,56(sp)
    18ea:	f822                	sd	s0,48(sp)
    18ec:	f426                	sd	s1,40(sp)
    18ee:	f04a                	sd	s2,32(sp)
    18f0:	ec4e                	sd	s3,24(sp)
    18f2:	e852                	sd	s4,16(sp)
    18f4:	e456                	sd	s5,8(sp)
    18f6:	e05a                	sd	s6,0(sp)
    18f8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18fa:	02051493          	slli	s1,a0,0x20
    18fe:	9081                	srli	s1,s1,0x20
    1900:	04bd                	addi	s1,s1,15
    1902:	8091                	srli	s1,s1,0x4
    1904:	0014899b          	addiw	s3,s1,1
    1908:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    190a:	00000517          	auipc	a0,0x0
    190e:	11e53503          	ld	a0,286(a0) # 1a28 <freep>
    1912:	c515                	beqz	a0,193e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1914:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1916:	4798                	lw	a4,8(a5)
    1918:	02977f63          	bgeu	a4,s1,1956 <malloc+0x70>
    191c:	8a4e                	mv	s4,s3
    191e:	0009871b          	sext.w	a4,s3
    1922:	6685                	lui	a3,0x1
    1924:	00d77363          	bgeu	a4,a3,192a <malloc+0x44>
    1928:	6a05                	lui	s4,0x1
    192a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    192e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1932:	00000917          	auipc	s2,0x0
    1936:	0f690913          	addi	s2,s2,246 # 1a28 <freep>
  if(p == (char*)-1)
    193a:	5afd                	li	s5,-1
    193c:	a88d                	j	19ae <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    193e:	00000797          	auipc	a5,0x0
    1942:	4f278793          	addi	a5,a5,1266 # 1e30 <base>
    1946:	00000717          	auipc	a4,0x0
    194a:	0ef73123          	sd	a5,226(a4) # 1a28 <freep>
    194e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1950:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1954:	b7e1                	j	191c <malloc+0x36>
      if(p->s.size == nunits)
    1956:	02e48b63          	beq	s1,a4,198c <malloc+0xa6>
        p->s.size -= nunits;
    195a:	4137073b          	subw	a4,a4,s3
    195e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1960:	1702                	slli	a4,a4,0x20
    1962:	9301                	srli	a4,a4,0x20
    1964:	0712                	slli	a4,a4,0x4
    1966:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1968:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    196c:	00000717          	auipc	a4,0x0
    1970:	0aa73e23          	sd	a0,188(a4) # 1a28 <freep>
      return (void*)(p + 1);
    1974:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1978:	70e2                	ld	ra,56(sp)
    197a:	7442                	ld	s0,48(sp)
    197c:	74a2                	ld	s1,40(sp)
    197e:	7902                	ld	s2,32(sp)
    1980:	69e2                	ld	s3,24(sp)
    1982:	6a42                	ld	s4,16(sp)
    1984:	6aa2                	ld	s5,8(sp)
    1986:	6b02                	ld	s6,0(sp)
    1988:	6121                	addi	sp,sp,64
    198a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    198c:	6398                	ld	a4,0(a5)
    198e:	e118                	sd	a4,0(a0)
    1990:	bff1                	j	196c <malloc+0x86>
  hp->s.size = nu;
    1992:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1996:	0541                	addi	a0,a0,16
    1998:	00000097          	auipc	ra,0x0
    199c:	ec6080e7          	jalr	-314(ra) # 185e <free>
  return freep;
    19a0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    19a4:	d971                	beqz	a0,1978 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    19a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    19a8:	4798                	lw	a4,8(a5)
    19aa:	fa9776e3          	bgeu	a4,s1,1956 <malloc+0x70>
    if(p == freep)
    19ae:	00093703          	ld	a4,0(s2)
    19b2:	853e                	mv	a0,a5
    19b4:	fef719e3          	bne	a4,a5,19a6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    19b8:	8552                	mv	a0,s4
    19ba:	00000097          	auipc	ra,0x0
    19be:	b6e080e7          	jalr	-1170(ra) # 1528 <sbrk>
  if(p == (char*)-1)
    19c2:	fd5518e3          	bne	a0,s5,1992 <malloc+0xac>
        return 0;
    19c6:	4501                	li	a0,0
    19c8:	bf45                	j	1978 <malloc+0x92>
