
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <cat>:

char buf[512];

void
cat(int fd)
{
    1000:	7179                	addi	sp,sp,-48
    1002:	f406                	sd	ra,40(sp)
    1004:	f022                	sd	s0,32(sp)
    1006:	ec26                	sd	s1,24(sp)
    1008:	e84a                	sd	s2,16(sp)
    100a:	e44e                	sd	s3,8(sp)
    100c:	1800                	addi	s0,sp,48
    100e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    1010:	00001917          	auipc	s2,0x1
    1014:	89890913          	addi	s2,s2,-1896 # 18a8 <buf>
    1018:	20000613          	li	a2,512
    101c:	85ca                	mv	a1,s2
    101e:	854e                	mv	a0,s3
    1020:	00000097          	auipc	ra,0x0
    1024:	306080e7          	jalr	774(ra) # 1326 <read>
    1028:	84aa                	mv	s1,a0
    102a:	02a05863          	blez	a0,105a <cat+0x5a>
    if (write(1, buf, n) != n) {
    102e:	8626                	mv	a2,s1
    1030:	85ca                	mv	a1,s2
    1032:	4505                	li	a0,1
    1034:	00000097          	auipc	ra,0x0
    1038:	2fa080e7          	jalr	762(ra) # 132e <write>
    103c:	fc950ee3          	beq	a0,s1,1018 <cat+0x18>
      printf("cat: write error\n");
    1040:	00000517          	auipc	a0,0x0
    1044:	7f850513          	addi	a0,a0,2040 # 1838 <malloc+0xe4>
    1048:	00000097          	auipc	ra,0x0
    104c:	64e080e7          	jalr	1614(ra) # 1696 <printf>
      exit(1);
    1050:	4505                	li	a0,1
    1052:	00000097          	auipc	ra,0x0
    1056:	2bc080e7          	jalr	700(ra) # 130e <exit>
    }
  }
  if(n < 0){
    105a:	00054963          	bltz	a0,106c <cat+0x6c>
    printf("cat: read error\n");
    exit(1);
  }
}
    105e:	70a2                	ld	ra,40(sp)
    1060:	7402                	ld	s0,32(sp)
    1062:	64e2                	ld	s1,24(sp)
    1064:	6942                	ld	s2,16(sp)
    1066:	69a2                	ld	s3,8(sp)
    1068:	6145                	addi	sp,sp,48
    106a:	8082                	ret
    printf("cat: read error\n");
    106c:	00000517          	auipc	a0,0x0
    1070:	7e450513          	addi	a0,a0,2020 # 1850 <malloc+0xfc>
    1074:	00000097          	auipc	ra,0x0
    1078:	622080e7          	jalr	1570(ra) # 1696 <printf>
    exit(1);
    107c:	4505                	li	a0,1
    107e:	00000097          	auipc	ra,0x0
    1082:	290080e7          	jalr	656(ra) # 130e <exit>

0000000000001086 <main>:

int
main(int argc, char *argv[])
{
    1086:	7179                	addi	sp,sp,-48
    1088:	f406                	sd	ra,40(sp)
    108a:	f022                	sd	s0,32(sp)
    108c:	ec26                	sd	s1,24(sp)
    108e:	e84a                	sd	s2,16(sp)
    1090:	e44e                	sd	s3,8(sp)
    1092:	e052                	sd	s4,0(sp)
    1094:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
    1096:	4785                	li	a5,1
    1098:	04a7d763          	bge	a5,a0,10e6 <main+0x60>
    109c:	00858913          	addi	s2,a1,8
    10a0:	ffe5099b          	addiw	s3,a0,-2
    10a4:	1982                	slli	s3,s3,0x20
    10a6:	0209d993          	srli	s3,s3,0x20
    10aa:	098e                	slli	s3,s3,0x3
    10ac:	05c1                	addi	a1,a1,16
    10ae:	99ae                	add	s3,s3,a1
    cat(0);
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
    10b0:	4581                	li	a1,0
    10b2:	00093503          	ld	a0,0(s2)
    10b6:	00000097          	auipc	ra,0x0
    10ba:	298080e7          	jalr	664(ra) # 134e <open>
    10be:	84aa                	mv	s1,a0
    10c0:	02054d63          	bltz	a0,10fa <main+0x74>
      printf("cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
    10c4:	00000097          	auipc	ra,0x0
    10c8:	f3c080e7          	jalr	-196(ra) # 1000 <cat>
    close(fd);
    10cc:	8526                	mv	a0,s1
    10ce:	00000097          	auipc	ra,0x0
    10d2:	268080e7          	jalr	616(ra) # 1336 <close>
  for(i = 1; i < argc; i++){
    10d6:	0921                	addi	s2,s2,8
    10d8:	fd391ce3          	bne	s2,s3,10b0 <main+0x2a>
  }
  exit(0);
    10dc:	4501                	li	a0,0
    10de:	00000097          	auipc	ra,0x0
    10e2:	230080e7          	jalr	560(ra) # 130e <exit>
    cat(0);
    10e6:	4501                	li	a0,0
    10e8:	00000097          	auipc	ra,0x0
    10ec:	f18080e7          	jalr	-232(ra) # 1000 <cat>
    exit(1);
    10f0:	4505                	li	a0,1
    10f2:	00000097          	auipc	ra,0x0
    10f6:	21c080e7          	jalr	540(ra) # 130e <exit>
      printf("cat: cannot open %s\n", argv[i]);
    10fa:	00093583          	ld	a1,0(s2)
    10fe:	00000517          	auipc	a0,0x0
    1102:	76a50513          	addi	a0,a0,1898 # 1868 <malloc+0x114>
    1106:	00000097          	auipc	ra,0x0
    110a:	590080e7          	jalr	1424(ra) # 1696 <printf>
      exit(1);
    110e:	4505                	li	a0,1
    1110:	00000097          	auipc	ra,0x0
    1114:	1fe080e7          	jalr	510(ra) # 130e <exit>

0000000000001118 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
    1118:	1141                	addi	sp,sp,-16
    111a:	e422                	sd	s0,8(sp)
    111c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    111e:	87aa                	mv	a5,a0
    1120:	0585                	addi	a1,a1,1
    1122:	0785                	addi	a5,a5,1
    1124:	fff5c703          	lbu	a4,-1(a1)
    1128:	fee78fa3          	sb	a4,-1(a5)
    112c:	fb75                	bnez	a4,1120 <strcpy+0x8>
    ;
  return os;
}
    112e:	6422                	ld	s0,8(sp)
    1130:	0141                	addi	sp,sp,16
    1132:	8082                	ret

0000000000001134 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1134:	1141                	addi	sp,sp,-16
    1136:	e422                	sd	s0,8(sp)
    1138:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    113a:	00054783          	lbu	a5,0(a0)
    113e:	cb91                	beqz	a5,1152 <strcmp+0x1e>
    1140:	0005c703          	lbu	a4,0(a1)
    1144:	00f71763          	bne	a4,a5,1152 <strcmp+0x1e>
    p++, q++;
    1148:	0505                	addi	a0,a0,1
    114a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    114c:	00054783          	lbu	a5,0(a0)
    1150:	fbe5                	bnez	a5,1140 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    1152:	0005c503          	lbu	a0,0(a1)
}
    1156:	40a7853b          	subw	a0,a5,a0
    115a:	6422                	ld	s0,8(sp)
    115c:	0141                	addi	sp,sp,16
    115e:	8082                	ret

0000000000001160 <strlen>:

uint
strlen(const char *s)
{
    1160:	1141                	addi	sp,sp,-16
    1162:	e422                	sd	s0,8(sp)
    1164:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    1166:	00054783          	lbu	a5,0(a0)
    116a:	cf91                	beqz	a5,1186 <strlen+0x26>
    116c:	0505                	addi	a0,a0,1
    116e:	87aa                	mv	a5,a0
    1170:	4685                	li	a3,1
    1172:	9e89                	subw	a3,a3,a0
    1174:	00f6853b          	addw	a0,a3,a5
    1178:	0785                	addi	a5,a5,1
    117a:	fff7c703          	lbu	a4,-1(a5)
    117e:	fb7d                	bnez	a4,1174 <strlen+0x14>
    ;
  return n;
}
    1180:	6422                	ld	s0,8(sp)
    1182:	0141                	addi	sp,sp,16
    1184:	8082                	ret
  for(n = 0; s[n]; n++)
    1186:	4501                	li	a0,0
    1188:	bfe5                	j	1180 <strlen+0x20>

000000000000118a <memset>:

void*
memset(void *dst, int c, uint n)
{
    118a:	1141                	addi	sp,sp,-16
    118c:	e422                	sd	s0,8(sp)
    118e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    1190:	ce09                	beqz	a2,11aa <memset+0x20>
    1192:	87aa                	mv	a5,a0
    1194:	fff6071b          	addiw	a4,a2,-1
    1198:	1702                	slli	a4,a4,0x20
    119a:	9301                	srli	a4,a4,0x20
    119c:	0705                	addi	a4,a4,1
    119e:	972a                	add	a4,a4,a0
    cdst[i] = c;
    11a0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    11a4:	0785                	addi	a5,a5,1
    11a6:	fee79de3          	bne	a5,a4,11a0 <memset+0x16>
  }
  return dst;
}
    11aa:	6422                	ld	s0,8(sp)
    11ac:	0141                	addi	sp,sp,16
    11ae:	8082                	ret

00000000000011b0 <strchr>:

char*
strchr(const char *s, char c)
{
    11b0:	1141                	addi	sp,sp,-16
    11b2:	e422                	sd	s0,8(sp)
    11b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
    11b6:	00054783          	lbu	a5,0(a0)
    11ba:	cb99                	beqz	a5,11d0 <strchr+0x20>
    if(*s == c)
    11bc:	00f58763          	beq	a1,a5,11ca <strchr+0x1a>
  for(; *s; s++)
    11c0:	0505                	addi	a0,a0,1
    11c2:	00054783          	lbu	a5,0(a0)
    11c6:	fbfd                	bnez	a5,11bc <strchr+0xc>
      return (char*)s;
  return 0;
    11c8:	4501                	li	a0,0
}
    11ca:	6422                	ld	s0,8(sp)
    11cc:	0141                	addi	sp,sp,16
    11ce:	8082                	ret
  return 0;
    11d0:	4501                	li	a0,0
    11d2:	bfe5                	j	11ca <strchr+0x1a>

00000000000011d4 <gets>:

char*
gets(char *buf, int max)
{
    11d4:	711d                	addi	sp,sp,-96
    11d6:	ec86                	sd	ra,88(sp)
    11d8:	e8a2                	sd	s0,80(sp)
    11da:	e4a6                	sd	s1,72(sp)
    11dc:	e0ca                	sd	s2,64(sp)
    11de:	fc4e                	sd	s3,56(sp)
    11e0:	f852                	sd	s4,48(sp)
    11e2:	f456                	sd	s5,40(sp)
    11e4:	f05a                	sd	s6,32(sp)
    11e6:	ec5e                	sd	s7,24(sp)
    11e8:	1080                	addi	s0,sp,96
    11ea:	8baa                	mv	s7,a0
    11ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11ee:	892a                	mv	s2,a0
    11f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    11f2:	4aa9                	li	s5,10
    11f4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    11f6:	89a6                	mv	s3,s1
    11f8:	2485                	addiw	s1,s1,1
    11fa:	0344d863          	bge	s1,s4,122a <gets+0x56>
    cc = read(0, &c, 1);
    11fe:	4605                	li	a2,1
    1200:	faf40593          	addi	a1,s0,-81
    1204:	4501                	li	a0,0
    1206:	00000097          	auipc	ra,0x0
    120a:	120080e7          	jalr	288(ra) # 1326 <read>
    if(cc < 1)
    120e:	00a05e63          	blez	a0,122a <gets+0x56>
    buf[i++] = c;
    1212:	faf44783          	lbu	a5,-81(s0)
    1216:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    121a:	01578763          	beq	a5,s5,1228 <gets+0x54>
    121e:	0905                	addi	s2,s2,1
    1220:	fd679be3          	bne	a5,s6,11f6 <gets+0x22>
  for(i=0; i+1 < max; ){
    1224:	89a6                	mv	s3,s1
    1226:	a011                	j	122a <gets+0x56>
    1228:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    122a:	99de                	add	s3,s3,s7
    122c:	00098023          	sb	zero,0(s3)
  return buf;
}
    1230:	855e                	mv	a0,s7
    1232:	60e6                	ld	ra,88(sp)
    1234:	6446                	ld	s0,80(sp)
    1236:	64a6                	ld	s1,72(sp)
    1238:	6906                	ld	s2,64(sp)
    123a:	79e2                	ld	s3,56(sp)
    123c:	7a42                	ld	s4,48(sp)
    123e:	7aa2                	ld	s5,40(sp)
    1240:	7b02                	ld	s6,32(sp)
    1242:	6be2                	ld	s7,24(sp)
    1244:	6125                	addi	sp,sp,96
    1246:	8082                	ret

0000000000001248 <stat>:

int
stat(const char *n, struct stat *st)
{
    1248:	1101                	addi	sp,sp,-32
    124a:	ec06                	sd	ra,24(sp)
    124c:	e822                	sd	s0,16(sp)
    124e:	e426                	sd	s1,8(sp)
    1250:	e04a                	sd	s2,0(sp)
    1252:	1000                	addi	s0,sp,32
    1254:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1256:	4581                	li	a1,0
    1258:	00000097          	auipc	ra,0x0
    125c:	0f6080e7          	jalr	246(ra) # 134e <open>
  if(fd < 0)
    1260:	02054563          	bltz	a0,128a <stat+0x42>
    1264:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    1266:	85ca                	mv	a1,s2
    1268:	00000097          	auipc	ra,0x0
    126c:	0fe080e7          	jalr	254(ra) # 1366 <fstat>
    1270:	892a                	mv	s2,a0
  close(fd);
    1272:	8526                	mv	a0,s1
    1274:	00000097          	auipc	ra,0x0
    1278:	0c2080e7          	jalr	194(ra) # 1336 <close>
  return r;
}
    127c:	854a                	mv	a0,s2
    127e:	60e2                	ld	ra,24(sp)
    1280:	6442                	ld	s0,16(sp)
    1282:	64a2                	ld	s1,8(sp)
    1284:	6902                	ld	s2,0(sp)
    1286:	6105                	addi	sp,sp,32
    1288:	8082                	ret
    return -1;
    128a:	597d                	li	s2,-1
    128c:	bfc5                	j	127c <stat+0x34>

000000000000128e <atoi>:

int
atoi(const char *s)
{
    128e:	1141                	addi	sp,sp,-16
    1290:	e422                	sd	s0,8(sp)
    1292:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1294:	00054603          	lbu	a2,0(a0)
    1298:	fd06079b          	addiw	a5,a2,-48
    129c:	0ff7f793          	andi	a5,a5,255
    12a0:	4725                	li	a4,9
    12a2:	02f76963          	bltu	a4,a5,12d4 <atoi+0x46>
    12a6:	86aa                	mv	a3,a0
  n = 0;
    12a8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    12aa:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    12ac:	0685                	addi	a3,a3,1
    12ae:	0025179b          	slliw	a5,a0,0x2
    12b2:	9fa9                	addw	a5,a5,a0
    12b4:	0017979b          	slliw	a5,a5,0x1
    12b8:	9fb1                	addw	a5,a5,a2
    12ba:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    12be:	0006c603          	lbu	a2,0(a3)
    12c2:	fd06071b          	addiw	a4,a2,-48
    12c6:	0ff77713          	andi	a4,a4,255
    12ca:	fee5f1e3          	bgeu	a1,a4,12ac <atoi+0x1e>
  return n;
}
    12ce:	6422                	ld	s0,8(sp)
    12d0:	0141                	addi	sp,sp,16
    12d2:	8082                	ret
  n = 0;
    12d4:	4501                	li	a0,0
    12d6:	bfe5                	j	12ce <atoi+0x40>

00000000000012d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    12d8:	1141                	addi	sp,sp,-16
    12da:	e422                	sd	s0,8(sp)
    12dc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12de:	02c05163          	blez	a2,1300 <memmove+0x28>
    12e2:	fff6071b          	addiw	a4,a2,-1
    12e6:	1702                	slli	a4,a4,0x20
    12e8:	9301                	srli	a4,a4,0x20
    12ea:	0705                	addi	a4,a4,1
    12ec:	972a                	add	a4,a4,a0
  dst = vdst;
    12ee:	87aa                	mv	a5,a0
    *dst++ = *src++;
    12f0:	0585                	addi	a1,a1,1
    12f2:	0785                	addi	a5,a5,1
    12f4:	fff5c683          	lbu	a3,-1(a1)
    12f8:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    12fc:	fee79ae3          	bne	a5,a4,12f0 <memmove+0x18>
  return vdst;
}
    1300:	6422                	ld	s0,8(sp)
    1302:	0141                	addi	sp,sp,16
    1304:	8082                	ret

0000000000001306 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1306:	4885                	li	a7,1
 ecall
    1308:	00000073          	ecall
 ret
    130c:	8082                	ret

000000000000130e <exit>:
.global exit
exit:
 li a7, SYS_exit
    130e:	4889                	li	a7,2
 ecall
    1310:	00000073          	ecall
 ret
    1314:	8082                	ret

0000000000001316 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1316:	488d                	li	a7,3
 ecall
    1318:	00000073          	ecall
 ret
    131c:	8082                	ret

000000000000131e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    131e:	4891                	li	a7,4
 ecall
    1320:	00000073          	ecall
 ret
    1324:	8082                	ret

0000000000001326 <read>:
.global read
read:
 li a7, SYS_read
    1326:	4895                	li	a7,5
 ecall
    1328:	00000073          	ecall
 ret
    132c:	8082                	ret

000000000000132e <write>:
.global write
write:
 li a7, SYS_write
    132e:	48c1                	li	a7,16
 ecall
    1330:	00000073          	ecall
 ret
    1334:	8082                	ret

0000000000001336 <close>:
.global close
close:
 li a7, SYS_close
    1336:	48d5                	li	a7,21
 ecall
    1338:	00000073          	ecall
 ret
    133c:	8082                	ret

000000000000133e <kill>:
.global kill
kill:
 li a7, SYS_kill
    133e:	4899                	li	a7,6
 ecall
    1340:	00000073          	ecall
 ret
    1344:	8082                	ret

0000000000001346 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1346:	489d                	li	a7,7
 ecall
    1348:	00000073          	ecall
 ret
    134c:	8082                	ret

000000000000134e <open>:
.global open
open:
 li a7, SYS_open
    134e:	48bd                	li	a7,15
 ecall
    1350:	00000073          	ecall
 ret
    1354:	8082                	ret

0000000000001356 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1356:	48c5                	li	a7,17
 ecall
    1358:	00000073          	ecall
 ret
    135c:	8082                	ret

000000000000135e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    135e:	48c9                	li	a7,18
 ecall
    1360:	00000073          	ecall
 ret
    1364:	8082                	ret

0000000000001366 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1366:	48a1                	li	a7,8
 ecall
    1368:	00000073          	ecall
 ret
    136c:	8082                	ret

000000000000136e <link>:
.global link
link:
 li a7, SYS_link
    136e:	48cd                	li	a7,19
 ecall
    1370:	00000073          	ecall
 ret
    1374:	8082                	ret

0000000000001376 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1376:	48d1                	li	a7,20
 ecall
    1378:	00000073          	ecall
 ret
    137c:	8082                	ret

000000000000137e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    137e:	48a5                	li	a7,9
 ecall
    1380:	00000073          	ecall
 ret
    1384:	8082                	ret

0000000000001386 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1386:	48a9                	li	a7,10
 ecall
    1388:	00000073          	ecall
 ret
    138c:	8082                	ret

000000000000138e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    138e:	48ad                	li	a7,11
 ecall
    1390:	00000073          	ecall
 ret
    1394:	8082                	ret

0000000000001396 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1396:	48b1                	li	a7,12
 ecall
    1398:	00000073          	ecall
 ret
    139c:	8082                	ret

000000000000139e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    139e:	48b5                	li	a7,13
 ecall
    13a0:	00000073          	ecall
 ret
    13a4:	8082                	ret

00000000000013a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    13a6:	48b9                	li	a7,14
 ecall
    13a8:	00000073          	ecall
 ret
    13ac:	8082                	ret

00000000000013ae <mprotect>:
.global mprotect
mprotect:
 li a7, SYS_mprotect
    13ae:	48d9                	li	a7,22
 ecall
    13b0:	00000073          	ecall
 ret
    13b4:	8082                	ret

00000000000013b6 <munprotect>:
.global munprotect
munprotect:
 li a7, SYS_munprotect
    13b6:	48dd                	li	a7,23
 ecall
    13b8:	00000073          	ecall
 ret
    13bc:	8082                	ret

00000000000013be <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    13be:	1101                	addi	sp,sp,-32
    13c0:	ec06                	sd	ra,24(sp)
    13c2:	e822                	sd	s0,16(sp)
    13c4:	1000                	addi	s0,sp,32
    13c6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    13ca:	4605                	li	a2,1
    13cc:	fef40593          	addi	a1,s0,-17
    13d0:	00000097          	auipc	ra,0x0
    13d4:	f5e080e7          	jalr	-162(ra) # 132e <write>
}
    13d8:	60e2                	ld	ra,24(sp)
    13da:	6442                	ld	s0,16(sp)
    13dc:	6105                	addi	sp,sp,32
    13de:	8082                	ret

00000000000013e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13e0:	7139                	addi	sp,sp,-64
    13e2:	fc06                	sd	ra,56(sp)
    13e4:	f822                	sd	s0,48(sp)
    13e6:	f426                	sd	s1,40(sp)
    13e8:	f04a                	sd	s2,32(sp)
    13ea:	ec4e                	sd	s3,24(sp)
    13ec:	0080                	addi	s0,sp,64
    13ee:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    13f0:	c299                	beqz	a3,13f6 <printint+0x16>
    13f2:	0805c863          	bltz	a1,1482 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    13f6:	2581                	sext.w	a1,a1
  neg = 0;
    13f8:	4881                	li	a7,0
    13fa:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    13fe:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1400:	2601                	sext.w	a2,a2
    1402:	00000517          	auipc	a0,0x0
    1406:	48650513          	addi	a0,a0,1158 # 1888 <digits>
    140a:	883a                	mv	a6,a4
    140c:	2705                	addiw	a4,a4,1
    140e:	02c5f7bb          	remuw	a5,a1,a2
    1412:	1782                	slli	a5,a5,0x20
    1414:	9381                	srli	a5,a5,0x20
    1416:	97aa                	add	a5,a5,a0
    1418:	0007c783          	lbu	a5,0(a5)
    141c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1420:	0005879b          	sext.w	a5,a1
    1424:	02c5d5bb          	divuw	a1,a1,a2
    1428:	0685                	addi	a3,a3,1
    142a:	fec7f0e3          	bgeu	a5,a2,140a <printint+0x2a>
  if(neg)
    142e:	00088b63          	beqz	a7,1444 <printint+0x64>
    buf[i++] = '-';
    1432:	fd040793          	addi	a5,s0,-48
    1436:	973e                	add	a4,a4,a5
    1438:	02d00793          	li	a5,45
    143c:	fef70823          	sb	a5,-16(a4)
    1440:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1444:	02e05863          	blez	a4,1474 <printint+0x94>
    1448:	fc040793          	addi	a5,s0,-64
    144c:	00e78933          	add	s2,a5,a4
    1450:	fff78993          	addi	s3,a5,-1
    1454:	99ba                	add	s3,s3,a4
    1456:	377d                	addiw	a4,a4,-1
    1458:	1702                	slli	a4,a4,0x20
    145a:	9301                	srli	a4,a4,0x20
    145c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1460:	fff94583          	lbu	a1,-1(s2)
    1464:	8526                	mv	a0,s1
    1466:	00000097          	auipc	ra,0x0
    146a:	f58080e7          	jalr	-168(ra) # 13be <putc>
  while(--i >= 0)
    146e:	197d                	addi	s2,s2,-1
    1470:	ff3918e3          	bne	s2,s3,1460 <printint+0x80>
}
    1474:	70e2                	ld	ra,56(sp)
    1476:	7442                	ld	s0,48(sp)
    1478:	74a2                	ld	s1,40(sp)
    147a:	7902                	ld	s2,32(sp)
    147c:	69e2                	ld	s3,24(sp)
    147e:	6121                	addi	sp,sp,64
    1480:	8082                	ret
    x = -xx;
    1482:	40b005bb          	negw	a1,a1
    neg = 1;
    1486:	4885                	li	a7,1
    x = -xx;
    1488:	bf8d                	j	13fa <printint+0x1a>

000000000000148a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    148a:	7119                	addi	sp,sp,-128
    148c:	fc86                	sd	ra,120(sp)
    148e:	f8a2                	sd	s0,112(sp)
    1490:	f4a6                	sd	s1,104(sp)
    1492:	f0ca                	sd	s2,96(sp)
    1494:	ecce                	sd	s3,88(sp)
    1496:	e8d2                	sd	s4,80(sp)
    1498:	e4d6                	sd	s5,72(sp)
    149a:	e0da                	sd	s6,64(sp)
    149c:	fc5e                	sd	s7,56(sp)
    149e:	f862                	sd	s8,48(sp)
    14a0:	f466                	sd	s9,40(sp)
    14a2:	f06a                	sd	s10,32(sp)
    14a4:	ec6e                	sd	s11,24(sp)
    14a6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    14a8:	0005c903          	lbu	s2,0(a1)
    14ac:	18090f63          	beqz	s2,164a <vprintf+0x1c0>
    14b0:	8aaa                	mv	s5,a0
    14b2:	8b32                	mv	s6,a2
    14b4:	00158493          	addi	s1,a1,1
  state = 0;
    14b8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    14ba:	02500a13          	li	s4,37
      if(c == 'd'){
    14be:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    14c2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    14c6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    14ca:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    14ce:	00000b97          	auipc	s7,0x0
    14d2:	3bab8b93          	addi	s7,s7,954 # 1888 <digits>
    14d6:	a839                	j	14f4 <vprintf+0x6a>
        putc(fd, c);
    14d8:	85ca                	mv	a1,s2
    14da:	8556                	mv	a0,s5
    14dc:	00000097          	auipc	ra,0x0
    14e0:	ee2080e7          	jalr	-286(ra) # 13be <putc>
    14e4:	a019                	j	14ea <vprintf+0x60>
    } else if(state == '%'){
    14e6:	01498f63          	beq	s3,s4,1504 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    14ea:	0485                	addi	s1,s1,1
    14ec:	fff4c903          	lbu	s2,-1(s1)
    14f0:	14090d63          	beqz	s2,164a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    14f4:	0009079b          	sext.w	a5,s2
    if(state == 0){
    14f8:	fe0997e3          	bnez	s3,14e6 <vprintf+0x5c>
      if(c == '%'){
    14fc:	fd479ee3          	bne	a5,s4,14d8 <vprintf+0x4e>
        state = '%';
    1500:	89be                	mv	s3,a5
    1502:	b7e5                	j	14ea <vprintf+0x60>
      if(c == 'd'){
    1504:	05878063          	beq	a5,s8,1544 <vprintf+0xba>
      } else if(c == 'l') {
    1508:	05978c63          	beq	a5,s9,1560 <vprintf+0xd6>
      } else if(c == 'x') {
    150c:	07a78863          	beq	a5,s10,157c <vprintf+0xf2>
      } else if(c == 'p') {
    1510:	09b78463          	beq	a5,s11,1598 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    1514:	07300713          	li	a4,115
    1518:	0ce78663          	beq	a5,a4,15e4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    151c:	06300713          	li	a4,99
    1520:	0ee78e63          	beq	a5,a4,161c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    1524:	11478863          	beq	a5,s4,1634 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1528:	85d2                	mv	a1,s4
    152a:	8556                	mv	a0,s5
    152c:	00000097          	auipc	ra,0x0
    1530:	e92080e7          	jalr	-366(ra) # 13be <putc>
        putc(fd, c);
    1534:	85ca                	mv	a1,s2
    1536:	8556                	mv	a0,s5
    1538:	00000097          	auipc	ra,0x0
    153c:	e86080e7          	jalr	-378(ra) # 13be <putc>
      }
      state = 0;
    1540:	4981                	li	s3,0
    1542:	b765                	j	14ea <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    1544:	008b0913          	addi	s2,s6,8
    1548:	4685                	li	a3,1
    154a:	4629                	li	a2,10
    154c:	000b2583          	lw	a1,0(s6)
    1550:	8556                	mv	a0,s5
    1552:	00000097          	auipc	ra,0x0
    1556:	e8e080e7          	jalr	-370(ra) # 13e0 <printint>
    155a:	8b4a                	mv	s6,s2
      state = 0;
    155c:	4981                	li	s3,0
    155e:	b771                	j	14ea <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1560:	008b0913          	addi	s2,s6,8
    1564:	4681                	li	a3,0
    1566:	4629                	li	a2,10
    1568:	000b2583          	lw	a1,0(s6)
    156c:	8556                	mv	a0,s5
    156e:	00000097          	auipc	ra,0x0
    1572:	e72080e7          	jalr	-398(ra) # 13e0 <printint>
    1576:	8b4a                	mv	s6,s2
      state = 0;
    1578:	4981                	li	s3,0
    157a:	bf85                	j	14ea <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    157c:	008b0913          	addi	s2,s6,8
    1580:	4681                	li	a3,0
    1582:	4641                	li	a2,16
    1584:	000b2583          	lw	a1,0(s6)
    1588:	8556                	mv	a0,s5
    158a:	00000097          	auipc	ra,0x0
    158e:	e56080e7          	jalr	-426(ra) # 13e0 <printint>
    1592:	8b4a                	mv	s6,s2
      state = 0;
    1594:	4981                	li	s3,0
    1596:	bf91                	j	14ea <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1598:	008b0793          	addi	a5,s6,8
    159c:	f8f43423          	sd	a5,-120(s0)
    15a0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    15a4:	03000593          	li	a1,48
    15a8:	8556                	mv	a0,s5
    15aa:	00000097          	auipc	ra,0x0
    15ae:	e14080e7          	jalr	-492(ra) # 13be <putc>
  putc(fd, 'x');
    15b2:	85ea                	mv	a1,s10
    15b4:	8556                	mv	a0,s5
    15b6:	00000097          	auipc	ra,0x0
    15ba:	e08080e7          	jalr	-504(ra) # 13be <putc>
    15be:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    15c0:	03c9d793          	srli	a5,s3,0x3c
    15c4:	97de                	add	a5,a5,s7
    15c6:	0007c583          	lbu	a1,0(a5)
    15ca:	8556                	mv	a0,s5
    15cc:	00000097          	auipc	ra,0x0
    15d0:	df2080e7          	jalr	-526(ra) # 13be <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    15d4:	0992                	slli	s3,s3,0x4
    15d6:	397d                	addiw	s2,s2,-1
    15d8:	fe0914e3          	bnez	s2,15c0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    15dc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    15e0:	4981                	li	s3,0
    15e2:	b721                	j	14ea <vprintf+0x60>
        s = va_arg(ap, char*);
    15e4:	008b0993          	addi	s3,s6,8
    15e8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    15ec:	02090163          	beqz	s2,160e <vprintf+0x184>
        while(*s != 0){
    15f0:	00094583          	lbu	a1,0(s2)
    15f4:	c9a1                	beqz	a1,1644 <vprintf+0x1ba>
          putc(fd, *s);
    15f6:	8556                	mv	a0,s5
    15f8:	00000097          	auipc	ra,0x0
    15fc:	dc6080e7          	jalr	-570(ra) # 13be <putc>
          s++;
    1600:	0905                	addi	s2,s2,1
        while(*s != 0){
    1602:	00094583          	lbu	a1,0(s2)
    1606:	f9e5                	bnez	a1,15f6 <vprintf+0x16c>
        s = va_arg(ap, char*);
    1608:	8b4e                	mv	s6,s3
      state = 0;
    160a:	4981                	li	s3,0
    160c:	bdf9                	j	14ea <vprintf+0x60>
          s = "(null)";
    160e:	00000917          	auipc	s2,0x0
    1612:	27290913          	addi	s2,s2,626 # 1880 <malloc+0x12c>
        while(*s != 0){
    1616:	02800593          	li	a1,40
    161a:	bff1                	j	15f6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    161c:	008b0913          	addi	s2,s6,8
    1620:	000b4583          	lbu	a1,0(s6)
    1624:	8556                	mv	a0,s5
    1626:	00000097          	auipc	ra,0x0
    162a:	d98080e7          	jalr	-616(ra) # 13be <putc>
    162e:	8b4a                	mv	s6,s2
      state = 0;
    1630:	4981                	li	s3,0
    1632:	bd65                	j	14ea <vprintf+0x60>
        putc(fd, c);
    1634:	85d2                	mv	a1,s4
    1636:	8556                	mv	a0,s5
    1638:	00000097          	auipc	ra,0x0
    163c:	d86080e7          	jalr	-634(ra) # 13be <putc>
      state = 0;
    1640:	4981                	li	s3,0
    1642:	b565                	j	14ea <vprintf+0x60>
        s = va_arg(ap, char*);
    1644:	8b4e                	mv	s6,s3
      state = 0;
    1646:	4981                	li	s3,0
    1648:	b54d                	j	14ea <vprintf+0x60>
    }
  }
}
    164a:	70e6                	ld	ra,120(sp)
    164c:	7446                	ld	s0,112(sp)
    164e:	74a6                	ld	s1,104(sp)
    1650:	7906                	ld	s2,96(sp)
    1652:	69e6                	ld	s3,88(sp)
    1654:	6a46                	ld	s4,80(sp)
    1656:	6aa6                	ld	s5,72(sp)
    1658:	6b06                	ld	s6,64(sp)
    165a:	7be2                	ld	s7,56(sp)
    165c:	7c42                	ld	s8,48(sp)
    165e:	7ca2                	ld	s9,40(sp)
    1660:	7d02                	ld	s10,32(sp)
    1662:	6de2                	ld	s11,24(sp)
    1664:	6109                	addi	sp,sp,128
    1666:	8082                	ret

0000000000001668 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1668:	715d                	addi	sp,sp,-80
    166a:	ec06                	sd	ra,24(sp)
    166c:	e822                	sd	s0,16(sp)
    166e:	1000                	addi	s0,sp,32
    1670:	e010                	sd	a2,0(s0)
    1672:	e414                	sd	a3,8(s0)
    1674:	e818                	sd	a4,16(s0)
    1676:	ec1c                	sd	a5,24(s0)
    1678:	03043023          	sd	a6,32(s0)
    167c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1680:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1684:	8622                	mv	a2,s0
    1686:	00000097          	auipc	ra,0x0
    168a:	e04080e7          	jalr	-508(ra) # 148a <vprintf>
}
    168e:	60e2                	ld	ra,24(sp)
    1690:	6442                	ld	s0,16(sp)
    1692:	6161                	addi	sp,sp,80
    1694:	8082                	ret

0000000000001696 <printf>:

void
printf(const char *fmt, ...)
{
    1696:	711d                	addi	sp,sp,-96
    1698:	ec06                	sd	ra,24(sp)
    169a:	e822                	sd	s0,16(sp)
    169c:	1000                	addi	s0,sp,32
    169e:	e40c                	sd	a1,8(s0)
    16a0:	e810                	sd	a2,16(s0)
    16a2:	ec14                	sd	a3,24(s0)
    16a4:	f018                	sd	a4,32(s0)
    16a6:	f41c                	sd	a5,40(s0)
    16a8:	03043823          	sd	a6,48(s0)
    16ac:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    16b0:	00840613          	addi	a2,s0,8
    16b4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    16b8:	85aa                	mv	a1,a0
    16ba:	4505                	li	a0,1
    16bc:	00000097          	auipc	ra,0x0
    16c0:	dce080e7          	jalr	-562(ra) # 148a <vprintf>
}
    16c4:	60e2                	ld	ra,24(sp)
    16c6:	6442                	ld	s0,16(sp)
    16c8:	6125                	addi	sp,sp,96
    16ca:	8082                	ret

00000000000016cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16cc:	1141                	addi	sp,sp,-16
    16ce:	e422                	sd	s0,8(sp)
    16d0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16d2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16d6:	00000797          	auipc	a5,0x0
    16da:	1ca7b783          	ld	a5,458(a5) # 18a0 <freep>
    16de:	a805                	j	170e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    16e0:	4618                	lw	a4,8(a2)
    16e2:	9db9                	addw	a1,a1,a4
    16e4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    16e8:	6398                	ld	a4,0(a5)
    16ea:	6318                	ld	a4,0(a4)
    16ec:	fee53823          	sd	a4,-16(a0)
    16f0:	a091                	j	1734 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    16f2:	ff852703          	lw	a4,-8(a0)
    16f6:	9e39                	addw	a2,a2,a4
    16f8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    16fa:	ff053703          	ld	a4,-16(a0)
    16fe:	e398                	sd	a4,0(a5)
    1700:	a099                	j	1746 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1702:	6398                	ld	a4,0(a5)
    1704:	00e7e463          	bltu	a5,a4,170c <free+0x40>
    1708:	00e6ea63          	bltu	a3,a4,171c <free+0x50>
{
    170c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    170e:	fed7fae3          	bgeu	a5,a3,1702 <free+0x36>
    1712:	6398                	ld	a4,0(a5)
    1714:	00e6e463          	bltu	a3,a4,171c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1718:	fee7eae3          	bltu	a5,a4,170c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    171c:	ff852583          	lw	a1,-8(a0)
    1720:	6390                	ld	a2,0(a5)
    1722:	02059713          	slli	a4,a1,0x20
    1726:	9301                	srli	a4,a4,0x20
    1728:	0712                	slli	a4,a4,0x4
    172a:	9736                	add	a4,a4,a3
    172c:	fae60ae3          	beq	a2,a4,16e0 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1730:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1734:	4790                	lw	a2,8(a5)
    1736:	02061713          	slli	a4,a2,0x20
    173a:	9301                	srli	a4,a4,0x20
    173c:	0712                	slli	a4,a4,0x4
    173e:	973e                	add	a4,a4,a5
    1740:	fae689e3          	beq	a3,a4,16f2 <free+0x26>
  } else
    p->s.ptr = bp;
    1744:	e394                	sd	a3,0(a5)
  freep = p;
    1746:	00000717          	auipc	a4,0x0
    174a:	14f73d23          	sd	a5,346(a4) # 18a0 <freep>
}
    174e:	6422                	ld	s0,8(sp)
    1750:	0141                	addi	sp,sp,16
    1752:	8082                	ret

0000000000001754 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1754:	7139                	addi	sp,sp,-64
    1756:	fc06                	sd	ra,56(sp)
    1758:	f822                	sd	s0,48(sp)
    175a:	f426                	sd	s1,40(sp)
    175c:	f04a                	sd	s2,32(sp)
    175e:	ec4e                	sd	s3,24(sp)
    1760:	e852                	sd	s4,16(sp)
    1762:	e456                	sd	s5,8(sp)
    1764:	e05a                	sd	s6,0(sp)
    1766:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1768:	02051493          	slli	s1,a0,0x20
    176c:	9081                	srli	s1,s1,0x20
    176e:	04bd                	addi	s1,s1,15
    1770:	8091                	srli	s1,s1,0x4
    1772:	0014899b          	addiw	s3,s1,1
    1776:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1778:	00000517          	auipc	a0,0x0
    177c:	12853503          	ld	a0,296(a0) # 18a0 <freep>
    1780:	c515                	beqz	a0,17ac <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1782:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1784:	4798                	lw	a4,8(a5)
    1786:	02977f63          	bgeu	a4,s1,17c4 <malloc+0x70>
    178a:	8a4e                	mv	s4,s3
    178c:	0009871b          	sext.w	a4,s3
    1790:	6685                	lui	a3,0x1
    1792:	00d77363          	bgeu	a4,a3,1798 <malloc+0x44>
    1796:	6a05                	lui	s4,0x1
    1798:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    179c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    17a0:	00000917          	auipc	s2,0x0
    17a4:	10090913          	addi	s2,s2,256 # 18a0 <freep>
  if(p == (char*)-1)
    17a8:	5afd                	li	s5,-1
    17aa:	a88d                	j	181c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    17ac:	00000797          	auipc	a5,0x0
    17b0:	2fc78793          	addi	a5,a5,764 # 1aa8 <base>
    17b4:	00000717          	auipc	a4,0x0
    17b8:	0ef73623          	sd	a5,236(a4) # 18a0 <freep>
    17bc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    17be:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    17c2:	b7e1                	j	178a <malloc+0x36>
      if(p->s.size == nunits)
    17c4:	02e48b63          	beq	s1,a4,17fa <malloc+0xa6>
        p->s.size -= nunits;
    17c8:	4137073b          	subw	a4,a4,s3
    17cc:	c798                	sw	a4,8(a5)
        p += p->s.size;
    17ce:	1702                	slli	a4,a4,0x20
    17d0:	9301                	srli	a4,a4,0x20
    17d2:	0712                	slli	a4,a4,0x4
    17d4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    17d6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    17da:	00000717          	auipc	a4,0x0
    17de:	0ca73323          	sd	a0,198(a4) # 18a0 <freep>
      return (void*)(p + 1);
    17e2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    17e6:	70e2                	ld	ra,56(sp)
    17e8:	7442                	ld	s0,48(sp)
    17ea:	74a2                	ld	s1,40(sp)
    17ec:	7902                	ld	s2,32(sp)
    17ee:	69e2                	ld	s3,24(sp)
    17f0:	6a42                	ld	s4,16(sp)
    17f2:	6aa2                	ld	s5,8(sp)
    17f4:	6b02                	ld	s6,0(sp)
    17f6:	6121                	addi	sp,sp,64
    17f8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    17fa:	6398                	ld	a4,0(a5)
    17fc:	e118                	sd	a4,0(a0)
    17fe:	bff1                	j	17da <malloc+0x86>
  hp->s.size = nu;
    1800:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1804:	0541                	addi	a0,a0,16
    1806:	00000097          	auipc	ra,0x0
    180a:	ec6080e7          	jalr	-314(ra) # 16cc <free>
  return freep;
    180e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1812:	d971                	beqz	a0,17e6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1814:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1816:	4798                	lw	a4,8(a5)
    1818:	fa9776e3          	bgeu	a4,s1,17c4 <malloc+0x70>
    if(p == freep)
    181c:	00093703          	ld	a4,0(s2)
    1820:	853e                	mv	a0,a5
    1822:	fef719e3          	bne	a4,a5,1814 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    1826:	8552                	mv	a0,s4
    1828:	00000097          	auipc	ra,0x0
    182c:	b6e080e7          	jalr	-1170(ra) # 1396 <sbrk>
  if(p == (char*)-1)
    1830:	fd5518e3          	bne	a0,s5,1800 <malloc+0xac>
        return 0;
    1834:	4501                	li	a0,0
    1836:	bf45                	j	17e6 <malloc+0x92>
