
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
    1000:	1101                	addi	sp,sp,-32
    1002:	ec06                	sd	ra,24(sp)
    1004:	e822                	sd	s0,16(sp)
    1006:	e426                	sd	s1,8(sp)
    1008:	e04a                	sd	s2,0(sp)
    100a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    100c:	4589                	li	a1,2
    100e:	00000517          	auipc	a0,0x0
    1012:	7f250513          	addi	a0,a0,2034 # 1800 <malloc+0xe4>
    1016:	00000097          	auipc	ra,0x0
    101a:	300080e7          	jalr	768(ra) # 1316 <open>
    101e:	04054763          	bltz	a0,106c <main+0x6c>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
    1022:	4501                	li	a0,0
    1024:	00000097          	auipc	ra,0x0
    1028:	32a080e7          	jalr	810(ra) # 134e <dup>
  dup(0);  // stderr
    102c:	4501                	li	a0,0
    102e:	00000097          	auipc	ra,0x0
    1032:	320080e7          	jalr	800(ra) # 134e <dup>

  for(;;){
    printf("init: starting sh\n");
    1036:	00000917          	auipc	s2,0x0
    103a:	7d290913          	addi	s2,s2,2002 # 1808 <malloc+0xec>
    103e:	854a                	mv	a0,s2
    1040:	00000097          	auipc	ra,0x0
    1044:	61e080e7          	jalr	1566(ra) # 165e <printf>
    pid = fork();
    1048:	00000097          	auipc	ra,0x0
    104c:	286080e7          	jalr	646(ra) # 12ce <fork>
    1050:	84aa                	mv	s1,a0
    if(pid < 0){
    1052:	04054163          	bltz	a0,1094 <main+0x94>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
    1056:	cd21                	beqz	a0,10ae <main+0xae>
      exec("sh", argv);
      printf("init: exec sh failed\n");
      exit(1);
    }
    while((wpid=wait(0)) >= 0 && wpid != pid){
    1058:	4501                	li	a0,0
    105a:	00000097          	auipc	ra,0x0
    105e:	284080e7          	jalr	644(ra) # 12de <wait>
    1062:	fc054ee3          	bltz	a0,103e <main+0x3e>
    1066:	fea499e3          	bne	s1,a0,1058 <main+0x58>
    106a:	bfd1                	j	103e <main+0x3e>
    mknod("console", 1, 1);
    106c:	4605                	li	a2,1
    106e:	4585                	li	a1,1
    1070:	00000517          	auipc	a0,0x0
    1074:	79050513          	addi	a0,a0,1936 # 1800 <malloc+0xe4>
    1078:	00000097          	auipc	ra,0x0
    107c:	2a6080e7          	jalr	678(ra) # 131e <mknod>
    open("console", O_RDWR);
    1080:	4589                	li	a1,2
    1082:	00000517          	auipc	a0,0x0
    1086:	77e50513          	addi	a0,a0,1918 # 1800 <malloc+0xe4>
    108a:	00000097          	auipc	ra,0x0
    108e:	28c080e7          	jalr	652(ra) # 1316 <open>
    1092:	bf41                	j	1022 <main+0x22>
      printf("init: fork failed\n");
    1094:	00000517          	auipc	a0,0x0
    1098:	78c50513          	addi	a0,a0,1932 # 1820 <malloc+0x104>
    109c:	00000097          	auipc	ra,0x0
    10a0:	5c2080e7          	jalr	1474(ra) # 165e <printf>
      exit(1);
    10a4:	4505                	li	a0,1
    10a6:	00000097          	auipc	ra,0x0
    10aa:	230080e7          	jalr	560(ra) # 12d6 <exit>
      exec("sh", argv);
    10ae:	00000597          	auipc	a1,0x0
    10b2:	7ca58593          	addi	a1,a1,1994 # 1878 <argv>
    10b6:	00000517          	auipc	a0,0x0
    10ba:	78250513          	addi	a0,a0,1922 # 1838 <malloc+0x11c>
    10be:	00000097          	auipc	ra,0x0
    10c2:	250080e7          	jalr	592(ra) # 130e <exec>
      printf("init: exec sh failed\n");
    10c6:	00000517          	auipc	a0,0x0
    10ca:	77a50513          	addi	a0,a0,1914 # 1840 <malloc+0x124>
    10ce:	00000097          	auipc	ra,0x0
    10d2:	590080e7          	jalr	1424(ra) # 165e <printf>
      exit(1);
    10d6:	4505                	li	a0,1
    10d8:	00000097          	auipc	ra,0x0
    10dc:	1fe080e7          	jalr	510(ra) # 12d6 <exit>

00000000000010e0 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
    10e0:	1141                	addi	sp,sp,-16
    10e2:	e422                	sd	s0,8(sp)
    10e4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    10e6:	87aa                	mv	a5,a0
    10e8:	0585                	addi	a1,a1,1
    10ea:	0785                	addi	a5,a5,1
    10ec:	fff5c703          	lbu	a4,-1(a1)
    10f0:	fee78fa3          	sb	a4,-1(a5)
    10f4:	fb75                	bnez	a4,10e8 <strcpy+0x8>
    ;
  return os;
}
    10f6:	6422                	ld	s0,8(sp)
    10f8:	0141                	addi	sp,sp,16
    10fa:	8082                	ret

00000000000010fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10fc:	1141                	addi	sp,sp,-16
    10fe:	e422                	sd	s0,8(sp)
    1100:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    1102:	00054783          	lbu	a5,0(a0)
    1106:	cb91                	beqz	a5,111a <strcmp+0x1e>
    1108:	0005c703          	lbu	a4,0(a1)
    110c:	00f71763          	bne	a4,a5,111a <strcmp+0x1e>
    p++, q++;
    1110:	0505                	addi	a0,a0,1
    1112:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    1114:	00054783          	lbu	a5,0(a0)
    1118:	fbe5                	bnez	a5,1108 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    111a:	0005c503          	lbu	a0,0(a1)
}
    111e:	40a7853b          	subw	a0,a5,a0
    1122:	6422                	ld	s0,8(sp)
    1124:	0141                	addi	sp,sp,16
    1126:	8082                	ret

0000000000001128 <strlen>:

uint
strlen(const char *s)
{
    1128:	1141                	addi	sp,sp,-16
    112a:	e422                	sd	s0,8(sp)
    112c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    112e:	00054783          	lbu	a5,0(a0)
    1132:	cf91                	beqz	a5,114e <strlen+0x26>
    1134:	0505                	addi	a0,a0,1
    1136:	87aa                	mv	a5,a0
    1138:	4685                	li	a3,1
    113a:	9e89                	subw	a3,a3,a0
    113c:	00f6853b          	addw	a0,a3,a5
    1140:	0785                	addi	a5,a5,1
    1142:	fff7c703          	lbu	a4,-1(a5)
    1146:	fb7d                	bnez	a4,113c <strlen+0x14>
    ;
  return n;
}
    1148:	6422                	ld	s0,8(sp)
    114a:	0141                	addi	sp,sp,16
    114c:	8082                	ret
  for(n = 0; s[n]; n++)
    114e:	4501                	li	a0,0
    1150:	bfe5                	j	1148 <strlen+0x20>

0000000000001152 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1152:	1141                	addi	sp,sp,-16
    1154:	e422                	sd	s0,8(sp)
    1156:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    1158:	ce09                	beqz	a2,1172 <memset+0x20>
    115a:	87aa                	mv	a5,a0
    115c:	fff6071b          	addiw	a4,a2,-1
    1160:	1702                	slli	a4,a4,0x20
    1162:	9301                	srli	a4,a4,0x20
    1164:	0705                	addi	a4,a4,1
    1166:	972a                	add	a4,a4,a0
    cdst[i] = c;
    1168:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    116c:	0785                	addi	a5,a5,1
    116e:	fee79de3          	bne	a5,a4,1168 <memset+0x16>
  }
  return dst;
}
    1172:	6422                	ld	s0,8(sp)
    1174:	0141                	addi	sp,sp,16
    1176:	8082                	ret

0000000000001178 <strchr>:

char*
strchr(const char *s, char c)
{
    1178:	1141                	addi	sp,sp,-16
    117a:	e422                	sd	s0,8(sp)
    117c:	0800                	addi	s0,sp,16
  for(; *s; s++)
    117e:	00054783          	lbu	a5,0(a0)
    1182:	cb99                	beqz	a5,1198 <strchr+0x20>
    if(*s == c)
    1184:	00f58763          	beq	a1,a5,1192 <strchr+0x1a>
  for(; *s; s++)
    1188:	0505                	addi	a0,a0,1
    118a:	00054783          	lbu	a5,0(a0)
    118e:	fbfd                	bnez	a5,1184 <strchr+0xc>
      return (char*)s;
  return 0;
    1190:	4501                	li	a0,0
}
    1192:	6422                	ld	s0,8(sp)
    1194:	0141                	addi	sp,sp,16
    1196:	8082                	ret
  return 0;
    1198:	4501                	li	a0,0
    119a:	bfe5                	j	1192 <strchr+0x1a>

000000000000119c <gets>:

char*
gets(char *buf, int max)
{
    119c:	711d                	addi	sp,sp,-96
    119e:	ec86                	sd	ra,88(sp)
    11a0:	e8a2                	sd	s0,80(sp)
    11a2:	e4a6                	sd	s1,72(sp)
    11a4:	e0ca                	sd	s2,64(sp)
    11a6:	fc4e                	sd	s3,56(sp)
    11a8:	f852                	sd	s4,48(sp)
    11aa:	f456                	sd	s5,40(sp)
    11ac:	f05a                	sd	s6,32(sp)
    11ae:	ec5e                	sd	s7,24(sp)
    11b0:	1080                	addi	s0,sp,96
    11b2:	8baa                	mv	s7,a0
    11b4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11b6:	892a                	mv	s2,a0
    11b8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    11ba:	4aa9                	li	s5,10
    11bc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    11be:	89a6                	mv	s3,s1
    11c0:	2485                	addiw	s1,s1,1
    11c2:	0344d863          	bge	s1,s4,11f2 <gets+0x56>
    cc = read(0, &c, 1);
    11c6:	4605                	li	a2,1
    11c8:	faf40593          	addi	a1,s0,-81
    11cc:	4501                	li	a0,0
    11ce:	00000097          	auipc	ra,0x0
    11d2:	120080e7          	jalr	288(ra) # 12ee <read>
    if(cc < 1)
    11d6:	00a05e63          	blez	a0,11f2 <gets+0x56>
    buf[i++] = c;
    11da:	faf44783          	lbu	a5,-81(s0)
    11de:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    11e2:	01578763          	beq	a5,s5,11f0 <gets+0x54>
    11e6:	0905                	addi	s2,s2,1
    11e8:	fd679be3          	bne	a5,s6,11be <gets+0x22>
  for(i=0; i+1 < max; ){
    11ec:	89a6                	mv	s3,s1
    11ee:	a011                	j	11f2 <gets+0x56>
    11f0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    11f2:	99de                	add	s3,s3,s7
    11f4:	00098023          	sb	zero,0(s3)
  return buf;
}
    11f8:	855e                	mv	a0,s7
    11fa:	60e6                	ld	ra,88(sp)
    11fc:	6446                	ld	s0,80(sp)
    11fe:	64a6                	ld	s1,72(sp)
    1200:	6906                	ld	s2,64(sp)
    1202:	79e2                	ld	s3,56(sp)
    1204:	7a42                	ld	s4,48(sp)
    1206:	7aa2                	ld	s5,40(sp)
    1208:	7b02                	ld	s6,32(sp)
    120a:	6be2                	ld	s7,24(sp)
    120c:	6125                	addi	sp,sp,96
    120e:	8082                	ret

0000000000001210 <stat>:

int
stat(const char *n, struct stat *st)
{
    1210:	1101                	addi	sp,sp,-32
    1212:	ec06                	sd	ra,24(sp)
    1214:	e822                	sd	s0,16(sp)
    1216:	e426                	sd	s1,8(sp)
    1218:	e04a                	sd	s2,0(sp)
    121a:	1000                	addi	s0,sp,32
    121c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    121e:	4581                	li	a1,0
    1220:	00000097          	auipc	ra,0x0
    1224:	0f6080e7          	jalr	246(ra) # 1316 <open>
  if(fd < 0)
    1228:	02054563          	bltz	a0,1252 <stat+0x42>
    122c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    122e:	85ca                	mv	a1,s2
    1230:	00000097          	auipc	ra,0x0
    1234:	0fe080e7          	jalr	254(ra) # 132e <fstat>
    1238:	892a                	mv	s2,a0
  close(fd);
    123a:	8526                	mv	a0,s1
    123c:	00000097          	auipc	ra,0x0
    1240:	0c2080e7          	jalr	194(ra) # 12fe <close>
  return r;
}
    1244:	854a                	mv	a0,s2
    1246:	60e2                	ld	ra,24(sp)
    1248:	6442                	ld	s0,16(sp)
    124a:	64a2                	ld	s1,8(sp)
    124c:	6902                	ld	s2,0(sp)
    124e:	6105                	addi	sp,sp,32
    1250:	8082                	ret
    return -1;
    1252:	597d                	li	s2,-1
    1254:	bfc5                	j	1244 <stat+0x34>

0000000000001256 <atoi>:

int
atoi(const char *s)
{
    1256:	1141                	addi	sp,sp,-16
    1258:	e422                	sd	s0,8(sp)
    125a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    125c:	00054603          	lbu	a2,0(a0)
    1260:	fd06079b          	addiw	a5,a2,-48
    1264:	0ff7f793          	andi	a5,a5,255
    1268:	4725                	li	a4,9
    126a:	02f76963          	bltu	a4,a5,129c <atoi+0x46>
    126e:	86aa                	mv	a3,a0
  n = 0;
    1270:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    1272:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    1274:	0685                	addi	a3,a3,1
    1276:	0025179b          	slliw	a5,a0,0x2
    127a:	9fa9                	addw	a5,a5,a0
    127c:	0017979b          	slliw	a5,a5,0x1
    1280:	9fb1                	addw	a5,a5,a2
    1282:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    1286:	0006c603          	lbu	a2,0(a3)
    128a:	fd06071b          	addiw	a4,a2,-48
    128e:	0ff77713          	andi	a4,a4,255
    1292:	fee5f1e3          	bgeu	a1,a4,1274 <atoi+0x1e>
  return n;
}
    1296:	6422                	ld	s0,8(sp)
    1298:	0141                	addi	sp,sp,16
    129a:	8082                	ret
  n = 0;
    129c:	4501                	li	a0,0
    129e:	bfe5                	j	1296 <atoi+0x40>

00000000000012a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    12a0:	1141                	addi	sp,sp,-16
    12a2:	e422                	sd	s0,8(sp)
    12a4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12a6:	02c05163          	blez	a2,12c8 <memmove+0x28>
    12aa:	fff6071b          	addiw	a4,a2,-1
    12ae:	1702                	slli	a4,a4,0x20
    12b0:	9301                	srli	a4,a4,0x20
    12b2:	0705                	addi	a4,a4,1
    12b4:	972a                	add	a4,a4,a0
  dst = vdst;
    12b6:	87aa                	mv	a5,a0
    *dst++ = *src++;
    12b8:	0585                	addi	a1,a1,1
    12ba:	0785                	addi	a5,a5,1
    12bc:	fff5c683          	lbu	a3,-1(a1)
    12c0:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    12c4:	fee79ae3          	bne	a5,a4,12b8 <memmove+0x18>
  return vdst;
}
    12c8:	6422                	ld	s0,8(sp)
    12ca:	0141                	addi	sp,sp,16
    12cc:	8082                	ret

00000000000012ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    12ce:	4885                	li	a7,1
 ecall
    12d0:	00000073          	ecall
 ret
    12d4:	8082                	ret

00000000000012d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
    12d6:	4889                	li	a7,2
 ecall
    12d8:	00000073          	ecall
 ret
    12dc:	8082                	ret

00000000000012de <wait>:
.global wait
wait:
 li a7, SYS_wait
    12de:	488d                	li	a7,3
 ecall
    12e0:	00000073          	ecall
 ret
    12e4:	8082                	ret

00000000000012e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    12e6:	4891                	li	a7,4
 ecall
    12e8:	00000073          	ecall
 ret
    12ec:	8082                	ret

00000000000012ee <read>:
.global read
read:
 li a7, SYS_read
    12ee:	4895                	li	a7,5
 ecall
    12f0:	00000073          	ecall
 ret
    12f4:	8082                	ret

00000000000012f6 <write>:
.global write
write:
 li a7, SYS_write
    12f6:	48c1                	li	a7,16
 ecall
    12f8:	00000073          	ecall
 ret
    12fc:	8082                	ret

00000000000012fe <close>:
.global close
close:
 li a7, SYS_close
    12fe:	48d5                	li	a7,21
 ecall
    1300:	00000073          	ecall
 ret
    1304:	8082                	ret

0000000000001306 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1306:	4899                	li	a7,6
 ecall
    1308:	00000073          	ecall
 ret
    130c:	8082                	ret

000000000000130e <exec>:
.global exec
exec:
 li a7, SYS_exec
    130e:	489d                	li	a7,7
 ecall
    1310:	00000073          	ecall
 ret
    1314:	8082                	ret

0000000000001316 <open>:
.global open
open:
 li a7, SYS_open
    1316:	48bd                	li	a7,15
 ecall
    1318:	00000073          	ecall
 ret
    131c:	8082                	ret

000000000000131e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    131e:	48c5                	li	a7,17
 ecall
    1320:	00000073          	ecall
 ret
    1324:	8082                	ret

0000000000001326 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1326:	48c9                	li	a7,18
 ecall
    1328:	00000073          	ecall
 ret
    132c:	8082                	ret

000000000000132e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    132e:	48a1                	li	a7,8
 ecall
    1330:	00000073          	ecall
 ret
    1334:	8082                	ret

0000000000001336 <link>:
.global link
link:
 li a7, SYS_link
    1336:	48cd                	li	a7,19
 ecall
    1338:	00000073          	ecall
 ret
    133c:	8082                	ret

000000000000133e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    133e:	48d1                	li	a7,20
 ecall
    1340:	00000073          	ecall
 ret
    1344:	8082                	ret

0000000000001346 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1346:	48a5                	li	a7,9
 ecall
    1348:	00000073          	ecall
 ret
    134c:	8082                	ret

000000000000134e <dup>:
.global dup
dup:
 li a7, SYS_dup
    134e:	48a9                	li	a7,10
 ecall
    1350:	00000073          	ecall
 ret
    1354:	8082                	ret

0000000000001356 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1356:	48ad                	li	a7,11
 ecall
    1358:	00000073          	ecall
 ret
    135c:	8082                	ret

000000000000135e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    135e:	48b1                	li	a7,12
 ecall
    1360:	00000073          	ecall
 ret
    1364:	8082                	ret

0000000000001366 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1366:	48b5                	li	a7,13
 ecall
    1368:	00000073          	ecall
 ret
    136c:	8082                	ret

000000000000136e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    136e:	48b9                	li	a7,14
 ecall
    1370:	00000073          	ecall
 ret
    1374:	8082                	ret

0000000000001376 <mprotect>:
.global mprotect
mprotect:
 li a7, SYS_mprotect
    1376:	48d9                	li	a7,22
 ecall
    1378:	00000073          	ecall
 ret
    137c:	8082                	ret

000000000000137e <munprotect>:
.global munprotect
munprotect:
 li a7, SYS_munprotect
    137e:	48dd                	li	a7,23
 ecall
    1380:	00000073          	ecall
 ret
    1384:	8082                	ret

0000000000001386 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1386:	1101                	addi	sp,sp,-32
    1388:	ec06                	sd	ra,24(sp)
    138a:	e822                	sd	s0,16(sp)
    138c:	1000                	addi	s0,sp,32
    138e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1392:	4605                	li	a2,1
    1394:	fef40593          	addi	a1,s0,-17
    1398:	00000097          	auipc	ra,0x0
    139c:	f5e080e7          	jalr	-162(ra) # 12f6 <write>
}
    13a0:	60e2                	ld	ra,24(sp)
    13a2:	6442                	ld	s0,16(sp)
    13a4:	6105                	addi	sp,sp,32
    13a6:	8082                	ret

00000000000013a8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13a8:	7139                	addi	sp,sp,-64
    13aa:	fc06                	sd	ra,56(sp)
    13ac:	f822                	sd	s0,48(sp)
    13ae:	f426                	sd	s1,40(sp)
    13b0:	f04a                	sd	s2,32(sp)
    13b2:	ec4e                	sd	s3,24(sp)
    13b4:	0080                	addi	s0,sp,64
    13b6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    13b8:	c299                	beqz	a3,13be <printint+0x16>
    13ba:	0805c863          	bltz	a1,144a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    13be:	2581                	sext.w	a1,a1
  neg = 0;
    13c0:	4881                	li	a7,0
    13c2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    13c6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    13c8:	2601                	sext.w	a2,a2
    13ca:	00000517          	auipc	a0,0x0
    13ce:	49650513          	addi	a0,a0,1174 # 1860 <digits>
    13d2:	883a                	mv	a6,a4
    13d4:	2705                	addiw	a4,a4,1
    13d6:	02c5f7bb          	remuw	a5,a1,a2
    13da:	1782                	slli	a5,a5,0x20
    13dc:	9381                	srli	a5,a5,0x20
    13de:	97aa                	add	a5,a5,a0
    13e0:	0007c783          	lbu	a5,0(a5)
    13e4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    13e8:	0005879b          	sext.w	a5,a1
    13ec:	02c5d5bb          	divuw	a1,a1,a2
    13f0:	0685                	addi	a3,a3,1
    13f2:	fec7f0e3          	bgeu	a5,a2,13d2 <printint+0x2a>
  if(neg)
    13f6:	00088b63          	beqz	a7,140c <printint+0x64>
    buf[i++] = '-';
    13fa:	fd040793          	addi	a5,s0,-48
    13fe:	973e                	add	a4,a4,a5
    1400:	02d00793          	li	a5,45
    1404:	fef70823          	sb	a5,-16(a4)
    1408:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    140c:	02e05863          	blez	a4,143c <printint+0x94>
    1410:	fc040793          	addi	a5,s0,-64
    1414:	00e78933          	add	s2,a5,a4
    1418:	fff78993          	addi	s3,a5,-1
    141c:	99ba                	add	s3,s3,a4
    141e:	377d                	addiw	a4,a4,-1
    1420:	1702                	slli	a4,a4,0x20
    1422:	9301                	srli	a4,a4,0x20
    1424:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1428:	fff94583          	lbu	a1,-1(s2)
    142c:	8526                	mv	a0,s1
    142e:	00000097          	auipc	ra,0x0
    1432:	f58080e7          	jalr	-168(ra) # 1386 <putc>
  while(--i >= 0)
    1436:	197d                	addi	s2,s2,-1
    1438:	ff3918e3          	bne	s2,s3,1428 <printint+0x80>
}
    143c:	70e2                	ld	ra,56(sp)
    143e:	7442                	ld	s0,48(sp)
    1440:	74a2                	ld	s1,40(sp)
    1442:	7902                	ld	s2,32(sp)
    1444:	69e2                	ld	s3,24(sp)
    1446:	6121                	addi	sp,sp,64
    1448:	8082                	ret
    x = -xx;
    144a:	40b005bb          	negw	a1,a1
    neg = 1;
    144e:	4885                	li	a7,1
    x = -xx;
    1450:	bf8d                	j	13c2 <printint+0x1a>

0000000000001452 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1452:	7119                	addi	sp,sp,-128
    1454:	fc86                	sd	ra,120(sp)
    1456:	f8a2                	sd	s0,112(sp)
    1458:	f4a6                	sd	s1,104(sp)
    145a:	f0ca                	sd	s2,96(sp)
    145c:	ecce                	sd	s3,88(sp)
    145e:	e8d2                	sd	s4,80(sp)
    1460:	e4d6                	sd	s5,72(sp)
    1462:	e0da                	sd	s6,64(sp)
    1464:	fc5e                	sd	s7,56(sp)
    1466:	f862                	sd	s8,48(sp)
    1468:	f466                	sd	s9,40(sp)
    146a:	f06a                	sd	s10,32(sp)
    146c:	ec6e                	sd	s11,24(sp)
    146e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1470:	0005c903          	lbu	s2,0(a1)
    1474:	18090f63          	beqz	s2,1612 <vprintf+0x1c0>
    1478:	8aaa                	mv	s5,a0
    147a:	8b32                	mv	s6,a2
    147c:	00158493          	addi	s1,a1,1
  state = 0;
    1480:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1482:	02500a13          	li	s4,37
      if(c == 'd'){
    1486:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    148a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    148e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    1492:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1496:	00000b97          	auipc	s7,0x0
    149a:	3cab8b93          	addi	s7,s7,970 # 1860 <digits>
    149e:	a839                	j	14bc <vprintf+0x6a>
        putc(fd, c);
    14a0:	85ca                	mv	a1,s2
    14a2:	8556                	mv	a0,s5
    14a4:	00000097          	auipc	ra,0x0
    14a8:	ee2080e7          	jalr	-286(ra) # 1386 <putc>
    14ac:	a019                	j	14b2 <vprintf+0x60>
    } else if(state == '%'){
    14ae:	01498f63          	beq	s3,s4,14cc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    14b2:	0485                	addi	s1,s1,1
    14b4:	fff4c903          	lbu	s2,-1(s1)
    14b8:	14090d63          	beqz	s2,1612 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    14bc:	0009079b          	sext.w	a5,s2
    if(state == 0){
    14c0:	fe0997e3          	bnez	s3,14ae <vprintf+0x5c>
      if(c == '%'){
    14c4:	fd479ee3          	bne	a5,s4,14a0 <vprintf+0x4e>
        state = '%';
    14c8:	89be                	mv	s3,a5
    14ca:	b7e5                	j	14b2 <vprintf+0x60>
      if(c == 'd'){
    14cc:	05878063          	beq	a5,s8,150c <vprintf+0xba>
      } else if(c == 'l') {
    14d0:	05978c63          	beq	a5,s9,1528 <vprintf+0xd6>
      } else if(c == 'x') {
    14d4:	07a78863          	beq	a5,s10,1544 <vprintf+0xf2>
      } else if(c == 'p') {
    14d8:	09b78463          	beq	a5,s11,1560 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    14dc:	07300713          	li	a4,115
    14e0:	0ce78663          	beq	a5,a4,15ac <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    14e4:	06300713          	li	a4,99
    14e8:	0ee78e63          	beq	a5,a4,15e4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    14ec:	11478863          	beq	a5,s4,15fc <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    14f0:	85d2                	mv	a1,s4
    14f2:	8556                	mv	a0,s5
    14f4:	00000097          	auipc	ra,0x0
    14f8:	e92080e7          	jalr	-366(ra) # 1386 <putc>
        putc(fd, c);
    14fc:	85ca                	mv	a1,s2
    14fe:	8556                	mv	a0,s5
    1500:	00000097          	auipc	ra,0x0
    1504:	e86080e7          	jalr	-378(ra) # 1386 <putc>
      }
      state = 0;
    1508:	4981                	li	s3,0
    150a:	b765                	j	14b2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    150c:	008b0913          	addi	s2,s6,8
    1510:	4685                	li	a3,1
    1512:	4629                	li	a2,10
    1514:	000b2583          	lw	a1,0(s6)
    1518:	8556                	mv	a0,s5
    151a:	00000097          	auipc	ra,0x0
    151e:	e8e080e7          	jalr	-370(ra) # 13a8 <printint>
    1522:	8b4a                	mv	s6,s2
      state = 0;
    1524:	4981                	li	s3,0
    1526:	b771                	j	14b2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1528:	008b0913          	addi	s2,s6,8
    152c:	4681                	li	a3,0
    152e:	4629                	li	a2,10
    1530:	000b2583          	lw	a1,0(s6)
    1534:	8556                	mv	a0,s5
    1536:	00000097          	auipc	ra,0x0
    153a:	e72080e7          	jalr	-398(ra) # 13a8 <printint>
    153e:	8b4a                	mv	s6,s2
      state = 0;
    1540:	4981                	li	s3,0
    1542:	bf85                	j	14b2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1544:	008b0913          	addi	s2,s6,8
    1548:	4681                	li	a3,0
    154a:	4641                	li	a2,16
    154c:	000b2583          	lw	a1,0(s6)
    1550:	8556                	mv	a0,s5
    1552:	00000097          	auipc	ra,0x0
    1556:	e56080e7          	jalr	-426(ra) # 13a8 <printint>
    155a:	8b4a                	mv	s6,s2
      state = 0;
    155c:	4981                	li	s3,0
    155e:	bf91                	j	14b2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1560:	008b0793          	addi	a5,s6,8
    1564:	f8f43423          	sd	a5,-120(s0)
    1568:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    156c:	03000593          	li	a1,48
    1570:	8556                	mv	a0,s5
    1572:	00000097          	auipc	ra,0x0
    1576:	e14080e7          	jalr	-492(ra) # 1386 <putc>
  putc(fd, 'x');
    157a:	85ea                	mv	a1,s10
    157c:	8556                	mv	a0,s5
    157e:	00000097          	auipc	ra,0x0
    1582:	e08080e7          	jalr	-504(ra) # 1386 <putc>
    1586:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1588:	03c9d793          	srli	a5,s3,0x3c
    158c:	97de                	add	a5,a5,s7
    158e:	0007c583          	lbu	a1,0(a5)
    1592:	8556                	mv	a0,s5
    1594:	00000097          	auipc	ra,0x0
    1598:	df2080e7          	jalr	-526(ra) # 1386 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    159c:	0992                	slli	s3,s3,0x4
    159e:	397d                	addiw	s2,s2,-1
    15a0:	fe0914e3          	bnez	s2,1588 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    15a4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    15a8:	4981                	li	s3,0
    15aa:	b721                	j	14b2 <vprintf+0x60>
        s = va_arg(ap, char*);
    15ac:	008b0993          	addi	s3,s6,8
    15b0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    15b4:	02090163          	beqz	s2,15d6 <vprintf+0x184>
        while(*s != 0){
    15b8:	00094583          	lbu	a1,0(s2)
    15bc:	c9a1                	beqz	a1,160c <vprintf+0x1ba>
          putc(fd, *s);
    15be:	8556                	mv	a0,s5
    15c0:	00000097          	auipc	ra,0x0
    15c4:	dc6080e7          	jalr	-570(ra) # 1386 <putc>
          s++;
    15c8:	0905                	addi	s2,s2,1
        while(*s != 0){
    15ca:	00094583          	lbu	a1,0(s2)
    15ce:	f9e5                	bnez	a1,15be <vprintf+0x16c>
        s = va_arg(ap, char*);
    15d0:	8b4e                	mv	s6,s3
      state = 0;
    15d2:	4981                	li	s3,0
    15d4:	bdf9                	j	14b2 <vprintf+0x60>
          s = "(null)";
    15d6:	00000917          	auipc	s2,0x0
    15da:	28290913          	addi	s2,s2,642 # 1858 <malloc+0x13c>
        while(*s != 0){
    15de:	02800593          	li	a1,40
    15e2:	bff1                	j	15be <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    15e4:	008b0913          	addi	s2,s6,8
    15e8:	000b4583          	lbu	a1,0(s6)
    15ec:	8556                	mv	a0,s5
    15ee:	00000097          	auipc	ra,0x0
    15f2:	d98080e7          	jalr	-616(ra) # 1386 <putc>
    15f6:	8b4a                	mv	s6,s2
      state = 0;
    15f8:	4981                	li	s3,0
    15fa:	bd65                	j	14b2 <vprintf+0x60>
        putc(fd, c);
    15fc:	85d2                	mv	a1,s4
    15fe:	8556                	mv	a0,s5
    1600:	00000097          	auipc	ra,0x0
    1604:	d86080e7          	jalr	-634(ra) # 1386 <putc>
      state = 0;
    1608:	4981                	li	s3,0
    160a:	b565                	j	14b2 <vprintf+0x60>
        s = va_arg(ap, char*);
    160c:	8b4e                	mv	s6,s3
      state = 0;
    160e:	4981                	li	s3,0
    1610:	b54d                	j	14b2 <vprintf+0x60>
    }
  }
}
    1612:	70e6                	ld	ra,120(sp)
    1614:	7446                	ld	s0,112(sp)
    1616:	74a6                	ld	s1,104(sp)
    1618:	7906                	ld	s2,96(sp)
    161a:	69e6                	ld	s3,88(sp)
    161c:	6a46                	ld	s4,80(sp)
    161e:	6aa6                	ld	s5,72(sp)
    1620:	6b06                	ld	s6,64(sp)
    1622:	7be2                	ld	s7,56(sp)
    1624:	7c42                	ld	s8,48(sp)
    1626:	7ca2                	ld	s9,40(sp)
    1628:	7d02                	ld	s10,32(sp)
    162a:	6de2                	ld	s11,24(sp)
    162c:	6109                	addi	sp,sp,128
    162e:	8082                	ret

0000000000001630 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1630:	715d                	addi	sp,sp,-80
    1632:	ec06                	sd	ra,24(sp)
    1634:	e822                	sd	s0,16(sp)
    1636:	1000                	addi	s0,sp,32
    1638:	e010                	sd	a2,0(s0)
    163a:	e414                	sd	a3,8(s0)
    163c:	e818                	sd	a4,16(s0)
    163e:	ec1c                	sd	a5,24(s0)
    1640:	03043023          	sd	a6,32(s0)
    1644:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1648:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    164c:	8622                	mv	a2,s0
    164e:	00000097          	auipc	ra,0x0
    1652:	e04080e7          	jalr	-508(ra) # 1452 <vprintf>
}
    1656:	60e2                	ld	ra,24(sp)
    1658:	6442                	ld	s0,16(sp)
    165a:	6161                	addi	sp,sp,80
    165c:	8082                	ret

000000000000165e <printf>:

void
printf(const char *fmt, ...)
{
    165e:	711d                	addi	sp,sp,-96
    1660:	ec06                	sd	ra,24(sp)
    1662:	e822                	sd	s0,16(sp)
    1664:	1000                	addi	s0,sp,32
    1666:	e40c                	sd	a1,8(s0)
    1668:	e810                	sd	a2,16(s0)
    166a:	ec14                	sd	a3,24(s0)
    166c:	f018                	sd	a4,32(s0)
    166e:	f41c                	sd	a5,40(s0)
    1670:	03043823          	sd	a6,48(s0)
    1674:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1678:	00840613          	addi	a2,s0,8
    167c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1680:	85aa                	mv	a1,a0
    1682:	4505                	li	a0,1
    1684:	00000097          	auipc	ra,0x0
    1688:	dce080e7          	jalr	-562(ra) # 1452 <vprintf>
}
    168c:	60e2                	ld	ra,24(sp)
    168e:	6442                	ld	s0,16(sp)
    1690:	6125                	addi	sp,sp,96
    1692:	8082                	ret

0000000000001694 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1694:	1141                	addi	sp,sp,-16
    1696:	e422                	sd	s0,8(sp)
    1698:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    169a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    169e:	00000797          	auipc	a5,0x0
    16a2:	1ea7b783          	ld	a5,490(a5) # 1888 <freep>
    16a6:	a805                	j	16d6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    16a8:	4618                	lw	a4,8(a2)
    16aa:	9db9                	addw	a1,a1,a4
    16ac:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    16b0:	6398                	ld	a4,0(a5)
    16b2:	6318                	ld	a4,0(a4)
    16b4:	fee53823          	sd	a4,-16(a0)
    16b8:	a091                	j	16fc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    16ba:	ff852703          	lw	a4,-8(a0)
    16be:	9e39                	addw	a2,a2,a4
    16c0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    16c2:	ff053703          	ld	a4,-16(a0)
    16c6:	e398                	sd	a4,0(a5)
    16c8:	a099                	j	170e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16ca:	6398                	ld	a4,0(a5)
    16cc:	00e7e463          	bltu	a5,a4,16d4 <free+0x40>
    16d0:	00e6ea63          	bltu	a3,a4,16e4 <free+0x50>
{
    16d4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16d6:	fed7fae3          	bgeu	a5,a3,16ca <free+0x36>
    16da:	6398                	ld	a4,0(a5)
    16dc:	00e6e463          	bltu	a3,a4,16e4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16e0:	fee7eae3          	bltu	a5,a4,16d4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    16e4:	ff852583          	lw	a1,-8(a0)
    16e8:	6390                	ld	a2,0(a5)
    16ea:	02059713          	slli	a4,a1,0x20
    16ee:	9301                	srli	a4,a4,0x20
    16f0:	0712                	slli	a4,a4,0x4
    16f2:	9736                	add	a4,a4,a3
    16f4:	fae60ae3          	beq	a2,a4,16a8 <free+0x14>
    bp->s.ptr = p->s.ptr;
    16f8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    16fc:	4790                	lw	a2,8(a5)
    16fe:	02061713          	slli	a4,a2,0x20
    1702:	9301                	srli	a4,a4,0x20
    1704:	0712                	slli	a4,a4,0x4
    1706:	973e                	add	a4,a4,a5
    1708:	fae689e3          	beq	a3,a4,16ba <free+0x26>
  } else
    p->s.ptr = bp;
    170c:	e394                	sd	a3,0(a5)
  freep = p;
    170e:	00000717          	auipc	a4,0x0
    1712:	16f73d23          	sd	a5,378(a4) # 1888 <freep>
}
    1716:	6422                	ld	s0,8(sp)
    1718:	0141                	addi	sp,sp,16
    171a:	8082                	ret

000000000000171c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    171c:	7139                	addi	sp,sp,-64
    171e:	fc06                	sd	ra,56(sp)
    1720:	f822                	sd	s0,48(sp)
    1722:	f426                	sd	s1,40(sp)
    1724:	f04a                	sd	s2,32(sp)
    1726:	ec4e                	sd	s3,24(sp)
    1728:	e852                	sd	s4,16(sp)
    172a:	e456                	sd	s5,8(sp)
    172c:	e05a                	sd	s6,0(sp)
    172e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1730:	02051493          	slli	s1,a0,0x20
    1734:	9081                	srli	s1,s1,0x20
    1736:	04bd                	addi	s1,s1,15
    1738:	8091                	srli	s1,s1,0x4
    173a:	0014899b          	addiw	s3,s1,1
    173e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1740:	00000517          	auipc	a0,0x0
    1744:	14853503          	ld	a0,328(a0) # 1888 <freep>
    1748:	c515                	beqz	a0,1774 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    174a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    174c:	4798                	lw	a4,8(a5)
    174e:	02977f63          	bgeu	a4,s1,178c <malloc+0x70>
    1752:	8a4e                	mv	s4,s3
    1754:	0009871b          	sext.w	a4,s3
    1758:	6685                	lui	a3,0x1
    175a:	00d77363          	bgeu	a4,a3,1760 <malloc+0x44>
    175e:	6a05                	lui	s4,0x1
    1760:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1764:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1768:	00000917          	auipc	s2,0x0
    176c:	12090913          	addi	s2,s2,288 # 1888 <freep>
  if(p == (char*)-1)
    1770:	5afd                	li	s5,-1
    1772:	a88d                	j	17e4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    1774:	00000797          	auipc	a5,0x0
    1778:	11c78793          	addi	a5,a5,284 # 1890 <base>
    177c:	00000717          	auipc	a4,0x0
    1780:	10f73623          	sd	a5,268(a4) # 1888 <freep>
    1784:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1786:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    178a:	b7e1                	j	1752 <malloc+0x36>
      if(p->s.size == nunits)
    178c:	02e48b63          	beq	s1,a4,17c2 <malloc+0xa6>
        p->s.size -= nunits;
    1790:	4137073b          	subw	a4,a4,s3
    1794:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1796:	1702                	slli	a4,a4,0x20
    1798:	9301                	srli	a4,a4,0x20
    179a:	0712                	slli	a4,a4,0x4
    179c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    179e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    17a2:	00000717          	auipc	a4,0x0
    17a6:	0ea73323          	sd	a0,230(a4) # 1888 <freep>
      return (void*)(p + 1);
    17aa:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    17ae:	70e2                	ld	ra,56(sp)
    17b0:	7442                	ld	s0,48(sp)
    17b2:	74a2                	ld	s1,40(sp)
    17b4:	7902                	ld	s2,32(sp)
    17b6:	69e2                	ld	s3,24(sp)
    17b8:	6a42                	ld	s4,16(sp)
    17ba:	6aa2                	ld	s5,8(sp)
    17bc:	6b02                	ld	s6,0(sp)
    17be:	6121                	addi	sp,sp,64
    17c0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    17c2:	6398                	ld	a4,0(a5)
    17c4:	e118                	sd	a4,0(a0)
    17c6:	bff1                	j	17a2 <malloc+0x86>
  hp->s.size = nu;
    17c8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    17cc:	0541                	addi	a0,a0,16
    17ce:	00000097          	auipc	ra,0x0
    17d2:	ec6080e7          	jalr	-314(ra) # 1694 <free>
  return freep;
    17d6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    17da:	d971                	beqz	a0,17ae <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    17de:	4798                	lw	a4,8(a5)
    17e0:	fa9776e3          	bgeu	a4,s1,178c <malloc+0x70>
    if(p == freep)
    17e4:	00093703          	ld	a4,0(s2)
    17e8:	853e                	mv	a0,a5
    17ea:	fef719e3          	bne	a4,a5,17dc <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    17ee:	8552                	mv	a0,s4
    17f0:	00000097          	auipc	ra,0x0
    17f4:	b6e080e7          	jalr	-1170(ra) # 135e <sbrk>
  if(p == (char*)-1)
    17f8:	fd5518e3          	bne	a0,s5,17c8 <malloc+0xac>
        return 0;
    17fc:	4501                	li	a0,0
    17fe:	bf45                	j	17ae <malloc+0x92>
