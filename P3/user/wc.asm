
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
    1000:	7119                	addi	sp,sp,-128
    1002:	fc86                	sd	ra,120(sp)
    1004:	f8a2                	sd	s0,112(sp)
    1006:	f4a6                	sd	s1,104(sp)
    1008:	f0ca                	sd	s2,96(sp)
    100a:	ecce                	sd	s3,88(sp)
    100c:	e8d2                	sd	s4,80(sp)
    100e:	e4d6                	sd	s5,72(sp)
    1010:	e0da                	sd	s6,64(sp)
    1012:	fc5e                	sd	s7,56(sp)
    1014:	f862                	sd	s8,48(sp)
    1016:	f466                	sd	s9,40(sp)
    1018:	f06a                	sd	s10,32(sp)
    101a:	ec6e                	sd	s11,24(sp)
    101c:	0100                	addi	s0,sp,128
    101e:	f8a43423          	sd	a0,-120(s0)
    1022:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
    1026:	4981                	li	s3,0
  l = w = c = 0;
    1028:	4c81                	li	s9,0
    102a:	4c01                	li	s8,0
    102c:	4b81                	li	s7,0
    102e:	00001d97          	auipc	s11,0x1
    1032:	8fbd8d93          	addi	s11,s11,-1797 # 1929 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
    1036:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
    1038:	00001a17          	auipc	s4,0x1
    103c:	880a0a13          	addi	s4,s4,-1920 # 18b8 <malloc+0xe6>
        inword = 0;
    1040:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1042:	a805                	j	1072 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
    1044:	8552                	mv	a0,s4
    1046:	00000097          	auipc	ra,0x0
    104a:	1e8080e7          	jalr	488(ra) # 122e <strchr>
    104e:	c919                	beqz	a0,1064 <wc+0x64>
        inword = 0;
    1050:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
    1052:	0485                	addi	s1,s1,1
    1054:	01248d63          	beq	s1,s2,106e <wc+0x6e>
      if(buf[i] == '\n')
    1058:	0004c583          	lbu	a1,0(s1)
    105c:	ff5594e3          	bne	a1,s5,1044 <wc+0x44>
        l++;
    1060:	2b85                	addiw	s7,s7,1
    1062:	b7cd                	j	1044 <wc+0x44>
      else if(!inword){
    1064:	fe0997e3          	bnez	s3,1052 <wc+0x52>
        w++;
    1068:	2c05                	addiw	s8,s8,1
        inword = 1;
    106a:	4985                	li	s3,1
    106c:	b7dd                	j	1052 <wc+0x52>
    106e:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1072:	20000613          	li	a2,512
    1076:	00001597          	auipc	a1,0x1
    107a:	8b258593          	addi	a1,a1,-1870 # 1928 <buf>
    107e:	f8843503          	ld	a0,-120(s0)
    1082:	00000097          	auipc	ra,0x0
    1086:	322080e7          	jalr	802(ra) # 13a4 <read>
    108a:	00a05f63          	blez	a0,10a8 <wc+0xa8>
    for(i=0; i<n; i++){
    108e:	00001497          	auipc	s1,0x1
    1092:	89a48493          	addi	s1,s1,-1894 # 1928 <buf>
    1096:	00050d1b          	sext.w	s10,a0
    109a:	fff5091b          	addiw	s2,a0,-1
    109e:	1902                	slli	s2,s2,0x20
    10a0:	02095913          	srli	s2,s2,0x20
    10a4:	996e                	add	s2,s2,s11
    10a6:	bf4d                	j	1058 <wc+0x58>
      }
    }
  }
  if(n < 0){
    10a8:	02054e63          	bltz	a0,10e4 <wc+0xe4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
    10ac:	f8043703          	ld	a4,-128(s0)
    10b0:	86e6                	mv	a3,s9
    10b2:	8662                	mv	a2,s8
    10b4:	85de                	mv	a1,s7
    10b6:	00001517          	auipc	a0,0x1
    10ba:	81a50513          	addi	a0,a0,-2022 # 18d0 <malloc+0xfe>
    10be:	00000097          	auipc	ra,0x0
    10c2:	656080e7          	jalr	1622(ra) # 1714 <printf>
}
    10c6:	70e6                	ld	ra,120(sp)
    10c8:	7446                	ld	s0,112(sp)
    10ca:	74a6                	ld	s1,104(sp)
    10cc:	7906                	ld	s2,96(sp)
    10ce:	69e6                	ld	s3,88(sp)
    10d0:	6a46                	ld	s4,80(sp)
    10d2:	6aa6                	ld	s5,72(sp)
    10d4:	6b06                	ld	s6,64(sp)
    10d6:	7be2                	ld	s7,56(sp)
    10d8:	7c42                	ld	s8,48(sp)
    10da:	7ca2                	ld	s9,40(sp)
    10dc:	7d02                	ld	s10,32(sp)
    10de:	6de2                	ld	s11,24(sp)
    10e0:	6109                	addi	sp,sp,128
    10e2:	8082                	ret
    printf("wc: read error\n");
    10e4:	00000517          	auipc	a0,0x0
    10e8:	7dc50513          	addi	a0,a0,2012 # 18c0 <malloc+0xee>
    10ec:	00000097          	auipc	ra,0x0
    10f0:	628080e7          	jalr	1576(ra) # 1714 <printf>
    exit(1);
    10f4:	4505                	li	a0,1
    10f6:	00000097          	auipc	ra,0x0
    10fa:	296080e7          	jalr	662(ra) # 138c <exit>

00000000000010fe <main>:

int
main(int argc, char *argv[])
{
    10fe:	7179                	addi	sp,sp,-48
    1100:	f406                	sd	ra,40(sp)
    1102:	f022                	sd	s0,32(sp)
    1104:	ec26                	sd	s1,24(sp)
    1106:	e84a                	sd	s2,16(sp)
    1108:	e44e                	sd	s3,8(sp)
    110a:	e052                	sd	s4,0(sp)
    110c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
    110e:	4785                	li	a5,1
    1110:	04a7d763          	bge	a5,a0,115e <main+0x60>
    1114:	00858493          	addi	s1,a1,8
    1118:	ffe5099b          	addiw	s3,a0,-2
    111c:	1982                	slli	s3,s3,0x20
    111e:	0209d993          	srli	s3,s3,0x20
    1122:	098e                	slli	s3,s3,0x3
    1124:	05c1                	addi	a1,a1,16
    1126:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
    1128:	4581                	li	a1,0
    112a:	6088                	ld	a0,0(s1)
    112c:	00000097          	auipc	ra,0x0
    1130:	2a0080e7          	jalr	672(ra) # 13cc <open>
    1134:	892a                	mv	s2,a0
    1136:	04054263          	bltz	a0,117a <main+0x7c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
    113a:	608c                	ld	a1,0(s1)
    113c:	00000097          	auipc	ra,0x0
    1140:	ec4080e7          	jalr	-316(ra) # 1000 <wc>
    close(fd);
    1144:	854a                	mv	a0,s2
    1146:	00000097          	auipc	ra,0x0
    114a:	26e080e7          	jalr	622(ra) # 13b4 <close>
  for(i = 1; i < argc; i++){
    114e:	04a1                	addi	s1,s1,8
    1150:	fd349ce3          	bne	s1,s3,1128 <main+0x2a>
  }
  exit(0);
    1154:	4501                	li	a0,0
    1156:	00000097          	auipc	ra,0x0
    115a:	236080e7          	jalr	566(ra) # 138c <exit>
    wc(0, "");
    115e:	00000597          	auipc	a1,0x0
    1162:	78258593          	addi	a1,a1,1922 # 18e0 <malloc+0x10e>
    1166:	4501                	li	a0,0
    1168:	00000097          	auipc	ra,0x0
    116c:	e98080e7          	jalr	-360(ra) # 1000 <wc>
    exit(0);
    1170:	4501                	li	a0,0
    1172:	00000097          	auipc	ra,0x0
    1176:	21a080e7          	jalr	538(ra) # 138c <exit>
      printf("wc: cannot open %s\n", argv[i]);
    117a:	608c                	ld	a1,0(s1)
    117c:	00000517          	auipc	a0,0x0
    1180:	76c50513          	addi	a0,a0,1900 # 18e8 <malloc+0x116>
    1184:	00000097          	auipc	ra,0x0
    1188:	590080e7          	jalr	1424(ra) # 1714 <printf>
      exit(1);
    118c:	4505                	li	a0,1
    118e:	00000097          	auipc	ra,0x0
    1192:	1fe080e7          	jalr	510(ra) # 138c <exit>

0000000000001196 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
    1196:	1141                	addi	sp,sp,-16
    1198:	e422                	sd	s0,8(sp)
    119a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    119c:	87aa                	mv	a5,a0
    119e:	0585                	addi	a1,a1,1
    11a0:	0785                	addi	a5,a5,1
    11a2:	fff5c703          	lbu	a4,-1(a1)
    11a6:	fee78fa3          	sb	a4,-1(a5)
    11aa:	fb75                	bnez	a4,119e <strcpy+0x8>
    ;
  return os;
}
    11ac:	6422                	ld	s0,8(sp)
    11ae:	0141                	addi	sp,sp,16
    11b0:	8082                	ret

00000000000011b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    11b2:	1141                	addi	sp,sp,-16
    11b4:	e422                	sd	s0,8(sp)
    11b6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    11b8:	00054783          	lbu	a5,0(a0)
    11bc:	cb91                	beqz	a5,11d0 <strcmp+0x1e>
    11be:	0005c703          	lbu	a4,0(a1)
    11c2:	00f71763          	bne	a4,a5,11d0 <strcmp+0x1e>
    p++, q++;
    11c6:	0505                	addi	a0,a0,1
    11c8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    11ca:	00054783          	lbu	a5,0(a0)
    11ce:	fbe5                	bnez	a5,11be <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    11d0:	0005c503          	lbu	a0,0(a1)
}
    11d4:	40a7853b          	subw	a0,a5,a0
    11d8:	6422                	ld	s0,8(sp)
    11da:	0141                	addi	sp,sp,16
    11dc:	8082                	ret

00000000000011de <strlen>:

uint
strlen(const char *s)
{
    11de:	1141                	addi	sp,sp,-16
    11e0:	e422                	sd	s0,8(sp)
    11e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    11e4:	00054783          	lbu	a5,0(a0)
    11e8:	cf91                	beqz	a5,1204 <strlen+0x26>
    11ea:	0505                	addi	a0,a0,1
    11ec:	87aa                	mv	a5,a0
    11ee:	4685                	li	a3,1
    11f0:	9e89                	subw	a3,a3,a0
    11f2:	00f6853b          	addw	a0,a3,a5
    11f6:	0785                	addi	a5,a5,1
    11f8:	fff7c703          	lbu	a4,-1(a5)
    11fc:	fb7d                	bnez	a4,11f2 <strlen+0x14>
    ;
  return n;
}
    11fe:	6422                	ld	s0,8(sp)
    1200:	0141                	addi	sp,sp,16
    1202:	8082                	ret
  for(n = 0; s[n]; n++)
    1204:	4501                	li	a0,0
    1206:	bfe5                	j	11fe <strlen+0x20>

0000000000001208 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1208:	1141                	addi	sp,sp,-16
    120a:	e422                	sd	s0,8(sp)
    120c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    120e:	ce09                	beqz	a2,1228 <memset+0x20>
    1210:	87aa                	mv	a5,a0
    1212:	fff6071b          	addiw	a4,a2,-1
    1216:	1702                	slli	a4,a4,0x20
    1218:	9301                	srli	a4,a4,0x20
    121a:	0705                	addi	a4,a4,1
    121c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    121e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    1222:	0785                	addi	a5,a5,1
    1224:	fee79de3          	bne	a5,a4,121e <memset+0x16>
  }
  return dst;
}
    1228:	6422                	ld	s0,8(sp)
    122a:	0141                	addi	sp,sp,16
    122c:	8082                	ret

000000000000122e <strchr>:

char*
strchr(const char *s, char c)
{
    122e:	1141                	addi	sp,sp,-16
    1230:	e422                	sd	s0,8(sp)
    1232:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1234:	00054783          	lbu	a5,0(a0)
    1238:	cb99                	beqz	a5,124e <strchr+0x20>
    if(*s == c)
    123a:	00f58763          	beq	a1,a5,1248 <strchr+0x1a>
  for(; *s; s++)
    123e:	0505                	addi	a0,a0,1
    1240:	00054783          	lbu	a5,0(a0)
    1244:	fbfd                	bnez	a5,123a <strchr+0xc>
      return (char*)s;
  return 0;
    1246:	4501                	li	a0,0
}
    1248:	6422                	ld	s0,8(sp)
    124a:	0141                	addi	sp,sp,16
    124c:	8082                	ret
  return 0;
    124e:	4501                	li	a0,0
    1250:	bfe5                	j	1248 <strchr+0x1a>

0000000000001252 <gets>:

char*
gets(char *buf, int max)
{
    1252:	711d                	addi	sp,sp,-96
    1254:	ec86                	sd	ra,88(sp)
    1256:	e8a2                	sd	s0,80(sp)
    1258:	e4a6                	sd	s1,72(sp)
    125a:	e0ca                	sd	s2,64(sp)
    125c:	fc4e                	sd	s3,56(sp)
    125e:	f852                	sd	s4,48(sp)
    1260:	f456                	sd	s5,40(sp)
    1262:	f05a                	sd	s6,32(sp)
    1264:	ec5e                	sd	s7,24(sp)
    1266:	1080                	addi	s0,sp,96
    1268:	8baa                	mv	s7,a0
    126a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    126c:	892a                	mv	s2,a0
    126e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1270:	4aa9                	li	s5,10
    1272:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1274:	89a6                	mv	s3,s1
    1276:	2485                	addiw	s1,s1,1
    1278:	0344d863          	bge	s1,s4,12a8 <gets+0x56>
    cc = read(0, &c, 1);
    127c:	4605                	li	a2,1
    127e:	faf40593          	addi	a1,s0,-81
    1282:	4501                	li	a0,0
    1284:	00000097          	auipc	ra,0x0
    1288:	120080e7          	jalr	288(ra) # 13a4 <read>
    if(cc < 1)
    128c:	00a05e63          	blez	a0,12a8 <gets+0x56>
    buf[i++] = c;
    1290:	faf44783          	lbu	a5,-81(s0)
    1294:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1298:	01578763          	beq	a5,s5,12a6 <gets+0x54>
    129c:	0905                	addi	s2,s2,1
    129e:	fd679be3          	bne	a5,s6,1274 <gets+0x22>
  for(i=0; i+1 < max; ){
    12a2:	89a6                	mv	s3,s1
    12a4:	a011                	j	12a8 <gets+0x56>
    12a6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    12a8:	99de                	add	s3,s3,s7
    12aa:	00098023          	sb	zero,0(s3)
  return buf;
}
    12ae:	855e                	mv	a0,s7
    12b0:	60e6                	ld	ra,88(sp)
    12b2:	6446                	ld	s0,80(sp)
    12b4:	64a6                	ld	s1,72(sp)
    12b6:	6906                	ld	s2,64(sp)
    12b8:	79e2                	ld	s3,56(sp)
    12ba:	7a42                	ld	s4,48(sp)
    12bc:	7aa2                	ld	s5,40(sp)
    12be:	7b02                	ld	s6,32(sp)
    12c0:	6be2                	ld	s7,24(sp)
    12c2:	6125                	addi	sp,sp,96
    12c4:	8082                	ret

00000000000012c6 <stat>:

int
stat(const char *n, struct stat *st)
{
    12c6:	1101                	addi	sp,sp,-32
    12c8:	ec06                	sd	ra,24(sp)
    12ca:	e822                	sd	s0,16(sp)
    12cc:	e426                	sd	s1,8(sp)
    12ce:	e04a                	sd	s2,0(sp)
    12d0:	1000                	addi	s0,sp,32
    12d2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12d4:	4581                	li	a1,0
    12d6:	00000097          	auipc	ra,0x0
    12da:	0f6080e7          	jalr	246(ra) # 13cc <open>
  if(fd < 0)
    12de:	02054563          	bltz	a0,1308 <stat+0x42>
    12e2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    12e4:	85ca                	mv	a1,s2
    12e6:	00000097          	auipc	ra,0x0
    12ea:	0fe080e7          	jalr	254(ra) # 13e4 <fstat>
    12ee:	892a                	mv	s2,a0
  close(fd);
    12f0:	8526                	mv	a0,s1
    12f2:	00000097          	auipc	ra,0x0
    12f6:	0c2080e7          	jalr	194(ra) # 13b4 <close>
  return r;
}
    12fa:	854a                	mv	a0,s2
    12fc:	60e2                	ld	ra,24(sp)
    12fe:	6442                	ld	s0,16(sp)
    1300:	64a2                	ld	s1,8(sp)
    1302:	6902                	ld	s2,0(sp)
    1304:	6105                	addi	sp,sp,32
    1306:	8082                	ret
    return -1;
    1308:	597d                	li	s2,-1
    130a:	bfc5                	j	12fa <stat+0x34>

000000000000130c <atoi>:

int
atoi(const char *s)
{
    130c:	1141                	addi	sp,sp,-16
    130e:	e422                	sd	s0,8(sp)
    1310:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1312:	00054603          	lbu	a2,0(a0)
    1316:	fd06079b          	addiw	a5,a2,-48
    131a:	0ff7f793          	andi	a5,a5,255
    131e:	4725                	li	a4,9
    1320:	02f76963          	bltu	a4,a5,1352 <atoi+0x46>
    1324:	86aa                	mv	a3,a0
  n = 0;
    1326:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    1328:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    132a:	0685                	addi	a3,a3,1
    132c:	0025179b          	slliw	a5,a0,0x2
    1330:	9fa9                	addw	a5,a5,a0
    1332:	0017979b          	slliw	a5,a5,0x1
    1336:	9fb1                	addw	a5,a5,a2
    1338:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    133c:	0006c603          	lbu	a2,0(a3)
    1340:	fd06071b          	addiw	a4,a2,-48
    1344:	0ff77713          	andi	a4,a4,255
    1348:	fee5f1e3          	bgeu	a1,a4,132a <atoi+0x1e>
  return n;
}
    134c:	6422                	ld	s0,8(sp)
    134e:	0141                	addi	sp,sp,16
    1350:	8082                	ret
  n = 0;
    1352:	4501                	li	a0,0
    1354:	bfe5                	j	134c <atoi+0x40>

0000000000001356 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1356:	1141                	addi	sp,sp,-16
    1358:	e422                	sd	s0,8(sp)
    135a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    135c:	02c05163          	blez	a2,137e <memmove+0x28>
    1360:	fff6071b          	addiw	a4,a2,-1
    1364:	1702                	slli	a4,a4,0x20
    1366:	9301                	srli	a4,a4,0x20
    1368:	0705                	addi	a4,a4,1
    136a:	972a                	add	a4,a4,a0
  dst = vdst;
    136c:	87aa                	mv	a5,a0
    *dst++ = *src++;
    136e:	0585                	addi	a1,a1,1
    1370:	0785                	addi	a5,a5,1
    1372:	fff5c683          	lbu	a3,-1(a1)
    1376:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    137a:	fee79ae3          	bne	a5,a4,136e <memmove+0x18>
  return vdst;
}
    137e:	6422                	ld	s0,8(sp)
    1380:	0141                	addi	sp,sp,16
    1382:	8082                	ret

0000000000001384 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1384:	4885                	li	a7,1
 ecall
    1386:	00000073          	ecall
 ret
    138a:	8082                	ret

000000000000138c <exit>:
.global exit
exit:
 li a7, SYS_exit
    138c:	4889                	li	a7,2
 ecall
    138e:	00000073          	ecall
 ret
    1392:	8082                	ret

0000000000001394 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1394:	488d                	li	a7,3
 ecall
    1396:	00000073          	ecall
 ret
    139a:	8082                	ret

000000000000139c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    139c:	4891                	li	a7,4
 ecall
    139e:	00000073          	ecall
 ret
    13a2:	8082                	ret

00000000000013a4 <read>:
.global read
read:
 li a7, SYS_read
    13a4:	4895                	li	a7,5
 ecall
    13a6:	00000073          	ecall
 ret
    13aa:	8082                	ret

00000000000013ac <write>:
.global write
write:
 li a7, SYS_write
    13ac:	48c1                	li	a7,16
 ecall
    13ae:	00000073          	ecall
 ret
    13b2:	8082                	ret

00000000000013b4 <close>:
.global close
close:
 li a7, SYS_close
    13b4:	48d5                	li	a7,21
 ecall
    13b6:	00000073          	ecall
 ret
    13ba:	8082                	ret

00000000000013bc <kill>:
.global kill
kill:
 li a7, SYS_kill
    13bc:	4899                	li	a7,6
 ecall
    13be:	00000073          	ecall
 ret
    13c2:	8082                	ret

00000000000013c4 <exec>:
.global exec
exec:
 li a7, SYS_exec
    13c4:	489d                	li	a7,7
 ecall
    13c6:	00000073          	ecall
 ret
    13ca:	8082                	ret

00000000000013cc <open>:
.global open
open:
 li a7, SYS_open
    13cc:	48bd                	li	a7,15
 ecall
    13ce:	00000073          	ecall
 ret
    13d2:	8082                	ret

00000000000013d4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    13d4:	48c5                	li	a7,17
 ecall
    13d6:	00000073          	ecall
 ret
    13da:	8082                	ret

00000000000013dc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    13dc:	48c9                	li	a7,18
 ecall
    13de:	00000073          	ecall
 ret
    13e2:	8082                	ret

00000000000013e4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    13e4:	48a1                	li	a7,8
 ecall
    13e6:	00000073          	ecall
 ret
    13ea:	8082                	ret

00000000000013ec <link>:
.global link
link:
 li a7, SYS_link
    13ec:	48cd                	li	a7,19
 ecall
    13ee:	00000073          	ecall
 ret
    13f2:	8082                	ret

00000000000013f4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    13f4:	48d1                	li	a7,20
 ecall
    13f6:	00000073          	ecall
 ret
    13fa:	8082                	ret

00000000000013fc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    13fc:	48a5                	li	a7,9
 ecall
    13fe:	00000073          	ecall
 ret
    1402:	8082                	ret

0000000000001404 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1404:	48a9                	li	a7,10
 ecall
    1406:	00000073          	ecall
 ret
    140a:	8082                	ret

000000000000140c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    140c:	48ad                	li	a7,11
 ecall
    140e:	00000073          	ecall
 ret
    1412:	8082                	ret

0000000000001414 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1414:	48b1                	li	a7,12
 ecall
    1416:	00000073          	ecall
 ret
    141a:	8082                	ret

000000000000141c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    141c:	48b5                	li	a7,13
 ecall
    141e:	00000073          	ecall
 ret
    1422:	8082                	ret

0000000000001424 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1424:	48b9                	li	a7,14
 ecall
    1426:	00000073          	ecall
 ret
    142a:	8082                	ret

000000000000142c <mprotect>:
.global mprotect
mprotect:
 li a7, SYS_mprotect
    142c:	48d9                	li	a7,22
 ecall
    142e:	00000073          	ecall
 ret
    1432:	8082                	ret

0000000000001434 <munprotect>:
.global munprotect
munprotect:
 li a7, SYS_munprotect
    1434:	48dd                	li	a7,23
 ecall
    1436:	00000073          	ecall
 ret
    143a:	8082                	ret

000000000000143c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    143c:	1101                	addi	sp,sp,-32
    143e:	ec06                	sd	ra,24(sp)
    1440:	e822                	sd	s0,16(sp)
    1442:	1000                	addi	s0,sp,32
    1444:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1448:	4605                	li	a2,1
    144a:	fef40593          	addi	a1,s0,-17
    144e:	00000097          	auipc	ra,0x0
    1452:	f5e080e7          	jalr	-162(ra) # 13ac <write>
}
    1456:	60e2                	ld	ra,24(sp)
    1458:	6442                	ld	s0,16(sp)
    145a:	6105                	addi	sp,sp,32
    145c:	8082                	ret

000000000000145e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    145e:	7139                	addi	sp,sp,-64
    1460:	fc06                	sd	ra,56(sp)
    1462:	f822                	sd	s0,48(sp)
    1464:	f426                	sd	s1,40(sp)
    1466:	f04a                	sd	s2,32(sp)
    1468:	ec4e                	sd	s3,24(sp)
    146a:	0080                	addi	s0,sp,64
    146c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    146e:	c299                	beqz	a3,1474 <printint+0x16>
    1470:	0805c863          	bltz	a1,1500 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1474:	2581                	sext.w	a1,a1
  neg = 0;
    1476:	4881                	li	a7,0
    1478:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    147c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    147e:	2601                	sext.w	a2,a2
    1480:	00000517          	auipc	a0,0x0
    1484:	48850513          	addi	a0,a0,1160 # 1908 <digits>
    1488:	883a                	mv	a6,a4
    148a:	2705                	addiw	a4,a4,1
    148c:	02c5f7bb          	remuw	a5,a1,a2
    1490:	1782                	slli	a5,a5,0x20
    1492:	9381                	srli	a5,a5,0x20
    1494:	97aa                	add	a5,a5,a0
    1496:	0007c783          	lbu	a5,0(a5)
    149a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    149e:	0005879b          	sext.w	a5,a1
    14a2:	02c5d5bb          	divuw	a1,a1,a2
    14a6:	0685                	addi	a3,a3,1
    14a8:	fec7f0e3          	bgeu	a5,a2,1488 <printint+0x2a>
  if(neg)
    14ac:	00088b63          	beqz	a7,14c2 <printint+0x64>
    buf[i++] = '-';
    14b0:	fd040793          	addi	a5,s0,-48
    14b4:	973e                	add	a4,a4,a5
    14b6:	02d00793          	li	a5,45
    14ba:	fef70823          	sb	a5,-16(a4)
    14be:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    14c2:	02e05863          	blez	a4,14f2 <printint+0x94>
    14c6:	fc040793          	addi	a5,s0,-64
    14ca:	00e78933          	add	s2,a5,a4
    14ce:	fff78993          	addi	s3,a5,-1
    14d2:	99ba                	add	s3,s3,a4
    14d4:	377d                	addiw	a4,a4,-1
    14d6:	1702                	slli	a4,a4,0x20
    14d8:	9301                	srli	a4,a4,0x20
    14da:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    14de:	fff94583          	lbu	a1,-1(s2)
    14e2:	8526                	mv	a0,s1
    14e4:	00000097          	auipc	ra,0x0
    14e8:	f58080e7          	jalr	-168(ra) # 143c <putc>
  while(--i >= 0)
    14ec:	197d                	addi	s2,s2,-1
    14ee:	ff3918e3          	bne	s2,s3,14de <printint+0x80>
}
    14f2:	70e2                	ld	ra,56(sp)
    14f4:	7442                	ld	s0,48(sp)
    14f6:	74a2                	ld	s1,40(sp)
    14f8:	7902                	ld	s2,32(sp)
    14fa:	69e2                	ld	s3,24(sp)
    14fc:	6121                	addi	sp,sp,64
    14fe:	8082                	ret
    x = -xx;
    1500:	40b005bb          	negw	a1,a1
    neg = 1;
    1504:	4885                	li	a7,1
    x = -xx;
    1506:	bf8d                	j	1478 <printint+0x1a>

0000000000001508 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1508:	7119                	addi	sp,sp,-128
    150a:	fc86                	sd	ra,120(sp)
    150c:	f8a2                	sd	s0,112(sp)
    150e:	f4a6                	sd	s1,104(sp)
    1510:	f0ca                	sd	s2,96(sp)
    1512:	ecce                	sd	s3,88(sp)
    1514:	e8d2                	sd	s4,80(sp)
    1516:	e4d6                	sd	s5,72(sp)
    1518:	e0da                	sd	s6,64(sp)
    151a:	fc5e                	sd	s7,56(sp)
    151c:	f862                	sd	s8,48(sp)
    151e:	f466                	sd	s9,40(sp)
    1520:	f06a                	sd	s10,32(sp)
    1522:	ec6e                	sd	s11,24(sp)
    1524:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1526:	0005c903          	lbu	s2,0(a1)
    152a:	18090f63          	beqz	s2,16c8 <vprintf+0x1c0>
    152e:	8aaa                	mv	s5,a0
    1530:	8b32                	mv	s6,a2
    1532:	00158493          	addi	s1,a1,1
  state = 0;
    1536:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1538:	02500a13          	li	s4,37
      if(c == 'd'){
    153c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    1540:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    1544:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    1548:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    154c:	00000b97          	auipc	s7,0x0
    1550:	3bcb8b93          	addi	s7,s7,956 # 1908 <digits>
    1554:	a839                	j	1572 <vprintf+0x6a>
        putc(fd, c);
    1556:	85ca                	mv	a1,s2
    1558:	8556                	mv	a0,s5
    155a:	00000097          	auipc	ra,0x0
    155e:	ee2080e7          	jalr	-286(ra) # 143c <putc>
    1562:	a019                	j	1568 <vprintf+0x60>
    } else if(state == '%'){
    1564:	01498f63          	beq	s3,s4,1582 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    1568:	0485                	addi	s1,s1,1
    156a:	fff4c903          	lbu	s2,-1(s1)
    156e:	14090d63          	beqz	s2,16c8 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    1572:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1576:	fe0997e3          	bnez	s3,1564 <vprintf+0x5c>
      if(c == '%'){
    157a:	fd479ee3          	bne	a5,s4,1556 <vprintf+0x4e>
        state = '%';
    157e:	89be                	mv	s3,a5
    1580:	b7e5                	j	1568 <vprintf+0x60>
      if(c == 'd'){
    1582:	05878063          	beq	a5,s8,15c2 <vprintf+0xba>
      } else if(c == 'l') {
    1586:	05978c63          	beq	a5,s9,15de <vprintf+0xd6>
      } else if(c == 'x') {
    158a:	07a78863          	beq	a5,s10,15fa <vprintf+0xf2>
      } else if(c == 'p') {
    158e:	09b78463          	beq	a5,s11,1616 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    1592:	07300713          	li	a4,115
    1596:	0ce78663          	beq	a5,a4,1662 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    159a:	06300713          	li	a4,99
    159e:	0ee78e63          	beq	a5,a4,169a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    15a2:	11478863          	beq	a5,s4,16b2 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15a6:	85d2                	mv	a1,s4
    15a8:	8556                	mv	a0,s5
    15aa:	00000097          	auipc	ra,0x0
    15ae:	e92080e7          	jalr	-366(ra) # 143c <putc>
        putc(fd, c);
    15b2:	85ca                	mv	a1,s2
    15b4:	8556                	mv	a0,s5
    15b6:	00000097          	auipc	ra,0x0
    15ba:	e86080e7          	jalr	-378(ra) # 143c <putc>
      }
      state = 0;
    15be:	4981                	li	s3,0
    15c0:	b765                	j	1568 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    15c2:	008b0913          	addi	s2,s6,8
    15c6:	4685                	li	a3,1
    15c8:	4629                	li	a2,10
    15ca:	000b2583          	lw	a1,0(s6)
    15ce:	8556                	mv	a0,s5
    15d0:	00000097          	auipc	ra,0x0
    15d4:	e8e080e7          	jalr	-370(ra) # 145e <printint>
    15d8:	8b4a                	mv	s6,s2
      state = 0;
    15da:	4981                	li	s3,0
    15dc:	b771                	j	1568 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    15de:	008b0913          	addi	s2,s6,8
    15e2:	4681                	li	a3,0
    15e4:	4629                	li	a2,10
    15e6:	000b2583          	lw	a1,0(s6)
    15ea:	8556                	mv	a0,s5
    15ec:	00000097          	auipc	ra,0x0
    15f0:	e72080e7          	jalr	-398(ra) # 145e <printint>
    15f4:	8b4a                	mv	s6,s2
      state = 0;
    15f6:	4981                	li	s3,0
    15f8:	bf85                	j	1568 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    15fa:	008b0913          	addi	s2,s6,8
    15fe:	4681                	li	a3,0
    1600:	4641                	li	a2,16
    1602:	000b2583          	lw	a1,0(s6)
    1606:	8556                	mv	a0,s5
    1608:	00000097          	auipc	ra,0x0
    160c:	e56080e7          	jalr	-426(ra) # 145e <printint>
    1610:	8b4a                	mv	s6,s2
      state = 0;
    1612:	4981                	li	s3,0
    1614:	bf91                	j	1568 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1616:	008b0793          	addi	a5,s6,8
    161a:	f8f43423          	sd	a5,-120(s0)
    161e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1622:	03000593          	li	a1,48
    1626:	8556                	mv	a0,s5
    1628:	00000097          	auipc	ra,0x0
    162c:	e14080e7          	jalr	-492(ra) # 143c <putc>
  putc(fd, 'x');
    1630:	85ea                	mv	a1,s10
    1632:	8556                	mv	a0,s5
    1634:	00000097          	auipc	ra,0x0
    1638:	e08080e7          	jalr	-504(ra) # 143c <putc>
    163c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    163e:	03c9d793          	srli	a5,s3,0x3c
    1642:	97de                	add	a5,a5,s7
    1644:	0007c583          	lbu	a1,0(a5)
    1648:	8556                	mv	a0,s5
    164a:	00000097          	auipc	ra,0x0
    164e:	df2080e7          	jalr	-526(ra) # 143c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1652:	0992                	slli	s3,s3,0x4
    1654:	397d                	addiw	s2,s2,-1
    1656:	fe0914e3          	bnez	s2,163e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    165a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    165e:	4981                	li	s3,0
    1660:	b721                	j	1568 <vprintf+0x60>
        s = va_arg(ap, char*);
    1662:	008b0993          	addi	s3,s6,8
    1666:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    166a:	02090163          	beqz	s2,168c <vprintf+0x184>
        while(*s != 0){
    166e:	00094583          	lbu	a1,0(s2)
    1672:	c9a1                	beqz	a1,16c2 <vprintf+0x1ba>
          putc(fd, *s);
    1674:	8556                	mv	a0,s5
    1676:	00000097          	auipc	ra,0x0
    167a:	dc6080e7          	jalr	-570(ra) # 143c <putc>
          s++;
    167e:	0905                	addi	s2,s2,1
        while(*s != 0){
    1680:	00094583          	lbu	a1,0(s2)
    1684:	f9e5                	bnez	a1,1674 <vprintf+0x16c>
        s = va_arg(ap, char*);
    1686:	8b4e                	mv	s6,s3
      state = 0;
    1688:	4981                	li	s3,0
    168a:	bdf9                	j	1568 <vprintf+0x60>
          s = "(null)";
    168c:	00000917          	auipc	s2,0x0
    1690:	27490913          	addi	s2,s2,628 # 1900 <malloc+0x12e>
        while(*s != 0){
    1694:	02800593          	li	a1,40
    1698:	bff1                	j	1674 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    169a:	008b0913          	addi	s2,s6,8
    169e:	000b4583          	lbu	a1,0(s6)
    16a2:	8556                	mv	a0,s5
    16a4:	00000097          	auipc	ra,0x0
    16a8:	d98080e7          	jalr	-616(ra) # 143c <putc>
    16ac:	8b4a                	mv	s6,s2
      state = 0;
    16ae:	4981                	li	s3,0
    16b0:	bd65                	j	1568 <vprintf+0x60>
        putc(fd, c);
    16b2:	85d2                	mv	a1,s4
    16b4:	8556                	mv	a0,s5
    16b6:	00000097          	auipc	ra,0x0
    16ba:	d86080e7          	jalr	-634(ra) # 143c <putc>
      state = 0;
    16be:	4981                	li	s3,0
    16c0:	b565                	j	1568 <vprintf+0x60>
        s = va_arg(ap, char*);
    16c2:	8b4e                	mv	s6,s3
      state = 0;
    16c4:	4981                	li	s3,0
    16c6:	b54d                	j	1568 <vprintf+0x60>
    }
  }
}
    16c8:	70e6                	ld	ra,120(sp)
    16ca:	7446                	ld	s0,112(sp)
    16cc:	74a6                	ld	s1,104(sp)
    16ce:	7906                	ld	s2,96(sp)
    16d0:	69e6                	ld	s3,88(sp)
    16d2:	6a46                	ld	s4,80(sp)
    16d4:	6aa6                	ld	s5,72(sp)
    16d6:	6b06                	ld	s6,64(sp)
    16d8:	7be2                	ld	s7,56(sp)
    16da:	7c42                	ld	s8,48(sp)
    16dc:	7ca2                	ld	s9,40(sp)
    16de:	7d02                	ld	s10,32(sp)
    16e0:	6de2                	ld	s11,24(sp)
    16e2:	6109                	addi	sp,sp,128
    16e4:	8082                	ret

00000000000016e6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    16e6:	715d                	addi	sp,sp,-80
    16e8:	ec06                	sd	ra,24(sp)
    16ea:	e822                	sd	s0,16(sp)
    16ec:	1000                	addi	s0,sp,32
    16ee:	e010                	sd	a2,0(s0)
    16f0:	e414                	sd	a3,8(s0)
    16f2:	e818                	sd	a4,16(s0)
    16f4:	ec1c                	sd	a5,24(s0)
    16f6:	03043023          	sd	a6,32(s0)
    16fa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    16fe:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1702:	8622                	mv	a2,s0
    1704:	00000097          	auipc	ra,0x0
    1708:	e04080e7          	jalr	-508(ra) # 1508 <vprintf>
}
    170c:	60e2                	ld	ra,24(sp)
    170e:	6442                	ld	s0,16(sp)
    1710:	6161                	addi	sp,sp,80
    1712:	8082                	ret

0000000000001714 <printf>:

void
printf(const char *fmt, ...)
{
    1714:	711d                	addi	sp,sp,-96
    1716:	ec06                	sd	ra,24(sp)
    1718:	e822                	sd	s0,16(sp)
    171a:	1000                	addi	s0,sp,32
    171c:	e40c                	sd	a1,8(s0)
    171e:	e810                	sd	a2,16(s0)
    1720:	ec14                	sd	a3,24(s0)
    1722:	f018                	sd	a4,32(s0)
    1724:	f41c                	sd	a5,40(s0)
    1726:	03043823          	sd	a6,48(s0)
    172a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    172e:	00840613          	addi	a2,s0,8
    1732:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1736:	85aa                	mv	a1,a0
    1738:	4505                	li	a0,1
    173a:	00000097          	auipc	ra,0x0
    173e:	dce080e7          	jalr	-562(ra) # 1508 <vprintf>
}
    1742:	60e2                	ld	ra,24(sp)
    1744:	6442                	ld	s0,16(sp)
    1746:	6125                	addi	sp,sp,96
    1748:	8082                	ret

000000000000174a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    174a:	1141                	addi	sp,sp,-16
    174c:	e422                	sd	s0,8(sp)
    174e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1750:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1754:	00000797          	auipc	a5,0x0
    1758:	1cc7b783          	ld	a5,460(a5) # 1920 <freep>
    175c:	a805                	j	178c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    175e:	4618                	lw	a4,8(a2)
    1760:	9db9                	addw	a1,a1,a4
    1762:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1766:	6398                	ld	a4,0(a5)
    1768:	6318                	ld	a4,0(a4)
    176a:	fee53823          	sd	a4,-16(a0)
    176e:	a091                	j	17b2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1770:	ff852703          	lw	a4,-8(a0)
    1774:	9e39                	addw	a2,a2,a4
    1776:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1778:	ff053703          	ld	a4,-16(a0)
    177c:	e398                	sd	a4,0(a5)
    177e:	a099                	j	17c4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1780:	6398                	ld	a4,0(a5)
    1782:	00e7e463          	bltu	a5,a4,178a <free+0x40>
    1786:	00e6ea63          	bltu	a3,a4,179a <free+0x50>
{
    178a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    178c:	fed7fae3          	bgeu	a5,a3,1780 <free+0x36>
    1790:	6398                	ld	a4,0(a5)
    1792:	00e6e463          	bltu	a3,a4,179a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1796:	fee7eae3          	bltu	a5,a4,178a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    179a:	ff852583          	lw	a1,-8(a0)
    179e:	6390                	ld	a2,0(a5)
    17a0:	02059713          	slli	a4,a1,0x20
    17a4:	9301                	srli	a4,a4,0x20
    17a6:	0712                	slli	a4,a4,0x4
    17a8:	9736                	add	a4,a4,a3
    17aa:	fae60ae3          	beq	a2,a4,175e <free+0x14>
    bp->s.ptr = p->s.ptr;
    17ae:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    17b2:	4790                	lw	a2,8(a5)
    17b4:	02061713          	slli	a4,a2,0x20
    17b8:	9301                	srli	a4,a4,0x20
    17ba:	0712                	slli	a4,a4,0x4
    17bc:	973e                	add	a4,a4,a5
    17be:	fae689e3          	beq	a3,a4,1770 <free+0x26>
  } else
    p->s.ptr = bp;
    17c2:	e394                	sd	a3,0(a5)
  freep = p;
    17c4:	00000717          	auipc	a4,0x0
    17c8:	14f73e23          	sd	a5,348(a4) # 1920 <freep>
}
    17cc:	6422                	ld	s0,8(sp)
    17ce:	0141                	addi	sp,sp,16
    17d0:	8082                	ret

00000000000017d2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    17d2:	7139                	addi	sp,sp,-64
    17d4:	fc06                	sd	ra,56(sp)
    17d6:	f822                	sd	s0,48(sp)
    17d8:	f426                	sd	s1,40(sp)
    17da:	f04a                	sd	s2,32(sp)
    17dc:	ec4e                	sd	s3,24(sp)
    17de:	e852                	sd	s4,16(sp)
    17e0:	e456                	sd	s5,8(sp)
    17e2:	e05a                	sd	s6,0(sp)
    17e4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17e6:	02051493          	slli	s1,a0,0x20
    17ea:	9081                	srli	s1,s1,0x20
    17ec:	04bd                	addi	s1,s1,15
    17ee:	8091                	srli	s1,s1,0x4
    17f0:	0014899b          	addiw	s3,s1,1
    17f4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    17f6:	00000517          	auipc	a0,0x0
    17fa:	12a53503          	ld	a0,298(a0) # 1920 <freep>
    17fe:	c515                	beqz	a0,182a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1800:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1802:	4798                	lw	a4,8(a5)
    1804:	02977f63          	bgeu	a4,s1,1842 <malloc+0x70>
    1808:	8a4e                	mv	s4,s3
    180a:	0009871b          	sext.w	a4,s3
    180e:	6685                	lui	a3,0x1
    1810:	00d77363          	bgeu	a4,a3,1816 <malloc+0x44>
    1814:	6a05                	lui	s4,0x1
    1816:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    181a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    181e:	00000917          	auipc	s2,0x0
    1822:	10290913          	addi	s2,s2,258 # 1920 <freep>
  if(p == (char*)-1)
    1826:	5afd                	li	s5,-1
    1828:	a88d                	j	189a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    182a:	00000797          	auipc	a5,0x0
    182e:	2fe78793          	addi	a5,a5,766 # 1b28 <base>
    1832:	00000717          	auipc	a4,0x0
    1836:	0ef73723          	sd	a5,238(a4) # 1920 <freep>
    183a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    183c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1840:	b7e1                	j	1808 <malloc+0x36>
      if(p->s.size == nunits)
    1842:	02e48b63          	beq	s1,a4,1878 <malloc+0xa6>
        p->s.size -= nunits;
    1846:	4137073b          	subw	a4,a4,s3
    184a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    184c:	1702                	slli	a4,a4,0x20
    184e:	9301                	srli	a4,a4,0x20
    1850:	0712                	slli	a4,a4,0x4
    1852:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1854:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1858:	00000717          	auipc	a4,0x0
    185c:	0ca73423          	sd	a0,200(a4) # 1920 <freep>
      return (void*)(p + 1);
    1860:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1864:	70e2                	ld	ra,56(sp)
    1866:	7442                	ld	s0,48(sp)
    1868:	74a2                	ld	s1,40(sp)
    186a:	7902                	ld	s2,32(sp)
    186c:	69e2                	ld	s3,24(sp)
    186e:	6a42                	ld	s4,16(sp)
    1870:	6aa2                	ld	s5,8(sp)
    1872:	6b02                	ld	s6,0(sp)
    1874:	6121                	addi	sp,sp,64
    1876:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1878:	6398                	ld	a4,0(a5)
    187a:	e118                	sd	a4,0(a0)
    187c:	bff1                	j	1858 <malloc+0x86>
  hp->s.size = nu;
    187e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1882:	0541                	addi	a0,a0,16
    1884:	00000097          	auipc	ra,0x0
    1888:	ec6080e7          	jalr	-314(ra) # 174a <free>
  return freep;
    188c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1890:	d971                	beqz	a0,1864 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1892:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1894:	4798                	lw	a4,8(a5)
    1896:	fa9776e3          	bgeu	a4,s1,1842 <malloc+0x70>
    if(p == freep)
    189a:	00093703          	ld	a4,0(s2)
    189e:	853e                	mv	a0,a5
    18a0:	fef719e3          	bne	a4,a5,1892 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    18a4:	8552                	mv	a0,s4
    18a6:	00000097          	auipc	ra,0x0
    18aa:	b6e080e7          	jalr	-1170(ra) # 1414 <sbrk>
  if(p == (char*)-1)
    18ae:	fd5518e3          	bne	a0,s5,187e <malloc+0xac>
        return 0;
    18b2:	4501                	li	a0,0
    18b4:	bf45                	j	1864 <malloc+0x92>
