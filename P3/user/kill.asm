
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
    1000:	1101                	addi	sp,sp,-32
    1002:	ec06                	sd	ra,24(sp)
    1004:	e822                	sd	s0,16(sp)
    1006:	e426                	sd	s1,8(sp)
    1008:	e04a                	sd	s2,0(sp)
    100a:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
    100c:	4785                	li	a5,1
    100e:	02a7dd63          	bge	a5,a0,1048 <main+0x48>
    1012:	00858493          	addi	s1,a1,8
    1016:	ffe5091b          	addiw	s2,a0,-2
    101a:	1902                	slli	s2,s2,0x20
    101c:	02095913          	srli	s2,s2,0x20
    1020:	090e                	slli	s2,s2,0x3
    1022:	05c1                	addi	a1,a1,16
    1024:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
    1026:	6088                	ld	a0,0(s1)
    1028:	00000097          	auipc	ra,0x0
    102c:	1b2080e7          	jalr	434(ra) # 11da <atoi>
    1030:	00000097          	auipc	ra,0x0
    1034:	25a080e7          	jalr	602(ra) # 128a <kill>
  for(i=1; i<argc; i++)
    1038:	04a1                	addi	s1,s1,8
    103a:	ff2496e3          	bne	s1,s2,1026 <main+0x26>
  exit(0);
    103e:	4501                	li	a0,0
    1040:	00000097          	auipc	ra,0x0
    1044:	21a080e7          	jalr	538(ra) # 125a <exit>
    fprintf(2, "usage: kill pid...\n");
    1048:	00000597          	auipc	a1,0x0
    104c:	74058593          	addi	a1,a1,1856 # 1788 <malloc+0xe8>
    1050:	4509                	li	a0,2
    1052:	00000097          	auipc	ra,0x0
    1056:	562080e7          	jalr	1378(ra) # 15b4 <fprintf>
    exit(1);
    105a:	4505                	li	a0,1
    105c:	00000097          	auipc	ra,0x0
    1060:	1fe080e7          	jalr	510(ra) # 125a <exit>

0000000000001064 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
    1064:	1141                	addi	sp,sp,-16
    1066:	e422                	sd	s0,8(sp)
    1068:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    106a:	87aa                	mv	a5,a0
    106c:	0585                	addi	a1,a1,1
    106e:	0785                	addi	a5,a5,1
    1070:	fff5c703          	lbu	a4,-1(a1)
    1074:	fee78fa3          	sb	a4,-1(a5)
    1078:	fb75                	bnez	a4,106c <strcpy+0x8>
    ;
  return os;
}
    107a:	6422                	ld	s0,8(sp)
    107c:	0141                	addi	sp,sp,16
    107e:	8082                	ret

0000000000001080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1080:	1141                	addi	sp,sp,-16
    1082:	e422                	sd	s0,8(sp)
    1084:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    1086:	00054783          	lbu	a5,0(a0)
    108a:	cb91                	beqz	a5,109e <strcmp+0x1e>
    108c:	0005c703          	lbu	a4,0(a1)
    1090:	00f71763          	bne	a4,a5,109e <strcmp+0x1e>
    p++, q++;
    1094:	0505                	addi	a0,a0,1
    1096:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    1098:	00054783          	lbu	a5,0(a0)
    109c:	fbe5                	bnez	a5,108c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    109e:	0005c503          	lbu	a0,0(a1)
}
    10a2:	40a7853b          	subw	a0,a5,a0
    10a6:	6422                	ld	s0,8(sp)
    10a8:	0141                	addi	sp,sp,16
    10aa:	8082                	ret

00000000000010ac <strlen>:

uint
strlen(const char *s)
{
    10ac:	1141                	addi	sp,sp,-16
    10ae:	e422                	sd	s0,8(sp)
    10b0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    10b2:	00054783          	lbu	a5,0(a0)
    10b6:	cf91                	beqz	a5,10d2 <strlen+0x26>
    10b8:	0505                	addi	a0,a0,1
    10ba:	87aa                	mv	a5,a0
    10bc:	4685                	li	a3,1
    10be:	9e89                	subw	a3,a3,a0
    10c0:	00f6853b          	addw	a0,a3,a5
    10c4:	0785                	addi	a5,a5,1
    10c6:	fff7c703          	lbu	a4,-1(a5)
    10ca:	fb7d                	bnez	a4,10c0 <strlen+0x14>
    ;
  return n;
}
    10cc:	6422                	ld	s0,8(sp)
    10ce:	0141                	addi	sp,sp,16
    10d0:	8082                	ret
  for(n = 0; s[n]; n++)
    10d2:	4501                	li	a0,0
    10d4:	bfe5                	j	10cc <strlen+0x20>

00000000000010d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10d6:	1141                	addi	sp,sp,-16
    10d8:	e422                	sd	s0,8(sp)
    10da:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    10dc:	ce09                	beqz	a2,10f6 <memset+0x20>
    10de:	87aa                	mv	a5,a0
    10e0:	fff6071b          	addiw	a4,a2,-1
    10e4:	1702                	slli	a4,a4,0x20
    10e6:	9301                	srli	a4,a4,0x20
    10e8:	0705                	addi	a4,a4,1
    10ea:	972a                	add	a4,a4,a0
    cdst[i] = c;
    10ec:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    10f0:	0785                	addi	a5,a5,1
    10f2:	fee79de3          	bne	a5,a4,10ec <memset+0x16>
  }
  return dst;
}
    10f6:	6422                	ld	s0,8(sp)
    10f8:	0141                	addi	sp,sp,16
    10fa:	8082                	ret

00000000000010fc <strchr>:

char*
strchr(const char *s, char c)
{
    10fc:	1141                	addi	sp,sp,-16
    10fe:	e422                	sd	s0,8(sp)
    1100:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1102:	00054783          	lbu	a5,0(a0)
    1106:	cb99                	beqz	a5,111c <strchr+0x20>
    if(*s == c)
    1108:	00f58763          	beq	a1,a5,1116 <strchr+0x1a>
  for(; *s; s++)
    110c:	0505                	addi	a0,a0,1
    110e:	00054783          	lbu	a5,0(a0)
    1112:	fbfd                	bnez	a5,1108 <strchr+0xc>
      return (char*)s;
  return 0;
    1114:	4501                	li	a0,0
}
    1116:	6422                	ld	s0,8(sp)
    1118:	0141                	addi	sp,sp,16
    111a:	8082                	ret
  return 0;
    111c:	4501                	li	a0,0
    111e:	bfe5                	j	1116 <strchr+0x1a>

0000000000001120 <gets>:

char*
gets(char *buf, int max)
{
    1120:	711d                	addi	sp,sp,-96
    1122:	ec86                	sd	ra,88(sp)
    1124:	e8a2                	sd	s0,80(sp)
    1126:	e4a6                	sd	s1,72(sp)
    1128:	e0ca                	sd	s2,64(sp)
    112a:	fc4e                	sd	s3,56(sp)
    112c:	f852                	sd	s4,48(sp)
    112e:	f456                	sd	s5,40(sp)
    1130:	f05a                	sd	s6,32(sp)
    1132:	ec5e                	sd	s7,24(sp)
    1134:	1080                	addi	s0,sp,96
    1136:	8baa                	mv	s7,a0
    1138:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    113a:	892a                	mv	s2,a0
    113c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    113e:	4aa9                	li	s5,10
    1140:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1142:	89a6                	mv	s3,s1
    1144:	2485                	addiw	s1,s1,1
    1146:	0344d863          	bge	s1,s4,1176 <gets+0x56>
    cc = read(0, &c, 1);
    114a:	4605                	li	a2,1
    114c:	faf40593          	addi	a1,s0,-81
    1150:	4501                	li	a0,0
    1152:	00000097          	auipc	ra,0x0
    1156:	120080e7          	jalr	288(ra) # 1272 <read>
    if(cc < 1)
    115a:	00a05e63          	blez	a0,1176 <gets+0x56>
    buf[i++] = c;
    115e:	faf44783          	lbu	a5,-81(s0)
    1162:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1166:	01578763          	beq	a5,s5,1174 <gets+0x54>
    116a:	0905                	addi	s2,s2,1
    116c:	fd679be3          	bne	a5,s6,1142 <gets+0x22>
  for(i=0; i+1 < max; ){
    1170:	89a6                	mv	s3,s1
    1172:	a011                	j	1176 <gets+0x56>
    1174:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1176:	99de                	add	s3,s3,s7
    1178:	00098023          	sb	zero,0(s3)
  return buf;
}
    117c:	855e                	mv	a0,s7
    117e:	60e6                	ld	ra,88(sp)
    1180:	6446                	ld	s0,80(sp)
    1182:	64a6                	ld	s1,72(sp)
    1184:	6906                	ld	s2,64(sp)
    1186:	79e2                	ld	s3,56(sp)
    1188:	7a42                	ld	s4,48(sp)
    118a:	7aa2                	ld	s5,40(sp)
    118c:	7b02                	ld	s6,32(sp)
    118e:	6be2                	ld	s7,24(sp)
    1190:	6125                	addi	sp,sp,96
    1192:	8082                	ret

0000000000001194 <stat>:

int
stat(const char *n, struct stat *st)
{
    1194:	1101                	addi	sp,sp,-32
    1196:	ec06                	sd	ra,24(sp)
    1198:	e822                	sd	s0,16(sp)
    119a:	e426                	sd	s1,8(sp)
    119c:	e04a                	sd	s2,0(sp)
    119e:	1000                	addi	s0,sp,32
    11a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11a2:	4581                	li	a1,0
    11a4:	00000097          	auipc	ra,0x0
    11a8:	0f6080e7          	jalr	246(ra) # 129a <open>
  if(fd < 0)
    11ac:	02054563          	bltz	a0,11d6 <stat+0x42>
    11b0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    11b2:	85ca                	mv	a1,s2
    11b4:	00000097          	auipc	ra,0x0
    11b8:	0fe080e7          	jalr	254(ra) # 12b2 <fstat>
    11bc:	892a                	mv	s2,a0
  close(fd);
    11be:	8526                	mv	a0,s1
    11c0:	00000097          	auipc	ra,0x0
    11c4:	0c2080e7          	jalr	194(ra) # 1282 <close>
  return r;
}
    11c8:	854a                	mv	a0,s2
    11ca:	60e2                	ld	ra,24(sp)
    11cc:	6442                	ld	s0,16(sp)
    11ce:	64a2                	ld	s1,8(sp)
    11d0:	6902                	ld	s2,0(sp)
    11d2:	6105                	addi	sp,sp,32
    11d4:	8082                	ret
    return -1;
    11d6:	597d                	li	s2,-1
    11d8:	bfc5                	j	11c8 <stat+0x34>

00000000000011da <atoi>:

int
atoi(const char *s)
{
    11da:	1141                	addi	sp,sp,-16
    11dc:	e422                	sd	s0,8(sp)
    11de:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11e0:	00054603          	lbu	a2,0(a0)
    11e4:	fd06079b          	addiw	a5,a2,-48
    11e8:	0ff7f793          	andi	a5,a5,255
    11ec:	4725                	li	a4,9
    11ee:	02f76963          	bltu	a4,a5,1220 <atoi+0x46>
    11f2:	86aa                	mv	a3,a0
  n = 0;
    11f4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    11f6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    11f8:	0685                	addi	a3,a3,1
    11fa:	0025179b          	slliw	a5,a0,0x2
    11fe:	9fa9                	addw	a5,a5,a0
    1200:	0017979b          	slliw	a5,a5,0x1
    1204:	9fb1                	addw	a5,a5,a2
    1206:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    120a:	0006c603          	lbu	a2,0(a3)
    120e:	fd06071b          	addiw	a4,a2,-48
    1212:	0ff77713          	andi	a4,a4,255
    1216:	fee5f1e3          	bgeu	a1,a4,11f8 <atoi+0x1e>
  return n;
}
    121a:	6422                	ld	s0,8(sp)
    121c:	0141                	addi	sp,sp,16
    121e:	8082                	ret
  n = 0;
    1220:	4501                	li	a0,0
    1222:	bfe5                	j	121a <atoi+0x40>

0000000000001224 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1224:	1141                	addi	sp,sp,-16
    1226:	e422                	sd	s0,8(sp)
    1228:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    122a:	02c05163          	blez	a2,124c <memmove+0x28>
    122e:	fff6071b          	addiw	a4,a2,-1
    1232:	1702                	slli	a4,a4,0x20
    1234:	9301                	srli	a4,a4,0x20
    1236:	0705                	addi	a4,a4,1
    1238:	972a                	add	a4,a4,a0
  dst = vdst;
    123a:	87aa                	mv	a5,a0
    *dst++ = *src++;
    123c:	0585                	addi	a1,a1,1
    123e:	0785                	addi	a5,a5,1
    1240:	fff5c683          	lbu	a3,-1(a1)
    1244:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    1248:	fee79ae3          	bne	a5,a4,123c <memmove+0x18>
  return vdst;
}
    124c:	6422                	ld	s0,8(sp)
    124e:	0141                	addi	sp,sp,16
    1250:	8082                	ret

0000000000001252 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1252:	4885                	li	a7,1
 ecall
    1254:	00000073          	ecall
 ret
    1258:	8082                	ret

000000000000125a <exit>:
.global exit
exit:
 li a7, SYS_exit
    125a:	4889                	li	a7,2
 ecall
    125c:	00000073          	ecall
 ret
    1260:	8082                	ret

0000000000001262 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1262:	488d                	li	a7,3
 ecall
    1264:	00000073          	ecall
 ret
    1268:	8082                	ret

000000000000126a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    126a:	4891                	li	a7,4
 ecall
    126c:	00000073          	ecall
 ret
    1270:	8082                	ret

0000000000001272 <read>:
.global read
read:
 li a7, SYS_read
    1272:	4895                	li	a7,5
 ecall
    1274:	00000073          	ecall
 ret
    1278:	8082                	ret

000000000000127a <write>:
.global write
write:
 li a7, SYS_write
    127a:	48c1                	li	a7,16
 ecall
    127c:	00000073          	ecall
 ret
    1280:	8082                	ret

0000000000001282 <close>:
.global close
close:
 li a7, SYS_close
    1282:	48d5                	li	a7,21
 ecall
    1284:	00000073          	ecall
 ret
    1288:	8082                	ret

000000000000128a <kill>:
.global kill
kill:
 li a7, SYS_kill
    128a:	4899                	li	a7,6
 ecall
    128c:	00000073          	ecall
 ret
    1290:	8082                	ret

0000000000001292 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1292:	489d                	li	a7,7
 ecall
    1294:	00000073          	ecall
 ret
    1298:	8082                	ret

000000000000129a <open>:
.global open
open:
 li a7, SYS_open
    129a:	48bd                	li	a7,15
 ecall
    129c:	00000073          	ecall
 ret
    12a0:	8082                	ret

00000000000012a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    12a2:	48c5                	li	a7,17
 ecall
    12a4:	00000073          	ecall
 ret
    12a8:	8082                	ret

00000000000012aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    12aa:	48c9                	li	a7,18
 ecall
    12ac:	00000073          	ecall
 ret
    12b0:	8082                	ret

00000000000012b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    12b2:	48a1                	li	a7,8
 ecall
    12b4:	00000073          	ecall
 ret
    12b8:	8082                	ret

00000000000012ba <link>:
.global link
link:
 li a7, SYS_link
    12ba:	48cd                	li	a7,19
 ecall
    12bc:	00000073          	ecall
 ret
    12c0:	8082                	ret

00000000000012c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    12c2:	48d1                	li	a7,20
 ecall
    12c4:	00000073          	ecall
 ret
    12c8:	8082                	ret

00000000000012ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    12ca:	48a5                	li	a7,9
 ecall
    12cc:	00000073          	ecall
 ret
    12d0:	8082                	ret

00000000000012d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
    12d2:	48a9                	li	a7,10
 ecall
    12d4:	00000073          	ecall
 ret
    12d8:	8082                	ret

00000000000012da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    12da:	48ad                	li	a7,11
 ecall
    12dc:	00000073          	ecall
 ret
    12e0:	8082                	ret

00000000000012e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    12e2:	48b1                	li	a7,12
 ecall
    12e4:	00000073          	ecall
 ret
    12e8:	8082                	ret

00000000000012ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    12ea:	48b5                	li	a7,13
 ecall
    12ec:	00000073          	ecall
 ret
    12f0:	8082                	ret

00000000000012f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    12f2:	48b9                	li	a7,14
 ecall
    12f4:	00000073          	ecall
 ret
    12f8:	8082                	ret

00000000000012fa <mprotect>:
.global mprotect
mprotect:
 li a7, SYS_mprotect
    12fa:	48d9                	li	a7,22
 ecall
    12fc:	00000073          	ecall
 ret
    1300:	8082                	ret

0000000000001302 <munprotect>:
.global munprotect
munprotect:
 li a7, SYS_munprotect
    1302:	48dd                	li	a7,23
 ecall
    1304:	00000073          	ecall
 ret
    1308:	8082                	ret

000000000000130a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    130a:	1101                	addi	sp,sp,-32
    130c:	ec06                	sd	ra,24(sp)
    130e:	e822                	sd	s0,16(sp)
    1310:	1000                	addi	s0,sp,32
    1312:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1316:	4605                	li	a2,1
    1318:	fef40593          	addi	a1,s0,-17
    131c:	00000097          	auipc	ra,0x0
    1320:	f5e080e7          	jalr	-162(ra) # 127a <write>
}
    1324:	60e2                	ld	ra,24(sp)
    1326:	6442                	ld	s0,16(sp)
    1328:	6105                	addi	sp,sp,32
    132a:	8082                	ret

000000000000132c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    132c:	7139                	addi	sp,sp,-64
    132e:	fc06                	sd	ra,56(sp)
    1330:	f822                	sd	s0,48(sp)
    1332:	f426                	sd	s1,40(sp)
    1334:	f04a                	sd	s2,32(sp)
    1336:	ec4e                	sd	s3,24(sp)
    1338:	0080                	addi	s0,sp,64
    133a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    133c:	c299                	beqz	a3,1342 <printint+0x16>
    133e:	0805c863          	bltz	a1,13ce <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1342:	2581                	sext.w	a1,a1
  neg = 0;
    1344:	4881                	li	a7,0
    1346:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    134a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    134c:	2601                	sext.w	a2,a2
    134e:	00000517          	auipc	a0,0x0
    1352:	45a50513          	addi	a0,a0,1114 # 17a8 <digits>
    1356:	883a                	mv	a6,a4
    1358:	2705                	addiw	a4,a4,1
    135a:	02c5f7bb          	remuw	a5,a1,a2
    135e:	1782                	slli	a5,a5,0x20
    1360:	9381                	srli	a5,a5,0x20
    1362:	97aa                	add	a5,a5,a0
    1364:	0007c783          	lbu	a5,0(a5)
    1368:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    136c:	0005879b          	sext.w	a5,a1
    1370:	02c5d5bb          	divuw	a1,a1,a2
    1374:	0685                	addi	a3,a3,1
    1376:	fec7f0e3          	bgeu	a5,a2,1356 <printint+0x2a>
  if(neg)
    137a:	00088b63          	beqz	a7,1390 <printint+0x64>
    buf[i++] = '-';
    137e:	fd040793          	addi	a5,s0,-48
    1382:	973e                	add	a4,a4,a5
    1384:	02d00793          	li	a5,45
    1388:	fef70823          	sb	a5,-16(a4)
    138c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1390:	02e05863          	blez	a4,13c0 <printint+0x94>
    1394:	fc040793          	addi	a5,s0,-64
    1398:	00e78933          	add	s2,a5,a4
    139c:	fff78993          	addi	s3,a5,-1
    13a0:	99ba                	add	s3,s3,a4
    13a2:	377d                	addiw	a4,a4,-1
    13a4:	1702                	slli	a4,a4,0x20
    13a6:	9301                	srli	a4,a4,0x20
    13a8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    13ac:	fff94583          	lbu	a1,-1(s2)
    13b0:	8526                	mv	a0,s1
    13b2:	00000097          	auipc	ra,0x0
    13b6:	f58080e7          	jalr	-168(ra) # 130a <putc>
  while(--i >= 0)
    13ba:	197d                	addi	s2,s2,-1
    13bc:	ff3918e3          	bne	s2,s3,13ac <printint+0x80>
}
    13c0:	70e2                	ld	ra,56(sp)
    13c2:	7442                	ld	s0,48(sp)
    13c4:	74a2                	ld	s1,40(sp)
    13c6:	7902                	ld	s2,32(sp)
    13c8:	69e2                	ld	s3,24(sp)
    13ca:	6121                	addi	sp,sp,64
    13cc:	8082                	ret
    x = -xx;
    13ce:	40b005bb          	negw	a1,a1
    neg = 1;
    13d2:	4885                	li	a7,1
    x = -xx;
    13d4:	bf8d                	j	1346 <printint+0x1a>

00000000000013d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    13d6:	7119                	addi	sp,sp,-128
    13d8:	fc86                	sd	ra,120(sp)
    13da:	f8a2                	sd	s0,112(sp)
    13dc:	f4a6                	sd	s1,104(sp)
    13de:	f0ca                	sd	s2,96(sp)
    13e0:	ecce                	sd	s3,88(sp)
    13e2:	e8d2                	sd	s4,80(sp)
    13e4:	e4d6                	sd	s5,72(sp)
    13e6:	e0da                	sd	s6,64(sp)
    13e8:	fc5e                	sd	s7,56(sp)
    13ea:	f862                	sd	s8,48(sp)
    13ec:	f466                	sd	s9,40(sp)
    13ee:	f06a                	sd	s10,32(sp)
    13f0:	ec6e                	sd	s11,24(sp)
    13f2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    13f4:	0005c903          	lbu	s2,0(a1)
    13f8:	18090f63          	beqz	s2,1596 <vprintf+0x1c0>
    13fc:	8aaa                	mv	s5,a0
    13fe:	8b32                	mv	s6,a2
    1400:	00158493          	addi	s1,a1,1
  state = 0;
    1404:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1406:	02500a13          	li	s4,37
      if(c == 'd'){
    140a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    140e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    1412:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    1416:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    141a:	00000b97          	auipc	s7,0x0
    141e:	38eb8b93          	addi	s7,s7,910 # 17a8 <digits>
    1422:	a839                	j	1440 <vprintf+0x6a>
        putc(fd, c);
    1424:	85ca                	mv	a1,s2
    1426:	8556                	mv	a0,s5
    1428:	00000097          	auipc	ra,0x0
    142c:	ee2080e7          	jalr	-286(ra) # 130a <putc>
    1430:	a019                	j	1436 <vprintf+0x60>
    } else if(state == '%'){
    1432:	01498f63          	beq	s3,s4,1450 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    1436:	0485                	addi	s1,s1,1
    1438:	fff4c903          	lbu	s2,-1(s1)
    143c:	14090d63          	beqz	s2,1596 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    1440:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1444:	fe0997e3          	bnez	s3,1432 <vprintf+0x5c>
      if(c == '%'){
    1448:	fd479ee3          	bne	a5,s4,1424 <vprintf+0x4e>
        state = '%';
    144c:	89be                	mv	s3,a5
    144e:	b7e5                	j	1436 <vprintf+0x60>
      if(c == 'd'){
    1450:	05878063          	beq	a5,s8,1490 <vprintf+0xba>
      } else if(c == 'l') {
    1454:	05978c63          	beq	a5,s9,14ac <vprintf+0xd6>
      } else if(c == 'x') {
    1458:	07a78863          	beq	a5,s10,14c8 <vprintf+0xf2>
      } else if(c == 'p') {
    145c:	09b78463          	beq	a5,s11,14e4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    1460:	07300713          	li	a4,115
    1464:	0ce78663          	beq	a5,a4,1530 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1468:	06300713          	li	a4,99
    146c:	0ee78e63          	beq	a5,a4,1568 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    1470:	11478863          	beq	a5,s4,1580 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1474:	85d2                	mv	a1,s4
    1476:	8556                	mv	a0,s5
    1478:	00000097          	auipc	ra,0x0
    147c:	e92080e7          	jalr	-366(ra) # 130a <putc>
        putc(fd, c);
    1480:	85ca                	mv	a1,s2
    1482:	8556                	mv	a0,s5
    1484:	00000097          	auipc	ra,0x0
    1488:	e86080e7          	jalr	-378(ra) # 130a <putc>
      }
      state = 0;
    148c:	4981                	li	s3,0
    148e:	b765                	j	1436 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    1490:	008b0913          	addi	s2,s6,8
    1494:	4685                	li	a3,1
    1496:	4629                	li	a2,10
    1498:	000b2583          	lw	a1,0(s6)
    149c:	8556                	mv	a0,s5
    149e:	00000097          	auipc	ra,0x0
    14a2:	e8e080e7          	jalr	-370(ra) # 132c <printint>
    14a6:	8b4a                	mv	s6,s2
      state = 0;
    14a8:	4981                	li	s3,0
    14aa:	b771                	j	1436 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    14ac:	008b0913          	addi	s2,s6,8
    14b0:	4681                	li	a3,0
    14b2:	4629                	li	a2,10
    14b4:	000b2583          	lw	a1,0(s6)
    14b8:	8556                	mv	a0,s5
    14ba:	00000097          	auipc	ra,0x0
    14be:	e72080e7          	jalr	-398(ra) # 132c <printint>
    14c2:	8b4a                	mv	s6,s2
      state = 0;
    14c4:	4981                	li	s3,0
    14c6:	bf85                	j	1436 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    14c8:	008b0913          	addi	s2,s6,8
    14cc:	4681                	li	a3,0
    14ce:	4641                	li	a2,16
    14d0:	000b2583          	lw	a1,0(s6)
    14d4:	8556                	mv	a0,s5
    14d6:	00000097          	auipc	ra,0x0
    14da:	e56080e7          	jalr	-426(ra) # 132c <printint>
    14de:	8b4a                	mv	s6,s2
      state = 0;
    14e0:	4981                	li	s3,0
    14e2:	bf91                	j	1436 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    14e4:	008b0793          	addi	a5,s6,8
    14e8:	f8f43423          	sd	a5,-120(s0)
    14ec:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    14f0:	03000593          	li	a1,48
    14f4:	8556                	mv	a0,s5
    14f6:	00000097          	auipc	ra,0x0
    14fa:	e14080e7          	jalr	-492(ra) # 130a <putc>
  putc(fd, 'x');
    14fe:	85ea                	mv	a1,s10
    1500:	8556                	mv	a0,s5
    1502:	00000097          	auipc	ra,0x0
    1506:	e08080e7          	jalr	-504(ra) # 130a <putc>
    150a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    150c:	03c9d793          	srli	a5,s3,0x3c
    1510:	97de                	add	a5,a5,s7
    1512:	0007c583          	lbu	a1,0(a5)
    1516:	8556                	mv	a0,s5
    1518:	00000097          	auipc	ra,0x0
    151c:	df2080e7          	jalr	-526(ra) # 130a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1520:	0992                	slli	s3,s3,0x4
    1522:	397d                	addiw	s2,s2,-1
    1524:	fe0914e3          	bnez	s2,150c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    1528:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    152c:	4981                	li	s3,0
    152e:	b721                	j	1436 <vprintf+0x60>
        s = va_arg(ap, char*);
    1530:	008b0993          	addi	s3,s6,8
    1534:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    1538:	02090163          	beqz	s2,155a <vprintf+0x184>
        while(*s != 0){
    153c:	00094583          	lbu	a1,0(s2)
    1540:	c9a1                	beqz	a1,1590 <vprintf+0x1ba>
          putc(fd, *s);
    1542:	8556                	mv	a0,s5
    1544:	00000097          	auipc	ra,0x0
    1548:	dc6080e7          	jalr	-570(ra) # 130a <putc>
          s++;
    154c:	0905                	addi	s2,s2,1
        while(*s != 0){
    154e:	00094583          	lbu	a1,0(s2)
    1552:	f9e5                	bnez	a1,1542 <vprintf+0x16c>
        s = va_arg(ap, char*);
    1554:	8b4e                	mv	s6,s3
      state = 0;
    1556:	4981                	li	s3,0
    1558:	bdf9                	j	1436 <vprintf+0x60>
          s = "(null)";
    155a:	00000917          	auipc	s2,0x0
    155e:	24690913          	addi	s2,s2,582 # 17a0 <malloc+0x100>
        while(*s != 0){
    1562:	02800593          	li	a1,40
    1566:	bff1                	j	1542 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    1568:	008b0913          	addi	s2,s6,8
    156c:	000b4583          	lbu	a1,0(s6)
    1570:	8556                	mv	a0,s5
    1572:	00000097          	auipc	ra,0x0
    1576:	d98080e7          	jalr	-616(ra) # 130a <putc>
    157a:	8b4a                	mv	s6,s2
      state = 0;
    157c:	4981                	li	s3,0
    157e:	bd65                	j	1436 <vprintf+0x60>
        putc(fd, c);
    1580:	85d2                	mv	a1,s4
    1582:	8556                	mv	a0,s5
    1584:	00000097          	auipc	ra,0x0
    1588:	d86080e7          	jalr	-634(ra) # 130a <putc>
      state = 0;
    158c:	4981                	li	s3,0
    158e:	b565                	j	1436 <vprintf+0x60>
        s = va_arg(ap, char*);
    1590:	8b4e                	mv	s6,s3
      state = 0;
    1592:	4981                	li	s3,0
    1594:	b54d                	j	1436 <vprintf+0x60>
    }
  }
}
    1596:	70e6                	ld	ra,120(sp)
    1598:	7446                	ld	s0,112(sp)
    159a:	74a6                	ld	s1,104(sp)
    159c:	7906                	ld	s2,96(sp)
    159e:	69e6                	ld	s3,88(sp)
    15a0:	6a46                	ld	s4,80(sp)
    15a2:	6aa6                	ld	s5,72(sp)
    15a4:	6b06                	ld	s6,64(sp)
    15a6:	7be2                	ld	s7,56(sp)
    15a8:	7c42                	ld	s8,48(sp)
    15aa:	7ca2                	ld	s9,40(sp)
    15ac:	7d02                	ld	s10,32(sp)
    15ae:	6de2                	ld	s11,24(sp)
    15b0:	6109                	addi	sp,sp,128
    15b2:	8082                	ret

00000000000015b4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    15b4:	715d                	addi	sp,sp,-80
    15b6:	ec06                	sd	ra,24(sp)
    15b8:	e822                	sd	s0,16(sp)
    15ba:	1000                	addi	s0,sp,32
    15bc:	e010                	sd	a2,0(s0)
    15be:	e414                	sd	a3,8(s0)
    15c0:	e818                	sd	a4,16(s0)
    15c2:	ec1c                	sd	a5,24(s0)
    15c4:	03043023          	sd	a6,32(s0)
    15c8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    15cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    15d0:	8622                	mv	a2,s0
    15d2:	00000097          	auipc	ra,0x0
    15d6:	e04080e7          	jalr	-508(ra) # 13d6 <vprintf>
}
    15da:	60e2                	ld	ra,24(sp)
    15dc:	6442                	ld	s0,16(sp)
    15de:	6161                	addi	sp,sp,80
    15e0:	8082                	ret

00000000000015e2 <printf>:

void
printf(const char *fmt, ...)
{
    15e2:	711d                	addi	sp,sp,-96
    15e4:	ec06                	sd	ra,24(sp)
    15e6:	e822                	sd	s0,16(sp)
    15e8:	1000                	addi	s0,sp,32
    15ea:	e40c                	sd	a1,8(s0)
    15ec:	e810                	sd	a2,16(s0)
    15ee:	ec14                	sd	a3,24(s0)
    15f0:	f018                	sd	a4,32(s0)
    15f2:	f41c                	sd	a5,40(s0)
    15f4:	03043823          	sd	a6,48(s0)
    15f8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    15fc:	00840613          	addi	a2,s0,8
    1600:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1604:	85aa                	mv	a1,a0
    1606:	4505                	li	a0,1
    1608:	00000097          	auipc	ra,0x0
    160c:	dce080e7          	jalr	-562(ra) # 13d6 <vprintf>
}
    1610:	60e2                	ld	ra,24(sp)
    1612:	6442                	ld	s0,16(sp)
    1614:	6125                	addi	sp,sp,96
    1616:	8082                	ret

0000000000001618 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1618:	1141                	addi	sp,sp,-16
    161a:	e422                	sd	s0,8(sp)
    161c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    161e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1622:	00000797          	auipc	a5,0x0
    1626:	19e7b783          	ld	a5,414(a5) # 17c0 <freep>
    162a:	a805                	j	165a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    162c:	4618                	lw	a4,8(a2)
    162e:	9db9                	addw	a1,a1,a4
    1630:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1634:	6398                	ld	a4,0(a5)
    1636:	6318                	ld	a4,0(a4)
    1638:	fee53823          	sd	a4,-16(a0)
    163c:	a091                	j	1680 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    163e:	ff852703          	lw	a4,-8(a0)
    1642:	9e39                	addw	a2,a2,a4
    1644:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1646:	ff053703          	ld	a4,-16(a0)
    164a:	e398                	sd	a4,0(a5)
    164c:	a099                	j	1692 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    164e:	6398                	ld	a4,0(a5)
    1650:	00e7e463          	bltu	a5,a4,1658 <free+0x40>
    1654:	00e6ea63          	bltu	a3,a4,1668 <free+0x50>
{
    1658:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    165a:	fed7fae3          	bgeu	a5,a3,164e <free+0x36>
    165e:	6398                	ld	a4,0(a5)
    1660:	00e6e463          	bltu	a3,a4,1668 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1664:	fee7eae3          	bltu	a5,a4,1658 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1668:	ff852583          	lw	a1,-8(a0)
    166c:	6390                	ld	a2,0(a5)
    166e:	02059713          	slli	a4,a1,0x20
    1672:	9301                	srli	a4,a4,0x20
    1674:	0712                	slli	a4,a4,0x4
    1676:	9736                	add	a4,a4,a3
    1678:	fae60ae3          	beq	a2,a4,162c <free+0x14>
    bp->s.ptr = p->s.ptr;
    167c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1680:	4790                	lw	a2,8(a5)
    1682:	02061713          	slli	a4,a2,0x20
    1686:	9301                	srli	a4,a4,0x20
    1688:	0712                	slli	a4,a4,0x4
    168a:	973e                	add	a4,a4,a5
    168c:	fae689e3          	beq	a3,a4,163e <free+0x26>
  } else
    p->s.ptr = bp;
    1690:	e394                	sd	a3,0(a5)
  freep = p;
    1692:	00000717          	auipc	a4,0x0
    1696:	12f73723          	sd	a5,302(a4) # 17c0 <freep>
}
    169a:	6422                	ld	s0,8(sp)
    169c:	0141                	addi	sp,sp,16
    169e:	8082                	ret

00000000000016a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    16a0:	7139                	addi	sp,sp,-64
    16a2:	fc06                	sd	ra,56(sp)
    16a4:	f822                	sd	s0,48(sp)
    16a6:	f426                	sd	s1,40(sp)
    16a8:	f04a                	sd	s2,32(sp)
    16aa:	ec4e                	sd	s3,24(sp)
    16ac:	e852                	sd	s4,16(sp)
    16ae:	e456                	sd	s5,8(sp)
    16b0:	e05a                	sd	s6,0(sp)
    16b2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16b4:	02051493          	slli	s1,a0,0x20
    16b8:	9081                	srli	s1,s1,0x20
    16ba:	04bd                	addi	s1,s1,15
    16bc:	8091                	srli	s1,s1,0x4
    16be:	0014899b          	addiw	s3,s1,1
    16c2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    16c4:	00000517          	auipc	a0,0x0
    16c8:	0fc53503          	ld	a0,252(a0) # 17c0 <freep>
    16cc:	c515                	beqz	a0,16f8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    16d0:	4798                	lw	a4,8(a5)
    16d2:	02977f63          	bgeu	a4,s1,1710 <malloc+0x70>
    16d6:	8a4e                	mv	s4,s3
    16d8:	0009871b          	sext.w	a4,s3
    16dc:	6685                	lui	a3,0x1
    16de:	00d77363          	bgeu	a4,a3,16e4 <malloc+0x44>
    16e2:	6a05                	lui	s4,0x1
    16e4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    16e8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    16ec:	00000917          	auipc	s2,0x0
    16f0:	0d490913          	addi	s2,s2,212 # 17c0 <freep>
  if(p == (char*)-1)
    16f4:	5afd                	li	s5,-1
    16f6:	a88d                	j	1768 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    16f8:	00000797          	auipc	a5,0x0
    16fc:	0d078793          	addi	a5,a5,208 # 17c8 <base>
    1700:	00000717          	auipc	a4,0x0
    1704:	0cf73023          	sd	a5,192(a4) # 17c0 <freep>
    1708:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    170a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    170e:	b7e1                	j	16d6 <malloc+0x36>
      if(p->s.size == nunits)
    1710:	02e48b63          	beq	s1,a4,1746 <malloc+0xa6>
        p->s.size -= nunits;
    1714:	4137073b          	subw	a4,a4,s3
    1718:	c798                	sw	a4,8(a5)
        p += p->s.size;
    171a:	1702                	slli	a4,a4,0x20
    171c:	9301                	srli	a4,a4,0x20
    171e:	0712                	slli	a4,a4,0x4
    1720:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1722:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1726:	00000717          	auipc	a4,0x0
    172a:	08a73d23          	sd	a0,154(a4) # 17c0 <freep>
      return (void*)(p + 1);
    172e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1732:	70e2                	ld	ra,56(sp)
    1734:	7442                	ld	s0,48(sp)
    1736:	74a2                	ld	s1,40(sp)
    1738:	7902                	ld	s2,32(sp)
    173a:	69e2                	ld	s3,24(sp)
    173c:	6a42                	ld	s4,16(sp)
    173e:	6aa2                	ld	s5,8(sp)
    1740:	6b02                	ld	s6,0(sp)
    1742:	6121                	addi	sp,sp,64
    1744:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1746:	6398                	ld	a4,0(a5)
    1748:	e118                	sd	a4,0(a0)
    174a:	bff1                	j	1726 <malloc+0x86>
  hp->s.size = nu;
    174c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1750:	0541                	addi	a0,a0,16
    1752:	00000097          	auipc	ra,0x0
    1756:	ec6080e7          	jalr	-314(ra) # 1618 <free>
  return freep;
    175a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    175e:	d971                	beqz	a0,1732 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1760:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1762:	4798                	lw	a4,8(a5)
    1764:	fa9776e3          	bgeu	a4,s1,1710 <malloc+0x70>
    if(p == freep)
    1768:	00093703          	ld	a4,0(s2)
    176c:	853e                	mv	a0,a5
    176e:	fef719e3          	bne	a4,a5,1760 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    1772:	8552                	mv	a0,s4
    1774:	00000097          	auipc	ra,0x0
    1778:	b6e080e7          	jalr	-1170(ra) # 12e2 <sbrk>
  if(p == (char*)-1)
    177c:	fd5518e3          	bne	a0,s5,174c <malloc+0xac>
        return 0;
    1780:	4501                	li	a0,0
    1782:	bf45                	j	1732 <malloc+0x92>
