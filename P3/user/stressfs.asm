
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
    1000:	dd010113          	addi	sp,sp,-560
    1004:	22113423          	sd	ra,552(sp)
    1008:	22813023          	sd	s0,544(sp)
    100c:	20913c23          	sd	s1,536(sp)
    1010:	21213823          	sd	s2,528(sp)
    1014:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
    1016:	00001797          	auipc	a5,0x1
    101a:	84a78793          	addi	a5,a5,-1974 # 1860 <malloc+0x118>
    101e:	6398                	ld	a4,0(a5)
    1020:	fce43823          	sd	a4,-48(s0)
    1024:	0087d783          	lhu	a5,8(a5)
    1028:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
    102c:	00001517          	auipc	a0,0x1
    1030:	80450513          	addi	a0,a0,-2044 # 1830 <malloc+0xe8>
    1034:	00000097          	auipc	ra,0x0
    1038:	656080e7          	jalr	1622(ra) # 168a <printf>
  memset(data, 'a', sizeof(data));
    103c:	20000613          	li	a2,512
    1040:	06100593          	li	a1,97
    1044:	dd040513          	addi	a0,s0,-560
    1048:	00000097          	auipc	ra,0x0
    104c:	136080e7          	jalr	310(ra) # 117e <memset>

  for(i = 0; i < 4; i++)
    1050:	4481                	li	s1,0
    1052:	4911                	li	s2,4
    if(fork() > 0)
    1054:	00000097          	auipc	ra,0x0
    1058:	2a6080e7          	jalr	678(ra) # 12fa <fork>
    105c:	00a04563          	bgtz	a0,1066 <main+0x66>
  for(i = 0; i < 4; i++)
    1060:	2485                	addiw	s1,s1,1
    1062:	ff2499e3          	bne	s1,s2,1054 <main+0x54>
      break;

  printf("write %d\n", i);
    1066:	85a6                	mv	a1,s1
    1068:	00000517          	auipc	a0,0x0
    106c:	7e050513          	addi	a0,a0,2016 # 1848 <malloc+0x100>
    1070:	00000097          	auipc	ra,0x0
    1074:	61a080e7          	jalr	1562(ra) # 168a <printf>

  path[8] += i;
    1078:	fd844783          	lbu	a5,-40(s0)
    107c:	9cbd                	addw	s1,s1,a5
    107e:	fc940c23          	sb	s1,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
    1082:	20200593          	li	a1,514
    1086:	fd040513          	addi	a0,s0,-48
    108a:	00000097          	auipc	ra,0x0
    108e:	2b8080e7          	jalr	696(ra) # 1342 <open>
    1092:	892a                	mv	s2,a0
    1094:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
    1096:	20000613          	li	a2,512
    109a:	dd040593          	addi	a1,s0,-560
    109e:	854a                	mv	a0,s2
    10a0:	00000097          	auipc	ra,0x0
    10a4:	282080e7          	jalr	642(ra) # 1322 <write>
  for(i = 0; i < 20; i++)
    10a8:	34fd                	addiw	s1,s1,-1
    10aa:	f4f5                	bnez	s1,1096 <main+0x96>
  close(fd);
    10ac:	854a                	mv	a0,s2
    10ae:	00000097          	auipc	ra,0x0
    10b2:	27c080e7          	jalr	636(ra) # 132a <close>

  printf("read\n");
    10b6:	00000517          	auipc	a0,0x0
    10ba:	7a250513          	addi	a0,a0,1954 # 1858 <malloc+0x110>
    10be:	00000097          	auipc	ra,0x0
    10c2:	5cc080e7          	jalr	1484(ra) # 168a <printf>

  fd = open(path, O_RDONLY);
    10c6:	4581                	li	a1,0
    10c8:	fd040513          	addi	a0,s0,-48
    10cc:	00000097          	auipc	ra,0x0
    10d0:	276080e7          	jalr	630(ra) # 1342 <open>
    10d4:	892a                	mv	s2,a0
    10d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
    10d8:	20000613          	li	a2,512
    10dc:	dd040593          	addi	a1,s0,-560
    10e0:	854a                	mv	a0,s2
    10e2:	00000097          	auipc	ra,0x0
    10e6:	238080e7          	jalr	568(ra) # 131a <read>
  for (i = 0; i < 20; i++)
    10ea:	34fd                	addiw	s1,s1,-1
    10ec:	f4f5                	bnez	s1,10d8 <main+0xd8>
  close(fd);
    10ee:	854a                	mv	a0,s2
    10f0:	00000097          	auipc	ra,0x0
    10f4:	23a080e7          	jalr	570(ra) # 132a <close>

  wait(0);
    10f8:	4501                	li	a0,0
    10fa:	00000097          	auipc	ra,0x0
    10fe:	210080e7          	jalr	528(ra) # 130a <wait>

  exit(0);
    1102:	4501                	li	a0,0
    1104:	00000097          	auipc	ra,0x0
    1108:	1fe080e7          	jalr	510(ra) # 1302 <exit>

000000000000110c <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
    110c:	1141                	addi	sp,sp,-16
    110e:	e422                	sd	s0,8(sp)
    1110:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1112:	87aa                	mv	a5,a0
    1114:	0585                	addi	a1,a1,1
    1116:	0785                	addi	a5,a5,1
    1118:	fff5c703          	lbu	a4,-1(a1)
    111c:	fee78fa3          	sb	a4,-1(a5)
    1120:	fb75                	bnez	a4,1114 <strcpy+0x8>
    ;
  return os;
}
    1122:	6422                	ld	s0,8(sp)
    1124:	0141                	addi	sp,sp,16
    1126:	8082                	ret

0000000000001128 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1128:	1141                	addi	sp,sp,-16
    112a:	e422                	sd	s0,8(sp)
    112c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    112e:	00054783          	lbu	a5,0(a0)
    1132:	cb91                	beqz	a5,1146 <strcmp+0x1e>
    1134:	0005c703          	lbu	a4,0(a1)
    1138:	00f71763          	bne	a4,a5,1146 <strcmp+0x1e>
    p++, q++;
    113c:	0505                	addi	a0,a0,1
    113e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    1140:	00054783          	lbu	a5,0(a0)
    1144:	fbe5                	bnez	a5,1134 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    1146:	0005c503          	lbu	a0,0(a1)
}
    114a:	40a7853b          	subw	a0,a5,a0
    114e:	6422                	ld	s0,8(sp)
    1150:	0141                	addi	sp,sp,16
    1152:	8082                	ret

0000000000001154 <strlen>:

uint
strlen(const char *s)
{
    1154:	1141                	addi	sp,sp,-16
    1156:	e422                	sd	s0,8(sp)
    1158:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    115a:	00054783          	lbu	a5,0(a0)
    115e:	cf91                	beqz	a5,117a <strlen+0x26>
    1160:	0505                	addi	a0,a0,1
    1162:	87aa                	mv	a5,a0
    1164:	4685                	li	a3,1
    1166:	9e89                	subw	a3,a3,a0
    1168:	00f6853b          	addw	a0,a3,a5
    116c:	0785                	addi	a5,a5,1
    116e:	fff7c703          	lbu	a4,-1(a5)
    1172:	fb7d                	bnez	a4,1168 <strlen+0x14>
    ;
  return n;
}
    1174:	6422                	ld	s0,8(sp)
    1176:	0141                	addi	sp,sp,16
    1178:	8082                	ret
  for(n = 0; s[n]; n++)
    117a:	4501                	li	a0,0
    117c:	bfe5                	j	1174 <strlen+0x20>

000000000000117e <memset>:

void*
memset(void *dst, int c, uint n)
{
    117e:	1141                	addi	sp,sp,-16
    1180:	e422                	sd	s0,8(sp)
    1182:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    1184:	ce09                	beqz	a2,119e <memset+0x20>
    1186:	87aa                	mv	a5,a0
    1188:	fff6071b          	addiw	a4,a2,-1
    118c:	1702                	slli	a4,a4,0x20
    118e:	9301                	srli	a4,a4,0x20
    1190:	0705                	addi	a4,a4,1
    1192:	972a                	add	a4,a4,a0
    cdst[i] = c;
    1194:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    1198:	0785                	addi	a5,a5,1
    119a:	fee79de3          	bne	a5,a4,1194 <memset+0x16>
  }
  return dst;
}
    119e:	6422                	ld	s0,8(sp)
    11a0:	0141                	addi	sp,sp,16
    11a2:	8082                	ret

00000000000011a4 <strchr>:

char*
strchr(const char *s, char c)
{
    11a4:	1141                	addi	sp,sp,-16
    11a6:	e422                	sd	s0,8(sp)
    11a8:	0800                	addi	s0,sp,16
  for(; *s; s++)
    11aa:	00054783          	lbu	a5,0(a0)
    11ae:	cb99                	beqz	a5,11c4 <strchr+0x20>
    if(*s == c)
    11b0:	00f58763          	beq	a1,a5,11be <strchr+0x1a>
  for(; *s; s++)
    11b4:	0505                	addi	a0,a0,1
    11b6:	00054783          	lbu	a5,0(a0)
    11ba:	fbfd                	bnez	a5,11b0 <strchr+0xc>
      return (char*)s;
  return 0;
    11bc:	4501                	li	a0,0
}
    11be:	6422                	ld	s0,8(sp)
    11c0:	0141                	addi	sp,sp,16
    11c2:	8082                	ret
  return 0;
    11c4:	4501                	li	a0,0
    11c6:	bfe5                	j	11be <strchr+0x1a>

00000000000011c8 <gets>:

char*
gets(char *buf, int max)
{
    11c8:	711d                	addi	sp,sp,-96
    11ca:	ec86                	sd	ra,88(sp)
    11cc:	e8a2                	sd	s0,80(sp)
    11ce:	e4a6                	sd	s1,72(sp)
    11d0:	e0ca                	sd	s2,64(sp)
    11d2:	fc4e                	sd	s3,56(sp)
    11d4:	f852                	sd	s4,48(sp)
    11d6:	f456                	sd	s5,40(sp)
    11d8:	f05a                	sd	s6,32(sp)
    11da:	ec5e                	sd	s7,24(sp)
    11dc:	1080                	addi	s0,sp,96
    11de:	8baa                	mv	s7,a0
    11e0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11e2:	892a                	mv	s2,a0
    11e4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    11e6:	4aa9                	li	s5,10
    11e8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    11ea:	89a6                	mv	s3,s1
    11ec:	2485                	addiw	s1,s1,1
    11ee:	0344d863          	bge	s1,s4,121e <gets+0x56>
    cc = read(0, &c, 1);
    11f2:	4605                	li	a2,1
    11f4:	faf40593          	addi	a1,s0,-81
    11f8:	4501                	li	a0,0
    11fa:	00000097          	auipc	ra,0x0
    11fe:	120080e7          	jalr	288(ra) # 131a <read>
    if(cc < 1)
    1202:	00a05e63          	blez	a0,121e <gets+0x56>
    buf[i++] = c;
    1206:	faf44783          	lbu	a5,-81(s0)
    120a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    120e:	01578763          	beq	a5,s5,121c <gets+0x54>
    1212:	0905                	addi	s2,s2,1
    1214:	fd679be3          	bne	a5,s6,11ea <gets+0x22>
  for(i=0; i+1 < max; ){
    1218:	89a6                	mv	s3,s1
    121a:	a011                	j	121e <gets+0x56>
    121c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    121e:	99de                	add	s3,s3,s7
    1220:	00098023          	sb	zero,0(s3)
  return buf;
}
    1224:	855e                	mv	a0,s7
    1226:	60e6                	ld	ra,88(sp)
    1228:	6446                	ld	s0,80(sp)
    122a:	64a6                	ld	s1,72(sp)
    122c:	6906                	ld	s2,64(sp)
    122e:	79e2                	ld	s3,56(sp)
    1230:	7a42                	ld	s4,48(sp)
    1232:	7aa2                	ld	s5,40(sp)
    1234:	7b02                	ld	s6,32(sp)
    1236:	6be2                	ld	s7,24(sp)
    1238:	6125                	addi	sp,sp,96
    123a:	8082                	ret

000000000000123c <stat>:

int
stat(const char *n, struct stat *st)
{
    123c:	1101                	addi	sp,sp,-32
    123e:	ec06                	sd	ra,24(sp)
    1240:	e822                	sd	s0,16(sp)
    1242:	e426                	sd	s1,8(sp)
    1244:	e04a                	sd	s2,0(sp)
    1246:	1000                	addi	s0,sp,32
    1248:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    124a:	4581                	li	a1,0
    124c:	00000097          	auipc	ra,0x0
    1250:	0f6080e7          	jalr	246(ra) # 1342 <open>
  if(fd < 0)
    1254:	02054563          	bltz	a0,127e <stat+0x42>
    1258:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    125a:	85ca                	mv	a1,s2
    125c:	00000097          	auipc	ra,0x0
    1260:	0fe080e7          	jalr	254(ra) # 135a <fstat>
    1264:	892a                	mv	s2,a0
  close(fd);
    1266:	8526                	mv	a0,s1
    1268:	00000097          	auipc	ra,0x0
    126c:	0c2080e7          	jalr	194(ra) # 132a <close>
  return r;
}
    1270:	854a                	mv	a0,s2
    1272:	60e2                	ld	ra,24(sp)
    1274:	6442                	ld	s0,16(sp)
    1276:	64a2                	ld	s1,8(sp)
    1278:	6902                	ld	s2,0(sp)
    127a:	6105                	addi	sp,sp,32
    127c:	8082                	ret
    return -1;
    127e:	597d                	li	s2,-1
    1280:	bfc5                	j	1270 <stat+0x34>

0000000000001282 <atoi>:

int
atoi(const char *s)
{
    1282:	1141                	addi	sp,sp,-16
    1284:	e422                	sd	s0,8(sp)
    1286:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1288:	00054603          	lbu	a2,0(a0)
    128c:	fd06079b          	addiw	a5,a2,-48
    1290:	0ff7f793          	andi	a5,a5,255
    1294:	4725                	li	a4,9
    1296:	02f76963          	bltu	a4,a5,12c8 <atoi+0x46>
    129a:	86aa                	mv	a3,a0
  n = 0;
    129c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    129e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    12a0:	0685                	addi	a3,a3,1
    12a2:	0025179b          	slliw	a5,a0,0x2
    12a6:	9fa9                	addw	a5,a5,a0
    12a8:	0017979b          	slliw	a5,a5,0x1
    12ac:	9fb1                	addw	a5,a5,a2
    12ae:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    12b2:	0006c603          	lbu	a2,0(a3)
    12b6:	fd06071b          	addiw	a4,a2,-48
    12ba:	0ff77713          	andi	a4,a4,255
    12be:	fee5f1e3          	bgeu	a1,a4,12a0 <atoi+0x1e>
  return n;
}
    12c2:	6422                	ld	s0,8(sp)
    12c4:	0141                	addi	sp,sp,16
    12c6:	8082                	ret
  n = 0;
    12c8:	4501                	li	a0,0
    12ca:	bfe5                	j	12c2 <atoi+0x40>

00000000000012cc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    12cc:	1141                	addi	sp,sp,-16
    12ce:	e422                	sd	s0,8(sp)
    12d0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12d2:	02c05163          	blez	a2,12f4 <memmove+0x28>
    12d6:	fff6071b          	addiw	a4,a2,-1
    12da:	1702                	slli	a4,a4,0x20
    12dc:	9301                	srli	a4,a4,0x20
    12de:	0705                	addi	a4,a4,1
    12e0:	972a                	add	a4,a4,a0
  dst = vdst;
    12e2:	87aa                	mv	a5,a0
    *dst++ = *src++;
    12e4:	0585                	addi	a1,a1,1
    12e6:	0785                	addi	a5,a5,1
    12e8:	fff5c683          	lbu	a3,-1(a1)
    12ec:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    12f0:	fee79ae3          	bne	a5,a4,12e4 <memmove+0x18>
  return vdst;
}
    12f4:	6422                	ld	s0,8(sp)
    12f6:	0141                	addi	sp,sp,16
    12f8:	8082                	ret

00000000000012fa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    12fa:	4885                	li	a7,1
 ecall
    12fc:	00000073          	ecall
 ret
    1300:	8082                	ret

0000000000001302 <exit>:
.global exit
exit:
 li a7, SYS_exit
    1302:	4889                	li	a7,2
 ecall
    1304:	00000073          	ecall
 ret
    1308:	8082                	ret

000000000000130a <wait>:
.global wait
wait:
 li a7, SYS_wait
    130a:	488d                	li	a7,3
 ecall
    130c:	00000073          	ecall
 ret
    1310:	8082                	ret

0000000000001312 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1312:	4891                	li	a7,4
 ecall
    1314:	00000073          	ecall
 ret
    1318:	8082                	ret

000000000000131a <read>:
.global read
read:
 li a7, SYS_read
    131a:	4895                	li	a7,5
 ecall
    131c:	00000073          	ecall
 ret
    1320:	8082                	ret

0000000000001322 <write>:
.global write
write:
 li a7, SYS_write
    1322:	48c1                	li	a7,16
 ecall
    1324:	00000073          	ecall
 ret
    1328:	8082                	ret

000000000000132a <close>:
.global close
close:
 li a7, SYS_close
    132a:	48d5                	li	a7,21
 ecall
    132c:	00000073          	ecall
 ret
    1330:	8082                	ret

0000000000001332 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1332:	4899                	li	a7,6
 ecall
    1334:	00000073          	ecall
 ret
    1338:	8082                	ret

000000000000133a <exec>:
.global exec
exec:
 li a7, SYS_exec
    133a:	489d                	li	a7,7
 ecall
    133c:	00000073          	ecall
 ret
    1340:	8082                	ret

0000000000001342 <open>:
.global open
open:
 li a7, SYS_open
    1342:	48bd                	li	a7,15
 ecall
    1344:	00000073          	ecall
 ret
    1348:	8082                	ret

000000000000134a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    134a:	48c5                	li	a7,17
 ecall
    134c:	00000073          	ecall
 ret
    1350:	8082                	ret

0000000000001352 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1352:	48c9                	li	a7,18
 ecall
    1354:	00000073          	ecall
 ret
    1358:	8082                	ret

000000000000135a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    135a:	48a1                	li	a7,8
 ecall
    135c:	00000073          	ecall
 ret
    1360:	8082                	ret

0000000000001362 <link>:
.global link
link:
 li a7, SYS_link
    1362:	48cd                	li	a7,19
 ecall
    1364:	00000073          	ecall
 ret
    1368:	8082                	ret

000000000000136a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    136a:	48d1                	li	a7,20
 ecall
    136c:	00000073          	ecall
 ret
    1370:	8082                	ret

0000000000001372 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1372:	48a5                	li	a7,9
 ecall
    1374:	00000073          	ecall
 ret
    1378:	8082                	ret

000000000000137a <dup>:
.global dup
dup:
 li a7, SYS_dup
    137a:	48a9                	li	a7,10
 ecall
    137c:	00000073          	ecall
 ret
    1380:	8082                	ret

0000000000001382 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1382:	48ad                	li	a7,11
 ecall
    1384:	00000073          	ecall
 ret
    1388:	8082                	ret

000000000000138a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    138a:	48b1                	li	a7,12
 ecall
    138c:	00000073          	ecall
 ret
    1390:	8082                	ret

0000000000001392 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1392:	48b5                	li	a7,13
 ecall
    1394:	00000073          	ecall
 ret
    1398:	8082                	ret

000000000000139a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    139a:	48b9                	li	a7,14
 ecall
    139c:	00000073          	ecall
 ret
    13a0:	8082                	ret

00000000000013a2 <mprotect>:
.global mprotect
mprotect:
 li a7, SYS_mprotect
    13a2:	48d9                	li	a7,22
 ecall
    13a4:	00000073          	ecall
 ret
    13a8:	8082                	ret

00000000000013aa <munprotect>:
.global munprotect
munprotect:
 li a7, SYS_munprotect
    13aa:	48dd                	li	a7,23
 ecall
    13ac:	00000073          	ecall
 ret
    13b0:	8082                	ret

00000000000013b2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    13b2:	1101                	addi	sp,sp,-32
    13b4:	ec06                	sd	ra,24(sp)
    13b6:	e822                	sd	s0,16(sp)
    13b8:	1000                	addi	s0,sp,32
    13ba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    13be:	4605                	li	a2,1
    13c0:	fef40593          	addi	a1,s0,-17
    13c4:	00000097          	auipc	ra,0x0
    13c8:	f5e080e7          	jalr	-162(ra) # 1322 <write>
}
    13cc:	60e2                	ld	ra,24(sp)
    13ce:	6442                	ld	s0,16(sp)
    13d0:	6105                	addi	sp,sp,32
    13d2:	8082                	ret

00000000000013d4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13d4:	7139                	addi	sp,sp,-64
    13d6:	fc06                	sd	ra,56(sp)
    13d8:	f822                	sd	s0,48(sp)
    13da:	f426                	sd	s1,40(sp)
    13dc:	f04a                	sd	s2,32(sp)
    13de:	ec4e                	sd	s3,24(sp)
    13e0:	0080                	addi	s0,sp,64
    13e2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    13e4:	c299                	beqz	a3,13ea <printint+0x16>
    13e6:	0805c863          	bltz	a1,1476 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    13ea:	2581                	sext.w	a1,a1
  neg = 0;
    13ec:	4881                	li	a7,0
    13ee:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    13f2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    13f4:	2601                	sext.w	a2,a2
    13f6:	00000517          	auipc	a0,0x0
    13fa:	48250513          	addi	a0,a0,1154 # 1878 <digits>
    13fe:	883a                	mv	a6,a4
    1400:	2705                	addiw	a4,a4,1
    1402:	02c5f7bb          	remuw	a5,a1,a2
    1406:	1782                	slli	a5,a5,0x20
    1408:	9381                	srli	a5,a5,0x20
    140a:	97aa                	add	a5,a5,a0
    140c:	0007c783          	lbu	a5,0(a5)
    1410:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1414:	0005879b          	sext.w	a5,a1
    1418:	02c5d5bb          	divuw	a1,a1,a2
    141c:	0685                	addi	a3,a3,1
    141e:	fec7f0e3          	bgeu	a5,a2,13fe <printint+0x2a>
  if(neg)
    1422:	00088b63          	beqz	a7,1438 <printint+0x64>
    buf[i++] = '-';
    1426:	fd040793          	addi	a5,s0,-48
    142a:	973e                	add	a4,a4,a5
    142c:	02d00793          	li	a5,45
    1430:	fef70823          	sb	a5,-16(a4)
    1434:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1438:	02e05863          	blez	a4,1468 <printint+0x94>
    143c:	fc040793          	addi	a5,s0,-64
    1440:	00e78933          	add	s2,a5,a4
    1444:	fff78993          	addi	s3,a5,-1
    1448:	99ba                	add	s3,s3,a4
    144a:	377d                	addiw	a4,a4,-1
    144c:	1702                	slli	a4,a4,0x20
    144e:	9301                	srli	a4,a4,0x20
    1450:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1454:	fff94583          	lbu	a1,-1(s2)
    1458:	8526                	mv	a0,s1
    145a:	00000097          	auipc	ra,0x0
    145e:	f58080e7          	jalr	-168(ra) # 13b2 <putc>
  while(--i >= 0)
    1462:	197d                	addi	s2,s2,-1
    1464:	ff3918e3          	bne	s2,s3,1454 <printint+0x80>
}
    1468:	70e2                	ld	ra,56(sp)
    146a:	7442                	ld	s0,48(sp)
    146c:	74a2                	ld	s1,40(sp)
    146e:	7902                	ld	s2,32(sp)
    1470:	69e2                	ld	s3,24(sp)
    1472:	6121                	addi	sp,sp,64
    1474:	8082                	ret
    x = -xx;
    1476:	40b005bb          	negw	a1,a1
    neg = 1;
    147a:	4885                	li	a7,1
    x = -xx;
    147c:	bf8d                	j	13ee <printint+0x1a>

000000000000147e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    147e:	7119                	addi	sp,sp,-128
    1480:	fc86                	sd	ra,120(sp)
    1482:	f8a2                	sd	s0,112(sp)
    1484:	f4a6                	sd	s1,104(sp)
    1486:	f0ca                	sd	s2,96(sp)
    1488:	ecce                	sd	s3,88(sp)
    148a:	e8d2                	sd	s4,80(sp)
    148c:	e4d6                	sd	s5,72(sp)
    148e:	e0da                	sd	s6,64(sp)
    1490:	fc5e                	sd	s7,56(sp)
    1492:	f862                	sd	s8,48(sp)
    1494:	f466                	sd	s9,40(sp)
    1496:	f06a                	sd	s10,32(sp)
    1498:	ec6e                	sd	s11,24(sp)
    149a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    149c:	0005c903          	lbu	s2,0(a1)
    14a0:	18090f63          	beqz	s2,163e <vprintf+0x1c0>
    14a4:	8aaa                	mv	s5,a0
    14a6:	8b32                	mv	s6,a2
    14a8:	00158493          	addi	s1,a1,1
  state = 0;
    14ac:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    14ae:	02500a13          	li	s4,37
      if(c == 'd'){
    14b2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    14b6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    14ba:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    14be:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    14c2:	00000b97          	auipc	s7,0x0
    14c6:	3b6b8b93          	addi	s7,s7,950 # 1878 <digits>
    14ca:	a839                	j	14e8 <vprintf+0x6a>
        putc(fd, c);
    14cc:	85ca                	mv	a1,s2
    14ce:	8556                	mv	a0,s5
    14d0:	00000097          	auipc	ra,0x0
    14d4:	ee2080e7          	jalr	-286(ra) # 13b2 <putc>
    14d8:	a019                	j	14de <vprintf+0x60>
    } else if(state == '%'){
    14da:	01498f63          	beq	s3,s4,14f8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    14de:	0485                	addi	s1,s1,1
    14e0:	fff4c903          	lbu	s2,-1(s1)
    14e4:	14090d63          	beqz	s2,163e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    14e8:	0009079b          	sext.w	a5,s2
    if(state == 0){
    14ec:	fe0997e3          	bnez	s3,14da <vprintf+0x5c>
      if(c == '%'){
    14f0:	fd479ee3          	bne	a5,s4,14cc <vprintf+0x4e>
        state = '%';
    14f4:	89be                	mv	s3,a5
    14f6:	b7e5                	j	14de <vprintf+0x60>
      if(c == 'd'){
    14f8:	05878063          	beq	a5,s8,1538 <vprintf+0xba>
      } else if(c == 'l') {
    14fc:	05978c63          	beq	a5,s9,1554 <vprintf+0xd6>
      } else if(c == 'x') {
    1500:	07a78863          	beq	a5,s10,1570 <vprintf+0xf2>
      } else if(c == 'p') {
    1504:	09b78463          	beq	a5,s11,158c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    1508:	07300713          	li	a4,115
    150c:	0ce78663          	beq	a5,a4,15d8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1510:	06300713          	li	a4,99
    1514:	0ee78e63          	beq	a5,a4,1610 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    1518:	11478863          	beq	a5,s4,1628 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    151c:	85d2                	mv	a1,s4
    151e:	8556                	mv	a0,s5
    1520:	00000097          	auipc	ra,0x0
    1524:	e92080e7          	jalr	-366(ra) # 13b2 <putc>
        putc(fd, c);
    1528:	85ca                	mv	a1,s2
    152a:	8556                	mv	a0,s5
    152c:	00000097          	auipc	ra,0x0
    1530:	e86080e7          	jalr	-378(ra) # 13b2 <putc>
      }
      state = 0;
    1534:	4981                	li	s3,0
    1536:	b765                	j	14de <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    1538:	008b0913          	addi	s2,s6,8
    153c:	4685                	li	a3,1
    153e:	4629                	li	a2,10
    1540:	000b2583          	lw	a1,0(s6)
    1544:	8556                	mv	a0,s5
    1546:	00000097          	auipc	ra,0x0
    154a:	e8e080e7          	jalr	-370(ra) # 13d4 <printint>
    154e:	8b4a                	mv	s6,s2
      state = 0;
    1550:	4981                	li	s3,0
    1552:	b771                	j	14de <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1554:	008b0913          	addi	s2,s6,8
    1558:	4681                	li	a3,0
    155a:	4629                	li	a2,10
    155c:	000b2583          	lw	a1,0(s6)
    1560:	8556                	mv	a0,s5
    1562:	00000097          	auipc	ra,0x0
    1566:	e72080e7          	jalr	-398(ra) # 13d4 <printint>
    156a:	8b4a                	mv	s6,s2
      state = 0;
    156c:	4981                	li	s3,0
    156e:	bf85                	j	14de <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1570:	008b0913          	addi	s2,s6,8
    1574:	4681                	li	a3,0
    1576:	4641                	li	a2,16
    1578:	000b2583          	lw	a1,0(s6)
    157c:	8556                	mv	a0,s5
    157e:	00000097          	auipc	ra,0x0
    1582:	e56080e7          	jalr	-426(ra) # 13d4 <printint>
    1586:	8b4a                	mv	s6,s2
      state = 0;
    1588:	4981                	li	s3,0
    158a:	bf91                	j	14de <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    158c:	008b0793          	addi	a5,s6,8
    1590:	f8f43423          	sd	a5,-120(s0)
    1594:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1598:	03000593          	li	a1,48
    159c:	8556                	mv	a0,s5
    159e:	00000097          	auipc	ra,0x0
    15a2:	e14080e7          	jalr	-492(ra) # 13b2 <putc>
  putc(fd, 'x');
    15a6:	85ea                	mv	a1,s10
    15a8:	8556                	mv	a0,s5
    15aa:	00000097          	auipc	ra,0x0
    15ae:	e08080e7          	jalr	-504(ra) # 13b2 <putc>
    15b2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    15b4:	03c9d793          	srli	a5,s3,0x3c
    15b8:	97de                	add	a5,a5,s7
    15ba:	0007c583          	lbu	a1,0(a5)
    15be:	8556                	mv	a0,s5
    15c0:	00000097          	auipc	ra,0x0
    15c4:	df2080e7          	jalr	-526(ra) # 13b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    15c8:	0992                	slli	s3,s3,0x4
    15ca:	397d                	addiw	s2,s2,-1
    15cc:	fe0914e3          	bnez	s2,15b4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    15d0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    15d4:	4981                	li	s3,0
    15d6:	b721                	j	14de <vprintf+0x60>
        s = va_arg(ap, char*);
    15d8:	008b0993          	addi	s3,s6,8
    15dc:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    15e0:	02090163          	beqz	s2,1602 <vprintf+0x184>
        while(*s != 0){
    15e4:	00094583          	lbu	a1,0(s2)
    15e8:	c9a1                	beqz	a1,1638 <vprintf+0x1ba>
          putc(fd, *s);
    15ea:	8556                	mv	a0,s5
    15ec:	00000097          	auipc	ra,0x0
    15f0:	dc6080e7          	jalr	-570(ra) # 13b2 <putc>
          s++;
    15f4:	0905                	addi	s2,s2,1
        while(*s != 0){
    15f6:	00094583          	lbu	a1,0(s2)
    15fa:	f9e5                	bnez	a1,15ea <vprintf+0x16c>
        s = va_arg(ap, char*);
    15fc:	8b4e                	mv	s6,s3
      state = 0;
    15fe:	4981                	li	s3,0
    1600:	bdf9                	j	14de <vprintf+0x60>
          s = "(null)";
    1602:	00000917          	auipc	s2,0x0
    1606:	26e90913          	addi	s2,s2,622 # 1870 <malloc+0x128>
        while(*s != 0){
    160a:	02800593          	li	a1,40
    160e:	bff1                	j	15ea <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    1610:	008b0913          	addi	s2,s6,8
    1614:	000b4583          	lbu	a1,0(s6)
    1618:	8556                	mv	a0,s5
    161a:	00000097          	auipc	ra,0x0
    161e:	d98080e7          	jalr	-616(ra) # 13b2 <putc>
    1622:	8b4a                	mv	s6,s2
      state = 0;
    1624:	4981                	li	s3,0
    1626:	bd65                	j	14de <vprintf+0x60>
        putc(fd, c);
    1628:	85d2                	mv	a1,s4
    162a:	8556                	mv	a0,s5
    162c:	00000097          	auipc	ra,0x0
    1630:	d86080e7          	jalr	-634(ra) # 13b2 <putc>
      state = 0;
    1634:	4981                	li	s3,0
    1636:	b565                	j	14de <vprintf+0x60>
        s = va_arg(ap, char*);
    1638:	8b4e                	mv	s6,s3
      state = 0;
    163a:	4981                	li	s3,0
    163c:	b54d                	j	14de <vprintf+0x60>
    }
  }
}
    163e:	70e6                	ld	ra,120(sp)
    1640:	7446                	ld	s0,112(sp)
    1642:	74a6                	ld	s1,104(sp)
    1644:	7906                	ld	s2,96(sp)
    1646:	69e6                	ld	s3,88(sp)
    1648:	6a46                	ld	s4,80(sp)
    164a:	6aa6                	ld	s5,72(sp)
    164c:	6b06                	ld	s6,64(sp)
    164e:	7be2                	ld	s7,56(sp)
    1650:	7c42                	ld	s8,48(sp)
    1652:	7ca2                	ld	s9,40(sp)
    1654:	7d02                	ld	s10,32(sp)
    1656:	6de2                	ld	s11,24(sp)
    1658:	6109                	addi	sp,sp,128
    165a:	8082                	ret

000000000000165c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    165c:	715d                	addi	sp,sp,-80
    165e:	ec06                	sd	ra,24(sp)
    1660:	e822                	sd	s0,16(sp)
    1662:	1000                	addi	s0,sp,32
    1664:	e010                	sd	a2,0(s0)
    1666:	e414                	sd	a3,8(s0)
    1668:	e818                	sd	a4,16(s0)
    166a:	ec1c                	sd	a5,24(s0)
    166c:	03043023          	sd	a6,32(s0)
    1670:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1674:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1678:	8622                	mv	a2,s0
    167a:	00000097          	auipc	ra,0x0
    167e:	e04080e7          	jalr	-508(ra) # 147e <vprintf>
}
    1682:	60e2                	ld	ra,24(sp)
    1684:	6442                	ld	s0,16(sp)
    1686:	6161                	addi	sp,sp,80
    1688:	8082                	ret

000000000000168a <printf>:

void
printf(const char *fmt, ...)
{
    168a:	711d                	addi	sp,sp,-96
    168c:	ec06                	sd	ra,24(sp)
    168e:	e822                	sd	s0,16(sp)
    1690:	1000                	addi	s0,sp,32
    1692:	e40c                	sd	a1,8(s0)
    1694:	e810                	sd	a2,16(s0)
    1696:	ec14                	sd	a3,24(s0)
    1698:	f018                	sd	a4,32(s0)
    169a:	f41c                	sd	a5,40(s0)
    169c:	03043823          	sd	a6,48(s0)
    16a0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    16a4:	00840613          	addi	a2,s0,8
    16a8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    16ac:	85aa                	mv	a1,a0
    16ae:	4505                	li	a0,1
    16b0:	00000097          	auipc	ra,0x0
    16b4:	dce080e7          	jalr	-562(ra) # 147e <vprintf>
}
    16b8:	60e2                	ld	ra,24(sp)
    16ba:	6442                	ld	s0,16(sp)
    16bc:	6125                	addi	sp,sp,96
    16be:	8082                	ret

00000000000016c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16c0:	1141                	addi	sp,sp,-16
    16c2:	e422                	sd	s0,8(sp)
    16c4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16c6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16ca:	00000797          	auipc	a5,0x0
    16ce:	1c67b783          	ld	a5,454(a5) # 1890 <freep>
    16d2:	a805                	j	1702 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    16d4:	4618                	lw	a4,8(a2)
    16d6:	9db9                	addw	a1,a1,a4
    16d8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    16dc:	6398                	ld	a4,0(a5)
    16de:	6318                	ld	a4,0(a4)
    16e0:	fee53823          	sd	a4,-16(a0)
    16e4:	a091                	j	1728 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    16e6:	ff852703          	lw	a4,-8(a0)
    16ea:	9e39                	addw	a2,a2,a4
    16ec:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    16ee:	ff053703          	ld	a4,-16(a0)
    16f2:	e398                	sd	a4,0(a5)
    16f4:	a099                	j	173a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16f6:	6398                	ld	a4,0(a5)
    16f8:	00e7e463          	bltu	a5,a4,1700 <free+0x40>
    16fc:	00e6ea63          	bltu	a3,a4,1710 <free+0x50>
{
    1700:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1702:	fed7fae3          	bgeu	a5,a3,16f6 <free+0x36>
    1706:	6398                	ld	a4,0(a5)
    1708:	00e6e463          	bltu	a3,a4,1710 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    170c:	fee7eae3          	bltu	a5,a4,1700 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1710:	ff852583          	lw	a1,-8(a0)
    1714:	6390                	ld	a2,0(a5)
    1716:	02059713          	slli	a4,a1,0x20
    171a:	9301                	srli	a4,a4,0x20
    171c:	0712                	slli	a4,a4,0x4
    171e:	9736                	add	a4,a4,a3
    1720:	fae60ae3          	beq	a2,a4,16d4 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1724:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1728:	4790                	lw	a2,8(a5)
    172a:	02061713          	slli	a4,a2,0x20
    172e:	9301                	srli	a4,a4,0x20
    1730:	0712                	slli	a4,a4,0x4
    1732:	973e                	add	a4,a4,a5
    1734:	fae689e3          	beq	a3,a4,16e6 <free+0x26>
  } else
    p->s.ptr = bp;
    1738:	e394                	sd	a3,0(a5)
  freep = p;
    173a:	00000717          	auipc	a4,0x0
    173e:	14f73b23          	sd	a5,342(a4) # 1890 <freep>
}
    1742:	6422                	ld	s0,8(sp)
    1744:	0141                	addi	sp,sp,16
    1746:	8082                	ret

0000000000001748 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1748:	7139                	addi	sp,sp,-64
    174a:	fc06                	sd	ra,56(sp)
    174c:	f822                	sd	s0,48(sp)
    174e:	f426                	sd	s1,40(sp)
    1750:	f04a                	sd	s2,32(sp)
    1752:	ec4e                	sd	s3,24(sp)
    1754:	e852                	sd	s4,16(sp)
    1756:	e456                	sd	s5,8(sp)
    1758:	e05a                	sd	s6,0(sp)
    175a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    175c:	02051493          	slli	s1,a0,0x20
    1760:	9081                	srli	s1,s1,0x20
    1762:	04bd                	addi	s1,s1,15
    1764:	8091                	srli	s1,s1,0x4
    1766:	0014899b          	addiw	s3,s1,1
    176a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    176c:	00000517          	auipc	a0,0x0
    1770:	12453503          	ld	a0,292(a0) # 1890 <freep>
    1774:	c515                	beqz	a0,17a0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1776:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1778:	4798                	lw	a4,8(a5)
    177a:	02977f63          	bgeu	a4,s1,17b8 <malloc+0x70>
    177e:	8a4e                	mv	s4,s3
    1780:	0009871b          	sext.w	a4,s3
    1784:	6685                	lui	a3,0x1
    1786:	00d77363          	bgeu	a4,a3,178c <malloc+0x44>
    178a:	6a05                	lui	s4,0x1
    178c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1790:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1794:	00000917          	auipc	s2,0x0
    1798:	0fc90913          	addi	s2,s2,252 # 1890 <freep>
  if(p == (char*)-1)
    179c:	5afd                	li	s5,-1
    179e:	a88d                	j	1810 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    17a0:	00000797          	auipc	a5,0x0
    17a4:	0f878793          	addi	a5,a5,248 # 1898 <base>
    17a8:	00000717          	auipc	a4,0x0
    17ac:	0ef73423          	sd	a5,232(a4) # 1890 <freep>
    17b0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    17b2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    17b6:	b7e1                	j	177e <malloc+0x36>
      if(p->s.size == nunits)
    17b8:	02e48b63          	beq	s1,a4,17ee <malloc+0xa6>
        p->s.size -= nunits;
    17bc:	4137073b          	subw	a4,a4,s3
    17c0:	c798                	sw	a4,8(a5)
        p += p->s.size;
    17c2:	1702                	slli	a4,a4,0x20
    17c4:	9301                	srli	a4,a4,0x20
    17c6:	0712                	slli	a4,a4,0x4
    17c8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    17ca:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    17ce:	00000717          	auipc	a4,0x0
    17d2:	0ca73123          	sd	a0,194(a4) # 1890 <freep>
      return (void*)(p + 1);
    17d6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    17da:	70e2                	ld	ra,56(sp)
    17dc:	7442                	ld	s0,48(sp)
    17de:	74a2                	ld	s1,40(sp)
    17e0:	7902                	ld	s2,32(sp)
    17e2:	69e2                	ld	s3,24(sp)
    17e4:	6a42                	ld	s4,16(sp)
    17e6:	6aa2                	ld	s5,8(sp)
    17e8:	6b02                	ld	s6,0(sp)
    17ea:	6121                	addi	sp,sp,64
    17ec:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    17ee:	6398                	ld	a4,0(a5)
    17f0:	e118                	sd	a4,0(a0)
    17f2:	bff1                	j	17ce <malloc+0x86>
  hp->s.size = nu;
    17f4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    17f8:	0541                	addi	a0,a0,16
    17fa:	00000097          	auipc	ra,0x0
    17fe:	ec6080e7          	jalr	-314(ra) # 16c0 <free>
  return freep;
    1802:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1806:	d971                	beqz	a0,17da <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1808:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    180a:	4798                	lw	a4,8(a5)
    180c:	fa9776e3          	bgeu	a4,s1,17b8 <malloc+0x70>
    if(p == freep)
    1810:	00093703          	ld	a4,0(s2)
    1814:	853e                	mv	a0,a5
    1816:	fef719e3          	bne	a4,a5,1808 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    181a:	8552                	mv	a0,s4
    181c:	00000097          	auipc	ra,0x0
    1820:	b6e080e7          	jalr	-1170(ra) # 138a <sbrk>
  if(p == (char*)-1)
    1824:	fd5518e3          	bne	a0,s5,17f4 <malloc+0xac>
        return 0;
    1828:	4501                	li	a0,0
    182a:	bf45                	j	17da <malloc+0x92>
